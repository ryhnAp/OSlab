
_tester:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"
#include "pstat.h"

int main(int argc, char* argv[]){
    1000:	f3 0f 1e fb          	endbr32 
    1004:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1008:	83 e4 f0             	and    $0xfffffff0,%esp
    100b:	ff 71 fc             	pushl  -0x4(%ecx)
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	56                   	push   %esi
    1012:	53                   	push   %ebx
    1013:	51                   	push   %ecx
    1014:	81 ec 0c 04 00 00    	sub    $0x40c,%esp
    101a:	8b 01                	mov    (%ecx),%eax
    101c:	8b 51 04             	mov    0x4(%ecx),%edx
    struct pstat ps;

    for(int i=1 ; i < argc ; i++ ){
    101f:	83 f8 01             	cmp    $0x1,%eax
    1022:	7e 44                	jle    1068 <main+0x68>
    1024:	8d 5a 04             	lea    0x4(%edx),%ebx
    1027:	8d 34 82             	lea    (%edx,%eax,4),%esi
    102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        int tickets_number =  atoi(argv[i]);
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	ff 33                	pushl  (%ebx)
    1035:	83 c3 04             	add    $0x4,%ebx
    1038:	e8 93 02 00 00       	call   12d0 <atoi>
        settickets(tickets_number);
    103d:	89 04 24             	mov    %eax,(%esp)
    1040:	e8 ae 03 00 00       	call   13f3 <settickets>
        printf(1,"#") ; 
    1045:	59                   	pop    %ecx
    1046:	58                   	pop    %eax
    1047:	68 28 18 00 00       	push   $0x1828
    104c:	6a 01                	push   $0x1
    104e:	e8 6d 04 00 00       	call   14c0 <printf>
        // while (1);
        printf(1,"@") ; 
    1053:	58                   	pop    %eax
    1054:	5a                   	pop    %edx
    1055:	68 2a 18 00 00       	push   $0x182a
    105a:	6a 01                	push   $0x1
    105c:	e8 5f 04 00 00       	call   14c0 <printf>
    for(int i=1 ; i < argc ; i++ ){
    1061:	83 c4 10             	add    $0x10,%esp
    1064:	39 f3                	cmp    %esi,%ebx
    1066:	75 c8                	jne    1030 <main+0x30>
        // printf(1, "%d", argv[i]);
    }
    getpinfo(&ps);
    1068:	83 ec 0c             	sub    $0xc,%esp
    106b:	8d 9d e8 fb ff ff    	lea    -0x418(%ebp),%ebx
    1071:	8d b5 e8 fc ff ff    	lea    -0x318(%ebp),%esi
    1077:	53                   	push   %ebx
    1078:	e8 7e 03 00 00       	call   13fb <getpinfo>
    printf(1, "%d running processes\n", NPROC);
    107d:	83 c4 0c             	add    $0xc,%esp
    1080:	6a 40                	push   $0x40
    1082:	68 2c 18 00 00       	push   $0x182c
    1087:	6a 01                	push   $0x1
    1089:	e8 32 04 00 00       	call   14c0 <printf>
    printf(1, "\nPID\tUSED?\tTICKETS\t\tTICKS\n");
    108e:	58                   	pop    %eax
    108f:	5a                   	pop    %edx
    1090:	68 42 18 00 00       	push   $0x1842
    1095:	6a 01                	push   $0x1
    1097:	e8 24 04 00 00       	call   14c0 <printf>
    for (int i = 0; i < NPROC ; i++)
    109c:	83 c4 10             	add    $0x10,%esp
    109f:	90                   	nop
    {
        // selcet used processes and print their information from pstat struct
        if(ps.pid[i] && ps.tickets[i]>0)
    10a0:	8b 83 00 02 00 00    	mov    0x200(%ebx),%eax
    10a6:	85 c0                	test   %eax,%eax
    10a8:	74 26                	je     10d0 <main+0xd0>
    10aa:	8b 93 00 01 00 00    	mov    0x100(%ebx),%edx
    10b0:	85 d2                	test   %edx,%edx
    10b2:	7e 1c                	jle    10d0 <main+0xd0>
            printf(1, "%d\t%d\t%d\t\t%d\n",ps.pid[i], ps.inuse[i], ps.tickets[i], ps.ticks[i]);
    10b4:	83 ec 08             	sub    $0x8,%esp
    10b7:	ff b3 00 03 00 00    	pushl  0x300(%ebx)
    10bd:	52                   	push   %edx
    10be:	ff 33                	pushl  (%ebx)
    10c0:	50                   	push   %eax
    10c1:	68 5d 18 00 00       	push   $0x185d
    10c6:	6a 01                	push   $0x1
    10c8:	e8 f3 03 00 00       	call   14c0 <printf>
    10cd:	83 c4 20             	add    $0x20,%esp
    for (int i = 0; i < NPROC ; i++)
    10d0:	83 c3 04             	add    $0x4,%ebx
    10d3:	39 f3                	cmp    %esi,%ebx
    10d5:	75 c9                	jne    10a0 <main+0xa0>
    }
    exit();
    10d7:	e8 67 02 00 00       	call   1343 <exit>
    10dc:	66 90                	xchg   %ax,%ax
    10de:	66 90                	xchg   %ax,%ax

000010e0 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    10e0:	f3 0f 1e fb          	endbr32 
    10e4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10e5:	31 c0                	xor    %eax,%eax
{
    10e7:	89 e5                	mov    %esp,%ebp
    10e9:	53                   	push   %ebx
    10ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    10f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    10f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    10f7:	83 c0 01             	add    $0x1,%eax
    10fa:	84 d2                	test   %dl,%dl
    10fc:	75 f2                	jne    10f0 <strcpy+0x10>
    ;
  return os;
}
    10fe:	89 c8                	mov    %ecx,%eax
    1100:	5b                   	pop    %ebx
    1101:	5d                   	pop    %ebp
    1102:	c3                   	ret    
    1103:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1110:	f3 0f 1e fb          	endbr32 
    1114:	55                   	push   %ebp
    1115:	89 e5                	mov    %esp,%ebp
    1117:	53                   	push   %ebx
    1118:	8b 4d 08             	mov    0x8(%ebp),%ecx
    111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    111e:	0f b6 01             	movzbl (%ecx),%eax
    1121:	0f b6 1a             	movzbl (%edx),%ebx
    1124:	84 c0                	test   %al,%al
    1126:	75 19                	jne    1141 <strcmp+0x31>
    1128:	eb 26                	jmp    1150 <strcmp+0x40>
    112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1130:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1134:	83 c1 01             	add    $0x1,%ecx
    1137:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    113a:	0f b6 1a             	movzbl (%edx),%ebx
    113d:	84 c0                	test   %al,%al
    113f:	74 0f                	je     1150 <strcmp+0x40>
    1141:	38 d8                	cmp    %bl,%al
    1143:	74 eb                	je     1130 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1145:	29 d8                	sub    %ebx,%eax
}
    1147:	5b                   	pop    %ebx
    1148:	5d                   	pop    %ebp
    1149:	c3                   	ret    
    114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1150:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1152:	29 d8                	sub    %ebx,%eax
}
    1154:	5b                   	pop    %ebx
    1155:	5d                   	pop    %ebp
    1156:	c3                   	ret    
    1157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    115e:	66 90                	xchg   %ax,%ax

