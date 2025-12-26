
obj/__user_hello.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa09                	j	800136 <sys_open>

0000000000800026 <close>:
  800026:	aa29                	j	800140 <sys_close>

0000000000800028 <dup2>:
  800028:	a205                	j	800148 <sys_dup>

000000000080002a <_start>:
  80002a:	182000ef          	jal	8001ac <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__warn>:
  800030:	715d                	addi	sp,sp,-80
  800032:	e822                	sd	s0,16(sp)
  800034:	02810313          	addi	t1,sp,40
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	66a50513          	addi	a0,a0,1642 # 8006a8 <main+0x62>
  800046:	ec06                	sd	ra,24(sp)
  800048:	f436                	sd	a3,40(sp)
  80004a:	f83a                	sd	a4,48(sp)
  80004c:	fc3e                	sd	a5,56(sp)
  80004e:	e0c2                	sd	a6,64(sp)
  800050:	e4c6                	sd	a7,72(sp)
  800052:	e41a                	sd	t1,8(sp)
  800054:	05e000ef          	jal	8000b2 <cprintf>
  800058:	65a2                	ld	a1,8(sp)
  80005a:	8522                	mv	a0,s0
  80005c:	030000ef          	jal	80008c <vcprintf>
  800060:	00000517          	auipc	a0,0x0
  800064:	64050513          	addi	a0,a0,1600 # 8006a0 <main+0x5a>
  800068:	04a000ef          	jal	8000b2 <cprintf>
  80006c:	60e2                	ld	ra,24(sp)
  80006e:	6442                	ld	s0,16(sp)
  800070:	6161                	addi	sp,sp,80
  800072:	8082                	ret

0000000000800074 <cputch>:
  800074:	1101                	addi	sp,sp,-32
  800076:	ec06                	sd	ra,24(sp)
  800078:	e42e                	sd	a1,8(sp)
  80007a:	0b6000ef          	jal	800130 <sys_putc>
  80007e:	65a2                	ld	a1,8(sp)
  800080:	60e2                	ld	ra,24(sp)
  800082:	419c                	lw	a5,0(a1)
  800084:	2785                	addiw	a5,a5,1
  800086:	c19c                	sw	a5,0(a1)
  800088:	6105                	addi	sp,sp,32
  80008a:	8082                	ret

000000000080008c <vcprintf>:
  80008c:	1101                	addi	sp,sp,-32
  80008e:	872e                	mv	a4,a1
  800090:	75dd                	lui	a1,0xffff7
  800092:	86aa                	mv	a3,a0
  800094:	0070                	addi	a2,sp,12
  800096:	00000517          	auipc	a0,0x0
  80009a:	fde50513          	addi	a0,a0,-34 # 800074 <cputch>
  80009e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ff1>
  8000a2:	ec06                	sd	ra,24(sp)
  8000a4:	c602                	sw	zero,12(sp)
  8000a6:	1ea000ef          	jal	800290 <vprintfmt>
  8000aa:	60e2                	ld	ra,24(sp)
  8000ac:	4532                	lw	a0,12(sp)
  8000ae:	6105                	addi	sp,sp,32
  8000b0:	8082                	ret

00000000008000b2 <cprintf>:
  8000b2:	711d                	addi	sp,sp,-96
  8000b4:	02810313          	addi	t1,sp,40
  8000b8:	f42e                	sd	a1,40(sp)
  8000ba:	75dd                	lui	a1,0xffff7
  8000bc:	f832                	sd	a2,48(sp)
  8000be:	fc36                	sd	a3,56(sp)
  8000c0:	e0ba                	sd	a4,64(sp)
  8000c2:	86aa                	mv	a3,a0
  8000c4:	0050                	addi	a2,sp,4
  8000c6:	00000517          	auipc	a0,0x0
  8000ca:	fae50513          	addi	a0,a0,-82 # 800074 <cputch>
  8000ce:	871a                	mv	a4,t1
  8000d0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ff1>
  8000d4:	ec06                	sd	ra,24(sp)
  8000d6:	e4be                	sd	a5,72(sp)
  8000d8:	e8c2                	sd	a6,80(sp)
  8000da:	ecc6                	sd	a7,88(sp)
  8000dc:	c202                	sw	zero,4(sp)
  8000de:	e41a                	sd	t1,8(sp)
  8000e0:	1b0000ef          	jal	800290 <vprintfmt>
  8000e4:	60e2                	ld	ra,24(sp)
  8000e6:	4512                	lw	a0,4(sp)
  8000e8:	6125                	addi	sp,sp,96
  8000ea:	8082                	ret

