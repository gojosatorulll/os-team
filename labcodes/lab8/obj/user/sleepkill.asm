
obj/__user_sleepkill.out:     file format elf64-littleriscv


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
  80002a:	1d8000ef          	jal	800202 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	6e250513          	addi	a0,a0,1762 # 800720 <main+0x84>
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
  800064:	6e050513          	addi	a0,a0,1760 # 800740 <main+0xa4>
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
  800084:	6c850513          	addi	a0,a0,1736 # 800748 <main+0xac>
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
  8000a6:	69e50513          	addi	a0,a0,1694 # 800740 <main+0xa4>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0bc000ef          	jal	800178 <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f29>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	1fe000ef          	jal	8002e6 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f29>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1c4000ef          	jal	8002e6 <vprintfmt>
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

0000000000800172 <sys_kill>:
  800172:	85aa                	mv	a1,a0
  800174:	4531                	li	a0,12
  800176:	bf65                	j	80012e <syscall>

0000000000800178 <sys_putc>:
  800178:	85aa                	mv	a1,a0
  80017a:	4579                	li	a0,30
  80017c:	bf4d                	j	80012e <syscall>

000000000080017e <sys_sleep>:
  80017e:	85aa                	mv	a1,a0
  800180:	452d                	li	a0,11
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
  8001ac:	5c050513          	addi	a0,a0,1472 # 800768 <main+0xcc>
  8001b0:	f45ff0ef          	jal	8000f4 <cprintf>
  8001b4:	a001                	j	8001b4 <exit+0x14>

00000000008001b6 <fork>:
  8001b6:	bf65                	j	80016e <sys_fork>

00000000008001b8 <kill>:
  8001b8:	bf6d                	j	800172 <sys_kill>

00000000008001ba <sleep>:
  8001ba:	1502                	slli	a0,a0,0x20
  8001bc:	9101                	srli	a0,a0,0x20
  8001be:	b7c1                	j	80017e <sys_sleep>

00000000008001c0 <initfd>:
  8001c0:	87ae                	mv	a5,a1
  8001c2:	1101                	addi	sp,sp,-32
  8001c4:	e822                	sd	s0,16(sp)
  8001c6:	85b2                	mv	a1,a2
  8001c8:	842a                	mv	s0,a0
  8001ca:	853e                	mv	a0,a5
  8001cc:	ec06                	sd	ra,24(sp)
  8001ce:	e53ff0ef          	jal	800020 <open>
  8001d2:	87aa                	mv	a5,a0
  8001d4:	00054463          	bltz	a0,8001dc <initfd+0x1c>
  8001d8:	00851763          	bne	a0,s0,8001e6 <initfd+0x26>
  8001dc:	60e2                	ld	ra,24(sp)
  8001de:	6442                	ld	s0,16(sp)
  8001e0:	853e                	mv	a0,a5
  8001e2:	6105                	addi	sp,sp,32
  8001e4:	8082                	ret
  8001e6:	e42a                	sd	a0,8(sp)
  8001e8:	8522                	mv	a0,s0
  8001ea:	e3dff0ef          	jal	800026 <close>
  8001ee:	6522                	ld	a0,8(sp)
  8001f0:	85a2                	mv	a1,s0
  8001f2:	e37ff0ef          	jal	800028 <dup2>
  8001f6:	842a                	mv	s0,a0
  8001f8:	6522                	ld	a0,8(sp)
  8001fa:	e2dff0ef          	jal	800026 <close>
  8001fe:	87a2                	mv	a5,s0
  800200:	bff1                	j	8001dc <initfd+0x1c>

