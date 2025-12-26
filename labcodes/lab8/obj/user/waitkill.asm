
obj/__user_waitkill.out:     file format elf64-littleriscv


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
  80002a:	1e2000ef          	jal	80020c <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	7aa50513          	addi	a0,a0,1962 # 8007e8 <main+0xba>
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
  800064:	a6050513          	addi	a0,a0,-1440 # 800ac0 <main+0x392>
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
  800080:	00000517          	auipc	a0,0x0
  800084:	78850513          	addi	a0,a0,1928 # 800808 <main+0xda>
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
  8000a6:	a1e50513          	addi	a0,a0,-1506 # 800ac0 <main+0x392>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <parent+0xffffffffff7f5ad1>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	208000ef          	jal	8002f0 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <parent+0xffffffffff7f5ad1>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1ce000ef          	jal	8002f0 <vprintfmt>
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
  8001b6:	67650513          	addi	a0,a0,1654 # 800828 <main+0xfa>
  8001ba:	f3bff0ef          	jal	8000f4 <cprintf>
  8001be:	a001                	j	8001be <exit+0x14>

00000000008001c0 <fork>:
  8001c0:	b77d                	j	80016e <sys_fork>

00000000008001c2 <waitpid>:
  8001c2:	bf45                	j	800172 <sys_wait>

00000000008001c4 <yield>:
  8001c4:	bf5d                	j	80017a <sys_yield>

00000000008001c6 <kill>:
  8001c6:	bf65                	j	80017e <sys_kill>

00000000008001c8 <getpid>:
  8001c8:	bf75                	j	800184 <sys_getpid>

00000000008001ca <initfd>:
  8001ca:	87ae                	mv	a5,a1
  8001cc:	1101                	addi	sp,sp,-32
  8001ce:	e822                	sd	s0,16(sp)
  8001d0:	85b2                	mv	a1,a2
  8001d2:	842a                	mv	s0,a0
  8001d4:	853e                	mv	a0,a5
  8001d6:	ec06                	sd	ra,24(sp)
  8001d8:	e49ff0ef          	jal	800020 <open>
  8001dc:	87aa                	mv	a5,a0
  8001de:	00054463          	bltz	a0,8001e6 <initfd+0x1c>
  8001e2:	00851763          	bne	a0,s0,8001f0 <initfd+0x26>
  8001e6:	60e2                	ld	ra,24(sp)
  8001e8:	6442                	ld	s0,16(sp)
  8001ea:	853e                	mv	a0,a5
  8001ec:	6105                	addi	sp,sp,32
  8001ee:	8082                	ret
  8001f0:	e42a                	sd	a0,8(sp)
  8001f2:	8522                	mv	a0,s0
  8001f4:	e33ff0ef          	jal	800026 <close>
  8001f8:	6522                	ld	a0,8(sp)
  8001fa:	85a2                	mv	a1,s0
  8001fc:	e2dff0ef          	jal	800028 <dup2>
  800200:	842a                	mv	s0,a0
  800202:	6522                	ld	a0,8(sp)
  800204:	e23ff0ef          	jal	800026 <close>
  800208:	87a2                	mv	a5,s0
  80020a:	bff1                	j	8001e6 <initfd+0x1c>

000000000080020c <umain>:
  80020c:	1101                	addi	sp,sp,-32
  80020e:	e822                	sd	s0,16(sp)
  800210:	e426                	sd	s1,8(sp)
  800212:	842a                	mv	s0,a0
  800214:	84ae                	mv	s1,a1
  800216:	4601                	li	a2,0
  800218:	00000597          	auipc	a1,0x0
  80021c:	62858593          	addi	a1,a1,1576 # 800840 <main+0x112>
  800220:	4501                	li	a0,0
  800222:	ec06                	sd	ra,24(sp)
  800224:	fa7ff0ef          	jal	8001ca <initfd>
  800228:	02054263          	bltz	a0,80024c <umain+0x40>
  80022c:	4605                	li	a2,1
  80022e:	8532                	mv	a0,a2
  800230:	00000597          	auipc	a1,0x0
  800234:	65058593          	addi	a1,a1,1616 # 800880 <main+0x152>
  800238:	f93ff0ef          	jal	8001ca <initfd>
  80023c:	02054563          	bltz	a0,800266 <umain+0x5a>
  800240:	85a6                	mv	a1,s1
  800242:	8522                	mv	a0,s0
  800244:	4ea000ef          	jal	80072e <main>
  800248:	f63ff0ef          	jal	8001aa <exit>
  80024c:	86aa                	mv	a3,a0
  80024e:	00000617          	auipc	a2,0x0
  800252:	5fa60613          	addi	a2,a2,1530 # 800848 <main+0x11a>
  800256:	45e9                	li	a1,26
  800258:	00000517          	auipc	a0,0x0
  80025c:	61050513          	addi	a0,a0,1552 # 800868 <main+0x13a>
  800260:	e13ff0ef          	jal	800072 <__warn>
  800264:	b7e1                	j	80022c <umain+0x20>
  800266:	86aa                	mv	a3,a0
  800268:	00000617          	auipc	a2,0x0
  80026c:	62060613          	addi	a2,a2,1568 # 800888 <main+0x15a>
  800270:	45f5                	li	a1,29
  800272:	00000517          	auipc	a0,0x0
  800276:	5f650513          	addi	a0,a0,1526 # 800868 <main+0x13a>
  80027a:	df9ff0ef          	jal	800072 <__warn>
  80027e:	b7c9                	j	800240 <umain+0x34>

