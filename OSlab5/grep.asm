
_grep:     file format elf32-i386


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
    1013:	53                   	push   %ebx
    1014:	51                   	push   %ecx
    1015:	83 ec 18             	sub    $0x18,%esp
    1018:	8b 01                	mov    (%ecx),%eax
    101a:	8b 59 04             	mov    0x4(%ecx),%ebx
    101d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
    1020:	83 f8 01             	cmp    $0x1,%eax
    1023:	7e 6b                	jle    1090 <main+0x90>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
    1025:	8b 43 04             	mov    0x4(%ebx),%eax
    1028:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
    102b:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    102f:	be 02 00 00 00       	mov    $0x2,%esi
  pattern = argv[1];
    1034:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
    1037:	75 29                	jne    1062 <main+0x62>
    1039:	eb 68                	jmp    10a3 <main+0xa3>
    103b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    103f:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
    1040:	83 ec 08             	sub    $0x8,%esp
  for(i = 2; i < argc; i++){
    1043:	83 c6 01             	add    $0x1,%esi
    1046:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
    1049:	50                   	push   %eax
    104a:	ff 75 e0             	pushl  -0x20(%ebp)
    104d:	e8 de 01 00 00       	call   1230 <grep>
    close(fd);
    1052:	89 3c 24             	mov    %edi,(%esp)
    1055:	e8 71 05 00 00       	call   15cb <close>
  for(i = 2; i < argc; i++){
    105a:	83 c4 10             	add    $0x10,%esp
    105d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
    1060:	7e 29                	jle    108b <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
    1062:	83 ec 08             	sub    $0x8,%esp
    1065:	6a 00                	push   $0x0
    1067:	ff 33                	pushl  (%ebx)
    1069:	e8 75 05 00 00       	call   15e3 <open>
    106e:	83 c4 10             	add    $0x10,%esp
    1071:	89 c7                	mov    %eax,%edi
    1073:	85 c0                	test   %eax,%eax
    1075:	79 c9                	jns    1040 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1077:	50                   	push   %eax
    1078:	ff 33                	pushl  (%ebx)
    107a:	68 a8 1a 00 00       	push   $0x1aa8
    107f:	6a 01                	push   $0x1
    1081:	e8 9a 06 00 00       	call   1720 <printf>
      exit();
    1086:	e8 18 05 00 00       	call   15a3 <exit>
  }
  exit();
    108b:	e8 13 05 00 00       	call   15a3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
    1090:	51                   	push   %ecx
    1091:	51                   	push   %ecx
    1092:	68 88 1a 00 00       	push   $0x1a88
    1097:	6a 02                	push   $0x2
    1099:	e8 82 06 00 00       	call   1720 <printf>
    exit();
    109e:	e8 00 05 00 00       	call   15a3 <exit>
    grep(pattern, 0);
    10a3:	52                   	push   %edx
    10a4:	52                   	push   %edx
    10a5:	6a 00                	push   $0x0
    10a7:	50                   	push   %eax
    10a8:	e8 83 01 00 00       	call   1230 <grep>
    exit();
    10ad:	e8 f1 04 00 00       	call   15a3 <exit>
    10b2:	66 90                	xchg   %ax,%ax
    10b4:	66 90                	xchg   %ax,%ax
    10b6:	66 90                	xchg   %ax,%ax
    10b8:	66 90                	xchg   %ax,%ax
    10ba:	66 90                	xchg   %ax,%ax
    10bc:	66 90                	xchg   %ax,%ax
    10be:	66 90                	xchg   %ax,%ax

000010c0 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    10c0:	f3 0f 1e fb          	endbr32 
    10c4:	55                   	push   %ebp
    10c5:	89 e5                	mov    %esp,%ebp
    10c7:	57                   	push   %edi
    10c8:	56                   	push   %esi
    10c9:	53                   	push   %ebx
    10ca:	83 ec 0c             	sub    $0xc,%esp
    10cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10d0:	8b 75 0c             	mov    0xc(%ebp),%esi
    10d3:	8b 7d 10             	mov    0x10(%ebp),%edi
    10d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    10e0:	83 ec 08             	sub    $0x8,%esp
    10e3:	57                   	push   %edi
    10e4:	56                   	push   %esi
    10e5:	e8 36 00 00 00       	call   1120 <matchhere>
    10ea:	83 c4 10             	add    $0x10,%esp
    10ed:	85 c0                	test   %eax,%eax
    10ef:	75 1f                	jne    1110 <matchstar+0x50>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
    10f1:	0f be 17             	movsbl (%edi),%edx
    10f4:	84 d2                	test   %dl,%dl
    10f6:	74 0c                	je     1104 <matchstar+0x44>
    10f8:	83 c7 01             	add    $0x1,%edi
    10fb:	39 da                	cmp    %ebx,%edx
    10fd:	74 e1                	je     10e0 <matchstar+0x20>
    10ff:	83 fb 2e             	cmp    $0x2e,%ebx
    1102:	74 dc                	je     10e0 <matchstar+0x20>
  return 0;
}
    1104:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1107:	5b                   	pop    %ebx
    1108:	5e                   	pop    %esi
    1109:	5f                   	pop    %edi
    110a:	5d                   	pop    %ebp
    110b:	c3                   	ret    
    110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 1;
    1113:	b8 01 00 00 00       	mov    $0x1,%eax
}
    1118:	5b                   	pop    %ebx
    1119:	5e                   	pop    %esi
    111a:	5f                   	pop    %edi
    111b:	5d                   	pop    %ebp
    111c:	c3                   	ret    
    111d:	8d 76 00             	lea    0x0(%esi),%esi

