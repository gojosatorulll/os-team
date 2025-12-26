
obj/__user_pgdir.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa19                	j	80013a <sys_open>

0000000000800026 <close>:
  800026:	aa39                	j	800144 <sys_close>

0000000000800028 <dup2>:
  800028:	a215                	j	80014c <sys_dup>

000000000080002a <_start>:
  80002a:	188000ef          	jal	8001b2 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__warn>:
  800030:	715d                	addi	sp,sp,-80
  800032:	e822                	sd	s0,16(sp)
  800034:	02810313          	addi	t1,sp,40
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	66a50513          	addi	a0,a0,1642 # 8006a8 <main+0x5c>
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
  800064:	64050513          	addi	a0,a0,1600 # 8006a0 <main+0x54>
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
  80009e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6001>
  8000a2:	ec06                	sd	ra,24(sp)
  8000a4:	c602                	sw	zero,12(sp)
  8000a6:	1f0000ef          	jal	800296 <vprintfmt>
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
  8000d0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6001>
  8000d4:	ec06                	sd	ra,24(sp)
  8000d6:	e4be                	sd	a5,72(sp)
  8000d8:	e8c2                	sd	a6,80(sp)
  8000da:	ecc6                	sd	a7,88(sp)
  8000dc:	c202                	sw	zero,4(sp)
  8000de:	e41a                	sd	t1,8(sp)
  8000e0:	1b6000ef          	jal	800296 <vprintfmt>
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

0000000000800136 <sys_pgdir>:
  800136:	457d                	li	a0,31
  800138:	bf55                	j	8000ec <syscall>

000000000080013a <sys_open>:
  80013a:	862e                	mv	a2,a1
  80013c:	85aa                	mv	a1,a0
  80013e:	06400513          	li	a0,100
  800142:	b76d                	j	8000ec <syscall>

0000000000800144 <sys_close>:
  800144:	85aa                	mv	a1,a0
  800146:	06500513          	li	a0,101
  80014a:	b74d                	j	8000ec <syscall>

000000000080014c <sys_dup>:
  80014c:	862e                	mv	a2,a1
  80014e:	85aa                	mv	a1,a0
  800150:	08200513          	li	a0,130
  800154:	bf61                	j	8000ec <syscall>

0000000000800156 <exit>:
  800156:	1141                	addi	sp,sp,-16
  800158:	e406                	sd	ra,8(sp)
  80015a:	fcdff0ef          	jal	800126 <sys_exit>
  80015e:	00000517          	auipc	a0,0x0
  800162:	56a50513          	addi	a0,a0,1386 # 8006c8 <main+0x7c>
  800166:	f4dff0ef          	jal	8000b2 <cprintf>
  80016a:	a001                	j	80016a <exit+0x14>

000000000080016c <getpid>:
  80016c:	b7c1                	j	80012c <sys_getpid>

000000000080016e <print_pgdir>:
  80016e:	b7e1                	j	800136 <sys_pgdir>

0000000000800170 <initfd>:
  800170:	87ae                	mv	a5,a1
  800172:	1101                	addi	sp,sp,-32
  800174:	e822                	sd	s0,16(sp)
  800176:	85b2                	mv	a1,a2
  800178:	842a                	mv	s0,a0
  80017a:	853e                	mv	a0,a5
  80017c:	ec06                	sd	ra,24(sp)
  80017e:	ea3ff0ef          	jal	800020 <open>
  800182:	87aa                	mv	a5,a0
  800184:	00054463          	bltz	a0,80018c <initfd+0x1c>
  800188:	00851763          	bne	a0,s0,800196 <initfd+0x26>
  80018c:	60e2                	ld	ra,24(sp)
  80018e:	6442                	ld	s0,16(sp)
  800190:	853e                	mv	a0,a5
  800192:	6105                	addi	sp,sp,32
  800194:	8082                	ret
  800196:	e42a                	sd	a0,8(sp)
  800198:	8522                	mv	a0,s0
  80019a:	e8dff0ef          	jal	800026 <close>
  80019e:	6522                	ld	a0,8(sp)
  8001a0:	85a2                	mv	a1,s0
  8001a2:	e87ff0ef          	jal	800028 <dup2>
  8001a6:	842a                	mv	s0,a0
  8001a8:	6522                	ld	a0,8(sp)
  8001aa:	e7dff0ef          	jal	800026 <close>
  8001ae:	87a2                	mv	a5,s0
  8001b0:	bff1                	j	80018c <initfd+0x1c>

