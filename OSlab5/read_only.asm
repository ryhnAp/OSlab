
_read_only:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"
#include "mmu.h"

int main(int argc, char *argv[])
{
    1000:	f3 0f 1e fb          	endbr32 
    1004:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1008:	83 e4 f0             	and    $0xfffffff0,%esp
    100b:	ff 71 fc             	pushl  -0x4(%ecx)
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	56                   	push   %esi
    1012:	53                   	push   %ebx
    1013:	51                   	push   %ecx
    1014:	83 ec 14             	sub    $0x14,%esp
  printf(1, "Access to a location in code segment with *begin pointer.\n"); 
    1017:	68 88 18 00 00       	push   $0x1888
    101c:	6a 01                	push   $0x1
    101e:	e8 fd 04 00 00       	call   1520 <printf>
  char *begin = sbrk(0);
    1023:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    102a:	e8 fc 03 00 00       	call   142b <sbrk>
  sbrk(PGSIZE);
    102f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  char *begin = sbrk(0);
    1036:	89 c3                	mov    %eax,%ebx
  sbrk(PGSIZE);
    1038:	e8 ee 03 00 00       	call   142b <sbrk>
  printf(1, "Going to write value 'a' in parent process on that location.\n"); 
    103d:	58                   	pop    %eax
    103e:	5a                   	pop    %edx
    103f:	68 c4 18 00 00       	push   $0x18c4
    1044:	6a 01                	push   $0x1
    1046:	e8 d5 04 00 00       	call   1520 <printf>
  *begin='a';
    104b:	c6 03 61             	movb   $0x61,(%ebx)
  printf(1, "Write value 'a' in parent process successfully.\n"); 
    104e:	59                   	pop    %ecx
    104f:	5e                   	pop    %esi
    1050:	68 04 19 00 00       	push   $0x1904
    1055:	6a 01                	push   $0x1
    1057:	e8 c4 04 00 00       	call   1520 <printf>

  printf(1, "Now file is going to be read only...\n"); 
    105c:	58                   	pop    %eax
    105d:	5a                   	pop    %edx
    105e:	68 38 19 00 00       	push   $0x1938
    1063:	6a 01                	push   $0x1
    1065:	e8 b6 04 00 00       	call   1520 <printf>
  provide_protection(begin, 1); // just one char and in entry address we make changes
    106a:	59                   	pop    %ecx
    106b:	5e                   	pop    %esi
    106c:	6a 01                	push   $0x1
    106e:	53                   	push   %ebx
    106f:	e8 cf 03 00 00       	call   1443 <provide_protection>
  printf(1, "Fork a child which make pointer and location unprotected(readable&writable).\n"); 
    1074:	58                   	pop    %eax
    1075:	5a                   	pop    %edx
    1076:	68 60 19 00 00       	push   $0x1960
    107b:	6a 01                	push   $0x1
    107d:	e8 9e 04 00 00       	call   1520 <printf>
  int refuse_caller=fork();
    1082:	e8 14 03 00 00       	call   139b <fork>
  if (refuse_caller != 0)
    1087:	83 c4 10             	add    $0x10,%esp
    108a:	85 c0                	test   %eax,%eax
    108c:	75 44                	jne    10d2 <main+0xd2>
  int protect_writer=-1;
  if (refuse_caller != 0)
    protect_writer = fork();

  if (refuse_caller==0){
	  printf(1, "\nProtected written value by parent = %c\n",*begin); 
    108e:	0f be 03             	movsbl (%ebx),%eax
    1091:	83 ec 04             	sub    $0x4,%esp
    1094:	50                   	push   %eax
    1095:	68 9c 1a 00 00       	push   $0x1a9c
    109a:	6a 01                	push   $0x1
    109c:	e8 7f 04 00 00       	call   1520 <printf>
    refuse_protection(begin, 1);  
    10a1:	58                   	pop    %eax
    10a2:	5a                   	pop    %edx
    10a3:	6a 01                	push   $0x1
    10a5:	53                   	push   %ebx
    10a6:	e8 a0 03 00 00       	call   144b <refuse_protection>
    printf(1, "Unprotected file(readable&writable) by first child.\n"); 
    10ab:	59                   	pop    %ecx
    10ac:	5e                   	pop    %esi
    10ad:	68 c8 1a 00 00       	push   $0x1ac8
    10b2:	6a 01                	push   $0x1
    10b4:	e8 67 04 00 00       	call   1520 <printf>
    *begin='b';
    printf(1, "After unprotecting the written value become = %c\n",*begin);
    10b9:	83 c4 0c             	add    $0xc,%esp
    *begin='b';
    10bc:	c6 03 62             	movb   $0x62,(%ebx)
    printf(1, "After unprotecting the written value become = %c\n",*begin);
    10bf:	6a 62                	push   $0x62
    10c1:	68 00 1b 00 00       	push   $0x1b00
    10c6:	6a 01                	push   $0x1
    10c8:	e8 53 04 00 00       	call   1520 <printf>
    exit();
    10cd:	e8 d1 02 00 00       	call   13a3 <exit>
    10d2:	89 c6                	mov    %eax,%esi
    printf(1, "Fork a child which writes on read only.\n"); 
    10d4:	50                   	push   %eax
    10d5:	50                   	push   %eax
    10d6:	68 b0 19 00 00       	push   $0x19b0
    10db:	6a 01                	push   $0x1
    10dd:	e8 3e 04 00 00       	call   1520 <printf>
    protect_writer = fork();
    10e2:	e8 b4 02 00 00       	call   139b <fork>
  }
  else if (protect_writer == 0)
    10e7:	83 c4 10             	add    $0x10,%esp
    10ea:	85 c0                	test   %eax,%eax
    10ec:	75 33                	jne    1121 <main+0x121>
  {
    wait();
    10ee:	e8 b8 02 00 00       	call   13ab <wait>
    sleep(20);
    10f3:	83 ec 0c             	sub    $0xc,%esp
    10f6:	6a 14                	push   $0x14
    10f8:	e8 36 03 00 00       	call   1433 <sleep>
    printf(1, "\nSecond child is going to stuck in trap.\ncuz it doesn't Know first child make file unprotected and writes in read only!\n"); 
    10fd:	58                   	pop    %eax
    10fe:	5a                   	pop    %edx
    10ff:	68 dc 19 00 00       	push   $0x19dc
    1104:	6a 01                	push   $0x1
    1106:	e8 15 04 00 00       	call   1520 <printf>
    *begin='c'; 
    110b:	c6 03 63             	movb   $0x63,(%ebx)
    printf(1, "\nTrap notice writing on read only, so you won't this announcement!\n");    
    110e:	59                   	pop    %ecx
    110f:	5b                   	pop    %ebx
    1110:	68 58 1a 00 00       	push   $0x1a58
    1115:	6a 01                	push   $0x1
    1117:	e8 04 04 00 00       	call   1520 <printf>
    exit();
    111c:	e8 82 02 00 00       	call   13a3 <exit>
  }
  else if((refuse_caller>0) & (protect_writer>0)){
    1121:	85 f6                	test   %esi,%esi
    1123:	7e 0e                	jle    1133 <main+0x133>
    1125:	85 c0                	test   %eax,%eax
    1127:	7e 0a                	jle    1133 <main+0x133>
    wait();
    1129:	e8 7d 02 00 00       	call   13ab <wait>
    wait();
    112e:	e8 78 02 00 00       	call   13ab <wait>
  } 
  exit();
    1133:	e8 6b 02 00 00       	call   13a3 <exit>
    1138:	66 90                	xchg   %ax,%ax
    113a:	66 90                	xchg   %ax,%ax
    113c:	66 90                	xchg   %ax,%ax
    113e:	66 90                	xchg   %ax,%ax

00001140 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    1140:	f3 0f 1e fb          	endbr32 
    1144:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1145:	31 c0                	xor    %eax,%eax
{
    1147:	89 e5                	mov    %esp,%ebp
    1149:	53                   	push   %ebx
    114a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    114d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1150:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1154:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1157:	83 c0 01             	add    $0x1,%eax
    115a:	84 d2                	test   %dl,%dl
    115c:	75 f2                	jne    1150 <strcpy+0x10>
    ;
  return os;
}
    115e:	89 c8                	mov    %ecx,%eax
    1160:	5b                   	pop    %ebx
    1161:	5d                   	pop    %ebp
    1162:	c3                   	ret    
    1163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    116a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1170:	f3 0f 1e fb          	endbr32 
    1174:	55                   	push   %ebp
    1175:	89 e5                	mov    %esp,%ebp
    1177:	53                   	push   %ebx
    1178:	8b 4d 08             	mov    0x8(%ebp),%ecx
    117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    117e:	0f b6 01             	movzbl (%ecx),%eax
    1181:	0f b6 1a             	movzbl (%edx),%ebx
    1184:	84 c0                	test   %al,%al
    1186:	75 19                	jne    11a1 <strcmp+0x31>
    1188:	eb 26                	jmp    11b0 <strcmp+0x40>
    118a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1190:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1194:	83 c1 01             	add    $0x1,%ecx
    1197:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    119a:	0f b6 1a             	movzbl (%edx),%ebx
    119d:	84 c0                	test   %al,%al
    119f:	74 0f                	je     11b0 <strcmp+0x40>
    11a1:	38 d8                	cmp    %bl,%al
    11a3:	74 eb                	je     1190 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    11a5:	29 d8                	sub    %ebx,%eax
}
    11a7:	5b                   	pop    %ebx
    11a8:	5d                   	pop    %ebp
    11a9:	c3                   	ret    
    11aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    11b2:	29 d8                	sub    %ebx,%eax
}
    11b4:	5b                   	pop    %ebx
    11b5:	5d                   	pop    %ebp
    11b6:	c3                   	ret    
    11b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11be:	66 90                	xchg   %ax,%ax

