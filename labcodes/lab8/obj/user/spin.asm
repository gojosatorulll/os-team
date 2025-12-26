
obj/__user_spin.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a29d                	j	80018a <sys_open>

0000000000800026 <close>:
  800026:	a2bd                	j	800194 <sys_close>

0000000000800028 <dup2>:
  800028:	aa95                	j	80019c <sys_dup>

000000000080002a <_start>:
  80002a:	1dc000ef          	jal	800206 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	73250513          	addi	a0,a0,1842 # 800770 <main+0xd0>
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
  800064:	73050513          	addi	a0,a0,1840 # 800790 <main+0xf0>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	138000ef          	jal	8001a6 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	71850513          	addi	a0,a0,1816 # 800798 <main+0xf8>
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
  8000a6:	6ee50513          	addi	a0,a0,1774 # 800790 <main+0xf0>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0c8000ef          	jal	800184 <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e01>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	202000ef          	jal	8002ea <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e01>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1c8000ef          	jal	8002ea <vprintfmt>
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

000000000080017e <sys_kill>:
  80017e:	85aa                	mv	a1,a0
  800180:	4531                	li	a0,12
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_putc>:
  800184:	85aa                	mv	a1,a0
  800186:	4579                	li	a0,30
  800188:	b75d                	j	80012e <syscall>

000000000080018a <sys_open>:
  80018a:	862e                	mv	a2,a1
  80018c:	85aa                	mv	a1,a0
  80018e:	06400513          	li	a0,100
  800192:	bf71                	j	80012e <syscall>

0000000000800194 <sys_close>:
  800194:	85aa                	mv	a1,a0
  800196:	06500513          	li	a0,101
  80019a:	bf51                	j	80012e <syscall>

000000000080019c <sys_dup>:
  80019c:	862e                	mv	a2,a1
  80019e:	85aa                	mv	a1,a0
  8001a0:	08200513          	li	a0,130
  8001a4:	b769                	j	80012e <syscall>

00000000008001a6 <exit>:
  8001a6:	1141                	addi	sp,sp,-16
  8001a8:	e406                	sd	ra,8(sp)
  8001aa:	fbfff0ef          	jal	800168 <sys_exit>
  8001ae:	00000517          	auipc	a0,0x0
  8001b2:	60a50513          	addi	a0,a0,1546 # 8007b8 <main+0x118>
  8001b6:	f3fff0ef          	jal	8000f4 <cprintf>
  8001ba:	a001                	j	8001ba <exit+0x14>

00000000008001bc <fork>:
  8001bc:	bf4d                	j	80016e <sys_fork>

00000000008001be <waitpid>:
  8001be:	bf55                	j	800172 <sys_wait>

00000000008001c0 <yield>:
  8001c0:	bf6d                	j	80017a <sys_yield>

00000000008001c2 <kill>:
  8001c2:	bf75                	j	80017e <sys_kill>

00000000008001c4 <initfd>:
  8001c4:	87ae                	mv	a5,a1
  8001c6:	1101                	addi	sp,sp,-32
  8001c8:	e822                	sd	s0,16(sp)
  8001ca:	85b2                	mv	a1,a2
  8001cc:	842a                	mv	s0,a0
  8001ce:	853e                	mv	a0,a5
  8001d0:	ec06                	sd	ra,24(sp)
  8001d2:	e4fff0ef          	jal	800020 <open>
  8001d6:	87aa                	mv	a5,a0
  8001d8:	00054463          	bltz	a0,8001e0 <initfd+0x1c>
  8001dc:	00851763          	bne	a0,s0,8001ea <initfd+0x26>
  8001e0:	60e2                	ld	ra,24(sp)
  8001e2:	6442                	ld	s0,16(sp)
  8001e4:	853e                	mv	a0,a5
  8001e6:	6105                	addi	sp,sp,32
  8001e8:	8082                	ret
  8001ea:	e42a                	sd	a0,8(sp)
  8001ec:	8522                	mv	a0,s0
  8001ee:	e39ff0ef          	jal	800026 <close>
  8001f2:	6522                	ld	a0,8(sp)
  8001f4:	85a2                	mv	a1,s0
  8001f6:	e33ff0ef          	jal	800028 <dup2>
  8001fa:	842a                	mv	s0,a0
  8001fc:	6522                	ld	a0,8(sp)
  8001fe:	e29ff0ef          	jal	800026 <close>
  800202:	87a2                	mv	a5,s0
  800204:	bff1                	j	8001e0 <initfd+0x1c>

