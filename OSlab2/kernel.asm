
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
80100028:	bc 00 c6 10 80       	mov    $0x8010c600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 36 10 80       	mov    $0x801036d0,%eax
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
80100048:	bb 34 c6 10 80       	mov    $0x8010c634,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 78 10 80       	push   $0x80107840
80100055:	68 00 c6 10 80       	push   $0x8010c600
8010005a:	e8 a1 4a 00 00       	call   80104b00 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 0c 11 80       	mov    $0x80110cfc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 0d 11 80 fc 	movl   $0x80110cfc,0x80110d4c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 0d 11 80 fc 	movl   $0x80110cfc,0x80110d50
80100078:	0c 11 80 
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
8010008b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 78 10 80       	push   $0x80107847
80100097:	50                   	push   %eax
80100098:	e8 23 49 00 00       	call   801049c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 0d 11 80       	mov    0x80110d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 0a 11 80    	cmp    $0x80110aa0,%ebx
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
801000e3:	68 00 c6 10 80       	push   $0x8010c600
801000e8:	e8 93 4b 00 00       	call   80104c80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 0d 11 80    	mov    0x80110d50,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
80100120:	8b 1d 4c 0d 11 80    	mov    0x80110d4c,%ebx
80100126:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
8010015d:	68 00 c6 10 80       	push   $0x8010c600
80100162:	e8 d9 4b 00 00       	call   80104d40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 48 00 00       	call   80104a00 <acquiresleep>
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
8010018c:	e8 7f 27 00 00       	call   80102910 <iderw>
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
801001c2:	e8 d9 48 00 00       	call   80104aa0 <holdingsleep>
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
801001d8:	e9 33 27 00 00       	jmp    80102910 <iderw>
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
80100203:	e8 98 48 00 00       	call   80104aa0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 48 00 00       	call   80104a60 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010021f:	e8 5c 4a 00 00       	call   80104c80 <acquire>
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
80100246:	a1 50 0d 11 80       	mov    0x80110d50,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 0d 11 80       	mov    0x80110d50,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 c6 10 80 	movl   $0x8010c600,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 4a 00 00       	jmp    80104d40 <release>
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
801002a5:	e8 26 1c 00 00       	call   80101ed0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 ca 49 00 00       	call   80104c80 <acquire>
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
801002c6:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002cb:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 b5 10 80       	push   $0x8010b540
801002e0:	68 e0 0f 11 80       	push   $0x80110fe0
801002e5:	e8 c6 42 00 00       	call   801045b0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 3c 00 00       	call   80103ff0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 b5 10 80       	push   $0x8010b540
8010030e:	e8 2d 4a 00 00       	call   80104d40 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 d4 1a 00 00       	call   80101df0 <ilock>
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
80100333:	89 15 e0 0f 11 80    	mov    %edx,0x80110fe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 0f 11 80 	movsbl -0x7feef0a0(%edx),%ecx
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
80100360:	68 40 b5 10 80       	push   $0x8010b540
80100365:	e8 d6 49 00 00       	call   80104d40 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 7d 1a 00 00       	call   80101df0 <ilock>
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
80100386:	a3 e0 0f 11 80       	mov    %eax,0x80110fe0
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
8010039d:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 7e 2b 00 00       	call   80102f30 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 78 10 80       	push   $0x8010786d
801003bb:	e8 e0 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 d7 03 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 a7 81 10 80 	movl   $0x801081a7,(%esp)
801003d0:	e8 cb 03 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 47 00 00       	call   80104b20 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 78 10 80       	push   $0x80107881
801003f1:	e8 aa 03 00 00       	call   801007a0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
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
8010042a:	e8 11 60 00 00       	call   80106440 <uartputc>
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
8010048c:	8b 0d 80 b5 10 80    	mov    0x8010b580,%ecx
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
8010053e:	03 3d 80 b5 10 80    	add    0x8010b580,%edi
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
80100595:	e8 a6 5e 00 00       	call   80106440 <uartputc>
8010059a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005a1:	e8 9a 5e 00 00       	call   80106440 <uartputc>
801005a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005ad:	e8 8e 5e 00 00       	call   80106440 <uartputc>
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
801005d5:	e8 56 48 00 00       	call   80104e30 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005da:	b8 80 07 00 00       	mov    $0x780,%eax
801005df:	83 c4 0c             	add    $0xc,%esp
801005e2:	29 f8                	sub    %edi,%eax
801005e4:	01 c0                	add    %eax,%eax
801005e6:	50                   	push   %eax
801005e7:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005ee:	6a 00                	push   $0x0
801005f0:	50                   	push   %eax
801005f1:	e8 9a 47 00 00       	call   80104d90 <memset>
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
80100620:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80100625:	85 c0                	test   %eax,%eax
80100627:	0f 84 b9 fe ff ff    	je     801004e6 <consputc.part.0+0xd6>
      width--;
8010062d:	83 e8 01             	sub    $0x1,%eax
      ++pos;
80100630:	83 c7 01             	add    $0x1,%edi
      width--;
80100633:	a3 80 b5 10 80       	mov    %eax,0x8010b580
80100638:	e9 a9 fe ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
8010063d:	8d 76 00             	lea    0x0(%esi),%esi
    int buf_char_size = strlen(input.buf)-empty_cell;
80100640:	83 ec 0c             	sub    $0xc,%esp
80100643:	68 60 0f 11 80       	push   $0x80110f60
80100648:	e8 43 49 00 00       	call   80104f90 <strlen>
    if (width<buf_char_size)
8010064d:	8b 15 80 b5 10 80    	mov    0x8010b580,%edx
    int buf_char_size = strlen(input.buf)-empty_cell;
80100653:	2b 05 7c b5 10 80    	sub    0x8010b57c,%eax
    if (width<buf_char_size)
80100659:	83 c4 10             	add    $0x10,%esp
8010065c:	39 d0                	cmp    %edx,%eax
8010065e:	0f 8e 82 fe ff ff    	jle    801004e6 <consputc.part.0+0xd6>
      width++;
80100664:	83 c2 01             	add    $0x1,%edx
      --pos;
80100667:	83 ef 01             	sub    $0x1,%edi
      width++;
8010066a:	89 15 80 b5 10 80    	mov    %edx,0x8010b580
80100670:	e9 71 fe ff ff       	jmp    801004e6 <consputc.part.0+0xd6>
    panic("pos under/overflow");
80100675:	83 ec 0c             	sub    $0xc,%esp
80100678:	68 85 78 10 80       	push   $0x80107885
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
801006b9:	0f b6 92 b0 78 10 80 	movzbl -0x7fef8750(%edx),%edx
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
801006f3:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
80100743:	e8 88 17 00 00       	call   80101ed0 <iunlock>
  acquire(&cons.lock);
80100748:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010074f:	e8 2c 45 00 00       	call   80104c80 <acquire>
  for(i = 0; i < n; i++)
80100754:	83 c4 10             	add    $0x10,%esp
80100757:	85 db                	test   %ebx,%ebx
80100759:	7e 24                	jle    8010077f <consolewrite+0x4f>
8010075b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010075e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100761:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
80100782:	68 40 b5 10 80       	push   $0x8010b540
80100787:	e8 b4 45 00 00       	call   80104d40 <release>
  ilock(ip);
8010078c:	58                   	pop    %eax
8010078d:	ff 75 08             	pushl  0x8(%ebp)
80100790:	e8 5b 16 00 00       	call   80101df0 <ilock>

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
801007ad:	a1 74 b5 10 80       	mov    0x8010b574,%eax
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
801007dc:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
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
8010086d:	bb 98 78 10 80       	mov    $0x80107898,%ebx
      for(; *s; s++)
80100872:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100877:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
801008a8:	68 40 b5 10 80       	push   $0x8010b540
801008ad:	e8 ce 43 00 00       	call   80104c80 <acquire>
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
801008d0:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
801008d6:	85 ff                	test   %edi,%edi
801008d8:	0f 84 12 ff ff ff    	je     801007f0 <cprintf+0x50>
801008de:	fa                   	cli    
    for(;;)
801008df:	eb fe                	jmp    801008df <cprintf+0x13f>
801008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801008e8:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
801008ee:	85 c9                	test   %ecx,%ecx
801008f0:	74 06                	je     801008f8 <cprintf+0x158>
801008f2:	fa                   	cli    
    for(;;)
801008f3:	eb fe                	jmp    801008f3 <cprintf+0x153>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
801008f8:	b8 25 00 00 00       	mov    $0x25,%eax
801008fd:	e8 0e fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100902:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100908:	85 d2                	test   %edx,%edx
8010090a:	74 2c                	je     80100938 <cprintf+0x198>
8010090c:	fa                   	cli    
    for(;;)
8010090d:	eb fe                	jmp    8010090d <cprintf+0x16d>
8010090f:	90                   	nop
    release(&cons.lock);
80100910:	83 ec 0c             	sub    $0xc,%esp
80100913:	68 40 b5 10 80       	push   $0x8010b540
80100918:	e8 23 44 00 00       	call   80104d40 <release>
8010091d:	83 c4 10             	add    $0x10,%esp
}
80100920:	e9 ee fe ff ff       	jmp    80100813 <cprintf+0x73>
    panic("null fmt");
80100925:	83 ec 0c             	sub    $0xc,%esp
80100928:	68 9f 78 10 80       	push   $0x8010789f
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
80100a70:	e8 1b 45 00 00       	call   80104f90 <strlen>
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
80100aa4:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
    if(off_limits)
80100aaa:	89 f0                	mov    %esi,%eax
80100aac:	83 fe 0a             	cmp    $0xa,%esi
80100aaf:	74 47                	je     80100af8 <save_command+0x98>
    memmove(cmd_mem[cmd_mem_size], cmd, sizeof(char)* count);  
80100ab1:	c1 e0 07             	shl    $0x7,%eax
80100ab4:	83 ec 04             	sub    $0x4,%esp
80100ab7:	ff 75 e4             	pushl  -0x1c(%ebp)
80100aba:	05 00 10 11 80       	add    $0x80111000,%eax
80100abf:	ff 75 08             	pushl  0x8(%ebp)
80100ac2:	50                   	push   %eax
80100ac3:	e8 68 43 00 00       	call   80104e30 <memmove>
    cmd_mem[cmd_mem_size][count] = '\0';
80100ac8:	8b 15 20 b5 10 80    	mov    0x8010b520,%edx
    cmd_mem_size += (off_limits ? 0 : 1);
80100ace:	83 c4 10             	add    $0x10,%esp
    cmd_mem[cmd_mem_size][count] = '\0';
80100ad1:	89 d0                	mov    %edx,%eax
80100ad3:	c1 e0 07             	shl    $0x7,%eax
80100ad6:	c6 84 03 00 10 11 80 	movb   $0x0,-0x7feef000(%ebx,%eax,1)
80100add:	00 
    cmd_mem_size += (off_limits ? 0 : 1);
80100ade:	31 c0                	xor    %eax,%eax
80100ae0:	83 fe 0a             	cmp    $0xa,%esi
80100ae3:	0f 95 c0             	setne  %al
80100ae6:	01 d0                	add    %edx,%eax
80100ae8:	a3 20 b5 10 80       	mov    %eax,0x8010b520
}
80100aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af0:	5b                   	pop    %ebx
80100af1:	5e                   	pop    %esi
80100af2:	5f                   	pop    %edi
80100af3:	5d                   	pop    %ebp
80100af4:	c3                   	ret    
80100af5:	8d 76 00             	lea    0x0(%esi),%esi
80100af8:	bf 00 10 11 80       	mov    $0x80111000,%edi
80100afd:	8d 76 00             	lea    0x0(%esi),%esi
        memmove(cmd_mem[i],cmd_mem[i+1],sizeof(char)* INPUT_BUF);  
80100b00:	83 ec 04             	sub    $0x4,%esp
80100b03:	89 f8                	mov    %edi,%eax
80100b05:	83 ef 80             	sub    $0xffffff80,%edi
80100b08:	68 80 00 00 00       	push   $0x80
80100b0d:	57                   	push   %edi
80100b0e:	50                   	push   %eax
80100b0f:	e8 1c 43 00 00       	call   80104e30 <memmove>
      for (int i = 0; i < CMD_MEM_SIZE; i++)
80100b14:	83 c4 10             	add    $0x10,%esp
80100b17:	81 ff 00 15 11 80    	cmp    $0x80111500,%edi
80100b1d:	75 e1                	jne    80100b00 <save_command+0xa0>
80100b1f:	a1 20 b5 10 80       	mov    0x8010b520,%eax
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
80100b89:	03 0d 80 b5 10 80    	add    0x8010b580,%ecx
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
80100c10:	68 40 b5 10 80       	push   $0x8010b540
80100c15:	e8 66 40 00 00       	call   80104c80 <acquire>
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
80100c4f:	8b 35 78 b5 10 80    	mov    0x8010b578,%esi
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
80100c72:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100c77:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100c7d:	74 a8                	je     80100c27 <consoleintr+0x27>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c7f:	83 e8 01             	sub    $0x1,%eax
80100c82:	89 c2                	mov    %eax,%edx
80100c84:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100c87:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100c8e:	74 97                	je     80100c27 <consoleintr+0x27>
        input.e--;
80100c90:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
  if(panicked){
80100c95:	a1 78 b5 10 80       	mov    0x8010b578,%eax
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
80100cb3:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
80100cb9:	83 ff ff             	cmp    $0xffffffff,%edi
80100cbc:	0f 84 65 ff ff ff    	je     80100c27 <consoleintr+0x27>
        for (int i = input.pos; i < input.e; i++)
80100cc2:	8b 35 ec 0f 11 80    	mov    0x80110fec,%esi
80100cc8:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
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
80100d3b:	39 0d e4 0f 11 80    	cmp    %ecx,0x80110fe4
80100d41:	75 1d                	jne    80100d60 <consoleintr+0x160>
80100d43:	eb 32                	jmp    80100d77 <consoleintr+0x177>
80100d45:	8d 76 00             	lea    0x0(%esi),%esi
          input.e--;
80100d48:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
          leftside_moving_cursor();
80100d4d:	e8 de fd ff ff       	call   80100b30 <leftside_moving_cursor>
        while(input.e != input.w &&
80100d52:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
80100d58:	3b 0d e4 0f 11 80    	cmp    0x80110fe4,%ecx
80100d5e:	74 11                	je     80100d71 <consoleintr+0x171>
          input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100d60:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100d63:	89 c2                	mov    %eax,%edx
80100d65:	83 e2 7f             	and    $0x7f,%edx
        while(input.e != input.w &&
80100d68:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100d6f:	75 d7                	jne    80100d48 <consoleintr+0x148>
80100d71:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
{
80100d77:	31 db                	xor    %ebx,%ebx
          temp_id = cmd_mem[cmd_idx][i];
80100d79:	89 f8                	mov    %edi,%eax
80100d7b:	c1 e0 07             	shl    $0x7,%eax
80100d7e:	0f b6 b4 03 00 10 11 	movzbl -0x7feef000(%ebx,%eax,1),%esi
80100d85:	80 
          if (temp_id == '\0')
80100d86:	89 f0                	mov    %esi,%eax
80100d88:	84 c0                	test   %al,%al
80100d8a:	0f 84 8c 02 00 00    	je     8010101c <consoleintr+0x41c>
  if(panicked){
80100d90:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
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
80100db1:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100db6:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100dbc:	0f 84 65 fe ff ff    	je     80100c27 <consoleintr+0x27>
        input.e--;
80100dc2:	83 e8 01             	sub    $0x1,%eax
        empty_cell++;
80100dc5:	83 05 7c b5 10 80 01 	addl   $0x1,0x8010b57c
        input.e--;
80100dcc:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
  if(panicked){
80100dd1:	a1 78 b5 10 80       	mov    0x8010b578,%eax
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
80100e06:	8b 1d 78 b5 10 80    	mov    0x8010b578,%ebx
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
80100e3e:	8b 15 e8 0f 11 80    	mov    0x80110fe8,%edx
80100e44:	8b 0d e0 0f 11 80    	mov    0x80110fe0,%ecx
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
80100e86:	8b 35 ec 0f 11 80    	mov    0x80110fec,%esi
80100e8c:	8b 1d 80 b5 10 80    	mov    0x8010b580,%ebx
80100e92:	8d 4e 01             	lea    0x1(%esi),%ecx
80100e95:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
80100e9b:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
80100ea1:	85 db                	test   %ebx,%ebx
80100ea3:	0f 85 8b 01 00 00    	jne    80101034 <consoleintr+0x434>
            input.buf[input.e++ % INPUT_BUF] = c;
80100ea9:	83 e2 7f             	and    $0x7f,%edx
80100eac:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100eb2:	88 82 60 0f 11 80    	mov    %al,-0x7feef0a0(%edx)
  if(panicked){
80100eb8:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
            input.pos++;
80100ebe:	89 0d ec 0f 11 80    	mov    %ecx,0x80110fec
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
80100ee2:	68 40 b5 10 80       	push   $0x8010b540
80100ee7:	e8 54 3e 00 00       	call   80104d40 <release>
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
80100f10:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
80100f16:	89 f0                	mov    %esi,%eax
80100f18:	89 ca                	mov    %ecx,%edx
80100f1a:	8d 79 01             	lea    0x1(%ecx),%edi
80100f1d:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100f23:	89 f9                	mov    %edi,%ecx
80100f25:	88 82 60 0f 11 80    	mov    %al,-0x7feef0a0(%edx)
        for (int i = 0; i < INPUT_BUF; i++)
80100f2b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80100f31:	0f 84 cb 00 00 00    	je     80101002 <consoleintr+0x402>
80100f37:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
80100f3d:	e9 37 fe ff ff       	jmp    80100d79 <consoleintr+0x179>
80100f42:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
        c = (c == '\r') ? '\n' : c;
80100f49:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80100f4e:	0f b6 9d 64 ff ff ff 	movzbl -0x9c(%ebp),%ebx
  if(panicked){
80100f55:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80100f5b:	83 e2 7f             	and    $0x7f,%edx
80100f5e:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100f64:	88 9a 60 0f 11 80    	mov    %bl,-0x7feef0a0(%edx)
  if(panicked){
80100f6a:	85 c9                	test   %ecx,%ecx
80100f6c:	74 0a                	je     80100f78 <consoleintr+0x378>
80100f6e:	fa                   	cli    
    for(;;)
80100f6f:	eb fe                	jmp    80100f6f <consoleintr+0x36f>
80100f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f78:	e8 93 f4 ff ff       	call   80100410 <consputc.part.0>
          for (int i = 0; i+input.w < input.e -1; i++)
80100f7d:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100f82:	8b 0d e4 0f 11 80    	mov    0x80110fe4,%ecx
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100f88:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
          width =0;
80100f8e:	c7 05 80 b5 10 80 00 	movl   $0x0,0x8010b580
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
80100fa8:	0f b6 9b 60 0f 11 80 	movzbl -0x7feef0a0(%ebx),%ebx
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
80100fd5:	a1 20 b5 10 80       	mov    0x8010b520,%eax
          wakeup(&input.r);
80100fda:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
          cmd_idx = cmd_mem_size;
80100fe1:	a3 00 90 10 80       	mov    %eax,0x80109000
          input.pos = input.e;
80100fe6:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100feb:	a3 ec 0f 11 80       	mov    %eax,0x80110fec
          input.w = input.e;
80100ff0:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
80100ff5:	e8 76 37 00 00       	call   80104770 <wakeup>
        {
80100ffa:	83 c4 10             	add    $0x10,%esp
80100ffd:	e9 25 fc ff ff       	jmp    80100c27 <consoleintr+0x27>
80101002:	89 f8                	mov    %edi,%eax
80101004:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
        input.pos = input.e;
8010100a:	a3 ec 0f 11 80       	mov    %eax,0x80110fec
        cmd_idx--;
8010100f:	8d 47 ff             	lea    -0x1(%edi),%eax
80101012:	a3 00 90 10 80       	mov    %eax,0x80109000
80101017:	e9 0b fc ff ff       	jmp    80100c27 <consoleintr+0x27>
8010101c:	89 c8                	mov    %ecx,%eax
8010101e:	eb ea                	jmp    8010100a <consoleintr+0x40a>
    procdump();  // now call procdump() wo. cons.lock held
80101020:	e8 3b 38 00 00       	call   80104860 <procdump>
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
80101051:	0f b6 99 60 0f 11 80 	movzbl -0x7feef0a0(%ecx),%ebx
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
80101078:	88 99 60 0f 11 80    	mov    %bl,-0x7feef0a0(%ecx)
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
8010109a:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
            input.pos++;
801010a0:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
            input.buf[input.pos%INPUT_BUF] = c;
801010a6:	88 9e 60 0f 11 80    	mov    %bl,-0x7feef0a0(%esi)
            input.pos++;
801010ac:	89 3d ec 0f 11 80    	mov    %edi,0x80110fec
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
801010ca:	68 a8 78 10 80       	push   $0x801078a8
801010cf:	68 40 b5 10 80       	push   $0x8010b540
801010d4:	e8 27 3a 00 00       	call   80104b00 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801010d9:	58                   	pop    %eax
801010da:	5a                   	pop    %edx
801010db:	6a 00                	push   $0x0
801010dd:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801010df:	c7 05 ac 1e 11 80 30 	movl   $0x80100730,0x80111eac
801010e6:	07 10 80 
  devsw[CONSOLE].read = consoleread;
801010e9:	c7 05 a8 1e 11 80 90 	movl   $0x80100290,0x80111ea8
801010f0:	02 10 80 
  cons.locking = 1;
801010f3:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801010fa:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801010fd:	e8 be 19 00 00       	call   80102ac0 <ioapicenable>
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
80101120:	e8 cb 2e 00 00       	call   80103ff0 <myproc>
80101125:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010112b:	e8 90 22 00 00       	call   801033c0 <begin_op>

  if((ip = namei(path)) == 0){
80101130:	83 ec 0c             	sub    $0xc,%esp
80101133:	ff 75 08             	pushl  0x8(%ebp)
80101136:	e8 85 15 00 00       	call   801026c0 <namei>
8010113b:	83 c4 10             	add    $0x10,%esp
8010113e:	85 c0                	test   %eax,%eax
80101140:	0f 84 fe 02 00 00    	je     80101444 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	89 c3                	mov    %eax,%ebx
8010114b:	50                   	push   %eax
8010114c:	e8 9f 0c 00 00       	call   80101df0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101151:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101157:	6a 34                	push   $0x34
80101159:	6a 00                	push   $0x0
8010115b:	50                   	push   %eax
8010115c:	53                   	push   %ebx
8010115d:	e8 8e 0f 00 00       	call   801020f0 <readi>
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
8010116e:	e8 1d 0f 00 00       	call   80102090 <iunlockput>
    end_op();
80101173:	e8 b8 22 00 00       	call   80103430 <end_op>
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
8010119c:	e8 0f 64 00 00       	call   801075b0 <setupkvm>
801011a1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801011a7:	85 c0                	test   %eax,%eax
801011a9:	74 bf                	je     8010116a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011ab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801011b2:	00 
801011b3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801011b9:	0f 84 a4 02 00 00    	je     80101463 <exec+0x353>
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
80101203:	e8 c8 61 00 00       	call   801073d0 <allocuvm>
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
80101239:	e8 c2 60 00 00       	call   80107300 <loaduvm>
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
80101261:	e8 8a 0e 00 00       	call   801020f0 <readi>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	83 f8 20             	cmp    $0x20,%eax
8010126c:	0f 84 5e ff ff ff    	je     801011d0 <exec+0xc0>
    freevm(pgdir);
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010127b:	e8 b0 62 00 00       	call   80107530 <freevm>
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
801012ac:	e8 df 0d 00 00       	call   80102090 <iunlockput>
  end_op();
801012b1:	e8 7a 21 00 00       	call   80103430 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801012b6:	83 c4 0c             	add    $0xc,%esp
801012b9:	56                   	push   %esi
801012ba:	57                   	push   %edi
801012bb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801012c1:	57                   	push   %edi
801012c2:	e8 09 61 00 00       	call   801073d0 <allocuvm>
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
801012e3:	e8 68 63 00 00       	call   80107650 <clearpteu>
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
80101333:	e8 58 3c 00 00       	call   80104f90 <strlen>
80101338:	f7 d0                	not    %eax
8010133a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010133c:	58                   	pop    %eax
8010133d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101340:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101343:	ff 34 b8             	pushl  (%eax,%edi,4)
80101346:	e8 45 3c 00 00       	call   80104f90 <strlen>
8010134b:	83 c0 01             	add    $0x1,%eax
8010134e:	50                   	push   %eax
8010134f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101352:	ff 34 b8             	pushl  (%eax,%edi,4)
80101355:	53                   	push   %ebx
80101356:	56                   	push   %esi
80101357:	e8 54 64 00 00       	call   801077b0 <copyout>
8010135c:	83 c4 20             	add    $0x20,%esp
8010135f:	85 c0                	test   %eax,%eax
80101361:	79 ad                	jns    80101310 <exec+0x200>
80101363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101367:	90                   	nop
    freevm(pgdir);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101371:	e8 ba 61 00 00       	call   80107530 <freevm>
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
801013c3:	e8 e8 63 00 00       	call   801077b0 <copyout>
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
80101401:	e8 4a 3b 00 00       	call   80104f50 <safestrcpy>
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
  switchuvm(curproc);
8010142a:	89 0c 24             	mov    %ecx,(%esp)
8010142d:	e8 3e 5d 00 00       	call   80107170 <switchuvm>
  freevm(oldpgdir);
80101432:	89 3c 24             	mov    %edi,(%esp)
80101435:	e8 f6 60 00 00       	call   80107530 <freevm>
  return 0;
8010143a:	83 c4 10             	add    $0x10,%esp
8010143d:	31 c0                	xor    %eax,%eax
8010143f:	e9 3c fd ff ff       	jmp    80101180 <exec+0x70>
    end_op();
80101444:	e8 e7 1f 00 00       	call   80103430 <end_op>
    cprintf("exec: fail\n");
80101449:	83 ec 0c             	sub    $0xc,%esp
8010144c:	68 c1 78 10 80       	push   $0x801078c1
80101451:	e8 4a f3 ff ff       	call   801007a0 <cprintf>
    return -1;
80101456:	83 c4 10             	add    $0x10,%esp
80101459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010145e:	e9 1d fd ff ff       	jmp    80101180 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101463:	31 ff                	xor    %edi,%edi
80101465:	be 00 20 00 00       	mov    $0x2000,%esi
8010146a:	e9 39 fe ff ff       	jmp    801012a8 <exec+0x198>
8010146f:	90                   	nop

80101470 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101470:	f3 0f 1e fb          	endbr32 
80101474:	55                   	push   %ebp
80101475:	89 e5                	mov    %esp,%ebp
80101477:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010147a:	68 cd 78 10 80       	push   $0x801078cd
8010147f:	68 00 15 11 80       	push   $0x80111500
80101484:	e8 77 36 00 00       	call   80104b00 <initlock>
}
80101489:	83 c4 10             	add    $0x10,%esp
8010148c:	c9                   	leave  
8010148d:	c3                   	ret    
8010148e:	66 90                	xchg   %ax,%ax

80101490 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101490:	f3 0f 1e fb          	endbr32 
80101494:	55                   	push   %ebp
80101495:	89 e5                	mov    %esp,%ebp
80101497:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101498:	bb 34 15 11 80       	mov    $0x80111534,%ebx
{
8010149d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801014a0:	68 00 15 11 80       	push   $0x80111500
801014a5:	e8 d6 37 00 00       	call   80104c80 <acquire>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb 0c                	jmp    801014bb <filealloc+0x2b>
801014af:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014b0:	83 c3 18             	add    $0x18,%ebx
801014b3:	81 fb 94 1e 11 80    	cmp    $0x80111e94,%ebx
801014b9:	74 25                	je     801014e0 <filealloc+0x50>
    if(f->ref == 0){
801014bb:	8b 43 04             	mov    0x4(%ebx),%eax
801014be:	85 c0                	test   %eax,%eax
801014c0:	75 ee                	jne    801014b0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801014c2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801014c5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801014cc:	68 00 15 11 80       	push   $0x80111500
801014d1:	e8 6a 38 00 00       	call   80104d40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801014d6:	89 d8                	mov    %ebx,%eax
      return f;
801014d8:	83 c4 10             	add    $0x10,%esp
}
801014db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014de:	c9                   	leave  
801014df:	c3                   	ret    
  release(&ftable.lock);
801014e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801014e3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801014e5:	68 00 15 11 80       	push   $0x80111500
801014ea:	e8 51 38 00 00       	call   80104d40 <release>
}
801014ef:	89 d8                	mov    %ebx,%eax
  return 0;
801014f1:	83 c4 10             	add    $0x10,%esp
}
801014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f7:	c9                   	leave  
801014f8:	c3                   	ret    
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101500 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	53                   	push   %ebx
80101508:	83 ec 10             	sub    $0x10,%esp
8010150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010150e:	68 00 15 11 80       	push   $0x80111500
80101513:	e8 68 37 00 00       	call   80104c80 <acquire>
  if(f->ref < 1)
80101518:	8b 43 04             	mov    0x4(%ebx),%eax
8010151b:	83 c4 10             	add    $0x10,%esp
8010151e:	85 c0                	test   %eax,%eax
80101520:	7e 1a                	jle    8010153c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101522:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101525:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101528:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010152b:	68 00 15 11 80       	push   $0x80111500
80101530:	e8 0b 38 00 00       	call   80104d40 <release>
  return f;
}
80101535:	89 d8                	mov    %ebx,%eax
80101537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010153a:	c9                   	leave  
8010153b:	c3                   	ret    
    panic("filedup");
8010153c:	83 ec 0c             	sub    $0xc,%esp
8010153f:	68 d4 78 10 80       	push   $0x801078d4
80101544:	e8 47 ee ff ff       	call   80100390 <panic>
80101549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101550 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	57                   	push   %edi
80101558:	56                   	push   %esi
80101559:	53                   	push   %ebx
8010155a:	83 ec 28             	sub    $0x28,%esp
8010155d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101560:	68 00 15 11 80       	push   $0x80111500
80101565:	e8 16 37 00 00       	call   80104c80 <acquire>
  if(f->ref < 1)
8010156a:	8b 53 04             	mov    0x4(%ebx),%edx
8010156d:	83 c4 10             	add    $0x10,%esp
80101570:	85 d2                	test   %edx,%edx
80101572:	0f 8e a1 00 00 00    	jle    80101619 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101578:	83 ea 01             	sub    $0x1,%edx
8010157b:	89 53 04             	mov    %edx,0x4(%ebx)
8010157e:	75 40                	jne    801015c0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101580:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101584:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101587:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101589:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010158f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101592:	88 45 e7             	mov    %al,-0x19(%ebp)
80101595:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101598:	68 00 15 11 80       	push   $0x80111500
  ff = *f;
8010159d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801015a0:	e8 9b 37 00 00       	call   80104d40 <release>

  if(ff.type == FD_PIPE)
801015a5:	83 c4 10             	add    $0x10,%esp
801015a8:	83 ff 01             	cmp    $0x1,%edi
801015ab:	74 53                	je     80101600 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801015ad:	83 ff 02             	cmp    $0x2,%edi
801015b0:	74 26                	je     801015d8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801015b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b5:	5b                   	pop    %ebx
801015b6:	5e                   	pop    %esi
801015b7:	5f                   	pop    %edi
801015b8:	5d                   	pop    %ebp
801015b9:	c3                   	ret    
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801015c0:	c7 45 08 00 15 11 80 	movl   $0x80111500,0x8(%ebp)
}
801015c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ca:	5b                   	pop    %ebx
801015cb:	5e                   	pop    %esi
801015cc:	5f                   	pop    %edi
801015cd:	5d                   	pop    %ebp
    release(&ftable.lock);
801015ce:	e9 6d 37 00 00       	jmp    80104d40 <release>
801015d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015d7:	90                   	nop
    begin_op();
801015d8:	e8 e3 1d 00 00       	call   801033c0 <begin_op>
    iput(ff.ip);
801015dd:	83 ec 0c             	sub    $0xc,%esp
801015e0:	ff 75 e0             	pushl  -0x20(%ebp)
801015e3:	e8 38 09 00 00       	call   80101f20 <iput>
    end_op();
801015e8:	83 c4 10             	add    $0x10,%esp
}
801015eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ee:	5b                   	pop    %ebx
801015ef:	5e                   	pop    %esi
801015f0:	5f                   	pop    %edi
801015f1:	5d                   	pop    %ebp
    end_op();
801015f2:	e9 39 1e 00 00       	jmp    80103430 <end_op>
801015f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101600:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101604:	83 ec 08             	sub    $0x8,%esp
80101607:	53                   	push   %ebx
80101608:	56                   	push   %esi
80101609:	e8 82 25 00 00       	call   80103b90 <pipeclose>
8010160e:	83 c4 10             	add    $0x10,%esp
}
80101611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101614:	5b                   	pop    %ebx
80101615:	5e                   	pop    %esi
80101616:	5f                   	pop    %edi
80101617:	5d                   	pop    %ebp
80101618:	c3                   	ret    
    panic("fileclose");
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	68 dc 78 10 80       	push   $0x801078dc
80101621:	e8 6a ed ff ff       	call   80100390 <panic>
80101626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101630:	f3 0f 1e fb          	endbr32 
80101634:	55                   	push   %ebp
80101635:	89 e5                	mov    %esp,%ebp
80101637:	53                   	push   %ebx
80101638:	83 ec 04             	sub    $0x4,%esp
8010163b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010163e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101641:	75 2d                	jne    80101670 <filestat+0x40>
    ilock(f->ip);
80101643:	83 ec 0c             	sub    $0xc,%esp
80101646:	ff 73 10             	pushl  0x10(%ebx)
80101649:	e8 a2 07 00 00       	call   80101df0 <ilock>
    stati(f->ip, st);
8010164e:	58                   	pop    %eax
8010164f:	5a                   	pop    %edx
80101650:	ff 75 0c             	pushl  0xc(%ebp)
80101653:	ff 73 10             	pushl  0x10(%ebx)
80101656:	e8 65 0a 00 00       	call   801020c0 <stati>
    iunlock(f->ip);
8010165b:	59                   	pop    %ecx
8010165c:	ff 73 10             	pushl  0x10(%ebx)
8010165f:	e8 6c 08 00 00       	call   80101ed0 <iunlock>
    return 0;
  }
  return -1;
}
80101664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	31 c0                	xor    %eax,%eax
}
8010166c:	c9                   	leave  
8010166d:	c3                   	ret    
8010166e:	66 90                	xchg   %ax,%ax
80101670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101678:	c9                   	leave  
80101679:	c3                   	ret    
8010167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101680 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101680:	f3 0f 1e fb          	endbr32 
80101684:	55                   	push   %ebp
80101685:	89 e5                	mov    %esp,%ebp
80101687:	57                   	push   %edi
80101688:	56                   	push   %esi
80101689:	53                   	push   %ebx
8010168a:	83 ec 0c             	sub    $0xc,%esp
8010168d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101690:	8b 75 0c             	mov    0xc(%ebp),%esi
80101693:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101696:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010169a:	74 64                	je     80101700 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010169c:	8b 03                	mov    (%ebx),%eax
8010169e:	83 f8 01             	cmp    $0x1,%eax
801016a1:	74 45                	je     801016e8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801016a3:	83 f8 02             	cmp    $0x2,%eax
801016a6:	75 5f                	jne    80101707 <fileread+0x87>
    ilock(f->ip);
801016a8:	83 ec 0c             	sub    $0xc,%esp
801016ab:	ff 73 10             	pushl  0x10(%ebx)
801016ae:	e8 3d 07 00 00       	call   80101df0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801016b3:	57                   	push   %edi
801016b4:	ff 73 14             	pushl  0x14(%ebx)
801016b7:	56                   	push   %esi
801016b8:	ff 73 10             	pushl  0x10(%ebx)
801016bb:	e8 30 0a 00 00       	call   801020f0 <readi>
801016c0:	83 c4 20             	add    $0x20,%esp
801016c3:	89 c6                	mov    %eax,%esi
801016c5:	85 c0                	test   %eax,%eax
801016c7:	7e 03                	jle    801016cc <fileread+0x4c>
      f->off += r;
801016c9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	ff 73 10             	pushl  0x10(%ebx)
801016d2:	e8 f9 07 00 00       	call   80101ed0 <iunlock>
    return r;
801016d7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801016da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016dd:	89 f0                	mov    %esi,%eax
801016df:	5b                   	pop    %ebx
801016e0:	5e                   	pop    %esi
801016e1:	5f                   	pop    %edi
801016e2:	5d                   	pop    %ebp
801016e3:	c3                   	ret    
801016e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801016e8:	8b 43 0c             	mov    0xc(%ebx),%eax
801016eb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016f1:	5b                   	pop    %ebx
801016f2:	5e                   	pop    %esi
801016f3:	5f                   	pop    %edi
801016f4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801016f5:	e9 36 26 00 00       	jmp    80103d30 <piperead>
801016fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101700:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101705:	eb d3                	jmp    801016da <fileread+0x5a>
  panic("fileread");
80101707:	83 ec 0c             	sub    $0xc,%esp
8010170a:	68 e6 78 10 80       	push   $0x801078e6
8010170f:	e8 7c ec ff ff       	call   80100390 <panic>
80101714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010171f:	90                   	nop

80101720 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101720:	f3 0f 1e fb          	endbr32 
80101724:	55                   	push   %ebp
80101725:	89 e5                	mov    %esp,%ebp
80101727:	57                   	push   %edi
80101728:	56                   	push   %esi
80101729:	53                   	push   %ebx
8010172a:	83 ec 1c             	sub    $0x1c,%esp
8010172d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101730:	8b 75 08             	mov    0x8(%ebp),%esi
80101733:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101736:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101739:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010173d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101740:	0f 84 c1 00 00 00    	je     80101807 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101746:	8b 06                	mov    (%esi),%eax
80101748:	83 f8 01             	cmp    $0x1,%eax
8010174b:	0f 84 c3 00 00 00    	je     80101814 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101751:	83 f8 02             	cmp    $0x2,%eax
80101754:	0f 85 cc 00 00 00    	jne    80101826 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010175a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010175d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010175f:	85 c0                	test   %eax,%eax
80101761:	7f 34                	jg     80101797 <filewrite+0x77>
80101763:	e9 98 00 00 00       	jmp    80101800 <filewrite+0xe0>
80101768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101770:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101773:	83 ec 0c             	sub    $0xc,%esp
80101776:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101779:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010177c:	e8 4f 07 00 00       	call   80101ed0 <iunlock>
      end_op();
80101781:	e8 aa 1c 00 00       	call   80103430 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101786:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101789:	83 c4 10             	add    $0x10,%esp
8010178c:	39 c3                	cmp    %eax,%ebx
8010178e:	75 60                	jne    801017f0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101790:	01 df                	add    %ebx,%edi
    while(i < n){
80101792:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101795:	7e 69                	jle    80101800 <filewrite+0xe0>
      int n1 = n - i;
80101797:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010179a:	b8 00 06 00 00       	mov    $0x600,%eax
8010179f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801017a1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801017a7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801017aa:	e8 11 1c 00 00       	call   801033c0 <begin_op>
      ilock(f->ip);
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	ff 76 10             	pushl  0x10(%esi)
801017b5:	e8 36 06 00 00       	call   80101df0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801017ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017bd:	53                   	push   %ebx
801017be:	ff 76 14             	pushl  0x14(%esi)
801017c1:	01 f8                	add    %edi,%eax
801017c3:	50                   	push   %eax
801017c4:	ff 76 10             	pushl  0x10(%esi)
801017c7:	e8 24 0a 00 00       	call   801021f0 <writei>
801017cc:	83 c4 20             	add    $0x20,%esp
801017cf:	85 c0                	test   %eax,%eax
801017d1:	7f 9d                	jg     80101770 <filewrite+0x50>
      iunlock(f->ip);
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 76 10             	pushl  0x10(%esi)
801017d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017dc:	e8 ef 06 00 00       	call   80101ed0 <iunlock>
      end_op();
801017e1:	e8 4a 1c 00 00       	call   80103430 <end_op>
      if(r < 0)
801017e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017e9:	83 c4 10             	add    $0x10,%esp
801017ec:	85 c0                	test   %eax,%eax
801017ee:	75 17                	jne    80101807 <filewrite+0xe7>
        panic("short filewrite");
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	68 ef 78 10 80       	push   $0x801078ef
801017f8:	e8 93 eb ff ff       	call   80100390 <panic>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101800:	89 f8                	mov    %edi,%eax
80101802:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101805:	74 05                	je     8010180c <filewrite+0xec>
80101807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010180c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5f                   	pop    %edi
80101812:	5d                   	pop    %ebp
80101813:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101814:	8b 46 0c             	mov    0xc(%esi),%eax
80101817:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010181a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181d:	5b                   	pop    %ebx
8010181e:	5e                   	pop    %esi
8010181f:	5f                   	pop    %edi
80101820:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101821:	e9 0a 24 00 00       	jmp    80103c30 <pipewrite>
  panic("filewrite");
80101826:	83 ec 0c             	sub    $0xc,%esp
80101829:	68 f5 78 10 80       	push   $0x801078f5
8010182e:	e8 5d eb ff ff       	call   80100390 <panic>
80101833:	66 90                	xchg   %ax,%ax
80101835:	66 90                	xchg   %ax,%ax
80101837:	66 90                	xchg   %ax,%ax
80101839:	66 90                	xchg   %ax,%ax
8010183b:	66 90                	xchg   %ax,%ax
8010183d:	66 90                	xchg   %ax,%ax
8010183f:	90                   	nop

80101840 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101840:	55                   	push   %ebp
80101841:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101843:	89 d0                	mov    %edx,%eax
80101845:	c1 e8 0c             	shr    $0xc,%eax
80101848:	03 05 18 1f 11 80    	add    0x80111f18,%eax
{
8010184e:	89 e5                	mov    %esp,%ebp
80101850:	56                   	push   %esi
80101851:	53                   	push   %ebx
80101852:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101854:	83 ec 08             	sub    $0x8,%esp
80101857:	50                   	push   %eax
80101858:	51                   	push   %ecx
80101859:	e8 72 e8 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010185e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101860:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101863:	ba 01 00 00 00       	mov    $0x1,%edx
80101868:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010186b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101871:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101874:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101876:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010187b:	85 d1                	test   %edx,%ecx
8010187d:	74 25                	je     801018a4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010187f:	f7 d2                	not    %edx
  log_write(bp);
80101881:	83 ec 0c             	sub    $0xc,%esp
80101884:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101886:	21 ca                	and    %ecx,%edx
80101888:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010188c:	50                   	push   %eax
8010188d:	e8 0e 1d 00 00       	call   801035a0 <log_write>
  brelse(bp);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 e9 ff ff       	call   801001f0 <brelse>
}
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a0:	5b                   	pop    %ebx
801018a1:	5e                   	pop    %esi
801018a2:	5d                   	pop    %ebp
801018a3:	c3                   	ret    
    panic("freeing free block");
801018a4:	83 ec 0c             	sub    $0xc,%esp
801018a7:	68 ff 78 10 80       	push   $0x801078ff
801018ac:	e8 df ea ff ff       	call   80100390 <panic>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <balloc>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801018c9:	8b 0d 00 1f 11 80    	mov    0x80111f00,%ecx
{
801018cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801018d2:	85 c9                	test   %ecx,%ecx
801018d4:	0f 84 87 00 00 00    	je     80101961 <balloc+0xa1>
801018da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801018e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801018e4:	83 ec 08             	sub    $0x8,%esp
801018e7:	89 f0                	mov    %esi,%eax
801018e9:	c1 f8 0c             	sar    $0xc,%eax
801018ec:	03 05 18 1f 11 80    	add    0x80111f18,%eax
801018f2:	50                   	push   %eax
801018f3:	ff 75 d8             	pushl  -0x28(%ebp)
801018f6:	e8 d5 e7 ff ff       	call   801000d0 <bread>
801018fb:	83 c4 10             	add    $0x10,%esp
801018fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101901:	a1 00 1f 11 80       	mov    0x80111f00,%eax
80101906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101909:	31 c0                	xor    %eax,%eax
8010190b:	eb 2f                	jmp    8010193c <balloc+0x7c>
8010190d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101910:	89 c1                	mov    %eax,%ecx
80101912:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101917:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010191a:	83 e1 07             	and    $0x7,%ecx
8010191d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010191f:	89 c1                	mov    %eax,%ecx
80101921:	c1 f9 03             	sar    $0x3,%ecx
80101924:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101929:	89 fa                	mov    %edi,%edx
8010192b:	85 df                	test   %ebx,%edi
8010192d:	74 41                	je     80101970 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010192f:	83 c0 01             	add    $0x1,%eax
80101932:	83 c6 01             	add    $0x1,%esi
80101935:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010193a:	74 05                	je     80101941 <balloc+0x81>
8010193c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010193f:	77 cf                	ja     80101910 <balloc+0x50>
    brelse(bp);
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	ff 75 e4             	pushl  -0x1c(%ebp)
80101947:	e8 a4 e8 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010194c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
80101956:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101959:	39 05 00 1f 11 80    	cmp    %eax,0x80111f00
8010195f:	77 80                	ja     801018e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101961:	83 ec 0c             	sub    $0xc,%esp
80101964:	68 12 79 10 80       	push   $0x80107912
80101969:	e8 22 ea ff ff       	call   80100390 <panic>
8010196e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101970:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101973:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101976:	09 da                	or     %ebx,%edx
80101978:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010197c:	57                   	push   %edi
8010197d:	e8 1e 1c 00 00       	call   801035a0 <log_write>
        brelse(bp);
80101982:	89 3c 24             	mov    %edi,(%esp)
80101985:	e8 66 e8 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010198a:	58                   	pop    %eax
8010198b:	5a                   	pop    %edx
8010198c:	56                   	push   %esi
8010198d:	ff 75 d8             	pushl  -0x28(%ebp)
80101990:	e8 3b e7 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101995:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101998:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010199a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010199d:	68 00 02 00 00       	push   $0x200
801019a2:	6a 00                	push   $0x0
801019a4:	50                   	push   %eax
801019a5:	e8 e6 33 00 00       	call   80104d90 <memset>
  log_write(bp);
801019aa:	89 1c 24             	mov    %ebx,(%esp)
801019ad:	e8 ee 1b 00 00       	call   801035a0 <log_write>
  brelse(bp);
801019b2:	89 1c 24             	mov    %ebx,(%esp)
801019b5:	e8 36 e8 ff ff       	call   801001f0 <brelse>
}
801019ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019bd:	89 f0                	mov    %esi,%eax
801019bf:	5b                   	pop    %ebx
801019c0:	5e                   	pop    %esi
801019c1:	5f                   	pop    %edi
801019c2:	5d                   	pop    %ebp
801019c3:	c3                   	ret    
801019c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019cf:	90                   	nop

801019d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	89 c7                	mov    %eax,%edi
801019d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801019d7:	31 f6                	xor    %esi,%esi
{
801019d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019da:	bb 54 1f 11 80       	mov    $0x80111f54,%ebx
{
801019df:	83 ec 28             	sub    $0x28,%esp
801019e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801019e5:	68 20 1f 11 80       	push   $0x80111f20
801019ea:	e8 91 32 00 00       	call   80104c80 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801019f2:	83 c4 10             	add    $0x10,%esp
801019f5:	eb 1b                	jmp    80101a12 <iget+0x42>
801019f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a00:	39 3b                	cmp    %edi,(%ebx)
80101a02:	74 6c                	je     80101a70 <iget+0xa0>
80101a04:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a0a:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101a10:	73 26                	jae    80101a38 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a12:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101a15:	85 c9                	test   %ecx,%ecx
80101a17:	7f e7                	jg     80101a00 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a19:	85 f6                	test   %esi,%esi
80101a1b:	75 e7                	jne    80101a04 <iget+0x34>
80101a1d:	89 d8                	mov    %ebx,%eax
80101a1f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a25:	85 c9                	test   %ecx,%ecx
80101a27:	75 6e                	jne    80101a97 <iget+0xc7>
80101a29:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a2b:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101a31:	72 df                	jb     80101a12 <iget+0x42>
80101a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a37:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a38:	85 f6                	test   %esi,%esi
80101a3a:	74 73                	je     80101aaf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101a3c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101a3f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101a41:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101a44:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101a4b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101a52:	68 20 1f 11 80       	push   $0x80111f20
80101a57:	e8 e4 32 00 00       	call   80104d40 <release>

  return ip;
80101a5c:	83 c4 10             	add    $0x10,%esp
}
80101a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a62:	89 f0                	mov    %esi,%eax
80101a64:	5b                   	pop    %ebx
80101a65:	5e                   	pop    %esi
80101a66:	5f                   	pop    %edi
80101a67:	5d                   	pop    %ebp
80101a68:	c3                   	ret    
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a70:	39 53 04             	cmp    %edx,0x4(%ebx)
80101a73:	75 8f                	jne    80101a04 <iget+0x34>
      release(&icache.lock);
80101a75:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101a78:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101a7b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101a7d:	68 20 1f 11 80       	push   $0x80111f20
      ip->ref++;
80101a82:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101a85:	e8 b6 32 00 00       	call   80104d40 <release>
      return ip;
80101a8a:	83 c4 10             	add    $0x10,%esp
}
80101a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a90:	89 f0                	mov    %esi,%eax
80101a92:	5b                   	pop    %ebx
80101a93:	5e                   	pop    %esi
80101a94:	5f                   	pop    %edi
80101a95:	5d                   	pop    %ebp
80101a96:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a97:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101a9d:	73 10                	jae    80101aaf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a9f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101aa2:	85 c9                	test   %ecx,%ecx
80101aa4:	0f 8f 56 ff ff ff    	jg     80101a00 <iget+0x30>
80101aaa:	e9 6e ff ff ff       	jmp    80101a1d <iget+0x4d>
    panic("iget: no inodes");
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	68 28 79 10 80       	push   $0x80107928
80101ab7:	e8 d4 e8 ff ff       	call   80100390 <panic>
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	89 c6                	mov    %eax,%esi
80101ac7:	53                   	push   %ebx
80101ac8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101acb:	83 fa 0b             	cmp    $0xb,%edx
80101ace:	0f 86 84 00 00 00    	jbe    80101b58 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101ad4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101ad7:	83 fb 7f             	cmp    $0x7f,%ebx
80101ada:	0f 87 98 00 00 00    	ja     80101b78 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ae0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ae6:	8b 16                	mov    (%esi),%edx
80101ae8:	85 c0                	test   %eax,%eax
80101aea:	74 54                	je     80101b40 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101aec:	83 ec 08             	sub    $0x8,%esp
80101aef:	50                   	push   %eax
80101af0:	52                   	push   %edx
80101af1:	e8 da e5 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101af6:	83 c4 10             	add    $0x10,%esp
80101af9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101afd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101aff:	8b 1a                	mov    (%edx),%ebx
80101b01:	85 db                	test   %ebx,%ebx
80101b03:	74 1b                	je     80101b20 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101b05:	83 ec 0c             	sub    $0xc,%esp
80101b08:	57                   	push   %edi
80101b09:	e8 e2 e6 ff ff       	call   801001f0 <brelse>
    return addr;
80101b0e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b14:	89 d8                	mov    %ebx,%eax
80101b16:	5b                   	pop    %ebx
80101b17:	5e                   	pop    %esi
80101b18:	5f                   	pop    %edi
80101b19:	5d                   	pop    %ebp
80101b1a:	c3                   	ret    
80101b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b1f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101b20:	8b 06                	mov    (%esi),%eax
80101b22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101b25:	e8 96 fd ff ff       	call   801018c0 <balloc>
80101b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101b2d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101b30:	89 c3                	mov    %eax,%ebx
80101b32:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101b34:	57                   	push   %edi
80101b35:	e8 66 1a 00 00       	call   801035a0 <log_write>
80101b3a:	83 c4 10             	add    $0x10,%esp
80101b3d:	eb c6                	jmp    80101b05 <bmap+0x45>
80101b3f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b40:	89 d0                	mov    %edx,%eax
80101b42:	e8 79 fd ff ff       	call   801018c0 <balloc>
80101b47:	8b 16                	mov    (%esi),%edx
80101b49:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101b4f:	eb 9b                	jmp    80101aec <bmap+0x2c>
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101b58:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101b5b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101b5e:	85 db                	test   %ebx,%ebx
80101b60:	75 af                	jne    80101b11 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b62:	8b 00                	mov    (%eax),%eax
80101b64:	e8 57 fd ff ff       	call   801018c0 <balloc>
80101b69:	89 47 5c             	mov    %eax,0x5c(%edi)
80101b6c:	89 c3                	mov    %eax,%ebx
}
80101b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b71:	89 d8                	mov    %ebx,%eax
80101b73:	5b                   	pop    %ebx
80101b74:	5e                   	pop    %esi
80101b75:	5f                   	pop    %edi
80101b76:	5d                   	pop    %ebp
80101b77:	c3                   	ret    
  panic("bmap: out of range");
80101b78:	83 ec 0c             	sub    $0xc,%esp
80101b7b:	68 38 79 10 80       	push   $0x80107938
80101b80:	e8 0b e8 ff ff       	call   80100390 <panic>
80101b85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b90 <readsb>:
{
80101b90:	f3 0f 1e fb          	endbr32 
80101b94:	55                   	push   %ebp
80101b95:	89 e5                	mov    %esp,%ebp
80101b97:	56                   	push   %esi
80101b98:	53                   	push   %ebx
80101b99:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101b9c:	83 ec 08             	sub    $0x8,%esp
80101b9f:	6a 01                	push   $0x1
80101ba1:	ff 75 08             	pushl  0x8(%ebp)
80101ba4:	e8 27 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ba9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101bac:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101bae:	8d 40 5c             	lea    0x5c(%eax),%eax
80101bb1:	6a 1c                	push   $0x1c
80101bb3:	50                   	push   %eax
80101bb4:	56                   	push   %esi
80101bb5:	e8 76 32 00 00       	call   80104e30 <memmove>
  brelse(bp);
80101bba:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101bbd:	83 c4 10             	add    $0x10,%esp
}
80101bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bc3:	5b                   	pop    %ebx
80101bc4:	5e                   	pop    %esi
80101bc5:	5d                   	pop    %ebp
  brelse(bp);
80101bc6:	e9 25 e6 ff ff       	jmp    801001f0 <brelse>
80101bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bcf:	90                   	nop

80101bd0 <iinit>:
{
80101bd0:	f3 0f 1e fb          	endbr32 
80101bd4:	55                   	push   %ebp
80101bd5:	89 e5                	mov    %esp,%ebp
80101bd7:	53                   	push   %ebx
80101bd8:	bb 60 1f 11 80       	mov    $0x80111f60,%ebx
80101bdd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101be0:	68 4b 79 10 80       	push   $0x8010794b
80101be5:	68 20 1f 11 80       	push   $0x80111f20
80101bea:	e8 11 2f 00 00       	call   80104b00 <initlock>
  for(i = 0; i < NINODE; i++) {
80101bef:	83 c4 10             	add    $0x10,%esp
80101bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101bf8:	83 ec 08             	sub    $0x8,%esp
80101bfb:	68 52 79 10 80       	push   $0x80107952
80101c00:	53                   	push   %ebx
80101c01:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c07:	e8 b4 2d 00 00       	call   801049c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101c0c:	83 c4 10             	add    $0x10,%esp
80101c0f:	81 fb 80 3b 11 80    	cmp    $0x80113b80,%ebx
80101c15:	75 e1                	jne    80101bf8 <iinit+0x28>
  readsb(dev, &sb);
80101c17:	83 ec 08             	sub    $0x8,%esp
80101c1a:	68 00 1f 11 80       	push   $0x80111f00
80101c1f:	ff 75 08             	pushl  0x8(%ebp)
80101c22:	e8 69 ff ff ff       	call   80101b90 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101c27:	ff 35 18 1f 11 80    	pushl  0x80111f18
80101c2d:	ff 35 14 1f 11 80    	pushl  0x80111f14
80101c33:	ff 35 10 1f 11 80    	pushl  0x80111f10
80101c39:	ff 35 0c 1f 11 80    	pushl  0x80111f0c
80101c3f:	ff 35 08 1f 11 80    	pushl  0x80111f08
80101c45:	ff 35 04 1f 11 80    	pushl  0x80111f04
80101c4b:	ff 35 00 1f 11 80    	pushl  0x80111f00
80101c51:	68 b8 79 10 80       	push   $0x801079b8
80101c56:	e8 45 eb ff ff       	call   801007a0 <cprintf>
}
80101c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c5e:	83 c4 30             	add    $0x30,%esp
80101c61:	c9                   	leave  
80101c62:	c3                   	ret    
80101c63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <ialloc>:
{
80101c70:	f3 0f 1e fb          	endbr32 
80101c74:	55                   	push   %ebp
80101c75:	89 e5                	mov    %esp,%ebp
80101c77:	57                   	push   %edi
80101c78:	56                   	push   %esi
80101c79:	53                   	push   %ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
80101c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101c80:	83 3d 08 1f 11 80 01 	cmpl   $0x1,0x80111f08
{
80101c87:	8b 75 08             	mov    0x8(%ebp),%esi
80101c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101c8d:	0f 86 8d 00 00 00    	jbe    80101d20 <ialloc+0xb0>
80101c93:	bf 01 00 00 00       	mov    $0x1,%edi
80101c98:	eb 1d                	jmp    80101cb7 <ialloc+0x47>
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101ca3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101ca6:	53                   	push   %ebx
80101ca7:	e8 44 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101cac:	83 c4 10             	add    $0x10,%esp
80101caf:	3b 3d 08 1f 11 80    	cmp    0x80111f08,%edi
80101cb5:	73 69                	jae    80101d20 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101cb7:	89 f8                	mov    %edi,%eax
80101cb9:	83 ec 08             	sub    $0x8,%esp
80101cbc:	c1 e8 03             	shr    $0x3,%eax
80101cbf:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101cc5:	50                   	push   %eax
80101cc6:	56                   	push   %esi
80101cc7:	e8 04 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101ccc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101ccf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101cd1:	89 f8                	mov    %edi,%eax
80101cd3:	83 e0 07             	and    $0x7,%eax
80101cd6:	c1 e0 06             	shl    $0x6,%eax
80101cd9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101cdd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ce1:	75 bd                	jne    80101ca0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ce3:	83 ec 04             	sub    $0x4,%esp
80101ce6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ce9:	6a 40                	push   $0x40
80101ceb:	6a 00                	push   $0x0
80101ced:	51                   	push   %ecx
80101cee:	e8 9d 30 00 00       	call   80104d90 <memset>
      dip->type = type;
80101cf3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101cf7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cfa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101cfd:	89 1c 24             	mov    %ebx,(%esp)
80101d00:	e8 9b 18 00 00       	call   801035a0 <log_write>
      brelse(bp);
80101d05:	89 1c 24             	mov    %ebx,(%esp)
80101d08:	e8 e3 e4 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101d0d:	83 c4 10             	add    $0x10,%esp
}
80101d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101d13:	89 fa                	mov    %edi,%edx
}
80101d15:	5b                   	pop    %ebx
      return iget(dev, inum);
80101d16:	89 f0                	mov    %esi,%eax
}
80101d18:	5e                   	pop    %esi
80101d19:	5f                   	pop    %edi
80101d1a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101d1b:	e9 b0 fc ff ff       	jmp    801019d0 <iget>
  panic("ialloc: no inodes");
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	68 58 79 10 80       	push   $0x80107958
80101d28:	e8 63 e6 ff ff       	call   80100390 <panic>
80101d2d:	8d 76 00             	lea    0x0(%esi),%esi

80101d30 <iupdate>:
{
80101d30:	f3 0f 1e fb          	endbr32 
80101d34:	55                   	push   %ebp
80101d35:	89 e5                	mov    %esp,%ebp
80101d37:	56                   	push   %esi
80101d38:	53                   	push   %ebx
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d3c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d3f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d42:	83 ec 08             	sub    $0x8,%esp
80101d45:	c1 e8 03             	shr    $0x3,%eax
80101d48:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101d4e:	50                   	push   %eax
80101d4f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101d52:	e8 79 e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101d57:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d5b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d5e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d60:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101d63:	83 e0 07             	and    $0x7,%eax
80101d66:	c1 e0 06             	shl    $0x6,%eax
80101d69:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101d6d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101d70:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d74:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101d77:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101d7b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101d7f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101d83:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101d87:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101d8b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101d8e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d91:	6a 34                	push   $0x34
80101d93:	53                   	push   %ebx
80101d94:	50                   	push   %eax
80101d95:	e8 96 30 00 00       	call   80104e30 <memmove>
  log_write(bp);
80101d9a:	89 34 24             	mov    %esi,(%esp)
80101d9d:	e8 fe 17 00 00       	call   801035a0 <log_write>
  brelse(bp);
80101da2:	89 75 08             	mov    %esi,0x8(%ebp)
80101da5:	83 c4 10             	add    $0x10,%esp
}
80101da8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5d                   	pop    %ebp
  brelse(bp);
80101dae:	e9 3d e4 ff ff       	jmp    801001f0 <brelse>
80101db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101dc0 <idup>:
{
80101dc0:	f3 0f 1e fb          	endbr32 
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	53                   	push   %ebx
80101dc8:	83 ec 10             	sub    $0x10,%esp
80101dcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101dce:	68 20 1f 11 80       	push   $0x80111f20
80101dd3:	e8 a8 2e 00 00       	call   80104c80 <acquire>
  ip->ref++;
80101dd8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ddc:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101de3:	e8 58 2f 00 00       	call   80104d40 <release>
}
80101de8:	89 d8                	mov    %ebx,%eax
80101dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ded:	c9                   	leave  
80101dee:	c3                   	ret    
80101def:	90                   	nop

80101df0 <ilock>:
{
80101df0:	f3 0f 1e fb          	endbr32 
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	56                   	push   %esi
80101df8:	53                   	push   %ebx
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101dfc:	85 db                	test   %ebx,%ebx
80101dfe:	0f 84 b3 00 00 00    	je     80101eb7 <ilock+0xc7>
80101e04:	8b 53 08             	mov    0x8(%ebx),%edx
80101e07:	85 d2                	test   %edx,%edx
80101e09:	0f 8e a8 00 00 00    	jle    80101eb7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
80101e12:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e15:	50                   	push   %eax
80101e16:	e8 e5 2b 00 00       	call   80104a00 <acquiresleep>
  if(ip->valid == 0){
80101e1b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101e1e:	83 c4 10             	add    $0x10,%esp
80101e21:	85 c0                	test   %eax,%eax
80101e23:	74 0b                	je     80101e30 <ilock+0x40>
}
80101e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e28:	5b                   	pop    %ebx
80101e29:	5e                   	pop    %esi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e30:	8b 43 04             	mov    0x4(%ebx),%eax
80101e33:	83 ec 08             	sub    $0x8,%esp
80101e36:	c1 e8 03             	shr    $0x3,%eax
80101e39:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101e3f:	50                   	push   %eax
80101e40:	ff 33                	pushl  (%ebx)
80101e42:	e8 89 e2 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e47:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e4a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e4c:	8b 43 04             	mov    0x4(%ebx),%eax
80101e4f:	83 e0 07             	and    $0x7,%eax
80101e52:	c1 e0 06             	shl    $0x6,%eax
80101e55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101e59:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e5c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101e5f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101e63:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101e67:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101e6b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101e6f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101e73:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101e77:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101e7b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101e7e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e81:	6a 34                	push   $0x34
80101e83:	50                   	push   %eax
80101e84:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101e87:	50                   	push   %eax
80101e88:	e8 a3 2f 00 00       	call   80104e30 <memmove>
    brelse(bp);
80101e8d:	89 34 24             	mov    %esi,(%esp)
80101e90:	e8 5b e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101e95:	83 c4 10             	add    $0x10,%esp
80101e98:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101e9d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ea4:	0f 85 7b ff ff ff    	jne    80101e25 <ilock+0x35>
      panic("ilock: no type");
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	68 70 79 10 80       	push   $0x80107970
80101eb2:	e8 d9 e4 ff ff       	call   80100390 <panic>
    panic("ilock");
80101eb7:	83 ec 0c             	sub    $0xc,%esp
80101eba:	68 6a 79 10 80       	push   $0x8010796a
80101ebf:	e8 cc e4 ff ff       	call   80100390 <panic>
80101ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop

80101ed0 <iunlock>:
{
80101ed0:	f3 0f 1e fb          	endbr32 
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	56                   	push   %esi
80101ed8:	53                   	push   %ebx
80101ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101edc:	85 db                	test   %ebx,%ebx
80101ede:	74 28                	je     80101f08 <iunlock+0x38>
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ee6:	56                   	push   %esi
80101ee7:	e8 b4 2b 00 00       	call   80104aa0 <holdingsleep>
80101eec:	83 c4 10             	add    $0x10,%esp
80101eef:	85 c0                	test   %eax,%eax
80101ef1:	74 15                	je     80101f08 <iunlock+0x38>
80101ef3:	8b 43 08             	mov    0x8(%ebx),%eax
80101ef6:	85 c0                	test   %eax,%eax
80101ef8:	7e 0e                	jle    80101f08 <iunlock+0x38>
  releasesleep(&ip->lock);
80101efa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101efd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101f03:	e9 58 2b 00 00       	jmp    80104a60 <releasesleep>
    panic("iunlock");
80101f08:	83 ec 0c             	sub    $0xc,%esp
80101f0b:	68 7f 79 10 80       	push   $0x8010797f
80101f10:	e8 7b e4 ff ff       	call   80100390 <panic>
80101f15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f20 <iput>:
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
80101f2a:	83 ec 28             	sub    $0x28,%esp
80101f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101f30:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101f33:	57                   	push   %edi
80101f34:	e8 c7 2a 00 00       	call   80104a00 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f39:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101f3c:	83 c4 10             	add    $0x10,%esp
80101f3f:	85 d2                	test   %edx,%edx
80101f41:	74 07                	je     80101f4a <iput+0x2a>
80101f43:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101f48:	74 36                	je     80101f80 <iput+0x60>
  releasesleep(&ip->lock);
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	57                   	push   %edi
80101f4e:	e8 0d 2b 00 00       	call   80104a60 <releasesleep>
  acquire(&icache.lock);
80101f53:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101f5a:	e8 21 2d 00 00       	call   80104c80 <acquire>
  ip->ref--;
80101f5f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c7 45 08 20 1f 11 80 	movl   $0x80111f20,0x8(%ebp)
}
80101f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
  release(&icache.lock);
80101f74:	e9 c7 2d 00 00       	jmp    80104d40 <release>
80101f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	68 20 1f 11 80       	push   $0x80111f20
80101f88:	e8 f3 2c 00 00       	call   80104c80 <acquire>
    int r = ip->ref;
80101f8d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101f90:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101f97:	e8 a4 2d 00 00       	call   80104d40 <release>
    if(r == 1){
80101f9c:	83 c4 10             	add    $0x10,%esp
80101f9f:	83 fe 01             	cmp    $0x1,%esi
80101fa2:	75 a6                	jne    80101f4a <iput+0x2a>
80101fa4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101faa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101fad:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101fb0:	89 cf                	mov    %ecx,%edi
80101fb2:	eb 0b                	jmp    80101fbf <iput+0x9f>
80101fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101fb8:	83 c6 04             	add    $0x4,%esi
80101fbb:	39 fe                	cmp    %edi,%esi
80101fbd:	74 19                	je     80101fd8 <iput+0xb8>
    if(ip->addrs[i]){
80101fbf:	8b 16                	mov    (%esi),%edx
80101fc1:	85 d2                	test   %edx,%edx
80101fc3:	74 f3                	je     80101fb8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101fc5:	8b 03                	mov    (%ebx),%eax
80101fc7:	e8 74 f8 ff ff       	call   80101840 <bfree>
      ip->addrs[i] = 0;
80101fcc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101fd2:	eb e4                	jmp    80101fb8 <iput+0x98>
80101fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101fd8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101fde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fe1:	85 c0                	test   %eax,%eax
80101fe3:	75 33                	jne    80102018 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101fe5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101fe8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101fef:	53                   	push   %ebx
80101ff0:	e8 3b fd ff ff       	call   80101d30 <iupdate>
      ip->type = 0;
80101ff5:	31 c0                	xor    %eax,%eax
80101ff7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ffb:	89 1c 24             	mov    %ebx,(%esp)
80101ffe:	e8 2d fd ff ff       	call   80101d30 <iupdate>
      ip->valid = 0;
80102003:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010200a:	83 c4 10             	add    $0x10,%esp
8010200d:	e9 38 ff ff ff       	jmp    80101f4a <iput+0x2a>
80102012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102018:	83 ec 08             	sub    $0x8,%esp
8010201b:	50                   	push   %eax
8010201c:	ff 33                	pushl  (%ebx)
8010201e:	e8 ad e0 ff ff       	call   801000d0 <bread>
80102023:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102026:	83 c4 10             	add    $0x10,%esp
80102029:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010202f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102032:	8d 70 5c             	lea    0x5c(%eax),%esi
80102035:	89 cf                	mov    %ecx,%edi
80102037:	eb 0e                	jmp    80102047 <iput+0x127>
80102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102040:	83 c6 04             	add    $0x4,%esi
80102043:	39 f7                	cmp    %esi,%edi
80102045:	74 19                	je     80102060 <iput+0x140>
      if(a[j])
80102047:	8b 16                	mov    (%esi),%edx
80102049:	85 d2                	test   %edx,%edx
8010204b:	74 f3                	je     80102040 <iput+0x120>
        bfree(ip->dev, a[j]);
8010204d:	8b 03                	mov    (%ebx),%eax
8010204f:	e8 ec f7 ff ff       	call   80101840 <bfree>
80102054:	eb ea                	jmp    80102040 <iput+0x120>
80102056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	ff 75 e4             	pushl  -0x1c(%ebp)
80102066:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102069:	e8 82 e1 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010206e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102074:	8b 03                	mov    (%ebx),%eax
80102076:	e8 c5 f7 ff ff       	call   80101840 <bfree>
    ip->addrs[NDIRECT] = 0;
8010207b:	83 c4 10             	add    $0x10,%esp
8010207e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102085:	00 00 00 
80102088:	e9 58 ff ff ff       	jmp    80101fe5 <iput+0xc5>
8010208d:	8d 76 00             	lea    0x0(%esi),%esi

80102090 <iunlockput>:
{
80102090:	f3 0f 1e fb          	endbr32 
80102094:	55                   	push   %ebp
80102095:	89 e5                	mov    %esp,%ebp
80102097:	53                   	push   %ebx
80102098:	83 ec 10             	sub    $0x10,%esp
8010209b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010209e:	53                   	push   %ebx
8010209f:	e8 2c fe ff ff       	call   80101ed0 <iunlock>
  iput(ip);
801020a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801020a7:	83 c4 10             	add    $0x10,%esp
}
801020aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020ad:	c9                   	leave  
  iput(ip);
801020ae:	e9 6d fe ff ff       	jmp    80101f20 <iput>
801020b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801020c0:	f3 0f 1e fb          	endbr32 
801020c4:	55                   	push   %ebp
801020c5:	89 e5                	mov    %esp,%ebp
801020c7:	8b 55 08             	mov    0x8(%ebp),%edx
801020ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801020cd:	8b 0a                	mov    (%edx),%ecx
801020cf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801020d2:	8b 4a 04             	mov    0x4(%edx),%ecx
801020d5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801020d8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801020dc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801020df:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801020e3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801020e7:	8b 52 58             	mov    0x58(%edx),%edx
801020ea:	89 50 10             	mov    %edx,0x10(%eax)
}
801020ed:	5d                   	pop    %ebp
801020ee:	c3                   	ret    
801020ef:	90                   	nop

801020f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020f0:	f3 0f 1e fb          	endbr32 
801020f4:	55                   	push   %ebp
801020f5:	89 e5                	mov    %esp,%ebp
801020f7:	57                   	push   %edi
801020f8:	56                   	push   %esi
801020f9:	53                   	push   %ebx
801020fa:	83 ec 1c             	sub    $0x1c,%esp
801020fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102100:	8b 45 08             	mov    0x8(%ebp),%eax
80102103:	8b 75 10             	mov    0x10(%ebp),%esi
80102106:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102109:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010210c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102111:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102114:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102117:	0f 84 a3 00 00 00    	je     801021c0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010211d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102120:	8b 40 58             	mov    0x58(%eax),%eax
80102123:	39 c6                	cmp    %eax,%esi
80102125:	0f 87 b6 00 00 00    	ja     801021e1 <readi+0xf1>
8010212b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010212e:	31 c9                	xor    %ecx,%ecx
80102130:	89 da                	mov    %ebx,%edx
80102132:	01 f2                	add    %esi,%edx
80102134:	0f 92 c1             	setb   %cl
80102137:	89 cf                	mov    %ecx,%edi
80102139:	0f 82 a2 00 00 00    	jb     801021e1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010213f:	89 c1                	mov    %eax,%ecx
80102141:	29 f1                	sub    %esi,%ecx
80102143:	39 d0                	cmp    %edx,%eax
80102145:	0f 43 cb             	cmovae %ebx,%ecx
80102148:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010214b:	85 c9                	test   %ecx,%ecx
8010214d:	74 63                	je     801021b2 <readi+0xc2>
8010214f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102150:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102153:	89 f2                	mov    %esi,%edx
80102155:	c1 ea 09             	shr    $0x9,%edx
80102158:	89 d8                	mov    %ebx,%eax
8010215a:	e8 61 f9 ff ff       	call   80101ac0 <bmap>
8010215f:	83 ec 08             	sub    $0x8,%esp
80102162:	50                   	push   %eax
80102163:	ff 33                	pushl  (%ebx)
80102165:	e8 66 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010216a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010216d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102172:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102175:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102177:	89 f0                	mov    %esi,%eax
80102179:	25 ff 01 00 00       	and    $0x1ff,%eax
8010217e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102180:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102183:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102185:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102189:	39 d9                	cmp    %ebx,%ecx
8010218b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010218e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010218f:	01 df                	add    %ebx,%edi
80102191:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102193:	50                   	push   %eax
80102194:	ff 75 e0             	pushl  -0x20(%ebp)
80102197:	e8 94 2c 00 00       	call   80104e30 <memmove>
    brelse(bp);
8010219c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010219f:	89 14 24             	mov    %edx,(%esp)
801021a2:	e8 49 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021a7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801021aa:	83 c4 10             	add    $0x10,%esp
801021ad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801021b0:	77 9e                	ja     80102150 <readi+0x60>
  }
  return n;
801021b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801021b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b8:	5b                   	pop    %ebx
801021b9:	5e                   	pop    %esi
801021ba:	5f                   	pop    %edi
801021bb:	5d                   	pop    %ebp
801021bc:	c3                   	ret    
801021bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801021c0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801021c4:	66 83 f8 09          	cmp    $0x9,%ax
801021c8:	77 17                	ja     801021e1 <readi+0xf1>
801021ca:	8b 04 c5 a0 1e 11 80 	mov    -0x7feee160(,%eax,8),%eax
801021d1:	85 c0                	test   %eax,%eax
801021d3:	74 0c                	je     801021e1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801021d5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021db:	5b                   	pop    %ebx
801021dc:	5e                   	pop    %esi
801021dd:	5f                   	pop    %edi
801021de:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801021df:	ff e0                	jmp    *%eax
      return -1;
801021e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e6:	eb cd                	jmp    801021b5 <readi+0xc5>
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 1c             	sub    $0x1c,%esp
801021fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102200:	8b 75 0c             	mov    0xc(%ebp),%esi
80102203:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102206:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010220b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010220e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102211:	8b 75 10             	mov    0x10(%ebp),%esi
80102214:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102217:	0f 84 b3 00 00 00    	je     801022d0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010221d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102220:	39 70 58             	cmp    %esi,0x58(%eax)
80102223:	0f 82 e3 00 00 00    	jb     8010230c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102229:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010222c:	89 f8                	mov    %edi,%eax
8010222e:	01 f0                	add    %esi,%eax
80102230:	0f 82 d6 00 00 00    	jb     8010230c <writei+0x11c>
80102236:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010223b:	0f 87 cb 00 00 00    	ja     8010230c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102241:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102248:	85 ff                	test   %edi,%edi
8010224a:	74 75                	je     801022c1 <writei+0xd1>
8010224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102250:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102253:	89 f2                	mov    %esi,%edx
80102255:	c1 ea 09             	shr    $0x9,%edx
80102258:	89 f8                	mov    %edi,%eax
8010225a:	e8 61 f8 ff ff       	call   80101ac0 <bmap>
8010225f:	83 ec 08             	sub    $0x8,%esp
80102262:	50                   	push   %eax
80102263:	ff 37                	pushl  (%edi)
80102265:	e8 66 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010226a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010226f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102272:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102275:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102277:	89 f0                	mov    %esi,%eax
80102279:	83 c4 0c             	add    $0xc,%esp
8010227c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102281:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102283:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102287:	39 d9                	cmp    %ebx,%ecx
80102289:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010228c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010228d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010228f:	ff 75 dc             	pushl  -0x24(%ebp)
80102292:	50                   	push   %eax
80102293:	e8 98 2b 00 00       	call   80104e30 <memmove>
    log_write(bp);
80102298:	89 3c 24             	mov    %edi,(%esp)
8010229b:	e8 00 13 00 00       	call   801035a0 <log_write>
    brelse(bp);
801022a0:	89 3c 24             	mov    %edi,(%esp)
801022a3:	e8 48 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022a8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022b1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801022b4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801022b7:	77 97                	ja     80102250 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801022b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801022bc:	3b 70 58             	cmp    0x58(%eax),%esi
801022bf:	77 37                	ja     801022f8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801022c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801022c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c7:	5b                   	pop    %ebx
801022c8:	5e                   	pop    %esi
801022c9:	5f                   	pop    %edi
801022ca:	5d                   	pop    %ebp
801022cb:	c3                   	ret    
801022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801022d0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801022d4:	66 83 f8 09          	cmp    $0x9,%ax
801022d8:	77 32                	ja     8010230c <writei+0x11c>
801022da:	8b 04 c5 a4 1e 11 80 	mov    -0x7feee15c(,%eax,8),%eax
801022e1:	85 c0                	test   %eax,%eax
801022e3:	74 27                	je     8010230c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801022e5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801022e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022eb:	5b                   	pop    %ebx
801022ec:	5e                   	pop    %esi
801022ed:	5f                   	pop    %edi
801022ee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801022ef:	ff e0                	jmp    *%eax
801022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801022f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801022fb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801022fe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102301:	50                   	push   %eax
80102302:	e8 29 fa ff ff       	call   80101d30 <iupdate>
80102307:	83 c4 10             	add    $0x10,%esp
8010230a:	eb b5                	jmp    801022c1 <writei+0xd1>
      return -1;
8010230c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102311:	eb b1                	jmp    801022c4 <writei+0xd4>
80102313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102320 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102320:	f3 0f 1e fb          	endbr32 
80102324:	55                   	push   %ebp
80102325:	89 e5                	mov    %esp,%ebp
80102327:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010232a:	6a 0e                	push   $0xe
8010232c:	ff 75 0c             	pushl  0xc(%ebp)
8010232f:	ff 75 08             	pushl  0x8(%ebp)
80102332:	e8 69 2b 00 00       	call   80104ea0 <strncmp>
}
80102337:	c9                   	leave  
80102338:	c3                   	ret    
80102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102340 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102340:	f3 0f 1e fb          	endbr32 
80102344:	55                   	push   %ebp
80102345:	89 e5                	mov    %esp,%ebp
80102347:	57                   	push   %edi
80102348:	56                   	push   %esi
80102349:	53                   	push   %ebx
8010234a:	83 ec 1c             	sub    $0x1c,%esp
8010234d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102350:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102355:	0f 85 89 00 00 00    	jne    801023e4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010235b:	8b 53 58             	mov    0x58(%ebx),%edx
8010235e:	31 ff                	xor    %edi,%edi
80102360:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102363:	85 d2                	test   %edx,%edx
80102365:	74 42                	je     801023a9 <dirlookup+0x69>
80102367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102370:	6a 10                	push   $0x10
80102372:	57                   	push   %edi
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
80102375:	e8 76 fd ff ff       	call   801020f0 <readi>
8010237a:	83 c4 10             	add    $0x10,%esp
8010237d:	83 f8 10             	cmp    $0x10,%eax
80102380:	75 55                	jne    801023d7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102382:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102387:	74 18                	je     801023a1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102389:	83 ec 04             	sub    $0x4,%esp
8010238c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010238f:	6a 0e                	push   $0xe
80102391:	50                   	push   %eax
80102392:	ff 75 0c             	pushl  0xc(%ebp)
80102395:	e8 06 2b 00 00       	call   80104ea0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010239a:	83 c4 10             	add    $0x10,%esp
8010239d:	85 c0                	test   %eax,%eax
8010239f:	74 17                	je     801023b8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023a1:	83 c7 10             	add    $0x10,%edi
801023a4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023a7:	72 c7                	jb     80102370 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801023a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801023ac:	31 c0                	xor    %eax,%eax
}
801023ae:	5b                   	pop    %ebx
801023af:	5e                   	pop    %esi
801023b0:	5f                   	pop    %edi
801023b1:	5d                   	pop    %ebp
801023b2:	c3                   	ret    
801023b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023b7:	90                   	nop
      if(poff)
801023b8:	8b 45 10             	mov    0x10(%ebp),%eax
801023bb:	85 c0                	test   %eax,%eax
801023bd:	74 05                	je     801023c4 <dirlookup+0x84>
        *poff = off;
801023bf:	8b 45 10             	mov    0x10(%ebp),%eax
801023c2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801023c4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801023c8:	8b 03                	mov    (%ebx),%eax
801023ca:	e8 01 f6 ff ff       	call   801019d0 <iget>
}
801023cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023d2:	5b                   	pop    %ebx
801023d3:	5e                   	pop    %esi
801023d4:	5f                   	pop    %edi
801023d5:	5d                   	pop    %ebp
801023d6:	c3                   	ret    
      panic("dirlookup read");
801023d7:	83 ec 0c             	sub    $0xc,%esp
801023da:	68 99 79 10 80       	push   $0x80107999
801023df:	e8 ac df ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801023e4:	83 ec 0c             	sub    $0xc,%esp
801023e7:	68 87 79 10 80       	push   $0x80107987
801023ec:	e8 9f df ff ff       	call   80100390 <panic>
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop

80102400 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	57                   	push   %edi
80102404:	56                   	push   %esi
80102405:	53                   	push   %ebx
80102406:	89 c3                	mov    %eax,%ebx
80102408:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010240b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010240e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102411:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102414:	0f 84 86 01 00 00    	je     801025a0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010241a:	e8 d1 1b 00 00       	call   80103ff0 <myproc>
  acquire(&icache.lock);
8010241f:	83 ec 0c             	sub    $0xc,%esp
80102422:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102424:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102427:	68 20 1f 11 80       	push   $0x80111f20
8010242c:	e8 4f 28 00 00       	call   80104c80 <acquire>
  ip->ref++;
80102431:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102435:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
8010243c:	e8 ff 28 00 00       	call   80104d40 <release>
80102441:	83 c4 10             	add    $0x10,%esp
80102444:	eb 0d                	jmp    80102453 <namex+0x53>
80102446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102450:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102453:	0f b6 07             	movzbl (%edi),%eax
80102456:	3c 2f                	cmp    $0x2f,%al
80102458:	74 f6                	je     80102450 <namex+0x50>
  if(*path == 0)
8010245a:	84 c0                	test   %al,%al
8010245c:	0f 84 ee 00 00 00    	je     80102550 <namex+0x150>
  while(*path != '/' && *path != 0)
80102462:	0f b6 07             	movzbl (%edi),%eax
80102465:	84 c0                	test   %al,%al
80102467:	0f 84 fb 00 00 00    	je     80102568 <namex+0x168>
8010246d:	89 fb                	mov    %edi,%ebx
8010246f:	3c 2f                	cmp    $0x2f,%al
80102471:	0f 84 f1 00 00 00    	je     80102568 <namex+0x168>
80102477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247e:	66 90                	xchg   %ax,%ax
80102480:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102484:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102487:	3c 2f                	cmp    $0x2f,%al
80102489:	74 04                	je     8010248f <namex+0x8f>
8010248b:	84 c0                	test   %al,%al
8010248d:	75 f1                	jne    80102480 <namex+0x80>
  len = path - s;
8010248f:	89 d8                	mov    %ebx,%eax
80102491:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102493:	83 f8 0d             	cmp    $0xd,%eax
80102496:	0f 8e 84 00 00 00    	jle    80102520 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010249c:	83 ec 04             	sub    $0x4,%esp
8010249f:	6a 0e                	push   $0xe
801024a1:	57                   	push   %edi
    path++;
801024a2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801024a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801024a7:	e8 84 29 00 00       	call   80104e30 <memmove>
801024ac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801024af:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801024b2:	75 0c                	jne    801024c0 <namex+0xc0>
801024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801024b8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801024bb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801024be:	74 f8                	je     801024b8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	56                   	push   %esi
801024c4:	e8 27 f9 ff ff       	call   80101df0 <ilock>
    if(ip->type != T_DIR){
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801024d1:	0f 85 a1 00 00 00    	jne    80102578 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801024d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801024da:	85 d2                	test   %edx,%edx
801024dc:	74 09                	je     801024e7 <namex+0xe7>
801024de:	80 3f 00             	cmpb   $0x0,(%edi)
801024e1:	0f 84 d9 00 00 00    	je     801025c0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	6a 00                	push   $0x0
801024ec:	ff 75 e4             	pushl  -0x1c(%ebp)
801024ef:	56                   	push   %esi
801024f0:	e8 4b fe ff ff       	call   80102340 <dirlookup>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	89 c3                	mov    %eax,%ebx
801024fa:	85 c0                	test   %eax,%eax
801024fc:	74 7a                	je     80102578 <namex+0x178>
  iunlock(ip);
801024fe:	83 ec 0c             	sub    $0xc,%esp
80102501:	56                   	push   %esi
80102502:	e8 c9 f9 ff ff       	call   80101ed0 <iunlock>
  iput(ip);
80102507:	89 34 24             	mov    %esi,(%esp)
8010250a:	89 de                	mov    %ebx,%esi
8010250c:	e8 0f fa ff ff       	call   80101f20 <iput>
80102511:	83 c4 10             	add    $0x10,%esp
80102514:	e9 3a ff ff ff       	jmp    80102453 <namex+0x53>
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102523:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102526:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102529:	83 ec 04             	sub    $0x4,%esp
8010252c:	50                   	push   %eax
8010252d:	57                   	push   %edi
    name[len] = 0;
8010252e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102530:	ff 75 e4             	pushl  -0x1c(%ebp)
80102533:	e8 f8 28 00 00       	call   80104e30 <memmove>
    name[len] = 0;
80102538:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010253b:	83 c4 10             	add    $0x10,%esp
8010253e:	c6 00 00             	movb   $0x0,(%eax)
80102541:	e9 69 ff ff ff       	jmp    801024af <namex+0xaf>
80102546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102550:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102553:	85 c0                	test   %eax,%eax
80102555:	0f 85 85 00 00 00    	jne    801025e0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010255b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010255e:	89 f0                	mov    %esi,%eax
80102560:	5b                   	pop    %ebx
80102561:	5e                   	pop    %esi
80102562:	5f                   	pop    %edi
80102563:	5d                   	pop    %ebp
80102564:	c3                   	ret    
80102565:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010256b:	89 fb                	mov    %edi,%ebx
8010256d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102570:	31 c0                	xor    %eax,%eax
80102572:	eb b5                	jmp    80102529 <namex+0x129>
80102574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	56                   	push   %esi
8010257c:	e8 4f f9 ff ff       	call   80101ed0 <iunlock>
  iput(ip);
80102581:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102584:	31 f6                	xor    %esi,%esi
  iput(ip);
80102586:	e8 95 f9 ff ff       	call   80101f20 <iput>
      return 0;
8010258b:	83 c4 10             	add    $0x10,%esp
}
8010258e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102591:	89 f0                	mov    %esi,%eax
80102593:	5b                   	pop    %ebx
80102594:	5e                   	pop    %esi
80102595:	5f                   	pop    %edi
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801025a0:	ba 01 00 00 00       	mov    $0x1,%edx
801025a5:	b8 01 00 00 00       	mov    $0x1,%eax
801025aa:	89 df                	mov    %ebx,%edi
801025ac:	e8 1f f4 ff ff       	call   801019d0 <iget>
801025b1:	89 c6                	mov    %eax,%esi
801025b3:	e9 9b fe ff ff       	jmp    80102453 <namex+0x53>
801025b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop
      iunlock(ip);
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	56                   	push   %esi
801025c4:	e8 07 f9 ff ff       	call   80101ed0 <iunlock>
      return ip;
801025c9:	83 c4 10             	add    $0x10,%esp
}
801025cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025cf:	89 f0                	mov    %esi,%eax
801025d1:	5b                   	pop    %ebx
801025d2:	5e                   	pop    %esi
801025d3:	5f                   	pop    %edi
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
801025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	56                   	push   %esi
    return 0;
801025e4:	31 f6                	xor    %esi,%esi
    iput(ip);
801025e6:	e8 35 f9 ff ff       	call   80101f20 <iput>
    return 0;
801025eb:	83 c4 10             	add    $0x10,%esp
801025ee:	e9 68 ff ff ff       	jmp    8010255b <namex+0x15b>
801025f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102600 <dirlink>:
{
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	57                   	push   %edi
80102608:	56                   	push   %esi
80102609:	53                   	push   %ebx
8010260a:	83 ec 20             	sub    $0x20,%esp
8010260d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102610:	6a 00                	push   $0x0
80102612:	ff 75 0c             	pushl  0xc(%ebp)
80102615:	53                   	push   %ebx
80102616:	e8 25 fd ff ff       	call   80102340 <dirlookup>
8010261b:	83 c4 10             	add    $0x10,%esp
8010261e:	85 c0                	test   %eax,%eax
80102620:	75 6b                	jne    8010268d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102622:	8b 7b 58             	mov    0x58(%ebx),%edi
80102625:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102628:	85 ff                	test   %edi,%edi
8010262a:	74 2d                	je     80102659 <dirlink+0x59>
8010262c:	31 ff                	xor    %edi,%edi
8010262e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102631:	eb 0d                	jmp    80102640 <dirlink+0x40>
80102633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102637:	90                   	nop
80102638:	83 c7 10             	add    $0x10,%edi
8010263b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010263e:	73 19                	jae    80102659 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102640:	6a 10                	push   $0x10
80102642:	57                   	push   %edi
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
80102645:	e8 a6 fa ff ff       	call   801020f0 <readi>
8010264a:	83 c4 10             	add    $0x10,%esp
8010264d:	83 f8 10             	cmp    $0x10,%eax
80102650:	75 4e                	jne    801026a0 <dirlink+0xa0>
    if(de.inum == 0)
80102652:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102657:	75 df                	jne    80102638 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102659:	83 ec 04             	sub    $0x4,%esp
8010265c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010265f:	6a 0e                	push   $0xe
80102661:	ff 75 0c             	pushl  0xc(%ebp)
80102664:	50                   	push   %eax
80102665:	e8 86 28 00 00       	call   80104ef0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010266a:	6a 10                	push   $0x10
  de.inum = inum;
8010266c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010266f:	57                   	push   %edi
80102670:	56                   	push   %esi
80102671:	53                   	push   %ebx
  de.inum = inum;
80102672:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102676:	e8 75 fb ff ff       	call   801021f0 <writei>
8010267b:	83 c4 20             	add    $0x20,%esp
8010267e:	83 f8 10             	cmp    $0x10,%eax
80102681:	75 2a                	jne    801026ad <dirlink+0xad>
  return 0;
80102683:	31 c0                	xor    %eax,%eax
}
80102685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102688:	5b                   	pop    %ebx
80102689:	5e                   	pop    %esi
8010268a:	5f                   	pop    %edi
8010268b:	5d                   	pop    %ebp
8010268c:	c3                   	ret    
    iput(ip);
8010268d:	83 ec 0c             	sub    $0xc,%esp
80102690:	50                   	push   %eax
80102691:	e8 8a f8 ff ff       	call   80101f20 <iput>
    return -1;
80102696:	83 c4 10             	add    $0x10,%esp
80102699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010269e:	eb e5                	jmp    80102685 <dirlink+0x85>
      panic("dirlink read");
801026a0:	83 ec 0c             	sub    $0xc,%esp
801026a3:	68 a8 79 10 80       	push   $0x801079a8
801026a8:	e8 e3 dc ff ff       	call   80100390 <panic>
    panic("dirlink");
801026ad:	83 ec 0c             	sub    $0xc,%esp
801026b0:	68 8e 7f 10 80       	push   $0x80107f8e
801026b5:	e8 d6 dc ff ff       	call   80100390 <panic>
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026c0 <namei>:

struct inode*
namei(char *path)
{
801026c0:	f3 0f 1e fb          	endbr32 
801026c4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801026c5:	31 d2                	xor    %edx,%edx
{
801026c7:	89 e5                	mov    %esp,%ebp
801026c9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801026cc:	8b 45 08             	mov    0x8(%ebp),%eax
801026cf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801026d2:	e8 29 fd ff ff       	call   80102400 <namex>
}
801026d7:	c9                   	leave  
801026d8:	c3                   	ret    
801026d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026e0:	f3 0f 1e fb          	endbr32 
801026e4:	55                   	push   %ebp
  return namex(path, 1, name);
801026e5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801026ea:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801026ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
801026f2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801026f3:	e9 08 fd ff ff       	jmp    80102400 <namex>
801026f8:	66 90                	xchg   %ax,%ax
801026fa:	66 90                	xchg   %ax,%ax
801026fc:	66 90                	xchg   %ax,%ax
801026fe:	66 90                	xchg   %ax,%ax

80102700 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	57                   	push   %edi
80102704:	56                   	push   %esi
80102705:	53                   	push   %ebx
80102706:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102709:	85 c0                	test   %eax,%eax
8010270b:	0f 84 b4 00 00 00    	je     801027c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102711:	8b 70 08             	mov    0x8(%eax),%esi
80102714:	89 c3                	mov    %eax,%ebx
80102716:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010271c:	0f 87 96 00 00 00    	ja     801027b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102722:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272e:	66 90                	xchg   %ax,%ax
80102730:	89 ca                	mov    %ecx,%edx
80102732:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102733:	83 e0 c0             	and    $0xffffffc0,%eax
80102736:	3c 40                	cmp    $0x40,%al
80102738:	75 f6                	jne    80102730 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010273a:	31 ff                	xor    %edi,%edi
8010273c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102741:	89 f8                	mov    %edi,%eax
80102743:	ee                   	out    %al,(%dx)
80102744:	b8 01 00 00 00       	mov    $0x1,%eax
80102749:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010274e:	ee                   	out    %al,(%dx)
8010274f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102754:	89 f0                	mov    %esi,%eax
80102756:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102757:	89 f0                	mov    %esi,%eax
80102759:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010275e:	c1 f8 08             	sar    $0x8,%eax
80102761:	ee                   	out    %al,(%dx)
80102762:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102767:	89 f8                	mov    %edi,%eax
80102769:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010276a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010276e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102773:	c1 e0 04             	shl    $0x4,%eax
80102776:	83 e0 10             	and    $0x10,%eax
80102779:	83 c8 e0             	or     $0xffffffe0,%eax
8010277c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010277d:	f6 03 04             	testb  $0x4,(%ebx)
80102780:	75 16                	jne    80102798 <idestart+0x98>
80102782:	b8 20 00 00 00       	mov    $0x20,%eax
80102787:	89 ca                	mov    %ecx,%edx
80102789:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010278a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010278d:	5b                   	pop    %ebx
8010278e:	5e                   	pop    %esi
8010278f:	5f                   	pop    %edi
80102790:	5d                   	pop    %ebp
80102791:	c3                   	ret    
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102798:	b8 30 00 00 00       	mov    $0x30,%eax
8010279d:	89 ca                	mov    %ecx,%edx
8010279f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801027a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801027a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801027a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027ad:	fc                   	cld    
801027ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801027b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027b3:	5b                   	pop    %ebx
801027b4:	5e                   	pop    %esi
801027b5:	5f                   	pop    %edi
801027b6:	5d                   	pop    %ebp
801027b7:	c3                   	ret    
    panic("incorrect blockno");
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	68 14 7a 10 80       	push   $0x80107a14
801027c0:	e8 cb db ff ff       	call   80100390 <panic>
    panic("idestart");
801027c5:	83 ec 0c             	sub    $0xc,%esp
801027c8:	68 0b 7a 10 80       	push   $0x80107a0b
801027cd:	e8 be db ff ff       	call   80100390 <panic>
801027d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027e0 <ideinit>:
{
801027e0:	f3 0f 1e fb          	endbr32 
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801027ea:	68 26 7a 10 80       	push   $0x80107a26
801027ef:	68 c0 b5 10 80       	push   $0x8010b5c0
801027f4:	e8 07 23 00 00       	call   80104b00 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801027f9:	58                   	pop    %eax
801027fa:	a1 40 42 11 80       	mov    0x80114240,%eax
801027ff:	5a                   	pop    %edx
80102800:	83 e8 01             	sub    $0x1,%eax
80102803:	50                   	push   %eax
80102804:	6a 0e                	push   $0xe
80102806:	e8 b5 02 00 00       	call   80102ac0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010280b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102817:	90                   	nop
80102818:	ec                   	in     (%dx),%al
80102819:	83 e0 c0             	and    $0xffffffc0,%eax
8010281c:	3c 40                	cmp    $0x40,%al
8010281e:	75 f8                	jne    80102818 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102820:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102825:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010282a:	ee                   	out    %al,(%dx)
8010282b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102830:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102835:	eb 0e                	jmp    80102845 <ideinit+0x65>
80102837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102840:	83 e9 01             	sub    $0x1,%ecx
80102843:	74 0f                	je     80102854 <ideinit+0x74>
80102845:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102846:	84 c0                	test   %al,%al
80102848:	74 f6                	je     80102840 <ideinit+0x60>
      havedisk1 = 1;
8010284a:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
80102851:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102854:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102859:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010285e:	ee                   	out    %al,(%dx)
}
8010285f:	c9                   	leave  
80102860:	c3                   	ret    
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102870:	f3 0f 1e fb          	endbr32 
80102874:	55                   	push   %ebp
80102875:	89 e5                	mov    %esp,%ebp
80102877:	57                   	push   %edi
80102878:	56                   	push   %esi
80102879:	53                   	push   %ebx
8010287a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010287d:	68 c0 b5 10 80       	push   $0x8010b5c0
80102882:	e8 f9 23 00 00       	call   80104c80 <acquire>

  if((b = idequeue) == 0){
80102887:	8b 1d a4 b5 10 80    	mov    0x8010b5a4,%ebx
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	85 db                	test   %ebx,%ebx
80102892:	74 5f                	je     801028f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102894:	8b 43 58             	mov    0x58(%ebx),%eax
80102897:	a3 a4 b5 10 80       	mov    %eax,0x8010b5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010289c:	8b 33                	mov    (%ebx),%esi
8010289e:	f7 c6 04 00 00 00    	test   $0x4,%esi
801028a4:	75 2b                	jne    801028d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop
801028b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028b1:	89 c1                	mov    %eax,%ecx
801028b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801028b6:	80 f9 40             	cmp    $0x40,%cl
801028b9:	75 f5                	jne    801028b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028bb:	a8 21                	test   $0x21,%al
801028bd:	75 12                	jne    801028d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801028bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801028c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801028c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801028cc:	fc                   	cld    
801028cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801028cf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801028d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801028d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801028d7:	83 ce 02             	or     $0x2,%esi
801028da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801028dc:	53                   	push   %ebx
801028dd:	e8 8e 1e 00 00       	call   80104770 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028e2:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	85 c0                	test   %eax,%eax
801028ec:	74 05                	je     801028f3 <ideintr+0x83>
    idestart(idequeue);
801028ee:	e8 0d fe ff ff       	call   80102700 <idestart>
    release(&idelock);
801028f3:	83 ec 0c             	sub    $0xc,%esp
801028f6:	68 c0 b5 10 80       	push   $0x8010b5c0
801028fb:	e8 40 24 00 00       	call   80104d40 <release>

  release(&idelock);
}
80102900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102903:	5b                   	pop    %ebx
80102904:	5e                   	pop    %esi
80102905:	5f                   	pop    %edi
80102906:	5d                   	pop    %ebp
80102907:	c3                   	ret    
80102908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
80102915:	89 e5                	mov    %esp,%ebp
80102917:	53                   	push   %ebx
80102918:	83 ec 10             	sub    $0x10,%esp
8010291b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010291e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102921:	50                   	push   %eax
80102922:	e8 79 21 00 00       	call   80104aa0 <holdingsleep>
80102927:	83 c4 10             	add    $0x10,%esp
8010292a:	85 c0                	test   %eax,%eax
8010292c:	0f 84 cf 00 00 00    	je     80102a01 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102932:	8b 03                	mov    (%ebx),%eax
80102934:	83 e0 06             	and    $0x6,%eax
80102937:	83 f8 02             	cmp    $0x2,%eax
8010293a:	0f 84 b4 00 00 00    	je     801029f4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102940:	8b 53 04             	mov    0x4(%ebx),%edx
80102943:	85 d2                	test   %edx,%edx
80102945:	74 0d                	je     80102954 <iderw+0x44>
80102947:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010294c:	85 c0                	test   %eax,%eax
8010294e:	0f 84 93 00 00 00    	je     801029e7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 c0 b5 10 80       	push   $0x8010b5c0
8010295c:	e8 1f 23 00 00       	call   80104c80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102961:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
  b->qnext = 0;
80102966:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010296d:	83 c4 10             	add    $0x10,%esp
80102970:	85 c0                	test   %eax,%eax
80102972:	74 6c                	je     801029e0 <iderw+0xd0>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102978:	89 c2                	mov    %eax,%edx
8010297a:	8b 40 58             	mov    0x58(%eax),%eax
8010297d:	85 c0                	test   %eax,%eax
8010297f:	75 f7                	jne    80102978 <iderw+0x68>
80102981:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102984:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102986:	39 1d a4 b5 10 80    	cmp    %ebx,0x8010b5a4
8010298c:	74 42                	je     801029d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010298e:	8b 03                	mov    (%ebx),%eax
80102990:	83 e0 06             	and    $0x6,%eax
80102993:	83 f8 02             	cmp    $0x2,%eax
80102996:	74 23                	je     801029bb <iderw+0xab>
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop
    sleep(b, &idelock);
801029a0:	83 ec 08             	sub    $0x8,%esp
801029a3:	68 c0 b5 10 80       	push   $0x8010b5c0
801029a8:	53                   	push   %ebx
801029a9:	e8 02 1c 00 00       	call   801045b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029ae:	8b 03                	mov    (%ebx),%eax
801029b0:	83 c4 10             	add    $0x10,%esp
801029b3:	83 e0 06             	and    $0x6,%eax
801029b6:	83 f8 02             	cmp    $0x2,%eax
801029b9:	75 e5                	jne    801029a0 <iderw+0x90>
  }


  release(&idelock);
801029bb:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
801029c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c5:	c9                   	leave  
  release(&idelock);
801029c6:	e9 75 23 00 00       	jmp    80104d40 <release>
801029cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop
    idestart(b);
801029d0:	89 d8                	mov    %ebx,%eax
801029d2:	e8 29 fd ff ff       	call   80102700 <idestart>
801029d7:	eb b5                	jmp    8010298e <iderw+0x7e>
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029e0:	ba a4 b5 10 80       	mov    $0x8010b5a4,%edx
801029e5:	eb 9d                	jmp    80102984 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801029e7:	83 ec 0c             	sub    $0xc,%esp
801029ea:	68 55 7a 10 80       	push   $0x80107a55
801029ef:	e8 9c d9 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	68 40 7a 10 80       	push   $0x80107a40
801029fc:	e8 8f d9 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102a01:	83 ec 0c             	sub    $0xc,%esp
80102a04:	68 2a 7a 10 80       	push   $0x80107a2a
80102a09:	e8 82 d9 ff ff       	call   80100390 <panic>
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a10:	f3 0f 1e fb          	endbr32 
80102a14:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a15:	c7 05 74 3b 11 80 00 	movl   $0xfec00000,0x80113b74
80102a1c:	00 c0 fe 
{
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	56                   	push   %esi
80102a22:	53                   	push   %ebx
  ioapic->reg = reg;
80102a23:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a2a:	00 00 00 
  return ioapic->data;
80102a2d:	8b 15 74 3b 11 80    	mov    0x80113b74,%edx
80102a33:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102a36:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102a3c:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a42:	0f b6 15 a0 3c 11 80 	movzbl 0x80113ca0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a49:	c1 ee 10             	shr    $0x10,%esi
80102a4c:	89 f0                	mov    %esi,%eax
80102a4e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102a51:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102a54:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a57:	39 c2                	cmp    %eax,%edx
80102a59:	74 16                	je     80102a71 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a5b:	83 ec 0c             	sub    $0xc,%esp
80102a5e:	68 74 7a 10 80       	push   $0x80107a74
80102a63:	e8 38 dd ff ff       	call   801007a0 <cprintf>
80102a68:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102a6e:	83 c4 10             	add    $0x10,%esp
80102a71:	83 c6 21             	add    $0x21,%esi
{
80102a74:	ba 10 00 00 00       	mov    $0x10,%edx
80102a79:	b8 20 00 00 00       	mov    $0x20,%eax
80102a7e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102a80:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a82:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102a84:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102a8a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a8d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102a93:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102a96:	8d 5a 01             	lea    0x1(%edx),%ebx
80102a99:	83 c2 02             	add    $0x2,%edx
80102a9c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102a9e:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102aa4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102aab:	39 f0                	cmp    %esi,%eax
80102aad:	75 d1                	jne    80102a80 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ab2:	5b                   	pop    %ebx
80102ab3:	5e                   	pop    %esi
80102ab4:	5d                   	pop    %ebp
80102ab5:	c3                   	ret    
80102ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abd:	8d 76 00             	lea    0x0(%esi),%esi

80102ac0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ac0:	f3 0f 1e fb          	endbr32 
80102ac4:	55                   	push   %ebp
  ioapic->reg = reg;
80102ac5:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
{
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ad0:	8d 50 20             	lea    0x20(%eax),%edx
80102ad3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ad7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ad9:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102adf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102ae2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ae8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102aea:	a1 74 3b 11 80       	mov    0x80113b74,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102aef:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102af2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102af5:	5d                   	pop    %ebp
80102af6:	c3                   	ret    
80102af7:	66 90                	xchg   %ax,%ax
80102af9:	66 90                	xchg   %ax,%ax
80102afb:	66 90                	xchg   %ax,%ax
80102afd:	66 90                	xchg   %ax,%ax
80102aff:	90                   	nop

80102b00 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b00:	f3 0f 1e fb          	endbr32 
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
80102b07:	53                   	push   %ebx
80102b08:	83 ec 04             	sub    $0x4,%esp
80102b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b0e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b14:	75 7a                	jne    80102b90 <kfree+0x90>
80102b16:	81 fb e8 69 11 80    	cmp    $0x801169e8,%ebx
80102b1c:	72 72                	jb     80102b90 <kfree+0x90>
80102b1e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b24:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b29:	77 65                	ja     80102b90 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b2b:	83 ec 04             	sub    $0x4,%esp
80102b2e:	68 00 10 00 00       	push   $0x1000
80102b33:	6a 01                	push   $0x1
80102b35:	53                   	push   %ebx
80102b36:	e8 55 22 00 00       	call   80104d90 <memset>

  if(kmem.use_lock)
80102b3b:	8b 15 b4 3b 11 80    	mov    0x80113bb4,%edx
80102b41:	83 c4 10             	add    $0x10,%esp
80102b44:	85 d2                	test   %edx,%edx
80102b46:	75 20                	jne    80102b68 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b48:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
80102b4d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b4f:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
  kmem.freelist = r;
80102b54:	89 1d b8 3b 11 80    	mov    %ebx,0x80113bb8
  if(kmem.use_lock)
80102b5a:	85 c0                	test   %eax,%eax
80102b5c:	75 22                	jne    80102b80 <kfree+0x80>
    release(&kmem.lock);
}
80102b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b61:	c9                   	leave  
80102b62:	c3                   	ret    
80102b63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b67:	90                   	nop
    acquire(&kmem.lock);
80102b68:	83 ec 0c             	sub    $0xc,%esp
80102b6b:	68 80 3b 11 80       	push   $0x80113b80
80102b70:	e8 0b 21 00 00       	call   80104c80 <acquire>
80102b75:	83 c4 10             	add    $0x10,%esp
80102b78:	eb ce                	jmp    80102b48 <kfree+0x48>
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102b80:	c7 45 08 80 3b 11 80 	movl   $0x80113b80,0x8(%ebp)
}
80102b87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b8a:	c9                   	leave  
    release(&kmem.lock);
80102b8b:	e9 b0 21 00 00       	jmp    80104d40 <release>
    panic("kfree");
80102b90:	83 ec 0c             	sub    $0xc,%esp
80102b93:	68 a6 7a 10 80       	push   $0x80107aa6
80102b98:	e8 f3 d7 ff ff       	call   80100390 <panic>
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ba0 <freerange>:
{
80102ba0:	f3 0f 1e fb          	endbr32 
80102ba4:	55                   	push   %ebp
80102ba5:	89 e5                	mov    %esp,%ebp
80102ba7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ba8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bab:	8b 75 0c             	mov    0xc(%ebp),%esi
80102bae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102baf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bb5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bc1:	39 de                	cmp    %ebx,%esi
80102bc3:	72 1f                	jb     80102be4 <freerange+0x44>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102bc8:	83 ec 0c             	sub    $0xc,%esp
80102bcb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102bd7:	50                   	push   %eax
80102bd8:	e8 23 ff ff ff       	call   80102b00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bdd:	83 c4 10             	add    $0x10,%esp
80102be0:	39 f3                	cmp    %esi,%ebx
80102be2:	76 e4                	jbe    80102bc8 <freerange+0x28>
}
80102be4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102be7:	5b                   	pop    %ebx
80102be8:	5e                   	pop    %esi
80102be9:	5d                   	pop    %ebp
80102bea:	c3                   	ret    
80102beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bef:	90                   	nop

80102bf0 <kinit1>:
{
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	56                   	push   %esi
80102bf8:	53                   	push   %ebx
80102bf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102bfc:	83 ec 08             	sub    $0x8,%esp
80102bff:	68 ac 7a 10 80       	push   $0x80107aac
80102c04:	68 80 3b 11 80       	push   $0x80113b80
80102c09:	e8 f2 1e 00 00       	call   80104b00 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c11:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c14:	c7 05 b4 3b 11 80 00 	movl   $0x0,0x80113bb4
80102c1b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c1e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c24:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c30:	39 de                	cmp    %ebx,%esi
80102c32:	72 20                	jb     80102c54 <kinit1+0x64>
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c38:	83 ec 0c             	sub    $0xc,%esp
80102c3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c47:	50                   	push   %eax
80102c48:	e8 b3 fe ff ff       	call   80102b00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	39 de                	cmp    %ebx,%esi
80102c52:	73 e4                	jae    80102c38 <kinit1+0x48>
}
80102c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c57:	5b                   	pop    %ebx
80102c58:	5e                   	pop    %esi
80102c59:	5d                   	pop    %ebp
80102c5a:	c3                   	ret    
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <kinit2>:
{
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
80102c65:	89 e5                	mov    %esp,%ebp
80102c67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c81:	39 de                	cmp    %ebx,%esi
80102c83:	72 1f                	jb     80102ca4 <kinit2+0x44>
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c97:	50                   	push   %eax
80102c98:	e8 63 fe ff ff       	call   80102b00 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	39 de                	cmp    %ebx,%esi
80102ca2:	73 e4                	jae    80102c88 <kinit2+0x28>
  kmem.use_lock = 1;
80102ca4:	c7 05 b4 3b 11 80 01 	movl   $0x1,0x80113bb4
80102cab:	00 00 00 
}
80102cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cb1:	5b                   	pop    %ebx
80102cb2:	5e                   	pop    %esi
80102cb3:	5d                   	pop    %ebp
80102cb4:	c3                   	ret    
80102cb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102cc0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102cc4:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
80102cc9:	85 c0                	test   %eax,%eax
80102ccb:	75 1b                	jne    80102ce8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102ccd:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
  if(r)
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	74 0a                	je     80102ce0 <kalloc+0x20>
    kmem.freelist = r->next;
80102cd6:	8b 10                	mov    (%eax),%edx
80102cd8:	89 15 b8 3b 11 80    	mov    %edx,0x80113bb8
  if(kmem.use_lock)
80102cde:	c3                   	ret    
80102cdf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102ce0:	c3                   	ret    
80102ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102cee:	68 80 3b 11 80       	push   $0x80113b80
80102cf3:	e8 88 1f 00 00       	call   80104c80 <acquire>
  r = kmem.freelist;
80102cf8:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
  if(r)
80102cfd:	8b 15 b4 3b 11 80    	mov    0x80113bb4,%edx
80102d03:	83 c4 10             	add    $0x10,%esp
80102d06:	85 c0                	test   %eax,%eax
80102d08:	74 08                	je     80102d12 <kalloc+0x52>
    kmem.freelist = r->next;
80102d0a:	8b 08                	mov    (%eax),%ecx
80102d0c:	89 0d b8 3b 11 80    	mov    %ecx,0x80113bb8
  if(kmem.use_lock)
80102d12:	85 d2                	test   %edx,%edx
80102d14:	74 16                	je     80102d2c <kalloc+0x6c>
    release(&kmem.lock);
80102d16:	83 ec 0c             	sub    $0xc,%esp
80102d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d1c:	68 80 3b 11 80       	push   $0x80113b80
80102d21:	e8 1a 20 00 00       	call   80104d40 <release>
  return (char*)r;
80102d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d29:	83 c4 10             	add    $0x10,%esp
}
80102d2c:	c9                   	leave  
80102d2d:	c3                   	ret    
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d34:	ba 64 00 00 00       	mov    $0x64,%edx
80102d39:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d3a:	a8 01                	test   $0x1,%al
80102d3c:	0f 84 be 00 00 00    	je     80102e00 <kbdgetc+0xd0>
{
80102d42:	55                   	push   %ebp
80102d43:	ba 60 00 00 00       	mov    $0x60,%edx
80102d48:	89 e5                	mov    %esp,%ebp
80102d4a:	53                   	push   %ebx
80102d4b:	ec                   	in     (%dx),%al
  return data;
80102d4c:	8b 1d f4 b5 10 80    	mov    0x8010b5f4,%ebx
    return -1;
  data = inb(KBDATAP);
80102d52:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102d55:	3c e0                	cmp    $0xe0,%al
80102d57:	74 57                	je     80102db0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d59:	89 d9                	mov    %ebx,%ecx
80102d5b:	83 e1 40             	and    $0x40,%ecx
80102d5e:	84 c0                	test   %al,%al
80102d60:	78 5e                	js     80102dc0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d62:	85 c9                	test   %ecx,%ecx
80102d64:	74 09                	je     80102d6f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d66:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d69:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102d6c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d6f:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
  shift ^= togglecode[data];
80102d76:	0f b6 82 e0 7a 10 80 	movzbl -0x7fef8520(%edx),%eax
  shift |= shiftcode[data];
80102d7d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d7f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d81:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d83:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d89:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d8c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d8f:	8b 04 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%eax
80102d96:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d9a:	74 0b                	je     80102da7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102d9c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d9f:	83 fa 19             	cmp    $0x19,%edx
80102da2:	77 44                	ja     80102de8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102da4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102da7:	5b                   	pop    %ebx
80102da8:	5d                   	pop    %ebp
80102da9:	c3                   	ret    
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102db0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102db3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102db5:	89 1d f4 b5 10 80    	mov    %ebx,0x8010b5f4
}
80102dbb:	5b                   	pop    %ebx
80102dbc:	5d                   	pop    %ebp
80102dbd:	c3                   	ret    
80102dbe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102dc0:	83 e0 7f             	and    $0x7f,%eax
80102dc3:	85 c9                	test   %ecx,%ecx
80102dc5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102dc8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102dca:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
80102dd1:	83 c9 40             	or     $0x40,%ecx
80102dd4:	0f b6 c9             	movzbl %cl,%ecx
80102dd7:	f7 d1                	not    %ecx
80102dd9:	21 d9                	and    %ebx,%ecx
}
80102ddb:	5b                   	pop    %ebx
80102ddc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102ddd:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
}
80102de3:	c3                   	ret    
80102de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102de8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102deb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102dee:	5b                   	pop    %ebx
80102def:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102df0:	83 f9 1a             	cmp    $0x1a,%ecx
80102df3:	0f 42 c2             	cmovb  %edx,%eax
}
80102df6:	c3                   	ret    
80102df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dfe:	66 90                	xchg   %ax,%ax
    return -1;
80102e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e05:	c3                   	ret    
80102e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi

80102e10 <kbdintr>:

void
kbdintr(void)
{
80102e10:	f3 0f 1e fb          	endbr32 
80102e14:	55                   	push   %ebp
80102e15:	89 e5                	mov    %esp,%ebp
80102e17:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e1a:	68 30 2d 10 80       	push   $0x80102d30
80102e1f:	e8 dc dd ff ff       	call   80100c00 <consoleintr>
}
80102e24:	83 c4 10             	add    $0x10,%esp
80102e27:	c9                   	leave  
80102e28:	c3                   	ret    
80102e29:	66 90                	xchg   %ax,%ax
80102e2b:	66 90                	xchg   %ax,%ax
80102e2d:	66 90                	xchg   %ax,%ax
80102e2f:	90                   	nop

80102e30 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102e30:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102e34:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102e39:	85 c0                	test   %eax,%eax
80102e3b:	0f 84 c7 00 00 00    	je     80102f08 <lapicinit+0xd8>
  lapic[index] = value;
80102e41:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e48:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e4e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e55:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e58:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e5b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e62:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e65:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e68:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e6f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e72:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e75:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e7c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e7f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e82:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e89:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e8c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e8f:	8b 50 30             	mov    0x30(%eax),%edx
80102e92:	c1 ea 10             	shr    $0x10,%edx
80102e95:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102e9b:	75 73                	jne    80102f10 <lapicinit+0xe0>
  lapic[index] = value;
80102e9d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ea4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eaa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102eb1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eb7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ebe:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ecb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ece:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ed8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102edb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ede:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ee5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ee8:	8b 50 20             	mov    0x20(%eax),%edx
80102eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eef:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ef0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ef6:	80 e6 10             	and    $0x10,%dh
80102ef9:	75 f5                	jne    80102ef0 <lapicinit+0xc0>
  lapic[index] = value;
80102efb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f08:	c3                   	ret    
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102f10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102f1d:	e9 7b ff ff ff       	jmp    80102e9d <lapicinit+0x6d>
80102f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f30 <lapicid>:

int
lapicid(void)
{
80102f30:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102f34:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102f39:	85 c0                	test   %eax,%eax
80102f3b:	74 0b                	je     80102f48 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102f3d:	8b 40 20             	mov    0x20(%eax),%eax
80102f40:	c1 e8 18             	shr    $0x18,%eax
80102f43:	c3                   	ret    
80102f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102f48:	31 c0                	xor    %eax,%eax
}
80102f4a:	c3                   	ret    
80102f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f50:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102f54:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102f59:	85 c0                	test   %eax,%eax
80102f5b:	74 0d                	je     80102f6a <lapiceoi+0x1a>
  lapic[index] = value;
80102f5d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f67:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f6a:	c3                   	ret    
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop

80102f70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f70:	f3 0f 1e fb          	endbr32 
}
80102f74:	c3                   	ret    
80102f75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f80:	f3 0f 1e fb          	endbr32 
80102f84:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f85:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f8a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f8f:	89 e5                	mov    %esp,%ebp
80102f91:	53                   	push   %ebx
80102f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f95:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f98:	ee                   	out    %al,(%dx)
80102f99:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f9e:	ba 71 00 00 00       	mov    $0x71,%edx
80102fa3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102fa4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fa6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102fa9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102faf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fb1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102fb4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102fb6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fb9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102fbc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102fc2:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102fc7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fcd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fd0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102fd7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fda:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fdd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102fe4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fe7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fea:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ff0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ff3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ff9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ffc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103002:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103005:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010300b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010300c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010300f:	5d                   	pop    %ebp
80103010:	c3                   	ret    
80103011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop

80103020 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	b8 0b 00 00 00       	mov    $0xb,%eax
8010302a:	ba 70 00 00 00       	mov    $0x70,%edx
8010302f:	89 e5                	mov    %esp,%ebp
80103031:	57                   	push   %edi
80103032:	56                   	push   %esi
80103033:	53                   	push   %ebx
80103034:	83 ec 4c             	sub    $0x4c,%esp
80103037:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103038:	ba 71 00 00 00       	mov    $0x71,%edx
8010303d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010303e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103041:	bb 70 00 00 00       	mov    $0x70,%ebx
80103046:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	31 c0                	xor    %eax,%eax
80103052:	89 da                	mov    %ebx,%edx
80103054:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103055:	b9 71 00 00 00       	mov    $0x71,%ecx
8010305a:	89 ca                	mov    %ecx,%edx
8010305c:	ec                   	in     (%dx),%al
8010305d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103060:	89 da                	mov    %ebx,%edx
80103062:	b8 02 00 00 00       	mov    $0x2,%eax
80103067:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103068:	89 ca                	mov    %ecx,%edx
8010306a:	ec                   	in     (%dx),%al
8010306b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010306e:	89 da                	mov    %ebx,%edx
80103070:	b8 04 00 00 00       	mov    $0x4,%eax
80103075:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103076:	89 ca                	mov    %ecx,%edx
80103078:	ec                   	in     (%dx),%al
80103079:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307c:	89 da                	mov    %ebx,%edx
8010307e:	b8 07 00 00 00       	mov    $0x7,%eax
80103083:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103084:	89 ca                	mov    %ecx,%edx
80103086:	ec                   	in     (%dx),%al
80103087:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308a:	89 da                	mov    %ebx,%edx
8010308c:	b8 08 00 00 00       	mov    $0x8,%eax
80103091:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103092:	89 ca                	mov    %ecx,%edx
80103094:	ec                   	in     (%dx),%al
80103095:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103097:	89 da                	mov    %ebx,%edx
80103099:	b8 09 00 00 00       	mov    $0x9,%eax
8010309e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010309f:	89 ca                	mov    %ecx,%edx
801030a1:	ec                   	in     (%dx),%al
801030a2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a4:	89 da                	mov    %ebx,%edx
801030a6:	b8 0a 00 00 00       	mov    $0xa,%eax
801030ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ac:	89 ca                	mov    %ecx,%edx
801030ae:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030af:	84 c0                	test   %al,%al
801030b1:	78 9d                	js     80103050 <cmostime+0x30>
  return inb(CMOS_RETURN);
801030b3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030b7:	89 fa                	mov    %edi,%edx
801030b9:	0f b6 fa             	movzbl %dl,%edi
801030bc:	89 f2                	mov    %esi,%edx
801030be:	89 45 b8             	mov    %eax,-0x48(%ebp)
801030c1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801030c5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c8:	89 da                	mov    %ebx,%edx
801030ca:	89 7d c8             	mov    %edi,-0x38(%ebp)
801030cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030d0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801030d4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801030d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030da:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801030de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030e1:	31 c0                	xor    %eax,%eax
801030e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e4:	89 ca                	mov    %ecx,%edx
801030e6:	ec                   	in     (%dx),%al
801030e7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ea:	89 da                	mov    %ebx,%edx
801030ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030ef:	b8 02 00 00 00       	mov    $0x2,%eax
801030f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f5:	89 ca                	mov    %ecx,%edx
801030f7:	ec                   	in     (%dx),%al
801030f8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fb:	89 da                	mov    %ebx,%edx
801030fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103100:	b8 04 00 00 00       	mov    $0x4,%eax
80103105:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103106:	89 ca                	mov    %ecx,%edx
80103108:	ec                   	in     (%dx),%al
80103109:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310c:	89 da                	mov    %ebx,%edx
8010310e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103111:	b8 07 00 00 00       	mov    $0x7,%eax
80103116:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103117:	89 ca                	mov    %ecx,%edx
80103119:	ec                   	in     (%dx),%al
8010311a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311d:	89 da                	mov    %ebx,%edx
8010311f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103122:	b8 08 00 00 00       	mov    $0x8,%eax
80103127:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103128:	89 ca                	mov    %ecx,%edx
8010312a:	ec                   	in     (%dx),%al
8010312b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312e:	89 da                	mov    %ebx,%edx
80103130:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103133:	b8 09 00 00 00       	mov    $0x9,%eax
80103138:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103139:	89 ca                	mov    %ecx,%edx
8010313b:	ec                   	in     (%dx),%al
8010313c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010313f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103145:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103148:	6a 18                	push   $0x18
8010314a:	50                   	push   %eax
8010314b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010314e:	50                   	push   %eax
8010314f:	e8 8c 1c 00 00       	call   80104de0 <memcmp>
80103154:	83 c4 10             	add    $0x10,%esp
80103157:	85 c0                	test   %eax,%eax
80103159:	0f 85 f1 fe ff ff    	jne    80103050 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010315f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103163:	75 78                	jne    801031dd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103165:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103168:	89 c2                	mov    %eax,%edx
8010316a:	83 e0 0f             	and    $0xf,%eax
8010316d:	c1 ea 04             	shr    $0x4,%edx
80103170:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103173:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103176:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103179:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010317c:	89 c2                	mov    %eax,%edx
8010317e:	83 e0 0f             	and    $0xf,%eax
80103181:	c1 ea 04             	shr    $0x4,%edx
80103184:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103187:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010318a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010318d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103190:	89 c2                	mov    %eax,%edx
80103192:	83 e0 0f             	and    $0xf,%eax
80103195:	c1 ea 04             	shr    $0x4,%edx
80103198:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010319b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010319e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031a4:	89 c2                	mov    %eax,%edx
801031a6:	83 e0 0f             	and    $0xf,%eax
801031a9:	c1 ea 04             	shr    $0x4,%edx
801031ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031b8:	89 c2                	mov    %eax,%edx
801031ba:	83 e0 0f             	and    $0xf,%eax
801031bd:	c1 ea 04             	shr    $0x4,%edx
801031c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801031c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031cc:	89 c2                	mov    %eax,%edx
801031ce:	83 e0 0f             	and    $0xf,%eax
801031d1:	c1 ea 04             	shr    $0x4,%edx
801031d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031da:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801031dd:	8b 75 08             	mov    0x8(%ebp),%esi
801031e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031e3:	89 06                	mov    %eax,(%esi)
801031e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031e8:	89 46 04             	mov    %eax,0x4(%esi)
801031eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031ee:	89 46 08             	mov    %eax,0x8(%esi)
801031f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031f4:	89 46 0c             	mov    %eax,0xc(%esi)
801031f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031fa:	89 46 10             	mov    %eax,0x10(%esi)
801031fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103200:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103203:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010320a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5f                   	pop    %edi
80103210:	5d                   	pop    %ebp
80103211:	c3                   	ret    
80103212:	66 90                	xchg   %ax,%ax
80103214:	66 90                	xchg   %ax,%ax
80103216:	66 90                	xchg   %ax,%ax
80103218:	66 90                	xchg   %ax,%ax
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103220:	8b 0d 08 3c 11 80    	mov    0x80113c08,%ecx
80103226:	85 c9                	test   %ecx,%ecx
80103228:	0f 8e 8a 00 00 00    	jle    801032b8 <install_trans+0x98>
{
8010322e:	55                   	push   %ebp
8010322f:	89 e5                	mov    %esp,%ebp
80103231:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103232:	31 ff                	xor    %edi,%edi
{
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 0c             	sub    $0xc,%esp
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103240:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80103245:	83 ec 08             	sub    $0x8,%esp
80103248:	01 f8                	add    %edi,%eax
8010324a:	83 c0 01             	add    $0x1,%eax
8010324d:	50                   	push   %eax
8010324e:	ff 35 04 3c 11 80    	pushl  0x80113c04
80103254:	e8 77 ce ff ff       	call   801000d0 <bread>
80103259:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010325b:	58                   	pop    %eax
8010325c:	5a                   	pop    %edx
8010325d:	ff 34 bd 0c 3c 11 80 	pushl  -0x7feec3f4(,%edi,4)
80103264:	ff 35 04 3c 11 80    	pushl  0x80113c04
  for (tail = 0; tail < log.lh.n; tail++) {
8010326a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010326d:	e8 5e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103272:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103275:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103277:	8d 46 5c             	lea    0x5c(%esi),%eax
8010327a:	68 00 02 00 00       	push   $0x200
8010327f:	50                   	push   %eax
80103280:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103283:	50                   	push   %eax
80103284:	e8 a7 1b 00 00       	call   80104e30 <memmove>
    bwrite(dbuf);  // write dst to disk
80103289:	89 1c 24             	mov    %ebx,(%esp)
8010328c:	e8 1f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103291:	89 34 24             	mov    %esi,(%esp)
80103294:	e8 57 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103299:	89 1c 24             	mov    %ebx,(%esp)
8010329c:	e8 4f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	39 3d 08 3c 11 80    	cmp    %edi,0x80113c08
801032aa:	7f 94                	jg     80103240 <install_trans+0x20>
  }
}
801032ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032af:	5b                   	pop    %ebx
801032b0:	5e                   	pop    %esi
801032b1:	5f                   	pop    %edi
801032b2:	5d                   	pop    %ebp
801032b3:	c3                   	ret    
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032b8:	c3                   	ret    
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	53                   	push   %ebx
801032c4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801032c7:	ff 35 f4 3b 11 80    	pushl  0x80113bf4
801032cd:	ff 35 04 3c 11 80    	pushl  0x80113c04
801032d3:	e8 f8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032d8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801032db:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801032dd:	a1 08 3c 11 80       	mov    0x80113c08,%eax
801032e2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032e5:	85 c0                	test   %eax,%eax
801032e7:	7e 19                	jle    80103302 <write_head+0x42>
801032e9:	31 d2                	xor    %edx,%edx
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
    hb->block[i] = log.lh.block[i];
801032f0:	8b 0c 95 0c 3c 11 80 	mov    -0x7feec3f4(,%edx,4),%ecx
801032f7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801032fb:	83 c2 01             	add    $0x1,%edx
801032fe:	39 d0                	cmp    %edx,%eax
80103300:	75 ee                	jne    801032f0 <write_head+0x30>
  }
  bwrite(buf);
80103302:	83 ec 0c             	sub    $0xc,%esp
80103305:	53                   	push   %ebx
80103306:	e8 a5 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010330b:	89 1c 24             	mov    %ebx,(%esp)
8010330e:	e8 dd ce ff ff       	call   801001f0 <brelse>
}
80103313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	c9                   	leave  
8010331a:	c3                   	ret    
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <initlog>:
{
80103320:	f3 0f 1e fb          	endbr32 
80103324:	55                   	push   %ebp
80103325:	89 e5                	mov    %esp,%ebp
80103327:	53                   	push   %ebx
80103328:	83 ec 2c             	sub    $0x2c,%esp
8010332b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010332e:	68 e0 7c 10 80       	push   $0x80107ce0
80103333:	68 c0 3b 11 80       	push   $0x80113bc0
80103338:	e8 c3 17 00 00       	call   80104b00 <initlock>
  readsb(dev, &sb);
8010333d:	58                   	pop    %eax
8010333e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103341:	5a                   	pop    %edx
80103342:	50                   	push   %eax
80103343:	53                   	push   %ebx
80103344:	e8 47 e8 ff ff       	call   80101b90 <readsb>
  log.start = sb.logstart;
80103349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010334c:	59                   	pop    %ecx
  log.dev = dev;
8010334d:	89 1d 04 3c 11 80    	mov    %ebx,0x80113c04
  log.size = sb.nlog;
80103353:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103356:	a3 f4 3b 11 80       	mov    %eax,0x80113bf4
  log.size = sb.nlog;
8010335b:	89 15 f8 3b 11 80    	mov    %edx,0x80113bf8
  struct buf *buf = bread(log.dev, log.start);
80103361:	5a                   	pop    %edx
80103362:	50                   	push   %eax
80103363:	53                   	push   %ebx
80103364:	e8 67 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103369:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010336c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010336f:	89 0d 08 3c 11 80    	mov    %ecx,0x80113c08
  for (i = 0; i < log.lh.n; i++) {
80103375:	85 c9                	test   %ecx,%ecx
80103377:	7e 19                	jle    80103392 <initlog+0x72>
80103379:	31 d2                	xor    %edx,%edx
8010337b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103380:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103384:	89 1c 95 0c 3c 11 80 	mov    %ebx,-0x7feec3f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010338b:	83 c2 01             	add    $0x1,%edx
8010338e:	39 d1                	cmp    %edx,%ecx
80103390:	75 ee                	jne    80103380 <initlog+0x60>
  brelse(buf);
80103392:	83 ec 0c             	sub    $0xc,%esp
80103395:	50                   	push   %eax
80103396:	e8 55 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010339b:	e8 80 fe ff ff       	call   80103220 <install_trans>
  log.lh.n = 0;
801033a0:	c7 05 08 3c 11 80 00 	movl   $0x0,0x80113c08
801033a7:	00 00 00 
  write_head(); // clear the log
801033aa:	e8 11 ff ff ff       	call   801032c0 <write_head>
}
801033af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033b2:	83 c4 10             	add    $0x10,%esp
801033b5:	c9                   	leave  
801033b6:	c3                   	ret    
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax

801033c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	55                   	push   %ebp
801033c5:	89 e5                	mov    %esp,%ebp
801033c7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801033ca:	68 c0 3b 11 80       	push   $0x80113bc0
801033cf:	e8 ac 18 00 00       	call   80104c80 <acquire>
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	eb 1c                	jmp    801033f5 <begin_op+0x35>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033e0:	83 ec 08             	sub    $0x8,%esp
801033e3:	68 c0 3b 11 80       	push   $0x80113bc0
801033e8:	68 c0 3b 11 80       	push   $0x80113bc0
801033ed:	e8 be 11 00 00       	call   801045b0 <sleep>
801033f2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801033f5:	a1 00 3c 11 80       	mov    0x80113c00,%eax
801033fa:	85 c0                	test   %eax,%eax
801033fc:	75 e2                	jne    801033e0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033fe:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80103403:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
80103409:	83 c0 01             	add    $0x1,%eax
8010340c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010340f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103412:	83 fa 1e             	cmp    $0x1e,%edx
80103415:	7f c9                	jg     801033e0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103417:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010341a:	a3 fc 3b 11 80       	mov    %eax,0x80113bfc
      release(&log.lock);
8010341f:	68 c0 3b 11 80       	push   $0x80113bc0
80103424:	e8 17 19 00 00       	call   80104d40 <release>
      break;
    }
  }
}
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	c9                   	leave  
8010342d:	c3                   	ret    
8010342e:	66 90                	xchg   %ax,%ax

80103430 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	55                   	push   %ebp
80103435:	89 e5                	mov    %esp,%ebp
80103437:	57                   	push   %edi
80103438:	56                   	push   %esi
80103439:	53                   	push   %ebx
8010343a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010343d:	68 c0 3b 11 80       	push   $0x80113bc0
80103442:	e8 39 18 00 00       	call   80104c80 <acquire>
  log.outstanding -= 1;
80103447:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
  if(log.committing)
8010344c:	8b 35 00 3c 11 80    	mov    0x80113c00,%esi
80103452:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103455:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103458:	89 1d fc 3b 11 80    	mov    %ebx,0x80113bfc
  if(log.committing)
8010345e:	85 f6                	test   %esi,%esi
80103460:	0f 85 1e 01 00 00    	jne    80103584 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103466:	85 db                	test   %ebx,%ebx
80103468:	0f 85 f2 00 00 00    	jne    80103560 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010346e:	c7 05 00 3c 11 80 01 	movl   $0x1,0x80113c00
80103475:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 c0 3b 11 80       	push   $0x80113bc0
80103480:	e8 bb 18 00 00       	call   80104d40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103485:	8b 0d 08 3c 11 80    	mov    0x80113c08,%ecx
8010348b:	83 c4 10             	add    $0x10,%esp
8010348e:	85 c9                	test   %ecx,%ecx
80103490:	7f 3e                	jg     801034d0 <end_op+0xa0>
    acquire(&log.lock);
80103492:	83 ec 0c             	sub    $0xc,%esp
80103495:	68 c0 3b 11 80       	push   $0x80113bc0
8010349a:	e8 e1 17 00 00       	call   80104c80 <acquire>
    wakeup(&log);
8010349f:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
    log.committing = 0;
801034a6:	c7 05 00 3c 11 80 00 	movl   $0x0,0x80113c00
801034ad:	00 00 00 
    wakeup(&log);
801034b0:	e8 bb 12 00 00       	call   80104770 <wakeup>
    release(&log.lock);
801034b5:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
801034bc:	e8 7f 18 00 00       	call   80104d40 <release>
801034c1:	83 c4 10             	add    $0x10,%esp
}
801034c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034d0:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
801034d5:	83 ec 08             	sub    $0x8,%esp
801034d8:	01 d8                	add    %ebx,%eax
801034da:	83 c0 01             	add    $0x1,%eax
801034dd:	50                   	push   %eax
801034de:	ff 35 04 3c 11 80    	pushl  0x80113c04
801034e4:	e8 e7 cb ff ff       	call   801000d0 <bread>
801034e9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034eb:	58                   	pop    %eax
801034ec:	5a                   	pop    %edx
801034ed:	ff 34 9d 0c 3c 11 80 	pushl  -0x7feec3f4(,%ebx,4)
801034f4:	ff 35 04 3c 11 80    	pushl  0x80113c04
  for (tail = 0; tail < log.lh.n; tail++) {
801034fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034fd:	e8 ce cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103502:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103505:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010350a:	68 00 02 00 00       	push   $0x200
8010350f:	50                   	push   %eax
80103510:	8d 46 5c             	lea    0x5c(%esi),%eax
80103513:	50                   	push   %eax
80103514:	e8 17 19 00 00       	call   80104e30 <memmove>
    bwrite(to);  // write the log
80103519:	89 34 24             	mov    %esi,(%esp)
8010351c:	e8 8f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103521:	89 3c 24             	mov    %edi,(%esp)
80103524:	e8 c7 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103529:	89 34 24             	mov    %esi,(%esp)
8010352c:	e8 bf cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103531:	83 c4 10             	add    $0x10,%esp
80103534:	3b 1d 08 3c 11 80    	cmp    0x80113c08,%ebx
8010353a:	7c 94                	jl     801034d0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010353c:	e8 7f fd ff ff       	call   801032c0 <write_head>
    install_trans(); // Now install writes to home locations
80103541:	e8 da fc ff ff       	call   80103220 <install_trans>
    log.lh.n = 0;
80103546:	c7 05 08 3c 11 80 00 	movl   $0x0,0x80113c08
8010354d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103550:	e8 6b fd ff ff       	call   801032c0 <write_head>
80103555:	e9 38 ff ff ff       	jmp    80103492 <end_op+0x62>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 c0 3b 11 80       	push   $0x80113bc0
80103568:	e8 03 12 00 00       	call   80104770 <wakeup>
  release(&log.lock);
8010356d:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
80103574:	e8 c7 17 00 00       	call   80104d40 <release>
80103579:	83 c4 10             	add    $0x10,%esp
}
8010357c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357f:	5b                   	pop    %ebx
80103580:	5e                   	pop    %esi
80103581:	5f                   	pop    %edi
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
    panic("log.committing");
80103584:	83 ec 0c             	sub    $0xc,%esp
80103587:	68 e4 7c 10 80       	push   $0x80107ce4
8010358c:	e8 ff cd ff ff       	call   80100390 <panic>
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359f:	90                   	nop

801035a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	53                   	push   %ebx
801035a8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035ab:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
{
801035b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035b4:	83 fa 1d             	cmp    $0x1d,%edx
801035b7:	0f 8f 91 00 00 00    	jg     8010364e <log_write+0xae>
801035bd:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
801035c2:	83 e8 01             	sub    $0x1,%eax
801035c5:	39 c2                	cmp    %eax,%edx
801035c7:	0f 8d 81 00 00 00    	jge    8010364e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035cd:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
801035d2:	85 c0                	test   %eax,%eax
801035d4:	0f 8e 81 00 00 00    	jle    8010365b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035da:	83 ec 0c             	sub    $0xc,%esp
801035dd:	68 c0 3b 11 80       	push   $0x80113bc0
801035e2:	e8 99 16 00 00       	call   80104c80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035e7:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
801035ed:	83 c4 10             	add    $0x10,%esp
801035f0:	85 d2                	test   %edx,%edx
801035f2:	7e 4e                	jle    80103642 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035f4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801035f7:	31 c0                	xor    %eax,%eax
801035f9:	eb 0c                	jmp    80103607 <log_write+0x67>
801035fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ff:	90                   	nop
80103600:	83 c0 01             	add    $0x1,%eax
80103603:	39 c2                	cmp    %eax,%edx
80103605:	74 29                	je     80103630 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103607:	39 0c 85 0c 3c 11 80 	cmp    %ecx,-0x7feec3f4(,%eax,4)
8010360e:	75 f0                	jne    80103600 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103610:	89 0c 85 0c 3c 11 80 	mov    %ecx,-0x7feec3f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103617:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010361a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010361d:	c7 45 08 c0 3b 11 80 	movl   $0x80113bc0,0x8(%ebp)
}
80103624:	c9                   	leave  
  release(&log.lock);
80103625:	e9 16 17 00 00       	jmp    80104d40 <release>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103630:	89 0c 95 0c 3c 11 80 	mov    %ecx,-0x7feec3f4(,%edx,4)
    log.lh.n++;
80103637:	83 c2 01             	add    $0x1,%edx
8010363a:	89 15 08 3c 11 80    	mov    %edx,0x80113c08
80103640:	eb d5                	jmp    80103617 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103642:	8b 43 08             	mov    0x8(%ebx),%eax
80103645:	a3 0c 3c 11 80       	mov    %eax,0x80113c0c
  if (i == log.lh.n)
8010364a:	75 cb                	jne    80103617 <log_write+0x77>
8010364c:	eb e9                	jmp    80103637 <log_write+0x97>
    panic("too big a transaction");
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 f3 7c 10 80       	push   $0x80107cf3
80103656:	e8 35 cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	68 09 7d 10 80       	push   $0x80107d09
80103663:	e8 28 cd ff ff       	call   80100390 <panic>
80103668:	66 90                	xchg   %ax,%ax
8010366a:	66 90                	xchg   %ax,%ax
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
80103674:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103677:	e8 54 09 00 00       	call   80103fd0 <cpuid>
8010367c:	89 c3                	mov    %eax,%ebx
8010367e:	e8 4d 09 00 00       	call   80103fd0 <cpuid>
80103683:	83 ec 04             	sub    $0x4,%esp
80103686:	53                   	push   %ebx
80103687:	50                   	push   %eax
80103688:	68 24 7d 10 80       	push   $0x80107d24
8010368d:	e8 0e d1 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
80103692:	e8 e9 29 00 00       	call   80106080 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103697:	e8 c4 08 00 00       	call   80103f60 <mycpu>
8010369c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010369e:	b8 01 00 00 00       	mov    $0x1,%eax
801036a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036aa:	e8 11 0c 00 00       	call   801042c0 <scheduler>
801036af:	90                   	nop

801036b0 <mpenter>:
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036ba:	e8 91 3a 00 00       	call   80107150 <switchkvm>
  seginit();
801036bf:	e8 fc 39 00 00       	call   801070c0 <seginit>
  lapicinit();
801036c4:	e8 67 f7 ff ff       	call   80102e30 <lapicinit>
  mpmain();
801036c9:	e8 a2 ff ff ff       	call   80103670 <mpmain>
801036ce:	66 90                	xchg   %ax,%ax

801036d0 <main>:
{
801036d0:	f3 0f 1e fb          	endbr32 
801036d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036d8:	83 e4 f0             	and    $0xfffffff0,%esp
801036db:	ff 71 fc             	pushl  -0x4(%ecx)
801036de:	55                   	push   %ebp
801036df:	89 e5                	mov    %esp,%ebp
801036e1:	53                   	push   %ebx
801036e2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036e3:	83 ec 08             	sub    $0x8,%esp
801036e6:	68 00 00 40 80       	push   $0x80400000
801036eb:	68 e8 69 11 80       	push   $0x801169e8
801036f0:	e8 fb f4 ff ff       	call   80102bf0 <kinit1>
  kvmalloc();      // kernel page table
801036f5:	e8 36 3f 00 00       	call   80107630 <kvmalloc>
  mpinit();        // detect other processors
801036fa:	e8 81 01 00 00       	call   80103880 <mpinit>
  lapicinit();     // interrupt controller
801036ff:	e8 2c f7 ff ff       	call   80102e30 <lapicinit>
  seginit();       // segment descriptors
80103704:	e8 b7 39 00 00       	call   801070c0 <seginit>
  picinit();       // disable pic
80103709:	e8 52 03 00 00       	call   80103a60 <picinit>
  ioapicinit();    // another interrupt controller
8010370e:	e8 fd f2 ff ff       	call   80102a10 <ioapicinit>
  consoleinit();   // console hardware
80103713:	e8 a8 d9 ff ff       	call   801010c0 <consoleinit>
  uartinit();      // serial port
80103718:	e8 63 2c 00 00       	call   80106380 <uartinit>
  pinit();         // process table
8010371d:	e8 1e 08 00 00       	call   80103f40 <pinit>
  tvinit();        // trap vectors
80103722:	e8 d9 28 00 00       	call   80106000 <tvinit>
  binit();         // buffer cache
80103727:	e8 14 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010372c:	e8 3f dd ff ff       	call   80101470 <fileinit>
  ideinit();       // disk 
80103731:	e8 aa f0 ff ff       	call   801027e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103736:	83 c4 0c             	add    $0xc,%esp
80103739:	68 8a 00 00 00       	push   $0x8a
8010373e:	68 8c b4 10 80       	push   $0x8010b48c
80103743:	68 00 70 00 80       	push   $0x80007000
80103748:	e8 e3 16 00 00       	call   80104e30 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010374d:	83 c4 10             	add    $0x10,%esp
80103750:	69 05 40 42 11 80 b0 	imul   $0xb0,0x80114240,%eax
80103757:	00 00 00 
8010375a:	05 c0 3c 11 80       	add    $0x80113cc0,%eax
8010375f:	3d c0 3c 11 80       	cmp    $0x80113cc0,%eax
80103764:	76 7a                	jbe    801037e0 <main+0x110>
80103766:	bb c0 3c 11 80       	mov    $0x80113cc0,%ebx
8010376b:	eb 1c                	jmp    80103789 <main+0xb9>
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
80103770:	69 05 40 42 11 80 b0 	imul   $0xb0,0x80114240,%eax
80103777:	00 00 00 
8010377a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103780:	05 c0 3c 11 80       	add    $0x80113cc0,%eax
80103785:	39 c3                	cmp    %eax,%ebx
80103787:	73 57                	jae    801037e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103789:	e8 d2 07 00 00       	call   80103f60 <mycpu>
8010378e:	39 c3                	cmp    %eax,%ebx
80103790:	74 de                	je     80103770 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103792:	e8 29 f5 ff ff       	call   80102cc0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103797:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010379a:	c7 05 f8 6f 00 80 b0 	movl   $0x801036b0,0x80006ff8
801037a1:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037a4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801037ab:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037ae:	05 00 10 00 00       	add    $0x1000,%eax
801037b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801037b8:	0f b6 03             	movzbl (%ebx),%eax
801037bb:	68 00 70 00 00       	push   $0x7000
801037c0:	50                   	push   %eax
801037c1:	e8 ba f7 ff ff       	call   80102f80 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037d6:	85 c0                	test   %eax,%eax
801037d8:	74 f6                	je     801037d0 <main+0x100>
801037da:	eb 94                	jmp    80103770 <main+0xa0>
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037e0:	83 ec 08             	sub    $0x8,%esp
801037e3:	68 00 00 00 8e       	push   $0x8e000000
801037e8:	68 00 00 40 80       	push   $0x80400000
801037ed:	e8 6e f4 ff ff       	call   80102c60 <kinit2>
  userinit();      // first user process
801037f2:	e8 29 08 00 00       	call   80104020 <userinit>
  mpmain();        // finish this processor's setup
801037f7:	e8 74 fe ff ff       	call   80103670 <mpmain>
801037fc:	66 90                	xchg   %ax,%ax
801037fe:	66 90                	xchg   %ax,%ax

80103800 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103805:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010380b:	53                   	push   %ebx
  e = addr+len;
8010380c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010380f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103812:	39 de                	cmp    %ebx,%esi
80103814:	72 10                	jb     80103826 <mpsearch1+0x26>
80103816:	eb 50                	jmp    80103868 <mpsearch1+0x68>
80103818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010381f:	90                   	nop
80103820:	89 fe                	mov    %edi,%esi
80103822:	39 fb                	cmp    %edi,%ebx
80103824:	76 42                	jbe    80103868 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103826:	83 ec 04             	sub    $0x4,%esp
80103829:	8d 7e 10             	lea    0x10(%esi),%edi
8010382c:	6a 04                	push   $0x4
8010382e:	68 38 7d 10 80       	push   $0x80107d38
80103833:	56                   	push   %esi
80103834:	e8 a7 15 00 00       	call   80104de0 <memcmp>
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	85 c0                	test   %eax,%eax
8010383e:	75 e0                	jne    80103820 <mpsearch1+0x20>
80103840:	89 f2                	mov    %esi,%edx
80103842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103848:	0f b6 0a             	movzbl (%edx),%ecx
8010384b:	83 c2 01             	add    $0x1,%edx
8010384e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103850:	39 fa                	cmp    %edi,%edx
80103852:	75 f4                	jne    80103848 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103854:	84 c0                	test   %al,%al
80103856:	75 c8                	jne    80103820 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010385b:	89 f0                	mov    %esi,%eax
8010385d:	5b                   	pop    %ebx
8010385e:	5e                   	pop    %esi
8010385f:	5f                   	pop    %edi
80103860:	5d                   	pop    %ebp
80103861:	c3                   	ret    
80103862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010386b:	31 f6                	xor    %esi,%esi
}
8010386d:	5b                   	pop    %ebx
8010386e:	89 f0                	mov    %esi,%eax
80103870:	5e                   	pop    %esi
80103871:	5f                   	pop    %edi
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	57                   	push   %edi
80103888:	56                   	push   %esi
80103889:	53                   	push   %ebx
8010388a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010388d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103894:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010389b:	c1 e0 08             	shl    $0x8,%eax
8010389e:	09 d0                	or     %edx,%eax
801038a0:	c1 e0 04             	shl    $0x4,%eax
801038a3:	75 1b                	jne    801038c0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038a5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038ac:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038b3:	c1 e0 08             	shl    $0x8,%eax
801038b6:	09 d0                	or     %edx,%eax
801038b8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038bb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038c0:	ba 00 04 00 00       	mov    $0x400,%edx
801038c5:	e8 36 ff ff ff       	call   80103800 <mpsearch1>
801038ca:	89 c6                	mov    %eax,%esi
801038cc:	85 c0                	test   %eax,%eax
801038ce:	0f 84 4c 01 00 00    	je     80103a20 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038d4:	8b 5e 04             	mov    0x4(%esi),%ebx
801038d7:	85 db                	test   %ebx,%ebx
801038d9:	0f 84 61 01 00 00    	je     80103a40 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801038df:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038e2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038e8:	6a 04                	push   $0x4
801038ea:	68 3d 7d 10 80       	push   $0x80107d3d
801038ef:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038f3:	e8 e8 14 00 00       	call   80104de0 <memcmp>
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	85 c0                	test   %eax,%eax
801038fd:	0f 85 3d 01 00 00    	jne    80103a40 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103903:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010390a:	3c 01                	cmp    $0x1,%al
8010390c:	74 08                	je     80103916 <mpinit+0x96>
8010390e:	3c 04                	cmp    $0x4,%al
80103910:	0f 85 2a 01 00 00    	jne    80103a40 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103916:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010391d:	66 85 d2             	test   %dx,%dx
80103920:	74 26                	je     80103948 <mpinit+0xc8>
80103922:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103925:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103927:	31 d2                	xor    %edx,%edx
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103930:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103937:	83 c0 01             	add    $0x1,%eax
8010393a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010393c:	39 f8                	cmp    %edi,%eax
8010393e:	75 f0                	jne    80103930 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103940:	84 d2                	test   %dl,%dl
80103942:	0f 85 f8 00 00 00    	jne    80103a40 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103948:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010394e:	a3 bc 3b 11 80       	mov    %eax,0x80113bbc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103953:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103959:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103960:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103965:	03 55 e4             	add    -0x1c(%ebp),%edx
80103968:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010396b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop
80103970:	39 c2                	cmp    %eax,%edx
80103972:	76 15                	jbe    80103989 <mpinit+0x109>
    switch(*p){
80103974:	0f b6 08             	movzbl (%eax),%ecx
80103977:	80 f9 02             	cmp    $0x2,%cl
8010397a:	74 5c                	je     801039d8 <mpinit+0x158>
8010397c:	77 42                	ja     801039c0 <mpinit+0x140>
8010397e:	84 c9                	test   %cl,%cl
80103980:	74 6e                	je     801039f0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103982:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103985:	39 c2                	cmp    %eax,%edx
80103987:	77 eb                	ja     80103974 <mpinit+0xf4>
80103989:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010398c:	85 db                	test   %ebx,%ebx
8010398e:	0f 84 b9 00 00 00    	je     80103a4d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103994:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103998:	74 15                	je     801039af <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010399a:	b8 70 00 00 00       	mov    $0x70,%eax
8010399f:	ba 22 00 00 00       	mov    $0x22,%edx
801039a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039a5:	ba 23 00 00 00       	mov    $0x23,%edx
801039aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039ab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039ae:	ee                   	out    %al,(%dx)
  }
}
801039af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b2:	5b                   	pop    %ebx
801039b3:	5e                   	pop    %esi
801039b4:	5f                   	pop    %edi
801039b5:	5d                   	pop    %ebp
801039b6:	c3                   	ret    
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax
    switch(*p){
801039c0:	83 e9 03             	sub    $0x3,%ecx
801039c3:	80 f9 01             	cmp    $0x1,%cl
801039c6:	76 ba                	jbe    80103982 <mpinit+0x102>
801039c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801039cf:	eb 9f                	jmp    80103970 <mpinit+0xf0>
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039d8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801039dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039df:	88 0d a0 3c 11 80    	mov    %cl,0x80113ca0
      continue;
801039e5:	eb 89                	jmp    80103970 <mpinit+0xf0>
801039e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ee:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801039f0:	8b 0d 40 42 11 80    	mov    0x80114240,%ecx
801039f6:	83 f9 07             	cmp    $0x7,%ecx
801039f9:	7f 19                	jg     80103a14 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039fb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103a01:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103a05:	83 c1 01             	add    $0x1,%ecx
80103a08:	89 0d 40 42 11 80    	mov    %ecx,0x80114240
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a0e:	88 9f c0 3c 11 80    	mov    %bl,-0x7feec340(%edi)
      p += sizeof(struct mpproc);
80103a14:	83 c0 14             	add    $0x14,%eax
      continue;
80103a17:	e9 54 ff ff ff       	jmp    80103970 <mpinit+0xf0>
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a2a:	e8 d1 fd ff ff       	call   80103800 <mpsearch1>
80103a2f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a31:	85 c0                	test   %eax,%eax
80103a33:	0f 85 9b fe ff ff    	jne    801038d4 <mpinit+0x54>
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 42 7d 10 80       	push   $0x80107d42
80103a48:	e8 43 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 5c 7d 10 80       	push   $0x80107d5c
80103a55:	e8 36 c9 ff ff       	call   80100390 <panic>
80103a5a:	66 90                	xchg   %ax,%ax
80103a5c:	66 90                	xchg   %ax,%ax
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a69:	ba 21 00 00 00       	mov    $0x21,%edx
80103a6e:	ee                   	out    %al,(%dx)
80103a6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a75:	c3                   	ret    
80103a76:	66 90                	xchg   %ax,%ax
80103a78:	66 90                	xchg   %ax,%ax
80103a7a:	66 90                	xchg   %ax,%ax
80103a7c:	66 90                	xchg   %ax,%ax
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	57                   	push   %edi
80103a88:	56                   	push   %esi
80103a89:	53                   	push   %ebx
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a90:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a99:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a9f:	e8 ec d9 ff ff       	call   80101490 <filealloc>
80103aa4:	89 03                	mov    %eax,(%ebx)
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	0f 84 ac 00 00 00    	je     80103b5a <pipealloc+0xda>
80103aae:	e8 dd d9 ff ff       	call   80101490 <filealloc>
80103ab3:	89 06                	mov    %eax,(%esi)
80103ab5:	85 c0                	test   %eax,%eax
80103ab7:	0f 84 8b 00 00 00    	je     80103b48 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103abd:	e8 fe f1 ff ff       	call   80102cc0 <kalloc>
80103ac2:	89 c7                	mov    %eax,%edi
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	0f 84 b4 00 00 00    	je     80103b80 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103acc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ad3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ad6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ad9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ae0:	00 00 00 
  p->nwrite = 0;
80103ae3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103aea:	00 00 00 
  p->nread = 0;
80103aed:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103af4:	00 00 00 
  initlock(&p->lock, "pipe");
80103af7:	68 7b 7d 10 80       	push   $0x80107d7b
80103afc:	50                   	push   %eax
80103afd:	e8 fe 0f 00 00       	call   80104b00 <initlock>
  (*f0)->type = FD_PIPE;
80103b02:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b04:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b07:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b0d:	8b 03                	mov    (%ebx),%eax
80103b0f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b13:	8b 03                	mov    (%ebx),%eax
80103b15:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b19:	8b 03                	mov    (%ebx),%eax
80103b1b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b1e:	8b 06                	mov    (%esi),%eax
80103b20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b26:	8b 06                	mov    (%esi),%eax
80103b28:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b2c:	8b 06                	mov    (%esi),%eax
80103b2e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b32:	8b 06                	mov    (%esi),%eax
80103b34:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b3a:	31 c0                	xor    %eax,%eax
}
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b48:	8b 03                	mov    (%ebx),%eax
80103b4a:	85 c0                	test   %eax,%eax
80103b4c:	74 1e                	je     80103b6c <pipealloc+0xec>
    fileclose(*f0);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	50                   	push   %eax
80103b52:	e8 f9 d9 ff ff       	call   80101550 <fileclose>
80103b57:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b5a:	8b 06                	mov    (%esi),%eax
80103b5c:	85 c0                	test   %eax,%eax
80103b5e:	74 0c                	je     80103b6c <pipealloc+0xec>
    fileclose(*f1);
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	50                   	push   %eax
80103b64:	e8 e7 d9 ff ff       	call   80101550 <fileclose>
80103b69:	83 c4 10             	add    $0x10,%esp
}
80103b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b74:	5b                   	pop    %ebx
80103b75:	5e                   	pop    %esi
80103b76:	5f                   	pop    %edi
80103b77:	5d                   	pop    %ebp
80103b78:	c3                   	ret    
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b80:	8b 03                	mov    (%ebx),%eax
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 c8                	jne    80103b4e <pipealloc+0xce>
80103b86:	eb d2                	jmp    80103b5a <pipealloc+0xda>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	56                   	push   %esi
80103b98:	53                   	push   %ebx
80103b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b9f:	83 ec 0c             	sub    $0xc,%esp
80103ba2:	53                   	push   %ebx
80103ba3:	e8 d8 10 00 00       	call   80104c80 <acquire>
  if(writable){
80103ba8:	83 c4 10             	add    $0x10,%esp
80103bab:	85 f6                	test   %esi,%esi
80103bad:	74 41                	je     80103bf0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103baf:	83 ec 0c             	sub    $0xc,%esp
80103bb2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103bb8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bbf:	00 00 00 
    wakeup(&p->nread);
80103bc2:	50                   	push   %eax
80103bc3:	e8 a8 0b 00 00       	call   80104770 <wakeup>
80103bc8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bcb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bd1:	85 d2                	test   %edx,%edx
80103bd3:	75 0a                	jne    80103bdf <pipeclose+0x4f>
80103bd5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	74 31                	je     80103c10 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103bdf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be5:	5b                   	pop    %ebx
80103be6:	5e                   	pop    %esi
80103be7:	5d                   	pop    %ebp
    release(&p->lock);
80103be8:	e9 53 11 00 00       	jmp    80104d40 <release>
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103bf9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c00:	00 00 00 
    wakeup(&p->nwrite);
80103c03:	50                   	push   %eax
80103c04:	e8 67 0b 00 00       	call   80104770 <wakeup>
80103c09:	83 c4 10             	add    $0x10,%esp
80103c0c:	eb bd                	jmp    80103bcb <pipeclose+0x3b>
80103c0e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	53                   	push   %ebx
80103c14:	e8 27 11 00 00       	call   80104d40 <release>
    kfree((char*)p);
80103c19:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c1c:	83 c4 10             	add    $0x10,%esp
}
80103c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c22:	5b                   	pop    %ebx
80103c23:	5e                   	pop    %esi
80103c24:	5d                   	pop    %ebp
    kfree((char*)p);
80103c25:	e9 d6 ee ff ff       	jmp    80102b00 <kfree>
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	57                   	push   %edi
80103c38:	56                   	push   %esi
80103c39:	53                   	push   %ebx
80103c3a:	83 ec 28             	sub    $0x28,%esp
80103c3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c40:	53                   	push   %ebx
80103c41:	e8 3a 10 00 00       	call   80104c80 <acquire>
  for(i = 0; i < n; i++){
80103c46:	8b 45 10             	mov    0x10(%ebp),%eax
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	85 c0                	test   %eax,%eax
80103c4e:	0f 8e bc 00 00 00    	jle    80103d10 <pipewrite+0xe0>
80103c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c57:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c5d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c66:	03 45 10             	add    0x10(%ebp),%eax
80103c69:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c6c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c72:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c78:	89 ca                	mov    %ecx,%edx
80103c7a:	05 00 02 00 00       	add    $0x200,%eax
80103c7f:	39 c1                	cmp    %eax,%ecx
80103c81:	74 3b                	je     80103cbe <pipewrite+0x8e>
80103c83:	eb 63                	jmp    80103ce8 <pipewrite+0xb8>
80103c85:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c88:	e8 63 03 00 00       	call   80103ff0 <myproc>
80103c8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c90:	85 c9                	test   %ecx,%ecx
80103c92:	75 34                	jne    80103cc8 <pipewrite+0x98>
      wakeup(&p->nread);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	57                   	push   %edi
80103c98:	e8 d3 0a 00 00       	call   80104770 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c9d:	58                   	pop    %eax
80103c9e:	5a                   	pop    %edx
80103c9f:	53                   	push   %ebx
80103ca0:	56                   	push   %esi
80103ca1:	e8 0a 09 00 00       	call   801045b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ca6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	05 00 02 00 00       	add    $0x200,%eax
80103cba:	39 c2                	cmp    %eax,%edx
80103cbc:	75 2a                	jne    80103ce8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103cbe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	75 c0                	jne    80103c88 <pipewrite+0x58>
        release(&p->lock);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	53                   	push   %ebx
80103ccc:	e8 6f 10 00 00       	call   80104d40 <release>
        return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cdc:	5b                   	pop    %ebx
80103cdd:	5e                   	pop    %esi
80103cde:	5f                   	pop    %edi
80103cdf:	5d                   	pop    %ebp
80103ce0:	c3                   	ret    
80103ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ce8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ceb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cf4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103cfa:	0f b6 06             	movzbl (%esi),%eax
80103cfd:	83 c6 01             	add    $0x1,%esi
80103d00:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103d03:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d07:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d0a:	0f 85 5c ff ff ff    	jne    80103c6c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d19:	50                   	push   %eax
80103d1a:	e8 51 0a 00 00       	call   80104770 <wakeup>
  release(&p->lock);
80103d1f:	89 1c 24             	mov    %ebx,(%esp)
80103d22:	e8 19 10 00 00       	call   80104d40 <release>
  return n;
80103d27:	8b 45 10             	mov    0x10(%ebp),%eax
80103d2a:	83 c4 10             	add    $0x10,%esp
80103d2d:	eb aa                	jmp    80103cd9 <pipewrite+0xa9>
80103d2f:	90                   	nop

80103d30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	57                   	push   %edi
80103d38:	56                   	push   %esi
80103d39:	53                   	push   %ebx
80103d3a:	83 ec 18             	sub    $0x18,%esp
80103d3d:	8b 75 08             	mov    0x8(%ebp),%esi
80103d40:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d43:	56                   	push   %esi
80103d44:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d4a:	e8 31 0f 00 00       	call   80104c80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d4f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103d5e:	74 33                	je     80103d93 <piperead+0x63>
80103d60:	eb 3b                	jmp    80103d9d <piperead+0x6d>
80103d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103d68:	e8 83 02 00 00       	call   80103ff0 <myproc>
80103d6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d70:	85 c9                	test   %ecx,%ecx
80103d72:	0f 85 88 00 00 00    	jne    80103e00 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d78:	83 ec 08             	sub    $0x8,%esp
80103d7b:	56                   	push   %esi
80103d7c:	53                   	push   %ebx
80103d7d:	e8 2e 08 00 00       	call   801045b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d82:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d91:	75 0a                	jne    80103d9d <piperead+0x6d>
80103d93:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d99:	85 c0                	test   %eax,%eax
80103d9b:	75 cb                	jne    80103d68 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d9d:	8b 55 10             	mov    0x10(%ebp),%edx
80103da0:	31 db                	xor    %ebx,%ebx
80103da2:	85 d2                	test   %edx,%edx
80103da4:	7f 28                	jg     80103dce <piperead+0x9e>
80103da6:	eb 34                	jmp    80103ddc <piperead+0xac>
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103db0:	8d 48 01             	lea    0x1(%eax),%ecx
80103db3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103db8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103dbe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103dc3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dc6:	83 c3 01             	add    $0x1,%ebx
80103dc9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103dcc:	74 0e                	je     80103ddc <piperead+0xac>
    if(p->nread == p->nwrite)
80103dce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103dd4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103dda:	75 d4                	jne    80103db0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103ddc:	83 ec 0c             	sub    $0xc,%esp
80103ddf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103de5:	50                   	push   %eax
80103de6:	e8 85 09 00 00       	call   80104770 <wakeup>
  release(&p->lock);
80103deb:	89 34 24             	mov    %esi,(%esp)
80103dee:	e8 4d 0f 00 00       	call   80104d40 <release>
  return i;
80103df3:	83 c4 10             	add    $0x10,%esp
}
80103df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df9:	89 d8                	mov    %ebx,%eax
80103dfb:	5b                   	pop    %ebx
80103dfc:	5e                   	pop    %esi
80103dfd:	5f                   	pop    %edi
80103dfe:	5d                   	pop    %ebp
80103dff:	c3                   	ret    
      release(&p->lock);
80103e00:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e08:	56                   	push   %esi
80103e09:	e8 32 0f 00 00       	call   80104d40 <release>
      return -1;
80103e0e:	83 c4 10             	add    $0x10,%esp
}
80103e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e14:	89 d8                	mov    %ebx,%eax
80103e16:	5b                   	pop    %ebx
80103e17:	5e                   	pop    %esi
80103e18:	5f                   	pop    %edi
80103e19:	5d                   	pop    %ebp
80103e1a:	c3                   	ret    
80103e1b:	66 90                	xchg   %ax,%ax
80103e1d:	66 90                	xchg   %ax,%ax
80103e1f:	90                   	nop

80103e20 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e24:	bb 94 42 11 80       	mov    $0x80114294,%ebx
{
80103e29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e2c:	68 60 42 11 80       	push   $0x80114260
80103e31:	e8 4a 0e 00 00       	call   80104c80 <acquire>
80103e36:	83 c4 10             	add    $0x10,%esp
80103e39:	eb 10                	jmp    80103e4b <allocproc+0x2b>
80103e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e40:	83 c3 7c             	add    $0x7c,%ebx
80103e43:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80103e49:	74 75                	je     80103ec0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103e4b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e4e:	85 c0                	test   %eax,%eax
80103e50:	75 ee                	jne    80103e40 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e52:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103e57:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e5a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e61:	89 43 10             	mov    %eax,0x10(%ebx)
80103e64:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103e67:	68 60 42 11 80       	push   $0x80114260
  p->pid = nextpid++;
80103e6c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103e72:	e8 c9 0e 00 00       	call   80104d40 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e77:	e8 44 ee ff ff       	call   80102cc0 <kalloc>
80103e7c:	83 c4 10             	add    $0x10,%esp
80103e7f:	89 43 08             	mov    %eax,0x8(%ebx)
80103e82:	85 c0                	test   %eax,%eax
80103e84:	74 53                	je     80103ed9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e86:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e8c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e8f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e94:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e97:	c7 40 14 ef 5f 10 80 	movl   $0x80105fef,0x14(%eax)
  p->context = (struct context*)sp;
80103e9e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ea1:	6a 14                	push   $0x14
80103ea3:	6a 00                	push   $0x0
80103ea5:	50                   	push   %eax
80103ea6:	e8 e5 0e 00 00       	call   80104d90 <memset>
  p->context->eip = (uint)forkret;
80103eab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103eae:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103eb1:	c7 40 10 f0 3e 10 80 	movl   $0x80103ef0,0x10(%eax)
}
80103eb8:	89 d8                	mov    %ebx,%eax
80103eba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ebd:	c9                   	leave  
80103ebe:	c3                   	ret    
80103ebf:	90                   	nop
  release(&ptable.lock);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ec3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ec5:	68 60 42 11 80       	push   $0x80114260
80103eca:	e8 71 0e 00 00       	call   80104d40 <release>
}
80103ecf:	89 d8                	mov    %ebx,%eax
  return 0;
80103ed1:	83 c4 10             	add    $0x10,%esp
}
80103ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed7:	c9                   	leave  
80103ed8:	c3                   	ret    
    p->state = UNUSED;
80103ed9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ee0:	31 db                	xor    %ebx,%ebx
}
80103ee2:	89 d8                	mov    %ebx,%eax
80103ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee7:	c9                   	leave  
80103ee8:	c3                   	ret    
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103efa:	68 60 42 11 80       	push   $0x80114260
80103eff:	e8 3c 0e 00 00       	call   80104d40 <release>

  if (first) {
80103f04:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103f09:	83 c4 10             	add    $0x10,%esp
80103f0c:	85 c0                	test   %eax,%eax
80103f0e:	75 08                	jne    80103f18 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f10:	c9                   	leave  
80103f11:	c3                   	ret    
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103f18:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103f1f:	00 00 00 
    iinit(ROOTDEV);
80103f22:	83 ec 0c             	sub    $0xc,%esp
80103f25:	6a 01                	push   $0x1
80103f27:	e8 a4 dc ff ff       	call   80101bd0 <iinit>
    initlog(ROOTDEV);
80103f2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f33:	e8 e8 f3 ff ff       	call   80103320 <initlog>
}
80103f38:	83 c4 10             	add    $0x10,%esp
80103f3b:	c9                   	leave  
80103f3c:	c3                   	ret    
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi

80103f40 <pinit>:
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f4a:	68 80 7d 10 80       	push   $0x80107d80
80103f4f:	68 60 42 11 80       	push   $0x80114260
80103f54:	e8 a7 0b 00 00       	call   80104b00 <initlock>
}
80103f59:	83 c4 10             	add    $0x10,%esp
80103f5c:	c9                   	leave  
80103f5d:	c3                   	ret    
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <mycpu>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	56                   	push   %esi
80103f68:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f69:	9c                   	pushf  
80103f6a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f6b:	f6 c4 02             	test   $0x2,%ah
80103f6e:	75 4a                	jne    80103fba <mycpu+0x5a>
  apicid = lapicid();
80103f70:	e8 bb ef ff ff       	call   80102f30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103f75:	8b 35 40 42 11 80    	mov    0x80114240,%esi
  apicid = lapicid();
80103f7b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103f7d:	85 f6                	test   %esi,%esi
80103f7f:	7e 2c                	jle    80103fad <mycpu+0x4d>
80103f81:	31 d2                	xor    %edx,%edx
80103f83:	eb 0a                	jmp    80103f8f <mycpu+0x2f>
80103f85:	8d 76 00             	lea    0x0(%esi),%esi
80103f88:	83 c2 01             	add    $0x1,%edx
80103f8b:	39 f2                	cmp    %esi,%edx
80103f8d:	74 1e                	je     80103fad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103f8f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103f95:	0f b6 81 c0 3c 11 80 	movzbl -0x7feec340(%ecx),%eax
80103f9c:	39 d8                	cmp    %ebx,%eax
80103f9e:	75 e8                	jne    80103f88 <mycpu+0x28>
}
80103fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103fa3:	8d 81 c0 3c 11 80    	lea    -0x7feec340(%ecx),%eax
}
80103fa9:	5b                   	pop    %ebx
80103faa:	5e                   	pop    %esi
80103fab:	5d                   	pop    %ebp
80103fac:	c3                   	ret    
  panic("unknown apicid\n");
80103fad:	83 ec 0c             	sub    $0xc,%esp
80103fb0:	68 87 7d 10 80       	push   $0x80107d87
80103fb5:	e8 d6 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 64 7e 10 80       	push   $0x80107e64
80103fc2:	e8 c9 c3 ff ff       	call   80100390 <panic>
80103fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fce:	66 90                	xchg   %ax,%ax

80103fd0 <cpuid>:
cpuid() {
80103fd0:	f3 0f 1e fb          	endbr32 
80103fd4:	55                   	push   %ebp
80103fd5:	89 e5                	mov    %esp,%ebp
80103fd7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103fda:	e8 81 ff ff ff       	call   80103f60 <mycpu>
}
80103fdf:	c9                   	leave  
  return mycpu()-cpus;
80103fe0:	2d c0 3c 11 80       	sub    $0x80113cc0,%eax
80103fe5:	c1 f8 04             	sar    $0x4,%eax
80103fe8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103fee:	c3                   	ret    
80103fef:	90                   	nop

80103ff0 <myproc>:
myproc(void) {
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	53                   	push   %ebx
80103ff8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ffb:	e8 80 0b 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104000:	e8 5b ff ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104005:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010400b:	e8 c0 0b 00 00       	call   80104bd0 <popcli>
}
80104010:	83 c4 04             	add    $0x4,%esp
80104013:	89 d8                	mov    %ebx,%eax
80104015:	5b                   	pop    %ebx
80104016:	5d                   	pop    %ebp
80104017:	c3                   	ret    
80104018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop

80104020 <userinit>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	53                   	push   %ebx
80104028:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010402b:	e8 f0 fd ff ff       	call   80103e20 <allocproc>
80104030:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104032:	a3 f8 b5 10 80       	mov    %eax,0x8010b5f8
  if((p->pgdir = setupkvm()) == 0)
80104037:	e8 74 35 00 00       	call   801075b0 <setupkvm>
8010403c:	89 43 04             	mov    %eax,0x4(%ebx)
8010403f:	85 c0                	test   %eax,%eax
80104041:	0f 84 bd 00 00 00    	je     80104104 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104047:	83 ec 04             	sub    $0x4,%esp
8010404a:	68 2c 00 00 00       	push   $0x2c
8010404f:	68 60 b4 10 80       	push   $0x8010b460
80104054:	50                   	push   %eax
80104055:	e8 26 32 00 00       	call   80107280 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010405a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010405d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104063:	6a 4c                	push   $0x4c
80104065:	6a 00                	push   $0x0
80104067:	ff 73 18             	pushl  0x18(%ebx)
8010406a:	e8 21 0d 00 00       	call   80104d90 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010406f:	8b 43 18             	mov    0x18(%ebx),%eax
80104072:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104077:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010407a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010407f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104083:	8b 43 18             	mov    0x18(%ebx),%eax
80104086:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010408a:	8b 43 18             	mov    0x18(%ebx),%eax
8010408d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104091:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104095:	8b 43 18             	mov    0x18(%ebx),%eax
80104098:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010409c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040a0:	8b 43 18             	mov    0x18(%ebx),%eax
801040a3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040aa:	8b 43 18             	mov    0x18(%ebx),%eax
801040ad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801040b4:	8b 43 18             	mov    0x18(%ebx),%eax
801040b7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040be:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040c1:	6a 10                	push   $0x10
801040c3:	68 b0 7d 10 80       	push   $0x80107db0
801040c8:	50                   	push   %eax
801040c9:	e8 82 0e 00 00       	call   80104f50 <safestrcpy>
  p->cwd = namei("/");
801040ce:	c7 04 24 b9 7d 10 80 	movl   $0x80107db9,(%esp)
801040d5:	e8 e6 e5 ff ff       	call   801026c0 <namei>
801040da:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801040dd:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801040e4:	e8 97 0b 00 00       	call   80104c80 <acquire>
  p->state = RUNNABLE;
801040e9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801040f0:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801040f7:	e8 44 0c 00 00       	call   80104d40 <release>
}
801040fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ff:	83 c4 10             	add    $0x10,%esp
80104102:	c9                   	leave  
80104103:	c3                   	ret    
    panic("userinit: out of memory?");
80104104:	83 ec 0c             	sub    $0xc,%esp
80104107:	68 97 7d 10 80       	push   $0x80107d97
8010410c:	e8 7f c2 ff ff       	call   80100390 <panic>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <growproc>:
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	56                   	push   %esi
80104128:	53                   	push   %ebx
80104129:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010412c:	e8 4f 0a 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104131:	e8 2a fe ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104136:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413c:	e8 8f 0a 00 00       	call   80104bd0 <popcli>
  sz = curproc->sz;
80104141:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104143:	85 f6                	test   %esi,%esi
80104145:	7f 19                	jg     80104160 <growproc+0x40>
  } else if(n < 0){
80104147:	75 37                	jne    80104180 <growproc+0x60>
  switchuvm(curproc);
80104149:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010414c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010414e:	53                   	push   %ebx
8010414f:	e8 1c 30 00 00       	call   80107170 <switchuvm>
  return 0;
80104154:	83 c4 10             	add    $0x10,%esp
80104157:	31 c0                	xor    %eax,%eax
}
80104159:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010415c:	5b                   	pop    %ebx
8010415d:	5e                   	pop    %esi
8010415e:	5d                   	pop    %ebp
8010415f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104160:	83 ec 04             	sub    $0x4,%esp
80104163:	01 c6                	add    %eax,%esi
80104165:	56                   	push   %esi
80104166:	50                   	push   %eax
80104167:	ff 73 04             	pushl  0x4(%ebx)
8010416a:	e8 61 32 00 00       	call   801073d0 <allocuvm>
8010416f:	83 c4 10             	add    $0x10,%esp
80104172:	85 c0                	test   %eax,%eax
80104174:	75 d3                	jne    80104149 <growproc+0x29>
      return -1;
80104176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010417b:	eb dc                	jmp    80104159 <growproc+0x39>
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104180:	83 ec 04             	sub    $0x4,%esp
80104183:	01 c6                	add    %eax,%esi
80104185:	56                   	push   %esi
80104186:	50                   	push   %eax
80104187:	ff 73 04             	pushl  0x4(%ebx)
8010418a:	e8 71 33 00 00       	call   80107500 <deallocuvm>
8010418f:	83 c4 10             	add    $0x10,%esp
80104192:	85 c0                	test   %eax,%eax
80104194:	75 b3                	jne    80104149 <growproc+0x29>
80104196:	eb de                	jmp    80104176 <growproc+0x56>
80104198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop

801041a0 <fork>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	57                   	push   %edi
801041a8:	56                   	push   %esi
801041a9:	53                   	push   %ebx
801041aa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041ad:	e8 ce 09 00 00       	call   80104b80 <pushcli>
  c = mycpu();
801041b2:	e8 a9 fd ff ff       	call   80103f60 <mycpu>
  p = c->proc;
801041b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bd:	e8 0e 0a 00 00       	call   80104bd0 <popcli>
  if((np = allocproc()) == 0){
801041c2:	e8 59 fc ff ff       	call   80103e20 <allocproc>
801041c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801041ca:	85 c0                	test   %eax,%eax
801041cc:	0f 84 bb 00 00 00    	je     8010428d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801041d2:	83 ec 08             	sub    $0x8,%esp
801041d5:	ff 33                	pushl  (%ebx)
801041d7:	89 c7                	mov    %eax,%edi
801041d9:	ff 73 04             	pushl  0x4(%ebx)
801041dc:	e8 9f 34 00 00       	call   80107680 <copyuvm>
801041e1:	83 c4 10             	add    $0x10,%esp
801041e4:	89 47 04             	mov    %eax,0x4(%edi)
801041e7:	85 c0                	test   %eax,%eax
801041e9:	0f 84 a5 00 00 00    	je     80104294 <fork+0xf4>
  np->sz = curproc->sz;
801041ef:	8b 03                	mov    (%ebx),%eax
801041f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801041f4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801041f6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801041f9:	89 c8                	mov    %ecx,%eax
801041fb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801041fe:	b9 13 00 00 00       	mov    $0x13,%ecx
80104203:	8b 73 18             	mov    0x18(%ebx),%esi
80104206:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104208:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010420a:	8b 40 18             	mov    0x18(%eax),%eax
8010420d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104218:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010421c:	85 c0                	test   %eax,%eax
8010421e:	74 13                	je     80104233 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	50                   	push   %eax
80104224:	e8 d7 d2 ff ff       	call   80101500 <filedup>
80104229:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010422c:	83 c4 10             	add    $0x10,%esp
8010422f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104233:	83 c6 01             	add    $0x1,%esi
80104236:	83 fe 10             	cmp    $0x10,%esi
80104239:	75 dd                	jne    80104218 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010423b:	83 ec 0c             	sub    $0xc,%esp
8010423e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104241:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104244:	e8 77 db ff ff       	call   80101dc0 <idup>
80104249:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010424c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010424f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104252:	8d 47 6c             	lea    0x6c(%edi),%eax
80104255:	6a 10                	push   $0x10
80104257:	53                   	push   %ebx
80104258:	50                   	push   %eax
80104259:	e8 f2 0c 00 00       	call   80104f50 <safestrcpy>
  pid = np->pid;
8010425e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104261:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80104268:	e8 13 0a 00 00       	call   80104c80 <acquire>
  np->state = RUNNABLE;
8010426d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104274:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
8010427b:	e8 c0 0a 00 00       	call   80104d40 <release>
  return pid;
80104280:	83 c4 10             	add    $0x10,%esp
}
80104283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104286:	89 d8                	mov    %ebx,%eax
80104288:	5b                   	pop    %ebx
80104289:	5e                   	pop    %esi
8010428a:	5f                   	pop    %edi
8010428b:	5d                   	pop    %ebp
8010428c:	c3                   	ret    
    return -1;
8010428d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104292:	eb ef                	jmp    80104283 <fork+0xe3>
    kfree(np->kstack);
80104294:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	ff 73 08             	pushl  0x8(%ebx)
8010429d:	e8 5e e8 ff ff       	call   80102b00 <kfree>
    np->kstack = 0;
801042a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801042a9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801042ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801042b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801042b8:	eb c9                	jmp    80104283 <fork+0xe3>
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <scheduler>:
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	57                   	push   %edi
801042c8:	56                   	push   %esi
801042c9:	53                   	push   %ebx
801042ca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801042cd:	e8 8e fc ff ff       	call   80103f60 <mycpu>
  c->proc = 0;
801042d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042d9:	00 00 00 
  struct cpu *c = mycpu();
801042dc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801042de:	8d 78 04             	lea    0x4(%eax),%edi
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801042e8:	fb                   	sti    
    acquire(&ptable.lock);
801042e9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ec:	bb 94 42 11 80       	mov    $0x80114294,%ebx
    acquire(&ptable.lock);
801042f1:	68 60 42 11 80       	push   $0x80114260
801042f6:	e8 85 09 00 00       	call   80104c80 <acquire>
801042fb:	83 c4 10             	add    $0x10,%esp
801042fe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104300:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104304:	75 33                	jne    80104339 <scheduler+0x79>
      switchuvm(p);
80104306:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104309:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010430f:	53                   	push   %ebx
80104310:	e8 5b 2e 00 00       	call   80107170 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104315:	58                   	pop    %eax
80104316:	5a                   	pop    %edx
80104317:	ff 73 1c             	pushl  0x1c(%ebx)
8010431a:	57                   	push   %edi
      p->state = RUNNING;
8010431b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104322:	e8 8c 0c 00 00       	call   80104fb3 <swtch>
      switchkvm();
80104327:	e8 24 2e 00 00       	call   80107150 <switchkvm>
      c->proc = 0;
8010432c:	83 c4 10             	add    $0x10,%esp
8010432f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104336:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104339:	83 c3 7c             	add    $0x7c,%ebx
8010433c:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80104342:	75 bc                	jne    80104300 <scheduler+0x40>
    release(&ptable.lock);
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	68 60 42 11 80       	push   $0x80114260
8010434c:	e8 ef 09 00 00       	call   80104d40 <release>
    sti();
80104351:	83 c4 10             	add    $0x10,%esp
80104354:	eb 92                	jmp    801042e8 <scheduler+0x28>
80104356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435d:	8d 76 00             	lea    0x0(%esi),%esi

80104360 <sched>:
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	56                   	push   %esi
80104368:	53                   	push   %ebx
  pushcli();
80104369:	e8 12 08 00 00       	call   80104b80 <pushcli>
  c = mycpu();
8010436e:	e8 ed fb ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104373:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104379:	e8 52 08 00 00       	call   80104bd0 <popcli>
  if(!holding(&ptable.lock))
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	68 60 42 11 80       	push   $0x80114260
80104386:	e8 a5 08 00 00       	call   80104c30 <holding>
8010438b:	83 c4 10             	add    $0x10,%esp
8010438e:	85 c0                	test   %eax,%eax
80104390:	74 4f                	je     801043e1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104392:	e8 c9 fb ff ff       	call   80103f60 <mycpu>
80104397:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010439e:	75 68                	jne    80104408 <sched+0xa8>
  if(p->state == RUNNING)
801043a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801043a4:	74 55                	je     801043fb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043a6:	9c                   	pushf  
801043a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043a8:	f6 c4 02             	test   $0x2,%ah
801043ab:	75 41                	jne    801043ee <sched+0x8e>
  intena = mycpu()->intena;
801043ad:	e8 ae fb ff ff       	call   80103f60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801043b2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801043b5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801043bb:	e8 a0 fb ff ff       	call   80103f60 <mycpu>
801043c0:	83 ec 08             	sub    $0x8,%esp
801043c3:	ff 70 04             	pushl  0x4(%eax)
801043c6:	53                   	push   %ebx
801043c7:	e8 e7 0b 00 00       	call   80104fb3 <swtch>
  mycpu()->intena = intena;
801043cc:	e8 8f fb ff ff       	call   80103f60 <mycpu>
}
801043d1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801043d4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801043da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043dd:	5b                   	pop    %ebx
801043de:	5e                   	pop    %esi
801043df:	5d                   	pop    %ebp
801043e0:	c3                   	ret    
    panic("sched ptable.lock");
801043e1:	83 ec 0c             	sub    $0xc,%esp
801043e4:	68 bb 7d 10 80       	push   $0x80107dbb
801043e9:	e8 a2 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	68 e7 7d 10 80       	push   $0x80107de7
801043f6:	e8 95 bf ff ff       	call   80100390 <panic>
    panic("sched running");
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	68 d9 7d 10 80       	push   $0x80107dd9
80104403:	e8 88 bf ff ff       	call   80100390 <panic>
    panic("sched locks");
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 cd 7d 10 80       	push   $0x80107dcd
80104410:	e8 7b bf ff ff       	call   80100390 <panic>
80104415:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104420 <exit>:
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	57                   	push   %edi
80104428:	56                   	push   %esi
80104429:	53                   	push   %ebx
8010442a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010442d:	e8 4e 07 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104432:	e8 29 fb ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104437:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010443d:	e8 8e 07 00 00       	call   80104bd0 <popcli>
  if(curproc == initproc)
80104442:	8d 5e 28             	lea    0x28(%esi),%ebx
80104445:	8d 7e 68             	lea    0x68(%esi),%edi
80104448:	39 35 f8 b5 10 80    	cmp    %esi,0x8010b5f8
8010444e:	0f 84 f3 00 00 00    	je     80104547 <exit+0x127>
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104458:	8b 03                	mov    (%ebx),%eax
8010445a:	85 c0                	test   %eax,%eax
8010445c:	74 12                	je     80104470 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010445e:	83 ec 0c             	sub    $0xc,%esp
80104461:	50                   	push   %eax
80104462:	e8 e9 d0 ff ff       	call   80101550 <fileclose>
      curproc->ofile[fd] = 0;
80104467:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010446d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104470:	83 c3 04             	add    $0x4,%ebx
80104473:	39 df                	cmp    %ebx,%edi
80104475:	75 e1                	jne    80104458 <exit+0x38>
  begin_op();
80104477:	e8 44 ef ff ff       	call   801033c0 <begin_op>
  iput(curproc->cwd);
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	ff 76 68             	pushl  0x68(%esi)
80104482:	e8 99 da ff ff       	call   80101f20 <iput>
  end_op();
80104487:	e8 a4 ef ff ff       	call   80103430 <end_op>
  curproc->cwd = 0;
8010448c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104493:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
8010449a:	e8 e1 07 00 00       	call   80104c80 <acquire>
  wakeup1(curproc->parent);
8010449f:	8b 56 14             	mov    0x14(%esi),%edx
801044a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a5:	b8 94 42 11 80       	mov    $0x80114294,%eax
801044aa:	eb 0e                	jmp    801044ba <exit+0x9a>
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b0:	83 c0 7c             	add    $0x7c,%eax
801044b3:	3d 94 61 11 80       	cmp    $0x80116194,%eax
801044b8:	74 1c                	je     801044d6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801044ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044be:	75 f0                	jne    801044b0 <exit+0x90>
801044c0:	3b 50 20             	cmp    0x20(%eax),%edx
801044c3:	75 eb                	jne    801044b0 <exit+0x90>
      p->state = RUNNABLE;
801044c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044cc:	83 c0 7c             	add    $0x7c,%eax
801044cf:	3d 94 61 11 80       	cmp    $0x80116194,%eax
801044d4:	75 e4                	jne    801044ba <exit+0x9a>
      p->parent = initproc;
801044d6:	8b 0d f8 b5 10 80    	mov    0x8010b5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044dc:	ba 94 42 11 80       	mov    $0x80114294,%edx
801044e1:	eb 10                	jmp    801044f3 <exit+0xd3>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
801044e8:	83 c2 7c             	add    $0x7c,%edx
801044eb:	81 fa 94 61 11 80    	cmp    $0x80116194,%edx
801044f1:	74 3b                	je     8010452e <exit+0x10e>
    if(p->parent == curproc){
801044f3:	39 72 14             	cmp    %esi,0x14(%edx)
801044f6:	75 f0                	jne    801044e8 <exit+0xc8>
      if(p->state == ZOMBIE)
801044f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801044ff:	75 e7                	jne    801044e8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104501:	b8 94 42 11 80       	mov    $0x80114294,%eax
80104506:	eb 12                	jmp    8010451a <exit+0xfa>
80104508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450f:	90                   	nop
80104510:	83 c0 7c             	add    $0x7c,%eax
80104513:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104518:	74 ce                	je     801044e8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010451a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010451e:	75 f0                	jne    80104510 <exit+0xf0>
80104520:	3b 48 20             	cmp    0x20(%eax),%ecx
80104523:	75 eb                	jne    80104510 <exit+0xf0>
      p->state = RUNNABLE;
80104525:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010452c:	eb e2                	jmp    80104510 <exit+0xf0>
  curproc->state = ZOMBIE;
8010452e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104535:	e8 26 fe ff ff       	call   80104360 <sched>
  panic("zombie exit");
8010453a:	83 ec 0c             	sub    $0xc,%esp
8010453d:	68 08 7e 10 80       	push   $0x80107e08
80104542:	e8 49 be ff ff       	call   80100390 <panic>
    panic("init exiting");
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 fb 7d 10 80       	push   $0x80107dfb
8010454f:	e8 3c be ff ff       	call   80100390 <panic>
80104554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <yield>:
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	53                   	push   %ebx
80104568:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010456b:	68 60 42 11 80       	push   $0x80114260
80104570:	e8 0b 07 00 00       	call   80104c80 <acquire>
  pushcli();
80104575:	e8 06 06 00 00       	call   80104b80 <pushcli>
  c = mycpu();
8010457a:	e8 e1 f9 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
8010457f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104585:	e8 46 06 00 00       	call   80104bd0 <popcli>
  myproc()->state = RUNNABLE;
8010458a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104591:	e8 ca fd ff ff       	call   80104360 <sched>
  release(&ptable.lock);
80104596:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
8010459d:	e8 9e 07 00 00       	call   80104d40 <release>
}
801045a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a5:	83 c4 10             	add    $0x10,%esp
801045a8:	c9                   	leave  
801045a9:	c3                   	ret    
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <sleep>:
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	57                   	push   %edi
801045b8:	56                   	push   %esi
801045b9:	53                   	push   %ebx
801045ba:	83 ec 0c             	sub    $0xc,%esp
801045bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801045c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045c3:	e8 b8 05 00 00       	call   80104b80 <pushcli>
  c = mycpu();
801045c8:	e8 93 f9 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
801045cd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045d3:	e8 f8 05 00 00       	call   80104bd0 <popcli>
  if(p == 0)
801045d8:	85 db                	test   %ebx,%ebx
801045da:	0f 84 83 00 00 00    	je     80104663 <sleep+0xb3>
  if(lk == 0)
801045e0:	85 f6                	test   %esi,%esi
801045e2:	74 72                	je     80104656 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045e4:	81 fe 60 42 11 80    	cmp    $0x80114260,%esi
801045ea:	74 4c                	je     80104638 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 60 42 11 80       	push   $0x80114260
801045f4:	e8 87 06 00 00       	call   80104c80 <acquire>
    release(lk);
801045f9:	89 34 24             	mov    %esi,(%esp)
801045fc:	e8 3f 07 00 00       	call   80104d40 <release>
  p->chan = chan;
80104601:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104604:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010460b:	e8 50 fd ff ff       	call   80104360 <sched>
  p->chan = 0;
80104610:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104617:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
8010461e:	e8 1d 07 00 00       	call   80104d40 <release>
    acquire(lk);
80104623:	89 75 08             	mov    %esi,0x8(%ebp)
80104626:	83 c4 10             	add    $0x10,%esp
}
80104629:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010462c:	5b                   	pop    %ebx
8010462d:	5e                   	pop    %esi
8010462e:	5f                   	pop    %edi
8010462f:	5d                   	pop    %ebp
    acquire(lk);
80104630:	e9 4b 06 00 00       	jmp    80104c80 <acquire>
80104635:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104638:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010463b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104642:	e8 19 fd ff ff       	call   80104360 <sched>
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
80104659:	68 1a 7e 10 80       	push   $0x80107e1a
8010465e:	e8 2d bd ff ff       	call   80100390 <panic>
    panic("sleep");
80104663:	83 ec 0c             	sub    $0xc,%esp
80104666:	68 14 7e 10 80       	push   $0x80107e14
8010466b:	e8 20 bd ff ff       	call   80100390 <panic>

80104670 <wait>:
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	56                   	push   %esi
80104678:	53                   	push   %ebx
  pushcli();
80104679:	e8 02 05 00 00       	call   80104b80 <pushcli>
  c = mycpu();
8010467e:	e8 dd f8 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104683:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104689:	e8 42 05 00 00       	call   80104bd0 <popcli>
  acquire(&ptable.lock);
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	68 60 42 11 80       	push   $0x80114260
80104696:	e8 e5 05 00 00       	call   80104c80 <acquire>
8010469b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010469e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a0:	bb 94 42 11 80       	mov    $0x80114294,%ebx
801046a5:	eb 14                	jmp    801046bb <wait+0x4b>
801046a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ae:	66 90                	xchg   %ax,%ax
801046b0:	83 c3 7c             	add    $0x7c,%ebx
801046b3:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
801046b9:	74 1b                	je     801046d6 <wait+0x66>
      if(p->parent != curproc)
801046bb:	39 73 14             	cmp    %esi,0x14(%ebx)
801046be:	75 f0                	jne    801046b0 <wait+0x40>
      if(p->state == ZOMBIE){
801046c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046c4:	74 32                	je     801046f8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801046c9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ce:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
801046d4:	75 e5                	jne    801046bb <wait+0x4b>
    if(!havekids || curproc->killed){
801046d6:	85 c0                	test   %eax,%eax
801046d8:	74 74                	je     8010474e <wait+0xde>
801046da:	8b 46 24             	mov    0x24(%esi),%eax
801046dd:	85 c0                	test   %eax,%eax
801046df:	75 6d                	jne    8010474e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801046e1:	83 ec 08             	sub    $0x8,%esp
801046e4:	68 60 42 11 80       	push   $0x80114260
801046e9:	56                   	push   %esi
801046ea:	e8 c1 fe ff ff       	call   801045b0 <sleep>
    havekids = 0;
801046ef:	83 c4 10             	add    $0x10,%esp
801046f2:	eb aa                	jmp    8010469e <wait+0x2e>
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801046f8:	83 ec 0c             	sub    $0xc,%esp
801046fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801046fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104701:	e8 fa e3 ff ff       	call   80102b00 <kfree>
        freevm(p->pgdir);
80104706:	5a                   	pop    %edx
80104707:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010470a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104711:	e8 1a 2e 00 00       	call   80107530 <freevm>
        release(&ptable.lock);
80104716:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
        p->pid = 0;
8010471d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104724:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010472b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010472f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104736:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010473d:	e8 fe 05 00 00       	call   80104d40 <release>
        return pid;
80104742:	83 c4 10             	add    $0x10,%esp
}
80104745:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104748:	89 f0                	mov    %esi,%eax
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
8010474d:	c3                   	ret    
      release(&ptable.lock);
8010474e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104751:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104756:	68 60 42 11 80       	push   $0x80114260
8010475b:	e8 e0 05 00 00       	call   80104d40 <release>
      return -1;
80104760:	83 c4 10             	add    $0x10,%esp
80104763:	eb e0                	jmp    80104745 <wait+0xd5>
80104765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	53                   	push   %ebx
80104778:	83 ec 10             	sub    $0x10,%esp
8010477b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010477e:	68 60 42 11 80       	push   $0x80114260
80104783:	e8 f8 04 00 00       	call   80104c80 <acquire>
80104788:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010478b:	b8 94 42 11 80       	mov    $0x80114294,%eax
80104790:	eb 10                	jmp    801047a2 <wakeup+0x32>
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104798:	83 c0 7c             	add    $0x7c,%eax
8010479b:	3d 94 61 11 80       	cmp    $0x80116194,%eax
801047a0:	74 1c                	je     801047be <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801047a2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047a6:	75 f0                	jne    80104798 <wakeup+0x28>
801047a8:	3b 58 20             	cmp    0x20(%eax),%ebx
801047ab:	75 eb                	jne    80104798 <wakeup+0x28>
      p->state = RUNNABLE;
801047ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b4:	83 c0 7c             	add    $0x7c,%eax
801047b7:	3d 94 61 11 80       	cmp    $0x80116194,%eax
801047bc:	75 e4                	jne    801047a2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801047be:	c7 45 08 60 42 11 80 	movl   $0x80114260,0x8(%ebp)
}
801047c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c8:	c9                   	leave  
  release(&ptable.lock);
801047c9:	e9 72 05 00 00       	jmp    80104d40 <release>
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047d0:	f3 0f 1e fb          	endbr32 
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	53                   	push   %ebx
801047d8:	83 ec 10             	sub    $0x10,%esp
801047db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047de:	68 60 42 11 80       	push   $0x80114260
801047e3:	e8 98 04 00 00       	call   80104c80 <acquire>
801047e8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047eb:	b8 94 42 11 80       	mov    $0x80114294,%eax
801047f0:	eb 10                	jmp    80104802 <kill+0x32>
801047f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f8:	83 c0 7c             	add    $0x7c,%eax
801047fb:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104800:	74 36                	je     80104838 <kill+0x68>
    if(p->pid == pid){
80104802:	39 58 10             	cmp    %ebx,0x10(%eax)
80104805:	75 f1                	jne    801047f8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104807:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010480b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104812:	75 07                	jne    8010481b <kill+0x4b>
        p->state = RUNNABLE;
80104814:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	68 60 42 11 80       	push   $0x80114260
80104823:	e8 18 05 00 00       	call   80104d40 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010482b:	83 c4 10             	add    $0x10,%esp
8010482e:	31 c0                	xor    %eax,%eax
}
80104830:	c9                   	leave  
80104831:	c3                   	ret    
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 60 42 11 80       	push   $0x80114260
80104840:	e8 fb 04 00 00       	call   80104d40 <release>
}
80104845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104848:	83 c4 10             	add    $0x10,%esp
8010484b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104850:	c9                   	leave  
80104851:	c3                   	ret    
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104860 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	56                   	push   %esi
80104869:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010486c:	53                   	push   %ebx
8010486d:	bb 00 43 11 80       	mov    $0x80114300,%ebx
80104872:	83 ec 3c             	sub    $0x3c,%esp
80104875:	eb 28                	jmp    8010489f <procdump+0x3f>
80104877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 a7 81 10 80       	push   $0x801081a7
80104888:	e8 13 bf ff ff       	call   801007a0 <cprintf>
8010488d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104890:	83 c3 7c             	add    $0x7c,%ebx
80104893:	81 fb 00 62 11 80    	cmp    $0x80116200,%ebx
80104899:	0f 84 81 00 00 00    	je     80104920 <procdump+0xc0>
    if(p->state == UNUSED)
8010489f:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048a2:	85 c0                	test   %eax,%eax
801048a4:	74 ea                	je     80104890 <procdump+0x30>
      state = "???";
801048a6:	ba 2b 7e 10 80       	mov    $0x80107e2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048ab:	83 f8 05             	cmp    $0x5,%eax
801048ae:	77 11                	ja     801048c1 <procdump+0x61>
801048b0:	8b 14 85 8c 7e 10 80 	mov    -0x7fef8174(,%eax,4),%edx
      state = "???";
801048b7:	b8 2b 7e 10 80       	mov    $0x80107e2b,%eax
801048bc:	85 d2                	test   %edx,%edx
801048be:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048c1:	53                   	push   %ebx
801048c2:	52                   	push   %edx
801048c3:	ff 73 a4             	pushl  -0x5c(%ebx)
801048c6:	68 2f 7e 10 80       	push   $0x80107e2f
801048cb:	e8 d0 be ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
801048d0:	83 c4 10             	add    $0x10,%esp
801048d3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048d7:	75 a7                	jne    80104880 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048d9:	83 ec 08             	sub    $0x8,%esp
801048dc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048df:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048e2:	50                   	push   %eax
801048e3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048e6:	8b 40 0c             	mov    0xc(%eax),%eax
801048e9:	83 c0 08             	add    $0x8,%eax
801048ec:	50                   	push   %eax
801048ed:	e8 2e 02 00 00       	call   80104b20 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801048f2:	83 c4 10             	add    $0x10,%esp
801048f5:	8d 76 00             	lea    0x0(%esi),%esi
801048f8:	8b 17                	mov    (%edi),%edx
801048fa:	85 d2                	test   %edx,%edx
801048fc:	74 82                	je     80104880 <procdump+0x20>
        cprintf(" %p", pc[i]);
801048fe:	83 ec 08             	sub    $0x8,%esp
80104901:	83 c7 04             	add    $0x4,%edi
80104904:	52                   	push   %edx
80104905:	68 81 78 10 80       	push   $0x80107881
8010490a:	e8 91 be ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010490f:	83 c4 10             	add    $0x10,%esp
80104912:	39 fe                	cmp    %edi,%esi
80104914:	75 e2                	jne    801048f8 <procdump+0x98>
80104916:	e9 65 ff ff ff       	jmp    80104880 <procdump+0x20>
8010491b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
  }
}
80104920:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104923:	5b                   	pop    %ebx
80104924:	5e                   	pop    %esi
80104925:	5f                   	pop    %edi
80104926:	5d                   	pop    %ebp
80104927:	c3                   	ret    
80104928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <find_next_prime_number>:

int find_next_prime_number(int n)
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	56                   	push   %esi
80104938:	8b 75 08             	mov    0x8(%ebp),%esi
8010493b:	53                   	push   %ebx
8010493c:	bb 02 00 00 00       	mov    $0x2,%ebx
  int find=0, sol, match;
  if (n<=1)
80104941:	83 fe 01             	cmp    $0x1,%esi
80104944:	7e 2c                	jle    80104972 <find_next_prime_number+0x42>
80104946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
    return sol = 2;

  while (!find)
  {
    n++;
80104950:	8d 5e 01             	lea    0x1(%esi),%ebx
    match = 0;
    for (int i = 2; i < n; i++)
80104953:	b9 02 00 00 00       	mov    $0x2,%ecx
80104958:	eb 08                	jmp    80104962 <find_next_prime_number+0x32>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104960:	89 c1                	mov    %eax,%ecx
    {
      if (n%i == 0)
80104962:	89 d8                	mov    %ebx,%eax
80104964:	99                   	cltd   
80104965:	f7 f9                	idiv   %ecx
80104967:	85 d2                	test   %edx,%edx
80104969:	74 15                	je     80104980 <find_next_prime_number+0x50>
    for (int i = 2; i < n; i++)
8010496b:	8d 41 01             	lea    0x1(%ecx),%eax
8010496e:	39 ce                	cmp    %ecx,%esi
80104970:	75 ee                	jne    80104960 <find_next_prime_number+0x30>
      find = 1;
      return sol;
    }
  }
  return sol =0;
}
80104972:	89 d8                	mov    %ebx,%eax
80104974:	5b                   	pop    %ebx
80104975:	5e                   	pop    %esi
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
    n++;
80104980:	89 de                	mov    %ebx,%esi
80104982:	eb cc                	jmp    80104950 <find_next_prime_number+0x20>
80104984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop

80104990 <get_call_count>:

int get_call_count(int syscall_number)
{
80104990:	f3 0f 1e fb          	endbr32 
  return 0;
}
80104994:	31 c0                	xor    %eax,%eax
80104996:	c3                   	ret    
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <get_most_caller>:
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	31 c0                	xor    %eax,%eax
801049a6:	c3                   	ret    
801049a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <wait_for_process>:
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	31 c0                	xor    %eax,%eax
801049b6:	c3                   	ret    
801049b7:	66 90                	xchg   %ax,%ax
801049b9:	66 90                	xchg   %ax,%ax
801049bb:	66 90                	xchg   %ax,%ax
801049bd:	66 90                	xchg   %ax,%ax
801049bf:	90                   	nop

801049c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049ce:	68 a4 7e 10 80       	push   $0x80107ea4
801049d3:	8d 43 04             	lea    0x4(%ebx),%eax
801049d6:	50                   	push   %eax
801049d7:	e8 24 01 00 00       	call   80104b00 <initlock>
  lk->name = name;
801049dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f5:	c9                   	leave  
801049f6:	c3                   	ret    
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
80104a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a0c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	56                   	push   %esi
80104a13:	e8 68 02 00 00       	call   80104c80 <acquire>
  while (lk->locked) {
80104a18:	8b 13                	mov    (%ebx),%edx
80104a1a:	83 c4 10             	add    $0x10,%esp
80104a1d:	85 d2                	test   %edx,%edx
80104a1f:	74 1a                	je     80104a3b <acquiresleep+0x3b>
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a28:	83 ec 08             	sub    $0x8,%esp
80104a2b:	56                   	push   %esi
80104a2c:	53                   	push   %ebx
80104a2d:	e8 7e fb ff ff       	call   801045b0 <sleep>
  while (lk->locked) {
80104a32:	8b 03                	mov    (%ebx),%eax
80104a34:	83 c4 10             	add    $0x10,%esp
80104a37:	85 c0                	test   %eax,%eax
80104a39:	75 ed                	jne    80104a28 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104a3b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a41:	e8 aa f5 ff ff       	call   80103ff0 <myproc>
80104a46:	8b 40 10             	mov    0x10(%eax),%eax
80104a49:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a4c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a52:	5b                   	pop    %ebx
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
  release(&lk->lk);
80104a55:	e9 e6 02 00 00       	jmp    80104d40 <release>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	53                   	push   %ebx
80104a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a6c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a6f:	83 ec 0c             	sub    $0xc,%esp
80104a72:	56                   	push   %esi
80104a73:	e8 08 02 00 00       	call   80104c80 <acquire>
  lk->locked = 0;
80104a78:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a7e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a85:	89 1c 24             	mov    %ebx,(%esp)
80104a88:	e8 e3 fc ff ff       	call   80104770 <wakeup>
  release(&lk->lk);
80104a8d:	89 75 08             	mov    %esi,0x8(%ebp)
80104a90:	83 c4 10             	add    $0x10,%esp
}
80104a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a96:	5b                   	pop    %ebx
80104a97:	5e                   	pop    %esi
80104a98:	5d                   	pop    %ebp
  release(&lk->lk);
80104a99:	e9 a2 02 00 00       	jmp    80104d40 <release>
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	57                   	push   %edi
80104aa8:	31 ff                	xor    %edi,%edi
80104aaa:	56                   	push   %esi
80104aab:	53                   	push   %ebx
80104aac:	83 ec 18             	sub    $0x18,%esp
80104aaf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ab2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ab5:	56                   	push   %esi
80104ab6:	e8 c5 01 00 00       	call   80104c80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104abb:	8b 03                	mov    (%ebx),%eax
80104abd:	83 c4 10             	add    $0x10,%esp
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	75 1c                	jne    80104ae0 <holdingsleep+0x40>
  release(&lk->lk);
80104ac4:	83 ec 0c             	sub    $0xc,%esp
80104ac7:	56                   	push   %esi
80104ac8:	e8 73 02 00 00       	call   80104d40 <release>
  return r;
}
80104acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad0:	89 f8                	mov    %edi,%eax
80104ad2:	5b                   	pop    %ebx
80104ad3:	5e                   	pop    %esi
80104ad4:	5f                   	pop    %edi
80104ad5:	5d                   	pop    %ebp
80104ad6:	c3                   	ret    
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104ae0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ae3:	e8 08 f5 ff ff       	call   80103ff0 <myproc>
80104ae8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aeb:	0f 94 c0             	sete   %al
80104aee:	0f b6 c0             	movzbl %al,%eax
80104af1:	89 c7                	mov    %eax,%edi
80104af3:	eb cf                	jmp    80104ac4 <holdingsleep+0x24>
80104af5:	66 90                	xchg   %ax,%ax
80104af7:	66 90                	xchg   %ax,%ax
80104af9:	66 90                	xchg   %ax,%ax
80104afb:	66 90                	xchg   %ax,%ax
80104afd:	66 90                	xchg   %ax,%ax
80104aff:	90                   	nop

80104b00 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b13:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b1d:	5d                   	pop    %ebp
80104b1e:	c3                   	ret    
80104b1f:	90                   	nop

80104b20 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b25:	31 d2                	xor    %edx,%edx
{
80104b27:	89 e5                	mov    %esp,%ebp
80104b29:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b2a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b30:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b37:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b38:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b3e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b44:	77 1a                	ja     80104b60 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b46:	8b 58 04             	mov    0x4(%eax),%ebx
80104b49:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b4c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b4f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b51:	83 fa 0a             	cmp    $0xa,%edx
80104b54:	75 e2                	jne    80104b38 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b56:	5b                   	pop    %ebx
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b60:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b63:	8d 51 28             	lea    0x28(%ecx),%edx
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b76:	83 c0 04             	add    $0x4,%eax
80104b79:	39 d0                	cmp    %edx,%eax
80104b7b:	75 f3                	jne    80104b70 <getcallerpcs+0x50>
}
80104b7d:	5b                   	pop    %ebx
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    

80104b80 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	9c                   	pushf  
80104b8c:	5b                   	pop    %ebx
  asm volatile("cli");
80104b8d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b8e:	e8 cd f3 ff ff       	call   80103f60 <mycpu>
80104b93:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b99:	85 c0                	test   %eax,%eax
80104b9b:	74 13                	je     80104bb0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b9d:	e8 be f3 ff ff       	call   80103f60 <mycpu>
80104ba2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ba9:	83 c4 04             	add    $0x4,%esp
80104bac:	5b                   	pop    %ebx
80104bad:	5d                   	pop    %ebp
80104bae:	c3                   	ret    
80104baf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104bb0:	e8 ab f3 ff ff       	call   80103f60 <mycpu>
80104bb5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104bbb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104bc1:	eb da                	jmp    80104b9d <pushcli+0x1d>
80104bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <popcli>:

void
popcli(void)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bda:	9c                   	pushf  
80104bdb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bdc:	f6 c4 02             	test   $0x2,%ah
80104bdf:	75 31                	jne    80104c12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104be1:	e8 7a f3 ff ff       	call   80103f60 <mycpu>
80104be6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bed:	78 30                	js     80104c1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bef:	e8 6c f3 ff ff       	call   80103f60 <mycpu>
80104bf4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bfa:	85 d2                	test   %edx,%edx
80104bfc:	74 02                	je     80104c00 <popcli+0x30>
    sti();
}
80104bfe:	c9                   	leave  
80104bff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c00:	e8 5b f3 ff ff       	call   80103f60 <mycpu>
80104c05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	74 ef                	je     80104bfe <popcli+0x2e>
  asm volatile("sti");
80104c0f:	fb                   	sti    
}
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    
    panic("popcli - interruptible");
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 af 7e 10 80       	push   $0x80107eaf
80104c1a:	e8 71 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c1f:	83 ec 0c             	sub    $0xc,%esp
80104c22:	68 c6 7e 10 80       	push   $0x80107ec6
80104c27:	e8 64 b7 ff ff       	call   80100390 <panic>
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <holding>:
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
80104c39:	8b 75 08             	mov    0x8(%ebp),%esi
80104c3c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c3e:	e8 3d ff ff ff       	call   80104b80 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c43:	8b 06                	mov    (%esi),%eax
80104c45:	85 c0                	test   %eax,%eax
80104c47:	75 0f                	jne    80104c58 <holding+0x28>
  popcli();
80104c49:	e8 82 ff ff ff       	call   80104bd0 <popcli>
}
80104c4e:	89 d8                	mov    %ebx,%eax
80104c50:	5b                   	pop    %ebx
80104c51:	5e                   	pop    %esi
80104c52:	5d                   	pop    %ebp
80104c53:	c3                   	ret    
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c58:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c5b:	e8 00 f3 ff ff       	call   80103f60 <mycpu>
80104c60:	39 c3                	cmp    %eax,%ebx
80104c62:	0f 94 c3             	sete   %bl
  popcli();
80104c65:	e8 66 ff ff ff       	call   80104bd0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c6a:	0f b6 db             	movzbl %bl,%ebx
}
80104c6d:	89 d8                	mov    %ebx,%eax
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <acquire>:
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	56                   	push   %esi
80104c88:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c89:	e8 f2 fe ff ff       	call   80104b80 <pushcli>
  if(holding(lk))
80104c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c91:	83 ec 0c             	sub    $0xc,%esp
80104c94:	53                   	push   %ebx
80104c95:	e8 96 ff ff ff       	call   80104c30 <holding>
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	0f 85 7f 00 00 00    	jne    80104d24 <acquire+0xa4>
80104ca5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ca7:	ba 01 00 00 00       	mov    $0x1,%edx
80104cac:	eb 05                	jmp    80104cb3 <acquire+0x33>
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cb3:	89 d0                	mov    %edx,%eax
80104cb5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	75 f4                	jne    80104cb0 <acquire+0x30>
  __sync_synchronize();
80104cbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104cc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cc4:	e8 97 f2 ff ff       	call   80103f60 <mycpu>
80104cc9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104ccc:	89 e8                	mov    %ebp,%eax
80104cce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cd0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104cd6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104cdc:	77 22                	ja     80104d00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104cde:	8b 50 04             	mov    0x4(%eax),%edx
80104ce1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ce5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ce8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cea:	83 fe 0a             	cmp    $0xa,%esi
80104ced:	75 e1                	jne    80104cd0 <acquire+0x50>
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d00:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d04:	83 c3 34             	add    $0x34,%ebx
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d16:	83 c0 04             	add    $0x4,%eax
80104d19:	39 d8                	cmp    %ebx,%eax
80104d1b:	75 f3                	jne    80104d10 <acquire+0x90>
}
80104d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d20:	5b                   	pop    %ebx
80104d21:	5e                   	pop    %esi
80104d22:	5d                   	pop    %ebp
80104d23:	c3                   	ret    
    panic("acquire");
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	68 cd 7e 10 80       	push   $0x80107ecd
80104d2c:	e8 5f b6 ff ff       	call   80100390 <panic>
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop

80104d40 <release>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	53                   	push   %ebx
80104d48:	83 ec 10             	sub    $0x10,%esp
80104d4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d4e:	53                   	push   %ebx
80104d4f:	e8 dc fe ff ff       	call   80104c30 <holding>
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	74 22                	je     80104d7d <release+0x3d>
  lk->pcs[0] = 0;
80104d5b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d69:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d6e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d77:	c9                   	leave  
  popcli();
80104d78:	e9 53 fe ff ff       	jmp    80104bd0 <popcli>
    panic("release");
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	68 d5 7e 10 80       	push   $0x80107ed5
80104d85:	e8 06 b6 ff ff       	call   80100390 <panic>
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	57                   	push   %edi
80104d98:	8b 55 08             	mov    0x8(%ebp),%edx
80104d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d9e:	53                   	push   %ebx
80104d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104da2:	89 d7                	mov    %edx,%edi
80104da4:	09 cf                	or     %ecx,%edi
80104da6:	83 e7 03             	and    $0x3,%edi
80104da9:	75 25                	jne    80104dd0 <memset+0x40>
    c &= 0xFF;
80104dab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dae:	c1 e0 18             	shl    $0x18,%eax
80104db1:	89 fb                	mov    %edi,%ebx
80104db3:	c1 e9 02             	shr    $0x2,%ecx
80104db6:	c1 e3 10             	shl    $0x10,%ebx
80104db9:	09 d8                	or     %ebx,%eax
80104dbb:	09 f8                	or     %edi,%eax
80104dbd:	c1 e7 08             	shl    $0x8,%edi
80104dc0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104dc2:	89 d7                	mov    %edx,%edi
80104dc4:	fc                   	cld    
80104dc5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104dc7:	5b                   	pop    %ebx
80104dc8:	89 d0                	mov    %edx,%eax
80104dca:	5f                   	pop    %edi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104dd0:	89 d7                	mov    %edx,%edi
80104dd2:	fc                   	cld    
80104dd3:	f3 aa                	rep stos %al,%es:(%edi)
80104dd5:	5b                   	pop    %ebx
80104dd6:	89 d0                	mov    %edx,%eax
80104dd8:	5f                   	pop    %edi
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	8b 75 10             	mov    0x10(%ebp),%esi
80104deb:	8b 55 08             	mov    0x8(%ebp),%edx
80104dee:	53                   	push   %ebx
80104def:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104df2:	85 f6                	test   %esi,%esi
80104df4:	74 2a                	je     80104e20 <memcmp+0x40>
80104df6:	01 c6                	add    %eax,%esi
80104df8:	eb 10                	jmp    80104e0a <memcmp+0x2a>
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e00:	83 c0 01             	add    $0x1,%eax
80104e03:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e06:	39 f0                	cmp    %esi,%eax
80104e08:	74 16                	je     80104e20 <memcmp+0x40>
    if(*s1 != *s2)
80104e0a:	0f b6 0a             	movzbl (%edx),%ecx
80104e0d:	0f b6 18             	movzbl (%eax),%ebx
80104e10:	38 d9                	cmp    %bl,%cl
80104e12:	74 ec                	je     80104e00 <memcmp+0x20>
      return *s1 - *s2;
80104e14:	0f b6 c1             	movzbl %cl,%eax
80104e17:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e19:	5b                   	pop    %ebx
80104e1a:	5e                   	pop    %esi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret    
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
80104e20:	5b                   	pop    %ebx
  return 0;
80104e21:	31 c0                	xor    %eax,%eax
}
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi

80104e30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	57                   	push   %edi
80104e38:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e3e:	56                   	push   %esi
80104e3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e42:	39 d6                	cmp    %edx,%esi
80104e44:	73 2a                	jae    80104e70 <memmove+0x40>
80104e46:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e49:	39 fa                	cmp    %edi,%edx
80104e4b:	73 23                	jae    80104e70 <memmove+0x40>
80104e4d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e50:	85 c9                	test   %ecx,%ecx
80104e52:	74 13                	je     80104e67 <memmove+0x37>
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e58:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e5c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e5f:	83 e8 01             	sub    $0x1,%eax
80104e62:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e65:	75 f1                	jne    80104e58 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e67:	5e                   	pop    %esi
80104e68:	89 d0                	mov    %edx,%eax
80104e6a:	5f                   	pop    %edi
80104e6b:	5d                   	pop    %ebp
80104e6c:	c3                   	ret    
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e70:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e73:	89 d7                	mov    %edx,%edi
80104e75:	85 c9                	test   %ecx,%ecx
80104e77:	74 ee                	je     80104e67 <memmove+0x37>
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e80:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e81:	39 f0                	cmp    %esi,%eax
80104e83:	75 fb                	jne    80104e80 <memmove+0x50>
}
80104e85:	5e                   	pop    %esi
80104e86:	89 d0                	mov    %edx,%eax
80104e88:	5f                   	pop    %edi
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop

80104e90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e90:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104e94:	eb 9a                	jmp    80104e30 <memmove>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	56                   	push   %esi
80104ea8:	8b 75 10             	mov    0x10(%ebp),%esi
80104eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eae:	53                   	push   %ebx
80104eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104eb2:	85 f6                	test   %esi,%esi
80104eb4:	74 32                	je     80104ee8 <strncmp+0x48>
80104eb6:	01 c6                	add    %eax,%esi
80104eb8:	eb 14                	jmp    80104ece <strncmp+0x2e>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec0:	38 da                	cmp    %bl,%dl
80104ec2:	75 14                	jne    80104ed8 <strncmp+0x38>
    n--, p++, q++;
80104ec4:	83 c0 01             	add    $0x1,%eax
80104ec7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104eca:	39 f0                	cmp    %esi,%eax
80104ecc:	74 1a                	je     80104ee8 <strncmp+0x48>
80104ece:	0f b6 11             	movzbl (%ecx),%edx
80104ed1:	0f b6 18             	movzbl (%eax),%ebx
80104ed4:	84 d2                	test   %dl,%dl
80104ed6:	75 e8                	jne    80104ec0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ed8:	0f b6 c2             	movzbl %dl,%eax
80104edb:	29 d8                	sub    %ebx,%eax
}
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5d                   	pop    %ebp
80104ee0:	c3                   	ret    
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	5b                   	pop    %ebx
    return 0;
80104ee9:	31 c0                	xor    %eax,%eax
}
80104eeb:	5e                   	pop    %esi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret    
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	57                   	push   %edi
80104ef8:	56                   	push   %esi
80104ef9:	8b 75 08             	mov    0x8(%ebp),%esi
80104efc:	53                   	push   %ebx
80104efd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f00:	89 f2                	mov    %esi,%edx
80104f02:	eb 1b                	jmp    80104f1f <strncpy+0x2f>
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f08:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f0f:	83 c2 01             	add    $0x1,%edx
80104f12:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104f16:	89 f9                	mov    %edi,%ecx
80104f18:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f1b:	84 c9                	test   %cl,%cl
80104f1d:	74 09                	je     80104f28 <strncpy+0x38>
80104f1f:	89 c3                	mov    %eax,%ebx
80104f21:	83 e8 01             	sub    $0x1,%eax
80104f24:	85 db                	test   %ebx,%ebx
80104f26:	7f e0                	jg     80104f08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f28:	89 d1                	mov    %edx,%ecx
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	7e 15                	jle    80104f43 <strncpy+0x53>
80104f2e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104f30:	83 c1 01             	add    $0x1,%ecx
80104f33:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104f37:	89 c8                	mov    %ecx,%eax
80104f39:	f7 d0                	not    %eax
80104f3b:	01 d0                	add    %edx,%eax
80104f3d:	01 d8                	add    %ebx,%eax
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	7f ed                	jg     80104f30 <strncpy+0x40>
  return os;
}
80104f43:	5b                   	pop    %ebx
80104f44:	89 f0                	mov    %esi,%eax
80104f46:	5e                   	pop    %esi
80104f47:	5f                   	pop    %edi
80104f48:	5d                   	pop    %ebp
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	8b 55 10             	mov    0x10(%ebp),%edx
80104f5b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f62:	85 d2                	test   %edx,%edx
80104f64:	7e 21                	jle    80104f87 <safestrcpy+0x37>
80104f66:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f6a:	89 f2                	mov    %esi,%edx
80104f6c:	eb 12                	jmp    80104f80 <safestrcpy+0x30>
80104f6e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f70:	0f b6 08             	movzbl (%eax),%ecx
80104f73:	83 c0 01             	add    $0x1,%eax
80104f76:	83 c2 01             	add    $0x1,%edx
80104f79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f7c:	84 c9                	test   %cl,%cl
80104f7e:	74 04                	je     80104f84 <safestrcpy+0x34>
80104f80:	39 d8                	cmp    %ebx,%eax
80104f82:	75 ec                	jne    80104f70 <safestrcpy+0x20>
    ;
  *s = 0;
80104f84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f87:	89 f0                	mov    %esi,%eax
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <strlen>:

int
strlen(const char *s)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f95:	31 c0                	xor    %eax,%eax
{
80104f97:	89 e5                	mov    %esp,%ebp
80104f99:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f9c:	80 3a 00             	cmpb   $0x0,(%edx)
80104f9f:	74 10                	je     80104fb1 <strlen+0x21>
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	83 c0 01             	add    $0x1,%eax
80104fab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104faf:	75 f7                	jne    80104fa8 <strlen+0x18>
    ;
  return n;
}
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    

80104fb3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fb7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104fbb:	55                   	push   %ebp
  pushl %ebx
80104fbc:	53                   	push   %ebx
  pushl %esi
80104fbd:	56                   	push   %esi
  pushl %edi
80104fbe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fbf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fc1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104fc3:	5f                   	pop    %edi
  popl %esi
80104fc4:	5e                   	pop    %esi
  popl %ebx
80104fc5:	5b                   	pop    %ebx
  popl %ebp
80104fc6:	5d                   	pop    %ebp
  ret
80104fc7:	c3                   	ret    
80104fc8:	66 90                	xchg   %ax,%ax
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	53                   	push   %ebx
80104fd8:	83 ec 04             	sub    $0x4,%esp
80104fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fde:	e8 0d f0 ff ff       	call   80103ff0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe3:	8b 00                	mov    (%eax),%eax
80104fe5:	39 d8                	cmp    %ebx,%eax
80104fe7:	76 17                	jbe    80105000 <fetchint+0x30>
80104fe9:	8d 53 04             	lea    0x4(%ebx),%edx
80104fec:	39 d0                	cmp    %edx,%eax
80104fee:	72 10                	jb     80105000 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff3:	8b 13                	mov    (%ebx),%edx
80104ff5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff7:	31 c0                	xor    %eax,%eax
}
80104ff9:	83 c4 04             	add    $0x4,%esp
80104ffc:	5b                   	pop    %ebx
80104ffd:	5d                   	pop    %ebp
80104ffe:	c3                   	ret    
80104fff:	90                   	nop
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb f2                	jmp    80104ff9 <fetchint+0x29>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	53                   	push   %ebx
80105018:	83 ec 04             	sub    $0x4,%esp
8010501b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010501e:	e8 cd ef ff ff       	call   80103ff0 <myproc>

  if(addr >= curproc->sz)
80105023:	39 18                	cmp    %ebx,(%eax)
80105025:	76 31                	jbe    80105058 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105027:	8b 55 0c             	mov    0xc(%ebp),%edx
8010502a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010502c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010502e:	39 d3                	cmp    %edx,%ebx
80105030:	73 26                	jae    80105058 <fetchstr+0x48>
80105032:	89 d8                	mov    %ebx,%eax
80105034:	eb 11                	jmp    80105047 <fetchstr+0x37>
80105036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
80105040:	83 c0 01             	add    $0x1,%eax
80105043:	39 c2                	cmp    %eax,%edx
80105045:	76 11                	jbe    80105058 <fetchstr+0x48>
    if(*s == 0)
80105047:	80 38 00             	cmpb   $0x0,(%eax)
8010504a:	75 f4                	jne    80105040 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010504c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010504f:	29 d8                	sub    %ebx,%eax
}
80105051:	5b                   	pop    %ebx
80105052:	5d                   	pop    %ebp
80105053:	c3                   	ret    
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105058:	83 c4 04             	add    $0x4,%esp
    return -1;
8010505b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105060:	5b                   	pop    %ebx
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105070 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	56                   	push   %esi
80105078:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105079:	e8 72 ef ff ff       	call   80103ff0 <myproc>
8010507e:	8b 55 08             	mov    0x8(%ebp),%edx
80105081:	8b 40 18             	mov    0x18(%eax),%eax
80105084:	8b 40 44             	mov    0x44(%eax),%eax
80105087:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010508a:	e8 61 ef ff ff       	call   80103ff0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010508f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105092:	8b 00                	mov    (%eax),%eax
80105094:	39 c6                	cmp    %eax,%esi
80105096:	73 18                	jae    801050b0 <argint+0x40>
80105098:	8d 53 08             	lea    0x8(%ebx),%edx
8010509b:	39 d0                	cmp    %edx,%eax
8010509d:	72 11                	jb     801050b0 <argint+0x40>
  *ip = *(int*)(addr);
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a2:	8b 53 04             	mov    0x4(%ebx),%edx
801050a5:	89 10                	mov    %edx,(%eax)
  return 0;
801050a7:	31 c0                	xor    %eax,%eax
}
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret    
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050b5:	eb f2                	jmp    801050a9 <argint+0x39>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	56                   	push   %esi
801050c8:	53                   	push   %ebx
801050c9:	83 ec 10             	sub    $0x10,%esp
801050cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050cf:	e8 1c ef ff ff       	call   80103ff0 <myproc>
 
  if(argint(n, &i) < 0)
801050d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801050d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801050d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050dc:	50                   	push   %eax
801050dd:	ff 75 08             	pushl  0x8(%ebp)
801050e0:	e8 8b ff ff ff       	call   80105070 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	85 c0                	test   %eax,%eax
801050ea:	78 24                	js     80105110 <argptr+0x50>
801050ec:	85 db                	test   %ebx,%ebx
801050ee:	78 20                	js     80105110 <argptr+0x50>
801050f0:	8b 16                	mov    (%esi),%edx
801050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f5:	39 c2                	cmp    %eax,%edx
801050f7:	76 17                	jbe    80105110 <argptr+0x50>
801050f9:	01 c3                	add    %eax,%ebx
801050fb:	39 da                	cmp    %ebx,%edx
801050fd:	72 11                	jb     80105110 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105102:	89 02                	mov    %eax,(%edx)
  return 0;
80105104:	31 c0                	xor    %eax,%eax
}
80105106:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105109:	5b                   	pop    %ebx
8010510a:	5e                   	pop    %esi
8010510b:	5d                   	pop    %ebp
8010510c:	c3                   	ret    
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb ef                	jmp    80105106 <argptr+0x46>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010512a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512d:	50                   	push   %eax
8010512e:	ff 75 08             	pushl  0x8(%ebp)
80105131:	e8 3a ff ff ff       	call   80105070 <argint>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	78 13                	js     80105150 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010513d:	83 ec 08             	sub    $0x8,%esp
80105140:	ff 75 0c             	pushl  0xc(%ebp)
80105143:	ff 75 f4             	pushl  -0xc(%ebp)
80105146:	e8 c5 fe ff ff       	call   80105010 <fetchstr>
8010514b:	83 c4 10             	add    $0x10,%esp
}
8010514e:	c9                   	leave  
8010514f:	c3                   	ret    
80105150:	c9                   	leave  
    return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105156:	c3                   	ret    
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <syscall>:

};

void
syscall(void)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	53                   	push   %ebx
80105168:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010516b:	e8 80 ee ff ff       	call   80103ff0 <myproc>
80105170:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105172:	8b 40 18             	mov    0x18(%eax),%eax
80105175:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105178:	8d 50 ff             	lea    -0x1(%eax),%edx
8010517b:	83 fa 18             	cmp    $0x18,%edx
8010517e:	77 20                	ja     801051a0 <syscall+0x40>
80105180:	8b 14 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%edx
80105187:	85 d2                	test   %edx,%edx
80105189:	74 15                	je     801051a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010518b:	ff d2                	call   *%edx
8010518d:	89 c2                	mov    %eax,%edx
8010518f:	8b 43 18             	mov    0x18(%ebx),%eax
80105192:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105198:	c9                   	leave  
80105199:	c3                   	ret    
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051a4:	50                   	push   %eax
801051a5:	ff 73 10             	pushl  0x10(%ebx)
801051a8:	68 dd 7e 10 80       	push   $0x80107edd
801051ad:	e8 ee b5 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
801051b2:	8b 43 18             	mov    0x18(%ebx),%eax
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051c2:	c9                   	leave  
801051c3:	c3                   	ret    
801051c4:	66 90                	xchg   %ax,%ax
801051c6:	66 90                	xchg   %ax,%ax
801051c8:	66 90                	xchg   %ax,%ax
801051ca:	66 90                	xchg   %ax,%ax
801051cc:	66 90                	xchg   %ax,%ax
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051d8:	53                   	push   %ebx
801051d9:	83 ec 34             	sub    $0x34,%esp
801051dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051e2:	57                   	push   %edi
801051e3:	50                   	push   %eax
{
801051e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051ea:	e8 f1 d4 ff ff       	call   801026e0 <nameiparent>
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	85 c0                	test   %eax,%eax
801051f4:	0f 84 46 01 00 00    	je     80105340 <create+0x170>
    return 0;
  ilock(dp);
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	89 c3                	mov    %eax,%ebx
801051ff:	50                   	push   %eax
80105200:	e8 eb cb ff ff       	call   80101df0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105205:	83 c4 0c             	add    $0xc,%esp
80105208:	6a 00                	push   $0x0
8010520a:	57                   	push   %edi
8010520b:	53                   	push   %ebx
8010520c:	e8 2f d1 ff ff       	call   80102340 <dirlookup>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	89 c6                	mov    %eax,%esi
80105216:	85 c0                	test   %eax,%eax
80105218:	74 56                	je     80105270 <create+0xa0>
    iunlockput(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	53                   	push   %ebx
8010521e:	e8 6d ce ff ff       	call   80102090 <iunlockput>
    ilock(ip);
80105223:	89 34 24             	mov    %esi,(%esp)
80105226:	e8 c5 cb ff ff       	call   80101df0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010522b:	83 c4 10             	add    $0x10,%esp
8010522e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105233:	75 1b                	jne    80105250 <create+0x80>
80105235:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010523a:	75 14                	jne    80105250 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010523c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010523f:	89 f0                	mov    %esi,%eax
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5f                   	pop    %edi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	56                   	push   %esi
    return 0;
80105254:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105256:	e8 35 ce ff ff       	call   80102090 <iunlockput>
    return 0;
8010525b:	83 c4 10             	add    $0x10,%esp
}
8010525e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105261:	89 f0                	mov    %esi,%eax
80105263:	5b                   	pop    %ebx
80105264:	5e                   	pop    %esi
80105265:	5f                   	pop    %edi
80105266:	5d                   	pop    %ebp
80105267:	c3                   	ret    
80105268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105270:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105274:	83 ec 08             	sub    $0x8,%esp
80105277:	50                   	push   %eax
80105278:	ff 33                	pushl  (%ebx)
8010527a:	e8 f1 c9 ff ff       	call   80101c70 <ialloc>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	89 c6                	mov    %eax,%esi
80105284:	85 c0                	test   %eax,%eax
80105286:	0f 84 cd 00 00 00    	je     80105359 <create+0x189>
  ilock(ip);
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	50                   	push   %eax
80105290:	e8 5b cb ff ff       	call   80101df0 <ilock>
  ip->major = major;
80105295:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105299:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010529d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801052a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801052a5:	b8 01 00 00 00       	mov    $0x1,%eax
801052aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801052ae:	89 34 24             	mov    %esi,(%esp)
801052b1:	e8 7a ca ff ff       	call   80101d30 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052be:	74 30                	je     801052f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801052c0:	83 ec 04             	sub    $0x4,%esp
801052c3:	ff 76 04             	pushl  0x4(%esi)
801052c6:	57                   	push   %edi
801052c7:	53                   	push   %ebx
801052c8:	e8 33 d3 ff ff       	call   80102600 <dirlink>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 78                	js     8010534c <create+0x17c>
  iunlockput(dp);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	53                   	push   %ebx
801052d8:	e8 b3 cd ff ff       	call   80102090 <iunlockput>
  return ip;
801052dd:	83 c4 10             	add    $0x10,%esp
}
801052e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e3:	89 f0                	mov    %esi,%eax
801052e5:	5b                   	pop    %ebx
801052e6:	5e                   	pop    %esi
801052e7:	5f                   	pop    %edi
801052e8:	5d                   	pop    %ebp
801052e9:	c3                   	ret    
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801052f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052f8:	53                   	push   %ebx
801052f9:	e8 32 ca ff ff       	call   80101d30 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052fe:	83 c4 0c             	add    $0xc,%esp
80105301:	ff 76 04             	pushl  0x4(%esi)
80105304:	68 84 7f 10 80       	push   $0x80107f84
80105309:	56                   	push   %esi
8010530a:	e8 f1 d2 ff ff       	call   80102600 <dirlink>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	78 18                	js     8010532e <create+0x15e>
80105316:	83 ec 04             	sub    $0x4,%esp
80105319:	ff 73 04             	pushl  0x4(%ebx)
8010531c:	68 83 7f 10 80       	push   $0x80107f83
80105321:	56                   	push   %esi
80105322:	e8 d9 d2 ff ff       	call   80102600 <dirlink>
80105327:	83 c4 10             	add    $0x10,%esp
8010532a:	85 c0                	test   %eax,%eax
8010532c:	79 92                	jns    801052c0 <create+0xf0>
      panic("create dots");
8010532e:	83 ec 0c             	sub    $0xc,%esp
80105331:	68 77 7f 10 80       	push   $0x80107f77
80105336:	e8 55 b0 ff ff       	call   80100390 <panic>
8010533b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010533f:	90                   	nop
}
80105340:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105343:	31 f6                	xor    %esi,%esi
}
80105345:	5b                   	pop    %ebx
80105346:	89 f0                	mov    %esi,%eax
80105348:	5e                   	pop    %esi
80105349:	5f                   	pop    %edi
8010534a:	5d                   	pop    %ebp
8010534b:	c3                   	ret    
    panic("create: dirlink");
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	68 86 7f 10 80       	push   $0x80107f86
80105354:	e8 37 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	68 68 7f 10 80       	push   $0x80107f68
80105361:	e8 2a b0 ff ff       	call   80100390 <panic>
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi

80105370 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	89 d6                	mov    %edx,%esi
80105376:	53                   	push   %ebx
80105377:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105379:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010537c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010537f:	50                   	push   %eax
80105380:	6a 00                	push   $0x0
80105382:	e8 e9 fc ff ff       	call   80105070 <argint>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	78 2a                	js     801053b8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010538e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105392:	77 24                	ja     801053b8 <argfd.constprop.0+0x48>
80105394:	e8 57 ec ff ff       	call   80103ff0 <myproc>
80105399:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010539c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 14                	je     801053b8 <argfd.constprop.0+0x48>
  if(pfd)
801053a4:	85 db                	test   %ebx,%ebx
801053a6:	74 02                	je     801053aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801053a8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801053aa:	89 06                	mov    %eax,(%esi)
  return 0;
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret    
801053b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	eb ef                	jmp    801053ae <argfd.constprop.0+0x3e>
801053bf:	90                   	nop

801053c0 <sys_dup>:
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801053c5:	31 c0                	xor    %eax,%eax
{
801053c7:	89 e5                	mov    %esp,%ebp
801053c9:	56                   	push   %esi
801053ca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053cb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053ce:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053d1:	e8 9a ff ff ff       	call   80105370 <argfd.constprop.0>
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 1e                	js     801053f8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801053da:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053dd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053df:	e8 0c ec ff ff       	call   80103ff0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053e8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053ec:	85 d2                	test   %edx,%edx
801053ee:	74 20                	je     80105410 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801053f0:	83 c3 01             	add    $0x1,%ebx
801053f3:	83 fb 10             	cmp    $0x10,%ebx
801053f6:	75 f0                	jne    801053e8 <sys_dup+0x28>
}
801053f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105400:	89 d8                	mov    %ebx,%eax
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105410:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	ff 75 f4             	pushl  -0xc(%ebp)
8010541a:	e8 e1 c0 ff ff       	call   80101500 <filedup>
  return fd;
8010541f:	83 c4 10             	add    $0x10,%esp
}
80105422:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105425:	89 d8                	mov    %ebx,%eax
80105427:	5b                   	pop    %ebx
80105428:	5e                   	pop    %esi
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop

80105430 <sys_read>:
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105435:	31 c0                	xor    %eax,%eax
{
80105437:	89 e5                	mov    %esp,%ebp
80105439:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010543c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010543f:	e8 2c ff ff ff       	call   80105370 <argfd.constprop.0>
80105444:	85 c0                	test   %eax,%eax
80105446:	78 48                	js     80105490 <sys_read+0x60>
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010544e:	50                   	push   %eax
8010544f:	6a 02                	push   $0x2
80105451:	e8 1a fc ff ff       	call   80105070 <argint>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 33                	js     80105490 <sys_read+0x60>
8010545d:	83 ec 04             	sub    $0x4,%esp
80105460:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105463:	ff 75 f0             	pushl  -0x10(%ebp)
80105466:	50                   	push   %eax
80105467:	6a 01                	push   $0x1
80105469:	e8 52 fc ff ff       	call   801050c0 <argptr>
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	85 c0                	test   %eax,%eax
80105473:	78 1b                	js     80105490 <sys_read+0x60>
  return fileread(f, p, n);
80105475:	83 ec 04             	sub    $0x4,%esp
80105478:	ff 75 f0             	pushl  -0x10(%ebp)
8010547b:	ff 75 f4             	pushl  -0xc(%ebp)
8010547e:	ff 75 ec             	pushl  -0x14(%ebp)
80105481:	e8 fa c1 ff ff       	call   80101680 <fileread>
80105486:	83 c4 10             	add    $0x10,%esp
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
80105490:	c9                   	leave  
    return -1;
80105491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105496:	c3                   	ret    
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <sys_write>:
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054a5:	31 c0                	xor    %eax,%eax
{
801054a7:	89 e5                	mov    %esp,%ebp
801054a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054af:	e8 bc fe ff ff       	call   80105370 <argfd.constprop.0>
801054b4:	85 c0                	test   %eax,%eax
801054b6:	78 48                	js     80105500 <sys_write+0x60>
801054b8:	83 ec 08             	sub    $0x8,%esp
801054bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054be:	50                   	push   %eax
801054bf:	6a 02                	push   $0x2
801054c1:	e8 aa fb ff ff       	call   80105070 <argint>
801054c6:	83 c4 10             	add    $0x10,%esp
801054c9:	85 c0                	test   %eax,%eax
801054cb:	78 33                	js     80105500 <sys_write+0x60>
801054cd:	83 ec 04             	sub    $0x4,%esp
801054d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d3:	ff 75 f0             	pushl  -0x10(%ebp)
801054d6:	50                   	push   %eax
801054d7:	6a 01                	push   $0x1
801054d9:	e8 e2 fb ff ff       	call   801050c0 <argptr>
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	85 c0                	test   %eax,%eax
801054e3:	78 1b                	js     80105500 <sys_write+0x60>
  return filewrite(f, p, n);
801054e5:	83 ec 04             	sub    $0x4,%esp
801054e8:	ff 75 f0             	pushl  -0x10(%ebp)
801054eb:	ff 75 f4             	pushl  -0xc(%ebp)
801054ee:	ff 75 ec             	pushl  -0x14(%ebp)
801054f1:	e8 2a c2 ff ff       	call   80101720 <filewrite>
801054f6:	83 c4 10             	add    $0x10,%esp
}
801054f9:	c9                   	leave  
801054fa:	c3                   	ret    
801054fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
80105500:	c9                   	leave  
    return -1;
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105506:	c3                   	ret    
80105507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550e:	66 90                	xchg   %ax,%ax

80105510 <sys_close>:
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010551a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010551d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105520:	e8 4b fe ff ff       	call   80105370 <argfd.constprop.0>
80105525:	85 c0                	test   %eax,%eax
80105527:	78 27                	js     80105550 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105529:	e8 c2 ea ff ff       	call   80103ff0 <myproc>
8010552e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105531:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105534:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010553b:	00 
  fileclose(f);
8010553c:	ff 75 f4             	pushl  -0xc(%ebp)
8010553f:	e8 0c c0 ff ff       	call   80101550 <fileclose>
  return 0;
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	31 c0                	xor    %eax,%eax
}
80105549:	c9                   	leave  
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
80105550:	c9                   	leave  
    return -1;
80105551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105556:	c3                   	ret    
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <sys_fstat>:
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105565:	31 c0                	xor    %eax,%eax
{
80105567:	89 e5                	mov    %esp,%ebp
80105569:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010556c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010556f:	e8 fc fd ff ff       	call   80105370 <argfd.constprop.0>
80105574:	85 c0                	test   %eax,%eax
80105576:	78 30                	js     801055a8 <sys_fstat+0x48>
80105578:	83 ec 04             	sub    $0x4,%esp
8010557b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557e:	6a 14                	push   $0x14
80105580:	50                   	push   %eax
80105581:	6a 01                	push   $0x1
80105583:	e8 38 fb ff ff       	call   801050c0 <argptr>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	78 19                	js     801055a8 <sys_fstat+0x48>
  return filestat(f, st);
8010558f:	83 ec 08             	sub    $0x8,%esp
80105592:	ff 75 f4             	pushl  -0xc(%ebp)
80105595:	ff 75 f0             	pushl  -0x10(%ebp)
80105598:	e8 93 c0 ff ff       	call   80101630 <filestat>
8010559d:	83 c4 10             	add    $0x10,%esp
}
801055a0:	c9                   	leave  
801055a1:	c3                   	ret    
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a8:	c9                   	leave  
    return -1;
801055a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ae:	c3                   	ret    
801055af:	90                   	nop

801055b0 <sys_link>:
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
801055b5:	89 e5                	mov    %esp,%ebp
801055b7:	57                   	push   %edi
801055b8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055bc:	53                   	push   %ebx
801055bd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055c0:	50                   	push   %eax
801055c1:	6a 00                	push   $0x0
801055c3:	e8 58 fb ff ff       	call   80105120 <argstr>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	85 c0                	test   %eax,%eax
801055cd:	0f 88 ff 00 00 00    	js     801056d2 <sys_link+0x122>
801055d3:	83 ec 08             	sub    $0x8,%esp
801055d6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055d9:	50                   	push   %eax
801055da:	6a 01                	push   $0x1
801055dc:	e8 3f fb ff ff       	call   80105120 <argstr>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	0f 88 e6 00 00 00    	js     801056d2 <sys_link+0x122>
  begin_op();
801055ec:	e8 cf dd ff ff       	call   801033c0 <begin_op>
  if((ip = namei(old)) == 0){
801055f1:	83 ec 0c             	sub    $0xc,%esp
801055f4:	ff 75 d4             	pushl  -0x2c(%ebp)
801055f7:	e8 c4 d0 ff ff       	call   801026c0 <namei>
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	89 c3                	mov    %eax,%ebx
80105601:	85 c0                	test   %eax,%eax
80105603:	0f 84 e8 00 00 00    	je     801056f1 <sys_link+0x141>
  ilock(ip);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	50                   	push   %eax
8010560d:	e8 de c7 ff ff       	call   80101df0 <ilock>
  if(ip->type == T_DIR){
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010561a:	0f 84 b9 00 00 00    	je     801056d9 <sys_link+0x129>
  iupdate(ip);
80105620:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105623:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105628:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010562b:	53                   	push   %ebx
8010562c:	e8 ff c6 ff ff       	call   80101d30 <iupdate>
  iunlock(ip);
80105631:	89 1c 24             	mov    %ebx,(%esp)
80105634:	e8 97 c8 ff ff       	call   80101ed0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105639:	58                   	pop    %eax
8010563a:	5a                   	pop    %edx
8010563b:	57                   	push   %edi
8010563c:	ff 75 d0             	pushl  -0x30(%ebp)
8010563f:	e8 9c d0 ff ff       	call   801026e0 <nameiparent>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	89 c6                	mov    %eax,%esi
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 5f                	je     801056ac <sys_link+0xfc>
  ilock(dp);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	50                   	push   %eax
80105651:	e8 9a c7 ff ff       	call   80101df0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105656:	8b 03                	mov    (%ebx),%eax
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	39 06                	cmp    %eax,(%esi)
8010565d:	75 41                	jne    801056a0 <sys_link+0xf0>
8010565f:	83 ec 04             	sub    $0x4,%esp
80105662:	ff 73 04             	pushl  0x4(%ebx)
80105665:	57                   	push   %edi
80105666:	56                   	push   %esi
80105667:	e8 94 cf ff ff       	call   80102600 <dirlink>
8010566c:	83 c4 10             	add    $0x10,%esp
8010566f:	85 c0                	test   %eax,%eax
80105671:	78 2d                	js     801056a0 <sys_link+0xf0>
  iunlockput(dp);
80105673:	83 ec 0c             	sub    $0xc,%esp
80105676:	56                   	push   %esi
80105677:	e8 14 ca ff ff       	call   80102090 <iunlockput>
  iput(ip);
8010567c:	89 1c 24             	mov    %ebx,(%esp)
8010567f:	e8 9c c8 ff ff       	call   80101f20 <iput>
  end_op();
80105684:	e8 a7 dd ff ff       	call   80103430 <end_op>
  return 0;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	31 c0                	xor    %eax,%eax
}
8010568e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105691:	5b                   	pop    %ebx
80105692:	5e                   	pop    %esi
80105693:	5f                   	pop    %edi
80105694:	5d                   	pop    %ebp
80105695:	c3                   	ret    
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	56                   	push   %esi
801056a4:	e8 e7 c9 ff ff       	call   80102090 <iunlockput>
    goto bad;
801056a9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	53                   	push   %ebx
801056b0:	e8 3b c7 ff ff       	call   80101df0 <ilock>
  ip->nlink--;
801056b5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056ba:	89 1c 24             	mov    %ebx,(%esp)
801056bd:	e8 6e c6 ff ff       	call   80101d30 <iupdate>
  iunlockput(ip);
801056c2:	89 1c 24             	mov    %ebx,(%esp)
801056c5:	e8 c6 c9 ff ff       	call   80102090 <iunlockput>
  end_op();
801056ca:	e8 61 dd ff ff       	call   80103430 <end_op>
  return -1;
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d7:	eb b5                	jmp    8010568e <sys_link+0xde>
    iunlockput(ip);
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	53                   	push   %ebx
801056dd:	e8 ae c9 ff ff       	call   80102090 <iunlockput>
    end_op();
801056e2:	e8 49 dd ff ff       	call   80103430 <end_op>
    return -1;
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ef:	eb 9d                	jmp    8010568e <sys_link+0xde>
    end_op();
801056f1:	e8 3a dd ff ff       	call   80103430 <end_op>
    return -1;
801056f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fb:	eb 91                	jmp    8010568e <sys_link+0xde>
801056fd:	8d 76 00             	lea    0x0(%esi),%esi

80105700 <sys_unlink>:
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	57                   	push   %edi
80105708:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105709:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010570c:	53                   	push   %ebx
8010570d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105710:	50                   	push   %eax
80105711:	6a 00                	push   $0x0
80105713:	e8 08 fa ff ff       	call   80105120 <argstr>
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	85 c0                	test   %eax,%eax
8010571d:	0f 88 7d 01 00 00    	js     801058a0 <sys_unlink+0x1a0>
  begin_op();
80105723:	e8 98 dc ff ff       	call   801033c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105728:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010572b:	83 ec 08             	sub    $0x8,%esp
8010572e:	53                   	push   %ebx
8010572f:	ff 75 c0             	pushl  -0x40(%ebp)
80105732:	e8 a9 cf ff ff       	call   801026e0 <nameiparent>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	89 c6                	mov    %eax,%esi
8010573c:	85 c0                	test   %eax,%eax
8010573e:	0f 84 66 01 00 00    	je     801058aa <sys_unlink+0x1aa>
  ilock(dp);
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	50                   	push   %eax
80105748:	e8 a3 c6 ff ff       	call   80101df0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010574d:	58                   	pop    %eax
8010574e:	5a                   	pop    %edx
8010574f:	68 84 7f 10 80       	push   $0x80107f84
80105754:	53                   	push   %ebx
80105755:	e8 c6 cb ff ff       	call   80102320 <namecmp>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 84 03 01 00 00    	je     80105868 <sys_unlink+0x168>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	68 83 7f 10 80       	push   $0x80107f83
8010576d:	53                   	push   %ebx
8010576e:	e8 ad cb ff ff       	call   80102320 <namecmp>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	0f 84 ea 00 00 00    	je     80105868 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010577e:	83 ec 04             	sub    $0x4,%esp
80105781:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105784:	50                   	push   %eax
80105785:	53                   	push   %ebx
80105786:	56                   	push   %esi
80105787:	e8 b4 cb ff ff       	call   80102340 <dirlookup>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	89 c3                	mov    %eax,%ebx
80105791:	85 c0                	test   %eax,%eax
80105793:	0f 84 cf 00 00 00    	je     80105868 <sys_unlink+0x168>
  ilock(ip);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 4e c6 ff ff       	call   80101df0 <ilock>
  if(ip->nlink < 1)
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057aa:	0f 8e 23 01 00 00    	jle    801058d3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057b8:	74 66                	je     80105820 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057ba:	83 ec 04             	sub    $0x4,%esp
801057bd:	6a 10                	push   $0x10
801057bf:	6a 00                	push   $0x0
801057c1:	57                   	push   %edi
801057c2:	e8 c9 f5 ff ff       	call   80104d90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057c7:	6a 10                	push   $0x10
801057c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057cc:	57                   	push   %edi
801057cd:	56                   	push   %esi
801057ce:	e8 1d ca ff ff       	call   801021f0 <writei>
801057d3:	83 c4 20             	add    $0x20,%esp
801057d6:	83 f8 10             	cmp    $0x10,%eax
801057d9:	0f 85 e7 00 00 00    	jne    801058c6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801057df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e4:	0f 84 96 00 00 00    	je     80105880 <sys_unlink+0x180>
  iunlockput(dp);
801057ea:	83 ec 0c             	sub    $0xc,%esp
801057ed:	56                   	push   %esi
801057ee:	e8 9d c8 ff ff       	call   80102090 <iunlockput>
  ip->nlink--;
801057f3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057f8:	89 1c 24             	mov    %ebx,(%esp)
801057fb:	e8 30 c5 ff ff       	call   80101d30 <iupdate>
  iunlockput(ip);
80105800:	89 1c 24             	mov    %ebx,(%esp)
80105803:	e8 88 c8 ff ff       	call   80102090 <iunlockput>
  end_op();
80105808:	e8 23 dc ff ff       	call   80103430 <end_op>
  return 0;
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	31 c0                	xor    %eax,%eax
}
80105812:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105815:	5b                   	pop    %ebx
80105816:	5e                   	pop    %esi
80105817:	5f                   	pop    %edi
80105818:	5d                   	pop    %ebp
80105819:	c3                   	ret    
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105820:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105824:	76 94                	jbe    801057ba <sys_unlink+0xba>
80105826:	ba 20 00 00 00       	mov    $0x20,%edx
8010582b:	eb 0b                	jmp    80105838 <sys_unlink+0x138>
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
80105830:	83 c2 10             	add    $0x10,%edx
80105833:	39 53 58             	cmp    %edx,0x58(%ebx)
80105836:	76 82                	jbe    801057ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105838:	6a 10                	push   $0x10
8010583a:	52                   	push   %edx
8010583b:	57                   	push   %edi
8010583c:	53                   	push   %ebx
8010583d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105840:	e8 ab c8 ff ff       	call   801020f0 <readi>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010584b:	83 f8 10             	cmp    $0x10,%eax
8010584e:	75 69                	jne    801058b9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105850:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105855:	74 d9                	je     80105830 <sys_unlink+0x130>
    iunlockput(ip);
80105857:	83 ec 0c             	sub    $0xc,%esp
8010585a:	53                   	push   %ebx
8010585b:	e8 30 c8 ff ff       	call   80102090 <iunlockput>
    goto bad;
80105860:	83 c4 10             	add    $0x10,%esp
80105863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105867:	90                   	nop
  iunlockput(dp);
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	56                   	push   %esi
8010586c:	e8 1f c8 ff ff       	call   80102090 <iunlockput>
  end_op();
80105871:	e8 ba db ff ff       	call   80103430 <end_op>
  return -1;
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587e:	eb 92                	jmp    80105812 <sys_unlink+0x112>
    iupdate(dp);
80105880:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105883:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105888:	56                   	push   %esi
80105889:	e8 a2 c4 ff ff       	call   80101d30 <iupdate>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	e9 54 ff ff ff       	jmp    801057ea <sys_unlink+0xea>
80105896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	e9 68 ff ff ff       	jmp    80105812 <sys_unlink+0x112>
    end_op();
801058aa:	e8 81 db ff ff       	call   80103430 <end_op>
    return -1;
801058af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b4:	e9 59 ff ff ff       	jmp    80105812 <sys_unlink+0x112>
      panic("isdirempty: readi");
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	68 a8 7f 10 80       	push   $0x80107fa8
801058c1:	e8 ca aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801058c6:	83 ec 0c             	sub    $0xc,%esp
801058c9:	68 ba 7f 10 80       	push   $0x80107fba
801058ce:	e8 bd aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058d3:	83 ec 0c             	sub    $0xc,%esp
801058d6:	68 96 7f 10 80       	push   $0x80107f96
801058db:	e8 b0 aa ff ff       	call   80100390 <panic>

801058e0 <sys_open>:

int
sys_open(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	57                   	push   %edi
801058e8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058ec:	53                   	push   %ebx
801058ed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058f0:	50                   	push   %eax
801058f1:	6a 00                	push   $0x0
801058f3:	e8 28 f8 ff ff       	call   80105120 <argstr>
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	85 c0                	test   %eax,%eax
801058fd:	0f 88 8a 00 00 00    	js     8010598d <sys_open+0xad>
80105903:	83 ec 08             	sub    $0x8,%esp
80105906:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105909:	50                   	push   %eax
8010590a:	6a 01                	push   $0x1
8010590c:	e8 5f f7 ff ff       	call   80105070 <argint>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	85 c0                	test   %eax,%eax
80105916:	78 75                	js     8010598d <sys_open+0xad>
    return -1;

  begin_op();
80105918:	e8 a3 da ff ff       	call   801033c0 <begin_op>

  if(omode & O_CREATE){
8010591d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105921:	75 75                	jne    80105998 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105923:	83 ec 0c             	sub    $0xc,%esp
80105926:	ff 75 e0             	pushl  -0x20(%ebp)
80105929:	e8 92 cd ff ff       	call   801026c0 <namei>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	89 c6                	mov    %eax,%esi
80105933:	85 c0                	test   %eax,%eax
80105935:	74 7e                	je     801059b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105937:	83 ec 0c             	sub    $0xc,%esp
8010593a:	50                   	push   %eax
8010593b:	e8 b0 c4 ff ff       	call   80101df0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105940:	83 c4 10             	add    $0x10,%esp
80105943:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105948:	0f 84 c2 00 00 00    	je     80105a10 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010594e:	e8 3d bb ff ff       	call   80101490 <filealloc>
80105953:	89 c7                	mov    %eax,%edi
80105955:	85 c0                	test   %eax,%eax
80105957:	74 23                	je     8010597c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105959:	e8 92 e6 ff ff       	call   80103ff0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010595e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105960:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105964:	85 d2                	test   %edx,%edx
80105966:	74 60                	je     801059c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105968:	83 c3 01             	add    $0x1,%ebx
8010596b:	83 fb 10             	cmp    $0x10,%ebx
8010596e:	75 f0                	jne    80105960 <sys_open+0x80>
    if(f)
      fileclose(f);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	57                   	push   %edi
80105974:	e8 d7 bb ff ff       	call   80101550 <fileclose>
80105979:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010597c:	83 ec 0c             	sub    $0xc,%esp
8010597f:	56                   	push   %esi
80105980:	e8 0b c7 ff ff       	call   80102090 <iunlockput>
    end_op();
80105985:	e8 a6 da ff ff       	call   80103430 <end_op>
    return -1;
8010598a:	83 c4 10             	add    $0x10,%esp
8010598d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105992:	eb 6d                	jmp    80105a01 <sys_open+0x121>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010599e:	31 c9                	xor    %ecx,%ecx
801059a0:	ba 02 00 00 00       	mov    $0x2,%edx
801059a5:	6a 00                	push   $0x0
801059a7:	e8 24 f8 ff ff       	call   801051d0 <create>
    if(ip == 0){
801059ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059b1:	85 c0                	test   %eax,%eax
801059b3:	75 99                	jne    8010594e <sys_open+0x6e>
      end_op();
801059b5:	e8 76 da ff ff       	call   80103430 <end_op>
      return -1;
801059ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059bf:	eb 40                	jmp    80105a01 <sys_open+0x121>
801059c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059cf:	56                   	push   %esi
801059d0:	e8 fb c4 ff ff       	call   80101ed0 <iunlock>
  end_op();
801059d5:	e8 56 da ff ff       	call   80103430 <end_op>

  f->type = FD_INODE;
801059da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059f2:	f7 d0                	not    %eax
801059f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a04:	89 d8                	mov    %ebx,%eax
80105a06:	5b                   	pop    %ebx
80105a07:	5e                   	pop    %esi
80105a08:	5f                   	pop    %edi
80105a09:	5d                   	pop    %ebp
80105a0a:	c3                   	ret    
80105a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a13:	85 c9                	test   %ecx,%ecx
80105a15:	0f 84 33 ff ff ff    	je     8010594e <sys_open+0x6e>
80105a1b:	e9 5c ff ff ff       	jmp    8010597c <sys_open+0x9c>

80105a20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a2a:	e8 91 d9 ff ff       	call   801033c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a2f:	83 ec 08             	sub    $0x8,%esp
80105a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a35:	50                   	push   %eax
80105a36:	6a 00                	push   $0x0
80105a38:	e8 e3 f6 ff ff       	call   80105120 <argstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	78 34                	js     80105a78 <sys_mkdir+0x58>
80105a44:	83 ec 0c             	sub    $0xc,%esp
80105a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4a:	31 c9                	xor    %ecx,%ecx
80105a4c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a51:	6a 00                	push   $0x0
80105a53:	e8 78 f7 ff ff       	call   801051d0 <create>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	74 19                	je     80105a78 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	50                   	push   %eax
80105a63:	e8 28 c6 ff ff       	call   80102090 <iunlockput>
  end_op();
80105a68:	e8 c3 d9 ff ff       	call   80103430 <end_op>
  return 0;
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	31 c0                	xor    %eax,%eax
}
80105a72:	c9                   	leave  
80105a73:	c3                   	ret    
80105a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a78:	e8 b3 d9 ff ff       	call   80103430 <end_op>
    return -1;
80105a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    
80105a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop

80105a90 <sys_mknod>:

int
sys_mknod(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a9a:	e8 21 d9 ff ff       	call   801033c0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a9f:	83 ec 08             	sub    $0x8,%esp
80105aa2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aa5:	50                   	push   %eax
80105aa6:	6a 00                	push   $0x0
80105aa8:	e8 73 f6 ff ff       	call   80105120 <argstr>
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	85 c0                	test   %eax,%eax
80105ab2:	78 64                	js     80105b18 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ab4:	83 ec 08             	sub    $0x8,%esp
80105ab7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aba:	50                   	push   %eax
80105abb:	6a 01                	push   $0x1
80105abd:	e8 ae f5 ff ff       	call   80105070 <argint>
  if((argstr(0, &path)) < 0 ||
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	78 4f                	js     80105b18 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105ac9:	83 ec 08             	sub    $0x8,%esp
80105acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105acf:	50                   	push   %eax
80105ad0:	6a 02                	push   $0x2
80105ad2:	e8 99 f5 ff ff       	call   80105070 <argint>
     argint(1, &major) < 0 ||
80105ad7:	83 c4 10             	add    $0x10,%esp
80105ada:	85 c0                	test   %eax,%eax
80105adc:	78 3a                	js     80105b18 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ade:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ae9:	ba 03 00 00 00       	mov    $0x3,%edx
80105aee:	50                   	push   %eax
80105aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105af2:	e8 d9 f6 ff ff       	call   801051d0 <create>
     argint(2, &minor) < 0 ||
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	74 1a                	je     80105b18 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105afe:	83 ec 0c             	sub    $0xc,%esp
80105b01:	50                   	push   %eax
80105b02:	e8 89 c5 ff ff       	call   80102090 <iunlockput>
  end_op();
80105b07:	e8 24 d9 ff ff       	call   80103430 <end_op>
  return 0;
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	31 c0                	xor    %eax,%eax
}
80105b11:	c9                   	leave  
80105b12:	c3                   	ret    
80105b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b17:	90                   	nop
    end_op();
80105b18:	e8 13 d9 ff ff       	call   80103430 <end_op>
    return -1;
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b22:	c9                   	leave  
80105b23:	c3                   	ret    
80105b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <sys_chdir>:

int
sys_chdir(void)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	56                   	push   %esi
80105b38:	53                   	push   %ebx
80105b39:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b3c:	e8 af e4 ff ff       	call   80103ff0 <myproc>
80105b41:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b43:	e8 78 d8 ff ff       	call   801033c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b48:	83 ec 08             	sub    $0x8,%esp
80105b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b4e:	50                   	push   %eax
80105b4f:	6a 00                	push   $0x0
80105b51:	e8 ca f5 ff ff       	call   80105120 <argstr>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	78 73                	js     80105bd0 <sys_chdir+0xa0>
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	ff 75 f4             	pushl  -0xc(%ebp)
80105b63:	e8 58 cb ff ff       	call   801026c0 <namei>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	89 c3                	mov    %eax,%ebx
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	74 5f                	je     80105bd0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	50                   	push   %eax
80105b75:	e8 76 c2 ff ff       	call   80101df0 <ilock>
  if(ip->type != T_DIR){
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b82:	75 2c                	jne    80105bb0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	53                   	push   %ebx
80105b88:	e8 43 c3 ff ff       	call   80101ed0 <iunlock>
  iput(curproc->cwd);
80105b8d:	58                   	pop    %eax
80105b8e:	ff 76 68             	pushl  0x68(%esi)
80105b91:	e8 8a c3 ff ff       	call   80101f20 <iput>
  end_op();
80105b96:	e8 95 d8 ff ff       	call   80103430 <end_op>
  curproc->cwd = ip;
80105b9b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	31 c0                	xor    %eax,%eax
}
80105ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ba6:	5b                   	pop    %ebx
80105ba7:	5e                   	pop    %esi
80105ba8:	5d                   	pop    %ebp
80105ba9:	c3                   	ret    
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	53                   	push   %ebx
80105bb4:	e8 d7 c4 ff ff       	call   80102090 <iunlockput>
    end_op();
80105bb9:	e8 72 d8 ff ff       	call   80103430 <end_op>
    return -1;
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	eb db                	jmp    80105ba3 <sys_chdir+0x73>
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    end_op();
80105bd0:	e8 5b d8 ff ff       	call   80103430 <end_op>
    return -1;
80105bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bda:	eb c7                	jmp    80105ba3 <sys_chdir+0x73>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_exec>:

int
sys_exec(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	57                   	push   %edi
80105be8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105be9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bef:	53                   	push   %ebx
80105bf0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bf6:	50                   	push   %eax
80105bf7:	6a 00                	push   $0x0
80105bf9:	e8 22 f5 ff ff       	call   80105120 <argstr>
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	0f 88 8b 00 00 00    	js     80105c94 <sys_exec+0xb4>
80105c09:	83 ec 08             	sub    $0x8,%esp
80105c0c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c12:	50                   	push   %eax
80105c13:	6a 01                	push   $0x1
80105c15:	e8 56 f4 ff ff       	call   80105070 <argint>
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	78 73                	js     80105c94 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c21:	83 ec 04             	sub    $0x4,%esp
80105c24:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105c2a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c2c:	68 80 00 00 00       	push   $0x80
80105c31:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c37:	6a 00                	push   $0x0
80105c39:	50                   	push   %eax
80105c3a:	e8 51 f1 ff ff       	call   80104d90 <memset>
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c48:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c4e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	57                   	push   %edi
80105c59:	01 f0                	add    %esi,%eax
80105c5b:	50                   	push   %eax
80105c5c:	e8 6f f3 ff ff       	call   80104fd0 <fetchint>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	78 2c                	js     80105c94 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c68:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	74 36                	je     80105ca8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c72:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c78:	83 ec 08             	sub    $0x8,%esp
80105c7b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c7e:	52                   	push   %edx
80105c7f:	50                   	push   %eax
80105c80:	e8 8b f3 ff ff       	call   80105010 <fetchstr>
80105c85:	83 c4 10             	add    $0x10,%esp
80105c88:	85 c0                	test   %eax,%eax
80105c8a:	78 08                	js     80105c94 <sys_exec+0xb4>
  for(i=0;; i++){
80105c8c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c8f:	83 fb 20             	cmp    $0x20,%ebx
80105c92:	75 b4                	jne    80105c48 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c9c:	5b                   	pop    %ebx
80105c9d:	5e                   	pop    %esi
80105c9e:	5f                   	pop    %edi
80105c9f:	5d                   	pop    %ebp
80105ca0:	c3                   	ret    
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ca8:	83 ec 08             	sub    $0x8,%esp
80105cab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105cb1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cb8:	00 00 00 00 
  return exec(path, argv);
80105cbc:	50                   	push   %eax
80105cbd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105cc3:	e8 48 b4 ff ff       	call   80101110 <exec>
80105cc8:	83 c4 10             	add    $0x10,%esp
}
80105ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cce:	5b                   	pop    %ebx
80105ccf:	5e                   	pop    %esi
80105cd0:	5f                   	pop    %edi
80105cd1:	5d                   	pop    %ebp
80105cd2:	c3                   	ret    
80105cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ce0 <sys_pipe>:

int
sys_pipe(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	57                   	push   %edi
80105ce8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ce9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105cec:	53                   	push   %ebx
80105ced:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cf0:	6a 08                	push   $0x8
80105cf2:	50                   	push   %eax
80105cf3:	6a 00                	push   $0x0
80105cf5:	e8 c6 f3 ff ff       	call   801050c0 <argptr>
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	78 4e                	js     80105d4f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d01:	83 ec 08             	sub    $0x8,%esp
80105d04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d07:	50                   	push   %eax
80105d08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d0b:	50                   	push   %eax
80105d0c:	e8 6f dd ff ff       	call   80103a80 <pipealloc>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 37                	js     80105d4f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d18:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d1b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d1d:	e8 ce e2 ff ff       	call   80103ff0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105d28:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d2c:	85 f6                	test   %esi,%esi
80105d2e:	74 30                	je     80105d60 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105d30:	83 c3 01             	add    $0x1,%ebx
80105d33:	83 fb 10             	cmp    $0x10,%ebx
80105d36:	75 f0                	jne    80105d28 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d3e:	e8 0d b8 ff ff       	call   80101550 <fileclose>
    fileclose(wf);
80105d43:	58                   	pop    %eax
80105d44:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d47:	e8 04 b8 ff ff       	call   80101550 <fileclose>
    return -1;
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	eb 5b                	jmp    80105db1 <sys_pipe+0xd1>
80105d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d60:	8d 73 08             	lea    0x8(%ebx),%esi
80105d63:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d6a:	e8 81 e2 ff ff       	call   80103ff0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d6f:	31 d2                	xor    %edx,%edx
80105d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d78:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d7c:	85 c9                	test   %ecx,%ecx
80105d7e:	74 20                	je     80105da0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105d80:	83 c2 01             	add    $0x1,%edx
80105d83:	83 fa 10             	cmp    $0x10,%edx
80105d86:	75 f0                	jne    80105d78 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d88:	e8 63 e2 ff ff       	call   80103ff0 <myproc>
80105d8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d94:	00 
80105d95:	eb a1                	jmp    80105d38 <sys_pipe+0x58>
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105da0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105da7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105da9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105daf:	31 c0                	xor    %eax,%eax
}
80105db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db4:	5b                   	pop    %ebx
80105db5:	5e                   	pop    %esi
80105db6:	5f                   	pop    %edi
80105db7:	5d                   	pop    %ebp
80105db8:	c3                   	ret    
80105db9:	66 90                	xchg   %ax,%ax
80105dbb:	66 90                	xchg   %ax,%ax
80105dbd:	66 90                	xchg   %ax,%ax
80105dbf:	90                   	nop

80105dc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
  return fork();
80105dc4:	e9 d7 e3 ff ff       	jmp    801041a0 <fork>
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <sys_exit>:
}

int
sys_exit(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105dda:	e8 41 e6 ff ff       	call   80104420 <exit>
  return 0;  // not reached
}
80105ddf:	31 c0                	xor    %eax,%eax
80105de1:	c9                   	leave  
80105de2:	c3                   	ret    
80105de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105df0 <sys_wait>:

int
sys_wait(void)
{
80105df0:	f3 0f 1e fb          	endbr32 
  return wait();
80105df4:	e9 77 e8 ff ff       	jmp    80104670 <wait>
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_kill>:
}

int
sys_kill(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e0d:	50                   	push   %eax
80105e0e:	6a 00                	push   $0x0
80105e10:	e8 5b f2 ff ff       	call   80105070 <argint>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	85 c0                	test   %eax,%eax
80105e1a:	78 14                	js     80105e30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e1c:	83 ec 0c             	sub    $0xc,%esp
80105e1f:	ff 75 f4             	pushl  -0xc(%ebp)
80105e22:	e8 a9 e9 ff ff       	call   801047d0 <kill>
80105e27:	83 c4 10             	add    $0x10,%esp
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e30:	c9                   	leave  
    return -1;
80105e31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e36:	c3                   	ret    
80105e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <sys_getpid>:

int
sys_getpid(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e4a:	e8 a1 e1 ff ff       	call   80103ff0 <myproc>
80105e4f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e52:	c9                   	leave  
80105e53:	c3                   	ret    
80105e54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop

80105e60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e60:	f3 0f 1e fb          	endbr32 
80105e64:	55                   	push   %ebp
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e6e:	50                   	push   %eax
80105e6f:	6a 00                	push   $0x0
80105e71:	e8 fa f1 ff ff       	call   80105070 <argint>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	78 23                	js     80105ea0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e7d:	e8 6e e1 ff ff       	call   80103ff0 <myproc>
  if(growproc(n) < 0)
80105e82:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e85:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e87:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8a:	e8 91 e2 ff ff       	call   80104120 <growproc>
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	85 c0                	test   %eax,%eax
80105e94:	78 0a                	js     80105ea0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e96:	89 d8                	mov    %ebx,%eax
80105e98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e9b:	c9                   	leave  
80105e9c:	c3                   	ret    
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ea0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ea5:	eb ef                	jmp    80105e96 <sys_sbrk+0x36>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_sleep>:

int
sys_sleep(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105eb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ebb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ebe:	50                   	push   %eax
80105ebf:	6a 00                	push   $0x0
80105ec1:	e8 aa f1 ff ff       	call   80105070 <argint>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	0f 88 86 00 00 00    	js     80105f57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ed1:	83 ec 0c             	sub    $0xc,%esp
80105ed4:	68 a0 61 11 80       	push   $0x801161a0
80105ed9:	e8 a2 ed ff ff       	call   80104c80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ee1:	8b 1d e0 69 11 80    	mov    0x801169e0,%ebx
  while(ticks - ticks0 < n){
80105ee7:	83 c4 10             	add    $0x10,%esp
80105eea:	85 d2                	test   %edx,%edx
80105eec:	75 23                	jne    80105f11 <sys_sleep+0x61>
80105eee:	eb 50                	jmp    80105f40 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ef0:	83 ec 08             	sub    $0x8,%esp
80105ef3:	68 a0 61 11 80       	push   $0x801161a0
80105ef8:	68 e0 69 11 80       	push   $0x801169e0
80105efd:	e8 ae e6 ff ff       	call   801045b0 <sleep>
  while(ticks - ticks0 < n){
80105f02:	a1 e0 69 11 80       	mov    0x801169e0,%eax
80105f07:	83 c4 10             	add    $0x10,%esp
80105f0a:	29 d8                	sub    %ebx,%eax
80105f0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f0f:	73 2f                	jae    80105f40 <sys_sleep+0x90>
    if(myproc()->killed){
80105f11:	e8 da e0 ff ff       	call   80103ff0 <myproc>
80105f16:	8b 40 24             	mov    0x24(%eax),%eax
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 d3                	je     80105ef0 <sys_sleep+0x40>
      release(&tickslock);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	68 a0 61 11 80       	push   $0x801161a0
80105f25:	e8 16 ee ff ff       	call   80104d40 <release>
  }
  release(&tickslock);
  return 0;
}
80105f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f35:	c9                   	leave  
80105f36:	c3                   	ret    
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	68 a0 61 11 80       	push   $0x801161a0
80105f48:	e8 f3 ed ff ff       	call   80104d40 <release>
  return 0;
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	31 c0                	xor    %eax,%eax
}
80105f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
    return -1;
80105f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5c:	eb f4                	jmp    80105f52 <sys_sleep+0xa2>
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	53                   	push   %ebx
80105f68:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f6b:	68 a0 61 11 80       	push   $0x801161a0
80105f70:	e8 0b ed ff ff       	call   80104c80 <acquire>
  xticks = ticks;
80105f75:	8b 1d e0 69 11 80    	mov    0x801169e0,%ebx
  release(&tickslock);
80105f7b:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105f82:	e8 b9 ed ff ff       	call   80104d40 <release>
  return xticks;
}
80105f87:	89 d8                	mov    %ebx,%eax
80105f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f8c:	c9                   	leave  
80105f8d:	c3                   	ret    
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_find_next_prime_number>:

int sys_find_next_prime_number(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	57                   	push   %edi
80105f98:	83 ec 10             	sub    $0x10,%esp
  register int edi asm("edi");
  int num = edi;

  return find_next_prime_number(num);
80105f9b:	57                   	push   %edi
80105f9c:	e8 8f e9 ff ff       	call   80104930 <find_next_prime_number>
}
80105fa1:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105fa4:	c9                   	leave  
80105fa5:	c3                   	ret    
80105fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fad:	8d 76 00             	lea    0x0(%esi),%esi

80105fb0 <sys_get_call_count>:

int sys_get_call_count(void)
{
80105fb0:	f3 0f 1e fb          	endbr32 
  return 0;
}
80105fb4:	31 c0                	xor    %eax,%eax
80105fb6:	c3                   	ret    
80105fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <sys_get_most_caller>:
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	31 c0                	xor    %eax,%eax
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_wait_for_process>:
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	31 c0                	xor    %eax,%eax
80105fd6:	c3                   	ret    

80105fd7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fd7:	1e                   	push   %ds
  pushl %es
80105fd8:	06                   	push   %es
  pushl %fs
80105fd9:	0f a0                	push   %fs
  pushl %gs
80105fdb:	0f a8                	push   %gs
  pushal
80105fdd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fde:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fe2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fe4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fe6:	54                   	push   %esp
  call trap
80105fe7:	e8 c4 00 00 00       	call   801060b0 <trap>
  addl $4, %esp
80105fec:	83 c4 04             	add    $0x4,%esp

80105fef <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fef:	61                   	popa   
  popl %gs
80105ff0:	0f a9                	pop    %gs
  popl %fs
80105ff2:	0f a1                	pop    %fs
  popl %es
80105ff4:	07                   	pop    %es
  popl %ds
80105ff5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ff6:	83 c4 08             	add    $0x8,%esp
  iret
80105ff9:	cf                   	iret   
80105ffa:	66 90                	xchg   %ax,%ax
80105ffc:	66 90                	xchg   %ax,%ax
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106005:	31 c0                	xor    %eax,%eax
{
80106007:	89 e5                	mov    %esp,%ebp
80106009:	83 ec 08             	sub    $0x8,%esp
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106010:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106017:	c7 04 c5 e2 61 11 80 	movl   $0x8e000008,-0x7fee9e1e(,%eax,8)
8010601e:	08 00 00 8e 
80106022:	66 89 14 c5 e0 61 11 	mov    %dx,-0x7fee9e20(,%eax,8)
80106029:	80 
8010602a:	c1 ea 10             	shr    $0x10,%edx
8010602d:	66 89 14 c5 e6 61 11 	mov    %dx,-0x7fee9e1a(,%eax,8)
80106034:	80 
  for(i = 0; i < 256; i++)
80106035:	83 c0 01             	add    $0x1,%eax
80106038:	3d 00 01 00 00       	cmp    $0x100,%eax
8010603d:	75 d1                	jne    80106010 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010603f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106042:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106047:	c7 05 e2 63 11 80 08 	movl   $0xef000008,0x801163e2
8010604e:	00 00 ef 
  initlock(&tickslock, "time");
80106051:	68 c9 7f 10 80       	push   $0x80107fc9
80106056:	68 a0 61 11 80       	push   $0x801161a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010605b:	66 a3 e0 63 11 80    	mov    %ax,0x801163e0
80106061:	c1 e8 10             	shr    $0x10,%eax
80106064:	66 a3 e6 63 11 80    	mov    %ax,0x801163e6
  initlock(&tickslock, "time");
8010606a:	e8 91 ea ff ff       	call   80104b00 <initlock>
}
8010606f:	83 c4 10             	add    $0x10,%esp
80106072:	c9                   	leave  
80106073:	c3                   	ret    
80106074:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010607f:	90                   	nop

80106080 <idtinit>:

void
idtinit(void)
{
80106080:	f3 0f 1e fb          	endbr32 
80106084:	55                   	push   %ebp
  pd[0] = size-1;
80106085:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010608a:	89 e5                	mov    %esp,%ebp
8010608c:	83 ec 10             	sub    $0x10,%esp
8010608f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106093:	b8 e0 61 11 80       	mov    $0x801161e0,%eax
80106098:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010609c:	c1 e8 10             	shr    $0x10,%eax
8010609f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060a3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060a6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801060a9:	c9                   	leave  
801060aa:	c3                   	ret    
801060ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop

801060b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	57                   	push   %edi
801060b8:	56                   	push   %esi
801060b9:	53                   	push   %ebx
801060ba:	83 ec 1c             	sub    $0x1c,%esp
801060bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801060c0:	8b 43 30             	mov    0x30(%ebx),%eax
801060c3:	83 f8 40             	cmp    $0x40,%eax
801060c6:	0f 84 bc 01 00 00    	je     80106288 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060cc:	83 e8 20             	sub    $0x20,%eax
801060cf:	83 f8 1f             	cmp    $0x1f,%eax
801060d2:	77 08                	ja     801060dc <trap+0x2c>
801060d4:	3e ff 24 85 70 80 10 	notrack jmp *-0x7fef7f90(,%eax,4)
801060db:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801060dc:	e8 0f df ff ff       	call   80103ff0 <myproc>
801060e1:	8b 7b 38             	mov    0x38(%ebx),%edi
801060e4:	85 c0                	test   %eax,%eax
801060e6:	0f 84 eb 01 00 00    	je     801062d7 <trap+0x227>
801060ec:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060f0:	0f 84 e1 01 00 00    	je     801062d7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060f6:	0f 20 d1             	mov    %cr2,%ecx
801060f9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060fc:	e8 cf de ff ff       	call   80103fd0 <cpuid>
80106101:	8b 73 30             	mov    0x30(%ebx),%esi
80106104:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106107:	8b 43 34             	mov    0x34(%ebx),%eax
8010610a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010610d:	e8 de de ff ff       	call   80103ff0 <myproc>
80106112:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106115:	e8 d6 de ff ff       	call   80103ff0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010611a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010611d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106120:	51                   	push   %ecx
80106121:	57                   	push   %edi
80106122:	52                   	push   %edx
80106123:	ff 75 e4             	pushl  -0x1c(%ebp)
80106126:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106127:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010612a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010612d:	56                   	push   %esi
8010612e:	ff 70 10             	pushl  0x10(%eax)
80106131:	68 2c 80 10 80       	push   $0x8010802c
80106136:	e8 65 a6 ff ff       	call   801007a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010613b:	83 c4 20             	add    $0x20,%esp
8010613e:	e8 ad de ff ff       	call   80103ff0 <myproc>
80106143:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010614a:	e8 a1 de ff ff       	call   80103ff0 <myproc>
8010614f:	85 c0                	test   %eax,%eax
80106151:	74 1d                	je     80106170 <trap+0xc0>
80106153:	e8 98 de ff ff       	call   80103ff0 <myproc>
80106158:	8b 50 24             	mov    0x24(%eax),%edx
8010615b:	85 d2                	test   %edx,%edx
8010615d:	74 11                	je     80106170 <trap+0xc0>
8010615f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106163:	83 e0 03             	and    $0x3,%eax
80106166:	66 83 f8 03          	cmp    $0x3,%ax
8010616a:	0f 84 50 01 00 00    	je     801062c0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106170:	e8 7b de ff ff       	call   80103ff0 <myproc>
80106175:	85 c0                	test   %eax,%eax
80106177:	74 0f                	je     80106188 <trap+0xd8>
80106179:	e8 72 de ff ff       	call   80103ff0 <myproc>
8010617e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106182:	0f 84 e8 00 00 00    	je     80106270 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106188:	e8 63 de ff ff       	call   80103ff0 <myproc>
8010618d:	85 c0                	test   %eax,%eax
8010618f:	74 1d                	je     801061ae <trap+0xfe>
80106191:	e8 5a de ff ff       	call   80103ff0 <myproc>
80106196:	8b 40 24             	mov    0x24(%eax),%eax
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 11                	je     801061ae <trap+0xfe>
8010619d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061a1:	83 e0 03             	and    $0x3,%eax
801061a4:	66 83 f8 03          	cmp    $0x3,%ax
801061a8:	0f 84 03 01 00 00    	je     801062b1 <trap+0x201>
    exit();
}
801061ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b1:	5b                   	pop    %ebx
801061b2:	5e                   	pop    %esi
801061b3:	5f                   	pop    %edi
801061b4:	5d                   	pop    %ebp
801061b5:	c3                   	ret    
    ideintr();
801061b6:	e8 b5 c6 ff ff       	call   80102870 <ideintr>
    lapiceoi();
801061bb:	e8 90 cd ff ff       	call   80102f50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c0:	e8 2b de ff ff       	call   80103ff0 <myproc>
801061c5:	85 c0                	test   %eax,%eax
801061c7:	75 8a                	jne    80106153 <trap+0xa3>
801061c9:	eb a5                	jmp    80106170 <trap+0xc0>
    if(cpuid() == 0){
801061cb:	e8 00 de ff ff       	call   80103fd0 <cpuid>
801061d0:	85 c0                	test   %eax,%eax
801061d2:	75 e7                	jne    801061bb <trap+0x10b>
      acquire(&tickslock);
801061d4:	83 ec 0c             	sub    $0xc,%esp
801061d7:	68 a0 61 11 80       	push   $0x801161a0
801061dc:	e8 9f ea ff ff       	call   80104c80 <acquire>
      wakeup(&ticks);
801061e1:	c7 04 24 e0 69 11 80 	movl   $0x801169e0,(%esp)
      ticks++;
801061e8:	83 05 e0 69 11 80 01 	addl   $0x1,0x801169e0
      wakeup(&ticks);
801061ef:	e8 7c e5 ff ff       	call   80104770 <wakeup>
      release(&tickslock);
801061f4:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801061fb:	e8 40 eb ff ff       	call   80104d40 <release>
80106200:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106203:	eb b6                	jmp    801061bb <trap+0x10b>
    kbdintr();
80106205:	e8 06 cc ff ff       	call   80102e10 <kbdintr>
    lapiceoi();
8010620a:	e8 41 cd ff ff       	call   80102f50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010620f:	e8 dc dd ff ff       	call   80103ff0 <myproc>
80106214:	85 c0                	test   %eax,%eax
80106216:	0f 85 37 ff ff ff    	jne    80106153 <trap+0xa3>
8010621c:	e9 4f ff ff ff       	jmp    80106170 <trap+0xc0>
    uartintr();
80106221:	e8 4a 02 00 00       	call   80106470 <uartintr>
    lapiceoi();
80106226:	e8 25 cd ff ff       	call   80102f50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010622b:	e8 c0 dd ff ff       	call   80103ff0 <myproc>
80106230:	85 c0                	test   %eax,%eax
80106232:	0f 85 1b ff ff ff    	jne    80106153 <trap+0xa3>
80106238:	e9 33 ff ff ff       	jmp    80106170 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010623d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106240:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106244:	e8 87 dd ff ff       	call   80103fd0 <cpuid>
80106249:	57                   	push   %edi
8010624a:	56                   	push   %esi
8010624b:	50                   	push   %eax
8010624c:	68 d4 7f 10 80       	push   $0x80107fd4
80106251:	e8 4a a5 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
80106256:	e8 f5 cc ff ff       	call   80102f50 <lapiceoi>
    break;
8010625b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010625e:	e8 8d dd ff ff       	call   80103ff0 <myproc>
80106263:	85 c0                	test   %eax,%eax
80106265:	0f 85 e8 fe ff ff    	jne    80106153 <trap+0xa3>
8010626b:	e9 00 ff ff ff       	jmp    80106170 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106270:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106274:	0f 85 0e ff ff ff    	jne    80106188 <trap+0xd8>
    yield();
8010627a:	e8 e1 e2 ff ff       	call   80104560 <yield>
8010627f:	e9 04 ff ff ff       	jmp    80106188 <trap+0xd8>
80106284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106288:	e8 63 dd ff ff       	call   80103ff0 <myproc>
8010628d:	8b 70 24             	mov    0x24(%eax),%esi
80106290:	85 f6                	test   %esi,%esi
80106292:	75 3c                	jne    801062d0 <trap+0x220>
    myproc()->tf = tf;
80106294:	e8 57 dd ff ff       	call   80103ff0 <myproc>
80106299:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010629c:	e8 bf ee ff ff       	call   80105160 <syscall>
    if(myproc()->killed)
801062a1:	e8 4a dd ff ff       	call   80103ff0 <myproc>
801062a6:	8b 48 24             	mov    0x24(%eax),%ecx
801062a9:	85 c9                	test   %ecx,%ecx
801062ab:	0f 84 fd fe ff ff    	je     801061ae <trap+0xfe>
}
801062b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b4:	5b                   	pop    %ebx
801062b5:	5e                   	pop    %esi
801062b6:	5f                   	pop    %edi
801062b7:	5d                   	pop    %ebp
      exit();
801062b8:	e9 63 e1 ff ff       	jmp    80104420 <exit>
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801062c0:	e8 5b e1 ff ff       	call   80104420 <exit>
801062c5:	e9 a6 fe ff ff       	jmp    80106170 <trap+0xc0>
801062ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801062d0:	e8 4b e1 ff ff       	call   80104420 <exit>
801062d5:	eb bd                	jmp    80106294 <trap+0x1e4>
801062d7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062da:	e8 f1 dc ff ff       	call   80103fd0 <cpuid>
801062df:	83 ec 0c             	sub    $0xc,%esp
801062e2:	56                   	push   %esi
801062e3:	57                   	push   %edi
801062e4:	50                   	push   %eax
801062e5:	ff 73 30             	pushl  0x30(%ebx)
801062e8:	68 f8 7f 10 80       	push   $0x80107ff8
801062ed:	e8 ae a4 ff ff       	call   801007a0 <cprintf>
      panic("trap");
801062f2:	83 c4 14             	add    $0x14,%esp
801062f5:	68 ce 7f 10 80       	push   $0x80107fce
801062fa:	e8 91 a0 ff ff       	call   80100390 <panic>
801062ff:	90                   	nop

80106300 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106300:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106304:	a1 fc b5 10 80       	mov    0x8010b5fc,%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	74 1b                	je     80106328 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010630d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106312:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106313:	a8 01                	test   $0x1,%al
80106315:	74 11                	je     80106328 <uartgetc+0x28>
80106317:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010631d:	0f b6 c0             	movzbl %al,%eax
80106320:	c3                   	ret    
80106321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010632d:	c3                   	ret    
8010632e:	66 90                	xchg   %ax,%ax

80106330 <uartputc.part.0>:
uartputc(int c)
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	89 c7                	mov    %eax,%edi
80106336:	56                   	push   %esi
80106337:	be fd 03 00 00       	mov    $0x3fd,%esi
8010633c:	53                   	push   %ebx
8010633d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106342:	83 ec 0c             	sub    $0xc,%esp
80106345:	eb 1b                	jmp    80106362 <uartputc.part.0+0x32>
80106347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	6a 0a                	push   $0xa
80106355:	e8 16 cc ff ff       	call   80102f70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010635a:	83 c4 10             	add    $0x10,%esp
8010635d:	83 eb 01             	sub    $0x1,%ebx
80106360:	74 07                	je     80106369 <uartputc.part.0+0x39>
80106362:	89 f2                	mov    %esi,%edx
80106364:	ec                   	in     (%dx),%al
80106365:	a8 20                	test   $0x20,%al
80106367:	74 e7                	je     80106350 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106369:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010636e:	89 f8                	mov    %edi,%eax
80106370:	ee                   	out    %al,(%dx)
}
80106371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106374:	5b                   	pop    %ebx
80106375:	5e                   	pop    %esi
80106376:	5f                   	pop    %edi
80106377:	5d                   	pop    %ebp
80106378:	c3                   	ret    
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106380 <uartinit>:
{
80106380:	f3 0f 1e fb          	endbr32 
80106384:	55                   	push   %ebp
80106385:	31 c9                	xor    %ecx,%ecx
80106387:	89 c8                	mov    %ecx,%eax
80106389:	89 e5                	mov    %esp,%ebp
8010638b:	57                   	push   %edi
8010638c:	56                   	push   %esi
8010638d:	53                   	push   %ebx
8010638e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106393:	89 da                	mov    %ebx,%edx
80106395:	83 ec 0c             	sub    $0xc,%esp
80106398:	ee                   	out    %al,(%dx)
80106399:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010639e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801063a3:	89 fa                	mov    %edi,%edx
801063a5:	ee                   	out    %al,(%dx)
801063a6:	b8 0c 00 00 00       	mov    $0xc,%eax
801063ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063b0:	ee                   	out    %al,(%dx)
801063b1:	be f9 03 00 00       	mov    $0x3f9,%esi
801063b6:	89 c8                	mov    %ecx,%eax
801063b8:	89 f2                	mov    %esi,%edx
801063ba:	ee                   	out    %al,(%dx)
801063bb:	b8 03 00 00 00       	mov    $0x3,%eax
801063c0:	89 fa                	mov    %edi,%edx
801063c2:	ee                   	out    %al,(%dx)
801063c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063c8:	89 c8                	mov    %ecx,%eax
801063ca:	ee                   	out    %al,(%dx)
801063cb:	b8 01 00 00 00       	mov    $0x1,%eax
801063d0:	89 f2                	mov    %esi,%edx
801063d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063d9:	3c ff                	cmp    $0xff,%al
801063db:	74 52                	je     8010642f <uartinit+0xaf>
  uart = 1;
801063dd:	c7 05 fc b5 10 80 01 	movl   $0x1,0x8010b5fc
801063e4:	00 00 00 
801063e7:	89 da                	mov    %ebx,%edx
801063e9:	ec                   	in     (%dx),%al
801063ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063f0:	83 ec 08             	sub    $0x8,%esp
801063f3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801063f8:	bb f0 80 10 80       	mov    $0x801080f0,%ebx
  ioapicenable(IRQ_COM1, 0);
801063fd:	6a 00                	push   $0x0
801063ff:	6a 04                	push   $0x4
80106401:	e8 ba c6 ff ff       	call   80102ac0 <ioapicenable>
80106406:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106409:	b8 78 00 00 00       	mov    $0x78,%eax
8010640e:	eb 04                	jmp    80106414 <uartinit+0x94>
80106410:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106414:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
8010641a:	85 d2                	test   %edx,%edx
8010641c:	74 08                	je     80106426 <uartinit+0xa6>
    uartputc(*p);
8010641e:	0f be c0             	movsbl %al,%eax
80106421:	e8 0a ff ff ff       	call   80106330 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106426:	89 f0                	mov    %esi,%eax
80106428:	83 c3 01             	add    $0x1,%ebx
8010642b:	84 c0                	test   %al,%al
8010642d:	75 e1                	jne    80106410 <uartinit+0x90>
}
8010642f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106432:	5b                   	pop    %ebx
80106433:	5e                   	pop    %esi
80106434:	5f                   	pop    %edi
80106435:	5d                   	pop    %ebp
80106436:	c3                   	ret    
80106437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010643e:	66 90                	xchg   %ax,%ax

80106440 <uartputc>:
{
80106440:	f3 0f 1e fb          	endbr32 
80106444:	55                   	push   %ebp
  if(!uart)
80106445:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
{
8010644b:	89 e5                	mov    %esp,%ebp
8010644d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106450:	85 d2                	test   %edx,%edx
80106452:	74 0c                	je     80106460 <uartputc+0x20>
}
80106454:	5d                   	pop    %ebp
80106455:	e9 d6 fe ff ff       	jmp    80106330 <uartputc.part.0>
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106460:	5d                   	pop    %ebp
80106461:	c3                   	ret    
80106462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106470 <uartintr>:

void
uartintr(void)
{
80106470:	f3 0f 1e fb          	endbr32 
80106474:	55                   	push   %ebp
80106475:	89 e5                	mov    %esp,%ebp
80106477:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010647a:	68 00 63 10 80       	push   $0x80106300
8010647f:	e8 7c a7 ff ff       	call   80100c00 <consoleintr>
}
80106484:	83 c4 10             	add    $0x10,%esp
80106487:	c9                   	leave  
80106488:	c3                   	ret    

80106489 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $0
8010648b:	6a 00                	push   $0x0
  jmp alltraps
8010648d:	e9 45 fb ff ff       	jmp    80105fd7 <alltraps>

80106492 <vector1>:
.globl vector1
vector1:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $1
80106494:	6a 01                	push   $0x1
  jmp alltraps
80106496:	e9 3c fb ff ff       	jmp    80105fd7 <alltraps>

8010649b <vector2>:
.globl vector2
vector2:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $2
8010649d:	6a 02                	push   $0x2
  jmp alltraps
8010649f:	e9 33 fb ff ff       	jmp    80105fd7 <alltraps>

801064a4 <vector3>:
.globl vector3
vector3:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $3
801064a6:	6a 03                	push   $0x3
  jmp alltraps
801064a8:	e9 2a fb ff ff       	jmp    80105fd7 <alltraps>

801064ad <vector4>:
.globl vector4
vector4:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $4
801064af:	6a 04                	push   $0x4
  jmp alltraps
801064b1:	e9 21 fb ff ff       	jmp    80105fd7 <alltraps>

801064b6 <vector5>:
.globl vector5
vector5:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $5
801064b8:	6a 05                	push   $0x5
  jmp alltraps
801064ba:	e9 18 fb ff ff       	jmp    80105fd7 <alltraps>

801064bf <vector6>:
.globl vector6
vector6:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $6
801064c1:	6a 06                	push   $0x6
  jmp alltraps
801064c3:	e9 0f fb ff ff       	jmp    80105fd7 <alltraps>

801064c8 <vector7>:
.globl vector7
vector7:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $7
801064ca:	6a 07                	push   $0x7
  jmp alltraps
801064cc:	e9 06 fb ff ff       	jmp    80105fd7 <alltraps>

801064d1 <vector8>:
.globl vector8
vector8:
  pushl $8
801064d1:	6a 08                	push   $0x8
  jmp alltraps
801064d3:	e9 ff fa ff ff       	jmp    80105fd7 <alltraps>

801064d8 <vector9>:
.globl vector9
vector9:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $9
801064da:	6a 09                	push   $0x9
  jmp alltraps
801064dc:	e9 f6 fa ff ff       	jmp    80105fd7 <alltraps>

801064e1 <vector10>:
.globl vector10
vector10:
  pushl $10
801064e1:	6a 0a                	push   $0xa
  jmp alltraps
801064e3:	e9 ef fa ff ff       	jmp    80105fd7 <alltraps>

801064e8 <vector11>:
.globl vector11
vector11:
  pushl $11
801064e8:	6a 0b                	push   $0xb
  jmp alltraps
801064ea:	e9 e8 fa ff ff       	jmp    80105fd7 <alltraps>

801064ef <vector12>:
.globl vector12
vector12:
  pushl $12
801064ef:	6a 0c                	push   $0xc
  jmp alltraps
801064f1:	e9 e1 fa ff ff       	jmp    80105fd7 <alltraps>

801064f6 <vector13>:
.globl vector13
vector13:
  pushl $13
801064f6:	6a 0d                	push   $0xd
  jmp alltraps
801064f8:	e9 da fa ff ff       	jmp    80105fd7 <alltraps>

801064fd <vector14>:
.globl vector14
vector14:
  pushl $14
801064fd:	6a 0e                	push   $0xe
  jmp alltraps
801064ff:	e9 d3 fa ff ff       	jmp    80105fd7 <alltraps>

80106504 <vector15>:
.globl vector15
vector15:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $15
80106506:	6a 0f                	push   $0xf
  jmp alltraps
80106508:	e9 ca fa ff ff       	jmp    80105fd7 <alltraps>

8010650d <vector16>:
.globl vector16
vector16:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $16
8010650f:	6a 10                	push   $0x10
  jmp alltraps
80106511:	e9 c1 fa ff ff       	jmp    80105fd7 <alltraps>

80106516 <vector17>:
.globl vector17
vector17:
  pushl $17
80106516:	6a 11                	push   $0x11
  jmp alltraps
80106518:	e9 ba fa ff ff       	jmp    80105fd7 <alltraps>

8010651d <vector18>:
.globl vector18
vector18:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $18
8010651f:	6a 12                	push   $0x12
  jmp alltraps
80106521:	e9 b1 fa ff ff       	jmp    80105fd7 <alltraps>

80106526 <vector19>:
.globl vector19
vector19:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $19
80106528:	6a 13                	push   $0x13
  jmp alltraps
8010652a:	e9 a8 fa ff ff       	jmp    80105fd7 <alltraps>

8010652f <vector20>:
.globl vector20
vector20:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $20
80106531:	6a 14                	push   $0x14
  jmp alltraps
80106533:	e9 9f fa ff ff       	jmp    80105fd7 <alltraps>

80106538 <vector21>:
.globl vector21
vector21:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $21
8010653a:	6a 15                	push   $0x15
  jmp alltraps
8010653c:	e9 96 fa ff ff       	jmp    80105fd7 <alltraps>

80106541 <vector22>:
.globl vector22
vector22:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $22
80106543:	6a 16                	push   $0x16
  jmp alltraps
80106545:	e9 8d fa ff ff       	jmp    80105fd7 <alltraps>

8010654a <vector23>:
.globl vector23
vector23:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $23
8010654c:	6a 17                	push   $0x17
  jmp alltraps
8010654e:	e9 84 fa ff ff       	jmp    80105fd7 <alltraps>

80106553 <vector24>:
.globl vector24
vector24:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $24
80106555:	6a 18                	push   $0x18
  jmp alltraps
80106557:	e9 7b fa ff ff       	jmp    80105fd7 <alltraps>

8010655c <vector25>:
.globl vector25
vector25:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $25
8010655e:	6a 19                	push   $0x19
  jmp alltraps
80106560:	e9 72 fa ff ff       	jmp    80105fd7 <alltraps>

80106565 <vector26>:
.globl vector26
vector26:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $26
80106567:	6a 1a                	push   $0x1a
  jmp alltraps
80106569:	e9 69 fa ff ff       	jmp    80105fd7 <alltraps>

8010656e <vector27>:
.globl vector27
vector27:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $27
80106570:	6a 1b                	push   $0x1b
  jmp alltraps
80106572:	e9 60 fa ff ff       	jmp    80105fd7 <alltraps>

80106577 <vector28>:
.globl vector28
vector28:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $28
80106579:	6a 1c                	push   $0x1c
  jmp alltraps
8010657b:	e9 57 fa ff ff       	jmp    80105fd7 <alltraps>

80106580 <vector29>:
.globl vector29
vector29:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $29
80106582:	6a 1d                	push   $0x1d
  jmp alltraps
80106584:	e9 4e fa ff ff       	jmp    80105fd7 <alltraps>

80106589 <vector30>:
.globl vector30
vector30:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $30
8010658b:	6a 1e                	push   $0x1e
  jmp alltraps
8010658d:	e9 45 fa ff ff       	jmp    80105fd7 <alltraps>

80106592 <vector31>:
.globl vector31
vector31:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $31
80106594:	6a 1f                	push   $0x1f
  jmp alltraps
80106596:	e9 3c fa ff ff       	jmp    80105fd7 <alltraps>

8010659b <vector32>:
.globl vector32
vector32:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $32
8010659d:	6a 20                	push   $0x20
  jmp alltraps
8010659f:	e9 33 fa ff ff       	jmp    80105fd7 <alltraps>

801065a4 <vector33>:
.globl vector33
vector33:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $33
801065a6:	6a 21                	push   $0x21
  jmp alltraps
801065a8:	e9 2a fa ff ff       	jmp    80105fd7 <alltraps>

801065ad <vector34>:
.globl vector34
vector34:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $34
801065af:	6a 22                	push   $0x22
  jmp alltraps
801065b1:	e9 21 fa ff ff       	jmp    80105fd7 <alltraps>

801065b6 <vector35>:
.globl vector35
vector35:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $35
801065b8:	6a 23                	push   $0x23
  jmp alltraps
801065ba:	e9 18 fa ff ff       	jmp    80105fd7 <alltraps>

801065bf <vector36>:
.globl vector36
vector36:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $36
801065c1:	6a 24                	push   $0x24
  jmp alltraps
801065c3:	e9 0f fa ff ff       	jmp    80105fd7 <alltraps>

801065c8 <vector37>:
.globl vector37
vector37:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $37
801065ca:	6a 25                	push   $0x25
  jmp alltraps
801065cc:	e9 06 fa ff ff       	jmp    80105fd7 <alltraps>

801065d1 <vector38>:
.globl vector38
vector38:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $38
801065d3:	6a 26                	push   $0x26
  jmp alltraps
801065d5:	e9 fd f9 ff ff       	jmp    80105fd7 <alltraps>

801065da <vector39>:
.globl vector39
vector39:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $39
801065dc:	6a 27                	push   $0x27
  jmp alltraps
801065de:	e9 f4 f9 ff ff       	jmp    80105fd7 <alltraps>

801065e3 <vector40>:
.globl vector40
vector40:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $40
801065e5:	6a 28                	push   $0x28
  jmp alltraps
801065e7:	e9 eb f9 ff ff       	jmp    80105fd7 <alltraps>

801065ec <vector41>:
.globl vector41
vector41:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $41
801065ee:	6a 29                	push   $0x29
  jmp alltraps
801065f0:	e9 e2 f9 ff ff       	jmp    80105fd7 <alltraps>

801065f5 <vector42>:
.globl vector42
vector42:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $42
801065f7:	6a 2a                	push   $0x2a
  jmp alltraps
801065f9:	e9 d9 f9 ff ff       	jmp    80105fd7 <alltraps>

801065fe <vector43>:
.globl vector43
vector43:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $43
80106600:	6a 2b                	push   $0x2b
  jmp alltraps
80106602:	e9 d0 f9 ff ff       	jmp    80105fd7 <alltraps>

80106607 <vector44>:
.globl vector44
vector44:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $44
80106609:	6a 2c                	push   $0x2c
  jmp alltraps
8010660b:	e9 c7 f9 ff ff       	jmp    80105fd7 <alltraps>

80106610 <vector45>:
.globl vector45
vector45:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $45
80106612:	6a 2d                	push   $0x2d
  jmp alltraps
80106614:	e9 be f9 ff ff       	jmp    80105fd7 <alltraps>

80106619 <vector46>:
.globl vector46
vector46:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $46
8010661b:	6a 2e                	push   $0x2e
  jmp alltraps
8010661d:	e9 b5 f9 ff ff       	jmp    80105fd7 <alltraps>

80106622 <vector47>:
.globl vector47
vector47:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $47
80106624:	6a 2f                	push   $0x2f
  jmp alltraps
80106626:	e9 ac f9 ff ff       	jmp    80105fd7 <alltraps>

8010662b <vector48>:
.globl vector48
vector48:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $48
8010662d:	6a 30                	push   $0x30
  jmp alltraps
8010662f:	e9 a3 f9 ff ff       	jmp    80105fd7 <alltraps>

80106634 <vector49>:
.globl vector49
vector49:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $49
80106636:	6a 31                	push   $0x31
  jmp alltraps
80106638:	e9 9a f9 ff ff       	jmp    80105fd7 <alltraps>

8010663d <vector50>:
.globl vector50
vector50:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $50
8010663f:	6a 32                	push   $0x32
  jmp alltraps
80106641:	e9 91 f9 ff ff       	jmp    80105fd7 <alltraps>

80106646 <vector51>:
.globl vector51
vector51:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $51
80106648:	6a 33                	push   $0x33
  jmp alltraps
8010664a:	e9 88 f9 ff ff       	jmp    80105fd7 <alltraps>

8010664f <vector52>:
.globl vector52
vector52:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $52
80106651:	6a 34                	push   $0x34
  jmp alltraps
80106653:	e9 7f f9 ff ff       	jmp    80105fd7 <alltraps>

80106658 <vector53>:
.globl vector53
vector53:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $53
8010665a:	6a 35                	push   $0x35
  jmp alltraps
8010665c:	e9 76 f9 ff ff       	jmp    80105fd7 <alltraps>

80106661 <vector54>:
.globl vector54
vector54:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $54
80106663:	6a 36                	push   $0x36
  jmp alltraps
80106665:	e9 6d f9 ff ff       	jmp    80105fd7 <alltraps>

8010666a <vector55>:
.globl vector55
vector55:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $55
8010666c:	6a 37                	push   $0x37
  jmp alltraps
8010666e:	e9 64 f9 ff ff       	jmp    80105fd7 <alltraps>

80106673 <vector56>:
.globl vector56
vector56:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $56
80106675:	6a 38                	push   $0x38
  jmp alltraps
80106677:	e9 5b f9 ff ff       	jmp    80105fd7 <alltraps>

8010667c <vector57>:
.globl vector57
vector57:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $57
8010667e:	6a 39                	push   $0x39
  jmp alltraps
80106680:	e9 52 f9 ff ff       	jmp    80105fd7 <alltraps>

80106685 <vector58>:
.globl vector58
vector58:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $58
80106687:	6a 3a                	push   $0x3a
  jmp alltraps
80106689:	e9 49 f9 ff ff       	jmp    80105fd7 <alltraps>

8010668e <vector59>:
.globl vector59
vector59:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $59
80106690:	6a 3b                	push   $0x3b
  jmp alltraps
80106692:	e9 40 f9 ff ff       	jmp    80105fd7 <alltraps>

80106697 <vector60>:
.globl vector60
vector60:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $60
80106699:	6a 3c                	push   $0x3c
  jmp alltraps
8010669b:	e9 37 f9 ff ff       	jmp    80105fd7 <alltraps>

801066a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $61
801066a2:	6a 3d                	push   $0x3d
  jmp alltraps
801066a4:	e9 2e f9 ff ff       	jmp    80105fd7 <alltraps>

801066a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $62
801066ab:	6a 3e                	push   $0x3e
  jmp alltraps
801066ad:	e9 25 f9 ff ff       	jmp    80105fd7 <alltraps>

801066b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $63
801066b4:	6a 3f                	push   $0x3f
  jmp alltraps
801066b6:	e9 1c f9 ff ff       	jmp    80105fd7 <alltraps>

801066bb <vector64>:
.globl vector64
vector64:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $64
801066bd:	6a 40                	push   $0x40
  jmp alltraps
801066bf:	e9 13 f9 ff ff       	jmp    80105fd7 <alltraps>

801066c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $65
801066c6:	6a 41                	push   $0x41
  jmp alltraps
801066c8:	e9 0a f9 ff ff       	jmp    80105fd7 <alltraps>

801066cd <vector66>:
.globl vector66
vector66:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $66
801066cf:	6a 42                	push   $0x42
  jmp alltraps
801066d1:	e9 01 f9 ff ff       	jmp    80105fd7 <alltraps>

801066d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $67
801066d8:	6a 43                	push   $0x43
  jmp alltraps
801066da:	e9 f8 f8 ff ff       	jmp    80105fd7 <alltraps>

801066df <vector68>:
.globl vector68
vector68:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $68
801066e1:	6a 44                	push   $0x44
  jmp alltraps
801066e3:	e9 ef f8 ff ff       	jmp    80105fd7 <alltraps>

801066e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $69
801066ea:	6a 45                	push   $0x45
  jmp alltraps
801066ec:	e9 e6 f8 ff ff       	jmp    80105fd7 <alltraps>

801066f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $70
801066f3:	6a 46                	push   $0x46
  jmp alltraps
801066f5:	e9 dd f8 ff ff       	jmp    80105fd7 <alltraps>

801066fa <vector71>:
.globl vector71
vector71:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $71
801066fc:	6a 47                	push   $0x47
  jmp alltraps
801066fe:	e9 d4 f8 ff ff       	jmp    80105fd7 <alltraps>

80106703 <vector72>:
.globl vector72
vector72:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $72
80106705:	6a 48                	push   $0x48
  jmp alltraps
80106707:	e9 cb f8 ff ff       	jmp    80105fd7 <alltraps>

8010670c <vector73>:
.globl vector73
vector73:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $73
8010670e:	6a 49                	push   $0x49
  jmp alltraps
80106710:	e9 c2 f8 ff ff       	jmp    80105fd7 <alltraps>

80106715 <vector74>:
.globl vector74
vector74:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $74
80106717:	6a 4a                	push   $0x4a
  jmp alltraps
80106719:	e9 b9 f8 ff ff       	jmp    80105fd7 <alltraps>

8010671e <vector75>:
.globl vector75
vector75:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $75
80106720:	6a 4b                	push   $0x4b
  jmp alltraps
80106722:	e9 b0 f8 ff ff       	jmp    80105fd7 <alltraps>

80106727 <vector76>:
.globl vector76
vector76:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $76
80106729:	6a 4c                	push   $0x4c
  jmp alltraps
8010672b:	e9 a7 f8 ff ff       	jmp    80105fd7 <alltraps>

80106730 <vector77>:
.globl vector77
vector77:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $77
80106732:	6a 4d                	push   $0x4d
  jmp alltraps
80106734:	e9 9e f8 ff ff       	jmp    80105fd7 <alltraps>

80106739 <vector78>:
.globl vector78
vector78:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $78
8010673b:	6a 4e                	push   $0x4e
  jmp alltraps
8010673d:	e9 95 f8 ff ff       	jmp    80105fd7 <alltraps>

80106742 <vector79>:
.globl vector79
vector79:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $79
80106744:	6a 4f                	push   $0x4f
  jmp alltraps
80106746:	e9 8c f8 ff ff       	jmp    80105fd7 <alltraps>

8010674b <vector80>:
.globl vector80
vector80:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $80
8010674d:	6a 50                	push   $0x50
  jmp alltraps
8010674f:	e9 83 f8 ff ff       	jmp    80105fd7 <alltraps>

80106754 <vector81>:
.globl vector81
vector81:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $81
80106756:	6a 51                	push   $0x51
  jmp alltraps
80106758:	e9 7a f8 ff ff       	jmp    80105fd7 <alltraps>

8010675d <vector82>:
.globl vector82
vector82:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $82
8010675f:	6a 52                	push   $0x52
  jmp alltraps
80106761:	e9 71 f8 ff ff       	jmp    80105fd7 <alltraps>

80106766 <vector83>:
.globl vector83
vector83:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $83
80106768:	6a 53                	push   $0x53
  jmp alltraps
8010676a:	e9 68 f8 ff ff       	jmp    80105fd7 <alltraps>

8010676f <vector84>:
.globl vector84
vector84:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $84
80106771:	6a 54                	push   $0x54
  jmp alltraps
80106773:	e9 5f f8 ff ff       	jmp    80105fd7 <alltraps>

80106778 <vector85>:
.globl vector85
vector85:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $85
8010677a:	6a 55                	push   $0x55
  jmp alltraps
8010677c:	e9 56 f8 ff ff       	jmp    80105fd7 <alltraps>

80106781 <vector86>:
.globl vector86
vector86:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $86
80106783:	6a 56                	push   $0x56
  jmp alltraps
80106785:	e9 4d f8 ff ff       	jmp    80105fd7 <alltraps>

8010678a <vector87>:
.globl vector87
vector87:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $87
8010678c:	6a 57                	push   $0x57
  jmp alltraps
8010678e:	e9 44 f8 ff ff       	jmp    80105fd7 <alltraps>

80106793 <vector88>:
.globl vector88
vector88:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $88
80106795:	6a 58                	push   $0x58
  jmp alltraps
80106797:	e9 3b f8 ff ff       	jmp    80105fd7 <alltraps>

8010679c <vector89>:
.globl vector89
vector89:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $89
8010679e:	6a 59                	push   $0x59
  jmp alltraps
801067a0:	e9 32 f8 ff ff       	jmp    80105fd7 <alltraps>

801067a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $90
801067a7:	6a 5a                	push   $0x5a
  jmp alltraps
801067a9:	e9 29 f8 ff ff       	jmp    80105fd7 <alltraps>

801067ae <vector91>:
.globl vector91
vector91:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $91
801067b0:	6a 5b                	push   $0x5b
  jmp alltraps
801067b2:	e9 20 f8 ff ff       	jmp    80105fd7 <alltraps>

801067b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $92
801067b9:	6a 5c                	push   $0x5c
  jmp alltraps
801067bb:	e9 17 f8 ff ff       	jmp    80105fd7 <alltraps>

801067c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $93
801067c2:	6a 5d                	push   $0x5d
  jmp alltraps
801067c4:	e9 0e f8 ff ff       	jmp    80105fd7 <alltraps>

801067c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $94
801067cb:	6a 5e                	push   $0x5e
  jmp alltraps
801067cd:	e9 05 f8 ff ff       	jmp    80105fd7 <alltraps>

801067d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $95
801067d4:	6a 5f                	push   $0x5f
  jmp alltraps
801067d6:	e9 fc f7 ff ff       	jmp    80105fd7 <alltraps>

801067db <vector96>:
.globl vector96
vector96:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $96
801067dd:	6a 60                	push   $0x60
  jmp alltraps
801067df:	e9 f3 f7 ff ff       	jmp    80105fd7 <alltraps>

801067e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $97
801067e6:	6a 61                	push   $0x61
  jmp alltraps
801067e8:	e9 ea f7 ff ff       	jmp    80105fd7 <alltraps>

801067ed <vector98>:
.globl vector98
vector98:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $98
801067ef:	6a 62                	push   $0x62
  jmp alltraps
801067f1:	e9 e1 f7 ff ff       	jmp    80105fd7 <alltraps>

801067f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $99
801067f8:	6a 63                	push   $0x63
  jmp alltraps
801067fa:	e9 d8 f7 ff ff       	jmp    80105fd7 <alltraps>

801067ff <vector100>:
.globl vector100
vector100:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $100
80106801:	6a 64                	push   $0x64
  jmp alltraps
80106803:	e9 cf f7 ff ff       	jmp    80105fd7 <alltraps>

80106808 <vector101>:
.globl vector101
vector101:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $101
8010680a:	6a 65                	push   $0x65
  jmp alltraps
8010680c:	e9 c6 f7 ff ff       	jmp    80105fd7 <alltraps>

80106811 <vector102>:
.globl vector102
vector102:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $102
80106813:	6a 66                	push   $0x66
  jmp alltraps
80106815:	e9 bd f7 ff ff       	jmp    80105fd7 <alltraps>

8010681a <vector103>:
.globl vector103
vector103:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $103
8010681c:	6a 67                	push   $0x67
  jmp alltraps
8010681e:	e9 b4 f7 ff ff       	jmp    80105fd7 <alltraps>

80106823 <vector104>:
.globl vector104
vector104:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $104
80106825:	6a 68                	push   $0x68
  jmp alltraps
80106827:	e9 ab f7 ff ff       	jmp    80105fd7 <alltraps>

8010682c <vector105>:
.globl vector105
vector105:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $105
8010682e:	6a 69                	push   $0x69
  jmp alltraps
80106830:	e9 a2 f7 ff ff       	jmp    80105fd7 <alltraps>

80106835 <vector106>:
.globl vector106
vector106:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $106
80106837:	6a 6a                	push   $0x6a
  jmp alltraps
80106839:	e9 99 f7 ff ff       	jmp    80105fd7 <alltraps>

8010683e <vector107>:
.globl vector107
vector107:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $107
80106840:	6a 6b                	push   $0x6b
  jmp alltraps
80106842:	e9 90 f7 ff ff       	jmp    80105fd7 <alltraps>

80106847 <vector108>:
.globl vector108
vector108:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $108
80106849:	6a 6c                	push   $0x6c
  jmp alltraps
8010684b:	e9 87 f7 ff ff       	jmp    80105fd7 <alltraps>

80106850 <vector109>:
.globl vector109
vector109:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $109
80106852:	6a 6d                	push   $0x6d
  jmp alltraps
80106854:	e9 7e f7 ff ff       	jmp    80105fd7 <alltraps>

80106859 <vector110>:
.globl vector110
vector110:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $110
8010685b:	6a 6e                	push   $0x6e
  jmp alltraps
8010685d:	e9 75 f7 ff ff       	jmp    80105fd7 <alltraps>

80106862 <vector111>:
.globl vector111
vector111:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $111
80106864:	6a 6f                	push   $0x6f
  jmp alltraps
80106866:	e9 6c f7 ff ff       	jmp    80105fd7 <alltraps>

8010686b <vector112>:
.globl vector112
vector112:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $112
8010686d:	6a 70                	push   $0x70
  jmp alltraps
8010686f:	e9 63 f7 ff ff       	jmp    80105fd7 <alltraps>

80106874 <vector113>:
.globl vector113
vector113:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $113
80106876:	6a 71                	push   $0x71
  jmp alltraps
80106878:	e9 5a f7 ff ff       	jmp    80105fd7 <alltraps>

8010687d <vector114>:
.globl vector114
vector114:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $114
8010687f:	6a 72                	push   $0x72
  jmp alltraps
80106881:	e9 51 f7 ff ff       	jmp    80105fd7 <alltraps>

80106886 <vector115>:
.globl vector115
vector115:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $115
80106888:	6a 73                	push   $0x73
  jmp alltraps
8010688a:	e9 48 f7 ff ff       	jmp    80105fd7 <alltraps>

8010688f <vector116>:
.globl vector116
vector116:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $116
80106891:	6a 74                	push   $0x74
  jmp alltraps
80106893:	e9 3f f7 ff ff       	jmp    80105fd7 <alltraps>

80106898 <vector117>:
.globl vector117
vector117:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $117
8010689a:	6a 75                	push   $0x75
  jmp alltraps
8010689c:	e9 36 f7 ff ff       	jmp    80105fd7 <alltraps>

801068a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $118
801068a3:	6a 76                	push   $0x76
  jmp alltraps
801068a5:	e9 2d f7 ff ff       	jmp    80105fd7 <alltraps>

801068aa <vector119>:
.globl vector119
vector119:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $119
801068ac:	6a 77                	push   $0x77
  jmp alltraps
801068ae:	e9 24 f7 ff ff       	jmp    80105fd7 <alltraps>

801068b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $120
801068b5:	6a 78                	push   $0x78
  jmp alltraps
801068b7:	e9 1b f7 ff ff       	jmp    80105fd7 <alltraps>

801068bc <vector121>:
.globl vector121
vector121:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $121
801068be:	6a 79                	push   $0x79
  jmp alltraps
801068c0:	e9 12 f7 ff ff       	jmp    80105fd7 <alltraps>

801068c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $122
801068c7:	6a 7a                	push   $0x7a
  jmp alltraps
801068c9:	e9 09 f7 ff ff       	jmp    80105fd7 <alltraps>

801068ce <vector123>:
.globl vector123
vector123:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $123
801068d0:	6a 7b                	push   $0x7b
  jmp alltraps
801068d2:	e9 00 f7 ff ff       	jmp    80105fd7 <alltraps>

801068d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $124
801068d9:	6a 7c                	push   $0x7c
  jmp alltraps
801068db:	e9 f7 f6 ff ff       	jmp    80105fd7 <alltraps>

801068e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $125
801068e2:	6a 7d                	push   $0x7d
  jmp alltraps
801068e4:	e9 ee f6 ff ff       	jmp    80105fd7 <alltraps>

801068e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $126
801068eb:	6a 7e                	push   $0x7e
  jmp alltraps
801068ed:	e9 e5 f6 ff ff       	jmp    80105fd7 <alltraps>

801068f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $127
801068f4:	6a 7f                	push   $0x7f
  jmp alltraps
801068f6:	e9 dc f6 ff ff       	jmp    80105fd7 <alltraps>

801068fb <vector128>:
.globl vector128
vector128:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $128
801068fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106902:	e9 d0 f6 ff ff       	jmp    80105fd7 <alltraps>

80106907 <vector129>:
.globl vector129
vector129:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $129
80106909:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010690e:	e9 c4 f6 ff ff       	jmp    80105fd7 <alltraps>

80106913 <vector130>:
.globl vector130
vector130:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $130
80106915:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010691a:	e9 b8 f6 ff ff       	jmp    80105fd7 <alltraps>

8010691f <vector131>:
.globl vector131
vector131:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $131
80106921:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106926:	e9 ac f6 ff ff       	jmp    80105fd7 <alltraps>

8010692b <vector132>:
.globl vector132
vector132:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $132
8010692d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106932:	e9 a0 f6 ff ff       	jmp    80105fd7 <alltraps>

80106937 <vector133>:
.globl vector133
vector133:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $133
80106939:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010693e:	e9 94 f6 ff ff       	jmp    80105fd7 <alltraps>

80106943 <vector134>:
.globl vector134
vector134:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $134
80106945:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010694a:	e9 88 f6 ff ff       	jmp    80105fd7 <alltraps>

8010694f <vector135>:
.globl vector135
vector135:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $135
80106951:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106956:	e9 7c f6 ff ff       	jmp    80105fd7 <alltraps>

8010695b <vector136>:
.globl vector136
vector136:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $136
8010695d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106962:	e9 70 f6 ff ff       	jmp    80105fd7 <alltraps>

80106967 <vector137>:
.globl vector137
vector137:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $137
80106969:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010696e:	e9 64 f6 ff ff       	jmp    80105fd7 <alltraps>

80106973 <vector138>:
.globl vector138
vector138:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $138
80106975:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010697a:	e9 58 f6 ff ff       	jmp    80105fd7 <alltraps>

8010697f <vector139>:
.globl vector139
vector139:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $139
80106981:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106986:	e9 4c f6 ff ff       	jmp    80105fd7 <alltraps>

8010698b <vector140>:
.globl vector140
vector140:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $140
8010698d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106992:	e9 40 f6 ff ff       	jmp    80105fd7 <alltraps>

80106997 <vector141>:
.globl vector141
vector141:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $141
80106999:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010699e:	e9 34 f6 ff ff       	jmp    80105fd7 <alltraps>

801069a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $142
801069a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069aa:	e9 28 f6 ff ff       	jmp    80105fd7 <alltraps>

801069af <vector143>:
.globl vector143
vector143:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $143
801069b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069b6:	e9 1c f6 ff ff       	jmp    80105fd7 <alltraps>

801069bb <vector144>:
.globl vector144
vector144:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $144
801069bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069c2:	e9 10 f6 ff ff       	jmp    80105fd7 <alltraps>

801069c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $145
801069c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069ce:	e9 04 f6 ff ff       	jmp    80105fd7 <alltraps>

801069d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $146
801069d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069da:	e9 f8 f5 ff ff       	jmp    80105fd7 <alltraps>

801069df <vector147>:
.globl vector147
vector147:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $147
801069e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069e6:	e9 ec f5 ff ff       	jmp    80105fd7 <alltraps>

801069eb <vector148>:
.globl vector148
vector148:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $148
801069ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069f2:	e9 e0 f5 ff ff       	jmp    80105fd7 <alltraps>

801069f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $149
801069f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069fe:	e9 d4 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a03 <vector150>:
.globl vector150
vector150:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $150
80106a05:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a0a:	e9 c8 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a0f <vector151>:
.globl vector151
vector151:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $151
80106a11:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a16:	e9 bc f5 ff ff       	jmp    80105fd7 <alltraps>

80106a1b <vector152>:
.globl vector152
vector152:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $152
80106a1d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a22:	e9 b0 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a27 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $153
80106a29:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a2e:	e9 a4 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a33 <vector154>:
.globl vector154
vector154:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $154
80106a35:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a3a:	e9 98 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a3f <vector155>:
.globl vector155
vector155:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $155
80106a41:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a46:	e9 8c f5 ff ff       	jmp    80105fd7 <alltraps>

80106a4b <vector156>:
.globl vector156
vector156:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $156
80106a4d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a52:	e9 80 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a57 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $157
80106a59:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a5e:	e9 74 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a63 <vector158>:
.globl vector158
vector158:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $158
80106a65:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a6a:	e9 68 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a6f <vector159>:
.globl vector159
vector159:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $159
80106a71:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a76:	e9 5c f5 ff ff       	jmp    80105fd7 <alltraps>

80106a7b <vector160>:
.globl vector160
vector160:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $160
80106a7d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a82:	e9 50 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a87 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $161
80106a89:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a8e:	e9 44 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a93 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $162
80106a95:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a9a:	e9 38 f5 ff ff       	jmp    80105fd7 <alltraps>

80106a9f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $163
80106aa1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106aa6:	e9 2c f5 ff ff       	jmp    80105fd7 <alltraps>

80106aab <vector164>:
.globl vector164
vector164:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $164
80106aad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ab2:	e9 20 f5 ff ff       	jmp    80105fd7 <alltraps>

80106ab7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $165
80106ab9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106abe:	e9 14 f5 ff ff       	jmp    80105fd7 <alltraps>

80106ac3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $166
80106ac5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106aca:	e9 08 f5 ff ff       	jmp    80105fd7 <alltraps>

80106acf <vector167>:
.globl vector167
vector167:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $167
80106ad1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ad6:	e9 fc f4 ff ff       	jmp    80105fd7 <alltraps>

80106adb <vector168>:
.globl vector168
vector168:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $168
80106add:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ae2:	e9 f0 f4 ff ff       	jmp    80105fd7 <alltraps>

80106ae7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $169
80106ae9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106aee:	e9 e4 f4 ff ff       	jmp    80105fd7 <alltraps>

80106af3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $170
80106af5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106afa:	e9 d8 f4 ff ff       	jmp    80105fd7 <alltraps>

80106aff <vector171>:
.globl vector171
vector171:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $171
80106b01:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b06:	e9 cc f4 ff ff       	jmp    80105fd7 <alltraps>

80106b0b <vector172>:
.globl vector172
vector172:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $172
80106b0d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b12:	e9 c0 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b17 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $173
80106b19:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b1e:	e9 b4 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b23 <vector174>:
.globl vector174
vector174:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $174
80106b25:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b2a:	e9 a8 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b2f <vector175>:
.globl vector175
vector175:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $175
80106b31:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b36:	e9 9c f4 ff ff       	jmp    80105fd7 <alltraps>

80106b3b <vector176>:
.globl vector176
vector176:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $176
80106b3d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b42:	e9 90 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b47 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $177
80106b49:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b4e:	e9 84 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b53 <vector178>:
.globl vector178
vector178:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $178
80106b55:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b5a:	e9 78 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b5f <vector179>:
.globl vector179
vector179:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $179
80106b61:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b66:	e9 6c f4 ff ff       	jmp    80105fd7 <alltraps>

80106b6b <vector180>:
.globl vector180
vector180:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $180
80106b6d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b72:	e9 60 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b77 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $181
80106b79:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b7e:	e9 54 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b83 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $182
80106b85:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b8a:	e9 48 f4 ff ff       	jmp    80105fd7 <alltraps>

80106b8f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $183
80106b91:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b96:	e9 3c f4 ff ff       	jmp    80105fd7 <alltraps>

80106b9b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $184
80106b9d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ba2:	e9 30 f4 ff ff       	jmp    80105fd7 <alltraps>

80106ba7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $185
80106ba9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bae:	e9 24 f4 ff ff       	jmp    80105fd7 <alltraps>

80106bb3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $186
80106bb5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106bba:	e9 18 f4 ff ff       	jmp    80105fd7 <alltraps>

80106bbf <vector187>:
.globl vector187
vector187:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $187
80106bc1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bc6:	e9 0c f4 ff ff       	jmp    80105fd7 <alltraps>

80106bcb <vector188>:
.globl vector188
vector188:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $188
80106bcd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bd2:	e9 00 f4 ff ff       	jmp    80105fd7 <alltraps>

80106bd7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $189
80106bd9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bde:	e9 f4 f3 ff ff       	jmp    80105fd7 <alltraps>

80106be3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $190
80106be5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bea:	e9 e8 f3 ff ff       	jmp    80105fd7 <alltraps>

80106bef <vector191>:
.globl vector191
vector191:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $191
80106bf1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106bf6:	e9 dc f3 ff ff       	jmp    80105fd7 <alltraps>

80106bfb <vector192>:
.globl vector192
vector192:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $192
80106bfd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c02:	e9 d0 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c07 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $193
80106c09:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c0e:	e9 c4 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c13 <vector194>:
.globl vector194
vector194:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $194
80106c15:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c1a:	e9 b8 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c1f <vector195>:
.globl vector195
vector195:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $195
80106c21:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c26:	e9 ac f3 ff ff       	jmp    80105fd7 <alltraps>

80106c2b <vector196>:
.globl vector196
vector196:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $196
80106c2d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c32:	e9 a0 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c37 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $197
80106c39:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c3e:	e9 94 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c43 <vector198>:
.globl vector198
vector198:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $198
80106c45:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c4a:	e9 88 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c4f <vector199>:
.globl vector199
vector199:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $199
80106c51:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c56:	e9 7c f3 ff ff       	jmp    80105fd7 <alltraps>

80106c5b <vector200>:
.globl vector200
vector200:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $200
80106c5d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c62:	e9 70 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c67 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $201
80106c69:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c6e:	e9 64 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c73 <vector202>:
.globl vector202
vector202:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $202
80106c75:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c7a:	e9 58 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c7f <vector203>:
.globl vector203
vector203:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $203
80106c81:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c86:	e9 4c f3 ff ff       	jmp    80105fd7 <alltraps>

80106c8b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $204
80106c8d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c92:	e9 40 f3 ff ff       	jmp    80105fd7 <alltraps>

80106c97 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $205
80106c99:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c9e:	e9 34 f3 ff ff       	jmp    80105fd7 <alltraps>

80106ca3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $206
80106ca5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106caa:	e9 28 f3 ff ff       	jmp    80105fd7 <alltraps>

80106caf <vector207>:
.globl vector207
vector207:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $207
80106cb1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106cb6:	e9 1c f3 ff ff       	jmp    80105fd7 <alltraps>

80106cbb <vector208>:
.globl vector208
vector208:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $208
80106cbd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cc2:	e9 10 f3 ff ff       	jmp    80105fd7 <alltraps>

80106cc7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $209
80106cc9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cce:	e9 04 f3 ff ff       	jmp    80105fd7 <alltraps>

80106cd3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $210
80106cd5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106cda:	e9 f8 f2 ff ff       	jmp    80105fd7 <alltraps>

80106cdf <vector211>:
.globl vector211
vector211:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $211
80106ce1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ce6:	e9 ec f2 ff ff       	jmp    80105fd7 <alltraps>

80106ceb <vector212>:
.globl vector212
vector212:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $212
80106ced:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cf2:	e9 e0 f2 ff ff       	jmp    80105fd7 <alltraps>

80106cf7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $213
80106cf9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cfe:	e9 d4 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d03 <vector214>:
.globl vector214
vector214:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $214
80106d05:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d0a:	e9 c8 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d0f <vector215>:
.globl vector215
vector215:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $215
80106d11:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d16:	e9 bc f2 ff ff       	jmp    80105fd7 <alltraps>

80106d1b <vector216>:
.globl vector216
vector216:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $216
80106d1d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d22:	e9 b0 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d27 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $217
80106d29:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d2e:	e9 a4 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d33 <vector218>:
.globl vector218
vector218:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $218
80106d35:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d3a:	e9 98 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d3f <vector219>:
.globl vector219
vector219:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $219
80106d41:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d46:	e9 8c f2 ff ff       	jmp    80105fd7 <alltraps>

80106d4b <vector220>:
.globl vector220
vector220:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $220
80106d4d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d52:	e9 80 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d57 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $221
80106d59:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d5e:	e9 74 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d63 <vector222>:
.globl vector222
vector222:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $222
80106d65:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d6a:	e9 68 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d6f <vector223>:
.globl vector223
vector223:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $223
80106d71:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d76:	e9 5c f2 ff ff       	jmp    80105fd7 <alltraps>

80106d7b <vector224>:
.globl vector224
vector224:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $224
80106d7d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d82:	e9 50 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d87 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $225
80106d89:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d8e:	e9 44 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d93 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $226
80106d95:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d9a:	e9 38 f2 ff ff       	jmp    80105fd7 <alltraps>

80106d9f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $227
80106da1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106da6:	e9 2c f2 ff ff       	jmp    80105fd7 <alltraps>

80106dab <vector228>:
.globl vector228
vector228:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $228
80106dad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106db2:	e9 20 f2 ff ff       	jmp    80105fd7 <alltraps>

80106db7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $229
80106db9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dbe:	e9 14 f2 ff ff       	jmp    80105fd7 <alltraps>

80106dc3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $230
80106dc5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106dca:	e9 08 f2 ff ff       	jmp    80105fd7 <alltraps>

80106dcf <vector231>:
.globl vector231
vector231:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $231
80106dd1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106dd6:	e9 fc f1 ff ff       	jmp    80105fd7 <alltraps>

80106ddb <vector232>:
.globl vector232
vector232:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $232
80106ddd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106de2:	e9 f0 f1 ff ff       	jmp    80105fd7 <alltraps>

80106de7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $233
80106de9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dee:	e9 e4 f1 ff ff       	jmp    80105fd7 <alltraps>

80106df3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $234
80106df5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106dfa:	e9 d8 f1 ff ff       	jmp    80105fd7 <alltraps>

80106dff <vector235>:
.globl vector235
vector235:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $235
80106e01:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e06:	e9 cc f1 ff ff       	jmp    80105fd7 <alltraps>

80106e0b <vector236>:
.globl vector236
vector236:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $236
80106e0d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e12:	e9 c0 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e17 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $237
80106e19:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e1e:	e9 b4 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e23 <vector238>:
.globl vector238
vector238:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $238
80106e25:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e2a:	e9 a8 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e2f <vector239>:
.globl vector239
vector239:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $239
80106e31:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e36:	e9 9c f1 ff ff       	jmp    80105fd7 <alltraps>

80106e3b <vector240>:
.globl vector240
vector240:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $240
80106e3d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e42:	e9 90 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e47 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $241
80106e49:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e4e:	e9 84 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e53 <vector242>:
.globl vector242
vector242:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $242
80106e55:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e5a:	e9 78 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e5f <vector243>:
.globl vector243
vector243:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $243
80106e61:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e66:	e9 6c f1 ff ff       	jmp    80105fd7 <alltraps>

80106e6b <vector244>:
.globl vector244
vector244:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $244
80106e6d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e72:	e9 60 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e77 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $245
80106e79:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e7e:	e9 54 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e83 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $246
80106e85:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e8a:	e9 48 f1 ff ff       	jmp    80105fd7 <alltraps>

80106e8f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $247
80106e91:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e96:	e9 3c f1 ff ff       	jmp    80105fd7 <alltraps>

80106e9b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $248
80106e9d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ea2:	e9 30 f1 ff ff       	jmp    80105fd7 <alltraps>

80106ea7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $249
80106ea9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eae:	e9 24 f1 ff ff       	jmp    80105fd7 <alltraps>

80106eb3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $250
80106eb5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106eba:	e9 18 f1 ff ff       	jmp    80105fd7 <alltraps>

80106ebf <vector251>:
.globl vector251
vector251:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $251
80106ec1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ec6:	e9 0c f1 ff ff       	jmp    80105fd7 <alltraps>

80106ecb <vector252>:
.globl vector252
vector252:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $252
80106ecd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ed2:	e9 00 f1 ff ff       	jmp    80105fd7 <alltraps>

80106ed7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $253
80106ed9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ede:	e9 f4 f0 ff ff       	jmp    80105fd7 <alltraps>

80106ee3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $254
80106ee5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106eea:	e9 e8 f0 ff ff       	jmp    80105fd7 <alltraps>

80106eef <vector255>:
.globl vector255
vector255:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $255
80106ef1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ef6:	e9 dc f0 ff ff       	jmp    80105fd7 <alltraps>
80106efb:	66 90                	xchg   %ax,%ax
80106efd:	66 90                	xchg   %ax,%ax
80106eff:	90                   	nop

80106f00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f07:	c1 ea 16             	shr    $0x16,%edx
{
80106f0a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106f0b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106f0e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106f11:	8b 1f                	mov    (%edi),%ebx
80106f13:	f6 c3 01             	test   $0x1,%bl
80106f16:	74 28                	je     80106f40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106f1e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f24:	89 f0                	mov    %esi,%eax
}
80106f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106f29:	c1 e8 0a             	shr    $0xa,%eax
80106f2c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f31:	01 d8                	add    %ebx,%eax
}
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5f                   	pop    %edi
80106f36:	5d                   	pop    %ebp
80106f37:	c3                   	ret    
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f40:	85 c9                	test   %ecx,%ecx
80106f42:	74 2c                	je     80106f70 <walkpgdir+0x70>
80106f44:	e8 77 bd ff ff       	call   80102cc0 <kalloc>
80106f49:	89 c3                	mov    %eax,%ebx
80106f4b:	85 c0                	test   %eax,%eax
80106f4d:	74 21                	je     80106f70 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106f4f:	83 ec 04             	sub    $0x4,%esp
80106f52:	68 00 10 00 00       	push   $0x1000
80106f57:	6a 00                	push   $0x0
80106f59:	50                   	push   %eax
80106f5a:	e8 31 de ff ff       	call   80104d90 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f65:	83 c4 10             	add    $0x10,%esp
80106f68:	83 c8 07             	or     $0x7,%eax
80106f6b:	89 07                	mov    %eax,(%edi)
80106f6d:	eb b5                	jmp    80106f24 <walkpgdir+0x24>
80106f6f:	90                   	nop
}
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f86:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f8a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f90:	89 d6                	mov    %edx,%esi
{
80106f92:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f93:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f99:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106fa2:	29 f0                	sub    %esi,%eax
80106fa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa7:	eb 1f                	jmp    80106fc8 <mappages+0x48>
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106fb0:	f6 00 01             	testb  $0x1,(%eax)
80106fb3:	75 45                	jne    80106ffa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fb5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106fb8:	83 cb 01             	or     $0x1,%ebx
80106fbb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106fbd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106fc0:	74 2e                	je     80106ff0 <mappages+0x70>
      break;
    a += PGSIZE;
80106fc2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fcb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fd0:	89 f2                	mov    %esi,%edx
80106fd2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106fd5:	89 f8                	mov    %edi,%eax
80106fd7:	e8 24 ff ff ff       	call   80106f00 <walkpgdir>
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	75 d0                	jne    80106fb0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fe8:	5b                   	pop    %ebx
80106fe9:	5e                   	pop    %esi
80106fea:	5f                   	pop    %edi
80106feb:	5d                   	pop    %ebp
80106fec:	c3                   	ret    
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
      panic("remap");
80106ffa:	83 ec 0c             	sub    $0xc,%esp
80106ffd:	68 f8 80 10 80       	push   $0x801080f8
80107002:	e8 89 93 ff ff       	call   80100390 <panic>
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	89 c6                	mov    %eax,%esi
80107017:	53                   	push   %ebx
80107018:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010701a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107020:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107026:	83 ec 1c             	sub    $0x1c,%esp
80107029:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010702c:	39 da                	cmp    %ebx,%edx
8010702e:	73 5b                	jae    8010708b <deallocuvm.part.0+0x7b>
80107030:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107033:	89 d7                	mov    %edx,%edi
80107035:	eb 14                	jmp    8010704b <deallocuvm.part.0+0x3b>
80107037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703e:	66 90                	xchg   %ax,%ax
80107040:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107046:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107049:	76 40                	jbe    8010708b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010704b:	31 c9                	xor    %ecx,%ecx
8010704d:	89 fa                	mov    %edi,%edx
8010704f:	89 f0                	mov    %esi,%eax
80107051:	e8 aa fe ff ff       	call   80106f00 <walkpgdir>
80107056:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107058:	85 c0                	test   %eax,%eax
8010705a:	74 44                	je     801070a0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010705c:	8b 00                	mov    (%eax),%eax
8010705e:	a8 01                	test   $0x1,%al
80107060:	74 de                	je     80107040 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107062:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107067:	74 47                	je     801070b0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107069:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010706c:	05 00 00 00 80       	add    $0x80000000,%eax
80107071:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107077:	50                   	push   %eax
80107078:	e8 83 ba ff ff       	call   80102b00 <kfree>
      *pte = 0;
8010707d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107083:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107086:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107089:	77 c0                	ja     8010704b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010708b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010708e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107091:	5b                   	pop    %ebx
80107092:	5e                   	pop    %esi
80107093:	5f                   	pop    %edi
80107094:	5d                   	pop    %ebp
80107095:	c3                   	ret    
80107096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070a0:	89 fa                	mov    %edi,%edx
801070a2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801070a8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801070ae:	eb 96                	jmp    80107046 <deallocuvm.part.0+0x36>
        panic("kfree");
801070b0:	83 ec 0c             	sub    $0xc,%esp
801070b3:	68 a6 7a 10 80       	push   $0x80107aa6
801070b8:	e8 d3 92 ff ff       	call   80100390 <panic>
801070bd:	8d 76 00             	lea    0x0(%esi),%esi

801070c0 <seginit>:
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070ca:	e8 01 cf ff ff       	call   80103fd0 <cpuid>
  pd[0] = size-1;
801070cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070de:	c7 80 38 3d 11 80 ff 	movl   $0xffff,-0x7feec2c8(%eax)
801070e5:	ff 00 00 
801070e8:	c7 80 3c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec2c4(%eax)
801070ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070f2:	c7 80 40 3d 11 80 ff 	movl   $0xffff,-0x7feec2c0(%eax)
801070f9:	ff 00 00 
801070fc:	c7 80 44 3d 11 80 00 	movl   $0xcf9200,-0x7feec2bc(%eax)
80107103:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107106:	c7 80 48 3d 11 80 ff 	movl   $0xffff,-0x7feec2b8(%eax)
8010710d:	ff 00 00 
80107110:	c7 80 4c 3d 11 80 00 	movl   $0xcffa00,-0x7feec2b4(%eax)
80107117:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010711a:	c7 80 50 3d 11 80 ff 	movl   $0xffff,-0x7feec2b0(%eax)
80107121:	ff 00 00 
80107124:	c7 80 54 3d 11 80 00 	movl   $0xcff200,-0x7feec2ac(%eax)
8010712b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010712e:	05 30 3d 11 80       	add    $0x80113d30,%eax
  pd[1] = (uint)p;
80107133:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107137:	c1 e8 10             	shr    $0x10,%eax
8010713a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010713e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107141:	0f 01 10             	lgdtl  (%eax)
}
80107144:	c9                   	leave  
80107145:	c3                   	ret    
80107146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714d:	8d 76 00             	lea    0x0(%esi),%esi

80107150 <switchkvm>:
{
80107150:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107154:	a1 e4 69 11 80       	mov    0x801169e4,%eax
80107159:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010715e:	0f 22 d8             	mov    %eax,%cr3
}
80107161:	c3                   	ret    
80107162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107170 <switchuvm>:
{
80107170:	f3 0f 1e fb          	endbr32 
80107174:	55                   	push   %ebp
80107175:	89 e5                	mov    %esp,%ebp
80107177:	57                   	push   %edi
80107178:	56                   	push   %esi
80107179:	53                   	push   %ebx
8010717a:	83 ec 1c             	sub    $0x1c,%esp
8010717d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107180:	85 f6                	test   %esi,%esi
80107182:	0f 84 cb 00 00 00    	je     80107253 <switchuvm+0xe3>
  if(p->kstack == 0)
80107188:	8b 46 08             	mov    0x8(%esi),%eax
8010718b:	85 c0                	test   %eax,%eax
8010718d:	0f 84 da 00 00 00    	je     8010726d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107193:	8b 46 04             	mov    0x4(%esi),%eax
80107196:	85 c0                	test   %eax,%eax
80107198:	0f 84 c2 00 00 00    	je     80107260 <switchuvm+0xf0>
  pushcli();
8010719e:	e8 dd d9 ff ff       	call   80104b80 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071a3:	e8 b8 cd ff ff       	call   80103f60 <mycpu>
801071a8:	89 c3                	mov    %eax,%ebx
801071aa:	e8 b1 cd ff ff       	call   80103f60 <mycpu>
801071af:	89 c7                	mov    %eax,%edi
801071b1:	e8 aa cd ff ff       	call   80103f60 <mycpu>
801071b6:	83 c7 08             	add    $0x8,%edi
801071b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071bc:	e8 9f cd ff ff       	call   80103f60 <mycpu>
801071c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071c4:	ba 67 00 00 00       	mov    $0x67,%edx
801071c9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071d0:	83 c0 08             	add    $0x8,%eax
801071d3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071da:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071df:	83 c1 08             	add    $0x8,%ecx
801071e2:	c1 e8 18             	shr    $0x18,%eax
801071e5:	c1 e9 10             	shr    $0x10,%ecx
801071e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801071ee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801071f4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071f9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107200:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107205:	e8 56 cd ff ff       	call   80103f60 <mycpu>
8010720a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107211:	e8 4a cd ff ff       	call   80103f60 <mycpu>
80107216:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010721a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010721d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107223:	e8 38 cd ff ff       	call   80103f60 <mycpu>
80107228:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010722b:	e8 30 cd ff ff       	call   80103f60 <mycpu>
80107230:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107234:	b8 28 00 00 00       	mov    $0x28,%eax
80107239:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010723c:	8b 46 04             	mov    0x4(%esi),%eax
8010723f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107244:	0f 22 d8             	mov    %eax,%cr3
}
80107247:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724a:	5b                   	pop    %ebx
8010724b:	5e                   	pop    %esi
8010724c:	5f                   	pop    %edi
8010724d:	5d                   	pop    %ebp
  popcli();
8010724e:	e9 7d d9 ff ff       	jmp    80104bd0 <popcli>
    panic("switchuvm: no process");
80107253:	83 ec 0c             	sub    $0xc,%esp
80107256:	68 fe 80 10 80       	push   $0x801080fe
8010725b:	e8 30 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107260:	83 ec 0c             	sub    $0xc,%esp
80107263:	68 29 81 10 80       	push   $0x80108129
80107268:	e8 23 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010726d:	83 ec 0c             	sub    $0xc,%esp
80107270:	68 14 81 10 80       	push   $0x80108114
80107275:	e8 16 91 ff ff       	call   80100390 <panic>
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <inituvm>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	57                   	push   %edi
80107288:	56                   	push   %esi
80107289:	53                   	push   %ebx
8010728a:	83 ec 1c             	sub    $0x1c,%esp
8010728d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107290:	8b 75 10             	mov    0x10(%ebp),%esi
80107293:	8b 7d 08             	mov    0x8(%ebp),%edi
80107296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107299:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010729f:	77 4b                	ja     801072ec <inituvm+0x6c>
  mem = kalloc();
801072a1:	e8 1a ba ff ff       	call   80102cc0 <kalloc>
  memset(mem, 0, PGSIZE);
801072a6:	83 ec 04             	sub    $0x4,%esp
801072a9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801072ae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072b0:	6a 00                	push   $0x0
801072b2:	50                   	push   %eax
801072b3:	e8 d8 da ff ff       	call   80104d90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072b8:	58                   	pop    %eax
801072b9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072bf:	5a                   	pop    %edx
801072c0:	6a 06                	push   $0x6
801072c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072c7:	31 d2                	xor    %edx,%edx
801072c9:	50                   	push   %eax
801072ca:	89 f8                	mov    %edi,%eax
801072cc:	e8 af fc ff ff       	call   80106f80 <mappages>
  memmove(mem, init, sz);
801072d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d4:	89 75 10             	mov    %esi,0x10(%ebp)
801072d7:	83 c4 10             	add    $0x10,%esp
801072da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072dd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e3:	5b                   	pop    %ebx
801072e4:	5e                   	pop    %esi
801072e5:	5f                   	pop    %edi
801072e6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072e7:	e9 44 db ff ff       	jmp    80104e30 <memmove>
    panic("inituvm: more than a page");
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	68 3d 81 10 80       	push   $0x8010813d
801072f4:	e8 97 90 ff ff       	call   80100390 <panic>
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107300 <loaduvm>:
{
80107300:	f3 0f 1e fb          	endbr32 
80107304:	55                   	push   %ebp
80107305:	89 e5                	mov    %esp,%ebp
80107307:	57                   	push   %edi
80107308:	56                   	push   %esi
80107309:	53                   	push   %ebx
8010730a:	83 ec 1c             	sub    $0x1c,%esp
8010730d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107310:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107313:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107318:	0f 85 99 00 00 00    	jne    801073b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010731e:	01 f0                	add    %esi,%eax
80107320:	89 f3                	mov    %esi,%ebx
80107322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107325:	8b 45 14             	mov    0x14(%ebp),%eax
80107328:	01 f0                	add    %esi,%eax
8010732a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010732d:	85 f6                	test   %esi,%esi
8010732f:	75 15                	jne    80107346 <loaduvm+0x46>
80107331:	eb 6d                	jmp    801073a0 <loaduvm+0xa0>
80107333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107337:	90                   	nop
80107338:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010733e:	89 f0                	mov    %esi,%eax
80107340:	29 d8                	sub    %ebx,%eax
80107342:	39 c6                	cmp    %eax,%esi
80107344:	76 5a                	jbe    801073a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107346:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
8010734c:	31 c9                	xor    %ecx,%ecx
8010734e:	29 da                	sub    %ebx,%edx
80107350:	e8 ab fb ff ff       	call   80106f00 <walkpgdir>
80107355:	85 c0                	test   %eax,%eax
80107357:	74 51                	je     801073aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107359:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010735b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010735e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107363:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107368:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010736e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107371:	29 d9                	sub    %ebx,%ecx
80107373:	05 00 00 00 80       	add    $0x80000000,%eax
80107378:	57                   	push   %edi
80107379:	51                   	push   %ecx
8010737a:	50                   	push   %eax
8010737b:	ff 75 10             	pushl  0x10(%ebp)
8010737e:	e8 6d ad ff ff       	call   801020f0 <readi>
80107383:	83 c4 10             	add    $0x10,%esp
80107386:	39 f8                	cmp    %edi,%eax
80107388:	74 ae                	je     80107338 <loaduvm+0x38>
}
8010738a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010738d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107392:	5b                   	pop    %ebx
80107393:	5e                   	pop    %esi
80107394:	5f                   	pop    %edi
80107395:	5d                   	pop    %ebp
80107396:	c3                   	ret    
80107397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739e:	66 90                	xchg   %ax,%ax
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073a3:	31 c0                	xor    %eax,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 57 81 10 80       	push   $0x80108157
801073b2:	e8 d9 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801073b7:	83 ec 0c             	sub    $0xc,%esp
801073ba:	68 f8 81 10 80       	push   $0x801081f8
801073bf:	e8 cc 8f ff ff       	call   80100390 <panic>
801073c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073cf:	90                   	nop

801073d0 <allocuvm>:
{
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	57                   	push   %edi
801073d8:	56                   	push   %esi
801073d9:	53                   	push   %ebx
801073da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801073e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801073e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073e6:	85 c0                	test   %eax,%eax
801073e8:	0f 88 b2 00 00 00    	js     801074a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801073ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801073f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801073f4:	0f 82 96 00 00 00    	jb     80107490 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801073fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107400:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107406:	39 75 10             	cmp    %esi,0x10(%ebp)
80107409:	77 40                	ja     8010744b <allocuvm+0x7b>
8010740b:	e9 83 00 00 00       	jmp    80107493 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107410:	83 ec 04             	sub    $0x4,%esp
80107413:	68 00 10 00 00       	push   $0x1000
80107418:	6a 00                	push   $0x0
8010741a:	50                   	push   %eax
8010741b:	e8 70 d9 ff ff       	call   80104d90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107420:	58                   	pop    %eax
80107421:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107427:	5a                   	pop    %edx
80107428:	6a 06                	push   $0x6
8010742a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010742f:	89 f2                	mov    %esi,%edx
80107431:	50                   	push   %eax
80107432:	89 f8                	mov    %edi,%eax
80107434:	e8 47 fb ff ff       	call   80106f80 <mappages>
80107439:	83 c4 10             	add    $0x10,%esp
8010743c:	85 c0                	test   %eax,%eax
8010743e:	78 78                	js     801074b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107440:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107446:	39 75 10             	cmp    %esi,0x10(%ebp)
80107449:	76 48                	jbe    80107493 <allocuvm+0xc3>
    mem = kalloc();
8010744b:	e8 70 b8 ff ff       	call   80102cc0 <kalloc>
80107450:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107452:	85 c0                	test   %eax,%eax
80107454:	75 ba                	jne    80107410 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	68 75 81 10 80       	push   $0x80108175
8010745e:	e8 3d 93 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107463:	8b 45 0c             	mov    0xc(%ebp),%eax
80107466:	83 c4 10             	add    $0x10,%esp
80107469:	39 45 10             	cmp    %eax,0x10(%ebp)
8010746c:	74 32                	je     801074a0 <allocuvm+0xd0>
8010746e:	8b 55 10             	mov    0x10(%ebp),%edx
80107471:	89 c1                	mov    %eax,%ecx
80107473:	89 f8                	mov    %edi,%eax
80107475:	e8 96 fb ff ff       	call   80107010 <deallocuvm.part.0>
      return 0;
8010747a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107487:	5b                   	pop    %ebx
80107488:	5e                   	pop    %esi
80107489:	5f                   	pop    %edi
8010748a:	5d                   	pop    %ebp
8010748b:	c3                   	ret    
8010748c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107499:	5b                   	pop    %ebx
8010749a:	5e                   	pop    %esi
8010749b:	5f                   	pop    %edi
8010749c:	5d                   	pop    %ebp
8010749d:	c3                   	ret    
8010749e:	66 90                	xchg   %ax,%ax
    return 0;
801074a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    
801074b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074b8:	83 ec 0c             	sub    $0xc,%esp
801074bb:	68 8d 81 10 80       	push   $0x8010818d
801074c0:	e8 db 92 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801074c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074c8:	83 c4 10             	add    $0x10,%esp
801074cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ce:	74 0c                	je     801074dc <allocuvm+0x10c>
801074d0:	8b 55 10             	mov    0x10(%ebp),%edx
801074d3:	89 c1                	mov    %eax,%ecx
801074d5:	89 f8                	mov    %edi,%eax
801074d7:	e8 34 fb ff ff       	call   80107010 <deallocuvm.part.0>
      kfree(mem);
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	53                   	push   %ebx
801074e0:	e8 1b b6 ff ff       	call   80102b00 <kfree>
      return 0;
801074e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801074ec:	83 c4 10             	add    $0x10,%esp
}
801074ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <deallocuvm>:
{
80107500:	f3 0f 1e fb          	endbr32 
80107504:	55                   	push   %ebp
80107505:	89 e5                	mov    %esp,%ebp
80107507:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010750d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107510:	39 d1                	cmp    %edx,%ecx
80107512:	73 0c                	jae    80107520 <deallocuvm+0x20>
}
80107514:	5d                   	pop    %ebp
80107515:	e9 f6 fa ff ff       	jmp    80107010 <deallocuvm.part.0>
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107520:	89 d0                	mov    %edx,%eax
80107522:	5d                   	pop    %ebp
80107523:	c3                   	ret    
80107524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop

80107530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	57                   	push   %edi
80107538:	56                   	push   %esi
80107539:	53                   	push   %ebx
8010753a:	83 ec 0c             	sub    $0xc,%esp
8010753d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107540:	85 f6                	test   %esi,%esi
80107542:	74 55                	je     80107599 <freevm+0x69>
  if(newsz >= oldsz)
80107544:	31 c9                	xor    %ecx,%ecx
80107546:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010754b:	89 f0                	mov    %esi,%eax
8010754d:	89 f3                	mov    %esi,%ebx
8010754f:	e8 bc fa ff ff       	call   80107010 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107554:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010755a:	eb 0b                	jmp    80107567 <freevm+0x37>
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107560:	83 c3 04             	add    $0x4,%ebx
80107563:	39 df                	cmp    %ebx,%edi
80107565:	74 23                	je     8010758a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107567:	8b 03                	mov    (%ebx),%eax
80107569:	a8 01                	test   $0x1,%al
8010756b:	74 f3                	je     80107560 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010756d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107572:	83 ec 0c             	sub    $0xc,%esp
80107575:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107578:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010757d:	50                   	push   %eax
8010757e:	e8 7d b5 ff ff       	call   80102b00 <kfree>
80107583:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107586:	39 df                	cmp    %ebx,%edi
80107588:	75 dd                	jne    80107567 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010758a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010758d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107594:	e9 67 b5 ff ff       	jmp    80102b00 <kfree>
    panic("freevm: no pgdir");
80107599:	83 ec 0c             	sub    $0xc,%esp
8010759c:	68 a9 81 10 80       	push   $0x801081a9
801075a1:	e8 ea 8d ff ff       	call   80100390 <panic>
801075a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ad:	8d 76 00             	lea    0x0(%esi),%esi

801075b0 <setupkvm>:
{
801075b0:	f3 0f 1e fb          	endbr32 
801075b4:	55                   	push   %ebp
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	56                   	push   %esi
801075b8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075b9:	e8 02 b7 ff ff       	call   80102cc0 <kalloc>
801075be:	89 c6                	mov    %eax,%esi
801075c0:	85 c0                	test   %eax,%eax
801075c2:	74 42                	je     80107606 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801075c4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075cc:	68 00 10 00 00       	push   $0x1000
801075d1:	6a 00                	push   $0x0
801075d3:	50                   	push   %eax
801075d4:	e8 b7 d7 ff ff       	call   80104d90 <memset>
801075d9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075df:	83 ec 08             	sub    $0x8,%esp
801075e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075e5:	ff 73 0c             	pushl  0xc(%ebx)
801075e8:	8b 13                	mov    (%ebx),%edx
801075ea:	50                   	push   %eax
801075eb:	29 c1                	sub    %eax,%ecx
801075ed:	89 f0                	mov    %esi,%eax
801075ef:	e8 8c f9 ff ff       	call   80106f80 <mappages>
801075f4:	83 c4 10             	add    $0x10,%esp
801075f7:	85 c0                	test   %eax,%eax
801075f9:	78 15                	js     80107610 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075fb:	83 c3 10             	add    $0x10,%ebx
801075fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107604:	75 d6                	jne    801075dc <setupkvm+0x2c>
}
80107606:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107609:	89 f0                	mov    %esi,%eax
8010760b:	5b                   	pop    %ebx
8010760c:	5e                   	pop    %esi
8010760d:	5d                   	pop    %ebp
8010760e:	c3                   	ret    
8010760f:	90                   	nop
      freevm(pgdir);
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	56                   	push   %esi
      return 0;
80107614:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107616:	e8 15 ff ff ff       	call   80107530 <freevm>
      return 0;
8010761b:	83 c4 10             	add    $0x10,%esp
}
8010761e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107621:	89 f0                	mov    %esi,%eax
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5d                   	pop    %ebp
80107626:	c3                   	ret    
80107627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762e:	66 90                	xchg   %ax,%ax

80107630 <kvmalloc>:
{
80107630:	f3 0f 1e fb          	endbr32 
80107634:	55                   	push   %ebp
80107635:	89 e5                	mov    %esp,%ebp
80107637:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010763a:	e8 71 ff ff ff       	call   801075b0 <setupkvm>
8010763f:	a3 e4 69 11 80       	mov    %eax,0x801169e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107644:	05 00 00 00 80       	add    $0x80000000,%eax
80107649:	0f 22 d8             	mov    %eax,%cr3
}
8010764c:	c9                   	leave  
8010764d:	c3                   	ret    
8010764e:	66 90                	xchg   %ax,%ax

80107650 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107655:	31 c9                	xor    %ecx,%ecx
{
80107657:	89 e5                	mov    %esp,%ebp
80107659:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010765c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010765f:	8b 45 08             	mov    0x8(%ebp),%eax
80107662:	e8 99 f8 ff ff       	call   80106f00 <walkpgdir>
  if(pte == 0)
80107667:	85 c0                	test   %eax,%eax
80107669:	74 05                	je     80107670 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010766b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010766e:	c9                   	leave  
8010766f:	c3                   	ret    
    panic("clearpteu");
80107670:	83 ec 0c             	sub    $0xc,%esp
80107673:	68 ba 81 10 80       	push   $0x801081ba
80107678:	e8 13 8d ff ff       	call   80100390 <panic>
8010767d:	8d 76 00             	lea    0x0(%esi),%esi

80107680 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107680:	f3 0f 1e fb          	endbr32 
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	57                   	push   %edi
80107688:	56                   	push   %esi
80107689:	53                   	push   %ebx
8010768a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010768d:	e8 1e ff ff ff       	call   801075b0 <setupkvm>
80107692:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107695:	85 c0                	test   %eax,%eax
80107697:	0f 84 9b 00 00 00    	je     80107738 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010769d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076a0:	85 c9                	test   %ecx,%ecx
801076a2:	0f 84 90 00 00 00    	je     80107738 <copyuvm+0xb8>
801076a8:	31 f6                	xor    %esi,%esi
801076aa:	eb 46                	jmp    801076f2 <copyuvm+0x72>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076b0:	83 ec 04             	sub    $0x4,%esp
801076b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076b9:	68 00 10 00 00       	push   $0x1000
801076be:	57                   	push   %edi
801076bf:	50                   	push   %eax
801076c0:	e8 6b d7 ff ff       	call   80104e30 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076c5:	58                   	pop    %eax
801076c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076cc:	5a                   	pop    %edx
801076cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801076d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076d5:	89 f2                	mov    %esi,%edx
801076d7:	50                   	push   %eax
801076d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076db:	e8 a0 f8 ff ff       	call   80106f80 <mappages>
801076e0:	83 c4 10             	add    $0x10,%esp
801076e3:	85 c0                	test   %eax,%eax
801076e5:	78 61                	js     80107748 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076f0:	76 46                	jbe    80107738 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076f2:	8b 45 08             	mov    0x8(%ebp),%eax
801076f5:	31 c9                	xor    %ecx,%ecx
801076f7:	89 f2                	mov    %esi,%edx
801076f9:	e8 02 f8 ff ff       	call   80106f00 <walkpgdir>
801076fe:	85 c0                	test   %eax,%eax
80107700:	74 61                	je     80107763 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107702:	8b 00                	mov    (%eax),%eax
80107704:	a8 01                	test   $0x1,%al
80107706:	74 4e                	je     80107756 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107708:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010770a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010770f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107712:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107718:	e8 a3 b5 ff ff       	call   80102cc0 <kalloc>
8010771d:	89 c3                	mov    %eax,%ebx
8010771f:	85 c0                	test   %eax,%eax
80107721:	75 8d                	jne    801076b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107723:	83 ec 0c             	sub    $0xc,%esp
80107726:	ff 75 e0             	pushl  -0x20(%ebp)
80107729:	e8 02 fe ff ff       	call   80107530 <freevm>
  return 0;
8010772e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107735:	83 c4 10             	add    $0x10,%esp
}
80107738:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010773b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773e:	5b                   	pop    %ebx
8010773f:	5e                   	pop    %esi
80107740:	5f                   	pop    %edi
80107741:	5d                   	pop    %ebp
80107742:	c3                   	ret    
80107743:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107747:	90                   	nop
      kfree(mem);
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	53                   	push   %ebx
8010774c:	e8 af b3 ff ff       	call   80102b00 <kfree>
      goto bad;
80107751:	83 c4 10             	add    $0x10,%esp
80107754:	eb cd                	jmp    80107723 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107756:	83 ec 0c             	sub    $0xc,%esp
80107759:	68 de 81 10 80       	push   $0x801081de
8010775e:	e8 2d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107763:	83 ec 0c             	sub    $0xc,%esp
80107766:	68 c4 81 10 80       	push   $0x801081c4
8010776b:	e8 20 8c ff ff       	call   80100390 <panic>

80107770 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107770:	f3 0f 1e fb          	endbr32 
80107774:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107775:	31 c9                	xor    %ecx,%ecx
{
80107777:	89 e5                	mov    %esp,%ebp
80107779:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010777c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010777f:	8b 45 08             	mov    0x8(%ebp),%eax
80107782:	e8 79 f7 ff ff       	call   80106f00 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107787:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107789:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010778a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010778c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107791:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107794:	05 00 00 00 80       	add    $0x80000000,%eax
80107799:	83 fa 05             	cmp    $0x5,%edx
8010779c:	ba 00 00 00 00       	mov    $0x0,%edx
801077a1:	0f 45 c2             	cmovne %edx,%eax
}
801077a4:	c3                   	ret    
801077a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	57                   	push   %edi
801077b8:	56                   	push   %esi
801077b9:	53                   	push   %ebx
801077ba:	83 ec 0c             	sub    $0xc,%esp
801077bd:	8b 75 14             	mov    0x14(%ebp),%esi
801077c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077c3:	85 f6                	test   %esi,%esi
801077c5:	75 3c                	jne    80107803 <copyout+0x53>
801077c7:	eb 67                	jmp    80107830 <copyout+0x80>
801077c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801077d3:	89 fb                	mov    %edi,%ebx
801077d5:	29 d3                	sub    %edx,%ebx
801077d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801077dd:	39 f3                	cmp    %esi,%ebx
801077df:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077e2:	29 fa                	sub    %edi,%edx
801077e4:	83 ec 04             	sub    $0x4,%esp
801077e7:	01 c2                	add    %eax,%edx
801077e9:	53                   	push   %ebx
801077ea:	ff 75 10             	pushl  0x10(%ebp)
801077ed:	52                   	push   %edx
801077ee:	e8 3d d6 ff ff       	call   80104e30 <memmove>
    len -= n;
    buf += n;
801077f3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801077f6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801077fc:	83 c4 10             	add    $0x10,%esp
801077ff:	29 de                	sub    %ebx,%esi
80107801:	74 2d                	je     80107830 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107803:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107805:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107808:	89 55 0c             	mov    %edx,0xc(%ebp)
8010780b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107811:	57                   	push   %edi
80107812:	ff 75 08             	pushl  0x8(%ebp)
80107815:	e8 56 ff ff ff       	call   80107770 <uva2ka>
    if(pa0 == 0)
8010781a:	83 c4 10             	add    $0x10,%esp
8010781d:	85 c0                	test   %eax,%eax
8010781f:	75 af                	jne    801077d0 <copyout+0x20>
  }
  return 0;
}
80107821:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107829:	5b                   	pop    %ebx
8010782a:	5e                   	pop    %esi
8010782b:	5f                   	pop    %edi
8010782c:	5d                   	pop    %ebp
8010782d:	c3                   	ret    
8010782e:	66 90                	xchg   %ax,%ax
80107830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107833:	31 c0                	xor    %eax,%eax
}
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
