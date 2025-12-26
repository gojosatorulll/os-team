
obj/__user_testbss.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa81                	j	800174 <sys_open>

0000000000800026 <close>:
  800026:	aaa1                	j	80017e <sys_close>

0000000000800028 <dup2>:
  800028:	aab9                	j	800186 <sys_dup>

000000000080002a <_start>:
  80002a:	1be000ef          	jal	8001e8 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	70250513          	addi	a0,a0,1794 # 800740 <main+0xbe>
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
  800064:	70050513          	addi	a0,a0,1792 # 800760 <main+0xde>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	122000ef          	jal	800190 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	6e850513          	addi	a0,a0,1768 # 800768 <main+0xe6>
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
  8000a6:	6be50513          	addi	a0,a0,1726 # 800760 <main+0xde>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0b2000ef          	jal	80016e <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <bigarray+0xffffffffff7f5ad9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	1e4000ef          	jal	8002cc <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <bigarray+0xffffffffff7f5ad9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1aa000ef          	jal	8002cc <vprintfmt>
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

000000000080016e <sys_putc>:
  80016e:	85aa                	mv	a1,a0
  800170:	4579                	li	a0,30
  800172:	bf75                	j	80012e <syscall>

0000000000800174 <sys_open>:
  800174:	862e                	mv	a2,a1
  800176:	85aa                	mv	a1,a0
  800178:	06400513          	li	a0,100
  80017c:	bf4d                	j	80012e <syscall>

000000000080017e <sys_close>:
  80017e:	85aa                	mv	a1,a0
  800180:	06500513          	li	a0,101
  800184:	b76d                	j	80012e <syscall>

0000000000800186 <sys_dup>:
  800186:	862e                	mv	a2,a1
  800188:	85aa                	mv	a1,a0
  80018a:	08200513          	li	a0,130
  80018e:	b745                	j	80012e <syscall>

0000000000800190 <exit>:
  800190:	1141                	addi	sp,sp,-16
  800192:	e406                	sd	ra,8(sp)
  800194:	fd5ff0ef          	jal	800168 <sys_exit>
  800198:	00000517          	auipc	a0,0x0
  80019c:	5f050513          	addi	a0,a0,1520 # 800788 <main+0x106>
  8001a0:	f55ff0ef          	jal	8000f4 <cprintf>
  8001a4:	a001                	j	8001a4 <exit+0x14>

00000000008001a6 <initfd>:
  8001a6:	87ae                	mv	a5,a1
  8001a8:	1101                	addi	sp,sp,-32
  8001aa:	e822                	sd	s0,16(sp)
  8001ac:	85b2                	mv	a1,a2
  8001ae:	842a                	mv	s0,a0
  8001b0:	853e                	mv	a0,a5
  8001b2:	ec06                	sd	ra,24(sp)
  8001b4:	e6dff0ef          	jal	800020 <open>
  8001b8:	87aa                	mv	a5,a0
  8001ba:	00054463          	bltz	a0,8001c2 <initfd+0x1c>
  8001be:	00851763          	bne	a0,s0,8001cc <initfd+0x26>
  8001c2:	60e2                	ld	ra,24(sp)
  8001c4:	6442                	ld	s0,16(sp)
  8001c6:	853e                	mv	a0,a5
  8001c8:	6105                	addi	sp,sp,32
  8001ca:	8082                	ret
  8001cc:	e42a                	sd	a0,8(sp)
  8001ce:	8522                	mv	a0,s0
  8001d0:	e57ff0ef          	jal	800026 <close>
  8001d4:	6522                	ld	a0,8(sp)
  8001d6:	85a2                	mv	a1,s0
  8001d8:	e51ff0ef          	jal	800028 <dup2>
  8001dc:	842a                	mv	s0,a0
  8001de:	6522                	ld	a0,8(sp)
  8001e0:	e47ff0ef          	jal	800026 <close>
  8001e4:	87a2                	mv	a5,s0
  8001e6:	bff1                	j	8001c2 <initfd+0x1c>

