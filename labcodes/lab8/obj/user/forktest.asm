
obj/__user_forktest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aab1                	j	800180 <sys_open>

0000000000800026 <close>:
  800026:	a295                	j	80018a <sys_close>

0000000000800028 <dup2>:
  800028:	a2ad                	j	800192 <sys_dup>

000000000080002a <_start>:
  80002a:	1d2000ef          	jal	8001fc <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	70250513          	addi	a0,a0,1794 # 800740 <main+0xaa>
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
  800064:	70050513          	addi	a0,a0,1792 # 800760 <main+0xca>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	12e000ef          	jal	80019c <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	6e850513          	addi	a0,a0,1768 # 800768 <main+0xd2>
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
  8000a6:	6be50513          	addi	a0,a0,1726 # 800760 <main+0xca>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0be000ef          	jal	80017a <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ee9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	1f8000ef          	jal	8002e0 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ee9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1be000ef          	jal	8002e0 <vprintfmt>
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

000000000080017a <sys_putc>:
  80017a:	85aa                	mv	a1,a0
  80017c:	4579                	li	a0,30
  80017e:	bf45                	j	80012e <syscall>

0000000000800180 <sys_open>:
  800180:	862e                	mv	a2,a1
  800182:	85aa                	mv	a1,a0
  800184:	06400513          	li	a0,100
  800188:	b75d                	j	80012e <syscall>

000000000080018a <sys_close>:
  80018a:	85aa                	mv	a1,a0
  80018c:	06500513          	li	a0,101
  800190:	bf79                	j	80012e <syscall>

0000000000800192 <sys_dup>:
  800192:	862e                	mv	a2,a1
  800194:	85aa                	mv	a1,a0
  800196:	08200513          	li	a0,130
  80019a:	bf51                	j	80012e <syscall>

000000000080019c <exit>:
  80019c:	1141                	addi	sp,sp,-16
  80019e:	e406                	sd	ra,8(sp)
  8001a0:	fc9ff0ef          	jal	800168 <sys_exit>
  8001a4:	00000517          	auipc	a0,0x0
  8001a8:	5e450513          	addi	a0,a0,1508 # 800788 <main+0xf2>
  8001ac:	f49ff0ef          	jal	8000f4 <cprintf>
  8001b0:	a001                	j	8001b0 <exit+0x14>

00000000008001b2 <fork>:
  8001b2:	bf75                	j	80016e <sys_fork>

00000000008001b4 <wait>:
  8001b4:	4581                	li	a1,0
  8001b6:	4501                	li	a0,0
  8001b8:	bf6d                	j	800172 <sys_wait>

00000000008001ba <initfd>:
  8001ba:	87ae                	mv	a5,a1
  8001bc:	1101                	addi	sp,sp,-32
  8001be:	e822                	sd	s0,16(sp)
  8001c0:	85b2                	mv	a1,a2
  8001c2:	842a                	mv	s0,a0
  8001c4:	853e                	mv	a0,a5
  8001c6:	ec06                	sd	ra,24(sp)
  8001c8:	e59ff0ef          	jal	800020 <open>
  8001cc:	87aa                	mv	a5,a0
  8001ce:	00054463          	bltz	a0,8001d6 <initfd+0x1c>
  8001d2:	00851763          	bne	a0,s0,8001e0 <initfd+0x26>
  8001d6:	60e2                	ld	ra,24(sp)
  8001d8:	6442                	ld	s0,16(sp)
  8001da:	853e                	mv	a0,a5
  8001dc:	6105                	addi	sp,sp,32
  8001de:	8082                	ret
  8001e0:	e42a                	sd	a0,8(sp)
  8001e2:	8522                	mv	a0,s0
  8001e4:	e43ff0ef          	jal	800026 <close>
  8001e8:	6522                	ld	a0,8(sp)
  8001ea:	85a2                	mv	a1,s0
  8001ec:	e3dff0ef          	jal	800028 <dup2>
  8001f0:	842a                	mv	s0,a0
  8001f2:	6522                	ld	a0,8(sp)
  8001f4:	e33ff0ef          	jal	800026 <close>
  8001f8:	87a2                	mv	a5,s0
  8001fa:	bff1                	j	8001d6 <initfd+0x1c>

