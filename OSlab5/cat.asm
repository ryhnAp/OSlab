
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
  }
}

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fb          	endbr32 
    1004:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1008:	83 e4 f0             	and    $0xfffffff0,%esp
    100b:	ff 71 fc             	pushl  -0x4(%ecx)
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	57                   	push   %edi
    1012:	56                   	push   %esi
    1013:	be 01 00 00 00       	mov    $0x1,%esi
    1018:	53                   	push   %ebx
    1019:	51                   	push   %ecx
    101a:	83 ec 18             	sub    $0x18,%esp
    101d:	8b 01                	mov    (%ecx),%eax
    101f:	8b 59 04             	mov    0x4(%ecx),%ebx
    1022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1025:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
    1028:	83 f8 01             	cmp    $0x1,%eax
    102b:	7e 50                	jle    107d <main+0x7d>
    102d:	8d 76 00             	lea    0x0(%esi),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
    1030:	83 ec 08             	sub    $0x8,%esp
    1033:	6a 00                	push   $0x0
    1035:	ff 33                	pushl  (%ebx)
    1037:	e8 77 03 00 00       	call   13b3 <open>
    103c:	83 c4 10             	add    $0x10,%esp
    103f:	89 c7                	mov    %eax,%edi
    1041:	85 c0                	test   %eax,%eax
    1043:	78 24                	js     1069 <main+0x69>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
    1045:	83 ec 0c             	sub    $0xc,%esp
  for(i = 1; i < argc; i++){
    1048:	83 c6 01             	add    $0x1,%esi
    104b:	83 c3 04             	add    $0x4,%ebx
    cat(fd);
    104e:	50                   	push   %eax
    104f:	e8 3c 00 00 00       	call   1090 <cat>
    close(fd);
    1054:	89 3c 24             	mov    %edi,(%esp)
    1057:	e8 3f 03 00 00       	call   139b <close>
  for(i = 1; i < argc; i++){
    105c:	83 c4 10             	add    $0x10,%esp
    105f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
    1062:	75 cc                	jne    1030 <main+0x30>
  }
  exit();
    1064:	e8 0a 03 00 00       	call   1373 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
    1069:	50                   	push   %eax
    106a:	ff 33                	pushl  (%ebx)
    106c:	68 7b 18 00 00       	push   $0x187b
    1071:	6a 01                	push   $0x1
    1073:	e8 78 04 00 00       	call   14f0 <printf>
      exit();
    1078:	e8 f6 02 00 00       	call   1373 <exit>
    cat(0);
    107d:	83 ec 0c             	sub    $0xc,%esp
    1080:	6a 00                	push   $0x0
    1082:	e8 09 00 00 00       	call   1090 <cat>
    exit();
    1087:	e8 e7 02 00 00       	call   1373 <exit>
    108c:	66 90                	xchg   %ax,%ax
    108e:	66 90                	xchg   %ax,%ax

00001090 <cat>:
{
    1090:	f3 0f 1e fb          	endbr32 
    1094:	55                   	push   %ebp
    1095:	89 e5                	mov    %esp,%ebp
    1097:	56                   	push   %esi
    1098:	8b 75 08             	mov    0x8(%ebp),%esi
    109b:	53                   	push   %ebx
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    109c:	eb 19                	jmp    10b7 <cat+0x27>
    109e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
    10a0:	83 ec 04             	sub    $0x4,%esp
    10a3:	53                   	push   %ebx
    10a4:	68 a0 1b 00 00       	push   $0x1ba0
    10a9:	6a 01                	push   $0x1
    10ab:	e8 e3 02 00 00       	call   1393 <write>
    10b0:	83 c4 10             	add    $0x10,%esp
    10b3:	39 d8                	cmp    %ebx,%eax
    10b5:	75 25                	jne    10dc <cat+0x4c>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    10b7:	83 ec 04             	sub    $0x4,%esp
    10ba:	68 00 02 00 00       	push   $0x200
    10bf:	68 a0 1b 00 00       	push   $0x1ba0
    10c4:	56                   	push   %esi
    10c5:	e8 c1 02 00 00       	call   138b <read>
    10ca:	83 c4 10             	add    $0x10,%esp
    10cd:	89 c3                	mov    %eax,%ebx
    10cf:	85 c0                	test   %eax,%eax
    10d1:	7f cd                	jg     10a0 <cat+0x10>
  if(n < 0){
    10d3:	75 1b                	jne    10f0 <cat+0x60>
}
    10d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10d8:	5b                   	pop    %ebx
    10d9:	5e                   	pop    %esi
    10da:	5d                   	pop    %ebp
    10db:	c3                   	ret    
      printf(1, "cat: write error\n");
    10dc:	83 ec 08             	sub    $0x8,%esp
    10df:	68 58 18 00 00       	push   $0x1858
    10e4:	6a 01                	push   $0x1
    10e6:	e8 05 04 00 00       	call   14f0 <printf>
      exit();
    10eb:	e8 83 02 00 00       	call   1373 <exit>
    printf(1, "cat: read error\n");
    10f0:	50                   	push   %eax
    10f1:	50                   	push   %eax
    10f2:	68 6a 18 00 00       	push   $0x186a
    10f7:	6a 01                	push   $0x1
    10f9:	e8 f2 03 00 00       	call   14f0 <printf>
    exit();
    10fe:	e8 70 02 00 00       	call   1373 <exit>
    1103:	66 90                	xchg   %ax,%ax
    1105:	66 90                	xchg   %ax,%ax
    1107:	66 90                	xchg   %ax,%ax
    1109:	66 90                	xchg   %ax,%ax
    110b:	66 90                	xchg   %ax,%ax
    110d:	66 90                	xchg   %ax,%ax
    110f:	90                   	nop

00001110 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    1110:	f3 0f 1e fb          	endbr32 
    1114:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1115:	31 c0                	xor    %eax,%eax
{
    1117:	89 e5                	mov    %esp,%ebp
    1119:	53                   	push   %ebx
    111a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    111d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1120:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1124:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1127:	83 c0 01             	add    $0x1,%eax
    112a:	84 d2                	test   %dl,%dl
    112c:	75 f2                	jne    1120 <strcpy+0x10>
    ;
  return os;
}
    112e:	89 c8                	mov    %ecx,%eax
    1130:	5b                   	pop    %ebx
    1131:	5d                   	pop    %ebp
    1132:	c3                   	ret    
    1133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1140:	f3 0f 1e fb          	endbr32 
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	53                   	push   %ebx
    1148:	8b 4d 08             	mov    0x8(%ebp),%ecx
    114b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    114e:	0f b6 01             	movzbl (%ecx),%eax
    1151:	0f b6 1a             	movzbl (%edx),%ebx
    1154:	84 c0                	test   %al,%al
    1156:	75 19                	jne    1171 <strcmp+0x31>
    1158:	eb 26                	jmp    1180 <strcmp+0x40>
    115a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1160:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1164:	83 c1 01             	add    $0x1,%ecx
    1167:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    116a:	0f b6 1a             	movzbl (%edx),%ebx
    116d:	84 c0                	test   %al,%al
    116f:	74 0f                	je     1180 <strcmp+0x40>
    1171:	38 d8                	cmp    %bl,%al
    1173:	74 eb                	je     1160 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1175:	29 d8                	sub    %ebx,%eax
}
    1177:	5b                   	pop    %ebx
    1178:	5d                   	pop    %ebp
    1179:	c3                   	ret    
    117a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1180:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1182:	29 d8                	sub    %ebx,%eax
}
    1184:	5b                   	pop    %ebx
    1185:	5d                   	pop    %ebp
    1186:	c3                   	ret    
    1187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    118e:	66 90                	xchg   %ax,%ax

