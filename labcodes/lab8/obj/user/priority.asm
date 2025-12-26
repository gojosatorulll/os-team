
obj/__user_priority.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa8d                	j	800196 <sys_open>

0000000000800026 <close>:
  800026:	aaad                	j	8001a0 <sys_close>

0000000000800028 <dup2>:
  800028:	a241                	j	8001a8 <sys_dup>

000000000080002a <_start>:
  80002a:	1f0000ef          	jal	80021a <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00001517          	auipc	a0,0x1
  800042:	83a50513          	addi	a0,a0,-1990 # 800878 <main+0x1b2>
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
  800064:	83850513          	addi	a0,a0,-1992 # 800898 <main+0x1d2>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	144000ef          	jal	8001b2 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00001517          	auipc	a0,0x1
  800084:	82050513          	addi	a0,a0,-2016 # 8008a0 <main+0x1da>
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
  8000a6:	7f650513          	addi	a0,a0,2038 # 800898 <main+0x1d2>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <acc+0xffffffffff7f5aa9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	216000ef          	jal	8002fe <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <acc+0xffffffffff7f5aa9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1dc000ef          	jal	8002fe <vprintfmt>
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

000000000080017a <sys_kill>:
  80017a:	85aa                	mv	a1,a0
  80017c:	4531                	li	a0,12
  80017e:	bf45                	j	80012e <syscall>

0000000000800180 <sys_getpid>:
  800180:	4549                	li	a0,18
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_putc>:
  800184:	85aa                	mv	a1,a0
  800186:	4579                	li	a0,30
  800188:	b75d                	j	80012e <syscall>

000000000080018a <sys_lab6_set_priority>:
  80018a:	85aa                	mv	a1,a0
  80018c:	0ff00513          	li	a0,255
  800190:	bf79                	j	80012e <syscall>

0000000000800192 <sys_gettime>:
  800192:	4545                	li	a0,17
  800194:	bf69                	j	80012e <syscall>

0000000000800196 <sys_open>:
  800196:	862e                	mv	a2,a1
  800198:	85aa                	mv	a1,a0
  80019a:	06400513          	li	a0,100
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <sys_close>:
  8001a0:	85aa                	mv	a1,a0
  8001a2:	06500513          	li	a0,101
  8001a6:	b761                	j	80012e <syscall>

00000000008001a8 <sys_dup>:
  8001a8:	862e                	mv	a2,a1
  8001aa:	85aa                	mv	a1,a0
  8001ac:	08200513          	li	a0,130
  8001b0:	bfbd                	j	80012e <syscall>

00000000008001b2 <exit>:
  8001b2:	1141                	addi	sp,sp,-16
  8001b4:	e406                	sd	ra,8(sp)
  8001b6:	fb3ff0ef          	jal	800168 <sys_exit>
  8001ba:	00000517          	auipc	a0,0x0
  8001be:	70650513          	addi	a0,a0,1798 # 8008c0 <main+0x1fa>
  8001c2:	f33ff0ef          	jal	8000f4 <cprintf>
  8001c6:	a001                	j	8001c6 <exit+0x14>

00000000008001c8 <fork>:
  8001c8:	b75d                	j	80016e <sys_fork>

00000000008001ca <waitpid>:
  8001ca:	b765                	j	800172 <sys_wait>

00000000008001cc <kill>:
  8001cc:	b77d                	j	80017a <sys_kill>

00000000008001ce <getpid>:
  8001ce:	bf4d                	j	800180 <sys_getpid>

00000000008001d0 <gettime_msec>:
  8001d0:	b7c9                	j	800192 <sys_gettime>

00000000008001d2 <lab6_set_priority>:
  8001d2:	1502                	slli	a0,a0,0x20
  8001d4:	9101                	srli	a0,a0,0x20
  8001d6:	bf55                	j	80018a <sys_lab6_set_priority>

00000000008001d8 <initfd>:
  8001d8:	87ae                	mv	a5,a1
  8001da:	1101                	addi	sp,sp,-32
  8001dc:	e822                	sd	s0,16(sp)
  8001de:	85b2                	mv	a1,a2
  8001e0:	842a                	mv	s0,a0
  8001e2:	853e                	mv	a0,a5
  8001e4:	ec06                	sd	ra,24(sp)
  8001e6:	e3bff0ef          	jal	800020 <open>
  8001ea:	87aa                	mv	a5,a0
  8001ec:	00054463          	bltz	a0,8001f4 <initfd+0x1c>
  8001f0:	00851763          	bne	a0,s0,8001fe <initfd+0x26>
  8001f4:	60e2                	ld	ra,24(sp)
  8001f6:	6442                	ld	s0,16(sp)
  8001f8:	853e                	mv	a0,a5
  8001fa:	6105                	addi	sp,sp,32
  8001fc:	8082                	ret
  8001fe:	e42a                	sd	a0,8(sp)
  800200:	8522                	mv	a0,s0
  800202:	e25ff0ef          	jal	800026 <close>
  800206:	6522                	ld	a0,8(sp)
  800208:	85a2                	mv	a1,s0
  80020a:	e1fff0ef          	jal	800028 <dup2>
  80020e:	842a                	mv	s0,a0
  800210:	6522                	ld	a0,8(sp)
  800212:	e15ff0ef          	jal	800026 <close>
  800216:	87a2                	mv	a5,s0
  800218:	bff1                	j	8001f4 <initfd+0x1c>

