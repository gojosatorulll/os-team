
obj/__user_sh.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	ac09                	j	800236 <sys_open>

0000000000800026 <close>:
  800026:	ac29                	j	800240 <sys_close>

0000000000800028 <read>:
  800028:	a405                	j	800248 <sys_read>

000000000080002a <write>:
  80002a:	a42d                	j	800254 <sys_write>

000000000080002c <dup2>:
  80002c:	ac15                	j	800260 <sys_dup>

000000000080002e <_start>:
  80002e:	2b4000ef          	jal	8002e2 <umain>
  800032:	a001                	j	800032 <_start+0x4>

0000000000800034 <__panic>:
  800034:	715d                	addi	sp,sp,-80
  800036:	02810313          	addi	t1,sp,40
  80003a:	e822                	sd	s0,16(sp)
  80003c:	8432                	mv	s0,a2
  80003e:	862e                	mv	a2,a1
  800040:	85aa                	mv	a1,a0
  800042:	00001517          	auipc	a0,0x1
  800046:	d1650513          	addi	a0,a0,-746 # 800d58 <main+0xc2>
  80004a:	ec06                	sd	ra,24(sp)
  80004c:	f436                	sd	a3,40(sp)
  80004e:	f83a                	sd	a4,48(sp)
  800050:	fc3e                	sd	a5,56(sp)
  800052:	e0c2                	sd	a6,64(sp)
  800054:	e4c6                	sd	a7,72(sp)
  800056:	e41a                	sd	t1,8(sp)
  800058:	0c6000ef          	jal	80011e <cprintf>
  80005c:	65a2                	ld	a1,8(sp)
  80005e:	8522                	mv	a0,s0
  800060:	098000ef          	jal	8000f8 <vcprintf>
  800064:	00001517          	auipc	a0,0x1
  800068:	d1450513          	addi	a0,a0,-748 # 800d78 <main+0xe2>
  80006c:	0b2000ef          	jal	80011e <cprintf>
  800070:	5559                	li	a0,-10
  800072:	1f8000ef          	jal	80026a <exit>

0000000000800076 <__warn>:
  800076:	715d                	addi	sp,sp,-80
  800078:	e822                	sd	s0,16(sp)
  80007a:	02810313          	addi	t1,sp,40
  80007e:	8432                	mv	s0,a2
  800080:	862e                	mv	a2,a1
  800082:	85aa                	mv	a1,a0
  800084:	00001517          	auipc	a0,0x1
  800088:	cfc50513          	addi	a0,a0,-772 # 800d80 <main+0xea>
  80008c:	ec06                	sd	ra,24(sp)
  80008e:	f436                	sd	a3,40(sp)
  800090:	f83a                	sd	a4,48(sp)
  800092:	fc3e                	sd	a5,56(sp)
  800094:	e0c2                	sd	a6,64(sp)
  800096:	e4c6                	sd	a7,72(sp)
  800098:	e41a                	sd	t1,8(sp)
  80009a:	084000ef          	jal	80011e <cprintf>
  80009e:	65a2                	ld	a1,8(sp)
  8000a0:	8522                	mv	a0,s0
  8000a2:	056000ef          	jal	8000f8 <vcprintf>
  8000a6:	00001517          	auipc	a0,0x1
  8000aa:	cd250513          	addi	a0,a0,-814 # 800d78 <main+0xe2>
  8000ae:	070000ef          	jal	80011e <cprintf>
  8000b2:	60e2                	ld	ra,24(sp)
  8000b4:	6442                	ld	s0,16(sp)
  8000b6:	6161                	addi	sp,sp,80
  8000b8:	8082                	ret

00000000008000ba <cputch>:
  8000ba:	1101                	addi	sp,sp,-32
  8000bc:	ec06                	sd	ra,24(sp)
  8000be:	e42e                	sd	a1,8(sp)
  8000c0:	166000ef          	jal	800226 <sys_putc>
  8000c4:	65a2                	ld	a1,8(sp)
  8000c6:	60e2                	ld	ra,24(sp)
  8000c8:	419c                	lw	a5,0(a1)
  8000ca:	2785                	addiw	a5,a5,1
  8000cc:	c19c                	sw	a5,0(a1)
  8000ce:	6105                	addi	sp,sp,32
  8000d0:	8082                	ret

00000000008000d2 <fputch>:
  8000d2:	1101                	addi	sp,sp,-32
  8000d4:	e822                	sd	s0,16(sp)
  8000d6:	00a107a3          	sb	a0,15(sp)
  8000da:	842e                	mv	s0,a1
  8000dc:	8532                	mv	a0,a2
  8000de:	00f10593          	addi	a1,sp,15
  8000e2:	4605                	li	a2,1
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	f45ff0ef          	jal	80002a <write>
  8000ea:	401c                	lw	a5,0(s0)
  8000ec:	60e2                	ld	ra,24(sp)
  8000ee:	2785                	addiw	a5,a5,1
  8000f0:	c01c                	sw	a5,0(s0)
  8000f2:	6442                	ld	s0,16(sp)
  8000f4:	6105                	addi	sp,sp,32
  8000f6:	8082                	ret

00000000008000f8 <vcprintf>:
  8000f8:	1101                	addi	sp,sp,-32
  8000fa:	872e                	mv	a4,a1
  8000fc:	75dd                	lui	a1,0xffff7
  8000fe:	86aa                	mv	a3,a0
  800100:	0070                	addi	a2,sp,12
  800102:	00000517          	auipc	a0,0x0
  800106:	fb850513          	addi	a0,a0,-72 # 8000ba <cputch>
  80010a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  80010e:	ec06                	sd	ra,24(sp)
  800110:	c602                	sw	zero,12(sp)
  800112:	2ce000ef          	jal	8003e0 <vprintfmt>
  800116:	60e2                	ld	ra,24(sp)
  800118:	4532                	lw	a0,12(sp)
  80011a:	6105                	addi	sp,sp,32
  80011c:	8082                	ret

000000000080011e <cprintf>:
  80011e:	711d                	addi	sp,sp,-96
  800120:	02810313          	addi	t1,sp,40
  800124:	f42e                	sd	a1,40(sp)
  800126:	75dd                	lui	a1,0xffff7
  800128:	f832                	sd	a2,48(sp)
  80012a:	fc36                	sd	a3,56(sp)
  80012c:	e0ba                	sd	a4,64(sp)
  80012e:	86aa                	mv	a3,a0
  800130:	0050                	addi	a2,sp,4
  800132:	00000517          	auipc	a0,0x0
  800136:	f8850513          	addi	a0,a0,-120 # 8000ba <cputch>
  80013a:	871a                	mv	a4,t1
  80013c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  800140:	ec06                	sd	ra,24(sp)
  800142:	e4be                	sd	a5,72(sp)
  800144:	e8c2                	sd	a6,80(sp)
  800146:	ecc6                	sd	a7,88(sp)
  800148:	c202                	sw	zero,4(sp)
  80014a:	e41a                	sd	t1,8(sp)
  80014c:	294000ef          	jal	8003e0 <vprintfmt>
  800150:	60e2                	ld	ra,24(sp)
  800152:	4512                	lw	a0,4(sp)
  800154:	6125                	addi	sp,sp,96
  800156:	8082                	ret

0000000000800158 <cputs>:
  800158:	1101                	addi	sp,sp,-32
  80015a:	e822                	sd	s0,16(sp)
  80015c:	ec06                	sd	ra,24(sp)
  80015e:	842a                	mv	s0,a0
  800160:	00054503          	lbu	a0,0(a0)
  800164:	c51d                	beqz	a0,800192 <cputs+0x3a>
  800166:	e426                	sd	s1,8(sp)
  800168:	0405                	addi	s0,s0,1
  80016a:	4481                	li	s1,0
  80016c:	0ba000ef          	jal	800226 <sys_putc>
  800170:	00044503          	lbu	a0,0(s0)
  800174:	0405                	addi	s0,s0,1
  800176:	87a6                	mv	a5,s1
  800178:	2485                	addiw	s1,s1,1
  80017a:	f96d                	bnez	a0,80016c <cputs+0x14>
  80017c:	4529                	li	a0,10
  80017e:	0027841b          	addiw	s0,a5,2
  800182:	64a2                	ld	s1,8(sp)
  800184:	0a2000ef          	jal	800226 <sys_putc>
  800188:	60e2                	ld	ra,24(sp)
  80018a:	8522                	mv	a0,s0
  80018c:	6442                	ld	s0,16(sp)
  80018e:	6105                	addi	sp,sp,32
  800190:	8082                	ret
  800192:	4529                	li	a0,10
  800194:	092000ef          	jal	800226 <sys_putc>
  800198:	4405                	li	s0,1
  80019a:	60e2                	ld	ra,24(sp)
  80019c:	8522                	mv	a0,s0
  80019e:	6442                	ld	s0,16(sp)
  8001a0:	6105                	addi	sp,sp,32
  8001a2:	8082                	ret