00001190 <strlen>:

uint
strlen(const char *s)
{
    1190:	f3 0f 1e fb          	endbr32 
    1194:	55                   	push   %ebp
    1195:	89 e5                	mov    %esp,%ebp
    1197:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    119a:	80 3a 00             	cmpb   $0x0,(%edx)
    119d:	74 21                	je     11c0 <strlen+0x30>
    119f:	31 c0                	xor    %eax,%eax
    11a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11a8:	83 c0 01             	add    $0x1,%eax
    11ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    11af:	89 c1                	mov    %eax,%ecx
    11b1:	75 f5                	jne    11a8 <strlen+0x18>
    ;
  return n;
}
    11b3:	89 c8                	mov    %ecx,%eax
    11b5:	5d                   	pop    %ebp
    11b6:	c3                   	ret    
    11b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    11c0:	31 c9                	xor    %ecx,%ecx
}
    11c2:	5d                   	pop    %ebp
    11c3:	89 c8                	mov    %ecx,%eax
    11c5:	c3                   	ret    
    11c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11cd:	8d 76 00             	lea    0x0(%esi),%esi

000011d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d0:	f3 0f 1e fb          	endbr32 
    11d4:	55                   	push   %ebp
    11d5:	89 e5                	mov    %esp,%ebp
    11d7:	57                   	push   %edi
    11d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11db:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11de:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e1:	89 d7                	mov    %edx,%edi
    11e3:	fc                   	cld    
    11e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11e6:	89 d0                	mov    %edx,%eax
    11e8:	5f                   	pop    %edi
    11e9:	5d                   	pop    %ebp
    11ea:	c3                   	ret    
    11eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11ef:	90                   	nop