00000000008001b2 <umain>:
  8001b2:	1101                	addi	sp,sp,-32
  8001b4:	e822                	sd	s0,16(sp)
  8001b6:	e426                	sd	s1,8(sp)
  8001b8:	842a                	mv	s0,a0
  8001ba:	84ae                	mv	s1,a1
  8001bc:	4601                	li	a2,0
  8001be:	00000597          	auipc	a1,0x0
  8001c2:	52258593          	addi	a1,a1,1314 # 8006e0 <main+0x94>
  8001c6:	4501                	li	a0,0
  8001c8:	ec06                	sd	ra,24(sp)
  8001ca:	fa7ff0ef          	jal	800170 <initfd>
  8001ce:	02054263          	bltz	a0,8001f2 <umain+0x40>
  8001d2:	4605                	li	a2,1
  8001d4:	8532                	mv	a0,a2
  8001d6:	00000597          	auipc	a1,0x0
  8001da:	54a58593          	addi	a1,a1,1354 # 800720 <main+0xd4>
  8001de:	f93ff0ef          	jal	800170 <initfd>
  8001e2:	02054563          	bltz	a0,80020c <umain+0x5a>
  8001e6:	85a6                	mv	a1,s1
  8001e8:	8522                	mv	a0,s0
  8001ea:	462000ef          	jal	80064c <main>
  8001ee:	f69ff0ef          	jal	800156 <exit>
  8001f2:	86aa                	mv	a3,a0
  8001f4:	00000617          	auipc	a2,0x0
  8001f8:	4f460613          	addi	a2,a2,1268 # 8006e8 <main+0x9c>
  8001fc:	45e9                	li	a1,26
  8001fe:	00000517          	auipc	a0,0x0
  800202:	50a50513          	addi	a0,a0,1290 # 800708 <main+0xbc>
  800206:	e2bff0ef          	jal	800030 <__warn>
  80020a:	b7e1                	j	8001d2 <umain+0x20>
  80020c:	86aa                	mv	a3,a0
  80020e:	00000617          	auipc	a2,0x0
  800212:	51a60613          	addi	a2,a2,1306 # 800728 <main+0xdc>
  800216:	45f5                	li	a1,29
  800218:	00000517          	auipc	a0,0x0
  80021c:	4f050513          	addi	a0,a0,1264 # 800708 <main+0xbc>
  800220:	e11ff0ef          	jal	800030 <__warn>
  800224:	b7c9                	j	8001e6 <umain+0x34>

