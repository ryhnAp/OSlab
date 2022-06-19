
_init:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	f3 0f 1e fb          	endbr32 
    1004:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1008:	83 e4 f0             	and    $0xfffffff0,%esp
    100b:	ff 71 fc             	pushl  -0x4(%ecx)
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	53                   	push   %ebx
    1012:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    1013:	83 ec 08             	sub    $0x8,%esp
    1016:	6a 02                	push   $0x2
    1018:	68 78 18 00 00       	push   $0x1878
    101d:	e8 b1 03 00 00       	call   13d3 <open>
    1022:	83 c4 10             	add    $0x10,%esp
    1025:	85 c0                	test   %eax,%eax
    1027:	0f 88 db 00 00 00    	js     1108 <main+0x108>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
    102d:	83 ec 0c             	sub    $0xc,%esp
    1030:	6a 00                	push   $0x0
    1032:	e8 d4 03 00 00       	call   140b <dup>
  dup(0);  // stderr
    1037:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    103e:	e8 c8 03 00 00       	call   140b <dup>
    1043:	83 c4 10             	add    $0x10,%esp
    1046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    104d:	8d 76 00             	lea    0x0(%esi),%esi

  for(;;){

    printf(1, "init: starting sh\n");
    1050:	83 ec 08             	sub    $0x8,%esp
    1053:	68 80 18 00 00       	push   $0x1880
    1058:	6a 01                	push   $0x1
    105a:	e8 b1 04 00 00       	call   1510 <printf>
    printf(1, "Group #5:\n");
    105f:	58                   	pop    %eax
    1060:	5a                   	pop    %edx
    1061:	68 93 18 00 00       	push   $0x1893
    1066:	6a 01                	push   $0x1
    1068:	e8 a3 04 00 00       	call   1510 <printf>
    printf(1, "1. Anahita Moshtagh\n");
    106d:	59                   	pop    %ecx
    106e:	5b                   	pop    %ebx
    106f:	68 9e 18 00 00       	push   $0x189e
    1074:	6a 01                	push   $0x1
    1076:	e8 95 04 00 00       	call   1510 <printf>
    printf(1, "2. Mona MohadesMojtahedi\n");
    107b:	58                   	pop    %eax
    107c:	5a                   	pop    %edx
    107d:	68 b3 18 00 00       	push   $0x18b3
    1082:	6a 01                	push   $0x1
    1084:	e8 87 04 00 00       	call   1510 <printf>
    printf(1, "3. Reyhane Ahmadpoor\n");
    1089:	59                   	pop    %ecx
    108a:	5b                   	pop    %ebx
    108b:	68 cd 18 00 00       	push   $0x18cd
    1090:	6a 01                	push   $0x1
    1092:	e8 79 04 00 00       	call   1510 <printf>

    pid = fork();
    1097:	e8 ef 02 00 00       	call   138b <fork>
    if(pid < 0){
    109c:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    109f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    10a1:	85 c0                	test   %eax,%eax
    10a3:	78 2c                	js     10d1 <main+0xd1>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
    10a5:	74 3d                	je     10e4 <main+0xe4>
    10a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10ae:	66 90                	xchg   %ax,%ax
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10b0:	e8 e6 02 00 00       	call   139b <wait>
    10b5:	85 c0                	test   %eax,%eax
    10b7:	78 97                	js     1050 <main+0x50>
    10b9:	39 c3                	cmp    %eax,%ebx
    10bb:	74 93                	je     1050 <main+0x50>
      printf(1, "zombie!\n");
    10bd:	83 ec 08             	sub    $0x8,%esp
    10c0:	68 0f 19 00 00       	push   $0x190f
    10c5:	6a 01                	push   $0x1
    10c7:	e8 44 04 00 00       	call   1510 <printf>
    10cc:	83 c4 10             	add    $0x10,%esp
    10cf:	eb df                	jmp    10b0 <main+0xb0>
      printf(1, "init: fork failed\n");
    10d1:	53                   	push   %ebx
    10d2:	53                   	push   %ebx
    10d3:	68 e3 18 00 00       	push   $0x18e3
    10d8:	6a 01                	push   $0x1
    10da:	e8 31 04 00 00       	call   1510 <printf>
      exit();
    10df:	e8 af 02 00 00       	call   1393 <exit>
      exec("sh", argv);
    10e4:	50                   	push   %eax
    10e5:	50                   	push   %eax
    10e6:	68 cc 1b 00 00       	push   $0x1bcc
    10eb:	68 f6 18 00 00       	push   $0x18f6
    10f0:	e8 d6 02 00 00       	call   13cb <exec>
      printf(1, "init: exec sh failed\n");
    10f5:	5a                   	pop    %edx
    10f6:	59                   	pop    %ecx
    10f7:	68 f9 18 00 00       	push   $0x18f9
    10fc:	6a 01                	push   $0x1
    10fe:	e8 0d 04 00 00       	call   1510 <printf>
      exit();
    1103:	e8 8b 02 00 00       	call   1393 <exit>
    mknod("console", 1, 1);
    1108:	50                   	push   %eax
    1109:	6a 01                	push   $0x1
    110b:	6a 01                	push   $0x1
    110d:	68 78 18 00 00       	push   $0x1878
    1112:	e8 c4 02 00 00       	call   13db <mknod>
    open("console", O_RDWR);
    1117:	58                   	pop    %eax
    1118:	5a                   	pop    %edx
    1119:	6a 02                	push   $0x2
    111b:	68 78 18 00 00       	push   $0x1878
    1120:	e8 ae 02 00 00       	call   13d3 <open>
    1125:	83 c4 10             	add    $0x10,%esp
    1128:	e9 00 ff ff ff       	jmp    102d <main+0x2d>
    112d:	66 90                	xchg   %ax,%ax
    112f:	90                   	nop

00001130 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    1130:	f3 0f 1e fb          	endbr32 
    1134:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1135:	31 c0                	xor    %eax,%eax
{
    1137:	89 e5                	mov    %esp,%ebp
    1139:	53                   	push   %ebx
    113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    113d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1140:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1144:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1147:	83 c0 01             	add    $0x1,%eax
    114a:	84 d2                	test   %dl,%dl
    114c:	75 f2                	jne    1140 <strcpy+0x10>
    ;
  return os;
}
    114e:	89 c8                	mov    %ecx,%eax
    1150:	5b                   	pop    %ebx
    1151:	5d                   	pop    %ebp
    1152:	c3                   	ret    
    1153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    115a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1160:	f3 0f 1e fb          	endbr32 
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
    1167:	53                   	push   %ebx
    1168:	8b 4d 08             	mov    0x8(%ebp),%ecx
    116b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    116e:	0f b6 01             	movzbl (%ecx),%eax
    1171:	0f b6 1a             	movzbl (%edx),%ebx
    1174:	84 c0                	test   %al,%al
    1176:	75 19                	jne    1191 <strcmp+0x31>
    1178:	eb 26                	jmp    11a0 <strcmp+0x40>
    117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1180:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1184:	83 c1 01             	add    $0x1,%ecx
    1187:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    118a:	0f b6 1a             	movzbl (%edx),%ebx
    118d:	84 c0                	test   %al,%al
    118f:	74 0f                	je     11a0 <strcmp+0x40>
    1191:	38 d8                	cmp    %bl,%al
    1193:	74 eb                	je     1180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1195:	29 d8                	sub    %ebx,%eax
}
    1197:	5b                   	pop    %ebx
    1198:	5d                   	pop    %ebp
    1199:	c3                   	ret    
    119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    11a2:	29 d8                	sub    %ebx,%eax
}
    11a4:	5b                   	pop    %ebx
    11a5:	5d                   	pop    %ebp
    11a6:	c3                   	ret    
    11a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ae:	66 90                	xchg   %ax,%ax