00001120 <matchhere>:
{
    1120:	f3 0f 1e fb          	endbr32 
    1124:	55                   	push   %ebp
    1125:	89 e5                	mov    %esp,%ebp
    1127:	57                   	push   %edi
    1128:	56                   	push   %esi
    1129:	53                   	push   %ebx
    112a:	83 ec 0c             	sub    $0xc,%esp
    112d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1130:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(re[0] == '\0')
    1133:	0f b6 01             	movzbl (%ecx),%eax
    1136:	84 c0                	test   %al,%al
    1138:	75 2b                	jne    1165 <matchhere+0x45>
    113a:	eb 64                	jmp    11a0 <matchhere+0x80>
    113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(re[0] == '$' && re[1] == '\0')
    1140:	0f b6 37             	movzbl (%edi),%esi
    1143:	80 fa 24             	cmp    $0x24,%dl
    1146:	75 04                	jne    114c <matchhere+0x2c>
    1148:	84 c0                	test   %al,%al
    114a:	74 61                	je     11ad <matchhere+0x8d>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    114c:	89 f3                	mov    %esi,%ebx
    114e:	84 db                	test   %bl,%bl
    1150:	74 3e                	je     1190 <matchhere+0x70>
    1152:	80 fa 2e             	cmp    $0x2e,%dl
    1155:	74 04                	je     115b <matchhere+0x3b>
    1157:	38 d3                	cmp    %dl,%bl
    1159:	75 35                	jne    1190 <matchhere+0x70>
    return matchhere(re+1, text+1);
    115b:	83 c7 01             	add    $0x1,%edi
    115e:	83 c1 01             	add    $0x1,%ecx
  if(re[0] == '\0')
    1161:	84 c0                	test   %al,%al
    1163:	74 3b                	je     11a0 <matchhere+0x80>
  if(re[1] == '*')
    1165:	0f be d0             	movsbl %al,%edx
    1168:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    116c:	3c 2a                	cmp    $0x2a,%al
    116e:	75 d0                	jne    1140 <matchhere+0x20>
    return matchstar(re[0], re+2, text);
    1170:	83 ec 04             	sub    $0x4,%esp
    1173:	83 c1 02             	add    $0x2,%ecx
    1176:	57                   	push   %edi
    1177:	51                   	push   %ecx
    1178:	52                   	push   %edx
    1179:	e8 42 ff ff ff       	call   10c0 <matchstar>
    117e:	83 c4 10             	add    $0x10,%esp
}
    1181:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1184:	5b                   	pop    %ebx
    1185:	5e                   	pop    %esi
    1186:	5f                   	pop    %edi
    1187:	5d                   	pop    %ebp
    1188:	c3                   	ret    
    1189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
    1193:	31 c0                	xor    %eax,%eax
}
    1195:	5b                   	pop    %ebx
    1196:	5e                   	pop    %esi
    1197:	5f                   	pop    %edi
    1198:	5d                   	pop    %ebp
    1199:	c3                   	ret    
    119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 1;
    11a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
    11a8:	5b                   	pop    %ebx
    11a9:	5e                   	pop    %esi
    11aa:	5f                   	pop    %edi
    11ab:	5d                   	pop    %ebp
    11ac:	c3                   	ret    
    return *text == '\0';
    11ad:	89 f0                	mov    %esi,%eax
    11af:	84 c0                	test   %al,%al
    11b1:	0f 94 c0             	sete   %al
    11b4:	0f b6 c0             	movzbl %al,%eax
    11b7:	eb c8                	jmp    1181 <matchhere+0x61>
    11b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000011c0 <match>:
{
    11c0:	f3 0f 1e fb          	endbr32 
    11c4:	55                   	push   %ebp
    11c5:	89 e5                	mov    %esp,%ebp
    11c7:	56                   	push   %esi
    11c8:	53                   	push   %ebx
    11c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    11cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
    11cf:	80 3b 5e             	cmpb   $0x5e,(%ebx)
    11d2:	75 15                	jne    11e9 <match+0x29>
    11d4:	eb 3a                	jmp    1210 <match+0x50>
    11d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11dd:	8d 76 00             	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
    11e0:	83 c6 01             	add    $0x1,%esi
    11e3:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
    11e7:	74 16                	je     11ff <match+0x3f>
    if(matchhere(re, text))
    11e9:	83 ec 08             	sub    $0x8,%esp
    11ec:	56                   	push   %esi
    11ed:	53                   	push   %ebx
    11ee:	e8 2d ff ff ff       	call   1120 <matchhere>
    11f3:	83 c4 10             	add    $0x10,%esp
    11f6:	85 c0                	test   %eax,%eax
    11f8:	74 e6                	je     11e0 <match+0x20>
      return 1;
    11fa:	b8 01 00 00 00       	mov    $0x1,%eax
}
    11ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1202:	5b                   	pop    %ebx
    1203:	5e                   	pop    %esi
    1204:	5d                   	pop    %ebp
    1205:	c3                   	ret    
    1206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    120d:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
    1210:	83 c3 01             	add    $0x1,%ebx
    1213:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    1216:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1219:	5b                   	pop    %ebx
    121a:	5e                   	pop    %esi
    121b:	5d                   	pop    %ebp
    return matchhere(re+1, text);
    121c:	e9 ff fe ff ff       	jmp    1120 <matchhere>
    1221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    122f:	90                   	nop