0000000000800202 <umain>:
  800202:	1101                	addi	sp,sp,-32
  800204:	e822                	sd	s0,16(sp)
  800206:	e426                	sd	s1,8(sp)
  800208:	842a                	mv	s0,a0
  80020a:	84ae                	mv	s1,a1
  80020c:	4601                	li	a2,0
  80020e:	00000597          	auipc	a1,0x0
  800212:	57258593          	addi	a1,a1,1394 # 800780 <main+0xe4>
  800216:	4501                	li	a0,0
  800218:	ec06                	sd	ra,24(sp)
  80021a:	fa7ff0ef          	jal	8001c0 <initfd>
  80021e:	02054263          	bltz	a0,800242 <umain+0x40>
  800222:	4605                	li	a2,1
  800224:	8532                	mv	a0,a2
  800226:	00000597          	auipc	a1,0x0
  80022a:	59a58593          	addi	a1,a1,1434 # 8007c0 <main+0x124>
  80022e:	f93ff0ef          	jal	8001c0 <initfd>
  800232:	02054563          	bltz	a0,80025c <umain+0x5a>
  800236:	85a6                	mv	a1,s1
  800238:	8522                	mv	a0,s0
  80023a:	462000ef          	jal	80069c <main>
  80023e:	f63ff0ef          	jal	8001a0 <exit>
  800242:	86aa                	mv	a3,a0
  800244:	00000617          	auipc	a2,0x0
  800248:	54460613          	addi	a2,a2,1348 # 800788 <main+0xec>
  80024c:	45e9                	li	a1,26
  80024e:	00000517          	auipc	a0,0x0
  800252:	55a50513          	addi	a0,a0,1370 # 8007a8 <main+0x10c>
  800256:	e1dff0ef          	jal	800072 <__warn>
  80025a:	b7e1                	j	800222 <umain+0x20>
  80025c:	86aa                	mv	a3,a0
  80025e:	00000617          	auipc	a2,0x0
  800262:	56a60613          	addi	a2,a2,1386 # 8007c8 <main+0x12c>
  800266:	45f5                	li	a1,29
  800268:	00000517          	auipc	a0,0x0
  80026c:	54050513          	addi	a0,a0,1344 # 8007a8 <main+0x10c>
  800270:	e03ff0ef          	jal	800072 <__warn>
  800274:	b7c9                	j	800236 <umain+0x34>

0000000000800276 <printnum>:
  800276:	7139                	addi	sp,sp,-64
  800278:	02071893          	slli	a7,a4,0x20
  80027c:	f822                	sd	s0,48(sp)
  80027e:	f426                	sd	s1,40(sp)
  800280:	f04a                	sd	s2,32(sp)
  800282:	ec4e                	sd	s3,24(sp)
  800284:	e456                	sd	s5,8(sp)
  800286:	0208d893          	srli	a7,a7,0x20
  80028a:	fc06                	sd	ra,56(sp)
  80028c:	0316fab3          	remu	s5,a3,a7
  800290:	fff7841b          	addiw	s0,a5,-1
  800294:	84aa                	mv	s1,a0
  800296:	89ae                	mv	s3,a1
  800298:	8932                	mv	s2,a2
  80029a:	0516f063          	bgeu	a3,a7,8002da <printnum+0x64>
  80029e:	e852                	sd	s4,16(sp)
  8002a0:	4705                	li	a4,1
  8002a2:	8a42                	mv	s4,a6
  8002a4:	00f75863          	bge	a4,a5,8002b4 <printnum+0x3e>
  8002a8:	864e                	mv	a2,s3
  8002aa:	85ca                	mv	a1,s2
  8002ac:	8552                	mv	a0,s4
  8002ae:	347d                	addiw	s0,s0,-1
  8002b0:	9482                	jalr	s1
  8002b2:	f87d                	bnez	s0,8002a8 <printnum+0x32>
  8002b4:	6a42                	ld	s4,16(sp)
  8002b6:	00000797          	auipc	a5,0x0
  8002ba:	53278793          	addi	a5,a5,1330 # 8007e8 <main+0x14c>
  8002be:	97d6                	add	a5,a5,s5
  8002c0:	7442                	ld	s0,48(sp)
  8002c2:	0007c503          	lbu	a0,0(a5)
  8002c6:	70e2                	ld	ra,56(sp)
  8002c8:	6aa2                	ld	s5,8(sp)
  8002ca:	864e                	mv	a2,s3
  8002cc:	85ca                	mv	a1,s2
  8002ce:	69e2                	ld	s3,24(sp)
  8002d0:	7902                	ld	s2,32(sp)
  8002d2:	87a6                	mv	a5,s1
  8002d4:	74a2                	ld	s1,40(sp)
  8002d6:	6121                	addi	sp,sp,64
  8002d8:	8782                	jr	a5
  8002da:	0316d6b3          	divu	a3,a3,a7
  8002de:	87a2                	mv	a5,s0
  8002e0:	f97ff0ef          	jal	800276 <printnum>
  8002e4:	bfc9                	j	8002b6 <printnum+0x40>

