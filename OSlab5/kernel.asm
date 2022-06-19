
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
80100028:	bc 80 cf 10 80       	mov    $0x8010cf80,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb b4 cf 10 80       	mov    $0x8010cfb4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 78 10 80       	push   $0x80107840
80100055:	68 80 cf 10 80       	push   $0x8010cf80
8010005a:	e8 81 45 00 00       	call   801045e0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 7c 16 11 80       	mov    $0x8011167c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 cc 16 11 80 7c 	movl   $0x8011167c,0x801116cc
8010006e:	16 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 d0 16 11 80 7c 	movl   $0x8011167c,0x801116d0
80100078:	16 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 7c 16 11 80 	movl   $0x8011167c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 78 10 80       	push   $0x80107847
80100097:	50                   	push   %eax
80100098:	e8 03 44 00 00       	call   801044a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 d0 16 11 80       	mov    0x801116d0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d d0 16 11 80    	mov    %ebx,0x801116d0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 20 14 11 80    	cmp    $0x80111420,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 80 cf 10 80       	push   $0x8010cf80
801000e8:	e8 73 46 00 00       	call   80104760 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d d0 16 11 80    	mov    0x801116d0,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 7c 16 11 80    	cmp    $0x8011167c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 7c 16 11 80    	cmp    $0x8011167c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d cc 16 11 80    	mov    0x801116cc,%ebx
80100126:	81 fb 7c 16 11 80    	cmp    $0x8011167c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 7c 16 11 80    	cmp    $0x8011167c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 80 cf 10 80       	push   $0x8010cf80
80100162:	e8 b9 46 00 00       	call   80104820 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 43 00 00       	call   801044e0 <acquiresleep>
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
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 78 10 80       	push   $0x8010784e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 b9 43 00 00       	call   80104580 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 78 10 80       	push   $0x8010785f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 78 43 00 00       	call   80104580 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 28 43 00 00       	call   80104540 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 80 cf 10 80 	movl   $0x8010cf80,(%esp)
8010021f:	e8 3c 45 00 00       	call   80104760 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 d0 16 11 80       	mov    0x801116d0,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 7c 16 11 80 	movl   $0x8011167c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 d0 16 11 80       	mov    0x801116d0,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d d0 16 11 80    	mov    %ebx,0x801116d0
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 80 cf 10 80 	movl   $0x8010cf80,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 ab 45 00 00       	jmp    80104820 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 78 10 80       	push   $0x80107866
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 aa 44 00 00       	call   80104760 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 60 19 11 80       	mov    0x80111960,%eax
801002cb:	3b 05 64 19 11 80    	cmp    0x80111964,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 60 19 11 80       	push   $0x80111960
801002e5:	e8 46 3d 00 00       	call   80104030 <sleep>
    while(input.r == input.w){
801002ea:	a1 60 19 11 80       	mov    0x80111960,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 64 19 11 80    	cmp    0x80111964,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 36 00 00       	call   801039f0 <myproc>
801002ff:	8b 48 28             	mov    0x28(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 0d 45 00 00       	call   80104820 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 60 19 11 80    	mov    %edx,0x80111960
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a e0 18 11 80 	movsbl -0x7feee720(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 b6 44 00 00       	call   80104820 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 60 19 11 80       	mov    %eax,0x80111960
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 78 10 80       	push   $0x8010786d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 a7 81 10 80 	movl   $0x801081a7,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 1f 42 00 00       	call   80104600 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 78 10 80       	push   $0x80107881
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 f1 5b 00 00       	call   80106020 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 06 5b 00 00       	call   80106020 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 5a 00 00       	call   80106020 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 5a 00 00       	call   80106020 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 aa 43 00 00       	call   80104910 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 f5 42 00 00       	call   80104870 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 78 10 80       	push   $0x80107885
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 78 10 80 	movzbl -0x7fef8750(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 fc 40 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 84 41 00 00       	call   80104820 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 78 10 80       	mov    $0x80107898,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 9e 3f 00 00       	call   80104760 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 f3 3f 00 00       	call   80104820 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 78 10 80       	push   $0x8010789f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 e4 3e 00 00       	call   80104760 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 68 19 11 80       	mov    0x80111968,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 60 19 11 80    	sub    0x80111960,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d 68 19 11 80    	mov    %ecx,0x80111968
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 e0 18 11 80    	mov    %bl,-0x7feee720(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 60 19 11 80       	mov    0x80111960,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 68 19 11 80    	cmp    %eax,0x80111968
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 68 19 11 80       	mov    0x80111968,%eax
80100925:	39 05 64 19 11 80    	cmp    %eax,0x80111964
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba e0 18 11 80 0a 	cmpb   $0xa,-0x7feee720(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 68 19 11 80       	mov    %eax,0x80111968
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 68 19 11 80       	mov    0x80111968,%eax
8010096f:	3b 05 64 19 11 80    	cmp    0x80111964,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 68 19 11 80       	mov    0x80111968,%eax
80100985:	3b 05 64 19 11 80    	cmp    0x80111964,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 68 19 11 80       	mov    %eax,0x80111968
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 4c 3e 00 00       	call   80104820 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 e0 18 11 80 0a 	movb   $0xa,-0x7feee720(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 bc 39 00 00       	jmp    801043c0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 68 19 11 80       	mov    0x80111968,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 64 19 11 80       	mov    %eax,0x80111964
          wakeup(&input.r);
80100a1b:	68 60 19 11 80       	push   $0x80111960
80100a20:	e8 cb 37 00 00       	call   801041f0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 78 10 80       	push   $0x801078a8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 97 3b 00 00       	call   801045e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 2c 23 11 80 40 	movl   $0x80100640,0x8011232c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 28 23 11 80 90 	movl   $0x80100290,0x80112328
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 5b 2f 00 00       	call   801039f0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 f0 22 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 18 23 00 00       	call   80102e00 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 7f 66 00 00       	call   80107190 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = PGSIZE;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x1000,-0x110(%ebp)
80100b36:	10 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 38 64 00 00       	call   80106fb0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 32 63 00 00       	call   80106ee0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 20 65 00 00       	call   80107110 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 da 21 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 79 63 00 00       	call   80106fb0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 d8 65 00 00       	call   80107230 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 c8 3d 00 00       	call   80104a70 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 b5 3d 00 00       	call   80104a70 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 d4 66 00 00       	call   801073a0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 64 00 00       	call   80107110 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 68 66 00 00       	call   801073a0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 70             	add    $0x70,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 ba 3c 00 00       	call   80104a30 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 1c             	mov    0x1c(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 ae 5f 00 00       	call   80106d50 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 66 63 00 00       	call   80107110 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 47 20 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 78 10 80       	push   $0x801078c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	bf 00 10 00 00       	mov    $0x1000,%edi
80100dd8:	be 00 30 00 00       	mov    $0x3000,%esi
80100ddd:	e9 36 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de2:	66 90                	xchg   %ax,%ax
80100de4:	66 90                	xchg   %ax,%ax
80100de6:	66 90                	xchg   %ax,%ax
80100de8:	66 90                	xchg   %ax,%ax
80100dea:	66 90                	xchg   %ax,%ax
80100dec:	66 90                	xchg   %ax,%ax
80100dee:	66 90                	xchg   %ax,%ax

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 cd 78 10 80       	push   $0x801078cd
80100dff:	68 80 19 11 80       	push   $0x80111980
80100e04:	e8 d7 37 00 00       	call   801045e0 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb b4 19 11 80       	mov    $0x801119b4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 80 19 11 80       	push   $0x80111980
80100e25:	e8 36 39 00 00       	call   80104760 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 14 23 11 80    	cmp    $0x80112314,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 80 19 11 80       	push   $0x80111980
80100e51:	e8 ca 39 00 00       	call   80104820 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 80 19 11 80       	push   $0x80111980
80100e6a:	e8 b1 39 00 00       	call   80104820 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 80 19 11 80       	push   $0x80111980
80100e93:	e8 c8 38 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 80 19 11 80       	push   $0x80111980
80100eb0:	e8 6b 39 00 00       	call   80104820 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 d4 78 10 80       	push   $0x801078d4
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 80 19 11 80       	push   $0x80111980
80100ee5:	e8 76 38 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 80 19 11 80       	push   $0x80111980
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 fb 38 00 00       	call   80104820 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 80 19 11 80 	movl   $0x80111980,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 cd 38 00 00       	jmp    80104820 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 33 1e 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 89 1e 00 00       	jmp    80102e00 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 d2 25 00 00       	call   80103560 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 dc 78 10 80       	push   $0x801078dc
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 86 26 00 00       	jmp    80103700 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 e6 78 10 80       	push   $0x801078e6
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 fa 1c 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 61 1c 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 9a 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 ef 78 10 80       	push   $0x801078ef
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 5a 24 00 00       	jmp    80103600 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 f5 78 10 80       	push   $0x801078f5
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 98 23 11 80    	add    0x80112398,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 5e 1d 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 ff 78 10 80       	push   $0x801078ff
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d 80 23 11 80    	mov    0x80112380,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 98 23 11 80    	add    0x80112398,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 80 23 11 80       	mov    0x80112380,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 80 23 11 80    	cmp    %eax,0x80112380
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 12 79 10 80       	push   $0x80107912
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 6e 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 46 35 00 00       	call   80104870 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 3e 1c 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb d4 23 11 80       	mov    $0x801123d4,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 a0 23 11 80       	push   $0x801123a0
8010136a:	e8 f1 33 00 00       	call   80104760 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb f4 3f 11 80    	cmp    $0x80113ff4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb f4 3f 11 80    	cmp    $0x80113ff4,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 a0 23 11 80       	push   $0x801123a0
801013d7:	e8 44 34 00 00       	call   80104820 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 a0 23 11 80       	push   $0x801123a0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 16 34 00 00       	call   80104820 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb f4 3f 11 80    	cmp    $0x80113ff4,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 28 79 10 80       	push   $0x80107928
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 b6 1a 00 00       	call   80102f70 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 38 79 10 80       	push   $0x80107938
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 d6 33 00 00       	call   80104910 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb e0 23 11 80       	mov    $0x801123e0,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 4b 79 10 80       	push   $0x8010794b
80101565:	68 a0 23 11 80       	push   $0x801123a0
8010156a:	e8 71 30 00 00       	call   801045e0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 52 79 10 80       	push   $0x80107952
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 14 2f 00 00       	call   801044a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 00 40 11 80    	cmp    $0x80114000,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 80 23 11 80       	push   $0x80112380
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 98 23 11 80    	pushl  0x80112398
801015ad:	ff 35 94 23 11 80    	pushl  0x80112394
801015b3:	ff 35 90 23 11 80    	pushl  0x80112390
801015b9:	ff 35 8c 23 11 80    	pushl  0x8011238c
801015bf:	ff 35 88 23 11 80    	pushl  0x80112388
801015c5:	ff 35 84 23 11 80    	pushl  0x80112384
801015cb:	ff 35 80 23 11 80    	pushl  0x80112380
801015d1:	68 b8 79 10 80       	push   $0x801079b8
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d 88 23 11 80 01 	cmpl   $0x1,0x80112388
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d 88 23 11 80    	cmp    0x80112388,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 94 23 11 80    	add    0x80112394,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 fd 31 00 00       	call   80104870 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 eb 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 58 79 10 80       	push   $0x80107958
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 94 23 11 80    	add    0x80112394,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 f6 31 00 00       	call   80104910 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 4e 18 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 a0 23 11 80       	push   $0x801123a0
80101753:	e8 08 30 00 00       	call   80104760 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 a0 23 11 80 	movl   $0x801123a0,(%esp)
80101763:	e8 b8 30 00 00       	call   80104820 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 45 2d 00 00       	call   801044e0 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 94 23 11 80    	add    0x80112394,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 03 31 00 00       	call   80104910 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 70 79 10 80       	push   $0x80107970
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 6a 79 10 80       	push   $0x8010796a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 14 2d 00 00       	call   80104580 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 b8 2c 00 00       	jmp    80104540 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 7f 79 10 80       	push   $0x8010797f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 27 2c 00 00       	call   801044e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 6d 2c 00 00       	call   80104540 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 a0 23 11 80 	movl   $0x801123a0,(%esp)
801018da:	e8 81 2e 00 00       	call   80104760 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 a0 23 11 80 	movl   $0x801123a0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 27 2f 00 00       	jmp    80104820 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 a0 23 11 80       	push   $0x801123a0
80101908:	e8 53 2e 00 00       	call   80104760 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 a0 23 11 80 	movl   $0x801123a0,(%esp)
80101917:	e8 04 2f 00 00       	call   80104820 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 f4 2d 00 00       	call   80104910 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 20 23 11 80 	mov    -0x7feedce0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 f8 2c 00 00       	call   80104910 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 50 13 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 24 23 11 80 	mov    -0x7feedcdc(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 c9 2c 00 00       	call   80104980 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 66 2c 00 00       	call   80104980 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 99 79 10 80       	push   $0x80107999
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 87 79 10 80       	push   $0x80107987
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 51 1c 00 00       	call   801039f0 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 a0 23 11 80       	push   $0x801123a0
80101dac:	e8 af 29 00 00       	call   80104760 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 a0 23 11 80 	movl   $0x801123a0,(%esp)
80101dbc:	e8 5f 2a 00 00       	call   80104820 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 e4 2a 00 00       	call   80104910 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 58 2a 00 00       	call   80104910 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 e6 29 00 00       	call   801049d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 a8 79 10 80       	push   $0x801079a8
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 8e 7f 10 80       	push   $0x80107f8e
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 14 7a 10 80       	push   $0x80107a14
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 0b 7a 10 80       	push   $0x80107a0b
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 26 7a 10 80       	push   $0x80107a26
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 67 24 00 00       	call   801045e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 c0 46 11 80       	mov    0x801146c0,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 b5 10 80       	push   $0x8010b580
80102202:	e8 59 25 00 00       	call   80104760 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 8e 1f 00 00       	call   801041f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 b5 10 80       	push   $0x8010b580
8010227b:	e8 a0 25 00 00       	call   80104820 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 d9 22 00 00       	call   80104580 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 b5 10 80       	push   $0x8010b580
801022dc:	e8 7f 24 00 00       	call   80104760 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 b5 10 80       	push   $0x8010b580
80102328:	53                   	push   %ebx
80102329:	e8 02 1d 00 00       	call   80104030 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 d5 24 00 00       	jmp    80104820 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 55 7a 10 80       	push   $0x80107a55
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 40 7a 10 80       	push   $0x80107a40
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 2a 7a 10 80       	push   $0x80107a2a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 f4 3f 11 80 00 	movl   $0xfec00000,0x80113ff4
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 f4 3f 11 80    	mov    0x80113ff4,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 20 41 11 80 	movzbl 0x80114120,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 74 7a 10 80       	push   $0x80107a74
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d f4 3f 11 80    	mov    0x80113ff4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 f4 3f 11 80       	mov    0x80113ff4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb 68 71 11 80    	cmp    $0x80117168,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 b5 23 00 00       	call   80104870 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 34 40 11 80    	mov    0x80114034,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 38 40 11 80       	mov    0x80114038,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 34 40 11 80       	mov    0x80114034,%eax
  kmem.freelist = r;
801024d4:	89 1d 38 40 11 80    	mov    %ebx,0x80114038
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 00 40 11 80       	push   $0x80114000
801024f0:	e8 6b 22 00 00       	call   80104760 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 00 40 11 80 	movl   $0x80114000,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 10 23 00 00       	jmp    80104820 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 a6 7a 10 80       	push   $0x80107aa6
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 ac 7a 10 80       	push   $0x80107aac
80102584:	68 00 40 11 80       	push   $0x80114000
80102589:	e8 52 20 00 00       	call   801045e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 34 40 11 80 00 	movl   $0x0,0x80114034
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 34 40 11 80 01 	movl   $0x1,0x80114034
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 34 40 11 80       	mov    0x80114034,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 38 40 11 80       	mov    0x80114038,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 38 40 11 80    	mov    %edx,0x80114038
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 00 40 11 80       	push   $0x80114000
80102673:	e8 e8 20 00 00       	call   80104760 <acquire>
  r = kmem.freelist;
80102678:	a1 38 40 11 80       	mov    0x80114038,%eax
  if(r)
8010267d:	8b 15 34 40 11 80    	mov    0x80114034,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 38 40 11 80    	mov    %ecx,0x80114038
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 00 40 11 80       	push   $0x80114000
801026a1:	e8 7a 21 00 00       	call   80104820 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 e0 7a 10 80 	movzbl -0x7fef8520(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 3c 40 11 80       	mov    0x8011403c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 3c 40 11 80       	mov    0x8011403c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 3c 40 11 80       	mov    0x8011403c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 3c 40 11 80       	mov    0x8011403c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 ec 1d 00 00       	call   801048c0 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <unixtime>:

// This is not the "real" UNIX time as it makes many
// simplifying assumptions -- no leap years, months
// that are all the same length (!)
unsigned long unixtime(void) {
80102ba0:	f3 0f 1e fb          	endbr32 
80102ba4:	55                   	push   %ebp
80102ba5:	89 e5                	mov    %esp,%ebp
80102ba7:	83 ec 34             	sub    $0x34,%esp
  struct rtcdate t;
  cmostime(&t);
80102baa:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102bad:	50                   	push   %eax
80102bae:	e8 ed fd ff ff       	call   801029a0 <cmostime>
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
80102bb3:	69 55 f4 80 33 e1 01 	imul   $0x1e13380,-0xc(%ebp),%edx
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
         (t.hour * 60 * 60) +
         (t.minute * 60) +
80102bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102bbd:	8d 84 02 00 b1 01 89 	lea    -0x76fe4f00(%edx,%eax,1),%eax
         (t.month * 30 * 24 * 60 * 60) +
80102bc4:	69 55 f0 00 8d 27 00 	imul   $0x278d00,-0x10(%ebp),%edx
         (t.minute * 60) +
80102bcb:	01 d0                	add    %edx,%eax
         (t.day * 24 * 60 * 60) +
80102bcd:	69 55 ec 80 51 01 00 	imul   $0x15180,-0x14(%ebp),%edx
         (t.minute * 60) +
80102bd4:	01 d0                	add    %edx,%eax
         (t.hour * 60 * 60) +
80102bd6:	69 55 e8 10 0e 00 00 	imul   $0xe10,-0x18(%ebp),%edx
         (t.minute * 60) +
80102bdd:	01 d0                	add    %edx,%eax
80102bdf:	6b 55 e4 3c          	imul   $0x3c,-0x1c(%ebp),%edx
         (t.second);
80102be3:	c9                   	leave  
         (t.minute * 60) +
80102be4:	01 d0                	add    %edx,%eax
80102be6:	c3                   	ret    
80102be7:	66 90                	xchg   %ax,%ax
80102be9:	66 90                	xchg   %ax,%ax
80102beb:	66 90                	xchg   %ax,%ax
80102bed:	66 90                	xchg   %ax,%ax
80102bef:	90                   	nop

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d 88 40 11 80    	mov    0x80114088,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 74 40 11 80       	mov    0x80114074,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 84 40 11 80    	pushl  0x80114084
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd 8c 40 11 80 	pushl  -0x7feebf74(,%edi,4)
80102c34:	ff 35 84 40 11 80    	pushl  0x80114084
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 b7 1c 00 00       	call   80104910 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d 88 40 11 80    	cmp    %edi,0x80114088
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret    
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 74 40 11 80    	pushl  0x80114074
80102c9d:	ff 35 84 40 11 80    	pushl  0x80114084
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 88 40 11 80       	mov    0x80114088,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 8c 40 11 80 	mov    -0x7feebf74(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop

80102cf0 <initlog>:
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	53                   	push   %ebx
80102cf8:	83 ec 2c             	sub    $0x2c,%esp
80102cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfe:	68 e0 7c 10 80       	push   $0x80107ce0
80102d03:	68 40 40 11 80       	push   $0x80114040
80102d08:	e8 d3 18 00 00       	call   801045e0 <initlock>
  readsb(dev, &sb);
80102d0d:	58                   	pop    %eax
80102d0e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d11:	5a                   	pop    %edx
80102d12:	50                   	push   %eax
80102d13:	53                   	push   %ebx
80102d14:	e8 f7 e7 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d1c:	59                   	pop    %ecx
  log.dev = dev;
80102d1d:	89 1d 84 40 11 80    	mov    %ebx,0x80114084
  log.size = sb.nlog;
80102d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d26:	a3 74 40 11 80       	mov    %eax,0x80114074
  log.size = sb.nlog;
80102d2b:	89 15 78 40 11 80    	mov    %edx,0x80114078
  struct buf *buf = bread(log.dev, log.start);
80102d31:	5a                   	pop    %edx
80102d32:	50                   	push   %eax
80102d33:	53                   	push   %ebx
80102d34:	e8 97 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d3c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d3f:	89 0d 88 40 11 80    	mov    %ecx,0x80114088
  for (i = 0; i < log.lh.n; i++) {
80102d45:	85 c9                	test   %ecx,%ecx
80102d47:	7e 19                	jle    80102d62 <initlog+0x72>
80102d49:	31 d2                	xor    %edx,%edx
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d50:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d54:	89 1c 95 8c 40 11 80 	mov    %ebx,-0x7feebf74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d1                	cmp    %edx,%ecx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 88 40 11 80 00 	movl   $0x0,0x80114088
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
80102d95:	89 e5                	mov    %esp,%ebp
80102d97:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d9a:	68 40 40 11 80       	push   $0x80114040
80102d9f:	e8 bc 19 00 00       	call   80104760 <acquire>
80102da4:	83 c4 10             	add    $0x10,%esp
80102da7:	eb 1c                	jmp    80102dc5 <begin_op+0x35>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db0:	83 ec 08             	sub    $0x8,%esp
80102db3:	68 40 40 11 80       	push   $0x80114040
80102db8:	68 40 40 11 80       	push   $0x80114040
80102dbd:	e8 6e 12 00 00       	call   80104030 <sleep>
80102dc2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dc5:	a1 80 40 11 80       	mov    0x80114080,%eax
80102dca:	85 c0                	test   %eax,%eax
80102dcc:	75 e2                	jne    80102db0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dce:	a1 7c 40 11 80       	mov    0x8011407c,%eax
80102dd3:	8b 15 88 40 11 80    	mov    0x80114088,%edx
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ddf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102de2:	83 fa 1e             	cmp    $0x1e,%edx
80102de5:	7f c9                	jg     80102db0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102de7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dea:	a3 7c 40 11 80       	mov    %eax,0x8011407c
      release(&log.lock);
80102def:	68 40 40 11 80       	push   $0x80114040
80102df4:	e8 27 1a 00 00       	call   80104820 <release>
      break;
    }
  }
}
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	c9                   	leave  
80102dfd:	c3                   	ret    
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	f3 0f 1e fb          	endbr32 
80102e04:	55                   	push   %ebp
80102e05:	89 e5                	mov    %esp,%ebp
80102e07:	57                   	push   %edi
80102e08:	56                   	push   %esi
80102e09:	53                   	push   %ebx
80102e0a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e0d:	68 40 40 11 80       	push   $0x80114040
80102e12:	e8 49 19 00 00       	call   80104760 <acquire>
  log.outstanding -= 1;
80102e17:	a1 7c 40 11 80       	mov    0x8011407c,%eax
  if(log.committing)
80102e1c:	8b 35 80 40 11 80    	mov    0x80114080,%esi
80102e22:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e25:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e28:	89 1d 7c 40 11 80    	mov    %ebx,0x8011407c
  if(log.committing)
80102e2e:	85 f6                	test   %esi,%esi
80102e30:	0f 85 1e 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e36:	85 db                	test   %ebx,%ebx
80102e38:	0f 85 f2 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3e:	c7 05 80 40 11 80 01 	movl   $0x1,0x80114080
80102e45:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	68 40 40 11 80       	push   $0x80114040
80102e50:	e8 cb 19 00 00       	call   80104820 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e55:	8b 0d 88 40 11 80    	mov    0x80114088,%ecx
80102e5b:	83 c4 10             	add    $0x10,%esp
80102e5e:	85 c9                	test   %ecx,%ecx
80102e60:	7f 3e                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	68 40 40 11 80       	push   $0x80114040
80102e6a:	e8 f1 18 00 00       	call   80104760 <acquire>
    wakeup(&log);
80102e6f:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
    log.committing = 0;
80102e76:	c7 05 80 40 11 80 00 	movl   $0x0,0x80114080
80102e7d:	00 00 00 
    wakeup(&log);
80102e80:	e8 6b 13 00 00       	call   801041f0 <wakeup>
    release(&log.lock);
80102e85:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80102e8c:	e8 8f 19 00 00       	call   80104820 <release>
80102e91:	83 c4 10             	add    $0x10,%esp
}
80102e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e97:	5b                   	pop    %ebx
80102e98:	5e                   	pop    %esi
80102e99:	5f                   	pop    %edi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 74 40 11 80       	mov    0x80114074,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 84 40 11 80    	pushl  0x80114084
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d 8c 40 11 80 	pushl  -0x7feebf74(,%ebx,4)
80102ec4:	ff 35 84 40 11 80    	pushl  0x80114084
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 27 1a 00 00       	call   80104910 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d 88 40 11 80    	cmp    0x80114088,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 88 40 11 80 00 	movl   $0x0,0x80114088
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 38 ff ff ff       	jmp    80102e62 <end_op+0x62>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 40 40 11 80       	push   $0x80114040
80102f38:	e8 b3 12 00 00       	call   801041f0 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80102f44:	e8 d7 18 00 00       	call   80104820 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 e4 7c 10 80       	push   $0x80107ce4
80102f5c:	e8 2f d4 ff ff       	call   80100390 <panic>
80102f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	f3 0f 1e fb          	endbr32 
80102f74:	55                   	push   %ebp
80102f75:	89 e5                	mov    %esp,%ebp
80102f77:	53                   	push   %ebx
80102f78:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f7b:	8b 15 88 40 11 80    	mov    0x80114088,%edx
{
80102f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f84:	83 fa 1d             	cmp    $0x1d,%edx
80102f87:	0f 8f 91 00 00 00    	jg     8010301e <log_write+0xae>
80102f8d:	a1 78 40 11 80       	mov    0x80114078,%eax
80102f92:	83 e8 01             	sub    $0x1,%eax
80102f95:	39 c2                	cmp    %eax,%edx
80102f97:	0f 8d 81 00 00 00    	jge    8010301e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f9d:	a1 7c 40 11 80       	mov    0x8011407c,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	0f 8e 81 00 00 00    	jle    8010302b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102faa:	83 ec 0c             	sub    $0xc,%esp
80102fad:	68 40 40 11 80       	push   $0x80114040
80102fb2:	e8 a9 17 00 00       	call   80104760 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fb7:	8b 15 88 40 11 80    	mov    0x80114088,%edx
80102fbd:	83 c4 10             	add    $0x10,%esp
80102fc0:	85 d2                	test   %edx,%edx
80102fc2:	7e 4e                	jle    80103012 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fc7:	31 c0                	xor    %eax,%eax
80102fc9:	eb 0c                	jmp    80102fd7 <log_write+0x67>
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
80102fd0:	83 c0 01             	add    $0x1,%eax
80102fd3:	39 c2                	cmp    %eax,%edx
80102fd5:	74 29                	je     80103000 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd7:	39 0c 85 8c 40 11 80 	cmp    %ecx,-0x7feebf74(,%eax,4)
80102fde:	75 f0                	jne    80102fd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 85 8c 40 11 80 	mov    %ecx,-0x7feebf74(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fe7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fed:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
80102ff4:	c9                   	leave  
  release(&log.lock);
80102ff5:	e9 26 18 00 00       	jmp    80104820 <release>
80102ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103000:	89 0c 95 8c 40 11 80 	mov    %ecx,-0x7feebf74(,%edx,4)
    log.lh.n++;
80103007:	83 c2 01             	add    $0x1,%edx
8010300a:	89 15 88 40 11 80    	mov    %edx,0x80114088
80103010:	eb d5                	jmp    80102fe7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103012:	8b 43 08             	mov    0x8(%ebx),%eax
80103015:	a3 8c 40 11 80       	mov    %eax,0x8011408c
  if (i == log.lh.n)
8010301a:	75 cb                	jne    80102fe7 <log_write+0x77>
8010301c:	eb e9                	jmp    80103007 <log_write+0x97>
    panic("too big a transaction");
8010301e:	83 ec 0c             	sub    $0xc,%esp
80103021:	68 f3 7c 10 80       	push   $0x80107cf3
80103026:	e8 65 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010302b:	83 ec 0c             	sub    $0xc,%esp
8010302e:	68 09 7d 10 80       	push   $0x80107d09
80103033:	e8 58 d3 ff ff       	call   80100390 <panic>
80103038:	66 90                	xchg   %ax,%ax
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 84 09 00 00       	call   801039d0 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 7d 09 00 00       	call   801039d0 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 24 7d 10 80       	push   $0x80107d24
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 f9 2b 00 00       	call   80105c60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 f4 08 00 00       	call   80103960 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 81 0c 00 00       	call   80103d00 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	f3 0f 1e fb          	endbr32 
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010308a:	e8 a1 3c 00 00       	call   80106d30 <switchkvm>
  seginit();
8010308f:	e8 0c 3c 00 00       	call   80106ca0 <seginit>
  lapicinit();
80103094:	e8 17 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103099:	e8 a2 ff ff ff       	call   80103040 <mpmain>
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	f3 0f 1e fb          	endbr32 
801030a4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a8:	83 e4 f0             	and    $0xfffffff0,%esp
801030ab:	ff 71 fc             	pushl  -0x4(%ecx)
801030ae:	55                   	push   %ebp
801030af:	89 e5                	mov    %esp,%ebp
801030b1:	53                   	push   %ebx
801030b2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030b3:	83 ec 08             	sub    $0x8,%esp
801030b6:	68 00 00 40 80       	push   $0x80400000
801030bb:	68 68 71 11 80       	push   $0x80117168
801030c0:	e8 ab f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
801030c5:	e8 46 41 00 00       	call   80107210 <kvmalloc>
  mpinit();        // detect other processors
801030ca:	e8 81 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cf:	e8 dc f6 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
801030d4:	e8 c7 3b 00 00       	call   80106ca0 <seginit>
  picinit();       // disable pic
801030d9:	e8 52 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030de:	e8 ad f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
801030e3:	e8 48 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030e8:	e8 73 2e 00 00       	call   80105f60 <uartinit>
  pinit();         // process table
801030ed:	e8 3e 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
801030f2:	e8 e9 2a 00 00       	call   80105be0 <tvinit>
  binit();         // buffer cache
801030f7:	e8 44 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030fc:	e8 ef dc ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
80103101:	e8 5a f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103106:	83 c4 0c             	add    $0xc,%esp
80103109:	68 8a 00 00 00       	push   $0x8a
8010310e:	68 90 b4 10 80       	push   $0x8010b490
80103113:	68 00 70 00 80       	push   $0x80007000
80103118:	e8 f3 17 00 00       	call   80104910 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010311d:	83 c4 10             	add    $0x10,%esp
80103120:	69 05 c0 46 11 80 b0 	imul   $0xb0,0x801146c0,%eax
80103127:	00 00 00 
8010312a:	05 40 41 11 80       	add    $0x80114140,%eax
8010312f:	3d 40 41 11 80       	cmp    $0x80114140,%eax
80103134:	76 7a                	jbe    801031b0 <main+0x110>
80103136:	bb 40 41 11 80       	mov    $0x80114140,%ebx
8010313b:	eb 1c                	jmp    80103159 <main+0xb9>
8010313d:	8d 76 00             	lea    0x0(%esi),%esi
80103140:	69 05 c0 46 11 80 b0 	imul   $0xb0,0x801146c0,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 40 41 11 80       	add    $0x80114140,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 02 08 00 00       	call   80103960 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 d9 f4 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010317b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 6a f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 1e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801031c2:	e8 59 08 00 00       	call   80103a20 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 fb                	cmp    %edi,%ebx
801031f4:	76 42                	jbe    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 38 7d 10 80       	push   $0x80107d38
80103203:	56                   	push   %esi
80103204:	e8 b7 16 00 00       	call   801048c0 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret    
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	89 e5                	mov    %esp,%ebp
80103257:	57                   	push   %edi
80103258:	56                   	push   %esi
80103259:	53                   	push   %ebx
8010325a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010325d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103264:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010326b:	c1 e0 08             	shl    $0x8,%eax
8010326e:	09 d0                	or     %edx,%eax
80103270:	c1 e0 04             	shl    $0x4,%eax
80103273:	75 1b                	jne    80103290 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103275:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010327c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103283:	c1 e0 08             	shl    $0x8,%eax
80103286:	09 d0                	or     %edx,%eax
80103288:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010328b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103290:	ba 00 04 00 00       	mov    $0x400,%edx
80103295:	e8 36 ff ff ff       	call   801031d0 <mpsearch1>
8010329a:	89 c6                	mov    %eax,%esi
8010329c:	85 c0                	test   %eax,%eax
8010329e:	0f 84 4c 01 00 00    	je     801033f0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a4:	8b 5e 04             	mov    0x4(%esi),%ebx
801032a7:	85 db                	test   %ebx,%ebx
801032a9:	0f 84 61 01 00 00    	je     80103410 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032af:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032b8:	6a 04                	push   $0x4
801032ba:	68 3d 7d 10 80       	push   $0x80107d3d
801032bf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032c3:	e8 f8 15 00 00       	call   801048c0 <memcmp>
801032c8:	83 c4 10             	add    $0x10,%esp
801032cb:	85 c0                	test   %eax,%eax
801032cd:	0f 85 3d 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032d3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032da:	3c 01                	cmp    $0x1,%al
801032dc:	74 08                	je     801032e6 <mpinit+0x96>
801032de:	3c 04                	cmp    $0x4,%al
801032e0:	0f 85 2a 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032e6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032ed:	66 85 d2             	test   %dx,%dx
801032f0:	74 26                	je     80103318 <mpinit+0xc8>
801032f2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032f5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032f7:	31 d2                	xor    %edx,%edx
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103300:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103307:	83 c0 01             	add    $0x1,%eax
8010330a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010330c:	39 f8                	cmp    %edi,%eax
8010330e:	75 f0                	jne    80103300 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103310:	84 d2                	test   %dl,%dl
80103312:	0f 85 f8 00 00 00    	jne    80103410 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103318:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010331e:	a3 3c 40 11 80       	mov    %eax,0x8011403c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103323:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103329:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103330:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103335:	03 55 e4             	add    -0x1c(%ebp),%edx
80103338:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
80103340:	39 c2                	cmp    %eax,%edx
80103342:	76 15                	jbe    80103359 <mpinit+0x109>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	74 5c                	je     801033a8 <mpinit+0x158>
8010334c:	77 42                	ja     80103390 <mpinit+0x140>
8010334e:	84 c9                	test   %cl,%cl
80103350:	74 6e                	je     801033c0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103352:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103355:	39 c2                	cmp    %eax,%edx
80103357:	77 eb                	ja     80103344 <mpinit+0xf4>
80103359:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335c:	85 db                	test   %ebx,%ebx
8010335e:	0f 84 b9 00 00 00    	je     8010341d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103364:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103368:	74 15                	je     8010337f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336a:	b8 70 00 00 00       	mov    $0x70,%eax
8010336f:	ba 22 00 00 00       	mov    $0x22,%edx
80103374:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103375:	ba 23 00 00 00       	mov    $0x23,%edx
8010337a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337e:	ee                   	out    %al,(%dx)
  }
}
8010337f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5f                   	pop    %edi
80103385:	5d                   	pop    %ebp
80103386:	c3                   	ret    
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103390:	83 e9 03             	sub    $0x3,%ecx
80103393:	80 f9 01             	cmp    $0x1,%cl
80103396:	76 ba                	jbe    80103352 <mpinit+0x102>
80103398:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010339f:	eb 9f                	jmp    80103340 <mpinit+0xf0>
801033a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033a8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033af:	88 0d 20 41 11 80    	mov    %cl,0x80114120
      continue;
801033b5:	eb 89                	jmp    80103340 <mpinit+0xf0>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033c0:	8b 0d c0 46 11 80    	mov    0x801146c0,%ecx
801033c6:	83 f9 07             	cmp    $0x7,%ecx
801033c9:	7f 19                	jg     801033e4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033d5:	83 c1 01             	add    $0x1,%ecx
801033d8:	89 0d c0 46 11 80    	mov    %ecx,0x801146c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033de:	88 9f 40 41 11 80    	mov    %bl,-0x7feebec0(%edi)
      p += sizeof(struct mpproc);
801033e4:	83 c0 14             	add    $0x14,%eax
      continue;
801033e7:	e9 54 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033fa:	e8 d1 fd ff ff       	call   801031d0 <mpsearch1>
801033ff:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103401:	85 c0                	test   %eax,%eax
80103403:	0f 85 9b fe ff ff    	jne    801032a4 <mpinit+0x54>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 42 7d 10 80       	push   $0x80107d42
80103418:	e8 73 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010341d:	83 ec 0c             	sub    $0xc,%esp
80103420:	68 5c 7d 10 80       	push   $0x80107d5c
80103425:	e8 66 cf ff ff       	call   80100390 <panic>
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103439:	ba 21 00 00 00       	mov    $0x21,%edx
8010343e:	ee                   	out    %al,(%dx)
8010343f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103444:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103445:	c3                   	ret    
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	f3 0f 1e fb          	endbr32 
80103454:	55                   	push   %ebp
80103455:	89 e5                	mov    %esp,%ebp
80103457:	57                   	push   %edi
80103458:	56                   	push   %esi
80103459:	53                   	push   %ebx
8010345a:	83 ec 0c             	sub    $0xc,%esp
8010345d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103460:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103463:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346f:	e8 9c d9 ff ff       	call   80100e10 <filealloc>
80103474:	89 03                	mov    %eax,(%ebx)
80103476:	85 c0                	test   %eax,%eax
80103478:	0f 84 ac 00 00 00    	je     8010352a <pipealloc+0xda>
8010347e:	e8 8d d9 ff ff       	call   80100e10 <filealloc>
80103483:	89 06                	mov    %eax,(%esi)
80103485:	85 c0                	test   %eax,%eax
80103487:	0f 84 8b 00 00 00    	je     80103518 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010348d:	e8 ae f1 ff ff       	call   80102640 <kalloc>
80103492:	89 c7                	mov    %eax,%edi
80103494:	85 c0                	test   %eax,%eax
80103496:	0f 84 b4 00 00 00    	je     80103550 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010349c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034a3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034b0:	00 00 00 
  p->nwrite = 0;
801034b3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ba:	00 00 00 
  p->nread = 0;
801034bd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c4:	00 00 00 
  initlock(&p->lock, "pipe");
801034c7:	68 7b 7d 10 80       	push   $0x80107d7b
801034cc:	50                   	push   %eax
801034cd:	e8 0e 11 00 00       	call   801045e0 <initlock>
  (*f0)->type = FD_PIPE;
801034d2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034dd:	8b 03                	mov    (%ebx),%eax
801034df:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034e3:	8b 03                	mov    (%ebx),%eax
801034e5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e9:	8b 03                	mov    (%ebx),%eax
801034eb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f6:	8b 06                	mov    (%esi),%eax
801034f8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034fc:	8b 06                	mov    (%esi),%eax
801034fe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103502:	8b 06                	mov    (%esi),%eax
80103504:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010350a:	31 c0                	xor    %eax,%eax
}
8010350c:	5b                   	pop    %ebx
8010350d:	5e                   	pop    %esi
8010350e:	5f                   	pop    %edi
8010350f:	5d                   	pop    %ebp
80103510:	c3                   	ret    
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103518:	8b 03                	mov    (%ebx),%eax
8010351a:	85 c0                	test   %eax,%eax
8010351c:	74 1e                	je     8010353c <pipealloc+0xec>
    fileclose(*f0);
8010351e:	83 ec 0c             	sub    $0xc,%esp
80103521:	50                   	push   %eax
80103522:	e8 a9 d9 ff ff       	call   80100ed0 <fileclose>
80103527:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	85 c0                	test   %eax,%eax
8010352e:	74 0c                	je     8010353c <pipealloc+0xec>
    fileclose(*f1);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	50                   	push   %eax
80103534:	e8 97 d9 ff ff       	call   80100ed0 <fileclose>
80103539:	83 c4 10             	add    $0x10,%esp
}
8010353c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010353f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103544:	5b                   	pop    %ebx
80103545:	5e                   	pop    %esi
80103546:	5f                   	pop    %edi
80103547:	5d                   	pop    %ebp
80103548:	c3                   	ret    
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	75 c8                	jne    8010351e <pipealloc+0xce>
80103556:	eb d2                	jmp    8010352a <pipealloc+0xda>
80103558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	56                   	push   %esi
80103568:	53                   	push   %ebx
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	53                   	push   %ebx
80103573:	e8 e8 11 00 00       	call   80104760 <acquire>
  if(writable){
80103578:	83 c4 10             	add    $0x10,%esp
8010357b:	85 f6                	test   %esi,%esi
8010357d:	74 41                	je     801035c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357f:	83 ec 0c             	sub    $0xc,%esp
80103582:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103588:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358f:	00 00 00 
    wakeup(&p->nread);
80103592:	50                   	push   %eax
80103593:	e8 58 0c 00 00       	call   801041f0 <wakeup>
80103598:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010359b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	75 0a                	jne    801035af <pipeclose+0x4f>
801035a5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035ab:	85 c0                	test   %eax,%eax
801035ad:	74 31                	je     801035e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035af:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b5:	5b                   	pop    %ebx
801035b6:	5e                   	pop    %esi
801035b7:	5d                   	pop    %ebp
    release(&p->lock);
801035b8:	e9 63 12 00 00       	jmp    80104820 <release>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 17 0c 00 00       	call   801041f0 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb bd                	jmp    8010359b <pipeclose+0x3b>
801035de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 37 12 00 00       	call   80104820 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    kfree((char*)p);
801035f5:	e9 86 ee ff ff       	jmp    80102480 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	f3 0f 1e fb          	endbr32 
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	57                   	push   %edi
80103608:	56                   	push   %esi
80103609:	53                   	push   %ebx
8010360a:	83 ec 28             	sub    $0x28,%esp
8010360d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103610:	53                   	push   %ebx
80103611:	e8 4a 11 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++){
80103616:	8b 45 10             	mov    0x10(%ebp),%eax
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	0f 8e bc 00 00 00    	jle    801036e0 <pipewrite+0xe0>
80103624:	8b 45 0c             	mov    0xc(%ebp),%eax
80103627:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010362d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103636:	03 45 10             	add    0x10(%ebp),%eax
80103639:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010363c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103642:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103648:	89 ca                	mov    %ecx,%edx
8010364a:	05 00 02 00 00       	add    $0x200,%eax
8010364f:	39 c1                	cmp    %eax,%ecx
80103651:	74 3b                	je     8010368e <pipewrite+0x8e>
80103653:	eb 63                	jmp    801036b8 <pipewrite+0xb8>
80103655:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103658:	e8 93 03 00 00       	call   801039f0 <myproc>
8010365d:	8b 48 28             	mov    0x28(%eax),%ecx
80103660:	85 c9                	test   %ecx,%ecx
80103662:	75 34                	jne    80103698 <pipewrite+0x98>
      wakeup(&p->nread);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	57                   	push   %edi
80103668:	e8 83 0b 00 00       	call   801041f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366d:	58                   	pop    %eax
8010366e:	5a                   	pop    %edx
8010366f:	53                   	push   %ebx
80103670:	56                   	push   %esi
80103671:	e8 ba 09 00 00       	call   80104030 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103676:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010367c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	05 00 02 00 00       	add    $0x200,%eax
8010368a:	39 c2                	cmp    %eax,%edx
8010368c:	75 2a                	jne    801036b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010368e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	75 c0                	jne    80103658 <pipewrite+0x58>
        release(&p->lock);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	53                   	push   %ebx
8010369c:	e8 7f 11 00 00       	call   80104820 <release>
        return -1;
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ca:	0f b6 06             	movzbl (%esi),%eax
801036cd:	83 c6 01             	add    $0x1,%esi
801036d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036da:	0f 85 5c ff ff ff    	jne    8010363c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e9:	50                   	push   %eax
801036ea:	e8 01 0b 00 00       	call   801041f0 <wakeup>
  release(&p->lock);
801036ef:	89 1c 24             	mov    %ebx,(%esp)
801036f2:	e8 29 11 00 00       	call   80104820 <release>
  return n;
801036f7:	8b 45 10             	mov    0x10(%ebp),%eax
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	eb aa                	jmp    801036a9 <pipewrite+0xa9>
801036ff:	90                   	nop

80103700 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
80103705:	89 e5                	mov    %esp,%ebp
80103707:	57                   	push   %edi
80103708:	56                   	push   %esi
80103709:	53                   	push   %ebx
8010370a:	83 ec 18             	sub    $0x18,%esp
8010370d:	8b 75 08             	mov    0x8(%ebp),%esi
80103710:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103713:	56                   	push   %esi
80103714:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010371a:	e8 41 10 00 00       	call   80104760 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010372e:	74 33                	je     80103763 <piperead+0x63>
80103730:	eb 3b                	jmp    8010376d <piperead+0x6d>
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103738:	e8 b3 02 00 00       	call   801039f0 <myproc>
8010373d:	8b 48 28             	mov    0x28(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	0f 85 88 00 00 00    	jne    801037d0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103748:	83 ec 08             	sub    $0x8,%esp
8010374b:	56                   	push   %esi
8010374c:	53                   	push   %ebx
8010374d:	e8 de 08 00 00       	call   80104030 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103752:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103758:	83 c4 10             	add    $0x10,%esp
8010375b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103761:	75 0a                	jne    8010376d <piperead+0x6d>
80103763:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103769:	85 c0                	test   %eax,%eax
8010376b:	75 cb                	jne    80103738 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010376d:	8b 55 10             	mov    0x10(%ebp),%edx
80103770:	31 db                	xor    %ebx,%ebx
80103772:	85 d2                	test   %edx,%edx
80103774:	7f 28                	jg     8010379e <piperead+0x9e>
80103776:	eb 34                	jmp    801037ac <piperead+0xac>
80103778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103780:	8d 48 01             	lea    0x1(%eax),%ecx
80103783:	25 ff 01 00 00       	and    $0x1ff,%eax
80103788:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010378e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103793:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103796:	83 c3 01             	add    $0x1,%ebx
80103799:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010379c:	74 0e                	je     801037ac <piperead+0xac>
    if(p->nread == p->nwrite)
8010379e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037aa:	75 d4                	jne    80103780 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037b5:	50                   	push   %eax
801037b6:	e8 35 0a 00 00       	call   801041f0 <wakeup>
  release(&p->lock);
801037bb:	89 34 24             	mov    %esi,(%esp)
801037be:	e8 5d 10 00 00       	call   80104820 <release>
  return i;
801037c3:	83 c4 10             	add    $0x10,%esp
}
801037c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5f                   	pop    %edi
801037ce:	5d                   	pop    %ebp
801037cf:	c3                   	ret    
      release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037d8:	56                   	push   %esi
801037d9:	e8 42 10 00 00       	call   80104820 <release>
      return -1;
801037de:	83 c4 10             	add    $0x10,%esp
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	5b                   	pop    %ebx
801037e7:	5e                   	pop    %esi
801037e8:	5f                   	pop    %edi
801037e9:	5d                   	pop    %ebp
801037ea:	c3                   	ret    
801037eb:	66 90                	xchg   %ax,%ax
801037ed:	66 90                	xchg   %ax,%ax
801037ef:	90                   	nop

801037f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f4:	bb 14 47 11 80       	mov    $0x80114714,%ebx
{
801037f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037fc:	68 e0 46 11 80       	push   $0x801146e0
80103801:	e8 5a 0f 00 00       	call   80104760 <acquire>
80103806:	83 c4 10             	add    $0x10,%esp
80103809:	eb 17                	jmp    80103822 <allocproc+0x32>
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103810:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103816:	81 fb 14 69 11 80    	cmp    $0x80116914,%ebx
8010381c:	0f 84 8e 00 00 00    	je     801038b0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103822:	8b 43 10             	mov    0x10(%ebx),%eax
80103825:	85 c0                	test   %eax,%eax
80103827:	75 e7                	jne    80103810 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103829:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  p->tickets = 1;    //updated
  p->ticks = 0;  // updated

  release(&ptable.lock);
8010382e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103831:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->tickets = 1;    //updated
80103838:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
8010383f:	00 00 00 
  p->pid = nextpid++;
80103842:	89 43 14             	mov    %eax,0x14(%ebx)
80103845:	8d 50 01             	lea    0x1(%eax),%edx
  p->ticks = 0;  // updated
80103848:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010384f:	00 00 00 
  release(&ptable.lock);
80103852:	68 e0 46 11 80       	push   $0x801146e0
  p->pid = nextpid++;
80103857:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010385d:	e8 be 0f 00 00       	call   80104820 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103862:	e8 d9 ed ff ff       	call   80102640 <kalloc>
80103867:	83 c4 10             	add    $0x10,%esp
8010386a:	89 43 08             	mov    %eax,0x8(%ebx)
8010386d:	85 c0                	test   %eax,%eax
8010386f:	74 58                	je     801038c9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103871:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103877:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010387a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010387f:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
80103882:	c7 40 14 c7 5b 10 80 	movl   $0x80105bc7,0x14(%eax)
  p->context = (struct context*)sp;
80103889:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010388c:	6a 14                	push   $0x14
8010388e:	6a 00                	push   $0x0
80103890:	50                   	push   %eax
80103891:	e8 da 0f 00 00       	call   80104870 <memset>
  p->context->eip = (uint)forkret;
80103896:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103899:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010389c:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a3:	89 d8                	mov    %ebx,%eax
801038a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a8:	c9                   	leave  
801038a9:	c3                   	ret    
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 e0 46 11 80       	push   $0x801146e0
801038ba:	e8 61 0f 00 00       	call   80104820 <release>
}
801038bf:	89 d8                	mov    %ebx,%eax
  return 0;
801038c1:	83 c4 10             	add    $0x10,%esp
}
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
    p->state = UNUSED;
801038c9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
801038d0:	31 db                	xor    %ebx,%ebx
}
801038d2:	89 d8                	mov    %ebx,%eax
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ea:	68 e0 46 11 80       	push   $0x801146e0
801038ef:	e8 2c 0f 00 00       	call   80104820 <release>

  if (first) {
801038f4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	85 c0                	test   %eax,%eax
801038fe:	75 08                	jne    80103908 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103900:	c9                   	leave  
80103901:	c3                   	ret    
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103908:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010390f:	00 00 00 
    iinit(ROOTDEV);
80103912:	83 ec 0c             	sub    $0xc,%esp
80103915:	6a 01                	push   $0x1
80103917:	e8 34 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
8010391c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103923:	e8 c8 f3 ff ff       	call   80102cf0 <initlog>
}
80103928:	83 c4 10             	add    $0x10,%esp
8010392b:	c9                   	leave  
8010392c:	c3                   	ret    
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <pinit>:
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010393a:	68 80 7d 10 80       	push   $0x80107d80
8010393f:	68 e0 46 11 80       	push   $0x801146e0
80103944:	e8 97 0c 00 00       	call   801045e0 <initlock>
  sgenrand(unixtime());
80103949:	e8 52 f2 ff ff       	call   80102ba0 <unixtime>
8010394e:	89 04 24             	mov    %eax,(%esp)
80103951:	e8 fa 3c 00 00       	call   80107650 <sgenrand>
}
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	c9                   	leave  
8010395a:	c3                   	ret    
8010395b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <mycpu>:
{
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	56                   	push   %esi
80103968:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103969:	9c                   	pushf  
8010396a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010396b:	f6 c4 02             	test   $0x2,%ah
8010396e:	75 4a                	jne    801039ba <mycpu+0x5a>
  apicid = lapicid();
80103970:	e8 3b ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103975:	8b 35 c0 46 11 80    	mov    0x801146c0,%esi
  apicid = lapicid();
8010397b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010397d:	85 f6                	test   %esi,%esi
8010397f:	7e 2c                	jle    801039ad <mycpu+0x4d>
80103981:	31 d2                	xor    %edx,%edx
80103983:	eb 0a                	jmp    8010398f <mycpu+0x2f>
80103985:	8d 76 00             	lea    0x0(%esi),%esi
80103988:	83 c2 01             	add    $0x1,%edx
8010398b:	39 f2                	cmp    %esi,%edx
8010398d:	74 1e                	je     801039ad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010398f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103995:	0f b6 81 40 41 11 80 	movzbl -0x7feebec0(%ecx),%eax
8010399c:	39 d8                	cmp    %ebx,%eax
8010399e:	75 e8                	jne    80103988 <mycpu+0x28>
}
801039a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039a3:	8d 81 40 41 11 80    	lea    -0x7feebec0(%ecx),%eax
}
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
  panic("unknown apicid\n");
801039ad:	83 ec 0c             	sub    $0xc,%esp
801039b0:	68 87 7d 10 80       	push   $0x80107d87
801039b5:	e8 d6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039ba:	83 ec 0c             	sub    $0xc,%esp
801039bd:	68 64 7e 10 80       	push   $0x80107e64
801039c2:	e8 c9 c9 ff ff       	call   80100390 <panic>
801039c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <cpuid>:
cpuid() {
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039da:	e8 81 ff ff ff       	call   80103960 <mycpu>
}
801039df:	c9                   	leave  
  return mycpu()-cpus;
801039e0:	2d 40 41 11 80       	sub    $0x80114140,%eax
801039e5:	c1 f8 04             	sar    $0x4,%eax
801039e8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ee:	c3                   	ret    
801039ef:	90                   	nop

801039f0 <myproc>:
myproc(void) {
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	53                   	push   %ebx
801039f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039fb:	e8 60 0c 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103a00:	e8 5b ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103a05:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a0b:	e8 a0 0c 00 00       	call   801046b0 <popcli>
}
80103a10:	83 c4 04             	add    $0x4,%esp
80103a13:	89 d8                	mov    %ebx,%eax
80103a15:	5b                   	pop    %ebx
80103a16:	5d                   	pop    %ebp
80103a17:	c3                   	ret    
80103a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop

80103a20 <userinit>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	53                   	push   %ebx
80103a28:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a2b:	e8 c0 fd ff ff       	call   801037f0 <allocproc>
80103a30:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a32:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a37:	e8 54 37 00 00       	call   80107190 <setupkvm>
80103a3c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a3f:	85 c0                	test   %eax,%eax
80103a41:	0f 84 bd 00 00 00    	je     80103b04 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a47:	83 ec 04             	sub    $0x4,%esp
80103a4a:	68 2c 00 00 00       	push   $0x2c
80103a4f:	68 64 b4 10 80       	push   $0x8010b464
80103a54:	50                   	push   %eax
80103a55:	e8 06 34 00 00       	call   80106e60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a5a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a5d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a63:	6a 4c                	push   $0x4c
80103a65:	6a 00                	push   $0x0
80103a67:	ff 73 1c             	pushl  0x1c(%ebx)
80103a6a:	e8 01 0e 00 00       	call   80104870 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a72:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a77:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a7a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a7f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a83:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a86:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a8a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a8d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a91:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a95:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a98:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a9c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103aa0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103aa3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aaa:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103aad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ab4:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ab7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103abe:	8d 43 70             	lea    0x70(%ebx),%eax
80103ac1:	6a 10                	push   $0x10
80103ac3:	68 b0 7d 10 80       	push   $0x80107db0
80103ac8:	50                   	push   %eax
80103ac9:	e8 62 0f 00 00       	call   80104a30 <safestrcpy>
  p->cwd = namei("/");
80103ace:	c7 04 24 b9 7d 10 80 	movl   $0x80107db9,(%esp)
80103ad5:	e8 66 e5 ff ff       	call   80102040 <namei>
80103ada:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103add:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103ae4:	e8 77 0c 00 00       	call   80104760 <acquire>
  p->state = RUNNABLE;
80103ae9:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103af0:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103af7:	e8 24 0d 00 00       	call   80104820 <release>
}
80103afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	c9                   	leave  
80103b03:	c3                   	ret    
    panic("userinit: out of memory?");
80103b04:	83 ec 0c             	sub    $0xc,%esp
80103b07:	68 97 7d 10 80       	push   $0x80107d97
80103b0c:	e8 7f c8 ff ff       	call   80100390 <panic>
80103b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <growproc>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	56                   	push   %esi
80103b28:	53                   	push   %ebx
80103b29:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b2c:	e8 2f 0b 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103b31:	e8 2a fe ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b36:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b3c:	e8 6f 0b 00 00       	call   801046b0 <popcli>
  sz = curproc->sz;
80103b41:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b43:	85 f6                	test   %esi,%esi
80103b45:	7f 19                	jg     80103b60 <growproc+0x40>
  } else if(n < 0){
80103b47:	75 37                	jne    80103b80 <growproc+0x60>
  switchuvm(curproc);
80103b49:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b4c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b4e:	53                   	push   %ebx
80103b4f:	e8 fc 31 00 00       	call   80106d50 <switchuvm>
  return 0;
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	31 c0                	xor    %eax,%eax
}
80103b59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b5c:	5b                   	pop    %ebx
80103b5d:	5e                   	pop    %esi
80103b5e:	5d                   	pop    %ebp
80103b5f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b60:	83 ec 04             	sub    $0x4,%esp
80103b63:	01 c6                	add    %eax,%esi
80103b65:	56                   	push   %esi
80103b66:	50                   	push   %eax
80103b67:	ff 73 04             	pushl  0x4(%ebx)
80103b6a:	e8 41 34 00 00       	call   80106fb0 <allocuvm>
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	85 c0                	test   %eax,%eax
80103b74:	75 d3                	jne    80103b49 <growproc+0x29>
      return -1;
80103b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b7b:	eb dc                	jmp    80103b59 <growproc+0x39>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b80:	83 ec 04             	sub    $0x4,%esp
80103b83:	01 c6                	add    %eax,%esi
80103b85:	56                   	push   %esi
80103b86:	50                   	push   %eax
80103b87:	ff 73 04             	pushl  0x4(%ebx)
80103b8a:	e8 51 35 00 00       	call   801070e0 <deallocuvm>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 b3                	jne    80103b49 <growproc+0x29>
80103b96:	eb de                	jmp    80103b76 <growproc+0x56>
80103b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <fork>:
{
80103ba0:	f3 0f 1e fb          	endbr32 
80103ba4:	55                   	push   %ebp
80103ba5:	89 e5                	mov    %esp,%ebp
80103ba7:	57                   	push   %edi
80103ba8:	56                   	push   %esi
80103ba9:	53                   	push   %ebx
80103baa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bad:	e8 ae 0a 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103bb2:	e8 a9 fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103bb7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bbd:	e8 ee 0a 00 00       	call   801046b0 <popcli>
  if((np = allocproc()) == 0){
80103bc2:	e8 29 fc ff ff       	call   801037f0 <allocproc>
80103bc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bca:	85 c0                	test   %eax,%eax
80103bcc:	0f 84 c3 00 00 00    	je     80103c95 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bd2:	83 ec 08             	sub    $0x8,%esp
80103bd5:	ff 33                	pushl  (%ebx)
80103bd7:	89 c7                	mov    %eax,%edi
80103bd9:	ff 73 04             	pushl  0x4(%ebx)
80103bdc:	e8 7f 36 00 00       	call   80107260 <copyuvm>
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	89 47 04             	mov    %eax,0x4(%edi)
80103be7:	85 c0                	test   %eax,%eax
80103be9:	0f 84 ad 00 00 00    	je     80103c9c <fork+0xfc>
  np->tickets = curproc->tickets;
80103bef:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103bf5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bf8:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  np->sz = curproc->sz;
80103bfe:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103c00:	8b 79 1c             	mov    0x1c(%ecx),%edi
  np->parent = curproc;
80103c03:	89 59 18             	mov    %ebx,0x18(%ecx)
  np->sz = curproc->sz;
80103c06:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c08:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c0a:	8b 73 1c             	mov    0x1c(%ebx),%esi
80103c0d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c16:	8b 40 1c             	mov    0x1c(%eax),%eax
80103c19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c20:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103c24:	85 c0                	test   %eax,%eax
80103c26:	74 13                	je     80103c3b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c28:	83 ec 0c             	sub    $0xc,%esp
80103c2b:	50                   	push   %eax
80103c2c:	e8 4f d2 ff ff       	call   80100e80 <filedup>
80103c31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c34:	83 c4 10             	add    $0x10,%esp
80103c37:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c3b:	83 c6 01             	add    $0x1,%esi
80103c3e:	83 fe 10             	cmp    $0x10,%esi
80103c41:	75 dd                	jne    80103c20 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c43:	83 ec 0c             	sub    $0xc,%esp
80103c46:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c49:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103c4c:	e8 ef da ff ff       	call   80101740 <idup>
80103c51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c57:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c5a:	8d 47 70             	lea    0x70(%edi),%eax
80103c5d:	6a 10                	push   $0x10
80103c5f:	53                   	push   %ebx
80103c60:	50                   	push   %eax
80103c61:	e8 ca 0d 00 00       	call   80104a30 <safestrcpy>
  pid = np->pid;
80103c66:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103c69:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103c70:	e8 eb 0a 00 00       	call   80104760 <acquire>
  np->state = RUNNABLE;
80103c75:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103c7c:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103c83:	e8 98 0b 00 00       	call   80104820 <release>
  return pid;
80103c88:	83 c4 10             	add    $0x10,%esp
}
80103c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c8e:	89 d8                	mov    %ebx,%eax
80103c90:	5b                   	pop    %ebx
80103c91:	5e                   	pop    %esi
80103c92:	5f                   	pop    %edi
80103c93:	5d                   	pop    %ebp
80103c94:	c3                   	ret    
    return -1;
80103c95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c9a:	eb ef                	jmp    80103c8b <fork+0xeb>
    kfree(np->kstack);
80103c9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c9f:	83 ec 0c             	sub    $0xc,%esp
80103ca2:	ff 73 08             	pushl  0x8(%ebx)
80103ca5:	e8 d6 e7 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103caa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cb1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cb4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103cbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cc0:	eb c9                	jmp    80103c8b <fork+0xeb>
80103cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cd0 <getrpt>:
getrpt(void){   // get total number of tickets for runnable processes
80103cd0:	f3 0f 1e fb          	endbr32 
  int total_process_tickets=0;
80103cd4:	31 d2                	xor    %edx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)  //You have access to the entire xv6 source presumably, which means that you can add a function in proc.c
80103cd6:	b8 14 47 11 80       	mov    $0x80114714,%eax
80103cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop
    if(p->state==RUNNABLE){
80103ce0:	83 78 10 03          	cmpl   $0x3,0x10(%eax)
80103ce4:	75 06                	jne    80103cec <getrpt+0x1c>
      total_process_tickets+=p->tickets;  
80103ce6:	03 90 80 00 00 00    	add    0x80(%eax),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)  //You have access to the entire xv6 source presumably, which means that you can add a function in proc.c
80103cec:	05 88 00 00 00       	add    $0x88,%eax
80103cf1:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80103cf6:	75 e8                	jne    80103ce0 <getrpt+0x10>
}
80103cf8:	89 d0                	mov    %edx,%eax
80103cfa:	c3                   	ret    
80103cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop

80103d00 <scheduler>:
{
80103d00:	f3 0f 1e fb          	endbr32 
80103d04:	55                   	push   %ebp
80103d05:	89 e5                	mov    %esp,%ebp
80103d07:	57                   	push   %edi
80103d08:	56                   	push   %esi
80103d09:	53                   	push   %ebx
80103d0a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();  // Per-CPU state
80103d0d:	e8 4e fc ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103d12:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d19:	00 00 00 
  struct cpu *c = mycpu();  // Per-CPU state
80103d1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
80103d1f:	83 c0 04             	add    $0x4,%eax
80103d22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d25:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d28:	fb                   	sti    
    acquire(&ptable.lock);                 
80103d29:	83 ec 0c             	sub    $0xc,%esp
80103d2c:	68 e0 46 11 80       	push   $0x801146e0
80103d31:	e8 2a 0a 00 00       	call   80104760 <acquire>
80103d36:	83 c4 10             	add    $0x10,%esp
  int total_process_tickets=0;
80103d39:	31 d2                	xor    %edx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)  //You have access to the entire xv6 source presumably, which means that you can add a function in proc.c
80103d3b:	b8 14 47 11 80       	mov    $0x80114714,%eax
    if(p->state==RUNNABLE){
80103d40:	83 78 10 03          	cmpl   $0x3,0x10(%eax)
80103d44:	75 06                	jne    80103d4c <scheduler+0x4c>
      total_process_tickets+=p->tickets;  
80103d46:	03 90 80 00 00 00    	add    0x80(%eax),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)  //You have access to the entire xv6 source presumably, which means that you can add a function in proc.c
80103d4c:	05 88 00 00 00       	add    $0x88,%eax
80103d51:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80103d56:	75 e8                	jne    80103d40 <scheduler+0x40>
    win = random_at_most(getrpt());       //You will need to add a psuedorandom number generator to the kernel to get a random number between 1 and total_tickets
80103d58:	83 ec 0c             	sub    $0xc,%esp
	   long count = 0;
80103d5b:	31 f6                	xor    %esi,%esi
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d5d:	bf 14 47 11 80       	mov    $0x80114714,%edi
    win = random_at_most(getrpt());       //You will need to add a psuedorandom number generator to the kernel to get a random number between 1 and total_tickets
80103d62:	52                   	push   %edx
80103d63:	e8 88 3a 00 00       	call   801077f0 <random_at_most>
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	89 c3                	mov    %eax,%ebx
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d6d:	8d 76 00             	lea    0x0(%esi),%esi
	 if(p->state == RUNNABLE)  count += p->tickets;  // sum of tickets of runnable process
80103d70:	83 7f 10 03          	cmpl   $0x3,0x10(%edi)
80103d74:	75 3f                	jne    80103db5 <scheduler+0xb5>
80103d76:	03 b7 80 00 00 00    	add    0x80(%edi),%esi
        if (count > win){   //  It is the chosen process job  / release ptable.lock / then reacquire it before jumping back to us.
80103d7c:	39 f3                	cmp    %esi,%ebx
80103d7e:	7d 35                	jge    80103db5 <scheduler+0xb5>
             c->proc = p;
80103d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
             switchuvm(p);     //The OS loads the process information to run it. After having loaded the process  
80103d83:	83 ec 0c             	sub    $0xc,%esp
             c->proc = p;
80103d86:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
             switchuvm(p);     //The OS loads the process information to run it. After having loaded the process  
80103d8c:	57                   	push   %edi
80103d8d:	e8 be 2f 00 00       	call   80106d50 <switchuvm>
             swtch(&(c->scheduler), p->context);   // the processor switches to execute it
80103d92:	58                   	pop    %eax
80103d93:	5a                   	pop    %edx
80103d94:	ff 77 20             	pushl  0x20(%edi)
80103d97:	ff 75 e0             	pushl  -0x20(%ebp)
             p->ticks++;   // increase no of times that processes has been chosen
80103d9a:	83 87 84 00 00 00 01 	addl   $0x1,0x84(%edi)
             p->state = RUNNING; // The process is marked running
80103da1:	c7 47 10 04 00 00 00 	movl   $0x4,0x10(%edi)
             swtch(&(c->scheduler), p->context);   // the processor switches to execute it
80103da8:	e8 e6 0c 00 00       	call   80104a93 <swtch>
             switchkvm();     //  When the process comes back to scheduler (so after the swtch) the kernel load its memory
80103dad:	e8 7e 2f 00 00       	call   80106d30 <switchkvm>
80103db2:	83 c4 10             	add    $0x10,%esp
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db5:	81 c7 88 00 00 00    	add    $0x88,%edi
80103dbb:	81 ff 14 69 11 80    	cmp    $0x80116914,%edi
80103dc1:	75 ad                	jne    80103d70 <scheduler+0x70>
    release(&ptable.lock);
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	68 e0 46 11 80       	push   $0x801146e0
80103dcb:	e8 50 0a 00 00       	call   80104820 <release>
  for(;;){
80103dd0:	83 c4 10             	add    $0x10,%esp
80103dd3:	e9 50 ff ff ff       	jmp    80103d28 <scheduler+0x28>
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <sched>:
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	56                   	push   %esi
80103de8:	53                   	push   %ebx
  pushcli();
80103de9:	e8 72 08 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103dee:	e8 6d fb ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103df3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df9:	e8 b2 08 00 00       	call   801046b0 <popcli>
  if(!holding(&ptable.lock))
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	68 e0 46 11 80       	push   $0x801146e0
80103e06:	e8 05 09 00 00       	call   80104710 <holding>
80103e0b:	83 c4 10             	add    $0x10,%esp
80103e0e:	85 c0                	test   %eax,%eax
80103e10:	74 4f                	je     80103e61 <sched+0x81>
  if(mycpu()->ncli != 1)
80103e12:	e8 49 fb ff ff       	call   80103960 <mycpu>
80103e17:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e1e:	75 68                	jne    80103e88 <sched+0xa8>
  if(p->state == RUNNING)
80103e20:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103e24:	74 55                	je     80103e7b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e26:	9c                   	pushf  
80103e27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e28:	f6 c4 02             	test   $0x2,%ah
80103e2b:	75 41                	jne    80103e6e <sched+0x8e>
  intena = mycpu()->intena;
80103e2d:	e8 2e fb ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e32:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103e35:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e3b:	e8 20 fb ff ff       	call   80103960 <mycpu>
80103e40:	83 ec 08             	sub    $0x8,%esp
80103e43:	ff 70 04             	pushl  0x4(%eax)
80103e46:	53                   	push   %ebx
80103e47:	e8 47 0c 00 00       	call   80104a93 <swtch>
  mycpu()->intena = intena;
80103e4c:	e8 0f fb ff ff       	call   80103960 <mycpu>
}
80103e51:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e54:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e5d:	5b                   	pop    %ebx
80103e5e:	5e                   	pop    %esi
80103e5f:	5d                   	pop    %ebp
80103e60:	c3                   	ret    
    panic("sched ptable.lock");
80103e61:	83 ec 0c             	sub    $0xc,%esp
80103e64:	68 bb 7d 10 80       	push   $0x80107dbb
80103e69:	e8 22 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	68 e7 7d 10 80       	push   $0x80107de7
80103e76:	e8 15 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e7b:	83 ec 0c             	sub    $0xc,%esp
80103e7e:	68 d9 7d 10 80       	push   $0x80107dd9
80103e83:	e8 08 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e88:	83 ec 0c             	sub    $0xc,%esp
80103e8b:	68 cd 7d 10 80       	push   $0x80107dcd
80103e90:	e8 fb c4 ff ff       	call   80100390 <panic>
80103e95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ea0 <exit>:
{
80103ea0:	f3 0f 1e fb          	endbr32 
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
80103ea7:	57                   	push   %edi
80103ea8:	56                   	push   %esi
80103ea9:	53                   	push   %ebx
80103eaa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ead:	e8 ae 07 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103eb2:	e8 a9 fa ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103eb7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ebd:	e8 ee 07 00 00       	call   801046b0 <popcli>
  if(curproc == initproc)
80103ec2:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103ec5:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103ec8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103ece:	0f 84 fd 00 00 00    	je     80103fd1 <exit+0x131>
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103ed8:	8b 03                	mov    (%ebx),%eax
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 12                	je     80103ef0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103ede:	83 ec 0c             	sub    $0xc,%esp
80103ee1:	50                   	push   %eax
80103ee2:	e8 e9 cf ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103ee7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103eed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ef0:	83 c3 04             	add    $0x4,%ebx
80103ef3:	39 df                	cmp    %ebx,%edi
80103ef5:	75 e1                	jne    80103ed8 <exit+0x38>
  begin_op();
80103ef7:	e8 94 ee ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80103efc:	83 ec 0c             	sub    $0xc,%esp
80103eff:	ff 76 6c             	pushl  0x6c(%esi)
80103f02:	e8 99 d9 ff ff       	call   801018a0 <iput>
  end_op();
80103f07:	e8 f4 ee ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80103f0c:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  acquire(&ptable.lock);
80103f13:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103f1a:	e8 41 08 00 00       	call   80104760 <acquire>
  wakeup1(curproc->parent);
80103f1f:	8b 56 18             	mov    0x18(%esi),%edx
80103f22:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f25:	b8 14 47 11 80       	mov    $0x80114714,%eax
80103f2a:	eb 10                	jmp    80103f3c <exit+0x9c>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f30:	05 88 00 00 00       	add    $0x88,%eax
80103f35:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80103f3a:	74 1e                	je     80103f5a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103f3c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103f40:	75 ee                	jne    80103f30 <exit+0x90>
80103f42:	3b 50 24             	cmp    0x24(%eax),%edx
80103f45:	75 e9                	jne    80103f30 <exit+0x90>
      p->state = RUNNABLE;
80103f47:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4e:	05 88 00 00 00       	add    $0x88,%eax
80103f53:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80103f58:	75 e2                	jne    80103f3c <exit+0x9c>
      p->parent = initproc;
80103f5a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f60:	ba 14 47 11 80       	mov    $0x80114714,%edx
80103f65:	eb 17                	jmp    80103f7e <exit+0xde>
80103f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6e:	66 90                	xchg   %ax,%ax
80103f70:	81 c2 88 00 00 00    	add    $0x88,%edx
80103f76:	81 fa 14 69 11 80    	cmp    $0x80116914,%edx
80103f7c:	74 3a                	je     80103fb8 <exit+0x118>
    if(p->parent == curproc){
80103f7e:	39 72 18             	cmp    %esi,0x18(%edx)
80103f81:	75 ed                	jne    80103f70 <exit+0xd0>
      if(p->state == ZOMBIE)
80103f83:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
80103f87:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
80103f8a:	75 e4                	jne    80103f70 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8c:	b8 14 47 11 80       	mov    $0x80114714,%eax
80103f91:	eb 11                	jmp    80103fa4 <exit+0x104>
80103f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f97:	90                   	nop
80103f98:	05 88 00 00 00       	add    $0x88,%eax
80103f9d:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80103fa2:	74 cc                	je     80103f70 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103fa4:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103fa8:	75 ee                	jne    80103f98 <exit+0xf8>
80103faa:	3b 48 24             	cmp    0x24(%eax),%ecx
80103fad:	75 e9                	jne    80103f98 <exit+0xf8>
      p->state = RUNNABLE;
80103faf:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103fb6:	eb e0                	jmp    80103f98 <exit+0xf8>
  curproc->state = ZOMBIE;
80103fb8:	c7 46 10 05 00 00 00 	movl   $0x5,0x10(%esi)
  sched();
80103fbf:	e8 1c fe ff ff       	call   80103de0 <sched>
  panic("zombie exit");
80103fc4:	83 ec 0c             	sub    $0xc,%esp
80103fc7:	68 08 7e 10 80       	push   $0x80107e08
80103fcc:	e8 bf c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103fd1:	83 ec 0c             	sub    $0xc,%esp
80103fd4:	68 fb 7d 10 80       	push   $0x80107dfb
80103fd9:	e8 b2 c3 ff ff       	call   80100390 <panic>
80103fde:	66 90                	xchg   %ax,%ax

80103fe0 <yield>:
{
80103fe0:	f3 0f 1e fb          	endbr32 
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	53                   	push   %ebx
80103fe8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103feb:	68 e0 46 11 80       	push   $0x801146e0
80103ff0:	e8 6b 07 00 00       	call   80104760 <acquire>
  pushcli();
80103ff5:	e8 66 06 00 00       	call   80104660 <pushcli>
  c = mycpu();
80103ffa:	e8 61 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103fff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104005:	e8 a6 06 00 00       	call   801046b0 <popcli>
  myproc()->state = RUNNABLE;
8010400a:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
80104011:	e8 ca fd ff ff       	call   80103de0 <sched>
  release(&ptable.lock);
80104016:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
8010401d:	e8 fe 07 00 00       	call   80104820 <release>
}
80104022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104025:	83 c4 10             	add    $0x10,%esp
80104028:	c9                   	leave  
80104029:	c3                   	ret    
8010402a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104030 <sleep>:
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	57                   	push   %edi
80104038:	56                   	push   %esi
80104039:	53                   	push   %ebx
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104040:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104043:	e8 18 06 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104048:	e8 13 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010404d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104053:	e8 58 06 00 00       	call   801046b0 <popcli>
  if(p == 0)
80104058:	85 db                	test   %ebx,%ebx
8010405a:	0f 84 83 00 00 00    	je     801040e3 <sleep+0xb3>
  if(lk == 0)
80104060:	85 f6                	test   %esi,%esi
80104062:	74 72                	je     801040d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104064:	81 fe e0 46 11 80    	cmp    $0x801146e0,%esi
8010406a:	74 4c                	je     801040b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010406c:	83 ec 0c             	sub    $0xc,%esp
8010406f:	68 e0 46 11 80       	push   $0x801146e0
80104074:	e8 e7 06 00 00       	call   80104760 <acquire>
    release(lk);
80104079:	89 34 24             	mov    %esi,(%esp)
8010407c:	e8 9f 07 00 00       	call   80104820 <release>
  p->chan = chan;
80104081:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104084:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
8010408b:	e8 50 fd ff ff       	call   80103de0 <sched>
  p->chan = 0;
80104090:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104097:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
8010409e:	e8 7d 07 00 00       	call   80104820 <release>
    acquire(lk);
801040a3:	89 75 08             	mov    %esi,0x8(%ebp)
801040a6:	83 c4 10             	add    $0x10,%esp
}
801040a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ac:	5b                   	pop    %ebx
801040ad:	5e                   	pop    %esi
801040ae:	5f                   	pop    %edi
801040af:	5d                   	pop    %ebp
    acquire(lk);
801040b0:	e9 ab 06 00 00       	jmp    80104760 <acquire>
801040b5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801040b8:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
801040bb:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801040c2:	e8 19 fd ff ff       	call   80103de0 <sched>
  p->chan = 0;
801040c7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801040ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d1:	5b                   	pop    %ebx
801040d2:	5e                   	pop    %esi
801040d3:	5f                   	pop    %edi
801040d4:	5d                   	pop    %ebp
801040d5:	c3                   	ret    
    panic("sleep without lk");
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	68 1a 7e 10 80       	push   $0x80107e1a
801040de:	e8 ad c2 ff ff       	call   80100390 <panic>
    panic("sleep");
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	68 14 7e 10 80       	push   $0x80107e14
801040eb:	e8 a0 c2 ff ff       	call   80100390 <panic>

801040f0 <wait>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	56                   	push   %esi
801040f8:	53                   	push   %ebx
  pushcli();
801040f9:	e8 62 05 00 00       	call   80104660 <pushcli>
  c = mycpu();
801040fe:	e8 5d f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104103:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104109:	e8 a2 05 00 00       	call   801046b0 <popcli>
  acquire(&ptable.lock);
8010410e:	83 ec 0c             	sub    $0xc,%esp
80104111:	68 e0 46 11 80       	push   $0x801146e0
80104116:	e8 45 06 00 00       	call   80104760 <acquire>
8010411b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104120:	bb 14 47 11 80       	mov    $0x80114714,%ebx
80104125:	eb 17                	jmp    8010413e <wait+0x4e>
80104127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412e:	66 90                	xchg   %ax,%ax
80104130:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104136:	81 fb 14 69 11 80    	cmp    $0x80116914,%ebx
8010413c:	74 1e                	je     8010415c <wait+0x6c>
      if(p->parent != curproc)
8010413e:	39 73 18             	cmp    %esi,0x18(%ebx)
80104141:	75 ed                	jne    80104130 <wait+0x40>
      if(p->state == ZOMBIE){
80104143:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80104147:	74 37                	je     80104180 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104149:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
8010414f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104154:	81 fb 14 69 11 80    	cmp    $0x80116914,%ebx
8010415a:	75 e2                	jne    8010413e <wait+0x4e>
    if(!havekids || curproc->killed){
8010415c:	85 c0                	test   %eax,%eax
8010415e:	74 76                	je     801041d6 <wait+0xe6>
80104160:	8b 46 28             	mov    0x28(%esi),%eax
80104163:	85 c0                	test   %eax,%eax
80104165:	75 6f                	jne    801041d6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104167:	83 ec 08             	sub    $0x8,%esp
8010416a:	68 e0 46 11 80       	push   $0x801146e0
8010416f:	56                   	push   %esi
80104170:	e8 bb fe ff ff       	call   80104030 <sleep>
    havekids = 0;
80104175:	83 c4 10             	add    $0x10,%esp
80104178:	eb a4                	jmp    8010411e <wait+0x2e>
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104180:	83 ec 0c             	sub    $0xc,%esp
80104183:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104186:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104189:	e8 f2 e2 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
8010418e:	5a                   	pop    %edx
8010418f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104192:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104199:	e8 72 2f 00 00       	call   80107110 <freevm>
        release(&ptable.lock);
8010419e:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
        p->pid = 0;
801041a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
801041ac:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
801041b3:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801041b7:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
801041be:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801041c5:	e8 56 06 00 00       	call   80104820 <release>
        return pid;
801041ca:	83 c4 10             	add    $0x10,%esp
}
801041cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d0:	89 f0                	mov    %esi,%eax
801041d2:	5b                   	pop    %ebx
801041d3:	5e                   	pop    %esi
801041d4:	5d                   	pop    %ebp
801041d5:	c3                   	ret    
      release(&ptable.lock);
801041d6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041de:	68 e0 46 11 80       	push   $0x801146e0
801041e3:	e8 38 06 00 00       	call   80104820 <release>
      return -1;
801041e8:	83 c4 10             	add    $0x10,%esp
801041eb:	eb e0                	jmp    801041cd <wait+0xdd>
801041ed:	8d 76 00             	lea    0x0(%esi),%esi

801041f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	53                   	push   %ebx
801041f8:	83 ec 10             	sub    $0x10,%esp
801041fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041fe:	68 e0 46 11 80       	push   $0x801146e0
80104203:	e8 58 05 00 00       	call   80104760 <acquire>
80104208:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010420b:	b8 14 47 11 80       	mov    $0x80114714,%eax
80104210:	eb 12                	jmp    80104224 <wakeup+0x34>
80104212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104218:	05 88 00 00 00       	add    $0x88,%eax
8010421d:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80104222:	74 1e                	je     80104242 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104224:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104228:	75 ee                	jne    80104218 <wakeup+0x28>
8010422a:	3b 58 24             	cmp    0x24(%eax),%ebx
8010422d:	75 e9                	jne    80104218 <wakeup+0x28>
      p->state = RUNNABLE;
8010422f:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104236:	05 88 00 00 00       	add    $0x88,%eax
8010423b:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80104240:	75 e2                	jne    80104224 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104242:	c7 45 08 e0 46 11 80 	movl   $0x801146e0,0x8(%ebp)
}
80104249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010424c:	c9                   	leave  
  release(&ptable.lock);
8010424d:	e9 ce 05 00 00       	jmp    80104820 <release>
80104252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	53                   	push   %ebx
80104268:	83 ec 10             	sub    $0x10,%esp
8010426b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010426e:	68 e0 46 11 80       	push   $0x801146e0
80104273:	e8 e8 04 00 00       	call   80104760 <acquire>
80104278:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427b:	b8 14 47 11 80       	mov    $0x80114714,%eax
80104280:	eb 12                	jmp    80104294 <kill+0x34>
80104282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104288:	05 88 00 00 00       	add    $0x88,%eax
8010428d:	3d 14 69 11 80       	cmp    $0x80116914,%eax
80104292:	74 34                	je     801042c8 <kill+0x68>
    if(p->pid == pid){
80104294:	39 58 14             	cmp    %ebx,0x14(%eax)
80104297:	75 ef                	jne    80104288 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104299:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
8010429d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
801042a4:	75 07                	jne    801042ad <kill+0x4d>
        p->state = RUNNABLE;
801042a6:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
801042ad:	83 ec 0c             	sub    $0xc,%esp
801042b0:	68 e0 46 11 80       	push   $0x801146e0
801042b5:	e8 66 05 00 00       	call   80104820 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042bd:	83 c4 10             	add    $0x10,%esp
801042c0:	31 c0                	xor    %eax,%eax
}
801042c2:	c9                   	leave  
801042c3:	c3                   	ret    
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 e0 46 11 80       	push   $0x801146e0
801042d0:	e8 4b 05 00 00       	call   80104820 <release>
}
801042d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042e0:	c9                   	leave  
801042e1:	c3                   	ret    
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <settickets>:

int 
settickets(int tickets){
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	53                   	push   %ebx
801042f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042fb:	e8 60 03 00 00       	call   80104660 <pushcli>
  c = mycpu();
80104300:	e8 5b f6 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104305:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430b:	e8 a0 03 00 00       	call   801046b0 <popcli>

  struct proc *proc = myproc(); //Disable interrupts so that we are not rescheduled; while reading proc from the cpu structure
  acquire(&ptable.lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 e0 46 11 80       	push   $0x801146e0
  ptable.proc[proc-ptable.proc].tickets = tickets;
80104318:	81 eb 14 47 11 80    	sub    $0x80114714,%ebx
8010431e:	83 e3 f8             	and    $0xfffffff8,%ebx
  acquire(&ptable.lock);
80104321:	e8 3a 04 00 00       	call   80104760 <acquire>
  ptable.proc[proc-ptable.proc].tickets = tickets;
80104326:	8b 45 08             	mov    0x8(%ebp),%eax
  release(&ptable.lock);
80104329:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
  ptable.proc[proc-ptable.proc].tickets = tickets;
80104330:	89 83 94 47 11 80    	mov    %eax,-0x7feeb86c(%ebx)
  release(&ptable.lock);
80104336:	e8 e5 04 00 00       	call   80104820 <release>
 
  return 0;
}
8010433b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010433e:	31 c0                	xor    %eax,%eax
80104340:	c9                   	leave  
80104341:	c3                   	ret    
80104342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104350 <getpinfo>:

int
getpinfo(struct pstat* ps) {
80104350:	f3 0f 1e fb          	endbr32 
80104354:	55                   	push   %ebp
80104355:	89 e5                	mov    %esp,%ebp
80104357:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
  struct proc *p;
  acquire(&ptable.lock);
8010435a:	68 e0 46 11 80       	push   $0x801146e0
8010435f:	e8 fc 03 00 00       	call   80104760 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104364:	8b 55 08             	mov    0x8(%ebp),%edx
80104367:	83 c4 10             	add    $0x10,%esp
8010436a:	b8 14 47 11 80       	mov    $0x80114714,%eax
8010436f:	90                   	nop
    ps->pid[i] = p->pid;
80104370:	8b 48 14             	mov    0x14(%eax),%ecx
80104373:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
    ps->inuse[i] = p->state != UNUSED;
80104379:	31 c9                	xor    %ecx,%ecx
8010437b:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
8010437f:	0f 95 c1             	setne  %cl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104382:	05 88 00 00 00       	add    $0x88,%eax
80104387:	83 c2 04             	add    $0x4,%edx
    ps->inuse[i] = p->state != UNUSED;
8010438a:	89 4a fc             	mov    %ecx,-0x4(%edx)
    ps->tickets[i] = p->tickets;
8010438d:	8b 48 f8             	mov    -0x8(%eax),%ecx
80104390:	89 8a fc 00 00 00    	mov    %ecx,0xfc(%edx)
    ps->ticks[i] = p->ticks;
80104396:	8b 48 fc             	mov    -0x4(%eax),%ecx
80104399:	89 8a fc 02 00 00    	mov    %ecx,0x2fc(%edx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010439f:	3d 14 69 11 80       	cmp    $0x80116914,%eax
801043a4:	75 ca                	jne    80104370 <getpinfo+0x20>
     
    i++;
  }
  release(&ptable.lock);
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	68 e0 46 11 80       	push   $0x801146e0
801043ae:	e8 6d 04 00 00       	call   80104820 <release>
  return 0;
}
801043b3:	31 c0                	xor    %eax,%eax
801043b5:	c9                   	leave  
801043b6:	c3                   	ret    
801043b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043be:	66 90                	xchg   %ax,%ax

801043c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	57                   	push   %edi
801043c8:	56                   	push   %esi
801043c9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043cc:	53                   	push   %ebx
801043cd:	bb 84 47 11 80       	mov    $0x80114784,%ebx
801043d2:	83 ec 3c             	sub    $0x3c,%esp
801043d5:	eb 2b                	jmp    80104402 <procdump+0x42>
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 a7 81 10 80       	push   $0x801081a7
801043e8:	e8 c3 c2 ff ff       	call   801006b0 <cprintf>
801043ed:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801043f6:	81 fb 84 69 11 80    	cmp    $0x80116984,%ebx
801043fc:	0f 84 8e 00 00 00    	je     80104490 <procdump+0xd0>
    if(p->state == UNUSED)
80104402:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104405:	85 c0                	test   %eax,%eax
80104407:	74 e7                	je     801043f0 <procdump+0x30>
      state = "???";
80104409:	ba 2b 7e 10 80       	mov    $0x80107e2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010440e:	83 f8 05             	cmp    $0x5,%eax
80104411:	77 11                	ja     80104424 <procdump+0x64>
80104413:	8b 14 85 8c 7e 10 80 	mov    -0x7fef8174(,%eax,4),%edx
      state = "???";
8010441a:	b8 2b 7e 10 80       	mov    $0x80107e2b,%eax
8010441f:	85 d2                	test   %edx,%edx
80104421:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104424:	53                   	push   %ebx
80104425:	52                   	push   %edx
80104426:	ff 73 a4             	pushl  -0x5c(%ebx)
80104429:	68 2f 7e 10 80       	push   $0x80107e2f
8010442e:	e8 7d c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104433:	83 c4 10             	add    $0x10,%esp
80104436:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010443a:	75 a4                	jne    801043e0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010443c:	83 ec 08             	sub    $0x8,%esp
8010443f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104442:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104445:	50                   	push   %eax
80104446:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104449:	8b 40 0c             	mov    0xc(%eax),%eax
8010444c:	83 c0 08             	add    $0x8,%eax
8010444f:	50                   	push   %eax
80104450:	e8 ab 01 00 00       	call   80104600 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104455:	83 c4 10             	add    $0x10,%esp
80104458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop
80104460:	8b 17                	mov    (%edi),%edx
80104462:	85 d2                	test   %edx,%edx
80104464:	0f 84 76 ff ff ff    	je     801043e0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010446a:	83 ec 08             	sub    $0x8,%esp
8010446d:	83 c7 04             	add    $0x4,%edi
80104470:	52                   	push   %edx
80104471:	68 81 78 10 80       	push   $0x80107881
80104476:	e8 35 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	39 fe                	cmp    %edi,%esi
80104480:	75 de                	jne    80104460 <procdump+0xa0>
80104482:	e9 59 ff ff ff       	jmp    801043e0 <procdump+0x20>
80104487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448e:	66 90                	xchg   %ax,%ax
  }
}
80104490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104493:	5b                   	pop    %ebx
80104494:	5e                   	pop    %esi
80104495:	5f                   	pop    %edi
80104496:	5d                   	pop    %ebp
80104497:	c3                   	ret    
80104498:	66 90                	xchg   %ax,%ax
8010449a:	66 90                	xchg   %ax,%ax
8010449c:	66 90                	xchg   %ax,%ax
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	53                   	push   %ebx
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044ae:	68 a4 7e 10 80       	push   $0x80107ea4
801044b3:	8d 43 04             	lea    0x4(%ebx),%eax
801044b6:	50                   	push   %eax
801044b7:	e8 24 01 00 00       	call   801045e0 <initlock>
  lk->name = name;
801044bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044c5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044c8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044cf:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d5:	c9                   	leave  
801044d6:	c3                   	ret    
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax

801044e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	56                   	push   %esi
801044e8:	53                   	push   %ebx
801044e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044ec:	8d 73 04             	lea    0x4(%ebx),%esi
801044ef:	83 ec 0c             	sub    $0xc,%esp
801044f2:	56                   	push   %esi
801044f3:	e8 68 02 00 00       	call   80104760 <acquire>
  while (lk->locked) {
801044f8:	8b 13                	mov    (%ebx),%edx
801044fa:	83 c4 10             	add    $0x10,%esp
801044fd:	85 d2                	test   %edx,%edx
801044ff:	74 1a                	je     8010451b <acquiresleep+0x3b>
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104508:	83 ec 08             	sub    $0x8,%esp
8010450b:	56                   	push   %esi
8010450c:	53                   	push   %ebx
8010450d:	e8 1e fb ff ff       	call   80104030 <sleep>
  while (lk->locked) {
80104512:	8b 03                	mov    (%ebx),%eax
80104514:	83 c4 10             	add    $0x10,%esp
80104517:	85 c0                	test   %eax,%eax
80104519:	75 ed                	jne    80104508 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010451b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104521:	e8 ca f4 ff ff       	call   801039f0 <myproc>
80104526:	8b 40 14             	mov    0x14(%eax),%eax
80104529:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010452c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010452f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	5d                   	pop    %ebp
  release(&lk->lk);
80104535:	e9 e6 02 00 00       	jmp    80104820 <release>
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
80104545:	89 e5                	mov    %esp,%ebp
80104547:	56                   	push   %esi
80104548:	53                   	push   %ebx
80104549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010454c:	8d 73 04             	lea    0x4(%ebx),%esi
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	56                   	push   %esi
80104553:	e8 08 02 00 00       	call   80104760 <acquire>
  lk->locked = 0;
80104558:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010455e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104565:	89 1c 24             	mov    %ebx,(%esp)
80104568:	e8 83 fc ff ff       	call   801041f0 <wakeup>
  release(&lk->lk);
8010456d:	89 75 08             	mov    %esi,0x8(%ebp)
80104570:	83 c4 10             	add    $0x10,%esp
}
80104573:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104576:	5b                   	pop    %ebx
80104577:	5e                   	pop    %esi
80104578:	5d                   	pop    %ebp
  release(&lk->lk);
80104579:	e9 a2 02 00 00       	jmp    80104820 <release>
8010457e:	66 90                	xchg   %ax,%ax

80104580 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	57                   	push   %edi
80104588:	31 ff                	xor    %edi,%edi
8010458a:	56                   	push   %esi
8010458b:	53                   	push   %ebx
8010458c:	83 ec 18             	sub    $0x18,%esp
8010458f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104592:	8d 73 04             	lea    0x4(%ebx),%esi
80104595:	56                   	push   %esi
80104596:	e8 c5 01 00 00       	call   80104760 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010459b:	8b 03                	mov    (%ebx),%eax
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	85 c0                	test   %eax,%eax
801045a2:	75 1c                	jne    801045c0 <holdingsleep+0x40>
  release(&lk->lk);
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	56                   	push   %esi
801045a8:	e8 73 02 00 00       	call   80104820 <release>
  return r;
}
801045ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b0:	89 f8                	mov    %edi,%eax
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5f                   	pop    %edi
801045b5:	5d                   	pop    %ebp
801045b6:	c3                   	ret    
801045b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045be:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801045c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045c3:	e8 28 f4 ff ff       	call   801039f0 <myproc>
801045c8:	39 58 14             	cmp    %ebx,0x14(%eax)
801045cb:	0f 94 c0             	sete   %al
801045ce:	0f b6 c0             	movzbl %al,%eax
801045d1:	89 c7                	mov    %eax,%edi
801045d3:	eb cf                	jmp    801045a4 <holdingsleep+0x24>
801045d5:	66 90                	xchg   %ax,%ax
801045d7:	66 90                	xchg   %ax,%ax
801045d9:	66 90                	xchg   %ax,%ax
801045db:	66 90                	xchg   %ax,%ax
801045dd:	66 90                	xchg   %ax,%ax
801045df:	90                   	nop

801045e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045f3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045fd:	5d                   	pop    %ebp
801045fe:	c3                   	ret    
801045ff:	90                   	nop

80104600 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104605:	31 d2                	xor    %edx,%edx
{
80104607:	89 e5                	mov    %esp,%ebp
80104609:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010460a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010460d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104610:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104617:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104618:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010461e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104624:	77 1a                	ja     80104640 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104626:	8b 58 04             	mov    0x4(%eax),%ebx
80104629:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010462c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010462f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104631:	83 fa 0a             	cmp    $0xa,%edx
80104634:	75 e2                	jne    80104618 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104636:	5b                   	pop    %ebx
80104637:	5d                   	pop    %ebp
80104638:	c3                   	ret    
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104640:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104643:	8d 51 28             	lea    0x28(%ecx),%edx
80104646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104656:	83 c0 04             	add    $0x4,%eax
80104659:	39 d0                	cmp    %edx,%eax
8010465b:	75 f3                	jne    80104650 <getcallerpcs+0x50>
}
8010465d:	5b                   	pop    %ebx
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret    

80104660 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	53                   	push   %ebx
80104668:	83 ec 04             	sub    $0x4,%esp
8010466b:	9c                   	pushf  
8010466c:	5b                   	pop    %ebx
  asm volatile("cli");
8010466d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010466e:	e8 ed f2 ff ff       	call   80103960 <mycpu>
80104673:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104679:	85 c0                	test   %eax,%eax
8010467b:	74 13                	je     80104690 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010467d:	e8 de f2 ff ff       	call   80103960 <mycpu>
80104682:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104689:	83 c4 04             	add    $0x4,%esp
8010468c:	5b                   	pop    %ebx
8010468d:	5d                   	pop    %ebp
8010468e:	c3                   	ret    
8010468f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104690:	e8 cb f2 ff ff       	call   80103960 <mycpu>
80104695:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010469b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046a1:	eb da                	jmp    8010467d <pushcli+0x1d>
801046a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <popcli>:

void
popcli(void)
{
801046b0:	f3 0f 1e fb          	endbr32 
801046b4:	55                   	push   %ebp
801046b5:	89 e5                	mov    %esp,%ebp
801046b7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046ba:	9c                   	pushf  
801046bb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046bc:	f6 c4 02             	test   $0x2,%ah
801046bf:	75 31                	jne    801046f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046c1:	e8 9a f2 ff ff       	call   80103960 <mycpu>
801046c6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046cd:	78 30                	js     801046ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046cf:	e8 8c f2 ff ff       	call   80103960 <mycpu>
801046d4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046da:	85 d2                	test   %edx,%edx
801046dc:	74 02                	je     801046e0 <popcli+0x30>
    sti();
}
801046de:	c9                   	leave  
801046df:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046e0:	e8 7b f2 ff ff       	call   80103960 <mycpu>
801046e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046eb:	85 c0                	test   %eax,%eax
801046ed:	74 ef                	je     801046de <popcli+0x2e>
  asm volatile("sti");
801046ef:	fb                   	sti    
}
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
    panic("popcli - interruptible");
801046f2:	83 ec 0c             	sub    $0xc,%esp
801046f5:	68 af 7e 10 80       	push   $0x80107eaf
801046fa:	e8 91 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046ff:	83 ec 0c             	sub    $0xc,%esp
80104702:	68 c6 7e 10 80       	push   $0x80107ec6
80104707:	e8 84 bc ff ff       	call   80100390 <panic>
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <holding>:
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	56                   	push   %esi
80104718:	53                   	push   %ebx
80104719:	8b 75 08             	mov    0x8(%ebp),%esi
8010471c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010471e:	e8 3d ff ff ff       	call   80104660 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104723:	8b 06                	mov    (%esi),%eax
80104725:	85 c0                	test   %eax,%eax
80104727:	75 0f                	jne    80104738 <holding+0x28>
  popcli();
80104729:	e8 82 ff ff ff       	call   801046b0 <popcli>
}
8010472e:	89 d8                	mov    %ebx,%eax
80104730:	5b                   	pop    %ebx
80104731:	5e                   	pop    %esi
80104732:	5d                   	pop    %ebp
80104733:	c3                   	ret    
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104738:	8b 5e 08             	mov    0x8(%esi),%ebx
8010473b:	e8 20 f2 ff ff       	call   80103960 <mycpu>
80104740:	39 c3                	cmp    %eax,%ebx
80104742:	0f 94 c3             	sete   %bl
  popcli();