00001230 <grep>:
{
    1230:	f3 0f 1e fb          	endbr32 
    1234:	55                   	push   %ebp
    1235:	89 e5                	mov    %esp,%ebp
    1237:	57                   	push   %edi
    1238:	56                   	push   %esi
    1239:	53                   	push   %ebx
    123a:	83 ec 1c             	sub    $0x1c,%esp
  m = 0;
    123d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
    1244:	8b 75 08             	mov    0x8(%ebp),%esi
    1247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    124e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1250:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    1253:	b8 ff 03 00 00       	mov    $0x3ff,%eax
    1258:	83 ec 04             	sub    $0x4,%esp
    125b:	29 c8                	sub    %ecx,%eax
    125d:	50                   	push   %eax
    125e:	8d 81 a0 1e 00 00    	lea    0x1ea0(%ecx),%eax
    1264:	50                   	push   %eax
    1265:	ff 75 0c             	pushl  0xc(%ebp)
    1268:	e8 4e 03 00 00       	call   15bb <read>
    126d:	83 c4 10             	add    $0x10,%esp
    1270:	85 c0                	test   %eax,%eax
    1272:	0f 8e b8 00 00 00    	jle    1330 <grep+0x100>
    m += n;
    1278:	01 45 e4             	add    %eax,-0x1c(%ebp)
    127b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p = buf;
    127e:	bb a0 1e 00 00       	mov    $0x1ea0,%ebx
    buf[m] = '\0';
    1283:	c6 81 a0 1e 00 00 00 	movb   $0x0,0x1ea0(%ecx)
    while((q = strchr(p, '\n')) != 0){
    128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1290:	83 ec 08             	sub    $0x8,%esp
    1293:	6a 0a                	push   $0xa
    1295:	53                   	push   %ebx
    1296:	e8 85 01 00 00       	call   1420 <strchr>
    129b:	83 c4 10             	add    $0x10,%esp
    129e:	89 c7                	mov    %eax,%edi
    12a0:	85 c0                	test   %eax,%eax
    12a2:	74 3c                	je     12e0 <grep+0xb0>
      if(match(pattern, p)){
    12a4:	83 ec 08             	sub    $0x8,%esp
      *q = 0;
    12a7:	c6 07 00             	movb   $0x0,(%edi)
      if(match(pattern, p)){
    12aa:	53                   	push   %ebx
    12ab:	56                   	push   %esi
    12ac:	e8 0f ff ff ff       	call   11c0 <match>
    12b1:	83 c4 10             	add    $0x10,%esp
    12b4:	8d 57 01             	lea    0x1(%edi),%edx
    12b7:	85 c0                	test   %eax,%eax
    12b9:	75 05                	jne    12c0 <grep+0x90>
      p = q+1;
    12bb:	89 d3                	mov    %edx,%ebx
    12bd:	eb d1                	jmp    1290 <grep+0x60>
    12bf:	90                   	nop
        write(1, p, q+1 - p);
    12c0:	89 d0                	mov    %edx,%eax
    12c2:	83 ec 04             	sub    $0x4,%esp
        *q = '\n';
    12c5:	c6 07 0a             	movb   $0xa,(%edi)
        write(1, p, q+1 - p);
    12c8:	29 d8                	sub    %ebx,%eax
    12ca:	89 55 e0             	mov    %edx,-0x20(%ebp)
    12cd:	50                   	push   %eax
    12ce:	53                   	push   %ebx
    12cf:	6a 01                	push   $0x1
    12d1:	e8 ed 02 00 00       	call   15c3 <write>
    12d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    12d9:	83 c4 10             	add    $0x10,%esp
      p = q+1;
    12dc:	89 d3                	mov    %edx,%ebx
    12de:	eb b0                	jmp    1290 <grep+0x60>
    if(p == buf)
    12e0:	81 fb a0 1e 00 00    	cmp    $0x1ea0,%ebx
    12e6:	74 38                	je     1320 <grep+0xf0>
    if(m > 0){
    12e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    12eb:	85 c9                	test   %ecx,%ecx
    12ed:	0f 8e 5d ff ff ff    	jle    1250 <grep+0x20>
      m -= p - buf;
    12f3:	89 d8                	mov    %ebx,%eax
      memmove(buf, p, m);
    12f5:	83 ec 04             	sub    $0x4,%esp
      m -= p - buf;
    12f8:	2d a0 1e 00 00       	sub    $0x1ea0,%eax
    12fd:	29 c1                	sub    %eax,%ecx
      memmove(buf, p, m);
    12ff:	51                   	push   %ecx
    1300:	53                   	push   %ebx
    1301:	68 a0 1e 00 00       	push   $0x1ea0
      m -= p - buf;
    1306:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
    1309:	e8 62 02 00 00       	call   1570 <memmove>
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	e9 3a ff ff ff       	jmp    1250 <grep+0x20>
    1316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    131d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 0;
    1320:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1327:	e9 24 ff ff ff       	jmp    1250 <grep+0x20>
    132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
    1330:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1333:	5b                   	pop    %ebx
    1334:	5e                   	pop    %esi
    1335:	5f                   	pop    %edi
    1336:	5d                   	pop    %ebp
    1337:	c3                   	ret    
    1338:	66 90                	xchg   %ax,%ax
    133a:	66 90                	xchg   %ax,%ax
    133c:	66 90                	xchg   %ax,%ax
    133e:	66 90                	xchg   %ax,%ax

00001340 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    1340:	f3 0f 1e fb          	endbr32 
    1344:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1345:	31 c0                	xor    %eax,%eax
{
    1347:	89 e5                	mov    %esp,%ebp
    1349:	53                   	push   %ebx
    134a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    134d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1350:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1354:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1357:	83 c0 01             	add    $0x1,%eax
    135a:	84 d2                	test   %dl,%dl
    135c:	75 f2                	jne    1350 <strcpy+0x10>
    ;
  return os;
}
    135e:	89 c8                	mov    %ecx,%eax
    1360:	5b                   	pop    %ebx
    1361:	5d                   	pop    %ebp
    1362:	c3                   	ret    
    1363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1370:	f3 0f 1e fb          	endbr32 
    1374:	55                   	push   %ebp
    1375:	89 e5                	mov    %esp,%ebp
    1377:	53                   	push   %ebx
    1378:	8b 4d 08             	mov    0x8(%ebp),%ecx
    137b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    137e:	0f b6 01             	movzbl (%ecx),%eax
    1381:	0f b6 1a             	movzbl (%edx),%ebx
    1384:	84 c0                	test   %al,%al
    1386:	75 19                	jne    13a1 <strcmp+0x31>
    1388:	eb 26                	jmp    13b0 <strcmp+0x40>
    138a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1390:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1394:	83 c1 01             	add    $0x1,%ecx
    1397:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    139a:	0f b6 1a             	movzbl (%edx),%ebx
    139d:	84 c0                	test   %al,%al
    139f:	74 0f                	je     13b0 <strcmp+0x40>
    13a1:	38 d8                	cmp    %bl,%al
    13a3:	74 eb                	je     1390 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    13a5:	29 d8                	sub    %ebx,%eax
}
    13a7:	5b                   	pop    %ebx
    13a8:	5d                   	pop    %ebp
    13a9:	c3                   	ret    
    13aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    13b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    13b2:	29 d8                	sub    %ebx,%eax
}
    13b4:	5b                   	pop    %ebx
    13b5:	5d                   	pop    %ebp
    13b6:	c3                   	ret    
    13b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13be:	66 90                	xchg   %ax,%ax

000013c0 <strlen>:

uint
strlen(const char *s)
{
    13c0:	f3 0f 1e fb          	endbr32 
    13c4:	55                   	push   %ebp
    13c5:	89 e5                	mov    %esp,%ebp
    13c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    13ca:	80 3a 00             	cmpb   $0x0,(%edx)
    13cd:	74 21                	je     13f0 <strlen+0x30>
    13cf:	31 c0                	xor    %eax,%eax
    13d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13d8:	83 c0 01             	add    $0x1,%eax
    13db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    13df:	89 c1                	mov    %eax,%ecx
    13e1:	75 f5                	jne    13d8 <strlen+0x18>
    ;
  return n;
}
    13e3:	89 c8                	mov    %ecx,%eax
    13e5:	5d                   	pop    %ebp
    13e6:	c3                   	ret    
    13e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ee:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    13f0:	31 c9                	xor    %ecx,%ecx
}
    13f2:	5d                   	pop    %ebp
    13f3:	89 c8                	mov    %ecx,%eax
    13f5:	c3                   	ret    
    13f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13fd:	8d 76 00             	lea    0x0(%esi),%esi

00001400 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1400:	f3 0f 1e fb          	endbr32 
    1404:	55                   	push   %ebp
    1405:	89 e5                	mov    %esp,%ebp
    1407:	57                   	push   %edi
    1408:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    140b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    140e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1411:	89 d7                	mov    %edx,%edi
    1413:	fc                   	cld    
    1414:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1416:	89 d0                	mov    %edx,%eax
    1418:	5f                   	pop    %edi
    1419:	5d                   	pop    %ebp
    141a:	c3                   	ret    
    141b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    141f:	90                   	nop

00001420 <strchr>:

char*
strchr(const char *s, char c)
{
    1420:	f3 0f 1e fb          	endbr32 
    1424:	55                   	push   %ebp
    1425:	89 e5                	mov    %esp,%ebp
    1427:	8b 45 08             	mov    0x8(%ebp),%eax
    142a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    142e:	0f b6 10             	movzbl (%eax),%edx
    1431:	84 d2                	test   %dl,%dl
    1433:	75 16                	jne    144b <strchr+0x2b>
    1435:	eb 21                	jmp    1458 <strchr+0x38>
    1437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    143e:	66 90                	xchg   %ax,%ax
    1440:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1444:	83 c0 01             	add    $0x1,%eax
    1447:	84 d2                	test   %dl,%dl
    1449:	74 0d                	je     1458 <strchr+0x38>
    if(*s == c)
    144b:	38 d1                	cmp    %dl,%cl
    144d:	75 f1                	jne    1440 <strchr+0x20>
      return (char*)s;
  return 0;
}
    144f:	5d                   	pop    %ebp
    1450:	c3                   	ret    
    1451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1458:	31 c0                	xor    %eax,%eax
}
    145a:	5d                   	pop    %ebp
    145b:	c3                   	ret    
    145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001460 <gets>:

char*
gets(char *buf, int max)
{
    1460:	f3 0f 1e fb          	endbr32 
    1464:	55                   	push   %ebp
    1465:	89 e5                	mov    %esp,%ebp
    1467:	57                   	push   %edi
    1468:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1469:	31 f6                	xor    %esi,%esi
{
    146b:	53                   	push   %ebx
    146c:	89 f3                	mov    %esi,%ebx
    146e:	83 ec 1c             	sub    $0x1c,%esp
    1471:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1474:	eb 33                	jmp    14a9 <gets+0x49>
    1476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    147d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1480:	83 ec 04             	sub    $0x4,%esp
    1483:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1486:	6a 01                	push   $0x1
    1488:	50                   	push   %eax
    1489:	6a 00                	push   $0x0
    148b:	e8 2b 01 00 00       	call   15bb <read>
    if(cc < 1)
    1490:	83 c4 10             	add    $0x10,%esp
    1493:	85 c0                	test   %eax,%eax
    1495:	7e 1c                	jle    14b3 <gets+0x53>
      break;
    buf[i++] = c;
    1497:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    149b:	83 c7 01             	add    $0x1,%edi
    149e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    14a1:	3c 0a                	cmp    $0xa,%al
    14a3:	74 23                	je     14c8 <gets+0x68>
    14a5:	3c 0d                	cmp    $0xd,%al
    14a7:	74 1f                	je     14c8 <gets+0x68>
  for(i=0; i+1 < max; ){
    14a9:	83 c3 01             	add    $0x1,%ebx
    14ac:	89 fe                	mov    %edi,%esi
    14ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    14b1:	7c cd                	jl     1480 <gets+0x20>
    14b3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    14b5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    14b8:	c6 03 00             	movb   $0x0,(%ebx)
}
    14bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14be:	5b                   	pop    %ebx
    14bf:	5e                   	pop    %esi
    14c0:	5f                   	pop    %edi
    14c1:	5d                   	pop    %ebp
    14c2:	c3                   	ret    
    14c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    14c7:	90                   	nop
    14c8:	8b 75 08             	mov    0x8(%ebp),%esi
    14cb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ce:	01 de                	add    %ebx,%esi
    14d0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    14d2:	c6 03 00             	movb   $0x0,(%ebx)
}
    14d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14d8:	5b                   	pop    %ebx
    14d9:	5e                   	pop    %esi
    14da:	5f                   	pop    %edi
    14db:	5d                   	pop    %ebp
    14dc:	c3                   	ret    
    14dd:	8d 76 00             	lea    0x0(%esi),%esi

000014e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    14e0:	f3 0f 1e fb          	endbr32 
    14e4:	55                   	push   %ebp
    14e5:	89 e5                	mov    %esp,%ebp
    14e7:	56                   	push   %esi
    14e8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e9:	83 ec 08             	sub    $0x8,%esp
    14ec:	6a 00                	push   $0x0
    14ee:	ff 75 08             	pushl  0x8(%ebp)
    14f1:	e8 ed 00 00 00       	call   15e3 <open>
  if(fd < 0)
    14f6:	83 c4 10             	add    $0x10,%esp
    14f9:	85 c0                	test   %eax,%eax
    14fb:	78 2b                	js     1528 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    14fd:	83 ec 08             	sub    $0x8,%esp
    1500:	ff 75 0c             	pushl  0xc(%ebp)
    1503:	89 c3                	mov    %eax,%ebx
    1505:	50                   	push   %eax
    1506:	e8 f0 00 00 00       	call   15fb <fstat>
  close(fd);
    150b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    150e:	89 c6                	mov    %eax,%esi
  close(fd);
    1510:	e8 b6 00 00 00       	call   15cb <close>
  return r;
    1515:	83 c4 10             	add    $0x10,%esp
}
    1518:	8d 65 f8             	lea    -0x8(%ebp),%esp
    151b:	89 f0                	mov    %esi,%eax
    151d:	5b                   	pop    %ebx
    151e:	5e                   	pop    %esi
    151f:	5d                   	pop    %ebp
    1520:	c3                   	ret    
    1521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1528:	be ff ff ff ff       	mov    $0xffffffff,%esi
    152d:	eb e9                	jmp    1518 <stat+0x38>
    152f:	90                   	nop

00001530 <atoi>:

int
atoi(const char *s)
{
    1530:	f3 0f 1e fb          	endbr32 
    1534:	55                   	push   %ebp
    1535:	89 e5                	mov    %esp,%ebp
    1537:	53                   	push   %ebx
    1538:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    153b:	0f be 02             	movsbl (%edx),%eax
    153e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1541:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1544:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1549:	77 1a                	ja     1565 <atoi+0x35>
    154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    154f:	90                   	nop
    n = n*10 + *s++ - '0';
    1550:	83 c2 01             	add    $0x1,%edx
    1553:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1556:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    155a:	0f be 02             	movsbl (%edx),%eax
    155d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1560:	80 fb 09             	cmp    $0x9,%bl
    1563:	76 eb                	jbe    1550 <atoi+0x20>
  return n;
}
    1565:	89 c8                	mov    %ecx,%eax
    1567:	5b                   	pop    %ebx
    1568:	5d                   	pop    %ebp
    1569:	c3                   	ret    
    156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001570 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1570:	f3 0f 1e fb          	endbr32 
    1574:	55                   	push   %ebp
    1575:	89 e5                	mov    %esp,%ebp
    1577:	57                   	push   %edi
    1578:	8b 45 10             	mov    0x10(%ebp),%eax
    157b:	8b 55 08             	mov    0x8(%ebp),%edx
    157e:	56                   	push   %esi
    157f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1582:	85 c0                	test   %eax,%eax
    1584:	7e 0f                	jle    1595 <memmove+0x25>
    1586:	01 d0                	add    %edx,%eax
  dst = vdst;
    1588:	89 d7                	mov    %edx,%edi
    158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1590:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1591:	39 f8                	cmp    %edi,%eax
    1593:	75 fb                	jne    1590 <memmove+0x20>
  return vdst;
}
    1595:	5e                   	pop    %esi
    1596:	89 d0                	mov    %edx,%eax
    1598:	5f                   	pop    %edi
    1599:	5d                   	pop    %ebp
    159a:	c3                   	ret    

