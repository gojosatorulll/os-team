
obj/__user_badarg.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a285                	j	800184 <sys_open>

0000000000800026 <close>:
  800026:	a2a5                	j	80018e <sys_close>

0000000000800028 <dup2>:
  800028:	a2bd                	j	800196 <sys_dup>

000000000080002a <_start>:
  80002a:	1d4000ef          	jal	8001fe <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	74a50513          	addi	a0,a0,1866 # 800788 <main+0xf0>
  800046:	ec06                	sd	ra,24(sp)
  800048:	f436                	sd	a3,40(sp)
  80004a:	f83a                	sd	a4,48(sp)
  80004c:	fc3e                	sd	a5,56(sp)
  80004e:	e0c2                	sd	a6,64(sp)
  800050:	e4c6                	sd	a7,72(sp)
  800052:	e41a                	sd	t1,8(sp)
  800054:	0a0000ef          	jal	8000f4 <cprintf>
  800058:	65a2                	ld	a1,8(sp)
  80005a:	8522                	mv	a0,s0
  80005c:	072000ef          	jal	8000ce <vcprintf>
  800060:	00000517          	auipc	a0,0x0
  800064:	74850513          	addi	a0,a0,1864 # 8007a8 <main+0x110>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	132000ef          	jal	8001a0 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	73050513          	addi	a0,a0,1840 # 8007b0 <main+0x118>
  800088:	ec06                	sd	ra,24(sp)
  80008a:	f436                	sd	a3,40(sp)
  80008c:	f83a                	sd	a4,48(sp)
  80008e:	fc3e                	sd	a5,56(sp)
  800090:	e0c2                	sd	a6,64(sp)
  800092:	e4c6                	sd	a7,72(sp)
  800094:	e41a                	sd	t1,8(sp)
  800096:	05e000ef          	jal	8000f4 <cprintf>
  80009a:	65a2                	ld	a1,8(sp)
  80009c:	8522                	mv	a0,s0
  80009e:	030000ef          	jal	8000ce <vcprintf>
  8000a2:	00000517          	auipc	a0,0x0
  8000a6:	70650513          	addi	a0,a0,1798 # 8007a8 <main+0x110>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0c2000ef          	jal	80017e <sys_putc>
  8000c0:	65a2                	ld	a1,8(sp)
  8000c2:	60e2                	ld	ra,24(sp)
  8000c4:	419c                	lw	a5,0(a1)
  8000c6:	2785                	addiw	a5,a5,1
  8000c8:	c19c                	sw	a5,0(a1)
  8000ca:	6105                	addi	sp,sp,32
  8000cc:	8082                	ret

00000000008000ce <vcprintf>:
  8000ce:	1101                	addi	sp,sp,-32
  8000d0:	872e                	mv	a4,a1
  8000d2:	75dd                	lui	a1,0xffff7
  8000d4:	86aa                	mv	a3,a0
  8000d6:	0070                	addi	a2,sp,12
  8000d8:	00000517          	auipc	a0,0x0
  8000dc:	fde50513          	addi	a0,a0,-34 # 8000b6 <cputch>
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e59>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	1fa000ef          	jal	8002e2 <vprintfmt>
  8000ec:	60e2                	ld	ra,24(sp)
  8000ee:	4532                	lw	a0,12(sp)
  8000f0:	6105                	addi	sp,sp,32
  8000f2:	8082                	ret

00000000008000f4 <cprintf>:
  8000f4:	711d                	addi	sp,sp,-96
  8000f6:	02810313          	addi	t1,sp,40
  8000fa:	f42e                	sd	a1,40(sp)
  8000fc:	75dd                	lui	a1,0xffff7
  8000fe:	f832                	sd	a2,48(sp)
  800100:	fc36                	sd	a3,56(sp)
  800102:	e0ba                	sd	a4,64(sp)
  800104:	86aa                	mv	a3,a0
  800106:	0050                	addi	a2,sp,4
  800108:	00000517          	auipc	a0,0x0
  80010c:	fae50513          	addi	a0,a0,-82 # 8000b6 <cputch>
  800110:	871a                	mv	a4,t1
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e59>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1c0000ef          	jal	8002e2 <vprintfmt>
  800126:	60e2                	ld	ra,24(sp)
  800128:	4512                	lw	a0,4(sp)
  80012a:	6125                	addi	sp,sp,96
  80012c:	8082                	ret

000000000080012e <syscall>:
  80012e:	7175                	addi	sp,sp,-144
  800130:	08010313          	addi	t1,sp,128
  800134:	e42a                	sd	a0,8(sp)
  800136:	ecae                	sd	a1,88(sp)
  800138:	f42e                	sd	a1,40(sp)
  80013a:	f0b2                	sd	a2,96(sp)
  80013c:	f832                	sd	a2,48(sp)
  80013e:	f4b6                	sd	a3,104(sp)
  800140:	fc36                	sd	a3,56(sp)
  800142:	f8ba                	sd	a4,112(sp)
  800144:	e0ba                	sd	a4,64(sp)
  800146:	fcbe                	sd	a5,120(sp)
  800148:	e4be                	sd	a5,72(sp)
  80014a:	e142                	sd	a6,128(sp)
  80014c:	e546                	sd	a7,136(sp)
  80014e:	f01a                	sd	t1,32(sp)
  800150:	4522                	lw	a0,8(sp)
  800152:	55a2                	lw	a1,40(sp)
  800154:	5642                	lw	a2,48(sp)
  800156:	56e2                	lw	a3,56(sp)
  800158:	4706                	lw	a4,64(sp)
  80015a:	47a6                	lw	a5,72(sp)
  80015c:	00000073          	ecall
  800160:	ce2a                	sw	a0,28(sp)
  800162:	4572                	lw	a0,28(sp)
  800164:	6149                	addi	sp,sp,144
  800166:	8082                	ret