00000000008001a4 <fprintf>:
  8001a4:	715d                	addi	sp,sp,-80
  8001a6:	02010313          	addi	t1,sp,32
  8001aa:	8e2e                	mv	t3,a1
  8001ac:	f032                	sd	a2,32(sp)
  8001ae:	f436                	sd	a3,40(sp)
  8001b0:	f83a                	sd	a4,48(sp)
  8001b2:	85aa                	mv	a1,a0
  8001b4:	0050                	addi	a2,sp,4
  8001b6:	00000517          	auipc	a0,0x0
  8001ba:	f1c50513          	addi	a0,a0,-228 # 8000d2 <fputch>
  8001be:	86f2                	mv	a3,t3
  8001c0:	871a                	mv	a4,t1
  8001c2:	ec06                	sd	ra,24(sp)
  8001c4:	fc3e                	sd	a5,56(sp)
  8001c6:	e0c2                	sd	a6,64(sp)
  8001c8:	e4c6                	sd	a7,72(sp)
  8001ca:	c202                	sw	zero,4(sp)
  8001cc:	e41a                	sd	t1,8(sp)
  8001ce:	212000ef          	jal	8003e0 <vprintfmt>
  8001d2:	60e2                	ld	ra,24(sp)
  8001d4:	4512                	lw	a0,4(sp)
  8001d6:	6161                	addi	sp,sp,80
  8001d8:	8082                	ret

00000000008001da <syscall>:
  8001da:	7175                	addi	sp,sp,-144
  8001dc:	08010313          	addi	t1,sp,128
  8001e0:	e42a                	sd	a0,8(sp)
  8001e2:	ecae                	sd	a1,88(sp)
  8001e4:	f42e                	sd	a1,40(sp)
  8001e6:	f0b2                	sd	a2,96(sp)
  8001e8:	f832                	sd	a2,48(sp)
  8001ea:	f4b6                	sd	a3,104(sp)
  8001ec:	fc36                	sd	a3,56(sp)
  8001ee:	f8ba                	sd	a4,112(sp)
  8001f0:	e0ba                	sd	a4,64(sp)
  8001f2:	fcbe                	sd	a5,120(sp)
  8001f4:	e4be                	sd	a5,72(sp)
  8001f6:	e142                	sd	a6,128(sp)
  8001f8:	e546                	sd	a7,136(sp)
  8001fa:	f01a                	sd	t1,32(sp)
  8001fc:	4522                	lw	a0,8(sp)
  8001fe:	55a2                	lw	a1,40(sp)
  800200:	5642                	lw	a2,48(sp)
  800202:	56e2                	lw	a3,56(sp)
  800204:	4706                	lw	a4,64(sp)
  800206:	47a6                	lw	a5,72(sp)
  800208:	00000073          	ecall
  80020c:	ce2a                	sw	a0,28(sp)
  80020e:	4572                	lw	a0,28(sp)
  800210:	6149                	addi	sp,sp,144
  800212:	8082                	ret

0000000000800214 <sys_exit>:
  800214:	85aa                	mv	a1,a0
  800216:	4505                	li	a0,1
  800218:	b7c9                	j	8001da <syscall>

000000000080021a <sys_fork>:
  80021a:	4509                	li	a0,2
  80021c:	bf7d                	j	8001da <syscall>

000000000080021e <sys_wait>:
  80021e:	862e                	mv	a2,a1
  800220:	85aa                	mv	a1,a0
  800222:	450d                	li	a0,3
  800224:	bf5d                	j	8001da <syscall>

0000000000800226 <sys_putc>:
  800226:	85aa                	mv	a1,a0
  800228:	4579                	li	a0,30
  80022a:	bf45                	j	8001da <syscall>

000000000080022c <sys_exec>:
  80022c:	86b2                	mv	a3,a2
  80022e:	862e                	mv	a2,a1
  800230:	85aa                	mv	a1,a0
  800232:	4511                	li	a0,4
  800234:	b75d                	j	8001da <syscall>

0000000000800236 <sys_open>:
  800236:	862e                	mv	a2,a1
  800238:	85aa                	mv	a1,a0
  80023a:	06400513          	li	a0,100
  80023e:	bf71                	j	8001da <syscall>

0000000000800240 <sys_close>:
  800240:	85aa                	mv	a1,a0
  800242:	06500513          	li	a0,101
  800246:	bf51                	j	8001da <syscall>

0000000000800248 <sys_read>:
  800248:	86b2                	mv	a3,a2
  80024a:	862e                	mv	a2,a1
  80024c:	85aa                	mv	a1,a0
  80024e:	06600513          	li	a0,102
  800252:	b761                	j	8001da <syscall>

0000000000800254 <sys_write>:
  800254:	86b2                	mv	a3,a2
  800256:	862e                	mv	a2,a1
  800258:	85aa                	mv	a1,a0
  80025a:	06700513          	li	a0,103
  80025e:	bfb5                	j	8001da <syscall>

0000000000800260 <sys_dup>:
  800260:	862e                	mv	a2,a1
  800262:	85aa                	mv	a1,a0
  800264:	08200513          	li	a0,130
  800268:	bf8d                	j	8001da <syscall>

000000000080026a <exit>:
  80026a:	1141                	addi	sp,sp,-16
  80026c:	e406                	sd	ra,8(sp)
  80026e:	fa7ff0ef          	jal	800214 <sys_exit>
  800272:	00001517          	auipc	a0,0x1
  800276:	b2e50513          	addi	a0,a0,-1234 # 800da0 <main+0x10a>
  80027a:	ea5ff0ef          	jal	80011e <cprintf>
  80027e:	a001                	j	80027e <exit+0x14>

0000000000800280 <fork>:
  800280:	bf69                	j	80021a <sys_fork>

0000000000800282 <waitpid>:
  800282:	bf71                	j	80021e <sys_wait>

0000000000800284 <__exec>:
  800284:	619c                	ld	a5,0(a1)
  800286:	862e                	mv	a2,a1
  800288:	cb91                	beqz	a5,80029c <__exec+0x18>
  80028a:	00858793          	addi	a5,a1,8
  80028e:	4701                	li	a4,0
  800290:	6394                	ld	a3,0(a5)
  800292:	07a1                	addi	a5,a5,8
  800294:	2705                	addiw	a4,a4,1
  800296:	feed                	bnez	a3,800290 <__exec+0xc>
  800298:	85ba                	mv	a1,a4
  80029a:	bf49                	j	80022c <sys_exec>
  80029c:	4581                	li	a1,0
  80029e:	b779                	j	80022c <sys_exec>

00000000008002a0 <initfd>:
  8002a0:	87ae                	mv	a5,a1
  8002a2:	1101                	addi	sp,sp,-32
  8002a4:	e822                	sd	s0,16(sp)
  8002a6:	85b2                	mv	a1,a2
  8002a8:	842a                	mv	s0,a0
  8002aa:	853e                	mv	a0,a5
  8002ac:	ec06                	sd	ra,24(sp)
  8002ae:	d73ff0ef          	jal	800020 <open>
  8002b2:	87aa                	mv	a5,a0
  8002b4:	00054463          	bltz	a0,8002bc <initfd+0x1c>
  8002b8:	00851763          	bne	a0,s0,8002c6 <initfd+0x26>
  8002bc:	60e2                	ld	ra,24(sp)
  8002be:	6442                	ld	s0,16(sp)
  8002c0:	853e                	mv	a0,a5
  8002c2:	6105                	addi	sp,sp,32
  8002c4:	8082                	ret
  8002c6:	e42a                	sd	a0,8(sp)
  8002c8:	8522                	mv	a0,s0
  8002ca:	d5dff0ef          	jal	800026 <close>
  8002ce:	6522                	ld	a0,8(sp)
  8002d0:	85a2                	mv	a1,s0
  8002d2:	d5bff0ef          	jal	80002c <dup2>
  8002d6:	842a                	mv	s0,a0
  8002d8:	6522                	ld	a0,8(sp)
  8002da:	d4dff0ef          	jal	800026 <close>
  8002de:	87a2                	mv	a5,s0
  8002e0:	bff1                	j	8002bc <initfd+0x1c>

00000000008002e2 <umain>:
  8002e2:	1101                	addi	sp,sp,-32
  8002e4:	e822                	sd	s0,16(sp)
  8002e6:	e426                	sd	s1,8(sp)
  8002e8:	842a                	mv	s0,a0
  8002ea:	84ae                	mv	s1,a1
  8002ec:	4601                	li	a2,0
  8002ee:	00001597          	auipc	a1,0x1
  8002f2:	aca58593          	addi	a1,a1,-1334 # 800db8 <main+0x122>
  8002f6:	4501                	li	a0,0
  8002f8:	ec06                	sd	ra,24(sp)
  8002fa:	fa7ff0ef          	jal	8002a0 <initfd>
  8002fe:	02054263          	bltz	a0,800322 <umain+0x40>
  800302:	4605                	li	a2,1
  800304:	8532                	mv	a0,a2
  800306:	00001597          	auipc	a1,0x1
  80030a:	af258593          	addi	a1,a1,-1294 # 800df8 <main+0x162>
  80030e:	f93ff0ef          	jal	8002a0 <initfd>
  800312:	02054563          	bltz	a0,80033c <umain+0x5a>
  800316:	85a6                	mv	a1,s1
  800318:	8522                	mv	a0,s0
  80031a:	17d000ef          	jal	800c96 <main>
  80031e:	f4dff0ef          	jal	80026a <exit>
  800322:	86aa                	mv	a3,a0
  800324:	00001617          	auipc	a2,0x1
  800328:	a9c60613          	addi	a2,a2,-1380 # 800dc0 <main+0x12a>
  80032c:	45e9                	li	a1,26
  80032e:	00001517          	auipc	a0,0x1
  800332:	ab250513          	addi	a0,a0,-1358 # 800de0 <main+0x14a>
  800336:	d41ff0ef          	jal	800076 <__warn>
  80033a:	b7e1                	j	800302 <umain+0x20>
  80033c:	86aa                	mv	a3,a0
  80033e:	00001617          	auipc	a2,0x1
  800342:	ac260613          	addi	a2,a2,-1342 # 800e00 <main+0x16a>
  800346:	45f5                	li	a1,29
  800348:	00001517          	auipc	a0,0x1
  80034c:	a9850513          	addi	a0,a0,-1384 # 800de0 <main+0x14a>
  800350:	d27ff0ef          	jal	800076 <__warn>
  800354:	b7c9                	j	800316 <umain+0x34>