00001160 <strlen>:

uint
strlen(const char *s)
{
    1160:	f3 0f 1e fb          	endbr32 
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
    1167:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    116a:	80 3a 00             	cmpb   $0x0,(%edx)
    116d:	74 21                	je     1190 <strlen+0x30>
    116f:	31 c0                	xor    %eax,%eax
    1171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1178:	83 c0 01             	add    $0x1,%eax
    117b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    117f:	89 c1                	mov    %eax,%ecx
    1181:	75 f5                	jne    1178 <strlen+0x18>
    ;
  return n;
}
    1183:	89 c8                	mov    %ecx,%eax
    1185:	5d                   	pop    %ebp
    1186:	c3                   	ret    
    1187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    118e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    1190:	31 c9                	xor    %ecx,%ecx
}
    1192:	5d                   	pop    %ebp
    1193:	89 c8                	mov    %ecx,%eax
    1195:	c3                   	ret    
    1196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    119d:	8d 76 00             	lea    0x0(%esi),%esi

000011a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a0:	f3 0f 1e fb          	endbr32 
    11a4:	55                   	push   %ebp
    11a5:	89 e5                	mov    %esp,%ebp
    11a7:	57                   	push   %edi
    11a8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b1:	89 d7                	mov    %edx,%edi
    11b3:	fc                   	cld    
    11b4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11b6:	89 d0                	mov    %edx,%eax
    11b8:	5f                   	pop    %edi
    11b9:	5d                   	pop    %ebp
    11ba:	c3                   	ret    
    11bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11bf:	90                   	nop

000011c0 <strchr>:

char*
strchr(const char *s, char c)
{
    11c0:	f3 0f 1e fb          	endbr32 
    11c4:	55                   	push   %ebp
    11c5:	89 e5                	mov    %esp,%ebp
    11c7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    11ce:	0f b6 10             	movzbl (%eax),%edx
    11d1:	84 d2                	test   %dl,%dl
    11d3:	75 16                	jne    11eb <strchr+0x2b>
    11d5:	eb 21                	jmp    11f8 <strchr+0x38>
    11d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11de:	66 90                	xchg   %ax,%ax
    11e0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    11e4:	83 c0 01             	add    $0x1,%eax
    11e7:	84 d2                	test   %dl,%dl
    11e9:	74 0d                	je     11f8 <strchr+0x38>
    if(*s == c)
    11eb:	38 d1                	cmp    %dl,%cl
    11ed:	75 f1                	jne    11e0 <strchr+0x20>
      return (char*)s;
  return 0;
}
    11ef:	5d                   	pop    %ebp
    11f0:	c3                   	ret    
    11f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    11f8:	31 c0                	xor    %eax,%eax
}
    11fa:	5d                   	pop    %ebp
    11fb:	c3                   	ret    
    11fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001200 <gets>:

char*
gets(char *buf, int max)
{
    1200:	f3 0f 1e fb          	endbr32 
    1204:	55                   	push   %ebp
    1205:	89 e5                	mov    %esp,%ebp
    1207:	57                   	push   %edi
    1208:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1209:	31 f6                	xor    %esi,%esi
{
    120b:	53                   	push   %ebx
    120c:	89 f3                	mov    %esi,%ebx
    120e:	83 ec 1c             	sub    $0x1c,%esp
    1211:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1214:	eb 33                	jmp    1249 <gets+0x49>
    1216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    121d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1220:	83 ec 04             	sub    $0x4,%esp
    1223:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1226:	6a 01                	push   $0x1
    1228:	50                   	push   %eax
    1229:	6a 00                	push   $0x0
    122b:	e8 2b 01 00 00       	call   135b <read>
    if(cc < 1)
    1230:	83 c4 10             	add    $0x10,%esp
    1233:	85 c0                	test   %eax,%eax
    1235:	7e 1c                	jle    1253 <gets+0x53>
      break;
    buf[i++] = c;
    1237:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    123b:	83 c7 01             	add    $0x1,%edi
    123e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1241:	3c 0a                	cmp    $0xa,%al
    1243:	74 23                	je     1268 <gets+0x68>
    1245:	3c 0d                	cmp    $0xd,%al
    1247:	74 1f                	je     1268 <gets+0x68>
  for(i=0; i+1 < max; ){
    1249:	83 c3 01             	add    $0x1,%ebx
    124c:	89 fe                	mov    %edi,%esi
    124e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1251:	7c cd                	jl     1220 <gets+0x20>
    1253:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1258:	c6 03 00             	movb   $0x0,(%ebx)
}
    125b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    125e:	5b                   	pop    %ebx
    125f:	5e                   	pop    %esi
    1260:	5f                   	pop    %edi
    1261:	5d                   	pop    %ebp
    1262:	c3                   	ret    
    1263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1267:	90                   	nop
    1268:	8b 75 08             	mov    0x8(%ebp),%esi
    126b:	8b 45 08             	mov    0x8(%ebp),%eax
    126e:	01 de                	add    %ebx,%esi
    1270:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    1272:	c6 03 00             	movb   $0x0,(%ebx)
}
    1275:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1278:	5b                   	pop    %ebx
    1279:	5e                   	pop    %esi
    127a:	5f                   	pop    %edi
    127b:	5d                   	pop    %ebp
    127c:	c3                   	ret    
    127d:	8d 76 00             	lea    0x0(%esi),%esi

00001280 <stat>:

int
stat(const char *n, struct stat *st)
{
    1280:	f3 0f 1e fb          	endbr32 
    1284:	55                   	push   %ebp
    1285:	89 e5                	mov    %esp,%ebp
    1287:	56                   	push   %esi
    1288:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1289:	83 ec 08             	sub    $0x8,%esp
    128c:	6a 00                	push   $0x0
    128e:	ff 75 08             	pushl  0x8(%ebp)
    1291:	e8 ed 00 00 00       	call   1383 <open>
  if(fd < 0)
    1296:	83 c4 10             	add    $0x10,%esp
    1299:	85 c0                	test   %eax,%eax
    129b:	78 2b                	js     12c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    129d:	83 ec 08             	sub    $0x8,%esp
    12a0:	ff 75 0c             	pushl  0xc(%ebp)
    12a3:	89 c3                	mov    %eax,%ebx
    12a5:	50                   	push   %eax
    12a6:	e8 f0 00 00 00       	call   139b <fstat>
  close(fd);
    12ab:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12ae:	89 c6                	mov    %eax,%esi
  close(fd);
    12b0:	e8 b6 00 00 00       	call   136b <close>
  return r;
    12b5:	83 c4 10             	add    $0x10,%esp
}
    12b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12bb:	89 f0                	mov    %esi,%eax
    12bd:	5b                   	pop    %ebx
    12be:	5e                   	pop    %esi
    12bf:	5d                   	pop    %ebp
    12c0:	c3                   	ret    
    12c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    12c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12cd:	eb e9                	jmp    12b8 <stat+0x38>
    12cf:	90                   	nop

000012d0 <atoi>:

int
atoi(const char *s)
{
    12d0:	f3 0f 1e fb          	endbr32 
    12d4:	55                   	push   %ebp
    12d5:	89 e5                	mov    %esp,%ebp
    12d7:	53                   	push   %ebx
    12d8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12db:	0f be 02             	movsbl (%edx),%eax
    12de:	8d 48 d0             	lea    -0x30(%eax),%ecx
    12e1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    12e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    12e9:	77 1a                	ja     1305 <atoi+0x35>
    12eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12ef:	90                   	nop
    n = n*10 + *s++ - '0';
    12f0:	83 c2 01             	add    $0x1,%edx
    12f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    12f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    12fa:	0f be 02             	movsbl (%edx),%eax
    12fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1300:	80 fb 09             	cmp    $0x9,%bl
    1303:	76 eb                	jbe    12f0 <atoi+0x20>
  return n;
}
    1305:	89 c8                	mov    %ecx,%eax
    1307:	5b                   	pop    %ebx
    1308:	5d                   	pop    %ebp
    1309:	c3                   	ret    
    130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1310:	f3 0f 1e fb          	endbr32 
    1314:	55                   	push   %ebp
    1315:	89 e5                	mov    %esp,%ebp
    1317:	57                   	push   %edi
    1318:	8b 45 10             	mov    0x10(%ebp),%eax
    131b:	8b 55 08             	mov    0x8(%ebp),%edx
    131e:	56                   	push   %esi
    131f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1322:	85 c0                	test   %eax,%eax
    1324:	7e 0f                	jle    1335 <memmove+0x25>
    1326:	01 d0                	add    %edx,%eax
  dst = vdst;
    1328:	89 d7                	mov    %edx,%edi
    132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1330:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1331:	39 f8                	cmp    %edi,%eax
    1333:	75 fb                	jne    1330 <memmove+0x20>
  return vdst;
}
    1335:	5e                   	pop    %esi
    1336:	89 d0                	mov    %edx,%eax
    1338:	5f                   	pop    %edi
    1339:	5d                   	pop    %ebp
    133a:	c3                   	ret    

