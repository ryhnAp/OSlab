
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
8010002d:	b8 20 37 10 80       	mov    $0x80103720,%eax
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
80100050:	68 c0 77 10 80       	push   $0x801077c0
80100055:	68 00 c6 10 80       	push   $0x8010c600
8010005a:	e8 61 4a 00 00       	call   80104ac0 <initlock>
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
80100092:	68 c7 77 10 80       	push   $0x801077c7
80100097:	50                   	push   %eax
80100098:	e8 e3 48 00 00       	call   80104980 <initsleeplock>
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
801000e8:	e8 53 4b 00 00       	call   80104c40 <acquire>
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
80100162:	e8 99 4b 00 00       	call   80104d00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 48 00 00       	call   801049c0 <acquiresleep>
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
8010018c:	e8 cf 27 00 00       	call   80102960 <iderw>
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
801001a3:	68 ce 77 10 80       	push   $0x801077ce
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
801001c2:	e8 99 48 00 00       	call   80104a60 <holdingsleep>
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
801001d8:	e9 83 27 00 00       	jmp    80102960 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 77 10 80       	push   $0x801077df
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
80100203:	e8 58 48 00 00       	call   80104a60 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 48 00 00       	call   80104a20 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010021f:	e8 1c 4a 00 00       	call   80104c40 <acquire>
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
80100270:	e9 8b 4a 00 00       	jmp    80104d00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 77 10 80       	push   $0x801077e6
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
801002a5:	e8 76 1c 00 00       	call   80101f20 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 8a 49 00 00       	call   80104c40 <acquire>
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
801002e5:	e8 16 43 00 00       	call   80104600 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 41 3d 00 00       	call   80104040 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 b5 10 80       	push   $0x8010b540
8010030e:	e8 ed 49 00 00       	call   80104d00 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 24 1b 00 00       	call   80101e40 <ilock>
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
80100365:	e8 96 49 00 00       	call   80104d00 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 cd 1a 00 00       	call   80101e40 <ilock>
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
801003ad:	e8 ce 2b 00 00       	call   80102f80 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 77 10 80       	push   $0x801077ed
801003bb:	e8 e0 03 00 00       	call   801007a0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 d7 03 00 00       	call   801007a0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 17 81 10 80 	movl   $0x80108117,(%esp)
801003d0:	e8 cb 03 00 00       	call   801007a0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 46 00 00       	call   80104ae0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 78 10 80       	push   $0x80107801
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
8010042a:	e8 91 5f 00 00       	call   801063c0 <uartputc>
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
80100595:	e8 26 5e 00 00       	call   801063c0 <uartputc>
8010059a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005a1:	e8 1a 5e 00 00       	call   801063c0 <uartputc>
801005a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005ad:	e8 0e 5e 00 00       	call   801063c0 <uartputc>
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
801005d5:	e8 16 48 00 00       	call   80104df0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005da:	b8 80 07 00 00       	mov    $0x780,%eax
801005df:	83 c4 0c             	add    $0xc,%esp
801005e2:	29 f8                	sub    %edi,%eax
801005e4:	01 c0                	add    %eax,%eax
801005e6:	50                   	push   %eax
801005e7:	8d 84 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%eax
801005ee:	6a 00                	push   $0x0
801005f0:	50                   	push   %eax
801005f1:	e8 5a 47 00 00       	call   80104d50 <memset>
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
80100648:	e8 03 49 00 00       	call   80104f50 <strlen>
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
80100678:	68 05 78 10 80       	push   $0x80107805
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
801006b9:	0f b6 92 30 78 10 80 	movzbl -0x7fef87d0(%edx),%edx
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
80100743:	e8 d8 17 00 00       	call   80101f20 <iunlock>
  acquire(&cons.lock);
80100748:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010074f:	e8 ec 44 00 00       	call   80104c40 <acquire>
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
80100787:	e8 74 45 00 00       	call   80104d00 <release>
  ilock(ip);
8010078c:	58                   	pop    %eax
8010078d:	ff 75 08             	pushl  0x8(%ebp)
80100790:	e8 ab 16 00 00       	call   80101e40 <ilock>

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
8010086d:	bb 18 78 10 80       	mov    $0x80107818,%ebx
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
801008ad:	e8 8e 43 00 00       	call   80104c40 <acquire>
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
80100918:	e8 e3 43 00 00       	call   80104d00 <release>
8010091d:	83 c4 10             	add    $0x10,%esp
}
80100920:	e9 ee fe ff ff       	jmp    80100813 <cprintf+0x73>
    panic("null fmt");
80100925:	83 ec 0c             	sub    $0xc,%esp
80100928:	68 1f 78 10 80       	push   $0x8010781f
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
80100a70:	e8 db 44 00 00       	call   80104f50 <strlen>
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
80100ac3:	e8 28 43 00 00       	call   80104df0 <memmove>
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
80100b0f:	e8 dc 42 00 00       	call   80104df0 <memmove>
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
80100c15:	e8 26 40 00 00       	call   80104c40 <acquire>
  while((c = getc()) >= 0){
80100c1a:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100c1d:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
80100c24:	00 00 00 
  while((c = getc()) >= 0){
80100c27:	ff 55 08             	call   *0x8(%ebp)
80100c2a:	89 c3                	mov    %eax,%ebx
80100c2c:	85 c0                	test   %eax,%eax
80100c2e:	0f 88 f3 02 00 00    	js     80100f27 <consoleintr+0x327>
    switch(c){
80100c34:	83 fb 7f             	cmp    $0x7f,%ebx
80100c37:	0f 84 7c 01 00 00    	je     80100db9 <consoleintr+0x1b9>
80100c3d:	7e 29                	jle    80100c68 <consoleintr+0x68>
80100c3f:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100c45:	0f 84 c3 01 00 00    	je     80100e0e <consoleintr+0x20e>
80100c4b:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100c51:	75 5d                	jne    80100cb0 <consoleintr+0xb0>
  if(panicked){
80100c53:	8b 35 78 b5 10 80    	mov    0x8010b578,%esi
80100c59:	85 f6                	test   %esi,%esi
80100c5b:	0f 84 ce 01 00 00    	je     80100e2f <consoleintr+0x22f>
  asm volatile("cli");
80100c61:	fa                   	cli    
    for(;;)
80100c62:	eb fe                	jmp    80100c62 <consoleintr+0x62>
80100c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100c68:	83 fb 10             	cmp    $0x10,%ebx
80100c6b:	0f 84 7f 01 00 00    	je     80100df0 <consoleintr+0x1f0>
80100c71:	83 fb 15             	cmp    $0x15,%ebx
80100c74:	0f 85 36 01 00 00    	jne    80100db0 <consoleintr+0x1b0>
      while(input.e != input.w &&
80100c7a:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100c7f:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100c85:	74 a0                	je     80100c27 <consoleintr+0x27>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c87:	83 e8 01             	sub    $0x1,%eax
80100c8a:	89 c2                	mov    %eax,%edx
80100c8c:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100c8f:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100c96:	74 8f                	je     80100c27 <consoleintr+0x27>
        input.e--;
80100c98:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
  if(panicked){
80100c9d:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100ca2:	85 c0                	test   %eax,%eax
80100ca4:	0f 84 55 01 00 00    	je     80100dff <consoleintr+0x1ff>
80100caa:	fa                   	cli    
    for(;;)
80100cab:	eb fe                	jmp    80100cab <consoleintr+0xab>
80100cad:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100cb0:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100cb6:	0f 85 ac 01 00 00    	jne    80100e68 <consoleintr+0x268>
      if (cmd_idx != NO_CMD)
80100cbc:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
80100cc2:	83 ff ff             	cmp    $0xffffffff,%edi
80100cc5:	0f 84 5c ff ff ff    	je     80100c27 <consoleintr+0x27>
        for (int i = input.pos; i < input.e; i++)
80100ccb:	8b 35 ec 0f 11 80    	mov    0x80110fec,%esi
80100cd1:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
80100cd7:	39 ce                	cmp    %ecx,%esi
80100cd9:	73 69                	jae    80100d44 <consoleintr+0x144>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cdb:	89 bd 64 ff ff ff    	mov    %edi,-0x9c(%ebp)
80100ce1:	89 cf                	mov    %ecx,%edi
80100ce3:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ce8:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100ced:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cee:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100cf3:	89 da                	mov    %ebx,%edx
80100cf5:	ec                   	in     (%dx),%al
80100cf6:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cf9:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100cfe:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT+1) << 8;
80100d03:	c1 e1 08             	shl    $0x8,%ecx
80100d06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d07:	89 da                	mov    %ebx,%edx
80100d09:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100d0a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d0d:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d12:	09 c1                	or     %eax,%ecx
80100d14:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos++;
80100d19:	83 c1 01             	add    $0x1,%ecx
80100d1c:	ee                   	out    %al,(%dx)
80100d1d:	89 c8                	mov    %ecx,%eax
80100d1f:	89 da                	mov    %ebx,%edx
80100d21:	ee                   	out    %al,(%dx)
80100d22:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d27:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d2c:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100d2d:	89 c8                	mov    %ecx,%eax
80100d2f:	89 da                	mov    %ebx,%edx
80100d31:	c1 f8 08             	sar    $0x8,%eax
80100d34:	ee                   	out    %al,(%dx)
        for (int i = input.pos; i < input.e; i++)
80100d35:	83 c6 01             	add    $0x1,%esi
80100d38:	39 f7                	cmp    %esi,%edi
80100d3a:	75 a7                	jne    80100ce3 <consoleintr+0xe3>
80100d3c:	89 f9                	mov    %edi,%ecx
80100d3e:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
        while(input.e != input.w &&
80100d44:	39 0d e4 0f 11 80    	cmp    %ecx,0x80110fe4
80100d4a:	75 1c                	jne    80100d68 <consoleintr+0x168>
80100d4c:	eb 31                	jmp    80100d7f <consoleintr+0x17f>
80100d4e:	66 90                	xchg   %ax,%ax
          input.e--;
80100d50:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
          leftside_moving_cursor();
80100d55:	e8 d6 fd ff ff       	call   80100b30 <leftside_moving_cursor>
        while(input.e != input.w &&
80100d5a:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
80100d60:	3b 0d e4 0f 11 80    	cmp    0x80110fe4,%ecx
80100d66:	74 11                	je     80100d79 <consoleintr+0x179>
          input.buf[(input.e-1) % INPUT_BUF] != '\n')
80100d68:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100d6b:	89 c2                	mov    %eax,%edx
80100d6d:	83 e2 7f             	and    $0x7f,%edx
        while(input.e != input.w &&
80100d70:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100d77:	75 d7                	jne    80100d50 <consoleintr+0x150>
80100d79:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
{
80100d7f:	31 db                	xor    %ebx,%ebx
          temp_id = cmd_mem[cmd_idx][i];
80100d81:	89 f8                	mov    %edi,%eax
80100d83:	c1 e0 07             	shl    $0x7,%eax
80100d86:	0f b6 b4 03 00 10 11 	movzbl -0x7feef000(%ebx,%eax,1),%esi
80100d8d:	80 
          if (temp_id == '\0')
80100d8e:	89 f0                	mov    %esi,%eax
80100d90:	84 c0                	test   %al,%al
80100d92:	0f 84 ce 02 00 00    	je     80101066 <consoleintr+0x466>
  if(panicked){
80100d98:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
80100d9e:	85 ff                	test   %edi,%edi
80100da0:	0f 84 a7 01 00 00    	je     80100f4d <consoleintr+0x34d>
  asm volatile("cli");
80100da6:	fa                   	cli    
    for(;;)
80100da7:	eb fe                	jmp    80100da7 <consoleintr+0x1a7>
80100da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100db0:	83 fb 08             	cmp    $0x8,%ebx
80100db3:	0f 85 85 00 00 00    	jne    80100e3e <consoleintr+0x23e>
      if(input.e != input.w){
80100db9:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100dbe:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100dc4:	0f 84 5d fe ff ff    	je     80100c27 <consoleintr+0x27>
        input.e--;
80100dca:	83 e8 01             	sub    $0x1,%eax
        empty_cell++;
80100dcd:	83 05 7c b5 10 80 01 	addl   $0x1,0x8010b57c
        input.e--;
80100dd4:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
  if(panicked){
80100dd9:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	0f 84 32 01 00 00    	je     80100f18 <consoleintr+0x318>
80100de6:	fa                   	cli    
    for(;;)
80100de7:	eb fe                	jmp    80100de7 <consoleintr+0x1e7>
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100df0:	c7 85 60 ff ff ff 01 	movl   $0x1,-0xa0(%ebp)
80100df7:	00 00 00 
80100dfa:	e9 28 fe ff ff       	jmp    80100c27 <consoleintr+0x27>
80100dff:	b8 00 01 00 00       	mov    $0x100,%eax
80100e04:	e8 07 f6 ff ff       	call   80100410 <consputc.part.0>
80100e09:	e9 6c fe ff ff       	jmp    80100c7a <consoleintr+0x7a>
  if(panicked){
80100e0e:	8b 1d 78 b5 10 80    	mov    0x8010b578,%ebx
80100e14:	85 db                	test   %ebx,%ebx
80100e16:	74 08                	je     80100e20 <consoleintr+0x220>
80100e18:	fa                   	cli    
    for(;;)
80100e19:	eb fe                	jmp    80100e19 <consoleintr+0x219>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
80100e20:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100e25:	e8 e6 f5 ff ff       	call   80100410 <consputc.part.0>
80100e2a:	e9 f8 fd ff ff       	jmp    80100c27 <consoleintr+0x27>
80100e2f:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100e34:	e8 d7 f5 ff ff       	call   80100410 <consputc.part.0>
80100e39:	e9 e9 fd ff ff       	jmp    80100c27 <consoleintr+0x27>
      uartputc('-');
80100e3e:	83 ec 0c             	sub    $0xc,%esp
80100e41:	6a 2d                	push   $0x2d
80100e43:	e8 78 55 00 00       	call   801063c0 <uartputc>
      uartputc('c');
80100e48:	c7 04 24 63 00 00 00 	movl   $0x63,(%esp)
80100e4f:	e8 6c 55 00 00       	call   801063c0 <uartputc>
      if(c != 0 && input.e-input.r < INPUT_BUF)
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	85 db                	test   %ebx,%ebx
80100e59:	0f 84 c8 fd ff ff    	je     80100c27 <consoleintr+0x27>
80100e5f:	eb 20                	jmp    80100e81 <consoleintr+0x281>
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      uartputc('-');
80100e68:	83 ec 0c             	sub    $0xc,%esp
80100e6b:	6a 2d                	push   $0x2d
80100e6d:	e8 4e 55 00 00       	call   801063c0 <uartputc>
      uartputc('c');
80100e72:	c7 04 24 63 00 00 00 	movl   $0x63,(%esp)
80100e79:	e8 42 55 00 00       	call   801063c0 <uartputc>
80100e7e:	83 c4 10             	add    $0x10,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF)
80100e81:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100e86:	8b 15 e0 0f 11 80    	mov    0x80110fe0,%edx
80100e8c:	89 c1                	mov    %eax,%ecx
80100e8e:	29 d1                	sub    %edx,%ecx
80100e90:	83 f9 7f             	cmp    $0x7f,%ecx
80100e93:	0f 87 8e fd ff ff    	ja     80100c27 <consoleintr+0x27>
        c = (c == '\r') ? '\n' : c;
80100e99:	8d 78 01             	lea    0x1(%eax),%edi
80100e9c:	83 fb 0d             	cmp    $0xd,%ebx
80100e9f:	0f 84 e5 00 00 00    	je     80100f8a <consoleintr+0x38a>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF)
80100ea5:	88 9d 64 ff ff ff    	mov    %bl,-0x9c(%ebp)
80100eab:	83 fb 0a             	cmp    $0xa,%ebx
80100eae:	0f 84 e2 00 00 00    	je     80100f96 <consoleintr+0x396>
80100eb4:	83 fb 04             	cmp    $0x4,%ebx
80100eb7:	0f 84 d9 00 00 00    	je     80100f96 <consoleintr+0x396>
80100ebd:	83 ea 80             	sub    $0xffffff80,%edx
80100ec0:	39 d0                	cmp    %edx,%eax
80100ec2:	0f 84 ce 00 00 00    	je     80100f96 <consoleintr+0x396>
          if (width == 0)
80100ec8:	8b 35 ec 0f 11 80    	mov    0x80110fec,%esi
80100ece:	8b 0d 80 b5 10 80    	mov    0x8010b580,%ecx
80100ed4:	8d 56 01             	lea    0x1(%esi),%edx
80100ed7:	89 8d 5c ff ff ff    	mov    %ecx,-0xa4(%ebp)
80100edd:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
80100ee3:	85 c9                	test   %ecx,%ecx
80100ee5:	0f 85 95 01 00 00    	jne    80101080 <consoleintr+0x480>
            input.pos++;
80100eeb:	89 15 ec 0f 11 80    	mov    %edx,0x80110fec
  if(panicked){
80100ef1:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
            input.buf[input.e++ % INPUT_BUF] = c;
80100ef7:	83 e0 7f             	and    $0x7f,%eax
80100efa:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100f00:	88 98 60 0f 11 80    	mov    %bl,-0x7feef0a0(%eax)
  if(panicked){
80100f06:	85 d2                	test   %edx,%edx
80100f08:	0f 84 66 01 00 00    	je     80101074 <consoleintr+0x474>
80100f0e:	fa                   	cli    
    for(;;)
80100f0f:	eb fe                	jmp    80100f0f <consoleintr+0x30f>
80100f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f18:	b8 00 01 00 00       	mov    $0x100,%eax
80100f1d:	e8 ee f4 ff ff       	call   80100410 <consputc.part.0>
80100f22:	e9 00 fd ff ff       	jmp    80100c27 <consoleintr+0x27>
  release(&cons.lock);
80100f27:	83 ec 0c             	sub    $0xc,%esp
80100f2a:	68 40 b5 10 80       	push   $0x8010b540
80100f2f:	e8 cc 3d 00 00       	call   80104d00 <release>
  if(doprocdump) {
80100f34:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80100f3a:	83 c4 10             	add    $0x10,%esp
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	0f 85 25 01 00 00    	jne    8010106a <consoleintr+0x46a>
}
80100f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f48:	5b                   	pop    %ebx
80100f49:	5e                   	pop    %esi
80100f4a:	5f                   	pop    %edi
80100f4b:	5d                   	pop    %ebp
80100f4c:	c3                   	ret    
          consputc(temp_id);
80100f4d:	0f be c0             	movsbl %al,%eax
        for (int i = 0; i < INPUT_BUF; i++)
80100f50:	83 c3 01             	add    $0x1,%ebx
80100f53:	e8 b8 f4 ff ff       	call   80100410 <consputc.part.0>
          input.buf[input.e++] = temp_id;
80100f58:	8b 0d e8 0f 11 80    	mov    0x80110fe8,%ecx
80100f5e:	89 f0                	mov    %esi,%eax
80100f60:	89 ca                	mov    %ecx,%edx
80100f62:	8d 79 01             	lea    0x1(%ecx),%edi
80100f65:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100f6b:	89 f9                	mov    %edi,%ecx
80100f6d:	88 82 60 0f 11 80    	mov    %al,-0x7feef0a0(%edx)
        for (int i = 0; i < INPUT_BUF; i++)
80100f73:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80100f79:	0f 84 cd 00 00 00    	je     8010104c <consoleintr+0x44c>
80100f7f:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
80100f85:	e9 f7 fd ff ff       	jmp    80100d81 <consoleintr+0x181>
80100f8a:	c6 85 64 ff ff ff 0a 	movb   $0xa,-0x9c(%ebp)
        c = (c == '\r') ? '\n' : c;
80100f91:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100f96:	0f b6 95 64 ff ff ff 	movzbl -0x9c(%ebp),%edx
  if(panicked){
80100f9d:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80100fa3:	83 e0 7f             	and    $0x7f,%eax
80100fa6:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
80100fac:	88 90 60 0f 11 80    	mov    %dl,-0x7feef0a0(%eax)
  if(panicked){
80100fb2:	85 c9                	test   %ecx,%ecx
80100fb4:	74 0a                	je     80100fc0 <consoleintr+0x3c0>
80100fb6:	fa                   	cli    
    for(;;)
80100fb7:	eb fe                	jmp    80100fb7 <consoleintr+0x3b7>
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fc0:	89 d8                	mov    %ebx,%eax
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100fc2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80100fc8:	e8 43 f4 ff ff       	call   80100410 <consputc.part.0>
          for (int i = 0; i+input.w < input.e -1; i++)
80100fcd:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100fd2:	8b 0d e4 0f 11 80    	mov    0x80110fe4,%ecx
          width =0;
80100fd8:	c7 05 80 b5 10 80 00 	movl   $0x0,0x8010b580
80100fdf:	00 00 00 
          for (int i = 0; i+input.w < input.e -1; i++)
80100fe2:	83 e8 01             	sub    $0x1,%eax
80100fe5:	89 ca                	mov    %ecx,%edx
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100fe7:	29 ce                	sub    %ecx,%esi
          for (int i = 0; i+input.w < input.e -1; i++)
80100fe9:	39 c1                	cmp    %eax,%ecx
80100feb:	73 16                	jae    80101003 <consoleintr+0x403>
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
80100fed:	89 d3                	mov    %edx,%ebx
80100fef:	83 e3 7f             	and    $0x7f,%ebx
80100ff2:	0f b6 9b 60 0f 11 80 	movzbl -0x7feef0a0(%ebx),%ebx
80100ff9:	88 1c 16             	mov    %bl,(%esi,%edx,1)
          for (int i = 0; i+input.w < input.e -1; i++)
80100ffc:	83 c2 01             	add    $0x1,%edx
80100fff:	39 c2                	cmp    %eax,%edx
80101001:	75 ea                	jne    80100fed <consoleintr+0x3ed>
          cmd_[(input.e -1 -input.w)%INPUT_BUF] = '\0';
80101003:	29 c8                	sub    %ecx,%eax
          save_command(cmd_);
80101005:	83 ec 0c             	sub    $0xc,%esp
          cmd_[(input.e -1 -input.w)%INPUT_BUF] = '\0';
80101008:	83 e0 7f             	and    $0x7f,%eax
8010100b:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80101012:	00 
          save_command(cmd_);
80101013:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80101019:	50                   	push   %eax
8010101a:	e8 41 fa ff ff       	call   80100a60 <save_command>
          cmd_idx = cmd_mem_size;
8010101f:	a1 20 b5 10 80       	mov    0x8010b520,%eax
          wakeup(&input.r);
80101024:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
          cmd_idx = cmd_mem_size;
8010102b:	a3 00 90 10 80       	mov    %eax,0x80109000
          input.pos = input.e;
80101030:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80101035:	a3 ec 0f 11 80       	mov    %eax,0x80110fec
          input.w = input.e;
8010103a:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
8010103f:	e8 7c 37 00 00       	call   801047c0 <wakeup>
        {
80101044:	83 c4 10             	add    $0x10,%esp
80101047:	e9 db fb ff ff       	jmp    80100c27 <consoleintr+0x27>
8010104c:	89 f8                	mov    %edi,%eax
8010104e:	8b 3d 00 90 10 80    	mov    0x80109000,%edi
        input.pos = input.e;
80101054:	a3 ec 0f 11 80       	mov    %eax,0x80110fec
        cmd_idx--;
80101059:	8d 47 ff             	lea    -0x1(%edi),%eax
8010105c:	a3 00 90 10 80       	mov    %eax,0x80109000
80101061:	e9 c1 fb ff ff       	jmp    80100c27 <consoleintr+0x27>
80101066:	89 c8                	mov    %ecx,%eax
80101068:	eb ea                	jmp    80101054 <consoleintr+0x454>
    procdump();  // now call procdump() wo. cons.lock held
8010106a:	e8 41 38 00 00       	call   801048b0 <procdump>
}
8010106f:	e9 d1 fe ff ff       	jmp    80100f45 <consoleintr+0x345>
80101074:	89 d8                	mov    %ebx,%eax
80101076:	e8 95 f3 ff ff       	call   80100410 <consputc.part.0>
8010107b:	e9 a7 fb ff ff       	jmp    80100c27 <consoleintr+0x27>
            for (int i = input.e; i > input.pos-1; i++)
80101080:	8d 4e ff             	lea    -0x1(%esi),%ecx
80101083:	89 8d 58 ff ff ff    	mov    %ecx,-0xa8(%ebp)
80101089:	39 c8                	cmp    %ecx,%eax
8010108b:	76 45                	jbe    801010d2 <consoleintr+0x4d2>
8010108d:	89 c1                	mov    %eax,%ecx
8010108f:	c1 f9 1f             	sar    $0x1f,%ecx
80101092:	c1 e9 19             	shr    $0x19,%ecx
80101095:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80101098:	83 e2 7f             	and    $0x7f,%edx
8010109b:	29 ca                	sub    %ecx,%edx
8010109d:	0f b6 92 60 0f 11 80 	movzbl -0x7feef0a0(%edx),%edx
801010a4:	88 95 57 ff ff ff    	mov    %dl,-0xa9(%ebp)
              input.buf[(i+1)%INPUT_BUF] = input.buf[(i)%INPUT_BUF];
801010aa:	83 c0 01             	add    $0x1,%eax
801010ad:	89 c1                	mov    %eax,%ecx
801010af:	c1 f9 1f             	sar    $0x1f,%ecx
801010b2:	c1 e9 19             	shr    $0x19,%ecx
801010b5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
801010b8:	83 e2 7f             	and    $0x7f,%edx
801010bb:	29 ca                	sub    %ecx,%edx
801010bd:	0f b6 8d 57 ff ff ff 	movzbl -0xa9(%ebp),%ecx
801010c4:	88 8a 60 0f 11 80    	mov    %cl,-0x7feef0a0(%edx)
            for (int i = input.e; i > input.pos-1; i++)
801010ca:	39 85 58 ff ff ff    	cmp    %eax,-0xa8(%ebp)
801010d0:	72 d8                	jb     801010aa <consoleintr+0x4aa>
            cursor_gathering_char(c,width);
801010d2:	83 ec 08             	sub    $0x8,%esp
            input.buf[input.pos%INPUT_BUF] = c;
801010d5:	0f b6 95 64 ff ff ff 	movzbl -0x9c(%ebp),%edx
801010dc:	89 f0                	mov    %esi,%eax
            cursor_gathering_char(c,width);
801010de:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
            input.buf[input.pos%INPUT_BUF] = c;
801010e4:	83 e0 7f             	and    $0x7f,%eax
            cursor_gathering_char(c,width);
801010e7:	53                   	push   %ebx
            input.buf[input.pos%INPUT_BUF] = c;
801010e8:	88 90 60 0f 11 80    	mov    %dl,-0x7feef0a0(%eax)
            input.pos++;
801010ee:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
            input.e++;
801010f4:	89 3d e8 0f 11 80    	mov    %edi,0x80110fe8
            input.pos++;
801010fa:	a3 ec 0f 11 80       	mov    %eax,0x80110fec
            cursor_gathering_char(c,width);
801010ff:	e8 9c f8 ff ff       	call   801009a0 <cursor_gathering_char>
80101104:	83 c4 10             	add    $0x10,%esp
80101107:	e9 1b fb ff ff       	jmp    80100c27 <consoleintr+0x27>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101110 <consoleinit>:

void
consoleinit(void)
{
80101110:	f3 0f 1e fb          	endbr32 
80101114:	55                   	push   %ebp
80101115:	89 e5                	mov    %esp,%ebp
80101117:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
8010111a:	68 28 78 10 80       	push   $0x80107828
8010111f:	68 40 b5 10 80       	push   $0x8010b540
80101124:	e8 97 39 00 00       	call   80104ac0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101129:	58                   	pop    %eax
8010112a:	5a                   	pop    %edx
8010112b:	6a 00                	push   $0x0
8010112d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010112f:	c7 05 ac 1e 11 80 30 	movl   $0x80100730,0x80111eac
80101136:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80101139:	c7 05 a8 1e 11 80 90 	movl   $0x80100290,0x80111ea8
80101140:	02 10 80 
  cons.locking = 1;
80101143:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
8010114a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
8010114d:	e8 be 19 00 00       	call   80102b10 <ioapicenable>
}
80101152:	83 c4 10             	add    $0x10,%esp
80101155:	c9                   	leave  
80101156:	c3                   	ret    
80101157:	66 90                	xchg   %ax,%ax
80101159:	66 90                	xchg   %ax,%ax
8010115b:	66 90                	xchg   %ax,%ax
8010115d:	66 90                	xchg   %ax,%ax
8010115f:	90                   	nop

80101160 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101160:	f3 0f 1e fb          	endbr32 
80101164:	55                   	push   %ebp
80101165:	89 e5                	mov    %esp,%ebp
80101167:	57                   	push   %edi
80101168:	56                   	push   %esi
80101169:	53                   	push   %ebx
8010116a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101170:	e8 cb 2e 00 00       	call   80104040 <myproc>
80101175:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010117b:	e8 90 22 00 00       	call   80103410 <begin_op>

  if((ip = namei(path)) == 0){
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	ff 75 08             	pushl  0x8(%ebp)
80101186:	e8 85 15 00 00       	call   80102710 <namei>
8010118b:	83 c4 10             	add    $0x10,%esp
8010118e:	85 c0                	test   %eax,%eax
80101190:	0f 84 fe 02 00 00    	je     80101494 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	89 c3                	mov    %eax,%ebx
8010119b:	50                   	push   %eax
8010119c:	e8 9f 0c 00 00       	call   80101e40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801011a1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801011a7:	6a 34                	push   $0x34
801011a9:	6a 00                	push   $0x0
801011ab:	50                   	push   %eax
801011ac:	53                   	push   %ebx
801011ad:	e8 8e 0f 00 00       	call   80102140 <readi>
801011b2:	83 c4 20             	add    $0x20,%esp
801011b5:	83 f8 34             	cmp    $0x34,%eax
801011b8:	74 26                	je     801011e0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801011ba:	83 ec 0c             	sub    $0xc,%esp
801011bd:	53                   	push   %ebx
801011be:	e8 1d 0f 00 00       	call   801020e0 <iunlockput>
    end_op();
801011c3:	e8 b8 22 00 00       	call   80103480 <end_op>
801011c8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801011cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d3:	5b                   	pop    %ebx
801011d4:	5e                   	pop    %esi
801011d5:	5f                   	pop    %edi
801011d6:	5d                   	pop    %ebp
801011d7:	c3                   	ret    
801011d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011df:	90                   	nop
  if(elf.magic != ELF_MAGIC)
801011e0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801011e7:	45 4c 46 
801011ea:	75 ce                	jne    801011ba <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
801011ec:	e8 3f 63 00 00       	call   80107530 <setupkvm>
801011f1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801011f7:	85 c0                	test   %eax,%eax
801011f9:	74 bf                	je     801011ba <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011fb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101202:	00 
80101203:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101209:	0f 84 a4 02 00 00    	je     801014b3 <exec+0x353>
  sz = 0;
8010120f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101216:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101219:	31 ff                	xor    %edi,%edi
8010121b:	e9 86 00 00 00       	jmp    801012a6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101220:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101227:	75 6c                	jne    80101295 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101229:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010122f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101235:	0f 82 87 00 00 00    	jb     801012c2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010123b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101241:	72 7f                	jb     801012c2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101243:	83 ec 04             	sub    $0x4,%esp
80101246:	50                   	push   %eax
80101247:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010124d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101253:	e8 f8 60 00 00       	call   80107350 <allocuvm>
80101258:	83 c4 10             	add    $0x10,%esp
8010125b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101261:	85 c0                	test   %eax,%eax
80101263:	74 5d                	je     801012c2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101265:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010126b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101270:	75 50                	jne    801012c2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010127b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101281:	53                   	push   %ebx
80101282:	50                   	push   %eax
80101283:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101289:	e8 f2 5f 00 00       	call   80107280 <loaduvm>
8010128e:	83 c4 20             	add    $0x20,%esp
80101291:	85 c0                	test   %eax,%eax
80101293:	78 2d                	js     801012c2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101295:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010129c:	83 c7 01             	add    $0x1,%edi
8010129f:	83 c6 20             	add    $0x20,%esi
801012a2:	39 f8                	cmp    %edi,%eax
801012a4:	7e 3a                	jle    801012e0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801012a6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801012ac:	6a 20                	push   $0x20
801012ae:	56                   	push   %esi
801012af:	50                   	push   %eax
801012b0:	53                   	push   %ebx
801012b1:	e8 8a 0e 00 00       	call   80102140 <readi>
801012b6:	83 c4 10             	add    $0x10,%esp
801012b9:	83 f8 20             	cmp    $0x20,%eax
801012bc:	0f 84 5e ff ff ff    	je     80101220 <exec+0xc0>
    freevm(pgdir);
801012c2:	83 ec 0c             	sub    $0xc,%esp
801012c5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801012cb:	e8 e0 61 00 00       	call   801074b0 <freevm>
  if(ip){
801012d0:	83 c4 10             	add    $0x10,%esp
801012d3:	e9 e2 fe ff ff       	jmp    801011ba <exec+0x5a>
801012d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012df:	90                   	nop
801012e0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801012e6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801012ec:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801012f2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801012f8:	83 ec 0c             	sub    $0xc,%esp
801012fb:	53                   	push   %ebx
801012fc:	e8 df 0d 00 00       	call   801020e0 <iunlockput>
  end_op();
80101301:	e8 7a 21 00 00       	call   80103480 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101306:	83 c4 0c             	add    $0xc,%esp
80101309:	56                   	push   %esi
8010130a:	57                   	push   %edi
8010130b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101311:	57                   	push   %edi
80101312:	e8 39 60 00 00       	call   80107350 <allocuvm>
80101317:	83 c4 10             	add    $0x10,%esp
8010131a:	89 c6                	mov    %eax,%esi
8010131c:	85 c0                	test   %eax,%eax
8010131e:	0f 84 94 00 00 00    	je     801013b8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010132d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010132f:	50                   	push   %eax
80101330:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101331:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101333:	e8 98 62 00 00       	call   801075d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101338:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133b:	83 c4 10             	add    $0x10,%esp
8010133e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101344:	8b 00                	mov    (%eax),%eax
80101346:	85 c0                	test   %eax,%eax
80101348:	0f 84 8b 00 00 00    	je     801013d9 <exec+0x279>
8010134e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101354:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010135a:	eb 23                	jmp    8010137f <exec+0x21f>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101360:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101363:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010136a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010136d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101373:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 59                	je     801013d3 <exec+0x273>
    if(argc >= MAXARG)
8010137a:	83 ff 20             	cmp    $0x20,%edi
8010137d:	74 39                	je     801013b8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	50                   	push   %eax
80101383:	e8 c8 3b 00 00       	call   80104f50 <strlen>
80101388:	f7 d0                	not    %eax
8010138a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010138c:	58                   	pop    %eax
8010138d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101390:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101393:	ff 34 b8             	pushl  (%eax,%edi,4)
80101396:	e8 b5 3b 00 00       	call   80104f50 <strlen>
8010139b:	83 c0 01             	add    $0x1,%eax
8010139e:	50                   	push   %eax
8010139f:	8b 45 0c             	mov    0xc(%ebp),%eax
801013a2:	ff 34 b8             	pushl  (%eax,%edi,4)
801013a5:	53                   	push   %ebx
801013a6:	56                   	push   %esi
801013a7:	e8 84 63 00 00       	call   80107730 <copyout>
801013ac:	83 c4 20             	add    $0x20,%esp
801013af:	85 c0                	test   %eax,%eax
801013b1:	79 ad                	jns    80101360 <exec+0x200>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
    freevm(pgdir);
801013b8:	83 ec 0c             	sub    $0xc,%esp
801013bb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801013c1:	e8 ea 60 00 00       	call   801074b0 <freevm>
801013c6:	83 c4 10             	add    $0x10,%esp
  return -1;
801013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ce:	e9 fd fd ff ff       	jmp    801011d0 <exec+0x70>
801013d3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801013d9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801013e0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801013e2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801013e9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801013ed:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801013ef:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801013f2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801013f8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801013fa:	50                   	push   %eax
801013fb:	52                   	push   %edx
801013fc:	53                   	push   %ebx
801013fd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101403:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010140a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010140d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101413:	e8 18 63 00 00       	call   80107730 <copyout>
80101418:	83 c4 10             	add    $0x10,%esp
8010141b:	85 c0                	test   %eax,%eax
8010141d:	78 99                	js     801013b8 <exec+0x258>
  for(last=s=path; *s; s++)
8010141f:	8b 45 08             	mov    0x8(%ebp),%eax
80101422:	8b 55 08             	mov    0x8(%ebp),%edx
80101425:	0f b6 00             	movzbl (%eax),%eax
80101428:	84 c0                	test   %al,%al
8010142a:	74 13                	je     8010143f <exec+0x2df>
8010142c:	89 d1                	mov    %edx,%ecx
8010142e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101430:	83 c1 01             	add    $0x1,%ecx
80101433:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101435:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101438:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010143b:	84 c0                	test   %al,%al
8010143d:	75 f1                	jne    80101430 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010143f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101445:	83 ec 04             	sub    $0x4,%esp
80101448:	6a 10                	push   $0x10
8010144a:	89 f8                	mov    %edi,%eax
8010144c:	52                   	push   %edx
8010144d:	83 c0 6c             	add    $0x6c,%eax
80101450:	50                   	push   %eax
80101451:	e8 ba 3a 00 00       	call   80104f10 <safestrcpy>
  curproc->pgdir = pgdir;
80101456:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010145c:	89 f8                	mov    %edi,%eax
8010145e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101461:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101463:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101466:	89 c1                	mov    %eax,%ecx
80101468:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010146e:	8b 40 18             	mov    0x18(%eax),%eax
80101471:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101474:	8b 41 18             	mov    0x18(%ecx),%eax
80101477:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010147a:	89 0c 24             	mov    %ecx,(%esp)
8010147d:	e8 6e 5c 00 00       	call   801070f0 <switchuvm>
  freevm(oldpgdir);
80101482:	89 3c 24             	mov    %edi,(%esp)
80101485:	e8 26 60 00 00       	call   801074b0 <freevm>
  return 0;
8010148a:	83 c4 10             	add    $0x10,%esp
8010148d:	31 c0                	xor    %eax,%eax
8010148f:	e9 3c fd ff ff       	jmp    801011d0 <exec+0x70>
    end_op();
80101494:	e8 e7 1f 00 00       	call   80103480 <end_op>
    cprintf("exec: fail\n");
80101499:	83 ec 0c             	sub    $0xc,%esp
8010149c:	68 41 78 10 80       	push   $0x80107841
801014a1:	e8 fa f2 ff ff       	call   801007a0 <cprintf>
    return -1;
801014a6:	83 c4 10             	add    $0x10,%esp
801014a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014ae:	e9 1d fd ff ff       	jmp    801011d0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801014b3:	31 ff                	xor    %edi,%edi
801014b5:	be 00 20 00 00       	mov    $0x2000,%esi
801014ba:	e9 39 fe ff ff       	jmp    801012f8 <exec+0x198>
801014bf:	90                   	nop

801014c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801014c0:	f3 0f 1e fb          	endbr32 
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801014ca:	68 4d 78 10 80       	push   $0x8010784d
801014cf:	68 00 15 11 80       	push   $0x80111500
801014d4:	e8 e7 35 00 00       	call   80104ac0 <initlock>
}
801014d9:	83 c4 10             	add    $0x10,%esp
801014dc:	c9                   	leave  
801014dd:	c3                   	ret    
801014de:	66 90                	xchg   %ax,%ax

801014e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801014e0:	f3 0f 1e fb          	endbr32 
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014e8:	bb 34 15 11 80       	mov    $0x80111534,%ebx
{
801014ed:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801014f0:	68 00 15 11 80       	push   $0x80111500
801014f5:	e8 46 37 00 00       	call   80104c40 <acquire>
801014fa:	83 c4 10             	add    $0x10,%esp
801014fd:	eb 0c                	jmp    8010150b <filealloc+0x2b>
801014ff:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101500:	83 c3 18             	add    $0x18,%ebx
80101503:	81 fb 94 1e 11 80    	cmp    $0x80111e94,%ebx
80101509:	74 25                	je     80101530 <filealloc+0x50>
    if(f->ref == 0){
8010150b:	8b 43 04             	mov    0x4(%ebx),%eax
8010150e:	85 c0                	test   %eax,%eax
80101510:	75 ee                	jne    80101500 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101512:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101515:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010151c:	68 00 15 11 80       	push   $0x80111500
80101521:	e8 da 37 00 00       	call   80104d00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101526:	89 d8                	mov    %ebx,%eax
      return f;
80101528:	83 c4 10             	add    $0x10,%esp
}
8010152b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010152e:	c9                   	leave  
8010152f:	c3                   	ret    
  release(&ftable.lock);
80101530:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101533:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101535:	68 00 15 11 80       	push   $0x80111500
8010153a:	e8 c1 37 00 00       	call   80104d00 <release>
}
8010153f:	89 d8                	mov    %ebx,%eax
  return 0;
80101541:	83 c4 10             	add    $0x10,%esp
}
80101544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101547:	c9                   	leave  
80101548:	c3                   	ret    
80101549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101550 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	83 ec 10             	sub    $0x10,%esp
8010155b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010155e:	68 00 15 11 80       	push   $0x80111500
80101563:	e8 d8 36 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
80101568:	8b 43 04             	mov    0x4(%ebx),%eax
8010156b:	83 c4 10             	add    $0x10,%esp
8010156e:	85 c0                	test   %eax,%eax
80101570:	7e 1a                	jle    8010158c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101572:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101575:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101578:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010157b:	68 00 15 11 80       	push   $0x80111500
80101580:	e8 7b 37 00 00       	call   80104d00 <release>
  return f;
}
80101585:	89 d8                	mov    %ebx,%eax
80101587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010158a:	c9                   	leave  
8010158b:	c3                   	ret    
    panic("filedup");
8010158c:	83 ec 0c             	sub    $0xc,%esp
8010158f:	68 54 78 10 80       	push   $0x80107854
80101594:	e8 f7 ed ff ff       	call   80100390 <panic>
80101599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801015a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801015a0:	f3 0f 1e fb          	endbr32 
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	57                   	push   %edi
801015a8:	56                   	push   %esi
801015a9:	53                   	push   %ebx
801015aa:	83 ec 28             	sub    $0x28,%esp
801015ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801015b0:	68 00 15 11 80       	push   $0x80111500
801015b5:	e8 86 36 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
801015ba:	8b 53 04             	mov    0x4(%ebx),%edx
801015bd:	83 c4 10             	add    $0x10,%esp
801015c0:	85 d2                	test   %edx,%edx
801015c2:	0f 8e a1 00 00 00    	jle    80101669 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801015c8:	83 ea 01             	sub    $0x1,%edx
801015cb:	89 53 04             	mov    %edx,0x4(%ebx)
801015ce:	75 40                	jne    80101610 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801015d0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801015d4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801015d7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801015d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801015df:	8b 73 0c             	mov    0xc(%ebx),%esi
801015e2:	88 45 e7             	mov    %al,-0x19(%ebp)
801015e5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801015e8:	68 00 15 11 80       	push   $0x80111500
  ff = *f;
801015ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801015f0:	e8 0b 37 00 00       	call   80104d00 <release>

  if(ff.type == FD_PIPE)
801015f5:	83 c4 10             	add    $0x10,%esp
801015f8:	83 ff 01             	cmp    $0x1,%edi
801015fb:	74 53                	je     80101650 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801015fd:	83 ff 02             	cmp    $0x2,%edi
80101600:	74 26                	je     80101628 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101602:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101605:	5b                   	pop    %ebx
80101606:	5e                   	pop    %esi
80101607:	5f                   	pop    %edi
80101608:	5d                   	pop    %ebp
80101609:	c3                   	ret    
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101610:	c7 45 08 00 15 11 80 	movl   $0x80111500,0x8(%ebp)
}
80101617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161a:	5b                   	pop    %ebx
8010161b:	5e                   	pop    %esi
8010161c:	5f                   	pop    %edi
8010161d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010161e:	e9 dd 36 00 00       	jmp    80104d00 <release>
80101623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101627:	90                   	nop
    begin_op();
80101628:	e8 e3 1d 00 00       	call   80103410 <begin_op>
    iput(ff.ip);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 e0             	pushl  -0x20(%ebp)
80101633:	e8 38 09 00 00       	call   80101f70 <iput>
    end_op();
80101638:	83 c4 10             	add    $0x10,%esp
}
8010163b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163e:	5b                   	pop    %ebx
8010163f:	5e                   	pop    %esi
80101640:	5f                   	pop    %edi
80101641:	5d                   	pop    %ebp
    end_op();
80101642:	e9 39 1e 00 00       	jmp    80103480 <end_op>
80101647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101650:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101654:	83 ec 08             	sub    $0x8,%esp
80101657:	53                   	push   %ebx
80101658:	56                   	push   %esi
80101659:	e8 82 25 00 00       	call   80103be0 <pipeclose>
8010165e:	83 c4 10             	add    $0x10,%esp
}
80101661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101664:	5b                   	pop    %ebx
80101665:	5e                   	pop    %esi
80101666:	5f                   	pop    %edi
80101667:	5d                   	pop    %ebp
80101668:	c3                   	ret    
    panic("fileclose");
80101669:	83 ec 0c             	sub    $0xc,%esp
8010166c:	68 5c 78 10 80       	push   $0x8010785c
80101671:	e8 1a ed ff ff       	call   80100390 <panic>
80101676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101680:	f3 0f 1e fb          	endbr32 
80101684:	55                   	push   %ebp
80101685:	89 e5                	mov    %esp,%ebp
80101687:	53                   	push   %ebx
80101688:	83 ec 04             	sub    $0x4,%esp
8010168b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010168e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101691:	75 2d                	jne    801016c0 <filestat+0x40>
    ilock(f->ip);
80101693:	83 ec 0c             	sub    $0xc,%esp
80101696:	ff 73 10             	pushl  0x10(%ebx)
80101699:	e8 a2 07 00 00       	call   80101e40 <ilock>
    stati(f->ip, st);
8010169e:	58                   	pop    %eax
8010169f:	5a                   	pop    %edx
801016a0:	ff 75 0c             	pushl  0xc(%ebp)
801016a3:	ff 73 10             	pushl  0x10(%ebx)
801016a6:	e8 65 0a 00 00       	call   80102110 <stati>
    iunlock(f->ip);
801016ab:	59                   	pop    %ecx
801016ac:	ff 73 10             	pushl  0x10(%ebx)
801016af:	e8 6c 08 00 00       	call   80101f20 <iunlock>
    return 0;
  }
  return -1;
}
801016b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801016b7:	83 c4 10             	add    $0x10,%esp
801016ba:	31 c0                	xor    %eax,%eax
}
801016bc:	c9                   	leave  
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax
801016c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801016c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801016c8:	c9                   	leave  
801016c9:	c3                   	ret    
801016ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801016d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801016d0:	f3 0f 1e fb          	endbr32 
801016d4:	55                   	push   %ebp
801016d5:	89 e5                	mov    %esp,%ebp
801016d7:	57                   	push   %edi
801016d8:	56                   	push   %esi
801016d9:	53                   	push   %ebx
801016da:	83 ec 0c             	sub    $0xc,%esp
801016dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016e0:	8b 75 0c             	mov    0xc(%ebp),%esi
801016e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801016e6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801016ea:	74 64                	je     80101750 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801016ec:	8b 03                	mov    (%ebx),%eax
801016ee:	83 f8 01             	cmp    $0x1,%eax
801016f1:	74 45                	je     80101738 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801016f3:	83 f8 02             	cmp    $0x2,%eax
801016f6:	75 5f                	jne    80101757 <fileread+0x87>
    ilock(f->ip);
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	ff 73 10             	pushl  0x10(%ebx)
801016fe:	e8 3d 07 00 00       	call   80101e40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101703:	57                   	push   %edi
80101704:	ff 73 14             	pushl  0x14(%ebx)
80101707:	56                   	push   %esi
80101708:	ff 73 10             	pushl  0x10(%ebx)
8010170b:	e8 30 0a 00 00       	call   80102140 <readi>
80101710:	83 c4 20             	add    $0x20,%esp
80101713:	89 c6                	mov    %eax,%esi
80101715:	85 c0                	test   %eax,%eax
80101717:	7e 03                	jle    8010171c <fileread+0x4c>
      f->off += r;
80101719:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010171c:	83 ec 0c             	sub    $0xc,%esp
8010171f:	ff 73 10             	pushl  0x10(%ebx)
80101722:	e8 f9 07 00 00       	call   80101f20 <iunlock>
    return r;
80101727:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010172a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010172d:	89 f0                	mov    %esi,%eax
8010172f:	5b                   	pop    %ebx
80101730:	5e                   	pop    %esi
80101731:	5f                   	pop    %edi
80101732:	5d                   	pop    %ebp
80101733:	c3                   	ret    
80101734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101738:	8b 43 0c             	mov    0xc(%ebx),%eax
8010173b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010173e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101741:	5b                   	pop    %ebx
80101742:	5e                   	pop    %esi
80101743:	5f                   	pop    %edi
80101744:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101745:	e9 36 26 00 00       	jmp    80103d80 <piperead>
8010174a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101750:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101755:	eb d3                	jmp    8010172a <fileread+0x5a>
  panic("fileread");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 66 78 10 80       	push   $0x80107866
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010176f:	90                   	nop

80101770 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	57                   	push   %edi
80101778:	56                   	push   %esi
80101779:	53                   	push   %ebx
8010177a:	83 ec 1c             	sub    $0x1c,%esp
8010177d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101780:	8b 75 08             	mov    0x8(%ebp),%esi
80101783:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101786:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101789:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010178d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101790:	0f 84 c1 00 00 00    	je     80101857 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101796:	8b 06                	mov    (%esi),%eax
80101798:	83 f8 01             	cmp    $0x1,%eax
8010179b:	0f 84 c3 00 00 00    	je     80101864 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801017a1:	83 f8 02             	cmp    $0x2,%eax
801017a4:	0f 85 cc 00 00 00    	jne    80101876 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801017aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801017ad:	31 ff                	xor    %edi,%edi
    while(i < n){
801017af:	85 c0                	test   %eax,%eax
801017b1:	7f 34                	jg     801017e7 <filewrite+0x77>
801017b3:	e9 98 00 00 00       	jmp    80101850 <filewrite+0xe0>
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801017c0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801017c3:	83 ec 0c             	sub    $0xc,%esp
801017c6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801017c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801017cc:	e8 4f 07 00 00       	call   80101f20 <iunlock>
      end_op();
801017d1:	e8 aa 1c 00 00       	call   80103480 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801017d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801017d9:	83 c4 10             	add    $0x10,%esp
801017dc:	39 c3                	cmp    %eax,%ebx
801017de:	75 60                	jne    80101840 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801017e0:	01 df                	add    %ebx,%edi
    while(i < n){
801017e2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801017e5:	7e 69                	jle    80101850 <filewrite+0xe0>
      int n1 = n - i;
801017e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801017ea:	b8 00 06 00 00       	mov    $0x600,%eax
801017ef:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801017f1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801017f7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801017fa:	e8 11 1c 00 00       	call   80103410 <begin_op>
      ilock(f->ip);
801017ff:	83 ec 0c             	sub    $0xc,%esp
80101802:	ff 76 10             	pushl  0x10(%esi)
80101805:	e8 36 06 00 00       	call   80101e40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010180a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010180d:	53                   	push   %ebx
8010180e:	ff 76 14             	pushl  0x14(%esi)
80101811:	01 f8                	add    %edi,%eax
80101813:	50                   	push   %eax
80101814:	ff 76 10             	pushl  0x10(%esi)
80101817:	e8 24 0a 00 00       	call   80102240 <writei>
8010181c:	83 c4 20             	add    $0x20,%esp
8010181f:	85 c0                	test   %eax,%eax
80101821:	7f 9d                	jg     801017c0 <filewrite+0x50>
      iunlock(f->ip);
80101823:	83 ec 0c             	sub    $0xc,%esp
80101826:	ff 76 10             	pushl  0x10(%esi)
80101829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010182c:	e8 ef 06 00 00       	call   80101f20 <iunlock>
      end_op();
80101831:	e8 4a 1c 00 00       	call   80103480 <end_op>
      if(r < 0)
80101836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101839:	83 c4 10             	add    $0x10,%esp
8010183c:	85 c0                	test   %eax,%eax
8010183e:	75 17                	jne    80101857 <filewrite+0xe7>
        panic("short filewrite");
80101840:	83 ec 0c             	sub    $0xc,%esp
80101843:	68 6f 78 10 80       	push   $0x8010786f
80101848:	e8 43 eb ff ff       	call   80100390 <panic>
8010184d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101850:	89 f8                	mov    %edi,%eax
80101852:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101855:	74 05                	je     8010185c <filewrite+0xec>
80101857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010185c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010185f:	5b                   	pop    %ebx
80101860:	5e                   	pop    %esi
80101861:	5f                   	pop    %edi
80101862:	5d                   	pop    %ebp
80101863:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101864:	8b 46 0c             	mov    0xc(%esi),%eax
80101867:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010186a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186d:	5b                   	pop    %ebx
8010186e:	5e                   	pop    %esi
8010186f:	5f                   	pop    %edi
80101870:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101871:	e9 0a 24 00 00       	jmp    80103c80 <pipewrite>
  panic("filewrite");
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	68 75 78 10 80       	push   $0x80107875
8010187e:	e8 0d eb ff ff       	call   80100390 <panic>
80101883:	66 90                	xchg   %ax,%ax
80101885:	66 90                	xchg   %ax,%ax
80101887:	66 90                	xchg   %ax,%ax
80101889:	66 90                	xchg   %ax,%ax
8010188b:	66 90                	xchg   %ax,%ax
8010188d:	66 90                	xchg   %ax,%ax
8010188f:	90                   	nop

80101890 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101890:	55                   	push   %ebp
80101891:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101893:	89 d0                	mov    %edx,%eax
80101895:	c1 e8 0c             	shr    $0xc,%eax
80101898:	03 05 18 1f 11 80    	add    0x80111f18,%eax
{
8010189e:	89 e5                	mov    %esp,%ebp
801018a0:	56                   	push   %esi
801018a1:	53                   	push   %ebx
801018a2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801018a4:	83 ec 08             	sub    $0x8,%esp
801018a7:	50                   	push   %eax
801018a8:	51                   	push   %ecx
801018a9:	e8 22 e8 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801018ae:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801018b0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801018b3:	ba 01 00 00 00       	mov    $0x1,%edx
801018b8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801018bb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801018c1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801018c4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801018c6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801018cb:	85 d1                	test   %edx,%ecx
801018cd:	74 25                	je     801018f4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801018cf:	f7 d2                	not    %edx
  log_write(bp);
801018d1:	83 ec 0c             	sub    $0xc,%esp
801018d4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801018d6:	21 ca                	and    %ecx,%edx
801018d8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801018dc:	50                   	push   %eax
801018dd:	e8 0e 1d 00 00       	call   801035f0 <log_write>
  brelse(bp);
801018e2:	89 34 24             	mov    %esi,(%esp)
801018e5:	e8 06 e9 ff ff       	call   801001f0 <brelse>
}
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5d                   	pop    %ebp
801018f3:	c3                   	ret    
    panic("freeing free block");
801018f4:	83 ec 0c             	sub    $0xc,%esp
801018f7:	68 7f 78 10 80       	push   $0x8010787f
801018fc:	e8 8f ea ff ff       	call   80100390 <panic>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop

80101910 <balloc>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101919:	8b 0d 00 1f 11 80    	mov    0x80111f00,%ecx
{
8010191f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101922:	85 c9                	test   %ecx,%ecx
80101924:	0f 84 87 00 00 00    	je     801019b1 <balloc+0xa1>
8010192a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101931:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101934:	83 ec 08             	sub    $0x8,%esp
80101937:	89 f0                	mov    %esi,%eax
80101939:	c1 f8 0c             	sar    $0xc,%eax
8010193c:	03 05 18 1f 11 80    	add    0x80111f18,%eax
80101942:	50                   	push   %eax
80101943:	ff 75 d8             	pushl  -0x28(%ebp)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	83 c4 10             	add    $0x10,%esp
8010194e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101951:	a1 00 1f 11 80       	mov    0x80111f00,%eax
80101956:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101959:	31 c0                	xor    %eax,%eax
8010195b:	eb 2f                	jmp    8010198c <balloc+0x7c>
8010195d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101960:	89 c1                	mov    %eax,%ecx
80101962:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010196a:	83 e1 07             	and    $0x7,%ecx
8010196d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010196f:	89 c1                	mov    %eax,%ecx
80101971:	c1 f9 03             	sar    $0x3,%ecx
80101974:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101979:	89 fa                	mov    %edi,%edx
8010197b:	85 df                	test   %ebx,%edi
8010197d:	74 41                	je     801019c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010197f:	83 c0 01             	add    $0x1,%eax
80101982:	83 c6 01             	add    $0x1,%esi
80101985:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010198a:	74 05                	je     80101991 <balloc+0x81>
8010198c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010198f:	77 cf                	ja     80101960 <balloc+0x50>
    brelse(bp);
80101991:	83 ec 0c             	sub    $0xc,%esp
80101994:	ff 75 e4             	pushl  -0x1c(%ebp)
80101997:	e8 54 e8 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010199c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801019a3:	83 c4 10             	add    $0x10,%esp
801019a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801019a9:	39 05 00 1f 11 80    	cmp    %eax,0x80111f00
801019af:	77 80                	ja     80101931 <balloc+0x21>
  panic("balloc: out of blocks");
801019b1:	83 ec 0c             	sub    $0xc,%esp
801019b4:	68 92 78 10 80       	push   $0x80107892
801019b9:	e8 d2 e9 ff ff       	call   80100390 <panic>
801019be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801019c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801019c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801019c6:	09 da                	or     %ebx,%edx
801019c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801019cc:	57                   	push   %edi
801019cd:	e8 1e 1c 00 00       	call   801035f0 <log_write>
        brelse(bp);
801019d2:	89 3c 24             	mov    %edi,(%esp)
801019d5:	e8 16 e8 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801019da:	58                   	pop    %eax
801019db:	5a                   	pop    %edx
801019dc:	56                   	push   %esi
801019dd:	ff 75 d8             	pushl  -0x28(%ebp)
801019e0:	e8 eb e6 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801019e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801019e8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801019ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801019ed:	68 00 02 00 00       	push   $0x200
801019f2:	6a 00                	push   $0x0
801019f4:	50                   	push   %eax
801019f5:	e8 56 33 00 00       	call   80104d50 <memset>
  log_write(bp);
801019fa:	89 1c 24             	mov    %ebx,(%esp)
801019fd:	e8 ee 1b 00 00       	call   801035f0 <log_write>
  brelse(bp);
80101a02:	89 1c 24             	mov    %ebx,(%esp)
80101a05:	e8 e6 e7 ff ff       	call   801001f0 <brelse>
}
80101a0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0d:	89 f0                	mov    %esi,%eax
80101a0f:	5b                   	pop    %ebx
80101a10:	5e                   	pop    %esi
80101a11:	5f                   	pop    %edi
80101a12:	5d                   	pop    %ebp
80101a13:	c3                   	ret    
80101a14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a1f:	90                   	nop

80101a20 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	89 c7                	mov    %eax,%edi
80101a26:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101a27:	31 f6                	xor    %esi,%esi
{
80101a29:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a2a:	bb 54 1f 11 80       	mov    $0x80111f54,%ebx
{
80101a2f:	83 ec 28             	sub    $0x28,%esp
80101a32:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101a35:	68 20 1f 11 80       	push   $0x80111f20
80101a3a:	e8 01 32 00 00       	call   80104c40 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	eb 1b                	jmp    80101a62 <iget+0x42>
80101a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a50:	39 3b                	cmp    %edi,(%ebx)
80101a52:	74 6c                	je     80101ac0 <iget+0xa0>
80101a54:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a5a:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101a60:	73 26                	jae    80101a88 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a62:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101a65:	85 c9                	test   %ecx,%ecx
80101a67:	7f e7                	jg     80101a50 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a69:	85 f6                	test   %esi,%esi
80101a6b:	75 e7                	jne    80101a54 <iget+0x34>
80101a6d:	89 d8                	mov    %ebx,%eax
80101a6f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a75:	85 c9                	test   %ecx,%ecx
80101a77:	75 6e                	jne    80101ae7 <iget+0xc7>
80101a79:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a7b:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101a81:	72 df                	jb     80101a62 <iget+0x42>
80101a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a87:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a88:	85 f6                	test   %esi,%esi
80101a8a:	74 73                	je     80101aff <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101a8c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101a8f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101a91:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101a94:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101a9b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101aa2:	68 20 1f 11 80       	push   $0x80111f20
80101aa7:	e8 54 32 00 00       	call   80104d00 <release>

  return ip;
80101aac:	83 c4 10             	add    $0x10,%esp
}
80101aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab2:	89 f0                	mov    %esi,%eax
80101ab4:	5b                   	pop    %ebx
80101ab5:	5e                   	pop    %esi
80101ab6:	5f                   	pop    %edi
80101ab7:	5d                   	pop    %ebp
80101ab8:	c3                   	ret    
80101ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101ac0:	39 53 04             	cmp    %edx,0x4(%ebx)
80101ac3:	75 8f                	jne    80101a54 <iget+0x34>
      release(&icache.lock);
80101ac5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101ac8:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101acb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101acd:	68 20 1f 11 80       	push   $0x80111f20
      ip->ref++;
80101ad2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101ad5:	e8 26 32 00 00       	call   80104d00 <release>
      return ip;
80101ada:	83 c4 10             	add    $0x10,%esp
}
80101add:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae0:	89 f0                	mov    %esi,%eax
80101ae2:	5b                   	pop    %ebx
80101ae3:	5e                   	pop    %esi
80101ae4:	5f                   	pop    %edi
80101ae5:	5d                   	pop    %ebp
80101ae6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ae7:	81 fb 74 3b 11 80    	cmp    $0x80113b74,%ebx
80101aed:	73 10                	jae    80101aff <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101aef:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101af2:	85 c9                	test   %ecx,%ecx
80101af4:	0f 8f 56 ff ff ff    	jg     80101a50 <iget+0x30>
80101afa:	e9 6e ff ff ff       	jmp    80101a6d <iget+0x4d>
    panic("iget: no inodes");
80101aff:	83 ec 0c             	sub    $0xc,%esp
80101b02:	68 a8 78 10 80       	push   $0x801078a8
80101b07:	e8 84 e8 ff ff       	call   80100390 <panic>
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	89 c6                	mov    %eax,%esi
80101b17:	53                   	push   %ebx
80101b18:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b1b:	83 fa 0b             	cmp    $0xb,%edx
80101b1e:	0f 86 84 00 00 00    	jbe    80101ba8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101b24:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101b27:	83 fb 7f             	cmp    $0x7f,%ebx
80101b2a:	0f 87 98 00 00 00    	ja     80101bc8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b30:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101b36:	8b 16                	mov    (%esi),%edx
80101b38:	85 c0                	test   %eax,%eax
80101b3a:	74 54                	je     80101b90 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101b3c:	83 ec 08             	sub    $0x8,%esp
80101b3f:	50                   	push   %eax
80101b40:	52                   	push   %edx
80101b41:	e8 8a e5 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101b46:	83 c4 10             	add    $0x10,%esp
80101b49:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101b4d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101b4f:	8b 1a                	mov    (%edx),%ebx
80101b51:	85 db                	test   %ebx,%ebx
80101b53:	74 1b                	je     80101b70 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101b55:	83 ec 0c             	sub    $0xc,%esp
80101b58:	57                   	push   %edi
80101b59:	e8 92 e6 ff ff       	call   801001f0 <brelse>
    return addr;
80101b5e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b64:	89 d8                	mov    %ebx,%eax
80101b66:	5b                   	pop    %ebx
80101b67:	5e                   	pop    %esi
80101b68:	5f                   	pop    %edi
80101b69:	5d                   	pop    %ebp
80101b6a:	c3                   	ret    
80101b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101b70:	8b 06                	mov    (%esi),%eax
80101b72:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101b75:	e8 96 fd ff ff       	call   80101910 <balloc>
80101b7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101b7d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101b80:	89 c3                	mov    %eax,%ebx
80101b82:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101b84:	57                   	push   %edi
80101b85:	e8 66 1a 00 00       	call   801035f0 <log_write>
80101b8a:	83 c4 10             	add    $0x10,%esp
80101b8d:	eb c6                	jmp    80101b55 <bmap+0x45>
80101b8f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b90:	89 d0                	mov    %edx,%eax
80101b92:	e8 79 fd ff ff       	call   80101910 <balloc>
80101b97:	8b 16                	mov    (%esi),%edx
80101b99:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101b9f:	eb 9b                	jmp    80101b3c <bmap+0x2c>
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101ba8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101bab:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101bae:	85 db                	test   %ebx,%ebx
80101bb0:	75 af                	jne    80101b61 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bb2:	8b 00                	mov    (%eax),%eax
80101bb4:	e8 57 fd ff ff       	call   80101910 <balloc>
80101bb9:	89 47 5c             	mov    %eax,0x5c(%edi)
80101bbc:	89 c3                	mov    %eax,%ebx
}
80101bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc1:	89 d8                	mov    %ebx,%eax
80101bc3:	5b                   	pop    %ebx
80101bc4:	5e                   	pop    %esi
80101bc5:	5f                   	pop    %edi
80101bc6:	5d                   	pop    %ebp
80101bc7:	c3                   	ret    
  panic("bmap: out of range");
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 b8 78 10 80       	push   $0x801078b8
80101bd0:	e8 bb e7 ff ff       	call   80100390 <panic>
80101bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101be0 <readsb>:
{
80101be0:	f3 0f 1e fb          	endbr32 
80101be4:	55                   	push   %ebp
80101be5:	89 e5                	mov    %esp,%ebp
80101be7:	56                   	push   %esi
80101be8:	53                   	push   %ebx
80101be9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101bec:	83 ec 08             	sub    $0x8,%esp
80101bef:	6a 01                	push   $0x1
80101bf1:	ff 75 08             	pushl  0x8(%ebp)
80101bf4:	e8 d7 e4 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101bf9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101bfc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101bfe:	8d 40 5c             	lea    0x5c(%eax),%eax
80101c01:	6a 1c                	push   $0x1c
80101c03:	50                   	push   %eax
80101c04:	56                   	push   %esi
80101c05:	e8 e6 31 00 00       	call   80104df0 <memmove>
  brelse(bp);
80101c0a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c0d:	83 c4 10             	add    $0x10,%esp
}
80101c10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c13:	5b                   	pop    %ebx
80101c14:	5e                   	pop    %esi
80101c15:	5d                   	pop    %ebp
  brelse(bp);
80101c16:	e9 d5 e5 ff ff       	jmp    801001f0 <brelse>
80101c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop

80101c20 <iinit>:
{
80101c20:	f3 0f 1e fb          	endbr32 
80101c24:	55                   	push   %ebp
80101c25:	89 e5                	mov    %esp,%ebp
80101c27:	53                   	push   %ebx
80101c28:	bb 60 1f 11 80       	mov    $0x80111f60,%ebx
80101c2d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101c30:	68 cb 78 10 80       	push   $0x801078cb
80101c35:	68 20 1f 11 80       	push   $0x80111f20
80101c3a:	e8 81 2e 00 00       	call   80104ac0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101c3f:	83 c4 10             	add    $0x10,%esp
80101c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101c48:	83 ec 08             	sub    $0x8,%esp
80101c4b:	68 d2 78 10 80       	push   $0x801078d2
80101c50:	53                   	push   %ebx
80101c51:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c57:	e8 24 2d 00 00       	call   80104980 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101c5c:	83 c4 10             	add    $0x10,%esp
80101c5f:	81 fb 80 3b 11 80    	cmp    $0x80113b80,%ebx
80101c65:	75 e1                	jne    80101c48 <iinit+0x28>
  readsb(dev, &sb);
80101c67:	83 ec 08             	sub    $0x8,%esp
80101c6a:	68 00 1f 11 80       	push   $0x80111f00
80101c6f:	ff 75 08             	pushl  0x8(%ebp)
80101c72:	e8 69 ff ff ff       	call   80101be0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101c77:	ff 35 18 1f 11 80    	pushl  0x80111f18
80101c7d:	ff 35 14 1f 11 80    	pushl  0x80111f14
80101c83:	ff 35 10 1f 11 80    	pushl  0x80111f10
80101c89:	ff 35 0c 1f 11 80    	pushl  0x80111f0c
80101c8f:	ff 35 08 1f 11 80    	pushl  0x80111f08
80101c95:	ff 35 04 1f 11 80    	pushl  0x80111f04
80101c9b:	ff 35 00 1f 11 80    	pushl  0x80111f00
80101ca1:	68 38 79 10 80       	push   $0x80107938
80101ca6:	e8 f5 ea ff ff       	call   801007a0 <cprintf>
}
80101cab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cae:	83 c4 30             	add    $0x30,%esp
80101cb1:	c9                   	leave  
80101cb2:	c3                   	ret    
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <ialloc>:
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101cd0:	83 3d 08 1f 11 80 01 	cmpl   $0x1,0x80111f08
{
80101cd7:	8b 75 08             	mov    0x8(%ebp),%esi
80101cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101cdd:	0f 86 8d 00 00 00    	jbe    80101d70 <ialloc+0xb0>
80101ce3:	bf 01 00 00 00       	mov    $0x1,%edi
80101ce8:	eb 1d                	jmp    80101d07 <ialloc+0x47>
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101cf0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101cf3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101cf6:	53                   	push   %ebx
80101cf7:	e8 f4 e4 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101cfc:	83 c4 10             	add    $0x10,%esp
80101cff:	3b 3d 08 1f 11 80    	cmp    0x80111f08,%edi
80101d05:	73 69                	jae    80101d70 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101d07:	89 f8                	mov    %edi,%eax
80101d09:	83 ec 08             	sub    $0x8,%esp
80101d0c:	c1 e8 03             	shr    $0x3,%eax
80101d0f:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101d15:	50                   	push   %eax
80101d16:	56                   	push   %esi
80101d17:	e8 b4 e3 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101d1c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101d1f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101d21:	89 f8                	mov    %edi,%eax
80101d23:	83 e0 07             	and    $0x7,%eax
80101d26:	c1 e0 06             	shl    $0x6,%eax
80101d29:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101d2d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101d31:	75 bd                	jne    80101cf0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101d33:	83 ec 04             	sub    $0x4,%esp
80101d36:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101d39:	6a 40                	push   $0x40
80101d3b:	6a 00                	push   $0x0
80101d3d:	51                   	push   %ecx
80101d3e:	e8 0d 30 00 00       	call   80104d50 <memset>
      dip->type = type;
80101d43:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101d47:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101d4a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101d4d:	89 1c 24             	mov    %ebx,(%esp)
80101d50:	e8 9b 18 00 00       	call   801035f0 <log_write>
      brelse(bp);
80101d55:	89 1c 24             	mov    %ebx,(%esp)
80101d58:	e8 93 e4 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101d5d:	83 c4 10             	add    $0x10,%esp
}
80101d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101d63:	89 fa                	mov    %edi,%edx
}
80101d65:	5b                   	pop    %ebx
      return iget(dev, inum);
80101d66:	89 f0                	mov    %esi,%eax
}
80101d68:	5e                   	pop    %esi
80101d69:	5f                   	pop    %edi
80101d6a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101d6b:	e9 b0 fc ff ff       	jmp    80101a20 <iget>
  panic("ialloc: no inodes");
80101d70:	83 ec 0c             	sub    $0xc,%esp
80101d73:	68 d8 78 10 80       	push   $0x801078d8
80101d78:	e8 13 e6 ff ff       	call   80100390 <panic>
80101d7d:	8d 76 00             	lea    0x0(%esi),%esi

80101d80 <iupdate>:
{
80101d80:	f3 0f 1e fb          	endbr32 
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	56                   	push   %esi
80101d88:	53                   	push   %ebx
80101d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d8c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d8f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d92:	83 ec 08             	sub    $0x8,%esp
80101d95:	c1 e8 03             	shr    $0x3,%eax
80101d98:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101d9e:	50                   	push   %eax
80101d9f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101da2:	e8 29 e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101da7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101dab:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101dae:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101db0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101db3:	83 e0 07             	and    $0x7,%eax
80101db6:	c1 e0 06             	shl    $0x6,%eax
80101db9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101dbd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101dc0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101dc4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101dc7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101dcb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101dcf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101dd3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101dd7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101ddb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101dde:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101de1:	6a 34                	push   $0x34
80101de3:	53                   	push   %ebx
80101de4:	50                   	push   %eax
80101de5:	e8 06 30 00 00       	call   80104df0 <memmove>
  log_write(bp);
80101dea:	89 34 24             	mov    %esi,(%esp)
80101ded:	e8 fe 17 00 00       	call   801035f0 <log_write>
  brelse(bp);
80101df2:	89 75 08             	mov    %esi,0x8(%ebp)
80101df5:	83 c4 10             	add    $0x10,%esp
}
80101df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5d                   	pop    %ebp
  brelse(bp);
80101dfe:	e9 ed e3 ff ff       	jmp    801001f0 <brelse>
80101e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e10 <idup>:
{
80101e10:	f3 0f 1e fb          	endbr32 
80101e14:	55                   	push   %ebp
80101e15:	89 e5                	mov    %esp,%ebp
80101e17:	53                   	push   %ebx
80101e18:	83 ec 10             	sub    $0x10,%esp
80101e1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101e1e:	68 20 1f 11 80       	push   $0x80111f20
80101e23:	e8 18 2e 00 00       	call   80104c40 <acquire>
  ip->ref++;
80101e28:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101e2c:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101e33:	e8 c8 2e 00 00       	call   80104d00 <release>
}
80101e38:	89 d8                	mov    %ebx,%eax
80101e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e3d:	c9                   	leave  
80101e3e:	c3                   	ret    
80101e3f:	90                   	nop

80101e40 <ilock>:
{
80101e40:	f3 0f 1e fb          	endbr32 
80101e44:	55                   	push   %ebp
80101e45:	89 e5                	mov    %esp,%ebp
80101e47:	56                   	push   %esi
80101e48:	53                   	push   %ebx
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101e4c:	85 db                	test   %ebx,%ebx
80101e4e:	0f 84 b3 00 00 00    	je     80101f07 <ilock+0xc7>
80101e54:	8b 53 08             	mov    0x8(%ebx),%edx
80101e57:	85 d2                	test   %edx,%edx
80101e59:	0f 8e a8 00 00 00    	jle    80101f07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101e5f:	83 ec 0c             	sub    $0xc,%esp
80101e62:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e65:	50                   	push   %eax
80101e66:	e8 55 2b 00 00       	call   801049c0 <acquiresleep>
  if(ip->valid == 0){
80101e6b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101e6e:	83 c4 10             	add    $0x10,%esp
80101e71:	85 c0                	test   %eax,%eax
80101e73:	74 0b                	je     80101e80 <ilock+0x40>
}
80101e75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e78:	5b                   	pop    %ebx
80101e79:	5e                   	pop    %esi
80101e7a:	5d                   	pop    %ebp
80101e7b:	c3                   	ret    
80101e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e80:	8b 43 04             	mov    0x4(%ebx),%eax
80101e83:	83 ec 08             	sub    $0x8,%esp
80101e86:	c1 e8 03             	shr    $0x3,%eax
80101e89:	03 05 14 1f 11 80    	add    0x80111f14,%eax
80101e8f:	50                   	push   %eax
80101e90:	ff 33                	pushl  (%ebx)
80101e92:	e8 39 e2 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e97:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e9a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e9c:	8b 43 04             	mov    0x4(%ebx),%eax
80101e9f:	83 e0 07             	and    $0x7,%eax
80101ea2:	c1 e0 06             	shl    $0x6,%eax
80101ea5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ea9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101eac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101eaf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101eb3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101eb7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101ebb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101ebf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ec3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ec7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101ecb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101ece:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ed1:	6a 34                	push   $0x34
80101ed3:	50                   	push   %eax
80101ed4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ed7:	50                   	push   %eax
80101ed8:	e8 13 2f 00 00       	call   80104df0 <memmove>
    brelse(bp);
80101edd:	89 34 24             	mov    %esi,(%esp)
80101ee0:	e8 0b e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101ee5:	83 c4 10             	add    $0x10,%esp
80101ee8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101eed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ef4:	0f 85 7b ff ff ff    	jne    80101e75 <ilock+0x35>
      panic("ilock: no type");
80101efa:	83 ec 0c             	sub    $0xc,%esp
80101efd:	68 f0 78 10 80       	push   $0x801078f0
80101f02:	e8 89 e4 ff ff       	call   80100390 <panic>
    panic("ilock");
80101f07:	83 ec 0c             	sub    $0xc,%esp
80101f0a:	68 ea 78 10 80       	push   $0x801078ea
80101f0f:	e8 7c e4 ff ff       	call   80100390 <panic>
80101f14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop

80101f20 <iunlock>:
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	56                   	push   %esi
80101f28:	53                   	push   %ebx
80101f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f2c:	85 db                	test   %ebx,%ebx
80101f2e:	74 28                	je     80101f58 <iunlock+0x38>
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	8d 73 0c             	lea    0xc(%ebx),%esi
80101f36:	56                   	push   %esi
80101f37:	e8 24 2b 00 00       	call   80104a60 <holdingsleep>
80101f3c:	83 c4 10             	add    $0x10,%esp
80101f3f:	85 c0                	test   %eax,%eax
80101f41:	74 15                	je     80101f58 <iunlock+0x38>
80101f43:	8b 43 08             	mov    0x8(%ebx),%eax
80101f46:	85 c0                	test   %eax,%eax
80101f48:	7e 0e                	jle    80101f58 <iunlock+0x38>
  releasesleep(&ip->lock);
80101f4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101f53:	e9 c8 2a 00 00       	jmp    80104a20 <releasesleep>
    panic("iunlock");
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	68 ff 78 10 80       	push   $0x801078ff
80101f60:	e8 2b e4 ff ff       	call   80100390 <panic>
80101f65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f70 <iput>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 28             	sub    $0x28,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101f80:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101f83:	57                   	push   %edi
80101f84:	e8 37 2a 00 00       	call   801049c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f89:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101f8c:	83 c4 10             	add    $0x10,%esp
80101f8f:	85 d2                	test   %edx,%edx
80101f91:	74 07                	je     80101f9a <iput+0x2a>
80101f93:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101f98:	74 36                	je     80101fd0 <iput+0x60>
  releasesleep(&ip->lock);
80101f9a:	83 ec 0c             	sub    $0xc,%esp
80101f9d:	57                   	push   %edi
80101f9e:	e8 7d 2a 00 00       	call   80104a20 <releasesleep>
  acquire(&icache.lock);
80101fa3:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101faa:	e8 91 2c 00 00       	call   80104c40 <acquire>
  ip->ref--;
80101faf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101fb3:	83 c4 10             	add    $0x10,%esp
80101fb6:	c7 45 08 20 1f 11 80 	movl   $0x80111f20,0x8(%ebp)
}
80101fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc0:	5b                   	pop    %ebx
80101fc1:	5e                   	pop    %esi
80101fc2:	5f                   	pop    %edi
80101fc3:	5d                   	pop    %ebp
  release(&icache.lock);
80101fc4:	e9 37 2d 00 00       	jmp    80104d00 <release>
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101fd0:	83 ec 0c             	sub    $0xc,%esp
80101fd3:	68 20 1f 11 80       	push   $0x80111f20
80101fd8:	e8 63 2c 00 00       	call   80104c40 <acquire>
    int r = ip->ref;
80101fdd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101fe0:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
80101fe7:	e8 14 2d 00 00       	call   80104d00 <release>
    if(r == 1){
80101fec:	83 c4 10             	add    $0x10,%esp
80101fef:	83 fe 01             	cmp    $0x1,%esi
80101ff2:	75 a6                	jne    80101f9a <iput+0x2a>
80101ff4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ffa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ffd:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102000:	89 cf                	mov    %ecx,%edi
80102002:	eb 0b                	jmp    8010200f <iput+0x9f>
80102004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102008:	83 c6 04             	add    $0x4,%esi
8010200b:	39 fe                	cmp    %edi,%esi
8010200d:	74 19                	je     80102028 <iput+0xb8>
    if(ip->addrs[i]){
8010200f:	8b 16                	mov    (%esi),%edx
80102011:	85 d2                	test   %edx,%edx
80102013:	74 f3                	je     80102008 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80102015:	8b 03                	mov    (%ebx),%eax
80102017:	e8 74 f8 ff ff       	call   80101890 <bfree>
      ip->addrs[i] = 0;
8010201c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102022:	eb e4                	jmp    80102008 <iput+0x98>
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102028:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010202e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102031:	85 c0                	test   %eax,%eax
80102033:	75 33                	jne    80102068 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102035:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102038:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010203f:	53                   	push   %ebx
80102040:	e8 3b fd ff ff       	call   80101d80 <iupdate>
      ip->type = 0;
80102045:	31 c0                	xor    %eax,%eax
80102047:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010204b:	89 1c 24             	mov    %ebx,(%esp)
8010204e:	e8 2d fd ff ff       	call   80101d80 <iupdate>
      ip->valid = 0;
80102053:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010205a:	83 c4 10             	add    $0x10,%esp
8010205d:	e9 38 ff ff ff       	jmp    80101f9a <iput+0x2a>
80102062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102068:	83 ec 08             	sub    $0x8,%esp
8010206b:	50                   	push   %eax
8010206c:	ff 33                	pushl  (%ebx)
8010206e:	e8 5d e0 ff ff       	call   801000d0 <bread>
80102073:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102076:	83 c4 10             	add    $0x10,%esp
80102079:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010207f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102082:	8d 70 5c             	lea    0x5c(%eax),%esi
80102085:	89 cf                	mov    %ecx,%edi
80102087:	eb 0e                	jmp    80102097 <iput+0x127>
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102090:	83 c6 04             	add    $0x4,%esi
80102093:	39 f7                	cmp    %esi,%edi
80102095:	74 19                	je     801020b0 <iput+0x140>
      if(a[j])
80102097:	8b 16                	mov    (%esi),%edx
80102099:	85 d2                	test   %edx,%edx
8010209b:	74 f3                	je     80102090 <iput+0x120>
        bfree(ip->dev, a[j]);
8010209d:	8b 03                	mov    (%ebx),%eax
8010209f:	e8 ec f7 ff ff       	call   80101890 <bfree>
801020a4:	eb ea                	jmp    80102090 <iput+0x120>
801020a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ad:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	ff 75 e4             	pushl  -0x1c(%ebp)
801020b6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801020b9:	e8 32 e1 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801020be:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801020c4:	8b 03                	mov    (%ebx),%eax
801020c6:	e8 c5 f7 ff ff       	call   80101890 <bfree>
    ip->addrs[NDIRECT] = 0;
801020cb:	83 c4 10             	add    $0x10,%esp
801020ce:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801020d5:	00 00 00 
801020d8:	e9 58 ff ff ff       	jmp    80102035 <iput+0xc5>
801020dd:	8d 76 00             	lea    0x0(%esi),%esi

801020e0 <iunlockput>:
{
801020e0:	f3 0f 1e fb          	endbr32 
801020e4:	55                   	push   %ebp
801020e5:	89 e5                	mov    %esp,%ebp
801020e7:	53                   	push   %ebx
801020e8:	83 ec 10             	sub    $0x10,%esp
801020eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801020ee:	53                   	push   %ebx
801020ef:	e8 2c fe ff ff       	call   80101f20 <iunlock>
  iput(ip);
801020f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801020f7:	83 c4 10             	add    $0x10,%esp
}
801020fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020fd:	c9                   	leave  
  iput(ip);
801020fe:	e9 6d fe ff ff       	jmp    80101f70 <iput>
80102103:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102110 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	8b 55 08             	mov    0x8(%ebp),%edx
8010211a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010211d:	8b 0a                	mov    (%edx),%ecx
8010211f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102122:	8b 4a 04             	mov    0x4(%edx),%ecx
80102125:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102128:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
8010212c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010212f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102133:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102137:	8b 52 58             	mov    0x58(%edx),%edx
8010213a:	89 50 10             	mov    %edx,0x10(%eax)
}
8010213d:	5d                   	pop    %ebp
8010213e:	c3                   	ret    
8010213f:	90                   	nop

80102140 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102140:	f3 0f 1e fb          	endbr32 
80102144:	55                   	push   %ebp
80102145:	89 e5                	mov    %esp,%ebp
80102147:	57                   	push   %edi
80102148:	56                   	push   %esi
80102149:	53                   	push   %ebx
8010214a:	83 ec 1c             	sub    $0x1c,%esp
8010214d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 75 10             	mov    0x10(%ebp),%esi
80102156:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102159:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010215c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102161:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102164:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102167:	0f 84 a3 00 00 00    	je     80102210 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010216d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102170:	8b 40 58             	mov    0x58(%eax),%eax
80102173:	39 c6                	cmp    %eax,%esi
80102175:	0f 87 b6 00 00 00    	ja     80102231 <readi+0xf1>
8010217b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010217e:	31 c9                	xor    %ecx,%ecx
80102180:	89 da                	mov    %ebx,%edx
80102182:	01 f2                	add    %esi,%edx
80102184:	0f 92 c1             	setb   %cl
80102187:	89 cf                	mov    %ecx,%edi
80102189:	0f 82 a2 00 00 00    	jb     80102231 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010218f:	89 c1                	mov    %eax,%ecx
80102191:	29 f1                	sub    %esi,%ecx
80102193:	39 d0                	cmp    %edx,%eax
80102195:	0f 43 cb             	cmovae %ebx,%ecx
80102198:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010219b:	85 c9                	test   %ecx,%ecx
8010219d:	74 63                	je     80102202 <readi+0xc2>
8010219f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801021a3:	89 f2                	mov    %esi,%edx
801021a5:	c1 ea 09             	shr    $0x9,%edx
801021a8:	89 d8                	mov    %ebx,%eax
801021aa:	e8 61 f9 ff ff       	call   80101b10 <bmap>
801021af:	83 ec 08             	sub    $0x8,%esp
801021b2:	50                   	push   %eax
801021b3:	ff 33                	pushl  (%ebx)
801021b5:	e8 16 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801021ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801021bd:	b9 00 02 00 00       	mov    $0x200,%ecx
801021c2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021c5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801021c7:	89 f0                	mov    %esi,%eax
801021c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ce:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801021d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021d3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801021d5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801021d9:	39 d9                	cmp    %ebx,%ecx
801021db:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801021de:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021df:	01 df                	add    %ebx,%edi
801021e1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801021e3:	50                   	push   %eax
801021e4:	ff 75 e0             	pushl  -0x20(%ebp)
801021e7:	e8 04 2c 00 00       	call   80104df0 <memmove>
    brelse(bp);
801021ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
801021ef:	89 14 24             	mov    %edx,(%esp)
801021f2:	e8 f9 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021f7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102200:	77 9e                	ja     801021a0 <readi+0x60>
  }
  return n;
80102202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102208:	5b                   	pop    %ebx
80102209:	5e                   	pop    %esi
8010220a:	5f                   	pop    %edi
8010220b:	5d                   	pop    %ebp
8010220c:	c3                   	ret    
8010220d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102210:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102214:	66 83 f8 09          	cmp    $0x9,%ax
80102218:	77 17                	ja     80102231 <readi+0xf1>
8010221a:	8b 04 c5 a0 1e 11 80 	mov    -0x7feee160(,%eax,8),%eax
80102221:	85 c0                	test   %eax,%eax
80102223:	74 0c                	je     80102231 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102225:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010222b:	5b                   	pop    %ebx
8010222c:	5e                   	pop    %esi
8010222d:	5f                   	pop    %edi
8010222e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010222f:	ff e0                	jmp    *%eax
      return -1;
80102231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102236:	eb cd                	jmp    80102205 <readi+0xc5>
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	57                   	push   %edi
80102248:	56                   	push   %esi
80102249:	53                   	push   %ebx
8010224a:	83 ec 1c             	sub    $0x1c,%esp
8010224d:	8b 45 08             	mov    0x8(%ebp),%eax
80102250:	8b 75 0c             	mov    0xc(%ebp),%esi
80102253:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102256:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010225b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010225e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102261:	8b 75 10             	mov    0x10(%ebp),%esi
80102264:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102267:	0f 84 b3 00 00 00    	je     80102320 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010226d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102270:	39 70 58             	cmp    %esi,0x58(%eax)
80102273:	0f 82 e3 00 00 00    	jb     8010235c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102279:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010227c:	89 f8                	mov    %edi,%eax
8010227e:	01 f0                	add    %esi,%eax
80102280:	0f 82 d6 00 00 00    	jb     8010235c <writei+0x11c>
80102286:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010228b:	0f 87 cb 00 00 00    	ja     8010235c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102291:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102298:	85 ff                	test   %edi,%edi
8010229a:	74 75                	je     80102311 <writei+0xd1>
8010229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022a0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801022a3:	89 f2                	mov    %esi,%edx
801022a5:	c1 ea 09             	shr    $0x9,%edx
801022a8:	89 f8                	mov    %edi,%eax
801022aa:	e8 61 f8 ff ff       	call   80101b10 <bmap>
801022af:	83 ec 08             	sub    $0x8,%esp
801022b2:	50                   	push   %eax
801022b3:	ff 37                	pushl  (%edi)
801022b5:	e8 16 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801022ba:	b9 00 02 00 00       	mov    $0x200,%ecx
801022bf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801022c2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022c5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801022c7:	89 f0                	mov    %esi,%eax
801022c9:	83 c4 0c             	add    $0xc,%esp
801022cc:	25 ff 01 00 00       	and    $0x1ff,%eax
801022d1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801022d3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801022d7:	39 d9                	cmp    %ebx,%ecx
801022d9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801022dc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022dd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801022df:	ff 75 dc             	pushl  -0x24(%ebp)
801022e2:	50                   	push   %eax
801022e3:	e8 08 2b 00 00       	call   80104df0 <memmove>
    log_write(bp);
801022e8:	89 3c 24             	mov    %edi,(%esp)
801022eb:	e8 00 13 00 00       	call   801035f0 <log_write>
    brelse(bp);
801022f0:	89 3c 24             	mov    %edi,(%esp)
801022f3:	e8 f8 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022f8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801022fb:	83 c4 10             	add    $0x10,%esp
801022fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102301:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102304:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102307:	77 97                	ja     801022a0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102309:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010230c:	3b 70 58             	cmp    0x58(%eax),%esi
8010230f:	77 37                	ja     80102348 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102311:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102314:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102317:	5b                   	pop    %ebx
80102318:	5e                   	pop    %esi
80102319:	5f                   	pop    %edi
8010231a:	5d                   	pop    %ebp
8010231b:	c3                   	ret    
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102320:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102324:	66 83 f8 09          	cmp    $0x9,%ax
80102328:	77 32                	ja     8010235c <writei+0x11c>
8010232a:	8b 04 c5 a4 1e 11 80 	mov    -0x7feee15c(,%eax,8),%eax
80102331:	85 c0                	test   %eax,%eax
80102333:	74 27                	je     8010235c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102335:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010233b:	5b                   	pop    %ebx
8010233c:	5e                   	pop    %esi
8010233d:	5f                   	pop    %edi
8010233e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010233f:	ff e0                	jmp    *%eax
80102341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102348:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010234b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010234e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102351:	50                   	push   %eax
80102352:	e8 29 fa ff ff       	call   80101d80 <iupdate>
80102357:	83 c4 10             	add    $0x10,%esp
8010235a:	eb b5                	jmp    80102311 <writei+0xd1>
      return -1;
8010235c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102361:	eb b1                	jmp    80102314 <writei+0xd4>
80102363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102370 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102370:	f3 0f 1e fb          	endbr32 
80102374:	55                   	push   %ebp
80102375:	89 e5                	mov    %esp,%ebp
80102377:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010237a:	6a 0e                	push   $0xe
8010237c:	ff 75 0c             	pushl  0xc(%ebp)
8010237f:	ff 75 08             	pushl  0x8(%ebp)
80102382:	e8 d9 2a 00 00       	call   80104e60 <strncmp>
}
80102387:	c9                   	leave  
80102388:	c3                   	ret    
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102390 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
80102395:	89 e5                	mov    %esp,%ebp
80102397:	57                   	push   %edi
80102398:	56                   	push   %esi
80102399:	53                   	push   %ebx
8010239a:	83 ec 1c             	sub    $0x1c,%esp
8010239d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801023a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801023a5:	0f 85 89 00 00 00    	jne    80102434 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801023ab:	8b 53 58             	mov    0x58(%ebx),%edx
801023ae:	31 ff                	xor    %edi,%edi
801023b0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023b3:	85 d2                	test   %edx,%edx
801023b5:	74 42                	je     801023f9 <dirlookup+0x69>
801023b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023be:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023c0:	6a 10                	push   $0x10
801023c2:	57                   	push   %edi
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	e8 76 fd ff ff       	call   80102140 <readi>
801023ca:	83 c4 10             	add    $0x10,%esp
801023cd:	83 f8 10             	cmp    $0x10,%eax
801023d0:	75 55                	jne    80102427 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801023d2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023d7:	74 18                	je     801023f1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801023d9:	83 ec 04             	sub    $0x4,%esp
801023dc:	8d 45 da             	lea    -0x26(%ebp),%eax
801023df:	6a 0e                	push   $0xe
801023e1:	50                   	push   %eax
801023e2:	ff 75 0c             	pushl  0xc(%ebp)
801023e5:	e8 76 2a 00 00       	call   80104e60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801023ea:	83 c4 10             	add    $0x10,%esp
801023ed:	85 c0                	test   %eax,%eax
801023ef:	74 17                	je     80102408 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023f1:	83 c7 10             	add    $0x10,%edi
801023f4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023f7:	72 c7                	jb     801023c0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801023f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801023fc:	31 c0                	xor    %eax,%eax
}
801023fe:	5b                   	pop    %ebx
801023ff:	5e                   	pop    %esi
80102400:	5f                   	pop    %edi
80102401:	5d                   	pop    %ebp
80102402:	c3                   	ret    
80102403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102407:	90                   	nop
      if(poff)
80102408:	8b 45 10             	mov    0x10(%ebp),%eax
8010240b:	85 c0                	test   %eax,%eax
8010240d:	74 05                	je     80102414 <dirlookup+0x84>
        *poff = off;
8010240f:	8b 45 10             	mov    0x10(%ebp),%eax
80102412:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102414:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102418:	8b 03                	mov    (%ebx),%eax
8010241a:	e8 01 f6 ff ff       	call   80101a20 <iget>
}
8010241f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5f                   	pop    %edi
80102425:	5d                   	pop    %ebp
80102426:	c3                   	ret    
      panic("dirlookup read");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 19 79 10 80       	push   $0x80107919
8010242f:	e8 5c df ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	68 07 79 10 80       	push   $0x80107907
8010243c:	e8 4f df ff ff       	call   80100390 <panic>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop

80102450 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	89 c3                	mov    %eax,%ebx
80102458:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010245b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010245e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102461:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102464:	0f 84 86 01 00 00    	je     801025f0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010246a:	e8 d1 1b 00 00       	call   80104040 <myproc>
  acquire(&icache.lock);
8010246f:	83 ec 0c             	sub    $0xc,%esp
80102472:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102474:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102477:	68 20 1f 11 80       	push   $0x80111f20
8010247c:	e8 bf 27 00 00       	call   80104c40 <acquire>
  ip->ref++;
80102481:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102485:	c7 04 24 20 1f 11 80 	movl   $0x80111f20,(%esp)
8010248c:	e8 6f 28 00 00       	call   80104d00 <release>
80102491:	83 c4 10             	add    $0x10,%esp
80102494:	eb 0d                	jmp    801024a3 <namex+0x53>
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
801024a0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801024a3:	0f b6 07             	movzbl (%edi),%eax
801024a6:	3c 2f                	cmp    $0x2f,%al
801024a8:	74 f6                	je     801024a0 <namex+0x50>
  if(*path == 0)
801024aa:	84 c0                	test   %al,%al
801024ac:	0f 84 ee 00 00 00    	je     801025a0 <namex+0x150>
  while(*path != '/' && *path != 0)
801024b2:	0f b6 07             	movzbl (%edi),%eax
801024b5:	84 c0                	test   %al,%al
801024b7:	0f 84 fb 00 00 00    	je     801025b8 <namex+0x168>
801024bd:	89 fb                	mov    %edi,%ebx
801024bf:	3c 2f                	cmp    $0x2f,%al
801024c1:	0f 84 f1 00 00 00    	je     801025b8 <namex+0x168>
801024c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ce:	66 90                	xchg   %ax,%ax
801024d0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801024d4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801024d7:	3c 2f                	cmp    $0x2f,%al
801024d9:	74 04                	je     801024df <namex+0x8f>
801024db:	84 c0                	test   %al,%al
801024dd:	75 f1                	jne    801024d0 <namex+0x80>
  len = path - s;
801024df:	89 d8                	mov    %ebx,%eax
801024e1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801024e3:	83 f8 0d             	cmp    $0xd,%eax
801024e6:	0f 8e 84 00 00 00    	jle    80102570 <namex+0x120>
    memmove(name, s, DIRSIZ);
801024ec:	83 ec 04             	sub    $0x4,%esp
801024ef:	6a 0e                	push   $0xe
801024f1:	57                   	push   %edi
    path++;
801024f2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801024f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801024f7:	e8 f4 28 00 00       	call   80104df0 <memmove>
801024fc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801024ff:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102502:	75 0c                	jne    80102510 <namex+0xc0>
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102508:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010250b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010250e:	74 f8                	je     80102508 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	56                   	push   %esi
80102514:	e8 27 f9 ff ff       	call   80101e40 <ilock>
    if(ip->type != T_DIR){
80102519:	83 c4 10             	add    $0x10,%esp
8010251c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102521:	0f 85 a1 00 00 00    	jne    801025c8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102527:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010252a:	85 d2                	test   %edx,%edx
8010252c:	74 09                	je     80102537 <namex+0xe7>
8010252e:	80 3f 00             	cmpb   $0x0,(%edi)
80102531:	0f 84 d9 00 00 00    	je     80102610 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	6a 00                	push   $0x0
8010253c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010253f:	56                   	push   %esi
80102540:	e8 4b fe ff ff       	call   80102390 <dirlookup>
80102545:	83 c4 10             	add    $0x10,%esp
80102548:	89 c3                	mov    %eax,%ebx
8010254a:	85 c0                	test   %eax,%eax
8010254c:	74 7a                	je     801025c8 <namex+0x178>
  iunlock(ip);
8010254e:	83 ec 0c             	sub    $0xc,%esp
80102551:	56                   	push   %esi
80102552:	e8 c9 f9 ff ff       	call   80101f20 <iunlock>
  iput(ip);
80102557:	89 34 24             	mov    %esi,(%esp)
8010255a:	89 de                	mov    %ebx,%esi
8010255c:	e8 0f fa ff ff       	call   80101f70 <iput>
80102561:	83 c4 10             	add    $0x10,%esp
80102564:	e9 3a ff ff ff       	jmp    801024a3 <namex+0x53>
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102573:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102576:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102579:	83 ec 04             	sub    $0x4,%esp
8010257c:	50                   	push   %eax
8010257d:	57                   	push   %edi
    name[len] = 0;
8010257e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102580:	ff 75 e4             	pushl  -0x1c(%ebp)
80102583:	e8 68 28 00 00       	call   80104df0 <memmove>
    name[len] = 0;
80102588:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010258b:	83 c4 10             	add    $0x10,%esp
8010258e:	c6 00 00             	movb   $0x0,(%eax)
80102591:	e9 69 ff ff ff       	jmp    801024ff <namex+0xaf>
80102596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025a3:	85 c0                	test   %eax,%eax
801025a5:	0f 85 85 00 00 00    	jne    80102630 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801025ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025ae:	89 f0                	mov    %esi,%eax
801025b0:	5b                   	pop    %ebx
801025b1:	5e                   	pop    %esi
801025b2:	5f                   	pop    %edi
801025b3:	5d                   	pop    %ebp
801025b4:	c3                   	ret    
801025b5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025bb:	89 fb                	mov    %edi,%ebx
801025bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801025c0:	31 c0                	xor    %eax,%eax
801025c2:	eb b5                	jmp    80102579 <namex+0x129>
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	56                   	push   %esi
801025cc:	e8 4f f9 ff ff       	call   80101f20 <iunlock>
  iput(ip);
801025d1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801025d4:	31 f6                	xor    %esi,%esi
  iput(ip);
801025d6:	e8 95 f9 ff ff       	call   80101f70 <iput>
      return 0;
801025db:	83 c4 10             	add    $0x10,%esp
}
801025de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025e1:	89 f0                	mov    %esi,%eax
801025e3:	5b                   	pop    %ebx
801025e4:	5e                   	pop    %esi
801025e5:	5f                   	pop    %edi
801025e6:	5d                   	pop    %ebp
801025e7:	c3                   	ret    
801025e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801025f0:	ba 01 00 00 00       	mov    $0x1,%edx
801025f5:	b8 01 00 00 00       	mov    $0x1,%eax
801025fa:	89 df                	mov    %ebx,%edi
801025fc:	e8 1f f4 ff ff       	call   80101a20 <iget>
80102601:	89 c6                	mov    %eax,%esi
80102603:	e9 9b fe ff ff       	jmp    801024a3 <namex+0x53>
80102608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop
      iunlock(ip);
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	56                   	push   %esi
80102614:	e8 07 f9 ff ff       	call   80101f20 <iunlock>
      return ip;
80102619:	83 c4 10             	add    $0x10,%esp
}
8010261c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010261f:	89 f0                	mov    %esi,%eax
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5f                   	pop    %edi
80102624:	5d                   	pop    %ebp
80102625:	c3                   	ret    
80102626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	56                   	push   %esi
    return 0;
80102634:	31 f6                	xor    %esi,%esi
    iput(ip);
80102636:	e8 35 f9 ff ff       	call   80101f70 <iput>
    return 0;
8010263b:	83 c4 10             	add    $0x10,%esp
8010263e:	e9 68 ff ff ff       	jmp    801025ab <namex+0x15b>
80102643:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102650 <dirlink>:
{
80102650:	f3 0f 1e fb          	endbr32 
80102654:	55                   	push   %ebp
80102655:	89 e5                	mov    %esp,%ebp
80102657:	57                   	push   %edi
80102658:	56                   	push   %esi
80102659:	53                   	push   %ebx
8010265a:	83 ec 20             	sub    $0x20,%esp
8010265d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102660:	6a 00                	push   $0x0
80102662:	ff 75 0c             	pushl  0xc(%ebp)
80102665:	53                   	push   %ebx
80102666:	e8 25 fd ff ff       	call   80102390 <dirlookup>
8010266b:	83 c4 10             	add    $0x10,%esp
8010266e:	85 c0                	test   %eax,%eax
80102670:	75 6b                	jne    801026dd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102672:	8b 7b 58             	mov    0x58(%ebx),%edi
80102675:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102678:	85 ff                	test   %edi,%edi
8010267a:	74 2d                	je     801026a9 <dirlink+0x59>
8010267c:	31 ff                	xor    %edi,%edi
8010267e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102681:	eb 0d                	jmp    80102690 <dirlink+0x40>
80102683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102687:	90                   	nop
80102688:	83 c7 10             	add    $0x10,%edi
8010268b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010268e:	73 19                	jae    801026a9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102690:	6a 10                	push   $0x10
80102692:	57                   	push   %edi
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	e8 a6 fa ff ff       	call   80102140 <readi>
8010269a:	83 c4 10             	add    $0x10,%esp
8010269d:	83 f8 10             	cmp    $0x10,%eax
801026a0:	75 4e                	jne    801026f0 <dirlink+0xa0>
    if(de.inum == 0)
801026a2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801026a7:	75 df                	jne    80102688 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801026a9:	83 ec 04             	sub    $0x4,%esp
801026ac:	8d 45 da             	lea    -0x26(%ebp),%eax
801026af:	6a 0e                	push   $0xe
801026b1:	ff 75 0c             	pushl  0xc(%ebp)
801026b4:	50                   	push   %eax
801026b5:	e8 f6 27 00 00       	call   80104eb0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026ba:	6a 10                	push   $0x10
  de.inum = inum;
801026bc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026bf:	57                   	push   %edi
801026c0:	56                   	push   %esi
801026c1:	53                   	push   %ebx
  de.inum = inum;
801026c2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026c6:	e8 75 fb ff ff       	call   80102240 <writei>
801026cb:	83 c4 20             	add    $0x20,%esp
801026ce:	83 f8 10             	cmp    $0x10,%eax
801026d1:	75 2a                	jne    801026fd <dirlink+0xad>
  return 0;
801026d3:	31 c0                	xor    %eax,%eax
}
801026d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026d8:	5b                   	pop    %ebx
801026d9:	5e                   	pop    %esi
801026da:	5f                   	pop    %edi
801026db:	5d                   	pop    %ebp
801026dc:	c3                   	ret    
    iput(ip);
801026dd:	83 ec 0c             	sub    $0xc,%esp
801026e0:	50                   	push   %eax
801026e1:	e8 8a f8 ff ff       	call   80101f70 <iput>
    return -1;
801026e6:	83 c4 10             	add    $0x10,%esp
801026e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026ee:	eb e5                	jmp    801026d5 <dirlink+0x85>
      panic("dirlink read");
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 28 79 10 80       	push   $0x80107928
801026f8:	e8 93 dc ff ff       	call   80100390 <panic>
    panic("dirlink");
801026fd:	83 ec 0c             	sub    $0xc,%esp
80102700:	68 fe 7e 10 80       	push   $0x80107efe
80102705:	e8 86 dc ff ff       	call   80100390 <panic>
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102710 <namei>:

struct inode*
namei(char *path)
{
80102710:	f3 0f 1e fb          	endbr32 
80102714:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102715:	31 d2                	xor    %edx,%edx
{
80102717:	89 e5                	mov    %esp,%ebp
80102719:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010271c:	8b 45 08             	mov    0x8(%ebp),%eax
8010271f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102722:	e8 29 fd ff ff       	call   80102450 <namex>
}
80102727:	c9                   	leave  
80102728:	c3                   	ret    
80102729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102730 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102730:	f3 0f 1e fb          	endbr32 
80102734:	55                   	push   %ebp
  return namex(path, 1, name);
80102735:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010273a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010273c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010273f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102742:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102743:	e9 08 fd ff ff       	jmp    80102450 <namex>
80102748:	66 90                	xchg   %ax,%ax
8010274a:	66 90                	xchg   %ax,%ax
8010274c:	66 90                	xchg   %ax,%ax
8010274e:	66 90                	xchg   %ax,%ax

80102750 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	57                   	push   %edi
80102754:	56                   	push   %esi
80102755:	53                   	push   %ebx
80102756:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102759:	85 c0                	test   %eax,%eax
8010275b:	0f 84 b4 00 00 00    	je     80102815 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102761:	8b 70 08             	mov    0x8(%eax),%esi
80102764:	89 c3                	mov    %eax,%ebx
80102766:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010276c:	0f 87 96 00 00 00    	ja     80102808 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102772:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
80102780:	89 ca                	mov    %ecx,%edx
80102782:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102783:	83 e0 c0             	and    $0xffffffc0,%eax
80102786:	3c 40                	cmp    $0x40,%al
80102788:	75 f6                	jne    80102780 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010278a:	31 ff                	xor    %edi,%edi
8010278c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102791:	89 f8                	mov    %edi,%eax
80102793:	ee                   	out    %al,(%dx)
80102794:	b8 01 00 00 00       	mov    $0x1,%eax
80102799:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010279e:	ee                   	out    %al,(%dx)
8010279f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801027a4:	89 f0                	mov    %esi,%eax
801027a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801027a7:	89 f0                	mov    %esi,%eax
801027a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801027ae:	c1 f8 08             	sar    $0x8,%eax
801027b1:	ee                   	out    %al,(%dx)
801027b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801027b7:	89 f8                	mov    %edi,%eax
801027b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027ba:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801027be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027c3:	c1 e0 04             	shl    $0x4,%eax
801027c6:	83 e0 10             	and    $0x10,%eax
801027c9:	83 c8 e0             	or     $0xffffffe0,%eax
801027cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801027cd:	f6 03 04             	testb  $0x4,(%ebx)
801027d0:	75 16                	jne    801027e8 <idestart+0x98>
801027d2:	b8 20 00 00 00       	mov    $0x20,%eax
801027d7:	89 ca                	mov    %ecx,%edx
801027d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801027da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027dd:	5b                   	pop    %ebx
801027de:	5e                   	pop    %esi
801027df:	5f                   	pop    %edi
801027e0:	5d                   	pop    %ebp
801027e1:	c3                   	ret    
801027e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027e8:	b8 30 00 00 00       	mov    $0x30,%eax
801027ed:	89 ca                	mov    %ecx,%edx
801027ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801027f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801027f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801027f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027fd:	fc                   	cld    
801027fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102800:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102803:	5b                   	pop    %ebx
80102804:	5e                   	pop    %esi
80102805:	5f                   	pop    %edi
80102806:	5d                   	pop    %ebp
80102807:	c3                   	ret    
    panic("incorrect blockno");
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	68 94 79 10 80       	push   $0x80107994
80102810:	e8 7b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102815:	83 ec 0c             	sub    $0xc,%esp
80102818:	68 8b 79 10 80       	push   $0x8010798b
8010281d:	e8 6e db ff ff       	call   80100390 <panic>
80102822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102830 <ideinit>:
{
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010283a:	68 a6 79 10 80       	push   $0x801079a6
8010283f:	68 c0 b5 10 80       	push   $0x8010b5c0
80102844:	e8 77 22 00 00       	call   80104ac0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102849:	58                   	pop    %eax
8010284a:	a1 40 42 11 80       	mov    0x80114240,%eax
8010284f:	5a                   	pop    %edx
80102850:	83 e8 01             	sub    $0x1,%eax
80102853:	50                   	push   %eax
80102854:	6a 0e                	push   $0xe
80102856:	e8 b5 02 00 00       	call   80102b10 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010285b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102867:	90                   	nop
80102868:	ec                   	in     (%dx),%al
80102869:	83 e0 c0             	and    $0xffffffc0,%eax
8010286c:	3c 40                	cmp    $0x40,%al
8010286e:	75 f8                	jne    80102868 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102875:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010287a:	ee                   	out    %al,(%dx)
8010287b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102885:	eb 0e                	jmp    80102895 <ideinit+0x65>
80102887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102890:	83 e9 01             	sub    $0x1,%ecx
80102893:	74 0f                	je     801028a4 <ideinit+0x74>
80102895:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102896:	84 c0                	test   %al,%al
80102898:	74 f6                	je     80102890 <ideinit+0x60>
      havedisk1 = 1;
8010289a:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801028a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801028a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028ae:	ee                   	out    %al,(%dx)
}
801028af:	c9                   	leave  
801028b0:	c3                   	ret    
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
801028c4:	55                   	push   %ebp
801028c5:	89 e5                	mov    %esp,%ebp
801028c7:	57                   	push   %edi
801028c8:	56                   	push   %esi
801028c9:	53                   	push   %ebx
801028ca:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028cd:	68 c0 b5 10 80       	push   $0x8010b5c0
801028d2:	e8 69 23 00 00       	call   80104c40 <acquire>

  if((b = idequeue) == 0){
801028d7:	8b 1d a4 b5 10 80    	mov    0x8010b5a4,%ebx
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	85 db                	test   %ebx,%ebx
801028e2:	74 5f                	je     80102943 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801028e4:	8b 43 58             	mov    0x58(%ebx),%eax
801028e7:	a3 a4 b5 10 80       	mov    %eax,0x8010b5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028ec:	8b 33                	mov    (%ebx),%esi
801028ee:	f7 c6 04 00 00 00    	test   $0x4,%esi
801028f4:	75 2b                	jne    80102921 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop
80102900:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102901:	89 c1                	mov    %eax,%ecx
80102903:	83 e1 c0             	and    $0xffffffc0,%ecx
80102906:	80 f9 40             	cmp    $0x40,%cl
80102909:	75 f5                	jne    80102900 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010290b:	a8 21                	test   $0x21,%al
8010290d:	75 12                	jne    80102921 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010290f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102912:	b9 80 00 00 00       	mov    $0x80,%ecx
80102917:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010291c:	fc                   	cld    
8010291d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010291f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102921:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102924:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102927:	83 ce 02             	or     $0x2,%esi
8010292a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010292c:	53                   	push   %ebx
8010292d:	e8 8e 1e 00 00       	call   801047c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102932:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
80102937:	83 c4 10             	add    $0x10,%esp
8010293a:	85 c0                	test   %eax,%eax
8010293c:	74 05                	je     80102943 <ideintr+0x83>
    idestart(idequeue);
8010293e:	e8 0d fe ff ff       	call   80102750 <idestart>
    release(&idelock);
80102943:	83 ec 0c             	sub    $0xc,%esp
80102946:	68 c0 b5 10 80       	push   $0x8010b5c0
8010294b:	e8 b0 23 00 00       	call   80104d00 <release>

  release(&idelock);
}
80102950:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102960:	f3 0f 1e fb          	endbr32 
80102964:	55                   	push   %ebp
80102965:	89 e5                	mov    %esp,%ebp
80102967:	53                   	push   %ebx
80102968:	83 ec 10             	sub    $0x10,%esp
8010296b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010296e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102971:	50                   	push   %eax
80102972:	e8 e9 20 00 00       	call   80104a60 <holdingsleep>
80102977:	83 c4 10             	add    $0x10,%esp
8010297a:	85 c0                	test   %eax,%eax
8010297c:	0f 84 cf 00 00 00    	je     80102a51 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102982:	8b 03                	mov    (%ebx),%eax
80102984:	83 e0 06             	and    $0x6,%eax
80102987:	83 f8 02             	cmp    $0x2,%eax
8010298a:	0f 84 b4 00 00 00    	je     80102a44 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102990:	8b 53 04             	mov    0x4(%ebx),%edx
80102993:	85 d2                	test   %edx,%edx
80102995:	74 0d                	je     801029a4 <iderw+0x44>
80102997:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010299c:	85 c0                	test   %eax,%eax
8010299e:	0f 84 93 00 00 00    	je     80102a37 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801029a4:	83 ec 0c             	sub    $0xc,%esp
801029a7:	68 c0 b5 10 80       	push   $0x8010b5c0
801029ac:	e8 8f 22 00 00       	call   80104c40 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029b1:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
  b->qnext = 0;
801029b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	85 c0                	test   %eax,%eax
801029c2:	74 6c                	je     80102a30 <iderw+0xd0>
801029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c8:	89 c2                	mov    %eax,%edx
801029ca:	8b 40 58             	mov    0x58(%eax),%eax
801029cd:	85 c0                	test   %eax,%eax
801029cf:	75 f7                	jne    801029c8 <iderw+0x68>
801029d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801029d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801029d6:	39 1d a4 b5 10 80    	cmp    %ebx,0x8010b5a4
801029dc:	74 42                	je     80102a20 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029de:	8b 03                	mov    (%ebx),%eax
801029e0:	83 e0 06             	and    $0x6,%eax
801029e3:	83 f8 02             	cmp    $0x2,%eax
801029e6:	74 23                	je     80102a0b <iderw+0xab>
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop
    sleep(b, &idelock);
801029f0:	83 ec 08             	sub    $0x8,%esp
801029f3:	68 c0 b5 10 80       	push   $0x8010b5c0
801029f8:	53                   	push   %ebx
801029f9:	e8 02 1c 00 00       	call   80104600 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029fe:	8b 03                	mov    (%ebx),%eax
80102a00:	83 c4 10             	add    $0x10,%esp
80102a03:	83 e0 06             	and    $0x6,%eax
80102a06:	83 f8 02             	cmp    $0x2,%eax
80102a09:	75 e5                	jne    801029f0 <iderw+0x90>
  }


  release(&idelock);
80102a0b:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80102a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a15:	c9                   	leave  
  release(&idelock);
80102a16:	e9 e5 22 00 00       	jmp    80104d00 <release>
80102a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a1f:	90                   	nop
    idestart(b);
80102a20:	89 d8                	mov    %ebx,%eax
80102a22:	e8 29 fd ff ff       	call   80102750 <idestart>
80102a27:	eb b5                	jmp    801029de <iderw+0x7e>
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a30:	ba a4 b5 10 80       	mov    $0x8010b5a4,%edx
80102a35:	eb 9d                	jmp    801029d4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 d5 79 10 80       	push   $0x801079d5
80102a3f:	e8 4c d9 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102a44:	83 ec 0c             	sub    $0xc,%esp
80102a47:	68 c0 79 10 80       	push   $0x801079c0
80102a4c:	e8 3f d9 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102a51:	83 ec 0c             	sub    $0xc,%esp
80102a54:	68 aa 79 10 80       	push   $0x801079aa
80102a59:	e8 32 d9 ff ff       	call   80100390 <panic>
80102a5e:	66 90                	xchg   %ax,%ax

80102a60 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a60:	f3 0f 1e fb          	endbr32 
80102a64:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a65:	c7 05 74 3b 11 80 00 	movl   $0xfec00000,0x80113b74
80102a6c:	00 c0 fe 
{
80102a6f:	89 e5                	mov    %esp,%ebp
80102a71:	56                   	push   %esi
80102a72:	53                   	push   %ebx
  ioapic->reg = reg;
80102a73:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a7a:	00 00 00 
  return ioapic->data;
80102a7d:	8b 15 74 3b 11 80    	mov    0x80113b74,%edx
80102a83:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102a86:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102a8c:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a92:	0f b6 15 a0 3c 11 80 	movzbl 0x80113ca0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a99:	c1 ee 10             	shr    $0x10,%esi
80102a9c:	89 f0                	mov    %esi,%eax
80102a9e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102aa1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102aa4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102aa7:	39 c2                	cmp    %eax,%edx
80102aa9:	74 16                	je     80102ac1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102aab:	83 ec 0c             	sub    $0xc,%esp
80102aae:	68 f4 79 10 80       	push   $0x801079f4
80102ab3:	e8 e8 dc ff ff       	call   801007a0 <cprintf>
80102ab8:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102abe:	83 c4 10             	add    $0x10,%esp
80102ac1:	83 c6 21             	add    $0x21,%esi
{
80102ac4:	ba 10 00 00 00       	mov    $0x10,%edx
80102ac9:	b8 20 00 00 00       	mov    $0x20,%eax
80102ace:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102ad0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ad2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102ad4:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102ada:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102add:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102ae3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102ae6:	8d 5a 01             	lea    0x1(%edx),%ebx
80102ae9:	83 c2 02             	add    $0x2,%edx
80102aec:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102aee:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
80102af4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102afb:	39 f0                	cmp    %esi,%eax
80102afd:	75 d1                	jne    80102ad0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b02:	5b                   	pop    %ebx
80102b03:	5e                   	pop    %esi
80102b04:	5d                   	pop    %ebp
80102b05:	c3                   	ret    
80102b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
  ioapic->reg = reg;
80102b15:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
{
80102b1b:	89 e5                	mov    %esp,%ebp
80102b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b20:	8d 50 20             	lea    0x20(%eax),%edx
80102b23:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102b27:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b29:	8b 0d 74 3b 11 80    	mov    0x80113b74,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b2f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b32:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b38:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b3a:	a1 74 3b 11 80       	mov    0x80113b74,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b3f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102b42:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	66 90                	xchg   %ax,%ax
80102b49:	66 90                	xchg   %ax,%ax
80102b4b:	66 90                	xchg   %ax,%ax
80102b4d:	66 90                	xchg   %ax,%ax
80102b4f:	90                   	nop

80102b50 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b50:	f3 0f 1e fb          	endbr32 
80102b54:	55                   	push   %ebp
80102b55:	89 e5                	mov    %esp,%ebp
80102b57:	53                   	push   %ebx
80102b58:	83 ec 04             	sub    $0x4,%esp
80102b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b5e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b64:	75 7a                	jne    80102be0 <kfree+0x90>
80102b66:	81 fb e8 69 11 80    	cmp    $0x801169e8,%ebx
80102b6c:	72 72                	jb     80102be0 <kfree+0x90>
80102b6e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b74:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b79:	77 65                	ja     80102be0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b7b:	83 ec 04             	sub    $0x4,%esp
80102b7e:	68 00 10 00 00       	push   $0x1000
80102b83:	6a 01                	push   $0x1
80102b85:	53                   	push   %ebx
80102b86:	e8 c5 21 00 00       	call   80104d50 <memset>

  if(kmem.use_lock)
80102b8b:	8b 15 b4 3b 11 80    	mov    0x80113bb4,%edx
80102b91:	83 c4 10             	add    $0x10,%esp
80102b94:	85 d2                	test   %edx,%edx
80102b96:	75 20                	jne    80102bb8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b98:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
80102b9d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b9f:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
  kmem.freelist = r;
80102ba4:	89 1d b8 3b 11 80    	mov    %ebx,0x80113bb8
  if(kmem.use_lock)
80102baa:	85 c0                	test   %eax,%eax
80102bac:	75 22                	jne    80102bd0 <kfree+0x80>
    release(&kmem.lock);
}
80102bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb1:	c9                   	leave  
80102bb2:	c3                   	ret    
80102bb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bb7:	90                   	nop
    acquire(&kmem.lock);
80102bb8:	83 ec 0c             	sub    $0xc,%esp
80102bbb:	68 80 3b 11 80       	push   $0x80113b80
80102bc0:	e8 7b 20 00 00       	call   80104c40 <acquire>
80102bc5:	83 c4 10             	add    $0x10,%esp
80102bc8:	eb ce                	jmp    80102b98 <kfree+0x48>
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102bd0:	c7 45 08 80 3b 11 80 	movl   $0x80113b80,0x8(%ebp)
}
80102bd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bda:	c9                   	leave  
    release(&kmem.lock);
80102bdb:	e9 20 21 00 00       	jmp    80104d00 <release>
    panic("kfree");
80102be0:	83 ec 0c             	sub    $0xc,%esp
80102be3:	68 26 7a 10 80       	push   $0x80107a26
80102be8:	e8 a3 d7 ff ff       	call   80100390 <panic>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi

80102bf0 <freerange>:
{
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bf8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bfb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102bfe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c11:	39 de                	cmp    %ebx,%esi
80102c13:	72 1f                	jb     80102c34 <freerange+0x44>
80102c15:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c18:	83 ec 0c             	sub    $0xc,%esp
80102c1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c27:	50                   	push   %eax
80102c28:	e8 23 ff ff ff       	call   80102b50 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c2d:	83 c4 10             	add    $0x10,%esp
80102c30:	39 f3                	cmp    %esi,%ebx
80102c32:	76 e4                	jbe    80102c18 <freerange+0x28>
}
80102c34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c37:	5b                   	pop    %ebx
80102c38:	5e                   	pop    %esi
80102c39:	5d                   	pop    %ebp
80102c3a:	c3                   	ret    
80102c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c3f:	90                   	nop

80102c40 <kinit1>:
{
80102c40:	f3 0f 1e fb          	endbr32 
80102c44:	55                   	push   %ebp
80102c45:	89 e5                	mov    %esp,%ebp
80102c47:	56                   	push   %esi
80102c48:	53                   	push   %ebx
80102c49:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c4c:	83 ec 08             	sub    $0x8,%esp
80102c4f:	68 2c 7a 10 80       	push   $0x80107a2c
80102c54:	68 80 3b 11 80       	push   $0x80113b80
80102c59:	e8 62 1e 00 00       	call   80104ac0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c61:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c64:	c7 05 b4 3b 11 80 00 	movl   $0x0,0x80113bb4
80102c6b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c6e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c74:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c80:	39 de                	cmp    %ebx,%esi
80102c82:	72 20                	jb     80102ca4 <kinit1+0x64>
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c97:	50                   	push   %eax
80102c98:	e8 b3 fe ff ff       	call   80102b50 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	39 de                	cmp    %ebx,%esi
80102ca2:	73 e4                	jae    80102c88 <kinit1+0x48>
}
80102ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ca7:	5b                   	pop    %ebx
80102ca8:	5e                   	pop    %esi
80102ca9:	5d                   	pop    %ebp
80102caa:	c3                   	ret    
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop

80102cb0 <kinit2>:
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102cb8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102cbe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102cbf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cc5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ccb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cd1:	39 de                	cmp    %ebx,%esi
80102cd3:	72 1f                	jb     80102cf4 <kinit2+0x44>
80102cd5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102cd8:	83 ec 0c             	sub    $0xc,%esp
80102cdb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ce1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ce7:	50                   	push   %eax
80102ce8:	e8 63 fe ff ff       	call   80102b50 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ced:	83 c4 10             	add    $0x10,%esp
80102cf0:	39 de                	cmp    %ebx,%esi
80102cf2:	73 e4                	jae    80102cd8 <kinit2+0x28>
  kmem.use_lock = 1;
80102cf4:	c7 05 b4 3b 11 80 01 	movl   $0x1,0x80113bb4
80102cfb:	00 00 00 
}
80102cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d01:	5b                   	pop    %ebx
80102d02:	5e                   	pop    %esi
80102d03:	5d                   	pop    %ebp
80102d04:	c3                   	ret    
80102d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d10 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d10:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102d14:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	75 1b                	jne    80102d38 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d1d:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
  if(r)
80102d22:	85 c0                	test   %eax,%eax
80102d24:	74 0a                	je     80102d30 <kalloc+0x20>
    kmem.freelist = r->next;
80102d26:	8b 10                	mov    (%eax),%edx
80102d28:	89 15 b8 3b 11 80    	mov    %edx,0x80113bb8
  if(kmem.use_lock)
80102d2e:	c3                   	ret    
80102d2f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102d38:	55                   	push   %ebp
80102d39:	89 e5                	mov    %esp,%ebp
80102d3b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d3e:	68 80 3b 11 80       	push   $0x80113b80
80102d43:	e8 f8 1e 00 00       	call   80104c40 <acquire>
  r = kmem.freelist;
80102d48:	a1 b8 3b 11 80       	mov    0x80113bb8,%eax
  if(r)
80102d4d:	8b 15 b4 3b 11 80    	mov    0x80113bb4,%edx
80102d53:	83 c4 10             	add    $0x10,%esp
80102d56:	85 c0                	test   %eax,%eax
80102d58:	74 08                	je     80102d62 <kalloc+0x52>
    kmem.freelist = r->next;
80102d5a:	8b 08                	mov    (%eax),%ecx
80102d5c:	89 0d b8 3b 11 80    	mov    %ecx,0x80113bb8
  if(kmem.use_lock)
80102d62:	85 d2                	test   %edx,%edx
80102d64:	74 16                	je     80102d7c <kalloc+0x6c>
    release(&kmem.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d6c:	68 80 3b 11 80       	push   $0x80113b80
80102d71:	e8 8a 1f 00 00       	call   80104d00 <release>
  return (char*)r;
80102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d79:	83 c4 10             	add    $0x10,%esp
}
80102d7c:	c9                   	leave  
80102d7d:	c3                   	ret    
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d84:	ba 64 00 00 00       	mov    $0x64,%edx
80102d89:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d8a:	a8 01                	test   $0x1,%al
80102d8c:	0f 84 be 00 00 00    	je     80102e50 <kbdgetc+0xd0>
{
80102d92:	55                   	push   %ebp
80102d93:	ba 60 00 00 00       	mov    $0x60,%edx
80102d98:	89 e5                	mov    %esp,%ebp
80102d9a:	53                   	push   %ebx
80102d9b:	ec                   	in     (%dx),%al
  return data;
80102d9c:	8b 1d f4 b5 10 80    	mov    0x8010b5f4,%ebx
    return -1;
  data = inb(KBDATAP);
80102da2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102da5:	3c e0                	cmp    $0xe0,%al
80102da7:	74 57                	je     80102e00 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102da9:	89 d9                	mov    %ebx,%ecx
80102dab:	83 e1 40             	and    $0x40,%ecx
80102dae:	84 c0                	test   %al,%al
80102db0:	78 5e                	js     80102e10 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102db2:	85 c9                	test   %ecx,%ecx
80102db4:	74 09                	je     80102dbf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102db6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102db9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102dbc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102dbf:	0f b6 8a 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%ecx
  shift ^= togglecode[data];
80102dc6:	0f b6 82 60 7a 10 80 	movzbl -0x7fef85a0(%edx),%eax
  shift |= shiftcode[data];
80102dcd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102dcf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102dd1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102dd3:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
  c = charcode[shift & (CTL | SHIFT)][data];
80102dd9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ddc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ddf:	8b 04 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%eax
80102de6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102dea:	74 0b                	je     80102df7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102dec:	8d 50 9f             	lea    -0x61(%eax),%edx
80102def:	83 fa 19             	cmp    $0x19,%edx
80102df2:	77 44                	ja     80102e38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102df4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102df7:	5b                   	pop    %ebx
80102df8:	5d                   	pop    %ebp
80102df9:	c3                   	ret    
80102dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102e00:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102e03:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e05:	89 1d f4 b5 10 80    	mov    %ebx,0x8010b5f4
}
80102e0b:	5b                   	pop    %ebx
80102e0c:	5d                   	pop    %ebp
80102e0d:	c3                   	ret    
80102e0e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e10:	83 e0 7f             	and    $0x7f,%eax
80102e13:	85 c9                	test   %ecx,%ecx
80102e15:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102e18:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e1a:	0f b6 8a 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%ecx
80102e21:	83 c9 40             	or     $0x40,%ecx
80102e24:	0f b6 c9             	movzbl %cl,%ecx
80102e27:	f7 d1                	not    %ecx
80102e29:	21 d9                	and    %ebx,%ecx
}
80102e2b:	5b                   	pop    %ebx
80102e2c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102e2d:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
}
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e3e:	5b                   	pop    %ebx
80102e3f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102e40:	83 f9 1a             	cmp    $0x1a,%ecx
80102e43:	0f 42 c2             	cmovb  %edx,%eax
}
80102e46:	c3                   	ret    
80102e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4e:	66 90                	xchg   %ax,%ax
    return -1;
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e55:	c3                   	ret    
80102e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi

80102e60 <kbdintr>:

void
kbdintr(void)
{
80102e60:	f3 0f 1e fb          	endbr32 
80102e64:	55                   	push   %ebp
80102e65:	89 e5                	mov    %esp,%ebp
80102e67:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e6a:	68 80 2d 10 80       	push   $0x80102d80
80102e6f:	e8 8c dd ff ff       	call   80100c00 <consoleintr>
}
80102e74:	83 c4 10             	add    $0x10,%esp
80102e77:	c9                   	leave  
80102e78:	c3                   	ret    
80102e79:	66 90                	xchg   %ax,%ax
80102e7b:	66 90                	xchg   %ax,%ax
80102e7d:	66 90                	xchg   %ax,%ax
80102e7f:	90                   	nop

80102e80 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102e80:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102e84:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102e89:	85 c0                	test   %eax,%eax
80102e8b:	0f 84 c7 00 00 00    	je     80102f58 <lapicinit+0xd8>
  lapic[index] = value;
80102e91:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e98:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e9e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ea5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eab:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102eb2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eb8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ebf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ecc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ecf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ed9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102edc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102edf:	8b 50 30             	mov    0x30(%eax),%edx
80102ee2:	c1 ea 10             	shr    $0x10,%edx
80102ee5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102eeb:	75 73                	jne    80102f60 <lapicinit+0xe0>
  lapic[index] = value;
80102eed:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ef4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102efa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f01:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f07:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f0e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f14:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f1b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f21:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f28:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f2e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f35:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f38:	8b 50 20             	mov    0x20(%eax),%edx
80102f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f46:	80 e6 10             	and    $0x10,%dh
80102f49:	75 f5                	jne    80102f40 <lapicinit+0xc0>
  lapic[index] = value;
80102f4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f58:	c3                   	ret    
80102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102f60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102f6d:	e9 7b ff ff ff       	jmp    80102eed <lapicinit+0x6d>
80102f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f80 <lapicid>:

int
lapicid(void)
{
80102f80:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102f84:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102f89:	85 c0                	test   %eax,%eax
80102f8b:	74 0b                	je     80102f98 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102f8d:	8b 40 20             	mov    0x20(%eax),%eax
80102f90:	c1 e8 18             	shr    $0x18,%eax
80102f93:	c3                   	ret    
80102f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102f98:	31 c0                	xor    %eax,%eax
}
80102f9a:	c3                   	ret    
80102f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fa0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102fa4:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80102fa9:	85 c0                	test   %eax,%eax
80102fab:	74 0d                	je     80102fba <lapiceoi+0x1a>
  lapic[index] = value;
80102fad:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102fba:	c3                   	ret    
80102fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop

80102fc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fc0:	f3 0f 1e fb          	endbr32 
}
80102fc4:	c3                   	ret    
80102fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fd0:	f3 0f 1e fb          	endbr32 
80102fd4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102fda:	ba 70 00 00 00       	mov    $0x70,%edx
80102fdf:	89 e5                	mov    %esp,%ebp
80102fe1:	53                   	push   %ebx
80102fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102fe5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fe8:	ee                   	out    %al,(%dx)
80102fe9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fee:	ba 71 00 00 00       	mov    $0x71,%edx
80102ff3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ff4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ff6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ff9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102fff:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103001:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103004:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103006:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103009:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010300c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103012:	a1 bc 3b 11 80       	mov    0x80113bbc,%eax
80103017:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010301d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103020:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103027:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010302a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010302d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103034:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103037:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010303a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103040:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103043:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103049:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010304c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103052:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103055:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010305b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010305c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010305f:	5d                   	pop    %ebp
80103060:	c3                   	ret    
80103061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop

80103070 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
80103075:	b8 0b 00 00 00       	mov    $0xb,%eax
8010307a:	ba 70 00 00 00       	mov    $0x70,%edx
8010307f:	89 e5                	mov    %esp,%ebp
80103081:	57                   	push   %edi
80103082:	56                   	push   %esi
80103083:	53                   	push   %ebx
80103084:	83 ec 4c             	sub    $0x4c,%esp
80103087:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103088:	ba 71 00 00 00       	mov    $0x71,%edx
8010308d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010308e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103091:	bb 70 00 00 00       	mov    $0x70,%ebx
80103096:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030a0:	31 c0                	xor    %eax,%eax
801030a2:	89 da                	mov    %ebx,%edx
801030a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a5:	b9 71 00 00 00       	mov    $0x71,%ecx
801030aa:	89 ca                	mov    %ecx,%edx
801030ac:	ec                   	in     (%dx),%al
801030ad:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b0:	89 da                	mov    %ebx,%edx
801030b2:	b8 02 00 00 00       	mov    $0x2,%eax
801030b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b8:	89 ca                	mov    %ecx,%edx
801030ba:	ec                   	in     (%dx),%al
801030bb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030be:	89 da                	mov    %ebx,%edx
801030c0:	b8 04 00 00 00       	mov    $0x4,%eax
801030c5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c6:	89 ca                	mov    %ecx,%edx
801030c8:	ec                   	in     (%dx),%al
801030c9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cc:	89 da                	mov    %ebx,%edx
801030ce:	b8 07 00 00 00       	mov    $0x7,%eax
801030d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d4:	89 ca                	mov    %ecx,%edx
801030d6:	ec                   	in     (%dx),%al
801030d7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030da:	89 da                	mov    %ebx,%edx
801030dc:	b8 08 00 00 00       	mov    $0x8,%eax
801030e1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e2:	89 ca                	mov    %ecx,%edx
801030e4:	ec                   	in     (%dx),%al
801030e5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e7:	89 da                	mov    %ebx,%edx
801030e9:	b8 09 00 00 00       	mov    $0x9,%eax
801030ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ef:	89 ca                	mov    %ecx,%edx
801030f1:	ec                   	in     (%dx),%al
801030f2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f4:	89 da                	mov    %ebx,%edx
801030f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801030fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030fc:	89 ca                	mov    %ecx,%edx
801030fe:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030ff:	84 c0                	test   %al,%al
80103101:	78 9d                	js     801030a0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103103:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103107:	89 fa                	mov    %edi,%edx
80103109:	0f b6 fa             	movzbl %dl,%edi
8010310c:	89 f2                	mov    %esi,%edx
8010310e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103111:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103115:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103118:	89 da                	mov    %ebx,%edx
8010311a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010311d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103120:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103124:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103127:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010312a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010312e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103131:	31 c0                	xor    %eax,%eax
80103133:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103134:	89 ca                	mov    %ecx,%edx
80103136:	ec                   	in     (%dx),%al
80103137:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010313a:	89 da                	mov    %ebx,%edx
8010313c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010313f:	b8 02 00 00 00       	mov    $0x2,%eax
80103144:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103145:	89 ca                	mov    %ecx,%edx
80103147:	ec                   	in     (%dx),%al
80103148:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010314b:	89 da                	mov    %ebx,%edx
8010314d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103150:	b8 04 00 00 00       	mov    $0x4,%eax
80103155:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103156:	89 ca                	mov    %ecx,%edx
80103158:	ec                   	in     (%dx),%al
80103159:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010315c:	89 da                	mov    %ebx,%edx
8010315e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103161:	b8 07 00 00 00       	mov    $0x7,%eax
80103166:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103167:	89 ca                	mov    %ecx,%edx
80103169:	ec                   	in     (%dx),%al
8010316a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010316d:	89 da                	mov    %ebx,%edx
8010316f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103172:	b8 08 00 00 00       	mov    $0x8,%eax
80103177:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103178:	89 ca                	mov    %ecx,%edx
8010317a:	ec                   	in     (%dx),%al
8010317b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317e:	89 da                	mov    %ebx,%edx
80103180:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103183:	b8 09 00 00 00       	mov    $0x9,%eax
80103188:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103189:	89 ca                	mov    %ecx,%edx
8010318b:	ec                   	in     (%dx),%al
8010318c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010318f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103195:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103198:	6a 18                	push   $0x18
8010319a:	50                   	push   %eax
8010319b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010319e:	50                   	push   %eax
8010319f:	e8 fc 1b 00 00       	call   80104da0 <memcmp>
801031a4:	83 c4 10             	add    $0x10,%esp
801031a7:	85 c0                	test   %eax,%eax
801031a9:	0f 85 f1 fe ff ff    	jne    801030a0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801031af:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801031b3:	75 78                	jne    8010322d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031b8:	89 c2                	mov    %eax,%edx
801031ba:	83 e0 0f             	and    $0xf,%eax
801031bd:	c1 ea 04             	shr    $0x4,%edx
801031c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031c9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031cc:	89 c2                	mov    %eax,%edx
801031ce:	83 e0 0f             	and    $0xf,%eax
801031d1:	c1 ea 04             	shr    $0x4,%edx
801031d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031da:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031e0:	89 c2                	mov    %eax,%edx
801031e2:	83 e0 0f             	and    $0xf,%eax
801031e5:	c1 ea 04             	shr    $0x4,%edx
801031e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031f4:	89 c2                	mov    %eax,%edx
801031f6:	83 e0 0f             	and    $0xf,%eax
801031f9:	c1 ea 04             	shr    $0x4,%edx
801031fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103202:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103205:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103208:	89 c2                	mov    %eax,%edx
8010320a:	83 e0 0f             	and    $0xf,%eax
8010320d:	c1 ea 04             	shr    $0x4,%edx
80103210:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103213:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103216:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103219:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010321c:	89 c2                	mov    %eax,%edx
8010321e:	83 e0 0f             	and    $0xf,%eax
80103221:	c1 ea 04             	shr    $0x4,%edx
80103224:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103227:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010322a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010322d:	8b 75 08             	mov    0x8(%ebp),%esi
80103230:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103233:	89 06                	mov    %eax,(%esi)
80103235:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103238:	89 46 04             	mov    %eax,0x4(%esi)
8010323b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010323e:	89 46 08             	mov    %eax,0x8(%esi)
80103241:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103244:	89 46 0c             	mov    %eax,0xc(%esi)
80103247:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010324a:	89 46 10             	mov    %eax,0x10(%esi)
8010324d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103250:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103253:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010325a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	66 90                	xchg   %ax,%ax
80103264:	66 90                	xchg   %ax,%ax
80103266:	66 90                	xchg   %ax,%ax
80103268:	66 90                	xchg   %ax,%ax
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103270:	8b 0d 08 3c 11 80    	mov    0x80113c08,%ecx
80103276:	85 c9                	test   %ecx,%ecx
80103278:	0f 8e 8a 00 00 00    	jle    80103308 <install_trans+0x98>
{
8010327e:	55                   	push   %ebp
8010327f:	89 e5                	mov    %esp,%ebp
80103281:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103282:	31 ff                	xor    %edi,%edi
{
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103290:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80103295:	83 ec 08             	sub    $0x8,%esp
80103298:	01 f8                	add    %edi,%eax
8010329a:	83 c0 01             	add    $0x1,%eax
8010329d:	50                   	push   %eax
8010329e:	ff 35 04 3c 11 80    	pushl  0x80113c04
801032a4:	e8 27 ce ff ff       	call   801000d0 <bread>
801032a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ab:	58                   	pop    %eax
801032ac:	5a                   	pop    %edx
801032ad:	ff 34 bd 0c 3c 11 80 	pushl  -0x7feec3f4(,%edi,4)
801032b4:	ff 35 04 3c 11 80    	pushl  0x80113c04
  for (tail = 0; tail < log.lh.n; tail++) {
801032ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032bd:	e8 0e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801032ca:	68 00 02 00 00       	push   $0x200
801032cf:	50                   	push   %eax
801032d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801032d3:	50                   	push   %eax
801032d4:	e8 17 1b 00 00       	call   80104df0 <memmove>
    bwrite(dbuf);  // write dst to disk
801032d9:	89 1c 24             	mov    %ebx,(%esp)
801032dc:	e8 cf ce ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801032e1:	89 34 24             	mov    %esi,(%esp)
801032e4:	e8 07 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801032e9:	89 1c 24             	mov    %ebx,(%esp)
801032ec:	e8 ff ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032f1:	83 c4 10             	add    $0x10,%esp
801032f4:	39 3d 08 3c 11 80    	cmp    %edi,0x80113c08
801032fa:	7f 94                	jg     80103290 <install_trans+0x20>
  }
}
801032fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ff:	5b                   	pop    %ebx
80103300:	5e                   	pop    %esi
80103301:	5f                   	pop    %edi
80103302:	5d                   	pop    %ebp
80103303:	c3                   	ret    
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103308:	c3                   	ret    
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103310 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	53                   	push   %ebx
80103314:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103317:	ff 35 f4 3b 11 80    	pushl  0x80113bf4
8010331d:	ff 35 04 3c 11 80    	pushl  0x80113c04
80103323:	e8 a8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103328:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010332b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010332d:	a1 08 3c 11 80       	mov    0x80113c08,%eax
80103332:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103335:	85 c0                	test   %eax,%eax
80103337:	7e 19                	jle    80103352 <write_head+0x42>
80103339:	31 d2                	xor    %edx,%edx
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103340:	8b 0c 95 0c 3c 11 80 	mov    -0x7feec3f4(,%edx,4),%ecx
80103347:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010334b:	83 c2 01             	add    $0x1,%edx
8010334e:	39 d0                	cmp    %edx,%eax
80103350:	75 ee                	jne    80103340 <write_head+0x30>
  }
  bwrite(buf);
80103352:	83 ec 0c             	sub    $0xc,%esp
80103355:	53                   	push   %ebx
80103356:	e8 55 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010335b:	89 1c 24             	mov    %ebx,(%esp)
8010335e:	e8 8d ce ff ff       	call   801001f0 <brelse>
}
80103363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103366:	83 c4 10             	add    $0x10,%esp
80103369:	c9                   	leave  
8010336a:	c3                   	ret    
8010336b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop

80103370 <initlog>:
{
80103370:	f3 0f 1e fb          	endbr32 
80103374:	55                   	push   %ebp
80103375:	89 e5                	mov    %esp,%ebp
80103377:	53                   	push   %ebx
80103378:	83 ec 2c             	sub    $0x2c,%esp
8010337b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010337e:	68 60 7c 10 80       	push   $0x80107c60
80103383:	68 c0 3b 11 80       	push   $0x80113bc0
80103388:	e8 33 17 00 00       	call   80104ac0 <initlock>
  readsb(dev, &sb);
8010338d:	58                   	pop    %eax
8010338e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103391:	5a                   	pop    %edx
80103392:	50                   	push   %eax
80103393:	53                   	push   %ebx
80103394:	e8 47 e8 ff ff       	call   80101be0 <readsb>
  log.start = sb.logstart;
80103399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010339c:	59                   	pop    %ecx
  log.dev = dev;
8010339d:	89 1d 04 3c 11 80    	mov    %ebx,0x80113c04
  log.size = sb.nlog;
801033a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801033a6:	a3 f4 3b 11 80       	mov    %eax,0x80113bf4
  log.size = sb.nlog;
801033ab:	89 15 f8 3b 11 80    	mov    %edx,0x80113bf8
  struct buf *buf = bread(log.dev, log.start);
801033b1:	5a                   	pop    %edx
801033b2:	50                   	push   %eax
801033b3:	53                   	push   %ebx
801033b4:	e8 17 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801033b9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801033bc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801033bf:	89 0d 08 3c 11 80    	mov    %ecx,0x80113c08
  for (i = 0; i < log.lh.n; i++) {
801033c5:	85 c9                	test   %ecx,%ecx
801033c7:	7e 19                	jle    801033e2 <initlog+0x72>
801033c9:	31 d2                	xor    %edx,%edx
801033cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801033d0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801033d4:	89 1c 95 0c 3c 11 80 	mov    %ebx,-0x7feec3f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033db:	83 c2 01             	add    $0x1,%edx
801033de:	39 d1                	cmp    %edx,%ecx
801033e0:	75 ee                	jne    801033d0 <initlog+0x60>
  brelse(buf);
801033e2:	83 ec 0c             	sub    $0xc,%esp
801033e5:	50                   	push   %eax
801033e6:	e8 05 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033eb:	e8 80 fe ff ff       	call   80103270 <install_trans>
  log.lh.n = 0;
801033f0:	c7 05 08 3c 11 80 00 	movl   $0x0,0x80113c08
801033f7:	00 00 00 
  write_head(); // clear the log
801033fa:	e8 11 ff ff ff       	call   80103310 <write_head>
}
801033ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103402:	83 c4 10             	add    $0x10,%esp
80103405:	c9                   	leave  
80103406:	c3                   	ret    
80103407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340e:	66 90                	xchg   %ax,%ax

80103410 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010341a:	68 c0 3b 11 80       	push   $0x80113bc0
8010341f:	e8 1c 18 00 00       	call   80104c40 <acquire>
80103424:	83 c4 10             	add    $0x10,%esp
80103427:	eb 1c                	jmp    80103445 <begin_op+0x35>
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103430:	83 ec 08             	sub    $0x8,%esp
80103433:	68 c0 3b 11 80       	push   $0x80113bc0
80103438:	68 c0 3b 11 80       	push   $0x80113bc0
8010343d:	e8 be 11 00 00       	call   80104600 <sleep>
80103442:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103445:	a1 00 3c 11 80       	mov    0x80113c00,%eax
8010344a:	85 c0                	test   %eax,%eax
8010344c:	75 e2                	jne    80103430 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010344e:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80103453:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
80103459:	83 c0 01             	add    $0x1,%eax
8010345c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010345f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103462:	83 fa 1e             	cmp    $0x1e,%edx
80103465:	7f c9                	jg     80103430 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103467:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010346a:	a3 fc 3b 11 80       	mov    %eax,0x80113bfc
      release(&log.lock);
8010346f:	68 c0 3b 11 80       	push   $0x80113bc0
80103474:	e8 87 18 00 00       	call   80104d00 <release>
      break;
    }
  }
}
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	c9                   	leave  
8010347d:	c3                   	ret    
8010347e:	66 90                	xchg   %ax,%ax

80103480 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103480:	f3 0f 1e fb          	endbr32 
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	57                   	push   %edi
80103488:	56                   	push   %esi
80103489:	53                   	push   %ebx
8010348a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010348d:	68 c0 3b 11 80       	push   $0x80113bc0
80103492:	e8 a9 17 00 00       	call   80104c40 <acquire>
  log.outstanding -= 1;
80103497:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
  if(log.committing)
8010349c:	8b 35 00 3c 11 80    	mov    0x80113c00,%esi
801034a2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801034a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801034a8:	89 1d fc 3b 11 80    	mov    %ebx,0x80113bfc
  if(log.committing)
801034ae:	85 f6                	test   %esi,%esi
801034b0:	0f 85 1e 01 00 00    	jne    801035d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801034b6:	85 db                	test   %ebx,%ebx
801034b8:	0f 85 f2 00 00 00    	jne    801035b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801034be:	c7 05 00 3c 11 80 01 	movl   $0x1,0x80113c00
801034c5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034c8:	83 ec 0c             	sub    $0xc,%esp
801034cb:	68 c0 3b 11 80       	push   $0x80113bc0
801034d0:	e8 2b 18 00 00       	call   80104d00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034d5:	8b 0d 08 3c 11 80    	mov    0x80113c08,%ecx
801034db:	83 c4 10             	add    $0x10,%esp
801034de:	85 c9                	test   %ecx,%ecx
801034e0:	7f 3e                	jg     80103520 <end_op+0xa0>
    acquire(&log.lock);
801034e2:	83 ec 0c             	sub    $0xc,%esp
801034e5:	68 c0 3b 11 80       	push   $0x80113bc0
801034ea:	e8 51 17 00 00       	call   80104c40 <acquire>
    wakeup(&log);
801034ef:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
    log.committing = 0;
801034f6:	c7 05 00 3c 11 80 00 	movl   $0x0,0x80113c00
801034fd:	00 00 00 
    wakeup(&log);
80103500:	e8 bb 12 00 00       	call   801047c0 <wakeup>
    release(&log.lock);
80103505:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
8010350c:	e8 ef 17 00 00       	call   80104d00 <release>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103517:	5b                   	pop    %ebx
80103518:	5e                   	pop    %esi
80103519:	5f                   	pop    %edi
8010351a:	5d                   	pop    %ebp
8010351b:	c3                   	ret    
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103520:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80103525:	83 ec 08             	sub    $0x8,%esp
80103528:	01 d8                	add    %ebx,%eax
8010352a:	83 c0 01             	add    $0x1,%eax
8010352d:	50                   	push   %eax
8010352e:	ff 35 04 3c 11 80    	pushl  0x80113c04
80103534:	e8 97 cb ff ff       	call   801000d0 <bread>
80103539:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010353b:	58                   	pop    %eax
8010353c:	5a                   	pop    %edx
8010353d:	ff 34 9d 0c 3c 11 80 	pushl  -0x7feec3f4(,%ebx,4)
80103544:	ff 35 04 3c 11 80    	pushl  0x80113c04
  for (tail = 0; tail < log.lh.n; tail++) {
8010354a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010354d:	e8 7e cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103552:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103555:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103557:	8d 40 5c             	lea    0x5c(%eax),%eax
8010355a:	68 00 02 00 00       	push   $0x200
8010355f:	50                   	push   %eax
80103560:	8d 46 5c             	lea    0x5c(%esi),%eax
80103563:	50                   	push   %eax
80103564:	e8 87 18 00 00       	call   80104df0 <memmove>
    bwrite(to);  // write the log
80103569:	89 34 24             	mov    %esi,(%esp)
8010356c:	e8 3f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103571:	89 3c 24             	mov    %edi,(%esp)
80103574:	e8 77 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103579:	89 34 24             	mov    %esi,(%esp)
8010357c:	e8 6f cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103581:	83 c4 10             	add    $0x10,%esp
80103584:	3b 1d 08 3c 11 80    	cmp    0x80113c08,%ebx
8010358a:	7c 94                	jl     80103520 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010358c:	e8 7f fd ff ff       	call   80103310 <write_head>
    install_trans(); // Now install writes to home locations
80103591:	e8 da fc ff ff       	call   80103270 <install_trans>
    log.lh.n = 0;
80103596:	c7 05 08 3c 11 80 00 	movl   $0x0,0x80113c08
8010359d:	00 00 00 
    write_head();    // Erase the transaction from the log
801035a0:	e8 6b fd ff ff       	call   80103310 <write_head>
801035a5:	e9 38 ff ff ff       	jmp    801034e2 <end_op+0x62>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	68 c0 3b 11 80       	push   $0x80113bc0
801035b8:	e8 03 12 00 00       	call   801047c0 <wakeup>
  release(&log.lock);
801035bd:	c7 04 24 c0 3b 11 80 	movl   $0x80113bc0,(%esp)
801035c4:	e8 37 17 00 00       	call   80104d00 <release>
801035c9:	83 c4 10             	add    $0x10,%esp
}
801035cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035cf:	5b                   	pop    %ebx
801035d0:	5e                   	pop    %esi
801035d1:	5f                   	pop    %edi
801035d2:	5d                   	pop    %ebp
801035d3:	c3                   	ret    
    panic("log.committing");
801035d4:	83 ec 0c             	sub    $0xc,%esp
801035d7:	68 64 7c 10 80       	push   $0x80107c64
801035dc:	e8 af cd ff ff       	call   80100390 <panic>
801035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ef:	90                   	nop

801035f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	53                   	push   %ebx
801035f8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035fb:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
{
80103601:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103604:	83 fa 1d             	cmp    $0x1d,%edx
80103607:	0f 8f 91 00 00 00    	jg     8010369e <log_write+0xae>
8010360d:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
80103612:	83 e8 01             	sub    $0x1,%eax
80103615:	39 c2                	cmp    %eax,%edx
80103617:	0f 8d 81 00 00 00    	jge    8010369e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010361d:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	0f 8e 81 00 00 00    	jle    801036ab <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010362a:	83 ec 0c             	sub    $0xc,%esp
8010362d:	68 c0 3b 11 80       	push   $0x80113bc0
80103632:	e8 09 16 00 00       	call   80104c40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103637:	8b 15 08 3c 11 80    	mov    0x80113c08,%edx
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	85 d2                	test   %edx,%edx
80103642:	7e 4e                	jle    80103692 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103644:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103647:	31 c0                	xor    %eax,%eax
80103649:	eb 0c                	jmp    80103657 <log_write+0x67>
8010364b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop
80103650:	83 c0 01             	add    $0x1,%eax
80103653:	39 c2                	cmp    %eax,%edx
80103655:	74 29                	je     80103680 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103657:	39 0c 85 0c 3c 11 80 	cmp    %ecx,-0x7feec3f4(,%eax,4)
8010365e:	75 f0                	jne    80103650 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103660:	89 0c 85 0c 3c 11 80 	mov    %ecx,-0x7feec3f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103667:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010366a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010366d:	c7 45 08 c0 3b 11 80 	movl   $0x80113bc0,0x8(%ebp)
}
80103674:	c9                   	leave  
  release(&log.lock);
80103675:	e9 86 16 00 00       	jmp    80104d00 <release>
8010367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103680:	89 0c 95 0c 3c 11 80 	mov    %ecx,-0x7feec3f4(,%edx,4)
    log.lh.n++;
80103687:	83 c2 01             	add    $0x1,%edx
8010368a:	89 15 08 3c 11 80    	mov    %edx,0x80113c08
80103690:	eb d5                	jmp    80103667 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103692:	8b 43 08             	mov    0x8(%ebx),%eax
80103695:	a3 0c 3c 11 80       	mov    %eax,0x80113c0c
  if (i == log.lh.n)
8010369a:	75 cb                	jne    80103667 <log_write+0x77>
8010369c:	eb e9                	jmp    80103687 <log_write+0x97>
    panic("too big a transaction");
8010369e:	83 ec 0c             	sub    $0xc,%esp
801036a1:	68 73 7c 10 80       	push   $0x80107c73
801036a6:	e8 e5 cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	68 89 7c 10 80       	push   $0x80107c89
801036b3:	e8 d8 cc ff ff       	call   80100390 <panic>
801036b8:	66 90                	xchg   %ax,%ax
801036ba:	66 90                	xchg   %ax,%ax
801036bc:	66 90                	xchg   %ax,%ax
801036be:	66 90                	xchg   %ax,%ax

801036c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801036c7:	e8 54 09 00 00       	call   80104020 <cpuid>
801036cc:	89 c3                	mov    %eax,%ebx
801036ce:	e8 4d 09 00 00       	call   80104020 <cpuid>
801036d3:	83 ec 04             	sub    $0x4,%esp
801036d6:	53                   	push   %ebx
801036d7:	50                   	push   %eax
801036d8:	68 a4 7c 10 80       	push   $0x80107ca4
801036dd:	e8 be d0 ff ff       	call   801007a0 <cprintf>
  idtinit();       // load idt register
801036e2:	e8 19 29 00 00       	call   80106000 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036e7:	e8 c4 08 00 00       	call   80103fb0 <mycpu>
801036ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036ee:	b8 01 00 00 00       	mov    $0x1,%eax
801036f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036fa:	e8 11 0c 00 00       	call   80104310 <scheduler>
801036ff:	90                   	nop

80103700 <mpenter>:
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
80103705:	89 e5                	mov    %esp,%ebp
80103707:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010370a:	e8 c1 39 00 00       	call   801070d0 <switchkvm>
  seginit();
8010370f:	e8 2c 39 00 00       	call   80107040 <seginit>
  lapicinit();
80103714:	e8 67 f7 ff ff       	call   80102e80 <lapicinit>
  mpmain();
80103719:	e8 a2 ff ff ff       	call   801036c0 <mpmain>
8010371e:	66 90                	xchg   %ax,%ax

80103720 <main>:
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103728:	83 e4 f0             	and    $0xfffffff0,%esp
8010372b:	ff 71 fc             	pushl  -0x4(%ecx)
8010372e:	55                   	push   %ebp
8010372f:	89 e5                	mov    %esp,%ebp
80103731:	53                   	push   %ebx
80103732:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103733:	83 ec 08             	sub    $0x8,%esp
80103736:	68 00 00 40 80       	push   $0x80400000
8010373b:	68 e8 69 11 80       	push   $0x801169e8
80103740:	e8 fb f4 ff ff       	call   80102c40 <kinit1>
  kvmalloc();      // kernel page table
80103745:	e8 66 3e 00 00       	call   801075b0 <kvmalloc>
  mpinit();        // detect other processors
8010374a:	e8 81 01 00 00       	call   801038d0 <mpinit>
  lapicinit();     // interrupt controller
8010374f:	e8 2c f7 ff ff       	call   80102e80 <lapicinit>
  seginit();       // segment descriptors
80103754:	e8 e7 38 00 00       	call   80107040 <seginit>
  picinit();       // disable pic
80103759:	e8 52 03 00 00       	call   80103ab0 <picinit>
  ioapicinit();    // another interrupt controller
8010375e:	e8 fd f2 ff ff       	call   80102a60 <ioapicinit>
  consoleinit();   // console hardware
80103763:	e8 a8 d9 ff ff       	call   80101110 <consoleinit>
  uartinit();      // serial port
80103768:	e8 93 2b 00 00       	call   80106300 <uartinit>
  pinit();         // process table
8010376d:	e8 1e 08 00 00       	call   80103f90 <pinit>
  tvinit();        // trap vectors
80103772:	e8 09 28 00 00       	call   80105f80 <tvinit>
  binit();         // buffer cache
80103777:	e8 c4 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010377c:	e8 3f dd ff ff       	call   801014c0 <fileinit>
  ideinit();       // disk 
80103781:	e8 aa f0 ff ff       	call   80102830 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103786:	83 c4 0c             	add    $0xc,%esp
80103789:	68 8a 00 00 00       	push   $0x8a
8010378e:	68 8c b4 10 80       	push   $0x8010b48c
80103793:	68 00 70 00 80       	push   $0x80007000
80103798:	e8 53 16 00 00       	call   80104df0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010379d:	83 c4 10             	add    $0x10,%esp
801037a0:	69 05 40 42 11 80 b0 	imul   $0xb0,0x80114240,%eax
801037a7:	00 00 00 
801037aa:	05 c0 3c 11 80       	add    $0x80113cc0,%eax
801037af:	3d c0 3c 11 80       	cmp    $0x80113cc0,%eax
801037b4:	76 7a                	jbe    80103830 <main+0x110>
801037b6:	bb c0 3c 11 80       	mov    $0x80113cc0,%ebx
801037bb:	eb 1c                	jmp    801037d9 <main+0xb9>
801037bd:	8d 76 00             	lea    0x0(%esi),%esi
801037c0:	69 05 40 42 11 80 b0 	imul   $0xb0,0x80114240,%eax
801037c7:	00 00 00 
801037ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801037d0:	05 c0 3c 11 80       	add    $0x80113cc0,%eax
801037d5:	39 c3                	cmp    %eax,%ebx
801037d7:	73 57                	jae    80103830 <main+0x110>
    if(c == mycpu())  // We've started already.
801037d9:	e8 d2 07 00 00       	call   80103fb0 <mycpu>
801037de:	39 c3                	cmp    %eax,%ebx
801037e0:	74 de                	je     801037c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801037e2:	e8 29 f5 ff ff       	call   80102d10 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801037e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801037ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103700,0x80006ff8
801037f1:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801037fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037fe:	05 00 10 00 00       	add    $0x1000,%eax
80103803:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103808:	0f b6 03             	movzbl (%ebx),%eax
8010380b:	68 00 70 00 00       	push   $0x7000
80103810:	50                   	push   %eax
80103811:	e8 ba f7 ff ff       	call   80102fd0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103816:	83 c4 10             	add    $0x10,%esp
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103820:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103826:	85 c0                	test   %eax,%eax
80103828:	74 f6                	je     80103820 <main+0x100>
8010382a:	eb 94                	jmp    801037c0 <main+0xa0>
8010382c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103830:	83 ec 08             	sub    $0x8,%esp
80103833:	68 00 00 00 8e       	push   $0x8e000000
80103838:	68 00 00 40 80       	push   $0x80400000
8010383d:	e8 6e f4 ff ff       	call   80102cb0 <kinit2>
  userinit();      // first user process
80103842:	e8 29 08 00 00       	call   80104070 <userinit>
  mpmain();        // finish this processor's setup
80103847:	e8 74 fe ff ff       	call   801036c0 <mpmain>
8010384c:	66 90                	xchg   %ax,%ax
8010384e:	66 90                	xchg   %ax,%ax

80103850 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103855:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010385b:	53                   	push   %ebx
  e = addr+len;
8010385c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010385f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103862:	39 de                	cmp    %ebx,%esi
80103864:	72 10                	jb     80103876 <mpsearch1+0x26>
80103866:	eb 50                	jmp    801038b8 <mpsearch1+0x68>
80103868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop
80103870:	89 fe                	mov    %edi,%esi
80103872:	39 fb                	cmp    %edi,%ebx
80103874:	76 42                	jbe    801038b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103876:	83 ec 04             	sub    $0x4,%esp
80103879:	8d 7e 10             	lea    0x10(%esi),%edi
8010387c:	6a 04                	push   $0x4
8010387e:	68 b8 7c 10 80       	push   $0x80107cb8
80103883:	56                   	push   %esi
80103884:	e8 17 15 00 00       	call   80104da0 <memcmp>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	85 c0                	test   %eax,%eax
8010388e:	75 e0                	jne    80103870 <mpsearch1+0x20>
80103890:	89 f2                	mov    %esi,%edx
80103892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103898:	0f b6 0a             	movzbl (%edx),%ecx
8010389b:	83 c2 01             	add    $0x1,%edx
8010389e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801038a0:	39 fa                	cmp    %edi,%edx
801038a2:	75 f4                	jne    80103898 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038a4:	84 c0                	test   %al,%al
801038a6:	75 c8                	jne    80103870 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801038a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038ab:	89 f0                	mov    %esi,%eax
801038ad:	5b                   	pop    %ebx
801038ae:	5e                   	pop    %esi
801038af:	5f                   	pop    %edi
801038b0:	5d                   	pop    %ebp
801038b1:	c3                   	ret    
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801038bb:	31 f6                	xor    %esi,%esi
}
801038bd:	5b                   	pop    %ebx
801038be:	89 f0                	mov    %esi,%eax
801038c0:	5e                   	pop    %esi
801038c1:	5f                   	pop    %edi
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop

801038d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	57                   	push   %edi
801038d8:	56                   	push   %esi
801038d9:	53                   	push   %ebx
801038da:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801038dd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038e4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038eb:	c1 e0 08             	shl    $0x8,%eax
801038ee:	09 d0                	or     %edx,%eax
801038f0:	c1 e0 04             	shl    $0x4,%eax
801038f3:	75 1b                	jne    80103910 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038f5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038fc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103903:	c1 e0 08             	shl    $0x8,%eax
80103906:	09 d0                	or     %edx,%eax
80103908:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010390b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103910:	ba 00 04 00 00       	mov    $0x400,%edx
80103915:	e8 36 ff ff ff       	call   80103850 <mpsearch1>
8010391a:	89 c6                	mov    %eax,%esi
8010391c:	85 c0                	test   %eax,%eax
8010391e:	0f 84 4c 01 00 00    	je     80103a70 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103924:	8b 5e 04             	mov    0x4(%esi),%ebx
80103927:	85 db                	test   %ebx,%ebx
80103929:	0f 84 61 01 00 00    	je     80103a90 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010392f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103932:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103938:	6a 04                	push   $0x4
8010393a:	68 bd 7c 10 80       	push   $0x80107cbd
8010393f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103943:	e8 58 14 00 00       	call   80104da0 <memcmp>
80103948:	83 c4 10             	add    $0x10,%esp
8010394b:	85 c0                	test   %eax,%eax
8010394d:	0f 85 3d 01 00 00    	jne    80103a90 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103953:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010395a:	3c 01                	cmp    $0x1,%al
8010395c:	74 08                	je     80103966 <mpinit+0x96>
8010395e:	3c 04                	cmp    $0x4,%al
80103960:	0f 85 2a 01 00 00    	jne    80103a90 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103966:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010396d:	66 85 d2             	test   %dx,%dx
80103970:	74 26                	je     80103998 <mpinit+0xc8>
80103972:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103975:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103977:	31 d2                	xor    %edx,%edx
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103980:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103987:	83 c0 01             	add    $0x1,%eax
8010398a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010398c:	39 f8                	cmp    %edi,%eax
8010398e:	75 f0                	jne    80103980 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103990:	84 d2                	test   %dl,%dl
80103992:	0f 85 f8 00 00 00    	jne    80103a90 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103998:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010399e:	a3 bc 3b 11 80       	mov    %eax,0x80113bbc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801039a9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801039b0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039b5:	03 55 e4             	add    -0x1c(%ebp),%edx
801039b8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
801039c0:	39 c2                	cmp    %eax,%edx
801039c2:	76 15                	jbe    801039d9 <mpinit+0x109>
    switch(*p){
801039c4:	0f b6 08             	movzbl (%eax),%ecx
801039c7:	80 f9 02             	cmp    $0x2,%cl
801039ca:	74 5c                	je     80103a28 <mpinit+0x158>
801039cc:	77 42                	ja     80103a10 <mpinit+0x140>
801039ce:	84 c9                	test   %cl,%cl
801039d0:	74 6e                	je     80103a40 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039d2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039d5:	39 c2                	cmp    %eax,%edx
801039d7:	77 eb                	ja     801039c4 <mpinit+0xf4>
801039d9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039dc:	85 db                	test   %ebx,%ebx
801039de:	0f 84 b9 00 00 00    	je     80103a9d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039e4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801039e8:	74 15                	je     801039ff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039ea:	b8 70 00 00 00       	mov    $0x70,%eax
801039ef:	ba 22 00 00 00       	mov    $0x22,%edx
801039f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039f5:	ba 23 00 00 00       	mov    $0x23,%edx
801039fa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039fb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039fe:	ee                   	out    %al,(%dx)
  }
}
801039ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a02:	5b                   	pop    %ebx
80103a03:	5e                   	pop    %esi
80103a04:	5f                   	pop    %edi
80103a05:	5d                   	pop    %ebp
80103a06:	c3                   	ret    
80103a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103a10:	83 e9 03             	sub    $0x3,%ecx
80103a13:	80 f9 01             	cmp    $0x1,%cl
80103a16:	76 ba                	jbe    801039d2 <mpinit+0x102>
80103a18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103a1f:	eb 9f                	jmp    801039c0 <mpinit+0xf0>
80103a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a28:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103a2c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a2f:	88 0d a0 3c 11 80    	mov    %cl,0x80113ca0
      continue;
80103a35:	eb 89                	jmp    801039c0 <mpinit+0xf0>
80103a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103a40:	8b 0d 40 42 11 80    	mov    0x80114240,%ecx
80103a46:	83 f9 07             	cmp    $0x7,%ecx
80103a49:	7f 19                	jg     80103a64 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a4b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103a51:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103a55:	83 c1 01             	add    $0x1,%ecx
80103a58:	89 0d 40 42 11 80    	mov    %ecx,0x80114240
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a5e:	88 9f c0 3c 11 80    	mov    %bl,-0x7feec340(%edi)
      p += sizeof(struct mpproc);
80103a64:	83 c0 14             	add    $0x14,%eax
      continue;
80103a67:	e9 54 ff ff ff       	jmp    801039c0 <mpinit+0xf0>
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a70:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a75:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a7a:	e8 d1 fd ff ff       	call   80103850 <mpsearch1>
80103a7f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a81:	85 c0                	test   %eax,%eax
80103a83:	0f 85 9b fe ff ff    	jne    80103924 <mpinit+0x54>
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 c2 7c 10 80       	push   $0x80107cc2
80103a98:	e8 f3 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a9d:	83 ec 0c             	sub    $0xc,%esp
80103aa0:	68 dc 7c 10 80       	push   $0x80107cdc
80103aa5:	e8 e6 c8 ff ff       	call   80100390 <panic>
80103aaa:	66 90                	xchg   %ax,%ax
80103aac:	66 90                	xchg   %ax,%ax
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ab9:	ba 21 00 00 00       	mov    $0x21,%edx
80103abe:	ee                   	out    %al,(%dx)
80103abf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103ac4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103ac5:	c3                   	ret    
80103ac6:	66 90                	xchg   %ax,%ax
80103ac8:	66 90                	xchg   %ax,%ax
80103aca:	66 90                	xchg   %ax,%ax
80103acc:	66 90                	xchg   %ax,%ax
80103ace:	66 90                	xchg   %ax,%ax

80103ad0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	57                   	push   %edi
80103ad8:	56                   	push   %esi
80103ad9:	53                   	push   %ebx
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ae0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103ae3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ae9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103aef:	e8 ec d9 ff ff       	call   801014e0 <filealloc>
80103af4:	89 03                	mov    %eax,(%ebx)
80103af6:	85 c0                	test   %eax,%eax
80103af8:	0f 84 ac 00 00 00    	je     80103baa <pipealloc+0xda>
80103afe:	e8 dd d9 ff ff       	call   801014e0 <filealloc>
80103b03:	89 06                	mov    %eax,(%esi)
80103b05:	85 c0                	test   %eax,%eax
80103b07:	0f 84 8b 00 00 00    	je     80103b98 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103b0d:	e8 fe f1 ff ff       	call   80102d10 <kalloc>
80103b12:	89 c7                	mov    %eax,%edi
80103b14:	85 c0                	test   %eax,%eax
80103b16:	0f 84 b4 00 00 00    	je     80103bd0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103b1c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b23:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103b26:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103b29:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b30:	00 00 00 
  p->nwrite = 0;
80103b33:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b3a:	00 00 00 
  p->nread = 0;
80103b3d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b44:	00 00 00 
  initlock(&p->lock, "pipe");
80103b47:	68 fb 7c 10 80       	push   $0x80107cfb
80103b4c:	50                   	push   %eax
80103b4d:	e8 6e 0f 00 00       	call   80104ac0 <initlock>
  (*f0)->type = FD_PIPE;
80103b52:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b54:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b57:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b5d:	8b 03                	mov    (%ebx),%eax
80103b5f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b63:	8b 03                	mov    (%ebx),%eax
80103b65:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b69:	8b 03                	mov    (%ebx),%eax
80103b6b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b6e:	8b 06                	mov    (%esi),%eax
80103b70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b76:	8b 06                	mov    (%esi),%eax
80103b78:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b7c:	8b 06                	mov    (%esi),%eax
80103b7e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b82:	8b 06                	mov    (%esi),%eax
80103b84:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b8a:	31 c0                	xor    %eax,%eax
}
80103b8c:	5b                   	pop    %ebx
80103b8d:	5e                   	pop    %esi
80103b8e:	5f                   	pop    %edi
80103b8f:	5d                   	pop    %ebp
80103b90:	c3                   	ret    
80103b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b98:	8b 03                	mov    (%ebx),%eax
80103b9a:	85 c0                	test   %eax,%eax
80103b9c:	74 1e                	je     80103bbc <pipealloc+0xec>
    fileclose(*f0);
80103b9e:	83 ec 0c             	sub    $0xc,%esp
80103ba1:	50                   	push   %eax
80103ba2:	e8 f9 d9 ff ff       	call   801015a0 <fileclose>
80103ba7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103baa:	8b 06                	mov    (%esi),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 0c                	je     80103bbc <pipealloc+0xec>
    fileclose(*f1);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 e7 d9 ff ff       	call   801015a0 <fileclose>
80103bb9:	83 c4 10             	add    $0x10,%esp
}
80103bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103bc4:	5b                   	pop    %ebx
80103bc5:	5e                   	pop    %esi
80103bc6:	5f                   	pop    %edi
80103bc7:	5d                   	pop    %ebp
80103bc8:	c3                   	ret    
80103bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103bd0:	8b 03                	mov    (%ebx),%eax
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 c8                	jne    80103b9e <pipealloc+0xce>
80103bd6:	eb d2                	jmp    80103baa <pipealloc+0xda>
80103bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdf:	90                   	nop

80103be0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	56                   	push   %esi
80103be8:	53                   	push   %ebx
80103be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bef:	83 ec 0c             	sub    $0xc,%esp
80103bf2:	53                   	push   %ebx
80103bf3:	e8 48 10 00 00       	call   80104c40 <acquire>
  if(writable){
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	85 f6                	test   %esi,%esi
80103bfd:	74 41                	je     80103c40 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bff:	83 ec 0c             	sub    $0xc,%esp
80103c02:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103c08:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c0f:	00 00 00 
    wakeup(&p->nread);
80103c12:	50                   	push   %eax
80103c13:	e8 a8 0b 00 00       	call   801047c0 <wakeup>
80103c18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c1b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103c21:	85 d2                	test   %edx,%edx
80103c23:	75 0a                	jne    80103c2f <pipeclose+0x4f>
80103c25:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103c2b:	85 c0                	test   %eax,%eax
80103c2d:	74 31                	je     80103c60 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103c2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c35:	5b                   	pop    %ebx
80103c36:	5e                   	pop    %esi
80103c37:	5d                   	pop    %ebp
    release(&p->lock);
80103c38:	e9 c3 10 00 00       	jmp    80104d00 <release>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103c49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c50:	00 00 00 
    wakeup(&p->nwrite);
80103c53:	50                   	push   %eax
80103c54:	e8 67 0b 00 00       	call   801047c0 <wakeup>
80103c59:	83 c4 10             	add    $0x10,%esp
80103c5c:	eb bd                	jmp    80103c1b <pipeclose+0x3b>
80103c5e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	53                   	push   %ebx
80103c64:	e8 97 10 00 00       	call   80104d00 <release>
    kfree((char*)p);
80103c69:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c6c:	83 c4 10             	add    $0x10,%esp
}
80103c6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c72:	5b                   	pop    %ebx
80103c73:	5e                   	pop    %esi
80103c74:	5d                   	pop    %ebp
    kfree((char*)p);
80103c75:	e9 d6 ee ff ff       	jmp    80102b50 <kfree>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c80:	f3 0f 1e fb          	endbr32 
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	57                   	push   %edi
80103c88:	56                   	push   %esi
80103c89:	53                   	push   %ebx
80103c8a:	83 ec 28             	sub    $0x28,%esp
80103c8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c90:	53                   	push   %ebx
80103c91:	e8 aa 0f 00 00       	call   80104c40 <acquire>
  for(i = 0; i < n; i++){
80103c96:	8b 45 10             	mov    0x10(%ebp),%eax
80103c99:	83 c4 10             	add    $0x10,%esp
80103c9c:	85 c0                	test   %eax,%eax
80103c9e:	0f 8e bc 00 00 00    	jle    80103d60 <pipewrite+0xe0>
80103ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103cad:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103cb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cb6:	03 45 10             	add    0x10(%ebp),%eax
80103cb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cbc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cc2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cc8:	89 ca                	mov    %ecx,%edx
80103cca:	05 00 02 00 00       	add    $0x200,%eax
80103ccf:	39 c1                	cmp    %eax,%ecx
80103cd1:	74 3b                	je     80103d0e <pipewrite+0x8e>
80103cd3:	eb 63                	jmp    80103d38 <pipewrite+0xb8>
80103cd5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103cd8:	e8 63 03 00 00       	call   80104040 <myproc>
80103cdd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ce0:	85 c9                	test   %ecx,%ecx
80103ce2:	75 34                	jne    80103d18 <pipewrite+0x98>
      wakeup(&p->nread);
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	57                   	push   %edi
80103ce8:	e8 d3 0a 00 00       	call   801047c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ced:	58                   	pop    %eax
80103cee:	5a                   	pop    %edx
80103cef:	53                   	push   %ebx
80103cf0:	56                   	push   %esi
80103cf1:	e8 0a 09 00 00       	call   80104600 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cf6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cfc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103d02:	83 c4 10             	add    $0x10,%esp
80103d05:	05 00 02 00 00       	add    $0x200,%eax
80103d0a:	39 c2                	cmp    %eax,%edx
80103d0c:	75 2a                	jne    80103d38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103d0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	75 c0                	jne    80103cd8 <pipewrite+0x58>
        release(&p->lock);
80103d18:	83 ec 0c             	sub    $0xc,%esp
80103d1b:	53                   	push   %ebx
80103d1c:	e8 df 0f 00 00       	call   80104d00 <release>
        return -1;
80103d21:	83 c4 10             	add    $0x10,%esp
80103d24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2c:	5b                   	pop    %ebx
80103d2d:	5e                   	pop    %esi
80103d2e:	5f                   	pop    %edi
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103d3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103d4a:	0f b6 06             	movzbl (%esi),%eax
80103d4d:	83 c6 01             	add    $0x1,%esi
80103d50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103d53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d5a:	0f 85 5c ff ff ff    	jne    80103cbc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d69:	50                   	push   %eax
80103d6a:	e8 51 0a 00 00       	call   801047c0 <wakeup>
  release(&p->lock);
80103d6f:	89 1c 24             	mov    %ebx,(%esp)
80103d72:	e8 89 0f 00 00       	call   80104d00 <release>
  return n;
80103d77:	8b 45 10             	mov    0x10(%ebp),%eax
80103d7a:	83 c4 10             	add    $0x10,%esp
80103d7d:	eb aa                	jmp    80103d29 <pipewrite+0xa9>
80103d7f:	90                   	nop

80103d80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	57                   	push   %edi
80103d88:	56                   	push   %esi
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 18             	sub    $0x18,%esp
80103d8d:	8b 75 08             	mov    0x8(%ebp),%esi
80103d90:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d93:	56                   	push   %esi
80103d94:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d9a:	e8 a1 0e 00 00       	call   80104c40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d9f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103da5:	83 c4 10             	add    $0x10,%esp
80103da8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103dae:	74 33                	je     80103de3 <piperead+0x63>
80103db0:	eb 3b                	jmp    80103ded <piperead+0x6d>
80103db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103db8:	e8 83 02 00 00       	call   80104040 <myproc>
80103dbd:	8b 48 24             	mov    0x24(%eax),%ecx
80103dc0:	85 c9                	test   %ecx,%ecx
80103dc2:	0f 85 88 00 00 00    	jne    80103e50 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103dc8:	83 ec 08             	sub    $0x8,%esp
80103dcb:	56                   	push   %esi
80103dcc:	53                   	push   %ebx
80103dcd:	e8 2e 08 00 00       	call   80104600 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103dd2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103de1:	75 0a                	jne    80103ded <piperead+0x6d>
80103de3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103de9:	85 c0                	test   %eax,%eax
80103deb:	75 cb                	jne    80103db8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ded:	8b 55 10             	mov    0x10(%ebp),%edx
80103df0:	31 db                	xor    %ebx,%ebx
80103df2:	85 d2                	test   %edx,%edx
80103df4:	7f 28                	jg     80103e1e <piperead+0x9e>
80103df6:	eb 34                	jmp    80103e2c <piperead+0xac>
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103e00:	8d 48 01             	lea    0x1(%eax),%ecx
80103e03:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103e0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103e13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e16:	83 c3 01             	add    $0x1,%ebx
80103e19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e1c:	74 0e                	je     80103e2c <piperead+0xac>
    if(p->nread == p->nwrite)
80103e1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103e2a:	75 d4                	jne    80103e00 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e35:	50                   	push   %eax
80103e36:	e8 85 09 00 00       	call   801047c0 <wakeup>
  release(&p->lock);
80103e3b:	89 34 24             	mov    %esi,(%esp)
80103e3e:	e8 bd 0e 00 00       	call   80104d00 <release>
  return i;
80103e43:	83 c4 10             	add    $0x10,%esp
}
80103e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e49:	89 d8                	mov    %ebx,%eax
80103e4b:	5b                   	pop    %ebx
80103e4c:	5e                   	pop    %esi
80103e4d:	5f                   	pop    %edi
80103e4e:	5d                   	pop    %ebp
80103e4f:	c3                   	ret    
      release(&p->lock);
80103e50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e58:	56                   	push   %esi
80103e59:	e8 a2 0e 00 00       	call   80104d00 <release>
      return -1;
80103e5e:	83 c4 10             	add    $0x10,%esp
}
80103e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e64:	89 d8                	mov    %ebx,%eax
80103e66:	5b                   	pop    %ebx
80103e67:	5e                   	pop    %esi
80103e68:	5f                   	pop    %edi
80103e69:	5d                   	pop    %ebp
80103e6a:	c3                   	ret    
80103e6b:	66 90                	xchg   %ax,%ax
80103e6d:	66 90                	xchg   %ax,%ax
80103e6f:	90                   	nop

80103e70 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e74:	bb 94 42 11 80       	mov    $0x80114294,%ebx
{
80103e79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e7c:	68 60 42 11 80       	push   $0x80114260
80103e81:	e8 ba 0d 00 00       	call   80104c40 <acquire>
80103e86:	83 c4 10             	add    $0x10,%esp
80103e89:	eb 10                	jmp    80103e9b <allocproc+0x2b>
80103e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e90:	83 c3 7c             	add    $0x7c,%ebx
80103e93:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80103e99:	74 75                	je     80103f10 <allocproc+0xa0>
    if(p->state == UNUSED)
80103e9b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	75 ee                	jne    80103e90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ea2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103ea7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103eaa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103eb1:	89 43 10             	mov    %eax,0x10(%ebx)
80103eb4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103eb7:	68 60 42 11 80       	push   $0x80114260
  p->pid = nextpid++;
80103ebc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ec2:	e8 39 0e 00 00       	call   80104d00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ec7:	e8 44 ee ff ff       	call   80102d10 <kalloc>
80103ecc:	83 c4 10             	add    $0x10,%esp
80103ecf:	89 43 08             	mov    %eax,0x8(%ebx)
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	74 53                	je     80103f29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ed6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103edc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103edf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ee4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ee7:	c7 40 14 66 5f 10 80 	movl   $0x80105f66,0x14(%eax)
  p->context = (struct context*)sp;
80103eee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ef1:	6a 14                	push   $0x14
80103ef3:	6a 00                	push   $0x0
80103ef5:	50                   	push   %eax
80103ef6:	e8 55 0e 00 00       	call   80104d50 <memset>
  p->context->eip = (uint)forkret;
80103efb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103efe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103f01:	c7 40 10 40 3f 10 80 	movl   $0x80103f40,0x10(%eax)
}
80103f08:	89 d8                	mov    %ebx,%eax
80103f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f0d:	c9                   	leave  
80103f0e:	c3                   	ret    
80103f0f:	90                   	nop
  release(&ptable.lock);
80103f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f15:	68 60 42 11 80       	push   $0x80114260
80103f1a:	e8 e1 0d 00 00       	call   80104d00 <release>
}
80103f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103f21:	83 c4 10             	add    $0x10,%esp
}
80103f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f27:	c9                   	leave  
80103f28:	c3                   	ret    
    p->state = UNUSED;
80103f29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f30:	31 db                	xor    %ebx,%ebx
}
80103f32:	89 d8                	mov    %ebx,%eax
80103f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f37:	c9                   	leave  
80103f38:	c3                   	ret    
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f4a:	68 60 42 11 80       	push   $0x80114260
80103f4f:	e8 ac 0d 00 00       	call   80104d00 <release>

  if (first) {
80103f54:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103f59:	83 c4 10             	add    $0x10,%esp
80103f5c:	85 c0                	test   %eax,%eax
80103f5e:	75 08                	jne    80103f68 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f60:	c9                   	leave  
80103f61:	c3                   	ret    
80103f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103f68:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103f6f:	00 00 00 
    iinit(ROOTDEV);
80103f72:	83 ec 0c             	sub    $0xc,%esp
80103f75:	6a 01                	push   $0x1
80103f77:	e8 a4 dc ff ff       	call   80101c20 <iinit>
    initlog(ROOTDEV);
80103f7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f83:	e8 e8 f3 ff ff       	call   80103370 <initlog>
}
80103f88:	83 c4 10             	add    $0x10,%esp
80103f8b:	c9                   	leave  
80103f8c:	c3                   	ret    
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi

80103f90 <pinit>:
{
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f9a:	68 00 7d 10 80       	push   $0x80107d00
80103f9f:	68 60 42 11 80       	push   $0x80114260
80103fa4:	e8 17 0b 00 00       	call   80104ac0 <initlock>
}
80103fa9:	83 c4 10             	add    $0x10,%esp
80103fac:	c9                   	leave  
80103fad:	c3                   	ret    
80103fae:	66 90                	xchg   %ax,%ax

80103fb0 <mycpu>:
{
80103fb0:	f3 0f 1e fb          	endbr32 
80103fb4:	55                   	push   %ebp
80103fb5:	89 e5                	mov    %esp,%ebp
80103fb7:	56                   	push   %esi
80103fb8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fb9:	9c                   	pushf  
80103fba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fbb:	f6 c4 02             	test   $0x2,%ah
80103fbe:	75 4a                	jne    8010400a <mycpu+0x5a>
  apicid = lapicid();
80103fc0:	e8 bb ef ff ff       	call   80102f80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103fc5:	8b 35 40 42 11 80    	mov    0x80114240,%esi
  apicid = lapicid();
80103fcb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103fcd:	85 f6                	test   %esi,%esi
80103fcf:	7e 2c                	jle    80103ffd <mycpu+0x4d>
80103fd1:	31 d2                	xor    %edx,%edx
80103fd3:	eb 0a                	jmp    80103fdf <mycpu+0x2f>
80103fd5:	8d 76 00             	lea    0x0(%esi),%esi
80103fd8:	83 c2 01             	add    $0x1,%edx
80103fdb:	39 f2                	cmp    %esi,%edx
80103fdd:	74 1e                	je     80103ffd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103fdf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103fe5:	0f b6 81 c0 3c 11 80 	movzbl -0x7feec340(%ecx),%eax
80103fec:	39 d8                	cmp    %ebx,%eax
80103fee:	75 e8                	jne    80103fd8 <mycpu+0x28>
}
80103ff0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ff3:	8d 81 c0 3c 11 80    	lea    -0x7feec340(%ecx),%eax
}
80103ff9:	5b                   	pop    %ebx
80103ffa:	5e                   	pop    %esi
80103ffb:	5d                   	pop    %ebp
80103ffc:	c3                   	ret    
  panic("unknown apicid\n");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 07 7d 10 80       	push   $0x80107d07
80104005:	e8 86 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 e4 7d 10 80       	push   $0x80107de4
80104012:	e8 79 c3 ff ff       	call   80100390 <panic>
80104017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401e:	66 90                	xchg   %ax,%ax

80104020 <cpuid>:
cpuid() {
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010402a:	e8 81 ff ff ff       	call   80103fb0 <mycpu>
}
8010402f:	c9                   	leave  
  return mycpu()-cpus;
80104030:	2d c0 3c 11 80       	sub    $0x80113cc0,%eax
80104035:	c1 f8 04             	sar    $0x4,%eax
80104038:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010403e:	c3                   	ret    
8010403f:	90                   	nop

80104040 <myproc>:
myproc(void) {
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	53                   	push   %ebx
80104048:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010404b:	e8 f0 0a 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104050:	e8 5b ff ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
80104055:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010405b:	e8 30 0b 00 00       	call   80104b90 <popcli>
}
80104060:	83 c4 04             	add    $0x4,%esp
80104063:	89 d8                	mov    %ebx,%eax
80104065:	5b                   	pop    %ebx
80104066:	5d                   	pop    %ebp
80104067:	c3                   	ret    
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop

80104070 <userinit>:
{
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	53                   	push   %ebx
80104078:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010407b:	e8 f0 fd ff ff       	call   80103e70 <allocproc>
80104080:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104082:	a3 f8 b5 10 80       	mov    %eax,0x8010b5f8
  if((p->pgdir = setupkvm()) == 0)
80104087:	e8 a4 34 00 00       	call   80107530 <setupkvm>
8010408c:	89 43 04             	mov    %eax,0x4(%ebx)
8010408f:	85 c0                	test   %eax,%eax
80104091:	0f 84 bd 00 00 00    	je     80104154 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104097:	83 ec 04             	sub    $0x4,%esp
8010409a:	68 2c 00 00 00       	push   $0x2c
8010409f:	68 60 b4 10 80       	push   $0x8010b460
801040a4:	50                   	push   %eax
801040a5:	e8 56 31 00 00       	call   80107200 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801040aa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801040ad:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801040b3:	6a 4c                	push   $0x4c
801040b5:	6a 00                	push   $0x0
801040b7:	ff 73 18             	pushl  0x18(%ebx)
801040ba:	e8 91 0c 00 00       	call   80104d50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040bf:	8b 43 18             	mov    0x18(%ebx),%eax
801040c2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040c7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040ca:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040cf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040d3:	8b 43 18             	mov    0x18(%ebx),%eax
801040d6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040da:	8b 43 18             	mov    0x18(%ebx),%eax
801040dd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040e1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040e5:	8b 43 18             	mov    0x18(%ebx),%eax
801040e8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040ec:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040f0:	8b 43 18             	mov    0x18(%ebx),%eax
801040f3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040fa:	8b 43 18             	mov    0x18(%ebx),%eax
801040fd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104104:	8b 43 18             	mov    0x18(%ebx),%eax
80104107:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010410e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104111:	6a 10                	push   $0x10
80104113:	68 30 7d 10 80       	push   $0x80107d30
80104118:	50                   	push   %eax
80104119:	e8 f2 0d 00 00       	call   80104f10 <safestrcpy>
  p->cwd = namei("/");
8010411e:	c7 04 24 39 7d 10 80 	movl   $0x80107d39,(%esp)
80104125:	e8 e6 e5 ff ff       	call   80102710 <namei>
8010412a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010412d:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80104134:	e8 07 0b 00 00       	call   80104c40 <acquire>
  p->state = RUNNABLE;
80104139:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104140:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
80104147:	e8 b4 0b 00 00       	call   80104d00 <release>
}
8010414c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010414f:	83 c4 10             	add    $0x10,%esp
80104152:	c9                   	leave  
80104153:	c3                   	ret    
    panic("userinit: out of memory?");
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	68 17 7d 10 80       	push   $0x80107d17
8010415c:	e8 2f c2 ff ff       	call   80100390 <panic>
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop

80104170 <growproc>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	56                   	push   %esi
80104178:	53                   	push   %ebx
80104179:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010417c:	e8 bf 09 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104181:	e8 2a fe ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
80104186:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010418c:	e8 ff 09 00 00       	call   80104b90 <popcli>
  sz = curproc->sz;
80104191:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104193:	85 f6                	test   %esi,%esi
80104195:	7f 19                	jg     801041b0 <growproc+0x40>
  } else if(n < 0){
80104197:	75 37                	jne    801041d0 <growproc+0x60>
  switchuvm(curproc);
80104199:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010419c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010419e:	53                   	push   %ebx
8010419f:	e8 4c 2f 00 00       	call   801070f0 <switchuvm>
  return 0;
801041a4:	83 c4 10             	add    $0x10,%esp
801041a7:	31 c0                	xor    %eax,%eax
}
801041a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ac:	5b                   	pop    %ebx
801041ad:	5e                   	pop    %esi
801041ae:	5d                   	pop    %ebp
801041af:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041b0:	83 ec 04             	sub    $0x4,%esp
801041b3:	01 c6                	add    %eax,%esi
801041b5:	56                   	push   %esi
801041b6:	50                   	push   %eax
801041b7:	ff 73 04             	pushl  0x4(%ebx)
801041ba:	e8 91 31 00 00       	call   80107350 <allocuvm>
801041bf:	83 c4 10             	add    $0x10,%esp
801041c2:	85 c0                	test   %eax,%eax
801041c4:	75 d3                	jne    80104199 <growproc+0x29>
      return -1;
801041c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cb:	eb dc                	jmp    801041a9 <growproc+0x39>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041d0:	83 ec 04             	sub    $0x4,%esp
801041d3:	01 c6                	add    %eax,%esi
801041d5:	56                   	push   %esi
801041d6:	50                   	push   %eax
801041d7:	ff 73 04             	pushl  0x4(%ebx)
801041da:	e8 a1 32 00 00       	call   80107480 <deallocuvm>
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	85 c0                	test   %eax,%eax
801041e4:	75 b3                	jne    80104199 <growproc+0x29>
801041e6:	eb de                	jmp    801041c6 <growproc+0x56>
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop

801041f0 <fork>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	53                   	push   %ebx
801041fa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041fd:	e8 3e 09 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104202:	e8 a9 fd ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
80104207:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010420d:	e8 7e 09 00 00       	call   80104b90 <popcli>
  if((np = allocproc()) == 0){
80104212:	e8 59 fc ff ff       	call   80103e70 <allocproc>
80104217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010421a:	85 c0                	test   %eax,%eax
8010421c:	0f 84 bb 00 00 00    	je     801042dd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104222:	83 ec 08             	sub    $0x8,%esp
80104225:	ff 33                	pushl  (%ebx)
80104227:	89 c7                	mov    %eax,%edi
80104229:	ff 73 04             	pushl  0x4(%ebx)
8010422c:	e8 cf 33 00 00       	call   80107600 <copyuvm>
80104231:	83 c4 10             	add    $0x10,%esp
80104234:	89 47 04             	mov    %eax,0x4(%edi)
80104237:	85 c0                	test   %eax,%eax
80104239:	0f 84 a5 00 00 00    	je     801042e4 <fork+0xf4>
  np->sz = curproc->sz;
8010423f:	8b 03                	mov    (%ebx),%eax
80104241:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104244:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104246:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104249:	89 c8                	mov    %ecx,%eax
8010424b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010424e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104253:	8b 73 18             	mov    0x18(%ebx),%esi
80104256:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104258:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010425a:	8b 40 18             	mov    0x18(%eax),%eax
8010425d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104268:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010426c:	85 c0                	test   %eax,%eax
8010426e:	74 13                	je     80104283 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	50                   	push   %eax
80104274:	e8 d7 d2 ff ff       	call   80101550 <filedup>
80104279:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010427c:	83 c4 10             	add    $0x10,%esp
8010427f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104283:	83 c6 01             	add    $0x1,%esi
80104286:	83 fe 10             	cmp    $0x10,%esi
80104289:	75 dd                	jne    80104268 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104291:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104294:	e8 77 db ff ff       	call   80101e10 <idup>
80104299:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010429c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010429f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042a2:	8d 47 6c             	lea    0x6c(%edi),%eax
801042a5:	6a 10                	push   $0x10
801042a7:	53                   	push   %ebx
801042a8:	50                   	push   %eax
801042a9:	e8 62 0c 00 00       	call   80104f10 <safestrcpy>
  pid = np->pid;
801042ae:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801042b1:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801042b8:	e8 83 09 00 00       	call   80104c40 <acquire>
  np->state = RUNNABLE;
801042bd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801042c4:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801042cb:	e8 30 0a 00 00       	call   80104d00 <release>
  return pid;
801042d0:	83 c4 10             	add    $0x10,%esp
}
801042d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d6:	89 d8                	mov    %ebx,%eax
801042d8:	5b                   	pop    %ebx
801042d9:	5e                   	pop    %esi
801042da:	5f                   	pop    %edi
801042db:	5d                   	pop    %ebp
801042dc:	c3                   	ret    
    return -1;
801042dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801042e2:	eb ef                	jmp    801042d3 <fork+0xe3>
    kfree(np->kstack);
801042e4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801042e7:	83 ec 0c             	sub    $0xc,%esp
801042ea:	ff 73 08             	pushl  0x8(%ebx)
801042ed:	e8 5e e8 ff ff       	call   80102b50 <kfree>
    np->kstack = 0;
801042f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801042f9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801042fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104303:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104308:	eb c9                	jmp    801042d3 <fork+0xe3>
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <scheduler>:
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	57                   	push   %edi
80104318:	56                   	push   %esi
80104319:	53                   	push   %ebx
8010431a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010431d:	e8 8e fc ff ff       	call   80103fb0 <mycpu>
  c->proc = 0;
80104322:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104329:	00 00 00 
  struct cpu *c = mycpu();
8010432c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010432e:	8d 78 04             	lea    0x4(%eax),%edi
80104331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104338:	fb                   	sti    
    acquire(&ptable.lock);
80104339:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010433c:	bb 94 42 11 80       	mov    $0x80114294,%ebx
    acquire(&ptable.lock);
80104341:	68 60 42 11 80       	push   $0x80114260
80104346:	e8 f5 08 00 00       	call   80104c40 <acquire>
8010434b:	83 c4 10             	add    $0x10,%esp
8010434e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104350:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104354:	75 33                	jne    80104389 <scheduler+0x79>
      switchuvm(p);
80104356:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104359:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010435f:	53                   	push   %ebx
80104360:	e8 8b 2d 00 00       	call   801070f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104365:	58                   	pop    %eax
80104366:	5a                   	pop    %edx
80104367:	ff 73 1c             	pushl  0x1c(%ebx)
8010436a:	57                   	push   %edi
      p->state = RUNNING;
8010436b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104372:	e8 fc 0b 00 00       	call   80104f73 <swtch>
      switchkvm();
80104377:	e8 54 2d 00 00       	call   801070d0 <switchkvm>
      c->proc = 0;
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104386:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104389:	83 c3 7c             	add    $0x7c,%ebx
8010438c:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80104392:	75 bc                	jne    80104350 <scheduler+0x40>
    release(&ptable.lock);
80104394:	83 ec 0c             	sub    $0xc,%esp
80104397:	68 60 42 11 80       	push   $0x80114260
8010439c:	e8 5f 09 00 00       	call   80104d00 <release>
    sti();
801043a1:	83 c4 10             	add    $0x10,%esp
801043a4:	eb 92                	jmp    80104338 <scheduler+0x28>
801043a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <sched>:
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	56                   	push   %esi
801043b8:	53                   	push   %ebx
  pushcli();
801043b9:	e8 82 07 00 00       	call   80104b40 <pushcli>
  c = mycpu();
801043be:	e8 ed fb ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
801043c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043c9:	e8 c2 07 00 00       	call   80104b90 <popcli>
  if(!holding(&ptable.lock))
801043ce:	83 ec 0c             	sub    $0xc,%esp
801043d1:	68 60 42 11 80       	push   $0x80114260
801043d6:	e8 15 08 00 00       	call   80104bf0 <holding>
801043db:	83 c4 10             	add    $0x10,%esp
801043de:	85 c0                	test   %eax,%eax
801043e0:	74 4f                	je     80104431 <sched+0x81>
  if(mycpu()->ncli != 1)
801043e2:	e8 c9 fb ff ff       	call   80103fb0 <mycpu>
801043e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801043ee:	75 68                	jne    80104458 <sched+0xa8>
  if(p->state == RUNNING)
801043f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801043f4:	74 55                	je     8010444b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043f6:	9c                   	pushf  
801043f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043f8:	f6 c4 02             	test   $0x2,%ah
801043fb:	75 41                	jne    8010443e <sched+0x8e>
  intena = mycpu()->intena;
801043fd:	e8 ae fb ff ff       	call   80103fb0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104402:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104405:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010440b:	e8 a0 fb ff ff       	call   80103fb0 <mycpu>
80104410:	83 ec 08             	sub    $0x8,%esp
80104413:	ff 70 04             	pushl  0x4(%eax)
80104416:	53                   	push   %ebx
80104417:	e8 57 0b 00 00       	call   80104f73 <swtch>
  mycpu()->intena = intena;
8010441c:	e8 8f fb ff ff       	call   80103fb0 <mycpu>
}
80104421:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104424:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010442a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010442d:	5b                   	pop    %ebx
8010442e:	5e                   	pop    %esi
8010442f:	5d                   	pop    %ebp
80104430:	c3                   	ret    
    panic("sched ptable.lock");
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 3b 7d 10 80       	push   $0x80107d3b
80104439:	e8 52 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010443e:	83 ec 0c             	sub    $0xc,%esp
80104441:	68 67 7d 10 80       	push   $0x80107d67
80104446:	e8 45 bf ff ff       	call   80100390 <panic>
    panic("sched running");
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	68 59 7d 10 80       	push   $0x80107d59
80104453:	e8 38 bf ff ff       	call   80100390 <panic>
    panic("sched locks");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 4d 7d 10 80       	push   $0x80107d4d
80104460:	e8 2b bf ff ff       	call   80100390 <panic>
80104465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <exit>:
{
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	57                   	push   %edi
80104478:	56                   	push   %esi
80104479:	53                   	push   %ebx
8010447a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010447d:	e8 be 06 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104482:	e8 29 fb ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
80104487:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010448d:	e8 fe 06 00 00       	call   80104b90 <popcli>
  if(curproc == initproc)
80104492:	8d 5e 28             	lea    0x28(%esi),%ebx
80104495:	8d 7e 68             	lea    0x68(%esi),%edi
80104498:	39 35 f8 b5 10 80    	cmp    %esi,0x8010b5f8
8010449e:	0f 84 f3 00 00 00    	je     80104597 <exit+0x127>
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801044a8:	8b 03                	mov    (%ebx),%eax
801044aa:	85 c0                	test   %eax,%eax
801044ac:	74 12                	je     801044c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801044ae:	83 ec 0c             	sub    $0xc,%esp
801044b1:	50                   	push   %eax
801044b2:	e8 e9 d0 ff ff       	call   801015a0 <fileclose>
      curproc->ofile[fd] = 0;
801044b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801044bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801044c0:	83 c3 04             	add    $0x4,%ebx
801044c3:	39 df                	cmp    %ebx,%edi
801044c5:	75 e1                	jne    801044a8 <exit+0x38>
  begin_op();
801044c7:	e8 44 ef ff ff       	call   80103410 <begin_op>
  iput(curproc->cwd);
801044cc:	83 ec 0c             	sub    $0xc,%esp
801044cf:	ff 76 68             	pushl  0x68(%esi)
801044d2:	e8 99 da ff ff       	call   80101f70 <iput>
  end_op();
801044d7:	e8 a4 ef ff ff       	call   80103480 <end_op>
  curproc->cwd = 0;
801044dc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801044e3:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801044ea:	e8 51 07 00 00       	call   80104c40 <acquire>
  wakeup1(curproc->parent);
801044ef:	8b 56 14             	mov    0x14(%esi),%edx
801044f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f5:	b8 94 42 11 80       	mov    $0x80114294,%eax
801044fa:	eb 0e                	jmp    8010450a <exit+0x9a>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104500:	83 c0 7c             	add    $0x7c,%eax
80104503:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104508:	74 1c                	je     80104526 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010450a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010450e:	75 f0                	jne    80104500 <exit+0x90>
80104510:	3b 50 20             	cmp    0x20(%eax),%edx
80104513:	75 eb                	jne    80104500 <exit+0x90>
      p->state = RUNNABLE;
80104515:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010451c:	83 c0 7c             	add    $0x7c,%eax
8010451f:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104524:	75 e4                	jne    8010450a <exit+0x9a>
      p->parent = initproc;
80104526:	8b 0d f8 b5 10 80    	mov    0x8010b5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010452c:	ba 94 42 11 80       	mov    $0x80114294,%edx
80104531:	eb 10                	jmp    80104543 <exit+0xd3>
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
80104538:	83 c2 7c             	add    $0x7c,%edx
8010453b:	81 fa 94 61 11 80    	cmp    $0x80116194,%edx
80104541:	74 3b                	je     8010457e <exit+0x10e>
    if(p->parent == curproc){
80104543:	39 72 14             	cmp    %esi,0x14(%edx)
80104546:	75 f0                	jne    80104538 <exit+0xc8>
      if(p->state == ZOMBIE)
80104548:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010454c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010454f:	75 e7                	jne    80104538 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104551:	b8 94 42 11 80       	mov    $0x80114294,%eax
80104556:	eb 12                	jmp    8010456a <exit+0xfa>
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop
80104560:	83 c0 7c             	add    $0x7c,%eax
80104563:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104568:	74 ce                	je     80104538 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010456a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010456e:	75 f0                	jne    80104560 <exit+0xf0>
80104570:	3b 48 20             	cmp    0x20(%eax),%ecx
80104573:	75 eb                	jne    80104560 <exit+0xf0>
      p->state = RUNNABLE;
80104575:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010457c:	eb e2                	jmp    80104560 <exit+0xf0>
  curproc->state = ZOMBIE;
8010457e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104585:	e8 26 fe ff ff       	call   801043b0 <sched>
  panic("zombie exit");
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	68 88 7d 10 80       	push   $0x80107d88
80104592:	e8 f9 bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104597:	83 ec 0c             	sub    $0xc,%esp
8010459a:	68 7b 7d 10 80       	push   $0x80107d7b
8010459f:	e8 ec bd ff ff       	call   80100390 <panic>
801045a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop

801045b0 <yield>:
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	53                   	push   %ebx
801045b8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801045bb:	68 60 42 11 80       	push   $0x80114260
801045c0:	e8 7b 06 00 00       	call   80104c40 <acquire>
  pushcli();
801045c5:	e8 76 05 00 00       	call   80104b40 <pushcli>
  c = mycpu();
801045ca:	e8 e1 f9 ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
801045cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045d5:	e8 b6 05 00 00       	call   80104b90 <popcli>
  myproc()->state = RUNNABLE;
801045da:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045e1:	e8 ca fd ff ff       	call   801043b0 <sched>
  release(&ptable.lock);
801045e6:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
801045ed:	e8 0e 07 00 00       	call   80104d00 <release>
}
801045f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f5:	83 c4 10             	add    $0x10,%esp
801045f8:	c9                   	leave  
801045f9:	c3                   	ret    
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <sleep>:
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	57                   	push   %edi
80104608:	56                   	push   %esi
80104609:	53                   	push   %ebx
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104610:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104613:	e8 28 05 00 00       	call   80104b40 <pushcli>
  c = mycpu();
80104618:	e8 93 f9 ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
8010461d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104623:	e8 68 05 00 00       	call   80104b90 <popcli>
  if(p == 0)
80104628:	85 db                	test   %ebx,%ebx
8010462a:	0f 84 83 00 00 00    	je     801046b3 <sleep+0xb3>
  if(lk == 0)
80104630:	85 f6                	test   %esi,%esi
80104632:	74 72                	je     801046a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104634:	81 fe 60 42 11 80    	cmp    $0x80114260,%esi
8010463a:	74 4c                	je     80104688 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010463c:	83 ec 0c             	sub    $0xc,%esp
8010463f:	68 60 42 11 80       	push   $0x80114260
80104644:	e8 f7 05 00 00       	call   80104c40 <acquire>
    release(lk);
80104649:	89 34 24             	mov    %esi,(%esp)
8010464c:	e8 af 06 00 00       	call   80104d00 <release>
  p->chan = chan;
80104651:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104654:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010465b:	e8 50 fd ff ff       	call   801043b0 <sched>
  p->chan = 0;
80104660:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104667:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
8010466e:	e8 8d 06 00 00       	call   80104d00 <release>
    acquire(lk);
80104673:	89 75 08             	mov    %esi,0x8(%ebp)
80104676:	83 c4 10             	add    $0x10,%esp
}
80104679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010467c:	5b                   	pop    %ebx
8010467d:	5e                   	pop    %esi
8010467e:	5f                   	pop    %edi
8010467f:	5d                   	pop    %ebp
    acquire(lk);
80104680:	e9 bb 05 00 00       	jmp    80104c40 <acquire>
80104685:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104688:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010468b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104692:	e8 19 fd ff ff       	call   801043b0 <sched>
  p->chan = 0;
80104697:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010469e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046a1:	5b                   	pop    %ebx
801046a2:	5e                   	pop    %esi
801046a3:	5f                   	pop    %edi
801046a4:	5d                   	pop    %ebp
801046a5:	c3                   	ret    
    panic("sleep without lk");
801046a6:	83 ec 0c             	sub    $0xc,%esp
801046a9:	68 9a 7d 10 80       	push   $0x80107d9a
801046ae:	e8 dd bc ff ff       	call   80100390 <panic>
    panic("sleep");
801046b3:	83 ec 0c             	sub    $0xc,%esp
801046b6:	68 94 7d 10 80       	push   $0x80107d94
801046bb:	e8 d0 bc ff ff       	call   80100390 <panic>

801046c0 <wait>:
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	56                   	push   %esi
801046c8:	53                   	push   %ebx
  pushcli();
801046c9:	e8 72 04 00 00       	call   80104b40 <pushcli>
  c = mycpu();
801046ce:	e8 dd f8 ff ff       	call   80103fb0 <mycpu>
  p = c->proc;
801046d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046d9:	e8 b2 04 00 00       	call   80104b90 <popcli>
  acquire(&ptable.lock);
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	68 60 42 11 80       	push   $0x80114260
801046e6:	e8 55 05 00 00       	call   80104c40 <acquire>
801046eb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801046ee:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f0:	bb 94 42 11 80       	mov    $0x80114294,%ebx
801046f5:	eb 14                	jmp    8010470b <wait+0x4b>
801046f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fe:	66 90                	xchg   %ax,%ax
80104700:	83 c3 7c             	add    $0x7c,%ebx
80104703:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80104709:	74 1b                	je     80104726 <wait+0x66>
      if(p->parent != curproc)
8010470b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010470e:	75 f0                	jne    80104700 <wait+0x40>
      if(p->state == ZOMBIE){
80104710:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104714:	74 32                	je     80104748 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104716:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104719:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471e:	81 fb 94 61 11 80    	cmp    $0x80116194,%ebx
80104724:	75 e5                	jne    8010470b <wait+0x4b>
    if(!havekids || curproc->killed){
80104726:	85 c0                	test   %eax,%eax
80104728:	74 74                	je     8010479e <wait+0xde>
8010472a:	8b 46 24             	mov    0x24(%esi),%eax
8010472d:	85 c0                	test   %eax,%eax
8010472f:	75 6d                	jne    8010479e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104731:	83 ec 08             	sub    $0x8,%esp
80104734:	68 60 42 11 80       	push   $0x80114260
80104739:	56                   	push   %esi
8010473a:	e8 c1 fe ff ff       	call   80104600 <sleep>
    havekids = 0;
8010473f:	83 c4 10             	add    $0x10,%esp
80104742:	eb aa                	jmp    801046ee <wait+0x2e>
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010474e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104751:	e8 fa e3 ff ff       	call   80102b50 <kfree>
        freevm(p->pgdir);
80104756:	5a                   	pop    %edx
80104757:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010475a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104761:	e8 4a 2d 00 00       	call   801074b0 <freevm>
        release(&ptable.lock);
80104766:	c7 04 24 60 42 11 80 	movl   $0x80114260,(%esp)
        p->pid = 0;
8010476d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104774:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010477b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010477f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104786:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010478d:	e8 6e 05 00 00       	call   80104d00 <release>
        return pid;
80104792:	83 c4 10             	add    $0x10,%esp
}
80104795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104798:	89 f0                	mov    %esi,%eax
8010479a:	5b                   	pop    %ebx
8010479b:	5e                   	pop    %esi
8010479c:	5d                   	pop    %ebp
8010479d:	c3                   	ret    
      release(&ptable.lock);
8010479e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801047a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801047a6:	68 60 42 11 80       	push   $0x80114260
801047ab:	e8 50 05 00 00       	call   80104d00 <release>
      return -1;
801047b0:	83 c4 10             	add    $0x10,%esp
801047b3:	eb e0                	jmp    80104795 <wait+0xd5>
801047b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	53                   	push   %ebx
801047c8:	83 ec 10             	sub    $0x10,%esp
801047cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801047ce:	68 60 42 11 80       	push   $0x80114260
801047d3:	e8 68 04 00 00       	call   80104c40 <acquire>
801047d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047db:	b8 94 42 11 80       	mov    $0x80114294,%eax
801047e0:	eb 10                	jmp    801047f2 <wakeup+0x32>
801047e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047e8:	83 c0 7c             	add    $0x7c,%eax
801047eb:	3d 94 61 11 80       	cmp    $0x80116194,%eax
801047f0:	74 1c                	je     8010480e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801047f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047f6:	75 f0                	jne    801047e8 <wakeup+0x28>
801047f8:	3b 58 20             	cmp    0x20(%eax),%ebx
801047fb:	75 eb                	jne    801047e8 <wakeup+0x28>
      p->state = RUNNABLE;
801047fd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104804:	83 c0 7c             	add    $0x7c,%eax
80104807:	3d 94 61 11 80       	cmp    $0x80116194,%eax
8010480c:	75 e4                	jne    801047f2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010480e:	c7 45 08 60 42 11 80 	movl   $0x80114260,0x8(%ebp)
}
80104815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104818:	c9                   	leave  
  release(&ptable.lock);
80104819:	e9 e2 04 00 00       	jmp    80104d00 <release>
8010481e:	66 90                	xchg   %ax,%ax

80104820 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	53                   	push   %ebx
80104828:	83 ec 10             	sub    $0x10,%esp
8010482b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010482e:	68 60 42 11 80       	push   $0x80114260
80104833:	e8 08 04 00 00       	call   80104c40 <acquire>
80104838:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010483b:	b8 94 42 11 80       	mov    $0x80114294,%eax
80104840:	eb 10                	jmp    80104852 <kill+0x32>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104848:	83 c0 7c             	add    $0x7c,%eax
8010484b:	3d 94 61 11 80       	cmp    $0x80116194,%eax
80104850:	74 36                	je     80104888 <kill+0x68>
    if(p->pid == pid){
80104852:	39 58 10             	cmp    %ebx,0x10(%eax)
80104855:	75 f1                	jne    80104848 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104857:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010485b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104862:	75 07                	jne    8010486b <kill+0x4b>
        p->state = RUNNABLE;
80104864:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010486b:	83 ec 0c             	sub    $0xc,%esp
8010486e:	68 60 42 11 80       	push   $0x80114260
80104873:	e8 88 04 00 00       	call   80104d00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010487b:	83 c4 10             	add    $0x10,%esp
8010487e:	31 c0                	xor    %eax,%eax
}
80104880:	c9                   	leave  
80104881:	c3                   	ret    
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	68 60 42 11 80       	push   $0x80114260
80104890:	e8 6b 04 00 00       	call   80104d00 <release>
}
80104895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104898:	83 c4 10             	add    $0x10,%esp
8010489b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a0:	c9                   	leave  
801048a1:	c3                   	ret    
801048a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	57                   	push   %edi
801048b8:	56                   	push   %esi
801048b9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801048bc:	53                   	push   %ebx
801048bd:	bb 00 43 11 80       	mov    $0x80114300,%ebx
801048c2:	83 ec 3c             	sub    $0x3c,%esp
801048c5:	eb 28                	jmp    801048ef <procdump+0x3f>
801048c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ce:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048d0:	83 ec 0c             	sub    $0xc,%esp
801048d3:	68 17 81 10 80       	push   $0x80108117
801048d8:	e8 c3 be ff ff       	call   801007a0 <cprintf>
801048dd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048e0:	83 c3 7c             	add    $0x7c,%ebx
801048e3:	81 fb 00 62 11 80    	cmp    $0x80116200,%ebx
801048e9:	0f 84 81 00 00 00    	je     80104970 <procdump+0xc0>
    if(p->state == UNUSED)
801048ef:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048f2:	85 c0                	test   %eax,%eax
801048f4:	74 ea                	je     801048e0 <procdump+0x30>
      state = "???";
801048f6:	ba ab 7d 10 80       	mov    $0x80107dab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048fb:	83 f8 05             	cmp    $0x5,%eax
801048fe:	77 11                	ja     80104911 <procdump+0x61>
80104900:	8b 14 85 0c 7e 10 80 	mov    -0x7fef81f4(,%eax,4),%edx
      state = "???";
80104907:	b8 ab 7d 10 80       	mov    $0x80107dab,%eax
8010490c:	85 d2                	test   %edx,%edx
8010490e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104911:	53                   	push   %ebx
80104912:	52                   	push   %edx
80104913:	ff 73 a4             	pushl  -0x5c(%ebx)
80104916:	68 af 7d 10 80       	push   $0x80107daf
8010491b:	e8 80 be ff ff       	call   801007a0 <cprintf>
    if(p->state == SLEEPING){
80104920:	83 c4 10             	add    $0x10,%esp
80104923:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104927:	75 a7                	jne    801048d0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104929:	83 ec 08             	sub    $0x8,%esp
8010492c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010492f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104932:	50                   	push   %eax
80104933:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104936:	8b 40 0c             	mov    0xc(%eax),%eax
80104939:	83 c0 08             	add    $0x8,%eax
8010493c:	50                   	push   %eax
8010493d:	e8 9e 01 00 00       	call   80104ae0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104942:	83 c4 10             	add    $0x10,%esp
80104945:	8d 76 00             	lea    0x0(%esi),%esi
80104948:	8b 17                	mov    (%edi),%edx
8010494a:	85 d2                	test   %edx,%edx
8010494c:	74 82                	je     801048d0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010494e:	83 ec 08             	sub    $0x8,%esp
80104951:	83 c7 04             	add    $0x4,%edi
80104954:	52                   	push   %edx
80104955:	68 01 78 10 80       	push   $0x80107801
8010495a:	e8 41 be ff ff       	call   801007a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010495f:	83 c4 10             	add    $0x10,%esp
80104962:	39 fe                	cmp    %edi,%esi
80104964:	75 e2                	jne    80104948 <procdump+0x98>
80104966:	e9 65 ff ff ff       	jmp    801048d0 <procdump+0x20>
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop
  }
}
80104970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104973:	5b                   	pop    %ebx
80104974:	5e                   	pop    %esi
80104975:	5f                   	pop    %edi
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	53                   	push   %ebx
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010498e:	68 24 7e 10 80       	push   $0x80107e24
80104993:	8d 43 04             	lea    0x4(%ebx),%eax
80104996:	50                   	push   %eax
80104997:	e8 24 01 00 00       	call   80104ac0 <initlock>
  lk->name = name;
8010499c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010499f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b5:	c9                   	leave  
801049b6:	c3                   	ret    
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	56                   	push   %esi
801049c8:	53                   	push   %ebx
801049c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049cc:	8d 73 04             	lea    0x4(%ebx),%esi
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	56                   	push   %esi
801049d3:	e8 68 02 00 00       	call   80104c40 <acquire>
  while (lk->locked) {
801049d8:	8b 13                	mov    (%ebx),%edx
801049da:	83 c4 10             	add    $0x10,%esp
801049dd:	85 d2                	test   %edx,%edx
801049df:	74 1a                	je     801049fb <acquiresleep+0x3b>
801049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801049e8:	83 ec 08             	sub    $0x8,%esp
801049eb:	56                   	push   %esi
801049ec:	53                   	push   %ebx
801049ed:	e8 0e fc ff ff       	call   80104600 <sleep>
  while (lk->locked) {
801049f2:	8b 03                	mov    (%ebx),%eax
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	85 c0                	test   %eax,%eax
801049f9:	75 ed                	jne    801049e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801049fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a01:	e8 3a f6 ff ff       	call   80104040 <myproc>
80104a06:	8b 40 10             	mov    0x10(%eax),%eax
80104a09:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a0c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
  release(&lk->lk);
80104a15:	e9 e6 02 00 00       	jmp    80104d00 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	56                   	push   %esi
80104a28:	53                   	push   %ebx
80104a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	56                   	push   %esi
80104a33:	e8 08 02 00 00       	call   80104c40 <acquire>
  lk->locked = 0;
80104a38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a3e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a45:	89 1c 24             	mov    %ebx,(%esp)
80104a48:	e8 73 fd ff ff       	call   801047c0 <wakeup>
  release(&lk->lk);
80104a4d:	89 75 08             	mov    %esi,0x8(%ebp)
80104a50:	83 c4 10             	add    $0x10,%esp
}
80104a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a56:	5b                   	pop    %ebx
80104a57:	5e                   	pop    %esi
80104a58:	5d                   	pop    %ebp
  release(&lk->lk);
80104a59:	e9 a2 02 00 00       	jmp    80104d00 <release>
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	31 ff                	xor    %edi,%edi
80104a6a:	56                   	push   %esi
80104a6b:	53                   	push   %ebx
80104a6c:	83 ec 18             	sub    $0x18,%esp
80104a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a72:	8d 73 04             	lea    0x4(%ebx),%esi
80104a75:	56                   	push   %esi
80104a76:	e8 c5 01 00 00       	call   80104c40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a7b:	8b 03                	mov    (%ebx),%eax
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	85 c0                	test   %eax,%eax
80104a82:	75 1c                	jne    80104aa0 <holdingsleep+0x40>
  release(&lk->lk);
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	56                   	push   %esi
80104a88:	e8 73 02 00 00       	call   80104d00 <release>
  return r;
}
80104a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a90:	89 f8                	mov    %edi,%eax
80104a92:	5b                   	pop    %ebx
80104a93:	5e                   	pop    %esi
80104a94:	5f                   	pop    %edi
80104a95:	5d                   	pop    %ebp
80104a96:	c3                   	ret    
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104aa0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104aa3:	e8 98 f5 ff ff       	call   80104040 <myproc>
80104aa8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aab:	0f 94 c0             	sete   %al
80104aae:	0f b6 c0             	movzbl %al,%eax
80104ab1:	89 c7                	mov    %eax,%edi
80104ab3:	eb cf                	jmp    80104a84 <holdingsleep+0x24>
80104ab5:	66 90                	xchg   %ax,%ax
80104ab7:	66 90                	xchg   %ax,%ax
80104ab9:	66 90                	xchg   %ax,%ax
80104abb:	66 90                	xchg   %ax,%ax
80104abd:	66 90                	xchg   %ax,%ax
80104abf:	90                   	nop

80104ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ad3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104add:	5d                   	pop    %ebp
80104ade:	c3                   	ret    
80104adf:	90                   	nop

80104ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ae5:	31 d2                	xor    %edx,%edx
{
80104ae7:	89 e5                	mov    %esp,%ebp
80104ae9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aea:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104af0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104af3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104afe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b04:	77 1a                	ja     80104b20 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b06:	8b 58 04             	mov    0x4(%eax),%ebx
80104b09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b11:	83 fa 0a             	cmp    $0xa,%edx
80104b14:	75 e2                	jne    80104af8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b16:	5b                   	pop    %ebx
80104b17:	5d                   	pop    %ebp
80104b18:	c3                   	ret    
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b23:	8d 51 28             	lea    0x28(%ecx),%edx
80104b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b36:	83 c0 04             	add    $0x4,%eax
80104b39:	39 d0                	cmp    %edx,%eax
80104b3b:	75 f3                	jne    80104b30 <getcallerpcs+0x50>
}
80104b3d:	5b                   	pop    %ebx
80104b3e:	5d                   	pop    %ebp
80104b3f:	c3                   	ret    

80104b40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	53                   	push   %ebx
80104b48:	83 ec 04             	sub    $0x4,%esp
80104b4b:	9c                   	pushf  
80104b4c:	5b                   	pop    %ebx
  asm volatile("cli");
80104b4d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b4e:	e8 5d f4 ff ff       	call   80103fb0 <mycpu>
80104b53:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	74 13                	je     80104b70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b5d:	e8 4e f4 ff ff       	call   80103fb0 <mycpu>
80104b62:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b69:	83 c4 04             	add    $0x4,%esp
80104b6c:	5b                   	pop    %ebx
80104b6d:	5d                   	pop    %ebp
80104b6e:	c3                   	ret    
80104b6f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104b70:	e8 3b f4 ff ff       	call   80103fb0 <mycpu>
80104b75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b81:	eb da                	jmp    80104b5d <pushcli+0x1d>
80104b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <popcli>:

void
popcli(void)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b9a:	9c                   	pushf  
80104b9b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b9c:	f6 c4 02             	test   $0x2,%ah
80104b9f:	75 31                	jne    80104bd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ba1:	e8 0a f4 ff ff       	call   80103fb0 <mycpu>
80104ba6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bad:	78 30                	js     80104bdf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104baf:	e8 fc f3 ff ff       	call   80103fb0 <mycpu>
80104bb4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bba:	85 d2                	test   %edx,%edx
80104bbc:	74 02                	je     80104bc0 <popcli+0x30>
    sti();
}
80104bbe:	c9                   	leave  
80104bbf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bc0:	e8 eb f3 ff ff       	call   80103fb0 <mycpu>
80104bc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bcb:	85 c0                	test   %eax,%eax
80104bcd:	74 ef                	je     80104bbe <popcli+0x2e>
  asm volatile("sti");
80104bcf:	fb                   	sti    
}
80104bd0:	c9                   	leave  
80104bd1:	c3                   	ret    
    panic("popcli - interruptible");
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	68 2f 7e 10 80       	push   $0x80107e2f
80104bda:	e8 b1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	68 46 7e 10 80       	push   $0x80107e46
80104be7:	e8 a4 b7 ff ff       	call   80100390 <panic>
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <holding>:
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	56                   	push   %esi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bfc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bfe:	e8 3d ff ff ff       	call   80104b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c03:	8b 06                	mov    (%esi),%eax
80104c05:	85 c0                	test   %eax,%eax
80104c07:	75 0f                	jne    80104c18 <holding+0x28>
  popcli();
80104c09:	e8 82 ff ff ff       	call   80104b90 <popcli>
}
80104c0e:	89 d8                	mov    %ebx,%eax
80104c10:	5b                   	pop    %ebx
80104c11:	5e                   	pop    %esi
80104c12:	5d                   	pop    %ebp
80104c13:	c3                   	ret    
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c18:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c1b:	e8 90 f3 ff ff       	call   80103fb0 <mycpu>
80104c20:	39 c3                	cmp    %eax,%ebx
80104c22:	0f 94 c3             	sete   %bl
  popcli();
80104c25:	e8 66 ff ff ff       	call   80104b90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c2a:	0f b6 db             	movzbl %bl,%ebx
}
80104c2d:	89 d8                	mov    %ebx,%eax
80104c2f:	5b                   	pop    %ebx
80104c30:	5e                   	pop    %esi
80104c31:	5d                   	pop    %ebp
80104c32:	c3                   	ret    
80104c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c40 <acquire>:
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c49:	e8 f2 fe ff ff       	call   80104b40 <pushcli>
  if(holding(lk))
80104c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c51:	83 ec 0c             	sub    $0xc,%esp
80104c54:	53                   	push   %ebx
80104c55:	e8 96 ff ff ff       	call   80104bf0 <holding>
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	0f 85 7f 00 00 00    	jne    80104ce4 <acquire+0xa4>
80104c65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c67:	ba 01 00 00 00       	mov    $0x1,%edx
80104c6c:	eb 05                	jmp    80104c73 <acquire+0x33>
80104c6e:	66 90                	xchg   %ax,%ax
80104c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c73:	89 d0                	mov    %edx,%eax
80104c75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c78:	85 c0                	test   %eax,%eax
80104c7a:	75 f4                	jne    80104c70 <acquire+0x30>
  __sync_synchronize();
80104c7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c84:	e8 27 f3 ff ff       	call   80103fb0 <mycpu>
80104c89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c8c:	89 e8                	mov    %ebp,%eax
80104c8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104c96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104c9c:	77 22                	ja     80104cc0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c9e:	8b 50 04             	mov    0x4(%eax),%edx
80104ca1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ca5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ca8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104caa:	83 fe 0a             	cmp    $0xa,%esi
80104cad:	75 e1                	jne    80104c90 <acquire+0x50>
}
80104caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb2:	5b                   	pop    %ebx
80104cb3:	5e                   	pop    %esi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104cc0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104cc4:	83 c3 34             	add    $0x34,%ebx
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cd6:	83 c0 04             	add    $0x4,%eax
80104cd9:	39 d8                	cmp    %ebx,%eax
80104cdb:	75 f3                	jne    80104cd0 <acquire+0x90>
}
80104cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce0:	5b                   	pop    %ebx
80104ce1:	5e                   	pop    %esi
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
    panic("acquire");
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	68 4d 7e 10 80       	push   $0x80107e4d
80104cec:	e8 9f b6 ff ff       	call   80100390 <panic>
80104cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop

80104d00 <release>:
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	53                   	push   %ebx
80104d08:	83 ec 10             	sub    $0x10,%esp
80104d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d0e:	53                   	push   %ebx
80104d0f:	e8 dc fe ff ff       	call   80104bf0 <holding>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	74 22                	je     80104d3d <release+0x3d>
  lk->pcs[0] = 0;
80104d1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d37:	c9                   	leave  
  popcli();
80104d38:	e9 53 fe ff ff       	jmp    80104b90 <popcli>
    panic("release");
80104d3d:	83 ec 0c             	sub    $0xc,%esp
80104d40:	68 55 7e 10 80       	push   $0x80107e55
80104d45:	e8 46 b6 ff ff       	call   80100390 <panic>
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	8b 55 08             	mov    0x8(%ebp),%edx
80104d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d5e:	53                   	push   %ebx
80104d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104d62:	89 d7                	mov    %edx,%edi
80104d64:	09 cf                	or     %ecx,%edi
80104d66:	83 e7 03             	and    $0x3,%edi
80104d69:	75 25                	jne    80104d90 <memset+0x40>
    c &= 0xFF;
80104d6b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d6e:	c1 e0 18             	shl    $0x18,%eax
80104d71:	89 fb                	mov    %edi,%ebx
80104d73:	c1 e9 02             	shr    $0x2,%ecx
80104d76:	c1 e3 10             	shl    $0x10,%ebx
80104d79:	09 d8                	or     %ebx,%eax
80104d7b:	09 f8                	or     %edi,%eax
80104d7d:	c1 e7 08             	shl    $0x8,%edi
80104d80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d82:	89 d7                	mov    %edx,%edi
80104d84:	fc                   	cld    
80104d85:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d87:	5b                   	pop    %ebx
80104d88:	89 d0                	mov    %edx,%eax
80104d8a:	5f                   	pop    %edi
80104d8b:	5d                   	pop    %ebp
80104d8c:	c3                   	ret    
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104d90:	89 d7                	mov    %edx,%edi
80104d92:	fc                   	cld    
80104d93:	f3 aa                	rep stos %al,%es:(%edi)
80104d95:	5b                   	pop    %ebx
80104d96:	89 d0                	mov    %edx,%eax
80104d98:	5f                   	pop    %edi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d9f:	90                   	nop

80104da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	8b 75 10             	mov    0x10(%ebp),%esi
80104dab:	8b 55 08             	mov    0x8(%ebp),%edx
80104dae:	53                   	push   %ebx
80104daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104db2:	85 f6                	test   %esi,%esi
80104db4:	74 2a                	je     80104de0 <memcmp+0x40>
80104db6:	01 c6                	add    %eax,%esi
80104db8:	eb 10                	jmp    80104dca <memcmp+0x2a>
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104dc0:	83 c0 01             	add    $0x1,%eax
80104dc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104dc6:	39 f0                	cmp    %esi,%eax
80104dc8:	74 16                	je     80104de0 <memcmp+0x40>
    if(*s1 != *s2)
80104dca:	0f b6 0a             	movzbl (%edx),%ecx
80104dcd:	0f b6 18             	movzbl (%eax),%ebx
80104dd0:	38 d9                	cmp    %bl,%cl
80104dd2:	74 ec                	je     80104dc0 <memcmp+0x20>
      return *s1 - *s2;
80104dd4:	0f b6 c1             	movzbl %cl,%eax
80104dd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104dd9:	5b                   	pop    %ebx
80104dda:	5e                   	pop    %esi
80104ddb:	5d                   	pop    %ebp
80104ddc:	c3                   	ret    
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
80104de0:	5b                   	pop    %ebx
  return 0;
80104de1:	31 c0                	xor    %eax,%eax
}
80104de3:	5e                   	pop    %esi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi

80104df0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	57                   	push   %edi
80104df8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dfe:	56                   	push   %esi
80104dff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e02:	39 d6                	cmp    %edx,%esi
80104e04:	73 2a                	jae    80104e30 <memmove+0x40>
80104e06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e09:	39 fa                	cmp    %edi,%edx
80104e0b:	73 23                	jae    80104e30 <memmove+0x40>
80104e0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e10:	85 c9                	test   %ecx,%ecx
80104e12:	74 13                	je     80104e27 <memmove+0x37>
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e1f:	83 e8 01             	sub    $0x1,%eax
80104e22:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e25:	75 f1                	jne    80104e18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e27:	5e                   	pop    %esi
80104e28:	89 d0                	mov    %edx,%eax
80104e2a:	5f                   	pop    %edi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e33:	89 d7                	mov    %edx,%edi
80104e35:	85 c9                	test   %ecx,%ecx
80104e37:	74 ee                	je     80104e27 <memmove+0x37>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e41:	39 f0                	cmp    %esi,%eax
80104e43:	75 fb                	jne    80104e40 <memmove+0x50>
}
80104e45:	5e                   	pop    %esi
80104e46:	89 d0                	mov    %edx,%eax
80104e48:	5f                   	pop    %edi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e50:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104e54:	eb 9a                	jmp    80104df0 <memmove>
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	56                   	push   %esi
80104e68:	8b 75 10             	mov    0x10(%ebp),%esi
80104e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e6e:	53                   	push   %ebx
80104e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104e72:	85 f6                	test   %esi,%esi
80104e74:	74 32                	je     80104ea8 <strncmp+0x48>
80104e76:	01 c6                	add    %eax,%esi
80104e78:	eb 14                	jmp    80104e8e <strncmp+0x2e>
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e80:	38 da                	cmp    %bl,%dl
80104e82:	75 14                	jne    80104e98 <strncmp+0x38>
    n--, p++, q++;
80104e84:	83 c0 01             	add    $0x1,%eax
80104e87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e8a:	39 f0                	cmp    %esi,%eax
80104e8c:	74 1a                	je     80104ea8 <strncmp+0x48>
80104e8e:	0f b6 11             	movzbl (%ecx),%edx
80104e91:	0f b6 18             	movzbl (%eax),%ebx
80104e94:	84 d2                	test   %dl,%dl
80104e96:	75 e8                	jne    80104e80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e98:	0f b6 c2             	movzbl %dl,%eax
80104e9b:	29 d8                	sub    %ebx,%eax
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	5b                   	pop    %ebx
    return 0;
80104ea9:	31 c0                	xor    %eax,%eax
}
80104eab:	5e                   	pop    %esi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	57                   	push   %edi
80104eb8:	56                   	push   %esi
80104eb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ebc:	53                   	push   %ebx
80104ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ec0:	89 f2                	mov    %esi,%edx
80104ec2:	eb 1b                	jmp    80104edf <strncpy+0x2f>
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ecc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ecf:	83 c2 01             	add    $0x1,%edx
80104ed2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104ed6:	89 f9                	mov    %edi,%ecx
80104ed8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104edb:	84 c9                	test   %cl,%cl
80104edd:	74 09                	je     80104ee8 <strncpy+0x38>
80104edf:	89 c3                	mov    %eax,%ebx
80104ee1:	83 e8 01             	sub    $0x1,%eax
80104ee4:	85 db                	test   %ebx,%ebx
80104ee6:	7f e0                	jg     80104ec8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ee8:	89 d1                	mov    %edx,%ecx
80104eea:	85 c0                	test   %eax,%eax
80104eec:	7e 15                	jle    80104f03 <strncpy+0x53>
80104eee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104ef0:	83 c1 01             	add    $0x1,%ecx
80104ef3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ef7:	89 c8                	mov    %ecx,%eax
80104ef9:	f7 d0                	not    %eax
80104efb:	01 d0                	add    %edx,%eax
80104efd:	01 d8                	add    %ebx,%eax
80104eff:	85 c0                	test   %eax,%eax
80104f01:	7f ed                	jg     80104ef0 <strncpy+0x40>
  return os;
}
80104f03:	5b                   	pop    %ebx
80104f04:	89 f0                	mov    %esi,%eax
80104f06:	5e                   	pop    %esi
80104f07:	5f                   	pop    %edi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	56                   	push   %esi
80104f18:	8b 55 10             	mov    0x10(%ebp),%edx
80104f1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f1e:	53                   	push   %ebx
80104f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f22:	85 d2                	test   %edx,%edx
80104f24:	7e 21                	jle    80104f47 <safestrcpy+0x37>
80104f26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f2a:	89 f2                	mov    %esi,%edx
80104f2c:	eb 12                	jmp    80104f40 <safestrcpy+0x30>
80104f2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f30:	0f b6 08             	movzbl (%eax),%ecx
80104f33:	83 c0 01             	add    $0x1,%eax
80104f36:	83 c2 01             	add    $0x1,%edx
80104f39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f3c:	84 c9                	test   %cl,%cl
80104f3e:	74 04                	je     80104f44 <safestrcpy+0x34>
80104f40:	39 d8                	cmp    %ebx,%eax
80104f42:	75 ec                	jne    80104f30 <safestrcpy+0x20>
    ;
  *s = 0;
80104f44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f47:	89 f0                	mov    %esi,%eax
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5d                   	pop    %ebp
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <strlen>:

int
strlen(const char *s)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f55:	31 c0                	xor    %eax,%eax
{
80104f57:	89 e5                	mov    %esp,%ebp
80104f59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104f5f:	74 10                	je     80104f71 <strlen+0x21>
80104f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f68:	83 c0 01             	add    $0x1,%eax
80104f6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f6f:	75 f7                	jne    80104f68 <strlen+0x18>
    ;
  return n;
}
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret    

80104f73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f7b:	55                   	push   %ebp
  pushl %ebx
80104f7c:	53                   	push   %ebx
  pushl %esi
80104f7d:	56                   	push   %esi
  pushl %edi
80104f7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f83:	5f                   	pop    %edi
  popl %esi
80104f84:	5e                   	pop    %esi
  popl %ebx
80104f85:	5b                   	pop    %ebx
  popl %ebp
80104f86:	5d                   	pop    %ebp
  ret
80104f87:	c3                   	ret    
80104f88:	66 90                	xchg   %ax,%ax
80104f8a:	66 90                	xchg   %ax,%ax
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	53                   	push   %ebx
80104f98:	83 ec 04             	sub    $0x4,%esp
80104f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f9e:	e8 9d f0 ff ff       	call   80104040 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fa3:	8b 00                	mov    (%eax),%eax
80104fa5:	39 d8                	cmp    %ebx,%eax
80104fa7:	76 17                	jbe    80104fc0 <fetchint+0x30>
80104fa9:	8d 53 04             	lea    0x4(%ebx),%edx
80104fac:	39 d0                	cmp    %edx,%eax
80104fae:	72 10                	jb     80104fc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fb3:	8b 13                	mov    (%ebx),%edx
80104fb5:	89 10                	mov    %edx,(%eax)
  return 0;
80104fb7:	31 c0                	xor    %eax,%eax
}
80104fb9:	83 c4 04             	add    $0x4,%esp
80104fbc:	5b                   	pop    %ebx
80104fbd:	5d                   	pop    %ebp
80104fbe:	c3                   	ret    
80104fbf:	90                   	nop
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb f2                	jmp    80104fb9 <fetchint+0x29>
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	53                   	push   %ebx
80104fd8:	83 ec 04             	sub    $0x4,%esp
80104fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fde:	e8 5d f0 ff ff       	call   80104040 <myproc>

  if(addr >= curproc->sz)
80104fe3:	39 18                	cmp    %ebx,(%eax)
80104fe5:	76 31                	jbe    80105018 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104fee:	39 d3                	cmp    %edx,%ebx
80104ff0:	73 26                	jae    80105018 <fetchstr+0x48>
80104ff2:	89 d8                	mov    %ebx,%eax
80104ff4:	eb 11                	jmp    80105007 <fetchstr+0x37>
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
80105000:	83 c0 01             	add    $0x1,%eax
80105003:	39 c2                	cmp    %eax,%edx
80105005:	76 11                	jbe    80105018 <fetchstr+0x48>
    if(*s == 0)
80105007:	80 38 00             	cmpb   $0x0,(%eax)
8010500a:	75 f4                	jne    80105000 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010500c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010500f:	29 d8                	sub    %ebx,%eax
}
80105011:	5b                   	pop    %ebx
80105012:	5d                   	pop    %ebp
80105013:	c3                   	ret    
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	83 c4 04             	add    $0x4,%esp
    return -1;
8010501b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105020:	5b                   	pop    %ebx
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105030 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	56                   	push   %esi
80105038:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105039:	e8 02 f0 ff ff       	call   80104040 <myproc>
8010503e:	8b 55 08             	mov    0x8(%ebp),%edx
80105041:	8b 40 18             	mov    0x18(%eax),%eax
80105044:	8b 40 44             	mov    0x44(%eax),%eax
80105047:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010504a:	e8 f1 ef ff ff       	call   80104040 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010504f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105052:	8b 00                	mov    (%eax),%eax
80105054:	39 c6                	cmp    %eax,%esi
80105056:	73 18                	jae    80105070 <argint+0x40>
80105058:	8d 53 08             	lea    0x8(%ebx),%edx
8010505b:	39 d0                	cmp    %edx,%eax
8010505d:	72 11                	jb     80105070 <argint+0x40>
  *ip = *(int*)(addr);
8010505f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105062:	8b 53 04             	mov    0x4(%ebx),%edx
80105065:	89 10                	mov    %edx,(%eax)
  return 0;
80105067:	31 c0                	xor    %eax,%eax
}
80105069:	5b                   	pop    %ebx
8010506a:	5e                   	pop    %esi
8010506b:	5d                   	pop    %ebp
8010506c:	c3                   	ret    
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105075:	eb f2                	jmp    80105069 <argint+0x39>
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax

80105080 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	56                   	push   %esi
80105088:	53                   	push   %ebx
80105089:	83 ec 10             	sub    $0x10,%esp
8010508c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010508f:	e8 ac ef ff ff       	call   80104040 <myproc>
 
  if(argint(n, &i) < 0)
80105094:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105097:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105099:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010509c:	50                   	push   %eax
8010509d:	ff 75 08             	pushl  0x8(%ebp)
801050a0:	e8 8b ff ff ff       	call   80105030 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	85 c0                	test   %eax,%eax
801050aa:	78 24                	js     801050d0 <argptr+0x50>
801050ac:	85 db                	test   %ebx,%ebx
801050ae:	78 20                	js     801050d0 <argptr+0x50>
801050b0:	8b 16                	mov    (%esi),%edx
801050b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b5:	39 c2                	cmp    %eax,%edx
801050b7:	76 17                	jbe    801050d0 <argptr+0x50>
801050b9:	01 c3                	add    %eax,%ebx
801050bb:	39 da                	cmp    %ebx,%edx
801050bd:	72 11                	jb     801050d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801050c2:	89 02                	mov    %eax,(%edx)
  return 0;
801050c4:	31 c0                	xor    %eax,%eax
}
801050c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d5:	eb ef                	jmp    801050c6 <argptr+0x46>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ed:	50                   	push   %eax
801050ee:	ff 75 08             	pushl  0x8(%ebp)
801050f1:	e8 3a ff ff ff       	call   80105030 <argint>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	78 13                	js     80105110 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050fd:	83 ec 08             	sub    $0x8,%esp
80105100:	ff 75 0c             	pushl  0xc(%ebp)
80105103:	ff 75 f4             	pushl  -0xc(%ebp)
80105106:	e8 c5 fe ff ff       	call   80104fd0 <fetchstr>
8010510b:	83 c4 10             	add    $0x10,%esp
}
8010510e:	c9                   	leave  
8010510f:	c3                   	ret    
80105110:	c9                   	leave  
    return -1;
80105111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105116:	c3                   	ret    
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	53                   	push   %ebx
80105128:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010512b:	e8 10 ef ff ff       	call   80104040 <myproc>
80105130:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105132:	8b 40 18             	mov    0x18(%eax),%eax
80105135:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105138:	8d 50 ff             	lea    -0x1(%eax),%edx
8010513b:	83 fa 14             	cmp    $0x14,%edx
8010513e:	77 20                	ja     80105160 <syscall+0x40>
80105140:	8b 14 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%edx
80105147:	85 d2                	test   %edx,%edx
80105149:	74 15                	je     80105160 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010514b:	ff d2                	call   *%edx
8010514d:	89 c2                	mov    %eax,%edx
8010514f:	8b 43 18             	mov    0x18(%ebx),%eax
80105152:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105160:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105161:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105164:	50                   	push   %eax
80105165:	ff 73 10             	pushl  0x10(%ebx)
80105168:	68 5d 7e 10 80       	push   $0x80107e5d
8010516d:	e8 2e b6 ff ff       	call   801007a0 <cprintf>
    curproc->tf->eax = -1;
80105172:	8b 43 18             	mov    0x18(%ebx),%eax
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010517f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105182:	c9                   	leave  
80105183:	c3                   	ret    
80105184:	66 90                	xchg   %ax,%ax
80105186:	66 90                	xchg   %ax,%ax
80105188:	66 90                	xchg   %ax,%ax
8010518a:	66 90                	xchg   %ax,%ax
8010518c:	66 90                	xchg   %ax,%ax
8010518e:	66 90                	xchg   %ax,%ax

80105190 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105195:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105198:	53                   	push   %ebx
80105199:	83 ec 34             	sub    $0x34,%esp
8010519c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010519f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051a2:	57                   	push   %edi
801051a3:	50                   	push   %eax
{
801051a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051aa:	e8 81 d5 ff ff       	call   80102730 <nameiparent>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 84 46 01 00 00    	je     80105300 <create+0x170>
    return 0;
  ilock(dp);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	89 c3                	mov    %eax,%ebx
801051bf:	50                   	push   %eax
801051c0:	e8 7b cc ff ff       	call   80101e40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051c5:	83 c4 0c             	add    $0xc,%esp
801051c8:	6a 00                	push   $0x0
801051ca:	57                   	push   %edi
801051cb:	53                   	push   %ebx
801051cc:	e8 bf d1 ff ff       	call   80102390 <dirlookup>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	89 c6                	mov    %eax,%esi
801051d6:	85 c0                	test   %eax,%eax
801051d8:	74 56                	je     80105230 <create+0xa0>
    iunlockput(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	53                   	push   %ebx
801051de:	e8 fd ce ff ff       	call   801020e0 <iunlockput>
    ilock(ip);
801051e3:	89 34 24             	mov    %esi,(%esp)
801051e6:	e8 55 cc ff ff       	call   80101e40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051eb:	83 c4 10             	add    $0x10,%esp
801051ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051f3:	75 1b                	jne    80105210 <create+0x80>
801051f5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801051fa:	75 14                	jne    80105210 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ff:	89 f0                	mov    %esi,%eax
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5f                   	pop    %edi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	56                   	push   %esi
    return 0;
80105214:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105216:	e8 c5 ce ff ff       	call   801020e0 <iunlockput>
    return 0;
8010521b:	83 c4 10             	add    $0x10,%esp
}
8010521e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105221:	89 f0                	mov    %esi,%eax
80105223:	5b                   	pop    %ebx
80105224:	5e                   	pop    %esi
80105225:	5f                   	pop    %edi
80105226:	5d                   	pop    %ebp
80105227:	c3                   	ret    
80105228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105230:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	50                   	push   %eax
80105238:	ff 33                	pushl  (%ebx)
8010523a:	e8 81 ca ff ff       	call   80101cc0 <ialloc>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	89 c6                	mov    %eax,%esi
80105244:	85 c0                	test   %eax,%eax
80105246:	0f 84 cd 00 00 00    	je     80105319 <create+0x189>
  ilock(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	50                   	push   %eax
80105250:	e8 eb cb ff ff       	call   80101e40 <ilock>
  ip->major = major;
80105255:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105259:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010525d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105261:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105265:	b8 01 00 00 00       	mov    $0x1,%eax
8010526a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010526e:	89 34 24             	mov    %esi,(%esp)
80105271:	e8 0a cb ff ff       	call   80101d80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010527e:	74 30                	je     801052b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105280:	83 ec 04             	sub    $0x4,%esp
80105283:	ff 76 04             	pushl  0x4(%esi)
80105286:	57                   	push   %edi
80105287:	53                   	push   %ebx
80105288:	e8 c3 d3 ff ff       	call   80102650 <dirlink>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 78                	js     8010530c <create+0x17c>
  iunlockput(dp);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	53                   	push   %ebx
80105298:	e8 43 ce ff ff       	call   801020e0 <iunlockput>
  return ip;
8010529d:	83 c4 10             	add    $0x10,%esp
}
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a3:	89 f0                	mov    %esi,%eax
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5f                   	pop    %edi
801052a8:	5d                   	pop    %ebp
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801052b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052b8:	53                   	push   %ebx
801052b9:	e8 c2 ca ff ff       	call   80101d80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052be:	83 c4 0c             	add    $0xc,%esp
801052c1:	ff 76 04             	pushl  0x4(%esi)
801052c4:	68 f4 7e 10 80       	push   $0x80107ef4
801052c9:	56                   	push   %esi
801052ca:	e8 81 d3 ff ff       	call   80102650 <dirlink>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	78 18                	js     801052ee <create+0x15e>
801052d6:	83 ec 04             	sub    $0x4,%esp
801052d9:	ff 73 04             	pushl  0x4(%ebx)
801052dc:	68 f3 7e 10 80       	push   $0x80107ef3
801052e1:	56                   	push   %esi
801052e2:	e8 69 d3 ff ff       	call   80102650 <dirlink>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	79 92                	jns    80105280 <create+0xf0>
      panic("create dots");
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	68 e7 7e 10 80       	push   $0x80107ee7
801052f6:	e8 95 b0 ff ff       	call   80100390 <panic>
801052fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop
}
80105300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105303:	31 f6                	xor    %esi,%esi
}
80105305:	5b                   	pop    %ebx
80105306:	89 f0                	mov    %esi,%eax
80105308:	5e                   	pop    %esi
80105309:	5f                   	pop    %edi
8010530a:	5d                   	pop    %ebp
8010530b:	c3                   	ret    
    panic("create: dirlink");
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	68 f6 7e 10 80       	push   $0x80107ef6
80105314:	e8 77 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	68 d8 7e 10 80       	push   $0x80107ed8
80105321:	e8 6a b0 ff ff       	call   80100390 <panic>
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	89 d6                	mov    %edx,%esi
80105336:	53                   	push   %ebx
80105337:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105339:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010533c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010533f:	50                   	push   %eax
80105340:	6a 00                	push   $0x0
80105342:	e8 e9 fc ff ff       	call   80105030 <argint>
80105347:	83 c4 10             	add    $0x10,%esp
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 2a                	js     80105378 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010534e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105352:	77 24                	ja     80105378 <argfd.constprop.0+0x48>
80105354:	e8 e7 ec ff ff       	call   80104040 <myproc>
80105359:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010535c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105360:	85 c0                	test   %eax,%eax
80105362:	74 14                	je     80105378 <argfd.constprop.0+0x48>
  if(pfd)
80105364:	85 db                	test   %ebx,%ebx
80105366:	74 02                	je     8010536a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105368:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010536a:	89 06                	mov    %eax,(%esi)
  return 0;
8010536c:	31 c0                	xor    %eax,%eax
}
8010536e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105371:	5b                   	pop    %ebx
80105372:	5e                   	pop    %esi
80105373:	5d                   	pop    %ebp
80105374:	c3                   	ret    
80105375:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537d:	eb ef                	jmp    8010536e <argfd.constprop.0+0x3e>
8010537f:	90                   	nop

80105380 <sys_dup>:
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105385:	31 c0                	xor    %eax,%eax
{
80105387:	89 e5                	mov    %esp,%ebp
80105389:	56                   	push   %esi
8010538a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010538b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010538e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105391:	e8 9a ff ff ff       	call   80105330 <argfd.constprop.0>
80105396:	85 c0                	test   %eax,%eax
80105398:	78 1e                	js     801053b8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010539a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010539d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010539f:	e8 9c ec ff ff       	call   80104040 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053a8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053ac:	85 d2                	test   %edx,%edx
801053ae:	74 20                	je     801053d0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801053b0:	83 c3 01             	add    $0x1,%ebx
801053b3:	83 fb 10             	cmp    $0x10,%ebx
801053b6:	75 f0                	jne    801053a8 <sys_dup+0x28>
}
801053b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053c0:	89 d8                	mov    %ebx,%eax
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801053d0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	ff 75 f4             	pushl  -0xc(%ebp)
801053da:	e8 71 c1 ff ff       	call   80101550 <filedup>
  return fd;
801053df:	83 c4 10             	add    $0x10,%esp
}
801053e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053e5:	89 d8                	mov    %ebx,%eax
801053e7:	5b                   	pop    %ebx
801053e8:	5e                   	pop    %esi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop

801053f0 <sys_read>:
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053f5:	31 c0                	xor    %eax,%eax
{
801053f7:	89 e5                	mov    %esp,%ebp
801053f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053ff:	e8 2c ff ff ff       	call   80105330 <argfd.constprop.0>
80105404:	85 c0                	test   %eax,%eax
80105406:	78 48                	js     80105450 <sys_read+0x60>
80105408:	83 ec 08             	sub    $0x8,%esp
8010540b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010540e:	50                   	push   %eax
8010540f:	6a 02                	push   $0x2
80105411:	e8 1a fc ff ff       	call   80105030 <argint>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 33                	js     80105450 <sys_read+0x60>
8010541d:	83 ec 04             	sub    $0x4,%esp
80105420:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105423:	ff 75 f0             	pushl  -0x10(%ebp)
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 52 fc ff ff       	call   80105080 <argptr>
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 1b                	js     80105450 <sys_read+0x60>
  return fileread(f, p, n);
80105435:	83 ec 04             	sub    $0x4,%esp
80105438:	ff 75 f0             	pushl  -0x10(%ebp)
8010543b:	ff 75 f4             	pushl  -0xc(%ebp)
8010543e:	ff 75 ec             	pushl  -0x14(%ebp)
80105441:	e8 8a c2 ff ff       	call   801016d0 <fileread>
80105446:	83 c4 10             	add    $0x10,%esp
}
80105449:	c9                   	leave  
8010544a:	c3                   	ret    
8010544b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010544f:	90                   	nop
80105450:	c9                   	leave  
    return -1;
80105451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105456:	c3                   	ret    
80105457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545e:	66 90                	xchg   %ax,%ax

80105460 <sys_write>:
{
80105460:	f3 0f 1e fb          	endbr32 
80105464:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105465:	31 c0                	xor    %eax,%eax
{
80105467:	89 e5                	mov    %esp,%ebp
80105469:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010546c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010546f:	e8 bc fe ff ff       	call   80105330 <argfd.constprop.0>
80105474:	85 c0                	test   %eax,%eax
80105476:	78 48                	js     801054c0 <sys_write+0x60>
80105478:	83 ec 08             	sub    $0x8,%esp
8010547b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547e:	50                   	push   %eax
8010547f:	6a 02                	push   $0x2
80105481:	e8 aa fb ff ff       	call   80105030 <argint>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 33                	js     801054c0 <sys_write+0x60>
8010548d:	83 ec 04             	sub    $0x4,%esp
80105490:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105493:	ff 75 f0             	pushl  -0x10(%ebp)
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 e2 fb ff ff       	call   80105080 <argptr>
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 1b                	js     801054c0 <sys_write+0x60>
  return filewrite(f, p, n);
801054a5:	83 ec 04             	sub    $0x4,%esp
801054a8:	ff 75 f0             	pushl  -0x10(%ebp)
801054ab:	ff 75 f4             	pushl  -0xc(%ebp)
801054ae:	ff 75 ec             	pushl  -0x14(%ebp)
801054b1:	e8 ba c2 ff ff       	call   80101770 <filewrite>
801054b6:	83 c4 10             	add    $0x10,%esp
}
801054b9:	c9                   	leave  
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop
801054c0:	c9                   	leave  
    return -1;
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c6:	c3                   	ret    
801054c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <sys_close>:
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801054da:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e0:	e8 4b fe ff ff       	call   80105330 <argfd.constprop.0>
801054e5:	85 c0                	test   %eax,%eax
801054e7:	78 27                	js     80105510 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054e9:	e8 52 eb ff ff       	call   80104040 <myproc>
801054ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054f1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054f4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054fb:	00 
  fileclose(f);
801054fc:	ff 75 f4             	pushl  -0xc(%ebp)
801054ff:	e8 9c c0 ff ff       	call   801015a0 <fileclose>
  return 0;
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	31 c0                	xor    %eax,%eax
}
80105509:	c9                   	leave  
8010550a:	c3                   	ret    
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
80105510:	c9                   	leave  
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105516:	c3                   	ret    
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_fstat>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105525:	31 c0                	xor    %eax,%eax
{
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010552c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010552f:	e8 fc fd ff ff       	call   80105330 <argfd.constprop.0>
80105534:	85 c0                	test   %eax,%eax
80105536:	78 30                	js     80105568 <sys_fstat+0x48>
80105538:	83 ec 04             	sub    $0x4,%esp
8010553b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553e:	6a 14                	push   $0x14
80105540:	50                   	push   %eax
80105541:	6a 01                	push   $0x1
80105543:	e8 38 fb ff ff       	call   80105080 <argptr>
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	85 c0                	test   %eax,%eax
8010554d:	78 19                	js     80105568 <sys_fstat+0x48>
  return filestat(f, st);
8010554f:	83 ec 08             	sub    $0x8,%esp
80105552:	ff 75 f4             	pushl  -0xc(%ebp)
80105555:	ff 75 f0             	pushl  -0x10(%ebp)
80105558:	e8 23 c1 ff ff       	call   80101680 <filestat>
8010555d:	83 c4 10             	add    $0x10,%esp
}
80105560:	c9                   	leave  
80105561:	c3                   	ret    
80105562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105568:	c9                   	leave  
    return -1;
80105569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556e:	c3                   	ret    
8010556f:	90                   	nop

80105570 <sys_link>:
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	57                   	push   %edi
80105578:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105579:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010557c:	53                   	push   %ebx
8010557d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105580:	50                   	push   %eax
80105581:	6a 00                	push   $0x0
80105583:	e8 58 fb ff ff       	call   801050e0 <argstr>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	0f 88 ff 00 00 00    	js     80105692 <sys_link+0x122>
80105593:	83 ec 08             	sub    $0x8,%esp
80105596:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105599:	50                   	push   %eax
8010559a:	6a 01                	push   $0x1
8010559c:	e8 3f fb ff ff       	call   801050e0 <argstr>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	0f 88 e6 00 00 00    	js     80105692 <sys_link+0x122>
  begin_op();
801055ac:	e8 5f de ff ff       	call   80103410 <begin_op>
  if((ip = namei(old)) == 0){
801055b1:	83 ec 0c             	sub    $0xc,%esp
801055b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801055b7:	e8 54 d1 ff ff       	call   80102710 <namei>
801055bc:	83 c4 10             	add    $0x10,%esp
801055bf:	89 c3                	mov    %eax,%ebx
801055c1:	85 c0                	test   %eax,%eax
801055c3:	0f 84 e8 00 00 00    	je     801056b1 <sys_link+0x141>
  ilock(ip);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	50                   	push   %eax
801055cd:	e8 6e c8 ff ff       	call   80101e40 <ilock>
  if(ip->type == T_DIR){
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055da:	0f 84 b9 00 00 00    	je     80105699 <sys_link+0x129>
  iupdate(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801055e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055eb:	53                   	push   %ebx
801055ec:	e8 8f c7 ff ff       	call   80101d80 <iupdate>
  iunlock(ip);
801055f1:	89 1c 24             	mov    %ebx,(%esp)
801055f4:	e8 27 c9 ff ff       	call   80101f20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055f9:	58                   	pop    %eax
801055fa:	5a                   	pop    %edx
801055fb:	57                   	push   %edi
801055fc:	ff 75 d0             	pushl  -0x30(%ebp)
801055ff:	e8 2c d1 ff ff       	call   80102730 <nameiparent>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	89 c6                	mov    %eax,%esi
80105609:	85 c0                	test   %eax,%eax
8010560b:	74 5f                	je     8010566c <sys_link+0xfc>
  ilock(dp);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	50                   	push   %eax
80105611:	e8 2a c8 ff ff       	call   80101e40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105616:	8b 03                	mov    (%ebx),%eax
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	39 06                	cmp    %eax,(%esi)
8010561d:	75 41                	jne    80105660 <sys_link+0xf0>
8010561f:	83 ec 04             	sub    $0x4,%esp
80105622:	ff 73 04             	pushl  0x4(%ebx)
80105625:	57                   	push   %edi
80105626:	56                   	push   %esi
80105627:	e8 24 d0 ff ff       	call   80102650 <dirlink>
8010562c:	83 c4 10             	add    $0x10,%esp
8010562f:	85 c0                	test   %eax,%eax
80105631:	78 2d                	js     80105660 <sys_link+0xf0>
  iunlockput(dp);
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	56                   	push   %esi
80105637:	e8 a4 ca ff ff       	call   801020e0 <iunlockput>
  iput(ip);
8010563c:	89 1c 24             	mov    %ebx,(%esp)
8010563f:	e8 2c c9 ff ff       	call   80101f70 <iput>
  end_op();
80105644:	e8 37 de ff ff       	call   80103480 <end_op>
  return 0;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	31 c0                	xor    %eax,%eax
}
8010564e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105651:	5b                   	pop    %ebx
80105652:	5e                   	pop    %esi
80105653:	5f                   	pop    %edi
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret    
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	56                   	push   %esi
80105664:	e8 77 ca ff ff       	call   801020e0 <iunlockput>
    goto bad;
80105669:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	53                   	push   %ebx
80105670:	e8 cb c7 ff ff       	call   80101e40 <ilock>
  ip->nlink--;
80105675:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010567a:	89 1c 24             	mov    %ebx,(%esp)
8010567d:	e8 fe c6 ff ff       	call   80101d80 <iupdate>
  iunlockput(ip);
80105682:	89 1c 24             	mov    %ebx,(%esp)
80105685:	e8 56 ca ff ff       	call   801020e0 <iunlockput>
  end_op();
8010568a:	e8 f1 dd ff ff       	call   80103480 <end_op>
  return -1;
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105697:	eb b5                	jmp    8010564e <sys_link+0xde>
    iunlockput(ip);
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	53                   	push   %ebx
8010569d:	e8 3e ca ff ff       	call   801020e0 <iunlockput>
    end_op();
801056a2:	e8 d9 dd ff ff       	call   80103480 <end_op>
    return -1;
801056a7:	83 c4 10             	add    $0x10,%esp
801056aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056af:	eb 9d                	jmp    8010564e <sys_link+0xde>
    end_op();
801056b1:	e8 ca dd ff ff       	call   80103480 <end_op>
    return -1;
801056b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bb:	eb 91                	jmp    8010564e <sys_link+0xde>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi

801056c0 <sys_unlink>:
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056cc:	53                   	push   %ebx
801056cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056d0:	50                   	push   %eax
801056d1:	6a 00                	push   $0x0
801056d3:	e8 08 fa ff ff       	call   801050e0 <argstr>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 88 7d 01 00 00    	js     80105860 <sys_unlink+0x1a0>
  begin_op();
801056e3:	e8 28 dd ff ff       	call   80103410 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	53                   	push   %ebx
801056ef:	ff 75 c0             	pushl  -0x40(%ebp)
801056f2:	e8 39 d0 ff ff       	call   80102730 <nameiparent>
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	89 c6                	mov    %eax,%esi
801056fc:	85 c0                	test   %eax,%eax
801056fe:	0f 84 66 01 00 00    	je     8010586a <sys_unlink+0x1aa>
  ilock(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	50                   	push   %eax
80105708:	e8 33 c7 ff ff       	call   80101e40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010570d:	58                   	pop    %eax
8010570e:	5a                   	pop    %edx
8010570f:	68 f4 7e 10 80       	push   $0x80107ef4
80105714:	53                   	push   %ebx
80105715:	e8 56 cc ff ff       	call   80102370 <namecmp>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 84 03 01 00 00    	je     80105828 <sys_unlink+0x168>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	68 f3 7e 10 80       	push   $0x80107ef3
8010572d:	53                   	push   %ebx
8010572e:	e8 3d cc ff ff       	call   80102370 <namecmp>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	0f 84 ea 00 00 00    	je     80105828 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010573e:	83 ec 04             	sub    $0x4,%esp
80105741:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105744:	50                   	push   %eax
80105745:	53                   	push   %ebx
80105746:	56                   	push   %esi
80105747:	e8 44 cc ff ff       	call   80102390 <dirlookup>
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	89 c3                	mov    %eax,%ebx
80105751:	85 c0                	test   %eax,%eax
80105753:	0f 84 cf 00 00 00    	je     80105828 <sys_unlink+0x168>
  ilock(ip);
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	50                   	push   %eax
8010575d:	e8 de c6 ff ff       	call   80101e40 <ilock>
  if(ip->nlink < 1)
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010576a:	0f 8e 23 01 00 00    	jle    80105893 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105770:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105775:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105778:	74 66                	je     801057e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010577a:	83 ec 04             	sub    $0x4,%esp
8010577d:	6a 10                	push   $0x10
8010577f:	6a 00                	push   $0x0
80105781:	57                   	push   %edi
80105782:	e8 c9 f5 ff ff       	call   80104d50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105787:	6a 10                	push   $0x10
80105789:	ff 75 c4             	pushl  -0x3c(%ebp)
8010578c:	57                   	push   %edi
8010578d:	56                   	push   %esi
8010578e:	e8 ad ca ff ff       	call   80102240 <writei>
80105793:	83 c4 20             	add    $0x20,%esp
80105796:	83 f8 10             	cmp    $0x10,%eax
80105799:	0f 85 e7 00 00 00    	jne    80105886 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010579f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057a4:	0f 84 96 00 00 00    	je     80105840 <sys_unlink+0x180>
  iunlockput(dp);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	56                   	push   %esi
801057ae:	e8 2d c9 ff ff       	call   801020e0 <iunlockput>
  ip->nlink--;
801057b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057b8:	89 1c 24             	mov    %ebx,(%esp)
801057bb:	e8 c0 c5 ff ff       	call   80101d80 <iupdate>
  iunlockput(ip);
801057c0:	89 1c 24             	mov    %ebx,(%esp)
801057c3:	e8 18 c9 ff ff       	call   801020e0 <iunlockput>
  end_op();
801057c8:	e8 b3 dc ff ff       	call   80103480 <end_op>
  return 0;
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	31 c0                	xor    %eax,%eax
}
801057d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d5:	5b                   	pop    %ebx
801057d6:	5e                   	pop    %esi
801057d7:	5f                   	pop    %edi
801057d8:	5d                   	pop    %ebp
801057d9:	c3                   	ret    
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057e4:	76 94                	jbe    8010577a <sys_unlink+0xba>
801057e6:	ba 20 00 00 00       	mov    $0x20,%edx
801057eb:	eb 0b                	jmp    801057f8 <sys_unlink+0x138>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
801057f0:	83 c2 10             	add    $0x10,%edx
801057f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801057f6:	76 82                	jbe    8010577a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057f8:	6a 10                	push   $0x10
801057fa:	52                   	push   %edx
801057fb:	57                   	push   %edi
801057fc:	53                   	push   %ebx
801057fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105800:	e8 3b c9 ff ff       	call   80102140 <readi>
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010580b:	83 f8 10             	cmp    $0x10,%eax
8010580e:	75 69                	jne    80105879 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105810:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105815:	74 d9                	je     801057f0 <sys_unlink+0x130>
    iunlockput(ip);
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	53                   	push   %ebx
8010581b:	e8 c0 c8 ff ff       	call   801020e0 <iunlockput>
    goto bad;
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105827:	90                   	nop
  iunlockput(dp);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	56                   	push   %esi
8010582c:	e8 af c8 ff ff       	call   801020e0 <iunlockput>
  end_op();
80105831:	e8 4a dc ff ff       	call   80103480 <end_op>
  return -1;
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583e:	eb 92                	jmp    801057d2 <sys_unlink+0x112>
    iupdate(dp);
80105840:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105843:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105848:	56                   	push   %esi
80105849:	e8 32 c5 ff ff       	call   80101d80 <iupdate>
8010584e:	83 c4 10             	add    $0x10,%esp
80105851:	e9 54 ff ff ff       	jmp    801057aa <sys_unlink+0xea>
80105856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	e9 68 ff ff ff       	jmp    801057d2 <sys_unlink+0x112>
    end_op();
8010586a:	e8 11 dc ff ff       	call   80103480 <end_op>
    return -1;
8010586f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105874:	e9 59 ff ff ff       	jmp    801057d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	68 18 7f 10 80       	push   $0x80107f18
80105881:	e8 0a ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105886:	83 ec 0c             	sub    $0xc,%esp
80105889:	68 2a 7f 10 80       	push   $0x80107f2a
8010588e:	e8 fd aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105893:	83 ec 0c             	sub    $0xc,%esp
80105896:	68 06 7f 10 80       	push   $0x80107f06
8010589b:	e8 f0 aa ff ff       	call   80100390 <panic>

801058a0 <sys_open>:

int
sys_open(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	57                   	push   %edi
801058a8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058ac:	53                   	push   %ebx
801058ad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058b0:	50                   	push   %eax
801058b1:	6a 00                	push   $0x0
801058b3:	e8 28 f8 ff ff       	call   801050e0 <argstr>
801058b8:	83 c4 10             	add    $0x10,%esp
801058bb:	85 c0                	test   %eax,%eax
801058bd:	0f 88 8a 00 00 00    	js     8010594d <sys_open+0xad>
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 01                	push   $0x1
801058cc:	e8 5f f7 ff ff       	call   80105030 <argint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 75                	js     8010594d <sys_open+0xad>
    return -1;

  begin_op();
801058d8:	e8 33 db ff ff       	call   80103410 <begin_op>

  if(omode & O_CREATE){
801058dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058e1:	75 75                	jne    80105958 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	ff 75 e0             	pushl  -0x20(%ebp)
801058e9:	e8 22 ce ff ff       	call   80102710 <namei>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	89 c6                	mov    %eax,%esi
801058f3:	85 c0                	test   %eax,%eax
801058f5:	74 7e                	je     80105975 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	50                   	push   %eax
801058fb:	e8 40 c5 ff ff       	call   80101e40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105908:	0f 84 c2 00 00 00    	je     801059d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010590e:	e8 cd bb ff ff       	call   801014e0 <filealloc>
80105913:	89 c7                	mov    %eax,%edi
80105915:	85 c0                	test   %eax,%eax
80105917:	74 23                	je     8010593c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105919:	e8 22 e7 ff ff       	call   80104040 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105920:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105924:	85 d2                	test   %edx,%edx
80105926:	74 60                	je     80105988 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105928:	83 c3 01             	add    $0x1,%ebx
8010592b:	83 fb 10             	cmp    $0x10,%ebx
8010592e:	75 f0                	jne    80105920 <sys_open+0x80>
    if(f)
      fileclose(f);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	57                   	push   %edi
80105934:	e8 67 bc ff ff       	call   801015a0 <fileclose>
80105939:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	56                   	push   %esi
80105940:	e8 9b c7 ff ff       	call   801020e0 <iunlockput>
    end_op();
80105945:	e8 36 db ff ff       	call   80103480 <end_op>
    return -1;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105952:	eb 6d                	jmp    801059c1 <sys_open+0x121>
80105954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010595e:	31 c9                	xor    %ecx,%ecx
80105960:	ba 02 00 00 00       	mov    $0x2,%edx
80105965:	6a 00                	push   $0x0
80105967:	e8 24 f8 ff ff       	call   80105190 <create>
    if(ip == 0){
8010596c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010596f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105971:	85 c0                	test   %eax,%eax
80105973:	75 99                	jne    8010590e <sys_open+0x6e>
      end_op();
80105975:	e8 06 db ff ff       	call   80103480 <end_op>
      return -1;
8010597a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010597f:	eb 40                	jmp    801059c1 <sys_open+0x121>
80105981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105988:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010598b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010598f:	56                   	push   %esi
80105990:	e8 8b c5 ff ff       	call   80101f20 <iunlock>
  end_op();
80105995:	e8 e6 da ff ff       	call   80103480 <end_op>

  f->type = FD_INODE;
8010599a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059b2:	f7 d0                	not    %eax
801059b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c4:	89 d8                	mov    %ebx,%eax
801059c6:	5b                   	pop    %ebx
801059c7:	5e                   	pop    %esi
801059c8:	5f                   	pop    %edi
801059c9:	5d                   	pop    %ebp
801059ca:	c3                   	ret    
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801059d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059d3:	85 c9                	test   %ecx,%ecx
801059d5:	0f 84 33 ff ff ff    	je     8010590e <sys_open+0x6e>
801059db:	e9 5c ff ff ff       	jmp    8010593c <sys_open+0x9c>

801059e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059e0:	f3 0f 1e fb          	endbr32 
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059ea:	e8 21 da ff ff       	call   80103410 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059ef:	83 ec 08             	sub    $0x8,%esp
801059f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f5:	50                   	push   %eax
801059f6:	6a 00                	push   $0x0
801059f8:	e8 e3 f6 ff ff       	call   801050e0 <argstr>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	85 c0                	test   %eax,%eax
80105a02:	78 34                	js     80105a38 <sys_mkdir+0x58>
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	31 c9                	xor    %ecx,%ecx
80105a0c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a11:	6a 00                	push   $0x0
80105a13:	e8 78 f7 ff ff       	call   80105190 <create>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	74 19                	je     80105a38 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	50                   	push   %eax
80105a23:	e8 b8 c6 ff ff       	call   801020e0 <iunlockput>
  end_op();
80105a28:	e8 53 da ff ff       	call   80103480 <end_op>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	c9                   	leave  
80105a33:	c3                   	ret    
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a38:	e8 43 da ff ff       	call   80103480 <end_op>
    return -1;
80105a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a42:	c9                   	leave  
80105a43:	c3                   	ret    
80105a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop

80105a50 <sys_mknod>:

int
sys_mknod(void)
{
80105a50:	f3 0f 1e fb          	endbr32 
80105a54:	55                   	push   %ebp
80105a55:	89 e5                	mov    %esp,%ebp
80105a57:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a5a:	e8 b1 d9 ff ff       	call   80103410 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a5f:	83 ec 08             	sub    $0x8,%esp
80105a62:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a65:	50                   	push   %eax
80105a66:	6a 00                	push   $0x0
80105a68:	e8 73 f6 ff ff       	call   801050e0 <argstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 64                	js     80105ad8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105a74:	83 ec 08             	sub    $0x8,%esp
80105a77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7a:	50                   	push   %eax
80105a7b:	6a 01                	push   $0x1
80105a7d:	e8 ae f5 ff ff       	call   80105030 <argint>
  if((argstr(0, &path)) < 0 ||
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	78 4f                	js     80105ad8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a8f:	50                   	push   %eax
80105a90:	6a 02                	push   $0x2
80105a92:	e8 99 f5 ff ff       	call   80105030 <argint>
     argint(1, &major) < 0 ||
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	78 3a                	js     80105ad8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a9e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105aa9:	ba 03 00 00 00       	mov    $0x3,%edx
80105aae:	50                   	push   %eax
80105aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ab2:	e8 d9 f6 ff ff       	call   80105190 <create>
     argint(2, &minor) < 0 ||
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	85 c0                	test   %eax,%eax
80105abc:	74 1a                	je     80105ad8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105abe:	83 ec 0c             	sub    $0xc,%esp
80105ac1:	50                   	push   %eax
80105ac2:	e8 19 c6 ff ff       	call   801020e0 <iunlockput>
  end_op();
80105ac7:	e8 b4 d9 ff ff       	call   80103480 <end_op>
  return 0;
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	31 c0                	xor    %eax,%eax
}
80105ad1:	c9                   	leave  
80105ad2:	c3                   	ret    
80105ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad7:	90                   	nop
    end_op();
80105ad8:	e8 a3 d9 ff ff       	call   80103480 <end_op>
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae2:	c9                   	leave  
80105ae3:	c3                   	ret    
80105ae4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop

80105af0 <sys_chdir>:

int
sys_chdir(void)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	56                   	push   %esi
80105af8:	53                   	push   %ebx
80105af9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105afc:	e8 3f e5 ff ff       	call   80104040 <myproc>
80105b01:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b03:	e8 08 d9 ff ff       	call   80103410 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 ca f5 ff ff       	call   801050e0 <argstr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	78 73                	js     80105b90 <sys_chdir+0xa0>
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	ff 75 f4             	pushl  -0xc(%ebp)
80105b23:	e8 e8 cb ff ff       	call   80102710 <namei>
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	89 c3                	mov    %eax,%ebx
80105b2d:	85 c0                	test   %eax,%eax
80105b2f:	74 5f                	je     80105b90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	50                   	push   %eax
80105b35:	e8 06 c3 ff ff       	call   80101e40 <ilock>
  if(ip->type != T_DIR){
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b42:	75 2c                	jne    80105b70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b44:	83 ec 0c             	sub    $0xc,%esp
80105b47:	53                   	push   %ebx
80105b48:	e8 d3 c3 ff ff       	call   80101f20 <iunlock>
  iput(curproc->cwd);
80105b4d:	58                   	pop    %eax
80105b4e:	ff 76 68             	pushl  0x68(%esi)
80105b51:	e8 1a c4 ff ff       	call   80101f70 <iput>
  end_op();
80105b56:	e8 25 d9 ff ff       	call   80103480 <end_op>
  curproc->cwd = ip;
80105b5b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	31 c0                	xor    %eax,%eax
}
80105b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5d                   	pop    %ebp
80105b69:	c3                   	ret    
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	53                   	push   %ebx
80105b74:	e8 67 c5 ff ff       	call   801020e0 <iunlockput>
    end_op();
80105b79:	e8 02 d9 ff ff       	call   80103480 <end_op>
    return -1;
80105b7e:	83 c4 10             	add    $0x10,%esp
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b86:	eb db                	jmp    80105b63 <sys_chdir+0x73>
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    end_op();
80105b90:	e8 eb d8 ff ff       	call   80103480 <end_op>
    return -1;
80105b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9a:	eb c7                	jmp    80105b63 <sys_chdir+0x73>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exec>:

int
sys_exec(void)
{
80105ba0:	f3 0f 1e fb          	endbr32 
80105ba4:	55                   	push   %ebp
80105ba5:	89 e5                	mov    %esp,%ebp
80105ba7:	57                   	push   %edi
80105ba8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ba9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105baf:	53                   	push   %ebx
80105bb0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bb6:	50                   	push   %eax
80105bb7:	6a 00                	push   $0x0
80105bb9:	e8 22 f5 ff ff       	call   801050e0 <argstr>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	0f 88 8b 00 00 00    	js     80105c54 <sys_exec+0xb4>
80105bc9:	83 ec 08             	sub    $0x8,%esp
80105bcc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bd2:	50                   	push   %eax
80105bd3:	6a 01                	push   $0x1
80105bd5:	e8 56 f4 ff ff       	call   80105030 <argint>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	78 73                	js     80105c54 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105be1:	83 ec 04             	sub    $0x4,%esp
80105be4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105bea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bec:	68 80 00 00 00       	push   $0x80
80105bf1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bf7:	6a 00                	push   $0x0
80105bf9:	50                   	push   %eax
80105bfa:	e8 51 f1 ff ff       	call   80104d50 <memset>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c08:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c0e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	57                   	push   %edi
80105c19:	01 f0                	add    %esi,%eax
80105c1b:	50                   	push   %eax
80105c1c:	e8 6f f3 ff ff       	call   80104f90 <fetchint>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 2c                	js     80105c54 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c28:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	74 36                	je     80105c68 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c32:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c3e:	52                   	push   %edx
80105c3f:	50                   	push   %eax
80105c40:	e8 8b f3 ff ff       	call   80104fd0 <fetchstr>
80105c45:	83 c4 10             	add    $0x10,%esp
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	78 08                	js     80105c54 <sys_exec+0xb4>
  for(i=0;; i++){
80105c4c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c4f:	83 fb 20             	cmp    $0x20,%ebx
80105c52:	75 b4                	jne    80105c08 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5c:	5b                   	pop    %ebx
80105c5d:	5e                   	pop    %esi
80105c5e:	5f                   	pop    %edi
80105c5f:	5d                   	pop    %ebp
80105c60:	c3                   	ret    
80105c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105c71:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c78:	00 00 00 00 
  return exec(path, argv);
80105c7c:	50                   	push   %eax
80105c7d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c83:	e8 d8 b4 ff ff       	call   80101160 <exec>
80105c88:	83 c4 10             	add    $0x10,%esp
}
80105c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8e:	5b                   	pop    %ebx
80105c8f:	5e                   	pop    %esi
80105c90:	5f                   	pop    %edi
80105c91:	5d                   	pop    %ebp
80105c92:	c3                   	ret    
80105c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ca0 <sys_pipe>:

int
sys_pipe(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ca9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105cac:	53                   	push   %ebx
80105cad:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cb0:	6a 08                	push   $0x8
80105cb2:	50                   	push   %eax
80105cb3:	6a 00                	push   $0x0
80105cb5:	e8 c6 f3 ff ff       	call   80105080 <argptr>
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	85 c0                	test   %eax,%eax
80105cbf:	78 4e                	js     80105d0f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105cc1:	83 ec 08             	sub    $0x8,%esp
80105cc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cc7:	50                   	push   %eax
80105cc8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ccb:	50                   	push   %eax
80105ccc:	e8 ff dd ff ff       	call   80103ad0 <pipealloc>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	78 37                	js     80105d0f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cd8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105cdb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cdd:	e8 5e e3 ff ff       	call   80104040 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ce8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cec:	85 f6                	test   %esi,%esi
80105cee:	74 30                	je     80105d20 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105cf0:	83 c3 01             	add    $0x1,%ebx
80105cf3:	83 fb 10             	cmp    $0x10,%ebx
80105cf6:	75 f0                	jne    80105ce8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	ff 75 e0             	pushl  -0x20(%ebp)
80105cfe:	e8 9d b8 ff ff       	call   801015a0 <fileclose>
    fileclose(wf);
80105d03:	58                   	pop    %eax
80105d04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d07:	e8 94 b8 ff ff       	call   801015a0 <fileclose>
    return -1;
80105d0c:	83 c4 10             	add    $0x10,%esp
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d14:	eb 5b                	jmp    80105d71 <sys_pipe+0xd1>
80105d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d20:	8d 73 08             	lea    0x8(%ebx),%esi
80105d23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d2a:	e8 11 e3 ff ff       	call   80104040 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d2f:	31 d2                	xor    %edx,%edx
80105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d38:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d3c:	85 c9                	test   %ecx,%ecx
80105d3e:	74 20                	je     80105d60 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105d40:	83 c2 01             	add    $0x1,%edx
80105d43:	83 fa 10             	cmp    $0x10,%edx
80105d46:	75 f0                	jne    80105d38 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d48:	e8 f3 e2 ff ff       	call   80104040 <myproc>
80105d4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d54:	00 
80105d55:	eb a1                	jmp    80105cf8 <sys_pipe+0x58>
80105d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d6f:	31 c0                	xor    %eax,%eax
}
80105d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d74:	5b                   	pop    %ebx
80105d75:	5e                   	pop    %esi
80105d76:	5f                   	pop    %edi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	66 90                	xchg   %ax,%ax
80105d7b:	66 90                	xchg   %ax,%ax
80105d7d:	66 90                	xchg   %ax,%ax
80105d7f:	90                   	nop

80105d80 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
  return fork();
80105d84:	e9 67 e4 ff ff       	jmp    801041f0 <fork>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_exit>:
}

int
sys_exit(void)
{
80105d90:	f3 0f 1e fb          	endbr32 
80105d94:	55                   	push   %ebp
80105d95:	89 e5                	mov    %esp,%ebp
80105d97:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d9a:	e8 d1 e6 ff ff       	call   80104470 <exit>
  return 0;  // not reached
}
80105d9f:	31 c0                	xor    %eax,%eax
80105da1:	c9                   	leave  
80105da2:	c3                   	ret    
80105da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105db0 <sys_wait>:

int
sys_wait(void)
{
80105db0:	f3 0f 1e fb          	endbr32 
  return wait();
80105db4:	e9 07 e9 ff ff       	jmp    801046c0 <wait>
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <sys_kill>:
}

int
sys_kill(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105dca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dcd:	50                   	push   %eax
80105dce:	6a 00                	push   $0x0
80105dd0:	e8 5b f2 ff ff       	call   80105030 <argint>
80105dd5:	83 c4 10             	add    $0x10,%esp
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	78 14                	js     80105df0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	ff 75 f4             	pushl  -0xc(%ebp)
80105de2:	e8 39 ea ff ff       	call   80104820 <kill>
80105de7:	83 c4 10             	add    $0x10,%esp
}
80105dea:	c9                   	leave  
80105deb:	c3                   	ret    
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105df0:	c9                   	leave  
    return -1;
80105df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df6:	c3                   	ret    
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <sys_getpid>:

int
sys_getpid(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e0a:	e8 31 e2 ff ff       	call   80104040 <myproc>
80105e0f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    
80105e14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop

80105e20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e2b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e2e:	50                   	push   %eax
80105e2f:	6a 00                	push   $0x0
80105e31:	e8 fa f1 ff ff       	call   80105030 <argint>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 23                	js     80105e60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e3d:	e8 fe e1 ff ff       	call   80104040 <myproc>
  if(growproc(n) < 0)
80105e42:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e45:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e47:	ff 75 f4             	pushl  -0xc(%ebp)
80105e4a:	e8 21 e3 ff ff       	call   80104170 <growproc>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	85 c0                	test   %eax,%eax
80105e54:	78 0a                	js     80105e60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e56:	89 d8                	mov    %ebx,%eax
80105e58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e5b:	c9                   	leave  
80105e5c:	c3                   	ret    
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e65:	eb ef                	jmp    80105e56 <sys_sbrk+0x36>
80105e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_sleep>:

int
sys_sleep(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e7e:	50                   	push   %eax
80105e7f:	6a 00                	push   $0x0
80105e81:	e8 aa f1 ff ff       	call   80105030 <argint>
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	0f 88 86 00 00 00    	js     80105f17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e91:	83 ec 0c             	sub    $0xc,%esp
80105e94:	68 a0 61 11 80       	push   $0x801161a0
80105e99:	e8 a2 ed ff ff       	call   80104c40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ea1:	8b 1d e0 69 11 80    	mov    0x801169e0,%ebx
  while(ticks - ticks0 < n){
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	85 d2                	test   %edx,%edx
80105eac:	75 23                	jne    80105ed1 <sys_sleep+0x61>
80105eae:	eb 50                	jmp    80105f00 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	68 a0 61 11 80       	push   $0x801161a0
80105eb8:	68 e0 69 11 80       	push   $0x801169e0
80105ebd:	e8 3e e7 ff ff       	call   80104600 <sleep>
  while(ticks - ticks0 < n){
80105ec2:	a1 e0 69 11 80       	mov    0x801169e0,%eax
80105ec7:	83 c4 10             	add    $0x10,%esp
80105eca:	29 d8                	sub    %ebx,%eax
80105ecc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ecf:	73 2f                	jae    80105f00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ed1:	e8 6a e1 ff ff       	call   80104040 <myproc>
80105ed6:	8b 40 24             	mov    0x24(%eax),%eax
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	74 d3                	je     80105eb0 <sys_sleep+0x40>
      release(&tickslock);
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 a0 61 11 80       	push   $0x801161a0
80105ee5:	e8 16 ee ff ff       	call   80104d00 <release>
  }
  release(&tickslock);
  return 0;
}
80105eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105eed:	83 c4 10             	add    $0x10,%esp
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	68 a0 61 11 80       	push   $0x801161a0
80105f08:	e8 f3 ed ff ff       	call   80104d00 <release>
  return 0;
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	31 c0                	xor    %eax,%eax
}
80105f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
    return -1;
80105f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1c:	eb f4                	jmp    80105f12 <sys_sleep+0xa2>
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	53                   	push   %ebx
80105f28:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f2b:	68 a0 61 11 80       	push   $0x801161a0
80105f30:	e8 0b ed ff ff       	call   80104c40 <acquire>
  xticks = ticks;
80105f35:	8b 1d e0 69 11 80    	mov    0x801169e0,%ebx
  release(&tickslock);
80105f3b:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105f42:	e8 b9 ed ff ff       	call   80104d00 <release>
  return xticks;
}
80105f47:	89 d8                	mov    %ebx,%eax
80105f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f4c:	c9                   	leave  
80105f4d:	c3                   	ret    

80105f4e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f4e:	1e                   	push   %ds
  pushl %es
80105f4f:	06                   	push   %es
  pushl %fs
80105f50:	0f a0                	push   %fs
  pushl %gs
80105f52:	0f a8                	push   %gs
  pushal
80105f54:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f55:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f59:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f5b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f5d:	54                   	push   %esp
  call trap
80105f5e:	e8 cd 00 00 00       	call   80106030 <trap>
  addl $4, %esp
80105f63:	83 c4 04             	add    $0x4,%esp

80105f66 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f66:	61                   	popa   
  popl %gs
80105f67:	0f a9                	pop    %gs
  popl %fs
80105f69:	0f a1                	pop    %fs
  popl %es
80105f6b:	07                   	pop    %es
  popl %ds
80105f6c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f6d:	83 c4 08             	add    $0x8,%esp
  iret
80105f70:	cf                   	iret   
80105f71:	66 90                	xchg   %ax,%ax
80105f73:	66 90                	xchg   %ax,%ax
80105f75:	66 90                	xchg   %ax,%ax
80105f77:	66 90                	xchg   %ax,%ax
80105f79:	66 90                	xchg   %ax,%ax
80105f7b:	66 90                	xchg   %ax,%ax
80105f7d:	66 90                	xchg   %ax,%ax
80105f7f:	90                   	nop

80105f80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f85:	31 c0                	xor    %eax,%eax
{
80105f87:	89 e5                	mov    %esp,%ebp
80105f89:	83 ec 08             	sub    $0x8,%esp
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f97:	c7 04 c5 e2 61 11 80 	movl   $0x8e000008,-0x7fee9e1e(,%eax,8)
80105f9e:	08 00 00 8e 
80105fa2:	66 89 14 c5 e0 61 11 	mov    %dx,-0x7fee9e20(,%eax,8)
80105fa9:	80 
80105faa:	c1 ea 10             	shr    $0x10,%edx
80105fad:	66 89 14 c5 e6 61 11 	mov    %dx,-0x7fee9e1a(,%eax,8)
80105fb4:	80 
  for(i = 0; i < 256; i++)
80105fb5:	83 c0 01             	add    $0x1,%eax
80105fb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fbd:	75 d1                	jne    80105f90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fc2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105fc7:	c7 05 e2 63 11 80 08 	movl   $0xef000008,0x801163e2
80105fce:	00 00 ef 
  initlock(&tickslock, "time");
80105fd1:	68 39 7f 10 80       	push   $0x80107f39
80105fd6:	68 a0 61 11 80       	push   $0x801161a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fdb:	66 a3 e0 63 11 80    	mov    %ax,0x801163e0
80105fe1:	c1 e8 10             	shr    $0x10,%eax
80105fe4:	66 a3 e6 63 11 80    	mov    %ax,0x801163e6
  initlock(&tickslock, "time");
80105fea:	e8 d1 ea ff ff       	call   80104ac0 <initlock>
}
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	c9                   	leave  
80105ff3:	c3                   	ret    
80105ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <idtinit>:

void
idtinit(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
  pd[0] = size-1;
80106005:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010600a:	89 e5                	mov    %esp,%ebp
8010600c:	83 ec 10             	sub    $0x10,%esp
8010600f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106013:	b8 e0 61 11 80       	mov    $0x801161e0,%eax
80106018:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010601c:	c1 e8 10             	shr    $0x10,%eax
8010601f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106023:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106026:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106029:	c9                   	leave  
8010602a:	c3                   	ret    
8010602b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106030:	f3 0f 1e fb          	endbr32 
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
80106037:	57                   	push   %edi
80106038:	56                   	push   %esi
80106039:	53                   	push   %ebx
8010603a:	83 ec 1c             	sub    $0x1c,%esp
8010603d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106040:	8b 43 30             	mov    0x30(%ebx),%eax
80106043:	83 f8 40             	cmp    $0x40,%eax
80106046:	0f 84 bc 01 00 00    	je     80106208 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010604c:	83 e8 20             	sub    $0x20,%eax
8010604f:	83 f8 1f             	cmp    $0x1f,%eax
80106052:	77 08                	ja     8010605c <trap+0x2c>
80106054:	3e ff 24 85 e0 7f 10 	notrack jmp *-0x7fef8020(,%eax,4)
8010605b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010605c:	e8 df df ff ff       	call   80104040 <myproc>
80106061:	8b 7b 38             	mov    0x38(%ebx),%edi
80106064:	85 c0                	test   %eax,%eax
80106066:	0f 84 eb 01 00 00    	je     80106257 <trap+0x227>
8010606c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106070:	0f 84 e1 01 00 00    	je     80106257 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106076:	0f 20 d1             	mov    %cr2,%ecx
80106079:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010607c:	e8 9f df ff ff       	call   80104020 <cpuid>
80106081:	8b 73 30             	mov    0x30(%ebx),%esi
80106084:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106087:	8b 43 34             	mov    0x34(%ebx),%eax
8010608a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010608d:	e8 ae df ff ff       	call   80104040 <myproc>
80106092:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106095:	e8 a6 df ff ff       	call   80104040 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010609a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010609d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060a0:	51                   	push   %ecx
801060a1:	57                   	push   %edi
801060a2:	52                   	push   %edx
801060a3:	ff 75 e4             	pushl  -0x1c(%ebp)
801060a6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060a7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060aa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ad:	56                   	push   %esi
801060ae:	ff 70 10             	pushl  0x10(%eax)
801060b1:	68 9c 7f 10 80       	push   $0x80107f9c
801060b6:	e8 e5 a6 ff ff       	call   801007a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060bb:	83 c4 20             	add    $0x20,%esp
801060be:	e8 7d df ff ff       	call   80104040 <myproc>
801060c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ca:	e8 71 df ff ff       	call   80104040 <myproc>
801060cf:	85 c0                	test   %eax,%eax
801060d1:	74 1d                	je     801060f0 <trap+0xc0>
801060d3:	e8 68 df ff ff       	call   80104040 <myproc>
801060d8:	8b 50 24             	mov    0x24(%eax),%edx
801060db:	85 d2                	test   %edx,%edx
801060dd:	74 11                	je     801060f0 <trap+0xc0>
801060df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060e3:	83 e0 03             	and    $0x3,%eax
801060e6:	66 83 f8 03          	cmp    $0x3,%ax
801060ea:	0f 84 50 01 00 00    	je     80106240 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060f0:	e8 4b df ff ff       	call   80104040 <myproc>
801060f5:	85 c0                	test   %eax,%eax
801060f7:	74 0f                	je     80106108 <trap+0xd8>
801060f9:	e8 42 df ff ff       	call   80104040 <myproc>
801060fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106102:	0f 84 e8 00 00 00    	je     801061f0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106108:	e8 33 df ff ff       	call   80104040 <myproc>
8010610d:	85 c0                	test   %eax,%eax
8010610f:	74 1d                	je     8010612e <trap+0xfe>
80106111:	e8 2a df ff ff       	call   80104040 <myproc>
80106116:	8b 40 24             	mov    0x24(%eax),%eax
80106119:	85 c0                	test   %eax,%eax
8010611b:	74 11                	je     8010612e <trap+0xfe>
8010611d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106121:	83 e0 03             	and    $0x3,%eax
80106124:	66 83 f8 03          	cmp    $0x3,%ax
80106128:	0f 84 03 01 00 00    	je     80106231 <trap+0x201>
    exit();
}
8010612e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106131:	5b                   	pop    %ebx
80106132:	5e                   	pop    %esi
80106133:	5f                   	pop    %edi
80106134:	5d                   	pop    %ebp
80106135:	c3                   	ret    
    ideintr();
80106136:	e8 85 c7 ff ff       	call   801028c0 <ideintr>
    lapiceoi();
8010613b:	e8 60 ce ff ff       	call   80102fa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106140:	e8 fb de ff ff       	call   80104040 <myproc>
80106145:	85 c0                	test   %eax,%eax
80106147:	75 8a                	jne    801060d3 <trap+0xa3>
80106149:	eb a5                	jmp    801060f0 <trap+0xc0>
    if(cpuid() == 0){
8010614b:	e8 d0 de ff ff       	call   80104020 <cpuid>
80106150:	85 c0                	test   %eax,%eax
80106152:	75 e7                	jne    8010613b <trap+0x10b>
      acquire(&tickslock);
80106154:	83 ec 0c             	sub    $0xc,%esp
80106157:	68 a0 61 11 80       	push   $0x801161a0
8010615c:	e8 df ea ff ff       	call   80104c40 <acquire>
      wakeup(&ticks);
80106161:	c7 04 24 e0 69 11 80 	movl   $0x801169e0,(%esp)
      ticks++;
80106168:	83 05 e0 69 11 80 01 	addl   $0x1,0x801169e0
      wakeup(&ticks);
8010616f:	e8 4c e6 ff ff       	call   801047c0 <wakeup>
      release(&tickslock);
80106174:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
8010617b:	e8 80 eb ff ff       	call   80104d00 <release>
80106180:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106183:	eb b6                	jmp    8010613b <trap+0x10b>
    kbdintr();
80106185:	e8 d6 cc ff ff       	call   80102e60 <kbdintr>
    lapiceoi();
8010618a:	e8 11 ce ff ff       	call   80102fa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010618f:	e8 ac de ff ff       	call   80104040 <myproc>
80106194:	85 c0                	test   %eax,%eax
80106196:	0f 85 37 ff ff ff    	jne    801060d3 <trap+0xa3>
8010619c:	e9 4f ff ff ff       	jmp    801060f0 <trap+0xc0>
    uartintr();
801061a1:	e8 4a 02 00 00       	call   801063f0 <uartintr>
    lapiceoi();
801061a6:	e8 f5 cd ff ff       	call   80102fa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ab:	e8 90 de ff ff       	call   80104040 <myproc>
801061b0:	85 c0                	test   %eax,%eax
801061b2:	0f 85 1b ff ff ff    	jne    801060d3 <trap+0xa3>
801061b8:	e9 33 ff ff ff       	jmp    801060f0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801061c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801061c4:	e8 57 de ff ff       	call   80104020 <cpuid>
801061c9:	57                   	push   %edi
801061ca:	56                   	push   %esi
801061cb:	50                   	push   %eax
801061cc:	68 44 7f 10 80       	push   $0x80107f44
801061d1:	e8 ca a5 ff ff       	call   801007a0 <cprintf>
    lapiceoi();
801061d6:	e8 c5 cd ff ff       	call   80102fa0 <lapiceoi>
    break;
801061db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061de:	e8 5d de ff ff       	call   80104040 <myproc>
801061e3:	85 c0                	test   %eax,%eax
801061e5:	0f 85 e8 fe ff ff    	jne    801060d3 <trap+0xa3>
801061eb:	e9 00 ff ff ff       	jmp    801060f0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801061f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801061f4:	0f 85 0e ff ff ff    	jne    80106108 <trap+0xd8>
    yield();
801061fa:	e8 b1 e3 ff ff       	call   801045b0 <yield>
801061ff:	e9 04 ff ff ff       	jmp    80106108 <trap+0xd8>
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106208:	e8 33 de ff ff       	call   80104040 <myproc>
8010620d:	8b 70 24             	mov    0x24(%eax),%esi
80106210:	85 f6                	test   %esi,%esi
80106212:	75 3c                	jne    80106250 <trap+0x220>
    myproc()->tf = tf;
80106214:	e8 27 de ff ff       	call   80104040 <myproc>
80106219:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010621c:	e8 ff ee ff ff       	call   80105120 <syscall>
    if(myproc()->killed)
80106221:	e8 1a de ff ff       	call   80104040 <myproc>
80106226:	8b 48 24             	mov    0x24(%eax),%ecx
80106229:	85 c9                	test   %ecx,%ecx
8010622b:	0f 84 fd fe ff ff    	je     8010612e <trap+0xfe>
}
80106231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106234:	5b                   	pop    %ebx
80106235:	5e                   	pop    %esi
80106236:	5f                   	pop    %edi
80106237:	5d                   	pop    %ebp
      exit();
80106238:	e9 33 e2 ff ff       	jmp    80104470 <exit>
8010623d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106240:	e8 2b e2 ff ff       	call   80104470 <exit>
80106245:	e9 a6 fe ff ff       	jmp    801060f0 <trap+0xc0>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106250:	e8 1b e2 ff ff       	call   80104470 <exit>
80106255:	eb bd                	jmp    80106214 <trap+0x1e4>
80106257:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010625a:	e8 c1 dd ff ff       	call   80104020 <cpuid>
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	56                   	push   %esi
80106263:	57                   	push   %edi
80106264:	50                   	push   %eax
80106265:	ff 73 30             	pushl  0x30(%ebx)
80106268:	68 68 7f 10 80       	push   $0x80107f68
8010626d:	e8 2e a5 ff ff       	call   801007a0 <cprintf>
      panic("trap");
80106272:	83 c4 14             	add    $0x14,%esp
80106275:	68 3e 7f 10 80       	push   $0x80107f3e
8010627a:	e8 11 a1 ff ff       	call   80100390 <panic>
8010627f:	90                   	nop

80106280 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106280:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106284:	a1 fc b5 10 80       	mov    0x8010b5fc,%eax
80106289:	85 c0                	test   %eax,%eax
8010628b:	74 1b                	je     801062a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010628d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106292:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106293:	a8 01                	test   $0x1,%al
80106295:	74 11                	je     801062a8 <uartgetc+0x28>
80106297:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010629d:	0f b6 c0             	movzbl %al,%eax
801062a0:	c3                   	ret    
801062a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ad:	c3                   	ret    
801062ae:	66 90                	xchg   %ax,%ax

801062b0 <uartputc.part.0>:
uartputc(int c)
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	89 c7                	mov    %eax,%edi
801062b6:	56                   	push   %esi
801062b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801062bc:	53                   	push   %ebx
801062bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801062c2:	83 ec 0c             	sub    $0xc,%esp
801062c5:	eb 1b                	jmp    801062e2 <uartputc.part.0+0x32>
801062c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	6a 0a                	push   $0xa
801062d5:	e8 e6 cc ff ff       	call   80102fc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	83 eb 01             	sub    $0x1,%ebx
801062e0:	74 07                	je     801062e9 <uartputc.part.0+0x39>
801062e2:	89 f2                	mov    %esi,%edx
801062e4:	ec                   	in     (%dx),%al
801062e5:	a8 20                	test   $0x20,%al
801062e7:	74 e7                	je     801062d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ee:	89 f8                	mov    %edi,%eax
801062f0:	ee                   	out    %al,(%dx)
}
801062f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f4:	5b                   	pop    %ebx
801062f5:	5e                   	pop    %esi
801062f6:	5f                   	pop    %edi
801062f7:	5d                   	pop    %ebp
801062f8:	c3                   	ret    
801062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106300 <uartinit>:
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
80106305:	31 c9                	xor    %ecx,%ecx
80106307:	89 c8                	mov    %ecx,%eax
80106309:	89 e5                	mov    %esp,%ebp
8010630b:	57                   	push   %edi
8010630c:	56                   	push   %esi
8010630d:	53                   	push   %ebx
8010630e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106313:	89 da                	mov    %ebx,%edx
80106315:	83 ec 0c             	sub    $0xc,%esp
80106318:	ee                   	out    %al,(%dx)
80106319:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010631e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106323:	89 fa                	mov    %edi,%edx
80106325:	ee                   	out    %al,(%dx)
80106326:	b8 0c 00 00 00       	mov    $0xc,%eax
8010632b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106330:	ee                   	out    %al,(%dx)
80106331:	be f9 03 00 00       	mov    $0x3f9,%esi
80106336:	89 c8                	mov    %ecx,%eax
80106338:	89 f2                	mov    %esi,%edx
8010633a:	ee                   	out    %al,(%dx)
8010633b:	b8 03 00 00 00       	mov    $0x3,%eax
80106340:	89 fa                	mov    %edi,%edx
80106342:	ee                   	out    %al,(%dx)
80106343:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106348:	89 c8                	mov    %ecx,%eax
8010634a:	ee                   	out    %al,(%dx)
8010634b:	b8 01 00 00 00       	mov    $0x1,%eax
80106350:	89 f2                	mov    %esi,%edx
80106352:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106353:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106358:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106359:	3c ff                	cmp    $0xff,%al
8010635b:	74 52                	je     801063af <uartinit+0xaf>
  uart = 1;
8010635d:	c7 05 fc b5 10 80 01 	movl   $0x1,0x8010b5fc
80106364:	00 00 00 
80106367:	89 da                	mov    %ebx,%edx
80106369:	ec                   	in     (%dx),%al
8010636a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010636f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106370:	83 ec 08             	sub    $0x8,%esp
80106373:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106378:	bb 60 80 10 80       	mov    $0x80108060,%ebx
  ioapicenable(IRQ_COM1, 0);
8010637d:	6a 00                	push   $0x0
8010637f:	6a 04                	push   $0x4
80106381:	e8 8a c7 ff ff       	call   80102b10 <ioapicenable>
80106386:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106389:	b8 78 00 00 00       	mov    $0x78,%eax
8010638e:	eb 04                	jmp    80106394 <uartinit+0x94>
80106390:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106394:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
8010639a:	85 d2                	test   %edx,%edx
8010639c:	74 08                	je     801063a6 <uartinit+0xa6>
    uartputc(*p);
8010639e:	0f be c0             	movsbl %al,%eax
801063a1:	e8 0a ff ff ff       	call   801062b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801063a6:	89 f0                	mov    %esi,%eax
801063a8:	83 c3 01             	add    $0x1,%ebx
801063ab:	84 c0                	test   %al,%al
801063ad:	75 e1                	jne    80106390 <uartinit+0x90>
}
801063af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b2:	5b                   	pop    %ebx
801063b3:	5e                   	pop    %esi
801063b4:	5f                   	pop    %edi
801063b5:	5d                   	pop    %ebp
801063b6:	c3                   	ret    
801063b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063be:	66 90                	xchg   %ax,%ax

801063c0 <uartputc>:
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
  if(!uart)
801063c5:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
{
801063cb:	89 e5                	mov    %esp,%ebp
801063cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063d0:	85 d2                	test   %edx,%edx
801063d2:	74 0c                	je     801063e0 <uartputc+0x20>
}
801063d4:	5d                   	pop    %ebp
801063d5:	e9 d6 fe ff ff       	jmp    801062b0 <uartputc.part.0>
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063e0:	5d                   	pop    %ebp
801063e1:	c3                   	ret    
801063e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063f0 <uartintr>:

void
uartintr(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063fa:	68 80 62 10 80       	push   $0x80106280
801063ff:	e8 fc a7 ff ff       	call   80100c00 <consoleintr>
}
80106404:	83 c4 10             	add    $0x10,%esp
80106407:	c9                   	leave  
80106408:	c3                   	ret    

80106409 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $0
8010640b:	6a 00                	push   $0x0
  jmp alltraps
8010640d:	e9 3c fb ff ff       	jmp    80105f4e <alltraps>

80106412 <vector1>:
.globl vector1
vector1:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $1
80106414:	6a 01                	push   $0x1
  jmp alltraps
80106416:	e9 33 fb ff ff       	jmp    80105f4e <alltraps>

8010641b <vector2>:
.globl vector2
vector2:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $2
8010641d:	6a 02                	push   $0x2
  jmp alltraps
8010641f:	e9 2a fb ff ff       	jmp    80105f4e <alltraps>

80106424 <vector3>:
.globl vector3
vector3:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $3
80106426:	6a 03                	push   $0x3
  jmp alltraps
80106428:	e9 21 fb ff ff       	jmp    80105f4e <alltraps>

8010642d <vector4>:
.globl vector4
vector4:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $4
8010642f:	6a 04                	push   $0x4
  jmp alltraps
80106431:	e9 18 fb ff ff       	jmp    80105f4e <alltraps>

80106436 <vector5>:
.globl vector5
vector5:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $5
80106438:	6a 05                	push   $0x5
  jmp alltraps
8010643a:	e9 0f fb ff ff       	jmp    80105f4e <alltraps>

8010643f <vector6>:
.globl vector6
vector6:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $6
80106441:	6a 06                	push   $0x6
  jmp alltraps
80106443:	e9 06 fb ff ff       	jmp    80105f4e <alltraps>

80106448 <vector7>:
.globl vector7
vector7:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $7
8010644a:	6a 07                	push   $0x7
  jmp alltraps
8010644c:	e9 fd fa ff ff       	jmp    80105f4e <alltraps>

80106451 <vector8>:
.globl vector8
vector8:
  pushl $8
80106451:	6a 08                	push   $0x8
  jmp alltraps
80106453:	e9 f6 fa ff ff       	jmp    80105f4e <alltraps>

80106458 <vector9>:
.globl vector9
vector9:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $9
8010645a:	6a 09                	push   $0x9
  jmp alltraps
8010645c:	e9 ed fa ff ff       	jmp    80105f4e <alltraps>

80106461 <vector10>:
.globl vector10
vector10:
  pushl $10
80106461:	6a 0a                	push   $0xa
  jmp alltraps
80106463:	e9 e6 fa ff ff       	jmp    80105f4e <alltraps>

80106468 <vector11>:
.globl vector11
vector11:
  pushl $11
80106468:	6a 0b                	push   $0xb
  jmp alltraps
8010646a:	e9 df fa ff ff       	jmp    80105f4e <alltraps>

8010646f <vector12>:
.globl vector12
vector12:
  pushl $12
8010646f:	6a 0c                	push   $0xc
  jmp alltraps
80106471:	e9 d8 fa ff ff       	jmp    80105f4e <alltraps>

80106476 <vector13>:
.globl vector13
vector13:
  pushl $13
80106476:	6a 0d                	push   $0xd
  jmp alltraps
80106478:	e9 d1 fa ff ff       	jmp    80105f4e <alltraps>

8010647d <vector14>:
.globl vector14
vector14:
  pushl $14
8010647d:	6a 0e                	push   $0xe
  jmp alltraps
8010647f:	e9 ca fa ff ff       	jmp    80105f4e <alltraps>

80106484 <vector15>:
.globl vector15
vector15:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $15
80106486:	6a 0f                	push   $0xf
  jmp alltraps
80106488:	e9 c1 fa ff ff       	jmp    80105f4e <alltraps>

8010648d <vector16>:
.globl vector16
vector16:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $16
8010648f:	6a 10                	push   $0x10
  jmp alltraps
80106491:	e9 b8 fa ff ff       	jmp    80105f4e <alltraps>

80106496 <vector17>:
.globl vector17
vector17:
  pushl $17
80106496:	6a 11                	push   $0x11
  jmp alltraps
80106498:	e9 b1 fa ff ff       	jmp    80105f4e <alltraps>

8010649d <vector18>:
.globl vector18
vector18:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $18
8010649f:	6a 12                	push   $0x12
  jmp alltraps
801064a1:	e9 a8 fa ff ff       	jmp    80105f4e <alltraps>

801064a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $19
801064a8:	6a 13                	push   $0x13
  jmp alltraps
801064aa:	e9 9f fa ff ff       	jmp    80105f4e <alltraps>

801064af <vector20>:
.globl vector20
vector20:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $20
801064b1:	6a 14                	push   $0x14
  jmp alltraps
801064b3:	e9 96 fa ff ff       	jmp    80105f4e <alltraps>

801064b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $21
801064ba:	6a 15                	push   $0x15
  jmp alltraps
801064bc:	e9 8d fa ff ff       	jmp    80105f4e <alltraps>

801064c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $22
801064c3:	6a 16                	push   $0x16
  jmp alltraps
801064c5:	e9 84 fa ff ff       	jmp    80105f4e <alltraps>

801064ca <vector23>:
.globl vector23
vector23:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $23
801064cc:	6a 17                	push   $0x17
  jmp alltraps
801064ce:	e9 7b fa ff ff       	jmp    80105f4e <alltraps>

801064d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $24
801064d5:	6a 18                	push   $0x18
  jmp alltraps
801064d7:	e9 72 fa ff ff       	jmp    80105f4e <alltraps>

801064dc <vector25>:
.globl vector25
vector25:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $25
801064de:	6a 19                	push   $0x19
  jmp alltraps
801064e0:	e9 69 fa ff ff       	jmp    80105f4e <alltraps>

801064e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $26
801064e7:	6a 1a                	push   $0x1a
  jmp alltraps
801064e9:	e9 60 fa ff ff       	jmp    80105f4e <alltraps>

801064ee <vector27>:
.globl vector27
vector27:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $27
801064f0:	6a 1b                	push   $0x1b
  jmp alltraps
801064f2:	e9 57 fa ff ff       	jmp    80105f4e <alltraps>

801064f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $28
801064f9:	6a 1c                	push   $0x1c
  jmp alltraps
801064fb:	e9 4e fa ff ff       	jmp    80105f4e <alltraps>

80106500 <vector29>:
.globl vector29
vector29:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $29
80106502:	6a 1d                	push   $0x1d
  jmp alltraps
80106504:	e9 45 fa ff ff       	jmp    80105f4e <alltraps>

80106509 <vector30>:
.globl vector30
vector30:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $30
8010650b:	6a 1e                	push   $0x1e
  jmp alltraps
8010650d:	e9 3c fa ff ff       	jmp    80105f4e <alltraps>

80106512 <vector31>:
.globl vector31
vector31:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $31
80106514:	6a 1f                	push   $0x1f
  jmp alltraps
80106516:	e9 33 fa ff ff       	jmp    80105f4e <alltraps>

8010651b <vector32>:
.globl vector32
vector32:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $32
8010651d:	6a 20                	push   $0x20
  jmp alltraps
8010651f:	e9 2a fa ff ff       	jmp    80105f4e <alltraps>

80106524 <vector33>:
.globl vector33
vector33:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $33
80106526:	6a 21                	push   $0x21
  jmp alltraps
80106528:	e9 21 fa ff ff       	jmp    80105f4e <alltraps>

8010652d <vector34>:
.globl vector34
vector34:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $34
8010652f:	6a 22                	push   $0x22
  jmp alltraps
80106531:	e9 18 fa ff ff       	jmp    80105f4e <alltraps>

80106536 <vector35>:
.globl vector35
vector35:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $35
80106538:	6a 23                	push   $0x23
  jmp alltraps
8010653a:	e9 0f fa ff ff       	jmp    80105f4e <alltraps>

8010653f <vector36>:
.globl vector36
vector36:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $36
80106541:	6a 24                	push   $0x24
  jmp alltraps
80106543:	e9 06 fa ff ff       	jmp    80105f4e <alltraps>

80106548 <vector37>:
.globl vector37
vector37:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $37
8010654a:	6a 25                	push   $0x25
  jmp alltraps
8010654c:	e9 fd f9 ff ff       	jmp    80105f4e <alltraps>

80106551 <vector38>:
.globl vector38
vector38:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $38
80106553:	6a 26                	push   $0x26
  jmp alltraps
80106555:	e9 f4 f9 ff ff       	jmp    80105f4e <alltraps>

8010655a <vector39>:
.globl vector39
vector39:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $39
8010655c:	6a 27                	push   $0x27
  jmp alltraps
8010655e:	e9 eb f9 ff ff       	jmp    80105f4e <alltraps>

80106563 <vector40>:
.globl vector40
vector40:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $40
80106565:	6a 28                	push   $0x28
  jmp alltraps
80106567:	e9 e2 f9 ff ff       	jmp    80105f4e <alltraps>

8010656c <vector41>:
.globl vector41
vector41:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $41
8010656e:	6a 29                	push   $0x29
  jmp alltraps
80106570:	e9 d9 f9 ff ff       	jmp    80105f4e <alltraps>

80106575 <vector42>:
.globl vector42
vector42:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $42
80106577:	6a 2a                	push   $0x2a
  jmp alltraps
80106579:	e9 d0 f9 ff ff       	jmp    80105f4e <alltraps>

8010657e <vector43>:
.globl vector43
vector43:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $43
80106580:	6a 2b                	push   $0x2b
  jmp alltraps
80106582:	e9 c7 f9 ff ff       	jmp    80105f4e <alltraps>

80106587 <vector44>:
.globl vector44
vector44:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $44
80106589:	6a 2c                	push   $0x2c
  jmp alltraps
8010658b:	e9 be f9 ff ff       	jmp    80105f4e <alltraps>

80106590 <vector45>:
.globl vector45
vector45:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $45
80106592:	6a 2d                	push   $0x2d
  jmp alltraps
80106594:	e9 b5 f9 ff ff       	jmp    80105f4e <alltraps>

80106599 <vector46>:
.globl vector46
vector46:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $46
8010659b:	6a 2e                	push   $0x2e
  jmp alltraps
8010659d:	e9 ac f9 ff ff       	jmp    80105f4e <alltraps>

801065a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $47
801065a4:	6a 2f                	push   $0x2f
  jmp alltraps
801065a6:	e9 a3 f9 ff ff       	jmp    80105f4e <alltraps>

801065ab <vector48>:
.globl vector48
vector48:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $48
801065ad:	6a 30                	push   $0x30
  jmp alltraps
801065af:	e9 9a f9 ff ff       	jmp    80105f4e <alltraps>

801065b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $49
801065b6:	6a 31                	push   $0x31
  jmp alltraps
801065b8:	e9 91 f9 ff ff       	jmp    80105f4e <alltraps>

801065bd <vector50>:
.globl vector50
vector50:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $50
801065bf:	6a 32                	push   $0x32
  jmp alltraps
801065c1:	e9 88 f9 ff ff       	jmp    80105f4e <alltraps>

801065c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $51
801065c8:	6a 33                	push   $0x33
  jmp alltraps
801065ca:	e9 7f f9 ff ff       	jmp    80105f4e <alltraps>

801065cf <vector52>:
.globl vector52
vector52:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $52
801065d1:	6a 34                	push   $0x34
  jmp alltraps
801065d3:	e9 76 f9 ff ff       	jmp    80105f4e <alltraps>

801065d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $53
801065da:	6a 35                	push   $0x35
  jmp alltraps
801065dc:	e9 6d f9 ff ff       	jmp    80105f4e <alltraps>

801065e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $54
801065e3:	6a 36                	push   $0x36
  jmp alltraps
801065e5:	e9 64 f9 ff ff       	jmp    80105f4e <alltraps>

801065ea <vector55>:
.globl vector55
vector55:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $55
801065ec:	6a 37                	push   $0x37
  jmp alltraps
801065ee:	e9 5b f9 ff ff       	jmp    80105f4e <alltraps>

801065f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $56
801065f5:	6a 38                	push   $0x38
  jmp alltraps
801065f7:	e9 52 f9 ff ff       	jmp    80105f4e <alltraps>

801065fc <vector57>:
.globl vector57
vector57:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $57
801065fe:	6a 39                	push   $0x39
  jmp alltraps
80106600:	e9 49 f9 ff ff       	jmp    80105f4e <alltraps>

80106605 <vector58>:
.globl vector58
vector58:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $58
80106607:	6a 3a                	push   $0x3a
  jmp alltraps
80106609:	e9 40 f9 ff ff       	jmp    80105f4e <alltraps>

8010660e <vector59>:
.globl vector59
vector59:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $59
80106610:	6a 3b                	push   $0x3b
  jmp alltraps
80106612:	e9 37 f9 ff ff       	jmp    80105f4e <alltraps>

80106617 <vector60>:
.globl vector60
vector60:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $60
80106619:	6a 3c                	push   $0x3c
  jmp alltraps
8010661b:	e9 2e f9 ff ff       	jmp    80105f4e <alltraps>

80106620 <vector61>:
.globl vector61
vector61:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $61
80106622:	6a 3d                	push   $0x3d
  jmp alltraps
80106624:	e9 25 f9 ff ff       	jmp    80105f4e <alltraps>

80106629 <vector62>:
.globl vector62
vector62:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $62
8010662b:	6a 3e                	push   $0x3e
  jmp alltraps
8010662d:	e9 1c f9 ff ff       	jmp    80105f4e <alltraps>

80106632 <vector63>:
.globl vector63
vector63:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $63
80106634:	6a 3f                	push   $0x3f
  jmp alltraps
80106636:	e9 13 f9 ff ff       	jmp    80105f4e <alltraps>

8010663b <vector64>:
.globl vector64
vector64:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $64
8010663d:	6a 40                	push   $0x40
  jmp alltraps
8010663f:	e9 0a f9 ff ff       	jmp    80105f4e <alltraps>

80106644 <vector65>:
.globl vector65
vector65:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $65
80106646:	6a 41                	push   $0x41
  jmp alltraps
80106648:	e9 01 f9 ff ff       	jmp    80105f4e <alltraps>

8010664d <vector66>:
.globl vector66
vector66:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $66
8010664f:	6a 42                	push   $0x42
  jmp alltraps
80106651:	e9 f8 f8 ff ff       	jmp    80105f4e <alltraps>

80106656 <vector67>:
.globl vector67
vector67:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $67
80106658:	6a 43                	push   $0x43
  jmp alltraps
8010665a:	e9 ef f8 ff ff       	jmp    80105f4e <alltraps>

8010665f <vector68>:
.globl vector68
vector68:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $68
80106661:	6a 44                	push   $0x44
  jmp alltraps
80106663:	e9 e6 f8 ff ff       	jmp    80105f4e <alltraps>

80106668 <vector69>:
.globl vector69
vector69:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $69
8010666a:	6a 45                	push   $0x45
  jmp alltraps
8010666c:	e9 dd f8 ff ff       	jmp    80105f4e <alltraps>

80106671 <vector70>:
.globl vector70
vector70:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $70
80106673:	6a 46                	push   $0x46
  jmp alltraps
80106675:	e9 d4 f8 ff ff       	jmp    80105f4e <alltraps>

8010667a <vector71>:
.globl vector71
vector71:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $71
8010667c:	6a 47                	push   $0x47
  jmp alltraps
8010667e:	e9 cb f8 ff ff       	jmp    80105f4e <alltraps>

80106683 <vector72>:
.globl vector72
vector72:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $72
80106685:	6a 48                	push   $0x48
  jmp alltraps
80106687:	e9 c2 f8 ff ff       	jmp    80105f4e <alltraps>

8010668c <vector73>:
.globl vector73
vector73:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $73
8010668e:	6a 49                	push   $0x49
  jmp alltraps
80106690:	e9 b9 f8 ff ff       	jmp    80105f4e <alltraps>

80106695 <vector74>:
.globl vector74
vector74:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $74
80106697:	6a 4a                	push   $0x4a
  jmp alltraps
80106699:	e9 b0 f8 ff ff       	jmp    80105f4e <alltraps>

8010669e <vector75>:
.globl vector75
vector75:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $75
801066a0:	6a 4b                	push   $0x4b
  jmp alltraps
801066a2:	e9 a7 f8 ff ff       	jmp    80105f4e <alltraps>

801066a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $76
801066a9:	6a 4c                	push   $0x4c
  jmp alltraps
801066ab:	e9 9e f8 ff ff       	jmp    80105f4e <alltraps>

801066b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $77
801066b2:	6a 4d                	push   $0x4d
  jmp alltraps
801066b4:	e9 95 f8 ff ff       	jmp    80105f4e <alltraps>

801066b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $78
801066bb:	6a 4e                	push   $0x4e
  jmp alltraps
801066bd:	e9 8c f8 ff ff       	jmp    80105f4e <alltraps>

801066c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $79
801066c4:	6a 4f                	push   $0x4f
  jmp alltraps
801066c6:	e9 83 f8 ff ff       	jmp    80105f4e <alltraps>

801066cb <vector80>:
.globl vector80
vector80:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $80
801066cd:	6a 50                	push   $0x50
  jmp alltraps
801066cf:	e9 7a f8 ff ff       	jmp    80105f4e <alltraps>

801066d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $81
801066d6:	6a 51                	push   $0x51
  jmp alltraps
801066d8:	e9 71 f8 ff ff       	jmp    80105f4e <alltraps>

801066dd <vector82>:
.globl vector82
vector82:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $82
801066df:	6a 52                	push   $0x52
  jmp alltraps
801066e1:	e9 68 f8 ff ff       	jmp    80105f4e <alltraps>

801066e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $83
801066e8:	6a 53                	push   $0x53
  jmp alltraps
801066ea:	e9 5f f8 ff ff       	jmp    80105f4e <alltraps>

801066ef <vector84>:
.globl vector84
vector84:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $84
801066f1:	6a 54                	push   $0x54
  jmp alltraps
801066f3:	e9 56 f8 ff ff       	jmp    80105f4e <alltraps>

801066f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $85
801066fa:	6a 55                	push   $0x55
  jmp alltraps
801066fc:	e9 4d f8 ff ff       	jmp    80105f4e <alltraps>

80106701 <vector86>:
.globl vector86
vector86:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $86
80106703:	6a 56                	push   $0x56
  jmp alltraps
80106705:	e9 44 f8 ff ff       	jmp    80105f4e <alltraps>

8010670a <vector87>:
.globl vector87
vector87:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $87
8010670c:	6a 57                	push   $0x57
  jmp alltraps
8010670e:	e9 3b f8 ff ff       	jmp    80105f4e <alltraps>

80106713 <vector88>:
.globl vector88
vector88:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $88
80106715:	6a 58                	push   $0x58
  jmp alltraps
80106717:	e9 32 f8 ff ff       	jmp    80105f4e <alltraps>

8010671c <vector89>:
.globl vector89
vector89:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $89
8010671e:	6a 59                	push   $0x59
  jmp alltraps
80106720:	e9 29 f8 ff ff       	jmp    80105f4e <alltraps>

80106725 <vector90>:
.globl vector90
vector90:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $90
80106727:	6a 5a                	push   $0x5a
  jmp alltraps
80106729:	e9 20 f8 ff ff       	jmp    80105f4e <alltraps>

8010672e <vector91>:
.globl vector91
vector91:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $91
80106730:	6a 5b                	push   $0x5b
  jmp alltraps
80106732:	e9 17 f8 ff ff       	jmp    80105f4e <alltraps>

80106737 <vector92>:
.globl vector92
vector92:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $92
80106739:	6a 5c                	push   $0x5c
  jmp alltraps
8010673b:	e9 0e f8 ff ff       	jmp    80105f4e <alltraps>

80106740 <vector93>:
.globl vector93
vector93:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $93
80106742:	6a 5d                	push   $0x5d
  jmp alltraps
80106744:	e9 05 f8 ff ff       	jmp    80105f4e <alltraps>

80106749 <vector94>:
.globl vector94
vector94:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $94
8010674b:	6a 5e                	push   $0x5e
  jmp alltraps
8010674d:	e9 fc f7 ff ff       	jmp    80105f4e <alltraps>

80106752 <vector95>:
.globl vector95
vector95:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $95
80106754:	6a 5f                	push   $0x5f
  jmp alltraps
80106756:	e9 f3 f7 ff ff       	jmp    80105f4e <alltraps>

8010675b <vector96>:
.globl vector96
vector96:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $96
8010675d:	6a 60                	push   $0x60
  jmp alltraps
8010675f:	e9 ea f7 ff ff       	jmp    80105f4e <alltraps>

80106764 <vector97>:
.globl vector97
vector97:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $97
80106766:	6a 61                	push   $0x61
  jmp alltraps
80106768:	e9 e1 f7 ff ff       	jmp    80105f4e <alltraps>

8010676d <vector98>:
.globl vector98
vector98:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $98
8010676f:	6a 62                	push   $0x62
  jmp alltraps
80106771:	e9 d8 f7 ff ff       	jmp    80105f4e <alltraps>

80106776 <vector99>:
.globl vector99
vector99:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $99
80106778:	6a 63                	push   $0x63
  jmp alltraps
8010677a:	e9 cf f7 ff ff       	jmp    80105f4e <alltraps>

8010677f <vector100>:
.globl vector100
vector100:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $100
80106781:	6a 64                	push   $0x64
  jmp alltraps
80106783:	e9 c6 f7 ff ff       	jmp    80105f4e <alltraps>

80106788 <vector101>:
.globl vector101
vector101:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $101
8010678a:	6a 65                	push   $0x65
  jmp alltraps
8010678c:	e9 bd f7 ff ff       	jmp    80105f4e <alltraps>

80106791 <vector102>:
.globl vector102
vector102:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $102
80106793:	6a 66                	push   $0x66
  jmp alltraps
80106795:	e9 b4 f7 ff ff       	jmp    80105f4e <alltraps>

8010679a <vector103>:
.globl vector103
vector103:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $103
8010679c:	6a 67                	push   $0x67
  jmp alltraps
8010679e:	e9 ab f7 ff ff       	jmp    80105f4e <alltraps>

801067a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $104
801067a5:	6a 68                	push   $0x68
  jmp alltraps
801067a7:	e9 a2 f7 ff ff       	jmp    80105f4e <alltraps>

801067ac <vector105>:
.globl vector105
vector105:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $105
801067ae:	6a 69                	push   $0x69
  jmp alltraps
801067b0:	e9 99 f7 ff ff       	jmp    80105f4e <alltraps>

801067b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $106
801067b7:	6a 6a                	push   $0x6a
  jmp alltraps
801067b9:	e9 90 f7 ff ff       	jmp    80105f4e <alltraps>

801067be <vector107>:
.globl vector107
vector107:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $107
801067c0:	6a 6b                	push   $0x6b
  jmp alltraps
801067c2:	e9 87 f7 ff ff       	jmp    80105f4e <alltraps>

801067c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $108
801067c9:	6a 6c                	push   $0x6c
  jmp alltraps
801067cb:	e9 7e f7 ff ff       	jmp    80105f4e <alltraps>

801067d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $109
801067d2:	6a 6d                	push   $0x6d
  jmp alltraps
801067d4:	e9 75 f7 ff ff       	jmp    80105f4e <alltraps>

801067d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $110
801067db:	6a 6e                	push   $0x6e
  jmp alltraps
801067dd:	e9 6c f7 ff ff       	jmp    80105f4e <alltraps>

801067e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $111
801067e4:	6a 6f                	push   $0x6f
  jmp alltraps
801067e6:	e9 63 f7 ff ff       	jmp    80105f4e <alltraps>

801067eb <vector112>:
.globl vector112
vector112:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $112
801067ed:	6a 70                	push   $0x70
  jmp alltraps
801067ef:	e9 5a f7 ff ff       	jmp    80105f4e <alltraps>

801067f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $113
801067f6:	6a 71                	push   $0x71
  jmp alltraps
801067f8:	e9 51 f7 ff ff       	jmp    80105f4e <alltraps>

801067fd <vector114>:
.globl vector114
vector114:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $114
801067ff:	6a 72                	push   $0x72
  jmp alltraps
80106801:	e9 48 f7 ff ff       	jmp    80105f4e <alltraps>

80106806 <vector115>:
.globl vector115
vector115:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $115
80106808:	6a 73                	push   $0x73
  jmp alltraps
8010680a:	e9 3f f7 ff ff       	jmp    80105f4e <alltraps>

8010680f <vector116>:
.globl vector116
vector116:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $116
80106811:	6a 74                	push   $0x74
  jmp alltraps
80106813:	e9 36 f7 ff ff       	jmp    80105f4e <alltraps>

80106818 <vector117>:
.globl vector117
vector117:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $117
8010681a:	6a 75                	push   $0x75
  jmp alltraps
8010681c:	e9 2d f7 ff ff       	jmp    80105f4e <alltraps>

80106821 <vector118>:
.globl vector118
vector118:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $118
80106823:	6a 76                	push   $0x76
  jmp alltraps
80106825:	e9 24 f7 ff ff       	jmp    80105f4e <alltraps>

8010682a <vector119>:
.globl vector119
vector119:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $119
8010682c:	6a 77                	push   $0x77
  jmp alltraps
8010682e:	e9 1b f7 ff ff       	jmp    80105f4e <alltraps>

80106833 <vector120>:
.globl vector120
vector120:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $120
80106835:	6a 78                	push   $0x78
  jmp alltraps
80106837:	e9 12 f7 ff ff       	jmp    80105f4e <alltraps>

8010683c <vector121>:
.globl vector121
vector121:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $121
8010683e:	6a 79                	push   $0x79
  jmp alltraps
80106840:	e9 09 f7 ff ff       	jmp    80105f4e <alltraps>

80106845 <vector122>:
.globl vector122
vector122:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $122
80106847:	6a 7a                	push   $0x7a
  jmp alltraps
80106849:	e9 00 f7 ff ff       	jmp    80105f4e <alltraps>

8010684e <vector123>:
.globl vector123
vector123:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $123
80106850:	6a 7b                	push   $0x7b
  jmp alltraps
80106852:	e9 f7 f6 ff ff       	jmp    80105f4e <alltraps>

80106857 <vector124>:
.globl vector124
vector124:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $124
80106859:	6a 7c                	push   $0x7c
  jmp alltraps
8010685b:	e9 ee f6 ff ff       	jmp    80105f4e <alltraps>

80106860 <vector125>:
.globl vector125
vector125:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $125
80106862:	6a 7d                	push   $0x7d
  jmp alltraps
80106864:	e9 e5 f6 ff ff       	jmp    80105f4e <alltraps>

80106869 <vector126>:
.globl vector126
vector126:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $126
8010686b:	6a 7e                	push   $0x7e
  jmp alltraps
8010686d:	e9 dc f6 ff ff       	jmp    80105f4e <alltraps>

80106872 <vector127>:
.globl vector127
vector127:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $127
80106874:	6a 7f                	push   $0x7f
  jmp alltraps
80106876:	e9 d3 f6 ff ff       	jmp    80105f4e <alltraps>

8010687b <vector128>:
.globl vector128
vector128:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $128
8010687d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106882:	e9 c7 f6 ff ff       	jmp    80105f4e <alltraps>

80106887 <vector129>:
.globl vector129
vector129:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $129
80106889:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010688e:	e9 bb f6 ff ff       	jmp    80105f4e <alltraps>

80106893 <vector130>:
.globl vector130
vector130:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $130
80106895:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010689a:	e9 af f6 ff ff       	jmp    80105f4e <alltraps>

8010689f <vector131>:
.globl vector131
vector131:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $131
801068a1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068a6:	e9 a3 f6 ff ff       	jmp    80105f4e <alltraps>

801068ab <vector132>:
.globl vector132
vector132:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $132
801068ad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068b2:	e9 97 f6 ff ff       	jmp    80105f4e <alltraps>

801068b7 <vector133>:
.globl vector133
vector133:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $133
801068b9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068be:	e9 8b f6 ff ff       	jmp    80105f4e <alltraps>

801068c3 <vector134>:
.globl vector134
vector134:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $134
801068c5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068ca:	e9 7f f6 ff ff       	jmp    80105f4e <alltraps>

801068cf <vector135>:
.globl vector135
vector135:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $135
801068d1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068d6:	e9 73 f6 ff ff       	jmp    80105f4e <alltraps>

801068db <vector136>:
.globl vector136
vector136:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $136
801068dd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068e2:	e9 67 f6 ff ff       	jmp    80105f4e <alltraps>

801068e7 <vector137>:
.globl vector137
vector137:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $137
801068e9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ee:	e9 5b f6 ff ff       	jmp    80105f4e <alltraps>

801068f3 <vector138>:
.globl vector138
vector138:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $138
801068f5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068fa:	e9 4f f6 ff ff       	jmp    80105f4e <alltraps>

801068ff <vector139>:
.globl vector139
vector139:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $139
80106901:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106906:	e9 43 f6 ff ff       	jmp    80105f4e <alltraps>

8010690b <vector140>:
.globl vector140
vector140:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $140
8010690d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106912:	e9 37 f6 ff ff       	jmp    80105f4e <alltraps>

80106917 <vector141>:
.globl vector141
vector141:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $141
80106919:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010691e:	e9 2b f6 ff ff       	jmp    80105f4e <alltraps>

80106923 <vector142>:
.globl vector142
vector142:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $142
80106925:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010692a:	e9 1f f6 ff ff       	jmp    80105f4e <alltraps>

8010692f <vector143>:
.globl vector143
vector143:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $143
80106931:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106936:	e9 13 f6 ff ff       	jmp    80105f4e <alltraps>

8010693b <vector144>:
.globl vector144
vector144:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $144
8010693d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106942:	e9 07 f6 ff ff       	jmp    80105f4e <alltraps>

80106947 <vector145>:
.globl vector145
vector145:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $145
80106949:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010694e:	e9 fb f5 ff ff       	jmp    80105f4e <alltraps>

80106953 <vector146>:
.globl vector146
vector146:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $146
80106955:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010695a:	e9 ef f5 ff ff       	jmp    80105f4e <alltraps>

8010695f <vector147>:
.globl vector147
vector147:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $147
80106961:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106966:	e9 e3 f5 ff ff       	jmp    80105f4e <alltraps>

8010696b <vector148>:
.globl vector148
vector148:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $148
8010696d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106972:	e9 d7 f5 ff ff       	jmp    80105f4e <alltraps>

80106977 <vector149>:
.globl vector149
vector149:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $149
80106979:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010697e:	e9 cb f5 ff ff       	jmp    80105f4e <alltraps>

80106983 <vector150>:
.globl vector150
vector150:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $150
80106985:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010698a:	e9 bf f5 ff ff       	jmp    80105f4e <alltraps>

8010698f <vector151>:
.globl vector151
vector151:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $151
80106991:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106996:	e9 b3 f5 ff ff       	jmp    80105f4e <alltraps>

8010699b <vector152>:
.globl vector152
vector152:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $152
8010699d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069a2:	e9 a7 f5 ff ff       	jmp    80105f4e <alltraps>

801069a7 <vector153>:
.globl vector153
vector153:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $153
801069a9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ae:	e9 9b f5 ff ff       	jmp    80105f4e <alltraps>

801069b3 <vector154>:
.globl vector154
vector154:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $154
801069b5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069ba:	e9 8f f5 ff ff       	jmp    80105f4e <alltraps>

801069bf <vector155>:
.globl vector155
vector155:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $155
801069c1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069c6:	e9 83 f5 ff ff       	jmp    80105f4e <alltraps>

801069cb <vector156>:
.globl vector156
vector156:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $156
801069cd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069d2:	e9 77 f5 ff ff       	jmp    80105f4e <alltraps>

801069d7 <vector157>:
.globl vector157
vector157:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $157
801069d9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069de:	e9 6b f5 ff ff       	jmp    80105f4e <alltraps>

801069e3 <vector158>:
.globl vector158
vector158:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $158
801069e5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069ea:	e9 5f f5 ff ff       	jmp    80105f4e <alltraps>

801069ef <vector159>:
.globl vector159
vector159:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $159
801069f1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069f6:	e9 53 f5 ff ff       	jmp    80105f4e <alltraps>

801069fb <vector160>:
.globl vector160
vector160:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $160
801069fd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a02:	e9 47 f5 ff ff       	jmp    80105f4e <alltraps>

80106a07 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $161
80106a09:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a0e:	e9 3b f5 ff ff       	jmp    80105f4e <alltraps>

80106a13 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $162
80106a15:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a1a:	e9 2f f5 ff ff       	jmp    80105f4e <alltraps>

80106a1f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $163
80106a21:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a26:	e9 23 f5 ff ff       	jmp    80105f4e <alltraps>

80106a2b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $164
80106a2d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a32:	e9 17 f5 ff ff       	jmp    80105f4e <alltraps>

80106a37 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $165
80106a39:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a3e:	e9 0b f5 ff ff       	jmp    80105f4e <alltraps>

80106a43 <vector166>:
.globl vector166
vector166:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $166
80106a45:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a4a:	e9 ff f4 ff ff       	jmp    80105f4e <alltraps>

80106a4f <vector167>:
.globl vector167
vector167:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $167
80106a51:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a56:	e9 f3 f4 ff ff       	jmp    80105f4e <alltraps>

80106a5b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $168
80106a5d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a62:	e9 e7 f4 ff ff       	jmp    80105f4e <alltraps>

80106a67 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $169
80106a69:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a6e:	e9 db f4 ff ff       	jmp    80105f4e <alltraps>

80106a73 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $170
80106a75:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a7a:	e9 cf f4 ff ff       	jmp    80105f4e <alltraps>

80106a7f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $171
80106a81:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a86:	e9 c3 f4 ff ff       	jmp    80105f4e <alltraps>

80106a8b <vector172>:
.globl vector172
vector172:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $172
80106a8d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a92:	e9 b7 f4 ff ff       	jmp    80105f4e <alltraps>

80106a97 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $173
80106a99:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a9e:	e9 ab f4 ff ff       	jmp    80105f4e <alltraps>

80106aa3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $174
80106aa5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106aaa:	e9 9f f4 ff ff       	jmp    80105f4e <alltraps>

80106aaf <vector175>:
.globl vector175
vector175:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $175
80106ab1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ab6:	e9 93 f4 ff ff       	jmp    80105f4e <alltraps>

80106abb <vector176>:
.globl vector176
vector176:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $176
80106abd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ac2:	e9 87 f4 ff ff       	jmp    80105f4e <alltraps>

80106ac7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $177
80106ac9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ace:	e9 7b f4 ff ff       	jmp    80105f4e <alltraps>

80106ad3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $178
80106ad5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ada:	e9 6f f4 ff ff       	jmp    80105f4e <alltraps>

80106adf <vector179>:
.globl vector179
vector179:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $179
80106ae1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ae6:	e9 63 f4 ff ff       	jmp    80105f4e <alltraps>

80106aeb <vector180>:
.globl vector180
vector180:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $180
80106aed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106af2:	e9 57 f4 ff ff       	jmp    80105f4e <alltraps>

80106af7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $181
80106af9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106afe:	e9 4b f4 ff ff       	jmp    80105f4e <alltraps>

80106b03 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $182
80106b05:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b0a:	e9 3f f4 ff ff       	jmp    80105f4e <alltraps>

80106b0f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $183
80106b11:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b16:	e9 33 f4 ff ff       	jmp    80105f4e <alltraps>

80106b1b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $184
80106b1d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b22:	e9 27 f4 ff ff       	jmp    80105f4e <alltraps>

80106b27 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $185
80106b29:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b2e:	e9 1b f4 ff ff       	jmp    80105f4e <alltraps>

80106b33 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $186
80106b35:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b3a:	e9 0f f4 ff ff       	jmp    80105f4e <alltraps>

80106b3f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $187
80106b41:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b46:	e9 03 f4 ff ff       	jmp    80105f4e <alltraps>

80106b4b <vector188>:
.globl vector188
vector188:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $188
80106b4d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b52:	e9 f7 f3 ff ff       	jmp    80105f4e <alltraps>

80106b57 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $189
80106b59:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b5e:	e9 eb f3 ff ff       	jmp    80105f4e <alltraps>

80106b63 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $190
80106b65:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b6a:	e9 df f3 ff ff       	jmp    80105f4e <alltraps>

80106b6f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $191
80106b71:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b76:	e9 d3 f3 ff ff       	jmp    80105f4e <alltraps>

80106b7b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $192
80106b7d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b82:	e9 c7 f3 ff ff       	jmp    80105f4e <alltraps>

80106b87 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $193
80106b89:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b8e:	e9 bb f3 ff ff       	jmp    80105f4e <alltraps>

80106b93 <vector194>:
.globl vector194
vector194:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $194
80106b95:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b9a:	e9 af f3 ff ff       	jmp    80105f4e <alltraps>

80106b9f <vector195>:
.globl vector195
vector195:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $195
80106ba1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ba6:	e9 a3 f3 ff ff       	jmp    80105f4e <alltraps>

80106bab <vector196>:
.globl vector196
vector196:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $196
80106bad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bb2:	e9 97 f3 ff ff       	jmp    80105f4e <alltraps>

80106bb7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $197
80106bb9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bbe:	e9 8b f3 ff ff       	jmp    80105f4e <alltraps>

80106bc3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $198
80106bc5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bca:	e9 7f f3 ff ff       	jmp    80105f4e <alltraps>

80106bcf <vector199>:
.globl vector199
vector199:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $199
80106bd1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bd6:	e9 73 f3 ff ff       	jmp    80105f4e <alltraps>

80106bdb <vector200>:
.globl vector200
vector200:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $200
80106bdd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106be2:	e9 67 f3 ff ff       	jmp    80105f4e <alltraps>

80106be7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $201
80106be9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bee:	e9 5b f3 ff ff       	jmp    80105f4e <alltraps>

80106bf3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $202
80106bf5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bfa:	e9 4f f3 ff ff       	jmp    80105f4e <alltraps>

80106bff <vector203>:
.globl vector203
vector203:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $203
80106c01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c06:	e9 43 f3 ff ff       	jmp    80105f4e <alltraps>

80106c0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $204
80106c0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c12:	e9 37 f3 ff ff       	jmp    80105f4e <alltraps>

80106c17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $205
80106c19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c1e:	e9 2b f3 ff ff       	jmp    80105f4e <alltraps>

80106c23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $206
80106c25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c2a:	e9 1f f3 ff ff       	jmp    80105f4e <alltraps>

80106c2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $207
80106c31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c36:	e9 13 f3 ff ff       	jmp    80105f4e <alltraps>

80106c3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $208
80106c3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c42:	e9 07 f3 ff ff       	jmp    80105f4e <alltraps>

80106c47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $209
80106c49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c4e:	e9 fb f2 ff ff       	jmp    80105f4e <alltraps>

80106c53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $210
80106c55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c5a:	e9 ef f2 ff ff       	jmp    80105f4e <alltraps>

80106c5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $211
80106c61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c66:	e9 e3 f2 ff ff       	jmp    80105f4e <alltraps>

80106c6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $212
80106c6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c72:	e9 d7 f2 ff ff       	jmp    80105f4e <alltraps>

80106c77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $213
80106c79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c7e:	e9 cb f2 ff ff       	jmp    80105f4e <alltraps>

80106c83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $214
80106c85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c8a:	e9 bf f2 ff ff       	jmp    80105f4e <alltraps>

80106c8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $215
80106c91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c96:	e9 b3 f2 ff ff       	jmp    80105f4e <alltraps>

80106c9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $216
80106c9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ca2:	e9 a7 f2 ff ff       	jmp    80105f4e <alltraps>

80106ca7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $217
80106ca9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cae:	e9 9b f2 ff ff       	jmp    80105f4e <alltraps>

80106cb3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $218
80106cb5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cba:	e9 8f f2 ff ff       	jmp    80105f4e <alltraps>

80106cbf <vector219>:
.globl vector219
vector219:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $219
80106cc1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cc6:	e9 83 f2 ff ff       	jmp    80105f4e <alltraps>

80106ccb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $220
80106ccd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cd2:	e9 77 f2 ff ff       	jmp    80105f4e <alltraps>

80106cd7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $221
80106cd9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cde:	e9 6b f2 ff ff       	jmp    80105f4e <alltraps>

80106ce3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $222
80106ce5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cea:	e9 5f f2 ff ff       	jmp    80105f4e <alltraps>

80106cef <vector223>:
.globl vector223
vector223:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $223
80106cf1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cf6:	e9 53 f2 ff ff       	jmp    80105f4e <alltraps>

80106cfb <vector224>:
.globl vector224
vector224:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $224
80106cfd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d02:	e9 47 f2 ff ff       	jmp    80105f4e <alltraps>

80106d07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $225
80106d09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d0e:	e9 3b f2 ff ff       	jmp    80105f4e <alltraps>

80106d13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $226
80106d15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d1a:	e9 2f f2 ff ff       	jmp    80105f4e <alltraps>

80106d1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $227
80106d21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d26:	e9 23 f2 ff ff       	jmp    80105f4e <alltraps>

80106d2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $228
80106d2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d32:	e9 17 f2 ff ff       	jmp    80105f4e <alltraps>

80106d37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $229
80106d39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d3e:	e9 0b f2 ff ff       	jmp    80105f4e <alltraps>

80106d43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $230
80106d45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d4a:	e9 ff f1 ff ff       	jmp    80105f4e <alltraps>

80106d4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $231
80106d51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d56:	e9 f3 f1 ff ff       	jmp    80105f4e <alltraps>

80106d5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $232
80106d5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d62:	e9 e7 f1 ff ff       	jmp    80105f4e <alltraps>

80106d67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $233
80106d69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d6e:	e9 db f1 ff ff       	jmp    80105f4e <alltraps>

80106d73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $234
80106d75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d7a:	e9 cf f1 ff ff       	jmp    80105f4e <alltraps>

80106d7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $235
80106d81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d86:	e9 c3 f1 ff ff       	jmp    80105f4e <alltraps>

80106d8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $236
80106d8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d92:	e9 b7 f1 ff ff       	jmp    80105f4e <alltraps>

80106d97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $237
80106d99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d9e:	e9 ab f1 ff ff       	jmp    80105f4e <alltraps>

80106da3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $238
80106da5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106daa:	e9 9f f1 ff ff       	jmp    80105f4e <alltraps>

80106daf <vector239>:
.globl vector239
vector239:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $239
80106db1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106db6:	e9 93 f1 ff ff       	jmp    80105f4e <alltraps>

80106dbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $240
80106dbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dc2:	e9 87 f1 ff ff       	jmp    80105f4e <alltraps>

80106dc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $241
80106dc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dce:	e9 7b f1 ff ff       	jmp    80105f4e <alltraps>

80106dd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $242
80106dd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dda:	e9 6f f1 ff ff       	jmp    80105f4e <alltraps>

80106ddf <vector243>:
.globl vector243
vector243:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $243
80106de1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106de6:	e9 63 f1 ff ff       	jmp    80105f4e <alltraps>

80106deb <vector244>:
.globl vector244
vector244:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $244
80106ded:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106df2:	e9 57 f1 ff ff       	jmp    80105f4e <alltraps>

80106df7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $245
80106df9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dfe:	e9 4b f1 ff ff       	jmp    80105f4e <alltraps>

80106e03 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $246
80106e05:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e0a:	e9 3f f1 ff ff       	jmp    80105f4e <alltraps>

80106e0f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $247
80106e11:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e16:	e9 33 f1 ff ff       	jmp    80105f4e <alltraps>

80106e1b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $248
80106e1d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e22:	e9 27 f1 ff ff       	jmp    80105f4e <alltraps>

80106e27 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $249
80106e29:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e2e:	e9 1b f1 ff ff       	jmp    80105f4e <alltraps>

80106e33 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $250
80106e35:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e3a:	e9 0f f1 ff ff       	jmp    80105f4e <alltraps>

80106e3f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $251
80106e41:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e46:	e9 03 f1 ff ff       	jmp    80105f4e <alltraps>

80106e4b <vector252>:
.globl vector252
vector252:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $252
80106e4d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e52:	e9 f7 f0 ff ff       	jmp    80105f4e <alltraps>

80106e57 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $253
80106e59:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e5e:	e9 eb f0 ff ff       	jmp    80105f4e <alltraps>

80106e63 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $254
80106e65:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e6a:	e9 df f0 ff ff       	jmp    80105f4e <alltraps>

80106e6f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $255
80106e71:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e76:	e9 d3 f0 ff ff       	jmp    80105f4e <alltraps>
80106e7b:	66 90                	xchg   %ax,%ax
80106e7d:	66 90                	xchg   %ax,%ax
80106e7f:	90                   	nop

80106e80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e87:	c1 ea 16             	shr    $0x16,%edx
{
80106e8a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106e8b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106e8e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e91:	8b 1f                	mov    (%edi),%ebx
80106e93:	f6 c3 01             	test   $0x1,%bl
80106e96:	74 28                	je     80106ec0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e9e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ea4:	89 f0                	mov    %esi,%eax
}
80106ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ea9:	c1 e8 0a             	shr    $0xa,%eax
80106eac:	25 fc 0f 00 00       	and    $0xffc,%eax
80106eb1:	01 d8                	add    %ebx,%eax
}
80106eb3:	5b                   	pop    %ebx
80106eb4:	5e                   	pop    %esi
80106eb5:	5f                   	pop    %edi
80106eb6:	5d                   	pop    %ebp
80106eb7:	c3                   	ret    
80106eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ec0:	85 c9                	test   %ecx,%ecx
80106ec2:	74 2c                	je     80106ef0 <walkpgdir+0x70>
80106ec4:	e8 47 be ff ff       	call   80102d10 <kalloc>
80106ec9:	89 c3                	mov    %eax,%ebx
80106ecb:	85 c0                	test   %eax,%eax
80106ecd:	74 21                	je     80106ef0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ecf:	83 ec 04             	sub    $0x4,%esp
80106ed2:	68 00 10 00 00       	push   $0x1000
80106ed7:	6a 00                	push   $0x0
80106ed9:	50                   	push   %eax
80106eda:	e8 71 de ff ff       	call   80104d50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106edf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ee5:	83 c4 10             	add    $0x10,%esp
80106ee8:	83 c8 07             	or     $0x7,%eax
80106eeb:	89 07                	mov    %eax,(%edi)
80106eed:	eb b5                	jmp    80106ea4 <walkpgdir+0x24>
80106eef:	90                   	nop
}
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f06:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f0a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f10:	89 d6                	mov    %edx,%esi
{
80106f12:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f13:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f19:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f22:	29 f0                	sub    %esi,%eax
80106f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f27:	eb 1f                	jmp    80106f48 <mappages+0x48>
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f30:	f6 00 01             	testb  $0x1,(%eax)
80106f33:	75 45                	jne    80106f7a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f35:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106f38:	83 cb 01             	or     $0x1,%ebx
80106f3b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106f3d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106f40:	74 2e                	je     80106f70 <mappages+0x70>
      break;
    a += PGSIZE;
80106f42:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f4b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f50:	89 f2                	mov    %esi,%edx
80106f52:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106f55:	89 f8                	mov    %edi,%eax
80106f57:	e8 24 ff ff ff       	call   80106e80 <walkpgdir>
80106f5c:	85 c0                	test   %eax,%eax
80106f5e:	75 d0                	jne    80106f30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f68:	5b                   	pop    %ebx
80106f69:	5e                   	pop    %esi
80106f6a:	5f                   	pop    %edi
80106f6b:	5d                   	pop    %ebp
80106f6c:	c3                   	ret    
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
      panic("remap");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 68 80 10 80       	push   $0x80108068
80106f82:	e8 09 94 ff ff       	call   80100390 <panic>
80106f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	89 c6                	mov    %eax,%esi
80106f97:	53                   	push   %ebx
80106f98:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f9a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106fa0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
80106fa9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fac:	39 da                	cmp    %ebx,%edx
80106fae:	73 5b                	jae    8010700b <deallocuvm.part.0+0x7b>
80106fb0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106fb3:	89 d7                	mov    %edx,%edi
80106fb5:	eb 14                	jmp    80106fcb <deallocuvm.part.0+0x3b>
80106fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbe:	66 90                	xchg   %ax,%ax
80106fc0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106fc6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106fc9:	76 40                	jbe    8010700b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fcb:	31 c9                	xor    %ecx,%ecx
80106fcd:	89 fa                	mov    %edi,%edx
80106fcf:	89 f0                	mov    %esi,%eax
80106fd1:	e8 aa fe ff ff       	call   80106e80 <walkpgdir>
80106fd6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106fd8:	85 c0                	test   %eax,%eax
80106fda:	74 44                	je     80107020 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fdc:	8b 00                	mov    (%eax),%eax
80106fde:	a8 01                	test   $0x1,%al
80106fe0:	74 de                	je     80106fc0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106fe2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fe7:	74 47                	je     80107030 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106fe9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fec:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106ff7:	50                   	push   %eax
80106ff8:	e8 53 bb ff ff       	call   80102b50 <kfree>
      *pte = 0;
80106ffd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107003:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107006:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107009:	77 c0                	ja     80106fcb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010700b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010700e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107011:	5b                   	pop    %ebx
80107012:	5e                   	pop    %esi
80107013:	5f                   	pop    %edi
80107014:	5d                   	pop    %ebp
80107015:	c3                   	ret    
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107020:	89 fa                	mov    %edi,%edx
80107022:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107028:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010702e:	eb 96                	jmp    80106fc6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	68 26 7a 10 80       	push   $0x80107a26
80107038:	e8 53 93 ff ff       	call   80100390 <panic>
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <seginit>:
{
80107040:	f3 0f 1e fb          	endbr32 
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010704a:	e8 d1 cf ff ff       	call   80104020 <cpuid>
  pd[0] = size-1;
8010704f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107054:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010705a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010705e:	c7 80 38 3d 11 80 ff 	movl   $0xffff,-0x7feec2c8(%eax)
80107065:	ff 00 00 
80107068:	c7 80 3c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec2c4(%eax)
8010706f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107072:	c7 80 40 3d 11 80 ff 	movl   $0xffff,-0x7feec2c0(%eax)
80107079:	ff 00 00 
8010707c:	c7 80 44 3d 11 80 00 	movl   $0xcf9200,-0x7feec2bc(%eax)
80107083:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107086:	c7 80 48 3d 11 80 ff 	movl   $0xffff,-0x7feec2b8(%eax)
8010708d:	ff 00 00 
80107090:	c7 80 4c 3d 11 80 00 	movl   $0xcffa00,-0x7feec2b4(%eax)
80107097:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010709a:	c7 80 50 3d 11 80 ff 	movl   $0xffff,-0x7feec2b0(%eax)
801070a1:	ff 00 00 
801070a4:	c7 80 54 3d 11 80 00 	movl   $0xcff200,-0x7feec2ac(%eax)
801070ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ae:	05 30 3d 11 80       	add    $0x80113d30,%eax
  pd[1] = (uint)p;
801070b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070b7:	c1 e8 10             	shr    $0x10,%eax
801070ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070c1:	0f 01 10             	lgdtl  (%eax)
}
801070c4:	c9                   	leave  
801070c5:	c3                   	ret    
801070c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cd:	8d 76 00             	lea    0x0(%esi),%esi

801070d0 <switchkvm>:
{
801070d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070d4:	a1 e4 69 11 80       	mov    0x801169e4,%eax
801070d9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070de:	0f 22 d8             	mov    %eax,%cr3
}
801070e1:	c3                   	ret    
801070e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070f0 <switchuvm>:
{
801070f0:	f3 0f 1e fb          	endbr32 
801070f4:	55                   	push   %ebp
801070f5:	89 e5                	mov    %esp,%ebp
801070f7:	57                   	push   %edi
801070f8:	56                   	push   %esi
801070f9:	53                   	push   %ebx
801070fa:	83 ec 1c             	sub    $0x1c,%esp
801070fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107100:	85 f6                	test   %esi,%esi
80107102:	0f 84 cb 00 00 00    	je     801071d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107108:	8b 46 08             	mov    0x8(%esi),%eax
8010710b:	85 c0                	test   %eax,%eax
8010710d:	0f 84 da 00 00 00    	je     801071ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107113:	8b 46 04             	mov    0x4(%esi),%eax
80107116:	85 c0                	test   %eax,%eax
80107118:	0f 84 c2 00 00 00    	je     801071e0 <switchuvm+0xf0>
  pushcli();
8010711e:	e8 1d da ff ff       	call   80104b40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107123:	e8 88 ce ff ff       	call   80103fb0 <mycpu>
80107128:	89 c3                	mov    %eax,%ebx
8010712a:	e8 81 ce ff ff       	call   80103fb0 <mycpu>
8010712f:	89 c7                	mov    %eax,%edi
80107131:	e8 7a ce ff ff       	call   80103fb0 <mycpu>
80107136:	83 c7 08             	add    $0x8,%edi
80107139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010713c:	e8 6f ce ff ff       	call   80103fb0 <mycpu>
80107141:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107144:	ba 67 00 00 00       	mov    $0x67,%edx
80107149:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107150:	83 c0 08             	add    $0x8,%eax
80107153:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010715a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010715f:	83 c1 08             	add    $0x8,%ecx
80107162:	c1 e8 18             	shr    $0x18,%eax
80107165:	c1 e9 10             	shr    $0x10,%ecx
80107168:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010716e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107174:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107179:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107180:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107185:	e8 26 ce ff ff       	call   80103fb0 <mycpu>
8010718a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107191:	e8 1a ce ff ff       	call   80103fb0 <mycpu>
80107196:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010719a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010719d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071a3:	e8 08 ce ff ff       	call   80103fb0 <mycpu>
801071a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071ab:	e8 00 ce ff ff       	call   80103fb0 <mycpu>
801071b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071b4:	b8 28 00 00 00       	mov    $0x28,%eax
801071b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071bc:	8b 46 04             	mov    0x4(%esi),%eax
801071bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071c4:	0f 22 d8             	mov    %eax,%cr3
}
801071c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ca:	5b                   	pop    %ebx
801071cb:	5e                   	pop    %esi
801071cc:	5f                   	pop    %edi
801071cd:	5d                   	pop    %ebp
  popcli();
801071ce:	e9 bd d9 ff ff       	jmp    80104b90 <popcli>
    panic("switchuvm: no process");
801071d3:	83 ec 0c             	sub    $0xc,%esp
801071d6:	68 6e 80 10 80       	push   $0x8010806e
801071db:	e8 b0 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	68 99 80 10 80       	push   $0x80108099
801071e8:	e8 a3 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801071ed:	83 ec 0c             	sub    $0xc,%esp
801071f0:	68 84 80 10 80       	push   $0x80108084
801071f5:	e8 96 91 ff ff       	call   80100390 <panic>
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107200 <inituvm>:
{
80107200:	f3 0f 1e fb          	endbr32 
80107204:	55                   	push   %ebp
80107205:	89 e5                	mov    %esp,%ebp
80107207:	57                   	push   %edi
80107208:	56                   	push   %esi
80107209:	53                   	push   %ebx
8010720a:	83 ec 1c             	sub    $0x1c,%esp
8010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107210:	8b 75 10             	mov    0x10(%ebp),%esi
80107213:	8b 7d 08             	mov    0x8(%ebp),%edi
80107216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107219:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010721f:	77 4b                	ja     8010726c <inituvm+0x6c>
  mem = kalloc();
80107221:	e8 ea ba ff ff       	call   80102d10 <kalloc>
  memset(mem, 0, PGSIZE);
80107226:	83 ec 04             	sub    $0x4,%esp
80107229:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010722e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107230:	6a 00                	push   $0x0
80107232:	50                   	push   %eax
80107233:	e8 18 db ff ff       	call   80104d50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107238:	58                   	pop    %eax
80107239:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010723f:	5a                   	pop    %edx
80107240:	6a 06                	push   $0x6
80107242:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107247:	31 d2                	xor    %edx,%edx
80107249:	50                   	push   %eax
8010724a:	89 f8                	mov    %edi,%eax
8010724c:	e8 af fc ff ff       	call   80106f00 <mappages>
  memmove(mem, init, sz);
80107251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107254:	89 75 10             	mov    %esi,0x10(%ebp)
80107257:	83 c4 10             	add    $0x10,%esp
8010725a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010725d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5f                   	pop    %edi
80107266:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107267:	e9 84 db ff ff       	jmp    80104df0 <memmove>
    panic("inituvm: more than a page");
8010726c:	83 ec 0c             	sub    $0xc,%esp
8010726f:	68 ad 80 10 80       	push   $0x801080ad
80107274:	e8 17 91 ff ff       	call   80100390 <panic>
80107279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107280 <loaduvm>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	57                   	push   %edi
80107288:	56                   	push   %esi
80107289:	53                   	push   %ebx
8010728a:	83 ec 1c             	sub    $0x1c,%esp
8010728d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107290:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107293:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107298:	0f 85 99 00 00 00    	jne    80107337 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010729e:	01 f0                	add    %esi,%eax
801072a0:	89 f3                	mov    %esi,%ebx
801072a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072a5:	8b 45 14             	mov    0x14(%ebp),%eax
801072a8:	01 f0                	add    %esi,%eax
801072aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801072ad:	85 f6                	test   %esi,%esi
801072af:	75 15                	jne    801072c6 <loaduvm+0x46>
801072b1:	eb 6d                	jmp    80107320 <loaduvm+0xa0>
801072b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072b7:	90                   	nop
801072b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801072be:	89 f0                	mov    %esi,%eax
801072c0:	29 d8                	sub    %ebx,%eax
801072c2:	39 c6                	cmp    %eax,%esi
801072c4:	76 5a                	jbe    80107320 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072c9:	8b 45 08             	mov    0x8(%ebp),%eax
801072cc:	31 c9                	xor    %ecx,%ecx
801072ce:	29 da                	sub    %ebx,%edx
801072d0:	e8 ab fb ff ff       	call   80106e80 <walkpgdir>
801072d5:	85 c0                	test   %eax,%eax
801072d7:	74 51                	je     8010732a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801072d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801072de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801072ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072f1:	29 d9                	sub    %ebx,%ecx
801072f3:	05 00 00 00 80       	add    $0x80000000,%eax
801072f8:	57                   	push   %edi
801072f9:	51                   	push   %ecx
801072fa:	50                   	push   %eax
801072fb:	ff 75 10             	pushl  0x10(%ebp)
801072fe:	e8 3d ae ff ff       	call   80102140 <readi>
80107303:	83 c4 10             	add    $0x10,%esp
80107306:	39 f8                	cmp    %edi,%eax
80107308:	74 ae                	je     801072b8 <loaduvm+0x38>
}
8010730a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010730d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107312:	5b                   	pop    %ebx
80107313:	5e                   	pop    %esi
80107314:	5f                   	pop    %edi
80107315:	5d                   	pop    %ebp
80107316:	c3                   	ret    
80107317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731e:	66 90                	xchg   %ax,%ax
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("loaduvm: address should exist");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 c7 80 10 80       	push   $0x801080c7
80107332:	e8 59 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107337:	83 ec 0c             	sub    $0xc,%esp
8010733a:	68 68 81 10 80       	push   $0x80108168
8010733f:	e8 4c 90 ff ff       	call   80100390 <panic>
80107344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010734f:	90                   	nop

80107350 <allocuvm>:
{
80107350:	f3 0f 1e fb          	endbr32 
80107354:	55                   	push   %ebp
80107355:	89 e5                	mov    %esp,%ebp
80107357:	57                   	push   %edi
80107358:	56                   	push   %esi
80107359:	53                   	push   %ebx
8010735a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010735d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107360:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107366:	85 c0                	test   %eax,%eax
80107368:	0f 88 b2 00 00 00    	js     80107420 <allocuvm+0xd0>
  if(newsz < oldsz)
8010736e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107371:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107374:	0f 82 96 00 00 00    	jb     80107410 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010737a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107380:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107386:	39 75 10             	cmp    %esi,0x10(%ebp)
80107389:	77 40                	ja     801073cb <allocuvm+0x7b>
8010738b:	e9 83 00 00 00       	jmp    80107413 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107390:	83 ec 04             	sub    $0x4,%esp
80107393:	68 00 10 00 00       	push   $0x1000
80107398:	6a 00                	push   $0x0
8010739a:	50                   	push   %eax
8010739b:	e8 b0 d9 ff ff       	call   80104d50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801073a0:	58                   	pop    %eax
801073a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073a7:	5a                   	pop    %edx
801073a8:	6a 06                	push   $0x6
801073aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073af:	89 f2                	mov    %esi,%edx
801073b1:	50                   	push   %eax
801073b2:	89 f8                	mov    %edi,%eax
801073b4:	e8 47 fb ff ff       	call   80106f00 <mappages>
801073b9:	83 c4 10             	add    $0x10,%esp
801073bc:	85 c0                	test   %eax,%eax
801073be:	78 78                	js     80107438 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801073c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073c9:	76 48                	jbe    80107413 <allocuvm+0xc3>
    mem = kalloc();
801073cb:	e8 40 b9 ff ff       	call   80102d10 <kalloc>
801073d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073d2:	85 c0                	test   %eax,%eax
801073d4:	75 ba                	jne    80107390 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	68 e5 80 10 80       	push   $0x801080e5
801073de:	e8 bd 93 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
801073e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073e6:	83 c4 10             	add    $0x10,%esp
801073e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801073ec:	74 32                	je     80107420 <allocuvm+0xd0>
801073ee:	8b 55 10             	mov    0x10(%ebp),%edx
801073f1:	89 c1                	mov    %eax,%ecx
801073f3:	89 f8                	mov    %edi,%eax
801073f5:	e8 96 fb ff ff       	call   80106f90 <deallocuvm.part.0>
      return 0;
801073fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107404:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107407:	5b                   	pop    %ebx
80107408:	5e                   	pop    %esi
80107409:	5f                   	pop    %edi
8010740a:	5d                   	pop    %ebp
8010740b:	c3                   	ret    
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107410:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107419:	5b                   	pop    %ebx
8010741a:	5e                   	pop    %esi
8010741b:	5f                   	pop    %edi
8010741c:	5d                   	pop    %ebp
8010741d:	c3                   	ret    
8010741e:	66 90                	xchg   %ax,%ax
    return 0;
80107420:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010742a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010742d:	5b                   	pop    %ebx
8010742e:	5e                   	pop    %esi
8010742f:	5f                   	pop    %edi
80107430:	5d                   	pop    %ebp
80107431:	c3                   	ret    
80107432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107438:	83 ec 0c             	sub    $0xc,%esp
8010743b:	68 fd 80 10 80       	push   $0x801080fd
80107440:	e8 5b 93 ff ff       	call   801007a0 <cprintf>
  if(newsz >= oldsz)
80107445:	8b 45 0c             	mov    0xc(%ebp),%eax
80107448:	83 c4 10             	add    $0x10,%esp
8010744b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010744e:	74 0c                	je     8010745c <allocuvm+0x10c>
80107450:	8b 55 10             	mov    0x10(%ebp),%edx
80107453:	89 c1                	mov    %eax,%ecx
80107455:	89 f8                	mov    %edi,%eax
80107457:	e8 34 fb ff ff       	call   80106f90 <deallocuvm.part.0>
      kfree(mem);
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	53                   	push   %ebx
80107460:	e8 eb b6 ff ff       	call   80102b50 <kfree>
      return 0;
80107465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010746c:	83 c4 10             	add    $0x10,%esp
}
8010746f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107480 <deallocuvm>:
{
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010748d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107490:	39 d1                	cmp    %edx,%ecx
80107492:	73 0c                	jae    801074a0 <deallocuvm+0x20>
}
80107494:	5d                   	pop    %ebp
80107495:	e9 f6 fa ff ff       	jmp    80106f90 <deallocuvm.part.0>
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074a0:	89 d0                	mov    %edx,%eax
801074a2:	5d                   	pop    %ebp
801074a3:	c3                   	ret    
801074a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074af:	90                   	nop

801074b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 0c             	sub    $0xc,%esp
801074bd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074c0:	85 f6                	test   %esi,%esi
801074c2:	74 55                	je     80107519 <freevm+0x69>
  if(newsz >= oldsz)
801074c4:	31 c9                	xor    %ecx,%ecx
801074c6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074cb:	89 f0                	mov    %esi,%eax
801074cd:	89 f3                	mov    %esi,%ebx
801074cf:	e8 bc fa ff ff       	call   80106f90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074d4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074da:	eb 0b                	jmp    801074e7 <freevm+0x37>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074e0:	83 c3 04             	add    $0x4,%ebx
801074e3:	39 df                	cmp    %ebx,%edi
801074e5:	74 23                	je     8010750a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074e7:	8b 03                	mov    (%ebx),%eax
801074e9:	a8 01                	test   $0x1,%al
801074eb:	74 f3                	je     801074e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074f2:	83 ec 0c             	sub    $0xc,%esp
801074f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074fd:	50                   	push   %eax
801074fe:	e8 4d b6 ff ff       	call   80102b50 <kfree>
80107503:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107506:	39 df                	cmp    %ebx,%edi
80107508:	75 dd                	jne    801074e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010750a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010750d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107510:	5b                   	pop    %ebx
80107511:	5e                   	pop    %esi
80107512:	5f                   	pop    %edi
80107513:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107514:	e9 37 b6 ff ff       	jmp    80102b50 <kfree>
    panic("freevm: no pgdir");
80107519:	83 ec 0c             	sub    $0xc,%esp
8010751c:	68 19 81 10 80       	push   $0x80108119
80107521:	e8 6a 8e ff ff       	call   80100390 <panic>
80107526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752d:	8d 76 00             	lea    0x0(%esi),%esi

80107530 <setupkvm>:
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	56                   	push   %esi
80107538:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107539:	e8 d2 b7 ff ff       	call   80102d10 <kalloc>
8010753e:	89 c6                	mov    %eax,%esi
80107540:	85 c0                	test   %eax,%eax
80107542:	74 42                	je     80107586 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107544:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107547:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010754c:	68 00 10 00 00       	push   $0x1000
80107551:	6a 00                	push   $0x0
80107553:	50                   	push   %eax
80107554:	e8 f7 d7 ff ff       	call   80104d50 <memset>
80107559:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010755c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010755f:	83 ec 08             	sub    $0x8,%esp
80107562:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107565:	ff 73 0c             	pushl  0xc(%ebx)
80107568:	8b 13                	mov    (%ebx),%edx
8010756a:	50                   	push   %eax
8010756b:	29 c1                	sub    %eax,%ecx
8010756d:	89 f0                	mov    %esi,%eax
8010756f:	e8 8c f9 ff ff       	call   80106f00 <mappages>
80107574:	83 c4 10             	add    $0x10,%esp
80107577:	85 c0                	test   %eax,%eax
80107579:	78 15                	js     80107590 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010757b:	83 c3 10             	add    $0x10,%ebx
8010757e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107584:	75 d6                	jne    8010755c <setupkvm+0x2c>
}
80107586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107589:	89 f0                	mov    %esi,%eax
8010758b:	5b                   	pop    %ebx
8010758c:	5e                   	pop    %esi
8010758d:	5d                   	pop    %ebp
8010758e:	c3                   	ret    
8010758f:	90                   	nop
      freevm(pgdir);
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	56                   	push   %esi
      return 0;
80107594:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107596:	e8 15 ff ff ff       	call   801074b0 <freevm>
      return 0;
8010759b:	83 c4 10             	add    $0x10,%esp
}
8010759e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075a1:	89 f0                	mov    %esi,%eax
801075a3:	5b                   	pop    %ebx
801075a4:	5e                   	pop    %esi
801075a5:	5d                   	pop    %ebp
801075a6:	c3                   	ret    
801075a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ae:	66 90                	xchg   %ax,%ax

801075b0 <kvmalloc>:
{
801075b0:	f3 0f 1e fb          	endbr32 
801075b4:	55                   	push   %ebp
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075ba:	e8 71 ff ff ff       	call   80107530 <setupkvm>
801075bf:	a3 e4 69 11 80       	mov    %eax,0x801169e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075c4:	05 00 00 00 80       	add    $0x80000000,%eax
801075c9:	0f 22 d8             	mov    %eax,%cr3
}
801075cc:	c9                   	leave  
801075cd:	c3                   	ret    
801075ce:	66 90                	xchg   %ax,%ax

801075d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075d0:	f3 0f 1e fb          	endbr32 
801075d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075d5:	31 c9                	xor    %ecx,%ecx
{
801075d7:	89 e5                	mov    %esp,%ebp
801075d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075df:	8b 45 08             	mov    0x8(%ebp),%eax
801075e2:	e8 99 f8 ff ff       	call   80106e80 <walkpgdir>
  if(pte == 0)
801075e7:	85 c0                	test   %eax,%eax
801075e9:	74 05                	je     801075f0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075ee:	c9                   	leave  
801075ef:	c3                   	ret    
    panic("clearpteu");
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	68 2a 81 10 80       	push   $0x8010812a
801075f8:	e8 93 8d ff ff       	call   80100390 <panic>
801075fd:	8d 76 00             	lea    0x0(%esi),%esi

80107600 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	57                   	push   %edi
80107608:	56                   	push   %esi
80107609:	53                   	push   %ebx
8010760a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010760d:	e8 1e ff ff ff       	call   80107530 <setupkvm>
80107612:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107615:	85 c0                	test   %eax,%eax
80107617:	0f 84 9b 00 00 00    	je     801076b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010761d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107620:	85 c9                	test   %ecx,%ecx
80107622:	0f 84 90 00 00 00    	je     801076b8 <copyuvm+0xb8>
80107628:	31 f6                	xor    %esi,%esi
8010762a:	eb 46                	jmp    80107672 <copyuvm+0x72>
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107630:	83 ec 04             	sub    $0x4,%esp
80107633:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107639:	68 00 10 00 00       	push   $0x1000
8010763e:	57                   	push   %edi
8010763f:	50                   	push   %eax
80107640:	e8 ab d7 ff ff       	call   80104df0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107645:	58                   	pop    %eax
80107646:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010764c:	5a                   	pop    %edx
8010764d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107650:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107655:	89 f2                	mov    %esi,%edx
80107657:	50                   	push   %eax
80107658:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010765b:	e8 a0 f8 ff ff       	call   80106f00 <mappages>
80107660:	83 c4 10             	add    $0x10,%esp
80107663:	85 c0                	test   %eax,%eax
80107665:	78 61                	js     801076c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107667:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010766d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107670:	76 46                	jbe    801076b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107672:	8b 45 08             	mov    0x8(%ebp),%eax
80107675:	31 c9                	xor    %ecx,%ecx
80107677:	89 f2                	mov    %esi,%edx
80107679:	e8 02 f8 ff ff       	call   80106e80 <walkpgdir>
8010767e:	85 c0                	test   %eax,%eax
80107680:	74 61                	je     801076e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107682:	8b 00                	mov    (%eax),%eax
80107684:	a8 01                	test   $0x1,%al
80107686:	74 4e                	je     801076d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107688:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010768a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010768f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107692:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107698:	e8 73 b6 ff ff       	call   80102d10 <kalloc>
8010769d:	89 c3                	mov    %eax,%ebx
8010769f:	85 c0                	test   %eax,%eax
801076a1:	75 8d                	jne    80107630 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801076a3:	83 ec 0c             	sub    $0xc,%esp
801076a6:	ff 75 e0             	pushl  -0x20(%ebp)
801076a9:	e8 02 fe ff ff       	call   801074b0 <freevm>
  return 0;
801076ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801076b5:	83 c4 10             	add    $0x10,%esp
}
801076b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076be:	5b                   	pop    %ebx
801076bf:	5e                   	pop    %esi
801076c0:	5f                   	pop    %edi
801076c1:	5d                   	pop    %ebp
801076c2:	c3                   	ret    
801076c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076c7:	90                   	nop
      kfree(mem);
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	53                   	push   %ebx
801076cc:	e8 7f b4 ff ff       	call   80102b50 <kfree>
      goto bad;
801076d1:	83 c4 10             	add    $0x10,%esp
801076d4:	eb cd                	jmp    801076a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076d6:	83 ec 0c             	sub    $0xc,%esp
801076d9:	68 4e 81 10 80       	push   $0x8010814e
801076de:	e8 ad 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801076e3:	83 ec 0c             	sub    $0xc,%esp
801076e6:	68 34 81 10 80       	push   $0x80108134
801076eb:	e8 a0 8c ff ff       	call   80100390 <panic>

801076f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076f5:	31 c9                	xor    %ecx,%ecx
{
801076f7:	89 e5                	mov    %esp,%ebp
801076f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107702:	e8 79 f7 ff ff       	call   80106e80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107707:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107709:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010770a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010770c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107711:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107714:	05 00 00 00 80       	add    $0x80000000,%eax
80107719:	83 fa 05             	cmp    $0x5,%edx
8010771c:	ba 00 00 00 00       	mov    $0x0,%edx
80107721:	0f 45 c2             	cmovne %edx,%eax
}
80107724:	c3                   	ret    
80107725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107730 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	57                   	push   %edi
80107738:	56                   	push   %esi
80107739:	53                   	push   %ebx
8010773a:	83 ec 0c             	sub    $0xc,%esp
8010773d:	8b 75 14             	mov    0x14(%ebp),%esi
80107740:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107743:	85 f6                	test   %esi,%esi
80107745:	75 3c                	jne    80107783 <copyout+0x53>
80107747:	eb 67                	jmp    801077b0 <copyout+0x80>
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107750:	8b 55 0c             	mov    0xc(%ebp),%edx
80107753:	89 fb                	mov    %edi,%ebx
80107755:	29 d3                	sub    %edx,%ebx
80107757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010775d:	39 f3                	cmp    %esi,%ebx
8010775f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107762:	29 fa                	sub    %edi,%edx
80107764:	83 ec 04             	sub    $0x4,%esp
80107767:	01 c2                	add    %eax,%edx
80107769:	53                   	push   %ebx
8010776a:	ff 75 10             	pushl  0x10(%ebp)
8010776d:	52                   	push   %edx
8010776e:	e8 7d d6 ff ff       	call   80104df0 <memmove>
    len -= n;
    buf += n;
80107773:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107776:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010777c:	83 c4 10             	add    $0x10,%esp
8010777f:	29 de                	sub    %ebx,%esi
80107781:	74 2d                	je     801077b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107783:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107785:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107788:	89 55 0c             	mov    %edx,0xc(%ebp)
8010778b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107791:	57                   	push   %edi
80107792:	ff 75 08             	pushl  0x8(%ebp)
80107795:	e8 56 ff ff ff       	call   801076f0 <uva2ka>
    if(pa0 == 0)
8010779a:	83 c4 10             	add    $0x10,%esp
8010779d:	85 c0                	test   %eax,%eax
8010779f:	75 af                	jne    80107750 <copyout+0x20>
  }
  return 0;
}
801077a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077a9:	5b                   	pop    %ebx
801077aa:	5e                   	pop    %esi
801077ab:	5f                   	pop    %edi
801077ac:	5d                   	pop    %ebp
801077ad:	c3                   	ret    
801077ae:	66 90                	xchg   %ax,%ax
801077b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077b3:	31 c0                	xor    %eax,%eax
}
801077b5:	5b                   	pop    %ebx
801077b6:	5e                   	pop    %esi
801077b7:	5f                   	pop    %edi
801077b8:	5d                   	pop    %ebp
801077b9:	c3                   	ret    