00000000008001e8 <umain>:
  8001e8:	1101                	addi	sp,sp,-32
  8001ea:	e822                	sd	s0,16(sp)
  8001ec:	e426                	sd	s1,8(sp)
  8001ee:	842a                	mv	s0,a0
  8001f0:	84ae                	mv	s1,a1
  8001f2:	4601                	li	a2,0
  8001f4:	00000597          	auipc	a1,0x0
  8001f8:	5ac58593          	addi	a1,a1,1452 # 8007a0 <main+0x11e>
  8001fc:	4501                	li	a0,0
  8001fe:	ec06                	sd	ra,24(sp)
  800200:	fa7ff0ef          	jal	8001a6 <initfd>
  800204:	02054263          	bltz	a0,800228 <umain+0x40>
  800208:	4605                	li	a2,1
  80020a:	8532                	mv	a0,a2
  80020c:	00000597          	auipc	a1,0x0
  800210:	5d458593          	addi	a1,a1,1492 # 8007e0 <main+0x15e>
  800214:	f93ff0ef          	jal	8001a6 <initfd>
  800218:	02054563          	bltz	a0,800242 <umain+0x5a>
  80021c:	85a6                	mv	a1,s1
  80021e:	8522                	mv	a0,s0
  800220:	462000ef          	jal	800682 <main>
  800224:	f6dff0ef          	jal	800190 <exit>
  800228:	86aa                	mv	a3,a0
  80022a:	00000617          	auipc	a2,0x0
  80022e:	57e60613          	addi	a2,a2,1406 # 8007a8 <main+0x126>
  800232:	45e9                	li	a1,26
  800234:	00000517          	auipc	a0,0x0
  800238:	59450513          	addi	a0,a0,1428 # 8007c8 <main+0x146>
  80023c:	e37ff0ef          	jal	800072 <__warn>
  800240:	b7e1                	j	800208 <umain+0x20>
  800242:	86aa                	mv	a3,a0
  800244:	00000617          	auipc	a2,0x0
  800248:	5a460613          	addi	a2,a2,1444 # 8007e8 <main+0x166>
  80024c:	45f5                	li	a1,29
  80024e:	00000517          	auipc	a0,0x0
  800252:	57a50513          	addi	a0,a0,1402 # 8007c8 <main+0x146>
  800256:	e1dff0ef          	jal	800072 <__warn>
  80025a:	b7c9                	j	80021c <umain+0x34>

000000000080025c <printnum>:
  80025c:	7139                	addi	sp,sp,-64
  80025e:	02071893          	slli	a7,a4,0x20
  800262:	f822                	sd	s0,48(sp)
  800264:	f426                	sd	s1,40(sp)
  800266:	f04a                	sd	s2,32(sp)
  800268:	ec4e                	sd	s3,24(sp)
  80026a:	e456                	sd	s5,8(sp)
  80026c:	0208d893          	srli	a7,a7,0x20
  800270:	fc06                	sd	ra,56(sp)
  800272:	0316fab3          	remu	s5,a3,a7
  800276:	fff7841b          	addiw	s0,a5,-1
  80027a:	84aa                	mv	s1,a0
  80027c:	89ae                	mv	s3,a1
  80027e:	8932                	mv	s2,a2
  800280:	0516f063          	bgeu	a3,a7,8002c0 <printnum+0x64>
  800284:	e852                	sd	s4,16(sp)
  800286:	4705                	li	a4,1
  800288:	8a42                	mv	s4,a6
  80028a:	00f75863          	bge	a4,a5,80029a <printnum+0x3e>
  80028e:	864e                	mv	a2,s3
  800290:	85ca                	mv	a1,s2
  800292:	8552                	mv	a0,s4
  800294:	347d                	addiw	s0,s0,-1
  800296:	9482                	jalr	s1
  800298:	f87d                	bnez	s0,80028e <printnum+0x32>
  80029a:	6a42                	ld	s4,16(sp)
  80029c:	00000797          	auipc	a5,0x0
  8002a0:	56c78793          	addi	a5,a5,1388 # 800808 <main+0x186>
  8002a4:	97d6                	add	a5,a5,s5
  8002a6:	7442                	ld	s0,48(sp)
  8002a8:	0007c503          	lbu	a0,0(a5)
  8002ac:	70e2                	ld	ra,56(sp)
  8002ae:	6aa2                	ld	s5,8(sp)
  8002b0:	864e                	mv	a2,s3
  8002b2:	85ca                	mv	a1,s2
  8002b4:	69e2                	ld	s3,24(sp)
  8002b6:	7902                	ld	s2,32(sp)
  8002b8:	87a6                	mv	a5,s1
  8002ba:	74a2                	ld	s1,40(sp)
  8002bc:	6121                	addi	sp,sp,64
  8002be:	8782                	jr	a5
  8002c0:	0316d6b3          	divu	a3,a3,a7
  8002c4:	87a2                	mv	a5,s0
  8002c6:	f97ff0ef          	jal	80025c <printnum>
  8002ca:	bfc9                	j	80029c <printnum+0x40>

