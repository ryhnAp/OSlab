
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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
    1014:	83 ec 0c             	sub    $0xc,%esp
    1017:	8b 01                	mov    (%ecx),%eax
    1019:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
    101c:	83 f8 01             	cmp    $0x1,%eax
    101f:	7e 30                	jle    1051 <main+0x51>
    1021:	8d 5a 04             	lea    0x4(%edx),%ebx
    1024:	8d 34 82             	lea    (%edx,%eax,4),%esi
    1027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    102e:	66 90                	xchg   %ax,%ax
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	ff 33                	pushl  (%ebx)
    1035:	83 c3 04             	add    $0x4,%ebx
    1038:	e8 23 02 00 00       	call   1260 <atoi>
    103d:	89 04 24             	mov    %eax,(%esp)
    1040:	e8 be 02 00 00       	call   1303 <kill>
  for(i=1; i<argc; i++)
    1045:	83 c4 10             	add    $0x10,%esp
    1048:	39 f3                	cmp    %esi,%ebx
    104a:	75 e4                	jne    1030 <main+0x30>
  exit();
    104c:	e8 82 02 00 00       	call   12d3 <exit>
    printf(2, "usage: kill pid...\n");
    1051:	50                   	push   %eax
    1052:	50                   	push   %eax
    1053:	68 b8 17 00 00       	push   $0x17b8
    1058:	6a 02                	push   $0x2
    105a:	e8 f1 03 00 00       	call   1450 <printf>
    exit();
    105f:	e8 6f 02 00 00       	call   12d3 <exit>
    1064:	66 90                	xchg   %ax,%ax
    1066:	66 90                	xchg   %ax,%ax
    1068:	66 90                	xchg   %ax,%ax
    106a:	66 90                	xchg   %ax,%ax
    106c:	66 90                	xchg   %ax,%ax
    106e:	66 90                	xchg   %ax,%ax

00001070 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    1070:	f3 0f 1e fb          	endbr32 
    1074:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1075:	31 c0                	xor    %eax,%eax
{
    1077:	89 e5                	mov    %esp,%ebp
    1079:	53                   	push   %ebx
    107a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    107d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1080:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1084:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1087:	83 c0 01             	add    $0x1,%eax
    108a:	84 d2                	test   %dl,%dl
    108c:	75 f2                	jne    1080 <strcpy+0x10>
    ;
  return os;
}
    108e:	89 c8                	mov    %ecx,%eax
    1090:	5b                   	pop    %ebx
    1091:	5d                   	pop    %ebp
    1092:	c3                   	ret    
    1093:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000010a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10a0:	f3 0f 1e fb          	endbr32 
    10a4:	55                   	push   %ebp
    10a5:	89 e5                	mov    %esp,%ebp
    10a7:	53                   	push   %ebx
    10a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    10ae:	0f b6 01             	movzbl (%ecx),%eax
    10b1:	0f b6 1a             	movzbl (%edx),%ebx
    10b4:	84 c0                	test   %al,%al
    10b6:	75 19                	jne    10d1 <strcmp+0x31>
    10b8:	eb 26                	jmp    10e0 <strcmp+0x40>
    10ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10c0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    10c4:	83 c1 01             	add    $0x1,%ecx
    10c7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10ca:	0f b6 1a             	movzbl (%edx),%ebx
    10cd:	84 c0                	test   %al,%al
    10cf:	74 0f                	je     10e0 <strcmp+0x40>
    10d1:	38 d8                	cmp    %bl,%al
    10d3:	74 eb                	je     10c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    10d5:	29 d8                	sub    %ebx,%eax
}
    10d7:	5b                   	pop    %ebx
    10d8:	5d                   	pop    %ebp
    10d9:	c3                   	ret    
    10da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    10e2:	29 d8                	sub    %ebx,%eax
}
    10e4:	5b                   	pop    %ebx
    10e5:	5d                   	pop    %ebp
    10e6:	c3                   	ret    
    10e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10ee:	66 90                	xchg   %ax,%ax

000010f0 <strlen>:

uint
strlen(const char *s)
{
    10f0:	f3 0f 1e fb          	endbr32 
    10f4:	55                   	push   %ebp
    10f5:	89 e5                	mov    %esp,%ebp
    10f7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    10fa:	80 3a 00             	cmpb   $0x0,(%edx)
    10fd:	74 21                	je     1120 <strlen+0x30>
    10ff:	31 c0                	xor    %eax,%eax
    1101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1108:	83 c0 01             	add    $0x1,%eax
    110b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    110f:	89 c1                	mov    %eax,%ecx
    1111:	75 f5                	jne    1108 <strlen+0x18>
    ;
  return n;
}
    1113:	89 c8                	mov    %ecx,%eax
    1115:	5d                   	pop    %ebp
    1116:	c3                   	ret    
    1117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    111e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    1120:	31 c9                	xor    %ecx,%ecx
}
    1122:	5d                   	pop    %ebp
    1123:	89 c8                	mov    %ecx,%eax
    1125:	c3                   	ret    
    1126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    112d:	8d 76 00             	lea    0x0(%esi),%esi

00001130 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1130:	f3 0f 1e fb          	endbr32 
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	57                   	push   %edi
    1138:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    113b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    113e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1141:	89 d7                	mov    %edx,%edi
    1143:	fc                   	cld    
    1144:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1146:	89 d0                	mov    %edx,%eax
    1148:	5f                   	pop    %edi
    1149:	5d                   	pop    %ebp
    114a:	c3                   	ret    
    114b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    114f:	90                   	nop

00001150 <strchr>:

char*
strchr(const char *s, char c)
{
    1150:	f3 0f 1e fb          	endbr32 
    1154:	55                   	push   %ebp
    1155:	89 e5                	mov    %esp,%ebp
    1157:	8b 45 08             	mov    0x8(%ebp),%eax
    115a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    115e:	0f b6 10             	movzbl (%eax),%edx
    1161:	84 d2                	test   %dl,%dl
    1163:	75 16                	jne    117b <strchr+0x2b>
    1165:	eb 21                	jmp    1188 <strchr+0x38>
    1167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    116e:	66 90                	xchg   %ax,%ax
    1170:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1174:	83 c0 01             	add    $0x1,%eax
    1177:	84 d2                	test   %dl,%dl
    1179:	74 0d                	je     1188 <strchr+0x38>
    if(*s == c)
    117b:	38 d1                	cmp    %dl,%cl
    117d:	75 f1                	jne    1170 <strchr+0x20>
      return (char*)s;
  return 0;
}
    117f:	5d                   	pop    %ebp
    1180:	c3                   	ret    
    1181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1188:	31 c0                	xor    %eax,%eax
}
    118a:	5d                   	pop    %ebp
    118b:	c3                   	ret    
    118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001190 <gets>:

char*
gets(char *buf, int max)
{
    1190:	f3 0f 1e fb          	endbr32 
    1194:	55                   	push   %ebp
    1195:	89 e5                	mov    %esp,%ebp
    1197:	57                   	push   %edi
    1198:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1199:	31 f6                	xor    %esi,%esi
{
    119b:	53                   	push   %ebx
    119c:	89 f3                	mov    %esi,%ebx
    119e:	83 ec 1c             	sub    $0x1c,%esp
    11a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    11a4:	eb 33                	jmp    11d9 <gets+0x49>
    11a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ad:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    11b0:	83 ec 04             	sub    $0x4,%esp
    11b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
    11b6:	6a 01                	push   $0x1
    11b8:	50                   	push   %eax
    11b9:	6a 00                	push   $0x0
    11bb:	e8 2b 01 00 00       	call   12eb <read>
    if(cc < 1)
    11c0:	83 c4 10             	add    $0x10,%esp
    11c3:	85 c0                	test   %eax,%eax
    11c5:	7e 1c                	jle    11e3 <gets+0x53>
      break;
    buf[i++] = c;
    11c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11cb:	83 c7 01             	add    $0x1,%edi
    11ce:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    11d1:	3c 0a                	cmp    $0xa,%al
    11d3:	74 23                	je     11f8 <gets+0x68>
    11d5:	3c 0d                	cmp    $0xd,%al
    11d7:	74 1f                	je     11f8 <gets+0x68>
  for(i=0; i+1 < max; ){
    11d9:	83 c3 01             	add    $0x1,%ebx
    11dc:	89 fe                	mov    %edi,%esi
    11de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11e1:	7c cd                	jl     11b0 <gets+0x20>
    11e3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    11e5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    11e8:	c6 03 00             	movb   $0x0,(%ebx)
}
    11eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11ee:	5b                   	pop    %ebx
    11ef:	5e                   	pop    %esi
    11f0:	5f                   	pop    %edi
    11f1:	5d                   	pop    %ebp
    11f2:	c3                   	ret    
    11f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11f7:	90                   	nop
    11f8:	8b 75 08             	mov    0x8(%ebp),%esi
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	01 de                	add    %ebx,%esi
    1200:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    1202:	c6 03 00             	movb   $0x0,(%ebx)
}
    1205:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1208:	5b                   	pop    %ebx
    1209:	5e                   	pop    %esi
    120a:	5f                   	pop    %edi
    120b:	5d                   	pop    %ebp
    120c:	c3                   	ret    
    120d:	8d 76 00             	lea    0x0(%esi),%esi

00001210 <stat>:

int
stat(const char *n, struct stat *st)
{
    1210:	f3 0f 1e fb          	endbr32 
    1214:	55                   	push   %ebp
    1215:	89 e5                	mov    %esp,%ebp
    1217:	56                   	push   %esi
    1218:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1219:	83 ec 08             	sub    $0x8,%esp
    121c:	6a 00                	push   $0x0
    121e:	ff 75 08             	pushl  0x8(%ebp)
    1221:	e8 ed 00 00 00       	call   1313 <open>
  if(fd < 0)
    1226:	83 c4 10             	add    $0x10,%esp
    1229:	85 c0                	test   %eax,%eax
    122b:	78 2b                	js     1258 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    122d:	83 ec 08             	sub    $0x8,%esp
    1230:	ff 75 0c             	pushl  0xc(%ebp)
    1233:	89 c3                	mov    %eax,%ebx
    1235:	50                   	push   %eax
    1236:	e8 f0 00 00 00       	call   132b <fstat>
  close(fd);
    123b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    123e:	89 c6                	mov    %eax,%esi
  close(fd);
    1240:	e8 b6 00 00 00       	call   12fb <close>
  return r;
    1245:	83 c4 10             	add    $0x10,%esp
}
    1248:	8d 65 f8             	lea    -0x8(%ebp),%esp
    124b:	89 f0                	mov    %esi,%eax
    124d:	5b                   	pop    %ebx
    124e:	5e                   	pop    %esi
    124f:	5d                   	pop    %ebp
    1250:	c3                   	ret    
    1251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1258:	be ff ff ff ff       	mov    $0xffffffff,%esi
    125d:	eb e9                	jmp    1248 <stat+0x38>
    125f:	90                   	nop

00001260 <atoi>:

int
atoi(const char *s)
{
    1260:	f3 0f 1e fb          	endbr32 
    1264:	55                   	push   %ebp
    1265:	89 e5                	mov    %esp,%ebp
    1267:	53                   	push   %ebx
    1268:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126b:	0f be 02             	movsbl (%edx),%eax
    126e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1271:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1274:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1279:	77 1a                	ja     1295 <atoi+0x35>
    127b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    127f:	90                   	nop
    n = n*10 + *s++ - '0';
    1280:	83 c2 01             	add    $0x1,%edx
    1283:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1286:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    128a:	0f be 02             	movsbl (%edx),%eax
    128d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1290:	80 fb 09             	cmp    $0x9,%bl
    1293:	76 eb                	jbe    1280 <atoi+0x20>
  return n;
}
    1295:	89 c8                	mov    %ecx,%eax
    1297:	5b                   	pop    %ebx
    1298:	5d                   	pop    %ebp
    1299:	c3                   	ret    
    129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000012a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12a0:	f3 0f 1e fb          	endbr32 
    12a4:	55                   	push   %ebp
    12a5:	89 e5                	mov    %esp,%ebp
    12a7:	57                   	push   %edi
    12a8:	8b 45 10             	mov    0x10(%ebp),%eax
    12ab:	8b 55 08             	mov    0x8(%ebp),%edx
    12ae:	56                   	push   %esi
    12af:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12b2:	85 c0                	test   %eax,%eax
    12b4:	7e 0f                	jle    12c5 <memmove+0x25>
    12b6:	01 d0                	add    %edx,%eax
  dst = vdst;
    12b8:	89 d7                	mov    %edx,%edi
    12ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    12c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    12c1:	39 f8                	cmp    %edi,%eax
    12c3:	75 fb                	jne    12c0 <memmove+0x20>
  return vdst;
}
    12c5:	5e                   	pop    %esi
    12c6:	89 d0                	mov    %edx,%eax
    12c8:	5f                   	pop    %edi
    12c9:	5d                   	pop    %ebp
    12ca:	c3                   	ret    

