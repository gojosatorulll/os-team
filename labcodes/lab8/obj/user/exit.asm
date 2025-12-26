
obj/__user_exit.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a285                	j	800184 <sys_open>

0000000000800026 <close>:
  800026:	a2a5                	j	80018e <sys_close>

0000000000800028 <dup2>:
  800028:	a2bd                	j	800196 <sys_dup>

000000000080002a <_start>:
  80002a:	1da000ef          	jal	800204 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	77250513          	addi	a0,a0,1906 # 8007b0 <main+0x112>
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
  800064:	77050513          	addi	a0,a0,1904 # 8007d0 <main+0x132>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	132000ef          	jal	8001a0 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	75850513          	addi	a0,a0,1880 # 8007d8 <main+0x13a>
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
  8000a6:	72e50513          	addi	a0,a0,1838 # 8007d0 <main+0x132>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0c2000ef          	jal	80017e <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	200000ef          	jal	8002e8 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1c6000ef          	jal	8002e8 <vprintfmt>
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

000000000080017e <sys_putc>:
  80017e:	85aa                	mv	a1,a0
  800180:	4579                	li	a0,30
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_open>:
  800184:	862e                	mv	a2,a1
  800186:	85aa                	mv	a1,a0
  800188:	06400513          	li	a0,100
  80018c:	b74d                	j	80012e <syscall>

000000000080018e <sys_close>:
  80018e:	85aa                	mv	a1,a0
  800190:	06500513          	li	a0,101
  800194:	bf69                	j	80012e <syscall>

0000000000800196 <sys_dup>:
  800196:	862e                	mv	a2,a1
  800198:	85aa                	mv	a1,a0
  80019a:	08200513          	li	a0,130
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <exit>:
  8001a0:	1141                	addi	sp,sp,-16
  8001a2:	e406                	sd	ra,8(sp)
  8001a4:	fc5ff0ef          	jal	800168 <sys_exit>
  8001a8:	00000517          	auipc	a0,0x0
  8001ac:	65050513          	addi	a0,a0,1616 # 8007f8 <main+0x15a>
  8001b0:	f45ff0ef          	jal	8000f4 <cprintf>
  8001b4:	a001                	j	8001b4 <exit+0x14>

00000000008001b6 <fork>:
  8001b6:	bf65                	j	80016e <sys_fork>

00000000008001b8 <wait>:
  8001b8:	4581                	li	a1,0
  8001ba:	4501                	li	a0,0
  8001bc:	bf5d                	j	800172 <sys_wait>

00000000008001be <waitpid>:
  8001be:	bf55                	j	800172 <sys_wait>

00000000008001c0 <yield>:
  8001c0:	bf6d                	j	80017a <sys_yield>

00000000008001c2 <initfd>:
  8001c2:	87ae                	mv	a5,a1
  8001c4:	1101                	addi	sp,sp,-32
  8001c6:	e822                	sd	s0,16(sp)
  8001c8:	85b2                	mv	a1,a2
  8001ca:	842a                	mv	s0,a0
  8001cc:	853e                	mv	a0,a5
  8001ce:	ec06                	sd	ra,24(sp)
  8001d0:	e51ff0ef          	jal	800020 <open>
  8001d4:	87aa                	mv	a5,a0
  8001d6:	00054463          	bltz	a0,8001de <initfd+0x1c>
  8001da:	00851763          	bne	a0,s0,8001e8 <initfd+0x26>
  8001de:	60e2                	ld	ra,24(sp)
  8001e0:	6442                	ld	s0,16(sp)
  8001e2:	853e                	mv	a0,a5
  8001e4:	6105                	addi	sp,sp,32
  8001e6:	8082                	ret
  8001e8:	e42a                	sd	a0,8(sp)
  8001ea:	8522                	mv	a0,s0
  8001ec:	e3bff0ef          	jal	800026 <close>
  8001f0:	6522                	ld	a0,8(sp)
  8001f2:	85a2                	mv	a1,s0
  8001f4:	e35ff0ef          	jal	800028 <dup2>
  8001f8:	842a                	mv	s0,a0
  8001fa:	6522                	ld	a0,8(sp)
  8001fc:	e2bff0ef          	jal	800026 <close>
  800200:	87a2                	mv	a5,s0
  800202:	bff1                	j	8001de <initfd+0x1c>