0000159b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    159b:	b8 01 00 00 00       	mov    $0x1,%eax
    15a0:	cd 40                	int    $0x40
    15a2:	c3                   	ret    

000015a3 <exit>:
SYSCALL(exit)
    15a3:	b8 02 00 00 00       	mov    $0x2,%eax
    15a8:	cd 40                	int    $0x40
    15aa:	c3                   	ret    

000015ab <wait>:
SYSCALL(wait)
    15ab:	b8 03 00 00 00       	mov    $0x3,%eax
    15b0:	cd 40                	int    $0x40
    15b2:	c3                   	ret    

000015b3 <pipe>:
SYSCALL(pipe)
    15b3:	b8 04 00 00 00       	mov    $0x4,%eax
    15b8:	cd 40                	int    $0x40
    15ba:	c3                   	ret    

000015bb <read>:
SYSCALL(read)
    15bb:	b8 05 00 00 00       	mov    $0x5,%eax
    15c0:	cd 40                	int    $0x40
    15c2:	c3                   	ret    

000015c3 <write>:
SYSCALL(write)
    15c3:	b8 10 00 00 00       	mov    $0x10,%eax
    15c8:	cd 40                	int    $0x40
    15ca:	c3                   	ret    

000015cb <close>:
SYSCALL(close)
    15cb:	b8 15 00 00 00       	mov    $0x15,%eax
    15d0:	cd 40                	int    $0x40
    15d2:	c3                   	ret    

