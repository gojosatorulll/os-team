
obj/__user_forktree.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa29                	j	80013e <sys_open>

0000000000800026 <close>:
  800026:	a20d                	j	800148 <sys_close>

0000000000800028 <dup2>:
  800028:	a225                	j	800150 <sys_dup>

000000000080002a <_start>:
  80002a:	18e000ef          	jal	8001b8 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__warn>:
  800030:	715d                	addi	sp,sp,-80
  800032:	e822                	sd	s0,16(sp)
  800034:	02810313          	addi	t1,sp,40
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	77a50513          	addi	a0,a0,1914 # 8007b8 <main+0x3a>
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
  800064:	7b050513          	addi	a0,a0,1968 # 800810 <main+0x92>
  800068:	04a000ef          	jal	8000b2 <cprintf>
  80006c:	60e2                	ld	ra,24(sp)
  80006e:	6442                	ld	s0,16(sp)
  800070:	6161                	addi	sp,sp,80
  800072:	8082                	ret

0000000000800074 <cputch>:
  800074:	1101                	addi	sp,sp,-32
  800076:	ec06                	sd	ra,24(sp)
  800078:	e42e                	sd	a1,8(sp)
  80007a:	0be000ef          	jal	800138 <sys_putc>
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
  80009e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ef9>
  8000a2:	ec06                	sd	ra,24(sp)
  8000a4:	c602                	sw	zero,12(sp)
  8000a6:	210000ef          	jal	8002b6 <vprintfmt>
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
  8000d0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ef9>
  8000d4:	ec06                	sd	ra,24(sp)
  8000d6:	e4be                	sd	a5,72(sp)
  8000d8:	e8c2                	sd	a6,80(sp)
  8000da:	ecc6                	sd	a7,88(sp)
  8000dc:	c202                	sw	zero,4(sp)
  8000de:	e41a                	sd	t1,8(sp)
  8000e0:	1d6000ef          	jal	8002b6 <vprintfmt>
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

000000000080012c <sys_fork>:
  80012c:	4509                	li	a0,2
  80012e:	bf7d                	j	8000ec <syscall>

0000000000800130 <sys_yield>:
  800130:	4529                	li	a0,10
  800132:	bf6d                	j	8000ec <syscall>

0000000000800134 <sys_getpid>:
  800134:	4549                	li	a0,18
  800136:	bf5d                	j	8000ec <syscall>

0000000000800138 <sys_putc>:
  800138:	85aa                	mv	a1,a0
  80013a:	4579                	li	a0,30
  80013c:	bf45                	j	8000ec <syscall>

000000000080013e <sys_open>:
  80013e:	862e                	mv	a2,a1
  800140:	85aa                	mv	a1,a0
  800142:	06400513          	li	a0,100
  800146:	b75d                	j	8000ec <syscall>

0000000000800148 <sys_close>:
  800148:	85aa                	mv	a1,a0
  80014a:	06500513          	li	a0,101
  80014e:	bf79                	j	8000ec <syscall>

0000000000800150 <sys_dup>:
  800150:	862e                	mv	a2,a1
  800152:	85aa                	mv	a1,a0
  800154:	08200513          	li	a0,130
  800158:	bf51                	j	8000ec <syscall>

000000000080015a <exit>:
  80015a:	1141                	addi	sp,sp,-16
  80015c:	e406                	sd	ra,8(sp)
  80015e:	fc9ff0ef          	jal	800126 <sys_exit>
  800162:	00000517          	auipc	a0,0x0
  800166:	67650513          	addi	a0,a0,1654 # 8007d8 <main+0x5a>
  80016a:	f49ff0ef          	jal	8000b2 <cprintf>
  80016e:	a001                	j	80016e <exit+0x14>

0000000000800170 <fork>:
  800170:	bf75                	j	80012c <sys_fork>

0000000000800172 <yield>:
  800172:	bf7d                	j	800130 <sys_yield>

0000000000800174 <getpid>:
  800174:	b7c1                	j	800134 <sys_getpid>

0000000000800176 <initfd>:
  800176:	87ae                	mv	a5,a1
  800178:	1101                	addi	sp,sp,-32
  80017a:	e822                	sd	s0,16(sp)
  80017c:	85b2                	mv	a1,a2
  80017e:	842a                	mv	s0,a0
  800180:	853e                	mv	a0,a5
  800182:	ec06                	sd	ra,24(sp)
  800184:	e9dff0ef          	jal	800020 <open>
  800188:	87aa                	mv	a5,a0
  80018a:	00054463          	bltz	a0,800192 <initfd+0x1c>
  80018e:	00851763          	bne	a0,s0,80019c <initfd+0x26>
  800192:	60e2                	ld	ra,24(sp)
  800194:	6442                	ld	s0,16(sp)
  800196:	853e                	mv	a0,a5
  800198:	6105                	addi	sp,sp,32
  80019a:	8082                	ret
  80019c:	e42a                	sd	a0,8(sp)
  80019e:	8522                	mv	a0,s0
  8001a0:	e87ff0ef          	jal	800026 <close>
  8001a4:	6522                	ld	a0,8(sp)
  8001a6:	85a2                	mv	a1,s0
  8001a8:	e81ff0ef          	jal	800028 <dup2>
  8001ac:	842a                	mv	s0,a0
  8001ae:	6522                	ld	a0,8(sp)
  8001b0:	e77ff0ef          	jal	800026 <close>
  8001b4:	87a2                	mv	a5,s0
  8001b6:	bff1                	j	800192 <initfd+0x1c>