0000000000800280 <printnum>:
  800280:	7139                	addi	sp,sp,-64
  800282:	02071893          	slli	a7,a4,0x20
  800286:	f822                	sd	s0,48(sp)
  800288:	f426                	sd	s1,40(sp)
  80028a:	f04a                	sd	s2,32(sp)
  80028c:	ec4e                	sd	s3,24(sp)
  80028e:	e456                	sd	s5,8(sp)
  800290:	0208d893          	srli	a7,a7,0x20
  800294:	fc06                	sd	ra,56(sp)
  800296:	0316fab3          	remu	s5,a3,a7
  80029a:	fff7841b          	addiw	s0,a5,-1
  80029e:	84aa                	mv	s1,a0
  8002a0:	89ae                	mv	s3,a1
  8002a2:	8932                	mv	s2,a2
  8002a4:	0516f063          	bgeu	a3,a7,8002e4 <printnum+0x64>
  8002a8:	e852                	sd	s4,16(sp)
  8002aa:	4705                	li	a4,1
  8002ac:	8a42                	mv	s4,a6
  8002ae:	00f75863          	bge	a4,a5,8002be <printnum+0x3e>
  8002b2:	864e                	mv	a2,s3
  8002b4:	85ca                	mv	a1,s2
  8002b6:	8552                	mv	a0,s4
  8002b8:	347d                	addiw	s0,s0,-1
  8002ba:	9482                	jalr	s1
  8002bc:	f87d                	bnez	s0,8002b2 <printnum+0x32>
  8002be:	6a42                	ld	s4,16(sp)
  8002c0:	00000797          	auipc	a5,0x0
  8002c4:	5e878793          	addi	a5,a5,1512 # 8008a8 <main+0x17a>
  8002c8:	97d6                	add	a5,a5,s5
  8002ca:	7442                	ld	s0,48(sp)
  8002cc:	0007c503          	lbu	a0,0(a5)
  8002d0:	70e2                	ld	ra,56(sp)
  8002d2:	6aa2                	ld	s5,8(sp)
  8002d4:	864e                	mv	a2,s3
  8002d6:	85ca                	mv	a1,s2
  8002d8:	69e2                	ld	s3,24(sp)
  8002da:	7902                	ld	s2,32(sp)
  8002dc:	87a6                	mv	a5,s1
  8002de:	74a2                	ld	s1,40(sp)
  8002e0:	6121                	addi	sp,sp,64
  8002e2:	8782                	jr	a5
  8002e4:	0316d6b3          	divu	a3,a3,a7
  8002e8:	87a2                	mv	a5,s0
  8002ea:	f97ff0ef          	jal	800280 <printnum>
  8002ee:	bfc9                	j	8002c0 <printnum+0x40>

