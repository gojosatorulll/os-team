
obj/__user_matrix.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a2ad                	j	80018e <sys_open>

0000000000800026 <close>:
  800026:	aa8d                	j	800198 <sys_close>

0000000000800028 <dup2>:
  800028:	aaa5                	j	8001a0 <sys_dup>

000000000080002a <_start>:
  80002a:	1e6000ef          	jal	800210 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00001517          	auipc	a0,0x1
  800042:	8c250513          	addi	a0,a0,-1854 # 800900 <main+0xc4>
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
  800060:	00001517          	auipc	a0,0x1
  800064:	8c050513          	addi	a0,a0,-1856 # 800920 <main+0xe4>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	13c000ef          	jal	8001aa <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00001517          	auipc	a0,0x1
  800084:	8a850513          	addi	a0,a0,-1880 # 800928 <main+0xec>
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
  8000a2:	00001517          	auipc	a0,0x1
  8000a6:	87e50513          	addi	a0,a0,-1922 # 800920 <main+0xe4>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0cc000ef          	jal	800188 <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <mata+0xffffffffff7f57b1>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	20c000ef          	jal	8002f4 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <mata+0xffffffffff7f57b1>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1d2000ef          	jal	8002f4 <vprintfmt>
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

0000000000800184 <sys_getpid>:
  800184:	4549                	li	a0,18
  800186:	b765                	j	80012e <syscall>

0000000000800188 <sys_putc>:
  800188:	85aa                	mv	a1,a0
  80018a:	4579                	li	a0,30
  80018c:	b74d                	j	80012e <syscall>

000000000080018e <sys_open>:
  80018e:	862e                	mv	a2,a1
  800190:	85aa                	mv	a1,a0
  800192:	06400513          	li	a0,100
  800196:	bf61                	j	80012e <syscall>

0000000000800198 <sys_close>:
  800198:	85aa                	mv	a1,a0
  80019a:	06500513          	li	a0,101
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <sys_dup>:
  8001a0:	862e                	mv	a2,a1
  8001a2:	85aa                	mv	a1,a0
  8001a4:	08200513          	li	a0,130
  8001a8:	b759                	j	80012e <syscall>

00000000008001aa <exit>:
  8001aa:	1141                	addi	sp,sp,-16
  8001ac:	e406                	sd	ra,8(sp)
  8001ae:	fbbff0ef          	jal	800168 <sys_exit>
  8001b2:	00000517          	auipc	a0,0x0
  8001b6:	79650513          	addi	a0,a0,1942 # 800948 <main+0x10c>
  8001ba:	f3bff0ef          	jal	8000f4 <cprintf>
  8001be:	a001                	j	8001be <exit+0x14>

00000000008001c0 <fork>:
  8001c0:	b77d                	j	80016e <sys_fork>

00000000008001c2 <wait>:
  8001c2:	4581                	li	a1,0
  8001c4:	4501                	li	a0,0
  8001c6:	b775                	j	800172 <sys_wait>

00000000008001c8 <yield>:
  8001c8:	bf4d                	j	80017a <sys_yield>

00000000008001ca <kill>:
  8001ca:	bf55                	j	80017e <sys_kill>

00000000008001cc <getpid>:
  8001cc:	bf65                	j	800184 <sys_getpid>

00000000008001ce <initfd>:
  8001ce:	87ae                	mv	a5,a1
  8001d0:	1101                	addi	sp,sp,-32
  8001d2:	e822                	sd	s0,16(sp)
  8001d4:	85b2                	mv	a1,a2
  8001d6:	842a                	mv	s0,a0
  8001d8:	853e                	mv	a0,a5
  8001da:	ec06                	sd	ra,24(sp)
  8001dc:	e45ff0ef          	jal	800020 <open>
  8001e0:	87aa                	mv	a5,a0
  8001e2:	00054463          	bltz	a0,8001ea <initfd+0x1c>
  8001e6:	00851763          	bne	a0,s0,8001f4 <initfd+0x26>
  8001ea:	60e2                	ld	ra,24(sp)
  8001ec:	6442                	ld	s0,16(sp)
  8001ee:	853e                	mv	a0,a5
  8001f0:	6105                	addi	sp,sp,32
  8001f2:	8082                	ret
  8001f4:	e42a                	sd	a0,8(sp)
  8001f6:	8522                	mv	a0,s0
  8001f8:	e2fff0ef          	jal	800026 <close>
  8001fc:	6522                	ld	a0,8(sp)
  8001fe:	85a2                	mv	a1,s0
  800200:	e29ff0ef          	jal	800028 <dup2>
  800204:	842a                	mv	s0,a0
  800206:	6522                	ld	a0,8(sp)
  800208:	e1fff0ef          	jal	800026 <close>
  80020c:	87a2                	mv	a5,s0
  80020e:	bff1                	j	8001ea <initfd+0x1c>