0000000000800204 <umain>:
  800204:	1101                	addi	sp,sp,-32
  800206:	e822                	sd	s0,16(sp)
  800208:	e426                	sd	s1,8(sp)
  80020a:	842a                	mv	s0,a0
  80020c:	84ae                	mv	s1,a1
  80020e:	4601                	li	a2,0
  800210:	00000597          	auipc	a1,0x0
  800214:	60058593          	addi	a1,a1,1536 # 800810 <main+0x172>
  800218:	4501                	li	a0,0
  80021a:	ec06                	sd	ra,24(sp)
  80021c:	fa7ff0ef          	jal	8001c2 <initfd>
  800220:	02054263          	bltz	a0,800244 <umain+0x40>
  800224:	4605                	li	a2,1
  800226:	8532                	mv	a0,a2
  800228:	00000597          	auipc	a1,0x0
  80022c:	62858593          	addi	a1,a1,1576 # 800850 <main+0x1b2>
  800230:	f93ff0ef          	jal	8001c2 <initfd>
  800234:	02054563          	bltz	a0,80025e <umain+0x5a>
  800238:	85a6                	mv	a1,s1
  80023a:	8522                	mv	a0,s0
  80023c:	462000ef          	jal	80069e <main>
  800240:	f61ff0ef          	jal	8001a0 <exit>
  800244:	86aa                	mv	a3,a0
  800246:	00000617          	auipc	a2,0x0
  80024a:	5d260613          	addi	a2,a2,1490 # 800818 <main+0x17a>
  80024e:	45e9                	li	a1,26
  800250:	00000517          	auipc	a0,0x0
  800254:	5e850513          	addi	a0,a0,1512 # 800838 <main+0x19a>
  800258:	e1bff0ef          	jal	800072 <__warn>
  80025c:	b7e1                	j	800224 <umain+0x20>
  80025e:	86aa                	mv	a3,a0
  800260:	00000617          	auipc	a2,0x0
  800264:	5f860613          	addi	a2,a2,1528 # 800858 <main+0x1ba>
  800268:	45f5                	li	a1,29
  80026a:	00000517          	auipc	a0,0x0
  80026e:	5ce50513          	addi	a0,a0,1486 # 800838 <main+0x19a>
  800272:	e01ff0ef          	jal	800072 <__warn>
  800276:	b7c9                	j	800238 <umain+0x34>

0000000000800278 <printnum>:
  800278:	7139                	addi	sp,sp,-64
  80027a:	02071893          	slli	a7,a4,0x20
  80027e:	f822                	sd	s0,48(sp)
  800280:	f426                	sd	s1,40(sp)
  800282:	f04a                	sd	s2,32(sp)
  800284:	ec4e                	sd	s3,24(sp)
  800286:	e456                	sd	s5,8(sp)
  800288:	0208d893          	srli	a7,a7,0x20
  80028c:	fc06                	sd	ra,56(sp)
  80028e:	0316fab3          	remu	s5,a3,a7
  800292:	fff7841b          	addiw	s0,a5,-1
  800296:	84aa                	mv	s1,a0
  800298:	89ae                	mv	s3,a1
  80029a:	8932                	mv	s2,a2
  80029c:	0516f063          	bgeu	a3,a7,8002dc <printnum+0x64>
  8002a0:	e852                	sd	s4,16(sp)
  8002a2:	4705                	li	a4,1
  8002a4:	8a42                	mv	s4,a6
  8002a6:	00f75863          	bge	a4,a5,8002b6 <printnum+0x3e>
  8002aa:	864e                	mv	a2,s3
  8002ac:	85ca                	mv	a1,s2
  8002ae:	8552                	mv	a0,s4
  8002b0:	347d                	addiw	s0,s0,-1
  8002b2:	9482                	jalr	s1
  8002b4:	f87d                	bnez	s0,8002aa <printnum+0x32>
  8002b6:	6a42                	ld	s4,16(sp)
  8002b8:	00000797          	auipc	a5,0x0
  8002bc:	5c078793          	addi	a5,a5,1472 # 800878 <main+0x1da>
  8002c0:	97d6                	add	a5,a5,s5
  8002c2:	7442                	ld	s0,48(sp)
  8002c4:	0007c503          	lbu	a0,0(a5)
  8002c8:	70e2                	ld	ra,56(sp)
  8002ca:	6aa2                	ld	s5,8(sp)
  8002cc:	864e                	mv	a2,s3
  8002ce:	85ca                	mv	a1,s2
  8002d0:	69e2                	ld	s3,24(sp)
  8002d2:	7902                	ld	s2,32(sp)
  8002d4:	87a6                	mv	a5,s1
  8002d6:	74a2                	ld	s1,40(sp)
  8002d8:	6121                	addi	sp,sp,64
  8002da:	8782                	jr	a5
  8002dc:	0316d6b3          	divu	a3,a3,a7
  8002e0:	87a2                	mv	a5,s0
  8002e2:	f97ff0ef          	jal	800278 <printnum>
  8002e6:	bfc9                	j	8002b8 <printnum+0x40>

