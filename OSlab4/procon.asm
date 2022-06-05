
_procon:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

    exit();
}

int main()
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
    sem_init(MUTEX, 1);
  15:	6a 01                	push   $0x1
  17:	6a 00                	push   $0x0
  19:	e8 b5 04 00 00       	call   4d3 <sem_init>
    sem_init(EMPTY, 5);
  1e:	58                   	pop    %eax
  1f:	5a                   	pop    %edx
  20:	6a 05                	push   $0x5
  22:	6a 01                	push   $0x1
  24:	e8 aa 04 00 00       	call   4d3 <sem_init>
    sem_init(FULL, 0);
  29:	59                   	pop    %ecx
  2a:	58                   	pop    %eax
  2b:	6a 00                	push   $0x0
  2d:	6a 02                	push   $0x2
  2f:	e8 9f 04 00 00       	call   4d3 <sem_init>

    int pid = fork();
  34:	e8 f2 03 00 00       	call   42b <fork>
    if (pid == 0) 
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	75 0a                	jne    4a <main+0x4a>
    {
        producer(pid);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 00                	push   $0x0
  45:	e8 26 00 00 00       	call   70 <producer>
    } 
    else 
    {
        int pid2 = fork();
  4a:	e8 dc 03 00 00       	call   42b <fork>
        if (pid2 == 0) 
  4f:	85 c0                	test   %eax,%eax
  51:	75 0a                	jne    5d <main+0x5d>
        {
            consumer(pid2);
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	6a 00                	push   $0x0
  58:	e8 c3 00 00 00       	call   120 <consumer>
        } else 
        {
			wait();
  5d:	e8 d9 03 00 00       	call   43b <wait>
			wait();
  62:	e8 d4 03 00 00       	call   43b <wait>
		}
    }
    
    exit();
  67:	e8 c7 03 00 00       	call   433 <exit>
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <producer>:
{
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	53                   	push   %ebx
    for (int j = 0; j < SIZE; j++)
  78:	31 db                	xor    %ebx,%ebx
{
  7a:	83 ec 04             	sub    $0x4,%esp
		sem_acquire(EMPTY);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	6a 01                	push   $0x1
  82:	e8 54 04 00 00       	call   4db <sem_acquire>
        sem_acquire(MUTEX);
  87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8e:	e8 48 04 00 00       	call   4db <sem_acquire>
        printf(1, "Produce value\n");
  93:	59                   	pop    %ecx
  94:	58                   	pop    %eax
  95:	68 18 09 00 00       	push   $0x918
  9a:	6a 01                	push   $0x1
  9c:	e8 0f 05 00 00       	call   5b0 <printf>
        sem_release(MUTEX);
  a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a8:	e8 36 04 00 00       	call   4e3 <sem_release>
		sem_release(FULL);
  ad:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  b4:	e8 2a 04 00 00       	call   4e3 <sem_release>
		sem_acquire(MUTEX);
  b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c0:	e8 16 04 00 00       	call   4db <sem_acquire>
        printf(1, "Add to queue %d\n", j);
  c5:	83 c4 0c             	add    $0xc,%esp
  c8:	53                   	push   %ebx
    for (int j = 0; j < SIZE; j++)
  c9:	83 c3 01             	add    $0x1,%ebx
        printf(1, "Add to queue %d\n", j);
  cc:	68 27 09 00 00       	push   $0x927
  d1:	6a 01                	push   $0x1
  d3:	e8 d8 04 00 00       	call   5b0 <printf>
		sem_release(MUTEX);
  d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  df:	e8 ff 03 00 00       	call   4e3 <sem_release>
    for (int j = 0; j < SIZE; j++)
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	83 fb 05             	cmp    $0x5,%ebx
  ea:	75 91                	jne    7d <producer+0xd>
	sem_acquire(MUTEX);
  ec:	83 ec 0c             	sub    $0xc,%esp
  ef:	6a 00                	push   $0x0
  f1:	e8 e5 03 00 00       	call   4db <sem_acquire>
    printf(1, "Full queue\n");
  f6:	58                   	pop    %eax
  f7:	5a                   	pop    %edx
  f8:	68 38 09 00 00       	push   $0x938
  fd:	6a 01                	push   $0x1
  ff:	e8 ac 04 00 00       	call   5b0 <printf>
	sem_release(MUTEX);
 104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 10b:	e8 d3 03 00 00       	call   4e3 <sem_release>
    exit();
 110:	e8 1e 03 00 00       	call   433 <exit>
 115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000120 <consumer>:
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	53                   	push   %ebx
    for (int j = 0; j < SIZE; j++)
 128:	31 db                	xor    %ebx,%ebx
{
 12a:	83 ec 04             	sub    $0x4,%esp
		sem_acquire(FULL);
 12d:	83 ec 0c             	sub    $0xc,%esp
 130:	6a 02                	push   $0x2
 132:	e8 a4 03 00 00       	call   4db <sem_acquire>
        sem_acquire(MUTEX);
 137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 13e:	e8 98 03 00 00       	call   4db <sem_acquire>
        printf(1, "Pop from queue\n");
 143:	59                   	pop    %ecx
 144:	58                   	pop    %eax
 145:	68 44 09 00 00       	push   $0x944
 14a:	6a 01                	push   $0x1
 14c:	e8 5f 04 00 00       	call   5b0 <printf>
        sem_release(MUTEX);
 151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 158:	e8 86 03 00 00       	call   4e3 <sem_release>
		sem_release(EMPTY);
 15d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 164:	e8 7a 03 00 00       	call   4e3 <sem_release>
		sem_acquire(MUTEX);
 169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 170:	e8 66 03 00 00       	call   4db <sem_acquire>
		printf(1, "Consume value %d\n", j);
 175:	83 c4 0c             	add    $0xc,%esp
 178:	53                   	push   %ebx
    for (int j = 0; j < SIZE; j++)
 179:	83 c3 01             	add    $0x1,%ebx
		printf(1, "Consume value %d\n", j);
 17c:	68 54 09 00 00       	push   $0x954
 181:	6a 01                	push   $0x1
 183:	e8 28 04 00 00       	call   5b0 <printf>
		sem_release(MUTEX);
 188:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18f:	e8 4f 03 00 00       	call   4e3 <sem_release>
    for (int j = 0; j < SIZE; j++)
 194:	83 c4 10             	add    $0x10,%esp
 197:	83 fb 05             	cmp    $0x5,%ebx
 19a:	75 91                	jne    12d <consumer+0xd>
	sem_acquire(MUTEX);
 19c:	83 ec 0c             	sub    $0xc,%esp
 19f:	6a 00                	push   $0x0
 1a1:	e8 35 03 00 00       	call   4db <sem_acquire>
	printf(1, "Empty queue\n");
 1a6:	58                   	pop    %eax
 1a7:	5a                   	pop    %edx
 1a8:	68 66 09 00 00       	push   $0x966
 1ad:	6a 01                	push   $0x1
 1af:	e8 fc 03 00 00       	call   5b0 <printf>
	sem_release(MUTEX);
 1b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bb:	e8 23 03 00 00       	call   4e3 <sem_release>
    exit();
 1c0:	e8 6e 02 00 00       	call   433 <exit>
 1c5:	66 90                	xchg   %ax,%ax
 1c7:	66 90                	xchg   %ax,%ax
 1c9:	66 90                	xchg   %ax,%ax
 1cb:	66 90                	xchg   %ax,%ax
 1cd:	66 90                	xchg   %ax,%ax
 1cf:	90                   	nop

000001d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d5:	31 c0                	xor    %eax,%eax
{
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	53                   	push   %ebx
 1da:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strcpy+0x10>
    ;
  return os;
}
 1ee:	89 c8                	mov    %ecx,%eax
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	53                   	push   %ebx
 208:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 20e:	0f b6 01             	movzbl (%ecx),%eax
 211:	0f b6 1a             	movzbl (%edx),%ebx
 214:	84 c0                	test   %al,%al
 216:	75 19                	jne    231 <strcmp+0x31>
 218:	eb 26                	jmp    240 <strcmp+0x40>
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 220:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 224:	83 c1 01             	add    $0x1,%ecx
 227:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 22a:	0f b6 1a             	movzbl (%edx),%ebx
 22d:	84 c0                	test   %al,%al
 22f:	74 0f                	je     240 <strcmp+0x40>
 231:	38 d8                	cmp    %bl,%al
 233:	74 eb                	je     220 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 235:	29 d8                	sub    %ebx,%eax
}
 237:	5b                   	pop    %ebx
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 242:	29 d8                	sub    %ebx,%eax
}
 244:	5b                   	pop    %ebx
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <strlen>:

uint
strlen(const char *s)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 25a:	80 3a 00             	cmpb   $0x0,(%edx)
 25d:	74 21                	je     280 <strlen+0x30>
 25f:	31 c0                	xor    %eax,%eax
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 268:	83 c0 01             	add    $0x1,%eax
 26b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 26f:	89 c1                	mov    %eax,%ecx
 271:	75 f5                	jne    268 <strlen+0x18>
    ;
  return n;
}
 273:	89 c8                	mov    %ecx,%eax
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 280:	31 c9                	xor    %ecx,%ecx
}
 282:	5d                   	pop    %ebp
 283:	89 c8                	mov    %ecx,%eax
 285:	c3                   	ret    
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	57                   	push   %edi
 298:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 29b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29e:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a1:	89 d7                	mov    %edx,%edi
 2a3:	fc                   	cld    
 2a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    
 2ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2af:	90                   	nop

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2be:	0f b6 10             	movzbl (%eax),%edx
 2c1:	84 d2                	test   %dl,%dl
 2c3:	75 16                	jne    2db <strchr+0x2b>
 2c5:	eb 21                	jmp    2e8 <strchr+0x38>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
 2d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2d4:	83 c0 01             	add    $0x1,%eax
 2d7:	84 d2                	test   %dl,%dl
 2d9:	74 0d                	je     2e8 <strchr+0x38>
    if(*s == c)
 2db:	38 d1                	cmp    %dl,%cl
 2dd:	75 f1                	jne    2d0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2e8:	31 c0                	xor    %eax,%eax
}
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	57                   	push   %edi
 2f8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f9:	31 f6                	xor    %esi,%esi
{
 2fb:	53                   	push   %ebx
 2fc:	89 f3                	mov    %esi,%ebx
 2fe:	83 ec 1c             	sub    $0x1c,%esp
 301:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 304:	eb 33                	jmp    339 <gets+0x49>
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	8d 45 e7             	lea    -0x19(%ebp),%eax
 316:	6a 01                	push   $0x1
 318:	50                   	push   %eax
 319:	6a 00                	push   $0x0
 31b:	e8 2b 01 00 00       	call   44b <read>
    if(cc < 1)
 320:	83 c4 10             	add    $0x10,%esp
 323:	85 c0                	test   %eax,%eax
 325:	7e 1c                	jle    343 <gets+0x53>
      break;
    buf[i++] = c;
 327:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 32b:	83 c7 01             	add    $0x1,%edi
 32e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 331:	3c 0a                	cmp    $0xa,%al
 333:	74 23                	je     358 <gets+0x68>
 335:	3c 0d                	cmp    $0xd,%al
 337:	74 1f                	je     358 <gets+0x68>
  for(i=0; i+1 < max; ){
 339:	83 c3 01             	add    $0x1,%ebx
 33c:	89 fe                	mov    %edi,%esi
 33e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 341:	7c cd                	jl     310 <gets+0x20>
 343:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 345:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 348:	c6 03 00             	movb   $0x0,(%ebx)
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 357:	90                   	nop
 358:	8b 75 08             	mov    0x8(%ebp),%esi
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	01 de                	add    %ebx,%esi
 360:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 362:	c6 03 00             	movb   $0x0,(%ebx)
}
 365:	8d 65 f4             	lea    -0xc(%ebp),%esp
 368:	5b                   	pop    %ebx
 369:	5e                   	pop    %esi
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	8d 76 00             	lea    0x0(%esi),%esi

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	56                   	push   %esi
 378:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 379:	83 ec 08             	sub    $0x8,%esp
 37c:	6a 00                	push   $0x0
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 ed 00 00 00       	call   473 <open>
  if(fd < 0)
 386:	83 c4 10             	add    $0x10,%esp
 389:	85 c0                	test   %eax,%eax
 38b:	78 2b                	js     3b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 38d:	83 ec 08             	sub    $0x8,%esp
 390:	ff 75 0c             	pushl  0xc(%ebp)
 393:	89 c3                	mov    %eax,%ebx
 395:	50                   	push   %eax
 396:	e8 f0 00 00 00       	call   48b <fstat>
  close(fd);
 39b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39e:	89 c6                	mov    %eax,%esi
  close(fd);
 3a0:	e8 b6 00 00 00       	call   45b <close>
  return r;
 3a5:	83 c4 10             	add    $0x10,%esp
}
 3a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ab:	89 f0                	mov    %esi,%eax
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3bd:	eb e9                	jmp    3a8 <stat+0x38>
 3bf:	90                   	nop

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	53                   	push   %ebx
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3cb:	0f be 02             	movsbl (%edx),%eax
 3ce:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3d1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d9:	77 1a                	ja     3f5 <atoi+0x35>
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	89 c8                	mov    %ecx,%eax
 3f7:	5b                   	pop    %ebx
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	8b 45 10             	mov    0x10(%ebp),%eax
 40b:	8b 55 08             	mov    0x8(%ebp),%edx
 40e:	56                   	push   %esi
 40f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 412:	85 c0                	test   %eax,%eax
 414:	7e 0f                	jle    425 <memmove+0x25>
 416:	01 d0                	add    %edx,%eax
  dst = vdst;
 418:	89 d7                	mov    %edx,%edi
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <sem_init>:

SYSCALL(sem_init)
 4d3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <sem_acquire>:
SYSCALL(sem_acquire)
 4db:	b8 20 00 00 00       	mov    $0x20,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <sem_release>:
SYSCALL(sem_release)
 4e3:	b8 21 00 00 00       	mov    $0x21,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <reentrant>:

SYSCALL(reentrant)
 4eb:	b8 22 00 00 00       	mov    $0x22,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    
 4f3:	66 90                	xchg   %ax,%ax
 4f5:	66 90                	xchg   %ax,%ax
 4f7:	66 90                	xchg   %ax,%ax
 4f9:	66 90                	xchg   %ax,%ax
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 3c             	sub    $0x3c,%esp
 509:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 50c:	89 d1                	mov    %edx,%ecx
{
 50e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 511:	85 d2                	test   %edx,%edx
 513:	0f 89 7f 00 00 00    	jns    598 <printint+0x98>
 519:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 51d:	74 79                	je     598 <printint+0x98>
    neg = 1;
 51f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 526:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 528:	31 db                	xor    %ebx,%ebx
 52a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 530:	89 c8                	mov    %ecx,%eax
 532:	31 d2                	xor    %edx,%edx
 534:	89 cf                	mov    %ecx,%edi
 536:	f7 75 c4             	divl   -0x3c(%ebp)
 539:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
 540:	89 45 c0             	mov    %eax,-0x40(%ebp)
 543:	89 d8                	mov    %ebx,%eax
 545:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 548:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 54b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 54e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 551:	76 dd                	jbe    530 <printint+0x30>
  if(neg)
 553:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 556:	85 c9                	test   %ecx,%ecx
 558:	74 0c                	je     566 <printint+0x66>
    buf[i++] = '-';
 55a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 55f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 561:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 566:	8b 7d b8             	mov    -0x48(%ebp),%edi
 569:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 56d:	eb 07                	jmp    576 <printint+0x76>
 56f:	90                   	nop
 570:	0f b6 13             	movzbl (%ebx),%edx
 573:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 576:	83 ec 04             	sub    $0x4,%esp
 579:	88 55 d7             	mov    %dl,-0x29(%ebp)
 57c:	6a 01                	push   $0x1
 57e:	56                   	push   %esi
 57f:	57                   	push   %edi
 580:	e8 ce fe ff ff       	call   453 <write>
  while(--i >= 0)
 585:	83 c4 10             	add    $0x10,%esp
 588:	39 de                	cmp    %ebx,%esi
 58a:	75 e4                	jne    570 <printint+0x70>
    putc(fd, buf[i]);
}
 58c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 598:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 59f:	eb 87                	jmp    528 <printint+0x28>
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bd:	8b 75 0c             	mov    0xc(%ebp),%esi
 5c0:	0f b6 1e             	movzbl (%esi),%ebx
 5c3:	84 db                	test   %bl,%bl
 5c5:	0f 84 b4 00 00 00    	je     67f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5cb:	8d 45 10             	lea    0x10(%ebp),%eax
 5ce:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5d1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5d4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d9:	eb 33                	jmp    60e <printf+0x5e>
 5db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
 5e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5e3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	74 17                	je     604 <printf+0x54>
  write(fd, &c, 1);
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 55 fe ff ff       	call   453 <write>
 5fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 601:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 604:	0f b6 1e             	movzbl (%esi),%ebx
 607:	83 c6 01             	add    $0x1,%esi
 60a:	84 db                	test   %bl,%bl
 60c:	74 71                	je     67f <printf+0xcf>
    c = fmt[i] & 0xff;
 60e:	0f be cb             	movsbl %bl,%ecx
 611:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 614:	85 d2                	test   %edx,%edx
 616:	74 c8                	je     5e0 <printf+0x30>
      }
    } else if(state == '%'){
 618:	83 fa 25             	cmp    $0x25,%edx
 61b:	75 e7                	jne    604 <printf+0x54>
      if(c == 'd'){
 61d:	83 f8 64             	cmp    $0x64,%eax
 620:	0f 84 9a 00 00 00    	je     6c0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 626:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 62c:	83 f9 70             	cmp    $0x70,%ecx
 62f:	74 5f                	je     690 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 631:	83 f8 73             	cmp    $0x73,%eax
 634:	0f 84 d6 00 00 00    	je     710 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63a:	83 f8 63             	cmp    $0x63,%eax
 63d:	0f 84 8d 00 00 00    	je     6d0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 643:	83 f8 25             	cmp    $0x25,%eax
 646:	0f 84 b4 00 00 00    	je     700 <printf+0x150>
  write(fd, &c, 1);
 64c:	83 ec 04             	sub    $0x4,%esp
 64f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 653:	6a 01                	push   $0x1
 655:	57                   	push   %edi
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 f5 fd ff ff       	call   453 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 65e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 661:	83 c4 0c             	add    $0xc,%esp
 664:	6a 01                	push   $0x1
 666:	83 c6 01             	add    $0x1,%esi
 669:	57                   	push   %edi
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 e1 fd ff ff       	call   453 <write>
  for(i = 0; fmt[i]; i++){
 672:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 676:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 679:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 67b:	84 db                	test   %bl,%bl
 67d:	75 8f                	jne    60e <printf+0x5e>
    }
  }
}
 67f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5f                   	pop    %edi
 685:	5d                   	pop    %ebp
 686:	c3                   	ret    
 687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 10 00 00 00       	mov    $0x10,%ecx
 698:	6a 00                	push   $0x0
 69a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	8b 13                	mov    (%ebx),%edx
 6a2:	e8 59 fe ff ff       	call   500 <printint>
        ap++;
 6a7:	89 d8                	mov    %ebx,%eax
 6a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ac:	31 d2                	xor    %edx,%edx
        ap++;
 6ae:	83 c0 04             	add    $0x4,%eax
 6b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b4:	e9 4b ff ff ff       	jmp    604 <printf+0x54>
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	eb ce                	jmp    69a <printf+0xea>
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6d0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6d6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
        ap++;
 6da:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6dd:	57                   	push   %edi
 6de:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e4:	e8 6a fd ff ff       	call   453 <write>
        ap++;
 6e9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	e9 0e ff ff ff       	jmp    604 <printf+0x54>
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 700:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
 706:	e9 59 ff ff ff       	jmp    664 <printf+0xb4>
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
        s = (char*)*ap;
 710:	8b 45 d0             	mov    -0x30(%ebp),%eax
 713:	8b 18                	mov    (%eax),%ebx
        ap++;
 715:	83 c0 04             	add    $0x4,%eax
 718:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 71b:	85 db                	test   %ebx,%ebx
 71d:	74 17                	je     736 <printf+0x186>
        while(*s != 0){
 71f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 722:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 724:	84 c0                	test   %al,%al
 726:	0f 84 d8 fe ff ff    	je     604 <printf+0x54>
 72c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 72f:	89 de                	mov    %ebx,%esi
 731:	8b 5d 08             	mov    0x8(%ebp),%ebx
 734:	eb 1a                	jmp    750 <printf+0x1a0>
          s = "(null)";
 736:	bb 73 09 00 00       	mov    $0x973,%ebx
        while(*s != 0){
 73b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 73e:	b8 28 00 00 00       	mov    $0x28,%eax
 743:	89 de                	mov    %ebx,%esi
 745:	8b 5d 08             	mov    0x8(%ebp),%ebx
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
          s++;
 753:	83 c6 01             	add    $0x1,%esi
 756:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 759:	6a 01                	push   $0x1
 75b:	57                   	push   %edi
 75c:	53                   	push   %ebx
 75d:	e8 f1 fc ff ff       	call   453 <write>
        while(*s != 0){
 762:	0f b6 06             	movzbl (%esi),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x1a0>
 76c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 8e fe ff ff       	jmp    604 <printf+0x54>
 776:	66 90                	xchg   %ax,%ax
 778:	66 90                	xchg   %ax,%ax
 77a:	66 90                	xchg   %ax,%ax
 77c:	66 90                	xchg   %ax,%ax
 77e:	66 90                	xchg   %ax,%ax

00000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 785:	a1 5c 0c 00 00       	mov    0xc5c,%eax
{
 78a:	89 e5                	mov    %esp,%ebp
 78c:	57                   	push   %edi
 78d:	56                   	push   %esi
 78e:	53                   	push   %ebx
 78f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 792:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 794:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	39 c8                	cmp    %ecx,%eax
 799:	73 15                	jae    7b0 <free+0x30>
 79b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
 7a0:	39 d1                	cmp    %edx,%ecx
 7a2:	72 14                	jb     7b8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	39 d0                	cmp    %edx,%eax
 7a6:	73 10                	jae    7b8 <free+0x38>
{
 7a8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	39 c8                	cmp    %ecx,%eax
 7ae:	72 f0                	jb     7a0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	39 d0                	cmp    %edx,%eax
 7b2:	72 f4                	jb     7a8 <free+0x28>
 7b4:	39 d1                	cmp    %edx,%ecx
 7b6:	73 f0                	jae    7a8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7be:	39 fa                	cmp    %edi,%edx
 7c0:	74 1e                	je     7e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7cb:	39 f1                	cmp    %esi,%ecx
 7cd:	74 28                	je     7f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7d1:	5b                   	pop    %ebx
  freep = p;
 7d2:	a3 5c 0c 00 00       	mov    %eax,0xc5c
}
 7d7:	5e                   	pop    %esi
 7d8:	5f                   	pop    %edi
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7e0:	03 72 04             	add    0x4(%edx),%esi
 7e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 12                	mov    (%edx),%edx
 7ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ed:	8b 50 04             	mov    0x4(%eax),%edx
 7f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f3:	39 f1                	cmp    %esi,%ecx
 7f5:	75 d8                	jne    7cf <free+0x4f>
    p->s.size += bp->s.size;
 7f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7fa:	a3 5c 0c 00 00       	mov    %eax,0xc5c
    p->s.size += bp->s.size;
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 802:	8b 53 f8             	mov    -0x8(%ebx),%edx
 805:	89 10                	mov    %edx,(%eax)
}
 807:	5b                   	pop    %ebx
 808:	5e                   	pop    %esi
 809:	5f                   	pop    %edi
 80a:	5d                   	pop    %ebp
 80b:	c3                   	ret    
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	f3 0f 1e fb          	endbr32 
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	57                   	push   %edi
 818:	56                   	push   %esi
 819:	53                   	push   %ebx
 81a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 820:	8b 3d 5c 0c 00 00    	mov    0xc5c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 826:	8d 70 07             	lea    0x7(%eax),%esi
 829:	c1 ee 03             	shr    $0x3,%esi
 82c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 82f:	85 ff                	test   %edi,%edi
 831:	0f 84 a9 00 00 00    	je     8e0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 837:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 839:	8b 48 04             	mov    0x4(%eax),%ecx
 83c:	39 f1                	cmp    %esi,%ecx
 83e:	73 6d                	jae    8ad <malloc+0x9d>
 840:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 846:	bb 00 10 00 00       	mov    $0x1000,%ebx
 84b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 84e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 855:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 858:	eb 17                	jmp    871 <malloc+0x61>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 862:	8b 4a 04             	mov    0x4(%edx),%ecx
 865:	39 f1                	cmp    %esi,%ecx
 867:	73 4f                	jae    8b8 <malloc+0xa8>
 869:	8b 3d 5c 0c 00 00    	mov    0xc5c,%edi
 86f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 871:	39 c7                	cmp    %eax,%edi
 873:	75 eb                	jne    860 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 875:	83 ec 0c             	sub    $0xc,%esp
 878:	ff 75 e4             	pushl  -0x1c(%ebp)
 87b:	e8 3b fc ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 880:	83 c4 10             	add    $0x10,%esp
 883:	83 f8 ff             	cmp    $0xffffffff,%eax
 886:	74 1b                	je     8a3 <malloc+0x93>
  hp->s.size = nu;
 888:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	83 c0 08             	add    $0x8,%eax
 891:	50                   	push   %eax
 892:	e8 e9 fe ff ff       	call   780 <free>
  return freep;
 897:	a1 5c 0c 00 00       	mov    0xc5c,%eax
      if((p = morecore(nunits)) == 0)
 89c:	83 c4 10             	add    $0x10,%esp
 89f:	85 c0                	test   %eax,%eax
 8a1:	75 bd                	jne    860 <malloc+0x50>
        return 0;
  }
}
 8a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8a6:	31 c0                	xor    %eax,%eax
}
 8a8:	5b                   	pop    %ebx
 8a9:	5e                   	pop    %esi
 8aa:	5f                   	pop    %edi
 8ab:	5d                   	pop    %ebp
 8ac:	c3                   	ret    
    if(p->s.size >= nunits){
 8ad:	89 c2                	mov    %eax,%edx
 8af:	89 f8                	mov    %edi,%eax
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8b8:	39 ce                	cmp    %ecx,%esi
 8ba:	74 54                	je     910 <malloc+0x100>
        p->s.size -= nunits;
 8bc:	29 f1                	sub    %esi,%ecx
 8be:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8c1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8c4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8c7:	a3 5c 0c 00 00       	mov    %eax,0xc5c
}
 8cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8cf:	8d 42 08             	lea    0x8(%edx),%eax
}
 8d2:	5b                   	pop    %ebx
 8d3:	5e                   	pop    %esi
 8d4:	5f                   	pop    %edi
 8d5:	5d                   	pop    %ebp
 8d6:	c3                   	ret    
 8d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8de:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8e0:	c7 05 5c 0c 00 00 60 	movl   $0xc60,0xc5c
 8e7:	0c 00 00 
    base.s.size = 0;
 8ea:	bf 60 0c 00 00       	mov    $0xc60,%edi
    base.s.ptr = freep = prevp = &base;
 8ef:	c7 05 60 0c 00 00 60 	movl   $0xc60,0xc60
 8f6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 8fb:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 902:	00 00 00 
    if(p->s.size >= nunits){
 905:	e9 36 ff ff ff       	jmp    840 <malloc+0x30>
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 910:	8b 0a                	mov    (%edx),%ecx
 912:	89 08                	mov    %ecx,(%eax)
 914:	eb b1                	jmp    8c7 <malloc+0xb7>