000011f0 <strchr>:

char*
strchr(const char *s, char c)
{
    11f0:	f3 0f 1e fb          	endbr32 
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	8b 45 08             	mov    0x8(%ebp),%eax
    11fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    11fe:	0f b6 10             	movzbl (%eax),%edx
    1201:	84 d2                	test   %dl,%dl
    1203:	75 16                	jne    121b <strchr+0x2b>
    1205:	eb 21                	jmp    1228 <strchr+0x38>
    1207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    120e:	66 90                	xchg   %ax,%ax
    1210:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1214:	83 c0 01             	add    $0x1,%eax
    1217:	84 d2                	test   %dl,%dl
    1219:	74 0d                	je     1228 <strchr+0x38>
    if(*s == c)
    121b:	38 d1                	cmp    %dl,%cl
    121d:	75 f1                	jne    1210 <strchr+0x20>
      return (char*)s;
  return 0;
}
    121f:	5d                   	pop    %ebp
    1220:	c3                   	ret    
    1221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1228:	31 c0                	xor    %eax,%eax
}
    122a:	5d                   	pop    %ebp
    122b:	c3                   	ret    
    122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001230 <gets>:

char*
gets(char *buf, int max)
{
    1230:	f3 0f 1e fb          	endbr32 
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	57                   	push   %edi
    1238:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1239:	31 f6                	xor    %esi,%esi
{
    123b:	53                   	push   %ebx
    123c:	89 f3                	mov    %esi,%ebx
    123e:	83 ec 1c             	sub    $0x1c,%esp
    1241:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1244:	eb 33                	jmp    1279 <gets+0x49>
    1246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    124d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1250:	83 ec 04             	sub    $0x4,%esp
    1253:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1256:	6a 01                	push   $0x1
    1258:	50                   	push   %eax
    1259:	6a 00                	push   $0x0
    125b:	e8 2b 01 00 00       	call   138b <read>
    if(cc < 1)
    1260:	83 c4 10             	add    $0x10,%esp
    1263:	85 c0                	test   %eax,%eax
    1265:	7e 1c                	jle    1283 <gets+0x53>
      break;
    buf[i++] = c;
    1267:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    126b:	83 c7 01             	add    $0x1,%edi
    126e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1271:	3c 0a                	cmp    $0xa,%al
    1273:	74 23                	je     1298 <gets+0x68>
    1275:	3c 0d                	cmp    $0xd,%al
    1277:	74 1f                	je     1298 <gets+0x68>
  for(i=0; i+1 < max; ){
    1279:	83 c3 01             	add    $0x1,%ebx
    127c:	89 fe                	mov    %edi,%esi
    127e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1281:	7c cd                	jl     1250 <gets+0x20>
    1283:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    1285:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1288:	c6 03 00             	movb   $0x0,(%ebx)
}
    128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    128e:	5b                   	pop    %ebx
    128f:	5e                   	pop    %esi
    1290:	5f                   	pop    %edi
    1291:	5d                   	pop    %ebp
    1292:	c3                   	ret    
    1293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1297:	90                   	nop
    1298:	8b 75 08             	mov    0x8(%ebp),%esi
    129b:	8b 45 08             	mov    0x8(%ebp),%eax
    129e:	01 de                	add    %ebx,%esi
    12a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    12a2:	c6 03 00             	movb   $0x0,(%ebx)
}
    12a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12a8:	5b                   	pop    %ebx
    12a9:	5e                   	pop    %esi
    12aa:	5f                   	pop    %edi
    12ab:	5d                   	pop    %ebp
    12ac:	c3                   	ret    
    12ad:	8d 76 00             	lea    0x0(%esi),%esi

000012b0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12b0:	f3 0f 1e fb          	endbr32 
    12b4:	55                   	push   %ebp
    12b5:	89 e5                	mov    %esp,%ebp
    12b7:	56                   	push   %esi
    12b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b9:	83 ec 08             	sub    $0x8,%esp
    12bc:	6a 00                	push   $0x0
    12be:	ff 75 08             	pushl  0x8(%ebp)
    12c1:	e8 ed 00 00 00       	call   13b3 <open>
  if(fd < 0)
    12c6:	83 c4 10             	add    $0x10,%esp
    12c9:	85 c0                	test   %eax,%eax
    12cb:	78 2b                	js     12f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    12cd:	83 ec 08             	sub    $0x8,%esp
    12d0:	ff 75 0c             	pushl  0xc(%ebp)
    12d3:	89 c3                	mov    %eax,%ebx
    12d5:	50                   	push   %eax
    12d6:	e8 f0 00 00 00       	call   13cb <fstat>
  close(fd);
    12db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12de:	89 c6                	mov    %eax,%esi
  close(fd);
    12e0:	e8 b6 00 00 00       	call   139b <close>
  return r;
    12e5:	83 c4 10             	add    $0x10,%esp
}
    12e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12eb:	89 f0                	mov    %esi,%eax
    12ed:	5b                   	pop    %ebx
    12ee:	5e                   	pop    %esi
    12ef:	5d                   	pop    %ebp
    12f0:	c3                   	ret    
    12f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    12f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12fd:	eb e9                	jmp    12e8 <stat+0x38>
    12ff:	90                   	nop