000000000080021a <umain>:
  80021a:	1101                	addi	sp,sp,-32
  80021c:	e822                	sd	s0,16(sp)
  80021e:	e426                	sd	s1,8(sp)
  800220:	842a                	mv	s0,a0
  800222:	84ae                	mv	s1,a1
  800224:	4601                	li	a2,0
  800226:	00000597          	auipc	a1,0x0
  80022a:	6b258593          	addi	a1,a1,1714 # 8008d8 <main+0x212>
  80022e:	4501                	li	a0,0
  800230:	ec06                	sd	ra,24(sp)
  800232:	fa7ff0ef          	jal	8001d8 <initfd>
  800236:	02054263          	bltz	a0,80025a <umain+0x40>
  80023a:	4605                	li	a2,1
  80023c:	8532                	mv	a0,a2
  80023e:	00000597          	auipc	a1,0x0
  800242:	6da58593          	addi	a1,a1,1754 # 800918 <main+0x252>
  800246:	f93ff0ef          	jal	8001d8 <initfd>
  80024a:	02054563          	bltz	a0,800274 <umain+0x5a>
  80024e:	85a6                	mv	a1,s1
  800250:	8522                	mv	a0,s0
  800252:	474000ef          	jal	8006c6 <main>
  800256:	f5dff0ef          	jal	8001b2 <exit>
  80025a:	86aa                	mv	a3,a0
  80025c:	00000617          	auipc	a2,0x0
  800260:	68460613          	addi	a2,a2,1668 # 8008e0 <main+0x21a>
  800264:	45e9                	li	a1,26
  800266:	00000517          	auipc	a0,0x0
  80026a:	69a50513          	addi	a0,a0,1690 # 800900 <main+0x23a>
  80026e:	e05ff0ef          	jal	800072 <__warn>
  800272:	b7e1                	j	80023a <umain+0x20>
  800274:	86aa                	mv	a3,a0
  800276:	00000617          	auipc	a2,0x0
  80027a:	6aa60613          	addi	a2,a2,1706 # 800920 <main+0x25a>
  80027e:	45f5                	li	a1,29
  800280:	00000517          	auipc	a0,0x0
  800284:	68050513          	addi	a0,a0,1664 # 800900 <main+0x23a>
  800288:	debff0ef          	jal	800072 <__warn>
  80028c:	b7c9                	j	80024e <umain+0x34>

000000000080028e <printnum>:
  80028e:	7139                	addi	sp,sp,-64
  800290:	02071893          	slli	a7,a4,0x20
  800294:	f822                	sd	s0,48(sp)
  800296:	f426                	sd	s1,40(sp)
  800298:	f04a                	sd	s2,32(sp)
  80029a:	ec4e                	sd	s3,24(sp)
  80029c:	e456                	sd	s5,8(sp)
  80029e:	0208d893          	srli	a7,a7,0x20
  8002a2:	fc06                	sd	ra,56(sp)
  8002a4:	0316fab3          	remu	s5,a3,a7
  8002a8:	fff7841b          	addiw	s0,a5,-1
  8002ac:	84aa                	mv	s1,a0
  8002ae:	89ae                	mv	s3,a1
  8002b0:	8932                	mv	s2,a2
  8002b2:	0516f063          	bgeu	a3,a7,8002f2 <printnum+0x64>
  8002b6:	e852                	sd	s4,16(sp)
  8002b8:	4705                	li	a4,1
  8002ba:	8a42                	mv	s4,a6
  8002bc:	00f75863          	bge	a4,a5,8002cc <printnum+0x3e>
  8002c0:	864e                	mv	a2,s3
  8002c2:	85ca                	mv	a1,s2
  8002c4:	8552                	mv	a0,s4
  8002c6:	347d                	addiw	s0,s0,-1
  8002c8:	9482                	jalr	s1
  8002ca:	f87d                	bnez	s0,8002c0 <printnum+0x32>
  8002cc:	6a42                	ld	s4,16(sp)
  8002ce:	00000797          	auipc	a5,0x0
  8002d2:	67278793          	addi	a5,a5,1650 # 800940 <main+0x27a>
  8002d6:	97d6                	add	a5,a5,s5
  8002d8:	7442                	ld	s0,48(sp)
  8002da:	0007c503          	lbu	a0,0(a5)
  8002de:	70e2                	ld	ra,56(sp)
  8002e0:	6aa2                	ld	s5,8(sp)
  8002e2:	864e                	mv	a2,s3
  8002e4:	85ca                	mv	a1,s2
  8002e6:	69e2                	ld	s3,24(sp)
  8002e8:	7902                	ld	s2,32(sp)
  8002ea:	87a6                	mv	a5,s1
  8002ec:	74a2                	ld	s1,40(sp)
  8002ee:	6121                	addi	sp,sp,64
  8002f0:	8782                	jr	a5
  8002f2:	0316d6b3          	divu	a3,a3,a7
  8002f6:	87a2                	mv	a5,s0
  8002f8:	f97ff0ef          	jal	80028e <printnum>
  8002fc:	bfc9                	j	8002ce <printnum+0x40>