80104745:	e8 66 ff ff ff       	call   801046b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010474a:	0f b6 db             	movzbl %bl,%ebx
}
8010474d:	89 d8                	mov    %ebx,%eax
8010474f:	5b                   	pop    %ebx
80104750:	5e                   	pop    %esi
80104751:	5d                   	pop    %ebp
80104752:	c3                   	ret    
80104753:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104760 <acquire>:
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	56                   	push   %esi
80104768:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104769:	e8 f2 fe ff ff       	call   80104660 <pushcli>
  if(holding(lk))
8010476e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104771:	83 ec 0c             	sub    $0xc,%esp
80104774:	53                   	push   %ebx
80104775:	e8 96 ff ff ff       	call   80104710 <holding>
8010477a:	83 c4 10             	add    $0x10,%esp
8010477d:	85 c0                	test   %eax,%eax
8010477f:	0f 85 7f 00 00 00    	jne    80104804 <acquire+0xa4>
80104785:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104787:	ba 01 00 00 00       	mov    $0x1,%edx
8010478c:	eb 05                	jmp    80104793 <acquire+0x33>
8010478e:	66 90                	xchg   %ax,%ax
80104790:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104793:	89 d0                	mov    %edx,%eax
80104795:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x30>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 b7 f1 ff ff       	call   80103960 <mycpu>
801047a9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047ac:	89 e8                	mov    %ebp,%eax
801047ae:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801047b6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801047bc:	77 22                	ja     801047e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801047be:	8b 50 04             	mov    0x4(%eax),%edx
801047c1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801047c5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801047c8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047ca:	83 fe 0a             	cmp    $0xa,%esi
801047cd:	75 e1                	jne    801047b0 <acquire+0x50>
}
801047cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801047e0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801047e4:	83 c3 34             	add    $0x34,%ebx
801047e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047f6:	83 c0 04             	add    $0x4,%eax
801047f9:	39 d8                	cmp    %ebx,%eax
801047fb:	75 f3                	jne    801047f0 <acquire+0x90>
}
801047fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104800:	5b                   	pop    %ebx
80104801:	5e                   	pop    %esi
80104802:	5d                   	pop    %ebp
80104803:	c3                   	ret    
    panic("acquire");
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	68 cd 7e 10 80       	push   $0x80107ecd
8010480c:	e8 7f bb ff ff       	call   80100390 <panic>
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <release>:
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	53                   	push   %ebx
80104828:	83 ec 10             	sub    $0x10,%esp
8010482b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010482e:	53                   	push   %ebx
8010482f:	e8 dc fe ff ff       	call   80104710 <holding>
80104834:	83 c4 10             	add    $0x10,%esp
80104837:	85 c0                	test   %eax,%eax
80104839:	74 22                	je     8010485d <release+0x3d>
  lk->pcs[0] = 0;