0000000000800356 <printnum>:
  800356:	7139                	addi	sp,sp,-64
  800358:	02071893          	slli	a7,a4,0x20
  80035c:	f822                	sd	s0,48(sp)
  80035e:	f426                	sd	s1,40(sp)
  800360:	f04a                	sd	s2,32(sp)
  800362:	ec4e                	sd	s3,24(sp)
  800364:	e456                	sd	s5,8(sp)
  800366:	0208d893          	srli	a7,a7,0x20
  80036a:	fc06                	sd	ra,56(sp)
  80036c:	0316fab3          	remu	s5,a3,a7
  800370:	fff7841b          	addiw	s0,a5,-1
  800374:	84aa                	mv	s1,a0
  800376:	89ae                	mv	s3,a1
  800378:	8932                	mv	s2,a2
  80037a:	0516f063          	bgeu	a3,a7,8003ba <printnum+0x64>
  80037e:	e852                	sd	s4,16(sp)
  800380:	4705                	li	a4,1
  800382:	8a42                	mv	s4,a6
  800384:	00f75863          	bge	a4,a5,800394 <printnum+0x3e>
  800388:	864e                	mv	a2,s3
  80038a:	85ca                	mv	a1,s2
  80038c:	8552                	mv	a0,s4
  80038e:	347d                	addiw	s0,s0,-1
  800390:	9482                	jalr	s1
  800392:	f87d                	bnez	s0,800388 <printnum+0x32>
  800394:	6a42                	ld	s4,16(sp)
  800396:	00001797          	auipc	a5,0x1
  80039a:	a8a78793          	addi	a5,a5,-1398 # 800e20 <main+0x18a>
  80039e:	97d6                	add	a5,a5,s5
  8003a0:	7442                	ld	s0,48(sp)
  8003a2:	0007c503          	lbu	a0,0(a5)
  8003a6:	70e2                	ld	ra,56(sp)
  8003a8:	6aa2                	ld	s5,8(sp)
  8003aa:	864e                	mv	a2,s3
  8003ac:	85ca                	mv	a1,s2
  8003ae:	69e2                	ld	s3,24(sp)
  8003b0:	7902                	ld	s2,32(sp)
  8003b2:	87a6                	mv	a5,s1
  8003b4:	74a2                	ld	s1,40(sp)
  8003b6:	6121                	addi	sp,sp,64
  8003b8:	8782                	jr	a5
  8003ba:	0316d6b3          	divu	a3,a3,a7
  8003be:	87a2                	mv	a5,s0
  8003c0:	f97ff0ef          	jal	800356 <printnum>
  8003c4:	bfc9                	j	800396 <printnum+0x40>

00000000008003c6 <sprintputch>:
  8003c6:	499c                	lw	a5,16(a1)
  8003c8:	6198                	ld	a4,0(a1)
  8003ca:	6594                	ld	a3,8(a1)
  8003cc:	2785                	addiw	a5,a5,1
  8003ce:	c99c                	sw	a5,16(a1)
  8003d0:	00d77763          	bgeu	a4,a3,8003de <sprintputch+0x18>
  8003d4:	00170793          	addi	a5,a4,1
  8003d8:	e19c                	sd	a5,0(a1)
  8003da:	00a70023          	sb	a0,0(a4)
  8003de:	8082                	ret

