
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 10 d6 10 80       	mov    $0x8010d610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 36 10 80       	mov    $0x801036e0,%eax
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
80100048:	bb 58 d6 10 80       	mov    $0x8010d658,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 86 10 80       	push   $0x80108680
80100055:	68 20 d6 10 80       	push   $0x8010d620
8010005a:	e8 d1 55 00 00       	call   80105630 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 98 1d 11 80       	mov    $0x80111d98,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 ec 1d 11 80 98 	movl   $0x80111d98,0x80111dec
8010006e:	1d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 f0 1d 11 80 98 	movl   $0x80111d98,0x80111df0
80100078:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 58             	mov    %eax,0x58(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 54 98 1d 11 80 	movl   $0x80111d98,0x54(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 86 10 80       	push   $0x80108687
80100097:	50                   	push   %eax
80100098:	e8 53 54 00 00       	call   801054f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 60 02 00 00    	lea    0x260(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 54             	mov    %ebx,0x54(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d f0 1d 11 80    	mov    %ebx,0x80111df0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 38 1b 11 80    	cmp    $0x80111b38,%ebx
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
801000e3:	68 20 d6 10 80       	push   $0x8010d620
801000e8:	e8 d3 56 00 00       	call   801057c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d f0 1d 11 80    	mov    0x80111df0,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 98 1d 11 80    	cmp    $0x80111d98,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 58             	mov    0x58(%ebx),%ebx
80100103:	81 fb 98 1d 11 80    	cmp    $0x80111d98,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 50 01          	addl   $0x1,0x50(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ec 1d 11 80    	mov    0x80111dec,%ebx
80100126:	81 fb 98 1d 11 80    	cmp    $0x80111d98,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100133:	81 fb 98 1d 11 80    	cmp    $0x80111d98,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 50             	mov    0x50(%ebx),%eax
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
80100153:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 d6 10 80       	push   $0x8010d620
80100162:	e8 49 57 00 00       	call   801058b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 53 00 00       	call   80105530 <acquiresleep>
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
8010018c:	e8 8f 27 00 00       	call   80102920 <iderw>
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
801001a3:	68 8e 86 10 80       	push   $0x8010868e
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
801001c2:	e8 09 54 00 00       	call   801055d0 <holdingsleep>
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
801001d8:	e9 43 27 00 00       	jmp    80102920 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 86 10 80       	push   $0x8010869f
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
80100203:	e8 c8 53 00 00       	call   801055d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 53 00 00       	call   80105590 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
8010021f:	e8 9c 55 00 00       	call   801057c0 <acquire>
  b->refcnt--;
80100224:	8b 43 50             	mov    0x50(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 50             	mov    %eax,0x50(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 58             	mov    0x58(%ebx),%eax
80100237:	8b 53 54             	mov    0x54(%ebx),%edx
8010023a:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 54             	mov    0x54(%ebx),%eax
80100240:	8b 53 58             	mov    0x58(%ebx),%edx
80100243:	89 50 58             	mov    %edx,0x58(%eax)
    b->next = bcache.head.next;
80100246:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 54 98 1d 11 80 	movl   $0x80111d98,0x54(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 58             	mov    %eax,0x58(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 f0 1d 11 80       	mov    0x80111df0,%eax
8010025a:	89 58 54             	mov    %ebx,0x54(%eax)
    bcache.head.next = b;
8010025d:	89 1d f0 1d 11 80    	mov    %ebx,0x80111df0
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 20 d6 10 80 	movl   $0x8010d620,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 56 00 00       	jmp    801058b0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 86 10 80       	push   $0x801086a6
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
801002a5:	e8 36 1c 00 00       	call   80101ee0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 c5 10 80 	movl   $0x8010c540,(%esp)
801002b1:	e8 0a 55 00 00       	call   801057c0 <acquire>
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
801002c6:	a1 80 20 11 80       	mov    0x80112080,%eax
801002cb:	3b 05 84 20 11 80    	cmp    0x80112084,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 c5 10 80       	push   $0x8010c540
801002e0:	68 80 20 11 80       	push   $0x80112080
801002e5:	e8 26 46 00 00       	call   80104910 <sleep>
    while(input.r == input.w){
801002ea:	a1 80 20 11 80       	mov    0x80112080,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 84 20 11 80    	cmp    0x80112084,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 21 3e 00 00       	call   80104120 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 c5 10 80       	push   $0x8010c540
8010030e:	e8 9d 55 00 00       	call   801058b0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 e4 1a 00 00       	call   80101e00 <ilock>
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
80100333:	89 15 80 20 11 80    	mov    %edx,0x80112080
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 00 20 11 80 	movsbl -0x7feee000(%edx),%ecx
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
80100360:	68 40 c5 10 80       	push   $0x8010c540
80100365:	e8 46 55 00 00       	call   801058b0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 8d 1a 00 00       	call   80101e00 <ilock>
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
80100386:	a3 80 20 11 80       	mov    %eax,0x80112080
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
8010039d:	c7 05 78 c5 10 80 00 	movl   $0x0,0x8010c578
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 8e 2b 00 00       	call   80102f40 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 86 10 80       	push   $0x801086ad
801003bb:	e8 e0 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 d7 03 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 83 91 10 80 	movl   $0x80109183,(%esp)
801003d0:	e8 cb 03 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 7f 52 00 00       	call   80105660 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 86 10 80       	push   $0x801086c1
801003f1:	e8 aa 03 00 00       	call   801007a0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 7c c5 10 80 01 	movl   $0x1,0x8010c57c
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
80100415:	89 c6                	mov    %eax,%esi
80100417:	53                   	push   %ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 6a 01 00 00    	je     80100590 <consputc.part.0+0x180>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 51 6e 00 00       	call   80107280 <uartputc>
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
80100447:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100451:	c1 e3 08             	shl    $0x8,%ebx
80100454:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100455:	89 ca                	mov    %ecx,%edx
80100457:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100458:	0f b6 d0             	movzbl %al,%edx
8010045b:	89 d7                	mov    %edx,%edi
8010045d:	09 df                	or     %ebx,%edi
  if(c == '\n')
8010045f:	83 fe 0a             	cmp    $0xa,%esi
80100462:	0f 84 08 01 00 00    	je     80100570 <consputc.part.0+0x160>
  else if(c == BACKSPACE)
80100468:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010046e:	0f 84 ec 00 00 00    	je     80100560 <consputc.part.0+0x150>
  else if(c == ARR_RT)
80100474:	81 fe e5 00 00 00    	cmp    $0xe5,%esi
8010047a:	0f 84 a0 01 00 00    	je     80100620 <consputc.part.0+0x210>
  else if(c == ARR_LF)
80100480:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
80100486:	0f 84 b4 01 00 00    	je     80100640 <consputc.part.0+0x230>
  for (int i = pos; i <= pos+width+1; i++)
8010048c:	8b 0d 84 c5 10 80    	mov    0x8010c584,%ecx
  ushort temp = crt[pos-1];
80100492:	8d 44 3f fe          	lea    -0x2(%edi,%edi,1),%eax
80100496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100499:	0f b7 90 00 80 0b 80 	movzwl -0x7ff48000(%eax),%edx
  for (int i = pos; i <= pos+width+1; i++)
801004a0:	2d fe 7f f4 7f       	sub    $0x7ff47ffe,%eax
801004a5:	01 f9                	add    %edi,%ecx
801004a7:	8d 59 01             	lea    0x1(%ecx),%ebx
801004aa:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801004ad:	8d 9c 09 04 80 0b 80 	lea    -0x7ff47ffc(%ecx,%ecx,1),%ebx
801004b4:	3b 7d e0             	cmp    -0x20(%ebp),%edi
801004b7:	7f 18                	jg     801004d1 <consputc.part.0+0xc1>
801004b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    temp_ = crt[i];
801004c0:	89 d1                	mov    %edx,%ecx
801004c2:	83 c0 02             	add    $0x2,%eax
801004c5:	0f b7 50 fe          	movzwl -0x2(%eax),%edx
    crt[i] = temp;
801004c9:	66 89 48 fe          	mov    %cx,-0x2(%eax)
  for (int i = pos; i <= pos+width+1; i++)
801004cd:	39 c3                	cmp    %eax,%ebx
801004cf:	75 ef                	jne    801004c0 <consputc.part.0+0xb0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004d1:	89 f0                	mov    %esi,%eax
801004d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801004d6:	83 c7 01             	add    $0x1,%edi
801004d9:	0f b6 c0             	movzbl %al,%eax
801004dc:	80 cc 07             	or     $0x7,%ah
801004df:	66 89 83 02 80 0b 80 	mov    %ax,-0x7ff47ffe(%ebx)
  if(pos < 0 || pos > 25*80)
801004e6:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
801004ec:	0f 87 83 01 00 00    	ja     80100675 <consputc.part.0+0x265>
  if((pos/80) >= 24){  // Scroll up.
801004f2:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
801004f8:	0f 8f c2 00 00 00    	jg     801005c0 <consputc.part.0+0x1b0>
801004fe:	89 f8                	mov    %edi,%eax
80100500:	0f b6 c4             	movzbl %ah,%eax
80100503:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100506:	89 f8                	mov    %edi,%eax
80100508:	88 45 e4             	mov    %al,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010050b:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100510:	b8 0e 00 00 00       	mov    $0xe,%eax
80100515:	89 da                	mov    %ebx,%edx
80100517:	ee                   	out    %al,(%dx)
80100518:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010051d:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80100521:	89 ca                	mov    %ecx,%edx
80100523:	ee                   	out    %al,(%dx)
80100524:	b8 0f 00 00 00       	mov    $0xf,%eax
80100529:	89 da                	mov    %ebx,%edx
8010052b:	ee                   	out    %al,(%dx)
8010052c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100530:	89 ca                	mov    %ecx,%edx
80100532:	ee                   	out    %al,(%dx)
  if(c != ARR_RT && c != ARR_LF)
80100533:	8d 86 1c ff ff ff    	lea    -0xe4(%esi),%eax
80100539:	83 f8 01             	cmp    $0x1,%eax
8010053c:	76 13                	jbe    80100551 <consputc.part.0+0x141>
  crt[pos+width] = ' ' | 0x0700;
8010053e:	03 3d 84 c5 10 80    	add    0x8010c584,%edi
80100544:	b8 20 07 00 00       	mov    $0x720,%eax
80100549:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
80100550:	80 
}
80100551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100554:	5b                   	pop    %ebx
80100555:	5e                   	pop    %esi
80100556:	5f                   	pop    %edi
80100557:	5d                   	pop    %ebp
80100558:	c3                   	ret    
80100559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0)
80100560:	85 ff                	test   %edi,%edi
80100562:	0f 84 a8 00 00 00    	je     80100610 <consputc.part.0+0x200>
     --pos;
80100568:	83 ef 01             	sub    $0x1,%edi
8010056b:	e9 76 ff ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
    pos += 80 - pos%80;
80100570:	89 f8                	mov    %edi,%eax
80100572:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100577:	f7 e2                	mul    %edx
80100579:	c1 ea 06             	shr    $0x6,%edx
8010057c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010057f:	c1 e0 04             	shl    $0x4,%eax
80100582:	8d 78 50             	lea    0x50(%eax),%edi
80100585:	e9 5c ff ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100590:	83 ec 0c             	sub    $0xc,%esp
80100593:	6a 08                	push   $0x8
80100595:	e8 e6 6c 00 00       	call   80107280 <uartputc>
8010059a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005a1:	e8 da 6c 00 00       	call   80107280 <uartputc>
801005a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005ad:	e8 ce 6c 00 00       	call   80107280 <uartputc>
801005b2:	83 c4 10             	add    $0x10,%esp
801005b5:	e9 78 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
801005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005c0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005c3:	83 ef 50             	sub    $0x50,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005c6:	68 60 0e 00 00       	push   $0xe60
801005cb:	68 a0 80 0b 80       	push   $0x800b80a0
801005d0:	68 00 80 0b 80       	push   $0x800b8000
801005d5:	e8 d6 53 00 00       	call   801059b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005da:	b8 80 07 00 00       	mov    $0x780,%eax
801005df:	83 c4 0c             	add    $0xc,%esp
801005e2:	29 f8                	sub    %edi,%eax
801005e4:	01 c0                	add    %eax,%eax
801005e6:	50                   	push   %eax
801005e7:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005ee:	6a 00                	push   $0x0
801005f0:	50                   	push   %eax
801005f1:	e8 1a 53 00 00       	call   80105910 <memset>
801005f6:	89 f8                	mov    %edi,%eax
801005f8:	c6 45 e0 07          	movb   $0x7,-0x20(%ebp)
801005fc:	83 c4 10             	add    $0x10,%esp
801005ff:	88 45 e4             	mov    %al,-0x1c(%ebp)
80100602:	e9 04 ff ff ff       	jmp    8010050b <consputc.part.0+0xfb>
80100607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010060e:	66 90                	xchg   %ax,%ax
80100610:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100614:	c6 45 e0 00          	movb   $0x0,-0x20(%ebp)
80100618:	e9 ee fe ff ff       	jmp    8010050b <consputc.part.0+0xfb>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    if (width)
80100620:	a1 84 c5 10 80       	mov    0x8010c584,%eax
80100625:	85 c0                	test   %eax,%eax
80100627:	0f 84 b9 fe ff ff    	je     801004e6 <consputc.part.0+0xd6>
      width--;
8010062d:	83 e8 01             	sub    $0x1,%eax
      ++pos;
80100630:	83 c7 01             	add    $0x1,%edi
      width--;
80100633:	a3 84 c5 10 80       	mov    %eax,0x8010c584
80100638:	e9 a9 fe ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
8010063d:	8d 76 00             	lea    0x0(%esi),%esi
    int buf_char_size = strlen(input.buf)-empty_cell;
80100640:	83 ec 0c             	sub    $0xc,%esp
80100643:	68 00 20 11 80       	push   $0x80112000
80100648:	e8 c3 54 00 00       	call   80105b10 <strlen>
    if (width<buf_char_size)
8010064d:	8b 15 84 c5 10 80    	mov    0x8010c584,%edx
    int buf_char_size = strlen(input.buf)-empty_cell;
80100653:	2b 05 80 c5 10 80    	sub    0x8010c580,%eax
    if (width<buf_char_size)
80100659:	83 c4 10             	add    $0x10,%esp
8010065c:	39 d0                	cmp    %edx,%eax
8010065e:	0f 8e 82 fe ff ff    	jle    801004e6 <consputc.part.0+0xd6>
      width++;
80100664:	83 c2 01             	add    $0x1,%edx
      --pos;
80100667:	83 ef 01             	sub    $0x1,%edi
      width++;
8010066a:	89 15 84 c5 10 80    	mov    %edx,0x8010c584
80100670:	e9 71 fe ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
    panic("pos under/overflow");
80100675:	83 ec 0c             	sub    $0xc,%esp
80100678:	68 c5 86 10 80       	push   $0x801086c5
8010067d:	e8 0e fd ff ff       	call   80100390 <panic>
80100682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100690 <printint>:
{
80100690:	55                   	push   %ebp
80100691:	89 e5                	mov    %esp,%ebp
80100693:	57                   	push   %edi
80100694:	56                   	push   %esi
80100695:	53                   	push   %ebx
80100696:	83 ec 2c             	sub    $0x2c,%esp
80100699:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010069c:	85 c9                	test   %ecx,%ecx
8010069e:	74 04                	je     801006a4 <printint+0x14>
801006a0:	85 c0                	test   %eax,%eax
801006a2:	78 6d                	js     80100711 <printint+0x81>
    x = xx;
801006a4:	89 c1                	mov    %eax,%ecx
801006a6:	31 f6                	xor    %esi,%esi
  i = 0;
801006a8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801006ab:	31 db                	xor    %ebx,%ebx
801006ad:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801006b0:	89 c8                	mov    %ecx,%eax
801006b2:	31 d2                	xor    %edx,%edx
801006b4:	89 ce                	mov    %ecx,%esi
801006b6:	f7 75 d4             	divl   -0x2c(%ebp)
801006b9:	0f b6 92 f0 86 10 80 	movzbl -0x7fef7910(%edx),%edx
801006c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801006c3:	89 d8                	mov    %ebx,%eax
801006c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801006c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801006cb:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801006ce:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801006d1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801006d4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801006d7:	73 d7                	jae    801006b0 <printint+0x20>
801006d9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801006dc:	85 f6                	test   %esi,%esi
801006de:	74 0c                	je     801006ec <printint+0x5c>
    buf[i++] = '-';
801006e0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801006e5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801006e7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801006ec:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
801006f0:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801006f3:	8b 15 7c c5 10 80    	mov    0x8010c57c,%edx
801006f9:	85 d2                	test   %edx,%edx
801006fb:	74 03                	je     80100700 <printint+0x70>
  asm volatile("cli");
801006fd:	fa                   	cli    
    for(;;)
801006fe:	eb fe                	jmp    801006fe <printint+0x6e>
80100700:	e8 0b fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100705:	39 fb                	cmp    %edi,%ebx
80100707:	74 10                	je     80100719 <printint+0x89>
80100709:	0f be 03             	movsbl (%ebx),%eax
8010070c:	83 eb 01             	sub    $0x1,%ebx
8010070f:	eb e2                	jmp    801006f3 <printint+0x63>
    x = -xx;
80100711:	f7 d8                	neg    %eax
80100713:	89 ce                	mov    %ecx,%esi
80100715:	89 c1                	mov    %eax,%ecx
80100717:	eb 8f                	jmp    801006a8 <printint+0x18>
}
80100719:	83 c4 2c             	add    $0x2c,%esp
8010071c:	5b                   	pop    %ebx
8010071d:	5e                   	pop    %esi
8010071e:	5f                   	pop    %edi
8010071f:	5d                   	pop    %ebp
80100720:	c3                   	ret    
80100721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop

80100730 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100730:	f3 0f 1e fb          	endbr32 
80100734:	55                   	push   %ebp
80100735:	89 e5                	mov    %esp,%ebp
80100737:	57                   	push   %edi
80100738:	56                   	push   %esi
80100739:	53                   	push   %ebx
8010073a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010073d:	ff 75 08             	pushl  0x8(%ebp)
{
80100740:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100743:	e8 98 17 00 00       	call   80101ee0 <iunlock>
  acquire(&cons.lock);
80100748:	c7 04 24 40 c5 10 80 	movl   $0x8010c540,(%esp)
8010074f:	e8 6c 50 00 00       	call   801057c0 <acquire>
  for(i = 0; i < n; i++)
80100754:	83 c4 10             	add    $0x10,%esp
80100757:	85 db                	test   %ebx,%ebx
80100759:	7e 24                	jle    8010077f <consolewrite+0x4f>
8010075b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010075e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100761:	8b 15 7c c5 10 80    	mov    0x8010c57c,%edx
80100767:	85 d2                	test   %edx,%edx
80100769:	74 05                	je     80100770 <consolewrite+0x40>
8010076b:	fa                   	cli    
    for(;;)
8010076c:	eb fe                	jmp    8010076c <consolewrite+0x3c>
8010076e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100770:	0f b6 07             	movzbl (%edi),%eax
80100773:	83 c7 01             	add    $0x1,%edi
80100776:	e8 95 fc ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010077b:	39 fe                	cmp    %edi,%esi
8010077d:	75 e2                	jne    80100761 <consolewrite+0x31>
  release(&cons.lock);
8010077f:	83 ec 0c             	sub    $0xc,%esp
80100782:	68 40 c5 10 80       	push   $0x8010c540
80100787:	e8 24 51 00 00       	call   801058b0 <release>
  ilock(ip);
8010078c:	58                   	pop    %eax
8010078d:	ff 75 08             	pushl  0x8(%ebp)
80100790:	e8 6b 16 00 00       	call   80101e00 <ilock>

  return n;
}
80100795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100798:	89 d8                	mov    %ebx,%eax
8010079a:	5b                   	pop    %ebx
8010079b:	5e                   	pop    %esi
8010079c:	5f                   	pop    %edi
8010079d:	5d                   	pop    %ebp
8010079e:	c3                   	ret    
8010079f:	90                   	nop

801007a0 <cprintf>:
{
801007a0:	f3 0f 1e fb          	endbr32 
801007a4:	55                   	push   %ebp
801007a5:	89 e5                	mov    %esp,%ebp
801007a7:	57                   	push   %edi
801007a8:	56                   	push   %esi
801007a9:	53                   	push   %ebx
801007aa:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801007ad:	a1 78 c5 10 80       	mov    0x8010c578,%eax
801007b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801007b5:	85 c0                	test   %eax,%eax
801007b7:	0f 85 e8 00 00 00    	jne    801008a5 <cprintf+0x105>
  if (fmt == 0)
801007bd:	8b 45 08             	mov    0x8(%ebp),%eax
801007c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007c3:	85 c0                	test   %eax,%eax
801007c5:	0f 84 5a 01 00 00    	je     80100925 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	0f b6 00             	movzbl (%eax),%eax
801007ce:	85 c0                	test   %eax,%eax
801007d0:	74 36                	je     80100808 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801007d2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007d5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801007d7:	83 f8 25             	cmp    $0x25,%eax
801007da:	74 44                	je     80100820 <cprintf+0x80>
  if(panicked){
801007dc:	8b 0d 7c c5 10 80    	mov    0x8010c57c,%ecx
801007e2:	85 c9                	test   %ecx,%ecx
801007e4:	74 0f                	je     801007f5 <cprintf+0x55>
801007e6:	fa                   	cli    
    for(;;)
801007e7:	eb fe                	jmp    801007e7 <cprintf+0x47>
801007e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007f0:	b8 25 00 00 00       	mov    $0x25,%eax
801007f5:	e8 16 fc ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007fd:	83 c6 01             	add    $0x1,%esi
80100800:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100804:	85 c0                	test   %eax,%eax
80100806:	75 cf                	jne    801007d7 <cprintf+0x37>
  if(locking)
80100808:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010080b:	85 c0                	test   %eax,%eax
8010080d:	0f 85 fd 00 00 00    	jne    80100910 <cprintf+0x170>
}
80100813:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100816:	5b                   	pop    %ebx
80100817:	5e                   	pop    %esi
80100818:	5f                   	pop    %edi
80100819:	5d                   	pop    %ebp
8010081a:	c3                   	ret    
8010081b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010081f:	90                   	nop
    c = fmt[++i] & 0xff;
80100820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100823:	83 c6 01             	add    $0x1,%esi
80100826:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010082a:	85 ff                	test   %edi,%edi
8010082c:	74 da                	je     80100808 <cprintf+0x68>
    switch(c){
8010082e:	83 ff 70             	cmp    $0x70,%edi
80100831:	74 5a                	je     8010088d <cprintf+0xed>
80100833:	7f 2a                	jg     8010085f <cprintf+0xbf>
80100835:	83 ff 25             	cmp    $0x25,%edi
80100838:	0f 84 92 00 00 00    	je     801008d0 <cprintf+0x130>
8010083e:	83 ff 64             	cmp    $0x64,%edi
80100841:	0f 85 a1 00 00 00    	jne    801008e8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100847:	8b 03                	mov    (%ebx),%eax
80100849:	8d 7b 04             	lea    0x4(%ebx),%edi
8010084c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100851:	ba 0a 00 00 00       	mov    $0xa,%edx
80100856:	89 fb                	mov    %edi,%ebx
80100858:	e8 33 fe ff ff       	call   80100690 <printint>
      break;
8010085d:	eb 9b                	jmp    801007fa <cprintf+0x5a>
    switch(c){
8010085f:	83 ff 73             	cmp    $0x73,%edi
80100862:	75 24                	jne    80100888 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100864:	8d 7b 04             	lea    0x4(%ebx),%edi
80100867:	8b 1b                	mov    (%ebx),%ebx
80100869:	85 db                	test   %ebx,%ebx
8010086b:	75 55                	jne    801008c2 <cprintf+0x122>
        s = "(null)";
8010086d:	bb d8 86 10 80       	mov    $0x801086d8,%ebx
      for(; *s; s++)
80100872:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100877:	8b 15 7c c5 10 80    	mov    0x8010c57c,%edx
8010087d:	85 d2                	test   %edx,%edx
8010087f:	74 39                	je     801008ba <cprintf+0x11a>
80100881:	fa                   	cli    
    for(;;)
80100882:	eb fe                	jmp    80100882 <cprintf+0xe2>
80100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100888:	83 ff 78             	cmp    $0x78,%edi
8010088b:	75 5b                	jne    801008e8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010088d:	8b 03                	mov    (%ebx),%eax
8010088f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100892:	31 c9                	xor    %ecx,%ecx
80100894:	ba 10 00 00 00       	mov    $0x10,%edx
80100899:	89 fb                	mov    %edi,%ebx
8010089b:	e8 f0 fd ff ff       	call   80100690 <printint>
      break;
801008a0:	e9 55 ff ff ff       	jmp    801007fa <cprintf+0x5a>
    acquire(&cons.lock);
801008a5:	83 ec 0c             	sub    $0xc,%esp
801008a8:	68 40 c5 10 80       	push   $0x8010c540
801008ad:	e8 0e 4f 00 00       	call   801057c0 <acquire>
801008b2:	83 c4 10             	add    $0x10,%esp
801008b5:	e9 03 ff ff ff       	jmp    801007bd <cprintf+0x1d>
801008ba:	e8 51 fb ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801008bf:	83 c3 01             	add    $0x1,%ebx
801008c2:	0f be 03             	movsbl (%ebx),%eax
801008c5:	84 c0                	test   %al,%al
801008c7:	75 ae                	jne    80100877 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801008c9:	89 fb                	mov    %edi,%ebx
801008cb:	e9 2a ff ff ff       	jmp    801007fa <cprintf+0x5a>
  if(panicked){
801008d0:	8b 3d 7c c5 10 80    	mov    0x8010c57c,%edi
801008d6:	85 ff                	test   %edi,%edi
801008d8:	0f 84 12 ff ff ff    	je     801007f0 <cprintf+0x50>
801008de:	fa                   	cli    
    for(;;)
801008df:	eb fe                	jmp    801008df <cprintf+0x13f>
801008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008e8:	8b 0d 7c c5 10 80    	mov    0x8010c57c,%ecx
801008ee:	85 c9                	test   %ecx,%ecx
801008f0:	74 06                	je     801008f8 <cprintf+0x158>
801008f2:	fa                   	cli    
    for(;;)
801008f3:	eb fe                	jmp    801008f3 <cprintf+0x153>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
801008f8:	b8 25 00 00 00       	mov    $0x25,%eax
801008fd:	e8 0e fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100902:	8b 15 7c c5 10 80    	mov    0x8010c57c,%edx
80100908:	85 d2                	test   %edx,%edx
8010090a:	74 2c                	je     80100938 <cprintf+0x198>
8010090c:	fa                   	cli    
    for(;;)
8010090d:	eb fe                	jmp    8010090d <cprintf+0x16d>
8010090f:	90                   	nop
    release(&cons.lock);
80100910:	83 ec 0c             	sub    $0xc,%esp
80100913:	68 40 c5 10 80       	push   $0x8010c540
80100918:	e8 93 4f 00 00       	call   801058b0 <release>
8010091d:	83 c4 10             	add    $0x10,%esp
}
80100920:	e9 ee fe ff ff       	jmp    80100813 <cprintf+0x73>
    panic("null fmt");
80100925:	83 ec 0c             	sub    $0xc,%esp
80100928:	68 df 86 10 80       	push   $0x801086df
8010092d:	e8 5e fa ff ff       	call   80100390 <panic>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100938:	89 f8                	mov    %edi,%eax
8010093a:	e8 d1 fa ff ff       	call   80100410 <consputc.part.0>
8010093f:	e9 b6 fe ff ff       	jmp    801007fa <cprintf+0x5a>
80100944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010094b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010094f:	90                   	nop

80100950 <updating_crt>:
{
80100950:	f3 0f 1e fb          	endbr32 
80100954:	55                   	push   %ebp
80100955:	89 e5                	mov    %esp,%ebp
80100957:	56                   	push   %esi
80100958:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010095b:	53                   	push   %ebx
  for (int i = pos; i <= pos+width+1; i++)
8010095c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ushort temp = crt[pos-1];
8010095f:	8d 44 09 fe          	lea    -0x2(%ecx,%ecx,1),%eax
  for (int i = pos; i <= pos+width+1; i++)
80100963:	01 cb                	add    %ecx,%ebx
  ushort temp = crt[pos-1];
80100965:	0f b7 90 00 80 0b 80 	movzwl -0x7ff48000(%eax),%edx
  for (int i = pos; i <= pos+width+1; i++)
8010096c:	8d 73 01             	lea    0x1(%ebx),%esi
8010096f:	39 f1                	cmp    %esi,%ecx
80100971:	7f 1e                	jg     80100991 <updating_crt+0x41>
80100973:	2d fe 7f f4 7f       	sub    $0x7ff47ffe,%eax
80100978:	8d 9c 1b 04 80 0b 80 	lea    -0x7ff47ffc(%ebx,%ebx,1),%ebx
8010097f:	90                   	nop
    temp_ = crt[i];
80100980:	89 d1                	mov    %edx,%ecx
80100982:	83 c0 02             	add    $0x2,%eax
80100985:	0f b7 50 fe          	movzwl -0x2(%eax),%edx
    crt[i] = temp;
80100989:	66 89 48 fe          	mov    %cx,-0x2(%eax)
  for (int i = pos; i <= pos+width+1; i++)
8010098d:	39 d8                	cmp    %ebx,%eax
8010098f:	75 ef                	jne    80100980 <updating_crt+0x30>
}
80100991:	5b                   	pop    %ebx
80100992:	5e                   	pop    %esi
80100993:	5d                   	pop    %ebp
80100994:	c3                   	ret    
80100995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009a0 <cursor_gathering_char>:
{
801009a0:	f3 0f 1e fb          	endbr32 
801009a4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009a5:	b8 0e 00 00 00       	mov    $0xe,%eax
801009aa:	89 e5                	mov    %esp,%ebp
801009ac:	57                   	push   %edi
801009ad:	bf d4 03 00 00       	mov    $0x3d4,%edi
801009b2:	56                   	push   %esi
801009b3:	89 fa                	mov    %edi,%edx
801009b5:	53                   	push   %ebx
801009b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009b7:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801009bc:	89 ca                	mov    %ecx,%edx
801009be:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801009bf:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009c2:	89 fa                	mov    %edi,%edx
801009c4:	b8 0f 00 00 00       	mov    $0xf,%eax
801009c9:	89 de                	mov    %ebx,%esi
801009cb:	c1 e6 08             	shl    $0x8,%esi
801009ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009cf:	89 ca                	mov    %ecx,%edx
801009d1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801009d2:	0f b6 d8             	movzbl %al,%ebx
  for (int i = pos; i <= pos+width+1; i++)
801009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  pos |= inb(CRTPORT+1);
801009d8:	09 f3                	or     %esi,%ebx
  for (int i = pos; i <= pos+width+1; i++)
801009da:	01 d8                	add    %ebx,%eax
  ushort temp = crt[pos-1];
801009dc:	8d 7c 1b fe          	lea    -0x2(%ebx,%ebx,1),%edi
  for (int i = pos; i <= pos+width+1; i++)
801009e0:	8d 50 01             	lea    0x1(%eax),%edx
  ushort temp = crt[pos-1];
801009e3:	0f b7 8f 00 80 0b 80 	movzwl -0x7ff48000(%edi),%ecx
  for (int i = pos; i <= pos+width+1; i++)
801009ea:	39 d3                	cmp    %edx,%ebx
801009ec:	7f 23                	jg     80100a11 <cursor_gathering_char+0x71>
801009ee:	8d 97 02 80 0b 80    	lea    -0x7ff47ffe(%edi),%edx
801009f4:	8d b4 00 04 80 0b 80 	lea    -0x7ff47ffc(%eax,%eax,1),%esi
801009fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ff:	90                   	nop
    temp_ = crt[i];
80100a00:	89 c8                	mov    %ecx,%eax
80100a02:	83 c2 02             	add    $0x2,%edx
80100a05:	0f b7 4a fe          	movzwl -0x2(%edx),%ecx
    crt[i] = temp;
80100a09:	66 89 42 fe          	mov    %ax,-0x2(%edx)
  for (int i = pos; i <= pos+width+1; i++)
80100a0d:	39 f2                	cmp    %esi,%edx
80100a0f:	75 ef                	jne    80100a00 <cursor_gathering_char+0x60>
  crt[pos++] = (col&0xff) | 0x0700;  // black on white
80100a11:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a15:	be d4 03 00 00       	mov    $0x3d4,%esi
  pos = pos+1; //place cursor to next pos
80100a1a:	83 c3 02             	add    $0x2,%ebx
80100a1d:	89 f2                	mov    %esi,%edx
  crt[pos++] = (col&0xff) | 0x0700;  // black on white
80100a1f:	80 cc 07             	or     $0x7,%ah
80100a22:	66 89 87 02 80 0b 80 	mov    %ax,-0x7ff47ffe(%edi)
80100a29:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a2e:	ee                   	out    %al,(%dx)
80100a2f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
80100a34:	89 d8                	mov    %ebx,%eax
80100a36:	c1 f8 08             	sar    $0x8,%eax
80100a39:	89 ca                	mov    %ecx,%edx
80100a3b:	ee                   	out    %al,(%dx)
80100a3c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a41:	89 f2                	mov    %esi,%edx
80100a43:	ee                   	out    %al,(%dx)
80100a44:	89 d8                	mov    %ebx,%eax
80100a46:	89 ca                	mov    %ecx,%edx
80100a48:	ee                   	out    %al,(%dx)
  crt[pos+width] = ' ' | 0x0700;  
80100a49:	b8 20 07 00 00       	mov    $0x720,%eax
80100a4e:	03 5d 0c             	add    0xc(%ebp),%ebx
80100a51:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100a58:	80 
}
80100a59:	5b                   	pop    %ebx
80100a5a:	5e                   	pop    %esi
80100a5b:	5f                   	pop    %edi
80100a5c:	5d                   	pop    %ebp
80100a5d:	c3                   	ret    
80100a5e:	66 90                	xchg   %ax,%ax

80100a60 <save_command>:
{
80100a60:	f3 0f 1e fb          	endbr32 
80100a64:	55                   	push   %ebp
80100a65:	89 e5                	mov    %esp,%ebp
80100a67:	57                   	push   %edi
80100a68:	56                   	push   %esi
80100a69:	53                   	push   %ebx
80100a6a:	83 ec 28             	sub    $0x28,%esp
  int cmd_len = strlen(cmd);
80100a6d:	ff 75 08             	pushl  0x8(%ebp)
80100a70:	e8 9b 50 00 00       	call   80105b10 <strlen>
  if (count>INPUT_BUF)
80100a75:	83 c4 10             	add    $0x10,%esp
80100a78:	3d 80 00 00 00       	cmp    $0x80,%eax
80100a7d:	7f 19                	jg     80100a98 <save_command+0x38>
80100a7f:	89 c3                	mov    %eax,%ebx
  if(cmd_len)
80100a81:	85 c0                	test   %eax,%eax
80100a83:	0f 85 9d 00 00 00    	jne    80100b26 <save_command+0xc6>
}
80100a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8c:	5b                   	pop    %ebx
80100a8d:	5e                   	pop    %esi
80100a8e:	5f                   	pop    %edi
80100a8f:	5d                   	pop    %ebp
80100a90:	c3                   	ret    
80100a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a98:	c7 45 e4 7f 00 00 00 	movl   $0x7f,-0x1c(%ebp)
    count = INPUT_BUF-1;
80100a9f:	bb 7f 00 00 00       	mov    $0x7f,%ebx
    int off_limits = cmd_mem_size == CMD_MEM_SIZE;
80100aa4:	8b 35 20 c5 10 80    	mov    0x8010c520,%esi
    if(off_limits)
80100aaa:	89 f0                	mov    %esi,%eax
80100aac:	83 fe 0a             	cmp    $0xa,%esi
80100aaf:	74 47                	je     80100af8 <save_command+0x98>
    memmove(cmd_mem[cmd_mem_size], cmd, sizeof(char)* count);  
80100ab1:	c1 e0 07             	shl    $0x7,%eax
80100ab4:	83 ec 04             	sub    $0x4,%esp
80100ab7:	ff 75 e4             	pushl  -0x1c(%ebp)
80100aba:	05 a0 20 11 80       	add    $0x801120a0,%eax
80100abf:	ff 75 08             	pushl  0x8(%ebp)
80100ac2:	50                   	push   %eax
80100ac3:	e8 e8 4e 00 00       	call   801059b0 <memmove>
    cmd_mem[cmd_mem_size][count] = '\0';
80100ac8:	8b 15 20 c5 10 80    	mov    0x8010c520,%edx
    cmd_mem_size += (off_limits ? 0 : 1);
80100ace:	83 c4 10             	add    $0x10,%esp
    cmd_mem[cmd_mem_size][count] = '\0';
80100ad1:	89 d0                	mov    %edx,%eax
80100ad3:	c1 e0 07             	shl    $0x7,%eax
80100ad6:	c6 84 03 a0 20 11 80 	movb   $0x0,-0x7feedf60(%ebx,%eax,1)
80100add:	00 
    cmd_mem_size += (off_limits ? 0 : 1);
80100ade:	31 c0                	xor    %eax,%eax
80100ae0:	83 fe 0a             	cmp    $0xa,%esi
80100ae3:	0f 95 c0             	setne  %al
80100ae6:	01 d0                	add    %edx,%eax
80100ae8:	a3 20 c5 10 80       	mov    %eax,0x8010c520
}
80100aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af0:	5b                   	pop    %ebx
80100af1:	5e                   	pop    %esi
80100af2:	5f                   	pop    %edi
80100af3:	5d                   	pop    %ebp
80100af4:	c3                   	ret    
80100af5:	8d 76 00             	lea    0x0(%esi),%esi
80100af8:	bf a0 20 11 80       	mov    $0x801120a0,%edi
80100afd:	8d 76 00             	lea    0x0(%esi),%esi
        memmove(cmd_mem[i],cmd_mem[i+1],sizeof(char)* INPUT_BUF);  
80100b00:	83 ec 04             	sub    $0x4,%esp
80100b03:	89 f8                	mov    %edi,%eax
80100b05:	83 ef 80             	sub    $0xffffff80,%edi
80100b08:	68 80 00 00 00       	push   $0x80
80100b0d:	57                   	push   %edi
80100b0e:	50                   	push   %eax
80100b0f:	e8 9c 4e 00 00       	call   801059b0 <memmove>
      for (int i = 0; i < CMD_MEM_SIZE; i++)
80100b14:	83 c4 10             	add    $0x10,%esp
80100b17:	81 ff a0 25 11 80    	cmp    $0x801125a0,%edi
80100b1d:	75 e1                	jne    80100b00 <save_command+0xa0>
80100b1f:	a1 20 c5 10 80       	mov    0x8010c520,%eax
80100b24:	eb 8b                	jmp    80100ab1 <save_command+0x51>
80100b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b29:	e9 76 ff ff ff       	jmp    80100aa4 <save_command+0x44>
80100b2e:	66 90                	xchg   %ax,%ax

80100b30 <leftside_moving_cursor>:
{
80100b30:	f3 0f 1e fb          	endbr32 
80100b34:	55                   	push   %ebp
80100b35:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b3a:	89 e5                	mov    %esp,%ebp
80100b3c:	57                   	push   %edi
80100b3d:	56                   	push   %esi
80100b3e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b43:	53                   	push   %ebx
80100b44:	89 f2                	mov    %esi,%edx
80100b46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b47:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b4c:	89 da                	mov    %ebx,%edx
80100b4e:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b4f:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100b54:	0f b6 c8             	movzbl %al,%ecx
80100b57:	89 f2                	mov    %esi,%edx
80100b59:	c1 e1 08             	shl    $0x8,%ecx
80100b5c:	89 f8                	mov    %edi,%eax
80100b5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b5f:	89 da                	mov    %ebx,%edx
80100b61:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100b62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b65:	89 f2                	mov    %esi,%edx
80100b67:	09 c1                	or     %eax,%ecx
80100b69:	89 f8                	mov    %edi,%eax
  pos--;
80100b6b:	83 e9 01             	sub    $0x1,%ecx
80100b6e:	ee                   	out    %al,(%dx)
80100b6f:	89 c8                	mov    %ecx,%eax
80100b71:	89 da                	mov    %ebx,%edx
80100b73:	ee                   	out    %al,(%dx)
80100b74:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b79:	89 f2                	mov    %esi,%edx
80100b7b:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100b7c:	89 c8                	mov    %ecx,%eax
80100b7e:	89 da                	mov    %ebx,%edx
80100b80:	c1 f8 08             	sar    $0x8,%eax
80100b83:	ee                   	out    %al,(%dx)
  crt[pos+width] = ' ' | 0x0700;
80100b84:	b8 20 07 00 00       	mov    $0x720,%eax
80100b89:	03 0d 84 c5 10 80    	add    0x8010c584,%ecx
80100b8f:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100b96:	80 
}
80100b97:	5b                   	pop    %ebx
80100b98:	5e                   	pop    %esi
80100b99:	5f                   	pop    %edi
80100b9a:	5d                   	pop    %ebp
80100b9b:	c3                   	ret    
80100b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ba0 <rightside_moving_cursor>:
{
80100ba0:	f3 0f 1e fb          	endbr32 
80100ba4:	55                   	push   %ebp
80100ba5:	b8 0e 00 00 00       	mov    $0xe,%eax
80100baa:	89 e5                	mov    %esp,%ebp
80100bac:	57                   	push   %edi
80100bad:	56                   	push   %esi
80100bae:	be d4 03 00 00       	mov    $0x3d4,%esi
80100bb3:	53                   	push   %ebx
80100bb4:	89 f2                	mov    %esi,%edx
80100bb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bb7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100bbc:	89 da                	mov    %ebx,%edx
80100bbe:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bbf:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100bc4:	0f b6 c8             	movzbl %al,%ecx
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	c1 e1 08             	shl    $0x8,%ecx
80100bcc:	89 f8                	mov    %edi,%eax
80100bce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bcf:	89 da                	mov    %ebx,%edx
80100bd1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100bd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bd5:	89 f2                	mov    %esi,%edx
80100bd7:	09 c1                	or     %eax,%ecx
80100bd9:	89 f8                	mov    %edi,%eax
  pos++;
80100bdb:	83 c1 01             	add    $0x1,%ecx
80100bde:	ee                   	out    %al,(%dx)
80100bdf:	89 c8                	mov    %ecx,%eax
80100be1:	89 da                	mov    %ebx,%edx
80100be3:	ee                   	out    %al,(%dx)
80100be4:	b8 0e 00 00 00       	mov    $0xe,%eax
80100be9:	89 f2                	mov    %esi,%edx
80100beb:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100bec:	89 c8                	mov    %ecx,%eax
80100bee:	89 da                	mov    %ebx,%edx
80100bf0:	c1 f8 08             	sar    $0x8,%eax
80100bf3:	ee                   	out    %al,(%dx)
}
80100bf4:	5b                   	pop    %ebx
80100bf5:	5e                   	pop    %esi
80100bf6:	5f                   	pop    %edi
80100bf7:	5d                   	pop    %ebp
80100bf8:	c3                   	ret    
80100bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100c00 <consoleintr>:
{
80100c00:	f3 0f 1e fb          	endbr32 
80100c04:	55                   	push   %ebp
80100c05:	89 e5                	mov    %esp,%ebp
80100c07:	57                   	push   %edi
80100c08:	56                   	push   %esi
80100c09:	53                   	push   %ebx
80100c0a:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  acquire(&cons.lock);
80100c10:	68 40 c5 10 80       	push   $0x8010c540
80100c15:	e8 a6 4b 00 00       	call   801057c0 <acquire>
  while((c = getc()) >= 0){
80100c1a:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100c1d:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
80100c24:	00 00 00 
  while((c = getc()) >= 0){
80100c27:	ff 55 08             	call   *0x8(%ebp)
80100c2a:	85 c0                	test   %eax,%eax
80100c2c:	0f 88 ad 02 00 00    	js     80100edf <consoleintr+0x2df>
    switch(c){
80100c32:	83 f8 7f             	cmp    $0x7f,%eax
80100c35:	0f 84 76 01 00 00    	je     80100db1 <consoleintr+0x1b1>
80100c3b:	7e 23                	jle    80100c60 <consoleintr+0x60>
80100c3d:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100c42:	0f 84 be 01 00 00    	je     80100e06 <consoleintr+0x206>
80100c48:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100c4d:	75 59                	jne    80100ca8 <consoleintr+0xa8>
  if(panicked){
80100c4f:	8b 35 7c c5 10 80    	mov    0x8010c57c,%esi
80100c55:	85 f6                	test   %esi,%esi
80100c57:	0f 84 ca 01 00 00    	je     80100e27 <consoleintr+0x227>
  asm volatile("cli");
80100c5d:	fa                   	cli    
    for(;;)
80100c5e:	eb fe                	jmp    80100c5e <consoleintr+0x5e>
    switch(c){
80100c60:	83 f8 10             	cmp    $0x10,%eax
80100c63:	0f 84 7f 01 00 00    	je     80100de8 <consoleintr+0x1e8>
80100c69:	83 f8 15             	cmp    $0x15,%eax
80100c6c:	0f 85 36 01 00 00    	jne    80100da8 <consoleintr+0x1a8>
      while(input.e != input.w &&
80100c72:	a1 88 20 11 80       	mov    0x80112088,%eax
80100c77:	3b 05 84 20 11 80    	cmp    0x80112084,%eax
80100c7d:	74 a8                	je     80100c27 <consoleintr+0x27>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c7f:	83 e8 01             	sub    $0x1,%eax
80100c82:	89 c2                	mov    %eax,%edx
80100c84:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100c87:	80 ba 00 20 11 80 0a 	cmpb   $0xa,-0x7feee000(%edx)
80100c8e:	74 97                	je     80100c27 <consoleintr+0x27>
        input.e--;
80100c90:	a3 88 20 11 80       	mov    %eax,0x80112088
  if(panicked){
80100c95:	a1 7c c5 10 80       	mov    0x8010c57c,%eax
80100c9a:	85 c0                	test   %eax,%eax
80100c9c:	0f 84 55 01 00 00    	je     80100df7 <consoleintr+0x1f7>
80100ca2:	fa                   	cli    
    for(;;)
80100ca3:	eb fe                	jmp    80100ca3 <consoleintr+0xa3>
80100ca5:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100ca8:	3d e2 00 00 00       	cmp    $0xe2,%eax
80100cad:	0f 85 8b 01 00 00    	jne    80100e3e <consoleintr+0x23e>
      if (cmd_idx != NO_CMD)
80100cb3:	8b 3d 00 a0 10 80    	mov    0x8010a000,%edi
80100cb9:	83 ff ff             	cmp    $0xffffffff,%edi
80100cbc:	0f 84 65 ff ff ff    	je     80100c27 <consoleintr+0x27>
        for (int i = input.pos; i < input.e; i++)
80100cc2:	8b 35 8c 20 11 80    	mov    0x8011208c,%esi
80100cc8:	8b 0d 88 20 11 80    	mov    0x80112088,%ecx
80100cce:	39 ce                	cmp    %ecx,%esi
80100cd0:	73 69                	jae    80100d3b <consoleintr+0x13b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cd2:	89 bd 64 ff ff ff    	mov    %edi,-0x9c(%ebp)
80100cd8:	89 cf                	mov    %ecx,%edi
80100cda:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cdf:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100ce4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ce5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100cea:	89 da                	mov    %ebx,%edx
80100cec:	ec                   	in     (%dx),%al
80100ced:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cf0:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100cf5:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT+1) << 8;
80100cfa:	c1 e1 08             	shl    $0x8,%ecx
80100cfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cfe:	89 da                	mov    %ebx,%edx
80100d00:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100d01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d04:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d09:	09 c1                	or     %eax,%ecx
80100d0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos++;
80100d10:	83 c1 01             	add    $0x1,%ecx
80100d13:	ee                   	out    %al,(%dx)
80100d14:	89 c8                	mov    %ecx,%eax
80100d16:	89 da                	mov    %ebx,%edx
80100d18:	ee                   	out    %al,(%dx)
80100d19:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d1e:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d23:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100d24:	89 c8                	mov    %ecx,%eax
80100d26:	89 da                	mov    %ebx,%edx
80100d28:	c1 f8 08             	sar    $0x8,%eax
80100d2b:	ee                   	out    %al,(%dx)
        for (int i = input.pos; i < input.e; i++)
80100d2c:	83 c6 01             	add    $0x1,%esi
80100d2f:	39 f7                	cmp    %esi,%edi
80100d31:	75 a7                	jne    80100cda <consoleintr+0xda>
80100d33:	89 f9                	mov    %edi,%ecx
80100d35:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
        while(input.e != input.w &&
80100d3b:	39 0d 84 20 11 80    	cmp    %ecx,0x80112084
80100d41:	75 1d                	jne    80100d60 <consoleintr+0x160>
80100d43:	eb 32                	jmp    80100d77 <consoleintr+0x177>
80100d45:	8d 76 00             	lea    0x0(%esi),%esi
          input.e--;
80100d48:	a3 88 20 11 80       	mov    %eax,0x80112088
          leftside_moving_cursor();
80100d4d:	e8 de fd ff ff       	call   80100b30 <leftside_moving_cursor>
        while(input.e != input.w &&
80100d52:	8b 0d 88 20 11 80    	mov    0x80112088,%ecx
80100d58:	3b 0d 84 20 11 80    	cmp    0x80112084,%ecx
80100d5e:	74 11                	je     80100d71 <consoleintr+0x171>
          input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100d60:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100d63:	89 c2                	mov    %eax,%edx
80100d65:	83 e2 7f             	and    $0x7f,%edx
        while(input.e != input.w &&
80100d68:	80 ba 00 20 11 80 0a 	cmpb   $0xa,-0x7feee000(%edx)
80100d6f:	75 d7                	jne    80100d48 <consoleintr+0x148>
80100d71:	8b 3d 00 a0 10 80    	mov    0x8010a000,%edi
{
80100d77:	31 db                	xor    %ebx,%ebx
          temp_id = cmd_mem[cmd_idx][i];
80100d79:	89 f8                	mov    %edi,%eax
80100d7b:	c1 e0 07             	shl    $0x7,%eax
80100d7e:	0f b6 b4 03 a0 20 11 	movzbl -0x7feedf60(%ebx,%eax,1),%esi
80100d85:	80 
          if (temp_id == '\0')
80100d86:	89 f0                	mov    %esi,%eax
80100d88:	84 c0                	test   %al,%al
80100d8a:	0f 84 8c 02 00 00    	je     8010101c <consoleintr+0x41c>
  if(panicked){
80100d90:	8b 3d 7c c5 10 80    	mov    0x8010c57c,%edi
80100d96:	85 ff                	test   %edi,%edi
80100d98:	0f 84 67 01 00 00    	je     80100f05 <consoleintr+0x305>
  asm volatile("cli");
80100d9e:	fa                   	cli    
    for(;;)
80100d9f:	eb fe                	jmp    80100d9f <consoleintr+0x19f>
80100da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100da8:	83 f8 08             	cmp    $0x8,%eax
80100dab:	0f 85 85 00 00 00    	jne    80100e36 <consoleintr+0x236>
      if(input.e != input.w){
80100db1:	a1 88 20 11 80       	mov    0x80112088,%eax
80100db6:	3b 05 84 20 11 80    	cmp    0x80112084,%eax
80100dbc:	0f 84 65 fe ff ff    	je     80100c27 <consoleintr+0x27>
        input.e--;
80100dc2:	83 e8 01             	sub    $0x1,%eax
        empty_cell++;
80100dc5:	83 05 80 c5 10 80 01 	addl   $0x1,0x8010c580
        input.e--;
80100dcc:	a3 88 20 11 80       	mov    %eax,0x80112088
  if(panicked){
80100dd1:	a1 7c c5 10 80       	mov    0x8010c57c,%eax
80100dd6:	85 c0                	test   %eax,%eax
80100dd8:	0f 84 f2 00 00 00    	je     80100ed0 <consoleintr+0x2d0>
80100dde:	fa                   	cli    
    for(;;)
80100ddf:	eb fe                	jmp    80100ddf <consoleintr+0x1df>
80100de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100de8:	c7 85 60 ff ff ff 01 	movl   $0x1,-0xa0(%ebp)
80100def:	00 00 00 
80100df2:	e9 30 fe ff ff       	jmp    80100c27 <consoleintr+0x27>
80100df7:	b8 00 01 00 00       	mov    $0x100,%eax
80100dfc:	e8 0f f6 ff ff       	call   80100410 <consputc.part.0>
80100e01:	e9 6c fe ff ff       	jmp    80100c72 <consoleintr+0x72>
  if(panicked){
80100e06:	8b 1d 7c c5 10 80    	mov    0x8010c57c,%ebx
80100e0c:	85 db                	test   %ebx,%ebx
80100e0e:	74 08                	je     80100e18 <consoleintr+0x218>
80100e10:	fa                   	cli    
    for(;;)
80100e11:	eb fe                	jmp    80100e11 <consoleintr+0x211>
80100e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e17:	90                   	nop
80100e18:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100e1d:	e8 ee f5 ff ff       	call   80100410 <consputc.part.0>
80100e22:	e9 00 fe ff ff       	jmp    80100c27 <consoleintr+0x27>
80100e27:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100e2c:	e8 df f5 ff ff       	call   80100410 <consputc.part.0>
80100e31:	e9 f1 fd ff ff       	jmp    80100c27 <consoleintr+0x27>
      if(c != 0 && input.e-input.r < INPUT_BUF)
80100e36:	85 c0                	test   %eax,%eax
80100e38:	0f 84 e9 fd ff ff    	je     80100c27 <consoleintr+0x27>
80100e3e:	8b 15 88 20 11 80    	mov    0x80112088,%edx
80100e44:	8b 0d 80 20 11 80    	mov    0x80112080,%ecx
80100e4a:	89 d3                	mov    %edx,%ebx
80100e4c:	29 cb                	sub    %ecx,%ebx
80100e4e:	83 fb 7f             	cmp    $0x7f,%ebx
80100e51:	0f 87 d0 fd ff ff    	ja     80100c27 <consoleintr+0x27>
        c = (c == '\r') ? '\n' : c;
80100e57:	8d 7a 01             	lea    0x1(%edx),%edi
80100e5a:	83 f8 0d             	cmp    $0xd,%eax
80100e5d:	0f 84 df 00 00 00    	je     80100f42 <consoleintr+0x342>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF)
80100e63:	88 85 64 ff ff ff    	mov    %al,-0x9c(%ebp)
80100e69:	83 f8 0a             	cmp    $0xa,%eax
80100e6c:	0f 84 dc 00 00 00    	je     80100f4e <consoleintr+0x34e>
80100e72:	83 f8 04             	cmp    $0x4,%eax
80100e75:	0f 84 d3 00 00 00    	je     80100f4e <consoleintr+0x34e>
80100e7b:	83 e9 80             	sub    $0xffffff80,%ecx
80100e7e:	39 ca                	cmp    %ecx,%edx
80100e80:	0f 84 c8 00 00 00    	je     80100f4e <consoleintr+0x34e>
          if (width == 0)
80100e86:	8b 35 8c 20 11 80    	mov    0x8011208c,%esi
80100e8c:	8b 1d 84 c5 10 80    	mov    0x8010c584,%ebx
80100e92:	8d 4e 01             	lea    0x1(%esi),%ecx
80100e95:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
80100e9b:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
80100ea1:	85 db                	test   %ebx,%ebx
80100ea3:	0f 85 8b 01 00 00    	jne    80101034 <consoleintr+0x434>
            input.buf[input.e++ % INPUT_BUF] = c;
80100ea9:	83 e2 7f             	and    $0x7f,%edx
80100eac:	89 3d 88 20 11 80    	mov    %edi,0x80112088
80100eb2:	88 82 00 20 11 80    	mov    %al,-0x7feee000(%edx)
  if(panicked){
80100eb8:	8b 15 7c c5 10 80    	mov    0x8010c57c,%edx
            input.pos++;
80100ebe:	89 0d 8c 20 11 80    	mov    %ecx,0x8011208c
  if(panicked){
80100ec4:	85 d2                	test   %edx,%edx
80100ec6:	0f 84 5e 01 00 00    	je     8010102a <consoleintr+0x42a>
80100ecc:	fa                   	cli    
    for(;;)
80100ecd:	eb fe                	jmp    80100ecd <consoleintr+0x2cd>
80100ecf:	90                   	nop
80100ed0:	b8 00 01 00 00       	mov    $0x100,%eax
80100ed5:	e8 36 f5 ff ff       	call   80100410 <consputc.part.0>
80100eda:	e9 48 fd ff ff       	jmp    80100c27 <consoleintr+0x27>
  release(&cons.lock);
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	68 40 c5 10 80       	push   $0x8010c540
80100ee7:	e8 c4 49 00 00       	call   801058b0 <release>
  if(doprocdump) {
80100eec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80100ef2:	83 c4 10             	add    $0x10,%esp
80100ef5:	85 c0                	test   %eax,%eax
80100ef7:	0f 85 23 01 00 00    	jne    80101020 <consoleintr+0x420>
}
80100efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f00:	5b                   	pop    %ebx
80100f01:	5e                   	pop    %esi
80100f02:	5f                   	pop    %edi
80100f03:	5d                   	pop    %ebp
80100f04:	c3                   	ret    
          consputc(temp_id);
80100f05:	0f be c0             	movsbl %al,%eax
        for (int i = 0; i < INPUT_BUF; i++)
80100f08:	83 c3 01             	add    $0x1,%ebx
80100f0b:	e8 00 f5 ff ff       	call   80100410 <consputc.part.0>
          input.buf[input.e++] = temp_id;
80100f10:	8b 0d 88 20 11 80    	mov    0x80112088,%ecx
80100f16:	89 f0                	mov    %esi,%eax
80100f18:	89 ca                	mov    %ecx,%edx
80100f1a:	8d 79 01             	lea    0x1(%ecx),%edi
80100f1d:	89 3d 88 20 11 80    	mov    %edi,0x80112088
80100f23:	89 f9                	mov    %edi,%ecx
80100f25:	88 82 00 20 11 80    	mov    %al,-0x7feee000(%edx)
        for (int i = 0; i < INPUT_BUF; i++)
80100f2b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80100f31:	0f 84 cb 00 00 00    	je     80101002 <consoleintr+0x402>
80100f37:	8b 3d 00 a0 10 80    	mov    0x8010a000,%edi
80100f3d:	e9 37 fe ff ff       	jmp    80100d79 <consoleintr+0x179>
80100f42:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
        c = (c == '\r') ? '\n' : c;
80100f49:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80100f4e:	0f b6 9d 64 ff ff ff 	movzbl -0x9c(%ebp),%ebx
  if(panicked){
80100f55:	8b 0d 7c c5 10 80    	mov    0x8010c57c,%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80100f5b:	83 e2 7f             	and    $0x7f,%edx
80100f5e:	89 3d 88 20 11 80    	mov    %edi,0x80112088
80100f64:	88 9a 00 20 11 80    	mov    %bl,-0x7feee000(%edx)
  if(panicked){
80100f6a:	85 c9                	test   %ecx,%ecx
80100f6c:	74 0a                	je     80100f78 <consoleintr+0x378>
80100f6e:	fa                   	cli    
    for(;;)
80100f6f:	eb fe                	jmp    80100f6f <consoleintr+0x36f>
80100f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f78:	e8 93 f4 ff ff       	call   80100410 <consputc.part.0>
          for (int i = 0; i+input.w < input.e -1; i++)
80100f7d:	a1 88 20 11 80       	mov    0x80112088,%eax
80100f82:	8b 0d 84 20 11 80    	mov    0x80112084,%ecx
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100f88:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
          width =0;
80100f8e:	c7 05 84 c5 10 80 00 	movl   $0x0,0x8010c584
80100f95:	00 00 00 
          for (int i = 0; i+input.w < input.e -1; i++)
80100f98:	83 e8 01             	sub    $0x1,%eax
80100f9b:	89 ca                	mov    %ecx,%edx
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100f9d:	29 ce                	sub    %ecx,%esi
          for (int i = 0; i+input.w < input.e -1; i++)
80100f9f:	39 c1                	cmp    %eax,%ecx
80100fa1:	73 16                	jae    80100fb9 <consoleintr+0x3b9>
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100fa3:	89 d3                	mov    %edx,%ebx
80100fa5:	83 e3 7f             	and    $0x7f,%ebx
80100fa8:	0f b6 9b 00 20 11 80 	movzbl -0x7feee000(%ebx),%ebx
80100faf:	88 1c 16             	mov    %bl,(%esi,%edx,1)
          for (int i = 0; i+input.w < input.e -1; i++)
80100fb2:	83 c2 01             	add    $0x1,%edx
80100fb5:	39 c2                	cmp    %eax,%edx
80100fb7:	75 ea                	jne    80100fa3 <consoleintr+0x3a3>
          cmd_[(input.e -1 -input.w)%INPUT_BUF] = '\0';
80100fb9:	29 c8                	sub    %ecx,%eax
          save_command(cmd_);
80100fbb:	83 ec 0c             	sub    $0xc,%esp
          cmd_[(input.e -1 -input.w)%INPUT_BUF] = '\0';
80100fbe:	83 e0 7f             	and    $0x7f,%eax
80100fc1:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80100fc8:	00 
          save_command(cmd_);
80100fc9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80100fcf:	50                   	push   %eax
80100fd0:	e8 8b fa ff ff       	call   80100a60 <save_command>
          cmd_idx = cmd_mem_size;
80100fd5:	a1 20 c5 10 80       	mov    0x8010c520,%eax
          wakeup(&input.r);
80100fda:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
          cmd_idx = cmd_mem_size;
80100fe1:	a3 00 a0 10 80       	mov    %eax,0x8010a000
          input.pos = input.e;
80100fe6:	a1 88 20 11 80       	mov    0x80112088,%eax
80100feb:	a3 8c 20 11 80       	mov    %eax,0x8011208c
          input.w = input.e;
80100ff0:	a3 84 20 11 80       	mov    %eax,0x80112084
          wakeup(&input.r);
80100ff5:	e8 d6 3a 00 00       	call   80104ad0 <wakeup>
        {
80100ffa:	83 c4 10             	add    $0x10,%esp
80100ffd:	e9 25 fc ff ff       	jmp    80100c27 <consoleintr+0x27>
80101002:	89 f8                	mov    %edi,%eax
80101004:	8b 3d 00 a0 10 80    	mov    0x8010a000,%edi
        input.pos = input.e;
8010100a:	a3 8c 20 11 80       	mov    %eax,0x8011208c
        cmd_idx--;
8010100f:	8d 47 ff             	lea    -0x1(%edi),%eax
80101012:	a3 00 a0 10 80       	mov    %eax,0x8010a000
80101017:	e9 0b fc ff ff       	jmp    80100c27 <consoleintr+0x27>
8010101c:	89 c8                	mov    %ecx,%eax
8010101e:	eb ea                	jmp    8010100a <consoleintr+0x40a>
    procdump();  // now call procdump() wo. cons.lock held
80101020:	e8 ab 3b 00 00       	call   80104bd0 <procdump>
}
80101025:	e9 d3 fe ff ff       	jmp    80100efd <consoleintr+0x2fd>
8010102a:	e8 e1 f3 ff ff       	call   80100410 <consputc.part.0>
8010102f:	e9 f3 fb ff ff       	jmp    80100c27 <consoleintr+0x27>
            for (int i = input.e; i > input.pos-1; i++)
80101034:	8d 5e ff             	lea    -0x1(%esi),%ebx
80101037:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
8010103d:	39 da                	cmp    %ebx,%edx
8010103f:	76 45                	jbe    80101086 <consoleintr+0x486>
80101041:	89 d3                	mov    %edx,%ebx
80101043:	c1 fb 1f             	sar    $0x1f,%ebx
80101046:	c1 eb 19             	shr    $0x19,%ebx
80101049:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
8010104c:	83 e1 7f             	and    $0x7f,%ecx
8010104f:	29 d9                	sub    %ebx,%ecx
80101051:	0f b6 99 00 20 11 80 	movzbl -0x7feee000(%ecx),%ebx
80101058:	88 9d 5b ff ff ff    	mov    %bl,-0xa5(%ebp)
              input.buf[(i+1)%INPUT_BUF] = input.buf[(i)%INPUT_BUF];
8010105e:	83 c2 01             	add    $0x1,%edx
80101061:	89 d3                	mov    %edx,%ebx
80101063:	c1 fb 1f             	sar    $0x1f,%ebx
80101066:	c1 eb 19             	shr    $0x19,%ebx
80101069:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
8010106c:	83 e1 7f             	and    $0x7f,%ecx
8010106f:	29 d9                	sub    %ebx,%ecx
80101071:	0f b6 9d 5b ff ff ff 	movzbl -0xa5(%ebp),%ebx
80101078:	88 99 00 20 11 80    	mov    %bl,-0x7feee000(%ecx)
            for (int i = input.e; i > input.pos-1; i++)
8010107e:	39 95 54 ff ff ff    	cmp    %edx,-0xac(%ebp)
80101084:	72 d8                	jb     8010105e <consoleintr+0x45e>
            cursor_gathering_char(c,width);
80101086:	83 ec 08             	sub    $0x8,%esp
80101089:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
            input.buf[input.pos%INPUT_BUF] = c;
8010108f:	0f b6 9d 64 ff ff ff 	movzbl -0x9c(%ebp),%ebx
80101096:	83 e6 7f             	and    $0x7f,%esi
            cursor_gathering_char(c,width);
80101099:	50                   	push   %eax
            input.e++;
8010109a:	89 3d 88 20 11 80    	mov    %edi,0x80112088
            input.pos++;
801010a0:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
            input.buf[input.pos%INPUT_BUF] = c;
801010a6:	88 9e 00 20 11 80    	mov    %bl,-0x7feee000(%esi)
            input.pos++;
801010ac:	89 3d 8c 20 11 80    	mov    %edi,0x8011208c
            cursor_gathering_char(c,width);
801010b2:	e8 e9 f8 ff ff       	call   801009a0 <cursor_gathering_char>
801010b7:	83 c4 10             	add    $0x10,%esp
801010ba:	e9 68 fb ff ff       	jmp    80100c27 <consoleintr+0x27>
801010bf:	90                   	nop

801010c0 <consoleinit>:

void
consoleinit(void)
{
801010c0:	f3 0f 1e fb          	endbr32 
801010c4:	55                   	push   %ebp
801010c5:	89 e5                	mov    %esp,%ebp
801010c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801010ca:	68 e8 86 10 80       	push   $0x801086e8
801010cf:	68 40 c5 10 80       	push   $0x8010c540
801010d4:	e8 57 45 00 00       	call   80105630 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801010d9:	58                   	pop    %eax
801010da:	5a                   	pop    %edx
801010db:	6a 00                	push   $0x0
801010dd:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801010df:	c7 05 4c 2f 11 80 30 	movl   $0x80100730,0x80112f4c
801010e6:	07 10 80 
  devsw[CONSOLE].read = consoleread;
801010e9:	c7 05 48 2f 11 80 90 	movl   $0x80100290,0x80112f48
801010f0:	02 10 80 
  cons.locking = 1;
801010f3:	c7 05 78 c5 10 80 01 	movl   $0x1,0x8010c578
801010fa:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801010fd:	e8 ce 19 00 00       	call   80102ad0 <ioapicenable>
}
80101102:	83 c4 10             	add    $0x10,%esp
80101105:	c9                   	leave  
80101106:	c3                   	ret    
80101107:	66 90                	xchg   %ax,%ax
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101110:	f3 0f 1e fb          	endbr32 
80101114:	55                   	push   %ebp
80101115:	89 e5                	mov    %esp,%ebp
80101117:	57                   	push   %edi
80101118:	56                   	push   %esi
80101119:	53                   	push   %ebx
8010111a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101120:	e8 fb 2f 00 00       	call   80104120 <myproc>
80101125:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010112b:	e8 a0 22 00 00       	call   801033d0 <begin_op>

  if((ip = namei(path)) == 0){
80101130:	83 ec 0c             	sub    $0xc,%esp
80101133:	ff 75 08             	pushl  0x8(%ebp)
80101136:	e8 95 15 00 00       	call   801026d0 <namei>
8010113b:	83 c4 10             	add    $0x10,%esp
8010113e:	85 c0                	test   %eax,%eax
80101140:	0f 84 08 03 00 00    	je     8010144e <exec+0x33e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	89 c3                	mov    %eax,%ebx
8010114b:	50                   	push   %eax
8010114c:	e8 af 0c 00 00       	call   80101e00 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101151:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101157:	6a 34                	push   $0x34
80101159:	6a 00                	push   $0x0
8010115b:	50                   	push   %eax
8010115c:	53                   	push   %ebx
8010115d:	e8 9e 0f 00 00       	call   80102100 <readi>
80101162:	83 c4 20             	add    $0x20,%esp
80101165:	83 f8 34             	cmp    $0x34,%eax
80101168:	74 26                	je     80101190 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	53                   	push   %ebx
8010116e:	e8 2d 0f 00 00       	call   801020a0 <iunlockput>
    end_op();
80101173:	e8 c8 22 00 00       	call   80103440 <end_op>
80101178:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010117b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101180:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101183:	5b                   	pop    %ebx
80101184:	5e                   	pop    %esi
80101185:	5f                   	pop    %edi
80101186:	5d                   	pop    %ebp
80101187:	c3                   	ret    
80101188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010118f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101190:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101197:	45 4c 46 
8010119a:	75 ce                	jne    8010116a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010119c:	e8 4f 72 00 00       	call   801083f0 <setupkvm>
801011a1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801011a7:	85 c0                	test   %eax,%eax
801011a9:	74 bf                	je     8010116a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011ab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801011b2:	00 
801011b3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801011b9:	0f 84 ae 02 00 00    	je     8010146d <exec+0x35d>
  sz = 0;
801011bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801011c6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011c9:	31 ff                	xor    %edi,%edi
801011cb:	e9 86 00 00 00       	jmp    80101256 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
801011d0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801011d7:	75 6c                	jne    80101245 <exec+0x135>
    if(ph.memsz < ph.filesz)
801011d9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801011df:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801011e5:	0f 82 87 00 00 00    	jb     80101272 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801011eb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801011f1:	72 7f                	jb     80101272 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801011f3:	83 ec 04             	sub    $0x4,%esp
801011f6:	50                   	push   %eax
801011f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011fd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101203:	e8 08 70 00 00       	call   80108210 <allocuvm>
80101208:	83 c4 10             	add    $0x10,%esp
8010120b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101211:	85 c0                	test   %eax,%eax
80101213:	74 5d                	je     80101272 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101215:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010121b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101220:	75 50                	jne    80101272 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101222:	83 ec 0c             	sub    $0xc,%esp
80101225:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010122b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101231:	53                   	push   %ebx
80101232:	50                   	push   %eax
80101233:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101239:	e8 02 6f 00 00       	call   80108140 <loaduvm>
8010123e:	83 c4 20             	add    $0x20,%esp
80101241:	85 c0                	test   %eax,%eax
80101243:	78 2d                	js     80101272 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101245:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010124c:	83 c7 01             	add    $0x1,%edi
8010124f:	83 c6 20             	add    $0x20,%esi
80101252:	39 f8                	cmp    %edi,%eax
80101254:	7e 3a                	jle    80101290 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101256:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010125c:	6a 20                	push   $0x20
8010125e:	56                   	push   %esi
8010125f:	50                   	push   %eax
80101260:	53                   	push   %ebx
80101261:	e8 9a 0e 00 00       	call   80102100 <readi>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	83 f8 20             	cmp    $0x20,%eax
8010126c:	0f 84 5e ff ff ff    	je     801011d0 <exec+0xc0>
    freevm(pgdir);
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010127b:	e8 f0 70 00 00       	call   80108370 <freevm>
  if(ip){
80101280:	83 c4 10             	add    $0x10,%esp
80101283:	e9 e2 fe ff ff       	jmp    8010116a <exec+0x5a>
80101288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop
80101290:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101296:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010129c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801012a2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801012a8:	83 ec 0c             	sub    $0xc,%esp
801012ab:	53                   	push   %ebx
801012ac:	e8 ef 0d 00 00       	call   801020a0 <iunlockput>
  end_op();
801012b1:	e8 8a 21 00 00       	call   80103440 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801012b6:	83 c4 0c             	add    $0xc,%esp
801012b9:	56                   	push   %esi
801012ba:	57                   	push   %edi
801012bb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801012c1:	57                   	push   %edi
801012c2:	e8 49 6f 00 00       	call   80108210 <allocuvm>
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	89 c6                	mov    %eax,%esi
801012cc:	85 c0                	test   %eax,%eax
801012ce:	0f 84 94 00 00 00    	je     80101368 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801012dd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012df:	50                   	push   %eax
801012e0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801012e1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012e3:	e8 a8 71 00 00       	call   80108490 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801012eb:	83 c4 10             	add    $0x10,%esp
801012ee:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801012f4:	8b 00                	mov    (%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	0f 84 8b 00 00 00    	je     80101389 <exec+0x279>
801012fe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101304:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010130a:	eb 23                	jmp    8010132f <exec+0x21f>
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101310:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101313:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010131a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010131d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101323:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 59                	je     80101383 <exec+0x273>
    if(argc >= MAXARG)
8010132a:	83 ff 20             	cmp    $0x20,%edi
8010132d:	74 39                	je     80101368 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	50                   	push   %eax
80101333:	e8 d8 47 00 00       	call   80105b10 <strlen>
80101338:	f7 d0                	not    %eax
8010133a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010133c:	58                   	pop    %eax
8010133d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101340:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101343:	ff 34 b8             	pushl  (%eax,%edi,4)
80101346:	e8 c5 47 00 00       	call   80105b10 <strlen>
8010134b:	83 c0 01             	add    $0x1,%eax
8010134e:	50                   	push   %eax
8010134f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101352:	ff 34 b8             	pushl  (%eax,%edi,4)
80101355:	53                   	push   %ebx
80101356:	56                   	push   %esi
80101357:	e8 94 72 00 00       	call   801085f0 <copyout>
8010135c:	83 c4 20             	add    $0x20,%esp
8010135f:	85 c0                	test   %eax,%eax
80101361:	79 ad                	jns    80101310 <exec+0x200>
80101363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101367:	90                   	nop
    freevm(pgdir);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101371:	e8 fa 6f 00 00       	call   80108370 <freevm>
80101376:	83 c4 10             	add    $0x10,%esp
  return -1;
80101379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137e:	e9 fd fd ff ff       	jmp    80101180 <exec+0x70>
80101383:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101389:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101390:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101392:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101399:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010139d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010139f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801013a2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801013a8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801013aa:	50                   	push   %eax
801013ab:	52                   	push   %edx
801013ac:	53                   	push   %ebx
801013ad:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801013b3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801013ba:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801013bd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801013c3:	e8 28 72 00 00       	call   801085f0 <copyout>
801013c8:	83 c4 10             	add    $0x10,%esp
801013cb:	85 c0                	test   %eax,%eax
801013cd:	78 99                	js     80101368 <exec+0x258>
  for(last=s=path; *s; s++)
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	8b 55 08             	mov    0x8(%ebp),%edx
801013d5:	0f b6 00             	movzbl (%eax),%eax
801013d8:	84 c0                	test   %al,%al
801013da:	74 13                	je     801013ef <exec+0x2df>
801013dc:	89 d1                	mov    %edx,%ecx
801013de:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801013e0:	83 c1 01             	add    $0x1,%ecx
801013e3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801013e5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801013e8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801013eb:	84 c0                	test   %al,%al
801013ed:	75 f1                	jne    801013e0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801013ef:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801013f5:	83 ec 04             	sub    $0x4,%esp
801013f8:	6a 10                	push   $0x10
801013fa:	89 f8                	mov    %edi,%eax
801013fc:	52                   	push   %edx
801013fd:	83 c0 6c             	add    $0x6c,%eax
80101400:	50                   	push   %eax
80101401:	e8 ca 46 00 00       	call   80105ad0 <safestrcpy>
  curproc->pgdir = pgdir;
80101406:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010140c:	89 f8                	mov    %edi,%eax
8010140e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101411:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101413:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101416:	89 c1                	mov    %eax,%ecx
80101418:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010141e:	8b 40 18             	mov    0x18(%eax),%eax
80101421:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101424:	8b 41 18             	mov    0x18(%ecx),%eax
80101427:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->qnum = 2;
8010142a:	c7 81 f4 00 00 00 02 	movl   $0x2,0xf4(%ecx)
80101431:	00 00 00 
  switchuvm(curproc);
80101434:	89 0c 24             	mov    %ecx,(%esp)
80101437:	e8 74 6b 00 00       	call   80107fb0 <switchuvm>
  freevm(oldpgdir);
8010143c:	89 3c 24             	mov    %edi,(%esp)
8010143f:	e8 2c 6f 00 00       	call   80108370 <freevm>
  return 0;
80101444:	83 c4 10             	add    $0x10,%esp
80101447:	31 c0                	xor    %eax,%eax
80101449:	e9 32 fd ff ff       	jmp    80101180 <exec+0x70>
    end_op();
8010144e:	e8 ed 1f 00 00       	call   80103440 <end_op>
    cprintf("exec: fail\n");
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	68 01 87 10 80       	push   $0x80108701
8010145b:	e8 40 f3 ff ff       	call   801007a0 <cprintf>
    return -1;
80101460:	83 c4 10             	add    $0x10,%esp
80101463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101468:	e9 13 fd ff ff       	jmp    80101180 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010146d:	31 ff                	xor    %edi,%edi
8010146f:	be 00 20 00 00       	mov    $0x2000,%esi
80101474:	e9 2f fe ff ff       	jmp    801012a8 <exec+0x198>
80101479:	66 90                	xchg   %ax,%ax
8010147b:	66 90                	xchg   %ax,%ax
8010147d:	66 90                	xchg   %ax,%ax
8010147f:	90                   	nop

80101480 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101480:	f3 0f 1e fb          	endbr32 
80101484:	55                   	push   %ebp
80101485:	89 e5                	mov    %esp,%ebp
80101487:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010148a:	68 0d 87 10 80       	push   $0x8010870d
8010148f:	68 a0 25 11 80       	push   $0x801125a0
80101494:	e8 97 41 00 00       	call   80105630 <initlock>
}
80101499:	83 c4 10             	add    $0x10,%esp
8010149c:	c9                   	leave  
8010149d:	c3                   	ret    
8010149e:	66 90                	xchg   %ax,%ax

801014a0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801014a0:	f3 0f 1e fb          	endbr32 
801014a4:	55                   	push   %ebp
801014a5:	89 e5                	mov    %esp,%ebp
801014a7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014a8:	bb d8 25 11 80       	mov    $0x801125d8,%ebx
{
801014ad:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801014b0:	68 a0 25 11 80       	push   $0x801125a0
801014b5:	e8 06 43 00 00       	call   801057c0 <acquire>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb 0c                	jmp    801014cb <filealloc+0x2b>
801014bf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014c0:	83 c3 18             	add    $0x18,%ebx
801014c3:	81 fb 38 2f 11 80    	cmp    $0x80112f38,%ebx
801014c9:	74 25                	je     801014f0 <filealloc+0x50>
    if(f->ref == 0){
801014cb:	8b 43 04             	mov    0x4(%ebx),%eax
801014ce:	85 c0                	test   %eax,%eax
801014d0:	75 ee                	jne    801014c0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801014d2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801014d5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801014dc:	68 a0 25 11 80       	push   $0x801125a0
801014e1:	e8 ca 43 00 00       	call   801058b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801014e6:	89 d8                	mov    %ebx,%eax
      return f;
801014e8:	83 c4 10             	add    $0x10,%esp
}
801014eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014ee:	c9                   	leave  
801014ef:	c3                   	ret    
  release(&ftable.lock);
801014f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801014f3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801014f5:	68 a0 25 11 80       	push   $0x801125a0
801014fa:	e8 b1 43 00 00       	call   801058b0 <release>
}
801014ff:	89 d8                	mov    %ebx,%eax
  return 0;
80101501:	83 c4 10             	add    $0x10,%esp
}
80101504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101507:	c9                   	leave  
80101508:	c3                   	ret    
80101509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101510 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	53                   	push   %ebx
80101518:	83 ec 10             	sub    $0x10,%esp
8010151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010151e:	68 a0 25 11 80       	push   $0x801125a0
80101523:	e8 98 42 00 00       	call   801057c0 <acquire>
  if(f->ref < 1)
80101528:	8b 43 04             	mov    0x4(%ebx),%eax
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	85 c0                	test   %eax,%eax
80101530:	7e 1a                	jle    8010154c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101532:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101535:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101538:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010153b:	68 a0 25 11 80       	push   $0x801125a0
80101540:	e8 6b 43 00 00       	call   801058b0 <release>
  return f;
}
80101545:	89 d8                	mov    %ebx,%eax
80101547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010154a:	c9                   	leave  
8010154b:	c3                   	ret    
    panic("filedup");
8010154c:	83 ec 0c             	sub    $0xc,%esp
8010154f:	68 14 87 10 80       	push   $0x80108714
80101554:	e8 37 ee ff ff       	call   80100390 <panic>
80101559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101560 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	57                   	push   %edi
80101568:	56                   	push   %esi
80101569:	53                   	push   %ebx
8010156a:	83 ec 28             	sub    $0x28,%esp
8010156d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101570:	68 a0 25 11 80       	push   $0x801125a0
80101575:	e8 46 42 00 00       	call   801057c0 <acquire>
  if(f->ref < 1)
8010157a:	8b 53 04             	mov    0x4(%ebx),%edx
8010157d:	83 c4 10             	add    $0x10,%esp
80101580:	85 d2                	test   %edx,%edx
80101582:	0f 8e a1 00 00 00    	jle    80101629 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101588:	83 ea 01             	sub    $0x1,%edx
8010158b:	89 53 04             	mov    %edx,0x4(%ebx)
8010158e:	75 40                	jne    801015d0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101590:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101594:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101597:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101599:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010159f:	8b 73 0c             	mov    0xc(%ebx),%esi
801015a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801015a5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801015a8:	68 a0 25 11 80       	push   $0x801125a0
  ff = *f;
801015ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801015b0:	e8 fb 42 00 00       	call   801058b0 <release>

  if(ff.type == FD_PIPE)
801015b5:	83 c4 10             	add    $0x10,%esp
801015b8:	83 ff 01             	cmp    $0x1,%edi
801015bb:	74 53                	je     80101610 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801015bd:	83 ff 02             	cmp    $0x2,%edi
801015c0:	74 26                	je     801015e8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801015c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015c5:	5b                   	pop    %ebx
801015c6:	5e                   	pop    %esi
801015c7:	5f                   	pop    %edi
801015c8:	5d                   	pop    %ebp
801015c9:	c3                   	ret    
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801015d0:	c7 45 08 a0 25 11 80 	movl   $0x801125a0,0x8(%ebp)
}
801015d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015da:	5b                   	pop    %ebx
801015db:	5e                   	pop    %esi
801015dc:	5f                   	pop    %edi
801015dd:	5d                   	pop    %ebp
    release(&ftable.lock);
801015de:	e9 cd 42 00 00       	jmp    801058b0 <release>
801015e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015e7:	90                   	nop
    begin_op();
801015e8:	e8 e3 1d 00 00       	call   801033d0 <begin_op>
    iput(ff.ip);
801015ed:	83 ec 0c             	sub    $0xc,%esp
801015f0:	ff 75 e0             	pushl  -0x20(%ebp)
801015f3:	e8 38 09 00 00       	call   80101f30 <iput>
    end_op();
801015f8:	83 c4 10             	add    $0x10,%esp
}
801015fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fe:	5b                   	pop    %ebx
801015ff:	5e                   	pop    %esi
80101600:	5f                   	pop    %edi
80101601:	5d                   	pop    %ebp
    end_op();
80101602:	e9 39 1e 00 00       	jmp    80103440 <end_op>
80101607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101610:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101614:	83 ec 08             	sub    $0x8,%esp
80101617:	53                   	push   %ebx
80101618:	56                   	push   %esi
80101619:	e8 82 25 00 00       	call   80103ba0 <pipeclose>
8010161e:	83 c4 10             	add    $0x10,%esp
}
80101621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101624:	5b                   	pop    %ebx
80101625:	5e                   	pop    %esi
80101626:	5f                   	pop    %edi
80101627:	5d                   	pop    %ebp
80101628:	c3                   	ret    
    panic("fileclose");
80101629:	83 ec 0c             	sub    $0xc,%esp
8010162c:	68 1c 87 10 80       	push   $0x8010871c
80101631:	e8 5a ed ff ff       	call   80100390 <panic>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101640:	f3 0f 1e fb          	endbr32 
80101644:	55                   	push   %ebp
80101645:	89 e5                	mov    %esp,%ebp
80101647:	53                   	push   %ebx
80101648:	83 ec 04             	sub    $0x4,%esp
8010164b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010164e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101651:	75 2d                	jne    80101680 <filestat+0x40>
    ilock(f->ip);
80101653:	83 ec 0c             	sub    $0xc,%esp
80101656:	ff 73 10             	pushl  0x10(%ebx)
80101659:	e8 a2 07 00 00       	call   80101e00 <ilock>
    stati(f->ip, st);
8010165e:	58                   	pop    %eax
8010165f:	5a                   	pop    %edx
80101660:	ff 75 0c             	pushl  0xc(%ebp)
80101663:	ff 73 10             	pushl  0x10(%ebx)
80101666:	e8 65 0a 00 00       	call   801020d0 <stati>
    iunlock(f->ip);
8010166b:	59                   	pop    %ecx
8010166c:	ff 73 10             	pushl  0x10(%ebx)
8010166f:	e8 6c 08 00 00       	call   80101ee0 <iunlock>
    return 0;
  }
  return -1;
}
80101674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101677:	83 c4 10             	add    $0x10,%esp
8010167a:	31 c0                	xor    %eax,%eax
}
8010167c:	c9                   	leave  
8010167d:	c3                   	ret    
8010167e:	66 90                	xchg   %ax,%ax
80101680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101688:	c9                   	leave  
80101689:	c3                   	ret    
8010168a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101690 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101690:	f3 0f 1e fb          	endbr32 
80101694:	55                   	push   %ebp
80101695:	89 e5                	mov    %esp,%ebp
80101697:	57                   	push   %edi
80101698:	56                   	push   %esi
80101699:	53                   	push   %ebx
8010169a:	83 ec 0c             	sub    $0xc,%esp
8010169d:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016a0:	8b 75 0c             	mov    0xc(%ebp),%esi
801016a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801016a6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801016aa:	74 64                	je     80101710 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801016ac:	8b 03                	mov    (%ebx),%eax
801016ae:	83 f8 01             	cmp    $0x1,%eax
801016b1:	74 45                	je     801016f8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801016b3:	83 f8 02             	cmp    $0x2,%eax
801016b6:	75 5f                	jne    80101717 <fileread+0x87>
    ilock(f->ip);
801016b8:	83 ec 0c             	sub    $0xc,%esp
801016bb:	ff 73 10             	pushl  0x10(%ebx)
801016be:	e8 3d 07 00 00       	call   80101e00 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801016c3:	57                   	push   %edi
801016c4:	ff 73 14             	pushl  0x14(%ebx)
801016c7:	56                   	push   %esi
801016c8:	ff 73 10             	pushl  0x10(%ebx)
801016cb:	e8 30 0a 00 00       	call   80102100 <readi>
801016d0:	83 c4 20             	add    $0x20,%esp
801016d3:	89 c6                	mov    %eax,%esi
801016d5:	85 c0                	test   %eax,%eax
801016d7:	7e 03                	jle    801016dc <fileread+0x4c>
      f->off += r;
801016d9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801016dc:	83 ec 0c             	sub    $0xc,%esp
801016df:	ff 73 10             	pushl  0x10(%ebx)
801016e2:	e8 f9 07 00 00       	call   80101ee0 <iunlock>
    return r;
801016e7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ed:	89 f0                	mov    %esi,%eax
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5f                   	pop    %edi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
801016f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801016f8:	8b 43 0c             	mov    0xc(%ebx),%eax
801016fb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101701:	5b                   	pop    %ebx
80101702:	5e                   	pop    %esi
80101703:	5f                   	pop    %edi
80101704:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101705:	e9 36 26 00 00       	jmp    80103d40 <piperead>
8010170a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101710:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101715:	eb d3                	jmp    801016ea <fileread+0x5a>
  panic("fileread");
80101717:	83 ec 0c             	sub    $0xc,%esp
8010171a:	68 26 87 10 80       	push   $0x80108726
8010171f:	e8 6c ec ff ff       	call   80100390 <panic>
80101724:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010172f:	90                   	nop

80101730 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	57                   	push   %edi
80101738:	56                   	push   %esi
80101739:	53                   	push   %ebx
8010173a:	83 ec 1c             	sub    $0x1c,%esp
8010173d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101740:	8b 75 08             	mov    0x8(%ebp),%esi
80101743:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101746:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101749:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010174d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101750:	0f 84 c1 00 00 00    	je     80101817 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101756:	8b 06                	mov    (%esi),%eax
80101758:	83 f8 01             	cmp    $0x1,%eax
8010175b:	0f 84 c3 00 00 00    	je     80101824 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101761:	83 f8 02             	cmp    $0x2,%eax
80101764:	0f 85 cc 00 00 00    	jne    80101836 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010176a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010176d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010176f:	85 c0                	test   %eax,%eax
80101771:	7f 34                	jg     801017a7 <filewrite+0x77>
80101773:	e9 98 00 00 00       	jmp    80101810 <filewrite+0xe0>
80101778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101780:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101783:	83 ec 0c             	sub    $0xc,%esp
80101786:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101789:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010178c:	e8 4f 07 00 00       	call   80101ee0 <iunlock>
      end_op();
80101791:	e8 aa 1c 00 00       	call   80103440 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101796:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	39 c3                	cmp    %eax,%ebx
8010179e:	75 60                	jne    80101800 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801017a0:	01 df                	add    %ebx,%edi
    while(i < n){
801017a2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801017a5:	7e 69                	jle    80101810 <filewrite+0xe0>
      int n1 = n - i;
801017a7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801017aa:	b8 00 06 00 00       	mov    $0x600,%eax
801017af:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801017b1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801017b7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801017ba:	e8 11 1c 00 00       	call   801033d0 <begin_op>
      ilock(f->ip);
801017bf:	83 ec 0c             	sub    $0xc,%esp
801017c2:	ff 76 10             	pushl  0x10(%esi)
801017c5:	e8 36 06 00 00       	call   80101e00 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801017ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017cd:	53                   	push   %ebx
801017ce:	ff 76 14             	pushl  0x14(%esi)
801017d1:	01 f8                	add    %edi,%eax
801017d3:	50                   	push   %eax
801017d4:	ff 76 10             	pushl  0x10(%esi)
801017d7:	e8 24 0a 00 00       	call   80102200 <writei>
801017dc:	83 c4 20             	add    $0x20,%esp
801017df:	85 c0                	test   %eax,%eax
801017e1:	7f 9d                	jg     80101780 <filewrite+0x50>
      iunlock(f->ip);
801017e3:	83 ec 0c             	sub    $0xc,%esp
801017e6:	ff 76 10             	pushl  0x10(%esi)
801017e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017ec:	e8 ef 06 00 00       	call   80101ee0 <iunlock>
      end_op();
801017f1:	e8 4a 1c 00 00       	call   80103440 <end_op>
      if(r < 0)
801017f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017f9:	83 c4 10             	add    $0x10,%esp
801017fc:	85 c0                	test   %eax,%eax
801017fe:	75 17                	jne    80101817 <filewrite+0xe7>
        panic("short filewrite");
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	68 2f 87 10 80       	push   $0x8010872f
80101808:	e8 83 eb ff ff       	call   80100390 <panic>
8010180d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101810:	89 f8                	mov    %edi,%eax
80101812:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101815:	74 05                	je     8010181c <filewrite+0xec>
80101817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010181c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181f:	5b                   	pop    %ebx
80101820:	5e                   	pop    %esi
80101821:	5f                   	pop    %edi
80101822:	5d                   	pop    %ebp
80101823:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101824:	8b 46 0c             	mov    0xc(%esi),%eax
80101827:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010182a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182d:	5b                   	pop    %ebx
8010182e:	5e                   	pop    %esi
8010182f:	5f                   	pop    %edi
80101830:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101831:	e9 0a 24 00 00       	jmp    80103c40 <pipewrite>
  panic("filewrite");
80101836:	83 ec 0c             	sub    $0xc,%esp
80101839:	68 35 87 10 80       	push   $0x80108735
8010183e:	e8 4d eb ff ff       	call   80100390 <panic>
80101843:	66 90                	xchg   %ax,%ax
80101845:	66 90                	xchg   %ax,%ax
80101847:	66 90                	xchg   %ax,%ax
80101849:	66 90                	xchg   %ax,%ax
8010184b:	66 90                	xchg   %ax,%ax
8010184d:	66 90                	xchg   %ax,%ax
8010184f:	90                   	nop

80101850 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101850:	55                   	push   %ebp
80101851:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101853:	89 d0                	mov    %edx,%eax
80101855:	c1 e8 0c             	shr    $0xc,%eax
80101858:	03 05 b8 2f 11 80    	add    0x80112fb8,%eax
{
8010185e:	89 e5                	mov    %esp,%ebp
80101860:	56                   	push   %esi
80101861:	53                   	push   %ebx
80101862:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101864:	83 ec 08             	sub    $0x8,%esp
80101867:	50                   	push   %eax
80101868:	51                   	push   %ecx
80101869:	e8 62 e8 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010186e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101870:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101873:	ba 01 00 00 00       	mov    $0x1,%edx
80101878:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010187b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101881:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101884:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101886:	0f b6 4c 18 60       	movzbl 0x60(%eax,%ebx,1),%ecx
8010188b:	85 d1                	test   %edx,%ecx
8010188d:	74 25                	je     801018b4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010188f:	f7 d2                	not    %edx
  log_write(bp);
80101891:	83 ec 0c             	sub    $0xc,%esp
80101894:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101896:	21 ca                	and    %ecx,%edx
80101898:	88 54 18 60          	mov    %dl,0x60(%eax,%ebx,1)
  log_write(bp);
8010189c:	50                   	push   %eax
8010189d:	e8 0e 1d 00 00       	call   801035b0 <log_write>
  brelse(bp);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 46 e9 ff ff       	call   801001f0 <brelse>
}
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5d                   	pop    %ebp
801018b3:	c3                   	ret    
    panic("freeing free block");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 3f 87 10 80       	push   $0x8010873f
801018bc:	e8 cf ea ff ff       	call   80100390 <panic>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <balloc>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801018d9:	8b 0d a0 2f 11 80    	mov    0x80112fa0,%ecx
{
801018df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801018e2:	85 c9                	test   %ecx,%ecx
801018e4:	0f 84 87 00 00 00    	je     80101971 <balloc+0xa1>
801018ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801018f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801018f4:	83 ec 08             	sub    $0x8,%esp
801018f7:	89 f0                	mov    %esi,%eax
801018f9:	c1 f8 0c             	sar    $0xc,%eax
801018fc:	03 05 b8 2f 11 80    	add    0x80112fb8,%eax
80101902:	50                   	push   %eax
80101903:	ff 75 d8             	pushl  -0x28(%ebp)
80101906:	e8 c5 e7 ff ff       	call   801000d0 <bread>
8010190b:	83 c4 10             	add    $0x10,%esp
8010190e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101911:	a1 a0 2f 11 80       	mov    0x80112fa0,%eax
80101916:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101919:	31 c0                	xor    %eax,%eax
8010191b:	eb 2f                	jmp    8010194c <balloc+0x7c>
8010191d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101920:	89 c1                	mov    %eax,%ecx
80101922:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101927:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010192a:	83 e1 07             	and    $0x7,%ecx
8010192d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010192f:	89 c1                	mov    %eax,%ecx
80101931:	c1 f9 03             	sar    $0x3,%ecx
80101934:	0f b6 7c 0a 60       	movzbl 0x60(%edx,%ecx,1),%edi
80101939:	89 fa                	mov    %edi,%edx
8010193b:	85 df                	test   %ebx,%edi
8010193d:	74 41                	je     80101980 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010193f:	83 c0 01             	add    $0x1,%eax
80101942:	83 c6 01             	add    $0x1,%esi
80101945:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010194a:	74 05                	je     80101951 <balloc+0x81>
8010194c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010194f:	77 cf                	ja     80101920 <balloc+0x50>
    brelse(bp);
80101951:	83 ec 0c             	sub    $0xc,%esp
80101954:	ff 75 e4             	pushl  -0x1c(%ebp)
80101957:	e8 94 e8 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010195c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
80101966:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101969:	39 05 a0 2f 11 80    	cmp    %eax,0x80112fa0
8010196f:	77 80                	ja     801018f1 <balloc+0x21>
  panic("balloc: out of blocks");
80101971:	83 ec 0c             	sub    $0xc,%esp
80101974:	68 52 87 10 80       	push   $0x80108752
80101979:	e8 12 ea ff ff       	call   80100390 <panic>
8010197e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101983:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101986:	09 da                	or     %ebx,%edx
80101988:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
        log_write(bp);
8010198c:	57                   	push   %edi
8010198d:	e8 1e 1c 00 00       	call   801035b0 <log_write>
        brelse(bp);
80101992:	89 3c 24             	mov    %edi,(%esp)
80101995:	e8 56 e8 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010199a:	58                   	pop    %eax
8010199b:	5a                   	pop    %edx
8010199c:	56                   	push   %esi
8010199d:	ff 75 d8             	pushl  -0x28(%ebp)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801019a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801019a8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801019aa:	8d 40 60             	lea    0x60(%eax),%eax
801019ad:	68 00 02 00 00       	push   $0x200
801019b2:	6a 00                	push   $0x0
801019b4:	50                   	push   %eax
801019b5:	e8 56 3f 00 00       	call   80105910 <memset>
  log_write(bp);
801019ba:	89 1c 24             	mov    %ebx,(%esp)
801019bd:	e8 ee 1b 00 00       	call   801035b0 <log_write>
  brelse(bp);
801019c2:	89 1c 24             	mov    %ebx,(%esp)
801019c5:	e8 26 e8 ff ff       	call   801001f0 <brelse>
}
801019ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cd:	89 f0                	mov    %esi,%eax
801019cf:	5b                   	pop    %ebx
801019d0:	5e                   	pop    %esi
801019d1:	5f                   	pop    %edi
801019d2:	5d                   	pop    %ebp
801019d3:	c3                   	ret    
801019d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop

801019e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	89 c7                	mov    %eax,%edi
801019e6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801019e7:	31 f6                	xor    %esi,%esi
{
801019e9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019ea:	bb f8 2f 11 80       	mov    $0x80112ff8,%ebx
{
801019ef:	83 ec 28             	sub    $0x28,%esp
801019f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801019f5:	68 c0 2f 11 80       	push   $0x80112fc0
801019fa:	e8 c1 3d 00 00       	call   801057c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101a02:	83 c4 10             	add    $0x10,%esp
80101a05:	eb 1b                	jmp    80101a22 <iget+0x42>
80101a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a10:	39 3b                	cmp    %edi,(%ebx)
80101a12:	74 6c                	je     80101a80 <iget+0xa0>
80101a14:	81 c3 94 00 00 00    	add    $0x94,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a1a:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
80101a20:	73 26                	jae    80101a48 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a22:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101a25:	85 c9                	test   %ecx,%ecx
80101a27:	7f e7                	jg     80101a10 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a29:	85 f6                	test   %esi,%esi
80101a2b:	75 e7                	jne    80101a14 <iget+0x34>
80101a2d:	89 d8                	mov    %ebx,%eax
80101a2f:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101a35:	85 c9                	test   %ecx,%ecx
80101a37:	75 6e                	jne    80101aa7 <iget+0xc7>
80101a39:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a3b:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
80101a41:	72 df                	jb     80101a22 <iget+0x42>
80101a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a47:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a48:	85 f6                	test   %esi,%esi
80101a4a:	74 73                	je     80101abf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101a4c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101a4f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101a51:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101a54:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101a5b:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
  release(&icache.lock);
80101a62:	68 c0 2f 11 80       	push   $0x80112fc0
80101a67:	e8 44 3e 00 00       	call   801058b0 <release>

  return ip;
80101a6c:	83 c4 10             	add    $0x10,%esp
}
80101a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a72:	89 f0                	mov    %esi,%eax
80101a74:	5b                   	pop    %ebx
80101a75:	5e                   	pop    %esi
80101a76:	5f                   	pop    %edi
80101a77:	5d                   	pop    %ebp
80101a78:	c3                   	ret    
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a80:	39 53 04             	cmp    %edx,0x4(%ebx)
80101a83:	75 8f                	jne    80101a14 <iget+0x34>
      release(&icache.lock);
80101a85:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101a88:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101a8b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101a8d:	68 c0 2f 11 80       	push   $0x80112fc0
      ip->ref++;
80101a92:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101a95:	e8 16 3e 00 00       	call   801058b0 <release>
      return ip;
80101a9a:	83 c4 10             	add    $0x10,%esp
}
80101a9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa0:	89 f0                	mov    %esi,%eax
80101aa2:	5b                   	pop    %ebx
80101aa3:	5e                   	pop    %esi
80101aa4:	5f                   	pop    %edi
80101aa5:	5d                   	pop    %ebp
80101aa6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101aa7:	81 fb e0 4c 11 80    	cmp    $0x80114ce0,%ebx
80101aad:	73 10                	jae    80101abf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101aaf:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101ab2:	85 c9                	test   %ecx,%ecx
80101ab4:	0f 8f 56 ff ff ff    	jg     80101a10 <iget+0x30>
80101aba:	e9 6e ff ff ff       	jmp    80101a2d <iget+0x4d>
    panic("iget: no inodes");
80101abf:	83 ec 0c             	sub    $0xc,%esp
80101ac2:	68 68 87 10 80       	push   $0x80108768
80101ac7:	e8 c4 e8 ff ff       	call   80100390 <panic>
80101acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	89 c6                	mov    %eax,%esi
80101ad7:	53                   	push   %ebx
80101ad8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101adb:	83 fa 0b             	cmp    $0xb,%edx
80101ade:	0f 86 84 00 00 00    	jbe    80101b68 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101ae4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101ae7:	83 fb 7f             	cmp    $0x7f,%ebx
80101aea:	0f 87 98 00 00 00    	ja     80101b88 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101af0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80101af6:	8b 16                	mov    (%esi),%edx
80101af8:	85 c0                	test   %eax,%eax
80101afa:	74 54                	je     80101b50 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101afc:	83 ec 08             	sub    $0x8,%esp
80101aff:	50                   	push   %eax
80101b00:	52                   	push   %edx
80101b01:	e8 ca e5 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101b06:	83 c4 10             	add    $0x10,%esp
80101b09:	8d 54 98 60          	lea    0x60(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101b0d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101b0f:	8b 1a                	mov    (%edx),%ebx
80101b11:	85 db                	test   %ebx,%ebx
80101b13:	74 1b                	je     80101b30 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101b15:	83 ec 0c             	sub    $0xc,%esp
80101b18:	57                   	push   %edi
80101b19:	e8 d2 e6 ff ff       	call   801001f0 <brelse>
    return addr;
80101b1e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b24:	89 d8                	mov    %ebx,%eax
80101b26:	5b                   	pop    %ebx
80101b27:	5e                   	pop    %esi
80101b28:	5f                   	pop    %edi
80101b29:	5d                   	pop    %ebp
80101b2a:	c3                   	ret    
80101b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b2f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101b30:	8b 06                	mov    (%esi),%eax
80101b32:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101b35:	e8 96 fd ff ff       	call   801018d0 <balloc>
80101b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101b3d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101b40:	89 c3                	mov    %eax,%ebx
80101b42:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101b44:	57                   	push   %edi
80101b45:	e8 66 1a 00 00       	call   801035b0 <log_write>
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	eb c6                	jmp    80101b15 <bmap+0x45>
80101b4f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b50:	89 d0                	mov    %edx,%eax
80101b52:	e8 79 fd ff ff       	call   801018d0 <balloc>
80101b57:	8b 16                	mov    (%esi),%edx
80101b59:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
80101b5f:	eb 9b                	jmp    80101afc <bmap+0x2c>
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101b68:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101b6b:	8b 5f 60             	mov    0x60(%edi),%ebx
80101b6e:	85 db                	test   %ebx,%ebx
80101b70:	75 af                	jne    80101b21 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b72:	8b 00                	mov    (%eax),%eax
80101b74:	e8 57 fd ff ff       	call   801018d0 <balloc>
80101b79:	89 47 60             	mov    %eax,0x60(%edi)
80101b7c:	89 c3                	mov    %eax,%ebx
}
80101b7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b81:	89 d8                	mov    %ebx,%eax
80101b83:	5b                   	pop    %ebx
80101b84:	5e                   	pop    %esi
80101b85:	5f                   	pop    %edi
80101b86:	5d                   	pop    %ebp
80101b87:	c3                   	ret    
  panic("bmap: out of range");
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 78 87 10 80       	push   $0x80108778
80101b90:	e8 fb e7 ff ff       	call   80100390 <panic>
80101b95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <readsb>:
{
80101ba0:	f3 0f 1e fb          	endbr32 
80101ba4:	55                   	push   %ebp
80101ba5:	89 e5                	mov    %esp,%ebp
80101ba7:	56                   	push   %esi
80101ba8:	53                   	push   %ebx
80101ba9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101bac:	83 ec 08             	sub    $0x8,%esp
80101baf:	6a 01                	push   $0x1
80101bb1:	ff 75 08             	pushl  0x8(%ebp)
80101bb4:	e8 17 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101bb9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101bbc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101bbe:	8d 40 60             	lea    0x60(%eax),%eax
80101bc1:	6a 1c                	push   $0x1c
80101bc3:	50                   	push   %eax
80101bc4:	56                   	push   %esi
80101bc5:	e8 e6 3d 00 00       	call   801059b0 <memmove>
  brelse(bp);
80101bca:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101bcd:	83 c4 10             	add    $0x10,%esp
}
80101bd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bd3:	5b                   	pop    %ebx
80101bd4:	5e                   	pop    %esi
80101bd5:	5d                   	pop    %ebp
  brelse(bp);
80101bd6:	e9 15 e6 ff ff       	jmp    801001f0 <brelse>
80101bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop

80101be0 <iinit>:
{
80101be0:	f3 0f 1e fb          	endbr32 
80101be4:	55                   	push   %ebp
80101be5:	89 e5                	mov    %esp,%ebp
80101be7:	53                   	push   %ebx
80101be8:	bb 04 30 11 80       	mov    $0x80113004,%ebx
80101bed:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101bf0:	68 8b 87 10 80       	push   $0x8010878b
80101bf5:	68 c0 2f 11 80       	push   $0x80112fc0
80101bfa:	e8 31 3a 00 00       	call   80105630 <initlock>
  for(i = 0; i < NINODE; i++) {
80101bff:	83 c4 10             	add    $0x10,%esp
80101c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101c08:	83 ec 08             	sub    $0x8,%esp
80101c0b:	68 92 87 10 80       	push   $0x80108792
80101c10:	53                   	push   %ebx
80101c11:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101c17:	e8 d4 38 00 00       	call   801054f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101c1c:	83 c4 10             	add    $0x10,%esp
80101c1f:	81 fb ec 4c 11 80    	cmp    $0x80114cec,%ebx
80101c25:	75 e1                	jne    80101c08 <iinit+0x28>
  readsb(dev, &sb);
80101c27:	83 ec 08             	sub    $0x8,%esp
80101c2a:	68 a0 2f 11 80       	push   $0x80112fa0
80101c2f:	ff 75 08             	pushl  0x8(%ebp)
80101c32:	e8 69 ff ff ff       	call   80101ba0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101c37:	ff 35 b8 2f 11 80    	pushl  0x80112fb8
80101c3d:	ff 35 b4 2f 11 80    	pushl  0x80112fb4
80101c43:	ff 35 b0 2f 11 80    	pushl  0x80112fb0
80101c49:	ff 35 ac 2f 11 80    	pushl  0x80112fac
80101c4f:	ff 35 a8 2f 11 80    	pushl  0x80112fa8
80101c55:	ff 35 a4 2f 11 80    	pushl  0x80112fa4
80101c5b:	ff 35 a0 2f 11 80    	pushl  0x80112fa0
80101c61:	68 f8 87 10 80       	push   $0x801087f8
80101c66:	e8 35 eb ff ff       	call   801007a0 <cprintf>
}
80101c6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c6e:	83 c4 30             	add    $0x30,%esp
80101c71:	c9                   	leave  
80101c72:	c3                   	ret    
80101c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <ialloc>:
{
80101c80:	f3 0f 1e fb          	endbr32 
80101c84:	55                   	push   %ebp
80101c85:	89 e5                	mov    %esp,%ebp
80101c87:	57                   	push   %edi
80101c88:	56                   	push   %esi
80101c89:	53                   	push   %ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
80101c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101c90:	83 3d a8 2f 11 80 01 	cmpl   $0x1,0x80112fa8
{
80101c97:	8b 75 08             	mov    0x8(%ebp),%esi
80101c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101c9d:	0f 86 8d 00 00 00    	jbe    80101d30 <ialloc+0xb0>
80101ca3:	bf 01 00 00 00       	mov    $0x1,%edi
80101ca8:	eb 1d                	jmp    80101cc7 <ialloc+0x47>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101cb0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101cb3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101cb6:	53                   	push   %ebx
80101cb7:	e8 34 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101cbc:	83 c4 10             	add    $0x10,%esp
80101cbf:	3b 3d a8 2f 11 80    	cmp    0x80112fa8,%edi
80101cc5:	73 69                	jae    80101d30 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101cc7:	89 f8                	mov    %edi,%eax
80101cc9:	83 ec 08             	sub    $0x8,%esp
80101ccc:	c1 e8 03             	shr    $0x3,%eax
80101ccf:	03 05 b4 2f 11 80    	add    0x80112fb4,%eax
80101cd5:	50                   	push   %eax
80101cd6:	56                   	push   %esi
80101cd7:	e8 f4 e3 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101cdc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101cdf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101ce1:	89 f8                	mov    %edi,%eax
80101ce3:	83 e0 07             	and    $0x7,%eax
80101ce6:	c1 e0 06             	shl    $0x6,%eax
80101ce9:	8d 4c 03 60          	lea    0x60(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101ced:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101cf1:	75 bd                	jne    80101cb0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101cf3:	83 ec 04             	sub    $0x4,%esp
80101cf6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101cf9:	6a 40                	push   $0x40
80101cfb:	6a 00                	push   $0x0
80101cfd:	51                   	push   %ecx
80101cfe:	e8 0d 3c 00 00       	call   80105910 <memset>
      dip->type = type;
80101d03:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101d07:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101d0a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101d0d:	89 1c 24             	mov    %ebx,(%esp)
80101d10:	e8 9b 18 00 00       	call   801035b0 <log_write>
      brelse(bp);
80101d15:	89 1c 24             	mov    %ebx,(%esp)
80101d18:	e8 d3 e4 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101d1d:	83 c4 10             	add    $0x10,%esp
}
80101d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101d23:	89 fa                	mov    %edi,%edx
}
80101d25:	5b                   	pop    %ebx
      return iget(dev, inum);
80101d26:	89 f0                	mov    %esi,%eax
}
80101d28:	5e                   	pop    %esi
80101d29:	5f                   	pop    %edi
80101d2a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101d2b:	e9 b0 fc ff ff       	jmp    801019e0 <iget>
  panic("ialloc: no inodes");
80101d30:	83 ec 0c             	sub    $0xc,%esp
80101d33:	68 98 87 10 80       	push   $0x80108798
80101d38:	e8 53 e6 ff ff       	call   80100390 <panic>
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi

80101d40 <iupdate>:
{
80101d40:	f3 0f 1e fb          	endbr32 
80101d44:	55                   	push   %ebp
80101d45:	89 e5                	mov    %esp,%ebp
80101d47:	56                   	push   %esi
80101d48:	53                   	push   %ebx
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d4c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d4f:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d52:	83 ec 08             	sub    $0x8,%esp
80101d55:	c1 e8 03             	shr    $0x3,%eax
80101d58:	03 05 b4 2f 11 80    	add    0x80112fb4,%eax
80101d5e:	50                   	push   %eax
80101d5f:	ff 73 a0             	pushl  -0x60(%ebx)
80101d62:	e8 69 e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101d67:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d6b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d6e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d70:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101d73:	83 e0 07             	and    $0x7,%eax
80101d76:	c1 e0 06             	shl    $0x6,%eax
80101d79:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
  dip->type = ip->type;
80101d7d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101d80:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d84:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101d87:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101d8b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101d8f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101d93:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101d97:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101d9b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101d9e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101da1:	6a 34                	push   $0x34
80101da3:	53                   	push   %ebx
80101da4:	50                   	push   %eax
80101da5:	e8 06 3c 00 00       	call   801059b0 <memmove>
  log_write(bp);
80101daa:	89 34 24             	mov    %esi,(%esp)
80101dad:	e8 fe 17 00 00       	call   801035b0 <log_write>
  brelse(bp);
80101db2:	89 75 08             	mov    %esi,0x8(%ebp)
80101db5:	83 c4 10             	add    $0x10,%esp
}
80101db8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5d                   	pop    %ebp
  brelse(bp);
80101dbe:	e9 2d e4 ff ff       	jmp    801001f0 <brelse>
80101dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101dd0 <idup>:
{
80101dd0:	f3 0f 1e fb          	endbr32 
80101dd4:	55                   	push   %ebp
80101dd5:	89 e5                	mov    %esp,%ebp
80101dd7:	53                   	push   %ebx
80101dd8:	83 ec 10             	sub    $0x10,%esp
80101ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101dde:	68 c0 2f 11 80       	push   $0x80112fc0
80101de3:	e8 d8 39 00 00       	call   801057c0 <acquire>
  ip->ref++;
80101de8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dec:	c7 04 24 c0 2f 11 80 	movl   $0x80112fc0,(%esp)
80101df3:	e8 b8 3a 00 00       	call   801058b0 <release>
}
80101df8:	89 d8                	mov    %ebx,%eax
80101dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dfd:	c9                   	leave  
80101dfe:	c3                   	ret    
80101dff:	90                   	nop

80101e00 <ilock>:
{
80101e00:	f3 0f 1e fb          	endbr32 
80101e04:	55                   	push   %ebp
80101e05:	89 e5                	mov    %esp,%ebp
80101e07:	56                   	push   %esi
80101e08:	53                   	push   %ebx
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101e0c:	85 db                	test   %ebx,%ebx
80101e0e:	0f 84 b3 00 00 00    	je     80101ec7 <ilock+0xc7>
80101e14:	8b 53 08             	mov    0x8(%ebx),%edx
80101e17:	85 d2                	test   %edx,%edx
80101e19:	0f 8e a8 00 00 00    	jle    80101ec7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
80101e22:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e25:	50                   	push   %eax
80101e26:	e8 05 37 00 00       	call   80105530 <acquiresleep>
  if(ip->valid == 0){
80101e2b:	8b 43 50             	mov    0x50(%ebx),%eax
80101e2e:	83 c4 10             	add    $0x10,%esp
80101e31:	85 c0                	test   %eax,%eax
80101e33:	74 0b                	je     80101e40 <ilock+0x40>
}
80101e35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e38:	5b                   	pop    %ebx
80101e39:	5e                   	pop    %esi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e40:	8b 43 04             	mov    0x4(%ebx),%eax
80101e43:	83 ec 08             	sub    $0x8,%esp
80101e46:	c1 e8 03             	shr    $0x3,%eax
80101e49:	03 05 b4 2f 11 80    	add    0x80112fb4,%eax
80101e4f:	50                   	push   %eax
80101e50:	ff 33                	pushl  (%ebx)
80101e52:	e8 79 e2 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e57:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e5a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e5c:	8b 43 04             	mov    0x4(%ebx),%eax
80101e5f:	83 e0 07             	and    $0x7,%eax
80101e62:	c1 e0 06             	shl    $0x6,%eax
80101e65:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
    ip->type = dip->type;
80101e69:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e6c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101e6f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->major = dip->major;
80101e73:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101e77:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->minor = dip->minor;
80101e7b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101e7f:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->nlink = dip->nlink;
80101e83:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101e87:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
    ip->size = dip->size;
80101e8b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101e8e:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e91:	6a 34                	push   $0x34
80101e93:	50                   	push   %eax
80101e94:	8d 43 60             	lea    0x60(%ebx),%eax
80101e97:	50                   	push   %eax
80101e98:	e8 13 3b 00 00       	call   801059b0 <memmove>
    brelse(bp);
80101e9d:	89 34 24             	mov    %esi,(%esp)
80101ea0:	e8 4b e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
    ip->valid = 1;
80101ead:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
    if(ip->type == 0)
80101eb4:	0f 85 7b ff ff ff    	jne    80101e35 <ilock+0x35>
      panic("ilock: no type");
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	68 b0 87 10 80       	push   $0x801087b0
80101ec2:	e8 c9 e4 ff ff       	call   80100390 <panic>
    panic("ilock");
80101ec7:	83 ec 0c             	sub    $0xc,%esp
80101eca:	68 aa 87 10 80       	push   $0x801087aa
80101ecf:	e8 bc e4 ff ff       	call   80100390 <panic>
80101ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101edf:	90                   	nop

80101ee0 <iunlock>:
{
80101ee0:	f3 0f 1e fb          	endbr32 
80101ee4:	55                   	push   %ebp
80101ee5:	89 e5                	mov    %esp,%ebp
80101ee7:	56                   	push   %esi
80101ee8:	53                   	push   %ebx
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101eec:	85 db                	test   %ebx,%ebx
80101eee:	74 28                	je     80101f18 <iunlock+0x38>
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ef6:	56                   	push   %esi
80101ef7:	e8 d4 36 00 00       	call   801055d0 <holdingsleep>
80101efc:	83 c4 10             	add    $0x10,%esp
80101eff:	85 c0                	test   %eax,%eax
80101f01:	74 15                	je     80101f18 <iunlock+0x38>
80101f03:	8b 43 08             	mov    0x8(%ebx),%eax
80101f06:	85 c0                	test   %eax,%eax
80101f08:	7e 0e                	jle    80101f18 <iunlock+0x38>
  releasesleep(&ip->lock);
80101f0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101f13:	e9 78 36 00 00       	jmp    80105590 <releasesleep>
    panic("iunlock");
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	68 bf 87 10 80       	push   $0x801087bf
80101f20:	e8 6b e4 ff ff       	call   80100390 <panic>
80101f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f30 <iput>:
{
80101f30:	f3 0f 1e fb          	endbr32 
80101f34:	55                   	push   %ebp
80101f35:	89 e5                	mov    %esp,%ebp
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
80101f3a:	83 ec 28             	sub    $0x28,%esp
80101f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101f40:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101f43:	57                   	push   %edi
80101f44:	e8 e7 35 00 00       	call   80105530 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f49:	8b 53 50             	mov    0x50(%ebx),%edx
80101f4c:	83 c4 10             	add    $0x10,%esp
80101f4f:	85 d2                	test   %edx,%edx
80101f51:	74 07                	je     80101f5a <iput+0x2a>
80101f53:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80101f58:	74 36                	je     80101f90 <iput+0x60>
  releasesleep(&ip->lock);
80101f5a:	83 ec 0c             	sub    $0xc,%esp
80101f5d:	57                   	push   %edi
80101f5e:	e8 2d 36 00 00       	call   80105590 <releasesleep>
  acquire(&icache.lock);
80101f63:	c7 04 24 c0 2f 11 80 	movl   $0x80112fc0,(%esp)
80101f6a:	e8 51 38 00 00       	call   801057c0 <acquire>
  ip->ref--;
80101f6f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101f73:	83 c4 10             	add    $0x10,%esp
80101f76:	c7 45 08 c0 2f 11 80 	movl   $0x80112fc0,0x8(%ebp)
}
80101f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
  release(&icache.lock);
80101f84:	e9 27 39 00 00       	jmp    801058b0 <release>
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	68 c0 2f 11 80       	push   $0x80112fc0
80101f98:	e8 23 38 00 00       	call   801057c0 <acquire>
    int r = ip->ref;
80101f9d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101fa0:	c7 04 24 c0 2f 11 80 	movl   $0x80112fc0,(%esp)
80101fa7:	e8 04 39 00 00       	call   801058b0 <release>
    if(r == 1){
80101fac:	83 c4 10             	add    $0x10,%esp
80101faf:	83 fe 01             	cmp    $0x1,%esi
80101fb2:	75 a6                	jne    80101f5a <iput+0x2a>
80101fb4:	8d 8b 90 00 00 00    	lea    0x90(%ebx),%ecx
80101fba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101fbd:	8d 73 60             	lea    0x60(%ebx),%esi
80101fc0:	89 cf                	mov    %ecx,%edi
80101fc2:	eb 0b                	jmp    80101fcf <iput+0x9f>
80101fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101fc8:	83 c6 04             	add    $0x4,%esi
80101fcb:	39 fe                	cmp    %edi,%esi
80101fcd:	74 19                	je     80101fe8 <iput+0xb8>
    if(ip->addrs[i]){
80101fcf:	8b 16                	mov    (%esi),%edx
80101fd1:	85 d2                	test   %edx,%edx
80101fd3:	74 f3                	je     80101fc8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101fd5:	8b 03                	mov    (%ebx),%eax
80101fd7:	e8 74 f8 ff ff       	call   80101850 <bfree>
      ip->addrs[i] = 0;
80101fdc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101fe2:	eb e4                	jmp    80101fc8 <iput+0x98>
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101fe8:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80101fee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ff1:	85 c0                	test   %eax,%eax
80101ff3:	75 33                	jne    80102028 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ff5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ff8:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
80101fff:	53                   	push   %ebx
80102000:	e8 3b fd ff ff       	call   80101d40 <iupdate>
      ip->type = 0;
80102005:	31 c0                	xor    %eax,%eax
80102007:	66 89 43 54          	mov    %ax,0x54(%ebx)
      iupdate(ip);
8010200b:	89 1c 24             	mov    %ebx,(%esp)
8010200e:	e8 2d fd ff ff       	call   80101d40 <iupdate>
      ip->valid = 0;
80102013:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	e9 38 ff ff ff       	jmp    80101f5a <iput+0x2a>
80102022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102028:	83 ec 08             	sub    $0x8,%esp
8010202b:	50                   	push   %eax
8010202c:	ff 33                	pushl  (%ebx)
8010202e:	e8 9d e0 ff ff       	call   801000d0 <bread>
80102033:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102036:	83 c4 10             	add    $0x10,%esp
80102039:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
8010203f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102042:	8d 70 60             	lea    0x60(%eax),%esi
80102045:	89 cf                	mov    %ecx,%edi
80102047:	eb 0e                	jmp    80102057 <iput+0x127>
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102050:	83 c6 04             	add    $0x4,%esi
80102053:	39 f7                	cmp    %esi,%edi
80102055:	74 19                	je     80102070 <iput+0x140>
      if(a[j])
80102057:	8b 16                	mov    (%esi),%edx
80102059:	85 d2                	test   %edx,%edx
8010205b:	74 f3                	je     80102050 <iput+0x120>
        bfree(ip->dev, a[j]);
8010205d:	8b 03                	mov    (%ebx),%eax
8010205f:	e8 ec f7 ff ff       	call   80101850 <bfree>
80102064:	eb ea                	jmp    80102050 <iput+0x120>
80102066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102070:	83 ec 0c             	sub    $0xc,%esp
80102073:	ff 75 e4             	pushl  -0x1c(%ebp)
80102076:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102079:	e8 72 e1 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010207e:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
80102084:	8b 03                	mov    (%ebx),%eax
80102086:	e8 c5 f7 ff ff       	call   80101850 <bfree>
    ip->addrs[NDIRECT] = 0;
8010208b:	83 c4 10             	add    $0x10,%esp
8010208e:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80102095:	00 00 00 
80102098:	e9 58 ff ff ff       	jmp    80101ff5 <iput+0xc5>
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <iunlockput>:
{
801020a0:	f3 0f 1e fb          	endbr32 
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	53                   	push   %ebx
801020a8:	83 ec 10             	sub    $0x10,%esp
801020ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801020ae:	53                   	push   %ebx
801020af:	e8 2c fe ff ff       	call   80101ee0 <iunlock>
  iput(ip);
801020b4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801020b7:	83 c4 10             	add    $0x10,%esp
}
801020ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020bd:	c9                   	leave  
  iput(ip);
801020be:	e9 6d fe ff ff       	jmp    80101f30 <iput>
801020c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801020d0:	f3 0f 1e fb          	endbr32 
801020d4:	55                   	push   %ebp
801020d5:	89 e5                	mov    %esp,%ebp
801020d7:	8b 55 08             	mov    0x8(%ebp),%edx
801020da:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801020dd:	8b 0a                	mov    (%edx),%ecx
801020df:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801020e2:	8b 4a 04             	mov    0x4(%edx),%ecx
801020e5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801020e8:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
801020ec:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801020ef:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
801020f3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801020f7:	8b 52 5c             	mov    0x5c(%edx),%edx
801020fa:	89 50 10             	mov    %edx,0x10(%eax)
}
801020fd:	5d                   	pop    %ebp
801020fe:	c3                   	ret    
801020ff:	90                   	nop

80102100 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
80102109:	53                   	push   %ebx
8010210a:	83 ec 1c             	sub    $0x1c,%esp
8010210d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102110:	8b 45 08             	mov    0x8(%ebp),%eax
80102113:	8b 75 10             	mov    0x10(%ebp),%esi
80102116:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102119:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010211c:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80102121:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102124:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102127:	0f 84 a3 00 00 00    	je     801021d0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010212d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102130:	8b 40 5c             	mov    0x5c(%eax),%eax
80102133:	39 c6                	cmp    %eax,%esi
80102135:	0f 87 b6 00 00 00    	ja     801021f1 <readi+0xf1>
8010213b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010213e:	31 c9                	xor    %ecx,%ecx
80102140:	89 da                	mov    %ebx,%edx
80102142:	01 f2                	add    %esi,%edx
80102144:	0f 92 c1             	setb   %cl
80102147:	89 cf                	mov    %ecx,%edi
80102149:	0f 82 a2 00 00 00    	jb     801021f1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010214f:	89 c1                	mov    %eax,%ecx
80102151:	29 f1                	sub    %esi,%ecx
80102153:	39 d0                	cmp    %edx,%eax
80102155:	0f 43 cb             	cmovae %ebx,%ecx
80102158:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010215b:	85 c9                	test   %ecx,%ecx
8010215d:	74 63                	je     801021c2 <readi+0xc2>
8010215f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102160:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102163:	89 f2                	mov    %esi,%edx
80102165:	c1 ea 09             	shr    $0x9,%edx
80102168:	89 d8                	mov    %ebx,%eax
8010216a:	e8 61 f9 ff ff       	call   80101ad0 <bmap>
8010216f:	83 ec 08             	sub    $0x8,%esp
80102172:	50                   	push   %eax
80102173:	ff 33                	pushl  (%ebx)
80102175:	e8 56 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010217a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010217d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102182:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102185:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102187:	89 f0                	mov    %esi,%eax
80102189:	25 ff 01 00 00       	and    $0x1ff,%eax
8010218e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102190:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102193:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102195:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102199:	39 d9                	cmp    %ebx,%ecx
8010219b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010219e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010219f:	01 df                	add    %ebx,%edi
801021a1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801021a3:	50                   	push   %eax
801021a4:	ff 75 e0             	pushl  -0x20(%ebp)
801021a7:	e8 04 38 00 00       	call   801059b0 <memmove>
    brelse(bp);
801021ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
801021af:	89 14 24             	mov    %edx,(%esp)
801021b2:	e8 39 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021b7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801021ba:	83 c4 10             	add    $0x10,%esp
801021bd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801021c0:	77 9e                	ja     80102160 <readi+0x60>
  }
  return n;
801021c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801021c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c8:	5b                   	pop    %ebx
801021c9:	5e                   	pop    %esi
801021ca:	5f                   	pop    %edi
801021cb:	5d                   	pop    %ebp
801021cc:	c3                   	ret    
801021cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801021d0:	0f bf 40 56          	movswl 0x56(%eax),%eax
801021d4:	66 83 f8 09          	cmp    $0x9,%ax
801021d8:	77 17                	ja     801021f1 <readi+0xf1>
801021da:	8b 04 c5 40 2f 11 80 	mov    -0x7feed0c0(,%eax,8),%eax
801021e1:	85 c0                	test   %eax,%eax
801021e3:	74 0c                	je     801021f1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801021e5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021eb:	5b                   	pop    %ebx
801021ec:	5e                   	pop    %esi
801021ed:	5f                   	pop    %edi
801021ee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801021ef:	ff e0                	jmp    *%eax
      return -1;
801021f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021f6:	eb cd                	jmp    801021c5 <readi+0xc5>
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	57                   	push   %edi
80102208:	56                   	push   %esi
80102209:	53                   	push   %ebx
8010220a:	83 ec 1c             	sub    $0x1c,%esp
8010220d:	8b 45 08             	mov    0x8(%ebp),%eax
80102210:	8b 75 0c             	mov    0xc(%ebp),%esi
80102213:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102216:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
8010221b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010221e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102221:	8b 75 10             	mov    0x10(%ebp),%esi
80102224:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102227:	0f 84 b3 00 00 00    	je     801022e0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010222d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102230:	39 70 5c             	cmp    %esi,0x5c(%eax)
80102233:	0f 82 e3 00 00 00    	jb     8010231c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102239:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010223c:	89 f8                	mov    %edi,%eax
8010223e:	01 f0                	add    %esi,%eax
80102240:	0f 82 d6 00 00 00    	jb     8010231c <writei+0x11c>
80102246:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010224b:	0f 87 cb 00 00 00    	ja     8010231c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102251:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102258:	85 ff                	test   %edi,%edi
8010225a:	74 75                	je     801022d1 <writei+0xd1>
8010225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102260:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102263:	89 f2                	mov    %esi,%edx
80102265:	c1 ea 09             	shr    $0x9,%edx
80102268:	89 f8                	mov    %edi,%eax
8010226a:	e8 61 f8 ff ff       	call   80101ad0 <bmap>
8010226f:	83 ec 08             	sub    $0x8,%esp
80102272:	50                   	push   %eax
80102273:	ff 37                	pushl  (%edi)
80102275:	e8 56 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010227a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010227f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102282:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102285:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102287:	89 f0                	mov    %esi,%eax
80102289:	83 c4 0c             	add    $0xc,%esp
8010228c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102291:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102293:	8d 44 07 60          	lea    0x60(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102297:	39 d9                	cmp    %ebx,%ecx
80102299:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010229c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010229d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010229f:	ff 75 dc             	pushl  -0x24(%ebp)
801022a2:	50                   	push   %eax
801022a3:	e8 08 37 00 00       	call   801059b0 <memmove>
    log_write(bp);
801022a8:	89 3c 24             	mov    %edi,(%esp)
801022ab:	e8 00 13 00 00       	call   801035b0 <log_write>
    brelse(bp);
801022b0:	89 3c 24             	mov    %edi,(%esp)
801022b3:	e8 38 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022b8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801022bb:	83 c4 10             	add    $0x10,%esp
801022be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022c1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801022c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801022c7:	77 97                	ja     80102260 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801022c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801022cc:	3b 70 5c             	cmp    0x5c(%eax),%esi
801022cf:	77 37                	ja     80102308 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801022d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801022d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d7:	5b                   	pop    %ebx
801022d8:	5e                   	pop    %esi
801022d9:	5f                   	pop    %edi
801022da:	5d                   	pop    %ebp
801022db:	c3                   	ret    
801022dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801022e0:	0f bf 40 56          	movswl 0x56(%eax),%eax
801022e4:	66 83 f8 09          	cmp    $0x9,%ax
801022e8:	77 32                	ja     8010231c <writei+0x11c>
801022ea:	8b 04 c5 44 2f 11 80 	mov    -0x7feed0bc(,%eax,8),%eax
801022f1:	85 c0                	test   %eax,%eax
801022f3:	74 27                	je     8010231c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801022f5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801022f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022fb:	5b                   	pop    %ebx
801022fc:	5e                   	pop    %esi
801022fd:	5f                   	pop    %edi
801022fe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801022ff:	ff e0                	jmp    *%eax
80102301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102308:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010230b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010230e:	89 70 5c             	mov    %esi,0x5c(%eax)
    iupdate(ip);
80102311:	50                   	push   %eax
80102312:	e8 29 fa ff ff       	call   80101d40 <iupdate>
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	eb b5                	jmp    801022d1 <writei+0xd1>
      return -1;
8010231c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102321:	eb b1                	jmp    801022d4 <writei+0xd4>
80102323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102330 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102330:	f3 0f 1e fb          	endbr32 
80102334:	55                   	push   %ebp
80102335:	89 e5                	mov    %esp,%ebp
80102337:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010233a:	6a 0e                	push   $0xe
8010233c:	ff 75 0c             	pushl  0xc(%ebp)
8010233f:	ff 75 08             	pushl  0x8(%ebp)
80102342:	e8 d9 36 00 00       	call   80105a20 <strncmp>
}
80102347:	c9                   	leave  
80102348:	c3                   	ret    
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102350 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102350:	f3 0f 1e fb          	endbr32 
80102354:	55                   	push   %ebp
80102355:	89 e5                	mov    %esp,%ebp
80102357:	57                   	push   %edi
80102358:	56                   	push   %esi
80102359:	53                   	push   %ebx
8010235a:	83 ec 1c             	sub    $0x1c,%esp
8010235d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102360:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80102365:	0f 85 89 00 00 00    	jne    801023f4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010236b:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010236e:	31 ff                	xor    %edi,%edi
80102370:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102373:	85 d2                	test   %edx,%edx
80102375:	74 42                	je     801023b9 <dirlookup+0x69>
80102377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010237e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102380:	6a 10                	push   $0x10
80102382:	57                   	push   %edi
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	e8 76 fd ff ff       	call   80102100 <readi>
8010238a:	83 c4 10             	add    $0x10,%esp
8010238d:	83 f8 10             	cmp    $0x10,%eax
80102390:	75 55                	jne    801023e7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102392:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102397:	74 18                	je     801023b1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102399:	83 ec 04             	sub    $0x4,%esp
8010239c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010239f:	6a 0e                	push   $0xe
801023a1:	50                   	push   %eax
801023a2:	ff 75 0c             	pushl  0xc(%ebp)
801023a5:	e8 76 36 00 00       	call   80105a20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801023aa:	83 c4 10             	add    $0x10,%esp
801023ad:	85 c0                	test   %eax,%eax
801023af:	74 17                	je     801023c8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023b1:	83 c7 10             	add    $0x10,%edi
801023b4:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
801023b7:	72 c7                	jb     80102380 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801023b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801023bc:	31 c0                	xor    %eax,%eax
}
801023be:	5b                   	pop    %ebx
801023bf:	5e                   	pop    %esi
801023c0:	5f                   	pop    %edi
801023c1:	5d                   	pop    %ebp
801023c2:	c3                   	ret    
801023c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c7:	90                   	nop
      if(poff)
801023c8:	8b 45 10             	mov    0x10(%ebp),%eax
801023cb:	85 c0                	test   %eax,%eax
801023cd:	74 05                	je     801023d4 <dirlookup+0x84>
        *poff = off;
801023cf:	8b 45 10             	mov    0x10(%ebp),%eax
801023d2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801023d4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801023d8:	8b 03                	mov    (%ebx),%eax
801023da:	e8 01 f6 ff ff       	call   801019e0 <iget>
}
801023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e2:	5b                   	pop    %ebx
801023e3:	5e                   	pop    %esi
801023e4:	5f                   	pop    %edi
801023e5:	5d                   	pop    %ebp
801023e6:	c3                   	ret    
      panic("dirlookup read");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 d9 87 10 80       	push   $0x801087d9
801023ef:	e8 9c df ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 c7 87 10 80       	push   $0x801087c7
801023fc:	e8 8f df ff ff       	call   80100390 <panic>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop

80102410 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	89 c3                	mov    %eax,%ebx
80102418:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010241b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010241e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102421:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102424:	0f 84 86 01 00 00    	je     801025b0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010242a:	e8 f1 1c 00 00       	call   80104120 <myproc>
  acquire(&icache.lock);
8010242f:	83 ec 0c             	sub    $0xc,%esp
80102432:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102434:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102437:	68 c0 2f 11 80       	push   $0x80112fc0
8010243c:	e8 7f 33 00 00       	call   801057c0 <acquire>
  ip->ref++;
80102441:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102445:	c7 04 24 c0 2f 11 80 	movl   $0x80112fc0,(%esp)
8010244c:	e8 5f 34 00 00       	call   801058b0 <release>
80102451:	83 c4 10             	add    $0x10,%esp
80102454:	eb 0d                	jmp    80102463 <namex+0x53>
80102456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102460:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102463:	0f b6 07             	movzbl (%edi),%eax
80102466:	3c 2f                	cmp    $0x2f,%al
80102468:	74 f6                	je     80102460 <namex+0x50>
  if(*path == 0)
8010246a:	84 c0                	test   %al,%al
8010246c:	0f 84 ee 00 00 00    	je     80102560 <namex+0x150>
  while(*path != '/' && *path != 0)
80102472:	0f b6 07             	movzbl (%edi),%eax
80102475:	84 c0                	test   %al,%al
80102477:	0f 84 fb 00 00 00    	je     80102578 <namex+0x168>
8010247d:	89 fb                	mov    %edi,%ebx
8010247f:	3c 2f                	cmp    $0x2f,%al
80102481:	0f 84 f1 00 00 00    	je     80102578 <namex+0x168>
80102487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248e:	66 90                	xchg   %ax,%ax
80102490:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102494:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102497:	3c 2f                	cmp    $0x2f,%al
80102499:	74 04                	je     8010249f <namex+0x8f>
8010249b:	84 c0                	test   %al,%al
8010249d:	75 f1                	jne    80102490 <namex+0x80>
  len = path - s;
8010249f:	89 d8                	mov    %ebx,%eax
801024a1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801024a3:	83 f8 0d             	cmp    $0xd,%eax
801024a6:	0f 8e 84 00 00 00    	jle    80102530 <namex+0x120>
    memmove(name, s, DIRSIZ);
801024ac:	83 ec 04             	sub    $0x4,%esp
801024af:	6a 0e                	push   $0xe
801024b1:	57                   	push   %edi
    path++;
801024b2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801024b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801024b7:	e8 f4 34 00 00       	call   801059b0 <memmove>
801024bc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801024bf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801024c2:	75 0c                	jne    801024d0 <namex+0xc0>
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801024c8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801024cb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801024ce:	74 f8                	je     801024c8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	56                   	push   %esi
801024d4:	e8 27 f9 ff ff       	call   80101e00 <ilock>
    if(ip->type != T_DIR){
801024d9:	83 c4 10             	add    $0x10,%esp
801024dc:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
801024e1:	0f 85 a1 00 00 00    	jne    80102588 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801024e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801024ea:	85 d2                	test   %edx,%edx
801024ec:	74 09                	je     801024f7 <namex+0xe7>
801024ee:	80 3f 00             	cmpb   $0x0,(%edi)
801024f1:	0f 84 d9 00 00 00    	je     801025d0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	6a 00                	push   $0x0
801024fc:	ff 75 e4             	pushl  -0x1c(%ebp)
801024ff:	56                   	push   %esi
80102500:	e8 4b fe ff ff       	call   80102350 <dirlookup>
80102505:	83 c4 10             	add    $0x10,%esp
80102508:	89 c3                	mov    %eax,%ebx
8010250a:	85 c0                	test   %eax,%eax
8010250c:	74 7a                	je     80102588 <namex+0x178>
  iunlock(ip);
8010250e:	83 ec 0c             	sub    $0xc,%esp
80102511:	56                   	push   %esi
80102512:	e8 c9 f9 ff ff       	call   80101ee0 <iunlock>
  iput(ip);
80102517:	89 34 24             	mov    %esi,(%esp)
8010251a:	89 de                	mov    %ebx,%esi
8010251c:	e8 0f fa ff ff       	call   80101f30 <iput>
80102521:	83 c4 10             	add    $0x10,%esp
80102524:	e9 3a ff ff ff       	jmp    80102463 <namex+0x53>
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102533:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102536:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102539:	83 ec 04             	sub    $0x4,%esp
8010253c:	50                   	push   %eax
8010253d:	57                   	push   %edi
    name[len] = 0;
8010253e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102540:	ff 75 e4             	pushl  -0x1c(%ebp)
80102543:	e8 68 34 00 00       	call   801059b0 <memmove>
    name[len] = 0;
80102548:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010254b:	83 c4 10             	add    $0x10,%esp
8010254e:	c6 00 00             	movb   $0x0,(%eax)
80102551:	e9 69 ff ff ff       	jmp    801024bf <namex+0xaf>
80102556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102560:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102563:	85 c0                	test   %eax,%eax
80102565:	0f 85 85 00 00 00    	jne    801025f0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010256b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010256e:	89 f0                	mov    %esi,%eax
80102570:	5b                   	pop    %ebx
80102571:	5e                   	pop    %esi
80102572:	5f                   	pop    %edi
80102573:	5d                   	pop    %ebp
80102574:	c3                   	ret    
80102575:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010257b:	89 fb                	mov    %edi,%ebx
8010257d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102580:	31 c0                	xor    %eax,%eax
80102582:	eb b5                	jmp    80102539 <namex+0x129>
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	56                   	push   %esi
8010258c:	e8 4f f9 ff ff       	call   80101ee0 <iunlock>
  iput(ip);
80102591:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102594:	31 f6                	xor    %esi,%esi
  iput(ip);
80102596:	e8 95 f9 ff ff       	call   80101f30 <iput>
      return 0;
8010259b:	83 c4 10             	add    $0x10,%esp
}
8010259e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a1:	89 f0                	mov    %esi,%eax
801025a3:	5b                   	pop    %ebx
801025a4:	5e                   	pop    %esi
801025a5:	5f                   	pop    %edi
801025a6:	5d                   	pop    %ebp
801025a7:	c3                   	ret    
801025a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801025b0:	ba 01 00 00 00       	mov    $0x1,%edx
801025b5:	b8 01 00 00 00       	mov    $0x1,%eax
801025ba:	89 df                	mov    %ebx,%edi
801025bc:	e8 1f f4 ff ff       	call   801019e0 <iget>
801025c1:	89 c6                	mov    %eax,%esi
801025c3:	e9 9b fe ff ff       	jmp    80102463 <namex+0x53>
801025c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop
      iunlock(ip);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	56                   	push   %esi
801025d4:	e8 07 f9 ff ff       	call   80101ee0 <iunlock>
      return ip;
801025d9:	83 c4 10             	add    $0x10,%esp
}
801025dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025df:	89 f0                	mov    %esi,%eax
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5f                   	pop    %edi
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801025f0:	83 ec 0c             	sub    $0xc,%esp
801025f3:	56                   	push   %esi
    return 0;
801025f4:	31 f6                	xor    %esi,%esi
    iput(ip);
801025f6:	e8 35 f9 ff ff       	call   80101f30 <iput>
    return 0;
801025fb:	83 c4 10             	add    $0x10,%esp
801025fe:	e9 68 ff ff ff       	jmp    8010256b <namex+0x15b>
80102603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102610 <dirlink>:
{
80102610:	f3 0f 1e fb          	endbr32 
80102614:	55                   	push   %ebp
80102615:	89 e5                	mov    %esp,%ebp
80102617:	57                   	push   %edi
80102618:	56                   	push   %esi
80102619:	53                   	push   %ebx
8010261a:	83 ec 20             	sub    $0x20,%esp
8010261d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102620:	6a 00                	push   $0x0
80102622:	ff 75 0c             	pushl  0xc(%ebp)
80102625:	53                   	push   %ebx
80102626:	e8 25 fd ff ff       	call   80102350 <dirlookup>
8010262b:	83 c4 10             	add    $0x10,%esp
8010262e:	85 c0                	test   %eax,%eax
80102630:	75 6b                	jne    8010269d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102632:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80102635:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102638:	85 ff                	test   %edi,%edi
8010263a:	74 2d                	je     80102669 <dirlink+0x59>
8010263c:	31 ff                	xor    %edi,%edi
8010263e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102641:	eb 0d                	jmp    80102650 <dirlink+0x40>
80102643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102647:	90                   	nop
80102648:	83 c7 10             	add    $0x10,%edi
8010264b:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
8010264e:	73 19                	jae    80102669 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102650:	6a 10                	push   $0x10
80102652:	57                   	push   %edi
80102653:	56                   	push   %esi
80102654:	53                   	push   %ebx
80102655:	e8 a6 fa ff ff       	call   80102100 <readi>
8010265a:	83 c4 10             	add    $0x10,%esp
8010265d:	83 f8 10             	cmp    $0x10,%eax
80102660:	75 4e                	jne    801026b0 <dirlink+0xa0>
    if(de.inum == 0)
80102662:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102667:	75 df                	jne    80102648 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102669:	83 ec 04             	sub    $0x4,%esp
8010266c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010266f:	6a 0e                	push   $0xe
80102671:	ff 75 0c             	pushl  0xc(%ebp)
80102674:	50                   	push   %eax
80102675:	e8 f6 33 00 00       	call   80105a70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010267a:	6a 10                	push   $0x10
  de.inum = inum;
8010267c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010267f:	57                   	push   %edi
80102680:	56                   	push   %esi
80102681:	53                   	push   %ebx
  de.inum = inum;
80102682:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102686:	e8 75 fb ff ff       	call   80102200 <writei>
8010268b:	83 c4 20             	add    $0x20,%esp
8010268e:	83 f8 10             	cmp    $0x10,%eax
80102691:	75 2a                	jne    801026bd <dirlink+0xad>
  return 0;
80102693:	31 c0                	xor    %eax,%eax
}
80102695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102698:	5b                   	pop    %ebx
80102699:	5e                   	pop    %esi
8010269a:	5f                   	pop    %edi
8010269b:	5d                   	pop    %ebp
8010269c:	c3                   	ret    
    iput(ip);
8010269d:	83 ec 0c             	sub    $0xc,%esp
801026a0:	50                   	push   %eax
801026a1:	e8 8a f8 ff ff       	call   80101f30 <iput>
    return -1;
801026a6:	83 c4 10             	add    $0x10,%esp
801026a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026ae:	eb e5                	jmp    80102695 <dirlink+0x85>
      panic("dirlink read");
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 e8 87 10 80       	push   $0x801087e8
801026b8:	e8 d3 dc ff ff       	call   80100390 <panic>
    panic("dirlink");
801026bd:	83 ec 0c             	sub    $0xc,%esp
801026c0:	68 6e 8f 10 80       	push   $0x80108f6e
801026c5:	e8 c6 dc ff ff       	call   80100390 <panic>
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026d0 <namei>:

struct inode*
namei(char *path)
{
801026d0:	f3 0f 1e fb          	endbr32 
801026d4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026d5:	31 d2                	xor    %edx,%edx
{
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801026dc:	8b 45 08             	mov    0x8(%ebp),%eax
801026df:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801026e2:	e8 29 fd ff ff       	call   80102410 <namex>
}
801026e7:	c9                   	leave  
801026e8:	c3                   	ret    
801026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026f0:	f3 0f 1e fb          	endbr32 
801026f4:	55                   	push   %ebp
  return namex(path, 1, name);
801026f5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801026fa:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801026fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102702:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102703:	e9 08 fd ff ff       	jmp    80102410 <namex>
80102708:	66 90                	xchg   %ax,%ax
8010270a:	66 90                	xchg   %ax,%ax
8010270c:	66 90                	xchg   %ax,%ax
8010270e:	66 90                	xchg   %ax,%ax

80102710 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	57                   	push   %edi
80102714:	56                   	push   %esi
80102715:	53                   	push   %ebx
80102716:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102719:	85 c0                	test   %eax,%eax
8010271b:	0f 84 b4 00 00 00    	je     801027d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102721:	8b 70 08             	mov    0x8(%eax),%esi
80102724:	89 c3                	mov    %eax,%ebx
80102726:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010272c:	0f 87 96 00 00 00    	ja     801027c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102732:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273e:	66 90                	xchg   %ax,%ax
80102740:	89 ca                	mov    %ecx,%edx
80102742:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102743:	83 e0 c0             	and    $0xffffffc0,%eax
80102746:	3c 40                	cmp    $0x40,%al
80102748:	75 f6                	jne    80102740 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010274a:	31 ff                	xor    %edi,%edi
8010274c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102751:	89 f8                	mov    %edi,%eax
80102753:	ee                   	out    %al,(%dx)
80102754:	b8 01 00 00 00       	mov    $0x1,%eax
80102759:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010275e:	ee                   	out    %al,(%dx)
8010275f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102764:	89 f0                	mov    %esi,%eax
80102766:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102767:	89 f0                	mov    %esi,%eax
80102769:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010276e:	c1 f8 08             	sar    $0x8,%eax
80102771:	ee                   	out    %al,(%dx)
80102772:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102777:	89 f8                	mov    %edi,%eax
80102779:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010277a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010277e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102783:	c1 e0 04             	shl    $0x4,%eax
80102786:	83 e0 10             	and    $0x10,%eax
80102789:	83 c8 e0             	or     $0xffffffe0,%eax
8010278c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010278d:	f6 03 04             	testb  $0x4,(%ebx)
80102790:	75 16                	jne    801027a8 <idestart+0x98>
80102792:	b8 20 00 00 00       	mov    $0x20,%eax
80102797:	89 ca                	mov    %ecx,%edx
80102799:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010279a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010279d:	5b                   	pop    %ebx
8010279e:	5e                   	pop    %esi
8010279f:	5f                   	pop    %edi
801027a0:	5d                   	pop    %ebp
801027a1:	c3                   	ret    
801027a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027a8:	b8 30 00 00 00       	mov    $0x30,%eax
801027ad:	89 ca                	mov    %ecx,%edx
801027af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801027b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801027b5:	8d 73 60             	lea    0x60(%ebx),%esi
801027b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027bd:	fc                   	cld    
801027be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801027c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027c3:	5b                   	pop    %ebx
801027c4:	5e                   	pop    %esi
801027c5:	5f                   	pop    %edi
801027c6:	5d                   	pop    %ebp
801027c7:	c3                   	ret    
    panic("incorrect blockno");
801027c8:	83 ec 0c             	sub    $0xc,%esp
801027cb:	68 54 88 10 80       	push   $0x80108854
801027d0:	e8 bb db ff ff       	call   80100390 <panic>
    panic("idestart");
801027d5:	83 ec 0c             	sub    $0xc,%esp
801027d8:	68 4b 88 10 80       	push   $0x8010884b
801027dd:	e8 ae db ff ff       	call   80100390 <panic>
801027e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027f0 <ideinit>:
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801027fa:	68 66 88 10 80       	push   $0x80108866
801027ff:	68 c0 c5 10 80       	push   $0x8010c5c0
80102804:	e8 27 2e 00 00       	call   80105630 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102809:	58                   	pop    %eax
8010280a:	a1 e0 53 11 80       	mov    0x801153e0,%eax
8010280f:	5a                   	pop    %edx
80102810:	83 e8 01             	sub    $0x1,%eax
80102813:	50                   	push   %eax
80102814:	6a 0e                	push   $0xe
80102816:	e8 b5 02 00 00       	call   80102ad0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010281b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102827:	90                   	nop
80102828:	ec                   	in     (%dx),%al
80102829:	83 e0 c0             	and    $0xffffffc0,%eax
8010282c:	3c 40                	cmp    $0x40,%al
8010282e:	75 f8                	jne    80102828 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102830:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102835:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010283a:	ee                   	out    %al,(%dx)
8010283b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102840:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102845:	eb 0e                	jmp    80102855 <ideinit+0x65>
80102847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102850:	83 e9 01             	sub    $0x1,%ecx
80102853:	74 0f                	je     80102864 <ideinit+0x74>
80102855:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102856:	84 c0                	test   %al,%al
80102858:	74 f6                	je     80102850 <ideinit+0x60>
      havedisk1 = 1;
8010285a:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
80102861:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102869:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010286e:	ee                   	out    %al,(%dx)
}
8010286f:	c9                   	leave  
80102870:	c3                   	ret    
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop

80102880 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102880:	f3 0f 1e fb          	endbr32 
80102884:	55                   	push   %ebp
80102885:	89 e5                	mov    %esp,%ebp
80102887:	57                   	push   %edi
80102888:	56                   	push   %esi
80102889:	53                   	push   %ebx
8010288a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010288d:	68 c0 c5 10 80       	push   $0x8010c5c0
80102892:	e8 29 2f 00 00       	call   801057c0 <acquire>

  if((b = idequeue) == 0){
80102897:	8b 1d a4 c5 10 80    	mov    0x8010c5a4,%ebx
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	85 db                	test   %ebx,%ebx
801028a2:	74 5f                	je     80102903 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801028a4:	8b 43 5c             	mov    0x5c(%ebx),%eax
801028a7:	a3 a4 c5 10 80       	mov    %eax,0x8010c5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ac:	8b 33                	mov    (%ebx),%esi
801028ae:	f7 c6 04 00 00 00    	test   $0x4,%esi
801028b4:	75 2b                	jne    801028e1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
801028c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028c1:	89 c1                	mov    %eax,%ecx
801028c3:	83 e1 c0             	and    $0xffffffc0,%ecx
801028c6:	80 f9 40             	cmp    $0x40,%cl
801028c9:	75 f5                	jne    801028c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028cb:	a8 21                	test   $0x21,%al
801028cd:	75 12                	jne    801028e1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801028cf:	8d 7b 60             	lea    0x60(%ebx),%edi
  asm volatile("cld; rep insl" :
801028d2:	b9 80 00 00 00       	mov    $0x80,%ecx
801028d7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801028dc:	fc                   	cld    
801028dd:	f3 6d                	rep insl (%dx),%es:(%edi)
801028df:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801028e1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801028e4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801028e7:	83 ce 02             	or     $0x2,%esi
801028ea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801028ec:	53                   	push   %ebx
801028ed:	e8 de 21 00 00       	call   80104ad0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028f2:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
801028f7:	83 c4 10             	add    $0x10,%esp
801028fa:	85 c0                	test   %eax,%eax
801028fc:	74 05                	je     80102903 <ideintr+0x83>
    idestart(idequeue);
801028fe:	e8 0d fe ff ff       	call   80102710 <idestart>
    release(&idelock);
80102903:	83 ec 0c             	sub    $0xc,%esp
80102906:	68 c0 c5 10 80       	push   $0x8010c5c0
8010290b:	e8 a0 2f 00 00       	call   801058b0 <release>

  release(&idelock);
}
80102910:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102913:	5b                   	pop    %ebx
80102914:	5e                   	pop    %esi
80102915:	5f                   	pop    %edi
80102916:	5d                   	pop    %ebp
80102917:	c3                   	ret    
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	53                   	push   %ebx
80102928:	83 ec 10             	sub    $0x10,%esp
8010292b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010292e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102931:	50                   	push   %eax
80102932:	e8 99 2c 00 00       	call   801055d0 <holdingsleep>
80102937:	83 c4 10             	add    $0x10,%esp
8010293a:	85 c0                	test   %eax,%eax
8010293c:	0f 84 cf 00 00 00    	je     80102a11 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102942:	8b 03                	mov    (%ebx),%eax
80102944:	83 e0 06             	and    $0x6,%eax
80102947:	83 f8 02             	cmp    $0x2,%eax
8010294a:	0f 84 b4 00 00 00    	je     80102a04 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102950:	8b 53 04             	mov    0x4(%ebx),%edx
80102953:	85 d2                	test   %edx,%edx
80102955:	74 0d                	je     80102964 <iderw+0x44>
80102957:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
8010295c:	85 c0                	test   %eax,%eax
8010295e:	0f 84 93 00 00 00    	je     801029f7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102964:	83 ec 0c             	sub    $0xc,%esp
80102967:	68 c0 c5 10 80       	push   $0x8010c5c0
8010296c:	e8 4f 2e 00 00       	call   801057c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102971:	a1 a4 c5 10 80       	mov    0x8010c5a4,%eax
  b->qnext = 0;
80102976:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010297d:	83 c4 10             	add    $0x10,%esp
80102980:	85 c0                	test   %eax,%eax
80102982:	74 6c                	je     801029f0 <iderw+0xd0>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102988:	89 c2                	mov    %eax,%edx
8010298a:	8b 40 5c             	mov    0x5c(%eax),%eax
8010298d:	85 c0                	test   %eax,%eax
8010298f:	75 f7                	jne    80102988 <iderw+0x68>
80102991:	83 c2 5c             	add    $0x5c,%edx
    ;
  *pp = b;
80102994:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102996:	39 1d a4 c5 10 80    	cmp    %ebx,0x8010c5a4
8010299c:	74 42                	je     801029e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010299e:	8b 03                	mov    (%ebx),%eax
801029a0:	83 e0 06             	and    $0x6,%eax
801029a3:	83 f8 02             	cmp    $0x2,%eax
801029a6:	74 23                	je     801029cb <iderw+0xab>
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop
    sleep(b, &idelock);
801029b0:	83 ec 08             	sub    $0x8,%esp
801029b3:	68 c0 c5 10 80       	push   $0x8010c5c0
801029b8:	53                   	push   %ebx
801029b9:	e8 52 1f 00 00       	call   80104910 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029be:	8b 03                	mov    (%ebx),%eax
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	83 e0 06             	and    $0x6,%eax
801029c6:	83 f8 02             	cmp    $0x2,%eax
801029c9:	75 e5                	jne    801029b0 <iderw+0x90>
  }


  release(&idelock);
801029cb:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
801029d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d5:	c9                   	leave  
  release(&idelock);
801029d6:	e9 d5 2e 00 00       	jmp    801058b0 <release>
801029db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029df:	90                   	nop
    idestart(b);
801029e0:	89 d8                	mov    %ebx,%eax
801029e2:	e8 29 fd ff ff       	call   80102710 <idestart>
801029e7:	eb b5                	jmp    8010299e <iderw+0x7e>
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029f0:	ba a4 c5 10 80       	mov    $0x8010c5a4,%edx
801029f5:	eb 9d                	jmp    80102994 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801029f7:	83 ec 0c             	sub    $0xc,%esp
801029fa:	68 95 88 10 80       	push   $0x80108895
801029ff:	e8 8c d9 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102a04:	83 ec 0c             	sub    $0xc,%esp
80102a07:	68 80 88 10 80       	push   $0x80108880
80102a0c:	e8 7f d9 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102a11:	83 ec 0c             	sub    $0xc,%esp
80102a14:	68 6a 88 10 80       	push   $0x8010886a
80102a19:	e8 72 d9 ff ff       	call   80100390 <panic>
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a20:	f3 0f 1e fb          	endbr32 
80102a24:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a25:	c7 05 e0 4c 11 80 00 	movl   $0xfec00000,0x80114ce0
80102a2c:	00 c0 fe 
{
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	56                   	push   %esi
80102a32:	53                   	push   %ebx
  ioapic->reg = reg;
80102a33:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a3a:	00 00 00 
  return ioapic->data;
80102a3d:	8b 15 e0 4c 11 80    	mov    0x80114ce0,%edx
80102a43:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102a46:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102a4c:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a52:	0f b6 15 40 4e 11 80 	movzbl 0x80114e40,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a59:	c1 ee 10             	shr    $0x10,%esi
80102a5c:	89 f0                	mov    %esi,%eax
80102a5e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102a61:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102a64:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a67:	39 c2                	cmp    %eax,%edx
80102a69:	74 16                	je     80102a81 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a6b:	83 ec 0c             	sub    $0xc,%esp
80102a6e:	68 b4 88 10 80       	push   $0x801088b4
80102a73:	e8 28 dd ff ff       	call   801007a0 <cprintf>
80102a78:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
80102a7e:	83 c4 10             	add    $0x10,%esp
80102a81:	83 c6 21             	add    $0x21,%esi
{
80102a84:	ba 10 00 00 00       	mov    $0x10,%edx
80102a89:	b8 20 00 00 00       	mov    $0x20,%eax
80102a8e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102a90:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a92:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102a94:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
80102a9a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a9d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102aa3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102aa6:	8d 5a 01             	lea    0x1(%edx),%ebx
80102aa9:	83 c2 02             	add    $0x2,%edx
80102aac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102aae:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
80102ab4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102abb:	39 f0                	cmp    %esi,%eax
80102abd:	75 d1                	jne    80102a90 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac2:	5b                   	pop    %ebx
80102ac3:	5e                   	pop    %esi
80102ac4:	5d                   	pop    %ebp
80102ac5:	c3                   	ret    
80102ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
  ioapic->reg = reg;
80102ad5:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
{
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ae0:	8d 50 20             	lea    0x20(%eax),%edx
80102ae3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ae7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ae9:	8b 0d e0 4c 11 80    	mov    0x80114ce0,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102aef:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102af2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102af8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102afa:	a1 e0 4c 11 80       	mov    0x80114ce0,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102aff:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102b02:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b05:	5d                   	pop    %ebp
80102b06:	c3                   	ret    
80102b07:	66 90                	xchg   %ax,%ax
80102b09:	66 90                	xchg   %ax,%ax
80102b0b:	66 90                	xchg   %ax,%ax
80102b0d:	66 90                	xchg   %ax,%ax
80102b0f:	90                   	nop

80102b10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	53                   	push   %ebx
80102b18:	83 ec 04             	sub    $0x4,%esp
80102b1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b1e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b24:	75 7a                	jne    80102ba0 <kfree+0x90>
80102b26:	81 fb 08 ae 11 80    	cmp    $0x8011ae08,%ebx
80102b2c:	72 72                	jb     80102ba0 <kfree+0x90>
80102b2e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b34:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b39:	77 65                	ja     80102ba0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b3b:	83 ec 04             	sub    $0x4,%esp
80102b3e:	68 00 10 00 00       	push   $0x1000
80102b43:	6a 01                	push   $0x1
80102b45:	53                   	push   %ebx
80102b46:	e8 c5 2d 00 00       	call   80105910 <memset>

  if(kmem.use_lock)
80102b4b:	8b 15 38 4d 11 80    	mov    0x80114d38,%edx
80102b51:	83 c4 10             	add    $0x10,%esp
80102b54:	85 d2                	test   %edx,%edx
80102b56:	75 20                	jne    80102b78 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b58:	a1 3c 4d 11 80       	mov    0x80114d3c,%eax
80102b5d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b5f:	a1 38 4d 11 80       	mov    0x80114d38,%eax
  kmem.freelist = r;
80102b64:	89 1d 3c 4d 11 80    	mov    %ebx,0x80114d3c
  if(kmem.use_lock)
80102b6a:	85 c0                	test   %eax,%eax
80102b6c:	75 22                	jne    80102b90 <kfree+0x80>
    release(&kmem.lock);
}
80102b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b71:	c9                   	leave  
80102b72:	c3                   	ret    
80102b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b77:	90                   	nop
    acquire(&kmem.lock);
80102b78:	83 ec 0c             	sub    $0xc,%esp
80102b7b:	68 00 4d 11 80       	push   $0x80114d00
80102b80:	e8 3b 2c 00 00       	call   801057c0 <acquire>
80102b85:	83 c4 10             	add    $0x10,%esp
80102b88:	eb ce                	jmp    80102b58 <kfree+0x48>
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102b90:	c7 45 08 00 4d 11 80 	movl   $0x80114d00,0x8(%ebp)
}
80102b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9a:	c9                   	leave  
    release(&kmem.lock);
80102b9b:	e9 10 2d 00 00       	jmp    801058b0 <release>
    panic("kfree");
80102ba0:	83 ec 0c             	sub    $0xc,%esp
80102ba3:	68 e6 88 10 80       	push   $0x801088e6
80102ba8:	e8 e3 d7 ff ff       	call   80100390 <panic>
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <freerange>:
{
80102bb0:	f3 0f 1e fb          	endbr32 
80102bb4:	55                   	push   %ebp
80102bb5:	89 e5                	mov    %esp,%ebp
80102bb7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bbb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102bbe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bbf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bc5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bcb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bd1:	39 de                	cmp    %ebx,%esi
80102bd3:	72 1f                	jb     80102bf4 <freerange+0x44>
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102bd8:	83 ec 0c             	sub    $0xc,%esp
80102bdb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102be1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102be7:	50                   	push   %eax
80102be8:	e8 23 ff ff ff       	call   80102b10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bed:	83 c4 10             	add    $0x10,%esp
80102bf0:	39 f3                	cmp    %esi,%ebx
80102bf2:	76 e4                	jbe    80102bd8 <freerange+0x28>
}
80102bf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bf7:	5b                   	pop    %ebx
80102bf8:	5e                   	pop    %esi
80102bf9:	5d                   	pop    %ebp
80102bfa:	c3                   	ret    
80102bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop

80102c00 <kinit1>:
{
80102c00:	f3 0f 1e fb          	endbr32 
80102c04:	55                   	push   %ebp
80102c05:	89 e5                	mov    %esp,%ebp
80102c07:	56                   	push   %esi
80102c08:	53                   	push   %ebx
80102c09:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c0c:	83 ec 08             	sub    $0x8,%esp
80102c0f:	68 ec 88 10 80       	push   $0x801088ec
80102c14:	68 00 4d 11 80       	push   $0x80114d00
80102c19:	e8 12 2a 00 00       	call   80105630 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c21:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c24:	c7 05 38 4d 11 80 00 	movl   $0x0,0x80114d38
80102c2b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c2e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c34:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c40:	39 de                	cmp    %ebx,%esi
80102c42:	72 20                	jb     80102c64 <kinit1+0x64>
80102c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c57:	50                   	push   %eax
80102c58:	e8 b3 fe ff ff       	call   80102b10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c5d:	83 c4 10             	add    $0x10,%esp
80102c60:	39 de                	cmp    %ebx,%esi
80102c62:	73 e4                	jae    80102c48 <kinit1+0x48>
}
80102c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c67:	5b                   	pop    %ebx
80102c68:	5e                   	pop    %esi
80102c69:	5d                   	pop    %ebp
80102c6a:	c3                   	ret    
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop

80102c70 <kinit2>:
{
80102c70:	f3 0f 1e fb          	endbr32 
80102c74:	55                   	push   %ebp
80102c75:	89 e5                	mov    %esp,%ebp
80102c77:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c78:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c7b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c7e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c7f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c85:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c91:	39 de                	cmp    %ebx,%esi
80102c93:	72 1f                	jb     80102cb4 <kinit2+0x44>
80102c95:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c98:	83 ec 0c             	sub    $0xc,%esp
80102c9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ca7:	50                   	push   %eax
80102ca8:	e8 63 fe ff ff       	call   80102b10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cad:	83 c4 10             	add    $0x10,%esp
80102cb0:	39 de                	cmp    %ebx,%esi
80102cb2:	73 e4                	jae    80102c98 <kinit2+0x28>
  kmem.use_lock = 1;
80102cb4:	c7 05 38 4d 11 80 01 	movl   $0x1,0x80114d38
80102cbb:	00 00 00 
}
80102cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cc1:	5b                   	pop    %ebx
80102cc2:	5e                   	pop    %esi
80102cc3:	5d                   	pop    %ebp
80102cc4:	c3                   	ret    
80102cc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102cd0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102cd4:	a1 38 4d 11 80       	mov    0x80114d38,%eax
80102cd9:	85 c0                	test   %eax,%eax
80102cdb:	75 1b                	jne    80102cf8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102cdd:	a1 3c 4d 11 80       	mov    0x80114d3c,%eax
  if(r)
80102ce2:	85 c0                	test   %eax,%eax
80102ce4:	74 0a                	je     80102cf0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ce6:	8b 10                	mov    (%eax),%edx
80102ce8:	89 15 3c 4d 11 80    	mov    %edx,0x80114d3c
  if(kmem.use_lock)
80102cee:	c3                   	ret    
80102cef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102cf0:	c3                   	ret    
80102cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102cf8:	55                   	push   %ebp
80102cf9:	89 e5                	mov    %esp,%ebp
80102cfb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102cfe:	68 00 4d 11 80       	push   $0x80114d00
80102d03:	e8 b8 2a 00 00       	call   801057c0 <acquire>
  r = kmem.freelist;
80102d08:	a1 3c 4d 11 80       	mov    0x80114d3c,%eax
  if(r)
80102d0d:	8b 15 38 4d 11 80    	mov    0x80114d38,%edx
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	85 c0                	test   %eax,%eax
80102d18:	74 08                	je     80102d22 <kalloc+0x52>
    kmem.freelist = r->next;
80102d1a:	8b 08                	mov    (%eax),%ecx
80102d1c:	89 0d 3c 4d 11 80    	mov    %ecx,0x80114d3c
  if(kmem.use_lock)
80102d22:	85 d2                	test   %edx,%edx
80102d24:	74 16                	je     80102d3c <kalloc+0x6c>
    release(&kmem.lock);
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d2c:	68 00 4d 11 80       	push   $0x80114d00
80102d31:	e8 7a 2b 00 00       	call   801058b0 <release>
  return (char*)r;
80102d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d39:	83 c4 10             	add    $0x10,%esp
}
80102d3c:	c9                   	leave  
80102d3d:	c3                   	ret    
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	ba 64 00 00 00       	mov    $0x64,%edx
80102d49:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d4a:	a8 01                	test   $0x1,%al
80102d4c:	0f 84 be 00 00 00    	je     80102e10 <kbdgetc+0xd0>
{
80102d52:	55                   	push   %ebp
80102d53:	ba 60 00 00 00       	mov    $0x60,%edx
80102d58:	89 e5                	mov    %esp,%ebp
80102d5a:	53                   	push   %ebx
80102d5b:	ec                   	in     (%dx),%al
  return data;
80102d5c:	8b 1d f8 c5 10 80    	mov    0x8010c5f8,%ebx
    return -1;
  data = inb(KBDATAP);
80102d62:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102d65:	3c e0                	cmp    $0xe0,%al
80102d67:	74 57                	je     80102dc0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d69:	89 d9                	mov    %ebx,%ecx
80102d6b:	83 e1 40             	and    $0x40,%ecx
80102d6e:	84 c0                	test   %al,%al
80102d70:	78 5e                	js     80102dd0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d72:	85 c9                	test   %ecx,%ecx
80102d74:	74 09                	je     80102d7f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d76:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d79:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102d7c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d7f:	0f b6 8a 20 8a 10 80 	movzbl -0x7fef75e0(%edx),%ecx
  shift ^= togglecode[data];
80102d86:	0f b6 82 20 89 10 80 	movzbl -0x7fef76e0(%edx),%eax
  shift |= shiftcode[data];
80102d8d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d8f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d91:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d93:	89 0d f8 c5 10 80    	mov    %ecx,0x8010c5f8
  c = charcode[shift & (CTL | SHIFT)][data];
80102d99:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d9c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d9f:	8b 04 85 00 89 10 80 	mov    -0x7fef7700(,%eax,4),%eax
80102da6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102daa:	74 0b                	je     80102db7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102dac:	8d 50 9f             	lea    -0x61(%eax),%edx
80102daf:	83 fa 19             	cmp    $0x19,%edx
80102db2:	77 44                	ja     80102df8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102db4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102db7:	5b                   	pop    %ebx
80102db8:	5d                   	pop    %ebp
80102db9:	c3                   	ret    
80102dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102dc0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102dc3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102dc5:	89 1d f8 c5 10 80    	mov    %ebx,0x8010c5f8
}
80102dcb:	5b                   	pop    %ebx
80102dcc:	5d                   	pop    %ebp
80102dcd:	c3                   	ret    
80102dce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102dd0:	83 e0 7f             	and    $0x7f,%eax
80102dd3:	85 c9                	test   %ecx,%ecx
80102dd5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102dd8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102dda:	0f b6 8a 20 8a 10 80 	movzbl -0x7fef75e0(%edx),%ecx
80102de1:	83 c9 40             	or     $0x40,%ecx
80102de4:	0f b6 c9             	movzbl %cl,%ecx
80102de7:	f7 d1                	not    %ecx
80102de9:	21 d9                	and    %ebx,%ecx
}
80102deb:	5b                   	pop    %ebx
80102dec:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102ded:	89 0d f8 c5 10 80    	mov    %ecx,0x8010c5f8
}
80102df3:	c3                   	ret    
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102df8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102dfb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102dfe:	5b                   	pop    %ebx
80102dff:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102e00:	83 f9 1a             	cmp    $0x1a,%ecx
80102e03:	0f 42 c2             	cmovb  %edx,%eax
}
80102e06:	c3                   	ret    
80102e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0e:	66 90                	xchg   %ax,%ax
    return -1;
80102e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e15:	c3                   	ret    
80102e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi

80102e20 <kbdintr>:

void
kbdintr(void)
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e2a:	68 40 2d 10 80       	push   $0x80102d40
80102e2f:	e8 cc dd ff ff       	call   80100c00 <consoleintr>
}
80102e34:	83 c4 10             	add    $0x10,%esp
80102e37:	c9                   	leave  
80102e38:	c3                   	ret    
80102e39:	66 90                	xchg   %ax,%ax
80102e3b:	66 90                	xchg   %ax,%ax
80102e3d:	66 90                	xchg   %ax,%ax
80102e3f:	90                   	nop

80102e40 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102e40:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102e44:	a1 40 4d 11 80       	mov    0x80114d40,%eax
80102e49:	85 c0                	test   %eax,%eax
80102e4b:	0f 84 c7 00 00 00    	je     80102f18 <lapicinit+0xd8>
  lapic[index] = value;
80102e51:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e58:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e5e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e65:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e68:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e6b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e72:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e75:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e78:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e7f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e82:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e85:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e8c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e8f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e92:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e99:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e9f:	8b 50 30             	mov    0x30(%eax),%edx
80102ea2:	c1 ea 10             	shr    $0x10,%edx
80102ea5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102eab:	75 73                	jne    80102f20 <lapicinit+0xe0>
  lapic[index] = value;
80102ead:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102eb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ec1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ece:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102edb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ede:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ee1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ee8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eeb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ef5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef8:	8b 50 20             	mov    0x20(%eax),%edx
80102efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f06:	80 e6 10             	and    $0x10,%dh
80102f09:	75 f5                	jne    80102f00 <lapicinit+0xc0>
  lapic[index] = value;
80102f0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f18:	c3                   	ret    
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102f20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102f2d:	e9 7b ff ff ff       	jmp    80102ead <lapicinit+0x6d>
80102f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f40 <lapicid>:

int
lapicid(void)
{
80102f40:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102f44:	a1 40 4d 11 80       	mov    0x80114d40,%eax
80102f49:	85 c0                	test   %eax,%eax
80102f4b:	74 0b                	je     80102f58 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102f4d:	8b 40 20             	mov    0x20(%eax),%eax
80102f50:	c1 e8 18             	shr    $0x18,%eax
80102f53:	c3                   	ret    
80102f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102f58:	31 c0                	xor    %eax,%eax
}
80102f5a:	c3                   	ret    
80102f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f60:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102f64:	a1 40 4d 11 80       	mov    0x80114d40,%eax
80102f69:	85 c0                	test   %eax,%eax
80102f6b:	74 0d                	je     80102f7a <lapiceoi+0x1a>
  lapic[index] = value;
80102f6d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f77:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f7a:	c3                   	ret    
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop

80102f80 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f80:	f3 0f 1e fb          	endbr32 
}
80102f84:	c3                   	ret    
80102f85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f90:	f3 0f 1e fb          	endbr32 
80102f94:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f95:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f9a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f9f:	89 e5                	mov    %esp,%ebp
80102fa1:	53                   	push   %ebx
80102fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102fa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fa8:	ee                   	out    %al,(%dx)
80102fa9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fae:	ba 71 00 00 00       	mov    $0x71,%edx
80102fb3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102fb4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fb6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102fb9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102fbf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fc1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102fc4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102fc6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fc9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102fcc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102fd2:	a1 40 4d 11 80       	mov    0x80114d40,%eax
80102fd7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fdd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fe0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102fe7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fea:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fed:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ff4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ffa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103000:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103003:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103009:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010300c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103012:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103015:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010301b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010301c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010301f:	5d                   	pop    %ebp
80103020:	c3                   	ret    
80103021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop

80103030 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	b8 0b 00 00 00       	mov    $0xb,%eax
8010303a:	ba 70 00 00 00       	mov    $0x70,%edx
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	57                   	push   %edi
80103042:	56                   	push   %esi
80103043:	53                   	push   %ebx
80103044:	83 ec 4c             	sub    $0x4c,%esp
80103047:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103048:	ba 71 00 00 00       	mov    $0x71,%edx
8010304d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010304e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103051:	bb 70 00 00 00       	mov    $0x70,%ebx
80103056:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103060:	31 c0                	xor    %eax,%eax
80103062:	89 da                	mov    %ebx,%edx
80103064:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103065:	b9 71 00 00 00       	mov    $0x71,%ecx
8010306a:	89 ca                	mov    %ecx,%edx
8010306c:	ec                   	in     (%dx),%al
8010306d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103070:	89 da                	mov    %ebx,%edx
80103072:	b8 02 00 00 00       	mov    $0x2,%eax
80103077:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103078:	89 ca                	mov    %ecx,%edx
8010307a:	ec                   	in     (%dx),%al
8010307b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307e:	89 da                	mov    %ebx,%edx
80103080:	b8 04 00 00 00       	mov    $0x4,%eax
80103085:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103086:	89 ca                	mov    %ecx,%edx
80103088:	ec                   	in     (%dx),%al
80103089:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308c:	89 da                	mov    %ebx,%edx
8010308e:	b8 07 00 00 00       	mov    $0x7,%eax
80103093:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103094:	89 ca                	mov    %ecx,%edx
80103096:	ec                   	in     (%dx),%al
80103097:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309a:	89 da                	mov    %ebx,%edx
8010309c:	b8 08 00 00 00       	mov    $0x8,%eax
801030a1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a2:	89 ca                	mov    %ecx,%edx
801030a4:	ec                   	in     (%dx),%al
801030a5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a7:	89 da                	mov    %ebx,%edx
801030a9:	b8 09 00 00 00       	mov    $0x9,%eax
801030ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030af:	89 ca                	mov    %ecx,%edx
801030b1:	ec                   	in     (%dx),%al
801030b2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b4:	89 da                	mov    %ebx,%edx
801030b6:	b8 0a 00 00 00       	mov    $0xa,%eax
801030bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030bc:	89 ca                	mov    %ecx,%edx
801030be:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030bf:	84 c0                	test   %al,%al
801030c1:	78 9d                	js     80103060 <cmostime+0x30>
  return inb(CMOS_RETURN);
801030c3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030c7:	89 fa                	mov    %edi,%edx
801030c9:	0f b6 fa             	movzbl %dl,%edi
801030cc:	89 f2                	mov    %esi,%edx
801030ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
801030d1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801030d5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d8:	89 da                	mov    %ebx,%edx
801030da:	89 7d c8             	mov    %edi,-0x38(%ebp)
801030dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030e0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801030e4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801030e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030ea:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801030ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030f1:	31 c0                	xor    %eax,%eax
801030f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f4:	89 ca                	mov    %ecx,%edx
801030f6:	ec                   	in     (%dx),%al
801030f7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fa:	89 da                	mov    %ebx,%edx
801030fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030ff:	b8 02 00 00 00       	mov    $0x2,%eax
80103104:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103105:	89 ca                	mov    %ecx,%edx
80103107:	ec                   	in     (%dx),%al
80103108:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310b:	89 da                	mov    %ebx,%edx
8010310d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103110:	b8 04 00 00 00       	mov    $0x4,%eax
80103115:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103116:	89 ca                	mov    %ecx,%edx
80103118:	ec                   	in     (%dx),%al
80103119:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311c:	89 da                	mov    %ebx,%edx
8010311e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103121:	b8 07 00 00 00       	mov    $0x7,%eax
80103126:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103127:	89 ca                	mov    %ecx,%edx
80103129:	ec                   	in     (%dx),%al
8010312a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312d:	89 da                	mov    %ebx,%edx
8010312f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103132:	b8 08 00 00 00       	mov    $0x8,%eax
80103137:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103138:	89 ca                	mov    %ecx,%edx
8010313a:	ec                   	in     (%dx),%al
8010313b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010313e:	89 da                	mov    %ebx,%edx
80103140:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103143:	b8 09 00 00 00       	mov    $0x9,%eax
80103148:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103149:	89 ca                	mov    %ecx,%edx
8010314b:	ec                   	in     (%dx),%al
8010314c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010314f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103155:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103158:	6a 18                	push   $0x18
8010315a:	50                   	push   %eax
8010315b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010315e:	50                   	push   %eax
8010315f:	e8 fc 27 00 00       	call   80105960 <memcmp>
80103164:	83 c4 10             	add    $0x10,%esp
80103167:	85 c0                	test   %eax,%eax
80103169:	0f 85 f1 fe ff ff    	jne    80103060 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010316f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103173:	75 78                	jne    801031ed <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103175:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103178:	89 c2                	mov    %eax,%edx
8010317a:	83 e0 0f             	and    $0xf,%eax
8010317d:	c1 ea 04             	shr    $0x4,%edx
80103180:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103183:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103186:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103189:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	83 e0 0f             	and    $0xf,%eax
80103191:	c1 ea 04             	shr    $0x4,%edx
80103194:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103197:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010319a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010319d:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031a0:	89 c2                	mov    %eax,%edx
801031a2:	83 e0 0f             	and    $0xf,%eax
801031a5:	c1 ea 04             	shr    $0x4,%edx
801031a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	83 e0 0f             	and    $0xf,%eax
801031b9:	c1 ea 04             	shr    $0x4,%edx
801031bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031c8:	89 c2                	mov    %eax,%edx
801031ca:	83 e0 0f             	and    $0xf,%eax
801031cd:	c1 ea 04             	shr    $0x4,%edx
801031d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801031d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031dc:	89 c2                	mov    %eax,%edx
801031de:	83 e0 0f             	and    $0xf,%eax
801031e1:	c1 ea 04             	shr    $0x4,%edx
801031e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801031ed:	8b 75 08             	mov    0x8(%ebp),%esi
801031f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031f3:	89 06                	mov    %eax,(%esi)
801031f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031f8:	89 46 04             	mov    %eax,0x4(%esi)
801031fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031fe:	89 46 08             	mov    %eax,0x8(%esi)
80103201:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103204:	89 46 0c             	mov    %eax,0xc(%esi)
80103207:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010320a:	89 46 10             	mov    %eax,0x10(%esi)
8010320d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103210:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103213:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010321a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	66 90                	xchg   %ax,%ax
80103224:	66 90                	xchg   %ax,%ax
80103226:	66 90                	xchg   %ax,%ax
80103228:	66 90                	xchg   %ax,%ax
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103230:	8b 0d ac 4d 11 80    	mov    0x80114dac,%ecx
80103236:	85 c9                	test   %ecx,%ecx
80103238:	0f 8e 8a 00 00 00    	jle    801032c8 <install_trans+0x98>
{
8010323e:	55                   	push   %ebp
8010323f:	89 e5                	mov    %esp,%ebp
80103241:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103242:	31 ff                	xor    %edi,%edi
{
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103250:	a1 98 4d 11 80       	mov    0x80114d98,%eax
80103255:	83 ec 08             	sub    $0x8,%esp
80103258:	01 f8                	add    %edi,%eax
8010325a:	83 c0 01             	add    $0x1,%eax
8010325d:	50                   	push   %eax
8010325e:	ff 35 a8 4d 11 80    	pushl  0x80114da8
80103264:	e8 67 ce ff ff       	call   801000d0 <bread>
80103269:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010326b:	58                   	pop    %eax
8010326c:	5a                   	pop    %edx
8010326d:	ff 34 bd b0 4d 11 80 	pushl  -0x7feeb250(,%edi,4)
80103274:	ff 35 a8 4d 11 80    	pushl  0x80114da8
  for (tail = 0; tail < log.lh.n; tail++) {
8010327a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010327d:	e8 4e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103282:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103285:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103287:	8d 46 60             	lea    0x60(%esi),%eax
8010328a:	68 00 02 00 00       	push   $0x200
8010328f:	50                   	push   %eax
80103290:	8d 43 60             	lea    0x60(%ebx),%eax
80103293:	50                   	push   %eax
80103294:	e8 17 27 00 00       	call   801059b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103299:	89 1c 24             	mov    %ebx,(%esp)
8010329c:	e8 0f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801032a1:	89 34 24             	mov    %esi,(%esp)
801032a4:	e8 47 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801032a9:	89 1c 24             	mov    %ebx,(%esp)
801032ac:	e8 3f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032b1:	83 c4 10             	add    $0x10,%esp
801032b4:	39 3d ac 4d 11 80    	cmp    %edi,0x80114dac
801032ba:	7f 94                	jg     80103250 <install_trans+0x20>
  }
}
801032bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032bf:	5b                   	pop    %ebx
801032c0:	5e                   	pop    %esi
801032c1:	5f                   	pop    %edi
801032c2:	5d                   	pop    %ebp
801032c3:	c3                   	ret    
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032c8:	c3                   	ret    
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	53                   	push   %ebx
801032d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801032d7:	ff 35 98 4d 11 80    	pushl  0x80114d98
801032dd:	ff 35 a8 4d 11 80    	pushl  0x80114da8
801032e3:	e8 e8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801032eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801032ed:	a1 ac 4d 11 80       	mov    0x80114dac,%eax
801032f2:	89 43 60             	mov    %eax,0x60(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032f5:	85 c0                	test   %eax,%eax
801032f7:	7e 19                	jle    80103312 <write_head+0x42>
801032f9:	31 d2                	xor    %edx,%edx
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103300:	8b 0c 95 b0 4d 11 80 	mov    -0x7feeb250(,%edx,4),%ecx
80103307:	89 4c 93 64          	mov    %ecx,0x64(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010330b:	83 c2 01             	add    $0x1,%edx
8010330e:	39 d0                	cmp    %edx,%eax
80103310:	75 ee                	jne    80103300 <write_head+0x30>
  }
  bwrite(buf);
80103312:	83 ec 0c             	sub    $0xc,%esp
80103315:	53                   	push   %ebx
80103316:	e8 95 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010331b:	89 1c 24             	mov    %ebx,(%esp)
8010331e:	e8 cd ce ff ff       	call   801001f0 <brelse>
}
80103323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103326:	83 c4 10             	add    $0x10,%esp
80103329:	c9                   	leave  
8010332a:	c3                   	ret    
8010332b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop

80103330 <initlog>:
{
80103330:	f3 0f 1e fb          	endbr32 
80103334:	55                   	push   %ebp
80103335:	89 e5                	mov    %esp,%ebp
80103337:	53                   	push   %ebx
80103338:	83 ec 2c             	sub    $0x2c,%esp
8010333b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010333e:	68 20 8b 10 80       	push   $0x80108b20
80103343:	68 60 4d 11 80       	push   $0x80114d60
80103348:	e8 e3 22 00 00       	call   80105630 <initlock>
  readsb(dev, &sb);
8010334d:	58                   	pop    %eax
8010334e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103351:	5a                   	pop    %edx
80103352:	50                   	push   %eax
80103353:	53                   	push   %ebx
80103354:	e8 47 e8 ff ff       	call   80101ba0 <readsb>
  log.start = sb.logstart;
80103359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010335c:	59                   	pop    %ecx
  log.dev = dev;
8010335d:	89 1d a8 4d 11 80    	mov    %ebx,0x80114da8
  log.size = sb.nlog;
80103363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103366:	a3 98 4d 11 80       	mov    %eax,0x80114d98
  log.size = sb.nlog;
8010336b:	89 15 9c 4d 11 80    	mov    %edx,0x80114d9c
  struct buf *buf = bread(log.dev, log.start);
80103371:	5a                   	pop    %edx
80103372:	50                   	push   %eax
80103373:	53                   	push   %ebx
80103374:	e8 57 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103379:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010337c:	8b 48 60             	mov    0x60(%eax),%ecx
8010337f:	89 0d ac 4d 11 80    	mov    %ecx,0x80114dac
  for (i = 0; i < log.lh.n; i++) {
80103385:	85 c9                	test   %ecx,%ecx
80103387:	7e 19                	jle    801033a2 <initlog+0x72>
80103389:	31 d2                	xor    %edx,%edx
8010338b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103390:	8b 5c 90 64          	mov    0x64(%eax,%edx,4),%ebx
80103394:	89 1c 95 b0 4d 11 80 	mov    %ebx,-0x7feeb250(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010339b:	83 c2 01             	add    $0x1,%edx
8010339e:	39 d1                	cmp    %edx,%ecx
801033a0:	75 ee                	jne    80103390 <initlog+0x60>
  brelse(buf);
801033a2:	83 ec 0c             	sub    $0xc,%esp
801033a5:	50                   	push   %eax
801033a6:	e8 45 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033ab:	e8 80 fe ff ff       	call   80103230 <install_trans>
  log.lh.n = 0;
801033b0:	c7 05 ac 4d 11 80 00 	movl   $0x0,0x80114dac
801033b7:	00 00 00 
  write_head(); // clear the log
801033ba:	e8 11 ff ff ff       	call   801032d0 <write_head>
}
801033bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033c2:	83 c4 10             	add    $0x10,%esp
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801033da:	68 60 4d 11 80       	push   $0x80114d60
801033df:	e8 dc 23 00 00       	call   801057c0 <acquire>
801033e4:	83 c4 10             	add    $0x10,%esp
801033e7:	eb 1c                	jmp    80103405 <begin_op+0x35>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033f0:	83 ec 08             	sub    $0x8,%esp
801033f3:	68 60 4d 11 80       	push   $0x80114d60
801033f8:	68 60 4d 11 80       	push   $0x80114d60
801033fd:	e8 0e 15 00 00       	call   80104910 <sleep>
80103402:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103405:	a1 a4 4d 11 80       	mov    0x80114da4,%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	75 e2                	jne    801033f0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010340e:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80103413:	8b 15 ac 4d 11 80    	mov    0x80114dac,%edx
80103419:	83 c0 01             	add    $0x1,%eax
8010341c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010341f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103422:	83 fa 1e             	cmp    $0x1e,%edx
80103425:	7f c9                	jg     801033f0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103427:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010342a:	a3 a0 4d 11 80       	mov    %eax,0x80114da0
      release(&log.lock);
8010342f:	68 60 4d 11 80       	push   $0x80114d60
80103434:	e8 77 24 00 00       	call   801058b0 <release>
      break;
    }
  }
}
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	c9                   	leave  
8010343d:	c3                   	ret    
8010343e:	66 90                	xchg   %ax,%ax

80103440 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103440:	f3 0f 1e fb          	endbr32 
80103444:	55                   	push   %ebp
80103445:	89 e5                	mov    %esp,%ebp
80103447:	57                   	push   %edi
80103448:	56                   	push   %esi
80103449:	53                   	push   %ebx
8010344a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010344d:	68 60 4d 11 80       	push   $0x80114d60
80103452:	e8 69 23 00 00       	call   801057c0 <acquire>
  log.outstanding -= 1;
80103457:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
  if(log.committing)
8010345c:	8b 35 a4 4d 11 80    	mov    0x80114da4,%esi
80103462:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103465:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103468:	89 1d a0 4d 11 80    	mov    %ebx,0x80114da0
  if(log.committing)
8010346e:	85 f6                	test   %esi,%esi
80103470:	0f 85 1e 01 00 00    	jne    80103594 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103476:	85 db                	test   %ebx,%ebx
80103478:	0f 85 f2 00 00 00    	jne    80103570 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010347e:	c7 05 a4 4d 11 80 01 	movl   $0x1,0x80114da4
80103485:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103488:	83 ec 0c             	sub    $0xc,%esp
8010348b:	68 60 4d 11 80       	push   $0x80114d60
80103490:	e8 1b 24 00 00       	call   801058b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103495:	8b 0d ac 4d 11 80    	mov    0x80114dac,%ecx
8010349b:	83 c4 10             	add    $0x10,%esp
8010349e:	85 c9                	test   %ecx,%ecx
801034a0:	7f 3e                	jg     801034e0 <end_op+0xa0>
    acquire(&log.lock);
801034a2:	83 ec 0c             	sub    $0xc,%esp
801034a5:	68 60 4d 11 80       	push   $0x80114d60
801034aa:	e8 11 23 00 00       	call   801057c0 <acquire>
    wakeup(&log);
801034af:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
    log.committing = 0;
801034b6:	c7 05 a4 4d 11 80 00 	movl   $0x0,0x80114da4
801034bd:	00 00 00 
    wakeup(&log);
801034c0:	e8 0b 16 00 00       	call   80104ad0 <wakeup>
    release(&log.lock);
801034c5:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801034cc:	e8 df 23 00 00       	call   801058b0 <release>
801034d1:	83 c4 10             	add    $0x10,%esp
}
801034d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d7:	5b                   	pop    %ebx
801034d8:	5e                   	pop    %esi
801034d9:	5f                   	pop    %edi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034e0:	a1 98 4d 11 80       	mov    0x80114d98,%eax
801034e5:	83 ec 08             	sub    $0x8,%esp
801034e8:	01 d8                	add    %ebx,%eax
801034ea:	83 c0 01             	add    $0x1,%eax
801034ed:	50                   	push   %eax
801034ee:	ff 35 a8 4d 11 80    	pushl  0x80114da8
801034f4:	e8 d7 cb ff ff       	call   801000d0 <bread>
801034f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034fb:	58                   	pop    %eax
801034fc:	5a                   	pop    %edx
801034fd:	ff 34 9d b0 4d 11 80 	pushl  -0x7feeb250(,%ebx,4)
80103504:	ff 35 a8 4d 11 80    	pushl  0x80114da8
  for (tail = 0; tail < log.lh.n; tail++) {
8010350a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010350d:	e8 be cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103512:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103515:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103517:	8d 40 60             	lea    0x60(%eax),%eax
8010351a:	68 00 02 00 00       	push   $0x200
8010351f:	50                   	push   %eax
80103520:	8d 46 60             	lea    0x60(%esi),%eax
80103523:	50                   	push   %eax
80103524:	e8 87 24 00 00       	call   801059b0 <memmove>
    bwrite(to);  // write the log
80103529:	89 34 24             	mov    %esi,(%esp)
8010352c:	e8 7f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103531:	89 3c 24             	mov    %edi,(%esp)
80103534:	e8 b7 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103539:	89 34 24             	mov    %esi,(%esp)
8010353c:	e8 af cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103541:	83 c4 10             	add    $0x10,%esp
80103544:	3b 1d ac 4d 11 80    	cmp    0x80114dac,%ebx
8010354a:	7c 94                	jl     801034e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010354c:	e8 7f fd ff ff       	call   801032d0 <write_head>
    install_trans(); // Now install writes to home locations
80103551:	e8 da fc ff ff       	call   80103230 <install_trans>
    log.lh.n = 0;
80103556:	c7 05 ac 4d 11 80 00 	movl   $0x0,0x80114dac
8010355d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103560:	e8 6b fd ff ff       	call   801032d0 <write_head>
80103565:	e9 38 ff ff ff       	jmp    801034a2 <end_op+0x62>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	68 60 4d 11 80       	push   $0x80114d60
80103578:	e8 53 15 00 00       	call   80104ad0 <wakeup>
  release(&log.lock);
8010357d:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80103584:	e8 27 23 00 00       	call   801058b0 <release>
80103589:	83 c4 10             	add    $0x10,%esp
}
8010358c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010358f:	5b                   	pop    %ebx
80103590:	5e                   	pop    %esi
80103591:	5f                   	pop    %edi
80103592:	5d                   	pop    %ebp
80103593:	c3                   	ret    
    panic("log.committing");
80103594:	83 ec 0c             	sub    $0xc,%esp
80103597:	68 24 8b 10 80       	push   $0x80108b24
8010359c:	e8 ef cd ff ff       	call   80100390 <panic>
801035a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop

801035b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	53                   	push   %ebx
801035b8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035bb:	8b 15 ac 4d 11 80    	mov    0x80114dac,%edx
{
801035c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035c4:	83 fa 1d             	cmp    $0x1d,%edx
801035c7:	0f 8f 91 00 00 00    	jg     8010365e <log_write+0xae>
801035cd:	a1 9c 4d 11 80       	mov    0x80114d9c,%eax
801035d2:	83 e8 01             	sub    $0x1,%eax
801035d5:	39 c2                	cmp    %eax,%edx
801035d7:	0f 8d 81 00 00 00    	jge    8010365e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035dd:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
801035e2:	85 c0                	test   %eax,%eax
801035e4:	0f 8e 81 00 00 00    	jle    8010366b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035ea:	83 ec 0c             	sub    $0xc,%esp
801035ed:	68 60 4d 11 80       	push   $0x80114d60
801035f2:	e8 c9 21 00 00       	call   801057c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035f7:	8b 15 ac 4d 11 80    	mov    0x80114dac,%edx
801035fd:	83 c4 10             	add    $0x10,%esp
80103600:	85 d2                	test   %edx,%edx
80103602:	7e 4e                	jle    80103652 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103604:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103607:	31 c0                	xor    %eax,%eax
80103609:	eb 0c                	jmp    80103617 <log_write+0x67>
8010360b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010360f:	90                   	nop
80103610:	83 c0 01             	add    $0x1,%eax
80103613:	39 c2                	cmp    %eax,%edx
80103615:	74 29                	je     80103640 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103617:	39 0c 85 b0 4d 11 80 	cmp    %ecx,-0x7feeb250(,%eax,4)
8010361e:	75 f0                	jne    80103610 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103620:	89 0c 85 b0 4d 11 80 	mov    %ecx,-0x7feeb250(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103627:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010362a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010362d:	c7 45 08 60 4d 11 80 	movl   $0x80114d60,0x8(%ebp)
}
80103634:	c9                   	leave  
  release(&log.lock);
80103635:	e9 76 22 00 00       	jmp    801058b0 <release>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103640:	89 0c 95 b0 4d 11 80 	mov    %ecx,-0x7feeb250(,%edx,4)
    log.lh.n++;
80103647:	83 c2 01             	add    $0x1,%edx
8010364a:	89 15 ac 4d 11 80    	mov    %edx,0x80114dac
80103650:	eb d5                	jmp    80103627 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103652:	8b 43 08             	mov    0x8(%ebx),%eax
80103655:	a3 b0 4d 11 80       	mov    %eax,0x80114db0
  if (i == log.lh.n)
8010365a:	75 cb                	jne    80103627 <log_write+0x77>
8010365c:	eb e9                	jmp    80103647 <log_write+0x97>
    panic("too big a transaction");
8010365e:	83 ec 0c             	sub    $0xc,%esp
80103661:	68 33 8b 10 80       	push   $0x80108b33
80103666:	e8 25 cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	68 49 8b 10 80       	push   $0x80108b49
80103673:	e8 18 cd ff ff       	call   80100390 <panic>
80103678:	66 90                	xchg   %ax,%ax
8010367a:	66 90                	xchg   %ax,%ax
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	53                   	push   %ebx
80103684:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103687:	e8 74 0a 00 00       	call   80104100 <cpuid>
8010368c:	89 c3                	mov    %eax,%ebx
8010368e:	e8 6d 0a 00 00       	call   80104100 <cpuid>
80103693:	83 ec 04             	sub    $0x4,%esp
80103696:	53                   	push   %ebx
80103697:	50                   	push   %eax
80103698:	68 64 8b 10 80       	push   $0x80108b64
8010369d:	e8 fe d0 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801036a2:	e8 19 38 00 00       	call   80106ec0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036a7:	e8 e4 09 00 00       	call   80104090 <mycpu>
801036ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036ae:	b8 01 00 00 00       	mov    $0x1,%eax
801036b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036ba:	e8 c1 0e 00 00       	call   80104580 <scheduler>
801036bf:	90                   	nop

801036c0 <mpenter>:
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036ca:	e8 c1 48 00 00       	call   80107f90 <switchkvm>
  seginit();
801036cf:	e8 2c 48 00 00       	call   80107f00 <seginit>
  lapicinit();
801036d4:	e8 67 f7 ff ff       	call   80102e40 <lapicinit>
  mpmain();
801036d9:	e8 a2 ff ff ff       	call   80103680 <mpmain>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <main>:
{
801036e0:	f3 0f 1e fb          	endbr32 
801036e4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036e8:	83 e4 f0             	and    $0xfffffff0,%esp
801036eb:	ff 71 fc             	pushl  -0x4(%ecx)
801036ee:	55                   	push   %ebp
801036ef:	89 e5                	mov    %esp,%ebp
801036f1:	53                   	push   %ebx
801036f2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036f3:	83 ec 08             	sub    $0x8,%esp
801036f6:	68 00 00 40 80       	push   $0x80400000
801036fb:	68 08 ae 11 80       	push   $0x8011ae08
80103700:	e8 fb f4 ff ff       	call   80102c00 <kinit1>
  kvmalloc();      // kernel page table
80103705:	e8 66 4d 00 00       	call   80108470 <kvmalloc>
  mpinit();        // detect other processors
8010370a:	e8 81 01 00 00       	call   80103890 <mpinit>
  lapicinit();     // interrupt controller
8010370f:	e8 2c f7 ff ff       	call   80102e40 <lapicinit>
  seginit();       // segment descriptors
80103714:	e8 e7 47 00 00       	call   80107f00 <seginit>
  picinit();       // disable pic
80103719:	e8 52 03 00 00       	call   80103a70 <picinit>
  ioapicinit();    // another interrupt controller
8010371e:	e8 fd f2 ff ff       	call   80102a20 <ioapicinit>
  consoleinit();   // console hardware
80103723:	e8 98 d9 ff ff       	call   801010c0 <consoleinit>
  uartinit();      // serial port
80103728:	e8 93 3a 00 00       	call   801071c0 <uartinit>
  pinit();         // process table
8010372d:	e8 3e 09 00 00       	call   80104070 <pinit>
  tvinit();        // trap vectors
80103732:	e8 09 37 00 00       	call   80106e40 <tvinit>
  binit();         // buffer cache
80103737:	e8 04 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010373c:	e8 3f dd ff ff       	call   80101480 <fileinit>
  ideinit();       // disk 
80103741:	e8 aa f0 ff ff       	call   801027f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103746:	83 c4 0c             	add    $0xc,%esp
80103749:	68 8a 00 00 00       	push   $0x8a
8010374e:	68 8c c4 10 80       	push   $0x8010c48c
80103753:	68 00 70 00 80       	push   $0x80007000
80103758:	e8 53 22 00 00       	call   801059b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010375d:	83 c4 10             	add    $0x10,%esp
80103760:	69 05 e0 53 11 80 b0 	imul   $0xb0,0x801153e0,%eax
80103767:	00 00 00 
8010376a:	05 60 4e 11 80       	add    $0x80114e60,%eax
8010376f:	3d 60 4e 11 80       	cmp    $0x80114e60,%eax
80103774:	76 7a                	jbe    801037f0 <main+0x110>
80103776:	bb 60 4e 11 80       	mov    $0x80114e60,%ebx
8010377b:	eb 1c                	jmp    80103799 <main+0xb9>
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
80103780:	69 05 e0 53 11 80 b0 	imul   $0xb0,0x801153e0,%eax
80103787:	00 00 00 
8010378a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103790:	05 60 4e 11 80       	add    $0x80114e60,%eax
80103795:	39 c3                	cmp    %eax,%ebx
80103797:	73 57                	jae    801037f0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103799:	e8 f2 08 00 00       	call   80104090 <mycpu>
8010379e:	39 c3                	cmp    %eax,%ebx
801037a0:	74 de                	je     80103780 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801037a2:	e8 29 f5 ff ff       	call   80102cd0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801037a7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801037aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801036c0,0x80006ff8
801037b1:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037b4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801037bb:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037be:	05 00 10 00 00       	add    $0x1000,%eax
801037c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801037c8:	0f b6 03             	movzbl (%ebx),%eax
801037cb:	68 00 70 00 00       	push   $0x7000
801037d0:	50                   	push   %eax
801037d1:	e8 ba f7 ff ff       	call   80102f90 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037e6:	85 c0                	test   %eax,%eax
801037e8:	74 f6                	je     801037e0 <main+0x100>
801037ea:	eb 94                	jmp    80103780 <main+0xa0>
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	68 00 00 00 8e       	push   $0x8e000000
801037f8:	68 00 00 40 80       	push   $0x80400000
801037fd:	e8 6e f4 ff ff       	call   80102c70 <kinit2>
  userinit();      // first user process
80103802:	e8 49 09 00 00       	call   80104150 <userinit>
  mpmain();        // finish this processor's setup
80103807:	e8 74 fe ff ff       	call   80103680 <mpmain>
8010380c:	66 90                	xchg   %ax,%ax
8010380e:	66 90                	xchg   %ax,%ax

80103810 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103815:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010381b:	53                   	push   %ebx
  e = addr+len;
8010381c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010381f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103822:	39 de                	cmp    %ebx,%esi
80103824:	72 10                	jb     80103836 <mpsearch1+0x26>
80103826:	eb 50                	jmp    80103878 <mpsearch1+0x68>
80103828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
80103830:	89 fe                	mov    %edi,%esi
80103832:	39 fb                	cmp    %edi,%ebx
80103834:	76 42                	jbe    80103878 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103836:	83 ec 04             	sub    $0x4,%esp
80103839:	8d 7e 10             	lea    0x10(%esi),%edi
8010383c:	6a 04                	push   $0x4
8010383e:	68 78 8b 10 80       	push   $0x80108b78
80103843:	56                   	push   %esi
80103844:	e8 17 21 00 00       	call   80105960 <memcmp>
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	85 c0                	test   %eax,%eax
8010384e:	75 e0                	jne    80103830 <mpsearch1+0x20>
80103850:	89 f2                	mov    %esi,%edx
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103858:	0f b6 0a             	movzbl (%edx),%ecx
8010385b:	83 c2 01             	add    $0x1,%edx
8010385e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103860:	39 fa                	cmp    %edi,%edx
80103862:	75 f4                	jne    80103858 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103864:	84 c0                	test   %al,%al
80103866:	75 c8                	jne    80103830 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386b:	89 f0                	mov    %esi,%eax
8010386d:	5b                   	pop    %ebx
8010386e:	5e                   	pop    %esi
8010386f:	5f                   	pop    %edi
80103870:	5d                   	pop    %ebp
80103871:	c3                   	ret    
80103872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103878:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010387b:	31 f6                	xor    %esi,%esi
}
8010387d:	5b                   	pop    %ebx
8010387e:	89 f0                	mov    %esi,%eax
80103880:	5e                   	pop    %esi
80103881:	5f                   	pop    %edi
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
80103884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop

80103890 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103890:	f3 0f 1e fb          	endbr32 
80103894:	55                   	push   %ebp
80103895:	89 e5                	mov    %esp,%ebp
80103897:	57                   	push   %edi
80103898:	56                   	push   %esi
80103899:	53                   	push   %ebx
8010389a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010389d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038a4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038ab:	c1 e0 08             	shl    $0x8,%eax
801038ae:	09 d0                	or     %edx,%eax
801038b0:	c1 e0 04             	shl    $0x4,%eax
801038b3:	75 1b                	jne    801038d0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038b5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038bc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038c3:	c1 e0 08             	shl    $0x8,%eax
801038c6:	09 d0                	or     %edx,%eax
801038c8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038cb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038d0:	ba 00 04 00 00       	mov    $0x400,%edx
801038d5:	e8 36 ff ff ff       	call   80103810 <mpsearch1>
801038da:	89 c6                	mov    %eax,%esi
801038dc:	85 c0                	test   %eax,%eax
801038de:	0f 84 4c 01 00 00    	je     80103a30 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038e4:	8b 5e 04             	mov    0x4(%esi),%ebx
801038e7:	85 db                	test   %ebx,%ebx
801038e9:	0f 84 61 01 00 00    	je     80103a50 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801038ef:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038f2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038f8:	6a 04                	push   $0x4
801038fa:	68 7d 8b 10 80       	push   $0x80108b7d
801038ff:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103900:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103903:	e8 58 20 00 00       	call   80105960 <memcmp>
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	85 c0                	test   %eax,%eax
8010390d:	0f 85 3d 01 00 00    	jne    80103a50 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103913:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010391a:	3c 01                	cmp    $0x1,%al
8010391c:	74 08                	je     80103926 <mpinit+0x96>
8010391e:	3c 04                	cmp    $0x4,%al
80103920:	0f 85 2a 01 00 00    	jne    80103a50 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103926:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010392d:	66 85 d2             	test   %dx,%dx
80103930:	74 26                	je     80103958 <mpinit+0xc8>
80103932:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103935:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103937:	31 d2                	xor    %edx,%edx
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103940:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103947:	83 c0 01             	add    $0x1,%eax
8010394a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010394c:	39 f8                	cmp    %edi,%eax
8010394e:	75 f0                	jne    80103940 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103950:	84 d2                	test   %dl,%dl
80103952:	0f 85 f8 00 00 00    	jne    80103a50 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103958:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010395e:	a3 40 4d 11 80       	mov    %eax,0x80114d40
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103963:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103969:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103970:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103975:	03 55 e4             	add    -0x1c(%ebp),%edx
80103978:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop
80103980:	39 c2                	cmp    %eax,%edx
80103982:	76 15                	jbe    80103999 <mpinit+0x109>
    switch(*p){
80103984:	0f b6 08             	movzbl (%eax),%ecx
80103987:	80 f9 02             	cmp    $0x2,%cl
8010398a:	74 5c                	je     801039e8 <mpinit+0x158>
8010398c:	77 42                	ja     801039d0 <mpinit+0x140>
8010398e:	84 c9                	test   %cl,%cl
80103990:	74 6e                	je     80103a00 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103992:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103995:	39 c2                	cmp    %eax,%edx
80103997:	77 eb                	ja     80103984 <mpinit+0xf4>
80103999:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010399c:	85 db                	test   %ebx,%ebx
8010399e:	0f 84 b9 00 00 00    	je     80103a5d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039a4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801039a8:	74 15                	je     801039bf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039aa:	b8 70 00 00 00       	mov    $0x70,%eax
801039af:	ba 22 00 00 00       	mov    $0x22,%edx
801039b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039b5:	ba 23 00 00 00       	mov    $0x23,%edx
801039ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039bb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039be:	ee                   	out    %al,(%dx)
  }
}
801039bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c2:	5b                   	pop    %ebx
801039c3:	5e                   	pop    %esi
801039c4:	5f                   	pop    %edi
801039c5:	5d                   	pop    %ebp
801039c6:	c3                   	ret    
801039c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ce:	66 90                	xchg   %ax,%ax
    switch(*p){
801039d0:	83 e9 03             	sub    $0x3,%ecx
801039d3:	80 f9 01             	cmp    $0x1,%cl
801039d6:	76 ba                	jbe    80103992 <mpinit+0x102>
801039d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801039df:	eb 9f                	jmp    80103980 <mpinit+0xf0>
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039e8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801039ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039ef:	88 0d 40 4e 11 80    	mov    %cl,0x80114e40
      continue;
801039f5:	eb 89                	jmp    80103980 <mpinit+0xf0>
801039f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039fe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103a00:	8b 0d e0 53 11 80    	mov    0x801153e0,%ecx
80103a06:	83 f9 07             	cmp    $0x7,%ecx
80103a09:	7f 19                	jg     80103a24 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a0b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103a11:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103a15:	83 c1 01             	add    $0x1,%ecx
80103a18:	89 0d e0 53 11 80    	mov    %ecx,0x801153e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a1e:	88 9f 60 4e 11 80    	mov    %bl,-0x7feeb1a0(%edi)
      p += sizeof(struct mpproc);
80103a24:	83 c0 14             	add    $0x14,%eax
      continue;
80103a27:	e9 54 ff ff ff       	jmp    80103980 <mpinit+0xf0>
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a3a:	e8 d1 fd ff ff       	call   80103810 <mpsearch1>
80103a3f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a41:	85 c0                	test   %eax,%eax
80103a43:	0f 85 9b fe ff ff    	jne    801038e4 <mpinit+0x54>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	68 82 8b 10 80       	push   $0x80108b82
80103a58:	e8 33 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	68 9c 8b 10 80       	push   $0x80108b9c
80103a65:	e8 26 c9 ff ff       	call   80100390 <panic>
80103a6a:	66 90                	xchg   %ax,%ax
80103a6c:	66 90                	xchg   %ax,%ax
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a79:	ba 21 00 00 00       	mov    $0x21,%edx
80103a7e:	ee                   	out    %al,(%dx)
80103a7f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a84:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a85:	c3                   	ret    
80103a86:	66 90                	xchg   %ax,%ax
80103a88:	66 90                	xchg   %ax,%ax
80103a8a:	66 90                	xchg   %ax,%ax
80103a8c:	66 90                	xchg   %ax,%ax
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	57                   	push   %edi
80103a98:	56                   	push   %esi
80103a99:	53                   	push   %ebx
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103aa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103aa3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aa9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103aaf:	e8 ec d9 ff ff       	call   801014a0 <filealloc>
80103ab4:	89 03                	mov    %eax,(%ebx)
80103ab6:	85 c0                	test   %eax,%eax
80103ab8:	0f 84 ac 00 00 00    	je     80103b6a <pipealloc+0xda>
80103abe:	e8 dd d9 ff ff       	call   801014a0 <filealloc>
80103ac3:	89 06                	mov    %eax,(%esi)
80103ac5:	85 c0                	test   %eax,%eax
80103ac7:	0f 84 8b 00 00 00    	je     80103b58 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103acd:	e8 fe f1 ff ff       	call   80102cd0 <kalloc>
80103ad2:	89 c7                	mov    %eax,%edi
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	0f 84 b4 00 00 00    	je     80103b90 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103adc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ae3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ae6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ae9:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
80103af0:	00 00 00 
  p->nwrite = 0;
80103af3:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103afa:	00 00 00 
  p->nread = 0;
80103afd:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b04:	00 00 00 
  initlock(&p->lock, "pipe");
80103b07:	68 bb 8b 10 80       	push   $0x80108bbb
80103b0c:	50                   	push   %eax
80103b0d:	e8 1e 1b 00 00       	call   80105630 <initlock>
  (*f0)->type = FD_PIPE;
80103b12:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b14:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b1d:	8b 03                	mov    (%ebx),%eax
80103b1f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b23:	8b 03                	mov    (%ebx),%eax
80103b25:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b29:	8b 03                	mov    (%ebx),%eax
80103b2b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b2e:	8b 06                	mov    (%esi),%eax
80103b30:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b36:	8b 06                	mov    (%esi),%eax
80103b38:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b3c:	8b 06                	mov    (%esi),%eax
80103b3e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b42:	8b 06                	mov    (%esi),%eax
80103b44:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b4a:	31 c0                	xor    %eax,%eax
}
80103b4c:	5b                   	pop    %ebx
80103b4d:	5e                   	pop    %esi
80103b4e:	5f                   	pop    %edi
80103b4f:	5d                   	pop    %ebp
80103b50:	c3                   	ret    
80103b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b58:	8b 03                	mov    (%ebx),%eax
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	74 1e                	je     80103b7c <pipealloc+0xec>
    fileclose(*f0);
80103b5e:	83 ec 0c             	sub    $0xc,%esp
80103b61:	50                   	push   %eax
80103b62:	e8 f9 d9 ff ff       	call   80101560 <fileclose>
80103b67:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b6a:	8b 06                	mov    (%esi),%eax
80103b6c:	85 c0                	test   %eax,%eax
80103b6e:	74 0c                	je     80103b7c <pipealloc+0xec>
    fileclose(*f1);
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	50                   	push   %eax
80103b74:	e8 e7 d9 ff ff       	call   80101560 <fileclose>
80103b79:	83 c4 10             	add    $0x10,%esp
}
80103b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b84:	5b                   	pop    %ebx
80103b85:	5e                   	pop    %esi
80103b86:	5f                   	pop    %edi
80103b87:	5d                   	pop    %ebp
80103b88:	c3                   	ret    
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b90:	8b 03                	mov    (%ebx),%eax
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 c8                	jne    80103b5e <pipealloc+0xce>
80103b96:	eb d2                	jmp    80103b6a <pipealloc+0xda>
80103b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ba0:	f3 0f 1e fb          	endbr32 
80103ba4:	55                   	push   %ebp
80103ba5:	89 e5                	mov    %esp,%ebp
80103ba7:	56                   	push   %esi
80103ba8:	53                   	push   %ebx
80103ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bac:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103baf:	83 ec 0c             	sub    $0xc,%esp
80103bb2:	53                   	push   %ebx
80103bb3:	e8 08 1c 00 00       	call   801057c0 <acquire>
  if(writable){
80103bb8:	83 c4 10             	add    $0x10,%esp
80103bbb:	85 f6                	test   %esi,%esi
80103bbd:	74 41                	je     80103c00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bbf:	83 ec 0c             	sub    $0xc,%esp
80103bc2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->writeopen = 0;
80103bc8:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
80103bcf:	00 00 00 
    wakeup(&p->nread);
80103bd2:	50                   	push   %eax
80103bd3:	e8 f8 0e 00 00       	call   80104ad0 <wakeup>
80103bd8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bdb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103be1:	85 d2                	test   %edx,%edx
80103be3:	75 0a                	jne    80103bef <pipeclose+0x4f>
80103be5:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
80103beb:	85 c0                	test   %eax,%eax
80103bed:	74 31                	je     80103c20 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103bef:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf5:	5b                   	pop    %ebx
80103bf6:	5e                   	pop    %esi
80103bf7:	5d                   	pop    %ebp
    release(&p->lock);
80103bf8:	e9 b3 1c 00 00       	jmp    801058b0 <release>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
    p->readopen = 0;
80103c09:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c10:	00 00 00 
    wakeup(&p->nwrite);
80103c13:	50                   	push   %eax
80103c14:	e8 b7 0e 00 00       	call   80104ad0 <wakeup>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	eb bd                	jmp    80103bdb <pipeclose+0x3b>
80103c1e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	53                   	push   %ebx
80103c24:	e8 87 1c 00 00       	call   801058b0 <release>
    kfree((char*)p);
80103c29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c2c:	83 c4 10             	add    $0x10,%esp
}
80103c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c32:	5b                   	pop    %ebx
80103c33:	5e                   	pop    %esi
80103c34:	5d                   	pop    %ebp
    kfree((char*)p);
80103c35:	e9 d6 ee ff ff       	jmp    80102b10 <kfree>
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c40:	f3 0f 1e fb          	endbr32 
80103c44:	55                   	push   %ebp
80103c45:	89 e5                	mov    %esp,%ebp
80103c47:	57                   	push   %edi
80103c48:	56                   	push   %esi
80103c49:	53                   	push   %ebx
80103c4a:	83 ec 28             	sub    $0x28,%esp
80103c4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c50:	53                   	push   %ebx
80103c51:	e8 6a 1b 00 00       	call   801057c0 <acquire>
  for(i = 0; i < n; i++){
80103c56:	8b 45 10             	mov    0x10(%ebp),%eax
80103c59:	83 c4 10             	add    $0x10,%esp
80103c5c:	85 c0                	test   %eax,%eax
80103c5e:	0f 8e bc 00 00 00    	jle    80103d20 <pipewrite+0xe0>
80103c64:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c67:	8b 8b 3c 02 00 00    	mov    0x23c(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c6d:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
80103c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c76:	03 45 10             	add    0x10(%ebp),%eax
80103c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c7c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c82:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c88:	89 ca                	mov    %ecx,%edx
80103c8a:	05 00 02 00 00       	add    $0x200,%eax
80103c8f:	39 c1                	cmp    %eax,%ecx
80103c91:	74 3b                	je     80103cce <pipewrite+0x8e>
80103c93:	eb 63                	jmp    80103cf8 <pipewrite+0xb8>
80103c95:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c98:	e8 83 04 00 00       	call   80104120 <myproc>
80103c9d:	8b 48 24             	mov    0x24(%eax),%ecx
80103ca0:	85 c9                	test   %ecx,%ecx
80103ca2:	75 34                	jne    80103cd8 <pipewrite+0x98>
      wakeup(&p->nread);
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	57                   	push   %edi
80103ca8:	e8 23 0e 00 00       	call   80104ad0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cad:	58                   	pop    %eax
80103cae:	5a                   	pop    %edx
80103caf:	53                   	push   %ebx
80103cb0:	56                   	push   %esi
80103cb1:	e8 5a 0c 00 00       	call   80104910 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cb6:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103cbc:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103cc2:	83 c4 10             	add    $0x10,%esp
80103cc5:	05 00 02 00 00       	add    $0x200,%eax
80103cca:	39 c2                	cmp    %eax,%edx
80103ccc:	75 2a                	jne    80103cf8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103cce:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	75 c0                	jne    80103c98 <pipewrite+0x58>
        release(&p->lock);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	53                   	push   %ebx
80103cdc:	e8 cf 1b 00 00       	call   801058b0 <release>
        return -1;
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cec:	5b                   	pop    %ebx
80103ced:	5e                   	pop    %esi
80103cee:	5f                   	pop    %edi
80103cef:	5d                   	pop    %ebp
80103cf0:	c3                   	ret    
80103cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103cf8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103cfb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cfe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d04:	89 8b 3c 02 00 00    	mov    %ecx,0x23c(%ebx)
80103d0a:	0f b6 06             	movzbl (%esi),%eax
80103d0d:	83 c6 01             	add    $0x1,%esi
80103d10:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103d13:	88 44 13 38          	mov    %al,0x38(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d17:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d1a:	0f 85 5c ff ff ff    	jne    80103c7c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d20:	83 ec 0c             	sub    $0xc,%esp
80103d23:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d29:	50                   	push   %eax
80103d2a:	e8 a1 0d 00 00       	call   80104ad0 <wakeup>
  release(&p->lock);
80103d2f:	89 1c 24             	mov    %ebx,(%esp)
80103d32:	e8 79 1b 00 00       	call   801058b0 <release>
  return n;
80103d37:	8b 45 10             	mov    0x10(%ebp),%eax
80103d3a:	83 c4 10             	add    $0x10,%esp
80103d3d:	eb aa                	jmp    80103ce9 <pipewrite+0xa9>
80103d3f:	90                   	nop

80103d40 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	57                   	push   %edi
80103d48:	56                   	push   %esi
80103d49:	53                   	push   %ebx
80103d4a:	83 ec 18             	sub    $0x18,%esp
80103d4d:	8b 75 08             	mov    0x8(%ebp),%esi
80103d50:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d53:	56                   	push   %esi
80103d54:	8d 9e 38 02 00 00    	lea    0x238(%esi),%ebx
80103d5a:	e8 61 1a 00 00       	call   801057c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d5f:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d65:	83 c4 10             	add    $0x10,%esp
80103d68:	39 86 3c 02 00 00    	cmp    %eax,0x23c(%esi)
80103d6e:	74 33                	je     80103da3 <piperead+0x63>
80103d70:	eb 3b                	jmp    80103dad <piperead+0x6d>
80103d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103d78:	e8 a3 03 00 00       	call   80104120 <myproc>
80103d7d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d80:	85 c9                	test   %ecx,%ecx
80103d82:	0f 85 88 00 00 00    	jne    80103e10 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d88:	83 ec 08             	sub    $0x8,%esp
80103d8b:	56                   	push   %esi
80103d8c:	53                   	push   %ebx
80103d8d:	e8 7e 0b 00 00       	call   80104910 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d92:	8b 86 3c 02 00 00    	mov    0x23c(%esi),%eax
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103da1:	75 0a                	jne    80103dad <piperead+0x6d>
80103da3:	8b 86 44 02 00 00    	mov    0x244(%esi),%eax
80103da9:	85 c0                	test   %eax,%eax
80103dab:	75 cb                	jne    80103d78 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dad:	8b 55 10             	mov    0x10(%ebp),%edx
80103db0:	31 db                	xor    %ebx,%ebx
80103db2:	85 d2                	test   %edx,%edx
80103db4:	7f 28                	jg     80103dde <piperead+0x9e>
80103db6:	eb 34                	jmp    80103dec <piperead+0xac>
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103dc0:	8d 48 01             	lea    0x1(%eax),%ecx
80103dc3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103dc8:	89 8e 38 02 00 00    	mov    %ecx,0x238(%esi)
80103dce:	0f b6 44 06 38       	movzbl 0x38(%esi,%eax,1),%eax
80103dd3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dd6:	83 c3 01             	add    $0x1,%ebx
80103dd9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103ddc:	74 0e                	je     80103dec <piperead+0xac>
    if(p->nread == p->nwrite)
80103dde:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103de4:	3b 86 3c 02 00 00    	cmp    0x23c(%esi),%eax
80103dea:	75 d4                	jne    80103dc0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103dec:	83 ec 0c             	sub    $0xc,%esp
80103def:	8d 86 3c 02 00 00    	lea    0x23c(%esi),%eax
80103df5:	50                   	push   %eax
80103df6:	e8 d5 0c 00 00       	call   80104ad0 <wakeup>
  release(&p->lock);
80103dfb:	89 34 24             	mov    %esi,(%esp)
80103dfe:	e8 ad 1a 00 00       	call   801058b0 <release>
  return i;
80103e03:	83 c4 10             	add    $0x10,%esp
}
80103e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e09:	89 d8                	mov    %ebx,%eax
80103e0b:	5b                   	pop    %ebx
80103e0c:	5e                   	pop    %esi
80103e0d:	5f                   	pop    %edi
80103e0e:	5d                   	pop    %ebp
80103e0f:	c3                   	ret    
      release(&p->lock);
80103e10:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e18:	56                   	push   %esi
80103e19:	e8 92 1a 00 00       	call   801058b0 <release>
      return -1;
80103e1e:	83 c4 10             	add    $0x10,%esp
}
80103e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e24:	89 d8                	mov    %ebx,%eax
80103e26:	5b                   	pop    %ebx
80103e27:	5e                   	pop    %esi
80103e28:	5f                   	pop    %edi
80103e29:	5d                   	pop    %ebp
80103e2a:	c3                   	ret    
80103e2b:	66 90                	xchg   %ax,%ax
80103e2d:	66 90                	xchg   %ax,%ax
80103e2f:	90                   	nop

80103e30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103e3a:	68 80 60 11 80       	push   $0x80116080
80103e3f:	e8 6c 1a 00 00       	call   801058b0 <release>

  if (first) {
80103e44:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	85 c0                	test   %eax,%eax
80103e4e:	75 08                	jne    80103e58 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e50:	c9                   	leave  
80103e51:	c3                   	ret    
80103e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103e58:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103e5f:	00 00 00 
    iinit(ROOTDEV);
80103e62:	83 ec 0c             	sub    $0xc,%esp
80103e65:	6a 01                	push   $0x1
80103e67:	e8 74 dd ff ff       	call   80101be0 <iinit>
    initlog(ROOTDEV);
80103e6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e73:	e8 b8 f4 ff ff       	call   80103330 <initlog>
}
80103e78:	83 c4 10             	add    $0x10,%esp
80103e7b:	c9                   	leave  
80103e7c:	c3                   	ret    
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <get_time>:
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	53                   	push   %ebx
80103e88:	83 ec 10             	sub    $0x10,%esp
  acquire(&tickslock);
80103e8b:	68 c0 a5 11 80       	push   $0x8011a5c0
80103e90:	e8 2b 19 00 00       	call   801057c0 <acquire>
  ticks0 = ticks;
80103e95:	8b 1d 00 ae 11 80    	mov    0x8011ae00,%ebx
  release(&tickslock);
80103e9b:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
80103ea2:	e8 09 1a 00 00       	call   801058b0 <release>
}
80103ea7:	89 d8                	mov    %ebx,%eax
80103ea9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eac:	c9                   	leave  
80103ead:	c3                   	ret    
80103eae:	66 90                	xchg   %ax,%ax

80103eb0 <rand_int>:
{
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	56                   	push   %esi
80103eb8:	53                   	push   %ebx
80103eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&tickslock);
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	68 c0 a5 11 80       	push   $0x8011a5c0
80103ec4:	e8 f7 18 00 00       	call   801057c0 <acquire>
  rand = (ticks * ticks * ticks * 71413) % (high - low + 1) + low;
80103ec9:	8b 35 00 ae 11 80    	mov    0x8011ae00,%esi
  release(&tickslock);
80103ecf:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
80103ed6:	e8 d5 19 00 00       	call   801058b0 <release>
  rand = (ticks * ticks * ticks * 71413) % (high - low + 1) + low;
80103edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ede:	31 d2                	xor    %edx,%edx
}
80103ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  rand = (ticks * ticks * ticks * 71413) % (high - low + 1) + low;
80103ee3:	89 f0                	mov    %esi,%eax
80103ee5:	0f af c6             	imul   %esi,%eax
80103ee8:	29 d9                	sub    %ebx,%ecx
80103eea:	83 c1 01             	add    $0x1,%ecx
80103eed:	0f af c6             	imul   %esi,%eax
80103ef0:	69 c0 f5 16 01 00    	imul   $0x116f5,%eax,%eax
80103ef6:	f7 f1                	div    %ecx
80103ef8:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
}
80103efb:	5b                   	pop    %ebx
80103efc:	5e                   	pop    %esi
80103efd:	5d                   	pop    %ebp
80103efe:	c3                   	ret    
80103eff:	90                   	nop

80103f00 <allocproc>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f05:	bb b8 60 11 80       	mov    $0x801160b8,%ebx
  acquire(&ptable.lock);
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 80 60 11 80       	push   $0x80116080
80103f12:	e8 a9 18 00 00       	call   801057c0 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	eb 16                	jmp    80103f32 <allocproc+0x32>
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f20:	81 c3 14 01 00 00    	add    $0x114,%ebx
80103f26:	81 fb b8 a5 11 80    	cmp    $0x8011a5b8,%ebx
80103f2c:	0f 84 06 01 00 00    	je     80104038 <allocproc+0x138>
    if(p->state == UNUSED)
80103f32:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103f35:	85 c9                	test   %ecx,%ecx
80103f37:	75 e7                	jne    80103f20 <allocproc+0x20>
  p->pid = nextpid++;
80103f39:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->state = EMBRYO;
80103f3e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103f45:	8d 50 01             	lea    0x1(%eax),%edx
80103f48:	89 43 10             	mov    %eax,0x10(%ebx)
  for (int i_ = 0; i_ < 30; i_++)
80103f4b:	8d 43 7c             	lea    0x7c(%ebx),%eax
  p->pid = nextpid++;
80103f4e:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80103f54:	8d 93 f4 00 00 00    	lea    0xf4(%ebx),%edx
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p->call_count[i_] = 0;
80103f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (int i_ = 0; i_ < 30; i_++)
80103f66:	83 c0 04             	add    $0x4,%eax
80103f69:	39 c2                	cmp    %eax,%edx
80103f6b:	75 f3                	jne    80103f60 <allocproc+0x60>
  p->qnum = 2; // default
80103f6d:	c7 83 f4 00 00 00 02 	movl   $0x2,0xf4(%ebx)
80103f74:	00 00 00 
  acquire(&tickslock);
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 c0 a5 11 80       	push   $0x8011a5c0
80103f7f:	e8 3c 18 00 00       	call   801057c0 <acquire>
  ticks0 = ticks;
80103f84:	8b 35 00 ae 11 80    	mov    0x8011ae00,%esi
  release(&tickslock);
80103f8a:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
80103f91:	e8 1a 19 00 00       	call   801058b0 <release>
  p->cycles = 0;
80103f96:	c7 83 00 01 00 00 00 	movl   $0x0,0x100(%ebx)
80103f9d:	00 00 00 
  p->arrival_time = get_time();
80103fa0:	89 b3 f8 00 00 00    	mov    %esi,0xf8(%ebx)
  p->wait_cycles = 0;
80103fa6:	c7 83 10 01 00 00 00 	movl   $0x0,0x110(%ebx)
80103fad:	00 00 00 
  p->arrival_time_ratio = 1;
80103fb0:	c7 83 fc 00 00 00 01 	movl   $0x1,0xfc(%ebx)
80103fb7:	00 00 00 
  p->cycles_ratio = 1;
80103fba:	c7 83 04 01 00 00 01 	movl   $0x1,0x104(%ebx)
80103fc1:	00 00 00 
  p->priority = rand_int(1, 1000);
80103fc4:	58                   	pop    %eax
80103fc5:	5a                   	pop    %edx
80103fc6:	68 e8 03 00 00       	push   $0x3e8
80103fcb:	6a 01                	push   $0x1
80103fcd:	e8 de fe ff ff       	call   80103eb0 <rand_int>
  p->priority_ratio = 1;
80103fd2:	c7 83 0c 01 00 00 01 	movl   $0x1,0x10c(%ebx)
80103fd9:	00 00 00 
  p->priority = rand_int(1, 1000);
80103fdc:	89 83 08 01 00 00    	mov    %eax,0x108(%ebx)
  release(&ptable.lock);
80103fe2:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80103fe9:	e8 c2 18 00 00       	call   801058b0 <release>
  if((p->kstack = kalloc()) == 0){
80103fee:	e8 dd ec ff ff       	call   80102cd0 <kalloc>
80103ff3:	83 c4 10             	add    $0x10,%esp
80103ff6:	89 43 08             	mov    %eax,0x8(%ebx)
80103ff9:	85 c0                	test   %eax,%eax
80103ffb:	74 56                	je     80104053 <allocproc+0x153>
  sp -= sizeof *p->tf;
80103ffd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80104003:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104006:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010400b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010400e:	c7 40 14 2b 6e 10 80 	movl   $0x80106e2b,0x14(%eax)
  p->context = (struct context*)sp;
80104015:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104018:	6a 14                	push   $0x14
8010401a:	6a 00                	push   $0x0
8010401c:	50                   	push   %eax
8010401d:	e8 ee 18 00 00       	call   80105910 <memset>
  p->context->eip = (uint)forkret;
80104022:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
80104025:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104028:	c7 40 10 30 3e 10 80 	movl   $0x80103e30,0x10(%eax)
}
8010402f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104032:	89 d8                	mov    %ebx,%eax
80104034:	5b                   	pop    %ebx
80104035:	5e                   	pop    %esi
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
  release(&ptable.lock);
80104038:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010403b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010403d:	68 80 60 11 80       	push   $0x80116080
80104042:	e8 69 18 00 00       	call   801058b0 <release>
  return 0;
80104047:	83 c4 10             	add    $0x10,%esp
}
8010404a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010404d:	89 d8                	mov    %ebx,%eax
8010404f:	5b                   	pop    %ebx
80104050:	5e                   	pop    %esi
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
    p->state = UNUSED;
80104053:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
8010405a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010405d:	31 db                	xor    %ebx,%ebx
}
8010405f:	89 d8                	mov    %ebx,%eax
80104061:	5b                   	pop    %ebx
80104062:	5e                   	pop    %esi
80104063:	5d                   	pop    %ebp
80104064:	c3                   	ret    
80104065:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104070 <pinit>:
{
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010407a:	68 c0 8b 10 80       	push   $0x80108bc0
8010407f:	68 80 60 11 80       	push   $0x80116080
80104084:	e8 a7 15 00 00       	call   80105630 <initlock>
}
80104089:	83 c4 10             	add    $0x10,%esp
8010408c:	c9                   	leave  
8010408d:	c3                   	ret    
8010408e:	66 90                	xchg   %ax,%ax

80104090 <mycpu>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	56                   	push   %esi
80104098:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104099:	9c                   	pushf  
8010409a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010409b:	f6 c4 02             	test   $0x2,%ah
8010409e:	75 4a                	jne    801040ea <mycpu+0x5a>
  apicid = lapicid();
801040a0:	e8 9b ee ff ff       	call   80102f40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801040a5:	8b 35 e0 53 11 80    	mov    0x801153e0,%esi
  apicid = lapicid();
801040ab:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801040ad:	85 f6                	test   %esi,%esi
801040af:	7e 2c                	jle    801040dd <mycpu+0x4d>
801040b1:	31 d2                	xor    %edx,%edx
801040b3:	eb 0a                	jmp    801040bf <mycpu+0x2f>
801040b5:	8d 76 00             	lea    0x0(%esi),%esi
801040b8:	83 c2 01             	add    $0x1,%edx
801040bb:	39 f2                	cmp    %esi,%edx
801040bd:	74 1e                	je     801040dd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801040bf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801040c5:	0f b6 81 60 4e 11 80 	movzbl -0x7feeb1a0(%ecx),%eax
801040cc:	39 d8                	cmp    %ebx,%eax
801040ce:	75 e8                	jne    801040b8 <mycpu+0x28>
}
801040d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801040d3:	8d 81 60 4e 11 80    	lea    -0x7feeb1a0(%ecx),%eax
}
801040d9:	5b                   	pop    %ebx
801040da:	5e                   	pop    %esi
801040db:	5d                   	pop    %ebp
801040dc:	c3                   	ret    
  panic("unknown apicid\n");
801040dd:	83 ec 0c             	sub    $0xc,%esp
801040e0:	68 c7 8b 10 80       	push   $0x80108bc7
801040e5:	e8 a6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 54 8d 10 80       	push   $0x80108d54
801040f2:	e8 99 c2 ff ff       	call   80100390 <panic>
801040f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fe:	66 90                	xchg   %ax,%ax

80104100 <cpuid>:
cpuid() {
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010410a:	e8 81 ff ff ff       	call   80104090 <mycpu>
}
8010410f:	c9                   	leave  
  return mycpu()-cpus;
80104110:	2d 60 4e 11 80       	sub    $0x80114e60,%eax
80104115:	c1 f8 04             	sar    $0x4,%eax
80104118:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010411e:	c3                   	ret    
8010411f:	90                   	nop

80104120 <myproc>:
myproc(void) {
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	53                   	push   %ebx
80104128:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010412b:	e8 90 15 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104130:	e8 5b ff ff ff       	call   80104090 <mycpu>
  p = c->proc;
80104135:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413b:	e8 d0 15 00 00       	call   80105710 <popcli>
}
80104140:	83 c4 04             	add    $0x4,%esp
80104143:	89 d8                	mov    %ebx,%eax
80104145:	5b                   	pop    %ebx
80104146:	5d                   	pop    %ebp
80104147:	c3                   	ret    
80104148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop

80104150 <userinit>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	53                   	push   %ebx
80104158:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010415b:	e8 a0 fd ff ff       	call   80103f00 <allocproc>
80104160:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104162:	a3 fc c5 10 80       	mov    %eax,0x8010c5fc
  if((p->pgdir = setupkvm()) == 0)
80104167:	e8 84 42 00 00       	call   801083f0 <setupkvm>
8010416c:	89 43 04             	mov    %eax,0x4(%ebx)
8010416f:	85 c0                	test   %eax,%eax
80104171:	0f 84 bd 00 00 00    	je     80104234 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104177:	83 ec 04             	sub    $0x4,%esp
8010417a:	68 2c 00 00 00       	push   $0x2c
8010417f:	68 60 c4 10 80       	push   $0x8010c460
80104184:	50                   	push   %eax
80104185:	e8 36 3f 00 00       	call   801080c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010418a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010418d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104193:	6a 4c                	push   $0x4c
80104195:	6a 00                	push   $0x0
80104197:	ff 73 18             	pushl  0x18(%ebx)
8010419a:	e8 71 17 00 00       	call   80105910 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010419f:	8b 43 18             	mov    0x18(%ebx),%eax
801041a2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041a7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041aa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041af:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041b3:	8b 43 18             	mov    0x18(%ebx),%eax
801041b6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041ba:	8b 43 18             	mov    0x18(%ebx),%eax
801041bd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041c1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041c5:	8b 43 18             	mov    0x18(%ebx),%eax
801041c8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041cc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041d0:	8b 43 18             	mov    0x18(%ebx),%eax
801041d3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041da:	8b 43 18             	mov    0x18(%ebx),%eax
801041dd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041e4:	8b 43 18             	mov    0x18(%ebx),%eax
801041e7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041ee:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041f1:	6a 10                	push   $0x10
801041f3:	68 f0 8b 10 80       	push   $0x80108bf0
801041f8:	50                   	push   %eax
801041f9:	e8 d2 18 00 00       	call   80105ad0 <safestrcpy>
  p->cwd = namei("/");
801041fe:	c7 04 24 f9 8b 10 80 	movl   $0x80108bf9,(%esp)
80104205:	e8 c6 e4 ff ff       	call   801026d0 <namei>
8010420a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010420d:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80104214:	e8 a7 15 00 00       	call   801057c0 <acquire>
  p->state = RUNNABLE;
80104219:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104220:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80104227:	e8 84 16 00 00       	call   801058b0 <release>
}
8010422c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	c9                   	leave  
80104233:	c3                   	ret    
    panic("userinit: out of memory?");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 d7 8b 10 80       	push   $0x80108bd7
8010423c:	e8 4f c1 ff ff       	call   80100390 <panic>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop

80104250 <growproc>:
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	56                   	push   %esi
80104258:	53                   	push   %ebx
80104259:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010425c:	e8 5f 14 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104261:	e8 2a fe ff ff       	call   80104090 <mycpu>
  p = c->proc;
80104266:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426c:	e8 9f 14 00 00       	call   80105710 <popcli>
  sz = curproc->sz;
80104271:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104273:	85 f6                	test   %esi,%esi
80104275:	7f 19                	jg     80104290 <growproc+0x40>
  } else if(n < 0){
80104277:	75 37                	jne    801042b0 <growproc+0x60>
  switchuvm(curproc);
80104279:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010427c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010427e:	53                   	push   %ebx
8010427f:	e8 2c 3d 00 00       	call   80107fb0 <switchuvm>
  return 0;
80104284:	83 c4 10             	add    $0x10,%esp
80104287:	31 c0                	xor    %eax,%eax
}
80104289:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010428c:	5b                   	pop    %ebx
8010428d:	5e                   	pop    %esi
8010428e:	5d                   	pop    %ebp
8010428f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104290:	83 ec 04             	sub    $0x4,%esp
80104293:	01 c6                	add    %eax,%esi
80104295:	56                   	push   %esi
80104296:	50                   	push   %eax
80104297:	ff 73 04             	pushl  0x4(%ebx)
8010429a:	e8 71 3f 00 00       	call   80108210 <allocuvm>
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	85 c0                	test   %eax,%eax
801042a4:	75 d3                	jne    80104279 <growproc+0x29>
      return -1;
801042a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042ab:	eb dc                	jmp    80104289 <growproc+0x39>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042b0:	83 ec 04             	sub    $0x4,%esp
801042b3:	01 c6                	add    %eax,%esi
801042b5:	56                   	push   %esi
801042b6:	50                   	push   %eax
801042b7:	ff 73 04             	pushl  0x4(%ebx)
801042ba:	e8 81 40 00 00       	call   80108340 <deallocuvm>
801042bf:	83 c4 10             	add    $0x10,%esp
801042c2:	85 c0                	test   %eax,%eax
801042c4:	75 b3                	jne    80104279 <growproc+0x29>
801042c6:	eb de                	jmp    801042a6 <growproc+0x56>
801042c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042cf:	90                   	nop

801042d0 <fork>:
{
801042d0:	f3 0f 1e fb          	endbr32 
801042d4:	55                   	push   %ebp
801042d5:	89 e5                	mov    %esp,%ebp
801042d7:	57                   	push   %edi
801042d8:	56                   	push   %esi
801042d9:	53                   	push   %ebx
801042da:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042dd:	e8 de 13 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801042e2:	e8 a9 fd ff ff       	call   80104090 <mycpu>
  p = c->proc;
801042e7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ed:	e8 1e 14 00 00       	call   80105710 <popcli>
  if((np = allocproc()) == 0){
801042f2:	e8 09 fc ff ff       	call   80103f00 <allocproc>
801042f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042fa:	85 c0                	test   %eax,%eax
801042fc:	0f 84 bb 00 00 00    	je     801043bd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104302:	83 ec 08             	sub    $0x8,%esp
80104305:	ff 33                	pushl  (%ebx)
80104307:	89 c7                	mov    %eax,%edi
80104309:	ff 73 04             	pushl  0x4(%ebx)
8010430c:	e8 af 41 00 00       	call   801084c0 <copyuvm>
80104311:	83 c4 10             	add    $0x10,%esp
80104314:	89 47 04             	mov    %eax,0x4(%edi)
80104317:	85 c0                	test   %eax,%eax
80104319:	0f 84 a5 00 00 00    	je     801043c4 <fork+0xf4>
  np->sz = curproc->sz;
8010431f:	8b 03                	mov    (%ebx),%eax
80104321:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104324:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104326:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104329:	89 c8                	mov    %ecx,%eax
8010432b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010432e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104333:	8b 73 18             	mov    0x18(%ebx),%esi
80104336:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104338:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010433a:	8b 40 18             	mov    0x18(%eax),%eax
8010433d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104348:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010434c:	85 c0                	test   %eax,%eax
8010434e:	74 13                	je     80104363 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104350:	83 ec 0c             	sub    $0xc,%esp
80104353:	50                   	push   %eax
80104354:	e8 b7 d1 ff ff       	call   80101510 <filedup>
80104359:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010435c:	83 c4 10             	add    $0x10,%esp
8010435f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104363:	83 c6 01             	add    $0x1,%esi
80104366:	83 fe 10             	cmp    $0x10,%esi
80104369:	75 dd                	jne    80104348 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104371:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104374:	e8 57 da ff ff       	call   80101dd0 <idup>
80104379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010437c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010437f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104382:	8d 47 6c             	lea    0x6c(%edi),%eax
80104385:	6a 10                	push   $0x10
80104387:	53                   	push   %ebx
80104388:	50                   	push   %eax
80104389:	e8 42 17 00 00       	call   80105ad0 <safestrcpy>
  pid = np->pid;
8010438e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104391:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
80104398:	e8 23 14 00 00       	call   801057c0 <acquire>
  np->state = RUNNABLE;
8010439d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801043a4:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
801043ab:	e8 00 15 00 00       	call   801058b0 <release>
  return pid;
801043b0:	83 c4 10             	add    $0x10,%esp
}
801043b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b6:	89 d8                	mov    %ebx,%eax
801043b8:	5b                   	pop    %ebx
801043b9:	5e                   	pop    %esi
801043ba:	5f                   	pop    %edi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
    return -1;
801043bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043c2:	eb ef                	jmp    801043b3 <fork+0xe3>
    kfree(np->kstack);
801043c4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043c7:	83 ec 0c             	sub    $0xc,%esp
801043ca:	ff 73 08             	pushl  0x8(%ebx)
801043cd:	e8 3e e7 ff ff       	call   80102b10 <kfree>
    np->kstack = 0;
801043d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801043d9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801043dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801043e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043e8:	eb c9                	jmp    801043b3 <fork+0xe3>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <rank_calc>:
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	53                   	push   %ebx
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return (p->priority * p->priority_ratio) +
801043fe:	8b 93 08 01 00 00    	mov    0x108(%ebx),%edx
80104404:	8b 8b 0c 01 00 00    	mov    0x10c(%ebx),%ecx
      (p->arrival_time * p->arrival_time_ratio) +
8010440a:	8b 83 f8 00 00 00    	mov    0xf8(%ebx),%eax
80104410:	0f af 83 fc 00 00 00 	imul   0xfc(%ebx),%eax
  return (p->priority * p->priority_ratio) +
80104417:	0f af ca             	imul   %edx,%ecx
8010441a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
      (p->cycles * p->cycles_ratio);
8010441d:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
80104423:	0f af 83 04 01 00 00 	imul   0x104(%ebx),%eax
      (p->arrival_time * p->arrival_time_ratio) +
8010442a:	01 d0                	add    %edx,%eax
8010442c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010442f:	db 45 f4             	fildl  -0xc(%ebp)
}
80104432:	83 c4 0c             	add    $0xc,%esp
80104435:	5b                   	pop    %ebx
80104436:	5d                   	pop    %ebp
80104437:	c3                   	ret    
80104438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443f:	90                   	nop

80104440 <find_process>:
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
80104445:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
{
8010444a:	89 e5                	mov    %esp,%ebp
8010444c:	57                   	push   %edi
8010444d:	56                   	push   %esi
8010444e:	53                   	push   %ebx
8010444f:	eb 13                	jmp    80104464 <find_process+0x24>
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
80104458:	05 14 01 00 00       	add    $0x114,%eax
8010445d:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104462:	74 24                	je     80104488 <find_process+0x48>
    if(p->state == RUNNABLE && p->qnum == 1) {
80104464:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104468:	75 ee                	jne    80104458 <find_process+0x18>
8010446a:	83 b8 f4 00 00 00 01 	cmpl   $0x1,0xf4(%eax)
80104471:	75 e5                	jne    80104458 <find_process+0x18>
    *flag = 1;
80104473:	8b 7d 08             	mov    0x8(%ebp),%edi
80104476:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
}
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5f                   	pop    %edi
8010447f:	5d                   	pop    %ebp
80104480:	c3                   	ret    
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int min_arrival_time = 1e6;
80104488:	be 40 42 0f 00       	mov    $0xf4240,%esi
  struct proc *first_p = 0;
8010448d:	31 c0                	xor    %eax,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448f:	ba b8 60 11 80       	mov    $0x801160b8,%edx
80104494:	eb 18                	jmp    801044ae <find_process+0x6e>
80104496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	81 c2 14 01 00 00    	add    $0x114,%edx
801044a6:	81 fa b8 a5 11 80    	cmp    $0x8011a5b8,%edx
801044ac:	74 32                	je     801044e0 <find_process+0xa0>
    if(p->state == RUNNABLE && p->qnum == 2) 
801044ae:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801044b2:	75 ec                	jne    801044a0 <find_process+0x60>
801044b4:	83 ba f4 00 00 00 02 	cmpl   $0x2,0xf4(%edx)
801044bb:	75 e3                	jne    801044a0 <find_process+0x60>
      if(p->arrival_time < min_arrival_time) 
801044bd:	8b 8a f8 00 00 00    	mov    0xf8(%edx),%ecx
801044c3:	39 f1                	cmp    %esi,%ecx
801044c5:	7d d9                	jge    801044a0 <find_process+0x60>
801044c7:	89 d0                	mov    %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044c9:	81 c2 14 01 00 00    	add    $0x114,%edx
      if(p->arrival_time < min_arrival_time) 
801044cf:	89 ce                	mov    %ecx,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d1:	81 fa b8 a5 11 80    	cmp    $0x8011a5b8,%edx
801044d7:	75 d5                	jne    801044ae <find_process+0x6e>
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(min_arrival_time != 1e6) 
801044e0:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
801044e6:	75 8b                	jne    80104473 <find_process+0x33>
  struct proc *min_p = 0;
801044e8:	31 ff                	xor    %edi,%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ea:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
801044ef:	eb 13                	jmp    80104504 <find_process+0xc4>
801044f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f8:	05 14 01 00 00       	add    $0x114,%eax
801044fd:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104502:	74 51                	je     80104555 <find_process+0x115>
    if(p->state == RUNNABLE && p->qnum == 3)
80104504:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104508:	75 ee                	jne    801044f8 <find_process+0xb8>
8010450a:	83 b8 f4 00 00 00 03 	cmpl   $0x3,0xf4(%eax)
80104511:	75 e5                	jne    801044f8 <find_process+0xb8>
  return (p->priority * p->priority_ratio) +
80104513:	8b 88 08 01 00 00    	mov    0x108(%eax),%ecx
80104519:	8b 98 0c 01 00 00    	mov    0x10c(%eax),%ebx
      (p->arrival_time * p->arrival_time_ratio) +
8010451f:	8b 90 f8 00 00 00    	mov    0xf8(%eax),%edx
80104525:	0f af 90 fc 00 00 00 	imul   0xfc(%eax),%edx
  return (p->priority * p->priority_ratio) +
8010452c:	0f af d9             	imul   %ecx,%ebx
8010452f:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
      (p->cycles * p->cycles_ratio);
80104532:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
80104538:	0f af 90 04 01 00 00 	imul   0x104(%eax),%edx
      (p->arrival_time * p->arrival_time_ratio) +
8010453f:	01 ca                	add    %ecx,%edx
      if (rank_calc(p) < min_rank)
80104541:	39 f2                	cmp    %esi,%edx
80104543:	7d b3                	jge    801044f8 <find_process+0xb8>
80104545:	89 c7                	mov    %eax,%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104547:	05 14 01 00 00       	add    $0x114,%eax
      if (rank_calc(p) < min_rank)
8010454c:	89 d6                	mov    %edx,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010454e:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104553:	75 af                	jne    80104504 <find_process+0xc4>
  if(min_rank != 1e6) 
80104555:	81 fe 40 42 0f 00    	cmp    $0xf4240,%esi
8010455b:	74 10                	je     8010456d <find_process+0x12d>
    *flag = 1;
8010455d:	8b 45 08             	mov    0x8(%ebp),%eax
80104560:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    return min_p;  
80104566:	89 f8                	mov    %edi,%eax
}
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5f                   	pop    %edi
8010456b:	5d                   	pop    %ebp
8010456c:	c3                   	ret    
  *flag = 0;
8010456d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104570:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
}
80104576:	5b                   	pop    %ebx
80104577:	5e                   	pop    %esi
80104578:	5f                   	pop    %edi
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
8010457b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010457f:	90                   	nop

80104580 <scheduler>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	57                   	push   %edi
80104588:	56                   	push   %esi
80104589:	8d 7d e4             	lea    -0x1c(%ebp),%edi
8010458c:	53                   	push   %ebx
8010458d:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80104590:	e8 fb fa ff ff       	call   80104090 <mycpu>
  c->proc = 0;
80104595:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010459c:	00 00 00 
  struct cpu *c = mycpu();
8010459f:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801045a1:	8d 40 04             	lea    0x4(%eax),%eax
801045a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801045a7:	eb 25                	jmp    801045ce <scheduler+0x4e>
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b0:	81 c6 14 01 00 00    	add    $0x114,%esi
801045b6:	81 fe b8 a5 11 80    	cmp    $0x8011a5b8,%esi
801045bc:	72 26                	jb     801045e4 <scheduler+0x64>
    release(&ptable.lock);
801045be:	83 ec 0c             	sub    $0xc,%esp
801045c1:	68 80 60 11 80       	push   $0x80116080
801045c6:	e8 e5 12 00 00       	call   801058b0 <release>
    sti();
801045cb:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801045ce:	fb                   	sti    
    acquire(&ptable.lock);
801045cf:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d2:	be b8 60 11 80       	mov    $0x801160b8,%esi
    acquire(&ptable.lock);
801045d7:	68 80 60 11 80       	push   $0x80116080
801045dc:	e8 df 11 00 00       	call   801057c0 <acquire>
801045e1:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
801045e4:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
801045e8:	75 c6                	jne    801045b0 <scheduler+0x30>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045ea:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
801045ef:	eb 2c                	jmp    8010461d <scheduler+0x9d>
801045f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->wait_cycles >= 8000 && p->state == RUNNABLE) {
801045f8:	83 f9 03             	cmp    $0x3,%ecx
801045fb:	75 14                	jne    80104611 <scheduler+0x91>
          p->wait_cycles = 0;
801045fd:	c7 80 10 01 00 00 00 	movl   $0x0,0x110(%eax)
80104604:	00 00 00 
          p->qnum = 1; // transfer this process to first queue
80104607:	c7 80 f4 00 00 00 01 	movl   $0x1,0xf4(%eax)
8010460e:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104611:	05 14 01 00 00       	add    $0x114,%eax
80104616:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
8010461b:	74 28                	je     80104645 <scheduler+0xc5>
        if(p->wait_cycles >= 8000 && p->state == RUNNABLE) {
8010461d:	8b 90 10 01 00 00    	mov    0x110(%eax),%edx
80104623:	8b 48 0c             	mov    0xc(%eax),%ecx
80104626:	81 fa 3f 1f 00 00    	cmp    $0x1f3f,%edx
8010462c:	7f ca                	jg     801045f8 <scheduler+0x78>
        } else if(p->state == RUNNABLE){
8010462e:	83 f9 03             	cmp    $0x3,%ecx
80104631:	75 de                	jne    80104611 <scheduler+0x91>
          p->wait_cycles++;
80104633:	83 c2 01             	add    $0x1,%edx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104636:	05 14 01 00 00       	add    $0x114,%eax
          p->wait_cycles++;
8010463b:	89 50 fc             	mov    %edx,-0x4(%eax)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463e:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104643:	75 d8                	jne    8010461d <scheduler+0x9d>
      p = find_process(&flag);
80104645:	83 ec 0c             	sub    $0xc,%esp
      int flag = 0;
80104648:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      p = find_process(&flag);
8010464f:	57                   	push   %edi
80104650:	e8 eb fd ff ff       	call   80104440 <find_process>
      c->proc = p;
80104655:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
      p = find_process(&flag);
8010465b:	89 c6                	mov    %eax,%esi
      switchuvm(p);
8010465d:	89 04 24             	mov    %eax,(%esp)
80104660:	e8 4b 39 00 00       	call   80107fb0 <switchuvm>
      p->state = RUNNING;
80104665:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      p->cycles += 0.1;
8010466c:	db 86 00 01 00 00    	fildl  0x100(%esi)
80104672:	d9 7d d6             	fnstcw -0x2a(%ebp)
80104675:	dc 05 48 8e 10 80    	faddl  0x80108e48
8010467b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
8010467f:	80 ce 0c             	or     $0xc,%dh
80104682:	66 89 55 d4          	mov    %dx,-0x2c(%ebp)
80104686:	d9 6d d4             	fldcw  -0x2c(%ebp)
80104689:	db 9e 00 01 00 00    	fistpl 0x100(%esi)
8010468f:	d9 6d d6             	fldcw  -0x2a(%ebp)
      p->wait_cycles = 0;
80104692:	c7 86 10 01 00 00 00 	movl   $0x0,0x110(%esi)
80104699:	00 00 00 
      swtch(&(c->scheduler), p->context);
8010469c:	58                   	pop    %eax
8010469d:	5a                   	pop    %edx
8010469e:	ff 76 1c             	pushl  0x1c(%esi)
801046a1:	ff 75 d0             	pushl  -0x30(%ebp)
801046a4:	e8 8a 14 00 00       	call   80105b33 <swtch>
      switchkvm();
801046a9:	e8 e2 38 00 00       	call   80107f90 <switchkvm>
      c->proc = 0;
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801046b8:	00 00 00 
801046bb:	e9 f0 fe ff ff       	jmp    801045b0 <scheduler+0x30>

801046c0 <sched>:
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	56                   	push   %esi
801046c8:	53                   	push   %ebx
  pushcli();
801046c9:	e8 f2 0f 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801046ce:	e8 bd f9 ff ff       	call   80104090 <mycpu>
  p = c->proc;
801046d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046d9:	e8 32 10 00 00       	call   80105710 <popcli>
  if(!holding(&ptable.lock))
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	68 80 60 11 80       	push   $0x80116080
801046e6:	e8 85 10 00 00       	call   80105770 <holding>
801046eb:	83 c4 10             	add    $0x10,%esp
801046ee:	85 c0                	test   %eax,%eax
801046f0:	74 4f                	je     80104741 <sched+0x81>
  if(mycpu()->ncli != 1)
801046f2:	e8 99 f9 ff ff       	call   80104090 <mycpu>
801046f7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801046fe:	75 68                	jne    80104768 <sched+0xa8>
  if(p->state == RUNNING)
80104700:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104704:	74 55                	je     8010475b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104706:	9c                   	pushf  
80104707:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104708:	f6 c4 02             	test   $0x2,%ah
8010470b:	75 41                	jne    8010474e <sched+0x8e>
  intena = mycpu()->intena;
8010470d:	e8 7e f9 ff ff       	call   80104090 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104712:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104715:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010471b:	e8 70 f9 ff ff       	call   80104090 <mycpu>
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	ff 70 04             	pushl  0x4(%eax)
80104726:	53                   	push   %ebx
80104727:	e8 07 14 00 00       	call   80105b33 <swtch>
  mycpu()->intena = intena;
8010472c:	e8 5f f9 ff ff       	call   80104090 <mycpu>
}
80104731:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104734:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010473a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010473d:	5b                   	pop    %ebx
8010473e:	5e                   	pop    %esi
8010473f:	5d                   	pop    %ebp
80104740:	c3                   	ret    
    panic("sched ptable.lock");
80104741:	83 ec 0c             	sub    $0xc,%esp
80104744:	68 fb 8b 10 80       	push   $0x80108bfb
80104749:	e8 42 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010474e:	83 ec 0c             	sub    $0xc,%esp
80104751:	68 27 8c 10 80       	push   $0x80108c27
80104756:	e8 35 bc ff ff       	call   80100390 <panic>
    panic("sched running");
8010475b:	83 ec 0c             	sub    $0xc,%esp
8010475e:	68 19 8c 10 80       	push   $0x80108c19
80104763:	e8 28 bc ff ff       	call   80100390 <panic>
    panic("sched locks");
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	68 0d 8c 10 80       	push   $0x80108c0d
80104770:	e8 1b bc ff ff       	call   80100390 <panic>
80104775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <exit>:
{
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	57                   	push   %edi
80104788:	56                   	push   %esi
80104789:	53                   	push   %ebx
8010478a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010478d:	e8 2e 0f 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104792:	e8 f9 f8 ff ff       	call   80104090 <mycpu>
  p = c->proc;
80104797:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010479d:	e8 6e 0f 00 00       	call   80105710 <popcli>
  if(curproc == initproc)
801047a2:	8d 5e 28             	lea    0x28(%esi),%ebx
801047a5:	8d 7e 68             	lea    0x68(%esi),%edi
801047a8:	39 35 fc c5 10 80    	cmp    %esi,0x8010c5fc
801047ae:	0f 84 fd 00 00 00    	je     801048b1 <exit+0x131>
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801047b8:	8b 03                	mov    (%ebx),%eax
801047ba:	85 c0                	test   %eax,%eax
801047bc:	74 12                	je     801047d0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801047be:	83 ec 0c             	sub    $0xc,%esp
801047c1:	50                   	push   %eax
801047c2:	e8 99 cd ff ff       	call   80101560 <fileclose>
      curproc->ofile[fd] = 0;
801047c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801047cd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801047d0:	83 c3 04             	add    $0x4,%ebx
801047d3:	39 df                	cmp    %ebx,%edi
801047d5:	75 e1                	jne    801047b8 <exit+0x38>
  begin_op();
801047d7:	e8 f4 eb ff ff       	call   801033d0 <begin_op>
  iput(curproc->cwd);
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	ff 76 68             	pushl  0x68(%esi)
801047e2:	e8 49 d7 ff ff       	call   80101f30 <iput>
  end_op();
801047e7:	e8 54 ec ff ff       	call   80103440 <end_op>
  curproc->cwd = 0;
801047ec:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801047f3:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
801047fa:	e8 c1 0f 00 00       	call   801057c0 <acquire>
  wakeup1(curproc->parent);
801047ff:	8b 56 14             	mov    0x14(%esi),%edx
80104802:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104805:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
8010480a:	eb 10                	jmp    8010481c <exit+0x9c>
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104810:	05 14 01 00 00       	add    $0x114,%eax
80104815:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
8010481a:	74 1e                	je     8010483a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010481c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104820:	75 ee                	jne    80104810 <exit+0x90>
80104822:	3b 50 20             	cmp    0x20(%eax),%edx
80104825:	75 e9                	jne    80104810 <exit+0x90>
      p->state = RUNNABLE;
80104827:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010482e:	05 14 01 00 00       	add    $0x114,%eax
80104833:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104838:	75 e2                	jne    8010481c <exit+0x9c>
      p->parent = initproc;
8010483a:	8b 0d fc c5 10 80    	mov    0x8010c5fc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104840:	ba b8 60 11 80       	mov    $0x801160b8,%edx
80104845:	eb 17                	jmp    8010485e <exit+0xde>
80104847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484e:	66 90                	xchg   %ax,%ax
80104850:	81 c2 14 01 00 00    	add    $0x114,%edx
80104856:	81 fa b8 a5 11 80    	cmp    $0x8011a5b8,%edx
8010485c:	74 3a                	je     80104898 <exit+0x118>
    if(p->parent == curproc){
8010485e:	39 72 14             	cmp    %esi,0x14(%edx)
80104861:	75 ed                	jne    80104850 <exit+0xd0>
      if(p->state == ZOMBIE)
80104863:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104867:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010486a:	75 e4                	jne    80104850 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010486c:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
80104871:	eb 11                	jmp    80104884 <exit+0x104>
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
80104878:	05 14 01 00 00       	add    $0x114,%eax
8010487d:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104882:	74 cc                	je     80104850 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104884:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104888:	75 ee                	jne    80104878 <exit+0xf8>
8010488a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010488d:	75 e9                	jne    80104878 <exit+0xf8>
      p->state = RUNNABLE;
8010488f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104896:	eb e0                	jmp    80104878 <exit+0xf8>
  curproc->state = ZOMBIE;
80104898:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010489f:	e8 1c fe ff ff       	call   801046c0 <sched>
  panic("zombie exit");
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	68 48 8c 10 80       	push   $0x80108c48
801048ac:	e8 df ba ff ff       	call   80100390 <panic>
    panic("init exiting");
801048b1:	83 ec 0c             	sub    $0xc,%esp
801048b4:	68 3b 8c 10 80       	push   $0x80108c3b
801048b9:	e8 d2 ba ff ff       	call   80100390 <panic>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <yield>:
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	53                   	push   %ebx
801048c8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801048cb:	68 80 60 11 80       	push   $0x80116080
801048d0:	e8 eb 0e 00 00       	call   801057c0 <acquire>
  pushcli();
801048d5:	e8 e6 0d 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801048da:	e8 b1 f7 ff ff       	call   80104090 <mycpu>
  p = c->proc;
801048df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048e5:	e8 26 0e 00 00       	call   80105710 <popcli>
  myproc()->state = RUNNABLE;
801048ea:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801048f1:	e8 ca fd ff ff       	call   801046c0 <sched>
  release(&ptable.lock);
801048f6:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
801048fd:	e8 ae 0f 00 00       	call   801058b0 <release>
}
80104902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104905:	83 c4 10             	add    $0x10,%esp
80104908:	c9                   	leave  
80104909:	c3                   	ret    
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104910 <sleep>:
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	57                   	push   %edi
80104918:	56                   	push   %esi
80104919:	53                   	push   %ebx
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104920:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104923:	e8 98 0d 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104928:	e8 63 f7 ff ff       	call   80104090 <mycpu>
  p = c->proc;
8010492d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104933:	e8 d8 0d 00 00       	call   80105710 <popcli>
  if(p == 0)
80104938:	85 db                	test   %ebx,%ebx
8010493a:	0f 84 83 00 00 00    	je     801049c3 <sleep+0xb3>
  if(lk == 0)
80104940:	85 f6                	test   %esi,%esi
80104942:	74 72                	je     801049b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104944:	81 fe 80 60 11 80    	cmp    $0x80116080,%esi
8010494a:	74 4c                	je     80104998 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	68 80 60 11 80       	push   $0x80116080
80104954:	e8 67 0e 00 00       	call   801057c0 <acquire>
    release(lk);
80104959:	89 34 24             	mov    %esi,(%esp)
8010495c:	e8 4f 0f 00 00       	call   801058b0 <release>
  p->chan = chan;
80104961:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104964:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010496b:	e8 50 fd ff ff       	call   801046c0 <sched>
  p->chan = 0;
80104970:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104977:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
8010497e:	e8 2d 0f 00 00       	call   801058b0 <release>
    acquire(lk);
80104983:	89 75 08             	mov    %esi,0x8(%ebp)
80104986:	83 c4 10             	add    $0x10,%esp
}
80104989:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010498c:	5b                   	pop    %ebx
8010498d:	5e                   	pop    %esi
8010498e:	5f                   	pop    %edi
8010498f:	5d                   	pop    %ebp
    acquire(lk);
80104990:	e9 2b 0e 00 00       	jmp    801057c0 <acquire>
80104995:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104998:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010499b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049a2:	e8 19 fd ff ff       	call   801046c0 <sched>
  p->chan = 0;
801049a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049b1:	5b                   	pop    %ebx
801049b2:	5e                   	pop    %esi
801049b3:	5f                   	pop    %edi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
    panic("sleep without lk");
801049b6:	83 ec 0c             	sub    $0xc,%esp
801049b9:	68 5a 8c 10 80       	push   $0x80108c5a
801049be:	e8 cd b9 ff ff       	call   80100390 <panic>
    panic("sleep");
801049c3:	83 ec 0c             	sub    $0xc,%esp
801049c6:	68 54 8c 10 80       	push   $0x80108c54
801049cb:	e8 c0 b9 ff ff       	call   80100390 <panic>

801049d0 <wait>:
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	56                   	push   %esi
801049d8:	53                   	push   %ebx
  pushcli();
801049d9:	e8 e2 0c 00 00       	call   801056c0 <pushcli>
  c = mycpu();
801049de:	e8 ad f6 ff ff       	call   80104090 <mycpu>
  p = c->proc;
801049e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049e9:	e8 22 0d 00 00       	call   80105710 <popcli>
  acquire(&ptable.lock);
801049ee:	83 ec 0c             	sub    $0xc,%esp
801049f1:	68 80 60 11 80       	push   $0x80116080
801049f6:	e8 c5 0d 00 00       	call   801057c0 <acquire>
801049fb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801049fe:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a00:	bb b8 60 11 80       	mov    $0x801160b8,%ebx
80104a05:	eb 17                	jmp    80104a1e <wait+0x4e>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax
80104a10:	81 c3 14 01 00 00    	add    $0x114,%ebx
80104a16:	81 fb b8 a5 11 80    	cmp    $0x8011a5b8,%ebx
80104a1c:	74 1e                	je     80104a3c <wait+0x6c>
      if(p->parent != curproc)
80104a1e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a21:	75 ed                	jne    80104a10 <wait+0x40>
      if(p->state == ZOMBIE){
80104a23:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a27:	74 37                	je     80104a60 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a29:	81 c3 14 01 00 00    	add    $0x114,%ebx
      havekids = 1;
80104a2f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a34:	81 fb b8 a5 11 80    	cmp    $0x8011a5b8,%ebx
80104a3a:	75 e2                	jne    80104a1e <wait+0x4e>
    if(!havekids || curproc->killed){
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	74 76                	je     80104ab6 <wait+0xe6>
80104a40:	8b 46 24             	mov    0x24(%esi),%eax
80104a43:	85 c0                	test   %eax,%eax
80104a45:	75 6f                	jne    80104ab6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a47:	83 ec 08             	sub    $0x8,%esp
80104a4a:	68 80 60 11 80       	push   $0x80116080
80104a4f:	56                   	push   %esi
80104a50:	e8 bb fe ff ff       	call   80104910 <sleep>
    havekids = 0;
80104a55:	83 c4 10             	add    $0x10,%esp
80104a58:	eb a4                	jmp    801049fe <wait+0x2e>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104a60:	83 ec 0c             	sub    $0xc,%esp
80104a63:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104a66:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a69:	e8 a2 e0 ff ff       	call   80102b10 <kfree>
        freevm(p->pgdir);
80104a6e:	5a                   	pop    %edx
80104a6f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a79:	e8 f2 38 00 00       	call   80108370 <freevm>
        release(&ptable.lock);
80104a7e:	c7 04 24 80 60 11 80 	movl   $0x80116080,(%esp)
        p->pid = 0;
80104a85:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a8c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a93:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a97:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a9e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104aa5:	e8 06 0e 00 00       	call   801058b0 <release>
        return pid;
80104aaa:	83 c4 10             	add    $0x10,%esp
}
80104aad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab0:	89 f0                	mov    %esi,%eax
80104ab2:	5b                   	pop    %ebx
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
      release(&ptable.lock);
80104ab6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ab9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104abe:	68 80 60 11 80       	push   $0x80116080
80104ac3:	e8 e8 0d 00 00       	call   801058b0 <release>
      return -1;
80104ac8:	83 c4 10             	add    $0x10,%esp
80104acb:	eb e0                	jmp    80104aad <wait+0xdd>
80104acd:	8d 76 00             	lea    0x0(%esi),%esi

80104ad0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
80104ad8:	83 ec 10             	sub    $0x10,%esp
80104adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104ade:	68 80 60 11 80       	push   $0x80116080
80104ae3:	e8 d8 0c 00 00       	call   801057c0 <acquire>
80104ae8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aeb:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
80104af0:	eb 12                	jmp    80104b04 <wakeup+0x34>
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af8:	05 14 01 00 00       	add    $0x114,%eax
80104afd:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104b02:	74 1e                	je     80104b22 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104b04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b08:	75 ee                	jne    80104af8 <wakeup+0x28>
80104b0a:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b0d:	75 e9                	jne    80104af8 <wakeup+0x28>
      p->state = RUNNABLE;
80104b0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b16:	05 14 01 00 00       	add    $0x114,%eax
80104b1b:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104b20:	75 e2                	jne    80104b04 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104b22:	c7 45 08 80 60 11 80 	movl   $0x80116080,0x8(%ebp)
}
80104b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2c:	c9                   	leave  
  release(&ptable.lock);
80104b2d:	e9 7e 0d 00 00       	jmp    801058b0 <release>
80104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	53                   	push   %ebx
80104b48:	83 ec 10             	sub    $0x10,%esp
80104b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b4e:	68 80 60 11 80       	push   $0x80116080
80104b53:	e8 68 0c 00 00       	call   801057c0 <acquire>
80104b58:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b5b:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
80104b60:	eb 12                	jmp    80104b74 <kill+0x34>
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b68:	05 14 01 00 00       	add    $0x114,%eax
80104b6d:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104b72:	74 34                	je     80104ba8 <kill+0x68>
    if(p->pid == pid){
80104b74:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b77:	75 ef                	jne    80104b68 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b79:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b7d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b84:	75 07                	jne    80104b8d <kill+0x4d>
        p->state = RUNNABLE;
80104b86:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b8d:	83 ec 0c             	sub    $0xc,%esp
80104b90:	68 80 60 11 80       	push   $0x80116080
80104b95:	e8 16 0d 00 00       	call   801058b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	31 c0                	xor    %eax,%eax
}
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104ba8:	83 ec 0c             	sub    $0xc,%esp
80104bab:	68 80 60 11 80       	push   $0x80116080
80104bb0:	e8 fb 0c 00 00       	call   801058b0 <release>
}
80104bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104bb8:	83 c4 10             	add    $0x10,%esp
80104bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc0:	c9                   	leave  
80104bc1:	c3                   	ret    
80104bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	57                   	push   %edi
80104bd8:	56                   	push   %esi
80104bd9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104bdc:	53                   	push   %ebx
80104bdd:	bb 24 61 11 80       	mov    $0x80116124,%ebx
80104be2:	83 ec 3c             	sub    $0x3c,%esp
80104be5:	eb 2b                	jmp    80104c12 <procdump+0x42>
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	68 83 91 10 80       	push   $0x80109183
80104bf8:	e8 a3 bb ff ff       	call   801007a0 <cprintf>
80104bfd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c00:	81 c3 14 01 00 00    	add    $0x114,%ebx
80104c06:	81 fb 24 a6 11 80    	cmp    $0x8011a624,%ebx
80104c0c:	0f 84 8e 00 00 00    	je     80104ca0 <procdump+0xd0>
    if(p->state == UNUSED)
80104c12:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104c15:	85 c0                	test   %eax,%eax
80104c17:	74 e7                	je     80104c00 <procdump+0x30>
      state = "???";
80104c19:	ba 6b 8c 10 80       	mov    $0x80108c6b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c1e:	83 f8 05             	cmp    $0x5,%eax
80104c21:	77 11                	ja     80104c34 <procdump+0x64>
80104c23:	8b 14 85 30 8e 10 80 	mov    -0x7fef71d0(,%eax,4),%edx
      state = "???";
80104c2a:	b8 6b 8c 10 80       	mov    $0x80108c6b,%eax
80104c2f:	85 d2                	test   %edx,%edx
80104c31:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c34:	53                   	push   %ebx
80104c35:	52                   	push   %edx
80104c36:	ff 73 a4             	pushl  -0x5c(%ebx)
80104c39:	68 6f 8c 10 80       	push   $0x80108c6f
80104c3e:	e8 5d bb ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
80104c43:	83 c4 10             	add    $0x10,%esp
80104c46:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104c4a:	75 a4                	jne    80104bf0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c4c:	83 ec 08             	sub    $0x8,%esp
80104c4f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c52:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c55:	50                   	push   %eax
80104c56:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104c59:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5c:	83 c0 08             	add    $0x8,%eax
80104c5f:	50                   	push   %eax
80104c60:	e8 fb 09 00 00       	call   80105660 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
80104c70:	8b 17                	mov    (%edi),%edx
80104c72:	85 d2                	test   %edx,%edx
80104c74:	0f 84 76 ff ff ff    	je     80104bf0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104c7a:	83 ec 08             	sub    $0x8,%esp
80104c7d:	83 c7 04             	add    $0x4,%edi
80104c80:	52                   	push   %edx
80104c81:	68 c1 86 10 80       	push   $0x801086c1
80104c86:	e8 15 bb ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c8b:	83 c4 10             	add    $0x10,%esp
80104c8e:	39 fe                	cmp    %edi,%esi
80104c90:	75 de                	jne    80104c70 <procdump+0xa0>
80104c92:	e9 59 ff ff ff       	jmp    80104bf0 <procdump+0x20>
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax
  }
}
80104ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ca3:	5b                   	pop    %ebx
80104ca4:	5e                   	pop    %esi
80104ca5:	5f                   	pop    %edi
80104ca6:	5d                   	pop    %ebp
80104ca7:	c3                   	ret    
80104ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop

80104cb0 <find_next_prime_number>:

int find_next_prime_number(int n)
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
80104cb5:	89 e5                	mov    %esp,%ebp
80104cb7:	56                   	push   %esi
80104cb8:	8b 75 08             	mov    0x8(%ebp),%esi
80104cbb:	53                   	push   %ebx
80104cbc:	bb 02 00 00 00       	mov    $0x2,%ebx
  int find=0, sol, match;
  if (n<=1)
80104cc1:	83 fe 01             	cmp    $0x1,%esi
80104cc4:	7e 2c                	jle    80104cf2 <find_next_prime_number+0x42>
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    return sol = 2;

  while (!find)
  {
    n++;
80104cd0:	8d 5e 01             	lea    0x1(%esi),%ebx
    match = 0;
    for (int i = 2; i < n; i++)
80104cd3:	b9 02 00 00 00       	mov    $0x2,%ecx
80104cd8:	eb 08                	jmp    80104ce2 <find_next_prime_number+0x32>
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ce0:	89 c1                	mov    %eax,%ecx
    {
      if (n%i == 0)
80104ce2:	89 d8                	mov    %ebx,%eax
80104ce4:	99                   	cltd   
80104ce5:	f7 f9                	idiv   %ecx
80104ce7:	85 d2                	test   %edx,%edx
80104ce9:	74 15                	je     80104d00 <find_next_prime_number+0x50>
    for (int i = 2; i < n; i++)
80104ceb:	8d 41 01             	lea    0x1(%ecx),%eax
80104cee:	39 ce                	cmp    %ecx,%esi
80104cf0:	75 ee                	jne    80104ce0 <find_next_prime_number+0x30>
      find = 1;
      return sol;
    }
  }
  return sol =0;
}
80104cf2:	89 d8                	mov    %ebx,%eax
80104cf4:	5b                   	pop    %ebx
80104cf5:	5e                   	pop    %esi
80104cf6:	5d                   	pop    %ebp
80104cf7:	c3                   	ret    
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop
    n++;
80104d00:	89 de                	mov    %ebx,%esi
80104d02:	eb cc                	jmp    80104cd0 <find_next_prime_number+0x20>
80104d04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <get_call_count>:

int get_call_count(int syscall_number)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	53                   	push   %ebx
80104d18:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104d1b:	e8 a0 09 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80104d20:	e8 6b f3 ff ff       	call   80104090 <mycpu>
  p = c->proc;
80104d25:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d2b:	e8 e0 09 00 00       	call   80105710 <popcli>
  struct proc *curproc = myproc();

  // cprintf("see pid in get call:%d\n", curproc->pid);

  return curproc->call_count[syscall_number]; 
80104d30:	8b 45 08             	mov    0x8(%ebp),%eax
80104d33:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
}
80104d37:	83 c4 04             	add    $0x4,%esp
80104d3a:	5b                   	pop    %ebx
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

80104d40 <get_most_caller>:

int get_most_caller(int syscall_number)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
  int maxi=-1;
  int most_procID=3;
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d45:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
  int maxi=-1;
80104d4a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
80104d4f:	89 e5                	mov    %esp,%ebp
80104d51:	56                   	push   %esi
  int most_procID=3;
80104d52:	be 03 00 00 00       	mov    $0x3,%esi
{
80104d57:	53                   	push   %ebx
80104d58:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop
  {
    if (p->call_count[syscall_number]>maxi)
80104d60:	8b 54 98 7c          	mov    0x7c(%eax,%ebx,4),%edx
80104d64:	39 ca                	cmp    %ecx,%edx
80104d66:	7e 05                	jle    80104d6d <get_most_caller+0x2d>
    {
      maxi = p->call_count[syscall_number];
      most_procID = p->pid;
80104d68:	8b 70 10             	mov    0x10(%eax),%esi
80104d6b:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d6d:	05 14 01 00 00       	add    $0x114,%eax
80104d72:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104d77:	75 e7                	jne    80104d60 <get_most_caller+0x20>
    }

  }
  return most_procID;

}
80104d79:	89 f0                	mov    %esi,%eax
80104d7b:	5b                   	pop    %ebx
80104d7c:	5e                   	pop    %esi
80104d7d:	5d                   	pop    %ebp
80104d7e:	c3                   	ret    
80104d7f:	90                   	nop

80104d80 <wait_for_process>:

int wait_for_process(int pid)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	56                   	push   %esi
80104d88:	8b 75 08             	mov    0x8(%ebp),%esi
80104d8b:	53                   	push   %ebx
  // struct proc *curproc = myproc();
  
  // acquire(&ptable.lock);
  // for(;;){

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d8c:	bb b8 60 11 80       	mov    $0x801160b8,%ebx
80104d91:	eb 13                	jmp    80104da6 <wait_for_process+0x26>
80104d93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d97:	90                   	nop
80104d98:	81 c3 14 01 00 00    	add    $0x114,%ebx
80104d9e:	81 fb b8 a5 11 80    	cmp    $0x8011a5b8,%ebx
80104da4:	74 18                	je     80104dbe <wait_for_process+0x3e>
    {
      if(p->pid == pid){
80104da6:	39 73 10             	cmp    %esi,0x10(%ebx)
80104da9:	75 ed                	jne    80104d98 <wait_for_process+0x18>

        wait();
80104dab:	e8 20 fc ff ff       	call   801049d0 <wait>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104db0:	81 c3 14 01 00 00    	add    $0x114,%ebx
80104db6:	81 fb b8 a5 11 80    	cmp    $0x8011a5b8,%ebx
80104dbc:	75 e8                	jne    80104da6 <wait_for_process+0x26>
      }
    }
  // release(&ptable.lock);
  // }  
  return pid;
}
80104dbe:	89 f0                	mov    %esi,%eax
80104dc0:	5b                   	pop    %ebx
80104dc1:	5e                   	pop    %esi
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop

80104dd0 <change_queue>:

int change_queue(int pid, int tqnum) 
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104dda:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p;
  if (tqnum < 1 || tqnum > 3)
80104ddd:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104de0:	83 f8 02             	cmp    $0x2,%eax
80104de3:	77 33                	ja     80104e18 <change_queue+0x48>
    return -1;
  // acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104de5:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
80104dea:	eb 10                	jmp    80104dfc <change_queue+0x2c>
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df0:	05 14 01 00 00       	add    $0x114,%eax
80104df5:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80104dfa:	74 1c                	je     80104e18 <change_queue+0x48>
    if(p->pid == pid){
80104dfc:	39 50 10             	cmp    %edx,0x10(%eax)
80104dff:	75 ef                	jne    80104df0 <change_queue+0x20>
      p->qnum = tqnum;
80104e01:	89 88 f4 00 00 00    	mov    %ecx,0xf4(%eax)
      p->wait_cycles = 0; // for retransferring 
80104e07:	c7 80 10 01 00 00 00 	movl   $0x0,0x110(%eax)
80104e0e:	00 00 00 
      // release(&ptable.lock);
      return 0;
80104e11:	31 c0                	xor    %eax,%eax
    }
  }
  // release(&ptable.lock);
  return -1;
}
80104e13:	5d                   	pop    %ebp
80104e14:	c3                   	ret    
80104e15:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e1d:	5d                   	pop    %ebp
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop

80104e20 <string_in_cell>:

void string_in_cell(char* cell_name)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	56                   	push   %esi
80104e28:	53                   	push   %ebx
80104e29:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104e2c:	83 ec 1c             	sub    $0x1c,%esp
80104e2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int point, len;
  char t[COL_WIDTH+1] = "               ";
80104e32:	c7 45 e8 20 20 20 20 	movl   $0x20202020,-0x18(%ebp)
80104e39:	c7 45 ec 20 20 20 20 	movl   $0x20202020,-0x14(%ebp)
  len = strlen(cell_name);
80104e40:	53                   	push   %ebx
  char t[COL_WIDTH+1] = "               ";
80104e41:	c7 45 f0 20 20 20 20 	movl   $0x20202020,-0x10(%ebp)
80104e48:	c7 45 f4 20 20 20 00 	movl   $0x202020,-0xc(%ebp)
  len = strlen(cell_name);
80104e4f:	e8 bc 0c 00 00       	call   80105b10 <strlen>
  point = (COL_WIDTH - len)/2;
80104e54:	b9 0f 00 00 00       	mov    $0xf,%ecx

  for (int i = 0; i < len; i++)
80104e59:	83 c4 10             	add    $0x10,%esp
  point = (COL_WIDTH - len)/2;
80104e5c:	29 c1                	sub    %eax,%ecx
80104e5e:	89 ca                	mov    %ecx,%edx
80104e60:	c1 e9 1f             	shr    $0x1f,%ecx
80104e63:	01 d1                	add    %edx,%ecx
80104e65:	d1 f9                	sar    %ecx
  for (int i = 0; i < len; i++)
80104e67:	85 c0                	test   %eax,%eax
80104e69:	7e 1d                	jle    80104e88 <string_in_cell+0x68>
80104e6b:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104e6e:	89 da                	mov    %ebx,%edx
80104e70:	01 d8                	add    %ebx,%eax
80104e72:	01 f1                	add    %esi,%ecx
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    t[i+point] = cell_name[i];
80104e78:	0f b6 1a             	movzbl (%edx),%ebx
80104e7b:	83 c2 01             	add    $0x1,%edx
80104e7e:	83 c1 01             	add    $0x1,%ecx
80104e81:	88 59 ff             	mov    %bl,-0x1(%ecx)
  for (int i = 0; i < len; i++)
80104e84:	39 c2                	cmp    %eax,%edx
80104e86:	75 f0                	jne    80104e78 <string_in_cell+0x58>
  }

  cprintf("%s", t);
80104e88:	83 ec 08             	sub    $0x8,%esp
80104e8b:	56                   	push   %esi
80104e8c:	68 75 8c 10 80       	push   $0x80108c75
80104e91:	e8 0a b9 ff ff       	call   801007a0 <cprintf>
}
80104e96:	83 c4 10             	add    $0x10,%esp
80104e99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9c:	5b                   	pop    %ebx
80104e9d:	5e                   	pop    %esi
80104e9e:	5d                   	pop    %ebp
80104e9f:	c3                   	ret    

80104ea0 <int_in_cell>:

void int_in_cell(int val)
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  char char_int[] = "0123456789";
80104ea5:	b8 38 39 00 00       	mov    $0x3938,%eax
{
80104eaa:	89 e5                	mov    %esp,%ebp
80104eac:	57                   	push   %edi
80104ead:	56                   	push   %esi
80104eae:	53                   	push   %ebx
  int counter = 0;
80104eaf:	31 db                	xor    %ebx,%ebx
{
80104eb1:	83 ec 3c             	sub    $0x3c,%esp
80104eb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char char_int[] = "0123456789";
80104eb7:	c7 45 bf 30 31 32 33 	movl   $0x33323130,-0x41(%ebp)
80104ebe:	c7 45 c3 34 35 36 37 	movl   $0x37363534,-0x3d(%ebp)
80104ec5:	66 89 45 c7          	mov    %ax,-0x39(%ebp)
80104ec9:	c6 45 c9 00          	movb   $0x0,-0x37(%ebp)
  char char_buff[COL_WIDTH];
  char rev_buff[COL_WIDTH];

  while(val > 0)
80104ecd:	85 c9                	test   %ecx,%ecx
80104ecf:	7e 4f                	jle    80104f20 <int_in_cell+0x80>
80104ed1:	8d 75 c9             	lea    -0x37(%ebp),%esi
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    int rem = val%10;
80104ed8:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80104edd:	89 cf                	mov    %ecx,%edi
80104edf:	f7 e1                	mul    %ecx
80104ee1:	c1 ea 03             	shr    $0x3,%edx
80104ee4:	89 d0                	mov    %edx,%eax
80104ee6:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104ee9:	01 d2                	add    %edx,%edx
80104eeb:	29 d7                	sub    %edx,%edi
80104eed:	89 fa                	mov    %edi,%edx
    val /= 10;
80104eef:	89 cf                	mov    %ecx,%edi
80104ef1:	89 c1                	mov    %eax,%ecx
    char_buff[counter++] = char_int[rem];
80104ef3:	89 d8                	mov    %ebx,%eax
80104ef5:	0f b6 54 15 bf       	movzbl -0x41(%ebp,%edx,1),%edx
80104efa:	83 c3 01             	add    $0x1,%ebx
80104efd:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  while(val > 0)
80104f00:	83 ff 09             	cmp    $0x9,%edi
80104f03:	7f d3                	jg     80104ed8 <int_in_cell+0x38>
80104f05:	8d 4d da             	lea    -0x26(%ebp),%ecx
80104f08:	8d 44 05 c9          	lea    -0x37(%ebp,%eax,1),%eax
80104f0c:	eb 08                	jmp    80104f16 <int_in_cell+0x76>
80104f0e:	66 90                	xchg   %ax,%ax
80104f10:	0f b6 10             	movzbl (%eax),%edx
80104f13:	83 e8 01             	sub    $0x1,%eax
  }

  for(int i = counter-1; i >= 0; i--)
      rev_buff[counter-i-1] = char_buff[i];
80104f16:	88 51 ff             	mov    %dl,-0x1(%ecx)
  for(int i = counter-1; i >= 0; i--)
80104f19:	83 c1 01             	add    $0x1,%ecx
80104f1c:	39 f0                	cmp    %esi,%eax
80104f1e:	75 f0                	jne    80104f10 <int_in_cell+0x70>

  rev_buff[counter++] = '\0';

  string_in_cell(rev_buff);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	8d 45 d9             	lea    -0x27(%ebp),%eax
  rev_buff[counter++] = '\0';
80104f26:	c6 44 1d d9 00       	movb   $0x0,-0x27(%ebp,%ebx,1)
  string_in_cell(rev_buff);
80104f2b:	50                   	push   %eax
80104f2c:	e8 ef fe ff ff       	call   80104e20 <string_in_cell>
  
}
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f37:	5b                   	pop    %ebx
80104f38:	5e                   	pop    %esi
80104f39:	5f                   	pop    %edi
80104f3a:	5d                   	pop    %ebp
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <print_process>:

int print_process(void) 
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	53                   	push   %ebx
80104f48:	bb 24 61 11 80       	mov    $0x80116124,%ebx
80104f4d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
80104f50:	68 80 60 11 80       	push   $0x80116080
80104f55:	e8 66 08 00 00       	call   801057c0 <acquire>

  string_in_cell("name"); string_in_cell("pid"); string_in_cell("state"); string_in_cell("queue"); string_in_cell("cycles"); 
80104f5a:	c7 04 24 78 8c 10 80 	movl   $0x80108c78,(%esp)
80104f61:	e8 ba fe ff ff       	call   80104e20 <string_in_cell>
80104f66:	c7 04 24 7d 8c 10 80 	movl   $0x80108c7d,(%esp)
80104f6d:	e8 ae fe ff ff       	call   80104e20 <string_in_cell>
80104f72:	c7 04 24 81 8c 10 80 	movl   $0x80108c81,(%esp)
80104f79:	e8 a2 fe ff ff       	call   80104e20 <string_in_cell>
80104f7e:	c7 04 24 87 8c 10 80 	movl   $0x80108c87,(%esp)
80104f85:	e8 96 fe ff ff       	call   80104e20 <string_in_cell>
80104f8a:	c7 04 24 8d 8c 10 80 	movl   $0x80108c8d,(%esp)
80104f91:	e8 8a fe ff ff       	call   80104e20 <string_in_cell>
  string_in_cell("arrival time"); string_in_cell("priority ratio"); string_in_cell("at ratio"); string_in_cell("cycles ratio"); string_in_cell("rank");
80104f96:	c7 04 24 94 8c 10 80 	movl   $0x80108c94,(%esp)
80104f9d:	e8 7e fe ff ff       	call   80104e20 <string_in_cell>
80104fa2:	c7 04 24 a1 8c 10 80 	movl   $0x80108ca1,(%esp)
80104fa9:	e8 72 fe ff ff       	call   80104e20 <string_in_cell>
80104fae:	c7 04 24 b0 8c 10 80 	movl   $0x80108cb0,(%esp)
80104fb5:	e8 66 fe ff ff       	call   80104e20 <string_in_cell>
80104fba:	c7 04 24 b9 8c 10 80 	movl   $0x80108cb9,(%esp)
80104fc1:	e8 5a fe ff ff       	call   80104e20 <string_in_cell>
80104fc6:	c7 04 24 c6 8c 10 80 	movl   $0x80108cc6,(%esp)
80104fcd:	e8 4e fe ff ff       	call   80104e20 <string_in_cell>
  cprintf("\n......................................................................................................................................................\n");
80104fd2:	c7 04 24 7c 8d 10 80 	movl   $0x80108d7c,(%esp)
80104fd9:	e8 c2 b7 ff ff       	call   801007a0 <cprintf>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == 0) 
80104fe8:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104feb:	85 c0                	test   %eax,%eax
80104fed:	0f 84 cc 00 00 00    	je     801050bf <print_process+0x17f>
      continue;
    
    string_in_cell(p->name);
80104ff3:	83 ec 0c             	sub    $0xc,%esp
80104ff6:	53                   	push   %ebx
80104ff7:	e8 24 fe ff ff       	call   80104e20 <string_in_cell>
    
    int_in_cell(p->pid);
80104ffc:	58                   	pop    %eax
80104ffd:	ff 73 a4             	pushl  -0x5c(%ebx)
80105000:	e8 9b fe ff ff       	call   80104ea0 <int_in_cell>

    switch (p->state)
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	83 7b a0 05          	cmpl   $0x5,-0x60(%ebx)
8010500c:	77 22                	ja     80105030 <print_process+0xf0>
8010500e:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105011:	3e ff 24 85 18 8e 10 	notrack jmp *-0x7fef71e8(,%eax,4)
80105018:	80 
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      case 3:
        string_in_cell("RUNNABLE");
        break;
      case 4:
        string_in_cell("RUNNING");
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	68 eb 8c 10 80       	push   $0x80108ceb
80105028:	e8 f3 fd ff ff       	call   80104e20 <string_in_cell>
        break;
8010502d:	83 c4 10             	add    $0x10,%esp

      default:
        break;
    }

    int_in_cell(p->qnum);
80105030:	83 ec 0c             	sub    $0xc,%esp
80105033:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80105039:	e8 62 fe ff ff       	call   80104ea0 <int_in_cell>

    int_in_cell(p->cycles);
8010503e:	58                   	pop    %eax
8010503f:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80105045:	e8 56 fe ff ff       	call   80104ea0 <int_in_cell>

    int_in_cell(p->arrival_time);
8010504a:	5a                   	pop    %edx
8010504b:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80105051:	e8 4a fe ff ff       	call   80104ea0 <int_in_cell>

    int_in_cell(p->priority_ratio);
80105056:	59                   	pop    %ecx
80105057:	ff b3 a0 00 00 00    	pushl  0xa0(%ebx)
8010505d:	e8 3e fe ff ff       	call   80104ea0 <int_in_cell>

    int_in_cell(p->arrival_time_ratio);
80105062:	58                   	pop    %eax
80105063:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80105069:	e8 32 fe ff ff       	call   80104ea0 <int_in_cell>

    int_in_cell(p->cycles_ratio);
8010506e:	58                   	pop    %eax
8010506f:	ff b3 98 00 00 00    	pushl  0x98(%ebx)
80105075:	e8 26 fe ff ff       	call   80104ea0 <int_in_cell>
  return (p->priority * p->priority_ratio) +
8010507a:	8b 93 9c 00 00 00    	mov    0x9c(%ebx),%edx
80105080:	8b 8b a0 00 00 00    	mov    0xa0(%ebx),%ecx
      (p->arrival_time * p->arrival_time_ratio) +
80105086:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010508c:	0f af 83 90 00 00 00 	imul   0x90(%ebx),%eax
  return (p->priority * p->priority_ratio) +
80105093:	0f af ca             	imul   %edx,%ecx
80105096:	8d 14 01             	lea    (%ecx,%eax,1),%edx
      (p->cycles * p->cycles_ratio);
80105099:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
8010509f:	0f af 83 98 00 00 00 	imul   0x98(%ebx),%eax
      (p->arrival_time * p->arrival_time_ratio) +
801050a6:	01 d0                	add    %edx,%eax

    int_in_cell(rank_calc(p));
801050a8:	89 04 24             	mov    %eax,(%esp)
801050ab:	e8 f0 fd ff ff       	call   80104ea0 <int_in_cell>

    cprintf("\n");
801050b0:	c7 04 24 83 91 10 80 	movl   $0x80109183,(%esp)
801050b7:	e8 e4 b6 ff ff       	call   801007a0 <cprintf>
801050bc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050bf:	81 c3 14 01 00 00    	add    $0x114,%ebx
801050c5:	81 fb 24 a6 11 80    	cmp    $0x8011a624,%ebx
801050cb:	0f 85 17 ff ff ff    	jne    80104fe8 <print_process+0xa8>
  }
  release(&ptable.lock);
801050d1:	83 ec 0c             	sub    $0xc,%esp
801050d4:	68 80 60 11 80       	push   $0x80116080
801050d9:	e8 d2 07 00 00       	call   801058b0 <release>
  return -1;
}
801050de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e6:	c9                   	leave  
801050e7:	c3                   	ret    
801050e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop
        string_in_cell("RUNNABLE");
801050f0:	83 ec 0c             	sub    $0xc,%esp
801050f3:	68 e2 8c 10 80       	push   $0x80108ce2
801050f8:	e8 23 fd ff ff       	call   80104e20 <string_in_cell>
        break;
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	e9 2b ff ff ff       	jmp    80105030 <print_process+0xf0>
80105105:	8d 76 00             	lea    0x0(%esi),%esi
        string_in_cell("UNUSED");
80105108:	83 ec 0c             	sub    $0xc,%esp
8010510b:	68 cb 8c 10 80       	push   $0x80108ccb
80105110:	e8 0b fd ff ff       	call   80104e20 <string_in_cell>
        break;
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	e9 13 ff ff ff       	jmp    80105030 <print_process+0xf0>
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
        string_in_cell("ZOMBIE");
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	68 f3 8c 10 80       	push   $0x80108cf3
80105128:	e8 f3 fc ff ff       	call   80104e20 <string_in_cell>
        break;
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	e9 fb fe ff ff       	jmp    80105030 <print_process+0xf0>
80105135:	8d 76 00             	lea    0x0(%esi),%esi
        string_in_cell("SLEEPING");
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 d9 8c 10 80       	push   $0x80108cd9
80105140:	e8 db fc ff ff       	call   80104e20 <string_in_cell>
        break;
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	e9 e3 fe ff ff       	jmp    80105030 <print_process+0xf0>
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
        string_in_cell("EMBRYO");
80105150:	83 ec 0c             	sub    $0xc,%esp
80105153:	68 d2 8c 10 80       	push   $0x80108cd2
80105158:	e8 c3 fc ff ff       	call   80104e20 <string_in_cell>
        break;
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	e9 cb fe ff ff       	jmp    80105030 <print_process+0xf0>
80105165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <BJF_proc_level>:

void BJF_proc_level(int pid, int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	57                   	push   %edi
80105178:	56                   	push   %esi
80105179:	53                   	push   %ebx
8010517a:	83 ec 28             	sub    $0x28,%esp
8010517d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105180:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105183:	8b 7d 10             	mov    0x10(%ebp),%edi
80105186:	8b 75 14             	mov    0x14(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
80105189:	68 80 60 11 80       	push   $0x80116080
{
8010518e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&ptable.lock);
80105191:	e8 2a 06 00 00       	call   801057c0 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105196:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&ptable.lock);
80105199:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010519c:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if (p->pid == pid)
801051a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801051ab:	75 12                	jne    801051bf <BJF_proc_level+0x4f>
    {
      p->priority_ratio = priority_ratio;
801051ad:	89 90 0c 01 00 00    	mov    %edx,0x10c(%eax)
      p->arrival_time_ratio = arrival_time_ratio;
801051b3:	89 b8 fc 00 00 00    	mov    %edi,0xfc(%eax)
      p->cycles_ratio = executed_cycle_ratio; 
801051b9:	89 b0 04 01 00 00    	mov    %esi,0x104(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051bf:	05 14 01 00 00       	add    $0x114,%eax
801051c4:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
801051c9:	75 dd                	jne    801051a8 <BJF_proc_level+0x38>
    }
  }
  release(&ptable.lock); 
801051cb:	c7 45 08 80 60 11 80 	movl   $0x80116080,0x8(%ebp)
}
801051d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d5:	5b                   	pop    %ebx
801051d6:	5e                   	pop    %esi
801051d7:	5f                   	pop    %edi
801051d8:	5d                   	pop    %ebp
  release(&ptable.lock); 
801051d9:	e9 d2 06 00 00       	jmp    801058b0 <release>
801051de:	66 90                	xchg   %ax,%ax

801051e0 <BJF_sys_level>:

void BJF_sys_level(int priority_ratio, int arrival_time_ratio, int executed_cycle_ratio)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	57                   	push   %edi
801051e8:	56                   	push   %esi
801051e9:	53                   	push   %ebx
801051ea:	83 ec 18             	sub    $0x18,%esp
801051ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801051f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
801051f3:	68 80 60 11 80       	push   $0x80116080
{
801051f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  acquire(&ptable.lock);
801051fb:	e8 c0 05 00 00       	call   801057c0 <acquire>
80105200:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105203:	b8 b8 60 11 80       	mov    $0x801160b8,%eax
80105208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop
  {
    p->priority_ratio = priority_ratio;
80105210:	89 b8 0c 01 00 00    	mov    %edi,0x10c(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105216:	05 14 01 00 00       	add    $0x114,%eax
    p->arrival_time_ratio = arrival_time_ratio;
8010521b:	89 70 e8             	mov    %esi,-0x18(%eax)
    p->cycles_ratio = executed_cycle_ratio; 
8010521e:	89 58 f0             	mov    %ebx,-0x10(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105221:	3d b8 a5 11 80       	cmp    $0x8011a5b8,%eax
80105226:	75 e8                	jne    80105210 <BJF_sys_level+0x30>
  }
  release(&ptable.lock); 
80105228:	c7 45 08 80 60 11 80 	movl   $0x80116080,0x8(%ebp)
}
8010522f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105232:	5b                   	pop    %ebx
80105233:	5e                   	pop    %esi
80105234:	5f                   	pop    %edi
80105235:	5d                   	pop    %ebp
  release(&ptable.lock); 
80105236:	e9 75 06 00 00       	jmp    801058b0 <release>
8010523b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010523f:	90                   	nop

80105240 <add_proc_to_sem_queue>:

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void add_proc_to_sem_queue(int i, struct proc *proc)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
  for (int j = 0; j < NPROC; j++)
80105245:	31 c0                	xor    %eax,%eax
{
80105247:	89 e5                	mov    %esp,%ebp
80105249:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010524c:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
8010524f:	c1 e2 06             	shl    $0x6,%edx
80105252:	eb 0c                	jmp    80105260 <add_proc_to_sem_queue+0x20>
80105254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (int j = 0; j < NPROC; j++)
80105258:	83 c0 01             	add    $0x1,%eax
8010525b:	83 f8 40             	cmp    $0x40,%eax
8010525e:	74 1e                	je     8010527e <add_proc_to_sem_queue+0x3e>
  {
    if (semaphores[i].queue[j] == 0){
80105260:	83 bc 82 40 54 11 80 	cmpl   $0x0,-0x7feeabc0(%edx,%eax,4)
80105267:	00 
80105268:	75 ee                	jne    80105258 <add_proc_to_sem_queue+0x18>
      semaphores[i].queue[j] = proc;
8010526a:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
8010526d:	c1 e2 04             	shl    $0x4,%edx
80105270:	8d 44 10 10          	lea    0x10(%eax,%edx,1),%eax
80105274:	8b 55 0c             	mov    0xc(%ebp),%edx
80105277:	89 14 85 00 54 11 80 	mov    %edx,-0x7feeac00(,%eax,4)
      return;
    }
  }
}
8010527e:	5d                   	pop    %ebp
8010527f:	c3                   	ret    

80105280 <pop_sem_queue>:

struct proc *pop_sem_queue(int i)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	57                   	push   %edi
80105288:	56                   	push   %esi
80105289:	53                   	push   %ebx
8010528a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = 0;
  int j = 0;

  if (semaphores[i].queue[0] == 0)
8010528d:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
80105290:	c1 e1 06             	shl    $0x6,%ecx
80105293:	8b b1 40 54 11 80    	mov    -0x7feeabc0(%ecx),%esi
80105299:	85 f6                	test   %esi,%esi
8010529b:	74 3c                	je     801052d9 <pop_sem_queue+0x59>
    return 0;

  p = semaphores[i].queue[0];

  for (j = 0; j < NPROC - 1; j++)
8010529d:	31 c0                	xor    %eax,%eax
8010529f:	eb 13                	jmp    801052b4 <pop_sem_queue+0x34>
801052a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if (semaphores[i].queue[j + 1] != 0)
      semaphores[i].queue[j] = semaphores[i].queue[j + 1];
801052a8:	89 94 81 3c 54 11 80 	mov    %edx,-0x7feeabc4(%ecx,%eax,4)
  for (j = 0; j < NPROC - 1; j++)
801052af:	83 f8 3f             	cmp    $0x3f,%eax
801052b2:	74 25                	je     801052d9 <pop_sem_queue+0x59>
    if (semaphores[i].queue[j + 1] != 0)
801052b4:	89 c7                	mov    %eax,%edi
801052b6:	83 c0 01             	add    $0x1,%eax
801052b9:	8b 94 81 40 54 11 80 	mov    -0x7feeabc0(%ecx,%eax,4),%edx
801052c0:	85 d2                	test   %edx,%edx
801052c2:	75 e4                	jne    801052a8 <pop_sem_queue+0x28>
    else
    {
      semaphores[i].queue[j] = 0;
801052c4:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
801052c7:	c1 e0 04             	shl    $0x4,%eax
801052ca:	8d 44 07 10          	lea    0x10(%edi,%eax,1),%eax
801052ce:	c7 04 85 00 54 11 80 	movl   $0x0,-0x7feeac00(,%eax,4)
801052d5:	00 00 00 00 
      break;
    }
  }

  return p;
}
801052d9:	5b                   	pop    %ebx
801052da:	89 f0                	mov    %esi,%eax
801052dc:	5e                   	pop    %esi
801052dd:	5f                   	pop    %edi
801052de:	5d                   	pop    %ebp
801052df:	c3                   	ret    

801052e0 <sem_init>:

int sem_init(int i, int v, int init)
{
801052e0:	f3 0f 1e fb          	endbr32 
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	83 ec 10             	sub    $0x10,%esp
801052ea:	8b 55 08             	mov    0x8(%ebp),%edx
  semaphores[i].max_procs = v;
801052ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801052f0:	8d 04 92             	lea    (%edx,%edx,4),%eax
  semaphores[i].procs_no = init;
  initlock(&(semaphores[i].lock), (char *)i + '0');
801052f3:	83 c2 30             	add    $0x30,%edx
  semaphores[i].max_procs = v;
801052f6:	c1 e0 06             	shl    $0x6,%eax
  initlock(&(semaphores[i].lock), (char *)i + '0');
801052f9:	52                   	push   %edx
  semaphores[i].max_procs = v;
801052fa:	89 88 00 54 11 80    	mov    %ecx,-0x7feeac00(%eax)
  semaphores[i].procs_no = init;
80105300:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105303:	89 88 04 54 11 80    	mov    %ecx,-0x7feeabfc(%eax)
  initlock(&(semaphores[i].lock), (char *)i + '0');
80105309:	05 08 54 11 80       	add    $0x80115408,%eax
8010530e:	50                   	push   %eax
8010530f:	e8 1c 03 00 00       	call   80105630 <initlock>

  return 1;
}
80105314:	b8 01 00 00 00       	mov    $0x1,%eax
80105319:	c9                   	leave  
8010531a:	c3                   	ret    
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop

80105320 <sem_acquire>:
int sem_acquire(int i)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	57                   	push   %edi
80105328:	56                   	push   %esi
80105329:	53                   	push   %ebx
8010532a:	83 ec 1c             	sub    $0x1c,%esp
8010532d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105330:	e8 8b 03 00 00       	call   801056c0 <pushcli>
  c = mycpu();
80105335:	e8 56 ed ff ff       	call   80104090 <mycpu>
  p = c->proc;
8010533a:	8d 3c 9b             	lea    (%ebx,%ebx,4),%edi
8010533d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105343:	c1 e7 06             	shl    $0x6,%edi
  struct proc *p = myproc();
  acquire(&(semaphores[i].lock));
80105346:	8d b7 08 54 11 80    	lea    -0x7feeabf8(%edi),%esi
  p = c->proc;
8010534c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
8010534f:	e8 bc 03 00 00       	call   80105710 <popcli>
  acquire(&(semaphores[i].lock));
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	56                   	push   %esi
80105358:	e8 63 04 00 00       	call   801057c0 <acquire>
  if (semaphores[i].procs_no < semaphores[i].max_procs)
8010535d:	8b 87 04 54 11 80    	mov    -0x7feeabfc(%edi),%eax
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	3b 87 00 54 11 80    	cmp    -0x7feeac00(%edi),%eax
8010536c:	7d 22                	jge    80105390 <sem_acquire+0x70>
    semaphores[i].procs_no += 1;
8010536e:	83 c0 01             	add    $0x1,%eax
80105371:	89 87 04 54 11 80    	mov    %eax,-0x7feeabfc(%edi)
  {
    add_proc_to_sem_queue(i, p);
    sleep(p, &(semaphores[i].lock));
    semaphores[i].procs_no += 1;
  }
  release(&(semaphores[i].lock));
80105377:	83 ec 0c             	sub    $0xc,%esp
8010537a:	56                   	push   %esi
8010537b:	e8 30 05 00 00       	call   801058b0 <release>

  return 1;
}
80105380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105383:	b8 01 00 00 00       	mov    $0x1,%eax
80105388:	5b                   	pop    %ebx
80105389:	5e                   	pop    %esi
8010538a:	5f                   	pop    %edi
8010538b:	5d                   	pop    %ebp
8010538c:	c3                   	ret    
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
  for (int j = 0; j < NPROC; j++)
80105390:	31 c0                	xor    %eax,%eax
80105392:	eb 0c                	jmp    801053a0 <sem_acquire+0x80>
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105398:	83 c0 01             	add    $0x1,%eax
8010539b:	83 f8 40             	cmp    $0x40,%eax
8010539e:	74 1f                	je     801053bf <sem_acquire+0x9f>
    if (semaphores[i].queue[j] == 0){
801053a0:	8b 94 87 40 54 11 80 	mov    -0x7feeabc0(%edi,%eax,4),%edx
801053a7:	85 d2                	test   %edx,%edx
801053a9:	75 ed                	jne    80105398 <sem_acquire+0x78>
      semaphores[i].queue[j] = proc;
801053ab:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
801053ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801053b1:	c1 e1 04             	shl    $0x4,%ecx
801053b4:	8d 44 08 10          	lea    0x10(%eax,%ecx,1),%eax
801053b8:	89 14 85 00 54 11 80 	mov    %edx,-0x7feeac00(,%eax,4)
    sleep(p, &(semaphores[i].lock));
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	56                   	push   %esi
801053c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801053c6:	e8 45 f5 ff ff       	call   80104910 <sleep>
    semaphores[i].procs_no += 1;
801053cb:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	c1 e0 06             	shl    $0x6,%eax
801053d4:	83 80 04 54 11 80 01 	addl   $0x1,-0x7feeabfc(%eax)
801053db:	eb 9a                	jmp    80105377 <sem_acquire+0x57>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi

801053e0 <sem_release>:

int sem_release(int i)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	57                   	push   %edi
801053e8:	56                   	push   %esi
801053e9:	53                   	push   %ebx
801053ea:	83 ec 18             	sub    $0x18,%esp
801053ed:	8b 45 08             	mov    0x8(%ebp),%eax
801053f0:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801053f3:	c1 e3 06             	shl    $0x6,%ebx
  struct proc *p = 0;
  acquire(&(semaphores[i].lock));
801053f6:	8d b3 08 54 11 80    	lea    -0x7feeabf8(%ebx),%esi
801053fc:	56                   	push   %esi
801053fd:	e8 be 03 00 00       	call   801057c0 <acquire>
  if (semaphores[i].queue[0] == 0)
80105402:	8b bb 40 54 11 80    	mov    -0x7feeabc0(%ebx),%edi
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	31 c0                	xor    %eax,%eax
  semaphores[i].procs_no -= 1;
8010540d:	83 ab 04 54 11 80 01 	subl   $0x1,-0x7feeabfc(%ebx)
  if (semaphores[i].queue[0] == 0)
80105414:	85 ff                	test   %edi,%edi
80105416:	75 14                	jne    8010542c <sem_release+0x4c>
80105418:	eb 5b                	jmp    80105475 <sem_release+0x95>
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      semaphores[i].queue[j] = semaphores[i].queue[j + 1];
80105420:	89 94 83 3c 54 11 80 	mov    %edx,-0x7feeabc4(%ebx,%eax,4)
  for (j = 0; j < NPROC - 1; j++)
80105427:	83 f8 3f             	cmp    $0x3f,%eax
8010542a:	74 28                	je     80105454 <sem_release+0x74>
    if (semaphores[i].queue[j + 1] != 0)
8010542c:	89 c1                	mov    %eax,%ecx
8010542e:	83 c0 01             	add    $0x1,%eax
80105431:	8b 94 83 40 54 11 80 	mov    -0x7feeabc0(%ebx,%eax,4),%edx
80105438:	85 d2                	test   %edx,%edx
8010543a:	75 e4                	jne    80105420 <sem_release+0x40>
      semaphores[i].queue[j] = 0;
8010543c:	8b 45 08             	mov    0x8(%ebp),%eax
8010543f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80105442:	c1 e0 04             	shl    $0x4,%eax
80105445:	8d 44 01 10          	lea    0x10(%ecx,%eax,1),%eax
80105449:	c7 04 85 00 54 11 80 	movl   $0x0,-0x7feeac00(,%eax,4)
80105450:	00 00 00 00 
  p = pop_sem_queue(i);
  // phstate[i] = HUNGRY;
  release(&(semaphores[i].lock));
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	56                   	push   %esi
80105458:	e8 53 04 00 00       	call   801058b0 <release>
  if (p != 0){
    wakeup(p);
8010545d:	89 3c 24             	mov    %edi,(%esp)
80105460:	e8 6b f6 ff ff       	call   80104ad0 <wakeup>
80105465:	83 c4 10             	add    $0x10,%esp
  }

  return 1;
}
80105468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546b:	b8 01 00 00 00       	mov    $0x1,%eax
80105470:	5b                   	pop    %ebx
80105471:	5e                   	pop    %esi
80105472:	5f                   	pop    %edi
80105473:	5d                   	pop    %ebp
80105474:	c3                   	ret    
  release(&(semaphores[i].lock));
80105475:	83 ec 0c             	sub    $0xc,%esp
80105478:	56                   	push   %esi
80105479:	e8 32 04 00 00       	call   801058b0 <release>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	eb e5                	jmp    80105468 <sem_release+0x88>
80105483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <reentrant>:

void reentrant(int count)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	53                   	push   %ebx
80105498:	83 ec 04             	sub    $0x4,%esp
8010549b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (count == 0)
8010549e:	85 db                	test   %ebx,%ebx
801054a0:	74 3e                	je     801054e0 <reentrant+0x50>
  {
    release(&tickslock);
    return;
  }

  cprintf("Acquiring the %d shift\n", count);
801054a2:	83 ec 08             	sub    $0x8,%esp
801054a5:	53                   	push   %ebx
801054a6:	68 fa 8c 10 80       	push   $0x80108cfa
801054ab:	e8 f0 b2 ff ff       	call   801007a0 <cprintf>
  acquire(&tickslock);
801054b0:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
801054b7:	e8 04 03 00 00       	call   801057c0 <acquire>
  reentrant(count - 1); 
801054bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
801054bf:	89 04 24             	mov    %eax,(%esp)
801054c2:	e8 c9 ff ff ff       	call   80105490 <reentrant>
  cprintf("Releasing the %d shift\n", count);
801054c7:	58                   	pop    %eax
801054c8:	5a                   	pop    %edx
801054c9:	53                   	push   %ebx
801054ca:	68 12 8d 10 80       	push   $0x80108d12
801054cf:	e8 cc b2 ff ff       	call   801007a0 <cprintf>
801054d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cprintf("Releasing the %d shift\n", count);
801054d7:	83 c4 10             	add    $0x10,%esp
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&tickslock);
801054e0:	c7 45 08 c0 a5 11 80 	movl   $0x8011a5c0,0x8(%ebp)
801054e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054ea:	c9                   	leave  
    release(&tickslock);
801054eb:	e9 c0 03 00 00       	jmp    801058b0 <release>

801054f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	53                   	push   %ebx
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801054fe:	68 50 8e 10 80       	push   $0x80108e50
80105503:	8d 43 04             	lea    0x4(%ebx),%eax
80105506:	50                   	push   %eax
80105507:	e8 24 01 00 00       	call   80105630 <initlock>
  lk->name = name;
8010550c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010550f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105515:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105518:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  lk->name = name;
8010551f:	89 43 3c             	mov    %eax,0x3c(%ebx)
}
80105522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	56                   	push   %esi
80105538:	53                   	push   %ebx
80105539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010553c:	8d 73 04             	lea    0x4(%ebx),%esi
8010553f:	83 ec 0c             	sub    $0xc,%esp
80105542:	56                   	push   %esi
80105543:	e8 78 02 00 00       	call   801057c0 <acquire>
  while (lk->locked) {
80105548:	8b 13                	mov    (%ebx),%edx
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 d2                	test   %edx,%edx
8010554f:	74 1a                	je     8010556b <acquiresleep+0x3b>
80105551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105558:	83 ec 08             	sub    $0x8,%esp
8010555b:	56                   	push   %esi
8010555c:	53                   	push   %ebx
8010555d:	e8 ae f3 ff ff       	call   80104910 <sleep>
  while (lk->locked) {
80105562:	8b 03                	mov    (%ebx),%eax
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	75 ed                	jne    80105558 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010556b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105571:	e8 aa eb ff ff       	call   80104120 <myproc>
80105576:	8b 40 10             	mov    0x10(%eax),%eax
80105579:	89 43 40             	mov    %eax,0x40(%ebx)
  release(&lk->lk);
8010557c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010557f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105582:	5b                   	pop    %ebx
80105583:	5e                   	pop    %esi
80105584:	5d                   	pop    %ebp
  release(&lk->lk);
80105585:	e9 26 03 00 00       	jmp    801058b0 <release>
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105590 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	56                   	push   %esi
80105598:	53                   	push   %ebx
80105599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010559c:	8d 73 04             	lea    0x4(%ebx),%esi
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	56                   	push   %esi
801055a3:	e8 18 02 00 00       	call   801057c0 <acquire>
  lk->locked = 0;
801055a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801055ae:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  wakeup(lk);
801055b5:	89 1c 24             	mov    %ebx,(%esp)
801055b8:	e8 13 f5 ff ff       	call   80104ad0 <wakeup>
  release(&lk->lk);
801055bd:	89 75 08             	mov    %esi,0x8(%ebp)
801055c0:	83 c4 10             	add    $0x10,%esp
}
801055c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5d                   	pop    %ebp
  release(&lk->lk);
801055c9:	e9 e2 02 00 00       	jmp    801058b0 <release>
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	57                   	push   %edi
801055d8:	31 ff                	xor    %edi,%edi
801055da:	56                   	push   %esi
801055db:	53                   	push   %ebx
801055dc:	83 ec 18             	sub    $0x18,%esp
801055df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801055e2:	8d 73 04             	lea    0x4(%ebx),%esi
801055e5:	56                   	push   %esi
801055e6:	e8 d5 01 00 00       	call   801057c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801055eb:	8b 03                	mov    (%ebx),%eax
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	75 1c                	jne    80105610 <holdingsleep+0x40>
  release(&lk->lk);
801055f4:	83 ec 0c             	sub    $0xc,%esp
801055f7:	56                   	push   %esi
801055f8:	e8 b3 02 00 00       	call   801058b0 <release>
  return r;
}
801055fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105600:	89 f8                	mov    %edi,%eax
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5f                   	pop    %edi
80105605:	5d                   	pop    %ebp
80105606:	c3                   	ret    
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105610:	8b 5b 40             	mov    0x40(%ebx),%ebx
80105613:	e8 08 eb ff ff       	call   80104120 <myproc>
80105618:	39 58 10             	cmp    %ebx,0x10(%eax)
8010561b:	0f 94 c0             	sete   %al
8010561e:	0f b6 c0             	movzbl %al,%eax
80105621:	89 c7                	mov    %eax,%edi
80105623:	eb cf                	jmp    801055f4 <holdingsleep+0x24>
80105625:	66 90                	xchg   %ax,%ax
80105627:	66 90                	xchg   %ax,%ax
80105629:	66 90                	xchg   %ax,%ax
8010562b:	66 90                	xchg   %ax,%ax
8010562d:	66 90                	xchg   %ax,%ax
8010562f:	90                   	nop

80105630 <initlock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name)
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010563a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010563d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105643:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105646:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  lk->pid = -1;
8010564d:	c7 40 34 ff ff ff ff 	movl   $0xffffffff,0x34(%eax)
}
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret    
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi

80105660 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105665:	31 d2                	xor    %edx,%edx
{
80105667:	89 e5                	mov    %esp,%ebp
80105669:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010566a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010566d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105670:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105677:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105678:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010567e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105684:	77 1a                	ja     801056a0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105686:	8b 58 04             	mov    0x4(%eax),%ebx
80105689:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010568c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010568f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105691:	83 fa 0a             	cmp    $0xa,%edx
80105694:	75 e2                	jne    80105678 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105696:	5b                   	pop    %ebx
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801056a0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801056a3:	8d 51 28             	lea    0x28(%ecx),%edx
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801056b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056b6:	83 c0 04             	add    $0x4,%eax
801056b9:	39 d0                	cmp    %edx,%eax
801056bb:	75 f3                	jne    801056b0 <getcallerpcs+0x50>
}
801056bd:	5b                   	pop    %ebx
801056be:	5d                   	pop    %ebp
801056bf:	c3                   	ret    

801056c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	53                   	push   %ebx
801056c8:	83 ec 04             	sub    $0x4,%esp
801056cb:	9c                   	pushf  
801056cc:	5b                   	pop    %ebx
  asm volatile("cli");
801056cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801056ce:	e8 bd e9 ff ff       	call   80104090 <mycpu>
801056d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801056d9:	85 c0                	test   %eax,%eax
801056db:	74 13                	je     801056f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801056dd:	e8 ae e9 ff ff       	call   80104090 <mycpu>
801056e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801056e9:	83 c4 04             	add    $0x4,%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5d                   	pop    %ebp
801056ee:	c3                   	ret    
801056ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801056f0:	e8 9b e9 ff ff       	call   80104090 <mycpu>
801056f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801056fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105701:	eb da                	jmp    801056dd <pushcli+0x1d>
80105703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <popcli>:

void
popcli(void)
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010571a:	9c                   	pushf  
8010571b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010571c:	f6 c4 02             	test   $0x2,%ah
8010571f:	75 31                	jne    80105752 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105721:	e8 6a e9 ff ff       	call   80104090 <mycpu>
80105726:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010572d:	78 30                	js     8010575f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010572f:	e8 5c e9 ff ff       	call   80104090 <mycpu>
80105734:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010573a:	85 d2                	test   %edx,%edx
8010573c:	74 02                	je     80105740 <popcli+0x30>
    sti();
}
8010573e:	c9                   	leave  
8010573f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105740:	e8 4b e9 ff ff       	call   80104090 <mycpu>
80105745:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010574b:	85 c0                	test   %eax,%eax
8010574d:	74 ef                	je     8010573e <popcli+0x2e>
  asm volatile("sti");
8010574f:	fb                   	sti    
}
80105750:	c9                   	leave  
80105751:	c3                   	ret    
    panic("popcli - interruptible");
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	68 5b 8e 10 80       	push   $0x80108e5b
8010575a:	e8 31 ac ff ff       	call   80100390 <panic>
    panic("popcli");
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	68 72 8e 10 80       	push   $0x80108e72
80105767:	e8 24 ac ff ff       	call   80100390 <panic>
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <holding>:
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	56                   	push   %esi
80105778:	53                   	push   %ebx
80105779:	8b 75 08             	mov    0x8(%ebp),%esi
8010577c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010577e:	e8 3d ff ff ff       	call   801056c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105783:	8b 06                	mov    (%esi),%eax
80105785:	85 c0                	test   %eax,%eax
80105787:	75 0f                	jne    80105798 <holding+0x28>
  popcli();
80105789:	e8 82 ff ff ff       	call   80105710 <popcli>
}
8010578e:	89 d8                	mov    %ebx,%eax
80105790:	5b                   	pop    %ebx
80105791:	5e                   	pop    %esi
80105792:	5d                   	pop    %ebp
80105793:	c3                   	ret    
80105794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105798:	8b 5e 08             	mov    0x8(%esi),%ebx
8010579b:	e8 f0 e8 ff ff       	call   80104090 <mycpu>
801057a0:	39 c3                	cmp    %eax,%ebx
801057a2:	0f 94 c3             	sete   %bl
  popcli();
801057a5:	e8 66 ff ff ff       	call   80105710 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801057aa:	0f b6 db             	movzbl %bl,%ebx
}
801057ad:	89 d8                	mov    %ebx,%eax
801057af:	5b                   	pop    %ebx
801057b0:	5e                   	pop    %esi
801057b1:	5d                   	pop    %ebp
801057b2:	c3                   	ret    
801057b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057c0 <acquire>:
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	56                   	push   %esi
801057c8:	be 01 00 00 00       	mov    $0x1,%esi
801057cd:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801057ce:	e8 ed fe ff ff       	call   801056c0 <pushcli>
  if(myproc() != ((void *)0))
801057d3:	e8 48 e9 ff ff       	call   80104120 <myproc>
801057d8:	85 c0                	test   %eax,%eax
801057da:	74 08                	je     801057e4 <acquire+0x24>
    curr_pid = myproc()->pid;
801057dc:	e8 3f e9 ff ff       	call   80104120 <myproc>
801057e1:	8b 70 10             	mov    0x10(%eax),%esi
  if(holding(lk) && lk->pid == curr_pid)
801057e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801057e7:	83 ec 0c             	sub    $0xc,%esp
801057ea:	53                   	push   %ebx
801057eb:	e8 80 ff ff ff       	call   80105770 <holding>
801057f0:	83 c4 10             	add    $0x10,%esp
801057f3:	85 c0                	test   %eax,%eax
801057f5:	74 09                	je     80105800 <acquire+0x40>
801057f7:	39 73 34             	cmp    %esi,0x34(%ebx)
801057fa:	0f 84 a4 00 00 00    	je     801058a4 <acquire+0xe4>
  if(holding(lk) && lk->pid != curr_pid)
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	53                   	push   %ebx
80105804:	e8 67 ff ff ff       	call   80105770 <holding>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	75 60                	jne    80105870 <acquire+0xb0>
80105810:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80105813:	b9 01 00 00 00       	mov    $0x1,%ecx
80105818:	eb 08                	jmp    80105822 <acquire+0x62>
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105820:	89 d3                	mov    %edx,%ebx
80105822:	89 c8                	mov    %ecx,%eax
80105824:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105827:	85 c0                	test   %eax,%eax
80105829:	75 f5                	jne    80105820 <acquire+0x60>
  lk->pid = curr_pid;
8010582b:	89 72 34             	mov    %esi,0x34(%edx)
  __sync_synchronize();
8010582e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105833:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105836:	e8 55 e8 ff ff       	call   80104090 <mycpu>
  ebp = (uint*)v - 2;
8010583b:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010583d:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105840:	31 c0                	xor    %eax,%eax
80105842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105848:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
8010584e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105854:	77 32                	ja     80105888 <acquire+0xc8>
    pcs[i] = ebp[1];     // saved %eip
80105856:	8b 4a 04             	mov    0x4(%edx),%ecx
80105859:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
8010585d:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105860:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105862:	83 f8 0a             	cmp    $0xa,%eax
80105865:	75 e1                	jne    80105848 <acquire+0x88>
}
80105867:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010586a:	5b                   	pop    %ebx
8010586b:	5e                   	pop    %esi
8010586c:	5d                   	pop    %ebp
8010586d:	c3                   	ret    
8010586e:	66 90                	xchg   %ax,%ax
  if(holding(lk) && lk->pid != curr_pid)
80105870:	39 73 34             	cmp    %esi,0x34(%ebx)
80105873:	74 9b                	je     80105810 <acquire+0x50>
    panic("acquire");
80105875:	83 ec 0c             	sub    $0xc,%esp
80105878:	68 79 8e 10 80       	push   $0x80108e79
8010587d:	e8 0e ab ff ff       	call   80100390 <panic>
80105882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105888:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
8010588c:	83 c3 34             	add    $0x34,%ebx
8010588f:	90                   	nop
    pcs[i] = 0;
80105890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105896:	83 c0 04             	add    $0x4,%eax
80105899:	39 d8                	cmp    %ebx,%eax
8010589b:	75 f3                	jne    80105890 <acquire+0xd0>
}
8010589d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058a0:	5b                   	pop    %ebx
801058a1:	5e                   	pop    %esi
801058a2:	5d                   	pop    %ebp
801058a3:	c3                   	ret    
    popcli();
801058a4:	e8 67 fe ff ff       	call   80105710 <popcli>
    return;
801058a9:	eb bc                	jmp    80105867 <acquire+0xa7>
801058ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop

801058b0 <release>:
{
801058b0:	f3 0f 1e fb          	endbr32 
801058b4:	55                   	push   %ebp
801058b5:	89 e5                	mov    %esp,%ebp
801058b7:	53                   	push   %ebx
801058b8:	83 ec 10             	sub    $0x10,%esp
801058bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801058be:	53                   	push   %ebx
801058bf:	e8 ac fe ff ff       	call   80105770 <holding>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	85 c0                	test   %eax,%eax
801058c9:	74 29                	je     801058f4 <release+0x44>
  lk->pcs[0] = 0;
801058cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801058d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  lk->pid = -1;
801058d9:	c7 43 34 ff ff ff ff 	movl   $0xffffffff,0x34(%ebx)
  __sync_synchronize();
801058e0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801058e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801058eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058ee:	c9                   	leave  
  popcli();
801058ef:	e9 1c fe ff ff       	jmp    80105710 <popcli>
    panic("release");
801058f4:	83 ec 0c             	sub    $0xc,%esp
801058f7:	68 81 8e 10 80       	push   $0x80108e81
801058fc:	e8 8f aa ff ff       	call   80100390 <panic>
80105901:	66 90                	xchg   %ax,%ax
80105903:	66 90                	xchg   %ax,%ax
80105905:	66 90                	xchg   %ax,%ax
80105907:	66 90                	xchg   %ax,%ax
80105909:	66 90                	xchg   %ax,%ax
8010590b:	66 90                	xchg   %ax,%ax
8010590d:	66 90                	xchg   %ax,%ax
8010590f:	90                   	nop

80105910 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	57                   	push   %edi
80105918:	8b 55 08             	mov    0x8(%ebp),%edx
8010591b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010591e:	53                   	push   %ebx
8010591f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105922:	89 d7                	mov    %edx,%edi
80105924:	09 cf                	or     %ecx,%edi
80105926:	83 e7 03             	and    $0x3,%edi
80105929:	75 25                	jne    80105950 <memset+0x40>
    c &= 0xFF;
8010592b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010592e:	c1 e0 18             	shl    $0x18,%eax
80105931:	89 fb                	mov    %edi,%ebx
80105933:	c1 e9 02             	shr    $0x2,%ecx
80105936:	c1 e3 10             	shl    $0x10,%ebx
80105939:	09 d8                	or     %ebx,%eax
8010593b:	09 f8                	or     %edi,%eax
8010593d:	c1 e7 08             	shl    $0x8,%edi
80105940:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105942:	89 d7                	mov    %edx,%edi
80105944:	fc                   	cld    
80105945:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105947:	5b                   	pop    %ebx
80105948:	89 d0                	mov    %edx,%eax
8010594a:	5f                   	pop    %edi
8010594b:	5d                   	pop    %ebp
8010594c:	c3                   	ret    
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105950:	89 d7                	mov    %edx,%edi
80105952:	fc                   	cld    
80105953:	f3 aa                	rep stos %al,%es:(%edi)
80105955:	5b                   	pop    %ebx
80105956:	89 d0                	mov    %edx,%eax
80105958:	5f                   	pop    %edi
80105959:	5d                   	pop    %ebp
8010595a:	c3                   	ret    
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop

80105960 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105960:	f3 0f 1e fb          	endbr32 
80105964:	55                   	push   %ebp
80105965:	89 e5                	mov    %esp,%ebp
80105967:	56                   	push   %esi
80105968:	8b 75 10             	mov    0x10(%ebp),%esi
8010596b:	8b 55 08             	mov    0x8(%ebp),%edx
8010596e:	53                   	push   %ebx
8010596f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105972:	85 f6                	test   %esi,%esi
80105974:	74 2a                	je     801059a0 <memcmp+0x40>
80105976:	01 c6                	add    %eax,%esi
80105978:	eb 10                	jmp    8010598a <memcmp+0x2a>
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105980:	83 c0 01             	add    $0x1,%eax
80105983:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105986:	39 f0                	cmp    %esi,%eax
80105988:	74 16                	je     801059a0 <memcmp+0x40>
    if(*s1 != *s2)
8010598a:	0f b6 0a             	movzbl (%edx),%ecx
8010598d:	0f b6 18             	movzbl (%eax),%ebx
80105990:	38 d9                	cmp    %bl,%cl
80105992:	74 ec                	je     80105980 <memcmp+0x20>
      return *s1 - *s2;
80105994:	0f b6 c1             	movzbl %cl,%eax
80105997:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105999:	5b                   	pop    %ebx
8010599a:	5e                   	pop    %esi
8010599b:	5d                   	pop    %ebp
8010599c:	c3                   	ret    
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
801059a0:	5b                   	pop    %ebx
  return 0;
801059a1:	31 c0                	xor    %eax,%eax
}
801059a3:	5e                   	pop    %esi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret    
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi

801059b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	8b 55 08             	mov    0x8(%ebp),%edx
801059bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801059be:	56                   	push   %esi
801059bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801059c2:	39 d6                	cmp    %edx,%esi
801059c4:	73 2a                	jae    801059f0 <memmove+0x40>
801059c6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801059c9:	39 fa                	cmp    %edi,%edx
801059cb:	73 23                	jae    801059f0 <memmove+0x40>
801059cd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801059d0:	85 c9                	test   %ecx,%ecx
801059d2:	74 13                	je     801059e7 <memmove+0x37>
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801059d8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801059dc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801059df:	83 e8 01             	sub    $0x1,%eax
801059e2:	83 f8 ff             	cmp    $0xffffffff,%eax
801059e5:	75 f1                	jne    801059d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801059e7:	5e                   	pop    %esi
801059e8:	89 d0                	mov    %edx,%eax
801059ea:	5f                   	pop    %edi
801059eb:	5d                   	pop    %ebp
801059ec:	c3                   	ret    
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801059f0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801059f3:	89 d7                	mov    %edx,%edi
801059f5:	85 c9                	test   %ecx,%ecx
801059f7:	74 ee                	je     801059e7 <memmove+0x37>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105a00:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105a01:	39 f0                	cmp    %esi,%eax
80105a03:	75 fb                	jne    80105a00 <memmove+0x50>
}
80105a05:	5e                   	pop    %esi
80105a06:	89 d0                	mov    %edx,%eax
80105a08:	5f                   	pop    %edi
80105a09:	5d                   	pop    %ebp
80105a0a:	c3                   	ret    
80105a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop

80105a10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105a10:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105a14:	eb 9a                	jmp    801059b0 <memmove>
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi

80105a20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	56                   	push   %esi
80105a28:	8b 75 10             	mov    0x10(%ebp),%esi
80105a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105a2e:	53                   	push   %ebx
80105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105a32:	85 f6                	test   %esi,%esi
80105a34:	74 32                	je     80105a68 <strncmp+0x48>
80105a36:	01 c6                	add    %eax,%esi
80105a38:	eb 14                	jmp    80105a4e <strncmp+0x2e>
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a40:	38 da                	cmp    %bl,%dl
80105a42:	75 14                	jne    80105a58 <strncmp+0x38>
    n--, p++, q++;
80105a44:	83 c0 01             	add    $0x1,%eax
80105a47:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105a4a:	39 f0                	cmp    %esi,%eax
80105a4c:	74 1a                	je     80105a68 <strncmp+0x48>
80105a4e:	0f b6 11             	movzbl (%ecx),%edx
80105a51:	0f b6 18             	movzbl (%eax),%ebx
80105a54:	84 d2                	test   %dl,%dl
80105a56:	75 e8                	jne    80105a40 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105a58:	0f b6 c2             	movzbl %dl,%eax
80105a5b:	29 d8                	sub    %ebx,%eax
}
80105a5d:	5b                   	pop    %ebx
80105a5e:	5e                   	pop    %esi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a68:	5b                   	pop    %ebx
    return 0;
80105a69:	31 c0                	xor    %eax,%eax
}
80105a6b:	5e                   	pop    %esi
80105a6c:	5d                   	pop    %ebp
80105a6d:	c3                   	ret    
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	8b 75 08             	mov    0x8(%ebp),%esi
80105a7c:	53                   	push   %ebx
80105a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105a80:	89 f2                	mov    %esi,%edx
80105a82:	eb 1b                	jmp    80105a9f <strncpy+0x2f>
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a88:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105a8f:	83 c2 01             	add    $0x1,%edx
80105a92:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105a96:	89 f9                	mov    %edi,%ecx
80105a98:	88 4a ff             	mov    %cl,-0x1(%edx)
80105a9b:	84 c9                	test   %cl,%cl
80105a9d:	74 09                	je     80105aa8 <strncpy+0x38>
80105a9f:	89 c3                	mov    %eax,%ebx
80105aa1:	83 e8 01             	sub    $0x1,%eax
80105aa4:	85 db                	test   %ebx,%ebx
80105aa6:	7f e0                	jg     80105a88 <strncpy+0x18>
    ;
  while(n-- > 0)
80105aa8:	89 d1                	mov    %edx,%ecx
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	7e 15                	jle    80105ac3 <strncpy+0x53>
80105aae:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105ab0:	83 c1 01             	add    $0x1,%ecx
80105ab3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105ab7:	89 c8                	mov    %ecx,%eax
80105ab9:	f7 d0                	not    %eax
80105abb:	01 d0                	add    %edx,%eax
80105abd:	01 d8                	add    %ebx,%eax
80105abf:	85 c0                	test   %eax,%eax
80105ac1:	7f ed                	jg     80105ab0 <strncpy+0x40>
  return os;
}
80105ac3:	5b                   	pop    %ebx
80105ac4:	89 f0                	mov    %esi,%eax
80105ac6:	5e                   	pop    %esi
80105ac7:	5f                   	pop    %edi
80105ac8:	5d                   	pop    %ebp
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ad0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105ad0:	f3 0f 1e fb          	endbr32 
80105ad4:	55                   	push   %ebp
80105ad5:	89 e5                	mov    %esp,%ebp
80105ad7:	56                   	push   %esi
80105ad8:	8b 55 10             	mov    0x10(%ebp),%edx
80105adb:	8b 75 08             	mov    0x8(%ebp),%esi
80105ade:	53                   	push   %ebx
80105adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105ae2:	85 d2                	test   %edx,%edx
80105ae4:	7e 21                	jle    80105b07 <safestrcpy+0x37>
80105ae6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105aea:	89 f2                	mov    %esi,%edx
80105aec:	eb 12                	jmp    80105b00 <safestrcpy+0x30>
80105aee:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105af0:	0f b6 08             	movzbl (%eax),%ecx
80105af3:	83 c0 01             	add    $0x1,%eax
80105af6:	83 c2 01             	add    $0x1,%edx
80105af9:	88 4a ff             	mov    %cl,-0x1(%edx)
80105afc:	84 c9                	test   %cl,%cl
80105afe:	74 04                	je     80105b04 <safestrcpy+0x34>
80105b00:	39 d8                	cmp    %ebx,%eax
80105b02:	75 ec                	jne    80105af0 <safestrcpy+0x20>
    ;
  *s = 0;
80105b04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105b07:	89 f0                	mov    %esi,%eax
80105b09:	5b                   	pop    %ebx
80105b0a:	5e                   	pop    %esi
80105b0b:	5d                   	pop    %ebp
80105b0c:	c3                   	ret    
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <strlen>:

int
strlen(const char *s)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105b15:	31 c0                	xor    %eax,%eax
{
80105b17:	89 e5                	mov    %esp,%ebp
80105b19:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105b1c:	80 3a 00             	cmpb   $0x0,(%edx)
80105b1f:	74 10                	je     80105b31 <strlen+0x21>
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b28:	83 c0 01             	add    $0x1,%eax
80105b2b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105b2f:	75 f7                	jne    80105b28 <strlen+0x18>
    ;
  return n;
}
80105b31:	5d                   	pop    %ebp
80105b32:	c3                   	ret    

80105b33 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b33:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b37:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105b3b:	55                   	push   %ebp
  pushl %ebx
80105b3c:	53                   	push   %ebx
  pushl %esi
80105b3d:	56                   	push   %esi
  pushl %edi
80105b3e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b3f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b41:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105b43:	5f                   	pop    %edi
  popl %esi
80105b44:	5e                   	pop    %esi
  popl %ebx
80105b45:	5b                   	pop    %ebx
  popl %ebp
80105b46:	5d                   	pop    %ebp
  ret
80105b47:	c3                   	ret    
80105b48:	66 90                	xchg   %ax,%ax
80105b4a:	66 90                	xchg   %ax,%ax
80105b4c:	66 90                	xchg   %ax,%ax
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	53                   	push   %ebx
80105b58:	83 ec 04             	sub    $0x4,%esp
80105b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b5e:	e8 bd e5 ff ff       	call   80104120 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b63:	8b 00                	mov    (%eax),%eax
80105b65:	39 d8                	cmp    %ebx,%eax
80105b67:	76 17                	jbe    80105b80 <fetchint+0x30>
80105b69:	8d 53 04             	lea    0x4(%ebx),%edx
80105b6c:	39 d0                	cmp    %edx,%eax
80105b6e:	72 10                	jb     80105b80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b73:	8b 13                	mov    (%ebx),%edx
80105b75:	89 10                	mov    %edx,(%eax)
  return 0;
80105b77:	31 c0                	xor    %eax,%eax
}
80105b79:	83 c4 04             	add    $0x4,%esp
80105b7c:	5b                   	pop    %ebx
80105b7d:	5d                   	pop    %ebp
80105b7e:	c3                   	ret    
80105b7f:	90                   	nop
    return -1;
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b85:	eb f2                	jmp    80105b79 <fetchint+0x29>
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	53                   	push   %ebx
80105b98:	83 ec 04             	sub    $0x4,%esp
80105b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105b9e:	e8 7d e5 ff ff       	call   80104120 <myproc>

  if(addr >= curproc->sz)
80105ba3:	39 18                	cmp    %ebx,(%eax)
80105ba5:	76 31                	jbe    80105bd8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105baa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105bac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105bae:	39 d3                	cmp    %edx,%ebx
80105bb0:	73 26                	jae    80105bd8 <fetchstr+0x48>
80105bb2:	89 d8                	mov    %ebx,%eax
80105bb4:	eb 11                	jmp    80105bc7 <fetchstr+0x37>
80105bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
80105bc0:	83 c0 01             	add    $0x1,%eax
80105bc3:	39 c2                	cmp    %eax,%edx
80105bc5:	76 11                	jbe    80105bd8 <fetchstr+0x48>
    if(*s == 0)
80105bc7:	80 38 00             	cmpb   $0x0,(%eax)
80105bca:	75 f4                	jne    80105bc0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80105bcc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80105bcf:	29 d8                	sub    %ebx,%eax
}
80105bd1:	5b                   	pop    %ebx
80105bd2:	5d                   	pop    %ebp
80105bd3:	c3                   	ret    
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bd8:	83 c4 04             	add    $0x4,%esp
    return -1;
80105bdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be0:	5b                   	pop    %ebx
80105be1:	5d                   	pop    %ebp
80105be2:	c3                   	ret    
80105be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bf0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	56                   	push   %esi
80105bf8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bf9:	e8 22 e5 ff ff       	call   80104120 <myproc>
80105bfe:	8b 55 08             	mov    0x8(%ebp),%edx
80105c01:	8b 40 18             	mov    0x18(%eax),%eax
80105c04:	8b 40 44             	mov    0x44(%eax),%eax
80105c07:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c0a:	e8 11 e5 ff ff       	call   80104120 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c0f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c12:	8b 00                	mov    (%eax),%eax
80105c14:	39 c6                	cmp    %eax,%esi
80105c16:	73 18                	jae    80105c30 <argint+0x40>
80105c18:	8d 53 08             	lea    0x8(%ebx),%edx
80105c1b:	39 d0                	cmp    %edx,%eax
80105c1d:	72 11                	jb     80105c30 <argint+0x40>
  *ip = *(int*)(addr);
80105c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c22:	8b 53 04             	mov    0x4(%ebx),%edx
80105c25:	89 10                	mov    %edx,(%eax)
  return 0;
80105c27:	31 c0                	xor    %eax,%eax
}
80105c29:	5b                   	pop    %ebx
80105c2a:	5e                   	pop    %esi
80105c2b:	5d                   	pop    %ebp
80105c2c:	c3                   	ret    
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c35:	eb f2                	jmp    80105c29 <argint+0x39>
80105c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	56                   	push   %esi
80105c48:	53                   	push   %ebx
80105c49:	83 ec 10             	sub    $0x10,%esp
80105c4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105c4f:	e8 cc e4 ff ff       	call   80104120 <myproc>
 
  if(argint(n, &i) < 0)
80105c54:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105c57:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105c59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5c:	50                   	push   %eax
80105c5d:	ff 75 08             	pushl  0x8(%ebp)
80105c60:	e8 8b ff ff ff       	call   80105bf0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	78 24                	js     80105c90 <argptr+0x50>
80105c6c:	85 db                	test   %ebx,%ebx
80105c6e:	78 20                	js     80105c90 <argptr+0x50>
80105c70:	8b 16                	mov    (%esi),%edx
80105c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c75:	39 c2                	cmp    %eax,%edx
80105c77:	76 17                	jbe    80105c90 <argptr+0x50>
80105c79:	01 c3                	add    %eax,%ebx
80105c7b:	39 da                	cmp    %ebx,%edx
80105c7d:	72 11                	jb     80105c90 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c82:	89 02                	mov    %eax,(%edx)
  return 0;
80105c84:	31 c0                	xor    %eax,%eax
}
80105c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c89:	5b                   	pop    %ebx
80105c8a:	5e                   	pop    %esi
80105c8b:	5d                   	pop    %ebp
80105c8c:	c3                   	ret    
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c95:	eb ef                	jmp    80105c86 <argptr+0x46>
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cad:	50                   	push   %eax
80105cae:	ff 75 08             	pushl  0x8(%ebp)
80105cb1:	e8 3a ff ff ff       	call   80105bf0 <argint>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 13                	js     80105cd0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105cbd:	83 ec 08             	sub    $0x8,%esp
80105cc0:	ff 75 0c             	pushl  0xc(%ebp)
80105cc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105cc6:	e8 c5 fe ff ff       	call   80105b90 <fetchstr>
80105ccb:	83 c4 10             	add    $0x10,%esp
}
80105cce:	c9                   	leave  
80105ccf:	c3                   	ret    
80105cd0:	c9                   	leave  
    return -1;
80105cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd6:	c3                   	ret    
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <syscall>:

};

void
syscall(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	56                   	push   %esi
80105ce8:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105ce9:	e8 32 e4 ff ff       	call   80104120 <myproc>
80105cee:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105cf0:	8b 40 18             	mov    0x18(%eax),%eax
80105cf3:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105cf6:	8d 46 ff             	lea    -0x1(%esi),%eax
80105cf9:	83 f8 20             	cmp    $0x20,%eax
80105cfc:	77 22                	ja     80105d20 <syscall+0x40>
80105cfe:	8b 04 b5 c0 8e 10 80 	mov    -0x7fef7140(,%esi,4),%eax
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 17                	je     80105d20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105d09:	ff d0                	call   *%eax
80105d0b:	8b 53 18             	mov    0x18(%ebx),%edx
80105d0e:	89 42 1c             	mov    %eax,0x1c(%edx)
    curproc->call_count[num]++;
80105d11:	83 44 b3 7c 01       	addl   $0x1,0x7c(%ebx,%esi,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d19:	5b                   	pop    %ebx
80105d1a:	5e                   	pop    %esi
80105d1b:	5d                   	pop    %ebp
80105d1c:	c3                   	ret    
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80105d20:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105d23:	56                   	push   %esi
80105d24:	50                   	push   %eax
80105d25:	ff 73 10             	pushl  0x10(%ebx)
80105d28:	68 89 8e 10 80       	push   $0x80108e89
80105d2d:	e8 6e aa ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80105d32:	8b 43 18             	mov    0x18(%ebx),%eax
80105d35:	83 c4 10             	add    $0x10,%esp
80105d38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105d3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d42:	5b                   	pop    %ebx
80105d43:	5e                   	pop    %esi
80105d44:	5d                   	pop    %ebp
80105d45:	c3                   	ret    
80105d46:	66 90                	xchg   %ax,%ax
80105d48:	66 90                	xchg   %ax,%ax
80105d4a:	66 90                	xchg   %ax,%ax
80105d4c:	66 90                	xchg   %ax,%ax
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	57                   	push   %edi
80105d54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105d58:	53                   	push   %ebx
80105d59:	83 ec 34             	sub    $0x34,%esp
80105d5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d62:	57                   	push   %edi
80105d63:	50                   	push   %eax
{
80105d64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105d67:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d6a:	e8 81 c9 ff ff       	call   801026f0 <nameiparent>
80105d6f:	83 c4 10             	add    $0x10,%esp
80105d72:	85 c0                	test   %eax,%eax
80105d74:	0f 84 46 01 00 00    	je     80105ec0 <create+0x170>
    return 0;
  ilock(dp);
80105d7a:	83 ec 0c             	sub    $0xc,%esp
80105d7d:	89 c3                	mov    %eax,%ebx
80105d7f:	50                   	push   %eax
80105d80:	e8 7b c0 ff ff       	call   80101e00 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d85:	83 c4 0c             	add    $0xc,%esp
80105d88:	6a 00                	push   $0x0
80105d8a:	57                   	push   %edi
80105d8b:	53                   	push   %ebx
80105d8c:	e8 bf c5 ff ff       	call   80102350 <dirlookup>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	89 c6                	mov    %eax,%esi
80105d96:	85 c0                	test   %eax,%eax
80105d98:	74 56                	je     80105df0 <create+0xa0>
    iunlockput(dp);
80105d9a:	83 ec 0c             	sub    $0xc,%esp
80105d9d:	53                   	push   %ebx
80105d9e:	e8 fd c2 ff ff       	call   801020a0 <iunlockput>
    ilock(ip);
80105da3:	89 34 24             	mov    %esi,(%esp)
80105da6:	e8 55 c0 ff ff       	call   80101e00 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105dab:	83 c4 10             	add    $0x10,%esp
80105dae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105db3:	75 1b                	jne    80105dd0 <create+0x80>
80105db5:	66 83 7e 54 02       	cmpw   $0x2,0x54(%esi)
80105dba:	75 14                	jne    80105dd0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dbf:	89 f0                	mov    %esi,%eax
80105dc1:	5b                   	pop    %ebx
80105dc2:	5e                   	pop    %esi
80105dc3:	5f                   	pop    %edi
80105dc4:	5d                   	pop    %ebp
80105dc5:	c3                   	ret    
80105dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	56                   	push   %esi
    return 0;
80105dd4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105dd6:	e8 c5 c2 ff ff       	call   801020a0 <iunlockput>
    return 0;
80105ddb:	83 c4 10             	add    $0x10,%esp
}
80105dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de1:	89 f0                	mov    %esi,%eax
80105de3:	5b                   	pop    %ebx
80105de4:	5e                   	pop    %esi
80105de5:	5f                   	pop    %edi
80105de6:	5d                   	pop    %ebp
80105de7:	c3                   	ret    
80105de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105df0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105df4:	83 ec 08             	sub    $0x8,%esp
80105df7:	50                   	push   %eax
80105df8:	ff 33                	pushl  (%ebx)
80105dfa:	e8 81 be ff ff       	call   80101c80 <ialloc>
80105dff:	83 c4 10             	add    $0x10,%esp
80105e02:	89 c6                	mov    %eax,%esi
80105e04:	85 c0                	test   %eax,%eax
80105e06:	0f 84 cd 00 00 00    	je     80105ed9 <create+0x189>
  ilock(ip);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	50                   	push   %eax
80105e10:	e8 eb bf ff ff       	call   80101e00 <ilock>
  ip->major = major;
80105e15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e19:	66 89 46 56          	mov    %ax,0x56(%esi)
  ip->minor = minor;
80105e1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e21:	66 89 46 58          	mov    %ax,0x58(%esi)
  ip->nlink = 1;
80105e25:	b8 01 00 00 00       	mov    $0x1,%eax
80105e2a:	66 89 46 5a          	mov    %ax,0x5a(%esi)
  iupdate(ip);
80105e2e:	89 34 24             	mov    %esi,(%esp)
80105e31:	e8 0a bf ff ff       	call   80101d40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e3e:	74 30                	je     80105e70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105e40:	83 ec 04             	sub    $0x4,%esp
80105e43:	ff 76 04             	pushl  0x4(%esi)
80105e46:	57                   	push   %edi
80105e47:	53                   	push   %ebx
80105e48:	e8 c3 c7 ff ff       	call   80102610 <dirlink>
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 78                	js     80105ecc <create+0x17c>
  iunlockput(dp);
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	53                   	push   %ebx
80105e58:	e8 43 c2 ff ff       	call   801020a0 <iunlockput>
  return ip;
80105e5d:	83 c4 10             	add    $0x10,%esp
}
80105e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e63:	89 f0                	mov    %esi,%eax
80105e65:	5b                   	pop    %ebx
80105e66:	5e                   	pop    %esi
80105e67:	5f                   	pop    %edi
80105e68:	5d                   	pop    %ebp
80105e69:	c3                   	ret    
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105e70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105e73:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
    iupdate(dp);
80105e78:	53                   	push   %ebx
80105e79:	e8 c2 be ff ff       	call   80101d40 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e7e:	83 c4 0c             	add    $0xc,%esp
80105e81:	ff 76 04             	pushl  0x4(%esi)
80105e84:	68 64 8f 10 80       	push   $0x80108f64
80105e89:	56                   	push   %esi
80105e8a:	e8 81 c7 ff ff       	call   80102610 <dirlink>
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	85 c0                	test   %eax,%eax
80105e94:	78 18                	js     80105eae <create+0x15e>
80105e96:	83 ec 04             	sub    $0x4,%esp
80105e99:	ff 73 04             	pushl  0x4(%ebx)
80105e9c:	68 63 8f 10 80       	push   $0x80108f63
80105ea1:	56                   	push   %esi
80105ea2:	e8 69 c7 ff ff       	call   80102610 <dirlink>
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	85 c0                	test   %eax,%eax
80105eac:	79 92                	jns    80105e40 <create+0xf0>
      panic("create dots");
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	68 57 8f 10 80       	push   $0x80108f57
80105eb6:	e8 d5 a4 ff ff       	call   80100390 <panic>
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop
}
80105ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ec3:	31 f6                	xor    %esi,%esi
}
80105ec5:	5b                   	pop    %ebx
80105ec6:	89 f0                	mov    %esi,%eax
80105ec8:	5e                   	pop    %esi
80105ec9:	5f                   	pop    %edi
80105eca:	5d                   	pop    %ebp
80105ecb:	c3                   	ret    
    panic("create: dirlink");
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	68 66 8f 10 80       	push   $0x80108f66
80105ed4:	e8 b7 a4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ed9:	83 ec 0c             	sub    $0xc,%esp
80105edc:	68 48 8f 10 80       	push   $0x80108f48
80105ee1:	e8 aa a4 ff ff       	call   80100390 <panic>
80105ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eed:	8d 76 00             	lea    0x0(%esi),%esi

80105ef0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	56                   	push   %esi
80105ef4:	89 d6                	mov    %edx,%esi
80105ef6:	53                   	push   %ebx
80105ef7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105ef9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105efc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105eff:	50                   	push   %eax
80105f00:	6a 00                	push   $0x0
80105f02:	e8 e9 fc ff ff       	call   80105bf0 <argint>
80105f07:	83 c4 10             	add    $0x10,%esp
80105f0a:	85 c0                	test   %eax,%eax
80105f0c:	78 2a                	js     80105f38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f12:	77 24                	ja     80105f38 <argfd.constprop.0+0x48>
80105f14:	e8 07 e2 ff ff       	call   80104120 <myproc>
80105f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105f20:	85 c0                	test   %eax,%eax
80105f22:	74 14                	je     80105f38 <argfd.constprop.0+0x48>
  if(pfd)
80105f24:	85 db                	test   %ebx,%ebx
80105f26:	74 02                	je     80105f2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105f28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105f2a:	89 06                	mov    %eax,(%esi)
  return 0;
80105f2c:	31 c0                	xor    %eax,%eax
}
80105f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f31:	5b                   	pop    %ebx
80105f32:	5e                   	pop    %esi
80105f33:	5d                   	pop    %ebp
80105f34:	c3                   	ret    
80105f35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3d:	eb ef                	jmp    80105f2e <argfd.constprop.0+0x3e>
80105f3f:	90                   	nop

80105f40 <sys_dup>:
{
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105f45:	31 c0                	xor    %eax,%eax
{
80105f47:	89 e5                	mov    %esp,%ebp
80105f49:	56                   	push   %esi
80105f4a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105f4b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105f4e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105f51:	e8 9a ff ff ff       	call   80105ef0 <argfd.constprop.0>
80105f56:	85 c0                	test   %eax,%eax
80105f58:	78 1e                	js     80105f78 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80105f5a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f5d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f5f:	e8 bc e1 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f68:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f6c:	85 d2                	test   %edx,%edx
80105f6e:	74 20                	je     80105f90 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105f70:	83 c3 01             	add    $0x1,%ebx
80105f73:	83 fb 10             	cmp    $0x10,%ebx
80105f76:	75 f0                	jne    80105f68 <sys_dup+0x28>
}
80105f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105f7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105f80:	89 d8                	mov    %ebx,%eax
80105f82:	5b                   	pop    %ebx
80105f83:	5e                   	pop    %esi
80105f84:	5d                   	pop    %ebp
80105f85:	c3                   	ret    
80105f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105f90:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105f94:	83 ec 0c             	sub    $0xc,%esp
80105f97:	ff 75 f4             	pushl  -0xc(%ebp)
80105f9a:	e8 71 b5 ff ff       	call   80101510 <filedup>
  return fd;
80105f9f:	83 c4 10             	add    $0x10,%esp
}
80105fa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fa5:	89 d8                	mov    %ebx,%eax
80105fa7:	5b                   	pop    %ebx
80105fa8:	5e                   	pop    %esi
80105fa9:	5d                   	pop    %ebp
80105faa:	c3                   	ret    
80105fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop

80105fb0 <sys_read>:
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105fb5:	31 c0                	xor    %eax,%eax
{
80105fb7:	89 e5                	mov    %esp,%ebp
80105fb9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105fbc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105fbf:	e8 2c ff ff ff       	call   80105ef0 <argfd.constprop.0>
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 48                	js     80106010 <sys_read+0x60>
80105fc8:	83 ec 08             	sub    $0x8,%esp
80105fcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fce:	50                   	push   %eax
80105fcf:	6a 02                	push   $0x2
80105fd1:	e8 1a fc ff ff       	call   80105bf0 <argint>
80105fd6:	83 c4 10             	add    $0x10,%esp
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	78 33                	js     80106010 <sys_read+0x60>
80105fdd:	83 ec 04             	sub    $0x4,%esp
80105fe0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fe3:	ff 75 f0             	pushl  -0x10(%ebp)
80105fe6:	50                   	push   %eax
80105fe7:	6a 01                	push   $0x1
80105fe9:	e8 52 fc ff ff       	call   80105c40 <argptr>
80105fee:	83 c4 10             	add    $0x10,%esp
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	78 1b                	js     80106010 <sys_read+0x60>
  return fileread(f, p, n);
80105ff5:	83 ec 04             	sub    $0x4,%esp
80105ff8:	ff 75 f0             	pushl  -0x10(%ebp)
80105ffb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ffe:	ff 75 ec             	pushl  -0x14(%ebp)
80106001:	e8 8a b6 ff ff       	call   80101690 <fileread>
80106006:	83 c4 10             	add    $0x10,%esp
}
80106009:	c9                   	leave  
8010600a:	c3                   	ret    
8010600b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
80106010:	c9                   	leave  
    return -1;
80106011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106016:	c3                   	ret    
80106017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601e:	66 90                	xchg   %ax,%ax

80106020 <sys_write>:
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106025:	31 c0                	xor    %eax,%eax
{
80106027:	89 e5                	mov    %esp,%ebp
80106029:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010602c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010602f:	e8 bc fe ff ff       	call   80105ef0 <argfd.constprop.0>
80106034:	85 c0                	test   %eax,%eax
80106036:	78 48                	js     80106080 <sys_write+0x60>
80106038:	83 ec 08             	sub    $0x8,%esp
8010603b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010603e:	50                   	push   %eax
8010603f:	6a 02                	push   $0x2
80106041:	e8 aa fb ff ff       	call   80105bf0 <argint>
80106046:	83 c4 10             	add    $0x10,%esp
80106049:	85 c0                	test   %eax,%eax
8010604b:	78 33                	js     80106080 <sys_write+0x60>
8010604d:	83 ec 04             	sub    $0x4,%esp
80106050:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106053:	ff 75 f0             	pushl  -0x10(%ebp)
80106056:	50                   	push   %eax
80106057:	6a 01                	push   $0x1
80106059:	e8 e2 fb ff ff       	call   80105c40 <argptr>
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	85 c0                	test   %eax,%eax
80106063:	78 1b                	js     80106080 <sys_write+0x60>
  return filewrite(f, p, n);
80106065:	83 ec 04             	sub    $0x4,%esp
80106068:	ff 75 f0             	pushl  -0x10(%ebp)
8010606b:	ff 75 f4             	pushl  -0xc(%ebp)
8010606e:	ff 75 ec             	pushl  -0x14(%ebp)
80106071:	e8 ba b6 ff ff       	call   80101730 <filewrite>
80106076:	83 c4 10             	add    $0x10,%esp
}
80106079:	c9                   	leave  
8010607a:	c3                   	ret    
8010607b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010607f:	90                   	nop
80106080:	c9                   	leave  
    return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106086:	c3                   	ret    
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax

80106090 <sys_close>:
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010609a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010609d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a0:	e8 4b fe ff ff       	call   80105ef0 <argfd.constprop.0>
801060a5:	85 c0                	test   %eax,%eax
801060a7:	78 27                	js     801060d0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801060a9:	e8 72 e0 ff ff       	call   80104120 <myproc>
801060ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801060b1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801060b4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801060bb:	00 
  fileclose(f);
801060bc:	ff 75 f4             	pushl  -0xc(%ebp)
801060bf:	e8 9c b4 ff ff       	call   80101560 <fileclose>
  return 0;
801060c4:	83 c4 10             	add    $0x10,%esp
801060c7:	31 c0                	xor    %eax,%eax
}
801060c9:	c9                   	leave  
801060ca:	c3                   	ret    
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop
801060d0:	c9                   	leave  
    return -1;
801060d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060d6:	c3                   	ret    
801060d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_fstat>:
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801060e5:	31 c0                	xor    %eax,%eax
{
801060e7:	89 e5                	mov    %esp,%ebp
801060e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801060ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
801060ef:	e8 fc fd ff ff       	call   80105ef0 <argfd.constprop.0>
801060f4:	85 c0                	test   %eax,%eax
801060f6:	78 30                	js     80106128 <sys_fstat+0x48>
801060f8:	83 ec 04             	sub    $0x4,%esp
801060fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060fe:	6a 14                	push   $0x14
80106100:	50                   	push   %eax
80106101:	6a 01                	push   $0x1
80106103:	e8 38 fb ff ff       	call   80105c40 <argptr>
80106108:	83 c4 10             	add    $0x10,%esp
8010610b:	85 c0                	test   %eax,%eax
8010610d:	78 19                	js     80106128 <sys_fstat+0x48>
  return filestat(f, st);
8010610f:	83 ec 08             	sub    $0x8,%esp
80106112:	ff 75 f4             	pushl  -0xc(%ebp)
80106115:	ff 75 f0             	pushl  -0x10(%ebp)
80106118:	e8 23 b5 ff ff       	call   80101640 <filestat>
8010611d:	83 c4 10             	add    $0x10,%esp
}
80106120:	c9                   	leave  
80106121:	c3                   	ret    
80106122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106128:	c9                   	leave  
    return -1;
80106129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612e:	c3                   	ret    
8010612f:	90                   	nop

80106130 <sys_link>:
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	57                   	push   %edi
80106138:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106139:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010613c:	53                   	push   %ebx
8010613d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106140:	50                   	push   %eax
80106141:	6a 00                	push   $0x0
80106143:	e8 58 fb ff ff       	call   80105ca0 <argstr>
80106148:	83 c4 10             	add    $0x10,%esp
8010614b:	85 c0                	test   %eax,%eax
8010614d:	0f 88 ff 00 00 00    	js     80106252 <sys_link+0x122>
80106153:	83 ec 08             	sub    $0x8,%esp
80106156:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106159:	50                   	push   %eax
8010615a:	6a 01                	push   $0x1
8010615c:	e8 3f fb ff ff       	call   80105ca0 <argstr>
80106161:	83 c4 10             	add    $0x10,%esp
80106164:	85 c0                	test   %eax,%eax
80106166:	0f 88 e6 00 00 00    	js     80106252 <sys_link+0x122>
  begin_op();
8010616c:	e8 5f d2 ff ff       	call   801033d0 <begin_op>
  if((ip = namei(old)) == 0){
80106171:	83 ec 0c             	sub    $0xc,%esp
80106174:	ff 75 d4             	pushl  -0x2c(%ebp)
80106177:	e8 54 c5 ff ff       	call   801026d0 <namei>
8010617c:	83 c4 10             	add    $0x10,%esp
8010617f:	89 c3                	mov    %eax,%ebx
80106181:	85 c0                	test   %eax,%eax
80106183:	0f 84 e8 00 00 00    	je     80106271 <sys_link+0x141>
  ilock(ip);
80106189:	83 ec 0c             	sub    $0xc,%esp
8010618c:	50                   	push   %eax
8010618d:	e8 6e bc ff ff       	call   80101e00 <ilock>
  if(ip->type == T_DIR){
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
8010619a:	0f 84 b9 00 00 00    	je     80106259 <sys_link+0x129>
  iupdate(ip);
801061a0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801061a3:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801061a8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801061ab:	53                   	push   %ebx
801061ac:	e8 8f bb ff ff       	call   80101d40 <iupdate>
  iunlock(ip);
801061b1:	89 1c 24             	mov    %ebx,(%esp)
801061b4:	e8 27 bd ff ff       	call   80101ee0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801061b9:	58                   	pop    %eax
801061ba:	5a                   	pop    %edx
801061bb:	57                   	push   %edi
801061bc:	ff 75 d0             	pushl  -0x30(%ebp)
801061bf:	e8 2c c5 ff ff       	call   801026f0 <nameiparent>
801061c4:	83 c4 10             	add    $0x10,%esp
801061c7:	89 c6                	mov    %eax,%esi
801061c9:	85 c0                	test   %eax,%eax
801061cb:	74 5f                	je     8010622c <sys_link+0xfc>
  ilock(dp);
801061cd:	83 ec 0c             	sub    $0xc,%esp
801061d0:	50                   	push   %eax
801061d1:	e8 2a bc ff ff       	call   80101e00 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061d6:	8b 03                	mov    (%ebx),%eax
801061d8:	83 c4 10             	add    $0x10,%esp
801061db:	39 06                	cmp    %eax,(%esi)
801061dd:	75 41                	jne    80106220 <sys_link+0xf0>
801061df:	83 ec 04             	sub    $0x4,%esp
801061e2:	ff 73 04             	pushl  0x4(%ebx)
801061e5:	57                   	push   %edi
801061e6:	56                   	push   %esi
801061e7:	e8 24 c4 ff ff       	call   80102610 <dirlink>
801061ec:	83 c4 10             	add    $0x10,%esp
801061ef:	85 c0                	test   %eax,%eax
801061f1:	78 2d                	js     80106220 <sys_link+0xf0>
  iunlockput(dp);
801061f3:	83 ec 0c             	sub    $0xc,%esp
801061f6:	56                   	push   %esi
801061f7:	e8 a4 be ff ff       	call   801020a0 <iunlockput>
  iput(ip);
801061fc:	89 1c 24             	mov    %ebx,(%esp)
801061ff:	e8 2c bd ff ff       	call   80101f30 <iput>
  end_op();
80106204:	e8 37 d2 ff ff       	call   80103440 <end_op>
  return 0;
80106209:	83 c4 10             	add    $0x10,%esp
8010620c:	31 c0                	xor    %eax,%eax
}
8010620e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106211:	5b                   	pop    %ebx
80106212:	5e                   	pop    %esi
80106213:	5f                   	pop    %edi
80106214:	5d                   	pop    %ebp
80106215:	c3                   	ret    
80106216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	56                   	push   %esi
80106224:	e8 77 be ff ff       	call   801020a0 <iunlockput>
    goto bad;
80106229:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010622c:	83 ec 0c             	sub    $0xc,%esp
8010622f:	53                   	push   %ebx
80106230:	e8 cb bb ff ff       	call   80101e00 <ilock>
  ip->nlink--;
80106235:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
8010623a:	89 1c 24             	mov    %ebx,(%esp)
8010623d:	e8 fe ba ff ff       	call   80101d40 <iupdate>
  iunlockput(ip);
80106242:	89 1c 24             	mov    %ebx,(%esp)
80106245:	e8 56 be ff ff       	call   801020a0 <iunlockput>
  end_op();
8010624a:	e8 f1 d1 ff ff       	call   80103440 <end_op>
  return -1;
8010624f:	83 c4 10             	add    $0x10,%esp
80106252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106257:	eb b5                	jmp    8010620e <sys_link+0xde>
    iunlockput(ip);
80106259:	83 ec 0c             	sub    $0xc,%esp
8010625c:	53                   	push   %ebx
8010625d:	e8 3e be ff ff       	call   801020a0 <iunlockput>
    end_op();
80106262:	e8 d9 d1 ff ff       	call   80103440 <end_op>
    return -1;
80106267:	83 c4 10             	add    $0x10,%esp
8010626a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626f:	eb 9d                	jmp    8010620e <sys_link+0xde>
    end_op();
80106271:	e8 ca d1 ff ff       	call   80103440 <end_op>
    return -1;
80106276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627b:	eb 91                	jmp    8010620e <sys_link+0xde>
8010627d:	8d 76 00             	lea    0x0(%esi),%esi

80106280 <sys_unlink>:
{
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	57                   	push   %edi
80106288:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106289:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010628c:	53                   	push   %ebx
8010628d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106290:	50                   	push   %eax
80106291:	6a 00                	push   $0x0
80106293:	e8 08 fa ff ff       	call   80105ca0 <argstr>
80106298:	83 c4 10             	add    $0x10,%esp
8010629b:	85 c0                	test   %eax,%eax
8010629d:	0f 88 7d 01 00 00    	js     80106420 <sys_unlink+0x1a0>
  begin_op();
801062a3:	e8 28 d1 ff ff       	call   801033d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062a8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801062ab:	83 ec 08             	sub    $0x8,%esp
801062ae:	53                   	push   %ebx
801062af:	ff 75 c0             	pushl  -0x40(%ebp)
801062b2:	e8 39 c4 ff ff       	call   801026f0 <nameiparent>
801062b7:	83 c4 10             	add    $0x10,%esp
801062ba:	89 c6                	mov    %eax,%esi
801062bc:	85 c0                	test   %eax,%eax
801062be:	0f 84 66 01 00 00    	je     8010642a <sys_unlink+0x1aa>
  ilock(dp);
801062c4:	83 ec 0c             	sub    $0xc,%esp
801062c7:	50                   	push   %eax
801062c8:	e8 33 bb ff ff       	call   80101e00 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801062cd:	58                   	pop    %eax
801062ce:	5a                   	pop    %edx
801062cf:	68 64 8f 10 80       	push   $0x80108f64
801062d4:	53                   	push   %ebx
801062d5:	e8 56 c0 ff ff       	call   80102330 <namecmp>
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	85 c0                	test   %eax,%eax
801062df:	0f 84 03 01 00 00    	je     801063e8 <sys_unlink+0x168>
801062e5:	83 ec 08             	sub    $0x8,%esp
801062e8:	68 63 8f 10 80       	push   $0x80108f63
801062ed:	53                   	push   %ebx
801062ee:	e8 3d c0 ff ff       	call   80102330 <namecmp>
801062f3:	83 c4 10             	add    $0x10,%esp
801062f6:	85 c0                	test   %eax,%eax
801062f8:	0f 84 ea 00 00 00    	je     801063e8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801062fe:	83 ec 04             	sub    $0x4,%esp
80106301:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106304:	50                   	push   %eax
80106305:	53                   	push   %ebx
80106306:	56                   	push   %esi
80106307:	e8 44 c0 ff ff       	call   80102350 <dirlookup>
8010630c:	83 c4 10             	add    $0x10,%esp
8010630f:	89 c3                	mov    %eax,%ebx
80106311:	85 c0                	test   %eax,%eax
80106313:	0f 84 cf 00 00 00    	je     801063e8 <sys_unlink+0x168>
  ilock(ip);
80106319:	83 ec 0c             	sub    $0xc,%esp
8010631c:	50                   	push   %eax
8010631d:	e8 de ba ff ff       	call   80101e00 <ilock>
  if(ip->nlink < 1)
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
8010632a:	0f 8e 23 01 00 00    	jle    80106453 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106330:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80106335:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106338:	74 66                	je     801063a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010633a:	83 ec 04             	sub    $0x4,%esp
8010633d:	6a 10                	push   $0x10
8010633f:	6a 00                	push   $0x0
80106341:	57                   	push   %edi
80106342:	e8 c9 f5 ff ff       	call   80105910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106347:	6a 10                	push   $0x10
80106349:	ff 75 c4             	pushl  -0x3c(%ebp)
8010634c:	57                   	push   %edi
8010634d:	56                   	push   %esi
8010634e:	e8 ad be ff ff       	call   80102200 <writei>
80106353:	83 c4 20             	add    $0x20,%esp
80106356:	83 f8 10             	cmp    $0x10,%eax
80106359:	0f 85 e7 00 00 00    	jne    80106446 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010635f:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80106364:	0f 84 96 00 00 00    	je     80106400 <sys_unlink+0x180>
  iunlockput(dp);
8010636a:	83 ec 0c             	sub    $0xc,%esp
8010636d:	56                   	push   %esi
8010636e:	e8 2d bd ff ff       	call   801020a0 <iunlockput>
  ip->nlink--;
80106373:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80106378:	89 1c 24             	mov    %ebx,(%esp)
8010637b:	e8 c0 b9 ff ff       	call   80101d40 <iupdate>
  iunlockput(ip);
80106380:	89 1c 24             	mov    %ebx,(%esp)
80106383:	e8 18 bd ff ff       	call   801020a0 <iunlockput>
  end_op();
80106388:	e8 b3 d0 ff ff       	call   80103440 <end_op>
  return 0;
8010638d:	83 c4 10             	add    $0x10,%esp
80106390:	31 c0                	xor    %eax,%eax
}
80106392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106395:	5b                   	pop    %ebx
80106396:	5e                   	pop    %esi
80106397:	5f                   	pop    %edi
80106398:	5d                   	pop    %ebp
80106399:	c3                   	ret    
8010639a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063a0:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
801063a4:	76 94                	jbe    8010633a <sys_unlink+0xba>
801063a6:	ba 20 00 00 00       	mov    $0x20,%edx
801063ab:	eb 0b                	jmp    801063b8 <sys_unlink+0x138>
801063ad:	8d 76 00             	lea    0x0(%esi),%esi
801063b0:	83 c2 10             	add    $0x10,%edx
801063b3:	39 53 5c             	cmp    %edx,0x5c(%ebx)
801063b6:	76 82                	jbe    8010633a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063b8:	6a 10                	push   $0x10
801063ba:	52                   	push   %edx
801063bb:	57                   	push   %edi
801063bc:	53                   	push   %ebx
801063bd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801063c0:	e8 3b bd ff ff       	call   80102100 <readi>
801063c5:	83 c4 10             	add    $0x10,%esp
801063c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801063cb:	83 f8 10             	cmp    $0x10,%eax
801063ce:	75 69                	jne    80106439 <sys_unlink+0x1b9>
    if(de.inum != 0)
801063d0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801063d5:	74 d9                	je     801063b0 <sys_unlink+0x130>
    iunlockput(ip);
801063d7:	83 ec 0c             	sub    $0xc,%esp
801063da:	53                   	push   %ebx
801063db:	e8 c0 bc ff ff       	call   801020a0 <iunlockput>
    goto bad;
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063e7:	90                   	nop
  iunlockput(dp);
801063e8:	83 ec 0c             	sub    $0xc,%esp
801063eb:	56                   	push   %esi
801063ec:	e8 af bc ff ff       	call   801020a0 <iunlockput>
  end_op();
801063f1:	e8 4a d0 ff ff       	call   80103440 <end_op>
  return -1;
801063f6:	83 c4 10             	add    $0x10,%esp
801063f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fe:	eb 92                	jmp    80106392 <sys_unlink+0x112>
    iupdate(dp);
80106400:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106403:	66 83 6e 5a 01       	subw   $0x1,0x5a(%esi)
    iupdate(dp);
80106408:	56                   	push   %esi
80106409:	e8 32 b9 ff ff       	call   80101d40 <iupdate>
8010640e:	83 c4 10             	add    $0x10,%esp
80106411:	e9 54 ff ff ff       	jmp    8010636a <sys_unlink+0xea>
80106416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010641d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106425:	e9 68 ff ff ff       	jmp    80106392 <sys_unlink+0x112>
    end_op();
8010642a:	e8 11 d0 ff ff       	call   80103440 <end_op>
    return -1;
8010642f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106434:	e9 59 ff ff ff       	jmp    80106392 <sys_unlink+0x112>
      panic("isdirempty: readi");
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	68 88 8f 10 80       	push   $0x80108f88
80106441:	e8 4a 9f ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106446:	83 ec 0c             	sub    $0xc,%esp
80106449:	68 9a 8f 10 80       	push   $0x80108f9a
8010644e:	e8 3d 9f ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80106453:	83 ec 0c             	sub    $0xc,%esp
80106456:	68 76 8f 10 80       	push   $0x80108f76
8010645b:	e8 30 9f ff ff       	call   80100390 <panic>

80106460 <sys_open>:

int
sys_open(void)
{
80106460:	f3 0f 1e fb          	endbr32 
80106464:	55                   	push   %ebp
80106465:	89 e5                	mov    %esp,%ebp
80106467:	57                   	push   %edi
80106468:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106469:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010646c:	53                   	push   %ebx
8010646d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106470:	50                   	push   %eax
80106471:	6a 00                	push   $0x0
80106473:	e8 28 f8 ff ff       	call   80105ca0 <argstr>
80106478:	83 c4 10             	add    $0x10,%esp
8010647b:	85 c0                	test   %eax,%eax
8010647d:	0f 88 8a 00 00 00    	js     8010650d <sys_open+0xad>
80106483:	83 ec 08             	sub    $0x8,%esp
80106486:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106489:	50                   	push   %eax
8010648a:	6a 01                	push   $0x1
8010648c:	e8 5f f7 ff ff       	call   80105bf0 <argint>
80106491:	83 c4 10             	add    $0x10,%esp
80106494:	85 c0                	test   %eax,%eax
80106496:	78 75                	js     8010650d <sys_open+0xad>
    return -1;

  begin_op();
80106498:	e8 33 cf ff ff       	call   801033d0 <begin_op>

  if(omode & O_CREATE){
8010649d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801064a1:	75 75                	jne    80106518 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801064a3:	83 ec 0c             	sub    $0xc,%esp
801064a6:	ff 75 e0             	pushl  -0x20(%ebp)
801064a9:	e8 22 c2 ff ff       	call   801026d0 <namei>
801064ae:	83 c4 10             	add    $0x10,%esp
801064b1:	89 c6                	mov    %eax,%esi
801064b3:	85 c0                	test   %eax,%eax
801064b5:	74 7e                	je     80106535 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801064b7:	83 ec 0c             	sub    $0xc,%esp
801064ba:	50                   	push   %eax
801064bb:	e8 40 b9 ff ff       	call   80101e00 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064c0:	83 c4 10             	add    $0x10,%esp
801064c3:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
801064c8:	0f 84 c2 00 00 00    	je     80106590 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801064ce:	e8 cd af ff ff       	call   801014a0 <filealloc>
801064d3:	89 c7                	mov    %eax,%edi
801064d5:	85 c0                	test   %eax,%eax
801064d7:	74 23                	je     801064fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801064d9:	e8 42 dc ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801064e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801064e4:	85 d2                	test   %edx,%edx
801064e6:	74 60                	je     80106548 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801064e8:	83 c3 01             	add    $0x1,%ebx
801064eb:	83 fb 10             	cmp    $0x10,%ebx
801064ee:	75 f0                	jne    801064e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	57                   	push   %edi
801064f4:	e8 67 b0 ff ff       	call   80101560 <fileclose>
801064f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801064fc:	83 ec 0c             	sub    $0xc,%esp
801064ff:	56                   	push   %esi
80106500:	e8 9b bb ff ff       	call   801020a0 <iunlockput>
    end_op();
80106505:	e8 36 cf ff ff       	call   80103440 <end_op>
    return -1;
8010650a:	83 c4 10             	add    $0x10,%esp
8010650d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106512:	eb 6d                	jmp    80106581 <sys_open+0x121>
80106514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106518:	83 ec 0c             	sub    $0xc,%esp
8010651b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010651e:	31 c9                	xor    %ecx,%ecx
80106520:	ba 02 00 00 00       	mov    $0x2,%edx
80106525:	6a 00                	push   $0x0
80106527:	e8 24 f8 ff ff       	call   80105d50 <create>
    if(ip == 0){
8010652c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010652f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106531:	85 c0                	test   %eax,%eax
80106533:	75 99                	jne    801064ce <sys_open+0x6e>
      end_op();
80106535:	e8 06 cf ff ff       	call   80103440 <end_op>
      return -1;
8010653a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010653f:	eb 40                	jmp    80106581 <sys_open+0x121>
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106548:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010654b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010654f:	56                   	push   %esi
80106550:	e8 8b b9 ff ff       	call   80101ee0 <iunlock>
  end_op();
80106555:	e8 e6 ce ff ff       	call   80103440 <end_op>

  f->type = FD_INODE;
8010655a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106563:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106566:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106569:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010656b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106572:	f7 d0                	not    %eax
80106574:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106577:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010657a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010657d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106584:	89 d8                	mov    %ebx,%eax
80106586:	5b                   	pop    %ebx
80106587:	5e                   	pop    %esi
80106588:	5f                   	pop    %edi
80106589:	5d                   	pop    %ebp
8010658a:	c3                   	ret    
8010658b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010658f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106593:	85 c9                	test   %ecx,%ecx
80106595:	0f 84 33 ff ff ff    	je     801064ce <sys_open+0x6e>
8010659b:	e9 5c ff ff ff       	jmp    801064fc <sys_open+0x9c>

801065a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065aa:	e8 21 ce ff ff       	call   801033d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065af:	83 ec 08             	sub    $0x8,%esp
801065b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b5:	50                   	push   %eax
801065b6:	6a 00                	push   $0x0
801065b8:	e8 e3 f6 ff ff       	call   80105ca0 <argstr>
801065bd:	83 c4 10             	add    $0x10,%esp
801065c0:	85 c0                	test   %eax,%eax
801065c2:	78 34                	js     801065f8 <sys_mkdir+0x58>
801065c4:	83 ec 0c             	sub    $0xc,%esp
801065c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ca:	31 c9                	xor    %ecx,%ecx
801065cc:	ba 01 00 00 00       	mov    $0x1,%edx
801065d1:	6a 00                	push   $0x0
801065d3:	e8 78 f7 ff ff       	call   80105d50 <create>
801065d8:	83 c4 10             	add    $0x10,%esp
801065db:	85 c0                	test   %eax,%eax
801065dd:	74 19                	je     801065f8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801065df:	83 ec 0c             	sub    $0xc,%esp
801065e2:	50                   	push   %eax
801065e3:	e8 b8 ba ff ff       	call   801020a0 <iunlockput>
  end_op();
801065e8:	e8 53 ce ff ff       	call   80103440 <end_op>
  return 0;
801065ed:	83 c4 10             	add    $0x10,%esp
801065f0:	31 c0                	xor    %eax,%eax
}
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    
801065f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801065f8:	e8 43 ce ff ff       	call   80103440 <end_op>
    return -1;
801065fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106602:	c9                   	leave  
80106603:	c3                   	ret    
80106604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010660f:	90                   	nop

80106610 <sys_mknod>:

int
sys_mknod(void)
{
80106610:	f3 0f 1e fb          	endbr32 
80106614:	55                   	push   %ebp
80106615:	89 e5                	mov    %esp,%ebp
80106617:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010661a:	e8 b1 cd ff ff       	call   801033d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010661f:	83 ec 08             	sub    $0x8,%esp
80106622:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106625:	50                   	push   %eax
80106626:	6a 00                	push   $0x0
80106628:	e8 73 f6 ff ff       	call   80105ca0 <argstr>
8010662d:	83 c4 10             	add    $0x10,%esp
80106630:	85 c0                	test   %eax,%eax
80106632:	78 64                	js     80106698 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106634:	83 ec 08             	sub    $0x8,%esp
80106637:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010663a:	50                   	push   %eax
8010663b:	6a 01                	push   $0x1
8010663d:	e8 ae f5 ff ff       	call   80105bf0 <argint>
  if((argstr(0, &path)) < 0 ||
80106642:	83 c4 10             	add    $0x10,%esp
80106645:	85 c0                	test   %eax,%eax
80106647:	78 4f                	js     80106698 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106649:	83 ec 08             	sub    $0x8,%esp
8010664c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010664f:	50                   	push   %eax
80106650:	6a 02                	push   $0x2
80106652:	e8 99 f5 ff ff       	call   80105bf0 <argint>
     argint(1, &major) < 0 ||
80106657:	83 c4 10             	add    $0x10,%esp
8010665a:	85 c0                	test   %eax,%eax
8010665c:	78 3a                	js     80106698 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010665e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106662:	83 ec 0c             	sub    $0xc,%esp
80106665:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106669:	ba 03 00 00 00       	mov    $0x3,%edx
8010666e:	50                   	push   %eax
8010666f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106672:	e8 d9 f6 ff ff       	call   80105d50 <create>
     argint(2, &minor) < 0 ||
80106677:	83 c4 10             	add    $0x10,%esp
8010667a:	85 c0                	test   %eax,%eax
8010667c:	74 1a                	je     80106698 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010667e:	83 ec 0c             	sub    $0xc,%esp
80106681:	50                   	push   %eax
80106682:	e8 19 ba ff ff       	call   801020a0 <iunlockput>
  end_op();
80106687:	e8 b4 cd ff ff       	call   80103440 <end_op>
  return 0;
8010668c:	83 c4 10             	add    $0x10,%esp
8010668f:	31 c0                	xor    %eax,%eax
}
80106691:	c9                   	leave  
80106692:	c3                   	ret    
80106693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106697:	90                   	nop
    end_op();
80106698:	e8 a3 cd ff ff       	call   80103440 <end_op>
    return -1;
8010669d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066a2:	c9                   	leave  
801066a3:	c3                   	ret    
801066a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066af:	90                   	nop

801066b0 <sys_chdir>:

int
sys_chdir(void)
{
801066b0:	f3 0f 1e fb          	endbr32 
801066b4:	55                   	push   %ebp
801066b5:	89 e5                	mov    %esp,%ebp
801066b7:	56                   	push   %esi
801066b8:	53                   	push   %ebx
801066b9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801066bc:	e8 5f da ff ff       	call   80104120 <myproc>
801066c1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801066c3:	e8 08 cd ff ff       	call   801033d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066c8:	83 ec 08             	sub    $0x8,%esp
801066cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066ce:	50                   	push   %eax
801066cf:	6a 00                	push   $0x0
801066d1:	e8 ca f5 ff ff       	call   80105ca0 <argstr>
801066d6:	83 c4 10             	add    $0x10,%esp
801066d9:	85 c0                	test   %eax,%eax
801066db:	78 73                	js     80106750 <sys_chdir+0xa0>
801066dd:	83 ec 0c             	sub    $0xc,%esp
801066e0:	ff 75 f4             	pushl  -0xc(%ebp)
801066e3:	e8 e8 bf ff ff       	call   801026d0 <namei>
801066e8:	83 c4 10             	add    $0x10,%esp
801066eb:	89 c3                	mov    %eax,%ebx
801066ed:	85 c0                	test   %eax,%eax
801066ef:	74 5f                	je     80106750 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801066f1:	83 ec 0c             	sub    $0xc,%esp
801066f4:	50                   	push   %eax
801066f5:	e8 06 b7 ff ff       	call   80101e00 <ilock>
  if(ip->type != T_DIR){
801066fa:	83 c4 10             	add    $0x10,%esp
801066fd:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80106702:	75 2c                	jne    80106730 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106704:	83 ec 0c             	sub    $0xc,%esp
80106707:	53                   	push   %ebx
80106708:	e8 d3 b7 ff ff       	call   80101ee0 <iunlock>
  iput(curproc->cwd);
8010670d:	58                   	pop    %eax
8010670e:	ff 76 68             	pushl  0x68(%esi)
80106711:	e8 1a b8 ff ff       	call   80101f30 <iput>
  end_op();
80106716:	e8 25 cd ff ff       	call   80103440 <end_op>
  curproc->cwd = ip;
8010671b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010671e:	83 c4 10             	add    $0x10,%esp
80106721:	31 c0                	xor    %eax,%eax
}
80106723:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106726:	5b                   	pop    %ebx
80106727:	5e                   	pop    %esi
80106728:	5d                   	pop    %ebp
80106729:	c3                   	ret    
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106730:	83 ec 0c             	sub    $0xc,%esp
80106733:	53                   	push   %ebx
80106734:	e8 67 b9 ff ff       	call   801020a0 <iunlockput>
    end_op();
80106739:	e8 02 cd ff ff       	call   80103440 <end_op>
    return -1;
8010673e:	83 c4 10             	add    $0x10,%esp
80106741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106746:	eb db                	jmp    80106723 <sys_chdir+0x73>
80106748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674f:	90                   	nop
    end_op();
80106750:	e8 eb cc ff ff       	call   80103440 <end_op>
    return -1;
80106755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675a:	eb c7                	jmp    80106723 <sys_chdir+0x73>
8010675c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106760 <sys_exec>:

int
sys_exec(void)
{
80106760:	f3 0f 1e fb          	endbr32 
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	57                   	push   %edi
80106768:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106769:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010676f:	53                   	push   %ebx
80106770:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106776:	50                   	push   %eax
80106777:	6a 00                	push   $0x0
80106779:	e8 22 f5 ff ff       	call   80105ca0 <argstr>
8010677e:	83 c4 10             	add    $0x10,%esp
80106781:	85 c0                	test   %eax,%eax
80106783:	0f 88 8b 00 00 00    	js     80106814 <sys_exec+0xb4>
80106789:	83 ec 08             	sub    $0x8,%esp
8010678c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106792:	50                   	push   %eax
80106793:	6a 01                	push   $0x1
80106795:	e8 56 f4 ff ff       	call   80105bf0 <argint>
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	85 c0                	test   %eax,%eax
8010679f:	78 73                	js     80106814 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801067a1:	83 ec 04             	sub    $0x4,%esp
801067a4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801067aa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801067ac:	68 80 00 00 00       	push   $0x80
801067b1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801067b7:	6a 00                	push   $0x0
801067b9:	50                   	push   %eax
801067ba:	e8 51 f1 ff ff       	call   80105910 <memset>
801067bf:	83 c4 10             	add    $0x10,%esp
801067c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067c8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801067ce:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801067d5:	83 ec 08             	sub    $0x8,%esp
801067d8:	57                   	push   %edi
801067d9:	01 f0                	add    %esi,%eax
801067db:	50                   	push   %eax
801067dc:	e8 6f f3 ff ff       	call   80105b50 <fetchint>
801067e1:	83 c4 10             	add    $0x10,%esp
801067e4:	85 c0                	test   %eax,%eax
801067e6:	78 2c                	js     80106814 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801067e8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801067ee:	85 c0                	test   %eax,%eax
801067f0:	74 36                	je     80106828 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801067f2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801067f8:	83 ec 08             	sub    $0x8,%esp
801067fb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801067fe:	52                   	push   %edx
801067ff:	50                   	push   %eax
80106800:	e8 8b f3 ff ff       	call   80105b90 <fetchstr>
80106805:	83 c4 10             	add    $0x10,%esp
80106808:	85 c0                	test   %eax,%eax
8010680a:	78 08                	js     80106814 <sys_exec+0xb4>
  for(i=0;; i++){
8010680c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010680f:	83 fb 20             	cmp    $0x20,%ebx
80106812:	75 b4                	jne    801067c8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106814:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010681c:	5b                   	pop    %ebx
8010681d:	5e                   	pop    %esi
8010681e:	5f                   	pop    %edi
8010681f:	5d                   	pop    %ebp
80106820:	c3                   	ret    
80106821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106828:	83 ec 08             	sub    $0x8,%esp
8010682b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106831:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106838:	00 00 00 00 
  return exec(path, argv);
8010683c:	50                   	push   %eax
8010683d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106843:	e8 c8 a8 ff ff       	call   80101110 <exec>
80106848:	83 c4 10             	add    $0x10,%esp
}
8010684b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010684e:	5b                   	pop    %ebx
8010684f:	5e                   	pop    %esi
80106850:	5f                   	pop    %edi
80106851:	5d                   	pop    %ebp
80106852:	c3                   	ret    
80106853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <sys_pipe>:

int
sys_pipe(void)
{
80106860:	f3 0f 1e fb          	endbr32 
80106864:	55                   	push   %ebp
80106865:	89 e5                	mov    %esp,%ebp
80106867:	57                   	push   %edi
80106868:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106869:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010686c:	53                   	push   %ebx
8010686d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106870:	6a 08                	push   $0x8
80106872:	50                   	push   %eax
80106873:	6a 00                	push   $0x0
80106875:	e8 c6 f3 ff ff       	call   80105c40 <argptr>
8010687a:	83 c4 10             	add    $0x10,%esp
8010687d:	85 c0                	test   %eax,%eax
8010687f:	78 4e                	js     801068cf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106881:	83 ec 08             	sub    $0x8,%esp
80106884:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106887:	50                   	push   %eax
80106888:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010688b:	50                   	push   %eax
8010688c:	e8 ff d1 ff ff       	call   80103a90 <pipealloc>
80106891:	83 c4 10             	add    $0x10,%esp
80106894:	85 c0                	test   %eax,%eax
80106896:	78 37                	js     801068cf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106898:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010689b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010689d:	e8 7e d8 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801068a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068ac:	85 f6                	test   %esi,%esi
801068ae:	74 30                	je     801068e0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801068b0:	83 c3 01             	add    $0x1,%ebx
801068b3:	83 fb 10             	cmp    $0x10,%ebx
801068b6:	75 f0                	jne    801068a8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801068b8:	83 ec 0c             	sub    $0xc,%esp
801068bb:	ff 75 e0             	pushl  -0x20(%ebp)
801068be:	e8 9d ac ff ff       	call   80101560 <fileclose>
    fileclose(wf);
801068c3:	58                   	pop    %eax
801068c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801068c7:	e8 94 ac ff ff       	call   80101560 <fileclose>
    return -1;
801068cc:	83 c4 10             	add    $0x10,%esp
801068cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d4:	eb 5b                	jmp    80106931 <sys_pipe+0xd1>
801068d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801068e0:	8d 73 08             	lea    0x8(%ebx),%esi
801068e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801068ea:	e8 31 d8 ff ff       	call   80104120 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068ef:	31 d2                	xor    %edx,%edx
801068f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801068f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801068fc:	85 c9                	test   %ecx,%ecx
801068fe:	74 20                	je     80106920 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106900:	83 c2 01             	add    $0x1,%edx
80106903:	83 fa 10             	cmp    $0x10,%edx
80106906:	75 f0                	jne    801068f8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106908:	e8 13 d8 ff ff       	call   80104120 <myproc>
8010690d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106914:	00 
80106915:	eb a1                	jmp    801068b8 <sys_pipe+0x58>
80106917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106920:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106924:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106927:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106929:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010692c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010692f:	31 c0                	xor    %eax,%eax
}
80106931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106934:	5b                   	pop    %ebx
80106935:	5e                   	pop    %esi
80106936:	5f                   	pop    %edi
80106937:	5d                   	pop    %ebp
80106938:	c3                   	ret    
80106939:	66 90                	xchg   %ax,%ax
8010693b:	66 90                	xchg   %ax,%ax
8010693d:	66 90                	xchg   %ax,%ax
8010693f:	90                   	nop

80106940 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106940:	f3 0f 1e fb          	endbr32 
  return fork();
80106944:	e9 87 d9 ff ff       	jmp    801042d0 <fork>
80106949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106950 <sys_exit>:
}

int
sys_exit(void)
{
80106950:	f3 0f 1e fb          	endbr32 
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	83 ec 08             	sub    $0x8,%esp
  exit();
8010695a:	e8 21 de ff ff       	call   80104780 <exit>
  return 0;  // not reached
}
8010695f:	31 c0                	xor    %eax,%eax
80106961:	c9                   	leave  
80106962:	c3                   	ret    
80106963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010696a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106970 <sys_wait>:

int
sys_wait(void)
{
80106970:	f3 0f 1e fb          	endbr32 
  return wait();
80106974:	e9 57 e0 ff ff       	jmp    801049d0 <wait>
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106980 <sys_kill>:
}

int
sys_kill(void)
{
80106980:	f3 0f 1e fb          	endbr32 
80106984:	55                   	push   %ebp
80106985:	89 e5                	mov    %esp,%ebp
80106987:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010698a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010698d:	50                   	push   %eax
8010698e:	6a 00                	push   $0x0
80106990:	e8 5b f2 ff ff       	call   80105bf0 <argint>
80106995:	83 c4 10             	add    $0x10,%esp
80106998:	85 c0                	test   %eax,%eax
8010699a:	78 14                	js     801069b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010699c:	83 ec 0c             	sub    $0xc,%esp
8010699f:	ff 75 f4             	pushl  -0xc(%ebp)
801069a2:	e8 99 e1 ff ff       	call   80104b40 <kill>
801069a7:	83 c4 10             	add    $0x10,%esp
}
801069aa:	c9                   	leave  
801069ab:	c3                   	ret    
801069ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069b0:	c9                   	leave  
    return -1;
801069b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069b6:	c3                   	ret    
801069b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069be:	66 90                	xchg   %ax,%ax

801069c0 <sys_getpid>:

int
sys_getpid(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801069ca:	e8 51 d7 ff ff       	call   80104120 <myproc>
801069cf:	8b 40 10             	mov    0x10(%eax),%eax
}
801069d2:	c9                   	leave  
801069d3:	c3                   	ret    
801069d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069df:	90                   	nop

801069e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801069e0:	f3 0f 1e fb          	endbr32 
801069e4:	55                   	push   %ebp
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801069e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801069ee:	50                   	push   %eax
801069ef:	6a 00                	push   $0x0
801069f1:	e8 fa f1 ff ff       	call   80105bf0 <argint>
801069f6:	83 c4 10             	add    $0x10,%esp
801069f9:	85 c0                	test   %eax,%eax
801069fb:	78 23                	js     80106a20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801069fd:	e8 1e d7 ff ff       	call   80104120 <myproc>
  if(growproc(n) < 0)
80106a02:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106a05:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106a07:	ff 75 f4             	pushl  -0xc(%ebp)
80106a0a:	e8 41 d8 ff ff       	call   80104250 <growproc>
80106a0f:	83 c4 10             	add    $0x10,%esp
80106a12:	85 c0                	test   %eax,%eax
80106a14:	78 0a                	js     80106a20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106a16:	89 d8                	mov    %ebx,%eax
80106a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a1b:	c9                   	leave  
80106a1c:	c3                   	ret    
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106a20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a25:	eb ef                	jmp    80106a16 <sys_sbrk+0x36>
80106a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a2e:	66 90                	xchg   %ax,%ax

80106a30 <sys_sleep>:

int
sys_sleep(void)
{
80106a30:	f3 0f 1e fb          	endbr32 
80106a34:	55                   	push   %ebp
80106a35:	89 e5                	mov    %esp,%ebp
80106a37:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106a3b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106a3e:	50                   	push   %eax
80106a3f:	6a 00                	push   $0x0
80106a41:	e8 aa f1 ff ff       	call   80105bf0 <argint>
80106a46:	83 c4 10             	add    $0x10,%esp
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	0f 88 86 00 00 00    	js     80106ad7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106a51:	83 ec 0c             	sub    $0xc,%esp
80106a54:	68 c0 a5 11 80       	push   $0x8011a5c0
80106a59:	e8 62 ed ff ff       	call   801057c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106a61:	8b 1d 00 ae 11 80    	mov    0x8011ae00,%ebx
  while(ticks - ticks0 < n){
80106a67:	83 c4 10             	add    $0x10,%esp
80106a6a:	85 d2                	test   %edx,%edx
80106a6c:	75 23                	jne    80106a91 <sys_sleep+0x61>
80106a6e:	eb 50                	jmp    80106ac0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106a70:	83 ec 08             	sub    $0x8,%esp
80106a73:	68 c0 a5 11 80       	push   $0x8011a5c0
80106a78:	68 00 ae 11 80       	push   $0x8011ae00
80106a7d:	e8 8e de ff ff       	call   80104910 <sleep>
  while(ticks - ticks0 < n){
80106a82:	a1 00 ae 11 80       	mov    0x8011ae00,%eax
80106a87:	83 c4 10             	add    $0x10,%esp
80106a8a:	29 d8                	sub    %ebx,%eax
80106a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106a8f:	73 2f                	jae    80106ac0 <sys_sleep+0x90>
    if(myproc()->killed){
80106a91:	e8 8a d6 ff ff       	call   80104120 <myproc>
80106a96:	8b 40 24             	mov    0x24(%eax),%eax
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	74 d3                	je     80106a70 <sys_sleep+0x40>
      release(&tickslock);
80106a9d:	83 ec 0c             	sub    $0xc,%esp
80106aa0:	68 c0 a5 11 80       	push   $0x8011a5c0
80106aa5:	e8 06 ee ff ff       	call   801058b0 <release>
  }
  release(&tickslock);
  return 0;
}
80106aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106aad:	83 c4 10             	add    $0x10,%esp
80106ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab5:	c9                   	leave  
80106ab6:	c3                   	ret    
80106ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106abe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106ac0:	83 ec 0c             	sub    $0xc,%esp
80106ac3:	68 c0 a5 11 80       	push   $0x8011a5c0
80106ac8:	e8 e3 ed ff ff       	call   801058b0 <release>
  return 0;
80106acd:	83 c4 10             	add    $0x10,%esp
80106ad0:	31 c0                	xor    %eax,%eax
}
80106ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ad5:	c9                   	leave  
80106ad6:	c3                   	ret    
    return -1;
80106ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106adc:	eb f4                	jmp    80106ad2 <sys_sleep+0xa2>
80106ade:	66 90                	xchg   %ax,%ax

80106ae0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106ae0:	f3 0f 1e fb          	endbr32 
80106ae4:	55                   	push   %ebp
80106ae5:	89 e5                	mov    %esp,%ebp
80106ae7:	53                   	push   %ebx
80106ae8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106aeb:	68 c0 a5 11 80       	push   $0x8011a5c0
80106af0:	e8 cb ec ff ff       	call   801057c0 <acquire>
  xticks = ticks;
80106af5:	8b 1d 00 ae 11 80    	mov    0x8011ae00,%ebx
  release(&tickslock);
80106afb:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
80106b02:	e8 a9 ed ff ff       	call   801058b0 <release>
  return xticks;
}
80106b07:	89 d8                	mov    %ebx,%eax
80106b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b0c:	c9                   	leave  
80106b0d:	c3                   	ret    
80106b0e:	66 90                	xchg   %ax,%ax

80106b10 <sys_find_next_prime_number>:

int sys_find_next_prime_number(void)
{
80106b10:	f3 0f 1e fb          	endbr32 
80106b14:	55                   	push   %ebp
80106b15:	89 e5                	mov    %esp,%ebp
80106b17:	57                   	push   %edi
80106b18:	83 ec 10             	sub    $0x10,%esp
  register int edi asm("edi");
  int num = edi;

  return find_next_prime_number(num);
80106b1b:	57                   	push   %edi
80106b1c:	e8 8f e1 ff ff       	call   80104cb0 <find_next_prime_number>
}
80106b21:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106b24:	c9                   	leave  
80106b25:	c3                   	ret    
80106b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <sys_get_call_count>:

int sys_get_call_count(void)
{
80106b30:	f3 0f 1e fb          	endbr32 
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	83 ec 20             	sub    $0x20,%esp
  int syscallID;

  if(argint(0, &syscallID) < 0)
80106b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b3d:	50                   	push   %eax
80106b3e:	6a 00                	push   $0x0
80106b40:	e8 ab f0 ff ff       	call   80105bf0 <argint>
80106b45:	83 c4 10             	add    $0x10,%esp
80106b48:	85 c0                	test   %eax,%eax
80106b4a:	78 14                	js     80106b60 <sys_get_call_count+0x30>
    return -1;
  
  return get_call_count(syscallID);
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b52:	e8 b9 e1 ff ff       	call   80104d10 <get_call_count>
80106b57:	83 c4 10             	add    $0x10,%esp
}
80106b5a:	c9                   	leave  
80106b5b:	c3                   	ret    
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b60:	c9                   	leave  
    return -1;
80106b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b66:	c3                   	ret    
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <sys_get_most_caller>:

int sys_get_most_caller(void)
{
80106b70:	f3 0f 1e fb          	endbr32 
80106b74:	55                   	push   %ebp
80106b75:	89 e5                	mov    %esp,%ebp
80106b77:	83 ec 20             	sub    $0x20,%esp
  int syscallID;

  if(argint(0, &syscallID) < 0)
80106b7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b7d:	50                   	push   %eax
80106b7e:	6a 00                	push   $0x0
80106b80:	e8 6b f0 ff ff       	call   80105bf0 <argint>
80106b85:	83 c4 10             	add    $0x10,%esp
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	78 14                	js     80106ba0 <sys_get_most_caller+0x30>
    return -1;
  
  return get_most_caller(syscallID);
80106b8c:	83 ec 0c             	sub    $0xc,%esp
80106b8f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b92:	e8 a9 e1 ff ff       	call   80104d40 <get_most_caller>
80106b97:	83 c4 10             	add    $0x10,%esp
}
80106b9a:	c9                   	leave  
80106b9b:	c3                   	ret    
80106b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	c9                   	leave  
    return -1;
80106ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba6:	c3                   	ret    
80106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bae:	66 90                	xchg   %ax,%ax

80106bb0 <sys_wait_for_process>:

int sys_wait_for_process(void)
{
80106bb0:	f3 0f 1e fb          	endbr32 
80106bb4:	55                   	push   %ebp
80106bb5:	89 e5                	mov    %esp,%ebp
80106bb7:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0)
80106bba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bbd:	50                   	push   %eax
80106bbe:	6a 00                	push   $0x0
80106bc0:	e8 2b f0 ff ff       	call   80105bf0 <argint>
80106bc5:	83 c4 10             	add    $0x10,%esp
80106bc8:	85 c0                	test   %eax,%eax
80106bca:	78 14                	js     80106be0 <sys_wait_for_process+0x30>
    return -1;

  return wait_for_process(pid);
80106bcc:	83 ec 0c             	sub    $0xc,%esp
80106bcf:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd2:	e8 a9 e1 ff ff       	call   80104d80 <wait_for_process>
80106bd7:	83 c4 10             	add    $0x10,%esp
}
80106bda:	c9                   	leave  
80106bdb:	c3                   	ret    
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106be0:	c9                   	leave  
    return -1;
80106be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106be6:	c3                   	ret    
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <sys_change_queue>:

int sys_change_queue(void) 
{
80106bf0:	f3 0f 1e fb          	endbr32 
80106bf4:	55                   	push   %ebp
80106bf5:	89 e5                	mov    %esp,%ebp
80106bf7:	83 ec 20             	sub    $0x20,%esp
  int pid, queue;
  if (argint(0, &pid) < 0) 
80106bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bfd:	50                   	push   %eax
80106bfe:	6a 00                	push   $0x0
80106c00:	e8 eb ef ff ff       	call   80105bf0 <argint>
80106c05:	83 c4 10             	add    $0x10,%esp
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	78 2c                	js     80106c38 <sys_change_queue+0x48>
    return -1;
  if (argint(1, &queue) < 0) 
80106c0c:	83 ec 08             	sub    $0x8,%esp
80106c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c12:	50                   	push   %eax
80106c13:	6a 01                	push   $0x1
80106c15:	e8 d6 ef ff ff       	call   80105bf0 <argint>
80106c1a:	83 c4 10             	add    $0x10,%esp
80106c1d:	85 c0                	test   %eax,%eax
80106c1f:	78 17                	js     80106c38 <sys_change_queue+0x48>
    return -1;
  return change_queue(pid, queue);
80106c21:	83 ec 08             	sub    $0x8,%esp
80106c24:	ff 75 f4             	pushl  -0xc(%ebp)
80106c27:	ff 75 f0             	pushl  -0x10(%ebp)
80106c2a:	e8 a1 e1 ff ff       	call   80104dd0 <change_queue>
80106c2f:	83 c4 10             	add    $0x10,%esp
}
80106c32:	c9                   	leave  
80106c33:	c3                   	ret    
80106c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c38:	c9                   	leave  
    return -1;
80106c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c3e:	c3                   	ret    
80106c3f:	90                   	nop

80106c40 <sys_print_process>:

int sys_print_process(void) 
{
80106c40:	f3 0f 1e fb          	endbr32 
  return print_process();
80106c44:	e9 f7 e2 ff ff       	jmp    80104f40 <print_process>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <sys_BJF_proc_level>:
}

void sys_BJF_proc_level(void)
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	83 ec 20             	sub    $0x20,%esp
  int pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  argint(0, &pid);
80106c5a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c5d:	50                   	push   %eax
80106c5e:	6a 00                	push   $0x0
80106c60:	e8 8b ef ff ff       	call   80105bf0 <argint>
  argint(1, &priority_ratio);
80106c65:	58                   	pop    %eax
80106c66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c69:	5a                   	pop    %edx
80106c6a:	50                   	push   %eax
80106c6b:	6a 01                	push   $0x1
80106c6d:	e8 7e ef ff ff       	call   80105bf0 <argint>
  argint(2, &arrival_time_ratio);
80106c72:	59                   	pop    %ecx
80106c73:	58                   	pop    %eax
80106c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c77:	50                   	push   %eax
80106c78:	6a 02                	push   $0x2
80106c7a:	e8 71 ef ff ff       	call   80105bf0 <argint>
  argint(3, &executed_cycle_ratio);
80106c7f:	58                   	pop    %eax
80106c80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c83:	5a                   	pop    %edx
80106c84:	50                   	push   %eax
80106c85:	6a 03                	push   $0x3
80106c87:	e8 64 ef ff ff       	call   80105bf0 <argint>
  BJF_proc_level(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80106c8c:	ff 75 f4             	pushl  -0xc(%ebp)
80106c8f:	ff 75 f0             	pushl  -0x10(%ebp)
80106c92:	ff 75 ec             	pushl  -0x14(%ebp)
80106c95:	ff 75 e8             	pushl  -0x18(%ebp)
80106c98:	e8 d3 e4 ff ff       	call   80105170 <BJF_proc_level>
}
80106c9d:	83 c4 20             	add    $0x20,%esp
80106ca0:	c9                   	leave  
80106ca1:	c3                   	ret    
80106ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cb0 <sys_BJF_sys_level>:

void sys_BJF_sys_level(void)
{
80106cb0:	f3 0f 1e fb          	endbr32 
80106cb4:	55                   	push   %ebp
80106cb5:	89 e5                	mov    %esp,%ebp
80106cb7:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  argint(0, &priority_ratio);
80106cba:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cbd:	50                   	push   %eax
80106cbe:	6a 00                	push   $0x0
80106cc0:	e8 2b ef ff ff       	call   80105bf0 <argint>
  argint(1, &arrival_time_ratio);
80106cc5:	58                   	pop    %eax
80106cc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cc9:	5a                   	pop    %edx
80106cca:	50                   	push   %eax
80106ccb:	6a 01                	push   $0x1
80106ccd:	e8 1e ef ff ff       	call   80105bf0 <argint>
  argint(2, &executed_cycle_ratio);
80106cd2:	59                   	pop    %ecx
80106cd3:	58                   	pop    %eax
80106cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cd7:	50                   	push   %eax
80106cd8:	6a 02                	push   $0x2
80106cda:	e8 11 ef ff ff       	call   80105bf0 <argint>
  BJF_sys_level(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80106cdf:	83 c4 0c             	add    $0xc,%esp
80106ce2:	ff 75 f4             	pushl  -0xc(%ebp)
80106ce5:	ff 75 f0             	pushl  -0x10(%ebp)
80106ce8:	ff 75 ec             	pushl  -0x14(%ebp)
80106ceb:	e8 f0 e4 ff ff       	call   801051e0 <BJF_sys_level>
}
80106cf0:	83 c4 10             	add    $0x10,%esp
80106cf3:	c9                   	leave  
80106cf4:	c3                   	ret    
80106cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d00 <sys_sem_init>:

int sys_sem_init(void)
{
80106d00:	f3 0f 1e fb          	endbr32 
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	83 ec 20             	sub    $0x20,%esp
  int i, v, init;
  if (argint(0, &i) < 0) 
80106d0a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106d0d:	50                   	push   %eax
80106d0e:	6a 00                	push   $0x0
80106d10:	e8 db ee ff ff       	call   80105bf0 <argint>
80106d15:	83 c4 10             	add    $0x10,%esp
80106d18:	85 c0                	test   %eax,%eax
80106d1a:	78 44                	js     80106d60 <sys_sem_init+0x60>
    return -1;
  if (argint(1, &v) < 0) 
80106d1c:	83 ec 08             	sub    $0x8,%esp
80106d1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d22:	50                   	push   %eax
80106d23:	6a 01                	push   $0x1
80106d25:	e8 c6 ee ff ff       	call   80105bf0 <argint>
80106d2a:	83 c4 10             	add    $0x10,%esp
80106d2d:	85 c0                	test   %eax,%eax
80106d2f:	78 2f                	js     80106d60 <sys_sem_init+0x60>
    return -1;
  if (argint(2, &init) < 0) 
80106d31:	83 ec 08             	sub    $0x8,%esp
80106d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d37:	50                   	push   %eax
80106d38:	6a 02                	push   $0x2
80106d3a:	e8 b1 ee ff ff       	call   80105bf0 <argint>
80106d3f:	83 c4 10             	add    $0x10,%esp
80106d42:	85 c0                	test   %eax,%eax
80106d44:	78 1a                	js     80106d60 <sys_sem_init+0x60>
    return -1;
  return sem_init(i, v, init);
80106d46:	83 ec 04             	sub    $0x4,%esp
80106d49:	ff 75 f4             	pushl  -0xc(%ebp)
80106d4c:	ff 75 f0             	pushl  -0x10(%ebp)
80106d4f:	ff 75 ec             	pushl  -0x14(%ebp)
80106d52:	e8 89 e5 ff ff       	call   801052e0 <sem_init>
80106d57:	83 c4 10             	add    $0x10,%esp
}
80106d5a:	c9                   	leave  
80106d5b:	c3                   	ret    
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d60:	c9                   	leave  
    return -1;
80106d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d66:	c3                   	ret    
80106d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6e:	66 90                	xchg   %ax,%ax

80106d70 <sys_sem_acquire>:

int sys_sem_acquire(void)
{
80106d70:	f3 0f 1e fb          	endbr32 
80106d74:	55                   	push   %ebp
80106d75:	89 e5                	mov    %esp,%ebp
80106d77:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0) 
80106d7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d7d:	50                   	push   %eax
80106d7e:	6a 00                	push   $0x0
80106d80:	e8 6b ee ff ff       	call   80105bf0 <argint>
80106d85:	83 c4 10             	add    $0x10,%esp
80106d88:	85 c0                	test   %eax,%eax
80106d8a:	78 14                	js     80106da0 <sys_sem_acquire+0x30>
    return -1;

  return sem_acquire(i);
80106d8c:	83 ec 0c             	sub    $0xc,%esp
80106d8f:	ff 75 f4             	pushl  -0xc(%ebp)
80106d92:	e8 89 e5 ff ff       	call   80105320 <sem_acquire>
80106d97:	83 c4 10             	add    $0x10,%esp
}
80106d9a:	c9                   	leave  
80106d9b:	c3                   	ret    
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106da0:	c9                   	leave  
    return -1;
80106da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106da6:	c3                   	ret    
80106da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dae:	66 90                	xchg   %ax,%ax

80106db0 <sys_sem_release>:

int sys_sem_release(void)
{
80106db0:	f3 0f 1e fb          	endbr32 
80106db4:	55                   	push   %ebp
80106db5:	89 e5                	mov    %esp,%ebp
80106db7:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0) 
80106dba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dbd:	50                   	push   %eax
80106dbe:	6a 00                	push   $0x0
80106dc0:	e8 2b ee ff ff       	call   80105bf0 <argint>
80106dc5:	83 c4 10             	add    $0x10,%esp
80106dc8:	85 c0                	test   %eax,%eax
80106dca:	78 14                	js     80106de0 <sys_sem_release+0x30>
    return -1;
  return sem_release(i);
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	ff 75 f4             	pushl  -0xc(%ebp)
80106dd2:	e8 09 e6 ff ff       	call   801053e0 <sem_release>
80106dd7:	83 c4 10             	add    $0x10,%esp
}
80106dda:	c9                   	leave  
80106ddb:	c3                   	ret    
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106de0:	c9                   	leave  
    return -1;
80106de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de6:	c3                   	ret    
80106de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <sys_reentrant>:

void sys_reentrant(void)
{
80106df0:	f3 0f 1e fb          	endbr32 
80106df4:	55                   	push   %ebp
80106df5:	89 e5                	mov    %esp,%ebp
80106df7:	83 ec 20             	sub    $0x20,%esp
  int count;
  argint(0, &count);
80106dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dfd:	50                   	push   %eax
80106dfe:	6a 00                	push   $0x0
80106e00:	e8 eb ed ff ff       	call   80105bf0 <argint>
  reentrant(count);
80106e05:	58                   	pop    %eax
80106e06:	ff 75 f4             	pushl  -0xc(%ebp)
80106e09:	e8 82 e6 ff ff       	call   80105490 <reentrant>
80106e0e:	83 c4 10             	add    $0x10,%esp
80106e11:	c9                   	leave  
80106e12:	c3                   	ret    

80106e13 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106e13:	1e                   	push   %ds
  pushl %es
80106e14:	06                   	push   %es
  pushl %fs
80106e15:	0f a0                	push   %fs
  pushl %gs
80106e17:	0f a8                	push   %gs
  pushal
80106e19:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106e1a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106e1e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106e20:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106e22:	54                   	push   %esp
  call trap
80106e23:	e8 c8 00 00 00       	call   80106ef0 <trap>
  addl $4, %esp
80106e28:	83 c4 04             	add    $0x4,%esp

80106e2b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106e2b:	61                   	popa   
  popl %gs
80106e2c:	0f a9                	pop    %gs
  popl %fs
80106e2e:	0f a1                	pop    %fs
  popl %es
80106e30:	07                   	pop    %es
  popl %ds
80106e31:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106e32:	83 c4 08             	add    $0x8,%esp
  iret
80106e35:	cf                   	iret   
80106e36:	66 90                	xchg   %ax,%ax
80106e38:	66 90                	xchg   %ax,%ax
80106e3a:	66 90                	xchg   %ax,%ax
80106e3c:	66 90                	xchg   %ax,%ax
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106e40:	f3 0f 1e fb          	endbr32 
80106e44:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106e45:	31 c0                	xor    %eax,%eax
{
80106e47:	89 e5                	mov    %esp,%ebp
80106e49:	83 ec 08             	sub    $0x8,%esp
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106e50:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106e57:	c7 04 c5 02 a6 11 80 	movl   $0x8e000008,-0x7fee59fe(,%eax,8)
80106e5e:	08 00 00 8e 
80106e62:	66 89 14 c5 00 a6 11 	mov    %dx,-0x7fee5a00(,%eax,8)
80106e69:	80 
80106e6a:	c1 ea 10             	shr    $0x10,%edx
80106e6d:	66 89 14 c5 06 a6 11 	mov    %dx,-0x7fee59fa(,%eax,8)
80106e74:	80 
  for(i = 0; i < 256; i++)
80106e75:	83 c0 01             	add    $0x1,%eax
80106e78:	3d 00 01 00 00       	cmp    $0x100,%eax
80106e7d:	75 d1                	jne    80106e50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106e7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e82:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106e87:	c7 05 02 a8 11 80 08 	movl   $0xef000008,0x8011a802
80106e8e:	00 00 ef 
  initlock(&tickslock, "time");
80106e91:	68 9c 8c 10 80       	push   $0x80108c9c
80106e96:	68 c0 a5 11 80       	push   $0x8011a5c0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106e9b:	66 a3 00 a8 11 80    	mov    %ax,0x8011a800
80106ea1:	c1 e8 10             	shr    $0x10,%eax
80106ea4:	66 a3 06 a8 11 80    	mov    %ax,0x8011a806
  initlock(&tickslock, "time");
80106eaa:	e8 81 e7 ff ff       	call   80105630 <initlock>
}
80106eaf:	83 c4 10             	add    $0x10,%esp
80106eb2:	c9                   	leave  
80106eb3:	c3                   	ret    
80106eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop

80106ec0 <idtinit>:

void
idtinit(void)
{
80106ec0:	f3 0f 1e fb          	endbr32 
80106ec4:	55                   	push   %ebp
  pd[0] = size-1;
80106ec5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106eca:	89 e5                	mov    %esp,%ebp
80106ecc:	83 ec 10             	sub    $0x10,%esp
80106ecf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ed3:	b8 00 a6 11 80       	mov    $0x8011a600,%eax
80106ed8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106edc:	c1 e8 10             	shr    $0x10,%eax
80106edf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106ee3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ee6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106ee9:	c9                   	leave  
80106eea:	c3                   	ret    
80106eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eef:	90                   	nop

80106ef0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106ef0:	f3 0f 1e fb          	endbr32 
80106ef4:	55                   	push   %ebp
80106ef5:	89 e5                	mov    %esp,%ebp
80106ef7:	57                   	push   %edi
80106ef8:	56                   	push   %esi
80106ef9:	53                   	push   %ebx
80106efa:	83 ec 1c             	sub    $0x1c,%esp
80106efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106f00:	8b 43 30             	mov    0x30(%ebx),%eax
80106f03:	83 f8 40             	cmp    $0x40,%eax
80106f06:	0f 84 bc 01 00 00    	je     801070c8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106f0c:	83 e8 20             	sub    $0x20,%eax
80106f0f:	83 f8 1f             	cmp    $0x1f,%eax
80106f12:	77 08                	ja     80106f1c <trap+0x2c>
80106f14:	3e ff 24 85 4c 90 10 	notrack jmp *-0x7fef6fb4(,%eax,4)
80106f1b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106f1c:	e8 ff d1 ff ff       	call   80104120 <myproc>
80106f21:	8b 7b 38             	mov    0x38(%ebx),%edi
80106f24:	85 c0                	test   %eax,%eax
80106f26:	0f 84 eb 01 00 00    	je     80107117 <trap+0x227>
80106f2c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106f30:	0f 84 e1 01 00 00    	je     80107117 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f36:	0f 20 d1             	mov    %cr2,%ecx
80106f39:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f3c:	e8 bf d1 ff ff       	call   80104100 <cpuid>
80106f41:	8b 73 30             	mov    0x30(%ebx),%esi
80106f44:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f47:	8b 43 34             	mov    0x34(%ebx),%eax
80106f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106f4d:	e8 ce d1 ff ff       	call   80104120 <myproc>
80106f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f55:	e8 c6 d1 ff ff       	call   80104120 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f5a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106f5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106f60:	51                   	push   %ecx
80106f61:	57                   	push   %edi
80106f62:	52                   	push   %edx
80106f63:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f66:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106f67:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106f6a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106f6d:	56                   	push   %esi
80106f6e:	ff 70 10             	pushl  0x10(%eax)
80106f71:	68 08 90 10 80       	push   $0x80109008
80106f76:	e8 25 98 ff ff       	call   801007a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106f7b:	83 c4 20             	add    $0x20,%esp
80106f7e:	e8 9d d1 ff ff       	call   80104120 <myproc>
80106f83:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f8a:	e8 91 d1 ff ff       	call   80104120 <myproc>
80106f8f:	85 c0                	test   %eax,%eax
80106f91:	74 1d                	je     80106fb0 <trap+0xc0>
80106f93:	e8 88 d1 ff ff       	call   80104120 <myproc>
80106f98:	8b 50 24             	mov    0x24(%eax),%edx
80106f9b:	85 d2                	test   %edx,%edx
80106f9d:	74 11                	je     80106fb0 <trap+0xc0>
80106f9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106fa3:	83 e0 03             	and    $0x3,%eax
80106fa6:	66 83 f8 03          	cmp    $0x3,%ax
80106faa:	0f 84 50 01 00 00    	je     80107100 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106fb0:	e8 6b d1 ff ff       	call   80104120 <myproc>
80106fb5:	85 c0                	test   %eax,%eax
80106fb7:	74 0f                	je     80106fc8 <trap+0xd8>
80106fb9:	e8 62 d1 ff ff       	call   80104120 <myproc>
80106fbe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106fc2:	0f 84 e8 00 00 00    	je     801070b0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106fc8:	e8 53 d1 ff ff       	call   80104120 <myproc>
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	74 1d                	je     80106fee <trap+0xfe>
80106fd1:	e8 4a d1 ff ff       	call   80104120 <myproc>
80106fd6:	8b 40 24             	mov    0x24(%eax),%eax
80106fd9:	85 c0                	test   %eax,%eax
80106fdb:	74 11                	je     80106fee <trap+0xfe>
80106fdd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106fe1:	83 e0 03             	and    $0x3,%eax
80106fe4:	66 83 f8 03          	cmp    $0x3,%ax
80106fe8:	0f 84 03 01 00 00    	je     801070f1 <trap+0x201>
    exit();
}
80106fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff1:	5b                   	pop    %ebx
80106ff2:	5e                   	pop    %esi
80106ff3:	5f                   	pop    %edi
80106ff4:	5d                   	pop    %ebp
80106ff5:	c3                   	ret    
    ideintr();
80106ff6:	e8 85 b8 ff ff       	call   80102880 <ideintr>
    lapiceoi();
80106ffb:	e8 60 bf ff ff       	call   80102f60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107000:	e8 1b d1 ff ff       	call   80104120 <myproc>
80107005:	85 c0                	test   %eax,%eax
80107007:	75 8a                	jne    80106f93 <trap+0xa3>
80107009:	eb a5                	jmp    80106fb0 <trap+0xc0>
    if(cpuid() == 0){
8010700b:	e8 f0 d0 ff ff       	call   80104100 <cpuid>
80107010:	85 c0                	test   %eax,%eax
80107012:	75 e7                	jne    80106ffb <trap+0x10b>
      acquire(&tickslock);
80107014:	83 ec 0c             	sub    $0xc,%esp
80107017:	68 c0 a5 11 80       	push   $0x8011a5c0
8010701c:	e8 9f e7 ff ff       	call   801057c0 <acquire>
      wakeup(&ticks);
80107021:	c7 04 24 00 ae 11 80 	movl   $0x8011ae00,(%esp)
      ticks++;
80107028:	83 05 00 ae 11 80 01 	addl   $0x1,0x8011ae00
      wakeup(&ticks);
8010702f:	e8 9c da ff ff       	call   80104ad0 <wakeup>
      release(&tickslock);
80107034:	c7 04 24 c0 a5 11 80 	movl   $0x8011a5c0,(%esp)
8010703b:	e8 70 e8 ff ff       	call   801058b0 <release>
80107040:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107043:	eb b6                	jmp    80106ffb <trap+0x10b>
    kbdintr();
80107045:	e8 d6 bd ff ff       	call   80102e20 <kbdintr>
    lapiceoi();
8010704a:	e8 11 bf ff ff       	call   80102f60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010704f:	e8 cc d0 ff ff       	call   80104120 <myproc>
80107054:	85 c0                	test   %eax,%eax
80107056:	0f 85 37 ff ff ff    	jne    80106f93 <trap+0xa3>
8010705c:	e9 4f ff ff ff       	jmp    80106fb0 <trap+0xc0>
    uartintr();
80107061:	e8 4a 02 00 00       	call   801072b0 <uartintr>
    lapiceoi();
80107066:	e8 f5 be ff ff       	call   80102f60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010706b:	e8 b0 d0 ff ff       	call   80104120 <myproc>
80107070:	85 c0                	test   %eax,%eax
80107072:	0f 85 1b ff ff ff    	jne    80106f93 <trap+0xa3>
80107078:	e9 33 ff ff ff       	jmp    80106fb0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010707d:	8b 7b 38             	mov    0x38(%ebx),%edi
80107080:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107084:	e8 77 d0 ff ff       	call   80104100 <cpuid>
80107089:	57                   	push   %edi
8010708a:	56                   	push   %esi
8010708b:	50                   	push   %eax
8010708c:	68 b0 8f 10 80       	push   $0x80108fb0
80107091:	e8 0a 97 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80107096:	e8 c5 be ff ff       	call   80102f60 <lapiceoi>
    break;
8010709b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010709e:	e8 7d d0 ff ff       	call   80104120 <myproc>
801070a3:	85 c0                	test   %eax,%eax
801070a5:	0f 85 e8 fe ff ff    	jne    80106f93 <trap+0xa3>
801070ab:	e9 00 ff ff ff       	jmp    80106fb0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801070b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801070b4:	0f 85 0e ff ff ff    	jne    80106fc8 <trap+0xd8>
    yield();
801070ba:	e8 01 d8 ff ff       	call   801048c0 <yield>
801070bf:	e9 04 ff ff ff       	jmp    80106fc8 <trap+0xd8>
801070c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801070c8:	e8 53 d0 ff ff       	call   80104120 <myproc>
801070cd:	8b 70 24             	mov    0x24(%eax),%esi
801070d0:	85 f6                	test   %esi,%esi
801070d2:	75 3c                	jne    80107110 <trap+0x220>
    myproc()->tf = tf;
801070d4:	e8 47 d0 ff ff       	call   80104120 <myproc>
801070d9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801070dc:	e8 ff eb ff ff       	call   80105ce0 <syscall>
    if(myproc()->killed)
801070e1:	e8 3a d0 ff ff       	call   80104120 <myproc>
801070e6:	8b 48 24             	mov    0x24(%eax),%ecx
801070e9:	85 c9                	test   %ecx,%ecx
801070eb:	0f 84 fd fe ff ff    	je     80106fee <trap+0xfe>
}
801070f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f4:	5b                   	pop    %ebx
801070f5:	5e                   	pop    %esi
801070f6:	5f                   	pop    %edi
801070f7:	5d                   	pop    %ebp
      exit();
801070f8:	e9 83 d6 ff ff       	jmp    80104780 <exit>
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80107100:	e8 7b d6 ff ff       	call   80104780 <exit>
80107105:	e9 a6 fe ff ff       	jmp    80106fb0 <trap+0xc0>
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107110:	e8 6b d6 ff ff       	call   80104780 <exit>
80107115:	eb bd                	jmp    801070d4 <trap+0x1e4>
80107117:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010711a:	e8 e1 cf ff ff       	call   80104100 <cpuid>
8010711f:	83 ec 0c             	sub    $0xc,%esp
80107122:	56                   	push   %esi
80107123:	57                   	push   %edi
80107124:	50                   	push   %eax
80107125:	ff 73 30             	pushl  0x30(%ebx)
80107128:	68 d4 8f 10 80       	push   $0x80108fd4
8010712d:	e8 6e 96 ff ff       	call   801007a0 <cprintf>
      panic("trap");
80107132:	83 c4 14             	add    $0x14,%esp
80107135:	68 a9 8f 10 80       	push   $0x80108fa9
8010713a:	e8 51 92 ff ff       	call   80100390 <panic>
8010713f:	90                   	nop

80107140 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80107140:	f3 0f 1e fb          	endbr32 
  if(!uart)
80107144:	a1 00 c6 10 80       	mov    0x8010c600,%eax
80107149:	85 c0                	test   %eax,%eax
8010714b:	74 1b                	je     80107168 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010714d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107152:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107153:	a8 01                	test   $0x1,%al
80107155:	74 11                	je     80107168 <uartgetc+0x28>
80107157:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010715c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010715d:	0f b6 c0             	movzbl %al,%eax
80107160:	c3                   	ret    
80107161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010716d:	c3                   	ret    
8010716e:	66 90                	xchg   %ax,%ax

80107170 <uartputc.part.0>:
uartputc(int c)
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	89 c7                	mov    %eax,%edi
80107176:	56                   	push   %esi
80107177:	be fd 03 00 00       	mov    $0x3fd,%esi
8010717c:	53                   	push   %ebx
8010717d:	bb 80 00 00 00       	mov    $0x80,%ebx
80107182:	83 ec 0c             	sub    $0xc,%esp
80107185:	eb 1b                	jmp    801071a2 <uartputc.part.0+0x32>
80107187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80107190:	83 ec 0c             	sub    $0xc,%esp
80107193:	6a 0a                	push   $0xa
80107195:	e8 e6 bd ff ff       	call   80102f80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010719a:	83 c4 10             	add    $0x10,%esp
8010719d:	83 eb 01             	sub    $0x1,%ebx
801071a0:	74 07                	je     801071a9 <uartputc.part.0+0x39>
801071a2:	89 f2                	mov    %esi,%edx
801071a4:	ec                   	in     (%dx),%al
801071a5:	a8 20                	test   $0x20,%al
801071a7:	74 e7                	je     80107190 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801071a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801071ae:	89 f8                	mov    %edi,%eax
801071b0:	ee                   	out    %al,(%dx)
}
801071b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b4:	5b                   	pop    %ebx
801071b5:	5e                   	pop    %esi
801071b6:	5f                   	pop    %edi
801071b7:	5d                   	pop    %ebp
801071b8:	c3                   	ret    
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <uartinit>:
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
801071c5:	31 c9                	xor    %ecx,%ecx
801071c7:	89 c8                	mov    %ecx,%eax
801071c9:	89 e5                	mov    %esp,%ebp
801071cb:	57                   	push   %edi
801071cc:	56                   	push   %esi
801071cd:	53                   	push   %ebx
801071ce:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801071d3:	89 da                	mov    %ebx,%edx
801071d5:	83 ec 0c             	sub    $0xc,%esp
801071d8:	ee                   	out    %al,(%dx)
801071d9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801071de:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801071e3:	89 fa                	mov    %edi,%edx
801071e5:	ee                   	out    %al,(%dx)
801071e6:	b8 0c 00 00 00       	mov    $0xc,%eax
801071eb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801071f0:	ee                   	out    %al,(%dx)
801071f1:	be f9 03 00 00       	mov    $0x3f9,%esi
801071f6:	89 c8                	mov    %ecx,%eax
801071f8:	89 f2                	mov    %esi,%edx
801071fa:	ee                   	out    %al,(%dx)
801071fb:	b8 03 00 00 00       	mov    $0x3,%eax
80107200:	89 fa                	mov    %edi,%edx
80107202:	ee                   	out    %al,(%dx)
80107203:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107208:	89 c8                	mov    %ecx,%eax
8010720a:	ee                   	out    %al,(%dx)
8010720b:	b8 01 00 00 00       	mov    $0x1,%eax
80107210:	89 f2                	mov    %esi,%edx
80107212:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107213:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107218:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107219:	3c ff                	cmp    $0xff,%al
8010721b:	74 52                	je     8010726f <uartinit+0xaf>
  uart = 1;
8010721d:	c7 05 00 c6 10 80 01 	movl   $0x1,0x8010c600
80107224:	00 00 00 
80107227:	89 da                	mov    %ebx,%edx
80107229:	ec                   	in     (%dx),%al
8010722a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010722f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107230:	83 ec 08             	sub    $0x8,%esp
80107233:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80107238:	bb cc 90 10 80       	mov    $0x801090cc,%ebx
  ioapicenable(IRQ_COM1, 0);
8010723d:	6a 00                	push   $0x0
8010723f:	6a 04                	push   $0x4
80107241:	e8 8a b8 ff ff       	call   80102ad0 <ioapicenable>
80107246:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107249:	b8 78 00 00 00       	mov    $0x78,%eax
8010724e:	eb 04                	jmp    80107254 <uartinit+0x94>
80107250:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80107254:	8b 15 00 c6 10 80    	mov    0x8010c600,%edx
8010725a:	85 d2                	test   %edx,%edx
8010725c:	74 08                	je     80107266 <uartinit+0xa6>
    uartputc(*p);
8010725e:	0f be c0             	movsbl %al,%eax
80107261:	e8 0a ff ff ff       	call   80107170 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80107266:	89 f0                	mov    %esi,%eax
80107268:	83 c3 01             	add    $0x1,%ebx
8010726b:	84 c0                	test   %al,%al
8010726d:	75 e1                	jne    80107250 <uartinit+0x90>
}
8010726f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107272:	5b                   	pop    %ebx
80107273:	5e                   	pop    %esi
80107274:	5f                   	pop    %edi
80107275:	5d                   	pop    %ebp
80107276:	c3                   	ret    
80107277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727e:	66 90                	xchg   %ax,%ax

80107280 <uartputc>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
  if(!uart)
80107285:	8b 15 00 c6 10 80    	mov    0x8010c600,%edx
{
8010728b:	89 e5                	mov    %esp,%ebp
8010728d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80107290:	85 d2                	test   %edx,%edx
80107292:	74 0c                	je     801072a0 <uartputc+0x20>
}
80107294:	5d                   	pop    %ebp
80107295:	e9 d6 fe ff ff       	jmp    80107170 <uartputc.part.0>
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret    
801072a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072b0 <uartintr>:

void
uartintr(void)
{
801072b0:	f3 0f 1e fb          	endbr32 
801072b4:	55                   	push   %ebp
801072b5:	89 e5                	mov    %esp,%ebp
801072b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801072ba:	68 40 71 10 80       	push   $0x80107140
801072bf:	e8 3c 99 ff ff       	call   80100c00 <consoleintr>
}
801072c4:	83 c4 10             	add    $0x10,%esp
801072c7:	c9                   	leave  
801072c8:	c3                   	ret    

801072c9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $0
801072cb:	6a 00                	push   $0x0
  jmp alltraps
801072cd:	e9 41 fb ff ff       	jmp    80106e13 <alltraps>

801072d2 <vector1>:
.globl vector1
vector1:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $1
801072d4:	6a 01                	push   $0x1
  jmp alltraps
801072d6:	e9 38 fb ff ff       	jmp    80106e13 <alltraps>

801072db <vector2>:
.globl vector2
vector2:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $2
801072dd:	6a 02                	push   $0x2
  jmp alltraps
801072df:	e9 2f fb ff ff       	jmp    80106e13 <alltraps>

801072e4 <vector3>:
.globl vector3
vector3:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $3
801072e6:	6a 03                	push   $0x3
  jmp alltraps
801072e8:	e9 26 fb ff ff       	jmp    80106e13 <alltraps>

801072ed <vector4>:
.globl vector4
vector4:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $4
801072ef:	6a 04                	push   $0x4
  jmp alltraps
801072f1:	e9 1d fb ff ff       	jmp    80106e13 <alltraps>

801072f6 <vector5>:
.globl vector5
vector5:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $5
801072f8:	6a 05                	push   $0x5
  jmp alltraps
801072fa:	e9 14 fb ff ff       	jmp    80106e13 <alltraps>

801072ff <vector6>:
.globl vector6
vector6:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $6
80107301:	6a 06                	push   $0x6
  jmp alltraps
80107303:	e9 0b fb ff ff       	jmp    80106e13 <alltraps>

80107308 <vector7>:
.globl vector7
vector7:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $7
8010730a:	6a 07                	push   $0x7
  jmp alltraps
8010730c:	e9 02 fb ff ff       	jmp    80106e13 <alltraps>

80107311 <vector8>:
.globl vector8
vector8:
  pushl $8
80107311:	6a 08                	push   $0x8
  jmp alltraps
80107313:	e9 fb fa ff ff       	jmp    80106e13 <alltraps>

80107318 <vector9>:
.globl vector9
vector9:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $9
8010731a:	6a 09                	push   $0x9
  jmp alltraps
8010731c:	e9 f2 fa ff ff       	jmp    80106e13 <alltraps>

80107321 <vector10>:
.globl vector10
vector10:
  pushl $10
80107321:	6a 0a                	push   $0xa
  jmp alltraps
80107323:	e9 eb fa ff ff       	jmp    80106e13 <alltraps>

80107328 <vector11>:
.globl vector11
vector11:
  pushl $11
80107328:	6a 0b                	push   $0xb
  jmp alltraps
8010732a:	e9 e4 fa ff ff       	jmp    80106e13 <alltraps>

8010732f <vector12>:
.globl vector12
vector12:
  pushl $12
8010732f:	6a 0c                	push   $0xc
  jmp alltraps
80107331:	e9 dd fa ff ff       	jmp    80106e13 <alltraps>

80107336 <vector13>:
.globl vector13
vector13:
  pushl $13
80107336:	6a 0d                	push   $0xd
  jmp alltraps
80107338:	e9 d6 fa ff ff       	jmp    80106e13 <alltraps>

8010733d <vector14>:
.globl vector14
vector14:
  pushl $14
8010733d:	6a 0e                	push   $0xe
  jmp alltraps
8010733f:	e9 cf fa ff ff       	jmp    80106e13 <alltraps>

80107344 <vector15>:
.globl vector15
vector15:
  pushl $0
80107344:	6a 00                	push   $0x0
  pushl $15
80107346:	6a 0f                	push   $0xf
  jmp alltraps
80107348:	e9 c6 fa ff ff       	jmp    80106e13 <alltraps>

8010734d <vector16>:
.globl vector16
vector16:
  pushl $0
8010734d:	6a 00                	push   $0x0
  pushl $16
8010734f:	6a 10                	push   $0x10
  jmp alltraps
80107351:	e9 bd fa ff ff       	jmp    80106e13 <alltraps>

80107356 <vector17>:
.globl vector17
vector17:
  pushl $17
80107356:	6a 11                	push   $0x11
  jmp alltraps
80107358:	e9 b6 fa ff ff       	jmp    80106e13 <alltraps>

8010735d <vector18>:
.globl vector18
vector18:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $18
8010735f:	6a 12                	push   $0x12
  jmp alltraps
80107361:	e9 ad fa ff ff       	jmp    80106e13 <alltraps>

80107366 <vector19>:
.globl vector19
vector19:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $19
80107368:	6a 13                	push   $0x13
  jmp alltraps
8010736a:	e9 a4 fa ff ff       	jmp    80106e13 <alltraps>

8010736f <vector20>:
.globl vector20
vector20:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $20
80107371:	6a 14                	push   $0x14
  jmp alltraps
80107373:	e9 9b fa ff ff       	jmp    80106e13 <alltraps>

80107378 <vector21>:
.globl vector21
vector21:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $21
8010737a:	6a 15                	push   $0x15
  jmp alltraps
8010737c:	e9 92 fa ff ff       	jmp    80106e13 <alltraps>

80107381 <vector22>:
.globl vector22
vector22:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $22
80107383:	6a 16                	push   $0x16
  jmp alltraps
80107385:	e9 89 fa ff ff       	jmp    80106e13 <alltraps>

8010738a <vector23>:
.globl vector23
vector23:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $23
8010738c:	6a 17                	push   $0x17
  jmp alltraps
8010738e:	e9 80 fa ff ff       	jmp    80106e13 <alltraps>

80107393 <vector24>:
.globl vector24
vector24:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $24
80107395:	6a 18                	push   $0x18
  jmp alltraps
80107397:	e9 77 fa ff ff       	jmp    80106e13 <alltraps>

8010739c <vector25>:
.globl vector25
vector25:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $25
8010739e:	6a 19                	push   $0x19
  jmp alltraps
801073a0:	e9 6e fa ff ff       	jmp    80106e13 <alltraps>

801073a5 <vector26>:
.globl vector26
vector26:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $26
801073a7:	6a 1a                	push   $0x1a
  jmp alltraps
801073a9:	e9 65 fa ff ff       	jmp    80106e13 <alltraps>

801073ae <vector27>:
.globl vector27
vector27:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $27
801073b0:	6a 1b                	push   $0x1b
  jmp alltraps
801073b2:	e9 5c fa ff ff       	jmp    80106e13 <alltraps>

801073b7 <vector28>:
.globl vector28
vector28:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $28
801073b9:	6a 1c                	push   $0x1c
  jmp alltraps
801073bb:	e9 53 fa ff ff       	jmp    80106e13 <alltraps>

801073c0 <vector29>:
.globl vector29
vector29:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $29
801073c2:	6a 1d                	push   $0x1d
  jmp alltraps
801073c4:	e9 4a fa ff ff       	jmp    80106e13 <alltraps>

801073c9 <vector30>:
.globl vector30
vector30:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $30
801073cb:	6a 1e                	push   $0x1e
  jmp alltraps
801073cd:	e9 41 fa ff ff       	jmp    80106e13 <alltraps>

801073d2 <vector31>:
.globl vector31
vector31:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $31
801073d4:	6a 1f                	push   $0x1f
  jmp alltraps
801073d6:	e9 38 fa ff ff       	jmp    80106e13 <alltraps>

801073db <vector32>:
.globl vector32
vector32:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $32
801073dd:	6a 20                	push   $0x20
  jmp alltraps
801073df:	e9 2f fa ff ff       	jmp    80106e13 <alltraps>

801073e4 <vector33>:
.globl vector33
vector33:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $33
801073e6:	6a 21                	push   $0x21
  jmp alltraps
801073e8:	e9 26 fa ff ff       	jmp    80106e13 <alltraps>

801073ed <vector34>:
.globl vector34
vector34:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $34
801073ef:	6a 22                	push   $0x22
  jmp alltraps
801073f1:	e9 1d fa ff ff       	jmp    80106e13 <alltraps>

801073f6 <vector35>:
.globl vector35
vector35:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $35
801073f8:	6a 23                	push   $0x23
  jmp alltraps
801073fa:	e9 14 fa ff ff       	jmp    80106e13 <alltraps>

801073ff <vector36>:
.globl vector36
vector36:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $36
80107401:	6a 24                	push   $0x24
  jmp alltraps
80107403:	e9 0b fa ff ff       	jmp    80106e13 <alltraps>

80107408 <vector37>:
.globl vector37
vector37:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $37
8010740a:	6a 25                	push   $0x25
  jmp alltraps
8010740c:	e9 02 fa ff ff       	jmp    80106e13 <alltraps>

80107411 <vector38>:
.globl vector38
vector38:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $38
80107413:	6a 26                	push   $0x26
  jmp alltraps
80107415:	e9 f9 f9 ff ff       	jmp    80106e13 <alltraps>

8010741a <vector39>:
.globl vector39
vector39:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $39
8010741c:	6a 27                	push   $0x27
  jmp alltraps
8010741e:	e9 f0 f9 ff ff       	jmp    80106e13 <alltraps>

80107423 <vector40>:
.globl vector40
vector40:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $40
80107425:	6a 28                	push   $0x28
  jmp alltraps
80107427:	e9 e7 f9 ff ff       	jmp    80106e13 <alltraps>

8010742c <vector41>:
.globl vector41
vector41:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $41
8010742e:	6a 29                	push   $0x29
  jmp alltraps
80107430:	e9 de f9 ff ff       	jmp    80106e13 <alltraps>

80107435 <vector42>:
.globl vector42
vector42:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $42
80107437:	6a 2a                	push   $0x2a
  jmp alltraps
80107439:	e9 d5 f9 ff ff       	jmp    80106e13 <alltraps>

8010743e <vector43>:
.globl vector43
vector43:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $43
80107440:	6a 2b                	push   $0x2b
  jmp alltraps
80107442:	e9 cc f9 ff ff       	jmp    80106e13 <alltraps>

80107447 <vector44>:
.globl vector44
vector44:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $44
80107449:	6a 2c                	push   $0x2c
  jmp alltraps
8010744b:	e9 c3 f9 ff ff       	jmp    80106e13 <alltraps>

80107450 <vector45>:
.globl vector45
vector45:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $45
80107452:	6a 2d                	push   $0x2d
  jmp alltraps
80107454:	e9 ba f9 ff ff       	jmp    80106e13 <alltraps>

80107459 <vector46>:
.globl vector46
vector46:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $46
8010745b:	6a 2e                	push   $0x2e
  jmp alltraps
8010745d:	e9 b1 f9 ff ff       	jmp    80106e13 <alltraps>

80107462 <vector47>:
.globl vector47
vector47:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $47
80107464:	6a 2f                	push   $0x2f
  jmp alltraps
80107466:	e9 a8 f9 ff ff       	jmp    80106e13 <alltraps>

8010746b <vector48>:
.globl vector48
vector48:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $48
8010746d:	6a 30                	push   $0x30
  jmp alltraps
8010746f:	e9 9f f9 ff ff       	jmp    80106e13 <alltraps>

80107474 <vector49>:
.globl vector49
vector49:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $49
80107476:	6a 31                	push   $0x31
  jmp alltraps
80107478:	e9 96 f9 ff ff       	jmp    80106e13 <alltraps>

8010747d <vector50>:
.globl vector50
vector50:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $50
8010747f:	6a 32                	push   $0x32
  jmp alltraps
80107481:	e9 8d f9 ff ff       	jmp    80106e13 <alltraps>

80107486 <vector51>:
.globl vector51
vector51:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $51
80107488:	6a 33                	push   $0x33
  jmp alltraps
8010748a:	e9 84 f9 ff ff       	jmp    80106e13 <alltraps>

8010748f <vector52>:
.globl vector52
vector52:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $52
80107491:	6a 34                	push   $0x34
  jmp alltraps
80107493:	e9 7b f9 ff ff       	jmp    80106e13 <alltraps>

80107498 <vector53>:
.globl vector53
vector53:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $53
8010749a:	6a 35                	push   $0x35
  jmp alltraps
8010749c:	e9 72 f9 ff ff       	jmp    80106e13 <alltraps>

801074a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $54
801074a3:	6a 36                	push   $0x36
  jmp alltraps
801074a5:	e9 69 f9 ff ff       	jmp    80106e13 <alltraps>

801074aa <vector55>:
.globl vector55
vector55:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $55
801074ac:	6a 37                	push   $0x37
  jmp alltraps
801074ae:	e9 60 f9 ff ff       	jmp    80106e13 <alltraps>

801074b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $56
801074b5:	6a 38                	push   $0x38
  jmp alltraps
801074b7:	e9 57 f9 ff ff       	jmp    80106e13 <alltraps>

801074bc <vector57>:
.globl vector57
vector57:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $57
801074be:	6a 39                	push   $0x39
  jmp alltraps
801074c0:	e9 4e f9 ff ff       	jmp    80106e13 <alltraps>

801074c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $58
801074c7:	6a 3a                	push   $0x3a
  jmp alltraps
801074c9:	e9 45 f9 ff ff       	jmp    80106e13 <alltraps>

801074ce <vector59>:
.globl vector59
vector59:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $59
801074d0:	6a 3b                	push   $0x3b
  jmp alltraps
801074d2:	e9 3c f9 ff ff       	jmp    80106e13 <alltraps>

801074d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $60
801074d9:	6a 3c                	push   $0x3c
  jmp alltraps
801074db:	e9 33 f9 ff ff       	jmp    80106e13 <alltraps>

801074e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $61
801074e2:	6a 3d                	push   $0x3d
  jmp alltraps
801074e4:	e9 2a f9 ff ff       	jmp    80106e13 <alltraps>

801074e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $62
801074eb:	6a 3e                	push   $0x3e
  jmp alltraps
801074ed:	e9 21 f9 ff ff       	jmp    80106e13 <alltraps>

801074f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $63
801074f4:	6a 3f                	push   $0x3f
  jmp alltraps
801074f6:	e9 18 f9 ff ff       	jmp    80106e13 <alltraps>

801074fb <vector64>:
.globl vector64
vector64:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $64
801074fd:	6a 40                	push   $0x40
  jmp alltraps
801074ff:	e9 0f f9 ff ff       	jmp    80106e13 <alltraps>

80107504 <vector65>:
.globl vector65
vector65:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $65
80107506:	6a 41                	push   $0x41
  jmp alltraps
80107508:	e9 06 f9 ff ff       	jmp    80106e13 <alltraps>

8010750d <vector66>:
.globl vector66
vector66:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $66
8010750f:	6a 42                	push   $0x42
  jmp alltraps
80107511:	e9 fd f8 ff ff       	jmp    80106e13 <alltraps>

80107516 <vector67>:
.globl vector67
vector67:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $67
80107518:	6a 43                	push   $0x43
  jmp alltraps
8010751a:	e9 f4 f8 ff ff       	jmp    80106e13 <alltraps>

8010751f <vector68>:
.globl vector68
vector68:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $68
80107521:	6a 44                	push   $0x44
  jmp alltraps
80107523:	e9 eb f8 ff ff       	jmp    80106e13 <alltraps>

80107528 <vector69>:
.globl vector69
vector69:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $69
8010752a:	6a 45                	push   $0x45
  jmp alltraps
8010752c:	e9 e2 f8 ff ff       	jmp    80106e13 <alltraps>

80107531 <vector70>:
.globl vector70
vector70:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $70
80107533:	6a 46                	push   $0x46
  jmp alltraps
80107535:	e9 d9 f8 ff ff       	jmp    80106e13 <alltraps>

8010753a <vector71>:
.globl vector71
vector71:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $71
8010753c:	6a 47                	push   $0x47
  jmp alltraps
8010753e:	e9 d0 f8 ff ff       	jmp    80106e13 <alltraps>

80107543 <vector72>:
.globl vector72
vector72:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $72
80107545:	6a 48                	push   $0x48
  jmp alltraps
80107547:	e9 c7 f8 ff ff       	jmp    80106e13 <alltraps>

8010754c <vector73>:
.globl vector73
vector73:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $73
8010754e:	6a 49                	push   $0x49
  jmp alltraps
80107550:	e9 be f8 ff ff       	jmp    80106e13 <alltraps>

80107555 <vector74>:
.globl vector74
vector74:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $74
80107557:	6a 4a                	push   $0x4a
  jmp alltraps
80107559:	e9 b5 f8 ff ff       	jmp    80106e13 <alltraps>

8010755e <vector75>:
.globl vector75
vector75:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $75
80107560:	6a 4b                	push   $0x4b
  jmp alltraps
80107562:	e9 ac f8 ff ff       	jmp    80106e13 <alltraps>

80107567 <vector76>:
.globl vector76
vector76:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $76
80107569:	6a 4c                	push   $0x4c
  jmp alltraps
8010756b:	e9 a3 f8 ff ff       	jmp    80106e13 <alltraps>

80107570 <vector77>:
.globl vector77
vector77:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $77
80107572:	6a 4d                	push   $0x4d
  jmp alltraps
80107574:	e9 9a f8 ff ff       	jmp    80106e13 <alltraps>

80107579 <vector78>:
.globl vector78
vector78:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $78
8010757b:	6a 4e                	push   $0x4e
  jmp alltraps
8010757d:	e9 91 f8 ff ff       	jmp    80106e13 <alltraps>

80107582 <vector79>:
.globl vector79
vector79:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $79
80107584:	6a 4f                	push   $0x4f
  jmp alltraps
80107586:	e9 88 f8 ff ff       	jmp    80106e13 <alltraps>

8010758b <vector80>:
.globl vector80
vector80:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $80
8010758d:	6a 50                	push   $0x50
  jmp alltraps
8010758f:	e9 7f f8 ff ff       	jmp    80106e13 <alltraps>

80107594 <vector81>:
.globl vector81
vector81:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $81
80107596:	6a 51                	push   $0x51
  jmp alltraps
80107598:	e9 76 f8 ff ff       	jmp    80106e13 <alltraps>

8010759d <vector82>:
.globl vector82
vector82:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $82
8010759f:	6a 52                	push   $0x52
  jmp alltraps
801075a1:	e9 6d f8 ff ff       	jmp    80106e13 <alltraps>

801075a6 <vector83>:
.globl vector83
vector83:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $83
801075a8:	6a 53                	push   $0x53
  jmp alltraps
801075aa:	e9 64 f8 ff ff       	jmp    80106e13 <alltraps>

801075af <vector84>:
.globl vector84
vector84:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $84
801075b1:	6a 54                	push   $0x54
  jmp alltraps
801075b3:	e9 5b f8 ff ff       	jmp    80106e13 <alltraps>

801075b8 <vector85>:
.globl vector85
vector85:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $85
801075ba:	6a 55                	push   $0x55
  jmp alltraps
801075bc:	e9 52 f8 ff ff       	jmp    80106e13 <alltraps>

801075c1 <vector86>:
.globl vector86
vector86:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $86
801075c3:	6a 56                	push   $0x56
  jmp alltraps
801075c5:	e9 49 f8 ff ff       	jmp    80106e13 <alltraps>

801075ca <vector87>:
.globl vector87
vector87:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $87
801075cc:	6a 57                	push   $0x57
  jmp alltraps
801075ce:	e9 40 f8 ff ff       	jmp    80106e13 <alltraps>

801075d3 <vector88>:
.globl vector88
vector88:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $88
801075d5:	6a 58                	push   $0x58
  jmp alltraps
801075d7:	e9 37 f8 ff ff       	jmp    80106e13 <alltraps>

801075dc <vector89>:
.globl vector89
vector89:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $89
801075de:	6a 59                	push   $0x59
  jmp alltraps
801075e0:	e9 2e f8 ff ff       	jmp    80106e13 <alltraps>

801075e5 <vector90>:
.globl vector90
vector90:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $90
801075e7:	6a 5a                	push   $0x5a
  jmp alltraps
801075e9:	e9 25 f8 ff ff       	jmp    80106e13 <alltraps>

801075ee <vector91>:
.globl vector91
vector91:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $91
801075f0:	6a 5b                	push   $0x5b
  jmp alltraps
801075f2:	e9 1c f8 ff ff       	jmp    80106e13 <alltraps>

801075f7 <vector92>:
.globl vector92
vector92:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $92
801075f9:	6a 5c                	push   $0x5c
  jmp alltraps
801075fb:	e9 13 f8 ff ff       	jmp    80106e13 <alltraps>

80107600 <vector93>:
.globl vector93
vector93:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $93
80107602:	6a 5d                	push   $0x5d
  jmp alltraps
80107604:	e9 0a f8 ff ff       	jmp    80106e13 <alltraps>

80107609 <vector94>:
.globl vector94
vector94:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $94
8010760b:	6a 5e                	push   $0x5e
  jmp alltraps
8010760d:	e9 01 f8 ff ff       	jmp    80106e13 <alltraps>

80107612 <vector95>:
.globl vector95
vector95:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $95
80107614:	6a 5f                	push   $0x5f
  jmp alltraps
80107616:	e9 f8 f7 ff ff       	jmp    80106e13 <alltraps>

8010761b <vector96>:
.globl vector96
vector96:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $96
8010761d:	6a 60                	push   $0x60
  jmp alltraps
8010761f:	e9 ef f7 ff ff       	jmp    80106e13 <alltraps>

80107624 <vector97>:
.globl vector97
vector97:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $97
80107626:	6a 61                	push   $0x61
  jmp alltraps
80107628:	e9 e6 f7 ff ff       	jmp    80106e13 <alltraps>

8010762d <vector98>:
.globl vector98
vector98:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $98
8010762f:	6a 62                	push   $0x62
  jmp alltraps
80107631:	e9 dd f7 ff ff       	jmp    80106e13 <alltraps>

80107636 <vector99>:
.globl vector99
vector99:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $99
80107638:	6a 63                	push   $0x63
  jmp alltraps
8010763a:	e9 d4 f7 ff ff       	jmp    80106e13 <alltraps>

8010763f <vector100>:
.globl vector100
vector100:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $100
80107641:	6a 64                	push   $0x64
  jmp alltraps
80107643:	e9 cb f7 ff ff       	jmp    80106e13 <alltraps>

80107648 <vector101>:
.globl vector101
vector101:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $101
8010764a:	6a 65                	push   $0x65
  jmp alltraps
8010764c:	e9 c2 f7 ff ff       	jmp    80106e13 <alltraps>

80107651 <vector102>:
.globl vector102
vector102:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $102
80107653:	6a 66                	push   $0x66
  jmp alltraps
80107655:	e9 b9 f7 ff ff       	jmp    80106e13 <alltraps>

8010765a <vector103>:
.globl vector103
vector103:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $103
8010765c:	6a 67                	push   $0x67
  jmp alltraps
8010765e:	e9 b0 f7 ff ff       	jmp    80106e13 <alltraps>

80107663 <vector104>:
.globl vector104
vector104:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $104
80107665:	6a 68                	push   $0x68
  jmp alltraps
80107667:	e9 a7 f7 ff ff       	jmp    80106e13 <alltraps>

8010766c <vector105>:
.globl vector105
vector105:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $105
8010766e:	6a 69                	push   $0x69
  jmp alltraps
80107670:	e9 9e f7 ff ff       	jmp    80106e13 <alltraps>

80107675 <vector106>:
.globl vector106
vector106:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $106
80107677:	6a 6a                	push   $0x6a
  jmp alltraps
80107679:	e9 95 f7 ff ff       	jmp    80106e13 <alltraps>

8010767e <vector107>:
.globl vector107
vector107:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $107
80107680:	6a 6b                	push   $0x6b
  jmp alltraps
80107682:	e9 8c f7 ff ff       	jmp    80106e13 <alltraps>

80107687 <vector108>:
.globl vector108
vector108:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $108
80107689:	6a 6c                	push   $0x6c
  jmp alltraps
8010768b:	e9 83 f7 ff ff       	jmp    80106e13 <alltraps>

80107690 <vector109>:
.globl vector109
vector109:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $109
80107692:	6a 6d                	push   $0x6d
  jmp alltraps
80107694:	e9 7a f7 ff ff       	jmp    80106e13 <alltraps>

80107699 <vector110>:
.globl vector110
vector110:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $110
8010769b:	6a 6e                	push   $0x6e
  jmp alltraps
8010769d:	e9 71 f7 ff ff       	jmp    80106e13 <alltraps>

801076a2 <vector111>:
.globl vector111
vector111:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $111
801076a4:	6a 6f                	push   $0x6f
  jmp alltraps
801076a6:	e9 68 f7 ff ff       	jmp    80106e13 <alltraps>

801076ab <vector112>:
.globl vector112
vector112:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $112
801076ad:	6a 70                	push   $0x70
  jmp alltraps
801076af:	e9 5f f7 ff ff       	jmp    80106e13 <alltraps>

801076b4 <vector113>:
.globl vector113
vector113:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $113
801076b6:	6a 71                	push   $0x71
  jmp alltraps
801076b8:	e9 56 f7 ff ff       	jmp    80106e13 <alltraps>

801076bd <vector114>:
.globl vector114
vector114:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $114
801076bf:	6a 72                	push   $0x72
  jmp alltraps
801076c1:	e9 4d f7 ff ff       	jmp    80106e13 <alltraps>

801076c6 <vector115>:
.globl vector115
vector115:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $115
801076c8:	6a 73                	push   $0x73
  jmp alltraps
801076ca:	e9 44 f7 ff ff       	jmp    80106e13 <alltraps>

801076cf <vector116>:
.globl vector116
vector116:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $116
801076d1:	6a 74                	push   $0x74
  jmp alltraps
801076d3:	e9 3b f7 ff ff       	jmp    80106e13 <alltraps>

801076d8 <vector117>:
.globl vector117
vector117:
  pushl $0
801076d8:	6a 00                	push   $0x0
  pushl $117
801076da:	6a 75                	push   $0x75
  jmp alltraps
801076dc:	e9 32 f7 ff ff       	jmp    80106e13 <alltraps>

801076e1 <vector118>:
.globl vector118
vector118:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $118
801076e3:	6a 76                	push   $0x76
  jmp alltraps
801076e5:	e9 29 f7 ff ff       	jmp    80106e13 <alltraps>

801076ea <vector119>:
.globl vector119
vector119:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $119
801076ec:	6a 77                	push   $0x77
  jmp alltraps
801076ee:	e9 20 f7 ff ff       	jmp    80106e13 <alltraps>

801076f3 <vector120>:
.globl vector120
vector120:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $120
801076f5:	6a 78                	push   $0x78
  jmp alltraps
801076f7:	e9 17 f7 ff ff       	jmp    80106e13 <alltraps>

801076fc <vector121>:
.globl vector121
vector121:
  pushl $0
801076fc:	6a 00                	push   $0x0
  pushl $121
801076fe:	6a 79                	push   $0x79
  jmp alltraps
80107700:	e9 0e f7 ff ff       	jmp    80106e13 <alltraps>

80107705 <vector122>:
.globl vector122
vector122:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $122
80107707:	6a 7a                	push   $0x7a
  jmp alltraps
80107709:	e9 05 f7 ff ff       	jmp    80106e13 <alltraps>

8010770e <vector123>:
.globl vector123
vector123:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $123
80107710:	6a 7b                	push   $0x7b
  jmp alltraps
80107712:	e9 fc f6 ff ff       	jmp    80106e13 <alltraps>

80107717 <vector124>:
.globl vector124
vector124:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $124
80107719:	6a 7c                	push   $0x7c
  jmp alltraps
8010771b:	e9 f3 f6 ff ff       	jmp    80106e13 <alltraps>

80107720 <vector125>:
.globl vector125
vector125:
  pushl $0
80107720:	6a 00                	push   $0x0
  pushl $125
80107722:	6a 7d                	push   $0x7d
  jmp alltraps
80107724:	e9 ea f6 ff ff       	jmp    80106e13 <alltraps>

80107729 <vector126>:
.globl vector126
vector126:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $126
8010772b:	6a 7e                	push   $0x7e
  jmp alltraps
8010772d:	e9 e1 f6 ff ff       	jmp    80106e13 <alltraps>

80107732 <vector127>:
.globl vector127
vector127:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $127
80107734:	6a 7f                	push   $0x7f
  jmp alltraps
80107736:	e9 d8 f6 ff ff       	jmp    80106e13 <alltraps>

8010773b <vector128>:
.globl vector128
vector128:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $128
8010773d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107742:	e9 cc f6 ff ff       	jmp    80106e13 <alltraps>

80107747 <vector129>:
.globl vector129
vector129:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $129
80107749:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010774e:	e9 c0 f6 ff ff       	jmp    80106e13 <alltraps>

80107753 <vector130>:
.globl vector130
vector130:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $130
80107755:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010775a:	e9 b4 f6 ff ff       	jmp    80106e13 <alltraps>

8010775f <vector131>:
.globl vector131
vector131:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $131
80107761:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107766:	e9 a8 f6 ff ff       	jmp    80106e13 <alltraps>

8010776b <vector132>:
.globl vector132
vector132:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $132
8010776d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107772:	e9 9c f6 ff ff       	jmp    80106e13 <alltraps>

80107777 <vector133>:
.globl vector133
vector133:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $133
80107779:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010777e:	e9 90 f6 ff ff       	jmp    80106e13 <alltraps>

80107783 <vector134>:
.globl vector134
vector134:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $134
80107785:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010778a:	e9 84 f6 ff ff       	jmp    80106e13 <alltraps>

8010778f <vector135>:
.globl vector135
vector135:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $135
80107791:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107796:	e9 78 f6 ff ff       	jmp    80106e13 <alltraps>

8010779b <vector136>:
.globl vector136
vector136:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $136
8010779d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801077a2:	e9 6c f6 ff ff       	jmp    80106e13 <alltraps>

801077a7 <vector137>:
.globl vector137
vector137:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $137
801077a9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801077ae:	e9 60 f6 ff ff       	jmp    80106e13 <alltraps>

801077b3 <vector138>:
.globl vector138
vector138:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $138
801077b5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801077ba:	e9 54 f6 ff ff       	jmp    80106e13 <alltraps>

801077bf <vector139>:
.globl vector139
vector139:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $139
801077c1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801077c6:	e9 48 f6 ff ff       	jmp    80106e13 <alltraps>

801077cb <vector140>:
.globl vector140
vector140:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $140
801077cd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801077d2:	e9 3c f6 ff ff       	jmp    80106e13 <alltraps>

801077d7 <vector141>:
.globl vector141
vector141:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $141
801077d9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801077de:	e9 30 f6 ff ff       	jmp    80106e13 <alltraps>

801077e3 <vector142>:
.globl vector142
vector142:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $142
801077e5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801077ea:	e9 24 f6 ff ff       	jmp    80106e13 <alltraps>

801077ef <vector143>:
.globl vector143
vector143:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $143
801077f1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801077f6:	e9 18 f6 ff ff       	jmp    80106e13 <alltraps>

801077fb <vector144>:
.globl vector144
vector144:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $144
801077fd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107802:	e9 0c f6 ff ff       	jmp    80106e13 <alltraps>

80107807 <vector145>:
.globl vector145
vector145:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $145
80107809:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010780e:	e9 00 f6 ff ff       	jmp    80106e13 <alltraps>

80107813 <vector146>:
.globl vector146
vector146:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $146
80107815:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010781a:	e9 f4 f5 ff ff       	jmp    80106e13 <alltraps>

8010781f <vector147>:
.globl vector147
vector147:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $147
80107821:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107826:	e9 e8 f5 ff ff       	jmp    80106e13 <alltraps>

8010782b <vector148>:
.globl vector148
vector148:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $148
8010782d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107832:	e9 dc f5 ff ff       	jmp    80106e13 <alltraps>

80107837 <vector149>:
.globl vector149
vector149:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $149
80107839:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010783e:	e9 d0 f5 ff ff       	jmp    80106e13 <alltraps>

80107843 <vector150>:
.globl vector150
vector150:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $150
80107845:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010784a:	e9 c4 f5 ff ff       	jmp    80106e13 <alltraps>

8010784f <vector151>:
.globl vector151
vector151:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $151
80107851:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107856:	e9 b8 f5 ff ff       	jmp    80106e13 <alltraps>

8010785b <vector152>:
.globl vector152
vector152:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $152
8010785d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107862:	e9 ac f5 ff ff       	jmp    80106e13 <alltraps>

80107867 <vector153>:
.globl vector153
vector153:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $153
80107869:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010786e:	e9 a0 f5 ff ff       	jmp    80106e13 <alltraps>

80107873 <vector154>:
.globl vector154
vector154:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $154
80107875:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010787a:	e9 94 f5 ff ff       	jmp    80106e13 <alltraps>

8010787f <vector155>:
.globl vector155
vector155:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $155
80107881:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107886:	e9 88 f5 ff ff       	jmp    80106e13 <alltraps>

8010788b <vector156>:
.globl vector156
vector156:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $156
8010788d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107892:	e9 7c f5 ff ff       	jmp    80106e13 <alltraps>

80107897 <vector157>:
.globl vector157
vector157:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $157
80107899:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010789e:	e9 70 f5 ff ff       	jmp    80106e13 <alltraps>

801078a3 <vector158>:
.globl vector158
vector158:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $158
801078a5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801078aa:	e9 64 f5 ff ff       	jmp    80106e13 <alltraps>

801078af <vector159>:
.globl vector159
vector159:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $159
801078b1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801078b6:	e9 58 f5 ff ff       	jmp    80106e13 <alltraps>

801078bb <vector160>:
.globl vector160
vector160:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $160
801078bd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801078c2:	e9 4c f5 ff ff       	jmp    80106e13 <alltraps>

801078c7 <vector161>:
.globl vector161
vector161:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $161
801078c9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801078ce:	e9 40 f5 ff ff       	jmp    80106e13 <alltraps>

801078d3 <vector162>:
.globl vector162
vector162:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $162
801078d5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801078da:	e9 34 f5 ff ff       	jmp    80106e13 <alltraps>

801078df <vector163>:
.globl vector163
vector163:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $163
801078e1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801078e6:	e9 28 f5 ff ff       	jmp    80106e13 <alltraps>

801078eb <vector164>:
.globl vector164
vector164:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $164
801078ed:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801078f2:	e9 1c f5 ff ff       	jmp    80106e13 <alltraps>

801078f7 <vector165>:
.globl vector165
vector165:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $165
801078f9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801078fe:	e9 10 f5 ff ff       	jmp    80106e13 <alltraps>

80107903 <vector166>:
.globl vector166
vector166:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $166
80107905:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010790a:	e9 04 f5 ff ff       	jmp    80106e13 <alltraps>

8010790f <vector167>:
.globl vector167
vector167:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $167
80107911:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107916:	e9 f8 f4 ff ff       	jmp    80106e13 <alltraps>

8010791b <vector168>:
.globl vector168
vector168:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $168
8010791d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107922:	e9 ec f4 ff ff       	jmp    80106e13 <alltraps>

80107927 <vector169>:
.globl vector169
vector169:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $169
80107929:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010792e:	e9 e0 f4 ff ff       	jmp    80106e13 <alltraps>

80107933 <vector170>:
.globl vector170
vector170:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $170
80107935:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010793a:	e9 d4 f4 ff ff       	jmp    80106e13 <alltraps>

8010793f <vector171>:
.globl vector171
vector171:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $171
80107941:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107946:	e9 c8 f4 ff ff       	jmp    80106e13 <alltraps>

8010794b <vector172>:
.globl vector172
vector172:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $172
8010794d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107952:	e9 bc f4 ff ff       	jmp    80106e13 <alltraps>

80107957 <vector173>:
.globl vector173
vector173:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $173
80107959:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010795e:	e9 b0 f4 ff ff       	jmp    80106e13 <alltraps>

80107963 <vector174>:
.globl vector174
vector174:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $174
80107965:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010796a:	e9 a4 f4 ff ff       	jmp    80106e13 <alltraps>

8010796f <vector175>:
.globl vector175
vector175:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $175
80107971:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107976:	e9 98 f4 ff ff       	jmp    80106e13 <alltraps>

8010797b <vector176>:
.globl vector176
vector176:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $176
8010797d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107982:	e9 8c f4 ff ff       	jmp    80106e13 <alltraps>

80107987 <vector177>:
.globl vector177
vector177:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $177
80107989:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010798e:	e9 80 f4 ff ff       	jmp    80106e13 <alltraps>

80107993 <vector178>:
.globl vector178
vector178:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $178
80107995:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010799a:	e9 74 f4 ff ff       	jmp    80106e13 <alltraps>

8010799f <vector179>:
.globl vector179
vector179:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $179
801079a1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801079a6:	e9 68 f4 ff ff       	jmp    80106e13 <alltraps>

801079ab <vector180>:
.globl vector180
vector180:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $180
801079ad:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801079b2:	e9 5c f4 ff ff       	jmp    80106e13 <alltraps>

801079b7 <vector181>:
.globl vector181
vector181:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $181
801079b9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801079be:	e9 50 f4 ff ff       	jmp    80106e13 <alltraps>

801079c3 <vector182>:
.globl vector182
vector182:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $182
801079c5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801079ca:	e9 44 f4 ff ff       	jmp    80106e13 <alltraps>

801079cf <vector183>:
.globl vector183
vector183:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $183
801079d1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801079d6:	e9 38 f4 ff ff       	jmp    80106e13 <alltraps>

801079db <vector184>:
.globl vector184
vector184:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $184
801079dd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801079e2:	e9 2c f4 ff ff       	jmp    80106e13 <alltraps>

801079e7 <vector185>:
.globl vector185
vector185:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $185
801079e9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801079ee:	e9 20 f4 ff ff       	jmp    80106e13 <alltraps>

801079f3 <vector186>:
.globl vector186
vector186:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $186
801079f5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801079fa:	e9 14 f4 ff ff       	jmp    80106e13 <alltraps>

801079ff <vector187>:
.globl vector187
vector187:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $187
80107a01:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107a06:	e9 08 f4 ff ff       	jmp    80106e13 <alltraps>

80107a0b <vector188>:
.globl vector188
vector188:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $188
80107a0d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107a12:	e9 fc f3 ff ff       	jmp    80106e13 <alltraps>

80107a17 <vector189>:
.globl vector189
vector189:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $189
80107a19:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107a1e:	e9 f0 f3 ff ff       	jmp    80106e13 <alltraps>

80107a23 <vector190>:
.globl vector190
vector190:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $190
80107a25:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107a2a:	e9 e4 f3 ff ff       	jmp    80106e13 <alltraps>

80107a2f <vector191>:
.globl vector191
vector191:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $191
80107a31:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107a36:	e9 d8 f3 ff ff       	jmp    80106e13 <alltraps>

80107a3b <vector192>:
.globl vector192
vector192:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $192
80107a3d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107a42:	e9 cc f3 ff ff       	jmp    80106e13 <alltraps>

80107a47 <vector193>:
.globl vector193
vector193:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $193
80107a49:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107a4e:	e9 c0 f3 ff ff       	jmp    80106e13 <alltraps>

80107a53 <vector194>:
.globl vector194
vector194:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $194
80107a55:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107a5a:	e9 b4 f3 ff ff       	jmp    80106e13 <alltraps>

80107a5f <vector195>:
.globl vector195
vector195:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $195
80107a61:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107a66:	e9 a8 f3 ff ff       	jmp    80106e13 <alltraps>

80107a6b <vector196>:
.globl vector196
vector196:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $196
80107a6d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107a72:	e9 9c f3 ff ff       	jmp    80106e13 <alltraps>

80107a77 <vector197>:
.globl vector197
vector197:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $197
80107a79:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107a7e:	e9 90 f3 ff ff       	jmp    80106e13 <alltraps>

80107a83 <vector198>:
.globl vector198
vector198:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $198
80107a85:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107a8a:	e9 84 f3 ff ff       	jmp    80106e13 <alltraps>

80107a8f <vector199>:
.globl vector199
vector199:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $199
80107a91:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107a96:	e9 78 f3 ff ff       	jmp    80106e13 <alltraps>

80107a9b <vector200>:
.globl vector200
vector200:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $200
80107a9d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107aa2:	e9 6c f3 ff ff       	jmp    80106e13 <alltraps>

80107aa7 <vector201>:
.globl vector201
vector201:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $201
80107aa9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107aae:	e9 60 f3 ff ff       	jmp    80106e13 <alltraps>

80107ab3 <vector202>:
.globl vector202
vector202:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $202
80107ab5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107aba:	e9 54 f3 ff ff       	jmp    80106e13 <alltraps>

80107abf <vector203>:
.globl vector203
vector203:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $203
80107ac1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107ac6:	e9 48 f3 ff ff       	jmp    80106e13 <alltraps>

80107acb <vector204>:
.globl vector204
vector204:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $204
80107acd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107ad2:	e9 3c f3 ff ff       	jmp    80106e13 <alltraps>

80107ad7 <vector205>:
.globl vector205
vector205:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $205
80107ad9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107ade:	e9 30 f3 ff ff       	jmp    80106e13 <alltraps>

80107ae3 <vector206>:
.globl vector206
vector206:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $206
80107ae5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107aea:	e9 24 f3 ff ff       	jmp    80106e13 <alltraps>

80107aef <vector207>:
.globl vector207
vector207:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $207
80107af1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107af6:	e9 18 f3 ff ff       	jmp    80106e13 <alltraps>

80107afb <vector208>:
.globl vector208
vector208:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $208
80107afd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107b02:	e9 0c f3 ff ff       	jmp    80106e13 <alltraps>

80107b07 <vector209>:
.globl vector209
vector209:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $209
80107b09:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107b0e:	e9 00 f3 ff ff       	jmp    80106e13 <alltraps>

80107b13 <vector210>:
.globl vector210
vector210:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $210
80107b15:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107b1a:	e9 f4 f2 ff ff       	jmp    80106e13 <alltraps>

80107b1f <vector211>:
.globl vector211
vector211:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $211
80107b21:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107b26:	e9 e8 f2 ff ff       	jmp    80106e13 <alltraps>

80107b2b <vector212>:
.globl vector212
vector212:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $212
80107b2d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107b32:	e9 dc f2 ff ff       	jmp    80106e13 <alltraps>

80107b37 <vector213>:
.globl vector213
vector213:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $213
80107b39:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107b3e:	e9 d0 f2 ff ff       	jmp    80106e13 <alltraps>

80107b43 <vector214>:
.globl vector214
vector214:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $214
80107b45:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107b4a:	e9 c4 f2 ff ff       	jmp    80106e13 <alltraps>

80107b4f <vector215>:
.globl vector215
vector215:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $215
80107b51:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107b56:	e9 b8 f2 ff ff       	jmp    80106e13 <alltraps>

80107b5b <vector216>:
.globl vector216
vector216:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $216
80107b5d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107b62:	e9 ac f2 ff ff       	jmp    80106e13 <alltraps>

80107b67 <vector217>:
.globl vector217
vector217:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $217
80107b69:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107b6e:	e9 a0 f2 ff ff       	jmp    80106e13 <alltraps>

80107b73 <vector218>:
.globl vector218
vector218:
  pushl $0
80107b73:	6a 00                	push   $0x0
  pushl $218
80107b75:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107b7a:	e9 94 f2 ff ff       	jmp    80106e13 <alltraps>

80107b7f <vector219>:
.globl vector219
vector219:
  pushl $0
80107b7f:	6a 00                	push   $0x0
  pushl $219
80107b81:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107b86:	e9 88 f2 ff ff       	jmp    80106e13 <alltraps>

80107b8b <vector220>:
.globl vector220
vector220:
  pushl $0
80107b8b:	6a 00                	push   $0x0
  pushl $220
80107b8d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107b92:	e9 7c f2 ff ff       	jmp    80106e13 <alltraps>

80107b97 <vector221>:
.globl vector221
vector221:
  pushl $0
80107b97:	6a 00                	push   $0x0
  pushl $221
80107b99:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107b9e:	e9 70 f2 ff ff       	jmp    80106e13 <alltraps>

80107ba3 <vector222>:
.globl vector222
vector222:
  pushl $0
80107ba3:	6a 00                	push   $0x0
  pushl $222
80107ba5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107baa:	e9 64 f2 ff ff       	jmp    80106e13 <alltraps>

80107baf <vector223>:
.globl vector223
vector223:
  pushl $0
80107baf:	6a 00                	push   $0x0
  pushl $223
80107bb1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107bb6:	e9 58 f2 ff ff       	jmp    80106e13 <alltraps>

80107bbb <vector224>:
.globl vector224
vector224:
  pushl $0
80107bbb:	6a 00                	push   $0x0
  pushl $224
80107bbd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107bc2:	e9 4c f2 ff ff       	jmp    80106e13 <alltraps>

80107bc7 <vector225>:
.globl vector225
vector225:
  pushl $0
80107bc7:	6a 00                	push   $0x0
  pushl $225
80107bc9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107bce:	e9 40 f2 ff ff       	jmp    80106e13 <alltraps>

80107bd3 <vector226>:
.globl vector226
vector226:
  pushl $0
80107bd3:	6a 00                	push   $0x0
  pushl $226
80107bd5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107bda:	e9 34 f2 ff ff       	jmp    80106e13 <alltraps>

80107bdf <vector227>:
.globl vector227
vector227:
  pushl $0
80107bdf:	6a 00                	push   $0x0
  pushl $227
80107be1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107be6:	e9 28 f2 ff ff       	jmp    80106e13 <alltraps>

80107beb <vector228>:
.globl vector228
vector228:
  pushl $0
80107beb:	6a 00                	push   $0x0
  pushl $228
80107bed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107bf2:	e9 1c f2 ff ff       	jmp    80106e13 <alltraps>

80107bf7 <vector229>:
.globl vector229
vector229:
  pushl $0
80107bf7:	6a 00                	push   $0x0
  pushl $229
80107bf9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107bfe:	e9 10 f2 ff ff       	jmp    80106e13 <alltraps>

80107c03 <vector230>:
.globl vector230
vector230:
  pushl $0
80107c03:	6a 00                	push   $0x0
  pushl $230
80107c05:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107c0a:	e9 04 f2 ff ff       	jmp    80106e13 <alltraps>

80107c0f <vector231>:
.globl vector231
vector231:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $231
80107c11:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107c16:	e9 f8 f1 ff ff       	jmp    80106e13 <alltraps>

80107c1b <vector232>:
.globl vector232
vector232:
  pushl $0
80107c1b:	6a 00                	push   $0x0
  pushl $232
80107c1d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107c22:	e9 ec f1 ff ff       	jmp    80106e13 <alltraps>

80107c27 <vector233>:
.globl vector233
vector233:
  pushl $0
80107c27:	6a 00                	push   $0x0
  pushl $233
80107c29:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107c2e:	e9 e0 f1 ff ff       	jmp    80106e13 <alltraps>

80107c33 <vector234>:
.globl vector234
vector234:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $234
80107c35:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107c3a:	e9 d4 f1 ff ff       	jmp    80106e13 <alltraps>

80107c3f <vector235>:
.globl vector235
vector235:
  pushl $0
80107c3f:	6a 00                	push   $0x0
  pushl $235
80107c41:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107c46:	e9 c8 f1 ff ff       	jmp    80106e13 <alltraps>

80107c4b <vector236>:
.globl vector236
vector236:
  pushl $0
80107c4b:	6a 00                	push   $0x0
  pushl $236
80107c4d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107c52:	e9 bc f1 ff ff       	jmp    80106e13 <alltraps>

80107c57 <vector237>:
.globl vector237
vector237:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $237
80107c59:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107c5e:	e9 b0 f1 ff ff       	jmp    80106e13 <alltraps>

80107c63 <vector238>:
.globl vector238
vector238:
  pushl $0
80107c63:	6a 00                	push   $0x0
  pushl $238
80107c65:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107c6a:	e9 a4 f1 ff ff       	jmp    80106e13 <alltraps>

80107c6f <vector239>:
.globl vector239
vector239:
  pushl $0
80107c6f:	6a 00                	push   $0x0
  pushl $239
80107c71:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107c76:	e9 98 f1 ff ff       	jmp    80106e13 <alltraps>

80107c7b <vector240>:
.globl vector240
vector240:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $240
80107c7d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107c82:	e9 8c f1 ff ff       	jmp    80106e13 <alltraps>

80107c87 <vector241>:
.globl vector241
vector241:
  pushl $0
80107c87:	6a 00                	push   $0x0
  pushl $241
80107c89:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107c8e:	e9 80 f1 ff ff       	jmp    80106e13 <alltraps>

80107c93 <vector242>:
.globl vector242
vector242:
  pushl $0
80107c93:	6a 00                	push   $0x0
  pushl $242
80107c95:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107c9a:	e9 74 f1 ff ff       	jmp    80106e13 <alltraps>

80107c9f <vector243>:
.globl vector243
vector243:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $243
80107ca1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ca6:	e9 68 f1 ff ff       	jmp    80106e13 <alltraps>

80107cab <vector244>:
.globl vector244
vector244:
  pushl $0
80107cab:	6a 00                	push   $0x0
  pushl $244
80107cad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107cb2:	e9 5c f1 ff ff       	jmp    80106e13 <alltraps>

80107cb7 <vector245>:
.globl vector245
vector245:
  pushl $0
80107cb7:	6a 00                	push   $0x0
  pushl $245
80107cb9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107cbe:	e9 50 f1 ff ff       	jmp    80106e13 <alltraps>

80107cc3 <vector246>:
.globl vector246
vector246:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $246
80107cc5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107cca:	e9 44 f1 ff ff       	jmp    80106e13 <alltraps>

80107ccf <vector247>:
.globl vector247
vector247:
  pushl $0
80107ccf:	6a 00                	push   $0x0
  pushl $247
80107cd1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107cd6:	e9 38 f1 ff ff       	jmp    80106e13 <alltraps>

80107cdb <vector248>:
.globl vector248
vector248:
  pushl $0
80107cdb:	6a 00                	push   $0x0
  pushl $248
80107cdd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107ce2:	e9 2c f1 ff ff       	jmp    80106e13 <alltraps>

80107ce7 <vector249>:
.globl vector249
vector249:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $249
80107ce9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107cee:	e9 20 f1 ff ff       	jmp    80106e13 <alltraps>

80107cf3 <vector250>:
.globl vector250
vector250:
  pushl $0
80107cf3:	6a 00                	push   $0x0
  pushl $250
80107cf5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107cfa:	e9 14 f1 ff ff       	jmp    80106e13 <alltraps>

80107cff <vector251>:
.globl vector251
vector251:
  pushl $0
80107cff:	6a 00                	push   $0x0
  pushl $251
80107d01:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107d06:	e9 08 f1 ff ff       	jmp    80106e13 <alltraps>

80107d0b <vector252>:
.globl vector252
vector252:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $252
80107d0d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107d12:	e9 fc f0 ff ff       	jmp    80106e13 <alltraps>

80107d17 <vector253>:
.globl vector253
vector253:
  pushl $0
80107d17:	6a 00                	push   $0x0
  pushl $253
80107d19:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107d1e:	e9 f0 f0 ff ff       	jmp    80106e13 <alltraps>

80107d23 <vector254>:
.globl vector254
vector254:
  pushl $0
80107d23:	6a 00                	push   $0x0
  pushl $254
80107d25:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107d2a:	e9 e4 f0 ff ff       	jmp    80106e13 <alltraps>

80107d2f <vector255>:
.globl vector255
vector255:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $255
80107d31:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107d36:	e9 d8 f0 ff ff       	jmp    80106e13 <alltraps>
80107d3b:	66 90                	xchg   %ax,%ax
80107d3d:	66 90                	xchg   %ax,%ax
80107d3f:	90                   	nop

80107d40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107d47:	c1 ea 16             	shr    $0x16,%edx
{
80107d4a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80107d4b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80107d4e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107d51:	8b 1f                	mov    (%edi),%ebx
80107d53:	f6 c3 01             	test   $0x1,%bl
80107d56:	74 28                	je     80107d80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107d5e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107d64:	89 f0                	mov    %esi,%eax
}
80107d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107d69:	c1 e8 0a             	shr    $0xa,%eax
80107d6c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d71:	01 d8                	add    %ebx,%eax
}
80107d73:	5b                   	pop    %ebx
80107d74:	5e                   	pop    %esi
80107d75:	5f                   	pop    %edi
80107d76:	5d                   	pop    %ebp
80107d77:	c3                   	ret    
80107d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d7f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107d80:	85 c9                	test   %ecx,%ecx
80107d82:	74 2c                	je     80107db0 <walkpgdir+0x70>
80107d84:	e8 47 af ff ff       	call   80102cd0 <kalloc>
80107d89:	89 c3                	mov    %eax,%ebx
80107d8b:	85 c0                	test   %eax,%eax
80107d8d:	74 21                	je     80107db0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107d8f:	83 ec 04             	sub    $0x4,%esp
80107d92:	68 00 10 00 00       	push   $0x1000
80107d97:	6a 00                	push   $0x0
80107d99:	50                   	push   %eax
80107d9a:	e8 71 db ff ff       	call   80105910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107d9f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107da5:	83 c4 10             	add    $0x10,%esp
80107da8:	83 c8 07             	or     $0x7,%eax
80107dab:	89 07                	mov    %eax,(%edi)
80107dad:	eb b5                	jmp    80107d64 <walkpgdir+0x24>
80107daf:	90                   	nop
}
80107db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107db3:	31 c0                	xor    %eax,%eax
}
80107db5:	5b                   	pop    %ebx
80107db6:	5e                   	pop    %esi
80107db7:	5f                   	pop    %edi
80107db8:	5d                   	pop    %ebp
80107db9:	c3                   	ret    
80107dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107dc0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dc6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80107dca:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107dcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107dd0:	89 d6                	mov    %edx,%esi
{
80107dd2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107dd3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107dd9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ddc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80107de2:	29 f0                	sub    %esi,%eax
80107de4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107de7:	eb 1f                	jmp    80107e08 <mappages+0x48>
80107de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107df0:	f6 00 01             	testb  $0x1,(%eax)
80107df3:	75 45                	jne    80107e3a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107df5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107df8:	83 cb 01             	or     $0x1,%ebx
80107dfb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80107dfd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107e00:	74 2e                	je     80107e30 <mappages+0x70>
      break;
    a += PGSIZE;
80107e02:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107e0b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107e10:	89 f2                	mov    %esi,%edx
80107e12:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107e15:	89 f8                	mov    %edi,%eax
80107e17:	e8 24 ff ff ff       	call   80107d40 <walkpgdir>
80107e1c:	85 c0                	test   %eax,%eax
80107e1e:	75 d0                	jne    80107df0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e28:	5b                   	pop    %ebx
80107e29:	5e                   	pop    %esi
80107e2a:	5f                   	pop    %edi
80107e2b:	5d                   	pop    %ebp
80107e2c:	c3                   	ret    
80107e2d:	8d 76 00             	lea    0x0(%esi),%esi
80107e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e33:	31 c0                	xor    %eax,%eax
}
80107e35:	5b                   	pop    %ebx
80107e36:	5e                   	pop    %esi
80107e37:	5f                   	pop    %edi
80107e38:	5d                   	pop    %ebp
80107e39:	c3                   	ret    
      panic("remap");
80107e3a:	83 ec 0c             	sub    $0xc,%esp
80107e3d:	68 d4 90 10 80       	push   $0x801090d4
80107e42:	e8 49 85 ff ff       	call   80100390 <panic>
80107e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e4e:	66 90                	xchg   %ax,%ax

80107e50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	89 c6                	mov    %eax,%esi
80107e57:	53                   	push   %ebx
80107e58:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107e5a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107e60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107e66:	83 ec 1c             	sub    $0x1c,%esp
80107e69:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e6c:	39 da                	cmp    %ebx,%edx
80107e6e:	73 5b                	jae    80107ecb <deallocuvm.part.0+0x7b>
80107e70:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107e73:	89 d7                	mov    %edx,%edi
80107e75:	eb 14                	jmp    80107e8b <deallocuvm.part.0+0x3b>
80107e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e7e:	66 90                	xchg   %ax,%ax
80107e80:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107e86:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107e89:	76 40                	jbe    80107ecb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e8b:	31 c9                	xor    %ecx,%ecx
80107e8d:	89 fa                	mov    %edi,%edx
80107e8f:	89 f0                	mov    %esi,%eax
80107e91:	e8 aa fe ff ff       	call   80107d40 <walkpgdir>
80107e96:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107e98:	85 c0                	test   %eax,%eax
80107e9a:	74 44                	je     80107ee0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107e9c:	8b 00                	mov    (%eax),%eax
80107e9e:	a8 01                	test   $0x1,%al
80107ea0:	74 de                	je     80107e80 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107ea2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ea7:	74 47                	je     80107ef0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107ea9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107eac:	05 00 00 00 80       	add    $0x80000000,%eax
80107eb1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107eb7:	50                   	push   %eax
80107eb8:	e8 53 ac ff ff       	call   80102b10 <kfree>
      *pte = 0;
80107ebd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107ec3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107ec6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107ec9:	77 c0                	ja     80107e8b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80107ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ed1:	5b                   	pop    %ebx
80107ed2:	5e                   	pop    %esi
80107ed3:	5f                   	pop    %edi
80107ed4:	5d                   	pop    %ebp
80107ed5:	c3                   	ret    
80107ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107edd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107ee0:	89 fa                	mov    %edi,%edx
80107ee2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107ee8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80107eee:	eb 96                	jmp    80107e86 <deallocuvm.part.0+0x36>
        panic("kfree");
80107ef0:	83 ec 0c             	sub    $0xc,%esp
80107ef3:	68 e6 88 10 80       	push   $0x801088e6
80107ef8:	e8 93 84 ff ff       	call   80100390 <panic>
80107efd:	8d 76 00             	lea    0x0(%esi),%esi

80107f00 <seginit>:
{
80107f00:	f3 0f 1e fb          	endbr32 
80107f04:	55                   	push   %ebp
80107f05:	89 e5                	mov    %esp,%ebp
80107f07:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107f0a:	e8 f1 c1 ff ff       	call   80104100 <cpuid>
  pd[0] = size-1;
80107f0f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107f14:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107f1a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f1e:	c7 80 d8 4e 11 80 ff 	movl   $0xffff,-0x7feeb128(%eax)
80107f25:	ff 00 00 
80107f28:	c7 80 dc 4e 11 80 00 	movl   $0xcf9a00,-0x7feeb124(%eax)
80107f2f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f32:	c7 80 e0 4e 11 80 ff 	movl   $0xffff,-0x7feeb120(%eax)
80107f39:	ff 00 00 
80107f3c:	c7 80 e4 4e 11 80 00 	movl   $0xcf9200,-0x7feeb11c(%eax)
80107f43:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107f46:	c7 80 e8 4e 11 80 ff 	movl   $0xffff,-0x7feeb118(%eax)
80107f4d:	ff 00 00 
80107f50:	c7 80 ec 4e 11 80 00 	movl   $0xcffa00,-0x7feeb114(%eax)
80107f57:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107f5a:	c7 80 f0 4e 11 80 ff 	movl   $0xffff,-0x7feeb110(%eax)
80107f61:	ff 00 00 
80107f64:	c7 80 f4 4e 11 80 00 	movl   $0xcff200,-0x7feeb10c(%eax)
80107f6b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107f6e:	05 d0 4e 11 80       	add    $0x80114ed0,%eax
  pd[1] = (uint)p;
80107f73:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107f77:	c1 e8 10             	shr    $0x10,%eax
80107f7a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107f7e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107f81:	0f 01 10             	lgdtl  (%eax)
}
80107f84:	c9                   	leave  
80107f85:	c3                   	ret    
80107f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f8d:	8d 76 00             	lea    0x0(%esi),%esi

80107f90 <switchkvm>:
{
80107f90:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f94:	a1 04 ae 11 80       	mov    0x8011ae04,%eax
80107f99:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f9e:	0f 22 d8             	mov    %eax,%cr3
}
80107fa1:	c3                   	ret    
80107fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fb0 <switchuvm>:
{
80107fb0:	f3 0f 1e fb          	endbr32 
80107fb4:	55                   	push   %ebp
80107fb5:	89 e5                	mov    %esp,%ebp
80107fb7:	57                   	push   %edi
80107fb8:	56                   	push   %esi
80107fb9:	53                   	push   %ebx
80107fba:	83 ec 1c             	sub    $0x1c,%esp
80107fbd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107fc0:	85 f6                	test   %esi,%esi
80107fc2:	0f 84 cb 00 00 00    	je     80108093 <switchuvm+0xe3>
  if(p->kstack == 0)
80107fc8:	8b 46 08             	mov    0x8(%esi),%eax
80107fcb:	85 c0                	test   %eax,%eax
80107fcd:	0f 84 da 00 00 00    	je     801080ad <switchuvm+0xfd>
  if(p->pgdir == 0)
80107fd3:	8b 46 04             	mov    0x4(%esi),%eax
80107fd6:	85 c0                	test   %eax,%eax
80107fd8:	0f 84 c2 00 00 00    	je     801080a0 <switchuvm+0xf0>
  pushcli();
80107fde:	e8 dd d6 ff ff       	call   801056c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107fe3:	e8 a8 c0 ff ff       	call   80104090 <mycpu>
80107fe8:	89 c3                	mov    %eax,%ebx
80107fea:	e8 a1 c0 ff ff       	call   80104090 <mycpu>
80107fef:	89 c7                	mov    %eax,%edi
80107ff1:	e8 9a c0 ff ff       	call   80104090 <mycpu>
80107ff6:	83 c7 08             	add    $0x8,%edi
80107ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ffc:	e8 8f c0 ff ff       	call   80104090 <mycpu>
80108001:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108004:	ba 67 00 00 00       	mov    $0x67,%edx
80108009:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108010:	83 c0 08             	add    $0x8,%eax
80108013:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010801a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010801f:	83 c1 08             	add    $0x8,%ecx
80108022:	c1 e8 18             	shr    $0x18,%eax
80108025:	c1 e9 10             	shr    $0x10,%ecx
80108028:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010802e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108034:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108039:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108040:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108045:	e8 46 c0 ff ff       	call   80104090 <mycpu>
8010804a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108051:	e8 3a c0 ff ff       	call   80104090 <mycpu>
80108056:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010805a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010805d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108063:	e8 28 c0 ff ff       	call   80104090 <mycpu>
80108068:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010806b:	e8 20 c0 ff ff       	call   80104090 <mycpu>
80108070:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108074:	b8 28 00 00 00       	mov    $0x28,%eax
80108079:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010807c:	8b 46 04             	mov    0x4(%esi),%eax
8010807f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108084:	0f 22 d8             	mov    %eax,%cr3
}
80108087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010808a:	5b                   	pop    %ebx
8010808b:	5e                   	pop    %esi
8010808c:	5f                   	pop    %edi
8010808d:	5d                   	pop    %ebp
  popcli();
8010808e:	e9 7d d6 ff ff       	jmp    80105710 <popcli>
    panic("switchuvm: no process");
80108093:	83 ec 0c             	sub    $0xc,%esp
80108096:	68 da 90 10 80       	push   $0x801090da
8010809b:	e8 f0 82 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801080a0:	83 ec 0c             	sub    $0xc,%esp
801080a3:	68 05 91 10 80       	push   $0x80109105
801080a8:	e8 e3 82 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801080ad:	83 ec 0c             	sub    $0xc,%esp
801080b0:	68 f0 90 10 80       	push   $0x801090f0
801080b5:	e8 d6 82 ff ff       	call   80100390 <panic>
801080ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801080c0 <inituvm>:
{
801080c0:	f3 0f 1e fb          	endbr32 
801080c4:	55                   	push   %ebp
801080c5:	89 e5                	mov    %esp,%ebp
801080c7:	57                   	push   %edi
801080c8:	56                   	push   %esi
801080c9:	53                   	push   %ebx
801080ca:	83 ec 1c             	sub    $0x1c,%esp
801080cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d0:	8b 75 10             	mov    0x10(%ebp),%esi
801080d3:	8b 7d 08             	mov    0x8(%ebp),%edi
801080d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801080d9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801080df:	77 4b                	ja     8010812c <inituvm+0x6c>
  mem = kalloc();
801080e1:	e8 ea ab ff ff       	call   80102cd0 <kalloc>
  memset(mem, 0, PGSIZE);
801080e6:	83 ec 04             	sub    $0x4,%esp
801080e9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801080ee:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801080f0:	6a 00                	push   $0x0
801080f2:	50                   	push   %eax
801080f3:	e8 18 d8 ff ff       	call   80105910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801080f8:	58                   	pop    %eax
801080f9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801080ff:	5a                   	pop    %edx
80108100:	6a 06                	push   $0x6
80108102:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108107:	31 d2                	xor    %edx,%edx
80108109:	50                   	push   %eax
8010810a:	89 f8                	mov    %edi,%eax
8010810c:	e8 af fc ff ff       	call   80107dc0 <mappages>
  memmove(mem, init, sz);
80108111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108114:	89 75 10             	mov    %esi,0x10(%ebp)
80108117:	83 c4 10             	add    $0x10,%esp
8010811a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010811d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108123:	5b                   	pop    %ebx
80108124:	5e                   	pop    %esi
80108125:	5f                   	pop    %edi
80108126:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108127:	e9 84 d8 ff ff       	jmp    801059b0 <memmove>
    panic("inituvm: more than a page");
8010812c:	83 ec 0c             	sub    $0xc,%esp
8010812f:	68 19 91 10 80       	push   $0x80109119
80108134:	e8 57 82 ff ff       	call   80100390 <panic>
80108139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108140 <loaduvm>:
{
80108140:	f3 0f 1e fb          	endbr32 
80108144:	55                   	push   %ebp
80108145:	89 e5                	mov    %esp,%ebp
80108147:	57                   	push   %edi
80108148:	56                   	push   %esi
80108149:	53                   	push   %ebx
8010814a:	83 ec 1c             	sub    $0x1c,%esp
8010814d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108150:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80108153:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108158:	0f 85 99 00 00 00    	jne    801081f7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010815e:	01 f0                	add    %esi,%eax
80108160:	89 f3                	mov    %esi,%ebx
80108162:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108165:	8b 45 14             	mov    0x14(%ebp),%eax
80108168:	01 f0                	add    %esi,%eax
8010816a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010816d:	85 f6                	test   %esi,%esi
8010816f:	75 15                	jne    80108186 <loaduvm+0x46>
80108171:	eb 6d                	jmp    801081e0 <loaduvm+0xa0>
80108173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108177:	90                   	nop
80108178:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010817e:	89 f0                	mov    %esi,%eax
80108180:	29 d8                	sub    %ebx,%eax
80108182:	39 c6                	cmp    %eax,%esi
80108184:	76 5a                	jbe    801081e0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108186:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108189:	8b 45 08             	mov    0x8(%ebp),%eax
8010818c:	31 c9                	xor    %ecx,%ecx
8010818e:	29 da                	sub    %ebx,%edx
80108190:	e8 ab fb ff ff       	call   80107d40 <walkpgdir>
80108195:	85 c0                	test   %eax,%eax
80108197:	74 51                	je     801081ea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80108199:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010819b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010819e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801081a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801081a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801081ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801081b1:	29 d9                	sub    %ebx,%ecx
801081b3:	05 00 00 00 80       	add    $0x80000000,%eax
801081b8:	57                   	push   %edi
801081b9:	51                   	push   %ecx
801081ba:	50                   	push   %eax
801081bb:	ff 75 10             	pushl  0x10(%ebp)
801081be:	e8 3d 9f ff ff       	call   80102100 <readi>
801081c3:	83 c4 10             	add    $0x10,%esp
801081c6:	39 f8                	cmp    %edi,%eax
801081c8:	74 ae                	je     80108178 <loaduvm+0x38>
}
801081ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081d2:	5b                   	pop    %ebx
801081d3:	5e                   	pop    %esi
801081d4:	5f                   	pop    %edi
801081d5:	5d                   	pop    %ebp
801081d6:	c3                   	ret    
801081d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081de:	66 90                	xchg   %ax,%ax
801081e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801081e3:	31 c0                	xor    %eax,%eax
}
801081e5:	5b                   	pop    %ebx
801081e6:	5e                   	pop    %esi
801081e7:	5f                   	pop    %edi
801081e8:	5d                   	pop    %ebp
801081e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801081ea:	83 ec 0c             	sub    $0xc,%esp
801081ed:	68 33 91 10 80       	push   $0x80109133
801081f2:	e8 99 81 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801081f7:	83 ec 0c             	sub    $0xc,%esp
801081fa:	68 d4 91 10 80       	push   $0x801091d4
801081ff:	e8 8c 81 ff ff       	call   80100390 <panic>
80108204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010820b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010820f:	90                   	nop

80108210 <allocuvm>:
{
80108210:	f3 0f 1e fb          	endbr32 
80108214:	55                   	push   %ebp
80108215:	89 e5                	mov    %esp,%ebp
80108217:	57                   	push   %edi
80108218:	56                   	push   %esi
80108219:	53                   	push   %ebx
8010821a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010821d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80108220:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80108223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108226:	85 c0                	test   %eax,%eax
80108228:	0f 88 b2 00 00 00    	js     801082e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010822e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108231:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108234:	0f 82 96 00 00 00    	jb     801082d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010823a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108240:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108246:	39 75 10             	cmp    %esi,0x10(%ebp)
80108249:	77 40                	ja     8010828b <allocuvm+0x7b>
8010824b:	e9 83 00 00 00       	jmp    801082d3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80108250:	83 ec 04             	sub    $0x4,%esp
80108253:	68 00 10 00 00       	push   $0x1000
80108258:	6a 00                	push   $0x0
8010825a:	50                   	push   %eax
8010825b:	e8 b0 d6 ff ff       	call   80105910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108260:	58                   	pop    %eax
80108261:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108267:	5a                   	pop    %edx
80108268:	6a 06                	push   $0x6
8010826a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010826f:	89 f2                	mov    %esi,%edx
80108271:	50                   	push   %eax
80108272:	89 f8                	mov    %edi,%eax
80108274:	e8 47 fb ff ff       	call   80107dc0 <mappages>
80108279:	83 c4 10             	add    $0x10,%esp
8010827c:	85 c0                	test   %eax,%eax
8010827e:	78 78                	js     801082f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108280:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108286:	39 75 10             	cmp    %esi,0x10(%ebp)
80108289:	76 48                	jbe    801082d3 <allocuvm+0xc3>
    mem = kalloc();
8010828b:	e8 40 aa ff ff       	call   80102cd0 <kalloc>
80108290:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108292:	85 c0                	test   %eax,%eax
80108294:	75 ba                	jne    80108250 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108296:	83 ec 0c             	sub    $0xc,%esp
80108299:	68 51 91 10 80       	push   $0x80109151
8010829e:	e8 fd 84 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801082a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801082a6:	83 c4 10             	add    $0x10,%esp
801082a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801082ac:	74 32                	je     801082e0 <allocuvm+0xd0>
801082ae:	8b 55 10             	mov    0x10(%ebp),%edx
801082b1:	89 c1                	mov    %eax,%ecx
801082b3:	89 f8                	mov    %edi,%eax
801082b5:	e8 96 fb ff ff       	call   80107e50 <deallocuvm.part.0>
      return 0;
801082ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801082c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c7:	5b                   	pop    %ebx
801082c8:	5e                   	pop    %esi
801082c9:	5f                   	pop    %edi
801082ca:	5d                   	pop    %ebp
801082cb:	c3                   	ret    
801082cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801082d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801082d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082d9:	5b                   	pop    %ebx
801082da:	5e                   	pop    %esi
801082db:	5f                   	pop    %edi
801082dc:	5d                   	pop    %ebp
801082dd:	c3                   	ret    
801082de:	66 90                	xchg   %ax,%ax
    return 0;
801082e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801082e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082ed:	5b                   	pop    %ebx
801082ee:	5e                   	pop    %esi
801082ef:	5f                   	pop    %edi
801082f0:	5d                   	pop    %ebp
801082f1:	c3                   	ret    
801082f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801082f8:	83 ec 0c             	sub    $0xc,%esp
801082fb:	68 69 91 10 80       	push   $0x80109169
80108300:	e8 9b 84 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80108305:	8b 45 0c             	mov    0xc(%ebp),%eax
80108308:	83 c4 10             	add    $0x10,%esp
8010830b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010830e:	74 0c                	je     8010831c <allocuvm+0x10c>
80108310:	8b 55 10             	mov    0x10(%ebp),%edx
80108313:	89 c1                	mov    %eax,%ecx
80108315:	89 f8                	mov    %edi,%eax
80108317:	e8 34 fb ff ff       	call   80107e50 <deallocuvm.part.0>
      kfree(mem);
8010831c:	83 ec 0c             	sub    $0xc,%esp
8010831f:	53                   	push   %ebx
80108320:	e8 eb a7 ff ff       	call   80102b10 <kfree>
      return 0;
80108325:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010832c:	83 c4 10             	add    $0x10,%esp
}
8010832f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108335:	5b                   	pop    %ebx
80108336:	5e                   	pop    %esi
80108337:	5f                   	pop    %edi
80108338:	5d                   	pop    %ebp
80108339:	c3                   	ret    
8010833a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108340 <deallocuvm>:
{
80108340:	f3 0f 1e fb          	endbr32 
80108344:	55                   	push   %ebp
80108345:	89 e5                	mov    %esp,%ebp
80108347:	8b 55 0c             	mov    0xc(%ebp),%edx
8010834a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010834d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108350:	39 d1                	cmp    %edx,%ecx
80108352:	73 0c                	jae    80108360 <deallocuvm+0x20>
}
80108354:	5d                   	pop    %ebp
80108355:	e9 f6 fa ff ff       	jmp    80107e50 <deallocuvm.part.0>
8010835a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108360:	89 d0                	mov    %edx,%eax
80108362:	5d                   	pop    %ebp
80108363:	c3                   	ret    
80108364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010836b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010836f:	90                   	nop

80108370 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108370:	f3 0f 1e fb          	endbr32 
80108374:	55                   	push   %ebp
80108375:	89 e5                	mov    %esp,%ebp
80108377:	57                   	push   %edi
80108378:	56                   	push   %esi
80108379:	53                   	push   %ebx
8010837a:	83 ec 0c             	sub    $0xc,%esp
8010837d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108380:	85 f6                	test   %esi,%esi
80108382:	74 55                	je     801083d9 <freevm+0x69>
  if(newsz >= oldsz)
80108384:	31 c9                	xor    %ecx,%ecx
80108386:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010838b:	89 f0                	mov    %esi,%eax
8010838d:	89 f3                	mov    %esi,%ebx
8010838f:	e8 bc fa ff ff       	call   80107e50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108394:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010839a:	eb 0b                	jmp    801083a7 <freevm+0x37>
8010839c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083a0:	83 c3 04             	add    $0x4,%ebx
801083a3:	39 df                	cmp    %ebx,%edi
801083a5:	74 23                	je     801083ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801083a7:	8b 03                	mov    (%ebx),%eax
801083a9:	a8 01                	test   $0x1,%al
801083ab:	74 f3                	je     801083a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801083ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801083b2:	83 ec 0c             	sub    $0xc,%esp
801083b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801083b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801083bd:	50                   	push   %eax
801083be:	e8 4d a7 ff ff       	call   80102b10 <kfree>
801083c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801083c6:	39 df                	cmp    %ebx,%edi
801083c8:	75 dd                	jne    801083a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801083ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801083cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083d0:	5b                   	pop    %ebx
801083d1:	5e                   	pop    %esi
801083d2:	5f                   	pop    %edi
801083d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801083d4:	e9 37 a7 ff ff       	jmp    80102b10 <kfree>
    panic("freevm: no pgdir");
801083d9:	83 ec 0c             	sub    $0xc,%esp
801083dc:	68 85 91 10 80       	push   $0x80109185
801083e1:	e8 aa 7f ff ff       	call   80100390 <panic>
801083e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083ed:	8d 76 00             	lea    0x0(%esi),%esi

801083f0 <setupkvm>:
{
801083f0:	f3 0f 1e fb          	endbr32 
801083f4:	55                   	push   %ebp
801083f5:	89 e5                	mov    %esp,%ebp
801083f7:	56                   	push   %esi
801083f8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801083f9:	e8 d2 a8 ff ff       	call   80102cd0 <kalloc>
801083fe:	89 c6                	mov    %eax,%esi
80108400:	85 c0                	test   %eax,%eax
80108402:	74 42                	je     80108446 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108404:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108407:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
8010840c:	68 00 10 00 00       	push   $0x1000
80108411:	6a 00                	push   $0x0
80108413:	50                   	push   %eax
80108414:	e8 f7 d4 ff ff       	call   80105910 <memset>
80108419:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010841c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010841f:	83 ec 08             	sub    $0x8,%esp
80108422:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108425:	ff 73 0c             	pushl  0xc(%ebx)
80108428:	8b 13                	mov    (%ebx),%edx
8010842a:	50                   	push   %eax
8010842b:	29 c1                	sub    %eax,%ecx
8010842d:	89 f0                	mov    %esi,%eax
8010842f:	e8 8c f9 ff ff       	call   80107dc0 <mappages>
80108434:	83 c4 10             	add    $0x10,%esp
80108437:	85 c0                	test   %eax,%eax
80108439:	78 15                	js     80108450 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010843b:	83 c3 10             	add    $0x10,%ebx
8010843e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108444:	75 d6                	jne    8010841c <setupkvm+0x2c>
}
80108446:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108449:	89 f0                	mov    %esi,%eax
8010844b:	5b                   	pop    %ebx
8010844c:	5e                   	pop    %esi
8010844d:	5d                   	pop    %ebp
8010844e:	c3                   	ret    
8010844f:	90                   	nop
      freevm(pgdir);
80108450:	83 ec 0c             	sub    $0xc,%esp
80108453:	56                   	push   %esi
      return 0;
80108454:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108456:	e8 15 ff ff ff       	call   80108370 <freevm>
      return 0;
8010845b:	83 c4 10             	add    $0x10,%esp
}
8010845e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108461:	89 f0                	mov    %esi,%eax
80108463:	5b                   	pop    %ebx
80108464:	5e                   	pop    %esi
80108465:	5d                   	pop    %ebp
80108466:	c3                   	ret    
80108467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010846e:	66 90                	xchg   %ax,%ax

80108470 <kvmalloc>:
{
80108470:	f3 0f 1e fb          	endbr32 
80108474:	55                   	push   %ebp
80108475:	89 e5                	mov    %esp,%ebp
80108477:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010847a:	e8 71 ff ff ff       	call   801083f0 <setupkvm>
8010847f:	a3 04 ae 11 80       	mov    %eax,0x8011ae04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108484:	05 00 00 00 80       	add    $0x80000000,%eax
80108489:	0f 22 d8             	mov    %eax,%cr3
}
8010848c:	c9                   	leave  
8010848d:	c3                   	ret    
8010848e:	66 90                	xchg   %ax,%ax

80108490 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108490:	f3 0f 1e fb          	endbr32 
80108494:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108495:	31 c9                	xor    %ecx,%ecx
{
80108497:	89 e5                	mov    %esp,%ebp
80108499:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010849c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010849f:	8b 45 08             	mov    0x8(%ebp),%eax
801084a2:	e8 99 f8 ff ff       	call   80107d40 <walkpgdir>
  if(pte == 0)
801084a7:	85 c0                	test   %eax,%eax
801084a9:	74 05                	je     801084b0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801084ab:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801084ae:	c9                   	leave  
801084af:	c3                   	ret    
    panic("clearpteu");
801084b0:	83 ec 0c             	sub    $0xc,%esp
801084b3:	68 96 91 10 80       	push   $0x80109196
801084b8:	e8 d3 7e ff ff       	call   80100390 <panic>
801084bd:	8d 76 00             	lea    0x0(%esi),%esi

801084c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801084c0:	f3 0f 1e fb          	endbr32 
801084c4:	55                   	push   %ebp
801084c5:	89 e5                	mov    %esp,%ebp
801084c7:	57                   	push   %edi
801084c8:	56                   	push   %esi
801084c9:	53                   	push   %ebx
801084ca:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801084cd:	e8 1e ff ff ff       	call   801083f0 <setupkvm>
801084d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801084d5:	85 c0                	test   %eax,%eax
801084d7:	0f 84 9b 00 00 00    	je     80108578 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801084dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801084e0:	85 c9                	test   %ecx,%ecx
801084e2:	0f 84 90 00 00 00    	je     80108578 <copyuvm+0xb8>
801084e8:	31 f6                	xor    %esi,%esi
801084ea:	eb 46                	jmp    80108532 <copyuvm+0x72>
801084ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801084f0:	83 ec 04             	sub    $0x4,%esp
801084f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801084f9:	68 00 10 00 00       	push   $0x1000
801084fe:	57                   	push   %edi
801084ff:	50                   	push   %eax
80108500:	e8 ab d4 ff ff       	call   801059b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108505:	58                   	pop    %eax
80108506:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010850c:	5a                   	pop    %edx
8010850d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108510:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108515:	89 f2                	mov    %esi,%edx
80108517:	50                   	push   %eax
80108518:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010851b:	e8 a0 f8 ff ff       	call   80107dc0 <mappages>
80108520:	83 c4 10             	add    $0x10,%esp
80108523:	85 c0                	test   %eax,%eax
80108525:	78 61                	js     80108588 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108527:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010852d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108530:	76 46                	jbe    80108578 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108532:	8b 45 08             	mov    0x8(%ebp),%eax
80108535:	31 c9                	xor    %ecx,%ecx
80108537:	89 f2                	mov    %esi,%edx
80108539:	e8 02 f8 ff ff       	call   80107d40 <walkpgdir>
8010853e:	85 c0                	test   %eax,%eax
80108540:	74 61                	je     801085a3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108542:	8b 00                	mov    (%eax),%eax
80108544:	a8 01                	test   $0x1,%al
80108546:	74 4e                	je     80108596 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108548:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010854a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010854f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108552:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108558:	e8 73 a7 ff ff       	call   80102cd0 <kalloc>
8010855d:	89 c3                	mov    %eax,%ebx
8010855f:	85 c0                	test   %eax,%eax
80108561:	75 8d                	jne    801084f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108563:	83 ec 0c             	sub    $0xc,%esp
80108566:	ff 75 e0             	pushl  -0x20(%ebp)
80108569:	e8 02 fe ff ff       	call   80108370 <freevm>
  return 0;
8010856e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108575:	83 c4 10             	add    $0x10,%esp
}
80108578:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010857b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010857e:	5b                   	pop    %ebx
8010857f:	5e                   	pop    %esi
80108580:	5f                   	pop    %edi
80108581:	5d                   	pop    %ebp
80108582:	c3                   	ret    
80108583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108587:	90                   	nop
      kfree(mem);
80108588:	83 ec 0c             	sub    $0xc,%esp
8010858b:	53                   	push   %ebx
8010858c:	e8 7f a5 ff ff       	call   80102b10 <kfree>
      goto bad;
80108591:	83 c4 10             	add    $0x10,%esp
80108594:	eb cd                	jmp    80108563 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108596:	83 ec 0c             	sub    $0xc,%esp
80108599:	68 ba 91 10 80       	push   $0x801091ba
8010859e:	e8 ed 7d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801085a3:	83 ec 0c             	sub    $0xc,%esp
801085a6:	68 a0 91 10 80       	push   $0x801091a0
801085ab:	e8 e0 7d ff ff       	call   80100390 <panic>

801085b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801085b0:	f3 0f 1e fb          	endbr32 
801085b4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085b5:	31 c9                	xor    %ecx,%ecx
{
801085b7:	89 e5                	mov    %esp,%ebp
801085b9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801085bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801085bf:	8b 45 08             	mov    0x8(%ebp),%eax
801085c2:	e8 79 f7 ff ff       	call   80107d40 <walkpgdir>
  if((*pte & PTE_P) == 0)
801085c7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801085c9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801085ca:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801085cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801085d1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801085d4:	05 00 00 00 80       	add    $0x80000000,%eax
801085d9:	83 fa 05             	cmp    $0x5,%edx
801085dc:	ba 00 00 00 00       	mov    $0x0,%edx
801085e1:	0f 45 c2             	cmovne %edx,%eax
}
801085e4:	c3                   	ret    
801085e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801085f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801085f0:	f3 0f 1e fb          	endbr32 
801085f4:	55                   	push   %ebp
801085f5:	89 e5                	mov    %esp,%ebp
801085f7:	57                   	push   %edi
801085f8:	56                   	push   %esi
801085f9:	53                   	push   %ebx
801085fa:	83 ec 0c             	sub    $0xc,%esp
801085fd:	8b 75 14             	mov    0x14(%ebp),%esi
80108600:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108603:	85 f6                	test   %esi,%esi
80108605:	75 3c                	jne    80108643 <copyout+0x53>
80108607:	eb 67                	jmp    80108670 <copyout+0x80>
80108609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108610:	8b 55 0c             	mov    0xc(%ebp),%edx
80108613:	89 fb                	mov    %edi,%ebx
80108615:	29 d3                	sub    %edx,%ebx
80108617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010861d:	39 f3                	cmp    %esi,%ebx
8010861f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108622:	29 fa                	sub    %edi,%edx
80108624:	83 ec 04             	sub    $0x4,%esp
80108627:	01 c2                	add    %eax,%edx
80108629:	53                   	push   %ebx
8010862a:	ff 75 10             	pushl  0x10(%ebp)
8010862d:	52                   	push   %edx
8010862e:	e8 7d d3 ff ff       	call   801059b0 <memmove>
    len -= n;
    buf += n;
80108633:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108636:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010863c:	83 c4 10             	add    $0x10,%esp
8010863f:	29 de                	sub    %ebx,%esi
80108641:	74 2d                	je     80108670 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108643:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108645:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108648:	89 55 0c             	mov    %edx,0xc(%ebp)
8010864b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108651:	57                   	push   %edi
80108652:	ff 75 08             	pushl  0x8(%ebp)
80108655:	e8 56 ff ff ff       	call   801085b0 <uva2ka>
    if(pa0 == 0)
8010865a:	83 c4 10             	add    $0x10,%esp
8010865d:	85 c0                	test   %eax,%eax
8010865f:	75 af                	jne    80108610 <copyout+0x20>
  }
  return 0;
}
80108661:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108669:	5b                   	pop    %ebx
8010866a:	5e                   	pop    %esi
8010866b:	5f                   	pop    %edi
8010866c:	5d                   	pop    %ebp
8010866d:	c3                   	ret    
8010866e:	66 90                	xchg   %ax,%ax
80108670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108673:	31 c0                	xor    %eax,%eax
}
80108675:	5b                   	pop    %ebx
80108676:	5e                   	pop    %esi
80108677:	5f                   	pop    %edi
80108678:	5d                   	pop    %ebp
80108679:	c3                   	ret    