00000000008000ec <syscall>:
  8000ec:	7175                	addi	sp,sp,-144
  8000ee:	08010313          	addi	t1,sp,128
  8000f2:	e42a                	sd	a0,8(sp)
  8000f4:	ecae                	sd	a1,88(sp)
  8000f6:	f42e                	sd	a1,40(sp)
  8000f8:	f0b2                	sd	a2,96(sp)
  8000fa:	f832                	sd	a2,48(sp)
  8000fc:	f4b6                	sd	a3,104(sp)
  8000fe:	fc36                	sd	a3,56(sp)
  800100:	f8ba                	sd	a4,112(sp)
  800102:	e0ba                	sd	a4,64(sp)
  800104:	fcbe                	sd	a5,120(sp)
  800106:	e4be                	sd	a5,72(sp)
  800108:	e142                	sd	a6,128(sp)
  80010a:	e546                	sd	a7,136(sp)
  80010c:	f01a                	sd	t1,32(sp)
  80010e:	4522                	lw	a0,8(sp)
  800110:	55a2                	lw	a1,40(sp)
  800112:	5642                	lw	a2,48(sp)
  800114:	56e2                	lw	a3,56(sp)
  800116:	4706                	lw	a4,64(sp)
  800118:	47a6                	lw	a5,72(sp)
  80011a:	00000073          	ecall
  80011e:	ce2a                	sw	a0,28(sp)
  800120:	4572                	lw	a0,28(sp)
  800122:	6149                	addi	sp,sp,144
  800124:	8082                	ret

0000000000800126 <sys_exit>:
  800126:	85aa                	mv	a1,a0
  800128:	4505                	li	a0,1
  80012a:	b7c9                	j	8000ec <syscall>

000000000080012c <sys_getpid>:
  80012c:	4549                	li	a0,18
  80012e:	bf7d                	j	8000ec <syscall>

0000000000800130 <sys_putc>:
  800130:	85aa                	mv	a1,a0
  800132:	4579                	li	a0,30
  800134:	bf65                	j	8000ec <syscall>

0000000000800136 <sys_open>:
  800136:	862e                	mv	a2,a1
  800138:	85aa                	mv	a1,a0
  80013a:	06400513          	li	a0,100
  80013e:	b77d                	j	8000ec <syscall>

0000000000800140 <sys_close>:
  800140:	85aa                	mv	a1,a0
  800142:	06500513          	li	a0,101
  800146:	b75d                	j	8000ec <syscall>

0000000000800148 <sys_dup>:
  800148:	862e                	mv	a2,a1
  80014a:	85aa                	mv	a1,a0
  80014c:	08200513          	li	a0,130
  800150:	bf71                	j	8000ec <syscall>

0000000000800152 <exit>:
  800152:	1141                	addi	sp,sp,-16
  800154:	e406                	sd	ra,8(sp)
  800156:	fd1ff0ef          	jal	800126 <sys_exit>
  80015a:	00000517          	auipc	a0,0x0
  80015e:	56e50513          	addi	a0,a0,1390 # 8006c8 <main+0x82>
  800162:	f51ff0ef          	jal	8000b2 <cprintf>
  800166:	a001                	j	800166 <exit+0x14>

0000000000800168 <getpid>:
  800168:	b7d1                	j	80012c <sys_getpid>

000000000080016a <initfd>:
  80016a:	87ae                	mv	a5,a1
  80016c:	1101                	addi	sp,sp,-32
  80016e:	e822                	sd	s0,16(sp)
  800170:	85b2                	mv	a1,a2
  800172:	842a                	mv	s0,a0
  800174:	853e                	mv	a0,a5
  800176:	ec06                	sd	ra,24(sp)
  800178:	ea9ff0ef          	jal	800020 <open>
  80017c:	87aa                	mv	a5,a0
  80017e:	00054463          	bltz	a0,800186 <initfd+0x1c>
  800182:	00851763          	bne	a0,s0,800190 <initfd+0x26>
  800186:	60e2                	ld	ra,24(sp)
  800188:	6442                	ld	s0,16(sp)
  80018a:	853e                	mv	a0,a5
  80018c:	6105                	addi	sp,sp,32
  80018e:	8082                	ret
  800190:	e42a                	sd	a0,8(sp)
  800192:	8522                	mv	a0,s0
  800194:	e93ff0ef          	jal	800026 <close>
  800198:	6522                	ld	a0,8(sp)
  80019a:	85a2                	mv	a1,s0
  80019c:	e8dff0ef          	jal	800028 <dup2>
  8001a0:	842a                	mv	s0,a0
  8001a2:	6522                	ld	a0,8(sp)
  8001a4:	e83ff0ef          	jal	800026 <close>
  8001a8:	87a2                	mv	a5,s0
  8001aa:	bff1                	j	800186 <initfd+0x1c>

