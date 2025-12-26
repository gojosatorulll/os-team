
obj/__user_faultread.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a239                	j	800132 <sys_open>

0000000000800026 <close>:
  800026:	aa19                	j	80013c <sys_close>

0000000000800028 <dup2>:
  800028:	aa31                	j	800144 <sys_dup>

000000000080002a <_start>:
  80002a:	17c000ef          	jal	8001a6 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__warn>:
  800030:	715d                	addi	sp,sp,-80
  800032:	e822                	sd	s0,16(sp)
  800034:	02810313          	addi	t1,sp,40
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	63250513          	addi	a0,a0,1586 # 800670 <main+0x30>
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
  800064:	60850513          	addi	a0,a0,1544 # 800668 <main+0x28>
  800068:	04a000ef          	jal	8000b2 <cprintf>
  80006c:	60e2                	ld	ra,24(sp)
  80006e:	6442                	ld	s0,16(sp)
  800070:	6161                	addi	sp,sp,80
  800072:	8082                	ret

0000000000800074 <cputch>:
  800074:	1101                	addi	sp,sp,-32
  800076:	ec06                	sd	ra,24(sp)
  800078:	e42e                	sd	a1,8(sp)
  80007a:	0b2000ef          	jal	80012c <sys_putc>
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
  80009e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6061>
  8000a2:	ec06                	sd	ra,24(sp)
  8000a4:	c602                	sw	zero,12(sp)
  8000a6:	1e4000ef          	jal	80028a <vprintfmt>
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
  8000d0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6061>
  8000d4:	ec06                	sd	ra,24(sp)
  8000d6:	e4be                	sd	a5,72(sp)
  8000d8:	e8c2                	sd	a6,80(sp)
  8000da:	ecc6                	sd	a7,88(sp)
  8000dc:	c202                	sw	zero,4(sp)
  8000de:	e41a                	sd	t1,8(sp)
  8000e0:	1aa000ef          	jal	80028a <vprintfmt>
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

000000000080012c <sys_putc>:
  80012c:	85aa                	mv	a1,a0
  80012e:	4579                	li	a0,30
  800130:	bf75                	j	8000ec <syscall>

0000000000800132 <sys_open>:
  800132:	862e                	mv	a2,a1
  800134:	85aa                	mv	a1,a0
  800136:	06400513          	li	a0,100
  80013a:	bf4d                	j	8000ec <syscall>

000000000080013c <sys_close>:
  80013c:	85aa                	mv	a1,a0
  80013e:	06500513          	li	a0,101
  800142:	b76d                	j	8000ec <syscall>

0000000000800144 <sys_dup>:
  800144:	862e                	mv	a2,a1
  800146:	85aa                	mv	a1,a0
  800148:	08200513          	li	a0,130
  80014c:	b745                	j	8000ec <syscall>

000000000080014e <exit>:
  80014e:	1141                	addi	sp,sp,-16
  800150:	e406                	sd	ra,8(sp)
  800152:	fd5ff0ef          	jal	800126 <sys_exit>
  800156:	00000517          	auipc	a0,0x0
  80015a:	53a50513          	addi	a0,a0,1338 # 800690 <main+0x50>
  80015e:	f55ff0ef          	jal	8000b2 <cprintf>
  800162:	a001                	j	800162 <exit+0x14>