00000000008002f0 <vprintfmt>:
  8002f0:	7119                	addi	sp,sp,-128
  8002f2:	f4a6                	sd	s1,104(sp)
  8002f4:	f0ca                	sd	s2,96(sp)
  8002f6:	ecce                	sd	s3,88(sp)
  8002f8:	e8d2                	sd	s4,80(sp)
  8002fa:	e4d6                	sd	s5,72(sp)
  8002fc:	e0da                	sd	s6,64(sp)
  8002fe:	fc5e                	sd	s7,56(sp)
  800300:	f466                	sd	s9,40(sp)
  800302:	fc86                	sd	ra,120(sp)
  800304:	f8a2                	sd	s0,112(sp)
  800306:	f862                	sd	s8,48(sp)
  800308:	f06a                	sd	s10,32(sp)
  80030a:	ec6e                	sd	s11,24(sp)
  80030c:	84aa                	mv	s1,a0
  80030e:	8cb6                	mv	s9,a3
  800310:	8aba                	mv	s5,a4
  800312:	89ae                	mv	s3,a1
  800314:	8932                	mv	s2,a2
  800316:	02500a13          	li	s4,37
  80031a:	05500b93          	li	s7,85
  80031e:	00001b17          	auipc	s6,0x1
  800322:	856b0b13          	addi	s6,s6,-1962 # 800b74 <main+0x446>
  800326:	000cc503          	lbu	a0,0(s9)
  80032a:	001c8413          	addi	s0,s9,1
  80032e:	01450b63          	beq	a0,s4,800344 <vprintfmt+0x54>
  800332:	cd15                	beqz	a0,80036e <vprintfmt+0x7e>
  800334:	864e                	mv	a2,s3
  800336:	85ca                	mv	a1,s2
  800338:	9482                	jalr	s1
  80033a:	00044503          	lbu	a0,0(s0)
  80033e:	0405                	addi	s0,s0,1
  800340:	ff4519e3          	bne	a0,s4,800332 <vprintfmt+0x42>
  800344:	5d7d                	li	s10,-1
  800346:	8dea                	mv	s11,s10
  800348:	02000813          	li	a6,32
  80034c:	4c01                	li	s8,0
  80034e:	4581                	li	a1,0
  800350:	00044703          	lbu	a4,0(s0)
  800354:	00140c93          	addi	s9,s0,1
  800358:	fdd7061b          	addiw	a2,a4,-35
  80035c:	0ff67613          	zext.b	a2,a2
  800360:	02cbe663          	bltu	s7,a2,80038c <vprintfmt+0x9c>
  800364:	060a                	slli	a2,a2,0x2
  800366:	965a                	add	a2,a2,s6
  800368:	421c                	lw	a5,0(a2)
  80036a:	97da                	add	a5,a5,s6
  80036c:	8782                	jr	a5
  80036e:	70e6                	ld	ra,120(sp)
  800370:	7446                	ld	s0,112(sp)
  800372:	74a6                	ld	s1,104(sp)
  800374:	7906                	ld	s2,96(sp)
  800376:	69e6                	ld	s3,88(sp)
  800378:	6a46                	ld	s4,80(sp)
  80037a:	6aa6                	ld	s5,72(sp)
  80037c:	6b06                	ld	s6,64(sp)
  80037e:	7be2                	ld	s7,56(sp)
  800380:	7c42                	ld	s8,48(sp)
  800382:	7ca2                	ld	s9,40(sp)
  800384:	7d02                	ld	s10,32(sp)
  800386:	6de2                	ld	s11,24(sp)
  800388:	6109                	addi	sp,sp,128
  80038a:	8082                	ret
  80038c:	864e                	mv	a2,s3
  80038e:	85ca                	mv	a1,s2
  800390:	02500513          	li	a0,37
  800394:	9482                	jalr	s1
  800396:	fff44783          	lbu	a5,-1(s0)
  80039a:	02500713          	li	a4,37
  80039e:	8ca2                	mv	s9,s0
  8003a0:	f8e783e3          	beq	a5,a4,800326 <vprintfmt+0x36>
  8003a4:	ffecc783          	lbu	a5,-2(s9)
  8003a8:	1cfd                	addi	s9,s9,-1
  8003aa:	fee79de3          	bne	a5,a4,8003a4 <vprintfmt+0xb4>
  8003ae:	bfa5                	j	800326 <vprintfmt+0x36>
  8003b0:	00144683          	lbu	a3,1(s0)
  8003b4:	4525                	li	a0,9
  8003b6:	fd070d1b          	addiw	s10,a4,-48
  8003ba:	fd06879b          	addiw	a5,a3,-48
  8003be:	28f56063          	bltu	a0,a5,80063e <vprintfmt+0x34e>
  8003c2:	2681                	sext.w	a3,a3
  8003c4:	8466                	mv	s0,s9
  8003c6:	002d179b          	slliw	a5,s10,0x2
  8003ca:	00144703          	lbu	a4,1(s0)
  8003ce:	01a787bb          	addw	a5,a5,s10
  8003d2:	0017979b          	slliw	a5,a5,0x1
  8003d6:	9fb5                	addw	a5,a5,a3
  8003d8:	fd07061b          	addiw	a2,a4,-48
  8003dc:	0405                	addi	s0,s0,1
  8003de:	fd078d1b          	addiw	s10,a5,-48
  8003e2:	0007069b          	sext.w	a3,a4
  8003e6:	fec570e3          	bgeu	a0,a2,8003c6 <vprintfmt+0xd6>
  8003ea:	f60dd3e3          	bgez	s11,800350 <vprintfmt+0x60>
  8003ee:	8dea                	mv	s11,s10
  8003f0:	5d7d                	li	s10,-1
  8003f2:	bfb9                	j	800350 <vprintfmt+0x60>
  8003f4:	883a                	mv	a6,a4
  8003f6:	8466                	mv	s0,s9
  8003f8:	bfa1                	j	800350 <vprintfmt+0x60>
  8003fa:	8466                	mv	s0,s9
  8003fc:	4c05                	li	s8,1
  8003fe:	bf89                	j	800350 <vprintfmt+0x60>
  800400:	4785                	li	a5,1
  800402:	008a8613          	addi	a2,s5,8
  800406:	00b7c463          	blt	a5,a1,80040e <vprintfmt+0x11e>
  80040a:	1c058363          	beqz	a1,8005d0 <vprintfmt+0x2e0>
  80040e:	000ab683          	ld	a3,0(s5)
  800412:	4741                	li	a4,16
  800414:	8ab2                	mv	s5,a2
  800416:	2801                	sext.w	a6,a6
  800418:	87ee                	mv	a5,s11
  80041a:	864a                	mv	a2,s2
  80041c:	85ce                	mv	a1,s3
  80041e:	8526                	mv	a0,s1
  800420:	e61ff0ef          	jal	800280 <printnum>
  800424:	b709                	j	800326 <vprintfmt+0x36>
  800426:	000aa503          	lw	a0,0(s5)
  80042a:	864e                	mv	a2,s3
  80042c:	85ca                	mv	a1,s2
  80042e:	9482                	jalr	s1
  800430:	0aa1                	addi	s5,s5,8
  800432:	bdd5                	j	800326 <vprintfmt+0x36>
  800434:	4785                	li	a5,1
  800436:	008a8613          	addi	a2,s5,8
  80043a:	00b7c463          	blt	a5,a1,800442 <vprintfmt+0x152>
  80043e:	18058463          	beqz	a1,8005c6 <vprintfmt+0x2d6>
  800442:	000ab683          	ld	a3,0(s5)
  800446:	4729                	li	a4,10
  800448:	8ab2                	mv	s5,a2
  80044a:	b7f1                	j	800416 <vprintfmt+0x126>
  80044c:	864e                	mv	a2,s3
  80044e:	85ca                	mv	a1,s2
  800450:	03000513          	li	a0,48
  800454:	e042                	sd	a6,0(sp)
  800456:	9482                	jalr	s1
  800458:	864e                	mv	a2,s3
  80045a:	85ca                	mv	a1,s2
  80045c:	07800513          	li	a0,120
  800460:	9482                	jalr	s1
  800462:	000ab683          	ld	a3,0(s5)
  800466:	6802                	ld	a6,0(sp)
  800468:	4741                	li	a4,16
  80046a:	0aa1                	addi	s5,s5,8
  80046c:	b76d                	j	800416 <vprintfmt+0x126>
  80046e:	864e                	mv	a2,s3
  800470:	85ca                	mv	a1,s2
  800472:	02500513          	li	a0,37
  800476:	9482                	jalr	s1
  800478:	b57d                	j	800326 <vprintfmt+0x36>
  80047a:	000aad03          	lw	s10,0(s5)
  80047e:	8466                	mv	s0,s9
  800480:	0aa1                	addi	s5,s5,8
  800482:	b7a5                	j	8003ea <vprintfmt+0xfa>
  800484:	4785                	li	a5,1
  800486:	008a8613          	addi	a2,s5,8
  80048a:	00b7c463          	blt	a5,a1,800492 <vprintfmt+0x1a2>
  80048e:	12058763          	beqz	a1,8005bc <vprintfmt+0x2cc>
  800492:	000ab683          	ld	a3,0(s5)
  800496:	4721                	li	a4,8
  800498:	8ab2                	mv	s5,a2
  80049a:	bfb5                	j	800416 <vprintfmt+0x126>
  80049c:	87ee                	mv	a5,s11
  80049e:	000dd363          	bgez	s11,8004a4 <vprintfmt+0x1b4>
  8004a2:	4781                	li	a5,0
  8004a4:	00078d9b          	sext.w	s11,a5
  8004a8:	8466                	mv	s0,s9
  8004aa:	b55d                	j	800350 <vprintfmt+0x60>
  8004ac:	0008041b          	sext.w	s0,a6
  8004b0:	fd340793          	addi	a5,s0,-45
  8004b4:	01b02733          	sgtz	a4,s11
  8004b8:	00f037b3          	snez	a5,a5
  8004bc:	8ff9                	and	a5,a5,a4
  8004be:	000ab703          	ld	a4,0(s5)
  8004c2:	008a8693          	addi	a3,s5,8
  8004c6:	e436                	sd	a3,8(sp)
  8004c8:	12070563          	beqz	a4,8005f2 <vprintfmt+0x302>
  8004cc:	12079d63          	bnez	a5,800606 <vprintfmt+0x316>
  8004d0:	00074783          	lbu	a5,0(a4)
  8004d4:	0007851b          	sext.w	a0,a5
  8004d8:	c78d                	beqz	a5,800502 <vprintfmt+0x212>
  8004da:	00170a93          	addi	s5,a4,1
  8004de:	547d                	li	s0,-1
  8004e0:	000d4563          	bltz	s10,8004ea <vprintfmt+0x1fa>
  8004e4:	3d7d                	addiw	s10,s10,-1
  8004e6:	008d0e63          	beq	s10,s0,800502 <vprintfmt+0x212>
  8004ea:	020c1863          	bnez	s8,80051a <vprintfmt+0x22a>
  8004ee:	864e                	mv	a2,s3
  8004f0:	85ca                	mv	a1,s2
  8004f2:	9482                	jalr	s1
  8004f4:	000ac783          	lbu	a5,0(s5)
  8004f8:	0a85                	addi	s5,s5,1
  8004fa:	3dfd                	addiw	s11,s11,-1
  8004fc:	0007851b          	sext.w	a0,a5
  800500:	f3e5                	bnez	a5,8004e0 <vprintfmt+0x1f0>
  800502:	01b05a63          	blez	s11,800516 <vprintfmt+0x226>
  800506:	864e                	mv	a2,s3
  800508:	85ca                	mv	a1,s2
  80050a:	02000513          	li	a0,32
  80050e:	3dfd                	addiw	s11,s11,-1
  800510:	9482                	jalr	s1
  800512:	fe0d9ae3          	bnez	s11,800506 <vprintfmt+0x216>
  800516:	6aa2                	ld	s5,8(sp)
  800518:	b539                	j	800326 <vprintfmt+0x36>
  80051a:	3781                	addiw	a5,a5,-32
  80051c:	05e00713          	li	a4,94
  800520:	fcf777e3          	bgeu	a4,a5,8004ee <vprintfmt+0x1fe>
  800524:	03f00513          	li	a0,63
  800528:	864e                	mv	a2,s3
  80052a:	85ca                	mv	a1,s2
  80052c:	9482                	jalr	s1
  80052e:	000ac783          	lbu	a5,0(s5)
  800532:	0a85                	addi	s5,s5,1
  800534:	3dfd                	addiw	s11,s11,-1
  800536:	0007851b          	sext.w	a0,a5
  80053a:	d7e1                	beqz	a5,800502 <vprintfmt+0x212>
  80053c:	fa0d54e3          	bgez	s10,8004e4 <vprintfmt+0x1f4>
  800540:	bfe9                	j	80051a <vprintfmt+0x22a>
  800542:	000aa783          	lw	a5,0(s5)
  800546:	46e1                	li	a3,24
  800548:	0aa1                	addi	s5,s5,8
  80054a:	41f7d71b          	sraiw	a4,a5,0x1f
  80054e:	8fb9                	xor	a5,a5,a4
  800550:	40e7873b          	subw	a4,a5,a4
  800554:	02e6c663          	blt	a3,a4,800580 <vprintfmt+0x290>
  800558:	00000797          	auipc	a5,0x0
  80055c:	77878793          	addi	a5,a5,1912 # 800cd0 <error_string>
  800560:	00371693          	slli	a3,a4,0x3
  800564:	97b6                	add	a5,a5,a3
  800566:	639c                	ld	a5,0(a5)
  800568:	cf81                	beqz	a5,800580 <vprintfmt+0x290>
  80056a:	873e                	mv	a4,a5
  80056c:	00000697          	auipc	a3,0x0
  800570:	36c68693          	addi	a3,a3,876 # 8008d8 <main+0x1aa>
  800574:	864a                	mv	a2,s2
  800576:	85ce                	mv	a1,s3
  800578:	8526                	mv	a0,s1
  80057a:	0f2000ef          	jal	80066c <printfmt>
  80057e:	b365                	j	800326 <vprintfmt+0x36>
  800580:	00000697          	auipc	a3,0x0
  800584:	34868693          	addi	a3,a3,840 # 8008c8 <main+0x19a>
  800588:	864a                	mv	a2,s2
  80058a:	85ce                	mv	a1,s3
  80058c:	8526                	mv	a0,s1
  80058e:	0de000ef          	jal	80066c <printfmt>
  800592:	bb51                	j	800326 <vprintfmt+0x36>
  800594:	4785                	li	a5,1
  800596:	008a8c13          	addi	s8,s5,8
  80059a:	00b7c363          	blt	a5,a1,8005a0 <vprintfmt+0x2b0>
  80059e:	cd81                	beqz	a1,8005b6 <vprintfmt+0x2c6>
  8005a0:	000ab403          	ld	s0,0(s5)
  8005a4:	02044b63          	bltz	s0,8005da <vprintfmt+0x2ea>
  8005a8:	86a2                	mv	a3,s0
  8005aa:	8ae2                	mv	s5,s8
  8005ac:	4729                	li	a4,10
  8005ae:	b5a5                	j	800416 <vprintfmt+0x126>
  8005b0:	2585                	addiw	a1,a1,1
  8005b2:	8466                	mv	s0,s9
  8005b4:	bb71                	j	800350 <vprintfmt+0x60>
  8005b6:	000aa403          	lw	s0,0(s5)
  8005ba:	b7ed                	j	8005a4 <vprintfmt+0x2b4>
  8005bc:	000ae683          	lwu	a3,0(s5)
  8005c0:	4721                	li	a4,8
  8005c2:	8ab2                	mv	s5,a2
  8005c4:	bd89                	j	800416 <vprintfmt+0x126>
  8005c6:	000ae683          	lwu	a3,0(s5)
  8005ca:	4729                	li	a4,10
  8005cc:	8ab2                	mv	s5,a2
  8005ce:	b5a1                	j	800416 <vprintfmt+0x126>
  8005d0:	000ae683          	lwu	a3,0(s5)
  8005d4:	4741                	li	a4,16
  8005d6:	8ab2                	mv	s5,a2
  8005d8:	bd3d                	j	800416 <vprintfmt+0x126>
  8005da:	864e                	mv	a2,s3
  8005dc:	85ca                	mv	a1,s2
  8005de:	02d00513          	li	a0,45
  8005e2:	e042                	sd	a6,0(sp)
  8005e4:	9482                	jalr	s1
  8005e6:	6802                	ld	a6,0(sp)
  8005e8:	408006b3          	neg	a3,s0
  8005ec:	8ae2                	mv	s5,s8
  8005ee:	4729                	li	a4,10
  8005f0:	b51d                	j	800416 <vprintfmt+0x126>
  8005f2:	eba1                	bnez	a5,800642 <vprintfmt+0x352>
  8005f4:	02800793          	li	a5,40
  8005f8:	853e                	mv	a0,a5
  8005fa:	00000a97          	auipc	s5,0x0
  8005fe:	2c7a8a93          	addi	s5,s5,711 # 8008c1 <main+0x193>
  800602:	547d                	li	s0,-1
  800604:	bdf1                	j	8004e0 <vprintfmt+0x1f0>
  800606:	853a                	mv	a0,a4
  800608:	85ea                	mv	a1,s10
  80060a:	e03a                	sd	a4,0(sp)
  80060c:	07e000ef          	jal	80068a <strnlen>
  800610:	40ad8dbb          	subw	s11,s11,a0
  800614:	6702                	ld	a4,0(sp)
  800616:	01b05b63          	blez	s11,80062c <vprintfmt+0x33c>
  80061a:	864e                	mv	a2,s3
  80061c:	85ca                	mv	a1,s2
  80061e:	8522                	mv	a0,s0
  800620:	e03a                	sd	a4,0(sp)
  800622:	3dfd                	addiw	s11,s11,-1
  800624:	9482                	jalr	s1
  800626:	6702                	ld	a4,0(sp)
  800628:	fe0d99e3          	bnez	s11,80061a <vprintfmt+0x32a>
  80062c:	00074783          	lbu	a5,0(a4)
  800630:	0007851b          	sext.w	a0,a5
  800634:	ee0781e3          	beqz	a5,800516 <vprintfmt+0x226>
  800638:	00170a93          	addi	s5,a4,1
  80063c:	b54d                	j	8004de <vprintfmt+0x1ee>
  80063e:	8466                	mv	s0,s9
  800640:	b36d                	j	8003ea <vprintfmt+0xfa>
  800642:	85ea                	mv	a1,s10
  800644:	00000517          	auipc	a0,0x0
  800648:	27c50513          	addi	a0,a0,636 # 8008c0 <main+0x192>
  80064c:	03e000ef          	jal	80068a <strnlen>
  800650:	40ad8dbb          	subw	s11,s11,a0
  800654:	02800793          	li	a5,40
  800658:	00000717          	auipc	a4,0x0
  80065c:	26870713          	addi	a4,a4,616 # 8008c0 <main+0x192>
  800660:	853e                	mv	a0,a5
  800662:	fbb04ce3          	bgtz	s11,80061a <vprintfmt+0x32a>
  800666:	00170a93          	addi	s5,a4,1
  80066a:	bd95                	j	8004de <vprintfmt+0x1ee>