00000000008002e8 <vprintfmt>:
  8002e8:	7119                	addi	sp,sp,-128
  8002ea:	f4a6                	sd	s1,104(sp)
  8002ec:	f0ca                	sd	s2,96(sp)
  8002ee:	ecce                	sd	s3,88(sp)
  8002f0:	e8d2                	sd	s4,80(sp)
  8002f2:	e4d6                	sd	s5,72(sp)
  8002f4:	e0da                	sd	s6,64(sp)
  8002f6:	fc5e                	sd	s7,56(sp)
  8002f8:	f466                	sd	s9,40(sp)
  8002fa:	fc86                	sd	ra,120(sp)
  8002fc:	f8a2                	sd	s0,112(sp)
  8002fe:	f862                	sd	s8,48(sp)
  800300:	f06a                	sd	s10,32(sp)
  800302:	ec6e                	sd	s11,24(sp)
  800304:	84aa                	mv	s1,a0
  800306:	8cb6                	mv	s9,a3
  800308:	8aba                	mv	s5,a4
  80030a:	89ae                	mv	s3,a1
  80030c:	8932                	mv	s2,a2
  80030e:	02500a13          	li	s4,37
  800312:	05500b93          	li	s7,85
  800316:	00001b17          	auipc	s6,0x1
  80031a:	89eb0b13          	addi	s6,s6,-1890 # 800bb4 <main+0x516>
  80031e:	000cc503          	lbu	a0,0(s9)
  800322:	001c8413          	addi	s0,s9,1
  800326:	01450b63          	beq	a0,s4,80033c <vprintfmt+0x54>
  80032a:	cd15                	beqz	a0,800366 <vprintfmt+0x7e>
  80032c:	864e                	mv	a2,s3
  80032e:	85ca                	mv	a1,s2
  800330:	9482                	jalr	s1
  800332:	00044503          	lbu	a0,0(s0)
  800336:	0405                	addi	s0,s0,1
  800338:	ff4519e3          	bne	a0,s4,80032a <vprintfmt+0x42>
  80033c:	5d7d                	li	s10,-1
  80033e:	8dea                	mv	s11,s10
  800340:	02000813          	li	a6,32
  800344:	4c01                	li	s8,0
  800346:	4581                	li	a1,0
  800348:	00044703          	lbu	a4,0(s0)
  80034c:	00140c93          	addi	s9,s0,1
  800350:	fdd7061b          	addiw	a2,a4,-35
  800354:	0ff67613          	zext.b	a2,a2
  800358:	02cbe663          	bltu	s7,a2,800384 <vprintfmt+0x9c>
  80035c:	060a                	slli	a2,a2,0x2
  80035e:	965a                	add	a2,a2,s6
  800360:	421c                	lw	a5,0(a2)
  800362:	97da                	add	a5,a5,s6
  800364:	8782                	jr	a5
  800366:	70e6                	ld	ra,120(sp)
  800368:	7446                	ld	s0,112(sp)
  80036a:	74a6                	ld	s1,104(sp)
  80036c:	7906                	ld	s2,96(sp)
  80036e:	69e6                	ld	s3,88(sp)
  800370:	6a46                	ld	s4,80(sp)
  800372:	6aa6                	ld	s5,72(sp)
  800374:	6b06                	ld	s6,64(sp)
  800376:	7be2                	ld	s7,56(sp)
  800378:	7c42                	ld	s8,48(sp)
  80037a:	7ca2                	ld	s9,40(sp)
  80037c:	7d02                	ld	s10,32(sp)
  80037e:	6de2                	ld	s11,24(sp)
  800380:	6109                	addi	sp,sp,128
  800382:	8082                	ret
  800384:	864e                	mv	a2,s3
  800386:	85ca                	mv	a1,s2
  800388:	02500513          	li	a0,37
  80038c:	9482                	jalr	s1
  80038e:	fff44783          	lbu	a5,-1(s0)
  800392:	02500713          	li	a4,37
  800396:	8ca2                	mv	s9,s0
  800398:	f8e783e3          	beq	a5,a4,80031e <vprintfmt+0x36>
  80039c:	ffecc783          	lbu	a5,-2(s9)
  8003a0:	1cfd                	addi	s9,s9,-1
  8003a2:	fee79de3          	bne	a5,a4,80039c <vprintfmt+0xb4>
  8003a6:	bfa5                	j	80031e <vprintfmt+0x36>
  8003a8:	00144683          	lbu	a3,1(s0)
  8003ac:	4525                	li	a0,9
  8003ae:	fd070d1b          	addiw	s10,a4,-48
  8003b2:	fd06879b          	addiw	a5,a3,-48
  8003b6:	28f56063          	bltu	a0,a5,800636 <vprintfmt+0x34e>
  8003ba:	2681                	sext.w	a3,a3
  8003bc:	8466                	mv	s0,s9
  8003be:	002d179b          	slliw	a5,s10,0x2
  8003c2:	00144703          	lbu	a4,1(s0)
  8003c6:	01a787bb          	addw	a5,a5,s10
  8003ca:	0017979b          	slliw	a5,a5,0x1
  8003ce:	9fb5                	addw	a5,a5,a3
  8003d0:	fd07061b          	addiw	a2,a4,-48
  8003d4:	0405                	addi	s0,s0,1
  8003d6:	fd078d1b          	addiw	s10,a5,-48
  8003da:	0007069b          	sext.w	a3,a4
  8003de:	fec570e3          	bgeu	a0,a2,8003be <vprintfmt+0xd6>
  8003e2:	f60dd3e3          	bgez	s11,800348 <vprintfmt+0x60>
  8003e6:	8dea                	mv	s11,s10
  8003e8:	5d7d                	li	s10,-1
  8003ea:	bfb9                	j	800348 <vprintfmt+0x60>
  8003ec:	883a                	mv	a6,a4
  8003ee:	8466                	mv	s0,s9
  8003f0:	bfa1                	j	800348 <vprintfmt+0x60>
  8003f2:	8466                	mv	s0,s9
  8003f4:	4c05                	li	s8,1
  8003f6:	bf89                	j	800348 <vprintfmt+0x60>
  8003f8:	4785                	li	a5,1
  8003fa:	008a8613          	addi	a2,s5,8
  8003fe:	00b7c463          	blt	a5,a1,800406 <vprintfmt+0x11e>
  800402:	1c058363          	beqz	a1,8005c8 <vprintfmt+0x2e0>
  800406:	000ab683          	ld	a3,0(s5)
  80040a:	4741                	li	a4,16
  80040c:	8ab2                	mv	s5,a2
  80040e:	2801                	sext.w	a6,a6
  800410:	87ee                	mv	a5,s11
  800412:	864a                	mv	a2,s2
  800414:	85ce                	mv	a1,s3
  800416:	8526                	mv	a0,s1
  800418:	e61ff0ef          	jal	800278 <printnum>
  80041c:	b709                	j	80031e <vprintfmt+0x36>
  80041e:	000aa503          	lw	a0,0(s5)
  800422:	864e                	mv	a2,s3
  800424:	85ca                	mv	a1,s2
  800426:	9482                	jalr	s1
  800428:	0aa1                	addi	s5,s5,8
  80042a:	bdd5                	j	80031e <vprintfmt+0x36>
  80042c:	4785                	li	a5,1
  80042e:	008a8613          	addi	a2,s5,8
  800432:	00b7c463          	blt	a5,a1,80043a <vprintfmt+0x152>
  800436:	18058463          	beqz	a1,8005be <vprintfmt+0x2d6>
  80043a:	000ab683          	ld	a3,0(s5)
  80043e:	4729                	li	a4,10
  800440:	8ab2                	mv	s5,a2
  800442:	b7f1                	j	80040e <vprintfmt+0x126>
  800444:	864e                	mv	a2,s3
  800446:	85ca                	mv	a1,s2
  800448:	03000513          	li	a0,48
  80044c:	e042                	sd	a6,0(sp)
  80044e:	9482                	jalr	s1
  800450:	864e                	mv	a2,s3
  800452:	85ca                	mv	a1,s2
  800454:	07800513          	li	a0,120
  800458:	9482                	jalr	s1
  80045a:	000ab683          	ld	a3,0(s5)
  80045e:	6802                	ld	a6,0(sp)
  800460:	4741                	li	a4,16
  800462:	0aa1                	addi	s5,s5,8
  800464:	b76d                	j	80040e <vprintfmt+0x126>
  800466:	864e                	mv	a2,s3
  800468:	85ca                	mv	a1,s2
  80046a:	02500513          	li	a0,37
  80046e:	9482                	jalr	s1
  800470:	b57d                	j	80031e <vprintfmt+0x36>
  800472:	000aad03          	lw	s10,0(s5)
  800476:	8466                	mv	s0,s9
  800478:	0aa1                	addi	s5,s5,8
  80047a:	b7a5                	j	8003e2 <vprintfmt+0xfa>
  80047c:	4785                	li	a5,1
  80047e:	008a8613          	addi	a2,s5,8
  800482:	00b7c463          	blt	a5,a1,80048a <vprintfmt+0x1a2>
  800486:	12058763          	beqz	a1,8005b4 <vprintfmt+0x2cc>
  80048a:	000ab683          	ld	a3,0(s5)
  80048e:	4721                	li	a4,8
  800490:	8ab2                	mv	s5,a2
  800492:	bfb5                	j	80040e <vprintfmt+0x126>
  800494:	87ee                	mv	a5,s11
  800496:	000dd363          	bgez	s11,80049c <vprintfmt+0x1b4>
  80049a:	4781                	li	a5,0
  80049c:	00078d9b          	sext.w	s11,a5
  8004a0:	8466                	mv	s0,s9
  8004a2:	b55d                	j	800348 <vprintfmt+0x60>
  8004a4:	0008041b          	sext.w	s0,a6
  8004a8:	fd340793          	addi	a5,s0,-45
  8004ac:	01b02733          	sgtz	a4,s11
  8004b0:	00f037b3          	snez	a5,a5
  8004b4:	8ff9                	and	a5,a5,a4
  8004b6:	000ab703          	ld	a4,0(s5)
  8004ba:	008a8693          	addi	a3,s5,8
  8004be:	e436                	sd	a3,8(sp)
  8004c0:	12070563          	beqz	a4,8005ea <vprintfmt+0x302>
  8004c4:	12079d63          	bnez	a5,8005fe <vprintfmt+0x316>
  8004c8:	00074783          	lbu	a5,0(a4)
  8004cc:	0007851b          	sext.w	a0,a5
  8004d0:	c78d                	beqz	a5,8004fa <vprintfmt+0x212>
  8004d2:	00170a93          	addi	s5,a4,1
  8004d6:	547d                	li	s0,-1
  8004d8:	000d4563          	bltz	s10,8004e2 <vprintfmt+0x1fa>
  8004dc:	3d7d                	addiw	s10,s10,-1
  8004de:	008d0e63          	beq	s10,s0,8004fa <vprintfmt+0x212>
  8004e2:	020c1863          	bnez	s8,800512 <vprintfmt+0x22a>
  8004e6:	864e                	mv	a2,s3
  8004e8:	85ca                	mv	a1,s2
  8004ea:	9482                	jalr	s1
  8004ec:	000ac783          	lbu	a5,0(s5)
  8004f0:	0a85                	addi	s5,s5,1
  8004f2:	3dfd                	addiw	s11,s11,-1
  8004f4:	0007851b          	sext.w	a0,a5
  8004f8:	f3e5                	bnez	a5,8004d8 <vprintfmt+0x1f0>
  8004fa:	01b05a63          	blez	s11,80050e <vprintfmt+0x226>
  8004fe:	864e                	mv	a2,s3
  800500:	85ca                	mv	a1,s2
  800502:	02000513          	li	a0,32
  800506:	3dfd                	addiw	s11,s11,-1
  800508:	9482                	jalr	s1
  80050a:	fe0d9ae3          	bnez	s11,8004fe <vprintfmt+0x216>
  80050e:	6aa2                	ld	s5,8(sp)
  800510:	b539                	j	80031e <vprintfmt+0x36>
  800512:	3781                	addiw	a5,a5,-32
  800514:	05e00713          	li	a4,94
  800518:	fcf777e3          	bgeu	a4,a5,8004e6 <vprintfmt+0x1fe>
  80051c:	03f00513          	li	a0,63
  800520:	864e                	mv	a2,s3
  800522:	85ca                	mv	a1,s2
  800524:	9482                	jalr	s1
  800526:	000ac783          	lbu	a5,0(s5)
  80052a:	0a85                	addi	s5,s5,1
  80052c:	3dfd                	addiw	s11,s11,-1
  80052e:	0007851b          	sext.w	a0,a5
  800532:	d7e1                	beqz	a5,8004fa <vprintfmt+0x212>
  800534:	fa0d54e3          	bgez	s10,8004dc <vprintfmt+0x1f4>
  800538:	bfe9                	j	800512 <vprintfmt+0x22a>
  80053a:	000aa783          	lw	a5,0(s5)
  80053e:	46e1                	li	a3,24
  800540:	0aa1                	addi	s5,s5,8
  800542:	41f7d71b          	sraiw	a4,a5,0x1f
  800546:	8fb9                	xor	a5,a5,a4
  800548:	40e7873b          	subw	a4,a5,a4
  80054c:	02e6c663          	blt	a3,a4,800578 <vprintfmt+0x290>
  800550:	00000797          	auipc	a5,0x0
  800554:	7c078793          	addi	a5,a5,1984 # 800d10 <error_string>
  800558:	00371693          	slli	a3,a4,0x3
  80055c:	97b6                	add	a5,a5,a3
  80055e:	639c                	ld	a5,0(a5)
  800560:	cf81                	beqz	a5,800578 <vprintfmt+0x290>
  800562:	873e                	mv	a4,a5
  800564:	00000697          	auipc	a3,0x0
  800568:	34468693          	addi	a3,a3,836 # 8008a8 <main+0x20a>
  80056c:	864a                	mv	a2,s2
  80056e:	85ce                	mv	a1,s3
  800570:	8526                	mv	a0,s1
  800572:	0f2000ef          	jal	800664 <printfmt>
  800576:	b365                	j	80031e <vprintfmt+0x36>
  800578:	00000697          	auipc	a3,0x0
  80057c:	32068693          	addi	a3,a3,800 # 800898 <main+0x1fa>
  800580:	864a                	mv	a2,s2
  800582:	85ce                	mv	a1,s3
  800584:	8526                	mv	a0,s1
  800586:	0de000ef          	jal	800664 <printfmt>
  80058a:	bb51                	j	80031e <vprintfmt+0x36>
  80058c:	4785                	li	a5,1
  80058e:	008a8c13          	addi	s8,s5,8
  800592:	00b7c363          	blt	a5,a1,800598 <vprintfmt+0x2b0>
  800596:	cd81                	beqz	a1,8005ae <vprintfmt+0x2c6>
  800598:	000ab403          	ld	s0,0(s5)
  80059c:	02044b63          	bltz	s0,8005d2 <vprintfmt+0x2ea>
  8005a0:	86a2                	mv	a3,s0
  8005a2:	8ae2                	mv	s5,s8
  8005a4:	4729                	li	a4,10
  8005a6:	b5a5                	j	80040e <vprintfmt+0x126>
  8005a8:	2585                	addiw	a1,a1,1
  8005aa:	8466                	mv	s0,s9
  8005ac:	bb71                	j	800348 <vprintfmt+0x60>
  8005ae:	000aa403          	lw	s0,0(s5)
  8005b2:	b7ed                	j	80059c <vprintfmt+0x2b4>
  8005b4:	000ae683          	lwu	a3,0(s5)
  8005b8:	4721                	li	a4,8
  8005ba:	8ab2                	mv	s5,a2
  8005bc:	bd89                	j	80040e <vprintfmt+0x126>
  8005be:	000ae683          	lwu	a3,0(s5)
  8005c2:	4729                	li	a4,10
  8005c4:	8ab2                	mv	s5,a2
  8005c6:	b5a1                	j	80040e <vprintfmt+0x126>
  8005c8:	000ae683          	lwu	a3,0(s5)
  8005cc:	4741                	li	a4,16
  8005ce:	8ab2                	mv	s5,a2
  8005d0:	bd3d                	j	80040e <vprintfmt+0x126>
  8005d2:	864e                	mv	a2,s3
  8005d4:	85ca                	mv	a1,s2
  8005d6:	02d00513          	li	a0,45
  8005da:	e042                	sd	a6,0(sp)
  8005dc:	9482                	jalr	s1
  8005de:	6802                	ld	a6,0(sp)
  8005e0:	408006b3          	neg	a3,s0
  8005e4:	8ae2                	mv	s5,s8
  8005e6:	4729                	li	a4,10
  8005e8:	b51d                	j	80040e <vprintfmt+0x126>
  8005ea:	eba1                	bnez	a5,80063a <vprintfmt+0x352>
  8005ec:	02800793          	li	a5,40
  8005f0:	853e                	mv	a0,a5
  8005f2:	00000a97          	auipc	s5,0x0
  8005f6:	29fa8a93          	addi	s5,s5,671 # 800891 <main+0x1f3>
  8005fa:	547d                	li	s0,-1
  8005fc:	bdf1                	j	8004d8 <vprintfmt+0x1f0>
  8005fe:	853a                	mv	a0,a4
  800600:	85ea                	mv	a1,s10
  800602:	e03a                	sd	a4,0(sp)
  800604:	07e000ef          	jal	800682 <strnlen>
  800608:	40ad8dbb          	subw	s11,s11,a0
  80060c:	6702                	ld	a4,0(sp)
  80060e:	01b05b63          	blez	s11,800624 <vprintfmt+0x33c>
  800612:	864e                	mv	a2,s3
  800614:	85ca                	mv	a1,s2
  800616:	8522                	mv	a0,s0
  800618:	e03a                	sd	a4,0(sp)
  80061a:	3dfd                	addiw	s11,s11,-1
  80061c:	9482                	jalr	s1
  80061e:	6702                	ld	a4,0(sp)
  800620:	fe0d99e3          	bnez	s11,800612 <vprintfmt+0x32a>
  800624:	00074783          	lbu	a5,0(a4)
  800628:	0007851b          	sext.w	a0,a5
  80062c:	ee0781e3          	beqz	a5,80050e <vprintfmt+0x226>
  800630:	00170a93          	addi	s5,a4,1
  800634:	b54d                	j	8004d6 <vprintfmt+0x1ee>
  800636:	8466                	mv	s0,s9
  800638:	b36d                	j	8003e2 <vprintfmt+0xfa>
  80063a:	85ea                	mv	a1,s10
  80063c:	00000517          	auipc	a0,0x0
  800640:	25450513          	addi	a0,a0,596 # 800890 <main+0x1f2>
  800644:	03e000ef          	jal	800682 <strnlen>
  800648:	40ad8dbb          	subw	s11,s11,a0
  80064c:	02800793          	li	a5,40
  800650:	00000717          	auipc	a4,0x0
  800654:	24070713          	addi	a4,a4,576 # 800890 <main+0x1f2>
  800658:	853e                	mv	a0,a5
  80065a:	fbb04ce3          	bgtz	s11,800612 <vprintfmt+0x32a>
  80065e:	00170a93          	addi	s5,a4,1
  800662:	bd95                	j	8004d6 <vprintfmt+0x1ee>