00001300 <atoi>:

int
atoi(const char *s)
{
    1300:	f3 0f 1e fb          	endbr32 
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	53                   	push   %ebx
    1308:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    130b:	0f be 02             	movsbl (%edx),%eax
    130e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1311:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1314:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1319:	77 1a                	ja     1335 <atoi+0x35>
    131b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    131f:	90                   	nop
    n = n*10 + *s++ - '0';
    1320:	83 c2 01             	add    $0x1,%edx
    1323:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1326:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    132a:	0f be 02             	movsbl (%edx),%eax
    132d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1330:	80 fb 09             	cmp    $0x9,%bl
    1333:	76 eb                	jbe    1320 <atoi+0x20>
  return n;
}
    1335:	89 c8                	mov    %ecx,%eax
    1337:	5b                   	pop    %ebx
    1338:	5d                   	pop    %ebp
    1339:	c3                   	ret    
    133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1340:	f3 0f 1e fb          	endbr32 
    1344:	55                   	push   %ebp
    1345:	89 e5                	mov    %esp,%ebp
    1347:	57                   	push   %edi
    1348:	8b 45 10             	mov    0x10(%ebp),%eax
    134b:	8b 55 08             	mov    0x8(%ebp),%edx
    134e:	56                   	push   %esi
    134f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1352:	85 c0                	test   %eax,%eax
    1354:	7e 0f                	jle    1365 <memmove+0x25>
    1356:	01 d0                	add    %edx,%eax
  dst = vdst;
    1358:	89 d7                	mov    %edx,%edi
    135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1360:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1361:	39 f8                	cmp    %edi,%eax
    1363:	75 fb                	jne    1360 <memmove+0x20>
  return vdst;
}
    1365:	5e                   	pop    %esi
    1366:	89 d0                	mov    %edx,%eax
    1368:	5f                   	pop    %edi
    1369:	5d                   	pop    %ebp
    136a:	c3                   	ret    

0000136b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136b:	b8 01 00 00 00       	mov    $0x1,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <exit>:
SYSCALL(exit)
    1373:	b8 02 00 00 00       	mov    $0x2,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <wait>:
SYSCALL(wait)
    137b:	b8 03 00 00 00       	mov    $0x3,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <pipe>:
SYSCALL(pipe)
    1383:	b8 04 00 00 00       	mov    $0x4,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <read>:
SYSCALL(read)
    138b:	b8 05 00 00 00       	mov    $0x5,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <write>:
SYSCALL(write)
    1393:	b8 10 00 00 00       	mov    $0x10,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <close>:
SYSCALL(close)
    139b:	b8 15 00 00 00       	mov    $0x15,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <kill>:
SYSCALL(kill)
    13a3:	b8 06 00 00 00       	mov    $0x6,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <exec>:
SYSCALL(exec)
    13ab:	b8 07 00 00 00       	mov    $0x7,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <open>:
SYSCALL(open)
    13b3:	b8 0f 00 00 00       	mov    $0xf,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <mknod>:
SYSCALL(mknod)
    13bb:	b8 11 00 00 00       	mov    $0x11,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <unlink>:
SYSCALL(unlink)
    13c3:	b8 12 00 00 00       	mov    $0x12,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <fstat>:
SYSCALL(fstat)
    13cb:	b8 08 00 00 00       	mov    $0x8,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <link>:
SYSCALL(link)
    13d3:	b8 13 00 00 00       	mov    $0x13,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <mkdir>:
SYSCALL(mkdir)
    13db:	b8 14 00 00 00       	mov    $0x14,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <chdir>:
SYSCALL(chdir)
    13e3:	b8 09 00 00 00       	mov    $0x9,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <dup>:
SYSCALL(dup)
    13eb:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <getpid>:
SYSCALL(getpid)
    13f3:	b8 0b 00 00 00       	mov    $0xb,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <sbrk>:
SYSCALL(sbrk)
    13fb:	b8 0c 00 00 00       	mov    $0xc,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <sleep>:
SYSCALL(sleep)
    1403:	b8 0d 00 00 00       	mov    $0xd,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <uptime>:
SYSCALL(uptime)
    140b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <provide_protection>:
SYSCALL(provide_protection)
    1413:	b8 18 00 00 00       	mov    $0x18,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <refuse_protection>:
SYSCALL(refuse_protection)
    141b:	b8 19 00 00 00       	mov    $0x19,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <settickets>:
SYSCALL(settickets) 
    1423:	b8 16 00 00 00       	mov    $0x16,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <getpinfo>:
    142b:	b8 17 00 00 00       	mov    $0x17,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    
    1433:	66 90                	xchg   %ax,%ax
    1435:	66 90                	xchg   %ax,%ax
    1437:	66 90                	xchg   %ax,%ax
    1439:	66 90                	xchg   %ax,%ax
    143b:	66 90                	xchg   %ax,%ax
    143d:	66 90                	xchg   %ax,%ax
    143f:	90                   	nop

00001440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	57                   	push   %edi
    1444:	56                   	push   %esi
    1445:	53                   	push   %ebx
    1446:	83 ec 3c             	sub    $0x3c,%esp
    1449:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    144c:	89 d1                	mov    %edx,%ecx
{
    144e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1451:	85 d2                	test   %edx,%edx
    1453:	0f 89 7f 00 00 00    	jns    14d8 <printint+0x98>
    1459:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    145d:	74 79                	je     14d8 <printint+0x98>
    neg = 1;
    145f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1466:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1468:	31 db                	xor    %ebx,%ebx
    146a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    146d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1470:	89 c8                	mov    %ecx,%eax
    1472:	31 d2                	xor    %edx,%edx
    1474:	89 cf                	mov    %ecx,%edi
    1476:	f7 75 c4             	divl   -0x3c(%ebp)
    1479:	0f b6 92 98 18 00 00 	movzbl 0x1898(%edx),%edx
    1480:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1483:	89 d8                	mov    %ebx,%eax
    1485:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1488:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    148b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    148e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1491:	76 dd                	jbe    1470 <printint+0x30>
  if(neg)
    1493:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1496:	85 c9                	test   %ecx,%ecx
    1498:	74 0c                	je     14a6 <printint+0x66>
    buf[i++] = '-';
    149a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    149f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    14a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    14a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    14a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    14ad:	eb 07                	jmp    14b6 <printint+0x76>
    14af:	90                   	nop
    14b0:	0f b6 13             	movzbl (%ebx),%edx
    14b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    14b6:	83 ec 04             	sub    $0x4,%esp
    14b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    14bc:	6a 01                	push   $0x1
    14be:	56                   	push   %esi
    14bf:	57                   	push   %edi
    14c0:	e8 ce fe ff ff       	call   1393 <write>
  while(--i >= 0)
    14c5:	83 c4 10             	add    $0x10,%esp
    14c8:	39 de                	cmp    %ebx,%esi
    14ca:	75 e4                	jne    14b0 <printint+0x70>
    putc(fd, buf[i]);
}
    14cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14cf:	5b                   	pop    %ebx
    14d0:	5e                   	pop    %esi
    14d1:	5f                   	pop    %edi
    14d2:	5d                   	pop    %ebp
    14d3:	c3                   	ret    
    14d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    14df:	eb 87                	jmp    1468 <printint+0x28>
    14e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14ef:	90                   	nop