8010483b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104842:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104849:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010484e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104857:	c9                   	leave  
  popcli();
80104858:	e9 53 fe ff ff       	jmp    801046b0 <popcli>
    panic("release");
8010485d:	83 ec 0c             	sub    $0xc,%esp
80104860:	68 d5 7e 10 80       	push   $0x80107ed5
80104865:	e8 26 bb ff ff       	call   80100390 <panic>
8010486a:	66 90                	xchg   %ax,%ax
8010486c:	66 90                	xchg   %ax,%ax
8010486e:	66 90                	xchg   %ax,%ax

80104870 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	57                   	push   %edi
80104878:	8b 55 08             	mov    0x8(%ebp),%edx
8010487b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010487e:	53                   	push   %ebx
8010487f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104882:	89 d7                	mov    %edx,%edi
80104884:	09 cf                	or     %ecx,%edi
80104886:	83 e7 03             	and    $0x3,%edi
80104889:	75 25                	jne    801048b0 <memset+0x40>
    c &= 0xFF;
8010488b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010488e:	c1 e0 18             	shl    $0x18,%eax
80104891:	89 fb                	mov    %edi,%ebx
80104893:	c1 e9 02             	shr    $0x2,%ecx
80104896:	c1 e3 10             	shl    $0x10,%ebx
80104899:	09 d8                	or     %ebx,%eax
8010489b:	09 f8                	or     %edi,%eax
8010489d:	c1 e7 08             	shl    $0x8,%edi
801048a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048a2:	89 d7                	mov    %edx,%edi
801048a4:	fc                   	cld    
801048a5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048a7:	5b                   	pop    %ebx
801048a8:	89 d0                	mov    %edx,%eax
801048aa:	5f                   	pop    %edi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret    
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801048b0:	89 d7                	mov    %edx,%edi
801048b2:	fc                   	cld    
801048b3:	f3 aa                	rep stos %al,%es:(%edi)
801048b5:	5b                   	pop    %ebx
801048b6:	89 d0                	mov    %edx,%eax
801048b8:	5f                   	pop    %edi
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	56                   	push   %esi
801048c8:	8b 75 10             	mov    0x10(%ebp),%esi
801048cb:	8b 55 08             	mov    0x8(%ebp),%edx
801048ce:	53                   	push   %ebx
801048cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048d2:	85 f6                	test   %esi,%esi
801048d4:	74 2a                	je     80104900 <memcmp+0x40>
801048d6:	01 c6                	add    %eax,%esi
801048d8:	eb 10                	jmp    801048ea <memcmp+0x2a>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048e0:	83 c0 01             	add    $0x1,%eax
801048e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048e6:	39 f0                	cmp    %esi,%eax
801048e8:	74 16                	je     80104900 <memcmp+0x40>
    if(*s1 != *s2)
801048ea:	0f b6 0a             	movzbl (%edx),%ecx
801048ed:	0f b6 18             	movzbl (%eax),%ebx
801048f0:	38 d9                	cmp    %bl,%cl
801048f2:	74 ec                	je     801048e0 <memcmp+0x20>
      return *s1 - *s2;
801048f4:	0f b6 c1             	movzbl %cl,%eax
801048f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	5b                   	pop    %ebx
  return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	57                   	push   %edi
80104918:	8b 55 08             	mov    0x8(%ebp),%edx
8010491b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010491e:	56                   	push   %esi
8010491f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104922:	39 d6                	cmp    %edx,%esi
80104924:	73 2a                	jae    80104950 <memmove+0x40>
80104926:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104929:	39 fa                	cmp    %edi,%edx
8010492b:	73 23                	jae    80104950 <memmove+0x40>
8010492d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104930:	85 c9                	test   %ecx,%ecx
80104932:	74 13                	je     80104947 <memmove+0x37>
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104938:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010493c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010493f:	83 e8 01             	sub    $0x1,%eax
80104942:	83 f8 ff             	cmp    $0xffffffff,%eax
80104945:	75 f1                	jne    80104938 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104947:	5e                   	pop    %esi
80104948:	89 d0                	mov    %edx,%eax
8010494a:	5f                   	pop    %edi
8010494b:	5d                   	pop    %ebp
8010494c:	c3                   	ret    
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104950:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104953:	89 d7                	mov    %edx,%edi
80104955:	85 c9                	test   %ecx,%ecx
80104957:	74 ee                	je     80104947 <memmove+0x37>
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104960:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104961:	39 f0                	cmp    %esi,%eax
80104963:	75 fb                	jne    80104960 <memmove+0x50>
}
80104965:	5e                   	pop    %esi
80104966:	89 d0                	mov    %edx,%eax
80104968:	5f                   	pop    %edi
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop

80104970 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104970:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104974:	eb 9a                	jmp    80104910 <memmove>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	56                   	push   %esi
80104988:	8b 75 10             	mov    0x10(%ebp),%esi
8010498b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010498e:	53                   	push   %ebx
8010498f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104992:	85 f6                	test   %esi,%esi
80104994:	74 32                	je     801049c8 <strncmp+0x48>
80104996:	01 c6                	add    %eax,%esi
80104998:	eb 14                	jmp    801049ae <strncmp+0x2e>
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049a0:	38 da                	cmp    %bl,%dl
801049a2:	75 14                	jne    801049b8 <strncmp+0x38>
    n--, p++, q++;