00000000008002fe <vprintfmt>:
  8002fe:	7119                	addi	sp,sp,-128
  800300:	f4a6                	sd	s1,104(sp)
  800302:	f0ca                	sd	s2,96(sp)
  800304:	ecce                	sd	s3,88(sp)
  800306:	e8d2                	sd	s4,80(sp)
  800308:	e4d6                	sd	s5,72(sp)
  80030a:	e0da                	sd	s6,64(sp)
  80030c:	fc5e                	sd	s7,56(sp)
  80030e:	f466                	sd	s9,40(sp)
  800310:	fc86                	sd	ra,120(sp)
  800312:	f8a2                	sd	s0,112(sp)
  800314:	f862                	sd	s8,48(sp)
  800316:	f06a                	sd	s10,32(sp)
  800318:	ec6e                	sd	s11,24(sp)
  80031a:	84aa                	mv	s1,a0
  80031c:	8cb6                	mv	s9,a3
  80031e:	8aba                	mv	s5,a4
  800320:	89ae                	mv	s3,a1
  800322:	8932                	mv	s2,a2
  800324:	02500a13          	li	s4,37
  800328:	05500b93          	li	s7,85
  80032c:	00001b17          	auipc	s6,0x1
  800330:	8ecb0b13          	addi	s6,s6,-1812 # 800c18 <main+0x552>
  800334:	000cc503          	lbu	a0,0(s9)
  800338:	001c8413          	addi	s0,s9,1
  80033c:	01450b63          	beq	a0,s4,800352 <vprintfmt+0x54>
  800340:	cd15                	beqz	a0,80037c <vprintfmt+0x7e>
  800342:	864e                	mv	a2,s3
  800344:	85ca                	mv	a1,s2
  800346:	9482                	jalr	s1
  800348:	00044503          	lbu	a0,0(s0)
  80034c:	0405                	addi	s0,s0,1
  80034e:	ff4519e3          	bne	a0,s4,800340 <vprintfmt+0x42>
  800352:	5d7d                	li	s10,-1
  800354:	8dea                	mv	s11,s10
  800356:	02000813          	li	a6,32
  80035a:	4c01                	li	s8,0
  80035c:	4581                	li	a1,0
  80035e:	00044703          	lbu	a4,0(s0)
  800362:	00140c93          	addi	s9,s0,1
  800366:	fdd7061b          	addiw	a2,a4,-35
  80036a:	0ff67613          	zext.b	a2,a2
  80036e:	02cbe663          	bltu	s7,a2,80039a <vprintfmt+0x9c>
  800372:	060a                	slli	a2,a2,0x2
  800374:	965a                	add	a2,a2,s6
  800376:	421c                	lw	a5,0(a2)
  800378:	97da                	add	a5,a5,s6
  80037a:	8782                	jr	a5
  80037c:	70e6                	ld	ra,120(sp)
  80037e:	7446                	ld	s0,112(sp)
  800380:	74a6                	ld	s1,104(sp)
  800382:	7906                	ld	s2,96(sp)
  800384:	69e6                	ld	s3,88(sp)
  800386:	6a46                	ld	s4,80(sp)
  800388:	6aa6                	ld	s5,72(sp)
  80038a:	6b06                	ld	s6,64(sp)
  80038c:	7be2                	ld	s7,56(sp)
  80038e:	7c42                	ld	s8,48(sp)
  800390:	7ca2                	ld	s9,40(sp)
  800392:	7d02                	ld	s10,32(sp)
  800394:	6de2                	ld	s11,24(sp)
  800396:	6109                	addi	sp,sp,128
  800398:	8082                	ret
  80039a:	864e                	mv	a2,s3
  80039c:	85ca                	mv	a1,s2
  80039e:	02500513          	li	a0,37
  8003a2:	9482                	jalr	s1
  8003a4:	fff44783          	lbu	a5,-1(s0)
  8003a8:	02500713          	li	a4,37
  8003ac:	8ca2                	mv	s9,s0
  8003ae:	f8e783e3          	beq	a5,a4,800334 <vprintfmt+0x36>
  8003b2:	ffecc783          	lbu	a5,-2(s9)
  8003b6:	1cfd                	addi	s9,s9,-1
  8003b8:	fee79de3          	bne	a5,a4,8003b2 <vprintfmt+0xb4>
  8003bc:	bfa5                	j	800334 <vprintfmt+0x36>
  8003be:	00144683          	lbu	a3,1(s0)
  8003c2:	4525                	li	a0,9
  8003c4:	fd070d1b          	addiw	s10,a4,-48
  8003c8:	fd06879b          	addiw	a5,a3,-48
  8003cc:	28f56063          	bltu	a0,a5,80064c <vprintfmt+0x34e>
  8003d0:	2681                	sext.w	a3,a3
  8003d2:	8466                	mv	s0,s9
  8003d4:	002d179b          	slliw	a5,s10,0x2
  8003d8:	00144703          	lbu	a4,1(s0)
  8003dc:	01a787bb          	addw	a5,a5,s10
  8003e0:	0017979b          	slliw	a5,a5,0x1
  8003e4:	9fb5                	addw	a5,a5,a3
  8003e6:	fd07061b          	addiw	a2,a4,-48
  8003ea:	0405                	addi	s0,s0,1
  8003ec:	fd078d1b          	addiw	s10,a5,-48
  8003f0:	0007069b          	sext.w	a3,a4
  8003f4:	fec570e3          	bgeu	a0,a2,8003d4 <vprintfmt+0xd6>
  8003f8:	f60dd3e3          	bgez	s11,80035e <vprintfmt+0x60>
  8003fc:	8dea                	mv	s11,s10
  8003fe:	5d7d                	li	s10,-1
  800400:	bfb9                	j	80035e <vprintfmt+0x60>
  800402:	883a                	mv	a6,a4
  800404:	8466                	mv	s0,s9
  800406:	bfa1                	j	80035e <vprintfmt+0x60>
  800408:	8466                	mv	s0,s9
  80040a:	4c05                	li	s8,1
  80040c:	bf89                	j	80035e <vprintfmt+0x60>
  80040e:	4785                	li	a5,1
  800410:	008a8613          	addi	a2,s5,8
  800414:	00b7c463          	blt	a5,a1,80041c <vprintfmt+0x11e>
  800418:	1c058363          	beqz	a1,8005de <vprintfmt+0x2e0>
  80041c:	000ab683          	ld	a3,0(s5)
  800420:	4741                	li	a4,16
  800422:	8ab2                	mv	s5,a2
  800424:	2801                	sext.w	a6,a6
  800426:	87ee                	mv	a5,s11
  800428:	864a                	mv	a2,s2
  80042a:	85ce                	mv	a1,s3
  80042c:	8526                	mv	a0,s1
  80042e:	e61ff0ef          	jal	80028e <printnum>
  800432:	b709                	j	800334 <vprintfmt+0x36>
  800434:	000aa503          	lw	a0,0(s5)
  800438:	864e                	mv	a2,s3
  80043a:	85ca                	mv	a1,s2
  80043c:	9482                	jalr	s1
  80043e:	0aa1                	addi	s5,s5,8
  800440:	bdd5                	j	800334 <vprintfmt+0x36>
  800442:	4785                	li	a5,1
  800444:	008a8613          	addi	a2,s5,8
  800448:	00b7c463          	blt	a5,a1,800450 <vprintfmt+0x152>
  80044c:	18058463          	beqz	a1,8005d4 <vprintfmt+0x2d6>
  800450:	000ab683          	ld	a3,0(s5)
  800454:	4729                	li	a4,10
  800456:	8ab2                	mv	s5,a2
  800458:	b7f1                	j	800424 <vprintfmt+0x126>
  80045a:	864e                	mv	a2,s3
  80045c:	85ca                	mv	a1,s2
  80045e:	03000513          	li	a0,48
  800462:	e042                	sd	a6,0(sp)
  800464:	9482                	jalr	s1
  800466:	864e                	mv	a2,s3
  800468:	85ca                	mv	a1,s2
  80046a:	07800513          	li	a0,120
  80046e:	9482                	jalr	s1
  800470:	000ab683          	ld	a3,0(s5)
  800474:	6802                	ld	a6,0(sp)
  800476:	4741                	li	a4,16
  800478:	0aa1                	addi	s5,s5,8
  80047a:	b76d                	j	800424 <vprintfmt+0x126>
  80047c:	864e                	mv	a2,s3
  80047e:	85ca                	mv	a1,s2
  800480:	02500513          	li	a0,37
  800484:	9482                	jalr	s1
  800486:	b57d                	j	800334 <vprintfmt+0x36>
  800488:	000aad03          	lw	s10,0(s5)
  80048c:	8466                	mv	s0,s9
  80048e:	0aa1                	addi	s5,s5,8
  800490:	b7a5                	j	8003f8 <vprintfmt+0xfa>
  800492:	4785                	li	a5,1
  800494:	008a8613          	addi	a2,s5,8
  800498:	00b7c463          	blt	a5,a1,8004a0 <vprintfmt+0x1a2>
  80049c:	12058763          	beqz	a1,8005ca <vprintfmt+0x2cc>
  8004a0:	000ab683          	ld	a3,0(s5)
  8004a4:	4721                	li	a4,8
  8004a6:	8ab2                	mv	s5,a2
  8004a8:	bfb5                	j	800424 <vprintfmt+0x126>
  8004aa:	87ee                	mv	a5,s11
  8004ac:	000dd363          	bgez	s11,8004b2 <vprintfmt+0x1b4>
  8004b0:	4781                	li	a5,0
  8004b2:	00078d9b          	sext.w	s11,a5
  8004b6:	8466                	mv	s0,s9
  8004b8:	b55d                	j	80035e <vprintfmt+0x60>
  8004ba:	0008041b          	sext.w	s0,a6
  8004be:	fd340793          	addi	a5,s0,-45
  8004c2:	01b02733          	sgtz	a4,s11
  8004c6:	00f037b3          	snez	a5,a5
  8004ca:	8ff9                	and	a5,a5,a4
  8004cc:	000ab703          	ld	a4,0(s5)
  8004d0:	008a8693          	addi	a3,s5,8
  8004d4:	e436                	sd	a3,8(sp)
  8004d6:	12070563          	beqz	a4,800600 <vprintfmt+0x302>
  8004da:	12079d63          	bnez	a5,800614 <vprintfmt+0x316>
  8004de:	00074783          	lbu	a5,0(a4)
  8004e2:	0007851b          	sext.w	a0,a5
  8004e6:	c78d                	beqz	a5,800510 <vprintfmt+0x212>
  8004e8:	00170a93          	addi	s5,a4,1
  8004ec:	547d                	li	s0,-1
  8004ee:	000d4563          	bltz	s10,8004f8 <vprintfmt+0x1fa>
  8004f2:	3d7d                	addiw	s10,s10,-1
  8004f4:	008d0e63          	beq	s10,s0,800510 <vprintfmt+0x212>
  8004f8:	020c1863          	bnez	s8,800528 <vprintfmt+0x22a>
  8004fc:	864e                	mv	a2,s3
  8004fe:	85ca                	mv	a1,s2
  800500:	9482                	jalr	s1
  800502:	000ac783          	lbu	a5,0(s5)
  800506:	0a85                	addi	s5,s5,1
  800508:	3dfd                	addiw	s11,s11,-1
  80050a:	0007851b          	sext.w	a0,a5
  80050e:	f3e5                	bnez	a5,8004ee <vprintfmt+0x1f0>
  800510:	01b05a63          	blez	s11,800524 <vprintfmt+0x226>
  800514:	864e                	mv	a2,s3
  800516:	85ca                	mv	a1,s2
  800518:	02000513          	li	a0,32
  80051c:	3dfd                	addiw	s11,s11,-1
  80051e:	9482                	jalr	s1
  800520:	fe0d9ae3          	bnez	s11,800514 <vprintfmt+0x216>
  800524:	6aa2                	ld	s5,8(sp)
  800526:	b539                	j	800334 <vprintfmt+0x36>
  800528:	3781                	addiw	a5,a5,-32
  80052a:	05e00713          	li	a4,94
  80052e:	fcf777e3          	bgeu	a4,a5,8004fc <vprintfmt+0x1fe>
  800532:	03f00513          	li	a0,63
  800536:	864e                	mv	a2,s3
  800538:	85ca                	mv	a1,s2
  80053a:	9482                	jalr	s1
  80053c:	000ac783          	lbu	a5,0(s5)
  800540:	0a85                	addi	s5,s5,1
  800542:	3dfd                	addiw	s11,s11,-1
  800544:	0007851b          	sext.w	a0,a5
  800548:	d7e1                	beqz	a5,800510 <vprintfmt+0x212>
  80054a:	fa0d54e3          	bgez	s10,8004f2 <vprintfmt+0x1f4>
  80054e:	bfe9                	j	800528 <vprintfmt+0x22a>
  800550:	000aa783          	lw	a5,0(s5)
  800554:	46e1                	li	a3,24
  800556:	0aa1                	addi	s5,s5,8
  800558:	41f7d71b          	sraiw	a4,a5,0x1f
  80055c:	8fb9                	xor	a5,a5,a4
  80055e:	40e7873b          	subw	a4,a5,a4
  800562:	02e6c663          	blt	a3,a4,80058e <vprintfmt+0x290>
  800566:	00001797          	auipc	a5,0x1
  80056a:	80a78793          	addi	a5,a5,-2038 # 800d70 <error_string>
  80056e:	00371693          	slli	a3,a4,0x3
  800572:	97b6                	add	a5,a5,a3
  800574:	639c                	ld	a5,0(a5)
  800576:	cf81                	beqz	a5,80058e <vprintfmt+0x290>
  800578:	873e                	mv	a4,a5
  80057a:	00000697          	auipc	a3,0x0
  80057e:	3f668693          	addi	a3,a3,1014 # 800970 <main+0x2aa>
  800582:	864a                	mv	a2,s2
  800584:	85ce                	mv	a1,s3
  800586:	8526                	mv	a0,s1
  800588:	0f2000ef          	jal	80067a <printfmt>
  80058c:	b365                	j	800334 <vprintfmt+0x36>
  80058e:	00000697          	auipc	a3,0x0
  800592:	3d268693          	addi	a3,a3,978 # 800960 <main+0x29a>
  800596:	864a                	mv	a2,s2
  800598:	85ce                	mv	a1,s3
  80059a:	8526                	mv	a0,s1
  80059c:	0de000ef          	jal	80067a <printfmt>
  8005a0:	bb51                	j	800334 <vprintfmt+0x36>
  8005a2:	4785                	li	a5,1
  8005a4:	008a8c13          	addi	s8,s5,8
  8005a8:	00b7c363          	blt	a5,a1,8005ae <vprintfmt+0x2b0>
  8005ac:	cd81                	beqz	a1,8005c4 <vprintfmt+0x2c6>
  8005ae:	000ab403          	ld	s0,0(s5)
  8005b2:	02044b63          	bltz	s0,8005e8 <vprintfmt+0x2ea>
  8005b6:	86a2                	mv	a3,s0
  8005b8:	8ae2                	mv	s5,s8
  8005ba:	4729                	li	a4,10
  8005bc:	b5a5                	j	800424 <vprintfmt+0x126>
  8005be:	2585                	addiw	a1,a1,1
  8005c0:	8466                	mv	s0,s9
  8005c2:	bb71                	j	80035e <vprintfmt+0x60>
  8005c4:	000aa403          	lw	s0,0(s5)
  8005c8:	b7ed                	j	8005b2 <vprintfmt+0x2b4>
  8005ca:	000ae683          	lwu	a3,0(s5)
  8005ce:	4721                	li	a4,8
  8005d0:	8ab2                	mv	s5,a2
  8005d2:	bd89                	j	800424 <vprintfmt+0x126>
  8005d4:	000ae683          	lwu	a3,0(s5)
  8005d8:	4729                	li	a4,10
  8005da:	8ab2                	mv	s5,a2
  8005dc:	b5a1                	j	800424 <vprintfmt+0x126>
  8005de:	000ae683          	lwu	a3,0(s5)
  8005e2:	4741                	li	a4,16
  8005e4:	8ab2                	mv	s5,a2
  8005e6:	bd3d                	j	800424 <vprintfmt+0x126>
  8005e8:	864e                	mv	a2,s3
  8005ea:	85ca                	mv	a1,s2
  8005ec:	02d00513          	li	a0,45
  8005f0:	e042                	sd	a6,0(sp)
  8005f2:	9482                	jalr	s1
  8005f4:	6802                	ld	a6,0(sp)
  8005f6:	408006b3          	neg	a3,s0
  8005fa:	8ae2                	mv	s5,s8
  8005fc:	4729                	li	a4,10
  8005fe:	b51d                	j	800424 <vprintfmt+0x126>
  800600:	eba1                	bnez	a5,800650 <vprintfmt+0x352>
  800602:	02800793          	li	a5,40
  800606:	853e                	mv	a0,a5
  800608:	00000a97          	auipc	s5,0x0
  80060c:	351a8a93          	addi	s5,s5,849 # 800959 <main+0x293>
  800610:	547d                	li	s0,-1
  800612:	bdf1                	j	8004ee <vprintfmt+0x1f0>
  800614:	853a                	mv	a0,a4
  800616:	85ea                	mv	a1,s10
  800618:	e03a                	sd	a4,0(sp)
  80061a:	07e000ef          	jal	800698 <strnlen>
  80061e:	40ad8dbb          	subw	s11,s11,a0
  800622:	6702                	ld	a4,0(sp)
  800624:	01b05b63          	blez	s11,80063a <vprintfmt+0x33c>
  800628:	864e                	mv	a2,s3
  80062a:	85ca                	mv	a1,s2
  80062c:	8522                	mv	a0,s0
  80062e:	e03a                	sd	a4,0(sp)
  800630:	3dfd                	addiw	s11,s11,-1
  800632:	9482                	jalr	s1
  800634:	6702                	ld	a4,0(sp)
  800636:	fe0d99e3          	bnez	s11,800628 <vprintfmt+0x32a>
  80063a:	00074783          	lbu	a5,0(a4)
  80063e:	0007851b          	sext.w	a0,a5
  800642:	ee0781e3          	beqz	a5,800524 <vprintfmt+0x226>
  800646:	00170a93          	addi	s5,a4,1
  80064a:	b54d                	j	8004ec <vprintfmt+0x1ee>
  80064c:	8466                	mv	s0,s9
  80064e:	b36d                	j	8003f8 <vprintfmt+0xfa>
  800650:	85ea                	mv	a1,s10
  800652:	00000517          	auipc	a0,0x0
  800656:	30650513          	addi	a0,a0,774 # 800958 <main+0x292>
  80065a:	03e000ef          	jal	800698 <strnlen>
  80065e:	40ad8dbb          	subw	s11,s11,a0
  800662:	02800793          	li	a5,40
  800666:	00000717          	auipc	a4,0x0
  80066a:	2f270713          	addi	a4,a4,754 # 800958 <main+0x292>
  80066e:	853e                	mv	a0,a5
  800670:	fbb04ce3          	bgtz	s11,800628 <vprintfmt+0x32a>
  800674:	00170a93          	addi	s5,a4,1
  800678:	bd95                	j	8004ec <vprintfmt+0x1ee>