0000000000800206 <umain>:
  800206:	1101                	addi	sp,sp,-32
  800208:	e822                	sd	s0,16(sp)
  80020a:	e426                	sd	s1,8(sp)
  80020c:	842a                	mv	s0,a0
  80020e:	84ae                	mv	s1,a1
  800210:	4601                	li	a2,0
  800212:	00000597          	auipc	a1,0x0
  800216:	5be58593          	addi	a1,a1,1470 # 8007d0 <main+0x130>
  80021a:	4501                	li	a0,0
  80021c:	ec06                	sd	ra,24(sp)
  80021e:	fa7ff0ef          	jal	8001c4 <initfd>
  800222:	02054263          	bltz	a0,800246 <umain+0x40>
  800226:	4605                	li	a2,1
  800228:	8532                	mv	a0,a2
  80022a:	00000597          	auipc	a1,0x0
  80022e:	5e658593          	addi	a1,a1,1510 # 800810 <main+0x170>
  800232:	f93ff0ef          	jal	8001c4 <initfd>
  800236:	02054563          	bltz	a0,800260 <umain+0x5a>
  80023a:	85a6                	mv	a1,s1
  80023c:	8522                	mv	a0,s0
  80023e:	462000ef          	jal	8006a0 <main>
  800242:	f65ff0ef          	jal	8001a6 <exit>
  800246:	86aa                	mv	a3,a0
  800248:	00000617          	auipc	a2,0x0
  80024c:	59060613          	addi	a2,a2,1424 # 8007d8 <main+0x138>
  800250:	45e9                	li	a1,26
  800252:	00000517          	auipc	a0,0x0
  800256:	5a650513          	addi	a0,a0,1446 # 8007f8 <main+0x158>
  80025a:	e19ff0ef          	jal	800072 <__warn>
  80025e:	b7e1                	j	800226 <umain+0x20>
  800260:	86aa                	mv	a3,a0
  800262:	00000617          	auipc	a2,0x0
  800266:	5b660613          	addi	a2,a2,1462 # 800818 <main+0x178>
  80026a:	45f5                	li	a1,29
  80026c:	00000517          	auipc	a0,0x0
  800270:	58c50513          	addi	a0,a0,1420 # 8007f8 <main+0x158>
  800274:	dffff0ef          	jal	800072 <__warn>
  800278:	b7c9                	j	80023a <umain+0x34>

000000000080027a <printnum>:
  80027a:	7139                	addi	sp,sp,-64
  80027c:	02071893          	slli	a7,a4,0x20
  800280:	f822                	sd	s0,48(sp)
  800282:	f426                	sd	s1,40(sp)
  800284:	f04a                	sd	s2,32(sp)
  800286:	ec4e                	sd	s3,24(sp)
  800288:	e456                	sd	s5,8(sp)
  80028a:	0208d893          	srli	a7,a7,0x20
  80028e:	fc06                	sd	ra,56(sp)
  800290:	0316fab3          	remu	s5,a3,a7
  800294:	fff7841b          	addiw	s0,a5,-1
  800298:	84aa                	mv	s1,a0
  80029a:	89ae                	mv	s3,a1
  80029c:	8932                	mv	s2,a2
  80029e:	0516f063          	bgeu	a3,a7,8002de <printnum+0x64>
  8002a2:	e852                	sd	s4,16(sp)
  8002a4:	4705                	li	a4,1
  8002a6:	8a42                	mv	s4,a6
  8002a8:	00f75863          	bge	a4,a5,8002b8 <printnum+0x3e>
  8002ac:	864e                	mv	a2,s3
  8002ae:	85ca                	mv	a1,s2
  8002b0:	8552                	mv	a0,s4
  8002b2:	347d                	addiw	s0,s0,-1
  8002b4:	9482                	jalr	s1
  8002b6:	f87d                	bnez	s0,8002ac <printnum+0x32>
  8002b8:	6a42                	ld	s4,16(sp)
  8002ba:	00000797          	auipc	a5,0x0
  8002be:	57e78793          	addi	a5,a5,1406 # 800838 <main+0x198>
  8002c2:	97d6                	add	a5,a5,s5
  8002c4:	7442                	ld	s0,48(sp)
  8002c6:	0007c503          	lbu	a0,0(a5)
  8002ca:	70e2                	ld	ra,56(sp)
  8002cc:	6aa2                	ld	s5,8(sp)
  8002ce:	864e                	mv	a2,s3
  8002d0:	85ca                	mv	a1,s2
  8002d2:	69e2                	ld	s3,24(sp)
  8002d4:	7902                	ld	s2,32(sp)
  8002d6:	87a6                	mv	a5,s1
  8002d8:	74a2                	ld	s1,40(sp)
  8002da:	6121                	addi	sp,sp,64
  8002dc:	8782                	jr	a5
  8002de:	0316d6b3          	divu	a3,a3,a7
  8002e2:	87a2                	mv	a5,s0
  8002e4:	f97ff0ef          	jal	80027a <printnum>
  8002e8:	bfc9                	j	8002ba <printnum+0x40>