00000000008003e0 <vprintfmt>:
  8003e0:	7119                	addi	sp,sp,-128
  8003e2:	f4a6                	sd	s1,104(sp)
  8003e4:	f0ca                	sd	s2,96(sp)
  8003e6:	ecce                	sd	s3,88(sp)
  8003e8:	e8d2                	sd	s4,80(sp)
  8003ea:	e4d6                	sd	s5,72(sp)
  8003ec:	e0da                	sd	s6,64(sp)
  8003ee:	fc5e                	sd	s7,56(sp)
  8003f0:	f466                	sd	s9,40(sp)
  8003f2:	fc86                	sd	ra,120(sp)
  8003f4:	f8a2                	sd	s0,112(sp)
  8003f6:	f862                	sd	s8,48(sp)
  8003f8:	f06a                	sd	s10,32(sp)
  8003fa:	ec6e                	sd	s11,24(sp)
  8003fc:	84aa                	mv	s1,a0
  8003fe:	8cb6                	mv	s9,a3
  800400:	8aba                	mv	s5,a4
  800402:	89ae                	mv	s3,a1
  800404:	8932                	mv	s2,a2
  800406:	02500a13          	li	s4,37
  80040a:	05500b93          	li	s7,85
  80040e:	00001b17          	auipc	s6,0x1
  800412:	d86b0b13          	addi	s6,s6,-634 # 801194 <main+0x4fe>
  800416:	000cc503          	lbu	a0,0(s9)
  80041a:	001c8413          	addi	s0,s9,1
  80041e:	01450b63          	beq	a0,s4,800434 <vprintfmt+0x54>
  800422:	cd15                	beqz	a0,80045e <vprintfmt+0x7e>
  800424:	864e                	mv	a2,s3
  800426:	85ca                	mv	a1,s2
  800428:	9482                	jalr	s1
  80042a:	00044503          	lbu	a0,0(s0)
  80042e:	0405                	addi	s0,s0,1
  800430:	ff4519e3          	bne	a0,s4,800422 <vprintfmt+0x42>
  800434:	5d7d                	li	s10,-1
  800436:	8dea                	mv	s11,s10
  800438:	02000813          	li	a6,32
  80043c:	4c01                	li	s8,0
  80043e:	4581                	li	a1,0
  800440:	00044703          	lbu	a4,0(s0)
  800444:	00140c93          	addi	s9,s0,1
  800448:	fdd7061b          	addiw	a2,a4,-35
  80044c:	0ff67613          	zext.b	a2,a2
  800450:	02cbe663          	bltu	s7,a2,80047c <vprintfmt+0x9c>
  800454:	060a                	slli	a2,a2,0x2
  800456:	965a                	add	a2,a2,s6
  800458:	421c                	lw	a5,0(a2)
  80045a:	97da                	add	a5,a5,s6
  80045c:	8782                	jr	a5
  80045e:	70e6                	ld	ra,120(sp)
  800460:	7446                	ld	s0,112(sp)
  800462:	74a6                	ld	s1,104(sp)
  800464:	7906                	ld	s2,96(sp)
  800466:	69e6                	ld	s3,88(sp)
  800468:	6a46                	ld	s4,80(sp)
  80046a:	6aa6                	ld	s5,72(sp)
  80046c:	6b06                	ld	s6,64(sp)
  80046e:	7be2                	ld	s7,56(sp)
  800470:	7c42                	ld	s8,48(sp)
  800472:	7ca2                	ld	s9,40(sp)
  800474:	7d02                	ld	s10,32(sp)
  800476:	6de2                	ld	s11,24(sp)
  800478:	6109                	addi	sp,sp,128
  80047a:	8082                	ret
  80047c:	864e                	mv	a2,s3
  80047e:	85ca                	mv	a1,s2
  800480:	02500513          	li	a0,37
  800484:	9482                	jalr	s1
  800486:	fff44783          	lbu	a5,-1(s0)
  80048a:	02500713          	li	a4,37
  80048e:	8ca2                	mv	s9,s0
  800490:	f8e783e3          	beq	a5,a4,800416 <vprintfmt+0x36>
  800494:	ffecc783          	lbu	a5,-2(s9)
  800498:	1cfd                	addi	s9,s9,-1
  80049a:	fee79de3          	bne	a5,a4,800494 <vprintfmt+0xb4>
  80049e:	bfa5                	j	800416 <vprintfmt+0x36>
  8004a0:	00144683          	lbu	a3,1(s0)
  8004a4:	4525                	li	a0,9
  8004a6:	fd070d1b          	addiw	s10,a4,-48
  8004aa:	fd06879b          	addiw	a5,a3,-48
  8004ae:	28f56063          	bltu	a0,a5,80072e <vprintfmt+0x34e>
  8004b2:	2681                	sext.w	a3,a3
  8004b4:	8466                	mv	s0,s9
  8004b6:	002d179b          	slliw	a5,s10,0x2
  8004ba:	00144703          	lbu	a4,1(s0)
  8004be:	01a787bb          	addw	a5,a5,s10
  8004c2:	0017979b          	slliw	a5,a5,0x1
  8004c6:	9fb5                	addw	a5,a5,a3
  8004c8:	fd07061b          	addiw	a2,a4,-48
  8004cc:	0405                	addi	s0,s0,1
  8004ce:	fd078d1b          	addiw	s10,a5,-48
  8004d2:	0007069b          	sext.w	a3,a4
  8004d6:	fec570e3          	bgeu	a0,a2,8004b6 <vprintfmt+0xd6>
  8004da:	f60dd3e3          	bgez	s11,800440 <vprintfmt+0x60>
  8004de:	8dea                	mv	s11,s10
  8004e0:	5d7d                	li	s10,-1
  8004e2:	bfb9                	j	800440 <vprintfmt+0x60>
  8004e4:	883a                	mv	a6,a4
  8004e6:	8466                	mv	s0,s9
  8004e8:	bfa1                	j	800440 <vprintfmt+0x60>
  8004ea:	8466                	mv	s0,s9
  8004ec:	4c05                	li	s8,1
  8004ee:	bf89                	j	800440 <vprintfmt+0x60>
  8004f0:	4785                	li	a5,1
  8004f2:	008a8613          	addi	a2,s5,8
  8004f6:	00b7c463          	blt	a5,a1,8004fe <vprintfmt+0x11e>
  8004fa:	1c058363          	beqz	a1,8006c0 <vprintfmt+0x2e0>
  8004fe:	000ab683          	ld	a3,0(s5)
  800502:	4741                	li	a4,16
  800504:	8ab2                	mv	s5,a2
  800506:	2801                	sext.w	a6,a6
  800508:	87ee                	mv	a5,s11
  80050a:	864a                	mv	a2,s2
  80050c:	85ce                	mv	a1,s3
  80050e:	8526                	mv	a0,s1
  800510:	e47ff0ef          	jal	800356 <printnum>
  800514:	b709                	j	800416 <vprintfmt+0x36>
  800516:	000aa503          	lw	a0,0(s5)
  80051a:	864e                	mv	a2,s3
  80051c:	85ca                	mv	a1,s2
  80051e:	9482                	jalr	s1
  800520:	0aa1                	addi	s5,s5,8
  800522:	bdd5                	j	800416 <vprintfmt+0x36>
  800524:	4785                	li	a5,1
  800526:	008a8613          	addi	a2,s5,8
  80052a:	00b7c463          	blt	a5,a1,800532 <vprintfmt+0x152>
  80052e:	18058463          	beqz	a1,8006b6 <vprintfmt+0x2d6>
  800532:	000ab683          	ld	a3,0(s5)
  800536:	4729                	li	a4,10
  800538:	8ab2                	mv	s5,a2
  80053a:	b7f1                	j	800506 <vprintfmt+0x126>
  80053c:	864e                	mv	a2,s3
  80053e:	85ca                	mv	a1,s2
  800540:	03000513          	li	a0,48
  800544:	e042                	sd	a6,0(sp)
  800546:	9482                	jalr	s1
  800548:	864e                	mv	a2,s3
  80054a:	85ca                	mv	a1,s2
  80054c:	07800513          	li	a0,120
  800550:	9482                	jalr	s1
  800552:	000ab683          	ld	a3,0(s5)
  800556:	6802                	ld	a6,0(sp)
  800558:	4741                	li	a4,16
  80055a:	0aa1                	addi	s5,s5,8
  80055c:	b76d                	j	800506 <vprintfmt+0x126>
  80055e:	864e                	mv	a2,s3
  800560:	85ca                	mv	a1,s2
  800562:	02500513          	li	a0,37
  800566:	9482                	jalr	s1
  800568:	b57d                	j	800416 <vprintfmt+0x36>
  80056a:	000aad03          	lw	s10,0(s5)
  80056e:	8466                	mv	s0,s9
  800570:	0aa1                	addi	s5,s5,8
  800572:	b7a5                	j	8004da <vprintfmt+0xfa>
  800574:	4785                	li	a5,1
  800576:	008a8613          	addi	a2,s5,8
  80057a:	00b7c463          	blt	a5,a1,800582 <vprintfmt+0x1a2>
  80057e:	12058763          	beqz	a1,8006ac <vprintfmt+0x2cc>
  800582:	000ab683          	ld	a3,0(s5)
  800586:	4721                	li	a4,8
  800588:	8ab2                	mv	s5,a2
  80058a:	bfb5                	j	800506 <vprintfmt+0x126>
  80058c:	87ee                	mv	a5,s11
  80058e:	000dd363          	bgez	s11,800594 <vprintfmt+0x1b4>
  800592:	4781                	li	a5,0
  800594:	00078d9b          	sext.w	s11,a5
  800598:	8466                	mv	s0,s9
  80059a:	b55d                	j	800440 <vprintfmt+0x60>
  80059c:	0008041b          	sext.w	s0,a6
  8005a0:	fd340793          	addi	a5,s0,-45
  8005a4:	01b02733          	sgtz	a4,s11
  8005a8:	00f037b3          	snez	a5,a5
  8005ac:	8ff9                	and	a5,a5,a4
  8005ae:	000ab703          	ld	a4,0(s5)
  8005b2:	008a8693          	addi	a3,s5,8
  8005b6:	e436                	sd	a3,8(sp)
  8005b8:	12070563          	beqz	a4,8006e2 <vprintfmt+0x302>
  8005bc:	12079d63          	bnez	a5,8006f6 <vprintfmt+0x316>
  8005c0:	00074783          	lbu	a5,0(a4)
  8005c4:	0007851b          	sext.w	a0,a5
  8005c8:	c78d                	beqz	a5,8005f2 <vprintfmt+0x212>
  8005ca:	00170a93          	addi	s5,a4,1
  8005ce:	547d                	li	s0,-1
  8005d0:	000d4563          	bltz	s10,8005da <vprintfmt+0x1fa>
  8005d4:	3d7d                	addiw	s10,s10,-1
  8005d6:	008d0e63          	beq	s10,s0,8005f2 <vprintfmt+0x212>
  8005da:	020c1863          	bnez	s8,80060a <vprintfmt+0x22a>
  8005de:	864e                	mv	a2,s3
  8005e0:	85ca                	mv	a1,s2
  8005e2:	9482                	jalr	s1
  8005e4:	000ac783          	lbu	a5,0(s5)
  8005e8:	0a85                	addi	s5,s5,1
  8005ea:	3dfd                	addiw	s11,s11,-1
  8005ec:	0007851b          	sext.w	a0,a5
  8005f0:	f3e5                	bnez	a5,8005d0 <vprintfmt+0x1f0>
  8005f2:	01b05a63          	blez	s11,800606 <vprintfmt+0x226>
  8005f6:	864e                	mv	a2,s3
  8005f8:	85ca                	mv	a1,s2
  8005fa:	02000513          	li	a0,32
  8005fe:	3dfd                	addiw	s11,s11,-1
  800600:	9482                	jalr	s1
  800602:	fe0d9ae3          	bnez	s11,8005f6 <vprintfmt+0x216>
  800606:	6aa2                	ld	s5,8(sp)
  800608:	b539                	j	800416 <vprintfmt+0x36>
  80060a:	3781                	addiw	a5,a5,-32
  80060c:	05e00713          	li	a4,94
  800610:	fcf777e3          	bgeu	a4,a5,8005de <vprintfmt+0x1fe>
  800614:	03f00513          	li	a0,63
  800618:	864e                	mv	a2,s3
  80061a:	85ca                	mv	a1,s2
  80061c:	9482                	jalr	s1
  80061e:	000ac783          	lbu	a5,0(s5)
  800622:	0a85                	addi	s5,s5,1
  800624:	3dfd                	addiw	s11,s11,-1
  800626:	0007851b          	sext.w	a0,a5
  80062a:	d7e1                	beqz	a5,8005f2 <vprintfmt+0x212>
  80062c:	fa0d54e3          	bgez	s10,8005d4 <vprintfmt+0x1f4>
  800630:	bfe9                	j	80060a <vprintfmt+0x22a>
  800632:	000aa783          	lw	a5,0(s5)
  800636:	46e1                	li	a3,24
  800638:	0aa1                	addi	s5,s5,8
  80063a:	41f7d71b          	sraiw	a4,a5,0x1f
  80063e:	8fb9                	xor	a5,a5,a4
  800640:	40e7873b          	subw	a4,a5,a4
  800644:	02e6c663          	blt	a3,a4,800670 <vprintfmt+0x290>
  800648:	00001797          	auipc	a5,0x1
  80064c:	ca878793          	addi	a5,a5,-856 # 8012f0 <error_string>
  800650:	00371693          	slli	a3,a4,0x3
  800654:	97b6                	add	a5,a5,a3
  800656:	639c                	ld	a5,0(a5)
  800658:	cf81                	beqz	a5,800670 <vprintfmt+0x290>
  80065a:	873e                	mv	a4,a5
  80065c:	00000697          	auipc	a3,0x0
  800660:	7f468693          	addi	a3,a3,2036 # 800e50 <main+0x1ba>
  800664:	864a                	mv	a2,s2
  800666:	85ce                	mv	a1,s3
  800668:	8526                	mv	a0,s1
  80066a:	0f2000ef          	jal	80075c <printfmt>
  80066e:	b365                	j	800416 <vprintfmt+0x36>
  800670:	00000697          	auipc	a3,0x0
  800674:	7d068693          	addi	a3,a3,2000 # 800e40 <main+0x1aa>
  800678:	864a                	mv	a2,s2
  80067a:	85ce                	mv	a1,s3
  80067c:	8526                	mv	a0,s1
  80067e:	0de000ef          	jal	80075c <printfmt>
  800682:	bb51                	j	800416 <vprintfmt+0x36>
  800684:	4785                	li	a5,1
  800686:	008a8c13          	addi	s8,s5,8
  80068a:	00b7c363          	blt	a5,a1,800690 <vprintfmt+0x2b0>
  80068e:	cd81                	beqz	a1,8006a6 <vprintfmt+0x2c6>
  800690:	000ab403          	ld	s0,0(s5)
  800694:	02044b63          	bltz	s0,8006ca <vprintfmt+0x2ea>
  800698:	86a2                	mv	a3,s0
  80069a:	8ae2                	mv	s5,s8
  80069c:	4729                	li	a4,10
  80069e:	b5a5                	j	800506 <vprintfmt+0x126>
  8006a0:	2585                	addiw	a1,a1,1
  8006a2:	8466                	mv	s0,s9
  8006a4:	bb71                	j	800440 <vprintfmt+0x60>
  8006a6:	000aa403          	lw	s0,0(s5)
  8006aa:	b7ed                	j	800694 <vprintfmt+0x2b4>
  8006ac:	000ae683          	lwu	a3,0(s5)
  8006b0:	4721                	li	a4,8
  8006b2:	8ab2                	mv	s5,a2
  8006b4:	bd89                	j	800506 <vprintfmt+0x126>
  8006b6:	000ae683          	lwu	a3,0(s5)
  8006ba:	4729                	li	a4,10
  8006bc:	8ab2                	mv	s5,a2
  8006be:	b5a1                	j	800506 <vprintfmt+0x126>
  8006c0:	000ae683          	lwu	a3,0(s5)
  8006c4:	4741                	li	a4,16
  8006c6:	8ab2                	mv	s5,a2
  8006c8:	bd3d                	j	800506 <vprintfmt+0x126>
  8006ca:	864e                	mv	a2,s3
  8006cc:	85ca                	mv	a1,s2
  8006ce:	02d00513          	li	a0,45
  8006d2:	e042                	sd	a6,0(sp)
  8006d4:	9482                	jalr	s1
  8006d6:	6802                	ld	a6,0(sp)
  8006d8:	408006b3          	neg	a3,s0
  8006dc:	8ae2                	mv	s5,s8
  8006de:	4729                	li	a4,10
  8006e0:	b51d                	j	800506 <vprintfmt+0x126>
  8006e2:	eba1                	bnez	a5,800732 <vprintfmt+0x352>
  8006e4:	02800793          	li	a5,40
  8006e8:	853e                	mv	a0,a5
  8006ea:	00000a97          	auipc	s5,0x0
  8006ee:	74fa8a93          	addi	s5,s5,1871 # 800e39 <main+0x1a3>
  8006f2:	547d                	li	s0,-1
  8006f4:	bdf1                	j	8005d0 <vprintfmt+0x1f0>
  8006f6:	853a                	mv	a0,a4
  8006f8:	85ea                	mv	a1,s10
  8006fa:	e03a                	sd	a4,0(sp)
  8006fc:	0cc000ef          	jal	8007c8 <strnlen>
  800700:	40ad8dbb          	subw	s11,s11,a0
  800704:	6702                	ld	a4,0(sp)
  800706:	01b05b63          	blez	s11,80071c <vprintfmt+0x33c>
  80070a:	864e                	mv	a2,s3
  80070c:	85ca                	mv	a1,s2
  80070e:	8522                	mv	a0,s0
  800710:	e03a                	sd	a4,0(sp)
  800712:	3dfd                	addiw	s11,s11,-1
  800714:	9482                	jalr	s1
  800716:	6702                	ld	a4,0(sp)
  800718:	fe0d99e3          	bnez	s11,80070a <vprintfmt+0x32a>
  80071c:	00074783          	lbu	a5,0(a4)
  800720:	0007851b          	sext.w	a0,a5
  800724:	ee0781e3          	beqz	a5,800606 <vprintfmt+0x226>
  800728:	00170a93          	addi	s5,a4,1
  80072c:	b54d                	j	8005ce <vprintfmt+0x1ee>
  80072e:	8466                	mv	s0,s9
  800730:	b36d                	j	8004da <vprintfmt+0xfa>
  800732:	85ea                	mv	a1,s10
  800734:	00000517          	auipc	a0,0x0
  800738:	70450513          	addi	a0,a0,1796 # 800e38 <main+0x1a2>
  80073c:	08c000ef          	jal	8007c8 <strnlen>
  800740:	40ad8dbb          	subw	s11,s11,a0
  800744:	02800793          	li	a5,40
  800748:	00000717          	auipc	a4,0x0
  80074c:	6f070713          	addi	a4,a4,1776 # 800e38 <main+0x1a2>
  800750:	853e                	mv	a0,a5
  800752:	fbb04ce3          	bgtz	s11,80070a <vprintfmt+0x32a>
  800756:	00170a93          	addi	s5,a4,1
  80075a:	bd95                	j	8005ce <vprintfmt+0x1ee>