00000000008001fc <umain>:
  8001fc:	1101                	addi	sp,sp,-32
  8001fe:	e822                	sd	s0,16(sp)
  800200:	e426                	sd	s1,8(sp)
  800202:	842a                	mv	s0,a0
  800204:	84ae                	mv	s1,a1
  800206:	4601                	li	a2,0
  800208:	00000597          	auipc	a1,0x0
  80020c:	59858593          	addi	a1,a1,1432 # 8007a0 <main+0x10a>
  800210:	4501                	li	a0,0
  800212:	ec06                	sd	ra,24(sp)
  800214:	fa7ff0ef          	jal	8001ba <initfd>
  800218:	02054263          	bltz	a0,80023c <umain+0x40>
  80021c:	4605                	li	a2,1
  80021e:	8532                	mv	a0,a2
  800220:	00000597          	auipc	a1,0x0
  800224:	5c058593          	addi	a1,a1,1472 # 8007e0 <main+0x14a>
  800228:	f93ff0ef          	jal	8001ba <initfd>
  80022c:	02054563          	bltz	a0,800256 <umain+0x5a>
  800230:	85a6                	mv	a1,s1
  800232:	8522                	mv	a0,s0
  800234:	462000ef          	jal	800696 <main>
  800238:	f65ff0ef          	jal	80019c <exit>
  80023c:	86aa                	mv	a3,a0
  80023e:	00000617          	auipc	a2,0x0
  800242:	56a60613          	addi	a2,a2,1386 # 8007a8 <main+0x112>
  800246:	45e9                	li	a1,26
  800248:	00000517          	auipc	a0,0x0
  80024c:	58050513          	addi	a0,a0,1408 # 8007c8 <main+0x132>
  800250:	e23ff0ef          	jal	800072 <__warn>
  800254:	b7e1                	j	80021c <umain+0x20>
  800256:	86aa                	mv	a3,a0
  800258:	00000617          	auipc	a2,0x0
  80025c:	59060613          	addi	a2,a2,1424 # 8007e8 <main+0x152>
  800260:	45f5                	li	a1,29
  800262:	00000517          	auipc	a0,0x0
  800266:	56650513          	addi	a0,a0,1382 # 8007c8 <main+0x132>
  80026a:	e09ff0ef          	jal	800072 <__warn>
  80026e:	b7c9                	j	800230 <umain+0x34>

0000000000800270 <printnum>:
  800270:	7139                	addi	sp,sp,-64
  800272:	02071893          	slli	a7,a4,0x20
  800276:	f822                	sd	s0,48(sp)
  800278:	f426                	sd	s1,40(sp)
  80027a:	f04a                	sd	s2,32(sp)
  80027c:	ec4e                	sd	s3,24(sp)
  80027e:	e456                	sd	s5,8(sp)
  800280:	0208d893          	srli	a7,a7,0x20
  800284:	fc06                	sd	ra,56(sp)
  800286:	0316fab3          	remu	s5,a3,a7
  80028a:	fff7841b          	addiw	s0,a5,-1
  80028e:	84aa                	mv	s1,a0
  800290:	89ae                	mv	s3,a1
  800292:	8932                	mv	s2,a2
  800294:	0516f063          	bgeu	a3,a7,8002d4 <printnum+0x64>
  800298:	e852                	sd	s4,16(sp)
  80029a:	4705                	li	a4,1
  80029c:	8a42                	mv	s4,a6
  80029e:	00f75863          	bge	a4,a5,8002ae <printnum+0x3e>
  8002a2:	864e                	mv	a2,s3
  8002a4:	85ca                	mv	a1,s2
  8002a6:	8552                	mv	a0,s4
  8002a8:	347d                	addiw	s0,s0,-1
  8002aa:	9482                	jalr	s1
  8002ac:	f87d                	bnez	s0,8002a2 <printnum+0x32>
  8002ae:	6a42                	ld	s4,16(sp)
  8002b0:	00000797          	auipc	a5,0x0
  8002b4:	55878793          	addi	a5,a5,1368 # 800808 <main+0x172>
  8002b8:	97d6                	add	a5,a5,s5
  8002ba:	7442                	ld	s0,48(sp)
  8002bc:	0007c503          	lbu	a0,0(a5)
  8002c0:	70e2                	ld	ra,56(sp)
  8002c2:	6aa2                	ld	s5,8(sp)
  8002c4:	864e                	mv	a2,s3
  8002c6:	85ca                	mv	a1,s2
  8002c8:	69e2                	ld	s3,24(sp)
  8002ca:	7902                	ld	s2,32(sp)
  8002cc:	87a6                	mv	a5,s1
  8002ce:	74a2                	ld	s1,40(sp)
  8002d0:	6121                	addi	sp,sp,64
  8002d2:	8782                	jr	a5
  8002d4:	0316d6b3          	divu	a3,a3,a7
  8002d8:	87a2                	mv	a5,s0
  8002da:	f97ff0ef          	jal	800270 <printnum>
  8002de:	bfc9                	j	8002b0 <printnum+0x40>