000015d3 <kill>:
SYSCALL(kill)
    15d3:	b8 06 00 00 00       	mov    $0x6,%eax
    15d8:	cd 40                	int    $0x40
    15da:	c3                   	ret    

000015db <exec>:
SYSCALL(exec)
    15db:	b8 07 00 00 00       	mov    $0x7,%eax
    15e0:	cd 40                	int    $0x40
    15e2:	c3                   	ret    

000015e3 <open>:
SYSCALL(open)
    15e3:	b8 0f 00 00 00       	mov    $0xf,%eax
    15e8:	cd 40                	int    $0x40
    15ea:	c3                   	ret    

000015eb <mknod>:
SYSCALL(mknod)
    15eb:	b8 11 00 00 00       	mov    $0x11,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <unlink>:
SYSCALL(unlink)
    15f3:	b8 12 00 00 00       	mov    $0x12,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <fstat>:
SYSCALL(fstat)
    15fb:	b8 08 00 00 00       	mov    $0x8,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <link>:
SYSCALL(link)
    1603:	b8 13 00 00 00       	mov    $0x13,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <mkdir>:
SYSCALL(mkdir)
    160b:	b8 14 00 00 00       	mov    $0x14,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <chdir>:
SYSCALL(chdir)
    1613:	b8 09 00 00 00       	mov    $0x9,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <dup>:
SYSCALL(dup)
    161b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <getpid>:
SYSCALL(getpid)
    1623:	b8 0b 00 00 00       	mov    $0xb,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <sbrk>:
SYSCALL(sbrk)
    162b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <sleep>:
SYSCALL(sleep)
    1633:	b8 0d 00 00 00       	mov    $0xd,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <uptime>:
SYSCALL(uptime)
    163b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <provide_protection>:
SYSCALL(provide_protection)
    1643:	b8 18 00 00 00       	mov    $0x18,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <refuse_protection>:
SYSCALL(refuse_protection)
    164b:	b8 19 00 00 00       	mov    $0x19,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <settickets>:
SYSCALL(settickets) 
    1653:	b8 16 00 00 00       	mov    $0x16,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <getpinfo>:
    165b:	b8 17 00 00 00       	mov    $0x17,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    
    1663:	66 90                	xchg   %ax,%ax
    1665:	66 90                	xchg   %ax,%ax
    1667:	66 90                	xchg   %ax,%ax
    1669:	66 90                	xchg   %ax,%ax
    166b:	66 90                	xchg   %ax,%ax
    166d:	66 90                	xchg   %ax,%ax
    166f:	90                   	nop

00001670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1670:	55                   	push   %ebp
    1671:	89 e5                	mov    %esp,%ebp
    1673:	57                   	push   %edi
    1674:	56                   	push   %esi
    1675:	53                   	push   %ebx
    1676:	83 ec 3c             	sub    $0x3c,%esp
    1679:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    167c:	89 d1                	mov    %edx,%ecx
{
    167e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1681:	85 d2                	test   %edx,%edx
    1683:	0f 89 7f 00 00 00    	jns    1708 <printint+0x98>
    1689:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    168d:	74 79                	je     1708 <printint+0x98>
    neg = 1;
    168f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1696:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1698:	31 db                	xor    %ebx,%ebx
    169a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    169d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    16a0:	89 c8                	mov    %ecx,%eax
    16a2:	31 d2                	xor    %edx,%edx
    16a4:	89 cf                	mov    %ecx,%edi
    16a6:	f7 75 c4             	divl   -0x3c(%ebp)
    16a9:	0f b6 92 c8 1a 00 00 	movzbl 0x1ac8(%edx),%edx
    16b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    16b3:	89 d8                	mov    %ebx,%eax
    16b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    16b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    16bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    16be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    16c1:	76 dd                	jbe    16a0 <printint+0x30>
  if(neg)
    16c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    16c6:	85 c9                	test   %ecx,%ecx
    16c8:	74 0c                	je     16d6 <printint+0x66>
    buf[i++] = '-';
    16ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    16cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    16d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    16d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    16d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    16dd:	eb 07                	jmp    16e6 <printint+0x76>
    16df:	90                   	nop
    16e0:	0f b6 13             	movzbl (%ebx),%edx
    16e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    16e6:	83 ec 04             	sub    $0x4,%esp
    16e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    16ec:	6a 01                	push   $0x1
    16ee:	56                   	push   %esi
    16ef:	57                   	push   %edi
    16f0:	e8 ce fe ff ff       	call   15c3 <write>
  while(--i >= 0)
    16f5:	83 c4 10             	add    $0x10,%esp
    16f8:	39 de                	cmp    %ebx,%esi
    16fa:	75 e4                	jne    16e0 <printint+0x70>
    putc(fd, buf[i]);
}
    16fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16ff:	5b                   	pop    %ebx
    1700:	5e                   	pop    %esi
    1701:	5f                   	pop    %edi
    1702:	5d                   	pop    %ebp
    1703:	c3                   	ret    
    1704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1708:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    170f:	eb 87                	jmp    1698 <printint+0x28>
    1711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    171f:	90                   	nop