000000000080075c <printfmt>:
  80075c:	7139                	addi	sp,sp,-64
  80075e:	02010313          	addi	t1,sp,32
  800762:	f03a                	sd	a4,32(sp)
  800764:	871a                	mv	a4,t1
  800766:	ec06                	sd	ra,24(sp)
  800768:	f43e                	sd	a5,40(sp)
  80076a:	f842                	sd	a6,48(sp)
  80076c:	fc46                	sd	a7,56(sp)
  80076e:	e41a                	sd	t1,8(sp)
  800770:	c71ff0ef          	jal	8003e0 <vprintfmt>
  800774:	60e2                	ld	ra,24(sp)
  800776:	6121                	addi	sp,sp,64
  800778:	8082                	ret

000000000080077a <snprintf>:
  80077a:	711d                	addi	sp,sp,-96
  80077c:	15fd                	addi	a1,a1,-1
  80077e:	95aa                	add	a1,a1,a0
  800780:	03810313          	addi	t1,sp,56
  800784:	f406                	sd	ra,40(sp)
  800786:	e82e                	sd	a1,16(sp)
  800788:	e42a                	sd	a0,8(sp)
  80078a:	fc36                	sd	a3,56(sp)
  80078c:	e0ba                	sd	a4,64(sp)
  80078e:	e4be                	sd	a5,72(sp)
  800790:	e8c2                	sd	a6,80(sp)
  800792:	ecc6                	sd	a7,88(sp)
  800794:	cc02                	sw	zero,24(sp)
  800796:	e01a                	sd	t1,0(sp)
  800798:	c515                	beqz	a0,8007c4 <snprintf+0x4a>
  80079a:	02a5e563          	bltu	a1,a0,8007c4 <snprintf+0x4a>
  80079e:	75dd                	lui	a1,0xffff7
  8007a0:	86b2                	mv	a3,a2
  8007a2:	00000517          	auipc	a0,0x0
  8007a6:	c2450513          	addi	a0,a0,-988 # 8003c6 <sprintputch>
  8007aa:	871a                	mv	a4,t1
  8007ac:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  8007b0:	0030                	addi	a2,sp,8
  8007b2:	c2fff0ef          	jal	8003e0 <vprintfmt>
  8007b6:	67a2                	ld	a5,8(sp)
  8007b8:	00078023          	sb	zero,0(a5)
  8007bc:	4562                	lw	a0,24(sp)
  8007be:	70a2                	ld	ra,40(sp)
  8007c0:	6125                	addi	sp,sp,96
  8007c2:	8082                	ret
  8007c4:	5575                	li	a0,-3
  8007c6:	bfe5                	j	8007be <snprintf+0x44>

00000000008007c8 <strnlen>:
  8007c8:	4781                	li	a5,0
  8007ca:	e589                	bnez	a1,8007d4 <strnlen+0xc>
  8007cc:	a811                	j	8007e0 <strnlen+0x18>
  8007ce:	0785                	addi	a5,a5,1
  8007d0:	00f58863          	beq	a1,a5,8007e0 <strnlen+0x18>
  8007d4:	00f50733          	add	a4,a0,a5
  8007d8:	00074703          	lbu	a4,0(a4)
  8007dc:	fb6d                	bnez	a4,8007ce <strnlen+0x6>
  8007de:	85be                	mv	a1,a5
  8007e0:	852e                	mv	a0,a1
  8007e2:	8082                	ret

00000000008007e4 <strcpy>:
  8007e4:	87aa                	mv	a5,a0
  8007e6:	0005c703          	lbu	a4,0(a1)
  8007ea:	0585                	addi	a1,a1,1
  8007ec:	0785                	addi	a5,a5,1
  8007ee:	fee78fa3          	sb	a4,-1(a5)
  8007f2:	fb75                	bnez	a4,8007e6 <strcpy+0x2>
  8007f4:	8082                	ret

00000000008007f6 <strcmp>:
  8007f6:	00054783          	lbu	a5,0(a0)
  8007fa:	e791                	bnez	a5,800806 <strcmp+0x10>
  8007fc:	a01d                	j	800822 <strcmp+0x2c>
  8007fe:	00054783          	lbu	a5,0(a0)
  800802:	cb99                	beqz	a5,800818 <strcmp+0x22>
  800804:	0585                	addi	a1,a1,1
  800806:	0005c703          	lbu	a4,0(a1)
  80080a:	0505                	addi	a0,a0,1
  80080c:	fef709e3          	beq	a4,a5,8007fe <strcmp+0x8>
  800810:	0007851b          	sext.w	a0,a5
  800814:	9d19                	subw	a0,a0,a4
  800816:	8082                	ret
  800818:	0015c703          	lbu	a4,1(a1)
  80081c:	4501                	li	a0,0
  80081e:	9d19                	subw	a0,a0,a4
  800820:	8082                	ret
  800822:	0005c703          	lbu	a4,0(a1)
  800826:	4501                	li	a0,0
  800828:	b7f5                	j	800814 <strcmp+0x1e>

000000000080082a <strchr>:
  80082a:	a021                	j	800832 <strchr+0x8>
  80082c:	00f58763          	beq	a1,a5,80083a <strchr+0x10>
  800830:	0505                	addi	a0,a0,1
  800832:	00054783          	lbu	a5,0(a0)
  800836:	fbfd                	bnez	a5,80082c <strchr+0x2>
  800838:	4501                	li	a0,0
  80083a:	8082                	ret