00000000008001b8 <umain>:
  8001b8:	1101                	addi	sp,sp,-32
  8001ba:	e822                	sd	s0,16(sp)
  8001bc:	e426                	sd	s1,8(sp)
  8001be:	842a                	mv	s0,a0
  8001c0:	84ae                	mv	s1,a1
  8001c2:	4601                	li	a2,0
  8001c4:	00000597          	auipc	a1,0x0
  8001c8:	62c58593          	addi	a1,a1,1580 # 8007f0 <main+0x72>
  8001cc:	4501                	li	a0,0
  8001ce:	ec06                	sd	ra,24(sp)
  8001d0:	fa7ff0ef          	jal	800176 <initfd>
  8001d4:	02054263          	bltz	a0,8001f8 <umain+0x40>
  8001d8:	4605                	li	a2,1
  8001da:	8532                	mv	a0,a2
  8001dc:	00000597          	auipc	a1,0x0
  8001e0:	65458593          	addi	a1,a1,1620 # 800830 <main+0xb2>
  8001e4:	f93ff0ef          	jal	800176 <initfd>
  8001e8:	02054563          	bltz	a0,800212 <umain+0x5a>
  8001ec:	85a6                	mv	a1,s1
  8001ee:	8522                	mv	a0,s0
  8001f0:	58e000ef          	jal	80077e <main>
  8001f4:	f67ff0ef          	jal	80015a <exit>
  8001f8:	86aa                	mv	a3,a0
  8001fa:	00000617          	auipc	a2,0x0
  8001fe:	5fe60613          	addi	a2,a2,1534 # 8007f8 <main+0x7a>
  800202:	45e9                	li	a1,26
  800204:	00000517          	auipc	a0,0x0
  800208:	61450513          	addi	a0,a0,1556 # 800818 <main+0x9a>
  80020c:	e25ff0ef          	jal	800030 <__warn>
  800210:	b7e1                	j	8001d8 <umain+0x20>
  800212:	86aa                	mv	a3,a0
  800214:	00000617          	auipc	a2,0x0
  800218:	62460613          	addi	a2,a2,1572 # 800838 <main+0xba>
  80021c:	45f5                	li	a1,29
  80021e:	00000517          	auipc	a0,0x0
  800222:	5fa50513          	addi	a0,a0,1530 # 800818 <main+0x9a>
  800226:	e0bff0ef          	jal	800030 <__warn>
  80022a:	b7c9                	j	8001ec <umain+0x34>

000000000080022c <printnum>:
  80022c:	7139                	addi	sp,sp,-64
  80022e:	02071893          	slli	a7,a4,0x20
  800232:	f822                	sd	s0,48(sp)
  800234:	f426                	sd	s1,40(sp)
  800236:	f04a                	sd	s2,32(sp)
  800238:	ec4e                	sd	s3,24(sp)
  80023a:	e456                	sd	s5,8(sp)
  80023c:	0208d893          	srli	a7,a7,0x20
  800240:	fc06                	sd	ra,56(sp)
  800242:	0316fab3          	remu	s5,a3,a7
  800246:	fff7841b          	addiw	s0,a5,-1
  80024a:	84aa                	mv	s1,a0
  80024c:	89ae                	mv	s3,a1
  80024e:	8932                	mv	s2,a2
  800250:	0516f063          	bgeu	a3,a7,800290 <printnum+0x64>
  800254:	e852                	sd	s4,16(sp)
  800256:	4705                	li	a4,1
  800258:	8a42                	mv	s4,a6
  80025a:	00f75863          	bge	a4,a5,80026a <printnum+0x3e>
  80025e:	864e                	mv	a2,s3
  800260:	85ca                	mv	a1,s2
  800262:	8552                	mv	a0,s4
  800264:	347d                	addiw	s0,s0,-1
  800266:	9482                	jalr	s1
  800268:	f87d                	bnez	s0,80025e <printnum+0x32>
  80026a:	6a42                	ld	s4,16(sp)
  80026c:	00000797          	auipc	a5,0x0
  800270:	5ec78793          	addi	a5,a5,1516 # 800858 <main+0xda>
  800274:	97d6                	add	a5,a5,s5
  800276:	7442                	ld	s0,48(sp)
  800278:	0007c503          	lbu	a0,0(a5)
  80027c:	70e2                	ld	ra,56(sp)
  80027e:	6aa2                	ld	s5,8(sp)
  800280:	864e                	mv	a2,s3
  800282:	85ca                	mv	a1,s2
  800284:	69e2                	ld	s3,24(sp)
  800286:	7902                	ld	s2,32(sp)
  800288:	87a6                	mv	a5,s1
  80028a:	74a2                	ld	s1,40(sp)
  80028c:	6121                	addi	sp,sp,64
  80028e:	8782                	jr	a5
  800290:	0316d6b3          	divu	a3,a3,a7
  800294:	87a2                	mv	a5,s0
  800296:	f97ff0ef          	jal	80022c <printnum>
  80029a:	bfc9                	j	80026c <printnum+0x40>