00000000008002e0 <vprintfmt>:
  8002e0:	7119                	addi	sp,sp,-128
  8002e2:	f4a6                	sd	s1,104(sp)
  8002e4:	f0ca                	sd	s2,96(sp)
  8002e6:	ecce                	sd	s3,88(sp)
  8002e8:	e8d2                	sd	s4,80(sp)
  8002ea:	e4d6                	sd	s5,72(sp)
  8002ec:	e0da                	sd	s6,64(sp)
  8002ee:	fc5e                	sd	s7,56(sp)
  8002f0:	f466                	sd	s9,40(sp)
  8002f2:	fc86                	sd	ra,120(sp)
  8002f4:	f8a2                	sd	s0,112(sp)
  8002f6:	f862                	sd	s8,48(sp)
  8002f8:	f06a                	sd	s10,32(sp)
  8002fa:	ec6e                	sd	s11,24(sp)
  8002fc:	84aa                	mv	s1,a0
  8002fe:	8cb6                	mv	s9,a3
  800300:	8aba                	mv	s5,a4
  800302:	89ae                	mv	s3,a1
  800304:	8932                	mv	s2,a2
  800306:	02500a13          	li	s4,37
  80030a:	05500b93          	li	s7,85
  80030e:	00000b17          	auipc	s6,0x0
  800312:	78ab0b13          	addi	s6,s6,1930 # 800a98 <main+0x402>
  800316:	000cc503          	lbu	a0,0(s9)
  80031a:	001c8413          	addi	s0,s9,1
  80031e:	01450b63          	beq	a0,s4,800334 <vprintfmt+0x54>
  800322:	cd15                	beqz	a0,80035e <vprintfmt+0x7e>
  800324:	864e                	mv	a2,s3
  800326:	85ca                	mv	a1,s2
  800328:	9482                	jalr	s1
  80032a:	00044503          	lbu	a0,0(s0)
  80032e:	0405                	addi	s0,s0,1
  800330:	ff4519e3          	bne	a0,s4,800322 <vprintfmt+0x42>
  800334:	5d7d                	li	s10,-1
  800336:	8dea                	mv	s11,s10
  800338:	02000813          	li	a6,32
  80033c:	4c01                	li	s8,0
  80033e:	4581                	li	a1,0
  800340:	00044703          	lbu	a4,0(s0)
  800344:	00140c93          	addi	s9,s0,1
  800348:	fdd7061b          	addiw	a2,a4,-35
  80034c:	0ff67613          	zext.b	a2,a2
  800350:	02cbe663          	bltu	s7,a2,80037c <vprintfmt+0x9c>
  800354:	060a                	slli	a2,a2,0x2
  800356:	965a                	add	a2,a2,s6
  800358:	421c                	lw	a5,0(a2)
  80035a:	97da                	add	a5,a5,s6
  80035c:	8782                	jr	a5
  80035e:	70e6                	ld	ra,120(sp)
  800360:	7446                	ld	s0,112(sp)
  800362:	74a6                	ld	s1,104(sp)
  800364:	7906                	ld	s2,96(sp)
  800366:	69e6                	ld	s3,88(sp)
  800368:	6a46                	ld	s4,80(sp)
  80036a:	6aa6                	ld	s5,72(sp)
  80036c:	6b06                	ld	s6,64(sp)
  80036e:	7be2                	ld	s7,56(sp)
  800370:	7c42                	ld	s8,48(sp)
  800372:	7ca2                	ld	s9,40(sp)
  800374:	7d02                	ld	s10,32(sp)
  800376:	6de2                	ld	s11,24(sp)
  800378:	6109                	addi	sp,sp,128
  80037a:	8082                	ret
  80037c:	864e                	mv	a2,s3
  80037e:	85ca                	mv	a1,s2
  800380:	02500513          	li	a0,37
  800384:	9482                	jalr	s1
  800386:	fff44783          	lbu	a5,-1(s0)
  80038a:	02500713          	li	a4,37
  80038e:	8ca2                	mv	s9,s0
  800390:	f8e783e3          	beq	a5,a4,800316 <vprintfmt+0x36>
  800394:	ffecc783          	lbu	a5,-2(s9)
  800398:	1cfd                	addi	s9,s9,-1
  80039a:	fee79de3          	bne	a5,a4,800394 <vprintfmt+0xb4>
  80039e:	bfa5                	j	800316 <vprintfmt+0x36>
  8003a0:	00144683          	lbu	a3,1(s0)
  8003a4:	4525                	li	a0,9
  8003a6:	fd070d1b          	addiw	s10,a4,-48
  8003aa:	fd06879b          	addiw	a5,a3,-48
  8003ae:	28f56063          	bltu	a0,a5,80062e <vprintfmt+0x34e>
  8003b2:	2681                	sext.w	a3,a3
  8003b4:	8466                	mv	s0,s9
  8003b6:	002d179b          	slliw	a5,s10,0x2
  8003ba:	00144703          	lbu	a4,1(s0)
  8003be:	01a787bb          	addw	a5,a5,s10
  8003c2:	0017979b          	slliw	a5,a5,0x1
  8003c6:	9fb5                	addw	a5,a5,a3
  8003c8:	fd07061b          	addiw	a2,a4,-48
  8003cc:	0405                	addi	s0,s0,1
  8003ce:	fd078d1b          	addiw	s10,a5,-48
  8003d2:	0007069b          	sext.w	a3,a4
  8003d6:	fec570e3          	bgeu	a0,a2,8003b6 <vprintfmt+0xd6>
  8003da:	f60dd3e3          	bgez	s11,800340 <vprintfmt+0x60>
  8003de:	8dea                	mv	s11,s10
  8003e0:	5d7d                	li	s10,-1
  8003e2:	bfb9                	j	800340 <vprintfmt+0x60>
  8003e4:	883a                	mv	a6,a4
  8003e6:	8466                	mv	s0,s9
  8003e8:	bfa1                	j	800340 <vprintfmt+0x60>
  8003ea:	8466                	mv	s0,s9
  8003ec:	4c05                	li	s8,1
  8003ee:	bf89                	j	800340 <vprintfmt+0x60>
  8003f0:	4785                	li	a5,1
  8003f2:	008a8613          	addi	a2,s5,8
  8003f6:	00b7c463          	blt	a5,a1,8003fe <vprintfmt+0x11e>
  8003fa:	1c058363          	beqz	a1,8005c0 <vprintfmt+0x2e0>
  8003fe:	000ab683          	ld	a3,0(s5)
  800402:	4741                	li	a4,16
  800404:	8ab2                	mv	s5,a2
  800406:	2801                	sext.w	a6,a6
  800408:	87ee                	mv	a5,s11
  80040a:	864a                	mv	a2,s2
  80040c:	85ce                	mv	a1,s3
  80040e:	8526                	mv	a0,s1
  800410:	e61ff0ef          	jal	800270 <printnum>
  800414:	b709                	j	800316 <vprintfmt+0x36>
  800416:	000aa503          	lw	a0,0(s5)
  80041a:	864e                	mv	a2,s3
  80041c:	85ca                	mv	a1,s2
  80041e:	9482                	jalr	s1
  800420:	0aa1                	addi	s5,s5,8
  800422:	bdd5                	j	800316 <vprintfmt+0x36>
  800424:	4785                	li	a5,1
  800426:	008a8613          	addi	a2,s5,8
  80042a:	00b7c463          	blt	a5,a1,800432 <vprintfmt+0x152>
  80042e:	18058463          	beqz	a1,8005b6 <vprintfmt+0x2d6>
  800432:	000ab683          	ld	a3,0(s5)
  800436:	4729                	li	a4,10
  800438:	8ab2                	mv	s5,a2
  80043a:	b7f1                	j	800406 <vprintfmt+0x126>
  80043c:	864e                	mv	a2,s3
  80043e:	85ca                	mv	a1,s2
  800440:	03000513          	li	a0,48
  800444:	e042                	sd	a6,0(sp)
  800446:	9482                	jalr	s1
  800448:	864e                	mv	a2,s3
  80044a:	85ca                	mv	a1,s2
  80044c:	07800513          	li	a0,120
  800450:	9482                	jalr	s1
  800452:	000ab683          	ld	a3,0(s5)
  800456:	6802                	ld	a6,0(sp)
  800458:	4741                	li	a4,16
  80045a:	0aa1                	addi	s5,s5,8
  80045c:	b76d                	j	800406 <vprintfmt+0x126>
  80045e:	864e                	mv	a2,s3
  800460:	85ca                	mv	a1,s2
  800462:	02500513          	li	a0,37
  800466:	9482                	jalr	s1
  800468:	b57d                	j	800316 <vprintfmt+0x36>
  80046a:	000aad03          	lw	s10,0(s5)
  80046e:	8466                	mv	s0,s9
  800470:	0aa1                	addi	s5,s5,8
  800472:	b7a5                	j	8003da <vprintfmt+0xfa>
  800474:	4785                	li	a5,1
  800476:	008a8613          	addi	a2,s5,8
  80047a:	00b7c463          	blt	a5,a1,800482 <vprintfmt+0x1a2>
  80047e:	12058763          	beqz	a1,8005ac <vprintfmt+0x2cc>
  800482:	000ab683          	ld	a3,0(s5)
  800486:	4721                	li	a4,8
  800488:	8ab2                	mv	s5,a2
  80048a:	bfb5                	j	800406 <vprintfmt+0x126>
  80048c:	87ee                	mv	a5,s11
  80048e:	000dd363          	bgez	s11,800494 <vprintfmt+0x1b4>
  800492:	4781                	li	a5,0
  800494:	00078d9b          	sext.w	s11,a5
  800498:	8466                	mv	s0,s9
  80049a:	b55d                	j	800340 <vprintfmt+0x60>
  80049c:	0008041b          	sext.w	s0,a6
  8004a0:	fd340793          	addi	a5,s0,-45
  8004a4:	01b02733          	sgtz	a4,s11
  8004a8:	00f037b3          	snez	a5,a5
  8004ac:	8ff9                	and	a5,a5,a4
  8004ae:	000ab703          	ld	a4,0(s5)
  8004b2:	008a8693          	addi	a3,s5,8
  8004b6:	e436                	sd	a3,8(sp)
  8004b8:	12070563          	beqz	a4,8005e2 <vprintfmt+0x302>
  8004bc:	12079d63          	bnez	a5,8005f6 <vprintfmt+0x316>
  8004c0:	00074783          	lbu	a5,0(a4)
  8004c4:	0007851b          	sext.w	a0,a5
  8004c8:	c78d                	beqz	a5,8004f2 <vprintfmt+0x212>
  8004ca:	00170a93          	addi	s5,a4,1
  8004ce:	547d                	li	s0,-1
  8004d0:	000d4563          	bltz	s10,8004da <vprintfmt+0x1fa>
  8004d4:	3d7d                	addiw	s10,s10,-1
  8004d6:	008d0e63          	beq	s10,s0,8004f2 <vprintfmt+0x212>
  8004da:	020c1863          	bnez	s8,80050a <vprintfmt+0x22a>
  8004de:	864e                	mv	a2,s3
  8004e0:	85ca                	mv	a1,s2
  8004e2:	9482                	jalr	s1
  8004e4:	000ac783          	lbu	a5,0(s5)
  8004e8:	0a85                	addi	s5,s5,1
  8004ea:	3dfd                	addiw	s11,s11,-1
  8004ec:	0007851b          	sext.w	a0,a5
  8004f0:	f3e5                	bnez	a5,8004d0 <vprintfmt+0x1f0>
  8004f2:	01b05a63          	blez	s11,800506 <vprintfmt+0x226>
  8004f6:	864e                	mv	a2,s3
  8004f8:	85ca                	mv	a1,s2
  8004fa:	02000513          	li	a0,32
  8004fe:	3dfd                	addiw	s11,s11,-1
  800500:	9482                	jalr	s1
  800502:	fe0d9ae3          	bnez	s11,8004f6 <vprintfmt+0x216>
  800506:	6aa2                	ld	s5,8(sp)
  800508:	b539                	j	800316 <vprintfmt+0x36>
  80050a:	3781                	addiw	a5,a5,-32
  80050c:	05e00713          	li	a4,94
  800510:	fcf777e3          	bgeu	a4,a5,8004de <vprintfmt+0x1fe>
  800514:	03f00513          	li	a0,63
  800518:	864e                	mv	a2,s3
  80051a:	85ca                	mv	a1,s2
  80051c:	9482                	jalr	s1
  80051e:	000ac783          	lbu	a5,0(s5)
  800522:	0a85                	addi	s5,s5,1
  800524:	3dfd                	addiw	s11,s11,-1
  800526:	0007851b          	sext.w	a0,a5
  80052a:	d7e1                	beqz	a5,8004f2 <vprintfmt+0x212>
  80052c:	fa0d54e3          	bgez	s10,8004d4 <vprintfmt+0x1f4>
  800530:	bfe9                	j	80050a <vprintfmt+0x22a>
  800532:	000aa783          	lw	a5,0(s5)
  800536:	46e1                	li	a3,24
  800538:	0aa1                	addi	s5,s5,8
  80053a:	41f7d71b          	sraiw	a4,a5,0x1f
  80053e:	8fb9                	xor	a5,a5,a4
  800540:	40e7873b          	subw	a4,a5,a4
  800544:	02e6c663          	blt	a3,a4,800570 <vprintfmt+0x290>
  800548:	00000797          	auipc	a5,0x0
  80054c:	6a878793          	addi	a5,a5,1704 # 800bf0 <error_string>
  800550:	00371693          	slli	a3,a4,0x3
  800554:	97b6                	add	a5,a5,a3
  800556:	639c                	ld	a5,0(a5)
  800558:	cf81                	beqz	a5,800570 <vprintfmt+0x290>
  80055a:	873e                	mv	a4,a5
  80055c:	00000697          	auipc	a3,0x0
  800560:	2dc68693          	addi	a3,a3,732 # 800838 <main+0x1a2>
  800564:	864a                	mv	a2,s2
  800566:	85ce                	mv	a1,s3
  800568:	8526                	mv	a0,s1
  80056a:	0f2000ef          	jal	80065c <printfmt>
  80056e:	b365                	j	800316 <vprintfmt+0x36>
  800570:	00000697          	auipc	a3,0x0
  800574:	2b868693          	addi	a3,a3,696 # 800828 <main+0x192>
  800578:	864a                	mv	a2,s2
  80057a:	85ce                	mv	a1,s3
  80057c:	8526                	mv	a0,s1
  80057e:	0de000ef          	jal	80065c <printfmt>
  800582:	bb51                	j	800316 <vprintfmt+0x36>
  800584:	4785                	li	a5,1
  800586:	008a8c13          	addi	s8,s5,8
  80058a:	00b7c363          	blt	a5,a1,800590 <vprintfmt+0x2b0>
  80058e:	cd81                	beqz	a1,8005a6 <vprintfmt+0x2c6>
  800590:	000ab403          	ld	s0,0(s5)
  800594:	02044b63          	bltz	s0,8005ca <vprintfmt+0x2ea>
  800598:	86a2                	mv	a3,s0
  80059a:	8ae2                	mv	s5,s8
  80059c:	4729                	li	a4,10
  80059e:	b5a5                	j	800406 <vprintfmt+0x126>
  8005a0:	2585                	addiw	a1,a1,1
  8005a2:	8466                	mv	s0,s9
  8005a4:	bb71                	j	800340 <vprintfmt+0x60>
  8005a6:	000aa403          	lw	s0,0(s5)
  8005aa:	b7ed                	j	800594 <vprintfmt+0x2b4>
  8005ac:	000ae683          	lwu	a3,0(s5)
  8005b0:	4721                	li	a4,8
  8005b2:	8ab2                	mv	s5,a2
  8005b4:	bd89                	j	800406 <vprintfmt+0x126>
  8005b6:	000ae683          	lwu	a3,0(s5)
  8005ba:	4729                	li	a4,10
  8005bc:	8ab2                	mv	s5,a2
  8005be:	b5a1                	j	800406 <vprintfmt+0x126>
  8005c0:	000ae683          	lwu	a3,0(s5)
  8005c4:	4741                	li	a4,16
  8005c6:	8ab2                	mv	s5,a2
  8005c8:	bd3d                	j	800406 <vprintfmt+0x126>
  8005ca:	864e                	mv	a2,s3
  8005cc:	85ca                	mv	a1,s2
  8005ce:	02d00513          	li	a0,45
  8005d2:	e042                	sd	a6,0(sp)
  8005d4:	9482                	jalr	s1
  8005d6:	6802                	ld	a6,0(sp)
  8005d8:	408006b3          	neg	a3,s0
  8005dc:	8ae2                	mv	s5,s8
  8005de:	4729                	li	a4,10
  8005e0:	b51d                	j	800406 <vprintfmt+0x126>
  8005e2:	eba1                	bnez	a5,800632 <vprintfmt+0x352>
  8005e4:	02800793          	li	a5,40
  8005e8:	853e                	mv	a0,a5
  8005ea:	00000a97          	auipc	s5,0x0
  8005ee:	237a8a93          	addi	s5,s5,567 # 800821 <main+0x18b>
  8005f2:	547d                	li	s0,-1
  8005f4:	bdf1                	j	8004d0 <vprintfmt+0x1f0>
  8005f6:	853a                	mv	a0,a4
  8005f8:	85ea                	mv	a1,s10
  8005fa:	e03a                	sd	a4,0(sp)
  8005fc:	07e000ef          	jal	80067a <strnlen>
  800600:	40ad8dbb          	subw	s11,s11,a0
  800604:	6702                	ld	a4,0(sp)
  800606:	01b05b63          	blez	s11,80061c <vprintfmt+0x33c>
  80060a:	864e                	mv	a2,s3
  80060c:	85ca                	mv	a1,s2
  80060e:	8522                	mv	a0,s0
  800610:	e03a                	sd	a4,0(sp)
  800612:	3dfd                	addiw	s11,s11,-1
  800614:	9482                	jalr	s1
  800616:	6702                	ld	a4,0(sp)
  800618:	fe0d99e3          	bnez	s11,80060a <vprintfmt+0x32a>
  80061c:	00074783          	lbu	a5,0(a4)
  800620:	0007851b          	sext.w	a0,a5
  800624:	ee0781e3          	beqz	a5,800506 <vprintfmt+0x226>
  800628:	00170a93          	addi	s5,a4,1
  80062c:	b54d                	j	8004ce <vprintfmt+0x1ee>
  80062e:	8466                	mv	s0,s9
  800630:	b36d                	j	8003da <vprintfmt+0xfa>
  800632:	85ea                	mv	a1,s10
  800634:	00000517          	auipc	a0,0x0
  800638:	1ec50513          	addi	a0,a0,492 # 800820 <main+0x18a>
  80063c:	03e000ef          	jal	80067a <strnlen>
  800640:	40ad8dbb          	subw	s11,s11,a0
  800644:	02800793          	li	a5,40
  800648:	00000717          	auipc	a4,0x0
  80064c:	1d870713          	addi	a4,a4,472 # 800820 <main+0x18a>
  800650:	853e                	mv	a0,a5
  800652:	fbb04ce3          	bgtz	s11,80060a <vprintfmt+0x32a>
  800656:	00170a93          	addi	s5,a4,1
  80065a:	bd95                	j	8004ce <vprintfmt+0x1ee>