0000000000800210 <umain>:
  800210:	1101                	addi	sp,sp,-32
  800212:	e822                	sd	s0,16(sp)
  800214:	e426                	sd	s1,8(sp)
  800216:	842a                	mv	s0,a0
  800218:	84ae                	mv	s1,a1
  80021a:	4601                	li	a2,0
  80021c:	00000597          	auipc	a1,0x0
  800220:	74458593          	addi	a1,a1,1860 # 800960 <main+0x124>
  800224:	4501                	li	a0,0
  800226:	ec06                	sd	ra,24(sp)
  800228:	fa7ff0ef          	jal	8001ce <initfd>
  80022c:	02054263          	bltz	a0,800250 <umain+0x40>
  800230:	4605                	li	a2,1
  800232:	8532                	mv	a0,a2
  800234:	00000597          	auipc	a1,0x0
  800238:	76c58593          	addi	a1,a1,1900 # 8009a0 <main+0x164>
  80023c:	f93ff0ef          	jal	8001ce <initfd>
  800240:	02054563          	bltz	a0,80026a <umain+0x5a>
  800244:	85a6                	mv	a1,s1
  800246:	8522                	mv	a0,s0
  800248:	5f4000ef          	jal	80083c <main>
  80024c:	f5fff0ef          	jal	8001aa <exit>
  800250:	86aa                	mv	a3,a0
  800252:	00000617          	auipc	a2,0x0
  800256:	71660613          	addi	a2,a2,1814 # 800968 <main+0x12c>
  80025a:	45e9                	li	a1,26
  80025c:	00000517          	auipc	a0,0x0
  800260:	72c50513          	addi	a0,a0,1836 # 800988 <main+0x14c>
  800264:	e0fff0ef          	jal	800072 <__warn>
  800268:	b7e1                	j	800230 <umain+0x20>
  80026a:	86aa                	mv	a3,a0
  80026c:	00000617          	auipc	a2,0x0
  800270:	73c60613          	addi	a2,a2,1852 # 8009a8 <main+0x16c>
  800274:	45f5                	li	a1,29
  800276:	00000517          	auipc	a0,0x0
  80027a:	71250513          	addi	a0,a0,1810 # 800988 <main+0x14c>
  80027e:	df5ff0ef          	jal	800072 <__warn>
  800282:	b7c9                	j	800244 <umain+0x34>

0000000000800284 <printnum>:
  800284:	7139                	addi	sp,sp,-64
  800286:	02071893          	slli	a7,a4,0x20
  80028a:	f822                	sd	s0,48(sp)
  80028c:	f426                	sd	s1,40(sp)
  80028e:	f04a                	sd	s2,32(sp)
  800290:	ec4e                	sd	s3,24(sp)
  800292:	e456                	sd	s5,8(sp)
  800294:	0208d893          	srli	a7,a7,0x20
  800298:	fc06                	sd	ra,56(sp)
  80029a:	0316fab3          	remu	s5,a3,a7
  80029e:	fff7841b          	addiw	s0,a5,-1
  8002a2:	84aa                	mv	s1,a0
  8002a4:	89ae                	mv	s3,a1
  8002a6:	8932                	mv	s2,a2
  8002a8:	0516f063          	bgeu	a3,a7,8002e8 <printnum+0x64>
  8002ac:	e852                	sd	s4,16(sp)
  8002ae:	4705                	li	a4,1
  8002b0:	8a42                	mv	s4,a6
  8002b2:	00f75863          	bge	a4,a5,8002c2 <printnum+0x3e>
  8002b6:	864e                	mv	a2,s3
  8002b8:	85ca                	mv	a1,s2
  8002ba:	8552                	mv	a0,s4
  8002bc:	347d                	addiw	s0,s0,-1
  8002be:	9482                	jalr	s1
  8002c0:	f87d                	bnez	s0,8002b6 <printnum+0x32>
  8002c2:	6a42                	ld	s4,16(sp)
  8002c4:	00000797          	auipc	a5,0x0
  8002c8:	70478793          	addi	a5,a5,1796 # 8009c8 <main+0x18c>
  8002cc:	97d6                	add	a5,a5,s5
  8002ce:	7442                	ld	s0,48(sp)
  8002d0:	0007c503          	lbu	a0,0(a5)
  8002d4:	70e2                	ld	ra,56(sp)
  8002d6:	6aa2                	ld	s5,8(sp)
  8002d8:	864e                	mv	a2,s3
  8002da:	85ca                	mv	a1,s2
  8002dc:	69e2                	ld	s3,24(sp)
  8002de:	7902                	ld	s2,32(sp)
  8002e0:	87a6                	mv	a5,s1
  8002e2:	74a2                	ld	s1,40(sp)
  8002e4:	6121                	addi	sp,sp,64
  8002e6:	8782                	jr	a5
  8002e8:	0316d6b3          	divu	a3,a3,a7
  8002ec:	87a2                	mv	a5,s0
  8002ee:	f97ff0ef          	jal	800284 <printnum>
  8002f2:	bfc9                	j	8002c4 <printnum+0x40>

