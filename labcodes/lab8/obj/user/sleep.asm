
obj/__user_sleep.out:     file format elf64-littleriscv


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
  80002a:	1e0000ef          	jal	80020a <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	70a50513          	addi	a0,a0,1802 # 800748 <main+0x72>
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
  800064:	70850513          	addi	a0,a0,1800 # 800768 <main+0x92>
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
  800084:	6f050513          	addi	a0,a0,1776 # 800770 <main+0x9a>
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
  8000a6:	6c650513          	addi	a0,a0,1734 # 800768 <main+0x92>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ec1>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	206000ef          	jal	8002ee <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ec1>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1cc000ef          	jal	8002ee <vprintfmt>
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

0000000000800180 <sys_sleep>:
  800180:	85aa                	mv	a1,a0
  800182:	452d                	li	a0,11
  800184:	b76d                	j	80012e <syscall>

0000000000800186 <sys_gettime>:
  800186:	4545                	li	a0,17
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
  8001b2:	5e250513          	addi	a0,a0,1506 # 800790 <main+0xba>
  8001b6:	f3fff0ef          	jal	8000f4 <cprintf>
  8001ba:	a001                	j	8001ba <exit+0x14>

00000000008001bc <fork>:
  8001bc:	bf4d                	j	80016e <sys_fork>

00000000008001be <waitpid>:
  8001be:	bf55                	j	800172 <sys_wait>

00000000008001c0 <gettime_msec>:
  8001c0:	b7d9                	j	800186 <sys_gettime>

00000000008001c2 <sleep>:
  8001c2:	1502                	slli	a0,a0,0x20
  8001c4:	9101                	srli	a0,a0,0x20
  8001c6:	bf6d                	j	800180 <sys_sleep>

00000000008001c8 <initfd>:
  8001c8:	87ae                	mv	a5,a1
  8001ca:	1101                	addi	sp,sp,-32
  8001cc:	e822                	sd	s0,16(sp)
  8001ce:	85b2                	mv	a1,a2
  8001d0:	842a                	mv	s0,a0
  8001d2:	853e                	mv	a0,a5
  8001d4:	ec06                	sd	ra,24(sp)
  8001d6:	e4bff0ef          	jal	800020 <open>
  8001da:	87aa                	mv	a5,a0
  8001dc:	00054463          	bltz	a0,8001e4 <initfd+0x1c>
  8001e0:	00851763          	bne	a0,s0,8001ee <initfd+0x26>
  8001e4:	60e2                	ld	ra,24(sp)
  8001e6:	6442                	ld	s0,16(sp)
  8001e8:	853e                	mv	a0,a5
  8001ea:	6105                	addi	sp,sp,32
  8001ec:	8082                	ret
  8001ee:	e42a                	sd	a0,8(sp)
  8001f0:	8522                	mv	a0,s0
  8001f2:	e35ff0ef          	jal	800026 <close>
  8001f6:	6522                	ld	a0,8(sp)
  8001f8:	85a2                	mv	a1,s0
  8001fa:	e2fff0ef          	jal	800028 <dup2>
  8001fe:	842a                	mv	s0,a0
  800200:	6522                	ld	a0,8(sp)
  800202:	e25ff0ef          	jal	800026 <close>
  800206:	87a2                	mv	a5,s0
  800208:	bff1                	j	8001e4 <initfd+0x1c>