000000000080065c <printfmt>:
  80065c:	7139                	addi	sp,sp,-64
  80065e:	02010313          	addi	t1,sp,32
  800662:	f03a                	sd	a4,32(sp)
  800664:	871a                	mv	a4,t1
  800666:	ec06                	sd	ra,24(sp)
  800668:	f43e                	sd	a5,40(sp)
  80066a:	f842                	sd	a6,48(sp)
  80066c:	fc46                	sd	a7,56(sp)
  80066e:	e41a                	sd	t1,8(sp)
  800670:	c71ff0ef          	jal	8002e0 <vprintfmt>
  800674:	60e2                	ld	ra,24(sp)
  800676:	6121                	addi	sp,sp,64
  800678:	8082                	ret

000000000080067a <strnlen>:
  80067a:	4781                	li	a5,0
  80067c:	e589                	bnez	a1,800686 <strnlen+0xc>
  80067e:	a811                	j	800692 <strnlen+0x18>
  800680:	0785                	addi	a5,a5,1
  800682:	00f58863          	beq	a1,a5,800692 <strnlen+0x18>
  800686:	00f50733          	add	a4,a0,a5
  80068a:	00074703          	lbu	a4,0(a4)
  80068e:	fb6d                	bnez	a4,800680 <strnlen+0x6>
  800690:	85be                	mv	a1,a5
  800692:	852e                	mv	a0,a1
  800694:	8082                	ret