0000000000800164 <initfd>:
  800164:	87ae                	mv	a5,a1
  800166:	1101                	addi	sp,sp,-32
  800168:	e822                	sd	s0,16(sp)
  80016a:	85b2                	mv	a1,a2
  80016c:	842a                	mv	s0,a0
  80016e:	853e                	mv	a0,a5
  800170:	ec06                	sd	ra,24(sp)
  800172:	eafff0ef          	jal	800020 <open>
  800176:	87aa                	mv	a5,a0
  800178:	00054463          	bltz	a0,800180 <initfd+0x1c>
  80017c:	00851763          	bne	a0,s0,80018a <initfd+0x26>
  800180:	60e2                	ld	ra,24(sp)
  800182:	6442                	ld	s0,16(sp)
  800184:	853e                	mv	a0,a5
  800186:	6105                	addi	sp,sp,32
  800188:	8082                	ret
  80018a:	e42a                	sd	a0,8(sp)
  80018c:	8522                	mv	a0,s0
  80018e:	e99ff0ef          	jal	800026 <close>
  800192:	6522                	ld	a0,8(sp)
  800194:	85a2                	mv	a1,s0
  800196:	e93ff0ef          	jal	800028 <dup2>
  80019a:	842a                	mv	s0,a0
  80019c:	6522                	ld	a0,8(sp)
  80019e:	e89ff0ef          	jal	800026 <close>
  8001a2:	87a2                	mv	a5,s0
  8001a4:	bff1                	j	800180 <initfd+0x1c>

00000000008001a6 <umain>:
  8001a6:	1101                	addi	sp,sp,-32
  8001a8:	e822                	sd	s0,16(sp)
  8001aa:	e426                	sd	s1,8(sp)
  8001ac:	842a                	mv	s0,a0
  8001ae:	84ae                	mv	s1,a1
  8001b0:	4601                	li	a2,0
  8001b2:	00000597          	auipc	a1,0x0
  8001b6:	4f658593          	addi	a1,a1,1270 # 8006a8 <main+0x68>
  8001ba:	4501                	li	a0,0
  8001bc:	ec06                	sd	ra,24(sp)
  8001be:	fa7ff0ef          	jal	800164 <initfd>
  8001c2:	02054263          	bltz	a0,8001e6 <umain+0x40>
  8001c6:	4605                	li	a2,1
  8001c8:	8532                	mv	a0,a2
  8001ca:	00000597          	auipc	a1,0x0
  8001ce:	51e58593          	addi	a1,a1,1310 # 8006e8 <main+0xa8>
  8001d2:	f93ff0ef          	jal	800164 <initfd>
  8001d6:	02054563          	bltz	a0,800200 <umain+0x5a>
  8001da:	85a6                	mv	a1,s1
  8001dc:	8522                	mv	a0,s0
  8001de:	462000ef          	jal	800640 <main>
  8001e2:	f6dff0ef          	jal	80014e <exit>
  8001e6:	86aa                	mv	a3,a0
  8001e8:	00000617          	auipc	a2,0x0
  8001ec:	4c860613          	addi	a2,a2,1224 # 8006b0 <main+0x70>
  8001f0:	45e9                	li	a1,26
  8001f2:	00000517          	auipc	a0,0x0
  8001f6:	4de50513          	addi	a0,a0,1246 # 8006d0 <main+0x90>
  8001fa:	e37ff0ef          	jal	800030 <__warn>
  8001fe:	b7e1                	j	8001c6 <umain+0x20>
  800200:	86aa                	mv	a3,a0
  800202:	00000617          	auipc	a2,0x0
  800206:	4ee60613          	addi	a2,a2,1262 # 8006f0 <main+0xb0>
  80020a:	45f5                	li	a1,29
  80020c:	00000517          	auipc	a0,0x0
  800210:	4c450513          	addi	a0,a0,1220 # 8006d0 <main+0x90>
  800214:	e1dff0ef          	jal	800030 <__warn>
  800218:	b7c9                	j	8001da <umain+0x34>