000011c0 <strlen>:

uint
strlen(const char *s)
{
    11c0:	f3 0f 1e fb          	endbr32 
    11c4:	55                   	push   %ebp
    11c5:	89 e5                	mov    %esp,%ebp
    11c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    11ca:	80 3a 00             	cmpb   $0x0,(%edx)
    11cd:	74 21                	je     11f0 <strlen+0x30>
    11cf:	31 c0                	xor    %eax,%eax
    11d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11d8:	83 c0 01             	add    $0x1,%eax
    11db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    11df:	89 c1                	mov    %eax,%ecx
    11e1:	75 f5                	jne    11d8 <strlen+0x18>
    ;
  return n;
}
    11e3:	89 c8                	mov    %ecx,%eax
    11e5:	5d                   	pop    %ebp
    11e6:	c3                   	ret    
    11e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ee:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    11f0:	31 c9                	xor    %ecx,%ecx
}
    11f2:	5d                   	pop    %ebp
    11f3:	89 c8                	mov    %ecx,%eax
    11f5:	c3                   	ret    
    11f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11fd:	8d 76 00             	lea    0x0(%esi),%esi

00001200 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1200:	f3 0f 1e fb          	endbr32 
    1204:	55                   	push   %ebp
    1205:	89 e5                	mov    %esp,%ebp
    1207:	57                   	push   %edi
    1208:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    120b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    120e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1211:	89 d7                	mov    %edx,%edi
    1213:	fc                   	cld    
    1214:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1216:	89 d0                	mov    %edx,%eax
    1218:	5f                   	pop    %edi
    1219:	5d                   	pop    %ebp
    121a:	c3                   	ret    
    121b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    121f:	90                   	nop