00000000008002ea <vprintfmt>:
  8002ea:	7119                	addi	sp,sp,-128
  8002ec:	f4a6                	sd	s1,104(sp)
  8002ee:	f0ca                	sd	s2,96(sp)
  8002f0:	ecce                	sd	s3,88(sp)
  8002f2:	e8d2                	sd	s4,80(sp)
  8002f4:	e4d6                	sd	s5,72(sp)
  8002f6:	e0da                	sd	s6,64(sp)
  8002f8:	fc5e                	sd	s7,56(sp)
  8002fa:	f466                	sd	s9,40(sp)
  8002fc:	fc86                	sd	ra,120(sp)
  8002fe:	f8a2                	sd	s0,112(sp)
  800300:	f862                	sd	s8,48(sp)
  800302:	f06a                	sd	s10,32(sp)
  800304:	ec6e                	sd	s11,24(sp)
  800306:	84aa                	mv	s1,a0
  800308:	8cb6                	mv	s9,a3
  80030a:	8aba                	mv	s5,a4
  80030c:	89ae                	mv	s3,a1
  80030e:	8932                	mv	s2,a2
  800310:	02500a13          	li	s4,37
  800314:	05500b93          	li	s7,85
  800318:	00001b17          	auipc	s6,0x1
  80031c:	868b0b13          	addi	s6,s6,-1944 # 800b80 <main+0x4e0>
  800320:	000cc503          	lbu	a0,0(s9)
  800324:	001c8413          	addi	s0,s9,1
  800328:	01450b63          	beq	a0,s4,80033e <vprintfmt+0x54>
  80032c:	cd15                	beqz	a0,800368 <vprintfmt+0x7e>
  80032e:	864e                	mv	a2,s3
  800330:	85ca                	mv	a1,s2
  800332:	9482                	jalr	s1
  800334:	00044503          	lbu	a0,0(s0)
  800338:	0405                	addi	s0,s0,1
  80033a:	ff4519e3          	bne	a0,s4,80032c <vprintfmt+0x42>
  80033e:	5d7d                	li	s10,-1
  800340:	8dea                	mv	s11,s10
  800342:	02000813          	li	a6,32
  800346:	4c01                	li	s8,0
  800348:	4581                	li	a1,0
  80034a:	00044703          	lbu	a4,0(s0)
  80034e:	00140c93          	addi	s9,s0,1
  800352:	fdd7061b          	addiw	a2,a4,-35
  800356:	0ff67613          	zext.b	a2,a2
  80035a:	02cbe663          	bltu	s7,a2,800386 <vprintfmt+0x9c>
  80035e:	060a                	slli	a2,a2,0x2
  800360:	965a                	add	a2,a2,s6
  800362:	421c                	lw	a5,0(a2)
  800364:	97da                	add	a5,a5,s6
  800366:	8782                	jr	a5
  800368:	70e6                	ld	ra,120(sp)
  80036a:	7446                	ld	s0,112(sp)
  80036c:	74a6                	ld	s1,104(sp)
  80036e:	7906                	ld	s2,96(sp)
  800370:	69e6                	ld	s3,88(sp)
  800372:	6a46                	ld	s4,80(sp)
  800374:	6aa6                	ld	s5,72(sp)
  800376:	6b06                	ld	s6,64(sp)
  800378:	7be2                	ld	s7,56(sp)
  80037a:	7c42                	ld	s8,48(sp)
  80037c:	7ca2                	ld	s9,40(sp)
  80037e:	7d02                	ld	s10,32(sp)
  800380:	6de2                	ld	s11,24(sp)
  800382:	6109                	addi	sp,sp,128
  800384:	8082                	ret
  800386:	864e                	mv	a2,s3
  800388:	85ca                	mv	a1,s2
  80038a:	02500513          	li	a0,37
  80038e:	9482                	jalr	s1
  800390:	fff44783          	lbu	a5,-1(s0)
  800394:	02500713          	li	a4,37
  800398:	8ca2                	mv	s9,s0
  80039a:	f8e783e3          	beq	a5,a4,800320 <vprintfmt+0x36>
  80039e:	ffecc783          	lbu	a5,-2(s9)
  8003a2:	1cfd                	addi	s9,s9,-1
  8003a4:	fee79de3          	bne	a5,a4,80039e <vprintfmt+0xb4>
  8003a8:	bfa5                	j	800320 <vprintfmt+0x36>
  8003aa:	00144683          	lbu	a3,1(s0)
  8003ae:	4525                	li	a0,9
  8003b0:	fd070d1b          	addiw	s10,a4,-48
  8003b4:	fd06879b          	addiw	a5,a3,-48
  8003b8:	28f56063          	bltu	a0,a5,800638 <vprintfmt+0x34e>
  8003bc:	2681                	sext.w	a3,a3
  8003be:	8466                	mv	s0,s9
  8003c0:	002d179b          	slliw	a5,s10,0x2
  8003c4:	00144703          	lbu	a4,1(s0)
  8003c8:	01a787bb          	addw	a5,a5,s10
  8003cc:	0017979b          	slliw	a5,a5,0x1
  8003d0:	9fb5                	addw	a5,a5,a3
  8003d2:	fd07061b          	addiw	a2,a4,-48
  8003d6:	0405                	addi	s0,s0,1
  8003d8:	fd078d1b          	addiw	s10,a5,-48
  8003dc:	0007069b          	sext.w	a3,a4
  8003e0:	fec570e3          	bgeu	a0,a2,8003c0 <vprintfmt+0xd6>
  8003e4:	f60dd3e3          	bgez	s11,80034a <vprintfmt+0x60>
  8003e8:	8dea                	mv	s11,s10
  8003ea:	5d7d                	li	s10,-1
  8003ec:	bfb9                	j	80034a <vprintfmt+0x60>
  8003ee:	883a                	mv	a6,a4
  8003f0:	8466                	mv	s0,s9
  8003f2:	bfa1                	j	80034a <vprintfmt+0x60>
  8003f4:	8466                	mv	s0,s9
  8003f6:	4c05                	li	s8,1
  8003f8:	bf89                	j	80034a <vprintfmt+0x60>
  8003fa:	4785                	li	a5,1
  8003fc:	008a8613          	addi	a2,s5,8
  800400:	00b7c463          	blt	a5,a1,800408 <vprintfmt+0x11e>
  800404:	1c058363          	beqz	a1,8005ca <vprintfmt+0x2e0>
  800408:	000ab683          	ld	a3,0(s5)
  80040c:	4741                	li	a4,16
  80040e:	8ab2                	mv	s5,a2
  800410:	2801                	sext.w	a6,a6
  800412:	87ee                	mv	a5,s11
  800414:	864a                	mv	a2,s2
  800416:	85ce                	mv	a1,s3
  800418:	8526                	mv	a0,s1
  80041a:	e61ff0ef          	jal	80027a <printnum>
  80041e:	b709                	j	800320 <vprintfmt+0x36>
  800420:	000aa503          	lw	a0,0(s5)
  800424:	864e                	mv	a2,s3
  800426:	85ca                	mv	a1,s2
  800428:	9482                	jalr	s1
  80042a:	0aa1                	addi	s5,s5,8
  80042c:	bdd5                	j	800320 <vprintfmt+0x36>
  80042e:	4785                	li	a5,1
  800430:	008a8613          	addi	a2,s5,8
  800434:	00b7c463          	blt	a5,a1,80043c <vprintfmt+0x152>
  800438:	18058463          	beqz	a1,8005c0 <vprintfmt+0x2d6>
  80043c:	000ab683          	ld	a3,0(s5)
  800440:	4729                	li	a4,10
  800442:	8ab2                	mv	s5,a2
  800444:	b7f1                	j	800410 <vprintfmt+0x126>
  800446:	864e                	mv	a2,s3
  800448:	85ca                	mv	a1,s2
  80044a:	03000513          	li	a0,48
  80044e:	e042                	sd	a6,0(sp)
  800450:	9482                	jalr	s1
  800452:	864e                	mv	a2,s3
  800454:	85ca                	mv	a1,s2
  800456:	07800513          	li	a0,120
  80045a:	9482                	jalr	s1
  80045c:	000ab683          	ld	a3,0(s5)
  800460:	6802                	ld	a6,0(sp)
  800462:	4741                	li	a4,16
  800464:	0aa1                	addi	s5,s5,8
  800466:	b76d                	j	800410 <vprintfmt+0x126>
  800468:	864e                	mv	a2,s3
  80046a:	85ca                	mv	a1,s2
  80046c:	02500513          	li	a0,37
  800470:	9482                	jalr	s1
  800472:	b57d                	j	800320 <vprintfmt+0x36>
  800474:	000aad03          	lw	s10,0(s5)
  800478:	8466                	mv	s0,s9
  80047a:	0aa1                	addi	s5,s5,8
  80047c:	b7a5                	j	8003e4 <vprintfmt+0xfa>
  80047e:	4785                	li	a5,1
  800480:	008a8613          	addi	a2,s5,8
  800484:	00b7c463          	blt	a5,a1,80048c <vprintfmt+0x1a2>
  800488:	12058763          	beqz	a1,8005b6 <vprintfmt+0x2cc>
  80048c:	000ab683          	ld	a3,0(s5)
  800490:	4721                	li	a4,8
  800492:	8ab2                	mv	s5,a2
  800494:	bfb5                	j	800410 <vprintfmt+0x126>
  800496:	87ee                	mv	a5,s11
  800498:	000dd363          	bgez	s11,80049e <vprintfmt+0x1b4>
  80049c:	4781                	li	a5,0
  80049e:	00078d9b          	sext.w	s11,a5
  8004a2:	8466                	mv	s0,s9
  8004a4:	b55d                	j	80034a <vprintfmt+0x60>
  8004a6:	0008041b          	sext.w	s0,a6
  8004aa:	fd340793          	addi	a5,s0,-45
  8004ae:	01b02733          	sgtz	a4,s11
  8004b2:	00f037b3          	snez	a5,a5
  8004b6:	8ff9                	and	a5,a5,a4
  8004b8:	000ab703          	ld	a4,0(s5)
  8004bc:	008a8693          	addi	a3,s5,8
  8004c0:	e436                	sd	a3,8(sp)
  8004c2:	12070563          	beqz	a4,8005ec <vprintfmt+0x302>
  8004c6:	12079d63          	bnez	a5,800600 <vprintfmt+0x316>
  8004ca:	00074783          	lbu	a5,0(a4)
  8004ce:	0007851b          	sext.w	a0,a5
  8004d2:	c78d                	beqz	a5,8004fc <vprintfmt+0x212>
  8004d4:	00170a93          	addi	s5,a4,1
  8004d8:	547d                	li	s0,-1
  8004da:	000d4563          	bltz	s10,8004e4 <vprintfmt+0x1fa>
  8004de:	3d7d                	addiw	s10,s10,-1
  8004e0:	008d0e63          	beq	s10,s0,8004fc <vprintfmt+0x212>
  8004e4:	020c1863          	bnez	s8,800514 <vprintfmt+0x22a>
  8004e8:	864e                	mv	a2,s3
  8004ea:	85ca                	mv	a1,s2
  8004ec:	9482                	jalr	s1
  8004ee:	000ac783          	lbu	a5,0(s5)
  8004f2:	0a85                	addi	s5,s5,1
  8004f4:	3dfd                	addiw	s11,s11,-1
  8004f6:	0007851b          	sext.w	a0,a5
  8004fa:	f3e5                	bnez	a5,8004da <vprintfmt+0x1f0>
  8004fc:	01b05a63          	blez	s11,800510 <vprintfmt+0x226>
  800500:	864e                	mv	a2,s3
  800502:	85ca                	mv	a1,s2
  800504:	02000513          	li	a0,32
  800508:	3dfd                	addiw	s11,s11,-1
  80050a:	9482                	jalr	s1
  80050c:	fe0d9ae3          	bnez	s11,800500 <vprintfmt+0x216>
  800510:	6aa2                	ld	s5,8(sp)
  800512:	b539                	j	800320 <vprintfmt+0x36>
  800514:	3781                	addiw	a5,a5,-32
  800516:	05e00713          	li	a4,94
  80051a:	fcf777e3          	bgeu	a4,a5,8004e8 <vprintfmt+0x1fe>
  80051e:	03f00513          	li	a0,63
  800522:	864e                	mv	a2,s3
  800524:	85ca                	mv	a1,s2
  800526:	9482                	jalr	s1
  800528:	000ac783          	lbu	a5,0(s5)
  80052c:	0a85                	addi	s5,s5,1
  80052e:	3dfd                	addiw	s11,s11,-1
  800530:	0007851b          	sext.w	a0,a5
  800534:	d7e1                	beqz	a5,8004fc <vprintfmt+0x212>
  800536:	fa0d54e3          	bgez	s10,8004de <vprintfmt+0x1f4>
  80053a:	bfe9                	j	800514 <vprintfmt+0x22a>
  80053c:	000aa783          	lw	a5,0(s5)
  800540:	46e1                	li	a3,24
  800542:	0aa1                	addi	s5,s5,8
  800544:	41f7d71b          	sraiw	a4,a5,0x1f
  800548:	8fb9                	xor	a5,a5,a4
  80054a:	40e7873b          	subw	a4,a5,a4
  80054e:	02e6c663          	blt	a3,a4,80057a <vprintfmt+0x290>
  800552:	00000797          	auipc	a5,0x0
  800556:	78678793          	addi	a5,a5,1926 # 800cd8 <error_string>
  80055a:	00371693          	slli	a3,a4,0x3
  80055e:	97b6                	add	a5,a5,a3
  800560:	639c                	ld	a5,0(a5)
  800562:	cf81                	beqz	a5,80057a <vprintfmt+0x290>
  800564:	873e                	mv	a4,a5
  800566:	00000697          	auipc	a3,0x0
  80056a:	30268693          	addi	a3,a3,770 # 800868 <main+0x1c8>
  80056e:	864a                	mv	a2,s2
  800570:	85ce                	mv	a1,s3
  800572:	8526                	mv	a0,s1
  800574:	0f2000ef          	jal	800666 <printfmt>
  800578:	b365                	j	800320 <vprintfmt+0x36>
  80057a:	00000697          	auipc	a3,0x0
  80057e:	2de68693          	addi	a3,a3,734 # 800858 <main+0x1b8>
  800582:	864a                	mv	a2,s2
  800584:	85ce                	mv	a1,s3
  800586:	8526                	mv	a0,s1
  800588:	0de000ef          	jal	800666 <printfmt>
  80058c:	bb51                	j	800320 <vprintfmt+0x36>
  80058e:	4785                	li	a5,1
  800590:	008a8c13          	addi	s8,s5,8
  800594:	00b7c363          	blt	a5,a1,80059a <vprintfmt+0x2b0>
  800598:	cd81                	beqz	a1,8005b0 <vprintfmt+0x2c6>
  80059a:	000ab403          	ld	s0,0(s5)
  80059e:	02044b63          	bltz	s0,8005d4 <vprintfmt+0x2ea>
  8005a2:	86a2                	mv	a3,s0
  8005a4:	8ae2                	mv	s5,s8
  8005a6:	4729                	li	a4,10
  8005a8:	b5a5                	j	800410 <vprintfmt+0x126>
  8005aa:	2585                	addiw	a1,a1,1
  8005ac:	8466                	mv	s0,s9
  8005ae:	bb71                	j	80034a <vprintfmt+0x60>
  8005b0:	000aa403          	lw	s0,0(s5)
  8005b4:	b7ed                	j	80059e <vprintfmt+0x2b4>
  8005b6:	000ae683          	lwu	a3,0(s5)
  8005ba:	4721                	li	a4,8
  8005bc:	8ab2                	mv	s5,a2
  8005be:	bd89                	j	800410 <vprintfmt+0x126>
  8005c0:	000ae683          	lwu	a3,0(s5)
  8005c4:	4729                	li	a4,10
  8005c6:	8ab2                	mv	s5,a2
  8005c8:	b5a1                	j	800410 <vprintfmt+0x126>
  8005ca:	000ae683          	lwu	a3,0(s5)
  8005ce:	4741                	li	a4,16
  8005d0:	8ab2                	mv	s5,a2
  8005d2:	bd3d                	j	800410 <vprintfmt+0x126>
  8005d4:	864e                	mv	a2,s3
  8005d6:	85ca                	mv	a1,s2
  8005d8:	02d00513          	li	a0,45
  8005dc:	e042                	sd	a6,0(sp)
  8005de:	9482                	jalr	s1
  8005e0:	6802                	ld	a6,0(sp)
  8005e2:	408006b3          	neg	a3,s0
  8005e6:	8ae2                	mv	s5,s8
  8005e8:	4729                	li	a4,10
  8005ea:	b51d                	j	800410 <vprintfmt+0x126>
  8005ec:	eba1                	bnez	a5,80063c <vprintfmt+0x352>
  8005ee:	02800793          	li	a5,40
  8005f2:	853e                	mv	a0,a5
  8005f4:	00000a97          	auipc	s5,0x0
  8005f8:	25da8a93          	addi	s5,s5,605 # 800851 <main+0x1b1>
  8005fc:	547d                	li	s0,-1
  8005fe:	bdf1                	j	8004da <vprintfmt+0x1f0>
  800600:	853a                	mv	a0,a4
  800602:	85ea                	mv	a1,s10
  800604:	e03a                	sd	a4,0(sp)
  800606:	07e000ef          	jal	800684 <strnlen>
  80060a:	40ad8dbb          	subw	s11,s11,a0
  80060e:	6702                	ld	a4,0(sp)
  800610:	01b05b63          	blez	s11,800626 <vprintfmt+0x33c>
  800614:	864e                	mv	a2,s3
  800616:	85ca                	mv	a1,s2
  800618:	8522                	mv	a0,s0
  80061a:	e03a                	sd	a4,0(sp)
  80061c:	3dfd                	addiw	s11,s11,-1
  80061e:	9482                	jalr	s1
  800620:	6702                	ld	a4,0(sp)
  800622:	fe0d99e3          	bnez	s11,800614 <vprintfmt+0x32a>
  800626:	00074783          	lbu	a5,0(a4)
  80062a:	0007851b          	sext.w	a0,a5
  80062e:	ee0781e3          	beqz	a5,800510 <vprintfmt+0x226>
  800632:	00170a93          	addi	s5,a4,1
  800636:	b54d                	j	8004d8 <vprintfmt+0x1ee>
  800638:	8466                	mv	s0,s9
  80063a:	b36d                	j	8003e4 <vprintfmt+0xfa>
  80063c:	85ea                	mv	a1,s10
  80063e:	00000517          	auipc	a0,0x0
  800642:	21250513          	addi	a0,a0,530 # 800850 <main+0x1b0>
  800646:	03e000ef          	jal	800684 <strnlen>
  80064a:	40ad8dbb          	subw	s11,s11,a0
  80064e:	02800793          	li	a5,40
  800652:	00000717          	auipc	a4,0x0
  800656:	1fe70713          	addi	a4,a4,510 # 800850 <main+0x1b0>
  80065a:	853e                	mv	a0,a5
  80065c:	fbb04ce3          	bgtz	s11,800614 <vprintfmt+0x32a>
  800660:	00170a93          	addi	s5,a4,1
  800664:	bd95                	j	8004d8 <vprintfmt+0x1ee>