000000000080020a <umain>:
  80020a:	1101                	addi	sp,sp,-32
  80020c:	e822                	sd	s0,16(sp)
  80020e:	e426                	sd	s1,8(sp)
  800210:	842a                	mv	s0,a0
  800212:	84ae                	mv	s1,a1
  800214:	4601                	li	a2,0
  800216:	00000597          	auipc	a1,0x0
  80021a:	59258593          	addi	a1,a1,1426 # 8007a8 <main+0xd2>
  80021e:	4501                	li	a0,0
  800220:	ec06                	sd	ra,24(sp)
  800222:	fa7ff0ef          	jal	8001c8 <initfd>
  800226:	02054263          	bltz	a0,80024a <umain+0x40>
  80022a:	4605                	li	a2,1
  80022c:	8532                	mv	a0,a2
  80022e:	00000597          	auipc	a1,0x0
  800232:	5ba58593          	addi	a1,a1,1466 # 8007e8 <main+0x112>
  800236:	f93ff0ef          	jal	8001c8 <initfd>
  80023a:	02054563          	bltz	a0,800264 <umain+0x5a>
  80023e:	85a6                	mv	a1,s1
  800240:	8522                	mv	a0,s0
  800242:	494000ef          	jal	8006d6 <main>
  800246:	f61ff0ef          	jal	8001a6 <exit>
  80024a:	86aa                	mv	a3,a0
  80024c:	00000617          	auipc	a2,0x0
  800250:	56460613          	addi	a2,a2,1380 # 8007b0 <main+0xda>
  800254:	45e9                	li	a1,26
  800256:	00000517          	auipc	a0,0x0
  80025a:	57a50513          	addi	a0,a0,1402 # 8007d0 <main+0xfa>
  80025e:	e15ff0ef          	jal	800072 <__warn>
  800262:	b7e1                	j	80022a <umain+0x20>
  800264:	86aa                	mv	a3,a0
  800266:	00000617          	auipc	a2,0x0
  80026a:	58a60613          	addi	a2,a2,1418 # 8007f0 <main+0x11a>
  80026e:	45f5                	li	a1,29
  800270:	00000517          	auipc	a0,0x0
  800274:	56050513          	addi	a0,a0,1376 # 8007d0 <main+0xfa>
  800278:	dfbff0ef          	jal	800072 <__warn>
  80027c:	b7c9                	j	80023e <umain+0x34>

000000000080027e <printnum>:
  80027e:	7139                	addi	sp,sp,-64
  800280:	02071893          	slli	a7,a4,0x20
  800284:	f822                	sd	s0,48(sp)
  800286:	f426                	sd	s1,40(sp)
  800288:	f04a                	sd	s2,32(sp)
  80028a:	ec4e                	sd	s3,24(sp)
  80028c:	e456                	sd	s5,8(sp)
  80028e:	0208d893          	srli	a7,a7,0x20
  800292:	fc06                	sd	ra,56(sp)
  800294:	0316fab3          	remu	s5,a3,a7
  800298:	fff7841b          	addiw	s0,a5,-1
  80029c:	84aa                	mv	s1,a0
  80029e:	89ae                	mv	s3,a1
  8002a0:	8932                	mv	s2,a2
  8002a2:	0516f063          	bgeu	a3,a7,8002e2 <printnum+0x64>
  8002a6:	e852                	sd	s4,16(sp)
  8002a8:	4705                	li	a4,1
  8002aa:	8a42                	mv	s4,a6
  8002ac:	00f75863          	bge	a4,a5,8002bc <printnum+0x3e>
  8002b0:	864e                	mv	a2,s3
  8002b2:	85ca                	mv	a1,s2
  8002b4:	8552                	mv	a0,s4
  8002b6:	347d                	addiw	s0,s0,-1
  8002b8:	9482                	jalr	s1
  8002ba:	f87d                	bnez	s0,8002b0 <printnum+0x32>
  8002bc:	6a42                	ld	s4,16(sp)
  8002be:	00000797          	auipc	a5,0x0
  8002c2:	55278793          	addi	a5,a5,1362 # 800810 <main+0x13a>
  8002c6:	97d6                	add	a5,a5,s5
  8002c8:	7442                	ld	s0,48(sp)
  8002ca:	0007c503          	lbu	a0,0(a5)
  8002ce:	70e2                	ld	ra,56(sp)
  8002d0:	6aa2                	ld	s5,8(sp)
  8002d2:	864e                	mv	a2,s3
  8002d4:	85ca                	mv	a1,s2
  8002d6:	69e2                	ld	s3,24(sp)
  8002d8:	7902                	ld	s2,32(sp)
  8002da:	87a6                	mv	a5,s1
  8002dc:	74a2                	ld	s1,40(sp)
  8002de:	6121                	addi	sp,sp,64
  8002e0:	8782                	jr	a5
  8002e2:	0316d6b3          	divu	a3,a3,a7
  8002e6:	87a2                	mv	a5,s0
  8002e8:	f97ff0ef          	jal	80027e <printnum>
  8002ec:	bfc9                	j	8002be <printnum+0x40>