00000000008002f4 <vprintfmt>:
  8002f4:	7119                	addi	sp,sp,-128
  8002f6:	f4a6                	sd	s1,104(sp)
  8002f8:	f0ca                	sd	s2,96(sp)
  8002fa:	ecce                	sd	s3,88(sp)
  8002fc:	e8d2                	sd	s4,80(sp)
  8002fe:	e4d6                	sd	s5,72(sp)
  800300:	e0da                	sd	s6,64(sp)
  800302:	fc5e                	sd	s7,56(sp)
  800304:	f466                	sd	s9,40(sp)
  800306:	fc86                	sd	ra,120(sp)
  800308:	f8a2                	sd	s0,112(sp)
  80030a:	f862                	sd	s8,48(sp)
  80030c:	f06a                	sd	s10,32(sp)
  80030e:	ec6e                	sd	s11,24(sp)
  800310:	84aa                	mv	s1,a0
  800312:	8cb6                	mv	s9,a3
  800314:	8aba                	mv	s5,a4
  800316:	89ae                	mv	s3,a1
  800318:	8932                	mv	s2,a2
  80031a:	02500a13          	li	s4,37
  80031e:	05500b93          	li	s7,85
  800322:	00001b17          	auipc	s6,0x1
  800326:	936b0b13          	addi	s6,s6,-1738 # 800c58 <main+0x41c>
  80032a:	000cc503          	lbu	a0,0(s9)
  80032e:	001c8413          	addi	s0,s9,1
  800332:	01450b63          	beq	a0,s4,800348 <vprintfmt+0x54>
  800336:	cd15                	beqz	a0,800372 <vprintfmt+0x7e>
  800338:	864e                	mv	a2,s3
  80033a:	85ca                	mv	a1,s2
  80033c:	9482                	jalr	s1
  80033e:	00044503          	lbu	a0,0(s0)
  800342:	0405                	addi	s0,s0,1
  800344:	ff4519e3          	bne	a0,s4,800336 <vprintfmt+0x42>
  800348:	5d7d                	li	s10,-1
  80034a:	8dea                	mv	s11,s10
  80034c:	02000813          	li	a6,32
  800350:	4c01                	li	s8,0
  800352:	4581                	li	a1,0
  800354:	00044703          	lbu	a4,0(s0)
  800358:	00140c93          	addi	s9,s0,1
  80035c:	fdd7061b          	addiw	a2,a4,-35
  800360:	0ff67613          	zext.b	a2,a2
  800364:	02cbe663          	bltu	s7,a2,800390 <vprintfmt+0x9c>
  800368:	060a                	slli	a2,a2,0x2
  80036a:	965a                	add	a2,a2,s6
  80036c:	421c                	lw	a5,0(a2)
  80036e:	97da                	add	a5,a5,s6
  800370:	8782                	jr	a5
  800372:	70e6                	ld	ra,120(sp)
  800374:	7446                	ld	s0,112(sp)
  800376:	74a6                	ld	s1,104(sp)
  800378:	7906                	ld	s2,96(sp)
  80037a:	69e6                	ld	s3,88(sp)
  80037c:	6a46                	ld	s4,80(sp)
  80037e:	6aa6                	ld	s5,72(sp)
  800380:	6b06                	ld	s6,64(sp)
  800382:	7be2                	ld	s7,56(sp)
  800384:	7c42                	ld	s8,48(sp)
  800386:	7ca2                	ld	s9,40(sp)
  800388:	7d02                	ld	s10,32(sp)
  80038a:	6de2                	ld	s11,24(sp)
  80038c:	6109                	addi	sp,sp,128
  80038e:	8082                	ret
  800390:	864e                	mv	a2,s3
  800392:	85ca                	mv	a1,s2
  800394:	02500513          	li	a0,37
  800398:	9482                	jalr	s1
  80039a:	fff44783          	lbu	a5,-1(s0)
  80039e:	02500713          	li	a4,37
  8003a2:	8ca2                	mv	s9,s0
  8003a4:	f8e783e3          	beq	a5,a4,80032a <vprintfmt+0x36>
  8003a8:	ffecc783          	lbu	a5,-2(s9)
  8003ac:	1cfd                	addi	s9,s9,-1
  8003ae:	fee79de3          	bne	a5,a4,8003a8 <vprintfmt+0xb4>
  8003b2:	bfa5                	j	80032a <vprintfmt+0x36>
  8003b4:	00144683          	lbu	a3,1(s0)
  8003b8:	4525                	li	a0,9
  8003ba:	fd070d1b          	addiw	s10,a4,-48
  8003be:	fd06879b          	addiw	a5,a3,-48
  8003c2:	28f56063          	bltu	a0,a5,800642 <vprintfmt+0x34e>
  8003c6:	2681                	sext.w	a3,a3
  8003c8:	8466                	mv	s0,s9
  8003ca:	002d179b          	slliw	a5,s10,0x2
  8003ce:	00144703          	lbu	a4,1(s0)
  8003d2:	01a787bb          	addw	a5,a5,s10
  8003d6:	0017979b          	slliw	a5,a5,0x1
  8003da:	9fb5                	addw	a5,a5,a3
  8003dc:	fd07061b          	addiw	a2,a4,-48
  8003e0:	0405                	addi	s0,s0,1
  8003e2:	fd078d1b          	addiw	s10,a5,-48
  8003e6:	0007069b          	sext.w	a3,a4
  8003ea:	fec570e3          	bgeu	a0,a2,8003ca <vprintfmt+0xd6>
  8003ee:	f60dd3e3          	bgez	s11,800354 <vprintfmt+0x60>
  8003f2:	8dea                	mv	s11,s10
  8003f4:	5d7d                	li	s10,-1
  8003f6:	bfb9                	j	800354 <vprintfmt+0x60>
  8003f8:	883a                	mv	a6,a4
  8003fa:	8466                	mv	s0,s9
  8003fc:	bfa1                	j	800354 <vprintfmt+0x60>
  8003fe:	8466                	mv	s0,s9
  800400:	4c05                	li	s8,1
  800402:	bf89                	j	800354 <vprintfmt+0x60>
  800404:	4785                	li	a5,1
  800406:	008a8613          	addi	a2,s5,8
  80040a:	00b7c463          	blt	a5,a1,800412 <vprintfmt+0x11e>
  80040e:	1c058363          	beqz	a1,8005d4 <vprintfmt+0x2e0>
  800412:	000ab683          	ld	a3,0(s5)
  800416:	4741                	li	a4,16
  800418:	8ab2                	mv	s5,a2
  80041a:	2801                	sext.w	a6,a6
  80041c:	87ee                	mv	a5,s11
  80041e:	864a                	mv	a2,s2
  800420:	85ce                	mv	a1,s3
  800422:	8526                	mv	a0,s1
  800424:	e61ff0ef          	jal	800284 <printnum>
  800428:	b709                	j	80032a <vprintfmt+0x36>
  80042a:	000aa503          	lw	a0,0(s5)
  80042e:	864e                	mv	a2,s3
  800430:	85ca                	mv	a1,s2
  800432:	9482                	jalr	s1
  800434:	0aa1                	addi	s5,s5,8
  800436:	bdd5                	j	80032a <vprintfmt+0x36>
  800438:	4785                	li	a5,1
  80043a:	008a8613          	addi	a2,s5,8
  80043e:	00b7c463          	blt	a5,a1,800446 <vprintfmt+0x152>
  800442:	18058463          	beqz	a1,8005ca <vprintfmt+0x2d6>
  800446:	000ab683          	ld	a3,0(s5)
  80044a:	4729                	li	a4,10
  80044c:	8ab2                	mv	s5,a2
  80044e:	b7f1                	j	80041a <vprintfmt+0x126>
  800450:	864e                	mv	a2,s3
  800452:	85ca                	mv	a1,s2
  800454:	03000513          	li	a0,48
  800458:	e042                	sd	a6,0(sp)
  80045a:	9482                	jalr	s1
  80045c:	864e                	mv	a2,s3
  80045e:	85ca                	mv	a1,s2
  800460:	07800513          	li	a0,120
  800464:	9482                	jalr	s1
  800466:	000ab683          	ld	a3,0(s5)
  80046a:	6802                	ld	a6,0(sp)
  80046c:	4741                	li	a4,16
  80046e:	0aa1                	addi	s5,s5,8
  800470:	b76d                	j	80041a <vprintfmt+0x126>
  800472:	864e                	mv	a2,s3
  800474:	85ca                	mv	a1,s2
  800476:	02500513          	li	a0,37
  80047a:	9482                	jalr	s1
  80047c:	b57d                	j	80032a <vprintfmt+0x36>
  80047e:	000aad03          	lw	s10,0(s5)
  800482:	8466                	mv	s0,s9
  800484:	0aa1                	addi	s5,s5,8
  800486:	b7a5                	j	8003ee <vprintfmt+0xfa>
  800488:	4785                	li	a5,1
  80048a:	008a8613          	addi	a2,s5,8
  80048e:	00b7c463          	blt	a5,a1,800496 <vprintfmt+0x1a2>
  800492:	12058763          	beqz	a1,8005c0 <vprintfmt+0x2cc>
  800496:	000ab683          	ld	a3,0(s5)
  80049a:	4721                	li	a4,8
  80049c:	8ab2                	mv	s5,a2
  80049e:	bfb5                	j	80041a <vprintfmt+0x126>
  8004a0:	87ee                	mv	a5,s11
  8004a2:	000dd363          	bgez	s11,8004a8 <vprintfmt+0x1b4>
  8004a6:	4781                	li	a5,0
  8004a8:	00078d9b          	sext.w	s11,a5
  8004ac:	8466                	mv	s0,s9
  8004ae:	b55d                	j	800354 <vprintfmt+0x60>
  8004b0:	0008041b          	sext.w	s0,a6
  8004b4:	fd340793          	addi	a5,s0,-45
  8004b8:	01b02733          	sgtz	a4,s11
  8004bc:	00f037b3          	snez	a5,a5
  8004c0:	8ff9                	and	a5,a5,a4
  8004c2:	000ab703          	ld	a4,0(s5)
  8004c6:	008a8693          	addi	a3,s5,8
  8004ca:	e436                	sd	a3,8(sp)
  8004cc:	12070563          	beqz	a4,8005f6 <vprintfmt+0x302>
  8004d0:	12079d63          	bnez	a5,80060a <vprintfmt+0x316>
  8004d4:	00074783          	lbu	a5,0(a4)
  8004d8:	0007851b          	sext.w	a0,a5
  8004dc:	c78d                	beqz	a5,800506 <vprintfmt+0x212>
  8004de:	00170a93          	addi	s5,a4,1
  8004e2:	547d                	li	s0,-1
  8004e4:	000d4563          	bltz	s10,8004ee <vprintfmt+0x1fa>
  8004e8:	3d7d                	addiw	s10,s10,-1
  8004ea:	008d0e63          	beq	s10,s0,800506 <vprintfmt+0x212>
  8004ee:	020c1863          	bnez	s8,80051e <vprintfmt+0x22a>
  8004f2:	864e                	mv	a2,s3
  8004f4:	85ca                	mv	a1,s2
  8004f6:	9482                	jalr	s1
  8004f8:	000ac783          	lbu	a5,0(s5)
  8004fc:	0a85                	addi	s5,s5,1
  8004fe:	3dfd                	addiw	s11,s11,-1
  800500:	0007851b          	sext.w	a0,a5
  800504:	f3e5                	bnez	a5,8004e4 <vprintfmt+0x1f0>
  800506:	01b05a63          	blez	s11,80051a <vprintfmt+0x226>
  80050a:	864e                	mv	a2,s3
  80050c:	85ca                	mv	a1,s2
  80050e:	02000513          	li	a0,32
  800512:	3dfd                	addiw	s11,s11,-1
  800514:	9482                	jalr	s1
  800516:	fe0d9ae3          	bnez	s11,80050a <vprintfmt+0x216>
  80051a:	6aa2                	ld	s5,8(sp)
  80051c:	b539                	j	80032a <vprintfmt+0x36>
  80051e:	3781                	addiw	a5,a5,-32
  800520:	05e00713          	li	a4,94
  800524:	fcf777e3          	bgeu	a4,a5,8004f2 <vprintfmt+0x1fe>
  800528:	03f00513          	li	a0,63
  80052c:	864e                	mv	a2,s3
  80052e:	85ca                	mv	a1,s2
  800530:	9482                	jalr	s1
  800532:	000ac783          	lbu	a5,0(s5)
  800536:	0a85                	addi	s5,s5,1
  800538:	3dfd                	addiw	s11,s11,-1
  80053a:	0007851b          	sext.w	a0,a5
  80053e:	d7e1                	beqz	a5,800506 <vprintfmt+0x212>
  800540:	fa0d54e3          	bgez	s10,8004e8 <vprintfmt+0x1f4>
  800544:	bfe9                	j	80051e <vprintfmt+0x22a>
  800546:	000aa783          	lw	a5,0(s5)
  80054a:	46e1                	li	a3,24
  80054c:	0aa1                	addi	s5,s5,8
  80054e:	41f7d71b          	sraiw	a4,a5,0x1f
  800552:	8fb9                	xor	a5,a5,a4
  800554:	40e7873b          	subw	a4,a5,a4
  800558:	02e6c663          	blt	a3,a4,800584 <vprintfmt+0x290>
  80055c:	00001797          	auipc	a5,0x1
  800560:	85478793          	addi	a5,a5,-1964 # 800db0 <error_string>
  800564:	00371693          	slli	a3,a4,0x3
  800568:	97b6                	add	a5,a5,a3
  80056a:	639c                	ld	a5,0(a5)
  80056c:	cf81                	beqz	a5,800584 <vprintfmt+0x290>
  80056e:	873e                	mv	a4,a5
  800570:	00000697          	auipc	a3,0x0
  800574:	48868693          	addi	a3,a3,1160 # 8009f8 <main+0x1bc>
  800578:	864a                	mv	a2,s2
  80057a:	85ce                	mv	a1,s3
  80057c:	8526                	mv	a0,s1
  80057e:	0f2000ef          	jal	800670 <printfmt>
  800582:	b365                	j	80032a <vprintfmt+0x36>
  800584:	00000697          	auipc	a3,0x0
  800588:	46468693          	addi	a3,a3,1124 # 8009e8 <main+0x1ac>
  80058c:	864a                	mv	a2,s2
  80058e:	85ce                	mv	a1,s3
  800590:	8526                	mv	a0,s1
  800592:	0de000ef          	jal	800670 <printfmt>
  800596:	bb51                	j	80032a <vprintfmt+0x36>
  800598:	4785                	li	a5,1
  80059a:	008a8c13          	addi	s8,s5,8
  80059e:	00b7c363          	blt	a5,a1,8005a4 <vprintfmt+0x2b0>
  8005a2:	cd81                	beqz	a1,8005ba <vprintfmt+0x2c6>
  8005a4:	000ab403          	ld	s0,0(s5)
  8005a8:	02044b63          	bltz	s0,8005de <vprintfmt+0x2ea>
  8005ac:	86a2                	mv	a3,s0
  8005ae:	8ae2                	mv	s5,s8
  8005b0:	4729                	li	a4,10
  8005b2:	b5a5                	j	80041a <vprintfmt+0x126>
  8005b4:	2585                	addiw	a1,a1,1
  8005b6:	8466                	mv	s0,s9
  8005b8:	bb71                	j	800354 <vprintfmt+0x60>
  8005ba:	000aa403          	lw	s0,0(s5)
  8005be:	b7ed                	j	8005a8 <vprintfmt+0x2b4>
  8005c0:	000ae683          	lwu	a3,0(s5)
  8005c4:	4721                	li	a4,8
  8005c6:	8ab2                	mv	s5,a2
  8005c8:	bd89                	j	80041a <vprintfmt+0x126>
  8005ca:	000ae683          	lwu	a3,0(s5)
  8005ce:	4729                	li	a4,10
  8005d0:	8ab2                	mv	s5,a2
  8005d2:	b5a1                	j	80041a <vprintfmt+0x126>
  8005d4:	000ae683          	lwu	a3,0(s5)
  8005d8:	4741                	li	a4,16
  8005da:	8ab2                	mv	s5,a2
  8005dc:	bd3d                	j	80041a <vprintfmt+0x126>
  8005de:	864e                	mv	a2,s3
  8005e0:	85ca                	mv	a1,s2
  8005e2:	02d00513          	li	a0,45
  8005e6:	e042                	sd	a6,0(sp)
  8005e8:	9482                	jalr	s1
  8005ea:	6802                	ld	a6,0(sp)
  8005ec:	408006b3          	neg	a3,s0
  8005f0:	8ae2                	mv	s5,s8
  8005f2:	4729                	li	a4,10
  8005f4:	b51d                	j	80041a <vprintfmt+0x126>
  8005f6:	eba1                	bnez	a5,800646 <vprintfmt+0x352>
  8005f8:	02800793          	li	a5,40
  8005fc:	853e                	mv	a0,a5
  8005fe:	00000a97          	auipc	s5,0x0
  800602:	3e3a8a93          	addi	s5,s5,995 # 8009e1 <main+0x1a5>
  800606:	547d                	li	s0,-1
  800608:	bdf1                	j	8004e4 <vprintfmt+0x1f0>
  80060a:	853a                	mv	a0,a4
  80060c:	85ea                	mv	a1,s10
  80060e:	e03a                	sd	a4,0(sp)
  800610:	0da000ef          	jal	8006ea <strnlen>
  800614:	40ad8dbb          	subw	s11,s11,a0
  800618:	6702                	ld	a4,0(sp)
  80061a:	01b05b63          	blez	s11,800630 <vprintfmt+0x33c>
  80061e:	864e                	mv	a2,s3
  800620:	85ca                	mv	a1,s2
  800622:	8522                	mv	a0,s0
  800624:	e03a                	sd	a4,0(sp)
  800626:	3dfd                	addiw	s11,s11,-1
  800628:	9482                	jalr	s1
  80062a:	6702                	ld	a4,0(sp)
  80062c:	fe0d99e3          	bnez	s11,80061e <vprintfmt+0x32a>
  800630:	00074783          	lbu	a5,0(a4)
  800634:	0007851b          	sext.w	a0,a5
  800638:	ee0781e3          	beqz	a5,80051a <vprintfmt+0x226>
  80063c:	00170a93          	addi	s5,a4,1
  800640:	b54d                	j	8004e2 <vprintfmt+0x1ee>
  800642:	8466                	mv	s0,s9
  800644:	b36d                	j	8003ee <vprintfmt+0xfa>
  800646:	85ea                	mv	a1,s10
  800648:	00000517          	auipc	a0,0x0
  80064c:	39850513          	addi	a0,a0,920 # 8009e0 <main+0x1a4>
  800650:	09a000ef          	jal	8006ea <strnlen>
  800654:	40ad8dbb          	subw	s11,s11,a0
  800658:	02800793          	li	a5,40
  80065c:	00000717          	auipc	a4,0x0
  800660:	38470713          	addi	a4,a4,900 # 8009e0 <main+0x1a4>
  800664:	853e                	mv	a0,a5
  800666:	fbb04ce3          	bgtz	s11,80061e <vprintfmt+0x32a>
  80066a:	00170a93          	addi	s5,a4,1
  80066e:	bd95                	j	8004e2 <vprintfmt+0x1ee>

