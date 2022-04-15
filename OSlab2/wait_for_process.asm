
_wait_for_process:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   5:	31 c0                	xor    %eax,%eax
{
   7:	89 e5                	mov    %esp,%ebp
   9:	53                   	push   %ebx
   a:	8b 4d 08             	mov    0x8(%ebp),%ecx
   d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
  10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  17:	83 c0 01             	add    $0x1,%eax
  1a:	84 d2                	test   %dl,%dl
  1c:	75 f2                	jne    10 <strcpy+0x10>
    ;
  return os;
}
  1e:	89 c8                	mov    %ecx,%eax
  20:	5b                   	pop    %ebx
  21:	5d                   	pop    %ebp
  22:	c3                   	ret    
  23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  30:	f3 0f 1e fb          	endbr32 
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	53                   	push   %ebx
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  3e:	0f b6 01             	movzbl (%ecx),%eax
  41:	0f b6 1a             	movzbl (%edx),%ebx
  44:	84 c0                	test   %al,%al
  46:	75 19                	jne    61 <strcmp+0x31>
  48:	eb 26                	jmp    70 <strcmp+0x40>
  4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  50:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  54:	83 c1 01             	add    $0x1,%ecx
  57:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  5a:	0f b6 1a             	movzbl (%edx),%ebx
  5d:	84 c0                	test   %al,%al
  5f:	74 0f                	je     70 <strcmp+0x40>
  61:	38 d8                	cmp    %bl,%al
  63:	74 eb                	je     50 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  65:	29 d8                	sub    %ebx,%eax
}
  67:	5b                   	pop    %ebx
  68:	5d                   	pop    %ebp
  69:	c3                   	ret    
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  70:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  72:	29 d8                	sub    %ebx,%eax
}
  74:	5b                   	pop    %ebx
  75:	5d                   	pop    %ebp
  76:	c3                   	ret    
  77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7e:	66 90                	xchg   %ax,%ax

00000080 <strlen>:

uint
strlen(const char *s)
{
  80:	f3 0f 1e fb          	endbr32 
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  8a:	80 3a 00             	cmpb   $0x0,(%edx)
  8d:	74 21                	je     b0 <strlen+0x30>
  8f:	31 c0                	xor    %eax,%eax
  91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  98:	83 c0 01             	add    $0x1,%eax
  9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  9f:	89 c1                	mov    %eax,%ecx
  a1:	75 f5                	jne    98 <strlen+0x18>
    ;
  return n;
}
  a3:	89 c8                	mov    %ecx,%eax
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    
  a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
  b0:	31 c9                	xor    %ecx,%ecx
}
  b2:	5d                   	pop    %ebp
  b3:	89 c8                	mov    %ecx,%eax
  b5:	c3                   	ret    
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	f3 0f 1e fb          	endbr32 
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  d1:	89 d7                	mov    %edx,%edi
  d3:	fc                   	cld    
  d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d6:	89 d0                	mov    %edx,%eax
  d8:	5f                   	pop    %edi
  d9:	5d                   	pop    %ebp
  da:	c3                   	ret    
  db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  df:	90                   	nop

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	84 d2                	test   %dl,%dl
  f3:	75 16                	jne    10b <strchr+0x2b>
  f5:	eb 21                	jmp    118 <strchr+0x38>
  f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fe:	66 90                	xchg   %ax,%ax
 100:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 104:	83 c0 01             	add    $0x1,%eax
 107:	84 d2                	test   %dl,%dl
 109:	74 0d                	je     118 <strchr+0x38>
    if(*s == c)
 10b:	38 d1                	cmp    %dl,%cl
 10d:	75 f1                	jne    100 <strchr+0x20>
      return (char*)s;
  return 0;
}
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
 111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 118:	31 c0                	xor    %eax,%eax
}
 11a:	5d                   	pop    %ebp
 11b:	c3                   	ret    
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 129:	31 f6                	xor    %esi,%esi
{
 12b:	53                   	push   %ebx
 12c:	89 f3                	mov    %esi,%ebx
 12e:	83 ec 1c             	sub    $0x1c,%esp
 131:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 134:	eb 33                	jmp    169 <gets+0x49>
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	8d 45 e7             	lea    -0x19(%ebp),%eax
 146:	6a 01                	push   $0x1
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 2b 01 00 00       	call   27b <read>
    if(cc < 1)
 150:	83 c4 10             	add    $0x10,%esp
 153:	85 c0                	test   %eax,%eax
 155:	7e 1c                	jle    173 <gets+0x53>
      break;
    buf[i++] = c;
 157:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 15b:	83 c7 01             	add    $0x1,%edi
 15e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 161:	3c 0a                	cmp    $0xa,%al
 163:	74 23                	je     188 <gets+0x68>
 165:	3c 0d                	cmp    $0xd,%al
 167:	74 1f                	je     188 <gets+0x68>
  for(i=0; i+1 < max; ){
 169:	83 c3 01             	add    $0x1,%ebx
 16c:	89 fe                	mov    %edi,%esi
 16e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 171:	7c cd                	jl     140 <gets+0x20>
 173:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 175:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 178:	c6 03 00             	movb   $0x0,(%ebx)
}
 17b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17e:	5b                   	pop    %ebx
 17f:	5e                   	pop    %esi
 180:	5f                   	pop    %edi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
 183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 187:	90                   	nop
 188:	8b 75 08             	mov    0x8(%ebp),%esi
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 de                	add    %ebx,%esi
 190:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 192:	c6 03 00             	movb   $0x0,(%ebx)
}
 195:	8d 65 f4             	lea    -0xc(%ebp),%esp
 198:	5b                   	pop    %ebx
 199:	5e                   	pop    %esi
 19a:	5f                   	pop    %edi
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	56                   	push   %esi
 1a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	6a 00                	push   $0x0
 1ae:	ff 75 08             	pushl  0x8(%ebp)
 1b1:	e8 ed 00 00 00       	call   2a3 <open>
  if(fd < 0)
 1b6:	83 c4 10             	add    $0x10,%esp
 1b9:	85 c0                	test   %eax,%eax
 1bb:	78 2b                	js     1e8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1bd:	83 ec 08             	sub    $0x8,%esp
 1c0:	ff 75 0c             	pushl  0xc(%ebp)
 1c3:	89 c3                	mov    %eax,%ebx
 1c5:	50                   	push   %eax
 1c6:	e8 f0 00 00 00       	call   2bb <fstat>
  close(fd);
 1cb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ce:	89 c6                	mov    %eax,%esi
  close(fd);
 1d0:	e8 b6 00 00 00       	call   28b <close>
  return r;
 1d5:	83 c4 10             	add    $0x10,%esp
}
 1d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1db:	89 f0                	mov    %esi,%eax
 1dd:	5b                   	pop    %ebx
 1de:	5e                   	pop    %esi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 1e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ed:	eb e9                	jmp    1d8 <stat+0x38>
 1ef:	90                   	nop

000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	53                   	push   %ebx
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fb:	0f be 02             	movsbl (%edx),%eax
 1fe:	8d 48 d0             	lea    -0x30(%eax),%ecx
 201:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 204:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 209:	77 1a                	ja     225 <atoi+0x35>
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop
    n = n*10 + *s++ - '0';
 210:	83 c2 01             	add    $0x1,%edx
 213:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 216:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 21a:	0f be 02             	movsbl (%edx),%eax
 21d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 220:	80 fb 09             	cmp    $0x9,%bl
 223:	76 eb                	jbe    210 <atoi+0x20>
  return n;
}
 225:	89 c8                	mov    %ecx,%eax
 227:	5b                   	pop    %ebx
 228:	5d                   	pop    %ebp
 229:	c3                   	ret    
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	57                   	push   %edi
 238:	8b 45 10             	mov    0x10(%ebp),%eax
 23b:	8b 55 08             	mov    0x8(%ebp),%edx
 23e:	56                   	push   %esi
 23f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 242:	85 c0                	test   %eax,%eax
 244:	7e 0f                	jle    255 <memmove+0x25>
 246:	01 d0                	add    %edx,%eax
  dst = vdst;
 248:	89 d7                	mov    %edx,%edi
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 250:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 251:	39 f8                	cmp    %edi,%eax
 253:	75 fb                	jne    250 <memmove+0x20>
  return vdst;
}
 255:	5e                   	pop    %esi
 256:	89 d0                	mov    %edx,%eax
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    