00000000008002cc <vprintfmt>:
  8002cc:	7119                	addi	sp,sp,-128
  8002ce:	f4a6                	sd	s1,104(sp)
  8002d0:	f0ca                	sd	s2,96(sp)
  8002d2:	ecce                	sd	s3,88(sp)
  8002d4:	e8d2                	sd	s4,80(sp)
  8002d6:	e4d6                	sd	s5,72(sp)
  8002d8:	e0da                	sd	s6,64(sp)
  8002da:	fc5e                	sd	s7,56(sp)
  8002dc:	f466                	sd	s9,40(sp)
  8002de:	fc86                	sd	ra,120(sp)
  8002e0:	f8a2                	sd	s0,112(sp)
  8002e2:	f862                	sd	s8,48(sp)
  8002e4:	f06a                	sd	s10,32(sp)
  8002e6:	ec6e                	sd	s11,24(sp)
  8002e8:	84aa                	mv	s1,a0
  8002ea:	8cb6                	mv	s9,a3
  8002ec:	8aba                	mv	s5,a4
  8002ee:	89ae                	mv	s3,a1
  8002f0:	8932                	mv	s2,a2
  8002f2:	02500a13          	li	s4,37
  8002f6:	05500b93          	li	s7,85
  8002fa:	00000b17          	auipc	s6,0x0
  8002fe:	7f2b0b13          	addi	s6,s6,2034 # 800aec <main+0x46a>
  800302:	000cc503          	lbu	a0,0(s9)
  800306:	001c8413          	addi	s0,s9,1
  80030a:	01450b63          	beq	a0,s4,800320 <vprintfmt+0x54>
  80030e:	cd15                	beqz	a0,80034a <vprintfmt+0x7e>
  800310:	864e                	mv	a2,s3
  800312:	85ca                	mv	a1,s2
  800314:	9482                	jalr	s1
  800316:	00044503          	lbu	a0,0(s0)
  80031a:	0405                	addi	s0,s0,1
  80031c:	ff4519e3          	bne	a0,s4,80030e <vprintfmt+0x42>
  800320:	5d7d                	li	s10,-1
  800322:	8dea                	mv	s11,s10
  800324:	02000813          	li	a6,32
  800328:	4c01                	li	s8,0
  80032a:	4581                	li	a1,0
  80032c:	00044703          	lbu	a4,0(s0)
  800330:	00140c93          	addi	s9,s0,1
  800334:	fdd7061b          	addiw	a2,a4,-35
  800338:	0ff67613          	zext.b	a2,a2
  80033c:	02cbe663          	bltu	s7,a2,800368 <vprintfmt+0x9c>
  800340:	060a                	slli	a2,a2,0x2
  800342:	965a                	add	a2,a2,s6
  800344:	421c                	lw	a5,0(a2)
  800346:	97da                	add	a5,a5,s6
  800348:	8782                	jr	a5
  80034a:	70e6                	ld	ra,120(sp)
  80034c:	7446                	ld	s0,112(sp)
  80034e:	74a6                	ld	s1,104(sp)
  800350:	7906                	ld	s2,96(sp)
  800352:	69e6                	ld	s3,88(sp)
  800354:	6a46                	ld	s4,80(sp)
  800356:	6aa6                	ld	s5,72(sp)
  800358:	6b06                	ld	s6,64(sp)
  80035a:	7be2                	ld	s7,56(sp)
  80035c:	7c42                	ld	s8,48(sp)
  80035e:	7ca2                	ld	s9,40(sp)
  800360:	7d02                	ld	s10,32(sp)
  800362:	6de2                	ld	s11,24(sp)
  800364:	6109                	addi	sp,sp,128
  800366:	8082                	ret
  800368:	864e                	mv	a2,s3
  80036a:	85ca                	mv	a1,s2
  80036c:	02500513          	li	a0,37
  800370:	9482                	jalr	s1
  800372:	fff44783          	lbu	a5,-1(s0)
  800376:	02500713          	li	a4,37
  80037a:	8ca2                	mv	s9,s0
  80037c:	f8e783e3          	beq	a5,a4,800302 <vprintfmt+0x36>
  800380:	ffecc783          	lbu	a5,-2(s9)
  800384:	1cfd                	addi	s9,s9,-1
  800386:	fee79de3          	bne	a5,a4,800380 <vprintfmt+0xb4>
  80038a:	bfa5                	j	800302 <vprintfmt+0x36>
  80038c:	00144683          	lbu	a3,1(s0)
  800390:	4525                	li	a0,9
  800392:	fd070d1b          	addiw	s10,a4,-48
  800396:	fd06879b          	addiw	a5,a3,-48
  80039a:	28f56063          	bltu	a0,a5,80061a <vprintfmt+0x34e>
  80039e:	2681                	sext.w	a3,a3
  8003a0:	8466                	mv	s0,s9
  8003a2:	002d179b          	slliw	a5,s10,0x2
  8003a6:	00144703          	lbu	a4,1(s0)
  8003aa:	01a787bb          	addw	a5,a5,s10
  8003ae:	0017979b          	slliw	a5,a5,0x1
  8003b2:	9fb5                	addw	a5,a5,a3
  8003b4:	fd07061b          	addiw	a2,a4,-48
  8003b8:	0405                	addi	s0,s0,1
  8003ba:	fd078d1b          	addiw	s10,a5,-48
  8003be:	0007069b          	sext.w	a3,a4
  8003c2:	fec570e3          	bgeu	a0,a2,8003a2 <vprintfmt+0xd6>
  8003c6:	f60dd3e3          	bgez	s11,80032c <vprintfmt+0x60>
  8003ca:	8dea                	mv	s11,s10
  8003cc:	5d7d                	li	s10,-1
  8003ce:	bfb9                	j	80032c <vprintfmt+0x60>
  8003d0:	883a                	mv	a6,a4
  8003d2:	8466                	mv	s0,s9
  8003d4:	bfa1                	j	80032c <vprintfmt+0x60>
  8003d6:	8466                	mv	s0,s9
  8003d8:	4c05                	li	s8,1
  8003da:	bf89                	j	80032c <vprintfmt+0x60>
  8003dc:	4785                	li	a5,1
  8003de:	008a8613          	addi	a2,s5,8
  8003e2:	00b7c463          	blt	a5,a1,8003ea <vprintfmt+0x11e>
  8003e6:	1c058363          	beqz	a1,8005ac <vprintfmt+0x2e0>
  8003ea:	000ab683          	ld	a3,0(s5)
  8003ee:	4741                	li	a4,16
  8003f0:	8ab2                	mv	s5,a2
  8003f2:	2801                	sext.w	a6,a6
  8003f4:	87ee                	mv	a5,s11
  8003f6:	864a                	mv	a2,s2
  8003f8:	85ce                	mv	a1,s3
  8003fa:	8526                	mv	a0,s1
  8003fc:	e61ff0ef          	jal	80025c <printnum>
  800400:	b709                	j	800302 <vprintfmt+0x36>
  800402:	000aa503          	lw	a0,0(s5)
  800406:	864e                	mv	a2,s3
  800408:	85ca                	mv	a1,s2
  80040a:	9482                	jalr	s1
  80040c:	0aa1                	addi	s5,s5,8
  80040e:	bdd5                	j	800302 <vprintfmt+0x36>
  800410:	4785                	li	a5,1
  800412:	008a8613          	addi	a2,s5,8
  800416:	00b7c463          	blt	a5,a1,80041e <vprintfmt+0x152>
  80041a:	18058463          	beqz	a1,8005a2 <vprintfmt+0x2d6>
  80041e:	000ab683          	ld	a3,0(s5)
  800422:	4729                	li	a4,10
  800424:	8ab2                	mv	s5,a2
  800426:	b7f1                	j	8003f2 <vprintfmt+0x126>
  800428:	864e                	mv	a2,s3
  80042a:	85ca                	mv	a1,s2
  80042c:	03000513          	li	a0,48
  800430:	e042                	sd	a6,0(sp)
  800432:	9482                	jalr	s1
  800434:	864e                	mv	a2,s3
  800436:	85ca                	mv	a1,s2
  800438:	07800513          	li	a0,120
  80043c:	9482                	jalr	s1
  80043e:	000ab683          	ld	a3,0(s5)
  800442:	6802                	ld	a6,0(sp)
  800444:	4741                	li	a4,16
  800446:	0aa1                	addi	s5,s5,8
  800448:	b76d                	j	8003f2 <vprintfmt+0x126>
  80044a:	864e                	mv	a2,s3
  80044c:	85ca                	mv	a1,s2
  80044e:	02500513          	li	a0,37
  800452:	9482                	jalr	s1
  800454:	b57d                	j	800302 <vprintfmt+0x36>
  800456:	000aad03          	lw	s10,0(s5)
  80045a:	8466                	mv	s0,s9
  80045c:	0aa1                	addi	s5,s5,8
  80045e:	b7a5                	j	8003c6 <vprintfmt+0xfa>
  800460:	4785                	li	a5,1
  800462:	008a8613          	addi	a2,s5,8
  800466:	00b7c463          	blt	a5,a1,80046e <vprintfmt+0x1a2>
  80046a:	12058763          	beqz	a1,800598 <vprintfmt+0x2cc>
  80046e:	000ab683          	ld	a3,0(s5)
  800472:	4721                	li	a4,8
  800474:	8ab2                	mv	s5,a2
  800476:	bfb5                	j	8003f2 <vprintfmt+0x126>
  800478:	87ee                	mv	a5,s11
  80047a:	000dd363          	bgez	s11,800480 <vprintfmt+0x1b4>
  80047e:	4781                	li	a5,0
  800480:	00078d9b          	sext.w	s11,a5
  800484:	8466                	mv	s0,s9
  800486:	b55d                	j	80032c <vprintfmt+0x60>
  800488:	0008041b          	sext.w	s0,a6
  80048c:	fd340793          	addi	a5,s0,-45
  800490:	01b02733          	sgtz	a4,s11
  800494:	00f037b3          	snez	a5,a5
  800498:	8ff9                	and	a5,a5,a4
  80049a:	000ab703          	ld	a4,0(s5)
  80049e:	008a8693          	addi	a3,s5,8
  8004a2:	e436                	sd	a3,8(sp)
  8004a4:	12070563          	beqz	a4,8005ce <vprintfmt+0x302>
  8004a8:	12079d63          	bnez	a5,8005e2 <vprintfmt+0x316>
  8004ac:	00074783          	lbu	a5,0(a4)
  8004b0:	0007851b          	sext.w	a0,a5
  8004b4:	c78d                	beqz	a5,8004de <vprintfmt+0x212>
  8004b6:	00170a93          	addi	s5,a4,1
  8004ba:	547d                	li	s0,-1
  8004bc:	000d4563          	bltz	s10,8004c6 <vprintfmt+0x1fa>
  8004c0:	3d7d                	addiw	s10,s10,-1
  8004c2:	008d0e63          	beq	s10,s0,8004de <vprintfmt+0x212>
  8004c6:	020c1863          	bnez	s8,8004f6 <vprintfmt+0x22a>
  8004ca:	864e                	mv	a2,s3
  8004cc:	85ca                	mv	a1,s2
  8004ce:	9482                	jalr	s1
  8004d0:	000ac783          	lbu	a5,0(s5)
  8004d4:	0a85                	addi	s5,s5,1
  8004d6:	3dfd                	addiw	s11,s11,-1
  8004d8:	0007851b          	sext.w	a0,a5
  8004dc:	f3e5                	bnez	a5,8004bc <vprintfmt+0x1f0>
  8004de:	01b05a63          	blez	s11,8004f2 <vprintfmt+0x226>
  8004e2:	864e                	mv	a2,s3
  8004e4:	85ca                	mv	a1,s2
  8004e6:	02000513          	li	a0,32
  8004ea:	3dfd                	addiw	s11,s11,-1
  8004ec:	9482                	jalr	s1
  8004ee:	fe0d9ae3          	bnez	s11,8004e2 <vprintfmt+0x216>
  8004f2:	6aa2                	ld	s5,8(sp)
  8004f4:	b539                	j	800302 <vprintfmt+0x36>
  8004f6:	3781                	addiw	a5,a5,-32
  8004f8:	05e00713          	li	a4,94
  8004fc:	fcf777e3          	bgeu	a4,a5,8004ca <vprintfmt+0x1fe>
  800500:	03f00513          	li	a0,63
  800504:	864e                	mv	a2,s3
  800506:	85ca                	mv	a1,s2
  800508:	9482                	jalr	s1
  80050a:	000ac783          	lbu	a5,0(s5)
  80050e:	0a85                	addi	s5,s5,1
  800510:	3dfd                	addiw	s11,s11,-1
  800512:	0007851b          	sext.w	a0,a5
  800516:	d7e1                	beqz	a5,8004de <vprintfmt+0x212>
  800518:	fa0d54e3          	bgez	s10,8004c0 <vprintfmt+0x1f4>
  80051c:	bfe9                	j	8004f6 <vprintfmt+0x22a>
  80051e:	000aa783          	lw	a5,0(s5)
  800522:	46e1                	li	a3,24
  800524:	0aa1                	addi	s5,s5,8
  800526:	41f7d71b          	sraiw	a4,a5,0x1f
  80052a:	8fb9                	xor	a5,a5,a4
  80052c:	40e7873b          	subw	a4,a5,a4
  800530:	02e6c663          	blt	a3,a4,80055c <vprintfmt+0x290>
  800534:	00000797          	auipc	a5,0x0
  800538:	71478793          	addi	a5,a5,1812 # 800c48 <error_string>
  80053c:	00371693          	slli	a3,a4,0x3
  800540:	97b6                	add	a5,a5,a3
  800542:	639c                	ld	a5,0(a5)
  800544:	cf81                	beqz	a5,80055c <vprintfmt+0x290>
  800546:	873e                	mv	a4,a5
  800548:	00000697          	auipc	a3,0x0
  80054c:	2f068693          	addi	a3,a3,752 # 800838 <main+0x1b6>
  800550:	864a                	mv	a2,s2
  800552:	85ce                	mv	a1,s3
  800554:	8526                	mv	a0,s1
  800556:	0f2000ef          	jal	800648 <printfmt>
  80055a:	b365                	j	800302 <vprintfmt+0x36>
  80055c:	00000697          	auipc	a3,0x0
  800560:	2cc68693          	addi	a3,a3,716 # 800828 <main+0x1a6>
  800564:	864a                	mv	a2,s2
  800566:	85ce                	mv	a1,s3
  800568:	8526                	mv	a0,s1
  80056a:	0de000ef          	jal	800648 <printfmt>
  80056e:	bb51                	j	800302 <vprintfmt+0x36>
  800570:	4785                	li	a5,1
  800572:	008a8c13          	addi	s8,s5,8
  800576:	00b7c363          	blt	a5,a1,80057c <vprintfmt+0x2b0>
  80057a:	cd81                	beqz	a1,800592 <vprintfmt+0x2c6>
  80057c:	000ab403          	ld	s0,0(s5)
  800580:	02044b63          	bltz	s0,8005b6 <vprintfmt+0x2ea>
  800584:	86a2                	mv	a3,s0
  800586:	8ae2                	mv	s5,s8
  800588:	4729                	li	a4,10
  80058a:	b5a5                	j	8003f2 <vprintfmt+0x126>
  80058c:	2585                	addiw	a1,a1,1
  80058e:	8466                	mv	s0,s9
  800590:	bb71                	j	80032c <vprintfmt+0x60>
  800592:	000aa403          	lw	s0,0(s5)
  800596:	b7ed                	j	800580 <vprintfmt+0x2b4>
  800598:	000ae683          	lwu	a3,0(s5)
  80059c:	4721                	li	a4,8
  80059e:	8ab2                	mv	s5,a2
  8005a0:	bd89                	j	8003f2 <vprintfmt+0x126>
  8005a2:	000ae683          	lwu	a3,0(s5)
  8005a6:	4729                	li	a4,10
  8005a8:	8ab2                	mv	s5,a2
  8005aa:	b5a1                	j	8003f2 <vprintfmt+0x126>
  8005ac:	000ae683          	lwu	a3,0(s5)
  8005b0:	4741                	li	a4,16
  8005b2:	8ab2                	mv	s5,a2
  8005b4:	bd3d                	j	8003f2 <vprintfmt+0x126>
  8005b6:	864e                	mv	a2,s3
  8005b8:	85ca                	mv	a1,s2
  8005ba:	02d00513          	li	a0,45
  8005be:	e042                	sd	a6,0(sp)
  8005c0:	9482                	jalr	s1
  8005c2:	6802                	ld	a6,0(sp)
  8005c4:	408006b3          	neg	a3,s0
  8005c8:	8ae2                	mv	s5,s8
  8005ca:	4729                	li	a4,10
  8005cc:	b51d                	j	8003f2 <vprintfmt+0x126>
  8005ce:	eba1                	bnez	a5,80061e <vprintfmt+0x352>
  8005d0:	02800793          	li	a5,40
  8005d4:	853e                	mv	a0,a5
  8005d6:	00000a97          	auipc	s5,0x0
  8005da:	24ba8a93          	addi	s5,s5,587 # 800821 <main+0x19f>
  8005de:	547d                	li	s0,-1
  8005e0:	bdf1                	j	8004bc <vprintfmt+0x1f0>
  8005e2:	853a                	mv	a0,a4
  8005e4:	85ea                	mv	a1,s10
  8005e6:	e03a                	sd	a4,0(sp)
  8005e8:	07e000ef          	jal	800666 <strnlen>
  8005ec:	40ad8dbb          	subw	s11,s11,a0
  8005f0:	6702                	ld	a4,0(sp)
  8005f2:	01b05b63          	blez	s11,800608 <vprintfmt+0x33c>
  8005f6:	864e                	mv	a2,s3
  8005f8:	85ca                	mv	a1,s2
  8005fa:	8522                	mv	a0,s0
  8005fc:	e03a                	sd	a4,0(sp)
  8005fe:	3dfd                	addiw	s11,s11,-1
  800600:	9482                	jalr	s1
  800602:	6702                	ld	a4,0(sp)
  800604:	fe0d99e3          	bnez	s11,8005f6 <vprintfmt+0x32a>
  800608:	00074783          	lbu	a5,0(a4)
  80060c:	0007851b          	sext.w	a0,a5
  800610:	ee0781e3          	beqz	a5,8004f2 <vprintfmt+0x226>
  800614:	00170a93          	addi	s5,a4,1
  800618:	b54d                	j	8004ba <vprintfmt+0x1ee>
  80061a:	8466                	mv	s0,s9
  80061c:	b36d                	j	8003c6 <vprintfmt+0xfa>
  80061e:	85ea                	mv	a1,s10
  800620:	00000517          	auipc	a0,0x0
  800624:	20050513          	addi	a0,a0,512 # 800820 <main+0x19e>
  800628:	03e000ef          	jal	800666 <strnlen>
  80062c:	40ad8dbb          	subw	s11,s11,a0
  800630:	02800793          	li	a5,40
  800634:	00000717          	auipc	a4,0x0
  800638:	1ec70713          	addi	a4,a4,492 # 800820 <main+0x19e>
  80063c:	853e                	mv	a0,a5
  80063e:	fbb04ce3          	bgtz	s11,8005f6 <vprintfmt+0x32a>
  800642:	00170a93          	addi	s5,a4,1
  800646:	bd95                	j	8004ba <vprintfmt+0x1ee>