00000000008001ac <umain>:
  8001ac:	1101                	addi	sp,sp,-32
  8001ae:	e822                	sd	s0,16(sp)
  8001b0:	e426                	sd	s1,8(sp)
  8001b2:	842a                	mv	s0,a0
  8001b4:	84ae                	mv	s1,a1
  8001b6:	4601                	li	a2,0
  8001b8:	00000597          	auipc	a1,0x0
  8001bc:	52858593          	addi	a1,a1,1320 # 8006e0 <main+0x9a>
  8001c0:	4501                	li	a0,0
  8001c2:	ec06                	sd	ra,24(sp)
  8001c4:	fa7ff0ef          	jal	80016a <initfd>
  8001c8:	02054263          	bltz	a0,8001ec <umain+0x40>
  8001cc:	4605                	li	a2,1
  8001ce:	8532                	mv	a0,a2
  8001d0:	00000597          	auipc	a1,0x0
  8001d4:	55058593          	addi	a1,a1,1360 # 800720 <main+0xda>
  8001d8:	f93ff0ef          	jal	80016a <initfd>
  8001dc:	02054563          	bltz	a0,800206 <umain+0x5a>
  8001e0:	85a6                	mv	a1,s1
  8001e2:	8522                	mv	a0,s0
  8001e4:	462000ef          	jal	800646 <main>
  8001e8:	f6bff0ef          	jal	800152 <exit>
  8001ec:	86aa                	mv	a3,a0
  8001ee:	00000617          	auipc	a2,0x0
  8001f2:	4fa60613          	addi	a2,a2,1274 # 8006e8 <main+0xa2>
  8001f6:	45e9                	li	a1,26
  8001f8:	00000517          	auipc	a0,0x0
  8001fc:	51050513          	addi	a0,a0,1296 # 800708 <main+0xc2>
  800200:	e31ff0ef          	jal	800030 <__warn>
  800204:	b7e1                	j	8001cc <umain+0x20>
  800206:	86aa                	mv	a3,a0
  800208:	00000617          	auipc	a2,0x0
  80020c:	52060613          	addi	a2,a2,1312 # 800728 <main+0xe2>
  800210:	45f5                	li	a1,29
  800212:	00000517          	auipc	a0,0x0
  800216:	4f650513          	addi	a0,a0,1270 # 800708 <main+0xc2>
  80021a:	e17ff0ef          	jal	800030 <__warn>
  80021e:	b7c9                	j	8001e0 <umain+0x34>

0000000000800220 <printnum>:
  800220:	7139                	addi	sp,sp,-64
  800222:	02071893          	slli	a7,a4,0x20
  800226:	f822                	sd	s0,48(sp)
  800228:	f426                	sd	s1,40(sp)
  80022a:	f04a                	sd	s2,32(sp)
  80022c:	ec4e                	sd	s3,24(sp)
  80022e:	e456                	sd	s5,8(sp)
  800230:	0208d893          	srli	a7,a7,0x20
  800234:	fc06                	sd	ra,56(sp)
  800236:	0316fab3          	remu	s5,a3,a7
  80023a:	fff7841b          	addiw	s0,a5,-1
  80023e:	84aa                	mv	s1,a0
  800240:	89ae                	mv	s3,a1
  800242:	8932                	mv	s2,a2
  800244:	0516f063          	bgeu	a3,a7,800284 <printnum+0x64>
  800248:	e852                	sd	s4,16(sp)
  80024a:	4705                	li	a4,1
  80024c:	8a42                	mv	s4,a6
  80024e:	00f75863          	bge	a4,a5,80025e <printnum+0x3e>
  800252:	864e                	mv	a2,s3
  800254:	85ca                	mv	a1,s2
  800256:	8552                	mv	a0,s4
  800258:	347d                	addiw	s0,s0,-1
  80025a:	9482                	jalr	s1
  80025c:	f87d                	bnez	s0,800252 <printnum+0x32>
  80025e:	6a42                	ld	s4,16(sp)
  800260:	00000797          	auipc	a5,0x0
  800264:	4e878793          	addi	a5,a5,1256 # 800748 <main+0x102>
  800268:	97d6                	add	a5,a5,s5
  80026a:	7442                	ld	s0,48(sp)
  80026c:	0007c503          	lbu	a0,0(a5)
  800270:	70e2                	ld	ra,56(sp)
  800272:	6aa2                	ld	s5,8(sp)
  800274:	864e                	mv	a2,s3
  800276:	85ca                	mv	a1,s2
  800278:	69e2                	ld	s3,24(sp)
  80027a:	7902                	ld	s2,32(sp)
  80027c:	87a6                	mv	a5,s1
  80027e:	74a2                	ld	s1,40(sp)
  800280:	6121                	addi	sp,sp,64
  800282:	8782                	jr	a5
  800284:	0316d6b3          	divu	a3,a3,a7
  800288:	87a2                	mv	a5,s0
  80028a:	f97ff0ef          	jal	800220 <printnum>
  80028e:	bfc9                	j	800260 <printnum+0x40>