000000000080066c <printfmt>:
  80066c:	7139                	addi	sp,sp,-64
  80066e:	02010313          	addi	t1,sp,32
  800672:	f03a                	sd	a4,32(sp)
  800674:	871a                	mv	a4,t1
  800676:	ec06                	sd	ra,24(sp)
  800678:	f43e                	sd	a5,40(sp)
  80067a:	f842                	sd	a6,48(sp)
  80067c:	fc46                	sd	a7,56(sp)
  80067e:	e41a                	sd	t1,8(sp)
  800680:	c71ff0ef          	jal	8002f0 <vprintfmt>
  800684:	60e2                	ld	ra,24(sp)
  800686:	6121                	addi	sp,sp,64
  800688:	8082                	ret

000000000080068a <strnlen>:
  80068a:	4781                	li	a5,0
  80068c:	e589                	bnez	a1,800696 <strnlen+0xc>
  80068e:	a811                	j	8006a2 <strnlen+0x18>
  800690:	0785                	addi	a5,a5,1
  800692:	00f58863          	beq	a1,a5,8006a2 <strnlen+0x18>
  800696:	00f50733          	add	a4,a0,a5
  80069a:	00074703          	lbu	a4,0(a4)
  80069e:	fb6d                	bnez	a4,800690 <strnlen+0x6>
  8006a0:	85be                	mv	a1,a5
  8006a2:	852e                	mv	a0,a1
  8006a4:	8082                	ret