000000000080021a <printnum>:
  80021a:	7139                	addi	sp,sp,-64
  80021c:	02071893          	slli	a7,a4,0x20
  800220:	f822                	sd	s0,48(sp)
  800222:	f426                	sd	s1,40(sp)
  800224:	f04a                	sd	s2,32(sp)
  800226:	ec4e                	sd	s3,24(sp)
  800228:	e456                	sd	s5,8(sp)
  80022a:	0208d893          	srli	a7,a7,0x20
  80022e:	fc06                	sd	ra,56(sp)
  800230:	0316fab3          	remu	s5,a3,a7
  800234:	fff7841b          	addiw	s0,a5,-1
  800238:	84aa                	mv	s1,a0
  80023a:	89ae                	mv	s3,a1
  80023c:	8932                	mv	s2,a2
  80023e:	0516f063          	bgeu	a3,a7,80027e <printnum+0x64>
  800242:	e852                	sd	s4,16(sp)
  800244:	4705                	li	a4,1
  800246:	8a42                	mv	s4,a6
  800248:	00f75863          	bge	a4,a5,800258 <printnum+0x3e>
  80024c:	864e                	mv	a2,s3
  80024e:	85ca                	mv	a1,s2
  800250:	8552                	mv	a0,s4
  800252:	347d                	addiw	s0,s0,-1
  800254:	9482                	jalr	s1
  800256:	f87d                	bnez	s0,80024c <printnum+0x32>
  800258:	6a42                	ld	s4,16(sp)
  80025a:	00000797          	auipc	a5,0x0
  80025e:	4b678793          	addi	a5,a5,1206 # 800710 <main+0xd0>
  800262:	97d6                	add	a5,a5,s5
  800264:	7442                	ld	s0,48(sp)
  800266:	0007c503          	lbu	a0,0(a5)
  80026a:	70e2                	ld	ra,56(sp)
  80026c:	6aa2                	ld	s5,8(sp)
  80026e:	864e                	mv	a2,s3
  800270:	85ca                	mv	a1,s2
  800272:	69e2                	ld	s3,24(sp)
  800274:	7902                	ld	s2,32(sp)
  800276:	87a6                	mv	a5,s1
  800278:	74a2                	ld	s1,40(sp)
  80027a:	6121                	addi	sp,sp,64
  80027c:	8782                	jr	a5
  80027e:	0316d6b3          	divu	a3,a3,a7
  800282:	87a2                	mv	a5,s0
  800284:	f97ff0ef          	jal	80021a <printnum>
  800288:	bfc9                	j	80025a <printnum+0x40>