0000000000800670 <printfmt>:
  800670:	7139                	addi	sp,sp,-64
  800672:	02010313          	addi	t1,sp,32
  800676:	f03a                	sd	a4,32(sp)
  800678:	871a                	mv	a4,t1
  80067a:	ec06                	sd	ra,24(sp)
  80067c:	f43e                	sd	a5,40(sp)
  80067e:	f842                	sd	a6,48(sp)
  800680:	fc46                	sd	a7,56(sp)
  800682:	e41a                	sd	t1,8(sp)
  800684:	c71ff0ef          	jal	8002f4 <vprintfmt>
  800688:	60e2                	ld	ra,24(sp)
  80068a:	6121                	addi	sp,sp,64
  80068c:	8082                	ret

000000000080068e <rand>:
  80068e:	002ef7b7          	lui	a5,0x2ef
  800692:	00001717          	auipc	a4,0x1
  800696:	96e73703          	ld	a4,-1682(a4) # 801000 <next>
  80069a:	76778793          	addi	a5,a5,1895 # 2ef767 <open-0x5108b9>
  80069e:	07b6                	slli	a5,a5,0xd
  8006a0:	66d78793          	addi	a5,a5,1645
  8006a4:	02f70733          	mul	a4,a4,a5
  8006a8:	4785                	li	a5,1
  8006aa:	1786                	slli	a5,a5,0x21
  8006ac:	0795                	addi	a5,a5,5
  8006ae:	072d                	addi	a4,a4,11
  8006b0:	0742                	slli	a4,a4,0x10
  8006b2:	8341                	srli	a4,a4,0x10
  8006b4:	00c75513          	srli	a0,a4,0xc
  8006b8:	02f537b3          	mulhu	a5,a0,a5
  8006bc:	00001697          	auipc	a3,0x1
  8006c0:	94e6b223          	sd	a4,-1724(a3) # 801000 <next>
  8006c4:	40f50733          	sub	a4,a0,a5
  8006c8:	8305                	srli	a4,a4,0x1
  8006ca:	97ba                	add	a5,a5,a4
  8006cc:	83f9                	srli	a5,a5,0x1e
  8006ce:	01f79713          	slli	a4,a5,0x1f
  8006d2:	40f707b3          	sub	a5,a4,a5
  8006d6:	8d1d                	sub	a0,a0,a5
  8006d8:	2505                	addiw	a0,a0,1
  8006da:	8082                	ret

