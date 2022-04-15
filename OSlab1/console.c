// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define ARR_UP          0xE2 // up arrow 
#define ARR_DN          0xE3 // down arrow 
#define ARR_LF          0xE4 // left arrow 
#define ARR_RT          0xE5 // right arrow 


#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint pos; // curr input buf size/position
} input;

#define CMD_MEM_SIZE 10
#define NO_CMD -1

char cmd_mem[CMD_MEM_SIZE][INPUT_BUF]; // saving commadns in memory
int cmd_mem_size = 0;
int cmd_idx = -1;
int up_key_press=0;
int down_key_press=0;

static int width = 0;
static int empty_cell = 0;

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

void updating_crt(int pos, int width)
{
  //putting chars forward and    ...abc.
  //putting crt buffer backward  ....abc
  ushort temp = crt[pos-1];
  ushort temp_;
  for (int i = pos; i <= pos+width+1; i++)
  {
    temp_ = crt[i];
    crt[i] = temp;
    temp = temp_;
  }

}

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE)
  {
    if(pos > 0)
     --pos;
  } 
  else if(c == ARR_RT)
  {
    if (width)
    {
      ++pos;
      width--;
    }
  }
  else if(c == ARR_LF)
  {
    int buf_char_size = strlen(input.buf)-empty_cell;
    if (width<buf_char_size)
    {
      --pos;
      width++;
    }
  }
  else
  {
    updating_crt(pos,width);
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  }

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  if(c != ARR_RT && c != ARR_LF)
  crt[pos+width] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}


#define C(x)  ((x)-'@')  // Control-x

void cursor_gathering_char(int col, int width)
{
  //inspiring from "cgaputc" function.

  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  //moving crt buf
  updating_crt(pos,width);

  crt[pos++] = (col&0xff) | 0x0700;  // black on white
  
  pos = pos+1; //place cursor to next pos

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos+width] = ' ' | 0x0700;  

}


void save_command(char* cmd)
{
  int cmd_len = strlen(cmd);
  int count = cmd_len;
  if (count>INPUT_BUF)
    count = INPUT_BUF-1;
  
  if(cmd_len)
  {
    
    int off_limits = cmd_mem_size == CMD_MEM_SIZE;
    if(off_limits)
    {
      cmd_mem_size--;
      //updating memory with new command data 
      for (int i = 0; i < CMD_MEM_SIZE-1; i++)
        memmove(cmd_mem[i],cmd_mem[i+1],sizeof(char)* INPUT_BUF);  

    }
    // save new data in curr mem size

    memmove(cmd_mem[cmd_mem_size], cmd, sizeof(char)* count);  
    cmd_mem[cmd_mem_size][count] = '\0';
    if(off_limits)
    {
      cmd_mem_size++;
    }
    cmd_mem_size += (off_limits ? 0 : 1);


  }
}

void leftside_moving_cursor()
{
  int pos;
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

  pos--;

  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
  crt[pos+width] = ' ' | 0x0700;
}

void rightside_moving_cursor()
{
  int pos;
  outb(CRTPORT, 14);                  
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);    

  pos++;

  outb(CRTPORT, 15);
  outb(CRTPORT+1, (unsigned char)(pos&0xFF));
  outb(CRTPORT, 14);
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
}

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        empty_cell++;
        consputc(BACKSPACE);
      }
      break;

      case ARR_UP:
      if (cmd_idx != NO_CMD)
      {
        up_key_press=1;
        for (int i = input.pos; i < input.e; i++)
          rightside_moving_cursor();
        
        while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n')
        {
          input.e--;
          leftside_moving_cursor();
        }

        char temp_id;
        for (int i = 0; i < INPUT_BUF; i++)
        {
          temp_id = cmd_mem[cmd_idx][i];
          if (temp_id == '\0')
            break;
          consputc(temp_id);
          input.buf[input.e++] = temp_id;
        }

        input.pos = input.e;
        
        cmd_idx--;
        //cmd_idx=(cmd_idx)%10;
      }
      

    break;
    
    case ARR_DN:

      if (cmd_idx != cmd_mem_size)
      {
        down_key_press=1;
        for (int i = input.pos; i < input.e; i++)
          rightside_moving_cursor();
        
        while(input.e != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n')
        {
          input.e--;
          leftside_moving_cursor();
        }

        if(up_key_press==1)
        {
          cmd_idx+=2;
          //cmd_idx=cmd_idx%10;
          up_key_press=0;
        }
        else
        {
          ++cmd_idx;
          //cmd_idx=cmd_idx%10;
        }
         
         char temp_id;
         for (int i = 0; i < INPUT_BUF; i++)
         {
             temp_id = cmd_mem[cmd_idx][i];
             if (temp_id == '\0')
               break;
             consputc(temp_id);
             input.buf[input.e++] = temp_id;
         }

           input.pos = input.e;
           
      }
      

    break;

    case ARR_RT:
      consputc(ARR_RT);
      // if(width)
      //   input.w++;
    break;

    case ARR_LF:
      consputc(ARR_LF);
      // int buf_char_size = strlen(input.buf)-empty_cell;
      //   if (width<buf_char_size)
      //   {
      //     input.w--;
      //     input.e--;
      //   }
    break;

    default:
      if(c != 0 && input.e-input.r < INPUT_BUF)
      {
        c = (c == '\r') ? '\n' : c;
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF)
        {
          input.buf[input.e++ % INPUT_BUF] = c;
          consputc(c);

          width =0;

          char cmd_[INPUT_BUF];
          for (int i = 0; i+input.w < input.e -1; i++)
          {
            cmd_[i] = input.buf[(input.w + i) % INPUT_BUF];
          }
          cmd_[(input.e -1 -input.w)%INPUT_BUF] = '\0';

          save_command(cmd_);
          cmd_idx = cmd_mem_size;

          input.pos = input.e;
          input.w = input.e;
          wakeup(&input.r);
        }
        else
        {
          if (width == 0)
          {
            input.buf[input.e++ % INPUT_BUF] = c;
            input.pos++;

            consputc(c);
          }
          else
          {
            for (int i = input.e; i > input.pos-1; i++)
              input.buf[(i+1)%INPUT_BUF] = input.buf[(i)%INPUT_BUF];
            
            input.buf[input.pos%INPUT_BUF] = c;

            input.e++;
            input.pos++;
            cursor_gathering_char(c,width);
          }
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