0000000000800666 <printfmt>:
  800666:	7139                	addi	sp,sp,-64
  800668:	02010313          	addi	t1,sp,32
  80066c:	f03a                	sd	a4,32(sp)
  80066e:	871a                	mv	a4,t1
  800670:	ec06                	sd	ra,24(sp)
  800672:	f43e                	sd	a5,40(sp)
  800674:	f842                	sd	a6,48(sp)
  800676:	fc46                	sd	a7,56(sp)
  800678:	e41a                	sd	t1,8(sp)
  80067a:	c71ff0ef          	jal	8002ea <vprintfmt>
  80067e:	60e2                	ld	ra,24(sp)
  800680:	6121                	addi	sp,sp,64
  800682:	8082                	ret

0000000000800684 <strnlen>:
  800684:	4781                	li	a5,0
  800686:	e589                	bnez	a1,800690 <strnlen+0xc>
  800688:	a811                	j	80069c <strnlen+0x18>
  80068a:	0785                	addi	a5,a5,1
  80068c:	00f58863          	beq	a1,a5,80069c <strnlen+0x18>
  800690:	00f50733          	add	a4,a0,a5
  800694:	00074703          	lbu	a4,0(a4)
  800698:	fb6d                	bnez	a4,80068a <strnlen+0x6>
  80069a:	85be                	mv	a1,a5
  80069c:	852e                	mv	a0,a1
  80069e:	8082                	ret