00000000008002ee <vprintfmt>:
  8002ee:	7119                	addi	sp,sp,-128
  8002f0:	f4a6                	sd	s1,104(sp)
  8002f2:	f0ca                	sd	s2,96(sp)
  8002f4:	ecce                	sd	s3,88(sp)
  8002f6:	e8d2                	sd	s4,80(sp)
  8002f8:	e4d6                	sd	s5,72(sp)
  8002fa:	e0da                	sd	s6,64(sp)
  8002fc:	fc5e                	sd	s7,56(sp)
  8002fe:	f466                	sd	s9,40(sp)
  800300:	fc86                	sd	ra,120(sp)
  800302:	f8a2                	sd	s0,112(sp)
  800304:	f862                	sd	s8,48(sp)
  800306:	f06a                	sd	s10,32(sp)
  800308:	ec6e                	sd	s11,24(sp)
  80030a:	84aa                	mv	s1,a0
  80030c:	8cb6                	mv	s9,a3
  80030e:	8aba                	mv	s5,a4
  800310:	89ae                	mv	s3,a1
  800312:	8932                	mv	s2,a2
  800314:	02500a13          	li	s4,37
  800318:	05500b93          	li	s7,85
  80031c:	00000b17          	auipc	s6,0x0
  800320:	7a4b0b13          	addi	s6,s6,1956 # 800ac0 <main+0x3ea>
  800324:	000cc503          	lbu	a0,0(s9)
  800328:	001c8413          	addi	s0,s9,1
  80032c:	01450b63          	beq	a0,s4,800342 <vprintfmt+0x54>
  800330:	cd15                	beqz	a0,80036c <vprintfmt+0x7e>
  800332:	864e                	mv	a2,s3
  800334:	85ca                	mv	a1,s2
  800336:	9482                	jalr	s1
  800338:	00044503          	lbu	a0,0(s0)
  80033c:	0405                	addi	s0,s0,1
  80033e:	ff4519e3          	bne	a0,s4,800330 <vprintfmt+0x42>
  800342:	5d7d                	li	s10,-1
  800344:	8dea                	mv	s11,s10
  800346:	02000813          	li	a6,32
  80034a:	4c01                	li	s8,0
  80034c:	4581                	li	a1,0
  80034e:	00044703          	lbu	a4,0(s0)
  800352:	00140c93          	addi	s9,s0,1
  800356:	fdd7061b          	addiw	a2,a4,-35
  80035a:	0ff67613          	zext.b	a2,a2
  80035e:	02cbe663          	bltu	s7,a2,80038a <vprintfmt+0x9c>
  800362:	060a                	slli	a2,a2,0x2
  800364:	965a                	add	a2,a2,s6
  800366:	421c                	lw	a5,0(a2)
  800368:	97da                	add	a5,a5,s6
  80036a:	8782                	jr	a5
  80036c:	70e6                	ld	ra,120(sp)
  80036e:	7446                	ld	s0,112(sp)
  800370:	74a6                	ld	s1,104(sp)
  800372:	7906                	ld	s2,96(sp)
  800374:	69e6                	ld	s3,88(sp)
  800376:	6a46                	ld	s4,80(sp)
  800378:	6aa6                	ld	s5,72(sp)
  80037a:	6b06                	ld	s6,64(sp)
  80037c:	7be2                	ld	s7,56(sp)
  80037e:	7c42                	ld	s8,48(sp)
  800380:	7ca2                	ld	s9,40(sp)
  800382:	7d02                	ld	s10,32(sp)
  800384:	6de2                	ld	s11,24(sp)
  800386:	6109                	addi	sp,sp,128
  800388:	8082                	ret
  80038a:	864e                	mv	a2,s3
  80038c:	85ca                	mv	a1,s2
  80038e:	02500513          	li	a0,37
  800392:	9482                	jalr	s1
  800394:	fff44783          	lbu	a5,-1(s0)
  800398:	02500713          	li	a4,37
  80039c:	8ca2                	mv	s9,s0
  80039e:	f8e783e3          	beq	a5,a4,800324 <vprintfmt+0x36>
  8003a2:	ffecc783          	lbu	a5,-2(s9)
  8003a6:	1cfd                	addi	s9,s9,-1
  8003a8:	fee79de3          	bne	a5,a4,8003a2 <vprintfmt+0xb4>
  8003ac:	bfa5                	j	800324 <vprintfmt+0x36>
  8003ae:	00144683          	lbu	a3,1(s0)
  8003b2:	4525                	li	a0,9
  8003b4:	fd070d1b          	addiw	s10,a4,-48
  8003b8:	fd06879b          	addiw	a5,a3,-48
  8003bc:	28f56063          	bltu	a0,a5,80063c <vprintfmt+0x34e>
  8003c0:	2681                	sext.w	a3,a3
  8003c2:	8466                	mv	s0,s9
  8003c4:	002d179b          	slliw	a5,s10,0x2
  8003c8:	00144703          	lbu	a4,1(s0)
  8003cc:	01a787bb          	addw	a5,a5,s10
  8003d0:	0017979b          	slliw	a5,a5,0x1
  8003d4:	9fb5                	addw	a5,a5,a3
  8003d6:	fd07061b          	addiw	a2,a4,-48
  8003da:	0405                	addi	s0,s0,1
  8003dc:	fd078d1b          	addiw	s10,a5,-48
  8003e0:	0007069b          	sext.w	a3,a4
  8003e4:	fec570e3          	bgeu	a0,a2,8003c4 <vprintfmt+0xd6>
  8003e8:	f60dd3e3          	bgez	s11,80034e <vprintfmt+0x60>
  8003ec:	8dea                	mv	s11,s10
  8003ee:	5d7d                	li	s10,-1
  8003f0:	bfb9                	j	80034e <vprintfmt+0x60>
  8003f2:	883a                	mv	a6,a4
  8003f4:	8466                	mv	s0,s9
  8003f6:	bfa1                	j	80034e <vprintfmt+0x60>
  8003f8:	8466                	mv	s0,s9
  8003fa:	4c05                	li	s8,1
  8003fc:	bf89                	j	80034e <vprintfmt+0x60>
  8003fe:	4785                	li	a5,1
  800400:	008a8613          	addi	a2,s5,8
  800404:	00b7c463          	blt	a5,a1,80040c <vprintfmt+0x11e>
  800408:	1c058363          	beqz	a1,8005ce <vprintfmt+0x2e0>
  80040c:	000ab683          	ld	a3,0(s5)
  800410:	4741                	li	a4,16
  800412:	8ab2                	mv	s5,a2
  800414:	2801                	sext.w	a6,a6
  800416:	87ee                	mv	a5,s11
  800418:	864a                	mv	a2,s2
  80041a:	85ce                	mv	a1,s3
  80041c:	8526                	mv	a0,s1
  80041e:	e61ff0ef          	jal	80027e <printnum>
  800422:	b709                	j	800324 <vprintfmt+0x36>
  800424:	000aa503          	lw	a0,0(s5)
  800428:	864e                	mv	a2,s3
  80042a:	85ca                	mv	a1,s2
  80042c:	9482                	jalr	s1
  80042e:	0aa1                	addi	s5,s5,8
  800430:	bdd5                	j	800324 <vprintfmt+0x36>
  800432:	4785                	li	a5,1
  800434:	008a8613          	addi	a2,s5,8
  800438:	00b7c463          	blt	a5,a1,800440 <vprintfmt+0x152>
  80043c:	18058463          	beqz	a1,8005c4 <vprintfmt+0x2d6>
  800440:	000ab683          	ld	a3,0(s5)
  800444:	4729                	li	a4,10
  800446:	8ab2                	mv	s5,a2
  800448:	b7f1                	j	800414 <vprintfmt+0x126>
  80044a:	864e                	mv	a2,s3
  80044c:	85ca                	mv	a1,s2
  80044e:	03000513          	li	a0,48
  800452:	e042                	sd	a6,0(sp)
  800454:	9482                	jalr	s1
  800456:	864e                	mv	a2,s3
  800458:	85ca                	mv	a1,s2
  80045a:	07800513          	li	a0,120
  80045e:	9482                	jalr	s1
  800460:	000ab683          	ld	a3,0(s5)
  800464:	6802                	ld	a6,0(sp)
  800466:	4741                	li	a4,16
  800468:	0aa1                	addi	s5,s5,8
  80046a:	b76d                	j	800414 <vprintfmt+0x126>
  80046c:	864e                	mv	a2,s3
  80046e:	85ca                	mv	a1,s2
  800470:	02500513          	li	a0,37
  800474:	9482                	jalr	s1
  800476:	b57d                	j	800324 <vprintfmt+0x36>
  800478:	000aad03          	lw	s10,0(s5)
  80047c:	8466                	mv	s0,s9
  80047e:	0aa1                	addi	s5,s5,8
  800480:	b7a5                	j	8003e8 <vprintfmt+0xfa>
  800482:	4785                	li	a5,1
  800484:	008a8613          	addi	a2,s5,8
  800488:	00b7c463          	blt	a5,a1,800490 <vprintfmt+0x1a2>
  80048c:	12058763          	beqz	a1,8005ba <vprintfmt+0x2cc>
  800490:	000ab683          	ld	a3,0(s5)
  800494:	4721                	li	a4,8
  800496:	8ab2                	mv	s5,a2
  800498:	bfb5                	j	800414 <vprintfmt+0x126>
  80049a:	87ee                	mv	a5,s11
  80049c:	000dd363          	bgez	s11,8004a2 <vprintfmt+0x1b4>
  8004a0:	4781                	li	a5,0
  8004a2:	00078d9b          	sext.w	s11,a5
  8004a6:	8466                	mv	s0,s9
  8004a8:	b55d                	j	80034e <vprintfmt+0x60>
  8004aa:	0008041b          	sext.w	s0,a6
  8004ae:	fd340793          	addi	a5,s0,-45
  8004b2:	01b02733          	sgtz	a4,s11
  8004b6:	00f037b3          	snez	a5,a5
  8004ba:	8ff9                	and	a5,a5,a4
  8004bc:	000ab703          	ld	a4,0(s5)
  8004c0:	008a8693          	addi	a3,s5,8
  8004c4:	e436                	sd	a3,8(sp)
  8004c6:	12070563          	beqz	a4,8005f0 <vprintfmt+0x302>
  8004ca:	12079d63          	bnez	a5,800604 <vprintfmt+0x316>
  8004ce:	00074783          	lbu	a5,0(a4)
  8004d2:	0007851b          	sext.w	a0,a5
  8004d6:	c78d                	beqz	a5,800500 <vprintfmt+0x212>
  8004d8:	00170a93          	addi	s5,a4,1
  8004dc:	547d                	li	s0,-1
  8004de:	000d4563          	bltz	s10,8004e8 <vprintfmt+0x1fa>
  8004e2:	3d7d                	addiw	s10,s10,-1
  8004e4:	008d0e63          	beq	s10,s0,800500 <vprintfmt+0x212>
  8004e8:	020c1863          	bnez	s8,800518 <vprintfmt+0x22a>
  8004ec:	864e                	mv	a2,s3
  8004ee:	85ca                	mv	a1,s2
  8004f0:	9482                	jalr	s1
  8004f2:	000ac783          	lbu	a5,0(s5)
  8004f6:	0a85                	addi	s5,s5,1
  8004f8:	3dfd                	addiw	s11,s11,-1
  8004fa:	0007851b          	sext.w	a0,a5
  8004fe:	f3e5                	bnez	a5,8004de <vprintfmt+0x1f0>
  800500:	01b05a63          	blez	s11,800514 <vprintfmt+0x226>
  800504:	864e                	mv	a2,s3
  800506:	85ca                	mv	a1,s2
  800508:	02000513          	li	a0,32
  80050c:	3dfd                	addiw	s11,s11,-1
  80050e:	9482                	jalr	s1
  800510:	fe0d9ae3          	bnez	s11,800504 <vprintfmt+0x216>
  800514:	6aa2                	ld	s5,8(sp)
  800516:	b539                	j	800324 <vprintfmt+0x36>
  800518:	3781                	addiw	a5,a5,-32
  80051a:	05e00713          	li	a4,94
  80051e:	fcf777e3          	bgeu	a4,a5,8004ec <vprintfmt+0x1fe>
  800522:	03f00513          	li	a0,63
  800526:	864e                	mv	a2,s3
  800528:	85ca                	mv	a1,s2
  80052a:	9482                	jalr	s1
  80052c:	000ac783          	lbu	a5,0(s5)
  800530:	0a85                	addi	s5,s5,1
  800532:	3dfd                	addiw	s11,s11,-1
  800534:	0007851b          	sext.w	a0,a5
  800538:	d7e1                	beqz	a5,800500 <vprintfmt+0x212>
  80053a:	fa0d54e3          	bgez	s10,8004e2 <vprintfmt+0x1f4>
  80053e:	bfe9                	j	800518 <vprintfmt+0x22a>
  800540:	000aa783          	lw	a5,0(s5)
  800544:	46e1                	li	a3,24
  800546:	0aa1                	addi	s5,s5,8
  800548:	41f7d71b          	sraiw	a4,a5,0x1f
  80054c:	8fb9                	xor	a5,a5,a4
  80054e:	40e7873b          	subw	a4,a5,a4
  800552:	02e6c663          	blt	a3,a4,80057e <vprintfmt+0x290>
  800556:	00000797          	auipc	a5,0x0
  80055a:	6c278793          	addi	a5,a5,1730 # 800c18 <error_string>
  80055e:	00371693          	slli	a3,a4,0x3
  800562:	97b6                	add	a5,a5,a3
  800564:	639c                	ld	a5,0(a5)
  800566:	cf81                	beqz	a5,80057e <vprintfmt+0x290>
  800568:	873e                	mv	a4,a5
  80056a:	00000697          	auipc	a3,0x0
  80056e:	2d668693          	addi	a3,a3,726 # 800840 <main+0x16a>
  800572:	864a                	mv	a2,s2
  800574:	85ce                	mv	a1,s3
  800576:	8526                	mv	a0,s1
  800578:	0f2000ef          	jal	80066a <printfmt>
  80057c:	b365                	j	800324 <vprintfmt+0x36>
  80057e:	00000697          	auipc	a3,0x0
  800582:	2b268693          	addi	a3,a3,690 # 800830 <main+0x15a>
  800586:	864a                	mv	a2,s2
  800588:	85ce                	mv	a1,s3
  80058a:	8526                	mv	a0,s1
  80058c:	0de000ef          	jal	80066a <printfmt>
  800590:	bb51                	j	800324 <vprintfmt+0x36>
  800592:	4785                	li	a5,1
  800594:	008a8c13          	addi	s8,s5,8
  800598:	00b7c363          	blt	a5,a1,80059e <vprintfmt+0x2b0>
  80059c:	cd81                	beqz	a1,8005b4 <vprintfmt+0x2c6>
  80059e:	000ab403          	ld	s0,0(s5)
  8005a2:	02044b63          	bltz	s0,8005d8 <vprintfmt+0x2ea>
  8005a6:	86a2                	mv	a3,s0
  8005a8:	8ae2                	mv	s5,s8
  8005aa:	4729                	li	a4,10
  8005ac:	b5a5                	j	800414 <vprintfmt+0x126>
  8005ae:	2585                	addiw	a1,a1,1
  8005b0:	8466                	mv	s0,s9
  8005b2:	bb71                	j	80034e <vprintfmt+0x60>
  8005b4:	000aa403          	lw	s0,0(s5)
  8005b8:	b7ed                	j	8005a2 <vprintfmt+0x2b4>
  8005ba:	000ae683          	lwu	a3,0(s5)
  8005be:	4721                	li	a4,8
  8005c0:	8ab2                	mv	s5,a2
  8005c2:	bd89                	j	800414 <vprintfmt+0x126>
  8005c4:	000ae683          	lwu	a3,0(s5)
  8005c8:	4729                	li	a4,10
  8005ca:	8ab2                	mv	s5,a2
  8005cc:	b5a1                	j	800414 <vprintfmt+0x126>
  8005ce:	000ae683          	lwu	a3,0(s5)
  8005d2:	4741                	li	a4,16
  8005d4:	8ab2                	mv	s5,a2
  8005d6:	bd3d                	j	800414 <vprintfmt+0x126>
  8005d8:	864e                	mv	a2,s3
  8005da:	85ca                	mv	a1,s2
  8005dc:	02d00513          	li	a0,45
  8005e0:	e042                	sd	a6,0(sp)
  8005e2:	9482                	jalr	s1
  8005e4:	6802                	ld	a6,0(sp)
  8005e6:	408006b3          	neg	a3,s0
  8005ea:	8ae2                	mv	s5,s8
  8005ec:	4729                	li	a4,10
  8005ee:	b51d                	j	800414 <vprintfmt+0x126>
  8005f0:	eba1                	bnez	a5,800640 <vprintfmt+0x352>
  8005f2:	02800793          	li	a5,40
  8005f6:	853e                	mv	a0,a5
  8005f8:	00000a97          	auipc	s5,0x0
  8005fc:	231a8a93          	addi	s5,s5,561 # 800829 <main+0x153>
  800600:	547d                	li	s0,-1
  800602:	bdf1                	j	8004de <vprintfmt+0x1f0>
  800604:	853a                	mv	a0,a4
  800606:	85ea                	mv	a1,s10
  800608:	e03a                	sd	a4,0(sp)
  80060a:	07e000ef          	jal	800688 <strnlen>
  80060e:	40ad8dbb          	subw	s11,s11,a0
  800612:	6702                	ld	a4,0(sp)
  800614:	01b05b63          	blez	s11,80062a <vprintfmt+0x33c>
  800618:	864e                	mv	a2,s3
  80061a:	85ca                	mv	a1,s2
  80061c:	8522                	mv	a0,s0
  80061e:	e03a                	sd	a4,0(sp)
  800620:	3dfd                	addiw	s11,s11,-1
  800622:	9482                	jalr	s1
  800624:	6702                	ld	a4,0(sp)
  800626:	fe0d99e3          	bnez	s11,800618 <vprintfmt+0x32a>
  80062a:	00074783          	lbu	a5,0(a4)
  80062e:	0007851b          	sext.w	a0,a5
  800632:	ee0781e3          	beqz	a5,800514 <vprintfmt+0x226>
  800636:	00170a93          	addi	s5,a4,1
  80063a:	b54d                	j	8004dc <vprintfmt+0x1ee>
  80063c:	8466                	mv	s0,s9
  80063e:	b36d                	j	8003e8 <vprintfmt+0xfa>
  800640:	85ea                	mv	a1,s10
  800642:	00000517          	auipc	a0,0x0
  800646:	1e650513          	addi	a0,a0,486 # 800828 <main+0x152>
  80064a:	03e000ef          	jal	800688 <strnlen>
  80064e:	40ad8dbb          	subw	s11,s11,a0
  800652:	02800793          	li	a5,40
  800656:	00000717          	auipc	a4,0x0
  80065a:	1d270713          	addi	a4,a4,466 # 800828 <main+0x152>
  80065e:	853e                	mv	a0,a5
  800660:	fbb04ce3          	bgtz	s11,800618 <vprintfmt+0x32a>
  800664:	00170a93          	addi	s5,a4,1
  800668:	bd95                	j	8004dc <vprintfmt+0x1ee>