00001220 <strchr>:

char*
strchr(const char *s, char c)
{
    1220:	f3 0f 1e fb          	endbr32 
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	8b 45 08             	mov    0x8(%ebp),%eax
    122a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    122e:	0f b6 10             	movzbl (%eax),%edx
    1231:	84 d2                	test   %dl,%dl
    1233:	75 16                	jne    124b <strchr+0x2b>
    1235:	eb 21                	jmp    1258 <strchr+0x38>
    1237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123e:	66 90                	xchg   %ax,%ax
    1240:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1244:	83 c0 01             	add    $0x1,%eax
    1247:	84 d2                	test   %dl,%dl
    1249:	74 0d                	je     1258 <strchr+0x38>
    if(*s == c)
    124b:	38 d1                	cmp    %dl,%cl
    124d:	75 f1                	jne    1240 <strchr+0x20>
      return (char*)s;
  return 0;
}
    124f:	5d                   	pop    %ebp
    1250:	c3                   	ret    
    1251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1258:	31 c0                	xor    %eax,%eax
}
    125a:	5d                   	pop    %ebp
    125b:	c3                   	ret    
    125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001260 <gets>:

char*
gets(char *buf, int max)
{
    1260:	f3 0f 1e fb          	endbr32 
    1264:	55                   	push   %ebp
    1265:	89 e5                	mov    %esp,%ebp
    1267:	57                   	push   %edi
    1268:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1269:	31 f6                	xor    %esi,%esi
{
    126b:	53                   	push   %ebx
    126c:	89 f3                	mov    %esi,%ebx
    126e:	83 ec 1c             	sub    $0x1c,%esp
    1271:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1274:	eb 33                	jmp    12a9 <gets+0x49>
    1276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    127d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1280:	83 ec 04             	sub    $0x4,%esp
    1283:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1286:	6a 01                	push   $0x1
    1288:	50                   	push   %eax
    1289:	6a 00                	push   $0x0
    128b:	e8 2b 01 00 00       	call   13bb <read>
    if(cc < 1)
    1290:	83 c4 10             	add    $0x10,%esp
    1293:	85 c0                	test   %eax,%eax
    1295:	7e 1c                	jle    12b3 <gets+0x53>
      break;
    buf[i++] = c;
    1297:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    129b:	83 c7 01             	add    $0x1,%edi
    129e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    12a1:	3c 0a                	cmp    $0xa,%al
    12a3:	74 23                	je     12c8 <gets+0x68>
    12a5:	3c 0d                	cmp    $0xd,%al
    12a7:	74 1f                	je     12c8 <gets+0x68>
  for(i=0; i+1 < max; ){
    12a9:	83 c3 01             	add    $0x1,%ebx
    12ac:	89 fe                	mov    %edi,%esi
    12ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    12b1:	7c cd                	jl     1280 <gets+0x20>
    12b3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    12b5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    12b8:	c6 03 00             	movb   $0x0,(%ebx)
}
    12bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12be:	5b                   	pop    %ebx
    12bf:	5e                   	pop    %esi
    12c0:	5f                   	pop    %edi
    12c1:	5d                   	pop    %ebp
    12c2:	c3                   	ret    
    12c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12c7:	90                   	nop
    12c8:	8b 75 08             	mov    0x8(%ebp),%esi
    12cb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ce:	01 de                	add    %ebx,%esi
    12d0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    12d2:	c6 03 00             	movb   $0x0,(%ebx)
}
    12d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12d8:	5b                   	pop    %ebx
    12d9:	5e                   	pop    %esi
    12da:	5f                   	pop    %edi
    12db:	5d                   	pop    %ebp
    12dc:	c3                   	ret    
    12dd:	8d 76 00             	lea    0x0(%esi),%esi

000012e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12e0:	f3 0f 1e fb          	endbr32 
    12e4:	55                   	push   %ebp
    12e5:	89 e5                	mov    %esp,%ebp
    12e7:	56                   	push   %esi
    12e8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12e9:	83 ec 08             	sub    $0x8,%esp
    12ec:	6a 00                	push   $0x0
    12ee:	ff 75 08             	pushl  0x8(%ebp)
    12f1:	e8 ed 00 00 00       	call   13e3 <open>
  if(fd < 0)
    12f6:	83 c4 10             	add    $0x10,%esp
    12f9:	85 c0                	test   %eax,%eax
    12fb:	78 2b                	js     1328 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    12fd:	83 ec 08             	sub    $0x8,%esp
    1300:	ff 75 0c             	pushl  0xc(%ebp)
    1303:	89 c3                	mov    %eax,%ebx
    1305:	50                   	push   %eax
    1306:	e8 f0 00 00 00       	call   13fb <fstat>
  close(fd);
    130b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    130e:	89 c6                	mov    %eax,%esi
  close(fd);
    1310:	e8 b6 00 00 00       	call   13cb <close>
  return r;
    1315:	83 c4 10             	add    $0x10,%esp
}
    1318:	8d 65 f8             	lea    -0x8(%ebp),%esp
    131b:	89 f0                	mov    %esi,%eax
    131d:	5b                   	pop    %ebx
    131e:	5e                   	pop    %esi
    131f:	5d                   	pop    %ebp
    1320:	c3                   	ret    
    1321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1328:	be ff ff ff ff       	mov    $0xffffffff,%esi
    132d:	eb e9                	jmp    1318 <stat+0x38>
    132f:	90                   	nop

