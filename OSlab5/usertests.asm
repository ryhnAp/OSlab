
_usertests:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
  return randstate;
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
    1011:	51                   	push   %ecx
    1012:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    1015:	68 56 5e 00 00       	push   $0x5e56
    101a:	6a 01                	push   $0x1
    101c:	e8 df 3a 00 00       	call   4b00 <printf>

  if(open("usertests.ran", 0) >= 0){
    1021:	59                   	pop    %ecx
    1022:	58                   	pop    %eax
    1023:	6a 00                	push   $0x0
    1025:	68 6a 5e 00 00       	push   $0x5e6a
    102a:	e8 94 39 00 00       	call   49c3 <open>
    102f:	83 c4 10             	add    $0x10,%esp
    1032:	85 c0                	test   %eax,%eax
    1034:	78 13                	js     1049 <main+0x49>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    1036:	52                   	push   %edx
    1037:	52                   	push   %edx
    1038:	68 d4 65 00 00       	push   $0x65d4
    103d:	6a 01                	push   $0x1
    103f:	e8 bc 3a 00 00       	call   4b00 <printf>
    exit();
    1044:	e8 3a 39 00 00       	call   4983 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    1049:	50                   	push   %eax
    104a:	50                   	push   %eax
    104b:	68 00 02 00 00       	push   $0x200
    1050:	68 6a 5e 00 00       	push   $0x5e6a
    1055:	e8 69 39 00 00       	call   49c3 <open>
    105a:	89 04 24             	mov    %eax,(%esp)
    105d:	e8 49 39 00 00       	call   49ab <close>

  argptest();
    1062:	e8 29 36 00 00       	call   4690 <argptest>
  createdelete();
    1067:	e8 04 12 00 00       	call   2270 <createdelete>
  linkunlink();
    106c:	e8 df 1a 00 00       	call   2b50 <linkunlink>
  concreate();
    1071:	e8 da 17 00 00       	call   2850 <concreate>
  fourfiles();
    1076:	e8 f5 0f 00 00       	call   2070 <fourfiles>
  sharedfd();
    107b:	e8 30 0e 00 00       	call   1eb0 <sharedfd>

  bigargtest();
    1080:	e8 ab 32 00 00       	call   4330 <bigargtest>
  bigwrite();
    1085:	e8 06 24 00 00       	call   3490 <bigwrite>
  bigargtest();
    108a:	e8 a1 32 00 00       	call   4330 <bigargtest>
  bsstest();
    108f:	e8 2c 32 00 00       	call   42c0 <bsstest>
  sbrktest();
    1094:	e8 37 2d 00 00       	call   3dd0 <sbrktest>
  validatetest();
    1099:	e8 62 31 00 00       	call   4200 <validatetest>

  opentest();
    109e:	e8 6d 03 00 00       	call   1410 <opentest>
  writetest();
    10a3:	e8 08 04 00 00       	call   14b0 <writetest>
  writetest1();
    10a8:	e8 e3 05 00 00       	call   1690 <writetest1>
  createtest();
    10ad:	e8 ae 07 00 00       	call   1860 <createtest>

  openiputtest();
    10b2:	e8 59 02 00 00       	call   1310 <openiputtest>
  exitiputtest();
    10b7:	e8 54 01 00 00       	call   1210 <exitiputtest>
  iputtest();
    10bc:	e8 5f 00 00 00       	call   1120 <iputtest>

  mem();
    10c1:	e8 1a 0d 00 00       	call   1de0 <mem>
  pipe1();
    10c6:	e8 95 09 00 00       	call   1a60 <pipe1>
  preempt();
    10cb:	e8 30 0b 00 00       	call   1c00 <preempt>
  exitwait();
    10d0:	e8 8b 0c 00 00       	call   1d60 <exitwait>

  rmdot();
    10d5:	e8 a6 27 00 00       	call   3880 <rmdot>
  fourteen();
    10da:	e8 61 26 00 00       	call   3740 <fourteen>
  bigfile();
    10df:	e8 8c 24 00 00       	call   3570 <bigfile>
  subdir();
    10e4:	e8 b7 1c 00 00       	call   2da0 <subdir>
  linktest();
    10e9:	e8 42 15 00 00       	call   2630 <linktest>
  unlinkread();
    10ee:	e8 ad 13 00 00       	call   24a0 <unlinkread>
  dirfile();
    10f3:	e8 08 29 00 00       	call   3a00 <dirfile>
  iref();
    10f8:	e8 03 2b 00 00       	call   3c00 <iref>
  forktest();
    10fd:	e8 1e 2c 00 00       	call   3d20 <forktest>
  bigdir(); // slow
    1102:	e8 59 1b 00 00       	call   2c60 <bigdir>

  uio();
    1107:	e8 04 35 00 00       	call   4610 <uio>

  exectest();
    110c:	e8 ff 08 00 00       	call   1a10 <exectest>

  exit();
    1111:	e8 6d 38 00 00       	call   4983 <exit>
    1116:	66 90                	xchg   %ax,%ax
    1118:	66 90                	xchg   %ax,%ax
    111a:	66 90                	xchg   %ax,%ax
    111c:	66 90                	xchg   %ax,%ax
    111e:	66 90                	xchg   %ax,%ax

00001120 <iputtest>:
{
    1120:	f3 0f 1e fb          	endbr32 
    1124:	55                   	push   %ebp
    1125:	89 e5                	mov    %esp,%ebp
    1127:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
    112a:	68 fc 4e 00 00       	push   $0x4efc
    112f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1135:	e8 c6 39 00 00       	call   4b00 <printf>
  if(mkdir("iputdir") < 0){
    113a:	c7 04 24 8f 4e 00 00 	movl   $0x4e8f,(%esp)
    1141:	e8 a5 38 00 00       	call   49eb <mkdir>
    1146:	83 c4 10             	add    $0x10,%esp
    1149:	85 c0                	test   %eax,%eax
    114b:	78 58                	js     11a5 <iputtest+0x85>
  if(chdir("iputdir") < 0){
    114d:	83 ec 0c             	sub    $0xc,%esp
    1150:	68 8f 4e 00 00       	push   $0x4e8f
    1155:	e8 99 38 00 00       	call   49f3 <chdir>
    115a:	83 c4 10             	add    $0x10,%esp
    115d:	85 c0                	test   %eax,%eax
    115f:	0f 88 85 00 00 00    	js     11ea <iputtest+0xca>
  if(unlink("../iputdir") < 0){
    1165:	83 ec 0c             	sub    $0xc,%esp
    1168:	68 8c 4e 00 00       	push   $0x4e8c
    116d:	e8 61 38 00 00       	call   49d3 <unlink>
    1172:	83 c4 10             	add    $0x10,%esp
    1175:	85 c0                	test   %eax,%eax
    1177:	78 5a                	js     11d3 <iputtest+0xb3>
  if(chdir("/") < 0){
    1179:	83 ec 0c             	sub    $0xc,%esp
    117c:	68 b1 4e 00 00       	push   $0x4eb1
    1181:	e8 6d 38 00 00       	call   49f3 <chdir>
    1186:	83 c4 10             	add    $0x10,%esp
    1189:	85 c0                	test   %eax,%eax
    118b:	78 2f                	js     11bc <iputtest+0x9c>
  printf(stdout, "iput test ok\n");
    118d:	83 ec 08             	sub    $0x8,%esp
    1190:	68 34 4f 00 00       	push   $0x4f34
    1195:	ff 35 00 6f 00 00    	pushl  0x6f00
    119b:	e8 60 39 00 00       	call   4b00 <printf>
}
    11a0:	83 c4 10             	add    $0x10,%esp
    11a3:	c9                   	leave  
    11a4:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
    11a5:	50                   	push   %eax
    11a6:	50                   	push   %eax
    11a7:	68 68 4e 00 00       	push   $0x4e68
    11ac:	ff 35 00 6f 00 00    	pushl  0x6f00
    11b2:	e8 49 39 00 00       	call   4b00 <printf>
    exit();
    11b7:	e8 c7 37 00 00       	call   4983 <exit>
    printf(stdout, "chdir / failed\n");
    11bc:	50                   	push   %eax
    11bd:	50                   	push   %eax
    11be:	68 b3 4e 00 00       	push   $0x4eb3
    11c3:	ff 35 00 6f 00 00    	pushl  0x6f00
    11c9:	e8 32 39 00 00       	call   4b00 <printf>
    exit();
    11ce:	e8 b0 37 00 00       	call   4983 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
    11d3:	52                   	push   %edx
    11d4:	52                   	push   %edx
    11d5:	68 97 4e 00 00       	push   $0x4e97
    11da:	ff 35 00 6f 00 00    	pushl  0x6f00
    11e0:	e8 1b 39 00 00       	call   4b00 <printf>
    exit();
    11e5:	e8 99 37 00 00       	call   4983 <exit>
    printf(stdout, "chdir iputdir failed\n");
    11ea:	51                   	push   %ecx
    11eb:	51                   	push   %ecx
    11ec:	68 76 4e 00 00       	push   $0x4e76
    11f1:	ff 35 00 6f 00 00    	pushl  0x6f00
    11f7:	e8 04 39 00 00       	call   4b00 <printf>
    exit();
    11fc:	e8 82 37 00 00       	call   4983 <exit>
    1201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    120f:	90                   	nop

00001210 <exitiputtest>:
{
    1210:	f3 0f 1e fb          	endbr32 
    1214:	55                   	push   %ebp
    1215:	89 e5                	mov    %esp,%ebp
    1217:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
    121a:	68 c3 4e 00 00       	push   $0x4ec3
    121f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1225:	e8 d6 38 00 00       	call   4b00 <printf>
  pid = fork();
    122a:	e8 4c 37 00 00       	call   497b <fork>
  if(pid < 0){
    122f:	83 c4 10             	add    $0x10,%esp
    1232:	85 c0                	test   %eax,%eax
    1234:	0f 88 86 00 00 00    	js     12c0 <exitiputtest+0xb0>
  if(pid == 0){
    123a:	75 4c                	jne    1288 <exitiputtest+0x78>
    if(mkdir("iputdir") < 0){
    123c:	83 ec 0c             	sub    $0xc,%esp
    123f:	68 8f 4e 00 00       	push   $0x4e8f
    1244:	e8 a2 37 00 00       	call   49eb <mkdir>
    1249:	83 c4 10             	add    $0x10,%esp
    124c:	85 c0                	test   %eax,%eax
    124e:	0f 88 83 00 00 00    	js     12d7 <exitiputtest+0xc7>
    if(chdir("iputdir") < 0){
    1254:	83 ec 0c             	sub    $0xc,%esp
    1257:	68 8f 4e 00 00       	push   $0x4e8f
    125c:	e8 92 37 00 00       	call   49f3 <chdir>
    1261:	83 c4 10             	add    $0x10,%esp
    1264:	85 c0                	test   %eax,%eax
    1266:	0f 88 82 00 00 00    	js     12ee <exitiputtest+0xde>
    if(unlink("../iputdir") < 0){
    126c:	83 ec 0c             	sub    $0xc,%esp
    126f:	68 8c 4e 00 00       	push   $0x4e8c
    1274:	e8 5a 37 00 00       	call   49d3 <unlink>
    1279:	83 c4 10             	add    $0x10,%esp
    127c:	85 c0                	test   %eax,%eax
    127e:	78 28                	js     12a8 <exitiputtest+0x98>
    exit();
    1280:	e8 fe 36 00 00       	call   4983 <exit>
    1285:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
    1288:	e8 fe 36 00 00       	call   498b <wait>
  printf(stdout, "exitiput test ok\n");
    128d:	83 ec 08             	sub    $0x8,%esp
    1290:	68 e6 4e 00 00       	push   $0x4ee6
    1295:	ff 35 00 6f 00 00    	pushl  0x6f00
    129b:	e8 60 38 00 00       	call   4b00 <printf>
}
    12a0:	83 c4 10             	add    $0x10,%esp
    12a3:	c9                   	leave  
    12a4:	c3                   	ret    
    12a5:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
    12a8:	83 ec 08             	sub    $0x8,%esp
    12ab:	68 97 4e 00 00       	push   $0x4e97
    12b0:	ff 35 00 6f 00 00    	pushl  0x6f00
    12b6:	e8 45 38 00 00       	call   4b00 <printf>
      exit();
    12bb:	e8 c3 36 00 00       	call   4983 <exit>
    printf(stdout, "fork failed\n");
    12c0:	51                   	push   %ecx
    12c1:	51                   	push   %ecx
    12c2:	68 a9 5d 00 00       	push   $0x5da9
    12c7:	ff 35 00 6f 00 00    	pushl  0x6f00
    12cd:	e8 2e 38 00 00       	call   4b00 <printf>
    exit();
    12d2:	e8 ac 36 00 00       	call   4983 <exit>
      printf(stdout, "mkdir failed\n");
    12d7:	52                   	push   %edx
    12d8:	52                   	push   %edx
    12d9:	68 68 4e 00 00       	push   $0x4e68
    12de:	ff 35 00 6f 00 00    	pushl  0x6f00
    12e4:	e8 17 38 00 00       	call   4b00 <printf>
      exit();
    12e9:	e8 95 36 00 00       	call   4983 <exit>
      printf(stdout, "child chdir failed\n");
    12ee:	50                   	push   %eax
    12ef:	50                   	push   %eax
    12f0:	68 d2 4e 00 00       	push   $0x4ed2
    12f5:	ff 35 00 6f 00 00    	pushl  0x6f00
    12fb:	e8 00 38 00 00       	call   4b00 <printf>
      exit();
    1300:	e8 7e 36 00 00       	call   4983 <exit>
    1305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001310 <openiputtest>:
{
    1310:	f3 0f 1e fb          	endbr32 
    1314:	55                   	push   %ebp
    1315:	89 e5                	mov    %esp,%ebp
    1317:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
    131a:	68 f8 4e 00 00       	push   $0x4ef8
    131f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1325:	e8 d6 37 00 00       	call   4b00 <printf>
  if(mkdir("oidir") < 0){
    132a:	c7 04 24 07 4f 00 00 	movl   $0x4f07,(%esp)
    1331:	e8 b5 36 00 00       	call   49eb <mkdir>
    1336:	83 c4 10             	add    $0x10,%esp
    1339:	85 c0                	test   %eax,%eax
    133b:	0f 88 9b 00 00 00    	js     13dc <openiputtest+0xcc>
  pid = fork();
    1341:	e8 35 36 00 00       	call   497b <fork>
  if(pid < 0){
    1346:	85 c0                	test   %eax,%eax
    1348:	78 7b                	js     13c5 <openiputtest+0xb5>
  if(pid == 0){
    134a:	75 34                	jne    1380 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
    134c:	83 ec 08             	sub    $0x8,%esp
    134f:	6a 02                	push   $0x2
    1351:	68 07 4f 00 00       	push   $0x4f07
    1356:	e8 68 36 00 00       	call   49c3 <open>
    if(fd >= 0){
    135b:	83 c4 10             	add    $0x10,%esp
    135e:	85 c0                	test   %eax,%eax
    1360:	78 5e                	js     13c0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
    1362:	83 ec 08             	sub    $0x8,%esp
    1365:	68 8c 5e 00 00       	push   $0x5e8c
    136a:	ff 35 00 6f 00 00    	pushl  0x6f00
    1370:	e8 8b 37 00 00       	call   4b00 <printf>
      exit();
    1375:	e8 09 36 00 00       	call   4983 <exit>
    137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
    1380:	83 ec 0c             	sub    $0xc,%esp
    1383:	6a 01                	push   $0x1
    1385:	e8 89 36 00 00       	call   4a13 <sleep>
  if(unlink("oidir") != 0){
    138a:	c7 04 24 07 4f 00 00 	movl   $0x4f07,(%esp)
    1391:	e8 3d 36 00 00       	call   49d3 <unlink>
    1396:	83 c4 10             	add    $0x10,%esp
    1399:	85 c0                	test   %eax,%eax
    139b:	75 56                	jne    13f3 <openiputtest+0xe3>
  wait();
    139d:	e8 e9 35 00 00       	call   498b <wait>
  printf(stdout, "openiput test ok\n");
    13a2:	83 ec 08             	sub    $0x8,%esp
    13a5:	68 30 4f 00 00       	push   $0x4f30
    13aa:	ff 35 00 6f 00 00    	pushl  0x6f00
    13b0:	e8 4b 37 00 00       	call   4b00 <printf>
    13b5:	83 c4 10             	add    $0x10,%esp
}
    13b8:	c9                   	leave  
    13b9:	c3                   	ret    
    13ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
    13c0:	e8 be 35 00 00       	call   4983 <exit>
    printf(stdout, "fork failed\n");
    13c5:	52                   	push   %edx
    13c6:	52                   	push   %edx
    13c7:	68 a9 5d 00 00       	push   $0x5da9
    13cc:	ff 35 00 6f 00 00    	pushl  0x6f00
    13d2:	e8 29 37 00 00       	call   4b00 <printf>
    exit();
    13d7:	e8 a7 35 00 00       	call   4983 <exit>
    printf(stdout, "mkdir oidir failed\n");
    13dc:	51                   	push   %ecx
    13dd:	51                   	push   %ecx
    13de:	68 0d 4f 00 00       	push   $0x4f0d
    13e3:	ff 35 00 6f 00 00    	pushl  0x6f00
    13e9:	e8 12 37 00 00       	call   4b00 <printf>
    exit();
    13ee:	e8 90 35 00 00       	call   4983 <exit>
    printf(stdout, "unlink failed\n");
    13f3:	50                   	push   %eax
    13f4:	50                   	push   %eax
    13f5:	68 21 4f 00 00       	push   $0x4f21
    13fa:	ff 35 00 6f 00 00    	pushl  0x6f00
    1400:	e8 fb 36 00 00       	call   4b00 <printf>
    exit();
    1405:	e8 79 35 00 00       	call   4983 <exit>
    140a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001410 <opentest>:
{
    1410:	f3 0f 1e fb          	endbr32 
    1414:	55                   	push   %ebp
    1415:	89 e5                	mov    %esp,%ebp
    1417:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
    141a:	68 42 4f 00 00       	push   $0x4f42
    141f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1425:	e8 d6 36 00 00       	call   4b00 <printf>
  fd = open("echo", 0);
    142a:	58                   	pop    %eax
    142b:	5a                   	pop    %edx
    142c:	6a 00                	push   $0x0
    142e:	68 4d 4f 00 00       	push   $0x4f4d
    1433:	e8 8b 35 00 00       	call   49c3 <open>
  if(fd < 0){
    1438:	83 c4 10             	add    $0x10,%esp
    143b:	85 c0                	test   %eax,%eax
    143d:	78 36                	js     1475 <opentest+0x65>
  close(fd);
    143f:	83 ec 0c             	sub    $0xc,%esp
    1442:	50                   	push   %eax
    1443:	e8 63 35 00 00       	call   49ab <close>
  fd = open("doesnotexist", 0);
    1448:	5a                   	pop    %edx
    1449:	59                   	pop    %ecx
    144a:	6a 00                	push   $0x0
    144c:	68 65 4f 00 00       	push   $0x4f65
    1451:	e8 6d 35 00 00       	call   49c3 <open>
  if(fd >= 0){
    1456:	83 c4 10             	add    $0x10,%esp
    1459:	85 c0                	test   %eax,%eax
    145b:	79 2f                	jns    148c <opentest+0x7c>
  printf(stdout, "open test ok\n");
    145d:	83 ec 08             	sub    $0x8,%esp
    1460:	68 90 4f 00 00       	push   $0x4f90
    1465:	ff 35 00 6f 00 00    	pushl  0x6f00
    146b:	e8 90 36 00 00       	call   4b00 <printf>
}
    1470:	83 c4 10             	add    $0x10,%esp
    1473:	c9                   	leave  
    1474:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
    1475:	50                   	push   %eax
    1476:	50                   	push   %eax
    1477:	68 52 4f 00 00       	push   $0x4f52
    147c:	ff 35 00 6f 00 00    	pushl  0x6f00
    1482:	e8 79 36 00 00       	call   4b00 <printf>
    exit();
    1487:	e8 f7 34 00 00       	call   4983 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
    148c:	50                   	push   %eax
    148d:	50                   	push   %eax
    148e:	68 72 4f 00 00       	push   $0x4f72
    1493:	ff 35 00 6f 00 00    	pushl  0x6f00
    1499:	e8 62 36 00 00       	call   4b00 <printf>
    exit();
    149e:	e8 e0 34 00 00       	call   4983 <exit>
    14a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000014b0 <writetest>:
{
    14b0:	f3 0f 1e fb          	endbr32 
    14b4:	55                   	push   %ebp
    14b5:	89 e5                	mov    %esp,%ebp
    14b7:	56                   	push   %esi
    14b8:	53                   	push   %ebx
  printf(stdout, "small file test\n");
    14b9:	83 ec 08             	sub    $0x8,%esp
    14bc:	68 9e 4f 00 00       	push   $0x4f9e
    14c1:	ff 35 00 6f 00 00    	pushl  0x6f00
    14c7:	e8 34 36 00 00       	call   4b00 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    14cc:	58                   	pop    %eax
    14cd:	5a                   	pop    %edx
    14ce:	68 02 02 00 00       	push   $0x202
    14d3:	68 af 4f 00 00       	push   $0x4faf
    14d8:	e8 e6 34 00 00       	call   49c3 <open>
  if(fd >= 0){
    14dd:	83 c4 10             	add    $0x10,%esp
    14e0:	85 c0                	test   %eax,%eax
    14e2:	0f 88 8c 01 00 00    	js     1674 <writetest+0x1c4>
    printf(stdout, "creat small succeeded; ok\n");
    14e8:	83 ec 08             	sub    $0x8,%esp
    14eb:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
    14ed:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
    14ef:	68 b5 4f 00 00       	push   $0x4fb5
    14f4:	ff 35 00 6f 00 00    	pushl  0x6f00
    14fa:	e8 01 36 00 00       	call   4b00 <printf>
    14ff:	83 c4 10             	add    $0x10,%esp
    1502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    1508:	83 ec 04             	sub    $0x4,%esp
    150b:	6a 0a                	push   $0xa
    150d:	68 ec 4f 00 00       	push   $0x4fec
    1512:	56                   	push   %esi
    1513:	e8 8b 34 00 00       	call   49a3 <write>
    1518:	83 c4 10             	add    $0x10,%esp
    151b:	83 f8 0a             	cmp    $0xa,%eax
    151e:	0f 85 d9 00 00 00    	jne    15fd <writetest+0x14d>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    1524:	83 ec 04             	sub    $0x4,%esp
    1527:	6a 0a                	push   $0xa
    1529:	68 f7 4f 00 00       	push   $0x4ff7
    152e:	56                   	push   %esi
    152f:	e8 6f 34 00 00       	call   49a3 <write>
    1534:	83 c4 10             	add    $0x10,%esp
    1537:	83 f8 0a             	cmp    $0xa,%eax
    153a:	0f 85 d6 00 00 00    	jne    1616 <writetest+0x166>
  for(i = 0; i < 100; i++){
    1540:	83 c3 01             	add    $0x1,%ebx
    1543:	83 fb 64             	cmp    $0x64,%ebx
    1546:	75 c0                	jne    1508 <writetest+0x58>
  printf(stdout, "writes ok\n");
    1548:	83 ec 08             	sub    $0x8,%esp
    154b:	68 02 50 00 00       	push   $0x5002
    1550:	ff 35 00 6f 00 00    	pushl  0x6f00
    1556:	e8 a5 35 00 00       	call   4b00 <printf>
  close(fd);
    155b:	89 34 24             	mov    %esi,(%esp)
    155e:	e8 48 34 00 00       	call   49ab <close>
  fd = open("small", O_RDONLY);
    1563:	5b                   	pop    %ebx
    1564:	5e                   	pop    %esi
    1565:	6a 00                	push   $0x0
    1567:	68 af 4f 00 00       	push   $0x4faf
    156c:	e8 52 34 00 00       	call   49c3 <open>
  if(fd >= 0){
    1571:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
    1574:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    1576:	85 c0                	test   %eax,%eax
    1578:	0f 88 b1 00 00 00    	js     162f <writetest+0x17f>
    printf(stdout, "open small succeeded ok\n");
    157e:	83 ec 08             	sub    $0x8,%esp
    1581:	68 0d 50 00 00       	push   $0x500d
    1586:	ff 35 00 6f 00 00    	pushl  0x6f00
    158c:	e8 6f 35 00 00       	call   4b00 <printf>
  i = read(fd, buf, 2000);
    1591:	83 c4 0c             	add    $0xc,%esp
    1594:	68 d0 07 00 00       	push   $0x7d0
    1599:	68 e0 96 00 00       	push   $0x96e0
    159e:	53                   	push   %ebx
    159f:	e8 f7 33 00 00       	call   499b <read>
  if(i == 2000){
    15a4:	83 c4 10             	add    $0x10,%esp
    15a7:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    15ac:	0f 85 94 00 00 00    	jne    1646 <writetest+0x196>
    printf(stdout, "read succeeded ok\n");
    15b2:	83 ec 08             	sub    $0x8,%esp
    15b5:	68 41 50 00 00       	push   $0x5041
    15ba:	ff 35 00 6f 00 00    	pushl  0x6f00
    15c0:	e8 3b 35 00 00       	call   4b00 <printf>
  close(fd);
    15c5:	89 1c 24             	mov    %ebx,(%esp)
    15c8:	e8 de 33 00 00       	call   49ab <close>
  if(unlink("small") < 0){
    15cd:	c7 04 24 af 4f 00 00 	movl   $0x4faf,(%esp)
    15d4:	e8 fa 33 00 00       	call   49d3 <unlink>
    15d9:	83 c4 10             	add    $0x10,%esp
    15dc:	85 c0                	test   %eax,%eax
    15de:	78 7d                	js     165d <writetest+0x1ad>
  printf(stdout, "small file test ok\n");
    15e0:	83 ec 08             	sub    $0x8,%esp
    15e3:	68 69 50 00 00       	push   $0x5069
    15e8:	ff 35 00 6f 00 00    	pushl  0x6f00
    15ee:	e8 0d 35 00 00       	call   4b00 <printf>
}
    15f3:	83 c4 10             	add    $0x10,%esp
    15f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
    15f9:	5b                   	pop    %ebx
    15fa:	5e                   	pop    %esi
    15fb:	5d                   	pop    %ebp
    15fc:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
    15fd:	83 ec 04             	sub    $0x4,%esp
    1600:	53                   	push   %ebx
    1601:	68 b0 5e 00 00       	push   $0x5eb0
    1606:	ff 35 00 6f 00 00    	pushl  0x6f00
    160c:	e8 ef 34 00 00       	call   4b00 <printf>
      exit();
    1611:	e8 6d 33 00 00       	call   4983 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
    1616:	83 ec 04             	sub    $0x4,%esp
    1619:	53                   	push   %ebx
    161a:	68 d4 5e 00 00       	push   $0x5ed4
    161f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1625:	e8 d6 34 00 00       	call   4b00 <printf>
      exit();
    162a:	e8 54 33 00 00       	call   4983 <exit>
    printf(stdout, "error: open small failed!\n");
    162f:	51                   	push   %ecx
    1630:	51                   	push   %ecx
    1631:	68 26 50 00 00       	push   $0x5026
    1636:	ff 35 00 6f 00 00    	pushl  0x6f00
    163c:	e8 bf 34 00 00       	call   4b00 <printf>
    exit();
    1641:	e8 3d 33 00 00       	call   4983 <exit>
    printf(stdout, "read failed\n");
    1646:	52                   	push   %edx
    1647:	52                   	push   %edx
    1648:	68 6d 53 00 00       	push   $0x536d
    164d:	ff 35 00 6f 00 00    	pushl  0x6f00
    1653:	e8 a8 34 00 00       	call   4b00 <printf>
    exit();
    1658:	e8 26 33 00 00       	call   4983 <exit>
    printf(stdout, "unlink small failed\n");
    165d:	50                   	push   %eax
    165e:	50                   	push   %eax
    165f:	68 54 50 00 00       	push   $0x5054
    1664:	ff 35 00 6f 00 00    	pushl  0x6f00
    166a:	e8 91 34 00 00       	call   4b00 <printf>
    exit();
    166f:	e8 0f 33 00 00       	call   4983 <exit>
    printf(stdout, "error: creat small failed!\n");
    1674:	50                   	push   %eax
    1675:	50                   	push   %eax
    1676:	68 d0 4f 00 00       	push   $0x4fd0
    167b:	ff 35 00 6f 00 00    	pushl  0x6f00
    1681:	e8 7a 34 00 00       	call   4b00 <printf>
    exit();
    1686:	e8 f8 32 00 00       	call   4983 <exit>
    168b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    168f:	90                   	nop

00001690 <writetest1>:
{
    1690:	f3 0f 1e fb          	endbr32 
    1694:	55                   	push   %ebp
    1695:	89 e5                	mov    %esp,%ebp
    1697:	56                   	push   %esi
    1698:	53                   	push   %ebx
  printf(stdout, "big files test\n");
    1699:	83 ec 08             	sub    $0x8,%esp
    169c:	68 7d 50 00 00       	push   $0x507d
    16a1:	ff 35 00 6f 00 00    	pushl  0x6f00
    16a7:	e8 54 34 00 00       	call   4b00 <printf>
  fd = open("big", O_CREATE|O_RDWR);
    16ac:	58                   	pop    %eax
    16ad:	5a                   	pop    %edx
    16ae:	68 02 02 00 00       	push   $0x202
    16b3:	68 f7 50 00 00       	push   $0x50f7
    16b8:	e8 06 33 00 00       	call   49c3 <open>
  if(fd < 0){
    16bd:	83 c4 10             	add    $0x10,%esp
    16c0:	85 c0                	test   %eax,%eax
    16c2:	0f 88 5d 01 00 00    	js     1825 <writetest1+0x195>
    16c8:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
    16ca:	31 db                	xor    %ebx,%ebx
    16cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
    16d0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
    16d3:	89 1d e0 96 00 00    	mov    %ebx,0x96e0
    if(write(fd, buf, 512) != 512){
    16d9:	68 00 02 00 00       	push   $0x200
    16de:	68 e0 96 00 00       	push   $0x96e0
    16e3:	56                   	push   %esi
    16e4:	e8 ba 32 00 00       	call   49a3 <write>
    16e9:	83 c4 10             	add    $0x10,%esp
    16ec:	3d 00 02 00 00       	cmp    $0x200,%eax
    16f1:	0f 85 b3 00 00 00    	jne    17aa <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
    16f7:	83 c3 01             	add    $0x1,%ebx
    16fa:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    1700:	75 ce                	jne    16d0 <writetest1+0x40>
  close(fd);
    1702:	83 ec 0c             	sub    $0xc,%esp
    1705:	56                   	push   %esi
    1706:	e8 a0 32 00 00       	call   49ab <close>
  fd = open("big", O_RDONLY);
    170b:	5b                   	pop    %ebx
    170c:	5e                   	pop    %esi
    170d:	6a 00                	push   $0x0
    170f:	68 f7 50 00 00       	push   $0x50f7
    1714:	e8 aa 32 00 00       	call   49c3 <open>
  if(fd < 0){
    1719:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
    171c:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    171e:	85 c0                	test   %eax,%eax
    1720:	0f 88 e8 00 00 00    	js     180e <writetest1+0x17e>
  n = 0;
    1726:	31 f6                	xor    %esi,%esi
    1728:	eb 1d                	jmp    1747 <writetest1+0xb7>
    172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
    1730:	3d 00 02 00 00       	cmp    $0x200,%eax
    1735:	0f 85 9f 00 00 00    	jne    17da <writetest1+0x14a>
    if(((int*)buf)[0] != n){
    173b:	a1 e0 96 00 00       	mov    0x96e0,%eax
    1740:	39 f0                	cmp    %esi,%eax
    1742:	75 7f                	jne    17c3 <writetest1+0x133>
    n++;
    1744:	83 c6 01             	add    $0x1,%esi
    i = read(fd, buf, 512);
    1747:	83 ec 04             	sub    $0x4,%esp
    174a:	68 00 02 00 00       	push   $0x200
    174f:	68 e0 96 00 00       	push   $0x96e0
    1754:	53                   	push   %ebx
    1755:	e8 41 32 00 00       	call   499b <read>
    if(i == 0){
    175a:	83 c4 10             	add    $0x10,%esp
    175d:	85 c0                	test   %eax,%eax
    175f:	75 cf                	jne    1730 <writetest1+0xa0>
      if(n == MAXFILE - 1){
    1761:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
    1767:	0f 84 86 00 00 00    	je     17f3 <writetest1+0x163>
  close(fd);
    176d:	83 ec 0c             	sub    $0xc,%esp
    1770:	53                   	push   %ebx
    1771:	e8 35 32 00 00       	call   49ab <close>
  if(unlink("big") < 0){
    1776:	c7 04 24 f7 50 00 00 	movl   $0x50f7,(%esp)
    177d:	e8 51 32 00 00       	call   49d3 <unlink>
    1782:	83 c4 10             	add    $0x10,%esp
    1785:	85 c0                	test   %eax,%eax
    1787:	0f 88 af 00 00 00    	js     183c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
    178d:	83 ec 08             	sub    $0x8,%esp
    1790:	68 1e 51 00 00       	push   $0x511e
    1795:	ff 35 00 6f 00 00    	pushl  0x6f00
    179b:	e8 60 33 00 00       	call   4b00 <printf>
}
    17a0:	83 c4 10             	add    $0x10,%esp
    17a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    17a6:	5b                   	pop    %ebx
    17a7:	5e                   	pop    %esi
    17a8:	5d                   	pop    %ebp
    17a9:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
    17aa:	83 ec 04             	sub    $0x4,%esp
    17ad:	53                   	push   %ebx
    17ae:	68 a7 50 00 00       	push   $0x50a7
    17b3:	ff 35 00 6f 00 00    	pushl  0x6f00
    17b9:	e8 42 33 00 00       	call   4b00 <printf>
      exit();
    17be:	e8 c0 31 00 00       	call   4983 <exit>
      printf(stdout, "read content of block %d is %d\n",
    17c3:	50                   	push   %eax
    17c4:	56                   	push   %esi
    17c5:	68 f8 5e 00 00       	push   $0x5ef8
    17ca:	ff 35 00 6f 00 00    	pushl  0x6f00
    17d0:	e8 2b 33 00 00       	call   4b00 <printf>
      exit();
    17d5:	e8 a9 31 00 00       	call   4983 <exit>
      printf(stdout, "read failed %d\n", i);
    17da:	83 ec 04             	sub    $0x4,%esp
    17dd:	50                   	push   %eax
    17de:	68 fb 50 00 00       	push   $0x50fb
    17e3:	ff 35 00 6f 00 00    	pushl  0x6f00
    17e9:	e8 12 33 00 00       	call   4b00 <printf>
      exit();
    17ee:	e8 90 31 00 00       	call   4983 <exit>
        printf(stdout, "read only %d blocks from big", n);
    17f3:	52                   	push   %edx
    17f4:	68 8b 00 00 00       	push   $0x8b
    17f9:	68 de 50 00 00       	push   $0x50de
    17fe:	ff 35 00 6f 00 00    	pushl  0x6f00
    1804:	e8 f7 32 00 00       	call   4b00 <printf>
        exit();
    1809:	e8 75 31 00 00       	call   4983 <exit>
    printf(stdout, "error: open big failed!\n");
    180e:	51                   	push   %ecx
    180f:	51                   	push   %ecx
    1810:	68 c5 50 00 00       	push   $0x50c5
    1815:	ff 35 00 6f 00 00    	pushl  0x6f00
    181b:	e8 e0 32 00 00       	call   4b00 <printf>
    exit();
    1820:	e8 5e 31 00 00       	call   4983 <exit>
    printf(stdout, "error: creat big failed!\n");
    1825:	50                   	push   %eax
    1826:	50                   	push   %eax
    1827:	68 8d 50 00 00       	push   $0x508d
    182c:	ff 35 00 6f 00 00    	pushl  0x6f00
    1832:	e8 c9 32 00 00       	call   4b00 <printf>
    exit();
    1837:	e8 47 31 00 00       	call   4983 <exit>
    printf(stdout, "unlink big failed\n");
    183c:	50                   	push   %eax
    183d:	50                   	push   %eax
    183e:	68 0b 51 00 00       	push   $0x510b
    1843:	ff 35 00 6f 00 00    	pushl  0x6f00
    1849:	e8 b2 32 00 00       	call   4b00 <printf>
    exit();
    184e:	e8 30 31 00 00       	call   4983 <exit>
    1853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    185a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001860 <createtest>:
{
    1860:	f3 0f 1e fb          	endbr32 
    1864:	55                   	push   %ebp
    1865:	89 e5                	mov    %esp,%ebp
    1867:	53                   	push   %ebx
  name[2] = '\0';
    1868:	bb 30 00 00 00       	mov    $0x30,%ebx
{
    186d:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
    1870:	68 18 5f 00 00       	push   $0x5f18
    1875:	ff 35 00 6f 00 00    	pushl  0x6f00
    187b:	e8 80 32 00 00       	call   4b00 <printf>
  name[0] = 'a';
    1880:	c6 05 e0 b6 00 00 61 	movb   $0x61,0xb6e0
  name[2] = '\0';
    1887:	83 c4 10             	add    $0x10,%esp
    188a:	c6 05 e2 b6 00 00 00 	movb   $0x0,0xb6e2
  for(i = 0; i < 52; i++){
    1891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open(name, O_CREATE|O_RDWR);
    1898:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
    189b:	88 1d e1 b6 00 00    	mov    %bl,0xb6e1
    fd = open(name, O_CREATE|O_RDWR);
    18a1:	83 c3 01             	add    $0x1,%ebx
    18a4:	68 02 02 00 00       	push   $0x202
    18a9:	68 e0 b6 00 00       	push   $0xb6e0
    18ae:	e8 10 31 00 00       	call   49c3 <open>
    close(fd);
    18b3:	89 04 24             	mov    %eax,(%esp)
    18b6:	e8 f0 30 00 00       	call   49ab <close>
  for(i = 0; i < 52; i++){
    18bb:	83 c4 10             	add    $0x10,%esp
    18be:	80 fb 64             	cmp    $0x64,%bl
    18c1:	75 d5                	jne    1898 <createtest+0x38>
  name[0] = 'a';
    18c3:	c6 05 e0 b6 00 00 61 	movb   $0x61,0xb6e0
  name[2] = '\0';
    18ca:	bb 30 00 00 00       	mov    $0x30,%ebx
    18cf:	c6 05 e2 b6 00 00 00 	movb   $0x0,0xb6e2
  for(i = 0; i < 52; i++){
    18d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18dd:	8d 76 00             	lea    0x0(%esi),%esi
    unlink(name);
    18e0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
    18e3:	88 1d e1 b6 00 00    	mov    %bl,0xb6e1
    unlink(name);
    18e9:	83 c3 01             	add    $0x1,%ebx
    18ec:	68 e0 b6 00 00       	push   $0xb6e0
    18f1:	e8 dd 30 00 00       	call   49d3 <unlink>
  for(i = 0; i < 52; i++){
    18f6:	83 c4 10             	add    $0x10,%esp
    18f9:	80 fb 64             	cmp    $0x64,%bl
    18fc:	75 e2                	jne    18e0 <createtest+0x80>
  printf(stdout, "many creates, followed by unlink; ok\n");
    18fe:	83 ec 08             	sub    $0x8,%esp
    1901:	68 40 5f 00 00       	push   $0x5f40
    1906:	ff 35 00 6f 00 00    	pushl  0x6f00
    190c:	e8 ef 31 00 00       	call   4b00 <printf>
}
    1911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1914:	83 c4 10             	add    $0x10,%esp
    1917:	c9                   	leave  
    1918:	c3                   	ret    
    1919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001920 <dirtest>:
{
    1920:	f3 0f 1e fb          	endbr32 
    1924:	55                   	push   %ebp
    1925:	89 e5                	mov    %esp,%ebp
    1927:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
    192a:	68 2c 51 00 00       	push   $0x512c
    192f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1935:	e8 c6 31 00 00       	call   4b00 <printf>
  if(mkdir("dir0") < 0){
    193a:	c7 04 24 38 51 00 00 	movl   $0x5138,(%esp)
    1941:	e8 a5 30 00 00       	call   49eb <mkdir>
    1946:	83 c4 10             	add    $0x10,%esp
    1949:	85 c0                	test   %eax,%eax
    194b:	78 58                	js     19a5 <dirtest+0x85>
  if(chdir("dir0") < 0){
    194d:	83 ec 0c             	sub    $0xc,%esp
    1950:	68 38 51 00 00       	push   $0x5138
    1955:	e8 99 30 00 00       	call   49f3 <chdir>
    195a:	83 c4 10             	add    $0x10,%esp
    195d:	85 c0                	test   %eax,%eax
    195f:	0f 88 85 00 00 00    	js     19ea <dirtest+0xca>
  if(chdir("..") < 0){
    1965:	83 ec 0c             	sub    $0xc,%esp
    1968:	68 dd 56 00 00       	push   $0x56dd
    196d:	e8 81 30 00 00       	call   49f3 <chdir>
    1972:	83 c4 10             	add    $0x10,%esp
    1975:	85 c0                	test   %eax,%eax
    1977:	78 5a                	js     19d3 <dirtest+0xb3>
  if(unlink("dir0") < 0){
    1979:	83 ec 0c             	sub    $0xc,%esp
    197c:	68 38 51 00 00       	push   $0x5138
    1981:	e8 4d 30 00 00       	call   49d3 <unlink>
    1986:	83 c4 10             	add    $0x10,%esp
    1989:	85 c0                	test   %eax,%eax
    198b:	78 2f                	js     19bc <dirtest+0x9c>
  printf(stdout, "mkdir test ok\n");
    198d:	83 ec 08             	sub    $0x8,%esp
    1990:	68 75 51 00 00       	push   $0x5175
    1995:	ff 35 00 6f 00 00    	pushl  0x6f00
    199b:	e8 60 31 00 00       	call   4b00 <printf>
}
    19a0:	83 c4 10             	add    $0x10,%esp
    19a3:	c9                   	leave  
    19a4:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
    19a5:	50                   	push   %eax
    19a6:	50                   	push   %eax
    19a7:	68 68 4e 00 00       	push   $0x4e68
    19ac:	ff 35 00 6f 00 00    	pushl  0x6f00
    19b2:	e8 49 31 00 00       	call   4b00 <printf>
    exit();
    19b7:	e8 c7 2f 00 00       	call   4983 <exit>
    printf(stdout, "unlink dir0 failed\n");
    19bc:	50                   	push   %eax
    19bd:	50                   	push   %eax
    19be:	68 61 51 00 00       	push   $0x5161
    19c3:	ff 35 00 6f 00 00    	pushl  0x6f00
    19c9:	e8 32 31 00 00       	call   4b00 <printf>
    exit();
    19ce:	e8 b0 2f 00 00       	call   4983 <exit>
    printf(stdout, "chdir .. failed\n");
    19d3:	52                   	push   %edx
    19d4:	52                   	push   %edx
    19d5:	68 50 51 00 00       	push   $0x5150
    19da:	ff 35 00 6f 00 00    	pushl  0x6f00
    19e0:	e8 1b 31 00 00       	call   4b00 <printf>
    exit();
    19e5:	e8 99 2f 00 00       	call   4983 <exit>
    printf(stdout, "chdir dir0 failed\n");
    19ea:	51                   	push   %ecx
    19eb:	51                   	push   %ecx
    19ec:	68 3d 51 00 00       	push   $0x513d
    19f1:	ff 35 00 6f 00 00    	pushl  0x6f00
    19f7:	e8 04 31 00 00       	call   4b00 <printf>
    exit();
    19fc:	e8 82 2f 00 00       	call   4983 <exit>
    1a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1a0f:	90                   	nop

00001a10 <exectest>:
{
    1a10:	f3 0f 1e fb          	endbr32 
    1a14:	55                   	push   %ebp
    1a15:	89 e5                	mov    %esp,%ebp
    1a17:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
    1a1a:	68 84 51 00 00       	push   $0x5184
    1a1f:	ff 35 00 6f 00 00    	pushl  0x6f00
    1a25:	e8 d6 30 00 00       	call   4b00 <printf>
  if(exec("echo", echoargv) < 0){
    1a2a:	5a                   	pop    %edx
    1a2b:	59                   	pop    %ecx
    1a2c:	68 04 6f 00 00       	push   $0x6f04
    1a31:	68 4d 4f 00 00       	push   $0x4f4d
    1a36:	e8 80 2f 00 00       	call   49bb <exec>
    1a3b:	83 c4 10             	add    $0x10,%esp
    1a3e:	85 c0                	test   %eax,%eax
    1a40:	78 02                	js     1a44 <exectest+0x34>
}
    1a42:	c9                   	leave  
    1a43:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
    1a44:	50                   	push   %eax
    1a45:	50                   	push   %eax
    1a46:	68 8f 51 00 00       	push   $0x518f
    1a4b:	ff 35 00 6f 00 00    	pushl  0x6f00
    1a51:	e8 aa 30 00 00       	call   4b00 <printf>
    exit();
    1a56:	e8 28 2f 00 00       	call   4983 <exit>
    1a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1a5f:	90                   	nop

00001a60 <pipe1>:
{
    1a60:	f3 0f 1e fb          	endbr32 
    1a64:	55                   	push   %ebp
    1a65:	89 e5                	mov    %esp,%ebp
    1a67:	57                   	push   %edi
    1a68:	56                   	push   %esi
  if(pipe(fds) != 0){
    1a69:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
    1a6c:	53                   	push   %ebx
    1a6d:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
    1a70:	50                   	push   %eax
    1a71:	e8 1d 2f 00 00       	call   4993 <pipe>
    1a76:	83 c4 10             	add    $0x10,%esp
    1a79:	85 c0                	test   %eax,%eax
    1a7b:	0f 85 38 01 00 00    	jne    1bb9 <pipe1+0x159>
  pid = fork();
    1a81:	e8 f5 2e 00 00       	call   497b <fork>
  if(pid == 0){
    1a86:	85 c0                	test   %eax,%eax
    1a88:	0f 84 8d 00 00 00    	je     1b1b <pipe1+0xbb>
  } else if(pid > 0){
    1a8e:	0f 8e 38 01 00 00    	jle    1bcc <pipe1+0x16c>
    close(fds[1]);
    1a94:	83 ec 0c             	sub    $0xc,%esp
    1a97:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
    1a9a:	31 db                	xor    %ebx,%ebx
    cc = 1;
    1a9c:	be 01 00 00 00       	mov    $0x1,%esi
    close(fds[1]);
    1aa1:	e8 05 2f 00 00       	call   49ab <close>
    total = 0;
    1aa6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
    1aad:	83 c4 10             	add    $0x10,%esp
    1ab0:	83 ec 04             	sub    $0x4,%esp
    1ab3:	56                   	push   %esi
    1ab4:	68 e0 96 00 00       	push   $0x96e0
    1ab9:	ff 75 e0             	pushl  -0x20(%ebp)
    1abc:	e8 da 2e 00 00       	call   499b <read>
    1ac1:	83 c4 10             	add    $0x10,%esp
    1ac4:	89 c7                	mov    %eax,%edi
    1ac6:	85 c0                	test   %eax,%eax
    1ac8:	0f 8e a7 00 00 00    	jle    1b75 <pipe1+0x115>
    1ace:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
      for(i = 0; i < n; i++){
    1ad1:	31 c0                	xor    %eax,%eax
    1ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1ad7:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1ad8:	89 da                	mov    %ebx,%edx
    1ada:	83 c3 01             	add    $0x1,%ebx
    1add:	38 90 e0 96 00 00    	cmp    %dl,0x96e0(%eax)
    1ae3:	75 1c                	jne    1b01 <pipe1+0xa1>
      for(i = 0; i < n; i++){
    1ae5:	83 c0 01             	add    $0x1,%eax
    1ae8:	39 d9                	cmp    %ebx,%ecx
    1aea:	75 ec                	jne    1ad8 <pipe1+0x78>
      cc = cc * 2;
    1aec:	01 f6                	add    %esi,%esi
      total += n;
    1aee:	01 7d d4             	add    %edi,-0x2c(%ebp)
    1af1:	b8 00 20 00 00       	mov    $0x2000,%eax
    1af6:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
    1afc:	0f 4f f0             	cmovg  %eax,%esi
    1aff:	eb af                	jmp    1ab0 <pipe1+0x50>
          printf(1, "pipe1 oops 2\n");
    1b01:	83 ec 08             	sub    $0x8,%esp
    1b04:	68 be 51 00 00       	push   $0x51be
    1b09:	6a 01                	push   $0x1
    1b0b:	e8 f0 2f 00 00       	call   4b00 <printf>
          return;
    1b10:	83 c4 10             	add    $0x10,%esp
}
    1b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b16:	5b                   	pop    %ebx
    1b17:	5e                   	pop    %esi
    1b18:	5f                   	pop    %edi
    1b19:	5d                   	pop    %ebp
    1b1a:	c3                   	ret    
    close(fds[0]);
    1b1b:	83 ec 0c             	sub    $0xc,%esp
    1b1e:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
    1b21:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
    1b23:	e8 83 2e 00 00       	call   49ab <close>
    1b28:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
    1b2b:	31 c0                	xor    %eax,%eax
    1b2d:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
    1b30:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
    1b33:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
    1b36:	88 90 df 96 00 00    	mov    %dl,0x96df(%eax)
      for(i = 0; i < 1033; i++)
    1b3c:	3d 09 04 00 00       	cmp    $0x409,%eax
    1b41:	75 ed                	jne    1b30 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
    1b43:	83 ec 04             	sub    $0x4,%esp
    1b46:	81 c3 09 04 00 00    	add    $0x409,%ebx
    1b4c:	68 09 04 00 00       	push   $0x409
    1b51:	68 e0 96 00 00       	push   $0x96e0
    1b56:	ff 75 e4             	pushl  -0x1c(%ebp)
    1b59:	e8 45 2e 00 00       	call   49a3 <write>
    1b5e:	83 c4 10             	add    $0x10,%esp
    1b61:	3d 09 04 00 00       	cmp    $0x409,%eax
    1b66:	75 77                	jne    1bdf <pipe1+0x17f>
    for(n = 0; n < 5; n++){
    1b68:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    1b6e:	75 bb                	jne    1b2b <pipe1+0xcb>
    exit();
    1b70:	e8 0e 2e 00 00       	call   4983 <exit>
    if(total != 5 * 1033){
    1b75:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
    1b7c:	75 26                	jne    1ba4 <pipe1+0x144>
    close(fds[0]);
    1b7e:	83 ec 0c             	sub    $0xc,%esp
    1b81:	ff 75 e0             	pushl  -0x20(%ebp)
    1b84:	e8 22 2e 00 00       	call   49ab <close>
    wait();
    1b89:	e8 fd 2d 00 00       	call   498b <wait>
  printf(1, "pipe1 ok\n");
    1b8e:	5a                   	pop    %edx
    1b8f:	59                   	pop    %ecx
    1b90:	68 e3 51 00 00       	push   $0x51e3
    1b95:	6a 01                	push   $0x1
    1b97:	e8 64 2f 00 00       	call   4b00 <printf>
    1b9c:	83 c4 10             	add    $0x10,%esp
    1b9f:	e9 6f ff ff ff       	jmp    1b13 <pipe1+0xb3>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1ba4:	53                   	push   %ebx
    1ba5:	ff 75 d4             	pushl  -0x2c(%ebp)
    1ba8:	68 cc 51 00 00       	push   $0x51cc
    1bad:	6a 01                	push   $0x1
    1baf:	e8 4c 2f 00 00       	call   4b00 <printf>
      exit();
    1bb4:	e8 ca 2d 00 00       	call   4983 <exit>
    printf(1, "pipe() failed\n");
    1bb9:	57                   	push   %edi
    1bba:	57                   	push   %edi
    1bbb:	68 a1 51 00 00       	push   $0x51a1
    1bc0:	6a 01                	push   $0x1
    1bc2:	e8 39 2f 00 00       	call   4b00 <printf>
    exit();
    1bc7:	e8 b7 2d 00 00       	call   4983 <exit>
    printf(1, "fork() failed\n");
    1bcc:	50                   	push   %eax
    1bcd:	50                   	push   %eax
    1bce:	68 ed 51 00 00       	push   $0x51ed
    1bd3:	6a 01                	push   $0x1
    1bd5:	e8 26 2f 00 00       	call   4b00 <printf>
    exit();
    1bda:	e8 a4 2d 00 00       	call   4983 <exit>
        printf(1, "pipe1 oops 1\n");
    1bdf:	56                   	push   %esi
    1be0:	56                   	push   %esi
    1be1:	68 b0 51 00 00       	push   $0x51b0
    1be6:	6a 01                	push   $0x1
    1be8:	e8 13 2f 00 00       	call   4b00 <printf>
        exit();
    1bed:	e8 91 2d 00 00       	call   4983 <exit>
    1bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001c00 <preempt>:
{
    1c00:	f3 0f 1e fb          	endbr32 
    1c04:	55                   	push   %ebp
    1c05:	89 e5                	mov    %esp,%ebp
    1c07:	57                   	push   %edi
    1c08:	56                   	push   %esi
    1c09:	53                   	push   %ebx
    1c0a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
    1c0d:	68 fc 51 00 00       	push   $0x51fc
    1c12:	6a 01                	push   $0x1
    1c14:	e8 e7 2e 00 00       	call   4b00 <printf>
  pid1 = fork();
    1c19:	e8 5d 2d 00 00       	call   497b <fork>
  if(pid1 == 0)
    1c1e:	83 c4 10             	add    $0x10,%esp
    1c21:	85 c0                	test   %eax,%eax
    1c23:	75 0b                	jne    1c30 <preempt+0x30>
    for(;;)
    1c25:	eb fe                	jmp    1c25 <preempt+0x25>
    1c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1c2e:	66 90                	xchg   %ax,%ax
    1c30:	89 c7                	mov    %eax,%edi
  pid2 = fork();
    1c32:	e8 44 2d 00 00       	call   497b <fork>
    1c37:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    1c39:	85 c0                	test   %eax,%eax
    1c3b:	75 03                	jne    1c40 <preempt+0x40>
    for(;;)
    1c3d:	eb fe                	jmp    1c3d <preempt+0x3d>
    1c3f:	90                   	nop
  pipe(pfds);
    1c40:	83 ec 0c             	sub    $0xc,%esp
    1c43:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1c46:	50                   	push   %eax
    1c47:	e8 47 2d 00 00       	call   4993 <pipe>
  pid3 = fork();
    1c4c:	e8 2a 2d 00 00       	call   497b <fork>
  if(pid3 == 0){
    1c51:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
    1c54:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    1c56:	85 c0                	test   %eax,%eax
    1c58:	75 3e                	jne    1c98 <preempt+0x98>
    close(pfds[0]);
    1c5a:	83 ec 0c             	sub    $0xc,%esp
    1c5d:	ff 75 e0             	pushl  -0x20(%ebp)
    1c60:	e8 46 2d 00 00       	call   49ab <close>
    if(write(pfds[1], "x", 1) != 1)
    1c65:	83 c4 0c             	add    $0xc,%esp
    1c68:	6a 01                	push   $0x1
    1c6a:	68 c1 57 00 00       	push   $0x57c1
    1c6f:	ff 75 e4             	pushl  -0x1c(%ebp)
    1c72:	e8 2c 2d 00 00       	call   49a3 <write>
    1c77:	83 c4 10             	add    $0x10,%esp
    1c7a:	83 f8 01             	cmp    $0x1,%eax
    1c7d:	0f 85 a4 00 00 00    	jne    1d27 <preempt+0x127>
    close(pfds[1]);
    1c83:	83 ec 0c             	sub    $0xc,%esp
    1c86:	ff 75 e4             	pushl  -0x1c(%ebp)
    1c89:	e8 1d 2d 00 00       	call   49ab <close>
    1c8e:	83 c4 10             	add    $0x10,%esp
    for(;;)
    1c91:	eb fe                	jmp    1c91 <preempt+0x91>
    1c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1c97:	90                   	nop
  close(pfds[1]);
    1c98:	83 ec 0c             	sub    $0xc,%esp
    1c9b:	ff 75 e4             	pushl  -0x1c(%ebp)
    1c9e:	e8 08 2d 00 00       	call   49ab <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1ca3:	83 c4 0c             	add    $0xc,%esp
    1ca6:	68 00 20 00 00       	push   $0x2000
    1cab:	68 e0 96 00 00       	push   $0x96e0
    1cb0:	ff 75 e0             	pushl  -0x20(%ebp)
    1cb3:	e8 e3 2c 00 00       	call   499b <read>
    1cb8:	83 c4 10             	add    $0x10,%esp
    1cbb:	83 f8 01             	cmp    $0x1,%eax
    1cbe:	75 7e                	jne    1d3e <preempt+0x13e>
  close(pfds[0]);
    1cc0:	83 ec 0c             	sub    $0xc,%esp
    1cc3:	ff 75 e0             	pushl  -0x20(%ebp)
    1cc6:	e8 e0 2c 00 00       	call   49ab <close>
  printf(1, "kill... ");
    1ccb:	58                   	pop    %eax
    1ccc:	5a                   	pop    %edx
    1ccd:	68 2d 52 00 00       	push   $0x522d
    1cd2:	6a 01                	push   $0x1
    1cd4:	e8 27 2e 00 00       	call   4b00 <printf>
  kill(pid1);
    1cd9:	89 3c 24             	mov    %edi,(%esp)
    1cdc:	e8 d2 2c 00 00       	call   49b3 <kill>
  kill(pid2);
    1ce1:	89 34 24             	mov    %esi,(%esp)
    1ce4:	e8 ca 2c 00 00       	call   49b3 <kill>
  kill(pid3);
    1ce9:	89 1c 24             	mov    %ebx,(%esp)
    1cec:	e8 c2 2c 00 00       	call   49b3 <kill>
  printf(1, "wait... ");
    1cf1:	59                   	pop    %ecx
    1cf2:	5b                   	pop    %ebx
    1cf3:	68 36 52 00 00       	push   $0x5236
    1cf8:	6a 01                	push   $0x1
    1cfa:	e8 01 2e 00 00       	call   4b00 <printf>
  wait();
    1cff:	e8 87 2c 00 00       	call   498b <wait>
  wait();
    1d04:	e8 82 2c 00 00       	call   498b <wait>
  wait();
    1d09:	e8 7d 2c 00 00       	call   498b <wait>
  printf(1, "preempt ok\n");
    1d0e:	5e                   	pop    %esi
    1d0f:	5f                   	pop    %edi
    1d10:	68 3f 52 00 00       	push   $0x523f
    1d15:	6a 01                	push   $0x1
    1d17:	e8 e4 2d 00 00       	call   4b00 <printf>
    1d1c:	83 c4 10             	add    $0x10,%esp
}
    1d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1d22:	5b                   	pop    %ebx
    1d23:	5e                   	pop    %esi
    1d24:	5f                   	pop    %edi
    1d25:	5d                   	pop    %ebp
    1d26:	c3                   	ret    
      printf(1, "preempt write error");
    1d27:	83 ec 08             	sub    $0x8,%esp
    1d2a:	68 06 52 00 00       	push   $0x5206
    1d2f:	6a 01                	push   $0x1
    1d31:	e8 ca 2d 00 00       	call   4b00 <printf>
    1d36:	83 c4 10             	add    $0x10,%esp
    1d39:	e9 45 ff ff ff       	jmp    1c83 <preempt+0x83>
    printf(1, "preempt read error");
    1d3e:	83 ec 08             	sub    $0x8,%esp
    1d41:	68 1a 52 00 00       	push   $0x521a
    1d46:	6a 01                	push   $0x1
    1d48:	e8 b3 2d 00 00       	call   4b00 <printf>
    return;
    1d4d:	83 c4 10             	add    $0x10,%esp
    1d50:	eb cd                	jmp    1d1f <preempt+0x11f>
    1d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001d60 <exitwait>:
{
    1d60:	f3 0f 1e fb          	endbr32 
    1d64:	55                   	push   %ebp
    1d65:	89 e5                	mov    %esp,%ebp
    1d67:	56                   	push   %esi
    1d68:	be 64 00 00 00       	mov    $0x64,%esi
    1d6d:	53                   	push   %ebx
    1d6e:	eb 10                	jmp    1d80 <exitwait+0x20>
    if(pid){
    1d70:	74 68                	je     1dda <exitwait+0x7a>
      if(wait() != pid){
    1d72:	e8 14 2c 00 00       	call   498b <wait>
    1d77:	39 d8                	cmp    %ebx,%eax
    1d79:	75 2d                	jne    1da8 <exitwait+0x48>
  for(i = 0; i < 100; i++){
    1d7b:	83 ee 01             	sub    $0x1,%esi
    1d7e:	74 41                	je     1dc1 <exitwait+0x61>
    pid = fork();
    1d80:	e8 f6 2b 00 00       	call   497b <fork>
    1d85:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1d87:	85 c0                	test   %eax,%eax
    1d89:	79 e5                	jns    1d70 <exitwait+0x10>
      printf(1, "fork failed\n");
    1d8b:	83 ec 08             	sub    $0x8,%esp
    1d8e:	68 a9 5d 00 00       	push   $0x5da9
    1d93:	6a 01                	push   $0x1
    1d95:	e8 66 2d 00 00       	call   4b00 <printf>
      return;
    1d9a:	83 c4 10             	add    $0x10,%esp
}
    1d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1da0:	5b                   	pop    %ebx
    1da1:	5e                   	pop    %esi
    1da2:	5d                   	pop    %ebp
    1da3:	c3                   	ret    
    1da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
    1da8:	83 ec 08             	sub    $0x8,%esp
    1dab:	68 4b 52 00 00       	push   $0x524b
    1db0:	6a 01                	push   $0x1
    1db2:	e8 49 2d 00 00       	call   4b00 <printf>
        return;
    1db7:	83 c4 10             	add    $0x10,%esp
}
    1dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1dbd:	5b                   	pop    %ebx
    1dbe:	5e                   	pop    %esi
    1dbf:	5d                   	pop    %ebp
    1dc0:	c3                   	ret    
  printf(1, "exitwait ok\n");
    1dc1:	83 ec 08             	sub    $0x8,%esp
    1dc4:	68 5b 52 00 00       	push   $0x525b
    1dc9:	6a 01                	push   $0x1
    1dcb:	e8 30 2d 00 00       	call   4b00 <printf>
    1dd0:	83 c4 10             	add    $0x10,%esp
}
    1dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1dd6:	5b                   	pop    %ebx
    1dd7:	5e                   	pop    %esi
    1dd8:	5d                   	pop    %ebp
    1dd9:	c3                   	ret    
      exit();
    1dda:	e8 a4 2b 00 00       	call   4983 <exit>
    1ddf:	90                   	nop

00001de0 <mem>:
{
    1de0:	f3 0f 1e fb          	endbr32 
    1de4:	55                   	push   %ebp
    1de5:	89 e5                	mov    %esp,%ebp
    1de7:	56                   	push   %esi
    1de8:	31 f6                	xor    %esi,%esi
    1dea:	53                   	push   %ebx
  printf(1, "mem test\n");
    1deb:	83 ec 08             	sub    $0x8,%esp
    1dee:	68 68 52 00 00       	push   $0x5268
    1df3:	6a 01                	push   $0x1
    1df5:	e8 06 2d 00 00       	call   4b00 <printf>
  ppid = getpid();
    1dfa:	e8 04 2c 00 00       	call   4a03 <getpid>
    1dff:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
    1e01:	e8 75 2b 00 00       	call   497b <fork>
    1e06:	83 c4 10             	add    $0x10,%esp
    1e09:	85 c0                	test   %eax,%eax
    1e0b:	74 0f                	je     1e1c <mem+0x3c>
    1e0d:	e9 8e 00 00 00       	jmp    1ea0 <mem+0xc0>
    1e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
    1e18:	89 30                	mov    %esi,(%eax)
    1e1a:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
    1e1c:	83 ec 0c             	sub    $0xc,%esp
    1e1f:	68 11 27 00 00       	push   $0x2711
    1e24:	e8 37 2f 00 00       	call   4d60 <malloc>
    1e29:	83 c4 10             	add    $0x10,%esp
    1e2c:	85 c0                	test   %eax,%eax
    1e2e:	75 e8                	jne    1e18 <mem+0x38>
    while(m1){
    1e30:	85 f6                	test   %esi,%esi
    1e32:	74 18                	je     1e4c <mem+0x6c>
    1e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
    1e38:	89 f0                	mov    %esi,%eax
      free(m1);
    1e3a:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
    1e3d:	8b 36                	mov    (%esi),%esi
      free(m1);
    1e3f:	50                   	push   %eax
    1e40:	e8 8b 2e 00 00       	call   4cd0 <free>
    while(m1){
    1e45:	83 c4 10             	add    $0x10,%esp
    1e48:	85 f6                	test   %esi,%esi
    1e4a:	75 ec                	jne    1e38 <mem+0x58>
    m1 = malloc(1024*20);
    1e4c:	83 ec 0c             	sub    $0xc,%esp
    1e4f:	68 00 50 00 00       	push   $0x5000
    1e54:	e8 07 2f 00 00       	call   4d60 <malloc>
    if(m1 == 0){
    1e59:	83 c4 10             	add    $0x10,%esp
    1e5c:	85 c0                	test   %eax,%eax
    1e5e:	74 20                	je     1e80 <mem+0xa0>
    free(m1);
    1e60:	83 ec 0c             	sub    $0xc,%esp
    1e63:	50                   	push   %eax
    1e64:	e8 67 2e 00 00       	call   4cd0 <free>
    printf(1, "mem ok\n");
    1e69:	58                   	pop    %eax
    1e6a:	5a                   	pop    %edx
    1e6b:	68 8c 52 00 00       	push   $0x528c
    1e70:	6a 01                	push   $0x1
    1e72:	e8 89 2c 00 00       	call   4b00 <printf>
    exit();
    1e77:	e8 07 2b 00 00       	call   4983 <exit>
    1e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
    1e80:	83 ec 08             	sub    $0x8,%esp
    1e83:	68 72 52 00 00       	push   $0x5272
    1e88:	6a 01                	push   $0x1
    1e8a:	e8 71 2c 00 00       	call   4b00 <printf>
      kill(ppid);
    1e8f:	89 1c 24             	mov    %ebx,(%esp)
    1e92:	e8 1c 2b 00 00       	call   49b3 <kill>
      exit();
    1e97:	e8 e7 2a 00 00       	call   4983 <exit>
    1e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
    1ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1ea3:	5b                   	pop    %ebx
    1ea4:	5e                   	pop    %esi
    1ea5:	5d                   	pop    %ebp
    wait();
    1ea6:	e9 e0 2a 00 00       	jmp    498b <wait>
    1eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1eaf:	90                   	nop

00001eb0 <sharedfd>:
{
    1eb0:	f3 0f 1e fb          	endbr32 
    1eb4:	55                   	push   %ebp
    1eb5:	89 e5                	mov    %esp,%ebp
    1eb7:	57                   	push   %edi
    1eb8:	56                   	push   %esi
    1eb9:	53                   	push   %ebx
    1eba:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
    1ebd:	68 94 52 00 00       	push   $0x5294
    1ec2:	6a 01                	push   $0x1
    1ec4:	e8 37 2c 00 00       	call   4b00 <printf>
  unlink("sharedfd");
    1ec9:	c7 04 24 a3 52 00 00 	movl   $0x52a3,(%esp)
    1ed0:	e8 fe 2a 00 00       	call   49d3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1ed5:	5b                   	pop    %ebx
    1ed6:	5e                   	pop    %esi
    1ed7:	68 02 02 00 00       	push   $0x202
    1edc:	68 a3 52 00 00       	push   $0x52a3
    1ee1:	e8 dd 2a 00 00       	call   49c3 <open>
  if(fd < 0){
    1ee6:	83 c4 10             	add    $0x10,%esp
    1ee9:	85 c0                	test   %eax,%eax
    1eeb:	0f 88 26 01 00 00    	js     2017 <sharedfd+0x167>
    1ef1:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1ef3:	8d 75 de             	lea    -0x22(%ebp),%esi
    1ef6:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
    1efb:	e8 7b 2a 00 00       	call   497b <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1f00:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
    1f03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1f06:	19 c0                	sbb    %eax,%eax
    1f08:	83 ec 04             	sub    $0x4,%esp
    1f0b:	83 e0 f3             	and    $0xfffffff3,%eax
    1f0e:	6a 0a                	push   $0xa
    1f10:	83 c0 70             	add    $0x70,%eax
    1f13:	50                   	push   %eax
    1f14:	56                   	push   %esi
    1f15:	e8 c6 28 00 00       	call   47e0 <memset>
    1f1a:	83 c4 10             	add    $0x10,%esp
    1f1d:	eb 06                	jmp    1f25 <sharedfd+0x75>
    1f1f:	90                   	nop
  for(i = 0; i < 1000; i++){
    1f20:	83 eb 01             	sub    $0x1,%ebx
    1f23:	74 26                	je     1f4b <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1f25:	83 ec 04             	sub    $0x4,%esp
    1f28:	6a 0a                	push   $0xa
    1f2a:	56                   	push   %esi
    1f2b:	57                   	push   %edi
    1f2c:	e8 72 2a 00 00       	call   49a3 <write>
    1f31:	83 c4 10             	add    $0x10,%esp
    1f34:	83 f8 0a             	cmp    $0xa,%eax
    1f37:	74 e7                	je     1f20 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
    1f39:	83 ec 08             	sub    $0x8,%esp
    1f3c:	68 94 5f 00 00       	push   $0x5f94
    1f41:	6a 01                	push   $0x1
    1f43:	e8 b8 2b 00 00       	call   4b00 <printf>
      break;
    1f48:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
    1f4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1f4e:	85 c9                	test   %ecx,%ecx
    1f50:	0f 84 f5 00 00 00    	je     204b <sharedfd+0x19b>
    wait();
    1f56:	e8 30 2a 00 00       	call   498b <wait>
  close(fd);
    1f5b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
    1f5e:	31 db                	xor    %ebx,%ebx
  close(fd);
    1f60:	57                   	push   %edi
    1f61:	8d 7d e8             	lea    -0x18(%ebp),%edi
    1f64:	e8 42 2a 00 00       	call   49ab <close>
  fd = open("sharedfd", 0);
    1f69:	58                   	pop    %eax
    1f6a:	5a                   	pop    %edx
    1f6b:	6a 00                	push   $0x0
    1f6d:	68 a3 52 00 00       	push   $0x52a3
    1f72:	e8 4c 2a 00 00       	call   49c3 <open>
  if(fd < 0){
    1f77:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
    1f7a:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
    1f7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
    1f7f:	85 c0                	test   %eax,%eax
    1f81:	0f 88 aa 00 00 00    	js     2031 <sharedfd+0x181>
    1f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1f8e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1f90:	83 ec 04             	sub    $0x4,%esp
    1f93:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1f96:	6a 0a                	push   $0xa
    1f98:	56                   	push   %esi
    1f99:	ff 75 d0             	pushl  -0x30(%ebp)
    1f9c:	e8 fa 29 00 00       	call   499b <read>
    1fa1:	83 c4 10             	add    $0x10,%esp
    1fa4:	85 c0                	test   %eax,%eax
    1fa6:	7e 28                	jle    1fd0 <sharedfd+0x120>
    for(i = 0; i < sizeof(buf); i++){
    1fa8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    1fab:	89 f0                	mov    %esi,%eax
    1fad:	eb 13                	jmp    1fc2 <sharedfd+0x112>
    1faf:	90                   	nop
        np++;
    1fb0:	80 f9 70             	cmp    $0x70,%cl
    1fb3:	0f 94 c1             	sete   %cl
    1fb6:	0f b6 c9             	movzbl %cl,%ecx
    1fb9:	01 cb                	add    %ecx,%ebx
    for(i = 0; i < sizeof(buf); i++){
    1fbb:	83 c0 01             	add    $0x1,%eax
    1fbe:	39 c7                	cmp    %eax,%edi
    1fc0:	74 ce                	je     1f90 <sharedfd+0xe0>
      if(buf[i] == 'c')
    1fc2:	0f b6 08             	movzbl (%eax),%ecx
    1fc5:	80 f9 63             	cmp    $0x63,%cl
    1fc8:	75 e6                	jne    1fb0 <sharedfd+0x100>
        nc++;
    1fca:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
    1fcd:	eb ec                	jmp    1fbb <sharedfd+0x10b>
    1fcf:	90                   	nop
  close(fd);
    1fd0:	83 ec 0c             	sub    $0xc,%esp
    1fd3:	ff 75 d0             	pushl  -0x30(%ebp)
    1fd6:	e8 d0 29 00 00       	call   49ab <close>
  unlink("sharedfd");
    1fdb:	c7 04 24 a3 52 00 00 	movl   $0x52a3,(%esp)
    1fe2:	e8 ec 29 00 00       	call   49d3 <unlink>
  if(nc == 10000 && np == 10000){
    1fe7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    1fea:	83 c4 10             	add    $0x10,%esp
    1fed:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
    1ff3:	75 5b                	jne    2050 <sharedfd+0x1a0>
    1ff5:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    1ffb:	75 53                	jne    2050 <sharedfd+0x1a0>
    printf(1, "sharedfd ok\n");
    1ffd:	83 ec 08             	sub    $0x8,%esp
    2000:	68 ac 52 00 00       	push   $0x52ac
    2005:	6a 01                	push   $0x1
    2007:	e8 f4 2a 00 00       	call   4b00 <printf>
    200c:	83 c4 10             	add    $0x10,%esp
}
    200f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2012:	5b                   	pop    %ebx
    2013:	5e                   	pop    %esi
    2014:	5f                   	pop    %edi
    2015:	5d                   	pop    %ebp
    2016:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
    2017:	83 ec 08             	sub    $0x8,%esp
    201a:	68 68 5f 00 00       	push   $0x5f68
    201f:	6a 01                	push   $0x1
    2021:	e8 da 2a 00 00       	call   4b00 <printf>
    return;
    2026:	83 c4 10             	add    $0x10,%esp
}
    2029:	8d 65 f4             	lea    -0xc(%ebp),%esp
    202c:	5b                   	pop    %ebx
    202d:	5e                   	pop    %esi
    202e:	5f                   	pop    %edi
    202f:	5d                   	pop    %ebp
    2030:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
    2031:	83 ec 08             	sub    $0x8,%esp
    2034:	68 b4 5f 00 00       	push   $0x5fb4
    2039:	6a 01                	push   $0x1
    203b:	e8 c0 2a 00 00       	call   4b00 <printf>
    return;
    2040:	83 c4 10             	add    $0x10,%esp
}
    2043:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2046:	5b                   	pop    %ebx
    2047:	5e                   	pop    %esi
    2048:	5f                   	pop    %edi
    2049:	5d                   	pop    %ebp
    204a:	c3                   	ret    
    exit();
    204b:	e8 33 29 00 00       	call   4983 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
    2050:	53                   	push   %ebx
    2051:	52                   	push   %edx
    2052:	68 b9 52 00 00       	push   $0x52b9
    2057:	6a 01                	push   $0x1
    2059:	e8 a2 2a 00 00       	call   4b00 <printf>
    exit();
    205e:	e8 20 29 00 00       	call   4983 <exit>
    2063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00002070 <fourfiles>:
{
    2070:	f3 0f 1e fb          	endbr32 
    2074:	55                   	push   %ebp
    2075:	89 e5                	mov    %esp,%ebp
    2077:	57                   	push   %edi
    2078:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    2079:	be ce 52 00 00       	mov    $0x52ce,%esi
{
    207e:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    207f:	31 db                	xor    %ebx,%ebx
{
    2081:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    2084:	c7 45 d8 ce 52 00 00 	movl   $0x52ce,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    208b:	68 d4 52 00 00       	push   $0x52d4
    2090:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    2092:	c7 45 dc 17 54 00 00 	movl   $0x5417,-0x24(%ebp)
    2099:	c7 45 e0 1b 54 00 00 	movl   $0x541b,-0x20(%ebp)
    20a0:	c7 45 e4 d1 52 00 00 	movl   $0x52d1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    20a7:	e8 54 2a 00 00       	call   4b00 <printf>
    20ac:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    20af:	83 ec 0c             	sub    $0xc,%esp
    20b2:	56                   	push   %esi
    20b3:	e8 1b 29 00 00       	call   49d3 <unlink>
    pid = fork();
    20b8:	e8 be 28 00 00       	call   497b <fork>
    if(pid < 0){
    20bd:	83 c4 10             	add    $0x10,%esp
    20c0:	85 c0                	test   %eax,%eax
    20c2:	0f 88 60 01 00 00    	js     2228 <fourfiles+0x1b8>
    if(pid == 0){
    20c8:	0f 84 e5 00 00 00    	je     21b3 <fourfiles+0x143>
  for(pi = 0; pi < 4; pi++){
    20ce:	83 c3 01             	add    $0x1,%ebx
    20d1:	83 fb 04             	cmp    $0x4,%ebx
    20d4:	74 06                	je     20dc <fourfiles+0x6c>
    20d6:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    20da:	eb d3                	jmp    20af <fourfiles+0x3f>
    wait();
    20dc:	e8 aa 28 00 00       	call   498b <wait>
  for(i = 0; i < 2; i++){
    20e1:	31 f6                	xor    %esi,%esi
    wait();
    20e3:	e8 a3 28 00 00       	call   498b <wait>
    20e8:	e8 9e 28 00 00       	call   498b <wait>
    20ed:	e8 99 28 00 00       	call   498b <wait>
    fname = names[i];
    20f2:	8b 44 b5 d8          	mov    -0x28(%ebp,%esi,4),%eax
    fd = open(fname, 0);
    20f6:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    20f9:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    20fb:	6a 00                	push   $0x0
    20fd:	50                   	push   %eax
    fname = names[i];
    20fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
    2101:	e8 bd 28 00 00       	call   49c3 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2106:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    2109:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2110:	83 ec 04             	sub    $0x4,%esp
    2113:	68 00 20 00 00       	push   $0x2000
    2118:	68 e0 96 00 00       	push   $0x96e0
    211d:	ff 75 d4             	pushl  -0x2c(%ebp)
    2120:	e8 76 28 00 00       	call   499b <read>
    2125:	83 c4 10             	add    $0x10,%esp
    2128:	85 c0                	test   %eax,%eax
    212a:	7e 22                	jle    214e <fourfiles+0xde>
      for(j = 0; j < n; j++){
    212c:	31 d2                	xor    %edx,%edx
    212e:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    2130:	83 fe 01             	cmp    $0x1,%esi
    2133:	0f be ba e0 96 00 00 	movsbl 0x96e0(%edx),%edi
    213a:	19 c9                	sbb    %ecx,%ecx
    213c:	83 c1 31             	add    $0x31,%ecx
    213f:	39 cf                	cmp    %ecx,%edi
    2141:	75 5c                	jne    219f <fourfiles+0x12f>
      for(j = 0; j < n; j++){
    2143:	83 c2 01             	add    $0x1,%edx
    2146:	39 d0                	cmp    %edx,%eax
    2148:	75 e6                	jne    2130 <fourfiles+0xc0>
      total += n;
    214a:	01 c3                	add    %eax,%ebx
    214c:	eb c2                	jmp    2110 <fourfiles+0xa0>
    close(fd);
    214e:	83 ec 0c             	sub    $0xc,%esp
    2151:	ff 75 d4             	pushl  -0x2c(%ebp)
    2154:	e8 52 28 00 00       	call   49ab <close>
    if(total != 12*500){
    2159:	83 c4 10             	add    $0x10,%esp
    215c:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    2162:	0f 85 d4 00 00 00    	jne    223c <fourfiles+0x1cc>
    unlink(fname);
    2168:	83 ec 0c             	sub    $0xc,%esp
    216b:	ff 75 d0             	pushl  -0x30(%ebp)
    216e:	e8 60 28 00 00       	call   49d3 <unlink>
  for(i = 0; i < 2; i++){
    2173:	83 c4 10             	add    $0x10,%esp
    2176:	83 fe 01             	cmp    $0x1,%esi
    2179:	75 1a                	jne    2195 <fourfiles+0x125>
  printf(1, "fourfiles ok\n");
    217b:	83 ec 08             	sub    $0x8,%esp
    217e:	68 12 53 00 00       	push   $0x5312
    2183:	6a 01                	push   $0x1
    2185:	e8 76 29 00 00       	call   4b00 <printf>
}
    218a:	83 c4 10             	add    $0x10,%esp
    218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2190:	5b                   	pop    %ebx
    2191:	5e                   	pop    %esi
    2192:	5f                   	pop    %edi
    2193:	5d                   	pop    %ebp
    2194:	c3                   	ret    
    2195:	be 01 00 00 00       	mov    $0x1,%esi
    219a:	e9 53 ff ff ff       	jmp    20f2 <fourfiles+0x82>
          printf(1, "wrong char\n");
    219f:	83 ec 08             	sub    $0x8,%esp
    21a2:	68 f5 52 00 00       	push   $0x52f5
    21a7:	6a 01                	push   $0x1
    21a9:	e8 52 29 00 00       	call   4b00 <printf>
          exit();
    21ae:	e8 d0 27 00 00       	call   4983 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    21b3:	83 ec 08             	sub    $0x8,%esp
    21b6:	68 02 02 00 00       	push   $0x202
    21bb:	56                   	push   %esi
    21bc:	e8 02 28 00 00       	call   49c3 <open>
      if(fd < 0){
    21c1:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    21c4:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    21c6:	85 c0                	test   %eax,%eax
    21c8:	78 45                	js     220f <fourfiles+0x19f>
      memset(buf, '0'+pi, 512);
    21ca:	83 ec 04             	sub    $0x4,%esp
    21cd:	83 c3 30             	add    $0x30,%ebx
    21d0:	68 00 02 00 00       	push   $0x200
    21d5:	53                   	push   %ebx
    21d6:	bb 0c 00 00 00       	mov    $0xc,%ebx
    21db:	68 e0 96 00 00       	push   $0x96e0
    21e0:	e8 fb 25 00 00       	call   47e0 <memset>
    21e5:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    21e8:	83 ec 04             	sub    $0x4,%esp
    21eb:	68 f4 01 00 00       	push   $0x1f4
    21f0:	68 e0 96 00 00       	push   $0x96e0
    21f5:	56                   	push   %esi
    21f6:	e8 a8 27 00 00       	call   49a3 <write>
    21fb:	83 c4 10             	add    $0x10,%esp
    21fe:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    2203:	75 4a                	jne    224f <fourfiles+0x1df>
      for(i = 0; i < 12; i++){
    2205:	83 eb 01             	sub    $0x1,%ebx
    2208:	75 de                	jne    21e8 <fourfiles+0x178>
      exit();
    220a:	e8 74 27 00 00       	call   4983 <exit>
        printf(1, "create failed\n");
    220f:	51                   	push   %ecx
    2210:	51                   	push   %ecx
    2211:	68 6f 55 00 00       	push   $0x556f
    2216:	6a 01                	push   $0x1
    2218:	e8 e3 28 00 00       	call   4b00 <printf>
        exit();
    221d:	e8 61 27 00 00       	call   4983 <exit>
    2222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    2228:	83 ec 08             	sub    $0x8,%esp
    222b:	68 a9 5d 00 00       	push   $0x5da9
    2230:	6a 01                	push   $0x1
    2232:	e8 c9 28 00 00       	call   4b00 <printf>
      exit();
    2237:	e8 47 27 00 00       	call   4983 <exit>
      printf(1, "wrong length %d\n", total);
    223c:	50                   	push   %eax
    223d:	53                   	push   %ebx
    223e:	68 01 53 00 00       	push   $0x5301
    2243:	6a 01                	push   $0x1
    2245:	e8 b6 28 00 00       	call   4b00 <printf>
      exit();
    224a:	e8 34 27 00 00       	call   4983 <exit>
          printf(1, "write failed %d\n", n);
    224f:	52                   	push   %edx
    2250:	50                   	push   %eax
    2251:	68 e4 52 00 00       	push   $0x52e4
    2256:	6a 01                	push   $0x1
    2258:	e8 a3 28 00 00       	call   4b00 <printf>
          exit();
    225d:	e8 21 27 00 00       	call   4983 <exit>
    2262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002270 <createdelete>:
{
    2270:	f3 0f 1e fb          	endbr32 
    2274:	55                   	push   %ebp
    2275:	89 e5                	mov    %esp,%ebp
    2277:	57                   	push   %edi
    2278:	56                   	push   %esi
    2279:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    227a:	31 db                	xor    %ebx,%ebx
{
    227c:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    227f:	68 20 53 00 00       	push   $0x5320
    2284:	6a 01                	push   $0x1
    2286:	e8 75 28 00 00       	call   4b00 <printf>
    228b:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    228e:	e8 e8 26 00 00       	call   497b <fork>
    if(pid < 0){
    2293:	85 c0                	test   %eax,%eax
    2295:	0f 88 ce 01 00 00    	js     2469 <createdelete+0x1f9>
    if(pid == 0){
    229b:	0f 84 17 01 00 00    	je     23b8 <createdelete+0x148>
  for(pi = 0; pi < 4; pi++){
    22a1:	83 c3 01             	add    $0x1,%ebx
    22a4:	83 fb 04             	cmp    $0x4,%ebx
    22a7:	75 e5                	jne    228e <createdelete+0x1e>
    wait();
    22a9:	e8 dd 26 00 00       	call   498b <wait>
    22ae:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    22b1:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    22b6:	e8 d0 26 00 00       	call   498b <wait>
    22bb:	e8 cb 26 00 00       	call   498b <wait>
    22c0:	e8 c6 26 00 00       	call   498b <wait>
  name[0] = name[1] = name[2] = 0;
    22c5:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    22c9:	89 7d c0             	mov    %edi,-0x40(%ebp)
    22cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(pi = 0; pi < 4; pi++){
    22d0:	8d 46 31             	lea    0x31(%esi),%eax
    22d3:	89 f7                	mov    %esi,%edi
    22d5:	83 c6 01             	add    $0x1,%esi
    22d8:	83 fe 09             	cmp    $0x9,%esi
    22db:	88 45 c7             	mov    %al,-0x39(%ebp)
    22de:	0f 9f c3             	setg   %bl
    22e1:	85 f6                	test   %esi,%esi
    22e3:	0f 94 c0             	sete   %al
    22e6:	09 c3                	or     %eax,%ebx
    22e8:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    22eb:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    22f0:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    22f3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    22f7:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    22fa:	6a 00                	push   $0x0
    22fc:	ff 75 c0             	pushl  -0x40(%ebp)
      name[1] = '0' + i;
    22ff:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    2302:	e8 bc 26 00 00       	call   49c3 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    2307:	83 c4 10             	add    $0x10,%esp
    230a:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    230e:	0f 84 8c 00 00 00    	je     23a0 <createdelete+0x130>
    2314:	85 c0                	test   %eax,%eax
    2316:	0f 88 21 01 00 00    	js     243d <createdelete+0x1cd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    231c:	83 ff 08             	cmp    $0x8,%edi
    231f:	0f 86 60 01 00 00    	jbe    2485 <createdelete+0x215>
        close(fd);
    2325:	83 ec 0c             	sub    $0xc,%esp
    2328:	50                   	push   %eax
    2329:	e8 7d 26 00 00       	call   49ab <close>
    232e:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    2331:	83 c3 01             	add    $0x1,%ebx
    2334:	80 fb 74             	cmp    $0x74,%bl
    2337:	75 b7                	jne    22f0 <createdelete+0x80>
  for(i = 0; i < N; i++){
    2339:	83 fe 13             	cmp    $0x13,%esi
    233c:	75 92                	jne    22d0 <createdelete+0x60>
    233e:	8b 7d c0             	mov    -0x40(%ebp),%edi
    2341:	be 70 00 00 00       	mov    $0x70,%esi
    2346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    234d:	8d 76 00             	lea    0x0(%esi),%esi
    for(pi = 0; pi < 4; pi++){
    2350:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    2353:	bb 04 00 00 00       	mov    $0x4,%ebx
    2358:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    235b:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    235e:	89 f0                	mov    %esi,%eax
      unlink(name);
    2360:	57                   	push   %edi
      name[0] = 'p' + i;
    2361:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    2364:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    2368:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    236b:	e8 63 26 00 00       	call   49d3 <unlink>
    for(pi = 0; pi < 4; pi++){
    2370:	83 c4 10             	add    $0x10,%esp
    2373:	83 eb 01             	sub    $0x1,%ebx
    2376:	75 e3                	jne    235b <createdelete+0xeb>
  for(i = 0; i < N; i++){
    2378:	83 c6 01             	add    $0x1,%esi
    237b:	89 f0                	mov    %esi,%eax
    237d:	3c 84                	cmp    $0x84,%al
    237f:	75 cf                	jne    2350 <createdelete+0xe0>
  printf(1, "createdelete ok\n");
    2381:	83 ec 08             	sub    $0x8,%esp
    2384:	68 33 53 00 00       	push   $0x5333
    2389:	6a 01                	push   $0x1
    238b:	e8 70 27 00 00       	call   4b00 <printf>
}
    2390:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2393:	5b                   	pop    %ebx
    2394:	5e                   	pop    %esi
    2395:	5f                   	pop    %edi
    2396:	5d                   	pop    %ebp
    2397:	c3                   	ret    
    2398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    239f:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    23a0:	83 ff 08             	cmp    $0x8,%edi
    23a3:	0f 86 d4 00 00 00    	jbe    247d <createdelete+0x20d>
      if(fd >= 0)
    23a9:	85 c0                	test   %eax,%eax
    23ab:	78 84                	js     2331 <createdelete+0xc1>
    23ad:	e9 73 ff ff ff       	jmp    2325 <createdelete+0xb5>
    23b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    23b8:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    23bb:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    23bf:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    23c2:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    23c5:	31 db                	xor    %ebx,%ebx
    23c7:	eb 0f                	jmp    23d8 <createdelete+0x168>
    23c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    23d0:	83 fb 13             	cmp    $0x13,%ebx
    23d3:	74 63                	je     2438 <createdelete+0x1c8>
    23d5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    23d8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    23db:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    23de:	68 02 02 00 00       	push   $0x202
    23e3:	57                   	push   %edi
        name[1] = '0' + i;
    23e4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    23e7:	e8 d7 25 00 00       	call   49c3 <open>
        if(fd < 0){
    23ec:	83 c4 10             	add    $0x10,%esp
    23ef:	85 c0                	test   %eax,%eax
    23f1:	78 62                	js     2455 <createdelete+0x1e5>
        close(fd);
    23f3:	83 ec 0c             	sub    $0xc,%esp
    23f6:	50                   	push   %eax
    23f7:	e8 af 25 00 00       	call   49ab <close>
        if(i > 0 && (i % 2 ) == 0){
    23fc:	83 c4 10             	add    $0x10,%esp
    23ff:	85 db                	test   %ebx,%ebx
    2401:	74 d2                	je     23d5 <createdelete+0x165>
    2403:	f6 c3 01             	test   $0x1,%bl
    2406:	75 c8                	jne    23d0 <createdelete+0x160>
          if(unlink(name) < 0){
    2408:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    240b:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    240d:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    240e:	d1 f8                	sar    %eax
    2410:	83 c0 30             	add    $0x30,%eax
    2413:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    2416:	e8 b8 25 00 00       	call   49d3 <unlink>
    241b:	83 c4 10             	add    $0x10,%esp
    241e:	85 c0                	test   %eax,%eax
    2420:	79 ae                	jns    23d0 <createdelete+0x160>
            printf(1, "unlink failed\n");
    2422:	52                   	push   %edx
    2423:	52                   	push   %edx
    2424:	68 21 4f 00 00       	push   $0x4f21
    2429:	6a 01                	push   $0x1
    242b:	e8 d0 26 00 00       	call   4b00 <printf>
            exit();
    2430:	e8 4e 25 00 00       	call   4983 <exit>
    2435:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    2438:	e8 46 25 00 00       	call   4983 <exit>
    243d:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s didn't exist\n", name);
    2440:	83 ec 04             	sub    $0x4,%esp
    2443:	57                   	push   %edi
    2444:	68 e0 5f 00 00       	push   $0x5fe0
    2449:	6a 01                	push   $0x1
    244b:	e8 b0 26 00 00       	call   4b00 <printf>
        exit();
    2450:	e8 2e 25 00 00       	call   4983 <exit>
          printf(1, "create failed\n");
    2455:	83 ec 08             	sub    $0x8,%esp
    2458:	68 6f 55 00 00       	push   $0x556f
    245d:	6a 01                	push   $0x1
    245f:	e8 9c 26 00 00       	call   4b00 <printf>
          exit();
    2464:	e8 1a 25 00 00       	call   4983 <exit>
      printf(1, "fork failed\n");
    2469:	83 ec 08             	sub    $0x8,%esp
    246c:	68 a9 5d 00 00       	push   $0x5da9
    2471:	6a 01                	push   $0x1
    2473:	e8 88 26 00 00       	call   4b00 <printf>
      exit();
    2478:	e8 06 25 00 00       	call   4983 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    247d:	85 c0                	test   %eax,%eax
    247f:	0f 88 ac fe ff ff    	js     2331 <createdelete+0xc1>
    2485:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s did exist\n", name);
    2488:	50                   	push   %eax
    2489:	57                   	push   %edi
    248a:	68 04 60 00 00       	push   $0x6004
    248f:	6a 01                	push   $0x1
    2491:	e8 6a 26 00 00       	call   4b00 <printf>
        exit();
    2496:	e8 e8 24 00 00       	call   4983 <exit>
    249b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    249f:	90                   	nop

000024a0 <unlinkread>:
{
    24a0:	f3 0f 1e fb          	endbr32 
    24a4:	55                   	push   %ebp
    24a5:	89 e5                	mov    %esp,%ebp
    24a7:	56                   	push   %esi
    24a8:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    24a9:	83 ec 08             	sub    $0x8,%esp
    24ac:	68 44 53 00 00       	push   $0x5344
    24b1:	6a 01                	push   $0x1
    24b3:	e8 48 26 00 00       	call   4b00 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    24b8:	5b                   	pop    %ebx
    24b9:	5e                   	pop    %esi
    24ba:	68 02 02 00 00       	push   $0x202
    24bf:	68 55 53 00 00       	push   $0x5355
    24c4:	e8 fa 24 00 00       	call   49c3 <open>
  if(fd < 0){
    24c9:	83 c4 10             	add    $0x10,%esp
    24cc:	85 c0                	test   %eax,%eax
    24ce:	0f 88 e6 00 00 00    	js     25ba <unlinkread+0x11a>
  write(fd, "hello", 5);
    24d4:	83 ec 04             	sub    $0x4,%esp
    24d7:	89 c3                	mov    %eax,%ebx
    24d9:	6a 05                	push   $0x5
    24db:	68 7a 53 00 00       	push   $0x537a
    24e0:	50                   	push   %eax
    24e1:	e8 bd 24 00 00       	call   49a3 <write>
  close(fd);
    24e6:	89 1c 24             	mov    %ebx,(%esp)
    24e9:	e8 bd 24 00 00       	call   49ab <close>
  fd = open("unlinkread", O_RDWR);
    24ee:	58                   	pop    %eax
    24ef:	5a                   	pop    %edx
    24f0:	6a 02                	push   $0x2
    24f2:	68 55 53 00 00       	push   $0x5355
    24f7:	e8 c7 24 00 00       	call   49c3 <open>
  if(fd < 0){
    24fc:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    24ff:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2501:	85 c0                	test   %eax,%eax
    2503:	0f 88 10 01 00 00    	js     2619 <unlinkread+0x179>
  if(unlink("unlinkread") != 0){
    2509:	83 ec 0c             	sub    $0xc,%esp
    250c:	68 55 53 00 00       	push   $0x5355
    2511:	e8 bd 24 00 00       	call   49d3 <unlink>
    2516:	83 c4 10             	add    $0x10,%esp
    2519:	85 c0                	test   %eax,%eax
    251b:	0f 85 e5 00 00 00    	jne    2606 <unlinkread+0x166>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2521:	83 ec 08             	sub    $0x8,%esp
    2524:	68 02 02 00 00       	push   $0x202
    2529:	68 55 53 00 00       	push   $0x5355
    252e:	e8 90 24 00 00       	call   49c3 <open>
  write(fd1, "yyy", 3);
    2533:	83 c4 0c             	add    $0xc,%esp
    2536:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2538:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    253a:	68 b2 53 00 00       	push   $0x53b2
    253f:	50                   	push   %eax
    2540:	e8 5e 24 00 00       	call   49a3 <write>
  close(fd1);
    2545:	89 34 24             	mov    %esi,(%esp)
    2548:	e8 5e 24 00 00       	call   49ab <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    254d:	83 c4 0c             	add    $0xc,%esp
    2550:	68 00 20 00 00       	push   $0x2000
    2555:	68 e0 96 00 00       	push   $0x96e0
    255a:	53                   	push   %ebx
    255b:	e8 3b 24 00 00       	call   499b <read>
    2560:	83 c4 10             	add    $0x10,%esp
    2563:	83 f8 05             	cmp    $0x5,%eax
    2566:	0f 85 87 00 00 00    	jne    25f3 <unlinkread+0x153>
  if(buf[0] != 'h'){
    256c:	80 3d e0 96 00 00 68 	cmpb   $0x68,0x96e0
    2573:	75 6b                	jne    25e0 <unlinkread+0x140>
  if(write(fd, buf, 10) != 10){
    2575:	83 ec 04             	sub    $0x4,%esp
    2578:	6a 0a                	push   $0xa
    257a:	68 e0 96 00 00       	push   $0x96e0
    257f:	53                   	push   %ebx
    2580:	e8 1e 24 00 00       	call   49a3 <write>
    2585:	83 c4 10             	add    $0x10,%esp
    2588:	83 f8 0a             	cmp    $0xa,%eax
    258b:	75 40                	jne    25cd <unlinkread+0x12d>
  close(fd);
    258d:	83 ec 0c             	sub    $0xc,%esp
    2590:	53                   	push   %ebx
    2591:	e8 15 24 00 00       	call   49ab <close>
  unlink("unlinkread");
    2596:	c7 04 24 55 53 00 00 	movl   $0x5355,(%esp)
    259d:	e8 31 24 00 00       	call   49d3 <unlink>
  printf(1, "unlinkread ok\n");
    25a2:	58                   	pop    %eax
    25a3:	5a                   	pop    %edx
    25a4:	68 fd 53 00 00       	push   $0x53fd
    25a9:	6a 01                	push   $0x1
    25ab:	e8 50 25 00 00       	call   4b00 <printf>
}
    25b0:	83 c4 10             	add    $0x10,%esp
    25b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    25b6:	5b                   	pop    %ebx
    25b7:	5e                   	pop    %esi
    25b8:	5d                   	pop    %ebp
    25b9:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    25ba:	51                   	push   %ecx
    25bb:	51                   	push   %ecx
    25bc:	68 60 53 00 00       	push   $0x5360
    25c1:	6a 01                	push   $0x1
    25c3:	e8 38 25 00 00       	call   4b00 <printf>
    exit();
    25c8:	e8 b6 23 00 00       	call   4983 <exit>
    printf(1, "unlinkread write failed\n");
    25cd:	51                   	push   %ecx
    25ce:	51                   	push   %ecx
    25cf:	68 e4 53 00 00       	push   $0x53e4
    25d4:	6a 01                	push   $0x1
    25d6:	e8 25 25 00 00       	call   4b00 <printf>
    exit();
    25db:	e8 a3 23 00 00       	call   4983 <exit>
    printf(1, "unlinkread wrong data\n");
    25e0:	53                   	push   %ebx
    25e1:	53                   	push   %ebx
    25e2:	68 cd 53 00 00       	push   $0x53cd
    25e7:	6a 01                	push   $0x1
    25e9:	e8 12 25 00 00       	call   4b00 <printf>
    exit();
    25ee:	e8 90 23 00 00       	call   4983 <exit>
    printf(1, "unlinkread read failed");
    25f3:	56                   	push   %esi
    25f4:	56                   	push   %esi
    25f5:	68 b6 53 00 00       	push   $0x53b6
    25fa:	6a 01                	push   $0x1
    25fc:	e8 ff 24 00 00       	call   4b00 <printf>
    exit();
    2601:	e8 7d 23 00 00       	call   4983 <exit>
    printf(1, "unlink unlinkread failed\n");
    2606:	50                   	push   %eax
    2607:	50                   	push   %eax
    2608:	68 98 53 00 00       	push   $0x5398
    260d:	6a 01                	push   $0x1
    260f:	e8 ec 24 00 00       	call   4b00 <printf>
    exit();
    2614:	e8 6a 23 00 00       	call   4983 <exit>
    printf(1, "open unlinkread failed\n");
    2619:	50                   	push   %eax
    261a:	50                   	push   %eax
    261b:	68 80 53 00 00       	push   $0x5380
    2620:	6a 01                	push   $0x1
    2622:	e8 d9 24 00 00       	call   4b00 <printf>
    exit();
    2627:	e8 57 23 00 00       	call   4983 <exit>
    262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002630 <linktest>:
{
    2630:	f3 0f 1e fb          	endbr32 
    2634:	55                   	push   %ebp
    2635:	89 e5                	mov    %esp,%ebp
    2637:	53                   	push   %ebx
    2638:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    263b:	68 0c 54 00 00       	push   $0x540c
    2640:	6a 01                	push   $0x1
    2642:	e8 b9 24 00 00       	call   4b00 <printf>
  unlink("lf1");
    2647:	c7 04 24 16 54 00 00 	movl   $0x5416,(%esp)
    264e:	e8 80 23 00 00       	call   49d3 <unlink>
  unlink("lf2");
    2653:	c7 04 24 1a 54 00 00 	movl   $0x541a,(%esp)
    265a:	e8 74 23 00 00       	call   49d3 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    265f:	58                   	pop    %eax
    2660:	5a                   	pop    %edx
    2661:	68 02 02 00 00       	push   $0x202
    2666:	68 16 54 00 00       	push   $0x5416
    266b:	e8 53 23 00 00       	call   49c3 <open>
  if(fd < 0){
    2670:	83 c4 10             	add    $0x10,%esp
    2673:	85 c0                	test   %eax,%eax
    2675:	0f 88 1e 01 00 00    	js     2799 <linktest+0x169>
  if(write(fd, "hello", 5) != 5){
    267b:	83 ec 04             	sub    $0x4,%esp
    267e:	89 c3                	mov    %eax,%ebx
    2680:	6a 05                	push   $0x5
    2682:	68 7a 53 00 00       	push   $0x537a
    2687:	50                   	push   %eax
    2688:	e8 16 23 00 00       	call   49a3 <write>
    268d:	83 c4 10             	add    $0x10,%esp
    2690:	83 f8 05             	cmp    $0x5,%eax
    2693:	0f 85 98 01 00 00    	jne    2831 <linktest+0x201>
  close(fd);
    2699:	83 ec 0c             	sub    $0xc,%esp
    269c:	53                   	push   %ebx
    269d:	e8 09 23 00 00       	call   49ab <close>
  if(link("lf1", "lf2") < 0){
    26a2:	5b                   	pop    %ebx
    26a3:	58                   	pop    %eax
    26a4:	68 1a 54 00 00       	push   $0x541a
    26a9:	68 16 54 00 00       	push   $0x5416
    26ae:	e8 30 23 00 00       	call   49e3 <link>
    26b3:	83 c4 10             	add    $0x10,%esp
    26b6:	85 c0                	test   %eax,%eax
    26b8:	0f 88 60 01 00 00    	js     281e <linktest+0x1ee>
  unlink("lf1");
    26be:	83 ec 0c             	sub    $0xc,%esp
    26c1:	68 16 54 00 00       	push   $0x5416
    26c6:	e8 08 23 00 00       	call   49d3 <unlink>
  if(open("lf1", 0) >= 0){
    26cb:	58                   	pop    %eax
    26cc:	5a                   	pop    %edx
    26cd:	6a 00                	push   $0x0
    26cf:	68 16 54 00 00       	push   $0x5416
    26d4:	e8 ea 22 00 00       	call   49c3 <open>
    26d9:	83 c4 10             	add    $0x10,%esp
    26dc:	85 c0                	test   %eax,%eax
    26de:	0f 89 27 01 00 00    	jns    280b <linktest+0x1db>
  fd = open("lf2", 0);
    26e4:	83 ec 08             	sub    $0x8,%esp
    26e7:	6a 00                	push   $0x0
    26e9:	68 1a 54 00 00       	push   $0x541a
    26ee:	e8 d0 22 00 00       	call   49c3 <open>
  if(fd < 0){
    26f3:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    26f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    26f8:	85 c0                	test   %eax,%eax
    26fa:	0f 88 f8 00 00 00    	js     27f8 <linktest+0x1c8>
  if(read(fd, buf, sizeof(buf)) != 5){
    2700:	83 ec 04             	sub    $0x4,%esp
    2703:	68 00 20 00 00       	push   $0x2000
    2708:	68 e0 96 00 00       	push   $0x96e0
    270d:	50                   	push   %eax
    270e:	e8 88 22 00 00       	call   499b <read>
    2713:	83 c4 10             	add    $0x10,%esp
    2716:	83 f8 05             	cmp    $0x5,%eax
    2719:	0f 85 c6 00 00 00    	jne    27e5 <linktest+0x1b5>
  close(fd);
    271f:	83 ec 0c             	sub    $0xc,%esp
    2722:	53                   	push   %ebx
    2723:	e8 83 22 00 00       	call   49ab <close>
  if(link("lf2", "lf2") >= 0){
    2728:	58                   	pop    %eax
    2729:	5a                   	pop    %edx
    272a:	68 1a 54 00 00       	push   $0x541a
    272f:	68 1a 54 00 00       	push   $0x541a
    2734:	e8 aa 22 00 00       	call   49e3 <link>
    2739:	83 c4 10             	add    $0x10,%esp
    273c:	85 c0                	test   %eax,%eax
    273e:	0f 89 8e 00 00 00    	jns    27d2 <linktest+0x1a2>
  unlink("lf2");
    2744:	83 ec 0c             	sub    $0xc,%esp
    2747:	68 1a 54 00 00       	push   $0x541a
    274c:	e8 82 22 00 00       	call   49d3 <unlink>
  if(link("lf2", "lf1") >= 0){
    2751:	59                   	pop    %ecx
    2752:	5b                   	pop    %ebx
    2753:	68 16 54 00 00       	push   $0x5416
    2758:	68 1a 54 00 00       	push   $0x541a
    275d:	e8 81 22 00 00       	call   49e3 <link>
    2762:	83 c4 10             	add    $0x10,%esp
    2765:	85 c0                	test   %eax,%eax
    2767:	79 56                	jns    27bf <linktest+0x18f>
  if(link(".", "lf1") >= 0){
    2769:	83 ec 08             	sub    $0x8,%esp
    276c:	68 16 54 00 00       	push   $0x5416
    2771:	68 de 56 00 00       	push   $0x56de
    2776:	e8 68 22 00 00       	call   49e3 <link>
    277b:	83 c4 10             	add    $0x10,%esp
    277e:	85 c0                	test   %eax,%eax
    2780:	79 2a                	jns    27ac <linktest+0x17c>
  printf(1, "linktest ok\n");
    2782:	83 ec 08             	sub    $0x8,%esp
    2785:	68 b4 54 00 00       	push   $0x54b4
    278a:	6a 01                	push   $0x1
    278c:	e8 6f 23 00 00       	call   4b00 <printf>
}
    2791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2794:	83 c4 10             	add    $0x10,%esp
    2797:	c9                   	leave  
    2798:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    2799:	50                   	push   %eax
    279a:	50                   	push   %eax
    279b:	68 1e 54 00 00       	push   $0x541e
    27a0:	6a 01                	push   $0x1
    27a2:	e8 59 23 00 00       	call   4b00 <printf>
    exit();
    27a7:	e8 d7 21 00 00       	call   4983 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    27ac:	50                   	push   %eax
    27ad:	50                   	push   %eax
    27ae:	68 98 54 00 00       	push   $0x5498
    27b3:	6a 01                	push   $0x1
    27b5:	e8 46 23 00 00       	call   4b00 <printf>
    exit();
    27ba:	e8 c4 21 00 00       	call   4983 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    27bf:	52                   	push   %edx
    27c0:	52                   	push   %edx
    27c1:	68 4c 60 00 00       	push   $0x604c
    27c6:	6a 01                	push   $0x1
    27c8:	e8 33 23 00 00       	call   4b00 <printf>
    exit();
    27cd:	e8 b1 21 00 00       	call   4983 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    27d2:	50                   	push   %eax
    27d3:	50                   	push   %eax
    27d4:	68 7a 54 00 00       	push   $0x547a
    27d9:	6a 01                	push   $0x1
    27db:	e8 20 23 00 00       	call   4b00 <printf>
    exit();
    27e0:	e8 9e 21 00 00       	call   4983 <exit>
    printf(1, "read lf2 failed\n");
    27e5:	51                   	push   %ecx
    27e6:	51                   	push   %ecx
    27e7:	68 69 54 00 00       	push   $0x5469
    27ec:	6a 01                	push   $0x1
    27ee:	e8 0d 23 00 00       	call   4b00 <printf>
    exit();
    27f3:	e8 8b 21 00 00       	call   4983 <exit>
    printf(1, "open lf2 failed\n");
    27f8:	53                   	push   %ebx
    27f9:	53                   	push   %ebx
    27fa:	68 58 54 00 00       	push   $0x5458
    27ff:	6a 01                	push   $0x1
    2801:	e8 fa 22 00 00       	call   4b00 <printf>
    exit();
    2806:	e8 78 21 00 00       	call   4983 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    280b:	50                   	push   %eax
    280c:	50                   	push   %eax
    280d:	68 24 60 00 00       	push   $0x6024
    2812:	6a 01                	push   $0x1
    2814:	e8 e7 22 00 00       	call   4b00 <printf>
    exit();
    2819:	e8 65 21 00 00       	call   4983 <exit>
    printf(1, "link lf1 lf2 failed\n");
    281e:	51                   	push   %ecx
    281f:	51                   	push   %ecx
    2820:	68 43 54 00 00       	push   $0x5443
    2825:	6a 01                	push   $0x1
    2827:	e8 d4 22 00 00       	call   4b00 <printf>
    exit();
    282c:	e8 52 21 00 00       	call   4983 <exit>
    printf(1, "write lf1 failed\n");
    2831:	50                   	push   %eax
    2832:	50                   	push   %eax
    2833:	68 31 54 00 00       	push   $0x5431
    2838:	6a 01                	push   $0x1
    283a:	e8 c1 22 00 00       	call   4b00 <printf>
    exit();
    283f:	e8 3f 21 00 00       	call   4983 <exit>
    2844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    284b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    284f:	90                   	nop

00002850 <concreate>:
{
    2850:	f3 0f 1e fb          	endbr32 
    2854:	55                   	push   %ebp
    2855:	89 e5                	mov    %esp,%ebp
    2857:	57                   	push   %edi
    2858:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    2859:	31 f6                	xor    %esi,%esi
{
    285b:	53                   	push   %ebx
    285c:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    285f:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    2862:	68 c1 54 00 00       	push   $0x54c1
    2867:	6a 01                	push   $0x1
    2869:	e8 92 22 00 00       	call   4b00 <printf>
  file[0] = 'C';
    286e:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    2872:	83 c4 10             	add    $0x10,%esp
    2875:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    2879:	eb 48                	jmp    28c3 <concreate+0x73>
    287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    287f:	90                   	nop
    2880:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
    if(pid && (i % 3) == 1){
    2886:	3d ab aa aa aa       	cmp    $0xaaaaaaab,%eax
    288b:	0f 83 af 00 00 00    	jae    2940 <concreate+0xf0>
      fd = open(file, O_CREATE | O_RDWR);
    2891:	83 ec 08             	sub    $0x8,%esp
    2894:	68 02 02 00 00       	push   $0x202
    2899:	53                   	push   %ebx
    289a:	e8 24 21 00 00       	call   49c3 <open>
      if(fd < 0){
    289f:	83 c4 10             	add    $0x10,%esp
    28a2:	85 c0                	test   %eax,%eax
    28a4:	78 5f                	js     2905 <concreate+0xb5>
      close(fd);
    28a6:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    28a9:	83 c6 01             	add    $0x1,%esi
      close(fd);
    28ac:	50                   	push   %eax
    28ad:	e8 f9 20 00 00       	call   49ab <close>
    28b2:	83 c4 10             	add    $0x10,%esp
      wait();
    28b5:	e8 d1 20 00 00       	call   498b <wait>
  for(i = 0; i < 40; i++){
    28ba:	83 fe 28             	cmp    $0x28,%esi
    28bd:	0f 84 9f 00 00 00    	je     2962 <concreate+0x112>
    unlink(file);
    28c3:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    28c6:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    28c9:	53                   	push   %ebx
    file[1] = '0' + i;
    28ca:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    28cd:	e8 01 21 00 00       	call   49d3 <unlink>
    pid = fork();
    28d2:	e8 a4 20 00 00       	call   497b <fork>
    if(pid && (i % 3) == 1){
    28d7:	83 c4 10             	add    $0x10,%esp
    28da:	85 c0                	test   %eax,%eax
    28dc:	75 a2                	jne    2880 <concreate+0x30>
      link("C0", file);
    28de:	69 f6 cd cc cc cc    	imul   $0xcccccccd,%esi,%esi
    } else if(pid == 0 && (i % 5) == 1){
    28e4:	81 fe cd cc cc cc    	cmp    $0xcccccccd,%esi
    28ea:	73 34                	jae    2920 <concreate+0xd0>
      fd = open(file, O_CREATE | O_RDWR);
    28ec:	83 ec 08             	sub    $0x8,%esp
    28ef:	68 02 02 00 00       	push   $0x202
    28f4:	53                   	push   %ebx
    28f5:	e8 c9 20 00 00       	call   49c3 <open>
      if(fd < 0){
    28fa:	83 c4 10             	add    $0x10,%esp
    28fd:	85 c0                	test   %eax,%eax
    28ff:	0f 89 39 02 00 00    	jns    2b3e <concreate+0x2ee>
        printf(1, "concreate create %s failed\n", file);
    2905:	83 ec 04             	sub    $0x4,%esp
    2908:	53                   	push   %ebx
    2909:	68 d4 54 00 00       	push   $0x54d4
    290e:	6a 01                	push   $0x1
    2910:	e8 eb 21 00 00       	call   4b00 <printf>
        exit();
    2915:	e8 69 20 00 00       	call   4983 <exit>
    291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("C0", file);
    2920:	83 ec 08             	sub    $0x8,%esp
    2923:	53                   	push   %ebx
    2924:	68 d1 54 00 00       	push   $0x54d1
    2929:	e8 b5 20 00 00       	call   49e3 <link>
    292e:	83 c4 10             	add    $0x10,%esp
      exit();
    2931:	e8 4d 20 00 00       	call   4983 <exit>
    2936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    293d:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    2940:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    2943:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    2946:	53                   	push   %ebx
    2947:	68 d1 54 00 00       	push   $0x54d1
    294c:	e8 92 20 00 00       	call   49e3 <link>
    2951:	83 c4 10             	add    $0x10,%esp
      wait();
    2954:	e8 32 20 00 00       	call   498b <wait>
  for(i = 0; i < 40; i++){
    2959:	83 fe 28             	cmp    $0x28,%esi
    295c:	0f 85 61 ff ff ff    	jne    28c3 <concreate+0x73>
  memset(fa, 0, sizeof(fa));
    2962:	83 ec 04             	sub    $0x4,%esp
    2965:	8d 45 c0             	lea    -0x40(%ebp),%eax
    2968:	6a 28                	push   $0x28
    296a:	6a 00                	push   $0x0
    296c:	50                   	push   %eax
    296d:	e8 6e 1e 00 00       	call   47e0 <memset>
  fd = open(".", 0);
    2972:	5e                   	pop    %esi
    2973:	5f                   	pop    %edi
    2974:	6a 00                	push   $0x0
    2976:	68 de 56 00 00       	push   $0x56de
    297b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    297e:	e8 40 20 00 00       	call   49c3 <open>
  n = 0;
    2983:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    298a:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    298d:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    298f:	90                   	nop
    2990:	83 ec 04             	sub    $0x4,%esp
    2993:	6a 10                	push   $0x10
    2995:	57                   	push   %edi
    2996:	56                   	push   %esi
    2997:	e8 ff 1f 00 00       	call   499b <read>
    299c:	83 c4 10             	add    $0x10,%esp
    299f:	85 c0                	test   %eax,%eax
    29a1:	7e 3d                	jle    29e0 <concreate+0x190>
    if(de.inum == 0)
    29a3:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    29a8:	74 e6                	je     2990 <concreate+0x140>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    29aa:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    29ae:	75 e0                	jne    2990 <concreate+0x140>
    29b0:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    29b4:	75 da                	jne    2990 <concreate+0x140>
      i = de.name[1] - '0';
    29b6:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    29ba:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    29bd:	83 f8 27             	cmp    $0x27,%eax
    29c0:	0f 87 60 01 00 00    	ja     2b26 <concreate+0x2d6>
      if(fa[i]){
    29c6:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    29cb:	0f 85 3d 01 00 00    	jne    2b0e <concreate+0x2be>
      n++;
    29d1:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
      fa[i] = 1;
    29d5:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    29da:	eb b4                	jmp    2990 <concreate+0x140>
    29dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    29e0:	83 ec 0c             	sub    $0xc,%esp
    29e3:	56                   	push   %esi
    29e4:	e8 c2 1f 00 00       	call   49ab <close>
  if(n != 40){
    29e9:	83 c4 10             	add    $0x10,%esp
    29ec:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    29f0:	0f 85 05 01 00 00    	jne    2afb <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    29f6:	31 f6                	xor    %esi,%esi
    29f8:	eb 4c                	jmp    2a46 <concreate+0x1f6>
    29fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    2a00:	85 ff                	test   %edi,%edi
    2a02:	74 05                	je     2a09 <concreate+0x1b9>
    2a04:	83 f8 01             	cmp    $0x1,%eax
    2a07:	74 6c                	je     2a75 <concreate+0x225>
      unlink(file);
    2a09:	83 ec 0c             	sub    $0xc,%esp
    2a0c:	53                   	push   %ebx
    2a0d:	e8 c1 1f 00 00       	call   49d3 <unlink>
      unlink(file);
    2a12:	89 1c 24             	mov    %ebx,(%esp)
    2a15:	e8 b9 1f 00 00       	call   49d3 <unlink>
      unlink(file);
    2a1a:	89 1c 24             	mov    %ebx,(%esp)
    2a1d:	e8 b1 1f 00 00       	call   49d3 <unlink>
      unlink(file);
    2a22:	89 1c 24             	mov    %ebx,(%esp)
    2a25:	e8 a9 1f 00 00       	call   49d3 <unlink>
    2a2a:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    2a2d:	85 ff                	test   %edi,%edi
    2a2f:	0f 84 fc fe ff ff    	je     2931 <concreate+0xe1>
      wait();
    2a35:	e8 51 1f 00 00       	call   498b <wait>
  for(i = 0; i < 40; i++){
    2a3a:	83 c6 01             	add    $0x1,%esi
    2a3d:	83 fe 28             	cmp    $0x28,%esi
    2a40:	0f 84 8a 00 00 00    	je     2ad0 <concreate+0x280>
    file[1] = '0' + i;
    2a46:	8d 46 30             	lea    0x30(%esi),%eax
    2a49:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    2a4c:	e8 2a 1f 00 00       	call   497b <fork>
    2a51:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    2a53:	85 c0                	test   %eax,%eax
    2a55:	0f 88 8c 00 00 00    	js     2ae7 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    2a5b:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    2a60:	f7 e6                	mul    %esi
    2a62:	89 d0                	mov    %edx,%eax
    2a64:	83 e2 fe             	and    $0xfffffffe,%edx
    2a67:	d1 e8                	shr    %eax
    2a69:	01 c2                	add    %eax,%edx
    2a6b:	89 f0                	mov    %esi,%eax
    2a6d:	29 d0                	sub    %edx,%eax
    2a6f:	89 c1                	mov    %eax,%ecx
    2a71:	09 f9                	or     %edi,%ecx
    2a73:	75 8b                	jne    2a00 <concreate+0x1b0>
      close(open(file, 0));
    2a75:	83 ec 08             	sub    $0x8,%esp
    2a78:	6a 00                	push   $0x0
    2a7a:	53                   	push   %ebx
    2a7b:	e8 43 1f 00 00       	call   49c3 <open>
    2a80:	89 04 24             	mov    %eax,(%esp)
    2a83:	e8 23 1f 00 00       	call   49ab <close>
      close(open(file, 0));
    2a88:	58                   	pop    %eax
    2a89:	5a                   	pop    %edx
    2a8a:	6a 00                	push   $0x0
    2a8c:	53                   	push   %ebx
    2a8d:	e8 31 1f 00 00       	call   49c3 <open>
    2a92:	89 04 24             	mov    %eax,(%esp)
    2a95:	e8 11 1f 00 00       	call   49ab <close>
      close(open(file, 0));
    2a9a:	59                   	pop    %ecx
    2a9b:	58                   	pop    %eax
    2a9c:	6a 00                	push   $0x0
    2a9e:	53                   	push   %ebx
    2a9f:	e8 1f 1f 00 00       	call   49c3 <open>
    2aa4:	89 04 24             	mov    %eax,(%esp)
    2aa7:	e8 ff 1e 00 00       	call   49ab <close>
      close(open(file, 0));
    2aac:	58                   	pop    %eax
    2aad:	5a                   	pop    %edx
    2aae:	6a 00                	push   $0x0
    2ab0:	53                   	push   %ebx
    2ab1:	e8 0d 1f 00 00       	call   49c3 <open>
    2ab6:	89 04 24             	mov    %eax,(%esp)
    2ab9:	e8 ed 1e 00 00       	call   49ab <close>
    2abe:	83 c4 10             	add    $0x10,%esp
    2ac1:	e9 67 ff ff ff       	jmp    2a2d <concreate+0x1dd>
    2ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2acd:	8d 76 00             	lea    0x0(%esi),%esi
  printf(1, "concreate ok\n");
    2ad0:	83 ec 08             	sub    $0x8,%esp
    2ad3:	68 26 55 00 00       	push   $0x5526
    2ad8:	6a 01                	push   $0x1
    2ada:	e8 21 20 00 00       	call   4b00 <printf>
}
    2adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2ae2:	5b                   	pop    %ebx
    2ae3:	5e                   	pop    %esi
    2ae4:	5f                   	pop    %edi
    2ae5:	5d                   	pop    %ebp
    2ae6:	c3                   	ret    
      printf(1, "fork failed\n");
    2ae7:	83 ec 08             	sub    $0x8,%esp
    2aea:	68 a9 5d 00 00       	push   $0x5da9
    2aef:	6a 01                	push   $0x1
    2af1:	e8 0a 20 00 00       	call   4b00 <printf>
      exit();
    2af6:	e8 88 1e 00 00       	call   4983 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    2afb:	51                   	push   %ecx
    2afc:	51                   	push   %ecx
    2afd:	68 70 60 00 00       	push   $0x6070
    2b02:	6a 01                	push   $0x1
    2b04:	e8 f7 1f 00 00       	call   4b00 <printf>
    exit();
    2b09:	e8 75 1e 00 00       	call   4983 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    2b0e:	83 ec 04             	sub    $0x4,%esp
    2b11:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    2b14:	50                   	push   %eax
    2b15:	68 09 55 00 00       	push   $0x5509
    2b1a:	6a 01                	push   $0x1
    2b1c:	e8 df 1f 00 00       	call   4b00 <printf>
        exit();
    2b21:	e8 5d 1e 00 00       	call   4983 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    2b26:	83 ec 04             	sub    $0x4,%esp
    2b29:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    2b2c:	50                   	push   %eax
    2b2d:	68 f0 54 00 00       	push   $0x54f0
    2b32:	6a 01                	push   $0x1
    2b34:	e8 c7 1f 00 00       	call   4b00 <printf>
        exit();
    2b39:	e8 45 1e 00 00       	call   4983 <exit>
      close(fd);
    2b3e:	83 ec 0c             	sub    $0xc,%esp
    2b41:	50                   	push   %eax
    2b42:	e8 64 1e 00 00       	call   49ab <close>
    2b47:	83 c4 10             	add    $0x10,%esp
    2b4a:	e9 e2 fd ff ff       	jmp    2931 <concreate+0xe1>
    2b4f:	90                   	nop

00002b50 <linkunlink>:
{
    2b50:	f3 0f 1e fb          	endbr32 
    2b54:	55                   	push   %ebp
    2b55:	89 e5                	mov    %esp,%ebp
    2b57:	57                   	push   %edi
    2b58:	56                   	push   %esi
    2b59:	53                   	push   %ebx
    2b5a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    2b5d:	68 34 55 00 00       	push   $0x5534
    2b62:	6a 01                	push   $0x1
    2b64:	e8 97 1f 00 00       	call   4b00 <printf>
  unlink("x");
    2b69:	c7 04 24 c1 57 00 00 	movl   $0x57c1,(%esp)
    2b70:	e8 5e 1e 00 00       	call   49d3 <unlink>
  pid = fork();
    2b75:	e8 01 1e 00 00       	call   497b <fork>
  if(pid < 0){
    2b7a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    2b7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    2b80:	85 c0                	test   %eax,%eax
    2b82:	0f 88 b2 00 00 00    	js     2c3a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    2b88:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    2b8c:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    2b91:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    2b96:	19 ff                	sbb    %edi,%edi
    2b98:	83 e7 60             	and    $0x60,%edi
    2b9b:	83 c7 01             	add    $0x1,%edi
    2b9e:	eb 1a                	jmp    2bba <linkunlink+0x6a>
    } else if((x % 3) == 1){
    2ba0:	83 f8 01             	cmp    $0x1,%eax
    2ba3:	74 7b                	je     2c20 <linkunlink+0xd0>
      unlink("x");
    2ba5:	83 ec 0c             	sub    $0xc,%esp
    2ba8:	68 c1 57 00 00       	push   $0x57c1
    2bad:	e8 21 1e 00 00       	call   49d3 <unlink>
    2bb2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    2bb5:	83 eb 01             	sub    $0x1,%ebx
    2bb8:	74 41                	je     2bfb <linkunlink+0xab>
    x = x * 1103515245 + 12345;
    2bba:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    2bc0:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    2bc6:	89 f8                	mov    %edi,%eax
    2bc8:	f7 e6                	mul    %esi
    2bca:	89 d0                	mov    %edx,%eax
    2bcc:	83 e2 fe             	and    $0xfffffffe,%edx
    2bcf:	d1 e8                	shr    %eax
    2bd1:	01 c2                	add    %eax,%edx
    2bd3:	89 f8                	mov    %edi,%eax
    2bd5:	29 d0                	sub    %edx,%eax
    2bd7:	75 c7                	jne    2ba0 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    2bd9:	83 ec 08             	sub    $0x8,%esp
    2bdc:	68 02 02 00 00       	push   $0x202
    2be1:	68 c1 57 00 00       	push   $0x57c1
    2be6:	e8 d8 1d 00 00       	call   49c3 <open>
    2beb:	89 04 24             	mov    %eax,(%esp)
    2bee:	e8 b8 1d 00 00       	call   49ab <close>
    2bf3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    2bf6:	83 eb 01             	sub    $0x1,%ebx
    2bf9:	75 bf                	jne    2bba <linkunlink+0x6a>
  if(pid)
    2bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2bfe:	85 c0                	test   %eax,%eax
    2c00:	74 4b                	je     2c4d <linkunlink+0xfd>
    wait();
    2c02:	e8 84 1d 00 00       	call   498b <wait>
  printf(1, "linkunlink ok\n");
    2c07:	83 ec 08             	sub    $0x8,%esp
    2c0a:	68 49 55 00 00       	push   $0x5549
    2c0f:	6a 01                	push   $0x1
    2c11:	e8 ea 1e 00 00       	call   4b00 <printf>
}
    2c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2c19:	5b                   	pop    %ebx
    2c1a:	5e                   	pop    %esi
    2c1b:	5f                   	pop    %edi
    2c1c:	5d                   	pop    %ebp
    2c1d:	c3                   	ret    
    2c1e:	66 90                	xchg   %ax,%ax
      link("cat", "x");
    2c20:	83 ec 08             	sub    $0x8,%esp
    2c23:	68 c1 57 00 00       	push   $0x57c1
    2c28:	68 45 55 00 00       	push   $0x5545
    2c2d:	e8 b1 1d 00 00       	call   49e3 <link>
    2c32:	83 c4 10             	add    $0x10,%esp
    2c35:	e9 7b ff ff ff       	jmp    2bb5 <linkunlink+0x65>
    printf(1, "fork failed\n");
    2c3a:	52                   	push   %edx
    2c3b:	52                   	push   %edx
    2c3c:	68 a9 5d 00 00       	push   $0x5da9
    2c41:	6a 01                	push   $0x1
    2c43:	e8 b8 1e 00 00       	call   4b00 <printf>
    exit();
    2c48:	e8 36 1d 00 00       	call   4983 <exit>
    exit();
    2c4d:	e8 31 1d 00 00       	call   4983 <exit>
    2c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002c60 <bigdir>:
{
    2c60:	f3 0f 1e fb          	endbr32 
    2c64:	55                   	push   %ebp
    2c65:	89 e5                	mov    %esp,%ebp
    2c67:	57                   	push   %edi
    2c68:	56                   	push   %esi
    2c69:	53                   	push   %ebx
    2c6a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    2c6d:	68 58 55 00 00       	push   $0x5558
    2c72:	6a 01                	push   $0x1
    2c74:	e8 87 1e 00 00       	call   4b00 <printf>
  unlink("bd");
    2c79:	c7 04 24 65 55 00 00 	movl   $0x5565,(%esp)
    2c80:	e8 4e 1d 00 00       	call   49d3 <unlink>
  fd = open("bd", O_CREATE);
    2c85:	5a                   	pop    %edx
    2c86:	59                   	pop    %ecx
    2c87:	68 00 02 00 00       	push   $0x200
    2c8c:	68 65 55 00 00       	push   $0x5565
    2c91:	e8 2d 1d 00 00       	call   49c3 <open>
  if(fd < 0){
    2c96:	83 c4 10             	add    $0x10,%esp
    2c99:	85 c0                	test   %eax,%eax
    2c9b:	0f 88 ea 00 00 00    	js     2d8b <bigdir+0x12b>
  close(fd);
    2ca1:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    2ca4:	31 f6                	xor    %esi,%esi
    2ca6:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    2ca9:	50                   	push   %eax
    2caa:	e8 fc 1c 00 00       	call   49ab <close>
    2caf:	83 c4 10             	add    $0x10,%esp
    2cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + (i / 64);
    2cb8:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    2cba:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    2cbd:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    2cc1:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    2cc4:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    2cc5:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    2cc8:	68 65 55 00 00       	push   $0x5565
    name[1] = '0' + (i / 64);
    2ccd:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    2cd0:	89 f0                	mov    %esi,%eax
    2cd2:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    2cd5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    2cd9:	83 c0 30             	add    $0x30,%eax
    2cdc:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    2cdf:	e8 ff 1c 00 00       	call   49e3 <link>
    2ce4:	83 c4 10             	add    $0x10,%esp
    2ce7:	89 c3                	mov    %eax,%ebx
    2ce9:	85 c0                	test   %eax,%eax
    2ceb:	75 76                	jne    2d63 <bigdir+0x103>
  for(i = 0; i < 500; i++){
    2ced:	83 c6 01             	add    $0x1,%esi
    2cf0:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    2cf6:	75 c0                	jne    2cb8 <bigdir+0x58>
  unlink("bd");
    2cf8:	83 ec 0c             	sub    $0xc,%esp
    2cfb:	68 65 55 00 00       	push   $0x5565
    2d00:	e8 ce 1c 00 00       	call   49d3 <unlink>
    2d05:	83 c4 10             	add    $0x10,%esp
    2d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2d0f:	90                   	nop
    name[1] = '0' + (i / 64);
    2d10:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    2d12:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    2d15:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    2d19:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    2d1c:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    2d1d:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    2d20:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    2d24:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    2d27:	89 d8                	mov    %ebx,%eax
    2d29:	83 e0 3f             	and    $0x3f,%eax
    2d2c:	83 c0 30             	add    $0x30,%eax
    2d2f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    2d32:	e8 9c 1c 00 00       	call   49d3 <unlink>
    2d37:	83 c4 10             	add    $0x10,%esp
    2d3a:	85 c0                	test   %eax,%eax
    2d3c:	75 39                	jne    2d77 <bigdir+0x117>
  for(i = 0; i < 500; i++){
    2d3e:	83 c3 01             	add    $0x1,%ebx
    2d41:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    2d47:	75 c7                	jne    2d10 <bigdir+0xb0>
  printf(1, "bigdir ok\n");
    2d49:	83 ec 08             	sub    $0x8,%esp
    2d4c:	68 a7 55 00 00       	push   $0x55a7
    2d51:	6a 01                	push   $0x1
    2d53:	e8 a8 1d 00 00       	call   4b00 <printf>
    2d58:	83 c4 10             	add    $0x10,%esp
}
    2d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2d5e:	5b                   	pop    %ebx
    2d5f:	5e                   	pop    %esi
    2d60:	5f                   	pop    %edi
    2d61:	5d                   	pop    %ebp
    2d62:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    2d63:	83 ec 08             	sub    $0x8,%esp
    2d66:	68 7e 55 00 00       	push   $0x557e
    2d6b:	6a 01                	push   $0x1
    2d6d:	e8 8e 1d 00 00       	call   4b00 <printf>
      exit();
    2d72:	e8 0c 1c 00 00       	call   4983 <exit>
      printf(1, "bigdir unlink failed");
    2d77:	83 ec 08             	sub    $0x8,%esp
    2d7a:	68 92 55 00 00       	push   $0x5592
    2d7f:	6a 01                	push   $0x1
    2d81:	e8 7a 1d 00 00       	call   4b00 <printf>
      exit();
    2d86:	e8 f8 1b 00 00       	call   4983 <exit>
    printf(1, "bigdir create failed\n");
    2d8b:	50                   	push   %eax
    2d8c:	50                   	push   %eax
    2d8d:	68 68 55 00 00       	push   $0x5568
    2d92:	6a 01                	push   $0x1
    2d94:	e8 67 1d 00 00       	call   4b00 <printf>
    exit();
    2d99:	e8 e5 1b 00 00       	call   4983 <exit>
    2d9e:	66 90                	xchg   %ax,%ax

00002da0 <subdir>:
{
    2da0:	f3 0f 1e fb          	endbr32 
    2da4:	55                   	push   %ebp
    2da5:	89 e5                	mov    %esp,%ebp
    2da7:	53                   	push   %ebx
    2da8:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    2dab:	68 b2 55 00 00       	push   $0x55b2
    2db0:	6a 01                	push   $0x1
    2db2:	e8 49 1d 00 00       	call   4b00 <printf>
  unlink("ff");
    2db7:	c7 04 24 3b 56 00 00 	movl   $0x563b,(%esp)
    2dbe:	e8 10 1c 00 00       	call   49d3 <unlink>
  if(mkdir("dd") != 0){
    2dc3:	c7 04 24 d8 56 00 00 	movl   $0x56d8,(%esp)
    2dca:	e8 1c 1c 00 00       	call   49eb <mkdir>
    2dcf:	83 c4 10             	add    $0x10,%esp
    2dd2:	85 c0                	test   %eax,%eax
    2dd4:	0f 85 b3 05 00 00    	jne    338d <subdir+0x5ed>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2dda:	83 ec 08             	sub    $0x8,%esp
    2ddd:	68 02 02 00 00       	push   $0x202
    2de2:	68 11 56 00 00       	push   $0x5611
    2de7:	e8 d7 1b 00 00       	call   49c3 <open>
  if(fd < 0){
    2dec:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2def:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2df1:	85 c0                	test   %eax,%eax
    2df3:	0f 88 81 05 00 00    	js     337a <subdir+0x5da>
  write(fd, "ff", 2);
    2df9:	83 ec 04             	sub    $0x4,%esp
    2dfc:	6a 02                	push   $0x2
    2dfe:	68 3b 56 00 00       	push   $0x563b
    2e03:	50                   	push   %eax
    2e04:	e8 9a 1b 00 00       	call   49a3 <write>
  close(fd);
    2e09:	89 1c 24             	mov    %ebx,(%esp)
    2e0c:	e8 9a 1b 00 00       	call   49ab <close>
  if(unlink("dd") >= 0){
    2e11:	c7 04 24 d8 56 00 00 	movl   $0x56d8,(%esp)
    2e18:	e8 b6 1b 00 00       	call   49d3 <unlink>
    2e1d:	83 c4 10             	add    $0x10,%esp
    2e20:	85 c0                	test   %eax,%eax
    2e22:	0f 89 3f 05 00 00    	jns    3367 <subdir+0x5c7>
  if(mkdir("/dd/dd") != 0){
    2e28:	83 ec 0c             	sub    $0xc,%esp
    2e2b:	68 ec 55 00 00       	push   $0x55ec
    2e30:	e8 b6 1b 00 00       	call   49eb <mkdir>
    2e35:	83 c4 10             	add    $0x10,%esp
    2e38:	85 c0                	test   %eax,%eax
    2e3a:	0f 85 14 05 00 00    	jne    3354 <subdir+0x5b4>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2e40:	83 ec 08             	sub    $0x8,%esp
    2e43:	68 02 02 00 00       	push   $0x202
    2e48:	68 0e 56 00 00       	push   $0x560e
    2e4d:	e8 71 1b 00 00       	call   49c3 <open>
  if(fd < 0){
    2e52:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2e55:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2e57:	85 c0                	test   %eax,%eax
    2e59:	0f 88 24 04 00 00    	js     3283 <subdir+0x4e3>
  write(fd, "FF", 2);
    2e5f:	83 ec 04             	sub    $0x4,%esp
    2e62:	6a 02                	push   $0x2
    2e64:	68 2f 56 00 00       	push   $0x562f
    2e69:	50                   	push   %eax
    2e6a:	e8 34 1b 00 00       	call   49a3 <write>
  close(fd);
    2e6f:	89 1c 24             	mov    %ebx,(%esp)
    2e72:	e8 34 1b 00 00       	call   49ab <close>
  fd = open("dd/dd/../ff", 0);
    2e77:	58                   	pop    %eax
    2e78:	5a                   	pop    %edx
    2e79:	6a 00                	push   $0x0
    2e7b:	68 32 56 00 00       	push   $0x5632
    2e80:	e8 3e 1b 00 00       	call   49c3 <open>
  if(fd < 0){
    2e85:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    2e88:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2e8a:	85 c0                	test   %eax,%eax
    2e8c:	0f 88 de 03 00 00    	js     3270 <subdir+0x4d0>
  cc = read(fd, buf, sizeof(buf));
    2e92:	83 ec 04             	sub    $0x4,%esp
    2e95:	68 00 20 00 00       	push   $0x2000
    2e9a:	68 e0 96 00 00       	push   $0x96e0
    2e9f:	50                   	push   %eax
    2ea0:	e8 f6 1a 00 00       	call   499b <read>
  if(cc != 2 || buf[0] != 'f'){
    2ea5:	83 c4 10             	add    $0x10,%esp
    2ea8:	83 f8 02             	cmp    $0x2,%eax
    2eab:	0f 85 3a 03 00 00    	jne    31eb <subdir+0x44b>
    2eb1:	80 3d e0 96 00 00 66 	cmpb   $0x66,0x96e0
    2eb8:	0f 85 2d 03 00 00    	jne    31eb <subdir+0x44b>
  close(fd);
    2ebe:	83 ec 0c             	sub    $0xc,%esp
    2ec1:	53                   	push   %ebx
    2ec2:	e8 e4 1a 00 00       	call   49ab <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ec7:	59                   	pop    %ecx
    2ec8:	5b                   	pop    %ebx
    2ec9:	68 72 56 00 00       	push   $0x5672
    2ece:	68 0e 56 00 00       	push   $0x560e
    2ed3:	e8 0b 1b 00 00       	call   49e3 <link>
    2ed8:	83 c4 10             	add    $0x10,%esp
    2edb:	85 c0                	test   %eax,%eax
    2edd:	0f 85 c6 03 00 00    	jne    32a9 <subdir+0x509>
  if(unlink("dd/dd/ff") != 0){
    2ee3:	83 ec 0c             	sub    $0xc,%esp
    2ee6:	68 0e 56 00 00       	push   $0x560e
    2eeb:	e8 e3 1a 00 00       	call   49d3 <unlink>
    2ef0:	83 c4 10             	add    $0x10,%esp
    2ef3:	85 c0                	test   %eax,%eax
    2ef5:	0f 85 16 03 00 00    	jne    3211 <subdir+0x471>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2efb:	83 ec 08             	sub    $0x8,%esp
    2efe:	6a 00                	push   $0x0
    2f00:	68 0e 56 00 00       	push   $0x560e
    2f05:	e8 b9 1a 00 00       	call   49c3 <open>
    2f0a:	83 c4 10             	add    $0x10,%esp
    2f0d:	85 c0                	test   %eax,%eax
    2f0f:	0f 89 2c 04 00 00    	jns    3341 <subdir+0x5a1>
  if(chdir("dd") != 0){
    2f15:	83 ec 0c             	sub    $0xc,%esp
    2f18:	68 d8 56 00 00       	push   $0x56d8
    2f1d:	e8 d1 1a 00 00       	call   49f3 <chdir>
    2f22:	83 c4 10             	add    $0x10,%esp
    2f25:	85 c0                	test   %eax,%eax
    2f27:	0f 85 01 04 00 00    	jne    332e <subdir+0x58e>
  if(chdir("dd/../../dd") != 0){
    2f2d:	83 ec 0c             	sub    $0xc,%esp
    2f30:	68 a6 56 00 00       	push   $0x56a6
    2f35:	e8 b9 1a 00 00       	call   49f3 <chdir>
    2f3a:	83 c4 10             	add    $0x10,%esp
    2f3d:	85 c0                	test   %eax,%eax
    2f3f:	0f 85 b9 02 00 00    	jne    31fe <subdir+0x45e>
  if(chdir("dd/../../../dd") != 0){
    2f45:	83 ec 0c             	sub    $0xc,%esp
    2f48:	68 cc 56 00 00       	push   $0x56cc
    2f4d:	e8 a1 1a 00 00       	call   49f3 <chdir>
    2f52:	83 c4 10             	add    $0x10,%esp
    2f55:	85 c0                	test   %eax,%eax
    2f57:	0f 85 a1 02 00 00    	jne    31fe <subdir+0x45e>
  if(chdir("./..") != 0){
    2f5d:	83 ec 0c             	sub    $0xc,%esp
    2f60:	68 db 56 00 00       	push   $0x56db
    2f65:	e8 89 1a 00 00       	call   49f3 <chdir>
    2f6a:	83 c4 10             	add    $0x10,%esp
    2f6d:	85 c0                	test   %eax,%eax
    2f6f:	0f 85 21 03 00 00    	jne    3296 <subdir+0x4f6>
  fd = open("dd/dd/ffff", 0);
    2f75:	83 ec 08             	sub    $0x8,%esp
    2f78:	6a 00                	push   $0x0
    2f7a:	68 72 56 00 00       	push   $0x5672
    2f7f:	e8 3f 1a 00 00       	call   49c3 <open>
  if(fd < 0){
    2f84:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    2f87:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2f89:	85 c0                	test   %eax,%eax
    2f8b:	0f 88 e0 04 00 00    	js     3471 <subdir+0x6d1>
  if(read(fd, buf, sizeof(buf)) != 2){
    2f91:	83 ec 04             	sub    $0x4,%esp
    2f94:	68 00 20 00 00       	push   $0x2000
    2f99:	68 e0 96 00 00       	push   $0x96e0
    2f9e:	50                   	push   %eax
    2f9f:	e8 f7 19 00 00       	call   499b <read>
    2fa4:	83 c4 10             	add    $0x10,%esp
    2fa7:	83 f8 02             	cmp    $0x2,%eax
    2faa:	0f 85 ae 04 00 00    	jne    345e <subdir+0x6be>
  close(fd);
    2fb0:	83 ec 0c             	sub    $0xc,%esp
    2fb3:	53                   	push   %ebx
    2fb4:	e8 f2 19 00 00       	call   49ab <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2fb9:	58                   	pop    %eax
    2fba:	5a                   	pop    %edx
    2fbb:	6a 00                	push   $0x0
    2fbd:	68 0e 56 00 00       	push   $0x560e
    2fc2:	e8 fc 19 00 00       	call   49c3 <open>
    2fc7:	83 c4 10             	add    $0x10,%esp
    2fca:	85 c0                	test   %eax,%eax
    2fcc:	0f 89 65 02 00 00    	jns    3237 <subdir+0x497>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2fd2:	83 ec 08             	sub    $0x8,%esp
    2fd5:	68 02 02 00 00       	push   $0x202
    2fda:	68 26 57 00 00       	push   $0x5726
    2fdf:	e8 df 19 00 00       	call   49c3 <open>
    2fe4:	83 c4 10             	add    $0x10,%esp
    2fe7:	85 c0                	test   %eax,%eax
    2fe9:	0f 89 35 02 00 00    	jns    3224 <subdir+0x484>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2fef:	83 ec 08             	sub    $0x8,%esp
    2ff2:	68 02 02 00 00       	push   $0x202
    2ff7:	68 4b 57 00 00       	push   $0x574b
    2ffc:	e8 c2 19 00 00       	call   49c3 <open>
    3001:	83 c4 10             	add    $0x10,%esp
    3004:	85 c0                	test   %eax,%eax
    3006:	0f 89 0f 03 00 00    	jns    331b <subdir+0x57b>
  if(open("dd", O_CREATE) >= 0){
    300c:	83 ec 08             	sub    $0x8,%esp
    300f:	68 00 02 00 00       	push   $0x200
    3014:	68 d8 56 00 00       	push   $0x56d8
    3019:	e8 a5 19 00 00       	call   49c3 <open>
    301e:	83 c4 10             	add    $0x10,%esp
    3021:	85 c0                	test   %eax,%eax
    3023:	0f 89 df 02 00 00    	jns    3308 <subdir+0x568>
  if(open("dd", O_RDWR) >= 0){
    3029:	83 ec 08             	sub    $0x8,%esp
    302c:	6a 02                	push   $0x2
    302e:	68 d8 56 00 00       	push   $0x56d8
    3033:	e8 8b 19 00 00       	call   49c3 <open>
    3038:	83 c4 10             	add    $0x10,%esp
    303b:	85 c0                	test   %eax,%eax
    303d:	0f 89 b2 02 00 00    	jns    32f5 <subdir+0x555>
  if(open("dd", O_WRONLY) >= 0){
    3043:	83 ec 08             	sub    $0x8,%esp
    3046:	6a 01                	push   $0x1
    3048:	68 d8 56 00 00       	push   $0x56d8
    304d:	e8 71 19 00 00       	call   49c3 <open>
    3052:	83 c4 10             	add    $0x10,%esp
    3055:	85 c0                	test   %eax,%eax
    3057:	0f 89 85 02 00 00    	jns    32e2 <subdir+0x542>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    305d:	83 ec 08             	sub    $0x8,%esp
    3060:	68 ba 57 00 00       	push   $0x57ba
    3065:	68 26 57 00 00       	push   $0x5726
    306a:	e8 74 19 00 00       	call   49e3 <link>
    306f:	83 c4 10             	add    $0x10,%esp
    3072:	85 c0                	test   %eax,%eax
    3074:	0f 84 55 02 00 00    	je     32cf <subdir+0x52f>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    307a:	83 ec 08             	sub    $0x8,%esp
    307d:	68 ba 57 00 00       	push   $0x57ba
    3082:	68 4b 57 00 00       	push   $0x574b
    3087:	e8 57 19 00 00       	call   49e3 <link>
    308c:	83 c4 10             	add    $0x10,%esp
    308f:	85 c0                	test   %eax,%eax
    3091:	0f 84 25 02 00 00    	je     32bc <subdir+0x51c>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3097:	83 ec 08             	sub    $0x8,%esp
    309a:	68 72 56 00 00       	push   $0x5672
    309f:	68 11 56 00 00       	push   $0x5611
    30a4:	e8 3a 19 00 00       	call   49e3 <link>
    30a9:	83 c4 10             	add    $0x10,%esp
    30ac:	85 c0                	test   %eax,%eax
    30ae:	0f 84 a9 01 00 00    	je     325d <subdir+0x4bd>
  if(mkdir("dd/ff/ff") == 0){
    30b4:	83 ec 0c             	sub    $0xc,%esp
    30b7:	68 26 57 00 00       	push   $0x5726
    30bc:	e8 2a 19 00 00       	call   49eb <mkdir>
    30c1:	83 c4 10             	add    $0x10,%esp
    30c4:	85 c0                	test   %eax,%eax
    30c6:	0f 84 7e 01 00 00    	je     324a <subdir+0x4aa>
  if(mkdir("dd/xx/ff") == 0){
    30cc:	83 ec 0c             	sub    $0xc,%esp
    30cf:	68 4b 57 00 00       	push   $0x574b
    30d4:	e8 12 19 00 00       	call   49eb <mkdir>
    30d9:	83 c4 10             	add    $0x10,%esp
    30dc:	85 c0                	test   %eax,%eax
    30de:	0f 84 67 03 00 00    	je     344b <subdir+0x6ab>
  if(mkdir("dd/dd/ffff") == 0){
    30e4:	83 ec 0c             	sub    $0xc,%esp
    30e7:	68 72 56 00 00       	push   $0x5672
    30ec:	e8 fa 18 00 00       	call   49eb <mkdir>
    30f1:	83 c4 10             	add    $0x10,%esp
    30f4:	85 c0                	test   %eax,%eax
    30f6:	0f 84 3c 03 00 00    	je     3438 <subdir+0x698>
  if(unlink("dd/xx/ff") == 0){
    30fc:	83 ec 0c             	sub    $0xc,%esp
    30ff:	68 4b 57 00 00       	push   $0x574b
    3104:	e8 ca 18 00 00       	call   49d3 <unlink>
    3109:	83 c4 10             	add    $0x10,%esp
    310c:	85 c0                	test   %eax,%eax
    310e:	0f 84 11 03 00 00    	je     3425 <subdir+0x685>
  if(unlink("dd/ff/ff") == 0){
    3114:	83 ec 0c             	sub    $0xc,%esp
    3117:	68 26 57 00 00       	push   $0x5726
    311c:	e8 b2 18 00 00       	call   49d3 <unlink>
    3121:	83 c4 10             	add    $0x10,%esp
    3124:	85 c0                	test   %eax,%eax
    3126:	0f 84 e6 02 00 00    	je     3412 <subdir+0x672>
  if(chdir("dd/ff") == 0){
    312c:	83 ec 0c             	sub    $0xc,%esp
    312f:	68 11 56 00 00       	push   $0x5611
    3134:	e8 ba 18 00 00       	call   49f3 <chdir>
    3139:	83 c4 10             	add    $0x10,%esp
    313c:	85 c0                	test   %eax,%eax
    313e:	0f 84 bb 02 00 00    	je     33ff <subdir+0x65f>
  if(chdir("dd/xx") == 0){
    3144:	83 ec 0c             	sub    $0xc,%esp
    3147:	68 bd 57 00 00       	push   $0x57bd
    314c:	e8 a2 18 00 00       	call   49f3 <chdir>
    3151:	83 c4 10             	add    $0x10,%esp
    3154:	85 c0                	test   %eax,%eax
    3156:	0f 84 90 02 00 00    	je     33ec <subdir+0x64c>
  if(unlink("dd/dd/ffff") != 0){
    315c:	83 ec 0c             	sub    $0xc,%esp
    315f:	68 72 56 00 00       	push   $0x5672
    3164:	e8 6a 18 00 00       	call   49d3 <unlink>
    3169:	83 c4 10             	add    $0x10,%esp
    316c:	85 c0                	test   %eax,%eax
    316e:	0f 85 9d 00 00 00    	jne    3211 <subdir+0x471>
  if(unlink("dd/ff") != 0){
    3174:	83 ec 0c             	sub    $0xc,%esp
    3177:	68 11 56 00 00       	push   $0x5611
    317c:	e8 52 18 00 00       	call   49d3 <unlink>
    3181:	83 c4 10             	add    $0x10,%esp
    3184:	85 c0                	test   %eax,%eax
    3186:	0f 85 4d 02 00 00    	jne    33d9 <subdir+0x639>
  if(unlink("dd") == 0){
    318c:	83 ec 0c             	sub    $0xc,%esp
    318f:	68 d8 56 00 00       	push   $0x56d8
    3194:	e8 3a 18 00 00       	call   49d3 <unlink>
    3199:	83 c4 10             	add    $0x10,%esp
    319c:	85 c0                	test   %eax,%eax
    319e:	0f 84 22 02 00 00    	je     33c6 <subdir+0x626>
  if(unlink("dd/dd") < 0){
    31a4:	83 ec 0c             	sub    $0xc,%esp
    31a7:	68 ed 55 00 00       	push   $0x55ed
    31ac:	e8 22 18 00 00       	call   49d3 <unlink>
    31b1:	83 c4 10             	add    $0x10,%esp
    31b4:	85 c0                	test   %eax,%eax
    31b6:	0f 88 f7 01 00 00    	js     33b3 <subdir+0x613>
  if(unlink("dd") < 0){
    31bc:	83 ec 0c             	sub    $0xc,%esp
    31bf:	68 d8 56 00 00       	push   $0x56d8
    31c4:	e8 0a 18 00 00       	call   49d3 <unlink>
    31c9:	83 c4 10             	add    $0x10,%esp
    31cc:	85 c0                	test   %eax,%eax
    31ce:	0f 88 cc 01 00 00    	js     33a0 <subdir+0x600>
  printf(1, "subdir ok\n");
    31d4:	83 ec 08             	sub    $0x8,%esp
    31d7:	68 ba 58 00 00       	push   $0x58ba
    31dc:	6a 01                	push   $0x1
    31de:	e8 1d 19 00 00       	call   4b00 <printf>
}
    31e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    31e6:	83 c4 10             	add    $0x10,%esp
    31e9:	c9                   	leave  
    31ea:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    31eb:	50                   	push   %eax
    31ec:	50                   	push   %eax
    31ed:	68 57 56 00 00       	push   $0x5657
    31f2:	6a 01                	push   $0x1
    31f4:	e8 07 19 00 00       	call   4b00 <printf>
    exit();
    31f9:	e8 85 17 00 00       	call   4983 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    31fe:	50                   	push   %eax
    31ff:	50                   	push   %eax
    3200:	68 b2 56 00 00       	push   $0x56b2
    3205:	6a 01                	push   $0x1
    3207:	e8 f4 18 00 00       	call   4b00 <printf>
    exit();
    320c:	e8 72 17 00 00       	call   4983 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    3211:	50                   	push   %eax
    3212:	50                   	push   %eax
    3213:	68 7d 56 00 00       	push   $0x567d
    3218:	6a 01                	push   $0x1
    321a:	e8 e1 18 00 00       	call   4b00 <printf>
    exit();
    321f:	e8 5f 17 00 00       	call   4983 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    3224:	51                   	push   %ecx
    3225:	51                   	push   %ecx
    3226:	68 2f 57 00 00       	push   $0x572f
    322b:	6a 01                	push   $0x1
    322d:	e8 ce 18 00 00       	call   4b00 <printf>
    exit();
    3232:	e8 4c 17 00 00       	call   4983 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    3237:	53                   	push   %ebx
    3238:	53                   	push   %ebx
    3239:	68 14 61 00 00       	push   $0x6114
    323e:	6a 01                	push   $0x1
    3240:	e8 bb 18 00 00       	call   4b00 <printf>
    exit();
    3245:	e8 39 17 00 00       	call   4983 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    324a:	51                   	push   %ecx
    324b:	51                   	push   %ecx
    324c:	68 c3 57 00 00       	push   $0x57c3
    3251:	6a 01                	push   $0x1
    3253:	e8 a8 18 00 00       	call   4b00 <printf>
    exit();
    3258:	e8 26 17 00 00       	call   4983 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    325d:	53                   	push   %ebx
    325e:	53                   	push   %ebx
    325f:	68 84 61 00 00       	push   $0x6184
    3264:	6a 01                	push   $0x1
    3266:	e8 95 18 00 00       	call   4b00 <printf>
    exit();
    326b:	e8 13 17 00 00       	call   4983 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    3270:	50                   	push   %eax
    3271:	50                   	push   %eax
    3272:	68 3e 56 00 00       	push   $0x563e
    3277:	6a 01                	push   $0x1
    3279:	e8 82 18 00 00       	call   4b00 <printf>
    exit();
    327e:	e8 00 17 00 00       	call   4983 <exit>
    printf(1, "create dd/dd/ff failed\n");
    3283:	51                   	push   %ecx
    3284:	51                   	push   %ecx
    3285:	68 17 56 00 00       	push   $0x5617
    328a:	6a 01                	push   $0x1
    328c:	e8 6f 18 00 00       	call   4b00 <printf>
    exit();
    3291:	e8 ed 16 00 00       	call   4983 <exit>
    printf(1, "chdir ./.. failed\n");
    3296:	50                   	push   %eax
    3297:	50                   	push   %eax
    3298:	68 e0 56 00 00       	push   $0x56e0
    329d:	6a 01                	push   $0x1
    329f:	e8 5c 18 00 00       	call   4b00 <printf>
    exit();
    32a4:	e8 da 16 00 00       	call   4983 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    32a9:	52                   	push   %edx
    32aa:	52                   	push   %edx
    32ab:	68 cc 60 00 00       	push   $0x60cc
    32b0:	6a 01                	push   $0x1
    32b2:	e8 49 18 00 00       	call   4b00 <printf>
    exit();
    32b7:	e8 c7 16 00 00       	call   4983 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    32bc:	50                   	push   %eax
    32bd:	50                   	push   %eax
    32be:	68 60 61 00 00       	push   $0x6160
    32c3:	6a 01                	push   $0x1
    32c5:	e8 36 18 00 00       	call   4b00 <printf>
    exit();
    32ca:	e8 b4 16 00 00       	call   4983 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    32cf:	50                   	push   %eax
    32d0:	50                   	push   %eax
    32d1:	68 3c 61 00 00       	push   $0x613c
    32d6:	6a 01                	push   $0x1
    32d8:	e8 23 18 00 00       	call   4b00 <printf>
    exit();
    32dd:	e8 a1 16 00 00       	call   4983 <exit>
    printf(1, "open dd wronly succeeded!\n");
    32e2:	50                   	push   %eax
    32e3:	50                   	push   %eax
    32e4:	68 9f 57 00 00       	push   $0x579f
    32e9:	6a 01                	push   $0x1
    32eb:	e8 10 18 00 00       	call   4b00 <printf>
    exit();
    32f0:	e8 8e 16 00 00       	call   4983 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    32f5:	50                   	push   %eax
    32f6:	50                   	push   %eax
    32f7:	68 86 57 00 00       	push   $0x5786
    32fc:	6a 01                	push   $0x1
    32fe:	e8 fd 17 00 00       	call   4b00 <printf>
    exit();
    3303:	e8 7b 16 00 00       	call   4983 <exit>
    printf(1, "create dd succeeded!\n");
    3308:	50                   	push   %eax
    3309:	50                   	push   %eax
    330a:	68 70 57 00 00       	push   $0x5770
    330f:	6a 01                	push   $0x1
    3311:	e8 ea 17 00 00       	call   4b00 <printf>
    exit();
    3316:	e8 68 16 00 00       	call   4983 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    331b:	52                   	push   %edx
    331c:	52                   	push   %edx
    331d:	68 54 57 00 00       	push   $0x5754
    3322:	6a 01                	push   $0x1
    3324:	e8 d7 17 00 00       	call   4b00 <printf>
    exit();
    3329:	e8 55 16 00 00       	call   4983 <exit>
    printf(1, "chdir dd failed\n");
    332e:	50                   	push   %eax
    332f:	50                   	push   %eax
    3330:	68 95 56 00 00       	push   $0x5695
    3335:	6a 01                	push   $0x1
    3337:	e8 c4 17 00 00       	call   4b00 <printf>
    exit();
    333c:	e8 42 16 00 00       	call   4983 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    3341:	50                   	push   %eax
    3342:	50                   	push   %eax
    3343:	68 f0 60 00 00       	push   $0x60f0
    3348:	6a 01                	push   $0x1
    334a:	e8 b1 17 00 00       	call   4b00 <printf>
    exit();
    334f:	e8 2f 16 00 00       	call   4983 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    3354:	53                   	push   %ebx
    3355:	53                   	push   %ebx
    3356:	68 f3 55 00 00       	push   $0x55f3
    335b:	6a 01                	push   $0x1
    335d:	e8 9e 17 00 00       	call   4b00 <printf>
    exit();
    3362:	e8 1c 16 00 00       	call   4983 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    3367:	50                   	push   %eax
    3368:	50                   	push   %eax
    3369:	68 a4 60 00 00       	push   $0x60a4
    336e:	6a 01                	push   $0x1
    3370:	e8 8b 17 00 00       	call   4b00 <printf>
    exit();
    3375:	e8 09 16 00 00       	call   4983 <exit>
    printf(1, "create dd/ff failed\n");
    337a:	50                   	push   %eax
    337b:	50                   	push   %eax
    337c:	68 d7 55 00 00       	push   $0x55d7
    3381:	6a 01                	push   $0x1
    3383:	e8 78 17 00 00       	call   4b00 <printf>
    exit();
    3388:	e8 f6 15 00 00       	call   4983 <exit>
    printf(1, "subdir mkdir dd failed\n");
    338d:	50                   	push   %eax
    338e:	50                   	push   %eax
    338f:	68 bf 55 00 00       	push   $0x55bf
    3394:	6a 01                	push   $0x1
    3396:	e8 65 17 00 00       	call   4b00 <printf>
    exit();
    339b:	e8 e3 15 00 00       	call   4983 <exit>
    printf(1, "unlink dd failed\n");
    33a0:	50                   	push   %eax
    33a1:	50                   	push   %eax
    33a2:	68 a8 58 00 00       	push   $0x58a8
    33a7:	6a 01                	push   $0x1
    33a9:	e8 52 17 00 00       	call   4b00 <printf>
    exit();
    33ae:	e8 d0 15 00 00       	call   4983 <exit>
    printf(1, "unlink dd/dd failed\n");
    33b3:	52                   	push   %edx
    33b4:	52                   	push   %edx
    33b5:	68 93 58 00 00       	push   $0x5893
    33ba:	6a 01                	push   $0x1
    33bc:	e8 3f 17 00 00       	call   4b00 <printf>
    exit();
    33c1:	e8 bd 15 00 00       	call   4983 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    33c6:	51                   	push   %ecx
    33c7:	51                   	push   %ecx
    33c8:	68 a8 61 00 00       	push   $0x61a8
    33cd:	6a 01                	push   $0x1
    33cf:	e8 2c 17 00 00       	call   4b00 <printf>
    exit();
    33d4:	e8 aa 15 00 00       	call   4983 <exit>
    printf(1, "unlink dd/ff failed\n");
    33d9:	53                   	push   %ebx
    33da:	53                   	push   %ebx
    33db:	68 7e 58 00 00       	push   $0x587e
    33e0:	6a 01                	push   $0x1
    33e2:	e8 19 17 00 00       	call   4b00 <printf>
    exit();
    33e7:	e8 97 15 00 00       	call   4983 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    33ec:	50                   	push   %eax
    33ed:	50                   	push   %eax
    33ee:	68 66 58 00 00       	push   $0x5866
    33f3:	6a 01                	push   $0x1
    33f5:	e8 06 17 00 00       	call   4b00 <printf>
    exit();
    33fa:	e8 84 15 00 00       	call   4983 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    33ff:	50                   	push   %eax
    3400:	50                   	push   %eax
    3401:	68 4e 58 00 00       	push   $0x584e
    3406:	6a 01                	push   $0x1
    3408:	e8 f3 16 00 00       	call   4b00 <printf>
    exit();
    340d:	e8 71 15 00 00       	call   4983 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    3412:	50                   	push   %eax
    3413:	50                   	push   %eax
    3414:	68 32 58 00 00       	push   $0x5832
    3419:	6a 01                	push   $0x1
    341b:	e8 e0 16 00 00       	call   4b00 <printf>
    exit();
    3420:	e8 5e 15 00 00       	call   4983 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    3425:	50                   	push   %eax
    3426:	50                   	push   %eax
    3427:	68 16 58 00 00       	push   $0x5816
    342c:	6a 01                	push   $0x1
    342e:	e8 cd 16 00 00       	call   4b00 <printf>
    exit();
    3433:	e8 4b 15 00 00       	call   4983 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    3438:	50                   	push   %eax
    3439:	50                   	push   %eax
    343a:	68 f9 57 00 00       	push   $0x57f9
    343f:	6a 01                	push   $0x1
    3441:	e8 ba 16 00 00       	call   4b00 <printf>
    exit();
    3446:	e8 38 15 00 00       	call   4983 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    344b:	52                   	push   %edx
    344c:	52                   	push   %edx
    344d:	68 de 57 00 00       	push   $0x57de
    3452:	6a 01                	push   $0x1
    3454:	e8 a7 16 00 00       	call   4b00 <printf>
    exit();
    3459:	e8 25 15 00 00       	call   4983 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    345e:	51                   	push   %ecx
    345f:	51                   	push   %ecx
    3460:	68 0b 57 00 00       	push   $0x570b
    3465:	6a 01                	push   $0x1
    3467:	e8 94 16 00 00       	call   4b00 <printf>
    exit();
    346c:	e8 12 15 00 00       	call   4983 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    3471:	53                   	push   %ebx
    3472:	53                   	push   %ebx
    3473:	68 f3 56 00 00       	push   $0x56f3
    3478:	6a 01                	push   $0x1
    347a:	e8 81 16 00 00       	call   4b00 <printf>
    exit();
    347f:	e8 ff 14 00 00       	call   4983 <exit>
    3484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    348b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    348f:	90                   	nop

00003490 <bigwrite>:
{
    3490:	f3 0f 1e fb          	endbr32 
    3494:	55                   	push   %ebp
    3495:	89 e5                	mov    %esp,%ebp
    3497:	56                   	push   %esi
    3498:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    3499:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    349e:	83 ec 08             	sub    $0x8,%esp
    34a1:	68 c5 58 00 00       	push   $0x58c5
    34a6:	6a 01                	push   $0x1
    34a8:	e8 53 16 00 00       	call   4b00 <printf>
  unlink("bigwrite");
    34ad:	c7 04 24 d4 58 00 00 	movl   $0x58d4,(%esp)
    34b4:	e8 1a 15 00 00       	call   49d3 <unlink>
    34b9:	83 c4 10             	add    $0x10,%esp
    34bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    34c0:	83 ec 08             	sub    $0x8,%esp
    34c3:	68 02 02 00 00       	push   $0x202
    34c8:	68 d4 58 00 00       	push   $0x58d4
    34cd:	e8 f1 14 00 00       	call   49c3 <open>
    if(fd < 0){
    34d2:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    34d5:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    34d7:	85 c0                	test   %eax,%eax
    34d9:	78 7e                	js     3559 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    34db:	83 ec 04             	sub    $0x4,%esp
    34de:	53                   	push   %ebx
    34df:	68 e0 96 00 00       	push   $0x96e0
    34e4:	50                   	push   %eax
    34e5:	e8 b9 14 00 00       	call   49a3 <write>
      if(cc != sz){
    34ea:	83 c4 10             	add    $0x10,%esp
    34ed:	39 d8                	cmp    %ebx,%eax
    34ef:	75 55                	jne    3546 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    34f1:	83 ec 04             	sub    $0x4,%esp
    34f4:	53                   	push   %ebx
    34f5:	68 e0 96 00 00       	push   $0x96e0
    34fa:	56                   	push   %esi
    34fb:	e8 a3 14 00 00       	call   49a3 <write>
      if(cc != sz){
    3500:	83 c4 10             	add    $0x10,%esp
    3503:	39 d8                	cmp    %ebx,%eax
    3505:	75 3f                	jne    3546 <bigwrite+0xb6>
    close(fd);
    3507:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    350a:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    3510:	56                   	push   %esi
    3511:	e8 95 14 00 00       	call   49ab <close>
    unlink("bigwrite");
    3516:	c7 04 24 d4 58 00 00 	movl   $0x58d4,(%esp)
    351d:	e8 b1 14 00 00       	call   49d3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    3522:	83 c4 10             	add    $0x10,%esp
    3525:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    352b:	75 93                	jne    34c0 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    352d:	83 ec 08             	sub    $0x8,%esp
    3530:	68 07 59 00 00       	push   $0x5907
    3535:	6a 01                	push   $0x1
    3537:	e8 c4 15 00 00       	call   4b00 <printf>
}
    353c:	83 c4 10             	add    $0x10,%esp
    353f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3542:	5b                   	pop    %ebx
    3543:	5e                   	pop    %esi
    3544:	5d                   	pop    %ebp
    3545:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    3546:	50                   	push   %eax
    3547:	53                   	push   %ebx
    3548:	68 f5 58 00 00       	push   $0x58f5
    354d:	6a 01                	push   $0x1
    354f:	e8 ac 15 00 00       	call   4b00 <printf>
        exit();
    3554:	e8 2a 14 00 00       	call   4983 <exit>
      printf(1, "cannot create bigwrite\n");
    3559:	83 ec 08             	sub    $0x8,%esp
    355c:	68 dd 58 00 00       	push   $0x58dd
    3561:	6a 01                	push   $0x1
    3563:	e8 98 15 00 00       	call   4b00 <printf>
      exit();
    3568:	e8 16 14 00 00       	call   4983 <exit>
    356d:	8d 76 00             	lea    0x0(%esi),%esi

00003570 <bigfile>:
{
    3570:	f3 0f 1e fb          	endbr32 
    3574:	55                   	push   %ebp
    3575:	89 e5                	mov    %esp,%ebp
    3577:	57                   	push   %edi
    3578:	56                   	push   %esi
    3579:	53                   	push   %ebx
    357a:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    357d:	68 14 59 00 00       	push   $0x5914
    3582:	6a 01                	push   $0x1
    3584:	e8 77 15 00 00       	call   4b00 <printf>
  unlink("bigfile");
    3589:	c7 04 24 30 59 00 00 	movl   $0x5930,(%esp)
    3590:	e8 3e 14 00 00       	call   49d3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    3595:	58                   	pop    %eax
    3596:	5a                   	pop    %edx
    3597:	68 02 02 00 00       	push   $0x202
    359c:	68 30 59 00 00       	push   $0x5930
    35a1:	e8 1d 14 00 00       	call   49c3 <open>
  if(fd < 0){
    35a6:	83 c4 10             	add    $0x10,%esp
    35a9:	85 c0                	test   %eax,%eax
    35ab:	0f 88 5a 01 00 00    	js     370b <bigfile+0x19b>
    35b1:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    35b3:	31 db                	xor    %ebx,%ebx
    35b5:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    35b8:	83 ec 04             	sub    $0x4,%esp
    35bb:	68 58 02 00 00       	push   $0x258
    35c0:	53                   	push   %ebx
    35c1:	68 e0 96 00 00       	push   $0x96e0
    35c6:	e8 15 12 00 00       	call   47e0 <memset>
    if(write(fd, buf, 600) != 600){
    35cb:	83 c4 0c             	add    $0xc,%esp
    35ce:	68 58 02 00 00       	push   $0x258
    35d3:	68 e0 96 00 00       	push   $0x96e0
    35d8:	56                   	push   %esi
    35d9:	e8 c5 13 00 00       	call   49a3 <write>
    35de:	83 c4 10             	add    $0x10,%esp
    35e1:	3d 58 02 00 00       	cmp    $0x258,%eax
    35e6:	0f 85 f8 00 00 00    	jne    36e4 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    35ec:	83 c3 01             	add    $0x1,%ebx
    35ef:	83 fb 14             	cmp    $0x14,%ebx
    35f2:	75 c4                	jne    35b8 <bigfile+0x48>
  close(fd);
    35f4:	83 ec 0c             	sub    $0xc,%esp
    35f7:	56                   	push   %esi
    35f8:	e8 ae 13 00 00       	call   49ab <close>
  fd = open("bigfile", 0);
    35fd:	5e                   	pop    %esi
    35fe:	5f                   	pop    %edi
    35ff:	6a 00                	push   $0x0
    3601:	68 30 59 00 00       	push   $0x5930
    3606:	e8 b8 13 00 00       	call   49c3 <open>
  if(fd < 0){
    360b:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    360e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    3610:	85 c0                	test   %eax,%eax
    3612:	0f 88 e0 00 00 00    	js     36f8 <bigfile+0x188>
  total = 0;
    3618:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    361a:	31 ff                	xor    %edi,%edi
    361c:	eb 30                	jmp    364e <bigfile+0xde>
    361e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    3620:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    3625:	0f 85 91 00 00 00    	jne    36bc <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    362b:	89 fa                	mov    %edi,%edx
    362d:	0f be 05 e0 96 00 00 	movsbl 0x96e0,%eax
    3634:	d1 fa                	sar    %edx
    3636:	39 d0                	cmp    %edx,%eax
    3638:	75 6e                	jne    36a8 <bigfile+0x138>
    363a:	0f be 15 0b 98 00 00 	movsbl 0x980b,%edx
    3641:	39 d0                	cmp    %edx,%eax
    3643:	75 63                	jne    36a8 <bigfile+0x138>
    total += cc;
    3645:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    364b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    364e:	83 ec 04             	sub    $0x4,%esp
    3651:	68 2c 01 00 00       	push   $0x12c
    3656:	68 e0 96 00 00       	push   $0x96e0
    365b:	56                   	push   %esi
    365c:	e8 3a 13 00 00       	call   499b <read>
    if(cc < 0){
    3661:	83 c4 10             	add    $0x10,%esp
    3664:	85 c0                	test   %eax,%eax
    3666:	78 68                	js     36d0 <bigfile+0x160>
    if(cc == 0)
    3668:	75 b6                	jne    3620 <bigfile+0xb0>
  close(fd);
    366a:	83 ec 0c             	sub    $0xc,%esp
    366d:	56                   	push   %esi
    366e:	e8 38 13 00 00       	call   49ab <close>
  if(total != 20*600){
    3673:	83 c4 10             	add    $0x10,%esp
    3676:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    367c:	0f 85 9c 00 00 00    	jne    371e <bigfile+0x1ae>
  unlink("bigfile");
    3682:	83 ec 0c             	sub    $0xc,%esp
    3685:	68 30 59 00 00       	push   $0x5930
    368a:	e8 44 13 00 00       	call   49d3 <unlink>
  printf(1, "bigfile test ok\n");
    368f:	58                   	pop    %eax
    3690:	5a                   	pop    %edx
    3691:	68 bf 59 00 00       	push   $0x59bf
    3696:	6a 01                	push   $0x1
    3698:	e8 63 14 00 00       	call   4b00 <printf>
}
    369d:	83 c4 10             	add    $0x10,%esp
    36a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    36a3:	5b                   	pop    %ebx
    36a4:	5e                   	pop    %esi
    36a5:	5f                   	pop    %edi
    36a6:	5d                   	pop    %ebp
    36a7:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    36a8:	83 ec 08             	sub    $0x8,%esp
    36ab:	68 8c 59 00 00       	push   $0x598c
    36b0:	6a 01                	push   $0x1
    36b2:	e8 49 14 00 00       	call   4b00 <printf>
      exit();
    36b7:	e8 c7 12 00 00       	call   4983 <exit>
      printf(1, "short read bigfile\n");
    36bc:	83 ec 08             	sub    $0x8,%esp
    36bf:	68 78 59 00 00       	push   $0x5978
    36c4:	6a 01                	push   $0x1
    36c6:	e8 35 14 00 00       	call   4b00 <printf>
      exit();
    36cb:	e8 b3 12 00 00       	call   4983 <exit>
      printf(1, "read bigfile failed\n");
    36d0:	83 ec 08             	sub    $0x8,%esp
    36d3:	68 63 59 00 00       	push   $0x5963
    36d8:	6a 01                	push   $0x1
    36da:	e8 21 14 00 00       	call   4b00 <printf>
      exit();
    36df:	e8 9f 12 00 00       	call   4983 <exit>
      printf(1, "write bigfile failed\n");
    36e4:	83 ec 08             	sub    $0x8,%esp
    36e7:	68 38 59 00 00       	push   $0x5938
    36ec:	6a 01                	push   $0x1
    36ee:	e8 0d 14 00 00       	call   4b00 <printf>
      exit();
    36f3:	e8 8b 12 00 00       	call   4983 <exit>
    printf(1, "cannot open bigfile\n");
    36f8:	53                   	push   %ebx
    36f9:	53                   	push   %ebx
    36fa:	68 4e 59 00 00       	push   $0x594e
    36ff:	6a 01                	push   $0x1
    3701:	e8 fa 13 00 00       	call   4b00 <printf>
    exit();
    3706:	e8 78 12 00 00       	call   4983 <exit>
    printf(1, "cannot create bigfile");
    370b:	50                   	push   %eax
    370c:	50                   	push   %eax
    370d:	68 22 59 00 00       	push   $0x5922
    3712:	6a 01                	push   $0x1
    3714:	e8 e7 13 00 00       	call   4b00 <printf>
    exit();
    3719:	e8 65 12 00 00       	call   4983 <exit>
    printf(1, "read bigfile wrong total\n");
    371e:	51                   	push   %ecx
    371f:	51                   	push   %ecx
    3720:	68 a5 59 00 00       	push   $0x59a5
    3725:	6a 01                	push   $0x1
    3727:	e8 d4 13 00 00       	call   4b00 <printf>
    exit();
    372c:	e8 52 12 00 00       	call   4983 <exit>
    3731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    373f:	90                   	nop

00003740 <fourteen>:
{
    3740:	f3 0f 1e fb          	endbr32 
    3744:	55                   	push   %ebp
    3745:	89 e5                	mov    %esp,%ebp
    3747:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    374a:	68 d0 59 00 00       	push   $0x59d0
    374f:	6a 01                	push   $0x1
    3751:	e8 aa 13 00 00       	call   4b00 <printf>
  if(mkdir("12345678901234") != 0){
    3756:	c7 04 24 0b 5a 00 00 	movl   $0x5a0b,(%esp)
    375d:	e8 89 12 00 00       	call   49eb <mkdir>
    3762:	83 c4 10             	add    $0x10,%esp
    3765:	85 c0                	test   %eax,%eax
    3767:	0f 85 97 00 00 00    	jne    3804 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    376d:	83 ec 0c             	sub    $0xc,%esp
    3770:	68 c8 61 00 00       	push   $0x61c8
    3775:	e8 71 12 00 00       	call   49eb <mkdir>
    377a:	83 c4 10             	add    $0x10,%esp
    377d:	85 c0                	test   %eax,%eax
    377f:	0f 85 de 00 00 00    	jne    3863 <fourteen+0x123>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3785:	83 ec 08             	sub    $0x8,%esp
    3788:	68 00 02 00 00       	push   $0x200
    378d:	68 18 62 00 00       	push   $0x6218
    3792:	e8 2c 12 00 00       	call   49c3 <open>
  if(fd < 0){
    3797:	83 c4 10             	add    $0x10,%esp
    379a:	85 c0                	test   %eax,%eax
    379c:	0f 88 ae 00 00 00    	js     3850 <fourteen+0x110>
  close(fd);
    37a2:	83 ec 0c             	sub    $0xc,%esp
    37a5:	50                   	push   %eax
    37a6:	e8 00 12 00 00       	call   49ab <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    37ab:	58                   	pop    %eax
    37ac:	5a                   	pop    %edx
    37ad:	6a 00                	push   $0x0
    37af:	68 88 62 00 00       	push   $0x6288
    37b4:	e8 0a 12 00 00       	call   49c3 <open>
  if(fd < 0){
    37b9:	83 c4 10             	add    $0x10,%esp
    37bc:	85 c0                	test   %eax,%eax
    37be:	78 7d                	js     383d <fourteen+0xfd>
  close(fd);
    37c0:	83 ec 0c             	sub    $0xc,%esp
    37c3:	50                   	push   %eax
    37c4:	e8 e2 11 00 00       	call   49ab <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    37c9:	c7 04 24 fc 59 00 00 	movl   $0x59fc,(%esp)
    37d0:	e8 16 12 00 00       	call   49eb <mkdir>
    37d5:	83 c4 10             	add    $0x10,%esp
    37d8:	85 c0                	test   %eax,%eax
    37da:	74 4e                	je     382a <fourteen+0xea>
  if(mkdir("123456789012345/12345678901234") == 0){
    37dc:	83 ec 0c             	sub    $0xc,%esp
    37df:	68 24 63 00 00       	push   $0x6324
    37e4:	e8 02 12 00 00       	call   49eb <mkdir>
    37e9:	83 c4 10             	add    $0x10,%esp
    37ec:	85 c0                	test   %eax,%eax
    37ee:	74 27                	je     3817 <fourteen+0xd7>
  printf(1, "fourteen ok\n");
    37f0:	83 ec 08             	sub    $0x8,%esp
    37f3:	68 1a 5a 00 00       	push   $0x5a1a
    37f8:	6a 01                	push   $0x1
    37fa:	e8 01 13 00 00       	call   4b00 <printf>
}
    37ff:	83 c4 10             	add    $0x10,%esp
    3802:	c9                   	leave  
    3803:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    3804:	50                   	push   %eax
    3805:	50                   	push   %eax
    3806:	68 df 59 00 00       	push   $0x59df
    380b:	6a 01                	push   $0x1
    380d:	e8 ee 12 00 00       	call   4b00 <printf>
    exit();
    3812:	e8 6c 11 00 00       	call   4983 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    3817:	50                   	push   %eax
    3818:	50                   	push   %eax
    3819:	68 44 63 00 00       	push   $0x6344
    381e:	6a 01                	push   $0x1
    3820:	e8 db 12 00 00       	call   4b00 <printf>
    exit();
    3825:	e8 59 11 00 00       	call   4983 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    382a:	52                   	push   %edx
    382b:	52                   	push   %edx
    382c:	68 f4 62 00 00       	push   $0x62f4
    3831:	6a 01                	push   $0x1
    3833:	e8 c8 12 00 00       	call   4b00 <printf>
    exit();
    3838:	e8 46 11 00 00       	call   4983 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    383d:	51                   	push   %ecx
    383e:	51                   	push   %ecx
    383f:	68 b8 62 00 00       	push   $0x62b8
    3844:	6a 01                	push   $0x1
    3846:	e8 b5 12 00 00       	call   4b00 <printf>
    exit();
    384b:	e8 33 11 00 00       	call   4983 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    3850:	51                   	push   %ecx
    3851:	51                   	push   %ecx
    3852:	68 48 62 00 00       	push   $0x6248
    3857:	6a 01                	push   $0x1
    3859:	e8 a2 12 00 00       	call   4b00 <printf>
    exit();
    385e:	e8 20 11 00 00       	call   4983 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    3863:	50                   	push   %eax
    3864:	50                   	push   %eax
    3865:	68 e8 61 00 00       	push   $0x61e8
    386a:	6a 01                	push   $0x1
    386c:	e8 8f 12 00 00       	call   4b00 <printf>
    exit();
    3871:	e8 0d 11 00 00       	call   4983 <exit>
    3876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    387d:	8d 76 00             	lea    0x0(%esi),%esi

00003880 <rmdot>:
{
    3880:	f3 0f 1e fb          	endbr32 
    3884:	55                   	push   %ebp
    3885:	89 e5                	mov    %esp,%ebp
    3887:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    388a:	68 27 5a 00 00       	push   $0x5a27
    388f:	6a 01                	push   $0x1
    3891:	e8 6a 12 00 00       	call   4b00 <printf>
  if(mkdir("dots") != 0){
    3896:	c7 04 24 33 5a 00 00 	movl   $0x5a33,(%esp)
    389d:	e8 49 11 00 00       	call   49eb <mkdir>
    38a2:	83 c4 10             	add    $0x10,%esp
    38a5:	85 c0                	test   %eax,%eax
    38a7:	0f 85 b0 00 00 00    	jne    395d <rmdot+0xdd>
  if(chdir("dots") != 0){
    38ad:	83 ec 0c             	sub    $0xc,%esp
    38b0:	68 33 5a 00 00       	push   $0x5a33
    38b5:	e8 39 11 00 00       	call   49f3 <chdir>
    38ba:	83 c4 10             	add    $0x10,%esp
    38bd:	85 c0                	test   %eax,%eax
    38bf:	0f 85 1d 01 00 00    	jne    39e2 <rmdot+0x162>
  if(unlink(".") == 0){
    38c5:	83 ec 0c             	sub    $0xc,%esp
    38c8:	68 de 56 00 00       	push   $0x56de
    38cd:	e8 01 11 00 00       	call   49d3 <unlink>
    38d2:	83 c4 10             	add    $0x10,%esp
    38d5:	85 c0                	test   %eax,%eax
    38d7:	0f 84 f2 00 00 00    	je     39cf <rmdot+0x14f>
  if(unlink("..") == 0){
    38dd:	83 ec 0c             	sub    $0xc,%esp
    38e0:	68 dd 56 00 00       	push   $0x56dd
    38e5:	e8 e9 10 00 00       	call   49d3 <unlink>
    38ea:	83 c4 10             	add    $0x10,%esp
    38ed:	85 c0                	test   %eax,%eax
    38ef:	0f 84 c7 00 00 00    	je     39bc <rmdot+0x13c>
  if(chdir("/") != 0){
    38f5:	83 ec 0c             	sub    $0xc,%esp
    38f8:	68 b1 4e 00 00       	push   $0x4eb1
    38fd:	e8 f1 10 00 00       	call   49f3 <chdir>
    3902:	83 c4 10             	add    $0x10,%esp
    3905:	85 c0                	test   %eax,%eax
    3907:	0f 85 9c 00 00 00    	jne    39a9 <rmdot+0x129>
  if(unlink("dots/.") == 0){
    390d:	83 ec 0c             	sub    $0xc,%esp
    3910:	68 7b 5a 00 00       	push   $0x5a7b
    3915:	e8 b9 10 00 00       	call   49d3 <unlink>
    391a:	83 c4 10             	add    $0x10,%esp
    391d:	85 c0                	test   %eax,%eax
    391f:	74 75                	je     3996 <rmdot+0x116>
  if(unlink("dots/..") == 0){
    3921:	83 ec 0c             	sub    $0xc,%esp
    3924:	68 99 5a 00 00       	push   $0x5a99
    3929:	e8 a5 10 00 00       	call   49d3 <unlink>
    392e:	83 c4 10             	add    $0x10,%esp
    3931:	85 c0                	test   %eax,%eax
    3933:	74 4e                	je     3983 <rmdot+0x103>
  if(unlink("dots") != 0){
    3935:	83 ec 0c             	sub    $0xc,%esp
    3938:	68 33 5a 00 00       	push   $0x5a33
    393d:	e8 91 10 00 00       	call   49d3 <unlink>
    3942:	83 c4 10             	add    $0x10,%esp
    3945:	85 c0                	test   %eax,%eax
    3947:	75 27                	jne    3970 <rmdot+0xf0>
  printf(1, "rmdot ok\n");
    3949:	83 ec 08             	sub    $0x8,%esp
    394c:	68 ce 5a 00 00       	push   $0x5ace
    3951:	6a 01                	push   $0x1
    3953:	e8 a8 11 00 00       	call   4b00 <printf>
}
    3958:	83 c4 10             	add    $0x10,%esp
    395b:	c9                   	leave  
    395c:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    395d:	50                   	push   %eax
    395e:	50                   	push   %eax
    395f:	68 38 5a 00 00       	push   $0x5a38
    3964:	6a 01                	push   $0x1
    3966:	e8 95 11 00 00       	call   4b00 <printf>
    exit();
    396b:	e8 13 10 00 00       	call   4983 <exit>
    printf(1, "unlink dots failed!\n");
    3970:	50                   	push   %eax
    3971:	50                   	push   %eax
    3972:	68 b9 5a 00 00       	push   $0x5ab9
    3977:	6a 01                	push   $0x1
    3979:	e8 82 11 00 00       	call   4b00 <printf>
    exit();
    397e:	e8 00 10 00 00       	call   4983 <exit>
    printf(1, "unlink dots/.. worked!\n");
    3983:	52                   	push   %edx
    3984:	52                   	push   %edx
    3985:	68 a1 5a 00 00       	push   $0x5aa1
    398a:	6a 01                	push   $0x1
    398c:	e8 6f 11 00 00       	call   4b00 <printf>
    exit();
    3991:	e8 ed 0f 00 00       	call   4983 <exit>
    printf(1, "unlink dots/. worked!\n");
    3996:	51                   	push   %ecx
    3997:	51                   	push   %ecx
    3998:	68 82 5a 00 00       	push   $0x5a82
    399d:	6a 01                	push   $0x1
    399f:	e8 5c 11 00 00       	call   4b00 <printf>
    exit();
    39a4:	e8 da 0f 00 00       	call   4983 <exit>
    printf(1, "chdir / failed\n");
    39a9:	50                   	push   %eax
    39aa:	50                   	push   %eax
    39ab:	68 b3 4e 00 00       	push   $0x4eb3
    39b0:	6a 01                	push   $0x1
    39b2:	e8 49 11 00 00       	call   4b00 <printf>
    exit();
    39b7:	e8 c7 0f 00 00       	call   4983 <exit>
    printf(1, "rm .. worked!\n");
    39bc:	50                   	push   %eax
    39bd:	50                   	push   %eax
    39be:	68 6c 5a 00 00       	push   $0x5a6c
    39c3:	6a 01                	push   $0x1
    39c5:	e8 36 11 00 00       	call   4b00 <printf>
    exit();
    39ca:	e8 b4 0f 00 00       	call   4983 <exit>
    printf(1, "rm . worked!\n");
    39cf:	50                   	push   %eax
    39d0:	50                   	push   %eax
    39d1:	68 5e 5a 00 00       	push   $0x5a5e
    39d6:	6a 01                	push   $0x1
    39d8:	e8 23 11 00 00       	call   4b00 <printf>
    exit();
    39dd:	e8 a1 0f 00 00       	call   4983 <exit>
    printf(1, "chdir dots failed\n");
    39e2:	50                   	push   %eax
    39e3:	50                   	push   %eax
    39e4:	68 4b 5a 00 00       	push   $0x5a4b
    39e9:	6a 01                	push   $0x1
    39eb:	e8 10 11 00 00       	call   4b00 <printf>
    exit();
    39f0:	e8 8e 0f 00 00       	call   4983 <exit>
    39f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    39fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003a00 <dirfile>:
{
    3a00:	f3 0f 1e fb          	endbr32 
    3a04:	55                   	push   %ebp
    3a05:	89 e5                	mov    %esp,%ebp
    3a07:	53                   	push   %ebx
    3a08:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    3a0b:	68 d8 5a 00 00       	push   $0x5ad8
    3a10:	6a 01                	push   $0x1
    3a12:	e8 e9 10 00 00       	call   4b00 <printf>
  fd = open("dirfile", O_CREATE);
    3a17:	5b                   	pop    %ebx
    3a18:	58                   	pop    %eax
    3a19:	68 00 02 00 00       	push   $0x200
    3a1e:	68 e5 5a 00 00       	push   $0x5ae5
    3a23:	e8 9b 0f 00 00       	call   49c3 <open>
  if(fd < 0){
    3a28:	83 c4 10             	add    $0x10,%esp
    3a2b:	85 c0                	test   %eax,%eax
    3a2d:	0f 88 43 01 00 00    	js     3b76 <dirfile+0x176>
  close(fd);
    3a33:	83 ec 0c             	sub    $0xc,%esp
    3a36:	50                   	push   %eax
    3a37:	e8 6f 0f 00 00       	call   49ab <close>
  if(chdir("dirfile") == 0){
    3a3c:	c7 04 24 e5 5a 00 00 	movl   $0x5ae5,(%esp)
    3a43:	e8 ab 0f 00 00       	call   49f3 <chdir>
    3a48:	83 c4 10             	add    $0x10,%esp
    3a4b:	85 c0                	test   %eax,%eax
    3a4d:	0f 84 10 01 00 00    	je     3b63 <dirfile+0x163>
  fd = open("dirfile/xx", 0);
    3a53:	83 ec 08             	sub    $0x8,%esp
    3a56:	6a 00                	push   $0x0
    3a58:	68 1e 5b 00 00       	push   $0x5b1e
    3a5d:	e8 61 0f 00 00       	call   49c3 <open>
  if(fd >= 0){
    3a62:	83 c4 10             	add    $0x10,%esp
    3a65:	85 c0                	test   %eax,%eax
    3a67:	0f 89 e3 00 00 00    	jns    3b50 <dirfile+0x150>
  fd = open("dirfile/xx", O_CREATE);
    3a6d:	83 ec 08             	sub    $0x8,%esp
    3a70:	68 00 02 00 00       	push   $0x200
    3a75:	68 1e 5b 00 00       	push   $0x5b1e
    3a7a:	e8 44 0f 00 00       	call   49c3 <open>
  if(fd >= 0){
    3a7f:	83 c4 10             	add    $0x10,%esp
    3a82:	85 c0                	test   %eax,%eax
    3a84:	0f 89 c6 00 00 00    	jns    3b50 <dirfile+0x150>
  if(mkdir("dirfile/xx") == 0){
    3a8a:	83 ec 0c             	sub    $0xc,%esp
    3a8d:	68 1e 5b 00 00       	push   $0x5b1e
    3a92:	e8 54 0f 00 00       	call   49eb <mkdir>
    3a97:	83 c4 10             	add    $0x10,%esp
    3a9a:	85 c0                	test   %eax,%eax
    3a9c:	0f 84 46 01 00 00    	je     3be8 <dirfile+0x1e8>
  if(unlink("dirfile/xx") == 0){
    3aa2:	83 ec 0c             	sub    $0xc,%esp
    3aa5:	68 1e 5b 00 00       	push   $0x5b1e
    3aaa:	e8 24 0f 00 00       	call   49d3 <unlink>
    3aaf:	83 c4 10             	add    $0x10,%esp
    3ab2:	85 c0                	test   %eax,%eax
    3ab4:	0f 84 1b 01 00 00    	je     3bd5 <dirfile+0x1d5>
  if(link("README", "dirfile/xx") == 0){
    3aba:	83 ec 08             	sub    $0x8,%esp
    3abd:	68 1e 5b 00 00       	push   $0x5b1e
    3ac2:	68 82 5b 00 00       	push   $0x5b82
    3ac7:	e8 17 0f 00 00       	call   49e3 <link>
    3acc:	83 c4 10             	add    $0x10,%esp
    3acf:	85 c0                	test   %eax,%eax
    3ad1:	0f 84 eb 00 00 00    	je     3bc2 <dirfile+0x1c2>
  if(unlink("dirfile") != 0){
    3ad7:	83 ec 0c             	sub    $0xc,%esp
    3ada:	68 e5 5a 00 00       	push   $0x5ae5
    3adf:	e8 ef 0e 00 00       	call   49d3 <unlink>
    3ae4:	83 c4 10             	add    $0x10,%esp
    3ae7:	85 c0                	test   %eax,%eax
    3ae9:	0f 85 c0 00 00 00    	jne    3baf <dirfile+0x1af>
  fd = open(".", O_RDWR);
    3aef:	83 ec 08             	sub    $0x8,%esp
    3af2:	6a 02                	push   $0x2
    3af4:	68 de 56 00 00       	push   $0x56de
    3af9:	e8 c5 0e 00 00       	call   49c3 <open>
  if(fd >= 0){
    3afe:	83 c4 10             	add    $0x10,%esp
    3b01:	85 c0                	test   %eax,%eax
    3b03:	0f 89 93 00 00 00    	jns    3b9c <dirfile+0x19c>
  fd = open(".", 0);
    3b09:	83 ec 08             	sub    $0x8,%esp
    3b0c:	6a 00                	push   $0x0
    3b0e:	68 de 56 00 00       	push   $0x56de
    3b13:	e8 ab 0e 00 00       	call   49c3 <open>
  if(write(fd, "x", 1) > 0){
    3b18:	83 c4 0c             	add    $0xc,%esp
    3b1b:	6a 01                	push   $0x1
  fd = open(".", 0);
    3b1d:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    3b1f:	68 c1 57 00 00       	push   $0x57c1
    3b24:	50                   	push   %eax
    3b25:	e8 79 0e 00 00       	call   49a3 <write>
    3b2a:	83 c4 10             	add    $0x10,%esp
    3b2d:	85 c0                	test   %eax,%eax
    3b2f:	7f 58                	jg     3b89 <dirfile+0x189>
  close(fd);
    3b31:	83 ec 0c             	sub    $0xc,%esp
    3b34:	53                   	push   %ebx
    3b35:	e8 71 0e 00 00       	call   49ab <close>
  printf(1, "dir vs file OK\n");
    3b3a:	58                   	pop    %eax
    3b3b:	5a                   	pop    %edx
    3b3c:	68 b5 5b 00 00       	push   $0x5bb5
    3b41:	6a 01                	push   $0x1
    3b43:	e8 b8 0f 00 00       	call   4b00 <printf>
}
    3b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b4b:	83 c4 10             	add    $0x10,%esp
    3b4e:	c9                   	leave  
    3b4f:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    3b50:	50                   	push   %eax
    3b51:	50                   	push   %eax
    3b52:	68 29 5b 00 00       	push   $0x5b29
    3b57:	6a 01                	push   $0x1
    3b59:	e8 a2 0f 00 00       	call   4b00 <printf>
    exit();
    3b5e:	e8 20 0e 00 00       	call   4983 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    3b63:	52                   	push   %edx
    3b64:	52                   	push   %edx
    3b65:	68 04 5b 00 00       	push   $0x5b04
    3b6a:	6a 01                	push   $0x1
    3b6c:	e8 8f 0f 00 00       	call   4b00 <printf>
    exit();
    3b71:	e8 0d 0e 00 00       	call   4983 <exit>
    printf(1, "create dirfile failed\n");
    3b76:	51                   	push   %ecx
    3b77:	51                   	push   %ecx
    3b78:	68 ed 5a 00 00       	push   $0x5aed
    3b7d:	6a 01                	push   $0x1
    3b7f:	e8 7c 0f 00 00       	call   4b00 <printf>
    exit();
    3b84:	e8 fa 0d 00 00       	call   4983 <exit>
    printf(1, "write . succeeded!\n");
    3b89:	51                   	push   %ecx
    3b8a:	51                   	push   %ecx
    3b8b:	68 a1 5b 00 00       	push   $0x5ba1
    3b90:	6a 01                	push   $0x1
    3b92:	e8 69 0f 00 00       	call   4b00 <printf>
    exit();
    3b97:	e8 e7 0d 00 00       	call   4983 <exit>
    printf(1, "open . for writing succeeded!\n");
    3b9c:	53                   	push   %ebx
    3b9d:	53                   	push   %ebx
    3b9e:	68 98 63 00 00       	push   $0x6398
    3ba3:	6a 01                	push   $0x1
    3ba5:	e8 56 0f 00 00       	call   4b00 <printf>
    exit();
    3baa:	e8 d4 0d 00 00       	call   4983 <exit>
    printf(1, "unlink dirfile failed!\n");
    3baf:	50                   	push   %eax
    3bb0:	50                   	push   %eax
    3bb1:	68 89 5b 00 00       	push   $0x5b89
    3bb6:	6a 01                	push   $0x1
    3bb8:	e8 43 0f 00 00       	call   4b00 <printf>
    exit();
    3bbd:	e8 c1 0d 00 00       	call   4983 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    3bc2:	50                   	push   %eax
    3bc3:	50                   	push   %eax
    3bc4:	68 78 63 00 00       	push   $0x6378
    3bc9:	6a 01                	push   $0x1
    3bcb:	e8 30 0f 00 00       	call   4b00 <printf>
    exit();
    3bd0:	e8 ae 0d 00 00       	call   4983 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3bd5:	50                   	push   %eax
    3bd6:	50                   	push   %eax
    3bd7:	68 64 5b 00 00       	push   $0x5b64
    3bdc:	6a 01                	push   $0x1
    3bde:	e8 1d 0f 00 00       	call   4b00 <printf>
    exit();
    3be3:	e8 9b 0d 00 00       	call   4983 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    3be8:	50                   	push   %eax
    3be9:	50                   	push   %eax
    3bea:	68 47 5b 00 00       	push   $0x5b47
    3bef:	6a 01                	push   $0x1
    3bf1:	e8 0a 0f 00 00       	call   4b00 <printf>
    exit();
    3bf6:	e8 88 0d 00 00       	call   4983 <exit>
    3bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3bff:	90                   	nop

00003c00 <iref>:
{
    3c00:	f3 0f 1e fb          	endbr32 
    3c04:	55                   	push   %ebp
    3c05:	89 e5                	mov    %esp,%ebp
    3c07:	53                   	push   %ebx
  printf(1, "empty file name\n");
    3c08:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    3c0d:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    3c10:	68 c5 5b 00 00       	push   $0x5bc5
    3c15:	6a 01                	push   $0x1
    3c17:	e8 e4 0e 00 00       	call   4b00 <printf>
    3c1c:	83 c4 10             	add    $0x10,%esp
    3c1f:	90                   	nop
    if(mkdir("irefd") != 0){
    3c20:	83 ec 0c             	sub    $0xc,%esp
    3c23:	68 d6 5b 00 00       	push   $0x5bd6
    3c28:	e8 be 0d 00 00       	call   49eb <mkdir>
    3c2d:	83 c4 10             	add    $0x10,%esp
    3c30:	85 c0                	test   %eax,%eax
    3c32:	0f 85 bb 00 00 00    	jne    3cf3 <iref+0xf3>
    if(chdir("irefd") != 0){
    3c38:	83 ec 0c             	sub    $0xc,%esp
    3c3b:	68 d6 5b 00 00       	push   $0x5bd6
    3c40:	e8 ae 0d 00 00       	call   49f3 <chdir>
    3c45:	83 c4 10             	add    $0x10,%esp
    3c48:	85 c0                	test   %eax,%eax
    3c4a:	0f 85 b7 00 00 00    	jne    3d07 <iref+0x107>
    mkdir("");
    3c50:	83 ec 0c             	sub    $0xc,%esp
    3c53:	68 8b 52 00 00       	push   $0x528b
    3c58:	e8 8e 0d 00 00       	call   49eb <mkdir>
    link("README", "");
    3c5d:	59                   	pop    %ecx
    3c5e:	58                   	pop    %eax
    3c5f:	68 8b 52 00 00       	push   $0x528b
    3c64:	68 82 5b 00 00       	push   $0x5b82
    3c69:	e8 75 0d 00 00       	call   49e3 <link>
    fd = open("", O_CREATE);
    3c6e:	58                   	pop    %eax
    3c6f:	5a                   	pop    %edx
    3c70:	68 00 02 00 00       	push   $0x200
    3c75:	68 8b 52 00 00       	push   $0x528b
    3c7a:	e8 44 0d 00 00       	call   49c3 <open>
    if(fd >= 0)
    3c7f:	83 c4 10             	add    $0x10,%esp
    3c82:	85 c0                	test   %eax,%eax
    3c84:	78 0c                	js     3c92 <iref+0x92>
      close(fd);
    3c86:	83 ec 0c             	sub    $0xc,%esp
    3c89:	50                   	push   %eax
    3c8a:	e8 1c 0d 00 00       	call   49ab <close>
    3c8f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    3c92:	83 ec 08             	sub    $0x8,%esp
    3c95:	68 00 02 00 00       	push   $0x200
    3c9a:	68 c0 57 00 00       	push   $0x57c0
    3c9f:	e8 1f 0d 00 00       	call   49c3 <open>
    if(fd >= 0)
    3ca4:	83 c4 10             	add    $0x10,%esp
    3ca7:	85 c0                	test   %eax,%eax
    3ca9:	78 0c                	js     3cb7 <iref+0xb7>
      close(fd);
    3cab:	83 ec 0c             	sub    $0xc,%esp
    3cae:	50                   	push   %eax
    3caf:	e8 f7 0c 00 00       	call   49ab <close>
    3cb4:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    3cb7:	83 ec 0c             	sub    $0xc,%esp
    3cba:	68 c0 57 00 00       	push   $0x57c0
    3cbf:	e8 0f 0d 00 00       	call   49d3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    3cc4:	83 c4 10             	add    $0x10,%esp
    3cc7:	83 eb 01             	sub    $0x1,%ebx
    3cca:	0f 85 50 ff ff ff    	jne    3c20 <iref+0x20>
  chdir("/");
    3cd0:	83 ec 0c             	sub    $0xc,%esp
    3cd3:	68 b1 4e 00 00       	push   $0x4eb1
    3cd8:	e8 16 0d 00 00       	call   49f3 <chdir>
  printf(1, "empty file name OK\n");
    3cdd:	58                   	pop    %eax
    3cde:	5a                   	pop    %edx
    3cdf:	68 04 5c 00 00       	push   $0x5c04
    3ce4:	6a 01                	push   $0x1
    3ce6:	e8 15 0e 00 00       	call   4b00 <printf>
}
    3ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3cee:	83 c4 10             	add    $0x10,%esp
    3cf1:	c9                   	leave  
    3cf2:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    3cf3:	83 ec 08             	sub    $0x8,%esp
    3cf6:	68 dc 5b 00 00       	push   $0x5bdc
    3cfb:	6a 01                	push   $0x1
    3cfd:	e8 fe 0d 00 00       	call   4b00 <printf>
      exit();
    3d02:	e8 7c 0c 00 00       	call   4983 <exit>
      printf(1, "chdir irefd failed\n");
    3d07:	83 ec 08             	sub    $0x8,%esp
    3d0a:	68 f0 5b 00 00       	push   $0x5bf0
    3d0f:	6a 01                	push   $0x1
    3d11:	e8 ea 0d 00 00       	call   4b00 <printf>
      exit();
    3d16:	e8 68 0c 00 00       	call   4983 <exit>
    3d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3d1f:	90                   	nop

00003d20 <forktest>:
{
    3d20:	f3 0f 1e fb          	endbr32 
    3d24:	55                   	push   %ebp
    3d25:	89 e5                	mov    %esp,%ebp
    3d27:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    3d28:	31 db                	xor    %ebx,%ebx
{
    3d2a:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    3d2d:	68 18 5c 00 00       	push   $0x5c18
    3d32:	6a 01                	push   $0x1
    3d34:	e8 c7 0d 00 00       	call   4b00 <printf>
    3d39:	83 c4 10             	add    $0x10,%esp
    3d3c:	eb 0f                	jmp    3d4d <forktest+0x2d>
    3d3e:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    3d40:	74 4a                	je     3d8c <forktest+0x6c>
  for(n=0; n<1000; n++){
    3d42:	83 c3 01             	add    $0x1,%ebx
    3d45:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    3d4b:	74 6b                	je     3db8 <forktest+0x98>
    pid = fork();
    3d4d:	e8 29 0c 00 00       	call   497b <fork>
    if(pid < 0)
    3d52:	85 c0                	test   %eax,%eax
    3d54:	79 ea                	jns    3d40 <forktest+0x20>
  for(; n > 0; n--){
    3d56:	85 db                	test   %ebx,%ebx
    3d58:	74 14                	je     3d6e <forktest+0x4e>
    3d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    3d60:	e8 26 0c 00 00       	call   498b <wait>
    3d65:	85 c0                	test   %eax,%eax
    3d67:	78 28                	js     3d91 <forktest+0x71>
  for(; n > 0; n--){
    3d69:	83 eb 01             	sub    $0x1,%ebx
    3d6c:	75 f2                	jne    3d60 <forktest+0x40>
  if(wait() != -1){
    3d6e:	e8 18 0c 00 00       	call   498b <wait>
    3d73:	83 f8 ff             	cmp    $0xffffffff,%eax
    3d76:	75 2d                	jne    3da5 <forktest+0x85>
  printf(1, "fork test OK\n");
    3d78:	83 ec 08             	sub    $0x8,%esp
    3d7b:	68 4a 5c 00 00       	push   $0x5c4a
    3d80:	6a 01                	push   $0x1
    3d82:	e8 79 0d 00 00       	call   4b00 <printf>
}
    3d87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3d8a:	c9                   	leave  
    3d8b:	c3                   	ret    
      exit();
    3d8c:	e8 f2 0b 00 00       	call   4983 <exit>
      printf(1, "wait stopped early\n");
    3d91:	83 ec 08             	sub    $0x8,%esp
    3d94:	68 23 5c 00 00       	push   $0x5c23
    3d99:	6a 01                	push   $0x1
    3d9b:	e8 60 0d 00 00       	call   4b00 <printf>
      exit();
    3da0:	e8 de 0b 00 00       	call   4983 <exit>
    printf(1, "wait got too many\n");
    3da5:	52                   	push   %edx
    3da6:	52                   	push   %edx
    3da7:	68 37 5c 00 00       	push   $0x5c37
    3dac:	6a 01                	push   $0x1
    3dae:	e8 4d 0d 00 00       	call   4b00 <printf>
    exit();
    3db3:	e8 cb 0b 00 00       	call   4983 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    3db8:	50                   	push   %eax
    3db9:	50                   	push   %eax
    3dba:	68 b8 63 00 00       	push   $0x63b8
    3dbf:	6a 01                	push   $0x1
    3dc1:	e8 3a 0d 00 00       	call   4b00 <printf>
    exit();
    3dc6:	e8 b8 0b 00 00       	call   4983 <exit>
    3dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3dcf:	90                   	nop

00003dd0 <sbrktest>:
{
    3dd0:	f3 0f 1e fb          	endbr32 
    3dd4:	55                   	push   %ebp
    3dd5:	89 e5                	mov    %esp,%ebp
    3dd7:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    3dd8:	31 ff                	xor    %edi,%edi
{
    3dda:	56                   	push   %esi
    3ddb:	53                   	push   %ebx
    3ddc:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    3ddf:	68 58 5c 00 00       	push   $0x5c58
    3de4:	ff 35 00 6f 00 00    	pushl  0x6f00
    3dea:	e8 11 0d 00 00       	call   4b00 <printf>
  oldbrk = sbrk(0);
    3def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3df6:	e8 10 0c 00 00       	call   4a0b <sbrk>
  a = sbrk(0);
    3dfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    3e02:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    3e04:	e8 02 0c 00 00       	call   4a0b <sbrk>
    3e09:	83 c4 10             	add    $0x10,%esp
    3e0c:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    3e0e:	eb 02                	jmp    3e12 <sbrktest+0x42>
    a = b + 1;
    3e10:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    3e12:	83 ec 0c             	sub    $0xc,%esp
    3e15:	6a 01                	push   $0x1
    3e17:	e8 ef 0b 00 00       	call   4a0b <sbrk>
    if(b != a){
    3e1c:	83 c4 10             	add    $0x10,%esp
    3e1f:	39 f0                	cmp    %esi,%eax
    3e21:	0f 85 84 02 00 00    	jne    40ab <sbrktest+0x2db>
  for(i = 0; i < 5000; i++){
    3e27:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    3e2a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    3e2d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    3e30:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    3e36:	75 d8                	jne    3e10 <sbrktest+0x40>
  pid = fork();
    3e38:	e8 3e 0b 00 00       	call   497b <fork>
    3e3d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    3e3f:	85 c0                	test   %eax,%eax
    3e41:	0f 88 91 03 00 00    	js     41d8 <sbrktest+0x408>
  c = sbrk(1);
    3e47:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    3e4a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    3e4d:	6a 01                	push   $0x1
    3e4f:	e8 b7 0b 00 00       	call   4a0b <sbrk>
  c = sbrk(1);
    3e54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e5b:	e8 ab 0b 00 00       	call   4a0b <sbrk>
  if(c != a + 1){
    3e60:	83 c4 10             	add    $0x10,%esp
    3e63:	39 c6                	cmp    %eax,%esi
    3e65:	0f 85 56 03 00 00    	jne    41c1 <sbrktest+0x3f1>
  if(pid == 0)
    3e6b:	85 ff                	test   %edi,%edi
    3e6d:	0f 84 49 03 00 00    	je     41bc <sbrktest+0x3ec>
  wait();
    3e73:	e8 13 0b 00 00       	call   498b <wait>
  a = sbrk(0);
    3e78:	83 ec 0c             	sub    $0xc,%esp
    3e7b:	6a 00                	push   $0x0
    3e7d:	e8 89 0b 00 00       	call   4a0b <sbrk>
    3e82:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    3e84:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3e89:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    3e8b:	89 04 24             	mov    %eax,(%esp)
    3e8e:	e8 78 0b 00 00       	call   4a0b <sbrk>
  if (p != a) {
    3e93:	83 c4 10             	add    $0x10,%esp
    3e96:	39 c6                	cmp    %eax,%esi
    3e98:	0f 85 07 03 00 00    	jne    41a5 <sbrktest+0x3d5>
  a = sbrk(0);
    3e9e:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    3ea1:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    3ea8:	6a 00                	push   $0x0
    3eaa:	e8 5c 0b 00 00       	call   4a0b <sbrk>
  c = sbrk(-4096);
    3eaf:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    3eb6:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    3eb8:	e8 4e 0b 00 00       	call   4a0b <sbrk>
  if(c == (char*)0xffffffff){
    3ebd:	83 c4 10             	add    $0x10,%esp
    3ec0:	83 f8 ff             	cmp    $0xffffffff,%eax
    3ec3:	0f 84 c5 02 00 00    	je     418e <sbrktest+0x3be>
  c = sbrk(0);
    3ec9:	83 ec 0c             	sub    $0xc,%esp
    3ecc:	6a 00                	push   $0x0
    3ece:	e8 38 0b 00 00       	call   4a0b <sbrk>
  if(c != a - 4096){
    3ed3:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    3ed9:	83 c4 10             	add    $0x10,%esp
    3edc:	39 d0                	cmp    %edx,%eax
    3ede:	0f 85 93 02 00 00    	jne    4177 <sbrktest+0x3a7>
  a = sbrk(0);
    3ee4:	83 ec 0c             	sub    $0xc,%esp
    3ee7:	6a 00                	push   $0x0
    3ee9:	e8 1d 0b 00 00       	call   4a0b <sbrk>
  c = sbrk(4096);
    3eee:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    3ef5:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    3ef7:	e8 0f 0b 00 00       	call   4a0b <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    3efc:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    3eff:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    3f01:	39 c6                	cmp    %eax,%esi
    3f03:	0f 85 57 02 00 00    	jne    4160 <sbrktest+0x390>
    3f09:	83 ec 0c             	sub    $0xc,%esp
    3f0c:	6a 00                	push   $0x0
    3f0e:	e8 f8 0a 00 00       	call   4a0b <sbrk>
    3f13:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    3f19:	83 c4 10             	add    $0x10,%esp
    3f1c:	39 c2                	cmp    %eax,%edx
    3f1e:	0f 85 3c 02 00 00    	jne    4160 <sbrktest+0x390>
  if(*lastaddr == 99){
    3f24:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    3f2b:	0f 84 18 02 00 00    	je     4149 <sbrktest+0x379>
  a = sbrk(0);
    3f31:	83 ec 0c             	sub    $0xc,%esp
    3f34:	6a 00                	push   $0x0
    3f36:	e8 d0 0a 00 00       	call   4a0b <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    3f3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    3f42:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    3f44:	e8 c2 0a 00 00       	call   4a0b <sbrk>
    3f49:	89 d9                	mov    %ebx,%ecx
    3f4b:	29 c1                	sub    %eax,%ecx
    3f4d:	89 0c 24             	mov    %ecx,(%esp)
    3f50:	e8 b6 0a 00 00       	call   4a0b <sbrk>
  if(c != a){
    3f55:	83 c4 10             	add    $0x10,%esp
    3f58:	39 c6                	cmp    %eax,%esi
    3f5a:	0f 85 d2 01 00 00    	jne    4132 <sbrktest+0x362>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3f60:	be 00 00 00 80       	mov    $0x80000000,%esi
    3f65:	8d 76 00             	lea    0x0(%esi),%esi
    ppid = getpid();
    3f68:	e8 96 0a 00 00       	call   4a03 <getpid>
    3f6d:	89 c7                	mov    %eax,%edi
    pid = fork();
    3f6f:	e8 07 0a 00 00       	call   497b <fork>
    if(pid < 0){
    3f74:	85 c0                	test   %eax,%eax
    3f76:	0f 88 9e 01 00 00    	js     411a <sbrktest+0x34a>
    if(pid == 0){
    3f7c:	0f 84 76 01 00 00    	je     40f8 <sbrktest+0x328>
    wait();
    3f82:	e8 04 0a 00 00       	call   498b <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3f87:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    3f8d:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    3f93:	75 d3                	jne    3f68 <sbrktest+0x198>
  if(pipe(fds) != 0){
    3f95:	83 ec 0c             	sub    $0xc,%esp
    3f98:	8d 45 b8             	lea    -0x48(%ebp),%eax
    3f9b:	50                   	push   %eax
    3f9c:	e8 f2 09 00 00       	call   4993 <pipe>
    3fa1:	83 c4 10             	add    $0x10,%esp
    3fa4:	85 c0                	test   %eax,%eax
    3fa6:	0f 85 34 01 00 00    	jne    40e0 <sbrktest+0x310>
    3fac:	8d 75 c0             	lea    -0x40(%ebp),%esi
    3faf:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    3fb1:	e8 c5 09 00 00       	call   497b <fork>
    3fb6:	89 07                	mov    %eax,(%edi)
    3fb8:	85 c0                	test   %eax,%eax
    3fba:	0f 84 8f 00 00 00    	je     404f <sbrktest+0x27f>
    if(pids[i] != -1)
    3fc0:	83 f8 ff             	cmp    $0xffffffff,%eax
    3fc3:	74 14                	je     3fd9 <sbrktest+0x209>
      read(fds[0], &scratch, 1);
    3fc5:	83 ec 04             	sub    $0x4,%esp
    3fc8:	8d 45 b7             	lea    -0x49(%ebp),%eax
    3fcb:	6a 01                	push   $0x1
    3fcd:	50                   	push   %eax
    3fce:	ff 75 b8             	pushl  -0x48(%ebp)
    3fd1:	e8 c5 09 00 00       	call   499b <read>
    3fd6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3fd9:	83 c7 04             	add    $0x4,%edi
    3fdc:	8d 45 e8             	lea    -0x18(%ebp),%eax
    3fdf:	39 c7                	cmp    %eax,%edi
    3fe1:	75 ce                	jne    3fb1 <sbrktest+0x1e1>
  c = sbrk(4096);
    3fe3:	83 ec 0c             	sub    $0xc,%esp
    3fe6:	68 00 10 00 00       	push   $0x1000
    3feb:	e8 1b 0a 00 00       	call   4a0b <sbrk>
    3ff0:	83 c4 10             	add    $0x10,%esp
    3ff3:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    3ff5:	8b 06                	mov    (%esi),%eax
    3ff7:	83 f8 ff             	cmp    $0xffffffff,%eax
    3ffa:	74 11                	je     400d <sbrktest+0x23d>
    kill(pids[i]);
    3ffc:	83 ec 0c             	sub    $0xc,%esp
    3fff:	50                   	push   %eax
    4000:	e8 ae 09 00 00       	call   49b3 <kill>
    wait();
    4005:	e8 81 09 00 00       	call   498b <wait>
    400a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    400d:	83 c6 04             	add    $0x4,%esi
    4010:	8d 45 e8             	lea    -0x18(%ebp),%eax
    4013:	39 f0                	cmp    %esi,%eax
    4015:	75 de                	jne    3ff5 <sbrktest+0x225>
  if(c == (char*)0xffffffff){
    4017:	83 ff ff             	cmp    $0xffffffff,%edi
    401a:	0f 84 a9 00 00 00    	je     40c9 <sbrktest+0x2f9>
  if(sbrk(0) > oldbrk)
    4020:	83 ec 0c             	sub    $0xc,%esp
    4023:	6a 00                	push   $0x0
    4025:	e8 e1 09 00 00       	call   4a0b <sbrk>
    402a:	83 c4 10             	add    $0x10,%esp
    402d:	39 c3                	cmp    %eax,%ebx
    402f:	72 61                	jb     4092 <sbrktest+0x2c2>
  printf(stdout, "sbrk test OK\n");
    4031:	83 ec 08             	sub    $0x8,%esp
    4034:	68 00 5d 00 00       	push   $0x5d00
    4039:	ff 35 00 6f 00 00    	pushl  0x6f00
    403f:	e8 bc 0a 00 00       	call   4b00 <printf>
}
    4044:	83 c4 10             	add    $0x10,%esp
    4047:	8d 65 f4             	lea    -0xc(%ebp),%esp
    404a:	5b                   	pop    %ebx
    404b:	5e                   	pop    %esi
    404c:	5f                   	pop    %edi
    404d:	5d                   	pop    %ebp
    404e:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    404f:	83 ec 0c             	sub    $0xc,%esp
    4052:	6a 00                	push   $0x0
    4054:	e8 b2 09 00 00       	call   4a0b <sbrk>
    4059:	89 c2                	mov    %eax,%edx
    405b:	b8 00 00 40 06       	mov    $0x6400000,%eax
    4060:	29 d0                	sub    %edx,%eax
    4062:	89 04 24             	mov    %eax,(%esp)
    4065:	e8 a1 09 00 00       	call   4a0b <sbrk>
      write(fds[1], "x", 1);
    406a:	83 c4 0c             	add    $0xc,%esp
    406d:	6a 01                	push   $0x1
    406f:	68 c1 57 00 00       	push   $0x57c1
    4074:	ff 75 bc             	pushl  -0x44(%ebp)
    4077:	e8 27 09 00 00       	call   49a3 <write>
    407c:	83 c4 10             	add    $0x10,%esp
    407f:	90                   	nop
      for(;;) sleep(1000);
    4080:	83 ec 0c             	sub    $0xc,%esp
    4083:	68 e8 03 00 00       	push   $0x3e8
    4088:	e8 86 09 00 00       	call   4a13 <sleep>
    408d:	83 c4 10             	add    $0x10,%esp
    4090:	eb ee                	jmp    4080 <sbrktest+0x2b0>
    sbrk(-(sbrk(0) - oldbrk));
    4092:	83 ec 0c             	sub    $0xc,%esp
    4095:	6a 00                	push   $0x0
    4097:	e8 6f 09 00 00       	call   4a0b <sbrk>
    409c:	29 c3                	sub    %eax,%ebx
    409e:	89 1c 24             	mov    %ebx,(%esp)
    40a1:	e8 65 09 00 00       	call   4a0b <sbrk>
    40a6:	83 c4 10             	add    $0x10,%esp
    40a9:	eb 86                	jmp    4031 <sbrktest+0x261>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    40ab:	83 ec 0c             	sub    $0xc,%esp
    40ae:	50                   	push   %eax
    40af:	56                   	push   %esi
    40b0:	57                   	push   %edi
    40b1:	68 63 5c 00 00       	push   $0x5c63
    40b6:	ff 35 00 6f 00 00    	pushl  0x6f00
    40bc:	e8 3f 0a 00 00       	call   4b00 <printf>
      exit();
    40c1:	83 c4 20             	add    $0x20,%esp
    40c4:	e8 ba 08 00 00       	call   4983 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    40c9:	50                   	push   %eax
    40ca:	50                   	push   %eax
    40cb:	68 e5 5c 00 00       	push   $0x5ce5
    40d0:	ff 35 00 6f 00 00    	pushl  0x6f00
    40d6:	e8 25 0a 00 00       	call   4b00 <printf>
    exit();
    40db:	e8 a3 08 00 00       	call   4983 <exit>
    printf(1, "pipe() failed\n");
    40e0:	52                   	push   %edx
    40e1:	52                   	push   %edx
    40e2:	68 a1 51 00 00       	push   $0x51a1
    40e7:	6a 01                	push   $0x1
    40e9:	e8 12 0a 00 00       	call   4b00 <printf>
    exit();
    40ee:	e8 90 08 00 00       	call   4983 <exit>
    40f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    40f7:	90                   	nop
      printf(stdout, "oops could read %x = %x\n", a, *a);
    40f8:	0f be 06             	movsbl (%esi),%eax
    40fb:	50                   	push   %eax
    40fc:	56                   	push   %esi
    40fd:	68 cc 5c 00 00       	push   $0x5ccc
    4102:	ff 35 00 6f 00 00    	pushl  0x6f00
    4108:	e8 f3 09 00 00       	call   4b00 <printf>
      kill(ppid);
    410d:	89 3c 24             	mov    %edi,(%esp)
    4110:	e8 9e 08 00 00       	call   49b3 <kill>
      exit();
    4115:	e8 69 08 00 00       	call   4983 <exit>
      printf(stdout, "fork failed\n");
    411a:	83 ec 08             	sub    $0x8,%esp
    411d:	68 a9 5d 00 00       	push   $0x5da9
    4122:	ff 35 00 6f 00 00    	pushl  0x6f00
    4128:	e8 d3 09 00 00       	call   4b00 <printf>
      exit();
    412d:	e8 51 08 00 00       	call   4983 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    4132:	50                   	push   %eax
    4133:	56                   	push   %esi
    4134:	68 ac 64 00 00       	push   $0x64ac
    4139:	ff 35 00 6f 00 00    	pushl  0x6f00
    413f:	e8 bc 09 00 00       	call   4b00 <printf>
    exit();
    4144:	e8 3a 08 00 00       	call   4983 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    4149:	51                   	push   %ecx
    414a:	51                   	push   %ecx
    414b:	68 7c 64 00 00       	push   $0x647c
    4150:	ff 35 00 6f 00 00    	pushl  0x6f00
    4156:	e8 a5 09 00 00       	call   4b00 <printf>
    exit();
    415b:	e8 23 08 00 00       	call   4983 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    4160:	57                   	push   %edi
    4161:	56                   	push   %esi
    4162:	68 54 64 00 00       	push   $0x6454
    4167:	ff 35 00 6f 00 00    	pushl  0x6f00
    416d:	e8 8e 09 00 00       	call   4b00 <printf>
    exit();
    4172:	e8 0c 08 00 00       	call   4983 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    4177:	50                   	push   %eax
    4178:	56                   	push   %esi
    4179:	68 1c 64 00 00       	push   $0x641c
    417e:	ff 35 00 6f 00 00    	pushl  0x6f00
    4184:	e8 77 09 00 00       	call   4b00 <printf>
    exit();
    4189:	e8 f5 07 00 00       	call   4983 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    418e:	53                   	push   %ebx
    418f:	53                   	push   %ebx
    4190:	68 b1 5c 00 00       	push   $0x5cb1
    4195:	ff 35 00 6f 00 00    	pushl  0x6f00
    419b:	e8 60 09 00 00       	call   4b00 <printf>
    exit();
    41a0:	e8 de 07 00 00       	call   4983 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    41a5:	56                   	push   %esi
    41a6:	56                   	push   %esi
    41a7:	68 dc 63 00 00       	push   $0x63dc
    41ac:	ff 35 00 6f 00 00    	pushl  0x6f00
    41b2:	e8 49 09 00 00       	call   4b00 <printf>
    exit();
    41b7:	e8 c7 07 00 00       	call   4983 <exit>
    exit();
    41bc:	e8 c2 07 00 00       	call   4983 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    41c1:	57                   	push   %edi
    41c2:	57                   	push   %edi
    41c3:	68 95 5c 00 00       	push   $0x5c95
    41c8:	ff 35 00 6f 00 00    	pushl  0x6f00
    41ce:	e8 2d 09 00 00       	call   4b00 <printf>
    exit();
    41d3:	e8 ab 07 00 00       	call   4983 <exit>
    printf(stdout, "sbrk test fork failed\n");
    41d8:	50                   	push   %eax
    41d9:	50                   	push   %eax
    41da:	68 7e 5c 00 00       	push   $0x5c7e
    41df:	ff 35 00 6f 00 00    	pushl  0x6f00
    41e5:	e8 16 09 00 00       	call   4b00 <printf>
    exit();
    41ea:	e8 94 07 00 00       	call   4983 <exit>
    41ef:	90                   	nop

000041f0 <validateint>:
{
    41f0:	f3 0f 1e fb          	endbr32 
}
    41f4:	c3                   	ret    
    41f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    41fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00004200 <validatetest>:
{
    4200:	f3 0f 1e fb          	endbr32 
    4204:	55                   	push   %ebp
    4205:	89 e5                	mov    %esp,%ebp
    4207:	56                   	push   %esi
  for(p = 0; p <= (uint)hi; p += 4096){
    4208:	31 f6                	xor    %esi,%esi
{
    420a:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    420b:	83 ec 08             	sub    $0x8,%esp
    420e:	68 0e 5d 00 00       	push   $0x5d0e
    4213:	ff 35 00 6f 00 00    	pushl  0x6f00
    4219:	e8 e2 08 00 00       	call   4b00 <printf>
    421e:	83 c4 10             	add    $0x10,%esp
    4221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pid = fork()) == 0){
    4228:	e8 4e 07 00 00       	call   497b <fork>
    422d:	89 c3                	mov    %eax,%ebx
    422f:	85 c0                	test   %eax,%eax
    4231:	74 63                	je     4296 <validatetest+0x96>
    sleep(0);
    4233:	83 ec 0c             	sub    $0xc,%esp
    4236:	6a 00                	push   $0x0
    4238:	e8 d6 07 00 00       	call   4a13 <sleep>
    sleep(0);
    423d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4244:	e8 ca 07 00 00       	call   4a13 <sleep>
    kill(pid);
    4249:	89 1c 24             	mov    %ebx,(%esp)
    424c:	e8 62 07 00 00       	call   49b3 <kill>
    wait();
    4251:	e8 35 07 00 00       	call   498b <wait>
    if(link("nosuchfile", (char*)p) != -1){
    4256:	58                   	pop    %eax
    4257:	5a                   	pop    %edx
    4258:	56                   	push   %esi
    4259:	68 1d 5d 00 00       	push   $0x5d1d
    425e:	e8 80 07 00 00       	call   49e3 <link>
    4263:	83 c4 10             	add    $0x10,%esp
    4266:	83 f8 ff             	cmp    $0xffffffff,%eax
    4269:	75 30                	jne    429b <validatetest+0x9b>
  for(p = 0; p <= (uint)hi; p += 4096){
    426b:	81 c6 00 10 00 00    	add    $0x1000,%esi
    4271:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    4277:	75 af                	jne    4228 <validatetest+0x28>
  printf(stdout, "validate ok\n");
    4279:	83 ec 08             	sub    $0x8,%esp
    427c:	68 41 5d 00 00       	push   $0x5d41
    4281:	ff 35 00 6f 00 00    	pushl  0x6f00
    4287:	e8 74 08 00 00       	call   4b00 <printf>
}
    428c:	83 c4 10             	add    $0x10,%esp
    428f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    4292:	5b                   	pop    %ebx
    4293:	5e                   	pop    %esi
    4294:	5d                   	pop    %ebp
    4295:	c3                   	ret    
      exit();
    4296:	e8 e8 06 00 00       	call   4983 <exit>
      printf(stdout, "link should not succeed\n");
    429b:	83 ec 08             	sub    $0x8,%esp
    429e:	68 28 5d 00 00       	push   $0x5d28
    42a3:	ff 35 00 6f 00 00    	pushl  0x6f00
    42a9:	e8 52 08 00 00       	call   4b00 <printf>
      exit();
    42ae:	e8 d0 06 00 00       	call   4983 <exit>
    42b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    42ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000042c0 <bsstest>:
{
    42c0:	f3 0f 1e fb          	endbr32 
    42c4:	55                   	push   %ebp
    42c5:	89 e5                	mov    %esp,%ebp
    42c7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    42ca:	68 4e 5d 00 00       	push   $0x5d4e
    42cf:	ff 35 00 6f 00 00    	pushl  0x6f00
    42d5:	e8 26 08 00 00       	call   4b00 <printf>
    42da:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    42dd:	31 c0                	xor    %eax,%eax
    42df:	90                   	nop
    if(uninit[i] != '\0'){
    42e0:	80 b8 c0 6f 00 00 00 	cmpb   $0x0,0x6fc0(%eax)
    42e7:	75 22                	jne    430b <bsstest+0x4b>
  for(i = 0; i < sizeof(uninit); i++){
    42e9:	83 c0 01             	add    $0x1,%eax
    42ec:	3d 10 27 00 00       	cmp    $0x2710,%eax
    42f1:	75 ed                	jne    42e0 <bsstest+0x20>
  printf(stdout, "bss test ok\n");
    42f3:	83 ec 08             	sub    $0x8,%esp
    42f6:	68 69 5d 00 00       	push   $0x5d69
    42fb:	ff 35 00 6f 00 00    	pushl  0x6f00
    4301:	e8 fa 07 00 00       	call   4b00 <printf>
}
    4306:	83 c4 10             	add    $0x10,%esp
    4309:	c9                   	leave  
    430a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    430b:	83 ec 08             	sub    $0x8,%esp
    430e:	68 58 5d 00 00       	push   $0x5d58
    4313:	ff 35 00 6f 00 00    	pushl  0x6f00
    4319:	e8 e2 07 00 00       	call   4b00 <printf>
      exit();
    431e:	e8 60 06 00 00       	call   4983 <exit>
    4323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00004330 <bigargtest>:
{
    4330:	f3 0f 1e fb          	endbr32 
    4334:	55                   	push   %ebp
    4335:	89 e5                	mov    %esp,%ebp
    4337:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    433a:	68 76 5d 00 00       	push   $0x5d76
    433f:	e8 8f 06 00 00       	call   49d3 <unlink>
  pid = fork();
    4344:	e8 32 06 00 00       	call   497b <fork>
  if(pid == 0){
    4349:	83 c4 10             	add    $0x10,%esp
    434c:	85 c0                	test   %eax,%eax
    434e:	74 40                	je     4390 <bigargtest+0x60>
  } else if(pid < 0){
    4350:	0f 88 c1 00 00 00    	js     4417 <bigargtest+0xe7>
  wait();
    4356:	e8 30 06 00 00       	call   498b <wait>
  fd = open("bigarg-ok", 0);
    435b:	83 ec 08             	sub    $0x8,%esp
    435e:	6a 00                	push   $0x0
    4360:	68 76 5d 00 00       	push   $0x5d76
    4365:	e8 59 06 00 00       	call   49c3 <open>
  if(fd < 0){
    436a:	83 c4 10             	add    $0x10,%esp
    436d:	85 c0                	test   %eax,%eax
    436f:	0f 88 8b 00 00 00    	js     4400 <bigargtest+0xd0>
  close(fd);
    4375:	83 ec 0c             	sub    $0xc,%esp
    4378:	50                   	push   %eax
    4379:	e8 2d 06 00 00       	call   49ab <close>
  unlink("bigarg-ok");
    437e:	c7 04 24 76 5d 00 00 	movl   $0x5d76,(%esp)
    4385:	e8 49 06 00 00       	call   49d3 <unlink>
}
    438a:	83 c4 10             	add    $0x10,%esp
    438d:	c9                   	leave  
    438e:	c3                   	ret    
    438f:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    4390:	c7 04 85 20 6f 00 00 	movl   $0x64d0,0x6f20(,%eax,4)
    4397:	d0 64 00 00 
    for(i = 0; i < MAXARG-1; i++)
    439b:	83 c0 01             	add    $0x1,%eax
    439e:	83 f8 1f             	cmp    $0x1f,%eax
    43a1:	75 ed                	jne    4390 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    43a3:	51                   	push   %ecx
    43a4:	51                   	push   %ecx
    43a5:	68 80 5d 00 00       	push   $0x5d80
    43aa:	ff 35 00 6f 00 00    	pushl  0x6f00
    args[MAXARG-1] = 0;
    43b0:	c7 05 9c 6f 00 00 00 	movl   $0x0,0x6f9c
    43b7:	00 00 00 
    printf(stdout, "bigarg test\n");
    43ba:	e8 41 07 00 00       	call   4b00 <printf>
    exec("echo", args);
    43bf:	58                   	pop    %eax
    43c0:	5a                   	pop    %edx
    43c1:	68 20 6f 00 00       	push   $0x6f20
    43c6:	68 4d 4f 00 00       	push   $0x4f4d
    43cb:	e8 eb 05 00 00       	call   49bb <exec>
    printf(stdout, "bigarg test ok\n");
    43d0:	59                   	pop    %ecx
    43d1:	58                   	pop    %eax
    43d2:	68 8d 5d 00 00       	push   $0x5d8d
    43d7:	ff 35 00 6f 00 00    	pushl  0x6f00
    43dd:	e8 1e 07 00 00       	call   4b00 <printf>
    fd = open("bigarg-ok", O_CREATE);
    43e2:	58                   	pop    %eax
    43e3:	5a                   	pop    %edx
    43e4:	68 00 02 00 00       	push   $0x200
    43e9:	68 76 5d 00 00       	push   $0x5d76
    43ee:	e8 d0 05 00 00       	call   49c3 <open>
    close(fd);
    43f3:	89 04 24             	mov    %eax,(%esp)
    43f6:	e8 b0 05 00 00       	call   49ab <close>
    exit();
    43fb:	e8 83 05 00 00       	call   4983 <exit>
    printf(stdout, "bigarg test failed!\n");
    4400:	50                   	push   %eax
    4401:	50                   	push   %eax
    4402:	68 b6 5d 00 00       	push   $0x5db6
    4407:	ff 35 00 6f 00 00    	pushl  0x6f00
    440d:	e8 ee 06 00 00       	call   4b00 <printf>
    exit();
    4412:	e8 6c 05 00 00       	call   4983 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    4417:	52                   	push   %edx
    4418:	52                   	push   %edx
    4419:	68 9d 5d 00 00       	push   $0x5d9d
    441e:	ff 35 00 6f 00 00    	pushl  0x6f00
    4424:	e8 d7 06 00 00       	call   4b00 <printf>
    exit();
    4429:	e8 55 05 00 00       	call   4983 <exit>
    442e:	66 90                	xchg   %ax,%ax

00004430 <fsfull>:
{
    4430:	f3 0f 1e fb          	endbr32 
    4434:	55                   	push   %ebp
    4435:	89 e5                	mov    %esp,%ebp
    4437:	57                   	push   %edi
    4438:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    4439:	31 f6                	xor    %esi,%esi
{
    443b:	53                   	push   %ebx
    443c:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    443f:	68 cb 5d 00 00       	push   $0x5dcb
    4444:	6a 01                	push   $0x1
    4446:	e8 b5 06 00 00       	call   4b00 <printf>
    444b:	83 c4 10             	add    $0x10,%esp
    444e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + nfiles / 1000;
    4450:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    4455:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    445a:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    445d:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    4461:	f7 e6                	mul    %esi
    name[5] = '\0';
    4463:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    4467:	c1 ea 06             	shr    $0x6,%edx
    446a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    446d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    4473:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    4476:	89 f0                	mov    %esi,%eax
    4478:	29 d0                	sub    %edx,%eax
    447a:	89 c2                	mov    %eax,%edx
    447c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    4481:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    4483:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    4488:	c1 ea 05             	shr    $0x5,%edx
    448b:	83 c2 30             	add    $0x30,%edx
    448e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    4491:	f7 e6                	mul    %esi
    4493:	89 f0                	mov    %esi,%eax
    4495:	c1 ea 05             	shr    $0x5,%edx
    4498:	6b d2 64             	imul   $0x64,%edx,%edx
    449b:	29 d0                	sub    %edx,%eax
    449d:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    449f:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    44a1:	c1 ea 03             	shr    $0x3,%edx
    44a4:	83 c2 30             	add    $0x30,%edx
    44a7:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    44aa:	f7 e1                	mul    %ecx
    44ac:	89 f1                	mov    %esi,%ecx
    44ae:	c1 ea 03             	shr    $0x3,%edx
    44b1:	8d 04 92             	lea    (%edx,%edx,4),%eax
    44b4:	01 c0                	add    %eax,%eax
    44b6:	29 c1                	sub    %eax,%ecx
    44b8:	89 c8                	mov    %ecx,%eax
    44ba:	83 c0 30             	add    $0x30,%eax
    44bd:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    44c0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    44c3:	50                   	push   %eax
    44c4:	68 d8 5d 00 00       	push   $0x5dd8
    44c9:	6a 01                	push   $0x1
    44cb:	e8 30 06 00 00       	call   4b00 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    44d0:	58                   	pop    %eax
    44d1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    44d4:	5a                   	pop    %edx
    44d5:	68 02 02 00 00       	push   $0x202
    44da:	50                   	push   %eax
    44db:	e8 e3 04 00 00       	call   49c3 <open>
    if(fd < 0){
    44e0:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    44e3:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    44e5:	85 c0                	test   %eax,%eax
    44e7:	78 4d                	js     4536 <fsfull+0x106>
    int total = 0;
    44e9:	31 db                	xor    %ebx,%ebx
    44eb:	eb 05                	jmp    44f2 <fsfull+0xc2>
    44ed:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    44f0:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    44f2:	83 ec 04             	sub    $0x4,%esp
    44f5:	68 00 02 00 00       	push   $0x200
    44fa:	68 e0 96 00 00       	push   $0x96e0
    44ff:	57                   	push   %edi
    4500:	e8 9e 04 00 00       	call   49a3 <write>
      if(cc < 512)
    4505:	83 c4 10             	add    $0x10,%esp
    4508:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    450d:	7f e1                	jg     44f0 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    450f:	83 ec 04             	sub    $0x4,%esp
    4512:	53                   	push   %ebx
    4513:	68 f4 5d 00 00       	push   $0x5df4
    4518:	6a 01                	push   $0x1
    451a:	e8 e1 05 00 00       	call   4b00 <printf>
    close(fd);
    451f:	89 3c 24             	mov    %edi,(%esp)
    4522:	e8 84 04 00 00       	call   49ab <close>
    if(total == 0)
    4527:	83 c4 10             	add    $0x10,%esp
    452a:	85 db                	test   %ebx,%ebx
    452c:	74 1e                	je     454c <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    452e:	83 c6 01             	add    $0x1,%esi
    4531:	e9 1a ff ff ff       	jmp    4450 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    4536:	83 ec 04             	sub    $0x4,%esp
    4539:	8d 45 a8             	lea    -0x58(%ebp),%eax
    453c:	50                   	push   %eax
    453d:	68 e4 5d 00 00       	push   $0x5de4
    4542:	6a 01                	push   $0x1
    4544:	e8 b7 05 00 00       	call   4b00 <printf>
      break;
    4549:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    454c:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    4551:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    4556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    455d:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    4560:	89 f0                	mov    %esi,%eax
    4562:	89 f1                	mov    %esi,%ecx
    unlink(name);
    4564:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    4567:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    456b:	f7 ef                	imul   %edi
    456d:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    4570:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    4574:	c1 fa 06             	sar    $0x6,%edx
    4577:	29 ca                	sub    %ecx,%edx
    4579:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    457c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    4582:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    4585:	89 f0                	mov    %esi,%eax
    4587:	29 d0                	sub    %edx,%eax
    4589:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    458b:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    458d:	c1 ea 05             	shr    $0x5,%edx
    4590:	83 c2 30             	add    $0x30,%edx
    4593:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    4596:	f7 eb                	imul   %ebx
    4598:	89 f0                	mov    %esi,%eax
    459a:	c1 fa 05             	sar    $0x5,%edx
    459d:	29 ca                	sub    %ecx,%edx
    459f:	6b d2 64             	imul   $0x64,%edx,%edx
    45a2:	29 d0                	sub    %edx,%eax
    45a4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    45a9:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    45ab:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    45ad:	c1 ea 03             	shr    $0x3,%edx
    45b0:	83 c2 30             	add    $0x30,%edx
    45b3:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    45b6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    45bb:	f7 ea                	imul   %edx
    45bd:	c1 fa 02             	sar    $0x2,%edx
    45c0:	29 ca                	sub    %ecx,%edx
    45c2:	89 f1                	mov    %esi,%ecx
    nfiles--;
    45c4:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    45c7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    45ca:	01 c0                	add    %eax,%eax
    45cc:	29 c1                	sub    %eax,%ecx
    45ce:	89 c8                	mov    %ecx,%eax
    45d0:	83 c0 30             	add    $0x30,%eax
    45d3:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    45d6:	8d 45 a8             	lea    -0x58(%ebp),%eax
    45d9:	50                   	push   %eax
    45da:	e8 f4 03 00 00       	call   49d3 <unlink>
  while(nfiles >= 0){
    45df:	83 c4 10             	add    $0x10,%esp
    45e2:	83 fe ff             	cmp    $0xffffffff,%esi
    45e5:	0f 85 75 ff ff ff    	jne    4560 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    45eb:	83 ec 08             	sub    $0x8,%esp
    45ee:	68 04 5e 00 00       	push   $0x5e04
    45f3:	6a 01                	push   $0x1
    45f5:	e8 06 05 00 00       	call   4b00 <printf>
}
    45fa:	83 c4 10             	add    $0x10,%esp
    45fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4600:	5b                   	pop    %ebx
    4601:	5e                   	pop    %esi
    4602:	5f                   	pop    %edi
    4603:	5d                   	pop    %ebp
    4604:	c3                   	ret    
    4605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00004610 <uio>:
{
    4610:	f3 0f 1e fb          	endbr32 
    4614:	55                   	push   %ebp
    4615:	89 e5                	mov    %esp,%ebp
    4617:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    461a:	68 1a 5e 00 00       	push   $0x5e1a
    461f:	6a 01                	push   $0x1
    4621:	e8 da 04 00 00       	call   4b00 <printf>
  pid = fork();
    4626:	e8 50 03 00 00       	call   497b <fork>
  if(pid == 0){
    462b:	83 c4 10             	add    $0x10,%esp
    462e:	85 c0                	test   %eax,%eax
    4630:	74 1b                	je     464d <uio+0x3d>
  } else if(pid < 0){
    4632:	78 3d                	js     4671 <uio+0x61>
  wait();
    4634:	e8 52 03 00 00       	call   498b <wait>
  printf(1, "uio test done\n");
    4639:	83 ec 08             	sub    $0x8,%esp
    463c:	68 24 5e 00 00       	push   $0x5e24
    4641:	6a 01                	push   $0x1
    4643:	e8 b8 04 00 00       	call   4b00 <printf>
}
    4648:	83 c4 10             	add    $0x10,%esp
    464b:	c9                   	leave  
    464c:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    464d:	b8 09 00 00 00       	mov    $0x9,%eax
    4652:	ba 70 00 00 00       	mov    $0x70,%edx
    4657:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    4658:	ba 71 00 00 00       	mov    $0x71,%edx
    465d:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    465e:	52                   	push   %edx
    465f:	52                   	push   %edx
    4660:	68 b0 65 00 00       	push   $0x65b0
    4665:	6a 01                	push   $0x1
    4667:	e8 94 04 00 00       	call   4b00 <printf>
    exit();
    466c:	e8 12 03 00 00       	call   4983 <exit>
    printf (1, "fork failed\n");
    4671:	50                   	push   %eax
    4672:	50                   	push   %eax
    4673:	68 a9 5d 00 00       	push   $0x5da9
    4678:	6a 01                	push   $0x1
    467a:	e8 81 04 00 00       	call   4b00 <printf>
    exit();
    467f:	e8 ff 02 00 00       	call   4983 <exit>
    4684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    468b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    468f:	90                   	nop

00004690 <argptest>:
{
    4690:	f3 0f 1e fb          	endbr32 
    4694:	55                   	push   %ebp
    4695:	89 e5                	mov    %esp,%ebp
    4697:	53                   	push   %ebx
    4698:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    469b:	6a 00                	push   $0x0
    469d:	68 33 5e 00 00       	push   $0x5e33
    46a2:	e8 1c 03 00 00       	call   49c3 <open>
  if (fd < 0) {
    46a7:	83 c4 10             	add    $0x10,%esp
    46aa:	85 c0                	test   %eax,%eax
    46ac:	78 39                	js     46e7 <argptest+0x57>
  read(fd, sbrk(0) - 1, -1);
    46ae:	83 ec 0c             	sub    $0xc,%esp
    46b1:	89 c3                	mov    %eax,%ebx
    46b3:	6a 00                	push   $0x0
    46b5:	e8 51 03 00 00       	call   4a0b <sbrk>
    46ba:	83 c4 0c             	add    $0xc,%esp
    46bd:	83 e8 01             	sub    $0x1,%eax
    46c0:	6a ff                	push   $0xffffffff
    46c2:	50                   	push   %eax
    46c3:	53                   	push   %ebx
    46c4:	e8 d2 02 00 00       	call   499b <read>
  close(fd);
    46c9:	89 1c 24             	mov    %ebx,(%esp)
    46cc:	e8 da 02 00 00       	call   49ab <close>
  printf(1, "arg test passed\n");
    46d1:	58                   	pop    %eax
    46d2:	5a                   	pop    %edx
    46d3:	68 45 5e 00 00       	push   $0x5e45
    46d8:	6a 01                	push   $0x1
    46da:	e8 21 04 00 00       	call   4b00 <printf>
}
    46df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    46e2:	83 c4 10             	add    $0x10,%esp
    46e5:	c9                   	leave  
    46e6:	c3                   	ret    
    printf(2, "open failed\n");
    46e7:	51                   	push   %ecx
    46e8:	51                   	push   %ecx
    46e9:	68 38 5e 00 00       	push   $0x5e38
    46ee:	6a 02                	push   $0x2
    46f0:	e8 0b 04 00 00       	call   4b00 <printf>
    exit();
    46f5:	e8 89 02 00 00       	call   4983 <exit>
    46fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00004700 <rand>:
{
    4700:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    4704:	69 05 fc 6e 00 00 0d 	imul   $0x19660d,0x6efc,%eax
    470b:	66 19 00 
    470e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    4713:	a3 fc 6e 00 00       	mov    %eax,0x6efc
}
    4718:	c3                   	ret    
    4719:	66 90                	xchg   %ax,%ax
    471b:	66 90                	xchg   %ax,%ax
    471d:	66 90                	xchg   %ax,%ax
    471f:	90                   	nop

00004720 <strcpy>:
#include "user.h"
#include "x86.h"
#define PGSIZE          4096
char*
strcpy(char *s, const char *t)
{
    4720:	f3 0f 1e fb          	endbr32 
    4724:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4725:	31 c0                	xor    %eax,%eax
{
    4727:	89 e5                	mov    %esp,%ebp
    4729:	53                   	push   %ebx
    472a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    472d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    4730:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    4734:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    4737:	83 c0 01             	add    $0x1,%eax
    473a:	84 d2                	test   %dl,%dl
    473c:	75 f2                	jne    4730 <strcpy+0x10>
    ;
  return os;
}
    473e:	89 c8                	mov    %ecx,%eax
    4740:	5b                   	pop    %ebx
    4741:	5d                   	pop    %ebp
    4742:	c3                   	ret    
    4743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00004750 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4750:	f3 0f 1e fb          	endbr32 
    4754:	55                   	push   %ebp
    4755:	89 e5                	mov    %esp,%ebp
    4757:	53                   	push   %ebx
    4758:	8b 4d 08             	mov    0x8(%ebp),%ecx
    475b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    475e:	0f b6 01             	movzbl (%ecx),%eax
    4761:	0f b6 1a             	movzbl (%edx),%ebx
    4764:	84 c0                	test   %al,%al
    4766:	75 19                	jne    4781 <strcmp+0x31>
    4768:	eb 26                	jmp    4790 <strcmp+0x40>
    476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    4770:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    4774:	83 c1 01             	add    $0x1,%ecx
    4777:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    477a:	0f b6 1a             	movzbl (%edx),%ebx
    477d:	84 c0                	test   %al,%al
    477f:	74 0f                	je     4790 <strcmp+0x40>
    4781:	38 d8                	cmp    %bl,%al
    4783:	74 eb                	je     4770 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    4785:	29 d8                	sub    %ebx,%eax
}
    4787:	5b                   	pop    %ebx
    4788:	5d                   	pop    %ebp
    4789:	c3                   	ret    
    478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    4790:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    4792:	29 d8                	sub    %ebx,%eax
}
    4794:	5b                   	pop    %ebx
    4795:	5d                   	pop    %ebp
    4796:	c3                   	ret    
    4797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    479e:	66 90                	xchg   %ax,%ax

000047a0 <strlen>:

uint
strlen(const char *s)
{
    47a0:	f3 0f 1e fb          	endbr32 
    47a4:	55                   	push   %ebp
    47a5:	89 e5                	mov    %esp,%ebp
    47a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    47aa:	80 3a 00             	cmpb   $0x0,(%edx)
    47ad:	74 21                	je     47d0 <strlen+0x30>
    47af:	31 c0                	xor    %eax,%eax
    47b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    47b8:	83 c0 01             	add    $0x1,%eax
    47bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    47bf:	89 c1                	mov    %eax,%ecx
    47c1:	75 f5                	jne    47b8 <strlen+0x18>
    ;
  return n;
}
    47c3:	89 c8                	mov    %ecx,%eax
    47c5:	5d                   	pop    %ebp
    47c6:	c3                   	ret    
    47c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    47ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    47d0:	31 c9                	xor    %ecx,%ecx
}
    47d2:	5d                   	pop    %ebp
    47d3:	89 c8                	mov    %ecx,%eax
    47d5:	c3                   	ret    
    47d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    47dd:	8d 76 00             	lea    0x0(%esi),%esi

000047e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    47e0:	f3 0f 1e fb          	endbr32 
    47e4:	55                   	push   %ebp
    47e5:	89 e5                	mov    %esp,%ebp
    47e7:	57                   	push   %edi
    47e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    47eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    47ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    47f1:	89 d7                	mov    %edx,%edi
    47f3:	fc                   	cld    
    47f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    47f6:	89 d0                	mov    %edx,%eax
    47f8:	5f                   	pop    %edi
    47f9:	5d                   	pop    %ebp
    47fa:	c3                   	ret    
    47fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    47ff:	90                   	nop

00004800 <strchr>:

char*
strchr(const char *s, char c)
{
    4800:	f3 0f 1e fb          	endbr32 
    4804:	55                   	push   %ebp
    4805:	89 e5                	mov    %esp,%ebp
    4807:	8b 45 08             	mov    0x8(%ebp),%eax
    480a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    480e:	0f b6 10             	movzbl (%eax),%edx
    4811:	84 d2                	test   %dl,%dl
    4813:	75 16                	jne    482b <strchr+0x2b>
    4815:	eb 21                	jmp    4838 <strchr+0x38>
    4817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    481e:	66 90                	xchg   %ax,%ax
    4820:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    4824:	83 c0 01             	add    $0x1,%eax
    4827:	84 d2                	test   %dl,%dl
    4829:	74 0d                	je     4838 <strchr+0x38>
    if(*s == c)
    482b:	38 d1                	cmp    %dl,%cl
    482d:	75 f1                	jne    4820 <strchr+0x20>
      return (char*)s;
  return 0;
}
    482f:	5d                   	pop    %ebp
    4830:	c3                   	ret    
    4831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    4838:	31 c0                	xor    %eax,%eax
}
    483a:	5d                   	pop    %ebp
    483b:	c3                   	ret    
    483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00004840 <gets>:

char*
gets(char *buf, int max)
{
    4840:	f3 0f 1e fb          	endbr32 
    4844:	55                   	push   %ebp
    4845:	89 e5                	mov    %esp,%ebp
    4847:	57                   	push   %edi
    4848:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4849:	31 f6                	xor    %esi,%esi
{
    484b:	53                   	push   %ebx
    484c:	89 f3                	mov    %esi,%ebx
    484e:	83 ec 1c             	sub    $0x1c,%esp
    4851:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    4854:	eb 33                	jmp    4889 <gets+0x49>
    4856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    485d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    4860:	83 ec 04             	sub    $0x4,%esp
    4863:	8d 45 e7             	lea    -0x19(%ebp),%eax
    4866:	6a 01                	push   $0x1
    4868:	50                   	push   %eax
    4869:	6a 00                	push   $0x0
    486b:	e8 2b 01 00 00       	call   499b <read>
    if(cc < 1)
    4870:	83 c4 10             	add    $0x10,%esp
    4873:	85 c0                	test   %eax,%eax
    4875:	7e 1c                	jle    4893 <gets+0x53>
      break;
    buf[i++] = c;
    4877:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    487b:	83 c7 01             	add    $0x1,%edi
    487e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    4881:	3c 0a                	cmp    $0xa,%al
    4883:	74 23                	je     48a8 <gets+0x68>
    4885:	3c 0d                	cmp    $0xd,%al
    4887:	74 1f                	je     48a8 <gets+0x68>
  for(i=0; i+1 < max; ){
    4889:	83 c3 01             	add    $0x1,%ebx
    488c:	89 fe                	mov    %edi,%esi
    488e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    4891:	7c cd                	jl     4860 <gets+0x20>
    4893:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    4895:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    4898:	c6 03 00             	movb   $0x0,(%ebx)
}
    489b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    489e:	5b                   	pop    %ebx
    489f:	5e                   	pop    %esi
    48a0:	5f                   	pop    %edi
    48a1:	5d                   	pop    %ebp
    48a2:	c3                   	ret    
    48a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    48a7:	90                   	nop
    48a8:	8b 75 08             	mov    0x8(%ebp),%esi
    48ab:	8b 45 08             	mov    0x8(%ebp),%eax
    48ae:	01 de                	add    %ebx,%esi
    48b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    48b2:	c6 03 00             	movb   $0x0,(%ebx)
}
    48b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    48b8:	5b                   	pop    %ebx
    48b9:	5e                   	pop    %esi
    48ba:	5f                   	pop    %edi
    48bb:	5d                   	pop    %ebp
    48bc:	c3                   	ret    
    48bd:	8d 76 00             	lea    0x0(%esi),%esi

000048c0 <stat>:

int
stat(const char *n, struct stat *st)
{
    48c0:	f3 0f 1e fb          	endbr32 
    48c4:	55                   	push   %ebp
    48c5:	89 e5                	mov    %esp,%ebp
    48c7:	56                   	push   %esi
    48c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    48c9:	83 ec 08             	sub    $0x8,%esp
    48cc:	6a 00                	push   $0x0
    48ce:	ff 75 08             	pushl  0x8(%ebp)
    48d1:	e8 ed 00 00 00       	call   49c3 <open>
  if(fd < 0)
    48d6:	83 c4 10             	add    $0x10,%esp
    48d9:	85 c0                	test   %eax,%eax
    48db:	78 2b                	js     4908 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    48dd:	83 ec 08             	sub    $0x8,%esp
    48e0:	ff 75 0c             	pushl  0xc(%ebp)
    48e3:	89 c3                	mov    %eax,%ebx
    48e5:	50                   	push   %eax
    48e6:	e8 f0 00 00 00       	call   49db <fstat>
  close(fd);
    48eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    48ee:	89 c6                	mov    %eax,%esi
  close(fd);
    48f0:	e8 b6 00 00 00       	call   49ab <close>
  return r;
    48f5:	83 c4 10             	add    $0x10,%esp
}
    48f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    48fb:	89 f0                	mov    %esi,%eax
    48fd:	5b                   	pop    %ebx
    48fe:	5e                   	pop    %esi
    48ff:	5d                   	pop    %ebp
    4900:	c3                   	ret    
    4901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    4908:	be ff ff ff ff       	mov    $0xffffffff,%esi
    490d:	eb e9                	jmp    48f8 <stat+0x38>
    490f:	90                   	nop

00004910 <atoi>:

int
atoi(const char *s)
{
    4910:	f3 0f 1e fb          	endbr32 
    4914:	55                   	push   %ebp
    4915:	89 e5                	mov    %esp,%ebp
    4917:	53                   	push   %ebx
    4918:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    491b:	0f be 02             	movsbl (%edx),%eax
    491e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    4921:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    4924:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    4929:	77 1a                	ja     4945 <atoi+0x35>
    492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    492f:	90                   	nop
    n = n*10 + *s++ - '0';
    4930:	83 c2 01             	add    $0x1,%edx
    4933:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    4936:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    493a:	0f be 02             	movsbl (%edx),%eax
    493d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    4940:	80 fb 09             	cmp    $0x9,%bl
    4943:	76 eb                	jbe    4930 <atoi+0x20>
  return n;
}
    4945:	89 c8                	mov    %ecx,%eax
    4947:	5b                   	pop    %ebx
    4948:	5d                   	pop    %ebp
    4949:	c3                   	ret    
    494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00004950 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4950:	f3 0f 1e fb          	endbr32 
    4954:	55                   	push   %ebp
    4955:	89 e5                	mov    %esp,%ebp
    4957:	57                   	push   %edi
    4958:	8b 45 10             	mov    0x10(%ebp),%eax
    495b:	8b 55 08             	mov    0x8(%ebp),%edx
    495e:	56                   	push   %esi
    495f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4962:	85 c0                	test   %eax,%eax
    4964:	7e 0f                	jle    4975 <memmove+0x25>
    4966:	01 d0                	add    %edx,%eax
  dst = vdst;
    4968:	89 d7                	mov    %edx,%edi
    496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    4970:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    4971:	39 f8                	cmp    %edi,%eax
    4973:	75 fb                	jne    4970 <memmove+0x20>
  return vdst;
}
    4975:	5e                   	pop    %esi
    4976:	89 d0                	mov    %edx,%eax
    4978:	5f                   	pop    %edi
    4979:	5d                   	pop    %ebp
    497a:	c3                   	ret    

0000497b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    497b:	b8 01 00 00 00       	mov    $0x1,%eax
    4980:	cd 40                	int    $0x40
    4982:	c3                   	ret    

00004983 <exit>:
SYSCALL(exit)
    4983:	b8 02 00 00 00       	mov    $0x2,%eax
    4988:	cd 40                	int    $0x40
    498a:	c3                   	ret    

0000498b <wait>:
SYSCALL(wait)
    498b:	b8 03 00 00 00       	mov    $0x3,%eax
    4990:	cd 40                	int    $0x40
    4992:	c3                   	ret    

00004993 <pipe>:
SYSCALL(pipe)
    4993:	b8 04 00 00 00       	mov    $0x4,%eax
    4998:	cd 40                	int    $0x40
    499a:	c3                   	ret    

0000499b <read>:
SYSCALL(read)
    499b:	b8 05 00 00 00       	mov    $0x5,%eax
    49a0:	cd 40                	int    $0x40
    49a2:	c3                   	ret    

000049a3 <write>:
SYSCALL(write)
    49a3:	b8 10 00 00 00       	mov    $0x10,%eax
    49a8:	cd 40                	int    $0x40
    49aa:	c3                   	ret    

000049ab <close>:
SYSCALL(close)
    49ab:	b8 15 00 00 00       	mov    $0x15,%eax
    49b0:	cd 40                	int    $0x40
    49b2:	c3                   	ret    

000049b3 <kill>:
SYSCALL(kill)
    49b3:	b8 06 00 00 00       	mov    $0x6,%eax
    49b8:	cd 40                	int    $0x40
    49ba:	c3                   	ret    

000049bb <exec>:
SYSCALL(exec)
    49bb:	b8 07 00 00 00       	mov    $0x7,%eax
    49c0:	cd 40                	int    $0x40
    49c2:	c3                   	ret    

000049c3 <open>:
SYSCALL(open)
    49c3:	b8 0f 00 00 00       	mov    $0xf,%eax
    49c8:	cd 40                	int    $0x40
    49ca:	c3                   	ret    

000049cb <mknod>:
SYSCALL(mknod)
    49cb:	b8 11 00 00 00       	mov    $0x11,%eax
    49d0:	cd 40                	int    $0x40
    49d2:	c3                   	ret    

000049d3 <unlink>:
SYSCALL(unlink)
    49d3:	b8 12 00 00 00       	mov    $0x12,%eax
    49d8:	cd 40                	int    $0x40
    49da:	c3                   	ret    

000049db <fstat>:
SYSCALL(fstat)
    49db:	b8 08 00 00 00       	mov    $0x8,%eax
    49e0:	cd 40                	int    $0x40
    49e2:	c3                   	ret    

000049e3 <link>:
SYSCALL(link)
    49e3:	b8 13 00 00 00       	mov    $0x13,%eax
    49e8:	cd 40                	int    $0x40
    49ea:	c3                   	ret    

000049eb <mkdir>:
SYSCALL(mkdir)
    49eb:	b8 14 00 00 00       	mov    $0x14,%eax
    49f0:	cd 40                	int    $0x40
    49f2:	c3                   	ret    

000049f3 <chdir>:
SYSCALL(chdir)
    49f3:	b8 09 00 00 00       	mov    $0x9,%eax
    49f8:	cd 40                	int    $0x40
    49fa:	c3                   	ret    

000049fb <dup>:
SYSCALL(dup)
    49fb:	b8 0a 00 00 00       	mov    $0xa,%eax
    4a00:	cd 40                	int    $0x40
    4a02:	c3                   	ret    

00004a03 <getpid>:
SYSCALL(getpid)
    4a03:	b8 0b 00 00 00       	mov    $0xb,%eax
    4a08:	cd 40                	int    $0x40
    4a0a:	c3                   	ret    

00004a0b <sbrk>:
SYSCALL(sbrk)
    4a0b:	b8 0c 00 00 00       	mov    $0xc,%eax
    4a10:	cd 40                	int    $0x40
    4a12:	c3                   	ret    

00004a13 <sleep>:
SYSCALL(sleep)
    4a13:	b8 0d 00 00 00       	mov    $0xd,%eax
    4a18:	cd 40                	int    $0x40
    4a1a:	c3                   	ret    

00004a1b <uptime>:
SYSCALL(uptime)
    4a1b:	b8 0e 00 00 00       	mov    $0xe,%eax
    4a20:	cd 40                	int    $0x40
    4a22:	c3                   	ret    

00004a23 <provide_protection>:
SYSCALL(provide_protection)
    4a23:	b8 18 00 00 00       	mov    $0x18,%eax
    4a28:	cd 40                	int    $0x40
    4a2a:	c3                   	ret    

00004a2b <refuse_protection>:
SYSCALL(refuse_protection)
    4a2b:	b8 19 00 00 00       	mov    $0x19,%eax
    4a30:	cd 40                	int    $0x40
    4a32:	c3                   	ret    

00004a33 <settickets>:
SYSCALL(settickets) 
    4a33:	b8 16 00 00 00       	mov    $0x16,%eax
    4a38:	cd 40                	int    $0x40
    4a3a:	c3                   	ret    

00004a3b <getpinfo>:
    4a3b:	b8 17 00 00 00       	mov    $0x17,%eax
    4a40:	cd 40                	int    $0x40
    4a42:	c3                   	ret    
    4a43:	66 90                	xchg   %ax,%ax
    4a45:	66 90                	xchg   %ax,%ax
    4a47:	66 90                	xchg   %ax,%ax
    4a49:	66 90                	xchg   %ax,%ax
    4a4b:	66 90                	xchg   %ax,%ax
    4a4d:	66 90                	xchg   %ax,%ax
    4a4f:	90                   	nop

00004a50 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    4a50:	55                   	push   %ebp
    4a51:	89 e5                	mov    %esp,%ebp
    4a53:	57                   	push   %edi
    4a54:	56                   	push   %esi
    4a55:	53                   	push   %ebx
    4a56:	83 ec 3c             	sub    $0x3c,%esp
    4a59:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    4a5c:	89 d1                	mov    %edx,%ecx
{
    4a5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    4a61:	85 d2                	test   %edx,%edx
    4a63:	0f 89 7f 00 00 00    	jns    4ae8 <printint+0x98>
    4a69:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    4a6d:	74 79                	je     4ae8 <printint+0x98>
    neg = 1;
    4a6f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    4a76:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    4a78:	31 db                	xor    %ebx,%ebx
    4a7a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    4a7d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    4a80:	89 c8                	mov    %ecx,%eax
    4a82:	31 d2                	xor    %edx,%edx
    4a84:	89 cf                	mov    %ecx,%edi
    4a86:	f7 75 c4             	divl   -0x3c(%ebp)
    4a89:	0f b6 92 08 66 00 00 	movzbl 0x6608(%edx),%edx
    4a90:	89 45 c0             	mov    %eax,-0x40(%ebp)
    4a93:	89 d8                	mov    %ebx,%eax
    4a95:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    4a98:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    4a9b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    4a9e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    4aa1:	76 dd                	jbe    4a80 <printint+0x30>
  if(neg)
    4aa3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    4aa6:	85 c9                	test   %ecx,%ecx
    4aa8:	74 0c                	je     4ab6 <printint+0x66>
    buf[i++] = '-';
    4aaa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    4aaf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    4ab1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    4ab6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    4ab9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    4abd:	eb 07                	jmp    4ac6 <printint+0x76>
    4abf:	90                   	nop
    4ac0:	0f b6 13             	movzbl (%ebx),%edx
    4ac3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    4ac6:	83 ec 04             	sub    $0x4,%esp
    4ac9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    4acc:	6a 01                	push   $0x1
    4ace:	56                   	push   %esi
    4acf:	57                   	push   %edi
    4ad0:	e8 ce fe ff ff       	call   49a3 <write>
  while(--i >= 0)
    4ad5:	83 c4 10             	add    $0x10,%esp
    4ad8:	39 de                	cmp    %ebx,%esi
    4ada:	75 e4                	jne    4ac0 <printint+0x70>
    putc(fd, buf[i]);
}
    4adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4adf:	5b                   	pop    %ebx
    4ae0:	5e                   	pop    %esi
    4ae1:	5f                   	pop    %edi
    4ae2:	5d                   	pop    %ebp
    4ae3:	c3                   	ret    
    4ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    4ae8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    4aef:	eb 87                	jmp    4a78 <printint+0x28>
    4af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4aff:	90                   	nop

00004b00 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    4b00:	f3 0f 1e fb          	endbr32 
    4b04:	55                   	push   %ebp
    4b05:	89 e5                	mov    %esp,%ebp
    4b07:	57                   	push   %edi
    4b08:	56                   	push   %esi
    4b09:	53                   	push   %ebx
    4b0a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
    4b10:	0f b6 1e             	movzbl (%esi),%ebx
    4b13:	84 db                	test   %bl,%bl
    4b15:	0f 84 b4 00 00 00    	je     4bcf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    4b1b:	8d 45 10             	lea    0x10(%ebp),%eax
    4b1e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    4b21:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    4b24:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    4b26:	89 45 d0             	mov    %eax,-0x30(%ebp)
    4b29:	eb 33                	jmp    4b5e <printf+0x5e>
    4b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    4b2f:	90                   	nop
    4b30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    4b33:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    4b38:	83 f8 25             	cmp    $0x25,%eax
    4b3b:	74 17                	je     4b54 <printf+0x54>
  write(fd, &c, 1);
    4b3d:	83 ec 04             	sub    $0x4,%esp
    4b40:	88 5d e7             	mov    %bl,-0x19(%ebp)
    4b43:	6a 01                	push   $0x1
    4b45:	57                   	push   %edi
    4b46:	ff 75 08             	pushl  0x8(%ebp)
    4b49:	e8 55 fe ff ff       	call   49a3 <write>
    4b4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    4b51:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    4b54:	0f b6 1e             	movzbl (%esi),%ebx
    4b57:	83 c6 01             	add    $0x1,%esi
    4b5a:	84 db                	test   %bl,%bl
    4b5c:	74 71                	je     4bcf <printf+0xcf>
    c = fmt[i] & 0xff;
    4b5e:	0f be cb             	movsbl %bl,%ecx
    4b61:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    4b64:	85 d2                	test   %edx,%edx
    4b66:	74 c8                	je     4b30 <printf+0x30>
      }
    } else if(state == '%'){
    4b68:	83 fa 25             	cmp    $0x25,%edx
    4b6b:	75 e7                	jne    4b54 <printf+0x54>
      if(c == 'd'){
    4b6d:	83 f8 64             	cmp    $0x64,%eax
    4b70:	0f 84 9a 00 00 00    	je     4c10 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    4b76:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    4b7c:	83 f9 70             	cmp    $0x70,%ecx
    4b7f:	74 5f                	je     4be0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    4b81:	83 f8 73             	cmp    $0x73,%eax
    4b84:	0f 84 d6 00 00 00    	je     4c60 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4b8a:	83 f8 63             	cmp    $0x63,%eax
    4b8d:	0f 84 8d 00 00 00    	je     4c20 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    4b93:	83 f8 25             	cmp    $0x25,%eax
    4b96:	0f 84 b4 00 00 00    	je     4c50 <printf+0x150>
  write(fd, &c, 1);
    4b9c:	83 ec 04             	sub    $0x4,%esp
    4b9f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    4ba3:	6a 01                	push   $0x1
    4ba5:	57                   	push   %edi
    4ba6:	ff 75 08             	pushl  0x8(%ebp)
    4ba9:	e8 f5 fd ff ff       	call   49a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    4bae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    4bb1:	83 c4 0c             	add    $0xc,%esp
    4bb4:	6a 01                	push   $0x1
    4bb6:	83 c6 01             	add    $0x1,%esi
    4bb9:	57                   	push   %edi
    4bba:	ff 75 08             	pushl  0x8(%ebp)
    4bbd:	e8 e1 fd ff ff       	call   49a3 <write>
  for(i = 0; fmt[i]; i++){
    4bc2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    4bc6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    4bc9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    4bcb:	84 db                	test   %bl,%bl
    4bcd:	75 8f                	jne    4b5e <printf+0x5e>
    }
  }
}
    4bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4bd2:	5b                   	pop    %ebx
    4bd3:	5e                   	pop    %esi
    4bd4:	5f                   	pop    %edi
    4bd5:	5d                   	pop    %ebp
    4bd6:	c3                   	ret    
    4bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4bde:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    4be0:	83 ec 0c             	sub    $0xc,%esp
    4be3:	b9 10 00 00 00       	mov    $0x10,%ecx
    4be8:	6a 00                	push   $0x0
    4bea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    4bed:	8b 45 08             	mov    0x8(%ebp),%eax
    4bf0:	8b 13                	mov    (%ebx),%edx
    4bf2:	e8 59 fe ff ff       	call   4a50 <printint>
        ap++;
    4bf7:	89 d8                	mov    %ebx,%eax
    4bf9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    4bfc:	31 d2                	xor    %edx,%edx
        ap++;
    4bfe:	83 c0 04             	add    $0x4,%eax
    4c01:	89 45 d0             	mov    %eax,-0x30(%ebp)
    4c04:	e9 4b ff ff ff       	jmp    4b54 <printf+0x54>
    4c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    4c10:	83 ec 0c             	sub    $0xc,%esp
    4c13:	b9 0a 00 00 00       	mov    $0xa,%ecx
    4c18:	6a 01                	push   $0x1
    4c1a:	eb ce                	jmp    4bea <printf+0xea>
    4c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    4c20:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    4c23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    4c26:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    4c28:	6a 01                	push   $0x1
        ap++;
    4c2a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    4c2d:	57                   	push   %edi
    4c2e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    4c31:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    4c34:	e8 6a fd ff ff       	call   49a3 <write>
        ap++;
    4c39:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    4c3c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    4c3f:	31 d2                	xor    %edx,%edx
    4c41:	e9 0e ff ff ff       	jmp    4b54 <printf+0x54>
    4c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4c4d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    4c50:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    4c53:	83 ec 04             	sub    $0x4,%esp
    4c56:	e9 59 ff ff ff       	jmp    4bb4 <printf+0xb4>
    4c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    4c5f:	90                   	nop
        s = (char*)*ap;
    4c60:	8b 45 d0             	mov    -0x30(%ebp),%eax
    4c63:	8b 18                	mov    (%eax),%ebx
        ap++;
    4c65:	83 c0 04             	add    $0x4,%eax
    4c68:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    4c6b:	85 db                	test   %ebx,%ebx
    4c6d:	74 17                	je     4c86 <printf+0x186>
        while(*s != 0){
    4c6f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    4c72:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    4c74:	84 c0                	test   %al,%al
    4c76:	0f 84 d8 fe ff ff    	je     4b54 <printf+0x54>
    4c7c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    4c7f:	89 de                	mov    %ebx,%esi
    4c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
    4c84:	eb 1a                	jmp    4ca0 <printf+0x1a0>
          s = "(null)";
    4c86:	bb fe 65 00 00       	mov    $0x65fe,%ebx
        while(*s != 0){
    4c8b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    4c8e:	b8 28 00 00 00       	mov    $0x28,%eax
    4c93:	89 de                	mov    %ebx,%esi
    4c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    4c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4c9f:	90                   	nop
  write(fd, &c, 1);
    4ca0:	83 ec 04             	sub    $0x4,%esp
          s++;
    4ca3:	83 c6 01             	add    $0x1,%esi
    4ca6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    4ca9:	6a 01                	push   $0x1
    4cab:	57                   	push   %edi
    4cac:	53                   	push   %ebx
    4cad:	e8 f1 fc ff ff       	call   49a3 <write>
        while(*s != 0){
    4cb2:	0f b6 06             	movzbl (%esi),%eax
    4cb5:	83 c4 10             	add    $0x10,%esp
    4cb8:	84 c0                	test   %al,%al
    4cba:	75 e4                	jne    4ca0 <printf+0x1a0>
    4cbc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    4cbf:	31 d2                	xor    %edx,%edx
    4cc1:	e9 8e fe ff ff       	jmp    4b54 <printf+0x54>
    4cc6:	66 90                	xchg   %ax,%ax
    4cc8:	66 90                	xchg   %ax,%ax
    4cca:	66 90                	xchg   %ax,%ax
    4ccc:	66 90                	xchg   %ax,%ax
    4cce:	66 90                	xchg   %ax,%ax

00004cd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4cd0:	f3 0f 1e fb          	endbr32 
    4cd4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4cd5:	a1 a0 6f 00 00       	mov    0x6fa0,%eax
{
    4cda:	89 e5                	mov    %esp,%ebp
    4cdc:	57                   	push   %edi
    4cdd:	56                   	push   %esi
    4cde:	53                   	push   %ebx
    4cdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    4ce2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    4ce4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4ce7:	39 c8                	cmp    %ecx,%eax
    4ce9:	73 15                	jae    4d00 <free+0x30>
    4ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    4cef:	90                   	nop
    4cf0:	39 d1                	cmp    %edx,%ecx
    4cf2:	72 14                	jb     4d08 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4cf4:	39 d0                	cmp    %edx,%eax
    4cf6:	73 10                	jae    4d08 <free+0x38>
{
    4cf8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4cfa:	8b 10                	mov    (%eax),%edx
    4cfc:	39 c8                	cmp    %ecx,%eax
    4cfe:	72 f0                	jb     4cf0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4d00:	39 d0                	cmp    %edx,%eax
    4d02:	72 f4                	jb     4cf8 <free+0x28>
    4d04:	39 d1                	cmp    %edx,%ecx
    4d06:	73 f0                	jae    4cf8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    4d08:	8b 73 fc             	mov    -0x4(%ebx),%esi
    4d0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    4d0e:	39 fa                	cmp    %edi,%edx
    4d10:	74 1e                	je     4d30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    4d12:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    4d15:	8b 50 04             	mov    0x4(%eax),%edx
    4d18:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    4d1b:	39 f1                	cmp    %esi,%ecx
    4d1d:	74 28                	je     4d47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    4d1f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    4d21:	5b                   	pop    %ebx
  freep = p;
    4d22:	a3 a0 6f 00 00       	mov    %eax,0x6fa0
}
    4d27:	5e                   	pop    %esi
    4d28:	5f                   	pop    %edi
    4d29:	5d                   	pop    %ebp
    4d2a:	c3                   	ret    
    4d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    4d2f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    4d30:	03 72 04             	add    0x4(%edx),%esi
    4d33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    4d36:	8b 10                	mov    (%eax),%edx
    4d38:	8b 12                	mov    (%edx),%edx
    4d3a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    4d3d:	8b 50 04             	mov    0x4(%eax),%edx
    4d40:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    4d43:	39 f1                	cmp    %esi,%ecx
    4d45:	75 d8                	jne    4d1f <free+0x4f>
    p->s.size += bp->s.size;
    4d47:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    4d4a:	a3 a0 6f 00 00       	mov    %eax,0x6fa0
    p->s.size += bp->s.size;
    4d4f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4d52:	8b 53 f8             	mov    -0x8(%ebx),%edx
    4d55:	89 10                	mov    %edx,(%eax)
}
    4d57:	5b                   	pop    %ebx
    4d58:	5e                   	pop    %esi
    4d59:	5f                   	pop    %edi
    4d5a:	5d                   	pop    %ebp
    4d5b:	c3                   	ret    
    4d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00004d60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4d60:	f3 0f 1e fb          	endbr32 
    4d64:	55                   	push   %ebp
    4d65:	89 e5                	mov    %esp,%ebp
    4d67:	57                   	push   %edi
    4d68:	56                   	push   %esi
    4d69:	53                   	push   %ebx
    4d6a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    4d70:	8b 3d a0 6f 00 00    	mov    0x6fa0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4d76:	8d 70 07             	lea    0x7(%eax),%esi
    4d79:	c1 ee 03             	shr    $0x3,%esi
    4d7c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    4d7f:	85 ff                	test   %edi,%edi
    4d81:	0f 84 a9 00 00 00    	je     4e30 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4d87:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    4d89:	8b 48 04             	mov    0x4(%eax),%ecx
    4d8c:	39 f1                	cmp    %esi,%ecx
    4d8e:	73 6d                	jae    4dfd <malloc+0x9d>
    4d90:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    4d96:	bb 00 10 00 00       	mov    $0x1000,%ebx
    4d9b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    4d9e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    4da5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    4da8:	eb 17                	jmp    4dc1 <malloc+0x61>
    4daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4db0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    4db2:	8b 4a 04             	mov    0x4(%edx),%ecx
    4db5:	39 f1                	cmp    %esi,%ecx
    4db7:	73 4f                	jae    4e08 <malloc+0xa8>
    4db9:	8b 3d a0 6f 00 00    	mov    0x6fa0,%edi
    4dbf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4dc1:	39 c7                	cmp    %eax,%edi
    4dc3:	75 eb                	jne    4db0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    4dc5:	83 ec 0c             	sub    $0xc,%esp
    4dc8:	ff 75 e4             	pushl  -0x1c(%ebp)
    4dcb:	e8 3b fc ff ff       	call   4a0b <sbrk>
  if(p == (char*)-1)
    4dd0:	83 c4 10             	add    $0x10,%esp
    4dd3:	83 f8 ff             	cmp    $0xffffffff,%eax
    4dd6:	74 1b                	je     4df3 <malloc+0x93>
  hp->s.size = nu;
    4dd8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    4ddb:	83 ec 0c             	sub    $0xc,%esp
    4dde:	83 c0 08             	add    $0x8,%eax
    4de1:	50                   	push   %eax
    4de2:	e8 e9 fe ff ff       	call   4cd0 <free>
  return freep;
    4de7:	a1 a0 6f 00 00       	mov    0x6fa0,%eax
      if((p = morecore(nunits)) == 0)
    4dec:	83 c4 10             	add    $0x10,%esp
    4def:	85 c0                	test   %eax,%eax
    4df1:	75 bd                	jne    4db0 <malloc+0x50>
        return 0;
  }
}
    4df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    4df6:	31 c0                	xor    %eax,%eax
}
    4df8:	5b                   	pop    %ebx
    4df9:	5e                   	pop    %esi
    4dfa:	5f                   	pop    %edi
    4dfb:	5d                   	pop    %ebp
    4dfc:	c3                   	ret    
    if(p->s.size >= nunits){
    4dfd:	89 c2                	mov    %eax,%edx
    4dff:	89 f8                	mov    %edi,%eax
    4e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    4e08:	39 ce                	cmp    %ecx,%esi
    4e0a:	74 54                	je     4e60 <malloc+0x100>
        p->s.size -= nunits;
    4e0c:	29 f1                	sub    %esi,%ecx
    4e0e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    4e11:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    4e14:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    4e17:	a3 a0 6f 00 00       	mov    %eax,0x6fa0
}
    4e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    4e1f:	8d 42 08             	lea    0x8(%edx),%eax
}
    4e22:	5b                   	pop    %ebx
    4e23:	5e                   	pop    %esi
    4e24:	5f                   	pop    %edi
    4e25:	5d                   	pop    %ebp
    4e26:	c3                   	ret    
    4e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    4e2e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    4e30:	c7 05 a0 6f 00 00 a4 	movl   $0x6fa4,0x6fa0
    4e37:	6f 00 00 
    base.s.size = 0;
    4e3a:	bf a4 6f 00 00       	mov    $0x6fa4,%edi
    base.s.ptr = freep = prevp = &base;
    4e3f:	c7 05 a4 6f 00 00 a4 	movl   $0x6fa4,0x6fa4
    4e46:	6f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4e49:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    4e4b:	c7 05 a8 6f 00 00 00 	movl   $0x0,0x6fa8
    4e52:	00 00 00 
    if(p->s.size >= nunits){
    4e55:	e9 36 ff ff ff       	jmp    4d90 <malloc+0x30>
    4e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    4e60:	8b 0a                	mov    (%edx),%ecx
    4e62:	89 08                	mov    %ecx,(%eax)
    4e64:	eb b1                	jmp    4e17 <malloc+0xb7>