000000000080066a <printfmt>:
  80066a:	7139                	addi	sp,sp,-64
  80066c:	02010313          	addi	t1,sp,32
  800670:	f03a                	sd	a4,32(sp)
  800672:	871a                	mv	a4,t1
  800674:	ec06                	sd	ra,24(sp)
  800676:	f43e                	sd	a5,40(sp)
  800678:	f842                	sd	a6,48(sp)
  80067a:	fc46                	sd	a7,56(sp)
  80067c:	e41a                	sd	t1,8(sp)
  80067e:	c71ff0ef          	jal	8002ee <vprintfmt>
  800682:	60e2                	ld	ra,24(sp)
  800684:	6121                	addi	sp,sp,64
  800686:	8082                	ret

0000000000800688 <strnlen>:
  800688:	4781                	li	a5,0
  80068a:	e589                	bnez	a1,800694 <strnlen+0xc>
  80068c:	a811                	j	8006a0 <strnlen+0x18>
  80068e:	0785                	addi	a5,a5,1
  800690:	00f58863          	beq	a1,a5,8006a0 <strnlen+0x18>
  800694:	00f50733          	add	a4,a0,a5
  800698:	00074703          	lbu	a4,0(a4)
  80069c:	fb6d                	bnez	a4,80068e <strnlen+0x6>
  80069e:	85be                	mv	a1,a5
  8006a0:	852e                	mv	a0,a1
  8006a2:	8082                	ret