00000000008006a6 <do_yield>:
  8006a6:	1141                	addi	sp,sp,-16
  8006a8:	e406                	sd	ra,8(sp)
  8006aa:	b1bff0ef          	jal	8001c4 <yield>
  8006ae:	b17ff0ef          	jal	8001c4 <yield>
  8006b2:	b13ff0ef          	jal	8001c4 <yield>
  8006b6:	b0fff0ef          	jal	8001c4 <yield>
  8006ba:	b0bff0ef          	jal	8001c4 <yield>
  8006be:	60a2                	ld	ra,8(sp)
  8006c0:	0141                	addi	sp,sp,16
  8006c2:	b609                	j	8001c4 <yield>

00000000008006c4 <loop>:
  8006c4:	1141                	addi	sp,sp,-16
  8006c6:	00000517          	auipc	a0,0x0
  8006ca:	3f250513          	addi	a0,a0,1010 # 800ab8 <main+0x38a>
  8006ce:	e406                	sd	ra,8(sp)
  8006d0:	a25ff0ef          	jal	8000f4 <cprintf>
  8006d4:	a001                	j	8006d4 <loop+0x10>

00000000008006d6 <work>:
  8006d6:	1141                	addi	sp,sp,-16
  8006d8:	00000517          	auipc	a0,0x0
  8006dc:	3f050513          	addi	a0,a0,1008 # 800ac8 <main+0x39a>
  8006e0:	e406                	sd	ra,8(sp)
  8006e2:	a13ff0ef          	jal	8000f4 <cprintf>
  8006e6:	fc1ff0ef          	jal	8006a6 <do_yield>
  8006ea:	00001517          	auipc	a0,0x1
  8006ee:	91e52503          	lw	a0,-1762(a0) # 801008 <parent>
  8006f2:	ad5ff0ef          	jal	8001c6 <kill>
  8006f6:	e105                	bnez	a0,800716 <work+0x40>
  8006f8:	00000517          	auipc	a0,0x0
  8006fc:	3e050513          	addi	a0,a0,992 # 800ad8 <main+0x3aa>
  800700:	9f5ff0ef          	jal	8000f4 <cprintf>
  800704:	fa3ff0ef          	jal	8006a6 <do_yield>
  800708:	00001517          	auipc	a0,0x1
  80070c:	8fc52503          	lw	a0,-1796(a0) # 801004 <pid1>
  800710:	ab7ff0ef          	jal	8001c6 <kill>
  800714:	c501                	beqz	a0,80071c <work+0x46>
  800716:	557d                	li	a0,-1
  800718:	a93ff0ef          	jal	8001aa <exit>
  80071c:	00000517          	auipc	a0,0x0
  800720:	3d450513          	addi	a0,a0,980 # 800af0 <main+0x3c2>
  800724:	9d1ff0ef          	jal	8000f4 <cprintf>
  800728:	4501                	li	a0,0
  80072a:	a81ff0ef          	jal	8001aa <exit>