000000000080067a <printfmt>:
  80067a:	7139                	addi	sp,sp,-64
  80067c:	02010313          	addi	t1,sp,32
  800680:	f03a                	sd	a4,32(sp)
  800682:	871a                	mv	a4,t1
  800684:	ec06                	sd	ra,24(sp)
  800686:	f43e                	sd	a5,40(sp)
  800688:	f842                	sd	a6,48(sp)
  80068a:	fc46                	sd	a7,56(sp)
  80068c:	e41a                	sd	t1,8(sp)
  80068e:	c71ff0ef          	jal	8002fe <vprintfmt>
  800692:	60e2                	ld	ra,24(sp)
  800694:	6121                	addi	sp,sp,64
  800696:	8082                	ret

0000000000800698 <strnlen>:
  800698:	4781                	li	a5,0
  80069a:	e589                	bnez	a1,8006a4 <strnlen+0xc>
  80069c:	a811                	j	8006b0 <strnlen+0x18>
  80069e:	0785                	addi	a5,a5,1
  8006a0:	00f58863          	beq	a1,a5,8006b0 <strnlen+0x18>
  8006a4:	00f50733          	add	a4,a0,a5
  8006a8:	00074703          	lbu	a4,0(a4)
  8006ac:	fb6d                	bnez	a4,80069e <strnlen+0x6>
  8006ae:	85be                	mv	a1,a5
  8006b0:	852e                	mv	a0,a1
  8006b2:	8082                	ret