000000000080083c <gettoken>:
  80083c:	7139                	addi	sp,sp,-64
  80083e:	f822                	sd	s0,48(sp)
  800840:	6100                	ld	s0,0(a0)
  800842:	fc06                	sd	ra,56(sp)
  800844:	c815                	beqz	s0,800878 <gettoken+0x3c>
  800846:	f04a                	sd	s2,32(sp)
  800848:	ec4e                	sd	s3,24(sp)
  80084a:	f426                	sd	s1,40(sp)
  80084c:	892a                	mv	s2,a0
  80084e:	89ae                	mv	s3,a1
  800850:	a021                	j	800858 <gettoken+0x1c>
  800852:	0405                	addi	s0,s0,1
  800854:	fe040fa3          	sb	zero,-1(s0)
  800858:	00044583          	lbu	a1,0(s0)
  80085c:	00000517          	auipc	a0,0x0
  800860:	7d450513          	addi	a0,a0,2004 # 801030 <main+0x39a>
  800864:	fc7ff0ef          	jal	80082a <strchr>
  800868:	84aa                	mv	s1,a0
  80086a:	f565                	bnez	a0,800852 <gettoken+0x16>
  80086c:	00044783          	lbu	a5,0(s0)
  800870:	eb89                	bnez	a5,800882 <gettoken+0x46>
  800872:	74a2                	ld	s1,40(sp)
  800874:	7902                	ld	s2,32(sp)
  800876:	69e2                	ld	s3,24(sp)
  800878:	70e2                	ld	ra,56(sp)
  80087a:	7442                	ld	s0,48(sp)
  80087c:	4501                	li	a0,0
  80087e:	6121                	addi	sp,sp,64
  800880:	8082                	ret
  800882:	0089b023          	sd	s0,0(s3)
  800886:	00044583          	lbu	a1,0(s0)
  80088a:	00000517          	auipc	a0,0x0
  80088e:	7ae50513          	addi	a0,a0,1966 # 801038 <main+0x3a2>
  800892:	f99ff0ef          	jal	80082a <strchr>
  800896:	00044583          	lbu	a1,0(s0)
  80089a:	c505                	beqz	a0,8008c2 <gettoken+0x86>
  80089c:	00144783          	lbu	a5,1(s0)
  8008a0:	0005851b          	sext.w	a0,a1
  8008a4:	00040023          	sb	zero,0(s0)
  8008a8:	00140713          	addi	a4,s0,1
  8008ac:	c391                	beqz	a5,8008b0 <gettoken+0x74>
  8008ae:	84ba                	mv	s1,a4
  8008b0:	70e2                	ld	ra,56(sp)
  8008b2:	7442                	ld	s0,48(sp)
  8008b4:	00993023          	sd	s1,0(s2)
  8008b8:	69e2                	ld	s3,24(sp)
  8008ba:	74a2                	ld	s1,40(sp)
  8008bc:	7902                	ld	s2,32(sp)
  8008be:	6121                	addi	sp,sp,64
  8008c0:	8082                	ret
  8008c2:	4701                	li	a4,0
  8008c4:	02200693          	li	a3,34
  8008c8:	c185                	beqz	a1,8008e8 <gettoken+0xac>
  8008ca:	c31d                	beqz	a4,8008f0 <gettoken+0xb4>
  8008cc:	00044783          	lbu	a5,0(s0)
  8008d0:	00d79863          	bne	a5,a3,8008e0 <gettoken+0xa4>
  8008d4:	02000793          	li	a5,32
  8008d8:	00f40023          	sb	a5,0(s0)
  8008dc:	00174713          	xori	a4,a4,1
  8008e0:	00144583          	lbu	a1,1(s0)
  8008e4:	0405                	addi	s0,s0,1
  8008e6:	f1f5                	bnez	a1,8008ca <gettoken+0x8e>
  8008e8:	4481                	li	s1,0
  8008ea:	07700513          	li	a0,119
  8008ee:	b7c9                	j	8008b0 <gettoken+0x74>
  8008f0:	00000517          	auipc	a0,0x0
  8008f4:	75050513          	addi	a0,a0,1872 # 801040 <main+0x3aa>
  8008f8:	e43a                	sd	a4,8(sp)
  8008fa:	f31ff0ef          	jal	80082a <strchr>
  8008fe:	6722                	ld	a4,8(sp)
  800900:	02200693          	li	a3,34
  800904:	d561                	beqz	a0,8008cc <gettoken+0x90>
  800906:	00044783          	lbu	a5,0(s0)
  80090a:	8722                	mv	a4,s0
  80090c:	07700513          	li	a0,119
  800910:	bf71                	j	8008ac <gettoken+0x70>

0000000000800912 <readline>:
  800912:	715d                	addi	sp,sp,-80
  800914:	e486                	sd	ra,72(sp)
  800916:	e0a2                	sd	s0,64(sp)
  800918:	fc26                	sd	s1,56(sp)
  80091a:	f84a                	sd	s2,48(sp)
  80091c:	f44e                	sd	s3,40(sp)
  80091e:	f052                	sd	s4,32(sp)
  800920:	ec56                	sd	s5,24(sp)
  800922:	c909                	beqz	a0,800934 <readline+0x22>
  800924:	862a                	mv	a2,a0
  800926:	00000597          	auipc	a1,0x0
  80092a:	52a58593          	addi	a1,a1,1322 # 800e50 <main+0x1ba>
  80092e:	4505                	li	a0,1
  800930:	875ff0ef          	jal	8001a4 <fprintf>
  800934:	6985                	lui	s3,0x1
  800936:	19f9                	addi	s3,s3,-2 # ffe <open-0x7ff022>
  800938:	4401                	li	s0,0
  80093a:	448d                	li	s1,3
  80093c:	497d                	li	s2,31
  80093e:	4a21                	li	s4,8
  800940:	00002a97          	auipc	s5,0x2
  800944:	7c8a8a93          	addi	s5,s5,1992 # 803108 <buffer.2>
  800948:	4605                	li	a2,1
  80094a:	00f10593          	addi	a1,sp,15
  80094e:	4501                	li	a0,0
  800950:	ed8ff0ef          	jal	800028 <read>
  800954:	04054163          	bltz	a0,800996 <readline+0x84>
  800958:	c549                	beqz	a0,8009e2 <readline+0xd0>
  80095a:	00f14603          	lbu	a2,15(sp)
  80095e:	02960c63          	beq	a2,s1,800996 <readline+0x84>
  800962:	04c97463          	bgeu	s2,a2,8009aa <readline+0x98>
  800966:	fe89c1e3          	blt	s3,s0,800948 <readline+0x36>
  80096a:	00000597          	auipc	a1,0x0
  80096e:	6e658593          	addi	a1,a1,1766 # 801050 <main+0x3ba>
  800972:	4505                	li	a0,1
  800974:	831ff0ef          	jal	8001a4 <fprintf>
  800978:	00f14703          	lbu	a4,15(sp)
  80097c:	008a87b3          	add	a5,s5,s0
  800980:	4605                	li	a2,1
  800982:	00f10593          	addi	a1,sp,15
  800986:	4501                	li	a0,0
  800988:	00e78023          	sb	a4,0(a5)
  80098c:	2405                	addiw	s0,s0,1
  80098e:	e9aff0ef          	jal	800028 <read>
  800992:	fc0553e3          	bgez	a0,800958 <readline+0x46>
  800996:	4501                	li	a0,0
  800998:	60a6                	ld	ra,72(sp)
  80099a:	6406                	ld	s0,64(sp)
  80099c:	74e2                	ld	s1,56(sp)
  80099e:	7942                	ld	s2,48(sp)
  8009a0:	79a2                	ld	s3,40(sp)
  8009a2:	7a02                	ld	s4,32(sp)
  8009a4:	6ae2                	ld	s5,24(sp)
  8009a6:	6161                	addi	sp,sp,80
  8009a8:	8082                	ret
  8009aa:	01461d63          	bne	a2,s4,8009c4 <readline+0xb2>
  8009ae:	f8805de3          	blez	s0,800948 <readline+0x36>
  8009b2:	00000597          	auipc	a1,0x0
  8009b6:	69e58593          	addi	a1,a1,1694 # 801050 <main+0x3ba>
  8009ba:	4505                	li	a0,1
  8009bc:	fe8ff0ef          	jal	8001a4 <fprintf>
  8009c0:	347d                	addiw	s0,s0,-1
  8009c2:	b759                	j	800948 <readline+0x36>
  8009c4:	ff660793          	addi	a5,a2,-10
  8009c8:	2601                	sext.w	a2,a2
  8009ca:	c781                	beqz	a5,8009d2 <readline+0xc0>
  8009cc:	ff360793          	addi	a5,a2,-13
  8009d0:	ffa5                	bnez	a5,800948 <readline+0x36>
  8009d2:	00000597          	auipc	a1,0x0
  8009d6:	67e58593          	addi	a1,a1,1662 # 801050 <main+0x3ba>
  8009da:	4505                	li	a0,1
  8009dc:	fc8ff0ef          	jal	8001a4 <fprintf>
  8009e0:	a019                	j	8009e6 <readline+0xd4>
  8009e2:	fa805be3          	blez	s0,800998 <readline+0x86>
  8009e6:	00002517          	auipc	a0,0x2
  8009ea:	72250513          	addi	a0,a0,1826 # 803108 <buffer.2>
  8009ee:	942a                	add	s0,s0,a0
  8009f0:	00040023          	sb	zero,0(s0)
  8009f4:	b755                	j	800998 <readline+0x86>