0000000000800648 <printfmt>:
  800648:	7139                	addi	sp,sp,-64
  80064a:	02010313          	addi	t1,sp,32
  80064e:	f03a                	sd	a4,32(sp)
  800650:	871a                	mv	a4,t1
  800652:	ec06                	sd	ra,24(sp)
  800654:	f43e                	sd	a5,40(sp)
  800656:	f842                	sd	a6,48(sp)
  800658:	fc46                	sd	a7,56(sp)
  80065a:	e41a                	sd	t1,8(sp)
  80065c:	c71ff0ef          	jal	8002cc <vprintfmt>
  800660:	60e2                	ld	ra,24(sp)
  800662:	6121                	addi	sp,sp,64
  800664:	8082                	ret

0000000000800666 <strnlen>:
  800666:	4781                	li	a5,0
  800668:	e589                	bnez	a1,800672 <strnlen+0xc>
  80066a:	a811                	j	80067e <strnlen+0x18>
  80066c:	0785                	addi	a5,a5,1
  80066e:	00f58863          	beq	a1,a5,80067e <strnlen+0x18>
  800672:	00f50733          	add	a4,a0,a5
  800676:	00074703          	lbu	a4,0(a4)
  80067a:	fb6d                	bnez	a4,80066c <strnlen+0x6>
  80067c:	85be                	mv	a1,a5
  80067e:	852e                	mv	a0,a1
  800680:	8082                	ret