00000000008006a0 <main>:
  8006a0:	1141                	addi	sp,sp,-16
  8006a2:	00000517          	auipc	a0,0x0
  8006a6:	3a650513          	addi	a0,a0,934 # 800a48 <main+0x3a8>
  8006aa:	e406                	sd	ra,8(sp)
  8006ac:	e022                	sd	s0,0(sp)
  8006ae:	a47ff0ef          	jal	8000f4 <cprintf>
  8006b2:	b0bff0ef          	jal	8001bc <fork>
  8006b6:	e901                	bnez	a0,8006c6 <main+0x26>
  8006b8:	00000517          	auipc	a0,0x0
  8006bc:	3b850513          	addi	a0,a0,952 # 800a70 <main+0x3d0>
  8006c0:	a35ff0ef          	jal	8000f4 <cprintf>
  8006c4:	a001                	j	8006c4 <main+0x24>
  8006c6:	842a                	mv	s0,a0
  8006c8:	00000517          	auipc	a0,0x0
  8006cc:	3c850513          	addi	a0,a0,968 # 800a90 <main+0x3f0>
  8006d0:	a25ff0ef          	jal	8000f4 <cprintf>
  8006d4:	aedff0ef          	jal	8001c0 <yield>
  8006d8:	ae9ff0ef          	jal	8001c0 <yield>
  8006dc:	ae5ff0ef          	jal	8001c0 <yield>
  8006e0:	00000517          	auipc	a0,0x0
  8006e4:	3d850513          	addi	a0,a0,984 # 800ab8 <main+0x418>
  8006e8:	a0dff0ef          	jal	8000f4 <cprintf>
  8006ec:	8522                	mv	a0,s0
  8006ee:	ad5ff0ef          	jal	8001c2 <kill>
  8006f2:	ed31                	bnez	a0,80074e <main+0xae>
  8006f4:	4581                	li	a1,0
  8006f6:	00000517          	auipc	a0,0x0
  8006fa:	42a50513          	addi	a0,a0,1066 # 800b20 <main+0x480>
  8006fe:	9f7ff0ef          	jal	8000f4 <cprintf>
  800702:	8522                	mv	a0,s0
  800704:	4581                	li	a1,0
  800706:	ab9ff0ef          	jal	8001be <waitpid>
  80070a:	e11d                	bnez	a0,800730 <main+0x90>
  80070c:	4581                	li	a1,0
  80070e:	00000517          	auipc	a0,0x0
  800712:	44a50513          	addi	a0,a0,1098 # 800b58 <main+0x4b8>
  800716:	9dfff0ef          	jal	8000f4 <cprintf>
  80071a:	00000517          	auipc	a0,0x0
  80071e:	45650513          	addi	a0,a0,1110 # 800b70 <main+0x4d0>
  800722:	9d3ff0ef          	jal	8000f4 <cprintf>
  800726:	60a2                	ld	ra,8(sp)
  800728:	6402                	ld	s0,0(sp)
  80072a:	4501                	li	a0,0
  80072c:	0141                	addi	sp,sp,16
  80072e:	8082                	ret
  800730:	00000697          	auipc	a3,0x0
  800734:	40868693          	addi	a3,a3,1032 # 800b38 <main+0x498>
  800738:	00000617          	auipc	a2,0x0
  80073c:	3c060613          	addi	a2,a2,960 # 800af8 <main+0x458>
  800740:	45dd                	li	a1,23
  800742:	00000517          	auipc	a0,0x0
  800746:	3ce50513          	addi	a0,a0,974 # 800b10 <main+0x470>
  80074a:	8e7ff0ef          	jal	800030 <__panic>
  80074e:	00000697          	auipc	a3,0x0
  800752:	39268693          	addi	a3,a3,914 # 800ae0 <main+0x440>
  800756:	00000617          	auipc	a2,0x0
  80075a:	3a260613          	addi	a2,a2,930 # 800af8 <main+0x458>
  80075e:	45d1                	li	a1,20
  800760:	00000517          	auipc	a0,0x0
  800764:	3b050513          	addi	a0,a0,944 # 800b10 <main+0x470>
  800768:	8c9ff0ef          	jal	800030 <__panic>