00000000008009f6 <reopen>:
  8009f6:	7179                	addi	sp,sp,-48
  8009f8:	f406                	sd	ra,40(sp)
  8009fa:	f022                	sd	s0,32(sp)
  8009fc:	ec26                	sd	s1,24(sp)
  8009fe:	e432                	sd	a2,8(sp)
  800a00:	84ae                	mv	s1,a1
  800a02:	842a                	mv	s0,a0
  800a04:	e22ff0ef          	jal	800026 <close>
  800a08:	65a2                	ld	a1,8(sp)
  800a0a:	8526                	mv	a0,s1
  800a0c:	e14ff0ef          	jal	800020 <open>
  800a10:	87aa                	mv	a5,a0
  800a12:	00a40763          	beq	s0,a0,800a20 <reopen+0x2a>
  800a16:	fff54713          	not	a4,a0
  800a1a:	01f7571b          	srliw	a4,a4,0x1f
  800a1e:	eb19                	bnez	a4,800a34 <reopen+0x3e>
  800a20:	0007851b          	sext.w	a0,a5
  800a24:	00f05363          	blez	a5,800a2a <reopen+0x34>
  800a28:	4501                	li	a0,0
  800a2a:	70a2                	ld	ra,40(sp)
  800a2c:	7402                	ld	s0,32(sp)
  800a2e:	64e2                	ld	s1,24(sp)
  800a30:	6145                	addi	sp,sp,48
  800a32:	8082                	ret
  800a34:	e42a                	sd	a0,8(sp)
  800a36:	8522                	mv	a0,s0
  800a38:	deeff0ef          	jal	800026 <close>
  800a3c:	6522                	ld	a0,8(sp)
  800a3e:	85a2                	mv	a1,s0
  800a40:	decff0ef          	jal	80002c <dup2>
  800a44:	842a                	mv	s0,a0
  800a46:	6522                	ld	a0,8(sp)
  800a48:	ddeff0ef          	jal	800026 <close>
  800a4c:	87a2                	mv	a5,s0
  800a4e:	bfc9                	j	800a20 <reopen+0x2a>

0000000000800a50 <runcmd>:
  800a50:	711d                	addi	sp,sp,-96
  800a52:	e8a2                	sd	s0,80(sp)
  800a54:	e0ca                	sd	s2,64(sp)
  800a56:	fc4e                	sd	s3,56(sp)
  800a58:	f852                	sd	s4,48(sp)
  800a5a:	ec86                	sd	ra,88(sp)
  800a5c:	e4a6                	sd	s1,72(sp)
  800a5e:	e42a                	sd	a0,8(sp)
  800a60:	03e00413          	li	s0,62
  800a64:	07700a13          	li	s4,119
  800a68:	03b00913          	li	s2,59
  800a6c:	03c00993          	li	s3,60
  800a70:	4481                	li	s1,0
  800a72:	082c                	addi	a1,sp,24
  800a74:	0028                	addi	a0,sp,8
  800a76:	dc7ff0ef          	jal	80083c <gettoken>
  800a7a:	0c850c63          	beq	a0,s0,800b52 <runcmd+0x102>
  800a7e:	04a44163          	blt	s0,a0,800ac0 <runcmd+0x70>
  800a82:	13250063          	beq	a0,s2,800ba2 <runcmd+0x152>
  800a86:	09350a63          	beq	a0,s3,800b1a <runcmd+0xca>
  800a8a:	e535                	bnez	a0,800af6 <runcmd+0xa6>
  800a8c:	c885                	beqz	s1,800abc <runcmd+0x6c>
  800a8e:	00002417          	auipc	s0,0x2
  800a92:	57240413          	addi	s0,s0,1394 # 803000 <argv.1>
  800a96:	6008                	ld	a0,0(s0)
  800a98:	00000597          	auipc	a1,0x0
  800a9c:	68858593          	addi	a1,a1,1672 # 801120 <main+0x48a>
  800aa0:	d57ff0ef          	jal	8007f6 <strcmp>
  800aa4:	14051263          	bnez	a0,800be8 <runcmd+0x198>
  800aa8:	4789                	li	a5,2
  800aaa:	04f49e63          	bne	s1,a5,800b06 <runcmd+0xb6>
  800aae:	640c                	ld	a1,8(s0)
  800ab0:	00003517          	auipc	a0,0x3
  800ab4:	65850513          	addi	a0,a0,1624 # 804108 <shcwd>
  800ab8:	d2dff0ef          	jal	8007e4 <strcpy>
  800abc:	4781                	li	a5,0
  800abe:	a0a9                	j	800b08 <runcmd+0xb8>
  800ac0:	0f450c63          	beq	a0,s4,800bb8 <runcmd+0x168>
  800ac4:	07c00793          	li	a5,124
  800ac8:	02f51763          	bne	a0,a5,800af6 <runcmd+0xa6>
  800acc:	fb4ff0ef          	jal	800280 <fork>
  800ad0:	87aa                	mv	a5,a0
  800ad2:	18051f63          	bnez	a0,800c70 <runcmd+0x220>
  800ad6:	d50ff0ef          	jal	800026 <close>
  800ada:	4581                	li	a1,0
  800adc:	4501                	li	a0,0
  800ade:	d4eff0ef          	jal	80002c <dup2>
  800ae2:	87aa                	mv	a5,a0
  800ae4:	02054263          	bltz	a0,800b08 <runcmd+0xb8>
  800ae8:	4501                	li	a0,0
  800aea:	d3cff0ef          	jal	800026 <close>
  800aee:	4501                	li	a0,0
  800af0:	d36ff0ef          	jal	800026 <close>
  800af4:	bfb5                	j	800a70 <runcmd+0x20>
  800af6:	862a                	mv	a2,a0
  800af8:	00000597          	auipc	a1,0x0
  800afc:	60058593          	addi	a1,a1,1536 # 8010f8 <main+0x462>
  800b00:	4505                	li	a0,1
  800b02:	ea2ff0ef          	jal	8001a4 <fprintf>
  800b06:	57fd                	li	a5,-1
  800b08:	60e6                	ld	ra,88(sp)
  800b0a:	6446                	ld	s0,80(sp)
  800b0c:	64a6                	ld	s1,72(sp)
  800b0e:	6906                	ld	s2,64(sp)
  800b10:	79e2                	ld	s3,56(sp)
  800b12:	7a42                	ld	s4,48(sp)
  800b14:	853e                	mv	a0,a5
  800b16:	6125                	addi	sp,sp,96
  800b18:	8082                	ret
  800b1a:	082c                	addi	a1,sp,24
  800b1c:	0028                	addi	a0,sp,8
  800b1e:	d1fff0ef          	jal	80083c <gettoken>
  800b22:	07700793          	li	a5,119
  800b26:	10f51d63          	bne	a0,a5,800c40 <runcmd+0x1f0>
  800b2a:	f456                	sd	s5,40(sp)
  800b2c:	6ae2                	ld	s5,24(sp)
  800b2e:	4501                	li	a0,0
  800b30:	cf6ff0ef          	jal	800026 <close>
  800b34:	8556                	mv	a0,s5
  800b36:	4581                	li	a1,0
  800b38:	ce8ff0ef          	jal	800020 <open>
  800b3c:	87aa                	mv	a5,a0
  800b3e:	08054c63          	bltz	a0,800bd6 <runcmd+0x186>
  800b42:	ed41                	bnez	a0,800bda <runcmd+0x18a>
  800b44:	082c                	addi	a1,sp,24
  800b46:	0028                	addi	a0,sp,8
  800b48:	7aa2                	ld	s5,40(sp)
  800b4a:	cf3ff0ef          	jal	80083c <gettoken>
  800b4e:	f28518e3          	bne	a0,s0,800a7e <runcmd+0x2e>
  800b52:	082c                	addi	a1,sp,24
  800b54:	0028                	addi	a0,sp,8
  800b56:	ce7ff0ef          	jal	80083c <gettoken>
  800b5a:	07700793          	li	a5,119
  800b5e:	0ef51963          	bne	a0,a5,800c50 <runcmd+0x200>
  800b62:	f456                	sd	s5,40(sp)
  800b64:	6ae2                	ld	s5,24(sp)
  800b66:	4505                	li	a0,1
  800b68:	cbeff0ef          	jal	800026 <close>
  800b6c:	8556                	mv	a0,s5
  800b6e:	45d9                	li	a1,22
  800b70:	cb0ff0ef          	jal	800020 <open>
  800b74:	87aa                	mv	a5,a0
  800b76:	06054063          	bltz	a0,800bd6 <runcmd+0x186>
  800b7a:	4585                	li	a1,1
  800b7c:	fcb504e3          	beq	a0,a1,800b44 <runcmd+0xf4>
  800b80:	852e                	mv	a0,a1
  800b82:	e03e                	sd	a5,0(sp)
  800b84:	ca2ff0ef          	jal	800026 <close>
  800b88:	6502                	ld	a0,0(sp)
  800b8a:	4585                	li	a1,1
  800b8c:	ca0ff0ef          	jal	80002c <dup2>
  800b90:	8aaa                	mv	s5,a0
  800b92:	6502                	ld	a0,0(sp)
  800b94:	c92ff0ef          	jal	800026 <close>
  800b98:	fa0ad6e3          	bgez	s5,800b44 <runcmd+0xf4>
  800b9c:	87d6                	mv	a5,s5
  800b9e:	7aa2                	ld	s5,40(sp)
  800ba0:	b7a5                	j	800b08 <runcmd+0xb8>
  800ba2:	edeff0ef          	jal	800280 <fork>
  800ba6:	87aa                	mv	a5,a0
  800ba8:	ee0502e3          	beqz	a0,800a8c <runcmd+0x3c>
  800bac:	f4054ee3          	bltz	a0,800b08 <runcmd+0xb8>
  800bb0:	4581                	li	a1,0
  800bb2:	ed0ff0ef          	jal	800282 <waitpid>
  800bb6:	bd6d                	j	800a70 <runcmd+0x20>
  800bb8:	02000793          	li	a5,32
  800bbc:	0af48263          	beq	s1,a5,800c60 <runcmd+0x210>
  800bc0:	6762                	ld	a4,24(sp)
  800bc2:	00349693          	slli	a3,s1,0x3
  800bc6:	00002797          	auipc	a5,0x2
  800bca:	43a78793          	addi	a5,a5,1082 # 803000 <argv.1>
  800bce:	97b6                	add	a5,a5,a3
  800bd0:	2485                	addiw	s1,s1,1
  800bd2:	e398                	sd	a4,0(a5)
  800bd4:	bd79                	j	800a72 <runcmd+0x22>
  800bd6:	7aa2                	ld	s5,40(sp)
  800bd8:	bf05                	j	800b08 <runcmd+0xb8>
  800bda:	4501                	li	a0,0
  800bdc:	e03e                	sd	a5,0(sp)
  800bde:	c48ff0ef          	jal	800026 <close>
  800be2:	6502                	ld	a0,0(sp)
  800be4:	4581                	li	a1,0
  800be6:	b75d                	j	800b8c <runcmd+0x13c>
  800be8:	6008                	ld	a0,0(s0)
  800bea:	4581                	li	a1,0
  800bec:	c34ff0ef          	jal	800020 <open>
  800bf0:	87aa                	mv	a5,a0
  800bf2:	02054263          	bltz	a0,800c16 <runcmd+0x1c6>
  800bf6:	c30ff0ef          	jal	800026 <close>
  800bfa:	00349793          	slli	a5,s1,0x3
  800bfe:	97a2                	add	a5,a5,s0
  800c00:	0007b023          	sd	zero,0(a5)
  800c04:	6008                	ld	a0,0(s0)
  800c06:	00002597          	auipc	a1,0x2
  800c0a:	3fa58593          	addi	a1,a1,1018 # 803000 <argv.1>
  800c0e:	e76ff0ef          	jal	800284 <__exec>
  800c12:	87aa                	mv	a5,a0
  800c14:	bdd5                	j	800b08 <runcmd+0xb8>
  800c16:	5741                	li	a4,-16
  800c18:	eee518e3          	bne	a0,a4,800b08 <runcmd+0xb8>
  800c1c:	6014                	ld	a3,0(s0)
  800c1e:	00000617          	auipc	a2,0x0
  800c22:	50a60613          	addi	a2,a2,1290 # 801128 <main+0x492>
  800c26:	6585                	lui	a1,0x1
  800c28:	00001517          	auipc	a0,0x1
  800c2c:	3d850513          	addi	a0,a0,984 # 802000 <argv0.0>
  800c30:	b4bff0ef          	jal	80077a <snprintf>
  800c34:	00001797          	auipc	a5,0x1
  800c38:	3cc78793          	addi	a5,a5,972 # 802000 <argv0.0>
  800c3c:	e01c                	sd	a5,0(s0)
  800c3e:	bf75                	j	800bfa <runcmd+0x1aa>
  800c40:	00000597          	auipc	a1,0x0
  800c44:	45858593          	addi	a1,a1,1112 # 801098 <main+0x402>
  800c48:	4505                	li	a0,1
  800c4a:	d5aff0ef          	jal	8001a4 <fprintf>
  800c4e:	bd65                	j	800b06 <runcmd+0xb6>
  800c50:	00000597          	auipc	a1,0x0
  800c54:	47858593          	addi	a1,a1,1144 # 8010c8 <main+0x432>
  800c58:	4505                	li	a0,1
  800c5a:	d4aff0ef          	jal	8001a4 <fprintf>
  800c5e:	b565                	j	800b06 <runcmd+0xb6>
  800c60:	00000597          	auipc	a1,0x0
  800c64:	41858593          	addi	a1,a1,1048 # 801078 <main+0x3e2>
  800c68:	4505                	li	a0,1
  800c6a:	d3aff0ef          	jal	8001a4 <fprintf>
  800c6e:	bd61                	j	800b06 <runcmd+0xb6>
  800c70:	e8054ce3          	bltz	a0,800b08 <runcmd+0xb8>
  800c74:	4505                	li	a0,1
  800c76:	bb0ff0ef          	jal	800026 <close>
  800c7a:	4585                	li	a1,1
  800c7c:	4501                	li	a0,0
  800c7e:	baeff0ef          	jal	80002c <dup2>
  800c82:	87aa                	mv	a5,a0
  800c84:	e80542e3          	bltz	a0,800b08 <runcmd+0xb8>
  800c88:	4501                	li	a0,0
  800c8a:	b9cff0ef          	jal	800026 <close>
  800c8e:	4501                	li	a0,0
  800c90:	b96ff0ef          	jal	800026 <close>
  800c94:	bbe5                	j	800a8c <runcmd+0x3c>