000000000080029c <sprintputch>:
  80029c:	499c                	lw	a5,16(a1)
  80029e:	6198                	ld	a4,0(a1)
  8002a0:	6594                	ld	a3,8(a1)
  8002a2:	2785                	addiw	a5,a5,1
  8002a4:	c99c                	sw	a5,16(a1)
  8002a6:	00d77763          	bgeu	a4,a3,8002b4 <sprintputch+0x18>
  8002aa:	00170793          	addi	a5,a4,1
  8002ae:	e19c                	sd	a5,0(a1)
  8002b0:	00a70023          	sb	a0,0(a4)
  8002b4:	8082                	ret

00000000008002b6 <vprintfmt>:
  8002b6:	7119                	addi	sp,sp,-128
  8002b8:	f4a6                	sd	s1,104(sp)
  8002ba:	f0ca                	sd	s2,96(sp)
  8002bc:	ecce                	sd	s3,88(sp)
  8002be:	e8d2                	sd	s4,80(sp)
  8002c0:	e4d6                	sd	s5,72(sp)
  8002c2:	e0da                	sd	s6,64(sp)
  8002c4:	fc5e                	sd	s7,56(sp)
  8002c6:	f466                	sd	s9,40(sp)
  8002c8:	fc86                	sd	ra,120(sp)
  8002ca:	f8a2                	sd	s0,112(sp)
  8002cc:	f862                	sd	s8,48(sp)
  8002ce:	f06a                	sd	s10,32(sp)
  8002d0:	ec6e                	sd	s11,24(sp)
  8002d2:	84aa                	mv	s1,a0
  8002d4:	8cb6                	mv	s9,a3
  8002d6:	8aba                	mv	s5,a4
  8002d8:	89ae                	mv	s3,a1
  8002da:	8932                	mv	s2,a2
  8002dc:	02500a13          	li	s4,37
  8002e0:	05500b93          	li	s7,85
  8002e4:	00000b17          	auipc	s6,0x0
  8002e8:	7a4b0b13          	addi	s6,s6,1956 # 800a88 <main+0x30a>
  8002ec:	000cc503          	lbu	a0,0(s9)
  8002f0:	001c8413          	addi	s0,s9,1
  8002f4:	01450b63          	beq	a0,s4,80030a <vprintfmt+0x54>
  8002f8:	cd15                	beqz	a0,800334 <vprintfmt+0x7e>
  8002fa:	864e                	mv	a2,s3
  8002fc:	85ca                	mv	a1,s2
  8002fe:	9482                	jalr	s1
  800300:	00044503          	lbu	a0,0(s0)
  800304:	0405                	addi	s0,s0,1
  800306:	ff4519e3          	bne	a0,s4,8002f8 <vprintfmt+0x42>
  80030a:	5d7d                	li	s10,-1
  80030c:	8dea                	mv	s11,s10
  80030e:	02000813          	li	a6,32
  800312:	4c01                	li	s8,0
  800314:	4581                	li	a1,0
  800316:	00044703          	lbu	a4,0(s0)
  80031a:	00140c93          	addi	s9,s0,1
  80031e:	fdd7061b          	addiw	a2,a4,-35
  800322:	0ff67613          	zext.b	a2,a2
  800326:	02cbe663          	bltu	s7,a2,800352 <vprintfmt+0x9c>
  80032a:	060a                	slli	a2,a2,0x2
  80032c:	965a                	add	a2,a2,s6
  80032e:	421c                	lw	a5,0(a2)
  800330:	97da                	add	a5,a5,s6
  800332:	8782                	jr	a5
  800334:	70e6                	ld	ra,120(sp)
  800336:	7446                	ld	s0,112(sp)
  800338:	74a6                	ld	s1,104(sp)
  80033a:	7906                	ld	s2,96(sp)
  80033c:	69e6                	ld	s3,88(sp)
  80033e:	6a46                	ld	s4,80(sp)
  800340:	6aa6                	ld	s5,72(sp)
  800342:	6b06                	ld	s6,64(sp)
  800344:	7be2                	ld	s7,56(sp)
  800346:	7c42                	ld	s8,48(sp)
  800348:	7ca2                	ld	s9,40(sp)
  80034a:	7d02                	ld	s10,32(sp)
  80034c:	6de2                	ld	s11,24(sp)
  80034e:	6109                	addi	sp,sp,128
  800350:	8082                	ret
  800352:	864e                	mv	a2,s3
  800354:	85ca                	mv	a1,s2
  800356:	02500513          	li	a0,37
  80035a:	9482                	jalr	s1
  80035c:	fff44783          	lbu	a5,-1(s0)
  800360:	02500713          	li	a4,37
  800364:	8ca2                	mv	s9,s0
  800366:	f8e783e3          	beq	a5,a4,8002ec <vprintfmt+0x36>
  80036a:	ffecc783          	lbu	a5,-2(s9)
  80036e:	1cfd                	addi	s9,s9,-1
  800370:	fee79de3          	bne	a5,a4,80036a <vprintfmt+0xb4>
  800374:	bfa5                	j	8002ec <vprintfmt+0x36>
  800376:	00144683          	lbu	a3,1(s0)
  80037a:	4525                	li	a0,9
  80037c:	fd070d1b          	addiw	s10,a4,-48
  800380:	fd06879b          	addiw	a5,a3,-48
  800384:	28f56063          	bltu	a0,a5,800604 <vprintfmt+0x34e>
  800388:	2681                	sext.w	a3,a3
  80038a:	8466                	mv	s0,s9
  80038c:	002d179b          	slliw	a5,s10,0x2
  800390:	00144703          	lbu	a4,1(s0)
  800394:	01a787bb          	addw	a5,a5,s10
  800398:	0017979b          	slliw	a5,a5,0x1
  80039c:	9fb5                	addw	a5,a5,a3
  80039e:	fd07061b          	addiw	a2,a4,-48
  8003a2:	0405                	addi	s0,s0,1
  8003a4:	fd078d1b          	addiw	s10,a5,-48
  8003a8:	0007069b          	sext.w	a3,a4
  8003ac:	fec570e3          	bgeu	a0,a2,80038c <vprintfmt+0xd6>
  8003b0:	f60dd3e3          	bgez	s11,800316 <vprintfmt+0x60>
  8003b4:	8dea                	mv	s11,s10
  8003b6:	5d7d                	li	s10,-1
  8003b8:	bfb9                	j	800316 <vprintfmt+0x60>
  8003ba:	883a                	mv	a6,a4
  8003bc:	8466                	mv	s0,s9
  8003be:	bfa1                	j	800316 <vprintfmt+0x60>
  8003c0:	8466                	mv	s0,s9
  8003c2:	4c05                	li	s8,1
  8003c4:	bf89                	j	800316 <vprintfmt+0x60>
  8003c6:	4785                	li	a5,1
  8003c8:	008a8613          	addi	a2,s5,8
  8003cc:	00b7c463          	blt	a5,a1,8003d4 <vprintfmt+0x11e>
  8003d0:	1c058363          	beqz	a1,800596 <vprintfmt+0x2e0>
  8003d4:	000ab683          	ld	a3,0(s5)
  8003d8:	4741                	li	a4,16
  8003da:	8ab2                	mv	s5,a2
  8003dc:	2801                	sext.w	a6,a6
  8003de:	87ee                	mv	a5,s11
  8003e0:	864a                	mv	a2,s2
  8003e2:	85ce                	mv	a1,s3
  8003e4:	8526                	mv	a0,s1
  8003e6:	e47ff0ef          	jal	80022c <printnum>
  8003ea:	b709                	j	8002ec <vprintfmt+0x36>
  8003ec:	000aa503          	lw	a0,0(s5)
  8003f0:	864e                	mv	a2,s3
  8003f2:	85ca                	mv	a1,s2
  8003f4:	9482                	jalr	s1
  8003f6:	0aa1                	addi	s5,s5,8
  8003f8:	bdd5                	j	8002ec <vprintfmt+0x36>
  8003fa:	4785                	li	a5,1
  8003fc:	008a8613          	addi	a2,s5,8
  800400:	00b7c463          	blt	a5,a1,800408 <vprintfmt+0x152>
  800404:	18058463          	beqz	a1,80058c <vprintfmt+0x2d6>
  800408:	000ab683          	ld	a3,0(s5)
  80040c:	4729                	li	a4,10
  80040e:	8ab2                	mv	s5,a2
  800410:	b7f1                	j	8003dc <vprintfmt+0x126>
  800412:	864e                	mv	a2,s3
  800414:	85ca                	mv	a1,s2
  800416:	03000513          	li	a0,48
  80041a:	e042                	sd	a6,0(sp)
  80041c:	9482                	jalr	s1
  80041e:	864e                	mv	a2,s3
  800420:	85ca                	mv	a1,s2
  800422:	07800513          	li	a0,120
  800426:	9482                	jalr	s1
  800428:	000ab683          	ld	a3,0(s5)
  80042c:	6802                	ld	a6,0(sp)
  80042e:	4741                	li	a4,16
  800430:	0aa1                	addi	s5,s5,8
  800432:	b76d                	j	8003dc <vprintfmt+0x126>
  800434:	864e                	mv	a2,s3
  800436:	85ca                	mv	a1,s2
  800438:	02500513          	li	a0,37
  80043c:	9482                	jalr	s1
  80043e:	b57d                	j	8002ec <vprintfmt+0x36>
  800440:	000aad03          	lw	s10,0(s5)
  800444:	8466                	mv	s0,s9
  800446:	0aa1                	addi	s5,s5,8
  800448:	b7a5                	j	8003b0 <vprintfmt+0xfa>
  80044a:	4785                	li	a5,1
  80044c:	008a8613          	addi	a2,s5,8
  800450:	00b7c463          	blt	a5,a1,800458 <vprintfmt+0x1a2>
  800454:	12058763          	beqz	a1,800582 <vprintfmt+0x2cc>
  800458:	000ab683          	ld	a3,0(s5)
  80045c:	4721                	li	a4,8
  80045e:	8ab2                	mv	s5,a2
  800460:	bfb5                	j	8003dc <vprintfmt+0x126>
  800462:	87ee                	mv	a5,s11
  800464:	000dd363          	bgez	s11,80046a <vprintfmt+0x1b4>
  800468:	4781                	li	a5,0
  80046a:	00078d9b          	sext.w	s11,a5
  80046e:	8466                	mv	s0,s9
  800470:	b55d                	j	800316 <vprintfmt+0x60>
  800472:	0008041b          	sext.w	s0,a6
  800476:	fd340793          	addi	a5,s0,-45
  80047a:	01b02733          	sgtz	a4,s11
  80047e:	00f037b3          	snez	a5,a5
  800482:	8ff9                	and	a5,a5,a4
  800484:	000ab703          	ld	a4,0(s5)
  800488:	008a8693          	addi	a3,s5,8
  80048c:	e436                	sd	a3,8(sp)
  80048e:	12070563          	beqz	a4,8005b8 <vprintfmt+0x302>
  800492:	12079d63          	bnez	a5,8005cc <vprintfmt+0x316>
  800496:	00074783          	lbu	a5,0(a4)
  80049a:	0007851b          	sext.w	a0,a5
  80049e:	c78d                	beqz	a5,8004c8 <vprintfmt+0x212>
  8004a0:	00170a93          	addi	s5,a4,1
  8004a4:	547d                	li	s0,-1
  8004a6:	000d4563          	bltz	s10,8004b0 <vprintfmt+0x1fa>
  8004aa:	3d7d                	addiw	s10,s10,-1
  8004ac:	008d0e63          	beq	s10,s0,8004c8 <vprintfmt+0x212>
  8004b0:	020c1863          	bnez	s8,8004e0 <vprintfmt+0x22a>
  8004b4:	864e                	mv	a2,s3
  8004b6:	85ca                	mv	a1,s2
  8004b8:	9482                	jalr	s1
  8004ba:	000ac783          	lbu	a5,0(s5)
  8004be:	0a85                	addi	s5,s5,1
  8004c0:	3dfd                	addiw	s11,s11,-1
  8004c2:	0007851b          	sext.w	a0,a5
  8004c6:	f3e5                	bnez	a5,8004a6 <vprintfmt+0x1f0>
  8004c8:	01b05a63          	blez	s11,8004dc <vprintfmt+0x226>
  8004cc:	864e                	mv	a2,s3
  8004ce:	85ca                	mv	a1,s2
  8004d0:	02000513          	li	a0,32
  8004d4:	3dfd                	addiw	s11,s11,-1
  8004d6:	9482                	jalr	s1
  8004d8:	fe0d9ae3          	bnez	s11,8004cc <vprintfmt+0x216>
  8004dc:	6aa2                	ld	s5,8(sp)
  8004de:	b539                	j	8002ec <vprintfmt+0x36>
  8004e0:	3781                	addiw	a5,a5,-32
  8004e2:	05e00713          	li	a4,94
  8004e6:	fcf777e3          	bgeu	a4,a5,8004b4 <vprintfmt+0x1fe>
  8004ea:	03f00513          	li	a0,63
  8004ee:	864e                	mv	a2,s3
  8004f0:	85ca                	mv	a1,s2
  8004f2:	9482                	jalr	s1
  8004f4:	000ac783          	lbu	a5,0(s5)
  8004f8:	0a85                	addi	s5,s5,1
  8004fa:	3dfd                	addiw	s11,s11,-1
  8004fc:	0007851b          	sext.w	a0,a5
  800500:	d7e1                	beqz	a5,8004c8 <vprintfmt+0x212>
  800502:	fa0d54e3          	bgez	s10,8004aa <vprintfmt+0x1f4>
  800506:	bfe9                	j	8004e0 <vprintfmt+0x22a>
  800508:	000aa783          	lw	a5,0(s5)
  80050c:	46e1                	li	a3,24
  80050e:	0aa1                	addi	s5,s5,8
  800510:	41f7d71b          	sraiw	a4,a5,0x1f
  800514:	8fb9                	xor	a5,a5,a4
  800516:	40e7873b          	subw	a4,a5,a4
  80051a:	02e6c663          	blt	a3,a4,800546 <vprintfmt+0x290>
  80051e:	00000797          	auipc	a5,0x0
  800522:	6c278793          	addi	a5,a5,1730 # 800be0 <error_string>
  800526:	00371693          	slli	a3,a4,0x3
  80052a:	97b6                	add	a5,a5,a3
  80052c:	639c                	ld	a5,0(a5)
  80052e:	cf81                	beqz	a5,800546 <vprintfmt+0x290>
  800530:	873e                	mv	a4,a5
  800532:	00000697          	auipc	a3,0x0
  800536:	35668693          	addi	a3,a3,854 # 800888 <main+0x10a>
  80053a:	864a                	mv	a2,s2
  80053c:	85ce                	mv	a1,s3
  80053e:	8526                	mv	a0,s1
  800540:	0f2000ef          	jal	800632 <printfmt>
  800544:	b365                	j	8002ec <vprintfmt+0x36>
  800546:	00000697          	auipc	a3,0x0
  80054a:	33268693          	addi	a3,a3,818 # 800878 <main+0xfa>
  80054e:	864a                	mv	a2,s2
  800550:	85ce                	mv	a1,s3
  800552:	8526                	mv	a0,s1
  800554:	0de000ef          	jal	800632 <printfmt>
  800558:	bb51                	j	8002ec <vprintfmt+0x36>
  80055a:	4785                	li	a5,1
  80055c:	008a8c13          	addi	s8,s5,8
  800560:	00b7c363          	blt	a5,a1,800566 <vprintfmt+0x2b0>
  800564:	cd81                	beqz	a1,80057c <vprintfmt+0x2c6>
  800566:	000ab403          	ld	s0,0(s5)
  80056a:	02044b63          	bltz	s0,8005a0 <vprintfmt+0x2ea>
  80056e:	86a2                	mv	a3,s0
  800570:	8ae2                	mv	s5,s8
  800572:	4729                	li	a4,10
  800574:	b5a5                	j	8003dc <vprintfmt+0x126>
  800576:	2585                	addiw	a1,a1,1
  800578:	8466                	mv	s0,s9
  80057a:	bb71                	j	800316 <vprintfmt+0x60>
  80057c:	000aa403          	lw	s0,0(s5)
  800580:	b7ed                	j	80056a <vprintfmt+0x2b4>
  800582:	000ae683          	lwu	a3,0(s5)
  800586:	4721                	li	a4,8
  800588:	8ab2                	mv	s5,a2
  80058a:	bd89                	j	8003dc <vprintfmt+0x126>
  80058c:	000ae683          	lwu	a3,0(s5)
  800590:	4729                	li	a4,10
  800592:	8ab2                	mv	s5,a2
  800594:	b5a1                	j	8003dc <vprintfmt+0x126>
  800596:	000ae683          	lwu	a3,0(s5)
  80059a:	4741                	li	a4,16
  80059c:	8ab2                	mv	s5,a2
  80059e:	bd3d                	j	8003dc <vprintfmt+0x126>
  8005a0:	864e                	mv	a2,s3
  8005a2:	85ca                	mv	a1,s2
  8005a4:	02d00513          	li	a0,45
  8005a8:	e042                	sd	a6,0(sp)
  8005aa:	9482                	jalr	s1
  8005ac:	6802                	ld	a6,0(sp)
  8005ae:	408006b3          	neg	a3,s0
  8005b2:	8ae2                	mv	s5,s8
  8005b4:	4729                	li	a4,10
  8005b6:	b51d                	j	8003dc <vprintfmt+0x126>
  8005b8:	eba1                	bnez	a5,800608 <vprintfmt+0x352>
  8005ba:	02800793          	li	a5,40
  8005be:	853e                	mv	a0,a5
  8005c0:	00000a97          	auipc	s5,0x0
  8005c4:	2b1a8a93          	addi	s5,s5,689 # 800871 <main+0xf3>
  8005c8:	547d                	li	s0,-1
  8005ca:	bdf1                	j	8004a6 <vprintfmt+0x1f0>
  8005cc:	853a                	mv	a0,a4
  8005ce:	85ea                	mv	a1,s10
  8005d0:	e03a                	sd	a4,0(sp)
  8005d2:	0e4000ef          	jal	8006b6 <strnlen>
  8005d6:	40ad8dbb          	subw	s11,s11,a0
  8005da:	6702                	ld	a4,0(sp)
  8005dc:	01b05b63          	blez	s11,8005f2 <vprintfmt+0x33c>
  8005e0:	864e                	mv	a2,s3
  8005e2:	85ca                	mv	a1,s2
  8005e4:	8522                	mv	a0,s0
  8005e6:	e03a                	sd	a4,0(sp)
  8005e8:	3dfd                	addiw	s11,s11,-1
  8005ea:	9482                	jalr	s1
  8005ec:	6702                	ld	a4,0(sp)
  8005ee:	fe0d99e3          	bnez	s11,8005e0 <vprintfmt+0x32a>
  8005f2:	00074783          	lbu	a5,0(a4)
  8005f6:	0007851b          	sext.w	a0,a5
  8005fa:	ee0781e3          	beqz	a5,8004dc <vprintfmt+0x226>
  8005fe:	00170a93          	addi	s5,a4,1
  800602:	b54d                	j	8004a4 <vprintfmt+0x1ee>
  800604:	8466                	mv	s0,s9
  800606:	b36d                	j	8003b0 <vprintfmt+0xfa>
  800608:	85ea                	mv	a1,s10
  80060a:	00000517          	auipc	a0,0x0
  80060e:	26650513          	addi	a0,a0,614 # 800870 <main+0xf2>
  800612:	0a4000ef          	jal	8006b6 <strnlen>
  800616:	40ad8dbb          	subw	s11,s11,a0
  80061a:	02800793          	li	a5,40
  80061e:	00000717          	auipc	a4,0x0
  800622:	25270713          	addi	a4,a4,594 # 800870 <main+0xf2>
  800626:	853e                	mv	a0,a5
  800628:	fbb04ce3          	bgtz	s11,8005e0 <vprintfmt+0x32a>
  80062c:	00170a93          	addi	s5,a4,1
  800630:	bd95                	j	8004a4 <vprintfmt+0x1ee>