0000000000800168 <sys_exit>:
  800168:	85aa                	mv	a1,a0
  80016a:	4505                	li	a0,1
  80016c:	b7c9                	j	80012e <syscall>

000000000080016e <sys_fork>:
  80016e:	4509                	li	a0,2
  800170:	bf7d                	j	80012e <syscall>

0000000000800172 <sys_wait>:
  800172:	862e                	mv	a2,a1
  800174:	85aa                	mv	a1,a0
  800176:	450d                	li	a0,3
  800178:	bf5d                	j	80012e <syscall>

000000000080017a <sys_yield>:
  80017a:	4529                	li	a0,10
  80017c:	bf4d                	j	80012e <syscall>

000000000080017e <sys_putc>:
  80017e:	85aa                	mv	a1,a0
  800180:	4579                	li	a0,30
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_open>:
  800184:	862e                	mv	a2,a1
  800186:	85aa                	mv	a1,a0
  800188:	06400513          	li	a0,100
  80018c:	b74d                	j	80012e <syscall>

000000000080018e <sys_close>:
  80018e:	85aa                	mv	a1,a0
  800190:	06500513          	li	a0,101
  800194:	bf69                	j	80012e <syscall>

0000000000800196 <sys_dup>:
  800196:	862e                	mv	a2,a1
  800198:	85aa                	mv	a1,a0
  80019a:	08200513          	li	a0,130
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <exit>:
  8001a0:	1141                	addi	sp,sp,-16
  8001a2:	e406                	sd	ra,8(sp)
  8001a4:	fc5ff0ef          	jal	800168 <sys_exit>
  8001a8:	00000517          	auipc	a0,0x0
  8001ac:	62850513          	addi	a0,a0,1576 # 8007d0 <main+0x138>
  8001b0:	f45ff0ef          	jal	8000f4 <cprintf>
  8001b4:	a001                	j	8001b4 <exit+0x14>

00000000008001b6 <fork>:
  8001b6:	bf65                	j	80016e <sys_fork>

00000000008001b8 <waitpid>:
  8001b8:	bf6d                	j	800172 <sys_wait>

00000000008001ba <yield>:
  8001ba:	b7c1                	j	80017a <sys_yield>

00000000008001bc <initfd>:
  8001bc:	87ae                	mv	a5,a1
  8001be:	1101                	addi	sp,sp,-32
  8001c0:	e822                	sd	s0,16(sp)
  8001c2:	85b2                	mv	a1,a2
  8001c4:	842a                	mv	s0,a0
  8001c6:	853e                	mv	a0,a5
  8001c8:	ec06                	sd	ra,24(sp)
  8001ca:	e57ff0ef          	jal	800020 <open>
  8001ce:	87aa                	mv	a5,a0
  8001d0:	00054463          	bltz	a0,8001d8 <initfd+0x1c>
  8001d4:	00851763          	bne	a0,s0,8001e2 <initfd+0x26>
  8001d8:	60e2                	ld	ra,24(sp)
  8001da:	6442                	ld	s0,16(sp)
  8001dc:	853e                	mv	a0,a5
  8001de:	6105                	addi	sp,sp,32
  8001e0:	8082                	ret
  8001e2:	e42a                	sd	a0,8(sp)
  8001e4:	8522                	mv	a0,s0
  8001e6:	e41ff0ef          	jal	800026 <close>
  8001ea:	6522                	ld	a0,8(sp)
  8001ec:	85a2                	mv	a1,s0
  8001ee:	e3bff0ef          	jal	800028 <dup2>
  8001f2:	842a                	mv	s0,a0
  8001f4:	6522                	ld	a0,8(sp)
  8001f6:	e31ff0ef          	jal	800026 <close>
  8001fa:	87a2                	mv	a5,s0
  8001fc:	bff1                	j	8001d8 <initfd+0x1c>