0000000000800682 <main>:
  800682:	1141                	addi	sp,sp,-16
  800684:	00000517          	auipc	a0,0x0
  800688:	39450513          	addi	a0,a0,916 # 800a18 <main+0x396>
  80068c:	e406                	sd	ra,8(sp)
  80068e:	a67ff0ef          	jal	8000f4 <cprintf>
  800692:	00001597          	auipc	a1,0x1
  800696:	96e58593          	addi	a1,a1,-1682 # 801000 <bigarray>
  80069a:	87ae                	mv	a5,a1
  80069c:	4681                	li	a3,0
  80069e:	00100637          	lui	a2,0x100
  8006a2:	a029                	j	8006ac <main+0x2a>
  8006a4:	2685                	addiw	a3,a3,1
  8006a6:	0791                	addi	a5,a5,4
  8006a8:	00c68f63          	beq	a3,a2,8006c6 <main+0x44>
  8006ac:	4398                	lw	a4,0(a5)
  8006ae:	db7d                	beqz	a4,8006a4 <main+0x22>
  8006b0:	00000617          	auipc	a2,0x0
  8006b4:	38860613          	addi	a2,a2,904 # 800a38 <main+0x3b6>
  8006b8:	45b9                	li	a1,14
  8006ba:	00000517          	auipc	a0,0x0
  8006be:	39e50513          	addi	a0,a0,926 # 800a58 <main+0x3d6>
  8006c2:	96fff0ef          	jal	800030 <__panic>
  8006c6:	00001717          	auipc	a4,0x1
  8006ca:	93a70713          	addi	a4,a4,-1734 # 801000 <bigarray>
  8006ce:	4781                	li	a5,0
  8006d0:	001006b7          	lui	a3,0x100
  8006d4:	c31c                	sw	a5,0(a4)
  8006d6:	2785                	addiw	a5,a5,1
  8006d8:	0711                	addi	a4,a4,4
  8006da:	fed79de3          	bne	a5,a3,8006d4 <main+0x52>
  8006de:	4681                	li	a3,0
  8006e0:	00100737          	lui	a4,0x100
  8006e4:	a029                	j	8006ee <main+0x6c>
  8006e6:	2685                	addiw	a3,a3,1 # 100001 <open-0x70001f>
  8006e8:	0591                	addi	a1,a1,4
  8006ea:	02e68063          	beq	a3,a4,80070a <main+0x88>
  8006ee:	419c                	lw	a5,0(a1)
  8006f0:	fed78be3          	beq	a5,a3,8006e6 <main+0x64>
  8006f4:	00000617          	auipc	a2,0x0
  8006f8:	37460613          	addi	a2,a2,884 # 800a68 <main+0x3e6>
  8006fc:	45d9                	li	a1,22
  8006fe:	00000517          	auipc	a0,0x0
  800702:	35a50513          	addi	a0,a0,858 # 800a58 <main+0x3d6>
  800706:	92bff0ef          	jal	800030 <__panic>
  80070a:	00000517          	auipc	a0,0x0
  80070e:	38650513          	addi	a0,a0,902 # 800a90 <main+0x40e>
  800712:	9e3ff0ef          	jal	8000f4 <cprintf>
  800716:	00000517          	auipc	a0,0x0
  80071a:	3b250513          	addi	a0,a0,946 # 800ac8 <main+0x446>
  80071e:	9d7ff0ef          	jal	8000f4 <cprintf>
  800722:	00000617          	auipc	a2,0x0
  800726:	3be60613          	addi	a2,a2,958 # 800ae0 <main+0x45e>
  80072a:	45fd                	li	a1,31
  80072c:	00000517          	auipc	a0,0x0
  800730:	32c50513          	addi	a0,a0,812 # 800a58 <main+0x3d6>
  800734:	00402797          	auipc	a5,0x402
  800738:	8c07a623          	sw	zero,-1844(a5) # c02000 <bigarray+0x401000>
  80073c:	8f5ff0ef          	jal	800030 <__panic>