0000000000800290 <vprintfmt>:
  800290:	7119                	addi	sp,sp,-128
  800292:	f4a6                	sd	s1,104(sp)
  800294:	f0ca                	sd	s2,96(sp)
  800296:	ecce                	sd	s3,88(sp)
  800298:	e8d2                	sd	s4,80(sp)
  80029a:	e4d6                	sd	s5,72(sp)
  80029c:	e0da                	sd	s6,64(sp)
  80029e:	fc5e                	sd	s7,56(sp)
  8002a0:	f466                	sd	s9,40(sp)
  8002a2:	fc86                	sd	ra,120(sp)
  8002a4:	f8a2                	sd	s0,112(sp)
  8002a6:	f862                	sd	s8,48(sp)
  8002a8:	f06a                	sd	s10,32(sp)
  8002aa:	ec6e                	sd	s11,24(sp)
  8002ac:	84aa                	mv	s1,a0
  8002ae:	8cb6                	mv	s9,a3
  8002b0:	8aba                	mv	s5,a4
  8002b2:	89ae                	mv	s3,a1
  8002b4:	8932                	mv	s2,a2
  8002b6:	02500a13          	li	s4,37
  8002ba:	05500b93          	li	s7,85
  8002be:	00000b17          	auipc	s6,0x0
  8002c2:	6d2b0b13          	addi	s6,s6,1746 # 800990 <main+0x34a>
  8002c6:	000cc503          	lbu	a0,0(s9)
  8002ca:	001c8413          	addi	s0,s9,1
  8002ce:	01450b63          	beq	a0,s4,8002e4 <vprintfmt+0x54>
  8002d2:	cd15                	beqz	a0,80030e <vprintfmt+0x7e>
  8002d4:	864e                	mv	a2,s3
  8002d6:	85ca                	mv	a1,s2
  8002d8:	9482                	jalr	s1
  8002da:	00044503          	lbu	a0,0(s0)
  8002de:	0405                	addi	s0,s0,1
  8002e0:	ff4519e3          	bne	a0,s4,8002d2 <vprintfmt+0x42>
  8002e4:	5d7d                	li	s10,-1
  8002e6:	8dea                	mv	s11,s10
  8002e8:	02000813          	li	a6,32
  8002ec:	4c01                	li	s8,0
  8002ee:	4581                	li	a1,0
  8002f0:	00044703          	lbu	a4,0(s0)
  8002f4:	00140c93          	addi	s9,s0,1
  8002f8:	fdd7061b          	addiw	a2,a4,-35
  8002fc:	0ff67613          	zext.b	a2,a2
  800300:	02cbe663          	bltu	s7,a2,80032c <vprintfmt+0x9c>
  800304:	060a                	slli	a2,a2,0x2
  800306:	965a                	add	a2,a2,s6
  800308:	421c                	lw	a5,0(a2)
  80030a:	97da                	add	a5,a5,s6
  80030c:	8782                	jr	a5
  80030e:	70e6                	ld	ra,120(sp)
  800310:	7446                	ld	s0,112(sp)
  800312:	74a6                	ld	s1,104(sp)
  800314:	7906                	ld	s2,96(sp)
  800316:	69e6                	ld	s3,88(sp)
  800318:	6a46                	ld	s4,80(sp)
  80031a:	6aa6                	ld	s5,72(sp)
  80031c:	6b06                	ld	s6,64(sp)
  80031e:	7be2                	ld	s7,56(sp)
  800320:	7c42                	ld	s8,48(sp)
  800322:	7ca2                	ld	s9,40(sp)
  800324:	7d02                	ld	s10,32(sp)
  800326:	6de2                	ld	s11,24(sp)
  800328:	6109                	addi	sp,sp,128
  80032a:	8082                	ret
  80032c:	864e                	mv	a2,s3
  80032e:	85ca                	mv	a1,s2
  800330:	02500513          	li	a0,37
  800334:	9482                	jalr	s1
  800336:	fff44783          	lbu	a5,-1(s0)
  80033a:	02500713          	li	a4,37
  80033e:	8ca2                	mv	s9,s0
  800340:	f8e783e3          	beq	a5,a4,8002c6 <vprintfmt+0x36>
  800344:	ffecc783          	lbu	a5,-2(s9)
  800348:	1cfd                	addi	s9,s9,-1
  80034a:	fee79de3          	bne	a5,a4,800344 <vprintfmt+0xb4>
  80034e:	bfa5                	j	8002c6 <vprintfmt+0x36>
  800350:	00144683          	lbu	a3,1(s0)
  800354:	4525                	li	a0,9
  800356:	fd070d1b          	addiw	s10,a4,-48
  80035a:	fd06879b          	addiw	a5,a3,-48
  80035e:	28f56063          	bltu	a0,a5,8005de <vprintfmt+0x34e>
  800362:	2681                	sext.w	a3,a3
  800364:	8466                	mv	s0,s9
  800366:	002d179b          	slliw	a5,s10,0x2
  80036a:	00144703          	lbu	a4,1(s0)
  80036e:	01a787bb          	addw	a5,a5,s10
  800372:	0017979b          	slliw	a5,a5,0x1
  800376:	9fb5                	addw	a5,a5,a3
  800378:	fd07061b          	addiw	a2,a4,-48
  80037c:	0405                	addi	s0,s0,1
  80037e:	fd078d1b          	addiw	s10,a5,-48
  800382:	0007069b          	sext.w	a3,a4
  800386:	fec570e3          	bgeu	a0,a2,800366 <vprintfmt+0xd6>
  80038a:	f60dd3e3          	bgez	s11,8002f0 <vprintfmt+0x60>
  80038e:	8dea                	mv	s11,s10
  800390:	5d7d                	li	s10,-1
  800392:	bfb9                	j	8002f0 <vprintfmt+0x60>
  800394:	883a                	mv	a6,a4
  800396:	8466                	mv	s0,s9
  800398:	bfa1                	j	8002f0 <vprintfmt+0x60>
  80039a:	8466                	mv	s0,s9
  80039c:	4c05                	li	s8,1
  80039e:	bf89                	j	8002f0 <vprintfmt+0x60>
  8003a0:	4785                	li	a5,1
  8003a2:	008a8613          	addi	a2,s5,8
  8003a6:	00b7c463          	blt	a5,a1,8003ae <vprintfmt+0x11e>
  8003aa:	1c058363          	beqz	a1,800570 <vprintfmt+0x2e0>
  8003ae:	000ab683          	ld	a3,0(s5)
  8003b2:	4741                	li	a4,16
  8003b4:	8ab2                	mv	s5,a2
  8003b6:	2801                	sext.w	a6,a6
  8003b8:	87ee                	mv	a5,s11
  8003ba:	864a                	mv	a2,s2
  8003bc:	85ce                	mv	a1,s3
  8003be:	8526                	mv	a0,s1
  8003c0:	e61ff0ef          	jal	800220 <printnum>
  8003c4:	b709                	j	8002c6 <vprintfmt+0x36>
  8003c6:	000aa503          	lw	a0,0(s5)
  8003ca:	864e                	mv	a2,s3
  8003cc:	85ca                	mv	a1,s2
  8003ce:	9482                	jalr	s1
  8003d0:	0aa1                	addi	s5,s5,8
  8003d2:	bdd5                	j	8002c6 <vprintfmt+0x36>
  8003d4:	4785                	li	a5,1
  8003d6:	008a8613          	addi	a2,s5,8
  8003da:	00b7c463          	blt	a5,a1,8003e2 <vprintfmt+0x152>
  8003de:	18058463          	beqz	a1,800566 <vprintfmt+0x2d6>
  8003e2:	000ab683          	ld	a3,0(s5)
  8003e6:	4729                	li	a4,10
  8003e8:	8ab2                	mv	s5,a2
  8003ea:	b7f1                	j	8003b6 <vprintfmt+0x126>
  8003ec:	864e                	mv	a2,s3
  8003ee:	85ca                	mv	a1,s2
  8003f0:	03000513          	li	a0,48
  8003f4:	e042                	sd	a6,0(sp)
  8003f6:	9482                	jalr	s1
  8003f8:	864e                	mv	a2,s3
  8003fa:	85ca                	mv	a1,s2
  8003fc:	07800513          	li	a0,120
  800400:	9482                	jalr	s1
  800402:	000ab683          	ld	a3,0(s5)
  800406:	6802                	ld	a6,0(sp)
  800408:	4741                	li	a4,16
  80040a:	0aa1                	addi	s5,s5,8
  80040c:	b76d                	j	8003b6 <vprintfmt+0x126>
  80040e:	864e                	mv	a2,s3
  800410:	85ca                	mv	a1,s2
  800412:	02500513          	li	a0,37
  800416:	9482                	jalr	s1
  800418:	b57d                	j	8002c6 <vprintfmt+0x36>
  80041a:	000aad03          	lw	s10,0(s5)
  80041e:	8466                	mv	s0,s9
  800420:	0aa1                	addi	s5,s5,8
  800422:	b7a5                	j	80038a <vprintfmt+0xfa>
  800424:	4785                	li	a5,1
  800426:	008a8613          	addi	a2,s5,8
  80042a:	00b7c463          	blt	a5,a1,800432 <vprintfmt+0x1a2>
  80042e:	12058763          	beqz	a1,80055c <vprintfmt+0x2cc>
  800432:	000ab683          	ld	a3,0(s5)
  800436:	4721                	li	a4,8
  800438:	8ab2                	mv	s5,a2
  80043a:	bfb5                	j	8003b6 <vprintfmt+0x126>
  80043c:	87ee                	mv	a5,s11
  80043e:	000dd363          	bgez	s11,800444 <vprintfmt+0x1b4>
  800442:	4781                	li	a5,0
  800444:	00078d9b          	sext.w	s11,a5
  800448:	8466                	mv	s0,s9
  80044a:	b55d                	j	8002f0 <vprintfmt+0x60>
  80044c:	0008041b          	sext.w	s0,a6
  800450:	fd340793          	addi	a5,s0,-45
  800454:	01b02733          	sgtz	a4,s11
  800458:	00f037b3          	snez	a5,a5
  80045c:	8ff9                	and	a5,a5,a4
  80045e:	000ab703          	ld	a4,0(s5)
  800462:	008a8693          	addi	a3,s5,8
  800466:	e436                	sd	a3,8(sp)
  800468:	12070563          	beqz	a4,800592 <vprintfmt+0x302>
  80046c:	12079d63          	bnez	a5,8005a6 <vprintfmt+0x316>
  800470:	00074783          	lbu	a5,0(a4)
  800474:	0007851b          	sext.w	a0,a5
  800478:	c78d                	beqz	a5,8004a2 <vprintfmt+0x212>
  80047a:	00170a93          	addi	s5,a4,1
  80047e:	547d                	li	s0,-1
  800480:	000d4563          	bltz	s10,80048a <vprintfmt+0x1fa>
  800484:	3d7d                	addiw	s10,s10,-1
  800486:	008d0e63          	beq	s10,s0,8004a2 <vprintfmt+0x212>
  80048a:	020c1863          	bnez	s8,8004ba <vprintfmt+0x22a>
  80048e:	864e                	mv	a2,s3
  800490:	85ca                	mv	a1,s2
  800492:	9482                	jalr	s1
  800494:	000ac783          	lbu	a5,0(s5)
  800498:	0a85                	addi	s5,s5,1
  80049a:	3dfd                	addiw	s11,s11,-1
  80049c:	0007851b          	sext.w	a0,a5
  8004a0:	f3e5                	bnez	a5,800480 <vprintfmt+0x1f0>
  8004a2:	01b05a63          	blez	s11,8004b6 <vprintfmt+0x226>
  8004a6:	864e                	mv	a2,s3
  8004a8:	85ca                	mv	a1,s2
  8004aa:	02000513          	li	a0,32
  8004ae:	3dfd                	addiw	s11,s11,-1
  8004b0:	9482                	jalr	s1
  8004b2:	fe0d9ae3          	bnez	s11,8004a6 <vprintfmt+0x216>
  8004b6:	6aa2                	ld	s5,8(sp)
  8004b8:	b539                	j	8002c6 <vprintfmt+0x36>
  8004ba:	3781                	addiw	a5,a5,-32
  8004bc:	05e00713          	li	a4,94
  8004c0:	fcf777e3          	bgeu	a4,a5,80048e <vprintfmt+0x1fe>
  8004c4:	03f00513          	li	a0,63
  8004c8:	864e                	mv	a2,s3
  8004ca:	85ca                	mv	a1,s2
  8004cc:	9482                	jalr	s1
  8004ce:	000ac783          	lbu	a5,0(s5)
  8004d2:	0a85                	addi	s5,s5,1
  8004d4:	3dfd                	addiw	s11,s11,-1
  8004d6:	0007851b          	sext.w	a0,a5
  8004da:	d7e1                	beqz	a5,8004a2 <vprintfmt+0x212>
  8004dc:	fa0d54e3          	bgez	s10,800484 <vprintfmt+0x1f4>
  8004e0:	bfe9                	j	8004ba <vprintfmt+0x22a>
  8004e2:	000aa783          	lw	a5,0(s5)
  8004e6:	46e1                	li	a3,24
  8004e8:	0aa1                	addi	s5,s5,8
  8004ea:	41f7d71b          	sraiw	a4,a5,0x1f
  8004ee:	8fb9                	xor	a5,a5,a4
  8004f0:	40e7873b          	subw	a4,a5,a4
  8004f4:	02e6c663          	blt	a3,a4,800520 <vprintfmt+0x290>
  8004f8:	00000797          	auipc	a5,0x0
  8004fc:	5f078793          	addi	a5,a5,1520 # 800ae8 <error_string>
  800500:	00371693          	slli	a3,a4,0x3
  800504:	97b6                	add	a5,a5,a3
  800506:	639c                	ld	a5,0(a5)
  800508:	cf81                	beqz	a5,800520 <vprintfmt+0x290>
  80050a:	873e                	mv	a4,a5
  80050c:	00000697          	auipc	a3,0x0
  800510:	26c68693          	addi	a3,a3,620 # 800778 <main+0x132>
  800514:	864a                	mv	a2,s2
  800516:	85ce                	mv	a1,s3
  800518:	8526                	mv	a0,s1
  80051a:	0f2000ef          	jal	80060c <printfmt>
  80051e:	b365                	j	8002c6 <vprintfmt+0x36>
  800520:	00000697          	auipc	a3,0x0
  800524:	24868693          	addi	a3,a3,584 # 800768 <main+0x122>
  800528:	864a                	mv	a2,s2
  80052a:	85ce                	mv	a1,s3
  80052c:	8526                	mv	a0,s1
  80052e:	0de000ef          	jal	80060c <printfmt>
  800532:	bb51                	j	8002c6 <vprintfmt+0x36>
  800534:	4785                	li	a5,1
  800536:	008a8c13          	addi	s8,s5,8
  80053a:	00b7c363          	blt	a5,a1,800540 <vprintfmt+0x2b0>
  80053e:	cd81                	beqz	a1,800556 <vprintfmt+0x2c6>
  800540:	000ab403          	ld	s0,0(s5)
  800544:	02044b63          	bltz	s0,80057a <vprintfmt+0x2ea>
  800548:	86a2                	mv	a3,s0
  80054a:	8ae2                	mv	s5,s8
  80054c:	4729                	li	a4,10
  80054e:	b5a5                	j	8003b6 <vprintfmt+0x126>
  800550:	2585                	addiw	a1,a1,1
  800552:	8466                	mv	s0,s9
  800554:	bb71                	j	8002f0 <vprintfmt+0x60>
  800556:	000aa403          	lw	s0,0(s5)
  80055a:	b7ed                	j	800544 <vprintfmt+0x2b4>
  80055c:	000ae683          	lwu	a3,0(s5)
  800560:	4721                	li	a4,8
  800562:	8ab2                	mv	s5,a2
  800564:	bd89                	j	8003b6 <vprintfmt+0x126>
  800566:	000ae683          	lwu	a3,0(s5)
  80056a:	4729                	li	a4,10
  80056c:	8ab2                	mv	s5,a2
  80056e:	b5a1                	j	8003b6 <vprintfmt+0x126>
  800570:	000ae683          	lwu	a3,0(s5)
  800574:	4741                	li	a4,16
  800576:	8ab2                	mv	s5,a2
  800578:	bd3d                	j	8003b6 <vprintfmt+0x126>
  80057a:	864e                	mv	a2,s3
  80057c:	85ca                	mv	a1,s2
  80057e:	02d00513          	li	a0,45
  800582:	e042                	sd	a6,0(sp)
  800584:	9482                	jalr	s1
  800586:	6802                	ld	a6,0(sp)
  800588:	408006b3          	neg	a3,s0
  80058c:	8ae2                	mv	s5,s8
  80058e:	4729                	li	a4,10
  800590:	b51d                	j	8003b6 <vprintfmt+0x126>
  800592:	eba1                	bnez	a5,8005e2 <vprintfmt+0x352>
  800594:	02800793          	li	a5,40
  800598:	853e                	mv	a0,a5
  80059a:	00000a97          	auipc	s5,0x0
  80059e:	1c7a8a93          	addi	s5,s5,455 # 800761 <main+0x11b>
  8005a2:	547d                	li	s0,-1
  8005a4:	bdf1                	j	800480 <vprintfmt+0x1f0>
  8005a6:	853a                	mv	a0,a4
  8005a8:	85ea                	mv	a1,s10
  8005aa:	e03a                	sd	a4,0(sp)
  8005ac:	07e000ef          	jal	80062a <strnlen>
  8005b0:	40ad8dbb          	subw	s11,s11,a0
  8005b4:	6702                	ld	a4,0(sp)
  8005b6:	01b05b63          	blez	s11,8005cc <vprintfmt+0x33c>
  8005ba:	864e                	mv	a2,s3
  8005bc:	85ca                	mv	a1,s2
  8005be:	8522                	mv	a0,s0
  8005c0:	e03a                	sd	a4,0(sp)
  8005c2:	3dfd                	addiw	s11,s11,-1
  8005c4:	9482                	jalr	s1
  8005c6:	6702                	ld	a4,0(sp)
  8005c8:	fe0d99e3          	bnez	s11,8005ba <vprintfmt+0x32a>
  8005cc:	00074783          	lbu	a5,0(a4)
  8005d0:	0007851b          	sext.w	a0,a5
  8005d4:	ee0781e3          	beqz	a5,8004b6 <vprintfmt+0x226>
  8005d8:	00170a93          	addi	s5,a4,1
  8005dc:	b54d                	j	80047e <vprintfmt+0x1ee>
  8005de:	8466                	mv	s0,s9
  8005e0:	b36d                	j	80038a <vprintfmt+0xfa>
  8005e2:	85ea                	mv	a1,s10
  8005e4:	00000517          	auipc	a0,0x0
  8005e8:	17c50513          	addi	a0,a0,380 # 800760 <main+0x11a>
  8005ec:	03e000ef          	jal	80062a <strnlen>
  8005f0:	40ad8dbb          	subw	s11,s11,a0
  8005f4:	02800793          	li	a5,40
  8005f8:	00000717          	auipc	a4,0x0
  8005fc:	16870713          	addi	a4,a4,360 # 800760 <main+0x11a>
  800600:	853e                	mv	a0,a5
  800602:	fbb04ce3          	bgtz	s11,8005ba <vprintfmt+0x32a>
  800606:	00170a93          	addi	s5,a4,1
  80060a:	bd95                	j	80047e <vprintfmt+0x1ee>