0000000000800226 <printnum>:
  800226:	7139                	addi	sp,sp,-64
  800228:	02071893          	slli	a7,a4,0x20
  80022c:	f822                	sd	s0,48(sp)
  80022e:	f426                	sd	s1,40(sp)
  800230:	f04a                	sd	s2,32(sp)
  800232:	ec4e                	sd	s3,24(sp)
  800234:	e456                	sd	s5,8(sp)
  800236:	0208d893          	srli	a7,a7,0x20
  80023a:	fc06                	sd	ra,56(sp)
  80023c:	0316fab3          	remu	s5,a3,a7
  800240:	fff7841b          	addiw	s0,a5,-1
  800244:	84aa                	mv	s1,a0
  800246:	89ae                	mv	s3,a1
  800248:	8932                	mv	s2,a2
  80024a:	0516f063          	bgeu	a3,a7,80028a <printnum+0x64>
  80024e:	e852                	sd	s4,16(sp)
  800250:	4705                	li	a4,1
  800252:	8a42                	mv	s4,a6
  800254:	00f75863          	bge	a4,a5,800264 <printnum+0x3e>
  800258:	864e                	mv	a2,s3
  80025a:	85ca                	mv	a1,s2
  80025c:	8552                	mv	a0,s4
  80025e:	347d                	addiw	s0,s0,-1
  800260:	9482                	jalr	s1
  800262:	f87d                	bnez	s0,800258 <printnum+0x32>
  800264:	6a42                	ld	s4,16(sp)
  800266:	00000797          	auipc	a5,0x0
  80026a:	4e278793          	addi	a5,a5,1250 # 800748 <main+0xfc>
  80026e:	97d6                	add	a5,a5,s5
  800270:	7442                	ld	s0,48(sp)
  800272:	0007c503          	lbu	a0,0(a5)
  800276:	70e2                	ld	ra,56(sp)
  800278:	6aa2                	ld	s5,8(sp)
  80027a:	864e                	mv	a2,s3
  80027c:	85ca                	mv	a1,s2
  80027e:	69e2                	ld	s3,24(sp)
  800280:	7902                	ld	s2,32(sp)
  800282:	87a6                	mv	a5,s1
  800284:	74a2                	ld	s1,40(sp)
  800286:	6121                	addi	sp,sp,64
  800288:	8782                	jr	a5
  80028a:	0316d6b3          	divu	a3,a3,a7
  80028e:	87a2                	mv	a5,s0
  800290:	f97ff0ef          	jal	800226 <printnum>
  800294:	bfc9                	j	800266 <printnum+0x40>