000012cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12cb:	b8 01 00 00 00       	mov    $0x1,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <exit>:
SYSCALL(exit)
    12d3:	b8 02 00 00 00       	mov    $0x2,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <wait>:
SYSCALL(wait)
    12db:	b8 03 00 00 00       	mov    $0x3,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <pipe>:
SYSCALL(pipe)
    12e3:	b8 04 00 00 00       	mov    $0x4,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <read>:
SYSCALL(read)
    12eb:	b8 05 00 00 00       	mov    $0x5,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <write>:
SYSCALL(write)
    12f3:	b8 10 00 00 00       	mov    $0x10,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <close>:
SYSCALL(close)
    12fb:	b8 15 00 00 00       	mov    $0x15,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <kill>:
SYSCALL(kill)
    1303:	b8 06 00 00 00       	mov    $0x6,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <exec>:
SYSCALL(exec)
    130b:	b8 07 00 00 00       	mov    $0x7,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <open>:
SYSCALL(open)
    1313:	b8 0f 00 00 00       	mov    $0xf,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <mknod>:
SYSCALL(mknod)
    131b:	b8 11 00 00 00       	mov    $0x11,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <unlink>:
SYSCALL(unlink)
    1323:	b8 12 00 00 00       	mov    $0x12,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <fstat>:
SYSCALL(fstat)
    132b:	b8 08 00 00 00       	mov    $0x8,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <link>:
SYSCALL(link)
    1333:	b8 13 00 00 00       	mov    $0x13,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <mkdir>:
SYSCALL(mkdir)
    133b:	b8 14 00 00 00       	mov    $0x14,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <chdir>:
SYSCALL(chdir)
    1343:	b8 09 00 00 00       	mov    $0x9,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <dup>:
SYSCALL(dup)
    134b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <getpid>:
SYSCALL(getpid)
    1353:	b8 0b 00 00 00       	mov    $0xb,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <sbrk>:
SYSCALL(sbrk)
    135b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <sleep>:
SYSCALL(sleep)
    1363:	b8 0d 00 00 00       	mov    $0xd,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <uptime>:
SYSCALL(uptime)
    136b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <provide_protection>:
SYSCALL(provide_protection)
    1373:	b8 18 00 00 00       	mov    $0x18,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <refuse_protection>:
SYSCALL(refuse_protection)
    137b:	b8 19 00 00 00       	mov    $0x19,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <settickets>:
SYSCALL(settickets) 
    1383:	b8 16 00 00 00       	mov    $0x16,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <getpinfo>:
    138b:	b8 17 00 00 00       	mov    $0x17,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    
    1393:	66 90                	xchg   %ax,%ax
    1395:	66 90                	xchg   %ax,%ax
    1397:	66 90                	xchg   %ax,%ax
    1399:	66 90                	xchg   %ax,%ax
    139b:	66 90                	xchg   %ax,%ax
    139d:	66 90                	xchg   %ax,%ax
    139f:	90                   	nop