00000000008006dc <srand>:
  8006dc:	1502                	slli	a0,a0,0x20
  8006de:	9101                	srli	a0,a0,0x20
  8006e0:	00001797          	auipc	a5,0x1
  8006e4:	92a7b023          	sd	a0,-1760(a5) # 801000 <next>
  8006e8:	8082                	ret

00000000008006ea <strnlen>:
  8006ea:	4781                	li	a5,0
  8006ec:	e589                	bnez	a1,8006f6 <strnlen+0xc>
  8006ee:	a811                	j	800702 <strnlen+0x18>
  8006f0:	0785                	addi	a5,a5,1
  8006f2:	00f58863          	beq	a1,a5,800702 <strnlen+0x18>
  8006f6:	00f50733          	add	a4,a0,a5
  8006fa:	00074703          	lbu	a4,0(a4)
  8006fe:	fb6d                	bnez	a4,8006f0 <strnlen+0x6>
  800700:	85be                	mv	a1,a5
  800702:	852e                	mv	a0,a1
  800704:	8082                	ret

0000000000800706 <memset>:
  800706:	ca01                	beqz	a2,800716 <memset+0x10>
  800708:	962a                	add	a2,a2,a0
  80070a:	87aa                	mv	a5,a0
  80070c:	0785                	addi	a5,a5,1
  80070e:	feb78fa3          	sb	a1,-1(a5)
  800712:	fef61de3          	bne	a2,a5,80070c <memset+0x6>
  800716:	8082                	ret