0000000000800296 <vprintfmt>:
  800296:	7119                	addi	sp,sp,-128
  800298:	f4a6                	sd	s1,104(sp)
  80029a:	f0ca                	sd	s2,96(sp)
  80029c:	ecce                	sd	s3,88(sp)
  80029e:	e8d2                	sd	s4,80(sp)
  8002a0:	e4d6                	sd	s5,72(sp)
  8002a2:	e0da                	sd	s6,64(sp)
  8002a4:	fc5e                	sd	s7,56(sp)
  8002a6:	f466                	sd	s9,40(sp)
  8002a8:	fc86                	sd	ra,120(sp)
  8002aa:	f8a2                	sd	s0,112(sp)
  8002ac:	f862                	sd	s8,48(sp)
  8002ae:	f06a                	sd	s10,32(sp)
  8002b0:	ec6e                	sd	s11,24(sp)
  8002b2:	84aa                	mv	s1,a0
  8002b4:	8cb6                	mv	s9,a3
  8002b6:	8aba                	mv	s5,a4
  8002b8:	89ae                	mv	s3,a1
  8002ba:	8932                	mv	s2,a2
  8002bc:	02500a13          	li	s4,37
  8002c0:	05500b93          	li	s7,85
  8002c4:	00000b17          	auipc	s6,0x0
  8002c8:	6bcb0b13          	addi	s6,s6,1724 # 800980 <main+0x334>
  8002cc:	000cc503          	lbu	a0,0(s9)
  8002d0:	001c8413          	addi	s0,s9,1
  8002d4:	01450b63          	beq	a0,s4,8002ea <vprintfmt+0x54>
  8002d8:	cd15                	beqz	a0,800314 <vprintfmt+0x7e>
  8002da:	864e                	mv	a2,s3
  8002dc:	85ca                	mv	a1,s2
  8002de:	9482                	jalr	s1
  8002e0:	00044503          	lbu	a0,0(s0)
  8002e4:	0405                	addi	s0,s0,1
  8002e6:	ff4519e3          	bne	a0,s4,8002d8 <vprintfmt+0x42>
  8002ea:	5d7d                	li	s10,-1
  8002ec:	8dea                	mv	s11,s10
  8002ee:	02000813          	li	a6,32
  8002f2:	4c01                	li	s8,0
  8002f4:	4581                	li	a1,0
  8002f6:	00044703          	lbu	a4,0(s0)
  8002fa:	00140c93          	addi	s9,s0,1
  8002fe:	fdd7061b          	addiw	a2,a4,-35
  800302:	0ff67613          	zext.b	a2,a2
  800306:	02cbe663          	bltu	s7,a2,800332 <vprintfmt+0x9c>
  80030a:	060a                	slli	a2,a2,0x2
  80030c:	965a                	add	a2,a2,s6
  80030e:	421c                	lw	a5,0(a2)
  800310:	97da                	add	a5,a5,s6
  800312:	8782                	jr	a5
  800314:	70e6                	ld	ra,120(sp)
  800316:	7446                	ld	s0,112(sp)
  800318:	74a6                	ld	s1,104(sp)
  80031a:	7906                	ld	s2,96(sp)
  80031c:	69e6                	ld	s3,88(sp)
  80031e:	6a46                	ld	s4,80(sp)
  800320:	6aa6                	ld	s5,72(sp)
  800322:	6b06                	ld	s6,64(sp)
  800324:	7be2                	ld	s7,56(sp)
  800326:	7c42                	ld	s8,48(sp)
  800328:	7ca2                	ld	s9,40(sp)
  80032a:	7d02                	ld	s10,32(sp)
  80032c:	6de2                	ld	s11,24(sp)
  80032e:	6109                	addi	sp,sp,128
  800330:	8082                	ret
  800332:	864e                	mv	a2,s3
  800334:	85ca                	mv	a1,s2
  800336:	02500513          	li	a0,37
  80033a:	9482                	jalr	s1
  80033c:	fff44783          	lbu	a5,-1(s0)
  800340:	02500713          	li	a4,37
  800344:	8ca2                	mv	s9,s0
  800346:	f8e783e3          	beq	a5,a4,8002cc <vprintfmt+0x36>
  80034a:	ffecc783          	lbu	a5,-2(s9)
  80034e:	1cfd                	addi	s9,s9,-1
  800350:	fee79de3          	bne	a5,a4,80034a <vprintfmt+0xb4>
  800354:	bfa5                	j	8002cc <vprintfmt+0x36>
  800356:	00144683          	lbu	a3,1(s0)
  80035a:	4525                	li	a0,9
  80035c:	fd070d1b          	addiw	s10,a4,-48
  800360:	fd06879b          	addiw	a5,a3,-48
  800364:	28f56063          	bltu	a0,a5,8005e4 <vprintfmt+0x34e>
  800368:	2681                	sext.w	a3,a3
  80036a:	8466                	mv	s0,s9
  80036c:	002d179b          	slliw	a5,s10,0x2
  800370:	00144703          	lbu	a4,1(s0)
  800374:	01a787bb          	addw	a5,a5,s10
  800378:	0017979b          	slliw	a5,a5,0x1
  80037c:	9fb5                	addw	a5,a5,a3
  80037e:	fd07061b          	addiw	a2,a4,-48
  800382:	0405                	addi	s0,s0,1
  800384:	fd078d1b          	addiw	s10,a5,-48
  800388:	0007069b          	sext.w	a3,a4
  80038c:	fec570e3          	bgeu	a0,a2,80036c <vprintfmt+0xd6>
  800390:	f60dd3e3          	bgez	s11,8002f6 <vprintfmt+0x60>
  800394:	8dea                	mv	s11,s10
  800396:	5d7d                	li	s10,-1
  800398:	bfb9                	j	8002f6 <vprintfmt+0x60>
  80039a:	883a                	mv	a6,a4
  80039c:	8466                	mv	s0,s9
  80039e:	bfa1                	j	8002f6 <vprintfmt+0x60>
  8003a0:	8466                	mv	s0,s9
  8003a2:	4c05                	li	s8,1
  8003a4:	bf89                	j	8002f6 <vprintfmt+0x60>
  8003a6:	4785                	li	a5,1
  8003a8:	008a8613          	addi	a2,s5,8
  8003ac:	00b7c463          	blt	a5,a1,8003b4 <vprintfmt+0x11e>
  8003b0:	1c058363          	beqz	a1,800576 <vprintfmt+0x2e0>
  8003b4:	000ab683          	ld	a3,0(s5)
  8003b8:	4741                	li	a4,16
  8003ba:	8ab2                	mv	s5,a2
  8003bc:	2801                	sext.w	a6,a6
  8003be:	87ee                	mv	a5,s11
  8003c0:	864a                	mv	a2,s2
  8003c2:	85ce                	mv	a1,s3
  8003c4:	8526                	mv	a0,s1
  8003c6:	e61ff0ef          	jal	800226 <printnum>
  8003ca:	b709                	j	8002cc <vprintfmt+0x36>
  8003cc:	000aa503          	lw	a0,0(s5)
  8003d0:	864e                	mv	a2,s3
  8003d2:	85ca                	mv	a1,s2
  8003d4:	9482                	jalr	s1
  8003d6:	0aa1                	addi	s5,s5,8
  8003d8:	bdd5                	j	8002cc <vprintfmt+0x36>
  8003da:	4785                	li	a5,1
  8003dc:	008a8613          	addi	a2,s5,8
  8003e0:	00b7c463          	blt	a5,a1,8003e8 <vprintfmt+0x152>
  8003e4:	18058463          	beqz	a1,80056c <vprintfmt+0x2d6>
  8003e8:	000ab683          	ld	a3,0(s5)
  8003ec:	4729                	li	a4,10
  8003ee:	8ab2                	mv	s5,a2
  8003f0:	b7f1                	j	8003bc <vprintfmt+0x126>
  8003f2:	864e                	mv	a2,s3
  8003f4:	85ca                	mv	a1,s2
  8003f6:	03000513          	li	a0,48
  8003fa:	e042                	sd	a6,0(sp)
  8003fc:	9482                	jalr	s1
  8003fe:	864e                	mv	a2,s3
  800400:	85ca                	mv	a1,s2
  800402:	07800513          	li	a0,120
  800406:	9482                	jalr	s1
  800408:	000ab683          	ld	a3,0(s5)
  80040c:	6802                	ld	a6,0(sp)
  80040e:	4741                	li	a4,16
  800410:	0aa1                	addi	s5,s5,8
  800412:	b76d                	j	8003bc <vprintfmt+0x126>
  800414:	864e                	mv	a2,s3
  800416:	85ca                	mv	a1,s2
  800418:	02500513          	li	a0,37
  80041c:	9482                	jalr	s1
  80041e:	b57d                	j	8002cc <vprintfmt+0x36>
  800420:	000aad03          	lw	s10,0(s5)
  800424:	8466                	mv	s0,s9
  800426:	0aa1                	addi	s5,s5,8
  800428:	b7a5                	j	800390 <vprintfmt+0xfa>
  80042a:	4785                	li	a5,1
  80042c:	008a8613          	addi	a2,s5,8
  800430:	00b7c463          	blt	a5,a1,800438 <vprintfmt+0x1a2>
  800434:	12058763          	beqz	a1,800562 <vprintfmt+0x2cc>
  800438:	000ab683          	ld	a3,0(s5)
  80043c:	4721                	li	a4,8
  80043e:	8ab2                	mv	s5,a2
  800440:	bfb5                	j	8003bc <vprintfmt+0x126>
  800442:	87ee                	mv	a5,s11
  800444:	000dd363          	bgez	s11,80044a <vprintfmt+0x1b4>
  800448:	4781                	li	a5,0
  80044a:	00078d9b          	sext.w	s11,a5
  80044e:	8466                	mv	s0,s9
  800450:	b55d                	j	8002f6 <vprintfmt+0x60>
  800452:	0008041b          	sext.w	s0,a6
  800456:	fd340793          	addi	a5,s0,-45
  80045a:	01b02733          	sgtz	a4,s11
  80045e:	00f037b3          	snez	a5,a5
  800462:	8ff9                	and	a5,a5,a4
  800464:	000ab703          	ld	a4,0(s5)
  800468:	008a8693          	addi	a3,s5,8
  80046c:	e436                	sd	a3,8(sp)
  80046e:	12070563          	beqz	a4,800598 <vprintfmt+0x302>
  800472:	12079d63          	bnez	a5,8005ac <vprintfmt+0x316>
  800476:	00074783          	lbu	a5,0(a4)
  80047a:	0007851b          	sext.w	a0,a5
  80047e:	c78d                	beqz	a5,8004a8 <vprintfmt+0x212>
  800480:	00170a93          	addi	s5,a4,1
  800484:	547d                	li	s0,-1
  800486:	000d4563          	bltz	s10,800490 <vprintfmt+0x1fa>
  80048a:	3d7d                	addiw	s10,s10,-1
  80048c:	008d0e63          	beq	s10,s0,8004a8 <vprintfmt+0x212>
  800490:	020c1863          	bnez	s8,8004c0 <vprintfmt+0x22a>
  800494:	864e                	mv	a2,s3
  800496:	85ca                	mv	a1,s2
  800498:	9482                	jalr	s1
  80049a:	000ac783          	lbu	a5,0(s5)
  80049e:	0a85                	addi	s5,s5,1
  8004a0:	3dfd                	addiw	s11,s11,-1
  8004a2:	0007851b          	sext.w	a0,a5
  8004a6:	f3e5                	bnez	a5,800486 <vprintfmt+0x1f0>
  8004a8:	01b05a63          	blez	s11,8004bc <vprintfmt+0x226>
  8004ac:	864e                	mv	a2,s3
  8004ae:	85ca                	mv	a1,s2
  8004b0:	02000513          	li	a0,32
  8004b4:	3dfd                	addiw	s11,s11,-1
  8004b6:	9482                	jalr	s1
  8004b8:	fe0d9ae3          	bnez	s11,8004ac <vprintfmt+0x216>
  8004bc:	6aa2                	ld	s5,8(sp)
  8004be:	b539                	j	8002cc <vprintfmt+0x36>
  8004c0:	3781                	addiw	a5,a5,-32
  8004c2:	05e00713          	li	a4,94
  8004c6:	fcf777e3          	bgeu	a4,a5,800494 <vprintfmt+0x1fe>
  8004ca:	03f00513          	li	a0,63
  8004ce:	864e                	mv	a2,s3
  8004d0:	85ca                	mv	a1,s2
  8004d2:	9482                	jalr	s1
  8004d4:	000ac783          	lbu	a5,0(s5)
  8004d8:	0a85                	addi	s5,s5,1
  8004da:	3dfd                	addiw	s11,s11,-1
  8004dc:	0007851b          	sext.w	a0,a5
  8004e0:	d7e1                	beqz	a5,8004a8 <vprintfmt+0x212>
  8004e2:	fa0d54e3          	bgez	s10,80048a <vprintfmt+0x1f4>
  8004e6:	bfe9                	j	8004c0 <vprintfmt+0x22a>
  8004e8:	000aa783          	lw	a5,0(s5)
  8004ec:	46e1                	li	a3,24
  8004ee:	0aa1                	addi	s5,s5,8
  8004f0:	41f7d71b          	sraiw	a4,a5,0x1f
  8004f4:	8fb9                	xor	a5,a5,a4
  8004f6:	40e7873b          	subw	a4,a5,a4
  8004fa:	02e6c663          	blt	a3,a4,800526 <vprintfmt+0x290>
  8004fe:	00000797          	auipc	a5,0x0
  800502:	5da78793          	addi	a5,a5,1498 # 800ad8 <error_string>
  800506:	00371693          	slli	a3,a4,0x3
  80050a:	97b6                	add	a5,a5,a3
  80050c:	639c                	ld	a5,0(a5)
  80050e:	cf81                	beqz	a5,800526 <vprintfmt+0x290>
  800510:	873e                	mv	a4,a5
  800512:	00000697          	auipc	a3,0x0
  800516:	26668693          	addi	a3,a3,614 # 800778 <main+0x12c>
  80051a:	864a                	mv	a2,s2
  80051c:	85ce                	mv	a1,s3
  80051e:	8526                	mv	a0,s1
  800520:	0f2000ef          	jal	800612 <printfmt>
  800524:	b365                	j	8002cc <vprintfmt+0x36>
  800526:	00000697          	auipc	a3,0x0
  80052a:	24268693          	addi	a3,a3,578 # 800768 <main+0x11c>
  80052e:	864a                	mv	a2,s2
  800530:	85ce                	mv	a1,s3
  800532:	8526                	mv	a0,s1
  800534:	0de000ef          	jal	800612 <printfmt>
  800538:	bb51                	j	8002cc <vprintfmt+0x36>
  80053a:	4785                	li	a5,1
  80053c:	008a8c13          	addi	s8,s5,8
  800540:	00b7c363          	blt	a5,a1,800546 <vprintfmt+0x2b0>
  800544:	cd81                	beqz	a1,80055c <vprintfmt+0x2c6>
  800546:	000ab403          	ld	s0,0(s5)
  80054a:	02044b63          	bltz	s0,800580 <vprintfmt+0x2ea>
  80054e:	86a2                	mv	a3,s0
  800550:	8ae2                	mv	s5,s8
  800552:	4729                	li	a4,10
  800554:	b5a5                	j	8003bc <vprintfmt+0x126>
  800556:	2585                	addiw	a1,a1,1
  800558:	8466                	mv	s0,s9
  80055a:	bb71                	j	8002f6 <vprintfmt+0x60>
  80055c:	000aa403          	lw	s0,0(s5)
  800560:	b7ed                	j	80054a <vprintfmt+0x2b4>
  800562:	000ae683          	lwu	a3,0(s5)
  800566:	4721                	li	a4,8
  800568:	8ab2                	mv	s5,a2
  80056a:	bd89                	j	8003bc <vprintfmt+0x126>
  80056c:	000ae683          	lwu	a3,0(s5)
  800570:	4729                	li	a4,10
  800572:	8ab2                	mv	s5,a2
  800574:	b5a1                	j	8003bc <vprintfmt+0x126>
  800576:	000ae683          	lwu	a3,0(s5)
  80057a:	4741                	li	a4,16
  80057c:	8ab2                	mv	s5,a2
  80057e:	bd3d                	j	8003bc <vprintfmt+0x126>
  800580:	864e                	mv	a2,s3
  800582:	85ca                	mv	a1,s2
  800584:	02d00513          	li	a0,45
  800588:	e042                	sd	a6,0(sp)
  80058a:	9482                	jalr	s1
  80058c:	6802                	ld	a6,0(sp)
  80058e:	408006b3          	neg	a3,s0
  800592:	8ae2                	mv	s5,s8
  800594:	4729                	li	a4,10
  800596:	b51d                	j	8003bc <vprintfmt+0x126>
  800598:	eba1                	bnez	a5,8005e8 <vprintfmt+0x352>
  80059a:	02800793          	li	a5,40
  80059e:	853e                	mv	a0,a5
  8005a0:	00000a97          	auipc	s5,0x0
  8005a4:	1c1a8a93          	addi	s5,s5,449 # 800761 <main+0x115>
  8005a8:	547d                	li	s0,-1
  8005aa:	bdf1                	j	800486 <vprintfmt+0x1f0>
  8005ac:	853a                	mv	a0,a4
  8005ae:	85ea                	mv	a1,s10
  8005b0:	e03a                	sd	a4,0(sp)
  8005b2:	07e000ef          	jal	800630 <strnlen>
  8005b6:	40ad8dbb          	subw	s11,s11,a0
  8005ba:	6702                	ld	a4,0(sp)
  8005bc:	01b05b63          	blez	s11,8005d2 <vprintfmt+0x33c>
  8005c0:	864e                	mv	a2,s3
  8005c2:	85ca                	mv	a1,s2
  8005c4:	8522                	mv	a0,s0
  8005c6:	e03a                	sd	a4,0(sp)
  8005c8:	3dfd                	addiw	s11,s11,-1
  8005ca:	9482                	jalr	s1
  8005cc:	6702                	ld	a4,0(sp)
  8005ce:	fe0d99e3          	bnez	s11,8005c0 <vprintfmt+0x32a>
  8005d2:	00074783          	lbu	a5,0(a4)
  8005d6:	0007851b          	sext.w	a0,a5
  8005da:	ee0781e3          	beqz	a5,8004bc <vprintfmt+0x226>
  8005de:	00170a93          	addi	s5,a4,1
  8005e2:	b54d                	j	800484 <vprintfmt+0x1ee>
  8005e4:	8466                	mv	s0,s9
  8005e6:	b36d                	j	800390 <vprintfmt+0xfa>
  8005e8:	85ea                	mv	a1,s10
  8005ea:	00000517          	auipc	a0,0x0
  8005ee:	17650513          	addi	a0,a0,374 # 800760 <main+0x114>
  8005f2:	03e000ef          	jal	800630 <strnlen>
  8005f6:	40ad8dbb          	subw	s11,s11,a0
  8005fa:	02800793          	li	a5,40
  8005fe:	00000717          	auipc	a4,0x0
  800602:	16270713          	addi	a4,a4,354 # 800760 <main+0x114>
  800606:	853e                	mv	a0,a5
  800608:	fbb04ce3          	bgtz	s11,8005c0 <vprintfmt+0x32a>
  80060c:	00170a93          	addi	s5,a4,1
  800610:	bd95                	j	800484 <vprintfmt+0x1ee>