000000000080028a <vprintfmt>:
  80028a:	7119                	addi	sp,sp,-128
  80028c:	f4a6                	sd	s1,104(sp)
  80028e:	f0ca                	sd	s2,96(sp)
  800290:	ecce                	sd	s3,88(sp)
  800292:	e8d2                	sd	s4,80(sp)
  800294:	e4d6                	sd	s5,72(sp)
  800296:	e0da                	sd	s6,64(sp)
  800298:	fc5e                	sd	s7,56(sp)
  80029a:	f466                	sd	s9,40(sp)
  80029c:	fc86                	sd	ra,120(sp)
  80029e:	f8a2                	sd	s0,112(sp)
  8002a0:	f862                	sd	s8,48(sp)
  8002a2:	f06a                	sd	s10,32(sp)
  8002a4:	ec6e                	sd	s11,24(sp)
  8002a6:	84aa                	mv	s1,a0
  8002a8:	8cb6                	mv	s9,a3
  8002aa:	8aba                	mv	s5,a4
  8002ac:	89ae                	mv	s3,a1
  8002ae:	8932                	mv	s2,a2
  8002b0:	02500a13          	li	s4,37
  8002b4:	05500b93          	li	s7,85
  8002b8:	00000b17          	auipc	s6,0x0
  8002bc:	668b0b13          	addi	s6,s6,1640 # 800920 <main+0x2e0>
  8002c0:	000cc503          	lbu	a0,0(s9)
  8002c4:	001c8413          	addi	s0,s9,1
  8002c8:	01450b63          	beq	a0,s4,8002de <vprintfmt+0x54>
  8002cc:	cd15                	beqz	a0,800308 <vprintfmt+0x7e>
  8002ce:	864e                	mv	a2,s3
  8002d0:	85ca                	mv	a1,s2
  8002d2:	9482                	jalr	s1
  8002d4:	00044503          	lbu	a0,0(s0)
  8002d8:	0405                	addi	s0,s0,1
  8002da:	ff4519e3          	bne	a0,s4,8002cc <vprintfmt+0x42>
  8002de:	5d7d                	li	s10,-1
  8002e0:	8dea                	mv	s11,s10
  8002e2:	02000813          	li	a6,32
  8002e6:	4c01                	li	s8,0
  8002e8:	4581                	li	a1,0
  8002ea:	00044703          	lbu	a4,0(s0)
  8002ee:	00140c93          	addi	s9,s0,1
  8002f2:	fdd7061b          	addiw	a2,a4,-35
  8002f6:	0ff67613          	zext.b	a2,a2
  8002fa:	02cbe663          	bltu	s7,a2,800326 <vprintfmt+0x9c>
  8002fe:	060a                	slli	a2,a2,0x2
  800300:	965a                	add	a2,a2,s6
  800302:	421c                	lw	a5,0(a2)
  800304:	97da                	add	a5,a5,s6
  800306:	8782                	jr	a5
  800308:	70e6                	ld	ra,120(sp)
  80030a:	7446                	ld	s0,112(sp)
  80030c:	74a6                	ld	s1,104(sp)
  80030e:	7906                	ld	s2,96(sp)
  800310:	69e6                	ld	s3,88(sp)
  800312:	6a46                	ld	s4,80(sp)
  800314:	6aa6                	ld	s5,72(sp)
  800316:	6b06                	ld	s6,64(sp)
  800318:	7be2                	ld	s7,56(sp)
  80031a:	7c42                	ld	s8,48(sp)
  80031c:	7ca2                	ld	s9,40(sp)
  80031e:	7d02                	ld	s10,32(sp)
  800320:	6de2                	ld	s11,24(sp)
  800322:	6109                	addi	sp,sp,128
  800324:	8082                	ret
  800326:	864e                	mv	a2,s3
  800328:	85ca                	mv	a1,s2
  80032a:	02500513          	li	a0,37
  80032e:	9482                	jalr	s1
  800330:	fff44783          	lbu	a5,-1(s0)
  800334:	02500713          	li	a4,37
  800338:	8ca2                	mv	s9,s0
  80033a:	f8e783e3          	beq	a5,a4,8002c0 <vprintfmt+0x36>
  80033e:	ffecc783          	lbu	a5,-2(s9)
  800342:	1cfd                	addi	s9,s9,-1
  800344:	fee79de3          	bne	a5,a4,80033e <vprintfmt+0xb4>
  800348:	bfa5                	j	8002c0 <vprintfmt+0x36>
  80034a:	00144683          	lbu	a3,1(s0)
  80034e:	4525                	li	a0,9
  800350:	fd070d1b          	addiw	s10,a4,-48
  800354:	fd06879b          	addiw	a5,a3,-48
  800358:	28f56063          	bltu	a0,a5,8005d8 <vprintfmt+0x34e>
  80035c:	2681                	sext.w	a3,a3
  80035e:	8466                	mv	s0,s9
  800360:	002d179b          	slliw	a5,s10,0x2
  800364:	00144703          	lbu	a4,1(s0)
  800368:	01a787bb          	addw	a5,a5,s10
  80036c:	0017979b          	slliw	a5,a5,0x1
  800370:	9fb5                	addw	a5,a5,a3
  800372:	fd07061b          	addiw	a2,a4,-48
  800376:	0405                	addi	s0,s0,1
  800378:	fd078d1b          	addiw	s10,a5,-48
  80037c:	0007069b          	sext.w	a3,a4
  800380:	fec570e3          	bgeu	a0,a2,800360 <vprintfmt+0xd6>
  800384:	f60dd3e3          	bgez	s11,8002ea <vprintfmt+0x60>
  800388:	8dea                	mv	s11,s10
  80038a:	5d7d                	li	s10,-1
  80038c:	bfb9                	j	8002ea <vprintfmt+0x60>
  80038e:	883a                	mv	a6,a4
  800390:	8466                	mv	s0,s9
  800392:	bfa1                	j	8002ea <vprintfmt+0x60>
  800394:	8466                	mv	s0,s9
  800396:	4c05                	li	s8,1
  800398:	bf89                	j	8002ea <vprintfmt+0x60>
  80039a:	4785                	li	a5,1
  80039c:	008a8613          	addi	a2,s5,8
  8003a0:	00b7c463          	blt	a5,a1,8003a8 <vprintfmt+0x11e>
  8003a4:	1c058363          	beqz	a1,80056a <vprintfmt+0x2e0>
  8003a8:	000ab683          	ld	a3,0(s5)
  8003ac:	4741                	li	a4,16
  8003ae:	8ab2                	mv	s5,a2
  8003b0:	2801                	sext.w	a6,a6
  8003b2:	87ee                	mv	a5,s11
  8003b4:	864a                	mv	a2,s2
  8003b6:	85ce                	mv	a1,s3
  8003b8:	8526                	mv	a0,s1
  8003ba:	e61ff0ef          	jal	80021a <printnum>
  8003be:	b709                	j	8002c0 <vprintfmt+0x36>
  8003c0:	000aa503          	lw	a0,0(s5)
  8003c4:	864e                	mv	a2,s3
  8003c6:	85ca                	mv	a1,s2
  8003c8:	9482                	jalr	s1
  8003ca:	0aa1                	addi	s5,s5,8
  8003cc:	bdd5                	j	8002c0 <vprintfmt+0x36>
  8003ce:	4785                	li	a5,1
  8003d0:	008a8613          	addi	a2,s5,8
  8003d4:	00b7c463          	blt	a5,a1,8003dc <vprintfmt+0x152>
  8003d8:	18058463          	beqz	a1,800560 <vprintfmt+0x2d6>
  8003dc:	000ab683          	ld	a3,0(s5)
  8003e0:	4729                	li	a4,10
  8003e2:	8ab2                	mv	s5,a2
  8003e4:	b7f1                	j	8003b0 <vprintfmt+0x126>
  8003e6:	864e                	mv	a2,s3
  8003e8:	85ca                	mv	a1,s2
  8003ea:	03000513          	li	a0,48
  8003ee:	e042                	sd	a6,0(sp)
  8003f0:	9482                	jalr	s1
  8003f2:	864e                	mv	a2,s3
  8003f4:	85ca                	mv	a1,s2
  8003f6:	07800513          	li	a0,120
  8003fa:	9482                	jalr	s1
  8003fc:	000ab683          	ld	a3,0(s5)
  800400:	6802                	ld	a6,0(sp)
  800402:	4741                	li	a4,16
  800404:	0aa1                	addi	s5,s5,8
  800406:	b76d                	j	8003b0 <vprintfmt+0x126>
  800408:	864e                	mv	a2,s3
  80040a:	85ca                	mv	a1,s2
  80040c:	02500513          	li	a0,37
  800410:	9482                	jalr	s1
  800412:	b57d                	j	8002c0 <vprintfmt+0x36>
  800414:	000aad03          	lw	s10,0(s5)
  800418:	8466                	mv	s0,s9
  80041a:	0aa1                	addi	s5,s5,8
  80041c:	b7a5                	j	800384 <vprintfmt+0xfa>
  80041e:	4785                	li	a5,1
  800420:	008a8613          	addi	a2,s5,8
  800424:	00b7c463          	blt	a5,a1,80042c <vprintfmt+0x1a2>
  800428:	12058763          	beqz	a1,800556 <vprintfmt+0x2cc>
  80042c:	000ab683          	ld	a3,0(s5)
  800430:	4721                	li	a4,8
  800432:	8ab2                	mv	s5,a2
  800434:	bfb5                	j	8003b0 <vprintfmt+0x126>
  800436:	87ee                	mv	a5,s11
  800438:	000dd363          	bgez	s11,80043e <vprintfmt+0x1b4>
  80043c:	4781                	li	a5,0
  80043e:	00078d9b          	sext.w	s11,a5
  800442:	8466                	mv	s0,s9
  800444:	b55d                	j	8002ea <vprintfmt+0x60>
  800446:	0008041b          	sext.w	s0,a6
  80044a:	fd340793          	addi	a5,s0,-45
  80044e:	01b02733          	sgtz	a4,s11
  800452:	00f037b3          	snez	a5,a5
  800456:	8ff9                	and	a5,a5,a4
  800458:	000ab703          	ld	a4,0(s5)
  80045c:	008a8693          	addi	a3,s5,8
  800460:	e436                	sd	a3,8(sp)
  800462:	12070563          	beqz	a4,80058c <vprintfmt+0x302>
  800466:	12079d63          	bnez	a5,8005a0 <vprintfmt+0x316>
  80046a:	00074783          	lbu	a5,0(a4)
  80046e:	0007851b          	sext.w	a0,a5
  800472:	c78d                	beqz	a5,80049c <vprintfmt+0x212>
  800474:	00170a93          	addi	s5,a4,1
  800478:	547d                	li	s0,-1
  80047a:	000d4563          	bltz	s10,800484 <vprintfmt+0x1fa>
  80047e:	3d7d                	addiw	s10,s10,-1
  800480:	008d0e63          	beq	s10,s0,80049c <vprintfmt+0x212>
  800484:	020c1863          	bnez	s8,8004b4 <vprintfmt+0x22a>
  800488:	864e                	mv	a2,s3
  80048a:	85ca                	mv	a1,s2
  80048c:	9482                	jalr	s1
  80048e:	000ac783          	lbu	a5,0(s5)
  800492:	0a85                	addi	s5,s5,1
  800494:	3dfd                	addiw	s11,s11,-1
  800496:	0007851b          	sext.w	a0,a5
  80049a:	f3e5                	bnez	a5,80047a <vprintfmt+0x1f0>
  80049c:	01b05a63          	blez	s11,8004b0 <vprintfmt+0x226>
  8004a0:	864e                	mv	a2,s3
  8004a2:	85ca                	mv	a1,s2
  8004a4:	02000513          	li	a0,32
  8004a8:	3dfd                	addiw	s11,s11,-1
  8004aa:	9482                	jalr	s1
  8004ac:	fe0d9ae3          	bnez	s11,8004a0 <vprintfmt+0x216>
  8004b0:	6aa2                	ld	s5,8(sp)
  8004b2:	b539                	j	8002c0 <vprintfmt+0x36>
  8004b4:	3781                	addiw	a5,a5,-32
  8004b6:	05e00713          	li	a4,94
  8004ba:	fcf777e3          	bgeu	a4,a5,800488 <vprintfmt+0x1fe>
  8004be:	03f00513          	li	a0,63
  8004c2:	864e                	mv	a2,s3
  8004c4:	85ca                	mv	a1,s2
  8004c6:	9482                	jalr	s1
  8004c8:	000ac783          	lbu	a5,0(s5)
  8004cc:	0a85                	addi	s5,s5,1
  8004ce:	3dfd                	addiw	s11,s11,-1
  8004d0:	0007851b          	sext.w	a0,a5
  8004d4:	d7e1                	beqz	a5,80049c <vprintfmt+0x212>
  8004d6:	fa0d54e3          	bgez	s10,80047e <vprintfmt+0x1f4>
  8004da:	bfe9                	j	8004b4 <vprintfmt+0x22a>
  8004dc:	000aa783          	lw	a5,0(s5)
  8004e0:	46e1                	li	a3,24
  8004e2:	0aa1                	addi	s5,s5,8
  8004e4:	41f7d71b          	sraiw	a4,a5,0x1f
  8004e8:	8fb9                	xor	a5,a5,a4
  8004ea:	40e7873b          	subw	a4,a5,a4
  8004ee:	02e6c663          	blt	a3,a4,80051a <vprintfmt+0x290>
  8004f2:	00000797          	auipc	a5,0x0
  8004f6:	58678793          	addi	a5,a5,1414 # 800a78 <error_string>
  8004fa:	00371693          	slli	a3,a4,0x3
  8004fe:	97b6                	add	a5,a5,a3
  800500:	639c                	ld	a5,0(a5)
  800502:	cf81                	beqz	a5,80051a <vprintfmt+0x290>
  800504:	873e                	mv	a4,a5
  800506:	00000697          	auipc	a3,0x0
  80050a:	23a68693          	addi	a3,a3,570 # 800740 <main+0x100>
  80050e:	864a                	mv	a2,s2
  800510:	85ce                	mv	a1,s3
  800512:	8526                	mv	a0,s1
  800514:	0f2000ef          	jal	800606 <printfmt>
  800518:	b365                	j	8002c0 <vprintfmt+0x36>
  80051a:	00000697          	auipc	a3,0x0
  80051e:	21668693          	addi	a3,a3,534 # 800730 <main+0xf0>
  800522:	864a                	mv	a2,s2
  800524:	85ce                	mv	a1,s3
  800526:	8526                	mv	a0,s1
  800528:	0de000ef          	jal	800606 <printfmt>
  80052c:	bb51                	j	8002c0 <vprintfmt+0x36>
  80052e:	4785                	li	a5,1
  800530:	008a8c13          	addi	s8,s5,8
  800534:	00b7c363          	blt	a5,a1,80053a <vprintfmt+0x2b0>
  800538:	cd81                	beqz	a1,800550 <vprintfmt+0x2c6>
  80053a:	000ab403          	ld	s0,0(s5)
  80053e:	02044b63          	bltz	s0,800574 <vprintfmt+0x2ea>
  800542:	86a2                	mv	a3,s0
  800544:	8ae2                	mv	s5,s8
  800546:	4729                	li	a4,10
  800548:	b5a5                	j	8003b0 <vprintfmt+0x126>
  80054a:	2585                	addiw	a1,a1,1
  80054c:	8466                	mv	s0,s9
  80054e:	bb71                	j	8002ea <vprintfmt+0x60>
  800550:	000aa403          	lw	s0,0(s5)
  800554:	b7ed                	j	80053e <vprintfmt+0x2b4>
  800556:	000ae683          	lwu	a3,0(s5)
  80055a:	4721                	li	a4,8
  80055c:	8ab2                	mv	s5,a2
  80055e:	bd89                	j	8003b0 <vprintfmt+0x126>
  800560:	000ae683          	lwu	a3,0(s5)
  800564:	4729                	li	a4,10
  800566:	8ab2                	mv	s5,a2
  800568:	b5a1                	j	8003b0 <vprintfmt+0x126>
  80056a:	000ae683          	lwu	a3,0(s5)
  80056e:	4741                	li	a4,16
  800570:	8ab2                	mv	s5,a2
  800572:	bd3d                	j	8003b0 <vprintfmt+0x126>
  800574:	864e                	mv	a2,s3
  800576:	85ca                	mv	a1,s2
  800578:	02d00513          	li	a0,45
  80057c:	e042                	sd	a6,0(sp)
  80057e:	9482                	jalr	s1
  800580:	6802                	ld	a6,0(sp)
  800582:	408006b3          	neg	a3,s0
  800586:	8ae2                	mv	s5,s8
  800588:	4729                	li	a4,10
  80058a:	b51d                	j	8003b0 <vprintfmt+0x126>
  80058c:	eba1                	bnez	a5,8005dc <vprintfmt+0x352>
  80058e:	02800793          	li	a5,40
  800592:	853e                	mv	a0,a5
  800594:	00000a97          	auipc	s5,0x0
  800598:	195a8a93          	addi	s5,s5,405 # 800729 <main+0xe9>
  80059c:	547d                	li	s0,-1
  80059e:	bdf1                	j	80047a <vprintfmt+0x1f0>
  8005a0:	853a                	mv	a0,a4
  8005a2:	85ea                	mv	a1,s10
  8005a4:	e03a                	sd	a4,0(sp)
  8005a6:	07e000ef          	jal	800624 <strnlen>
  8005aa:	40ad8dbb          	subw	s11,s11,a0
  8005ae:	6702                	ld	a4,0(sp)
  8005b0:	01b05b63          	blez	s11,8005c6 <vprintfmt+0x33c>
  8005b4:	864e                	mv	a2,s3
  8005b6:	85ca                	mv	a1,s2
  8005b8:	8522                	mv	a0,s0
  8005ba:	e03a                	sd	a4,0(sp)
  8005bc:	3dfd                	addiw	s11,s11,-1
  8005be:	9482                	jalr	s1
  8005c0:	6702                	ld	a4,0(sp)
  8005c2:	fe0d99e3          	bnez	s11,8005b4 <vprintfmt+0x32a>
  8005c6:	00074783          	lbu	a5,0(a4)
  8005ca:	0007851b          	sext.w	a0,a5
  8005ce:	ee0781e3          	beqz	a5,8004b0 <vprintfmt+0x226>
  8005d2:	00170a93          	addi	s5,a4,1
  8005d6:	b54d                	j	800478 <vprintfmt+0x1ee>
  8005d8:	8466                	mv	s0,s9
  8005da:	b36d                	j	800384 <vprintfmt+0xfa>
  8005dc:	85ea                	mv	a1,s10
  8005de:	00000517          	auipc	a0,0x0
  8005e2:	14a50513          	addi	a0,a0,330 # 800728 <main+0xe8>
  8005e6:	03e000ef          	jal	800624 <strnlen>
  8005ea:	40ad8dbb          	subw	s11,s11,a0
  8005ee:	02800793          	li	a5,40
  8005f2:	00000717          	auipc	a4,0x0
  8005f6:	13670713          	addi	a4,a4,310 # 800728 <main+0xe8>
  8005fa:	853e                	mv	a0,a5
  8005fc:	fbb04ce3          	bgtz	s11,8005b4 <vprintfmt+0x32a>
  800600:	00170a93          	addi	s5,a4,1
  800604:	bd95                	j	800478 <vprintfmt+0x1ee>