00000000008001fe <umain>:
  8001fe:	1101                	addi	sp,sp,-32
  800200:	e822                	sd	s0,16(sp)
  800202:	e426                	sd	s1,8(sp)
  800204:	842a                	mv	s0,a0
  800206:	84ae                	mv	s1,a1
  800208:	4601                	li	a2,0
  80020a:	00000597          	auipc	a1,0x0
  80020e:	5de58593          	addi	a1,a1,1502 # 8007e8 <main+0x150>
  800212:	4501                	li	a0,0
  800214:	ec06                	sd	ra,24(sp)
  800216:	fa7ff0ef          	jal	8001bc <initfd>
  80021a:	02054263          	bltz	a0,80023e <umain+0x40>
  80021e:	4605                	li	a2,1
  800220:	8532                	mv	a0,a2
  800222:	00000597          	auipc	a1,0x0
  800226:	60658593          	addi	a1,a1,1542 # 800828 <main+0x190>
  80022a:	f93ff0ef          	jal	8001bc <initfd>
  80022e:	02054563          	bltz	a0,800258 <umain+0x5a>
  800232:	85a6                	mv	a1,s1
  800234:	8522                	mv	a0,s0
  800236:	462000ef          	jal	800698 <main>
  80023a:	f67ff0ef          	jal	8001a0 <exit>
  80023e:	86aa                	mv	a3,a0
  800240:	00000617          	auipc	a2,0x0
  800244:	5b060613          	addi	a2,a2,1456 # 8007f0 <main+0x158>
  800248:	45e9                	li	a1,26
  80024a:	00000517          	auipc	a0,0x0
  80024e:	5c650513          	addi	a0,a0,1478 # 800810 <main+0x178>
  800252:	e21ff0ef          	jal	800072 <__warn>
  800256:	b7e1                	j	80021e <umain+0x20>
  800258:	86aa                	mv	a3,a0
  80025a:	00000617          	auipc	a2,0x0
  80025e:	5d660613          	addi	a2,a2,1494 # 800830 <main+0x198>
  800262:	45f5                	li	a1,29
  800264:	00000517          	auipc	a0,0x0
  800268:	5ac50513          	addi	a0,a0,1452 # 800810 <main+0x178>
  80026c:	e07ff0ef          	jal	800072 <__warn>
  800270:	b7c9                	j	800232 <umain+0x34>

0000000000800272 <printnum>:
  800272:	7139                	addi	sp,sp,-64
  800274:	02071893          	slli	a7,a4,0x20
  800278:	f822                	sd	s0,48(sp)
  80027a:	f426                	sd	s1,40(sp)
  80027c:	f04a                	sd	s2,32(sp)
  80027e:	ec4e                	sd	s3,24(sp)
  800280:	e456                	sd	s5,8(sp)
  800282:	0208d893          	srli	a7,a7,0x20
  800286:	fc06                	sd	ra,56(sp)
  800288:	0316fab3          	remu	s5,a3,a7
  80028c:	fff7841b          	addiw	s0,a5,-1
  800290:	84aa                	mv	s1,a0
  800292:	89ae                	mv	s3,a1
  800294:	8932                	mv	s2,a2
  800296:	0516f063          	bgeu	a3,a7,8002d6 <printnum+0x64>
  80029a:	e852                	sd	s4,16(sp)
  80029c:	4705                	li	a4,1
  80029e:	8a42                	mv	s4,a6
  8002a0:	00f75863          	bge	a4,a5,8002b0 <printnum+0x3e>
  8002a4:	864e                	mv	a2,s3
  8002a6:	85ca                	mv	a1,s2
  8002a8:	8552                	mv	a0,s4
  8002aa:	347d                	addiw	s0,s0,-1
  8002ac:	9482                	jalr	s1
  8002ae:	f87d                	bnez	s0,8002a4 <printnum+0x32>
  8002b0:	6a42                	ld	s4,16(sp)
  8002b2:	00000797          	auipc	a5,0x0
  8002b6:	59e78793          	addi	a5,a5,1438 # 800850 <main+0x1b8>
  8002ba:	97d6                	add	a5,a5,s5
  8002bc:	7442                	ld	s0,48(sp)
  8002be:	0007c503          	lbu	a0,0(a5)
  8002c2:	70e2                	ld	ra,56(sp)
  8002c4:	6aa2                	ld	s5,8(sp)
  8002c6:	864e                	mv	a2,s3
  8002c8:	85ca                	mv	a1,s2
  8002ca:	69e2                	ld	s3,24(sp)
  8002cc:	7902                	ld	s2,32(sp)
  8002ce:	87a6                	mv	a5,s1
  8002d0:	74a2                	ld	s1,40(sp)
  8002d2:	6121                	addi	sp,sp,64
  8002d4:	8782                	jr	a5
  8002d6:	0316d6b3          	divu	a3,a3,a7
  8002da:	87a2                	mv	a5,s0
  8002dc:	f97ff0ef          	jal	800272 <printnum>
  8002e0:	bfc9                	j	8002b2 <printnum+0x40>