000011b0 <strlen>:

uint
strlen(const char *s)
{
    11b0:	f3 0f 1e fb          	endbr32 
    11b4:	55                   	push   %ebp
    11b5:	89 e5                	mov    %esp,%ebp
    11b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    11ba:	80 3a 00             	cmpb   $0x0,(%edx)
    11bd:	74 21                	je     11e0 <strlen+0x30>
    11bf:	31 c0                	xor    %eax,%eax
    11c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11c8:	83 c0 01             	add    $0x1,%eax
    11cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    11cf:	89 c1                	mov    %eax,%ecx
    11d1:	75 f5                	jne    11c8 <strlen+0x18>
    ;
  return n;
}
    11d3:	89 c8                	mov    %ecx,%eax
    11d5:	5d                   	pop    %ebp
    11d6:	c3                   	ret    
    11d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11de:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    11e0:	31 c9                	xor    %ecx,%ecx
}
    11e2:	5d                   	pop    %ebp
    11e3:	89 c8                	mov    %ecx,%eax
    11e5:	c3                   	ret    
    11e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ed:	8d 76 00             	lea    0x0(%esi),%esi

000011f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11f0:	f3 0f 1e fb          	endbr32 
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	57                   	push   %edi
    11f8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1201:	89 d7                	mov    %edx,%edi
    1203:	fc                   	cld    
    1204:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1206:	89 d0                	mov    %edx,%eax
    1208:	5f                   	pop    %edi
    1209:	5d                   	pop    %ebp
    120a:	c3                   	ret    
    120b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    120f:	90                   	nop