0000000000800606 <printfmt>:
  800606:	7139                	addi	sp,sp,-64
  800608:	02010313          	addi	t1,sp,32
  80060c:	f03a                	sd	a4,32(sp)
  80060e:	871a                	mv	a4,t1
  800610:	ec06                	sd	ra,24(sp)
  800612:	f43e                	sd	a5,40(sp)
  800614:	f842                	sd	a6,48(sp)
  800616:	fc46                	sd	a7,56(sp)
  800618:	e41a                	sd	t1,8(sp)
  80061a:	c71ff0ef          	jal	80028a <vprintfmt>
  80061e:	60e2                	ld	ra,24(sp)
  800620:	6121                	addi	sp,sp,64
  800622:	8082                	ret

0000000000800624 <strnlen>:
  800624:	4781                	li	a5,0
  800626:	e589                	bnez	a1,800630 <strnlen+0xc>
  800628:	a811                	j	80063c <strnlen+0x18>
  80062a:	0785                	addi	a5,a5,1
  80062c:	00f58863          	beq	a1,a5,80063c <strnlen+0x18>
  800630:	00f50733          	add	a4,a0,a5
  800634:	00074703          	lbu	a4,0(a4)
  800638:	fb6d                	bnez	a4,80062a <strnlen+0x6>
  80063a:	85be                	mv	a1,a5
  80063c:	852e                	mv	a0,a1
  80063e:	8082                	ret

0000000000800640 <main>:
  800640:	4781                	li	a5,0
  800642:	439c                	lw	a5,0(a5)
  800644:	9002                	ebreak