801049a4:	83 c0 01             	add    $0x1,%eax
801049a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049aa:	39 f0                	cmp    %esi,%eax
801049ac:	74 1a                	je     801049c8 <strncmp+0x48>
801049ae:	0f b6 11             	movzbl (%ecx),%edx
801049b1:	0f b6 18             	movzbl (%eax),%ebx
801049b4:	84 d2                	test   %dl,%dl
801049b6:	75 e8                	jne    801049a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049b8:	0f b6 c2             	movzbl %dl,%eax
801049bb:	29 d8                	sub    %ebx,%eax
}
801049bd:	5b                   	pop    %ebx
801049be:	5e                   	pop    %esi
801049bf:	5d                   	pop    %ebp
801049c0:	c3                   	ret    
801049c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c8:	5b                   	pop    %ebx
    return 0;
801049c9:	31 c0                	xor    %eax,%eax
}
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret    
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	57                   	push   %edi
801049d8:	56                   	push   %esi
801049d9:	8b 75 08             	mov    0x8(%ebp),%esi
801049dc:	53                   	push   %ebx
801049dd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049e0:	89 f2                	mov    %esi,%edx
801049e2:	eb 1b                	jmp    801049ff <strncpy+0x2f>
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049ef:	83 c2 01             	add    $0x1,%edx
801049f2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801049f6:	89 f9                	mov    %edi,%ecx
801049f8:	88 4a ff             	mov    %cl,-0x1(%edx)
801049fb:	84 c9                	test   %cl,%cl
801049fd:	74 09                	je     80104a08 <strncpy+0x38>
801049ff:	89 c3                	mov    %eax,%ebx
80104a01:	83 e8 01             	sub    $0x1,%eax
80104a04:	85 db                	test   %ebx,%ebx
80104a06:	7f e0                	jg     801049e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a08:	89 d1                	mov    %edx,%ecx
80104a0a:	85 c0                	test   %eax,%eax
80104a0c:	7e 15                	jle    80104a23 <strncpy+0x53>
80104a0e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104a10:	83 c1 01             	add    $0x1,%ecx
80104a13:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104a17:	89 c8                	mov    %ecx,%eax
80104a19:	f7 d0                	not    %eax
80104a1b:	01 d0                	add    %edx,%eax
80104a1d:	01 d8                	add    %ebx,%eax
80104a1f:	85 c0                	test   %eax,%eax
80104a21:	7f ed                	jg     80104a10 <strncpy+0x40>
  return os;
}
80104a23:	5b                   	pop    %ebx
80104a24:	89 f0                	mov    %esi,%eax
80104a26:	5e                   	pop    %esi
80104a27:	5f                   	pop    %edi
80104a28:	5d                   	pop    %ebp
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	56                   	push   %esi
80104a38:	8b 55 10             	mov    0x10(%ebp),%edx
80104a3b:	8b 75 08             	mov    0x8(%ebp),%esi
80104a3e:	53                   	push   %ebx
80104a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a42:	85 d2                	test   %edx,%edx
80104a44:	7e 21                	jle    80104a67 <safestrcpy+0x37>
80104a46:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a4a:	89 f2                	mov    %esi,%edx
80104a4c:	eb 12                	jmp    80104a60 <safestrcpy+0x30>
80104a4e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a50:	0f b6 08             	movzbl (%eax),%ecx
80104a53:	83 c0 01             	add    $0x1,%eax
80104a56:	83 c2 01             	add    $0x1,%edx
80104a59:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a5c:	84 c9                	test   %cl,%cl
80104a5e:	74 04                	je     80104a64 <safestrcpy+0x34>
80104a60:	39 d8                	cmp    %ebx,%eax
80104a62:	75 ec                	jne    80104a50 <safestrcpy+0x20>
    ;
  *s = 0;
80104a64:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a67:	89 f0                	mov    %esi,%eax
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <strlen>:

int
strlen(const char *s)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a75:	31 c0                	xor    %eax,%eax
{
80104a77:	89 e5                	mov    %esp,%ebp
80104a79:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a7c:	80 3a 00             	cmpb   $0x0,(%edx)
80104a7f:	74 10                	je     80104a91 <strlen+0x21>
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a88:	83 c0 01             	add    $0x1,%eax
80104a8b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a8f:	75 f7                	jne    80104a88 <strlen+0x18>
    ;
  return n;
}
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    

80104a93 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a93:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a97:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a9b:	55                   	push   %ebp
  pushl %ebx
80104a9c:	53                   	push   %ebx
  pushl %esi
80104a9d:	56                   	push   %esi
  pushl %edi
80104a9e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a9f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104aa1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104aa3:	5f                   	pop    %edi
  popl %esi
80104aa4:	5e                   	pop    %esi
  popl %ebx
80104aa5:	5b                   	pop    %ebx
  popl %ebp
80104aa6:	5d                   	pop    %ebp
  ret
80104aa7:	c3                   	ret    
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	53                   	push   %ebx
80104ab8:	83 ec 04             	sub    $0x4,%esp
80104abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104abe:	e8 2d ef ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ac3:	8b 00                	mov    (%eax),%eax
80104ac5:	39 d8                	cmp    %ebx,%eax
80104ac7:	76 17                	jbe    80104ae0 <fetchint+0x30>
80104ac9:	8d 53 04             	lea    0x4(%ebx),%edx
80104acc:	39 d0                	cmp    %edx,%eax
80104ace:	72 10                	jb     80104ae0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ad3:	8b 13                	mov    (%ebx),%edx
80104ad5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ad7:	31 c0                	xor    %eax,%eax
}
80104ad9:	83 c4 04             	add    $0x4,%esp
80104adc:	5b                   	pop    %ebx
80104add:	5d                   	pop    %ebp
80104ade:	c3                   	ret    
80104adf:	90                   	nop
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae5:	eb f2                	jmp    80104ad9 <fetchint+0x29>
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	53                   	push   %ebx
80104af8:	83 ec 04             	sub    $0x4,%esp
80104afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104afe:	e8 ed ee ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz)
80104b03:	39 18                	cmp    %ebx,(%eax)
80104b05:	76 31                	jbe    80104b38 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104b07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b0e:	39 d3                	cmp    %edx,%ebx
80104b10:	73 26                	jae    80104b38 <fetchstr+0x48>
80104b12:	89 d8                	mov    %ebx,%eax
80104b14:	eb 11                	jmp    80104b27 <fetchstr+0x37>
80104b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	83 c0 01             	add    $0x1,%eax
80104b23:	39 c2                	cmp    %eax,%edx
80104b25:	76 11                	jbe    80104b38 <fetchstr+0x48>
    if(*s == 0)
80104b27:	80 38 00             	cmpb   $0x0,(%eax)
80104b2a:	75 f4                	jne    80104b20 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104b2c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104b2f:	29 d8                	sub    %ebx,%eax
}
80104b31:	5b                   	pop    %ebx
80104b32:	5d                   	pop    %ebp
80104b33:	c3                   	ret    
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b38:	83 c4 04             	add    $0x4,%esp
    return -1;
80104b3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b40:	5b                   	pop    %ebx
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	56                   	push   %esi
80104b58:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b59:	e8 92 ee ff ff       	call   801039f0 <myproc>
80104b5e:	8b 55 08             	mov    0x8(%ebp),%edx
80104b61:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b64:	8b 40 44             	mov    0x44(%eax),%eax
80104b67:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b6a:	e8 81 ee ff ff       	call   801039f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b6f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b72:	8b 00                	mov    (%eax),%eax
80104b74:	39 c6                	cmp    %eax,%esi
80104b76:	73 18                	jae    80104b90 <argint+0x40>
80104b78:	8d 53 08             	lea    0x8(%ebx),%edx
80104b7b:	39 d0                	cmp    %edx,%eax
80104b7d:	72 11                	jb     80104b90 <argint+0x40>
  *ip = *(int*)(addr);
80104b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b82:	8b 53 04             	mov    0x4(%ebx),%edx
80104b85:	89 10                	mov    %edx,(%eax)
  return 0;
80104b87:	31 c0                	xor    %eax,%eax
}
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	eb f2                	jmp    80104b89 <argint+0x39>
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	56                   	push   %esi
80104ba8:	53                   	push   %ebx
80104ba9:	83 ec 10             	sub    $0x10,%esp
80104bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104baf:	e8 3c ee ff ff       	call   801039f0 <myproc>
 
  if(argint(n, &i) < 0)
80104bb4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104bb7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bbc:	50                   	push   %eax
80104bbd:	ff 75 08             	pushl  0x8(%ebp)
80104bc0:	e8 8b ff ff ff       	call   80104b50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	85 c0                	test   %eax,%eax
80104bca:	78 24                	js     80104bf0 <argptr+0x50>
80104bcc:	85 db                	test   %ebx,%ebx
80104bce:	78 20                	js     80104bf0 <argptr+0x50>
80104bd0:	8b 16                	mov    (%esi),%edx
80104bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd5:	39 c2                	cmp    %eax,%edx
80104bd7:	76 17                	jbe    80104bf0 <argptr+0x50>
80104bd9:	01 c3                	add    %eax,%ebx
80104bdb:	39 da                	cmp    %ebx,%edx
80104bdd:	72 11                	jb     80104bf0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104be2:	89 02                	mov    %eax,(%edx)
  return 0;
80104be4:	31 c0                	xor    %eax,%eax
}
80104be6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be9:	5b                   	pop    %ebx
80104bea:	5e                   	pop    %esi
80104beb:	5d                   	pop    %ebp
80104bec:	c3                   	ret    
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf5:	eb ef                	jmp    80104be6 <argptr+0x46>
80104bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0d:	50                   	push   %eax
80104c0e:	ff 75 08             	pushl  0x8(%ebp)
80104c11:	e8 3a ff ff ff       	call   80104b50 <argint>
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	85 c0                	test   %eax,%eax
80104c1b:	78 13                	js     80104c30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c1d:	83 ec 08             	sub    $0x8,%esp
80104c20:	ff 75 0c             	pushl  0xc(%ebp)
80104c23:	ff 75 f4             	pushl  -0xc(%ebp)
80104c26:	e8 c5 fe ff ff       	call   80104af0 <fetchstr>
80104c2b:	83 c4 10             	add    $0x10,%esp
}
80104c2e:	c9                   	leave  
80104c2f:	c3                   	ret    
80104c30:	c9                   	leave  
    return -1;
80104c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c36:	c3                   	ret    
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <syscall>:

};

void
syscall(void)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	53                   	push   %ebx
80104c48:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c4b:	e8 a0 ed ff ff       	call   801039f0 <myproc>
80104c50:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c52:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c55:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c58:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c5b:	83 fa 18             	cmp    $0x18,%edx
80104c5e:	77 20                	ja     80104c80 <syscall+0x40>
80104c60:	8b 14 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%edx
80104c67:	85 d2                	test   %edx,%edx
80104c69:	74 15                	je     80104c80 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c6b:	ff d2                	call   *%edx
80104c6d:	89 c2                	mov    %eax,%edx
80104c6f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c72:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c78:	c9                   	leave  
80104c79:	c3                   	ret    
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c81:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c84:	50                   	push   %eax
80104c85:	ff 73 14             	pushl  0x14(%ebx)
80104c88:	68 dd 7e 10 80       	push   $0x80107edd
80104c8d:	e8 1e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c92:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c95:	83 c4 10             	add    $0x10,%esp
80104c98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca2:	c9                   	leave  
80104ca3:	c3                   	ret    
80104ca4:	66 90                	xchg   %ax,%ax
80104ca6:	66 90                	xchg   %ax,%ax
80104ca8:	66 90                	xchg   %ax,%ax
80104caa:	66 90                	xchg   %ax,%ax
80104cac:	66 90                	xchg   %ax,%ax
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cb5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cb8:	53                   	push   %ebx
80104cb9:	83 ec 34             	sub    $0x34,%esp
80104cbc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cc2:	57                   	push   %edi
80104cc3:	50                   	push   %eax
{
80104cc4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cc7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cca:	e8 91 d3 ff ff       	call   80102060 <nameiparent>
80104ccf:	83 c4 10             	add    $0x10,%esp
80104cd2:	85 c0                	test   %eax,%eax
80104cd4:	0f 84 46 01 00 00    	je     80104e20 <create+0x170>
    return 0;
  ilock(dp);
80104cda:	83 ec 0c             	sub    $0xc,%esp
80104cdd:	89 c3                	mov    %eax,%ebx
80104cdf:	50                   	push   %eax
80104ce0:	e8 8b ca ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ce5:	83 c4 0c             	add    $0xc,%esp
80104ce8:	6a 00                	push   $0x0
80104cea:	57                   	push   %edi
80104ceb:	53                   	push   %ebx
80104cec:	e8 cf cf ff ff       	call   80101cc0 <dirlookup>
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	89 c6                	mov    %eax,%esi
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	74 56                	je     80104d50 <create+0xa0>
    iunlockput(dp);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	53                   	push   %ebx
80104cfe:	e8 0d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d03:	89 34 24             	mov    %esi,(%esp)
80104d06:	e8 65 ca ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d0b:	83 c4 10             	add    $0x10,%esp
80104d0e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d13:	75 1b                	jne    80104d30 <create+0x80>
80104d15:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d1a:	75 14                	jne    80104d30 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1f:	89 f0                	mov    %esi,%eax
80104d21:	5b                   	pop    %ebx
80104d22:	5e                   	pop    %esi
80104d23:	5f                   	pop    %edi
80104d24:	5d                   	pop    %ebp
80104d25:	c3                   	ret    
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d30:	83 ec 0c             	sub    $0xc,%esp
80104d33:	56                   	push   %esi
    return 0;
80104d34:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d36:	e8 d5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d3b:	83 c4 10             	add    $0x10,%esp
}
80104d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d41:	89 f0                	mov    %esi,%eax
80104d43:	5b                   	pop    %ebx
80104d44:	5e                   	pop    %esi
80104d45:	5f                   	pop    %edi
80104d46:	5d                   	pop    %ebp
80104d47:	c3                   	ret    
80104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d54:	83 ec 08             	sub    $0x8,%esp
80104d57:	50                   	push   %eax
80104d58:	ff 33                	pushl  (%ebx)
80104d5a:	e8 91 c8 ff ff       	call   801015f0 <ialloc>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	89 c6                	mov    %eax,%esi
80104d64:	85 c0                	test   %eax,%eax
80104d66:	0f 84 cd 00 00 00    	je     80104e39 <create+0x189>
  ilock(ip);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	50                   	push   %eax
80104d70:	e8 fb c9 ff ff       	call   80101770 <ilock>
  ip->major = major;
80104d75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d79:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d81:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d85:	b8 01 00 00 00       	mov    $0x1,%eax
80104d8a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d8e:	89 34 24             	mov    %esi,(%esp)
80104d91:	e8 1a c9 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d9e:	74 30                	je     80104dd0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104da0:	83 ec 04             	sub    $0x4,%esp
80104da3:	ff 76 04             	pushl  0x4(%esi)
80104da6:	57                   	push   %edi
80104da7:	53                   	push   %ebx
80104da8:	e8 d3 d1 ff ff       	call   80101f80 <dirlink>
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 78                	js     80104e2c <create+0x17c>
  iunlockput(dp);
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	53                   	push   %ebx
80104db8:	e8 53 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104dbd:	83 c4 10             	add    $0x10,%esp
}
80104dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc3:	89 f0                	mov    %esi,%eax
80104dc5:	5b                   	pop    %ebx
80104dc6:	5e                   	pop    %esi
80104dc7:	5f                   	pop    %edi
80104dc8:	5d                   	pop    %ebp
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dd3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dd8:	53                   	push   %ebx
80104dd9:	e8 d2 c8 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dde:	83 c4 0c             	add    $0xc,%esp
80104de1:	ff 76 04             	pushl  0x4(%esi)
80104de4:	68 84 7f 10 80       	push   $0x80107f84
80104de9:	56                   	push   %esi
80104dea:	e8 91 d1 ff ff       	call   80101f80 <dirlink>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	78 18                	js     80104e0e <create+0x15e>
80104df6:	83 ec 04             	sub    $0x4,%esp
80104df9:	ff 73 04             	pushl  0x4(%ebx)
80104dfc:	68 83 7f 10 80       	push   $0x80107f83
80104e01:	56                   	push   %esi
80104e02:	e8 79 d1 ff ff       	call   80101f80 <dirlink>
80104e07:	83 c4 10             	add    $0x10,%esp
80104e0a:	85 c0                	test   %eax,%eax
80104e0c:	79 92                	jns    80104da0 <create+0xf0>
      panic("create dots");
80104e0e:	83 ec 0c             	sub    $0xc,%esp
80104e11:	68 77 7f 10 80       	push   $0x80107f77
80104e16:	e8 75 b5 ff ff       	call   80100390 <panic>
80104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
}
80104e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e23:	31 f6                	xor    %esi,%esi
}
80104e25:	5b                   	pop    %ebx
80104e26:	89 f0                	mov    %esi,%eax
80104e28:	5e                   	pop    %esi
80104e29:	5f                   	pop    %edi
80104e2a:	5d                   	pop    %ebp
80104e2b:	c3                   	ret    
    panic("create: dirlink");
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	68 86 7f 10 80       	push   $0x80107f86
80104e34:	e8 57 b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e39:	83 ec 0c             	sub    $0xc,%esp
80104e3c:	68 68 7f 10 80       	push   $0x80107f68
80104e41:	e8 4a b5 ff ff       	call   80100390 <panic>
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	89 d6                	mov    %edx,%esi
80104e56:	53                   	push   %ebx
80104e57:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e59:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e5c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5f:	50                   	push   %eax
80104e60:	6a 00                	push   $0x0
80104e62:	e8 e9 fc ff ff       	call   80104b50 <argint>
80104e67:	83 c4 10             	add    $0x10,%esp
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	78 2a                	js     80104e98 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e72:	77 24                	ja     80104e98 <argfd.constprop.0+0x48>
80104e74:	e8 77 eb ff ff       	call   801039f0 <myproc>
80104e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e7c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104e80:	85 c0                	test   %eax,%eax
80104e82:	74 14                	je     80104e98 <argfd.constprop.0+0x48>
  if(pfd)
80104e84:	85 db                	test   %ebx,%ebx
80104e86:	74 02                	je     80104e8a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e88:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e8a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e8c:	31 c0                	xor    %eax,%eax
}
80104e8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e91:	5b                   	pop    %ebx
80104e92:	5e                   	pop    %esi
80104e93:	5d                   	pop    %ebp
80104e94:	c3                   	ret    
80104e95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9d:	eb ef                	jmp    80104e8e <argfd.constprop.0+0x3e>
80104e9f:	90                   	nop

80104ea0 <sys_dup>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ea5:	31 c0                	xor    %eax,%eax
{
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	56                   	push   %esi
80104eaa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104eab:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104eae:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104eb1:	e8 9a ff ff ff       	call   80104e50 <argfd.constprop.0>
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 1e                	js     80104ed8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104eba:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ebd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ebf:	e8 2c eb ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104ec8:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104ecc:	85 d2                	test   %edx,%edx
80104ece:	74 20                	je     80104ef0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104ed0:	83 c3 01             	add    $0x1,%ebx
80104ed3:	83 fb 10             	cmp    $0x10,%ebx
80104ed6:	75 f0                	jne    80104ec8 <sys_dup+0x28>
}
80104ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104edb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ee0:	89 d8                	mov    %ebx,%eax
80104ee2:	5b                   	pop    %ebx
80104ee3:	5e                   	pop    %esi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ef0:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	ff 75 f4             	pushl  -0xc(%ebp)
80104efa:	e8 81 bf ff ff       	call   80100e80 <filedup>
  return fd;
80104eff:	83 c4 10             	add    $0x10,%esp
}
80104f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f05:	89 d8                	mov    %ebx,%eax
80104f07:	5b                   	pop    %ebx
80104f08:	5e                   	pop    %esi
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    
80104f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f0f:	90                   	nop

80104f10 <sys_read>:
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f15:	31 c0                	xor    %eax,%eax
{
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f1c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f1f:	e8 2c ff ff ff       	call   80104e50 <argfd.constprop.0>
80104f24:	85 c0                	test   %eax,%eax
80104f26:	78 48                	js     80104f70 <sys_read+0x60>
80104f28:	83 ec 08             	sub    $0x8,%esp
80104f2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f2e:	50                   	push   %eax
80104f2f:	6a 02                	push   $0x2
80104f31:	e8 1a fc ff ff       	call   80104b50 <argint>
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	85 c0                	test   %eax,%eax
80104f3b:	78 33                	js     80104f70 <sys_read+0x60>
80104f3d:	83 ec 04             	sub    $0x4,%esp
80104f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f43:	ff 75 f0             	pushl  -0x10(%ebp)
80104f46:	50                   	push   %eax
80104f47:	6a 01                	push   $0x1
80104f49:	e8 52 fc ff ff       	call   80104ba0 <argptr>
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	85 c0                	test   %eax,%eax
80104f53:	78 1b                	js     80104f70 <sys_read+0x60>
  return fileread(f, p, n);
80104f55:	83 ec 04             	sub    $0x4,%esp
80104f58:	ff 75 f0             	pushl  -0x10(%ebp)
80104f5b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f5e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f61:	e8 9a c0 ff ff       	call   80101000 <fileread>
80104f66:	83 c4 10             	add    $0x10,%esp
}
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
80104f70:	c9                   	leave  
    return -1;
80104f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f76:	c3                   	ret    
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <sys_write>:
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f85:	31 c0                	xor    %eax,%eax
{
80104f87:	89 e5                	mov    %esp,%ebp
80104f89:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f8c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f8f:	e8 bc fe ff ff       	call   80104e50 <argfd.constprop.0>
80104f94:	85 c0                	test   %eax,%eax
80104f96:	78 48                	js     80104fe0 <sys_write+0x60>
80104f98:	83 ec 08             	sub    $0x8,%esp
80104f9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f9e:	50                   	push   %eax
80104f9f:	6a 02                	push   $0x2
80104fa1:	e8 aa fb ff ff       	call   80104b50 <argint>
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	85 c0                	test   %eax,%eax
80104fab:	78 33                	js     80104fe0 <sys_write+0x60>
80104fad:	83 ec 04             	sub    $0x4,%esp
80104fb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb3:	ff 75 f0             	pushl  -0x10(%ebp)
80104fb6:	50                   	push   %eax
80104fb7:	6a 01                	push   $0x1
80104fb9:	e8 e2 fb ff ff       	call   80104ba0 <argptr>
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	78 1b                	js     80104fe0 <sys_write+0x60>
  return filewrite(f, p, n);
80104fc5:	83 ec 04             	sub    $0x4,%esp
80104fc8:	ff 75 f0             	pushl  -0x10(%ebp)
80104fcb:	ff 75 f4             	pushl  -0xc(%ebp)
80104fce:	ff 75 ec             	pushl  -0x14(%ebp)
80104fd1:	e8 ca c0 ff ff       	call   801010a0 <filewrite>
80104fd6:	83 c4 10             	add    $0x10,%esp
}
80104fd9:	c9                   	leave  
80104fda:	c3                   	ret    
80104fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop
80104fe0:	c9                   	leave  
    return -1;
80104fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe6:	c3                   	ret    
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <sys_close>:
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104ffa:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ffd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105000:	e8 4b fe ff ff       	call   80104e50 <argfd.constprop.0>
80105005:	85 c0                	test   %eax,%eax
80105007:	78 27                	js     80105030 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105009:	e8 e2 e9 ff ff       	call   801039f0 <myproc>
8010500e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105011:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105014:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
8010501b:	00 
  fileclose(f);
8010501c:	ff 75 f4             	pushl  -0xc(%ebp)
8010501f:	e8 ac be ff ff       	call   80100ed0 <fileclose>
  return 0;
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	31 c0                	xor    %eax,%eax
}
80105029:	c9                   	leave  
8010502a:	c3                   	ret    
8010502b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop
80105030:	c9                   	leave  
    return -1;
80105031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105036:	c3                   	ret    
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <sys_fstat>:
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105045:	31 c0                	xor    %eax,%eax
{
80105047:	89 e5                	mov    %esp,%ebp
80105049:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010504c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010504f:	e8 fc fd ff ff       	call   80104e50 <argfd.constprop.0>
80105054:	85 c0                	test   %eax,%eax
80105056:	78 30                	js     80105088 <sys_fstat+0x48>
80105058:	83 ec 04             	sub    $0x4,%esp
8010505b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505e:	6a 14                	push   $0x14
80105060:	50                   	push   %eax
80105061:	6a 01                	push   $0x1
80105063:	e8 38 fb ff ff       	call   80104ba0 <argptr>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	78 19                	js     80105088 <sys_fstat+0x48>
  return filestat(f, st);
8010506f:	83 ec 08             	sub    $0x8,%esp
80105072:	ff 75 f4             	pushl  -0xc(%ebp)
80105075:	ff 75 f0             	pushl  -0x10(%ebp)
80105078:	e8 33 bf ff ff       	call   80100fb0 <filestat>
8010507d:	83 c4 10             	add    $0x10,%esp
}
80105080:	c9                   	leave  
80105081:	c3                   	ret    
80105082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105088:	c9                   	leave  
    return -1;
80105089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010508e:	c3                   	ret    
8010508f:	90                   	nop

80105090 <sys_link>:
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	57                   	push   %edi
80105098:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105099:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010509c:	53                   	push   %ebx
8010509d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050a0:	50                   	push   %eax
801050a1:	6a 00                	push   $0x0
801050a3:	e8 58 fb ff ff       	call   80104c00 <argstr>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	85 c0                	test   %eax,%eax
801050ad:	0f 88 ff 00 00 00    	js     801051b2 <sys_link+0x122>
801050b3:	83 ec 08             	sub    $0x8,%esp
801050b6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050b9:	50                   	push   %eax
801050ba:	6a 01                	push   $0x1
801050bc:	e8 3f fb ff ff       	call   80104c00 <argstr>
801050c1:	83 c4 10             	add    $0x10,%esp
801050c4:	85 c0                	test   %eax,%eax
801050c6:	0f 88 e6 00 00 00    	js     801051b2 <sys_link+0x122>
  begin_op();
801050cc:	e8 bf dc ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
801050d1:	83 ec 0c             	sub    $0xc,%esp
801050d4:	ff 75 d4             	pushl  -0x2c(%ebp)
801050d7:	e8 64 cf ff ff       	call   80102040 <namei>
801050dc:	83 c4 10             	add    $0x10,%esp
801050df:	89 c3                	mov    %eax,%ebx
801050e1:	85 c0                	test   %eax,%eax
801050e3:	0f 84 e8 00 00 00    	je     801051d1 <sys_link+0x141>
  ilock(ip);
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	50                   	push   %eax
801050ed:	e8 7e c6 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050fa:	0f 84 b9 00 00 00    	je     801051b9 <sys_link+0x129>
  iupdate(ip);
80105100:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105103:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105108:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010510b:	53                   	push   %ebx
8010510c:	e8 9f c5 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105111:	89 1c 24             	mov    %ebx,(%esp)
80105114:	e8 37 c7 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105119:	58                   	pop    %eax
8010511a:	5a                   	pop    %edx
8010511b:	57                   	push   %edi
8010511c:	ff 75 d0             	pushl  -0x30(%ebp)
8010511f:	e8 3c cf ff ff       	call   80102060 <nameiparent>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	89 c6                	mov    %eax,%esi
80105129:	85 c0                	test   %eax,%eax
8010512b:	74 5f                	je     8010518c <sys_link+0xfc>
  ilock(dp);
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	50                   	push   %eax
80105131:	e8 3a c6 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105136:	8b 03                	mov    (%ebx),%eax
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	39 06                	cmp    %eax,(%esi)
8010513d:	75 41                	jne    80105180 <sys_link+0xf0>
8010513f:	83 ec 04             	sub    $0x4,%esp
80105142:	ff 73 04             	pushl  0x4(%ebx)
80105145:	57                   	push   %edi
80105146:	56                   	push   %esi
80105147:	e8 34 ce ff ff       	call   80101f80 <dirlink>
8010514c:	83 c4 10             	add    $0x10,%esp
8010514f:	85 c0                	test   %eax,%eax
80105151:	78 2d                	js     80105180 <sys_link+0xf0>
  iunlockput(dp);
80105153:	83 ec 0c             	sub    $0xc,%esp
80105156:	56                   	push   %esi
80105157:	e8 b4 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
8010515c:	89 1c 24             	mov    %ebx,(%esp)
8010515f:	e8 3c c7 ff ff       	call   801018a0 <iput>
  end_op();
80105164:	e8 97 dc ff ff       	call   80102e00 <end_op>
  return 0;
80105169:	83 c4 10             	add    $0x10,%esp
8010516c:	31 c0                	xor    %eax,%eax
}
8010516e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105171:	5b                   	pop    %ebx
80105172:	5e                   	pop    %esi
80105173:	5f                   	pop    %edi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    
80105176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	56                   	push   %esi
80105184:	e8 87 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105189:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	53                   	push   %ebx
80105190:	e8 db c5 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105195:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010519a:	89 1c 24             	mov    %ebx,(%esp)
8010519d:	e8 0e c5 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801051a2:	89 1c 24             	mov    %ebx,(%esp)
801051a5:	e8 66 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051aa:	e8 51 dc ff ff       	call   80102e00 <end_op>
  return -1;
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b7:	eb b5                	jmp    8010516e <sys_link+0xde>
    iunlockput(ip);
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	53                   	push   %ebx
801051bd:	e8 4e c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801051c2:	e8 39 dc ff ff       	call   80102e00 <end_op>
    return -1;
801051c7:	83 c4 10             	add    $0x10,%esp
801051ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cf:	eb 9d                	jmp    8010516e <sys_link+0xde>
    end_op();
801051d1:	e8 2a dc ff ff       	call   80102e00 <end_op>
    return -1;
801051d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051db:	eb 91                	jmp    8010516e <sys_link+0xde>
801051dd:	8d 76 00             	lea    0x0(%esi),%esi

801051e0 <sys_unlink>:
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	57                   	push   %edi
801051e8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051e9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051ec:	53                   	push   %ebx
801051ed:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051f0:	50                   	push   %eax
801051f1:	6a 00                	push   $0x0
801051f3:	e8 08 fa ff ff       	call   80104c00 <argstr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	0f 88 7d 01 00 00    	js     80105380 <sys_unlink+0x1a0>
  begin_op();
80105203:	e8 88 db ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105208:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010520b:	83 ec 08             	sub    $0x8,%esp
8010520e:	53                   	push   %ebx
8010520f:	ff 75 c0             	pushl  -0x40(%ebp)
80105212:	e8 49 ce ff ff       	call   80102060 <nameiparent>
80105217:	83 c4 10             	add    $0x10,%esp
8010521a:	89 c6                	mov    %eax,%esi
8010521c:	85 c0                	test   %eax,%eax
8010521e:	0f 84 66 01 00 00    	je     8010538a <sys_unlink+0x1aa>
  ilock(dp);
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	50                   	push   %eax
80105228:	e8 43 c5 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010522d:	58                   	pop    %eax
8010522e:	5a                   	pop    %edx
8010522f:	68 84 7f 10 80       	push   $0x80107f84
80105234:	53                   	push   %ebx
80105235:	e8 66 ca ff ff       	call   80101ca0 <namecmp>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	0f 84 03 01 00 00    	je     80105348 <sys_unlink+0x168>
80105245:	83 ec 08             	sub    $0x8,%esp
80105248:	68 83 7f 10 80       	push   $0x80107f83
8010524d:	53                   	push   %ebx
8010524e:	e8 4d ca ff ff       	call   80101ca0 <namecmp>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	0f 84 ea 00 00 00    	je     80105348 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010525e:	83 ec 04             	sub    $0x4,%esp
80105261:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105264:	50                   	push   %eax
80105265:	53                   	push   %ebx
80105266:	56                   	push   %esi
80105267:	e8 54 ca ff ff       	call   80101cc0 <dirlookup>
8010526c:	83 c4 10             	add    $0x10,%esp
8010526f:	89 c3                	mov    %eax,%ebx
80105271:	85 c0                	test   %eax,%eax
80105273:	0f 84 cf 00 00 00    	je     80105348 <sys_unlink+0x168>
  ilock(ip);
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	50                   	push   %eax
8010527d:	e8 ee c4 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010528a:	0f 8e 23 01 00 00    	jle    801053b3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105290:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105295:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105298:	74 66                	je     80105300 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010529a:	83 ec 04             	sub    $0x4,%esp
8010529d:	6a 10                	push   $0x10
8010529f:	6a 00                	push   $0x0
801052a1:	57                   	push   %edi
801052a2:	e8 c9 f5 ff ff       	call   80104870 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052a7:	6a 10                	push   $0x10
801052a9:	ff 75 c4             	pushl  -0x3c(%ebp)
801052ac:	57                   	push   %edi
801052ad:	56                   	push   %esi
801052ae:	e8 bd c8 ff ff       	call   80101b70 <writei>
801052b3:	83 c4 20             	add    $0x20,%esp
801052b6:	83 f8 10             	cmp    $0x10,%eax
801052b9:	0f 85 e7 00 00 00    	jne    801053a6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801052bf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c4:	0f 84 96 00 00 00    	je     80105360 <sys_unlink+0x180>
  iunlockput(dp);
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	56                   	push   %esi
801052ce:	e8 3d c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801052d3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 d0 c3 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801052e0:	89 1c 24             	mov    %ebx,(%esp)
801052e3:	e8 28 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052e8:	e8 13 db ff ff       	call   80102e00 <end_op>
  return 0;
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	31 c0                	xor    %eax,%eax
}
801052f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f5:	5b                   	pop    %ebx
801052f6:	5e                   	pop    %esi
801052f7:	5f                   	pop    %edi
801052f8:	5d                   	pop    %ebp
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105300:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105304:	76 94                	jbe    8010529a <sys_unlink+0xba>
80105306:	ba 20 00 00 00       	mov    $0x20,%edx
8010530b:	eb 0b                	jmp    80105318 <sys_unlink+0x138>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
80105310:	83 c2 10             	add    $0x10,%edx
80105313:	39 53 58             	cmp    %edx,0x58(%ebx)
80105316:	76 82                	jbe    8010529a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105318:	6a 10                	push   $0x10
8010531a:	52                   	push   %edx
8010531b:	57                   	push   %edi
8010531c:	53                   	push   %ebx
8010531d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105320:	e8 4b c7 ff ff       	call   80101a70 <readi>
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010532b:	83 f8 10             	cmp    $0x10,%eax
8010532e:	75 69                	jne    80105399 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105330:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105335:	74 d9                	je     80105310 <sys_unlink+0x130>
    iunlockput(ip);
80105337:	83 ec 0c             	sub    $0xc,%esp
8010533a:	53                   	push   %ebx
8010533b:	e8 d0 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105340:	83 c4 10             	add    $0x10,%esp
80105343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105347:	90                   	nop
  iunlockput(dp);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	56                   	push   %esi