0000000000800632 <printfmt>:
  800632:	7139                	addi	sp,sp,-64
  800634:	02010313          	addi	t1,sp,32
  800638:	f03a                	sd	a4,32(sp)
  80063a:	871a                	mv	a4,t1
  80063c:	ec06                	sd	ra,24(sp)
  80063e:	f43e                	sd	a5,40(sp)
  800640:	f842                	sd	a6,48(sp)
  800642:	fc46                	sd	a7,56(sp)
  800644:	e41a                	sd	t1,8(sp)
  800646:	c71ff0ef          	jal	8002b6 <vprintfmt>
  80064a:	60e2                	ld	ra,24(sp)
  80064c:	6121                	addi	sp,sp,64
  80064e:	8082                	ret

0000000000800650 <snprintf>:
  800650:	711d                	addi	sp,sp,-96
  800652:	15fd                	addi	a1,a1,-1
  800654:	95aa                	add	a1,a1,a0
  800656:	03810313          	addi	t1,sp,56
  80065a:	f406                	sd	ra,40(sp)
  80065c:	e82e                	sd	a1,16(sp)
  80065e:	e42a                	sd	a0,8(sp)
  800660:	fc36                	sd	a3,56(sp)
  800662:	e0ba                	sd	a4,64(sp)
  800664:	e4be                	sd	a5,72(sp)
  800666:	e8c2                	sd	a6,80(sp)
  800668:	ecc6                	sd	a7,88(sp)
  80066a:	cc02                	sw	zero,24(sp)
  80066c:	e01a                	sd	t1,0(sp)
  80066e:	c515                	beqz	a0,80069a <snprintf+0x4a>
  800670:	02a5e563          	bltu	a1,a0,80069a <snprintf+0x4a>
  800674:	75dd                	lui	a1,0xffff7
  800676:	86b2                	mv	a3,a2
  800678:	00000517          	auipc	a0,0x0
  80067c:	c2450513          	addi	a0,a0,-988 # 80029c <sprintputch>
  800680:	871a                	mv	a4,t1
  800682:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ef9>
  800686:	0030                	addi	a2,sp,8
  800688:	c2fff0ef          	jal	8002b6 <vprintfmt>
  80068c:	67a2                	ld	a5,8(sp)
  80068e:	00078023          	sb	zero,0(a5)
  800692:	4562                	lw	a0,24(sp)
  800694:	70a2                	ld	ra,40(sp)
  800696:	6125                	addi	sp,sp,96
  800698:	8082                	ret
  80069a:	5575                	li	a0,-3
  80069c:	bfe5                	j	800694 <snprintf+0x44>