00000000008002e6 <vprintfmt>:
  8002e6:	7119                	addi	sp,sp,-128
  8002e8:	f4a6                	sd	s1,104(sp)
  8002ea:	f0ca                	sd	s2,96(sp)
  8002ec:	ecce                	sd	s3,88(sp)
  8002ee:	e8d2                	sd	s4,80(sp)
  8002f0:	e4d6                	sd	s5,72(sp)
  8002f2:	e0da                	sd	s6,64(sp)
  8002f4:	fc5e                	sd	s7,56(sp)
  8002f6:	f466                	sd	s9,40(sp)
  8002f8:	fc86                	sd	ra,120(sp)
  8002fa:	f8a2                	sd	s0,112(sp)
  8002fc:	f862                	sd	s8,48(sp)
  8002fe:	f06a                	sd	s10,32(sp)
  800300:	ec6e                	sd	s11,24(sp)
  800302:	84aa                	mv	s1,a0
  800304:	8cb6                	mv	s9,a3
  800306:	8aba                	mv	s5,a4
  800308:	89ae                	mv	s3,a1
  80030a:	8932                	mv	s2,a2
  80030c:	02500a13          	li	s4,37
  800310:	05500b93          	li	s7,85
  800314:	00000b17          	auipc	s6,0x0
  800318:	740b0b13          	addi	s6,s6,1856 # 800a54 <main+0x3b8>
  80031c:	000cc503          	lbu	a0,0(s9)
  800320:	001c8413          	addi	s0,s9,1
  800324:	01450b63          	beq	a0,s4,80033a <vprintfmt+0x54>
  800328:	cd15                	beqz	a0,800364 <vprintfmt+0x7e>
  80032a:	864e                	mv	a2,s3
  80032c:	85ca                	mv	a1,s2
  80032e:	9482                	jalr	s1
  800330:	00044503          	lbu	a0,0(s0)
  800334:	0405                	addi	s0,s0,1
  800336:	ff4519e3          	bne	a0,s4,800328 <vprintfmt+0x42>
  80033a:	5d7d                	li	s10,-1
  80033c:	8dea                	mv	s11,s10
  80033e:	02000813          	li	a6,32
  800342:	4c01                	li	s8,0
  800344:	4581                	li	a1,0
  800346:	00044703          	lbu	a4,0(s0)
  80034a:	00140c93          	addi	s9,s0,1
  80034e:	fdd7061b          	addiw	a2,a4,-35
  800352:	0ff67613          	zext.b	a2,a2
  800356:	02cbe663          	bltu	s7,a2,800382 <vprintfmt+0x9c>
  80035a:	060a                	slli	a2,a2,0x2
  80035c:	965a                	add	a2,a2,s6
  80035e:	421c                	lw	a5,0(a2)
  800360:	97da                	add	a5,a5,s6
  800362:	8782                	jr	a5
  800364:	70e6                	ld	ra,120(sp)
  800366:	7446                	ld	s0,112(sp)
  800368:	74a6                	ld	s1,104(sp)
  80036a:	7906                	ld	s2,96(sp)
  80036c:	69e6                	ld	s3,88(sp)
  80036e:	6a46                	ld	s4,80(sp)
  800370:	6aa6                	ld	s5,72(sp)
  800372:	6b06                	ld	s6,64(sp)
  800374:	7be2                	ld	s7,56(sp)
  800376:	7c42                	ld	s8,48(sp)
  800378:	7ca2                	ld	s9,40(sp)
  80037a:	7d02                	ld	s10,32(sp)
  80037c:	6de2                	ld	s11,24(sp)
  80037e:	6109                	addi	sp,sp,128
  800380:	8082                	ret
  800382:	864e                	mv	a2,s3
  800384:	85ca                	mv	a1,s2
  800386:	02500513          	li	a0,37
  80038a:	9482                	jalr	s1
  80038c:	fff44783          	lbu	a5,-1(s0)
  800390:	02500713          	li	a4,37
  800394:	8ca2                	mv	s9,s0
  800396:	f8e783e3          	beq	a5,a4,80031c <vprintfmt+0x36>
  80039a:	ffecc783          	lbu	a5,-2(s9)
  80039e:	1cfd                	addi	s9,s9,-1
  8003a0:	fee79de3          	bne	a5,a4,80039a <vprintfmt+0xb4>
  8003a4:	bfa5                	j	80031c <vprintfmt+0x36>
  8003a6:	00144683          	lbu	a3,1(s0)
  8003aa:	4525                	li	a0,9
  8003ac:	fd070d1b          	addiw	s10,a4,-48
  8003b0:	fd06879b          	addiw	a5,a3,-48
  8003b4:	28f56063          	bltu	a0,a5,800634 <vprintfmt+0x34e>
  8003b8:	2681                	sext.w	a3,a3
  8003ba:	8466                	mv	s0,s9
  8003bc:	002d179b          	slliw	a5,s10,0x2
  8003c0:	00144703          	lbu	a4,1(s0)
  8003c4:	01a787bb          	addw	a5,a5,s10
  8003c8:	0017979b          	slliw	a5,a5,0x1
  8003cc:	9fb5                	addw	a5,a5,a3
  8003ce:	fd07061b          	addiw	a2,a4,-48
  8003d2:	0405                	addi	s0,s0,1
  8003d4:	fd078d1b          	addiw	s10,a5,-48
  8003d8:	0007069b          	sext.w	a3,a4
  8003dc:	fec570e3          	bgeu	a0,a2,8003bc <vprintfmt+0xd6>
  8003e0:	f60dd3e3          	bgez	s11,800346 <vprintfmt+0x60>
  8003e4:	8dea                	mv	s11,s10
  8003e6:	5d7d                	li	s10,-1
  8003e8:	bfb9                	j	800346 <vprintfmt+0x60>
  8003ea:	883a                	mv	a6,a4
  8003ec:	8466                	mv	s0,s9
  8003ee:	bfa1                	j	800346 <vprintfmt+0x60>
  8003f0:	8466                	mv	s0,s9
  8003f2:	4c05                	li	s8,1
  8003f4:	bf89                	j	800346 <vprintfmt+0x60>
  8003f6:	4785                	li	a5,1
  8003f8:	008a8613          	addi	a2,s5,8
  8003fc:	00b7c463          	blt	a5,a1,800404 <vprintfmt+0x11e>
  800400:	1c058363          	beqz	a1,8005c6 <vprintfmt+0x2e0>
  800404:	000ab683          	ld	a3,0(s5)
  800408:	4741                	li	a4,16
  80040a:	8ab2                	mv	s5,a2
  80040c:	2801                	sext.w	a6,a6
  80040e:	87ee                	mv	a5,s11
  800410:	864a                	mv	a2,s2
  800412:	85ce                	mv	a1,s3
  800414:	8526                	mv	a0,s1
  800416:	e61ff0ef          	jal	800276 <printnum>
  80041a:	b709                	j	80031c <vprintfmt+0x36>
  80041c:	000aa503          	lw	a0,0(s5)
  800420:	864e                	mv	a2,s3
  800422:	85ca                	mv	a1,s2
  800424:	9482                	jalr	s1
  800426:	0aa1                	addi	s5,s5,8
  800428:	bdd5                	j	80031c <vprintfmt+0x36>
  80042a:	4785                	li	a5,1
  80042c:	008a8613          	addi	a2,s5,8
  800430:	00b7c463          	blt	a5,a1,800438 <vprintfmt+0x152>
  800434:	18058463          	beqz	a1,8005bc <vprintfmt+0x2d6>
  800438:	000ab683          	ld	a3,0(s5)
  80043c:	4729                	li	a4,10
  80043e:	8ab2                	mv	s5,a2
  800440:	b7f1                	j	80040c <vprintfmt+0x126>
  800442:	864e                	mv	a2,s3
  800444:	85ca                	mv	a1,s2
  800446:	03000513          	li	a0,48
  80044a:	e042                	sd	a6,0(sp)
  80044c:	9482                	jalr	s1
  80044e:	864e                	mv	a2,s3
  800450:	85ca                	mv	a1,s2
  800452:	07800513          	li	a0,120
  800456:	9482                	jalr	s1
  800458:	000ab683          	ld	a3,0(s5)
  80045c:	6802                	ld	a6,0(sp)
  80045e:	4741                	li	a4,16
  800460:	0aa1                	addi	s5,s5,8
  800462:	b76d                	j	80040c <vprintfmt+0x126>
  800464:	864e                	mv	a2,s3
  800466:	85ca                	mv	a1,s2
  800468:	02500513          	li	a0,37
  80046c:	9482                	jalr	s1
  80046e:	b57d                	j	80031c <vprintfmt+0x36>
  800470:	000aad03          	lw	s10,0(s5)
  800474:	8466                	mv	s0,s9
  800476:	0aa1                	addi	s5,s5,8
  800478:	b7a5                	j	8003e0 <vprintfmt+0xfa>
  80047a:	4785                	li	a5,1
  80047c:	008a8613          	addi	a2,s5,8
  800480:	00b7c463          	blt	a5,a1,800488 <vprintfmt+0x1a2>
  800484:	12058763          	beqz	a1,8005b2 <vprintfmt+0x2cc>
  800488:	000ab683          	ld	a3,0(s5)
  80048c:	4721                	li	a4,8
  80048e:	8ab2                	mv	s5,a2
  800490:	bfb5                	j	80040c <vprintfmt+0x126>
  800492:	87ee                	mv	a5,s11
  800494:	000dd363          	bgez	s11,80049a <vprintfmt+0x1b4>
  800498:	4781                	li	a5,0
  80049a:	00078d9b          	sext.w	s11,a5
  80049e:	8466                	mv	s0,s9
  8004a0:	b55d                	j	800346 <vprintfmt+0x60>
  8004a2:	0008041b          	sext.w	s0,a6
  8004a6:	fd340793          	addi	a5,s0,-45
  8004aa:	01b02733          	sgtz	a4,s11
  8004ae:	00f037b3          	snez	a5,a5
  8004b2:	8ff9                	and	a5,a5,a4
  8004b4:	000ab703          	ld	a4,0(s5)
  8004b8:	008a8693          	addi	a3,s5,8
  8004bc:	e436                	sd	a3,8(sp)
  8004be:	12070563          	beqz	a4,8005e8 <vprintfmt+0x302>
  8004c2:	12079d63          	bnez	a5,8005fc <vprintfmt+0x316>
  8004c6:	00074783          	lbu	a5,0(a4)
  8004ca:	0007851b          	sext.w	a0,a5
  8004ce:	c78d                	beqz	a5,8004f8 <vprintfmt+0x212>
  8004d0:	00170a93          	addi	s5,a4,1
  8004d4:	547d                	li	s0,-1
  8004d6:	000d4563          	bltz	s10,8004e0 <vprintfmt+0x1fa>
  8004da:	3d7d                	addiw	s10,s10,-1
  8004dc:	008d0e63          	beq	s10,s0,8004f8 <vprintfmt+0x212>
  8004e0:	020c1863          	bnez	s8,800510 <vprintfmt+0x22a>
  8004e4:	864e                	mv	a2,s3
  8004e6:	85ca                	mv	a1,s2
  8004e8:	9482                	jalr	s1
  8004ea:	000ac783          	lbu	a5,0(s5)
  8004ee:	0a85                	addi	s5,s5,1
  8004f0:	3dfd                	addiw	s11,s11,-1
  8004f2:	0007851b          	sext.w	a0,a5
  8004f6:	f3e5                	bnez	a5,8004d6 <vprintfmt+0x1f0>
  8004f8:	01b05a63          	blez	s11,80050c <vprintfmt+0x226>
  8004fc:	864e                	mv	a2,s3
  8004fe:	85ca                	mv	a1,s2
  800500:	02000513          	li	a0,32
  800504:	3dfd                	addiw	s11,s11,-1
  800506:	9482                	jalr	s1
  800508:	fe0d9ae3          	bnez	s11,8004fc <vprintfmt+0x216>
  80050c:	6aa2                	ld	s5,8(sp)
  80050e:	b539                	j	80031c <vprintfmt+0x36>
  800510:	3781                	addiw	a5,a5,-32
  800512:	05e00713          	li	a4,94
  800516:	fcf777e3          	bgeu	a4,a5,8004e4 <vprintfmt+0x1fe>
  80051a:	03f00513          	li	a0,63
  80051e:	864e                	mv	a2,s3
  800520:	85ca                	mv	a1,s2
  800522:	9482                	jalr	s1
  800524:	000ac783          	lbu	a5,0(s5)
  800528:	0a85                	addi	s5,s5,1
  80052a:	3dfd                	addiw	s11,s11,-1
  80052c:	0007851b          	sext.w	a0,a5
  800530:	d7e1                	beqz	a5,8004f8 <vprintfmt+0x212>
  800532:	fa0d54e3          	bgez	s10,8004da <vprintfmt+0x1f4>
  800536:	bfe9                	j	800510 <vprintfmt+0x22a>
  800538:	000aa783          	lw	a5,0(s5)
  80053c:	46e1                	li	a3,24
  80053e:	0aa1                	addi	s5,s5,8
  800540:	41f7d71b          	sraiw	a4,a5,0x1f
  800544:	8fb9                	xor	a5,a5,a4
  800546:	40e7873b          	subw	a4,a5,a4
  80054a:	02e6c663          	blt	a3,a4,800576 <vprintfmt+0x290>
  80054e:	00000797          	auipc	a5,0x0
  800552:	66278793          	addi	a5,a5,1634 # 800bb0 <error_string>
  800556:	00371693          	slli	a3,a4,0x3
  80055a:	97b6                	add	a5,a5,a3
  80055c:	639c                	ld	a5,0(a5)
  80055e:	cf81                	beqz	a5,800576 <vprintfmt+0x290>
  800560:	873e                	mv	a4,a5
  800562:	00000697          	auipc	a3,0x0
  800566:	2b668693          	addi	a3,a3,694 # 800818 <main+0x17c>
  80056a:	864a                	mv	a2,s2
  80056c:	85ce                	mv	a1,s3
  80056e:	8526                	mv	a0,s1
  800570:	0f2000ef          	jal	800662 <printfmt>
  800574:	b365                	j	80031c <vprintfmt+0x36>
  800576:	00000697          	auipc	a3,0x0
  80057a:	29268693          	addi	a3,a3,658 # 800808 <main+0x16c>
  80057e:	864a                	mv	a2,s2
  800580:	85ce                	mv	a1,s3
  800582:	8526                	mv	a0,s1
  800584:	0de000ef          	jal	800662 <printfmt>
  800588:	bb51                	j	80031c <vprintfmt+0x36>
  80058a:	4785                	li	a5,1
  80058c:	008a8c13          	addi	s8,s5,8
  800590:	00b7c363          	blt	a5,a1,800596 <vprintfmt+0x2b0>
  800594:	cd81                	beqz	a1,8005ac <vprintfmt+0x2c6>
  800596:	000ab403          	ld	s0,0(s5)
  80059a:	02044b63          	bltz	s0,8005d0 <vprintfmt+0x2ea>
  80059e:	86a2                	mv	a3,s0
  8005a0:	8ae2                	mv	s5,s8
  8005a2:	4729                	li	a4,10
  8005a4:	b5a5                	j	80040c <vprintfmt+0x126>
  8005a6:	2585                	addiw	a1,a1,1
  8005a8:	8466                	mv	s0,s9
  8005aa:	bb71                	j	800346 <vprintfmt+0x60>
  8005ac:	000aa403          	lw	s0,0(s5)
  8005b0:	b7ed                	j	80059a <vprintfmt+0x2b4>
  8005b2:	000ae683          	lwu	a3,0(s5)
  8005b6:	4721                	li	a4,8
  8005b8:	8ab2                	mv	s5,a2
  8005ba:	bd89                	j	80040c <vprintfmt+0x126>
  8005bc:	000ae683          	lwu	a3,0(s5)
  8005c0:	4729                	li	a4,10
  8005c2:	8ab2                	mv	s5,a2
  8005c4:	b5a1                	j	80040c <vprintfmt+0x126>
  8005c6:	000ae683          	lwu	a3,0(s5)
  8005ca:	4741                	li	a4,16
  8005cc:	8ab2                	mv	s5,a2
  8005ce:	bd3d                	j	80040c <vprintfmt+0x126>
  8005d0:	864e                	mv	a2,s3
  8005d2:	85ca                	mv	a1,s2
  8005d4:	02d00513          	li	a0,45
  8005d8:	e042                	sd	a6,0(sp)
  8005da:	9482                	jalr	s1
  8005dc:	6802                	ld	a6,0(sp)
  8005de:	408006b3          	neg	a3,s0
  8005e2:	8ae2                	mv	s5,s8
  8005e4:	4729                	li	a4,10
  8005e6:	b51d                	j	80040c <vprintfmt+0x126>
  8005e8:	eba1                	bnez	a5,800638 <vprintfmt+0x352>
  8005ea:	02800793          	li	a5,40
  8005ee:	853e                	mv	a0,a5
  8005f0:	00000a97          	auipc	s5,0x0
  8005f4:	211a8a93          	addi	s5,s5,529 # 800801 <main+0x165>
  8005f8:	547d                	li	s0,-1
  8005fa:	bdf1                	j	8004d6 <vprintfmt+0x1f0>
  8005fc:	853a                	mv	a0,a4
  8005fe:	85ea                	mv	a1,s10
  800600:	e03a                	sd	a4,0(sp)
  800602:	07e000ef          	jal	800680 <strnlen>
  800606:	40ad8dbb          	subw	s11,s11,a0
  80060a:	6702                	ld	a4,0(sp)
  80060c:	01b05b63          	blez	s11,800622 <vprintfmt+0x33c>
  800610:	864e                	mv	a2,s3
  800612:	85ca                	mv	a1,s2
  800614:	8522                	mv	a0,s0
  800616:	e03a                	sd	a4,0(sp)
  800618:	3dfd                	addiw	s11,s11,-1
  80061a:	9482                	jalr	s1
  80061c:	6702                	ld	a4,0(sp)
  80061e:	fe0d99e3          	bnez	s11,800610 <vprintfmt+0x32a>
  800622:	00074783          	lbu	a5,0(a4)
  800626:	0007851b          	sext.w	a0,a5
  80062a:	ee0781e3          	beqz	a5,80050c <vprintfmt+0x226>
  80062e:	00170a93          	addi	s5,a4,1
  800632:	b54d                	j	8004d4 <vprintfmt+0x1ee>
  800634:	8466                	mv	s0,s9
  800636:	b36d                	j	8003e0 <vprintfmt+0xfa>
  800638:	85ea                	mv	a1,s10
  80063a:	00000517          	auipc	a0,0x0
  80063e:	1c650513          	addi	a0,a0,454 # 800800 <main+0x164>
  800642:	03e000ef          	jal	800680 <strnlen>
  800646:	40ad8dbb          	subw	s11,s11,a0
  80064a:	02800793          	li	a5,40
  80064e:	00000717          	auipc	a4,0x0
  800652:	1b270713          	addi	a4,a4,434 # 800800 <main+0x164>
  800656:	853e                	mv	a0,a5
  800658:	fbb04ce3          	bgtz	s11,800610 <vprintfmt+0x32a>
  80065c:	00170a93          	addi	s5,a4,1
  800660:	bd95                	j	8004d4 <vprintfmt+0x1ee>