0000000000800664 <printfmt>:
  800664:	7139                	addi	sp,sp,-64
  800666:	02010313          	addi	t1,sp,32
  80066a:	f03a                	sd	a4,32(sp)
  80066c:	871a                	mv	a4,t1
  80066e:	ec06                	sd	ra,24(sp)
  800670:	f43e                	sd	a5,40(sp)
  800672:	f842                	sd	a6,48(sp)
  800674:	fc46                	sd	a7,56(sp)
  800676:	e41a                	sd	t1,8(sp)
  800678:	c71ff0ef          	jal	8002e8 <vprintfmt>
  80067c:	60e2                	ld	ra,24(sp)
  80067e:	6121                	addi	sp,sp,64
  800680:	8082                	ret

0000000000800682 <strnlen>:
  800682:	4781                	li	a5,0
  800684:	e589                	bnez	a1,80068e <strnlen+0xc>
  800686:	a811                	j	80069a <strnlen+0x18>
  800688:	0785                	addi	a5,a5,1
  80068a:	00f58863          	beq	a1,a5,80069a <strnlen+0x18>
  80068e:	00f50733          	add	a4,a0,a5
  800692:	00074703          	lbu	a4,0(a4)
  800696:	fb6d                	bnez	a4,800688 <strnlen+0x6>
  800698:	85be                	mv	a1,a5
  80069a:	852e                	mv	a0,a1
  80069c:	8082                	ret