000000000080069e <strlen>:
  80069e:	00054783          	lbu	a5,0(a0)
  8006a2:	cb81                	beqz	a5,8006b2 <strlen+0x14>
  8006a4:	4781                	li	a5,0
  8006a6:	0785                	addi	a5,a5,1
  8006a8:	00f50733          	add	a4,a0,a5
  8006ac:	00074703          	lbu	a4,0(a4)
  8006b0:	fb7d                	bnez	a4,8006a6 <strlen+0x8>
  8006b2:	853e                	mv	a0,a5
  8006b4:	8082                	ret

00000000008006b6 <strnlen>:
  8006b6:	4781                	li	a5,0
  8006b8:	e589                	bnez	a1,8006c2 <strnlen+0xc>
  8006ba:	a811                	j	8006ce <strnlen+0x18>
  8006bc:	0785                	addi	a5,a5,1
  8006be:	00f58863          	beq	a1,a5,8006ce <strnlen+0x18>
  8006c2:	00f50733          	add	a4,a0,a5
  8006c6:	00074703          	lbu	a4,0(a4)
  8006ca:	fb6d                	bnez	a4,8006bc <strnlen+0x6>
  8006cc:	85be                	mv	a1,a5
  8006ce:	852e                	mv	a0,a1
  8006d0:	8082                	ret