00000000008002e2 <vprintfmt>:
  8002e2:	7119                	addi	sp,sp,-128
  8002e4:	f4a6                	sd	s1,104(sp)
  8002e6:	f0ca                	sd	s2,96(sp)
  8002e8:	ecce                	sd	s3,88(sp)
  8002ea:	e8d2                	sd	s4,80(sp)
  8002ec:	e4d6                	sd	s5,72(sp)
  8002ee:	e0da                	sd	s6,64(sp)
  8002f0:	fc5e                	sd	s7,56(sp)
  8002f2:	f466                	sd	s9,40(sp)
  8002f4:	fc86                	sd	ra,120(sp)
  8002f6:	f8a2                	sd	s0,112(sp)
  8002f8:	f862                	sd	s8,48(sp)
  8002fa:	f06a                	sd	s10,32(sp)
  8002fc:	ec6e                	sd	s11,24(sp)
  8002fe:	84aa                	mv	s1,a0
  800300:	8cb6                	mv	s9,a3
  800302:	8aba                	mv	s5,a4
  800304:	89ae                	mv	s3,a1
  800306:	8932                	mv	s2,a2
  800308:	02500a13          	li	s4,37
  80030c:	05500b93          	li	s7,85
  800310:	00001b17          	auipc	s6,0x1
  800314:	818b0b13          	addi	s6,s6,-2024 # 800b28 <main+0x490>
  800318:	000cc503          	lbu	a0,0(s9)
  80031c:	001c8413          	addi	s0,s9,1
  800320:	01450b63          	beq	a0,s4,800336 <vprintfmt+0x54>
  800324:	cd15                	beqz	a0,800360 <vprintfmt+0x7e>
  800326:	864e                	mv	a2,s3
  800328:	85ca                	mv	a1,s2
  80032a:	9482                	jalr	s1
  80032c:	00044503          	lbu	a0,0(s0)
  800330:	0405                	addi	s0,s0,1
  800332:	ff4519e3          	bne	a0,s4,800324 <vprintfmt+0x42>
  800336:	5d7d                	li	s10,-1
  800338:	8dea                	mv	s11,s10
  80033a:	02000813          	li	a6,32
  80033e:	4c01                	li	s8,0
  800340:	4581                	li	a1,0
  800342:	00044703          	lbu	a4,0(s0)
  800346:	00140c93          	addi	s9,s0,1
  80034a:	fdd7061b          	addiw	a2,a4,-35
  80034e:	0ff67613          	zext.b	a2,a2
  800352:	02cbe663          	bltu	s7,a2,80037e <vprintfmt+0x9c>
  800356:	060a                	slli	a2,a2,0x2
  800358:	965a                	add	a2,a2,s6
  80035a:	421c                	lw	a5,0(a2)
  80035c:	97da                	add	a5,a5,s6
  80035e:	8782                	jr	a5
  800360:	70e6                	ld	ra,120(sp)
  800362:	7446                	ld	s0,112(sp)
  800364:	74a6                	ld	s1,104(sp)
  800366:	7906                	ld	s2,96(sp)
  800368:	69e6                	ld	s3,88(sp)
  80036a:	6a46                	ld	s4,80(sp)
  80036c:	6aa6                	ld	s5,72(sp)
  80036e:	6b06                	ld	s6,64(sp)
  800370:	7be2                	ld	s7,56(sp)
  800372:	7c42                	ld	s8,48(sp)
  800374:	7ca2                	ld	s9,40(sp)
  800376:	7d02                	ld	s10,32(sp)
  800378:	6de2                	ld	s11,24(sp)
  80037a:	6109                	addi	sp,sp,128
  80037c:	8082                	ret
  80037e:	864e                	mv	a2,s3
  800380:	85ca                	mv	a1,s2
  800382:	02500513          	li	a0,37
  800386:	9482                	jalr	s1
  800388:	fff44783          	lbu	a5,-1(s0)
  80038c:	02500713          	li	a4,37
  800390:	8ca2                	mv	s9,s0
  800392:	f8e783e3          	beq	a5,a4,800318 <vprintfmt+0x36>
  800396:	ffecc783          	lbu	a5,-2(s9)
  80039a:	1cfd                	addi	s9,s9,-1
  80039c:	fee79de3          	bne	a5,a4,800396 <vprintfmt+0xb4>
  8003a0:	bfa5                	j	800318 <vprintfmt+0x36>
  8003a2:	00144683          	lbu	a3,1(s0)
  8003a6:	4525                	li	a0,9
  8003a8:	fd070d1b          	addiw	s10,a4,-48
  8003ac:	fd06879b          	addiw	a5,a3,-48
  8003b0:	28f56063          	bltu	a0,a5,800630 <vprintfmt+0x34e>
  8003b4:	2681                	sext.w	a3,a3
  8003b6:	8466                	mv	s0,s9
  8003b8:	002d179b          	slliw	a5,s10,0x2
  8003bc:	00144703          	lbu	a4,1(s0)
  8003c0:	01a787bb          	addw	a5,a5,s10
  8003c4:	0017979b          	slliw	a5,a5,0x1
  8003c8:	9fb5                	addw	a5,a5,a3
  8003ca:	fd07061b          	addiw	a2,a4,-48
  8003ce:	0405                	addi	s0,s0,1
  8003d0:	fd078d1b          	addiw	s10,a5,-48
  8003d4:	0007069b          	sext.w	a3,a4
  8003d8:	fec570e3          	bgeu	a0,a2,8003b8 <vprintfmt+0xd6>
  8003dc:	f60dd3e3          	bgez	s11,800342 <vprintfmt+0x60>
  8003e0:	8dea                	mv	s11,s10
  8003e2:	5d7d                	li	s10,-1
  8003e4:	bfb9                	j	800342 <vprintfmt+0x60>
  8003e6:	883a                	mv	a6,a4
  8003e8:	8466                	mv	s0,s9
  8003ea:	bfa1                	j	800342 <vprintfmt+0x60>
  8003ec:	8466                	mv	s0,s9
  8003ee:	4c05                	li	s8,1
  8003f0:	bf89                	j	800342 <vprintfmt+0x60>
  8003f2:	4785                	li	a5,1
  8003f4:	008a8613          	addi	a2,s5,8
  8003f8:	00b7c463          	blt	a5,a1,800400 <vprintfmt+0x11e>
  8003fc:	1c058363          	beqz	a1,8005c2 <vprintfmt+0x2e0>
  800400:	000ab683          	ld	a3,0(s5)
  800404:	4741                	li	a4,16
  800406:	8ab2                	mv	s5,a2
  800408:	2801                	sext.w	a6,a6
  80040a:	87ee                	mv	a5,s11
  80040c:	864a                	mv	a2,s2
  80040e:	85ce                	mv	a1,s3
  800410:	8526                	mv	a0,s1
  800412:	e61ff0ef          	jal	800272 <printnum>
  800416:	b709                	j	800318 <vprintfmt+0x36>
  800418:	000aa503          	lw	a0,0(s5)
  80041c:	864e                	mv	a2,s3
  80041e:	85ca                	mv	a1,s2
  800420:	9482                	jalr	s1
  800422:	0aa1                	addi	s5,s5,8
  800424:	bdd5                	j	800318 <vprintfmt+0x36>
  800426:	4785                	li	a5,1
  800428:	008a8613          	addi	a2,s5,8
  80042c:	00b7c463          	blt	a5,a1,800434 <vprintfmt+0x152>
  800430:	18058463          	beqz	a1,8005b8 <vprintfmt+0x2d6>
  800434:	000ab683          	ld	a3,0(s5)
  800438:	4729                	li	a4,10
  80043a:	8ab2                	mv	s5,a2
  80043c:	b7f1                	j	800408 <vprintfmt+0x126>
  80043e:	864e                	mv	a2,s3
  800440:	85ca                	mv	a1,s2
  800442:	03000513          	li	a0,48
  800446:	e042                	sd	a6,0(sp)
  800448:	9482                	jalr	s1
  80044a:	864e                	mv	a2,s3
  80044c:	85ca                	mv	a1,s2
  80044e:	07800513          	li	a0,120
  800452:	9482                	jalr	s1
  800454:	000ab683          	ld	a3,0(s5)
  800458:	6802                	ld	a6,0(sp)
  80045a:	4741                	li	a4,16
  80045c:	0aa1                	addi	s5,s5,8
  80045e:	b76d                	j	800408 <vprintfmt+0x126>
  800460:	864e                	mv	a2,s3
  800462:	85ca                	mv	a1,s2
  800464:	02500513          	li	a0,37
  800468:	9482                	jalr	s1
  80046a:	b57d                	j	800318 <vprintfmt+0x36>
  80046c:	000aad03          	lw	s10,0(s5)
  800470:	8466                	mv	s0,s9
  800472:	0aa1                	addi	s5,s5,8
  800474:	b7a5                	j	8003dc <vprintfmt+0xfa>
  800476:	4785                	li	a5,1
  800478:	008a8613          	addi	a2,s5,8
  80047c:	00b7c463          	blt	a5,a1,800484 <vprintfmt+0x1a2>
  800480:	12058763          	beqz	a1,8005ae <vprintfmt+0x2cc>
  800484:	000ab683          	ld	a3,0(s5)
  800488:	4721                	li	a4,8
  80048a:	8ab2                	mv	s5,a2
  80048c:	bfb5                	j	800408 <vprintfmt+0x126>
  80048e:	87ee                	mv	a5,s11
  800490:	000dd363          	bgez	s11,800496 <vprintfmt+0x1b4>
  800494:	4781                	li	a5,0
  800496:	00078d9b          	sext.w	s11,a5
  80049a:	8466                	mv	s0,s9
  80049c:	b55d                	j	800342 <vprintfmt+0x60>
  80049e:	0008041b          	sext.w	s0,a6
  8004a2:	fd340793          	addi	a5,s0,-45
  8004a6:	01b02733          	sgtz	a4,s11
  8004aa:	00f037b3          	snez	a5,a5
  8004ae:	8ff9                	and	a5,a5,a4
  8004b0:	000ab703          	ld	a4,0(s5)
  8004b4:	008a8693          	addi	a3,s5,8
  8004b8:	e436                	sd	a3,8(sp)
  8004ba:	12070563          	beqz	a4,8005e4 <vprintfmt+0x302>
  8004be:	12079d63          	bnez	a5,8005f8 <vprintfmt+0x316>
  8004c2:	00074783          	lbu	a5,0(a4)
  8004c6:	0007851b          	sext.w	a0,a5
  8004ca:	c78d                	beqz	a5,8004f4 <vprintfmt+0x212>
  8004cc:	00170a93          	addi	s5,a4,1
  8004d0:	547d                	li	s0,-1
  8004d2:	000d4563          	bltz	s10,8004dc <vprintfmt+0x1fa>
  8004d6:	3d7d                	addiw	s10,s10,-1
  8004d8:	008d0e63          	beq	s10,s0,8004f4 <vprintfmt+0x212>
  8004dc:	020c1863          	bnez	s8,80050c <vprintfmt+0x22a>
  8004e0:	864e                	mv	a2,s3
  8004e2:	85ca                	mv	a1,s2
  8004e4:	9482                	jalr	s1
  8004e6:	000ac783          	lbu	a5,0(s5)
  8004ea:	0a85                	addi	s5,s5,1
  8004ec:	3dfd                	addiw	s11,s11,-1
  8004ee:	0007851b          	sext.w	a0,a5
  8004f2:	f3e5                	bnez	a5,8004d2 <vprintfmt+0x1f0>
  8004f4:	01b05a63          	blez	s11,800508 <vprintfmt+0x226>
  8004f8:	864e                	mv	a2,s3
  8004fa:	85ca                	mv	a1,s2
  8004fc:	02000513          	li	a0,32
  800500:	3dfd                	addiw	s11,s11,-1
  800502:	9482                	jalr	s1
  800504:	fe0d9ae3          	bnez	s11,8004f8 <vprintfmt+0x216>
  800508:	6aa2                	ld	s5,8(sp)
  80050a:	b539                	j	800318 <vprintfmt+0x36>
  80050c:	3781                	addiw	a5,a5,-32
  80050e:	05e00713          	li	a4,94
  800512:	fcf777e3          	bgeu	a4,a5,8004e0 <vprintfmt+0x1fe>
  800516:	03f00513          	li	a0,63
  80051a:	864e                	mv	a2,s3
  80051c:	85ca                	mv	a1,s2
  80051e:	9482                	jalr	s1
  800520:	000ac783          	lbu	a5,0(s5)
  800524:	0a85                	addi	s5,s5,1
  800526:	3dfd                	addiw	s11,s11,-1
  800528:	0007851b          	sext.w	a0,a5
  80052c:	d7e1                	beqz	a5,8004f4 <vprintfmt+0x212>
  80052e:	fa0d54e3          	bgez	s10,8004d6 <vprintfmt+0x1f4>
  800532:	bfe9                	j	80050c <vprintfmt+0x22a>
  800534:	000aa783          	lw	a5,0(s5)
  800538:	46e1                	li	a3,24
  80053a:	0aa1                	addi	s5,s5,8
  80053c:	41f7d71b          	sraiw	a4,a5,0x1f
  800540:	8fb9                	xor	a5,a5,a4
  800542:	40e7873b          	subw	a4,a5,a4
  800546:	02e6c663          	blt	a3,a4,800572 <vprintfmt+0x290>
  80054a:	00000797          	auipc	a5,0x0
  80054e:	73678793          	addi	a5,a5,1846 # 800c80 <error_string>
  800552:	00371693          	slli	a3,a4,0x3
  800556:	97b6                	add	a5,a5,a3
  800558:	639c                	ld	a5,0(a5)
  80055a:	cf81                	beqz	a5,800572 <vprintfmt+0x290>
  80055c:	873e                	mv	a4,a5
  80055e:	00000697          	auipc	a3,0x0
  800562:	32268693          	addi	a3,a3,802 # 800880 <main+0x1e8>
  800566:	864a                	mv	a2,s2
  800568:	85ce                	mv	a1,s3
  80056a:	8526                	mv	a0,s1
  80056c:	0f2000ef          	jal	80065e <printfmt>
  800570:	b365                	j	800318 <vprintfmt+0x36>
  800572:	00000697          	auipc	a3,0x0
  800576:	2fe68693          	addi	a3,a3,766 # 800870 <main+0x1d8>
  80057a:	864a                	mv	a2,s2
  80057c:	85ce                	mv	a1,s3
  80057e:	8526                	mv	a0,s1
  800580:	0de000ef          	jal	80065e <printfmt>
  800584:	bb51                	j	800318 <vprintfmt+0x36>
  800586:	4785                	li	a5,1
  800588:	008a8c13          	addi	s8,s5,8
  80058c:	00b7c363          	blt	a5,a1,800592 <vprintfmt+0x2b0>
  800590:	cd81                	beqz	a1,8005a8 <vprintfmt+0x2c6>
  800592:	000ab403          	ld	s0,0(s5)
  800596:	02044b63          	bltz	s0,8005cc <vprintfmt+0x2ea>
  80059a:	86a2                	mv	a3,s0
  80059c:	8ae2                	mv	s5,s8
  80059e:	4729                	li	a4,10
  8005a0:	b5a5                	j	800408 <vprintfmt+0x126>
  8005a2:	2585                	addiw	a1,a1,1
  8005a4:	8466                	mv	s0,s9
  8005a6:	bb71                	j	800342 <vprintfmt+0x60>
  8005a8:	000aa403          	lw	s0,0(s5)
  8005ac:	b7ed                	j	800596 <vprintfmt+0x2b4>
  8005ae:	000ae683          	lwu	a3,0(s5)
  8005b2:	4721                	li	a4,8
  8005b4:	8ab2                	mv	s5,a2
  8005b6:	bd89                	j	800408 <vprintfmt+0x126>
  8005b8:	000ae683          	lwu	a3,0(s5)
  8005bc:	4729                	li	a4,10
  8005be:	8ab2                	mv	s5,a2
  8005c0:	b5a1                	j	800408 <vprintfmt+0x126>
  8005c2:	000ae683          	lwu	a3,0(s5)
  8005c6:	4741                	li	a4,16
  8005c8:	8ab2                	mv	s5,a2
  8005ca:	bd3d                	j	800408 <vprintfmt+0x126>
  8005cc:	864e                	mv	a2,s3
  8005ce:	85ca                	mv	a1,s2
  8005d0:	02d00513          	li	a0,45
  8005d4:	e042                	sd	a6,0(sp)
  8005d6:	9482                	jalr	s1
  8005d8:	6802                	ld	a6,0(sp)
  8005da:	408006b3          	neg	a3,s0
  8005de:	8ae2                	mv	s5,s8
  8005e0:	4729                	li	a4,10
  8005e2:	b51d                	j	800408 <vprintfmt+0x126>
  8005e4:	eba1                	bnez	a5,800634 <vprintfmt+0x352>
  8005e6:	02800793          	li	a5,40
  8005ea:	853e                	mv	a0,a5
  8005ec:	00000a97          	auipc	s5,0x0
  8005f0:	27da8a93          	addi	s5,s5,637 # 800869 <main+0x1d1>
  8005f4:	547d                	li	s0,-1
  8005f6:	bdf1                	j	8004d2 <vprintfmt+0x1f0>
  8005f8:	853a                	mv	a0,a4
  8005fa:	85ea                	mv	a1,s10
  8005fc:	e03a                	sd	a4,0(sp)
  8005fe:	07e000ef          	jal	80067c <strnlen>
  800602:	40ad8dbb          	subw	s11,s11,a0
  800606:	6702                	ld	a4,0(sp)
  800608:	01b05b63          	blez	s11,80061e <vprintfmt+0x33c>
  80060c:	864e                	mv	a2,s3
  80060e:	85ca                	mv	a1,s2
  800610:	8522                	mv	a0,s0
  800612:	e03a                	sd	a4,0(sp)
  800614:	3dfd                	addiw	s11,s11,-1
  800616:	9482                	jalr	s1
  800618:	6702                	ld	a4,0(sp)
  80061a:	fe0d99e3          	bnez	s11,80060c <vprintfmt+0x32a>
  80061e:	00074783          	lbu	a5,0(a4)
  800622:	0007851b          	sext.w	a0,a5
  800626:	ee0781e3          	beqz	a5,800508 <vprintfmt+0x226>
  80062a:	00170a93          	addi	s5,a4,1
  80062e:	b54d                	j	8004d0 <vprintfmt+0x1ee>
  800630:	8466                	mv	s0,s9
  800632:	b36d                	j	8003dc <vprintfmt+0xfa>
  800634:	85ea                	mv	a1,s10
  800636:	00000517          	auipc	a0,0x0
  80063a:	23250513          	addi	a0,a0,562 # 800868 <main+0x1d0>
  80063e:	03e000ef          	jal	80067c <strnlen>
  800642:	40ad8dbb          	subw	s11,s11,a0
  800646:	02800793          	li	a5,40
  80064a:	00000717          	auipc	a4,0x0
  80064e:	21e70713          	addi	a4,a4,542 # 800868 <main+0x1d0>
  800652:	853e                	mv	a0,a5
  800654:	fbb04ce3          	bgtz	s11,80060c <vprintfmt+0x32a>
  800658:	00170a93          	addi	s5,a4,1
  80065c:	bd95                	j	8004d0 <vprintfmt+0x1ee>