00001330 <atoi>:

int
atoi(const char *s)
{
    1330:	f3 0f 1e fb          	endbr32 
    1334:	55                   	push   %ebp
    1335:	89 e5                	mov    %esp,%ebp
    1337:	53                   	push   %ebx
    1338:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    133b:	0f be 02             	movsbl (%edx),%eax
    133e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1341:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1344:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1349:	77 1a                	ja     1365 <atoi+0x35>
    134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    134f:	90                   	nop
    n = n*10 + *s++ - '0';
    1350:	83 c2 01             	add    $0x1,%edx
    1353:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1356:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    135a:	0f be 02             	movsbl (%edx),%eax
    135d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1360:	80 fb 09             	cmp    $0x9,%bl
    1363:	76 eb                	jbe    1350 <atoi+0x20>
  return n;
}
    1365:	89 c8                	mov    %ecx,%eax
    1367:	5b                   	pop    %ebx
    1368:	5d                   	pop    %ebp
    1369:	c3                   	ret    
    136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1370:	f3 0f 1e fb          	endbr32 
    1374:	55                   	push   %ebp
    1375:	89 e5                	mov    %esp,%ebp
    1377:	57                   	push   %edi
    1378:	8b 45 10             	mov    0x10(%ebp),%eax
    137b:	8b 55 08             	mov    0x8(%ebp),%edx
    137e:	56                   	push   %esi
    137f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1382:	85 c0                	test   %eax,%eax
    1384:	7e 0f                	jle    1395 <memmove+0x25>
    1386:	01 d0                	add    %edx,%eax
  dst = vdst;
    1388:	89 d7                	mov    %edx,%edi
    138a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1391:	39 f8                	cmp    %edi,%eax
    1393:	75 fb                	jne    1390 <memmove+0x20>
  return vdst;
}
    1395:	5e                   	pop    %esi
    1396:	89 d0                	mov    %edx,%eax
    1398:	5f                   	pop    %edi
    1399:	5d                   	pop    %ebp
    139a:	c3                   	ret    

0000139b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    139b:	b8 01 00 00 00       	mov    $0x1,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <exit>:
SYSCALL(exit)
    13a3:	b8 02 00 00 00       	mov    $0x2,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <wait>:
SYSCALL(wait)
    13ab:	b8 03 00 00 00       	mov    $0x3,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <pipe>:
SYSCALL(pipe)
    13b3:	b8 04 00 00 00       	mov    $0x4,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <read>:
SYSCALL(read)
    13bb:	b8 05 00 00 00       	mov    $0x5,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <write>:
SYSCALL(write)
    13c3:	b8 10 00 00 00       	mov    $0x10,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <close>:
SYSCALL(close)
    13cb:	b8 15 00 00 00       	mov    $0x15,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <kill>:
SYSCALL(kill)
    13d3:	b8 06 00 00 00       	mov    $0x6,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <exec>:
SYSCALL(exec)
    13db:	b8 07 00 00 00       	mov    $0x7,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <open>:
SYSCALL(open)
    13e3:	b8 0f 00 00 00       	mov    $0xf,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <mknod>:
SYSCALL(mknod)
    13eb:	b8 11 00 00 00       	mov    $0x11,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <unlink>:
SYSCALL(unlink)
    13f3:	b8 12 00 00 00       	mov    $0x12,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <fstat>:
SYSCALL(fstat)
    13fb:	b8 08 00 00 00       	mov    $0x8,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <link>:
SYSCALL(link)
    1403:	b8 13 00 00 00       	mov    $0x13,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <mkdir>:
SYSCALL(mkdir)
    140b:	b8 14 00 00 00       	mov    $0x14,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <chdir>:
SYSCALL(chdir)
    1413:	b8 09 00 00 00       	mov    $0x9,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <dup>:
SYSCALL(dup)
    141b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <getpid>:
SYSCALL(getpid)
    1423:	b8 0b 00 00 00       	mov    $0xb,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <sbrk>:
SYSCALL(sbrk)
    142b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <sleep>:
SYSCALL(sleep)
    1433:	b8 0d 00 00 00       	mov    $0xd,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <uptime>:
SYSCALL(uptime)
    143b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <provide_protection>:
SYSCALL(provide_protection)
    1443:	b8 18 00 00 00       	mov    $0x18,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <refuse_protection>:
SYSCALL(refuse_protection)
    144b:	b8 19 00 00 00       	mov    $0x19,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <settickets>:
SYSCALL(settickets) 
    1453:	b8 16 00 00 00       	mov    $0x16,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <getpinfo>:
    145b:	b8 17 00 00 00       	mov    $0x17,%eax
    1460:	cd 40                	int    $0x40
    1462:	c3                   	ret    
    1463:	66 90                	xchg   %ax,%ax
    1465:	66 90                	xchg   %ax,%ax
    1467:	66 90                	xchg   %ax,%ax
    1469:	66 90                	xchg   %ax,%ax
    146b:	66 90                	xchg   %ax,%ax
    146d:	66 90                	xchg   %ax,%ax
    146f:	90                   	nop

00001470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1470:	55                   	push   %ebp
    1471:	89 e5                	mov    %esp,%ebp
    1473:	57                   	push   %edi
    1474:	56                   	push   %esi
    1475:	53                   	push   %ebx
    1476:	83 ec 3c             	sub    $0x3c,%esp
    1479:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    147c:	89 d1                	mov    %edx,%ecx
{
    147e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1481:	85 d2                	test   %edx,%edx
    1483:	0f 89 7f 00 00 00    	jns    1508 <printint+0x98>
    1489:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    148d:	74 79                	je     1508 <printint+0x98>
    neg = 1;
    148f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1496:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1498:	31 db                	xor    %ebx,%ebx
    149a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    149d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    14a0:	89 c8                	mov    %ecx,%eax
    14a2:	31 d2                	xor    %edx,%edx
    14a4:	89 cf                	mov    %ecx,%edi
    14a6:	f7 75 c4             	divl   -0x3c(%ebp)
    14a9:	0f b6 92 3c 1b 00 00 	movzbl 0x1b3c(%edx),%edx
    14b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    14b3:	89 d8                	mov    %ebx,%eax
    14b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    14b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    14bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    14be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    14c1:	76 dd                	jbe    14a0 <printint+0x30>
  if(neg)
    14c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    14c6:	85 c9                	test   %ecx,%ecx
    14c8:	74 0c                	je     14d6 <printint+0x66>
    buf[i++] = '-';
    14ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    14cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    14d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    14d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    14d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    14dd:	eb 07                	jmp    14e6 <printint+0x76>
    14df:	90                   	nop
    14e0:	0f b6 13             	movzbl (%ebx),%edx
    14e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    14e6:	83 ec 04             	sub    $0x4,%esp
    14e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    14ec:	6a 01                	push   $0x1
    14ee:	56                   	push   %esi
    14ef:	57                   	push   %edi
    14f0:	e8 ce fe ff ff       	call   13c3 <write>
  while(--i >= 0)
    14f5:	83 c4 10             	add    $0x10,%esp
    14f8:	39 de                	cmp    %ebx,%esi
    14fa:	75 e4                	jne    14e0 <printint+0x70>
    putc(fd, buf[i]);
}
    14fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14ff:	5b                   	pop    %ebx
    1500:	5e                   	pop    %esi
    1501:	5f                   	pop    %edi
    1502:	5d                   	pop    %ebp
    1503:	c3                   	ret    
    1504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1508:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    150f:	eb 87                	jmp    1498 <printint+0x28>
    1511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    151f:	90                   	nop