00000000008006d2 <forktree>:
  8006d2:	1101                	addi	sp,sp,-32
  8006d4:	ec06                	sd	ra,24(sp)
  8006d6:	e822                	sd	s0,16(sp)
  8006d8:	842a                	mv	s0,a0
  8006da:	a9bff0ef          	jal	800174 <getpid>
  8006de:	85aa                	mv	a1,a0
  8006e0:	8622                	mv	a2,s0
  8006e2:	00000517          	auipc	a0,0x0
  8006e6:	38650513          	addi	a0,a0,902 # 800a68 <main+0x2ea>
  8006ea:	9c9ff0ef          	jal	8000b2 <cprintf>
  8006ee:	8522                	mv	a0,s0
  8006f0:	fafff0ef          	jal	80069e <strlen>
  8006f4:	4789                	li	a5,2
  8006f6:	00a7f963          	bgeu	a5,a0,800708 <forktree+0x36>
  8006fa:	8522                	mv	a0,s0
  8006fc:	6442                	ld	s0,16(sp)
  8006fe:	60e2                	ld	ra,24(sp)
  800700:	03100593          	li	a1,49
  800704:	6105                	addi	sp,sp,32
  800706:	a03d                	j	800734 <forkchild>
  800708:	03000713          	li	a4,48
  80070c:	86a2                	mv	a3,s0
  80070e:	00000617          	auipc	a2,0x0
  800712:	37260613          	addi	a2,a2,882 # 800a80 <main+0x302>
  800716:	4591                	li	a1,4
  800718:	0028                	addi	a0,sp,8
  80071a:	f37ff0ef          	jal	800650 <snprintf>
  80071e:	a53ff0ef          	jal	800170 <fork>
  800722:	fd61                	bnez	a0,8006fa <forktree+0x28>
  800724:	0028                	addi	a0,sp,8
  800726:	fadff0ef          	jal	8006d2 <forktree>
  80072a:	a49ff0ef          	jal	800172 <yield>
  80072e:	4501                	li	a0,0
  800730:	a2bff0ef          	jal	80015a <exit>