000000000080065e <printfmt>:
  80065e:	7139                	addi	sp,sp,-64
  800660:	02010313          	addi	t1,sp,32
  800664:	f03a                	sd	a4,32(sp)
  800666:	871a                	mv	a4,t1
  800668:	ec06                	sd	ra,24(sp)
  80066a:	f43e                	sd	a5,40(sp)
  80066c:	f842                	sd	a6,48(sp)
  80066e:	fc46                	sd	a7,56(sp)
  800670:	e41a                	sd	t1,8(sp)
  800672:	c71ff0ef          	jal	8002e2 <vprintfmt>
  800676:	60e2                	ld	ra,24(sp)
  800678:	6121                	addi	sp,sp,64
  80067a:	8082                	ret

000000000080067c <strnlen>:
  80067c:	4781                	li	a5,0
  80067e:	e589                	bnez	a1,800688 <strnlen+0xc>
  800680:	a811                	j	800694 <strnlen+0x18>
  800682:	0785                	addi	a5,a5,1
  800684:	00f58863          	beq	a1,a5,800694 <strnlen+0x18>
  800688:	00f50733          	add	a4,a0,a5
  80068c:	00074703          	lbu	a4,0(a4)
  800690:	fb6d                	bnez	a4,800682 <strnlen+0x6>
  800692:	85be                	mv	a1,a5
  800694:	852e                	mv	a0,a1
  800696:	8082                	ret