8010534c:	e8 bf c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105351:	e8 aa da ff ff       	call   80102e00 <end_op>
  return -1;
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535e:	eb 92                	jmp    801052f2 <sys_unlink+0x112>
    iupdate(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105363:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105368:	56                   	push   %esi
80105369:	e8 42 c3 ff ff       	call   801016b0 <iupdate>
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	e9 54 ff ff ff       	jmp    801052ca <sys_unlink+0xea>
80105376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	e9 68 ff ff ff       	jmp    801052f2 <sys_unlink+0x112>
    end_op();
8010538a:	e8 71 da ff ff       	call   80102e00 <end_op>
    return -1;
8010538f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105394:	e9 59 ff ff ff       	jmp    801052f2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	68 a8 7f 10 80       	push   $0x80107fa8
801053a1:	e8 ea af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801053a6:	83 ec 0c             	sub    $0xc,%esp
801053a9:	68 ba 7f 10 80       	push   $0x80107fba
801053ae:	e8 dd af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801053b3:	83 ec 0c             	sub    $0xc,%esp
801053b6:	68 96 7f 10 80       	push   $0x80107f96
801053bb:	e8 d0 af ff ff       	call   80100390 <panic>

801053c0 <sys_open>:

int
sys_open(void)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	57                   	push   %edi
801053c8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053cc:	53                   	push   %ebx
801053cd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053d0:	50                   	push   %eax
801053d1:	6a 00                	push   $0x0
801053d3:	e8 28 f8 ff ff       	call   80104c00 <argstr>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	0f 88 8a 00 00 00    	js     8010546d <sys_open+0xad>
801053e3:	83 ec 08             	sub    $0x8,%esp
801053e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053e9:	50                   	push   %eax
801053ea:	6a 01                	push   $0x1
801053ec:	e8 5f f7 ff ff       	call   80104b50 <argint>
801053f1:	83 c4 10             	add    $0x10,%esp
801053f4:	85 c0                	test   %eax,%eax
801053f6:	78 75                	js     8010546d <sys_open+0xad>
    return -1;

  begin_op();
801053f8:	e8 93 d9 ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
801053fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105401:	75 75                	jne    80105478 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105403:	83 ec 0c             	sub    $0xc,%esp
80105406:	ff 75 e0             	pushl  -0x20(%ebp)
80105409:	e8 32 cc ff ff       	call   80102040 <namei>
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	89 c6                	mov    %eax,%esi
80105413:	85 c0                	test   %eax,%eax
80105415:	74 7e                	je     80105495 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105417:	83 ec 0c             	sub    $0xc,%esp
8010541a:	50                   	push   %eax
8010541b:	e8 50 c3 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105428:	0f 84 c2 00 00 00    	je     801054f0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010542e:	e8 dd b9 ff ff       	call   80100e10 <filealloc>
80105433:	89 c7                	mov    %eax,%edi
80105435:	85 c0                	test   %eax,%eax
80105437:	74 23                	je     8010545c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105439:	e8 b2 e5 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010543e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105440:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105444:	85 d2                	test   %edx,%edx
80105446:	74 60                	je     801054a8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	75 f0                	jne    80105440 <sys_open+0x80>
    if(f)
      fileclose(f);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	57                   	push   %edi
80105454:	e8 77 ba ff ff       	call   80100ed0 <fileclose>
80105459:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	56                   	push   %esi
80105460:	e8 ab c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105465:	e8 96 d9 ff ff       	call   80102e00 <end_op>
    return -1;
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105472:	eb 6d                	jmp    801054e1 <sys_open+0x121>
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010547e:	31 c9                	xor    %ecx,%ecx
80105480:	ba 02 00 00 00       	mov    $0x2,%edx
80105485:	6a 00                	push   $0x0
80105487:	e8 24 f8 ff ff       	call   80104cb0 <create>
    if(ip == 0){
8010548c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010548f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105491:	85 c0                	test   %eax,%eax
80105493:	75 99                	jne    8010542e <sys_open+0x6e>
      end_op();
80105495:	e8 66 d9 ff ff       	call   80102e00 <end_op>
      return -1;
8010549a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010549f:	eb 40                	jmp    801054e1 <sys_open+0x121>
801054a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054a8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054ab:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
801054af:	56                   	push   %esi
801054b0:	e8 9b c3 ff ff       	call   80101850 <iunlock>
  end_op();
801054b5:	e8 46 d9 ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
801054ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054c3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054c6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054c9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054cb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054d2:	f7 d0                	not    %eax
801054d4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054d7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054da:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e4:	89 d8                	mov    %ebx,%eax
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5f                   	pop    %edi
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    
801054eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054f3:	85 c9                	test   %ecx,%ecx
801054f5:	0f 84 33 ff ff ff    	je     8010542e <sys_open+0x6e>
801054fb:	e9 5c ff ff ff       	jmp    8010545c <sys_open+0x9c>

80105500 <sys_mkdir>:

int
sys_mkdir(void)
{
80105500:	f3 0f 1e fb          	endbr32 
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
80105507:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010550a:	e8 81 d8 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010550f:	83 ec 08             	sub    $0x8,%esp
80105512:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105515:	50                   	push   %eax
80105516:	6a 00                	push   $0x0
80105518:	e8 e3 f6 ff ff       	call   80104c00 <argstr>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	78 34                	js     80105558 <sys_mkdir+0x58>
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552a:	31 c9                	xor    %ecx,%ecx
8010552c:	ba 01 00 00 00       	mov    $0x1,%edx
80105531:	6a 00                	push   $0x0
80105533:	e8 78 f7 ff ff       	call   80104cb0 <create>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	74 19                	je     80105558 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010553f:	83 ec 0c             	sub    $0xc,%esp
80105542:	50                   	push   %eax
80105543:	e8 c8 c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105548:	e8 b3 d8 ff ff       	call   80102e00 <end_op>
  return 0;
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	31 c0                	xor    %eax,%eax
}
80105552:	c9                   	leave  
80105553:	c3                   	ret    
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105558:	e8 a3 d8 ff ff       	call   80102e00 <end_op>
    return -1;
8010555d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105562:	c9                   	leave  
80105563:	c3                   	ret    
80105564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop

80105570 <sys_mknod>:

int
sys_mknod(void)
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010557a:	e8 11 d8 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010557f:	83 ec 08             	sub    $0x8,%esp
80105582:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105585:	50                   	push   %eax
80105586:	6a 00                	push   $0x0
80105588:	e8 73 f6 ff ff       	call   80104c00 <argstr>
8010558d:	83 c4 10             	add    $0x10,%esp
80105590:	85 c0                	test   %eax,%eax
80105592:	78 64                	js     801055f8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105594:	83 ec 08             	sub    $0x8,%esp
80105597:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010559a:	50                   	push   %eax
8010559b:	6a 01                	push   $0x1
8010559d:	e8 ae f5 ff ff       	call   80104b50 <argint>
  if((argstr(0, &path)) < 0 ||
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	78 4f                	js     801055f8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801055a9:	83 ec 08             	sub    $0x8,%esp
801055ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055af:	50                   	push   %eax
801055b0:	6a 02                	push   $0x2
801055b2:	e8 99 f5 ff ff       	call   80104b50 <argint>
     argint(1, &major) < 0 ||
801055b7:	83 c4 10             	add    $0x10,%esp
801055ba:	85 c0                	test   %eax,%eax
801055bc:	78 3a                	js     801055f8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055be:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055c2:	83 ec 0c             	sub    $0xc,%esp
801055c5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055c9:	ba 03 00 00 00       	mov    $0x3,%edx
801055ce:	50                   	push   %eax
801055cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055d2:	e8 d9 f6 ff ff       	call   80104cb0 <create>
     argint(2, &minor) < 0 ||
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	85 c0                	test   %eax,%eax
801055dc:	74 1a                	je     801055f8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055de:	83 ec 0c             	sub    $0xc,%esp
801055e1:	50                   	push   %eax
801055e2:	e8 29 c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055e7:	e8 14 d8 ff ff       	call   80102e00 <end_op>
  return 0;
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	31 c0                	xor    %eax,%eax
}
801055f1:	c9                   	leave  
801055f2:	c3                   	ret    
801055f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055f7:	90                   	nop
    end_op();
801055f8:	e8 03 d8 ff ff       	call   80102e00 <end_op>
    return -1;
801055fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105602:	c9                   	leave  
80105603:	c3                   	ret    
80105604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop

80105610 <sys_chdir>:

int
sys_chdir(void)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	56                   	push   %esi
80105618:	53                   	push   %ebx
80105619:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010561c:	e8 cf e3 ff ff       	call   801039f0 <myproc>
80105621:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105623:	e8 68 d7 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105628:	83 ec 08             	sub    $0x8,%esp
8010562b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562e:	50                   	push   %eax
8010562f:	6a 00                	push   $0x0
80105631:	e8 ca f5 ff ff       	call   80104c00 <argstr>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 73                	js     801056b0 <sys_chdir+0xa0>
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	ff 75 f4             	pushl  -0xc(%ebp)
80105643:	e8 f8 c9 ff ff       	call   80102040 <namei>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	89 c3                	mov    %eax,%ebx
8010564d:	85 c0                	test   %eax,%eax
8010564f:	74 5f                	je     801056b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	50                   	push   %eax
80105655:	e8 16 c1 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105662:	75 2c                	jne    80105690 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	53                   	push   %ebx
80105668:	e8 e3 c1 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
8010566d:	58                   	pop    %eax
8010566e:	ff 76 6c             	pushl  0x6c(%esi)
80105671:	e8 2a c2 ff ff       	call   801018a0 <iput>
  end_op();
80105676:	e8 85 d7 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
8010567b:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	31 c0                	xor    %eax,%eax
}
80105683:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105686:	5b                   	pop    %ebx
80105687:	5e                   	pop    %esi
80105688:	5d                   	pop    %ebp
80105689:	c3                   	ret    
8010568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	53                   	push   %ebx
80105694:	e8 77 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105699:	e8 62 d7 ff ff       	call   80102e00 <end_op>
    return -1;
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a6:	eb db                	jmp    80105683 <sys_chdir+0x73>
801056a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop
    end_op();
801056b0:	e8 4b d7 ff ff       	call   80102e00 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ba:	eb c7                	jmp    80105683 <sys_chdir+0x73>
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_exec>:

int
sys_exec(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056c9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056cf:	53                   	push   %ebx
801056d0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d6:	50                   	push   %eax
801056d7:	6a 00                	push   $0x0
801056d9:	e8 22 f5 ff ff       	call   80104c00 <argstr>
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	85 c0                	test   %eax,%eax
801056e3:	0f 88 8b 00 00 00    	js     80105774 <sys_exec+0xb4>
801056e9:	83 ec 08             	sub    $0x8,%esp
801056ec:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056f2:	50                   	push   %eax
801056f3:	6a 01                	push   $0x1
801056f5:	e8 56 f4 ff ff       	call   80104b50 <argint>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 73                	js     80105774 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105701:	83 ec 04             	sub    $0x4,%esp
80105704:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010570a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010570c:	68 80 00 00 00       	push   $0x80
80105711:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105717:	6a 00                	push   $0x0
80105719:	50                   	push   %eax
8010571a:	e8 51 f1 ff ff       	call   80104870 <memset>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105728:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010572e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105735:	83 ec 08             	sub    $0x8,%esp
80105738:	57                   	push   %edi
80105739:	01 f0                	add    %esi,%eax
8010573b:	50                   	push   %eax
8010573c:	e8 6f f3 ff ff       	call   80104ab0 <fetchint>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	78 2c                	js     80105774 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105748:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010574e:	85 c0                	test   %eax,%eax
80105750:	74 36                	je     80105788 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105752:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105758:	83 ec 08             	sub    $0x8,%esp
8010575b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010575e:	52                   	push   %edx
8010575f:	50                   	push   %eax
80105760:	e8 8b f3 ff ff       	call   80104af0 <fetchstr>
80105765:	83 c4 10             	add    $0x10,%esp
80105768:	85 c0                	test   %eax,%eax
8010576a:	78 08                	js     80105774 <sys_exec+0xb4>
  for(i=0;; i++){
8010576c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010576f:	83 fb 20             	cmp    $0x20,%ebx
80105772:	75 b4                	jne    80105728 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105774:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577c:	5b                   	pop    %ebx
8010577d:	5e                   	pop    %esi
8010577e:	5f                   	pop    %edi
8010577f:	5d                   	pop    %ebp
80105780:	c3                   	ret    
80105781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105788:	83 ec 08             	sub    $0x8,%esp
8010578b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105791:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105798:	00 00 00 00 
  return exec(path, argv);
8010579c:	50                   	push   %eax
8010579d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801057a3:	e8 d8 b2 ff ff       	call   80100a80 <exec>
801057a8:	83 c4 10             	add    $0x10,%esp
}
801057ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ae:	5b                   	pop    %ebx
801057af:	5e                   	pop    %esi
801057b0:	5f                   	pop    %edi
801057b1:	5d                   	pop    %ebp
801057b2:	c3                   	ret    
801057b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057c0 <sys_pipe>:

int
sys_pipe(void)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	57                   	push   %edi
801057c8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057cc:	53                   	push   %ebx
801057cd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057d0:	6a 08                	push   $0x8
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 c6 f3 ff ff       	call   80104ba0 <argptr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	78 4e                	js     8010582f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057e7:	50                   	push   %eax
801057e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057eb:	50                   	push   %eax
801057ec:	e8 5f dc ff ff       	call   80103450 <pipealloc>
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	85 c0                	test   %eax,%eax
801057f6:	78 37                	js     8010582f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057fb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057fd:	e8 ee e1 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105808:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
8010580c:	85 f6                	test   %esi,%esi
8010580e:	74 30                	je     80105840 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	75 f0                	jne    80105808 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	ff 75 e0             	pushl  -0x20(%ebp)
8010581e:	e8 ad b6 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105823:	58                   	pop    %eax
80105824:	ff 75 e4             	pushl  -0x1c(%ebp)
80105827:	e8 a4 b6 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105834:	eb 5b                	jmp    80105891 <sys_pipe+0xd1>
80105836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105840:	8d 73 08             	lea    0x8(%ebx),%esi
80105843:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105847:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010584a:	e8 a1 e1 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010584f:	31 d2                	xor    %edx,%edx
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105858:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
8010585c:	85 c9                	test   %ecx,%ecx
8010585e:	74 20                	je     80105880 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105860:	83 c2 01             	add    $0x1,%edx
80105863:	83 fa 10             	cmp    $0x10,%edx
80105866:	75 f0                	jne    80105858 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105868:	e8 83 e1 ff ff       	call   801039f0 <myproc>
8010586d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105874:	00 
80105875:	eb a1                	jmp    80105818 <sys_pipe+0x58>
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105880:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105884:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105887:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105889:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010588c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010588f:	31 c0                	xor    %eax,%eax
}
80105891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105894:	5b                   	pop    %ebx
80105895:	5e                   	pop    %esi
80105896:	5f                   	pop    %edi
80105897:	5d                   	pop    %ebp
80105898:	c3                   	ret    
80105899:	66 90                	xchg   %ax,%ax
8010589b:	66 90                	xchg   %ax,%ax
8010589d:	66 90                	xchg   %ax,%ax
8010589f:	90                   	nop

801058a0 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int
sys_fork(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
  return fork();
801058a4:	e9 f7 e2 ff ff       	jmp    80103ba0 <fork>
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_exit>:
}

int
sys_exit(void)
{
801058b0:	f3 0f 1e fb          	endbr32 
801058b4:	55                   	push   %ebp
801058b5:	89 e5                	mov    %esp,%ebp
801058b7:	83 ec 08             	sub    $0x8,%esp
  exit();
801058ba:	e8 e1 e5 ff ff       	call   80103ea0 <exit>
  return 0;  // not reached
}
801058bf:	31 c0                	xor    %eax,%eax
801058c1:	c9                   	leave  
801058c2:	c3                   	ret    
801058c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058d0 <sys_wait>:

int
sys_wait(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
  return wait();
801058d4:	e9 17 e8 ff ff       	jmp    801040f0 <wait>
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_kill>:
}

int
sys_kill(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ed:	50                   	push   %eax
801058ee:	6a 00                	push   $0x0
801058f0:	e8 5b f2 ff ff       	call   80104b50 <argint>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	78 14                	js     80105910 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105902:	e8 59 e9 ff ff       	call   80104260 <kill>
80105907:	83 c4 10             	add    $0x10,%esp
}
8010590a:	c9                   	leave  
8010590b:	c3                   	ret    
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105910:	c9                   	leave  
    return -1;
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105916:	c3                   	ret    
80105917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_getpid>:

int
sys_getpid(void)
{
80105920:	f3 0f 1e fb          	endbr32 
80105924:	55                   	push   %ebp
80105925:	89 e5                	mov    %esp,%ebp
80105927:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010592a:	e8 c1 e0 ff ff       	call   801039f0 <myproc>
8010592f:	8b 40 14             	mov    0x14(%eax),%eax
}
80105932:	c9                   	leave  
80105933:	c3                   	ret    
80105934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop

80105940 <sys_sbrk>:

int
sys_sbrk(void)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105948:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010594b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594e:	50                   	push   %eax
8010594f:	6a 00                	push   $0x0
80105951:	e8 fa f1 ff ff       	call   80104b50 <argint>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 23                	js     80105980 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010595d:	e8 8e e0 ff ff       	call   801039f0 <myproc>
  if(growproc(n) < 0)
80105962:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105965:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105967:	ff 75 f4             	pushl  -0xc(%ebp)
8010596a:	e8 b1 e1 ff ff       	call   80103b20 <growproc>
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 c0                	test   %eax,%eax
80105974:	78 0a                	js     80105980 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105976:	89 d8                	mov    %ebx,%eax
80105978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010597b:	c9                   	leave  
8010597c:	c3                   	ret    
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb ef                	jmp    80105976 <sys_sbrk+0x36>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_sleep>:

int
sys_sleep(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105998:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010599b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599e:	50                   	push   %eax
8010599f:	6a 00                	push   $0x0
801059a1:	e8 aa f1 ff ff       	call   80104b50 <argint>
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	85 c0                	test   %eax,%eax
801059ab:	0f 88 86 00 00 00    	js     80105a37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059b1:	83 ec 0c             	sub    $0xc,%esp
801059b4:	68 20 69 11 80       	push   $0x80116920
801059b9:	e8 a2 ed ff ff       	call   80104760 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059c1:	8b 1d 60 71 11 80    	mov    0x80117160,%ebx
  while(ticks - ticks0 < n){
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	85 d2                	test   %edx,%edx
801059cc:	75 23                	jne    801059f1 <sys_sleep+0x61>
801059ce:	eb 50                	jmp    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	68 20 69 11 80       	push   $0x80116920
801059d8:	68 60 71 11 80       	push   $0x80117160
801059dd:	e8 4e e6 ff ff       	call   80104030 <sleep>
  while(ticks - ticks0 < n){
801059e2:	a1 60 71 11 80       	mov    0x80117160,%eax
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	29 d8                	sub    %ebx,%eax
801059ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059ef:	73 2f                	jae    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
801059f1:	e8 fa df ff ff       	call   801039f0 <myproc>
801059f6:	8b 40 28             	mov    0x28(%eax),%eax
801059f9:	85 c0                	test   %eax,%eax
801059fb:	74 d3                	je     801059d0 <sys_sleep+0x40>
      release(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 20 69 11 80       	push   $0x80116920
80105a05:	e8 16 ee ff ff       	call   80104820 <release>
  }
  release(&tickslock);
  return 0;
}
80105a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 20 69 11 80       	push   $0x80116920
80105a28:	e8 f3 ed ff ff       	call   80104820 <release>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
    return -1;
80105a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3c:	eb f4                	jmp    80105a32 <sys_sleep+0xa2>
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	53                   	push   %ebx
80105a48:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a4b:	68 20 69 11 80       	push   $0x80116920
80105a50:	e8 0b ed ff ff       	call   80104760 <acquire>
  xticks = ticks;
80105a55:	8b 1d 60 71 11 80    	mov    0x80117160,%ebx
  release(&tickslock);
80105a5b:	c7 04 24 20 69 11 80 	movl   $0x80116920,(%esp)
80105a62:	e8 b9 ed ff ff       	call   80104820 <release>
  return xticks;
}
80105a67:	89 d8                	mov    %ebx,%eax
80105a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a6c:	c9                   	leave  
80105a6d:	c3                   	ret    
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_provide_protection>:

int
sys_provide_protection(void){
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	83 ec 20             	sub    $0x20,%esp
  int d;
  int n = 0;
  // cprintf("done done done ") ;
  if(argint(0, &d)<0 || argint(1, &n)<0)
80105a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  int n = 0;
80105a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argint(0, &d)<0 || argint(1, &n)<0)
80105a84:	50                   	push   %eax
80105a85:	6a 00                	push   $0x0
80105a87:	e8 c4 f0 ff ff       	call   80104b50 <argint>
80105a8c:	83 c4 10             	add    $0x10,%esp
80105a8f:	85 c0                	test   %eax,%eax
80105a91:	78 2d                	js     80105ac0 <sys_provide_protection+0x50>
80105a93:	83 ec 08             	sub    $0x8,%esp
80105a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 01                	push   $0x1
80105a9c:	e8 af f0 ff ff       	call   80104b50 <argint>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 18                	js     80105ac0 <sys_provide_protection+0x50>
    return -1;
  return provide_protection((void *)d,n);
80105aa8:	83 ec 08             	sub    $0x8,%esp
80105aab:	ff 75 f4             	pushl  -0xc(%ebp)
80105aae:	ff 75 f0             	pushl  -0x10(%ebp)
80105ab1:	e8 7a 19 00 00       	call   80107430 <provide_protection>
80105ab6:	83 c4 10             	add    $0x10,%esp
}
80105ab9:	c9                   	leave  
80105aba:	c3                   	ret    
80105abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105abf:	90                   	nop
80105ac0:	c9                   	leave  
    return -1;
80105ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac6:	c3                   	ret    
80105ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <sys_refuse_protection>:

int
sys_refuse_protection(void){
80105ad0:	f3 0f 1e fb          	endbr32 
80105ad4:	55                   	push   %ebp
80105ad5:	89 e5                	mov    %esp,%ebp
80105ad7:	83 ec 20             	sub    $0x20,%esp
  int d;
  int n = 0;
  if(argint(0, &d)<0 || argint(1, &n)<0)
80105ada:	8d 45 f0             	lea    -0x10(%ebp),%eax
  int n = 0;
80105add:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argint(0, &d)<0 || argint(1, &n)<0)
80105ae4:	50                   	push   %eax
80105ae5:	6a 00                	push   $0x0
80105ae7:	e8 64 f0 ff ff       	call   80104b50 <argint>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	85 c0                	test   %eax,%eax
80105af1:	78 2d                	js     80105b20 <sys_refuse_protection+0x50>
80105af3:	83 ec 08             	sub    $0x8,%esp
80105af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af9:	50                   	push   %eax
80105afa:	6a 01                	push   $0x1
80105afc:	e8 4f f0 ff ff       	call   80104b50 <argint>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	85 c0                	test   %eax,%eax
80105b06:	78 18                	js     80105b20 <sys_refuse_protection+0x50>
    return -1;
  return refuse_protection((void *)d,n);
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0e:	ff 75 f0             	pushl  -0x10(%ebp)
80105b11:	e8 2a 1a 00 00       	call   80107540 <refuse_protection>
80105b16:	83 c4 10             	add    $0x10,%esp

}
80105b19:	c9                   	leave  
80105b1a:	c3                   	ret    
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
80105b20:	c9                   	leave  
    return -1;
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b26:	c3                   	ret    
80105b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <sys_settickets>:

int
sys_settickets(void) {
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	83 ec 20             	sub    $0x20,%esp
  int n;
  if(argint(0, &n) < 0) {      //if n is negtive return error  // argint(0, &n) pass argument from user space to kernel space ; 
80105b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b3d:	50                   	push   %eax
80105b3e:	6a 00                	push   $0x0
80105b40:	e8 0b f0 ff ff       	call   80104b50 <argint>
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	85 c0                	test   %eax,%eax
80105b4a:	78 14                	js     80105b60 <sys_settickets+0x30>
    return -1;
  }
  else {
    settickets(n);                // call settickets from proc.c to assign number of tickets
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105b52:	e8 99 e7 ff ff       	call   801042f0 <settickets>
  }
  return 0;
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	31 c0                	xor    %eax,%eax
}
80105b5c:	c9                   	leave  
80105b5d:	c3                   	ret    
80105b5e:	66 90                	xchg   %ax,%ax
80105b60:	c9                   	leave  
    return -1;
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b66:	c3                   	ret    
80105b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <sys_getpinfo>:

int
sys_getpinfo(void){
80105b70:	f3 0f 1e fb          	endbr32 
80105b74:	55                   	push   %ebp
80105b75:	89 e5                	mov    %esp,%ebp
80105b77:	83 ec 1c             	sub    $0x1c,%esp
    struct pstat *d;
  if (argptr(0, (char **)&d, sizeof(struct pstat)) < 0)   // argptr() pass pstat pointer and saves the given pointer in a local (function scope) pointer variable.
80105b7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b7d:	68 00 04 00 00       	push   $0x400
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 16 f0 ff ff       	call   80104ba0 <argptr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	78 17                	js     80105ba8 <sys_getpinfo+0x38>
      return -1;                                          // all arguments were fetched can be used by the kernel implementation
                                                          // the struct size must be postive 
  getpinfo(d);                                    
80105b91:	83 ec 0c             	sub    $0xc,%esp
80105b94:	ff 75 f4             	pushl  -0xc(%ebp)
80105b97:	e8 b4 e7 ff ff       	call   80104350 <getpinfo>
  return 0;
80105b9c:	83 c4 10             	add    $0x10,%esp
80105b9f:	31 c0                	xor    %eax,%eax
}
80105ba1:	c9                   	leave  
80105ba2:	c3                   	ret    
80105ba3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ba7:	90                   	nop
80105ba8:	c9                   	leave  
      return -1;                                          // all arguments were fetched can be used by the kernel implementation
80105ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bae:	c3                   	ret    

80105baf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105baf:	1e                   	push   %ds
  pushl %es
80105bb0:	06                   	push   %es
  pushl %fs
80105bb1:	0f a0                	push   %fs
  pushl %gs
80105bb3:	0f a8                	push   %gs
  pushal
80105bb5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bb6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bba:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bbc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bbe:	54                   	push   %esp
  call trap
80105bbf:	e8 cc 00 00 00       	call   80105c90 <trap>
  addl $4, %esp
80105bc4:	83 c4 04             	add    $0x4,%esp

80105bc7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bc7:	61                   	popa   
  popl %gs
80105bc8:	0f a9                	pop    %gs
  popl %fs
80105bca:	0f a1                	pop    %fs
  popl %es
80105bcc:	07                   	pop    %es
  popl %ds
80105bcd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bce:	83 c4 08             	add    $0x8,%esp
  iret
80105bd1:	cf                   	iret   
80105bd2:	66 90                	xchg   %ax,%ax
80105bd4:	66 90                	xchg   %ax,%ax
80105bd6:	66 90                	xchg   %ax,%ax
80105bd8:	66 90                	xchg   %ax,%ax
80105bda:	66 90                	xchg   %ax,%ax
80105bdc:	66 90                	xchg   %ax,%ax
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105be5:	31 c0                	xor    %eax,%eax
{
80105be7:	89 e5                	mov    %esp,%ebp
80105be9:	83 ec 08             	sub    $0x8,%esp
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bf0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105bf7:	c7 04 c5 62 69 11 80 	movl   $0x8e000008,-0x7fee969e(,%eax,8)
80105bfe:	08 00 00 8e 
80105c02:	66 89 14 c5 60 69 11 	mov    %dx,-0x7fee96a0(,%eax,8)
80105c09:	80 
80105c0a:	c1 ea 10             	shr    $0x10,%edx
80105c0d:	66 89 14 c5 66 69 11 	mov    %dx,-0x7fee969a(,%eax,8)
80105c14:	80 
  for(i = 0; i < 256; i++)
80105c15:	83 c0 01             	add    $0x1,%eax
80105c18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c1d:	75 d1                	jne    80105bf0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105c27:	c7 05 62 6b 11 80 08 	movl   $0xef000008,0x80116b62
80105c2e:	00 00 ef 
  initlock(&tickslock, "time");
80105c31:	68 c9 7f 10 80       	push   $0x80107fc9
80105c36:	68 20 69 11 80       	push   $0x80116920
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c3b:	66 a3 60 6b 11 80    	mov    %ax,0x80116b60
80105c41:	c1 e8 10             	shr    $0x10,%eax
80105c44:	66 a3 66 6b 11 80    	mov    %ax,0x80116b66
  initlock(&tickslock, "time");
80105c4a:	e8 91 e9 ff ff       	call   801045e0 <initlock>
}
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	c9                   	leave  
80105c53:	c3                   	ret    
80105c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c5f:	90                   	nop

80105c60 <idtinit>:

void
idtinit(void)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
  pd[0] = size-1;
80105c65:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c6a:	89 e5                	mov    %esp,%ebp
80105c6c:	83 ec 10             	sub    $0x10,%esp
80105c6f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c73:	b8 60 69 11 80       	mov    $0x80116960,%eax
80105c78:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c7c:	c1 e8 10             	shr    $0x10,%eax
80105c7f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c83:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c86:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c89:	c9                   	leave  
80105c8a:	c3                   	ret    
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop

80105c90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	57                   	push   %edi
80105c98:	56                   	push   %esi
80105c99:	53                   	push   %ebx
80105c9a:	83 ec 1c             	sub    $0x1c,%esp
80105c9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ca0:	8b 43 30             	mov    0x30(%ebx),%eax
80105ca3:	83 f8 40             	cmp    $0x40,%eax
80105ca6:	0f 84 bc 01 00 00    	je     80105e68 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cac:	83 e8 20             	sub    $0x20,%eax
80105caf:	83 f8 1f             	cmp    $0x1f,%eax
80105cb2:	77 08                	ja     80105cbc <trap+0x2c>
80105cb4:	3e ff 24 85 70 80 10 	notrack jmp *-0x7fef7f90(,%eax,4)
80105cbb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cbc:	e8 2f dd ff ff       	call   801039f0 <myproc>
80105cc1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	0f 84 eb 01 00 00    	je     80105eb7 <trap+0x227>
80105ccc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cd0:	0f 84 e1 01 00 00    	je     80105eb7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cd6:	0f 20 d1             	mov    %cr2,%ecx
80105cd9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cdc:	e8 ef dc ff ff       	call   801039d0 <cpuid>
80105ce1:	8b 73 30             	mov    0x30(%ebx),%esi
80105ce4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ce7:	8b 43 34             	mov    0x34(%ebx),%eax
80105cea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ced:	e8 fe dc ff ff       	call   801039f0 <myproc>
80105cf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cf5:	e8 f6 dc ff ff       	call   801039f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cfa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cfd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d00:	51                   	push   %ecx
80105d01:	57                   	push   %edi
80105d02:	52                   	push   %edx
80105d03:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d06:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d07:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d0a:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d0d:	56                   	push   %esi
80105d0e:	ff 70 14             	pushl  0x14(%eax)
80105d11:	68 2c 80 10 80       	push   $0x8010802c
80105d16:	e8 95 a9 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d1b:	83 c4 20             	add    $0x20,%esp
80105d1e:	e8 cd dc ff ff       	call   801039f0 <myproc>
80105d23:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2a:	e8 c1 dc ff ff       	call   801039f0 <myproc>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	74 1d                	je     80105d50 <trap+0xc0>
80105d33:	e8 b8 dc ff ff       	call   801039f0 <myproc>
80105d38:	8b 50 28             	mov    0x28(%eax),%edx
80105d3b:	85 d2                	test   %edx,%edx
80105d3d:	74 11                	je     80105d50 <trap+0xc0>
80105d3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d43:	83 e0 03             	and    $0x3,%eax
80105d46:	66 83 f8 03          	cmp    $0x3,%ax
80105d4a:	0f 84 50 01 00 00    	je     80105ea0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d50:	e8 9b dc ff ff       	call   801039f0 <myproc>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 0f                	je     80105d68 <trap+0xd8>
80105d59:	e8 92 dc ff ff       	call   801039f0 <myproc>
80105d5e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105d62:	0f 84 e8 00 00 00    	je     80105e50 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d68:	e8 83 dc ff ff       	call   801039f0 <myproc>
80105d6d:	85 c0                	test   %eax,%eax
80105d6f:	74 1d                	je     80105d8e <trap+0xfe>
80105d71:	e8 7a dc ff ff       	call   801039f0 <myproc>
80105d76:	8b 40 28             	mov    0x28(%eax),%eax
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	74 11                	je     80105d8e <trap+0xfe>
80105d7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d81:	83 e0 03             	and    $0x3,%eax
80105d84:	66 83 f8 03          	cmp    $0x3,%ax
80105d88:	0f 84 03 01 00 00    	je     80105e91 <trap+0x201>
    exit();
}
80105d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d91:	5b                   	pop    %ebx
80105d92:	5e                   	pop    %esi
80105d93:	5f                   	pop    %edi
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
    ideintr();
80105d96:	e8 55 c4 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
80105d9b:	e8 30 cb ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da0:	e8 4b dc ff ff       	call   801039f0 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	75 8a                	jne    80105d33 <trap+0xa3>
80105da9:	eb a5                	jmp    80105d50 <trap+0xc0>
    if(cpuid() == 0){
80105dab:	e8 20 dc ff ff       	call   801039d0 <cpuid>
80105db0:	85 c0                	test   %eax,%eax
80105db2:	75 e7                	jne    80105d9b <trap+0x10b>
      acquire(&tickslock);
80105db4:	83 ec 0c             	sub    $0xc,%esp
80105db7:	68 20 69 11 80       	push   $0x80116920
80105dbc:	e8 9f e9 ff ff       	call   80104760 <acquire>
      wakeup(&ticks);
80105dc1:	c7 04 24 60 71 11 80 	movl   $0x80117160,(%esp)
      ticks++;
80105dc8:	83 05 60 71 11 80 01 	addl   $0x1,0x80117160
      wakeup(&ticks);
80105dcf:	e8 1c e4 ff ff       	call   801041f0 <wakeup>
      release(&tickslock);
80105dd4:	c7 04 24 20 69 11 80 	movl   $0x80116920,(%esp)
80105ddb:	e8 40 ea ff ff       	call   80104820 <release>
80105de0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105de3:	eb b6                	jmp    80105d9b <trap+0x10b>
    kbdintr();
80105de5:	e8 a6 c9 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
80105dea:	e8 e1 ca ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105def:	e8 fc db ff ff       	call   801039f0 <myproc>
80105df4:	85 c0                	test   %eax,%eax
80105df6:	0f 85 37 ff ff ff    	jne    80105d33 <trap+0xa3>
80105dfc:	e9 4f ff ff ff       	jmp    80105d50 <trap+0xc0>
    uartintr();
80105e01:	e8 4a 02 00 00       	call   80106050 <uartintr>
    lapiceoi();
80105e06:	e8 c5 ca ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0b:	e8 e0 db ff ff       	call   801039f0 <myproc>
80105e10:	85 c0                	test   %eax,%eax
80105e12:	0f 85 1b ff ff ff    	jne    80105d33 <trap+0xa3>
80105e18:	e9 33 ff ff ff       	jmp    80105d50 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e1d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e20:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e24:	e8 a7 db ff ff       	call   801039d0 <cpuid>
80105e29:	57                   	push   %edi
80105e2a:	56                   	push   %esi
80105e2b:	50                   	push   %eax
80105e2c:	68 d4 7f 10 80       	push   $0x80107fd4
80105e31:	e8 7a a8 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105e36:	e8 95 ca ff ff       	call   801028d0 <lapiceoi>
    break;
80105e3b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3e:	e8 ad db ff ff       	call   801039f0 <myproc>
80105e43:	85 c0                	test   %eax,%eax
80105e45:	0f 85 e8 fe ff ff    	jne    80105d33 <trap+0xa3>
80105e4b:	e9 00 ff ff ff       	jmp    80105d50 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e54:	0f 85 0e ff ff ff    	jne    80105d68 <trap+0xd8>
    yield();
80105e5a:	e8 81 e1 ff ff       	call   80103fe0 <yield>
80105e5f:	e9 04 ff ff ff       	jmp    80105d68 <trap+0xd8>
80105e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105e68:	e8 83 db ff ff       	call   801039f0 <myproc>
80105e6d:	8b 70 28             	mov    0x28(%eax),%esi
80105e70:	85 f6                	test   %esi,%esi
80105e72:	75 3c                	jne    80105eb0 <trap+0x220>
    myproc()->tf = tf;
80105e74:	e8 77 db ff ff       	call   801039f0 <myproc>
80105e79:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105e7c:	e8 bf ed ff ff       	call   80104c40 <syscall>
    if(myproc()->killed)
80105e81:	e8 6a db ff ff       	call   801039f0 <myproc>
80105e86:	8b 48 28             	mov    0x28(%eax),%ecx
80105e89:	85 c9                	test   %ecx,%ecx
80105e8b:	0f 84 fd fe ff ff    	je     80105d8e <trap+0xfe>
}
80105e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e94:	5b                   	pop    %ebx
80105e95:	5e                   	pop    %esi
80105e96:	5f                   	pop    %edi
80105e97:	5d                   	pop    %ebp
      exit();