0000133b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    133b:	b8 01 00 00 00       	mov    $0x1,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <exit>:
SYSCALL(exit)
    1343:	b8 02 00 00 00       	mov    $0x2,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <wait>:
SYSCALL(wait)
    134b:	b8 03 00 00 00       	mov    $0x3,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <pipe>:
SYSCALL(pipe)
    1353:	b8 04 00 00 00       	mov    $0x4,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <read>:
SYSCALL(read)
    135b:	b8 05 00 00 00       	mov    $0x5,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <write>:
SYSCALL(write)
    1363:	b8 10 00 00 00       	mov    $0x10,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <close>:
SYSCALL(close)
    136b:	b8 15 00 00 00       	mov    $0x15,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <kill>:
SYSCALL(kill)
    1373:	b8 06 00 00 00       	mov    $0x6,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <exec>:
SYSCALL(exec)
    137b:	b8 07 00 00 00       	mov    $0x7,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <open>:
SYSCALL(open)
    1383:	b8 0f 00 00 00       	mov    $0xf,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <mknod>:
SYSCALL(mknod)
    138b:	b8 11 00 00 00       	mov    $0x11,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <unlink>:
SYSCALL(unlink)
    1393:	b8 12 00 00 00       	mov    $0x12,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <fstat>:
SYSCALL(fstat)
    139b:	b8 08 00 00 00       	mov    $0x8,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <link>:
SYSCALL(link)
    13a3:	b8 13 00 00 00       	mov    $0x13,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <mkdir>:
SYSCALL(mkdir)
    13ab:	b8 14 00 00 00       	mov    $0x14,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <chdir>:
SYSCALL(chdir)
    13b3:	b8 09 00 00 00       	mov    $0x9,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <dup>:
SYSCALL(dup)
    13bb:	b8 0a 00 00 00       	mov    $0xa,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <getpid>:
SYSCALL(getpid)
    13c3:	b8 0b 00 00 00       	mov    $0xb,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <sbrk>:
SYSCALL(sbrk)
    13cb:	b8 0c 00 00 00       	mov    $0xc,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <sleep>:
SYSCALL(sleep)
    13d3:	b8 0d 00 00 00       	mov    $0xd,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <uptime>:
SYSCALL(uptime)
    13db:	b8 0e 00 00 00       	mov    $0xe,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <provide_protection>:
SYSCALL(provide_protection)
    13e3:	b8 18 00 00 00       	mov    $0x18,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <refuse_protection>:
SYSCALL(refuse_protection)
    13eb:	b8 19 00 00 00       	mov    $0x19,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <settickets>:
SYSCALL(settickets) 
    13f3:	b8 16 00 00 00       	mov    $0x16,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <getpinfo>:
    13fb:	b8 17 00 00 00       	mov    $0x17,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    
    1403:	66 90                	xchg   %ax,%ax
    1405:	66 90                	xchg   %ax,%ax
    1407:	66 90                	xchg   %ax,%ax
    1409:	66 90                	xchg   %ax,%ax
    140b:	66 90                	xchg   %ax,%ax
    140d:	66 90                	xchg   %ax,%ax
    140f:	90                   	nop

00001410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	57                   	push   %edi
    1414:	56                   	push   %esi
    1415:	53                   	push   %ebx
    1416:	83 ec 3c             	sub    $0x3c,%esp
    1419:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    141c:	89 d1                	mov    %edx,%ecx
{
    141e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1421:	85 d2                	test   %edx,%edx
    1423:	0f 89 7f 00 00 00    	jns    14a8 <printint+0x98>
    1429:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    142d:	74 79                	je     14a8 <printint+0x98>
    neg = 1;
    142f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1436:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1438:	31 db                	xor    %ebx,%ebx
    143a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    143d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1440:	89 c8                	mov    %ecx,%eax
    1442:	31 d2                	xor    %edx,%edx
    1444:	89 cf                	mov    %ecx,%edi
    1446:	f7 75 c4             	divl   -0x3c(%ebp)
    1449:	0f b6 92 74 18 00 00 	movzbl 0x1874(%edx),%edx
    1450:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1453:	89 d8                	mov    %ebx,%eax
    1455:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1458:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    145b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    145e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1461:	76 dd                	jbe    1440 <printint+0x30>
  if(neg)
    1463:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1466:	85 c9                	test   %ecx,%ecx
    1468:	74 0c                	je     1476 <printint+0x66>
    buf[i++] = '-';
    146a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    146f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1471:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1476:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1479:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    147d:	eb 07                	jmp    1486 <printint+0x76>
    147f:	90                   	nop
    1480:	0f b6 13             	movzbl (%ebx),%edx
    1483:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1486:	83 ec 04             	sub    $0x4,%esp
    1489:	88 55 d7             	mov    %dl,-0x29(%ebp)
    148c:	6a 01                	push   $0x1
    148e:	56                   	push   %esi
    148f:	57                   	push   %edi
    1490:	e8 ce fe ff ff       	call   1363 <write>
  while(--i >= 0)
    1495:	83 c4 10             	add    $0x10,%esp
    1498:	39 de                	cmp    %ebx,%esi
    149a:	75 e4                	jne    1480 <printint+0x70>
    putc(fd, buf[i]);
}
    149c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    149f:	5b                   	pop    %ebx
    14a0:	5e                   	pop    %esi
    14a1:	5f                   	pop    %edi
    14a2:	5d                   	pop    %ebp
    14a3:	c3                   	ret    
    14a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    14af:	eb 87                	jmp    1438 <printint+0x28>
    14b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14bf:	90                   	nop