00001520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1520:	f3 0f 1e fb          	endbr32 
    1524:	55                   	push   %ebp
    1525:	89 e5                	mov    %esp,%ebp
    1527:	57                   	push   %edi
    1528:	56                   	push   %esi
    1529:	53                   	push   %ebx
    152a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    152d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1530:	0f b6 1e             	movzbl (%esi),%ebx
    1533:	84 db                	test   %bl,%bl
    1535:	0f 84 b4 00 00 00    	je     15ef <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    153b:	8d 45 10             	lea    0x10(%ebp),%eax
    153e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1541:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1544:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1546:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1549:	eb 33                	jmp    157e <printf+0x5e>
    154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    154f:	90                   	nop
    1550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1553:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1558:	83 f8 25             	cmp    $0x25,%eax
    155b:	74 17                	je     1574 <printf+0x54>
  write(fd, &c, 1);
    155d:	83 ec 04             	sub    $0x4,%esp
    1560:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1563:	6a 01                	push   $0x1
    1565:	57                   	push   %edi
    1566:	ff 75 08             	pushl  0x8(%ebp)
    1569:	e8 55 fe ff ff       	call   13c3 <write>
    156e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1571:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1574:	0f b6 1e             	movzbl (%esi),%ebx
    1577:	83 c6 01             	add    $0x1,%esi
    157a:	84 db                	test   %bl,%bl
    157c:	74 71                	je     15ef <printf+0xcf>
    c = fmt[i] & 0xff;
    157e:	0f be cb             	movsbl %bl,%ecx
    1581:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1584:	85 d2                	test   %edx,%edx
    1586:	74 c8                	je     1550 <printf+0x30>
      }
    } else if(state == '%'){
    1588:	83 fa 25             	cmp    $0x25,%edx
    158b:	75 e7                	jne    1574 <printf+0x54>
      if(c == 'd'){
    158d:	83 f8 64             	cmp    $0x64,%eax
    1590:	0f 84 9a 00 00 00    	je     1630 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1596:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    159c:	83 f9 70             	cmp    $0x70,%ecx
    159f:	74 5f                	je     1600 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    15a1:	83 f8 73             	cmp    $0x73,%eax
    15a4:	0f 84 d6 00 00 00    	je     1680 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    15aa:	83 f8 63             	cmp    $0x63,%eax
    15ad:	0f 84 8d 00 00 00    	je     1640 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    15b3:	83 f8 25             	cmp    $0x25,%eax
    15b6:	0f 84 b4 00 00 00    	je     1670 <printf+0x150>
  write(fd, &c, 1);
    15bc:	83 ec 04             	sub    $0x4,%esp
    15bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    15c3:	6a 01                	push   $0x1
    15c5:	57                   	push   %edi
    15c6:	ff 75 08             	pushl  0x8(%ebp)
    15c9:	e8 f5 fd ff ff       	call   13c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    15ce:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    15d1:	83 c4 0c             	add    $0xc,%esp
    15d4:	6a 01                	push   $0x1
    15d6:	83 c6 01             	add    $0x1,%esi
    15d9:	57                   	push   %edi
    15da:	ff 75 08             	pushl  0x8(%ebp)
    15dd:	e8 e1 fd ff ff       	call   13c3 <write>
  for(i = 0; fmt[i]; i++){
    15e2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    15e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15e9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    15eb:	84 db                	test   %bl,%bl
    15ed:	75 8f                	jne    157e <printf+0x5e>
    }
  }
}
    15ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15f2:	5b                   	pop    %ebx
    15f3:	5e                   	pop    %esi
    15f4:	5f                   	pop    %edi
    15f5:	5d                   	pop    %ebp
    15f6:	c3                   	ret    
    15f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1600:	83 ec 0c             	sub    $0xc,%esp
    1603:	b9 10 00 00 00       	mov    $0x10,%ecx
    1608:	6a 00                	push   $0x0
    160a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    160d:	8b 45 08             	mov    0x8(%ebp),%eax
    1610:	8b 13                	mov    (%ebx),%edx
    1612:	e8 59 fe ff ff       	call   1470 <printint>
        ap++;
    1617:	89 d8                	mov    %ebx,%eax
    1619:	83 c4 10             	add    $0x10,%esp
      state = 0;
    161c:	31 d2                	xor    %edx,%edx
        ap++;
    161e:	83 c0 04             	add    $0x4,%eax
    1621:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1624:	e9 4b ff ff ff       	jmp    1574 <printf+0x54>
    1629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1630:	83 ec 0c             	sub    $0xc,%esp
    1633:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1638:	6a 01                	push   $0x1
    163a:	eb ce                	jmp    160a <printf+0xea>
    163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1640:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1643:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1646:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1648:	6a 01                	push   $0x1
        ap++;
    164a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    164d:	57                   	push   %edi
    164e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1651:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1654:	e8 6a fd ff ff       	call   13c3 <write>
        ap++;
    1659:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    165c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    165f:	31 d2                	xor    %edx,%edx
    1661:	e9 0e ff ff ff       	jmp    1574 <printf+0x54>
    1666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    166d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1670:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1673:	83 ec 04             	sub    $0x4,%esp
    1676:	e9 59 ff ff ff       	jmp    15d4 <printf+0xb4>
    167b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    167f:	90                   	nop
        s = (char*)*ap;
    1680:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1683:	8b 18                	mov    (%eax),%ebx
        ap++;
    1685:	83 c0 04             	add    $0x4,%eax
    1688:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    168b:	85 db                	test   %ebx,%ebx
    168d:	74 17                	je     16a6 <printf+0x186>
        while(*s != 0){
    168f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1692:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1694:	84 c0                	test   %al,%al
    1696:	0f 84 d8 fe ff ff    	je     1574 <printf+0x54>
    169c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    169f:	89 de                	mov    %ebx,%esi
    16a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16a4:	eb 1a                	jmp    16c0 <printf+0x1a0>
          s = "(null)";
    16a6:	bb 32 1b 00 00       	mov    $0x1b32,%ebx
        while(*s != 0){
    16ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    16ae:	b8 28 00 00 00       	mov    $0x28,%eax
    16b3:	89 de                	mov    %ebx,%esi
    16b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16bf:	90                   	nop
  write(fd, &c, 1);
    16c0:	83 ec 04             	sub    $0x4,%esp
          s++;
    16c3:	83 c6 01             	add    $0x1,%esi
    16c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    16c9:	6a 01                	push   $0x1
    16cb:	57                   	push   %edi
    16cc:	53                   	push   %ebx
    16cd:	e8 f1 fc ff ff       	call   13c3 <write>
        while(*s != 0){
    16d2:	0f b6 06             	movzbl (%esi),%eax
    16d5:	83 c4 10             	add    $0x10,%esp
    16d8:	84 c0                	test   %al,%al
    16da:	75 e4                	jne    16c0 <printf+0x1a0>
    16dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    16df:	31 d2                	xor    %edx,%edx
    16e1:	e9 8e fe ff ff       	jmp    1574 <printf+0x54>
    16e6:	66 90                	xchg   %ax,%ax
    16e8:	66 90                	xchg   %ax,%ax
    16ea:	66 90                	xchg   %ax,%ax
    16ec:	66 90                	xchg   %ax,%ax
    16ee:	66 90                	xchg   %ax,%ax

000016f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16f0:	f3 0f 1e fb          	endbr32 
    16f4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f5:	a1 ec 1d 00 00       	mov    0x1dec,%eax
{
    16fa:	89 e5                	mov    %esp,%ebp
    16fc:	57                   	push   %edi
    16fd:	56                   	push   %esi
    16fe:	53                   	push   %ebx
    16ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1702:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1704:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1707:	39 c8                	cmp    %ecx,%eax
    1709:	73 15                	jae    1720 <free+0x30>
    170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    170f:	90                   	nop
    1710:	39 d1                	cmp    %edx,%ecx
    1712:	72 14                	jb     1728 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1714:	39 d0                	cmp    %edx,%eax
    1716:	73 10                	jae    1728 <free+0x38>
{
    1718:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    171a:	8b 10                	mov    (%eax),%edx
    171c:	39 c8                	cmp    %ecx,%eax
    171e:	72 f0                	jb     1710 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1720:	39 d0                	cmp    %edx,%eax
    1722:	72 f4                	jb     1718 <free+0x28>
    1724:	39 d1                	cmp    %edx,%ecx
    1726:	73 f0                	jae    1718 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1728:	8b 73 fc             	mov    -0x4(%ebx),%esi
    172b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    172e:	39 fa                	cmp    %edi,%edx
    1730:	74 1e                	je     1750 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1732:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1735:	8b 50 04             	mov    0x4(%eax),%edx
    1738:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    173b:	39 f1                	cmp    %esi,%ecx
    173d:	74 28                	je     1767 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    173f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1741:	5b                   	pop    %ebx
  freep = p;
    1742:	a3 ec 1d 00 00       	mov    %eax,0x1dec
}
    1747:	5e                   	pop    %esi
    1748:	5f                   	pop    %edi
    1749:	5d                   	pop    %ebp
    174a:	c3                   	ret    
    174b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    174f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1750:	03 72 04             	add    0x4(%edx),%esi
    1753:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1756:	8b 10                	mov    (%eax),%edx
    1758:	8b 12                	mov    (%edx),%edx
    175a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    175d:	8b 50 04             	mov    0x4(%eax),%edx
    1760:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1763:	39 f1                	cmp    %esi,%ecx
    1765:	75 d8                	jne    173f <free+0x4f>
    p->s.size += bp->s.size;
    1767:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    176a:	a3 ec 1d 00 00       	mov    %eax,0x1dec
    p->s.size += bp->s.size;
    176f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1772:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1775:	89 10                	mov    %edx,(%eax)
}
    1777:	5b                   	pop    %ebx
    1778:	5e                   	pop    %esi
    1779:	5f                   	pop    %edi
    177a:	5d                   	pop    %ebp
    177b:	c3                   	ret    
    177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1780:	f3 0f 1e fb          	endbr32 
    1784:	55                   	push   %ebp
    1785:	89 e5                	mov    %esp,%ebp
    1787:	57                   	push   %edi
    1788:	56                   	push   %esi
    1789:	53                   	push   %ebx
    178a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    178d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1790:	8b 3d ec 1d 00 00    	mov    0x1dec,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1796:	8d 70 07             	lea    0x7(%eax),%esi
    1799:	c1 ee 03             	shr    $0x3,%esi
    179c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    179f:	85 ff                	test   %edi,%edi
    17a1:	0f 84 a9 00 00 00    	je     1850 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17a7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    17a9:	8b 48 04             	mov    0x4(%eax),%ecx
    17ac:	39 f1                	cmp    %esi,%ecx
    17ae:	73 6d                	jae    181d <malloc+0x9d>
    17b0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    17b6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    17bb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    17be:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    17c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    17c8:	eb 17                	jmp    17e1 <malloc+0x61>
    17ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    17d2:	8b 4a 04             	mov    0x4(%edx),%ecx
    17d5:	39 f1                	cmp    %esi,%ecx
    17d7:	73 4f                	jae    1828 <malloc+0xa8>
    17d9:	8b 3d ec 1d 00 00    	mov    0x1dec,%edi
    17df:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17e1:	39 c7                	cmp    %eax,%edi
    17e3:	75 eb                	jne    17d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    17e5:	83 ec 0c             	sub    $0xc,%esp
    17e8:	ff 75 e4             	pushl  -0x1c(%ebp)
    17eb:	e8 3b fc ff ff       	call   142b <sbrk>
  if(p == (char*)-1)
    17f0:	83 c4 10             	add    $0x10,%esp
    17f3:	83 f8 ff             	cmp    $0xffffffff,%eax
    17f6:	74 1b                	je     1813 <malloc+0x93>
  hp->s.size = nu;
    17f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17fb:	83 ec 0c             	sub    $0xc,%esp
    17fe:	83 c0 08             	add    $0x8,%eax
    1801:	50                   	push   %eax
    1802:	e8 e9 fe ff ff       	call   16f0 <free>
  return freep;
    1807:	a1 ec 1d 00 00       	mov    0x1dec,%eax
      if((p = morecore(nunits)) == 0)
    180c:	83 c4 10             	add    $0x10,%esp
    180f:	85 c0                	test   %eax,%eax
    1811:	75 bd                	jne    17d0 <malloc+0x50>
        return 0;
  }
}
    1813:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1816:	31 c0                	xor    %eax,%eax
}
    1818:	5b                   	pop    %ebx
    1819:	5e                   	pop    %esi
    181a:	5f                   	pop    %edi
    181b:	5d                   	pop    %ebp
    181c:	c3                   	ret    
    if(p->s.size >= nunits){
    181d:	89 c2                	mov    %eax,%edx
    181f:	89 f8                	mov    %edi,%eax
    1821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1828:	39 ce                	cmp    %ecx,%esi
    182a:	74 54                	je     1880 <malloc+0x100>
        p->s.size -= nunits;
    182c:	29 f1                	sub    %esi,%ecx
    182e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1831:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1834:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1837:	a3 ec 1d 00 00       	mov    %eax,0x1dec
}
    183c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    183f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1842:	5b                   	pop    %ebx
    1843:	5e                   	pop    %esi
    1844:	5f                   	pop    %edi
    1845:	5d                   	pop    %ebp
    1846:	c3                   	ret    
    1847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    184e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1850:	c7 05 ec 1d 00 00 f0 	movl   $0x1df0,0x1dec
    1857:	1d 00 00 
    base.s.size = 0;
    185a:	bf f0 1d 00 00       	mov    $0x1df0,%edi
    base.s.ptr = freep = prevp = &base;
    185f:	c7 05 f0 1d 00 00 f0 	movl   $0x1df0,0x1df0
    1866:	1d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1869:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    186b:	c7 05 f4 1d 00 00 00 	movl   $0x0,0x1df4
    1872:	00 00 00 
    if(p->s.size >= nunits){
    1875:	e9 36 ff ff ff       	jmp    17b0 <malloc+0x30>
    187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1880:	8b 0a                	mov    (%edx),%ecx
    1882:	89 08                	mov    %ecx,(%eax)
    1884:	eb b1                	jmp    1837 <malloc+0xb7>