0000000000800696 <main>:
  800696:	1101                	addi	sp,sp,-32
  800698:	e822                	sd	s0,16(sp)
  80069a:	e426                	sd	s1,8(sp)
  80069c:	ec06                	sd	ra,24(sp)
  80069e:	4401                	li	s0,0
  8006a0:	02000493          	li	s1,32
  8006a4:	b0fff0ef          	jal	8001b2 <fork>
  8006a8:	c915                	beqz	a0,8006dc <main+0x46>
  8006aa:	04a05e63          	blez	a0,800706 <main+0x70>
  8006ae:	2405                	addiw	s0,s0,1
  8006b0:	fe941ae3          	bne	s0,s1,8006a4 <main+0xe>
  8006b4:	b01ff0ef          	jal	8001b4 <wait>
  8006b8:	ed05                	bnez	a0,8006f0 <main+0x5a>
  8006ba:	347d                	addiw	s0,s0,-1
  8006bc:	fc65                	bnez	s0,8006b4 <main+0x1e>
  8006be:	af7ff0ef          	jal	8001b4 <wait>
  8006c2:	c12d                	beqz	a0,800724 <main+0x8e>
  8006c4:	00000517          	auipc	a0,0x0
  8006c8:	3c450513          	addi	a0,a0,964 # 800a88 <main+0x3f2>
  8006cc:	a29ff0ef          	jal	8000f4 <cprintf>
  8006d0:	60e2                	ld	ra,24(sp)
  8006d2:	6442                	ld	s0,16(sp)
  8006d4:	64a2                	ld	s1,8(sp)
  8006d6:	4501                	li	a0,0
  8006d8:	6105                	addi	sp,sp,32
  8006da:	8082                	ret
  8006dc:	85a2                	mv	a1,s0
  8006de:	00000517          	auipc	a0,0x0
  8006e2:	33a50513          	addi	a0,a0,826 # 800a18 <main+0x382>
  8006e6:	a0fff0ef          	jal	8000f4 <cprintf>
  8006ea:	4501                	li	a0,0
  8006ec:	ab1ff0ef          	jal	80019c <exit>
  8006f0:	00000617          	auipc	a2,0x0
  8006f4:	36860613          	addi	a2,a2,872 # 800a58 <main+0x3c2>
  8006f8:	45dd                	li	a1,23
  8006fa:	00000517          	auipc	a0,0x0
  8006fe:	34e50513          	addi	a0,a0,846 # 800a48 <main+0x3b2>
  800702:	92fff0ef          	jal	800030 <__panic>
  800706:	00000697          	auipc	a3,0x0
  80070a:	32268693          	addi	a3,a3,802 # 800a28 <main+0x392>
  80070e:	00000617          	auipc	a2,0x0
  800712:	32260613          	addi	a2,a2,802 # 800a30 <main+0x39a>
  800716:	45b9                	li	a1,14
  800718:	00000517          	auipc	a0,0x0
  80071c:	33050513          	addi	a0,a0,816 # 800a48 <main+0x3b2>
  800720:	911ff0ef          	jal	800030 <__panic>
  800724:	00000617          	auipc	a2,0x0
  800728:	34c60613          	addi	a2,a2,844 # 800a70 <main+0x3da>
  80072c:	45f1                	li	a1,28
  80072e:	00000517          	auipc	a0,0x0
  800732:	31a50513          	addi	a0,a0,794 # 800a48 <main+0x3b2>
  800736:	8fbff0ef          	jal	800030 <__panic>