00001720 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1720:	f3 0f 1e fb          	endbr32 
    1724:	55                   	push   %ebp
    1725:	89 e5                	mov    %esp,%ebp
    1727:	57                   	push   %edi
    1728:	56                   	push   %esi
    1729:	53                   	push   %ebx
    172a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    172d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1730:	0f b6 1e             	movzbl (%esi),%ebx
    1733:	84 db                	test   %bl,%bl
    1735:	0f 84 b4 00 00 00    	je     17ef <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    173b:	8d 45 10             	lea    0x10(%ebp),%eax
    173e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1741:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1744:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1746:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1749:	eb 33                	jmp    177e <printf+0x5e>
    174b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    174f:	90                   	nop
    1750:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1753:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1758:	83 f8 25             	cmp    $0x25,%eax
    175b:	74 17                	je     1774 <printf+0x54>
  write(fd, &c, 1);
    175d:	83 ec 04             	sub    $0x4,%esp
    1760:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1763:	6a 01                	push   $0x1
    1765:	57                   	push   %edi
    1766:	ff 75 08             	pushl  0x8(%ebp)
    1769:	e8 55 fe ff ff       	call   15c3 <write>
    176e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1771:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1774:	0f b6 1e             	movzbl (%esi),%ebx
    1777:	83 c6 01             	add    $0x1,%esi
    177a:	84 db                	test   %bl,%bl
    177c:	74 71                	je     17ef <printf+0xcf>
    c = fmt[i] & 0xff;
    177e:	0f be cb             	movsbl %bl,%ecx
    1781:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1784:	85 d2                	test   %edx,%edx
    1786:	74 c8                	je     1750 <printf+0x30>
      }
    } else if(state == '%'){
    1788:	83 fa 25             	cmp    $0x25,%edx
    178b:	75 e7                	jne    1774 <printf+0x54>
      if(c == 'd'){
    178d:	83 f8 64             	cmp    $0x64,%eax
    1790:	0f 84 9a 00 00 00    	je     1830 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1796:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    179c:	83 f9 70             	cmp    $0x70,%ecx
    179f:	74 5f                	je     1800 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    17a1:	83 f8 73             	cmp    $0x73,%eax
    17a4:	0f 84 d6 00 00 00    	je     1880 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    17aa:	83 f8 63             	cmp    $0x63,%eax
    17ad:	0f 84 8d 00 00 00    	je     1840 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    17b3:	83 f8 25             	cmp    $0x25,%eax
    17b6:	0f 84 b4 00 00 00    	je     1870 <printf+0x150>
  write(fd, &c, 1);
    17bc:	83 ec 04             	sub    $0x4,%esp
    17bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    17c3:	6a 01                	push   $0x1
    17c5:	57                   	push   %edi
    17c6:	ff 75 08             	pushl  0x8(%ebp)
    17c9:	e8 f5 fd ff ff       	call   15c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    17ce:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    17d1:	83 c4 0c             	add    $0xc,%esp
    17d4:	6a 01                	push   $0x1
    17d6:	83 c6 01             	add    $0x1,%esi
    17d9:	57                   	push   %edi
    17da:	ff 75 08             	pushl  0x8(%ebp)
    17dd:	e8 e1 fd ff ff       	call   15c3 <write>
  for(i = 0; fmt[i]; i++){
    17e2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    17e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    17e9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    17eb:	84 db                	test   %bl,%bl
    17ed:	75 8f                	jne    177e <printf+0x5e>
    }
  }
}
    17ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
    17f2:	5b                   	pop    %ebx
    17f3:	5e                   	pop    %esi
    17f4:	5f                   	pop    %edi
    17f5:	5d                   	pop    %ebp
    17f6:	c3                   	ret    
    17f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    17fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1800:	83 ec 0c             	sub    $0xc,%esp
    1803:	b9 10 00 00 00       	mov    $0x10,%ecx
    1808:	6a 00                	push   $0x0
    180a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    180d:	8b 45 08             	mov    0x8(%ebp),%eax
    1810:	8b 13                	mov    (%ebx),%edx
    1812:	e8 59 fe ff ff       	call   1670 <printint>
        ap++;
    1817:	89 d8                	mov    %ebx,%eax
    1819:	83 c4 10             	add    $0x10,%esp
      state = 0;
    181c:	31 d2                	xor    %edx,%edx
        ap++;
    181e:	83 c0 04             	add    $0x4,%eax
    1821:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1824:	e9 4b ff ff ff       	jmp    1774 <printf+0x54>
    1829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1830:	83 ec 0c             	sub    $0xc,%esp
    1833:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1838:	6a 01                	push   $0x1
    183a:	eb ce                	jmp    180a <printf+0xea>
    183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1840:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1843:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1846:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1848:	6a 01                	push   $0x1
        ap++;
    184a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    184d:	57                   	push   %edi
    184e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1851:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1854:	e8 6a fd ff ff       	call   15c3 <write>
        ap++;
    1859:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    185c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    185f:	31 d2                	xor    %edx,%edx
    1861:	e9 0e ff ff ff       	jmp    1774 <printf+0x54>
    1866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    186d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1870:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1873:	83 ec 04             	sub    $0x4,%esp
    1876:	e9 59 ff ff ff       	jmp    17d4 <printf+0xb4>
    187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    187f:	90                   	nop
        s = (char*)*ap;
    1880:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1883:	8b 18                	mov    (%eax),%ebx
        ap++;
    1885:	83 c0 04             	add    $0x4,%eax
    1888:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    188b:	85 db                	test   %ebx,%ebx
    188d:	74 17                	je     18a6 <printf+0x186>
        while(*s != 0){
    188f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1892:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1894:	84 c0                	test   %al,%al
    1896:	0f 84 d8 fe ff ff    	je     1774 <printf+0x54>
    189c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    189f:	89 de                	mov    %ebx,%esi
    18a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    18a4:	eb 1a                	jmp    18c0 <printf+0x1a0>
          s = "(null)";
    18a6:	bb be 1a 00 00       	mov    $0x1abe,%ebx
        while(*s != 0){
    18ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    18ae:	b8 28 00 00 00       	mov    $0x28,%eax
    18b3:	89 de                	mov    %ebx,%esi
    18b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    18b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18bf:	90                   	nop
  write(fd, &c, 1);
    18c0:	83 ec 04             	sub    $0x4,%esp
          s++;
    18c3:	83 c6 01             	add    $0x1,%esi
    18c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    18c9:	6a 01                	push   $0x1
    18cb:	57                   	push   %edi
    18cc:	53                   	push   %ebx
    18cd:	e8 f1 fc ff ff       	call   15c3 <write>
        while(*s != 0){
    18d2:	0f b6 06             	movzbl (%esi),%eax
    18d5:	83 c4 10             	add    $0x10,%esp
    18d8:	84 c0                	test   %al,%al
    18da:	75 e4                	jne    18c0 <printf+0x1a0>
    18dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    18df:	31 d2                	xor    %edx,%edx
    18e1:	e9 8e fe ff ff       	jmp    1774 <printf+0x54>
    18e6:	66 90                	xchg   %ax,%ax
    18e8:	66 90                	xchg   %ax,%ax
    18ea:	66 90                	xchg   %ax,%ax
    18ec:	66 90                	xchg   %ax,%ax
    18ee:	66 90                	xchg   %ax,%ax

000018f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18f0:	f3 0f 1e fb          	endbr32 
    18f4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18f5:	a1 80 1e 00 00       	mov    0x1e80,%eax
{
    18fa:	89 e5                	mov    %esp,%ebp
    18fc:	57                   	push   %edi
    18fd:	56                   	push   %esi
    18fe:	53                   	push   %ebx
    18ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1902:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1904:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1907:	39 c8                	cmp    %ecx,%eax
    1909:	73 15                	jae    1920 <free+0x30>
    190b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    190f:	90                   	nop
    1910:	39 d1                	cmp    %edx,%ecx
    1912:	72 14                	jb     1928 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1914:	39 d0                	cmp    %edx,%eax
    1916:	73 10                	jae    1928 <free+0x38>
{
    1918:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    191a:	8b 10                	mov    (%eax),%edx
    191c:	39 c8                	cmp    %ecx,%eax
    191e:	72 f0                	jb     1910 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1920:	39 d0                	cmp    %edx,%eax
    1922:	72 f4                	jb     1918 <free+0x28>
    1924:	39 d1                	cmp    %edx,%ecx
    1926:	73 f0                	jae    1918 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1928:	8b 73 fc             	mov    -0x4(%ebx),%esi
    192b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    192e:	39 fa                	cmp    %edi,%edx
    1930:	74 1e                	je     1950 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1932:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1935:	8b 50 04             	mov    0x4(%eax),%edx
    1938:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    193b:	39 f1                	cmp    %esi,%ecx
    193d:	74 28                	je     1967 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    193f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1941:	5b                   	pop    %ebx
  freep = p;
    1942:	a3 80 1e 00 00       	mov    %eax,0x1e80
}
    1947:	5e                   	pop    %esi
    1948:	5f                   	pop    %edi
    1949:	5d                   	pop    %ebp
    194a:	c3                   	ret    
    194b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    194f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1950:	03 72 04             	add    0x4(%edx),%esi
    1953:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1956:	8b 10                	mov    (%eax),%edx
    1958:	8b 12                	mov    (%edx),%edx
    195a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    195d:	8b 50 04             	mov    0x4(%eax),%edx
    1960:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1963:	39 f1                	cmp    %esi,%ecx
    1965:	75 d8                	jne    193f <free+0x4f>
    p->s.size += bp->s.size;
    1967:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    196a:	a3 80 1e 00 00       	mov    %eax,0x1e80
    p->s.size += bp->s.size;
    196f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1972:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1975:	89 10                	mov    %edx,(%eax)
}
    1977:	5b                   	pop    %ebx
    1978:	5e                   	pop    %esi
    1979:	5f                   	pop    %edi
    197a:	5d                   	pop    %ebp
    197b:	c3                   	ret    
    197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001980 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1980:	f3 0f 1e fb          	endbr32 
    1984:	55                   	push   %ebp
    1985:	89 e5                	mov    %esp,%ebp
    1987:	57                   	push   %edi
    1988:	56                   	push   %esi
    1989:	53                   	push   %ebx
    198a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    198d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1990:	8b 3d 80 1e 00 00    	mov    0x1e80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1996:	8d 70 07             	lea    0x7(%eax),%esi
    1999:	c1 ee 03             	shr    $0x3,%esi
    199c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    199f:	85 ff                	test   %edi,%edi
    19a1:	0f 84 a9 00 00 00    	je     1a50 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19a7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    19a9:	8b 48 04             	mov    0x4(%eax),%ecx
    19ac:	39 f1                	cmp    %esi,%ecx
    19ae:	73 6d                	jae    1a1d <malloc+0x9d>
    19b0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    19b6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    19bb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    19be:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    19c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    19c8:	eb 17                	jmp    19e1 <malloc+0x61>
    19ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    19d2:	8b 4a 04             	mov    0x4(%edx),%ecx
    19d5:	39 f1                	cmp    %esi,%ecx
    19d7:	73 4f                	jae    1a28 <malloc+0xa8>
    19d9:	8b 3d 80 1e 00 00    	mov    0x1e80,%edi
    19df:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    19e1:	39 c7                	cmp    %eax,%edi
    19e3:	75 eb                	jne    19d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    19e5:	83 ec 0c             	sub    $0xc,%esp
    19e8:	ff 75 e4             	pushl  -0x1c(%ebp)
    19eb:	e8 3b fc ff ff       	call   162b <sbrk>
  if(p == (char*)-1)
    19f0:	83 c4 10             	add    $0x10,%esp
    19f3:	83 f8 ff             	cmp    $0xffffffff,%eax
    19f6:	74 1b                	je     1a13 <malloc+0x93>
  hp->s.size = nu;
    19f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    19fb:	83 ec 0c             	sub    $0xc,%esp
    19fe:	83 c0 08             	add    $0x8,%eax
    1a01:	50                   	push   %eax
    1a02:	e8 e9 fe ff ff       	call   18f0 <free>
  return freep;
    1a07:	a1 80 1e 00 00       	mov    0x1e80,%eax
      if((p = morecore(nunits)) == 0)
    1a0c:	83 c4 10             	add    $0x10,%esp
    1a0f:	85 c0                	test   %eax,%eax
    1a11:	75 bd                	jne    19d0 <malloc+0x50>
        return 0;
  }
}
    1a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1a16:	31 c0                	xor    %eax,%eax
}
    1a18:	5b                   	pop    %ebx
    1a19:	5e                   	pop    %esi
    1a1a:	5f                   	pop    %edi
    1a1b:	5d                   	pop    %ebp
    1a1c:	c3                   	ret    
    if(p->s.size >= nunits){
    1a1d:	89 c2                	mov    %eax,%edx
    1a1f:	89 f8                	mov    %edi,%eax
    1a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1a28:	39 ce                	cmp    %ecx,%esi
    1a2a:	74 54                	je     1a80 <malloc+0x100>
        p->s.size -= nunits;
    1a2c:	29 f1                	sub    %esi,%ecx
    1a2e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1a31:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1a34:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1a37:	a3 80 1e 00 00       	mov    %eax,0x1e80
}
    1a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1a3f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1a42:	5b                   	pop    %ebx
    1a43:	5e                   	pop    %esi
    1a44:	5f                   	pop    %edi
    1a45:	5d                   	pop    %ebp
    1a46:	c3                   	ret    
    1a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1a4e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1a50:	c7 05 80 1e 00 00 84 	movl   $0x1e84,0x1e80
    1a57:	1e 00 00 
    base.s.size = 0;
    1a5a:	bf 84 1e 00 00       	mov    $0x1e84,%edi
    base.s.ptr = freep = prevp = &base;
    1a5f:	c7 05 84 1e 00 00 84 	movl   $0x1e84,0x1e84
    1a66:	1e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a69:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    1a6b:	c7 05 88 1e 00 00 00 	movl   $0x0,0x1e88
    1a72:	00 00 00 
    if(p->s.size >= nunits){
    1a75:	e9 36 ff ff ff       	jmp    19b0 <malloc+0x30>
    1a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1a80:	8b 0a                	mov    (%edx),%ecx
    1a82:	89 08                	mov    %ecx,(%eax)
    1a84:	eb b1                	jmp    1a37 <malloc+0xb7>