80105e98:	e9 03 e0 ff ff       	jmp    80103ea0 <exit>
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105ea0:	e8 fb df ff ff       	call   80103ea0 <exit>
80105ea5:	e9 a6 fe ff ff       	jmp    80105d50 <trap+0xc0>
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105eb0:	e8 eb df ff ff       	call   80103ea0 <exit>
80105eb5:	eb bd                	jmp    80105e74 <trap+0x1e4>
80105eb7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105eba:	e8 11 db ff ff       	call   801039d0 <cpuid>
80105ebf:	83 ec 0c             	sub    $0xc,%esp
80105ec2:	56                   	push   %esi
80105ec3:	57                   	push   %edi
80105ec4:	50                   	push   %eax
80105ec5:	ff 73 30             	pushl  0x30(%ebx)
80105ec8:	68 f8 7f 10 80       	push   $0x80107ff8
80105ecd:	e8 de a7 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ed2:	83 c4 14             	add    $0x14,%esp
80105ed5:	68 ce 7f 10 80       	push   $0x80107fce
80105eda:	e8 b1 a4 ff ff       	call   80100390 <panic>
80105edf:	90                   	nop

80105ee0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105ee4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	74 1b                	je     80105f08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eed:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ef2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ef3:	a8 01                	test   $0x1,%al
80105ef5:	74 11                	je     80105f08 <uartgetc+0x28>
80105ef7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105efc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105efd:	0f b6 c0             	movzbl %al,%eax
80105f00:	c3                   	ret    
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f0d:	c3                   	ret    
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <uartputc.part.0>:
uartputc(int c)
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	57                   	push   %edi
80105f14:	89 c7                	mov    %eax,%edi
80105f16:	56                   	push   %esi
80105f17:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f1c:	53                   	push   %ebx
80105f1d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f22:	83 ec 0c             	sub    $0xc,%esp
80105f25:	eb 1b                	jmp    80105f42 <uartputc.part.0+0x32>
80105f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	6a 0a                	push   $0xa
80105f35:	e8 b6 c9 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	83 eb 01             	sub    $0x1,%ebx
80105f40:	74 07                	je     80105f49 <uartputc.part.0+0x39>
80105f42:	89 f2                	mov    %esi,%edx
80105f44:	ec                   	in     (%dx),%al
80105f45:	a8 20                	test   $0x20,%al
80105f47:	74 e7                	je     80105f30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4e:	89 f8                	mov    %edi,%eax
80105f50:	ee                   	out    %al,(%dx)
}
80105f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f54:	5b                   	pop    %ebx
80105f55:	5e                   	pop    %esi
80105f56:	5f                   	pop    %edi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <uartinit>:
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	31 c9                	xor    %ecx,%ecx
80105f67:	89 c8                	mov    %ecx,%eax
80105f69:	89 e5                	mov    %esp,%ebp
80105f6b:	57                   	push   %edi
80105f6c:	56                   	push   %esi
80105f6d:	53                   	push   %ebx
80105f6e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f73:	89 da                	mov    %ebx,%edx
80105f75:	83 ec 0c             	sub    $0xc,%esp
80105f78:	ee                   	out    %al,(%dx)
80105f79:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f7e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f83:	89 fa                	mov    %edi,%edx
80105f85:	ee                   	out    %al,(%dx)
80105f86:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f8b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f90:	ee                   	out    %al,(%dx)
80105f91:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f96:	89 c8                	mov    %ecx,%eax
80105f98:	89 f2                	mov    %esi,%edx
80105f9a:	ee                   	out    %al,(%dx)
80105f9b:	b8 03 00 00 00       	mov    $0x3,%eax
80105fa0:	89 fa                	mov    %edi,%edx
80105fa2:	ee                   	out    %al,(%dx)
80105fa3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fa8:	89 c8                	mov    %ecx,%eax
80105faa:	ee                   	out    %al,(%dx)
80105fab:	b8 01 00 00 00       	mov    $0x1,%eax
80105fb0:	89 f2                	mov    %esi,%edx
80105fb2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fb3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fb8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fb9:	3c ff                	cmp    $0xff,%al
80105fbb:	74 52                	je     8010600f <uartinit+0xaf>
  uart = 1;
80105fbd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105fc4:	00 00 00 
80105fc7:	89 da                	mov    %ebx,%edx
80105fc9:	ec                   	in     (%dx),%al
80105fca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fcf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fd0:	83 ec 08             	sub    $0x8,%esp
80105fd3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105fd8:	bb f0 80 10 80       	mov    $0x801080f0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fdd:	6a 00                	push   $0x0
80105fdf:	6a 04                	push   $0x4
80105fe1:	e8 5a c4 ff ff       	call   80102440 <ioapicenable>
80105fe6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fe9:	b8 78 00 00 00       	mov    $0x78,%eax
80105fee:	eb 04                	jmp    80105ff4 <uartinit+0x94>
80105ff0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105ff4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105ffa:	85 d2                	test   %edx,%edx
80105ffc:	74 08                	je     80106006 <uartinit+0xa6>
    uartputc(*p);
80105ffe:	0f be c0             	movsbl %al,%eax
80106001:	e8 0a ff ff ff       	call   80105f10 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106006:	89 f0                	mov    %esi,%eax
80106008:	83 c3 01             	add    $0x1,%ebx
8010600b:	84 c0                	test   %al,%al
8010600d:	75 e1                	jne    80105ff0 <uartinit+0x90>
}
8010600f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106012:	5b                   	pop    %ebx
80106013:	5e                   	pop    %esi
80106014:	5f                   	pop    %edi
80106015:	5d                   	pop    %ebp
80106016:	c3                   	ret    
80106017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601e:	66 90                	xchg   %ax,%ax

80106020 <uartputc>:
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
  if(!uart)
80106025:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010602b:	89 e5                	mov    %esp,%ebp
8010602d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106030:	85 d2                	test   %edx,%edx
80106032:	74 0c                	je     80106040 <uartputc+0x20>
}
80106034:	5d                   	pop    %ebp
80106035:	e9 d6 fe ff ff       	jmp    80105f10 <uartputc.part.0>
8010603a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106040:	5d                   	pop    %ebp
80106041:	c3                   	ret    
80106042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106050 <uartintr>:

void
uartintr(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010605a:	68 e0 5e 10 80       	push   $0x80105ee0
8010605f:	e8 fc a7 ff ff       	call   80100860 <consoleintr>
}
80106064:	83 c4 10             	add    $0x10,%esp
80106067:	c9                   	leave  
80106068:	c3                   	ret    

80106069 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $0
8010606b:	6a 00                	push   $0x0
  jmp alltraps
8010606d:	e9 3d fb ff ff       	jmp    80105baf <alltraps>

80106072 <vector1>:
.globl vector1
vector1:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $1
80106074:	6a 01                	push   $0x1
  jmp alltraps
80106076:	e9 34 fb ff ff       	jmp    80105baf <alltraps>

8010607b <vector2>:
.globl vector2
vector2:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $2
8010607d:	6a 02                	push   $0x2
  jmp alltraps
8010607f:	e9 2b fb ff ff       	jmp    80105baf <alltraps>

80106084 <vector3>:
.globl vector3
vector3:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $3
80106086:	6a 03                	push   $0x3
  jmp alltraps
80106088:	e9 22 fb ff ff       	jmp    80105baf <alltraps>

8010608d <vector4>:
.globl vector4
vector4:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $4
8010608f:	6a 04                	push   $0x4
  jmp alltraps
80106091:	e9 19 fb ff ff       	jmp    80105baf <alltraps>

80106096 <vector5>:
.globl vector5
vector5:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $5
80106098:	6a 05                	push   $0x5
  jmp alltraps
8010609a:	e9 10 fb ff ff       	jmp    80105baf <alltraps>

8010609f <vector6>:
.globl vector6
vector6:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $6
801060a1:	6a 06                	push   $0x6
  jmp alltraps
801060a3:	e9 07 fb ff ff       	jmp    80105baf <alltraps>

801060a8 <vector7>:
.globl vector7
vector7:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $7
801060aa:	6a 07                	push   $0x7
  jmp alltraps
801060ac:	e9 fe fa ff ff       	jmp    80105baf <alltraps>

801060b1 <vector8>:
.globl vector8
vector8:
  pushl $8
801060b1:	6a 08                	push   $0x8
  jmp alltraps
801060b3:	e9 f7 fa ff ff       	jmp    80105baf <alltraps>

801060b8 <vector9>:
.globl vector9
vector9:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $9
801060ba:	6a 09                	push   $0x9
  jmp alltraps
801060bc:	e9 ee fa ff ff       	jmp    80105baf <alltraps>

801060c1 <vector10>:
.globl vector10
vector10:
  pushl $10
801060c1:	6a 0a                	push   $0xa
  jmp alltraps
801060c3:	e9 e7 fa ff ff       	jmp    80105baf <alltraps>

801060c8 <vector11>:
.globl vector11
vector11:
  pushl $11
801060c8:	6a 0b                	push   $0xb
  jmp alltraps
801060ca:	e9 e0 fa ff ff       	jmp    80105baf <alltraps>

801060cf <vector12>:
.globl vector12
vector12:
  pushl $12
801060cf:	6a 0c                	push   $0xc
  jmp alltraps
801060d1:	e9 d9 fa ff ff       	jmp    80105baf <alltraps>

801060d6 <vector13>:
.globl vector13
vector13:
  pushl $13
801060d6:	6a 0d                	push   $0xd
  jmp alltraps
801060d8:	e9 d2 fa ff ff       	jmp    80105baf <alltraps>

801060dd <vector14>:
.globl vector14
vector14:
  pushl $14
801060dd:	6a 0e                	push   $0xe
  jmp alltraps
801060df:	e9 cb fa ff ff       	jmp    80105baf <alltraps>

801060e4 <vector15>:
.globl vector15
vector15:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $15
801060e6:	6a 0f                	push   $0xf
  jmp alltraps
801060e8:	e9 c2 fa ff ff       	jmp    80105baf <alltraps>

801060ed <vector16>:
.globl vector16
vector16:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $16
801060ef:	6a 10                	push   $0x10
  jmp alltraps
801060f1:	e9 b9 fa ff ff       	jmp    80105baf <alltraps>

801060f6 <vector17>:
.globl vector17
vector17:
  pushl $17
801060f6:	6a 11                	push   $0x11
  jmp alltraps
801060f8:	e9 b2 fa ff ff       	jmp    80105baf <alltraps>

801060fd <vector18>:
.globl vector18
vector18:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $18
801060ff:	6a 12                	push   $0x12
  jmp alltraps
80106101:	e9 a9 fa ff ff       	jmp    80105baf <alltraps>

80106106 <vector19>:
.globl vector19
vector19:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $19
80106108:	6a 13                	push   $0x13
  jmp alltraps
8010610a:	e9 a0 fa ff ff       	jmp    80105baf <alltraps>

8010610f <vector20>:
.globl vector20
vector20:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $20
80106111:	6a 14                	push   $0x14
  jmp alltraps
80106113:	e9 97 fa ff ff       	jmp    80105baf <alltraps>

80106118 <vector21>:
.globl vector21
vector21:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $21
8010611a:	6a 15                	push   $0x15
  jmp alltraps
8010611c:	e9 8e fa ff ff       	jmp    80105baf <alltraps>

80106121 <vector22>:
.globl vector22
vector22:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $22
80106123:	6a 16                	push   $0x16
  jmp alltraps
80106125:	e9 85 fa ff ff       	jmp    80105baf <alltraps>

8010612a <vector23>:
.globl vector23
vector23:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $23
8010612c:	6a 17                	push   $0x17
  jmp alltraps
8010612e:	e9 7c fa ff ff       	jmp    80105baf <alltraps>

80106133 <vector24>:
.globl vector24
vector24:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $24
80106135:	6a 18                	push   $0x18
  jmp alltraps
80106137:	e9 73 fa ff ff       	jmp    80105baf <alltraps>

8010613c <vector25>:
.globl vector25
vector25:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $25
8010613e:	6a 19                	push   $0x19
  jmp alltraps
80106140:	e9 6a fa ff ff       	jmp    80105baf <alltraps>

80106145 <vector26>:
.globl vector26
vector26:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $26
80106147:	6a 1a                	push   $0x1a
  jmp alltraps
80106149:	e9 61 fa ff ff       	jmp    80105baf <alltraps>

8010614e <vector27>:
.globl vector27
vector27:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $27
80106150:	6a 1b                	push   $0x1b
  jmp alltraps
80106152:	e9 58 fa ff ff       	jmp    80105baf <alltraps>

80106157 <vector28>:
.globl vector28
vector28:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $28
80106159:	6a 1c                	push   $0x1c
  jmp alltraps
8010615b:	e9 4f fa ff ff       	jmp    80105baf <alltraps>

80106160 <vector29>:
.globl vector29
vector29:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $29
80106162:	6a 1d                	push   $0x1d
  jmp alltraps
80106164:	e9 46 fa ff ff       	jmp    80105baf <alltraps>

80106169 <vector30>:
.globl vector30
vector30:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $30
8010616b:	6a 1e                	push   $0x1e
  jmp alltraps
8010616d:	e9 3d fa ff ff       	jmp    80105baf <alltraps>

80106172 <vector31>:
.globl vector31
vector31:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $31
80106174:	6a 1f                	push   $0x1f
  jmp alltraps
80106176:	e9 34 fa ff ff       	jmp    80105baf <alltraps>

8010617b <vector32>:
.globl vector32
vector32:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $32
8010617d:	6a 20                	push   $0x20
  jmp alltraps
8010617f:	e9 2b fa ff ff       	jmp    80105baf <alltraps>

80106184 <vector33>:
.globl vector33
vector33:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $33
80106186:	6a 21                	push   $0x21
  jmp alltraps
80106188:	e9 22 fa ff ff       	jmp    80105baf <alltraps>

8010618d <vector34>:
.globl vector34
vector34:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $34
8010618f:	6a 22                	push   $0x22
  jmp alltraps
80106191:	e9 19 fa ff ff       	jmp    80105baf <alltraps>

80106196 <vector35>:
.globl vector35
vector35:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $35
80106198:	6a 23                	push   $0x23
  jmp alltraps
8010619a:	e9 10 fa ff ff       	jmp    80105baf <alltraps>

8010619f <vector36>:
.globl vector36
vector36:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $36
801061a1:	6a 24                	push   $0x24
  jmp alltraps
801061a3:	e9 07 fa ff ff       	jmp    80105baf <alltraps>

801061a8 <vector37>:
.globl vector37
vector37:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $37
801061aa:	6a 25                	push   $0x25
  jmp alltraps
801061ac:	e9 fe f9 ff ff       	jmp    80105baf <alltraps>

801061b1 <vector38>:
.globl vector38
vector38:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $38
801061b3:	6a 26                	push   $0x26
  jmp alltraps
801061b5:	e9 f5 f9 ff ff       	jmp    80105baf <alltraps>

801061ba <vector39>:
.globl vector39
vector39:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $39
801061bc:	6a 27                	push   $0x27
  jmp alltraps
801061be:	e9 ec f9 ff ff       	jmp    80105baf <alltraps>

801061c3 <vector40>:
.globl vector40
vector40:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $40
801061c5:	6a 28                	push   $0x28
  jmp alltraps
801061c7:	e9 e3 f9 ff ff       	jmp    80105baf <alltraps>

801061cc <vector41>:
.globl vector41
vector41:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $41
801061ce:	6a 29                	push   $0x29
  jmp alltraps
801061d0:	e9 da f9 ff ff       	jmp    80105baf <alltraps>

801061d5 <vector42>:
.globl vector42
vector42:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $42
801061d7:	6a 2a                	push   $0x2a
  jmp alltraps
801061d9:	e9 d1 f9 ff ff       	jmp    80105baf <alltraps>

801061de <vector43>:
.globl vector43
vector43:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $43
801061e0:	6a 2b                	push   $0x2b
  jmp alltraps
801061e2:	e9 c8 f9 ff ff       	jmp    80105baf <alltraps>

801061e7 <vector44>:
.globl vector44
vector44:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $44
801061e9:	6a 2c                	push   $0x2c
  jmp alltraps
801061eb:	e9 bf f9 ff ff       	jmp    80105baf <alltraps>

801061f0 <vector45>:
.globl vector45
vector45:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $45
801061f2:	6a 2d                	push   $0x2d
  jmp alltraps
801061f4:	e9 b6 f9 ff ff       	jmp    80105baf <alltraps>

801061f9 <vector46>:
.globl vector46
vector46:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $46
801061fb:	6a 2e                	push   $0x2e
  jmp alltraps
801061fd:	e9 ad f9 ff ff       	jmp    80105baf <alltraps>

80106202 <vector47>:
.globl vector47
vector47:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $47
80106204:	6a 2f                	push   $0x2f
  jmp alltraps
80106206:	e9 a4 f9 ff ff       	jmp    80105baf <alltraps>

8010620b <vector48>:
.globl vector48
vector48:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $48
8010620d:	6a 30                	push   $0x30
  jmp alltraps
8010620f:	e9 9b f9 ff ff       	jmp    80105baf <alltraps>

80106214 <vector49>:
.globl vector49
vector49:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $49
80106216:	6a 31                	push   $0x31
  jmp alltraps
80106218:	e9 92 f9 ff ff       	jmp    80105baf <alltraps>

8010621d <vector50>:
.globl vector50
vector50:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $50
8010621f:	6a 32                	push   $0x32
  jmp alltraps
80106221:	e9 89 f9 ff ff       	jmp    80105baf <alltraps>

80106226 <vector51>:
.globl vector51
vector51:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $51
80106228:	6a 33                	push   $0x33
  jmp alltraps
8010622a:	e9 80 f9 ff ff       	jmp    80105baf <alltraps>

8010622f <vector52>:
.globl vector52
vector52:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $52
80106231:	6a 34                	push   $0x34
  jmp alltraps
80106233:	e9 77 f9 ff ff       	jmp    80105baf <alltraps>

80106238 <vector53>:
.globl vector53
vector53:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $53
8010623a:	6a 35                	push   $0x35
  jmp alltraps
8010623c:	e9 6e f9 ff ff       	jmp    80105baf <alltraps>

80106241 <vector54>:
.globl vector54
vector54:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $54
80106243:	6a 36                	push   $0x36
  jmp alltraps
80106245:	e9 65 f9 ff ff       	jmp    80105baf <alltraps>

8010624a <vector55>:
.globl vector55
vector55:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $55
8010624c:	6a 37                	push   $0x37
  jmp alltraps
8010624e:	e9 5c f9 ff ff       	jmp    80105baf <alltraps>

80106253 <vector56>:
.globl vector56
vector56:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $56
80106255:	6a 38                	push   $0x38
  jmp alltraps
80106257:	e9 53 f9 ff ff       	jmp    80105baf <alltraps>

8010625c <vector57>:
.globl vector57
vector57:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $57
8010625e:	6a 39                	push   $0x39
  jmp alltraps
80106260:	e9 4a f9 ff ff       	jmp    80105baf <alltraps>

80106265 <vector58>:
.globl vector58
vector58:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $58
80106267:	6a 3a                	push   $0x3a
  jmp alltraps
80106269:	e9 41 f9 ff ff       	jmp    80105baf <alltraps>

8010626e <vector59>:
.globl vector59
vector59:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $59
80106270:	6a 3b                	push   $0x3b
  jmp alltraps
80106272:	e9 38 f9 ff ff       	jmp    80105baf <alltraps>

80106277 <vector60>:
.globl vector60
vector60:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $60
80106279:	6a 3c                	push   $0x3c
  jmp alltraps
8010627b:	e9 2f f9 ff ff       	jmp    80105baf <alltraps>

80106280 <vector61>:
.globl vector61
vector61:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $61
80106282:	6a 3d                	push   $0x3d
  jmp alltraps
80106284:	e9 26 f9 ff ff       	jmp    80105baf <alltraps>

80106289 <vector62>:
.globl vector62
vector62:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $62
8010628b:	6a 3e                	push   $0x3e
  jmp alltraps
8010628d:	e9 1d f9 ff ff       	jmp    80105baf <alltraps>

80106292 <vector63>:
.globl vector63
vector63:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $63
80106294:	6a 3f                	push   $0x3f
  jmp alltraps
80106296:	e9 14 f9 ff ff       	jmp    80105baf <alltraps>

8010629b <vector64>:
.globl vector64
vector64:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $64
8010629d:	6a 40                	push   $0x40
  jmp alltraps
8010629f:	e9 0b f9 ff ff       	jmp    80105baf <alltraps>

801062a4 <vector65>:
.globl vector65
vector65:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $65
801062a6:	6a 41                	push   $0x41
  jmp alltraps
801062a8:	e9 02 f9 ff ff       	jmp    80105baf <alltraps>

801062ad <vector66>:
.globl vector66
vector66:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $66
801062af:	6a 42                	push   $0x42
  jmp alltraps
801062b1:	e9 f9 f8 ff ff       	jmp    80105baf <alltraps>

801062b6 <vector67>:
.globl vector67
vector67:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $67
801062b8:	6a 43                	push   $0x43
  jmp alltraps
801062ba:	e9 f0 f8 ff ff       	jmp    80105baf <alltraps>

801062bf <vector68>:
.globl vector68
vector68:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $68
801062c1:	6a 44                	push   $0x44
  jmp alltraps
801062c3:	e9 e7 f8 ff ff       	jmp    80105baf <alltraps>

801062c8 <vector69>:
.globl vector69
vector69:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $69
801062ca:	6a 45                	push   $0x45
  jmp alltraps
801062cc:	e9 de f8 ff ff       	jmp    80105baf <alltraps>

801062d1 <vector70>:
.globl vector70
vector70:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $70
801062d3:	6a 46                	push   $0x46
  jmp alltraps
801062d5:	e9 d5 f8 ff ff       	jmp    80105baf <alltraps>

801062da <vector71>:
.globl vector71
vector71:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $71
801062dc:	6a 47                	push   $0x47
  jmp alltraps
801062de:	e9 cc f8 ff ff       	jmp    80105baf <alltraps>

801062e3 <vector72>:
.globl vector72
vector72:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $72
801062e5:	6a 48                	push   $0x48
  jmp alltraps
801062e7:	e9 c3 f8 ff ff       	jmp    80105baf <alltraps>

801062ec <vector73>:
.globl vector73
vector73:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $73
801062ee:	6a 49                	push   $0x49
  jmp alltraps
801062f0:	e9 ba f8 ff ff       	jmp    80105baf <alltraps>

801062f5 <vector74>:
.globl vector74
vector74:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $74
801062f7:	6a 4a                	push   $0x4a
  jmp alltraps
801062f9:	e9 b1 f8 ff ff       	jmp    80105baf <alltraps>

801062fe <vector75>:
.globl vector75
vector75:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $75
80106300:	6a 4b                	push   $0x4b
  jmp alltraps
80106302:	e9 a8 f8 ff ff       	jmp    80105baf <alltraps>

80106307 <vector76>:
.globl vector76
vector76:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $76
80106309:	6a 4c                	push   $0x4c
  jmp alltraps
8010630b:	e9 9f f8 ff ff       	jmp    80105baf <alltraps>

80106310 <vector77>:
.globl vector77
vector77:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $77
80106312:	6a 4d                	push   $0x4d
  jmp alltraps
80106314:	e9 96 f8 ff ff       	jmp    80105baf <alltraps>

80106319 <vector78>:
.globl vector78
vector78:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $78
8010631b:	6a 4e                	push   $0x4e
  jmp alltraps
8010631d:	e9 8d f8 ff ff       	jmp    80105baf <alltraps>

80106322 <vector79>:
.globl vector79
vector79:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $79
80106324:	6a 4f                	push   $0x4f
  jmp alltraps
80106326:	e9 84 f8 ff ff       	jmp    80105baf <alltraps>

8010632b <vector80>:
.globl vector80
vector80:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $80
8010632d:	6a 50                	push   $0x50
  jmp alltraps
8010632f:	e9 7b f8 ff ff       	jmp    80105baf <alltraps>

80106334 <vector81>:
.globl vector81
vector81:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $81
80106336:	6a 51                	push   $0x51
  jmp alltraps
80106338:	e9 72 f8 ff ff       	jmp    80105baf <alltraps>

8010633d <vector82>:
.globl vector82
vector82:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $82
8010633f:	6a 52                	push   $0x52
  jmp alltraps
80106341:	e9 69 f8 ff ff       	jmp    80105baf <alltraps>

80106346 <vector83>:
.globl vector83
vector83:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $83
80106348:	6a 53                	push   $0x53
  jmp alltraps
8010634a:	e9 60 f8 ff ff       	jmp    80105baf <alltraps>

8010634f <vector84>:
.globl vector84
vector84:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $84
80106351:	6a 54                	push   $0x54
  jmp alltraps
80106353:	e9 57 f8 ff ff       	jmp    80105baf <alltraps>

80106358 <vector85>:
.globl vector85
vector85:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $85
8010635a:	6a 55                	push   $0x55
  jmp alltraps
8010635c:	e9 4e f8 ff ff       	jmp    80105baf <alltraps>

80106361 <vector86>:
.globl vector86
vector86:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $86
80106363:	6a 56                	push   $0x56
  jmp alltraps
80106365:	e9 45 f8 ff ff       	jmp    80105baf <alltraps>

8010636a <vector87>:
.globl vector87
vector87:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $87
8010636c:	6a 57                	push   $0x57
  jmp alltraps
8010636e:	e9 3c f8 ff ff       	jmp    80105baf <alltraps>

80106373 <vector88>:
.globl vector88
vector88:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $88
80106375:	6a 58                	push   $0x58
  jmp alltraps
80106377:	e9 33 f8 ff ff       	jmp    80105baf <alltraps>

8010637c <vector89>:
.globl vector89
vector89:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $89
8010637e:	6a 59                	push   $0x59
  jmp alltraps
80106380:	e9 2a f8 ff ff       	jmp    80105baf <alltraps>

80106385 <vector90>:
.globl vector90
vector90:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $90
80106387:	6a 5a                	push   $0x5a
  jmp alltraps
80106389:	e9 21 f8 ff ff       	jmp    80105baf <alltraps>

8010638e <vector91>:
.globl vector91
vector91:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $91
80106390:	6a 5b                	push   $0x5b
  jmp alltraps
80106392:	e9 18 f8 ff ff       	jmp    80105baf <alltraps>

80106397 <vector92>:
.globl vector92
vector92:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $92
80106399:	6a 5c                	push   $0x5c
  jmp alltraps
8010639b:	e9 0f f8 ff ff       	jmp    80105baf <alltraps>

801063a0 <vector93>:
.globl vector93
vector93:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $93
801063a2:	6a 5d                	push   $0x5d
  jmp alltraps
801063a4:	e9 06 f8 ff ff       	jmp    80105baf <alltraps>

801063a9 <vector94>:
.globl vector94
vector94:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $94
801063ab:	6a 5e                	push   $0x5e
  jmp alltraps
801063ad:	e9 fd f7 ff ff       	jmp    80105baf <alltraps>

801063b2 <vector95>:
.globl vector95
vector95:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $95
801063b4:	6a 5f                	push   $0x5f
  jmp alltraps
801063b6:	e9 f4 f7 ff ff       	jmp    80105baf <alltraps>

801063bb <vector96>:
.globl vector96
vector96:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $96
801063bd:	6a 60                	push   $0x60
  jmp alltraps
801063bf:	e9 eb f7 ff ff       	jmp    80105baf <alltraps>

801063c4 <vector97>:
.globl vector97
vector97:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $97
801063c6:	6a 61                	push   $0x61
  jmp alltraps
801063c8:	e9 e2 f7 ff ff       	jmp    80105baf <alltraps>

801063cd <vector98>:
.globl vector98
vector98:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $98
801063cf:	6a 62                	push   $0x62
  jmp alltraps
801063d1:	e9 d9 f7 ff ff       	jmp    80105baf <alltraps>

801063d6 <vector99>:
.globl vector99
vector99:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $99
801063d8:	6a 63                	push   $0x63
  jmp alltraps
801063da:	e9 d0 f7 ff ff       	jmp    80105baf <alltraps>

801063df <vector100>:
.globl vector100
vector100:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $100
801063e1:	6a 64                	push   $0x64
  jmp alltraps
801063e3:	e9 c7 f7 ff ff       	jmp    80105baf <alltraps>

801063e8 <vector101>:
.globl vector101
vector101:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $101
801063ea:	6a 65                	push   $0x65
  jmp alltraps
801063ec:	e9 be f7 ff ff       	jmp    80105baf <alltraps>

801063f1 <vector102>:
.globl vector102
vector102:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $102
801063f3:	6a 66                	push   $0x66
  jmp alltraps
801063f5:	e9 b5 f7 ff ff       	jmp    80105baf <alltraps>

801063fa <vector103>:
.globl vector103
vector103:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $103
801063fc:	6a 67                	push   $0x67
  jmp alltraps
801063fe:	e9 ac f7 ff ff       	jmp    80105baf <alltraps>

80106403 <vector104>:
.globl vector104
vector104:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $104
80106405:	6a 68                	push   $0x68
  jmp alltraps
80106407:	e9 a3 f7 ff ff       	jmp    80105baf <alltraps>

8010640c <vector105>:
.globl vector105
vector105:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $105
8010640e:	6a 69                	push   $0x69
  jmp alltraps
80106410:	e9 9a f7 ff ff       	jmp    80105baf <alltraps>

80106415 <vector106>:
.globl vector106
vector106:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $106
80106417:	6a 6a                	push   $0x6a
  jmp alltraps
80106419:	e9 91 f7 ff ff       	jmp    80105baf <alltraps>

8010641e <vector107>:
.globl vector107
vector107:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $107
80106420:	6a 6b                	push   $0x6b
  jmp alltraps
80106422:	e9 88 f7 ff ff       	jmp    80105baf <alltraps>

80106427 <vector108>:
.globl vector108
vector108:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $108
80106429:	6a 6c                	push   $0x6c
  jmp alltraps
8010642b:	e9 7f f7 ff ff       	jmp    80105baf <alltraps>

80106430 <vector109>:
.globl vector109
vector109:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $109
80106432:	6a 6d                	push   $0x6d
  jmp alltraps
80106434:	e9 76 f7 ff ff       	jmp    80105baf <alltraps>

80106439 <vector110>:
.globl vector110
vector110:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $110
8010643b:	6a 6e                	push   $0x6e
  jmp alltraps
8010643d:	e9 6d f7 ff ff       	jmp    80105baf <alltraps>

80106442 <vector111>:
.globl vector111
vector111:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $111
80106444:	6a 6f                	push   $0x6f
  jmp alltraps
80106446:	e9 64 f7 ff ff       	jmp    80105baf <alltraps>

8010644b <vector112>:
.globl vector112
vector112:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $112
8010644d:	6a 70                	push   $0x70
  jmp alltraps
8010644f:	e9 5b f7 ff ff       	jmp    80105baf <alltraps>

80106454 <vector113>:
.globl vector113
vector113:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $113
80106456:	6a 71                	push   $0x71
  jmp alltraps
80106458:	e9 52 f7 ff ff       	jmp    80105baf <alltraps>

8010645d <vector114>:
.globl vector114
vector114:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $114
8010645f:	6a 72                	push   $0x72
  jmp alltraps
80106461:	e9 49 f7 ff ff       	jmp    80105baf <alltraps>

80106466 <vector115>:
.globl vector115
vector115:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $115
80106468:	6a 73                	push   $0x73
  jmp alltraps
8010646a:	e9 40 f7 ff ff       	jmp    80105baf <alltraps>

8010646f <vector116>:
.globl vector116
vector116:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $116
80106471:	6a 74                	push   $0x74
  jmp alltraps
80106473:	e9 37 f7 ff ff       	jmp    80105baf <alltraps>

80106478 <vector117>:
.globl vector117
vector117:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $117
8010647a:	6a 75                	push   $0x75
  jmp alltraps
8010647c:	e9 2e f7 ff ff       	jmp    80105baf <alltraps>

80106481 <vector118>:
.globl vector118
vector118:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $118
80106483:	6a 76                	push   $0x76
  jmp alltraps
80106485:	e9 25 f7 ff ff       	jmp    80105baf <alltraps>

8010648a <vector119>:
.globl vector119
vector119:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $119
8010648c:	6a 77                	push   $0x77
  jmp alltraps
8010648e:	e9 1c f7 ff ff       	jmp    80105baf <alltraps>

80106493 <vector120>:
.globl vector120
vector120:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $120
80106495:	6a 78                	push   $0x78
  jmp alltraps
80106497:	e9 13 f7 ff ff       	jmp    80105baf <alltraps>

8010649c <vector121>:
.globl vector121
vector121:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $121
8010649e:	6a 79                	push   $0x79
  jmp alltraps
801064a0:	e9 0a f7 ff ff       	jmp    80105baf <alltraps>

801064a5 <vector122>:
.globl vector122
vector122:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $122
801064a7:	6a 7a                	push   $0x7a
  jmp alltraps
801064a9:	e9 01 f7 ff ff       	jmp    80105baf <alltraps>

801064ae <vector123>:
.globl vector123
vector123:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $123
801064b0:	6a 7b                	push   $0x7b
  jmp alltraps
801064b2:	e9 f8 f6 ff ff       	jmp    80105baf <alltraps>

801064b7 <vector124>:
.globl vector124
vector124:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $124
801064b9:	6a 7c                	push   $0x7c
  jmp alltraps
801064bb:	e9 ef f6 ff ff       	jmp    80105baf <alltraps>

801064c0 <vector125>:
.globl vector125
vector125:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $125
801064c2:	6a 7d                	push   $0x7d
  jmp alltraps
801064c4:	e9 e6 f6 ff ff       	jmp    80105baf <alltraps>

801064c9 <vector126>:
.globl vector126
vector126:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $126
801064cb:	6a 7e                	push   $0x7e
  jmp alltraps
801064cd:	e9 dd f6 ff ff       	jmp    80105baf <alltraps>

801064d2 <vector127>:
.globl vector127
vector127:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $127
801064d4:	6a 7f                	push   $0x7f
  jmp alltraps
801064d6:	e9 d4 f6 ff ff       	jmp    80105baf <alltraps>

801064db <vector128>:
.globl vector128
vector128:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $128
801064dd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064e2:	e9 c8 f6 ff ff       	jmp    80105baf <alltraps>

801064e7 <vector129>:
.globl vector129
vector129:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $129
801064e9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ee:	e9 bc f6 ff ff       	jmp    80105baf <alltraps>

801064f3 <vector130>:
.globl vector130
vector130:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $130
801064f5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064fa:	e9 b0 f6 ff ff       	jmp    80105baf <alltraps>

801064ff <vector131>:
.globl vector131
vector131:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $131
80106501:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106506:	e9 a4 f6 ff ff       	jmp    80105baf <alltraps>

8010650b <vector132>:
.globl vector132
vector132:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $132
8010650d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106512:	e9 98 f6 ff ff       	jmp    80105baf <alltraps>

80106517 <vector133>:
.globl vector133
vector133:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $133
80106519:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010651e:	e9 8c f6 ff ff       	jmp    80105baf <alltraps>

80106523 <vector134>:
.globl vector134
vector134:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $134
80106525:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010652a:	e9 80 f6 ff ff       	jmp    80105baf <alltraps>

8010652f <vector135>:
.globl vector135
vector135:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $135
80106531:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106536:	e9 74 f6 ff ff       	jmp    80105baf <alltraps>

8010653b <vector136>:
.globl vector136
vector136:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $136
8010653d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106542:	e9 68 f6 ff ff       	jmp    80105baf <alltraps>

80106547 <vector137>:
.globl vector137
vector137:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $137
80106549:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010654e:	e9 5c f6 ff ff       	jmp    80105baf <alltraps>

80106553 <vector138>:
.globl vector138
vector138:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $138
80106555:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010655a:	e9 50 f6 ff ff       	jmp    80105baf <alltraps>

8010655f <vector139>:
.globl vector139
vector139:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $139
80106561:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106566:	e9 44 f6 ff ff       	jmp    80105baf <alltraps>

8010656b <vector140>:
.globl vector140
vector140:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $140
8010656d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106572:	e9 38 f6 ff ff       	jmp    80105baf <alltraps>