00001210 <strchr>:

char*
strchr(const char *s, char c)
{
    1210:	f3 0f 1e fb          	endbr32 
    1214:	55                   	push   %ebp
    1215:	89 e5                	mov    %esp,%ebp
    1217:	8b 45 08             	mov    0x8(%ebp),%eax
    121a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    121e:	0f b6 10             	movzbl (%eax),%edx
    1221:	84 d2                	test   %dl,%dl
    1223:	75 16                	jne    123b <strchr+0x2b>
    1225:	eb 21                	jmp    1248 <strchr+0x38>
    1227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    122e:	66 90                	xchg   %ax,%ax
    1230:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1234:	83 c0 01             	add    $0x1,%eax
    1237:	84 d2                	test   %dl,%dl
    1239:	74 0d                	je     1248 <strchr+0x38>
    if(*s == c)
    123b:	38 d1                	cmp    %dl,%cl
    123d:	75 f1                	jne    1230 <strchr+0x20>
      return (char*)s;
  return 0;
}
    123f:	5d                   	pop    %ebp
    1240:	c3                   	ret    
    1241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1248:	31 c0                	xor    %eax,%eax
}
    124a:	5d                   	pop    %ebp
    124b:	c3                   	ret    
    124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001250 <gets>:

char*
gets(char *buf, int max)
{
    1250:	f3 0f 1e fb          	endbr32 
    1254:	55                   	push   %ebp
    1255:	89 e5                	mov    %esp,%ebp
    1257:	57                   	push   %edi
    1258:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1259:	31 f6                	xor    %esi,%esi
{
    125b:	53                   	push   %ebx
    125c:	89 f3                	mov    %esi,%ebx
    125e:	83 ec 1c             	sub    $0x1c,%esp
    1261:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1264:	eb 33                	jmp    1299 <gets+0x49>
    1266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    126d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1270:	83 ec 04             	sub    $0x4,%esp
    1273:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1276:	6a 01                	push   $0x1
    1278:	50                   	push   %eax
    1279:	6a 00                	push   $0x0
    127b:	e8 2b 01 00 00       	call   13ab <read>
    if(cc < 1)
    1280:	83 c4 10             	add    $0x10,%esp
    1283:	85 c0                	test   %eax,%eax
    1285:	7e 1c                	jle    12a3 <gets+0x53>
      break;
    buf[i++] = c;
    1287:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    128b:	83 c7 01             	add    $0x1,%edi
    128e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1291:	3c 0a                	cmp    $0xa,%al
    1293:	74 23                	je     12b8 <gets+0x68>
    1295:	3c 0d                	cmp    $0xd,%al
    1297:	74 1f                	je     12b8 <gets+0x68>
  for(i=0; i+1 < max; ){
    1299:	83 c3 01             	add    $0x1,%ebx
    129c:	89 fe                	mov    %edi,%esi
    129e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    12a1:	7c cd                	jl     1270 <gets+0x20>
    12a3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    12a8:	c6 03 00             	movb   $0x0,(%ebx)
}
    12ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12ae:	5b                   	pop    %ebx
    12af:	5e                   	pop    %esi
    12b0:	5f                   	pop    %edi
    12b1:	5d                   	pop    %ebp
    12b2:	c3                   	ret    
    12b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12b7:	90                   	nop
    12b8:	8b 75 08             	mov    0x8(%ebp),%esi
    12bb:	8b 45 08             	mov    0x8(%ebp),%eax
    12be:	01 de                	add    %ebx,%esi
    12c0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    12c2:	c6 03 00             	movb   $0x0,(%ebx)
}
    12c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12c8:	5b                   	pop    %ebx
    12c9:	5e                   	pop    %esi
    12ca:	5f                   	pop    %edi
    12cb:	5d                   	pop    %ebp
    12cc:	c3                   	ret    
    12cd:	8d 76 00             	lea    0x0(%esi),%esi

000012d0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12d0:	f3 0f 1e fb          	endbr32 
    12d4:	55                   	push   %ebp
    12d5:	89 e5                	mov    %esp,%ebp
    12d7:	56                   	push   %esi
    12d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12d9:	83 ec 08             	sub    $0x8,%esp
    12dc:	6a 00                	push   $0x0
    12de:	ff 75 08             	pushl  0x8(%ebp)
    12e1:	e8 ed 00 00 00       	call   13d3 <open>
  if(fd < 0)
    12e6:	83 c4 10             	add    $0x10,%esp
    12e9:	85 c0                	test   %eax,%eax
    12eb:	78 2b                	js     1318 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    12ed:	83 ec 08             	sub    $0x8,%esp
    12f0:	ff 75 0c             	pushl  0xc(%ebp)
    12f3:	89 c3                	mov    %eax,%ebx
    12f5:	50                   	push   %eax
    12f6:	e8 f0 00 00 00       	call   13eb <fstat>
  close(fd);
    12fb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12fe:	89 c6                	mov    %eax,%esi
  close(fd);
    1300:	e8 b6 00 00 00       	call   13bb <close>
  return r;
    1305:	83 c4 10             	add    $0x10,%esp
}
    1308:	8d 65 f8             	lea    -0x8(%ebp),%esp
    130b:	89 f0                	mov    %esi,%eax
    130d:	5b                   	pop    %ebx
    130e:	5e                   	pop    %esi
    130f:	5d                   	pop    %ebp
    1310:	c3                   	ret    
    1311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1318:	be ff ff ff ff       	mov    $0xffffffff,%esi
    131d:	eb e9                	jmp    1308 <stat+0x38>
    131f:	90                   	nop