0000000000800662 <printfmt>:
  800662:	7139                	addi	sp,sp,-64
  800664:	02010313          	addi	t1,sp,32
  800668:	f03a                	sd	a4,32(sp)
  80066a:	871a                	mv	a4,t1
  80066c:	ec06                	sd	ra,24(sp)
  80066e:	f43e                	sd	a5,40(sp)
  800670:	f842                	sd	a6,48(sp)
  800672:	fc46                	sd	a7,56(sp)
  800674:	e41a                	sd	t1,8(sp)
  800676:	c71ff0ef          	jal	8002e6 <vprintfmt>
  80067a:	60e2                	ld	ra,24(sp)
  80067c:	6121                	addi	sp,sp,64
  80067e:	8082                	ret

0000000000800680 <strnlen>:
  800680:	4781                	li	a5,0
  800682:	e589                	bnez	a1,80068c <strnlen+0xc>
  800684:	a811                	j	800698 <strnlen+0x18>
  800686:	0785                	addi	a5,a5,1
  800688:	00f58863          	beq	a1,a5,800698 <strnlen+0x18>
  80068c:	00f50733          	add	a4,a0,a5
  800690:	00074703          	lbu	a4,0(a4)
  800694:	fb6d                	bnez	a4,800686 <strnlen+0x6>
  800696:	85be                	mv	a1,a5
  800698:	852e                	mv	a0,a1
  80069a:	8082                	ret