80106577 <vector141>:
.globl vector141
vector141:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $141
80106579:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010657e:	e9 2c f6 ff ff       	jmp    80105baf <alltraps>

80106583 <vector142>:
.globl vector142
vector142:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $142
80106585:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010658a:	e9 20 f6 ff ff       	jmp    80105baf <alltraps>

8010658f <vector143>:
.globl vector143
vector143:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $143
80106591:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106596:	e9 14 f6 ff ff       	jmp    80105baf <alltraps>

8010659b <vector144>:
.globl vector144
vector144:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $144
8010659d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065a2:	e9 08 f6 ff ff       	jmp    80105baf <alltraps>

801065a7 <vector145>:
.globl vector145
vector145:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $145
801065a9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ae:	e9 fc f5 ff ff       	jmp    80105baf <alltraps>

801065b3 <vector146>:
.globl vector146
vector146:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $146
801065b5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065ba:	e9 f0 f5 ff ff       	jmp    80105baf <alltraps>

801065bf <vector147>:
.globl vector147
vector147:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $147
801065c1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065c6:	e9 e4 f5 ff ff       	jmp    80105baf <alltraps>

801065cb <vector148>:
.globl vector148
vector148:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $148
801065cd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065d2:	e9 d8 f5 ff ff       	jmp    80105baf <alltraps>

801065d7 <vector149>:
.globl vector149
vector149:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $149
801065d9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065de:	e9 cc f5 ff ff       	jmp    80105baf <alltraps>

801065e3 <vector150>:
.globl vector150
vector150:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $150
801065e5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065ea:	e9 c0 f5 ff ff       	jmp    80105baf <alltraps>

801065ef <vector151>:
.globl vector151
vector151:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $151
801065f1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065f6:	e9 b4 f5 ff ff       	jmp    80105baf <alltraps>

801065fb <vector152>:
.globl vector152
vector152:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $152
801065fd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106602:	e9 a8 f5 ff ff       	jmp    80105baf <alltraps>

80106607 <vector153>:
.globl vector153
vector153:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $153
80106609:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010660e:	e9 9c f5 ff ff       	jmp    80105baf <alltraps>

80106613 <vector154>:
.globl vector154
vector154:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $154
80106615:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010661a:	e9 90 f5 ff ff       	jmp    80105baf <alltraps>

8010661f <vector155>:
.globl vector155
vector155:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $155
80106621:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106626:	e9 84 f5 ff ff       	jmp    80105baf <alltraps>

8010662b <vector156>:
.globl vector156
vector156:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $156
8010662d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106632:	e9 78 f5 ff ff       	jmp    80105baf <alltraps>

80106637 <vector157>:
.globl vector157
vector157:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $157
80106639:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010663e:	e9 6c f5 ff ff       	jmp    80105baf <alltraps>

80106643 <vector158>:
.globl vector158
vector158:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $158
80106645:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010664a:	e9 60 f5 ff ff       	jmp    80105baf <alltraps>

8010664f <vector159>:
.globl vector159
vector159:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $159
80106651:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106656:	e9 54 f5 ff ff       	jmp    80105baf <alltraps>

8010665b <vector160>:
.globl vector160
vector160:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $160
8010665d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106662:	e9 48 f5 ff ff       	jmp    80105baf <alltraps>

80106667 <vector161>:
.globl vector161
vector161:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $161
80106669:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010666e:	e9 3c f5 ff ff       	jmp    80105baf <alltraps>

80106673 <vector162>:
.globl vector162
vector162:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $162
80106675:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010667a:	e9 30 f5 ff ff       	jmp    80105baf <alltraps>

8010667f <vector163>:
.globl vector163
vector163:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $163
80106681:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106686:	e9 24 f5 ff ff       	jmp    80105baf <alltraps>

8010668b <vector164>:
.globl vector164
vector164:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $164
8010668d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106692:	e9 18 f5 ff ff       	jmp    80105baf <alltraps>

80106697 <vector165>:
.globl vector165
vector165:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $165
80106699:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010669e:	e9 0c f5 ff ff       	jmp    80105baf <alltraps>

801066a3 <vector166>:
.globl vector166
vector166:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $166
801066a5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066aa:	e9 00 f5 ff ff       	jmp    80105baf <alltraps>

801066af <vector167>:
.globl vector167
vector167:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $167
801066b1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066b6:	e9 f4 f4 ff ff       	jmp    80105baf <alltraps>

801066bb <vector168>:
.globl vector168
vector168:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $168
801066bd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066c2:	e9 e8 f4 ff ff       	jmp    80105baf <alltraps>

801066c7 <vector169>:
.globl vector169
vector169:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $169
801066c9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066ce:	e9 dc f4 ff ff       	jmp    80105baf <alltraps>

801066d3 <vector170>:
.globl vector170
vector170:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $170
801066d5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066da:	e9 d0 f4 ff ff       	jmp    80105baf <alltraps>

801066df <vector171>:
.globl vector171
vector171:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $171
801066e1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066e6:	e9 c4 f4 ff ff       	jmp    80105baf <alltraps>

801066eb <vector172>:
.globl vector172
vector172:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $172
801066ed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066f2:	e9 b8 f4 ff ff       	jmp    80105baf <alltraps>

801066f7 <vector173>:
.globl vector173
vector173:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $173
801066f9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066fe:	e9 ac f4 ff ff       	jmp    80105baf <alltraps>

80106703 <vector174>:
.globl vector174
vector174:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $174
80106705:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010670a:	e9 a0 f4 ff ff       	jmp    80105baf <alltraps>

8010670f <vector175>:
.globl vector175
vector175:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $175
80106711:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106716:	e9 94 f4 ff ff       	jmp    80105baf <alltraps>

8010671b <vector176>:
.globl vector176
vector176:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $176
8010671d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106722:	e9 88 f4 ff ff       	jmp    80105baf <alltraps>

80106727 <vector177>:
.globl vector177
vector177:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $177
80106729:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010672e:	e9 7c f4 ff ff       	jmp    80105baf <alltraps>

80106733 <vector178>:
.globl vector178
vector178:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $178
80106735:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010673a:	e9 70 f4 ff ff       	jmp    80105baf <alltraps>

8010673f <vector179>:
.globl vector179
vector179:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $179
80106741:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106746:	e9 64 f4 ff ff       	jmp    80105baf <alltraps>

8010674b <vector180>:
.globl vector180
vector180:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $180
8010674d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106752:	e9 58 f4 ff ff       	jmp    80105baf <alltraps>

80106757 <vector181>:
.globl vector181
vector181:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $181
80106759:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010675e:	e9 4c f4 ff ff       	jmp    80105baf <alltraps>

80106763 <vector182>:
.globl vector182
vector182:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $182
80106765:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010676a:	e9 40 f4 ff ff       	jmp    80105baf <alltraps>

8010676f <vector183>:
.globl vector183
vector183:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $183
80106771:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106776:	e9 34 f4 ff ff       	jmp    80105baf <alltraps>

8010677b <vector184>:
.globl vector184
vector184:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $184
8010677d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106782:	e9 28 f4 ff ff       	jmp    80105baf <alltraps>

80106787 <vector185>:
.globl vector185
vector185:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $185
80106789:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010678e:	e9 1c f4 ff ff       	jmp    80105baf <alltraps>

80106793 <vector186>:
.globl vector186
vector186:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $186
80106795:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010679a:	e9 10 f4 ff ff       	jmp    80105baf <alltraps>

8010679f <vector187>:
.globl vector187
vector187:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $187
801067a1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067a6:	e9 04 f4 ff ff       	jmp    80105baf <alltraps>

801067ab <vector188>:
.globl vector188
vector188:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $188
801067ad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067b2:	e9 f8 f3 ff ff       	jmp    80105baf <alltraps>

801067b7 <vector189>:
.globl vector189
vector189:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $189
801067b9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067be:	e9 ec f3 ff ff       	jmp    80105baf <alltraps>

801067c3 <vector190>:
.globl vector190
vector190:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $190
801067c5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067ca:	e9 e0 f3 ff ff       	jmp    80105baf <alltraps>

801067cf <vector191>:
.globl vector191
vector191:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $191
801067d1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067d6:	e9 d4 f3 ff ff       	jmp    80105baf <alltraps>

801067db <vector192>:
.globl vector192
vector192:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $192
801067dd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067e2:	e9 c8 f3 ff ff       	jmp    80105baf <alltraps>

801067e7 <vector193>:
.globl vector193
vector193:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $193
801067e9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ee:	e9 bc f3 ff ff       	jmp    80105baf <alltraps>

801067f3 <vector194>:
.globl vector194
vector194:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $194
801067f5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067fa:	e9 b0 f3 ff ff       	jmp    80105baf <alltraps>

801067ff <vector195>:
.globl vector195
vector195:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $195
80106801:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106806:	e9 a4 f3 ff ff       	jmp    80105baf <alltraps>

8010680b <vector196>:
.globl vector196
vector196:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $196
8010680d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106812:	e9 98 f3 ff ff       	jmp    80105baf <alltraps>

80106817 <vector197>:
.globl vector197
vector197:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $197
80106819:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010681e:	e9 8c f3 ff ff       	jmp    80105baf <alltraps>

80106823 <vector198>:
.globl vector198
vector198:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $198
80106825:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010682a:	e9 80 f3 ff ff       	jmp    80105baf <alltraps>

8010682f <vector199>:
.globl vector199
vector199:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $199
80106831:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106836:	e9 74 f3 ff ff       	jmp    80105baf <alltraps>

8010683b <vector200>:
.globl vector200
vector200:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $200
8010683d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106842:	e9 68 f3 ff ff       	jmp    80105baf <alltraps>

80106847 <vector201>:
.globl vector201
vector201:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $201
80106849:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010684e:	e9 5c f3 ff ff       	jmp    80105baf <alltraps>

80106853 <vector202>:
.globl vector202
vector202:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $202
80106855:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010685a:	e9 50 f3 ff ff       	jmp    80105baf <alltraps>

8010685f <vector203>:
.globl vector203
vector203:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $203
80106861:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106866:	e9 44 f3 ff ff       	jmp    80105baf <alltraps>

8010686b <vector204>:
.globl vector204
vector204:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $204
8010686d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106872:	e9 38 f3 ff ff       	jmp    80105baf <alltraps>

80106877 <vector205>:
.globl vector205
vector205:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $205
80106879:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010687e:	e9 2c f3 ff ff       	jmp    80105baf <alltraps>

80106883 <vector206>:
.globl vector206
vector206:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $206
80106885:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010688a:	e9 20 f3 ff ff       	jmp    80105baf <alltraps>

8010688f <vector207>:
.globl vector207
vector207:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $207
80106891:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106896:	e9 14 f3 ff ff       	jmp    80105baf <alltraps>

8010689b <vector208>:
.globl vector208
vector208:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $208
8010689d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068a2:	e9 08 f3 ff ff       	jmp    80105baf <alltraps>

801068a7 <vector209>:
.globl vector209
vector209:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $209
801068a9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ae:	e9 fc f2 ff ff       	jmp    80105baf <alltraps>

801068b3 <vector210>:
.globl vector210
vector210:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $210
801068b5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068ba:	e9 f0 f2 ff ff       	jmp    80105baf <alltraps>

801068bf <vector211>:
.globl vector211
vector211:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $211
801068c1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068c6:	e9 e4 f2 ff ff       	jmp    80105baf <alltraps>

801068cb <vector212>:
.globl vector212
vector212:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $212
801068cd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068d2:	e9 d8 f2 ff ff       	jmp    80105baf <alltraps>

801068d7 <vector213>:
.globl vector213
vector213:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $213
801068d9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068de:	e9 cc f2 ff ff       	jmp    80105baf <alltraps>

801068e3 <vector214>:
.globl vector214
vector214:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $214
801068e5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068ea:	e9 c0 f2 ff ff       	jmp    80105baf <alltraps>

801068ef <vector215>:
.globl vector215
vector215:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $215
801068f1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068f6:	e9 b4 f2 ff ff       	jmp    80105baf <alltraps>

801068fb <vector216>:
.globl vector216
vector216:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $216
801068fd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106902:	e9 a8 f2 ff ff       	jmp    80105baf <alltraps>

80106907 <vector217>:
.globl vector217
vector217:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $217
80106909:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010690e:	e9 9c f2 ff ff       	jmp    80105baf <alltraps>

80106913 <vector218>:
.globl vector218
vector218:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $218
80106915:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010691a:	e9 90 f2 ff ff       	jmp    80105baf <alltraps>

8010691f <vector219>:
.globl vector219
vector219:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $219
80106921:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106926:	e9 84 f2 ff ff       	jmp    80105baf <alltraps>

8010692b <vector220>:
.globl vector220
vector220:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $220
8010692d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106932:	e9 78 f2 ff ff       	jmp    80105baf <alltraps>

80106937 <vector221>:
.globl vector221
vector221:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $221
80106939:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010693e:	e9 6c f2 ff ff       	jmp    80105baf <alltraps>

80106943 <vector222>:
.globl vector222
vector222:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $222
80106945:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010694a:	e9 60 f2 ff ff       	jmp    80105baf <alltraps>

8010694f <vector223>:
.globl vector223
vector223:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $223
80106951:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106956:	e9 54 f2 ff ff       	jmp    80105baf <alltraps>

8010695b <vector224>:
.globl vector224
vector224:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $224
8010695d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106962:	e9 48 f2 ff ff       	jmp    80105baf <alltraps>

80106967 <vector225>:
.globl vector225
vector225:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $225
80106969:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010696e:	e9 3c f2 ff ff       	jmp    80105baf <alltraps>

80106973 <vector226>:
.globl vector226
vector226:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $226
80106975:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010697a:	e9 30 f2 ff ff       	jmp    80105baf <alltraps>

8010697f <vector227>:
.globl vector227
vector227:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $227
80106981:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106986:	e9 24 f2 ff ff       	jmp    80105baf <alltraps>

8010698b <vector228>:
.globl vector228
vector228:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $228
8010698d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106992:	e9 18 f2 ff ff       	jmp    80105baf <alltraps>

80106997 <vector229>:
.globl vector229
vector229:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $229
80106999:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010699e:	e9 0c f2 ff ff       	jmp    80105baf <alltraps>

801069a3 <vector230>:
.globl vector230
vector230:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $230
801069a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069aa:	e9 00 f2 ff ff       	jmp    80105baf <alltraps>

801069af <vector231>:
.globl vector231
vector231:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $231
801069b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069b6:	e9 f4 f1 ff ff       	jmp    80105baf <alltraps>

801069bb <vector232>:
.globl vector232
vector232:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $232
801069bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069c2:	e9 e8 f1 ff ff       	jmp    80105baf <alltraps>

801069c7 <vector233>:
.globl vector233
vector233:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $233
801069c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069ce:	e9 dc f1 ff ff       	jmp    80105baf <alltraps>

801069d3 <vector234>:
.globl vector234
vector234:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $234
801069d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069da:	e9 d0 f1 ff ff       	jmp    80105baf <alltraps>

801069df <vector235>:
.globl vector235
vector235:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $235
801069e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069e6:	e9 c4 f1 ff ff       	jmp    80105baf <alltraps>

801069eb <vector236>:
.globl vector236
vector236:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $236
801069ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069f2:	e9 b8 f1 ff ff       	jmp    80105baf <alltraps>

801069f7 <vector237>:
.globl vector237
vector237:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $237
801069f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069fe:	e9 ac f1 ff ff       	jmp    80105baf <alltraps>

80106a03 <vector238>:
.globl vector238
vector238:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $238
80106a05:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a0a:	e9 a0 f1 ff ff       	jmp    80105baf <alltraps>

80106a0f <vector239>:
.globl vector239
vector239:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $239
80106a11:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a16:	e9 94 f1 ff ff       	jmp    80105baf <alltraps>

80106a1b <vector240>:
.globl vector240
vector240:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $240
80106a1d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a22:	e9 88 f1 ff ff       	jmp    80105baf <alltraps>

80106a27 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $241
80106a29:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a2e:	e9 7c f1 ff ff       	jmp    80105baf <alltraps>

80106a33 <vector242>:
.globl vector242
vector242:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $242
80106a35:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a3a:	e9 70 f1 ff ff       	jmp    80105baf <alltraps>

80106a3f <vector243>:
.globl vector243
vector243:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $243
80106a41:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a46:	e9 64 f1 ff ff       	jmp    80105baf <alltraps>

80106a4b <vector244>:
.globl vector244
vector244:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $244
80106a4d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a52:	e9 58 f1 ff ff       	jmp    80105baf <alltraps>

80106a57 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $245
80106a59:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a5e:	e9 4c f1 ff ff       	jmp    80105baf <alltraps>

80106a63 <vector246>:
.globl vector246
vector246:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $246
80106a65:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a6a:	e9 40 f1 ff ff       	jmp    80105baf <alltraps>

80106a6f <vector247>:
.globl vector247
vector247:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $247
80106a71:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a76:	e9 34 f1 ff ff       	jmp    80105baf <alltraps>

80106a7b <vector248>:
.globl vector248
vector248:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $248
80106a7d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a82:	e9 28 f1 ff ff       	jmp    80105baf <alltraps>

80106a87 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $249
80106a89:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a8e:	e9 1c f1 ff ff       	jmp    80105baf <alltraps>

80106a93 <vector250>:
.globl vector250
vector250:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $250
80106a95:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a9a:	e9 10 f1 ff ff       	jmp    80105baf <alltraps>

80106a9f <vector251>:
.globl vector251
vector251:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $251
80106aa1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106aa6:	e9 04 f1 ff ff       	jmp    80105baf <alltraps>

80106aab <vector252>:
.globl vector252
vector252:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $252
80106aad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ab2:	e9 f8 f0 ff ff       	jmp    80105baf <alltraps>

80106ab7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $253
80106ab9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106abe:	e9 ec f0 ff ff       	jmp    80105baf <alltraps>

80106ac3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $254
80106ac5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106aca:	e9 e0 f0 ff ff       	jmp    80105baf <alltraps>

80106acf <vector255>:
.globl vector255
vector255:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $255
80106ad1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ad6:	e9 d4 f0 ff ff       	jmp    80105baf <alltraps>
80106adb:	66 90                	xchg   %ax,%ax
80106add:	66 90                	xchg   %ax,%ax
80106adf:	90                   	nop

80106ae0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ae7:	c1 ea 16             	shr    $0x16,%edx
{
80106aea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106aeb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106aee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106af1:	8b 1f                	mov    (%edi),%ebx
80106af3:	f6 c3 01             	test   $0x1,%bl
80106af6:	74 28                	je     80106b20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106af8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106afe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b04:	89 f0                	mov    %esi,%eax
}
80106b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b09:	c1 e8 0a             	shr    $0xa,%eax
80106b0c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b11:	01 d8                	add    %ebx,%eax
}
80106b13:	5b                   	pop    %ebx
80106b14:	5e                   	pop    %esi
80106b15:	5f                   	pop    %edi
80106b16:	5d                   	pop    %ebp
80106b17:	c3                   	ret    
80106b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b20:	85 c9                	test   %ecx,%ecx
80106b22:	74 2c                	je     80106b50 <walkpgdir+0x70>
80106b24:	e8 17 bb ff ff       	call   80102640 <kalloc>
80106b29:	89 c3                	mov    %eax,%ebx
80106b2b:	85 c0                	test   %eax,%eax
80106b2d:	74 21                	je     80106b50 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b2f:	83 ec 04             	sub    $0x4,%esp
80106b32:	68 00 10 00 00       	push   $0x1000
80106b37:	6a 00                	push   $0x0
80106b39:	50                   	push   %eax
80106b3a:	e8 31 dd ff ff       	call   80104870 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b45:	83 c4 10             	add    $0x10,%esp
80106b48:	83 c8 07             	or     $0x7,%eax
80106b4b:	89 07                	mov    %eax,(%edi)
80106b4d:	eb b5                	jmp    80106b04 <walkpgdir+0x24>
80106b4f:	90                   	nop
}
80106b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b53:	31 c0                	xor    %eax,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b66:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106b6a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106b70:	89 d6                	mov    %edx,%esi
{
80106b72:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b73:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106b79:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106b82:	29 f0                	sub    %esi,%eax
80106b84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b87:	eb 1f                	jmp    80106ba8 <mappages+0x48>
80106b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b90:	f6 00 01             	testb  $0x1,(%eax)
80106b93:	75 45                	jne    80106bda <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b95:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106b98:	83 cb 01             	or     $0x1,%ebx
80106b9b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106b9d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106ba0:	74 2e                	je     80106bd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106ba2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bab:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bb0:	89 f2                	mov    %esi,%edx
80106bb2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106bb5:	89 f8                	mov    %edi,%eax
80106bb7:	e8 24 ff ff ff       	call   80106ae0 <walkpgdir>
80106bbc:	85 c0                	test   %eax,%eax
80106bbe:	75 d0                	jne    80106b90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret    
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bd3:	31 c0                	xor    %eax,%eax
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret    
      panic("remap");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 f8 80 10 80       	push   $0x801080f8
80106be2:	e8 a9 97 ff ff       	call   80100390 <panic>
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	89 c6                	mov    %eax,%esi
80106bf7:	53                   	push   %ebx
80106bf8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bfa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106c00:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c0c:	39 da                	cmp    %ebx,%edx
80106c0e:	73 5b                	jae    80106c6b <deallocuvm.part.0+0x7b>
80106c10:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106c13:	89 d7                	mov    %edx,%edi
80106c15:	eb 14                	jmp    80106c2b <deallocuvm.part.0+0x3b>
80106c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1e:	66 90                	xchg   %ax,%ax
80106c20:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106c26:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106c29:	76 40                	jbe    80106c6b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c2b:	31 c9                	xor    %ecx,%ecx
80106c2d:	89 fa                	mov    %edi,%edx
80106c2f:	89 f0                	mov    %esi,%eax
80106c31:	e8 aa fe ff ff       	call   80106ae0 <walkpgdir>
80106c36:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106c38:	85 c0                	test   %eax,%eax
80106c3a:	74 44                	je     80106c80 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c3c:	8b 00                	mov    (%eax),%eax
80106c3e:	a8 01                	test   $0x1,%al
80106c40:	74 de                	je     80106c20 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c47:	74 47                	je     80106c90 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c49:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c4c:	05 00 00 00 80       	add    $0x80000000,%eax
80106c51:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106c57:	50                   	push   %eax
80106c58:	e8 23 b8 ff ff       	call   80102480 <kfree>
      *pte = 0;
80106c5d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106c63:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c66:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106c69:	77 c0                	ja     80106c2b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c71:	5b                   	pop    %ebx
80106c72:	5e                   	pop    %esi
80106c73:	5f                   	pop    %edi
80106c74:	5d                   	pop    %ebp
80106c75:	c3                   	ret    
80106c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c80:	89 fa                	mov    %edi,%edx
80106c82:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106c88:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106c8e:	eb 96                	jmp    80106c26 <deallocuvm.part.0+0x36>
        panic("kfree");
80106c90:	83 ec 0c             	sub    $0xc,%esp
80106c93:	68 a6 7a 10 80       	push   $0x80107aa6
80106c98:	e8 f3 96 ff ff       	call   80100390 <panic>
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ca0 <seginit>:
{
80106ca0:	f3 0f 1e fb          	endbr32 
80106ca4:	55                   	push   %ebp
80106ca5:	89 e5                	mov    %esp,%ebp
80106ca7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106caa:	e8 21 cd ff ff       	call   801039d0 <cpuid>
  pd[0] = size-1;
80106caf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cb4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cbe:	c7 80 b8 41 11 80 ff 	movl   $0xffff,-0x7feebe48(%eax)
80106cc5:	ff 00 00 
80106cc8:	c7 80 bc 41 11 80 00 	movl   $0xcf9a00,-0x7feebe44(%eax)
80106ccf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cd2:	c7 80 c0 41 11 80 ff 	movl   $0xffff,-0x7feebe40(%eax)
80106cd9:	ff 00 00 
80106cdc:	c7 80 c4 41 11 80 00 	movl   $0xcf9200,-0x7feebe3c(%eax)
80106ce3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ce6:	c7 80 c8 41 11 80 ff 	movl   $0xffff,-0x7feebe38(%eax)
80106ced:	ff 00 00 
80106cf0:	c7 80 cc 41 11 80 00 	movl   $0xcffa00,-0x7feebe34(%eax)
80106cf7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cfa:	c7 80 d0 41 11 80 ff 	movl   $0xffff,-0x7feebe30(%eax)
80106d01:	ff 00 00 
80106d04:	c7 80 d4 41 11 80 00 	movl   $0xcff200,-0x7feebe2c(%eax)
80106d0b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d0e:	05 b0 41 11 80       	add    $0x801141b0,%eax
  pd[1] = (uint)p;
80106d13:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d17:	c1 e8 10             	shr    $0x10,%eax
80106d1a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d1e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d21:	0f 01 10             	lgdtl  (%eax)
}
80106d24:	c9                   	leave  
80106d25:	c3                   	ret    
80106d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi

80106d30 <switchkvm>:
{
80106d30:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d34:	a1 64 71 11 80       	mov    0x80117164,%eax
80106d39:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d3e:	0f 22 d8             	mov    %eax,%cr3
}
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d50 <switchuvm>:
{
80106d50:	f3 0f 1e fb          	endbr32 
80106d54:	55                   	push   %ebp
80106d55:	89 e5                	mov    %esp,%ebp
80106d57:	57                   	push   %edi
80106d58:	56                   	push   %esi
80106d59:	53                   	push   %ebx
80106d5a:	83 ec 1c             	sub    $0x1c,%esp
80106d5d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d60:	85 f6                	test   %esi,%esi
80106d62:	0f 84 cb 00 00 00    	je     80106e33 <switchuvm+0xe3>
  if(p->kstack == 0)
80106d68:	8b 46 08             	mov    0x8(%esi),%eax
80106d6b:	85 c0                	test   %eax,%eax
80106d6d:	0f 84 da 00 00 00    	je     80106e4d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106d73:	8b 46 04             	mov    0x4(%esi),%eax
80106d76:	85 c0                	test   %eax,%eax
80106d78:	0f 84 c2 00 00 00    	je     80106e40 <switchuvm+0xf0>
  pushcli();
80106d7e:	e8 dd d8 ff ff       	call   80104660 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d83:	e8 d8 cb ff ff       	call   80103960 <mycpu>
80106d88:	89 c3                	mov    %eax,%ebx
80106d8a:	e8 d1 cb ff ff       	call   80103960 <mycpu>
80106d8f:	89 c7                	mov    %eax,%edi
80106d91:	e8 ca cb ff ff       	call   80103960 <mycpu>
80106d96:	83 c7 08             	add    $0x8,%edi
80106d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d9c:	e8 bf cb ff ff       	call   80103960 <mycpu>
80106da1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106da4:	ba 67 00 00 00       	mov    $0x67,%edx
80106da9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106db0:	83 c0 08             	add    $0x8,%eax
80106db3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dbf:	83 c1 08             	add    $0x8,%ecx
80106dc2:	c1 e8 18             	shr    $0x18,%eax
80106dc5:	c1 e9 10             	shr    $0x10,%ecx
80106dc8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106dce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106dd4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106dd9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106de0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106de5:	e8 76 cb ff ff       	call   80103960 <mycpu>
80106dea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106df1:	e8 6a cb ff ff       	call   80103960 <mycpu>
80106df6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dfa:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dfd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e03:	e8 58 cb ff ff       	call   80103960 <mycpu>
80106e08:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e0b:	e8 50 cb ff ff       	call   80103960 <mycpu>
80106e10:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e14:	b8 28 00 00 00       	mov    $0x28,%eax
80106e19:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e1c:	8b 46 04             	mov    0x4(%esi),%eax
80106e1f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e24:	0f 22 d8             	mov    %eax,%cr3
}
80106e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2a:	5b                   	pop    %ebx
80106e2b:	5e                   	pop    %esi
80106e2c:	5f                   	pop    %edi
80106e2d:	5d                   	pop    %ebp
  popcli();
80106e2e:	e9 7d d8 ff ff       	jmp    801046b0 <popcli>
    panic("switchuvm: no process");
80106e33:	83 ec 0c             	sub    $0xc,%esp
80106e36:	68 fe 80 10 80       	push   $0x801080fe
80106e3b:	e8 50 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e40:	83 ec 0c             	sub    $0xc,%esp
80106e43:	68 29 81 10 80       	push   $0x80108129
80106e48:	e8 43 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e4d:	83 ec 0c             	sub    $0xc,%esp
80106e50:	68 14 81 10 80       	push   $0x80108114
80106e55:	e8 36 95 ff ff       	call   80100390 <panic>
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <inituvm>:
{
80106e60:	f3 0f 1e fb          	endbr32 
80106e64:	55                   	push   %ebp
80106e65:	89 e5                	mov    %esp,%ebp
80106e67:	57                   	push   %edi
80106e68:	56                   	push   %esi
80106e69:	53                   	push   %ebx
80106e6a:	83 ec 1c             	sub    $0x1c,%esp
80106e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e70:	8b 75 10             	mov    0x10(%ebp),%esi
80106e73:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e79:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e7f:	77 4b                	ja     80106ecc <inituvm+0x6c>
  mem = kalloc();
80106e81:	e8 ba b7 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80106e86:	83 ec 04             	sub    $0x4,%esp
80106e89:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e8e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e90:	6a 00                	push   $0x0
80106e92:	50                   	push   %eax
80106e93:	e8 d8 d9 ff ff       	call   80104870 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e98:	58                   	pop    %eax
80106e99:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e9f:	5a                   	pop    %edx
80106ea0:	6a 06                	push   $0x6
80106ea2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ea7:	31 d2                	xor    %edx,%edx
80106ea9:	50                   	push   %eax
80106eaa:	89 f8                	mov    %edi,%eax
80106eac:	e8 af fc ff ff       	call   80106b60 <mappages>
  memmove(mem, init, sz);
80106eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb4:	89 75 10             	mov    %esi,0x10(%ebp)
80106eb7:	83 c4 10             	add    $0x10,%esp
80106eba:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ebd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec3:	5b                   	pop    %ebx
80106ec4:	5e                   	pop    %esi
80106ec5:	5f                   	pop    %edi
80106ec6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ec7:	e9 44 da ff ff       	jmp    80104910 <memmove>
    panic("inituvm: more than a page");
80106ecc:	83 ec 0c             	sub    $0xc,%esp
80106ecf:	68 3d 81 10 80       	push   $0x8010813d
80106ed4:	e8 b7 94 ff ff       	call   80100390 <panic>
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ee0 <loaduvm>:
{
80106ee0:	f3 0f 1e fb          	endbr32 
80106ee4:	55                   	push   %ebp
80106ee5:	89 e5                	mov    %esp,%ebp
80106ee7:	57                   	push   %edi
80106ee8:	56                   	push   %esi
80106ee9:	53                   	push   %ebx
80106eea:	83 ec 1c             	sub    $0x1c,%esp
80106eed:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ef0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ef3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ef8:	0f 85 99 00 00 00    	jne    80106f97 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106efe:	01 f0                	add    %esi,%eax
80106f00:	89 f3                	mov    %esi,%ebx
80106f02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f05:	8b 45 14             	mov    0x14(%ebp),%eax
80106f08:	01 f0                	add    %esi,%eax
80106f0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f0d:	85 f6                	test   %esi,%esi
80106f0f:	75 15                	jne    80106f26 <loaduvm+0x46>
80106f11:	eb 6d                	jmp    80106f80 <loaduvm+0xa0>
80106f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f17:	90                   	nop
80106f18:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f1e:	89 f0                	mov    %esi,%eax
80106f20:	29 d8                	sub    %ebx,%eax
80106f22:	39 c6                	cmp    %eax,%esi
80106f24:	76 5a                	jbe    80106f80 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f29:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2c:	31 c9                	xor    %ecx,%ecx
80106f2e:	29 da                	sub    %ebx,%edx
80106f30:	e8 ab fb ff ff       	call   80106ae0 <walkpgdir>
80106f35:	85 c0                	test   %eax,%eax
80106f37:	74 51                	je     80106f8a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106f39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f51:	29 d9                	sub    %ebx,%ecx
80106f53:	05 00 00 00 80       	add    $0x80000000,%eax
80106f58:	57                   	push   %edi
80106f59:	51                   	push   %ecx
80106f5a:	50                   	push   %eax
80106f5b:	ff 75 10             	pushl  0x10(%ebp)
80106f5e:	e8 0d ab ff ff       	call   80101a70 <readi>
80106f63:	83 c4 10             	add    $0x10,%esp
80106f66:	39 f8                	cmp    %edi,%eax
80106f68:	74 ae                	je     80106f18 <loaduvm+0x38>
}
80106f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f72:	5b                   	pop    %ebx
80106f73:	5e                   	pop    %esi
80106f74:	5f                   	pop    %edi
80106f75:	5d                   	pop    %ebp
80106f76:	c3                   	ret    
80106f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7e:	66 90                	xchg   %ax,%ax
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f83:	31 c0                	xor    %eax,%eax
}
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f8a:	83 ec 0c             	sub    $0xc,%esp
80106f8d:	68 57 81 10 80       	push   $0x80108157
80106f92:	e8 f9 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f97:	83 ec 0c             	sub    $0xc,%esp
80106f9a:	68 18 82 10 80       	push   $0x80108218
80106f9f:	e8 ec 93 ff ff       	call   80100390 <panic>
80106fa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop

80106fb0 <allocuvm>:
{
80106fb0:	f3 0f 1e fb          	endbr32 
80106fb4:	55                   	push   %ebp
80106fb5:	89 e5                	mov    %esp,%ebp
80106fb7:	57                   	push   %edi
80106fb8:	56                   	push   %esi
80106fb9:	53                   	push   %ebx
80106fba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fbd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106fc0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106fc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fc6:	85 c0                	test   %eax,%eax
80106fc8:	0f 88 b2 00 00 00    	js     80107080 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106fd4:	0f 82 96 00 00 00    	jb     80107070 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fda:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fe0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fe6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fe9:	77 40                	ja     8010702b <allocuvm+0x7b>
80106feb:	e9 83 00 00 00       	jmp    80107073 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	68 00 10 00 00       	push   $0x1000
80106ff8:	6a 00                	push   $0x0
80106ffa:	50                   	push   %eax
80106ffb:	e8 70 d8 ff ff       	call   80104870 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107000:	58                   	pop    %eax
80107001:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107007:	5a                   	pop    %edx
80107008:	6a 06                	push   $0x6
8010700a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010700f:	89 f2                	mov    %esi,%edx
80107011:	50                   	push   %eax
80107012:	89 f8                	mov    %edi,%eax
80107014:	e8 47 fb ff ff       	call   80106b60 <mappages>
80107019:	83 c4 10             	add    $0x10,%esp
8010701c:	85 c0                	test   %eax,%eax
8010701e:	78 78                	js     80107098 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107020:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107026:	39 75 10             	cmp    %esi,0x10(%ebp)
80107029:	76 48                	jbe    80107073 <allocuvm+0xc3>
    mem = kalloc();
8010702b:	e8 10 b6 ff ff       	call   80102640 <kalloc>
80107030:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107032:	85 c0                	test   %eax,%eax
80107034:	75 ba                	jne    80106ff0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	68 75 81 10 80       	push   $0x80108175
8010703e:	e8 6d 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107043:	8b 45 0c             	mov    0xc(%ebp),%eax
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	39 45 10             	cmp    %eax,0x10(%ebp)
8010704c:	74 32                	je     80107080 <allocuvm+0xd0>
8010704e:	8b 55 10             	mov    0x10(%ebp),%edx
80107051:	89 c1                	mov    %eax,%ecx
80107053:	89 f8                	mov    %edi,%eax
80107055:	e8 96 fb ff ff       	call   80106bf0 <deallocuvm.part.0>
      return 0;
8010705a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107067:	5b                   	pop    %ebx
80107068:	5e                   	pop    %esi
80107069:	5f                   	pop    %edi
8010706a:	5d                   	pop    %ebp
8010706b:	c3                   	ret    
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107070:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107079:	5b                   	pop    %ebx
8010707a:	5e                   	pop    %esi
8010707b:	5f                   	pop    %edi
8010707c:	5d                   	pop    %ebp
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax
    return 0;
80107080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 8d 81 10 80       	push   $0x8010818d
801070a0:	e8 0b 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801070a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a8:	83 c4 10             	add    $0x10,%esp
801070ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ae:	74 0c                	je     801070bc <allocuvm+0x10c>
801070b0:	8b 55 10             	mov    0x10(%ebp),%edx
801070b3:	89 c1                	mov    %eax,%ecx
801070b5:	89 f8                	mov    %edi,%eax
801070b7:	e8 34 fb ff ff       	call   80106bf0 <deallocuvm.part.0>
      kfree(mem);
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	53                   	push   %ebx
801070c0:	e8 bb b3 ff ff       	call   80102480 <kfree>
      return 0;
801070c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801070cc:	83 c4 10             	add    $0x10,%esp
}
801070cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <deallocuvm>:
{
801070e0:	f3 0f 1e fb          	endbr32 
801070e4:	55                   	push   %ebp
801070e5:	89 e5                	mov    %esp,%ebp
801070e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070f0:	39 d1                	cmp    %edx,%ecx
801070f2:	73 0c                	jae    80107100 <deallocuvm+0x20>
}
801070f4:	5d                   	pop    %ebp
801070f5:	e9 f6 fa ff ff       	jmp    80106bf0 <deallocuvm.part.0>
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107100:	89 d0                	mov    %edx,%eax
80107102:	5d                   	pop    %ebp
80107103:	c3                   	ret    
80107104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop

80107110 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107110:	f3 0f 1e fb          	endbr32 
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	57                   	push   %edi
80107118:	56                   	push   %esi
80107119:	53                   	push   %ebx
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107120:	85 f6                	test   %esi,%esi
80107122:	74 55                	je     80107179 <freevm+0x69>
  if(newsz >= oldsz)
80107124:	31 c9                	xor    %ecx,%ecx
80107126:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010712b:	89 f0                	mov    %esi,%eax
8010712d:	89 f3                	mov    %esi,%ebx
8010712f:	e8 bc fa ff ff       	call   80106bf0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107134:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010713a:	eb 0b                	jmp    80107147 <freevm+0x37>
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107140:	83 c3 04             	add    $0x4,%ebx
80107143:	39 df                	cmp    %ebx,%edi
80107145:	74 23                	je     8010716a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107147:	8b 03                	mov    (%ebx),%eax
80107149:	a8 01                	test   $0x1,%al
8010714b:	74 f3                	je     80107140 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010714d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107152:	83 ec 0c             	sub    $0xc,%esp
80107155:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107158:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010715d:	50                   	push   %eax
8010715e:	e8 1d b3 ff ff       	call   80102480 <kfree>
80107163:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107166:	39 df                	cmp    %ebx,%edi
80107168:	75 dd                	jne    80107147 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010716a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010716d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107170:	5b                   	pop    %ebx
80107171:	5e                   	pop    %esi
80107172:	5f                   	pop    %edi
80107173:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107174:	e9 07 b3 ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 a9 81 10 80       	push   $0x801081a9
80107181:	e8 0a 92 ff ff       	call   80100390 <panic>
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi

80107190 <setupkvm>:
{
80107190:	f3 0f 1e fb          	endbr32 
80107194:	55                   	push   %ebp
80107195:	89 e5                	mov    %esp,%ebp
80107197:	56                   	push   %esi
80107198:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107199:	e8 a2 b4 ff ff       	call   80102640 <kalloc>
8010719e:	89 c6                	mov    %eax,%esi
801071a0:	85 c0                	test   %eax,%eax
801071a2:	74 42                	je     801071e6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801071a4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801071ac:	68 00 10 00 00       	push   $0x1000
801071b1:	6a 00                	push   $0x0
801071b3:	50                   	push   %eax
801071b4:	e8 b7 d6 ff ff       	call   80104870 <memset>
801071b9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071bc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071bf:	83 ec 08             	sub    $0x8,%esp
801071c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071c5:	ff 73 0c             	pushl  0xc(%ebx)
801071c8:	8b 13                	mov    (%ebx),%edx
801071ca:	50                   	push   %eax
801071cb:	29 c1                	sub    %eax,%ecx
801071cd:	89 f0                	mov    %esi,%eax
801071cf:	e8 8c f9 ff ff       	call   80106b60 <mappages>
801071d4:	83 c4 10             	add    $0x10,%esp
801071d7:	85 c0                	test   %eax,%eax
801071d9:	78 15                	js     801071f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071db:	83 c3 10             	add    $0x10,%ebx
801071de:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071e4:	75 d6                	jne    801071bc <setupkvm+0x2c>
}
801071e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071e9:	89 f0                	mov    %esi,%eax
801071eb:	5b                   	pop    %ebx
801071ec:	5e                   	pop    %esi
801071ed:	5d                   	pop    %ebp
801071ee:	c3                   	ret    
801071ef:	90                   	nop
      freevm(pgdir);
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	56                   	push   %esi
      return 0;
801071f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071f6:	e8 15 ff ff ff       	call   80107110 <freevm>
      return 0;
801071fb:	83 c4 10             	add    $0x10,%esp
}
801071fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107201:	89 f0                	mov    %esi,%eax
80107203:	5b                   	pop    %ebx
80107204:	5e                   	pop    %esi
80107205:	5d                   	pop    %ebp
80107206:	c3                   	ret    
80107207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720e:	66 90                	xchg   %ax,%ax