0000000000800698 <main>:
  800698:	1101                	addi	sp,sp,-32
  80069a:	ec06                	sd	ra,24(sp)
  80069c:	e822                	sd	s0,16(sp)
  80069e:	b19ff0ef          	jal	8001b6 <fork>
  8006a2:	c169                	beqz	a0,800764 <main+0xcc>
  8006a4:	842a                	mv	s0,a0
  8006a6:	0aa05063          	blez	a0,800746 <main+0xae>
  8006aa:	4581                	li	a1,0
  8006ac:	557d                	li	a0,-1
  8006ae:	b0bff0ef          	jal	8001b8 <waitpid>
  8006b2:	c93d                	beqz	a0,800728 <main+0x90>
  8006b4:	458d                	li	a1,3
  8006b6:	05fa                	slli	a1,a1,0x1e
  8006b8:	8522                	mv	a0,s0
  8006ba:	affff0ef          	jal	8001b8 <waitpid>
  8006be:	c531                	beqz	a0,80070a <main+0x72>
  8006c0:	8522                	mv	a0,s0
  8006c2:	006c                	addi	a1,sp,12
  8006c4:	af5ff0ef          	jal	8001b8 <waitpid>
  8006c8:	e115                	bnez	a0,8006ec <main+0x54>
  8006ca:	4732                	lw	a4,12(sp)
  8006cc:	67b1                	lui	a5,0xc
  8006ce:	eaf78793          	addi	a5,a5,-337 # beaf <open-0x7f4171>
  8006d2:	00f71d63          	bne	a4,a5,8006ec <main+0x54>
  8006d6:	00000517          	auipc	a0,0x0
  8006da:	44250513          	addi	a0,a0,1090 # 800b18 <main+0x480>
  8006de:	a17ff0ef          	jal	8000f4 <cprintf>
  8006e2:	60e2                	ld	ra,24(sp)
  8006e4:	6442                	ld	s0,16(sp)
  8006e6:	4501                	li	a0,0
  8006e8:	6105                	addi	sp,sp,32
  8006ea:	8082                	ret
  8006ec:	00000697          	auipc	a3,0x0
  8006f0:	3f468693          	addi	a3,a3,1012 # 800ae0 <main+0x448>
  8006f4:	00000617          	auipc	a2,0x0
  8006f8:	38460613          	addi	a2,a2,900 # 800a78 <main+0x3e0>
  8006fc:	45c9                	li	a1,18
  8006fe:	00000517          	auipc	a0,0x0
  800702:	39250513          	addi	a0,a0,914 # 800a90 <main+0x3f8>
  800706:	92bff0ef          	jal	800030 <__panic>
  80070a:	00000697          	auipc	a3,0x0
  80070e:	3ae68693          	addi	a3,a3,942 # 800ab8 <main+0x420>
  800712:	00000617          	auipc	a2,0x0
  800716:	36660613          	addi	a2,a2,870 # 800a78 <main+0x3e0>
  80071a:	45c5                	li	a1,17
  80071c:	00000517          	auipc	a0,0x0
  800720:	37450513          	addi	a0,a0,884 # 800a90 <main+0x3f8>
  800724:	90dff0ef          	jal	800030 <__panic>
  800728:	00000697          	auipc	a3,0x0
  80072c:	37868693          	addi	a3,a3,888 # 800aa0 <main+0x408>
  800730:	00000617          	auipc	a2,0x0
  800734:	34860613          	addi	a2,a2,840 # 800a78 <main+0x3e0>
  800738:	45c1                	li	a1,16
  80073a:	00000517          	auipc	a0,0x0
  80073e:	35650513          	addi	a0,a0,854 # 800a90 <main+0x3f8>
  800742:	8efff0ef          	jal	800030 <__panic>
  800746:	00000697          	auipc	a3,0x0
  80074a:	32a68693          	addi	a3,a3,810 # 800a70 <main+0x3d8>
  80074e:	00000617          	auipc	a2,0x0
  800752:	32a60613          	addi	a2,a2,810 # 800a78 <main+0x3e0>
  800756:	45bd                	li	a1,15
  800758:	00000517          	auipc	a0,0x0
  80075c:	33850513          	addi	a0,a0,824 # 800a90 <main+0x3f8>
  800760:	8d1ff0ef          	jal	800030 <__panic>
  800764:	00000517          	auipc	a0,0x0
  800768:	2fc50513          	addi	a0,a0,764 # 800a60 <main+0x3c8>
  80076c:	989ff0ef          	jal	8000f4 <cprintf>
  800770:	4429                	li	s0,10
  800772:	347d                	addiw	s0,s0,-1
  800774:	a47ff0ef          	jal	8001ba <yield>
  800778:	fc6d                	bnez	s0,800772 <main+0xda>
  80077a:	6531                	lui	a0,0xc
  80077c:	eaf50513          	addi	a0,a0,-337 # beaf <open-0x7f4171>
  800780:	a21ff0ef          	jal	8001a0 <exit>