0000025b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 25b:	b8 01 00 00 00       	mov    $0x1,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <exit>:
SYSCALL(exit)
 263:	b8 02 00 00 00       	mov    $0x2,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <wait>:
SYSCALL(wait)
 26b:	b8 03 00 00 00       	mov    $0x3,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <pipe>:
SYSCALL(pipe)
 273:	b8 04 00 00 00       	mov    $0x4,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <read>:
SYSCALL(read)
 27b:	b8 05 00 00 00       	mov    $0x5,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <write>:
SYSCALL(write)
 283:	b8 10 00 00 00       	mov    $0x10,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <close>:
SYSCALL(close)
 28b:	b8 15 00 00 00       	mov    $0x15,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <kill>:
SYSCALL(kill)
 293:	b8 06 00 00 00       	mov    $0x6,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <exec>:
SYSCALL(exec)
 29b:	b8 07 00 00 00       	mov    $0x7,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <open>:
SYSCALL(open)
 2a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <mknod>:
SYSCALL(mknod)
 2ab:	b8 11 00 00 00       	mov    $0x11,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <unlink>:
SYSCALL(unlink)
 2b3:	b8 12 00 00 00       	mov    $0x12,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <fstat>:
SYSCALL(fstat)
 2bb:	b8 08 00 00 00       	mov    $0x8,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <link>:
SYSCALL(link)
 2c3:	b8 13 00 00 00       	mov    $0x13,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mkdir>:
SYSCALL(mkdir)
 2cb:	b8 14 00 00 00       	mov    $0x14,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <chdir>:
SYSCALL(chdir)
 2d3:	b8 09 00 00 00       	mov    $0x9,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <dup>:
SYSCALL(dup)
 2db:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <getpid>:
SYSCALL(getpid)
 2e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <sbrk>:
SYSCALL(sbrk)
 2eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <sleep>:
SYSCALL(sleep)
 2f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <uptime>:
SYSCALL(uptime)
 2fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <find_next_prime_number>:

SYSCALL(find_next_prime_number)
 303:	b8 16 00 00 00       	mov    $0x16,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <get_call_count>:
SYSCALL(get_call_count)
 30b:	b8 17 00 00 00       	mov    $0x17,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <get_most_caller>:
SYSCALL(get_most_caller)
 313:	b8 18 00 00 00       	mov    $0x18,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <wait_for_process>:
 31b:	b8 19 00 00 00       	mov    $0x19,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    
 323:	66 90                	xchg   %ax,%ax
 325:	66 90                	xchg   %ax,%ax
 327:	66 90                	xchg   %ax,%ax
 329:	66 90                	xchg   %ax,%ax
 32b:	66 90                	xchg   %ax,%ax
 32d:	66 90                	xchg   %ax,%ax
 32f:	90                   	nop

00000330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
 336:	83 ec 3c             	sub    $0x3c,%esp
 339:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 33c:	89 d1                	mov    %edx,%ecx
{
 33e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 341:	85 d2                	test   %edx,%edx
 343:	0f 89 7f 00 00 00    	jns    3c8 <printint+0x98>
 349:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 34d:	74 79                	je     3c8 <printint+0x98>
    neg = 1;
 34f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 356:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 358:	31 db                	xor    %ebx,%ebx
 35a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 360:	89 c8                	mov    %ecx,%eax
 362:	31 d2                	xor    %edx,%edx
 364:	89 cf                	mov    %ecx,%edi
 366:	f7 75 c4             	divl   -0x3c(%ebp)
 369:	0f b6 92 50 07 00 00 	movzbl 0x750(%edx),%edx
 370:	89 45 c0             	mov    %eax,-0x40(%ebp)
 373:	89 d8                	mov    %ebx,%eax
 375:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 378:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 37b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 37e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 381:	76 dd                	jbe    360 <printint+0x30>
  if(neg)
 383:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 386:	85 c9                	test   %ecx,%ecx
 388:	74 0c                	je     396 <printint+0x66>
    buf[i++] = '-';
 38a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 38f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 391:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 396:	8b 7d b8             	mov    -0x48(%ebp),%edi
 399:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 39d:	eb 07                	jmp    3a6 <printint+0x76>
 39f:	90                   	nop
 3a0:	0f b6 13             	movzbl (%ebx),%edx
 3a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3a6:	83 ec 04             	sub    $0x4,%esp
 3a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3ac:	6a 01                	push   $0x1
 3ae:	56                   	push   %esi
 3af:	57                   	push   %edi
 3b0:	e8 ce fe ff ff       	call   283 <write>
  while(--i >= 0)
 3b5:	83 c4 10             	add    $0x10,%esp
 3b8:	39 de                	cmp    %ebx,%esi
 3ba:	75 e4                	jne    3a0 <printint+0x70>
    putc(fd, buf[i]);
}
 3bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bf:	5b                   	pop    %ebx
 3c0:	5e                   	pop    %esi
 3c1:	5f                   	pop    %edi
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3cf:	eb 87                	jmp    358 <printint+0x28>
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop

000003e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 3f0:	0f b6 1e             	movzbl (%esi),%ebx
 3f3:	84 db                	test   %bl,%bl
 3f5:	0f 84 b4 00 00 00    	je     4af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 3fb:	8d 45 10             	lea    0x10(%ebp),%eax
 3fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 401:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 404:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 406:	89 45 d0             	mov    %eax,-0x30(%ebp)
 409:	eb 33                	jmp    43e <printf+0x5e>
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
 410:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 413:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 418:	83 f8 25             	cmp    $0x25,%eax
 41b:	74 17                	je     434 <printf+0x54>
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
 420:	88 5d e7             	mov    %bl,-0x19(%ebp)
 423:	6a 01                	push   $0x1
 425:	57                   	push   %edi
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 55 fe ff ff       	call   283 <write>
 42e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 431:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 434:	0f b6 1e             	movzbl (%esi),%ebx
 437:	83 c6 01             	add    $0x1,%esi
 43a:	84 db                	test   %bl,%bl
 43c:	74 71                	je     4af <printf+0xcf>
    c = fmt[i] & 0xff;
 43e:	0f be cb             	movsbl %bl,%ecx
 441:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 444:	85 d2                	test   %edx,%edx
 446:	74 c8                	je     410 <printf+0x30>
      }
    } else if(state == '%'){
 448:	83 fa 25             	cmp    $0x25,%edx
 44b:	75 e7                	jne    434 <printf+0x54>
      if(c == 'd'){
 44d:	83 f8 64             	cmp    $0x64,%eax
 450:	0f 84 9a 00 00 00    	je     4f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 456:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 45c:	83 f9 70             	cmp    $0x70,%ecx
 45f:	74 5f                	je     4c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 461:	83 f8 73             	cmp    $0x73,%eax
 464:	0f 84 d6 00 00 00    	je     540 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46a:	83 f8 63             	cmp    $0x63,%eax
 46d:	0f 84 8d 00 00 00    	je     500 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 473:	83 f8 25             	cmp    $0x25,%eax
 476:	0f 84 b4 00 00 00    	je     530 <printf+0x150>
  write(fd, &c, 1);
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	ff 75 08             	pushl  0x8(%ebp)
 489:	e8 f5 fd ff ff       	call   283 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 48e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 491:	83 c4 0c             	add    $0xc,%esp
 494:	6a 01                	push   $0x1
 496:	83 c6 01             	add    $0x1,%esi
 499:	57                   	push   %edi
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 e1 fd ff ff       	call   283 <write>
  for(i = 0; fmt[i]; i++){
 4a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4ab:	84 db                	test   %bl,%bl
 4ad:	75 8f                	jne    43e <printf+0x5e>
    }
  }
}
 4af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b2:	5b                   	pop    %ebx
 4b3:	5e                   	pop    %esi
 4b4:	5f                   	pop    %edi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    
 4b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4c0:	83 ec 0c             	sub    $0xc,%esp
 4c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4c8:	6a 00                	push   $0x0
 4ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	8b 13                	mov    (%ebx),%edx
 4d2:	e8 59 fe ff ff       	call   330 <printint>
        ap++;
 4d7:	89 d8                	mov    %ebx,%eax
 4d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4dc:	31 d2                	xor    %edx,%edx
        ap++;
 4de:	83 c0 04             	add    $0x4,%eax
 4e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4e4:	e9 4b ff ff ff       	jmp    434 <printf+0x54>
 4e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f8:	6a 01                	push   $0x1
 4fa:	eb ce                	jmp    4ca <printf+0xea>
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 500:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 503:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 506:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 508:	6a 01                	push   $0x1
        ap++;
 50a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 50d:	57                   	push   %edi
 50e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 511:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 514:	e8 6a fd ff ff       	call   283 <write>
        ap++;
 519:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 51c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 0e ff ff ff       	jmp    434 <printf+0x54>
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 530:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 533:	83 ec 04             	sub    $0x4,%esp
 536:	e9 59 ff ff ff       	jmp    494 <printf+0xb4>
 53b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop
        s = (char*)*ap;
 540:	8b 45 d0             	mov    -0x30(%ebp),%eax
 543:	8b 18                	mov    (%eax),%ebx
        ap++;
 545:	83 c0 04             	add    $0x4,%eax
 548:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 54b:	85 db                	test   %ebx,%ebx
 54d:	74 17                	je     566 <printf+0x186>
        while(*s != 0){
 54f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 552:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 554:	84 c0                	test   %al,%al
 556:	0f 84 d8 fe ff ff    	je     434 <printf+0x54>
 55c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 55f:	89 de                	mov    %ebx,%esi
 561:	8b 5d 08             	mov    0x8(%ebp),%ebx
 564:	eb 1a                	jmp    580 <printf+0x1a0>
          s = "(null)";
 566:	bb 48 07 00 00       	mov    $0x748,%ebx
        while(*s != 0){
 56b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 56e:	b8 28 00 00 00       	mov    $0x28,%eax
 573:	89 de                	mov    %ebx,%esi
 575:	8b 5d 08             	mov    0x8(%ebp),%ebx
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
          s++;
 583:	83 c6 01             	add    $0x1,%esi
 586:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 589:	6a 01                	push   $0x1
 58b:	57                   	push   %edi
 58c:	53                   	push   %ebx
 58d:	e8 f1 fc ff ff       	call   283 <write>
        while(*s != 0){
 592:	0f b6 06             	movzbl (%esi),%eax
 595:	83 c4 10             	add    $0x10,%esp
 598:	84 c0                	test   %al,%al
 59a:	75 e4                	jne    580 <printf+0x1a0>
 59c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 8e fe ff ff       	jmp    434 <printf+0x54>
 5a6:	66 90                	xchg   %ax,%ax
 5a8:	66 90                	xchg   %ax,%ax
 5aa:	66 90                	xchg   %ax,%ax
 5ac:	66 90                	xchg   %ax,%ax
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b5:	a1 d4 09 00 00       	mov    0x9d4,%eax
{
 5ba:	89 e5                	mov    %esp,%ebp
 5bc:	57                   	push   %edi
 5bd:	56                   	push   %esi
 5be:	53                   	push   %ebx
 5bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c7:	39 c8                	cmp    %ecx,%eax
 5c9:	73 15                	jae    5e0 <free+0x30>
 5cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
 5d0:	39 d1                	cmp    %edx,%ecx
 5d2:	72 14                	jb     5e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	39 d0                	cmp    %edx,%eax
 5d6:	73 10                	jae    5e8 <free+0x38>
{
 5d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	8b 10                	mov    (%eax),%edx
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	72 f0                	jb     5d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	39 d0                	cmp    %edx,%eax
 5e2:	72 f4                	jb     5d8 <free+0x28>
 5e4:	39 d1                	cmp    %edx,%ecx
 5e6:	73 f0                	jae    5d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ee:	39 fa                	cmp    %edi,%edx
 5f0:	74 1e                	je     610 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f5:	8b 50 04             	mov    0x4(%eax),%edx
 5f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5fb:	39 f1                	cmp    %esi,%ecx
 5fd:	74 28                	je     627 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 601:	5b                   	pop    %ebx
  freep = p;
 602:	a3 d4 09 00 00       	mov    %eax,0x9d4
}
 607:	5e                   	pop    %esi
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 610:	03 72 04             	add    0x4(%edx),%esi
 613:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 616:	8b 10                	mov    (%eax),%edx
 618:	8b 12                	mov    (%edx),%edx
 61a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 623:	39 f1                	cmp    %esi,%ecx
 625:	75 d8                	jne    5ff <free+0x4f>
    p->s.size += bp->s.size;
 627:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 62a:	a3 d4 09 00 00       	mov    %eax,0x9d4
    p->s.size += bp->s.size;
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 632:	8b 53 f8             	mov    -0x8(%ebx),%edx
 635:	89 10                	mov    %edx,(%eax)
}
 637:	5b                   	pop    %ebx
 638:	5e                   	pop    %esi
 639:	5f                   	pop    %edi
 63a:	5d                   	pop    %ebp
 63b:	c3                   	ret    
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	f3 0f 1e fb          	endbr32 
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	57                   	push   %edi
 648:	56                   	push   %esi
 649:	53                   	push   %ebx
 64a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 650:	8b 3d d4 09 00 00    	mov    0x9d4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 656:	8d 70 07             	lea    0x7(%eax),%esi
 659:	c1 ee 03             	shr    $0x3,%esi
 65c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 65f:	85 ff                	test   %edi,%edi
 661:	0f 84 a9 00 00 00    	je     710 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 667:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 669:	8b 48 04             	mov    0x4(%eax),%ecx
 66c:	39 f1                	cmp    %esi,%ecx
 66e:	73 6d                	jae    6dd <malloc+0x9d>
 670:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 676:	bb 00 10 00 00       	mov    $0x1000,%ebx
 67b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 67e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 685:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 688:	eb 17                	jmp    6a1 <malloc+0x61>
 68a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 690:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 692:	8b 4a 04             	mov    0x4(%edx),%ecx
 695:	39 f1                	cmp    %esi,%ecx
 697:	73 4f                	jae    6e8 <malloc+0xa8>
 699:	8b 3d d4 09 00 00    	mov    0x9d4,%edi
 69f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6a1:	39 c7                	cmp    %eax,%edi
 6a3:	75 eb                	jne    690 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6ab:	e8 3b fc ff ff       	call   2eb <sbrk>
  if(p == (char*)-1)
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b6:	74 1b                	je     6d3 <malloc+0x93>
  hp->s.size = nu;
 6b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	83 c0 08             	add    $0x8,%eax
 6c1:	50                   	push   %eax
 6c2:	e8 e9 fe ff ff       	call   5b0 <free>
  return freep;
 6c7:	a1 d4 09 00 00       	mov    0x9d4,%eax
      if((p = morecore(nunits)) == 0)
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	85 c0                	test   %eax,%eax
 6d1:	75 bd                	jne    690 <malloc+0x50>
        return 0;
  }
}
 6d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6d6:	31 c0                	xor    %eax,%eax
}
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5f                   	pop    %edi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    
    if(p->s.size >= nunits){
 6dd:	89 c2                	mov    %eax,%edx
 6df:	89 f8                	mov    %edi,%eax
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6e8:	39 ce                	cmp    %ecx,%esi
 6ea:	74 54                	je     740 <malloc+0x100>
        p->s.size -= nunits;
 6ec:	29 f1                	sub    %esi,%ecx
 6ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 6f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 6f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 6f7:	a3 d4 09 00 00       	mov    %eax,0x9d4
}
 6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 702:	5b                   	pop    %ebx
 703:	5e                   	pop    %esi
 704:	5f                   	pop    %edi
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    
 707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 710:	c7 05 d4 09 00 00 d8 	movl   $0x9d8,0x9d4
 717:	09 00 00 
    base.s.size = 0;
 71a:	bf d8 09 00 00       	mov    $0x9d8,%edi
    base.s.ptr = freep = prevp = &base;
 71f:	c7 05 d8 09 00 00 d8 	movl   $0x9d8,0x9d8
 726:	09 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 729:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 72b:	c7 05 dc 09 00 00 00 	movl   $0x0,0x9dc
 732:	00 00 00 
    if(p->s.size >= nunits){
 735:	e9 36 ff ff ff       	jmp    670 <malloc+0x30>
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 740:	8b 0a                	mov    (%edx),%ecx
 742:	89 08                	mov    %ecx,(%eax)
 744:	eb b1                	jmp    6f7 <malloc+0xb7>