0000000000800734 <forkchild>:
  800734:	7179                	addi	sp,sp,-48
  800736:	f022                	sd	s0,32(sp)
  800738:	ec26                	sd	s1,24(sp)
  80073a:	f406                	sd	ra,40(sp)
  80073c:	84ae                	mv	s1,a1
  80073e:	842a                	mv	s0,a0
  800740:	f5fff0ef          	jal	80069e <strlen>
  800744:	4789                	li	a5,2
  800746:	00a7f763          	bgeu	a5,a0,800754 <forkchild+0x20>
  80074a:	70a2                	ld	ra,40(sp)
  80074c:	7402                	ld	s0,32(sp)
  80074e:	64e2                	ld	s1,24(sp)
  800750:	6145                	addi	sp,sp,48
  800752:	8082                	ret
  800754:	8726                	mv	a4,s1
  800756:	86a2                	mv	a3,s0
  800758:	00000617          	auipc	a2,0x0
  80075c:	32860613          	addi	a2,a2,808 # 800a80 <main+0x302>
  800760:	4591                	li	a1,4
  800762:	0028                	addi	a0,sp,8
  800764:	eedff0ef          	jal	800650 <snprintf>
  800768:	a09ff0ef          	jal	800170 <fork>
  80076c:	fd79                	bnez	a0,80074a <forkchild+0x16>
  80076e:	0028                	addi	a0,sp,8
  800770:	f63ff0ef          	jal	8006d2 <forktree>
  800774:	9ffff0ef          	jal	800172 <yield>
  800778:	4501                	li	a0,0
  80077a:	9e1ff0ef          	jal	80015a <exit>

000000000080077e <main>:
  80077e:	1141                	addi	sp,sp,-16
  800780:	00000517          	auipc	a0,0x0
  800784:	2f850513          	addi	a0,a0,760 # 800a78 <main+0x2fa>
  800788:	e406                	sd	ra,8(sp)
  80078a:	f49ff0ef          	jal	8006d2 <forktree>
  80078e:	60a2                	ld	ra,8(sp)
  800790:	4501                	li	a0,0
  800792:	0141                	addi	sp,sp,16
  800794:	8082                	ret