000013a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    13a0:	55                   	push   %ebp
    13a1:	89 e5                	mov    %esp,%ebp
    13a3:	57                   	push   %edi
    13a4:	56                   	push   %esi
    13a5:	53                   	push   %ebx
    13a6:	83 ec 3c             	sub    $0x3c,%esp
    13a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    13ac:	89 d1                	mov    %edx,%ecx
{
    13ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    13b1:	85 d2                	test   %edx,%edx
    13b3:	0f 89 7f 00 00 00    	jns    1438 <printint+0x98>
    13b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    13bd:	74 79                	je     1438 <printint+0x98>
    neg = 1;
    13bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    13c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    13c8:	31 db                	xor    %ebx,%ebx
    13ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
    13cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    13d0:	89 c8                	mov    %ecx,%eax
    13d2:	31 d2                	xor    %edx,%edx
    13d4:	89 cf                	mov    %ecx,%edi
    13d6:	f7 75 c4             	divl   -0x3c(%ebp)
    13d9:	0f b6 92 d4 17 00 00 	movzbl 0x17d4(%edx),%edx
    13e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    13e3:	89 d8                	mov    %ebx,%eax
    13e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    13e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    13eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    13ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    13f1:	76 dd                	jbe    13d0 <printint+0x30>
  if(neg)
    13f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    13f6:	85 c9                	test   %ecx,%ecx
    13f8:	74 0c                	je     1406 <printint+0x66>
    buf[i++] = '-';
    13fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    13ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1401:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1406:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1409:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    140d:	eb 07                	jmp    1416 <printint+0x76>
    140f:	90                   	nop
    1410:	0f b6 13             	movzbl (%ebx),%edx
    1413:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1416:	83 ec 04             	sub    $0x4,%esp
    1419:	88 55 d7             	mov    %dl,-0x29(%ebp)
    141c:	6a 01                	push   $0x1
    141e:	56                   	push   %esi
    141f:	57                   	push   %edi
    1420:	e8 ce fe ff ff       	call   12f3 <write>
  while(--i >= 0)
    1425:	83 c4 10             	add    $0x10,%esp
    1428:	39 de                	cmp    %ebx,%esi
    142a:	75 e4                	jne    1410 <printint+0x70>
    putc(fd, buf[i]);
}
    142c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    142f:	5b                   	pop    %ebx
    1430:	5e                   	pop    %esi
    1431:	5f                   	pop    %edi
    1432:	5d                   	pop    %ebp
    1433:	c3                   	ret    
    1434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1438:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    143f:	eb 87                	jmp    13c8 <printint+0x28>
    1441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    144f:	90                   	nop