80107210 <kvmalloc>:
{
80107210:	f3 0f 1e fb          	endbr32 
80107214:	55                   	push   %ebp
80107215:	89 e5                	mov    %esp,%ebp
80107217:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010721a:	e8 71 ff ff ff       	call   80107190 <setupkvm>
8010721f:	a3 64 71 11 80       	mov    %eax,0x80117164
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107224:	05 00 00 00 80       	add    $0x80000000,%eax
80107229:	0f 22 d8             	mov    %eax,%cr3
}
8010722c:	c9                   	leave  
8010722d:	c3                   	ret    
8010722e:	66 90                	xchg   %ax,%ax

80107230 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107235:	31 c9                	xor    %ecx,%ecx
{
80107237:	89 e5                	mov    %esp,%ebp
80107239:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010723c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010723f:	8b 45 08             	mov    0x8(%ebp),%eax
80107242:	e8 99 f8 ff ff       	call   80106ae0 <walkpgdir>
  if(pte == 0)
80107247:	85 c0                	test   %eax,%eax
80107249:	74 05                	je     80107250 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010724b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010724e:	c9                   	leave  
8010724f:	c3                   	ret    
    panic("clearpteu");
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	68 ba 81 10 80       	push   $0x801081ba
80107258:	e8 33 91 ff ff       	call   80100390 <panic>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107260:	f3 0f 1e fb          	endbr32 
80107264:	55                   	push   %ebp
80107265:	89 e5                	mov    %esp,%ebp
80107267:	57                   	push   %edi
80107268:	56                   	push   %esi
80107269:	53                   	push   %ebx
8010726a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010726d:	e8 1e ff ff ff       	call   80107190 <setupkvm>
80107272:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107275:	85 c0                	test   %eax,%eax
80107277:	0f 84 a3 00 00 00    	je     80107320 <copyuvm+0xc0>
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
8010727d:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
80107284:	0f 86 96 00 00 00    	jbe    80107320 <copyuvm+0xc0>
8010728a:	be 00 10 00 00       	mov    $0x1000,%esi
8010728f:	eb 49                	jmp    801072da <copyuvm+0x7a>
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107298:	83 ec 04             	sub    $0x4,%esp
8010729b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801072a1:	68 00 10 00 00       	push   $0x1000
801072a6:	57                   	push   %edi
801072a7:	50                   	push   %eax
801072a8:	e8 63 d6 ff ff       	call   80104910 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801072ad:	58                   	pop    %eax
801072ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072b4:	5a                   	pop    %edx
801072b5:	ff 75 e4             	pushl  -0x1c(%ebp)
801072b8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072bd:	89 f2                	mov    %esi,%edx
801072bf:	50                   	push   %eax
801072c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072c3:	e8 98 f8 ff ff       	call   80106b60 <mappages>
801072c8:	83 c4 10             	add    $0x10,%esp
801072cb:	85 c0                	test   %eax,%eax
801072cd:	78 61                	js     80107330 <copyuvm+0xd0>
  for(i = PGSIZE; i < sz; i += PGSIZE){
801072cf:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072d5:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072d8:	76 46                	jbe    80107320 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072da:	8b 45 08             	mov    0x8(%ebp),%eax
801072dd:	31 c9                	xor    %ecx,%ecx
801072df:	89 f2                	mov    %esi,%edx
801072e1:	e8 fa f7 ff ff       	call   80106ae0 <walkpgdir>
801072e6:	85 c0                	test   %eax,%eax
801072e8:	74 61                	je     8010734b <copyuvm+0xeb>
    if(!(*pte & PTE_P))
801072ea:	8b 00                	mov    (%eax),%eax
801072ec:	a8 01                	test   $0x1,%al
801072ee:	74 4e                	je     8010733e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
801072f0:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072f2:	25 ff 0f 00 00       	and    $0xfff,%eax
801072f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072fa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107300:	e8 3b b3 ff ff       	call   80102640 <kalloc>
80107305:	89 c3                	mov    %eax,%ebx
80107307:	85 c0                	test   %eax,%eax
80107309:	75 8d                	jne    80107298 <copyuvm+0x38>
    }
  }
  return d;

bad:
  freevm(d);
8010730b:	83 ec 0c             	sub    $0xc,%esp
8010730e:	ff 75 e0             	pushl  -0x20(%ebp)
80107311:	e8 fa fd ff ff       	call   80107110 <freevm>
  return 0;
80107316:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010731d:	83 c4 10             	add    $0x10,%esp
}
80107320:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	5b                   	pop    %ebx
80107327:	5e                   	pop    %esi
80107328:	5f                   	pop    %edi
80107329:	5d                   	pop    %ebp
8010732a:	c3                   	ret    
8010732b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010732f:	90                   	nop
      kfree(mem);
80107330:	83 ec 0c             	sub    $0xc,%esp
80107333:	53                   	push   %ebx
80107334:	e8 47 b1 ff ff       	call   80102480 <kfree>
      goto bad;
80107339:	83 c4 10             	add    $0x10,%esp
8010733c:	eb cd                	jmp    8010730b <copyuvm+0xab>
      panic("copyuvm: page not present");
8010733e:	83 ec 0c             	sub    $0xc,%esp
80107341:	68 de 81 10 80       	push   $0x801081de
80107346:	e8 45 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	68 c4 81 10 80       	push   $0x801081c4
80107353:	e8 38 90 ff ff       	call   80100390 <panic>
80107358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop

80107360 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107365:	31 c9                	xor    %ecx,%ecx
{
80107367:	89 e5                	mov    %esp,%ebp
80107369:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010736c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736f:	8b 45 08             	mov    0x8(%ebp),%eax
80107372:	e8 69 f7 ff ff       	call   80106ae0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107377:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107379:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010737a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010737c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107381:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107384:	05 00 00 00 80       	add    $0x80000000,%eax
80107389:	83 fa 05             	cmp    $0x5,%edx
8010738c:	ba 00 00 00 00       	mov    $0x0,%edx
80107391:	0f 45 c2             	cmovne %edx,%eax
}
80107394:	c3                   	ret    
80107395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	57                   	push   %edi
801073a8:	56                   	push   %esi
801073a9:	53                   	push   %ebx
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	8b 75 14             	mov    0x14(%ebp),%esi
801073b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073b3:	85 f6                	test   %esi,%esi
801073b5:	75 3c                	jne    801073f3 <copyout+0x53>
801073b7:	eb 67                	jmp    80107420 <copyout+0x80>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801073c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801073c3:	89 fb                	mov    %edi,%ebx
801073c5:	29 d3                	sub    %edx,%ebx
801073c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801073cd:	39 f3                	cmp    %esi,%ebx
801073cf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073d2:	29 fa                	sub    %edi,%edx
801073d4:	83 ec 04             	sub    $0x4,%esp
801073d7:	01 c2                	add    %eax,%edx
801073d9:	53                   	push   %ebx
801073da:	ff 75 10             	pushl  0x10(%ebp)
801073dd:	52                   	push   %edx
801073de:	e8 2d d5 ff ff       	call   80104910 <memmove>
    len -= n;
    buf += n;
801073e3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801073e6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801073ec:	83 c4 10             	add    $0x10,%esp
801073ef:	29 de                	sub    %ebx,%esi
801073f1:	74 2d                	je     80107420 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801073f3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801073f5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073f8:	89 55 0c             	mov    %edx,0xc(%ebp)
801073fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107401:	57                   	push   %edi
80107402:	ff 75 08             	pushl  0x8(%ebp)
80107405:	e8 56 ff ff ff       	call   80107360 <uva2ka>
    if(pa0 == 0)
8010740a:	83 c4 10             	add    $0x10,%esp
8010740d:	85 c0                	test   %eax,%eax
8010740f:	75 af                	jne    801073c0 <copyout+0x20>
  }
  return 0;
}
80107411:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107419:	5b                   	pop    %ebx
8010741a:	5e                   	pop    %esi
8010741b:	5f                   	pop    %edi
8010741c:	5d                   	pop    %ebp
8010741d:	c3                   	ret    
8010741e:	66 90                	xchg   %ax,%ax
80107420:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107423:	31 c0                	xor    %eax,%eax
}
80107425:	5b                   	pop    %ebx
80107426:	5e                   	pop    %esi
80107427:	5f                   	pop    %edi
80107428:	5d                   	pop    %ebp
80107429:	c3                   	ret    
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107430 <provide_protection>:
// Blank page.
//PAGEBREAK!
// Blank page.

//provide_protection system call makes page table entries only readable, non-writable
int provide_protection(void *addr, int len){
80107430:	f3 0f 1e fb          	endbr32 
80107434:	55                   	push   %ebp
80107435:	89 e5                	mov    %esp,%ebp
80107437:	57                   	push   %edi
80107438:	56                   	push   %esi
80107439:	53                   	push   %ebx
8010743a:	83 ec 1c             	sub    $0x1c,%esp
8010743d:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
80107440:	e8 ab c5 ff ff       	call   801039f0 <myproc>
  
  cprintf("\ncurrent : 0x%p\n", curproc);
80107445:	83 ec 08             	sub    $0x8,%esp
80107448:	50                   	push   %eax
  struct proc *curproc = myproc();
80107449:	89 c6                	mov    %eax,%esi
  cprintf("\ncurrent : 0x%p\n", curproc);
8010744b:	68 f8 81 10 80       	push   $0x801081f8
80107450:	e8 5b 92 ff ff       	call   801006b0 <cprintf>

  //if entry address points out of range to a point out of current slice(window)
  //it means it points to a region that is not currently a part of the address space
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
80107455:	8b 45 0c             	mov    0xc(%ebp),%eax
80107458:	83 c4 10             	add    $0x10,%esp
8010745b:	85 c0                	test   %eax,%eax
8010745d:	0f 8e a2 00 00 00    	jle    80107505 <provide_protection+0xd5>
80107463:	8b 45 0c             	mov    0xc(%ebp),%eax
80107466:	89 fb                	mov    %edi,%ebx
80107468:	c1 e0 0c             	shl    $0xc,%eax
8010746b:	01 f8                	add    %edi,%eax
8010746d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107470:	3b 06                	cmp    (%esi),%eax
80107472:	0f 87 8d 00 00 00    	ja     80107505 <provide_protection+0xd5>
    cprintf("\nOut of range. can't access cuz length is out of whole process length.\n");
    return -1;
  }

  //if address is out of page size (it contains more than one page so its wrong alignment)
  if((int)(((int) addr) % PGSIZE )  != 0){
80107478:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
8010747e:	0f 85 98 00 00 00    	jne    8010751c <provide_protection+0xec>
  //loop for each page
  pte_t *pte; // pointer to virtual address of the page needs protection bit changing 
  int i;

  // all pages in this address that we want to change the protection of
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80107484:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80107487:	7c 34                	jl     801074bd <provide_protection+0x8d>
80107489:	eb 65                	jmp    801074f0 <provide_protection+0xc0>
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop
    // Getting the address of the PTE in the current process's page table (pgdir)
    // that corresponds to virtual address (i)
    pte = walkpgdir(curproc->pgdir,(void*) i, 0); // get virtual address of page number i
    //check pte non zero cuz "walk page direction" return zero when fails
    //and check is available in user space and protected type
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){ // return virtual add of index 0
80107490:	8b 08                	mov    (%eax),%ecx
80107492:	89 cf                	mov    %ecx,%edi
80107494:	83 e7 05             	and    $0x5,%edi
80107497:	83 ff 05             	cmp    $0x5,%edi
8010749a:	75 31                	jne    801074cd <provide_protection+0x9d>
      // by bitwise and pte and fliped writable we make this address to read only 
      *pte = (*pte) & (~PTE_W) ; //Clearing the write bit (flip writable state) which default is "2"
      cprintf("\nPTE : 0x%p\n", pte); // points to index 0 virtual add
8010749c:	83 ec 08             	sub    $0x8,%esp
      *pte = (*pte) & (~PTE_W) ; //Clearing the write bit (flip writable state) which default is "2"
8010749f:	83 e1 fd             	and    $0xfffffffd,%ecx
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
801074a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      *pte = (*pte) & (~PTE_W) ; //Clearing the write bit (flip writable state) which default is "2"
801074a8:	89 08                	mov    %ecx,(%eax)
      cprintf("\nPTE : 0x%p\n", pte); // points to index 0 virtual add
801074aa:	50                   	push   %eax
801074ab:	68 09 82 10 80       	push   $0x80108209
801074b0:	e8 fb 91 ff ff       	call   801006b0 <cprintf>
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
801074b5:	83 c4 10             	add    $0x10,%esp
801074b8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801074bb:	7e 33                	jle    801074f0 <provide_protection+0xc0>
    pte = walkpgdir(curproc->pgdir,(void*) i, 0); // get virtual address of page number i
801074bd:	8b 46 04             	mov    0x4(%esi),%eax
801074c0:	31 c9                	xor    %ecx,%ecx
801074c2:	89 da                	mov    %ebx,%edx
801074c4:	e8 17 f6 ff ff       	call   80106ae0 <walkpgdir>
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){ // return virtual add of index 0
801074c9:	85 c0                	test   %eax,%eax
801074cb:	75 c3                	jne    80107490 <provide_protection+0x60>
    } 
    else {
      cprintf("\nError in virtual add, check available add.\n");
801074cd:	83 ec 0c             	sub    $0xc,%esp
801074d0:	68 c4 82 10 80       	push   $0x801082c4
801074d5:	e8 d6 91 ff ff       	call   801006b0 <cprintf>
      return -1;
801074da:	83 c4 10             	add    $0x10,%esp
801074dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  //Reloading the Control register 3 with the address of page directory 
  //to flush TLB by hardware and making virtual address(page direction) to physical
  lcr3(V2P(curproc->pgdir));  
  return 0; // pass successfully(it returns -1 if we've failed)
}
801074e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e5:	5b                   	pop    %ebx
801074e6:	5e                   	pop    %esi
801074e7:	5f                   	pop    %edi
801074e8:	5d                   	pop    %ebp
801074e9:	c3                   	ret    
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lcr3(V2P(curproc->pgdir));  
801074f0:	8b 46 04             	mov    0x4(%esi),%eax
801074f3:	05 00 00 00 80       	add    $0x80000000,%eax
801074f8:	0f 22 d8             	mov    %eax,%cr3
}
801074fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0; // pass successfully(it returns -1 if we've failed)
801074fe:	31 c0                	xor    %eax,%eax
}
80107500:	5b                   	pop    %ebx
80107501:	5e                   	pop    %esi
80107502:	5f                   	pop    %edi
80107503:	5d                   	pop    %ebp
80107504:	c3                   	ret    
    cprintf("\nOut of range. can't access cuz length is out of whole process length.\n");
80107505:	83 ec 0c             	sub    $0xc,%esp
80107508:	68 3c 82 10 80       	push   $0x8010823c
8010750d:	e8 9e 91 ff ff       	call   801006b0 <cprintf>
    return -1;
80107512:	83 c4 10             	add    $0x10,%esp
80107515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010751a:	eb c6                	jmp    801074e2 <provide_protection+0xb2>
    cprintf("\nAddress out of correct size(cuz it isn't page beginning )%p\n", addr);
8010751c:	83 ec 08             	sub    $0x8,%esp
8010751f:	57                   	push   %edi
80107520:	68 84 82 10 80       	push   $0x80108284
80107525:	e8 86 91 ff ff       	call   801006b0 <cprintf>
    return -1;
8010752a:	83 c4 10             	add    $0x10,%esp
8010752d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107532:	eb ae                	jmp    801074e2 <provide_protection+0xb2>
80107534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010753f:	90                   	nop

80107540 <refuse_protection>:

//refuse_protection system call makes page table entries both readable and writable
int refuse_protection(void *addr, int len){
80107540:	f3 0f 1e fb          	endbr32 
80107544:	55                   	push   %ebp
80107545:	89 e5                	mov    %esp,%ebp
80107547:	57                   	push   %edi
80107548:	56                   	push   %esi
80107549:	53                   	push   %ebx
8010754a:	83 ec 1c             	sub    $0x1c,%esp
8010754d:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
80107550:	e8 9b c4 ff ff       	call   801039f0 <myproc>
  
  cprintf("\ncurrent : 0x%p\n", curproc);
80107555:	83 ec 08             	sub    $0x8,%esp
80107558:	50                   	push   %eax
  struct proc *curproc = myproc();
80107559:	89 c6                	mov    %eax,%esi
  cprintf("\ncurrent : 0x%p\n", curproc);
8010755b:	68 f8 81 10 80       	push   $0x801081f8
80107560:	e8 4b 91 ff ff       	call   801006b0 <cprintf>

  //if entry address points out of range to a point out of current slice(window)
  //it means it points to a region that is not currently a part of the address space
  if(len <= 0 || (int)addr+len*PGSIZE>curproc->sz){
80107565:	8b 45 0c             	mov    0xc(%ebp),%eax
80107568:	83 c4 10             	add    $0x10,%esp
8010756b:	85 c0                	test   %eax,%eax
8010756d:	0f 8e a2 00 00 00    	jle    80107615 <refuse_protection+0xd5>
80107573:	8b 45 0c             	mov    0xc(%ebp),%eax
80107576:	89 fb                	mov    %edi,%ebx
80107578:	c1 e0 0c             	shl    $0xc,%eax
8010757b:	01 f8                	add    %edi,%eax
8010757d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107580:	3b 06                	cmp    (%esi),%eax
80107582:	0f 87 8d 00 00 00    	ja     80107615 <refuse_protection+0xd5>
    cprintf("\nOut of range. can't access cuz length is out of whole process length.\n");
    return -1;
  }

  //if address is out of page size (it contains more than one page so its wrong alignment)
  if((int)(((int) addr) % PGSIZE )  != 0){
80107588:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
8010758e:	0f 85 98 00 00 00    	jne    8010762c <refuse_protection+0xec>
  //loop for each page
  pte_t *pte; // pointer to virtual address of the page needs protection bit changing 
  int i;

  // all pages in this address that we want to change the protection of
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
80107594:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80107597:	7c 34                	jl     801075cd <refuse_protection+0x8d>
80107599:	eb 65                	jmp    80107600 <refuse_protection+0xc0>
8010759b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop
    // Getting the address of the PTE in the current process's page table (pgdir)
    // that corresponds to virtual address (i)
    pte = walkpgdir(curproc->pgdir,(void*) i, 0); // get virtual address of page number i
    //check pte non zero cuz "walk page direction" return zero when fails
    //and check is available in user space and protected type
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
801075a0:	8b 08                	mov    (%eax),%ecx
801075a2:	89 cf                	mov    %ecx,%edi
801075a4:	83 e7 05             	and    $0x5,%edi
801075a7:	83 ff 05             	cmp    $0x5,%edi
801075aa:	75 31                	jne    801075dd <refuse_protection+0x9d>
      // by bitwise or pte and writable we make this address back to readable and writable 
      *pte = (*pte) | (PTE_W) ; //Setting the write bit 
      cprintf("\nPTE : 0x%p\n", pte);
801075ac:	83 ec 08             	sub    $0x8,%esp
      *pte = (*pte) | (PTE_W) ; //Setting the write bit 
801075af:	83 c9 02             	or     $0x2,%ecx
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
801075b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      *pte = (*pte) | (PTE_W) ; //Setting the write bit 
801075b8:	89 08                	mov    %ecx,(%eax)
      cprintf("\nPTE : 0x%p\n", pte);
801075ba:	50                   	push   %eax
801075bb:	68 09 82 10 80       	push   $0x80108209
801075c0:	e8 eb 90 ff ff       	call   801006b0 <cprintf>
  for (i = (int) addr; i < ((int) addr + (len) *PGSIZE); i+= PGSIZE){
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801075cb:	7e 33                	jle    80107600 <refuse_protection+0xc0>
    pte = walkpgdir(curproc->pgdir,(void*) i, 0); // get virtual address of page number i
801075cd:	8b 46 04             	mov    0x4(%esi),%eax
801075d0:	31 c9                	xor    %ecx,%ecx
801075d2:	89 da                	mov    %ebx,%edx
801075d4:	e8 07 f5 ff ff       	call   80106ae0 <walkpgdir>
    if(pte && ((*pte & PTE_U) != 0) && ((*pte & PTE_P) != 0) ){
801075d9:	85 c0                	test   %eax,%eax
801075db:	75 c3                	jne    801075a0 <refuse_protection+0x60>
    } 
    else {
      cprintf("\nError in virtual add, check available add.\n");
801075dd:	83 ec 0c             	sub    $0xc,%esp
801075e0:	68 c4 82 10 80       	push   $0x801082c4
801075e5:	e8 c6 90 ff ff       	call   801006b0 <cprintf>
      return -1;
801075ea:	83 c4 10             	add    $0x10,%esp
801075ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  //Reloading the Control register 3 with the address of page directory 
  //to flush TLB by hardware and making virtual address(page direction) to physical
  lcr3(V2P(curproc->pgdir));
  return 0; // pass successfully(it returns -1 if we've failed)
}
801075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lcr3(V2P(curproc->pgdir));
80107600:	8b 46 04             	mov    0x4(%esi),%eax
80107603:	05 00 00 00 80       	add    $0x80000000,%eax
80107608:	0f 22 d8             	mov    %eax,%cr3
}
8010760b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0; // pass successfully(it returns -1 if we've failed)
8010760e:	31 c0                	xor    %eax,%eax
}
80107610:	5b                   	pop    %ebx
80107611:	5e                   	pop    %esi
80107612:	5f                   	pop    %edi
80107613:	5d                   	pop    %ebp
80107614:	c3                   	ret    
    cprintf("\nOut of range. can't access cuz length is out of whole process length.\n");
80107615:	83 ec 0c             	sub    $0xc,%esp
80107618:	68 3c 82 10 80       	push   $0x8010823c
8010761d:	e8 8e 90 ff ff       	call   801006b0 <cprintf>
    return -1;
80107622:	83 c4 10             	add    $0x10,%esp
80107625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010762a:	eb c6                	jmp    801075f2 <refuse_protection+0xb2>
    cprintf("\nAddress out of correct size(cuz it isn't page beginning )%p\n", addr);
8010762c:	83 ec 08             	sub    $0x8,%esp
8010762f:	57                   	push   %edi
80107630:	68 84 82 10 80       	push   $0x80108284
80107635:	e8 76 90 ff ff       	call   801006b0 <cprintf>
    return -1;
8010763a:	83 c4 10             	add    $0x10,%esp
8010763d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107642:	eb ae                	jmp    801075f2 <refuse_protection+0xb2>
80107644:	66 90                	xchg   %ax,%ax
80107646:	66 90                	xchg   %ax,%ax
80107648:	66 90                	xchg   %ax,%ax
8010764a:	66 90                	xchg   %ax,%ax
8010764c:	66 90                	xchg   %ax,%ax
8010764e:	66 90                	xchg   %ax,%ax

80107650 <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	b8 c4 b5 10 80       	mov    $0x8010b5c4,%eax
8010765a:	89 e5                	mov    %esp,%ebp
8010765c:	8b 55 08             	mov    0x8(%ebp),%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
8010765f:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
    for (mti=1; mti<N; mti++)
80107665:	eb 0c                	jmp    80107673 <sgenrand+0x23>
80107667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010766e:	66 90                	xchg   %ax,%ax
80107670:	83 c0 04             	add    $0x4,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80107673:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
80107679:	89 10                	mov    %edx,(%eax)
    for (mti=1; mti<N; mti++)
8010767b:	3d 7c bf 10 80       	cmp    $0x8010bf7c,%eax
80107680:	75 ee                	jne    80107670 <sgenrand+0x20>
80107682:	c7 05 60 b4 10 80 70 	movl   $0x270,0x8010b460
80107689:	02 00 00 
}
8010768c:	5d                   	pop    %ebp
8010768d:	c3                   	ret    
8010768e:	66 90                	xchg   %ax,%ax

80107690 <genrand>:

long /* for integer generation */
genrand()
{
80107690:	f3 0f 1e fb          	endbr32 
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80107694:	a1 60 b4 10 80       	mov    0x8010b460,%eax
80107699:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010769e:	7f 3c                	jg     801076dc <genrand+0x4c>
801076a0:	8d 50 01             	lea    0x1(%eax),%edx
801076a3:	8b 04 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%eax
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];

        mti = 0;
    }
  
    y = mt[mti++];
801076aa:	89 15 60 b4 10 80    	mov    %edx,0x8010b460
    y ^= TEMPERING_SHIFT_U(y);
801076b0:	89 c2                	mov    %eax,%edx
801076b2:	c1 ea 0b             	shr    $0xb,%edx
801076b5:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
801076b7:	89 d0                	mov    %edx,%eax
801076b9:	c1 e0 07             	shl    $0x7,%eax
801076bc:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
801076c1:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
801076c3:	89 d0                	mov    %edx,%eax
801076c5:	c1 e0 0f             	shl    $0xf,%eax
801076c8:	25 00 00 c6 ef       	and    $0xefc60000,%eax
801076cd:	31 d0                	xor    %edx,%eax
    y ^= TEMPERING_SHIFT_L(y);
801076cf:	89 c2                	mov    %eax,%edx
801076d1:	c1 ea 12             	shr    $0x12,%edx
801076d4:	31 d0                	xor    %edx,%eax

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
801076d6:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
801076db:	c3                   	ret    
        if (mti == N+1)   /* if sgenrand() has not been called, */
801076dc:	3d 71 02 00 00       	cmp    $0x271,%eax
801076e1:	0f 84 d2 00 00 00    	je     801077b9 <genrand+0x129>
    mt[0]= seed & 0xffffffff;
801076e7:	31 c0                	xor    %eax,%eax
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801076f0:	8b 0c 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%ecx
801076f7:	83 c0 01             	add    $0x1,%eax
801076fa:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80107701:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
80107707:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
8010770d:	09 ca                	or     %ecx,%edx
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
8010770f:	89 d1                	mov    %edx,%ecx
80107711:	83 e2 01             	and    $0x1,%edx
80107714:	d1 e9                	shr    %ecx
80107716:	33 0c 85 f0 bb 10 80 	xor    -0x7fef4410(,%eax,4),%ecx
8010771d:	33 0c 95 f4 82 10 80 	xor    -0x7fef7d0c(,%edx,4),%ecx
80107724:	89 0c 85 bc b5 10 80 	mov    %ecx,-0x7fef4a44(,%eax,4)
        for (kk=0;kk<N-M;kk++) {
8010772b:	3d e3 00 00 00       	cmp    $0xe3,%eax
80107730:	75 be                	jne    801076f0 <genrand+0x60>
80107732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80107738:	8b 0c 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%ecx
8010773f:	83 c0 01             	add    $0x1,%eax
80107742:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80107749:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
8010774f:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80107755:	09 ca                	or     %ecx,%edx
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
80107757:	89 d1                	mov    %edx,%ecx
80107759:	83 e2 01             	and    $0x1,%edx
8010775c:	d1 e9                	shr    %ecx
8010775e:	33 0c 85 30 b2 10 80 	xor    -0x7fef4dd0(,%eax,4),%ecx
80107765:	33 0c 95 f4 82 10 80 	xor    -0x7fef7d0c(,%edx,4),%ecx
8010776c:	89 0c 85 bc b5 10 80 	mov    %ecx,-0x7fef4a44(,%eax,4)
        for (;kk<N-1;kk++) {
80107773:	3d 6f 02 00 00       	cmp    $0x26f,%eax
80107778:	75 be                	jne    80107738 <genrand+0xa8>
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
8010777a:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
8010777f:	8b 0d 7c bf 10 80    	mov    0x8010bf7c,%ecx
80107785:	89 c2                	mov    %eax,%edx
80107787:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
8010778d:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80107793:	09 d1                	or     %edx,%ecx
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
80107795:	89 ca                	mov    %ecx,%edx
80107797:	83 e1 01             	and    $0x1,%ecx
8010779a:	d1 ea                	shr    %edx
8010779c:	33 15 f0 bb 10 80    	xor    0x8010bbf0,%edx
801077a2:	33 14 8d f4 82 10 80 	xor    -0x7fef7d0c(,%ecx,4),%edx
801077a9:	89 15 7c bf 10 80    	mov    %edx,0x8010bf7c
801077af:	ba 01 00 00 00       	mov    $0x1,%edx
801077b4:	e9 f1 fe ff ff       	jmp    801076aa <genrand+0x1a>
    mt[0]= seed & 0xffffffff;
801077b9:	b8 c4 b5 10 80       	mov    $0x8010b5c4,%eax
801077be:	b9 7c bf 10 80       	mov    $0x8010bf7c,%ecx
801077c3:	ba 05 11 00 00       	mov    $0x1105,%edx
801077c8:	c7 05 c0 b5 10 80 05 	movl   $0x1105,0x8010b5c0
801077cf:	11 00 00 
    for (mti=1; mti<N; mti++)
801077d2:	eb 07                	jmp    801077db <genrand+0x14b>
801077d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077d8:	83 c0 04             	add    $0x4,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
801077db:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
801077e1:	89 10                	mov    %edx,(%eax)
    for (mti=1; mti<N; mti++)
801077e3:	39 c1                	cmp    %eax,%ecx
801077e5:	75 f1                	jne    801077d8 <genrand+0x148>
801077e7:	e9 fb fe ff ff       	jmp    801076e7 <genrand+0x57>
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077f0 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
801077f0:	f3 0f 1e fb          	endbr32 
801077f4:	55                   	push   %ebp
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
801077f5:	31 d2                	xor    %edx,%edx
long random_at_most(long max) {
801077f7:	89 e5                	mov    %esp,%ebp
801077f9:	56                   	push   %esi
    num_bins = (unsigned long) max + 1,
801077fa:	8b 45 08             	mov    0x8(%ebp),%eax
long random_at_most(long max) {
801077fd:	53                   	push   %ebx
    bin_size = num_rand / num_bins,
801077fe:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    num_bins = (unsigned long) max + 1,
80107803:	8d 48 01             	lea    0x1(%eax),%ecx
    bin_size = num_rand / num_bins,
80107806:	89 d8                	mov    %ebx,%eax
80107808:	f7 f1                	div    %ecx
8010780a:	89 c6                	mov    %eax,%esi
8010780c:	29 d3                	sub    %edx,%ebx
8010780e:	66 90                	xchg   %ax,%ax
    defect   = num_rand % num_bins;

  long x;
  do {
   x = genrand();
80107810:	e8 7b fe ff ff       	call   80107690 <genrand>
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80107815:	39 d8                	cmp    %ebx,%eax
80107817:	73 f7                	jae    80107810 <random_at_most+0x20>

  // Truncated division is intentional
  return x/bin_size;
80107819:	31 d2                	xor    %edx,%edx
}
8010781b:	5b                   	pop    %ebx
  return x/bin_size;
8010781c:	f7 f6                	div    %esi
}
8010781e:	5e                   	pop    %esi
8010781f:	5d                   	pop    %ebp
80107820:	c3                   	ret    