000014f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    14f0:	f3 0f 1e fb          	endbr32 
    14f4:	55                   	push   %ebp
    14f5:	89 e5                	mov    %esp,%ebp
    14f7:	57                   	push   %edi
    14f8:	56                   	push   %esi
    14f9:	53                   	push   %ebx
    14fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14fd:	8b 75 0c             	mov    0xc(%ebp),%esi
    1500:	0f b6 1e             	movzbl (%esi),%ebx
    1503:	84 db                	test   %bl,%bl
    1505:	0f 84 b4 00 00 00    	je     15bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    150b:	8d 45 10             	lea    0x10(%ebp),%eax
    150e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1511:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1514:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1516:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1519:	eb 33                	jmp    154e <printf+0x5e>
    151b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    151f:	90                   	nop
    1520:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1523:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1528:	83 f8 25             	cmp    $0x25,%eax
    152b:	74 17                	je     1544 <printf+0x54>
  write(fd, &c, 1);
    152d:	83 ec 04             	sub    $0x4,%esp
    1530:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1533:	6a 01                	push   $0x1
    1535:	57                   	push   %edi
    1536:	ff 75 08             	pushl  0x8(%ebp)
    1539:	e8 55 fe ff ff       	call   1393 <write>
    153e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1541:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1544:	0f b6 1e             	movzbl (%esi),%ebx
    1547:	83 c6 01             	add    $0x1,%esi
    154a:	84 db                	test   %bl,%bl
    154c:	74 71                	je     15bf <printf+0xcf>
    c = fmt[i] & 0xff;
    154e:	0f be cb             	movsbl %bl,%ecx
    1551:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1554:	85 d2                	test   %edx,%edx
    1556:	74 c8                	je     1520 <printf+0x30>
      }
    } else if(state == '%'){
    1558:	83 fa 25             	cmp    $0x25,%edx
    155b:	75 e7                	jne    1544 <printf+0x54>
      if(c == 'd'){
    155d:	83 f8 64             	cmp    $0x64,%eax
    1560:	0f 84 9a 00 00 00    	je     1600 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1566:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    156c:	83 f9 70             	cmp    $0x70,%ecx
    156f:	74 5f                	je     15d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1571:	83 f8 73             	cmp    $0x73,%eax
    1574:	0f 84 d6 00 00 00    	je     1650 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    157a:	83 f8 63             	cmp    $0x63,%eax
    157d:	0f 84 8d 00 00 00    	je     1610 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1583:	83 f8 25             	cmp    $0x25,%eax
    1586:	0f 84 b4 00 00 00    	je     1640 <printf+0x150>
  write(fd, &c, 1);
    158c:	83 ec 04             	sub    $0x4,%esp
    158f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1593:	6a 01                	push   $0x1
    1595:	57                   	push   %edi
    1596:	ff 75 08             	pushl  0x8(%ebp)
    1599:	e8 f5 fd ff ff       	call   1393 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    159e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    15a1:	83 c4 0c             	add    $0xc,%esp
    15a4:	6a 01                	push   $0x1
    15a6:	83 c6 01             	add    $0x1,%esi
    15a9:	57                   	push   %edi
    15aa:	ff 75 08             	pushl  0x8(%ebp)
    15ad:	e8 e1 fd ff ff       	call   1393 <write>
  for(i = 0; fmt[i]; i++){
    15b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    15b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    15b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    15bb:	84 db                	test   %bl,%bl
    15bd:	75 8f                	jne    154e <printf+0x5e>
    }
  }
}
    15bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15c2:	5b                   	pop    %ebx
    15c3:	5e                   	pop    %esi
    15c4:	5f                   	pop    %edi
    15c5:	5d                   	pop    %ebp
    15c6:	c3                   	ret    
    15c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    15d0:	83 ec 0c             	sub    $0xc,%esp
    15d3:	b9 10 00 00 00       	mov    $0x10,%ecx
    15d8:	6a 00                	push   $0x0
    15da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    15dd:	8b 45 08             	mov    0x8(%ebp),%eax
    15e0:	8b 13                	mov    (%ebx),%edx
    15e2:	e8 59 fe ff ff       	call   1440 <printint>
        ap++;
    15e7:	89 d8                	mov    %ebx,%eax
    15e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15ec:	31 d2                	xor    %edx,%edx
        ap++;
    15ee:	83 c0 04             	add    $0x4,%eax
    15f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    15f4:	e9 4b ff ff ff       	jmp    1544 <printf+0x54>
    15f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1600:	83 ec 0c             	sub    $0xc,%esp
    1603:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1608:	6a 01                	push   $0x1
    160a:	eb ce                	jmp    15da <printf+0xea>
    160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1610:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1616:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1618:	6a 01                	push   $0x1
        ap++;
    161a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    161d:	57                   	push   %edi
    161e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1621:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1624:	e8 6a fd ff ff       	call   1393 <write>
        ap++;
    1629:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    162c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    162f:	31 d2                	xor    %edx,%edx
    1631:	e9 0e ff ff ff       	jmp    1544 <printf+0x54>
    1636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    163d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1640:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1643:	83 ec 04             	sub    $0x4,%esp
    1646:	e9 59 ff ff ff       	jmp    15a4 <printf+0xb4>
    164b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    164f:	90                   	nop
        s = (char*)*ap;
    1650:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1653:	8b 18                	mov    (%eax),%ebx
        ap++;
    1655:	83 c0 04             	add    $0x4,%eax
    1658:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    165b:	85 db                	test   %ebx,%ebx
    165d:	74 17                	je     1676 <printf+0x186>
        while(*s != 0){
    165f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1662:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1664:	84 c0                	test   %al,%al
    1666:	0f 84 d8 fe ff ff    	je     1544 <printf+0x54>
    166c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    166f:	89 de                	mov    %ebx,%esi
    1671:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1674:	eb 1a                	jmp    1690 <printf+0x1a0>
          s = "(null)";
    1676:	bb 90 18 00 00       	mov    $0x1890,%ebx
        while(*s != 0){
    167b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    167e:	b8 28 00 00 00       	mov    $0x28,%eax
    1683:	89 de                	mov    %ebx,%esi
    1685:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    168f:	90                   	nop
  write(fd, &c, 1);
    1690:	83 ec 04             	sub    $0x4,%esp
          s++;
    1693:	83 c6 01             	add    $0x1,%esi
    1696:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1699:	6a 01                	push   $0x1
    169b:	57                   	push   %edi
    169c:	53                   	push   %ebx
    169d:	e8 f1 fc ff ff       	call   1393 <write>
        while(*s != 0){
    16a2:	0f b6 06             	movzbl (%esi),%eax
    16a5:	83 c4 10             	add    $0x10,%esp
    16a8:	84 c0                	test   %al,%al
    16aa:	75 e4                	jne    1690 <printf+0x1a0>
    16ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    16af:	31 d2                	xor    %edx,%edx
    16b1:	e9 8e fe ff ff       	jmp    1544 <printf+0x54>
    16b6:	66 90                	xchg   %ax,%ax
    16b8:	66 90                	xchg   %ax,%ax
    16ba:	66 90                	xchg   %ax,%ax
    16bc:	66 90                	xchg   %ax,%ax
    16be:	66 90                	xchg   %ax,%ax

000016c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16c0:	f3 0f 1e fb          	endbr32 
    16c4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16c5:	a1 80 1b 00 00       	mov    0x1b80,%eax
{
    16ca:	89 e5                	mov    %esp,%ebp
    16cc:	57                   	push   %edi
    16cd:	56                   	push   %esi
    16ce:	53                   	push   %ebx
    16cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16d2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    16d4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16d7:	39 c8                	cmp    %ecx,%eax
    16d9:	73 15                	jae    16f0 <free+0x30>
    16db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16df:	90                   	nop
    16e0:	39 d1                	cmp    %edx,%ecx
    16e2:	72 14                	jb     16f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16e4:	39 d0                	cmp    %edx,%eax
    16e6:	73 10                	jae    16f8 <free+0x38>
{
    16e8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16ea:	8b 10                	mov    (%eax),%edx
    16ec:	39 c8                	cmp    %ecx,%eax
    16ee:	72 f0                	jb     16e0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f0:	39 d0                	cmp    %edx,%eax
    16f2:	72 f4                	jb     16e8 <free+0x28>
    16f4:	39 d1                	cmp    %edx,%ecx
    16f6:	73 f0                	jae    16e8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16fe:	39 fa                	cmp    %edi,%edx
    1700:	74 1e                	je     1720 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1702:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1705:	8b 50 04             	mov    0x4(%eax),%edx
    1708:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    170b:	39 f1                	cmp    %esi,%ecx
    170d:	74 28                	je     1737 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    170f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1711:	5b                   	pop    %ebx
  freep = p;
    1712:	a3 80 1b 00 00       	mov    %eax,0x1b80
}
    1717:	5e                   	pop    %esi
    1718:	5f                   	pop    %edi
    1719:	5d                   	pop    %ebp
    171a:	c3                   	ret    
    171b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    171f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1720:	03 72 04             	add    0x4(%edx),%esi
    1723:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1726:	8b 10                	mov    (%eax),%edx
    1728:	8b 12                	mov    (%edx),%edx
    172a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    172d:	8b 50 04             	mov    0x4(%eax),%edx
    1730:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1733:	39 f1                	cmp    %esi,%ecx
    1735:	75 d8                	jne    170f <free+0x4f>
    p->s.size += bp->s.size;
    1737:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    173a:	a3 80 1b 00 00       	mov    %eax,0x1b80
    p->s.size += bp->s.size;
    173f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1742:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1745:	89 10                	mov    %edx,(%eax)
}
    1747:	5b                   	pop    %ebx
    1748:	5e                   	pop    %esi
    1749:	5f                   	pop    %edi
    174a:	5d                   	pop    %ebp
    174b:	c3                   	ret    
    174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1750:	f3 0f 1e fb          	endbr32 
    1754:	55                   	push   %ebp
    1755:	89 e5                	mov    %esp,%ebp
    1757:	57                   	push   %edi
    1758:	56                   	push   %esi
    1759:	53                   	push   %ebx
    175a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    175d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1760:	8b 3d 80 1b 00 00    	mov    0x1b80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1766:	8d 70 07             	lea    0x7(%eax),%esi
    1769:	c1 ee 03             	shr    $0x3,%esi
    176c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    176f:	85 ff                	test   %edi,%edi
    1771:	0f 84 a9 00 00 00    	je     1820 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1777:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1779:	8b 48 04             	mov    0x4(%eax),%ecx
    177c:	39 f1                	cmp    %esi,%ecx
    177e:	73 6d                	jae    17ed <malloc+0x9d>
    1780:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1786:	bb 00 10 00 00       	mov    $0x1000,%ebx
    178b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    178e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1795:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1798:	eb 17                	jmp    17b1 <malloc+0x61>
    179a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17a0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    17a2:	8b 4a 04             	mov    0x4(%edx),%ecx
    17a5:	39 f1                	cmp    %esi,%ecx
    17a7:	73 4f                	jae    17f8 <malloc+0xa8>
    17a9:	8b 3d 80 1b 00 00    	mov    0x1b80,%edi
    17af:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17b1:	39 c7                	cmp    %eax,%edi
    17b3:	75 eb                	jne    17a0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    17b5:	83 ec 0c             	sub    $0xc,%esp
    17b8:	ff 75 e4             	pushl  -0x1c(%ebp)
    17bb:	e8 3b fc ff ff       	call   13fb <sbrk>
  if(p == (char*)-1)
    17c0:	83 c4 10             	add    $0x10,%esp
    17c3:	83 f8 ff             	cmp    $0xffffffff,%eax
    17c6:	74 1b                	je     17e3 <malloc+0x93>
  hp->s.size = nu;
    17c8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17cb:	83 ec 0c             	sub    $0xc,%esp
    17ce:	83 c0 08             	add    $0x8,%eax
    17d1:	50                   	push   %eax
    17d2:	e8 e9 fe ff ff       	call   16c0 <free>
  return freep;
    17d7:	a1 80 1b 00 00       	mov    0x1b80,%eax
      if((p = morecore(nunits)) == 0)
    17dc:	83 c4 10             	add    $0x10,%esp
    17df:	85 c0                	test   %eax,%eax
    17e1:	75 bd                	jne    17a0 <malloc+0x50>
        return 0;
  }
}
    17e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    17e6:	31 c0                	xor    %eax,%eax
}
    17e8:	5b                   	pop    %ebx
    17e9:	5e                   	pop    %esi
    17ea:	5f                   	pop    %edi
    17eb:	5d                   	pop    %ebp
    17ec:	c3                   	ret    
    if(p->s.size >= nunits){
    17ed:	89 c2                	mov    %eax,%edx
    17ef:	89 f8                	mov    %edi,%eax
    17f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    17f8:	39 ce                	cmp    %ecx,%esi
    17fa:	74 54                	je     1850 <malloc+0x100>
        p->s.size -= nunits;
    17fc:	29 f1                	sub    %esi,%ecx
    17fe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1801:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1804:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1807:	a3 80 1b 00 00       	mov    %eax,0x1b80
}
    180c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    180f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1812:	5b                   	pop    %ebx
    1813:	5e                   	pop    %esi
    1814:	5f                   	pop    %edi
    1815:	5d                   	pop    %ebp
    1816:	c3                   	ret    
    1817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    181e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1820:	c7 05 80 1b 00 00 84 	movl   $0x1b84,0x1b80
    1827:	1b 00 00 
    base.s.size = 0;
    182a:	bf 84 1b 00 00       	mov    $0x1b84,%edi
    base.s.ptr = freep = prevp = &base;
    182f:	c7 05 84 1b 00 00 84 	movl   $0x1b84,0x1b84
    1836:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1839:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    183b:	c7 05 88 1b 00 00 00 	movl   $0x0,0x1b88
    1842:	00 00 00 
    if(p->s.size >= nunits){
    1845:	e9 36 ff ff ff       	jmp    1780 <malloc+0x30>
    184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1850:	8b 0a                	mov    (%edx),%ecx
    1852:	89 08                	mov    %ecx,(%eax)
    1854:	eb b1                	jmp    1807 <malloc+0xb7>