000000000080072e <main>:
  80072e:	1141                	addi	sp,sp,-16
  800730:	e406                	sd	ra,8(sp)
  800732:	a97ff0ef          	jal	8001c8 <getpid>
  800736:	00001797          	auipc	a5,0x1
  80073a:	8ca7a923          	sw	a0,-1838(a5) # 801008 <parent>
  80073e:	a83ff0ef          	jal	8001c0 <fork>
  800742:	00001797          	auipc	a5,0x1
  800746:	8ca7a123          	sw	a0,-1854(a5) # 801004 <pid1>
  80074a:	c92d                	beqz	a0,8007bc <main+0x8e>
  80074c:	04a05863          	blez	a0,80079c <main+0x6e>
  800750:	a71ff0ef          	jal	8001c0 <fork>
  800754:	00001797          	auipc	a5,0x1
  800758:	8aa7a623          	sw	a0,-1876(a5) # 801000 <pid2>
  80075c:	c541                	beqz	a0,8007e4 <main+0xb6>
  80075e:	06a05163          	blez	a0,8007c0 <main+0x92>
  800762:	00000517          	auipc	a0,0x0
  800766:	3de50513          	addi	a0,a0,990 # 800b40 <main+0x412>
  80076a:	98bff0ef          	jal	8000f4 <cprintf>
  80076e:	00001517          	auipc	a0,0x1
  800772:	89652503          	lw	a0,-1898(a0) # 801004 <pid1>
  800776:	4581                	li	a1,0
  800778:	a4bff0ef          	jal	8001c2 <waitpid>
  80077c:	00001697          	auipc	a3,0x1
  800780:	8886a683          	lw	a3,-1912(a3) # 801004 <pid1>
  800784:	00000617          	auipc	a2,0x0
  800788:	3cc60613          	addi	a2,a2,972 # 800b50 <main+0x422>
  80078c:	03400593          	li	a1,52
  800790:	00000517          	auipc	a0,0x0
  800794:	3a050513          	addi	a0,a0,928 # 800b30 <main+0x402>
  800798:	899ff0ef          	jal	800030 <__panic>
  80079c:	00000697          	auipc	a3,0x0
  8007a0:	36c68693          	addi	a3,a3,876 # 800b08 <main+0x3da>
  8007a4:	00000617          	auipc	a2,0x0
  8007a8:	37460613          	addi	a2,a2,884 # 800b18 <main+0x3ea>
  8007ac:	02c00593          	li	a1,44
  8007b0:	00000517          	auipc	a0,0x0
  8007b4:	38050513          	addi	a0,a0,896 # 800b30 <main+0x402>
  8007b8:	879ff0ef          	jal	800030 <__panic>
  8007bc:	f09ff0ef          	jal	8006c4 <loop>
  8007c0:	00001517          	auipc	a0,0x1
  8007c4:	84452503          	lw	a0,-1980(a0) # 801004 <pid1>
  8007c8:	9ffff0ef          	jal	8001c6 <kill>
  8007cc:	00000617          	auipc	a2,0x0
  8007d0:	39c60613          	addi	a2,a2,924 # 800b68 <main+0x43a>
  8007d4:	03900593          	li	a1,57
  8007d8:	00000517          	auipc	a0,0x0
  8007dc:	35850513          	addi	a0,a0,856 # 800b30 <main+0x402>
  8007e0:	851ff0ef          	jal	800030 <__panic>
  8007e4:	ef3ff0ef          	jal	8006d6 <work>