000014c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    14c0:	f3 0f 1e fb          	endbr32 
    14c4:	55                   	push   %ebp
    14c5:	89 e5                	mov    %esp,%ebp
    14c7:	57                   	push   %edi
    14c8:	56                   	push   %esi
    14c9:	53                   	push   %ebx
    14ca:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14cd:	8b 75 0c             	mov    0xc(%ebp),%esi
    14d0:	0f b6 1e             	movzbl (%esi),%ebx
    14d3:	84 db                	test   %bl,%bl
    14d5:	0f 84 b4 00 00 00    	je     158f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    14db:	8d 45 10             	lea    0x10(%ebp),%eax
    14de:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    14e1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    14e4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    14e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    14e9:	eb 33                	jmp    151e <printf+0x5e>
    14eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    14ef:	90                   	nop
    14f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    14f3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    14f8:	83 f8 25             	cmp    $0x25,%eax
    14fb:	74 17                	je     1514 <printf+0x54>
  write(fd, &c, 1);
    14fd:	83 ec 04             	sub    $0x4,%esp
    1500:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1503:	6a 01                	push   $0x1
    1505:	57                   	push   %edi
    1506:	ff 75 08             	pushl  0x8(%ebp)
    1509:	e8 55 fe ff ff       	call   1363 <write>
    150e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1511:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1514:	0f b6 1e             	movzbl (%esi),%ebx
    1517:	83 c6 01             	add    $0x1,%esi
    151a:	84 db                	test   %bl,%bl
    151c:	74 71                	je     158f <printf+0xcf>
    c = fmt[i] & 0xff;
    151e:	0f be cb             	movsbl %bl,%ecx
    1521:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1524:	85 d2                	test   %edx,%edx
    1526:	74 c8                	je     14f0 <printf+0x30>
      }
    } else if(state == '%'){
    1528:	83 fa 25             	cmp    $0x25,%edx
    152b:	75 e7                	jne    1514 <printf+0x54>
      if(c == 'd'){
    152d:	83 f8 64             	cmp    $0x64,%eax
    1530:	0f 84 9a 00 00 00    	je     15d0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1536:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    153c:	83 f9 70             	cmp    $0x70,%ecx
    153f:	74 5f                	je     15a0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1541:	83 f8 73             	cmp    $0x73,%eax
    1544:	0f 84 d6 00 00 00    	je     1620 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    154a:	83 f8 63             	cmp    $0x63,%eax
    154d:	0f 84 8d 00 00 00    	je     15e0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1553:	83 f8 25             	cmp    $0x25,%eax
    1556:	0f 84 b4 00 00 00    	je     1610 <printf+0x150>
  write(fd, &c, 1);
    155c:	83 ec 04             	sub    $0x4,%esp
    155f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1563:	6a 01                	push   $0x1
    1565:	57                   	push   %edi
    1566:	ff 75 08             	pushl  0x8(%ebp)
    1569:	e8 f5 fd ff ff       	call   1363 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    156e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1571:	83 c4 0c             	add    $0xc,%esp
    1574:	6a 01                	push   $0x1
    1576:	83 c6 01             	add    $0x1,%esi
    1579:	57                   	push   %edi
    157a:	ff 75 08             	pushl  0x8(%ebp)
    157d:	e8 e1 fd ff ff       	call   1363 <write>
  for(i = 0; fmt[i]; i++){
    1582:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1586:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1589:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    158b:	84 db                	test   %bl,%bl
    158d:	75 8f                	jne    151e <printf+0x5e>
    }
  }
}
    158f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1592:	5b                   	pop    %ebx
    1593:	5e                   	pop    %esi
    1594:	5f                   	pop    %edi
    1595:	5d                   	pop    %ebp
    1596:	c3                   	ret    
    1597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    159e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    15a0:	83 ec 0c             	sub    $0xc,%esp
    15a3:	b9 10 00 00 00       	mov    $0x10,%ecx
    15a8:	6a 00                	push   $0x0
    15aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    15ad:	8b 45 08             	mov    0x8(%ebp),%eax
    15b0:	8b 13                	mov    (%ebx),%edx
    15b2:	e8 59 fe ff ff       	call   1410 <printint>
        ap++;
    15b7:	89 d8                	mov    %ebx,%eax
    15b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15bc:	31 d2                	xor    %edx,%edx
        ap++;
    15be:	83 c0 04             	add    $0x4,%eax
    15c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    15c4:	e9 4b ff ff ff       	jmp    1514 <printf+0x54>
    15c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    15d0:	83 ec 0c             	sub    $0xc,%esp
    15d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    15d8:	6a 01                	push   $0x1
    15da:	eb ce                	jmp    15aa <printf+0xea>
    15dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    15e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    15e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    15e6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    15e8:	6a 01                	push   $0x1
        ap++;
    15ea:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    15ed:	57                   	push   %edi
    15ee:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    15f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    15f4:	e8 6a fd ff ff       	call   1363 <write>
        ap++;
    15f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    15fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15ff:	31 d2                	xor    %edx,%edx
    1601:	e9 0e ff ff ff       	jmp    1514 <printf+0x54>
    1606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    160d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1610:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1613:	83 ec 04             	sub    $0x4,%esp
    1616:	e9 59 ff ff ff       	jmp    1574 <printf+0xb4>
    161b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    161f:	90                   	nop
        s = (char*)*ap;
    1620:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1623:	8b 18                	mov    (%eax),%ebx
        ap++;
    1625:	83 c0 04             	add    $0x4,%eax
    1628:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    162b:	85 db                	test   %ebx,%ebx
    162d:	74 17                	je     1646 <printf+0x186>
        while(*s != 0){
    162f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1632:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1634:	84 c0                	test   %al,%al
    1636:	0f 84 d8 fe ff ff    	je     1514 <printf+0x54>
    163c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    163f:	89 de                	mov    %ebx,%esi
    1641:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1644:	eb 1a                	jmp    1660 <printf+0x1a0>
          s = "(null)";
    1646:	bb 6b 18 00 00       	mov    $0x186b,%ebx
        while(*s != 0){
    164b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    164e:	b8 28 00 00 00       	mov    $0x28,%eax
    1653:	89 de                	mov    %ebx,%esi
    1655:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    165f:	90                   	nop
  write(fd, &c, 1);
    1660:	83 ec 04             	sub    $0x4,%esp
          s++;
    1663:	83 c6 01             	add    $0x1,%esi
    1666:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1669:	6a 01                	push   $0x1
    166b:	57                   	push   %edi
    166c:	53                   	push   %ebx
    166d:	e8 f1 fc ff ff       	call   1363 <write>
        while(*s != 0){
    1672:	0f b6 06             	movzbl (%esi),%eax
    1675:	83 c4 10             	add    $0x10,%esp
    1678:	84 c0                	test   %al,%al
    167a:	75 e4                	jne    1660 <printf+0x1a0>
    167c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    167f:	31 d2                	xor    %edx,%edx
    1681:	e9 8e fe ff ff       	jmp    1514 <printf+0x54>
    1686:	66 90                	xchg   %ax,%ax
    1688:	66 90                	xchg   %ax,%ax
    168a:	66 90                	xchg   %ax,%ax
    168c:	66 90                	xchg   %ax,%ax
    168e:	66 90                	xchg   %ax,%ax

00001690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1690:	f3 0f 1e fb          	endbr32 
    1694:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1695:	a1 24 1b 00 00       	mov    0x1b24,%eax
{
    169a:	89 e5                	mov    %esp,%ebp
    169c:	57                   	push   %edi
    169d:	56                   	push   %esi
    169e:	53                   	push   %ebx
    169f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16a2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    16a4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16a7:	39 c8                	cmp    %ecx,%eax
    16a9:	73 15                	jae    16c0 <free+0x30>
    16ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16af:	90                   	nop
    16b0:	39 d1                	cmp    %edx,%ecx
    16b2:	72 14                	jb     16c8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16b4:	39 d0                	cmp    %edx,%eax
    16b6:	73 10                	jae    16c8 <free+0x38>
{
    16b8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16ba:	8b 10                	mov    (%eax),%edx
    16bc:	39 c8                	cmp    %ecx,%eax
    16be:	72 f0                	jb     16b0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c0:	39 d0                	cmp    %edx,%eax
    16c2:	72 f4                	jb     16b8 <free+0x28>
    16c4:	39 d1                	cmp    %edx,%ecx
    16c6:	73 f0                	jae    16b8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16ce:	39 fa                	cmp    %edi,%edx
    16d0:	74 1e                	je     16f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    16d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    16d5:	8b 50 04             	mov    0x4(%eax),%edx
    16d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    16db:	39 f1                	cmp    %esi,%ecx
    16dd:	74 28                	je     1707 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    16df:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    16e1:	5b                   	pop    %ebx
  freep = p;
    16e2:	a3 24 1b 00 00       	mov    %eax,0x1b24
}
    16e7:	5e                   	pop    %esi
    16e8:	5f                   	pop    %edi
    16e9:	5d                   	pop    %ebp
    16ea:	c3                   	ret    
    16eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16ef:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    16f0:	03 72 04             	add    0x4(%edx),%esi
    16f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    16f6:	8b 10                	mov    (%eax),%edx
    16f8:	8b 12                	mov    (%edx),%edx
    16fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    16fd:	8b 50 04             	mov    0x4(%eax),%edx
    1700:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1703:	39 f1                	cmp    %esi,%ecx
    1705:	75 d8                	jne    16df <free+0x4f>
    p->s.size += bp->s.size;
    1707:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    170a:	a3 24 1b 00 00       	mov    %eax,0x1b24
    p->s.size += bp->s.size;
    170f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1712:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1715:	89 10                	mov    %edx,(%eax)
}
    1717:	5b                   	pop    %ebx
    1718:	5e                   	pop    %esi
    1719:	5f                   	pop    %edi
    171a:	5d                   	pop    %ebp
    171b:	c3                   	ret    
    171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1720:	f3 0f 1e fb          	endbr32 
    1724:	55                   	push   %ebp
    1725:	89 e5                	mov    %esp,%ebp
    1727:	57                   	push   %edi
    1728:	56                   	push   %esi
    1729:	53                   	push   %ebx
    172a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    172d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1730:	8b 3d 24 1b 00 00    	mov    0x1b24,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1736:	8d 70 07             	lea    0x7(%eax),%esi
    1739:	c1 ee 03             	shr    $0x3,%esi
    173c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    173f:	85 ff                	test   %edi,%edi
    1741:	0f 84 a9 00 00 00    	je     17f0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1747:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1749:	8b 48 04             	mov    0x4(%eax),%ecx
    174c:	39 f1                	cmp    %esi,%ecx
    174e:	73 6d                	jae    17bd <malloc+0x9d>
    1750:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1756:	bb 00 10 00 00       	mov    $0x1000,%ebx
    175b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    175e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1765:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1768:	eb 17                	jmp    1781 <malloc+0x61>
    176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1770:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1772:	8b 4a 04             	mov    0x4(%edx),%ecx
    1775:	39 f1                	cmp    %esi,%ecx
    1777:	73 4f                	jae    17c8 <malloc+0xa8>
    1779:	8b 3d 24 1b 00 00    	mov    0x1b24,%edi
    177f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1781:	39 c7                	cmp    %eax,%edi
    1783:	75 eb                	jne    1770 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1785:	83 ec 0c             	sub    $0xc,%esp
    1788:	ff 75 e4             	pushl  -0x1c(%ebp)
    178b:	e8 3b fc ff ff       	call   13cb <sbrk>
  if(p == (char*)-1)
    1790:	83 c4 10             	add    $0x10,%esp
    1793:	83 f8 ff             	cmp    $0xffffffff,%eax
    1796:	74 1b                	je     17b3 <malloc+0x93>
  hp->s.size = nu;
    1798:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    179b:	83 ec 0c             	sub    $0xc,%esp
    179e:	83 c0 08             	add    $0x8,%eax
    17a1:	50                   	push   %eax
    17a2:	e8 e9 fe ff ff       	call   1690 <free>
  return freep;
    17a7:	a1 24 1b 00 00       	mov    0x1b24,%eax
      if((p = morecore(nunits)) == 0)
    17ac:	83 c4 10             	add    $0x10,%esp
    17af:	85 c0                	test   %eax,%eax
    17b1:	75 bd                	jne    1770 <malloc+0x50>
        return 0;
  }
}
    17b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    17b6:	31 c0                	xor    %eax,%eax
}
    17b8:	5b                   	pop    %ebx
    17b9:	5e                   	pop    %esi
    17ba:	5f                   	pop    %edi
    17bb:	5d                   	pop    %ebp
    17bc:	c3                   	ret    
    if(p->s.size >= nunits){
    17bd:	89 c2                	mov    %eax,%edx
    17bf:	89 f8                	mov    %edi,%eax
    17c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    17c8:	39 ce                	cmp    %ecx,%esi
    17ca:	74 54                	je     1820 <malloc+0x100>
        p->s.size -= nunits;
    17cc:	29 f1                	sub    %esi,%ecx
    17ce:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    17d1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    17d4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    17d7:	a3 24 1b 00 00       	mov    %eax,0x1b24
}
    17dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    17df:	8d 42 08             	lea    0x8(%edx),%eax
}
    17e2:	5b                   	pop    %ebx
    17e3:	5e                   	pop    %esi
    17e4:	5f                   	pop    %edi
    17e5:	5d                   	pop    %ebp
    17e6:	c3                   	ret    
    17e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    17ee:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    17f0:	c7 05 24 1b 00 00 28 	movl   $0x1b28,0x1b24
    17f7:	1b 00 00 
    base.s.size = 0;
    17fa:	bf 28 1b 00 00       	mov    $0x1b28,%edi
    base.s.ptr = freep = prevp = &base;
    17ff:	c7 05 28 1b 00 00 28 	movl   $0x1b28,0x1b28
    1806:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1809:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    180b:	c7 05 2c 1b 00 00 00 	movl   $0x0,0x1b2c
    1812:	00 00 00 
    if(p->s.size >= nunits){
    1815:	e9 36 ff ff ff       	jmp    1750 <malloc+0x30>
    181a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1820:	8b 0a                	mov    (%edx),%ecx
    1822:	89 08                	mov    %ecx,(%eax)
    1824:	eb b1                	jmp    17d7 <malloc+0xb7>