00000000008006b4 <memset>:
  8006b4:	ca01                	beqz	a2,8006c4 <memset+0x10>
  8006b6:	962a                	add	a2,a2,a0
  8006b8:	87aa                	mv	a5,a0
  8006ba:	0785                	addi	a5,a5,1
  8006bc:	feb78fa3          	sb	a1,-1(a5)
  8006c0:	fef61de3          	bne	a2,a5,8006ba <memset+0x6>
  8006c4:	8082                	ret

00000000008006c6 <main>:
  8006c6:	715d                	addi	sp,sp,-80
  8006c8:	4651                	li	a2,20
  8006ca:	4581                	li	a1,0
  8006cc:	00001517          	auipc	a0,0x1
  8006d0:	93450513          	addi	a0,a0,-1740 # 801000 <pids>
  8006d4:	e486                	sd	ra,72(sp)
  8006d6:	e0a2                	sd	s0,64(sp)
  8006d8:	fc26                	sd	s1,56(sp)
  8006da:	f84a                	sd	s2,48(sp)
  8006dc:	f44e                	sd	s3,40(sp)
  8006de:	f052                	sd	s4,32(sp)
  8006e0:	ec56                	sd	s5,24(sp)
  8006e2:	fd3ff0ef          	jal	8006b4 <memset>
  8006e6:	4519                	li	a0,6
  8006e8:	00001a97          	auipc	s5,0x1
  8006ec:	948a8a93          	addi	s5,s5,-1720 # 801030 <acc>
  8006f0:	00001497          	auipc	s1,0x1
  8006f4:	91048493          	addi	s1,s1,-1776 # 801000 <pids>
  8006f8:	adbff0ef          	jal	8001d2 <lab6_set_priority>
  8006fc:	89d6                	mv	s3,s5
  8006fe:	8926                	mv	s2,s1
  800700:	4401                	li	s0,0
  800702:	4a15                	li	s4,5
  800704:	0009a023          	sw	zero,0(s3)
  800708:	ac1ff0ef          	jal	8001c8 <fork>
  80070c:	00a92023          	sw	a0,0(s2)
  800710:	c561                	beqz	a0,8007d8 <main+0x112>
  800712:	12054863          	bltz	a0,800842 <main+0x17c>
  800716:	2405                	addiw	s0,s0,1
  800718:	0991                	addi	s3,s3,4
  80071a:	0911                	addi	s2,s2,4
  80071c:	ff4414e3          	bne	s0,s4,800704 <main+0x3e>
  800720:	00000517          	auipc	a0,0x0
  800724:	45050513          	addi	a0,a0,1104 # 800b70 <main+0x4aa>
  800728:	00001917          	auipc	s2,0x1
  80072c:	8f090913          	addi	s2,s2,-1808 # 801018 <status>
  800730:	9c5ff0ef          	jal	8000f4 <cprintf>
  800734:	844a                	mv	s0,s2
  800736:	00001997          	auipc	s3,0x1
  80073a:	8f698993          	addi	s3,s3,-1802 # 80102c <status+0x14>
  80073e:	4088                	lw	a0,0(s1)
  800740:	85a2                	mv	a1,s0
  800742:	00042023          	sw	zero,0(s0)
  800746:	a85ff0ef          	jal	8001ca <waitpid>
  80074a:	0004aa03          	lw	s4,0(s1)
  80074e:	00042a83          	lw	s5,0(s0)
  800752:	a7fff0ef          	jal	8001d0 <gettime_msec>
  800756:	86aa                	mv	a3,a0
  800758:	8656                	mv	a2,s5
  80075a:	85d2                	mv	a1,s4
  80075c:	00000517          	auipc	a0,0x0
  800760:	43c50513          	addi	a0,a0,1084 # 800b98 <main+0x4d2>
  800764:	0411                	addi	s0,s0,4
  800766:	98fff0ef          	jal	8000f4 <cprintf>
  80076a:	0491                	addi	s1,s1,4
  80076c:	fd3419e3          	bne	s0,s3,80073e <main+0x78>
  800770:	00000517          	auipc	a0,0x0
  800774:	44850513          	addi	a0,a0,1096 # 800bb8 <main+0x4f2>
  800778:	97dff0ef          	jal	8000f4 <cprintf>
  80077c:	00000517          	auipc	a0,0x0
  800780:	45450513          	addi	a0,a0,1108 # 800bd0 <main+0x50a>
  800784:	971ff0ef          	jal	8000f4 <cprintf>
  800788:	00092783          	lw	a5,0(s2)
  80078c:	00001717          	auipc	a4,0x1
  800790:	88c72703          	lw	a4,-1908(a4) # 801018 <status>
  800794:	00000517          	auipc	a0,0x0
  800798:	45c50513          	addi	a0,a0,1116 # 800bf0 <main+0x52a>
  80079c:	0017979b          	slliw	a5,a5,0x1
  8007a0:	02e7c7bb          	divw	a5,a5,a4
  8007a4:	0911                	addi	s2,s2,4
  8007a6:	2785                	addiw	a5,a5,1
  8007a8:	01f7d59b          	srliw	a1,a5,0x1f
  8007ac:	9dbd                	addw	a1,a1,a5
  8007ae:	8585                	srai	a1,a1,0x1
  8007b0:	945ff0ef          	jal	8000f4 <cprintf>
  8007b4:	fd391ae3          	bne	s2,s3,800788 <main+0xc2>
  8007b8:	00000517          	auipc	a0,0x0
  8007bc:	0e050513          	addi	a0,a0,224 # 800898 <main+0x1d2>
  8007c0:	935ff0ef          	jal	8000f4 <cprintf>
  8007c4:	60a6                	ld	ra,72(sp)
  8007c6:	6406                	ld	s0,64(sp)
  8007c8:	74e2                	ld	s1,56(sp)
  8007ca:	7942                	ld	s2,48(sp)
  8007cc:	79a2                	ld	s3,40(sp)
  8007ce:	7a02                	ld	s4,32(sp)
  8007d0:	6ae2                	ld	s5,24(sp)
  8007d2:	4501                	li	a0,0
  8007d4:	6161                	addi	sp,sp,80
  8007d6:	8082                	ret
  8007d8:	0014051b          	addiw	a0,s0,1
  8007dc:	040a                	slli	s0,s0,0x2
  8007de:	9aa2                	add	s5,s5,s0
  8007e0:	6489                	lui	s1,0x2
  8007e2:	6405                	lui	s0,0x1
  8007e4:	9efff0ef          	jal	8001d2 <lab6_set_priority>
  8007e8:	fa04041b          	addiw	s0,s0,-96 # fa0 <open-0x7ff080>
  8007ec:	000aa023          	sw	zero,0(s5)
  8007f0:	71048493          	addi	s1,s1,1808 # 2710 <open-0x7fd910>
  8007f4:	000aa683          	lw	a3,0(s5)
  8007f8:	2685                	addiw	a3,a3,1
  8007fa:	0c800713          	li	a4,200
  8007fe:	47b2                	lw	a5,12(sp)
  800800:	377d                	addiw	a4,a4,-1
  800802:	0017b793          	seqz	a5,a5
  800806:	c63e                	sw	a5,12(sp)
  800808:	fb7d                	bnez	a4,8007fe <main+0x138>
  80080a:	0286f7bb          	remuw	a5,a3,s0
  80080e:	c399                	beqz	a5,800814 <main+0x14e>
  800810:	2685                	addiw	a3,a3,1
  800812:	b7e5                	j	8007fa <main+0x134>
  800814:	00daa023          	sw	a3,0(s5)
  800818:	9b9ff0ef          	jal	8001d0 <gettime_msec>
  80081c:	892a                	mv	s2,a0
  80081e:	fca4dbe3          	bge	s1,a0,8007f4 <main+0x12e>
  800822:	9adff0ef          	jal	8001ce <getpid>
  800826:	000aa603          	lw	a2,0(s5)
  80082a:	85aa                	mv	a1,a0
  80082c:	86ca                	mv	a3,s2
  80082e:	00000517          	auipc	a0,0x0
  800832:	32250513          	addi	a0,a0,802 # 800b50 <main+0x48a>
  800836:	8bfff0ef          	jal	8000f4 <cprintf>
  80083a:	000aa503          	lw	a0,0(s5)
  80083e:	975ff0ef          	jal	8001b2 <exit>
  800842:	00000417          	auipc	s0,0x0
  800846:	7d240413          	addi	s0,s0,2002 # 801014 <pids+0x14>
  80084a:	4088                	lw	a0,0(s1)
  80084c:	00a05463          	blez	a0,800854 <main+0x18e>
  800850:	97dff0ef          	jal	8001cc <kill>
  800854:	0491                	addi	s1,s1,4
  800856:	fe849ae3          	bne	s1,s0,80084a <main+0x184>
  80085a:	00000617          	auipc	a2,0x0
  80085e:	39e60613          	addi	a2,a2,926 # 800bf8 <main+0x532>
  800862:	04b00593          	li	a1,75
  800866:	00000517          	auipc	a0,0x0
  80086a:	3a250513          	addi	a0,a0,930 # 800c08 <main+0x542>
  80086e:	fc2ff0ef          	jal	800030 <__panic>