0000000000800612 <printfmt>:
  800612:	7139                	addi	sp,sp,-64
  800614:	02010313          	addi	t1,sp,32
  800618:	f03a                	sd	a4,32(sp)
  80061a:	871a                	mv	a4,t1
  80061c:	ec06                	sd	ra,24(sp)
  80061e:	f43e                	sd	a5,40(sp)
  800620:	f842                	sd	a6,48(sp)
  800622:	fc46                	sd	a7,56(sp)
  800624:	e41a                	sd	t1,8(sp)
  800626:	c71ff0ef          	jal	800296 <vprintfmt>
  80062a:	60e2                	ld	ra,24(sp)
  80062c:	6121                	addi	sp,sp,64
  80062e:	8082                	ret

0000000000800630 <strnlen>:
  800630:	4781                	li	a5,0
  800632:	e589                	bnez	a1,80063c <strnlen+0xc>
  800634:	a811                	j	800648 <strnlen+0x18>
  800636:	0785                	addi	a5,a5,1
  800638:	00f58863          	beq	a1,a5,800648 <strnlen+0x18>
  80063c:	00f50733          	add	a4,a0,a5
  800640:	00074703          	lbu	a4,0(a4)
  800644:	fb6d                	bnez	a4,800636 <strnlen+0x6>
  800646:	85be                	mv	a1,a5
  800648:	852e                	mv	a0,a1
  80064a:	8082                	ret

000000000080064c <main>:
  80064c:	1141                	addi	sp,sp,-16
  80064e:	e406                	sd	ra,8(sp)
  800650:	b1dff0ef          	jal	80016c <getpid>
  800654:	85aa                	mv	a1,a0
  800656:	00000517          	auipc	a0,0x0
  80065a:	30250513          	addi	a0,a0,770 # 800958 <main+0x30c>
  80065e:	a55ff0ef          	jal	8000b2 <cprintf>
  800662:	b0dff0ef          	jal	80016e <print_pgdir>
  800666:	00000517          	auipc	a0,0x0
  80066a:	30a50513          	addi	a0,a0,778 # 800970 <main+0x324>
  80066e:	a45ff0ef          	jal	8000b2 <cprintf>
  800672:	60a2                	ld	ra,8(sp)
  800674:	4501                	li	a0,0
  800676:	0141                	addi	sp,sp,16
  800678:	8082                	ret