00001320 <atoi>:

int
atoi(const char *s)
{
    1320:	f3 0f 1e fb          	endbr32 
    1324:	55                   	push   %ebp
    1325:	89 e5                	mov    %esp,%ebp
    1327:	53                   	push   %ebx
    1328:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    132b:	0f be 02             	movsbl (%edx),%eax
    132e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1331:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1334:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1339:	77 1a                	ja     1355 <atoi+0x35>
    133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    133f:	90                   	nop
    n = n*10 + *s++ - '0';
    1340:	83 c2 01             	add    $0x1,%edx
    1343:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1346:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    134a:	0f be 02             	movsbl (%edx),%eax
    134d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1350:	80 fb 09             	cmp    $0x9,%bl
    1353:	76 eb                	jbe    1340 <atoi+0x20>
  return n;
}
    1355:	89 c8                	mov    %ecx,%eax
    1357:	5b                   	pop    %ebx
    1358:	5d                   	pop    %ebp
    1359:	c3                   	ret    
    135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001360 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1360:	f3 0f 1e fb          	endbr32 
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	57                   	push   %edi
    1368:	8b 45 10             	mov    0x10(%ebp),%eax
    136b:	8b 55 08             	mov    0x8(%ebp),%edx
    136e:	56                   	push   %esi
    136f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1372:	85 c0                	test   %eax,%eax
    1374:	7e 0f                	jle    1385 <memmove+0x25>
    1376:	01 d0                	add    %edx,%eax
  dst = vdst;
    1378:	89 d7                	mov    %edx,%edi
    137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1380:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1381:	39 f8                	cmp    %edi,%eax
    1383:	75 fb                	jne    1380 <memmove+0x20>
  return vdst;
}
    1385:	5e                   	pop    %esi
    1386:	89 d0                	mov    %edx,%eax
    1388:	5f                   	pop    %edi
    1389:	5d                   	pop    %ebp
    138a:	c3                   	ret    

0000138b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    138b:	b8 01 00 00 00       	mov    $0x1,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <exit>:
SYSCALL(exit)
    1393:	b8 02 00 00 00       	mov    $0x2,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <wait>:
SYSCALL(wait)
    139b:	b8 03 00 00 00       	mov    $0x3,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <pipe>:
SYSCALL(pipe)
    13a3:	b8 04 00 00 00       	mov    $0x4,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <read>:
SYSCALL(read)
    13ab:	b8 05 00 00 00       	mov    $0x5,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <write>:
SYSCALL(write)
    13b3:	b8 10 00 00 00       	mov    $0x10,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <close>:
SYSCALL(close)
    13bb:	b8 15 00 00 00       	mov    $0x15,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <kill>:
SYSCALL(kill)
    13c3:	b8 06 00 00 00       	mov    $0x6,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <exec>:
SYSCALL(exec)
    13cb:	b8 07 00 00 00       	mov    $0x7,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <open>:
SYSCALL(open)
    13d3:	b8 0f 00 00 00       	mov    $0xf,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <mknod>:
SYSCALL(mknod)
    13db:	b8 11 00 00 00       	mov    $0x11,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <unlink>:
SYSCALL(unlink)
    13e3:	b8 12 00 00 00       	mov    $0x12,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <fstat>:
SYSCALL(fstat)
    13eb:	b8 08 00 00 00       	mov    $0x8,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <link>:
SYSCALL(link)
    13f3:	b8 13 00 00 00       	mov    $0x13,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <mkdir>:
SYSCALL(mkdir)
    13fb:	b8 14 00 00 00       	mov    $0x14,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <chdir>:
SYSCALL(chdir)
    1403:	b8 09 00 00 00       	mov    $0x9,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <dup>:
SYSCALL(dup)
    140b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <getpid>:
SYSCALL(getpid)
    1413:	b8 0b 00 00 00       	mov    $0xb,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <sbrk>:
SYSCALL(sbrk)
    141b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <sleep>:
SYSCALL(sleep)
    1423:	b8 0d 00 00 00       	mov    $0xd,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <uptime>:
SYSCALL(uptime)
    142b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <provide_protection>:
SYSCALL(provide_protection)
    1433:	b8 18 00 00 00       	mov    $0x18,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <refuse_protection>:
SYSCALL(refuse_protection)
    143b:	b8 19 00 00 00       	mov    $0x19,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <settickets>:
SYSCALL(settickets) 
    1443:	b8 16 00 00 00       	mov    $0x16,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <getpinfo>:
    144b:	b8 17 00 00 00       	mov    $0x17,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    
    1453:	66 90                	xchg   %ax,%ax
    1455:	66 90                	xchg   %ax,%ax
    1457:	66 90                	xchg   %ax,%ax
    1459:	66 90                	xchg   %ax,%ax
    145b:	66 90                	xchg   %ax,%ax
    145d:	66 90                	xchg   %ax,%ax
    145f:	90                   	nop

00001460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1460:	55                   	push   %ebp
    1461:	89 e5                	mov    %esp,%ebp
    1463:	57                   	push   %edi
    1464:	56                   	push   %esi
    1465:	53                   	push   %ebx
    1466:	83 ec 3c             	sub    $0x3c,%esp
    1469:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    146c:	89 d1                	mov    %edx,%ecx
{
    146e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1471:	85 d2                	test   %edx,%edx
    1473:	0f 89 7f 00 00 00    	jns    14f8 <printint+0x98>
    1479:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    147d:	74 79                	je     14f8 <printint+0x98>
    neg = 1;
    147f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1486:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1488:	31 db                	xor    %ebx,%ebx
    148a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    148d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1490:	89 c8                	mov    %ecx,%eax
    1492:	31 d2                	xor    %edx,%edx
    1494:	89 cf                	mov    %ecx,%edi
    1496:	f7 75 c4             	divl   -0x3c(%ebp)
    1499:	0f b6 92 20 19 00 00 	movzbl 0x1920(%edx),%edx
    14a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    14a3:	89 d8                	mov    %ebx,%eax
    14a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    14a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    14ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    14ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    14b1:	76 dd                	jbe    1490 <printint+0x30>
  if(neg)
    14b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    14b6:	85 c9                	test   %ecx,%ecx
    14b8:	74 0c                	je     14c6 <printint+0x66>
    buf[i++] = '-';
    14ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    14bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    14c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    14c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    14c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    14cd:	eb 07                	jmp    14d6 <printint+0x76>
    14cf:	90                   	nop
    14d0:	0f b6 13             	movzbl (%ebx),%edx
    14d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    14d6:	83 ec 04             	sub    $0x4,%esp
    14d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    14dc:	6a 01                	push   $0x1
    14de:	56                   	push   %esi
    14df:	57                   	push   %edi
    14e0:	e8 ce fe ff ff       	call   13b3 <write>
  while(--i >= 0)
    14e5:	83 c4 10             	add    $0x10,%esp
    14e8:	39 de                	cmp    %ebx,%esi
    14ea:	75 e4                	jne    14d0 <printint+0x70>
    putc(fd, buf[i]);
}
    14ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14ef:	5b                   	pop    %ebx
    14f0:	5e                   	pop    %esi
    14f1:	5f                   	pop    %edi
    14f2:	5d                   	pop    %ebp
    14f3:	c3                   	ret    
    14f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    14ff:	eb 87                	jmp    1488 <printint+0x28>
    1501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    150f:	90                   	nop