000000000080069c <main>:
  80069c:	1141                	addi	sp,sp,-16
  80069e:	e406                	sd	ra,8(sp)
  8006a0:	e022                	sd	s0,0(sp)
  8006a2:	b15ff0ef          	jal	8001b6 <fork>
  8006a6:	c51d                	beqz	a0,8006d4 <main+0x38>
  8006a8:	842a                	mv	s0,a0
  8006aa:	04a05c63          	blez	a0,800702 <main+0x66>
  8006ae:	06400513          	li	a0,100
  8006b2:	b09ff0ef          	jal	8001ba <sleep>
  8006b6:	8522                	mv	a0,s0
  8006b8:	b01ff0ef          	jal	8001b8 <kill>
  8006bc:	e505                	bnez	a0,8006e4 <main+0x48>
  8006be:	00000517          	auipc	a0,0x0
  8006c2:	38250513          	addi	a0,a0,898 # 800a40 <main+0x3a4>
  8006c6:	a2fff0ef          	jal	8000f4 <cprintf>
  8006ca:	60a2                	ld	ra,8(sp)
  8006cc:	6402                	ld	s0,0(sp)
  8006ce:	4501                	li	a0,0
  8006d0:	0141                	addi	sp,sp,16
  8006d2:	8082                	ret
  8006d4:	557d                	li	a0,-1
  8006d6:	ae5ff0ef          	jal	8001ba <sleep>
  8006da:	6539                	lui	a0,0xe
  8006dc:	ead50513          	addi	a0,a0,-339 # dead <open-0x7f2173>
  8006e0:	ac1ff0ef          	jal	8001a0 <exit>
  8006e4:	00000697          	auipc	a3,0x0
  8006e8:	34c68693          	addi	a3,a3,844 # 800a30 <main+0x394>
  8006ec:	00000617          	auipc	a2,0x0
  8006f0:	31460613          	addi	a2,a2,788 # 800a00 <main+0x364>
  8006f4:	45b9                	li	a1,14
  8006f6:	00000517          	auipc	a0,0x0
  8006fa:	32250513          	addi	a0,a0,802 # 800a18 <main+0x37c>
  8006fe:	933ff0ef          	jal	800030 <__panic>
  800702:	00000697          	auipc	a3,0x0
  800706:	2f668693          	addi	a3,a3,758 # 8009f8 <main+0x35c>
  80070a:	00000617          	auipc	a2,0x0
  80070e:	2f660613          	addi	a2,a2,758 # 800a00 <main+0x364>
  800712:	45ad                	li	a1,11
  800714:	00000517          	auipc	a0,0x0
  800718:	30450513          	addi	a0,a0,772 # 800a18 <main+0x37c>
  80071c:	915ff0ef          	jal	800030 <__panic>