0000000000800718 <work>:
  800718:	1101                	addi	sp,sp,-32
  80071a:	e822                	sd	s0,16(sp)
  80071c:	e426                	sd	s1,8(sp)
  80071e:	ec06                	sd	ra,24(sp)
  800720:	84aa                	mv	s1,a0
  800722:	00001617          	auipc	a2,0x1
  800726:	a9e60613          	addi	a2,a2,-1378 # 8011c0 <matb+0x28>
  80072a:	00001417          	auipc	s0,0x1
  80072e:	c2640413          	addi	s0,s0,-986 # 801350 <mata+0x28>
  800732:	00001597          	auipc	a1,0x1
  800736:	bf658593          	addi	a1,a1,-1034 # 801328 <mata>
  80073a:	4685                	li	a3,1
  80073c:	fd860793          	addi	a5,a2,-40
  800740:	872e                	mv	a4,a1
  800742:	c394                	sw	a3,0(a5)
  800744:	c314                	sw	a3,0(a4)
  800746:	0791                	addi	a5,a5,4
  800748:	0711                	addi	a4,a4,4
  80074a:	fec79ce3          	bne	a5,a2,800742 <work+0x2a>
  80074e:	02878613          	addi	a2,a5,40
  800752:	02858593          	addi	a1,a1,40
  800756:	fe8613e3          	bne	a2,s0,80073c <work+0x24>
  80075a:	a6fff0ef          	jal	8001c8 <yield>
  80075e:	a6fff0ef          	jal	8001cc <getpid>
  800762:	85aa                	mv	a1,a0
  800764:	8626                	mv	a2,s1
  800766:	00000517          	auipc	a0,0x0
  80076a:	47250513          	addi	a0,a0,1138 # 800bd8 <main+0x39c>
  80076e:	987ff0ef          	jal	8000f4 <cprintf>
  800772:	c8cd                	beqz	s1,800824 <work+0x10c>
  800774:	34fd                	addiw	s1,s1,-1
  800776:	00001f17          	auipc	t5,0x1
  80077a:	bb2f0f13          	addi	t5,t5,-1102 # 801328 <mata>
  80077e:	00001e97          	auipc	t4,0x1
  800782:	d3ae8e93          	addi	t4,t4,-710 # 8014b8 <mata+0x190>
  800786:	5ffd                	li	t6,-1
  800788:	00001317          	auipc	t1,0x1
  80078c:	88030313          	addi	t1,t1,-1920 # 801008 <matc>
  800790:	8e1a                	mv	t3,t1
  800792:	00001897          	auipc	a7,0x1
  800796:	b9688893          	addi	a7,a7,-1130 # 801328 <mata>
  80079a:	00001517          	auipc	a0,0x1
  80079e:	b8e50513          	addi	a0,a0,-1138 # 801328 <mata>
  8007a2:	8872                	mv	a6,t3
  8007a4:	e7050793          	addi	a5,a0,-400
  8007a8:	86c6                	mv	a3,a7
  8007aa:	4601                	li	a2,0
  8007ac:	428c                	lw	a1,0(a3)
  8007ae:	4398                	lw	a4,0(a5)
  8007b0:	02878793          	addi	a5,a5,40
  8007b4:	0691                	addi	a3,a3,4
  8007b6:	02b7073b          	mulw	a4,a4,a1
  8007ba:	9e39                	addw	a2,a2,a4
  8007bc:	fea798e3          	bne	a5,a0,8007ac <work+0x94>
  8007c0:	00c82023          	sw	a2,0(a6)
  8007c4:	00478513          	addi	a0,a5,4
  8007c8:	0811                	addi	a6,a6,4
  8007ca:	fc851de3          	bne	a0,s0,8007a4 <work+0x8c>
  8007ce:	02888893          	addi	a7,a7,40
  8007d2:	028e0e13          	addi	t3,t3,40
  8007d6:	fd1e92e3          	bne	t4,a7,80079a <work+0x82>
  8007da:	00001597          	auipc	a1,0x1
  8007de:	85658593          	addi	a1,a1,-1962 # 801030 <matc+0x28>
  8007e2:	00001817          	auipc	a6,0x1
  8007e6:	b4680813          	addi	a6,a6,-1210 # 801328 <mata>
  8007ea:	00001517          	auipc	a0,0x1
  8007ee:	9ae50513          	addi	a0,a0,-1618 # 801198 <matb>
  8007f2:	86aa                	mv	a3,a0
  8007f4:	8742                	mv	a4,a6
  8007f6:	879a                	mv	a5,t1
  8007f8:	6390                	ld	a2,0(a5)
  8007fa:	07a1                	addi	a5,a5,8
  8007fc:	06a1                	addi	a3,a3,8
  8007fe:	fec6bc23          	sd	a2,-8(a3)
  800802:	e310                	sd	a2,0(a4)
  800804:	0721                	addi	a4,a4,8
  800806:	feb799e3          	bne	a5,a1,8007f8 <work+0xe0>
  80080a:	02850513          	addi	a0,a0,40
  80080e:	02830313          	addi	t1,t1,40
  800812:	02880813          	addi	a6,a6,40
  800816:	02878593          	addi	a1,a5,40
  80081a:	fcaf1ce3          	bne	t5,a0,8007f2 <work+0xda>
  80081e:	34fd                	addiw	s1,s1,-1
  800820:	f7f494e3          	bne	s1,t6,800788 <work+0x70>
  800824:	9a9ff0ef          	jal	8001cc <getpid>
  800828:	85aa                	mv	a1,a0
  80082a:	00000517          	auipc	a0,0x0
  80082e:	3ce50513          	addi	a0,a0,974 # 800bf8 <main+0x3bc>
  800832:	8c3ff0ef          	jal	8000f4 <cprintf>
  800836:	4501                	li	a0,0
  800838:	973ff0ef          	jal	8001aa <exit>