00001510 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1510:	f3 0f 1e fb          	endbr32 
    1514:	55                   	push   %ebp
    1515:	89 e5                	mov    %esp,%ebp
    1517:	57                   	push   %edi
    1518:	56                   	push   %esi
    1519:	53                   	push   %ebx
    151a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    151d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1520:	0f b6 1e             	movzbl (%esi),%ebx
    1523:	84 db                	test   %bl,%bl
    1525:	0f 84 b4 00 00 00    	je     15df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    152b:	8d 45 10             	lea    0x10(%ebp),%eax
    152e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1531:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1534:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1536:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1539:	eb 33                	jmp    156e <printf+0x5e>
    153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    153f:	90                   	nop
    1540:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1543:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1548:	83 f8 25             	cmp    $0x25,%eax
    154b:	74 17                	je     1564 <printf+0x54>
  write(fd, &c, 1);
    154d:	83 ec 04             	sub    $0x4,%esp
    1550:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1553:	6a 01                	push   $0x1
    1555:	57                   	push   %edi
    1556:	ff 75 08             	pushl  0x8(%ebp)
    1559:	e8 55 fe ff ff       	call   13b3 <write>
    155e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1561:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1564:	0f b6 1e             	movzbl (%esi),%ebx
    1567:	83 c6 01             	add    $0x1,%esi
    156a:	84 db                	test   %bl,%bl
    156c:	74 71                	je     15df <printf+0xcf>
    c = fmt[i] & 0xff;
    156e:	0f be cb             	movsbl %bl,%ecx
    1571:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1574:	85 d2                	test   %edx,%edx
    1576:	74 c8                	je     1540 <printf+0x30>
      }
    } else if(state == '%'){
    1578:	83 fa 25             	cmp    $0x25,%edx
    157b:	75 e7                	jne    1564 <printf+0x54>
      if(c == 'd'){
    157d:	83 f8 64             	cmp    $0x64,%eax
    1580:	0f 84 9a 00 00 00    	je     1620 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1586:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    158c:	83 f9 70             	cmp    $0x70,%ecx
    158f:	74 5f                	je     15f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1591:	83 f8 73             	cmp    $0x73,%eax
    1594:	0f 84 d6 00 00 00    	je     1670 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    159a:	83 f8 63             	cmp    $0x63,%eax
    159d:	0f 84 8d 00 00 00    	je     1630 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    15a3:	83 f8 25             	cmp    $0x25,%eax
    15a6:	0f 84 b4 00 00 00    	je     1660 <printf+0x150>
  write(fd, &c, 1);
    15ac:	83 ec 04             	sub    $0x4,%esp
    15af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    15b3:	6a 01                	push   $0x1
    15b5:	57                   	push   %edi
    15b6:	ff 75 08             	pushl  0x8(%ebp)
    15b9:	e8 f5 fd ff ff       	call   13b3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    15be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    15c1:	83 c4 0c             	add    $0xc,%esp
    15c4:	6a 01                	push   $0x1
    15c6:	83 c6 01             	add    $0x1,%esi
    15c9:	57                   	push   %edi
    15ca:	ff 75 08             	pushl  0x8(%ebp)
    15cd:	e8 e1 fd ff ff       	call   13b3 <write>
  for(i = 0; fmt[i]; i++){
    15d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    15d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    15db:	84 db                	test   %bl,%bl
    15dd:	75 8f                	jne    156e <printf+0x5e>
    }
  }
}
    15df:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15e2:	5b                   	pop    %ebx
    15e3:	5e                   	pop    %esi
    15e4:	5f                   	pop    %edi
    15e5:	5d                   	pop    %ebp
    15e6:	c3                   	ret    
    15e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    15f0:	83 ec 0c             	sub    $0xc,%esp
    15f3:	b9 10 00 00 00       	mov    $0x10,%ecx
    15f8:	6a 00                	push   $0x0
    15fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    15fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1600:	8b 13                	mov    (%ebx),%edx
    1602:	e8 59 fe ff ff       	call   1460 <printint>
        ap++;
    1607:	89 d8                	mov    %ebx,%eax
    1609:	83 c4 10             	add    $0x10,%esp
      state = 0;
    160c:	31 d2                	xor    %edx,%edx
        ap++;
    160e:	83 c0 04             	add    $0x4,%eax
    1611:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1614:	e9 4b ff ff ff       	jmp    1564 <printf+0x54>
    1619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1620:	83 ec 0c             	sub    $0xc,%esp
    1623:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1628:	6a 01                	push   $0x1
    162a:	eb ce                	jmp    15fa <printf+0xea>
    162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1630:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1633:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1636:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1638:	6a 01                	push   $0x1
        ap++;
    163a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    163d:	57                   	push   %edi
    163e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1641:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1644:	e8 6a fd ff ff       	call   13b3 <write>
        ap++;
    1649:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    164c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    164f:	31 d2                	xor    %edx,%edx
    1651:	e9 0e ff ff ff       	jmp    1564 <printf+0x54>
    1656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    165d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1660:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1663:	83 ec 04             	sub    $0x4,%esp
    1666:	e9 59 ff ff ff       	jmp    15c4 <printf+0xb4>
    166b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    166f:	90                   	nop
        s = (char*)*ap;
    1670:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1673:	8b 18                	mov    (%eax),%ebx
        ap++;
    1675:	83 c0 04             	add    $0x4,%eax
    1678:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    167b:	85 db                	test   %ebx,%ebx
    167d:	74 17                	je     1696 <printf+0x186>
        while(*s != 0){
    167f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1682:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1684:	84 c0                	test   %al,%al
    1686:	0f 84 d8 fe ff ff    	je     1564 <printf+0x54>
    168c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    168f:	89 de                	mov    %ebx,%esi
    1691:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1694:	eb 1a                	jmp    16b0 <printf+0x1a0>
          s = "(null)";
    1696:	bb 18 19 00 00       	mov    $0x1918,%ebx
        while(*s != 0){
    169b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    169e:	b8 28 00 00 00       	mov    $0x28,%eax
    16a3:	89 de                	mov    %ebx,%esi
    16a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16af:	90                   	nop
  write(fd, &c, 1);
    16b0:	83 ec 04             	sub    $0x4,%esp
          s++;
    16b3:	83 c6 01             	add    $0x1,%esi
    16b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    16b9:	6a 01                	push   $0x1
    16bb:	57                   	push   %edi
    16bc:	53                   	push   %ebx
    16bd:	e8 f1 fc ff ff       	call   13b3 <write>
        while(*s != 0){
    16c2:	0f b6 06             	movzbl (%esi),%eax
    16c5:	83 c4 10             	add    $0x10,%esp
    16c8:	84 c0                	test   %al,%al
    16ca:	75 e4                	jne    16b0 <printf+0x1a0>
    16cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    16cf:	31 d2                	xor    %edx,%edx
    16d1:	e9 8e fe ff ff       	jmp    1564 <printf+0x54>
    16d6:	66 90                	xchg   %ax,%ax
    16d8:	66 90                	xchg   %ax,%ax
    16da:	66 90                	xchg   %ax,%ax
    16dc:	66 90                	xchg   %ax,%ax
    16de:	66 90                	xchg   %ax,%ax

000016e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16e0:	f3 0f 1e fb          	endbr32 
    16e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16e5:	a1 d4 1b 00 00       	mov    0x1bd4,%eax
{
    16ea:	89 e5                	mov    %esp,%ebp
    16ec:	57                   	push   %edi
    16ed:	56                   	push   %esi
    16ee:	53                   	push   %ebx
    16ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    16f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f7:	39 c8                	cmp    %ecx,%eax
    16f9:	73 15                	jae    1710 <free+0x30>
    16fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16ff:	90                   	nop
    1700:	39 d1                	cmp    %edx,%ecx
    1702:	72 14                	jb     1718 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1704:	39 d0                	cmp    %edx,%eax
    1706:	73 10                	jae    1718 <free+0x38>
{
    1708:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    170a:	8b 10                	mov    (%eax),%edx
    170c:	39 c8                	cmp    %ecx,%eax
    170e:	72 f0                	jb     1700 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1710:	39 d0                	cmp    %edx,%eax
    1712:	72 f4                	jb     1708 <free+0x28>
    1714:	39 d1                	cmp    %edx,%ecx
    1716:	73 f0                	jae    1708 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1718:	8b 73 fc             	mov    -0x4(%ebx),%esi
    171b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    171e:	39 fa                	cmp    %edi,%edx
    1720:	74 1e                	je     1740 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1722:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1725:	8b 50 04             	mov    0x4(%eax),%edx
    1728:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    172b:	39 f1                	cmp    %esi,%ecx
    172d:	74 28                	je     1757 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    172f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1731:	5b                   	pop    %ebx
  freep = p;
    1732:	a3 d4 1b 00 00       	mov    %eax,0x1bd4
}
    1737:	5e                   	pop    %esi
    1738:	5f                   	pop    %edi
    1739:	5d                   	pop    %ebp
    173a:	c3                   	ret    
    173b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    173f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1740:	03 72 04             	add    0x4(%edx),%esi
    1743:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1746:	8b 10                	mov    (%eax),%edx
    1748:	8b 12                	mov    (%edx),%edx
    174a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    174d:	8b 50 04             	mov    0x4(%eax),%edx
    1750:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1753:	39 f1                	cmp    %esi,%ecx
    1755:	75 d8                	jne    172f <free+0x4f>
    p->s.size += bp->s.size;
    1757:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    175a:	a3 d4 1b 00 00       	mov    %eax,0x1bd4
    p->s.size += bp->s.size;
    175f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1762:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1765:	89 10                	mov    %edx,(%eax)
}
    1767:	5b                   	pop    %ebx
    1768:	5e                   	pop    %esi
    1769:	5f                   	pop    %edi
    176a:	5d                   	pop    %ebp
    176b:	c3                   	ret    
    176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1770:	f3 0f 1e fb          	endbr32 
    1774:	55                   	push   %ebp
    1775:	89 e5                	mov    %esp,%ebp
    1777:	57                   	push   %edi
    1778:	56                   	push   %esi
    1779:	53                   	push   %ebx
    177a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    177d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1780:	8b 3d d4 1b 00 00    	mov    0x1bd4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1786:	8d 70 07             	lea    0x7(%eax),%esi
    1789:	c1 ee 03             	shr    $0x3,%esi
    178c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    178f:	85 ff                	test   %edi,%edi
    1791:	0f 84 a9 00 00 00    	je     1840 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1797:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1799:	8b 48 04             	mov    0x4(%eax),%ecx
    179c:	39 f1                	cmp    %esi,%ecx
    179e:	73 6d                	jae    180d <malloc+0x9d>
    17a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    17a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    17ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    17ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    17b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    17b8:	eb 17                	jmp    17d1 <malloc+0x61>
    17ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    17c2:	8b 4a 04             	mov    0x4(%edx),%ecx
    17c5:	39 f1                	cmp    %esi,%ecx
    17c7:	73 4f                	jae    1818 <malloc+0xa8>
    17c9:	8b 3d d4 1b 00 00    	mov    0x1bd4,%edi
    17cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17d1:	39 c7                	cmp    %eax,%edi
    17d3:	75 eb                	jne    17c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    17d5:	83 ec 0c             	sub    $0xc,%esp
    17d8:	ff 75 e4             	pushl  -0x1c(%ebp)
    17db:	e8 3b fc ff ff       	call   141b <sbrk>
  if(p == (char*)-1)
    17e0:	83 c4 10             	add    $0x10,%esp
    17e3:	83 f8 ff             	cmp    $0xffffffff,%eax
    17e6:	74 1b                	je     1803 <malloc+0x93>
  hp->s.size = nu;
    17e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17eb:	83 ec 0c             	sub    $0xc,%esp
    17ee:	83 c0 08             	add    $0x8,%eax
    17f1:	50                   	push   %eax
    17f2:	e8 e9 fe ff ff       	call   16e0 <free>
  return freep;
    17f7:	a1 d4 1b 00 00       	mov    0x1bd4,%eax
      if((p = morecore(nunits)) == 0)
    17fc:	83 c4 10             	add    $0x10,%esp
    17ff:	85 c0                	test   %eax,%eax
    1801:	75 bd                	jne    17c0 <malloc+0x50>
        return 0;
  }
}
    1803:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1806:	31 c0                	xor    %eax,%eax
}
    1808:	5b                   	pop    %ebx
    1809:	5e                   	pop    %esi
    180a:	5f                   	pop    %edi
    180b:	5d                   	pop    %ebp
    180c:	c3                   	ret    
    if(p->s.size >= nunits){
    180d:	89 c2                	mov    %eax,%edx
    180f:	89 f8                	mov    %edi,%eax
    1811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1818:	39 ce                	cmp    %ecx,%esi
    181a:	74 54                	je     1870 <malloc+0x100>
        p->s.size -= nunits;
    181c:	29 f1                	sub    %esi,%ecx
    181e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1821:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1824:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1827:	a3 d4 1b 00 00       	mov    %eax,0x1bd4
}
    182c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    182f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1832:	5b                   	pop    %ebx
    1833:	5e                   	pop    %esi
    1834:	5f                   	pop    %edi
    1835:	5d                   	pop    %ebp
    1836:	c3                   	ret    
    1837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    183e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1840:	c7 05 d4 1b 00 00 d8 	movl   $0x1bd8,0x1bd4
    1847:	1b 00 00 
    base.s.size = 0;
    184a:	bf d8 1b 00 00       	mov    $0x1bd8,%edi
    base.s.ptr = freep = prevp = &base;
    184f:	c7 05 d8 1b 00 00 d8 	movl   $0x1bd8,0x1bd8
    1856:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1859:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    185b:	c7 05 dc 1b 00 00 00 	movl   $0x0,0x1bdc
    1862:	00 00 00 
    if(p->s.size >= nunits){
    1865:	e9 36 ff ff ff       	jmp    17a0 <malloc+0x30>
    186a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1870:	8b 0a                	mov    (%edx),%ecx
    1872:	89 08                	mov    %ecx,(%eax)
    1874:	eb b1                	jmp    1827 <malloc+0xb7>