000000000080069e <main>:
  80069e:	1101                	addi	sp,sp,-32
  8006a0:	00000517          	auipc	a0,0x0
  8006a4:	3e850513          	addi	a0,a0,1000 # 800a88 <main+0x3ea>
  8006a8:	ec06                	sd	ra,24(sp)
  8006aa:	e822                	sd	s0,16(sp)
  8006ac:	a49ff0ef          	jal	8000f4 <cprintf>
  8006b0:	b07ff0ef          	jal	8001b6 <fork>
  8006b4:	c561                	beqz	a0,80077c <main+0xde>
  8006b6:	842a                	mv	s0,a0
  8006b8:	85aa                	mv	a1,a0
  8006ba:	00000517          	auipc	a0,0x0
  8006be:	40e50513          	addi	a0,a0,1038 # 800ac8 <main+0x42a>
  8006c2:	a33ff0ef          	jal	8000f4 <cprintf>
  8006c6:	08805c63          	blez	s0,80075e <main+0xc0>
  8006ca:	00000517          	auipc	a0,0x0
  8006ce:	45650513          	addi	a0,a0,1110 # 800b20 <main+0x482>
  8006d2:	a23ff0ef          	jal	8000f4 <cprintf>
  8006d6:	006c                	addi	a1,sp,12
  8006d8:	8522                	mv	a0,s0
  8006da:	ae5ff0ef          	jal	8001be <waitpid>
  8006de:	e131                	bnez	a0,800722 <main+0x84>
  8006e0:	4732                	lw	a4,12(sp)
  8006e2:	00001797          	auipc	a5,0x1
  8006e6:	91e7a783          	lw	a5,-1762(a5) # 801000 <magic>
  8006ea:	02f71c63          	bne	a4,a5,800722 <main+0x84>
  8006ee:	006c                	addi	a1,sp,12
  8006f0:	8522                	mv	a0,s0
  8006f2:	acdff0ef          	jal	8001be <waitpid>
  8006f6:	c529                	beqz	a0,800740 <main+0xa2>
  8006f8:	ac1ff0ef          	jal	8001b8 <wait>
  8006fc:	c131                	beqz	a0,800740 <main+0xa2>
  8006fe:	85a2                	mv	a1,s0
  800700:	00000517          	auipc	a0,0x0
  800704:	49850513          	addi	a0,a0,1176 # 800b98 <main+0x4fa>
  800708:	9edff0ef          	jal	8000f4 <cprintf>
  80070c:	00000517          	auipc	a0,0x0
  800710:	49c50513          	addi	a0,a0,1180 # 800ba8 <main+0x50a>
  800714:	9e1ff0ef          	jal	8000f4 <cprintf>
  800718:	60e2                	ld	ra,24(sp)
  80071a:	6442                	ld	s0,16(sp)
  80071c:	4501                	li	a0,0
  80071e:	6105                	addi	sp,sp,32
  800720:	8082                	ret
  800722:	00000697          	auipc	a3,0x0
  800726:	41e68693          	addi	a3,a3,1054 # 800b40 <main+0x4a2>
  80072a:	00000617          	auipc	a2,0x0
  80072e:	3ce60613          	addi	a2,a2,974 # 800af8 <main+0x45a>
  800732:	45ed                	li	a1,27
  800734:	00000517          	auipc	a0,0x0
  800738:	3dc50513          	addi	a0,a0,988 # 800b10 <main+0x472>
  80073c:	8f5ff0ef          	jal	800030 <__panic>
  800740:	00000697          	auipc	a3,0x0
  800744:	43068693          	addi	a3,a3,1072 # 800b70 <main+0x4d2>
  800748:	00000617          	auipc	a2,0x0
  80074c:	3b060613          	addi	a2,a2,944 # 800af8 <main+0x45a>
  800750:	45f1                	li	a1,28
  800752:	00000517          	auipc	a0,0x0
  800756:	3be50513          	addi	a0,a0,958 # 800b10 <main+0x472>
  80075a:	8d7ff0ef          	jal	800030 <__panic>
  80075e:	00000697          	auipc	a3,0x0
  800762:	39268693          	addi	a3,a3,914 # 800af0 <main+0x452>
  800766:	00000617          	auipc	a2,0x0
  80076a:	39260613          	addi	a2,a2,914 # 800af8 <main+0x45a>
  80076e:	45e1                	li	a1,24
  800770:	00000517          	auipc	a0,0x0
  800774:	3a050513          	addi	a0,a0,928 # 800b10 <main+0x472>
  800778:	8b9ff0ef          	jal	800030 <__panic>
  80077c:	00000517          	auipc	a0,0x0
  800780:	33450513          	addi	a0,a0,820 # 800ab0 <main+0x412>
  800784:	971ff0ef          	jal	8000f4 <cprintf>
  800788:	a39ff0ef          	jal	8001c0 <yield>
  80078c:	a35ff0ef          	jal	8001c0 <yield>
  800790:	a31ff0ef          	jal	8001c0 <yield>
  800794:	a2dff0ef          	jal	8001c0 <yield>
  800798:	a29ff0ef          	jal	8001c0 <yield>
  80079c:	a25ff0ef          	jal	8001c0 <yield>
  8007a0:	a21ff0ef          	jal	8001c0 <yield>
  8007a4:	00001517          	auipc	a0,0x1
  8007a8:	85c52503          	lw	a0,-1956(a0) # 801000 <magic>
  8007ac:	9f5ff0ef          	jal	8001a0 <exit>