000000000080060c <printfmt>:
  80060c:	7139                	addi	sp,sp,-64
  80060e:	02010313          	addi	t1,sp,32
  800612:	f03a                	sd	a4,32(sp)
  800614:	871a                	mv	a4,t1
  800616:	ec06                	sd	ra,24(sp)
  800618:	f43e                	sd	a5,40(sp)
  80061a:	f842                	sd	a6,48(sp)
  80061c:	fc46                	sd	a7,56(sp)
  80061e:	e41a                	sd	t1,8(sp)
  800620:	c71ff0ef          	jal	800290 <vprintfmt>
  800624:	60e2                	ld	ra,24(sp)
  800626:	6121                	addi	sp,sp,64
  800628:	8082                	ret

000000000080062a <strnlen>:
  80062a:	4781                	li	a5,0
  80062c:	e589                	bnez	a1,800636 <strnlen+0xc>
  80062e:	a811                	j	800642 <strnlen+0x18>
  800630:	0785                	addi	a5,a5,1
  800632:	00f58863          	beq	a1,a5,800642 <strnlen+0x18>
  800636:	00f50733          	add	a4,a0,a5
  80063a:	00074703          	lbu	a4,0(a4)
  80063e:	fb6d                	bnez	a4,800630 <strnlen+0x6>
  800640:	85be                	mv	a1,a5
  800642:	852e                	mv	a0,a1
  800644:	8082                	ret

0000000000800646 <main>:
  800646:	1141                	addi	sp,sp,-16
  800648:	00000517          	auipc	a0,0x0
  80064c:	31050513          	addi	a0,a0,784 # 800958 <main+0x312>
  800650:	e406                	sd	ra,8(sp)
  800652:	a61ff0ef          	jal	8000b2 <cprintf>
  800656:	b13ff0ef          	jal	800168 <getpid>
  80065a:	85aa                	mv	a1,a0
  80065c:	00000517          	auipc	a0,0x0
  800660:	30c50513          	addi	a0,a0,780 # 800968 <main+0x322>
  800664:	a4fff0ef          	jal	8000b2 <cprintf>
  800668:	00000517          	auipc	a0,0x0
  80066c:	31850513          	addi	a0,a0,792 # 800980 <main+0x33a>
  800670:	a43ff0ef          	jal	8000b2 <cprintf>
  800674:	60a2                	ld	ra,8(sp)
  800676:	4501                	li	a0,0
  800678:	0141                	addi	sp,sp,16
  80067a:	8082                	ret