0000000000800c96 <main>:
  800c96:	7179                	addi	sp,sp,-48
  800c98:	f022                	sd	s0,32(sp)
  800c9a:	842a                	mv	s0,a0
  800c9c:	00000517          	auipc	a0,0x0
  800ca0:	49450513          	addi	a0,a0,1172 # 801130 <main+0x49a>
  800ca4:	ec26                	sd	s1,24(sp)
  800ca6:	f406                	sd	ra,40(sp)
  800ca8:	84ae                	mv	s1,a1
  800caa:	caeff0ef          	jal	800158 <cputs>
  800cae:	4789                	li	a5,2
  800cb0:	04f40c63          	beq	s0,a5,800d08 <main+0x72>
  800cb4:	00000497          	auipc	s1,0x0
  800cb8:	4dc48493          	addi	s1,s1,1244 # 801190 <main+0x4fa>
  800cbc:	0287d063          	bge	a5,s0,800cdc <main+0x46>
  800cc0:	a059                	j	800d46 <main+0xb0>
  800cc2:	00003797          	auipc	a5,0x3
  800cc6:	44078323          	sb	zero,1094(a5) # 804108 <shcwd>
  800cca:	db6ff0ef          	jal	800280 <fork>
  800cce:	c535                	beqz	a0,800d3a <main+0xa4>
  800cd0:	04054563          	bltz	a0,800d1a <main+0x84>
  800cd4:	006c                	addi	a1,sp,12
  800cd6:	dacff0ef          	jal	800282 <waitpid>
  800cda:	cd01                	beqz	a0,800cf2 <main+0x5c>
  800cdc:	8526                	mv	a0,s1
  800cde:	c35ff0ef          	jal	800912 <readline>
  800ce2:	842a                	mv	s0,a0
  800ce4:	fd79                	bnez	a0,800cc2 <main+0x2c>
  800ce6:	4501                	li	a0,0
  800ce8:	70a2                	ld	ra,40(sp)
  800cea:	7402                	ld	s0,32(sp)
  800cec:	64e2                	ld	s1,24(sp)
  800cee:	6145                	addi	sp,sp,48
  800cf0:	8082                	ret
  800cf2:	46b2                	lw	a3,12(sp)
  800cf4:	d6e5                	beqz	a3,800cdc <main+0x46>
  800cf6:	8636                	mv	a2,a3
  800cf8:	00000597          	auipc	a1,0x0
  800cfc:	48858593          	addi	a1,a1,1160 # 801180 <main+0x4ea>
  800d00:	4505                	li	a0,1
  800d02:	ca2ff0ef          	jal	8001a4 <fprintf>
  800d06:	bfd9                	j	800cdc <main+0x46>
  800d08:	648c                	ld	a1,8(s1)
  800d0a:	4601                	li	a2,0
  800d0c:	4501                	li	a0,0
  800d0e:	ce9ff0ef          	jal	8009f6 <reopen>
  800d12:	c62a                	sw	a0,12(sp)
  800d14:	4481                	li	s1,0
  800d16:	d179                	beqz	a0,800cdc <main+0x46>
  800d18:	bfc1                	j	800ce8 <main+0x52>
  800d1a:	00000697          	auipc	a3,0x0
  800d1e:	42e68693          	addi	a3,a3,1070 # 801148 <main+0x4b2>
  800d22:	00000617          	auipc	a2,0x0
  800d26:	43660613          	addi	a2,a2,1078 # 801158 <main+0x4c2>
  800d2a:	0f200593          	li	a1,242
  800d2e:	00000517          	auipc	a0,0x0
  800d32:	44250513          	addi	a0,a0,1090 # 801170 <main+0x4da>
  800d36:	afeff0ef          	jal	800034 <__panic>
  800d3a:	8522                	mv	a0,s0
  800d3c:	d15ff0ef          	jal	800a50 <runcmd>
  800d40:	c62a                	sw	a0,12(sp)
  800d42:	d28ff0ef          	jal	80026a <exit>
  800d46:	00000597          	auipc	a1,0x0
  800d4a:	31258593          	addi	a1,a1,786 # 801058 <main+0x3c2>
  800d4e:	4505                	li	a0,1
  800d50:	c54ff0ef          	jal	8001a4 <fprintf>
  800d54:	557d                	li	a0,-1
  800d56:	bf49                	j	800ce8 <main+0x52>