000000000080083c <main>:
  80083c:	7175                	addi	sp,sp,-144
  80083e:	f4ce                	sd	s3,104(sp)
  800840:	0028                	addi	a0,sp,8
  800842:	05400613          	li	a2,84
  800846:	4581                	li	a1,0
  800848:	00810993          	addi	s3,sp,8
  80084c:	e122                	sd	s0,128(sp)
  80084e:	fca6                	sd	s1,120(sp)
  800850:	f8ca                	sd	s2,112(sp)
  800852:	e506                	sd	ra,136(sp)
  800854:	84ce                	mv	s1,s3
  800856:	eb1ff0ef          	jal	800706 <memset>
  80085a:	4401                	li	s0,0
  80085c:	4955                	li	s2,21
  80085e:	963ff0ef          	jal	8001c0 <fork>
  800862:	c088                	sw	a0,0(s1)
  800864:	cd25                	beqz	a0,8008dc <main+0xa0>
  800866:	04054563          	bltz	a0,8008b0 <main+0x74>
  80086a:	2405                	addiw	s0,s0,1
  80086c:	0491                	addi	s1,s1,4
  80086e:	ff2418e3          	bne	s0,s2,80085e <main+0x22>
  800872:	00000517          	auipc	a0,0x0
  800876:	39650513          	addi	a0,a0,918 # 800c08 <main+0x3cc>
  80087a:	87bff0ef          	jal	8000f4 <cprintf>
  80087e:	945ff0ef          	jal	8001c2 <wait>
  800882:	e10d                	bnez	a0,8008a4 <main+0x68>
  800884:	347d                	addiw	s0,s0,-1
  800886:	fc65                	bnez	s0,80087e <main+0x42>
  800888:	00000517          	auipc	a0,0x0
  80088c:	3a050513          	addi	a0,a0,928 # 800c28 <main+0x3ec>
  800890:	865ff0ef          	jal	8000f4 <cprintf>
  800894:	60aa                	ld	ra,136(sp)
  800896:	640a                	ld	s0,128(sp)
  800898:	74e6                	ld	s1,120(sp)
  80089a:	7946                	ld	s2,112(sp)
  80089c:	79a6                	ld	s3,104(sp)
  80089e:	4501                	li	a0,0
  8008a0:	6149                	addi	sp,sp,144
  8008a2:	8082                	ret
  8008a4:	00000517          	auipc	a0,0x0
  8008a8:	37450513          	addi	a0,a0,884 # 800c18 <main+0x3dc>
  8008ac:	849ff0ef          	jal	8000f4 <cprintf>
  8008b0:	08e0                	addi	s0,sp,92
  8008b2:	0009a503          	lw	a0,0(s3)
  8008b6:	00a05463          	blez	a0,8008be <main+0x82>
  8008ba:	911ff0ef          	jal	8001ca <kill>
  8008be:	0991                	addi	s3,s3,4
  8008c0:	fe8999e3          	bne	s3,s0,8008b2 <main+0x76>
  8008c4:	00000617          	auipc	a2,0x0
  8008c8:	37460613          	addi	a2,a2,884 # 800c38 <main+0x3fc>
  8008cc:	05200593          	li	a1,82
  8008d0:	00000517          	auipc	a0,0x0
  8008d4:	37850513          	addi	a0,a0,888 # 800c48 <main+0x40c>
  8008d8:	f58ff0ef          	jal	800030 <__panic>
  8008dc:	0284053b          	mulw	a0,s0,s0
  8008e0:	dfdff0ef          	jal	8006dc <srand>
  8008e4:	dabff0ef          	jal	80068e <rand>
  8008e8:	47d5                	li	a5,21
  8008ea:	02f577bb          	remuw	a5,a0,a5
  8008ee:	06400513          	li	a0,100
  8008f2:	02f787bb          	mulw	a5,a5,a5
  8008f6:	27a9                	addiw	a5,a5,10
  8008f8:	02f5053b          	mulw	a0,a0,a5
  8008fc:	e1dff0ef          	jal	800718 <work>