00000000008006a4 <sleepy>:
  8006a4:	1101                	addi	sp,sp,-32
  8006a6:	e822                	sd	s0,16(sp)
  8006a8:	e426                	sd	s1,8(sp)
  8006aa:	ec06                	sd	ra,24(sp)
  8006ac:	4401                	li	s0,0
  8006ae:	44a9                	li	s1,10
  8006b0:	06400513          	li	a0,100
  8006b4:	b0fff0ef          	jal	8001c2 <sleep>
  8006b8:	2405                	addiw	s0,s0,1
  8006ba:	85a2                	mv	a1,s0
  8006bc:	06400613          	li	a2,100
  8006c0:	00000517          	auipc	a0,0x0
  8006c4:	36050513          	addi	a0,a0,864 # 800a20 <main+0x34a>
  8006c8:	a2dff0ef          	jal	8000f4 <cprintf>
  8006cc:	fe9412e3          	bne	s0,s1,8006b0 <sleepy+0xc>
  8006d0:	4501                	li	a0,0
  8006d2:	ad5ff0ef          	jal	8001a6 <exit>

00000000008006d6 <main>:
  8006d6:	1101                	addi	sp,sp,-32
  8006d8:	e822                	sd	s0,16(sp)
  8006da:	ec06                	sd	ra,24(sp)
  8006dc:	ae5ff0ef          	jal	8001c0 <gettime_msec>
  8006e0:	842a                	mv	s0,a0
  8006e2:	adbff0ef          	jal	8001bc <fork>
  8006e6:	cd21                	beqz	a0,80073e <main+0x68>
  8006e8:	006c                	addi	a1,sp,12
  8006ea:	ad5ff0ef          	jal	8001be <waitpid>
  8006ee:	47b2                	lw	a5,12(sp)
  8006f0:	8d5d                	or	a0,a0,a5
  8006f2:	2501                	sext.w	a0,a0
  8006f4:	e515                	bnez	a0,800720 <main+0x4a>
  8006f6:	acbff0ef          	jal	8001c0 <gettime_msec>
  8006fa:	408505bb          	subw	a1,a0,s0
  8006fe:	00000517          	auipc	a0,0x0
  800702:	39a50513          	addi	a0,a0,922 # 800a98 <main+0x3c2>
  800706:	9efff0ef          	jal	8000f4 <cprintf>
  80070a:	00000517          	auipc	a0,0x0
  80070e:	3a650513          	addi	a0,a0,934 # 800ab0 <main+0x3da>
  800712:	9e3ff0ef          	jal	8000f4 <cprintf>
  800716:	60e2                	ld	ra,24(sp)
  800718:	6442                	ld	s0,16(sp)
  80071a:	4501                	li	a0,0
  80071c:	6105                	addi	sp,sp,32
  80071e:	8082                	ret
  800720:	00000697          	auipc	a3,0x0
  800724:	31868693          	addi	a3,a3,792 # 800a38 <main+0x362>
  800728:	00000617          	auipc	a2,0x0
  80072c:	34860613          	addi	a2,a2,840 # 800a70 <main+0x39a>
  800730:	45dd                	li	a1,23
  800732:	00000517          	auipc	a0,0x0
  800736:	35650513          	addi	a0,a0,854 # 800a88 <main+0x3b2>
  80073a:	8f7ff0ef          	jal	800030 <__panic>
  80073e:	f67ff0ef          	jal	8006a4 <sleepy>