00001450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1450:	f3 0f 1e fb          	endbr32 
    1454:	55                   	push   %ebp
    1455:	89 e5                	mov    %esp,%ebp
    1457:	57                   	push   %edi
    1458:	56                   	push   %esi
    1459:	53                   	push   %ebx
    145a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    145d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1460:	0f b6 1e             	movzbl (%esi),%ebx
    1463:	84 db                	test   %bl,%bl
    1465:	0f 84 b4 00 00 00    	je     151f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    146b:	8d 45 10             	lea    0x10(%ebp),%eax
    146e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1471:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1474:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1476:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1479:	eb 33                	jmp    14ae <printf+0x5e>
    147b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    147f:	90                   	nop
    1480:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1483:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1488:	83 f8 25             	cmp    $0x25,%eax
    148b:	74 17                	je     14a4 <printf+0x54>
  write(fd, &c, 1);
    148d:	83 ec 04             	sub    $0x4,%esp
    1490:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1493:	6a 01                	push   $0x1
    1495:	57                   	push   %edi
    1496:	ff 75 08             	pushl  0x8(%ebp)
    1499:	e8 55 fe ff ff       	call   12f3 <write>
    149e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    14a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    14a4:	0f b6 1e             	movzbl (%esi),%ebx
    14a7:	83 c6 01             	add    $0x1,%esi
    14aa:	84 db                	test   %bl,%bl
    14ac:	74 71                	je     151f <printf+0xcf>
    c = fmt[i] & 0xff;
    14ae:	0f be cb             	movsbl %bl,%ecx
    14b1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    14b4:	85 d2                	test   %edx,%edx
    14b6:	74 c8                	je     1480 <printf+0x30>
      }
    } else if(state == '%'){
    14b8:	83 fa 25             	cmp    $0x25,%edx
    14bb:	75 e7                	jne    14a4 <printf+0x54>
      if(c == 'd'){
    14bd:	83 f8 64             	cmp    $0x64,%eax
    14c0:	0f 84 9a 00 00 00    	je     1560 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    14c6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    14cc:	83 f9 70             	cmp    $0x70,%ecx
    14cf:	74 5f                	je     1530 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14d1:	83 f8 73             	cmp    $0x73,%eax
    14d4:	0f 84 d6 00 00 00    	je     15b0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14da:	83 f8 63             	cmp    $0x63,%eax
    14dd:	0f 84 8d 00 00 00    	je     1570 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    14e3:	83 f8 25             	cmp    $0x25,%eax
    14e6:	0f 84 b4 00 00 00    	je     15a0 <printf+0x150>
  write(fd, &c, 1);
    14ec:	83 ec 04             	sub    $0x4,%esp
    14ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    14f3:	6a 01                	push   $0x1
    14f5:	57                   	push   %edi
    14f6:	ff 75 08             	pushl  0x8(%ebp)
    14f9:	e8 f5 fd ff ff       	call   12f3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    14fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1501:	83 c4 0c             	add    $0xc,%esp
    1504:	6a 01                	push   $0x1
    1506:	83 c6 01             	add    $0x1,%esi
    1509:	57                   	push   %edi
    150a:	ff 75 08             	pushl  0x8(%ebp)
    150d:	e8 e1 fd ff ff       	call   12f3 <write>
  for(i = 0; fmt[i]; i++){
    1512:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1516:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1519:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    151b:	84 db                	test   %bl,%bl
    151d:	75 8f                	jne    14ae <printf+0x5e>
    }
  }
}
    151f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1522:	5b                   	pop    %ebx
    1523:	5e                   	pop    %esi
    1524:	5f                   	pop    %edi
    1525:	5d                   	pop    %ebp
    1526:	c3                   	ret    
    1527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    152e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1530:	83 ec 0c             	sub    $0xc,%esp
    1533:	b9 10 00 00 00       	mov    $0x10,%ecx
    1538:	6a 00                	push   $0x0
    153a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    153d:	8b 45 08             	mov    0x8(%ebp),%eax
    1540:	8b 13                	mov    (%ebx),%edx
    1542:	e8 59 fe ff ff       	call   13a0 <printint>
        ap++;
    1547:	89 d8                	mov    %ebx,%eax
    1549:	83 c4 10             	add    $0x10,%esp
      state = 0;
    154c:	31 d2                	xor    %edx,%edx
        ap++;
    154e:	83 c0 04             	add    $0x4,%eax
    1551:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1554:	e9 4b ff ff ff       	jmp    14a4 <printf+0x54>
    1559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1560:	83 ec 0c             	sub    $0xc,%esp
    1563:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1568:	6a 01                	push   $0x1
    156a:	eb ce                	jmp    153a <printf+0xea>
    156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1570:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1573:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1576:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1578:	6a 01                	push   $0x1
        ap++;
    157a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    157d:	57                   	push   %edi
    157e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1581:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1584:	e8 6a fd ff ff       	call   12f3 <write>
        ap++;
    1589:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    158c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    158f:	31 d2                	xor    %edx,%edx
    1591:	e9 0e ff ff ff       	jmp    14a4 <printf+0x54>
    1596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    159d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    15a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    15a3:	83 ec 04             	sub    $0x4,%esp
    15a6:	e9 59 ff ff ff       	jmp    1504 <printf+0xb4>
    15ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    15af:	90                   	nop
        s = (char*)*ap;
    15b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    15b3:	8b 18                	mov    (%eax),%ebx
        ap++;
    15b5:	83 c0 04             	add    $0x4,%eax
    15b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    15bb:	85 db                	test   %ebx,%ebx
    15bd:	74 17                	je     15d6 <printf+0x186>
        while(*s != 0){
    15bf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    15c2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    15c4:	84 c0                	test   %al,%al
    15c6:	0f 84 d8 fe ff ff    	je     14a4 <printf+0x54>
    15cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    15cf:	89 de                	mov    %ebx,%esi
    15d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    15d4:	eb 1a                	jmp    15f0 <printf+0x1a0>
          s = "(null)";
    15d6:	bb cc 17 00 00       	mov    $0x17cc,%ebx
        while(*s != 0){
    15db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    15de:	b8 28 00 00 00       	mov    $0x28,%eax
    15e3:	89 de                	mov    %ebx,%esi
    15e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    15e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15ef:	90                   	nop
  write(fd, &c, 1);
    15f0:	83 ec 04             	sub    $0x4,%esp
          s++;
    15f3:	83 c6 01             	add    $0x1,%esi
    15f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    15f9:	6a 01                	push   $0x1
    15fb:	57                   	push   %edi
    15fc:	53                   	push   %ebx
    15fd:	e8 f1 fc ff ff       	call   12f3 <write>
        while(*s != 0){
    1602:	0f b6 06             	movzbl (%esi),%eax
    1605:	83 c4 10             	add    $0x10,%esp
    1608:	84 c0                	test   %al,%al
    160a:	75 e4                	jne    15f0 <printf+0x1a0>
    160c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    160f:	31 d2                	xor    %edx,%edx
    1611:	e9 8e fe ff ff       	jmp    14a4 <printf+0x54>
    1616:	66 90                	xchg   %ax,%ax
    1618:	66 90                	xchg   %ax,%ax
    161a:	66 90                	xchg   %ax,%ax
    161c:	66 90                	xchg   %ax,%ax
    161e:	66 90                	xchg   %ax,%ax

00001620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1620:	f3 0f 1e fb          	endbr32 
    1624:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1625:	a1 84 1a 00 00       	mov    0x1a84,%eax
{
    162a:	89 e5                	mov    %esp,%ebp
    162c:	57                   	push   %edi
    162d:	56                   	push   %esi
    162e:	53                   	push   %ebx
    162f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1632:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1634:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1637:	39 c8                	cmp    %ecx,%eax
    1639:	73 15                	jae    1650 <free+0x30>
    163b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    163f:	90                   	nop
    1640:	39 d1                	cmp    %edx,%ecx
    1642:	72 14                	jb     1658 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1644:	39 d0                	cmp    %edx,%eax
    1646:	73 10                	jae    1658 <free+0x38>
{
    1648:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    164a:	8b 10                	mov    (%eax),%edx
    164c:	39 c8                	cmp    %ecx,%eax
    164e:	72 f0                	jb     1640 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1650:	39 d0                	cmp    %edx,%eax
    1652:	72 f4                	jb     1648 <free+0x28>
    1654:	39 d1                	cmp    %edx,%ecx
    1656:	73 f0                	jae    1648 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1658:	8b 73 fc             	mov    -0x4(%ebx),%esi
    165b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    165e:	39 fa                	cmp    %edi,%edx
    1660:	74 1e                	je     1680 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1662:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1665:	8b 50 04             	mov    0x4(%eax),%edx
    1668:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    166b:	39 f1                	cmp    %esi,%ecx
    166d:	74 28                	je     1697 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    166f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1671:	5b                   	pop    %ebx
  freep = p;
    1672:	a3 84 1a 00 00       	mov    %eax,0x1a84
}
    1677:	5e                   	pop    %esi
    1678:	5f                   	pop    %edi
    1679:	5d                   	pop    %ebp
    167a:	c3                   	ret    
    167b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    167f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1680:	03 72 04             	add    0x4(%edx),%esi
    1683:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1686:	8b 10                	mov    (%eax),%edx
    1688:	8b 12                	mov    (%edx),%edx
    168a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    168d:	8b 50 04             	mov    0x4(%eax),%edx
    1690:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1693:	39 f1                	cmp    %esi,%ecx
    1695:	75 d8                	jne    166f <free+0x4f>
    p->s.size += bp->s.size;
    1697:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    169a:	a3 84 1a 00 00       	mov    %eax,0x1a84
    p->s.size += bp->s.size;
    169f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    16a5:	89 10                	mov    %edx,(%eax)
}
    16a7:	5b                   	pop    %ebx
    16a8:	5e                   	pop    %esi
    16a9:	5f                   	pop    %edi
    16aa:	5d                   	pop    %ebp
    16ab:	c3                   	ret    
    16ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000016b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16b0:	f3 0f 1e fb          	endbr32 
    16b4:	55                   	push   %ebp
    16b5:	89 e5                	mov    %esp,%ebp
    16b7:	57                   	push   %edi
    16b8:	56                   	push   %esi
    16b9:	53                   	push   %ebx
    16ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    16c0:	8b 3d 84 1a 00 00    	mov    0x1a84,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16c6:	8d 70 07             	lea    0x7(%eax),%esi
    16c9:	c1 ee 03             	shr    $0x3,%esi
    16cc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    16cf:	85 ff                	test   %edi,%edi
    16d1:	0f 84 a9 00 00 00    	je     1780 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16d7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    16d9:	8b 48 04             	mov    0x4(%eax),%ecx
    16dc:	39 f1                	cmp    %esi,%ecx
    16de:	73 6d                	jae    174d <malloc+0x9d>
    16e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    16e6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    16eb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    16ee:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    16f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    16f8:	eb 17                	jmp    1711 <malloc+0x61>
    16fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1700:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1702:	8b 4a 04             	mov    0x4(%edx),%ecx
    1705:	39 f1                	cmp    %esi,%ecx
    1707:	73 4f                	jae    1758 <malloc+0xa8>
    1709:	8b 3d 84 1a 00 00    	mov    0x1a84,%edi
    170f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1711:	39 c7                	cmp    %eax,%edi
    1713:	75 eb                	jne    1700 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1715:	83 ec 0c             	sub    $0xc,%esp
    1718:	ff 75 e4             	pushl  -0x1c(%ebp)
    171b:	e8 3b fc ff ff       	call   135b <sbrk>
  if(p == (char*)-1)
    1720:	83 c4 10             	add    $0x10,%esp
    1723:	83 f8 ff             	cmp    $0xffffffff,%eax
    1726:	74 1b                	je     1743 <malloc+0x93>
  hp->s.size = nu;
    1728:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    172b:	83 ec 0c             	sub    $0xc,%esp
    172e:	83 c0 08             	add    $0x8,%eax
    1731:	50                   	push   %eax
    1732:	e8 e9 fe ff ff       	call   1620 <free>
  return freep;
    1737:	a1 84 1a 00 00       	mov    0x1a84,%eax
      if((p = morecore(nunits)) == 0)
    173c:	83 c4 10             	add    $0x10,%esp
    173f:	85 c0                	test   %eax,%eax
    1741:	75 bd                	jne    1700 <malloc+0x50>
        return 0;
  }
}
    1743:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1746:	31 c0                	xor    %eax,%eax
}
    1748:	5b                   	pop    %ebx
    1749:	5e                   	pop    %esi
    174a:	5f                   	pop    %edi
    174b:	5d                   	pop    %ebp
    174c:	c3                   	ret    
    if(p->s.size >= nunits){
    174d:	89 c2                	mov    %eax,%edx
    174f:	89 f8                	mov    %edi,%eax
    1751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1758:	39 ce                	cmp    %ecx,%esi
    175a:	74 54                	je     17b0 <malloc+0x100>
        p->s.size -= nunits;
    175c:	29 f1                	sub    %esi,%ecx
    175e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1761:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1764:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1767:	a3 84 1a 00 00       	mov    %eax,0x1a84
}
    176c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    176f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1772:	5b                   	pop    %ebx
    1773:	5e                   	pop    %esi
    1774:	5f                   	pop    %edi
    1775:	5d                   	pop    %ebp
    1776:	c3                   	ret    
    1777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    177e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1780:	c7 05 84 1a 00 00 88 	movl   $0x1a88,0x1a84
    1787:	1a 00 00 
    base.s.size = 0;
    178a:	bf 88 1a 00 00       	mov    $0x1a88,%edi
    base.s.ptr = freep = prevp = &base;
    178f:	c7 05 88 1a 00 00 88 	movl   $0x1a88,0x1a88
    1796:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1799:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    179b:	c7 05 8c 1a 00 00 00 	movl   $0x0,0x1a8c
    17a2:	00 00 00 
    if(p->s.size >= nunits){
    17a5:	e9 36 ff ff ff       	jmp    16e0 <malloc+0x30>
    17aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    17b0:	8b 0a                	mov    (%edx),%ecx
    17b2:	89 08                	mov    %ecx,(%eax)
    17b4:	eb b1                	jmp    1767 <malloc+0xb7>
