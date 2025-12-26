
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0212ff0 <bootstack+0x1ff0>
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	6fa0b0ef          	jal	ffffffffc020b75c <memset>
ffffffffc0200066:	4da000ef          	jal	ffffffffc0200540 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	75e58593          	addi	a1,a1,1886 # ffffffffc020b7c8 <etext+0x4>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	77650513          	addi	a0,a0,1910 # ffffffffc020b7e8 <etext+0x24>
ffffffffc020007a:	12c000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200082:	5f4000ef          	jal	ffffffffc0200676 <dtb_init>
ffffffffc0200086:	29b020ef          	jal	ffffffffc0202b20 <pmm_init>
ffffffffc020008a:	355000ef          	jal	ffffffffc0200bde <pic_init>
ffffffffc020008e:	477000ef          	jal	ffffffffc0200d04 <idt_init>
ffffffffc0200092:	75d030ef          	jal	ffffffffc0203fee <vmm_init>
ffffffffc0200096:	2c2070ef          	jal	ffffffffc0207358 <sched_init>
ffffffffc020009a:	6cd060ef          	jal	ffffffffc0206f66 <proc_init>
ffffffffc020009e:	11f000ef          	jal	ffffffffc02009bc <ide_init>
ffffffffc02000a2:	1b2050ef          	jal	ffffffffc0205254 <fs_init>
ffffffffc02000a6:	452000ef          	jal	ffffffffc02004f8 <clock_init>
ffffffffc02000aa:	329000ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02000ae:	08c070ef          	jal	ffffffffc020713a <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	7179                	addi	sp,sp,-48
ffffffffc02000b4:	f406                	sd	ra,40(sp)
ffffffffc02000b6:	f022                	sd	s0,32(sp)
ffffffffc02000b8:	ec26                	sd	s1,24(sp)
ffffffffc02000ba:	e84a                	sd	s2,16(sp)
ffffffffc02000bc:	e44e                	sd	s3,8(sp)
ffffffffc02000be:	c901                	beqz	a0,ffffffffc02000ce <readline+0x1c>
ffffffffc02000c0:	85aa                	mv	a1,a0
ffffffffc02000c2:	0000b517          	auipc	a0,0xb
ffffffffc02000c6:	72e50513          	addi	a0,a0,1838 # ffffffffc020b7f0 <etext+0x2c>
ffffffffc02000ca:	0dc000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02000ce:	4481                	li	s1,0
ffffffffc02000d0:	497d                	li	s2,31
ffffffffc02000d2:	00091997          	auipc	s3,0x91
ffffffffc02000d6:	f8e98993          	addi	s3,s3,-114 # ffffffffc0291060 <buf>
ffffffffc02000da:	108000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc02000de:	842a                	mv	s0,a0
ffffffffc02000e0:	ff850793          	addi	a5,a0,-8
ffffffffc02000e4:	3ff4a713          	slti	a4,s1,1023
ffffffffc02000e8:	ff650693          	addi	a3,a0,-10
ffffffffc02000ec:	ff350613          	addi	a2,a0,-13
ffffffffc02000f0:	02054963          	bltz	a0,ffffffffc0200122 <readline+0x70>
ffffffffc02000f4:	02a95f63          	bge	s2,a0,ffffffffc0200132 <readline+0x80>
ffffffffc02000f8:	cf0d                	beqz	a4,ffffffffc0200132 <readline+0x80>
ffffffffc02000fa:	0e6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02000fe:	009987b3          	add	a5,s3,s1
ffffffffc0200102:	00878023          	sb	s0,0(a5)
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	0da000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc020010c:	842a                	mv	s0,a0
ffffffffc020010e:	ff850793          	addi	a5,a0,-8
ffffffffc0200112:	3ff4a713          	slti	a4,s1,1023
ffffffffc0200116:	ff650693          	addi	a3,a0,-10
ffffffffc020011a:	ff350613          	addi	a2,a0,-13
ffffffffc020011e:	fc055be3          	bgez	a0,ffffffffc02000f4 <readline+0x42>
ffffffffc0200122:	70a2                	ld	ra,40(sp)
ffffffffc0200124:	7402                	ld	s0,32(sp)
ffffffffc0200126:	64e2                	ld	s1,24(sp)
ffffffffc0200128:	6942                	ld	s2,16(sp)
ffffffffc020012a:	69a2                	ld	s3,8(sp)
ffffffffc020012c:	4501                	li	a0,0
ffffffffc020012e:	6145                	addi	sp,sp,48
ffffffffc0200130:	8082                	ret
ffffffffc0200132:	eb81                	bnez	a5,ffffffffc0200142 <readline+0x90>
ffffffffc0200134:	4521                	li	a0,8
ffffffffc0200136:	00905663          	blez	s1,ffffffffc0200142 <readline+0x90>
ffffffffc020013a:	0a6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020013e:	34fd                	addiw	s1,s1,-1
ffffffffc0200140:	bf69                	j	ffffffffc02000da <readline+0x28>
ffffffffc0200142:	c291                	beqz	a3,ffffffffc0200146 <readline+0x94>
ffffffffc0200144:	fa59                	bnez	a2,ffffffffc02000da <readline+0x28>
ffffffffc0200146:	8522                	mv	a0,s0
ffffffffc0200148:	098000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020014c:	00091517          	auipc	a0,0x91
ffffffffc0200150:	f1450513          	addi	a0,a0,-236 # ffffffffc0291060 <buf>
ffffffffc0200154:	94aa                	add	s1,s1,a0
ffffffffc0200156:	00048023          	sb	zero,0(s1)
ffffffffc020015a:	70a2                	ld	ra,40(sp)
ffffffffc020015c:	7402                	ld	s0,32(sp)
ffffffffc020015e:	64e2                	ld	s1,24(sp)
ffffffffc0200160:	6942                	ld	s2,16(sp)
ffffffffc0200162:	69a2                	ld	s3,8(sp)
ffffffffc0200164:	6145                	addi	sp,sp,48
ffffffffc0200166:	8082                	ret

ffffffffc0200168 <cputch>:
ffffffffc0200168:	1101                	addi	sp,sp,-32
ffffffffc020016a:	ec06                	sd	ra,24(sp)
ffffffffc020016c:	e42e                	sd	a1,8(sp)
ffffffffc020016e:	3e0000ef          	jal	ffffffffc020054e <cons_putc>
ffffffffc0200172:	65a2                	ld	a1,8(sp)
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	419c                	lw	a5,0(a1)
ffffffffc0200178:	2785                	addiw	a5,a5,1
ffffffffc020017a:	c19c                	sw	a5,0(a1)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fde50513          	addi	a0,a0,-34 # ffffffffc0200168 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	1260b0ef          	jal	ffffffffc020b2c0 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40
ffffffffc02001ac:	f42e                	sd	a1,40(sp)
ffffffffc02001ae:	75dd                	lui	a1,0xffff7
ffffffffc02001b0:	f832                	sd	a2,48(sp)
ffffffffc02001b2:	fc36                	sd	a3,56(sp)
ffffffffc02001b4:	e0ba                	sd	a4,64(sp)
ffffffffc02001b6:	86aa                	mv	a3,a0
ffffffffc02001b8:	0050                	addi	a2,sp,4
ffffffffc02001ba:	00000517          	auipc	a0,0x0
ffffffffc02001be:	fae50513          	addi	a0,a0,-82 # ffffffffc0200168 <cputch>
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001c8:	ec06                	sd	ra,24(sp)
ffffffffc02001ca:	e4be                	sd	a5,72(sp)
ffffffffc02001cc:	e8c2                	sd	a6,80(sp)
ffffffffc02001ce:	ecc6                	sd	a7,88(sp)
ffffffffc02001d0:	c202                	sw	zero,4(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	0ec0b0ef          	jal	ffffffffc020b2c0 <vprintfmt>
ffffffffc02001d8:	60e2                	ld	ra,24(sp)
ffffffffc02001da:	4512                	lw	a0,4(sp)
ffffffffc02001dc:	6125                	addi	sp,sp,96
ffffffffc02001de:	8082                	ret

ffffffffc02001e0 <cputchar>:
ffffffffc02001e0:	a6bd                	j	ffffffffc020054e <cons_putc>

ffffffffc02001e2 <getchar>:
ffffffffc02001e2:	1141                	addi	sp,sp,-16
ffffffffc02001e4:	e406                	sd	ra,8(sp)
ffffffffc02001e6:	3d0000ef          	jal	ffffffffc02005b6 <cons_getc>
ffffffffc02001ea:	dd75                	beqz	a0,ffffffffc02001e6 <getchar+0x4>
ffffffffc02001ec:	60a2                	ld	ra,8(sp)
ffffffffc02001ee:	0141                	addi	sp,sp,16
ffffffffc02001f0:	8082                	ret

ffffffffc02001f2 <strdup>:
ffffffffc02001f2:	7179                	addi	sp,sp,-48
ffffffffc02001f4:	f406                	sd	ra,40(sp)
ffffffffc02001f6:	f022                	sd	s0,32(sp)
ffffffffc02001f8:	ec26                	sd	s1,24(sp)
ffffffffc02001fa:	84aa                	mv	s1,a0
ffffffffc02001fc:	4ac0b0ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc0200200:	842a                	mv	s0,a0
ffffffffc0200202:	0505                	addi	a0,a0,1
ffffffffc0200204:	5bd010ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0200208:	87aa                	mv	a5,a0
ffffffffc020020a:	c911                	beqz	a0,ffffffffc020021e <strdup+0x2c>
ffffffffc020020c:	8622                	mv	a2,s0
ffffffffc020020e:	85a6                	mv	a1,s1
ffffffffc0200210:	e42a                	sd	a0,8(sp)
ffffffffc0200212:	59a0b0ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0200216:	67a2                	ld	a5,8(sp)
ffffffffc0200218:	943e                	add	s0,s0,a5
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	70a2                	ld	ra,40(sp)
ffffffffc0200220:	7402                	ld	s0,32(sp)
ffffffffc0200222:	64e2                	ld	s1,24(sp)
ffffffffc0200224:	853e                	mv	a0,a5
ffffffffc0200226:	6145                	addi	sp,sp,48
ffffffffc0200228:	8082                	ret

ffffffffc020022a <print_kerninfo>:
ffffffffc020022a:	1141                	addi	sp,sp,-16
ffffffffc020022c:	0000b517          	auipc	a0,0xb
ffffffffc0200230:	5cc50513          	addi	a0,a0,1484 # ffffffffc020b7f8 <etext+0x34>
ffffffffc0200234:	e406                	sd	ra,8(sp)
ffffffffc0200236:	f71ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000b517          	auipc	a0,0xb
ffffffffc0200246:	5d650513          	addi	a0,a0,1494 # ffffffffc020b818 <etext+0x54>
ffffffffc020024a:	f5dff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020024e:	0000b597          	auipc	a1,0xb
ffffffffc0200252:	57658593          	addi	a1,a1,1398 # ffffffffc020b7c4 <etext>
ffffffffc0200256:	0000b517          	auipc	a0,0xb
ffffffffc020025a:	5e250513          	addi	a0,a0,1506 # ffffffffc020b838 <etext+0x74>
ffffffffc020025e:	f49ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200262:	00091597          	auipc	a1,0x91
ffffffffc0200266:	dfe58593          	addi	a1,a1,-514 # ffffffffc0291060 <buf>
ffffffffc020026a:	0000b517          	auipc	a0,0xb
ffffffffc020026e:	5ee50513          	addi	a0,a0,1518 # ffffffffc020b858 <etext+0x94>
ffffffffc0200272:	f35ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200276:	00096597          	auipc	a1,0x96
ffffffffc020027a:	69a58593          	addi	a1,a1,1690 # ffffffffc0296910 <end>
ffffffffc020027e:	0000b517          	auipc	a0,0xb
ffffffffc0200282:	5fa50513          	addi	a0,a0,1530 # ffffffffc020b878 <etext+0xb4>
ffffffffc0200286:	f21ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	00097797          	auipc	a5,0x97
ffffffffc0200296:	a7d78793          	addi	a5,a5,-1411 # ffffffffc0296d0f <end+0x3ff>
ffffffffc020029a:	8f99                	sub	a5,a5,a4
ffffffffc020029c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a6:	95be                	add	a1,a1,a5
ffffffffc02002a8:	85a9                	srai	a1,a1,0xa
ffffffffc02002aa:	0000b517          	auipc	a0,0xb
ffffffffc02002ae:	5ee50513          	addi	a0,a0,1518 # ffffffffc020b898 <etext+0xd4>
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	bdcd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002b6 <print_stackframe>:
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	0000b617          	auipc	a2,0xb
ffffffffc02002bc:	61060613          	addi	a2,a2,1552 # ffffffffc020b8c8 <etext+0x104>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	0000b517          	auipc	a0,0xb
ffffffffc02002c8:	61c50513          	addi	a0,a0,1564 # ffffffffc020b8e0 <etext+0x11c>
ffffffffc02002cc:	e406                	sd	ra,8(sp)
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	0000f417          	auipc	s0,0xf
ffffffffc02002de:	b2640413          	addi	s0,s0,-1242 # ffffffffc020ee00 <commands>
ffffffffc02002e2:	0000f497          	auipc	s1,0xf
ffffffffc02002e6:	b6648493          	addi	s1,s1,-1178 # ffffffffc020ee48 <commands+0x48>
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	0000b517          	auipc	a0,0xb
ffffffffc02002f2:	60a50513          	addi	a0,a0,1546 # ffffffffc020b8f8 <etext+0x134>
ffffffffc02002f6:	0461                	addi	s0,s0,24
ffffffffc02002f8:	eafff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02002fc:	fe9417e3          	bne	s0,s1,ffffffffc02002ea <mon_help+0x18>
ffffffffc0200300:	60e2                	ld	ra,24(sp)
ffffffffc0200302:	6442                	ld	s0,16(sp)
ffffffffc0200304:	64a2                	ld	s1,8(sp)
ffffffffc0200306:	4501                	li	a0,0
ffffffffc0200308:	6105                	addi	sp,sp,32
ffffffffc020030a:	8082                	ret

ffffffffc020030c <mon_kerninfo>:
ffffffffc020030c:	1141                	addi	sp,sp,-16
ffffffffc020030e:	e406                	sd	ra,8(sp)
ffffffffc0200310:	f1bff0ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200314:	60a2                	ld	ra,8(sp)
ffffffffc0200316:	4501                	li	a0,0
ffffffffc0200318:	0141                	addi	sp,sp,16
ffffffffc020031a:	8082                	ret

ffffffffc020031c <mon_backtrace>:
ffffffffc020031c:	1141                	addi	sp,sp,-16
ffffffffc020031e:	e406                	sd	ra,8(sp)
ffffffffc0200320:	f97ff0ef          	jal	ffffffffc02002b6 <print_stackframe>
ffffffffc0200324:	60a2                	ld	ra,8(sp)
ffffffffc0200326:	4501                	li	a0,0
ffffffffc0200328:	0141                	addi	sp,sp,16
ffffffffc020032a:	8082                	ret

ffffffffc020032c <kmonitor>:
ffffffffc020032c:	7131                	addi	sp,sp,-192
ffffffffc020032e:	e952                	sd	s4,144(sp)
ffffffffc0200330:	8a2a                	mv	s4,a0
ffffffffc0200332:	0000b517          	auipc	a0,0xb
ffffffffc0200336:	5d650513          	addi	a0,a0,1494 # ffffffffc020b908 <etext+0x144>
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
ffffffffc0200346:	e61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020034a:	0000b517          	auipc	a0,0xb
ffffffffc020034e:	5e650513          	addi	a0,a0,1510 # ffffffffc020b930 <etext+0x16c>
ffffffffc0200352:	e55ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	391000ef          	jal	ffffffffc0200eec <print_trapframe>
ffffffffc0200360:	0000fa97          	auipc	s5,0xf
ffffffffc0200364:	aa0a8a93          	addi	s5,s5,-1376 # ffffffffc020ee00 <commands>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	0000b517          	auipc	a0,0xb
ffffffffc020036e:	5ee50513          	addi	a0,a0,1518 # ffffffffc020b958 <etext+0x194>
ffffffffc0200372:	d41ff0ef          	jal	ffffffffc02000b2 <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
ffffffffc020037e:	4481                	li	s1,0
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc0200382:	8b26                	mv	s6,s1
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	0000f497          	auipc	s1,0xf
ffffffffc020038c:	a7848493          	addi	s1,s1,-1416 # ffffffffc020ee00 <commands>
ffffffffc0200390:	4401                	li	s0,0
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	3580b0ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc020039a:	478d                	li	a5,3
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	0000b517          	auipc	a0,0xb
ffffffffc02003ac:	5e050513          	addi	a0,a0,1504 # ffffffffc020b988 <etext+0x1c4>
ffffffffc02003b0:	df7ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
ffffffffc02003b6:	0000b517          	auipc	a0,0xb
ffffffffc02003ba:	5aa50513          	addi	a0,a0,1450 # ffffffffc020b960 <etext+0x19c>
ffffffffc02003be:	38c0b0ef          	jal	ffffffffc020b74a <strchr>
ffffffffc02003c2:	c901                	beqz	a0,ffffffffc02003d2 <kmonitor+0xa6>
ffffffffc02003c4:	00144583          	lbu	a1,1(s0)
ffffffffc02003c8:	00040023          	sb	zero,0(s0)
ffffffffc02003cc:	0405                	addi	s0,s0,1
ffffffffc02003ce:	d9d5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d0:	b7dd                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc02003d2:	00044783          	lbu	a5,0(s0)
ffffffffc02003d6:	d7d5                	beqz	a5,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d8:	03348b63          	beq	s1,s3,ffffffffc020040e <kmonitor+0xe2>
ffffffffc02003dc:	00349793          	slli	a5,s1,0x3
ffffffffc02003e0:	978a                	add	a5,a5,sp
ffffffffc02003e2:	e380                	sd	s0,0(a5)
ffffffffc02003e4:	00044583          	lbu	a1,0(s0)
ffffffffc02003e8:	2485                	addiw	s1,s1,1
ffffffffc02003ea:	8b26                	mv	s6,s1
ffffffffc02003ec:	e591                	bnez	a1,ffffffffc02003f8 <kmonitor+0xcc>
ffffffffc02003ee:	bf59                	j	ffffffffc0200384 <kmonitor+0x58>
ffffffffc02003f0:	00144583          	lbu	a1,1(s0)
ffffffffc02003f4:	0405                	addi	s0,s0,1
ffffffffc02003f6:	d5d1                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003f8:	0000b517          	auipc	a0,0xb
ffffffffc02003fc:	56850513          	addi	a0,a0,1384 # ffffffffc020b960 <etext+0x19c>
ffffffffc0200400:	34a0b0ef          	jal	ffffffffc020b74a <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	0000b517          	auipc	a0,0xb
ffffffffc0200414:	55850513          	addi	a0,a0,1368 # ffffffffc020b968 <etext+0x1a4>
ffffffffc0200418:	d8fff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020041c:	b7c1                	j	ffffffffc02003dc <kmonitor+0xb0>
ffffffffc020041e:	00141793          	slli	a5,s0,0x1
ffffffffc0200422:	97a2                	add	a5,a5,s0
ffffffffc0200424:	078e                	slli	a5,a5,0x3
ffffffffc0200426:	97d6                	add	a5,a5,s5
ffffffffc0200428:	6b9c                	ld	a5,16(a5)
ffffffffc020042a:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042e:	8652                	mv	a2,s4
ffffffffc0200430:	002c                	addi	a1,sp,8
ffffffffc0200432:	9782                	jalr	a5
ffffffffc0200434:	f2055be3          	bgez	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200438:	70ea                	ld	ra,184(sp)
ffffffffc020043a:	744a                	ld	s0,176(sp)
ffffffffc020043c:	74aa                	ld	s1,168(sp)
ffffffffc020043e:	69ea                	ld	s3,152(sp)
ffffffffc0200440:	6a4a                	ld	s4,144(sp)
ffffffffc0200442:	6aaa                	ld	s5,136(sp)
ffffffffc0200444:	6b0a                	ld	s6,128(sp)
ffffffffc0200446:	6129                	addi	sp,sp,192
ffffffffc0200448:	8082                	ret

ffffffffc020044a <__panic>:
ffffffffc020044a:	00096317          	auipc	t1,0x96
ffffffffc020044e:	41e33303          	ld	t1,1054(t1) # ffffffffc0296868 <is_panic>
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	f436                	sd	a3,40(sp)
ffffffffc0200458:	f83a                	sd	a4,48(sp)
ffffffffc020045a:	fc3e                	sd	a5,56(sp)
ffffffffc020045c:	e0c2                	sd	a6,64(sp)
ffffffffc020045e:	e4c6                	sd	a7,72(sp)
ffffffffc0200460:	02031e63          	bnez	t1,ffffffffc020049c <__panic+0x52>
ffffffffc0200464:	4705                	li	a4,1
ffffffffc0200466:	103c                	addi	a5,sp,40
ffffffffc0200468:	e822                	sd	s0,16(sp)
ffffffffc020046a:	8432                	mv	s0,a2
ffffffffc020046c:	862e                	mv	a2,a1
ffffffffc020046e:	85aa                	mv	a1,a0
ffffffffc0200470:	0000b517          	auipc	a0,0xb
ffffffffc0200474:	5c050513          	addi	a0,a0,1472 # ffffffffc020ba30 <etext+0x26c>
ffffffffc0200478:	00096697          	auipc	a3,0x96
ffffffffc020047c:	3ee6b823          	sd	a4,1008(a3) # ffffffffc0296868 <is_panic>
ffffffffc0200480:	e43e                	sd	a5,8(sp)
ffffffffc0200482:	d25ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cf7ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc020048e:	0000b517          	auipc	a0,0xb
ffffffffc0200492:	5c250513          	addi	a0,a0,1474 # ffffffffc020ba50 <etext+0x28c>
ffffffffc0200496:	d11ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020049a:	6442                	ld	s0,16(sp)
ffffffffc020049c:	4501                	li	a0,0
ffffffffc020049e:	4581                	li	a1,0
ffffffffc02004a0:	4601                	li	a2,0
ffffffffc02004a2:	48a1                	li	a7,8
ffffffffc02004a4:	00000073          	ecall
ffffffffc02004a8:	730000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02004ac:	4501                	li	a0,0
ffffffffc02004ae:	e7fff0ef          	jal	ffffffffc020032c <kmonitor>
ffffffffc02004b2:	bfed                	j	ffffffffc02004ac <__panic+0x62>

ffffffffc02004b4 <__warn>:
ffffffffc02004b4:	715d                	addi	sp,sp,-80
ffffffffc02004b6:	e822                	sd	s0,16(sp)
ffffffffc02004b8:	02810313          	addi	t1,sp,40
ffffffffc02004bc:	8432                	mv	s0,a2
ffffffffc02004be:	862e                	mv	a2,a1
ffffffffc02004c0:	85aa                	mv	a1,a0
ffffffffc02004c2:	0000b517          	auipc	a0,0xb
ffffffffc02004c6:	59650513          	addi	a0,a0,1430 # ffffffffc020ba58 <etext+0x294>
ffffffffc02004ca:	ec06                	sd	ra,24(sp)
ffffffffc02004cc:	f436                	sd	a3,40(sp)
ffffffffc02004ce:	f83a                	sd	a4,48(sp)
ffffffffc02004d0:	fc3e                	sd	a5,56(sp)
ffffffffc02004d2:	e0c2                	sd	a6,64(sp)
ffffffffc02004d4:	e4c6                	sd	a7,72(sp)
ffffffffc02004d6:	e41a                	sd	t1,8(sp)
ffffffffc02004d8:	ccfff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004dc:	65a2                	ld	a1,8(sp)
ffffffffc02004de:	8522                	mv	a0,s0
ffffffffc02004e0:	ca1ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc02004e4:	0000b517          	auipc	a0,0xb
ffffffffc02004e8:	56c50513          	addi	a0,a0,1388 # ffffffffc020ba50 <etext+0x28c>
ffffffffc02004ec:	cbbff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004f0:	60e2                	ld	ra,24(sp)
ffffffffc02004f2:	6442                	ld	s0,16(sp)
ffffffffc02004f4:	6161                	addi	sp,sp,80
ffffffffc02004f6:	8082                	ret

ffffffffc02004f8 <clock_init>:
ffffffffc02004f8:	02000793          	li	a5,32
ffffffffc02004fc:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200500:	c0102573          	rdtime	a0
ffffffffc0200504:	67e1                	lui	a5,0x18
ffffffffc0200506:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020050a:	953e                	add	a0,a0,a5
ffffffffc020050c:	4581                	li	a1,0
ffffffffc020050e:	4601                	li	a2,0
ffffffffc0200510:	4881                	li	a7,0
ffffffffc0200512:	00000073          	ecall
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	56250513          	addi	a0,a0,1378 # ffffffffc020ba78 <etext+0x2b4>
ffffffffc020051e:	00096797          	auipc	a5,0x96
ffffffffc0200522:	3407b923          	sd	zero,850(a5) # ffffffffc0296870 <ticks>
ffffffffc0200526:	b141                	j	ffffffffc02001a6 <cprintf>

ffffffffc0200528 <clock_set_next_event>:
ffffffffc0200528:	c0102573          	rdtime	a0
ffffffffc020052c:	67e1                	lui	a5,0x18
ffffffffc020052e:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200532:	953e                	add	a0,a0,a5
ffffffffc0200534:	4581                	li	a1,0
ffffffffc0200536:	4601                	li	a2,0
ffffffffc0200538:	4881                	li	a7,0
ffffffffc020053a:	00000073          	ecall
ffffffffc020053e:	8082                	ret

ffffffffc0200540 <cons_init>:
ffffffffc0200540:	4501                	li	a0,0
ffffffffc0200542:	4581                	li	a1,0
ffffffffc0200544:	4601                	li	a2,0
ffffffffc0200546:	4889                	li	a7,2
ffffffffc0200548:	00000073          	ecall
ffffffffc020054c:	8082                	ret

ffffffffc020054e <cons_putc>:
ffffffffc020054e:	1101                	addi	sp,sp,-32
ffffffffc0200550:	ec06                	sd	ra,24(sp)
ffffffffc0200552:	100027f3          	csrr	a5,sstatus
ffffffffc0200556:	8b89                	andi	a5,a5,2
ffffffffc0200558:	ef95                	bnez	a5,ffffffffc0200594 <cons_putc+0x46>
ffffffffc020055a:	47a1                	li	a5,8
ffffffffc020055c:	00f50a63          	beq	a0,a5,ffffffffc0200570 <cons_putc+0x22>
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4885                	li	a7,1
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	60e2                	ld	ra,24(sp)
ffffffffc020056c:	6105                	addi	sp,sp,32
ffffffffc020056e:	8082                	ret
ffffffffc0200570:	4781                	li	a5,0
ffffffffc0200572:	4521                	li	a0,8
ffffffffc0200574:	4581                	li	a1,0
ffffffffc0200576:	4601                	li	a2,0
ffffffffc0200578:	4885                	li	a7,1
ffffffffc020057a:	00000073          	ecall
ffffffffc020057e:	02000513          	li	a0,32
ffffffffc0200582:	00000073          	ecall
ffffffffc0200586:	4521                	li	a0,8
ffffffffc0200588:	00000073          	ecall
ffffffffc020058c:	dff9                	beqz	a5,ffffffffc020056a <cons_putc+0x1c>
ffffffffc020058e:	60e2                	ld	ra,24(sp)
ffffffffc0200590:	6105                	addi	sp,sp,32
ffffffffc0200592:	a581                	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0200594:	e42a                	sd	a0,8(sp)
ffffffffc0200596:	642000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020059a:	6522                	ld	a0,8(sp)
ffffffffc020059c:	47a1                	li	a5,8
ffffffffc020059e:	00f50a63          	beq	a0,a5,ffffffffc02005b2 <cons_putc+0x64>
ffffffffc02005a2:	4581                	li	a1,0
ffffffffc02005a4:	4601                	li	a2,0
ffffffffc02005a6:	4885                	li	a7,1
ffffffffc02005a8:	00000073          	ecall
ffffffffc02005ac:	60e2                	ld	ra,24(sp)
ffffffffc02005ae:	6105                	addi	sp,sp,32
ffffffffc02005b0:	a50d                	j	ffffffffc0200bd2 <intr_enable>
ffffffffc02005b2:	4785                	li	a5,1
ffffffffc02005b4:	bf7d                	j	ffffffffc0200572 <cons_putc+0x24>

ffffffffc02005b6 <cons_getc>:
ffffffffc02005b6:	1101                	addi	sp,sp,-32
ffffffffc02005b8:	ec06                	sd	ra,24(sp)
ffffffffc02005ba:	100027f3          	csrr	a5,sstatus
ffffffffc02005be:	8b89                	andi	a5,a5,2
ffffffffc02005c0:	4801                	li	a6,0
ffffffffc02005c2:	e7d5                	bnez	a5,ffffffffc020066e <cons_getc+0xb8>
ffffffffc02005c4:	00091697          	auipc	a3,0x91
ffffffffc02005c8:	e9c68693          	addi	a3,a3,-356 # ffffffffc0291460 <cons>
ffffffffc02005cc:	07f00713          	li	a4,127
ffffffffc02005d0:	4501                	li	a0,0
ffffffffc02005d2:	4581                	li	a1,0
ffffffffc02005d4:	4601                	li	a2,0
ffffffffc02005d6:	4889                	li	a7,2
ffffffffc02005d8:	00000073          	ecall
ffffffffc02005dc:	0005079b          	sext.w	a5,a0
ffffffffc02005e0:	0207cd63          	bltz	a5,ffffffffc020061a <cons_getc+0x64>
ffffffffc02005e4:	02e78963          	beq	a5,a4,ffffffffc0200616 <cons_getc+0x60>
ffffffffc02005e8:	d7e5                	beqz	a5,ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc02005ea:	00091797          	auipc	a5,0x91
ffffffffc02005ee:	07a7a783          	lw	a5,122(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc02005f2:	20000593          	li	a1,512
ffffffffc02005f6:	02079613          	slli	a2,a5,0x20
ffffffffc02005fa:	9201                	srli	a2,a2,0x20
ffffffffc02005fc:	2785                	addiw	a5,a5,1
ffffffffc02005fe:	9636                	add	a2,a2,a3
ffffffffc0200600:	20f6a223          	sw	a5,516(a3)
ffffffffc0200604:	00a60023          	sb	a0,0(a2)
ffffffffc0200608:	fcb794e3          	bne	a5,a1,ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc020060c:	00091797          	auipc	a5,0x91
ffffffffc0200610:	0407ac23          	sw	zero,88(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200614:	bf75                	j	ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc0200616:	4521                	li	a0,8
ffffffffc0200618:	bfc9                	j	ffffffffc02005ea <cons_getc+0x34>
ffffffffc020061a:	00091797          	auipc	a5,0x91
ffffffffc020061e:	0467a783          	lw	a5,70(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200622:	00091717          	auipc	a4,0x91
ffffffffc0200626:	04272703          	lw	a4,66(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc020062a:	4501                	li	a0,0
ffffffffc020062c:	00f70f63          	beq	a4,a5,ffffffffc020064a <cons_getc+0x94>
ffffffffc0200630:	02079713          	slli	a4,a5,0x20
ffffffffc0200634:	9301                	srli	a4,a4,0x20
ffffffffc0200636:	2785                	addiw	a5,a5,1
ffffffffc0200638:	20f6a023          	sw	a5,512(a3)
ffffffffc020063c:	96ba                	add	a3,a3,a4
ffffffffc020063e:	20000713          	li	a4,512
ffffffffc0200642:	0006c503          	lbu	a0,0(a3)
ffffffffc0200646:	00e78763          	beq	a5,a4,ffffffffc0200654 <cons_getc+0x9e>
ffffffffc020064a:	00081b63          	bnez	a6,ffffffffc0200660 <cons_getc+0xaa>
ffffffffc020064e:	60e2                	ld	ra,24(sp)
ffffffffc0200650:	6105                	addi	sp,sp,32
ffffffffc0200652:	8082                	ret
ffffffffc0200654:	00091797          	auipc	a5,0x91
ffffffffc0200658:	0007a623          	sw	zero,12(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc020065c:	fe0809e3          	beqz	a6,ffffffffc020064e <cons_getc+0x98>
ffffffffc0200660:	e42a                	sd	a0,8(sp)
ffffffffc0200662:	570000ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0200666:	60e2                	ld	ra,24(sp)
ffffffffc0200668:	6522                	ld	a0,8(sp)
ffffffffc020066a:	6105                	addi	sp,sp,32
ffffffffc020066c:	8082                	ret
ffffffffc020066e:	56a000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0200672:	4805                	li	a6,1
ffffffffc0200674:	bf81                	j	ffffffffc02005c4 <cons_getc+0xe>

ffffffffc0200676 <dtb_init>:
ffffffffc0200676:	7179                	addi	sp,sp,-48
ffffffffc0200678:	0000b517          	auipc	a0,0xb
ffffffffc020067c:	42050513          	addi	a0,a0,1056 # ffffffffc020ba98 <etext+0x2d4>
ffffffffc0200680:	f406                	sd	ra,40(sp)
ffffffffc0200682:	f022                	sd	s0,32(sp)
ffffffffc0200684:	b23ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200688:	00014597          	auipc	a1,0x14
ffffffffc020068c:	9785b583          	ld	a1,-1672(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc0200690:	0000b517          	auipc	a0,0xb
ffffffffc0200694:	41850513          	addi	a0,a0,1048 # ffffffffc020baa8 <etext+0x2e4>
ffffffffc0200698:	00014417          	auipc	s0,0x14
ffffffffc020069c:	97040413          	addi	s0,s0,-1680 # ffffffffc0214008 <boot_dtb>
ffffffffc02006a0:	b07ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006a4:	600c                	ld	a1,0(s0)
ffffffffc02006a6:	0000b517          	auipc	a0,0xb
ffffffffc02006aa:	41250513          	addi	a0,a0,1042 # ffffffffc020bab8 <etext+0x2f4>
ffffffffc02006ae:	af9ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006b2:	6018                	ld	a4,0(s0)
ffffffffc02006b4:	0000b517          	auipc	a0,0xb
ffffffffc02006b8:	41c50513          	addi	a0,a0,1052 # ffffffffc020bad0 <etext+0x30c>
ffffffffc02006bc:	10070163          	beqz	a4,ffffffffc02007be <dtb_init+0x148>
ffffffffc02006c0:	57f5                	li	a5,-3
ffffffffc02006c2:	07fa                	slli	a5,a5,0x1e
ffffffffc02006c4:	973e                	add	a4,a4,a5
ffffffffc02006c6:	431c                	lw	a5,0(a4)
ffffffffc02006c8:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02006cc:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc02006d0:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006d4:	0187961b          	slliw	a2,a5,0x18
ffffffffc02006d8:	0187d51b          	srliw	a0,a5,0x18
ffffffffc02006dc:	0ff5f593          	zext.b	a1,a1
ffffffffc02006e0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006e4:	05c2                	slli	a1,a1,0x10
ffffffffc02006e6:	8e49                	or	a2,a2,a0
ffffffffc02006e8:	0ff7f793          	zext.b	a5,a5
ffffffffc02006ec:	8dd1                	or	a1,a1,a2
ffffffffc02006ee:	07a2                	slli	a5,a5,0x8
ffffffffc02006f0:	8ddd                	or	a1,a1,a5
ffffffffc02006f2:	00ff0837          	lui	a6,0xff0
ffffffffc02006f6:	0cd59863          	bne	a1,a3,ffffffffc02007c6 <dtb_init+0x150>
ffffffffc02006fa:	4710                	lw	a2,8(a4)
ffffffffc02006fc:	4754                	lw	a3,12(a4)
ffffffffc02006fe:	e84a                	sd	s2,16(sp)
ffffffffc0200700:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200704:	0086d79b          	srliw	a5,a3,0x8
ffffffffc0200708:	01865e1b          	srliw	t3,a2,0x18
ffffffffc020070c:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200710:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200714:	0186959b          	slliw	a1,a3,0x18
ffffffffc0200718:	0104141b          	slliw	s0,s0,0x10
ffffffffc020071c:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200720:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200724:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200728:	01c56533          	or	a0,a0,t3
ffffffffc020072c:	0115e5b3          	or	a1,a1,a7
ffffffffc0200730:	01047433          	and	s0,s0,a6
ffffffffc0200734:	0ff67613          	zext.b	a2,a2
ffffffffc0200738:	0107f7b3          	and	a5,a5,a6
ffffffffc020073c:	0ff6f693          	zext.b	a3,a3
ffffffffc0200740:	8c49                	or	s0,s0,a0
ffffffffc0200742:	0622                	slli	a2,a2,0x8
ffffffffc0200744:	8fcd                	or	a5,a5,a1
ffffffffc0200746:	06a2                	slli	a3,a3,0x8
ffffffffc0200748:	8c51                	or	s0,s0,a2
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	1402                	slli	s0,s0,0x20
ffffffffc020074e:	1782                	slli	a5,a5,0x20
ffffffffc0200750:	9001                	srli	s0,s0,0x20
ffffffffc0200752:	9381                	srli	a5,a5,0x20
ffffffffc0200754:	ec26                	sd	s1,24(sp)
ffffffffc0200756:	4301                	li	t1,0
ffffffffc0200758:	488d                	li	a7,3
ffffffffc020075a:	943a                	add	s0,s0,a4
ffffffffc020075c:	00e78933          	add	s2,a5,a4
ffffffffc0200760:	4e05                	li	t3,1
ffffffffc0200762:	4018                	lw	a4,0(s0)
ffffffffc0200764:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200768:	0187169b          	slliw	a3,a4,0x18
ffffffffc020076c:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200770:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200774:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200778:	0107f7b3          	and	a5,a5,a6
ffffffffc020077c:	8ed1                	or	a3,a3,a2
ffffffffc020077e:	0ff77713          	zext.b	a4,a4
ffffffffc0200782:	8fd5                	or	a5,a5,a3
ffffffffc0200784:	0722                	slli	a4,a4,0x8
ffffffffc0200786:	8fd9                	or	a5,a5,a4
ffffffffc0200788:	05178763          	beq	a5,a7,ffffffffc02007d6 <dtb_init+0x160>
ffffffffc020078c:	0411                	addi	s0,s0,4
ffffffffc020078e:	00f8e963          	bltu	a7,a5,ffffffffc02007a0 <dtb_init+0x12a>
ffffffffc0200792:	07c78d63          	beq	a5,t3,ffffffffc020080c <dtb_init+0x196>
ffffffffc0200796:	4709                	li	a4,2
ffffffffc0200798:	00e79763          	bne	a5,a4,ffffffffc02007a6 <dtb_init+0x130>
ffffffffc020079c:	4301                	li	t1,0
ffffffffc020079e:	b7d1                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc02007a0:	4711                	li	a4,4
ffffffffc02007a2:	fce780e3          	beq	a5,a4,ffffffffc0200762 <dtb_init+0xec>
ffffffffc02007a6:	0000b517          	auipc	a0,0xb
ffffffffc02007aa:	3f250513          	addi	a0,a0,1010 # ffffffffc020bb98 <etext+0x3d4>
ffffffffc02007ae:	9f9ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02007b2:	64e2                	ld	s1,24(sp)
ffffffffc02007b4:	6942                	ld	s2,16(sp)
ffffffffc02007b6:	0000b517          	auipc	a0,0xb
ffffffffc02007ba:	41a50513          	addi	a0,a0,1050 # ffffffffc020bbd0 <etext+0x40c>
ffffffffc02007be:	7402                	ld	s0,32(sp)
ffffffffc02007c0:	70a2                	ld	ra,40(sp)
ffffffffc02007c2:	6145                	addi	sp,sp,48
ffffffffc02007c4:	b2cd                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007c6:	7402                	ld	s0,32(sp)
ffffffffc02007c8:	70a2                	ld	ra,40(sp)
ffffffffc02007ca:	0000b517          	auipc	a0,0xb
ffffffffc02007ce:	32650513          	addi	a0,a0,806 # ffffffffc020baf0 <etext+0x32c>
ffffffffc02007d2:	6145                	addi	sp,sp,48
ffffffffc02007d4:	bac9                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007d6:	4058                	lw	a4,4(s0)
ffffffffc02007d8:	0087579b          	srliw	a5,a4,0x8
ffffffffc02007dc:	0187169b          	slliw	a3,a4,0x18
ffffffffc02007e0:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e4:	0107979b          	slliw	a5,a5,0x10
ffffffffc02007e8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ec:	0107f7b3          	and	a5,a5,a6
ffffffffc02007f0:	8ed1                	or	a3,a3,a2
ffffffffc02007f2:	0ff77713          	zext.b	a4,a4
ffffffffc02007f6:	8fd5                	or	a5,a5,a3
ffffffffc02007f8:	0722                	slli	a4,a4,0x8
ffffffffc02007fa:	8fd9                	or	a5,a5,a4
ffffffffc02007fc:	04031463          	bnez	t1,ffffffffc0200844 <dtb_init+0x1ce>
ffffffffc0200800:	1782                	slli	a5,a5,0x20
ffffffffc0200802:	9381                	srli	a5,a5,0x20
ffffffffc0200804:	043d                	addi	s0,s0,15
ffffffffc0200806:	943e                	add	s0,s0,a5
ffffffffc0200808:	9871                	andi	s0,s0,-4
ffffffffc020080a:	bfa1                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc020080c:	8522                	mv	a0,s0
ffffffffc020080e:	e01a                	sd	t1,0(sp)
ffffffffc0200810:	6990a0ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc0200814:	84aa                	mv	s1,a0
ffffffffc0200816:	4619                	li	a2,6
ffffffffc0200818:	8522                	mv	a0,s0
ffffffffc020081a:	0000b597          	auipc	a1,0xb
ffffffffc020081e:	2fe58593          	addi	a1,a1,766 # ffffffffc020bb18 <etext+0x354>
ffffffffc0200822:	7010a0ef          	jal	ffffffffc020b722 <strncmp>
ffffffffc0200826:	6302                	ld	t1,0(sp)
ffffffffc0200828:	0411                	addi	s0,s0,4
ffffffffc020082a:	0004879b          	sext.w	a5,s1
ffffffffc020082e:	943e                	add	s0,s0,a5
ffffffffc0200830:	00153513          	seqz	a0,a0
ffffffffc0200834:	9871                	andi	s0,s0,-4
ffffffffc0200836:	00a36333          	or	t1,t1,a0
ffffffffc020083a:	00ff0837          	lui	a6,0xff0
ffffffffc020083e:	488d                	li	a7,3
ffffffffc0200840:	4e05                	li	t3,1
ffffffffc0200842:	b705                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc0200844:	4418                	lw	a4,8(s0)
ffffffffc0200846:	0000b597          	auipc	a1,0xb
ffffffffc020084a:	2da58593          	addi	a1,a1,730 # ffffffffc020bb20 <etext+0x35c>
ffffffffc020084e:	e43e                	sd	a5,8(sp)
ffffffffc0200850:	0087551b          	srliw	a0,a4,0x8
ffffffffc0200854:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200858:	0187169b          	slliw	a3,a4,0x18
ffffffffc020085c:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200860:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200864:	01057533          	and	a0,a0,a6
ffffffffc0200868:	8ed1                	or	a3,a3,a2
ffffffffc020086a:	0ff77713          	zext.b	a4,a4
ffffffffc020086e:	0722                	slli	a4,a4,0x8
ffffffffc0200870:	8d55                	or	a0,a0,a3
ffffffffc0200872:	8d59                	or	a0,a0,a4
ffffffffc0200874:	1502                	slli	a0,a0,0x20
ffffffffc0200876:	9101                	srli	a0,a0,0x20
ffffffffc0200878:	954a                	add	a0,a0,s2
ffffffffc020087a:	e01a                	sd	t1,0(sp)
ffffffffc020087c:	6730a0ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc0200880:	67a2                	ld	a5,8(sp)
ffffffffc0200882:	473d                	li	a4,15
ffffffffc0200884:	6302                	ld	t1,0(sp)
ffffffffc0200886:	00ff0837          	lui	a6,0xff0
ffffffffc020088a:	488d                	li	a7,3
ffffffffc020088c:	4e05                	li	t3,1
ffffffffc020088e:	f6f779e3          	bgeu	a4,a5,ffffffffc0200800 <dtb_init+0x18a>
ffffffffc0200892:	f53d                	bnez	a0,ffffffffc0200800 <dtb_init+0x18a>
ffffffffc0200894:	00c43683          	ld	a3,12(s0)
ffffffffc0200898:	01443703          	ld	a4,20(s0)
ffffffffc020089c:	0000b517          	auipc	a0,0xb
ffffffffc02008a0:	28c50513          	addi	a0,a0,652 # ffffffffc020bb28 <etext+0x364>
ffffffffc02008a4:	4206d793          	srai	a5,a3,0x20
ffffffffc02008a8:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02008ac:	00871f93          	slli	t6,a4,0x8
ffffffffc02008b0:	42075893          	srai	a7,a4,0x20
ffffffffc02008b4:	0187df1b          	srliw	t5,a5,0x18
ffffffffc02008b8:	0187959b          	slliw	a1,a5,0x18
ffffffffc02008bc:	0103131b          	slliw	t1,t1,0x10
ffffffffc02008c0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008c4:	420fd613          	srai	a2,t6,0x20
ffffffffc02008c8:	0188de9b          	srliw	t4,a7,0x18
ffffffffc02008cc:	01037333          	and	t1,t1,a6
ffffffffc02008d0:	01889e1b          	slliw	t3,a7,0x18
ffffffffc02008d4:	01e5e5b3          	or	a1,a1,t5
ffffffffc02008d8:	0ff7f793          	zext.b	a5,a5
ffffffffc02008dc:	01de6e33          	or	t3,t3,t4
ffffffffc02008e0:	0065e5b3          	or	a1,a1,t1
ffffffffc02008e4:	01067633          	and	a2,a2,a6
ffffffffc02008e8:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02008ec:	0087541b          	srliw	s0,a4,0x8
ffffffffc02008f0:	07a2                	slli	a5,a5,0x8
ffffffffc02008f2:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02008f6:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02008fa:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02008fe:	8ddd                	or	a1,a1,a5
ffffffffc0200900:	01c66633          	or	a2,a2,t3
ffffffffc0200904:	0186979b          	slliw	a5,a3,0x18
ffffffffc0200908:	01871e1b          	slliw	t3,a4,0x18
ffffffffc020090c:	0ff8f893          	zext.b	a7,a7
ffffffffc0200910:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200914:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200918:	0104141b          	slliw	s0,s0,0x10
ffffffffc020091c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200920:	01037333          	and	t1,t1,a6
ffffffffc0200924:	08a2                	slli	a7,a7,0x8
ffffffffc0200926:	01e7e7b3          	or	a5,a5,t5
ffffffffc020092a:	01047433          	and	s0,s0,a6
ffffffffc020092e:	0ff6f693          	zext.b	a3,a3
ffffffffc0200932:	01de6833          	or	a6,t3,t4
ffffffffc0200936:	0ff77713          	zext.b	a4,a4
ffffffffc020093a:	01166633          	or	a2,a2,a7
ffffffffc020093e:	0067e7b3          	or	a5,a5,t1
ffffffffc0200942:	06a2                	slli	a3,a3,0x8
ffffffffc0200944:	01046433          	or	s0,s0,a6
ffffffffc0200948:	0722                	slli	a4,a4,0x8
ffffffffc020094a:	8fd5                	or	a5,a5,a3
ffffffffc020094c:	8c59                	or	s0,s0,a4
ffffffffc020094e:	1582                	slli	a1,a1,0x20
ffffffffc0200950:	1602                	slli	a2,a2,0x20
ffffffffc0200952:	1782                	slli	a5,a5,0x20
ffffffffc0200954:	9201                	srli	a2,a2,0x20
ffffffffc0200956:	9181                	srli	a1,a1,0x20
ffffffffc0200958:	1402                	slli	s0,s0,0x20
ffffffffc020095a:	00b7e4b3          	or	s1,a5,a1
ffffffffc020095e:	8c51                	or	s0,s0,a2
ffffffffc0200960:	847ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200964:	85a6                	mv	a1,s1
ffffffffc0200966:	0000b517          	auipc	a0,0xb
ffffffffc020096a:	1e250513          	addi	a0,a0,482 # ffffffffc020bb48 <etext+0x384>
ffffffffc020096e:	839ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200972:	01445613          	srli	a2,s0,0x14
ffffffffc0200976:	85a2                	mv	a1,s0
ffffffffc0200978:	0000b517          	auipc	a0,0xb
ffffffffc020097c:	1e850513          	addi	a0,a0,488 # ffffffffc020bb60 <etext+0x39c>
ffffffffc0200980:	827ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200984:	009405b3          	add	a1,s0,s1
ffffffffc0200988:	15fd                	addi	a1,a1,-1
ffffffffc020098a:	0000b517          	auipc	a0,0xb
ffffffffc020098e:	1f650513          	addi	a0,a0,502 # ffffffffc020bb80 <etext+0x3bc>
ffffffffc0200992:	815ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200996:	00096797          	auipc	a5,0x96
ffffffffc020099a:	ee97b523          	sd	s1,-278(a5) # ffffffffc0296880 <memory_base>
ffffffffc020099e:	00096797          	auipc	a5,0x96
ffffffffc02009a2:	ec87bd23          	sd	s0,-294(a5) # ffffffffc0296878 <memory_size>
ffffffffc02009a6:	b531                	j	ffffffffc02007b2 <dtb_init+0x13c>

ffffffffc02009a8 <get_memory_base>:
ffffffffc02009a8:	00096517          	auipc	a0,0x96
ffffffffc02009ac:	ed853503          	ld	a0,-296(a0) # ffffffffc0296880 <memory_base>
ffffffffc02009b0:	8082                	ret

ffffffffc02009b2 <get_memory_size>:
ffffffffc02009b2:	00096517          	auipc	a0,0x96
ffffffffc02009b6:	ec653503          	ld	a0,-314(a0) # ffffffffc0296878 <memory_size>
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <ide_init>:
ffffffffc02009bc:	1141                	addi	sp,sp,-16
ffffffffc02009be:	00091597          	auipc	a1,0x91
ffffffffc02009c2:	cfa58593          	addi	a1,a1,-774 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009c6:	4505                	li	a0,1
ffffffffc02009c8:	00091797          	auipc	a5,0x91
ffffffffc02009cc:	ca07a023          	sw	zero,-864(a5) # ffffffffc0291668 <ide_devices>
ffffffffc02009d0:	00091797          	auipc	a5,0x91
ffffffffc02009d4:	ce07a423          	sw	zero,-792(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009d8:	00091797          	auipc	a5,0x91
ffffffffc02009dc:	d207a823          	sw	zero,-720(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc02009e0:	00091797          	auipc	a5,0x91
ffffffffc02009e4:	d607ac23          	sw	zero,-648(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc02009e8:	e406                	sd	ra,8(sp)
ffffffffc02009ea:	24c000ef          	jal	ffffffffc0200c36 <ramdisk_init>
ffffffffc02009ee:	00091797          	auipc	a5,0x91
ffffffffc02009f2:	cca7a783          	lw	a5,-822(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009f6:	c385                	beqz	a5,ffffffffc0200a16 <ide_init+0x5a>
ffffffffc02009f8:	00091597          	auipc	a1,0x91
ffffffffc02009fc:	d1058593          	addi	a1,a1,-752 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a00:	4509                	li	a0,2
ffffffffc0200a02:	234000ef          	jal	ffffffffc0200c36 <ramdisk_init>
ffffffffc0200a06:	00091797          	auipc	a5,0x91
ffffffffc0200a0a:	d027a783          	lw	a5,-766(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a0e:	c39d                	beqz	a5,ffffffffc0200a34 <ide_init+0x78>
ffffffffc0200a10:	60a2                	ld	ra,8(sp)
ffffffffc0200a12:	0141                	addi	sp,sp,16
ffffffffc0200a14:	8082                	ret
ffffffffc0200a16:	0000b697          	auipc	a3,0xb
ffffffffc0200a1a:	1d268693          	addi	a3,a3,466 # ffffffffc020bbe8 <etext+0x424>
ffffffffc0200a1e:	0000b617          	auipc	a2,0xb
ffffffffc0200a22:	1e260613          	addi	a2,a2,482 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200a26:	45c5                	li	a1,17
ffffffffc0200a28:	0000b517          	auipc	a0,0xb
ffffffffc0200a2c:	1f050513          	addi	a0,a0,496 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200a30:	a1bff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200a34:	0000b697          	auipc	a3,0xb
ffffffffc0200a38:	1fc68693          	addi	a3,a3,508 # ffffffffc020bc30 <etext+0x46c>
ffffffffc0200a3c:	0000b617          	auipc	a2,0xb
ffffffffc0200a40:	1c460613          	addi	a2,a2,452 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200a44:	45d1                	li	a1,20
ffffffffc0200a46:	0000b517          	auipc	a0,0xb
ffffffffc0200a4a:	1d250513          	addi	a0,a0,466 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200a4e:	9fdff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200a52 <ide_device_valid>:
ffffffffc0200a52:	478d                	li	a5,3
ffffffffc0200a54:	00a7ef63          	bltu	a5,a0,ffffffffc0200a72 <ide_device_valid+0x20>
ffffffffc0200a58:	00251793          	slli	a5,a0,0x2
ffffffffc0200a5c:	97aa                	add	a5,a5,a0
ffffffffc0200a5e:	00091717          	auipc	a4,0x91
ffffffffc0200a62:	c0a70713          	addi	a4,a4,-1014 # ffffffffc0291668 <ide_devices>
ffffffffc0200a66:	0792                	slli	a5,a5,0x4
ffffffffc0200a68:	97ba                	add	a5,a5,a4
ffffffffc0200a6a:	4388                	lw	a0,0(a5)
ffffffffc0200a6c:	00a03533          	snez	a0,a0
ffffffffc0200a70:	8082                	ret
ffffffffc0200a72:	4501                	li	a0,0
ffffffffc0200a74:	8082                	ret

ffffffffc0200a76 <ide_device_size>:
ffffffffc0200a76:	478d                	li	a5,3
ffffffffc0200a78:	02a7e163          	bltu	a5,a0,ffffffffc0200a9a <ide_device_size+0x24>
ffffffffc0200a7c:	00251793          	slli	a5,a0,0x2
ffffffffc0200a80:	97aa                	add	a5,a5,a0
ffffffffc0200a82:	00091717          	auipc	a4,0x91
ffffffffc0200a86:	be670713          	addi	a4,a4,-1050 # ffffffffc0291668 <ide_devices>
ffffffffc0200a8a:	0792                	slli	a5,a5,0x4
ffffffffc0200a8c:	97ba                	add	a5,a5,a4
ffffffffc0200a8e:	4398                	lw	a4,0(a5)
ffffffffc0200a90:	4501                	li	a0,0
ffffffffc0200a92:	c709                	beqz	a4,ffffffffc0200a9c <ide_device_size+0x26>
ffffffffc0200a94:	0087e503          	lwu	a0,8(a5)
ffffffffc0200a98:	8082                	ret
ffffffffc0200a9a:	4501                	li	a0,0
ffffffffc0200a9c:	8082                	ret

ffffffffc0200a9e <ide_read_secs>:
ffffffffc0200a9e:	1141                	addi	sp,sp,-16
ffffffffc0200aa0:	e406                	sd	ra,8(sp)
ffffffffc0200aa2:	0816b793          	sltiu	a5,a3,129
ffffffffc0200aa6:	cba9                	beqz	a5,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200aa8:	478d                	li	a5,3
ffffffffc0200aaa:	0005081b          	sext.w	a6,a0
ffffffffc0200aae:	04a7e563          	bltu	a5,a0,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200ab2:	00281793          	slli	a5,a6,0x2
ffffffffc0200ab6:	97c2                	add	a5,a5,a6
ffffffffc0200ab8:	0792                	slli	a5,a5,0x4
ffffffffc0200aba:	00091817          	auipc	a6,0x91
ffffffffc0200abe:	bae80813          	addi	a6,a6,-1106 # ffffffffc0291668 <ide_devices>
ffffffffc0200ac2:	97c2                	add	a5,a5,a6
ffffffffc0200ac4:	0007a883          	lw	a7,0(a5)
ffffffffc0200ac8:	02088863          	beqz	a7,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200acc:	100008b7          	lui	a7,0x10000
ffffffffc0200ad0:	0515f463          	bgeu	a1,a7,ffffffffc0200b18 <ide_read_secs+0x7a>
ffffffffc0200ad4:	1582                	slli	a1,a1,0x20
ffffffffc0200ad6:	9181                	srli	a1,a1,0x20
ffffffffc0200ad8:	00d58733          	add	a4,a1,a3
ffffffffc0200adc:	02e8ee63          	bltu	a7,a4,ffffffffc0200b18 <ide_read_secs+0x7a>
ffffffffc0200ae0:	00251713          	slli	a4,a0,0x2
ffffffffc0200ae4:	0407b883          	ld	a7,64(a5)
ffffffffc0200ae8:	60a2                	ld	ra,8(sp)
ffffffffc0200aea:	00a707b3          	add	a5,a4,a0
ffffffffc0200aee:	0792                	slli	a5,a5,0x4
ffffffffc0200af0:	00f80533          	add	a0,a6,a5
ffffffffc0200af4:	0141                	addi	sp,sp,16
ffffffffc0200af6:	8882                	jr	a7
ffffffffc0200af8:	0000b697          	auipc	a3,0xb
ffffffffc0200afc:	15068693          	addi	a3,a3,336 # ffffffffc020bc48 <etext+0x484>
ffffffffc0200b00:	0000b617          	auipc	a2,0xb
ffffffffc0200b04:	10060613          	addi	a2,a2,256 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200b08:	02200593          	li	a1,34
ffffffffc0200b0c:	0000b517          	auipc	a0,0xb
ffffffffc0200b10:	10c50513          	addi	a0,a0,268 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200b14:	937ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200b18:	0000b697          	auipc	a3,0xb
ffffffffc0200b1c:	15868693          	addi	a3,a3,344 # ffffffffc020bc70 <etext+0x4ac>
ffffffffc0200b20:	0000b617          	auipc	a2,0xb
ffffffffc0200b24:	0e060613          	addi	a2,a2,224 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200b28:	02300593          	li	a1,35
ffffffffc0200b2c:	0000b517          	auipc	a0,0xb
ffffffffc0200b30:	0ec50513          	addi	a0,a0,236 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200b34:	917ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200b38 <ide_write_secs>:
ffffffffc0200b38:	1141                	addi	sp,sp,-16
ffffffffc0200b3a:	e406                	sd	ra,8(sp)
ffffffffc0200b3c:	0816b793          	sltiu	a5,a3,129
ffffffffc0200b40:	cba9                	beqz	a5,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b42:	478d                	li	a5,3
ffffffffc0200b44:	0005081b          	sext.w	a6,a0
ffffffffc0200b48:	04a7e563          	bltu	a5,a0,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b4c:	00281793          	slli	a5,a6,0x2
ffffffffc0200b50:	97c2                	add	a5,a5,a6
ffffffffc0200b52:	0792                	slli	a5,a5,0x4
ffffffffc0200b54:	00091817          	auipc	a6,0x91
ffffffffc0200b58:	b1480813          	addi	a6,a6,-1260 # ffffffffc0291668 <ide_devices>
ffffffffc0200b5c:	97c2                	add	a5,a5,a6
ffffffffc0200b5e:	0007a883          	lw	a7,0(a5)
ffffffffc0200b62:	02088863          	beqz	a7,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b66:	100008b7          	lui	a7,0x10000
ffffffffc0200b6a:	0515f463          	bgeu	a1,a7,ffffffffc0200bb2 <ide_write_secs+0x7a>
ffffffffc0200b6e:	1582                	slli	a1,a1,0x20
ffffffffc0200b70:	9181                	srli	a1,a1,0x20
ffffffffc0200b72:	00d58733          	add	a4,a1,a3
ffffffffc0200b76:	02e8ee63          	bltu	a7,a4,ffffffffc0200bb2 <ide_write_secs+0x7a>
ffffffffc0200b7a:	00251713          	slli	a4,a0,0x2
ffffffffc0200b7e:	0487b883          	ld	a7,72(a5)
ffffffffc0200b82:	60a2                	ld	ra,8(sp)
ffffffffc0200b84:	00a707b3          	add	a5,a4,a0
ffffffffc0200b88:	0792                	slli	a5,a5,0x4
ffffffffc0200b8a:	00f80533          	add	a0,a6,a5
ffffffffc0200b8e:	0141                	addi	sp,sp,16
ffffffffc0200b90:	8882                	jr	a7
ffffffffc0200b92:	0000b697          	auipc	a3,0xb
ffffffffc0200b96:	0b668693          	addi	a3,a3,182 # ffffffffc020bc48 <etext+0x484>
ffffffffc0200b9a:	0000b617          	auipc	a2,0xb
ffffffffc0200b9e:	06660613          	addi	a2,a2,102 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200ba2:	02900593          	li	a1,41
ffffffffc0200ba6:	0000b517          	auipc	a0,0xb
ffffffffc0200baa:	07250513          	addi	a0,a0,114 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200bae:	89dff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200bb2:	0000b697          	auipc	a3,0xb
ffffffffc0200bb6:	0be68693          	addi	a3,a3,190 # ffffffffc020bc70 <etext+0x4ac>
ffffffffc0200bba:	0000b617          	auipc	a2,0xb
ffffffffc0200bbe:	04660613          	addi	a2,a2,70 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0200bc2:	02a00593          	li	a1,42
ffffffffc0200bc6:	0000b517          	auipc	a0,0xb
ffffffffc0200bca:	05250513          	addi	a0,a0,82 # ffffffffc020bc18 <etext+0x454>
ffffffffc0200bce:	87dff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200bd2 <intr_enable>:
ffffffffc0200bd2:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200bd6:	8082                	ret

ffffffffc0200bd8 <intr_disable>:
ffffffffc0200bd8:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200bdc:	8082                	ret

ffffffffc0200bde <pic_init>:
ffffffffc0200bde:	8082                	ret

ffffffffc0200be0 <ramdisk_write>:
ffffffffc0200be0:	00856783          	lwu	a5,8(a0)
ffffffffc0200be4:	1141                	addi	sp,sp,-16
ffffffffc0200be6:	e406                	sd	ra,8(sp)
ffffffffc0200be8:	8f8d                	sub	a5,a5,a1
ffffffffc0200bea:	8732                	mv	a4,a2
ffffffffc0200bec:	00f6f363          	bgeu	a3,a5,ffffffffc0200bf2 <ramdisk_write+0x12>
ffffffffc0200bf0:	87b6                	mv	a5,a3
ffffffffc0200bf2:	6914                	ld	a3,16(a0)
ffffffffc0200bf4:	00959513          	slli	a0,a1,0x9
ffffffffc0200bf8:	00979613          	slli	a2,a5,0x9
ffffffffc0200bfc:	9536                	add	a0,a0,a3
ffffffffc0200bfe:	85ba                	mv	a1,a4
ffffffffc0200c00:	3ad0a0ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0200c04:	60a2                	ld	ra,8(sp)
ffffffffc0200c06:	4501                	li	a0,0
ffffffffc0200c08:	0141                	addi	sp,sp,16
ffffffffc0200c0a:	8082                	ret

ffffffffc0200c0c <ramdisk_read>:
ffffffffc0200c0c:	00856783          	lwu	a5,8(a0)
ffffffffc0200c10:	1141                	addi	sp,sp,-16
ffffffffc0200c12:	e406                	sd	ra,8(sp)
ffffffffc0200c14:	8f8d                	sub	a5,a5,a1
ffffffffc0200c16:	872a                	mv	a4,a0
ffffffffc0200c18:	8532                	mv	a0,a2
ffffffffc0200c1a:	00f6f363          	bgeu	a3,a5,ffffffffc0200c20 <ramdisk_read+0x14>
ffffffffc0200c1e:	87b6                	mv	a5,a3
ffffffffc0200c20:	6b18                	ld	a4,16(a4)
ffffffffc0200c22:	05a6                	slli	a1,a1,0x9
ffffffffc0200c24:	00979613          	slli	a2,a5,0x9
ffffffffc0200c28:	95ba                	add	a1,a1,a4
ffffffffc0200c2a:	3830a0ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0200c2e:	60a2                	ld	ra,8(sp)
ffffffffc0200c30:	4501                	li	a0,0
ffffffffc0200c32:	0141                	addi	sp,sp,16
ffffffffc0200c34:	8082                	ret

ffffffffc0200c36 <ramdisk_init>:
ffffffffc0200c36:	7179                	addi	sp,sp,-48
ffffffffc0200c38:	f022                	sd	s0,32(sp)
ffffffffc0200c3a:	ec26                	sd	s1,24(sp)
ffffffffc0200c3c:	842e                	mv	s0,a1
ffffffffc0200c3e:	84aa                	mv	s1,a0
ffffffffc0200c40:	05000613          	li	a2,80
ffffffffc0200c44:	852e                	mv	a0,a1
ffffffffc0200c46:	4581                	li	a1,0
ffffffffc0200c48:	f406                	sd	ra,40(sp)
ffffffffc0200c4a:	3130a0ef          	jal	ffffffffc020b75c <memset>
ffffffffc0200c4e:	4785                	li	a5,1
ffffffffc0200c50:	06f48a63          	beq	s1,a5,ffffffffc0200cc4 <ramdisk_init+0x8e>
ffffffffc0200c54:	4789                	li	a5,2
ffffffffc0200c56:	00090617          	auipc	a2,0x90
ffffffffc0200c5a:	3ba60613          	addi	a2,a2,954 # ffffffffc0291010 <arena>
ffffffffc0200c5e:	0001b597          	auipc	a1,0x1b
ffffffffc0200c62:	0b258593          	addi	a1,a1,178 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200c66:	08f49363          	bne	s1,a5,ffffffffc0200cec <ramdisk_init+0xb6>
ffffffffc0200c6a:	06c58763          	beq	a1,a2,ffffffffc0200cd8 <ramdisk_init+0xa2>
ffffffffc0200c6e:	40b604b3          	sub	s1,a2,a1
ffffffffc0200c72:	86a6                	mv	a3,s1
ffffffffc0200c74:	167d                	addi	a2,a2,-1
ffffffffc0200c76:	0000b517          	auipc	a0,0xb
ffffffffc0200c7a:	05250513          	addi	a0,a0,82 # ffffffffc020bcc8 <etext+0x504>
ffffffffc0200c7e:	e42e                	sd	a1,8(sp)
ffffffffc0200c80:	d26ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200c84:	65a2                	ld	a1,8(sp)
ffffffffc0200c86:	57fd                	li	a5,-1
ffffffffc0200c88:	1782                	slli	a5,a5,0x20
ffffffffc0200c8a:	0094d69b          	srliw	a3,s1,0x9
ffffffffc0200c8e:	0785                	addi	a5,a5,1
ffffffffc0200c90:	e80c                	sd	a1,16(s0)
ffffffffc0200c92:	e01c                	sd	a5,0(s0)
ffffffffc0200c94:	c414                	sw	a3,8(s0)
ffffffffc0200c96:	02040513          	addi	a0,s0,32
ffffffffc0200c9a:	0000b597          	auipc	a1,0xb
ffffffffc0200c9e:	08658593          	addi	a1,a1,134 # ffffffffc020bd20 <etext+0x55c>
ffffffffc0200ca2:	23b0a0ef          	jal	ffffffffc020b6dc <strcpy>
ffffffffc0200ca6:	00000717          	auipc	a4,0x0
ffffffffc0200caa:	f6670713          	addi	a4,a4,-154 # ffffffffc0200c0c <ramdisk_read>
ffffffffc0200cae:	00000797          	auipc	a5,0x0
ffffffffc0200cb2:	f3278793          	addi	a5,a5,-206 # ffffffffc0200be0 <ramdisk_write>
ffffffffc0200cb6:	70a2                	ld	ra,40(sp)
ffffffffc0200cb8:	e038                	sd	a4,64(s0)
ffffffffc0200cba:	e43c                	sd	a5,72(s0)
ffffffffc0200cbc:	7402                	ld	s0,32(sp)
ffffffffc0200cbe:	64e2                	ld	s1,24(sp)
ffffffffc0200cc0:	6145                	addi	sp,sp,48
ffffffffc0200cc2:	8082                	ret
ffffffffc0200cc4:	0001b617          	auipc	a2,0x1b
ffffffffc0200cc8:	04c60613          	addi	a2,a2,76 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200ccc:	00013597          	auipc	a1,0x13
ffffffffc0200cd0:	34458593          	addi	a1,a1,836 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200cd4:	f8c59de3          	bne	a1,a2,ffffffffc0200c6e <ramdisk_init+0x38>
ffffffffc0200cd8:	7402                	ld	s0,32(sp)
ffffffffc0200cda:	70a2                	ld	ra,40(sp)
ffffffffc0200cdc:	64e2                	ld	s1,24(sp)
ffffffffc0200cde:	0000b517          	auipc	a0,0xb
ffffffffc0200ce2:	fd250513          	addi	a0,a0,-46 # ffffffffc020bcb0 <etext+0x4ec>
ffffffffc0200ce6:	6145                	addi	sp,sp,48
ffffffffc0200ce8:	cbeff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200cec:	0000b617          	auipc	a2,0xb
ffffffffc0200cf0:	00460613          	addi	a2,a2,4 # ffffffffc020bcf0 <etext+0x52c>
ffffffffc0200cf4:	03200593          	li	a1,50
ffffffffc0200cf8:	0000b517          	auipc	a0,0xb
ffffffffc0200cfc:	01050513          	addi	a0,a0,16 # ffffffffc020bd08 <etext+0x544>
ffffffffc0200d00:	f4aff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200d04 <idt_init>:
ffffffffc0200d04:	14005073          	csrwi	sscratch,0
ffffffffc0200d08:	00000797          	auipc	a5,0x0
ffffffffc0200d0c:	47c78793          	addi	a5,a5,1148 # ffffffffc0201184 <__alltraps>
ffffffffc0200d10:	10579073          	csrw	stvec,a5
ffffffffc0200d14:	000407b7          	lui	a5,0x40
ffffffffc0200d18:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200d1c:	8082                	ret

ffffffffc0200d1e <print_regs>:
ffffffffc0200d1e:	610c                	ld	a1,0(a0)
ffffffffc0200d20:	1141                	addi	sp,sp,-16
ffffffffc0200d22:	e022                	sd	s0,0(sp)
ffffffffc0200d24:	842a                	mv	s0,a0
ffffffffc0200d26:	0000b517          	auipc	a0,0xb
ffffffffc0200d2a:	00a50513          	addi	a0,a0,10 # ffffffffc020bd30 <etext+0x56c>
ffffffffc0200d2e:	e406                	sd	ra,8(sp)
ffffffffc0200d30:	c76ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d34:	640c                	ld	a1,8(s0)
ffffffffc0200d36:	0000b517          	auipc	a0,0xb
ffffffffc0200d3a:	01250513          	addi	a0,a0,18 # ffffffffc020bd48 <etext+0x584>
ffffffffc0200d3e:	c68ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d42:	680c                	ld	a1,16(s0)
ffffffffc0200d44:	0000b517          	auipc	a0,0xb
ffffffffc0200d48:	01c50513          	addi	a0,a0,28 # ffffffffc020bd60 <etext+0x59c>
ffffffffc0200d4c:	c5aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d50:	6c0c                	ld	a1,24(s0)
ffffffffc0200d52:	0000b517          	auipc	a0,0xb
ffffffffc0200d56:	02650513          	addi	a0,a0,38 # ffffffffc020bd78 <etext+0x5b4>
ffffffffc0200d5a:	c4cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d5e:	700c                	ld	a1,32(s0)
ffffffffc0200d60:	0000b517          	auipc	a0,0xb
ffffffffc0200d64:	03050513          	addi	a0,a0,48 # ffffffffc020bd90 <etext+0x5cc>
ffffffffc0200d68:	c3eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d6c:	740c                	ld	a1,40(s0)
ffffffffc0200d6e:	0000b517          	auipc	a0,0xb
ffffffffc0200d72:	03a50513          	addi	a0,a0,58 # ffffffffc020bda8 <etext+0x5e4>
ffffffffc0200d76:	c30ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d7a:	780c                	ld	a1,48(s0)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	04450513          	addi	a0,a0,68 # ffffffffc020bdc0 <etext+0x5fc>
ffffffffc0200d84:	c22ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d88:	7c0c                	ld	a1,56(s0)
ffffffffc0200d8a:	0000b517          	auipc	a0,0xb
ffffffffc0200d8e:	04e50513          	addi	a0,a0,78 # ffffffffc020bdd8 <etext+0x614>
ffffffffc0200d92:	c14ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d96:	602c                	ld	a1,64(s0)
ffffffffc0200d98:	0000b517          	auipc	a0,0xb
ffffffffc0200d9c:	05850513          	addi	a0,a0,88 # ffffffffc020bdf0 <etext+0x62c>
ffffffffc0200da0:	c06ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200da4:	642c                	ld	a1,72(s0)
ffffffffc0200da6:	0000b517          	auipc	a0,0xb
ffffffffc0200daa:	06250513          	addi	a0,a0,98 # ffffffffc020be08 <etext+0x644>
ffffffffc0200dae:	bf8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200db2:	682c                	ld	a1,80(s0)
ffffffffc0200db4:	0000b517          	auipc	a0,0xb
ffffffffc0200db8:	06c50513          	addi	a0,a0,108 # ffffffffc020be20 <etext+0x65c>
ffffffffc0200dbc:	beaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dc0:	6c2c                	ld	a1,88(s0)
ffffffffc0200dc2:	0000b517          	auipc	a0,0xb
ffffffffc0200dc6:	07650513          	addi	a0,a0,118 # ffffffffc020be38 <etext+0x674>
ffffffffc0200dca:	bdcff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dce:	702c                	ld	a1,96(s0)
ffffffffc0200dd0:	0000b517          	auipc	a0,0xb
ffffffffc0200dd4:	08050513          	addi	a0,a0,128 # ffffffffc020be50 <etext+0x68c>
ffffffffc0200dd8:	bceff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ddc:	742c                	ld	a1,104(s0)
ffffffffc0200dde:	0000b517          	auipc	a0,0xb
ffffffffc0200de2:	08a50513          	addi	a0,a0,138 # ffffffffc020be68 <etext+0x6a4>
ffffffffc0200de6:	bc0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dea:	782c                	ld	a1,112(s0)
ffffffffc0200dec:	0000b517          	auipc	a0,0xb
ffffffffc0200df0:	09450513          	addi	a0,a0,148 # ffffffffc020be80 <etext+0x6bc>
ffffffffc0200df4:	bb2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200df8:	7c2c                	ld	a1,120(s0)
ffffffffc0200dfa:	0000b517          	auipc	a0,0xb
ffffffffc0200dfe:	09e50513          	addi	a0,a0,158 # ffffffffc020be98 <etext+0x6d4>
ffffffffc0200e02:	ba4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e06:	604c                	ld	a1,128(s0)
ffffffffc0200e08:	0000b517          	auipc	a0,0xb
ffffffffc0200e0c:	0a850513          	addi	a0,a0,168 # ffffffffc020beb0 <etext+0x6ec>
ffffffffc0200e10:	b96ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e14:	644c                	ld	a1,136(s0)
ffffffffc0200e16:	0000b517          	auipc	a0,0xb
ffffffffc0200e1a:	0b250513          	addi	a0,a0,178 # ffffffffc020bec8 <etext+0x704>
ffffffffc0200e1e:	b88ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e22:	684c                	ld	a1,144(s0)
ffffffffc0200e24:	0000b517          	auipc	a0,0xb
ffffffffc0200e28:	0bc50513          	addi	a0,a0,188 # ffffffffc020bee0 <etext+0x71c>
ffffffffc0200e2c:	b7aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e30:	6c4c                	ld	a1,152(s0)
ffffffffc0200e32:	0000b517          	auipc	a0,0xb
ffffffffc0200e36:	0c650513          	addi	a0,a0,198 # ffffffffc020bef8 <etext+0x734>
ffffffffc0200e3a:	b6cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e3e:	704c                	ld	a1,160(s0)
ffffffffc0200e40:	0000b517          	auipc	a0,0xb
ffffffffc0200e44:	0d050513          	addi	a0,a0,208 # ffffffffc020bf10 <etext+0x74c>
ffffffffc0200e48:	b5eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e4c:	744c                	ld	a1,168(s0)
ffffffffc0200e4e:	0000b517          	auipc	a0,0xb
ffffffffc0200e52:	0da50513          	addi	a0,a0,218 # ffffffffc020bf28 <etext+0x764>
ffffffffc0200e56:	b50ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e5a:	784c                	ld	a1,176(s0)
ffffffffc0200e5c:	0000b517          	auipc	a0,0xb
ffffffffc0200e60:	0e450513          	addi	a0,a0,228 # ffffffffc020bf40 <etext+0x77c>
ffffffffc0200e64:	b42ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e68:	7c4c                	ld	a1,184(s0)
ffffffffc0200e6a:	0000b517          	auipc	a0,0xb
ffffffffc0200e6e:	0ee50513          	addi	a0,a0,238 # ffffffffc020bf58 <etext+0x794>
ffffffffc0200e72:	b34ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e76:	606c                	ld	a1,192(s0)
ffffffffc0200e78:	0000b517          	auipc	a0,0xb
ffffffffc0200e7c:	0f850513          	addi	a0,a0,248 # ffffffffc020bf70 <etext+0x7ac>
ffffffffc0200e80:	b26ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e84:	646c                	ld	a1,200(s0)
ffffffffc0200e86:	0000b517          	auipc	a0,0xb
ffffffffc0200e8a:	10250513          	addi	a0,a0,258 # ffffffffc020bf88 <etext+0x7c4>
ffffffffc0200e8e:	b18ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e92:	686c                	ld	a1,208(s0)
ffffffffc0200e94:	0000b517          	auipc	a0,0xb
ffffffffc0200e98:	10c50513          	addi	a0,a0,268 # ffffffffc020bfa0 <etext+0x7dc>
ffffffffc0200e9c:	b0aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ea0:	6c6c                	ld	a1,216(s0)
ffffffffc0200ea2:	0000b517          	auipc	a0,0xb
ffffffffc0200ea6:	11650513          	addi	a0,a0,278 # ffffffffc020bfb8 <etext+0x7f4>
ffffffffc0200eaa:	afcff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eae:	706c                	ld	a1,224(s0)
ffffffffc0200eb0:	0000b517          	auipc	a0,0xb
ffffffffc0200eb4:	12050513          	addi	a0,a0,288 # ffffffffc020bfd0 <etext+0x80c>
ffffffffc0200eb8:	aeeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ebc:	746c                	ld	a1,232(s0)
ffffffffc0200ebe:	0000b517          	auipc	a0,0xb
ffffffffc0200ec2:	12a50513          	addi	a0,a0,298 # ffffffffc020bfe8 <etext+0x824>
ffffffffc0200ec6:	ae0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eca:	786c                	ld	a1,240(s0)
ffffffffc0200ecc:	0000b517          	auipc	a0,0xb
ffffffffc0200ed0:	13450513          	addi	a0,a0,308 # ffffffffc020c000 <etext+0x83c>
ffffffffc0200ed4:	ad2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ed8:	7c6c                	ld	a1,248(s0)
ffffffffc0200eda:	6402                	ld	s0,0(sp)
ffffffffc0200edc:	60a2                	ld	ra,8(sp)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	13a50513          	addi	a0,a0,314 # ffffffffc020c018 <etext+0x854>
ffffffffc0200ee6:	0141                	addi	sp,sp,16
ffffffffc0200ee8:	abeff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200eec <print_trapframe>:
ffffffffc0200eec:	1141                	addi	sp,sp,-16
ffffffffc0200eee:	e022                	sd	s0,0(sp)
ffffffffc0200ef0:	85aa                	mv	a1,a0
ffffffffc0200ef2:	842a                	mv	s0,a0
ffffffffc0200ef4:	0000b517          	auipc	a0,0xb
ffffffffc0200ef8:	13c50513          	addi	a0,a0,316 # ffffffffc020c030 <etext+0x86c>
ffffffffc0200efc:	e406                	sd	ra,8(sp)
ffffffffc0200efe:	aa8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f02:	8522                	mv	a0,s0
ffffffffc0200f04:	e1bff0ef          	jal	ffffffffc0200d1e <print_regs>
ffffffffc0200f08:	10043583          	ld	a1,256(s0)
ffffffffc0200f0c:	0000b517          	auipc	a0,0xb
ffffffffc0200f10:	13c50513          	addi	a0,a0,316 # ffffffffc020c048 <etext+0x884>
ffffffffc0200f14:	a92ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f18:	10843583          	ld	a1,264(s0)
ffffffffc0200f1c:	0000b517          	auipc	a0,0xb
ffffffffc0200f20:	14450513          	addi	a0,a0,324 # ffffffffc020c060 <etext+0x89c>
ffffffffc0200f24:	a82ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f28:	11043583          	ld	a1,272(s0)
ffffffffc0200f2c:	0000b517          	auipc	a0,0xb
ffffffffc0200f30:	14c50513          	addi	a0,a0,332 # ffffffffc020c078 <etext+0x8b4>
ffffffffc0200f34:	a72ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f38:	11843583          	ld	a1,280(s0)
ffffffffc0200f3c:	6402                	ld	s0,0(sp)
ffffffffc0200f3e:	60a2                	ld	ra,8(sp)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	14850513          	addi	a0,a0,328 # ffffffffc020c088 <etext+0x8c4>
ffffffffc0200f48:	0141                	addi	sp,sp,16
ffffffffc0200f4a:	a5cff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f4e <interrupt_handler>:
ffffffffc0200f4e:	11853783          	ld	a5,280(a0)
ffffffffc0200f52:	472d                	li	a4,11
ffffffffc0200f54:	0786                	slli	a5,a5,0x1
ffffffffc0200f56:	8385                	srli	a5,a5,0x1
ffffffffc0200f58:	08f76063          	bltu	a4,a5,ffffffffc0200fd8 <interrupt_handler+0x8a>
ffffffffc0200f5c:	0000e717          	auipc	a4,0xe
ffffffffc0200f60:	eec70713          	addi	a4,a4,-276 # ffffffffc020ee48 <commands+0x48>
ffffffffc0200f64:	078a                	slli	a5,a5,0x2
ffffffffc0200f66:	97ba                	add	a5,a5,a4
ffffffffc0200f68:	439c                	lw	a5,0(a5)
ffffffffc0200f6a:	97ba                	add	a5,a5,a4
ffffffffc0200f6c:	8782                	jr	a5
ffffffffc0200f6e:	0000b517          	auipc	a0,0xb
ffffffffc0200f72:	19250513          	addi	a0,a0,402 # ffffffffc020c100 <etext+0x93c>
ffffffffc0200f76:	a30ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f7a:	0000b517          	auipc	a0,0xb
ffffffffc0200f7e:	16650513          	addi	a0,a0,358 # ffffffffc020c0e0 <etext+0x91c>
ffffffffc0200f82:	a24ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f86:	0000b517          	auipc	a0,0xb
ffffffffc0200f8a:	11a50513          	addi	a0,a0,282 # ffffffffc020c0a0 <etext+0x8dc>
ffffffffc0200f8e:	a18ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	12e50513          	addi	a0,a0,302 # ffffffffc020c0c0 <etext+0x8fc>
ffffffffc0200f9a:	a0cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f9e:	1141                	addi	sp,sp,-16
ffffffffc0200fa0:	e406                	sd	ra,8(sp)
ffffffffc0200fa2:	d86ff0ef          	jal	ffffffffc0200528 <clock_set_next_event>
ffffffffc0200fa6:	00096797          	auipc	a5,0x96
ffffffffc0200faa:	8ca7b783          	ld	a5,-1846(a5) # ffffffffc0296870 <ticks>
ffffffffc0200fae:	0785                	addi	a5,a5,1
ffffffffc0200fb0:	00096717          	auipc	a4,0x96
ffffffffc0200fb4:	8cf73023          	sd	a5,-1856(a4) # ffffffffc0296870 <ticks>
ffffffffc0200fb8:	6f6060ef          	jal	ffffffffc02076ae <run_timer_list>
ffffffffc0200fbc:	dfaff0ef          	jal	ffffffffc02005b6 <cons_getc>
ffffffffc0200fc0:	60a2                	ld	ra,8(sp)
ffffffffc0200fc2:	0ff57513          	zext.b	a0,a0
ffffffffc0200fc6:	0141                	addi	sp,sp,16
ffffffffc0200fc8:	60d0706f          	j	ffffffffc0208dd4 <dev_stdin_write>
ffffffffc0200fcc:	0000b517          	auipc	a0,0xb
ffffffffc0200fd0:	15450513          	addi	a0,a0,340 # ffffffffc020c120 <etext+0x95c>
ffffffffc0200fd4:	9d2ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200fd8:	bf11                	j	ffffffffc0200eec <print_trapframe>

ffffffffc0200fda <exception_handler>:
ffffffffc0200fda:	11853783          	ld	a5,280(a0)
ffffffffc0200fde:	473d                	li	a4,15
ffffffffc0200fe0:	10f76e63          	bltu	a4,a5,ffffffffc02010fc <exception_handler+0x122>
ffffffffc0200fe4:	0000e717          	auipc	a4,0xe
ffffffffc0200fe8:	e9470713          	addi	a4,a4,-364 # ffffffffc020ee78 <commands+0x78>
ffffffffc0200fec:	078a                	slli	a5,a5,0x2
ffffffffc0200fee:	97ba                	add	a5,a5,a4
ffffffffc0200ff0:	439c                	lw	a5,0(a5)
ffffffffc0200ff2:	1101                	addi	sp,sp,-32
ffffffffc0200ff4:	ec06                	sd	ra,24(sp)
ffffffffc0200ff6:	97ba                	add	a5,a5,a4
ffffffffc0200ff8:	86aa                	mv	a3,a0
ffffffffc0200ffa:	8782                	jr	a5
ffffffffc0200ffc:	e42a                	sd	a0,8(sp)
ffffffffc0200ffe:	0000b517          	auipc	a0,0xb
ffffffffc0201002:	22a50513          	addi	a0,a0,554 # ffffffffc020c228 <etext+0xa64>
ffffffffc0201006:	9a0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020100a:	66a2                	ld	a3,8(sp)
ffffffffc020100c:	1086b783          	ld	a5,264(a3)
ffffffffc0201010:	60e2                	ld	ra,24(sp)
ffffffffc0201012:	0791                	addi	a5,a5,4
ffffffffc0201014:	10f6b423          	sd	a5,264(a3)
ffffffffc0201018:	6105                	addi	sp,sp,32
ffffffffc020101a:	0e50606f          	j	ffffffffc02078fe <syscall>
ffffffffc020101e:	60e2                	ld	ra,24(sp)
ffffffffc0201020:	0000b517          	auipc	a0,0xb
ffffffffc0201024:	22850513          	addi	a0,a0,552 # ffffffffc020c248 <etext+0xa84>
ffffffffc0201028:	6105                	addi	sp,sp,32
ffffffffc020102a:	97cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020102e:	60e2                	ld	ra,24(sp)
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	23850513          	addi	a0,a0,568 # ffffffffc020c268 <etext+0xaa4>
ffffffffc0201038:	6105                	addi	sp,sp,32
ffffffffc020103a:	96cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103e:	60e2                	ld	ra,24(sp)
ffffffffc0201040:	0000b517          	auipc	a0,0xb
ffffffffc0201044:	24850513          	addi	a0,a0,584 # ffffffffc020c288 <etext+0xac4>
ffffffffc0201048:	6105                	addi	sp,sp,32
ffffffffc020104a:	95cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020104e:	60e2                	ld	ra,24(sp)
ffffffffc0201050:	0000b517          	auipc	a0,0xb
ffffffffc0201054:	25050513          	addi	a0,a0,592 # ffffffffc020c2a0 <etext+0xadc>
ffffffffc0201058:	6105                	addi	sp,sp,32
ffffffffc020105a:	94cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020105e:	60e2                	ld	ra,24(sp)
ffffffffc0201060:	0000b517          	auipc	a0,0xb
ffffffffc0201064:	25850513          	addi	a0,a0,600 # ffffffffc020c2b8 <etext+0xaf4>
ffffffffc0201068:	6105                	addi	sp,sp,32
ffffffffc020106a:	93cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020106e:	60e2                	ld	ra,24(sp)
ffffffffc0201070:	0000b517          	auipc	a0,0xb
ffffffffc0201074:	0d050513          	addi	a0,a0,208 # ffffffffc020c140 <etext+0x97c>
ffffffffc0201078:	6105                	addi	sp,sp,32
ffffffffc020107a:	92cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020107e:	60e2                	ld	ra,24(sp)
ffffffffc0201080:	0000b517          	auipc	a0,0xb
ffffffffc0201084:	0e050513          	addi	a0,a0,224 # ffffffffc020c160 <etext+0x99c>
ffffffffc0201088:	6105                	addi	sp,sp,32
ffffffffc020108a:	91cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020108e:	60e2                	ld	ra,24(sp)
ffffffffc0201090:	0000b517          	auipc	a0,0xb
ffffffffc0201094:	0f050513          	addi	a0,a0,240 # ffffffffc020c180 <etext+0x9bc>
ffffffffc0201098:	6105                	addi	sp,sp,32
ffffffffc020109a:	90cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020109e:	60e2                	ld	ra,24(sp)
ffffffffc02010a0:	0000b517          	auipc	a0,0xb
ffffffffc02010a4:	0f850513          	addi	a0,a0,248 # ffffffffc020c198 <etext+0x9d4>
ffffffffc02010a8:	6105                	addi	sp,sp,32
ffffffffc02010aa:	8fcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010ae:	60e2                	ld	ra,24(sp)
ffffffffc02010b0:	0000b517          	auipc	a0,0xb
ffffffffc02010b4:	0f850513          	addi	a0,a0,248 # ffffffffc020c1a8 <etext+0x9e4>
ffffffffc02010b8:	6105                	addi	sp,sp,32
ffffffffc02010ba:	8ecff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010be:	60e2                	ld	ra,24(sp)
ffffffffc02010c0:	0000b517          	auipc	a0,0xb
ffffffffc02010c4:	10850513          	addi	a0,a0,264 # ffffffffc020c1c8 <etext+0xa04>
ffffffffc02010c8:	6105                	addi	sp,sp,32
ffffffffc02010ca:	8dcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010ce:	60e2                	ld	ra,24(sp)
ffffffffc02010d0:	0000b517          	auipc	a0,0xb
ffffffffc02010d4:	14050513          	addi	a0,a0,320 # ffffffffc020c210 <etext+0xa4c>
ffffffffc02010d8:	6105                	addi	sp,sp,32
ffffffffc02010da:	8ccff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010de:	60e2                	ld	ra,24(sp)
ffffffffc02010e0:	6105                	addi	sp,sp,32
ffffffffc02010e2:	b529                	j	ffffffffc0200eec <print_trapframe>
ffffffffc02010e4:	0000b617          	auipc	a2,0xb
ffffffffc02010e8:	0fc60613          	addi	a2,a2,252 # ffffffffc020c1e0 <etext+0xa1c>
ffffffffc02010ec:	0b400593          	li	a1,180
ffffffffc02010f0:	0000b517          	auipc	a0,0xb
ffffffffc02010f4:	10850513          	addi	a0,a0,264 # ffffffffc020c1f8 <etext+0xa34>
ffffffffc02010f8:	b52ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02010fc:	bbc5                	j	ffffffffc0200eec <print_trapframe>

ffffffffc02010fe <trap>:
ffffffffc02010fe:	00095717          	auipc	a4,0x95
ffffffffc0201102:	7ca73703          	ld	a4,1994(a4) # ffffffffc02968c8 <current>
ffffffffc0201106:	11853583          	ld	a1,280(a0)
ffffffffc020110a:	cf21                	beqz	a4,ffffffffc0201162 <trap+0x64>
ffffffffc020110c:	10053603          	ld	a2,256(a0)
ffffffffc0201110:	0a073803          	ld	a6,160(a4)
ffffffffc0201114:	1101                	addi	sp,sp,-32
ffffffffc0201116:	ec06                	sd	ra,24(sp)
ffffffffc0201118:	10067613          	andi	a2,a2,256
ffffffffc020111c:	f348                	sd	a0,160(a4)
ffffffffc020111e:	e432                	sd	a2,8(sp)
ffffffffc0201120:	e042                	sd	a6,0(sp)
ffffffffc0201122:	0205c763          	bltz	a1,ffffffffc0201150 <trap+0x52>
ffffffffc0201126:	eb5ff0ef          	jal	ffffffffc0200fda <exception_handler>
ffffffffc020112a:	6622                	ld	a2,8(sp)
ffffffffc020112c:	6802                	ld	a6,0(sp)
ffffffffc020112e:	00095697          	auipc	a3,0x95
ffffffffc0201132:	79a68693          	addi	a3,a3,1946 # ffffffffc02968c8 <current>
ffffffffc0201136:	6298                	ld	a4,0(a3)
ffffffffc0201138:	0b073023          	sd	a6,160(a4)
ffffffffc020113c:	e619                	bnez	a2,ffffffffc020114a <trap+0x4c>
ffffffffc020113e:	0b072783          	lw	a5,176(a4)
ffffffffc0201142:	8b85                	andi	a5,a5,1
ffffffffc0201144:	e79d                	bnez	a5,ffffffffc0201172 <trap+0x74>
ffffffffc0201146:	6f1c                	ld	a5,24(a4)
ffffffffc0201148:	e38d                	bnez	a5,ffffffffc020116a <trap+0x6c>
ffffffffc020114a:	60e2                	ld	ra,24(sp)
ffffffffc020114c:	6105                	addi	sp,sp,32
ffffffffc020114e:	8082                	ret
ffffffffc0201150:	dffff0ef          	jal	ffffffffc0200f4e <interrupt_handler>
ffffffffc0201154:	6802                	ld	a6,0(sp)
ffffffffc0201156:	6622                	ld	a2,8(sp)
ffffffffc0201158:	00095697          	auipc	a3,0x95
ffffffffc020115c:	77068693          	addi	a3,a3,1904 # ffffffffc02968c8 <current>
ffffffffc0201160:	bfd9                	j	ffffffffc0201136 <trap+0x38>
ffffffffc0201162:	0005c363          	bltz	a1,ffffffffc0201168 <trap+0x6a>
ffffffffc0201166:	bd95                	j	ffffffffc0200fda <exception_handler>
ffffffffc0201168:	b3dd                	j	ffffffffc0200f4e <interrupt_handler>
ffffffffc020116a:	60e2                	ld	ra,24(sp)
ffffffffc020116c:	6105                	addi	sp,sp,32
ffffffffc020116e:	3360606f          	j	ffffffffc02074a4 <schedule>
ffffffffc0201172:	555d                	li	a0,-9
ffffffffc0201174:	7d3040ef          	jal	ffffffffc0206146 <do_exit>
ffffffffc0201178:	00095717          	auipc	a4,0x95
ffffffffc020117c:	75073703          	ld	a4,1872(a4) # ffffffffc02968c8 <current>
ffffffffc0201180:	b7d9                	j	ffffffffc0201146 <trap+0x48>
	...

ffffffffc0201184 <__alltraps>:
ffffffffc0201184:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201188:	00011463          	bnez	sp,ffffffffc0201190 <__alltraps+0xc>
ffffffffc020118c:	14002173          	csrr	sp,sscratch
ffffffffc0201190:	712d                	addi	sp,sp,-288
ffffffffc0201192:	e002                	sd	zero,0(sp)
ffffffffc0201194:	e406                	sd	ra,8(sp)
ffffffffc0201196:	ec0e                	sd	gp,24(sp)
ffffffffc0201198:	f012                	sd	tp,32(sp)
ffffffffc020119a:	f416                	sd	t0,40(sp)
ffffffffc020119c:	f81a                	sd	t1,48(sp)
ffffffffc020119e:	fc1e                	sd	t2,56(sp)
ffffffffc02011a0:	e0a2                	sd	s0,64(sp)
ffffffffc02011a2:	e4a6                	sd	s1,72(sp)
ffffffffc02011a4:	e8aa                	sd	a0,80(sp)
ffffffffc02011a6:	ecae                	sd	a1,88(sp)
ffffffffc02011a8:	f0b2                	sd	a2,96(sp)
ffffffffc02011aa:	f4b6                	sd	a3,104(sp)
ffffffffc02011ac:	f8ba                	sd	a4,112(sp)
ffffffffc02011ae:	fcbe                	sd	a5,120(sp)
ffffffffc02011b0:	e142                	sd	a6,128(sp)
ffffffffc02011b2:	e546                	sd	a7,136(sp)
ffffffffc02011b4:	e94a                	sd	s2,144(sp)
ffffffffc02011b6:	ed4e                	sd	s3,152(sp)
ffffffffc02011b8:	f152                	sd	s4,160(sp)
ffffffffc02011ba:	f556                	sd	s5,168(sp)
ffffffffc02011bc:	f95a                	sd	s6,176(sp)
ffffffffc02011be:	fd5e                	sd	s7,184(sp)
ffffffffc02011c0:	e1e2                	sd	s8,192(sp)
ffffffffc02011c2:	e5e6                	sd	s9,200(sp)
ffffffffc02011c4:	e9ea                	sd	s10,208(sp)
ffffffffc02011c6:	edee                	sd	s11,216(sp)
ffffffffc02011c8:	f1f2                	sd	t3,224(sp)
ffffffffc02011ca:	f5f6                	sd	t4,232(sp)
ffffffffc02011cc:	f9fa                	sd	t5,240(sp)
ffffffffc02011ce:	fdfe                	sd	t6,248(sp)
ffffffffc02011d0:	14001473          	csrrw	s0,sscratch,zero
ffffffffc02011d4:	100024f3          	csrr	s1,sstatus
ffffffffc02011d8:	14102973          	csrr	s2,sepc
ffffffffc02011dc:	143029f3          	csrr	s3,stval
ffffffffc02011e0:	14202a73          	csrr	s4,scause
ffffffffc02011e4:	e822                	sd	s0,16(sp)
ffffffffc02011e6:	e226                	sd	s1,256(sp)
ffffffffc02011e8:	e64a                	sd	s2,264(sp)
ffffffffc02011ea:	ea4e                	sd	s3,272(sp)
ffffffffc02011ec:	ee52                	sd	s4,280(sp)
ffffffffc02011ee:	850a                	mv	a0,sp
ffffffffc02011f0:	f0fff0ef          	jal	ffffffffc02010fe <trap>

ffffffffc02011f4 <__trapret>:
ffffffffc02011f4:	6492                	ld	s1,256(sp)
ffffffffc02011f6:	6932                	ld	s2,264(sp)
ffffffffc02011f8:	1004f413          	andi	s0,s1,256
ffffffffc02011fc:	e401                	bnez	s0,ffffffffc0201204 <__trapret+0x10>
ffffffffc02011fe:	1200                	addi	s0,sp,288
ffffffffc0201200:	14041073          	csrw	sscratch,s0
ffffffffc0201204:	10049073          	csrw	sstatus,s1
ffffffffc0201208:	14191073          	csrw	sepc,s2
ffffffffc020120c:	60a2                	ld	ra,8(sp)
ffffffffc020120e:	61e2                	ld	gp,24(sp)
ffffffffc0201210:	7202                	ld	tp,32(sp)
ffffffffc0201212:	72a2                	ld	t0,40(sp)
ffffffffc0201214:	7342                	ld	t1,48(sp)
ffffffffc0201216:	73e2                	ld	t2,56(sp)
ffffffffc0201218:	6406                	ld	s0,64(sp)
ffffffffc020121a:	64a6                	ld	s1,72(sp)
ffffffffc020121c:	6546                	ld	a0,80(sp)
ffffffffc020121e:	65e6                	ld	a1,88(sp)
ffffffffc0201220:	7606                	ld	a2,96(sp)
ffffffffc0201222:	76a6                	ld	a3,104(sp)
ffffffffc0201224:	7746                	ld	a4,112(sp)
ffffffffc0201226:	77e6                	ld	a5,120(sp)
ffffffffc0201228:	680a                	ld	a6,128(sp)
ffffffffc020122a:	68aa                	ld	a7,136(sp)
ffffffffc020122c:	694a                	ld	s2,144(sp)
ffffffffc020122e:	69ea                	ld	s3,152(sp)
ffffffffc0201230:	7a0a                	ld	s4,160(sp)
ffffffffc0201232:	7aaa                	ld	s5,168(sp)
ffffffffc0201234:	7b4a                	ld	s6,176(sp)
ffffffffc0201236:	7bea                	ld	s7,184(sp)
ffffffffc0201238:	6c0e                	ld	s8,192(sp)
ffffffffc020123a:	6cae                	ld	s9,200(sp)
ffffffffc020123c:	6d4e                	ld	s10,208(sp)
ffffffffc020123e:	6dee                	ld	s11,216(sp)
ffffffffc0201240:	7e0e                	ld	t3,224(sp)
ffffffffc0201242:	7eae                	ld	t4,232(sp)
ffffffffc0201244:	7f4e                	ld	t5,240(sp)
ffffffffc0201246:	7fee                	ld	t6,248(sp)
ffffffffc0201248:	6142                	ld	sp,16(sp)
ffffffffc020124a:	10200073          	sret

ffffffffc020124e <forkrets>:
ffffffffc020124e:	812a                	mv	sp,a0
ffffffffc0201250:	b755                	j	ffffffffc02011f4 <__trapret>

ffffffffc0201252 <default_init>:
ffffffffc0201252:	00090797          	auipc	a5,0x90
ffffffffc0201256:	55678793          	addi	a5,a5,1366 # ffffffffc02917a8 <free_area>
ffffffffc020125a:	e79c                	sd	a5,8(a5)
ffffffffc020125c:	e39c                	sd	a5,0(a5)
ffffffffc020125e:	0007a823          	sw	zero,16(a5)
ffffffffc0201262:	8082                	ret

ffffffffc0201264 <default_nr_free_pages>:
ffffffffc0201264:	00090517          	auipc	a0,0x90
ffffffffc0201268:	55456503          	lwu	a0,1364(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020126c:	8082                	ret

ffffffffc020126e <default_check>:
ffffffffc020126e:	711d                	addi	sp,sp,-96
ffffffffc0201270:	e0ca                	sd	s2,64(sp)
ffffffffc0201272:	00090917          	auipc	s2,0x90
ffffffffc0201276:	53690913          	addi	s2,s2,1334 # ffffffffc02917a8 <free_area>
ffffffffc020127a:	00893783          	ld	a5,8(s2)
ffffffffc020127e:	ec86                	sd	ra,88(sp)
ffffffffc0201280:	e8a2                	sd	s0,80(sp)
ffffffffc0201282:	e4a6                	sd	s1,72(sp)
ffffffffc0201284:	fc4e                	sd	s3,56(sp)
ffffffffc0201286:	f852                	sd	s4,48(sp)
ffffffffc0201288:	f456                	sd	s5,40(sp)
ffffffffc020128a:	f05a                	sd	s6,32(sp)
ffffffffc020128c:	ec5e                	sd	s7,24(sp)
ffffffffc020128e:	e862                	sd	s8,16(sp)
ffffffffc0201290:	e466                	sd	s9,8(sp)
ffffffffc0201292:	2f278363          	beq	a5,s2,ffffffffc0201578 <default_check+0x30a>
ffffffffc0201296:	4401                	li	s0,0
ffffffffc0201298:	4481                	li	s1,0
ffffffffc020129a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020129e:	8b09                	andi	a4,a4,2
ffffffffc02012a0:	2e070063          	beqz	a4,ffffffffc0201580 <default_check+0x312>
ffffffffc02012a4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012a8:	679c                	ld	a5,8(a5)
ffffffffc02012aa:	2485                	addiw	s1,s1,1
ffffffffc02012ac:	9c39                	addw	s0,s0,a4
ffffffffc02012ae:	ff2796e3          	bne	a5,s2,ffffffffc020129a <default_check+0x2c>
ffffffffc02012b2:	89a2                	mv	s3,s0
ffffffffc02012b4:	743000ef          	jal	ffffffffc02021f6 <nr_free_pages>
ffffffffc02012b8:	73351463          	bne	a0,s3,ffffffffc02019e0 <default_check+0x772>
ffffffffc02012bc:	4505                	li	a0,1
ffffffffc02012be:	6c7000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02012c2:	8a2a                	mv	s4,a0
ffffffffc02012c4:	44050e63          	beqz	a0,ffffffffc0201720 <default_check+0x4b2>
ffffffffc02012c8:	4505                	li	a0,1
ffffffffc02012ca:	6bb000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02012ce:	89aa                	mv	s3,a0
ffffffffc02012d0:	72050863          	beqz	a0,ffffffffc0201a00 <default_check+0x792>
ffffffffc02012d4:	4505                	li	a0,1
ffffffffc02012d6:	6af000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02012da:	8aaa                	mv	s5,a0
ffffffffc02012dc:	4c050263          	beqz	a0,ffffffffc02017a0 <default_check+0x532>
ffffffffc02012e0:	40a987b3          	sub	a5,s3,a0
ffffffffc02012e4:	40aa0733          	sub	a4,s4,a0
ffffffffc02012e8:	0017b793          	seqz	a5,a5
ffffffffc02012ec:	00173713          	seqz	a4,a4
ffffffffc02012f0:	8fd9                	or	a5,a5,a4
ffffffffc02012f2:	30079763          	bnez	a5,ffffffffc0201600 <default_check+0x392>
ffffffffc02012f6:	313a0563          	beq	s4,s3,ffffffffc0201600 <default_check+0x392>
ffffffffc02012fa:	000a2783          	lw	a5,0(s4)
ffffffffc02012fe:	2a079163          	bnez	a5,ffffffffc02015a0 <default_check+0x332>
ffffffffc0201302:	0009a783          	lw	a5,0(s3)
ffffffffc0201306:	28079d63          	bnez	a5,ffffffffc02015a0 <default_check+0x332>
ffffffffc020130a:	411c                	lw	a5,0(a0)
ffffffffc020130c:	28079a63          	bnez	a5,ffffffffc02015a0 <default_check+0x332>
ffffffffc0201310:	00095797          	auipc	a5,0x95
ffffffffc0201314:	5a87b783          	ld	a5,1448(a5) # ffffffffc02968b8 <pages>
ffffffffc0201318:	0000e617          	auipc	a2,0xe
ffffffffc020131c:	7a863603          	ld	a2,1960(a2) # ffffffffc020fac0 <nbase>
ffffffffc0201320:	00095697          	auipc	a3,0x95
ffffffffc0201324:	5906b683          	ld	a3,1424(a3) # ffffffffc02968b0 <npage>
ffffffffc0201328:	40fa0733          	sub	a4,s4,a5
ffffffffc020132c:	8719                	srai	a4,a4,0x6
ffffffffc020132e:	9732                	add	a4,a4,a2
ffffffffc0201330:	0732                	slli	a4,a4,0xc
ffffffffc0201332:	06b2                	slli	a3,a3,0xc
ffffffffc0201334:	2ad77663          	bgeu	a4,a3,ffffffffc02015e0 <default_check+0x372>
ffffffffc0201338:	40f98733          	sub	a4,s3,a5
ffffffffc020133c:	8719                	srai	a4,a4,0x6
ffffffffc020133e:	9732                	add	a4,a4,a2
ffffffffc0201340:	0732                	slli	a4,a4,0xc
ffffffffc0201342:	4cd77f63          	bgeu	a4,a3,ffffffffc0201820 <default_check+0x5b2>
ffffffffc0201346:	40f507b3          	sub	a5,a0,a5
ffffffffc020134a:	8799                	srai	a5,a5,0x6
ffffffffc020134c:	97b2                	add	a5,a5,a2
ffffffffc020134e:	07b2                	slli	a5,a5,0xc
ffffffffc0201350:	32d7f863          	bgeu	a5,a3,ffffffffc0201680 <default_check+0x412>
ffffffffc0201354:	4505                	li	a0,1
ffffffffc0201356:	00093c03          	ld	s8,0(s2)
ffffffffc020135a:	00893b83          	ld	s7,8(s2)
ffffffffc020135e:	00090b17          	auipc	s6,0x90
ffffffffc0201362:	45ab2b03          	lw	s6,1114(s6) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201366:	01293023          	sd	s2,0(s2)
ffffffffc020136a:	01293423          	sd	s2,8(s2)
ffffffffc020136e:	00090797          	auipc	a5,0x90
ffffffffc0201372:	4407a523          	sw	zero,1098(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201376:	60f000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc020137a:	2e051363          	bnez	a0,ffffffffc0201660 <default_check+0x3f2>
ffffffffc020137e:	8552                	mv	a0,s4
ffffffffc0201380:	4585                	li	a1,1
ffffffffc0201382:	63d000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201386:	854e                	mv	a0,s3
ffffffffc0201388:	4585                	li	a1,1
ffffffffc020138a:	635000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc020138e:	8556                	mv	a0,s5
ffffffffc0201390:	4585                	li	a1,1
ffffffffc0201392:	62d000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201396:	00090717          	auipc	a4,0x90
ffffffffc020139a:	42272703          	lw	a4,1058(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020139e:	478d                	li	a5,3
ffffffffc02013a0:	2af71063          	bne	a4,a5,ffffffffc0201640 <default_check+0x3d2>
ffffffffc02013a4:	4505                	li	a0,1
ffffffffc02013a6:	5df000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013aa:	89aa                	mv	s3,a0
ffffffffc02013ac:	26050a63          	beqz	a0,ffffffffc0201620 <default_check+0x3b2>
ffffffffc02013b0:	4505                	li	a0,1
ffffffffc02013b2:	5d3000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013b6:	8aaa                	mv	s5,a0
ffffffffc02013b8:	3c050463          	beqz	a0,ffffffffc0201780 <default_check+0x512>
ffffffffc02013bc:	4505                	li	a0,1
ffffffffc02013be:	5c7000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013c2:	8a2a                	mv	s4,a0
ffffffffc02013c4:	38050e63          	beqz	a0,ffffffffc0201760 <default_check+0x4f2>
ffffffffc02013c8:	4505                	li	a0,1
ffffffffc02013ca:	5bb000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013ce:	36051963          	bnez	a0,ffffffffc0201740 <default_check+0x4d2>
ffffffffc02013d2:	4585                	li	a1,1
ffffffffc02013d4:	854e                	mv	a0,s3
ffffffffc02013d6:	5e9000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc02013da:	00893783          	ld	a5,8(s2)
ffffffffc02013de:	1f278163          	beq	a5,s2,ffffffffc02015c0 <default_check+0x352>
ffffffffc02013e2:	4505                	li	a0,1
ffffffffc02013e4:	5a1000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013e8:	8caa                	mv	s9,a0
ffffffffc02013ea:	30a99b63          	bne	s3,a0,ffffffffc0201700 <default_check+0x492>
ffffffffc02013ee:	4505                	li	a0,1
ffffffffc02013f0:	595000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02013f4:	2e051663          	bnez	a0,ffffffffc02016e0 <default_check+0x472>
ffffffffc02013f8:	00090797          	auipc	a5,0x90
ffffffffc02013fc:	3c07a783          	lw	a5,960(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201400:	2c079063          	bnez	a5,ffffffffc02016c0 <default_check+0x452>
ffffffffc0201404:	8566                	mv	a0,s9
ffffffffc0201406:	4585                	li	a1,1
ffffffffc0201408:	01893023          	sd	s8,0(s2)
ffffffffc020140c:	01793423          	sd	s7,8(s2)
ffffffffc0201410:	01692823          	sw	s6,16(s2)
ffffffffc0201414:	5ab000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201418:	8556                	mv	a0,s5
ffffffffc020141a:	4585                	li	a1,1
ffffffffc020141c:	5a3000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201420:	8552                	mv	a0,s4
ffffffffc0201422:	4585                	li	a1,1
ffffffffc0201424:	59b000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201428:	4515                	li	a0,5
ffffffffc020142a:	55b000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc020142e:	89aa                	mv	s3,a0
ffffffffc0201430:	26050863          	beqz	a0,ffffffffc02016a0 <default_check+0x432>
ffffffffc0201434:	651c                	ld	a5,8(a0)
ffffffffc0201436:	8b89                	andi	a5,a5,2
ffffffffc0201438:	54079463          	bnez	a5,ffffffffc0201980 <default_check+0x712>
ffffffffc020143c:	4505                	li	a0,1
ffffffffc020143e:	00093b83          	ld	s7,0(s2)
ffffffffc0201442:	00893b03          	ld	s6,8(s2)
ffffffffc0201446:	01293023          	sd	s2,0(s2)
ffffffffc020144a:	01293423          	sd	s2,8(s2)
ffffffffc020144e:	537000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0201452:	50051763          	bnez	a0,ffffffffc0201960 <default_check+0x6f2>
ffffffffc0201456:	08098a13          	addi	s4,s3,128
ffffffffc020145a:	8552                	mv	a0,s4
ffffffffc020145c:	458d                	li	a1,3
ffffffffc020145e:	00090c17          	auipc	s8,0x90
ffffffffc0201462:	35ac2c03          	lw	s8,858(s8) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201466:	00090797          	auipc	a5,0x90
ffffffffc020146a:	3407a923          	sw	zero,850(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020146e:	551000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201472:	4511                	li	a0,4
ffffffffc0201474:	511000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0201478:	4c051463          	bnez	a0,ffffffffc0201940 <default_check+0x6d2>
ffffffffc020147c:	0889b783          	ld	a5,136(s3)
ffffffffc0201480:	8b89                	andi	a5,a5,2
ffffffffc0201482:	48078f63          	beqz	a5,ffffffffc0201920 <default_check+0x6b2>
ffffffffc0201486:	0909a503          	lw	a0,144(s3)
ffffffffc020148a:	478d                	li	a5,3
ffffffffc020148c:	48f51a63          	bne	a0,a5,ffffffffc0201920 <default_check+0x6b2>
ffffffffc0201490:	4f5000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0201494:	8aaa                	mv	s5,a0
ffffffffc0201496:	46050563          	beqz	a0,ffffffffc0201900 <default_check+0x692>
ffffffffc020149a:	4505                	li	a0,1
ffffffffc020149c:	4e9000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02014a0:	44051063          	bnez	a0,ffffffffc02018e0 <default_check+0x672>
ffffffffc02014a4:	415a1e63          	bne	s4,s5,ffffffffc02018c0 <default_check+0x652>
ffffffffc02014a8:	4585                	li	a1,1
ffffffffc02014aa:	854e                	mv	a0,s3
ffffffffc02014ac:	513000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc02014b0:	8552                	mv	a0,s4
ffffffffc02014b2:	458d                	li	a1,3
ffffffffc02014b4:	50b000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc02014b8:	0089b783          	ld	a5,8(s3)
ffffffffc02014bc:	8b89                	andi	a5,a5,2
ffffffffc02014be:	3e078163          	beqz	a5,ffffffffc02018a0 <default_check+0x632>
ffffffffc02014c2:	0109aa83          	lw	s5,16(s3)
ffffffffc02014c6:	4785                	li	a5,1
ffffffffc02014c8:	3cfa9c63          	bne	s5,a5,ffffffffc02018a0 <default_check+0x632>
ffffffffc02014cc:	008a3783          	ld	a5,8(s4)
ffffffffc02014d0:	8b89                	andi	a5,a5,2
ffffffffc02014d2:	3a078763          	beqz	a5,ffffffffc0201880 <default_check+0x612>
ffffffffc02014d6:	010a2703          	lw	a4,16(s4)
ffffffffc02014da:	478d                	li	a5,3
ffffffffc02014dc:	3af71263          	bne	a4,a5,ffffffffc0201880 <default_check+0x612>
ffffffffc02014e0:	8556                	mv	a0,s5
ffffffffc02014e2:	4a3000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02014e6:	36a99d63          	bne	s3,a0,ffffffffc0201860 <default_check+0x5f2>
ffffffffc02014ea:	85d6                	mv	a1,s5
ffffffffc02014ec:	4d3000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc02014f0:	4509                	li	a0,2
ffffffffc02014f2:	493000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc02014f6:	34aa1563          	bne	s4,a0,ffffffffc0201840 <default_check+0x5d2>
ffffffffc02014fa:	4589                	li	a1,2
ffffffffc02014fc:	4c3000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201500:	04098513          	addi	a0,s3,64
ffffffffc0201504:	85d6                	mv	a1,s5
ffffffffc0201506:	4b9000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc020150a:	4515                	li	a0,5
ffffffffc020150c:	479000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0201510:	89aa                	mv	s3,a0
ffffffffc0201512:	48050763          	beqz	a0,ffffffffc02019a0 <default_check+0x732>
ffffffffc0201516:	8556                	mv	a0,s5
ffffffffc0201518:	46d000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc020151c:	2e051263          	bnez	a0,ffffffffc0201800 <default_check+0x592>
ffffffffc0201520:	00090797          	auipc	a5,0x90
ffffffffc0201524:	2987a783          	lw	a5,664(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201528:	2a079c63          	bnez	a5,ffffffffc02017e0 <default_check+0x572>
ffffffffc020152c:	854e                	mv	a0,s3
ffffffffc020152e:	4595                	li	a1,5
ffffffffc0201530:	01892823          	sw	s8,16(s2)
ffffffffc0201534:	01793023          	sd	s7,0(s2)
ffffffffc0201538:	01693423          	sd	s6,8(s2)
ffffffffc020153c:	483000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0201540:	00893783          	ld	a5,8(s2)
ffffffffc0201544:	01278963          	beq	a5,s2,ffffffffc0201556 <default_check+0x2e8>
ffffffffc0201548:	ff87a703          	lw	a4,-8(a5)
ffffffffc020154c:	679c                	ld	a5,8(a5)
ffffffffc020154e:	34fd                	addiw	s1,s1,-1
ffffffffc0201550:	9c19                	subw	s0,s0,a4
ffffffffc0201552:	ff279be3          	bne	a5,s2,ffffffffc0201548 <default_check+0x2da>
ffffffffc0201556:	26049563          	bnez	s1,ffffffffc02017c0 <default_check+0x552>
ffffffffc020155a:	46041363          	bnez	s0,ffffffffc02019c0 <default_check+0x752>
ffffffffc020155e:	60e6                	ld	ra,88(sp)
ffffffffc0201560:	6446                	ld	s0,80(sp)
ffffffffc0201562:	64a6                	ld	s1,72(sp)
ffffffffc0201564:	6906                	ld	s2,64(sp)
ffffffffc0201566:	79e2                	ld	s3,56(sp)
ffffffffc0201568:	7a42                	ld	s4,48(sp)
ffffffffc020156a:	7aa2                	ld	s5,40(sp)
ffffffffc020156c:	7b02                	ld	s6,32(sp)
ffffffffc020156e:	6be2                	ld	s7,24(sp)
ffffffffc0201570:	6c42                	ld	s8,16(sp)
ffffffffc0201572:	6ca2                	ld	s9,8(sp)
ffffffffc0201574:	6125                	addi	sp,sp,96
ffffffffc0201576:	8082                	ret
ffffffffc0201578:	4981                	li	s3,0
ffffffffc020157a:	4401                	li	s0,0
ffffffffc020157c:	4481                	li	s1,0
ffffffffc020157e:	bb1d                	j	ffffffffc02012b4 <default_check+0x46>
ffffffffc0201580:	0000b697          	auipc	a3,0xb
ffffffffc0201584:	d5068693          	addi	a3,a3,-688 # ffffffffc020c2d0 <etext+0xb0c>
ffffffffc0201588:	0000a617          	auipc	a2,0xa
ffffffffc020158c:	67860613          	addi	a2,a2,1656 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201590:	0ef00593          	li	a1,239
ffffffffc0201594:	0000b517          	auipc	a0,0xb
ffffffffc0201598:	d4c50513          	addi	a0,a0,-692 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020159c:	eaffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015a0:	0000b697          	auipc	a3,0xb
ffffffffc02015a4:	e0068693          	addi	a3,a3,-512 # ffffffffc020c3a0 <etext+0xbdc>
ffffffffc02015a8:	0000a617          	auipc	a2,0xa
ffffffffc02015ac:	65860613          	addi	a2,a2,1624 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02015b0:	0bd00593          	li	a1,189
ffffffffc02015b4:	0000b517          	auipc	a0,0xb
ffffffffc02015b8:	d2c50513          	addi	a0,a0,-724 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02015bc:	e8ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015c0:	0000b697          	auipc	a3,0xb
ffffffffc02015c4:	ea868693          	addi	a3,a3,-344 # ffffffffc020c468 <etext+0xca4>
ffffffffc02015c8:	0000a617          	auipc	a2,0xa
ffffffffc02015cc:	63860613          	addi	a2,a2,1592 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02015d0:	0d800593          	li	a1,216
ffffffffc02015d4:	0000b517          	auipc	a0,0xb
ffffffffc02015d8:	d0c50513          	addi	a0,a0,-756 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02015dc:	e6ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015e0:	0000b697          	auipc	a3,0xb
ffffffffc02015e4:	e0068693          	addi	a3,a3,-512 # ffffffffc020c3e0 <etext+0xc1c>
ffffffffc02015e8:	0000a617          	auipc	a2,0xa
ffffffffc02015ec:	61860613          	addi	a2,a2,1560 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02015f0:	0bf00593          	li	a1,191
ffffffffc02015f4:	0000b517          	auipc	a0,0xb
ffffffffc02015f8:	cec50513          	addi	a0,a0,-788 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02015fc:	e4ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201600:	0000b697          	auipc	a3,0xb
ffffffffc0201604:	d7868693          	addi	a3,a3,-648 # ffffffffc020c378 <etext+0xbb4>
ffffffffc0201608:	0000a617          	auipc	a2,0xa
ffffffffc020160c:	5f860613          	addi	a2,a2,1528 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201610:	0bc00593          	li	a1,188
ffffffffc0201614:	0000b517          	auipc	a0,0xb
ffffffffc0201618:	ccc50513          	addi	a0,a0,-820 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020161c:	e2ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201620:	0000b697          	auipc	a3,0xb
ffffffffc0201624:	cf868693          	addi	a3,a3,-776 # ffffffffc020c318 <etext+0xb54>
ffffffffc0201628:	0000a617          	auipc	a2,0xa
ffffffffc020162c:	5d860613          	addi	a2,a2,1496 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201630:	0d100593          	li	a1,209
ffffffffc0201634:	0000b517          	auipc	a0,0xb
ffffffffc0201638:	cac50513          	addi	a0,a0,-852 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020163c:	e0ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201640:	0000b697          	auipc	a3,0xb
ffffffffc0201644:	e1868693          	addi	a3,a3,-488 # ffffffffc020c458 <etext+0xc94>
ffffffffc0201648:	0000a617          	auipc	a2,0xa
ffffffffc020164c:	5b860613          	addi	a2,a2,1464 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201650:	0cf00593          	li	a1,207
ffffffffc0201654:	0000b517          	auipc	a0,0xb
ffffffffc0201658:	c8c50513          	addi	a0,a0,-884 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020165c:	deffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201660:	0000b697          	auipc	a3,0xb
ffffffffc0201664:	de068693          	addi	a3,a3,-544 # ffffffffc020c440 <etext+0xc7c>
ffffffffc0201668:	0000a617          	auipc	a2,0xa
ffffffffc020166c:	59860613          	addi	a2,a2,1432 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201670:	0ca00593          	li	a1,202
ffffffffc0201674:	0000b517          	auipc	a0,0xb
ffffffffc0201678:	c6c50513          	addi	a0,a0,-916 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020167c:	dcffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201680:	0000b697          	auipc	a3,0xb
ffffffffc0201684:	da068693          	addi	a3,a3,-608 # ffffffffc020c420 <etext+0xc5c>
ffffffffc0201688:	0000a617          	auipc	a2,0xa
ffffffffc020168c:	57860613          	addi	a2,a2,1400 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201690:	0c100593          	li	a1,193
ffffffffc0201694:	0000b517          	auipc	a0,0xb
ffffffffc0201698:	c4c50513          	addi	a0,a0,-948 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020169c:	daffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016a0:	0000b697          	auipc	a3,0xb
ffffffffc02016a4:	e1068693          	addi	a3,a3,-496 # ffffffffc020c4b0 <etext+0xcec>
ffffffffc02016a8:	0000a617          	auipc	a2,0xa
ffffffffc02016ac:	55860613          	addi	a2,a2,1368 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02016b0:	0f700593          	li	a1,247
ffffffffc02016b4:	0000b517          	auipc	a0,0xb
ffffffffc02016b8:	c2c50513          	addi	a0,a0,-980 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02016bc:	d8ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016c0:	0000b697          	auipc	a3,0xb
ffffffffc02016c4:	de068693          	addi	a3,a3,-544 # ffffffffc020c4a0 <etext+0xcdc>
ffffffffc02016c8:	0000a617          	auipc	a2,0xa
ffffffffc02016cc:	53860613          	addi	a2,a2,1336 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02016d0:	0de00593          	li	a1,222
ffffffffc02016d4:	0000b517          	auipc	a0,0xb
ffffffffc02016d8:	c0c50513          	addi	a0,a0,-1012 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02016dc:	d6ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016e0:	0000b697          	auipc	a3,0xb
ffffffffc02016e4:	d6068693          	addi	a3,a3,-672 # ffffffffc020c440 <etext+0xc7c>
ffffffffc02016e8:	0000a617          	auipc	a2,0xa
ffffffffc02016ec:	51860613          	addi	a2,a2,1304 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02016f0:	0dc00593          	li	a1,220
ffffffffc02016f4:	0000b517          	auipc	a0,0xb
ffffffffc02016f8:	bec50513          	addi	a0,a0,-1044 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02016fc:	d4ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201700:	0000b697          	auipc	a3,0xb
ffffffffc0201704:	d8068693          	addi	a3,a3,-640 # ffffffffc020c480 <etext+0xcbc>
ffffffffc0201708:	0000a617          	auipc	a2,0xa
ffffffffc020170c:	4f860613          	addi	a2,a2,1272 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201710:	0db00593          	li	a1,219
ffffffffc0201714:	0000b517          	auipc	a0,0xb
ffffffffc0201718:	bcc50513          	addi	a0,a0,-1076 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020171c:	d2ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201720:	0000b697          	auipc	a3,0xb
ffffffffc0201724:	bf868693          	addi	a3,a3,-1032 # ffffffffc020c318 <etext+0xb54>
ffffffffc0201728:	0000a617          	auipc	a2,0xa
ffffffffc020172c:	4d860613          	addi	a2,a2,1240 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201730:	0b800593          	li	a1,184
ffffffffc0201734:	0000b517          	auipc	a0,0xb
ffffffffc0201738:	bac50513          	addi	a0,a0,-1108 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020173c:	d0ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201740:	0000b697          	auipc	a3,0xb
ffffffffc0201744:	d0068693          	addi	a3,a3,-768 # ffffffffc020c440 <etext+0xc7c>
ffffffffc0201748:	0000a617          	auipc	a2,0xa
ffffffffc020174c:	4b860613          	addi	a2,a2,1208 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201750:	0d500593          	li	a1,213
ffffffffc0201754:	0000b517          	auipc	a0,0xb
ffffffffc0201758:	b8c50513          	addi	a0,a0,-1140 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020175c:	ceffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201760:	0000b697          	auipc	a3,0xb
ffffffffc0201764:	bf868693          	addi	a3,a3,-1032 # ffffffffc020c358 <etext+0xb94>
ffffffffc0201768:	0000a617          	auipc	a2,0xa
ffffffffc020176c:	49860613          	addi	a2,a2,1176 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201770:	0d300593          	li	a1,211
ffffffffc0201774:	0000b517          	auipc	a0,0xb
ffffffffc0201778:	b6c50513          	addi	a0,a0,-1172 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020177c:	ccffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201780:	0000b697          	auipc	a3,0xb
ffffffffc0201784:	bb868693          	addi	a3,a3,-1096 # ffffffffc020c338 <etext+0xb74>
ffffffffc0201788:	0000a617          	auipc	a2,0xa
ffffffffc020178c:	47860613          	addi	a2,a2,1144 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201790:	0d200593          	li	a1,210
ffffffffc0201794:	0000b517          	auipc	a0,0xb
ffffffffc0201798:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020179c:	caffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017a0:	0000b697          	auipc	a3,0xb
ffffffffc02017a4:	bb868693          	addi	a3,a3,-1096 # ffffffffc020c358 <etext+0xb94>
ffffffffc02017a8:	0000a617          	auipc	a2,0xa
ffffffffc02017ac:	45860613          	addi	a2,a2,1112 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02017b0:	0ba00593          	li	a1,186
ffffffffc02017b4:	0000b517          	auipc	a0,0xb
ffffffffc02017b8:	b2c50513          	addi	a0,a0,-1236 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02017bc:	c8ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017c0:	0000b697          	auipc	a3,0xb
ffffffffc02017c4:	e4068693          	addi	a3,a3,-448 # ffffffffc020c600 <etext+0xe3c>
ffffffffc02017c8:	0000a617          	auipc	a2,0xa
ffffffffc02017cc:	43860613          	addi	a2,a2,1080 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02017d0:	12400593          	li	a1,292
ffffffffc02017d4:	0000b517          	auipc	a0,0xb
ffffffffc02017d8:	b0c50513          	addi	a0,a0,-1268 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02017dc:	c6ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017e0:	0000b697          	auipc	a3,0xb
ffffffffc02017e4:	cc068693          	addi	a3,a3,-832 # ffffffffc020c4a0 <etext+0xcdc>
ffffffffc02017e8:	0000a617          	auipc	a2,0xa
ffffffffc02017ec:	41860613          	addi	a2,a2,1048 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02017f0:	11900593          	li	a1,281
ffffffffc02017f4:	0000b517          	auipc	a0,0xb
ffffffffc02017f8:	aec50513          	addi	a0,a0,-1300 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02017fc:	c4ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201800:	0000b697          	auipc	a3,0xb
ffffffffc0201804:	c4068693          	addi	a3,a3,-960 # ffffffffc020c440 <etext+0xc7c>
ffffffffc0201808:	0000a617          	auipc	a2,0xa
ffffffffc020180c:	3f860613          	addi	a2,a2,1016 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201810:	11700593          	li	a1,279
ffffffffc0201814:	0000b517          	auipc	a0,0xb
ffffffffc0201818:	acc50513          	addi	a0,a0,-1332 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020181c:	c2ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201820:	0000b697          	auipc	a3,0xb
ffffffffc0201824:	be068693          	addi	a3,a3,-1056 # ffffffffc020c400 <etext+0xc3c>
ffffffffc0201828:	0000a617          	auipc	a2,0xa
ffffffffc020182c:	3d860613          	addi	a2,a2,984 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201830:	0c000593          	li	a1,192
ffffffffc0201834:	0000b517          	auipc	a0,0xb
ffffffffc0201838:	aac50513          	addi	a0,a0,-1364 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020183c:	c0ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201840:	0000b697          	auipc	a3,0xb
ffffffffc0201844:	d8068693          	addi	a3,a3,-640 # ffffffffc020c5c0 <etext+0xdfc>
ffffffffc0201848:	0000a617          	auipc	a2,0xa
ffffffffc020184c:	3b860613          	addi	a2,a2,952 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201850:	11100593          	li	a1,273
ffffffffc0201854:	0000b517          	auipc	a0,0xb
ffffffffc0201858:	a8c50513          	addi	a0,a0,-1396 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020185c:	beffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201860:	0000b697          	auipc	a3,0xb
ffffffffc0201864:	d4068693          	addi	a3,a3,-704 # ffffffffc020c5a0 <etext+0xddc>
ffffffffc0201868:	0000a617          	auipc	a2,0xa
ffffffffc020186c:	39860613          	addi	a2,a2,920 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201870:	10f00593          	li	a1,271
ffffffffc0201874:	0000b517          	auipc	a0,0xb
ffffffffc0201878:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020187c:	bcffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201880:	0000b697          	auipc	a3,0xb
ffffffffc0201884:	cf868693          	addi	a3,a3,-776 # ffffffffc020c578 <etext+0xdb4>
ffffffffc0201888:	0000a617          	auipc	a2,0xa
ffffffffc020188c:	37860613          	addi	a2,a2,888 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201890:	10d00593          	li	a1,269
ffffffffc0201894:	0000b517          	auipc	a0,0xb
ffffffffc0201898:	a4c50513          	addi	a0,a0,-1460 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020189c:	baffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018a0:	0000b697          	auipc	a3,0xb
ffffffffc02018a4:	cb068693          	addi	a3,a3,-848 # ffffffffc020c550 <etext+0xd8c>
ffffffffc02018a8:	0000a617          	auipc	a2,0xa
ffffffffc02018ac:	35860613          	addi	a2,a2,856 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02018b0:	10c00593          	li	a1,268
ffffffffc02018b4:	0000b517          	auipc	a0,0xb
ffffffffc02018b8:	a2c50513          	addi	a0,a0,-1492 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02018bc:	b8ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018c0:	0000b697          	auipc	a3,0xb
ffffffffc02018c4:	c8068693          	addi	a3,a3,-896 # ffffffffc020c540 <etext+0xd7c>
ffffffffc02018c8:	0000a617          	auipc	a2,0xa
ffffffffc02018cc:	33860613          	addi	a2,a2,824 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02018d0:	10700593          	li	a1,263
ffffffffc02018d4:	0000b517          	auipc	a0,0xb
ffffffffc02018d8:	a0c50513          	addi	a0,a0,-1524 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02018dc:	b6ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018e0:	0000b697          	auipc	a3,0xb
ffffffffc02018e4:	b6068693          	addi	a3,a3,-1184 # ffffffffc020c440 <etext+0xc7c>
ffffffffc02018e8:	0000a617          	auipc	a2,0xa
ffffffffc02018ec:	31860613          	addi	a2,a2,792 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02018f0:	10600593          	li	a1,262
ffffffffc02018f4:	0000b517          	auipc	a0,0xb
ffffffffc02018f8:	9ec50513          	addi	a0,a0,-1556 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02018fc:	b4ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201900:	0000b697          	auipc	a3,0xb
ffffffffc0201904:	c2068693          	addi	a3,a3,-992 # ffffffffc020c520 <etext+0xd5c>
ffffffffc0201908:	0000a617          	auipc	a2,0xa
ffffffffc020190c:	2f860613          	addi	a2,a2,760 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201910:	10500593          	li	a1,261
ffffffffc0201914:	0000b517          	auipc	a0,0xb
ffffffffc0201918:	9cc50513          	addi	a0,a0,-1588 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020191c:	b2ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201920:	0000b697          	auipc	a3,0xb
ffffffffc0201924:	bd068693          	addi	a3,a3,-1072 # ffffffffc020c4f0 <etext+0xd2c>
ffffffffc0201928:	0000a617          	auipc	a2,0xa
ffffffffc020192c:	2d860613          	addi	a2,a2,728 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201930:	10400593          	li	a1,260
ffffffffc0201934:	0000b517          	auipc	a0,0xb
ffffffffc0201938:	9ac50513          	addi	a0,a0,-1620 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020193c:	b0ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201940:	0000b697          	auipc	a3,0xb
ffffffffc0201944:	b9868693          	addi	a3,a3,-1128 # ffffffffc020c4d8 <etext+0xd14>
ffffffffc0201948:	0000a617          	auipc	a2,0xa
ffffffffc020194c:	2b860613          	addi	a2,a2,696 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201950:	10300593          	li	a1,259
ffffffffc0201954:	0000b517          	auipc	a0,0xb
ffffffffc0201958:	98c50513          	addi	a0,a0,-1652 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020195c:	aeffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201960:	0000b697          	auipc	a3,0xb
ffffffffc0201964:	ae068693          	addi	a3,a3,-1312 # ffffffffc020c440 <etext+0xc7c>
ffffffffc0201968:	0000a617          	auipc	a2,0xa
ffffffffc020196c:	29860613          	addi	a2,a2,664 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201970:	0fd00593          	li	a1,253
ffffffffc0201974:	0000b517          	auipc	a0,0xb
ffffffffc0201978:	96c50513          	addi	a0,a0,-1684 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020197c:	acffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201980:	0000b697          	auipc	a3,0xb
ffffffffc0201984:	b4068693          	addi	a3,a3,-1216 # ffffffffc020c4c0 <etext+0xcfc>
ffffffffc0201988:	0000a617          	auipc	a2,0xa
ffffffffc020198c:	27860613          	addi	a2,a2,632 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201990:	0f800593          	li	a1,248
ffffffffc0201994:	0000b517          	auipc	a0,0xb
ffffffffc0201998:	94c50513          	addi	a0,a0,-1716 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc020199c:	aaffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019a0:	0000b697          	auipc	a3,0xb
ffffffffc02019a4:	c4068693          	addi	a3,a3,-960 # ffffffffc020c5e0 <etext+0xe1c>
ffffffffc02019a8:	0000a617          	auipc	a2,0xa
ffffffffc02019ac:	25860613          	addi	a2,a2,600 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02019b0:	11600593          	li	a1,278
ffffffffc02019b4:	0000b517          	auipc	a0,0xb
ffffffffc02019b8:	92c50513          	addi	a0,a0,-1748 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02019bc:	a8ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019c0:	0000b697          	auipc	a3,0xb
ffffffffc02019c4:	c5068693          	addi	a3,a3,-944 # ffffffffc020c610 <etext+0xe4c>
ffffffffc02019c8:	0000a617          	auipc	a2,0xa
ffffffffc02019cc:	23860613          	addi	a2,a2,568 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02019d0:	12500593          	li	a1,293
ffffffffc02019d4:	0000b517          	auipc	a0,0xb
ffffffffc02019d8:	90c50513          	addi	a0,a0,-1780 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02019dc:	a6ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019e0:	0000b697          	auipc	a3,0xb
ffffffffc02019e4:	91868693          	addi	a3,a3,-1768 # ffffffffc020c2f8 <etext+0xb34>
ffffffffc02019e8:	0000a617          	auipc	a2,0xa
ffffffffc02019ec:	21860613          	addi	a2,a2,536 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02019f0:	0f200593          	li	a1,242
ffffffffc02019f4:	0000b517          	auipc	a0,0xb
ffffffffc02019f8:	8ec50513          	addi	a0,a0,-1812 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc02019fc:	a4ffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a00:	0000b697          	auipc	a3,0xb
ffffffffc0201a04:	93868693          	addi	a3,a3,-1736 # ffffffffc020c338 <etext+0xb74>
ffffffffc0201a08:	0000a617          	auipc	a2,0xa
ffffffffc0201a0c:	1f860613          	addi	a2,a2,504 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201a10:	0b900593          	li	a1,185
ffffffffc0201a14:	0000b517          	auipc	a0,0xb
ffffffffc0201a18:	8cc50513          	addi	a0,a0,-1844 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201a1c:	a2ffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201a20 <default_free_pages>:
ffffffffc0201a20:	1141                	addi	sp,sp,-16
ffffffffc0201a22:	e406                	sd	ra,8(sp)
ffffffffc0201a24:	14058663          	beqz	a1,ffffffffc0201b70 <default_free_pages+0x150>
ffffffffc0201a28:	00659713          	slli	a4,a1,0x6
ffffffffc0201a2c:	00e506b3          	add	a3,a0,a4
ffffffffc0201a30:	87aa                	mv	a5,a0
ffffffffc0201a32:	c30d                	beqz	a4,ffffffffc0201a54 <default_free_pages+0x34>
ffffffffc0201a34:	6798                	ld	a4,8(a5)
ffffffffc0201a36:	8b05                	andi	a4,a4,1
ffffffffc0201a38:	10071c63          	bnez	a4,ffffffffc0201b50 <default_free_pages+0x130>
ffffffffc0201a3c:	6798                	ld	a4,8(a5)
ffffffffc0201a3e:	8b09                	andi	a4,a4,2
ffffffffc0201a40:	10071863          	bnez	a4,ffffffffc0201b50 <default_free_pages+0x130>
ffffffffc0201a44:	0007b423          	sd	zero,8(a5)
ffffffffc0201a48:	0007a023          	sw	zero,0(a5)
ffffffffc0201a4c:	04078793          	addi	a5,a5,64
ffffffffc0201a50:	fed792e3          	bne	a5,a3,ffffffffc0201a34 <default_free_pages+0x14>
ffffffffc0201a54:	c90c                	sw	a1,16(a0)
ffffffffc0201a56:	00850893          	addi	a7,a0,8
ffffffffc0201a5a:	4789                	li	a5,2
ffffffffc0201a5c:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a60:	00090717          	auipc	a4,0x90
ffffffffc0201a64:	d5872703          	lw	a4,-680(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201a68:	00090697          	auipc	a3,0x90
ffffffffc0201a6c:	d4068693          	addi	a3,a3,-704 # ffffffffc02917a8 <free_area>
ffffffffc0201a70:	669c                	ld	a5,8(a3)
ffffffffc0201a72:	9f2d                	addw	a4,a4,a1
ffffffffc0201a74:	ca98                	sw	a4,16(a3)
ffffffffc0201a76:	0ad78163          	beq	a5,a3,ffffffffc0201b18 <default_free_pages+0xf8>
ffffffffc0201a7a:	fe878713          	addi	a4,a5,-24
ffffffffc0201a7e:	4581                	li	a1,0
ffffffffc0201a80:	01850613          	addi	a2,a0,24
ffffffffc0201a84:	00e56a63          	bltu	a0,a4,ffffffffc0201a98 <default_free_pages+0x78>
ffffffffc0201a88:	6798                	ld	a4,8(a5)
ffffffffc0201a8a:	04d70c63          	beq	a4,a3,ffffffffc0201ae2 <default_free_pages+0xc2>
ffffffffc0201a8e:	87ba                	mv	a5,a4
ffffffffc0201a90:	fe878713          	addi	a4,a5,-24
ffffffffc0201a94:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a88 <default_free_pages+0x68>
ffffffffc0201a98:	c199                	beqz	a1,ffffffffc0201a9e <default_free_pages+0x7e>
ffffffffc0201a9a:	0106b023          	sd	a6,0(a3)
ffffffffc0201a9e:	6398                	ld	a4,0(a5)
ffffffffc0201aa0:	e390                	sd	a2,0(a5)
ffffffffc0201aa2:	e710                	sd	a2,8(a4)
ffffffffc0201aa4:	ed18                	sd	a4,24(a0)
ffffffffc0201aa6:	f11c                	sd	a5,32(a0)
ffffffffc0201aa8:	00d70d63          	beq	a4,a3,ffffffffc0201ac2 <default_free_pages+0xa2>
ffffffffc0201aac:	ff872583          	lw	a1,-8(a4)
ffffffffc0201ab0:	fe870613          	addi	a2,a4,-24
ffffffffc0201ab4:	02059813          	slli	a6,a1,0x20
ffffffffc0201ab8:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201abc:	97b2                	add	a5,a5,a2
ffffffffc0201abe:	02f50c63          	beq	a0,a5,ffffffffc0201af6 <default_free_pages+0xd6>
ffffffffc0201ac2:	711c                	ld	a5,32(a0)
ffffffffc0201ac4:	00d78c63          	beq	a5,a3,ffffffffc0201adc <default_free_pages+0xbc>
ffffffffc0201ac8:	4910                	lw	a2,16(a0)
ffffffffc0201aca:	fe878693          	addi	a3,a5,-24
ffffffffc0201ace:	02061593          	slli	a1,a2,0x20
ffffffffc0201ad2:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201ad6:	972a                	add	a4,a4,a0
ffffffffc0201ad8:	04e68c63          	beq	a3,a4,ffffffffc0201b30 <default_free_pages+0x110>
ffffffffc0201adc:	60a2                	ld	ra,8(sp)
ffffffffc0201ade:	0141                	addi	sp,sp,16
ffffffffc0201ae0:	8082                	ret
ffffffffc0201ae2:	e790                	sd	a2,8(a5)
ffffffffc0201ae4:	f114                	sd	a3,32(a0)
ffffffffc0201ae6:	6798                	ld	a4,8(a5)
ffffffffc0201ae8:	ed1c                	sd	a5,24(a0)
ffffffffc0201aea:	8832                	mv	a6,a2
ffffffffc0201aec:	02d70f63          	beq	a4,a3,ffffffffc0201b2a <default_free_pages+0x10a>
ffffffffc0201af0:	4585                	li	a1,1
ffffffffc0201af2:	87ba                	mv	a5,a4
ffffffffc0201af4:	bf71                	j	ffffffffc0201a90 <default_free_pages+0x70>
ffffffffc0201af6:	491c                	lw	a5,16(a0)
ffffffffc0201af8:	5875                	li	a6,-3
ffffffffc0201afa:	9fad                	addw	a5,a5,a1
ffffffffc0201afc:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201b00:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201b04:	01853803          	ld	a6,24(a0)
ffffffffc0201b08:	710c                	ld	a1,32(a0)
ffffffffc0201b0a:	8532                	mv	a0,a2
ffffffffc0201b0c:	00b83423          	sd	a1,8(a6)
ffffffffc0201b10:	671c                	ld	a5,8(a4)
ffffffffc0201b12:	0105b023          	sd	a6,0(a1)
ffffffffc0201b16:	b77d                	j	ffffffffc0201ac4 <default_free_pages+0xa4>
ffffffffc0201b18:	60a2                	ld	ra,8(sp)
ffffffffc0201b1a:	01850713          	addi	a4,a0,24
ffffffffc0201b1e:	f11c                	sd	a5,32(a0)
ffffffffc0201b20:	ed1c                	sd	a5,24(a0)
ffffffffc0201b22:	e398                	sd	a4,0(a5)
ffffffffc0201b24:	e798                	sd	a4,8(a5)
ffffffffc0201b26:	0141                	addi	sp,sp,16
ffffffffc0201b28:	8082                	ret
ffffffffc0201b2a:	e290                	sd	a2,0(a3)
ffffffffc0201b2c:	873e                	mv	a4,a5
ffffffffc0201b2e:	bfad                	j	ffffffffc0201aa8 <default_free_pages+0x88>
ffffffffc0201b30:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b34:	56f5                	li	a3,-3
ffffffffc0201b36:	9f31                	addw	a4,a4,a2
ffffffffc0201b38:	c918                	sw	a4,16(a0)
ffffffffc0201b3a:	ff078713          	addi	a4,a5,-16
ffffffffc0201b3e:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc0201b42:	6398                	ld	a4,0(a5)
ffffffffc0201b44:	679c                	ld	a5,8(a5)
ffffffffc0201b46:	60a2                	ld	ra,8(sp)
ffffffffc0201b48:	e71c                	sd	a5,8(a4)
ffffffffc0201b4a:	e398                	sd	a4,0(a5)
ffffffffc0201b4c:	0141                	addi	sp,sp,16
ffffffffc0201b4e:	8082                	ret
ffffffffc0201b50:	0000b697          	auipc	a3,0xb
ffffffffc0201b54:	ad868693          	addi	a3,a3,-1320 # ffffffffc020c628 <etext+0xe64>
ffffffffc0201b58:	0000a617          	auipc	a2,0xa
ffffffffc0201b5c:	0a860613          	addi	a2,a2,168 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201b60:	08200593          	li	a1,130
ffffffffc0201b64:	0000a517          	auipc	a0,0xa
ffffffffc0201b68:	77c50513          	addi	a0,a0,1916 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201b6c:	8dffe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b70:	0000b697          	auipc	a3,0xb
ffffffffc0201b74:	ab068693          	addi	a3,a3,-1360 # ffffffffc020c620 <etext+0xe5c>
ffffffffc0201b78:	0000a617          	auipc	a2,0xa
ffffffffc0201b7c:	08860613          	addi	a2,a2,136 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201b80:	07f00593          	li	a1,127
ffffffffc0201b84:	0000a517          	auipc	a0,0xa
ffffffffc0201b88:	75c50513          	addi	a0,a0,1884 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201b8c:	8bffe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201b90 <default_alloc_pages>:
ffffffffc0201b90:	c951                	beqz	a0,ffffffffc0201c24 <default_alloc_pages+0x94>
ffffffffc0201b92:	00090597          	auipc	a1,0x90
ffffffffc0201b96:	c265a583          	lw	a1,-986(a1) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201b9a:	86aa                	mv	a3,a0
ffffffffc0201b9c:	02059793          	slli	a5,a1,0x20
ffffffffc0201ba0:	9381                	srli	a5,a5,0x20
ffffffffc0201ba2:	00a7ef63          	bltu	a5,a0,ffffffffc0201bc0 <default_alloc_pages+0x30>
ffffffffc0201ba6:	00090617          	auipc	a2,0x90
ffffffffc0201baa:	c0260613          	addi	a2,a2,-1022 # ffffffffc02917a8 <free_area>
ffffffffc0201bae:	87b2                	mv	a5,a2
ffffffffc0201bb0:	a029                	j	ffffffffc0201bba <default_alloc_pages+0x2a>
ffffffffc0201bb2:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201bb6:	00d77763          	bgeu	a4,a3,ffffffffc0201bc4 <default_alloc_pages+0x34>
ffffffffc0201bba:	679c                	ld	a5,8(a5)
ffffffffc0201bbc:	fec79be3          	bne	a5,a2,ffffffffc0201bb2 <default_alloc_pages+0x22>
ffffffffc0201bc0:	4501                	li	a0,0
ffffffffc0201bc2:	8082                	ret
ffffffffc0201bc4:	ff87a883          	lw	a7,-8(a5)
ffffffffc0201bc8:	0007b803          	ld	a6,0(a5)
ffffffffc0201bcc:	6798                	ld	a4,8(a5)
ffffffffc0201bce:	02089313          	slli	t1,a7,0x20
ffffffffc0201bd2:	02035313          	srli	t1,t1,0x20
ffffffffc0201bd6:	00e83423          	sd	a4,8(a6)
ffffffffc0201bda:	01073023          	sd	a6,0(a4)
ffffffffc0201bde:	fe878513          	addi	a0,a5,-24
ffffffffc0201be2:	0266fa63          	bgeu	a3,t1,ffffffffc0201c16 <default_alloc_pages+0x86>
ffffffffc0201be6:	00669713          	slli	a4,a3,0x6
ffffffffc0201bea:	40d888bb          	subw	a7,a7,a3
ffffffffc0201bee:	972a                	add	a4,a4,a0
ffffffffc0201bf0:	01172823          	sw	a7,16(a4)
ffffffffc0201bf4:	00870313          	addi	t1,a4,8
ffffffffc0201bf8:	4889                	li	a7,2
ffffffffc0201bfa:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc0201bfe:	00883883          	ld	a7,8(a6)
ffffffffc0201c02:	01870313          	addi	t1,a4,24
ffffffffc0201c06:	0068b023          	sd	t1,0(a7) # 10000000 <_binary_bin_sfs_img_size+0xff8ad00>
ffffffffc0201c0a:	00683423          	sd	t1,8(a6)
ffffffffc0201c0e:	03173023          	sd	a7,32(a4)
ffffffffc0201c12:	01073c23          	sd	a6,24(a4)
ffffffffc0201c16:	9d95                	subw	a1,a1,a3
ffffffffc0201c18:	ca0c                	sw	a1,16(a2)
ffffffffc0201c1a:	5775                	li	a4,-3
ffffffffc0201c1c:	17c1                	addi	a5,a5,-16
ffffffffc0201c1e:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c22:	8082                	ret
ffffffffc0201c24:	1141                	addi	sp,sp,-16
ffffffffc0201c26:	0000b697          	auipc	a3,0xb
ffffffffc0201c2a:	9fa68693          	addi	a3,a3,-1542 # ffffffffc020c620 <etext+0xe5c>
ffffffffc0201c2e:	0000a617          	auipc	a2,0xa
ffffffffc0201c32:	fd260613          	addi	a2,a2,-46 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201c36:	06100593          	li	a1,97
ffffffffc0201c3a:	0000a517          	auipc	a0,0xa
ffffffffc0201c3e:	6a650513          	addi	a0,a0,1702 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201c42:	e406                	sd	ra,8(sp)
ffffffffc0201c44:	807fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201c48 <default_init_memmap>:
ffffffffc0201c48:	1141                	addi	sp,sp,-16
ffffffffc0201c4a:	e406                	sd	ra,8(sp)
ffffffffc0201c4c:	c9e1                	beqz	a1,ffffffffc0201d1c <default_init_memmap+0xd4>
ffffffffc0201c4e:	00659713          	slli	a4,a1,0x6
ffffffffc0201c52:	00e506b3          	add	a3,a0,a4
ffffffffc0201c56:	87aa                	mv	a5,a0
ffffffffc0201c58:	cf11                	beqz	a4,ffffffffc0201c74 <default_init_memmap+0x2c>
ffffffffc0201c5a:	6798                	ld	a4,8(a5)
ffffffffc0201c5c:	8b05                	andi	a4,a4,1
ffffffffc0201c5e:	cf59                	beqz	a4,ffffffffc0201cfc <default_init_memmap+0xb4>
ffffffffc0201c60:	0007a823          	sw	zero,16(a5)
ffffffffc0201c64:	0007b423          	sd	zero,8(a5)
ffffffffc0201c68:	0007a023          	sw	zero,0(a5)
ffffffffc0201c6c:	04078793          	addi	a5,a5,64
ffffffffc0201c70:	fed795e3          	bne	a5,a3,ffffffffc0201c5a <default_init_memmap+0x12>
ffffffffc0201c74:	c90c                	sw	a1,16(a0)
ffffffffc0201c76:	4789                	li	a5,2
ffffffffc0201c78:	00850713          	addi	a4,a0,8
ffffffffc0201c7c:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201c80:	00090717          	auipc	a4,0x90
ffffffffc0201c84:	b3872703          	lw	a4,-1224(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201c88:	00090697          	auipc	a3,0x90
ffffffffc0201c8c:	b2068693          	addi	a3,a3,-1248 # ffffffffc02917a8 <free_area>
ffffffffc0201c90:	669c                	ld	a5,8(a3)
ffffffffc0201c92:	9f2d                	addw	a4,a4,a1
ffffffffc0201c94:	ca98                	sw	a4,16(a3)
ffffffffc0201c96:	04d78663          	beq	a5,a3,ffffffffc0201ce2 <default_init_memmap+0x9a>
ffffffffc0201c9a:	fe878713          	addi	a4,a5,-24
ffffffffc0201c9e:	4581                	li	a1,0
ffffffffc0201ca0:	01850613          	addi	a2,a0,24
ffffffffc0201ca4:	00e56a63          	bltu	a0,a4,ffffffffc0201cb8 <default_init_memmap+0x70>
ffffffffc0201ca8:	6798                	ld	a4,8(a5)
ffffffffc0201caa:	02d70263          	beq	a4,a3,ffffffffc0201cce <default_init_memmap+0x86>
ffffffffc0201cae:	87ba                	mv	a5,a4
ffffffffc0201cb0:	fe878713          	addi	a4,a5,-24
ffffffffc0201cb4:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ca8 <default_init_memmap+0x60>
ffffffffc0201cb8:	c199                	beqz	a1,ffffffffc0201cbe <default_init_memmap+0x76>
ffffffffc0201cba:	0106b023          	sd	a6,0(a3)
ffffffffc0201cbe:	6398                	ld	a4,0(a5)
ffffffffc0201cc0:	60a2                	ld	ra,8(sp)
ffffffffc0201cc2:	e390                	sd	a2,0(a5)
ffffffffc0201cc4:	e710                	sd	a2,8(a4)
ffffffffc0201cc6:	ed18                	sd	a4,24(a0)
ffffffffc0201cc8:	f11c                	sd	a5,32(a0)
ffffffffc0201cca:	0141                	addi	sp,sp,16
ffffffffc0201ccc:	8082                	ret
ffffffffc0201cce:	e790                	sd	a2,8(a5)
ffffffffc0201cd0:	f114                	sd	a3,32(a0)
ffffffffc0201cd2:	6798                	ld	a4,8(a5)
ffffffffc0201cd4:	ed1c                	sd	a5,24(a0)
ffffffffc0201cd6:	8832                	mv	a6,a2
ffffffffc0201cd8:	00d70e63          	beq	a4,a3,ffffffffc0201cf4 <default_init_memmap+0xac>
ffffffffc0201cdc:	4585                	li	a1,1
ffffffffc0201cde:	87ba                	mv	a5,a4
ffffffffc0201ce0:	bfc1                	j	ffffffffc0201cb0 <default_init_memmap+0x68>
ffffffffc0201ce2:	60a2                	ld	ra,8(sp)
ffffffffc0201ce4:	01850713          	addi	a4,a0,24
ffffffffc0201ce8:	f11c                	sd	a5,32(a0)
ffffffffc0201cea:	ed1c                	sd	a5,24(a0)
ffffffffc0201cec:	e398                	sd	a4,0(a5)
ffffffffc0201cee:	e798                	sd	a4,8(a5)
ffffffffc0201cf0:	0141                	addi	sp,sp,16
ffffffffc0201cf2:	8082                	ret
ffffffffc0201cf4:	60a2                	ld	ra,8(sp)
ffffffffc0201cf6:	e290                	sd	a2,0(a3)
ffffffffc0201cf8:	0141                	addi	sp,sp,16
ffffffffc0201cfa:	8082                	ret
ffffffffc0201cfc:	0000b697          	auipc	a3,0xb
ffffffffc0201d00:	95468693          	addi	a3,a3,-1708 # ffffffffc020c650 <etext+0xe8c>
ffffffffc0201d04:	0000a617          	auipc	a2,0xa
ffffffffc0201d08:	efc60613          	addi	a2,a2,-260 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201d0c:	04800593          	li	a1,72
ffffffffc0201d10:	0000a517          	auipc	a0,0xa
ffffffffc0201d14:	5d050513          	addi	a0,a0,1488 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201d18:	f32fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201d1c:	0000b697          	auipc	a3,0xb
ffffffffc0201d20:	90468693          	addi	a3,a3,-1788 # ffffffffc020c620 <etext+0xe5c>
ffffffffc0201d24:	0000a617          	auipc	a2,0xa
ffffffffc0201d28:	edc60613          	addi	a2,a2,-292 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201d2c:	04500593          	li	a1,69
ffffffffc0201d30:	0000a517          	auipc	a0,0xa
ffffffffc0201d34:	5b050513          	addi	a0,a0,1456 # ffffffffc020c2e0 <etext+0xb1c>
ffffffffc0201d38:	f12fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d3c <slob_free>:
ffffffffc0201d3c:	c531                	beqz	a0,ffffffffc0201d88 <slob_free+0x4c>
ffffffffc0201d3e:	e9b9                	bnez	a1,ffffffffc0201d94 <slob_free+0x58>
ffffffffc0201d40:	100027f3          	csrr	a5,sstatus
ffffffffc0201d44:	8b89                	andi	a5,a5,2
ffffffffc0201d46:	4581                	li	a1,0
ffffffffc0201d48:	efb1                	bnez	a5,ffffffffc0201da4 <slob_free+0x68>
ffffffffc0201d4a:	0008f797          	auipc	a5,0x8f
ffffffffc0201d4e:	3067b783          	ld	a5,774(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201d52:	873e                	mv	a4,a5
ffffffffc0201d54:	679c                	ld	a5,8(a5)
ffffffffc0201d56:	02a77a63          	bgeu	a4,a0,ffffffffc0201d8a <slob_free+0x4e>
ffffffffc0201d5a:	00f56463          	bltu	a0,a5,ffffffffc0201d62 <slob_free+0x26>
ffffffffc0201d5e:	fef76ae3          	bltu	a4,a5,ffffffffc0201d52 <slob_free+0x16>
ffffffffc0201d62:	4110                	lw	a2,0(a0)
ffffffffc0201d64:	00461693          	slli	a3,a2,0x4
ffffffffc0201d68:	96aa                	add	a3,a3,a0
ffffffffc0201d6a:	0ad78463          	beq	a5,a3,ffffffffc0201e12 <slob_free+0xd6>
ffffffffc0201d6e:	4310                	lw	a2,0(a4)
ffffffffc0201d70:	e51c                	sd	a5,8(a0)
ffffffffc0201d72:	00461693          	slli	a3,a2,0x4
ffffffffc0201d76:	96ba                	add	a3,a3,a4
ffffffffc0201d78:	08d50163          	beq	a0,a3,ffffffffc0201dfa <slob_free+0xbe>
ffffffffc0201d7c:	e708                	sd	a0,8(a4)
ffffffffc0201d7e:	0008f797          	auipc	a5,0x8f
ffffffffc0201d82:	2ce7b923          	sd	a4,722(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201d86:	e9a5                	bnez	a1,ffffffffc0201df6 <slob_free+0xba>
ffffffffc0201d88:	8082                	ret
ffffffffc0201d8a:	fcf574e3          	bgeu	a0,a5,ffffffffc0201d52 <slob_free+0x16>
ffffffffc0201d8e:	fcf762e3          	bltu	a4,a5,ffffffffc0201d52 <slob_free+0x16>
ffffffffc0201d92:	bfc1                	j	ffffffffc0201d62 <slob_free+0x26>
ffffffffc0201d94:	25bd                	addiw	a1,a1,15
ffffffffc0201d96:	8191                	srli	a1,a1,0x4
ffffffffc0201d98:	c10c                	sw	a1,0(a0)
ffffffffc0201d9a:	100027f3          	csrr	a5,sstatus
ffffffffc0201d9e:	8b89                	andi	a5,a5,2
ffffffffc0201da0:	4581                	li	a1,0
ffffffffc0201da2:	d7c5                	beqz	a5,ffffffffc0201d4a <slob_free+0xe>
ffffffffc0201da4:	1101                	addi	sp,sp,-32
ffffffffc0201da6:	e42a                	sd	a0,8(sp)
ffffffffc0201da8:	ec06                	sd	ra,24(sp)
ffffffffc0201daa:	e2ffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201dae:	6522                	ld	a0,8(sp)
ffffffffc0201db0:	0008f797          	auipc	a5,0x8f
ffffffffc0201db4:	2a07b783          	ld	a5,672(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201db8:	4585                	li	a1,1
ffffffffc0201dba:	873e                	mv	a4,a5
ffffffffc0201dbc:	679c                	ld	a5,8(a5)
ffffffffc0201dbe:	06a77663          	bgeu	a4,a0,ffffffffc0201e2a <slob_free+0xee>
ffffffffc0201dc2:	00f56463          	bltu	a0,a5,ffffffffc0201dca <slob_free+0x8e>
ffffffffc0201dc6:	fef76ae3          	bltu	a4,a5,ffffffffc0201dba <slob_free+0x7e>
ffffffffc0201dca:	4110                	lw	a2,0(a0)
ffffffffc0201dcc:	00461693          	slli	a3,a2,0x4
ffffffffc0201dd0:	96aa                	add	a3,a3,a0
ffffffffc0201dd2:	06d78363          	beq	a5,a3,ffffffffc0201e38 <slob_free+0xfc>
ffffffffc0201dd6:	4310                	lw	a2,0(a4)
ffffffffc0201dd8:	e51c                	sd	a5,8(a0)
ffffffffc0201dda:	00461693          	slli	a3,a2,0x4
ffffffffc0201dde:	96ba                	add	a3,a3,a4
ffffffffc0201de0:	06d50163          	beq	a0,a3,ffffffffc0201e42 <slob_free+0x106>
ffffffffc0201de4:	e708                	sd	a0,8(a4)
ffffffffc0201de6:	0008f797          	auipc	a5,0x8f
ffffffffc0201dea:	26e7b523          	sd	a4,618(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201dee:	e1a9                	bnez	a1,ffffffffc0201e30 <slob_free+0xf4>
ffffffffc0201df0:	60e2                	ld	ra,24(sp)
ffffffffc0201df2:	6105                	addi	sp,sp,32
ffffffffc0201df4:	8082                	ret
ffffffffc0201df6:	dddfe06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0201dfa:	4114                	lw	a3,0(a0)
ffffffffc0201dfc:	853e                	mv	a0,a5
ffffffffc0201dfe:	e708                	sd	a0,8(a4)
ffffffffc0201e00:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e04:	c31c                	sw	a5,0(a4)
ffffffffc0201e06:	0008f797          	auipc	a5,0x8f
ffffffffc0201e0a:	24e7b523          	sd	a4,586(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e0e:	ddad                	beqz	a1,ffffffffc0201d88 <slob_free+0x4c>
ffffffffc0201e10:	b7dd                	j	ffffffffc0201df6 <slob_free+0xba>
ffffffffc0201e12:	4394                	lw	a3,0(a5)
ffffffffc0201e14:	679c                	ld	a5,8(a5)
ffffffffc0201e16:	9eb1                	addw	a3,a3,a2
ffffffffc0201e18:	c114                	sw	a3,0(a0)
ffffffffc0201e1a:	4310                	lw	a2,0(a4)
ffffffffc0201e1c:	e51c                	sd	a5,8(a0)
ffffffffc0201e1e:	00461693          	slli	a3,a2,0x4
ffffffffc0201e22:	96ba                	add	a3,a3,a4
ffffffffc0201e24:	f4d51ce3          	bne	a0,a3,ffffffffc0201d7c <slob_free+0x40>
ffffffffc0201e28:	bfc9                	j	ffffffffc0201dfa <slob_free+0xbe>
ffffffffc0201e2a:	f8f56ee3          	bltu	a0,a5,ffffffffc0201dc6 <slob_free+0x8a>
ffffffffc0201e2e:	b771                	j	ffffffffc0201dba <slob_free+0x7e>
ffffffffc0201e30:	60e2                	ld	ra,24(sp)
ffffffffc0201e32:	6105                	addi	sp,sp,32
ffffffffc0201e34:	d9ffe06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0201e38:	4394                	lw	a3,0(a5)
ffffffffc0201e3a:	679c                	ld	a5,8(a5)
ffffffffc0201e3c:	9eb1                	addw	a3,a3,a2
ffffffffc0201e3e:	c114                	sw	a3,0(a0)
ffffffffc0201e40:	bf59                	j	ffffffffc0201dd6 <slob_free+0x9a>
ffffffffc0201e42:	4114                	lw	a3,0(a0)
ffffffffc0201e44:	853e                	mv	a0,a5
ffffffffc0201e46:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e4a:	c31c                	sw	a5,0(a4)
ffffffffc0201e4c:	bf61                	j	ffffffffc0201de4 <slob_free+0xa8>

ffffffffc0201e4e <__slob_get_free_pages.constprop.0>:
ffffffffc0201e4e:	4785                	li	a5,1
ffffffffc0201e50:	1141                	addi	sp,sp,-16
ffffffffc0201e52:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e56:	e406                	sd	ra,8(sp)
ffffffffc0201e58:	32c000ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0201e5c:	c91d                	beqz	a0,ffffffffc0201e92 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e5e:	00095697          	auipc	a3,0x95
ffffffffc0201e62:	a5a6b683          	ld	a3,-1446(a3) # ffffffffc02968b8 <pages>
ffffffffc0201e66:	0000e797          	auipc	a5,0xe
ffffffffc0201e6a:	c5a7b783          	ld	a5,-934(a5) # ffffffffc020fac0 <nbase>
ffffffffc0201e6e:	00095717          	auipc	a4,0x95
ffffffffc0201e72:	a4273703          	ld	a4,-1470(a4) # ffffffffc02968b0 <npage>
ffffffffc0201e76:	8d15                	sub	a0,a0,a3
ffffffffc0201e78:	8519                	srai	a0,a0,0x6
ffffffffc0201e7a:	953e                	add	a0,a0,a5
ffffffffc0201e7c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e80:	83b1                	srli	a5,a5,0xc
ffffffffc0201e82:	0532                	slli	a0,a0,0xc
ffffffffc0201e84:	00e7fa63          	bgeu	a5,a4,ffffffffc0201e98 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e88:	00095797          	auipc	a5,0x95
ffffffffc0201e8c:	a207b783          	ld	a5,-1504(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0201e90:	953e                	add	a0,a0,a5
ffffffffc0201e92:	60a2                	ld	ra,8(sp)
ffffffffc0201e94:	0141                	addi	sp,sp,16
ffffffffc0201e96:	8082                	ret
ffffffffc0201e98:	86aa                	mv	a3,a0
ffffffffc0201e9a:	0000a617          	auipc	a2,0xa
ffffffffc0201e9e:	7de60613          	addi	a2,a2,2014 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0201ea2:	07100593          	li	a1,113
ffffffffc0201ea6:	0000a517          	auipc	a0,0xa
ffffffffc0201eaa:	7fa50513          	addi	a0,a0,2042 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0201eae:	d9cfe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201eb2 <slob_alloc.constprop.0>:
ffffffffc0201eb2:	7179                	addi	sp,sp,-48
ffffffffc0201eb4:	f406                	sd	ra,40(sp)
ffffffffc0201eb6:	f022                	sd	s0,32(sp)
ffffffffc0201eb8:	ec26                	sd	s1,24(sp)
ffffffffc0201eba:	01050713          	addi	a4,a0,16
ffffffffc0201ebe:	6785                	lui	a5,0x1
ffffffffc0201ec0:	0af77e63          	bgeu	a4,a5,ffffffffc0201f7c <slob_alloc.constprop.0+0xca>
ffffffffc0201ec4:	00f50413          	addi	s0,a0,15
ffffffffc0201ec8:	8011                	srli	s0,s0,0x4
ffffffffc0201eca:	2401                	sext.w	s0,s0
ffffffffc0201ecc:	100025f3          	csrr	a1,sstatus
ffffffffc0201ed0:	8989                	andi	a1,a1,2
ffffffffc0201ed2:	edd1                	bnez	a1,ffffffffc0201f6e <slob_alloc.constprop.0+0xbc>
ffffffffc0201ed4:	0008f497          	auipc	s1,0x8f
ffffffffc0201ed8:	17c48493          	addi	s1,s1,380 # ffffffffc0291050 <slobfree>
ffffffffc0201edc:	6090                	ld	a2,0(s1)
ffffffffc0201ede:	6618                	ld	a4,8(a2)
ffffffffc0201ee0:	4314                	lw	a3,0(a4)
ffffffffc0201ee2:	0886da63          	bge	a3,s0,ffffffffc0201f76 <slob_alloc.constprop.0+0xc4>
ffffffffc0201ee6:	00e60a63          	beq	a2,a4,ffffffffc0201efa <slob_alloc.constprop.0+0x48>
ffffffffc0201eea:	671c                	ld	a5,8(a4)
ffffffffc0201eec:	4394                	lw	a3,0(a5)
ffffffffc0201eee:	0286d863          	bge	a3,s0,ffffffffc0201f1e <slob_alloc.constprop.0+0x6c>
ffffffffc0201ef2:	6090                	ld	a2,0(s1)
ffffffffc0201ef4:	873e                	mv	a4,a5
ffffffffc0201ef6:	fee61ae3          	bne	a2,a4,ffffffffc0201eea <slob_alloc.constprop.0+0x38>
ffffffffc0201efa:	e9b1                	bnez	a1,ffffffffc0201f4e <slob_alloc.constprop.0+0x9c>
ffffffffc0201efc:	4501                	li	a0,0
ffffffffc0201efe:	f51ff0ef          	jal	ffffffffc0201e4e <__slob_get_free_pages.constprop.0>
ffffffffc0201f02:	87aa                	mv	a5,a0
ffffffffc0201f04:	c915                	beqz	a0,ffffffffc0201f38 <slob_alloc.constprop.0+0x86>
ffffffffc0201f06:	6585                	lui	a1,0x1
ffffffffc0201f08:	e35ff0ef          	jal	ffffffffc0201d3c <slob_free>
ffffffffc0201f0c:	100025f3          	csrr	a1,sstatus
ffffffffc0201f10:	8989                	andi	a1,a1,2
ffffffffc0201f12:	e98d                	bnez	a1,ffffffffc0201f44 <slob_alloc.constprop.0+0x92>
ffffffffc0201f14:	6098                	ld	a4,0(s1)
ffffffffc0201f16:	671c                	ld	a5,8(a4)
ffffffffc0201f18:	4394                	lw	a3,0(a5)
ffffffffc0201f1a:	fc86cce3          	blt	a3,s0,ffffffffc0201ef2 <slob_alloc.constprop.0+0x40>
ffffffffc0201f1e:	04d40563          	beq	s0,a3,ffffffffc0201f68 <slob_alloc.constprop.0+0xb6>
ffffffffc0201f22:	00441613          	slli	a2,s0,0x4
ffffffffc0201f26:	963e                	add	a2,a2,a5
ffffffffc0201f28:	e710                	sd	a2,8(a4)
ffffffffc0201f2a:	6788                	ld	a0,8(a5)
ffffffffc0201f2c:	9e81                	subw	a3,a3,s0
ffffffffc0201f2e:	c214                	sw	a3,0(a2)
ffffffffc0201f30:	e608                	sd	a0,8(a2)
ffffffffc0201f32:	c380                	sw	s0,0(a5)
ffffffffc0201f34:	e098                	sd	a4,0(s1)
ffffffffc0201f36:	ed99                	bnez	a1,ffffffffc0201f54 <slob_alloc.constprop.0+0xa2>
ffffffffc0201f38:	70a2                	ld	ra,40(sp)
ffffffffc0201f3a:	7402                	ld	s0,32(sp)
ffffffffc0201f3c:	64e2                	ld	s1,24(sp)
ffffffffc0201f3e:	853e                	mv	a0,a5
ffffffffc0201f40:	6145                	addi	sp,sp,48
ffffffffc0201f42:	8082                	ret
ffffffffc0201f44:	c95fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201f48:	6098                	ld	a4,0(s1)
ffffffffc0201f4a:	4585                	li	a1,1
ffffffffc0201f4c:	b7e9                	j	ffffffffc0201f16 <slob_alloc.constprop.0+0x64>
ffffffffc0201f4e:	c85fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0201f52:	b76d                	j	ffffffffc0201efc <slob_alloc.constprop.0+0x4a>
ffffffffc0201f54:	e43e                	sd	a5,8(sp)
ffffffffc0201f56:	c7dfe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0201f5a:	67a2                	ld	a5,8(sp)
ffffffffc0201f5c:	70a2                	ld	ra,40(sp)
ffffffffc0201f5e:	7402                	ld	s0,32(sp)
ffffffffc0201f60:	64e2                	ld	s1,24(sp)
ffffffffc0201f62:	853e                	mv	a0,a5
ffffffffc0201f64:	6145                	addi	sp,sp,48
ffffffffc0201f66:	8082                	ret
ffffffffc0201f68:	6794                	ld	a3,8(a5)
ffffffffc0201f6a:	e714                	sd	a3,8(a4)
ffffffffc0201f6c:	b7e1                	j	ffffffffc0201f34 <slob_alloc.constprop.0+0x82>
ffffffffc0201f6e:	c6bfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201f72:	4585                	li	a1,1
ffffffffc0201f74:	b785                	j	ffffffffc0201ed4 <slob_alloc.constprop.0+0x22>
ffffffffc0201f76:	87ba                	mv	a5,a4
ffffffffc0201f78:	8732                	mv	a4,a2
ffffffffc0201f7a:	b755                	j	ffffffffc0201f1e <slob_alloc.constprop.0+0x6c>
ffffffffc0201f7c:	0000a697          	auipc	a3,0xa
ffffffffc0201f80:	73468693          	addi	a3,a3,1844 # ffffffffc020c6b0 <etext+0xeec>
ffffffffc0201f84:	0000a617          	auipc	a2,0xa
ffffffffc0201f88:	c7c60613          	addi	a2,a2,-900 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0201f8c:	06300593          	li	a1,99
ffffffffc0201f90:	0000a517          	auipc	a0,0xa
ffffffffc0201f94:	74050513          	addi	a0,a0,1856 # ffffffffc020c6d0 <etext+0xf0c>
ffffffffc0201f98:	cb2fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201f9c <kmalloc_init>:
ffffffffc0201f9c:	1141                	addi	sp,sp,-16
ffffffffc0201f9e:	0000a517          	auipc	a0,0xa
ffffffffc0201fa2:	74a50513          	addi	a0,a0,1866 # ffffffffc020c6e8 <etext+0xf24>
ffffffffc0201fa6:	e406                	sd	ra,8(sp)
ffffffffc0201fa8:	9fefe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201fac:	60a2                	ld	ra,8(sp)
ffffffffc0201fae:	0000a517          	auipc	a0,0xa
ffffffffc0201fb2:	75250513          	addi	a0,a0,1874 # ffffffffc020c700 <etext+0xf3c>
ffffffffc0201fb6:	0141                	addi	sp,sp,16
ffffffffc0201fb8:	9eefe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201fbc <kallocated>:
ffffffffc0201fbc:	4501                	li	a0,0
ffffffffc0201fbe:	8082                	ret

ffffffffc0201fc0 <kmalloc>:
ffffffffc0201fc0:	1101                	addi	sp,sp,-32
ffffffffc0201fc2:	6685                	lui	a3,0x1
ffffffffc0201fc4:	ec06                	sd	ra,24(sp)
ffffffffc0201fc6:	16bd                	addi	a3,a3,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201fc8:	04a6f963          	bgeu	a3,a0,ffffffffc020201a <kmalloc+0x5a>
ffffffffc0201fcc:	e42a                	sd	a0,8(sp)
ffffffffc0201fce:	4561                	li	a0,24
ffffffffc0201fd0:	e822                	sd	s0,16(sp)
ffffffffc0201fd2:	ee1ff0ef          	jal	ffffffffc0201eb2 <slob_alloc.constprop.0>
ffffffffc0201fd6:	842a                	mv	s0,a0
ffffffffc0201fd8:	c541                	beqz	a0,ffffffffc0202060 <kmalloc+0xa0>
ffffffffc0201fda:	47a2                	lw	a5,8(sp)
ffffffffc0201fdc:	6705                	lui	a4,0x1
ffffffffc0201fde:	4501                	li	a0,0
ffffffffc0201fe0:	00f75763          	bge	a4,a5,ffffffffc0201fee <kmalloc+0x2e>
ffffffffc0201fe4:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0201fe8:	2505                	addiw	a0,a0,1
ffffffffc0201fea:	fef74de3          	blt	a4,a5,ffffffffc0201fe4 <kmalloc+0x24>
ffffffffc0201fee:	c008                	sw	a0,0(s0)
ffffffffc0201ff0:	e5fff0ef          	jal	ffffffffc0201e4e <__slob_get_free_pages.constprop.0>
ffffffffc0201ff4:	e408                	sd	a0,8(s0)
ffffffffc0201ff6:	cd31                	beqz	a0,ffffffffc0202052 <kmalloc+0x92>
ffffffffc0201ff8:	100027f3          	csrr	a5,sstatus
ffffffffc0201ffc:	8b89                	andi	a5,a5,2
ffffffffc0201ffe:	eb85                	bnez	a5,ffffffffc020202e <kmalloc+0x6e>
ffffffffc0202000:	00095797          	auipc	a5,0x95
ffffffffc0202004:	8887b783          	ld	a5,-1912(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202008:	00095717          	auipc	a4,0x95
ffffffffc020200c:	88873023          	sd	s0,-1920(a4) # ffffffffc0296888 <bigblocks>
ffffffffc0202010:	e81c                	sd	a5,16(s0)
ffffffffc0202012:	6442                	ld	s0,16(sp)
ffffffffc0202014:	60e2                	ld	ra,24(sp)
ffffffffc0202016:	6105                	addi	sp,sp,32
ffffffffc0202018:	8082                	ret
ffffffffc020201a:	0541                	addi	a0,a0,16
ffffffffc020201c:	e97ff0ef          	jal	ffffffffc0201eb2 <slob_alloc.constprop.0>
ffffffffc0202020:	87aa                	mv	a5,a0
ffffffffc0202022:	0541                	addi	a0,a0,16
ffffffffc0202024:	fbe5                	bnez	a5,ffffffffc0202014 <kmalloc+0x54>
ffffffffc0202026:	4501                	li	a0,0
ffffffffc0202028:	60e2                	ld	ra,24(sp)
ffffffffc020202a:	6105                	addi	sp,sp,32
ffffffffc020202c:	8082                	ret
ffffffffc020202e:	babfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202032:	00095797          	auipc	a5,0x95
ffffffffc0202036:	8567b783          	ld	a5,-1962(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020203a:	00095717          	auipc	a4,0x95
ffffffffc020203e:	84873723          	sd	s0,-1970(a4) # ffffffffc0296888 <bigblocks>
ffffffffc0202042:	e81c                	sd	a5,16(s0)
ffffffffc0202044:	b8ffe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202048:	6408                	ld	a0,8(s0)
ffffffffc020204a:	60e2                	ld	ra,24(sp)
ffffffffc020204c:	6442                	ld	s0,16(sp)
ffffffffc020204e:	6105                	addi	sp,sp,32
ffffffffc0202050:	8082                	ret
ffffffffc0202052:	8522                	mv	a0,s0
ffffffffc0202054:	45e1                	li	a1,24
ffffffffc0202056:	ce7ff0ef          	jal	ffffffffc0201d3c <slob_free>
ffffffffc020205a:	4501                	li	a0,0
ffffffffc020205c:	6442                	ld	s0,16(sp)
ffffffffc020205e:	b7e9                	j	ffffffffc0202028 <kmalloc+0x68>
ffffffffc0202060:	6442                	ld	s0,16(sp)
ffffffffc0202062:	4501                	li	a0,0
ffffffffc0202064:	b7d1                	j	ffffffffc0202028 <kmalloc+0x68>

ffffffffc0202066 <kfree>:
ffffffffc0202066:	c579                	beqz	a0,ffffffffc0202134 <kfree+0xce>
ffffffffc0202068:	03451793          	slli	a5,a0,0x34
ffffffffc020206c:	e3e1                	bnez	a5,ffffffffc020212c <kfree+0xc6>
ffffffffc020206e:	1101                	addi	sp,sp,-32
ffffffffc0202070:	ec06                	sd	ra,24(sp)
ffffffffc0202072:	100027f3          	csrr	a5,sstatus
ffffffffc0202076:	8b89                	andi	a5,a5,2
ffffffffc0202078:	e7c1                	bnez	a5,ffffffffc0202100 <kfree+0x9a>
ffffffffc020207a:	00095797          	auipc	a5,0x95
ffffffffc020207e:	80e7b783          	ld	a5,-2034(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202082:	4581                	li	a1,0
ffffffffc0202084:	cbad                	beqz	a5,ffffffffc02020f6 <kfree+0x90>
ffffffffc0202086:	00095617          	auipc	a2,0x95
ffffffffc020208a:	80260613          	addi	a2,a2,-2046 # ffffffffc0296888 <bigblocks>
ffffffffc020208e:	a021                	j	ffffffffc0202096 <kfree+0x30>
ffffffffc0202090:	01070613          	addi	a2,a4,16
ffffffffc0202094:	c3a5                	beqz	a5,ffffffffc02020f4 <kfree+0x8e>
ffffffffc0202096:	6794                	ld	a3,8(a5)
ffffffffc0202098:	873e                	mv	a4,a5
ffffffffc020209a:	6b9c                	ld	a5,16(a5)
ffffffffc020209c:	fea69ae3          	bne	a3,a0,ffffffffc0202090 <kfree+0x2a>
ffffffffc02020a0:	e21c                	sd	a5,0(a2)
ffffffffc02020a2:	edb5                	bnez	a1,ffffffffc020211e <kfree+0xb8>
ffffffffc02020a4:	c02007b7          	lui	a5,0xc0200
ffffffffc02020a8:	0af56363          	bltu	a0,a5,ffffffffc020214e <kfree+0xe8>
ffffffffc02020ac:	00094797          	auipc	a5,0x94
ffffffffc02020b0:	7fc7b783          	ld	a5,2044(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02020b4:	00094697          	auipc	a3,0x94
ffffffffc02020b8:	7fc6b683          	ld	a3,2044(a3) # ffffffffc02968b0 <npage>
ffffffffc02020bc:	8d1d                	sub	a0,a0,a5
ffffffffc02020be:	00c55793          	srli	a5,a0,0xc
ffffffffc02020c2:	06d7fa63          	bgeu	a5,a3,ffffffffc0202136 <kfree+0xd0>
ffffffffc02020c6:	0000e617          	auipc	a2,0xe
ffffffffc02020ca:	9fa63603          	ld	a2,-1542(a2) # ffffffffc020fac0 <nbase>
ffffffffc02020ce:	00094517          	auipc	a0,0x94
ffffffffc02020d2:	7ea53503          	ld	a0,2026(a0) # ffffffffc02968b8 <pages>
ffffffffc02020d6:	4314                	lw	a3,0(a4)
ffffffffc02020d8:	8f91                	sub	a5,a5,a2
ffffffffc02020da:	079a                	slli	a5,a5,0x6
ffffffffc02020dc:	4585                	li	a1,1
ffffffffc02020de:	953e                	add	a0,a0,a5
ffffffffc02020e0:	00d595bb          	sllw	a1,a1,a3
ffffffffc02020e4:	e03a                	sd	a4,0(sp)
ffffffffc02020e6:	0d8000ef          	jal	ffffffffc02021be <free_pages>
ffffffffc02020ea:	6502                	ld	a0,0(sp)
ffffffffc02020ec:	60e2                	ld	ra,24(sp)
ffffffffc02020ee:	45e1                	li	a1,24
ffffffffc02020f0:	6105                	addi	sp,sp,32
ffffffffc02020f2:	b1a9                	j	ffffffffc0201d3c <slob_free>
ffffffffc02020f4:	e185                	bnez	a1,ffffffffc0202114 <kfree+0xae>
ffffffffc02020f6:	60e2                	ld	ra,24(sp)
ffffffffc02020f8:	1541                	addi	a0,a0,-16
ffffffffc02020fa:	4581                	li	a1,0
ffffffffc02020fc:	6105                	addi	sp,sp,32
ffffffffc02020fe:	b93d                	j	ffffffffc0201d3c <slob_free>
ffffffffc0202100:	e02a                	sd	a0,0(sp)
ffffffffc0202102:	ad7fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202106:	00094797          	auipc	a5,0x94
ffffffffc020210a:	7827b783          	ld	a5,1922(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020210e:	6502                	ld	a0,0(sp)
ffffffffc0202110:	4585                	li	a1,1
ffffffffc0202112:	fbb5                	bnez	a5,ffffffffc0202086 <kfree+0x20>
ffffffffc0202114:	e02a                	sd	a0,0(sp)
ffffffffc0202116:	abdfe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020211a:	6502                	ld	a0,0(sp)
ffffffffc020211c:	bfe9                	j	ffffffffc02020f6 <kfree+0x90>
ffffffffc020211e:	e42a                	sd	a0,8(sp)
ffffffffc0202120:	e03a                	sd	a4,0(sp)
ffffffffc0202122:	ab1fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202126:	6522                	ld	a0,8(sp)
ffffffffc0202128:	6702                	ld	a4,0(sp)
ffffffffc020212a:	bfad                	j	ffffffffc02020a4 <kfree+0x3e>
ffffffffc020212c:	1541                	addi	a0,a0,-16
ffffffffc020212e:	4581                	li	a1,0
ffffffffc0202130:	c0dff06f          	j	ffffffffc0201d3c <slob_free>
ffffffffc0202134:	8082                	ret
ffffffffc0202136:	0000a617          	auipc	a2,0xa
ffffffffc020213a:	61260613          	addi	a2,a2,1554 # ffffffffc020c748 <etext+0xf84>
ffffffffc020213e:	06900593          	li	a1,105
ffffffffc0202142:	0000a517          	auipc	a0,0xa
ffffffffc0202146:	55e50513          	addi	a0,a0,1374 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc020214a:	b00fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020214e:	86aa                	mv	a3,a0
ffffffffc0202150:	0000a617          	auipc	a2,0xa
ffffffffc0202154:	5d060613          	addi	a2,a2,1488 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0202158:	07700593          	li	a1,119
ffffffffc020215c:	0000a517          	auipc	a0,0xa
ffffffffc0202160:	54450513          	addi	a0,a0,1348 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0202164:	ae6fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202168 <pa2page.part.0>:
ffffffffc0202168:	1141                	addi	sp,sp,-16
ffffffffc020216a:	0000a617          	auipc	a2,0xa
ffffffffc020216e:	5de60613          	addi	a2,a2,1502 # ffffffffc020c748 <etext+0xf84>
ffffffffc0202172:	06900593          	li	a1,105
ffffffffc0202176:	0000a517          	auipc	a0,0xa
ffffffffc020217a:	52a50513          	addi	a0,a0,1322 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc020217e:	e406                	sd	ra,8(sp)
ffffffffc0202180:	acafe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202184 <alloc_pages>:
ffffffffc0202184:	100027f3          	csrr	a5,sstatus
ffffffffc0202188:	8b89                	andi	a5,a5,2
ffffffffc020218a:	e799                	bnez	a5,ffffffffc0202198 <alloc_pages+0x14>
ffffffffc020218c:	00094797          	auipc	a5,0x94
ffffffffc0202190:	7047b783          	ld	a5,1796(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202194:	6f9c                	ld	a5,24(a5)
ffffffffc0202196:	8782                	jr	a5
ffffffffc0202198:	1101                	addi	sp,sp,-32
ffffffffc020219a:	ec06                	sd	ra,24(sp)
ffffffffc020219c:	e42a                	sd	a0,8(sp)
ffffffffc020219e:	a3bfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02021a2:	00094797          	auipc	a5,0x94
ffffffffc02021a6:	6ee7b783          	ld	a5,1774(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021aa:	6522                	ld	a0,8(sp)
ffffffffc02021ac:	6f9c                	ld	a5,24(a5)
ffffffffc02021ae:	9782                	jalr	a5
ffffffffc02021b0:	e42a                	sd	a0,8(sp)
ffffffffc02021b2:	a21fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02021b6:	60e2                	ld	ra,24(sp)
ffffffffc02021b8:	6522                	ld	a0,8(sp)
ffffffffc02021ba:	6105                	addi	sp,sp,32
ffffffffc02021bc:	8082                	ret

ffffffffc02021be <free_pages>:
ffffffffc02021be:	100027f3          	csrr	a5,sstatus
ffffffffc02021c2:	8b89                	andi	a5,a5,2
ffffffffc02021c4:	e799                	bnez	a5,ffffffffc02021d2 <free_pages+0x14>
ffffffffc02021c6:	00094797          	auipc	a5,0x94
ffffffffc02021ca:	6ca7b783          	ld	a5,1738(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021ce:	739c                	ld	a5,32(a5)
ffffffffc02021d0:	8782                	jr	a5
ffffffffc02021d2:	1101                	addi	sp,sp,-32
ffffffffc02021d4:	ec06                	sd	ra,24(sp)
ffffffffc02021d6:	e42e                	sd	a1,8(sp)
ffffffffc02021d8:	e02a                	sd	a0,0(sp)
ffffffffc02021da:	9fffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02021de:	00094797          	auipc	a5,0x94
ffffffffc02021e2:	6b27b783          	ld	a5,1714(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021e6:	65a2                	ld	a1,8(sp)
ffffffffc02021e8:	6502                	ld	a0,0(sp)
ffffffffc02021ea:	739c                	ld	a5,32(a5)
ffffffffc02021ec:	9782                	jalr	a5
ffffffffc02021ee:	60e2                	ld	ra,24(sp)
ffffffffc02021f0:	6105                	addi	sp,sp,32
ffffffffc02021f2:	9e1fe06f          	j	ffffffffc0200bd2 <intr_enable>

ffffffffc02021f6 <nr_free_pages>:
ffffffffc02021f6:	100027f3          	csrr	a5,sstatus
ffffffffc02021fa:	8b89                	andi	a5,a5,2
ffffffffc02021fc:	e799                	bnez	a5,ffffffffc020220a <nr_free_pages+0x14>
ffffffffc02021fe:	00094797          	auipc	a5,0x94
ffffffffc0202202:	6927b783          	ld	a5,1682(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202206:	779c                	ld	a5,40(a5)
ffffffffc0202208:	8782                	jr	a5
ffffffffc020220a:	1101                	addi	sp,sp,-32
ffffffffc020220c:	ec06                	sd	ra,24(sp)
ffffffffc020220e:	9cbfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202212:	00094797          	auipc	a5,0x94
ffffffffc0202216:	67e7b783          	ld	a5,1662(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020221a:	779c                	ld	a5,40(a5)
ffffffffc020221c:	9782                	jalr	a5
ffffffffc020221e:	e42a                	sd	a0,8(sp)
ffffffffc0202220:	9b3fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202224:	60e2                	ld	ra,24(sp)
ffffffffc0202226:	6522                	ld	a0,8(sp)
ffffffffc0202228:	6105                	addi	sp,sp,32
ffffffffc020222a:	8082                	ret

ffffffffc020222c <get_pte>:
ffffffffc020222c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202230:	1ff7f793          	andi	a5,a5,511
ffffffffc0202234:	078e                	slli	a5,a5,0x3
ffffffffc0202236:	00f50733          	add	a4,a0,a5
ffffffffc020223a:	6314                	ld	a3,0(a4)
ffffffffc020223c:	7139                	addi	sp,sp,-64
ffffffffc020223e:	f822                	sd	s0,48(sp)
ffffffffc0202240:	f426                	sd	s1,40(sp)
ffffffffc0202242:	fc06                	sd	ra,56(sp)
ffffffffc0202244:	0016f793          	andi	a5,a3,1
ffffffffc0202248:	842e                	mv	s0,a1
ffffffffc020224a:	8832                	mv	a6,a2
ffffffffc020224c:	00094497          	auipc	s1,0x94
ffffffffc0202250:	66448493          	addi	s1,s1,1636 # ffffffffc02968b0 <npage>
ffffffffc0202254:	ebd1                	bnez	a5,ffffffffc02022e8 <get_pte+0xbc>
ffffffffc0202256:	16060d63          	beqz	a2,ffffffffc02023d0 <get_pte+0x1a4>
ffffffffc020225a:	100027f3          	csrr	a5,sstatus
ffffffffc020225e:	8b89                	andi	a5,a5,2
ffffffffc0202260:	16079e63          	bnez	a5,ffffffffc02023dc <get_pte+0x1b0>
ffffffffc0202264:	00094797          	auipc	a5,0x94
ffffffffc0202268:	62c7b783          	ld	a5,1580(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020226c:	4505                	li	a0,1
ffffffffc020226e:	e43a                	sd	a4,8(sp)
ffffffffc0202270:	6f9c                	ld	a5,24(a5)
ffffffffc0202272:	e832                	sd	a2,16(sp)
ffffffffc0202274:	9782                	jalr	a5
ffffffffc0202276:	6722                	ld	a4,8(sp)
ffffffffc0202278:	6842                	ld	a6,16(sp)
ffffffffc020227a:	87aa                	mv	a5,a0
ffffffffc020227c:	14078a63          	beqz	a5,ffffffffc02023d0 <get_pte+0x1a4>
ffffffffc0202280:	00094517          	auipc	a0,0x94
ffffffffc0202284:	63853503          	ld	a0,1592(a0) # ffffffffc02968b8 <pages>
ffffffffc0202288:	000808b7          	lui	a7,0x80
ffffffffc020228c:	00094497          	auipc	s1,0x94
ffffffffc0202290:	62448493          	addi	s1,s1,1572 # ffffffffc02968b0 <npage>
ffffffffc0202294:	40a78533          	sub	a0,a5,a0
ffffffffc0202298:	8519                	srai	a0,a0,0x6
ffffffffc020229a:	9546                	add	a0,a0,a7
ffffffffc020229c:	6090                	ld	a2,0(s1)
ffffffffc020229e:	00c51693          	slli	a3,a0,0xc
ffffffffc02022a2:	4585                	li	a1,1
ffffffffc02022a4:	82b1                	srli	a3,a3,0xc
ffffffffc02022a6:	c38c                	sw	a1,0(a5)
ffffffffc02022a8:	0532                	slli	a0,a0,0xc
ffffffffc02022aa:	1ac6f763          	bgeu	a3,a2,ffffffffc0202458 <get_pte+0x22c>
ffffffffc02022ae:	00094697          	auipc	a3,0x94
ffffffffc02022b2:	5fa6b683          	ld	a3,1530(a3) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02022b6:	6605                	lui	a2,0x1
ffffffffc02022b8:	4581                	li	a1,0
ffffffffc02022ba:	9536                	add	a0,a0,a3
ffffffffc02022bc:	ec42                	sd	a6,24(sp)
ffffffffc02022be:	e83e                	sd	a5,16(sp)
ffffffffc02022c0:	e43a                	sd	a4,8(sp)
ffffffffc02022c2:	49a090ef          	jal	ffffffffc020b75c <memset>
ffffffffc02022c6:	00094697          	auipc	a3,0x94
ffffffffc02022ca:	5f26b683          	ld	a3,1522(a3) # ffffffffc02968b8 <pages>
ffffffffc02022ce:	67c2                	ld	a5,16(sp)
ffffffffc02022d0:	000808b7          	lui	a7,0x80
ffffffffc02022d4:	6722                	ld	a4,8(sp)
ffffffffc02022d6:	40d786b3          	sub	a3,a5,a3
ffffffffc02022da:	8699                	srai	a3,a3,0x6
ffffffffc02022dc:	96c6                	add	a3,a3,a7
ffffffffc02022de:	06aa                	slli	a3,a3,0xa
ffffffffc02022e0:	6862                	ld	a6,24(sp)
ffffffffc02022e2:	0116e693          	ori	a3,a3,17
ffffffffc02022e6:	e314                	sd	a3,0(a4)
ffffffffc02022e8:	c006f693          	andi	a3,a3,-1024
ffffffffc02022ec:	6098                	ld	a4,0(s1)
ffffffffc02022ee:	068a                	slli	a3,a3,0x2
ffffffffc02022f0:	00c6d793          	srli	a5,a3,0xc
ffffffffc02022f4:	14e7f663          	bgeu	a5,a4,ffffffffc0202440 <get_pte+0x214>
ffffffffc02022f8:	00094897          	auipc	a7,0x94
ffffffffc02022fc:	5b088893          	addi	a7,a7,1456 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202300:	0008b603          	ld	a2,0(a7)
ffffffffc0202304:	01545793          	srli	a5,s0,0x15
ffffffffc0202308:	1ff7f793          	andi	a5,a5,511
ffffffffc020230c:	96b2                	add	a3,a3,a2
ffffffffc020230e:	078e                	slli	a5,a5,0x3
ffffffffc0202310:	97b6                	add	a5,a5,a3
ffffffffc0202312:	6394                	ld	a3,0(a5)
ffffffffc0202314:	0016f613          	andi	a2,a3,1
ffffffffc0202318:	e659                	bnez	a2,ffffffffc02023a6 <get_pte+0x17a>
ffffffffc020231a:	0a080b63          	beqz	a6,ffffffffc02023d0 <get_pte+0x1a4>
ffffffffc020231e:	10002773          	csrr	a4,sstatus
ffffffffc0202322:	8b09                	andi	a4,a4,2
ffffffffc0202324:	ef71                	bnez	a4,ffffffffc0202400 <get_pte+0x1d4>
ffffffffc0202326:	00094717          	auipc	a4,0x94
ffffffffc020232a:	56a73703          	ld	a4,1386(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020232e:	4505                	li	a0,1
ffffffffc0202330:	e43e                	sd	a5,8(sp)
ffffffffc0202332:	6f18                	ld	a4,24(a4)
ffffffffc0202334:	9702                	jalr	a4
ffffffffc0202336:	67a2                	ld	a5,8(sp)
ffffffffc0202338:	872a                	mv	a4,a0
ffffffffc020233a:	00094897          	auipc	a7,0x94
ffffffffc020233e:	56e88893          	addi	a7,a7,1390 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202342:	c759                	beqz	a4,ffffffffc02023d0 <get_pte+0x1a4>
ffffffffc0202344:	00094697          	auipc	a3,0x94
ffffffffc0202348:	5746b683          	ld	a3,1396(a3) # ffffffffc02968b8 <pages>
ffffffffc020234c:	00080837          	lui	a6,0x80
ffffffffc0202350:	608c                	ld	a1,0(s1)
ffffffffc0202352:	40d706b3          	sub	a3,a4,a3
ffffffffc0202356:	8699                	srai	a3,a3,0x6
ffffffffc0202358:	96c2                	add	a3,a3,a6
ffffffffc020235a:	00c69613          	slli	a2,a3,0xc
ffffffffc020235e:	4505                	li	a0,1
ffffffffc0202360:	8231                	srli	a2,a2,0xc
ffffffffc0202362:	c308                	sw	a0,0(a4)
ffffffffc0202364:	06b2                	slli	a3,a3,0xc
ffffffffc0202366:	10b67663          	bgeu	a2,a1,ffffffffc0202472 <get_pte+0x246>
ffffffffc020236a:	0008b503          	ld	a0,0(a7)
ffffffffc020236e:	6605                	lui	a2,0x1
ffffffffc0202370:	4581                	li	a1,0
ffffffffc0202372:	9536                	add	a0,a0,a3
ffffffffc0202374:	e83a                	sd	a4,16(sp)
ffffffffc0202376:	e43e                	sd	a5,8(sp)
ffffffffc0202378:	3e4090ef          	jal	ffffffffc020b75c <memset>
ffffffffc020237c:	00094697          	auipc	a3,0x94
ffffffffc0202380:	53c6b683          	ld	a3,1340(a3) # ffffffffc02968b8 <pages>
ffffffffc0202384:	6742                	ld	a4,16(sp)
ffffffffc0202386:	00080837          	lui	a6,0x80
ffffffffc020238a:	67a2                	ld	a5,8(sp)
ffffffffc020238c:	40d706b3          	sub	a3,a4,a3
ffffffffc0202390:	8699                	srai	a3,a3,0x6
ffffffffc0202392:	96c2                	add	a3,a3,a6
ffffffffc0202394:	06aa                	slli	a3,a3,0xa
ffffffffc0202396:	0116e693          	ori	a3,a3,17
ffffffffc020239a:	e394                	sd	a3,0(a5)
ffffffffc020239c:	6098                	ld	a4,0(s1)
ffffffffc020239e:	00094897          	auipc	a7,0x94
ffffffffc02023a2:	50a88893          	addi	a7,a7,1290 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02023a6:	c006f693          	andi	a3,a3,-1024
ffffffffc02023aa:	068a                	slli	a3,a3,0x2
ffffffffc02023ac:	00c6d793          	srli	a5,a3,0xc
ffffffffc02023b0:	06e7fc63          	bgeu	a5,a4,ffffffffc0202428 <get_pte+0x1fc>
ffffffffc02023b4:	0008b783          	ld	a5,0(a7)
ffffffffc02023b8:	8031                	srli	s0,s0,0xc
ffffffffc02023ba:	1ff47413          	andi	s0,s0,511
ffffffffc02023be:	040e                	slli	s0,s0,0x3
ffffffffc02023c0:	96be                	add	a3,a3,a5
ffffffffc02023c2:	70e2                	ld	ra,56(sp)
ffffffffc02023c4:	00868533          	add	a0,a3,s0
ffffffffc02023c8:	7442                	ld	s0,48(sp)
ffffffffc02023ca:	74a2                	ld	s1,40(sp)
ffffffffc02023cc:	6121                	addi	sp,sp,64
ffffffffc02023ce:	8082                	ret
ffffffffc02023d0:	70e2                	ld	ra,56(sp)
ffffffffc02023d2:	7442                	ld	s0,48(sp)
ffffffffc02023d4:	74a2                	ld	s1,40(sp)
ffffffffc02023d6:	4501                	li	a0,0
ffffffffc02023d8:	6121                	addi	sp,sp,64
ffffffffc02023da:	8082                	ret
ffffffffc02023dc:	e83a                	sd	a4,16(sp)
ffffffffc02023de:	ec32                	sd	a2,24(sp)
ffffffffc02023e0:	ff8fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02023e4:	00094797          	auipc	a5,0x94
ffffffffc02023e8:	4ac7b783          	ld	a5,1196(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02023ec:	4505                	li	a0,1
ffffffffc02023ee:	6f9c                	ld	a5,24(a5)
ffffffffc02023f0:	9782                	jalr	a5
ffffffffc02023f2:	e42a                	sd	a0,8(sp)
ffffffffc02023f4:	fdefe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02023f8:	6862                	ld	a6,24(sp)
ffffffffc02023fa:	6742                	ld	a4,16(sp)
ffffffffc02023fc:	67a2                	ld	a5,8(sp)
ffffffffc02023fe:	bdbd                	j	ffffffffc020227c <get_pte+0x50>
ffffffffc0202400:	e83e                	sd	a5,16(sp)
ffffffffc0202402:	fd6fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202406:	00094717          	auipc	a4,0x94
ffffffffc020240a:	48a73703          	ld	a4,1162(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020240e:	4505                	li	a0,1
ffffffffc0202410:	6f18                	ld	a4,24(a4)
ffffffffc0202412:	9702                	jalr	a4
ffffffffc0202414:	e42a                	sd	a0,8(sp)
ffffffffc0202416:	fbcfe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020241a:	6722                	ld	a4,8(sp)
ffffffffc020241c:	67c2                	ld	a5,16(sp)
ffffffffc020241e:	00094897          	auipc	a7,0x94
ffffffffc0202422:	48a88893          	addi	a7,a7,1162 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202426:	bf31                	j	ffffffffc0202342 <get_pte+0x116>
ffffffffc0202428:	0000a617          	auipc	a2,0xa
ffffffffc020242c:	25060613          	addi	a2,a2,592 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0202430:	13200593          	li	a1,306
ffffffffc0202434:	0000a517          	auipc	a0,0xa
ffffffffc0202438:	33450513          	addi	a0,a0,820 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020243c:	80efe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202440:	0000a617          	auipc	a2,0xa
ffffffffc0202444:	23860613          	addi	a2,a2,568 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0202448:	12500593          	li	a1,293
ffffffffc020244c:	0000a517          	auipc	a0,0xa
ffffffffc0202450:	31c50513          	addi	a0,a0,796 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0202454:	ff7fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202458:	86aa                	mv	a3,a0
ffffffffc020245a:	0000a617          	auipc	a2,0xa
ffffffffc020245e:	21e60613          	addi	a2,a2,542 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0202462:	12100593          	li	a1,289
ffffffffc0202466:	0000a517          	auipc	a0,0xa
ffffffffc020246a:	30250513          	addi	a0,a0,770 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020246e:	fddfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202472:	0000a617          	auipc	a2,0xa
ffffffffc0202476:	20660613          	addi	a2,a2,518 # ffffffffc020c678 <etext+0xeb4>
ffffffffc020247a:	12f00593          	li	a1,303
ffffffffc020247e:	0000a517          	auipc	a0,0xa
ffffffffc0202482:	2ea50513          	addi	a0,a0,746 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0202486:	fc5fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020248a <boot_map_segment>:
ffffffffc020248a:	7139                	addi	sp,sp,-64
ffffffffc020248c:	f04a                	sd	s2,32(sp)
ffffffffc020248e:	6905                	lui	s2,0x1
ffffffffc0202490:	00d5c833          	xor	a6,a1,a3
ffffffffc0202494:	fff90793          	addi	a5,s2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0202498:	fc06                	sd	ra,56(sp)
ffffffffc020249a:	00f87833          	and	a6,a6,a5
ffffffffc020249e:	08081563          	bnez	a6,ffffffffc0202528 <boot_map_segment+0x9e>
ffffffffc02024a2:	f426                	sd	s1,40(sp)
ffffffffc02024a4:	963e                	add	a2,a2,a5
ffffffffc02024a6:	00f5f4b3          	and	s1,a1,a5
ffffffffc02024aa:	94b2                	add	s1,s1,a2
ffffffffc02024ac:	80b1                	srli	s1,s1,0xc
ffffffffc02024ae:	c8a1                	beqz	s1,ffffffffc02024fe <boot_map_segment+0x74>
ffffffffc02024b0:	77fd                	lui	a5,0xfffff
ffffffffc02024b2:	00176713          	ori	a4,a4,1
ffffffffc02024b6:	f822                	sd	s0,48(sp)
ffffffffc02024b8:	e852                	sd	s4,16(sp)
ffffffffc02024ba:	8efd                	and	a3,a3,a5
ffffffffc02024bc:	02071a13          	slli	s4,a4,0x20
ffffffffc02024c0:	00f5f433          	and	s0,a1,a5
ffffffffc02024c4:	ec4e                	sd	s3,24(sp)
ffffffffc02024c6:	e456                	sd	s5,8(sp)
ffffffffc02024c8:	89aa                	mv	s3,a0
ffffffffc02024ca:	020a5a13          	srli	s4,s4,0x20
ffffffffc02024ce:	40868ab3          	sub	s5,a3,s0
ffffffffc02024d2:	4605                	li	a2,1
ffffffffc02024d4:	85a2                	mv	a1,s0
ffffffffc02024d6:	854e                	mv	a0,s3
ffffffffc02024d8:	d55ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc02024dc:	c515                	beqz	a0,ffffffffc0202508 <boot_map_segment+0x7e>
ffffffffc02024de:	008a87b3          	add	a5,s5,s0
ffffffffc02024e2:	83b1                	srli	a5,a5,0xc
ffffffffc02024e4:	07aa                	slli	a5,a5,0xa
ffffffffc02024e6:	0147e7b3          	or	a5,a5,s4
ffffffffc02024ea:	0017e793          	ori	a5,a5,1
ffffffffc02024ee:	14fd                	addi	s1,s1,-1
ffffffffc02024f0:	e11c                	sd	a5,0(a0)
ffffffffc02024f2:	944a                	add	s0,s0,s2
ffffffffc02024f4:	fcf9                	bnez	s1,ffffffffc02024d2 <boot_map_segment+0x48>
ffffffffc02024f6:	7442                	ld	s0,48(sp)
ffffffffc02024f8:	69e2                	ld	s3,24(sp)
ffffffffc02024fa:	6a42                	ld	s4,16(sp)
ffffffffc02024fc:	6aa2                	ld	s5,8(sp)
ffffffffc02024fe:	70e2                	ld	ra,56(sp)
ffffffffc0202500:	74a2                	ld	s1,40(sp)
ffffffffc0202502:	7902                	ld	s2,32(sp)
ffffffffc0202504:	6121                	addi	sp,sp,64
ffffffffc0202506:	8082                	ret
ffffffffc0202508:	0000a697          	auipc	a3,0xa
ffffffffc020250c:	28868693          	addi	a3,a3,648 # ffffffffc020c790 <etext+0xfcc>
ffffffffc0202510:	00009617          	auipc	a2,0x9
ffffffffc0202514:	6f060613          	addi	a2,a2,1776 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0202518:	09c00593          	li	a1,156
ffffffffc020251c:	0000a517          	auipc	a0,0xa
ffffffffc0202520:	24c50513          	addi	a0,a0,588 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0202524:	f27fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202528:	0000a697          	auipc	a3,0xa
ffffffffc020252c:	25068693          	addi	a3,a3,592 # ffffffffc020c778 <etext+0xfb4>
ffffffffc0202530:	00009617          	auipc	a2,0x9
ffffffffc0202534:	6d060613          	addi	a2,a2,1744 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0202538:	09500593          	li	a1,149
ffffffffc020253c:	0000a517          	auipc	a0,0xa
ffffffffc0202540:	22c50513          	addi	a0,a0,556 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0202544:	f822                	sd	s0,48(sp)
ffffffffc0202546:	f426                	sd	s1,40(sp)
ffffffffc0202548:	ec4e                	sd	s3,24(sp)
ffffffffc020254a:	e852                	sd	s4,16(sp)
ffffffffc020254c:	e456                	sd	s5,8(sp)
ffffffffc020254e:	efdfd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202552 <get_page>:
ffffffffc0202552:	1141                	addi	sp,sp,-16
ffffffffc0202554:	e022                	sd	s0,0(sp)
ffffffffc0202556:	8432                	mv	s0,a2
ffffffffc0202558:	4601                	li	a2,0
ffffffffc020255a:	e406                	sd	ra,8(sp)
ffffffffc020255c:	cd1ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202560:	c011                	beqz	s0,ffffffffc0202564 <get_page+0x12>
ffffffffc0202562:	e008                	sd	a0,0(s0)
ffffffffc0202564:	c511                	beqz	a0,ffffffffc0202570 <get_page+0x1e>
ffffffffc0202566:	611c                	ld	a5,0(a0)
ffffffffc0202568:	4501                	li	a0,0
ffffffffc020256a:	0017f713          	andi	a4,a5,1
ffffffffc020256e:	e709                	bnez	a4,ffffffffc0202578 <get_page+0x26>
ffffffffc0202570:	60a2                	ld	ra,8(sp)
ffffffffc0202572:	6402                	ld	s0,0(sp)
ffffffffc0202574:	0141                	addi	sp,sp,16
ffffffffc0202576:	8082                	ret
ffffffffc0202578:	00094717          	auipc	a4,0x94
ffffffffc020257c:	33873703          	ld	a4,824(a4) # ffffffffc02968b0 <npage>
ffffffffc0202580:	078a                	slli	a5,a5,0x2
ffffffffc0202582:	83b1                	srli	a5,a5,0xc
ffffffffc0202584:	00e7ff63          	bgeu	a5,a4,ffffffffc02025a2 <get_page+0x50>
ffffffffc0202588:	00094517          	auipc	a0,0x94
ffffffffc020258c:	33053503          	ld	a0,816(a0) # ffffffffc02968b8 <pages>
ffffffffc0202590:	60a2                	ld	ra,8(sp)
ffffffffc0202592:	6402                	ld	s0,0(sp)
ffffffffc0202594:	079a                	slli	a5,a5,0x6
ffffffffc0202596:	fe000737          	lui	a4,0xfe000
ffffffffc020259a:	97ba                	add	a5,a5,a4
ffffffffc020259c:	953e                	add	a0,a0,a5
ffffffffc020259e:	0141                	addi	sp,sp,16
ffffffffc02025a0:	8082                	ret
ffffffffc02025a2:	bc7ff0ef          	jal	ffffffffc0202168 <pa2page.part.0>

ffffffffc02025a6 <unmap_range>:
ffffffffc02025a6:	715d                	addi	sp,sp,-80
ffffffffc02025a8:	00c5e7b3          	or	a5,a1,a2
ffffffffc02025ac:	e486                	sd	ra,72(sp)
ffffffffc02025ae:	e0a2                	sd	s0,64(sp)
ffffffffc02025b0:	fc26                	sd	s1,56(sp)
ffffffffc02025b2:	f84a                	sd	s2,48(sp)
ffffffffc02025b4:	f44e                	sd	s3,40(sp)
ffffffffc02025b6:	f052                	sd	s4,32(sp)
ffffffffc02025b8:	ec56                	sd	s5,24(sp)
ffffffffc02025ba:	03479713          	slli	a4,a5,0x34
ffffffffc02025be:	ef61                	bnez	a4,ffffffffc0202696 <unmap_range+0xf0>
ffffffffc02025c0:	00200a37          	lui	s4,0x200
ffffffffc02025c4:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02025c8:	0145b733          	sltu	a4,a1,s4
ffffffffc02025cc:	0017b793          	seqz	a5,a5
ffffffffc02025d0:	8fd9                	or	a5,a5,a4
ffffffffc02025d2:	842e                	mv	s0,a1
ffffffffc02025d4:	84b2                	mv	s1,a2
ffffffffc02025d6:	e3e5                	bnez	a5,ffffffffc02026b6 <unmap_range+0x110>
ffffffffc02025d8:	4785                	li	a5,1
ffffffffc02025da:	07fe                	slli	a5,a5,0x1f
ffffffffc02025dc:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc02025de:	892a                	mv	s2,a0
ffffffffc02025e0:	6985                	lui	s3,0x1
ffffffffc02025e2:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02025e6:	0cf67863          	bgeu	a2,a5,ffffffffc02026b6 <unmap_range+0x110>
ffffffffc02025ea:	4601                	li	a2,0
ffffffffc02025ec:	85a2                	mv	a1,s0
ffffffffc02025ee:	854a                	mv	a0,s2
ffffffffc02025f0:	c3dff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc02025f4:	87aa                	mv	a5,a0
ffffffffc02025f6:	cd31                	beqz	a0,ffffffffc0202652 <unmap_range+0xac>
ffffffffc02025f8:	6118                	ld	a4,0(a0)
ffffffffc02025fa:	ef11                	bnez	a4,ffffffffc0202616 <unmap_range+0x70>
ffffffffc02025fc:	944e                	add	s0,s0,s3
ffffffffc02025fe:	c019                	beqz	s0,ffffffffc0202604 <unmap_range+0x5e>
ffffffffc0202600:	fe9465e3          	bltu	s0,s1,ffffffffc02025ea <unmap_range+0x44>
ffffffffc0202604:	60a6                	ld	ra,72(sp)
ffffffffc0202606:	6406                	ld	s0,64(sp)
ffffffffc0202608:	74e2                	ld	s1,56(sp)
ffffffffc020260a:	7942                	ld	s2,48(sp)
ffffffffc020260c:	79a2                	ld	s3,40(sp)
ffffffffc020260e:	7a02                	ld	s4,32(sp)
ffffffffc0202610:	6ae2                	ld	s5,24(sp)
ffffffffc0202612:	6161                	addi	sp,sp,80
ffffffffc0202614:	8082                	ret
ffffffffc0202616:	00177693          	andi	a3,a4,1
ffffffffc020261a:	d2ed                	beqz	a3,ffffffffc02025fc <unmap_range+0x56>
ffffffffc020261c:	00094697          	auipc	a3,0x94
ffffffffc0202620:	2946b683          	ld	a3,660(a3) # ffffffffc02968b0 <npage>
ffffffffc0202624:	070a                	slli	a4,a4,0x2
ffffffffc0202626:	8331                	srli	a4,a4,0xc
ffffffffc0202628:	0ad77763          	bgeu	a4,a3,ffffffffc02026d6 <unmap_range+0x130>
ffffffffc020262c:	00094517          	auipc	a0,0x94
ffffffffc0202630:	28c53503          	ld	a0,652(a0) # ffffffffc02968b8 <pages>
ffffffffc0202634:	071a                	slli	a4,a4,0x6
ffffffffc0202636:	fe0006b7          	lui	a3,0xfe000
ffffffffc020263a:	9736                	add	a4,a4,a3
ffffffffc020263c:	953a                	add	a0,a0,a4
ffffffffc020263e:	4118                	lw	a4,0(a0)
ffffffffc0202640:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd696ef>
ffffffffc0202642:	c118                	sw	a4,0(a0)
ffffffffc0202644:	cb19                	beqz	a4,ffffffffc020265a <unmap_range+0xb4>
ffffffffc0202646:	0007b023          	sd	zero,0(a5)
ffffffffc020264a:	12040073          	sfence.vma	s0
ffffffffc020264e:	944e                	add	s0,s0,s3
ffffffffc0202650:	b77d                	j	ffffffffc02025fe <unmap_range+0x58>
ffffffffc0202652:	9452                	add	s0,s0,s4
ffffffffc0202654:	01547433          	and	s0,s0,s5
ffffffffc0202658:	b75d                	j	ffffffffc02025fe <unmap_range+0x58>
ffffffffc020265a:	10002773          	csrr	a4,sstatus
ffffffffc020265e:	8b09                	andi	a4,a4,2
ffffffffc0202660:	eb19                	bnez	a4,ffffffffc0202676 <unmap_range+0xd0>
ffffffffc0202662:	00094717          	auipc	a4,0x94
ffffffffc0202666:	22e73703          	ld	a4,558(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020266a:	4585                	li	a1,1
ffffffffc020266c:	e03e                	sd	a5,0(sp)
ffffffffc020266e:	7318                	ld	a4,32(a4)
ffffffffc0202670:	9702                	jalr	a4
ffffffffc0202672:	6782                	ld	a5,0(sp)
ffffffffc0202674:	bfc9                	j	ffffffffc0202646 <unmap_range+0xa0>
ffffffffc0202676:	e43e                	sd	a5,8(sp)
ffffffffc0202678:	e02a                	sd	a0,0(sp)
ffffffffc020267a:	d5efe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020267e:	00094717          	auipc	a4,0x94
ffffffffc0202682:	21273703          	ld	a4,530(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202686:	6502                	ld	a0,0(sp)
ffffffffc0202688:	4585                	li	a1,1
ffffffffc020268a:	7318                	ld	a4,32(a4)
ffffffffc020268c:	9702                	jalr	a4
ffffffffc020268e:	d44fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202692:	67a2                	ld	a5,8(sp)
ffffffffc0202694:	bf4d                	j	ffffffffc0202646 <unmap_range+0xa0>
ffffffffc0202696:	0000a697          	auipc	a3,0xa
ffffffffc020269a:	10a68693          	addi	a3,a3,266 # ffffffffc020c7a0 <etext+0xfdc>
ffffffffc020269e:	00009617          	auipc	a2,0x9
ffffffffc02026a2:	56260613          	addi	a2,a2,1378 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02026a6:	15a00593          	li	a1,346
ffffffffc02026aa:	0000a517          	auipc	a0,0xa
ffffffffc02026ae:	0be50513          	addi	a0,a0,190 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02026b2:	d99fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02026b6:	0000a697          	auipc	a3,0xa
ffffffffc02026ba:	11a68693          	addi	a3,a3,282 # ffffffffc020c7d0 <etext+0x100c>
ffffffffc02026be:	00009617          	auipc	a2,0x9
ffffffffc02026c2:	54260613          	addi	a2,a2,1346 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02026c6:	15b00593          	li	a1,347
ffffffffc02026ca:	0000a517          	auipc	a0,0xa
ffffffffc02026ce:	09e50513          	addi	a0,a0,158 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02026d2:	d79fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02026d6:	a93ff0ef          	jal	ffffffffc0202168 <pa2page.part.0>

ffffffffc02026da <exit_range>:
ffffffffc02026da:	7135                	addi	sp,sp,-160
ffffffffc02026dc:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026e0:	ed06                	sd	ra,152(sp)
ffffffffc02026e2:	e922                	sd	s0,144(sp)
ffffffffc02026e4:	e526                	sd	s1,136(sp)
ffffffffc02026e6:	e14a                	sd	s2,128(sp)
ffffffffc02026e8:	fcce                	sd	s3,120(sp)
ffffffffc02026ea:	f8d2                	sd	s4,112(sp)
ffffffffc02026ec:	f4d6                	sd	s5,104(sp)
ffffffffc02026ee:	f0da                	sd	s6,96(sp)
ffffffffc02026f0:	ecde                	sd	s7,88(sp)
ffffffffc02026f2:	17d2                	slli	a5,a5,0x34
ffffffffc02026f4:	22079263          	bnez	a5,ffffffffc0202918 <exit_range+0x23e>
ffffffffc02026f8:	00200937          	lui	s2,0x200
ffffffffc02026fc:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202700:	0125b733          	sltu	a4,a1,s2
ffffffffc0202704:	0017b793          	seqz	a5,a5
ffffffffc0202708:	8fd9                	or	a5,a5,a4
ffffffffc020270a:	26079263          	bnez	a5,ffffffffc020296e <exit_range+0x294>
ffffffffc020270e:	4785                	li	a5,1
ffffffffc0202710:	07fe                	slli	a5,a5,0x1f
ffffffffc0202712:	0785                	addi	a5,a5,1
ffffffffc0202714:	24f67d63          	bgeu	a2,a5,ffffffffc020296e <exit_range+0x294>
ffffffffc0202718:	c00004b7          	lui	s1,0xc0000
ffffffffc020271c:	ffe007b7          	lui	a5,0xffe00
ffffffffc0202720:	8a2a                	mv	s4,a0
ffffffffc0202722:	8ced                	and	s1,s1,a1
ffffffffc0202724:	00f5f833          	and	a6,a1,a5
ffffffffc0202728:	00094a97          	auipc	s5,0x94
ffffffffc020272c:	188a8a93          	addi	s5,s5,392 # ffffffffc02968b0 <npage>
ffffffffc0202730:	400009b7          	lui	s3,0x40000
ffffffffc0202734:	a809                	j	ffffffffc0202746 <exit_range+0x6c>
ffffffffc0202736:	013487b3          	add	a5,s1,s3
ffffffffc020273a:	400004b7          	lui	s1,0x40000
ffffffffc020273e:	8826                	mv	a6,s1
ffffffffc0202740:	c3f1                	beqz	a5,ffffffffc0202804 <exit_range+0x12a>
ffffffffc0202742:	0cc7f163          	bgeu	a5,a2,ffffffffc0202804 <exit_range+0x12a>
ffffffffc0202746:	01e4d413          	srli	s0,s1,0x1e
ffffffffc020274a:	1ff47413          	andi	s0,s0,511
ffffffffc020274e:	040e                	slli	s0,s0,0x3
ffffffffc0202750:	9452                	add	s0,s0,s4
ffffffffc0202752:	00043883          	ld	a7,0(s0)
ffffffffc0202756:	0018f793          	andi	a5,a7,1
ffffffffc020275a:	dff1                	beqz	a5,ffffffffc0202736 <exit_range+0x5c>
ffffffffc020275c:	000ab783          	ld	a5,0(s5)
ffffffffc0202760:	088a                	slli	a7,a7,0x2
ffffffffc0202762:	00c8d893          	srli	a7,a7,0xc
ffffffffc0202766:	20f8f263          	bgeu	a7,a5,ffffffffc020296a <exit_range+0x290>
ffffffffc020276a:	fff802b7          	lui	t0,0xfff80
ffffffffc020276e:	00588f33          	add	t5,a7,t0
ffffffffc0202772:	000803b7          	lui	t2,0x80
ffffffffc0202776:	007f0733          	add	a4,t5,t2
ffffffffc020277a:	00c71e13          	slli	t3,a4,0xc
ffffffffc020277e:	0f1a                	slli	t5,t5,0x6
ffffffffc0202780:	1cf77863          	bgeu	a4,a5,ffffffffc0202950 <exit_range+0x276>
ffffffffc0202784:	00094f97          	auipc	t6,0x94
ffffffffc0202788:	124f8f93          	addi	t6,t6,292 # ffffffffc02968a8 <va_pa_offset>
ffffffffc020278c:	000fb783          	ld	a5,0(t6)
ffffffffc0202790:	4e85                	li	t4,1
ffffffffc0202792:	6b05                	lui	s6,0x1
ffffffffc0202794:	9e3e                	add	t3,t3,a5
ffffffffc0202796:	01348333          	add	t1,s1,s3
ffffffffc020279a:	01585713          	srli	a4,a6,0x15
ffffffffc020279e:	1ff77713          	andi	a4,a4,511
ffffffffc02027a2:	070e                	slli	a4,a4,0x3
ffffffffc02027a4:	9772                	add	a4,a4,t3
ffffffffc02027a6:	631c                	ld	a5,0(a4)
ffffffffc02027a8:	0017f693          	andi	a3,a5,1
ffffffffc02027ac:	e6bd                	bnez	a3,ffffffffc020281a <exit_range+0x140>
ffffffffc02027ae:	4e81                	li	t4,0
ffffffffc02027b0:	984a                	add	a6,a6,s2
ffffffffc02027b2:	00080863          	beqz	a6,ffffffffc02027c2 <exit_range+0xe8>
ffffffffc02027b6:	879a                	mv	a5,t1
ffffffffc02027b8:	00667363          	bgeu	a2,t1,ffffffffc02027be <exit_range+0xe4>
ffffffffc02027bc:	87b2                	mv	a5,a2
ffffffffc02027be:	fcf86ee3          	bltu	a6,a5,ffffffffc020279a <exit_range+0xc0>
ffffffffc02027c2:	f60e8ae3          	beqz	t4,ffffffffc0202736 <exit_range+0x5c>
ffffffffc02027c6:	000ab783          	ld	a5,0(s5)
ffffffffc02027ca:	1af8f063          	bgeu	a7,a5,ffffffffc020296a <exit_range+0x290>
ffffffffc02027ce:	00094517          	auipc	a0,0x94
ffffffffc02027d2:	0ea53503          	ld	a0,234(a0) # ffffffffc02968b8 <pages>
ffffffffc02027d6:	957a                	add	a0,a0,t5
ffffffffc02027d8:	100027f3          	csrr	a5,sstatus
ffffffffc02027dc:	8b89                	andi	a5,a5,2
ffffffffc02027de:	10079b63          	bnez	a5,ffffffffc02028f4 <exit_range+0x21a>
ffffffffc02027e2:	00094797          	auipc	a5,0x94
ffffffffc02027e6:	0ae7b783          	ld	a5,174(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02027ea:	4585                	li	a1,1
ffffffffc02027ec:	e432                	sd	a2,8(sp)
ffffffffc02027ee:	739c                	ld	a5,32(a5)
ffffffffc02027f0:	9782                	jalr	a5
ffffffffc02027f2:	6622                	ld	a2,8(sp)
ffffffffc02027f4:	00043023          	sd	zero,0(s0)
ffffffffc02027f8:	013487b3          	add	a5,s1,s3
ffffffffc02027fc:	400004b7          	lui	s1,0x40000
ffffffffc0202800:	8826                	mv	a6,s1
ffffffffc0202802:	f3a1                	bnez	a5,ffffffffc0202742 <exit_range+0x68>
ffffffffc0202804:	60ea                	ld	ra,152(sp)
ffffffffc0202806:	644a                	ld	s0,144(sp)
ffffffffc0202808:	64aa                	ld	s1,136(sp)
ffffffffc020280a:	690a                	ld	s2,128(sp)
ffffffffc020280c:	79e6                	ld	s3,120(sp)
ffffffffc020280e:	7a46                	ld	s4,112(sp)
ffffffffc0202810:	7aa6                	ld	s5,104(sp)
ffffffffc0202812:	7b06                	ld	s6,96(sp)
ffffffffc0202814:	6be6                	ld	s7,88(sp)
ffffffffc0202816:	610d                	addi	sp,sp,160
ffffffffc0202818:	8082                	ret
ffffffffc020281a:	000ab503          	ld	a0,0(s5)
ffffffffc020281e:	078a                	slli	a5,a5,0x2
ffffffffc0202820:	83b1                	srli	a5,a5,0xc
ffffffffc0202822:	14a7f463          	bgeu	a5,a0,ffffffffc020296a <exit_range+0x290>
ffffffffc0202826:	9796                	add	a5,a5,t0
ffffffffc0202828:	00778bb3          	add	s7,a5,t2
ffffffffc020282c:	00679593          	slli	a1,a5,0x6
ffffffffc0202830:	00cb9693          	slli	a3,s7,0xc
ffffffffc0202834:	10abf263          	bgeu	s7,a0,ffffffffc0202938 <exit_range+0x25e>
ffffffffc0202838:	000fb783          	ld	a5,0(t6)
ffffffffc020283c:	96be                	add	a3,a3,a5
ffffffffc020283e:	01668533          	add	a0,a3,s6
ffffffffc0202842:	629c                	ld	a5,0(a3)
ffffffffc0202844:	8b85                	andi	a5,a5,1
ffffffffc0202846:	f7ad                	bnez	a5,ffffffffc02027b0 <exit_range+0xd6>
ffffffffc0202848:	06a1                	addi	a3,a3,8
ffffffffc020284a:	fea69ce3          	bne	a3,a0,ffffffffc0202842 <exit_range+0x168>
ffffffffc020284e:	00094517          	auipc	a0,0x94
ffffffffc0202852:	06a53503          	ld	a0,106(a0) # ffffffffc02968b8 <pages>
ffffffffc0202856:	952e                	add	a0,a0,a1
ffffffffc0202858:	100027f3          	csrr	a5,sstatus
ffffffffc020285c:	8b89                	andi	a5,a5,2
ffffffffc020285e:	e3b9                	bnez	a5,ffffffffc02028a4 <exit_range+0x1ca>
ffffffffc0202860:	00094797          	auipc	a5,0x94
ffffffffc0202864:	0307b783          	ld	a5,48(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202868:	4585                	li	a1,1
ffffffffc020286a:	e0b2                	sd	a2,64(sp)
ffffffffc020286c:	739c                	ld	a5,32(a5)
ffffffffc020286e:	fc1a                	sd	t1,56(sp)
ffffffffc0202870:	f846                	sd	a7,48(sp)
ffffffffc0202872:	f47a                	sd	t5,40(sp)
ffffffffc0202874:	f072                	sd	t3,32(sp)
ffffffffc0202876:	ec76                	sd	t4,24(sp)
ffffffffc0202878:	e842                	sd	a6,16(sp)
ffffffffc020287a:	e43a                	sd	a4,8(sp)
ffffffffc020287c:	9782                	jalr	a5
ffffffffc020287e:	6722                	ld	a4,8(sp)
ffffffffc0202880:	6842                	ld	a6,16(sp)
ffffffffc0202882:	6ee2                	ld	t4,24(sp)
ffffffffc0202884:	7e02                	ld	t3,32(sp)
ffffffffc0202886:	7f22                	ld	t5,40(sp)
ffffffffc0202888:	78c2                	ld	a7,48(sp)
ffffffffc020288a:	7362                	ld	t1,56(sp)
ffffffffc020288c:	6606                	ld	a2,64(sp)
ffffffffc020288e:	fff802b7          	lui	t0,0xfff80
ffffffffc0202892:	000803b7          	lui	t2,0x80
ffffffffc0202896:	00094f97          	auipc	t6,0x94
ffffffffc020289a:	012f8f93          	addi	t6,t6,18 # ffffffffc02968a8 <va_pa_offset>
ffffffffc020289e:	00073023          	sd	zero,0(a4)
ffffffffc02028a2:	b739                	j	ffffffffc02027b0 <exit_range+0xd6>
ffffffffc02028a4:	e4b2                	sd	a2,72(sp)
ffffffffc02028a6:	e09a                	sd	t1,64(sp)
ffffffffc02028a8:	fc46                	sd	a7,56(sp)
ffffffffc02028aa:	f47a                	sd	t5,40(sp)
ffffffffc02028ac:	f072                	sd	t3,32(sp)
ffffffffc02028ae:	ec76                	sd	t4,24(sp)
ffffffffc02028b0:	e842                	sd	a6,16(sp)
ffffffffc02028b2:	e43a                	sd	a4,8(sp)
ffffffffc02028b4:	f82a                	sd	a0,48(sp)
ffffffffc02028b6:	b22fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02028ba:	00094797          	auipc	a5,0x94
ffffffffc02028be:	fd67b783          	ld	a5,-42(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02028c2:	7542                	ld	a0,48(sp)
ffffffffc02028c4:	4585                	li	a1,1
ffffffffc02028c6:	739c                	ld	a5,32(a5)
ffffffffc02028c8:	9782                	jalr	a5
ffffffffc02028ca:	b08fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02028ce:	6722                	ld	a4,8(sp)
ffffffffc02028d0:	6626                	ld	a2,72(sp)
ffffffffc02028d2:	6306                	ld	t1,64(sp)
ffffffffc02028d4:	78e2                	ld	a7,56(sp)
ffffffffc02028d6:	7f22                	ld	t5,40(sp)
ffffffffc02028d8:	7e02                	ld	t3,32(sp)
ffffffffc02028da:	6ee2                	ld	t4,24(sp)
ffffffffc02028dc:	6842                	ld	a6,16(sp)
ffffffffc02028de:	00094f97          	auipc	t6,0x94
ffffffffc02028e2:	fcaf8f93          	addi	t6,t6,-54 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02028e6:	000803b7          	lui	t2,0x80
ffffffffc02028ea:	fff802b7          	lui	t0,0xfff80
ffffffffc02028ee:	00073023          	sd	zero,0(a4)
ffffffffc02028f2:	bd7d                	j	ffffffffc02027b0 <exit_range+0xd6>
ffffffffc02028f4:	e832                	sd	a2,16(sp)
ffffffffc02028f6:	e42a                	sd	a0,8(sp)
ffffffffc02028f8:	ae0fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02028fc:	00094797          	auipc	a5,0x94
ffffffffc0202900:	f947b783          	ld	a5,-108(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202904:	6522                	ld	a0,8(sp)
ffffffffc0202906:	4585                	li	a1,1
ffffffffc0202908:	739c                	ld	a5,32(a5)
ffffffffc020290a:	9782                	jalr	a5
ffffffffc020290c:	ac6fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202910:	6642                	ld	a2,16(sp)
ffffffffc0202912:	00043023          	sd	zero,0(s0)
ffffffffc0202916:	b5cd                	j	ffffffffc02027f8 <exit_range+0x11e>
ffffffffc0202918:	0000a697          	auipc	a3,0xa
ffffffffc020291c:	e8868693          	addi	a3,a3,-376 # ffffffffc020c7a0 <etext+0xfdc>
ffffffffc0202920:	00009617          	auipc	a2,0x9
ffffffffc0202924:	2e060613          	addi	a2,a2,736 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0202928:	16f00593          	li	a1,367
ffffffffc020292c:	0000a517          	auipc	a0,0xa
ffffffffc0202930:	e3c50513          	addi	a0,a0,-452 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0202934:	b17fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202938:	0000a617          	auipc	a2,0xa
ffffffffc020293c:	d4060613          	addi	a2,a2,-704 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0202940:	07100593          	li	a1,113
ffffffffc0202944:	0000a517          	auipc	a0,0xa
ffffffffc0202948:	d5c50513          	addi	a0,a0,-676 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc020294c:	afffd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202950:	86f2                	mv	a3,t3
ffffffffc0202952:	0000a617          	auipc	a2,0xa
ffffffffc0202956:	d2660613          	addi	a2,a2,-730 # ffffffffc020c678 <etext+0xeb4>
ffffffffc020295a:	07100593          	li	a1,113
ffffffffc020295e:	0000a517          	auipc	a0,0xa
ffffffffc0202962:	d4250513          	addi	a0,a0,-702 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0202966:	ae5fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020296a:	ffeff0ef          	jal	ffffffffc0202168 <pa2page.part.0>
ffffffffc020296e:	0000a697          	auipc	a3,0xa
ffffffffc0202972:	e6268693          	addi	a3,a3,-414 # ffffffffc020c7d0 <etext+0x100c>
ffffffffc0202976:	00009617          	auipc	a2,0x9
ffffffffc020297a:	28a60613          	addi	a2,a2,650 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020297e:	17000593          	li	a1,368
ffffffffc0202982:	0000a517          	auipc	a0,0xa
ffffffffc0202986:	de650513          	addi	a0,a0,-538 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020298a:	ac1fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020298e <page_remove>:
ffffffffc020298e:	1101                	addi	sp,sp,-32
ffffffffc0202990:	4601                	li	a2,0
ffffffffc0202992:	e822                	sd	s0,16(sp)
ffffffffc0202994:	ec06                	sd	ra,24(sp)
ffffffffc0202996:	842e                	mv	s0,a1
ffffffffc0202998:	895ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc020299c:	c511                	beqz	a0,ffffffffc02029a8 <page_remove+0x1a>
ffffffffc020299e:	6118                	ld	a4,0(a0)
ffffffffc02029a0:	87aa                	mv	a5,a0
ffffffffc02029a2:	00177693          	andi	a3,a4,1
ffffffffc02029a6:	e689                	bnez	a3,ffffffffc02029b0 <page_remove+0x22>
ffffffffc02029a8:	60e2                	ld	ra,24(sp)
ffffffffc02029aa:	6442                	ld	s0,16(sp)
ffffffffc02029ac:	6105                	addi	sp,sp,32
ffffffffc02029ae:	8082                	ret
ffffffffc02029b0:	00094697          	auipc	a3,0x94
ffffffffc02029b4:	f006b683          	ld	a3,-256(a3) # ffffffffc02968b0 <npage>
ffffffffc02029b8:	070a                	slli	a4,a4,0x2
ffffffffc02029ba:	8331                	srli	a4,a4,0xc
ffffffffc02029bc:	06d77563          	bgeu	a4,a3,ffffffffc0202a26 <page_remove+0x98>
ffffffffc02029c0:	00094517          	auipc	a0,0x94
ffffffffc02029c4:	ef853503          	ld	a0,-264(a0) # ffffffffc02968b8 <pages>
ffffffffc02029c8:	071a                	slli	a4,a4,0x6
ffffffffc02029ca:	fe0006b7          	lui	a3,0xfe000
ffffffffc02029ce:	9736                	add	a4,a4,a3
ffffffffc02029d0:	953a                	add	a0,a0,a4
ffffffffc02029d2:	4118                	lw	a4,0(a0)
ffffffffc02029d4:	377d                	addiw	a4,a4,-1
ffffffffc02029d6:	c118                	sw	a4,0(a0)
ffffffffc02029d8:	cb09                	beqz	a4,ffffffffc02029ea <page_remove+0x5c>
ffffffffc02029da:	0007b023          	sd	zero,0(a5)
ffffffffc02029de:	12040073          	sfence.vma	s0
ffffffffc02029e2:	60e2                	ld	ra,24(sp)
ffffffffc02029e4:	6442                	ld	s0,16(sp)
ffffffffc02029e6:	6105                	addi	sp,sp,32
ffffffffc02029e8:	8082                	ret
ffffffffc02029ea:	10002773          	csrr	a4,sstatus
ffffffffc02029ee:	8b09                	andi	a4,a4,2
ffffffffc02029f0:	eb19                	bnez	a4,ffffffffc0202a06 <page_remove+0x78>
ffffffffc02029f2:	00094717          	auipc	a4,0x94
ffffffffc02029f6:	e9e73703          	ld	a4,-354(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02029fa:	4585                	li	a1,1
ffffffffc02029fc:	e03e                	sd	a5,0(sp)
ffffffffc02029fe:	7318                	ld	a4,32(a4)
ffffffffc0202a00:	9702                	jalr	a4
ffffffffc0202a02:	6782                	ld	a5,0(sp)
ffffffffc0202a04:	bfd9                	j	ffffffffc02029da <page_remove+0x4c>
ffffffffc0202a06:	e43e                	sd	a5,8(sp)
ffffffffc0202a08:	e02a                	sd	a0,0(sp)
ffffffffc0202a0a:	9cefe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202a0e:	00094717          	auipc	a4,0x94
ffffffffc0202a12:	e8273703          	ld	a4,-382(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a16:	6502                	ld	a0,0(sp)
ffffffffc0202a18:	4585                	li	a1,1
ffffffffc0202a1a:	7318                	ld	a4,32(a4)
ffffffffc0202a1c:	9702                	jalr	a4
ffffffffc0202a1e:	9b4fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202a22:	67a2                	ld	a5,8(sp)
ffffffffc0202a24:	bf5d                	j	ffffffffc02029da <page_remove+0x4c>
ffffffffc0202a26:	f42ff0ef          	jal	ffffffffc0202168 <pa2page.part.0>

ffffffffc0202a2a <page_insert>:
ffffffffc0202a2a:	7139                	addi	sp,sp,-64
ffffffffc0202a2c:	f426                	sd	s1,40(sp)
ffffffffc0202a2e:	84b2                	mv	s1,a2
ffffffffc0202a30:	f822                	sd	s0,48(sp)
ffffffffc0202a32:	4605                	li	a2,1
ffffffffc0202a34:	842e                	mv	s0,a1
ffffffffc0202a36:	85a6                	mv	a1,s1
ffffffffc0202a38:	fc06                	sd	ra,56(sp)
ffffffffc0202a3a:	e436                	sd	a3,8(sp)
ffffffffc0202a3c:	ff0ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202a40:	cd61                	beqz	a0,ffffffffc0202b18 <page_insert+0xee>
ffffffffc0202a42:	400c                	lw	a1,0(s0)
ffffffffc0202a44:	611c                	ld	a5,0(a0)
ffffffffc0202a46:	66a2                	ld	a3,8(sp)
ffffffffc0202a48:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0202a4c:	c010                	sw	a2,0(s0)
ffffffffc0202a4e:	0017f613          	andi	a2,a5,1
ffffffffc0202a52:	872a                	mv	a4,a0
ffffffffc0202a54:	e61d                	bnez	a2,ffffffffc0202a82 <page_insert+0x58>
ffffffffc0202a56:	00094617          	auipc	a2,0x94
ffffffffc0202a5a:	e6263603          	ld	a2,-414(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a5e:	8c11                	sub	s0,s0,a2
ffffffffc0202a60:	8419                	srai	s0,s0,0x6
ffffffffc0202a62:	200007b7          	lui	a5,0x20000
ffffffffc0202a66:	042a                	slli	s0,s0,0xa
ffffffffc0202a68:	943e                	add	s0,s0,a5
ffffffffc0202a6a:	8ec1                	or	a3,a3,s0
ffffffffc0202a6c:	0016e693          	ori	a3,a3,1
ffffffffc0202a70:	e314                	sd	a3,0(a4)
ffffffffc0202a72:	12048073          	sfence.vma	s1
ffffffffc0202a76:	4501                	li	a0,0
ffffffffc0202a78:	70e2                	ld	ra,56(sp)
ffffffffc0202a7a:	7442                	ld	s0,48(sp)
ffffffffc0202a7c:	74a2                	ld	s1,40(sp)
ffffffffc0202a7e:	6121                	addi	sp,sp,64
ffffffffc0202a80:	8082                	ret
ffffffffc0202a82:	00094617          	auipc	a2,0x94
ffffffffc0202a86:	e2e63603          	ld	a2,-466(a2) # ffffffffc02968b0 <npage>
ffffffffc0202a8a:	078a                	slli	a5,a5,0x2
ffffffffc0202a8c:	83b1                	srli	a5,a5,0xc
ffffffffc0202a8e:	08c7f763          	bgeu	a5,a2,ffffffffc0202b1c <page_insert+0xf2>
ffffffffc0202a92:	00094617          	auipc	a2,0x94
ffffffffc0202a96:	e2663603          	ld	a2,-474(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a9a:	fe000537          	lui	a0,0xfe000
ffffffffc0202a9e:	079a                	slli	a5,a5,0x6
ffffffffc0202aa0:	97aa                	add	a5,a5,a0
ffffffffc0202aa2:	00f60533          	add	a0,a2,a5
ffffffffc0202aa6:	00a40963          	beq	s0,a0,ffffffffc0202ab8 <page_insert+0x8e>
ffffffffc0202aaa:	411c                	lw	a5,0(a0)
ffffffffc0202aac:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_bin_sfs_img_size+0x1ff8acff>
ffffffffc0202aae:	c11c                	sw	a5,0(a0)
ffffffffc0202ab0:	c791                	beqz	a5,ffffffffc0202abc <page_insert+0x92>
ffffffffc0202ab2:	12048073          	sfence.vma	s1
ffffffffc0202ab6:	b765                	j	ffffffffc0202a5e <page_insert+0x34>
ffffffffc0202ab8:	c00c                	sw	a1,0(s0)
ffffffffc0202aba:	b755                	j	ffffffffc0202a5e <page_insert+0x34>
ffffffffc0202abc:	100027f3          	csrr	a5,sstatus
ffffffffc0202ac0:	8b89                	andi	a5,a5,2
ffffffffc0202ac2:	e39d                	bnez	a5,ffffffffc0202ae8 <page_insert+0xbe>
ffffffffc0202ac4:	00094797          	auipc	a5,0x94
ffffffffc0202ac8:	dcc7b783          	ld	a5,-564(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202acc:	4585                	li	a1,1
ffffffffc0202ace:	e83a                	sd	a4,16(sp)
ffffffffc0202ad0:	739c                	ld	a5,32(a5)
ffffffffc0202ad2:	e436                	sd	a3,8(sp)
ffffffffc0202ad4:	9782                	jalr	a5
ffffffffc0202ad6:	00094617          	auipc	a2,0x94
ffffffffc0202ada:	de263603          	ld	a2,-542(a2) # ffffffffc02968b8 <pages>
ffffffffc0202ade:	66a2                	ld	a3,8(sp)
ffffffffc0202ae0:	6742                	ld	a4,16(sp)
ffffffffc0202ae2:	12048073          	sfence.vma	s1
ffffffffc0202ae6:	bfa5                	j	ffffffffc0202a5e <page_insert+0x34>
ffffffffc0202ae8:	ec3a                	sd	a4,24(sp)
ffffffffc0202aea:	e836                	sd	a3,16(sp)
ffffffffc0202aec:	e42a                	sd	a0,8(sp)
ffffffffc0202aee:	8eafe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202af2:	00094797          	auipc	a5,0x94
ffffffffc0202af6:	d9e7b783          	ld	a5,-610(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202afa:	6522                	ld	a0,8(sp)
ffffffffc0202afc:	4585                	li	a1,1
ffffffffc0202afe:	739c                	ld	a5,32(a5)
ffffffffc0202b00:	9782                	jalr	a5
ffffffffc0202b02:	8d0fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202b06:	00094617          	auipc	a2,0x94
ffffffffc0202b0a:	db263603          	ld	a2,-590(a2) # ffffffffc02968b8 <pages>
ffffffffc0202b0e:	6762                	ld	a4,24(sp)
ffffffffc0202b10:	66c2                	ld	a3,16(sp)
ffffffffc0202b12:	12048073          	sfence.vma	s1
ffffffffc0202b16:	b7a1                	j	ffffffffc0202a5e <page_insert+0x34>
ffffffffc0202b18:	5571                	li	a0,-4
ffffffffc0202b1a:	bfb9                	j	ffffffffc0202a78 <page_insert+0x4e>
ffffffffc0202b1c:	e4cff0ef          	jal	ffffffffc0202168 <pa2page.part.0>

ffffffffc0202b20 <pmm_init>:
ffffffffc0202b20:	0000c797          	auipc	a5,0xc
ffffffffc0202b24:	39878793          	addi	a5,a5,920 # ffffffffc020eeb8 <default_pmm_manager>
ffffffffc0202b28:	638c                	ld	a1,0(a5)
ffffffffc0202b2a:	7159                	addi	sp,sp,-112
ffffffffc0202b2c:	f486                	sd	ra,104(sp)
ffffffffc0202b2e:	e8ca                	sd	s2,80(sp)
ffffffffc0202b30:	e4ce                	sd	s3,72(sp)
ffffffffc0202b32:	f85a                	sd	s6,48(sp)
ffffffffc0202b34:	f0a2                	sd	s0,96(sp)
ffffffffc0202b36:	eca6                	sd	s1,88(sp)
ffffffffc0202b38:	e0d2                	sd	s4,64(sp)
ffffffffc0202b3a:	fc56                	sd	s5,56(sp)
ffffffffc0202b3c:	f45e                	sd	s7,40(sp)
ffffffffc0202b3e:	f062                	sd	s8,32(sp)
ffffffffc0202b40:	ec66                	sd	s9,24(sp)
ffffffffc0202b42:	00094b17          	auipc	s6,0x94
ffffffffc0202b46:	d4eb0b13          	addi	s6,s6,-690 # ffffffffc0296890 <pmm_manager>
ffffffffc0202b4a:	0000a517          	auipc	a0,0xa
ffffffffc0202b4e:	c9e50513          	addi	a0,a0,-866 # ffffffffc020c7e8 <etext+0x1024>
ffffffffc0202b52:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b56:	e50fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202b5e:	00094997          	auipc	s3,0x94
ffffffffc0202b62:	d4a98993          	addi	s3,s3,-694 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202b66:	679c                	ld	a5,8(a5)
ffffffffc0202b68:	9782                	jalr	a5
ffffffffc0202b6a:	57f5                	li	a5,-3
ffffffffc0202b6c:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b6e:	00f9b023          	sd	a5,0(s3)
ffffffffc0202b72:	e37fd0ef          	jal	ffffffffc02009a8 <get_memory_base>
ffffffffc0202b76:	892a                	mv	s2,a0
ffffffffc0202b78:	e3bfd0ef          	jal	ffffffffc02009b2 <get_memory_size>
ffffffffc0202b7c:	460506e3          	beqz	a0,ffffffffc02037e8 <pmm_init+0xcc8>
ffffffffc0202b80:	84aa                	mv	s1,a0
ffffffffc0202b82:	0000a517          	auipc	a0,0xa
ffffffffc0202b86:	c9e50513          	addi	a0,a0,-866 # ffffffffc020c820 <etext+0x105c>
ffffffffc0202b8a:	e1cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b8e:	00990433          	add	s0,s2,s1
ffffffffc0202b92:	864a                	mv	a2,s2
ffffffffc0202b94:	85a6                	mv	a1,s1
ffffffffc0202b96:	fff40693          	addi	a3,s0,-1
ffffffffc0202b9a:	0000a517          	auipc	a0,0xa
ffffffffc0202b9e:	c9e50513          	addi	a0,a0,-866 # ffffffffc020c838 <etext+0x1074>
ffffffffc0202ba2:	e04fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202ba6:	c80007b7          	lui	a5,0xc8000
ffffffffc0202baa:	8522                	mv	a0,s0
ffffffffc0202bac:	6887e263          	bltu	a5,s0,ffffffffc0203230 <pmm_init+0x710>
ffffffffc0202bb0:	77fd                	lui	a5,0xfffff
ffffffffc0202bb2:	00095617          	auipc	a2,0x95
ffffffffc0202bb6:	d5d60613          	addi	a2,a2,-675 # ffffffffc029790f <end+0xfff>
ffffffffc0202bba:	8e7d                	and	a2,a2,a5
ffffffffc0202bbc:	8131                	srli	a0,a0,0xc
ffffffffc0202bbe:	00094b97          	auipc	s7,0x94
ffffffffc0202bc2:	cfab8b93          	addi	s7,s7,-774 # ffffffffc02968b8 <pages>
ffffffffc0202bc6:	00094497          	auipc	s1,0x94
ffffffffc0202bca:	cea48493          	addi	s1,s1,-790 # ffffffffc02968b0 <npage>
ffffffffc0202bce:	00cbb023          	sd	a2,0(s7)
ffffffffc0202bd2:	e088                	sd	a0,0(s1)
ffffffffc0202bd4:	000807b7          	lui	a5,0x80
ffffffffc0202bd8:	86b2                	mv	a3,a2
ffffffffc0202bda:	02f50763          	beq	a0,a5,ffffffffc0202c08 <pmm_init+0xe8>
ffffffffc0202bde:	4701                	li	a4,0
ffffffffc0202be0:	4585                	li	a1,1
ffffffffc0202be2:	fff806b7          	lui	a3,0xfff80
ffffffffc0202be6:	00671793          	slli	a5,a4,0x6
ffffffffc0202bea:	97b2                	add	a5,a5,a2
ffffffffc0202bec:	07a1                	addi	a5,a5,8 # 80008 <_binary_bin_sfs_img_size+0xad08>
ffffffffc0202bee:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202bf2:	6088                	ld	a0,0(s1)
ffffffffc0202bf4:	0705                	addi	a4,a4,1
ffffffffc0202bf6:	000bb603          	ld	a2,0(s7)
ffffffffc0202bfa:	00d507b3          	add	a5,a0,a3
ffffffffc0202bfe:	fef764e3          	bltu	a4,a5,ffffffffc0202be6 <pmm_init+0xc6>
ffffffffc0202c02:	079a                	slli	a5,a5,0x6
ffffffffc0202c04:	00f606b3          	add	a3,a2,a5
ffffffffc0202c08:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c0c:	36f6ede3          	bltu	a3,a5,ffffffffc0203786 <pmm_init+0xc66>
ffffffffc0202c10:	0009b583          	ld	a1,0(s3)
ffffffffc0202c14:	77fd                	lui	a5,0xfffff
ffffffffc0202c16:	8c7d                	and	s0,s0,a5
ffffffffc0202c18:	8e8d                	sub	a3,a3,a1
ffffffffc0202c1a:	6486ed63          	bltu	a3,s0,ffffffffc0203274 <pmm_init+0x754>
ffffffffc0202c1e:	0000a517          	auipc	a0,0xa
ffffffffc0202c22:	c4250513          	addi	a0,a0,-958 # ffffffffc020c860 <etext+0x109c>
ffffffffc0202c26:	d80fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c2e:	7b9c                	ld	a5,48(a5)
ffffffffc0202c30:	9782                	jalr	a5
ffffffffc0202c32:	0000a517          	auipc	a0,0xa
ffffffffc0202c36:	c4650513          	addi	a0,a0,-954 # ffffffffc020c878 <etext+0x10b4>
ffffffffc0202c3a:	d6cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202c42:	8b89                	andi	a5,a5,2
ffffffffc0202c44:	60079d63          	bnez	a5,ffffffffc020325e <pmm_init+0x73e>
ffffffffc0202c48:	000b3783          	ld	a5,0(s6)
ffffffffc0202c4c:	4505                	li	a0,1
ffffffffc0202c4e:	6f9c                	ld	a5,24(a5)
ffffffffc0202c50:	9782                	jalr	a5
ffffffffc0202c52:	842a                	mv	s0,a0
ffffffffc0202c54:	36040ee3          	beqz	s0,ffffffffc02037d0 <pmm_init+0xcb0>
ffffffffc0202c58:	000bb703          	ld	a4,0(s7)
ffffffffc0202c5c:	000807b7          	lui	a5,0x80
ffffffffc0202c60:	5a7d                	li	s4,-1
ffffffffc0202c62:	40e406b3          	sub	a3,s0,a4
ffffffffc0202c66:	8699                	srai	a3,a3,0x6
ffffffffc0202c68:	6098                	ld	a4,0(s1)
ffffffffc0202c6a:	96be                	add	a3,a3,a5
ffffffffc0202c6c:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202c70:	8ff5                	and	a5,a5,a3
ffffffffc0202c72:	06b2                	slli	a3,a3,0xc
ffffffffc0202c74:	32e7f5e3          	bgeu	a5,a4,ffffffffc020379e <pmm_init+0xc7e>
ffffffffc0202c78:	0009b783          	ld	a5,0(s3)
ffffffffc0202c7c:	6605                	lui	a2,0x1
ffffffffc0202c7e:	4581                	li	a1,0
ffffffffc0202c80:	00f68433          	add	s0,a3,a5
ffffffffc0202c84:	8522                	mv	a0,s0
ffffffffc0202c86:	2d7080ef          	jal	ffffffffc020b75c <memset>
ffffffffc0202c8a:	0009b683          	ld	a3,0(s3)
ffffffffc0202c8e:	0000a917          	auipc	s2,0xa
ffffffffc0202c92:	b3590913          	addi	s2,s2,-1227 # ffffffffc020c7c3 <etext+0xfff>
ffffffffc0202c96:	77fd                	lui	a5,0xfffff
ffffffffc0202c98:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202c9c:	00f97933          	and	s2,s2,a5
ffffffffc0202ca0:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202ca4:	40da86b3          	sub	a3,s5,a3
ffffffffc0202ca8:	8522                	mv	a0,s0
ffffffffc0202caa:	964a                	add	a2,a2,s2
ffffffffc0202cac:	85d6                	mv	a1,s5
ffffffffc0202cae:	4729                	li	a4,10
ffffffffc0202cb0:	fdaff0ef          	jal	ffffffffc020248a <boot_map_segment>
ffffffffc0202cb4:	435962e3          	bltu	s2,s5,ffffffffc02038d8 <pmm_init+0xdb8>
ffffffffc0202cb8:	0009b683          	ld	a3,0(s3)
ffffffffc0202cbc:	c8000637          	lui	a2,0xc8000
ffffffffc0202cc0:	41260633          	sub	a2,a2,s2
ffffffffc0202cc4:	40d906b3          	sub	a3,s2,a3
ffffffffc0202cc8:	85ca                	mv	a1,s2
ffffffffc0202cca:	4719                	li	a4,6
ffffffffc0202ccc:	8522                	mv	a0,s0
ffffffffc0202cce:	00094917          	auipc	s2,0x94
ffffffffc0202cd2:	bd290913          	addi	s2,s2,-1070 # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0202cd6:	fb4ff0ef          	jal	ffffffffc020248a <boot_map_segment>
ffffffffc0202cda:	00893023          	sd	s0,0(s2)
ffffffffc0202cde:	2d546ce3          	bltu	s0,s5,ffffffffc02037b6 <pmm_init+0xc96>
ffffffffc0202ce2:	0009b783          	ld	a5,0(s3)
ffffffffc0202ce6:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202ce8:	8c1d                	sub	s0,s0,a5
ffffffffc0202cea:	00c45793          	srli	a5,s0,0xc
ffffffffc0202cee:	00094717          	auipc	a4,0x94
ffffffffc0202cf2:	ba873523          	sd	s0,-1110(a4) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0202cf6:	0147e7b3          	or	a5,a5,s4
ffffffffc0202cfa:	18079073          	csrw	satp,a5
ffffffffc0202cfe:	12000073          	sfence.vma
ffffffffc0202d02:	0000a517          	auipc	a0,0xa
ffffffffc0202d06:	bb650513          	addi	a0,a0,-1098 # ffffffffc020c8b8 <etext+0x10f4>
ffffffffc0202d0a:	c9cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202d0e:	0000e717          	auipc	a4,0xe
ffffffffc0202d12:	2f270713          	addi	a4,a4,754 # ffffffffc0211000 <bootstack>
ffffffffc0202d16:	0000e797          	auipc	a5,0xe
ffffffffc0202d1a:	2ea78793          	addi	a5,a5,746 # ffffffffc0211000 <bootstack>
ffffffffc0202d1e:	48f70163          	beq	a4,a5,ffffffffc02031a0 <pmm_init+0x680>
ffffffffc0202d22:	100027f3          	csrr	a5,sstatus
ffffffffc0202d26:	8b89                	andi	a5,a5,2
ffffffffc0202d28:	52079163          	bnez	a5,ffffffffc020324a <pmm_init+0x72a>
ffffffffc0202d2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d30:	779c                	ld	a5,40(a5)
ffffffffc0202d32:	9782                	jalr	a5
ffffffffc0202d34:	842a                	mv	s0,a0
ffffffffc0202d36:	6098                	ld	a4,0(s1)
ffffffffc0202d38:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d3c:	83b1                	srli	a5,a5,0xc
ffffffffc0202d3e:	30e7e1e3          	bltu	a5,a4,ffffffffc0203840 <pmm_init+0xd20>
ffffffffc0202d42:	00093503          	ld	a0,0(s2)
ffffffffc0202d46:	2c050de3          	beqz	a0,ffffffffc0203820 <pmm_init+0xd00>
ffffffffc0202d4a:	03451793          	slli	a5,a0,0x34
ffffffffc0202d4e:	2c0799e3          	bnez	a5,ffffffffc0203820 <pmm_init+0xd00>
ffffffffc0202d52:	4601                	li	a2,0
ffffffffc0202d54:	4581                	li	a1,0
ffffffffc0202d56:	ffcff0ef          	jal	ffffffffc0202552 <get_page>
ffffffffc0202d5a:	2a0513e3          	bnez	a0,ffffffffc0203800 <pmm_init+0xce0>
ffffffffc0202d5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d62:	8b89                	andi	a5,a5,2
ffffffffc0202d64:	4c079863          	bnez	a5,ffffffffc0203234 <pmm_init+0x714>
ffffffffc0202d68:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6c:	4505                	li	a0,1
ffffffffc0202d6e:	6f9c                	ld	a5,24(a5)
ffffffffc0202d70:	9782                	jalr	a5
ffffffffc0202d72:	8a2a                	mv	s4,a0
ffffffffc0202d74:	00093503          	ld	a0,0(s2)
ffffffffc0202d78:	4681                	li	a3,0
ffffffffc0202d7a:	4601                	li	a2,0
ffffffffc0202d7c:	85d2                	mv	a1,s4
ffffffffc0202d7e:	cadff0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc0202d82:	32051be3          	bnez	a0,ffffffffc02038b8 <pmm_init+0xd98>
ffffffffc0202d86:	00093503          	ld	a0,0(s2)
ffffffffc0202d8a:	4601                	li	a2,0
ffffffffc0202d8c:	4581                	li	a1,0
ffffffffc0202d8e:	c9eff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202d92:	300503e3          	beqz	a0,ffffffffc0203898 <pmm_init+0xd78>
ffffffffc0202d96:	611c                	ld	a5,0(a0)
ffffffffc0202d98:	0017f713          	andi	a4,a5,1
ffffffffc0202d9c:	2e0702e3          	beqz	a4,ffffffffc0203880 <pmm_init+0xd60>
ffffffffc0202da0:	6090                	ld	a2,0(s1)
ffffffffc0202da2:	078a                	slli	a5,a5,0x2
ffffffffc0202da4:	83b1                	srli	a5,a5,0xc
ffffffffc0202da6:	62c7fb63          	bgeu	a5,a2,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0202daa:	000bb703          	ld	a4,0(s7)
ffffffffc0202dae:	079a                	slli	a5,a5,0x6
ffffffffc0202db0:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202db4:	97b6                	add	a5,a5,a3
ffffffffc0202db6:	97ba                	add	a5,a5,a4
ffffffffc0202db8:	64fa1463          	bne	s4,a5,ffffffffc0203400 <pmm_init+0x8e0>
ffffffffc0202dbc:	000a2703          	lw	a4,0(s4) # 200000 <_binary_bin_sfs_img_size+0x18ad00>
ffffffffc0202dc0:	4785                	li	a5,1
ffffffffc0202dc2:	78f71863          	bne	a4,a5,ffffffffc0203552 <pmm_init+0xa32>
ffffffffc0202dc6:	00093503          	ld	a0,0(s2)
ffffffffc0202dca:	77fd                	lui	a5,0xfffff
ffffffffc0202dcc:	6114                	ld	a3,0(a0)
ffffffffc0202dce:	068a                	slli	a3,a3,0x2
ffffffffc0202dd0:	8efd                	and	a3,a3,a5
ffffffffc0202dd2:	00c6d713          	srli	a4,a3,0xc
ffffffffc0202dd6:	76c77263          	bgeu	a4,a2,ffffffffc020353a <pmm_init+0xa1a>
ffffffffc0202dda:	0009bc03          	ld	s8,0(s3)
ffffffffc0202dde:	96e2                	add	a3,a3,s8
ffffffffc0202de0:	0006ba83          	ld	s5,0(a3) # fffffffffe000000 <end+0x3dd696f0>
ffffffffc0202de4:	0a8a                	slli	s5,s5,0x2
ffffffffc0202de6:	00fafab3          	and	s5,s5,a5
ffffffffc0202dea:	00cad793          	srli	a5,s5,0xc
ffffffffc0202dee:	72c7f963          	bgeu	a5,a2,ffffffffc0203520 <pmm_init+0xa00>
ffffffffc0202df2:	4601                	li	a2,0
ffffffffc0202df4:	6585                	lui	a1,0x1
ffffffffc0202df6:	9c56                	add	s8,s8,s5
ffffffffc0202df8:	c34ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202dfc:	0c21                	addi	s8,s8,8
ffffffffc0202dfe:	6d851163          	bne	a0,s8,ffffffffc02034c0 <pmm_init+0x9a0>
ffffffffc0202e02:	100027f3          	csrr	a5,sstatus
ffffffffc0202e06:	8b89                	andi	a5,a5,2
ffffffffc0202e08:	48079e63          	bnez	a5,ffffffffc02032a4 <pmm_init+0x784>
ffffffffc0202e0c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e10:	4505                	li	a0,1
ffffffffc0202e12:	6f9c                	ld	a5,24(a5)
ffffffffc0202e14:	9782                	jalr	a5
ffffffffc0202e16:	8c2a                	mv	s8,a0
ffffffffc0202e18:	00093503          	ld	a0,0(s2)
ffffffffc0202e1c:	46d1                	li	a3,20
ffffffffc0202e1e:	6605                	lui	a2,0x1
ffffffffc0202e20:	85e2                	mv	a1,s8
ffffffffc0202e22:	c09ff0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc0202e26:	6c051d63          	bnez	a0,ffffffffc0203500 <pmm_init+0x9e0>
ffffffffc0202e2a:	00093503          	ld	a0,0(s2)
ffffffffc0202e2e:	4601                	li	a2,0
ffffffffc0202e30:	6585                	lui	a1,0x1
ffffffffc0202e32:	bfaff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202e36:	6a050563          	beqz	a0,ffffffffc02034e0 <pmm_init+0x9c0>
ffffffffc0202e3a:	611c                	ld	a5,0(a0)
ffffffffc0202e3c:	0107f713          	andi	a4,a5,16
ffffffffc0202e40:	5a070063          	beqz	a4,ffffffffc02033e0 <pmm_init+0x8c0>
ffffffffc0202e44:	8b91                	andi	a5,a5,4
ffffffffc0202e46:	60078d63          	beqz	a5,ffffffffc0203460 <pmm_init+0x940>
ffffffffc0202e4a:	00093503          	ld	a0,0(s2)
ffffffffc0202e4e:	611c                	ld	a5,0(a0)
ffffffffc0202e50:	8bc1                	andi	a5,a5,16
ffffffffc0202e52:	5e078763          	beqz	a5,ffffffffc0203440 <pmm_init+0x920>
ffffffffc0202e56:	000c2703          	lw	a4,0(s8)
ffffffffc0202e5a:	4785                	li	a5,1
ffffffffc0202e5c:	64f71263          	bne	a4,a5,ffffffffc02034a0 <pmm_init+0x980>
ffffffffc0202e60:	4681                	li	a3,0
ffffffffc0202e62:	6605                	lui	a2,0x1
ffffffffc0202e64:	85d2                	mv	a1,s4
ffffffffc0202e66:	bc5ff0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc0202e6a:	60051b63          	bnez	a0,ffffffffc0203480 <pmm_init+0x960>
ffffffffc0202e6e:	000a2703          	lw	a4,0(s4)
ffffffffc0202e72:	4789                	li	a5,2
ffffffffc0202e74:	28f71fe3          	bne	a4,a5,ffffffffc0203912 <pmm_init+0xdf2>
ffffffffc0202e78:	000c2783          	lw	a5,0(s8)
ffffffffc0202e7c:	26079be3          	bnez	a5,ffffffffc02038f2 <pmm_init+0xdd2>
ffffffffc0202e80:	00093503          	ld	a0,0(s2)
ffffffffc0202e84:	4601                	li	a2,0
ffffffffc0202e86:	6585                	lui	a1,0x1
ffffffffc0202e88:	ba4ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202e8c:	58050a63          	beqz	a0,ffffffffc0203420 <pmm_init+0x900>
ffffffffc0202e90:	6118                	ld	a4,0(a0)
ffffffffc0202e92:	00177793          	andi	a5,a4,1
ffffffffc0202e96:	1e0785e3          	beqz	a5,ffffffffc0203880 <pmm_init+0xd60>
ffffffffc0202e9a:	6094                	ld	a3,0(s1)
ffffffffc0202e9c:	00271793          	slli	a5,a4,0x2
ffffffffc0202ea0:	83b1                	srli	a5,a5,0xc
ffffffffc0202ea2:	52d7fd63          	bgeu	a5,a3,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0202ea6:	000bb683          	ld	a3,0(s7)
ffffffffc0202eaa:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202eae:	97d6                	add	a5,a5,s5
ffffffffc0202eb0:	079a                	slli	a5,a5,0x6
ffffffffc0202eb2:	97b6                	add	a5,a5,a3
ffffffffc0202eb4:	0afa19e3          	bne	s4,a5,ffffffffc0203766 <pmm_init+0xc46>
ffffffffc0202eb8:	8b41                	andi	a4,a4,16
ffffffffc0202eba:	080716e3          	bnez	a4,ffffffffc0203746 <pmm_init+0xc26>
ffffffffc0202ebe:	00093503          	ld	a0,0(s2)
ffffffffc0202ec2:	4581                	li	a1,0
ffffffffc0202ec4:	acbff0ef          	jal	ffffffffc020298e <page_remove>
ffffffffc0202ec8:	000a2c83          	lw	s9,0(s4)
ffffffffc0202ecc:	4785                	li	a5,1
ffffffffc0202ece:	04fc9ce3          	bne	s9,a5,ffffffffc0203726 <pmm_init+0xc06>
ffffffffc0202ed2:	000c2783          	lw	a5,0(s8)
ffffffffc0202ed6:	020798e3          	bnez	a5,ffffffffc0203706 <pmm_init+0xbe6>
ffffffffc0202eda:	00093503          	ld	a0,0(s2)
ffffffffc0202ede:	6585                	lui	a1,0x1
ffffffffc0202ee0:	aafff0ef          	jal	ffffffffc020298e <page_remove>
ffffffffc0202ee4:	000a2783          	lw	a5,0(s4)
ffffffffc0202ee8:	7e079f63          	bnez	a5,ffffffffc02036e6 <pmm_init+0xbc6>
ffffffffc0202eec:	000c2783          	lw	a5,0(s8)
ffffffffc0202ef0:	7c079b63          	bnez	a5,ffffffffc02036c6 <pmm_init+0xba6>
ffffffffc0202ef4:	00093a03          	ld	s4,0(s2)
ffffffffc0202ef8:	6098                	ld	a4,0(s1)
ffffffffc0202efa:	000a3783          	ld	a5,0(s4)
ffffffffc0202efe:	078a                	slli	a5,a5,0x2
ffffffffc0202f00:	83b1                	srli	a5,a5,0xc
ffffffffc0202f02:	4ce7fd63          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0202f06:	000bb503          	ld	a0,0(s7)
ffffffffc0202f0a:	97d6                	add	a5,a5,s5
ffffffffc0202f0c:	079a                	slli	a5,a5,0x6
ffffffffc0202f0e:	00f506b3          	add	a3,a0,a5
ffffffffc0202f12:	4294                	lw	a3,0(a3)
ffffffffc0202f14:	79969963          	bne	a3,s9,ffffffffc02036a6 <pmm_init+0xb86>
ffffffffc0202f18:	8799                	srai	a5,a5,0x6
ffffffffc0202f1a:	00080637          	lui	a2,0x80
ffffffffc0202f1e:	97b2                	add	a5,a5,a2
ffffffffc0202f20:	00c79693          	slli	a3,a5,0xc
ffffffffc0202f24:	06e7fde3          	bgeu	a5,a4,ffffffffc020379e <pmm_init+0xc7e>
ffffffffc0202f28:	0009b783          	ld	a5,0(s3)
ffffffffc0202f2c:	97b6                	add	a5,a5,a3
ffffffffc0202f2e:	639c                	ld	a5,0(a5)
ffffffffc0202f30:	078a                	slli	a5,a5,0x2
ffffffffc0202f32:	83b1                	srli	a5,a5,0xc
ffffffffc0202f34:	4ae7f463          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0202f38:	8f91                	sub	a5,a5,a2
ffffffffc0202f3a:	079a                	slli	a5,a5,0x6
ffffffffc0202f3c:	953e                	add	a0,a0,a5
ffffffffc0202f3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f42:	8b89                	andi	a5,a5,2
ffffffffc0202f44:	3a079b63          	bnez	a5,ffffffffc02032fa <pmm_init+0x7da>
ffffffffc0202f48:	000b3783          	ld	a5,0(s6)
ffffffffc0202f4c:	4585                	li	a1,1
ffffffffc0202f4e:	739c                	ld	a5,32(a5)
ffffffffc0202f50:	9782                	jalr	a5
ffffffffc0202f52:	000a3783          	ld	a5,0(s4)
ffffffffc0202f56:	6098                	ld	a4,0(s1)
ffffffffc0202f58:	078a                	slli	a5,a5,0x2
ffffffffc0202f5a:	83b1                	srli	a5,a5,0xc
ffffffffc0202f5c:	48e7f063          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0202f60:	000bb503          	ld	a0,0(s7)
ffffffffc0202f64:	fe000737          	lui	a4,0xfe000
ffffffffc0202f68:	079a                	slli	a5,a5,0x6
ffffffffc0202f6a:	97ba                	add	a5,a5,a4
ffffffffc0202f6c:	953e                	add	a0,a0,a5
ffffffffc0202f6e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f72:	8b89                	andi	a5,a5,2
ffffffffc0202f74:	36079763          	bnez	a5,ffffffffc02032e2 <pmm_init+0x7c2>
ffffffffc0202f78:	000b3783          	ld	a5,0(s6)
ffffffffc0202f7c:	4585                	li	a1,1
ffffffffc0202f7e:	739c                	ld	a5,32(a5)
ffffffffc0202f80:	9782                	jalr	a5
ffffffffc0202f82:	00093783          	ld	a5,0(s2)
ffffffffc0202f86:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202f8a:	12000073          	sfence.vma
ffffffffc0202f8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202f92:	8b89                	andi	a5,a5,2
ffffffffc0202f94:	32079d63          	bnez	a5,ffffffffc02032ce <pmm_init+0x7ae>
ffffffffc0202f98:	000b3783          	ld	a5,0(s6)
ffffffffc0202f9c:	779c                	ld	a5,40(a5)
ffffffffc0202f9e:	9782                	jalr	a5
ffffffffc0202fa0:	8a2a                	mv	s4,a0
ffffffffc0202fa2:	6f441263          	bne	s0,s4,ffffffffc0203686 <pmm_init+0xb66>
ffffffffc0202fa6:	0000a517          	auipc	a0,0xa
ffffffffc0202faa:	c9250513          	addi	a0,a0,-878 # ffffffffc020cc38 <etext+0x1474>
ffffffffc0202fae:	9f8fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202fb2:	100027f3          	csrr	a5,sstatus
ffffffffc0202fb6:	8b89                	andi	a5,a5,2
ffffffffc0202fb8:	30079163          	bnez	a5,ffffffffc02032ba <pmm_init+0x79a>
ffffffffc0202fbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202fc0:	779c                	ld	a5,40(a5)
ffffffffc0202fc2:	9782                	jalr	a5
ffffffffc0202fc4:	8c2a                	mv	s8,a0
ffffffffc0202fc6:	609c                	ld	a5,0(s1)
ffffffffc0202fc8:	c0200437          	lui	s0,0xc0200
ffffffffc0202fcc:	7a7d                	lui	s4,0xfffff
ffffffffc0202fce:	00c79713          	slli	a4,a5,0xc
ffffffffc0202fd2:	6a85                	lui	s5,0x1
ffffffffc0202fd4:	02e47c63          	bgeu	s0,a4,ffffffffc020300c <pmm_init+0x4ec>
ffffffffc0202fd8:	00c45713          	srli	a4,s0,0xc
ffffffffc0202fdc:	3af77363          	bgeu	a4,a5,ffffffffc0203382 <pmm_init+0x862>
ffffffffc0202fe0:	0009b583          	ld	a1,0(s3)
ffffffffc0202fe4:	00093503          	ld	a0,0(s2)
ffffffffc0202fe8:	4601                	li	a2,0
ffffffffc0202fea:	95a2                	add	a1,a1,s0
ffffffffc0202fec:	a40ff0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc0202ff0:	3c050663          	beqz	a0,ffffffffc02033bc <pmm_init+0x89c>
ffffffffc0202ff4:	611c                	ld	a5,0(a0)
ffffffffc0202ff6:	078a                	slli	a5,a5,0x2
ffffffffc0202ff8:	0147f7b3          	and	a5,a5,s4
ffffffffc0202ffc:	3a879063          	bne	a5,s0,ffffffffc020339c <pmm_init+0x87c>
ffffffffc0203000:	609c                	ld	a5,0(s1)
ffffffffc0203002:	9456                	add	s0,s0,s5
ffffffffc0203004:	00c79713          	slli	a4,a5,0xc
ffffffffc0203008:	fce468e3          	bltu	s0,a4,ffffffffc0202fd8 <pmm_init+0x4b8>
ffffffffc020300c:	00093783          	ld	a5,0(s2)
ffffffffc0203010:	639c                	ld	a5,0(a5)
ffffffffc0203012:	5c079a63          	bnez	a5,ffffffffc02035e6 <pmm_init+0xac6>
ffffffffc0203016:	100027f3          	csrr	a5,sstatus
ffffffffc020301a:	8b89                	andi	a5,a5,2
ffffffffc020301c:	30079663          	bnez	a5,ffffffffc0203328 <pmm_init+0x808>
ffffffffc0203020:	000b3783          	ld	a5,0(s6)
ffffffffc0203024:	4505                	li	a0,1
ffffffffc0203026:	6f9c                	ld	a5,24(a5)
ffffffffc0203028:	9782                	jalr	a5
ffffffffc020302a:	842a                	mv	s0,a0
ffffffffc020302c:	00093503          	ld	a0,0(s2)
ffffffffc0203030:	4699                	li	a3,6
ffffffffc0203032:	10000613          	li	a2,256
ffffffffc0203036:	85a2                	mv	a1,s0
ffffffffc0203038:	9f3ff0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc020303c:	5e051563          	bnez	a0,ffffffffc0203626 <pmm_init+0xb06>
ffffffffc0203040:	4018                	lw	a4,0(s0)
ffffffffc0203042:	4785                	li	a5,1
ffffffffc0203044:	62f71163          	bne	a4,a5,ffffffffc0203666 <pmm_init+0xb46>
ffffffffc0203048:	00093503          	ld	a0,0(s2)
ffffffffc020304c:	6605                	lui	a2,0x1
ffffffffc020304e:	10060613          	addi	a2,a2,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0203052:	4699                	li	a3,6
ffffffffc0203054:	85a2                	mv	a1,s0
ffffffffc0203056:	9d5ff0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc020305a:	5e051663          	bnez	a0,ffffffffc0203646 <pmm_init+0xb26>
ffffffffc020305e:	4018                	lw	a4,0(s0)
ffffffffc0203060:	4789                	li	a5,2
ffffffffc0203062:	54f71263          	bne	a4,a5,ffffffffc02035a6 <pmm_init+0xa86>
ffffffffc0203066:	0000a597          	auipc	a1,0xa
ffffffffc020306a:	d1a58593          	addi	a1,a1,-742 # ffffffffc020cd80 <etext+0x15bc>
ffffffffc020306e:	10000513          	li	a0,256
ffffffffc0203072:	66a080ef          	jal	ffffffffc020b6dc <strcpy>
ffffffffc0203076:	6585                	lui	a1,0x1
ffffffffc0203078:	10058593          	addi	a1,a1,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020307c:	10000513          	li	a0,256
ffffffffc0203080:	66e080ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc0203084:	7c051e63          	bnez	a0,ffffffffc0203860 <pmm_init+0xd40>
ffffffffc0203088:	000bb683          	ld	a3,0(s7)
ffffffffc020308c:	000807b7          	lui	a5,0x80
ffffffffc0203090:	6098                	ld	a4,0(s1)
ffffffffc0203092:	40d406b3          	sub	a3,s0,a3
ffffffffc0203096:	8699                	srai	a3,a3,0x6
ffffffffc0203098:	96be                	add	a3,a3,a5
ffffffffc020309a:	00c69793          	slli	a5,a3,0xc
ffffffffc020309e:	83b1                	srli	a5,a5,0xc
ffffffffc02030a0:	06b2                	slli	a3,a3,0xc
ffffffffc02030a2:	6ee7fe63          	bgeu	a5,a4,ffffffffc020379e <pmm_init+0xc7e>
ffffffffc02030a6:	0009b783          	ld	a5,0(s3)
ffffffffc02030aa:	10000513          	li	a0,256
ffffffffc02030ae:	97b6                	add	a5,a5,a3
ffffffffc02030b0:	10078023          	sb	zero,256(a5) # 80100 <_binary_bin_sfs_img_size+0xae00>
ffffffffc02030b4:	5f4080ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc02030b8:	54051763          	bnez	a0,ffffffffc0203606 <pmm_init+0xae6>
ffffffffc02030bc:	00093a03          	ld	s4,0(s2)
ffffffffc02030c0:	6098                	ld	a4,0(s1)
ffffffffc02030c2:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc02030c6:	078a                	slli	a5,a5,0x2
ffffffffc02030c8:	83b1                	srli	a5,a5,0xc
ffffffffc02030ca:	30e7f963          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc02030ce:	00c79693          	slli	a3,a5,0xc
ffffffffc02030d2:	6ce7f663          	bgeu	a5,a4,ffffffffc020379e <pmm_init+0xc7e>
ffffffffc02030d6:	0009b783          	ld	a5,0(s3)
ffffffffc02030da:	00f689b3          	add	s3,a3,a5
ffffffffc02030de:	100027f3          	csrr	a5,sstatus
ffffffffc02030e2:	8b89                	andi	a5,a5,2
ffffffffc02030e4:	22079763          	bnez	a5,ffffffffc0203312 <pmm_init+0x7f2>
ffffffffc02030e8:	000b3783          	ld	a5,0(s6)
ffffffffc02030ec:	8522                	mv	a0,s0
ffffffffc02030ee:	4585                	li	a1,1
ffffffffc02030f0:	739c                	ld	a5,32(a5)
ffffffffc02030f2:	9782                	jalr	a5
ffffffffc02030f4:	0009b783          	ld	a5,0(s3)
ffffffffc02030f8:	6098                	ld	a4,0(s1)
ffffffffc02030fa:	078a                	slli	a5,a5,0x2
ffffffffc02030fc:	83b1                	srli	a5,a5,0xc
ffffffffc02030fe:	2ce7ff63          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0203102:	000bb503          	ld	a0,0(s7)
ffffffffc0203106:	fe000737          	lui	a4,0xfe000
ffffffffc020310a:	079a                	slli	a5,a5,0x6
ffffffffc020310c:	97ba                	add	a5,a5,a4
ffffffffc020310e:	953e                	add	a0,a0,a5
ffffffffc0203110:	100027f3          	csrr	a5,sstatus
ffffffffc0203114:	8b89                	andi	a5,a5,2
ffffffffc0203116:	24079a63          	bnez	a5,ffffffffc020336a <pmm_init+0x84a>
ffffffffc020311a:	000b3783          	ld	a5,0(s6)
ffffffffc020311e:	4585                	li	a1,1
ffffffffc0203120:	739c                	ld	a5,32(a5)
ffffffffc0203122:	9782                	jalr	a5
ffffffffc0203124:	000a3783          	ld	a5,0(s4)
ffffffffc0203128:	6098                	ld	a4,0(s1)
ffffffffc020312a:	078a                	slli	a5,a5,0x2
ffffffffc020312c:	83b1                	srli	a5,a5,0xc
ffffffffc020312e:	2ae7f763          	bgeu	a5,a4,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0203132:	000bb503          	ld	a0,0(s7)
ffffffffc0203136:	fe000737          	lui	a4,0xfe000
ffffffffc020313a:	079a                	slli	a5,a5,0x6
ffffffffc020313c:	97ba                	add	a5,a5,a4
ffffffffc020313e:	953e                	add	a0,a0,a5
ffffffffc0203140:	100027f3          	csrr	a5,sstatus
ffffffffc0203144:	8b89                	andi	a5,a5,2
ffffffffc0203146:	20079663          	bnez	a5,ffffffffc0203352 <pmm_init+0x832>
ffffffffc020314a:	000b3783          	ld	a5,0(s6)
ffffffffc020314e:	4585                	li	a1,1
ffffffffc0203150:	739c                	ld	a5,32(a5)
ffffffffc0203152:	9782                	jalr	a5
ffffffffc0203154:	00093783          	ld	a5,0(s2)
ffffffffc0203158:	0007b023          	sd	zero,0(a5)
ffffffffc020315c:	12000073          	sfence.vma
ffffffffc0203160:	100027f3          	csrr	a5,sstatus
ffffffffc0203164:	8b89                	andi	a5,a5,2
ffffffffc0203166:	1c079c63          	bnez	a5,ffffffffc020333e <pmm_init+0x81e>
ffffffffc020316a:	000b3783          	ld	a5,0(s6)
ffffffffc020316e:	779c                	ld	a5,40(a5)
ffffffffc0203170:	9782                	jalr	a5
ffffffffc0203172:	842a                	mv	s0,a0
ffffffffc0203174:	448c1963          	bne	s8,s0,ffffffffc02035c6 <pmm_init+0xaa6>
ffffffffc0203178:	0000a517          	auipc	a0,0xa
ffffffffc020317c:	c8050513          	addi	a0,a0,-896 # ffffffffc020cdf8 <etext+0x1634>
ffffffffc0203180:	826fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0203184:	7406                	ld	s0,96(sp)
ffffffffc0203186:	70a6                	ld	ra,104(sp)
ffffffffc0203188:	64e6                	ld	s1,88(sp)
ffffffffc020318a:	6946                	ld	s2,80(sp)
ffffffffc020318c:	69a6                	ld	s3,72(sp)
ffffffffc020318e:	6a06                	ld	s4,64(sp)
ffffffffc0203190:	7ae2                	ld	s5,56(sp)
ffffffffc0203192:	7b42                	ld	s6,48(sp)
ffffffffc0203194:	7ba2                	ld	s7,40(sp)
ffffffffc0203196:	7c02                	ld	s8,32(sp)
ffffffffc0203198:	6ce2                	ld	s9,24(sp)
ffffffffc020319a:	6165                	addi	sp,sp,112
ffffffffc020319c:	e01fe06f          	j	ffffffffc0201f9c <kmalloc_init>
ffffffffc02031a0:	00010797          	auipc	a5,0x10
ffffffffc02031a4:	e6078793          	addi	a5,a5,-416 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02031a8:	00010717          	auipc	a4,0x10
ffffffffc02031ac:	e5870713          	addi	a4,a4,-424 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02031b0:	b6f719e3          	bne	a4,a5,ffffffffc0202d22 <pmm_init+0x202>
ffffffffc02031b4:	6605                	lui	a2,0x1
ffffffffc02031b6:	4581                	li	a1,0
ffffffffc02031b8:	853a                	mv	a0,a4
ffffffffc02031ba:	5a2080ef          	jal	ffffffffc020b75c <memset>
ffffffffc02031be:	0000e797          	auipc	a5,0xe
ffffffffc02031c2:	e40780a3          	sb	zero,-447(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc02031c6:	0000d797          	auipc	a5,0xd
ffffffffc02031ca:	e2078d23          	sb	zero,-454(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc02031ce:	0000d797          	auipc	a5,0xd
ffffffffc02031d2:	e3278793          	addi	a5,a5,-462 # ffffffffc0210000 <bootstackguard>
ffffffffc02031d6:	3b57eb63          	bltu	a5,s5,ffffffffc020358c <pmm_init+0xa6c>
ffffffffc02031da:	0009b683          	ld	a3,0(s3)
ffffffffc02031de:	00093503          	ld	a0,0(s2)
ffffffffc02031e2:	0000d597          	auipc	a1,0xd
ffffffffc02031e6:	e1e58593          	addi	a1,a1,-482 # ffffffffc0210000 <bootstackguard>
ffffffffc02031ea:	40d586b3          	sub	a3,a1,a3
ffffffffc02031ee:	4701                	li	a4,0
ffffffffc02031f0:	6605                	lui	a2,0x1
ffffffffc02031f2:	a98ff0ef          	jal	ffffffffc020248a <boot_map_segment>
ffffffffc02031f6:	00010797          	auipc	a5,0x10
ffffffffc02031fa:	e0a78793          	addi	a5,a5,-502 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02031fe:	3757ea63          	bltu	a5,s5,ffffffffc0203572 <pmm_init+0xa52>
ffffffffc0203202:	0009b683          	ld	a3,0(s3)
ffffffffc0203206:	00093503          	ld	a0,0(s2)
ffffffffc020320a:	00010597          	auipc	a1,0x10
ffffffffc020320e:	df658593          	addi	a1,a1,-522 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0203212:	40d586b3          	sub	a3,a1,a3
ffffffffc0203216:	4701                	li	a4,0
ffffffffc0203218:	6605                	lui	a2,0x1
ffffffffc020321a:	a70ff0ef          	jal	ffffffffc020248a <boot_map_segment>
ffffffffc020321e:	12000073          	sfence.vma
ffffffffc0203222:	00009517          	auipc	a0,0x9
ffffffffc0203226:	6be50513          	addi	a0,a0,1726 # ffffffffc020c8e0 <etext+0x111c>
ffffffffc020322a:	f7dfc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020322e:	bcd5                	j	ffffffffc0202d22 <pmm_init+0x202>
ffffffffc0203230:	853e                	mv	a0,a5
ffffffffc0203232:	babd                	j	ffffffffc0202bb0 <pmm_init+0x90>
ffffffffc0203234:	9a5fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203238:	000b3783          	ld	a5,0(s6)
ffffffffc020323c:	4505                	li	a0,1
ffffffffc020323e:	6f9c                	ld	a5,24(a5)
ffffffffc0203240:	9782                	jalr	a5
ffffffffc0203242:	8a2a                	mv	s4,a0
ffffffffc0203244:	98ffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203248:	b635                	j	ffffffffc0202d74 <pmm_init+0x254>
ffffffffc020324a:	98ffd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020324e:	000b3783          	ld	a5,0(s6)
ffffffffc0203252:	779c                	ld	a5,40(a5)
ffffffffc0203254:	9782                	jalr	a5
ffffffffc0203256:	842a                	mv	s0,a0
ffffffffc0203258:	97bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020325c:	bce9                	j	ffffffffc0202d36 <pmm_init+0x216>
ffffffffc020325e:	97bfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203262:	000b3783          	ld	a5,0(s6)
ffffffffc0203266:	4505                	li	a0,1
ffffffffc0203268:	6f9c                	ld	a5,24(a5)
ffffffffc020326a:	9782                	jalr	a5
ffffffffc020326c:	842a                	mv	s0,a0
ffffffffc020326e:	965fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203272:	b2cd                	j	ffffffffc0202c54 <pmm_init+0x134>
ffffffffc0203274:	6705                	lui	a4,0x1
ffffffffc0203276:	177d                	addi	a4,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203278:	96ba                	add	a3,a3,a4
ffffffffc020327a:	8ff5                	and	a5,a5,a3
ffffffffc020327c:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203280:	14a77e63          	bgeu	a4,a0,ffffffffc02033dc <pmm_init+0x8bc>
ffffffffc0203284:	000b3683          	ld	a3,0(s6)
ffffffffc0203288:	8c1d                	sub	s0,s0,a5
ffffffffc020328a:	071a                	slli	a4,a4,0x6
ffffffffc020328c:	fe0007b7          	lui	a5,0xfe000
ffffffffc0203290:	973e                	add	a4,a4,a5
ffffffffc0203292:	6a9c                	ld	a5,16(a3)
ffffffffc0203294:	00c45593          	srli	a1,s0,0xc
ffffffffc0203298:	00e60533          	add	a0,a2,a4
ffffffffc020329c:	9782                	jalr	a5
ffffffffc020329e:	0009b583          	ld	a1,0(s3)
ffffffffc02032a2:	bab5                	j	ffffffffc0202c1e <pmm_init+0xfe>
ffffffffc02032a4:	935fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032a8:	000b3783          	ld	a5,0(s6)
ffffffffc02032ac:	4505                	li	a0,1
ffffffffc02032ae:	6f9c                	ld	a5,24(a5)
ffffffffc02032b0:	9782                	jalr	a5
ffffffffc02032b2:	8c2a                	mv	s8,a0
ffffffffc02032b4:	91ffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032b8:	b685                	j	ffffffffc0202e18 <pmm_init+0x2f8>
ffffffffc02032ba:	91ffd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032be:	000b3783          	ld	a5,0(s6)
ffffffffc02032c2:	779c                	ld	a5,40(a5)
ffffffffc02032c4:	9782                	jalr	a5
ffffffffc02032c6:	8c2a                	mv	s8,a0
ffffffffc02032c8:	90bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032cc:	b9ed                	j	ffffffffc0202fc6 <pmm_init+0x4a6>
ffffffffc02032ce:	90bfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032d2:	000b3783          	ld	a5,0(s6)
ffffffffc02032d6:	779c                	ld	a5,40(a5)
ffffffffc02032d8:	9782                	jalr	a5
ffffffffc02032da:	8a2a                	mv	s4,a0
ffffffffc02032dc:	8f7fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032e0:	b1c9                	j	ffffffffc0202fa2 <pmm_init+0x482>
ffffffffc02032e2:	e42a                	sd	a0,8(sp)
ffffffffc02032e4:	8f5fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032e8:	000b3783          	ld	a5,0(s6)
ffffffffc02032ec:	6522                	ld	a0,8(sp)
ffffffffc02032ee:	4585                	li	a1,1
ffffffffc02032f0:	739c                	ld	a5,32(a5)
ffffffffc02032f2:	9782                	jalr	a5
ffffffffc02032f4:	8dffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032f8:	b169                	j	ffffffffc0202f82 <pmm_init+0x462>
ffffffffc02032fa:	e42a                	sd	a0,8(sp)
ffffffffc02032fc:	8ddfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203300:	000b3783          	ld	a5,0(s6)
ffffffffc0203304:	6522                	ld	a0,8(sp)
ffffffffc0203306:	4585                	li	a1,1
ffffffffc0203308:	739c                	ld	a5,32(a5)
ffffffffc020330a:	9782                	jalr	a5
ffffffffc020330c:	8c7fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203310:	b189                	j	ffffffffc0202f52 <pmm_init+0x432>
ffffffffc0203312:	8c7fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203316:	000b3783          	ld	a5,0(s6)
ffffffffc020331a:	8522                	mv	a0,s0
ffffffffc020331c:	4585                	li	a1,1
ffffffffc020331e:	739c                	ld	a5,32(a5)
ffffffffc0203320:	9782                	jalr	a5
ffffffffc0203322:	8b1fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203326:	b3f9                	j	ffffffffc02030f4 <pmm_init+0x5d4>
ffffffffc0203328:	8b1fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020332c:	000b3783          	ld	a5,0(s6)
ffffffffc0203330:	4505                	li	a0,1
ffffffffc0203332:	6f9c                	ld	a5,24(a5)
ffffffffc0203334:	9782                	jalr	a5
ffffffffc0203336:	842a                	mv	s0,a0
ffffffffc0203338:	89bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020333c:	b9c5                	j	ffffffffc020302c <pmm_init+0x50c>
ffffffffc020333e:	89bfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203342:	000b3783          	ld	a5,0(s6)
ffffffffc0203346:	779c                	ld	a5,40(a5)
ffffffffc0203348:	9782                	jalr	a5
ffffffffc020334a:	842a                	mv	s0,a0
ffffffffc020334c:	887fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203350:	b515                	j	ffffffffc0203174 <pmm_init+0x654>
ffffffffc0203352:	e42a                	sd	a0,8(sp)
ffffffffc0203354:	885fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203358:	000b3783          	ld	a5,0(s6)
ffffffffc020335c:	6522                	ld	a0,8(sp)
ffffffffc020335e:	4585                	li	a1,1
ffffffffc0203360:	739c                	ld	a5,32(a5)
ffffffffc0203362:	9782                	jalr	a5
ffffffffc0203364:	86ffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203368:	b3f5                	j	ffffffffc0203154 <pmm_init+0x634>
ffffffffc020336a:	e42a                	sd	a0,8(sp)
ffffffffc020336c:	86dfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203370:	000b3783          	ld	a5,0(s6)
ffffffffc0203374:	6522                	ld	a0,8(sp)
ffffffffc0203376:	4585                	li	a1,1
ffffffffc0203378:	739c                	ld	a5,32(a5)
ffffffffc020337a:	9782                	jalr	a5
ffffffffc020337c:	857fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203380:	b355                	j	ffffffffc0203124 <pmm_init+0x604>
ffffffffc0203382:	86a2                	mv	a3,s0
ffffffffc0203384:	00009617          	auipc	a2,0x9
ffffffffc0203388:	2f460613          	addi	a2,a2,756 # ffffffffc020c678 <etext+0xeb4>
ffffffffc020338c:	28800593          	li	a1,648
ffffffffc0203390:	00009517          	auipc	a0,0x9
ffffffffc0203394:	3d850513          	addi	a0,a0,984 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203398:	8b2fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020339c:	0000a697          	auipc	a3,0xa
ffffffffc02033a0:	8fc68693          	addi	a3,a3,-1796 # ffffffffc020cc98 <etext+0x14d4>
ffffffffc02033a4:	00009617          	auipc	a2,0x9
ffffffffc02033a8:	85c60613          	addi	a2,a2,-1956 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02033ac:	28900593          	li	a1,649
ffffffffc02033b0:	00009517          	auipc	a0,0x9
ffffffffc02033b4:	3b850513          	addi	a0,a0,952 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02033b8:	892fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033bc:	0000a697          	auipc	a3,0xa
ffffffffc02033c0:	89c68693          	addi	a3,a3,-1892 # ffffffffc020cc58 <etext+0x1494>
ffffffffc02033c4:	00009617          	auipc	a2,0x9
ffffffffc02033c8:	83c60613          	addi	a2,a2,-1988 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02033cc:	28800593          	li	a1,648
ffffffffc02033d0:	00009517          	auipc	a0,0x9
ffffffffc02033d4:	39850513          	addi	a0,a0,920 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02033d8:	872fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033dc:	d8dfe0ef          	jal	ffffffffc0202168 <pa2page.part.0>
ffffffffc02033e0:	00009697          	auipc	a3,0x9
ffffffffc02033e4:	71868693          	addi	a3,a3,1816 # ffffffffc020caf8 <etext+0x1334>
ffffffffc02033e8:	00009617          	auipc	a2,0x9
ffffffffc02033ec:	81860613          	addi	a2,a2,-2024 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02033f0:	25d00593          	li	a1,605
ffffffffc02033f4:	00009517          	auipc	a0,0x9
ffffffffc02033f8:	37450513          	addi	a0,a0,884 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02033fc:	84efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203400:	00009697          	auipc	a3,0x9
ffffffffc0203404:	62068693          	addi	a3,a3,1568 # ffffffffc020ca20 <etext+0x125c>
ffffffffc0203408:	00008617          	auipc	a2,0x8
ffffffffc020340c:	7f860613          	addi	a2,a2,2040 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203410:	25300593          	li	a1,595
ffffffffc0203414:	00009517          	auipc	a0,0x9
ffffffffc0203418:	35450513          	addi	a0,a0,852 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020341c:	82efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203420:	00009697          	auipc	a3,0x9
ffffffffc0203424:	6a068693          	addi	a3,a3,1696 # ffffffffc020cac0 <etext+0x12fc>
ffffffffc0203428:	00008617          	auipc	a2,0x8
ffffffffc020342c:	7d860613          	addi	a2,a2,2008 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203430:	26500593          	li	a1,613
ffffffffc0203434:	00009517          	auipc	a0,0x9
ffffffffc0203438:	33450513          	addi	a0,a0,820 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020343c:	80efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203440:	00009697          	auipc	a3,0x9
ffffffffc0203444:	6d868693          	addi	a3,a3,1752 # ffffffffc020cb18 <etext+0x1354>
ffffffffc0203448:	00008617          	auipc	a2,0x8
ffffffffc020344c:	7b860613          	addi	a2,a2,1976 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203450:	25f00593          	li	a1,607
ffffffffc0203454:	00009517          	auipc	a0,0x9
ffffffffc0203458:	31450513          	addi	a0,a0,788 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020345c:	feffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203460:	00009697          	auipc	a3,0x9
ffffffffc0203464:	6a868693          	addi	a3,a3,1704 # ffffffffc020cb08 <etext+0x1344>
ffffffffc0203468:	00008617          	auipc	a2,0x8
ffffffffc020346c:	79860613          	addi	a2,a2,1944 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203470:	25e00593          	li	a1,606
ffffffffc0203474:	00009517          	auipc	a0,0x9
ffffffffc0203478:	2f450513          	addi	a0,a0,756 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020347c:	fcffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203480:	00009697          	auipc	a3,0x9
ffffffffc0203484:	6d068693          	addi	a3,a3,1744 # ffffffffc020cb50 <etext+0x138c>
ffffffffc0203488:	00008617          	auipc	a2,0x8
ffffffffc020348c:	77860613          	addi	a2,a2,1912 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203490:	26200593          	li	a1,610
ffffffffc0203494:	00009517          	auipc	a0,0x9
ffffffffc0203498:	2d450513          	addi	a0,a0,724 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020349c:	faffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034a0:	00009697          	auipc	a3,0x9
ffffffffc02034a4:	69868693          	addi	a3,a3,1688 # ffffffffc020cb38 <etext+0x1374>
ffffffffc02034a8:	00008617          	auipc	a2,0x8
ffffffffc02034ac:	75860613          	addi	a2,a2,1880 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02034b0:	26000593          	li	a1,608
ffffffffc02034b4:	00009517          	auipc	a0,0x9
ffffffffc02034b8:	2b450513          	addi	a0,a0,692 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02034bc:	f8ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034c0:	00009697          	auipc	a3,0x9
ffffffffc02034c4:	59068693          	addi	a3,a3,1424 # ffffffffc020ca50 <etext+0x128c>
ffffffffc02034c8:	00008617          	auipc	a2,0x8
ffffffffc02034cc:	73860613          	addi	a2,a2,1848 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02034d0:	25800593          	li	a1,600
ffffffffc02034d4:	00009517          	auipc	a0,0x9
ffffffffc02034d8:	29450513          	addi	a0,a0,660 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02034dc:	f6ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034e0:	00009697          	auipc	a3,0x9
ffffffffc02034e4:	5e068693          	addi	a3,a3,1504 # ffffffffc020cac0 <etext+0x12fc>
ffffffffc02034e8:	00008617          	auipc	a2,0x8
ffffffffc02034ec:	71860613          	addi	a2,a2,1816 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02034f0:	25c00593          	li	a1,604
ffffffffc02034f4:	00009517          	auipc	a0,0x9
ffffffffc02034f8:	27450513          	addi	a0,a0,628 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02034fc:	f4ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203500:	00009697          	auipc	a3,0x9
ffffffffc0203504:	58068693          	addi	a3,a3,1408 # ffffffffc020ca80 <etext+0x12bc>
ffffffffc0203508:	00008617          	auipc	a2,0x8
ffffffffc020350c:	6f860613          	addi	a2,a2,1784 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203510:	25b00593          	li	a1,603
ffffffffc0203514:	00009517          	auipc	a0,0x9
ffffffffc0203518:	25450513          	addi	a0,a0,596 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020351c:	f2ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203520:	86d6                	mv	a3,s5
ffffffffc0203522:	00009617          	auipc	a2,0x9
ffffffffc0203526:	15660613          	addi	a2,a2,342 # ffffffffc020c678 <etext+0xeb4>
ffffffffc020352a:	25700593          	li	a1,599
ffffffffc020352e:	00009517          	auipc	a0,0x9
ffffffffc0203532:	23a50513          	addi	a0,a0,570 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203536:	f15fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020353a:	00009617          	auipc	a2,0x9
ffffffffc020353e:	13e60613          	addi	a2,a2,318 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0203542:	25600593          	li	a1,598
ffffffffc0203546:	00009517          	auipc	a0,0x9
ffffffffc020354a:	22250513          	addi	a0,a0,546 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020354e:	efdfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203552:	00009697          	auipc	a3,0x9
ffffffffc0203556:	4e668693          	addi	a3,a3,1254 # ffffffffc020ca38 <etext+0x1274>
ffffffffc020355a:	00008617          	auipc	a2,0x8
ffffffffc020355e:	6a660613          	addi	a2,a2,1702 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203562:	25400593          	li	a1,596
ffffffffc0203566:	00009517          	auipc	a0,0x9
ffffffffc020356a:	20250513          	addi	a0,a0,514 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020356e:	eddfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203572:	86be                	mv	a3,a5
ffffffffc0203574:	00009617          	auipc	a2,0x9
ffffffffc0203578:	1ac60613          	addi	a2,a2,428 # ffffffffc020c720 <etext+0xf5c>
ffffffffc020357c:	0dc00593          	li	a1,220
ffffffffc0203580:	00009517          	auipc	a0,0x9
ffffffffc0203584:	1e850513          	addi	a0,a0,488 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203588:	ec3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020358c:	86be                	mv	a3,a5
ffffffffc020358e:	00009617          	auipc	a2,0x9
ffffffffc0203592:	19260613          	addi	a2,a2,402 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0203596:	0db00593          	li	a1,219
ffffffffc020359a:	00009517          	auipc	a0,0x9
ffffffffc020359e:	1ce50513          	addi	a0,a0,462 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02035a2:	ea9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035a6:	00009697          	auipc	a3,0x9
ffffffffc02035aa:	7c268693          	addi	a3,a3,1986 # ffffffffc020cd68 <etext+0x15a4>
ffffffffc02035ae:	00008617          	auipc	a2,0x8
ffffffffc02035b2:	65260613          	addi	a2,a2,1618 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02035b6:	29300593          	li	a1,659
ffffffffc02035ba:	00009517          	auipc	a0,0x9
ffffffffc02035be:	1ae50513          	addi	a0,a0,430 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02035c2:	e89fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035c6:	00009697          	auipc	a3,0x9
ffffffffc02035ca:	64a68693          	addi	a3,a3,1610 # ffffffffc020cc10 <etext+0x144c>
ffffffffc02035ce:	00008617          	auipc	a2,0x8
ffffffffc02035d2:	63260613          	addi	a2,a2,1586 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02035d6:	2a300593          	li	a1,675
ffffffffc02035da:	00009517          	auipc	a0,0x9
ffffffffc02035de:	18e50513          	addi	a0,a0,398 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02035e2:	e69fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035e6:	00009697          	auipc	a3,0x9
ffffffffc02035ea:	6ca68693          	addi	a3,a3,1738 # ffffffffc020ccb0 <etext+0x14ec>
ffffffffc02035ee:	00008617          	auipc	a2,0x8
ffffffffc02035f2:	61260613          	addi	a2,a2,1554 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02035f6:	28c00593          	li	a1,652
ffffffffc02035fa:	00009517          	auipc	a0,0x9
ffffffffc02035fe:	16e50513          	addi	a0,a0,366 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203602:	e49fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203606:	00009697          	auipc	a3,0x9
ffffffffc020360a:	7ca68693          	addi	a3,a3,1994 # ffffffffc020cdd0 <etext+0x160c>
ffffffffc020360e:	00008617          	auipc	a2,0x8
ffffffffc0203612:	5f260613          	addi	a2,a2,1522 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203616:	29a00593          	li	a1,666
ffffffffc020361a:	00009517          	auipc	a0,0x9
ffffffffc020361e:	14e50513          	addi	a0,a0,334 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203622:	e29fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203626:	00009697          	auipc	a3,0x9
ffffffffc020362a:	6a268693          	addi	a3,a3,1698 # ffffffffc020ccc8 <etext+0x1504>
ffffffffc020362e:	00008617          	auipc	a2,0x8
ffffffffc0203632:	5d260613          	addi	a2,a2,1490 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203636:	29000593          	li	a1,656
ffffffffc020363a:	00009517          	auipc	a0,0x9
ffffffffc020363e:	12e50513          	addi	a0,a0,302 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203642:	e09fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203646:	00009697          	auipc	a3,0x9
ffffffffc020364a:	6da68693          	addi	a3,a3,1754 # ffffffffc020cd20 <etext+0x155c>
ffffffffc020364e:	00008617          	auipc	a2,0x8
ffffffffc0203652:	5b260613          	addi	a2,a2,1458 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203656:	29200593          	li	a1,658
ffffffffc020365a:	00009517          	auipc	a0,0x9
ffffffffc020365e:	10e50513          	addi	a0,a0,270 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203662:	de9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203666:	00009697          	auipc	a3,0x9
ffffffffc020366a:	6a268693          	addi	a3,a3,1698 # ffffffffc020cd08 <etext+0x1544>
ffffffffc020366e:	00008617          	auipc	a2,0x8
ffffffffc0203672:	59260613          	addi	a2,a2,1426 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203676:	29100593          	li	a1,657
ffffffffc020367a:	00009517          	auipc	a0,0x9
ffffffffc020367e:	0ee50513          	addi	a0,a0,238 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203682:	dc9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203686:	00009697          	auipc	a3,0x9
ffffffffc020368a:	58a68693          	addi	a3,a3,1418 # ffffffffc020cc10 <etext+0x144c>
ffffffffc020368e:	00008617          	auipc	a2,0x8
ffffffffc0203692:	57260613          	addi	a2,a2,1394 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203696:	27900593          	li	a1,633
ffffffffc020369a:	00009517          	auipc	a0,0x9
ffffffffc020369e:	0ce50513          	addi	a0,a0,206 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02036a2:	da9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036a6:	00009697          	auipc	a3,0x9
ffffffffc02036aa:	53a68693          	addi	a3,a3,1338 # ffffffffc020cbe0 <etext+0x141c>
ffffffffc02036ae:	00008617          	auipc	a2,0x8
ffffffffc02036b2:	55260613          	addi	a2,a2,1362 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02036b6:	27100593          	li	a1,625
ffffffffc02036ba:	00009517          	auipc	a0,0x9
ffffffffc02036be:	0ae50513          	addi	a0,a0,174 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02036c2:	d89fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036c6:	00009697          	auipc	a3,0x9
ffffffffc02036ca:	4d268693          	addi	a3,a3,1234 # ffffffffc020cb98 <etext+0x13d4>
ffffffffc02036ce:	00008617          	auipc	a2,0x8
ffffffffc02036d2:	53260613          	addi	a2,a2,1330 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02036d6:	26f00593          	li	a1,623
ffffffffc02036da:	00009517          	auipc	a0,0x9
ffffffffc02036de:	08e50513          	addi	a0,a0,142 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02036e2:	d69fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036e6:	00009697          	auipc	a3,0x9
ffffffffc02036ea:	4e268693          	addi	a3,a3,1250 # ffffffffc020cbc8 <etext+0x1404>
ffffffffc02036ee:	00008617          	auipc	a2,0x8
ffffffffc02036f2:	51260613          	addi	a2,a2,1298 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02036f6:	26e00593          	li	a1,622
ffffffffc02036fa:	00009517          	auipc	a0,0x9
ffffffffc02036fe:	06e50513          	addi	a0,a0,110 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203702:	d49fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203706:	00009697          	auipc	a3,0x9
ffffffffc020370a:	49268693          	addi	a3,a3,1170 # ffffffffc020cb98 <etext+0x13d4>
ffffffffc020370e:	00008617          	auipc	a2,0x8
ffffffffc0203712:	4f260613          	addi	a2,a2,1266 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203716:	26b00593          	li	a1,619
ffffffffc020371a:	00009517          	auipc	a0,0x9
ffffffffc020371e:	04e50513          	addi	a0,a0,78 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203722:	d29fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203726:	00009697          	auipc	a3,0x9
ffffffffc020372a:	31268693          	addi	a3,a3,786 # ffffffffc020ca38 <etext+0x1274>
ffffffffc020372e:	00008617          	auipc	a2,0x8
ffffffffc0203732:	4d260613          	addi	a2,a2,1234 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203736:	26a00593          	li	a1,618
ffffffffc020373a:	00009517          	auipc	a0,0x9
ffffffffc020373e:	02e50513          	addi	a0,a0,46 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203742:	d09fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203746:	00009697          	auipc	a3,0x9
ffffffffc020374a:	46a68693          	addi	a3,a3,1130 # ffffffffc020cbb0 <etext+0x13ec>
ffffffffc020374e:	00008617          	auipc	a2,0x8
ffffffffc0203752:	4b260613          	addi	a2,a2,1202 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203756:	26700593          	li	a1,615
ffffffffc020375a:	00009517          	auipc	a0,0x9
ffffffffc020375e:	00e50513          	addi	a0,a0,14 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203762:	ce9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203766:	00009697          	auipc	a3,0x9
ffffffffc020376a:	2ba68693          	addi	a3,a3,698 # ffffffffc020ca20 <etext+0x125c>
ffffffffc020376e:	00008617          	auipc	a2,0x8
ffffffffc0203772:	49260613          	addi	a2,a2,1170 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203776:	26600593          	li	a1,614
ffffffffc020377a:	00009517          	auipc	a0,0x9
ffffffffc020377e:	fee50513          	addi	a0,a0,-18 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203782:	cc9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203786:	00009617          	auipc	a2,0x9
ffffffffc020378a:	f9a60613          	addi	a2,a2,-102 # ffffffffc020c720 <etext+0xf5c>
ffffffffc020378e:	08100593          	li	a1,129
ffffffffc0203792:	00009517          	auipc	a0,0x9
ffffffffc0203796:	fd650513          	addi	a0,a0,-42 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020379a:	cb1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020379e:	00009617          	auipc	a2,0x9
ffffffffc02037a2:	eda60613          	addi	a2,a2,-294 # ffffffffc020c678 <etext+0xeb4>
ffffffffc02037a6:	07100593          	li	a1,113
ffffffffc02037aa:	00009517          	auipc	a0,0x9
ffffffffc02037ae:	ef650513          	addi	a0,a0,-266 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc02037b2:	c99fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037b6:	86a2                	mv	a3,s0
ffffffffc02037b8:	00009617          	auipc	a2,0x9
ffffffffc02037bc:	f6860613          	addi	a2,a2,-152 # ffffffffc020c720 <etext+0xf5c>
ffffffffc02037c0:	0ca00593          	li	a1,202
ffffffffc02037c4:	00009517          	auipc	a0,0x9
ffffffffc02037c8:	fa450513          	addi	a0,a0,-92 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02037cc:	c7ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037d0:	00009617          	auipc	a2,0x9
ffffffffc02037d4:	0c860613          	addi	a2,a2,200 # ffffffffc020c898 <etext+0x10d4>
ffffffffc02037d8:	0aa00593          	li	a1,170
ffffffffc02037dc:	00009517          	auipc	a0,0x9
ffffffffc02037e0:	f8c50513          	addi	a0,a0,-116 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02037e4:	c67fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037e8:	00009617          	auipc	a2,0x9
ffffffffc02037ec:	01860613          	addi	a2,a2,24 # ffffffffc020c800 <etext+0x103c>
ffffffffc02037f0:	06500593          	li	a1,101
ffffffffc02037f4:	00009517          	auipc	a0,0x9
ffffffffc02037f8:	f7450513          	addi	a0,a0,-140 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02037fc:	c4ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203800:	00009697          	auipc	a3,0x9
ffffffffc0203804:	16868693          	addi	a3,a3,360 # ffffffffc020c968 <etext+0x11a4>
ffffffffc0203808:	00008617          	auipc	a2,0x8
ffffffffc020380c:	3f860613          	addi	a2,a2,1016 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203810:	24b00593          	li	a1,587
ffffffffc0203814:	00009517          	auipc	a0,0x9
ffffffffc0203818:	f5450513          	addi	a0,a0,-172 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020381c:	c2ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203820:	00009697          	auipc	a3,0x9
ffffffffc0203824:	10868693          	addi	a3,a3,264 # ffffffffc020c928 <etext+0x1164>
ffffffffc0203828:	00008617          	auipc	a2,0x8
ffffffffc020382c:	3d860613          	addi	a2,a2,984 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203830:	24a00593          	li	a1,586
ffffffffc0203834:	00009517          	auipc	a0,0x9
ffffffffc0203838:	f3450513          	addi	a0,a0,-204 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020383c:	c0ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203840:	00009697          	auipc	a3,0x9
ffffffffc0203844:	0c868693          	addi	a3,a3,200 # ffffffffc020c908 <etext+0x1144>
ffffffffc0203848:	00008617          	auipc	a2,0x8
ffffffffc020384c:	3b860613          	addi	a2,a2,952 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203850:	24900593          	li	a1,585
ffffffffc0203854:	00009517          	auipc	a0,0x9
ffffffffc0203858:	f1450513          	addi	a0,a0,-236 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020385c:	beffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203860:	00009697          	auipc	a3,0x9
ffffffffc0203864:	53868693          	addi	a3,a3,1336 # ffffffffc020cd98 <etext+0x15d4>
ffffffffc0203868:	00008617          	auipc	a2,0x8
ffffffffc020386c:	39860613          	addi	a2,a2,920 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203870:	29700593          	li	a1,663
ffffffffc0203874:	00009517          	auipc	a0,0x9
ffffffffc0203878:	ef450513          	addi	a0,a0,-268 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020387c:	bcffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203880:	00009617          	auipc	a2,0x9
ffffffffc0203884:	17860613          	addi	a2,a2,376 # ffffffffc020c9f8 <etext+0x1234>
ffffffffc0203888:	07f00593          	li	a1,127
ffffffffc020388c:	00009517          	auipc	a0,0x9
ffffffffc0203890:	e1450513          	addi	a0,a0,-492 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0203894:	bb7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203898:	00009697          	auipc	a3,0x9
ffffffffc020389c:	13068693          	addi	a3,a3,304 # ffffffffc020c9c8 <etext+0x1204>
ffffffffc02038a0:	00008617          	auipc	a2,0x8
ffffffffc02038a4:	36060613          	addi	a2,a2,864 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02038a8:	25200593          	li	a1,594
ffffffffc02038ac:	00009517          	auipc	a0,0x9
ffffffffc02038b0:	ebc50513          	addi	a0,a0,-324 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02038b4:	b97fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038b8:	00009697          	auipc	a3,0x9
ffffffffc02038bc:	0e068693          	addi	a3,a3,224 # ffffffffc020c998 <etext+0x11d4>
ffffffffc02038c0:	00008617          	auipc	a2,0x8
ffffffffc02038c4:	34060613          	addi	a2,a2,832 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02038c8:	24f00593          	li	a1,591
ffffffffc02038cc:	00009517          	auipc	a0,0x9
ffffffffc02038d0:	e9c50513          	addi	a0,a0,-356 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02038d4:	b77fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038d8:	86ca                	mv	a3,s2
ffffffffc02038da:	00009617          	auipc	a2,0x9
ffffffffc02038de:	e4660613          	addi	a2,a2,-442 # ffffffffc020c720 <etext+0xf5c>
ffffffffc02038e2:	0c600593          	li	a1,198
ffffffffc02038e6:	00009517          	auipc	a0,0x9
ffffffffc02038ea:	e8250513          	addi	a0,a0,-382 # ffffffffc020c768 <etext+0xfa4>
ffffffffc02038ee:	b5dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038f2:	00009697          	auipc	a3,0x9
ffffffffc02038f6:	2a668693          	addi	a3,a3,678 # ffffffffc020cb98 <etext+0x13d4>
ffffffffc02038fa:	00008617          	auipc	a2,0x8
ffffffffc02038fe:	30660613          	addi	a2,a2,774 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203902:	26400593          	li	a1,612
ffffffffc0203906:	00009517          	auipc	a0,0x9
ffffffffc020390a:	e6250513          	addi	a0,a0,-414 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020390e:	b3dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203912:	00009697          	auipc	a3,0x9
ffffffffc0203916:	26e68693          	addi	a3,a3,622 # ffffffffc020cb80 <etext+0x13bc>
ffffffffc020391a:	00008617          	auipc	a2,0x8
ffffffffc020391e:	2e660613          	addi	a2,a2,742 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203922:	26300593          	li	a1,611
ffffffffc0203926:	00009517          	auipc	a0,0x9
ffffffffc020392a:	e4250513          	addi	a0,a0,-446 # ffffffffc020c768 <etext+0xfa4>
ffffffffc020392e:	b1dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203932 <copy_range>:
ffffffffc0203932:	7159                	addi	sp,sp,-112
ffffffffc0203934:	00d667b3          	or	a5,a2,a3
ffffffffc0203938:	f486                	sd	ra,104(sp)
ffffffffc020393a:	f0a2                	sd	s0,96(sp)
ffffffffc020393c:	eca6                	sd	s1,88(sp)
ffffffffc020393e:	e8ca                	sd	s2,80(sp)
ffffffffc0203940:	e4ce                	sd	s3,72(sp)
ffffffffc0203942:	e0d2                	sd	s4,64(sp)
ffffffffc0203944:	fc56                	sd	s5,56(sp)
ffffffffc0203946:	f85a                	sd	s6,48(sp)
ffffffffc0203948:	f45e                	sd	s7,40(sp)
ffffffffc020394a:	f062                	sd	s8,32(sp)
ffffffffc020394c:	ec66                	sd	s9,24(sp)
ffffffffc020394e:	e86a                	sd	s10,16(sp)
ffffffffc0203950:	e46e                	sd	s11,8(sp)
ffffffffc0203952:	03479713          	slli	a4,a5,0x34
ffffffffc0203956:	20071f63          	bnez	a4,ffffffffc0203b74 <copy_range+0x242>
ffffffffc020395a:	002007b7          	lui	a5,0x200
ffffffffc020395e:	00d63733          	sltu	a4,a2,a3
ffffffffc0203962:	00f637b3          	sltu	a5,a2,a5
ffffffffc0203966:	00173713          	seqz	a4,a4
ffffffffc020396a:	8fd9                	or	a5,a5,a4
ffffffffc020396c:	8432                	mv	s0,a2
ffffffffc020396e:	8936                	mv	s2,a3
ffffffffc0203970:	1e079263          	bnez	a5,ffffffffc0203b54 <copy_range+0x222>
ffffffffc0203974:	4785                	li	a5,1
ffffffffc0203976:	07fe                	slli	a5,a5,0x1f
ffffffffc0203978:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc020397a:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203b54 <copy_range+0x222>
ffffffffc020397e:	5b7d                	li	s6,-1
ffffffffc0203980:	8baa                	mv	s7,a0
ffffffffc0203982:	8a2e                	mv	s4,a1
ffffffffc0203984:	6a85                	lui	s5,0x1
ffffffffc0203986:	00cb5b13          	srli	s6,s6,0xc
ffffffffc020398a:	00093c97          	auipc	s9,0x93
ffffffffc020398e:	f26c8c93          	addi	s9,s9,-218 # ffffffffc02968b0 <npage>
ffffffffc0203992:	00093c17          	auipc	s8,0x93
ffffffffc0203996:	f26c0c13          	addi	s8,s8,-218 # ffffffffc02968b8 <pages>
ffffffffc020399a:	fff80d37          	lui	s10,0xfff80
ffffffffc020399e:	4601                	li	a2,0
ffffffffc02039a0:	85a2                	mv	a1,s0
ffffffffc02039a2:	8552                	mv	a0,s4
ffffffffc02039a4:	889fe0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc02039a8:	84aa                	mv	s1,a0
ffffffffc02039aa:	0e050a63          	beqz	a0,ffffffffc0203a9e <copy_range+0x16c>
ffffffffc02039ae:	611c                	ld	a5,0(a0)
ffffffffc02039b0:	8b85                	andi	a5,a5,1
ffffffffc02039b2:	e78d                	bnez	a5,ffffffffc02039dc <copy_range+0xaa>
ffffffffc02039b4:	9456                	add	s0,s0,s5
ffffffffc02039b6:	c019                	beqz	s0,ffffffffc02039bc <copy_range+0x8a>
ffffffffc02039b8:	ff2463e3          	bltu	s0,s2,ffffffffc020399e <copy_range+0x6c>
ffffffffc02039bc:	4501                	li	a0,0
ffffffffc02039be:	70a6                	ld	ra,104(sp)
ffffffffc02039c0:	7406                	ld	s0,96(sp)
ffffffffc02039c2:	64e6                	ld	s1,88(sp)
ffffffffc02039c4:	6946                	ld	s2,80(sp)
ffffffffc02039c6:	69a6                	ld	s3,72(sp)
ffffffffc02039c8:	6a06                	ld	s4,64(sp)
ffffffffc02039ca:	7ae2                	ld	s5,56(sp)
ffffffffc02039cc:	7b42                	ld	s6,48(sp)
ffffffffc02039ce:	7ba2                	ld	s7,40(sp)
ffffffffc02039d0:	7c02                	ld	s8,32(sp)
ffffffffc02039d2:	6ce2                	ld	s9,24(sp)
ffffffffc02039d4:	6d42                	ld	s10,16(sp)
ffffffffc02039d6:	6da2                	ld	s11,8(sp)
ffffffffc02039d8:	6165                	addi	sp,sp,112
ffffffffc02039da:	8082                	ret
ffffffffc02039dc:	4605                	li	a2,1
ffffffffc02039de:	85a2                	mv	a1,s0
ffffffffc02039e0:	855e                	mv	a0,s7
ffffffffc02039e2:	84bfe0ef          	jal	ffffffffc020222c <get_pte>
ffffffffc02039e6:	c165                	beqz	a0,ffffffffc0203ac6 <copy_range+0x194>
ffffffffc02039e8:	0004b983          	ld	s3,0(s1)
ffffffffc02039ec:	0019f793          	andi	a5,s3,1
ffffffffc02039f0:	14078663          	beqz	a5,ffffffffc0203b3c <copy_range+0x20a>
ffffffffc02039f4:	000cb703          	ld	a4,0(s9)
ffffffffc02039f8:	00299793          	slli	a5,s3,0x2
ffffffffc02039fc:	83b1                	srli	a5,a5,0xc
ffffffffc02039fe:	12e7f363          	bgeu	a5,a4,ffffffffc0203b24 <copy_range+0x1f2>
ffffffffc0203a02:	000c3483          	ld	s1,0(s8)
ffffffffc0203a06:	97ea                	add	a5,a5,s10
ffffffffc0203a08:	079a                	slli	a5,a5,0x6
ffffffffc0203a0a:	94be                	add	s1,s1,a5
ffffffffc0203a0c:	100027f3          	csrr	a5,sstatus
ffffffffc0203a10:	8b89                	andi	a5,a5,2
ffffffffc0203a12:	efc9                	bnez	a5,ffffffffc0203aac <copy_range+0x17a>
ffffffffc0203a14:	00093797          	auipc	a5,0x93
ffffffffc0203a18:	e7c7b783          	ld	a5,-388(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0203a1c:	4505                	li	a0,1
ffffffffc0203a1e:	6f9c                	ld	a5,24(a5)
ffffffffc0203a20:	9782                	jalr	a5
ffffffffc0203a22:	8daa                	mv	s11,a0
ffffffffc0203a24:	c0e5                	beqz	s1,ffffffffc0203b04 <copy_range+0x1d2>
ffffffffc0203a26:	0a0d8f63          	beqz	s11,ffffffffc0203ae4 <copy_range+0x1b2>
ffffffffc0203a2a:	000c3783          	ld	a5,0(s8)
ffffffffc0203a2e:	00080637          	lui	a2,0x80
ffffffffc0203a32:	000cb703          	ld	a4,0(s9)
ffffffffc0203a36:	40f486b3          	sub	a3,s1,a5
ffffffffc0203a3a:	8699                	srai	a3,a3,0x6
ffffffffc0203a3c:	96b2                	add	a3,a3,a2
ffffffffc0203a3e:	0166f5b3          	and	a1,a3,s6
ffffffffc0203a42:	06b2                	slli	a3,a3,0xc
ffffffffc0203a44:	08e5f463          	bgeu	a1,a4,ffffffffc0203acc <copy_range+0x19a>
ffffffffc0203a48:	40fd87b3          	sub	a5,s11,a5
ffffffffc0203a4c:	8799                	srai	a5,a5,0x6
ffffffffc0203a4e:	97b2                	add	a5,a5,a2
ffffffffc0203a50:	0167f633          	and	a2,a5,s6
ffffffffc0203a54:	07b2                	slli	a5,a5,0xc
ffffffffc0203a56:	06e67a63          	bgeu	a2,a4,ffffffffc0203aca <copy_range+0x198>
ffffffffc0203a5a:	00093517          	auipc	a0,0x93
ffffffffc0203a5e:	e4e53503          	ld	a0,-434(a0) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0203a62:	6605                	lui	a2,0x1
ffffffffc0203a64:	00a685b3          	add	a1,a3,a0
ffffffffc0203a68:	953e                	add	a0,a0,a5
ffffffffc0203a6a:	543070ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0203a6e:	01f9f693          	andi	a3,s3,31
ffffffffc0203a72:	85ee                	mv	a1,s11
ffffffffc0203a74:	8622                	mv	a2,s0
ffffffffc0203a76:	855e                	mv	a0,s7
ffffffffc0203a78:	fb3fe0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc0203a7c:	dd05                	beqz	a0,ffffffffc02039b4 <copy_range+0x82>
ffffffffc0203a7e:	00009697          	auipc	a3,0x9
ffffffffc0203a82:	3ba68693          	addi	a3,a3,954 # ffffffffc020ce38 <etext+0x1674>
ffffffffc0203a86:	00008617          	auipc	a2,0x8
ffffffffc0203a8a:	17a60613          	addi	a2,a2,378 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203a8e:	1e700593          	li	a1,487
ffffffffc0203a92:	00009517          	auipc	a0,0x9
ffffffffc0203a96:	cd650513          	addi	a0,a0,-810 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203a9a:	9b1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a9e:	002007b7          	lui	a5,0x200
ffffffffc0203aa2:	97a2                	add	a5,a5,s0
ffffffffc0203aa4:	ffe00437          	lui	s0,0xffe00
ffffffffc0203aa8:	8c7d                	and	s0,s0,a5
ffffffffc0203aaa:	b731                	j	ffffffffc02039b6 <copy_range+0x84>
ffffffffc0203aac:	92cfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203ab0:	00093797          	auipc	a5,0x93
ffffffffc0203ab4:	de07b783          	ld	a5,-544(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0203ab8:	4505                	li	a0,1
ffffffffc0203aba:	6f9c                	ld	a5,24(a5)
ffffffffc0203abc:	9782                	jalr	a5
ffffffffc0203abe:	8daa                	mv	s11,a0
ffffffffc0203ac0:	912fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203ac4:	b785                	j	ffffffffc0203a24 <copy_range+0xf2>
ffffffffc0203ac6:	5571                	li	a0,-4
ffffffffc0203ac8:	bddd                	j	ffffffffc02039be <copy_range+0x8c>
ffffffffc0203aca:	86be                	mv	a3,a5
ffffffffc0203acc:	00009617          	auipc	a2,0x9
ffffffffc0203ad0:	bac60613          	addi	a2,a2,-1108 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0203ad4:	07100593          	li	a1,113
ffffffffc0203ad8:	00009517          	auipc	a0,0x9
ffffffffc0203adc:	bc850513          	addi	a0,a0,-1080 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0203ae0:	96bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203ae4:	00009697          	auipc	a3,0x9
ffffffffc0203ae8:	34468693          	addi	a3,a3,836 # ffffffffc020ce28 <etext+0x1664>
ffffffffc0203aec:	00008617          	auipc	a2,0x8
ffffffffc0203af0:	11460613          	addi	a2,a2,276 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203af4:	1cf00593          	li	a1,463
ffffffffc0203af8:	00009517          	auipc	a0,0x9
ffffffffc0203afc:	c7050513          	addi	a0,a0,-912 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203b00:	94bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b04:	00009697          	auipc	a3,0x9
ffffffffc0203b08:	31468693          	addi	a3,a3,788 # ffffffffc020ce18 <etext+0x1654>
ffffffffc0203b0c:	00008617          	auipc	a2,0x8
ffffffffc0203b10:	0f460613          	addi	a2,a2,244 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203b14:	1ce00593          	li	a1,462
ffffffffc0203b18:	00009517          	auipc	a0,0x9
ffffffffc0203b1c:	c5050513          	addi	a0,a0,-944 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203b20:	92bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b24:	00009617          	auipc	a2,0x9
ffffffffc0203b28:	c2460613          	addi	a2,a2,-988 # ffffffffc020c748 <etext+0xf84>
ffffffffc0203b2c:	06900593          	li	a1,105
ffffffffc0203b30:	00009517          	auipc	a0,0x9
ffffffffc0203b34:	b7050513          	addi	a0,a0,-1168 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0203b38:	913fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b3c:	00009617          	auipc	a2,0x9
ffffffffc0203b40:	ebc60613          	addi	a2,a2,-324 # ffffffffc020c9f8 <etext+0x1234>
ffffffffc0203b44:	07f00593          	li	a1,127
ffffffffc0203b48:	00009517          	auipc	a0,0x9
ffffffffc0203b4c:	b5850513          	addi	a0,a0,-1192 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0203b50:	8fbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b54:	00009697          	auipc	a3,0x9
ffffffffc0203b58:	c7c68693          	addi	a3,a3,-900 # ffffffffc020c7d0 <etext+0x100c>
ffffffffc0203b5c:	00008617          	auipc	a2,0x8
ffffffffc0203b60:	0a460613          	addi	a2,a2,164 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203b64:	1b600593          	li	a1,438
ffffffffc0203b68:	00009517          	auipc	a0,0x9
ffffffffc0203b6c:	c0050513          	addi	a0,a0,-1024 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203b70:	8dbfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b74:	00009697          	auipc	a3,0x9
ffffffffc0203b78:	c2c68693          	addi	a3,a3,-980 # ffffffffc020c7a0 <etext+0xfdc>
ffffffffc0203b7c:	00008617          	auipc	a2,0x8
ffffffffc0203b80:	08460613          	addi	a2,a2,132 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203b84:	1b500593          	li	a1,437
ffffffffc0203b88:	00009517          	auipc	a0,0x9
ffffffffc0203b8c:	be050513          	addi	a0,a0,-1056 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203b90:	8bbfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203b94 <pgdir_alloc_page>:
ffffffffc0203b94:	7139                	addi	sp,sp,-64
ffffffffc0203b96:	f426                	sd	s1,40(sp)
ffffffffc0203b98:	f04a                	sd	s2,32(sp)
ffffffffc0203b9a:	ec4e                	sd	s3,24(sp)
ffffffffc0203b9c:	fc06                	sd	ra,56(sp)
ffffffffc0203b9e:	f822                	sd	s0,48(sp)
ffffffffc0203ba0:	892a                	mv	s2,a0
ffffffffc0203ba2:	84ae                	mv	s1,a1
ffffffffc0203ba4:	89b2                	mv	s3,a2
ffffffffc0203ba6:	100027f3          	csrr	a5,sstatus
ffffffffc0203baa:	8b89                	andi	a5,a5,2
ffffffffc0203bac:	ebb5                	bnez	a5,ffffffffc0203c20 <pgdir_alloc_page+0x8c>
ffffffffc0203bae:	00093417          	auipc	s0,0x93
ffffffffc0203bb2:	ce240413          	addi	s0,s0,-798 # ffffffffc0296890 <pmm_manager>
ffffffffc0203bb6:	601c                	ld	a5,0(s0)
ffffffffc0203bb8:	4505                	li	a0,1
ffffffffc0203bba:	6f9c                	ld	a5,24(a5)
ffffffffc0203bbc:	9782                	jalr	a5
ffffffffc0203bbe:	85aa                	mv	a1,a0
ffffffffc0203bc0:	c5b9                	beqz	a1,ffffffffc0203c0e <pgdir_alloc_page+0x7a>
ffffffffc0203bc2:	86ce                	mv	a3,s3
ffffffffc0203bc4:	854a                	mv	a0,s2
ffffffffc0203bc6:	8626                	mv	a2,s1
ffffffffc0203bc8:	e42e                	sd	a1,8(sp)
ffffffffc0203bca:	e61fe0ef          	jal	ffffffffc0202a2a <page_insert>
ffffffffc0203bce:	65a2                	ld	a1,8(sp)
ffffffffc0203bd0:	e515                	bnez	a0,ffffffffc0203bfc <pgdir_alloc_page+0x68>
ffffffffc0203bd2:	4198                	lw	a4,0(a1)
ffffffffc0203bd4:	fd84                	sd	s1,56(a1)
ffffffffc0203bd6:	4785                	li	a5,1
ffffffffc0203bd8:	02f70c63          	beq	a4,a5,ffffffffc0203c10 <pgdir_alloc_page+0x7c>
ffffffffc0203bdc:	00009697          	auipc	a3,0x9
ffffffffc0203be0:	26c68693          	addi	a3,a3,620 # ffffffffc020ce48 <etext+0x1684>
ffffffffc0203be4:	00008617          	auipc	a2,0x8
ffffffffc0203be8:	01c60613          	addi	a2,a2,28 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203bec:	23000593          	li	a1,560
ffffffffc0203bf0:	00009517          	auipc	a0,0x9
ffffffffc0203bf4:	b7850513          	addi	a0,a0,-1160 # ffffffffc020c768 <etext+0xfa4>
ffffffffc0203bf8:	853fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203bfc:	100027f3          	csrr	a5,sstatus
ffffffffc0203c00:	8b89                	andi	a5,a5,2
ffffffffc0203c02:	ef95                	bnez	a5,ffffffffc0203c3e <pgdir_alloc_page+0xaa>
ffffffffc0203c04:	601c                	ld	a5,0(s0)
ffffffffc0203c06:	852e                	mv	a0,a1
ffffffffc0203c08:	4585                	li	a1,1
ffffffffc0203c0a:	739c                	ld	a5,32(a5)
ffffffffc0203c0c:	9782                	jalr	a5
ffffffffc0203c0e:	4581                	li	a1,0
ffffffffc0203c10:	70e2                	ld	ra,56(sp)
ffffffffc0203c12:	7442                	ld	s0,48(sp)
ffffffffc0203c14:	74a2                	ld	s1,40(sp)
ffffffffc0203c16:	7902                	ld	s2,32(sp)
ffffffffc0203c18:	69e2                	ld	s3,24(sp)
ffffffffc0203c1a:	852e                	mv	a0,a1
ffffffffc0203c1c:	6121                	addi	sp,sp,64
ffffffffc0203c1e:	8082                	ret
ffffffffc0203c20:	fb9fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203c24:	00093417          	auipc	s0,0x93
ffffffffc0203c28:	c6c40413          	addi	s0,s0,-916 # ffffffffc0296890 <pmm_manager>
ffffffffc0203c2c:	601c                	ld	a5,0(s0)
ffffffffc0203c2e:	4505                	li	a0,1
ffffffffc0203c30:	6f9c                	ld	a5,24(a5)
ffffffffc0203c32:	9782                	jalr	a5
ffffffffc0203c34:	e42a                	sd	a0,8(sp)
ffffffffc0203c36:	f9dfc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203c3a:	65a2                	ld	a1,8(sp)
ffffffffc0203c3c:	b751                	j	ffffffffc0203bc0 <pgdir_alloc_page+0x2c>
ffffffffc0203c3e:	f9bfc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203c42:	601c                	ld	a5,0(s0)
ffffffffc0203c44:	6522                	ld	a0,8(sp)
ffffffffc0203c46:	4585                	li	a1,1
ffffffffc0203c48:	739c                	ld	a5,32(a5)
ffffffffc0203c4a:	9782                	jalr	a5
ffffffffc0203c4c:	f87fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203c50:	bf7d                	j	ffffffffc0203c0e <pgdir_alloc_page+0x7a>

ffffffffc0203c52 <check_vma_overlap.part.0>:
ffffffffc0203c52:	1141                	addi	sp,sp,-16
ffffffffc0203c54:	00009697          	auipc	a3,0x9
ffffffffc0203c58:	20c68693          	addi	a3,a3,524 # ffffffffc020ce60 <etext+0x169c>
ffffffffc0203c5c:	00008617          	auipc	a2,0x8
ffffffffc0203c60:	fa460613          	addi	a2,a2,-92 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203c64:	07400593          	li	a1,116
ffffffffc0203c68:	00009517          	auipc	a0,0x9
ffffffffc0203c6c:	21850513          	addi	a0,a0,536 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203c70:	e406                	sd	ra,8(sp)
ffffffffc0203c72:	fd8fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203c76 <mm_create>:
ffffffffc0203c76:	1101                	addi	sp,sp,-32
ffffffffc0203c78:	05800513          	li	a0,88
ffffffffc0203c7c:	ec06                	sd	ra,24(sp)
ffffffffc0203c7e:	b42fe0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0203c82:	87aa                	mv	a5,a0
ffffffffc0203c84:	c505                	beqz	a0,ffffffffc0203cac <mm_create+0x36>
ffffffffc0203c86:	e788                	sd	a0,8(a5)
ffffffffc0203c88:	e388                	sd	a0,0(a5)
ffffffffc0203c8a:	00053823          	sd	zero,16(a0)
ffffffffc0203c8e:	00053c23          	sd	zero,24(a0)
ffffffffc0203c92:	02052023          	sw	zero,32(a0)
ffffffffc0203c96:	02053423          	sd	zero,40(a0)
ffffffffc0203c9a:	02052823          	sw	zero,48(a0)
ffffffffc0203c9e:	4585                	li	a1,1
ffffffffc0203ca0:	03850513          	addi	a0,a0,56
ffffffffc0203ca4:	e43e                	sd	a5,8(sp)
ffffffffc0203ca6:	147000ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc0203caa:	67a2                	ld	a5,8(sp)
ffffffffc0203cac:	60e2                	ld	ra,24(sp)
ffffffffc0203cae:	853e                	mv	a0,a5
ffffffffc0203cb0:	6105                	addi	sp,sp,32
ffffffffc0203cb2:	8082                	ret

ffffffffc0203cb4 <find_vma>:
ffffffffc0203cb4:	c505                	beqz	a0,ffffffffc0203cdc <find_vma+0x28>
ffffffffc0203cb6:	691c                	ld	a5,16(a0)
ffffffffc0203cb8:	c781                	beqz	a5,ffffffffc0203cc0 <find_vma+0xc>
ffffffffc0203cba:	6798                	ld	a4,8(a5)
ffffffffc0203cbc:	02e5f363          	bgeu	a1,a4,ffffffffc0203ce2 <find_vma+0x2e>
ffffffffc0203cc0:	651c                	ld	a5,8(a0)
ffffffffc0203cc2:	00f50d63          	beq	a0,a5,ffffffffc0203cdc <find_vma+0x28>
ffffffffc0203cc6:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203cca:	00e5e663          	bltu	a1,a4,ffffffffc0203cd6 <find_vma+0x22>
ffffffffc0203cce:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203cd2:	00e5ee63          	bltu	a1,a4,ffffffffc0203cee <find_vma+0x3a>
ffffffffc0203cd6:	679c                	ld	a5,8(a5)
ffffffffc0203cd8:	fef517e3          	bne	a0,a5,ffffffffc0203cc6 <find_vma+0x12>
ffffffffc0203cdc:	4781                	li	a5,0
ffffffffc0203cde:	853e                	mv	a0,a5
ffffffffc0203ce0:	8082                	ret
ffffffffc0203ce2:	6b98                	ld	a4,16(a5)
ffffffffc0203ce4:	fce5fee3          	bgeu	a1,a4,ffffffffc0203cc0 <find_vma+0xc>
ffffffffc0203ce8:	e91c                	sd	a5,16(a0)
ffffffffc0203cea:	853e                	mv	a0,a5
ffffffffc0203cec:	8082                	ret
ffffffffc0203cee:	1781                	addi	a5,a5,-32
ffffffffc0203cf0:	e91c                	sd	a5,16(a0)
ffffffffc0203cf2:	bfe5                	j	ffffffffc0203cea <find_vma+0x36>

ffffffffc0203cf4 <insert_vma_struct>:
ffffffffc0203cf4:	6590                	ld	a2,8(a1)
ffffffffc0203cf6:	0105b803          	ld	a6,16(a1)
ffffffffc0203cfa:	1141                	addi	sp,sp,-16
ffffffffc0203cfc:	e406                	sd	ra,8(sp)
ffffffffc0203cfe:	87aa                	mv	a5,a0
ffffffffc0203d00:	01066763          	bltu	a2,a6,ffffffffc0203d0e <insert_vma_struct+0x1a>
ffffffffc0203d04:	a8b9                	j	ffffffffc0203d62 <insert_vma_struct+0x6e>
ffffffffc0203d06:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d0a:	04e66763          	bltu	a2,a4,ffffffffc0203d58 <insert_vma_struct+0x64>
ffffffffc0203d0e:	86be                	mv	a3,a5
ffffffffc0203d10:	679c                	ld	a5,8(a5)
ffffffffc0203d12:	fef51ae3          	bne	a0,a5,ffffffffc0203d06 <insert_vma_struct+0x12>
ffffffffc0203d16:	02a68463          	beq	a3,a0,ffffffffc0203d3e <insert_vma_struct+0x4a>
ffffffffc0203d1a:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203d1e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203d22:	08e8f063          	bgeu	a7,a4,ffffffffc0203da2 <insert_vma_struct+0xae>
ffffffffc0203d26:	04e66e63          	bltu	a2,a4,ffffffffc0203d82 <insert_vma_struct+0x8e>
ffffffffc0203d2a:	00f50a63          	beq	a0,a5,ffffffffc0203d3e <insert_vma_struct+0x4a>
ffffffffc0203d2e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d32:	05076863          	bltu	a4,a6,ffffffffc0203d82 <insert_vma_struct+0x8e>
ffffffffc0203d36:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203d3a:	02c77263          	bgeu	a4,a2,ffffffffc0203d5e <insert_vma_struct+0x6a>
ffffffffc0203d3e:	5118                	lw	a4,32(a0)
ffffffffc0203d40:	e188                	sd	a0,0(a1)
ffffffffc0203d42:	02058613          	addi	a2,a1,32
ffffffffc0203d46:	e390                	sd	a2,0(a5)
ffffffffc0203d48:	e690                	sd	a2,8(a3)
ffffffffc0203d4a:	60a2                	ld	ra,8(sp)
ffffffffc0203d4c:	f59c                	sd	a5,40(a1)
ffffffffc0203d4e:	f194                	sd	a3,32(a1)
ffffffffc0203d50:	2705                	addiw	a4,a4,1
ffffffffc0203d52:	d118                	sw	a4,32(a0)
ffffffffc0203d54:	0141                	addi	sp,sp,16
ffffffffc0203d56:	8082                	ret
ffffffffc0203d58:	fca691e3          	bne	a3,a0,ffffffffc0203d1a <insert_vma_struct+0x26>
ffffffffc0203d5c:	bfd9                	j	ffffffffc0203d32 <insert_vma_struct+0x3e>
ffffffffc0203d5e:	ef5ff0ef          	jal	ffffffffc0203c52 <check_vma_overlap.part.0>
ffffffffc0203d62:	00009697          	auipc	a3,0x9
ffffffffc0203d66:	12e68693          	addi	a3,a3,302 # ffffffffc020ce90 <etext+0x16cc>
ffffffffc0203d6a:	00008617          	auipc	a2,0x8
ffffffffc0203d6e:	e9660613          	addi	a2,a2,-362 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203d72:	07a00593          	li	a1,122
ffffffffc0203d76:	00009517          	auipc	a0,0x9
ffffffffc0203d7a:	10a50513          	addi	a0,a0,266 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203d7e:	eccfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203d82:	00009697          	auipc	a3,0x9
ffffffffc0203d86:	14e68693          	addi	a3,a3,334 # ffffffffc020ced0 <etext+0x170c>
ffffffffc0203d8a:	00008617          	auipc	a2,0x8
ffffffffc0203d8e:	e7660613          	addi	a2,a2,-394 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203d92:	07300593          	li	a1,115
ffffffffc0203d96:	00009517          	auipc	a0,0x9
ffffffffc0203d9a:	0ea50513          	addi	a0,a0,234 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203d9e:	eacfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203da2:	00009697          	auipc	a3,0x9
ffffffffc0203da6:	10e68693          	addi	a3,a3,270 # ffffffffc020ceb0 <etext+0x16ec>
ffffffffc0203daa:	00008617          	auipc	a2,0x8
ffffffffc0203dae:	e5660613          	addi	a2,a2,-426 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203db2:	07200593          	li	a1,114
ffffffffc0203db6:	00009517          	auipc	a0,0x9
ffffffffc0203dba:	0ca50513          	addi	a0,a0,202 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203dbe:	e8cfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203dc2 <mm_destroy>:
ffffffffc0203dc2:	591c                	lw	a5,48(a0)
ffffffffc0203dc4:	1141                	addi	sp,sp,-16
ffffffffc0203dc6:	e406                	sd	ra,8(sp)
ffffffffc0203dc8:	e022                	sd	s0,0(sp)
ffffffffc0203dca:	e78d                	bnez	a5,ffffffffc0203df4 <mm_destroy+0x32>
ffffffffc0203dcc:	842a                	mv	s0,a0
ffffffffc0203dce:	6508                	ld	a0,8(a0)
ffffffffc0203dd0:	00a40c63          	beq	s0,a0,ffffffffc0203de8 <mm_destroy+0x26>
ffffffffc0203dd4:	6118                	ld	a4,0(a0)
ffffffffc0203dd6:	651c                	ld	a5,8(a0)
ffffffffc0203dd8:	1501                	addi	a0,a0,-32
ffffffffc0203dda:	e71c                	sd	a5,8(a4)
ffffffffc0203ddc:	e398                	sd	a4,0(a5)
ffffffffc0203dde:	a88fe0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0203de2:	6408                	ld	a0,8(s0)
ffffffffc0203de4:	fea418e3          	bne	s0,a0,ffffffffc0203dd4 <mm_destroy+0x12>
ffffffffc0203de8:	8522                	mv	a0,s0
ffffffffc0203dea:	6402                	ld	s0,0(sp)
ffffffffc0203dec:	60a2                	ld	ra,8(sp)
ffffffffc0203dee:	0141                	addi	sp,sp,16
ffffffffc0203df0:	a76fe06f          	j	ffffffffc0202066 <kfree>
ffffffffc0203df4:	00009697          	auipc	a3,0x9
ffffffffc0203df8:	0fc68693          	addi	a3,a3,252 # ffffffffc020cef0 <etext+0x172c>
ffffffffc0203dfc:	00008617          	auipc	a2,0x8
ffffffffc0203e00:	e0460613          	addi	a2,a2,-508 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203e04:	09e00593          	li	a1,158
ffffffffc0203e08:	00009517          	auipc	a0,0x9
ffffffffc0203e0c:	07850513          	addi	a0,a0,120 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203e10:	e3afc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203e14 <mm_map>:
ffffffffc0203e14:	6785                	lui	a5,0x1
ffffffffc0203e16:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203e18:	963e                	add	a2,a2,a5
ffffffffc0203e1a:	4785                	li	a5,1
ffffffffc0203e1c:	7139                	addi	sp,sp,-64
ffffffffc0203e1e:	962e                	add	a2,a2,a1
ffffffffc0203e20:	787d                	lui	a6,0xfffff
ffffffffc0203e22:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e24:	f822                	sd	s0,48(sp)
ffffffffc0203e26:	f426                	sd	s1,40(sp)
ffffffffc0203e28:	01067433          	and	s0,a2,a6
ffffffffc0203e2c:	0105f4b3          	and	s1,a1,a6
ffffffffc0203e30:	0785                	addi	a5,a5,1
ffffffffc0203e32:	0084b633          	sltu	a2,s1,s0
ffffffffc0203e36:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203e3a:	00163613          	seqz	a2,a2
ffffffffc0203e3e:	0017b793          	seqz	a5,a5
ffffffffc0203e42:	fc06                	sd	ra,56(sp)
ffffffffc0203e44:	8fd1                	or	a5,a5,a2
ffffffffc0203e46:	ebbd                	bnez	a5,ffffffffc0203ebc <mm_map+0xa8>
ffffffffc0203e48:	002007b7          	lui	a5,0x200
ffffffffc0203e4c:	06f4e863          	bltu	s1,a5,ffffffffc0203ebc <mm_map+0xa8>
ffffffffc0203e50:	f04a                	sd	s2,32(sp)
ffffffffc0203e52:	ec4e                	sd	s3,24(sp)
ffffffffc0203e54:	e852                	sd	s4,16(sp)
ffffffffc0203e56:	892a                	mv	s2,a0
ffffffffc0203e58:	89ba                	mv	s3,a4
ffffffffc0203e5a:	8a36                	mv	s4,a3
ffffffffc0203e5c:	c135                	beqz	a0,ffffffffc0203ec0 <mm_map+0xac>
ffffffffc0203e5e:	85a6                	mv	a1,s1
ffffffffc0203e60:	e55ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc0203e64:	c501                	beqz	a0,ffffffffc0203e6c <mm_map+0x58>
ffffffffc0203e66:	651c                	ld	a5,8(a0)
ffffffffc0203e68:	0487e763          	bltu	a5,s0,ffffffffc0203eb6 <mm_map+0xa2>
ffffffffc0203e6c:	03000513          	li	a0,48
ffffffffc0203e70:	950fe0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0203e74:	85aa                	mv	a1,a0
ffffffffc0203e76:	5571                	li	a0,-4
ffffffffc0203e78:	c59d                	beqz	a1,ffffffffc0203ea6 <mm_map+0x92>
ffffffffc0203e7a:	e584                	sd	s1,8(a1)
ffffffffc0203e7c:	e980                	sd	s0,16(a1)
ffffffffc0203e7e:	0145ac23          	sw	s4,24(a1)
ffffffffc0203e82:	854a                	mv	a0,s2
ffffffffc0203e84:	e42e                	sd	a1,8(sp)
ffffffffc0203e86:	e6fff0ef          	jal	ffffffffc0203cf4 <insert_vma_struct>
ffffffffc0203e8a:	65a2                	ld	a1,8(sp)
ffffffffc0203e8c:	00098463          	beqz	s3,ffffffffc0203e94 <mm_map+0x80>
ffffffffc0203e90:	00b9b023          	sd	a1,0(s3)
ffffffffc0203e94:	7902                	ld	s2,32(sp)
ffffffffc0203e96:	69e2                	ld	s3,24(sp)
ffffffffc0203e98:	6a42                	ld	s4,16(sp)
ffffffffc0203e9a:	4501                	li	a0,0
ffffffffc0203e9c:	70e2                	ld	ra,56(sp)
ffffffffc0203e9e:	7442                	ld	s0,48(sp)
ffffffffc0203ea0:	74a2                	ld	s1,40(sp)
ffffffffc0203ea2:	6121                	addi	sp,sp,64
ffffffffc0203ea4:	8082                	ret
ffffffffc0203ea6:	70e2                	ld	ra,56(sp)
ffffffffc0203ea8:	7442                	ld	s0,48(sp)
ffffffffc0203eaa:	7902                	ld	s2,32(sp)
ffffffffc0203eac:	69e2                	ld	s3,24(sp)
ffffffffc0203eae:	6a42                	ld	s4,16(sp)
ffffffffc0203eb0:	74a2                	ld	s1,40(sp)
ffffffffc0203eb2:	6121                	addi	sp,sp,64
ffffffffc0203eb4:	8082                	ret
ffffffffc0203eb6:	7902                	ld	s2,32(sp)
ffffffffc0203eb8:	69e2                	ld	s3,24(sp)
ffffffffc0203eba:	6a42                	ld	s4,16(sp)
ffffffffc0203ebc:	5575                	li	a0,-3
ffffffffc0203ebe:	bff9                	j	ffffffffc0203e9c <mm_map+0x88>
ffffffffc0203ec0:	00009697          	auipc	a3,0x9
ffffffffc0203ec4:	04868693          	addi	a3,a3,72 # ffffffffc020cf08 <etext+0x1744>
ffffffffc0203ec8:	00008617          	auipc	a2,0x8
ffffffffc0203ecc:	d3860613          	addi	a2,a2,-712 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203ed0:	0b300593          	li	a1,179
ffffffffc0203ed4:	00009517          	auipc	a0,0x9
ffffffffc0203ed8:	fac50513          	addi	a0,a0,-84 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203edc:	d6efc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203ee0 <dup_mmap>:
ffffffffc0203ee0:	7139                	addi	sp,sp,-64
ffffffffc0203ee2:	fc06                	sd	ra,56(sp)
ffffffffc0203ee4:	f822                	sd	s0,48(sp)
ffffffffc0203ee6:	f426                	sd	s1,40(sp)
ffffffffc0203ee8:	f04a                	sd	s2,32(sp)
ffffffffc0203eea:	ec4e                	sd	s3,24(sp)
ffffffffc0203eec:	e852                	sd	s4,16(sp)
ffffffffc0203eee:	e456                	sd	s5,8(sp)
ffffffffc0203ef0:	c525                	beqz	a0,ffffffffc0203f58 <dup_mmap+0x78>
ffffffffc0203ef2:	892a                	mv	s2,a0
ffffffffc0203ef4:	84ae                	mv	s1,a1
ffffffffc0203ef6:	842e                	mv	s0,a1
ffffffffc0203ef8:	c1a5                	beqz	a1,ffffffffc0203f58 <dup_mmap+0x78>
ffffffffc0203efa:	6000                	ld	s0,0(s0)
ffffffffc0203efc:	04848c63          	beq	s1,s0,ffffffffc0203f54 <dup_mmap+0x74>
ffffffffc0203f00:	03000513          	li	a0,48
ffffffffc0203f04:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203f08:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203f0c:	ff842983          	lw	s3,-8(s0)
ffffffffc0203f10:	8b0fe0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0203f14:	c515                	beqz	a0,ffffffffc0203f40 <dup_mmap+0x60>
ffffffffc0203f16:	85aa                	mv	a1,a0
ffffffffc0203f18:	01553423          	sd	s5,8(a0)
ffffffffc0203f1c:	01453823          	sd	s4,16(a0)
ffffffffc0203f20:	01352c23          	sw	s3,24(a0)
ffffffffc0203f24:	854a                	mv	a0,s2
ffffffffc0203f26:	dcfff0ef          	jal	ffffffffc0203cf4 <insert_vma_struct>
ffffffffc0203f2a:	ff043683          	ld	a3,-16(s0)
ffffffffc0203f2e:	fe843603          	ld	a2,-24(s0)
ffffffffc0203f32:	6c8c                	ld	a1,24(s1)
ffffffffc0203f34:	01893503          	ld	a0,24(s2)
ffffffffc0203f38:	4701                	li	a4,0
ffffffffc0203f3a:	9f9ff0ef          	jal	ffffffffc0203932 <copy_range>
ffffffffc0203f3e:	dd55                	beqz	a0,ffffffffc0203efa <dup_mmap+0x1a>
ffffffffc0203f40:	5571                	li	a0,-4
ffffffffc0203f42:	70e2                	ld	ra,56(sp)
ffffffffc0203f44:	7442                	ld	s0,48(sp)
ffffffffc0203f46:	74a2                	ld	s1,40(sp)
ffffffffc0203f48:	7902                	ld	s2,32(sp)
ffffffffc0203f4a:	69e2                	ld	s3,24(sp)
ffffffffc0203f4c:	6a42                	ld	s4,16(sp)
ffffffffc0203f4e:	6aa2                	ld	s5,8(sp)
ffffffffc0203f50:	6121                	addi	sp,sp,64
ffffffffc0203f52:	8082                	ret
ffffffffc0203f54:	4501                	li	a0,0
ffffffffc0203f56:	b7f5                	j	ffffffffc0203f42 <dup_mmap+0x62>
ffffffffc0203f58:	00009697          	auipc	a3,0x9
ffffffffc0203f5c:	fc068693          	addi	a3,a3,-64 # ffffffffc020cf18 <etext+0x1754>
ffffffffc0203f60:	00008617          	auipc	a2,0x8
ffffffffc0203f64:	ca060613          	addi	a2,a2,-864 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203f68:	0cf00593          	li	a1,207
ffffffffc0203f6c:	00009517          	auipc	a0,0x9
ffffffffc0203f70:	f1450513          	addi	a0,a0,-236 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203f74:	cd6fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203f78 <exit_mmap>:
ffffffffc0203f78:	1101                	addi	sp,sp,-32
ffffffffc0203f7a:	ec06                	sd	ra,24(sp)
ffffffffc0203f7c:	e822                	sd	s0,16(sp)
ffffffffc0203f7e:	e426                	sd	s1,8(sp)
ffffffffc0203f80:	e04a                	sd	s2,0(sp)
ffffffffc0203f82:	c531                	beqz	a0,ffffffffc0203fce <exit_mmap+0x56>
ffffffffc0203f84:	591c                	lw	a5,48(a0)
ffffffffc0203f86:	84aa                	mv	s1,a0
ffffffffc0203f88:	e3b9                	bnez	a5,ffffffffc0203fce <exit_mmap+0x56>
ffffffffc0203f8a:	6500                	ld	s0,8(a0)
ffffffffc0203f8c:	01853903          	ld	s2,24(a0)
ffffffffc0203f90:	02850663          	beq	a0,s0,ffffffffc0203fbc <exit_mmap+0x44>
ffffffffc0203f94:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f98:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f9c:	854a                	mv	a0,s2
ffffffffc0203f9e:	e08fe0ef          	jal	ffffffffc02025a6 <unmap_range>
ffffffffc0203fa2:	6400                	ld	s0,8(s0)
ffffffffc0203fa4:	fe8498e3          	bne	s1,s0,ffffffffc0203f94 <exit_mmap+0x1c>
ffffffffc0203fa8:	6400                	ld	s0,8(s0)
ffffffffc0203faa:	00848c63          	beq	s1,s0,ffffffffc0203fc2 <exit_mmap+0x4a>
ffffffffc0203fae:	ff043603          	ld	a2,-16(s0)
ffffffffc0203fb2:	fe843583          	ld	a1,-24(s0)
ffffffffc0203fb6:	854a                	mv	a0,s2
ffffffffc0203fb8:	f22fe0ef          	jal	ffffffffc02026da <exit_range>
ffffffffc0203fbc:	6400                	ld	s0,8(s0)
ffffffffc0203fbe:	fe8498e3          	bne	s1,s0,ffffffffc0203fae <exit_mmap+0x36>
ffffffffc0203fc2:	60e2                	ld	ra,24(sp)
ffffffffc0203fc4:	6442                	ld	s0,16(sp)
ffffffffc0203fc6:	64a2                	ld	s1,8(sp)
ffffffffc0203fc8:	6902                	ld	s2,0(sp)
ffffffffc0203fca:	6105                	addi	sp,sp,32
ffffffffc0203fcc:	8082                	ret
ffffffffc0203fce:	00009697          	auipc	a3,0x9
ffffffffc0203fd2:	f6a68693          	addi	a3,a3,-150 # ffffffffc020cf38 <etext+0x1774>
ffffffffc0203fd6:	00008617          	auipc	a2,0x8
ffffffffc0203fda:	c2a60613          	addi	a2,a2,-982 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0203fde:	0e800593          	li	a1,232
ffffffffc0203fe2:	00009517          	auipc	a0,0x9
ffffffffc0203fe6:	e9e50513          	addi	a0,a0,-354 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0203fea:	c60fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203fee <vmm_init>:
ffffffffc0203fee:	7179                	addi	sp,sp,-48
ffffffffc0203ff0:	05800513          	li	a0,88
ffffffffc0203ff4:	f406                	sd	ra,40(sp)
ffffffffc0203ff6:	f022                	sd	s0,32(sp)
ffffffffc0203ff8:	ec26                	sd	s1,24(sp)
ffffffffc0203ffa:	e84a                	sd	s2,16(sp)
ffffffffc0203ffc:	e44e                	sd	s3,8(sp)
ffffffffc0203ffe:	e052                	sd	s4,0(sp)
ffffffffc0204000:	fc1fd0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0204004:	16050f63          	beqz	a0,ffffffffc0204182 <vmm_init+0x194>
ffffffffc0204008:	e508                	sd	a0,8(a0)
ffffffffc020400a:	e108                	sd	a0,0(a0)
ffffffffc020400c:	00053823          	sd	zero,16(a0)
ffffffffc0204010:	00053c23          	sd	zero,24(a0)
ffffffffc0204014:	02052023          	sw	zero,32(a0)
ffffffffc0204018:	02053423          	sd	zero,40(a0)
ffffffffc020401c:	02052823          	sw	zero,48(a0)
ffffffffc0204020:	842a                	mv	s0,a0
ffffffffc0204022:	4585                	li	a1,1
ffffffffc0204024:	03850513          	addi	a0,a0,56
ffffffffc0204028:	5c4000ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc020402c:	03200493          	li	s1,50
ffffffffc0204030:	03000513          	li	a0,48
ffffffffc0204034:	f8dfd0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0204038:	12050563          	beqz	a0,ffffffffc0204162 <vmm_init+0x174>
ffffffffc020403c:	00248793          	addi	a5,s1,2
ffffffffc0204040:	e504                	sd	s1,8(a0)
ffffffffc0204042:	00052c23          	sw	zero,24(a0)
ffffffffc0204046:	e91c                	sd	a5,16(a0)
ffffffffc0204048:	85aa                	mv	a1,a0
ffffffffc020404a:	14ed                	addi	s1,s1,-5
ffffffffc020404c:	8522                	mv	a0,s0
ffffffffc020404e:	ca7ff0ef          	jal	ffffffffc0203cf4 <insert_vma_struct>
ffffffffc0204052:	fcf9                	bnez	s1,ffffffffc0204030 <vmm_init+0x42>
ffffffffc0204054:	03700493          	li	s1,55
ffffffffc0204058:	1f900913          	li	s2,505
ffffffffc020405c:	03000513          	li	a0,48
ffffffffc0204060:	f61fd0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0204064:	12050f63          	beqz	a0,ffffffffc02041a2 <vmm_init+0x1b4>
ffffffffc0204068:	00248793          	addi	a5,s1,2
ffffffffc020406c:	e504                	sd	s1,8(a0)
ffffffffc020406e:	00052c23          	sw	zero,24(a0)
ffffffffc0204072:	e91c                	sd	a5,16(a0)
ffffffffc0204074:	85aa                	mv	a1,a0
ffffffffc0204076:	0495                	addi	s1,s1,5
ffffffffc0204078:	8522                	mv	a0,s0
ffffffffc020407a:	c7bff0ef          	jal	ffffffffc0203cf4 <insert_vma_struct>
ffffffffc020407e:	fd249fe3          	bne	s1,s2,ffffffffc020405c <vmm_init+0x6e>
ffffffffc0204082:	641c                	ld	a5,8(s0)
ffffffffc0204084:	471d                	li	a4,7
ffffffffc0204086:	1fb00593          	li	a1,507
ffffffffc020408a:	1ef40c63          	beq	s0,a5,ffffffffc0204282 <vmm_init+0x294>
ffffffffc020408e:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0204092:	ffe70693          	addi	a3,a4,-2
ffffffffc0204096:	12d61663          	bne	a2,a3,ffffffffc02041c2 <vmm_init+0x1d4>
ffffffffc020409a:	ff07b683          	ld	a3,-16(a5)
ffffffffc020409e:	12e69263          	bne	a3,a4,ffffffffc02041c2 <vmm_init+0x1d4>
ffffffffc02040a2:	0715                	addi	a4,a4,5
ffffffffc02040a4:	679c                	ld	a5,8(a5)
ffffffffc02040a6:	feb712e3          	bne	a4,a1,ffffffffc020408a <vmm_init+0x9c>
ffffffffc02040aa:	491d                	li	s2,7
ffffffffc02040ac:	4495                	li	s1,5
ffffffffc02040ae:	85a6                	mv	a1,s1
ffffffffc02040b0:	8522                	mv	a0,s0
ffffffffc02040b2:	c03ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc02040b6:	8a2a                	mv	s4,a0
ffffffffc02040b8:	20050563          	beqz	a0,ffffffffc02042c2 <vmm_init+0x2d4>
ffffffffc02040bc:	00148593          	addi	a1,s1,1
ffffffffc02040c0:	8522                	mv	a0,s0
ffffffffc02040c2:	bf3ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc02040c6:	89aa                	mv	s3,a0
ffffffffc02040c8:	1c050d63          	beqz	a0,ffffffffc02042a2 <vmm_init+0x2b4>
ffffffffc02040cc:	85ca                	mv	a1,s2
ffffffffc02040ce:	8522                	mv	a0,s0
ffffffffc02040d0:	be5ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc02040d4:	18051763          	bnez	a0,ffffffffc0204262 <vmm_init+0x274>
ffffffffc02040d8:	00348593          	addi	a1,s1,3
ffffffffc02040dc:	8522                	mv	a0,s0
ffffffffc02040de:	bd7ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc02040e2:	16051063          	bnez	a0,ffffffffc0204242 <vmm_init+0x254>
ffffffffc02040e6:	00448593          	addi	a1,s1,4
ffffffffc02040ea:	8522                	mv	a0,s0
ffffffffc02040ec:	bc9ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc02040f0:	12051963          	bnez	a0,ffffffffc0204222 <vmm_init+0x234>
ffffffffc02040f4:	008a3783          	ld	a5,8(s4)
ffffffffc02040f8:	10979563          	bne	a5,s1,ffffffffc0204202 <vmm_init+0x214>
ffffffffc02040fc:	010a3783          	ld	a5,16(s4)
ffffffffc0204100:	11279163          	bne	a5,s2,ffffffffc0204202 <vmm_init+0x214>
ffffffffc0204104:	0089b783          	ld	a5,8(s3)
ffffffffc0204108:	0c979d63          	bne	a5,s1,ffffffffc02041e2 <vmm_init+0x1f4>
ffffffffc020410c:	0109b783          	ld	a5,16(s3)
ffffffffc0204110:	0d279963          	bne	a5,s2,ffffffffc02041e2 <vmm_init+0x1f4>
ffffffffc0204114:	0495                	addi	s1,s1,5
ffffffffc0204116:	1f900793          	li	a5,505
ffffffffc020411a:	0915                	addi	s2,s2,5
ffffffffc020411c:	f8f499e3          	bne	s1,a5,ffffffffc02040ae <vmm_init+0xc0>
ffffffffc0204120:	4491                	li	s1,4
ffffffffc0204122:	597d                	li	s2,-1
ffffffffc0204124:	85a6                	mv	a1,s1
ffffffffc0204126:	8522                	mv	a0,s0
ffffffffc0204128:	b8dff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc020412c:	1a051b63          	bnez	a0,ffffffffc02042e2 <vmm_init+0x2f4>
ffffffffc0204130:	14fd                	addi	s1,s1,-1
ffffffffc0204132:	ff2499e3          	bne	s1,s2,ffffffffc0204124 <vmm_init+0x136>
ffffffffc0204136:	8522                	mv	a0,s0
ffffffffc0204138:	c8bff0ef          	jal	ffffffffc0203dc2 <mm_destroy>
ffffffffc020413c:	00009517          	auipc	a0,0x9
ffffffffc0204140:	f6c50513          	addi	a0,a0,-148 # ffffffffc020d0a8 <etext+0x18e4>
ffffffffc0204144:	862fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0204148:	7402                	ld	s0,32(sp)
ffffffffc020414a:	70a2                	ld	ra,40(sp)
ffffffffc020414c:	64e2                	ld	s1,24(sp)
ffffffffc020414e:	6942                	ld	s2,16(sp)
ffffffffc0204150:	69a2                	ld	s3,8(sp)
ffffffffc0204152:	6a02                	ld	s4,0(sp)
ffffffffc0204154:	00009517          	auipc	a0,0x9
ffffffffc0204158:	f7450513          	addi	a0,a0,-140 # ffffffffc020d0c8 <etext+0x1904>
ffffffffc020415c:	6145                	addi	sp,sp,48
ffffffffc020415e:	848fc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0204162:	00009697          	auipc	a3,0x9
ffffffffc0204166:	df668693          	addi	a3,a3,-522 # ffffffffc020cf58 <etext+0x1794>
ffffffffc020416a:	00008617          	auipc	a2,0x8
ffffffffc020416e:	a9660613          	addi	a2,a2,-1386 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204172:	12c00593          	li	a1,300
ffffffffc0204176:	00009517          	auipc	a0,0x9
ffffffffc020417a:	d0a50513          	addi	a0,a0,-758 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020417e:	accfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204182:	00009697          	auipc	a3,0x9
ffffffffc0204186:	d8668693          	addi	a3,a3,-634 # ffffffffc020cf08 <etext+0x1744>
ffffffffc020418a:	00008617          	auipc	a2,0x8
ffffffffc020418e:	a7660613          	addi	a2,a2,-1418 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204192:	12400593          	li	a1,292
ffffffffc0204196:	00009517          	auipc	a0,0x9
ffffffffc020419a:	cea50513          	addi	a0,a0,-790 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020419e:	aacfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041a2:	00009697          	auipc	a3,0x9
ffffffffc02041a6:	db668693          	addi	a3,a3,-586 # ffffffffc020cf58 <etext+0x1794>
ffffffffc02041aa:	00008617          	auipc	a2,0x8
ffffffffc02041ae:	a5660613          	addi	a2,a2,-1450 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02041b2:	13300593          	li	a1,307
ffffffffc02041b6:	00009517          	auipc	a0,0x9
ffffffffc02041ba:	cca50513          	addi	a0,a0,-822 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc02041be:	a8cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041c2:	00009697          	auipc	a3,0x9
ffffffffc02041c6:	dbe68693          	addi	a3,a3,-578 # ffffffffc020cf80 <etext+0x17bc>
ffffffffc02041ca:	00008617          	auipc	a2,0x8
ffffffffc02041ce:	a3660613          	addi	a2,a2,-1482 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02041d2:	13d00593          	li	a1,317
ffffffffc02041d6:	00009517          	auipc	a0,0x9
ffffffffc02041da:	caa50513          	addi	a0,a0,-854 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc02041de:	a6cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041e2:	00009697          	auipc	a3,0x9
ffffffffc02041e6:	e5668693          	addi	a3,a3,-426 # ffffffffc020d038 <etext+0x1874>
ffffffffc02041ea:	00008617          	auipc	a2,0x8
ffffffffc02041ee:	a1660613          	addi	a2,a2,-1514 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02041f2:	14f00593          	li	a1,335
ffffffffc02041f6:	00009517          	auipc	a0,0x9
ffffffffc02041fa:	c8a50513          	addi	a0,a0,-886 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc02041fe:	a4cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204202:	00009697          	auipc	a3,0x9
ffffffffc0204206:	e0668693          	addi	a3,a3,-506 # ffffffffc020d008 <etext+0x1844>
ffffffffc020420a:	00008617          	auipc	a2,0x8
ffffffffc020420e:	9f660613          	addi	a2,a2,-1546 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204212:	14e00593          	li	a1,334
ffffffffc0204216:	00009517          	auipc	a0,0x9
ffffffffc020421a:	c6a50513          	addi	a0,a0,-918 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020421e:	a2cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204222:	00009697          	auipc	a3,0x9
ffffffffc0204226:	dd668693          	addi	a3,a3,-554 # ffffffffc020cff8 <etext+0x1834>
ffffffffc020422a:	00008617          	auipc	a2,0x8
ffffffffc020422e:	9d660613          	addi	a2,a2,-1578 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204232:	14c00593          	li	a1,332
ffffffffc0204236:	00009517          	auipc	a0,0x9
ffffffffc020423a:	c4a50513          	addi	a0,a0,-950 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020423e:	a0cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204242:	00009697          	auipc	a3,0x9
ffffffffc0204246:	da668693          	addi	a3,a3,-602 # ffffffffc020cfe8 <etext+0x1824>
ffffffffc020424a:	00008617          	auipc	a2,0x8
ffffffffc020424e:	9b660613          	addi	a2,a2,-1610 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204252:	14a00593          	li	a1,330
ffffffffc0204256:	00009517          	auipc	a0,0x9
ffffffffc020425a:	c2a50513          	addi	a0,a0,-982 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020425e:	9ecfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204262:	00009697          	auipc	a3,0x9
ffffffffc0204266:	d7668693          	addi	a3,a3,-650 # ffffffffc020cfd8 <etext+0x1814>
ffffffffc020426a:	00008617          	auipc	a2,0x8
ffffffffc020426e:	99660613          	addi	a2,a2,-1642 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204272:	14800593          	li	a1,328
ffffffffc0204276:	00009517          	auipc	a0,0x9
ffffffffc020427a:	c0a50513          	addi	a0,a0,-1014 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020427e:	9ccfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204282:	00009697          	auipc	a3,0x9
ffffffffc0204286:	ce668693          	addi	a3,a3,-794 # ffffffffc020cf68 <etext+0x17a4>
ffffffffc020428a:	00008617          	auipc	a2,0x8
ffffffffc020428e:	97660613          	addi	a2,a2,-1674 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204292:	13b00593          	li	a1,315
ffffffffc0204296:	00009517          	auipc	a0,0x9
ffffffffc020429a:	bea50513          	addi	a0,a0,-1046 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc020429e:	9acfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042a2:	00009697          	auipc	a3,0x9
ffffffffc02042a6:	d2668693          	addi	a3,a3,-730 # ffffffffc020cfc8 <etext+0x1804>
ffffffffc02042aa:	00008617          	auipc	a2,0x8
ffffffffc02042ae:	95660613          	addi	a2,a2,-1706 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02042b2:	14600593          	li	a1,326
ffffffffc02042b6:	00009517          	auipc	a0,0x9
ffffffffc02042ba:	bca50513          	addi	a0,a0,-1078 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc02042be:	98cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042c2:	00009697          	auipc	a3,0x9
ffffffffc02042c6:	cf668693          	addi	a3,a3,-778 # ffffffffc020cfb8 <etext+0x17f4>
ffffffffc02042ca:	00008617          	auipc	a2,0x8
ffffffffc02042ce:	93660613          	addi	a2,a2,-1738 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02042d2:	14400593          	li	a1,324
ffffffffc02042d6:	00009517          	auipc	a0,0x9
ffffffffc02042da:	baa50513          	addi	a0,a0,-1110 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc02042de:	96cfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042e2:	6914                	ld	a3,16(a0)
ffffffffc02042e4:	6510                	ld	a2,8(a0)
ffffffffc02042e6:	0004859b          	sext.w	a1,s1
ffffffffc02042ea:	00009517          	auipc	a0,0x9
ffffffffc02042ee:	d7e50513          	addi	a0,a0,-642 # ffffffffc020d068 <etext+0x18a4>
ffffffffc02042f2:	eb5fb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02042f6:	00009697          	auipc	a3,0x9
ffffffffc02042fa:	d9a68693          	addi	a3,a3,-614 # ffffffffc020d090 <etext+0x18cc>
ffffffffc02042fe:	00008617          	auipc	a2,0x8
ffffffffc0204302:	90260613          	addi	a2,a2,-1790 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204306:	15900593          	li	a1,345
ffffffffc020430a:	00009517          	auipc	a0,0x9
ffffffffc020430e:	b7650513          	addi	a0,a0,-1162 # ffffffffc020ce80 <etext+0x16bc>
ffffffffc0204312:	938fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204316 <user_mem_check>:
ffffffffc0204316:	7179                	addi	sp,sp,-48
ffffffffc0204318:	f022                	sd	s0,32(sp)
ffffffffc020431a:	f406                	sd	ra,40(sp)
ffffffffc020431c:	842e                	mv	s0,a1
ffffffffc020431e:	c52d                	beqz	a0,ffffffffc0204388 <user_mem_check+0x72>
ffffffffc0204320:	002007b7          	lui	a5,0x200
ffffffffc0204324:	04f5ed63          	bltu	a1,a5,ffffffffc020437e <user_mem_check+0x68>
ffffffffc0204328:	ec26                	sd	s1,24(sp)
ffffffffc020432a:	00c584b3          	add	s1,a1,a2
ffffffffc020432e:	0695ff63          	bgeu	a1,s1,ffffffffc02043ac <user_mem_check+0x96>
ffffffffc0204332:	4785                	li	a5,1
ffffffffc0204334:	07fe                	slli	a5,a5,0x1f
ffffffffc0204336:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc0204338:	06f4fa63          	bgeu	s1,a5,ffffffffc02043ac <user_mem_check+0x96>
ffffffffc020433c:	e84a                	sd	s2,16(sp)
ffffffffc020433e:	e44e                	sd	s3,8(sp)
ffffffffc0204340:	8936                	mv	s2,a3
ffffffffc0204342:	89aa                	mv	s3,a0
ffffffffc0204344:	a829                	j	ffffffffc020435e <user_mem_check+0x48>
ffffffffc0204346:	6685                	lui	a3,0x1
ffffffffc0204348:	9736                	add	a4,a4,a3
ffffffffc020434a:	0027f693          	andi	a3,a5,2
ffffffffc020434e:	8ba1                	andi	a5,a5,8
ffffffffc0204350:	c685                	beqz	a3,ffffffffc0204378 <user_mem_check+0x62>
ffffffffc0204352:	c399                	beqz	a5,ffffffffc0204358 <user_mem_check+0x42>
ffffffffc0204354:	02e46263          	bltu	s0,a4,ffffffffc0204378 <user_mem_check+0x62>
ffffffffc0204358:	6900                	ld	s0,16(a0)
ffffffffc020435a:	04947b63          	bgeu	s0,s1,ffffffffc02043b0 <user_mem_check+0x9a>
ffffffffc020435e:	85a2                	mv	a1,s0
ffffffffc0204360:	854e                	mv	a0,s3
ffffffffc0204362:	953ff0ef          	jal	ffffffffc0203cb4 <find_vma>
ffffffffc0204366:	c909                	beqz	a0,ffffffffc0204378 <user_mem_check+0x62>
ffffffffc0204368:	6518                	ld	a4,8(a0)
ffffffffc020436a:	00e46763          	bltu	s0,a4,ffffffffc0204378 <user_mem_check+0x62>
ffffffffc020436e:	4d1c                	lw	a5,24(a0)
ffffffffc0204370:	fc091be3          	bnez	s2,ffffffffc0204346 <user_mem_check+0x30>
ffffffffc0204374:	8b85                	andi	a5,a5,1
ffffffffc0204376:	f3ed                	bnez	a5,ffffffffc0204358 <user_mem_check+0x42>
ffffffffc0204378:	64e2                	ld	s1,24(sp)
ffffffffc020437a:	6942                	ld	s2,16(sp)
ffffffffc020437c:	69a2                	ld	s3,8(sp)
ffffffffc020437e:	4501                	li	a0,0
ffffffffc0204380:	70a2                	ld	ra,40(sp)
ffffffffc0204382:	7402                	ld	s0,32(sp)
ffffffffc0204384:	6145                	addi	sp,sp,48
ffffffffc0204386:	8082                	ret
ffffffffc0204388:	c02007b7          	lui	a5,0xc0200
ffffffffc020438c:	fef5eae3          	bltu	a1,a5,ffffffffc0204380 <user_mem_check+0x6a>
ffffffffc0204390:	c80007b7          	lui	a5,0xc8000
ffffffffc0204394:	962e                	add	a2,a2,a1
ffffffffc0204396:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d696f1>
ffffffffc0204398:	00c5b433          	sltu	s0,a1,a2
ffffffffc020439c:	00f63633          	sltu	a2,a2,a5
ffffffffc02043a0:	70a2                	ld	ra,40(sp)
ffffffffc02043a2:	00867533          	and	a0,a2,s0
ffffffffc02043a6:	7402                	ld	s0,32(sp)
ffffffffc02043a8:	6145                	addi	sp,sp,48
ffffffffc02043aa:	8082                	ret
ffffffffc02043ac:	64e2                	ld	s1,24(sp)
ffffffffc02043ae:	bfc1                	j	ffffffffc020437e <user_mem_check+0x68>
ffffffffc02043b0:	64e2                	ld	s1,24(sp)
ffffffffc02043b2:	6942                	ld	s2,16(sp)
ffffffffc02043b4:	69a2                	ld	s3,8(sp)
ffffffffc02043b6:	4505                	li	a0,1
ffffffffc02043b8:	b7e1                	j	ffffffffc0204380 <user_mem_check+0x6a>

ffffffffc02043ba <copy_from_user>:
ffffffffc02043ba:	7179                	addi	sp,sp,-48
ffffffffc02043bc:	f022                	sd	s0,32(sp)
ffffffffc02043be:	8432                	mv	s0,a2
ffffffffc02043c0:	ec26                	sd	s1,24(sp)
ffffffffc02043c2:	8636                	mv	a2,a3
ffffffffc02043c4:	84ae                	mv	s1,a1
ffffffffc02043c6:	86ba                	mv	a3,a4
ffffffffc02043c8:	85a2                	mv	a1,s0
ffffffffc02043ca:	f406                	sd	ra,40(sp)
ffffffffc02043cc:	e032                	sd	a2,0(sp)
ffffffffc02043ce:	f49ff0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc02043d2:	87aa                	mv	a5,a0
ffffffffc02043d4:	c901                	beqz	a0,ffffffffc02043e4 <copy_from_user+0x2a>
ffffffffc02043d6:	6602                	ld	a2,0(sp)
ffffffffc02043d8:	e42a                	sd	a0,8(sp)
ffffffffc02043da:	85a2                	mv	a1,s0
ffffffffc02043dc:	8526                	mv	a0,s1
ffffffffc02043de:	3ce070ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc02043e2:	67a2                	ld	a5,8(sp)
ffffffffc02043e4:	70a2                	ld	ra,40(sp)
ffffffffc02043e6:	7402                	ld	s0,32(sp)
ffffffffc02043e8:	64e2                	ld	s1,24(sp)
ffffffffc02043ea:	853e                	mv	a0,a5
ffffffffc02043ec:	6145                	addi	sp,sp,48
ffffffffc02043ee:	8082                	ret

ffffffffc02043f0 <copy_to_user>:
ffffffffc02043f0:	7179                	addi	sp,sp,-48
ffffffffc02043f2:	f022                	sd	s0,32(sp)
ffffffffc02043f4:	8436                	mv	s0,a3
ffffffffc02043f6:	e84a                	sd	s2,16(sp)
ffffffffc02043f8:	4685                	li	a3,1
ffffffffc02043fa:	8932                	mv	s2,a2
ffffffffc02043fc:	8622                	mv	a2,s0
ffffffffc02043fe:	ec26                	sd	s1,24(sp)
ffffffffc0204400:	f406                	sd	ra,40(sp)
ffffffffc0204402:	84ae                	mv	s1,a1
ffffffffc0204404:	f13ff0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc0204408:	87aa                	mv	a5,a0
ffffffffc020440a:	c901                	beqz	a0,ffffffffc020441a <copy_to_user+0x2a>
ffffffffc020440c:	e42a                	sd	a0,8(sp)
ffffffffc020440e:	8622                	mv	a2,s0
ffffffffc0204410:	85ca                	mv	a1,s2
ffffffffc0204412:	8526                	mv	a0,s1
ffffffffc0204414:	398070ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0204418:	67a2                	ld	a5,8(sp)
ffffffffc020441a:	70a2                	ld	ra,40(sp)
ffffffffc020441c:	7402                	ld	s0,32(sp)
ffffffffc020441e:	64e2                	ld	s1,24(sp)
ffffffffc0204420:	6942                	ld	s2,16(sp)
ffffffffc0204422:	853e                	mv	a0,a5
ffffffffc0204424:	6145                	addi	sp,sp,48
ffffffffc0204426:	8082                	ret

ffffffffc0204428 <copy_string>:
ffffffffc0204428:	7139                	addi	sp,sp,-64
ffffffffc020442a:	e852                	sd	s4,16(sp)
ffffffffc020442c:	6a05                	lui	s4,0x1
ffffffffc020442e:	9a32                	add	s4,s4,a2
ffffffffc0204430:	77fd                	lui	a5,0xfffff
ffffffffc0204432:	00fa7a33          	and	s4,s4,a5
ffffffffc0204436:	f426                	sd	s1,40(sp)
ffffffffc0204438:	f04a                	sd	s2,32(sp)
ffffffffc020443a:	e456                	sd	s5,8(sp)
ffffffffc020443c:	e05a                	sd	s6,0(sp)
ffffffffc020443e:	fc06                	sd	ra,56(sp)
ffffffffc0204440:	f822                	sd	s0,48(sp)
ffffffffc0204442:	ec4e                	sd	s3,24(sp)
ffffffffc0204444:	84b2                	mv	s1,a2
ffffffffc0204446:	8aae                	mv	s5,a1
ffffffffc0204448:	8936                	mv	s2,a3
ffffffffc020444a:	8b2a                	mv	s6,a0
ffffffffc020444c:	40ca0a33          	sub	s4,s4,a2
ffffffffc0204450:	a015                	j	ffffffffc0204474 <copy_string+0x4c>
ffffffffc0204452:	26e070ef          	jal	ffffffffc020b6c0 <strnlen>
ffffffffc0204456:	87aa                	mv	a5,a0
ffffffffc0204458:	8622                	mv	a2,s0
ffffffffc020445a:	85a6                	mv	a1,s1
ffffffffc020445c:	8556                	mv	a0,s5
ffffffffc020445e:	0487e663          	bltu	a5,s0,ffffffffc02044aa <copy_string+0x82>
ffffffffc0204462:	032a7863          	bgeu	s4,s2,ffffffffc0204492 <copy_string+0x6a>
ffffffffc0204466:	346070ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc020446a:	9aa2                	add	s5,s5,s0
ffffffffc020446c:	94a2                	add	s1,s1,s0
ffffffffc020446e:	40890933          	sub	s2,s2,s0
ffffffffc0204472:	6a05                	lui	s4,0x1
ffffffffc0204474:	4681                	li	a3,0
ffffffffc0204476:	85a6                	mv	a1,s1
ffffffffc0204478:	855a                	mv	a0,s6
ffffffffc020447a:	844a                	mv	s0,s2
ffffffffc020447c:	012a7363          	bgeu	s4,s2,ffffffffc0204482 <copy_string+0x5a>
ffffffffc0204480:	8452                	mv	s0,s4
ffffffffc0204482:	8622                	mv	a2,s0
ffffffffc0204484:	e93ff0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc0204488:	89aa                	mv	s3,a0
ffffffffc020448a:	85a2                	mv	a1,s0
ffffffffc020448c:	8526                	mv	a0,s1
ffffffffc020448e:	fc0992e3          	bnez	s3,ffffffffc0204452 <copy_string+0x2a>
ffffffffc0204492:	4981                	li	s3,0
ffffffffc0204494:	70e2                	ld	ra,56(sp)
ffffffffc0204496:	7442                	ld	s0,48(sp)
ffffffffc0204498:	74a2                	ld	s1,40(sp)
ffffffffc020449a:	7902                	ld	s2,32(sp)
ffffffffc020449c:	6a42                	ld	s4,16(sp)
ffffffffc020449e:	6aa2                	ld	s5,8(sp)
ffffffffc02044a0:	6b02                	ld	s6,0(sp)
ffffffffc02044a2:	854e                	mv	a0,s3
ffffffffc02044a4:	69e2                	ld	s3,24(sp)
ffffffffc02044a6:	6121                	addi	sp,sp,64
ffffffffc02044a8:	8082                	ret
ffffffffc02044aa:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc02044ae:	2fe070ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc02044b2:	b7cd                	j	ffffffffc0204494 <copy_string+0x6c>

ffffffffc02044b4 <__down.constprop.0>:
ffffffffc02044b4:	711d                	addi	sp,sp,-96
ffffffffc02044b6:	ec86                	sd	ra,88(sp)
ffffffffc02044b8:	100027f3          	csrr	a5,sstatus
ffffffffc02044bc:	8b89                	andi	a5,a5,2
ffffffffc02044be:	eba1                	bnez	a5,ffffffffc020450e <__down.constprop.0+0x5a>
ffffffffc02044c0:	411c                	lw	a5,0(a0)
ffffffffc02044c2:	00f05863          	blez	a5,ffffffffc02044d2 <__down.constprop.0+0x1e>
ffffffffc02044c6:	37fd                	addiw	a5,a5,-1
ffffffffc02044c8:	c11c                	sw	a5,0(a0)
ffffffffc02044ca:	60e6                	ld	ra,88(sp)
ffffffffc02044cc:	4501                	li	a0,0
ffffffffc02044ce:	6125                	addi	sp,sp,96
ffffffffc02044d0:	8082                	ret
ffffffffc02044d2:	0521                	addi	a0,a0,8
ffffffffc02044d4:	082c                	addi	a1,sp,24
ffffffffc02044d6:	10000613          	li	a2,256
ffffffffc02044da:	e8a2                	sd	s0,80(sp)
ffffffffc02044dc:	e4a6                	sd	s1,72(sp)
ffffffffc02044de:	0820                	addi	s0,sp,24
ffffffffc02044e0:	84aa                	mv	s1,a0
ffffffffc02044e2:	2d0000ef          	jal	ffffffffc02047b2 <wait_current_set>
ffffffffc02044e6:	7bf020ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc02044ea:	100027f3          	csrr	a5,sstatus
ffffffffc02044ee:	8b89                	andi	a5,a5,2
ffffffffc02044f0:	efa9                	bnez	a5,ffffffffc020454a <__down.constprop.0+0x96>
ffffffffc02044f2:	8522                	mv	a0,s0
ffffffffc02044f4:	192000ef          	jal	ffffffffc0204686 <wait_in_queue>
ffffffffc02044f8:	e521                	bnez	a0,ffffffffc0204540 <__down.constprop.0+0x8c>
ffffffffc02044fa:	5502                	lw	a0,32(sp)
ffffffffc02044fc:	10000793          	li	a5,256
ffffffffc0204500:	6446                	ld	s0,80(sp)
ffffffffc0204502:	64a6                	ld	s1,72(sp)
ffffffffc0204504:	fcf503e3          	beq	a0,a5,ffffffffc02044ca <__down.constprop.0+0x16>
ffffffffc0204508:	60e6                	ld	ra,88(sp)
ffffffffc020450a:	6125                	addi	sp,sp,96
ffffffffc020450c:	8082                	ret
ffffffffc020450e:	e42a                	sd	a0,8(sp)
ffffffffc0204510:	ec8fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0204514:	6522                	ld	a0,8(sp)
ffffffffc0204516:	411c                	lw	a5,0(a0)
ffffffffc0204518:	00f05763          	blez	a5,ffffffffc0204526 <__down.constprop.0+0x72>
ffffffffc020451c:	37fd                	addiw	a5,a5,-1
ffffffffc020451e:	c11c                	sw	a5,0(a0)
ffffffffc0204520:	eb2fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0204524:	b75d                	j	ffffffffc02044ca <__down.constprop.0+0x16>
ffffffffc0204526:	0521                	addi	a0,a0,8
ffffffffc0204528:	082c                	addi	a1,sp,24
ffffffffc020452a:	10000613          	li	a2,256
ffffffffc020452e:	e8a2                	sd	s0,80(sp)
ffffffffc0204530:	e4a6                	sd	s1,72(sp)
ffffffffc0204532:	0820                	addi	s0,sp,24
ffffffffc0204534:	84aa                	mv	s1,a0
ffffffffc0204536:	27c000ef          	jal	ffffffffc02047b2 <wait_current_set>
ffffffffc020453a:	e98fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020453e:	b765                	j	ffffffffc02044e6 <__down.constprop.0+0x32>
ffffffffc0204540:	85a2                	mv	a1,s0
ffffffffc0204542:	8526                	mv	a0,s1
ffffffffc0204544:	0e8000ef          	jal	ffffffffc020462c <wait_queue_del>
ffffffffc0204548:	bf4d                	j	ffffffffc02044fa <__down.constprop.0+0x46>
ffffffffc020454a:	e8efc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020454e:	8522                	mv	a0,s0
ffffffffc0204550:	136000ef          	jal	ffffffffc0204686 <wait_in_queue>
ffffffffc0204554:	e501                	bnez	a0,ffffffffc020455c <__down.constprop.0+0xa8>
ffffffffc0204556:	e7cfc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020455a:	b745                	j	ffffffffc02044fa <__down.constprop.0+0x46>
ffffffffc020455c:	85a2                	mv	a1,s0
ffffffffc020455e:	8526                	mv	a0,s1
ffffffffc0204560:	0cc000ef          	jal	ffffffffc020462c <wait_queue_del>
ffffffffc0204564:	bfcd                	j	ffffffffc0204556 <__down.constprop.0+0xa2>

ffffffffc0204566 <__up.constprop.0>:
ffffffffc0204566:	1101                	addi	sp,sp,-32
ffffffffc0204568:	e426                	sd	s1,8(sp)
ffffffffc020456a:	ec06                	sd	ra,24(sp)
ffffffffc020456c:	e822                	sd	s0,16(sp)
ffffffffc020456e:	e04a                	sd	s2,0(sp)
ffffffffc0204570:	84aa                	mv	s1,a0
ffffffffc0204572:	100027f3          	csrr	a5,sstatus
ffffffffc0204576:	8b89                	andi	a5,a5,2
ffffffffc0204578:	4901                	li	s2,0
ffffffffc020457a:	e7b1                	bnez	a5,ffffffffc02045c6 <__up.constprop.0+0x60>
ffffffffc020457c:	00848413          	addi	s0,s1,8
ffffffffc0204580:	8522                	mv	a0,s0
ffffffffc0204582:	0e8000ef          	jal	ffffffffc020466a <wait_queue_first>
ffffffffc0204586:	cd05                	beqz	a0,ffffffffc02045be <__up.constprop.0+0x58>
ffffffffc0204588:	6118                	ld	a4,0(a0)
ffffffffc020458a:	10000793          	li	a5,256
ffffffffc020458e:	0ec72603          	lw	a2,236(a4)
ffffffffc0204592:	02f61e63          	bne	a2,a5,ffffffffc02045ce <__up.constprop.0+0x68>
ffffffffc0204596:	85aa                	mv	a1,a0
ffffffffc0204598:	4685                	li	a3,1
ffffffffc020459a:	8522                	mv	a0,s0
ffffffffc020459c:	0f8000ef          	jal	ffffffffc0204694 <wakeup_wait>
ffffffffc02045a0:	00091863          	bnez	s2,ffffffffc02045b0 <__up.constprop.0+0x4a>
ffffffffc02045a4:	60e2                	ld	ra,24(sp)
ffffffffc02045a6:	6442                	ld	s0,16(sp)
ffffffffc02045a8:	64a2                	ld	s1,8(sp)
ffffffffc02045aa:	6902                	ld	s2,0(sp)
ffffffffc02045ac:	6105                	addi	sp,sp,32
ffffffffc02045ae:	8082                	ret
ffffffffc02045b0:	6442                	ld	s0,16(sp)
ffffffffc02045b2:	60e2                	ld	ra,24(sp)
ffffffffc02045b4:	64a2                	ld	s1,8(sp)
ffffffffc02045b6:	6902                	ld	s2,0(sp)
ffffffffc02045b8:	6105                	addi	sp,sp,32
ffffffffc02045ba:	e18fc06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc02045be:	409c                	lw	a5,0(s1)
ffffffffc02045c0:	2785                	addiw	a5,a5,1
ffffffffc02045c2:	c09c                	sw	a5,0(s1)
ffffffffc02045c4:	bff1                	j	ffffffffc02045a0 <__up.constprop.0+0x3a>
ffffffffc02045c6:	e12fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02045ca:	4905                	li	s2,1
ffffffffc02045cc:	bf45                	j	ffffffffc020457c <__up.constprop.0+0x16>
ffffffffc02045ce:	00009697          	auipc	a3,0x9
ffffffffc02045d2:	b1268693          	addi	a3,a3,-1262 # ffffffffc020d0e0 <etext+0x191c>
ffffffffc02045d6:	00007617          	auipc	a2,0x7
ffffffffc02045da:	62a60613          	addi	a2,a2,1578 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02045de:	45e5                	li	a1,25
ffffffffc02045e0:	00009517          	auipc	a0,0x9
ffffffffc02045e4:	b2850513          	addi	a0,a0,-1240 # ffffffffc020d108 <etext+0x1944>
ffffffffc02045e8:	e63fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02045ec <sem_init>:
ffffffffc02045ec:	c10c                	sw	a1,0(a0)
ffffffffc02045ee:	0521                	addi	a0,a0,8
ffffffffc02045f0:	a81d                	j	ffffffffc0204626 <wait_queue_init>

ffffffffc02045f2 <up>:
ffffffffc02045f2:	f75ff06f          	j	ffffffffc0204566 <__up.constprop.0>

ffffffffc02045f6 <down>:
ffffffffc02045f6:	1141                	addi	sp,sp,-16
ffffffffc02045f8:	e406                	sd	ra,8(sp)
ffffffffc02045fa:	ebbff0ef          	jal	ffffffffc02044b4 <__down.constprop.0>
ffffffffc02045fe:	e501                	bnez	a0,ffffffffc0204606 <down+0x10>
ffffffffc0204600:	60a2                	ld	ra,8(sp)
ffffffffc0204602:	0141                	addi	sp,sp,16
ffffffffc0204604:	8082                	ret
ffffffffc0204606:	00009697          	auipc	a3,0x9
ffffffffc020460a:	b1268693          	addi	a3,a3,-1262 # ffffffffc020d118 <etext+0x1954>
ffffffffc020460e:	00007617          	auipc	a2,0x7
ffffffffc0204612:	5f260613          	addi	a2,a2,1522 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204616:	04000593          	li	a1,64
ffffffffc020461a:	00009517          	auipc	a0,0x9
ffffffffc020461e:	aee50513          	addi	a0,a0,-1298 # ffffffffc020d108 <etext+0x1944>
ffffffffc0204622:	e29fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204626 <wait_queue_init>:
ffffffffc0204626:	e508                	sd	a0,8(a0)
ffffffffc0204628:	e108                	sd	a0,0(a0)
ffffffffc020462a:	8082                	ret

ffffffffc020462c <wait_queue_del>:
ffffffffc020462c:	7198                	ld	a4,32(a1)
ffffffffc020462e:	01858793          	addi	a5,a1,24
ffffffffc0204632:	00e78b63          	beq	a5,a4,ffffffffc0204648 <wait_queue_del+0x1c>
ffffffffc0204636:	6994                	ld	a3,16(a1)
ffffffffc0204638:	00a69863          	bne	a3,a0,ffffffffc0204648 <wait_queue_del+0x1c>
ffffffffc020463c:	6d94                	ld	a3,24(a1)
ffffffffc020463e:	e698                	sd	a4,8(a3)
ffffffffc0204640:	e314                	sd	a3,0(a4)
ffffffffc0204642:	f19c                	sd	a5,32(a1)
ffffffffc0204644:	ed9c                	sd	a5,24(a1)
ffffffffc0204646:	8082                	ret
ffffffffc0204648:	1141                	addi	sp,sp,-16
ffffffffc020464a:	00009697          	auipc	a3,0x9
ffffffffc020464e:	b2e68693          	addi	a3,a3,-1234 # ffffffffc020d178 <etext+0x19b4>
ffffffffc0204652:	00007617          	auipc	a2,0x7
ffffffffc0204656:	5ae60613          	addi	a2,a2,1454 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020465a:	45f1                	li	a1,28
ffffffffc020465c:	00009517          	auipc	a0,0x9
ffffffffc0204660:	b0450513          	addi	a0,a0,-1276 # ffffffffc020d160 <etext+0x199c>
ffffffffc0204664:	e406                	sd	ra,8(sp)
ffffffffc0204666:	de5fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020466a <wait_queue_first>:
ffffffffc020466a:	651c                	ld	a5,8(a0)
ffffffffc020466c:	00f50563          	beq	a0,a5,ffffffffc0204676 <wait_queue_first+0xc>
ffffffffc0204670:	fe878513          	addi	a0,a5,-24
ffffffffc0204674:	8082                	ret
ffffffffc0204676:	4501                	li	a0,0
ffffffffc0204678:	8082                	ret

ffffffffc020467a <wait_queue_empty>:
ffffffffc020467a:	651c                	ld	a5,8(a0)
ffffffffc020467c:	40a78533          	sub	a0,a5,a0
ffffffffc0204680:	00153513          	seqz	a0,a0
ffffffffc0204684:	8082                	ret

ffffffffc0204686 <wait_in_queue>:
ffffffffc0204686:	711c                	ld	a5,32(a0)
ffffffffc0204688:	0561                	addi	a0,a0,24
ffffffffc020468a:	40a78533          	sub	a0,a5,a0
ffffffffc020468e:	00a03533          	snez	a0,a0
ffffffffc0204692:	8082                	ret

ffffffffc0204694 <wakeup_wait>:
ffffffffc0204694:	e689                	bnez	a3,ffffffffc020469e <wakeup_wait+0xa>
ffffffffc0204696:	6188                	ld	a0,0(a1)
ffffffffc0204698:	c590                	sw	a2,8(a1)
ffffffffc020469a:	5130206f          	j	ffffffffc02073ac <wakeup_proc>
ffffffffc020469e:	7198                	ld	a4,32(a1)
ffffffffc02046a0:	01858793          	addi	a5,a1,24
ffffffffc02046a4:	00e78e63          	beq	a5,a4,ffffffffc02046c0 <wakeup_wait+0x2c>
ffffffffc02046a8:	6994                	ld	a3,16(a1)
ffffffffc02046aa:	00d51b63          	bne	a0,a3,ffffffffc02046c0 <wakeup_wait+0x2c>
ffffffffc02046ae:	6d94                	ld	a3,24(a1)
ffffffffc02046b0:	6188                	ld	a0,0(a1)
ffffffffc02046b2:	e698                	sd	a4,8(a3)
ffffffffc02046b4:	e314                	sd	a3,0(a4)
ffffffffc02046b6:	f19c                	sd	a5,32(a1)
ffffffffc02046b8:	ed9c                	sd	a5,24(a1)
ffffffffc02046ba:	c590                	sw	a2,8(a1)
ffffffffc02046bc:	4f10206f          	j	ffffffffc02073ac <wakeup_proc>
ffffffffc02046c0:	1141                	addi	sp,sp,-16
ffffffffc02046c2:	00009697          	auipc	a3,0x9
ffffffffc02046c6:	ab668693          	addi	a3,a3,-1354 # ffffffffc020d178 <etext+0x19b4>
ffffffffc02046ca:	00007617          	auipc	a2,0x7
ffffffffc02046ce:	53660613          	addi	a2,a2,1334 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02046d2:	45f1                	li	a1,28
ffffffffc02046d4:	00009517          	auipc	a0,0x9
ffffffffc02046d8:	a8c50513          	addi	a0,a0,-1396 # ffffffffc020d160 <etext+0x199c>
ffffffffc02046dc:	e406                	sd	ra,8(sp)
ffffffffc02046de:	d6dfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046e2 <wakeup_queue>:
ffffffffc02046e2:	651c                	ld	a5,8(a0)
ffffffffc02046e4:	0aa78763          	beq	a5,a0,ffffffffc0204792 <wakeup_queue+0xb0>
ffffffffc02046e8:	1101                	addi	sp,sp,-32
ffffffffc02046ea:	e822                	sd	s0,16(sp)
ffffffffc02046ec:	e426                	sd	s1,8(sp)
ffffffffc02046ee:	e04a                	sd	s2,0(sp)
ffffffffc02046f0:	ec06                	sd	ra,24(sp)
ffffffffc02046f2:	892e                	mv	s2,a1
ffffffffc02046f4:	84aa                	mv	s1,a0
ffffffffc02046f6:	fe878413          	addi	s0,a5,-24
ffffffffc02046fa:	ee29                	bnez	a2,ffffffffc0204754 <wakeup_queue+0x72>
ffffffffc02046fc:	6008                	ld	a0,0(s0)
ffffffffc02046fe:	01242423          	sw	s2,8(s0)
ffffffffc0204702:	4ab020ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0204706:	701c                	ld	a5,32(s0)
ffffffffc0204708:	01840713          	addi	a4,s0,24
ffffffffc020470c:	02e78463          	beq	a5,a4,ffffffffc0204734 <wakeup_queue+0x52>
ffffffffc0204710:	6818                	ld	a4,16(s0)
ffffffffc0204712:	02e49163          	bne	s1,a4,ffffffffc0204734 <wakeup_queue+0x52>
ffffffffc0204716:	06f48863          	beq	s1,a5,ffffffffc0204786 <wakeup_queue+0xa4>
ffffffffc020471a:	fe87b503          	ld	a0,-24(a5)
ffffffffc020471e:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204722:	fe878413          	addi	s0,a5,-24
ffffffffc0204726:	487020ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc020472a:	701c                	ld	a5,32(s0)
ffffffffc020472c:	01840713          	addi	a4,s0,24
ffffffffc0204730:	fee790e3          	bne	a5,a4,ffffffffc0204710 <wakeup_queue+0x2e>
ffffffffc0204734:	00009697          	auipc	a3,0x9
ffffffffc0204738:	a4468693          	addi	a3,a3,-1468 # ffffffffc020d178 <etext+0x19b4>
ffffffffc020473c:	00007617          	auipc	a2,0x7
ffffffffc0204740:	4c460613          	addi	a2,a2,1220 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204744:	02200593          	li	a1,34
ffffffffc0204748:	00009517          	auipc	a0,0x9
ffffffffc020474c:	a1850513          	addi	a0,a0,-1512 # ffffffffc020d160 <etext+0x199c>
ffffffffc0204750:	cfbfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204754:	6798                	ld	a4,8(a5)
ffffffffc0204756:	00e79863          	bne	a5,a4,ffffffffc0204766 <wakeup_queue+0x84>
ffffffffc020475a:	a82d                	j	ffffffffc0204794 <wakeup_queue+0xb2>
ffffffffc020475c:	6418                	ld	a4,8(s0)
ffffffffc020475e:	87a2                	mv	a5,s0
ffffffffc0204760:	1421                	addi	s0,s0,-24
ffffffffc0204762:	02e78963          	beq	a5,a4,ffffffffc0204794 <wakeup_queue+0xb2>
ffffffffc0204766:	6814                	ld	a3,16(s0)
ffffffffc0204768:	02d49663          	bne	s1,a3,ffffffffc0204794 <wakeup_queue+0xb2>
ffffffffc020476c:	6c14                	ld	a3,24(s0)
ffffffffc020476e:	6008                	ld	a0,0(s0)
ffffffffc0204770:	e698                	sd	a4,8(a3)
ffffffffc0204772:	e314                	sd	a3,0(a4)
ffffffffc0204774:	f01c                	sd	a5,32(s0)
ffffffffc0204776:	ec1c                	sd	a5,24(s0)
ffffffffc0204778:	01242423          	sw	s2,8(s0)
ffffffffc020477c:	431020ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0204780:	6480                	ld	s0,8(s1)
ffffffffc0204782:	fc849de3          	bne	s1,s0,ffffffffc020475c <wakeup_queue+0x7a>
ffffffffc0204786:	60e2                	ld	ra,24(sp)
ffffffffc0204788:	6442                	ld	s0,16(sp)
ffffffffc020478a:	64a2                	ld	s1,8(sp)
ffffffffc020478c:	6902                	ld	s2,0(sp)
ffffffffc020478e:	6105                	addi	sp,sp,32
ffffffffc0204790:	8082                	ret
ffffffffc0204792:	8082                	ret
ffffffffc0204794:	00009697          	auipc	a3,0x9
ffffffffc0204798:	9e468693          	addi	a3,a3,-1564 # ffffffffc020d178 <etext+0x19b4>
ffffffffc020479c:	00007617          	auipc	a2,0x7
ffffffffc02047a0:	46460613          	addi	a2,a2,1124 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02047a4:	45f1                	li	a1,28
ffffffffc02047a6:	00009517          	auipc	a0,0x9
ffffffffc02047aa:	9ba50513          	addi	a0,a0,-1606 # ffffffffc020d160 <etext+0x199c>
ffffffffc02047ae:	c9dfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047b2 <wait_current_set>:
ffffffffc02047b2:	00092797          	auipc	a5,0x92
ffffffffc02047b6:	1167b783          	ld	a5,278(a5) # ffffffffc02968c8 <current>
ffffffffc02047ba:	c39d                	beqz	a5,ffffffffc02047e0 <wait_current_set+0x2e>
ffffffffc02047bc:	80000737          	lui	a4,0x80000
ffffffffc02047c0:	c598                	sw	a4,8(a1)
ffffffffc02047c2:	01858713          	addi	a4,a1,24
ffffffffc02047c6:	ed98                	sd	a4,24(a1)
ffffffffc02047c8:	e19c                	sd	a5,0(a1)
ffffffffc02047ca:	0ec7a623          	sw	a2,236(a5)
ffffffffc02047ce:	4605                	li	a2,1
ffffffffc02047d0:	6114                	ld	a3,0(a0)
ffffffffc02047d2:	c390                	sw	a2,0(a5)
ffffffffc02047d4:	e988                	sd	a0,16(a1)
ffffffffc02047d6:	e118                	sd	a4,0(a0)
ffffffffc02047d8:	e698                	sd	a4,8(a3)
ffffffffc02047da:	ed94                	sd	a3,24(a1)
ffffffffc02047dc:	f188                	sd	a0,32(a1)
ffffffffc02047de:	8082                	ret
ffffffffc02047e0:	1141                	addi	sp,sp,-16
ffffffffc02047e2:	00009697          	auipc	a3,0x9
ffffffffc02047e6:	9d668693          	addi	a3,a3,-1578 # ffffffffc020d1b8 <etext+0x19f4>
ffffffffc02047ea:	00007617          	auipc	a2,0x7
ffffffffc02047ee:	41660613          	addi	a2,a2,1046 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02047f2:	07400593          	li	a1,116
ffffffffc02047f6:	00009517          	auipc	a0,0x9
ffffffffc02047fa:	96a50513          	addi	a0,a0,-1686 # ffffffffc020d160 <etext+0x199c>
ffffffffc02047fe:	e406                	sd	ra,8(sp)
ffffffffc0204800:	c4bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204804 <get_fd_array.part.0>:
ffffffffc0204804:	1141                	addi	sp,sp,-16
ffffffffc0204806:	00009697          	auipc	a3,0x9
ffffffffc020480a:	9c268693          	addi	a3,a3,-1598 # ffffffffc020d1c8 <etext+0x1a04>
ffffffffc020480e:	00007617          	auipc	a2,0x7
ffffffffc0204812:	3f260613          	addi	a2,a2,1010 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204816:	45d1                	li	a1,20
ffffffffc0204818:	00009517          	auipc	a0,0x9
ffffffffc020481c:	9e050513          	addi	a0,a0,-1568 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204820:	e406                	sd	ra,8(sp)
ffffffffc0204822:	c29fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204826 <fd_array_alloc>:
ffffffffc0204826:	00092797          	auipc	a5,0x92
ffffffffc020482a:	0a27b783          	ld	a5,162(a5) # ffffffffc02968c8 <current>
ffffffffc020482e:	1141                	addi	sp,sp,-16
ffffffffc0204830:	e406                	sd	ra,8(sp)
ffffffffc0204832:	1487b783          	ld	a5,328(a5)
ffffffffc0204836:	cfb9                	beqz	a5,ffffffffc0204894 <fd_array_alloc+0x6e>
ffffffffc0204838:	4b98                	lw	a4,16(a5)
ffffffffc020483a:	04e05d63          	blez	a4,ffffffffc0204894 <fd_array_alloc+0x6e>
ffffffffc020483e:	775d                	lui	a4,0xffff7
ffffffffc0204840:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204844:	679c                	ld	a5,8(a5)
ffffffffc0204846:	02e50763          	beq	a0,a4,ffffffffc0204874 <fd_array_alloc+0x4e>
ffffffffc020484a:	04700713          	li	a4,71
ffffffffc020484e:	04a76163          	bltu	a4,a0,ffffffffc0204890 <fd_array_alloc+0x6a>
ffffffffc0204852:	00351713          	slli	a4,a0,0x3
ffffffffc0204856:	8f09                	sub	a4,a4,a0
ffffffffc0204858:	070e                	slli	a4,a4,0x3
ffffffffc020485a:	97ba                	add	a5,a5,a4
ffffffffc020485c:	4398                	lw	a4,0(a5)
ffffffffc020485e:	e71d                	bnez	a4,ffffffffc020488c <fd_array_alloc+0x66>
ffffffffc0204860:	5b88                	lw	a0,48(a5)
ffffffffc0204862:	e91d                	bnez	a0,ffffffffc0204898 <fd_array_alloc+0x72>
ffffffffc0204864:	4705                	li	a4,1
ffffffffc0204866:	0207b423          	sd	zero,40(a5)
ffffffffc020486a:	c398                	sw	a4,0(a5)
ffffffffc020486c:	e19c                	sd	a5,0(a1)
ffffffffc020486e:	60a2                	ld	ra,8(sp)
ffffffffc0204870:	0141                	addi	sp,sp,16
ffffffffc0204872:	8082                	ret
ffffffffc0204874:	7ff78693          	addi	a3,a5,2047
ffffffffc0204878:	7c168693          	addi	a3,a3,1985
ffffffffc020487c:	4398                	lw	a4,0(a5)
ffffffffc020487e:	d36d                	beqz	a4,ffffffffc0204860 <fd_array_alloc+0x3a>
ffffffffc0204880:	03878793          	addi	a5,a5,56
ffffffffc0204884:	fed79ce3          	bne	a5,a3,ffffffffc020487c <fd_array_alloc+0x56>
ffffffffc0204888:	5529                	li	a0,-22
ffffffffc020488a:	b7d5                	j	ffffffffc020486e <fd_array_alloc+0x48>
ffffffffc020488c:	5545                	li	a0,-15
ffffffffc020488e:	b7c5                	j	ffffffffc020486e <fd_array_alloc+0x48>
ffffffffc0204890:	5575                	li	a0,-3
ffffffffc0204892:	bff1                	j	ffffffffc020486e <fd_array_alloc+0x48>
ffffffffc0204894:	f71ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>
ffffffffc0204898:	00009697          	auipc	a3,0x9
ffffffffc020489c:	97068693          	addi	a3,a3,-1680 # ffffffffc020d208 <etext+0x1a44>
ffffffffc02048a0:	00007617          	auipc	a2,0x7
ffffffffc02048a4:	36060613          	addi	a2,a2,864 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02048a8:	03b00593          	li	a1,59
ffffffffc02048ac:	00009517          	auipc	a0,0x9
ffffffffc02048b0:	94c50513          	addi	a0,a0,-1716 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc02048b4:	b97fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02048b8 <fd_array_free>:
ffffffffc02048b8:	4118                	lw	a4,0(a0)
ffffffffc02048ba:	1101                	addi	sp,sp,-32
ffffffffc02048bc:	ec06                	sd	ra,24(sp)
ffffffffc02048be:	4685                	li	a3,1
ffffffffc02048c0:	ffd77613          	andi	a2,a4,-3
ffffffffc02048c4:	04d61763          	bne	a2,a3,ffffffffc0204912 <fd_array_free+0x5a>
ffffffffc02048c8:	5914                	lw	a3,48(a0)
ffffffffc02048ca:	87aa                	mv	a5,a0
ffffffffc02048cc:	e29d                	bnez	a3,ffffffffc02048f2 <fd_array_free+0x3a>
ffffffffc02048ce:	468d                	li	a3,3
ffffffffc02048d0:	00d70763          	beq	a4,a3,ffffffffc02048de <fd_array_free+0x26>
ffffffffc02048d4:	60e2                	ld	ra,24(sp)
ffffffffc02048d6:	0007a023          	sw	zero,0(a5)
ffffffffc02048da:	6105                	addi	sp,sp,32
ffffffffc02048dc:	8082                	ret
ffffffffc02048de:	7508                	ld	a0,40(a0)
ffffffffc02048e0:	e43e                	sd	a5,8(sp)
ffffffffc02048e2:	205030ef          	jal	ffffffffc02082e6 <vfs_close>
ffffffffc02048e6:	67a2                	ld	a5,8(sp)
ffffffffc02048e8:	60e2                	ld	ra,24(sp)
ffffffffc02048ea:	0007a023          	sw	zero,0(a5)
ffffffffc02048ee:	6105                	addi	sp,sp,32
ffffffffc02048f0:	8082                	ret
ffffffffc02048f2:	00009697          	auipc	a3,0x9
ffffffffc02048f6:	91668693          	addi	a3,a3,-1770 # ffffffffc020d208 <etext+0x1a44>
ffffffffc02048fa:	00007617          	auipc	a2,0x7
ffffffffc02048fe:	30660613          	addi	a2,a2,774 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204902:	04500593          	li	a1,69
ffffffffc0204906:	00009517          	auipc	a0,0x9
ffffffffc020490a:	8f250513          	addi	a0,a0,-1806 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc020490e:	b3dfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204912:	00009697          	auipc	a3,0x9
ffffffffc0204916:	92e68693          	addi	a3,a3,-1746 # ffffffffc020d240 <etext+0x1a7c>
ffffffffc020491a:	00007617          	auipc	a2,0x7
ffffffffc020491e:	2e660613          	addi	a2,a2,742 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204922:	04400593          	li	a1,68
ffffffffc0204926:	00009517          	auipc	a0,0x9
ffffffffc020492a:	8d250513          	addi	a0,a0,-1838 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc020492e:	b1dfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204932 <fd_array_release>:
ffffffffc0204932:	411c                	lw	a5,0(a0)
ffffffffc0204934:	1141                	addi	sp,sp,-16
ffffffffc0204936:	e406                	sd	ra,8(sp)
ffffffffc0204938:	4685                	li	a3,1
ffffffffc020493a:	37f9                	addiw	a5,a5,-2
ffffffffc020493c:	02f6ef63          	bltu	a3,a5,ffffffffc020497a <fd_array_release+0x48>
ffffffffc0204940:	591c                	lw	a5,48(a0)
ffffffffc0204942:	00f05c63          	blez	a5,ffffffffc020495a <fd_array_release+0x28>
ffffffffc0204946:	37fd                	addiw	a5,a5,-1
ffffffffc0204948:	d91c                	sw	a5,48(a0)
ffffffffc020494a:	c781                	beqz	a5,ffffffffc0204952 <fd_array_release+0x20>
ffffffffc020494c:	60a2                	ld	ra,8(sp)
ffffffffc020494e:	0141                	addi	sp,sp,16
ffffffffc0204950:	8082                	ret
ffffffffc0204952:	60a2                	ld	ra,8(sp)
ffffffffc0204954:	0141                	addi	sp,sp,16
ffffffffc0204956:	f63ff06f          	j	ffffffffc02048b8 <fd_array_free>
ffffffffc020495a:	00009697          	auipc	a3,0x9
ffffffffc020495e:	95668693          	addi	a3,a3,-1706 # ffffffffc020d2b0 <etext+0x1aec>
ffffffffc0204962:	00007617          	auipc	a2,0x7
ffffffffc0204966:	29e60613          	addi	a2,a2,670 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020496a:	05600593          	li	a1,86
ffffffffc020496e:	00009517          	auipc	a0,0x9
ffffffffc0204972:	88a50513          	addi	a0,a0,-1910 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204976:	ad5fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020497a:	00009697          	auipc	a3,0x9
ffffffffc020497e:	8fe68693          	addi	a3,a3,-1794 # ffffffffc020d278 <etext+0x1ab4>
ffffffffc0204982:	00007617          	auipc	a2,0x7
ffffffffc0204986:	27e60613          	addi	a2,a2,638 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020498a:	05500593          	li	a1,85
ffffffffc020498e:	00009517          	auipc	a0,0x9
ffffffffc0204992:	86a50513          	addi	a0,a0,-1942 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204996:	ab5fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020499a <fd_array_open.part.0>:
ffffffffc020499a:	1141                	addi	sp,sp,-16
ffffffffc020499c:	00009697          	auipc	a3,0x9
ffffffffc02049a0:	92c68693          	addi	a3,a3,-1748 # ffffffffc020d2c8 <etext+0x1b04>
ffffffffc02049a4:	00007617          	auipc	a2,0x7
ffffffffc02049a8:	25c60613          	addi	a2,a2,604 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02049ac:	05f00593          	li	a1,95
ffffffffc02049b0:	00009517          	auipc	a0,0x9
ffffffffc02049b4:	84850513          	addi	a0,a0,-1976 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc02049b8:	e406                	sd	ra,8(sp)
ffffffffc02049ba:	a91fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02049be <fd_array_init>:
ffffffffc02049be:	4781                	li	a5,0
ffffffffc02049c0:	04800713          	li	a4,72
ffffffffc02049c4:	cd1c                	sw	a5,24(a0)
ffffffffc02049c6:	02052823          	sw	zero,48(a0)
ffffffffc02049ca:	00052023          	sw	zero,0(a0)
ffffffffc02049ce:	2785                	addiw	a5,a5,1
ffffffffc02049d0:	03850513          	addi	a0,a0,56
ffffffffc02049d4:	fee798e3          	bne	a5,a4,ffffffffc02049c4 <fd_array_init+0x6>
ffffffffc02049d8:	8082                	ret

ffffffffc02049da <fd_array_close>:
ffffffffc02049da:	4114                	lw	a3,0(a0)
ffffffffc02049dc:	1101                	addi	sp,sp,-32
ffffffffc02049de:	ec06                	sd	ra,24(sp)
ffffffffc02049e0:	4789                	li	a5,2
ffffffffc02049e2:	04f69863          	bne	a3,a5,ffffffffc0204a32 <fd_array_close+0x58>
ffffffffc02049e6:	591c                	lw	a5,48(a0)
ffffffffc02049e8:	872a                	mv	a4,a0
ffffffffc02049ea:	02f05463          	blez	a5,ffffffffc0204a12 <fd_array_close+0x38>
ffffffffc02049ee:	37fd                	addiw	a5,a5,-1
ffffffffc02049f0:	468d                	li	a3,3
ffffffffc02049f2:	d91c                	sw	a5,48(a0)
ffffffffc02049f4:	c114                	sw	a3,0(a0)
ffffffffc02049f6:	c781                	beqz	a5,ffffffffc02049fe <fd_array_close+0x24>
ffffffffc02049f8:	60e2                	ld	ra,24(sp)
ffffffffc02049fa:	6105                	addi	sp,sp,32
ffffffffc02049fc:	8082                	ret
ffffffffc02049fe:	7508                	ld	a0,40(a0)
ffffffffc0204a00:	e43a                	sd	a4,8(sp)
ffffffffc0204a02:	0e5030ef          	jal	ffffffffc02082e6 <vfs_close>
ffffffffc0204a06:	6722                	ld	a4,8(sp)
ffffffffc0204a08:	60e2                	ld	ra,24(sp)
ffffffffc0204a0a:	00072023          	sw	zero,0(a4)
ffffffffc0204a0e:	6105                	addi	sp,sp,32
ffffffffc0204a10:	8082                	ret
ffffffffc0204a12:	00009697          	auipc	a3,0x9
ffffffffc0204a16:	89e68693          	addi	a3,a3,-1890 # ffffffffc020d2b0 <etext+0x1aec>
ffffffffc0204a1a:	00007617          	auipc	a2,0x7
ffffffffc0204a1e:	1e660613          	addi	a2,a2,486 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204a22:	06800593          	li	a1,104
ffffffffc0204a26:	00008517          	auipc	a0,0x8
ffffffffc0204a2a:	7d250513          	addi	a0,a0,2002 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204a2e:	a1dfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204a32:	00008697          	auipc	a3,0x8
ffffffffc0204a36:	7ee68693          	addi	a3,a3,2030 # ffffffffc020d220 <etext+0x1a5c>
ffffffffc0204a3a:	00007617          	auipc	a2,0x7
ffffffffc0204a3e:	1c660613          	addi	a2,a2,454 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204a42:	06700593          	li	a1,103
ffffffffc0204a46:	00008517          	auipc	a0,0x8
ffffffffc0204a4a:	7b250513          	addi	a0,a0,1970 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204a4e:	9fdfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204a52 <fd_array_dup>:
ffffffffc0204a52:	4118                	lw	a4,0(a0)
ffffffffc0204a54:	1101                	addi	sp,sp,-32
ffffffffc0204a56:	ec06                	sd	ra,24(sp)
ffffffffc0204a58:	e822                	sd	s0,16(sp)
ffffffffc0204a5a:	e426                	sd	s1,8(sp)
ffffffffc0204a5c:	e04a                	sd	s2,0(sp)
ffffffffc0204a5e:	4785                	li	a5,1
ffffffffc0204a60:	04f71563          	bne	a4,a5,ffffffffc0204aaa <fd_array_dup+0x58>
ffffffffc0204a64:	0005a903          	lw	s2,0(a1)
ffffffffc0204a68:	4789                	li	a5,2
ffffffffc0204a6a:	04f91063          	bne	s2,a5,ffffffffc0204aaa <fd_array_dup+0x58>
ffffffffc0204a6e:	719c                	ld	a5,32(a1)
ffffffffc0204a70:	7584                	ld	s1,40(a1)
ffffffffc0204a72:	842a                	mv	s0,a0
ffffffffc0204a74:	f11c                	sd	a5,32(a0)
ffffffffc0204a76:	699c                	ld	a5,16(a1)
ffffffffc0204a78:	6598                	ld	a4,8(a1)
ffffffffc0204a7a:	8526                	mv	a0,s1
ffffffffc0204a7c:	e81c                	sd	a5,16(s0)
ffffffffc0204a7e:	e418                	sd	a4,8(s0)
ffffffffc0204a80:	77b020ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc0204a84:	8526                	mv	a0,s1
ffffffffc0204a86:	77f020ef          	jal	ffffffffc0207a04 <inode_open_inc>
ffffffffc0204a8a:	401c                	lw	a5,0(s0)
ffffffffc0204a8c:	f404                	sd	s1,40(s0)
ffffffffc0204a8e:	17fd                	addi	a5,a5,-1
ffffffffc0204a90:	ef8d                	bnez	a5,ffffffffc0204aca <fd_array_dup+0x78>
ffffffffc0204a92:	cc85                	beqz	s1,ffffffffc0204aca <fd_array_dup+0x78>
ffffffffc0204a94:	581c                	lw	a5,48(s0)
ffffffffc0204a96:	01242023          	sw	s2,0(s0)
ffffffffc0204a9a:	60e2                	ld	ra,24(sp)
ffffffffc0204a9c:	2785                	addiw	a5,a5,1
ffffffffc0204a9e:	d81c                	sw	a5,48(s0)
ffffffffc0204aa0:	6442                	ld	s0,16(sp)
ffffffffc0204aa2:	64a2                	ld	s1,8(sp)
ffffffffc0204aa4:	6902                	ld	s2,0(sp)
ffffffffc0204aa6:	6105                	addi	sp,sp,32
ffffffffc0204aa8:	8082                	ret
ffffffffc0204aaa:	00009697          	auipc	a3,0x9
ffffffffc0204aae:	84e68693          	addi	a3,a3,-1970 # ffffffffc020d2f8 <etext+0x1b34>
ffffffffc0204ab2:	00007617          	auipc	a2,0x7
ffffffffc0204ab6:	14e60613          	addi	a2,a2,334 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204aba:	07300593          	li	a1,115
ffffffffc0204abe:	00008517          	auipc	a0,0x8
ffffffffc0204ac2:	73a50513          	addi	a0,a0,1850 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204ac6:	985fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204aca:	ed1ff0ef          	jal	ffffffffc020499a <fd_array_open.part.0>

ffffffffc0204ace <file_testfd>:
ffffffffc0204ace:	04700793          	li	a5,71
ffffffffc0204ad2:	04a7e263          	bltu	a5,a0,ffffffffc0204b16 <file_testfd+0x48>
ffffffffc0204ad6:	00092797          	auipc	a5,0x92
ffffffffc0204ada:	df27b783          	ld	a5,-526(a5) # ffffffffc02968c8 <current>
ffffffffc0204ade:	1487b783          	ld	a5,328(a5)
ffffffffc0204ae2:	cf85                	beqz	a5,ffffffffc0204b1a <file_testfd+0x4c>
ffffffffc0204ae4:	4b98                	lw	a4,16(a5)
ffffffffc0204ae6:	02e05a63          	blez	a4,ffffffffc0204b1a <file_testfd+0x4c>
ffffffffc0204aea:	6798                	ld	a4,8(a5)
ffffffffc0204aec:	00351793          	slli	a5,a0,0x3
ffffffffc0204af0:	8f89                	sub	a5,a5,a0
ffffffffc0204af2:	078e                	slli	a5,a5,0x3
ffffffffc0204af4:	97ba                	add	a5,a5,a4
ffffffffc0204af6:	4394                	lw	a3,0(a5)
ffffffffc0204af8:	4709                	li	a4,2
ffffffffc0204afa:	00e69e63          	bne	a3,a4,ffffffffc0204b16 <file_testfd+0x48>
ffffffffc0204afe:	4f98                	lw	a4,24(a5)
ffffffffc0204b00:	00a71b63          	bne	a4,a0,ffffffffc0204b16 <file_testfd+0x48>
ffffffffc0204b04:	c199                	beqz	a1,ffffffffc0204b0a <file_testfd+0x3c>
ffffffffc0204b06:	6788                	ld	a0,8(a5)
ffffffffc0204b08:	c901                	beqz	a0,ffffffffc0204b18 <file_testfd+0x4a>
ffffffffc0204b0a:	4505                	li	a0,1
ffffffffc0204b0c:	c611                	beqz	a2,ffffffffc0204b18 <file_testfd+0x4a>
ffffffffc0204b0e:	6b88                	ld	a0,16(a5)
ffffffffc0204b10:	00a03533          	snez	a0,a0
ffffffffc0204b14:	8082                	ret
ffffffffc0204b16:	4501                	li	a0,0
ffffffffc0204b18:	8082                	ret
ffffffffc0204b1a:	1141                	addi	sp,sp,-16
ffffffffc0204b1c:	e406                	sd	ra,8(sp)
ffffffffc0204b1e:	ce7ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc0204b22 <file_open>:
ffffffffc0204b22:	0035f793          	andi	a5,a1,3
ffffffffc0204b26:	470d                	li	a4,3
ffffffffc0204b28:	0ee78563          	beq	a5,a4,ffffffffc0204c12 <file_open+0xf0>
ffffffffc0204b2c:	078e                	slli	a5,a5,0x3
ffffffffc0204b2e:	0000a717          	auipc	a4,0xa
ffffffffc0204b32:	3c270713          	addi	a4,a4,962 # ffffffffc020eef0 <CSWTCH.79>
ffffffffc0204b36:	0000a697          	auipc	a3,0xa
ffffffffc0204b3a:	3d268693          	addi	a3,a3,978 # ffffffffc020ef08 <CSWTCH.78>
ffffffffc0204b3e:	96be                	add	a3,a3,a5
ffffffffc0204b40:	97ba                	add	a5,a5,a4
ffffffffc0204b42:	7159                	addi	sp,sp,-112
ffffffffc0204b44:	639c                	ld	a5,0(a5)
ffffffffc0204b46:	6298                	ld	a4,0(a3)
ffffffffc0204b48:	eca6                	sd	s1,88(sp)
ffffffffc0204b4a:	84aa                	mv	s1,a0
ffffffffc0204b4c:	755d                	lui	a0,0xffff7
ffffffffc0204b4e:	f0a2                	sd	s0,96(sp)
ffffffffc0204b50:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204b54:	842e                	mv	s0,a1
ffffffffc0204b56:	080c                	addi	a1,sp,16
ffffffffc0204b58:	e8ca                	sd	s2,80(sp)
ffffffffc0204b5a:	e4ce                	sd	s3,72(sp)
ffffffffc0204b5c:	f486                	sd	ra,104(sp)
ffffffffc0204b5e:	89be                	mv	s3,a5
ffffffffc0204b60:	893a                	mv	s2,a4
ffffffffc0204b62:	cc5ff0ef          	jal	ffffffffc0204826 <fd_array_alloc>
ffffffffc0204b66:	87aa                	mv	a5,a0
ffffffffc0204b68:	c909                	beqz	a0,ffffffffc0204b7a <file_open+0x58>
ffffffffc0204b6a:	70a6                	ld	ra,104(sp)
ffffffffc0204b6c:	7406                	ld	s0,96(sp)
ffffffffc0204b6e:	64e6                	ld	s1,88(sp)
ffffffffc0204b70:	6946                	ld	s2,80(sp)
ffffffffc0204b72:	69a6                	ld	s3,72(sp)
ffffffffc0204b74:	853e                	mv	a0,a5
ffffffffc0204b76:	6165                	addi	sp,sp,112
ffffffffc0204b78:	8082                	ret
ffffffffc0204b7a:	8526                	mv	a0,s1
ffffffffc0204b7c:	0830                	addi	a2,sp,24
ffffffffc0204b7e:	85a2                	mv	a1,s0
ffffffffc0204b80:	590030ef          	jal	ffffffffc0208110 <vfs_open>
ffffffffc0204b84:	6742                	ld	a4,16(sp)
ffffffffc0204b86:	e141                	bnez	a0,ffffffffc0204c06 <file_open+0xe4>
ffffffffc0204b88:	02073023          	sd	zero,32(a4)
ffffffffc0204b8c:	02047593          	andi	a1,s0,32
ffffffffc0204b90:	c98d                	beqz	a1,ffffffffc0204bc2 <file_open+0xa0>
ffffffffc0204b92:	6562                	ld	a0,24(sp)
ffffffffc0204b94:	c541                	beqz	a0,ffffffffc0204c1c <file_open+0xfa>
ffffffffc0204b96:	793c                	ld	a5,112(a0)
ffffffffc0204b98:	c3d1                	beqz	a5,ffffffffc0204c1c <file_open+0xfa>
ffffffffc0204b9a:	779c                	ld	a5,40(a5)
ffffffffc0204b9c:	c3c1                	beqz	a5,ffffffffc0204c1c <file_open+0xfa>
ffffffffc0204b9e:	00008597          	auipc	a1,0x8
ffffffffc0204ba2:	7e258593          	addi	a1,a1,2018 # ffffffffc020d380 <etext+0x1bbc>
ffffffffc0204ba6:	e43a                	sd	a4,8(sp)
ffffffffc0204ba8:	e02a                	sd	a0,0(sp)
ffffffffc0204baa:	665020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204bae:	6502                	ld	a0,0(sp)
ffffffffc0204bb0:	100c                	addi	a1,sp,32
ffffffffc0204bb2:	793c                	ld	a5,112(a0)
ffffffffc0204bb4:	6562                	ld	a0,24(sp)
ffffffffc0204bb6:	779c                	ld	a5,40(a5)
ffffffffc0204bb8:	9782                	jalr	a5
ffffffffc0204bba:	6722                	ld	a4,8(sp)
ffffffffc0204bbc:	e91d                	bnez	a0,ffffffffc0204bf2 <file_open+0xd0>
ffffffffc0204bbe:	77e2                	ld	a5,56(sp)
ffffffffc0204bc0:	f31c                	sd	a5,32(a4)
ffffffffc0204bc2:	66e2                	ld	a3,24(sp)
ffffffffc0204bc4:	431c                	lw	a5,0(a4)
ffffffffc0204bc6:	01273423          	sd	s2,8(a4)
ffffffffc0204bca:	01373823          	sd	s3,16(a4)
ffffffffc0204bce:	f714                	sd	a3,40(a4)
ffffffffc0204bd0:	17fd                	addi	a5,a5,-1
ffffffffc0204bd2:	e3b9                	bnez	a5,ffffffffc0204c18 <file_open+0xf6>
ffffffffc0204bd4:	c2b1                	beqz	a3,ffffffffc0204c18 <file_open+0xf6>
ffffffffc0204bd6:	5b1c                	lw	a5,48(a4)
ffffffffc0204bd8:	70a6                	ld	ra,104(sp)
ffffffffc0204bda:	7406                	ld	s0,96(sp)
ffffffffc0204bdc:	2785                	addiw	a5,a5,1
ffffffffc0204bde:	db1c                	sw	a5,48(a4)
ffffffffc0204be0:	4f1c                	lw	a5,24(a4)
ffffffffc0204be2:	4689                	li	a3,2
ffffffffc0204be4:	c314                	sw	a3,0(a4)
ffffffffc0204be6:	64e6                	ld	s1,88(sp)
ffffffffc0204be8:	6946                	ld	s2,80(sp)
ffffffffc0204bea:	69a6                	ld	s3,72(sp)
ffffffffc0204bec:	853e                	mv	a0,a5
ffffffffc0204bee:	6165                	addi	sp,sp,112
ffffffffc0204bf0:	8082                	ret
ffffffffc0204bf2:	e42a                	sd	a0,8(sp)
ffffffffc0204bf4:	6562                	ld	a0,24(sp)
ffffffffc0204bf6:	e03a                	sd	a4,0(sp)
ffffffffc0204bf8:	6ee030ef          	jal	ffffffffc02082e6 <vfs_close>
ffffffffc0204bfc:	6502                	ld	a0,0(sp)
ffffffffc0204bfe:	cbbff0ef          	jal	ffffffffc02048b8 <fd_array_free>
ffffffffc0204c02:	67a2                	ld	a5,8(sp)
ffffffffc0204c04:	b79d                	j	ffffffffc0204b6a <file_open+0x48>
ffffffffc0204c06:	e02a                	sd	a0,0(sp)
ffffffffc0204c08:	853a                	mv	a0,a4
ffffffffc0204c0a:	cafff0ef          	jal	ffffffffc02048b8 <fd_array_free>
ffffffffc0204c0e:	6782                	ld	a5,0(sp)
ffffffffc0204c10:	bfa9                	j	ffffffffc0204b6a <file_open+0x48>
ffffffffc0204c12:	57f5                	li	a5,-3
ffffffffc0204c14:	853e                	mv	a0,a5
ffffffffc0204c16:	8082                	ret
ffffffffc0204c18:	d83ff0ef          	jal	ffffffffc020499a <fd_array_open.part.0>
ffffffffc0204c1c:	00008697          	auipc	a3,0x8
ffffffffc0204c20:	71468693          	addi	a3,a3,1812 # ffffffffc020d330 <etext+0x1b6c>
ffffffffc0204c24:	00007617          	auipc	a2,0x7
ffffffffc0204c28:	fdc60613          	addi	a2,a2,-36 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204c2c:	0b500593          	li	a1,181
ffffffffc0204c30:	00008517          	auipc	a0,0x8
ffffffffc0204c34:	5c850513          	addi	a0,a0,1480 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204c38:	813fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204c3c <file_close>:
ffffffffc0204c3c:	04700793          	li	a5,71
ffffffffc0204c40:	04a7e663          	bltu	a5,a0,ffffffffc0204c8c <file_close+0x50>
ffffffffc0204c44:	00092717          	auipc	a4,0x92
ffffffffc0204c48:	c8473703          	ld	a4,-892(a4) # ffffffffc02968c8 <current>
ffffffffc0204c4c:	1141                	addi	sp,sp,-16
ffffffffc0204c4e:	e406                	sd	ra,8(sp)
ffffffffc0204c50:	14873703          	ld	a4,328(a4)
ffffffffc0204c54:	87aa                	mv	a5,a0
ffffffffc0204c56:	cf0d                	beqz	a4,ffffffffc0204c90 <file_close+0x54>
ffffffffc0204c58:	4b14                	lw	a3,16(a4)
ffffffffc0204c5a:	02d05b63          	blez	a3,ffffffffc0204c90 <file_close+0x54>
ffffffffc0204c5e:	6708                	ld	a0,8(a4)
ffffffffc0204c60:	00379713          	slli	a4,a5,0x3
ffffffffc0204c64:	8f1d                	sub	a4,a4,a5
ffffffffc0204c66:	070e                	slli	a4,a4,0x3
ffffffffc0204c68:	953a                	add	a0,a0,a4
ffffffffc0204c6a:	4114                	lw	a3,0(a0)
ffffffffc0204c6c:	4709                	li	a4,2
ffffffffc0204c6e:	00e69b63          	bne	a3,a4,ffffffffc0204c84 <file_close+0x48>
ffffffffc0204c72:	4d18                	lw	a4,24(a0)
ffffffffc0204c74:	00f71863          	bne	a4,a5,ffffffffc0204c84 <file_close+0x48>
ffffffffc0204c78:	d63ff0ef          	jal	ffffffffc02049da <fd_array_close>
ffffffffc0204c7c:	60a2                	ld	ra,8(sp)
ffffffffc0204c7e:	4501                	li	a0,0
ffffffffc0204c80:	0141                	addi	sp,sp,16
ffffffffc0204c82:	8082                	ret
ffffffffc0204c84:	60a2                	ld	ra,8(sp)
ffffffffc0204c86:	5575                	li	a0,-3
ffffffffc0204c88:	0141                	addi	sp,sp,16
ffffffffc0204c8a:	8082                	ret
ffffffffc0204c8c:	5575                	li	a0,-3
ffffffffc0204c8e:	8082                	ret
ffffffffc0204c90:	b75ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc0204c94 <file_read>:
ffffffffc0204c94:	711d                	addi	sp,sp,-96
ffffffffc0204c96:	ec86                	sd	ra,88(sp)
ffffffffc0204c98:	e0ca                	sd	s2,64(sp)
ffffffffc0204c9a:	0006b023          	sd	zero,0(a3)
ffffffffc0204c9e:	04700793          	li	a5,71
ffffffffc0204ca2:	0aa7ec63          	bltu	a5,a0,ffffffffc0204d5a <file_read+0xc6>
ffffffffc0204ca6:	00092797          	auipc	a5,0x92
ffffffffc0204caa:	c227b783          	ld	a5,-990(a5) # ffffffffc02968c8 <current>
ffffffffc0204cae:	e4a6                	sd	s1,72(sp)
ffffffffc0204cb0:	e8a2                	sd	s0,80(sp)
ffffffffc0204cb2:	1487b783          	ld	a5,328(a5)
ffffffffc0204cb6:	fc4e                	sd	s3,56(sp)
ffffffffc0204cb8:	84b6                	mv	s1,a3
ffffffffc0204cba:	c3f1                	beqz	a5,ffffffffc0204d7e <file_read+0xea>
ffffffffc0204cbc:	4b98                	lw	a4,16(a5)
ffffffffc0204cbe:	0ce05063          	blez	a4,ffffffffc0204d7e <file_read+0xea>
ffffffffc0204cc2:	6780                	ld	s0,8(a5)
ffffffffc0204cc4:	00351793          	slli	a5,a0,0x3
ffffffffc0204cc8:	8f89                	sub	a5,a5,a0
ffffffffc0204cca:	078e                	slli	a5,a5,0x3
ffffffffc0204ccc:	943e                	add	s0,s0,a5
ffffffffc0204cce:	00042983          	lw	s3,0(s0)
ffffffffc0204cd2:	4789                	li	a5,2
ffffffffc0204cd4:	06f99a63          	bne	s3,a5,ffffffffc0204d48 <file_read+0xb4>
ffffffffc0204cd8:	4c1c                	lw	a5,24(s0)
ffffffffc0204cda:	06a79763          	bne	a5,a0,ffffffffc0204d48 <file_read+0xb4>
ffffffffc0204cde:	641c                	ld	a5,8(s0)
ffffffffc0204ce0:	c7a5                	beqz	a5,ffffffffc0204d48 <file_read+0xb4>
ffffffffc0204ce2:	581c                	lw	a5,48(s0)
ffffffffc0204ce4:	7014                	ld	a3,32(s0)
ffffffffc0204ce6:	0808                	addi	a0,sp,16
ffffffffc0204ce8:	2785                	addiw	a5,a5,1
ffffffffc0204cea:	d81c                	sw	a5,48(s0)
ffffffffc0204cec:	7a0000ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc0204cf0:	892a                	mv	s2,a0
ffffffffc0204cf2:	7408                	ld	a0,40(s0)
ffffffffc0204cf4:	c52d                	beqz	a0,ffffffffc0204d5e <file_read+0xca>
ffffffffc0204cf6:	793c                	ld	a5,112(a0)
ffffffffc0204cf8:	c3bd                	beqz	a5,ffffffffc0204d5e <file_read+0xca>
ffffffffc0204cfa:	6f9c                	ld	a5,24(a5)
ffffffffc0204cfc:	c3ad                	beqz	a5,ffffffffc0204d5e <file_read+0xca>
ffffffffc0204cfe:	00008597          	auipc	a1,0x8
ffffffffc0204d02:	6da58593          	addi	a1,a1,1754 # ffffffffc020d3d8 <etext+0x1c14>
ffffffffc0204d06:	e42a                	sd	a0,8(sp)
ffffffffc0204d08:	507020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204d0c:	6522                	ld	a0,8(sp)
ffffffffc0204d0e:	85ca                	mv	a1,s2
ffffffffc0204d10:	793c                	ld	a5,112(a0)
ffffffffc0204d12:	7408                	ld	a0,40(s0)
ffffffffc0204d14:	6f9c                	ld	a5,24(a5)
ffffffffc0204d16:	9782                	jalr	a5
ffffffffc0204d18:	01093783          	ld	a5,16(s2)
ffffffffc0204d1c:	01893683          	ld	a3,24(s2)
ffffffffc0204d20:	4018                	lw	a4,0(s0)
ffffffffc0204d22:	892a                	mv	s2,a0
ffffffffc0204d24:	8f95                	sub	a5,a5,a3
ffffffffc0204d26:	01371563          	bne	a4,s3,ffffffffc0204d30 <file_read+0x9c>
ffffffffc0204d2a:	7018                	ld	a4,32(s0)
ffffffffc0204d2c:	973e                	add	a4,a4,a5
ffffffffc0204d2e:	f018                	sd	a4,32(s0)
ffffffffc0204d30:	e09c                	sd	a5,0(s1)
ffffffffc0204d32:	8522                	mv	a0,s0
ffffffffc0204d34:	bffff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc0204d38:	6446                	ld	s0,80(sp)
ffffffffc0204d3a:	64a6                	ld	s1,72(sp)
ffffffffc0204d3c:	79e2                	ld	s3,56(sp)
ffffffffc0204d3e:	60e6                	ld	ra,88(sp)
ffffffffc0204d40:	854a                	mv	a0,s2
ffffffffc0204d42:	6906                	ld	s2,64(sp)
ffffffffc0204d44:	6125                	addi	sp,sp,96
ffffffffc0204d46:	8082                	ret
ffffffffc0204d48:	6446                	ld	s0,80(sp)
ffffffffc0204d4a:	60e6                	ld	ra,88(sp)
ffffffffc0204d4c:	5975                	li	s2,-3
ffffffffc0204d4e:	64a6                	ld	s1,72(sp)
ffffffffc0204d50:	79e2                	ld	s3,56(sp)
ffffffffc0204d52:	854a                	mv	a0,s2
ffffffffc0204d54:	6906                	ld	s2,64(sp)
ffffffffc0204d56:	6125                	addi	sp,sp,96
ffffffffc0204d58:	8082                	ret
ffffffffc0204d5a:	5975                	li	s2,-3
ffffffffc0204d5c:	b7cd                	j	ffffffffc0204d3e <file_read+0xaa>
ffffffffc0204d5e:	00008697          	auipc	a3,0x8
ffffffffc0204d62:	62a68693          	addi	a3,a3,1578 # ffffffffc020d388 <etext+0x1bc4>
ffffffffc0204d66:	00007617          	auipc	a2,0x7
ffffffffc0204d6a:	e9a60613          	addi	a2,a2,-358 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204d6e:	0de00593          	li	a1,222
ffffffffc0204d72:	00008517          	auipc	a0,0x8
ffffffffc0204d76:	48650513          	addi	a0,a0,1158 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204d7a:	ed0fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204d7e:	a87ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc0204d82 <file_write>:
ffffffffc0204d82:	711d                	addi	sp,sp,-96
ffffffffc0204d84:	ec86                	sd	ra,88(sp)
ffffffffc0204d86:	e0ca                	sd	s2,64(sp)
ffffffffc0204d88:	0006b023          	sd	zero,0(a3)
ffffffffc0204d8c:	04700793          	li	a5,71
ffffffffc0204d90:	0aa7ec63          	bltu	a5,a0,ffffffffc0204e48 <file_write+0xc6>
ffffffffc0204d94:	00092797          	auipc	a5,0x92
ffffffffc0204d98:	b347b783          	ld	a5,-1228(a5) # ffffffffc02968c8 <current>
ffffffffc0204d9c:	e4a6                	sd	s1,72(sp)
ffffffffc0204d9e:	e8a2                	sd	s0,80(sp)
ffffffffc0204da0:	1487b783          	ld	a5,328(a5)
ffffffffc0204da4:	fc4e                	sd	s3,56(sp)
ffffffffc0204da6:	84b6                	mv	s1,a3
ffffffffc0204da8:	c3f1                	beqz	a5,ffffffffc0204e6c <file_write+0xea>
ffffffffc0204daa:	4b98                	lw	a4,16(a5)
ffffffffc0204dac:	0ce05063          	blez	a4,ffffffffc0204e6c <file_write+0xea>
ffffffffc0204db0:	6780                	ld	s0,8(a5)
ffffffffc0204db2:	00351793          	slli	a5,a0,0x3
ffffffffc0204db6:	8f89                	sub	a5,a5,a0
ffffffffc0204db8:	078e                	slli	a5,a5,0x3
ffffffffc0204dba:	943e                	add	s0,s0,a5
ffffffffc0204dbc:	00042983          	lw	s3,0(s0)
ffffffffc0204dc0:	4789                	li	a5,2
ffffffffc0204dc2:	06f99a63          	bne	s3,a5,ffffffffc0204e36 <file_write+0xb4>
ffffffffc0204dc6:	4c1c                	lw	a5,24(s0)
ffffffffc0204dc8:	06a79763          	bne	a5,a0,ffffffffc0204e36 <file_write+0xb4>
ffffffffc0204dcc:	681c                	ld	a5,16(s0)
ffffffffc0204dce:	c7a5                	beqz	a5,ffffffffc0204e36 <file_write+0xb4>
ffffffffc0204dd0:	581c                	lw	a5,48(s0)
ffffffffc0204dd2:	7014                	ld	a3,32(s0)
ffffffffc0204dd4:	0808                	addi	a0,sp,16
ffffffffc0204dd6:	2785                	addiw	a5,a5,1
ffffffffc0204dd8:	d81c                	sw	a5,48(s0)
ffffffffc0204dda:	6b2000ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc0204dde:	892a                	mv	s2,a0
ffffffffc0204de0:	7408                	ld	a0,40(s0)
ffffffffc0204de2:	c52d                	beqz	a0,ffffffffc0204e4c <file_write+0xca>
ffffffffc0204de4:	793c                	ld	a5,112(a0)
ffffffffc0204de6:	c3bd                	beqz	a5,ffffffffc0204e4c <file_write+0xca>
ffffffffc0204de8:	739c                	ld	a5,32(a5)
ffffffffc0204dea:	c3ad                	beqz	a5,ffffffffc0204e4c <file_write+0xca>
ffffffffc0204dec:	00008597          	auipc	a1,0x8
ffffffffc0204df0:	64458593          	addi	a1,a1,1604 # ffffffffc020d430 <etext+0x1c6c>
ffffffffc0204df4:	e42a                	sd	a0,8(sp)
ffffffffc0204df6:	419020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204dfa:	6522                	ld	a0,8(sp)
ffffffffc0204dfc:	85ca                	mv	a1,s2
ffffffffc0204dfe:	793c                	ld	a5,112(a0)
ffffffffc0204e00:	7408                	ld	a0,40(s0)
ffffffffc0204e02:	739c                	ld	a5,32(a5)
ffffffffc0204e04:	9782                	jalr	a5
ffffffffc0204e06:	01093783          	ld	a5,16(s2)
ffffffffc0204e0a:	01893683          	ld	a3,24(s2)
ffffffffc0204e0e:	4018                	lw	a4,0(s0)
ffffffffc0204e10:	892a                	mv	s2,a0
ffffffffc0204e12:	8f95                	sub	a5,a5,a3
ffffffffc0204e14:	01371563          	bne	a4,s3,ffffffffc0204e1e <file_write+0x9c>
ffffffffc0204e18:	7018                	ld	a4,32(s0)
ffffffffc0204e1a:	973e                	add	a4,a4,a5
ffffffffc0204e1c:	f018                	sd	a4,32(s0)
ffffffffc0204e1e:	e09c                	sd	a5,0(s1)
ffffffffc0204e20:	8522                	mv	a0,s0
ffffffffc0204e22:	b11ff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc0204e26:	6446                	ld	s0,80(sp)
ffffffffc0204e28:	64a6                	ld	s1,72(sp)
ffffffffc0204e2a:	79e2                	ld	s3,56(sp)
ffffffffc0204e2c:	60e6                	ld	ra,88(sp)
ffffffffc0204e2e:	854a                	mv	a0,s2
ffffffffc0204e30:	6906                	ld	s2,64(sp)
ffffffffc0204e32:	6125                	addi	sp,sp,96
ffffffffc0204e34:	8082                	ret
ffffffffc0204e36:	6446                	ld	s0,80(sp)
ffffffffc0204e38:	60e6                	ld	ra,88(sp)
ffffffffc0204e3a:	5975                	li	s2,-3
ffffffffc0204e3c:	64a6                	ld	s1,72(sp)
ffffffffc0204e3e:	79e2                	ld	s3,56(sp)
ffffffffc0204e40:	854a                	mv	a0,s2
ffffffffc0204e42:	6906                	ld	s2,64(sp)
ffffffffc0204e44:	6125                	addi	sp,sp,96
ffffffffc0204e46:	8082                	ret
ffffffffc0204e48:	5975                	li	s2,-3
ffffffffc0204e4a:	b7cd                	j	ffffffffc0204e2c <file_write+0xaa>
ffffffffc0204e4c:	00008697          	auipc	a3,0x8
ffffffffc0204e50:	59468693          	addi	a3,a3,1428 # ffffffffc020d3e0 <etext+0x1c1c>
ffffffffc0204e54:	00007617          	auipc	a2,0x7
ffffffffc0204e58:	dac60613          	addi	a2,a2,-596 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204e5c:	0f800593          	li	a1,248
ffffffffc0204e60:	00008517          	auipc	a0,0x8
ffffffffc0204e64:	39850513          	addi	a0,a0,920 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204e68:	de2fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204e6c:	999ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc0204e70 <file_seek>:
ffffffffc0204e70:	7139                	addi	sp,sp,-64
ffffffffc0204e72:	fc06                	sd	ra,56(sp)
ffffffffc0204e74:	f426                	sd	s1,40(sp)
ffffffffc0204e76:	04700793          	li	a5,71
ffffffffc0204e7a:	0ca7e563          	bltu	a5,a0,ffffffffc0204f44 <file_seek+0xd4>
ffffffffc0204e7e:	00092797          	auipc	a5,0x92
ffffffffc0204e82:	a4a7b783          	ld	a5,-1462(a5) # ffffffffc02968c8 <current>
ffffffffc0204e86:	f822                	sd	s0,48(sp)
ffffffffc0204e88:	1487b783          	ld	a5,328(a5)
ffffffffc0204e8c:	c3e9                	beqz	a5,ffffffffc0204f4e <file_seek+0xde>
ffffffffc0204e8e:	4b98                	lw	a4,16(a5)
ffffffffc0204e90:	0ae05f63          	blez	a4,ffffffffc0204f4e <file_seek+0xde>
ffffffffc0204e94:	6780                	ld	s0,8(a5)
ffffffffc0204e96:	00351793          	slli	a5,a0,0x3
ffffffffc0204e9a:	8f89                	sub	a5,a5,a0
ffffffffc0204e9c:	078e                	slli	a5,a5,0x3
ffffffffc0204e9e:	943e                	add	s0,s0,a5
ffffffffc0204ea0:	4018                	lw	a4,0(s0)
ffffffffc0204ea2:	4789                	li	a5,2
ffffffffc0204ea4:	0af71263          	bne	a4,a5,ffffffffc0204f48 <file_seek+0xd8>
ffffffffc0204ea8:	4c1c                	lw	a5,24(s0)
ffffffffc0204eaa:	f04a                	sd	s2,32(sp)
ffffffffc0204eac:	08a79863          	bne	a5,a0,ffffffffc0204f3c <file_seek+0xcc>
ffffffffc0204eb0:	581c                	lw	a5,48(s0)
ffffffffc0204eb2:	4685                	li	a3,1
ffffffffc0204eb4:	892e                	mv	s2,a1
ffffffffc0204eb6:	2785                	addiw	a5,a5,1
ffffffffc0204eb8:	d81c                	sw	a5,48(s0)
ffffffffc0204eba:	06d60d63          	beq	a2,a3,ffffffffc0204f34 <file_seek+0xc4>
ffffffffc0204ebe:	04e60463          	beq	a2,a4,ffffffffc0204f06 <file_seek+0x96>
ffffffffc0204ec2:	54f5                	li	s1,-3
ffffffffc0204ec4:	e61d                	bnez	a2,ffffffffc0204ef2 <file_seek+0x82>
ffffffffc0204ec6:	7404                	ld	s1,40(s0)
ffffffffc0204ec8:	c4d1                	beqz	s1,ffffffffc0204f54 <file_seek+0xe4>
ffffffffc0204eca:	78bc                	ld	a5,112(s1)
ffffffffc0204ecc:	c7c1                	beqz	a5,ffffffffc0204f54 <file_seek+0xe4>
ffffffffc0204ece:	6fbc                	ld	a5,88(a5)
ffffffffc0204ed0:	c3d1                	beqz	a5,ffffffffc0204f54 <file_seek+0xe4>
ffffffffc0204ed2:	8526                	mv	a0,s1
ffffffffc0204ed4:	00008597          	auipc	a1,0x8
ffffffffc0204ed8:	5b458593          	addi	a1,a1,1460 # ffffffffc020d488 <etext+0x1cc4>
ffffffffc0204edc:	333020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204ee0:	78bc                	ld	a5,112(s1)
ffffffffc0204ee2:	7408                	ld	a0,40(s0)
ffffffffc0204ee4:	85ca                	mv	a1,s2
ffffffffc0204ee6:	6fbc                	ld	a5,88(a5)
ffffffffc0204ee8:	9782                	jalr	a5
ffffffffc0204eea:	84aa                	mv	s1,a0
ffffffffc0204eec:	e119                	bnez	a0,ffffffffc0204ef2 <file_seek+0x82>
ffffffffc0204eee:	03243023          	sd	s2,32(s0)
ffffffffc0204ef2:	8522                	mv	a0,s0
ffffffffc0204ef4:	a3fff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc0204ef8:	7442                	ld	s0,48(sp)
ffffffffc0204efa:	7902                	ld	s2,32(sp)
ffffffffc0204efc:	70e2                	ld	ra,56(sp)
ffffffffc0204efe:	8526                	mv	a0,s1
ffffffffc0204f00:	74a2                	ld	s1,40(sp)
ffffffffc0204f02:	6121                	addi	sp,sp,64
ffffffffc0204f04:	8082                	ret
ffffffffc0204f06:	7404                	ld	s1,40(s0)
ffffffffc0204f08:	c4b5                	beqz	s1,ffffffffc0204f74 <file_seek+0x104>
ffffffffc0204f0a:	78bc                	ld	a5,112(s1)
ffffffffc0204f0c:	c7a5                	beqz	a5,ffffffffc0204f74 <file_seek+0x104>
ffffffffc0204f0e:	779c                	ld	a5,40(a5)
ffffffffc0204f10:	c3b5                	beqz	a5,ffffffffc0204f74 <file_seek+0x104>
ffffffffc0204f12:	8526                	mv	a0,s1
ffffffffc0204f14:	00008597          	auipc	a1,0x8
ffffffffc0204f18:	46c58593          	addi	a1,a1,1132 # ffffffffc020d380 <etext+0x1bbc>
ffffffffc0204f1c:	2f3020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204f20:	78bc                	ld	a5,112(s1)
ffffffffc0204f22:	7408                	ld	a0,40(s0)
ffffffffc0204f24:	858a                	mv	a1,sp
ffffffffc0204f26:	779c                	ld	a5,40(a5)
ffffffffc0204f28:	9782                	jalr	a5
ffffffffc0204f2a:	84aa                	mv	s1,a0
ffffffffc0204f2c:	f179                	bnez	a0,ffffffffc0204ef2 <file_seek+0x82>
ffffffffc0204f2e:	67e2                	ld	a5,24(sp)
ffffffffc0204f30:	993e                	add	s2,s2,a5
ffffffffc0204f32:	bf51                	j	ffffffffc0204ec6 <file_seek+0x56>
ffffffffc0204f34:	701c                	ld	a5,32(s0)
ffffffffc0204f36:	00f58933          	add	s2,a1,a5
ffffffffc0204f3a:	b771                	j	ffffffffc0204ec6 <file_seek+0x56>
ffffffffc0204f3c:	7442                	ld	s0,48(sp)
ffffffffc0204f3e:	7902                	ld	s2,32(sp)
ffffffffc0204f40:	54f5                	li	s1,-3
ffffffffc0204f42:	bf6d                	j	ffffffffc0204efc <file_seek+0x8c>
ffffffffc0204f44:	54f5                	li	s1,-3
ffffffffc0204f46:	bf5d                	j	ffffffffc0204efc <file_seek+0x8c>
ffffffffc0204f48:	7442                	ld	s0,48(sp)
ffffffffc0204f4a:	54f5                	li	s1,-3
ffffffffc0204f4c:	bf45                	j	ffffffffc0204efc <file_seek+0x8c>
ffffffffc0204f4e:	f04a                	sd	s2,32(sp)
ffffffffc0204f50:	8b5ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>
ffffffffc0204f54:	00008697          	auipc	a3,0x8
ffffffffc0204f58:	4e468693          	addi	a3,a3,1252 # ffffffffc020d438 <etext+0x1c74>
ffffffffc0204f5c:	00007617          	auipc	a2,0x7
ffffffffc0204f60:	ca460613          	addi	a2,a2,-860 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204f64:	11a00593          	li	a1,282
ffffffffc0204f68:	00008517          	auipc	a0,0x8
ffffffffc0204f6c:	29050513          	addi	a0,a0,656 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204f70:	cdafb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204f74:	00008697          	auipc	a3,0x8
ffffffffc0204f78:	3bc68693          	addi	a3,a3,956 # ffffffffc020d330 <etext+0x1b6c>
ffffffffc0204f7c:	00007617          	auipc	a2,0x7
ffffffffc0204f80:	c8460613          	addi	a2,a2,-892 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0204f84:	11200593          	li	a1,274
ffffffffc0204f88:	00008517          	auipc	a0,0x8
ffffffffc0204f8c:	27050513          	addi	a0,a0,624 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0204f90:	cbafb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204f94 <file_fstat>:
ffffffffc0204f94:	7179                	addi	sp,sp,-48
ffffffffc0204f96:	f406                	sd	ra,40(sp)
ffffffffc0204f98:	f022                	sd	s0,32(sp)
ffffffffc0204f9a:	04700793          	li	a5,71
ffffffffc0204f9e:	08a7e363          	bltu	a5,a0,ffffffffc0205024 <file_fstat+0x90>
ffffffffc0204fa2:	00092797          	auipc	a5,0x92
ffffffffc0204fa6:	9267b783          	ld	a5,-1754(a5) # ffffffffc02968c8 <current>
ffffffffc0204faa:	ec26                	sd	s1,24(sp)
ffffffffc0204fac:	84ae                	mv	s1,a1
ffffffffc0204fae:	1487b783          	ld	a5,328(a5)
ffffffffc0204fb2:	cbd9                	beqz	a5,ffffffffc0205048 <file_fstat+0xb4>
ffffffffc0204fb4:	4b98                	lw	a4,16(a5)
ffffffffc0204fb6:	08e05963          	blez	a4,ffffffffc0205048 <file_fstat+0xb4>
ffffffffc0204fba:	6780                	ld	s0,8(a5)
ffffffffc0204fbc:	00351793          	slli	a5,a0,0x3
ffffffffc0204fc0:	8f89                	sub	a5,a5,a0
ffffffffc0204fc2:	078e                	slli	a5,a5,0x3
ffffffffc0204fc4:	943e                	add	s0,s0,a5
ffffffffc0204fc6:	4018                	lw	a4,0(s0)
ffffffffc0204fc8:	4789                	li	a5,2
ffffffffc0204fca:	04f71663          	bne	a4,a5,ffffffffc0205016 <file_fstat+0x82>
ffffffffc0204fce:	4c1c                	lw	a5,24(s0)
ffffffffc0204fd0:	04a79363          	bne	a5,a0,ffffffffc0205016 <file_fstat+0x82>
ffffffffc0204fd4:	581c                	lw	a5,48(s0)
ffffffffc0204fd6:	7408                	ld	a0,40(s0)
ffffffffc0204fd8:	2785                	addiw	a5,a5,1
ffffffffc0204fda:	d81c                	sw	a5,48(s0)
ffffffffc0204fdc:	c531                	beqz	a0,ffffffffc0205028 <file_fstat+0x94>
ffffffffc0204fde:	793c                	ld	a5,112(a0)
ffffffffc0204fe0:	c7a1                	beqz	a5,ffffffffc0205028 <file_fstat+0x94>
ffffffffc0204fe2:	779c                	ld	a5,40(a5)
ffffffffc0204fe4:	c3b1                	beqz	a5,ffffffffc0205028 <file_fstat+0x94>
ffffffffc0204fe6:	00008597          	auipc	a1,0x8
ffffffffc0204fea:	39a58593          	addi	a1,a1,922 # ffffffffc020d380 <etext+0x1bbc>
ffffffffc0204fee:	e42a                	sd	a0,8(sp)
ffffffffc0204ff0:	21f020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0204ff4:	6522                	ld	a0,8(sp)
ffffffffc0204ff6:	85a6                	mv	a1,s1
ffffffffc0204ff8:	793c                	ld	a5,112(a0)
ffffffffc0204ffa:	7408                	ld	a0,40(s0)
ffffffffc0204ffc:	779c                	ld	a5,40(a5)
ffffffffc0204ffe:	9782                	jalr	a5
ffffffffc0205000:	87aa                	mv	a5,a0
ffffffffc0205002:	8522                	mv	a0,s0
ffffffffc0205004:	843e                	mv	s0,a5
ffffffffc0205006:	92dff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc020500a:	64e2                	ld	s1,24(sp)
ffffffffc020500c:	70a2                	ld	ra,40(sp)
ffffffffc020500e:	8522                	mv	a0,s0
ffffffffc0205010:	7402                	ld	s0,32(sp)
ffffffffc0205012:	6145                	addi	sp,sp,48
ffffffffc0205014:	8082                	ret
ffffffffc0205016:	5475                	li	s0,-3
ffffffffc0205018:	70a2                	ld	ra,40(sp)
ffffffffc020501a:	8522                	mv	a0,s0
ffffffffc020501c:	7402                	ld	s0,32(sp)
ffffffffc020501e:	64e2                	ld	s1,24(sp)
ffffffffc0205020:	6145                	addi	sp,sp,48
ffffffffc0205022:	8082                	ret
ffffffffc0205024:	5475                	li	s0,-3
ffffffffc0205026:	b7dd                	j	ffffffffc020500c <file_fstat+0x78>
ffffffffc0205028:	00008697          	auipc	a3,0x8
ffffffffc020502c:	30868693          	addi	a3,a3,776 # ffffffffc020d330 <etext+0x1b6c>
ffffffffc0205030:	00007617          	auipc	a2,0x7
ffffffffc0205034:	bd060613          	addi	a2,a2,-1072 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205038:	12c00593          	li	a1,300
ffffffffc020503c:	00008517          	auipc	a0,0x8
ffffffffc0205040:	1bc50513          	addi	a0,a0,444 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc0205044:	c06fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205048:	fbcff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc020504c <file_fsync>:
ffffffffc020504c:	1101                	addi	sp,sp,-32
ffffffffc020504e:	ec06                	sd	ra,24(sp)
ffffffffc0205050:	e822                	sd	s0,16(sp)
ffffffffc0205052:	04700793          	li	a5,71
ffffffffc0205056:	06a7e863          	bltu	a5,a0,ffffffffc02050c6 <file_fsync+0x7a>
ffffffffc020505a:	00092797          	auipc	a5,0x92
ffffffffc020505e:	86e7b783          	ld	a5,-1938(a5) # ffffffffc02968c8 <current>
ffffffffc0205062:	1487b783          	ld	a5,328(a5)
ffffffffc0205066:	c7d1                	beqz	a5,ffffffffc02050f2 <file_fsync+0xa6>
ffffffffc0205068:	4b98                	lw	a4,16(a5)
ffffffffc020506a:	08e05463          	blez	a4,ffffffffc02050f2 <file_fsync+0xa6>
ffffffffc020506e:	6780                	ld	s0,8(a5)
ffffffffc0205070:	00351793          	slli	a5,a0,0x3
ffffffffc0205074:	8f89                	sub	a5,a5,a0
ffffffffc0205076:	078e                	slli	a5,a5,0x3
ffffffffc0205078:	943e                	add	s0,s0,a5
ffffffffc020507a:	4018                	lw	a4,0(s0)
ffffffffc020507c:	4789                	li	a5,2
ffffffffc020507e:	04f71463          	bne	a4,a5,ffffffffc02050c6 <file_fsync+0x7a>
ffffffffc0205082:	4c1c                	lw	a5,24(s0)
ffffffffc0205084:	04a79163          	bne	a5,a0,ffffffffc02050c6 <file_fsync+0x7a>
ffffffffc0205088:	581c                	lw	a5,48(s0)
ffffffffc020508a:	7408                	ld	a0,40(s0)
ffffffffc020508c:	2785                	addiw	a5,a5,1
ffffffffc020508e:	d81c                	sw	a5,48(s0)
ffffffffc0205090:	c129                	beqz	a0,ffffffffc02050d2 <file_fsync+0x86>
ffffffffc0205092:	793c                	ld	a5,112(a0)
ffffffffc0205094:	cf9d                	beqz	a5,ffffffffc02050d2 <file_fsync+0x86>
ffffffffc0205096:	7b9c                	ld	a5,48(a5)
ffffffffc0205098:	cf8d                	beqz	a5,ffffffffc02050d2 <file_fsync+0x86>
ffffffffc020509a:	00008597          	auipc	a1,0x8
ffffffffc020509e:	44658593          	addi	a1,a1,1094 # ffffffffc020d4e0 <etext+0x1d1c>
ffffffffc02050a2:	e42a                	sd	a0,8(sp)
ffffffffc02050a4:	16b020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc02050a8:	6522                	ld	a0,8(sp)
ffffffffc02050aa:	793c                	ld	a5,112(a0)
ffffffffc02050ac:	7408                	ld	a0,40(s0)
ffffffffc02050ae:	7b9c                	ld	a5,48(a5)
ffffffffc02050b0:	9782                	jalr	a5
ffffffffc02050b2:	87aa                	mv	a5,a0
ffffffffc02050b4:	8522                	mv	a0,s0
ffffffffc02050b6:	843e                	mv	s0,a5
ffffffffc02050b8:	87bff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc02050bc:	60e2                	ld	ra,24(sp)
ffffffffc02050be:	8522                	mv	a0,s0
ffffffffc02050c0:	6442                	ld	s0,16(sp)
ffffffffc02050c2:	6105                	addi	sp,sp,32
ffffffffc02050c4:	8082                	ret
ffffffffc02050c6:	5475                	li	s0,-3
ffffffffc02050c8:	60e2                	ld	ra,24(sp)
ffffffffc02050ca:	8522                	mv	a0,s0
ffffffffc02050cc:	6442                	ld	s0,16(sp)
ffffffffc02050ce:	6105                	addi	sp,sp,32
ffffffffc02050d0:	8082                	ret
ffffffffc02050d2:	00008697          	auipc	a3,0x8
ffffffffc02050d6:	3be68693          	addi	a3,a3,958 # ffffffffc020d490 <etext+0x1ccc>
ffffffffc02050da:	00007617          	auipc	a2,0x7
ffffffffc02050de:	b2660613          	addi	a2,a2,-1242 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02050e2:	13a00593          	li	a1,314
ffffffffc02050e6:	00008517          	auipc	a0,0x8
ffffffffc02050ea:	11250513          	addi	a0,a0,274 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc02050ee:	b5cfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02050f2:	f12ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc02050f6 <file_getdirentry>:
ffffffffc02050f6:	715d                	addi	sp,sp,-80
ffffffffc02050f8:	e486                	sd	ra,72(sp)
ffffffffc02050fa:	f84a                	sd	s2,48(sp)
ffffffffc02050fc:	04700793          	li	a5,71
ffffffffc0205100:	0aa7e963          	bltu	a5,a0,ffffffffc02051b2 <file_getdirentry+0xbc>
ffffffffc0205104:	00091797          	auipc	a5,0x91
ffffffffc0205108:	7c47b783          	ld	a5,1988(a5) # ffffffffc02968c8 <current>
ffffffffc020510c:	fc26                	sd	s1,56(sp)
ffffffffc020510e:	e0a2                	sd	s0,64(sp)
ffffffffc0205110:	1487b783          	ld	a5,328(a5)
ffffffffc0205114:	84ae                	mv	s1,a1
ffffffffc0205116:	c7e1                	beqz	a5,ffffffffc02051de <file_getdirentry+0xe8>
ffffffffc0205118:	4b98                	lw	a4,16(a5)
ffffffffc020511a:	0ce05263          	blez	a4,ffffffffc02051de <file_getdirentry+0xe8>
ffffffffc020511e:	6780                	ld	s0,8(a5)
ffffffffc0205120:	00351793          	slli	a5,a0,0x3
ffffffffc0205124:	8f89                	sub	a5,a5,a0
ffffffffc0205126:	078e                	slli	a5,a5,0x3
ffffffffc0205128:	943e                	add	s0,s0,a5
ffffffffc020512a:	4018                	lw	a4,0(s0)
ffffffffc020512c:	4789                	li	a5,2
ffffffffc020512e:	08f71463          	bne	a4,a5,ffffffffc02051b6 <file_getdirentry+0xc0>
ffffffffc0205132:	4c1c                	lw	a5,24(s0)
ffffffffc0205134:	f44e                	sd	s3,40(sp)
ffffffffc0205136:	06a79963          	bne	a5,a0,ffffffffc02051a8 <file_getdirentry+0xb2>
ffffffffc020513a:	581c                	lw	a5,48(s0)
ffffffffc020513c:	6194                	ld	a3,0(a1)
ffffffffc020513e:	10000613          	li	a2,256
ffffffffc0205142:	2785                	addiw	a5,a5,1
ffffffffc0205144:	d81c                	sw	a5,48(s0)
ffffffffc0205146:	05a1                	addi	a1,a1,8
ffffffffc0205148:	850a                	mv	a0,sp
ffffffffc020514a:	342000ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc020514e:	02843903          	ld	s2,40(s0)
ffffffffc0205152:	89aa                	mv	s3,a0
ffffffffc0205154:	06090563          	beqz	s2,ffffffffc02051be <file_getdirentry+0xc8>
ffffffffc0205158:	07093783          	ld	a5,112(s2)
ffffffffc020515c:	c3ad                	beqz	a5,ffffffffc02051be <file_getdirentry+0xc8>
ffffffffc020515e:	63bc                	ld	a5,64(a5)
ffffffffc0205160:	cfb9                	beqz	a5,ffffffffc02051be <file_getdirentry+0xc8>
ffffffffc0205162:	854a                	mv	a0,s2
ffffffffc0205164:	00008597          	auipc	a1,0x8
ffffffffc0205168:	3dc58593          	addi	a1,a1,988 # ffffffffc020d540 <etext+0x1d7c>
ffffffffc020516c:	0a3020ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0205170:	07093783          	ld	a5,112(s2)
ffffffffc0205174:	7408                	ld	a0,40(s0)
ffffffffc0205176:	85ce                	mv	a1,s3
ffffffffc0205178:	63bc                	ld	a5,64(a5)
ffffffffc020517a:	9782                	jalr	a5
ffffffffc020517c:	892a                	mv	s2,a0
ffffffffc020517e:	cd01                	beqz	a0,ffffffffc0205196 <file_getdirentry+0xa0>
ffffffffc0205180:	8522                	mv	a0,s0
ffffffffc0205182:	fb0ff0ef          	jal	ffffffffc0204932 <fd_array_release>
ffffffffc0205186:	6406                	ld	s0,64(sp)
ffffffffc0205188:	74e2                	ld	s1,56(sp)
ffffffffc020518a:	79a2                	ld	s3,40(sp)
ffffffffc020518c:	60a6                	ld	ra,72(sp)
ffffffffc020518e:	854a                	mv	a0,s2
ffffffffc0205190:	7942                	ld	s2,48(sp)
ffffffffc0205192:	6161                	addi	sp,sp,80
ffffffffc0205194:	8082                	ret
ffffffffc0205196:	609c                	ld	a5,0(s1)
ffffffffc0205198:	0109b683          	ld	a3,16(s3)
ffffffffc020519c:	0189b703          	ld	a4,24(s3)
ffffffffc02051a0:	97b6                	add	a5,a5,a3
ffffffffc02051a2:	8f99                	sub	a5,a5,a4
ffffffffc02051a4:	e09c                	sd	a5,0(s1)
ffffffffc02051a6:	bfe9                	j	ffffffffc0205180 <file_getdirentry+0x8a>
ffffffffc02051a8:	6406                	ld	s0,64(sp)
ffffffffc02051aa:	74e2                	ld	s1,56(sp)
ffffffffc02051ac:	79a2                	ld	s3,40(sp)
ffffffffc02051ae:	5975                	li	s2,-3
ffffffffc02051b0:	bff1                	j	ffffffffc020518c <file_getdirentry+0x96>
ffffffffc02051b2:	5975                	li	s2,-3
ffffffffc02051b4:	bfe1                	j	ffffffffc020518c <file_getdirentry+0x96>
ffffffffc02051b6:	6406                	ld	s0,64(sp)
ffffffffc02051b8:	74e2                	ld	s1,56(sp)
ffffffffc02051ba:	5975                	li	s2,-3
ffffffffc02051bc:	bfc1                	j	ffffffffc020518c <file_getdirentry+0x96>
ffffffffc02051be:	00008697          	auipc	a3,0x8
ffffffffc02051c2:	32a68693          	addi	a3,a3,810 # ffffffffc020d4e8 <etext+0x1d24>
ffffffffc02051c6:	00007617          	auipc	a2,0x7
ffffffffc02051ca:	a3a60613          	addi	a2,a2,-1478 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02051ce:	14a00593          	li	a1,330
ffffffffc02051d2:	00008517          	auipc	a0,0x8
ffffffffc02051d6:	02650513          	addi	a0,a0,38 # ffffffffc020d1f8 <etext+0x1a34>
ffffffffc02051da:	a70fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02051de:	f44e                	sd	s3,40(sp)
ffffffffc02051e0:	e24ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc02051e4 <file_dup>:
ffffffffc02051e4:	04700713          	li	a4,71
ffffffffc02051e8:	06a76263          	bltu	a4,a0,ffffffffc020524c <file_dup+0x68>
ffffffffc02051ec:	00091717          	auipc	a4,0x91
ffffffffc02051f0:	6dc73703          	ld	a4,1756(a4) # ffffffffc02968c8 <current>
ffffffffc02051f4:	7179                	addi	sp,sp,-48
ffffffffc02051f6:	f406                	sd	ra,40(sp)
ffffffffc02051f8:	14873703          	ld	a4,328(a4)
ffffffffc02051fc:	f022                	sd	s0,32(sp)
ffffffffc02051fe:	87aa                	mv	a5,a0
ffffffffc0205200:	852e                	mv	a0,a1
ffffffffc0205202:	c739                	beqz	a4,ffffffffc0205250 <file_dup+0x6c>
ffffffffc0205204:	4b14                	lw	a3,16(a4)
ffffffffc0205206:	04d05563          	blez	a3,ffffffffc0205250 <file_dup+0x6c>
ffffffffc020520a:	6700                	ld	s0,8(a4)
ffffffffc020520c:	00379713          	slli	a4,a5,0x3
ffffffffc0205210:	8f1d                	sub	a4,a4,a5
ffffffffc0205212:	070e                	slli	a4,a4,0x3
ffffffffc0205214:	943a                	add	s0,s0,a4
ffffffffc0205216:	4014                	lw	a3,0(s0)
ffffffffc0205218:	4709                	li	a4,2
ffffffffc020521a:	02e69463          	bne	a3,a4,ffffffffc0205242 <file_dup+0x5e>
ffffffffc020521e:	4c18                	lw	a4,24(s0)
ffffffffc0205220:	02f71163          	bne	a4,a5,ffffffffc0205242 <file_dup+0x5e>
ffffffffc0205224:	082c                	addi	a1,sp,24
ffffffffc0205226:	e00ff0ef          	jal	ffffffffc0204826 <fd_array_alloc>
ffffffffc020522a:	e901                	bnez	a0,ffffffffc020523a <file_dup+0x56>
ffffffffc020522c:	6562                	ld	a0,24(sp)
ffffffffc020522e:	85a2                	mv	a1,s0
ffffffffc0205230:	e42a                	sd	a0,8(sp)
ffffffffc0205232:	821ff0ef          	jal	ffffffffc0204a52 <fd_array_dup>
ffffffffc0205236:	6522                	ld	a0,8(sp)
ffffffffc0205238:	4d08                	lw	a0,24(a0)
ffffffffc020523a:	70a2                	ld	ra,40(sp)
ffffffffc020523c:	7402                	ld	s0,32(sp)
ffffffffc020523e:	6145                	addi	sp,sp,48
ffffffffc0205240:	8082                	ret
ffffffffc0205242:	70a2                	ld	ra,40(sp)
ffffffffc0205244:	7402                	ld	s0,32(sp)
ffffffffc0205246:	5575                	li	a0,-3
ffffffffc0205248:	6145                	addi	sp,sp,48
ffffffffc020524a:	8082                	ret
ffffffffc020524c:	5575                	li	a0,-3
ffffffffc020524e:	8082                	ret
ffffffffc0205250:	db4ff0ef          	jal	ffffffffc0204804 <get_fd_array.part.0>

ffffffffc0205254 <fs_init>:
ffffffffc0205254:	1141                	addi	sp,sp,-16
ffffffffc0205256:	e406                	sd	ra,8(sp)
ffffffffc0205258:	1c1020ef          	jal	ffffffffc0207c18 <vfs_init>
ffffffffc020525c:	6ce030ef          	jal	ffffffffc020892a <dev_init>
ffffffffc0205260:	60a2                	ld	ra,8(sp)
ffffffffc0205262:	0141                	addi	sp,sp,16
ffffffffc0205264:	0420406f          	j	ffffffffc02092a6 <sfs_init>

ffffffffc0205268 <fs_cleanup>:
ffffffffc0205268:	42d0206f          	j	ffffffffc0207e94 <vfs_cleanup>

ffffffffc020526c <lock_files>:
ffffffffc020526c:	0561                	addi	a0,a0,24
ffffffffc020526e:	b88ff06f          	j	ffffffffc02045f6 <down>

ffffffffc0205272 <unlock_files>:
ffffffffc0205272:	0561                	addi	a0,a0,24
ffffffffc0205274:	b7eff06f          	j	ffffffffc02045f2 <up>

ffffffffc0205278 <files_create>:
ffffffffc0205278:	1141                	addi	sp,sp,-16
ffffffffc020527a:	6505                	lui	a0,0x1
ffffffffc020527c:	e022                	sd	s0,0(sp)
ffffffffc020527e:	e406                	sd	ra,8(sp)
ffffffffc0205280:	d41fc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0205284:	842a                	mv	s0,a0
ffffffffc0205286:	cd19                	beqz	a0,ffffffffc02052a4 <files_create+0x2c>
ffffffffc0205288:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc020528c:	e51c                	sd	a5,8(a0)
ffffffffc020528e:	00053023          	sd	zero,0(a0)
ffffffffc0205292:	00052823          	sw	zero,16(a0)
ffffffffc0205296:	4585                	li	a1,1
ffffffffc0205298:	0561                	addi	a0,a0,24
ffffffffc020529a:	b52ff0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc020529e:	6408                	ld	a0,8(s0)
ffffffffc02052a0:	f1eff0ef          	jal	ffffffffc02049be <fd_array_init>
ffffffffc02052a4:	60a2                	ld	ra,8(sp)
ffffffffc02052a6:	8522                	mv	a0,s0
ffffffffc02052a8:	6402                	ld	s0,0(sp)
ffffffffc02052aa:	0141                	addi	sp,sp,16
ffffffffc02052ac:	8082                	ret

ffffffffc02052ae <files_destroy>:
ffffffffc02052ae:	7179                	addi	sp,sp,-48
ffffffffc02052b0:	f406                	sd	ra,40(sp)
ffffffffc02052b2:	f022                	sd	s0,32(sp)
ffffffffc02052b4:	ec26                	sd	s1,24(sp)
ffffffffc02052b6:	e84a                	sd	s2,16(sp)
ffffffffc02052b8:	e44e                	sd	s3,8(sp)
ffffffffc02052ba:	c52d                	beqz	a0,ffffffffc0205324 <files_destroy+0x76>
ffffffffc02052bc:	491c                	lw	a5,16(a0)
ffffffffc02052be:	89aa                	mv	s3,a0
ffffffffc02052c0:	e3b5                	bnez	a5,ffffffffc0205324 <files_destroy+0x76>
ffffffffc02052c2:	6108                	ld	a0,0(a0)
ffffffffc02052c4:	c119                	beqz	a0,ffffffffc02052ca <files_destroy+0x1c>
ffffffffc02052c6:	003020ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc02052ca:	0089b403          	ld	s0,8(s3)
ffffffffc02052ce:	4909                	li	s2,2
ffffffffc02052d0:	7ff40493          	addi	s1,s0,2047
ffffffffc02052d4:	7c148493          	addi	s1,s1,1985
ffffffffc02052d8:	401c                	lw	a5,0(s0)
ffffffffc02052da:	03278063          	beq	a5,s2,ffffffffc02052fa <files_destroy+0x4c>
ffffffffc02052de:	e39d                	bnez	a5,ffffffffc0205304 <files_destroy+0x56>
ffffffffc02052e0:	03840413          	addi	s0,s0,56
ffffffffc02052e4:	fe941ae3          	bne	s0,s1,ffffffffc02052d8 <files_destroy+0x2a>
ffffffffc02052e8:	7402                	ld	s0,32(sp)
ffffffffc02052ea:	70a2                	ld	ra,40(sp)
ffffffffc02052ec:	64e2                	ld	s1,24(sp)
ffffffffc02052ee:	6942                	ld	s2,16(sp)
ffffffffc02052f0:	854e                	mv	a0,s3
ffffffffc02052f2:	69a2                	ld	s3,8(sp)
ffffffffc02052f4:	6145                	addi	sp,sp,48
ffffffffc02052f6:	d71fc06f          	j	ffffffffc0202066 <kfree>
ffffffffc02052fa:	8522                	mv	a0,s0
ffffffffc02052fc:	edeff0ef          	jal	ffffffffc02049da <fd_array_close>
ffffffffc0205300:	401c                	lw	a5,0(s0)
ffffffffc0205302:	bff1                	j	ffffffffc02052de <files_destroy+0x30>
ffffffffc0205304:	00008697          	auipc	a3,0x8
ffffffffc0205308:	28c68693          	addi	a3,a3,652 # ffffffffc020d590 <etext+0x1dcc>
ffffffffc020530c:	00007617          	auipc	a2,0x7
ffffffffc0205310:	8f460613          	addi	a2,a2,-1804 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205314:	03d00593          	li	a1,61
ffffffffc0205318:	00008517          	auipc	a0,0x8
ffffffffc020531c:	26850513          	addi	a0,a0,616 # ffffffffc020d580 <etext+0x1dbc>
ffffffffc0205320:	92afb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205324:	00008697          	auipc	a3,0x8
ffffffffc0205328:	22c68693          	addi	a3,a3,556 # ffffffffc020d550 <etext+0x1d8c>
ffffffffc020532c:	00007617          	auipc	a2,0x7
ffffffffc0205330:	8d460613          	addi	a2,a2,-1836 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205334:	03300593          	li	a1,51
ffffffffc0205338:	00008517          	auipc	a0,0x8
ffffffffc020533c:	24850513          	addi	a0,a0,584 # ffffffffc020d580 <etext+0x1dbc>
ffffffffc0205340:	90afb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205344 <files_closeall>:
ffffffffc0205344:	1101                	addi	sp,sp,-32
ffffffffc0205346:	ec06                	sd	ra,24(sp)
ffffffffc0205348:	e822                	sd	s0,16(sp)
ffffffffc020534a:	e426                	sd	s1,8(sp)
ffffffffc020534c:	e04a                	sd	s2,0(sp)
ffffffffc020534e:	c129                	beqz	a0,ffffffffc0205390 <files_closeall+0x4c>
ffffffffc0205350:	491c                	lw	a5,16(a0)
ffffffffc0205352:	02f05f63          	blez	a5,ffffffffc0205390 <files_closeall+0x4c>
ffffffffc0205356:	6500                	ld	s0,8(a0)
ffffffffc0205358:	4909                	li	s2,2
ffffffffc020535a:	7ff40493          	addi	s1,s0,2047
ffffffffc020535e:	7c148493          	addi	s1,s1,1985
ffffffffc0205362:	07040413          	addi	s0,s0,112
ffffffffc0205366:	a029                	j	ffffffffc0205370 <files_closeall+0x2c>
ffffffffc0205368:	03840413          	addi	s0,s0,56
ffffffffc020536c:	00940c63          	beq	s0,s1,ffffffffc0205384 <files_closeall+0x40>
ffffffffc0205370:	401c                	lw	a5,0(s0)
ffffffffc0205372:	ff279be3          	bne	a5,s2,ffffffffc0205368 <files_closeall+0x24>
ffffffffc0205376:	8522                	mv	a0,s0
ffffffffc0205378:	03840413          	addi	s0,s0,56
ffffffffc020537c:	e5eff0ef          	jal	ffffffffc02049da <fd_array_close>
ffffffffc0205380:	fe9418e3          	bne	s0,s1,ffffffffc0205370 <files_closeall+0x2c>
ffffffffc0205384:	60e2                	ld	ra,24(sp)
ffffffffc0205386:	6442                	ld	s0,16(sp)
ffffffffc0205388:	64a2                	ld	s1,8(sp)
ffffffffc020538a:	6902                	ld	s2,0(sp)
ffffffffc020538c:	6105                	addi	sp,sp,32
ffffffffc020538e:	8082                	ret
ffffffffc0205390:	00008697          	auipc	a3,0x8
ffffffffc0205394:	e3868693          	addi	a3,a3,-456 # ffffffffc020d1c8 <etext+0x1a04>
ffffffffc0205398:	00007617          	auipc	a2,0x7
ffffffffc020539c:	86860613          	addi	a2,a2,-1944 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02053a0:	04500593          	li	a1,69
ffffffffc02053a4:	00008517          	auipc	a0,0x8
ffffffffc02053a8:	1dc50513          	addi	a0,a0,476 # ffffffffc020d580 <etext+0x1dbc>
ffffffffc02053ac:	89efb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02053b0 <dup_files>:
ffffffffc02053b0:	7179                	addi	sp,sp,-48
ffffffffc02053b2:	f406                	sd	ra,40(sp)
ffffffffc02053b4:	f022                	sd	s0,32(sp)
ffffffffc02053b6:	ec26                	sd	s1,24(sp)
ffffffffc02053b8:	e84a                	sd	s2,16(sp)
ffffffffc02053ba:	e44e                	sd	s3,8(sp)
ffffffffc02053bc:	e052                	sd	s4,0(sp)
ffffffffc02053be:	c52d                	beqz	a0,ffffffffc0205428 <dup_files+0x78>
ffffffffc02053c0:	842e                	mv	s0,a1
ffffffffc02053c2:	c1bd                	beqz	a1,ffffffffc0205428 <dup_files+0x78>
ffffffffc02053c4:	491c                	lw	a5,16(a0)
ffffffffc02053c6:	84aa                	mv	s1,a0
ffffffffc02053c8:	e3c1                	bnez	a5,ffffffffc0205448 <dup_files+0x98>
ffffffffc02053ca:	499c                	lw	a5,16(a1)
ffffffffc02053cc:	06f05e63          	blez	a5,ffffffffc0205448 <dup_files+0x98>
ffffffffc02053d0:	6188                	ld	a0,0(a1)
ffffffffc02053d2:	e088                	sd	a0,0(s1)
ffffffffc02053d4:	c119                	beqz	a0,ffffffffc02053da <dup_files+0x2a>
ffffffffc02053d6:	624020ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc02053da:	6400                	ld	s0,8(s0)
ffffffffc02053dc:	6484                	ld	s1,8(s1)
ffffffffc02053de:	4989                	li	s3,2
ffffffffc02053e0:	7ff40913          	addi	s2,s0,2047
ffffffffc02053e4:	7c190913          	addi	s2,s2,1985
ffffffffc02053e8:	4a05                	li	s4,1
ffffffffc02053ea:	a039                	j	ffffffffc02053f8 <dup_files+0x48>
ffffffffc02053ec:	03840413          	addi	s0,s0,56
ffffffffc02053f0:	03848493          	addi	s1,s1,56
ffffffffc02053f4:	03240163          	beq	s0,s2,ffffffffc0205416 <dup_files+0x66>
ffffffffc02053f8:	401c                	lw	a5,0(s0)
ffffffffc02053fa:	ff3799e3          	bne	a5,s3,ffffffffc02053ec <dup_files+0x3c>
ffffffffc02053fe:	0144a023          	sw	s4,0(s1)
ffffffffc0205402:	85a2                	mv	a1,s0
ffffffffc0205404:	8526                	mv	a0,s1
ffffffffc0205406:	03840413          	addi	s0,s0,56
ffffffffc020540a:	e48ff0ef          	jal	ffffffffc0204a52 <fd_array_dup>
ffffffffc020540e:	03848493          	addi	s1,s1,56
ffffffffc0205412:	ff2413e3          	bne	s0,s2,ffffffffc02053f8 <dup_files+0x48>
ffffffffc0205416:	70a2                	ld	ra,40(sp)
ffffffffc0205418:	7402                	ld	s0,32(sp)
ffffffffc020541a:	64e2                	ld	s1,24(sp)
ffffffffc020541c:	6942                	ld	s2,16(sp)
ffffffffc020541e:	69a2                	ld	s3,8(sp)
ffffffffc0205420:	6a02                	ld	s4,0(sp)
ffffffffc0205422:	4501                	li	a0,0
ffffffffc0205424:	6145                	addi	sp,sp,48
ffffffffc0205426:	8082                	ret
ffffffffc0205428:	00008697          	auipc	a3,0x8
ffffffffc020542c:	af068693          	addi	a3,a3,-1296 # ffffffffc020cf18 <etext+0x1754>
ffffffffc0205430:	00006617          	auipc	a2,0x6
ffffffffc0205434:	7d060613          	addi	a2,a2,2000 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205438:	05300593          	li	a1,83
ffffffffc020543c:	00008517          	auipc	a0,0x8
ffffffffc0205440:	14450513          	addi	a0,a0,324 # ffffffffc020d580 <etext+0x1dbc>
ffffffffc0205444:	806fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205448:	00008697          	auipc	a3,0x8
ffffffffc020544c:	16068693          	addi	a3,a3,352 # ffffffffc020d5a8 <etext+0x1de4>
ffffffffc0205450:	00006617          	auipc	a2,0x6
ffffffffc0205454:	7b060613          	addi	a2,a2,1968 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205458:	05400593          	li	a1,84
ffffffffc020545c:	00008517          	auipc	a0,0x8
ffffffffc0205460:	12450513          	addi	a0,a0,292 # ffffffffc020d580 <etext+0x1dbc>
ffffffffc0205464:	fe7fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205468 <iobuf_skip.part.0>:
ffffffffc0205468:	1141                	addi	sp,sp,-16
ffffffffc020546a:	00008697          	auipc	a3,0x8
ffffffffc020546e:	16e68693          	addi	a3,a3,366 # ffffffffc020d5d8 <etext+0x1e14>
ffffffffc0205472:	00006617          	auipc	a2,0x6
ffffffffc0205476:	78e60613          	addi	a2,a2,1934 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020547a:	04a00593          	li	a1,74
ffffffffc020547e:	00008517          	auipc	a0,0x8
ffffffffc0205482:	17250513          	addi	a0,a0,370 # ffffffffc020d5f0 <etext+0x1e2c>
ffffffffc0205486:	e406                	sd	ra,8(sp)
ffffffffc0205488:	fc3fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020548c <iobuf_init>:
ffffffffc020548c:	e10c                	sd	a1,0(a0)
ffffffffc020548e:	e514                	sd	a3,8(a0)
ffffffffc0205490:	ed10                	sd	a2,24(a0)
ffffffffc0205492:	e910                	sd	a2,16(a0)
ffffffffc0205494:	8082                	ret

ffffffffc0205496 <iobuf_move>:
ffffffffc0205496:	6d1c                	ld	a5,24(a0)
ffffffffc0205498:	88aa                	mv	a7,a0
ffffffffc020549a:	8832                	mv	a6,a2
ffffffffc020549c:	00f67363          	bgeu	a2,a5,ffffffffc02054a2 <iobuf_move+0xc>
ffffffffc02054a0:	87b2                	mv	a5,a2
ffffffffc02054a2:	cfa1                	beqz	a5,ffffffffc02054fa <iobuf_move+0x64>
ffffffffc02054a4:	7179                	addi	sp,sp,-48
ffffffffc02054a6:	f406                	sd	ra,40(sp)
ffffffffc02054a8:	0008b503          	ld	a0,0(a7)
ffffffffc02054ac:	cea9                	beqz	a3,ffffffffc0205506 <iobuf_move+0x70>
ffffffffc02054ae:	863e                	mv	a2,a5
ffffffffc02054b0:	ec3a                	sd	a4,24(sp)
ffffffffc02054b2:	e846                	sd	a7,16(sp)
ffffffffc02054b4:	e442                	sd	a6,8(sp)
ffffffffc02054b6:	e03e                	sd	a5,0(sp)
ffffffffc02054b8:	2b6060ef          	jal	ffffffffc020b76e <memmove>
ffffffffc02054bc:	68c2                	ld	a7,16(sp)
ffffffffc02054be:	6782                	ld	a5,0(sp)
ffffffffc02054c0:	6822                	ld	a6,8(sp)
ffffffffc02054c2:	0188b683          	ld	a3,24(a7)
ffffffffc02054c6:	6762                	ld	a4,24(sp)
ffffffffc02054c8:	04f6e763          	bltu	a3,a5,ffffffffc0205516 <iobuf_move+0x80>
ffffffffc02054cc:	0008b583          	ld	a1,0(a7)
ffffffffc02054d0:	0088b603          	ld	a2,8(a7)
ffffffffc02054d4:	8e9d                	sub	a3,a3,a5
ffffffffc02054d6:	95be                	add	a1,a1,a5
ffffffffc02054d8:	963e                	add	a2,a2,a5
ffffffffc02054da:	00d8bc23          	sd	a3,24(a7)
ffffffffc02054de:	00b8b023          	sd	a1,0(a7)
ffffffffc02054e2:	00c8b423          	sd	a2,8(a7)
ffffffffc02054e6:	40f80833          	sub	a6,a6,a5
ffffffffc02054ea:	c311                	beqz	a4,ffffffffc02054ee <iobuf_move+0x58>
ffffffffc02054ec:	e31c                	sd	a5,0(a4)
ffffffffc02054ee:	02081263          	bnez	a6,ffffffffc0205512 <iobuf_move+0x7c>
ffffffffc02054f2:	4501                	li	a0,0
ffffffffc02054f4:	70a2                	ld	ra,40(sp)
ffffffffc02054f6:	6145                	addi	sp,sp,48
ffffffffc02054f8:	8082                	ret
ffffffffc02054fa:	c311                	beqz	a4,ffffffffc02054fe <iobuf_move+0x68>
ffffffffc02054fc:	e31c                	sd	a5,0(a4)
ffffffffc02054fe:	00081863          	bnez	a6,ffffffffc020550e <iobuf_move+0x78>
ffffffffc0205502:	4501                	li	a0,0
ffffffffc0205504:	8082                	ret
ffffffffc0205506:	86ae                	mv	a3,a1
ffffffffc0205508:	85aa                	mv	a1,a0
ffffffffc020550a:	8536                	mv	a0,a3
ffffffffc020550c:	b74d                	j	ffffffffc02054ae <iobuf_move+0x18>
ffffffffc020550e:	5571                	li	a0,-4
ffffffffc0205510:	8082                	ret
ffffffffc0205512:	5571                	li	a0,-4
ffffffffc0205514:	b7c5                	j	ffffffffc02054f4 <iobuf_move+0x5e>
ffffffffc0205516:	f53ff0ef          	jal	ffffffffc0205468 <iobuf_skip.part.0>

ffffffffc020551a <iobuf_skip>:
ffffffffc020551a:	6d1c                	ld	a5,24(a0)
ffffffffc020551c:	00b7eb63          	bltu	a5,a1,ffffffffc0205532 <iobuf_skip+0x18>
ffffffffc0205520:	6114                	ld	a3,0(a0)
ffffffffc0205522:	6518                	ld	a4,8(a0)
ffffffffc0205524:	8f8d                	sub	a5,a5,a1
ffffffffc0205526:	96ae                	add	a3,a3,a1
ffffffffc0205528:	972e                	add	a4,a4,a1
ffffffffc020552a:	ed1c                	sd	a5,24(a0)
ffffffffc020552c:	e114                	sd	a3,0(a0)
ffffffffc020552e:	e518                	sd	a4,8(a0)
ffffffffc0205530:	8082                	ret
ffffffffc0205532:	1141                	addi	sp,sp,-16
ffffffffc0205534:	e406                	sd	ra,8(sp)
ffffffffc0205536:	f33ff0ef          	jal	ffffffffc0205468 <iobuf_skip.part.0>

ffffffffc020553a <copy_path>:
ffffffffc020553a:	7139                	addi	sp,sp,-64
ffffffffc020553c:	f04a                	sd	s2,32(sp)
ffffffffc020553e:	00091917          	auipc	s2,0x91
ffffffffc0205542:	38a90913          	addi	s2,s2,906 # ffffffffc02968c8 <current>
ffffffffc0205546:	00093783          	ld	a5,0(s2)
ffffffffc020554a:	e852                	sd	s4,16(sp)
ffffffffc020554c:	8a2a                	mv	s4,a0
ffffffffc020554e:	6505                	lui	a0,0x1
ffffffffc0205550:	f426                	sd	s1,40(sp)
ffffffffc0205552:	ec4e                	sd	s3,24(sp)
ffffffffc0205554:	fc06                	sd	ra,56(sp)
ffffffffc0205556:	7784                	ld	s1,40(a5)
ffffffffc0205558:	89ae                	mv	s3,a1
ffffffffc020555a:	a67fc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020555e:	c92d                	beqz	a0,ffffffffc02055d0 <copy_path+0x96>
ffffffffc0205560:	f822                	sd	s0,48(sp)
ffffffffc0205562:	842a                	mv	s0,a0
ffffffffc0205564:	c0b1                	beqz	s1,ffffffffc02055a8 <copy_path+0x6e>
ffffffffc0205566:	03848513          	addi	a0,s1,56
ffffffffc020556a:	88cff0ef          	jal	ffffffffc02045f6 <down>
ffffffffc020556e:	00093783          	ld	a5,0(s2)
ffffffffc0205572:	c399                	beqz	a5,ffffffffc0205578 <copy_path+0x3e>
ffffffffc0205574:	43dc                	lw	a5,4(a5)
ffffffffc0205576:	c8bc                	sw	a5,80(s1)
ffffffffc0205578:	864e                	mv	a2,s3
ffffffffc020557a:	6685                	lui	a3,0x1
ffffffffc020557c:	85a2                	mv	a1,s0
ffffffffc020557e:	8526                	mv	a0,s1
ffffffffc0205580:	ea9fe0ef          	jal	ffffffffc0204428 <copy_string>
ffffffffc0205584:	cd1d                	beqz	a0,ffffffffc02055c2 <copy_path+0x88>
ffffffffc0205586:	03848513          	addi	a0,s1,56
ffffffffc020558a:	868ff0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020558e:	0404a823          	sw	zero,80(s1)
ffffffffc0205592:	008a3023          	sd	s0,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0205596:	7442                	ld	s0,48(sp)
ffffffffc0205598:	4501                	li	a0,0
ffffffffc020559a:	70e2                	ld	ra,56(sp)
ffffffffc020559c:	74a2                	ld	s1,40(sp)
ffffffffc020559e:	7902                	ld	s2,32(sp)
ffffffffc02055a0:	69e2                	ld	s3,24(sp)
ffffffffc02055a2:	6a42                	ld	s4,16(sp)
ffffffffc02055a4:	6121                	addi	sp,sp,64
ffffffffc02055a6:	8082                	ret
ffffffffc02055a8:	85aa                	mv	a1,a0
ffffffffc02055aa:	864e                	mv	a2,s3
ffffffffc02055ac:	6685                	lui	a3,0x1
ffffffffc02055ae:	4501                	li	a0,0
ffffffffc02055b0:	e79fe0ef          	jal	ffffffffc0204428 <copy_string>
ffffffffc02055b4:	fd79                	bnez	a0,ffffffffc0205592 <copy_path+0x58>
ffffffffc02055b6:	8522                	mv	a0,s0
ffffffffc02055b8:	aaffc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02055bc:	5575                	li	a0,-3
ffffffffc02055be:	7442                	ld	s0,48(sp)
ffffffffc02055c0:	bfe9                	j	ffffffffc020559a <copy_path+0x60>
ffffffffc02055c2:	03848513          	addi	a0,s1,56
ffffffffc02055c6:	82cff0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02055ca:	0404a823          	sw	zero,80(s1)
ffffffffc02055ce:	b7e5                	j	ffffffffc02055b6 <copy_path+0x7c>
ffffffffc02055d0:	5571                	li	a0,-4
ffffffffc02055d2:	b7e1                	j	ffffffffc020559a <copy_path+0x60>

ffffffffc02055d4 <sysfile_open>:
ffffffffc02055d4:	7179                	addi	sp,sp,-48
ffffffffc02055d6:	f022                	sd	s0,32(sp)
ffffffffc02055d8:	842e                	mv	s0,a1
ffffffffc02055da:	85aa                	mv	a1,a0
ffffffffc02055dc:	0828                	addi	a0,sp,24
ffffffffc02055de:	f406                	sd	ra,40(sp)
ffffffffc02055e0:	f5bff0ef          	jal	ffffffffc020553a <copy_path>
ffffffffc02055e4:	87aa                	mv	a5,a0
ffffffffc02055e6:	ed09                	bnez	a0,ffffffffc0205600 <sysfile_open+0x2c>
ffffffffc02055e8:	6762                	ld	a4,24(sp)
ffffffffc02055ea:	85a2                	mv	a1,s0
ffffffffc02055ec:	853a                	mv	a0,a4
ffffffffc02055ee:	e43a                	sd	a4,8(sp)
ffffffffc02055f0:	d32ff0ef          	jal	ffffffffc0204b22 <file_open>
ffffffffc02055f4:	6722                	ld	a4,8(sp)
ffffffffc02055f6:	e42a                	sd	a0,8(sp)
ffffffffc02055f8:	853a                	mv	a0,a4
ffffffffc02055fa:	a6dfc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02055fe:	67a2                	ld	a5,8(sp)
ffffffffc0205600:	70a2                	ld	ra,40(sp)
ffffffffc0205602:	7402                	ld	s0,32(sp)
ffffffffc0205604:	853e                	mv	a0,a5
ffffffffc0205606:	6145                	addi	sp,sp,48
ffffffffc0205608:	8082                	ret

ffffffffc020560a <sysfile_close>:
ffffffffc020560a:	e32ff06f          	j	ffffffffc0204c3c <file_close>

ffffffffc020560e <sysfile_read>:
ffffffffc020560e:	7119                	addi	sp,sp,-128
ffffffffc0205610:	f466                	sd	s9,40(sp)
ffffffffc0205612:	fc86                	sd	ra,120(sp)
ffffffffc0205614:	4c81                	li	s9,0
ffffffffc0205616:	e611                	bnez	a2,ffffffffc0205622 <sysfile_read+0x14>
ffffffffc0205618:	70e6                	ld	ra,120(sp)
ffffffffc020561a:	8566                	mv	a0,s9
ffffffffc020561c:	7ca2                	ld	s9,40(sp)
ffffffffc020561e:	6109                	addi	sp,sp,128
ffffffffc0205620:	8082                	ret
ffffffffc0205622:	f862                	sd	s8,48(sp)
ffffffffc0205624:	00091c17          	auipc	s8,0x91
ffffffffc0205628:	2a4c0c13          	addi	s8,s8,676 # ffffffffc02968c8 <current>
ffffffffc020562c:	000c3783          	ld	a5,0(s8)
ffffffffc0205630:	f8a2                	sd	s0,112(sp)
ffffffffc0205632:	f0ca                	sd	s2,96(sp)
ffffffffc0205634:	8432                	mv	s0,a2
ffffffffc0205636:	892e                	mv	s2,a1
ffffffffc0205638:	4601                	li	a2,0
ffffffffc020563a:	4585                	li	a1,1
ffffffffc020563c:	f4a6                	sd	s1,104(sp)
ffffffffc020563e:	e8d2                	sd	s4,80(sp)
ffffffffc0205640:	7784                	ld	s1,40(a5)
ffffffffc0205642:	8a2a                	mv	s4,a0
ffffffffc0205644:	c8aff0ef          	jal	ffffffffc0204ace <file_testfd>
ffffffffc0205648:	c969                	beqz	a0,ffffffffc020571a <sysfile_read+0x10c>
ffffffffc020564a:	6505                	lui	a0,0x1
ffffffffc020564c:	ecce                	sd	s3,88(sp)
ffffffffc020564e:	973fc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0205652:	89aa                	mv	s3,a0
ffffffffc0205654:	c971                	beqz	a0,ffffffffc0205728 <sysfile_read+0x11a>
ffffffffc0205656:	e4d6                	sd	s5,72(sp)
ffffffffc0205658:	e0da                	sd	s6,64(sp)
ffffffffc020565a:	6a85                	lui	s5,0x1
ffffffffc020565c:	4b01                	li	s6,0
ffffffffc020565e:	09546863          	bltu	s0,s5,ffffffffc02056ee <sysfile_read+0xe0>
ffffffffc0205662:	6785                	lui	a5,0x1
ffffffffc0205664:	863e                	mv	a2,a5
ffffffffc0205666:	0834                	addi	a3,sp,24
ffffffffc0205668:	85ce                	mv	a1,s3
ffffffffc020566a:	8552                	mv	a0,s4
ffffffffc020566c:	ec3e                	sd	a5,24(sp)
ffffffffc020566e:	e26ff0ef          	jal	ffffffffc0204c94 <file_read>
ffffffffc0205672:	66e2                	ld	a3,24(sp)
ffffffffc0205674:	8caa                	mv	s9,a0
ffffffffc0205676:	e68d                	bnez	a3,ffffffffc02056a0 <sysfile_read+0x92>
ffffffffc0205678:	854e                	mv	a0,s3
ffffffffc020567a:	9edfc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020567e:	000b0463          	beqz	s6,ffffffffc0205686 <sysfile_read+0x78>
ffffffffc0205682:	000b0c9b          	sext.w	s9,s6
ffffffffc0205686:	7446                	ld	s0,112(sp)
ffffffffc0205688:	70e6                	ld	ra,120(sp)
ffffffffc020568a:	74a6                	ld	s1,104(sp)
ffffffffc020568c:	7906                	ld	s2,96(sp)
ffffffffc020568e:	69e6                	ld	s3,88(sp)
ffffffffc0205690:	6a46                	ld	s4,80(sp)
ffffffffc0205692:	6aa6                	ld	s5,72(sp)
ffffffffc0205694:	6b06                	ld	s6,64(sp)
ffffffffc0205696:	7c42                	ld	s8,48(sp)
ffffffffc0205698:	8566                	mv	a0,s9
ffffffffc020569a:	7ca2                	ld	s9,40(sp)
ffffffffc020569c:	6109                	addi	sp,sp,128
ffffffffc020569e:	8082                	ret
ffffffffc02056a0:	c899                	beqz	s1,ffffffffc02056b6 <sysfile_read+0xa8>
ffffffffc02056a2:	03848513          	addi	a0,s1,56
ffffffffc02056a6:	f51fe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc02056aa:	000c3783          	ld	a5,0(s8)
ffffffffc02056ae:	66e2                	ld	a3,24(sp)
ffffffffc02056b0:	c399                	beqz	a5,ffffffffc02056b6 <sysfile_read+0xa8>
ffffffffc02056b2:	43dc                	lw	a5,4(a5)
ffffffffc02056b4:	c8bc                	sw	a5,80(s1)
ffffffffc02056b6:	864e                	mv	a2,s3
ffffffffc02056b8:	85ca                	mv	a1,s2
ffffffffc02056ba:	8526                	mv	a0,s1
ffffffffc02056bc:	d35fe0ef          	jal	ffffffffc02043f0 <copy_to_user>
ffffffffc02056c0:	c915                	beqz	a0,ffffffffc02056f4 <sysfile_read+0xe6>
ffffffffc02056c2:	67e2                	ld	a5,24(sp)
ffffffffc02056c4:	06f46a63          	bltu	s0,a5,ffffffffc0205738 <sysfile_read+0x12a>
ffffffffc02056c8:	9b3e                	add	s6,s6,a5
ffffffffc02056ca:	c889                	beqz	s1,ffffffffc02056dc <sysfile_read+0xce>
ffffffffc02056cc:	03848513          	addi	a0,s1,56
ffffffffc02056d0:	e43e                	sd	a5,8(sp)
ffffffffc02056d2:	f21fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02056d6:	67a2                	ld	a5,8(sp)
ffffffffc02056d8:	0404a823          	sw	zero,80(s1)
ffffffffc02056dc:	f80c9ee3          	bnez	s9,ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc02056e0:	6762                	ld	a4,24(sp)
ffffffffc02056e2:	db59                	beqz	a4,ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc02056e4:	8c1d                	sub	s0,s0,a5
ffffffffc02056e6:	d849                	beqz	s0,ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc02056e8:	993e                	add	s2,s2,a5
ffffffffc02056ea:	f7547ce3          	bgeu	s0,s5,ffffffffc0205662 <sysfile_read+0x54>
ffffffffc02056ee:	87a2                	mv	a5,s0
ffffffffc02056f0:	8622                	mv	a2,s0
ffffffffc02056f2:	bf95                	j	ffffffffc0205666 <sysfile_read+0x58>
ffffffffc02056f4:	000c8a63          	beqz	s9,ffffffffc0205708 <sysfile_read+0xfa>
ffffffffc02056f8:	d0c1                	beqz	s1,ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc02056fa:	03848513          	addi	a0,s1,56
ffffffffc02056fe:	ef5fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205702:	0404a823          	sw	zero,80(s1)
ffffffffc0205706:	bf8d                	j	ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc0205708:	c499                	beqz	s1,ffffffffc0205716 <sysfile_read+0x108>
ffffffffc020570a:	03848513          	addi	a0,s1,56
ffffffffc020570e:	ee5fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205712:	0404a823          	sw	zero,80(s1)
ffffffffc0205716:	5cf5                	li	s9,-3
ffffffffc0205718:	b785                	j	ffffffffc0205678 <sysfile_read+0x6a>
ffffffffc020571a:	7446                	ld	s0,112(sp)
ffffffffc020571c:	74a6                	ld	s1,104(sp)
ffffffffc020571e:	7906                	ld	s2,96(sp)
ffffffffc0205720:	6a46                	ld	s4,80(sp)
ffffffffc0205722:	7c42                	ld	s8,48(sp)
ffffffffc0205724:	5cf5                	li	s9,-3
ffffffffc0205726:	bdcd                	j	ffffffffc0205618 <sysfile_read+0xa>
ffffffffc0205728:	7446                	ld	s0,112(sp)
ffffffffc020572a:	74a6                	ld	s1,104(sp)
ffffffffc020572c:	7906                	ld	s2,96(sp)
ffffffffc020572e:	69e6                	ld	s3,88(sp)
ffffffffc0205730:	6a46                	ld	s4,80(sp)
ffffffffc0205732:	7c42                	ld	s8,48(sp)
ffffffffc0205734:	5cf1                	li	s9,-4
ffffffffc0205736:	b5cd                	j	ffffffffc0205618 <sysfile_read+0xa>
ffffffffc0205738:	00008697          	auipc	a3,0x8
ffffffffc020573c:	ec868693          	addi	a3,a3,-312 # ffffffffc020d600 <etext+0x1e3c>
ffffffffc0205740:	00006617          	auipc	a2,0x6
ffffffffc0205744:	4c060613          	addi	a2,a2,1216 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0205748:	05500593          	li	a1,85
ffffffffc020574c:	00008517          	auipc	a0,0x8
ffffffffc0205750:	ec450513          	addi	a0,a0,-316 # ffffffffc020d610 <etext+0x1e4c>
ffffffffc0205754:	fc5e                	sd	s7,56(sp)
ffffffffc0205756:	cf5fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020575a <sysfile_write>:
ffffffffc020575a:	e601                	bnez	a2,ffffffffc0205762 <sysfile_write+0x8>
ffffffffc020575c:	4701                	li	a4,0
ffffffffc020575e:	853a                	mv	a0,a4
ffffffffc0205760:	8082                	ret
ffffffffc0205762:	7159                	addi	sp,sp,-112
ffffffffc0205764:	f062                	sd	s8,32(sp)
ffffffffc0205766:	00091c17          	auipc	s8,0x91
ffffffffc020576a:	162c0c13          	addi	s8,s8,354 # ffffffffc02968c8 <current>
ffffffffc020576e:	000c3783          	ld	a5,0(s8)
ffffffffc0205772:	f0a2                	sd	s0,96(sp)
ffffffffc0205774:	eca6                	sd	s1,88(sp)
ffffffffc0205776:	8432                	mv	s0,a2
ffffffffc0205778:	84ae                	mv	s1,a1
ffffffffc020577a:	4605                	li	a2,1
ffffffffc020577c:	4581                	li	a1,0
ffffffffc020577e:	e8ca                	sd	s2,80(sp)
ffffffffc0205780:	e0d2                	sd	s4,64(sp)
ffffffffc0205782:	f486                	sd	ra,104(sp)
ffffffffc0205784:	0287b903          	ld	s2,40(a5) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc0205788:	8a2a                	mv	s4,a0
ffffffffc020578a:	b44ff0ef          	jal	ffffffffc0204ace <file_testfd>
ffffffffc020578e:	c969                	beqz	a0,ffffffffc0205860 <sysfile_write+0x106>
ffffffffc0205790:	6505                	lui	a0,0x1
ffffffffc0205792:	e4ce                	sd	s3,72(sp)
ffffffffc0205794:	82dfc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0205798:	89aa                	mv	s3,a0
ffffffffc020579a:	c569                	beqz	a0,ffffffffc0205864 <sysfile_write+0x10a>
ffffffffc020579c:	fc56                	sd	s5,56(sp)
ffffffffc020579e:	f45e                	sd	s7,40(sp)
ffffffffc02057a0:	4a81                	li	s5,0
ffffffffc02057a2:	6b85                	lui	s7,0x1
ffffffffc02057a4:	86a2                	mv	a3,s0
ffffffffc02057a6:	008bf363          	bgeu	s7,s0,ffffffffc02057ac <sysfile_write+0x52>
ffffffffc02057aa:	6685                	lui	a3,0x1
ffffffffc02057ac:	ec36                	sd	a3,24(sp)
ffffffffc02057ae:	04090e63          	beqz	s2,ffffffffc020580a <sysfile_write+0xb0>
ffffffffc02057b2:	03890513          	addi	a0,s2,56
ffffffffc02057b6:	e41fe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc02057ba:	000c3783          	ld	a5,0(s8)
ffffffffc02057be:	c781                	beqz	a5,ffffffffc02057c6 <sysfile_write+0x6c>
ffffffffc02057c0:	43dc                	lw	a5,4(a5)
ffffffffc02057c2:	04f92823          	sw	a5,80(s2)
ffffffffc02057c6:	66e2                	ld	a3,24(sp)
ffffffffc02057c8:	4701                	li	a4,0
ffffffffc02057ca:	8626                	mv	a2,s1
ffffffffc02057cc:	85ce                	mv	a1,s3
ffffffffc02057ce:	854a                	mv	a0,s2
ffffffffc02057d0:	bebfe0ef          	jal	ffffffffc02043ba <copy_from_user>
ffffffffc02057d4:	ed3d                	bnez	a0,ffffffffc0205852 <sysfile_write+0xf8>
ffffffffc02057d6:	03890513          	addi	a0,s2,56
ffffffffc02057da:	e19fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02057de:	04092823          	sw	zero,80(s2)
ffffffffc02057e2:	5775                	li	a4,-3
ffffffffc02057e4:	854e                	mv	a0,s3
ffffffffc02057e6:	e43a                	sd	a4,8(sp)
ffffffffc02057e8:	87ffc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02057ec:	6722                	ld	a4,8(sp)
ffffffffc02057ee:	040a9c63          	bnez	s5,ffffffffc0205846 <sysfile_write+0xec>
ffffffffc02057f2:	69a6                	ld	s3,72(sp)
ffffffffc02057f4:	7ae2                	ld	s5,56(sp)
ffffffffc02057f6:	7ba2                	ld	s7,40(sp)
ffffffffc02057f8:	70a6                	ld	ra,104(sp)
ffffffffc02057fa:	7406                	ld	s0,96(sp)
ffffffffc02057fc:	64e6                	ld	s1,88(sp)
ffffffffc02057fe:	6946                	ld	s2,80(sp)
ffffffffc0205800:	6a06                	ld	s4,64(sp)
ffffffffc0205802:	7c02                	ld	s8,32(sp)
ffffffffc0205804:	853a                	mv	a0,a4
ffffffffc0205806:	6165                	addi	sp,sp,112
ffffffffc0205808:	8082                	ret
ffffffffc020580a:	4701                	li	a4,0
ffffffffc020580c:	8626                	mv	a2,s1
ffffffffc020580e:	85ce                	mv	a1,s3
ffffffffc0205810:	4501                	li	a0,0
ffffffffc0205812:	ba9fe0ef          	jal	ffffffffc02043ba <copy_from_user>
ffffffffc0205816:	d571                	beqz	a0,ffffffffc02057e2 <sysfile_write+0x88>
ffffffffc0205818:	6662                	ld	a2,24(sp)
ffffffffc020581a:	0834                	addi	a3,sp,24
ffffffffc020581c:	85ce                	mv	a1,s3
ffffffffc020581e:	8552                	mv	a0,s4
ffffffffc0205820:	d62ff0ef          	jal	ffffffffc0204d82 <file_write>
ffffffffc0205824:	67e2                	ld	a5,24(sp)
ffffffffc0205826:	872a                	mv	a4,a0
ffffffffc0205828:	dfd5                	beqz	a5,ffffffffc02057e4 <sysfile_write+0x8a>
ffffffffc020582a:	04f46063          	bltu	s0,a5,ffffffffc020586a <sysfile_write+0x110>
ffffffffc020582e:	9abe                	add	s5,s5,a5
ffffffffc0205830:	f955                	bnez	a0,ffffffffc02057e4 <sysfile_write+0x8a>
ffffffffc0205832:	8c1d                	sub	s0,s0,a5
ffffffffc0205834:	94be                	add	s1,s1,a5
ffffffffc0205836:	f43d                	bnez	s0,ffffffffc02057a4 <sysfile_write+0x4a>
ffffffffc0205838:	854e                	mv	a0,s3
ffffffffc020583a:	e43a                	sd	a4,8(sp)
ffffffffc020583c:	82bfc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0205840:	6722                	ld	a4,8(sp)
ffffffffc0205842:	fa0a88e3          	beqz	s5,ffffffffc02057f2 <sysfile_write+0x98>
ffffffffc0205846:	000a871b          	sext.w	a4,s5
ffffffffc020584a:	69a6                	ld	s3,72(sp)
ffffffffc020584c:	7ae2                	ld	s5,56(sp)
ffffffffc020584e:	7ba2                	ld	s7,40(sp)
ffffffffc0205850:	b765                	j	ffffffffc02057f8 <sysfile_write+0x9e>
ffffffffc0205852:	03890513          	addi	a0,s2,56
ffffffffc0205856:	d9dfe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020585a:	04092823          	sw	zero,80(s2)
ffffffffc020585e:	bf6d                	j	ffffffffc0205818 <sysfile_write+0xbe>
ffffffffc0205860:	5775                	li	a4,-3
ffffffffc0205862:	bf59                	j	ffffffffc02057f8 <sysfile_write+0x9e>
ffffffffc0205864:	69a6                	ld	s3,72(sp)
ffffffffc0205866:	5771                	li	a4,-4
ffffffffc0205868:	bf41                	j	ffffffffc02057f8 <sysfile_write+0x9e>
ffffffffc020586a:	00008697          	auipc	a3,0x8
ffffffffc020586e:	d9668693          	addi	a3,a3,-618 # ffffffffc020d600 <etext+0x1e3c>
ffffffffc0205872:	00006617          	auipc	a2,0x6
ffffffffc0205876:	38e60613          	addi	a2,a2,910 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020587a:	08a00593          	li	a1,138
ffffffffc020587e:	00008517          	auipc	a0,0x8
ffffffffc0205882:	d9250513          	addi	a0,a0,-622 # ffffffffc020d610 <etext+0x1e4c>
ffffffffc0205886:	f85a                	sd	s6,48(sp)
ffffffffc0205888:	bc3fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020588c <sysfile_seek>:
ffffffffc020588c:	de4ff06f          	j	ffffffffc0204e70 <file_seek>

ffffffffc0205890 <sysfile_fstat>:
ffffffffc0205890:	715d                	addi	sp,sp,-80
ffffffffc0205892:	f84a                	sd	s2,48(sp)
ffffffffc0205894:	00091917          	auipc	s2,0x91
ffffffffc0205898:	03490913          	addi	s2,s2,52 # ffffffffc02968c8 <current>
ffffffffc020589c:	00093783          	ld	a5,0(s2)
ffffffffc02058a0:	f44e                	sd	s3,40(sp)
ffffffffc02058a2:	89ae                	mv	s3,a1
ffffffffc02058a4:	858a                	mv	a1,sp
ffffffffc02058a6:	e0a2                	sd	s0,64(sp)
ffffffffc02058a8:	fc26                	sd	s1,56(sp)
ffffffffc02058aa:	e486                	sd	ra,72(sp)
ffffffffc02058ac:	7784                	ld	s1,40(a5)
ffffffffc02058ae:	ee6ff0ef          	jal	ffffffffc0204f94 <file_fstat>
ffffffffc02058b2:	842a                	mv	s0,a0
ffffffffc02058b4:	e915                	bnez	a0,ffffffffc02058e8 <sysfile_fstat+0x58>
ffffffffc02058b6:	c0a9                	beqz	s1,ffffffffc02058f8 <sysfile_fstat+0x68>
ffffffffc02058b8:	03848513          	addi	a0,s1,56
ffffffffc02058bc:	d3bfe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc02058c0:	00093783          	ld	a5,0(s2)
ffffffffc02058c4:	c399                	beqz	a5,ffffffffc02058ca <sysfile_fstat+0x3a>
ffffffffc02058c6:	43dc                	lw	a5,4(a5)
ffffffffc02058c8:	c8bc                	sw	a5,80(s1)
ffffffffc02058ca:	860a                	mv	a2,sp
ffffffffc02058cc:	85ce                	mv	a1,s3
ffffffffc02058ce:	02000693          	li	a3,32
ffffffffc02058d2:	8526                	mv	a0,s1
ffffffffc02058d4:	b1dfe0ef          	jal	ffffffffc02043f0 <copy_to_user>
ffffffffc02058d8:	e111                	bnez	a0,ffffffffc02058dc <sysfile_fstat+0x4c>
ffffffffc02058da:	5475                	li	s0,-3
ffffffffc02058dc:	03848513          	addi	a0,s1,56
ffffffffc02058e0:	d13fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02058e4:	0404a823          	sw	zero,80(s1)
ffffffffc02058e8:	60a6                	ld	ra,72(sp)
ffffffffc02058ea:	8522                	mv	a0,s0
ffffffffc02058ec:	6406                	ld	s0,64(sp)
ffffffffc02058ee:	74e2                	ld	s1,56(sp)
ffffffffc02058f0:	7942                	ld	s2,48(sp)
ffffffffc02058f2:	79a2                	ld	s3,40(sp)
ffffffffc02058f4:	6161                	addi	sp,sp,80
ffffffffc02058f6:	8082                	ret
ffffffffc02058f8:	860a                	mv	a2,sp
ffffffffc02058fa:	85ce                	mv	a1,s3
ffffffffc02058fc:	02000693          	li	a3,32
ffffffffc0205900:	af1fe0ef          	jal	ffffffffc02043f0 <copy_to_user>
ffffffffc0205904:	f175                	bnez	a0,ffffffffc02058e8 <sysfile_fstat+0x58>
ffffffffc0205906:	5475                	li	s0,-3
ffffffffc0205908:	60a6                	ld	ra,72(sp)
ffffffffc020590a:	8522                	mv	a0,s0
ffffffffc020590c:	6406                	ld	s0,64(sp)
ffffffffc020590e:	74e2                	ld	s1,56(sp)
ffffffffc0205910:	7942                	ld	s2,48(sp)
ffffffffc0205912:	79a2                	ld	s3,40(sp)
ffffffffc0205914:	6161                	addi	sp,sp,80
ffffffffc0205916:	8082                	ret

ffffffffc0205918 <sysfile_fsync>:
ffffffffc0205918:	f34ff06f          	j	ffffffffc020504c <file_fsync>

ffffffffc020591c <sysfile_getcwd>:
ffffffffc020591c:	c1d5                	beqz	a1,ffffffffc02059c0 <sysfile_getcwd+0xa4>
ffffffffc020591e:	00091717          	auipc	a4,0x91
ffffffffc0205922:	faa73703          	ld	a4,-86(a4) # ffffffffc02968c8 <current>
ffffffffc0205926:	711d                	addi	sp,sp,-96
ffffffffc0205928:	e8a2                	sd	s0,80(sp)
ffffffffc020592a:	7700                	ld	s0,40(a4)
ffffffffc020592c:	e4a6                	sd	s1,72(sp)
ffffffffc020592e:	e0ca                	sd	s2,64(sp)
ffffffffc0205930:	ec86                	sd	ra,88(sp)
ffffffffc0205932:	892a                	mv	s2,a0
ffffffffc0205934:	84ae                	mv	s1,a1
ffffffffc0205936:	c039                	beqz	s0,ffffffffc020597c <sysfile_getcwd+0x60>
ffffffffc0205938:	03840513          	addi	a0,s0,56
ffffffffc020593c:	cbbfe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0205940:	00091797          	auipc	a5,0x91
ffffffffc0205944:	f887b783          	ld	a5,-120(a5) # ffffffffc02968c8 <current>
ffffffffc0205948:	c399                	beqz	a5,ffffffffc020594e <sysfile_getcwd+0x32>
ffffffffc020594a:	43dc                	lw	a5,4(a5)
ffffffffc020594c:	c83c                	sw	a5,80(s0)
ffffffffc020594e:	4685                	li	a3,1
ffffffffc0205950:	8626                	mv	a2,s1
ffffffffc0205952:	85ca                	mv	a1,s2
ffffffffc0205954:	8522                	mv	a0,s0
ffffffffc0205956:	9c1fe0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc020595a:	57f5                	li	a5,-3
ffffffffc020595c:	e921                	bnez	a0,ffffffffc02059ac <sysfile_getcwd+0x90>
ffffffffc020595e:	03840513          	addi	a0,s0,56
ffffffffc0205962:	e43e                	sd	a5,8(sp)
ffffffffc0205964:	c8ffe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205968:	67a2                	ld	a5,8(sp)
ffffffffc020596a:	04042823          	sw	zero,80(s0)
ffffffffc020596e:	60e6                	ld	ra,88(sp)
ffffffffc0205970:	6446                	ld	s0,80(sp)
ffffffffc0205972:	64a6                	ld	s1,72(sp)
ffffffffc0205974:	6906                	ld	s2,64(sp)
ffffffffc0205976:	853e                	mv	a0,a5
ffffffffc0205978:	6125                	addi	sp,sp,96
ffffffffc020597a:	8082                	ret
ffffffffc020597c:	862e                	mv	a2,a1
ffffffffc020597e:	4685                	li	a3,1
ffffffffc0205980:	85aa                	mv	a1,a0
ffffffffc0205982:	4501                	li	a0,0
ffffffffc0205984:	993fe0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc0205988:	57f5                	li	a5,-3
ffffffffc020598a:	d175                	beqz	a0,ffffffffc020596e <sysfile_getcwd+0x52>
ffffffffc020598c:	8626                	mv	a2,s1
ffffffffc020598e:	85ca                	mv	a1,s2
ffffffffc0205990:	4681                	li	a3,0
ffffffffc0205992:	0808                	addi	a0,sp,16
ffffffffc0205994:	af9ff0ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc0205998:	449020ef          	jal	ffffffffc02085e0 <vfs_getcwd>
ffffffffc020599c:	60e6                	ld	ra,88(sp)
ffffffffc020599e:	6446                	ld	s0,80(sp)
ffffffffc02059a0:	87aa                	mv	a5,a0
ffffffffc02059a2:	64a6                	ld	s1,72(sp)
ffffffffc02059a4:	6906                	ld	s2,64(sp)
ffffffffc02059a6:	853e                	mv	a0,a5
ffffffffc02059a8:	6125                	addi	sp,sp,96
ffffffffc02059aa:	8082                	ret
ffffffffc02059ac:	8626                	mv	a2,s1
ffffffffc02059ae:	85ca                	mv	a1,s2
ffffffffc02059b0:	4681                	li	a3,0
ffffffffc02059b2:	0808                	addi	a0,sp,16
ffffffffc02059b4:	ad9ff0ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc02059b8:	429020ef          	jal	ffffffffc02085e0 <vfs_getcwd>
ffffffffc02059bc:	87aa                	mv	a5,a0
ffffffffc02059be:	b745                	j	ffffffffc020595e <sysfile_getcwd+0x42>
ffffffffc02059c0:	57f5                	li	a5,-3
ffffffffc02059c2:	853e                	mv	a0,a5
ffffffffc02059c4:	8082                	ret

ffffffffc02059c6 <sysfile_getdirentry>:
ffffffffc02059c6:	7139                	addi	sp,sp,-64
ffffffffc02059c8:	ec4e                	sd	s3,24(sp)
ffffffffc02059ca:	00091997          	auipc	s3,0x91
ffffffffc02059ce:	efe98993          	addi	s3,s3,-258 # ffffffffc02968c8 <current>
ffffffffc02059d2:	0009b783          	ld	a5,0(s3)
ffffffffc02059d6:	f04a                	sd	s2,32(sp)
ffffffffc02059d8:	892a                	mv	s2,a0
ffffffffc02059da:	10800513          	li	a0,264
ffffffffc02059de:	f426                	sd	s1,40(sp)
ffffffffc02059e0:	e852                	sd	s4,16(sp)
ffffffffc02059e2:	fc06                	sd	ra,56(sp)
ffffffffc02059e4:	7784                	ld	s1,40(a5)
ffffffffc02059e6:	8a2e                	mv	s4,a1
ffffffffc02059e8:	dd8fc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc02059ec:	c179                	beqz	a0,ffffffffc0205ab2 <sysfile_getdirentry+0xec>
ffffffffc02059ee:	f822                	sd	s0,48(sp)
ffffffffc02059f0:	842a                	mv	s0,a0
ffffffffc02059f2:	c8d1                	beqz	s1,ffffffffc0205a86 <sysfile_getdirentry+0xc0>
ffffffffc02059f4:	03848513          	addi	a0,s1,56
ffffffffc02059f8:	bfffe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc02059fc:	0009b783          	ld	a5,0(s3)
ffffffffc0205a00:	c399                	beqz	a5,ffffffffc0205a06 <sysfile_getdirentry+0x40>
ffffffffc0205a02:	43dc                	lw	a5,4(a5)
ffffffffc0205a04:	c8bc                	sw	a5,80(s1)
ffffffffc0205a06:	4705                	li	a4,1
ffffffffc0205a08:	46a1                	li	a3,8
ffffffffc0205a0a:	8652                	mv	a2,s4
ffffffffc0205a0c:	85a2                	mv	a1,s0
ffffffffc0205a0e:	8526                	mv	a0,s1
ffffffffc0205a10:	9abfe0ef          	jal	ffffffffc02043ba <copy_from_user>
ffffffffc0205a14:	e505                	bnez	a0,ffffffffc0205a3c <sysfile_getdirentry+0x76>
ffffffffc0205a16:	03848513          	addi	a0,s1,56
ffffffffc0205a1a:	bd9fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205a1e:	0404a823          	sw	zero,80(s1)
ffffffffc0205a22:	5975                	li	s2,-3
ffffffffc0205a24:	8522                	mv	a0,s0
ffffffffc0205a26:	e40fc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0205a2a:	7442                	ld	s0,48(sp)
ffffffffc0205a2c:	70e2                	ld	ra,56(sp)
ffffffffc0205a2e:	74a2                	ld	s1,40(sp)
ffffffffc0205a30:	69e2                	ld	s3,24(sp)
ffffffffc0205a32:	6a42                	ld	s4,16(sp)
ffffffffc0205a34:	854a                	mv	a0,s2
ffffffffc0205a36:	7902                	ld	s2,32(sp)
ffffffffc0205a38:	6121                	addi	sp,sp,64
ffffffffc0205a3a:	8082                	ret
ffffffffc0205a3c:	03848513          	addi	a0,s1,56
ffffffffc0205a40:	bb3fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205a44:	854a                	mv	a0,s2
ffffffffc0205a46:	0404a823          	sw	zero,80(s1)
ffffffffc0205a4a:	85a2                	mv	a1,s0
ffffffffc0205a4c:	eaaff0ef          	jal	ffffffffc02050f6 <file_getdirentry>
ffffffffc0205a50:	892a                	mv	s2,a0
ffffffffc0205a52:	f969                	bnez	a0,ffffffffc0205a24 <sysfile_getdirentry+0x5e>
ffffffffc0205a54:	03848513          	addi	a0,s1,56
ffffffffc0205a58:	b9ffe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0205a5c:	0009b783          	ld	a5,0(s3)
ffffffffc0205a60:	c399                	beqz	a5,ffffffffc0205a66 <sysfile_getdirentry+0xa0>
ffffffffc0205a62:	43dc                	lw	a5,4(a5)
ffffffffc0205a64:	c8bc                	sw	a5,80(s1)
ffffffffc0205a66:	85d2                	mv	a1,s4
ffffffffc0205a68:	10800693          	li	a3,264
ffffffffc0205a6c:	8622                	mv	a2,s0
ffffffffc0205a6e:	8526                	mv	a0,s1
ffffffffc0205a70:	981fe0ef          	jal	ffffffffc02043f0 <copy_to_user>
ffffffffc0205a74:	e111                	bnez	a0,ffffffffc0205a78 <sysfile_getdirentry+0xb2>
ffffffffc0205a76:	5975                	li	s2,-3
ffffffffc0205a78:	03848513          	addi	a0,s1,56
ffffffffc0205a7c:	b77fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205a80:	0404a823          	sw	zero,80(s1)
ffffffffc0205a84:	b745                	j	ffffffffc0205a24 <sysfile_getdirentry+0x5e>
ffffffffc0205a86:	85aa                	mv	a1,a0
ffffffffc0205a88:	4705                	li	a4,1
ffffffffc0205a8a:	46a1                	li	a3,8
ffffffffc0205a8c:	8652                	mv	a2,s4
ffffffffc0205a8e:	4501                	li	a0,0
ffffffffc0205a90:	92bfe0ef          	jal	ffffffffc02043ba <copy_from_user>
ffffffffc0205a94:	d559                	beqz	a0,ffffffffc0205a22 <sysfile_getdirentry+0x5c>
ffffffffc0205a96:	854a                	mv	a0,s2
ffffffffc0205a98:	85a2                	mv	a1,s0
ffffffffc0205a9a:	e5cff0ef          	jal	ffffffffc02050f6 <file_getdirentry>
ffffffffc0205a9e:	892a                	mv	s2,a0
ffffffffc0205aa0:	f151                	bnez	a0,ffffffffc0205a24 <sysfile_getdirentry+0x5e>
ffffffffc0205aa2:	85d2                	mv	a1,s4
ffffffffc0205aa4:	10800693          	li	a3,264
ffffffffc0205aa8:	8622                	mv	a2,s0
ffffffffc0205aaa:	947fe0ef          	jal	ffffffffc02043f0 <copy_to_user>
ffffffffc0205aae:	f93d                	bnez	a0,ffffffffc0205a24 <sysfile_getdirentry+0x5e>
ffffffffc0205ab0:	bf8d                	j	ffffffffc0205a22 <sysfile_getdirentry+0x5c>
ffffffffc0205ab2:	5971                	li	s2,-4
ffffffffc0205ab4:	bfa5                	j	ffffffffc0205a2c <sysfile_getdirentry+0x66>

ffffffffc0205ab6 <sysfile_dup>:
ffffffffc0205ab6:	f2eff06f          	j	ffffffffc02051e4 <file_dup>

ffffffffc0205aba <kernel_thread_entry>:
ffffffffc0205aba:	8526                	mv	a0,s1
ffffffffc0205abc:	9402                	jalr	s0
ffffffffc0205abe:	688000ef          	jal	ffffffffc0206146 <do_exit>

ffffffffc0205ac2 <alloc_proc>:
ffffffffc0205ac2:	1141                	addi	sp,sp,-16
ffffffffc0205ac4:	15000513          	li	a0,336
ffffffffc0205ac8:	e022                	sd	s0,0(sp)
ffffffffc0205aca:	e406                	sd	ra,8(sp)
ffffffffc0205acc:	cf4fc0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0205ad0:	842a                	mv	s0,a0
ffffffffc0205ad2:	c141                	beqz	a0,ffffffffc0205b52 <alloc_proc+0x90>
ffffffffc0205ad4:	57fd                	li	a5,-1
ffffffffc0205ad6:	1782                	slli	a5,a5,0x20
ffffffffc0205ad8:	e11c                	sd	a5,0(a0)
ffffffffc0205ada:	00052423          	sw	zero,8(a0)
ffffffffc0205ade:	00053823          	sd	zero,16(a0)
ffffffffc0205ae2:	00053c23          	sd	zero,24(a0)
ffffffffc0205ae6:	02053023          	sd	zero,32(a0)
ffffffffc0205aea:	02053423          	sd	zero,40(a0)
ffffffffc0205aee:	07000613          	li	a2,112
ffffffffc0205af2:	4581                	li	a1,0
ffffffffc0205af4:	03050513          	addi	a0,a0,48
ffffffffc0205af8:	465050ef          	jal	ffffffffc020b75c <memset>
ffffffffc0205afc:	00091797          	auipc	a5,0x91
ffffffffc0205b00:	d9c7b783          	ld	a5,-612(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0205b04:	0a043023          	sd	zero,160(s0)
ffffffffc0205b08:	0a042823          	sw	zero,176(s0)
ffffffffc0205b0c:	f45c                	sd	a5,168(s0)
ffffffffc0205b0e:	0b440513          	addi	a0,s0,180
ffffffffc0205b12:	463d                	li	a2,15
ffffffffc0205b14:	4581                	li	a1,0
ffffffffc0205b16:	447050ef          	jal	ffffffffc020b75c <memset>
ffffffffc0205b1a:	11040793          	addi	a5,s0,272
ffffffffc0205b1e:	0e042623          	sw	zero,236(s0)
ffffffffc0205b22:	0e043c23          	sd	zero,248(s0)
ffffffffc0205b26:	10043023          	sd	zero,256(s0)
ffffffffc0205b2a:	0e043823          	sd	zero,240(s0)
ffffffffc0205b2e:	10043423          	sd	zero,264(s0)
ffffffffc0205b32:	12042023          	sw	zero,288(s0)
ffffffffc0205b36:	12043423          	sd	zero,296(s0)
ffffffffc0205b3a:	12043c23          	sd	zero,312(s0)
ffffffffc0205b3e:	12043823          	sd	zero,304(s0)
ffffffffc0205b42:	14043023          	sd	zero,320(s0)
ffffffffc0205b46:	14043423          	sd	zero,328(s0)
ffffffffc0205b4a:	10f43c23          	sd	a5,280(s0)
ffffffffc0205b4e:	10f43823          	sd	a5,272(s0)
ffffffffc0205b52:	60a2                	ld	ra,8(sp)
ffffffffc0205b54:	8522                	mv	a0,s0
ffffffffc0205b56:	6402                	ld	s0,0(sp)
ffffffffc0205b58:	0141                	addi	sp,sp,16
ffffffffc0205b5a:	8082                	ret

ffffffffc0205b5c <forkret>:
ffffffffc0205b5c:	00091797          	auipc	a5,0x91
ffffffffc0205b60:	d6c7b783          	ld	a5,-660(a5) # ffffffffc02968c8 <current>
ffffffffc0205b64:	73c8                	ld	a0,160(a5)
ffffffffc0205b66:	ee8fb06f          	j	ffffffffc020124e <forkrets>

ffffffffc0205b6a <put_pgdir.isra.0>:
ffffffffc0205b6a:	1141                	addi	sp,sp,-16
ffffffffc0205b6c:	e406                	sd	ra,8(sp)
ffffffffc0205b6e:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b72:	02f56f63          	bltu	a0,a5,ffffffffc0205bb0 <put_pgdir.isra.0+0x46>
ffffffffc0205b76:	00091797          	auipc	a5,0x91
ffffffffc0205b7a:	d327b783          	ld	a5,-718(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205b7e:	00091717          	auipc	a4,0x91
ffffffffc0205b82:	d3273703          	ld	a4,-718(a4) # ffffffffc02968b0 <npage>
ffffffffc0205b86:	8d1d                	sub	a0,a0,a5
ffffffffc0205b88:	00c55793          	srli	a5,a0,0xc
ffffffffc0205b8c:	02e7ff63          	bgeu	a5,a4,ffffffffc0205bca <put_pgdir.isra.0+0x60>
ffffffffc0205b90:	0000a717          	auipc	a4,0xa
ffffffffc0205b94:	f3073703          	ld	a4,-208(a4) # ffffffffc020fac0 <nbase>
ffffffffc0205b98:	00091517          	auipc	a0,0x91
ffffffffc0205b9c:	d2053503          	ld	a0,-736(a0) # ffffffffc02968b8 <pages>
ffffffffc0205ba0:	60a2                	ld	ra,8(sp)
ffffffffc0205ba2:	8f99                	sub	a5,a5,a4
ffffffffc0205ba4:	079a                	slli	a5,a5,0x6
ffffffffc0205ba6:	4585                	li	a1,1
ffffffffc0205ba8:	953e                	add	a0,a0,a5
ffffffffc0205baa:	0141                	addi	sp,sp,16
ffffffffc0205bac:	e12fc06f          	j	ffffffffc02021be <free_pages>
ffffffffc0205bb0:	86aa                	mv	a3,a0
ffffffffc0205bb2:	00007617          	auipc	a2,0x7
ffffffffc0205bb6:	b6e60613          	addi	a2,a2,-1170 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0205bba:	07700593          	li	a1,119
ffffffffc0205bbe:	00007517          	auipc	a0,0x7
ffffffffc0205bc2:	ae250513          	addi	a0,a0,-1310 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0205bc6:	885fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205bca:	00007617          	auipc	a2,0x7
ffffffffc0205bce:	b7e60613          	addi	a2,a2,-1154 # ffffffffc020c748 <etext+0xf84>
ffffffffc0205bd2:	06900593          	li	a1,105
ffffffffc0205bd6:	00007517          	auipc	a0,0x7
ffffffffc0205bda:	aca50513          	addi	a0,a0,-1334 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0205bde:	86dfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205be2 <setup_pgdir>:
ffffffffc0205be2:	1101                	addi	sp,sp,-32
ffffffffc0205be4:	e426                	sd	s1,8(sp)
ffffffffc0205be6:	84aa                	mv	s1,a0
ffffffffc0205be8:	4505                	li	a0,1
ffffffffc0205bea:	ec06                	sd	ra,24(sp)
ffffffffc0205bec:	d98fc0ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0205bf0:	cd29                	beqz	a0,ffffffffc0205c4a <setup_pgdir+0x68>
ffffffffc0205bf2:	00091697          	auipc	a3,0x91
ffffffffc0205bf6:	cc66b683          	ld	a3,-826(a3) # ffffffffc02968b8 <pages>
ffffffffc0205bfa:	0000a797          	auipc	a5,0xa
ffffffffc0205bfe:	ec67b783          	ld	a5,-314(a5) # ffffffffc020fac0 <nbase>
ffffffffc0205c02:	00091717          	auipc	a4,0x91
ffffffffc0205c06:	cae73703          	ld	a4,-850(a4) # ffffffffc02968b0 <npage>
ffffffffc0205c0a:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c0e:	8699                	srai	a3,a3,0x6
ffffffffc0205c10:	96be                	add	a3,a3,a5
ffffffffc0205c12:	00c69793          	slli	a5,a3,0xc
ffffffffc0205c16:	e822                	sd	s0,16(sp)
ffffffffc0205c18:	83b1                	srli	a5,a5,0xc
ffffffffc0205c1a:	06b2                	slli	a3,a3,0xc
ffffffffc0205c1c:	02e7f963          	bgeu	a5,a4,ffffffffc0205c4e <setup_pgdir+0x6c>
ffffffffc0205c20:	00091797          	auipc	a5,0x91
ffffffffc0205c24:	c887b783          	ld	a5,-888(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205c28:	00091597          	auipc	a1,0x91
ffffffffc0205c2c:	c785b583          	ld	a1,-904(a1) # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0205c30:	6605                	lui	a2,0x1
ffffffffc0205c32:	00f68433          	add	s0,a3,a5
ffffffffc0205c36:	8522                	mv	a0,s0
ffffffffc0205c38:	375050ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0205c3c:	ec80                	sd	s0,24(s1)
ffffffffc0205c3e:	6442                	ld	s0,16(sp)
ffffffffc0205c40:	4501                	li	a0,0
ffffffffc0205c42:	60e2                	ld	ra,24(sp)
ffffffffc0205c44:	64a2                	ld	s1,8(sp)
ffffffffc0205c46:	6105                	addi	sp,sp,32
ffffffffc0205c48:	8082                	ret
ffffffffc0205c4a:	5571                	li	a0,-4
ffffffffc0205c4c:	bfdd                	j	ffffffffc0205c42 <setup_pgdir+0x60>
ffffffffc0205c4e:	00007617          	auipc	a2,0x7
ffffffffc0205c52:	a2a60613          	addi	a2,a2,-1494 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0205c56:	07100593          	li	a1,113
ffffffffc0205c5a:	00007517          	auipc	a0,0x7
ffffffffc0205c5e:	a4650513          	addi	a0,a0,-1466 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0205c62:	fe8fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205c66 <proc_run>:
ffffffffc0205c66:	00091697          	auipc	a3,0x91
ffffffffc0205c6a:	c626b683          	ld	a3,-926(a3) # ffffffffc02968c8 <current>
ffffffffc0205c6e:	04a68663          	beq	a3,a0,ffffffffc0205cba <proc_run+0x54>
ffffffffc0205c72:	1101                	addi	sp,sp,-32
ffffffffc0205c74:	ec06                	sd	ra,24(sp)
ffffffffc0205c76:	100027f3          	csrr	a5,sstatus
ffffffffc0205c7a:	8b89                	andi	a5,a5,2
ffffffffc0205c7c:	4601                	li	a2,0
ffffffffc0205c7e:	ef9d                	bnez	a5,ffffffffc0205cbc <proc_run+0x56>
ffffffffc0205c80:	755c                	ld	a5,168(a0)
ffffffffc0205c82:	577d                	li	a4,-1
ffffffffc0205c84:	177e                	slli	a4,a4,0x3f
ffffffffc0205c86:	83b1                	srli	a5,a5,0xc
ffffffffc0205c88:	e032                	sd	a2,0(sp)
ffffffffc0205c8a:	00091597          	auipc	a1,0x91
ffffffffc0205c8e:	c2a5bf23          	sd	a0,-962(a1) # ffffffffc02968c8 <current>
ffffffffc0205c92:	8fd9                	or	a5,a5,a4
ffffffffc0205c94:	18079073          	csrw	satp,a5
ffffffffc0205c98:	12000073          	sfence.vma
ffffffffc0205c9c:	03050593          	addi	a1,a0,48
ffffffffc0205ca0:	03068513          	addi	a0,a3,48
ffffffffc0205ca4:	564010ef          	jal	ffffffffc0207208 <switch_to>
ffffffffc0205ca8:	6602                	ld	a2,0(sp)
ffffffffc0205caa:	e601                	bnez	a2,ffffffffc0205cb2 <proc_run+0x4c>
ffffffffc0205cac:	60e2                	ld	ra,24(sp)
ffffffffc0205cae:	6105                	addi	sp,sp,32
ffffffffc0205cb0:	8082                	ret
ffffffffc0205cb2:	60e2                	ld	ra,24(sp)
ffffffffc0205cb4:	6105                	addi	sp,sp,32
ffffffffc0205cb6:	f1dfa06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0205cba:	8082                	ret
ffffffffc0205cbc:	e42a                	sd	a0,8(sp)
ffffffffc0205cbe:	e036                	sd	a3,0(sp)
ffffffffc0205cc0:	f19fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0205cc4:	6522                	ld	a0,8(sp)
ffffffffc0205cc6:	6682                	ld	a3,0(sp)
ffffffffc0205cc8:	4605                	li	a2,1
ffffffffc0205cca:	bf5d                	j	ffffffffc0205c80 <proc_run+0x1a>

ffffffffc0205ccc <do_fork>:
ffffffffc0205ccc:	00091717          	auipc	a4,0x91
ffffffffc0205cd0:	bf472703          	lw	a4,-1036(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205cd4:	6785                	lui	a5,0x1
ffffffffc0205cd6:	34f75a63          	bge	a4,a5,ffffffffc020602a <do_fork+0x35e>
ffffffffc0205cda:	7119                	addi	sp,sp,-128
ffffffffc0205cdc:	f8a2                	sd	s0,112(sp)
ffffffffc0205cde:	f4a6                	sd	s1,104(sp)
ffffffffc0205ce0:	f0ca                	sd	s2,96(sp)
ffffffffc0205ce2:	ecce                	sd	s3,88(sp)
ffffffffc0205ce4:	fc86                	sd	ra,120(sp)
ffffffffc0205ce6:	892e                	mv	s2,a1
ffffffffc0205ce8:	84b2                	mv	s1,a2
ffffffffc0205cea:	89aa                	mv	s3,a0
ffffffffc0205cec:	dd7ff0ef          	jal	ffffffffc0205ac2 <alloc_proc>
ffffffffc0205cf0:	842a                	mv	s0,a0
ffffffffc0205cf2:	2a050263          	beqz	a0,ffffffffc0205f96 <do_fork+0x2ca>
ffffffffc0205cf6:	f466                	sd	s9,40(sp)
ffffffffc0205cf8:	00091c97          	auipc	s9,0x91
ffffffffc0205cfc:	bd0c8c93          	addi	s9,s9,-1072 # ffffffffc02968c8 <current>
ffffffffc0205d00:	000cb783          	ld	a5,0(s9)
ffffffffc0205d04:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205d08:	f11c                	sd	a5,32(a0)
ffffffffc0205d0a:	3a071163          	bnez	a4,ffffffffc02060ac <do_fork+0x3e0>
ffffffffc0205d0e:	4509                	li	a0,2
ffffffffc0205d10:	c74fc0ef          	jal	ffffffffc0202184 <alloc_pages>
ffffffffc0205d14:	26050d63          	beqz	a0,ffffffffc0205f8e <do_fork+0x2c2>
ffffffffc0205d18:	e4d6                	sd	s5,72(sp)
ffffffffc0205d1a:	00091a97          	auipc	s5,0x91
ffffffffc0205d1e:	b9ea8a93          	addi	s5,s5,-1122 # ffffffffc02968b8 <pages>
ffffffffc0205d22:	000ab783          	ld	a5,0(s5)
ffffffffc0205d26:	e8d2                	sd	s4,80(sp)
ffffffffc0205d28:	0000aa17          	auipc	s4,0xa
ffffffffc0205d2c:	d98a3a03          	ld	s4,-616(s4) # ffffffffc020fac0 <nbase>
ffffffffc0205d30:	40f506b3          	sub	a3,a0,a5
ffffffffc0205d34:	e0da                	sd	s6,64(sp)
ffffffffc0205d36:	8699                	srai	a3,a3,0x6
ffffffffc0205d38:	00091b17          	auipc	s6,0x91
ffffffffc0205d3c:	b78b0b13          	addi	s6,s6,-1160 # ffffffffc02968b0 <npage>
ffffffffc0205d40:	96d2                	add	a3,a3,s4
ffffffffc0205d42:	000b3703          	ld	a4,0(s6)
ffffffffc0205d46:	00c69793          	slli	a5,a3,0xc
ffffffffc0205d4a:	fc5e                	sd	s7,56(sp)
ffffffffc0205d4c:	f862                	sd	s8,48(sp)
ffffffffc0205d4e:	83b1                	srli	a5,a5,0xc
ffffffffc0205d50:	06b2                	slli	a3,a3,0xc
ffffffffc0205d52:	38e7f463          	bgeu	a5,a4,ffffffffc02060da <do_fork+0x40e>
ffffffffc0205d56:	000cb703          	ld	a4,0(s9)
ffffffffc0205d5a:	00091b97          	auipc	s7,0x91
ffffffffc0205d5e:	b4eb8b93          	addi	s7,s7,-1202 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205d62:	000bb783          	ld	a5,0(s7)
ffffffffc0205d66:	02873c03          	ld	s8,40(a4)
ffffffffc0205d6a:	96be                	add	a3,a3,a5
ffffffffc0205d6c:	e814                	sd	a3,16(s0)
ffffffffc0205d6e:	020c0a63          	beqz	s8,ffffffffc0205da2 <do_fork+0xd6>
ffffffffc0205d72:	1009f793          	andi	a5,s3,256
ffffffffc0205d76:	1c078363          	beqz	a5,ffffffffc0205f3c <do_fork+0x270>
ffffffffc0205d7a:	030c2703          	lw	a4,48(s8)
ffffffffc0205d7e:	018c3783          	ld	a5,24(s8)
ffffffffc0205d82:	c02006b7          	lui	a3,0xc0200
ffffffffc0205d86:	2705                	addiw	a4,a4,1
ffffffffc0205d88:	02ec2823          	sw	a4,48(s8)
ffffffffc0205d8c:	03843423          	sd	s8,40(s0)
ffffffffc0205d90:	2ed7ef63          	bltu	a5,a3,ffffffffc020608e <do_fork+0x3c2>
ffffffffc0205d94:	000bb603          	ld	a2,0(s7)
ffffffffc0205d98:	000cb703          	ld	a4,0(s9)
ffffffffc0205d9c:	6814                	ld	a3,16(s0)
ffffffffc0205d9e:	8f91                	sub	a5,a5,a2
ffffffffc0205da0:	f45c                	sd	a5,168(s0)
ffffffffc0205da2:	6789                	lui	a5,0x2
ffffffffc0205da4:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205da8:	96be                	add	a3,a3,a5
ffffffffc0205daa:	f054                	sd	a3,160(s0)
ffffffffc0205dac:	87b6                	mv	a5,a3
ffffffffc0205dae:	12048613          	addi	a2,s1,288
ffffffffc0205db2:	688c                	ld	a1,16(s1)
ffffffffc0205db4:	0004b803          	ld	a6,0(s1)
ffffffffc0205db8:	6488                	ld	a0,8(s1)
ffffffffc0205dba:	eb8c                	sd	a1,16(a5)
ffffffffc0205dbc:	0107b023          	sd	a6,0(a5)
ffffffffc0205dc0:	e788                	sd	a0,8(a5)
ffffffffc0205dc2:	6c8c                	ld	a1,24(s1)
ffffffffc0205dc4:	02048493          	addi	s1,s1,32
ffffffffc0205dc8:	02078793          	addi	a5,a5,32
ffffffffc0205dcc:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0205dd0:	fec491e3          	bne	s1,a2,ffffffffc0205db2 <do_fork+0xe6>
ffffffffc0205dd4:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205dd8:	1c090163          	beqz	s2,ffffffffc0205f9a <do_fork+0x2ce>
ffffffffc0205ddc:	14873483          	ld	s1,328(a4)
ffffffffc0205de0:	00000797          	auipc	a5,0x0
ffffffffc0205de4:	d7c78793          	addi	a5,a5,-644 # ffffffffc0205b5c <forkret>
ffffffffc0205de8:	0126b823          	sd	s2,16(a3)
ffffffffc0205dec:	fc14                	sd	a3,56(s0)
ffffffffc0205dee:	f81c                	sd	a5,48(s0)
ffffffffc0205df0:	24048f63          	beqz	s1,ffffffffc020604e <do_fork+0x382>
ffffffffc0205df4:	03499793          	slli	a5,s3,0x34
ffffffffc0205df8:	0007cd63          	bltz	a5,ffffffffc0205e12 <do_fork+0x146>
ffffffffc0205dfc:	c7cff0ef          	jal	ffffffffc0205278 <files_create>
ffffffffc0205e00:	892a                	mv	s2,a0
ffffffffc0205e02:	20050163          	beqz	a0,ffffffffc0206004 <do_fork+0x338>
ffffffffc0205e06:	85a6                	mv	a1,s1
ffffffffc0205e08:	da8ff0ef          	jal	ffffffffc02053b0 <dup_files>
ffffffffc0205e0c:	84ca                	mv	s1,s2
ffffffffc0205e0e:	1e051863          	bnez	a0,ffffffffc0205ffe <do_fork+0x332>
ffffffffc0205e12:	489c                	lw	a5,16(s1)
ffffffffc0205e14:	2785                	addiw	a5,a5,1
ffffffffc0205e16:	c89c                	sw	a5,16(s1)
ffffffffc0205e18:	14943423          	sd	s1,328(s0)
ffffffffc0205e1c:	100027f3          	csrr	a5,sstatus
ffffffffc0205e20:	8b89                	andi	a5,a5,2
ffffffffc0205e22:	1c079a63          	bnez	a5,ffffffffc0205ff6 <do_fork+0x32a>
ffffffffc0205e26:	4901                	li	s2,0
ffffffffc0205e28:	0008b517          	auipc	a0,0x8b
ffffffffc0205e2c:	23452503          	lw	a0,564(a0) # ffffffffc029105c <last_pid.1>
ffffffffc0205e30:	6789                	lui	a5,0x2
ffffffffc0205e32:	2505                	addiw	a0,a0,1
ffffffffc0205e34:	0008b717          	auipc	a4,0x8b
ffffffffc0205e38:	22a72423          	sw	a0,552(a4) # ffffffffc029105c <last_pid.1>
ffffffffc0205e3c:	16f55163          	bge	a0,a5,ffffffffc0205f9e <do_fork+0x2d2>
ffffffffc0205e40:	0008b797          	auipc	a5,0x8b
ffffffffc0205e44:	2187a783          	lw	a5,536(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205e48:	00090497          	auipc	s1,0x90
ffffffffc0205e4c:	97848493          	addi	s1,s1,-1672 # ffffffffc02957c0 <proc_list>
ffffffffc0205e50:	06f54563          	blt	a0,a5,ffffffffc0205eba <do_fork+0x1ee>
ffffffffc0205e54:	00090497          	auipc	s1,0x90
ffffffffc0205e58:	96c48493          	addi	s1,s1,-1684 # ffffffffc02957c0 <proc_list>
ffffffffc0205e5c:	0084b883          	ld	a7,8(s1)
ffffffffc0205e60:	6789                	lui	a5,0x2
ffffffffc0205e62:	0008b717          	auipc	a4,0x8b
ffffffffc0205e66:	1ef72b23          	sw	a5,502(a4) # ffffffffc0291058 <next_safe.0>
ffffffffc0205e6a:	86aa                	mv	a3,a0
ffffffffc0205e6c:	4581                	li	a1,0
ffffffffc0205e6e:	04988063          	beq	a7,s1,ffffffffc0205eae <do_fork+0x1e2>
ffffffffc0205e72:	882e                	mv	a6,a1
ffffffffc0205e74:	87c6                	mv	a5,a7
ffffffffc0205e76:	6609                	lui	a2,0x2
ffffffffc0205e78:	a811                	j	ffffffffc0205e8c <do_fork+0x1c0>
ffffffffc0205e7a:	00e6d663          	bge	a3,a4,ffffffffc0205e86 <do_fork+0x1ba>
ffffffffc0205e7e:	00c75463          	bge	a4,a2,ffffffffc0205e86 <do_fork+0x1ba>
ffffffffc0205e82:	863a                	mv	a2,a4
ffffffffc0205e84:	4805                	li	a6,1
ffffffffc0205e86:	679c                	ld	a5,8(a5)
ffffffffc0205e88:	00978d63          	beq	a5,s1,ffffffffc0205ea2 <do_fork+0x1d6>
ffffffffc0205e8c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205e90:	fed715e3          	bne	a4,a3,ffffffffc0205e7a <do_fork+0x1ae>
ffffffffc0205e94:	2685                	addiw	a3,a3,1
ffffffffc0205e96:	10c6dd63          	bge	a3,a2,ffffffffc0205fb0 <do_fork+0x2e4>
ffffffffc0205e9a:	679c                	ld	a5,8(a5)
ffffffffc0205e9c:	4585                	li	a1,1
ffffffffc0205e9e:	fe9797e3          	bne	a5,s1,ffffffffc0205e8c <do_fork+0x1c0>
ffffffffc0205ea2:	00080663          	beqz	a6,ffffffffc0205eae <do_fork+0x1e2>
ffffffffc0205ea6:	0008b797          	auipc	a5,0x8b
ffffffffc0205eaa:	1ac7a923          	sw	a2,434(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205eae:	c591                	beqz	a1,ffffffffc0205eba <do_fork+0x1ee>
ffffffffc0205eb0:	0008b797          	auipc	a5,0x8b
ffffffffc0205eb4:	1ad7a623          	sw	a3,428(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205eb8:	8536                	mv	a0,a3
ffffffffc0205eba:	c048                	sw	a0,4(s0)
ffffffffc0205ebc:	45a9                	li	a1,10
ffffffffc0205ebe:	362050ef          	jal	ffffffffc020b220 <hash32>
ffffffffc0205ec2:	02051793          	slli	a5,a0,0x20
ffffffffc0205ec6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205eca:	0008c797          	auipc	a5,0x8c
ffffffffc0205ece:	8f678793          	addi	a5,a5,-1802 # ffffffffc02917c0 <hash_list>
ffffffffc0205ed2:	953e                	add	a0,a0,a5
ffffffffc0205ed4:	6518                	ld	a4,8(a0)
ffffffffc0205ed6:	0d840793          	addi	a5,s0,216
ffffffffc0205eda:	6490                	ld	a2,8(s1)
ffffffffc0205edc:	e31c                	sd	a5,0(a4)
ffffffffc0205ede:	e51c                	sd	a5,8(a0)
ffffffffc0205ee0:	f078                	sd	a4,224(s0)
ffffffffc0205ee2:	0c840793          	addi	a5,s0,200
ffffffffc0205ee6:	7018                	ld	a4,32(s0)
ffffffffc0205ee8:	ec68                	sd	a0,216(s0)
ffffffffc0205eea:	e21c                	sd	a5,0(a2)
ffffffffc0205eec:	0e043c23          	sd	zero,248(s0)
ffffffffc0205ef0:	7b74                	ld	a3,240(a4)
ffffffffc0205ef2:	e49c                	sd	a5,8(s1)
ffffffffc0205ef4:	e870                	sd	a2,208(s0)
ffffffffc0205ef6:	e464                	sd	s1,200(s0)
ffffffffc0205ef8:	10d43023          	sd	a3,256(s0)
ffffffffc0205efc:	c299                	beqz	a3,ffffffffc0205f02 <do_fork+0x236>
ffffffffc0205efe:	fee0                	sd	s0,248(a3)
ffffffffc0205f00:	7018                	ld	a4,32(s0)
ffffffffc0205f02:	00091797          	auipc	a5,0x91
ffffffffc0205f06:	9be7a783          	lw	a5,-1602(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0205f0a:	fb60                	sd	s0,240(a4)
ffffffffc0205f0c:	2785                	addiw	a5,a5,1
ffffffffc0205f0e:	00091717          	auipc	a4,0x91
ffffffffc0205f12:	9af72923          	sw	a5,-1614(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205f16:	08091a63          	bnez	s2,ffffffffc0205faa <do_fork+0x2de>
ffffffffc0205f1a:	8522                	mv	a0,s0
ffffffffc0205f1c:	490010ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0205f20:	4048                	lw	a0,4(s0)
ffffffffc0205f22:	6a46                	ld	s4,80(sp)
ffffffffc0205f24:	6aa6                	ld	s5,72(sp)
ffffffffc0205f26:	6b06                	ld	s6,64(sp)
ffffffffc0205f28:	7be2                	ld	s7,56(sp)
ffffffffc0205f2a:	7c42                	ld	s8,48(sp)
ffffffffc0205f2c:	7ca2                	ld	s9,40(sp)
ffffffffc0205f2e:	70e6                	ld	ra,120(sp)
ffffffffc0205f30:	7446                	ld	s0,112(sp)
ffffffffc0205f32:	74a6                	ld	s1,104(sp)
ffffffffc0205f34:	7906                	ld	s2,96(sp)
ffffffffc0205f36:	69e6                	ld	s3,88(sp)
ffffffffc0205f38:	6109                	addi	sp,sp,128
ffffffffc0205f3a:	8082                	ret
ffffffffc0205f3c:	f06a                	sd	s10,32(sp)
ffffffffc0205f3e:	d39fd0ef          	jal	ffffffffc0203c76 <mm_create>
ffffffffc0205f42:	8d2a                	mv	s10,a0
ffffffffc0205f44:	0e050563          	beqz	a0,ffffffffc020602e <do_fork+0x362>
ffffffffc0205f48:	c9bff0ef          	jal	ffffffffc0205be2 <setup_pgdir>
ffffffffc0205f4c:	c925                	beqz	a0,ffffffffc0205fbc <do_fork+0x2f0>
ffffffffc0205f4e:	856a                	mv	a0,s10
ffffffffc0205f50:	e73fd0ef          	jal	ffffffffc0203dc2 <mm_destroy>
ffffffffc0205f54:	7d02                	ld	s10,32(sp)
ffffffffc0205f56:	6814                	ld	a3,16(s0)
ffffffffc0205f58:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f5c:	0cf6eb63          	bltu	a3,a5,ffffffffc0206032 <do_fork+0x366>
ffffffffc0205f60:	000bb783          	ld	a5,0(s7)
ffffffffc0205f64:	000b3703          	ld	a4,0(s6)
ffffffffc0205f68:	40f687b3          	sub	a5,a3,a5
ffffffffc0205f6c:	83b1                	srli	a5,a5,0xc
ffffffffc0205f6e:	10e7f263          	bgeu	a5,a4,ffffffffc0206072 <do_fork+0x3a6>
ffffffffc0205f72:	000ab503          	ld	a0,0(s5)
ffffffffc0205f76:	414787b3          	sub	a5,a5,s4
ffffffffc0205f7a:	079a                	slli	a5,a5,0x6
ffffffffc0205f7c:	953e                	add	a0,a0,a5
ffffffffc0205f7e:	4589                	li	a1,2
ffffffffc0205f80:	a3efc0ef          	jal	ffffffffc02021be <free_pages>
ffffffffc0205f84:	6a46                	ld	s4,80(sp)
ffffffffc0205f86:	6aa6                	ld	s5,72(sp)
ffffffffc0205f88:	6b06                	ld	s6,64(sp)
ffffffffc0205f8a:	7be2                	ld	s7,56(sp)
ffffffffc0205f8c:	7c42                	ld	s8,48(sp)
ffffffffc0205f8e:	8522                	mv	a0,s0
ffffffffc0205f90:	8d6fc0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0205f94:	7ca2                	ld	s9,40(sp)
ffffffffc0205f96:	5571                	li	a0,-4
ffffffffc0205f98:	bf59                	j	ffffffffc0205f2e <do_fork+0x262>
ffffffffc0205f9a:	8936                	mv	s2,a3
ffffffffc0205f9c:	b581                	j	ffffffffc0205ddc <do_fork+0x110>
ffffffffc0205f9e:	4505                	li	a0,1
ffffffffc0205fa0:	0008b797          	auipc	a5,0x8b
ffffffffc0205fa4:	0aa7ae23          	sw	a0,188(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205fa8:	b575                	j	ffffffffc0205e54 <do_fork+0x188>
ffffffffc0205faa:	c29fa0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0205fae:	b7b5                	j	ffffffffc0205f1a <do_fork+0x24e>
ffffffffc0205fb0:	6789                	lui	a5,0x2
ffffffffc0205fb2:	00f6c363          	blt	a3,a5,ffffffffc0205fb8 <do_fork+0x2ec>
ffffffffc0205fb6:	4685                	li	a3,1
ffffffffc0205fb8:	4585                	li	a1,1
ffffffffc0205fba:	bd55                	j	ffffffffc0205e6e <do_fork+0x1a2>
ffffffffc0205fbc:	038c0793          	addi	a5,s8,56
ffffffffc0205fc0:	853e                	mv	a0,a5
ffffffffc0205fc2:	e43e                	sd	a5,8(sp)
ffffffffc0205fc4:	ec6e                	sd	s11,24(sp)
ffffffffc0205fc6:	e30fe0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0205fca:	000cb783          	ld	a5,0(s9)
ffffffffc0205fce:	c781                	beqz	a5,ffffffffc0205fd6 <do_fork+0x30a>
ffffffffc0205fd0:	43dc                	lw	a5,4(a5)
ffffffffc0205fd2:	04fc2823          	sw	a5,80(s8)
ffffffffc0205fd6:	85e2                	mv	a1,s8
ffffffffc0205fd8:	856a                	mv	a0,s10
ffffffffc0205fda:	f07fd0ef          	jal	ffffffffc0203ee0 <dup_mmap>
ffffffffc0205fde:	8daa                	mv	s11,a0
ffffffffc0205fe0:	6522                	ld	a0,8(sp)
ffffffffc0205fe2:	e10fe0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0205fe6:	040c2823          	sw	zero,80(s8)
ffffffffc0205fea:	8c6a                	mv	s8,s10
ffffffffc0205fec:	020d9663          	bnez	s11,ffffffffc0206018 <do_fork+0x34c>
ffffffffc0205ff0:	7d02                	ld	s10,32(sp)
ffffffffc0205ff2:	6de2                	ld	s11,24(sp)
ffffffffc0205ff4:	b359                	j	ffffffffc0205d7a <do_fork+0xae>
ffffffffc0205ff6:	be3fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0205ffa:	4905                	li	s2,1
ffffffffc0205ffc:	b535                	j	ffffffffc0205e28 <do_fork+0x15c>
ffffffffc0205ffe:	854a                	mv	a0,s2
ffffffffc0206000:	aaeff0ef          	jal	ffffffffc02052ae <files_destroy>
ffffffffc0206004:	14843503          	ld	a0,328(s0)
ffffffffc0206008:	d539                	beqz	a0,ffffffffc0205f56 <do_fork+0x28a>
ffffffffc020600a:	491c                	lw	a5,16(a0)
ffffffffc020600c:	37fd                	addiw	a5,a5,-1 # 1fff <_binary_bin_swap_img_size-0x5d01>
ffffffffc020600e:	c91c                	sw	a5,16(a0)
ffffffffc0206010:	f3b9                	bnez	a5,ffffffffc0205f56 <do_fork+0x28a>
ffffffffc0206012:	a9cff0ef          	jal	ffffffffc02052ae <files_destroy>
ffffffffc0206016:	b781                	j	ffffffffc0205f56 <do_fork+0x28a>
ffffffffc0206018:	856a                	mv	a0,s10
ffffffffc020601a:	f5ffd0ef          	jal	ffffffffc0203f78 <exit_mmap>
ffffffffc020601e:	018d3503          	ld	a0,24(s10) # fffffffffff80018 <end+0x3fce9708>
ffffffffc0206022:	b49ff0ef          	jal	ffffffffc0205b6a <put_pgdir.isra.0>
ffffffffc0206026:	6de2                	ld	s11,24(sp)
ffffffffc0206028:	b71d                	j	ffffffffc0205f4e <do_fork+0x282>
ffffffffc020602a:	556d                	li	a0,-5
ffffffffc020602c:	8082                	ret
ffffffffc020602e:	7d02                	ld	s10,32(sp)
ffffffffc0206030:	b71d                	j	ffffffffc0205f56 <do_fork+0x28a>
ffffffffc0206032:	00006617          	auipc	a2,0x6
ffffffffc0206036:	6ee60613          	addi	a2,a2,1774 # ffffffffc020c720 <etext+0xf5c>
ffffffffc020603a:	07700593          	li	a1,119
ffffffffc020603e:	00006517          	auipc	a0,0x6
ffffffffc0206042:	66250513          	addi	a0,a0,1634 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0206046:	f06a                	sd	s10,32(sp)
ffffffffc0206048:	ec6e                	sd	s11,24(sp)
ffffffffc020604a:	c00fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020604e:	00007697          	auipc	a3,0x7
ffffffffc0206052:	61268693          	addi	a3,a3,1554 # ffffffffc020d660 <etext+0x1e9c>
ffffffffc0206056:	00006617          	auipc	a2,0x6
ffffffffc020605a:	baa60613          	addi	a2,a2,-1110 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020605e:	1cc00593          	li	a1,460
ffffffffc0206062:	00007517          	auipc	a0,0x7
ffffffffc0206066:	5e650513          	addi	a0,a0,1510 # ffffffffc020d648 <etext+0x1e84>
ffffffffc020606a:	f06a                	sd	s10,32(sp)
ffffffffc020606c:	ec6e                	sd	s11,24(sp)
ffffffffc020606e:	bdcfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206072:	00006617          	auipc	a2,0x6
ffffffffc0206076:	6d660613          	addi	a2,a2,1750 # ffffffffc020c748 <etext+0xf84>
ffffffffc020607a:	06900593          	li	a1,105
ffffffffc020607e:	00006517          	auipc	a0,0x6
ffffffffc0206082:	62250513          	addi	a0,a0,1570 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0206086:	f06a                	sd	s10,32(sp)
ffffffffc0206088:	ec6e                	sd	s11,24(sp)
ffffffffc020608a:	bc0fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020608e:	86be                	mv	a3,a5
ffffffffc0206090:	00006617          	auipc	a2,0x6
ffffffffc0206094:	69060613          	addi	a2,a2,1680 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0206098:	1ac00593          	li	a1,428
ffffffffc020609c:	00007517          	auipc	a0,0x7
ffffffffc02060a0:	5ac50513          	addi	a0,a0,1452 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02060a4:	f06a                	sd	s10,32(sp)
ffffffffc02060a6:	ec6e                	sd	s11,24(sp)
ffffffffc02060a8:	ba2fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060ac:	00007697          	auipc	a3,0x7
ffffffffc02060b0:	57c68693          	addi	a3,a3,1404 # ffffffffc020d628 <etext+0x1e64>
ffffffffc02060b4:	00006617          	auipc	a2,0x6
ffffffffc02060b8:	b4c60613          	addi	a2,a2,-1204 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02060bc:	23000593          	li	a1,560
ffffffffc02060c0:	00007517          	auipc	a0,0x7
ffffffffc02060c4:	58850513          	addi	a0,a0,1416 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02060c8:	e8d2                	sd	s4,80(sp)
ffffffffc02060ca:	e4d6                	sd	s5,72(sp)
ffffffffc02060cc:	e0da                	sd	s6,64(sp)
ffffffffc02060ce:	fc5e                	sd	s7,56(sp)
ffffffffc02060d0:	f862                	sd	s8,48(sp)
ffffffffc02060d2:	f06a                	sd	s10,32(sp)
ffffffffc02060d4:	ec6e                	sd	s11,24(sp)
ffffffffc02060d6:	b74fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060da:	00006617          	auipc	a2,0x6
ffffffffc02060de:	59e60613          	addi	a2,a2,1438 # ffffffffc020c678 <etext+0xeb4>
ffffffffc02060e2:	07100593          	li	a1,113
ffffffffc02060e6:	00006517          	auipc	a0,0x6
ffffffffc02060ea:	5ba50513          	addi	a0,a0,1466 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc02060ee:	f06a                	sd	s10,32(sp)
ffffffffc02060f0:	ec6e                	sd	s11,24(sp)
ffffffffc02060f2:	b58fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02060f6 <kernel_thread>:
ffffffffc02060f6:	7129                	addi	sp,sp,-320
ffffffffc02060f8:	fa22                	sd	s0,304(sp)
ffffffffc02060fa:	f626                	sd	s1,296(sp)
ffffffffc02060fc:	f24a                	sd	s2,288(sp)
ffffffffc02060fe:	842a                	mv	s0,a0
ffffffffc0206100:	84ae                	mv	s1,a1
ffffffffc0206102:	8932                	mv	s2,a2
ffffffffc0206104:	850a                	mv	a0,sp
ffffffffc0206106:	12000613          	li	a2,288
ffffffffc020610a:	4581                	li	a1,0
ffffffffc020610c:	fe06                	sd	ra,312(sp)
ffffffffc020610e:	64e050ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206112:	e0a2                	sd	s0,64(sp)
ffffffffc0206114:	e4a6                	sd	s1,72(sp)
ffffffffc0206116:	100027f3          	csrr	a5,sstatus
ffffffffc020611a:	edd7f793          	andi	a5,a5,-291
ffffffffc020611e:	1207e793          	ori	a5,a5,288
ffffffffc0206122:	860a                	mv	a2,sp
ffffffffc0206124:	10096513          	ori	a0,s2,256
ffffffffc0206128:	00000717          	auipc	a4,0x0
ffffffffc020612c:	99270713          	addi	a4,a4,-1646 # ffffffffc0205aba <kernel_thread_entry>
ffffffffc0206130:	4581                	li	a1,0
ffffffffc0206132:	e23e                	sd	a5,256(sp)
ffffffffc0206134:	e63a                	sd	a4,264(sp)
ffffffffc0206136:	b97ff0ef          	jal	ffffffffc0205ccc <do_fork>
ffffffffc020613a:	70f2                	ld	ra,312(sp)
ffffffffc020613c:	7452                	ld	s0,304(sp)
ffffffffc020613e:	74b2                	ld	s1,296(sp)
ffffffffc0206140:	7912                	ld	s2,288(sp)
ffffffffc0206142:	6131                	addi	sp,sp,320
ffffffffc0206144:	8082                	ret

ffffffffc0206146 <do_exit>:
ffffffffc0206146:	7179                	addi	sp,sp,-48
ffffffffc0206148:	f022                	sd	s0,32(sp)
ffffffffc020614a:	00090417          	auipc	s0,0x90
ffffffffc020614e:	77e40413          	addi	s0,s0,1918 # ffffffffc02968c8 <current>
ffffffffc0206152:	601c                	ld	a5,0(s0)
ffffffffc0206154:	00090717          	auipc	a4,0x90
ffffffffc0206158:	78473703          	ld	a4,1924(a4) # ffffffffc02968d8 <idleproc>
ffffffffc020615c:	f406                	sd	ra,40(sp)
ffffffffc020615e:	ec26                	sd	s1,24(sp)
ffffffffc0206160:	0ee78763          	beq	a5,a4,ffffffffc020624e <do_exit+0x108>
ffffffffc0206164:	00090497          	auipc	s1,0x90
ffffffffc0206168:	76c48493          	addi	s1,s1,1900 # ffffffffc02968d0 <initproc>
ffffffffc020616c:	6098                	ld	a4,0(s1)
ffffffffc020616e:	e84a                	sd	s2,16(sp)
ffffffffc0206170:	10e78863          	beq	a5,a4,ffffffffc0206280 <do_exit+0x13a>
ffffffffc0206174:	7798                	ld	a4,40(a5)
ffffffffc0206176:	892a                	mv	s2,a0
ffffffffc0206178:	cb0d                	beqz	a4,ffffffffc02061aa <do_exit+0x64>
ffffffffc020617a:	00090797          	auipc	a5,0x90
ffffffffc020617e:	71e7b783          	ld	a5,1822(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0206182:	56fd                	li	a3,-1
ffffffffc0206184:	16fe                	slli	a3,a3,0x3f
ffffffffc0206186:	83b1                	srli	a5,a5,0xc
ffffffffc0206188:	8fd5                	or	a5,a5,a3
ffffffffc020618a:	18079073          	csrw	satp,a5
ffffffffc020618e:	5b1c                	lw	a5,48(a4)
ffffffffc0206190:	37fd                	addiw	a5,a5,-1
ffffffffc0206192:	db1c                	sw	a5,48(a4)
ffffffffc0206194:	cbf1                	beqz	a5,ffffffffc0206268 <do_exit+0x122>
ffffffffc0206196:	601c                	ld	a5,0(s0)
ffffffffc0206198:	1487b503          	ld	a0,328(a5)
ffffffffc020619c:	0207b423          	sd	zero,40(a5)
ffffffffc02061a0:	c509                	beqz	a0,ffffffffc02061aa <do_exit+0x64>
ffffffffc02061a2:	491c                	lw	a5,16(a0)
ffffffffc02061a4:	37fd                	addiw	a5,a5,-1
ffffffffc02061a6:	c91c                	sw	a5,16(a0)
ffffffffc02061a8:	c3c5                	beqz	a5,ffffffffc0206248 <do_exit+0x102>
ffffffffc02061aa:	601c                	ld	a5,0(s0)
ffffffffc02061ac:	470d                	li	a4,3
ffffffffc02061ae:	0f27a423          	sw	s2,232(a5)
ffffffffc02061b2:	c398                	sw	a4,0(a5)
ffffffffc02061b4:	100027f3          	csrr	a5,sstatus
ffffffffc02061b8:	8b89                	andi	a5,a5,2
ffffffffc02061ba:	4901                	li	s2,0
ffffffffc02061bc:	0c079e63          	bnez	a5,ffffffffc0206298 <do_exit+0x152>
ffffffffc02061c0:	6018                	ld	a4,0(s0)
ffffffffc02061c2:	800007b7          	lui	a5,0x80000
ffffffffc02061c6:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02061c8:	7308                	ld	a0,32(a4)
ffffffffc02061ca:	0ec52703          	lw	a4,236(a0)
ffffffffc02061ce:	0cf70963          	beq	a4,a5,ffffffffc02062a0 <do_exit+0x15a>
ffffffffc02061d2:	6018                	ld	a4,0(s0)
ffffffffc02061d4:	7b7c                	ld	a5,240(a4)
ffffffffc02061d6:	c7a1                	beqz	a5,ffffffffc020621e <do_exit+0xd8>
ffffffffc02061d8:	800005b7          	lui	a1,0x80000
ffffffffc02061dc:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02061de:	460d                	li	a2,3
ffffffffc02061e0:	a021                	j	ffffffffc02061e8 <do_exit+0xa2>
ffffffffc02061e2:	6018                	ld	a4,0(s0)
ffffffffc02061e4:	7b7c                	ld	a5,240(a4)
ffffffffc02061e6:	cf85                	beqz	a5,ffffffffc020621e <do_exit+0xd8>
ffffffffc02061e8:	1007b683          	ld	a3,256(a5)
ffffffffc02061ec:	6088                	ld	a0,0(s1)
ffffffffc02061ee:	fb74                	sd	a3,240(a4)
ffffffffc02061f0:	0e07bc23          	sd	zero,248(a5)
ffffffffc02061f4:	7978                	ld	a4,240(a0)
ffffffffc02061f6:	10e7b023          	sd	a4,256(a5)
ffffffffc02061fa:	c311                	beqz	a4,ffffffffc02061fe <do_exit+0xb8>
ffffffffc02061fc:	ff7c                	sd	a5,248(a4)
ffffffffc02061fe:	4398                	lw	a4,0(a5)
ffffffffc0206200:	f388                	sd	a0,32(a5)
ffffffffc0206202:	f97c                	sd	a5,240(a0)
ffffffffc0206204:	fcc71fe3          	bne	a4,a2,ffffffffc02061e2 <do_exit+0x9c>
ffffffffc0206208:	0ec52783          	lw	a5,236(a0)
ffffffffc020620c:	fcb79be3          	bne	a5,a1,ffffffffc02061e2 <do_exit+0x9c>
ffffffffc0206210:	19c010ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0206214:	800005b7          	lui	a1,0x80000
ffffffffc0206218:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc020621a:	460d                	li	a2,3
ffffffffc020621c:	b7d9                	j	ffffffffc02061e2 <do_exit+0x9c>
ffffffffc020621e:	02091263          	bnez	s2,ffffffffc0206242 <do_exit+0xfc>
ffffffffc0206222:	282010ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc0206226:	601c                	ld	a5,0(s0)
ffffffffc0206228:	00007617          	auipc	a2,0x7
ffffffffc020622c:	47060613          	addi	a2,a2,1136 # ffffffffc020d698 <etext+0x1ed4>
ffffffffc0206230:	29e00593          	li	a1,670
ffffffffc0206234:	43d4                	lw	a3,4(a5)
ffffffffc0206236:	00007517          	auipc	a0,0x7
ffffffffc020623a:	41250513          	addi	a0,a0,1042 # ffffffffc020d648 <etext+0x1e84>
ffffffffc020623e:	a0cfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206242:	991fa0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0206246:	bff1                	j	ffffffffc0206222 <do_exit+0xdc>
ffffffffc0206248:	866ff0ef          	jal	ffffffffc02052ae <files_destroy>
ffffffffc020624c:	bfb9                	j	ffffffffc02061aa <do_exit+0x64>
ffffffffc020624e:	00007617          	auipc	a2,0x7
ffffffffc0206252:	42a60613          	addi	a2,a2,1066 # ffffffffc020d678 <etext+0x1eb4>
ffffffffc0206256:	26900593          	li	a1,617
ffffffffc020625a:	00007517          	auipc	a0,0x7
ffffffffc020625e:	3ee50513          	addi	a0,a0,1006 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206262:	e84a                	sd	s2,16(sp)
ffffffffc0206264:	9e6fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206268:	853a                	mv	a0,a4
ffffffffc020626a:	e43a                	sd	a4,8(sp)
ffffffffc020626c:	d0dfd0ef          	jal	ffffffffc0203f78 <exit_mmap>
ffffffffc0206270:	6722                	ld	a4,8(sp)
ffffffffc0206272:	6f08                	ld	a0,24(a4)
ffffffffc0206274:	8f7ff0ef          	jal	ffffffffc0205b6a <put_pgdir.isra.0>
ffffffffc0206278:	6522                	ld	a0,8(sp)
ffffffffc020627a:	b49fd0ef          	jal	ffffffffc0203dc2 <mm_destroy>
ffffffffc020627e:	bf21                	j	ffffffffc0206196 <do_exit+0x50>
ffffffffc0206280:	00007617          	auipc	a2,0x7
ffffffffc0206284:	40860613          	addi	a2,a2,1032 # ffffffffc020d688 <etext+0x1ec4>
ffffffffc0206288:	26d00593          	li	a1,621
ffffffffc020628c:	00007517          	auipc	a0,0x7
ffffffffc0206290:	3bc50513          	addi	a0,a0,956 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206294:	9b6fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206298:	941fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020629c:	4905                	li	s2,1
ffffffffc020629e:	b70d                	j	ffffffffc02061c0 <do_exit+0x7a>
ffffffffc02062a0:	10c010ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc02062a4:	b73d                	j	ffffffffc02061d2 <do_exit+0x8c>

ffffffffc02062a6 <do_wait.part.0>:
ffffffffc02062a6:	7179                	addi	sp,sp,-48
ffffffffc02062a8:	ec26                	sd	s1,24(sp)
ffffffffc02062aa:	e84a                	sd	s2,16(sp)
ffffffffc02062ac:	e44e                	sd	s3,8(sp)
ffffffffc02062ae:	f406                	sd	ra,40(sp)
ffffffffc02062b0:	f022                	sd	s0,32(sp)
ffffffffc02062b2:	84aa                	mv	s1,a0
ffffffffc02062b4:	892e                	mv	s2,a1
ffffffffc02062b6:	00090997          	auipc	s3,0x90
ffffffffc02062ba:	61298993          	addi	s3,s3,1554 # ffffffffc02968c8 <current>
ffffffffc02062be:	cd19                	beqz	a0,ffffffffc02062dc <do_wait.part.0+0x36>
ffffffffc02062c0:	6789                	lui	a5,0x2
ffffffffc02062c2:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc02062c4:	fff5071b          	addiw	a4,a0,-1
ffffffffc02062c8:	12e7f563          	bgeu	a5,a4,ffffffffc02063f2 <do_wait.part.0+0x14c>
ffffffffc02062cc:	70a2                	ld	ra,40(sp)
ffffffffc02062ce:	7402                	ld	s0,32(sp)
ffffffffc02062d0:	64e2                	ld	s1,24(sp)
ffffffffc02062d2:	6942                	ld	s2,16(sp)
ffffffffc02062d4:	69a2                	ld	s3,8(sp)
ffffffffc02062d6:	5579                	li	a0,-2
ffffffffc02062d8:	6145                	addi	sp,sp,48
ffffffffc02062da:	8082                	ret
ffffffffc02062dc:	0009b703          	ld	a4,0(s3)
ffffffffc02062e0:	7b60                	ld	s0,240(a4)
ffffffffc02062e2:	d46d                	beqz	s0,ffffffffc02062cc <do_wait.part.0+0x26>
ffffffffc02062e4:	468d                	li	a3,3
ffffffffc02062e6:	a021                	j	ffffffffc02062ee <do_wait.part.0+0x48>
ffffffffc02062e8:	10043403          	ld	s0,256(s0)
ffffffffc02062ec:	c075                	beqz	s0,ffffffffc02063d0 <do_wait.part.0+0x12a>
ffffffffc02062ee:	401c                	lw	a5,0(s0)
ffffffffc02062f0:	fed79ce3          	bne	a5,a3,ffffffffc02062e8 <do_wait.part.0+0x42>
ffffffffc02062f4:	00090797          	auipc	a5,0x90
ffffffffc02062f8:	5e47b783          	ld	a5,1508(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02062fc:	14878263          	beq	a5,s0,ffffffffc0206440 <do_wait.part.0+0x19a>
ffffffffc0206300:	00090797          	auipc	a5,0x90
ffffffffc0206304:	5d07b783          	ld	a5,1488(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206308:	12f40c63          	beq	s0,a5,ffffffffc0206440 <do_wait.part.0+0x19a>
ffffffffc020630c:	00090663          	beqz	s2,ffffffffc0206318 <do_wait.part.0+0x72>
ffffffffc0206310:	0e842783          	lw	a5,232(s0)
ffffffffc0206314:	00f92023          	sw	a5,0(s2)
ffffffffc0206318:	100027f3          	csrr	a5,sstatus
ffffffffc020631c:	8b89                	andi	a5,a5,2
ffffffffc020631e:	4601                	li	a2,0
ffffffffc0206320:	10079963          	bnez	a5,ffffffffc0206432 <do_wait.part.0+0x18c>
ffffffffc0206324:	6c74                	ld	a3,216(s0)
ffffffffc0206326:	7078                	ld	a4,224(s0)
ffffffffc0206328:	10043783          	ld	a5,256(s0)
ffffffffc020632c:	e698                	sd	a4,8(a3)
ffffffffc020632e:	e314                	sd	a3,0(a4)
ffffffffc0206330:	6474                	ld	a3,200(s0)
ffffffffc0206332:	6878                	ld	a4,208(s0)
ffffffffc0206334:	e698                	sd	a4,8(a3)
ffffffffc0206336:	e314                	sd	a3,0(a4)
ffffffffc0206338:	c789                	beqz	a5,ffffffffc0206342 <do_wait.part.0+0x9c>
ffffffffc020633a:	7c78                	ld	a4,248(s0)
ffffffffc020633c:	fff8                	sd	a4,248(a5)
ffffffffc020633e:	10043783          	ld	a5,256(s0)
ffffffffc0206342:	7c78                	ld	a4,248(s0)
ffffffffc0206344:	c36d                	beqz	a4,ffffffffc0206426 <do_wait.part.0+0x180>
ffffffffc0206346:	10f73023          	sd	a5,256(a4)
ffffffffc020634a:	00090797          	auipc	a5,0x90
ffffffffc020634e:	5767a783          	lw	a5,1398(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0206352:	37fd                	addiw	a5,a5,-1
ffffffffc0206354:	00090717          	auipc	a4,0x90
ffffffffc0206358:	56f72623          	sw	a5,1388(a4) # ffffffffc02968c0 <nr_process>
ffffffffc020635c:	e271                	bnez	a2,ffffffffc0206420 <do_wait.part.0+0x17a>
ffffffffc020635e:	6814                	ld	a3,16(s0)
ffffffffc0206360:	c02007b7          	lui	a5,0xc0200
ffffffffc0206364:	10f6e663          	bltu	a3,a5,ffffffffc0206470 <do_wait.part.0+0x1ca>
ffffffffc0206368:	00090717          	auipc	a4,0x90
ffffffffc020636c:	54073703          	ld	a4,1344(a4) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206370:	00090797          	auipc	a5,0x90
ffffffffc0206374:	5407b783          	ld	a5,1344(a5) # ffffffffc02968b0 <npage>
ffffffffc0206378:	8e99                	sub	a3,a3,a4
ffffffffc020637a:	82b1                	srli	a3,a3,0xc
ffffffffc020637c:	0cf6fe63          	bgeu	a3,a5,ffffffffc0206458 <do_wait.part.0+0x1b2>
ffffffffc0206380:	00009797          	auipc	a5,0x9
ffffffffc0206384:	7407b783          	ld	a5,1856(a5) # ffffffffc020fac0 <nbase>
ffffffffc0206388:	00090517          	auipc	a0,0x90
ffffffffc020638c:	53053503          	ld	a0,1328(a0) # ffffffffc02968b8 <pages>
ffffffffc0206390:	4589                	li	a1,2
ffffffffc0206392:	8e9d                	sub	a3,a3,a5
ffffffffc0206394:	069a                	slli	a3,a3,0x6
ffffffffc0206396:	9536                	add	a0,a0,a3
ffffffffc0206398:	e27fb0ef          	jal	ffffffffc02021be <free_pages>
ffffffffc020639c:	8522                	mv	a0,s0
ffffffffc020639e:	cc9fb0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02063a2:	70a2                	ld	ra,40(sp)
ffffffffc02063a4:	7402                	ld	s0,32(sp)
ffffffffc02063a6:	64e2                	ld	s1,24(sp)
ffffffffc02063a8:	6942                	ld	s2,16(sp)
ffffffffc02063aa:	69a2                	ld	s3,8(sp)
ffffffffc02063ac:	4501                	li	a0,0
ffffffffc02063ae:	6145                	addi	sp,sp,48
ffffffffc02063b0:	8082                	ret
ffffffffc02063b2:	00090997          	auipc	s3,0x90
ffffffffc02063b6:	51698993          	addi	s3,s3,1302 # ffffffffc02968c8 <current>
ffffffffc02063ba:	0009b703          	ld	a4,0(s3)
ffffffffc02063be:	f487b683          	ld	a3,-184(a5)
ffffffffc02063c2:	f0e695e3          	bne	a3,a4,ffffffffc02062cc <do_wait.part.0+0x26>
ffffffffc02063c6:	f287a603          	lw	a2,-216(a5)
ffffffffc02063ca:	468d                	li	a3,3
ffffffffc02063cc:	06d60063          	beq	a2,a3,ffffffffc020642c <do_wait.part.0+0x186>
ffffffffc02063d0:	800007b7          	lui	a5,0x80000
ffffffffc02063d4:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02063d6:	4685                	li	a3,1
ffffffffc02063d8:	0ef72623          	sw	a5,236(a4)
ffffffffc02063dc:	c314                	sw	a3,0(a4)
ffffffffc02063de:	0c6010ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc02063e2:	0009b783          	ld	a5,0(s3)
ffffffffc02063e6:	0b07a783          	lw	a5,176(a5)
ffffffffc02063ea:	8b85                	andi	a5,a5,1
ffffffffc02063ec:	e7b9                	bnez	a5,ffffffffc020643a <do_wait.part.0+0x194>
ffffffffc02063ee:	ee0487e3          	beqz	s1,ffffffffc02062dc <do_wait.part.0+0x36>
ffffffffc02063f2:	45a9                	li	a1,10
ffffffffc02063f4:	8526                	mv	a0,s1
ffffffffc02063f6:	62b040ef          	jal	ffffffffc020b220 <hash32>
ffffffffc02063fa:	02051793          	slli	a5,a0,0x20
ffffffffc02063fe:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206402:	0008b797          	auipc	a5,0x8b
ffffffffc0206406:	3be78793          	addi	a5,a5,958 # ffffffffc02917c0 <hash_list>
ffffffffc020640a:	953e                	add	a0,a0,a5
ffffffffc020640c:	87aa                	mv	a5,a0
ffffffffc020640e:	a029                	j	ffffffffc0206418 <do_wait.part.0+0x172>
ffffffffc0206410:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206414:	f8970fe3          	beq	a4,s1,ffffffffc02063b2 <do_wait.part.0+0x10c>
ffffffffc0206418:	679c                	ld	a5,8(a5)
ffffffffc020641a:	fef51be3          	bne	a0,a5,ffffffffc0206410 <do_wait.part.0+0x16a>
ffffffffc020641e:	b57d                	j	ffffffffc02062cc <do_wait.part.0+0x26>
ffffffffc0206420:	fb2fa0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0206424:	bf2d                	j	ffffffffc020635e <do_wait.part.0+0xb8>
ffffffffc0206426:	7018                	ld	a4,32(s0)
ffffffffc0206428:	fb7c                	sd	a5,240(a4)
ffffffffc020642a:	b705                	j	ffffffffc020634a <do_wait.part.0+0xa4>
ffffffffc020642c:	f2878413          	addi	s0,a5,-216
ffffffffc0206430:	b5d1                	j	ffffffffc02062f4 <do_wait.part.0+0x4e>
ffffffffc0206432:	fa6fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0206436:	4605                	li	a2,1
ffffffffc0206438:	b5f5                	j	ffffffffc0206324 <do_wait.part.0+0x7e>
ffffffffc020643a:	555d                	li	a0,-9
ffffffffc020643c:	d0bff0ef          	jal	ffffffffc0206146 <do_exit>
ffffffffc0206440:	00007617          	auipc	a2,0x7
ffffffffc0206444:	27860613          	addi	a2,a2,632 # ffffffffc020d6b8 <etext+0x1ef4>
ffffffffc0206448:	43100593          	li	a1,1073
ffffffffc020644c:	00007517          	auipc	a0,0x7
ffffffffc0206450:	1fc50513          	addi	a0,a0,508 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206454:	ff7f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206458:	00006617          	auipc	a2,0x6
ffffffffc020645c:	2f060613          	addi	a2,a2,752 # ffffffffc020c748 <etext+0xf84>
ffffffffc0206460:	06900593          	li	a1,105
ffffffffc0206464:	00006517          	auipc	a0,0x6
ffffffffc0206468:	23c50513          	addi	a0,a0,572 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc020646c:	fdff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206470:	00006617          	auipc	a2,0x6
ffffffffc0206474:	2b060613          	addi	a2,a2,688 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0206478:	07700593          	li	a1,119
ffffffffc020647c:	00006517          	auipc	a0,0x6
ffffffffc0206480:	22450513          	addi	a0,a0,548 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0206484:	fc7f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206488 <init_main>:
ffffffffc0206488:	1141                	addi	sp,sp,-16
ffffffffc020648a:	00007517          	auipc	a0,0x7
ffffffffc020648e:	24e50513          	addi	a0,a0,590 # ffffffffc020d6d8 <etext+0x1f14>
ffffffffc0206492:	e406                	sd	ra,8(sp)
ffffffffc0206494:	79c010ef          	jal	ffffffffc0207c30 <vfs_set_bootfs>
ffffffffc0206498:	e179                	bnez	a0,ffffffffc020655e <init_main+0xd6>
ffffffffc020649a:	d5dfb0ef          	jal	ffffffffc02021f6 <nr_free_pages>
ffffffffc020649e:	b1ffb0ef          	jal	ffffffffc0201fbc <kallocated>
ffffffffc02064a2:	4601                	li	a2,0
ffffffffc02064a4:	4581                	li	a1,0
ffffffffc02064a6:	00001517          	auipc	a0,0x1
ffffffffc02064aa:	96a50513          	addi	a0,a0,-1686 # ffffffffc0206e10 <user_main>
ffffffffc02064ae:	c49ff0ef          	jal	ffffffffc02060f6 <kernel_thread>
ffffffffc02064b2:	00a04563          	bgtz	a0,ffffffffc02064bc <init_main+0x34>
ffffffffc02064b6:	a841                	j	ffffffffc0206546 <init_main+0xbe>
ffffffffc02064b8:	7ed000ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc02064bc:	4581                	li	a1,0
ffffffffc02064be:	4501                	li	a0,0
ffffffffc02064c0:	de7ff0ef          	jal	ffffffffc02062a6 <do_wait.part.0>
ffffffffc02064c4:	d975                	beqz	a0,ffffffffc02064b8 <init_main+0x30>
ffffffffc02064c6:	da3fe0ef          	jal	ffffffffc0205268 <fs_cleanup>
ffffffffc02064ca:	00007517          	auipc	a0,0x7
ffffffffc02064ce:	25650513          	addi	a0,a0,598 # ffffffffc020d720 <etext+0x1f5c>
ffffffffc02064d2:	cd5f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02064d6:	00090797          	auipc	a5,0x90
ffffffffc02064da:	3fa7b783          	ld	a5,1018(a5) # ffffffffc02968d0 <initproc>
ffffffffc02064de:	7bf8                	ld	a4,240(a5)
ffffffffc02064e0:	e339                	bnez	a4,ffffffffc0206526 <init_main+0x9e>
ffffffffc02064e2:	7ff8                	ld	a4,248(a5)
ffffffffc02064e4:	e329                	bnez	a4,ffffffffc0206526 <init_main+0x9e>
ffffffffc02064e6:	1007b703          	ld	a4,256(a5)
ffffffffc02064ea:	ef15                	bnez	a4,ffffffffc0206526 <init_main+0x9e>
ffffffffc02064ec:	00090697          	auipc	a3,0x90
ffffffffc02064f0:	3d46a683          	lw	a3,980(a3) # ffffffffc02968c0 <nr_process>
ffffffffc02064f4:	4709                	li	a4,2
ffffffffc02064f6:	0ce69163          	bne	a3,a4,ffffffffc02065b8 <init_main+0x130>
ffffffffc02064fa:	0008f717          	auipc	a4,0x8f
ffffffffc02064fe:	2c670713          	addi	a4,a4,710 # ffffffffc02957c0 <proc_list>
ffffffffc0206502:	6714                	ld	a3,8(a4)
ffffffffc0206504:	0c878793          	addi	a5,a5,200
ffffffffc0206508:	08d79863          	bne	a5,a3,ffffffffc0206598 <init_main+0x110>
ffffffffc020650c:	6318                	ld	a4,0(a4)
ffffffffc020650e:	06e79563          	bne	a5,a4,ffffffffc0206578 <init_main+0xf0>
ffffffffc0206512:	00007517          	auipc	a0,0x7
ffffffffc0206516:	2f650513          	addi	a0,a0,758 # ffffffffc020d808 <etext+0x2044>
ffffffffc020651a:	c8df90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020651e:	60a2                	ld	ra,8(sp)
ffffffffc0206520:	4501                	li	a0,0
ffffffffc0206522:	0141                	addi	sp,sp,16
ffffffffc0206524:	8082                	ret
ffffffffc0206526:	00007697          	auipc	a3,0x7
ffffffffc020652a:	22268693          	addi	a3,a3,546 # ffffffffc020d748 <etext+0x1f84>
ffffffffc020652e:	00005617          	auipc	a2,0x5
ffffffffc0206532:	6d260613          	addi	a2,a2,1746 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206536:	4a700593          	li	a1,1191
ffffffffc020653a:	00007517          	auipc	a0,0x7
ffffffffc020653e:	10e50513          	addi	a0,a0,270 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206542:	f09f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206546:	00007617          	auipc	a2,0x7
ffffffffc020654a:	1ba60613          	addi	a2,a2,442 # ffffffffc020d700 <etext+0x1f3c>
ffffffffc020654e:	49a00593          	li	a1,1178
ffffffffc0206552:	00007517          	auipc	a0,0x7
ffffffffc0206556:	0f650513          	addi	a0,a0,246 # ffffffffc020d648 <etext+0x1e84>
ffffffffc020655a:	ef1f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020655e:	86aa                	mv	a3,a0
ffffffffc0206560:	00007617          	auipc	a2,0x7
ffffffffc0206564:	18060613          	addi	a2,a2,384 # ffffffffc020d6e0 <etext+0x1f1c>
ffffffffc0206568:	49200593          	li	a1,1170
ffffffffc020656c:	00007517          	auipc	a0,0x7
ffffffffc0206570:	0dc50513          	addi	a0,a0,220 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206574:	ed7f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206578:	00007697          	auipc	a3,0x7
ffffffffc020657c:	26068693          	addi	a3,a3,608 # ffffffffc020d7d8 <etext+0x2014>
ffffffffc0206580:	00005617          	auipc	a2,0x5
ffffffffc0206584:	68060613          	addi	a2,a2,1664 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206588:	4aa00593          	li	a1,1194
ffffffffc020658c:	00007517          	auipc	a0,0x7
ffffffffc0206590:	0bc50513          	addi	a0,a0,188 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206594:	eb7f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206598:	00007697          	auipc	a3,0x7
ffffffffc020659c:	21068693          	addi	a3,a3,528 # ffffffffc020d7a8 <etext+0x1fe4>
ffffffffc02065a0:	00005617          	auipc	a2,0x5
ffffffffc02065a4:	66060613          	addi	a2,a2,1632 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02065a8:	4a900593          	li	a1,1193
ffffffffc02065ac:	00007517          	auipc	a0,0x7
ffffffffc02065b0:	09c50513          	addi	a0,a0,156 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02065b4:	e97f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02065b8:	00007697          	auipc	a3,0x7
ffffffffc02065bc:	1e068693          	addi	a3,a3,480 # ffffffffc020d798 <etext+0x1fd4>
ffffffffc02065c0:	00005617          	auipc	a2,0x5
ffffffffc02065c4:	64060613          	addi	a2,a2,1600 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02065c8:	4a800593          	li	a1,1192
ffffffffc02065cc:	00007517          	auipc	a0,0x7
ffffffffc02065d0:	07c50513          	addi	a0,a0,124 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02065d4:	e77f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02065d8 <do_execve>:
ffffffffc02065d8:	db010113          	addi	sp,sp,-592
ffffffffc02065dc:	21613823          	sd	s6,528(sp)
ffffffffc02065e0:	24113423          	sd	ra,584(sp)
ffffffffc02065e4:	f7ee                	sd	s11,488(sp)
ffffffffc02065e6:	fff58b1b          	addiw	s6,a1,-1
ffffffffc02065ea:	47fd                	li	a5,31
ffffffffc02065ec:	5f67e363          	bltu	a5,s6,ffffffffc0206bd2 <do_execve+0x5fa>
ffffffffc02065f0:	23213823          	sd	s2,560(sp)
ffffffffc02065f4:	00090917          	auipc	s2,0x90
ffffffffc02065f8:	2d490913          	addi	s2,s2,724 # ffffffffc02968c8 <current>
ffffffffc02065fc:	00093783          	ld	a5,0(s2)
ffffffffc0206600:	21713423          	sd	s7,520(sp)
ffffffffc0206604:	24813023          	sd	s0,576(sp)
ffffffffc0206608:	0287bb83          	ld	s7,40(a5)
ffffffffc020660c:	22913c23          	sd	s1,568(sp)
ffffffffc0206610:	ffe6                	sd	s9,504(sp)
ffffffffc0206612:	84aa                	mv	s1,a0
ffffffffc0206614:	8cb2                	mv	s9,a2
ffffffffc0206616:	842e                	mv	s0,a1
ffffffffc0206618:	08a8                	addi	a0,sp,88
ffffffffc020661a:	4641                	li	a2,16
ffffffffc020661c:	4581                	li	a1,0
ffffffffc020661e:	13e050ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206622:	000b8c63          	beqz	s7,ffffffffc020663a <do_execve+0x62>
ffffffffc0206626:	038b8513          	addi	a0,s7,56
ffffffffc020662a:	fcdfd0ef          	jal	ffffffffc02045f6 <down>
ffffffffc020662e:	00093783          	ld	a5,0(s2)
ffffffffc0206632:	c781                	beqz	a5,ffffffffc020663a <do_execve+0x62>
ffffffffc0206634:	43dc                	lw	a5,4(a5)
ffffffffc0206636:	04fba823          	sw	a5,80(s7)
ffffffffc020663a:	1c048963          	beqz	s1,ffffffffc020680c <do_execve+0x234>
ffffffffc020663e:	8626                	mv	a2,s1
ffffffffc0206640:	46c1                	li	a3,16
ffffffffc0206642:	08ac                	addi	a1,sp,88
ffffffffc0206644:	855e                	mv	a0,s7
ffffffffc0206646:	de3fd0ef          	jal	ffffffffc0204428 <copy_string>
ffffffffc020664a:	56050363          	beqz	a0,ffffffffc0206bb0 <do_execve+0x5d8>
ffffffffc020664e:	23413023          	sd	s4,544(sp)
ffffffffc0206652:	fbea                	sd	s10,496(sp)
ffffffffc0206654:	00341d13          	slli	s10,s0,0x3
ffffffffc0206658:	866a                	mv	a2,s10
ffffffffc020665a:	4681                	li	a3,0
ffffffffc020665c:	85e6                	mv	a1,s9
ffffffffc020665e:	855e                	mv	a0,s7
ffffffffc0206660:	8a66                	mv	s4,s9
ffffffffc0206662:	cb5fd0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc0206666:	6a050363          	beqz	a0,ffffffffc0206d0c <do_execve+0x734>
ffffffffc020666a:	23313423          	sd	s3,552(sp)
ffffffffc020666e:	21813023          	sd	s8,512(sp)
ffffffffc0206672:	4981                	li	s3,0
ffffffffc0206674:	0e010c13          	addi	s8,sp,224
ffffffffc0206678:	6505                	lui	a0,0x1
ffffffffc020667a:	947fb0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020667e:	84aa                	mv	s1,a0
ffffffffc0206680:	10050963          	beqz	a0,ffffffffc0206792 <do_execve+0x1ba>
ffffffffc0206684:	000a3603          	ld	a2,0(s4)
ffffffffc0206688:	85aa                	mv	a1,a0
ffffffffc020668a:	6685                	lui	a3,0x1
ffffffffc020668c:	855e                	mv	a0,s7
ffffffffc020668e:	d9bfd0ef          	jal	ffffffffc0204428 <copy_string>
ffffffffc0206692:	16050863          	beqz	a0,ffffffffc0206802 <do_execve+0x22a>
ffffffffc0206696:	009c3023          	sd	s1,0(s8)
ffffffffc020669a:	2985                	addiw	s3,s3,1
ffffffffc020669c:	0c21                	addi	s8,s8,8
ffffffffc020669e:	0a21                	addi	s4,s4,8
ffffffffc02066a0:	fd341ce3          	bne	s0,s3,ffffffffc0206678 <do_execve+0xa0>
ffffffffc02066a4:	21513c23          	sd	s5,536(sp)
ffffffffc02066a8:	000cb483          	ld	s1,0(s9)
ffffffffc02066ac:	0a0b8663          	beqz	s7,ffffffffc0206758 <do_execve+0x180>
ffffffffc02066b0:	038b8513          	addi	a0,s7,56
ffffffffc02066b4:	f3ffd0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02066b8:	00093783          	ld	a5,0(s2)
ffffffffc02066bc:	040ba823          	sw	zero,80(s7)
ffffffffc02066c0:	1487b503          	ld	a0,328(a5)
ffffffffc02066c4:	c81fe0ef          	jal	ffffffffc0205344 <files_closeall>
ffffffffc02066c8:	8526                	mv	a0,s1
ffffffffc02066ca:	4581                	li	a1,0
ffffffffc02066cc:	f09fe0ef          	jal	ffffffffc02055d4 <sysfile_open>
ffffffffc02066d0:	8a2a                	mv	s4,a0
ffffffffc02066d2:	6a054d63          	bltz	a0,ffffffffc0206d8c <do_execve+0x7b4>
ffffffffc02066d6:	00090797          	auipc	a5,0x90
ffffffffc02066da:	1c27b783          	ld	a5,450(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc02066de:	577d                	li	a4,-1
ffffffffc02066e0:	177e                	slli	a4,a4,0x3f
ffffffffc02066e2:	83b1                	srli	a5,a5,0xc
ffffffffc02066e4:	8fd9                	or	a5,a5,a4
ffffffffc02066e6:	18079073          	csrw	satp,a5
ffffffffc02066ea:	030ba783          	lw	a5,48(s7)
ffffffffc02066ee:	37fd                	addiw	a5,a5,-1
ffffffffc02066f0:	02fba823          	sw	a5,48(s7)
ffffffffc02066f4:	14078e63          	beqz	a5,ffffffffc0206850 <do_execve+0x278>
ffffffffc02066f8:	00093783          	ld	a5,0(s2)
ffffffffc02066fc:	0207b423          	sd	zero,40(a5)
ffffffffc0206700:	d76fd0ef          	jal	ffffffffc0203c76 <mm_create>
ffffffffc0206704:	89aa                	mv	s3,a0
ffffffffc0206706:	5df1                	li	s11,-4
ffffffffc0206708:	c505                	beqz	a0,ffffffffc0206730 <do_execve+0x158>
ffffffffc020670a:	cd8ff0ef          	jal	ffffffffc0205be2 <setup_pgdir>
ffffffffc020670e:	5df1                	li	s11,-4
ffffffffc0206710:	ed09                	bnez	a0,ffffffffc020672a <do_execve+0x152>
ffffffffc0206712:	4601                	li	a2,0
ffffffffc0206714:	4581                	li	a1,0
ffffffffc0206716:	8552                	mv	a0,s4
ffffffffc0206718:	974ff0ef          	jal	ffffffffc020588c <sysfile_seek>
ffffffffc020671c:	8daa                	mv	s11,a0
ffffffffc020671e:	10050863          	beqz	a0,ffffffffc020682e <do_execve+0x256>
ffffffffc0206722:	0189b503          	ld	a0,24(s3)
ffffffffc0206726:	c44ff0ef          	jal	ffffffffc0205b6a <put_pgdir.isra.0>
ffffffffc020672a:	854e                	mv	a0,s3
ffffffffc020672c:	e96fd0ef          	jal	ffffffffc0203dc2 <mm_destroy>
ffffffffc0206730:	0d010913          	addi	s2,sp,208
ffffffffc0206734:	020b1713          	slli	a4,s6,0x20
ffffffffc0206738:	01d75793          	srli	a5,a4,0x1d
ffffffffc020673c:	996a                	add	s2,s2,s10
ffffffffc020673e:	09a0                	addi	s0,sp,216
ffffffffc0206740:	40f90933          	sub	s2,s2,a5
ffffffffc0206744:	946a                	add	s0,s0,s10
ffffffffc0206746:	6008                	ld	a0,0(s0)
ffffffffc0206748:	1461                	addi	s0,s0,-8
ffffffffc020674a:	91dfb0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020674e:	ff241ce3          	bne	s0,s2,ffffffffc0206746 <do_execve+0x16e>
ffffffffc0206752:	856e                	mv	a0,s11
ffffffffc0206754:	9f3ff0ef          	jal	ffffffffc0206146 <do_exit>
ffffffffc0206758:	00093783          	ld	a5,0(s2)
ffffffffc020675c:	1487b503          	ld	a0,328(a5)
ffffffffc0206760:	be5fe0ef          	jal	ffffffffc0205344 <files_closeall>
ffffffffc0206764:	8526                	mv	a0,s1
ffffffffc0206766:	4581                	li	a1,0
ffffffffc0206768:	e6dfe0ef          	jal	ffffffffc02055d4 <sysfile_open>
ffffffffc020676c:	8a2a                	mv	s4,a0
ffffffffc020676e:	0a054e63          	bltz	a0,ffffffffc020682a <do_execve+0x252>
ffffffffc0206772:	00093783          	ld	a5,0(s2)
ffffffffc0206776:	779c                	ld	a5,40(a5)
ffffffffc0206778:	d7c1                	beqz	a5,ffffffffc0206700 <do_execve+0x128>
ffffffffc020677a:	00007617          	auipc	a2,0x7
ffffffffc020677e:	0be60613          	addi	a2,a2,190 # ffffffffc020d838 <etext+0x2074>
ffffffffc0206782:	2d300593          	li	a1,723
ffffffffc0206786:	00007517          	auipc	a0,0x7
ffffffffc020678a:	ec250513          	addi	a0,a0,-318 # ffffffffc020d648 <etext+0x1e84>
ffffffffc020678e:	cbdf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206792:	5df1                	li	s11,-4
ffffffffc0206794:	02098663          	beqz	s3,ffffffffc02067c0 <do_execve+0x1e8>
ffffffffc0206798:	00399793          	slli	a5,s3,0x3
ffffffffc020679c:	39fd                	addiw	s3,s3,-1
ffffffffc020679e:	0d010913          	addi	s2,sp,208
ffffffffc02067a2:	02099713          	slli	a4,s3,0x20
ffffffffc02067a6:	01d75993          	srli	s3,a4,0x1d
ffffffffc02067aa:	993e                	add	s2,s2,a5
ffffffffc02067ac:	09a0                	addi	s0,sp,216
ffffffffc02067ae:	41390933          	sub	s2,s2,s3
ffffffffc02067b2:	943e                	add	s0,s0,a5
ffffffffc02067b4:	6008                	ld	a0,0(s0)
ffffffffc02067b6:	1461                	addi	s0,s0,-8
ffffffffc02067b8:	8affb0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02067bc:	ff241ce3          	bne	s0,s2,ffffffffc02067b4 <do_execve+0x1dc>
ffffffffc02067c0:	22813983          	ld	s3,552(sp)
ffffffffc02067c4:	20013c03          	ld	s8,512(sp)
ffffffffc02067c8:	000b8863          	beqz	s7,ffffffffc02067d8 <do_execve+0x200>
ffffffffc02067cc:	038b8513          	addi	a0,s7,56
ffffffffc02067d0:	e23fd0ef          	jal	ffffffffc02045f2 <up>
ffffffffc02067d4:	040ba823          	sw	zero,80(s7)
ffffffffc02067d8:	24013403          	ld	s0,576(sp)
ffffffffc02067dc:	23813483          	ld	s1,568(sp)
ffffffffc02067e0:	23013903          	ld	s2,560(sp)
ffffffffc02067e4:	22013a03          	ld	s4,544(sp)
ffffffffc02067e8:	20813b83          	ld	s7,520(sp)
ffffffffc02067ec:	7cfe                	ld	s9,504(sp)
ffffffffc02067ee:	7d5e                	ld	s10,496(sp)
ffffffffc02067f0:	24813083          	ld	ra,584(sp)
ffffffffc02067f4:	21013b03          	ld	s6,528(sp)
ffffffffc02067f8:	856e                	mv	a0,s11
ffffffffc02067fa:	7dbe                	ld	s11,488(sp)
ffffffffc02067fc:	25010113          	addi	sp,sp,592
ffffffffc0206800:	8082                	ret
ffffffffc0206802:	8526                	mv	a0,s1
ffffffffc0206804:	863fb0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0206808:	5df5                	li	s11,-3
ffffffffc020680a:	b769                	j	ffffffffc0206794 <do_execve+0x1bc>
ffffffffc020680c:	00093783          	ld	a5,0(s2)
ffffffffc0206810:	00007617          	auipc	a2,0x7
ffffffffc0206814:	01860613          	addi	a2,a2,24 # ffffffffc020d828 <etext+0x2064>
ffffffffc0206818:	45c1                	li	a1,16
ffffffffc020681a:	43d4                	lw	a3,4(a5)
ffffffffc020681c:	08a8                	addi	a0,sp,88
ffffffffc020681e:	23413023          	sd	s4,544(sp)
ffffffffc0206822:	fbea                	sd	s10,496(sp)
ffffffffc0206824:	637040ef          	jal	ffffffffc020b65a <snprintf>
ffffffffc0206828:	b535                	j	ffffffffc0206654 <do_execve+0x7c>
ffffffffc020682a:	8daa                	mv	s11,a0
ffffffffc020682c:	b711                	j	ffffffffc0206730 <do_execve+0x158>
ffffffffc020682e:	04000613          	li	a2,64
ffffffffc0206832:	110c                	addi	a1,sp,160
ffffffffc0206834:	8552                	mv	a0,s4
ffffffffc0206836:	dd9fe0ef          	jal	ffffffffc020560e <sysfile_read>
ffffffffc020683a:	04000793          	li	a5,64
ffffffffc020683e:	02f50463          	beq	a0,a5,ffffffffc0206866 <do_execve+0x28e>
ffffffffc0206842:	84aa                	mv	s1,a0
ffffffffc0206844:	00054363          	bltz	a0,ffffffffc020684a <do_execve+0x272>
ffffffffc0206848:	54fd                	li	s1,-1
ffffffffc020684a:	00048d9b          	sext.w	s11,s1
ffffffffc020684e:	bdd1                	j	ffffffffc0206722 <do_execve+0x14a>
ffffffffc0206850:	855e                	mv	a0,s7
ffffffffc0206852:	f26fd0ef          	jal	ffffffffc0203f78 <exit_mmap>
ffffffffc0206856:	018bb503          	ld	a0,24(s7)
ffffffffc020685a:	b10ff0ef          	jal	ffffffffc0205b6a <put_pgdir.isra.0>
ffffffffc020685e:	855e                	mv	a0,s7
ffffffffc0206860:	d62fd0ef          	jal	ffffffffc0203dc2 <mm_destroy>
ffffffffc0206864:	bd51                	j	ffffffffc02066f8 <do_execve+0x120>
ffffffffc0206866:	570a                	lw	a4,160(sp)
ffffffffc0206868:	464c47b7          	lui	a5,0x464c4
ffffffffc020686c:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206870:	30f71c63          	bne	a4,a5,ffffffffc0206b88 <do_execve+0x5b0>
ffffffffc0206874:	0d815783          	lhu	a5,216(sp)
ffffffffc0206878:	f402                	sd	zero,40(sp)
ffffffffc020687a:	e082                	sd	zero,64(sp)
ffffffffc020687c:	c7ad                	beqz	a5,ffffffffc02068e6 <do_execve+0x30e>
ffffffffc020687e:	f06a                	sd	s10,32(sp)
ffffffffc0206880:	e452                	sd	s4,8(sp)
ffffffffc0206882:	e4a2                	sd	s0,72(sp)
ffffffffc0206884:	658e                	ld	a1,192(sp)
ffffffffc0206886:	6422                	ld	s0,8(sp)
ffffffffc0206888:	77a2                	ld	a5,40(sp)
ffffffffc020688a:	4601                	li	a2,0
ffffffffc020688c:	8522                	mv	a0,s0
ffffffffc020688e:	95be                	add	a1,a1,a5
ffffffffc0206890:	ffdfe0ef          	jal	ffffffffc020588c <sysfile_seek>
ffffffffc0206894:	20051363          	bnez	a0,ffffffffc0206a9a <do_execve+0x4c2>
ffffffffc0206898:	03800613          	li	a2,56
ffffffffc020689c:	10ac                	addi	a1,sp,104
ffffffffc020689e:	8522                	mv	a0,s0
ffffffffc02068a0:	d6ffe0ef          	jal	ffffffffc020560e <sysfile_read>
ffffffffc02068a4:	03800793          	li	a5,56
ffffffffc02068a8:	00f50d63          	beq	a0,a5,ffffffffc02068c2 <do_execve+0x2ea>
ffffffffc02068ac:	7d02                	ld	s10,32(sp)
ffffffffc02068ae:	84aa                	mv	s1,a0
ffffffffc02068b0:	00054363          	bltz	a0,ffffffffc02068b6 <do_execve+0x2de>
ffffffffc02068b4:	54fd                	li	s1,-1
ffffffffc02068b6:	00048d9b          	sext.w	s11,s1
ffffffffc02068ba:	854e                	mv	a0,s3
ffffffffc02068bc:	ebcfd0ef          	jal	ffffffffc0203f78 <exit_mmap>
ffffffffc02068c0:	b58d                	j	ffffffffc0206722 <do_execve+0x14a>
ffffffffc02068c2:	57a6                	lw	a5,104(sp)
ffffffffc02068c4:	4705                	li	a4,1
ffffffffc02068c6:	1ce78d63          	beq	a5,a4,ffffffffc0206aa0 <do_execve+0x4c8>
ffffffffc02068ca:	6706                	ld	a4,64(sp)
ffffffffc02068cc:	76a2                	ld	a3,40(sp)
ffffffffc02068ce:	0d815783          	lhu	a5,216(sp)
ffffffffc02068d2:	2705                	addiw	a4,a4,1
ffffffffc02068d4:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02068d8:	e0ba                	sd	a4,64(sp)
ffffffffc02068da:	f436                	sd	a3,40(sp)
ffffffffc02068dc:	faf764e3          	bltu	a4,a5,ffffffffc0206884 <do_execve+0x2ac>
ffffffffc02068e0:	7d02                	ld	s10,32(sp)
ffffffffc02068e2:	6a22                	ld	s4,8(sp)
ffffffffc02068e4:	6426                	ld	s0,72(sp)
ffffffffc02068e6:	8552                	mv	a0,s4
ffffffffc02068e8:	d23fe0ef          	jal	ffffffffc020560a <sysfile_close>
ffffffffc02068ec:	854e                	mv	a0,s3
ffffffffc02068ee:	4701                	li	a4,0
ffffffffc02068f0:	46ad                	li	a3,11
ffffffffc02068f2:	00100637          	lui	a2,0x100
ffffffffc02068f6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02068fa:	d1afd0ef          	jal	ffffffffc0203e14 <mm_map>
ffffffffc02068fe:	8daa                	mv	s11,a0
ffffffffc0206900:	fd4d                	bnez	a0,ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206902:	0189b503          	ld	a0,24(s3)
ffffffffc0206906:	467d                	li	a2,31
ffffffffc0206908:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc020690c:	a88fd0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206910:	4e050063          	beqz	a0,ffffffffc0206df0 <do_execve+0x818>
ffffffffc0206914:	0189b503          	ld	a0,24(s3)
ffffffffc0206918:	467d                	li	a2,31
ffffffffc020691a:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc020691e:	a76fd0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206922:	4a050763          	beqz	a0,ffffffffc0206dd0 <do_execve+0x7f8>
ffffffffc0206926:	0189b503          	ld	a0,24(s3)
ffffffffc020692a:	467d                	li	a2,31
ffffffffc020692c:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206930:	a64fd0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206934:	46050e63          	beqz	a0,ffffffffc0206db0 <do_execve+0x7d8>
ffffffffc0206938:	0189b503          	ld	a0,24(s3)
ffffffffc020693c:	467d                	li	a2,31
ffffffffc020693e:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206942:	a52fd0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206946:	44050563          	beqz	a0,ffffffffc0206d90 <do_execve+0x7b8>
ffffffffc020694a:	0309a783          	lw	a5,48(s3)
ffffffffc020694e:	00093603          	ld	a2,0(s2)
ffffffffc0206952:	0189b683          	ld	a3,24(s3)
ffffffffc0206956:	2785                	addiw	a5,a5,1
ffffffffc0206958:	02f9a823          	sw	a5,48(s3)
ffffffffc020695c:	03363423          	sd	s3,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc0206960:	c02007b7          	lui	a5,0xc0200
ffffffffc0206964:	3ef6eb63          	bltu	a3,a5,ffffffffc0206d5a <do_execve+0x782>
ffffffffc0206968:	00090797          	auipc	a5,0x90
ffffffffc020696c:	f407b783          	ld	a5,-192(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206970:	577d                	li	a4,-1
ffffffffc0206972:	177e                	slli	a4,a4,0x3f
ffffffffc0206974:	8e9d                	sub	a3,a3,a5
ffffffffc0206976:	00c6d793          	srli	a5,a3,0xc
ffffffffc020697a:	f654                	sd	a3,168(a2)
ffffffffc020697c:	8fd9                	or	a5,a5,a4
ffffffffc020697e:	18079073          	csrw	satp,a5
ffffffffc0206982:	4a01                	li	s4,0
ffffffffc0206984:	0e010a93          	addi	s5,sp,224
ffffffffc0206988:	4981                	li	s3,0
ffffffffc020698a:	000ab503          	ld	a0,0(s5)
ffffffffc020698e:	6585                	lui	a1,0x1
ffffffffc0206990:	2985                	addiw	s3,s3,1
ffffffffc0206992:	52f040ef          	jal	ffffffffc020b6c0 <strnlen>
ffffffffc0206996:	00150793          	addi	a5,a0,1
ffffffffc020699a:	0aa1                	addi	s5,s5,8
ffffffffc020699c:	01478a3b          	addw	s4,a5,s4
ffffffffc02069a0:	fe89e5e3          	bltu	s3,s0,ffffffffc020698a <do_execve+0x3b2>
ffffffffc02069a4:	100009b7          	lui	s3,0x10000
ffffffffc02069a8:	003a5a1b          	srliw	s4,s4,0x3
ffffffffc02069ac:	19fd                	addi	s3,s3,-1 # fffffff <_binary_bin_sfs_img_size+0xff8acff>
ffffffffc02069ae:	414989b3          	sub	s3,s3,s4
ffffffffc02069b2:	098e                	slli	s3,s3,0x3
ffffffffc02069b4:	119c                	addi	a5,sp,224
ffffffffc02069b6:	41a98cb3          	sub	s9,s3,s10
ffffffffc02069ba:	40fc8c33          	sub	s8,s9,a5
ffffffffc02069be:	8a3e                	mv	s4,a5
ffffffffc02069c0:	4b81                	li	s7,0
ffffffffc02069c2:	4a81                	li	s5,0
ffffffffc02069c4:	000a3483          	ld	s1,0(s4)
ffffffffc02069c8:	020a9513          	slli	a0,s5,0x20
ffffffffc02069cc:	9101                	srli	a0,a0,0x20
ffffffffc02069ce:	85a6                	mv	a1,s1
ffffffffc02069d0:	954e                	add	a0,a0,s3
ffffffffc02069d2:	50b040ef          	jal	ffffffffc020b6dc <strcpy>
ffffffffc02069d6:	014c07b3          	add	a5,s8,s4
ffffffffc02069da:	872a                	mv	a4,a0
ffffffffc02069dc:	e398                	sd	a4,0(a5)
ffffffffc02069de:	8526                	mv	a0,s1
ffffffffc02069e0:	6585                	lui	a1,0x1
ffffffffc02069e2:	4df040ef          	jal	ffffffffc020b6c0 <strnlen>
ffffffffc02069e6:	00150793          	addi	a5,a0,1
ffffffffc02069ea:	2b85                	addiw	s7,s7,1
ffffffffc02069ec:	0a21                	addi	s4,s4,8
ffffffffc02069ee:	01578abb          	addw	s5,a5,s5
ffffffffc02069f2:	fc8be9e3          	bltu	s7,s0,ffffffffc02069c4 <do_execve+0x3ec>
ffffffffc02069f6:	00093783          	ld	a5,0(s2)
ffffffffc02069fa:	fe8cae23          	sw	s0,-4(s9)
ffffffffc02069fe:	12000613          	li	a2,288
ffffffffc0206a02:	0a07ba03          	ld	s4,160(a5)
ffffffffc0206a06:	4581                	li	a1,0
ffffffffc0206a08:	0d010993          	addi	s3,sp,208
ffffffffc0206a0c:	8552                	mv	a0,s4
ffffffffc0206a0e:	100a3403          	ld	s0,256(s4)
ffffffffc0206a12:	54b040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206a16:	776a                	ld	a4,184(sp)
ffffffffc0206a18:	020b1613          	slli	a2,s6,0x20
ffffffffc0206a1c:	edf47793          	andi	a5,s0,-289
ffffffffc0206a20:	1cf1                	addi	s9,s9,-4
ffffffffc0206a22:	01d65693          	srli	a3,a2,0x1d
ffffffffc0206a26:	99ea                	add	s3,s3,s10
ffffffffc0206a28:	09a0                	addi	s0,sp,216
ffffffffc0206a2a:	10fa3023          	sd	a5,256(s4)
ffffffffc0206a2e:	019a3823          	sd	s9,16(s4)
ffffffffc0206a32:	40d989b3          	sub	s3,s3,a3
ffffffffc0206a36:	946a                	add	s0,s0,s10
ffffffffc0206a38:	10ea3423          	sd	a4,264(s4)
ffffffffc0206a3c:	6008                	ld	a0,0(s0)
ffffffffc0206a3e:	1461                	addi	s0,s0,-8
ffffffffc0206a40:	e26fb0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0206a44:	ff341ce3          	bne	s0,s3,ffffffffc0206a3c <do_execve+0x464>
ffffffffc0206a48:	00093403          	ld	s0,0(s2)
ffffffffc0206a4c:	4641                	li	a2,16
ffffffffc0206a4e:	4581                	li	a1,0
ffffffffc0206a50:	0b440413          	addi	s0,s0,180
ffffffffc0206a54:	8522                	mv	a0,s0
ffffffffc0206a56:	507040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206a5a:	08ac                	addi	a1,sp,88
ffffffffc0206a5c:	8522                	mv	a0,s0
ffffffffc0206a5e:	463d                	li	a2,15
ffffffffc0206a60:	54d040ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0206a64:	24813083          	ld	ra,584(sp)
ffffffffc0206a68:	24013403          	ld	s0,576(sp)
ffffffffc0206a6c:	23813483          	ld	s1,568(sp)
ffffffffc0206a70:	23013903          	ld	s2,560(sp)
ffffffffc0206a74:	22813983          	ld	s3,552(sp)
ffffffffc0206a78:	22013a03          	ld	s4,544(sp)
ffffffffc0206a7c:	21813a83          	ld	s5,536(sp)
ffffffffc0206a80:	20813b83          	ld	s7,520(sp)
ffffffffc0206a84:	20013c03          	ld	s8,512(sp)
ffffffffc0206a88:	7cfe                	ld	s9,504(sp)
ffffffffc0206a8a:	7d5e                	ld	s10,496(sp)
ffffffffc0206a8c:	21013b03          	ld	s6,528(sp)
ffffffffc0206a90:	856e                	mv	a0,s11
ffffffffc0206a92:	7dbe                	ld	s11,488(sp)
ffffffffc0206a94:	25010113          	addi	sp,sp,592
ffffffffc0206a98:	8082                	ret
ffffffffc0206a9a:	7d02                	ld	s10,32(sp)
ffffffffc0206a9c:	8daa                	mv	s11,a0
ffffffffc0206a9e:	bd31                	j	ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206aa0:	664a                	ld	a2,144(sp)
ffffffffc0206aa2:	67aa                	ld	a5,136(sp)
ffffffffc0206aa4:	26f66b63          	bltu	a2,a5,ffffffffc0206d1a <do_execve+0x742>
ffffffffc0206aa8:	57b6                	lw	a5,108(sp)
ffffffffc0206aaa:	0027971b          	slliw	a4,a5,0x2
ffffffffc0206aae:	0027f693          	andi	a3,a5,2
ffffffffc0206ab2:	8b11                	andi	a4,a4,4
ffffffffc0206ab4:	8b91                	andi	a5,a5,4
ffffffffc0206ab6:	caf9                	beqz	a3,ffffffffc0206b8c <do_execve+0x5b4>
ffffffffc0206ab8:	24079363          	bnez	a5,ffffffffc0206cfe <do_execve+0x726>
ffffffffc0206abc:	47dd                	li	a5,23
ffffffffc0206abe:	00276693          	ori	a3,a4,2
ffffffffc0206ac2:	ec3e                	sd	a5,24(sp)
ffffffffc0206ac4:	c709                	beqz	a4,ffffffffc0206ace <do_execve+0x4f6>
ffffffffc0206ac6:	67e2                	ld	a5,24(sp)
ffffffffc0206ac8:	0087e793          	ori	a5,a5,8
ffffffffc0206acc:	ec3e                	sd	a5,24(sp)
ffffffffc0206ace:	75e6                	ld	a1,120(sp)
ffffffffc0206ad0:	4701                	li	a4,0
ffffffffc0206ad2:	854e                	mv	a0,s3
ffffffffc0206ad4:	b40fd0ef          	jal	ffffffffc0203e14 <mm_map>
ffffffffc0206ad8:	f169                	bnez	a0,ffffffffc0206a9a <do_execve+0x4c2>
ffffffffc0206ada:	74e6                	ld	s1,120(sp)
ffffffffc0206adc:	662a                	ld	a2,136(sp)
ffffffffc0206ade:	77fd                	lui	a5,0xfffff
ffffffffc0206ae0:	00f4fa33          	and	s4,s1,a5
ffffffffc0206ae4:	00c48c33          	add	s8,s1,a2
ffffffffc0206ae8:	2384f663          	bgeu	s1,s8,ffffffffc0206d14 <do_execve+0x73c>
ffffffffc0206aec:	577d                	li	a4,-1
ffffffffc0206aee:	7bc6                	ld	s7,112(sp)
ffffffffc0206af0:	00c75793          	srli	a5,a4,0xc
ffffffffc0206af4:	f83e                	sd	a5,48(sp)
ffffffffc0206af6:	00090d97          	auipc	s11,0x90
ffffffffc0206afa:	dc2d8d93          	addi	s11,s11,-574 # ffffffffc02968b8 <pages>
ffffffffc0206afe:	00009c97          	auipc	s9,0x9
ffffffffc0206b02:	fc2c8c93          	addi	s9,s9,-62 # ffffffffc020fac0 <nbase>
ffffffffc0206b06:	fc5a                	sd	s6,56(sp)
ffffffffc0206b08:	e84e                	sd	s3,16(sp)
ffffffffc0206b0a:	67c2                	ld	a5,16(sp)
ffffffffc0206b0c:	6662                	ld	a2,24(sp)
ffffffffc0206b0e:	85d2                	mv	a1,s4
ffffffffc0206b10:	6f88                	ld	a0,24(a5)
ffffffffc0206b12:	882fd0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206b16:	8d2a                	mv	s10,a0
ffffffffc0206b18:	cd5d                	beqz	a0,ffffffffc0206bd6 <do_execve+0x5fe>
ffffffffc0206b1a:	6785                	lui	a5,0x1
ffffffffc0206b1c:	00fa0b33          	add	s6,s4,a5
ffffffffc0206b20:	409c09b3          	sub	s3,s8,s1
ffffffffc0206b24:	016c6463          	bltu	s8,s6,ffffffffc0206b2c <do_execve+0x554>
ffffffffc0206b28:	409b09b3          	sub	s3,s6,s1
ffffffffc0206b2c:	000db403          	ld	s0,0(s11)
ffffffffc0206b30:	000cb583          	ld	a1,0(s9)
ffffffffc0206b34:	77c2                	ld	a5,48(sp)
ffffffffc0206b36:	408d0433          	sub	s0,s10,s0
ffffffffc0206b3a:	8419                	srai	s0,s0,0x6
ffffffffc0206b3c:	00090617          	auipc	a2,0x90
ffffffffc0206b40:	d7463603          	ld	a2,-652(a2) # ffffffffc02968b0 <npage>
ffffffffc0206b44:	942e                	add	s0,s0,a1
ffffffffc0206b46:	00f475b3          	and	a1,s0,a5
ffffffffc0206b4a:	0432                	slli	s0,s0,0xc
ffffffffc0206b4c:	22c5f363          	bgeu	a1,a2,ffffffffc0206d72 <do_execve+0x79a>
ffffffffc0206b50:	6522                	ld	a0,8(sp)
ffffffffc0206b52:	4601                	li	a2,0
ffffffffc0206b54:	85de                	mv	a1,s7
ffffffffc0206b56:	00090a97          	auipc	s5,0x90
ffffffffc0206b5a:	d52aba83          	ld	s5,-686(s5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206b5e:	d2ffe0ef          	jal	ffffffffc020588c <sysfile_seek>
ffffffffc0206b62:	e131                	bnez	a0,ffffffffc0206ba6 <do_execve+0x5ce>
ffffffffc0206b64:	6522                	ld	a0,8(sp)
ffffffffc0206b66:	9aa2                	add	s5,s5,s0
ffffffffc0206b68:	414485b3          	sub	a1,s1,s4
ffffffffc0206b6c:	95d6                	add	a1,a1,s5
ffffffffc0206b6e:	864e                	mv	a2,s3
ffffffffc0206b70:	a9ffe0ef          	jal	ffffffffc020560e <sysfile_read>
ffffffffc0206b74:	02a98363          	beq	s3,a0,ffffffffc0206b9a <do_execve+0x5c2>
ffffffffc0206b78:	7d02                	ld	s10,32(sp)
ffffffffc0206b7a:	7b62                	ld	s6,56(sp)
ffffffffc0206b7c:	69c2                	ld	s3,16(sp)
ffffffffc0206b7e:	84aa                	mv	s1,a0
ffffffffc0206b80:	d2054be3          	bltz	a0,ffffffffc02068b6 <do_execve+0x2de>
ffffffffc0206b84:	54fd                	li	s1,-1
ffffffffc0206b86:	bb05                	j	ffffffffc02068b6 <do_execve+0x2de>
ffffffffc0206b88:	5de1                	li	s11,-8
ffffffffc0206b8a:	be61                	j	ffffffffc0206722 <do_execve+0x14a>
ffffffffc0206b8c:	16078563          	beqz	a5,ffffffffc0206cf6 <do_execve+0x71e>
ffffffffc0206b90:	47cd                	li	a5,19
ffffffffc0206b92:	00176693          	ori	a3,a4,1
ffffffffc0206b96:	ec3e                	sd	a5,24(sp)
ffffffffc0206b98:	b735                	j	ffffffffc0206ac4 <do_execve+0x4ec>
ffffffffc0206b9a:	94ce                	add	s1,s1,s3
ffffffffc0206b9c:	9bce                	add	s7,s7,s3
ffffffffc0206b9e:	0584f163          	bgeu	s1,s8,ffffffffc0206be0 <do_execve+0x608>
ffffffffc0206ba2:	8a5a                	mv	s4,s6
ffffffffc0206ba4:	b79d                	j	ffffffffc0206b0a <do_execve+0x532>
ffffffffc0206ba6:	7d02                	ld	s10,32(sp)
ffffffffc0206ba8:	7b62                	ld	s6,56(sp)
ffffffffc0206baa:	69c2                	ld	s3,16(sp)
ffffffffc0206bac:	8daa                	mv	s11,a0
ffffffffc0206bae:	b331                	j	ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206bb0:	000b8863          	beqz	s7,ffffffffc0206bc0 <do_execve+0x5e8>
ffffffffc0206bb4:	038b8513          	addi	a0,s7,56
ffffffffc0206bb8:	a3bfd0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0206bbc:	040ba823          	sw	zero,80(s7)
ffffffffc0206bc0:	24013403          	ld	s0,576(sp)
ffffffffc0206bc4:	23813483          	ld	s1,568(sp)
ffffffffc0206bc8:	23013903          	ld	s2,560(sp)
ffffffffc0206bcc:	20813b83          	ld	s7,520(sp)
ffffffffc0206bd0:	7cfe                	ld	s9,504(sp)
ffffffffc0206bd2:	5df5                	li	s11,-3
ffffffffc0206bd4:	b931                	j	ffffffffc02067f0 <do_execve+0x218>
ffffffffc0206bd6:	7d02                	ld	s10,32(sp)
ffffffffc0206bd8:	7b62                	ld	s6,56(sp)
ffffffffc0206bda:	69c2                	ld	s3,16(sp)
ffffffffc0206bdc:	5df1                	li	s11,-4
ffffffffc0206bde:	b9f1                	j	ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206be0:	8aea                	mv	s5,s10
ffffffffc0206be2:	69c2                	ld	s3,16(sp)
ffffffffc0206be4:	8d5a                	mv	s10,s6
ffffffffc0206be6:	7866                	ld	a6,120(sp)
ffffffffc0206be8:	7b62                	ld	s6,56(sp)
ffffffffc0206bea:	66ca                	ld	a3,144(sp)
ffffffffc0206bec:	00d80433          	add	s0,a6,a3
ffffffffc0206bf0:	07a4f863          	bgeu	s1,s10,ffffffffc0206c60 <do_execve+0x688>
ffffffffc0206bf4:	cc940be3          	beq	s0,s1,ffffffffc02068ca <do_execve+0x2f2>
ffffffffc0206bf8:	40940a33          	sub	s4,s0,s1
ffffffffc0206bfc:	01a46463          	bltu	s0,s10,ffffffffc0206c04 <do_execve+0x62c>
ffffffffc0206c00:	409d0a33          	sub	s4,s10,s1
ffffffffc0206c04:	00090697          	auipc	a3,0x90
ffffffffc0206c08:	cb46b683          	ld	a3,-844(a3) # ffffffffc02968b8 <pages>
ffffffffc0206c0c:	00009617          	auipc	a2,0x9
ffffffffc0206c10:	eb463603          	ld	a2,-332(a2) # ffffffffc020fac0 <nbase>
ffffffffc0206c14:	00090597          	auipc	a1,0x90
ffffffffc0206c18:	c9c5b583          	ld	a1,-868(a1) # ffffffffc02968b0 <npage>
ffffffffc0206c1c:	40da86b3          	sub	a3,s5,a3
ffffffffc0206c20:	8699                	srai	a3,a3,0x6
ffffffffc0206c22:	96b2                	add	a3,a3,a2
ffffffffc0206c24:	00c69613          	slli	a2,a3,0xc
ffffffffc0206c28:	8231                	srli	a2,a2,0xc
ffffffffc0206c2a:	06b2                	slli	a3,a3,0xc
ffffffffc0206c2c:	0eb67b63          	bgeu	a2,a1,ffffffffc0206d22 <do_execve+0x74a>
ffffffffc0206c30:	00090617          	auipc	a2,0x90
ffffffffc0206c34:	c7863603          	ld	a2,-904(a2) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206c38:	6505                	lui	a0,0x1
ffffffffc0206c3a:	9526                	add	a0,a0,s1
ffffffffc0206c3c:	96b2                	add	a3,a3,a2
ffffffffc0206c3e:	41a50533          	sub	a0,a0,s10
ffffffffc0206c42:	9536                	add	a0,a0,a3
ffffffffc0206c44:	8652                	mv	a2,s4
ffffffffc0206c46:	4581                	li	a1,0
ffffffffc0206c48:	315040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206c4c:	94d2                	add	s1,s1,s4
ffffffffc0206c4e:	01a436b3          	sltu	a3,s0,s10
ffffffffc0206c52:	01a47463          	bgeu	s0,s10,ffffffffc0206c5a <do_execve+0x682>
ffffffffc0206c56:	c6940ae3          	beq	s0,s1,ffffffffc02068ca <do_execve+0x2f2>
ffffffffc0206c5a:	e2e5                	bnez	a3,ffffffffc0206d3a <do_execve+0x762>
ffffffffc0206c5c:	0da49f63          	bne	s1,s10,ffffffffc0206d3a <do_execve+0x762>
ffffffffc0206c60:	c684f5e3          	bgeu	s1,s0,ffffffffc02068ca <do_execve+0x2f2>
ffffffffc0206c64:	57fd                	li	a5,-1
ffffffffc0206c66:	83b1                	srli	a5,a5,0xc
ffffffffc0206c68:	e83e                	sd	a5,16(sp)
ffffffffc0206c6a:	00090c97          	auipc	s9,0x90
ffffffffc0206c6e:	c4ec8c93          	addi	s9,s9,-946 # ffffffffc02968b8 <pages>
ffffffffc0206c72:	00009c17          	auipc	s8,0x9
ffffffffc0206c76:	e4ec0c13          	addi	s8,s8,-434 # ffffffffc020fac0 <nbase>
ffffffffc0206c7a:	00090b97          	auipc	s7,0x90
ffffffffc0206c7e:	c36b8b93          	addi	s7,s7,-970 # ffffffffc02968b0 <npage>
ffffffffc0206c82:	00090d97          	auipc	s11,0x90
ffffffffc0206c86:	c26d8d93          	addi	s11,s11,-986 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206c8a:	f85a                	sd	s6,48(sp)
ffffffffc0206c8c:	a889                	j	ffffffffc0206cde <do_execve+0x706>
ffffffffc0206c8e:	6785                	lui	a5,0x1
ffffffffc0206c90:	00fd0a33          	add	s4,s10,a5
ffffffffc0206c94:	40940b33          	sub	s6,s0,s1
ffffffffc0206c98:	01446463          	bltu	s0,s4,ffffffffc0206ca0 <do_execve+0x6c8>
ffffffffc0206c9c:	409a0b33          	sub	s6,s4,s1
ffffffffc0206ca0:	000cb783          	ld	a5,0(s9)
ffffffffc0206ca4:	000c3583          	ld	a1,0(s8)
ffffffffc0206ca8:	6742                	ld	a4,16(sp)
ffffffffc0206caa:	40fa87b3          	sub	a5,s5,a5
ffffffffc0206cae:	8799                	srai	a5,a5,0x6
ffffffffc0206cb0:	000bb683          	ld	a3,0(s7)
ffffffffc0206cb4:	97ae                	add	a5,a5,a1
ffffffffc0206cb6:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206cba:	07b2                	slli	a5,a5,0xc
ffffffffc0206cbc:	06d5f263          	bgeu	a1,a3,ffffffffc0206d20 <do_execve+0x748>
ffffffffc0206cc0:	000db683          	ld	a3,0(s11)
ffffffffc0206cc4:	41a48d33          	sub	s10,s1,s10
ffffffffc0206cc8:	865a                	mv	a2,s6
ffffffffc0206cca:	97b6                	add	a5,a5,a3
ffffffffc0206ccc:	01a78533          	add	a0,a5,s10
ffffffffc0206cd0:	4581                	li	a1,0
ffffffffc0206cd2:	94da                	add	s1,s1,s6
ffffffffc0206cd4:	289040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206cd8:	0284f863          	bgeu	s1,s0,ffffffffc0206d08 <do_execve+0x730>
ffffffffc0206cdc:	8d52                	mv	s10,s4
ffffffffc0206cde:	0189b503          	ld	a0,24(s3)
ffffffffc0206ce2:	6662                	ld	a2,24(sp)
ffffffffc0206ce4:	85ea                	mv	a1,s10
ffffffffc0206ce6:	eaffc0ef          	jal	ffffffffc0203b94 <pgdir_alloc_page>
ffffffffc0206cea:	8aaa                	mv	s5,a0
ffffffffc0206cec:	f14d                	bnez	a0,ffffffffc0206c8e <do_execve+0x6b6>
ffffffffc0206cee:	7d02                	ld	s10,32(sp)
ffffffffc0206cf0:	7b42                	ld	s6,48(sp)
ffffffffc0206cf2:	5df1                	li	s11,-4
ffffffffc0206cf4:	b6d9                	j	ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206cf6:	47c5                	li	a5,17
ffffffffc0206cf8:	86ba                	mv	a3,a4
ffffffffc0206cfa:	ec3e                	sd	a5,24(sp)
ffffffffc0206cfc:	b3e1                	j	ffffffffc0206ac4 <do_execve+0x4ec>
ffffffffc0206cfe:	47dd                	li	a5,23
ffffffffc0206d00:	00376693          	ori	a3,a4,3
ffffffffc0206d04:	ec3e                	sd	a5,24(sp)
ffffffffc0206d06:	bb7d                	j	ffffffffc0206ac4 <do_execve+0x4ec>
ffffffffc0206d08:	7b42                	ld	s6,48(sp)
ffffffffc0206d0a:	b6c1                	j	ffffffffc02068ca <do_execve+0x2f2>
ffffffffc0206d0c:	5df5                	li	s11,-3
ffffffffc0206d0e:	aa0b9fe3          	bnez	s7,ffffffffc02067cc <do_execve+0x1f4>
ffffffffc0206d12:	b4d9                	j	ffffffffc02067d8 <do_execve+0x200>
ffffffffc0206d14:	8d52                	mv	s10,s4
ffffffffc0206d16:	8826                	mv	a6,s1
ffffffffc0206d18:	bdc9                	j	ffffffffc0206bea <do_execve+0x612>
ffffffffc0206d1a:	7d02                	ld	s10,32(sp)
ffffffffc0206d1c:	5de1                	li	s11,-8
ffffffffc0206d1e:	be71                	j	ffffffffc02068ba <do_execve+0x2e2>
ffffffffc0206d20:	86be                	mv	a3,a5
ffffffffc0206d22:	00006617          	auipc	a2,0x6
ffffffffc0206d26:	95660613          	addi	a2,a2,-1706 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0206d2a:	07100593          	li	a1,113
ffffffffc0206d2e:	00006517          	auipc	a0,0x6
ffffffffc0206d32:	97250513          	addi	a0,a0,-1678 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0206d36:	f14f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d3a:	00007697          	auipc	a3,0x7
ffffffffc0206d3e:	b2668693          	addi	a3,a3,-1242 # ffffffffc020d860 <etext+0x209c>
ffffffffc0206d42:	00005617          	auipc	a2,0x5
ffffffffc0206d46:	ebe60613          	addi	a2,a2,-322 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206d4a:	32c00593          	li	a1,812
ffffffffc0206d4e:	00007517          	auipc	a0,0x7
ffffffffc0206d52:	8fa50513          	addi	a0,a0,-1798 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206d56:	ef4f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d5a:	00006617          	auipc	a2,0x6
ffffffffc0206d5e:	9c660613          	addi	a2,a2,-1594 # ffffffffc020c720 <etext+0xf5c>
ffffffffc0206d62:	34c00593          	li	a1,844
ffffffffc0206d66:	00007517          	auipc	a0,0x7
ffffffffc0206d6a:	8e250513          	addi	a0,a0,-1822 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206d6e:	edcf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d72:	86a2                	mv	a3,s0
ffffffffc0206d74:	00006617          	auipc	a2,0x6
ffffffffc0206d78:	90460613          	addi	a2,a2,-1788 # ffffffffc020c678 <etext+0xeb4>
ffffffffc0206d7c:	07100593          	li	a1,113
ffffffffc0206d80:	00006517          	auipc	a0,0x6
ffffffffc0206d84:	92050513          	addi	a0,a0,-1760 # ffffffffc020c6a0 <etext+0xedc>
ffffffffc0206d88:	ec2f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d8c:	8daa                	mv	s11,a0
ffffffffc0206d8e:	b24d                	j	ffffffffc0206730 <do_execve+0x158>
ffffffffc0206d90:	00007697          	auipc	a3,0x7
ffffffffc0206d94:	be868693          	addi	a3,a3,-1048 # ffffffffc020d978 <etext+0x21b4>
ffffffffc0206d98:	00005617          	auipc	a2,0x5
ffffffffc0206d9c:	e6860613          	addi	a2,a2,-408 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206da0:	34600593          	li	a1,838
ffffffffc0206da4:	00007517          	auipc	a0,0x7
ffffffffc0206da8:	8a450513          	addi	a0,a0,-1884 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206dac:	e9ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206db0:	00007697          	auipc	a3,0x7
ffffffffc0206db4:	b8068693          	addi	a3,a3,-1152 # ffffffffc020d930 <etext+0x216c>
ffffffffc0206db8:	00005617          	auipc	a2,0x5
ffffffffc0206dbc:	e4860613          	addi	a2,a2,-440 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206dc0:	34500593          	li	a1,837
ffffffffc0206dc4:	00007517          	auipc	a0,0x7
ffffffffc0206dc8:	88450513          	addi	a0,a0,-1916 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206dcc:	e7ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206dd0:	00007697          	auipc	a3,0x7
ffffffffc0206dd4:	b1868693          	addi	a3,a3,-1256 # ffffffffc020d8e8 <etext+0x2124>
ffffffffc0206dd8:	00005617          	auipc	a2,0x5
ffffffffc0206ddc:	e2860613          	addi	a2,a2,-472 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206de0:	34400593          	li	a1,836
ffffffffc0206de4:	00007517          	auipc	a0,0x7
ffffffffc0206de8:	86450513          	addi	a0,a0,-1948 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206dec:	e5ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206df0:	00007697          	auipc	a3,0x7
ffffffffc0206df4:	ab068693          	addi	a3,a3,-1360 # ffffffffc020d8a0 <etext+0x20dc>
ffffffffc0206df8:	00005617          	auipc	a2,0x5
ffffffffc0206dfc:	e0860613          	addi	a2,a2,-504 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0206e00:	34300593          	li	a1,835
ffffffffc0206e04:	00007517          	auipc	a0,0x7
ffffffffc0206e08:	84450513          	addi	a0,a0,-1980 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206e0c:	e3ef90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206e10 <user_main>:
ffffffffc0206e10:	7179                	addi	sp,sp,-48
ffffffffc0206e12:	e84a                	sd	s2,16(sp)
ffffffffc0206e14:	00090917          	auipc	s2,0x90
ffffffffc0206e18:	ab490913          	addi	s2,s2,-1356 # ffffffffc02968c8 <current>
ffffffffc0206e1c:	00093783          	ld	a5,0(s2)
ffffffffc0206e20:	00007617          	auipc	a2,0x7
ffffffffc0206e24:	ba060613          	addi	a2,a2,-1120 # ffffffffc020d9c0 <etext+0x21fc>
ffffffffc0206e28:	00007517          	auipc	a0,0x7
ffffffffc0206e2c:	ba050513          	addi	a0,a0,-1120 # ffffffffc020d9c8 <etext+0x2204>
ffffffffc0206e30:	43cc                	lw	a1,4(a5)
ffffffffc0206e32:	f406                	sd	ra,40(sp)
ffffffffc0206e34:	f022                	sd	s0,32(sp)
ffffffffc0206e36:	ec26                	sd	s1,24(sp)
ffffffffc0206e38:	e402                	sd	zero,8(sp)
ffffffffc0206e3a:	e032                	sd	a2,0(sp)
ffffffffc0206e3c:	b6af90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206e40:	6782                	ld	a5,0(sp)
ffffffffc0206e42:	cfb9                	beqz	a5,ffffffffc0206ea0 <user_main+0x90>
ffffffffc0206e44:	003c                	addi	a5,sp,8
ffffffffc0206e46:	4401                	li	s0,0
ffffffffc0206e48:	6398                	ld	a4,0(a5)
ffffffffc0206e4a:	07a1                	addi	a5,a5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0206e4c:	0405                	addi	s0,s0,1
ffffffffc0206e4e:	ff6d                	bnez	a4,ffffffffc0206e48 <user_main+0x38>
ffffffffc0206e50:	00093703          	ld	a4,0(s2)
ffffffffc0206e54:	6789                	lui	a5,0x2
ffffffffc0206e56:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206e5a:	6b04                	ld	s1,16(a4)
ffffffffc0206e5c:	734c                	ld	a1,160(a4)
ffffffffc0206e5e:	12000613          	li	a2,288
ffffffffc0206e62:	94be                	add	s1,s1,a5
ffffffffc0206e64:	8526                	mv	a0,s1
ffffffffc0206e66:	147040ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0206e6a:	00093783          	ld	a5,0(s2)
ffffffffc0206e6e:	0004059b          	sext.w	a1,s0
ffffffffc0206e72:	860a                	mv	a2,sp
ffffffffc0206e74:	f3c4                	sd	s1,160(a5)
ffffffffc0206e76:	00007517          	auipc	a0,0x7
ffffffffc0206e7a:	b4a50513          	addi	a0,a0,-1206 # ffffffffc020d9c0 <etext+0x21fc>
ffffffffc0206e7e:	f5aff0ef          	jal	ffffffffc02065d8 <do_execve>
ffffffffc0206e82:	8126                	mv	sp,s1
ffffffffc0206e84:	b70fa06f          	j	ffffffffc02011f4 <__trapret>
ffffffffc0206e88:	00007617          	auipc	a2,0x7
ffffffffc0206e8c:	b6860613          	addi	a2,a2,-1176 # ffffffffc020d9f0 <etext+0x222c>
ffffffffc0206e90:	48800593          	li	a1,1160
ffffffffc0206e94:	00006517          	auipc	a0,0x6
ffffffffc0206e98:	7b450513          	addi	a0,a0,1972 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0206e9c:	daef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206ea0:	4401                	li	s0,0
ffffffffc0206ea2:	b77d                	j	ffffffffc0206e50 <user_main+0x40>

ffffffffc0206ea4 <do_yield>:
ffffffffc0206ea4:	00090797          	auipc	a5,0x90
ffffffffc0206ea8:	a247b783          	ld	a5,-1500(a5) # ffffffffc02968c8 <current>
ffffffffc0206eac:	4705                	li	a4,1
ffffffffc0206eae:	4501                	li	a0,0
ffffffffc0206eb0:	ef98                	sd	a4,24(a5)
ffffffffc0206eb2:	8082                	ret

ffffffffc0206eb4 <do_wait>:
ffffffffc0206eb4:	c59d                	beqz	a1,ffffffffc0206ee2 <do_wait+0x2e>
ffffffffc0206eb6:	1101                	addi	sp,sp,-32
ffffffffc0206eb8:	e02a                	sd	a0,0(sp)
ffffffffc0206eba:	00090517          	auipc	a0,0x90
ffffffffc0206ebe:	a0e53503          	ld	a0,-1522(a0) # ffffffffc02968c8 <current>
ffffffffc0206ec2:	4685                	li	a3,1
ffffffffc0206ec4:	4611                	li	a2,4
ffffffffc0206ec6:	7508                	ld	a0,40(a0)
ffffffffc0206ec8:	ec06                	sd	ra,24(sp)
ffffffffc0206eca:	e42e                	sd	a1,8(sp)
ffffffffc0206ecc:	c4afd0ef          	jal	ffffffffc0204316 <user_mem_check>
ffffffffc0206ed0:	6702                	ld	a4,0(sp)
ffffffffc0206ed2:	67a2                	ld	a5,8(sp)
ffffffffc0206ed4:	c909                	beqz	a0,ffffffffc0206ee6 <do_wait+0x32>
ffffffffc0206ed6:	60e2                	ld	ra,24(sp)
ffffffffc0206ed8:	85be                	mv	a1,a5
ffffffffc0206eda:	853a                	mv	a0,a4
ffffffffc0206edc:	6105                	addi	sp,sp,32
ffffffffc0206ede:	bc8ff06f          	j	ffffffffc02062a6 <do_wait.part.0>
ffffffffc0206ee2:	bc4ff06f          	j	ffffffffc02062a6 <do_wait.part.0>
ffffffffc0206ee6:	60e2                	ld	ra,24(sp)
ffffffffc0206ee8:	5575                	li	a0,-3
ffffffffc0206eea:	6105                	addi	sp,sp,32
ffffffffc0206eec:	8082                	ret

ffffffffc0206eee <do_kill>:
ffffffffc0206eee:	6789                	lui	a5,0x2
ffffffffc0206ef0:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206ef4:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206ef6:	06e7e463          	bltu	a5,a4,ffffffffc0206f5e <do_kill+0x70>
ffffffffc0206efa:	1101                	addi	sp,sp,-32
ffffffffc0206efc:	45a9                	li	a1,10
ffffffffc0206efe:	ec06                	sd	ra,24(sp)
ffffffffc0206f00:	e42a                	sd	a0,8(sp)
ffffffffc0206f02:	31e040ef          	jal	ffffffffc020b220 <hash32>
ffffffffc0206f06:	02051793          	slli	a5,a0,0x20
ffffffffc0206f0a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206f0e:	0008b797          	auipc	a5,0x8b
ffffffffc0206f12:	8b278793          	addi	a5,a5,-1870 # ffffffffc02917c0 <hash_list>
ffffffffc0206f16:	96be                	add	a3,a3,a5
ffffffffc0206f18:	6622                	ld	a2,8(sp)
ffffffffc0206f1a:	8536                	mv	a0,a3
ffffffffc0206f1c:	a029                	j	ffffffffc0206f26 <do_kill+0x38>
ffffffffc0206f1e:	f2c52703          	lw	a4,-212(a0)
ffffffffc0206f22:	00c70963          	beq	a4,a2,ffffffffc0206f34 <do_kill+0x46>
ffffffffc0206f26:	6508                	ld	a0,8(a0)
ffffffffc0206f28:	fea69be3          	bne	a3,a0,ffffffffc0206f1e <do_kill+0x30>
ffffffffc0206f2c:	60e2                	ld	ra,24(sp)
ffffffffc0206f2e:	5575                	li	a0,-3
ffffffffc0206f30:	6105                	addi	sp,sp,32
ffffffffc0206f32:	8082                	ret
ffffffffc0206f34:	fd852703          	lw	a4,-40(a0)
ffffffffc0206f38:	00177693          	andi	a3,a4,1
ffffffffc0206f3c:	e29d                	bnez	a3,ffffffffc0206f62 <do_kill+0x74>
ffffffffc0206f3e:	4954                	lw	a3,20(a0)
ffffffffc0206f40:	00176713          	ori	a4,a4,1
ffffffffc0206f44:	fce52c23          	sw	a4,-40(a0)
ffffffffc0206f48:	0006c663          	bltz	a3,ffffffffc0206f54 <do_kill+0x66>
ffffffffc0206f4c:	4501                	li	a0,0
ffffffffc0206f4e:	60e2                	ld	ra,24(sp)
ffffffffc0206f50:	6105                	addi	sp,sp,32
ffffffffc0206f52:	8082                	ret
ffffffffc0206f54:	f2850513          	addi	a0,a0,-216
ffffffffc0206f58:	454000ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0206f5c:	bfc5                	j	ffffffffc0206f4c <do_kill+0x5e>
ffffffffc0206f5e:	5575                	li	a0,-3
ffffffffc0206f60:	8082                	ret
ffffffffc0206f62:	555d                	li	a0,-9
ffffffffc0206f64:	b7ed                	j	ffffffffc0206f4e <do_kill+0x60>

ffffffffc0206f66 <proc_init>:
ffffffffc0206f66:	1101                	addi	sp,sp,-32
ffffffffc0206f68:	e426                	sd	s1,8(sp)
ffffffffc0206f6a:	0008f797          	auipc	a5,0x8f
ffffffffc0206f6e:	85678793          	addi	a5,a5,-1962 # ffffffffc02957c0 <proc_list>
ffffffffc0206f72:	ec06                	sd	ra,24(sp)
ffffffffc0206f74:	e822                	sd	s0,16(sp)
ffffffffc0206f76:	e04a                	sd	s2,0(sp)
ffffffffc0206f78:	0008b497          	auipc	s1,0x8b
ffffffffc0206f7c:	84848493          	addi	s1,s1,-1976 # ffffffffc02917c0 <hash_list>
ffffffffc0206f80:	e79c                	sd	a5,8(a5)
ffffffffc0206f82:	e39c                	sd	a5,0(a5)
ffffffffc0206f84:	0008f717          	auipc	a4,0x8f
ffffffffc0206f88:	83c70713          	addi	a4,a4,-1988 # ffffffffc02957c0 <proc_list>
ffffffffc0206f8c:	87a6                	mv	a5,s1
ffffffffc0206f8e:	e79c                	sd	a5,8(a5)
ffffffffc0206f90:	e39c                	sd	a5,0(a5)
ffffffffc0206f92:	07c1                	addi	a5,a5,16
ffffffffc0206f94:	fee79de3          	bne	a5,a4,ffffffffc0206f8e <proc_init+0x28>
ffffffffc0206f98:	b2bfe0ef          	jal	ffffffffc0205ac2 <alloc_proc>
ffffffffc0206f9c:	00090917          	auipc	s2,0x90
ffffffffc0206fa0:	93c90913          	addi	s2,s2,-1732 # ffffffffc02968d8 <idleproc>
ffffffffc0206fa4:	00a93023          	sd	a0,0(s2)
ffffffffc0206fa8:	842a                	mv	s0,a0
ffffffffc0206faa:	12050c63          	beqz	a0,ffffffffc02070e2 <proc_init+0x17c>
ffffffffc0206fae:	4689                	li	a3,2
ffffffffc0206fb0:	0000a717          	auipc	a4,0xa
ffffffffc0206fb4:	05070713          	addi	a4,a4,80 # ffffffffc0211000 <bootstack>
ffffffffc0206fb8:	4785                	li	a5,1
ffffffffc0206fba:	e114                	sd	a3,0(a0)
ffffffffc0206fbc:	e918                	sd	a4,16(a0)
ffffffffc0206fbe:	ed1c                	sd	a5,24(a0)
ffffffffc0206fc0:	ab8fe0ef          	jal	ffffffffc0205278 <files_create>
ffffffffc0206fc4:	14a43423          	sd	a0,328(s0)
ffffffffc0206fc8:	10050163          	beqz	a0,ffffffffc02070ca <proc_init+0x164>
ffffffffc0206fcc:	00093403          	ld	s0,0(s2)
ffffffffc0206fd0:	4641                	li	a2,16
ffffffffc0206fd2:	4581                	li	a1,0
ffffffffc0206fd4:	14843703          	ld	a4,328(s0)
ffffffffc0206fd8:	0b440413          	addi	s0,s0,180
ffffffffc0206fdc:	8522                	mv	a0,s0
ffffffffc0206fde:	4b1c                	lw	a5,16(a4)
ffffffffc0206fe0:	2785                	addiw	a5,a5,1
ffffffffc0206fe2:	cb1c                	sw	a5,16(a4)
ffffffffc0206fe4:	778040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0206fe8:	8522                	mv	a0,s0
ffffffffc0206fea:	463d                	li	a2,15
ffffffffc0206fec:	00007597          	auipc	a1,0x7
ffffffffc0206ff0:	a6458593          	addi	a1,a1,-1436 # ffffffffc020da50 <etext+0x228c>
ffffffffc0206ff4:	7b8040ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0206ff8:	00090797          	auipc	a5,0x90
ffffffffc0206ffc:	8c87a783          	lw	a5,-1848(a5) # ffffffffc02968c0 <nr_process>
ffffffffc0207000:	00093703          	ld	a4,0(s2)
ffffffffc0207004:	4601                	li	a2,0
ffffffffc0207006:	2785                	addiw	a5,a5,1
ffffffffc0207008:	4581                	li	a1,0
ffffffffc020700a:	fffff517          	auipc	a0,0xfffff
ffffffffc020700e:	47e50513          	addi	a0,a0,1150 # ffffffffc0206488 <init_main>
ffffffffc0207012:	00090697          	auipc	a3,0x90
ffffffffc0207016:	8ae6bb23          	sd	a4,-1866(a3) # ffffffffc02968c8 <current>
ffffffffc020701a:	00090717          	auipc	a4,0x90
ffffffffc020701e:	8af72323          	sw	a5,-1882(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0207022:	8d4ff0ef          	jal	ffffffffc02060f6 <kernel_thread>
ffffffffc0207026:	842a                	mv	s0,a0
ffffffffc0207028:	08a05563          	blez	a0,ffffffffc02070b2 <proc_init+0x14c>
ffffffffc020702c:	6789                	lui	a5,0x2
ffffffffc020702e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0207030:	fff5071b          	addiw	a4,a0,-1
ffffffffc0207034:	02e7e463          	bltu	a5,a4,ffffffffc020705c <proc_init+0xf6>
ffffffffc0207038:	45a9                	li	a1,10
ffffffffc020703a:	1e6040ef          	jal	ffffffffc020b220 <hash32>
ffffffffc020703e:	02051713          	slli	a4,a0,0x20
ffffffffc0207042:	01c75793          	srli	a5,a4,0x1c
ffffffffc0207046:	00f486b3          	add	a3,s1,a5
ffffffffc020704a:	87b6                	mv	a5,a3
ffffffffc020704c:	a029                	j	ffffffffc0207056 <proc_init+0xf0>
ffffffffc020704e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0207052:	04870d63          	beq	a4,s0,ffffffffc02070ac <proc_init+0x146>
ffffffffc0207056:	679c                	ld	a5,8(a5)
ffffffffc0207058:	fef69be3          	bne	a3,a5,ffffffffc020704e <proc_init+0xe8>
ffffffffc020705c:	4781                	li	a5,0
ffffffffc020705e:	0b478413          	addi	s0,a5,180
ffffffffc0207062:	4641                	li	a2,16
ffffffffc0207064:	4581                	li	a1,0
ffffffffc0207066:	8522                	mv	a0,s0
ffffffffc0207068:	00090717          	auipc	a4,0x90
ffffffffc020706c:	86f73423          	sd	a5,-1944(a4) # ffffffffc02968d0 <initproc>
ffffffffc0207070:	6ec040ef          	jal	ffffffffc020b75c <memset>
ffffffffc0207074:	8522                	mv	a0,s0
ffffffffc0207076:	463d                	li	a2,15
ffffffffc0207078:	00007597          	auipc	a1,0x7
ffffffffc020707c:	a0058593          	addi	a1,a1,-1536 # ffffffffc020da78 <etext+0x22b4>
ffffffffc0207080:	72c040ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc0207084:	00093783          	ld	a5,0(s2)
ffffffffc0207088:	cbc9                	beqz	a5,ffffffffc020711a <proc_init+0x1b4>
ffffffffc020708a:	43dc                	lw	a5,4(a5)
ffffffffc020708c:	e7d9                	bnez	a5,ffffffffc020711a <proc_init+0x1b4>
ffffffffc020708e:	00090797          	auipc	a5,0x90
ffffffffc0207092:	8427b783          	ld	a5,-1982(a5) # ffffffffc02968d0 <initproc>
ffffffffc0207096:	c3b5                	beqz	a5,ffffffffc02070fa <proc_init+0x194>
ffffffffc0207098:	43d8                	lw	a4,4(a5)
ffffffffc020709a:	4785                	li	a5,1
ffffffffc020709c:	04f71f63          	bne	a4,a5,ffffffffc02070fa <proc_init+0x194>
ffffffffc02070a0:	60e2                	ld	ra,24(sp)
ffffffffc02070a2:	6442                	ld	s0,16(sp)
ffffffffc02070a4:	64a2                	ld	s1,8(sp)
ffffffffc02070a6:	6902                	ld	s2,0(sp)
ffffffffc02070a8:	6105                	addi	sp,sp,32
ffffffffc02070aa:	8082                	ret
ffffffffc02070ac:	f2878793          	addi	a5,a5,-216
ffffffffc02070b0:	b77d                	j	ffffffffc020705e <proc_init+0xf8>
ffffffffc02070b2:	00007617          	auipc	a2,0x7
ffffffffc02070b6:	9a660613          	addi	a2,a2,-1626 # ffffffffc020da58 <etext+0x2294>
ffffffffc02070ba:	4d400593          	li	a1,1236
ffffffffc02070be:	00006517          	auipc	a0,0x6
ffffffffc02070c2:	58a50513          	addi	a0,a0,1418 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02070c6:	b84f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02070ca:	00007617          	auipc	a2,0x7
ffffffffc02070ce:	95e60613          	addi	a2,a2,-1698 # ffffffffc020da28 <etext+0x2264>
ffffffffc02070d2:	4c800593          	li	a1,1224
ffffffffc02070d6:	00006517          	auipc	a0,0x6
ffffffffc02070da:	57250513          	addi	a0,a0,1394 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02070de:	b6cf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02070e2:	00007617          	auipc	a2,0x7
ffffffffc02070e6:	92e60613          	addi	a2,a2,-1746 # ffffffffc020da10 <etext+0x224c>
ffffffffc02070ea:	4be00593          	li	a1,1214
ffffffffc02070ee:	00006517          	auipc	a0,0x6
ffffffffc02070f2:	55a50513          	addi	a0,a0,1370 # ffffffffc020d648 <etext+0x1e84>
ffffffffc02070f6:	b54f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02070fa:	00007697          	auipc	a3,0x7
ffffffffc02070fe:	9ae68693          	addi	a3,a3,-1618 # ffffffffc020daa8 <etext+0x22e4>
ffffffffc0207102:	00005617          	auipc	a2,0x5
ffffffffc0207106:	afe60613          	addi	a2,a2,-1282 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020710a:	4db00593          	li	a1,1243
ffffffffc020710e:	00006517          	auipc	a0,0x6
ffffffffc0207112:	53a50513          	addi	a0,a0,1338 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0207116:	b34f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020711a:	00007697          	auipc	a3,0x7
ffffffffc020711e:	96668693          	addi	a3,a3,-1690 # ffffffffc020da80 <etext+0x22bc>
ffffffffc0207122:	00005617          	auipc	a2,0x5
ffffffffc0207126:	ade60613          	addi	a2,a2,-1314 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020712a:	4da00593          	li	a1,1242
ffffffffc020712e:	00006517          	auipc	a0,0x6
ffffffffc0207132:	51a50513          	addi	a0,a0,1306 # ffffffffc020d648 <etext+0x1e84>
ffffffffc0207136:	b14f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc020713a <cpu_idle>:
ffffffffc020713a:	1141                	addi	sp,sp,-16
ffffffffc020713c:	e022                	sd	s0,0(sp)
ffffffffc020713e:	e406                	sd	ra,8(sp)
ffffffffc0207140:	0008f417          	auipc	s0,0x8f
ffffffffc0207144:	78840413          	addi	s0,s0,1928 # ffffffffc02968c8 <current>
ffffffffc0207148:	6018                	ld	a4,0(s0)
ffffffffc020714a:	6f1c                	ld	a5,24(a4)
ffffffffc020714c:	dffd                	beqz	a5,ffffffffc020714a <cpu_idle+0x10>
ffffffffc020714e:	356000ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc0207152:	bfdd                	j	ffffffffc0207148 <cpu_idle+0xe>

ffffffffc0207154 <lab6_set_priority>:
ffffffffc0207154:	1101                	addi	sp,sp,-32
ffffffffc0207156:	85aa                	mv	a1,a0
ffffffffc0207158:	e42a                	sd	a0,8(sp)
ffffffffc020715a:	00007517          	auipc	a0,0x7
ffffffffc020715e:	97650513          	addi	a0,a0,-1674 # ffffffffc020dad0 <etext+0x230c>
ffffffffc0207162:	ec06                	sd	ra,24(sp)
ffffffffc0207164:	842f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207168:	65a2                	ld	a1,8(sp)
ffffffffc020716a:	0008f717          	auipc	a4,0x8f
ffffffffc020716e:	75e73703          	ld	a4,1886(a4) # ffffffffc02968c8 <current>
ffffffffc0207172:	4785                	li	a5,1
ffffffffc0207174:	c191                	beqz	a1,ffffffffc0207178 <lab6_set_priority+0x24>
ffffffffc0207176:	87ae                	mv	a5,a1
ffffffffc0207178:	60e2                	ld	ra,24(sp)
ffffffffc020717a:	14f72223          	sw	a5,324(a4)
ffffffffc020717e:	6105                	addi	sp,sp,32
ffffffffc0207180:	8082                	ret

ffffffffc0207182 <do_sleep>:
ffffffffc0207182:	c531                	beqz	a0,ffffffffc02071ce <do_sleep+0x4c>
ffffffffc0207184:	7139                	addi	sp,sp,-64
ffffffffc0207186:	fc06                	sd	ra,56(sp)
ffffffffc0207188:	f822                	sd	s0,48(sp)
ffffffffc020718a:	100027f3          	csrr	a5,sstatus
ffffffffc020718e:	8b89                	andi	a5,a5,2
ffffffffc0207190:	e3a9                	bnez	a5,ffffffffc02071d2 <do_sleep+0x50>
ffffffffc0207192:	0008f797          	auipc	a5,0x8f
ffffffffc0207196:	7367b783          	ld	a5,1846(a5) # ffffffffc02968c8 <current>
ffffffffc020719a:	1014                	addi	a3,sp,32
ffffffffc020719c:	80000737          	lui	a4,0x80000
ffffffffc02071a0:	c82a                	sw	a0,16(sp)
ffffffffc02071a2:	f436                	sd	a3,40(sp)
ffffffffc02071a4:	f036                	sd	a3,32(sp)
ffffffffc02071a6:	ec3e                	sd	a5,24(sp)
ffffffffc02071a8:	4685                	li	a3,1
ffffffffc02071aa:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc02071ac:	0808                	addi	a0,sp,16
ffffffffc02071ae:	c394                	sw	a3,0(a5)
ffffffffc02071b0:	0ee7a623          	sw	a4,236(a5)
ffffffffc02071b4:	842a                	mv	s0,a0
ffffffffc02071b6:	3a4000ef          	jal	ffffffffc020755a <add_timer>
ffffffffc02071ba:	2ea000ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc02071be:	8522                	mv	a0,s0
ffffffffc02071c0:	460000ef          	jal	ffffffffc0207620 <del_timer>
ffffffffc02071c4:	70e2                	ld	ra,56(sp)
ffffffffc02071c6:	7442                	ld	s0,48(sp)
ffffffffc02071c8:	4501                	li	a0,0
ffffffffc02071ca:	6121                	addi	sp,sp,64
ffffffffc02071cc:	8082                	ret
ffffffffc02071ce:	4501                	li	a0,0
ffffffffc02071d0:	8082                	ret
ffffffffc02071d2:	e42a                	sd	a0,8(sp)
ffffffffc02071d4:	a05f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02071d8:	0008f797          	auipc	a5,0x8f
ffffffffc02071dc:	6f07b783          	ld	a5,1776(a5) # ffffffffc02968c8 <current>
ffffffffc02071e0:	6522                	ld	a0,8(sp)
ffffffffc02071e2:	1014                	addi	a3,sp,32
ffffffffc02071e4:	80000737          	lui	a4,0x80000
ffffffffc02071e8:	c82a                	sw	a0,16(sp)
ffffffffc02071ea:	f436                	sd	a3,40(sp)
ffffffffc02071ec:	f036                	sd	a3,32(sp)
ffffffffc02071ee:	ec3e                	sd	a5,24(sp)
ffffffffc02071f0:	4685                	li	a3,1
ffffffffc02071f2:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc02071f4:	0808                	addi	a0,sp,16
ffffffffc02071f6:	c394                	sw	a3,0(a5)
ffffffffc02071f8:	0ee7a623          	sw	a4,236(a5)
ffffffffc02071fc:	842a                	mv	s0,a0
ffffffffc02071fe:	35c000ef          	jal	ffffffffc020755a <add_timer>
ffffffffc0207202:	9d1f90ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0207206:	bf55                	j	ffffffffc02071ba <do_sleep+0x38>

ffffffffc0207208 <switch_to>:
ffffffffc0207208:	00153023          	sd	ra,0(a0)
ffffffffc020720c:	00253423          	sd	sp,8(a0)
ffffffffc0207210:	e900                	sd	s0,16(a0)
ffffffffc0207212:	ed04                	sd	s1,24(a0)
ffffffffc0207214:	03253023          	sd	s2,32(a0)
ffffffffc0207218:	03353423          	sd	s3,40(a0)
ffffffffc020721c:	03453823          	sd	s4,48(a0)
ffffffffc0207220:	03553c23          	sd	s5,56(a0)
ffffffffc0207224:	05653023          	sd	s6,64(a0)
ffffffffc0207228:	05753423          	sd	s7,72(a0)
ffffffffc020722c:	05853823          	sd	s8,80(a0)
ffffffffc0207230:	05953c23          	sd	s9,88(a0)
ffffffffc0207234:	07a53023          	sd	s10,96(a0)
ffffffffc0207238:	07b53423          	sd	s11,104(a0)
ffffffffc020723c:	0005b083          	ld	ra,0(a1)
ffffffffc0207240:	0085b103          	ld	sp,8(a1)
ffffffffc0207244:	6980                	ld	s0,16(a1)
ffffffffc0207246:	6d84                	ld	s1,24(a1)
ffffffffc0207248:	0205b903          	ld	s2,32(a1)
ffffffffc020724c:	0285b983          	ld	s3,40(a1)
ffffffffc0207250:	0305ba03          	ld	s4,48(a1)
ffffffffc0207254:	0385ba83          	ld	s5,56(a1)
ffffffffc0207258:	0405bb03          	ld	s6,64(a1)
ffffffffc020725c:	0485bb83          	ld	s7,72(a1)
ffffffffc0207260:	0505bc03          	ld	s8,80(a1)
ffffffffc0207264:	0585bc83          	ld	s9,88(a1)
ffffffffc0207268:	0605bd03          	ld	s10,96(a1)
ffffffffc020726c:	0685bd83          	ld	s11,104(a1)
ffffffffc0207270:	8082                	ret

ffffffffc0207272 <RR_init>:
ffffffffc0207272:	e508                	sd	a0,8(a0)
ffffffffc0207274:	e108                	sd	a0,0(a0)
ffffffffc0207276:	00052823          	sw	zero,16(a0)
ffffffffc020727a:	8082                	ret

ffffffffc020727c <RR_pick_next>:
ffffffffc020727c:	651c                	ld	a5,8(a0)
ffffffffc020727e:	00f50563          	beq	a0,a5,ffffffffc0207288 <RR_pick_next+0xc>
ffffffffc0207282:	ef078513          	addi	a0,a5,-272
ffffffffc0207286:	8082                	ret
ffffffffc0207288:	4501                	li	a0,0
ffffffffc020728a:	8082                	ret

ffffffffc020728c <RR_proc_tick>:
ffffffffc020728c:	1205a783          	lw	a5,288(a1)
ffffffffc0207290:	00f05563          	blez	a5,ffffffffc020729a <RR_proc_tick+0xe>
ffffffffc0207294:	37fd                	addiw	a5,a5,-1
ffffffffc0207296:	12f5a023          	sw	a5,288(a1)
ffffffffc020729a:	e399                	bnez	a5,ffffffffc02072a0 <RR_proc_tick+0x14>
ffffffffc020729c:	4785                	li	a5,1
ffffffffc020729e:	ed9c                	sd	a5,24(a1)
ffffffffc02072a0:	8082                	ret

ffffffffc02072a2 <RR_dequeue>:
ffffffffc02072a2:	1185b703          	ld	a4,280(a1)
ffffffffc02072a6:	11058793          	addi	a5,a1,272
ffffffffc02072aa:	02e78263          	beq	a5,a4,ffffffffc02072ce <RR_dequeue+0x2c>
ffffffffc02072ae:	1085b683          	ld	a3,264(a1)
ffffffffc02072b2:	00a69e63          	bne	a3,a0,ffffffffc02072ce <RR_dequeue+0x2c>
ffffffffc02072b6:	1105b503          	ld	a0,272(a1)
ffffffffc02072ba:	4a90                	lw	a2,16(a3)
ffffffffc02072bc:	e518                	sd	a4,8(a0)
ffffffffc02072be:	e308                	sd	a0,0(a4)
ffffffffc02072c0:	10f5bc23          	sd	a5,280(a1)
ffffffffc02072c4:	10f5b823          	sd	a5,272(a1)
ffffffffc02072c8:	367d                	addiw	a2,a2,-1
ffffffffc02072ca:	ca90                	sw	a2,16(a3)
ffffffffc02072cc:	8082                	ret
ffffffffc02072ce:	1141                	addi	sp,sp,-16
ffffffffc02072d0:	00007697          	auipc	a3,0x7
ffffffffc02072d4:	81868693          	addi	a3,a3,-2024 # ffffffffc020dae8 <etext+0x2324>
ffffffffc02072d8:	00005617          	auipc	a2,0x5
ffffffffc02072dc:	92860613          	addi	a2,a2,-1752 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02072e0:	03c00593          	li	a1,60
ffffffffc02072e4:	00007517          	auipc	a0,0x7
ffffffffc02072e8:	83c50513          	addi	a0,a0,-1988 # ffffffffc020db20 <etext+0x235c>
ffffffffc02072ec:	e406                	sd	ra,8(sp)
ffffffffc02072ee:	95cf90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02072f2 <RR_enqueue>:
ffffffffc02072f2:	1185b703          	ld	a4,280(a1)
ffffffffc02072f6:	11058793          	addi	a5,a1,272
ffffffffc02072fa:	02e79d63          	bne	a5,a4,ffffffffc0207334 <RR_enqueue+0x42>
ffffffffc02072fe:	6118                	ld	a4,0(a0)
ffffffffc0207300:	1205a683          	lw	a3,288(a1)
ffffffffc0207304:	e11c                	sd	a5,0(a0)
ffffffffc0207306:	e71c                	sd	a5,8(a4)
ffffffffc0207308:	10e5b823          	sd	a4,272(a1)
ffffffffc020730c:	10a5bc23          	sd	a0,280(a1)
ffffffffc0207310:	495c                	lw	a5,20(a0)
ffffffffc0207312:	ea89                	bnez	a3,ffffffffc0207324 <RR_enqueue+0x32>
ffffffffc0207314:	12f5a023          	sw	a5,288(a1)
ffffffffc0207318:	491c                	lw	a5,16(a0)
ffffffffc020731a:	10a5b423          	sd	a0,264(a1)
ffffffffc020731e:	2785                	addiw	a5,a5,1
ffffffffc0207320:	c91c                	sw	a5,16(a0)
ffffffffc0207322:	8082                	ret
ffffffffc0207324:	fed7c8e3          	blt	a5,a3,ffffffffc0207314 <RR_enqueue+0x22>
ffffffffc0207328:	491c                	lw	a5,16(a0)
ffffffffc020732a:	10a5b423          	sd	a0,264(a1)
ffffffffc020732e:	2785                	addiw	a5,a5,1
ffffffffc0207330:	c91c                	sw	a5,16(a0)
ffffffffc0207332:	8082                	ret
ffffffffc0207334:	1141                	addi	sp,sp,-16
ffffffffc0207336:	00007697          	auipc	a3,0x7
ffffffffc020733a:	80a68693          	addi	a3,a3,-2038 # ffffffffc020db40 <etext+0x237c>
ffffffffc020733e:	00005617          	auipc	a2,0x5
ffffffffc0207342:	8c260613          	addi	a2,a2,-1854 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207346:	02800593          	li	a1,40
ffffffffc020734a:	00006517          	auipc	a0,0x6
ffffffffc020734e:	7d650513          	addi	a0,a0,2006 # ffffffffc020db20 <etext+0x235c>
ffffffffc0207352:	e406                	sd	ra,8(sp)
ffffffffc0207354:	8f6f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207358 <sched_init>:
ffffffffc0207358:	0008a797          	auipc	a5,0x8a
ffffffffc020735c:	cc878793          	addi	a5,a5,-824 # ffffffffc0291020 <default_sched_class>
ffffffffc0207360:	1141                	addi	sp,sp,-16
ffffffffc0207362:	6794                	ld	a3,8(a5)
ffffffffc0207364:	0008f717          	auipc	a4,0x8f
ffffffffc0207368:	58f73223          	sd	a5,1412(a4) # ffffffffc02968e8 <sched_class>
ffffffffc020736c:	e406                	sd	ra,8(sp)
ffffffffc020736e:	0008e797          	auipc	a5,0x8e
ffffffffc0207372:	48278793          	addi	a5,a5,1154 # ffffffffc02957f0 <timer_list>
ffffffffc0207376:	0008e717          	auipc	a4,0x8e
ffffffffc020737a:	45a70713          	addi	a4,a4,1114 # ffffffffc02957d0 <__rq>
ffffffffc020737e:	4615                	li	a2,5
ffffffffc0207380:	e79c                	sd	a5,8(a5)
ffffffffc0207382:	e39c                	sd	a5,0(a5)
ffffffffc0207384:	853a                	mv	a0,a4
ffffffffc0207386:	cb50                	sw	a2,20(a4)
ffffffffc0207388:	0008f797          	auipc	a5,0x8f
ffffffffc020738c:	54e7bc23          	sd	a4,1368(a5) # ffffffffc02968e0 <rq>
ffffffffc0207390:	9682                	jalr	a3
ffffffffc0207392:	0008f797          	auipc	a5,0x8f
ffffffffc0207396:	5567b783          	ld	a5,1366(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020739a:	60a2                	ld	ra,8(sp)
ffffffffc020739c:	00006517          	auipc	a0,0x6
ffffffffc02073a0:	7d450513          	addi	a0,a0,2004 # ffffffffc020db70 <etext+0x23ac>
ffffffffc02073a4:	638c                	ld	a1,0(a5)
ffffffffc02073a6:	0141                	addi	sp,sp,16
ffffffffc02073a8:	dfff806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc02073ac <wakeup_proc>:
ffffffffc02073ac:	4118                	lw	a4,0(a0)
ffffffffc02073ae:	1101                	addi	sp,sp,-32
ffffffffc02073b0:	ec06                	sd	ra,24(sp)
ffffffffc02073b2:	478d                	li	a5,3
ffffffffc02073b4:	0cf70863          	beq	a4,a5,ffffffffc0207484 <wakeup_proc+0xd8>
ffffffffc02073b8:	85aa                	mv	a1,a0
ffffffffc02073ba:	100027f3          	csrr	a5,sstatus
ffffffffc02073be:	8b89                	andi	a5,a5,2
ffffffffc02073c0:	e3b1                	bnez	a5,ffffffffc0207404 <wakeup_proc+0x58>
ffffffffc02073c2:	4789                	li	a5,2
ffffffffc02073c4:	08f70563          	beq	a4,a5,ffffffffc020744e <wakeup_proc+0xa2>
ffffffffc02073c8:	0008f717          	auipc	a4,0x8f
ffffffffc02073cc:	50073703          	ld	a4,1280(a4) # ffffffffc02968c8 <current>
ffffffffc02073d0:	0e052623          	sw	zero,236(a0)
ffffffffc02073d4:	c11c                	sw	a5,0(a0)
ffffffffc02073d6:	02e50463          	beq	a0,a4,ffffffffc02073fe <wakeup_proc+0x52>
ffffffffc02073da:	0008f797          	auipc	a5,0x8f
ffffffffc02073de:	4fe7b783          	ld	a5,1278(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02073e2:	00f50e63          	beq	a0,a5,ffffffffc02073fe <wakeup_proc+0x52>
ffffffffc02073e6:	0008f797          	auipc	a5,0x8f
ffffffffc02073ea:	5027b783          	ld	a5,1282(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02073ee:	60e2                	ld	ra,24(sp)
ffffffffc02073f0:	0008f517          	auipc	a0,0x8f
ffffffffc02073f4:	4f053503          	ld	a0,1264(a0) # ffffffffc02968e0 <rq>
ffffffffc02073f8:	6b9c                	ld	a5,16(a5)
ffffffffc02073fa:	6105                	addi	sp,sp,32
ffffffffc02073fc:	8782                	jr	a5
ffffffffc02073fe:	60e2                	ld	ra,24(sp)
ffffffffc0207400:	6105                	addi	sp,sp,32
ffffffffc0207402:	8082                	ret
ffffffffc0207404:	e42a                	sd	a0,8(sp)
ffffffffc0207406:	fd2f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020740a:	65a2                	ld	a1,8(sp)
ffffffffc020740c:	4789                	li	a5,2
ffffffffc020740e:	4198                	lw	a4,0(a1)
ffffffffc0207410:	04f70d63          	beq	a4,a5,ffffffffc020746a <wakeup_proc+0xbe>
ffffffffc0207414:	0008f717          	auipc	a4,0x8f
ffffffffc0207418:	4b473703          	ld	a4,1204(a4) # ffffffffc02968c8 <current>
ffffffffc020741c:	0e05a623          	sw	zero,236(a1)
ffffffffc0207420:	c19c                	sw	a5,0(a1)
ffffffffc0207422:	02e58263          	beq	a1,a4,ffffffffc0207446 <wakeup_proc+0x9a>
ffffffffc0207426:	0008f797          	auipc	a5,0x8f
ffffffffc020742a:	4b27b783          	ld	a5,1202(a5) # ffffffffc02968d8 <idleproc>
ffffffffc020742e:	00f58c63          	beq	a1,a5,ffffffffc0207446 <wakeup_proc+0x9a>
ffffffffc0207432:	0008f797          	auipc	a5,0x8f
ffffffffc0207436:	4b67b783          	ld	a5,1206(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020743a:	0008f517          	auipc	a0,0x8f
ffffffffc020743e:	4a653503          	ld	a0,1190(a0) # ffffffffc02968e0 <rq>
ffffffffc0207442:	6b9c                	ld	a5,16(a5)
ffffffffc0207444:	9782                	jalr	a5
ffffffffc0207446:	60e2                	ld	ra,24(sp)
ffffffffc0207448:	6105                	addi	sp,sp,32
ffffffffc020744a:	f88f906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc020744e:	60e2                	ld	ra,24(sp)
ffffffffc0207450:	00006617          	auipc	a2,0x6
ffffffffc0207454:	77060613          	addi	a2,a2,1904 # ffffffffc020dbc0 <etext+0x23fc>
ffffffffc0207458:	05200593          	li	a1,82
ffffffffc020745c:	00006517          	auipc	a0,0x6
ffffffffc0207460:	74c50513          	addi	a0,a0,1868 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc0207464:	6105                	addi	sp,sp,32
ffffffffc0207466:	84ef906f          	j	ffffffffc02004b4 <__warn>
ffffffffc020746a:	00006617          	auipc	a2,0x6
ffffffffc020746e:	75660613          	addi	a2,a2,1878 # ffffffffc020dbc0 <etext+0x23fc>
ffffffffc0207472:	05200593          	li	a1,82
ffffffffc0207476:	00006517          	auipc	a0,0x6
ffffffffc020747a:	73250513          	addi	a0,a0,1842 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc020747e:	836f90ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207482:	b7d1                	j	ffffffffc0207446 <wakeup_proc+0x9a>
ffffffffc0207484:	00006697          	auipc	a3,0x6
ffffffffc0207488:	70468693          	addi	a3,a3,1796 # ffffffffc020db88 <etext+0x23c4>
ffffffffc020748c:	00004617          	auipc	a2,0x4
ffffffffc0207490:	77460613          	addi	a2,a2,1908 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207494:	04300593          	li	a1,67
ffffffffc0207498:	00006517          	auipc	a0,0x6
ffffffffc020749c:	71050513          	addi	a0,a0,1808 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc02074a0:	fabf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02074a4 <schedule>:
ffffffffc02074a4:	7139                	addi	sp,sp,-64
ffffffffc02074a6:	fc06                	sd	ra,56(sp)
ffffffffc02074a8:	f822                	sd	s0,48(sp)
ffffffffc02074aa:	f426                	sd	s1,40(sp)
ffffffffc02074ac:	f04a                	sd	s2,32(sp)
ffffffffc02074ae:	ec4e                	sd	s3,24(sp)
ffffffffc02074b0:	100027f3          	csrr	a5,sstatus
ffffffffc02074b4:	8b89                	andi	a5,a5,2
ffffffffc02074b6:	4981                	li	s3,0
ffffffffc02074b8:	efc9                	bnez	a5,ffffffffc0207552 <schedule+0xae>
ffffffffc02074ba:	0008f417          	auipc	s0,0x8f
ffffffffc02074be:	40e40413          	addi	s0,s0,1038 # ffffffffc02968c8 <current>
ffffffffc02074c2:	600c                	ld	a1,0(s0)
ffffffffc02074c4:	4789                	li	a5,2
ffffffffc02074c6:	0008f497          	auipc	s1,0x8f
ffffffffc02074ca:	41a48493          	addi	s1,s1,1050 # ffffffffc02968e0 <rq>
ffffffffc02074ce:	4198                	lw	a4,0(a1)
ffffffffc02074d0:	0005bc23          	sd	zero,24(a1)
ffffffffc02074d4:	0008f917          	auipc	s2,0x8f
ffffffffc02074d8:	41490913          	addi	s2,s2,1044 # ffffffffc02968e8 <sched_class>
ffffffffc02074dc:	04f70f63          	beq	a4,a5,ffffffffc020753a <schedule+0x96>
ffffffffc02074e0:	00093783          	ld	a5,0(s2)
ffffffffc02074e4:	6088                	ld	a0,0(s1)
ffffffffc02074e6:	739c                	ld	a5,32(a5)
ffffffffc02074e8:	9782                	jalr	a5
ffffffffc02074ea:	85aa                	mv	a1,a0
ffffffffc02074ec:	c131                	beqz	a0,ffffffffc0207530 <schedule+0x8c>
ffffffffc02074ee:	00093783          	ld	a5,0(s2)
ffffffffc02074f2:	6088                	ld	a0,0(s1)
ffffffffc02074f4:	e42e                	sd	a1,8(sp)
ffffffffc02074f6:	6f9c                	ld	a5,24(a5)
ffffffffc02074f8:	9782                	jalr	a5
ffffffffc02074fa:	65a2                	ld	a1,8(sp)
ffffffffc02074fc:	459c                	lw	a5,8(a1)
ffffffffc02074fe:	6018                	ld	a4,0(s0)
ffffffffc0207500:	2785                	addiw	a5,a5,1
ffffffffc0207502:	c59c                	sw	a5,8(a1)
ffffffffc0207504:	00b70563          	beq	a4,a1,ffffffffc020750e <schedule+0x6a>
ffffffffc0207508:	852e                	mv	a0,a1
ffffffffc020750a:	f5cfe0ef          	jal	ffffffffc0205c66 <proc_run>
ffffffffc020750e:	00099963          	bnez	s3,ffffffffc0207520 <schedule+0x7c>
ffffffffc0207512:	70e2                	ld	ra,56(sp)
ffffffffc0207514:	7442                	ld	s0,48(sp)
ffffffffc0207516:	74a2                	ld	s1,40(sp)
ffffffffc0207518:	7902                	ld	s2,32(sp)
ffffffffc020751a:	69e2                	ld	s3,24(sp)
ffffffffc020751c:	6121                	addi	sp,sp,64
ffffffffc020751e:	8082                	ret
ffffffffc0207520:	7442                	ld	s0,48(sp)
ffffffffc0207522:	70e2                	ld	ra,56(sp)
ffffffffc0207524:	74a2                	ld	s1,40(sp)
ffffffffc0207526:	7902                	ld	s2,32(sp)
ffffffffc0207528:	69e2                	ld	s3,24(sp)
ffffffffc020752a:	6121                	addi	sp,sp,64
ffffffffc020752c:	ea6f906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207530:	0008f597          	auipc	a1,0x8f
ffffffffc0207534:	3a85b583          	ld	a1,936(a1) # ffffffffc02968d8 <idleproc>
ffffffffc0207538:	b7d1                	j	ffffffffc02074fc <schedule+0x58>
ffffffffc020753a:	0008f797          	auipc	a5,0x8f
ffffffffc020753e:	39e7b783          	ld	a5,926(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207542:	f8f58fe3          	beq	a1,a5,ffffffffc02074e0 <schedule+0x3c>
ffffffffc0207546:	00093783          	ld	a5,0(s2)
ffffffffc020754a:	6088                	ld	a0,0(s1)
ffffffffc020754c:	6b9c                	ld	a5,16(a5)
ffffffffc020754e:	9782                	jalr	a5
ffffffffc0207550:	bf41                	j	ffffffffc02074e0 <schedule+0x3c>
ffffffffc0207552:	e86f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207556:	4985                	li	s3,1
ffffffffc0207558:	b78d                	j	ffffffffc02074ba <schedule+0x16>

ffffffffc020755a <add_timer>:
ffffffffc020755a:	1101                	addi	sp,sp,-32
ffffffffc020755c:	ec06                	sd	ra,24(sp)
ffffffffc020755e:	100027f3          	csrr	a5,sstatus
ffffffffc0207562:	8b89                	andi	a5,a5,2
ffffffffc0207564:	4801                	li	a6,0
ffffffffc0207566:	e7bd                	bnez	a5,ffffffffc02075d4 <add_timer+0x7a>
ffffffffc0207568:	4118                	lw	a4,0(a0)
ffffffffc020756a:	cb3d                	beqz	a4,ffffffffc02075e0 <add_timer+0x86>
ffffffffc020756c:	651c                	ld	a5,8(a0)
ffffffffc020756e:	cbad                	beqz	a5,ffffffffc02075e0 <add_timer+0x86>
ffffffffc0207570:	6d1c                	ld	a5,24(a0)
ffffffffc0207572:	01050593          	addi	a1,a0,16
ffffffffc0207576:	08f59563          	bne	a1,a5,ffffffffc0207600 <add_timer+0xa6>
ffffffffc020757a:	0008e617          	auipc	a2,0x8e
ffffffffc020757e:	27660613          	addi	a2,a2,630 # ffffffffc02957f0 <timer_list>
ffffffffc0207582:	661c                	ld	a5,8(a2)
ffffffffc0207584:	00c79863          	bne	a5,a2,ffffffffc0207594 <add_timer+0x3a>
ffffffffc0207588:	a805                	j	ffffffffc02075b8 <add_timer+0x5e>
ffffffffc020758a:	679c                	ld	a5,8(a5)
ffffffffc020758c:	9f15                	subw	a4,a4,a3
ffffffffc020758e:	c118                	sw	a4,0(a0)
ffffffffc0207590:	02c78463          	beq	a5,a2,ffffffffc02075b8 <add_timer+0x5e>
ffffffffc0207594:	ff07a683          	lw	a3,-16(a5)
ffffffffc0207598:	fed779e3          	bgeu	a4,a3,ffffffffc020758a <add_timer+0x30>
ffffffffc020759c:	9e99                	subw	a3,a3,a4
ffffffffc020759e:	6398                	ld	a4,0(a5)
ffffffffc02075a0:	fed7a823          	sw	a3,-16(a5)
ffffffffc02075a4:	e38c                	sd	a1,0(a5)
ffffffffc02075a6:	e70c                	sd	a1,8(a4)
ffffffffc02075a8:	e918                	sd	a4,16(a0)
ffffffffc02075aa:	ed1c                	sd	a5,24(a0)
ffffffffc02075ac:	02080163          	beqz	a6,ffffffffc02075ce <add_timer+0x74>
ffffffffc02075b0:	60e2                	ld	ra,24(sp)
ffffffffc02075b2:	6105                	addi	sp,sp,32
ffffffffc02075b4:	e1ef906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc02075b8:	0008e797          	auipc	a5,0x8e
ffffffffc02075bc:	23878793          	addi	a5,a5,568 # ffffffffc02957f0 <timer_list>
ffffffffc02075c0:	6398                	ld	a4,0(a5)
ffffffffc02075c2:	e38c                	sd	a1,0(a5)
ffffffffc02075c4:	e70c                	sd	a1,8(a4)
ffffffffc02075c6:	e918                	sd	a4,16(a0)
ffffffffc02075c8:	ed1c                	sd	a5,24(a0)
ffffffffc02075ca:	fe0813e3          	bnez	a6,ffffffffc02075b0 <add_timer+0x56>
ffffffffc02075ce:	60e2                	ld	ra,24(sp)
ffffffffc02075d0:	6105                	addi	sp,sp,32
ffffffffc02075d2:	8082                	ret
ffffffffc02075d4:	e42a                	sd	a0,8(sp)
ffffffffc02075d6:	e02f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02075da:	6522                	ld	a0,8(sp)
ffffffffc02075dc:	4805                	li	a6,1
ffffffffc02075de:	b769                	j	ffffffffc0207568 <add_timer+0xe>
ffffffffc02075e0:	00006697          	auipc	a3,0x6
ffffffffc02075e4:	60068693          	addi	a3,a3,1536 # ffffffffc020dbe0 <etext+0x241c>
ffffffffc02075e8:	00004617          	auipc	a2,0x4
ffffffffc02075ec:	61860613          	addi	a2,a2,1560 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02075f0:	07a00593          	li	a1,122
ffffffffc02075f4:	00006517          	auipc	a0,0x6
ffffffffc02075f8:	5b450513          	addi	a0,a0,1460 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc02075fc:	e4ff80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207600:	00006697          	auipc	a3,0x6
ffffffffc0207604:	61068693          	addi	a3,a3,1552 # ffffffffc020dc10 <etext+0x244c>
ffffffffc0207608:	00004617          	auipc	a2,0x4
ffffffffc020760c:	5f860613          	addi	a2,a2,1528 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207610:	07b00593          	li	a1,123
ffffffffc0207614:	00006517          	auipc	a0,0x6
ffffffffc0207618:	59450513          	addi	a0,a0,1428 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc020761c:	e2ff80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207620 <del_timer>:
ffffffffc0207620:	100027f3          	csrr	a5,sstatus
ffffffffc0207624:	8b89                	andi	a5,a5,2
ffffffffc0207626:	ef95                	bnez	a5,ffffffffc0207662 <del_timer+0x42>
ffffffffc0207628:	6d1c                	ld	a5,24(a0)
ffffffffc020762a:	01050713          	addi	a4,a0,16
ffffffffc020762e:	4601                	li	a2,0
ffffffffc0207630:	02f70863          	beq	a4,a5,ffffffffc0207660 <del_timer+0x40>
ffffffffc0207634:	0008e597          	auipc	a1,0x8e
ffffffffc0207638:	1bc58593          	addi	a1,a1,444 # ffffffffc02957f0 <timer_list>
ffffffffc020763c:	4114                	lw	a3,0(a0)
ffffffffc020763e:	00b78863          	beq	a5,a1,ffffffffc020764e <del_timer+0x2e>
ffffffffc0207642:	c691                	beqz	a3,ffffffffc020764e <del_timer+0x2e>
ffffffffc0207644:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207648:	9ead                	addw	a3,a3,a1
ffffffffc020764a:	fed7a823          	sw	a3,-16(a5)
ffffffffc020764e:	6914                	ld	a3,16(a0)
ffffffffc0207650:	e69c                	sd	a5,8(a3)
ffffffffc0207652:	e394                	sd	a3,0(a5)
ffffffffc0207654:	ed18                	sd	a4,24(a0)
ffffffffc0207656:	e918                	sd	a4,16(a0)
ffffffffc0207658:	e211                	bnez	a2,ffffffffc020765c <del_timer+0x3c>
ffffffffc020765a:	8082                	ret
ffffffffc020765c:	d76f906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207660:	8082                	ret
ffffffffc0207662:	1101                	addi	sp,sp,-32
ffffffffc0207664:	e42a                	sd	a0,8(sp)
ffffffffc0207666:	ec06                	sd	ra,24(sp)
ffffffffc0207668:	d70f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020766c:	6522                	ld	a0,8(sp)
ffffffffc020766e:	4605                	li	a2,1
ffffffffc0207670:	6d1c                	ld	a5,24(a0)
ffffffffc0207672:	01050713          	addi	a4,a0,16
ffffffffc0207676:	02f70863          	beq	a4,a5,ffffffffc02076a6 <del_timer+0x86>
ffffffffc020767a:	0008e597          	auipc	a1,0x8e
ffffffffc020767e:	17658593          	addi	a1,a1,374 # ffffffffc02957f0 <timer_list>
ffffffffc0207682:	4114                	lw	a3,0(a0)
ffffffffc0207684:	00b78863          	beq	a5,a1,ffffffffc0207694 <del_timer+0x74>
ffffffffc0207688:	c691                	beqz	a3,ffffffffc0207694 <del_timer+0x74>
ffffffffc020768a:	ff07a583          	lw	a1,-16(a5)
ffffffffc020768e:	9ead                	addw	a3,a3,a1
ffffffffc0207690:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207694:	6914                	ld	a3,16(a0)
ffffffffc0207696:	e69c                	sd	a5,8(a3)
ffffffffc0207698:	e394                	sd	a3,0(a5)
ffffffffc020769a:	ed18                	sd	a4,24(a0)
ffffffffc020769c:	e918                	sd	a4,16(a0)
ffffffffc020769e:	e601                	bnez	a2,ffffffffc02076a6 <del_timer+0x86>
ffffffffc02076a0:	60e2                	ld	ra,24(sp)
ffffffffc02076a2:	6105                	addi	sp,sp,32
ffffffffc02076a4:	8082                	ret
ffffffffc02076a6:	60e2                	ld	ra,24(sp)
ffffffffc02076a8:	6105                	addi	sp,sp,32
ffffffffc02076aa:	d28f906f          	j	ffffffffc0200bd2 <intr_enable>

ffffffffc02076ae <run_timer_list>:
ffffffffc02076ae:	7179                	addi	sp,sp,-48
ffffffffc02076b0:	f406                	sd	ra,40(sp)
ffffffffc02076b2:	f022                	sd	s0,32(sp)
ffffffffc02076b4:	e44e                	sd	s3,8(sp)
ffffffffc02076b6:	e052                	sd	s4,0(sp)
ffffffffc02076b8:	100027f3          	csrr	a5,sstatus
ffffffffc02076bc:	8b89                	andi	a5,a5,2
ffffffffc02076be:	0e079b63          	bnez	a5,ffffffffc02077b4 <run_timer_list+0x106>
ffffffffc02076c2:	0008e997          	auipc	s3,0x8e
ffffffffc02076c6:	12e98993          	addi	s3,s3,302 # ffffffffc02957f0 <timer_list>
ffffffffc02076ca:	0089b403          	ld	s0,8(s3)
ffffffffc02076ce:	4a01                	li	s4,0
ffffffffc02076d0:	0d340463          	beq	s0,s3,ffffffffc0207798 <run_timer_list+0xea>
ffffffffc02076d4:	ff042783          	lw	a5,-16(s0)
ffffffffc02076d8:	12078763          	beqz	a5,ffffffffc0207806 <run_timer_list+0x158>
ffffffffc02076dc:	e84a                	sd	s2,16(sp)
ffffffffc02076de:	37fd                	addiw	a5,a5,-1
ffffffffc02076e0:	fef42823          	sw	a5,-16(s0)
ffffffffc02076e4:	ff040913          	addi	s2,s0,-16
ffffffffc02076e8:	efb1                	bnez	a5,ffffffffc0207744 <run_timer_list+0x96>
ffffffffc02076ea:	ec26                	sd	s1,24(sp)
ffffffffc02076ec:	a005                	j	ffffffffc020770c <run_timer_list+0x5e>
ffffffffc02076ee:	0e07dc63          	bgez	a5,ffffffffc02077e6 <run_timer_list+0x138>
ffffffffc02076f2:	8526                	mv	a0,s1
ffffffffc02076f4:	cb9ff0ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc02076f8:	854a                	mv	a0,s2
ffffffffc02076fa:	f27ff0ef          	jal	ffffffffc0207620 <del_timer>
ffffffffc02076fe:	05340263          	beq	s0,s3,ffffffffc0207742 <run_timer_list+0x94>
ffffffffc0207702:	ff042783          	lw	a5,-16(s0)
ffffffffc0207706:	ff040913          	addi	s2,s0,-16
ffffffffc020770a:	ef85                	bnez	a5,ffffffffc0207742 <run_timer_list+0x94>
ffffffffc020770c:	00893483          	ld	s1,8(s2)
ffffffffc0207710:	6400                	ld	s0,8(s0)
ffffffffc0207712:	0ec4a783          	lw	a5,236(s1)
ffffffffc0207716:	ffe1                	bnez	a5,ffffffffc02076ee <run_timer_list+0x40>
ffffffffc0207718:	40d4                	lw	a3,4(s1)
ffffffffc020771a:	00006617          	auipc	a2,0x6
ffffffffc020771e:	55e60613          	addi	a2,a2,1374 # ffffffffc020dc78 <etext+0x24b4>
ffffffffc0207722:	0ba00593          	li	a1,186
ffffffffc0207726:	00006517          	auipc	a0,0x6
ffffffffc020772a:	48250513          	addi	a0,a0,1154 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc020772e:	d87f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207732:	8526                	mv	a0,s1
ffffffffc0207734:	c79ff0ef          	jal	ffffffffc02073ac <wakeup_proc>
ffffffffc0207738:	854a                	mv	a0,s2
ffffffffc020773a:	ee7ff0ef          	jal	ffffffffc0207620 <del_timer>
ffffffffc020773e:	fd3412e3          	bne	s0,s3,ffffffffc0207702 <run_timer_list+0x54>
ffffffffc0207742:	64e2                	ld	s1,24(sp)
ffffffffc0207744:	0008f597          	auipc	a1,0x8f
ffffffffc0207748:	1845b583          	ld	a1,388(a1) # ffffffffc02968c8 <current>
ffffffffc020774c:	cd85                	beqz	a1,ffffffffc0207784 <run_timer_list+0xd6>
ffffffffc020774e:	0008f797          	auipc	a5,0x8f
ffffffffc0207752:	18a7b783          	ld	a5,394(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207756:	02f58563          	beq	a1,a5,ffffffffc0207780 <run_timer_list+0xd2>
ffffffffc020775a:	6942                	ld	s2,16(sp)
ffffffffc020775c:	0008f797          	auipc	a5,0x8f
ffffffffc0207760:	18c7b783          	ld	a5,396(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207764:	0008f517          	auipc	a0,0x8f
ffffffffc0207768:	17c53503          	ld	a0,380(a0) # ffffffffc02968e0 <rq>
ffffffffc020776c:	779c                	ld	a5,40(a5)
ffffffffc020776e:	9782                	jalr	a5
ffffffffc0207770:	000a1d63          	bnez	s4,ffffffffc020778a <run_timer_list+0xdc>
ffffffffc0207774:	70a2                	ld	ra,40(sp)
ffffffffc0207776:	7402                	ld	s0,32(sp)
ffffffffc0207778:	69a2                	ld	s3,8(sp)
ffffffffc020777a:	6a02                	ld	s4,0(sp)
ffffffffc020777c:	6145                	addi	sp,sp,48
ffffffffc020777e:	8082                	ret
ffffffffc0207780:	4785                	li	a5,1
ffffffffc0207782:	ed9c                	sd	a5,24(a1)
ffffffffc0207784:	6942                	ld	s2,16(sp)
ffffffffc0207786:	fe0a07e3          	beqz	s4,ffffffffc0207774 <run_timer_list+0xc6>
ffffffffc020778a:	7402                	ld	s0,32(sp)
ffffffffc020778c:	70a2                	ld	ra,40(sp)
ffffffffc020778e:	69a2                	ld	s3,8(sp)
ffffffffc0207790:	6a02                	ld	s4,0(sp)
ffffffffc0207792:	6145                	addi	sp,sp,48
ffffffffc0207794:	c3ef906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207798:	0008f597          	auipc	a1,0x8f
ffffffffc020779c:	1305b583          	ld	a1,304(a1) # ffffffffc02968c8 <current>
ffffffffc02077a0:	d9f1                	beqz	a1,ffffffffc0207774 <run_timer_list+0xc6>
ffffffffc02077a2:	0008f797          	auipc	a5,0x8f
ffffffffc02077a6:	1367b783          	ld	a5,310(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02077aa:	fab799e3          	bne	a5,a1,ffffffffc020775c <run_timer_list+0xae>
ffffffffc02077ae:	4705                	li	a4,1
ffffffffc02077b0:	ef98                	sd	a4,24(a5)
ffffffffc02077b2:	b7c9                	j	ffffffffc0207774 <run_timer_list+0xc6>
ffffffffc02077b4:	0008e997          	auipc	s3,0x8e
ffffffffc02077b8:	03c98993          	addi	s3,s3,60 # ffffffffc02957f0 <timer_list>
ffffffffc02077bc:	c1cf90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02077c0:	0089b403          	ld	s0,8(s3)
ffffffffc02077c4:	4a05                	li	s4,1
ffffffffc02077c6:	f13417e3          	bne	s0,s3,ffffffffc02076d4 <run_timer_list+0x26>
ffffffffc02077ca:	0008f597          	auipc	a1,0x8f
ffffffffc02077ce:	0fe5b583          	ld	a1,254(a1) # ffffffffc02968c8 <current>
ffffffffc02077d2:	ddc5                	beqz	a1,ffffffffc020778a <run_timer_list+0xdc>
ffffffffc02077d4:	0008f797          	auipc	a5,0x8f
ffffffffc02077d8:	1047b783          	ld	a5,260(a5) # ffffffffc02968d8 <idleproc>
ffffffffc02077dc:	f8f590e3          	bne	a1,a5,ffffffffc020775c <run_timer_list+0xae>
ffffffffc02077e0:	0145bc23          	sd	s4,24(a1)
ffffffffc02077e4:	b75d                	j	ffffffffc020778a <run_timer_list+0xdc>
ffffffffc02077e6:	00006697          	auipc	a3,0x6
ffffffffc02077ea:	46a68693          	addi	a3,a3,1130 # ffffffffc020dc50 <etext+0x248c>
ffffffffc02077ee:	00004617          	auipc	a2,0x4
ffffffffc02077f2:	41260613          	addi	a2,a2,1042 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02077f6:	0b600593          	li	a1,182
ffffffffc02077fa:	00006517          	auipc	a0,0x6
ffffffffc02077fe:	3ae50513          	addi	a0,a0,942 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc0207802:	c49f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207806:	00006697          	auipc	a3,0x6
ffffffffc020780a:	43268693          	addi	a3,a3,1074 # ffffffffc020dc38 <etext+0x2474>
ffffffffc020780e:	00004617          	auipc	a2,0x4
ffffffffc0207812:	3f260613          	addi	a2,a2,1010 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207816:	0ae00593          	li	a1,174
ffffffffc020781a:	00006517          	auipc	a0,0x6
ffffffffc020781e:	38e50513          	addi	a0,a0,910 # ffffffffc020dba8 <etext+0x23e4>
ffffffffc0207822:	ec26                	sd	s1,24(sp)
ffffffffc0207824:	e84a                	sd	s2,16(sp)
ffffffffc0207826:	c25f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020782a <sys_getpid>:
ffffffffc020782a:	0008f797          	auipc	a5,0x8f
ffffffffc020782e:	09e7b783          	ld	a5,158(a5) # ffffffffc02968c8 <current>
ffffffffc0207832:	43c8                	lw	a0,4(a5)
ffffffffc0207834:	8082                	ret

ffffffffc0207836 <sys_pgdir>:
ffffffffc0207836:	4501                	li	a0,0
ffffffffc0207838:	8082                	ret

ffffffffc020783a <sys_gettime>:
ffffffffc020783a:	0008f797          	auipc	a5,0x8f
ffffffffc020783e:	0367b783          	ld	a5,54(a5) # ffffffffc0296870 <ticks>
ffffffffc0207842:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207846:	9d3d                	addw	a0,a0,a5
ffffffffc0207848:	0015151b          	slliw	a0,a0,0x1
ffffffffc020784c:	8082                	ret

ffffffffc020784e <sys_lab6_set_priority>:
ffffffffc020784e:	4108                	lw	a0,0(a0)
ffffffffc0207850:	1141                	addi	sp,sp,-16
ffffffffc0207852:	e406                	sd	ra,8(sp)
ffffffffc0207854:	901ff0ef          	jal	ffffffffc0207154 <lab6_set_priority>
ffffffffc0207858:	60a2                	ld	ra,8(sp)
ffffffffc020785a:	4501                	li	a0,0
ffffffffc020785c:	0141                	addi	sp,sp,16
ffffffffc020785e:	8082                	ret

ffffffffc0207860 <sys_dup>:
ffffffffc0207860:	450c                	lw	a1,8(a0)
ffffffffc0207862:	4108                	lw	a0,0(a0)
ffffffffc0207864:	a52fe06f          	j	ffffffffc0205ab6 <sysfile_dup>

ffffffffc0207868 <sys_getdirentry>:
ffffffffc0207868:	650c                	ld	a1,8(a0)
ffffffffc020786a:	4108                	lw	a0,0(a0)
ffffffffc020786c:	95afe06f          	j	ffffffffc02059c6 <sysfile_getdirentry>

ffffffffc0207870 <sys_getcwd>:
ffffffffc0207870:	650c                	ld	a1,8(a0)
ffffffffc0207872:	6108                	ld	a0,0(a0)
ffffffffc0207874:	8a8fe06f          	j	ffffffffc020591c <sysfile_getcwd>

ffffffffc0207878 <sys_fsync>:
ffffffffc0207878:	4108                	lw	a0,0(a0)
ffffffffc020787a:	89efe06f          	j	ffffffffc0205918 <sysfile_fsync>

ffffffffc020787e <sys_fstat>:
ffffffffc020787e:	650c                	ld	a1,8(a0)
ffffffffc0207880:	4108                	lw	a0,0(a0)
ffffffffc0207882:	80efe06f          	j	ffffffffc0205890 <sysfile_fstat>

ffffffffc0207886 <sys_seek>:
ffffffffc0207886:	4910                	lw	a2,16(a0)
ffffffffc0207888:	650c                	ld	a1,8(a0)
ffffffffc020788a:	4108                	lw	a0,0(a0)
ffffffffc020788c:	800fe06f          	j	ffffffffc020588c <sysfile_seek>

ffffffffc0207890 <sys_write>:
ffffffffc0207890:	6910                	ld	a2,16(a0)
ffffffffc0207892:	650c                	ld	a1,8(a0)
ffffffffc0207894:	4108                	lw	a0,0(a0)
ffffffffc0207896:	ec5fd06f          	j	ffffffffc020575a <sysfile_write>

ffffffffc020789a <sys_read>:
ffffffffc020789a:	6910                	ld	a2,16(a0)
ffffffffc020789c:	650c                	ld	a1,8(a0)
ffffffffc020789e:	4108                	lw	a0,0(a0)
ffffffffc02078a0:	d6ffd06f          	j	ffffffffc020560e <sysfile_read>

ffffffffc02078a4 <sys_close>:
ffffffffc02078a4:	4108                	lw	a0,0(a0)
ffffffffc02078a6:	d65fd06f          	j	ffffffffc020560a <sysfile_close>

ffffffffc02078aa <sys_open>:
ffffffffc02078aa:	450c                	lw	a1,8(a0)
ffffffffc02078ac:	6108                	ld	a0,0(a0)
ffffffffc02078ae:	d27fd06f          	j	ffffffffc02055d4 <sysfile_open>

ffffffffc02078b2 <sys_putc>:
ffffffffc02078b2:	4108                	lw	a0,0(a0)
ffffffffc02078b4:	1141                	addi	sp,sp,-16
ffffffffc02078b6:	e406                	sd	ra,8(sp)
ffffffffc02078b8:	929f80ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02078bc:	60a2                	ld	ra,8(sp)
ffffffffc02078be:	4501                	li	a0,0
ffffffffc02078c0:	0141                	addi	sp,sp,16
ffffffffc02078c2:	8082                	ret

ffffffffc02078c4 <sys_kill>:
ffffffffc02078c4:	4108                	lw	a0,0(a0)
ffffffffc02078c6:	e28ff06f          	j	ffffffffc0206eee <do_kill>

ffffffffc02078ca <sys_sleep>:
ffffffffc02078ca:	4108                	lw	a0,0(a0)
ffffffffc02078cc:	8b7ff06f          	j	ffffffffc0207182 <do_sleep>

ffffffffc02078d0 <sys_yield>:
ffffffffc02078d0:	dd4ff06f          	j	ffffffffc0206ea4 <do_yield>

ffffffffc02078d4 <sys_exec>:
ffffffffc02078d4:	6910                	ld	a2,16(a0)
ffffffffc02078d6:	450c                	lw	a1,8(a0)
ffffffffc02078d8:	6108                	ld	a0,0(a0)
ffffffffc02078da:	cfffe06f          	j	ffffffffc02065d8 <do_execve>

ffffffffc02078de <sys_wait>:
ffffffffc02078de:	650c                	ld	a1,8(a0)
ffffffffc02078e0:	4108                	lw	a0,0(a0)
ffffffffc02078e2:	dd2ff06f          	j	ffffffffc0206eb4 <do_wait>

ffffffffc02078e6 <sys_fork>:
ffffffffc02078e6:	0008f797          	auipc	a5,0x8f
ffffffffc02078ea:	fe27b783          	ld	a5,-30(a5) # ffffffffc02968c8 <current>
ffffffffc02078ee:	4501                	li	a0,0
ffffffffc02078f0:	73d0                	ld	a2,160(a5)
ffffffffc02078f2:	6a0c                	ld	a1,16(a2)
ffffffffc02078f4:	bd8fe06f          	j	ffffffffc0205ccc <do_fork>

ffffffffc02078f8 <sys_exit>:
ffffffffc02078f8:	4108                	lw	a0,0(a0)
ffffffffc02078fa:	84dfe06f          	j	ffffffffc0206146 <do_exit>

ffffffffc02078fe <syscall>:
ffffffffc02078fe:	0008f697          	auipc	a3,0x8f
ffffffffc0207902:	fca6b683          	ld	a3,-54(a3) # ffffffffc02968c8 <current>
ffffffffc0207906:	715d                	addi	sp,sp,-80
ffffffffc0207908:	e0a2                	sd	s0,64(sp)
ffffffffc020790a:	72c0                	ld	s0,160(a3)
ffffffffc020790c:	e486                	sd	ra,72(sp)
ffffffffc020790e:	0ff00793          	li	a5,255
ffffffffc0207912:	4834                	lw	a3,80(s0)
ffffffffc0207914:	02d7ec63          	bltu	a5,a3,ffffffffc020794c <syscall+0x4e>
ffffffffc0207918:	00007797          	auipc	a5,0x7
ffffffffc020791c:	60878793          	addi	a5,a5,1544 # ffffffffc020ef20 <syscalls>
ffffffffc0207920:	00369613          	slli	a2,a3,0x3
ffffffffc0207924:	97b2                	add	a5,a5,a2
ffffffffc0207926:	639c                	ld	a5,0(a5)
ffffffffc0207928:	c395                	beqz	a5,ffffffffc020794c <syscall+0x4e>
ffffffffc020792a:	7028                	ld	a0,96(s0)
ffffffffc020792c:	742c                	ld	a1,104(s0)
ffffffffc020792e:	7830                	ld	a2,112(s0)
ffffffffc0207930:	7c34                	ld	a3,120(s0)
ffffffffc0207932:	6c38                	ld	a4,88(s0)
ffffffffc0207934:	f02a                	sd	a0,32(sp)
ffffffffc0207936:	f42e                	sd	a1,40(sp)
ffffffffc0207938:	f832                	sd	a2,48(sp)
ffffffffc020793a:	fc36                	sd	a3,56(sp)
ffffffffc020793c:	ec3a                	sd	a4,24(sp)
ffffffffc020793e:	0828                	addi	a0,sp,24
ffffffffc0207940:	9782                	jalr	a5
ffffffffc0207942:	60a6                	ld	ra,72(sp)
ffffffffc0207944:	e828                	sd	a0,80(s0)
ffffffffc0207946:	6406                	ld	s0,64(sp)
ffffffffc0207948:	6161                	addi	sp,sp,80
ffffffffc020794a:	8082                	ret
ffffffffc020794c:	8522                	mv	a0,s0
ffffffffc020794e:	e436                	sd	a3,8(sp)
ffffffffc0207950:	d9cf90ef          	jal	ffffffffc0200eec <print_trapframe>
ffffffffc0207954:	0008f797          	auipc	a5,0x8f
ffffffffc0207958:	f747b783          	ld	a5,-140(a5) # ffffffffc02968c8 <current>
ffffffffc020795c:	66a2                	ld	a3,8(sp)
ffffffffc020795e:	00006617          	auipc	a2,0x6
ffffffffc0207962:	33a60613          	addi	a2,a2,826 # ffffffffc020dc98 <etext+0x24d4>
ffffffffc0207966:	43d8                	lw	a4,4(a5)
ffffffffc0207968:	0d800593          	li	a1,216
ffffffffc020796c:	0b478793          	addi	a5,a5,180
ffffffffc0207970:	00006517          	auipc	a0,0x6
ffffffffc0207974:	35850513          	addi	a0,a0,856 # ffffffffc020dcc8 <etext+0x2504>
ffffffffc0207978:	ad3f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020797c <__alloc_inode>:
ffffffffc020797c:	1141                	addi	sp,sp,-16
ffffffffc020797e:	e022                	sd	s0,0(sp)
ffffffffc0207980:	842a                	mv	s0,a0
ffffffffc0207982:	07800513          	li	a0,120
ffffffffc0207986:	e406                	sd	ra,8(sp)
ffffffffc0207988:	e38fa0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020798c:	c111                	beqz	a0,ffffffffc0207990 <__alloc_inode+0x14>
ffffffffc020798e:	cd20                	sw	s0,88(a0)
ffffffffc0207990:	60a2                	ld	ra,8(sp)
ffffffffc0207992:	6402                	ld	s0,0(sp)
ffffffffc0207994:	0141                	addi	sp,sp,16
ffffffffc0207996:	8082                	ret

ffffffffc0207998 <inode_init>:
ffffffffc0207998:	4785                	li	a5,1
ffffffffc020799a:	06052023          	sw	zero,96(a0)
ffffffffc020799e:	f92c                	sd	a1,112(a0)
ffffffffc02079a0:	f530                	sd	a2,104(a0)
ffffffffc02079a2:	cd7c                	sw	a5,92(a0)
ffffffffc02079a4:	8082                	ret

ffffffffc02079a6 <inode_kill>:
ffffffffc02079a6:	4d78                	lw	a4,92(a0)
ffffffffc02079a8:	1141                	addi	sp,sp,-16
ffffffffc02079aa:	e406                	sd	ra,8(sp)
ffffffffc02079ac:	e719                	bnez	a4,ffffffffc02079ba <inode_kill+0x14>
ffffffffc02079ae:	513c                	lw	a5,96(a0)
ffffffffc02079b0:	e78d                	bnez	a5,ffffffffc02079da <inode_kill+0x34>
ffffffffc02079b2:	60a2                	ld	ra,8(sp)
ffffffffc02079b4:	0141                	addi	sp,sp,16
ffffffffc02079b6:	eb0fa06f          	j	ffffffffc0202066 <kfree>
ffffffffc02079ba:	00006697          	auipc	a3,0x6
ffffffffc02079be:	32668693          	addi	a3,a3,806 # ffffffffc020dce0 <etext+0x251c>
ffffffffc02079c2:	00004617          	auipc	a2,0x4
ffffffffc02079c6:	23e60613          	addi	a2,a2,574 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02079ca:	02900593          	li	a1,41
ffffffffc02079ce:	00006517          	auipc	a0,0x6
ffffffffc02079d2:	33250513          	addi	a0,a0,818 # ffffffffc020dd00 <etext+0x253c>
ffffffffc02079d6:	a75f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02079da:	00006697          	auipc	a3,0x6
ffffffffc02079de:	33e68693          	addi	a3,a3,830 # ffffffffc020dd18 <etext+0x2554>
ffffffffc02079e2:	00004617          	auipc	a2,0x4
ffffffffc02079e6:	21e60613          	addi	a2,a2,542 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02079ea:	02a00593          	li	a1,42
ffffffffc02079ee:	00006517          	auipc	a0,0x6
ffffffffc02079f2:	31250513          	addi	a0,a0,786 # ffffffffc020dd00 <etext+0x253c>
ffffffffc02079f6:	a55f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02079fa <inode_ref_inc>:
ffffffffc02079fa:	4d7c                	lw	a5,92(a0)
ffffffffc02079fc:	2785                	addiw	a5,a5,1
ffffffffc02079fe:	cd7c                	sw	a5,92(a0)
ffffffffc0207a00:	853e                	mv	a0,a5
ffffffffc0207a02:	8082                	ret

ffffffffc0207a04 <inode_open_inc>:
ffffffffc0207a04:	513c                	lw	a5,96(a0)
ffffffffc0207a06:	2785                	addiw	a5,a5,1
ffffffffc0207a08:	d13c                	sw	a5,96(a0)
ffffffffc0207a0a:	853e                	mv	a0,a5
ffffffffc0207a0c:	8082                	ret

ffffffffc0207a0e <inode_check>:
ffffffffc0207a0e:	1141                	addi	sp,sp,-16
ffffffffc0207a10:	e406                	sd	ra,8(sp)
ffffffffc0207a12:	c91d                	beqz	a0,ffffffffc0207a48 <inode_check+0x3a>
ffffffffc0207a14:	793c                	ld	a5,112(a0)
ffffffffc0207a16:	cb8d                	beqz	a5,ffffffffc0207a48 <inode_check+0x3a>
ffffffffc0207a18:	6398                	ld	a4,0(a5)
ffffffffc0207a1a:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207a1e:	0786                	slli	a5,a5,0x1
ffffffffc0207a20:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207a24:	08f71263          	bne	a4,a5,ffffffffc0207aa8 <inode_check+0x9a>
ffffffffc0207a28:	4d74                	lw	a3,92(a0)
ffffffffc0207a2a:	5138                	lw	a4,96(a0)
ffffffffc0207a2c:	04e6ce63          	blt	a3,a4,ffffffffc0207a88 <inode_check+0x7a>
ffffffffc0207a30:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0207a34:	ebb1                	bnez	a5,ffffffffc0207a88 <inode_check+0x7a>
ffffffffc0207a36:	67c1                	lui	a5,0x10
ffffffffc0207a38:	17fd                	addi	a5,a5,-1 # ffff <_binary_bin_swap_img_size+0x82ff>
ffffffffc0207a3a:	02d7c763          	blt	a5,a3,ffffffffc0207a68 <inode_check+0x5a>
ffffffffc0207a3e:	02e7c563          	blt	a5,a4,ffffffffc0207a68 <inode_check+0x5a>
ffffffffc0207a42:	60a2                	ld	ra,8(sp)
ffffffffc0207a44:	0141                	addi	sp,sp,16
ffffffffc0207a46:	8082                	ret
ffffffffc0207a48:	00006697          	auipc	a3,0x6
ffffffffc0207a4c:	2f068693          	addi	a3,a3,752 # ffffffffc020dd38 <etext+0x2574>
ffffffffc0207a50:	00004617          	auipc	a2,0x4
ffffffffc0207a54:	1b060613          	addi	a2,a2,432 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207a58:	06e00593          	li	a1,110
ffffffffc0207a5c:	00006517          	auipc	a0,0x6
ffffffffc0207a60:	2a450513          	addi	a0,a0,676 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207a64:	9e7f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207a68:	00006697          	auipc	a3,0x6
ffffffffc0207a6c:	35068693          	addi	a3,a3,848 # ffffffffc020ddb8 <etext+0x25f4>
ffffffffc0207a70:	00004617          	auipc	a2,0x4
ffffffffc0207a74:	19060613          	addi	a2,a2,400 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207a78:	07200593          	li	a1,114
ffffffffc0207a7c:	00006517          	auipc	a0,0x6
ffffffffc0207a80:	28450513          	addi	a0,a0,644 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207a84:	9c7f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207a88:	00006697          	auipc	a3,0x6
ffffffffc0207a8c:	30068693          	addi	a3,a3,768 # ffffffffc020dd88 <etext+0x25c4>
ffffffffc0207a90:	00004617          	auipc	a2,0x4
ffffffffc0207a94:	17060613          	addi	a2,a2,368 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207a98:	07100593          	li	a1,113
ffffffffc0207a9c:	00006517          	auipc	a0,0x6
ffffffffc0207aa0:	26450513          	addi	a0,a0,612 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207aa4:	9a7f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207aa8:	00006697          	auipc	a3,0x6
ffffffffc0207aac:	2b868693          	addi	a3,a3,696 # ffffffffc020dd60 <etext+0x259c>
ffffffffc0207ab0:	00004617          	auipc	a2,0x4
ffffffffc0207ab4:	15060613          	addi	a2,a2,336 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207ab8:	06f00593          	li	a1,111
ffffffffc0207abc:	00006517          	auipc	a0,0x6
ffffffffc0207ac0:	24450513          	addi	a0,a0,580 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207ac4:	987f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207ac8 <inode_ref_dec>:
ffffffffc0207ac8:	4d7c                	lw	a5,92(a0)
ffffffffc0207aca:	7179                	addi	sp,sp,-48
ffffffffc0207acc:	f406                	sd	ra,40(sp)
ffffffffc0207ace:	06f05b63          	blez	a5,ffffffffc0207b44 <inode_ref_dec+0x7c>
ffffffffc0207ad2:	37fd                	addiw	a5,a5,-1
ffffffffc0207ad4:	cd7c                	sw	a5,92(a0)
ffffffffc0207ad6:	e795                	bnez	a5,ffffffffc0207b02 <inode_ref_dec+0x3a>
ffffffffc0207ad8:	7934                	ld	a3,112(a0)
ffffffffc0207ada:	c6a9                	beqz	a3,ffffffffc0207b24 <inode_ref_dec+0x5c>
ffffffffc0207adc:	66b4                	ld	a3,72(a3)
ffffffffc0207ade:	c2b9                	beqz	a3,ffffffffc0207b24 <inode_ref_dec+0x5c>
ffffffffc0207ae0:	00006597          	auipc	a1,0x6
ffffffffc0207ae4:	38858593          	addi	a1,a1,904 # ffffffffc020de68 <etext+0x26a4>
ffffffffc0207ae8:	e83e                	sd	a5,16(sp)
ffffffffc0207aea:	ec2a                	sd	a0,24(sp)
ffffffffc0207aec:	e436                	sd	a3,8(sp)
ffffffffc0207aee:	f21ff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0207af2:	6562                	ld	a0,24(sp)
ffffffffc0207af4:	66a2                	ld	a3,8(sp)
ffffffffc0207af6:	9682                	jalr	a3
ffffffffc0207af8:	00f50713          	addi	a4,a0,15
ffffffffc0207afc:	67c2                	ld	a5,16(sp)
ffffffffc0207afe:	c311                	beqz	a4,ffffffffc0207b02 <inode_ref_dec+0x3a>
ffffffffc0207b00:	e509                	bnez	a0,ffffffffc0207b0a <inode_ref_dec+0x42>
ffffffffc0207b02:	70a2                	ld	ra,40(sp)
ffffffffc0207b04:	853e                	mv	a0,a5
ffffffffc0207b06:	6145                	addi	sp,sp,48
ffffffffc0207b08:	8082                	ret
ffffffffc0207b0a:	85aa                	mv	a1,a0
ffffffffc0207b0c:	00006517          	auipc	a0,0x6
ffffffffc0207b10:	36450513          	addi	a0,a0,868 # ffffffffc020de70 <etext+0x26ac>
ffffffffc0207b14:	e43e                	sd	a5,8(sp)
ffffffffc0207b16:	e90f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207b1a:	67a2                	ld	a5,8(sp)
ffffffffc0207b1c:	70a2                	ld	ra,40(sp)
ffffffffc0207b1e:	853e                	mv	a0,a5
ffffffffc0207b20:	6145                	addi	sp,sp,48
ffffffffc0207b22:	8082                	ret
ffffffffc0207b24:	00006697          	auipc	a3,0x6
ffffffffc0207b28:	2f468693          	addi	a3,a3,756 # ffffffffc020de18 <etext+0x2654>
ffffffffc0207b2c:	00004617          	auipc	a2,0x4
ffffffffc0207b30:	0d460613          	addi	a2,a2,212 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207b34:	04400593          	li	a1,68
ffffffffc0207b38:	00006517          	auipc	a0,0x6
ffffffffc0207b3c:	1c850513          	addi	a0,a0,456 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207b40:	90bf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207b44:	00006697          	auipc	a3,0x6
ffffffffc0207b48:	2b468693          	addi	a3,a3,692 # ffffffffc020ddf8 <etext+0x2634>
ffffffffc0207b4c:	00004617          	auipc	a2,0x4
ffffffffc0207b50:	0b460613          	addi	a2,a2,180 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207b54:	03f00593          	li	a1,63
ffffffffc0207b58:	00006517          	auipc	a0,0x6
ffffffffc0207b5c:	1a850513          	addi	a0,a0,424 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207b60:	8ebf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207b64 <inode_open_dec>:
ffffffffc0207b64:	513c                	lw	a5,96(a0)
ffffffffc0207b66:	7179                	addi	sp,sp,-48
ffffffffc0207b68:	f406                	sd	ra,40(sp)
ffffffffc0207b6a:	06f05863          	blez	a5,ffffffffc0207bda <inode_open_dec+0x76>
ffffffffc0207b6e:	37fd                	addiw	a5,a5,-1
ffffffffc0207b70:	d13c                	sw	a5,96(a0)
ffffffffc0207b72:	e39d                	bnez	a5,ffffffffc0207b98 <inode_open_dec+0x34>
ffffffffc0207b74:	7934                	ld	a3,112(a0)
ffffffffc0207b76:	c2b1                	beqz	a3,ffffffffc0207bba <inode_open_dec+0x56>
ffffffffc0207b78:	6a94                	ld	a3,16(a3)
ffffffffc0207b7a:	c2a1                	beqz	a3,ffffffffc0207bba <inode_open_dec+0x56>
ffffffffc0207b7c:	00006597          	auipc	a1,0x6
ffffffffc0207b80:	38458593          	addi	a1,a1,900 # ffffffffc020df00 <etext+0x273c>
ffffffffc0207b84:	e83e                	sd	a5,16(sp)
ffffffffc0207b86:	ec2a                	sd	a0,24(sp)
ffffffffc0207b88:	e436                	sd	a3,8(sp)
ffffffffc0207b8a:	e85ff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0207b8e:	6562                	ld	a0,24(sp)
ffffffffc0207b90:	66a2                	ld	a3,8(sp)
ffffffffc0207b92:	9682                	jalr	a3
ffffffffc0207b94:	67c2                	ld	a5,16(sp)
ffffffffc0207b96:	e509                	bnez	a0,ffffffffc0207ba0 <inode_open_dec+0x3c>
ffffffffc0207b98:	70a2                	ld	ra,40(sp)
ffffffffc0207b9a:	853e                	mv	a0,a5
ffffffffc0207b9c:	6145                	addi	sp,sp,48
ffffffffc0207b9e:	8082                	ret
ffffffffc0207ba0:	85aa                	mv	a1,a0
ffffffffc0207ba2:	00006517          	auipc	a0,0x6
ffffffffc0207ba6:	36650513          	addi	a0,a0,870 # ffffffffc020df08 <etext+0x2744>
ffffffffc0207baa:	e43e                	sd	a5,8(sp)
ffffffffc0207bac:	dfaf80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207bb0:	67a2                	ld	a5,8(sp)
ffffffffc0207bb2:	70a2                	ld	ra,40(sp)
ffffffffc0207bb4:	853e                	mv	a0,a5
ffffffffc0207bb6:	6145                	addi	sp,sp,48
ffffffffc0207bb8:	8082                	ret
ffffffffc0207bba:	00006697          	auipc	a3,0x6
ffffffffc0207bbe:	2f668693          	addi	a3,a3,758 # ffffffffc020deb0 <etext+0x26ec>
ffffffffc0207bc2:	00004617          	auipc	a2,0x4
ffffffffc0207bc6:	03e60613          	addi	a2,a2,62 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207bca:	06100593          	li	a1,97
ffffffffc0207bce:	00006517          	auipc	a0,0x6
ffffffffc0207bd2:	13250513          	addi	a0,a0,306 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207bd6:	875f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207bda:	00006697          	auipc	a3,0x6
ffffffffc0207bde:	2b668693          	addi	a3,a3,694 # ffffffffc020de90 <etext+0x26cc>
ffffffffc0207be2:	00004617          	auipc	a2,0x4
ffffffffc0207be6:	01e60613          	addi	a2,a2,30 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207bea:	05c00593          	li	a1,92
ffffffffc0207bee:	00006517          	auipc	a0,0x6
ffffffffc0207bf2:	11250513          	addi	a0,a0,274 # ffffffffc020dd00 <etext+0x253c>
ffffffffc0207bf6:	855f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207bfa <__alloc_fs>:
ffffffffc0207bfa:	1141                	addi	sp,sp,-16
ffffffffc0207bfc:	e022                	sd	s0,0(sp)
ffffffffc0207bfe:	842a                	mv	s0,a0
ffffffffc0207c00:	0d800513          	li	a0,216
ffffffffc0207c04:	e406                	sd	ra,8(sp)
ffffffffc0207c06:	bbafa0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0207c0a:	c119                	beqz	a0,ffffffffc0207c10 <__alloc_fs+0x16>
ffffffffc0207c0c:	0a852823          	sw	s0,176(a0)
ffffffffc0207c10:	60a2                	ld	ra,8(sp)
ffffffffc0207c12:	6402                	ld	s0,0(sp)
ffffffffc0207c14:	0141                	addi	sp,sp,16
ffffffffc0207c16:	8082                	ret

ffffffffc0207c18 <vfs_init>:
ffffffffc0207c18:	1141                	addi	sp,sp,-16
ffffffffc0207c1a:	4585                	li	a1,1
ffffffffc0207c1c:	0008e517          	auipc	a0,0x8e
ffffffffc0207c20:	be450513          	addi	a0,a0,-1052 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c24:	e406                	sd	ra,8(sp)
ffffffffc0207c26:	9c7fc0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc0207c2a:	60a2                	ld	ra,8(sp)
ffffffffc0207c2c:	0141                	addi	sp,sp,16
ffffffffc0207c2e:	a4b1                	j	ffffffffc0207e7a <vfs_devlist_init>

ffffffffc0207c30 <vfs_set_bootfs>:
ffffffffc0207c30:	7179                	addi	sp,sp,-48
ffffffffc0207c32:	f022                	sd	s0,32(sp)
ffffffffc0207c34:	f406                	sd	ra,40(sp)
ffffffffc0207c36:	ec02                	sd	zero,24(sp)
ffffffffc0207c38:	842a                	mv	s0,a0
ffffffffc0207c3a:	c515                	beqz	a0,ffffffffc0207c66 <vfs_set_bootfs+0x36>
ffffffffc0207c3c:	03a00593          	li	a1,58
ffffffffc0207c40:	30b030ef          	jal	ffffffffc020b74a <strchr>
ffffffffc0207c44:	c125                	beqz	a0,ffffffffc0207ca4 <vfs_set_bootfs+0x74>
ffffffffc0207c46:	00154783          	lbu	a5,1(a0)
ffffffffc0207c4a:	efa9                	bnez	a5,ffffffffc0207ca4 <vfs_set_bootfs+0x74>
ffffffffc0207c4c:	8522                	mv	a0,s0
ffffffffc0207c4e:	163000ef          	jal	ffffffffc02085b0 <vfs_chdir>
ffffffffc0207c52:	c509                	beqz	a0,ffffffffc0207c5c <vfs_set_bootfs+0x2c>
ffffffffc0207c54:	70a2                	ld	ra,40(sp)
ffffffffc0207c56:	7402                	ld	s0,32(sp)
ffffffffc0207c58:	6145                	addi	sp,sp,48
ffffffffc0207c5a:	8082                	ret
ffffffffc0207c5c:	0828                	addi	a0,sp,24
ffffffffc0207c5e:	05f000ef          	jal	ffffffffc02084bc <vfs_get_curdir>
ffffffffc0207c62:	f96d                	bnez	a0,ffffffffc0207c54 <vfs_set_bootfs+0x24>
ffffffffc0207c64:	6462                	ld	s0,24(sp)
ffffffffc0207c66:	0008e517          	auipc	a0,0x8e
ffffffffc0207c6a:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c6e:	989fc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0207c72:	0008f797          	auipc	a5,0x8f
ffffffffc0207c76:	c7e7b783          	ld	a5,-898(a5) # ffffffffc02968f0 <bootfs_node>
ffffffffc0207c7a:	0008e517          	auipc	a0,0x8e
ffffffffc0207c7e:	b8650513          	addi	a0,a0,-1146 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c82:	0008f717          	auipc	a4,0x8f
ffffffffc0207c86:	c6873723          	sd	s0,-914(a4) # ffffffffc02968f0 <bootfs_node>
ffffffffc0207c8a:	e43e                	sd	a5,8(sp)
ffffffffc0207c8c:	967fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207c90:	67a2                	ld	a5,8(sp)
ffffffffc0207c92:	c781                	beqz	a5,ffffffffc0207c9a <vfs_set_bootfs+0x6a>
ffffffffc0207c94:	853e                	mv	a0,a5
ffffffffc0207c96:	e33ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc0207c9a:	70a2                	ld	ra,40(sp)
ffffffffc0207c9c:	7402                	ld	s0,32(sp)
ffffffffc0207c9e:	4501                	li	a0,0
ffffffffc0207ca0:	6145                	addi	sp,sp,48
ffffffffc0207ca2:	8082                	ret
ffffffffc0207ca4:	5575                	li	a0,-3
ffffffffc0207ca6:	b77d                	j	ffffffffc0207c54 <vfs_set_bootfs+0x24>

ffffffffc0207ca8 <vfs_get_bootfs>:
ffffffffc0207ca8:	1101                	addi	sp,sp,-32
ffffffffc0207caa:	e426                	sd	s1,8(sp)
ffffffffc0207cac:	0008f497          	auipc	s1,0x8f
ffffffffc0207cb0:	c4448493          	addi	s1,s1,-956 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207cb4:	609c                	ld	a5,0(s1)
ffffffffc0207cb6:	ec06                	sd	ra,24(sp)
ffffffffc0207cb8:	c3b1                	beqz	a5,ffffffffc0207cfc <vfs_get_bootfs+0x54>
ffffffffc0207cba:	e822                	sd	s0,16(sp)
ffffffffc0207cbc:	842a                	mv	s0,a0
ffffffffc0207cbe:	0008e517          	auipc	a0,0x8e
ffffffffc0207cc2:	b4250513          	addi	a0,a0,-1214 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207cc6:	931fc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0207cca:	6084                	ld	s1,0(s1)
ffffffffc0207ccc:	c08d                	beqz	s1,ffffffffc0207cee <vfs_get_bootfs+0x46>
ffffffffc0207cce:	8526                	mv	a0,s1
ffffffffc0207cd0:	d2bff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc0207cd4:	0008e517          	auipc	a0,0x8e
ffffffffc0207cd8:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207cdc:	917fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207ce0:	60e2                	ld	ra,24(sp)
ffffffffc0207ce2:	e004                	sd	s1,0(s0)
ffffffffc0207ce4:	6442                	ld	s0,16(sp)
ffffffffc0207ce6:	64a2                	ld	s1,8(sp)
ffffffffc0207ce8:	4501                	li	a0,0
ffffffffc0207cea:	6105                	addi	sp,sp,32
ffffffffc0207cec:	8082                	ret
ffffffffc0207cee:	0008e517          	auipc	a0,0x8e
ffffffffc0207cf2:	b1250513          	addi	a0,a0,-1262 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207cf6:	8fdfc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207cfa:	6442                	ld	s0,16(sp)
ffffffffc0207cfc:	60e2                	ld	ra,24(sp)
ffffffffc0207cfe:	64a2                	ld	s1,8(sp)
ffffffffc0207d00:	5541                	li	a0,-16
ffffffffc0207d02:	6105                	addi	sp,sp,32
ffffffffc0207d04:	8082                	ret

ffffffffc0207d06 <vfs_do_add>:
ffffffffc0207d06:	7139                	addi	sp,sp,-64
ffffffffc0207d08:	fc06                	sd	ra,56(sp)
ffffffffc0207d0a:	f822                	sd	s0,48(sp)
ffffffffc0207d0c:	e852                	sd	s4,16(sp)
ffffffffc0207d0e:	e456                	sd	s5,8(sp)
ffffffffc0207d10:	e05a                	sd	s6,0(sp)
ffffffffc0207d12:	10050f63          	beqz	a0,ffffffffc0207e30 <vfs_do_add+0x12a>
ffffffffc0207d16:	00d5e7b3          	or	a5,a1,a3
ffffffffc0207d1a:	842a                	mv	s0,a0
ffffffffc0207d1c:	8a2e                	mv	s4,a1
ffffffffc0207d1e:	8b32                	mv	s6,a2
ffffffffc0207d20:	8ab6                	mv	s5,a3
ffffffffc0207d22:	cb89                	beqz	a5,ffffffffc0207d34 <vfs_do_add+0x2e>
ffffffffc0207d24:	0e058363          	beqz	a1,ffffffffc0207e0a <vfs_do_add+0x104>
ffffffffc0207d28:	4db8                	lw	a4,88(a1)
ffffffffc0207d2a:	6785                	lui	a5,0x1
ffffffffc0207d2c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207d30:	0cf71d63          	bne	a4,a5,ffffffffc0207e0a <vfs_do_add+0x104>
ffffffffc0207d34:	8522                	mv	a0,s0
ffffffffc0207d36:	173030ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc0207d3a:	47fd                	li	a5,31
ffffffffc0207d3c:	0ca7e263          	bltu	a5,a0,ffffffffc0207e00 <vfs_do_add+0xfa>
ffffffffc0207d40:	8522                	mv	a0,s0
ffffffffc0207d42:	f426                	sd	s1,40(sp)
ffffffffc0207d44:	caef80ef          	jal	ffffffffc02001f2 <strdup>
ffffffffc0207d48:	84aa                	mv	s1,a0
ffffffffc0207d4a:	cd4d                	beqz	a0,ffffffffc0207e04 <vfs_do_add+0xfe>
ffffffffc0207d4c:	03000513          	li	a0,48
ffffffffc0207d50:	ec4e                	sd	s3,24(sp)
ffffffffc0207d52:	a6efa0ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0207d56:	89aa                	mv	s3,a0
ffffffffc0207d58:	c935                	beqz	a0,ffffffffc0207dcc <vfs_do_add+0xc6>
ffffffffc0207d5a:	f04a                	sd	s2,32(sp)
ffffffffc0207d5c:	0008e517          	auipc	a0,0x8e
ffffffffc0207d60:	abc50513          	addi	a0,a0,-1348 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207d64:	0008e917          	auipc	s2,0x8e
ffffffffc0207d68:	acc90913          	addi	s2,s2,-1332 # ffffffffc0295830 <vdev_list>
ffffffffc0207d6c:	88bfc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0207d70:	844a                	mv	s0,s2
ffffffffc0207d72:	a039                	j	ffffffffc0207d80 <vfs_do_add+0x7a>
ffffffffc0207d74:	fe043503          	ld	a0,-32(s0)
ffffffffc0207d78:	85a6                	mv	a1,s1
ffffffffc0207d7a:	175030ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc0207d7e:	c52d                	beqz	a0,ffffffffc0207de8 <vfs_do_add+0xe2>
ffffffffc0207d80:	6400                	ld	s0,8(s0)
ffffffffc0207d82:	ff2419e3          	bne	s0,s2,ffffffffc0207d74 <vfs_do_add+0x6e>
ffffffffc0207d86:	6418                	ld	a4,8(s0)
ffffffffc0207d88:	02098793          	addi	a5,s3,32
ffffffffc0207d8c:	0099b023          	sd	s1,0(s3)
ffffffffc0207d90:	0149b423          	sd	s4,8(s3)
ffffffffc0207d94:	0159bc23          	sd	s5,24(s3)
ffffffffc0207d98:	0169b823          	sd	s6,16(s3)
ffffffffc0207d9c:	e31c                	sd	a5,0(a4)
ffffffffc0207d9e:	0289b023          	sd	s0,32(s3)
ffffffffc0207da2:	02e9b423          	sd	a4,40(s3)
ffffffffc0207da6:	0008e517          	auipc	a0,0x8e
ffffffffc0207daa:	a7250513          	addi	a0,a0,-1422 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207dae:	e41c                	sd	a5,8(s0)
ffffffffc0207db0:	843fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207db4:	74a2                	ld	s1,40(sp)
ffffffffc0207db6:	7902                	ld	s2,32(sp)
ffffffffc0207db8:	69e2                	ld	s3,24(sp)
ffffffffc0207dba:	4401                	li	s0,0
ffffffffc0207dbc:	70e2                	ld	ra,56(sp)
ffffffffc0207dbe:	8522                	mv	a0,s0
ffffffffc0207dc0:	7442                	ld	s0,48(sp)
ffffffffc0207dc2:	6a42                	ld	s4,16(sp)
ffffffffc0207dc4:	6aa2                	ld	s5,8(sp)
ffffffffc0207dc6:	6b02                	ld	s6,0(sp)
ffffffffc0207dc8:	6121                	addi	sp,sp,64
ffffffffc0207dca:	8082                	ret
ffffffffc0207dcc:	5471                	li	s0,-4
ffffffffc0207dce:	8526                	mv	a0,s1
ffffffffc0207dd0:	a96fa0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0207dd4:	70e2                	ld	ra,56(sp)
ffffffffc0207dd6:	8522                	mv	a0,s0
ffffffffc0207dd8:	7442                	ld	s0,48(sp)
ffffffffc0207dda:	74a2                	ld	s1,40(sp)
ffffffffc0207ddc:	69e2                	ld	s3,24(sp)
ffffffffc0207dde:	6a42                	ld	s4,16(sp)
ffffffffc0207de0:	6aa2                	ld	s5,8(sp)
ffffffffc0207de2:	6b02                	ld	s6,0(sp)
ffffffffc0207de4:	6121                	addi	sp,sp,64
ffffffffc0207de6:	8082                	ret
ffffffffc0207de8:	0008e517          	auipc	a0,0x8e
ffffffffc0207dec:	a3050513          	addi	a0,a0,-1488 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207df0:	803fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207df4:	854e                	mv	a0,s3
ffffffffc0207df6:	a70fa0ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0207dfa:	5425                	li	s0,-23
ffffffffc0207dfc:	7902                	ld	s2,32(sp)
ffffffffc0207dfe:	bfc1                	j	ffffffffc0207dce <vfs_do_add+0xc8>
ffffffffc0207e00:	5451                	li	s0,-12
ffffffffc0207e02:	bf6d                	j	ffffffffc0207dbc <vfs_do_add+0xb6>
ffffffffc0207e04:	74a2                	ld	s1,40(sp)
ffffffffc0207e06:	5471                	li	s0,-4
ffffffffc0207e08:	bf55                	j	ffffffffc0207dbc <vfs_do_add+0xb6>
ffffffffc0207e0a:	00006697          	auipc	a3,0x6
ffffffffc0207e0e:	14668693          	addi	a3,a3,326 # ffffffffc020df50 <etext+0x278c>
ffffffffc0207e12:	00004617          	auipc	a2,0x4
ffffffffc0207e16:	dee60613          	addi	a2,a2,-530 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207e1a:	08f00593          	li	a1,143
ffffffffc0207e1e:	00006517          	auipc	a0,0x6
ffffffffc0207e22:	11a50513          	addi	a0,a0,282 # ffffffffc020df38 <etext+0x2774>
ffffffffc0207e26:	f426                	sd	s1,40(sp)
ffffffffc0207e28:	f04a                	sd	s2,32(sp)
ffffffffc0207e2a:	ec4e                	sd	s3,24(sp)
ffffffffc0207e2c:	e1ef80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207e30:	00006697          	auipc	a3,0x6
ffffffffc0207e34:	0f868693          	addi	a3,a3,248 # ffffffffc020df28 <etext+0x2764>
ffffffffc0207e38:	00004617          	auipc	a2,0x4
ffffffffc0207e3c:	dc860613          	addi	a2,a2,-568 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207e40:	08e00593          	li	a1,142
ffffffffc0207e44:	00006517          	auipc	a0,0x6
ffffffffc0207e48:	0f450513          	addi	a0,a0,244 # ffffffffc020df38 <etext+0x2774>
ffffffffc0207e4c:	f426                	sd	s1,40(sp)
ffffffffc0207e4e:	f04a                	sd	s2,32(sp)
ffffffffc0207e50:	ec4e                	sd	s3,24(sp)
ffffffffc0207e52:	df8f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207e56 <find_mount.part.0>:
ffffffffc0207e56:	1141                	addi	sp,sp,-16
ffffffffc0207e58:	00006697          	auipc	a3,0x6
ffffffffc0207e5c:	0d068693          	addi	a3,a3,208 # ffffffffc020df28 <etext+0x2764>
ffffffffc0207e60:	00004617          	auipc	a2,0x4
ffffffffc0207e64:	da060613          	addi	a2,a2,-608 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207e68:	0cd00593          	li	a1,205
ffffffffc0207e6c:	00006517          	auipc	a0,0x6
ffffffffc0207e70:	0cc50513          	addi	a0,a0,204 # ffffffffc020df38 <etext+0x2774>
ffffffffc0207e74:	e406                	sd	ra,8(sp)
ffffffffc0207e76:	dd4f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207e7a <vfs_devlist_init>:
ffffffffc0207e7a:	0008e797          	auipc	a5,0x8e
ffffffffc0207e7e:	9b678793          	addi	a5,a5,-1610 # ffffffffc0295830 <vdev_list>
ffffffffc0207e82:	4585                	li	a1,1
ffffffffc0207e84:	0008e517          	auipc	a0,0x8e
ffffffffc0207e88:	99450513          	addi	a0,a0,-1644 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207e8c:	e79c                	sd	a5,8(a5)
ffffffffc0207e8e:	e39c                	sd	a5,0(a5)
ffffffffc0207e90:	f5cfc06f          	j	ffffffffc02045ec <sem_init>

ffffffffc0207e94 <vfs_cleanup>:
ffffffffc0207e94:	1101                	addi	sp,sp,-32
ffffffffc0207e96:	e426                	sd	s1,8(sp)
ffffffffc0207e98:	0008e497          	auipc	s1,0x8e
ffffffffc0207e9c:	99848493          	addi	s1,s1,-1640 # ffffffffc0295830 <vdev_list>
ffffffffc0207ea0:	649c                	ld	a5,8(s1)
ffffffffc0207ea2:	ec06                	sd	ra,24(sp)
ffffffffc0207ea4:	02978f63          	beq	a5,s1,ffffffffc0207ee2 <vfs_cleanup+0x4e>
ffffffffc0207ea8:	0008e517          	auipc	a0,0x8e
ffffffffc0207eac:	97050513          	addi	a0,a0,-1680 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207eb0:	e822                	sd	s0,16(sp)
ffffffffc0207eb2:	f44fc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0207eb6:	6480                	ld	s0,8(s1)
ffffffffc0207eb8:	00940b63          	beq	s0,s1,ffffffffc0207ece <vfs_cleanup+0x3a>
ffffffffc0207ebc:	ff043783          	ld	a5,-16(s0)
ffffffffc0207ec0:	853e                	mv	a0,a5
ffffffffc0207ec2:	c399                	beqz	a5,ffffffffc0207ec8 <vfs_cleanup+0x34>
ffffffffc0207ec4:	6bfc                	ld	a5,208(a5)
ffffffffc0207ec6:	9782                	jalr	a5
ffffffffc0207ec8:	6400                	ld	s0,8(s0)
ffffffffc0207eca:	fe9419e3          	bne	s0,s1,ffffffffc0207ebc <vfs_cleanup+0x28>
ffffffffc0207ece:	6442                	ld	s0,16(sp)
ffffffffc0207ed0:	60e2                	ld	ra,24(sp)
ffffffffc0207ed2:	64a2                	ld	s1,8(sp)
ffffffffc0207ed4:	0008e517          	auipc	a0,0x8e
ffffffffc0207ed8:	94450513          	addi	a0,a0,-1724 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207edc:	6105                	addi	sp,sp,32
ffffffffc0207ede:	f14fc06f          	j	ffffffffc02045f2 <up>
ffffffffc0207ee2:	60e2                	ld	ra,24(sp)
ffffffffc0207ee4:	64a2                	ld	s1,8(sp)
ffffffffc0207ee6:	6105                	addi	sp,sp,32
ffffffffc0207ee8:	8082                	ret

ffffffffc0207eea <vfs_get_root>:
ffffffffc0207eea:	7179                	addi	sp,sp,-48
ffffffffc0207eec:	f406                	sd	ra,40(sp)
ffffffffc0207eee:	c949                	beqz	a0,ffffffffc0207f80 <vfs_get_root+0x96>
ffffffffc0207ef0:	e84a                	sd	s2,16(sp)
ffffffffc0207ef2:	0008e917          	auipc	s2,0x8e
ffffffffc0207ef6:	93e90913          	addi	s2,s2,-1730 # ffffffffc0295830 <vdev_list>
ffffffffc0207efa:	00893783          	ld	a5,8(s2)
ffffffffc0207efe:	ec26                	sd	s1,24(sp)
ffffffffc0207f00:	07278e63          	beq	a5,s2,ffffffffc0207f7c <vfs_get_root+0x92>
ffffffffc0207f04:	e44e                	sd	s3,8(sp)
ffffffffc0207f06:	89aa                	mv	s3,a0
ffffffffc0207f08:	0008e517          	auipc	a0,0x8e
ffffffffc0207f0c:	91050513          	addi	a0,a0,-1776 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207f10:	f022                	sd	s0,32(sp)
ffffffffc0207f12:	e052                	sd	s4,0(sp)
ffffffffc0207f14:	844a                	mv	s0,s2
ffffffffc0207f16:	8a2e                	mv	s4,a1
ffffffffc0207f18:	edefc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0207f1c:	a801                	j	ffffffffc0207f2c <vfs_get_root+0x42>
ffffffffc0207f1e:	fe043583          	ld	a1,-32(s0)
ffffffffc0207f22:	854e                	mv	a0,s3
ffffffffc0207f24:	7ca030ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc0207f28:	84aa                	mv	s1,a0
ffffffffc0207f2a:	c505                	beqz	a0,ffffffffc0207f52 <vfs_get_root+0x68>
ffffffffc0207f2c:	6400                	ld	s0,8(s0)
ffffffffc0207f2e:	ff2418e3          	bne	s0,s2,ffffffffc0207f1e <vfs_get_root+0x34>
ffffffffc0207f32:	54cd                	li	s1,-13
ffffffffc0207f34:	0008e517          	auipc	a0,0x8e
ffffffffc0207f38:	8e450513          	addi	a0,a0,-1820 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0207f3c:	eb6fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0207f40:	7402                	ld	s0,32(sp)
ffffffffc0207f42:	69a2                	ld	s3,8(sp)
ffffffffc0207f44:	6a02                	ld	s4,0(sp)
ffffffffc0207f46:	70a2                	ld	ra,40(sp)
ffffffffc0207f48:	6942                	ld	s2,16(sp)
ffffffffc0207f4a:	8526                	mv	a0,s1
ffffffffc0207f4c:	64e2                	ld	s1,24(sp)
ffffffffc0207f4e:	6145                	addi	sp,sp,48
ffffffffc0207f50:	8082                	ret
ffffffffc0207f52:	ff043503          	ld	a0,-16(s0)
ffffffffc0207f56:	c519                	beqz	a0,ffffffffc0207f64 <vfs_get_root+0x7a>
ffffffffc0207f58:	617c                	ld	a5,192(a0)
ffffffffc0207f5a:	9782                	jalr	a5
ffffffffc0207f5c:	c519                	beqz	a0,ffffffffc0207f6a <vfs_get_root+0x80>
ffffffffc0207f5e:	00aa3023          	sd	a0,0(s4)
ffffffffc0207f62:	bfc9                	j	ffffffffc0207f34 <vfs_get_root+0x4a>
ffffffffc0207f64:	ff843783          	ld	a5,-8(s0)
ffffffffc0207f68:	c399                	beqz	a5,ffffffffc0207f6e <vfs_get_root+0x84>
ffffffffc0207f6a:	54c9                	li	s1,-14
ffffffffc0207f6c:	b7e1                	j	ffffffffc0207f34 <vfs_get_root+0x4a>
ffffffffc0207f6e:	fe843503          	ld	a0,-24(s0)
ffffffffc0207f72:	a89ff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc0207f76:	fe843503          	ld	a0,-24(s0)
ffffffffc0207f7a:	b7cd                	j	ffffffffc0207f5c <vfs_get_root+0x72>
ffffffffc0207f7c:	54cd                	li	s1,-13
ffffffffc0207f7e:	b7e1                	j	ffffffffc0207f46 <vfs_get_root+0x5c>
ffffffffc0207f80:	00006697          	auipc	a3,0x6
ffffffffc0207f84:	fa868693          	addi	a3,a3,-88 # ffffffffc020df28 <etext+0x2764>
ffffffffc0207f88:	00004617          	auipc	a2,0x4
ffffffffc0207f8c:	c7860613          	addi	a2,a2,-904 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207f90:	04500593          	li	a1,69
ffffffffc0207f94:	00006517          	auipc	a0,0x6
ffffffffc0207f98:	fa450513          	addi	a0,a0,-92 # ffffffffc020df38 <etext+0x2774>
ffffffffc0207f9c:	f022                	sd	s0,32(sp)
ffffffffc0207f9e:	ec26                	sd	s1,24(sp)
ffffffffc0207fa0:	e84a                	sd	s2,16(sp)
ffffffffc0207fa2:	e44e                	sd	s3,8(sp)
ffffffffc0207fa4:	e052                	sd	s4,0(sp)
ffffffffc0207fa6:	ca4f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207faa <vfs_get_devname>:
ffffffffc0207faa:	0008e697          	auipc	a3,0x8e
ffffffffc0207fae:	88668693          	addi	a3,a3,-1914 # ffffffffc0295830 <vdev_list>
ffffffffc0207fb2:	87b6                	mv	a5,a3
ffffffffc0207fb4:	e511                	bnez	a0,ffffffffc0207fc0 <vfs_get_devname+0x16>
ffffffffc0207fb6:	a829                	j	ffffffffc0207fd0 <vfs_get_devname+0x26>
ffffffffc0207fb8:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207fbc:	00a70763          	beq	a4,a0,ffffffffc0207fca <vfs_get_devname+0x20>
ffffffffc0207fc0:	679c                	ld	a5,8(a5)
ffffffffc0207fc2:	fed79be3          	bne	a5,a3,ffffffffc0207fb8 <vfs_get_devname+0xe>
ffffffffc0207fc6:	4501                	li	a0,0
ffffffffc0207fc8:	8082                	ret
ffffffffc0207fca:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207fce:	8082                	ret
ffffffffc0207fd0:	1141                	addi	sp,sp,-16
ffffffffc0207fd2:	00006697          	auipc	a3,0x6
ffffffffc0207fd6:	fde68693          	addi	a3,a3,-34 # ffffffffc020dfb0 <etext+0x27ec>
ffffffffc0207fda:	00004617          	auipc	a2,0x4
ffffffffc0207fde:	c2660613          	addi	a2,a2,-986 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0207fe2:	06a00593          	li	a1,106
ffffffffc0207fe6:	00006517          	auipc	a0,0x6
ffffffffc0207fea:	f5250513          	addi	a0,a0,-174 # ffffffffc020df38 <etext+0x2774>
ffffffffc0207fee:	e406                	sd	ra,8(sp)
ffffffffc0207ff0:	c5af80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207ff4 <vfs_add_dev>:
ffffffffc0207ff4:	86b2                	mv	a3,a2
ffffffffc0207ff6:	4601                	li	a2,0
ffffffffc0207ff8:	d0fff06f          	j	ffffffffc0207d06 <vfs_do_add>

ffffffffc0207ffc <vfs_mount>:
ffffffffc0207ffc:	7179                	addi	sp,sp,-48
ffffffffc0207ffe:	e84a                	sd	s2,16(sp)
ffffffffc0208000:	892a                	mv	s2,a0
ffffffffc0208002:	0008e517          	auipc	a0,0x8e
ffffffffc0208006:	81650513          	addi	a0,a0,-2026 # ffffffffc0295818 <vdev_list_sem>
ffffffffc020800a:	e44e                	sd	s3,8(sp)
ffffffffc020800c:	f406                	sd	ra,40(sp)
ffffffffc020800e:	f022                	sd	s0,32(sp)
ffffffffc0208010:	ec26                	sd	s1,24(sp)
ffffffffc0208012:	89ae                	mv	s3,a1
ffffffffc0208014:	de2fc0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0208018:	0c090a63          	beqz	s2,ffffffffc02080ec <vfs_mount+0xf0>
ffffffffc020801c:	0008e497          	auipc	s1,0x8e
ffffffffc0208020:	81448493          	addi	s1,s1,-2028 # ffffffffc0295830 <vdev_list>
ffffffffc0208024:	6480                	ld	s0,8(s1)
ffffffffc0208026:	00941663          	bne	s0,s1,ffffffffc0208032 <vfs_mount+0x36>
ffffffffc020802a:	a8ad                	j	ffffffffc02080a4 <vfs_mount+0xa8>
ffffffffc020802c:	6400                	ld	s0,8(s0)
ffffffffc020802e:	06940b63          	beq	s0,s1,ffffffffc02080a4 <vfs_mount+0xa8>
ffffffffc0208032:	ff843783          	ld	a5,-8(s0)
ffffffffc0208036:	dbfd                	beqz	a5,ffffffffc020802c <vfs_mount+0x30>
ffffffffc0208038:	fe043503          	ld	a0,-32(s0)
ffffffffc020803c:	85ca                	mv	a1,s2
ffffffffc020803e:	6b0030ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc0208042:	f56d                	bnez	a0,ffffffffc020802c <vfs_mount+0x30>
ffffffffc0208044:	ff043783          	ld	a5,-16(s0)
ffffffffc0208048:	e3a5                	bnez	a5,ffffffffc02080a8 <vfs_mount+0xac>
ffffffffc020804a:	fe043783          	ld	a5,-32(s0)
ffffffffc020804e:	cfbd                	beqz	a5,ffffffffc02080cc <vfs_mount+0xd0>
ffffffffc0208050:	ff843783          	ld	a5,-8(s0)
ffffffffc0208054:	cfa5                	beqz	a5,ffffffffc02080cc <vfs_mount+0xd0>
ffffffffc0208056:	fe843503          	ld	a0,-24(s0)
ffffffffc020805a:	c929                	beqz	a0,ffffffffc02080ac <vfs_mount+0xb0>
ffffffffc020805c:	4d38                	lw	a4,88(a0)
ffffffffc020805e:	6785                	lui	a5,0x1
ffffffffc0208060:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208064:	04f71463          	bne	a4,a5,ffffffffc02080ac <vfs_mount+0xb0>
ffffffffc0208068:	ff040593          	addi	a1,s0,-16
ffffffffc020806c:	9982                	jalr	s3
ffffffffc020806e:	84aa                	mv	s1,a0
ffffffffc0208070:	ed01                	bnez	a0,ffffffffc0208088 <vfs_mount+0x8c>
ffffffffc0208072:	ff043783          	ld	a5,-16(s0)
ffffffffc0208076:	cfad                	beqz	a5,ffffffffc02080f0 <vfs_mount+0xf4>
ffffffffc0208078:	fe043583          	ld	a1,-32(s0)
ffffffffc020807c:	00006517          	auipc	a0,0x6
ffffffffc0208080:	fc450513          	addi	a0,a0,-60 # ffffffffc020e040 <etext+0x287c>
ffffffffc0208084:	922f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0208088:	0008d517          	auipc	a0,0x8d
ffffffffc020808c:	79050513          	addi	a0,a0,1936 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0208090:	d62fc0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0208094:	70a2                	ld	ra,40(sp)
ffffffffc0208096:	7402                	ld	s0,32(sp)
ffffffffc0208098:	6942                	ld	s2,16(sp)
ffffffffc020809a:	69a2                	ld	s3,8(sp)
ffffffffc020809c:	8526                	mv	a0,s1
ffffffffc020809e:	64e2                	ld	s1,24(sp)
ffffffffc02080a0:	6145                	addi	sp,sp,48
ffffffffc02080a2:	8082                	ret
ffffffffc02080a4:	54cd                	li	s1,-13
ffffffffc02080a6:	b7cd                	j	ffffffffc0208088 <vfs_mount+0x8c>
ffffffffc02080a8:	54c5                	li	s1,-15
ffffffffc02080aa:	bff9                	j	ffffffffc0208088 <vfs_mount+0x8c>
ffffffffc02080ac:	00006697          	auipc	a3,0x6
ffffffffc02080b0:	f4468693          	addi	a3,a3,-188 # ffffffffc020dff0 <etext+0x282c>
ffffffffc02080b4:	00004617          	auipc	a2,0x4
ffffffffc02080b8:	b4c60613          	addi	a2,a2,-1204 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02080bc:	0ed00593          	li	a1,237
ffffffffc02080c0:	00006517          	auipc	a0,0x6
ffffffffc02080c4:	e7850513          	addi	a0,a0,-392 # ffffffffc020df38 <etext+0x2774>
ffffffffc02080c8:	b82f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080cc:	00006697          	auipc	a3,0x6
ffffffffc02080d0:	ef468693          	addi	a3,a3,-268 # ffffffffc020dfc0 <etext+0x27fc>
ffffffffc02080d4:	00004617          	auipc	a2,0x4
ffffffffc02080d8:	b2c60613          	addi	a2,a2,-1236 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02080dc:	0eb00593          	li	a1,235
ffffffffc02080e0:	00006517          	auipc	a0,0x6
ffffffffc02080e4:	e5850513          	addi	a0,a0,-424 # ffffffffc020df38 <etext+0x2774>
ffffffffc02080e8:	b62f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080ec:	d6bff0ef          	jal	ffffffffc0207e56 <find_mount.part.0>
ffffffffc02080f0:	00006697          	auipc	a3,0x6
ffffffffc02080f4:	f3868693          	addi	a3,a3,-200 # ffffffffc020e028 <etext+0x2864>
ffffffffc02080f8:	00004617          	auipc	a2,0x4
ffffffffc02080fc:	b0860613          	addi	a2,a2,-1272 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208100:	0ef00593          	li	a1,239
ffffffffc0208104:	00006517          	auipc	a0,0x6
ffffffffc0208108:	e3450513          	addi	a0,a0,-460 # ffffffffc020df38 <etext+0x2774>
ffffffffc020810c:	b3ef80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208110 <vfs_open>:
ffffffffc0208110:	7159                	addi	sp,sp,-112
ffffffffc0208112:	f486                	sd	ra,104(sp)
ffffffffc0208114:	e0d2                	sd	s4,64(sp)
ffffffffc0208116:	0035f793          	andi	a5,a1,3
ffffffffc020811a:	10078363          	beqz	a5,ffffffffc0208220 <vfs_open+0x110>
ffffffffc020811e:	470d                	li	a4,3
ffffffffc0208120:	12e78163          	beq	a5,a4,ffffffffc0208242 <vfs_open+0x132>
ffffffffc0208124:	f0a2                	sd	s0,96(sp)
ffffffffc0208126:	eca6                	sd	s1,88(sp)
ffffffffc0208128:	e8ca                	sd	s2,80(sp)
ffffffffc020812a:	e4ce                	sd	s3,72(sp)
ffffffffc020812c:	fc56                	sd	s5,56(sp)
ffffffffc020812e:	f85a                	sd	s6,48(sp)
ffffffffc0208130:	0105fa13          	andi	s4,a1,16
ffffffffc0208134:	842e                	mv	s0,a1
ffffffffc0208136:	00447793          	andi	a5,s0,4
ffffffffc020813a:	8b32                	mv	s6,a2
ffffffffc020813c:	082c                	addi	a1,sp,24
ffffffffc020813e:	00345613          	srli	a2,s0,0x3
ffffffffc0208142:	8abe                	mv	s5,a5
ffffffffc0208144:	0027d493          	srli	s1,a5,0x2
ffffffffc0208148:	892a                	mv	s2,a0
ffffffffc020814a:	00167993          	andi	s3,a2,1
ffffffffc020814e:	2ba000ef          	jal	ffffffffc0208408 <vfs_lookup>
ffffffffc0208152:	87aa                	mv	a5,a0
ffffffffc0208154:	c175                	beqz	a0,ffffffffc0208238 <vfs_open+0x128>
ffffffffc0208156:	01050713          	addi	a4,a0,16
ffffffffc020815a:	eb45                	bnez	a4,ffffffffc020820a <vfs_open+0xfa>
ffffffffc020815c:	c4dd                	beqz	s1,ffffffffc020820a <vfs_open+0xfa>
ffffffffc020815e:	854a                	mv	a0,s2
ffffffffc0208160:	1010                	addi	a2,sp,32
ffffffffc0208162:	102c                	addi	a1,sp,40
ffffffffc0208164:	32e000ef          	jal	ffffffffc0208492 <vfs_lookup_parent>
ffffffffc0208168:	87aa                	mv	a5,a0
ffffffffc020816a:	e145                	bnez	a0,ffffffffc020820a <vfs_open+0xfa>
ffffffffc020816c:	7522                	ld	a0,40(sp)
ffffffffc020816e:	14050c63          	beqz	a0,ffffffffc02082c6 <vfs_open+0x1b6>
ffffffffc0208172:	793c                	ld	a5,112(a0)
ffffffffc0208174:	14078963          	beqz	a5,ffffffffc02082c6 <vfs_open+0x1b6>
ffffffffc0208178:	77bc                	ld	a5,104(a5)
ffffffffc020817a:	14078663          	beqz	a5,ffffffffc02082c6 <vfs_open+0x1b6>
ffffffffc020817e:	00006597          	auipc	a1,0x6
ffffffffc0208182:	f3a58593          	addi	a1,a1,-198 # ffffffffc020e0b8 <etext+0x28f4>
ffffffffc0208186:	e42a                	sd	a0,8(sp)
ffffffffc0208188:	887ff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc020818c:	6522                	ld	a0,8(sp)
ffffffffc020818e:	7582                	ld	a1,32(sp)
ffffffffc0208190:	0834                	addi	a3,sp,24
ffffffffc0208192:	793c                	ld	a5,112(a0)
ffffffffc0208194:	7522                	ld	a0,40(sp)
ffffffffc0208196:	864e                	mv	a2,s3
ffffffffc0208198:	77bc                	ld	a5,104(a5)
ffffffffc020819a:	9782                	jalr	a5
ffffffffc020819c:	6562                	ld	a0,24(sp)
ffffffffc020819e:	10050463          	beqz	a0,ffffffffc02082a6 <vfs_open+0x196>
ffffffffc02081a2:	793c                	ld	a5,112(a0)
ffffffffc02081a4:	c3e9                	beqz	a5,ffffffffc0208266 <vfs_open+0x156>
ffffffffc02081a6:	679c                	ld	a5,8(a5)
ffffffffc02081a8:	cfdd                	beqz	a5,ffffffffc0208266 <vfs_open+0x156>
ffffffffc02081aa:	00006597          	auipc	a1,0x6
ffffffffc02081ae:	f7658593          	addi	a1,a1,-138 # ffffffffc020e120 <etext+0x295c>
ffffffffc02081b2:	e42a                	sd	a0,8(sp)
ffffffffc02081b4:	85bff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc02081b8:	6522                	ld	a0,8(sp)
ffffffffc02081ba:	85a2                	mv	a1,s0
ffffffffc02081bc:	793c                	ld	a5,112(a0)
ffffffffc02081be:	6562                	ld	a0,24(sp)
ffffffffc02081c0:	679c                	ld	a5,8(a5)
ffffffffc02081c2:	9782                	jalr	a5
ffffffffc02081c4:	87aa                	mv	a5,a0
ffffffffc02081c6:	e43e                	sd	a5,8(sp)
ffffffffc02081c8:	6562                	ld	a0,24(sp)
ffffffffc02081ca:	e3d1                	bnez	a5,ffffffffc020824e <vfs_open+0x13e>
ffffffffc02081cc:	839ff0ef          	jal	ffffffffc0207a04 <inode_open_inc>
ffffffffc02081d0:	014ae733          	or	a4,s5,s4
ffffffffc02081d4:	67a2                	ld	a5,8(sp)
ffffffffc02081d6:	c71d                	beqz	a4,ffffffffc0208204 <vfs_open+0xf4>
ffffffffc02081d8:	6462                	ld	s0,24(sp)
ffffffffc02081da:	c455                	beqz	s0,ffffffffc0208286 <vfs_open+0x176>
ffffffffc02081dc:	7838                	ld	a4,112(s0)
ffffffffc02081de:	c745                	beqz	a4,ffffffffc0208286 <vfs_open+0x176>
ffffffffc02081e0:	7338                	ld	a4,96(a4)
ffffffffc02081e2:	c355                	beqz	a4,ffffffffc0208286 <vfs_open+0x176>
ffffffffc02081e4:	8522                	mv	a0,s0
ffffffffc02081e6:	00006597          	auipc	a1,0x6
ffffffffc02081ea:	f9a58593          	addi	a1,a1,-102 # ffffffffc020e180 <etext+0x29bc>
ffffffffc02081ee:	e43e                	sd	a5,8(sp)
ffffffffc02081f0:	81fff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc02081f4:	7838                	ld	a4,112(s0)
ffffffffc02081f6:	6562                	ld	a0,24(sp)
ffffffffc02081f8:	4581                	li	a1,0
ffffffffc02081fa:	7338                	ld	a4,96(a4)
ffffffffc02081fc:	9702                	jalr	a4
ffffffffc02081fe:	67a2                	ld	a5,8(sp)
ffffffffc0208200:	842a                	mv	s0,a0
ffffffffc0208202:	e931                	bnez	a0,ffffffffc0208256 <vfs_open+0x146>
ffffffffc0208204:	6762                	ld	a4,24(sp)
ffffffffc0208206:	00eb3023          	sd	a4,0(s6)
ffffffffc020820a:	7406                	ld	s0,96(sp)
ffffffffc020820c:	64e6                	ld	s1,88(sp)
ffffffffc020820e:	6946                	ld	s2,80(sp)
ffffffffc0208210:	69a6                	ld	s3,72(sp)
ffffffffc0208212:	7ae2                	ld	s5,56(sp)
ffffffffc0208214:	7b42                	ld	s6,48(sp)
ffffffffc0208216:	70a6                	ld	ra,104(sp)
ffffffffc0208218:	6a06                	ld	s4,64(sp)
ffffffffc020821a:	853e                	mv	a0,a5
ffffffffc020821c:	6165                	addi	sp,sp,112
ffffffffc020821e:	8082                	ret
ffffffffc0208220:	0105f713          	andi	a4,a1,16
ffffffffc0208224:	8a3a                	mv	s4,a4
ffffffffc0208226:	57f5                	li	a5,-3
ffffffffc0208228:	f77d                	bnez	a4,ffffffffc0208216 <vfs_open+0x106>
ffffffffc020822a:	f0a2                	sd	s0,96(sp)
ffffffffc020822c:	eca6                	sd	s1,88(sp)
ffffffffc020822e:	e8ca                	sd	s2,80(sp)
ffffffffc0208230:	e4ce                	sd	s3,72(sp)
ffffffffc0208232:	fc56                	sd	s5,56(sp)
ffffffffc0208234:	f85a                	sd	s6,48(sp)
ffffffffc0208236:	bdfd                	j	ffffffffc0208134 <vfs_open+0x24>
ffffffffc0208238:	f60982e3          	beqz	s3,ffffffffc020819c <vfs_open+0x8c>
ffffffffc020823c:	d0a5                	beqz	s1,ffffffffc020819c <vfs_open+0x8c>
ffffffffc020823e:	57a5                	li	a5,-23
ffffffffc0208240:	b7e9                	j	ffffffffc020820a <vfs_open+0xfa>
ffffffffc0208242:	70a6                	ld	ra,104(sp)
ffffffffc0208244:	57f5                	li	a5,-3
ffffffffc0208246:	6a06                	ld	s4,64(sp)
ffffffffc0208248:	853e                	mv	a0,a5
ffffffffc020824a:	6165                	addi	sp,sp,112
ffffffffc020824c:	8082                	ret
ffffffffc020824e:	87bff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc0208252:	67a2                	ld	a5,8(sp)
ffffffffc0208254:	bf5d                	j	ffffffffc020820a <vfs_open+0xfa>
ffffffffc0208256:	6562                	ld	a0,24(sp)
ffffffffc0208258:	90dff0ef          	jal	ffffffffc0207b64 <inode_open_dec>
ffffffffc020825c:	6562                	ld	a0,24(sp)
ffffffffc020825e:	86bff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc0208262:	87a2                	mv	a5,s0
ffffffffc0208264:	b75d                	j	ffffffffc020820a <vfs_open+0xfa>
ffffffffc0208266:	00006697          	auipc	a3,0x6
ffffffffc020826a:	e6a68693          	addi	a3,a3,-406 # ffffffffc020e0d0 <etext+0x290c>
ffffffffc020826e:	00004617          	auipc	a2,0x4
ffffffffc0208272:	99260613          	addi	a2,a2,-1646 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208276:	03300593          	li	a1,51
ffffffffc020827a:	00006517          	auipc	a0,0x6
ffffffffc020827e:	e2650513          	addi	a0,a0,-474 # ffffffffc020e0a0 <etext+0x28dc>
ffffffffc0208282:	9c8f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208286:	00006697          	auipc	a3,0x6
ffffffffc020828a:	ea268693          	addi	a3,a3,-350 # ffffffffc020e128 <etext+0x2964>
ffffffffc020828e:	00004617          	auipc	a2,0x4
ffffffffc0208292:	97260613          	addi	a2,a2,-1678 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208296:	03a00593          	li	a1,58
ffffffffc020829a:	00006517          	auipc	a0,0x6
ffffffffc020829e:	e0650513          	addi	a0,a0,-506 # ffffffffc020e0a0 <etext+0x28dc>
ffffffffc02082a2:	9a8f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02082a6:	00006697          	auipc	a3,0x6
ffffffffc02082aa:	e1a68693          	addi	a3,a3,-486 # ffffffffc020e0c0 <etext+0x28fc>
ffffffffc02082ae:	00004617          	auipc	a2,0x4
ffffffffc02082b2:	95260613          	addi	a2,a2,-1710 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02082b6:	03100593          	li	a1,49
ffffffffc02082ba:	00006517          	auipc	a0,0x6
ffffffffc02082be:	de650513          	addi	a0,a0,-538 # ffffffffc020e0a0 <etext+0x28dc>
ffffffffc02082c2:	988f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02082c6:	00006697          	auipc	a3,0x6
ffffffffc02082ca:	d8a68693          	addi	a3,a3,-630 # ffffffffc020e050 <etext+0x288c>
ffffffffc02082ce:	00004617          	auipc	a2,0x4
ffffffffc02082d2:	93260613          	addi	a2,a2,-1742 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02082d6:	02c00593          	li	a1,44
ffffffffc02082da:	00006517          	auipc	a0,0x6
ffffffffc02082de:	dc650513          	addi	a0,a0,-570 # ffffffffc020e0a0 <etext+0x28dc>
ffffffffc02082e2:	968f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02082e6 <vfs_close>:
ffffffffc02082e6:	1141                	addi	sp,sp,-16
ffffffffc02082e8:	e406                	sd	ra,8(sp)
ffffffffc02082ea:	e022                	sd	s0,0(sp)
ffffffffc02082ec:	842a                	mv	s0,a0
ffffffffc02082ee:	877ff0ef          	jal	ffffffffc0207b64 <inode_open_dec>
ffffffffc02082f2:	8522                	mv	a0,s0
ffffffffc02082f4:	fd4ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc02082f8:	60a2                	ld	ra,8(sp)
ffffffffc02082fa:	6402                	ld	s0,0(sp)
ffffffffc02082fc:	4501                	li	a0,0
ffffffffc02082fe:	0141                	addi	sp,sp,16
ffffffffc0208300:	8082                	ret

ffffffffc0208302 <get_device>:
ffffffffc0208302:	00054e03          	lbu	t3,0(a0)
ffffffffc0208306:	020e0463          	beqz	t3,ffffffffc020832e <get_device+0x2c>
ffffffffc020830a:	00150693          	addi	a3,a0,1
ffffffffc020830e:	8736                	mv	a4,a3
ffffffffc0208310:	87f2                	mv	a5,t3
ffffffffc0208312:	4801                	li	a6,0
ffffffffc0208314:	03a00893          	li	a7,58
ffffffffc0208318:	02f00313          	li	t1,47
ffffffffc020831c:	01178c63          	beq	a5,a7,ffffffffc0208334 <get_device+0x32>
ffffffffc0208320:	02678e63          	beq	a5,t1,ffffffffc020835c <get_device+0x5a>
ffffffffc0208324:	00074783          	lbu	a5,0(a4)
ffffffffc0208328:	0705                	addi	a4,a4,1
ffffffffc020832a:	2805                	addiw	a6,a6,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc020832c:	fbe5                	bnez	a5,ffffffffc020831c <get_device+0x1a>
ffffffffc020832e:	e188                	sd	a0,0(a1)
ffffffffc0208330:	8532                	mv	a0,a2
ffffffffc0208332:	a269                	j	ffffffffc02084bc <vfs_get_curdir>
ffffffffc0208334:	02080663          	beqz	a6,ffffffffc0208360 <get_device+0x5e>
ffffffffc0208338:	01050733          	add	a4,a0,a6
ffffffffc020833c:	010687b3          	add	a5,a3,a6
ffffffffc0208340:	00070023          	sb	zero,0(a4)
ffffffffc0208344:	02f00813          	li	a6,47
ffffffffc0208348:	86be                	mv	a3,a5
ffffffffc020834a:	0007c703          	lbu	a4,0(a5)
ffffffffc020834e:	0785                	addi	a5,a5,1
ffffffffc0208350:	ff070ce3          	beq	a4,a6,ffffffffc0208348 <get_device+0x46>
ffffffffc0208354:	e194                	sd	a3,0(a1)
ffffffffc0208356:	85b2                	mv	a1,a2
ffffffffc0208358:	b93ff06f          	j	ffffffffc0207eea <vfs_get_root>
ffffffffc020835c:	fc0819e3          	bnez	a6,ffffffffc020832e <get_device+0x2c>
ffffffffc0208360:	7139                	addi	sp,sp,-64
ffffffffc0208362:	f822                	sd	s0,48(sp)
ffffffffc0208364:	f426                	sd	s1,40(sp)
ffffffffc0208366:	fc06                	sd	ra,56(sp)
ffffffffc0208368:	02f00793          	li	a5,47
ffffffffc020836c:	8432                	mv	s0,a2
ffffffffc020836e:	84ae                	mv	s1,a1
ffffffffc0208370:	04fe0563          	beq	t3,a5,ffffffffc02083ba <get_device+0xb8>
ffffffffc0208374:	03a00793          	li	a5,58
ffffffffc0208378:	06fe1863          	bne	t3,a5,ffffffffc02083e8 <get_device+0xe6>
ffffffffc020837c:	0828                	addi	a0,sp,24
ffffffffc020837e:	e436                	sd	a3,8(sp)
ffffffffc0208380:	13c000ef          	jal	ffffffffc02084bc <vfs_get_curdir>
ffffffffc0208384:	e515                	bnez	a0,ffffffffc02083b0 <get_device+0xae>
ffffffffc0208386:	67e2                	ld	a5,24(sp)
ffffffffc0208388:	77a8                	ld	a0,104(a5)
ffffffffc020838a:	cd1d                	beqz	a0,ffffffffc02083c8 <get_device+0xc6>
ffffffffc020838c:	617c                	ld	a5,192(a0)
ffffffffc020838e:	9782                	jalr	a5
ffffffffc0208390:	87aa                	mv	a5,a0
ffffffffc0208392:	6562                	ld	a0,24(sp)
ffffffffc0208394:	e01c                	sd	a5,0(s0)
ffffffffc0208396:	f32ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020839a:	66a2                	ld	a3,8(sp)
ffffffffc020839c:	02f00713          	li	a4,47
ffffffffc02083a0:	a011                	j	ffffffffc02083a4 <get_device+0xa2>
ffffffffc02083a2:	0685                	addi	a3,a3,1
ffffffffc02083a4:	0006c783          	lbu	a5,0(a3)
ffffffffc02083a8:	fee78de3          	beq	a5,a4,ffffffffc02083a2 <get_device+0xa0>
ffffffffc02083ac:	e094                	sd	a3,0(s1)
ffffffffc02083ae:	4501                	li	a0,0
ffffffffc02083b0:	70e2                	ld	ra,56(sp)
ffffffffc02083b2:	7442                	ld	s0,48(sp)
ffffffffc02083b4:	74a2                	ld	s1,40(sp)
ffffffffc02083b6:	6121                	addi	sp,sp,64
ffffffffc02083b8:	8082                	ret
ffffffffc02083ba:	8532                	mv	a0,a2
ffffffffc02083bc:	e436                	sd	a3,8(sp)
ffffffffc02083be:	8ebff0ef          	jal	ffffffffc0207ca8 <vfs_get_bootfs>
ffffffffc02083c2:	66a2                	ld	a3,8(sp)
ffffffffc02083c4:	dd61                	beqz	a0,ffffffffc020839c <get_device+0x9a>
ffffffffc02083c6:	b7ed                	j	ffffffffc02083b0 <get_device+0xae>
ffffffffc02083c8:	00006697          	auipc	a3,0x6
ffffffffc02083cc:	df068693          	addi	a3,a3,-528 # ffffffffc020e1b8 <etext+0x29f4>
ffffffffc02083d0:	00004617          	auipc	a2,0x4
ffffffffc02083d4:	83060613          	addi	a2,a2,-2000 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02083d8:	03900593          	li	a1,57
ffffffffc02083dc:	00006517          	auipc	a0,0x6
ffffffffc02083e0:	dc450513          	addi	a0,a0,-572 # ffffffffc020e1a0 <etext+0x29dc>
ffffffffc02083e4:	866f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02083e8:	00006697          	auipc	a3,0x6
ffffffffc02083ec:	da868693          	addi	a3,a3,-600 # ffffffffc020e190 <etext+0x29cc>
ffffffffc02083f0:	00004617          	auipc	a2,0x4
ffffffffc02083f4:	81060613          	addi	a2,a2,-2032 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02083f8:	03300593          	li	a1,51
ffffffffc02083fc:	00006517          	auipc	a0,0x6
ffffffffc0208400:	da450513          	addi	a0,a0,-604 # ffffffffc020e1a0 <etext+0x29dc>
ffffffffc0208404:	846f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208408 <vfs_lookup>:
ffffffffc0208408:	7139                	addi	sp,sp,-64
ffffffffc020840a:	f822                	sd	s0,48(sp)
ffffffffc020840c:	1030                	addi	a2,sp,40
ffffffffc020840e:	842e                	mv	s0,a1
ffffffffc0208410:	082c                	addi	a1,sp,24
ffffffffc0208412:	fc06                	sd	ra,56(sp)
ffffffffc0208414:	ec2a                	sd	a0,24(sp)
ffffffffc0208416:	eedff0ef          	jal	ffffffffc0208302 <get_device>
ffffffffc020841a:	87aa                	mv	a5,a0
ffffffffc020841c:	e121                	bnez	a0,ffffffffc020845c <vfs_lookup+0x54>
ffffffffc020841e:	6762                	ld	a4,24(sp)
ffffffffc0208420:	7522                	ld	a0,40(sp)
ffffffffc0208422:	00074683          	lbu	a3,0(a4)
ffffffffc0208426:	c2a1                	beqz	a3,ffffffffc0208466 <vfs_lookup+0x5e>
ffffffffc0208428:	c529                	beqz	a0,ffffffffc0208472 <vfs_lookup+0x6a>
ffffffffc020842a:	793c                	ld	a5,112(a0)
ffffffffc020842c:	c3b9                	beqz	a5,ffffffffc0208472 <vfs_lookup+0x6a>
ffffffffc020842e:	7bbc                	ld	a5,112(a5)
ffffffffc0208430:	c3a9                	beqz	a5,ffffffffc0208472 <vfs_lookup+0x6a>
ffffffffc0208432:	00006597          	auipc	a1,0x6
ffffffffc0208436:	dee58593          	addi	a1,a1,-530 # ffffffffc020e220 <etext+0x2a5c>
ffffffffc020843a:	e83a                	sd	a4,16(sp)
ffffffffc020843c:	e42a                	sd	a0,8(sp)
ffffffffc020843e:	dd0ff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0208442:	6522                	ld	a0,8(sp)
ffffffffc0208444:	65c2                	ld	a1,16(sp)
ffffffffc0208446:	8622                	mv	a2,s0
ffffffffc0208448:	793c                	ld	a5,112(a0)
ffffffffc020844a:	7522                	ld	a0,40(sp)
ffffffffc020844c:	7bbc                	ld	a5,112(a5)
ffffffffc020844e:	9782                	jalr	a5
ffffffffc0208450:	87aa                	mv	a5,a0
ffffffffc0208452:	7522                	ld	a0,40(sp)
ffffffffc0208454:	e43e                	sd	a5,8(sp)
ffffffffc0208456:	e72ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020845a:	67a2                	ld	a5,8(sp)
ffffffffc020845c:	70e2                	ld	ra,56(sp)
ffffffffc020845e:	7442                	ld	s0,48(sp)
ffffffffc0208460:	853e                	mv	a0,a5
ffffffffc0208462:	6121                	addi	sp,sp,64
ffffffffc0208464:	8082                	ret
ffffffffc0208466:	e008                	sd	a0,0(s0)
ffffffffc0208468:	70e2                	ld	ra,56(sp)
ffffffffc020846a:	7442                	ld	s0,48(sp)
ffffffffc020846c:	853e                	mv	a0,a5
ffffffffc020846e:	6121                	addi	sp,sp,64
ffffffffc0208470:	8082                	ret
ffffffffc0208472:	00006697          	auipc	a3,0x6
ffffffffc0208476:	d5e68693          	addi	a3,a3,-674 # ffffffffc020e1d0 <etext+0x2a0c>
ffffffffc020847a:	00003617          	auipc	a2,0x3
ffffffffc020847e:	78660613          	addi	a2,a2,1926 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208482:	04f00593          	li	a1,79
ffffffffc0208486:	00006517          	auipc	a0,0x6
ffffffffc020848a:	d1a50513          	addi	a0,a0,-742 # ffffffffc020e1a0 <etext+0x29dc>
ffffffffc020848e:	fbdf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208492 <vfs_lookup_parent>:
ffffffffc0208492:	7139                	addi	sp,sp,-64
ffffffffc0208494:	f822                	sd	s0,48(sp)
ffffffffc0208496:	f426                	sd	s1,40(sp)
ffffffffc0208498:	8432                	mv	s0,a2
ffffffffc020849a:	84ae                	mv	s1,a1
ffffffffc020849c:	0830                	addi	a2,sp,24
ffffffffc020849e:	002c                	addi	a1,sp,8
ffffffffc02084a0:	fc06                	sd	ra,56(sp)
ffffffffc02084a2:	e42a                	sd	a0,8(sp)
ffffffffc02084a4:	e5fff0ef          	jal	ffffffffc0208302 <get_device>
ffffffffc02084a8:	e509                	bnez	a0,ffffffffc02084b2 <vfs_lookup_parent+0x20>
ffffffffc02084aa:	6722                	ld	a4,8(sp)
ffffffffc02084ac:	67e2                	ld	a5,24(sp)
ffffffffc02084ae:	e018                	sd	a4,0(s0)
ffffffffc02084b0:	e09c                	sd	a5,0(s1)
ffffffffc02084b2:	70e2                	ld	ra,56(sp)
ffffffffc02084b4:	7442                	ld	s0,48(sp)
ffffffffc02084b6:	74a2                	ld	s1,40(sp)
ffffffffc02084b8:	6121                	addi	sp,sp,64
ffffffffc02084ba:	8082                	ret

ffffffffc02084bc <vfs_get_curdir>:
ffffffffc02084bc:	0008e797          	auipc	a5,0x8e
ffffffffc02084c0:	40c7b783          	ld	a5,1036(a5) # ffffffffc02968c8 <current>
ffffffffc02084c4:	1101                	addi	sp,sp,-32
ffffffffc02084c6:	e822                	sd	s0,16(sp)
ffffffffc02084c8:	1487b783          	ld	a5,328(a5)
ffffffffc02084cc:	ec06                	sd	ra,24(sp)
ffffffffc02084ce:	6380                	ld	s0,0(a5)
ffffffffc02084d0:	cc09                	beqz	s0,ffffffffc02084ea <vfs_get_curdir+0x2e>
ffffffffc02084d2:	e426                	sd	s1,8(sp)
ffffffffc02084d4:	84aa                	mv	s1,a0
ffffffffc02084d6:	8522                	mv	a0,s0
ffffffffc02084d8:	d22ff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc02084dc:	e080                	sd	s0,0(s1)
ffffffffc02084de:	64a2                	ld	s1,8(sp)
ffffffffc02084e0:	4501                	li	a0,0
ffffffffc02084e2:	60e2                	ld	ra,24(sp)
ffffffffc02084e4:	6442                	ld	s0,16(sp)
ffffffffc02084e6:	6105                	addi	sp,sp,32
ffffffffc02084e8:	8082                	ret
ffffffffc02084ea:	5541                	li	a0,-16
ffffffffc02084ec:	bfdd                	j	ffffffffc02084e2 <vfs_get_curdir+0x26>

ffffffffc02084ee <vfs_set_curdir>:
ffffffffc02084ee:	7139                	addi	sp,sp,-64
ffffffffc02084f0:	f04a                	sd	s2,32(sp)
ffffffffc02084f2:	0008e917          	auipc	s2,0x8e
ffffffffc02084f6:	3d690913          	addi	s2,s2,982 # ffffffffc02968c8 <current>
ffffffffc02084fa:	00093783          	ld	a5,0(s2)
ffffffffc02084fe:	f822                	sd	s0,48(sp)
ffffffffc0208500:	842a                	mv	s0,a0
ffffffffc0208502:	1487b503          	ld	a0,328(a5)
ffffffffc0208506:	fc06                	sd	ra,56(sp)
ffffffffc0208508:	f426                	sd	s1,40(sp)
ffffffffc020850a:	d63fc0ef          	jal	ffffffffc020526c <lock_files>
ffffffffc020850e:	00093783          	ld	a5,0(s2)
ffffffffc0208512:	1487b503          	ld	a0,328(a5)
ffffffffc0208516:	611c                	ld	a5,0(a0)
ffffffffc0208518:	06f40a63          	beq	s0,a5,ffffffffc020858c <vfs_set_curdir+0x9e>
ffffffffc020851c:	c02d                	beqz	s0,ffffffffc020857e <vfs_set_curdir+0x90>
ffffffffc020851e:	7838                	ld	a4,112(s0)
ffffffffc0208520:	cb25                	beqz	a4,ffffffffc0208590 <vfs_set_curdir+0xa2>
ffffffffc0208522:	6b38                	ld	a4,80(a4)
ffffffffc0208524:	c735                	beqz	a4,ffffffffc0208590 <vfs_set_curdir+0xa2>
ffffffffc0208526:	00006597          	auipc	a1,0x6
ffffffffc020852a:	d6a58593          	addi	a1,a1,-662 # ffffffffc020e290 <etext+0x2acc>
ffffffffc020852e:	8522                	mv	a0,s0
ffffffffc0208530:	e43e                	sd	a5,8(sp)
ffffffffc0208532:	cdcff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0208536:	7838                	ld	a4,112(s0)
ffffffffc0208538:	086c                	addi	a1,sp,28
ffffffffc020853a:	8522                	mv	a0,s0
ffffffffc020853c:	6b38                	ld	a4,80(a4)
ffffffffc020853e:	9702                	jalr	a4
ffffffffc0208540:	84aa                	mv	s1,a0
ffffffffc0208542:	e909                	bnez	a0,ffffffffc0208554 <vfs_set_curdir+0x66>
ffffffffc0208544:	4772                	lw	a4,28(sp)
ffffffffc0208546:	4609                	li	a2,2
ffffffffc0208548:	54b9                	li	s1,-18
ffffffffc020854a:	40c75693          	srai	a3,a4,0xc
ffffffffc020854e:	8a9d                	andi	a3,a3,7
ffffffffc0208550:	00c68f63          	beq	a3,a2,ffffffffc020856e <vfs_set_curdir+0x80>
ffffffffc0208554:	00093783          	ld	a5,0(s2)
ffffffffc0208558:	1487b503          	ld	a0,328(a5)
ffffffffc020855c:	d17fc0ef          	jal	ffffffffc0205272 <unlock_files>
ffffffffc0208560:	70e2                	ld	ra,56(sp)
ffffffffc0208562:	7442                	ld	s0,48(sp)
ffffffffc0208564:	7902                	ld	s2,32(sp)
ffffffffc0208566:	8526                	mv	a0,s1
ffffffffc0208568:	74a2                	ld	s1,40(sp)
ffffffffc020856a:	6121                	addi	sp,sp,64
ffffffffc020856c:	8082                	ret
ffffffffc020856e:	8522                	mv	a0,s0
ffffffffc0208570:	c8aff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc0208574:	00093703          	ld	a4,0(s2)
ffffffffc0208578:	67a2                	ld	a5,8(sp)
ffffffffc020857a:	14873503          	ld	a0,328(a4)
ffffffffc020857e:	e100                	sd	s0,0(a0)
ffffffffc0208580:	4481                	li	s1,0
ffffffffc0208582:	dfe9                	beqz	a5,ffffffffc020855c <vfs_set_curdir+0x6e>
ffffffffc0208584:	853e                	mv	a0,a5
ffffffffc0208586:	d42ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020858a:	b7e9                	j	ffffffffc0208554 <vfs_set_curdir+0x66>
ffffffffc020858c:	4481                	li	s1,0
ffffffffc020858e:	b7f9                	j	ffffffffc020855c <vfs_set_curdir+0x6e>
ffffffffc0208590:	00006697          	auipc	a3,0x6
ffffffffc0208594:	c9868693          	addi	a3,a3,-872 # ffffffffc020e228 <etext+0x2a64>
ffffffffc0208598:	00003617          	auipc	a2,0x3
ffffffffc020859c:	66860613          	addi	a2,a2,1640 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02085a0:	04300593          	li	a1,67
ffffffffc02085a4:	00006517          	auipc	a0,0x6
ffffffffc02085a8:	cd450513          	addi	a0,a0,-812 # ffffffffc020e278 <etext+0x2ab4>
ffffffffc02085ac:	e9ff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02085b0 <vfs_chdir>:
ffffffffc02085b0:	7179                	addi	sp,sp,-48
ffffffffc02085b2:	082c                	addi	a1,sp,24
ffffffffc02085b4:	f406                	sd	ra,40(sp)
ffffffffc02085b6:	e53ff0ef          	jal	ffffffffc0208408 <vfs_lookup>
ffffffffc02085ba:	87aa                	mv	a5,a0
ffffffffc02085bc:	c509                	beqz	a0,ffffffffc02085c6 <vfs_chdir+0x16>
ffffffffc02085be:	70a2                	ld	ra,40(sp)
ffffffffc02085c0:	853e                	mv	a0,a5
ffffffffc02085c2:	6145                	addi	sp,sp,48
ffffffffc02085c4:	8082                	ret
ffffffffc02085c6:	6562                	ld	a0,24(sp)
ffffffffc02085c8:	f27ff0ef          	jal	ffffffffc02084ee <vfs_set_curdir>
ffffffffc02085cc:	87aa                	mv	a5,a0
ffffffffc02085ce:	6562                	ld	a0,24(sp)
ffffffffc02085d0:	e43e                	sd	a5,8(sp)
ffffffffc02085d2:	cf6ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc02085d6:	67a2                	ld	a5,8(sp)
ffffffffc02085d8:	70a2                	ld	ra,40(sp)
ffffffffc02085da:	853e                	mv	a0,a5
ffffffffc02085dc:	6145                	addi	sp,sp,48
ffffffffc02085de:	8082                	ret

ffffffffc02085e0 <vfs_getcwd>:
ffffffffc02085e0:	0008e797          	auipc	a5,0x8e
ffffffffc02085e4:	2e87b783          	ld	a5,744(a5) # ffffffffc02968c8 <current>
ffffffffc02085e8:	7179                	addi	sp,sp,-48
ffffffffc02085ea:	ec26                	sd	s1,24(sp)
ffffffffc02085ec:	1487b783          	ld	a5,328(a5)
ffffffffc02085f0:	f406                	sd	ra,40(sp)
ffffffffc02085f2:	f022                	sd	s0,32(sp)
ffffffffc02085f4:	6384                	ld	s1,0(a5)
ffffffffc02085f6:	c0c1                	beqz	s1,ffffffffc0208676 <vfs_getcwd+0x96>
ffffffffc02085f8:	e84a                	sd	s2,16(sp)
ffffffffc02085fa:	892a                	mv	s2,a0
ffffffffc02085fc:	8526                	mv	a0,s1
ffffffffc02085fe:	bfcff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc0208602:	74a8                	ld	a0,104(s1)
ffffffffc0208604:	c93d                	beqz	a0,ffffffffc020867a <vfs_getcwd+0x9a>
ffffffffc0208606:	9a5ff0ef          	jal	ffffffffc0207faa <vfs_get_devname>
ffffffffc020860a:	842a                	mv	s0,a0
ffffffffc020860c:	09c030ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc0208610:	862a                	mv	a2,a0
ffffffffc0208612:	85a2                	mv	a1,s0
ffffffffc0208614:	854a                	mv	a0,s2
ffffffffc0208616:	4701                	li	a4,0
ffffffffc0208618:	4685                	li	a3,1
ffffffffc020861a:	e7dfc0ef          	jal	ffffffffc0205496 <iobuf_move>
ffffffffc020861e:	842a                	mv	s0,a0
ffffffffc0208620:	c919                	beqz	a0,ffffffffc0208636 <vfs_getcwd+0x56>
ffffffffc0208622:	8526                	mv	a0,s1
ffffffffc0208624:	ca4ff0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc0208628:	6942                	ld	s2,16(sp)
ffffffffc020862a:	70a2                	ld	ra,40(sp)
ffffffffc020862c:	8522                	mv	a0,s0
ffffffffc020862e:	7402                	ld	s0,32(sp)
ffffffffc0208630:	64e2                	ld	s1,24(sp)
ffffffffc0208632:	6145                	addi	sp,sp,48
ffffffffc0208634:	8082                	ret
ffffffffc0208636:	4685                	li	a3,1
ffffffffc0208638:	03a00793          	li	a5,58
ffffffffc020863c:	8636                	mv	a2,a3
ffffffffc020863e:	4701                	li	a4,0
ffffffffc0208640:	00f10593          	addi	a1,sp,15
ffffffffc0208644:	854a                	mv	a0,s2
ffffffffc0208646:	00f107a3          	sb	a5,15(sp)
ffffffffc020864a:	e4dfc0ef          	jal	ffffffffc0205496 <iobuf_move>
ffffffffc020864e:	842a                	mv	s0,a0
ffffffffc0208650:	f969                	bnez	a0,ffffffffc0208622 <vfs_getcwd+0x42>
ffffffffc0208652:	78bc                	ld	a5,112(s1)
ffffffffc0208654:	c3b9                	beqz	a5,ffffffffc020869a <vfs_getcwd+0xba>
ffffffffc0208656:	7f9c                	ld	a5,56(a5)
ffffffffc0208658:	c3a9                	beqz	a5,ffffffffc020869a <vfs_getcwd+0xba>
ffffffffc020865a:	00006597          	auipc	a1,0x6
ffffffffc020865e:	c9658593          	addi	a1,a1,-874 # ffffffffc020e2f0 <etext+0x2b2c>
ffffffffc0208662:	8526                	mv	a0,s1
ffffffffc0208664:	baaff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0208668:	78bc                	ld	a5,112(s1)
ffffffffc020866a:	85ca                	mv	a1,s2
ffffffffc020866c:	8526                	mv	a0,s1
ffffffffc020866e:	7f9c                	ld	a5,56(a5)
ffffffffc0208670:	9782                	jalr	a5
ffffffffc0208672:	842a                	mv	s0,a0
ffffffffc0208674:	b77d                	j	ffffffffc0208622 <vfs_getcwd+0x42>
ffffffffc0208676:	5441                	li	s0,-16
ffffffffc0208678:	bf4d                	j	ffffffffc020862a <vfs_getcwd+0x4a>
ffffffffc020867a:	00006697          	auipc	a3,0x6
ffffffffc020867e:	b3e68693          	addi	a3,a3,-1218 # ffffffffc020e1b8 <etext+0x29f4>
ffffffffc0208682:	00003617          	auipc	a2,0x3
ffffffffc0208686:	57e60613          	addi	a2,a2,1406 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020868a:	06e00593          	li	a1,110
ffffffffc020868e:	00006517          	auipc	a0,0x6
ffffffffc0208692:	bea50513          	addi	a0,a0,-1046 # ffffffffc020e278 <etext+0x2ab4>
ffffffffc0208696:	db5f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020869a:	00006697          	auipc	a3,0x6
ffffffffc020869e:	bfe68693          	addi	a3,a3,-1026 # ffffffffc020e298 <etext+0x2ad4>
ffffffffc02086a2:	00003617          	auipc	a2,0x3
ffffffffc02086a6:	55e60613          	addi	a2,a2,1374 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02086aa:	07800593          	li	a1,120
ffffffffc02086ae:	00006517          	auipc	a0,0x6
ffffffffc02086b2:	bca50513          	addi	a0,a0,-1078 # ffffffffc020e278 <etext+0x2ab4>
ffffffffc02086b6:	d95f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02086ba <dev_lookup>:
ffffffffc02086ba:	0005c703          	lbu	a4,0(a1)
ffffffffc02086be:	ef11                	bnez	a4,ffffffffc02086da <dev_lookup+0x20>
ffffffffc02086c0:	1101                	addi	sp,sp,-32
ffffffffc02086c2:	ec06                	sd	ra,24(sp)
ffffffffc02086c4:	e032                	sd	a2,0(sp)
ffffffffc02086c6:	e42a                	sd	a0,8(sp)
ffffffffc02086c8:	b32ff0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc02086cc:	6602                	ld	a2,0(sp)
ffffffffc02086ce:	67a2                	ld	a5,8(sp)
ffffffffc02086d0:	60e2                	ld	ra,24(sp)
ffffffffc02086d2:	4501                	li	a0,0
ffffffffc02086d4:	e21c                	sd	a5,0(a2)
ffffffffc02086d6:	6105                	addi	sp,sp,32
ffffffffc02086d8:	8082                	ret
ffffffffc02086da:	5541                	li	a0,-16
ffffffffc02086dc:	8082                	ret

ffffffffc02086de <dev_fstat>:
ffffffffc02086de:	1101                	addi	sp,sp,-32
ffffffffc02086e0:	e822                	sd	s0,16(sp)
ffffffffc02086e2:	e426                	sd	s1,8(sp)
ffffffffc02086e4:	842a                	mv	s0,a0
ffffffffc02086e6:	84ae                	mv	s1,a1
ffffffffc02086e8:	852e                	mv	a0,a1
ffffffffc02086ea:	02000613          	li	a2,32
ffffffffc02086ee:	4581                	li	a1,0
ffffffffc02086f0:	ec06                	sd	ra,24(sp)
ffffffffc02086f2:	06a030ef          	jal	ffffffffc020b75c <memset>
ffffffffc02086f6:	c429                	beqz	s0,ffffffffc0208740 <dev_fstat+0x62>
ffffffffc02086f8:	783c                	ld	a5,112(s0)
ffffffffc02086fa:	c3b9                	beqz	a5,ffffffffc0208740 <dev_fstat+0x62>
ffffffffc02086fc:	6bbc                	ld	a5,80(a5)
ffffffffc02086fe:	c3a9                	beqz	a5,ffffffffc0208740 <dev_fstat+0x62>
ffffffffc0208700:	00006597          	auipc	a1,0x6
ffffffffc0208704:	b9058593          	addi	a1,a1,-1136 # ffffffffc020e290 <etext+0x2acc>
ffffffffc0208708:	8522                	mv	a0,s0
ffffffffc020870a:	b04ff0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc020870e:	783c                	ld	a5,112(s0)
ffffffffc0208710:	85a6                	mv	a1,s1
ffffffffc0208712:	8522                	mv	a0,s0
ffffffffc0208714:	6bbc                	ld	a5,80(a5)
ffffffffc0208716:	9782                	jalr	a5
ffffffffc0208718:	ed19                	bnez	a0,ffffffffc0208736 <dev_fstat+0x58>
ffffffffc020871a:	4c38                	lw	a4,88(s0)
ffffffffc020871c:	6785                	lui	a5,0x1
ffffffffc020871e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208722:	02f71f63          	bne	a4,a5,ffffffffc0208760 <dev_fstat+0x82>
ffffffffc0208726:	6018                	ld	a4,0(s0)
ffffffffc0208728:	641c                	ld	a5,8(s0)
ffffffffc020872a:	4685                	li	a3,1
ffffffffc020872c:	e898                	sd	a4,16(s1)
ffffffffc020872e:	02e787b3          	mul	a5,a5,a4
ffffffffc0208732:	e494                	sd	a3,8(s1)
ffffffffc0208734:	ec9c                	sd	a5,24(s1)
ffffffffc0208736:	60e2                	ld	ra,24(sp)
ffffffffc0208738:	6442                	ld	s0,16(sp)
ffffffffc020873a:	64a2                	ld	s1,8(sp)
ffffffffc020873c:	6105                	addi	sp,sp,32
ffffffffc020873e:	8082                	ret
ffffffffc0208740:	00006697          	auipc	a3,0x6
ffffffffc0208744:	ae868693          	addi	a3,a3,-1304 # ffffffffc020e228 <etext+0x2a64>
ffffffffc0208748:	00003617          	auipc	a2,0x3
ffffffffc020874c:	4b860613          	addi	a2,a2,1208 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208750:	04200593          	li	a1,66
ffffffffc0208754:	00006517          	auipc	a0,0x6
ffffffffc0208758:	bac50513          	addi	a0,a0,-1108 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc020875c:	ceff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208760:	00006697          	auipc	a3,0x6
ffffffffc0208764:	89068693          	addi	a3,a3,-1904 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0208768:	00003617          	auipc	a2,0x3
ffffffffc020876c:	49860613          	addi	a2,a2,1176 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208770:	04500593          	li	a1,69
ffffffffc0208774:	00006517          	auipc	a0,0x6
ffffffffc0208778:	b8c50513          	addi	a0,a0,-1140 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc020877c:	ccff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208780 <dev_ioctl>:
ffffffffc0208780:	c909                	beqz	a0,ffffffffc0208792 <dev_ioctl+0x12>
ffffffffc0208782:	4d34                	lw	a3,88(a0)
ffffffffc0208784:	6705                	lui	a4,0x1
ffffffffc0208786:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020878a:	00e69463          	bne	a3,a4,ffffffffc0208792 <dev_ioctl+0x12>
ffffffffc020878e:	751c                	ld	a5,40(a0)
ffffffffc0208790:	8782                	jr	a5
ffffffffc0208792:	1141                	addi	sp,sp,-16
ffffffffc0208794:	00006697          	auipc	a3,0x6
ffffffffc0208798:	85c68693          	addi	a3,a3,-1956 # ffffffffc020dff0 <etext+0x282c>
ffffffffc020879c:	00003617          	auipc	a2,0x3
ffffffffc02087a0:	46460613          	addi	a2,a2,1124 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02087a4:	03500593          	li	a1,53
ffffffffc02087a8:	00006517          	auipc	a0,0x6
ffffffffc02087ac:	b5850513          	addi	a0,a0,-1192 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc02087b0:	e406                	sd	ra,8(sp)
ffffffffc02087b2:	c99f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02087b6 <dev_tryseek>:
ffffffffc02087b6:	c51d                	beqz	a0,ffffffffc02087e4 <dev_tryseek+0x2e>
ffffffffc02087b8:	4d38                	lw	a4,88(a0)
ffffffffc02087ba:	6785                	lui	a5,0x1
ffffffffc02087bc:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02087c0:	02f71263          	bne	a4,a5,ffffffffc02087e4 <dev_tryseek+0x2e>
ffffffffc02087c4:	611c                	ld	a5,0(a0)
ffffffffc02087c6:	cf89                	beqz	a5,ffffffffc02087e0 <dev_tryseek+0x2a>
ffffffffc02087c8:	6518                	ld	a4,8(a0)
ffffffffc02087ca:	02e5f6b3          	remu	a3,a1,a4
ffffffffc02087ce:	ea89                	bnez	a3,ffffffffc02087e0 <dev_tryseek+0x2a>
ffffffffc02087d0:	0005c863          	bltz	a1,ffffffffc02087e0 <dev_tryseek+0x2a>
ffffffffc02087d4:	02e787b3          	mul	a5,a5,a4
ffffffffc02087d8:	4501                	li	a0,0
ffffffffc02087da:	00f5f363          	bgeu	a1,a5,ffffffffc02087e0 <dev_tryseek+0x2a>
ffffffffc02087de:	8082                	ret
ffffffffc02087e0:	5575                	li	a0,-3
ffffffffc02087e2:	8082                	ret
ffffffffc02087e4:	1141                	addi	sp,sp,-16
ffffffffc02087e6:	00006697          	auipc	a3,0x6
ffffffffc02087ea:	80a68693          	addi	a3,a3,-2038 # ffffffffc020dff0 <etext+0x282c>
ffffffffc02087ee:	00003617          	auipc	a2,0x3
ffffffffc02087f2:	41260613          	addi	a2,a2,1042 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02087f6:	05f00593          	li	a1,95
ffffffffc02087fa:	00006517          	auipc	a0,0x6
ffffffffc02087fe:	b0650513          	addi	a0,a0,-1274 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc0208802:	e406                	sd	ra,8(sp)
ffffffffc0208804:	c47f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208808 <dev_gettype>:
ffffffffc0208808:	cd11                	beqz	a0,ffffffffc0208824 <dev_gettype+0x1c>
ffffffffc020880a:	4d38                	lw	a4,88(a0)
ffffffffc020880c:	6785                	lui	a5,0x1
ffffffffc020880e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208812:	00f71963          	bne	a4,a5,ffffffffc0208824 <dev_gettype+0x1c>
ffffffffc0208816:	6118                	ld	a4,0(a0)
ffffffffc0208818:	6791                	lui	a5,0x4
ffffffffc020881a:	c311                	beqz	a4,ffffffffc020881e <dev_gettype+0x16>
ffffffffc020881c:	6795                	lui	a5,0x5
ffffffffc020881e:	c19c                	sw	a5,0(a1)
ffffffffc0208820:	4501                	li	a0,0
ffffffffc0208822:	8082                	ret
ffffffffc0208824:	1141                	addi	sp,sp,-16
ffffffffc0208826:	00005697          	auipc	a3,0x5
ffffffffc020882a:	7ca68693          	addi	a3,a3,1994 # ffffffffc020dff0 <etext+0x282c>
ffffffffc020882e:	00003617          	auipc	a2,0x3
ffffffffc0208832:	3d260613          	addi	a2,a2,978 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208836:	05300593          	li	a1,83
ffffffffc020883a:	00006517          	auipc	a0,0x6
ffffffffc020883e:	ac650513          	addi	a0,a0,-1338 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc0208842:	e406                	sd	ra,8(sp)
ffffffffc0208844:	c07f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208848 <dev_write>:
ffffffffc0208848:	c911                	beqz	a0,ffffffffc020885c <dev_write+0x14>
ffffffffc020884a:	4d34                	lw	a3,88(a0)
ffffffffc020884c:	6705                	lui	a4,0x1
ffffffffc020884e:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208852:	00e69563          	bne	a3,a4,ffffffffc020885c <dev_write+0x14>
ffffffffc0208856:	711c                	ld	a5,32(a0)
ffffffffc0208858:	4605                	li	a2,1
ffffffffc020885a:	8782                	jr	a5
ffffffffc020885c:	1141                	addi	sp,sp,-16
ffffffffc020885e:	00005697          	auipc	a3,0x5
ffffffffc0208862:	79268693          	addi	a3,a3,1938 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0208866:	00003617          	auipc	a2,0x3
ffffffffc020886a:	39a60613          	addi	a2,a2,922 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020886e:	02c00593          	li	a1,44
ffffffffc0208872:	00006517          	auipc	a0,0x6
ffffffffc0208876:	a8e50513          	addi	a0,a0,-1394 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc020887a:	e406                	sd	ra,8(sp)
ffffffffc020887c:	bcff70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208880 <dev_read>:
ffffffffc0208880:	c911                	beqz	a0,ffffffffc0208894 <dev_read+0x14>
ffffffffc0208882:	4d34                	lw	a3,88(a0)
ffffffffc0208884:	6705                	lui	a4,0x1
ffffffffc0208886:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020888a:	00e69563          	bne	a3,a4,ffffffffc0208894 <dev_read+0x14>
ffffffffc020888e:	711c                	ld	a5,32(a0)
ffffffffc0208890:	4601                	li	a2,0
ffffffffc0208892:	8782                	jr	a5
ffffffffc0208894:	1141                	addi	sp,sp,-16
ffffffffc0208896:	00005697          	auipc	a3,0x5
ffffffffc020889a:	75a68693          	addi	a3,a3,1882 # ffffffffc020dff0 <etext+0x282c>
ffffffffc020889e:	00003617          	auipc	a2,0x3
ffffffffc02088a2:	36260613          	addi	a2,a2,866 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02088a6:	02300593          	li	a1,35
ffffffffc02088aa:	00006517          	auipc	a0,0x6
ffffffffc02088ae:	a5650513          	addi	a0,a0,-1450 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc02088b2:	e406                	sd	ra,8(sp)
ffffffffc02088b4:	b97f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02088b8 <dev_close>:
ffffffffc02088b8:	c909                	beqz	a0,ffffffffc02088ca <dev_close+0x12>
ffffffffc02088ba:	4d34                	lw	a3,88(a0)
ffffffffc02088bc:	6705                	lui	a4,0x1
ffffffffc02088be:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088c2:	00e69463          	bne	a3,a4,ffffffffc02088ca <dev_close+0x12>
ffffffffc02088c6:	6d1c                	ld	a5,24(a0)
ffffffffc02088c8:	8782                	jr	a5
ffffffffc02088ca:	1141                	addi	sp,sp,-16
ffffffffc02088cc:	00005697          	auipc	a3,0x5
ffffffffc02088d0:	72468693          	addi	a3,a3,1828 # ffffffffc020dff0 <etext+0x282c>
ffffffffc02088d4:	00003617          	auipc	a2,0x3
ffffffffc02088d8:	32c60613          	addi	a2,a2,812 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02088dc:	45e9                	li	a1,26
ffffffffc02088de:	00006517          	auipc	a0,0x6
ffffffffc02088e2:	a2250513          	addi	a0,a0,-1502 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc02088e6:	e406                	sd	ra,8(sp)
ffffffffc02088e8:	b63f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02088ec <dev_open>:
ffffffffc02088ec:	03c5f793          	andi	a5,a1,60
ffffffffc02088f0:	eb91                	bnez	a5,ffffffffc0208904 <dev_open+0x18>
ffffffffc02088f2:	c919                	beqz	a0,ffffffffc0208908 <dev_open+0x1c>
ffffffffc02088f4:	4d34                	lw	a3,88(a0)
ffffffffc02088f6:	6785                	lui	a5,0x1
ffffffffc02088f8:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02088fc:	00f69663          	bne	a3,a5,ffffffffc0208908 <dev_open+0x1c>
ffffffffc0208900:	691c                	ld	a5,16(a0)
ffffffffc0208902:	8782                	jr	a5
ffffffffc0208904:	5575                	li	a0,-3
ffffffffc0208906:	8082                	ret
ffffffffc0208908:	1141                	addi	sp,sp,-16
ffffffffc020890a:	00005697          	auipc	a3,0x5
ffffffffc020890e:	6e668693          	addi	a3,a3,1766 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0208912:	00003617          	auipc	a2,0x3
ffffffffc0208916:	2ee60613          	addi	a2,a2,750 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020891a:	45c5                	li	a1,17
ffffffffc020891c:	00006517          	auipc	a0,0x6
ffffffffc0208920:	9e450513          	addi	a0,a0,-1564 # ffffffffc020e300 <etext+0x2b3c>
ffffffffc0208924:	e406                	sd	ra,8(sp)
ffffffffc0208926:	b25f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020892a <dev_init>:
ffffffffc020892a:	1141                	addi	sp,sp,-16
ffffffffc020892c:	e406                	sd	ra,8(sp)
ffffffffc020892e:	544000ef          	jal	ffffffffc0208e72 <dev_init_stdin>
ffffffffc0208932:	65c000ef          	jal	ffffffffc0208f8e <dev_init_stdout>
ffffffffc0208936:	60a2                	ld	ra,8(sp)
ffffffffc0208938:	0141                	addi	sp,sp,16
ffffffffc020893a:	ac01                	j	ffffffffc0208b4a <dev_init_disk0>

ffffffffc020893c <dev_create_inode>:
ffffffffc020893c:	6505                	lui	a0,0x1
ffffffffc020893e:	1101                	addi	sp,sp,-32
ffffffffc0208940:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208944:	ec06                	sd	ra,24(sp)
ffffffffc0208946:	836ff0ef          	jal	ffffffffc020797c <__alloc_inode>
ffffffffc020894a:	87aa                	mv	a5,a0
ffffffffc020894c:	c911                	beqz	a0,ffffffffc0208960 <dev_create_inode+0x24>
ffffffffc020894e:	4601                	li	a2,0
ffffffffc0208950:	00007597          	auipc	a1,0x7
ffffffffc0208954:	dd058593          	addi	a1,a1,-560 # ffffffffc020f720 <dev_node_ops>
ffffffffc0208958:	e42a                	sd	a0,8(sp)
ffffffffc020895a:	83eff0ef          	jal	ffffffffc0207998 <inode_init>
ffffffffc020895e:	67a2                	ld	a5,8(sp)
ffffffffc0208960:	60e2                	ld	ra,24(sp)
ffffffffc0208962:	853e                	mv	a0,a5
ffffffffc0208964:	6105                	addi	sp,sp,32
ffffffffc0208966:	8082                	ret

ffffffffc0208968 <disk0_open>:
ffffffffc0208968:	4501                	li	a0,0
ffffffffc020896a:	8082                	ret

ffffffffc020896c <disk0_close>:
ffffffffc020896c:	4501                	li	a0,0
ffffffffc020896e:	8082                	ret

ffffffffc0208970 <disk0_ioctl>:
ffffffffc0208970:	5531                	li	a0,-20
ffffffffc0208972:	8082                	ret

ffffffffc0208974 <disk0_io>:
ffffffffc0208974:	711d                	addi	sp,sp,-96
ffffffffc0208976:	6594                	ld	a3,8(a1)
ffffffffc0208978:	e8a2                	sd	s0,80(sp)
ffffffffc020897a:	6d80                	ld	s0,24(a1)
ffffffffc020897c:	6785                	lui	a5,0x1
ffffffffc020897e:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208980:	0086e733          	or	a4,a3,s0
ffffffffc0208984:	ec86                	sd	ra,88(sp)
ffffffffc0208986:	8f7d                	and	a4,a4,a5
ffffffffc0208988:	14071663          	bnez	a4,ffffffffc0208ad4 <disk0_io+0x160>
ffffffffc020898c:	e0ca                	sd	s2,64(sp)
ffffffffc020898e:	43f6d913          	srai	s2,a3,0x3f
ffffffffc0208992:	00f97933          	and	s2,s2,a5
ffffffffc0208996:	9936                	add	s2,s2,a3
ffffffffc0208998:	40c95913          	srai	s2,s2,0xc
ffffffffc020899c:	00c45793          	srli	a5,s0,0xc
ffffffffc02089a0:	0127873b          	addw	a4,a5,s2
ffffffffc02089a4:	6114                	ld	a3,0(a0)
ffffffffc02089a6:	1702                	slli	a4,a4,0x20
ffffffffc02089a8:	9301                	srli	a4,a4,0x20
ffffffffc02089aa:	2901                	sext.w	s2,s2
ffffffffc02089ac:	2781                	sext.w	a5,a5
ffffffffc02089ae:	12e6e063          	bltu	a3,a4,ffffffffc0208ace <disk0_io+0x15a>
ffffffffc02089b2:	e799                	bnez	a5,ffffffffc02089c0 <disk0_io+0x4c>
ffffffffc02089b4:	6906                	ld	s2,64(sp)
ffffffffc02089b6:	4501                	li	a0,0
ffffffffc02089b8:	60e6                	ld	ra,88(sp)
ffffffffc02089ba:	6446                	ld	s0,80(sp)
ffffffffc02089bc:	6125                	addi	sp,sp,96
ffffffffc02089be:	8082                	ret
ffffffffc02089c0:	0008d517          	auipc	a0,0x8d
ffffffffc02089c4:	e8050513          	addi	a0,a0,-384 # ffffffffc0295840 <disk0_sem>
ffffffffc02089c8:	e4a6                	sd	s1,72(sp)
ffffffffc02089ca:	f852                	sd	s4,48(sp)
ffffffffc02089cc:	f456                	sd	s5,40(sp)
ffffffffc02089ce:	84b2                	mv	s1,a2
ffffffffc02089d0:	8aae                	mv	s5,a1
ffffffffc02089d2:	0008ea17          	auipc	s4,0x8e
ffffffffc02089d6:	f26a0a13          	addi	s4,s4,-218 # ffffffffc02968f8 <disk0_buffer>
ffffffffc02089da:	c1dfb0ef          	jal	ffffffffc02045f6 <down>
ffffffffc02089de:	000a3603          	ld	a2,0(s4)
ffffffffc02089e2:	e8ad                	bnez	s1,ffffffffc0208a54 <disk0_io+0xe0>
ffffffffc02089e4:	e862                	sd	s8,16(sp)
ffffffffc02089e6:	fc4e                	sd	s3,56(sp)
ffffffffc02089e8:	ec5e                	sd	s7,24(sp)
ffffffffc02089ea:	6c11                	lui	s8,0x4
ffffffffc02089ec:	a029                	j	ffffffffc02089f6 <disk0_io+0x82>
ffffffffc02089ee:	000a3603          	ld	a2,0(s4)
ffffffffc02089f2:	0129893b          	addw	s2,s3,s2
ffffffffc02089f6:	84a2                	mv	s1,s0
ffffffffc02089f8:	008c7363          	bgeu	s8,s0,ffffffffc02089fe <disk0_io+0x8a>
ffffffffc02089fc:	6491                	lui	s1,0x4
ffffffffc02089fe:	00c4d993          	srli	s3,s1,0xc
ffffffffc0208a02:	2981                	sext.w	s3,s3
ffffffffc0208a04:	00399b9b          	slliw	s7,s3,0x3
ffffffffc0208a08:	020b9693          	slli	a3,s7,0x20
ffffffffc0208a0c:	9281                	srli	a3,a3,0x20
ffffffffc0208a0e:	0039159b          	slliw	a1,s2,0x3
ffffffffc0208a12:	4509                	li	a0,2
ffffffffc0208a14:	88af80ef          	jal	ffffffffc0200a9e <ide_read_secs>
ffffffffc0208a18:	e16d                	bnez	a0,ffffffffc0208afa <disk0_io+0x186>
ffffffffc0208a1a:	000a3583          	ld	a1,0(s4)
ffffffffc0208a1e:	0038                	addi	a4,sp,8
ffffffffc0208a20:	4685                	li	a3,1
ffffffffc0208a22:	8626                	mv	a2,s1
ffffffffc0208a24:	8556                	mv	a0,s5
ffffffffc0208a26:	a71fc0ef          	jal	ffffffffc0205496 <iobuf_move>
ffffffffc0208a2a:	67a2                	ld	a5,8(sp)
ffffffffc0208a2c:	0a979663          	bne	a5,s1,ffffffffc0208ad8 <disk0_io+0x164>
ffffffffc0208a30:	03449793          	slli	a5,s1,0x34
ffffffffc0208a34:	e3d5                	bnez	a5,ffffffffc0208ad8 <disk0_io+0x164>
ffffffffc0208a36:	8c05                	sub	s0,s0,s1
ffffffffc0208a38:	f85d                	bnez	s0,ffffffffc02089ee <disk0_io+0x7a>
ffffffffc0208a3a:	79e2                	ld	s3,56(sp)
ffffffffc0208a3c:	6be2                	ld	s7,24(sp)
ffffffffc0208a3e:	6c42                	ld	s8,16(sp)
ffffffffc0208a40:	0008d517          	auipc	a0,0x8d
ffffffffc0208a44:	e0050513          	addi	a0,a0,-512 # ffffffffc0295840 <disk0_sem>
ffffffffc0208a48:	babfb0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0208a4c:	64a6                	ld	s1,72(sp)
ffffffffc0208a4e:	7a42                	ld	s4,48(sp)
ffffffffc0208a50:	7aa2                	ld	s5,40(sp)
ffffffffc0208a52:	b78d                	j	ffffffffc02089b4 <disk0_io+0x40>
ffffffffc0208a54:	f05a                	sd	s6,32(sp)
ffffffffc0208a56:	a029                	j	ffffffffc0208a60 <disk0_io+0xec>
ffffffffc0208a58:	000a3603          	ld	a2,0(s4)
ffffffffc0208a5c:	0124893b          	addw	s2,s1,s2
ffffffffc0208a60:	85b2                	mv	a1,a2
ffffffffc0208a62:	0038                	addi	a4,sp,8
ffffffffc0208a64:	4681                	li	a3,0
ffffffffc0208a66:	6611                	lui	a2,0x4
ffffffffc0208a68:	8556                	mv	a0,s5
ffffffffc0208a6a:	a2dfc0ef          	jal	ffffffffc0205496 <iobuf_move>
ffffffffc0208a6e:	67a2                	ld	a5,8(sp)
ffffffffc0208a70:	fff78713          	addi	a4,a5,-1
ffffffffc0208a74:	02877a63          	bgeu	a4,s0,ffffffffc0208aa8 <disk0_io+0x134>
ffffffffc0208a78:	03479713          	slli	a4,a5,0x34
ffffffffc0208a7c:	e715                	bnez	a4,ffffffffc0208aa8 <disk0_io+0x134>
ffffffffc0208a7e:	83b1                	srli	a5,a5,0xc
ffffffffc0208a80:	0007849b          	sext.w	s1,a5
ffffffffc0208a84:	00349b1b          	slliw	s6,s1,0x3
ffffffffc0208a88:	000a3603          	ld	a2,0(s4)
ffffffffc0208a8c:	020b1693          	slli	a3,s6,0x20
ffffffffc0208a90:	9281                	srli	a3,a3,0x20
ffffffffc0208a92:	0039159b          	slliw	a1,s2,0x3
ffffffffc0208a96:	4509                	li	a0,2
ffffffffc0208a98:	8a0f80ef          	jal	ffffffffc0200b38 <ide_write_secs>
ffffffffc0208a9c:	e151                	bnez	a0,ffffffffc0208b20 <disk0_io+0x1ac>
ffffffffc0208a9e:	67a2                	ld	a5,8(sp)
ffffffffc0208aa0:	8c1d                	sub	s0,s0,a5
ffffffffc0208aa2:	f85d                	bnez	s0,ffffffffc0208a58 <disk0_io+0xe4>
ffffffffc0208aa4:	7b02                	ld	s6,32(sp)
ffffffffc0208aa6:	bf69                	j	ffffffffc0208a40 <disk0_io+0xcc>
ffffffffc0208aa8:	00006697          	auipc	a3,0x6
ffffffffc0208aac:	87068693          	addi	a3,a3,-1936 # ffffffffc020e318 <etext+0x2b54>
ffffffffc0208ab0:	00003617          	auipc	a2,0x3
ffffffffc0208ab4:	15060613          	addi	a2,a2,336 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208ab8:	05700593          	li	a1,87
ffffffffc0208abc:	00006517          	auipc	a0,0x6
ffffffffc0208ac0:	89c50513          	addi	a0,a0,-1892 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208ac4:	fc4e                	sd	s3,56(sp)
ffffffffc0208ac6:	ec5e                	sd	s7,24(sp)
ffffffffc0208ac8:	e862                	sd	s8,16(sp)
ffffffffc0208aca:	981f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208ace:	6906                	ld	s2,64(sp)
ffffffffc0208ad0:	5575                	li	a0,-3
ffffffffc0208ad2:	b5dd                	j	ffffffffc02089b8 <disk0_io+0x44>
ffffffffc0208ad4:	5575                	li	a0,-3
ffffffffc0208ad6:	b5cd                	j	ffffffffc02089b8 <disk0_io+0x44>
ffffffffc0208ad8:	00006697          	auipc	a3,0x6
ffffffffc0208adc:	93868693          	addi	a3,a3,-1736 # ffffffffc020e410 <etext+0x2c4c>
ffffffffc0208ae0:	00003617          	auipc	a2,0x3
ffffffffc0208ae4:	12060613          	addi	a2,a2,288 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208ae8:	06200593          	li	a1,98
ffffffffc0208aec:	00006517          	auipc	a0,0x6
ffffffffc0208af0:	86c50513          	addi	a0,a0,-1940 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208af4:	f05a                	sd	s6,32(sp)
ffffffffc0208af6:	955f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208afa:	88aa                	mv	a7,a0
ffffffffc0208afc:	885e                	mv	a6,s7
ffffffffc0208afe:	87ce                	mv	a5,s3
ffffffffc0208b00:	0039171b          	slliw	a4,s2,0x3
ffffffffc0208b04:	86ca                	mv	a3,s2
ffffffffc0208b06:	00006617          	auipc	a2,0x6
ffffffffc0208b0a:	8c260613          	addi	a2,a2,-1854 # ffffffffc020e3c8 <etext+0x2c04>
ffffffffc0208b0e:	02d00593          	li	a1,45
ffffffffc0208b12:	00006517          	auipc	a0,0x6
ffffffffc0208b16:	84650513          	addi	a0,a0,-1978 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208b1a:	f05a                	sd	s6,32(sp)
ffffffffc0208b1c:	92ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208b20:	88aa                	mv	a7,a0
ffffffffc0208b22:	885a                	mv	a6,s6
ffffffffc0208b24:	87a6                	mv	a5,s1
ffffffffc0208b26:	0039171b          	slliw	a4,s2,0x3
ffffffffc0208b2a:	86ca                	mv	a3,s2
ffffffffc0208b2c:	00006617          	auipc	a2,0x6
ffffffffc0208b30:	84c60613          	addi	a2,a2,-1972 # ffffffffc020e378 <etext+0x2bb4>
ffffffffc0208b34:	03700593          	li	a1,55
ffffffffc0208b38:	00006517          	auipc	a0,0x6
ffffffffc0208b3c:	82050513          	addi	a0,a0,-2016 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208b40:	fc4e                	sd	s3,56(sp)
ffffffffc0208b42:	ec5e                	sd	s7,24(sp)
ffffffffc0208b44:	e862                	sd	s8,16(sp)
ffffffffc0208b46:	905f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208b4a <dev_init_disk0>:
ffffffffc0208b4a:	1101                	addi	sp,sp,-32
ffffffffc0208b4c:	ec06                	sd	ra,24(sp)
ffffffffc0208b4e:	e822                	sd	s0,16(sp)
ffffffffc0208b50:	e426                	sd	s1,8(sp)
ffffffffc0208b52:	debff0ef          	jal	ffffffffc020893c <dev_create_inode>
ffffffffc0208b56:	c541                	beqz	a0,ffffffffc0208bde <dev_init_disk0+0x94>
ffffffffc0208b58:	4d38                	lw	a4,88(a0)
ffffffffc0208b5a:	6785                	lui	a5,0x1
ffffffffc0208b5c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208b60:	842a                	mv	s0,a0
ffffffffc0208b62:	6485                	lui	s1,0x1
ffffffffc0208b64:	0cf71e63          	bne	a4,a5,ffffffffc0208c40 <dev_init_disk0+0xf6>
ffffffffc0208b68:	4509                	li	a0,2
ffffffffc0208b6a:	ee9f70ef          	jal	ffffffffc0200a52 <ide_device_valid>
ffffffffc0208b6e:	cd4d                	beqz	a0,ffffffffc0208c28 <dev_init_disk0+0xde>
ffffffffc0208b70:	4509                	li	a0,2
ffffffffc0208b72:	f05f70ef          	jal	ffffffffc0200a76 <ide_device_size>
ffffffffc0208b76:	00000797          	auipc	a5,0x0
ffffffffc0208b7a:	dfa78793          	addi	a5,a5,-518 # ffffffffc0208970 <disk0_ioctl>
ffffffffc0208b7e:	00000617          	auipc	a2,0x0
ffffffffc0208b82:	dea60613          	addi	a2,a2,-534 # ffffffffc0208968 <disk0_open>
ffffffffc0208b86:	00000697          	auipc	a3,0x0
ffffffffc0208b8a:	de668693          	addi	a3,a3,-538 # ffffffffc020896c <disk0_close>
ffffffffc0208b8e:	00000717          	auipc	a4,0x0
ffffffffc0208b92:	de670713          	addi	a4,a4,-538 # ffffffffc0208974 <disk0_io>
ffffffffc0208b96:	810d                	srli	a0,a0,0x3
ffffffffc0208b98:	f41c                	sd	a5,40(s0)
ffffffffc0208b9a:	e008                	sd	a0,0(s0)
ffffffffc0208b9c:	e810                	sd	a2,16(s0)
ffffffffc0208b9e:	ec14                	sd	a3,24(s0)
ffffffffc0208ba0:	f018                	sd	a4,32(s0)
ffffffffc0208ba2:	4585                	li	a1,1
ffffffffc0208ba4:	0008d517          	auipc	a0,0x8d
ffffffffc0208ba8:	c9c50513          	addi	a0,a0,-868 # ffffffffc0295840 <disk0_sem>
ffffffffc0208bac:	e404                	sd	s1,8(s0)
ffffffffc0208bae:	a3ffb0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc0208bb2:	6511                	lui	a0,0x4
ffffffffc0208bb4:	c0cf90ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0208bb8:	0008e797          	auipc	a5,0x8e
ffffffffc0208bbc:	d4a7b023          	sd	a0,-704(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208bc0:	c921                	beqz	a0,ffffffffc0208c10 <dev_init_disk0+0xc6>
ffffffffc0208bc2:	85a2                	mv	a1,s0
ffffffffc0208bc4:	4605                	li	a2,1
ffffffffc0208bc6:	00006517          	auipc	a0,0x6
ffffffffc0208bca:	8da50513          	addi	a0,a0,-1830 # ffffffffc020e4a0 <etext+0x2cdc>
ffffffffc0208bce:	c26ff0ef          	jal	ffffffffc0207ff4 <vfs_add_dev>
ffffffffc0208bd2:	e115                	bnez	a0,ffffffffc0208bf6 <dev_init_disk0+0xac>
ffffffffc0208bd4:	60e2                	ld	ra,24(sp)
ffffffffc0208bd6:	6442                	ld	s0,16(sp)
ffffffffc0208bd8:	64a2                	ld	s1,8(sp)
ffffffffc0208bda:	6105                	addi	sp,sp,32
ffffffffc0208bdc:	8082                	ret
ffffffffc0208bde:	00006617          	auipc	a2,0x6
ffffffffc0208be2:	86260613          	addi	a2,a2,-1950 # ffffffffc020e440 <etext+0x2c7c>
ffffffffc0208be6:	08700593          	li	a1,135
ffffffffc0208bea:	00005517          	auipc	a0,0x5
ffffffffc0208bee:	76e50513          	addi	a0,a0,1902 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208bf2:	859f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208bf6:	86aa                	mv	a3,a0
ffffffffc0208bf8:	00006617          	auipc	a2,0x6
ffffffffc0208bfc:	8b060613          	addi	a2,a2,-1872 # ffffffffc020e4a8 <etext+0x2ce4>
ffffffffc0208c00:	08d00593          	li	a1,141
ffffffffc0208c04:	00005517          	auipc	a0,0x5
ffffffffc0208c08:	75450513          	addi	a0,a0,1876 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208c0c:	83ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c10:	00006617          	auipc	a2,0x6
ffffffffc0208c14:	87060613          	addi	a2,a2,-1936 # ffffffffc020e480 <etext+0x2cbc>
ffffffffc0208c18:	07f00593          	li	a1,127
ffffffffc0208c1c:	00005517          	auipc	a0,0x5
ffffffffc0208c20:	73c50513          	addi	a0,a0,1852 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208c24:	827f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c28:	00006617          	auipc	a2,0x6
ffffffffc0208c2c:	83860613          	addi	a2,a2,-1992 # ffffffffc020e460 <etext+0x2c9c>
ffffffffc0208c30:	07300593          	li	a1,115
ffffffffc0208c34:	00005517          	auipc	a0,0x5
ffffffffc0208c38:	72450513          	addi	a0,a0,1828 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208c3c:	80ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c40:	00005697          	auipc	a3,0x5
ffffffffc0208c44:	3b068693          	addi	a3,a3,944 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0208c48:	00003617          	auipc	a2,0x3
ffffffffc0208c4c:	fb860613          	addi	a2,a2,-72 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208c50:	08900593          	li	a1,137
ffffffffc0208c54:	00005517          	auipc	a0,0x5
ffffffffc0208c58:	70450513          	addi	a0,a0,1796 # ffffffffc020e358 <etext+0x2b94>
ffffffffc0208c5c:	feef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208c60 <stdin_open>:
ffffffffc0208c60:	e199                	bnez	a1,ffffffffc0208c66 <stdin_open+0x6>
ffffffffc0208c62:	4501                	li	a0,0
ffffffffc0208c64:	8082                	ret
ffffffffc0208c66:	5575                	li	a0,-3
ffffffffc0208c68:	8082                	ret

ffffffffc0208c6a <stdin_close>:
ffffffffc0208c6a:	4501                	li	a0,0
ffffffffc0208c6c:	8082                	ret

ffffffffc0208c6e <stdin_ioctl>:
ffffffffc0208c6e:	5575                	li	a0,-3
ffffffffc0208c70:	8082                	ret

ffffffffc0208c72 <stdin_io>:
ffffffffc0208c72:	14061f63          	bnez	a2,ffffffffc0208dd0 <stdin_io+0x15e>
ffffffffc0208c76:	7175                	addi	sp,sp,-144
ffffffffc0208c78:	ecd6                	sd	s5,88(sp)
ffffffffc0208c7a:	e8da                	sd	s6,80(sp)
ffffffffc0208c7c:	e4de                	sd	s7,72(sp)
ffffffffc0208c7e:	0185bb03          	ld	s6,24(a1)
ffffffffc0208c82:	0005bb83          	ld	s7,0(a1)
ffffffffc0208c86:	e506                	sd	ra,136(sp)
ffffffffc0208c88:	e122                	sd	s0,128(sp)
ffffffffc0208c8a:	8aae                	mv	s5,a1
ffffffffc0208c8c:	100027f3          	csrr	a5,sstatus
ffffffffc0208c90:	8b89                	andi	a5,a5,2
ffffffffc0208c92:	12079663          	bnez	a5,ffffffffc0208dbe <stdin_io+0x14c>
ffffffffc0208c96:	4401                	li	s0,0
ffffffffc0208c98:	120b0a63          	beqz	s6,ffffffffc0208dcc <stdin_io+0x15a>
ffffffffc0208c9c:	f8ca                	sd	s2,112(sp)
ffffffffc0208c9e:	0008e917          	auipc	s2,0x8e
ffffffffc0208ca2:	c6a90913          	addi	s2,s2,-918 # ffffffffc0296908 <p_rpos>
ffffffffc0208ca6:	00093783          	ld	a5,0(s2)
ffffffffc0208caa:	fca6                	sd	s1,120(sp)
ffffffffc0208cac:	6705                	lui	a4,0x1
ffffffffc0208cae:	800004b7          	lui	s1,0x80000
ffffffffc0208cb2:	f4ce                	sd	s3,104(sp)
ffffffffc0208cb4:	f0d2                	sd	s4,96(sp)
ffffffffc0208cb6:	e0e2                	sd	s8,64(sp)
ffffffffc0208cb8:	0491                	addi	s1,s1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208cba:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208cbe:	4a01                	li	s4,0
ffffffffc0208cc0:	0008e997          	auipc	s3,0x8e
ffffffffc0208cc4:	c4098993          	addi	s3,s3,-960 # ffffffffc0296900 <p_wpos>
ffffffffc0208cc8:	0009b703          	ld	a4,0(s3)
ffffffffc0208ccc:	02e7d763          	bge	a5,a4,ffffffffc0208cfa <stdin_io+0x88>
ffffffffc0208cd0:	a045                	j	ffffffffc0208d70 <stdin_io+0xfe>
ffffffffc0208cd2:	fd2fe0ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc0208cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0208cda:	8b89                	andi	a5,a5,2
ffffffffc0208cdc:	4401                	li	s0,0
ffffffffc0208cde:	e3b1                	bnez	a5,ffffffffc0208d22 <stdin_io+0xb0>
ffffffffc0208ce0:	0828                	addi	a0,sp,24
ffffffffc0208ce2:	9a5fb0ef          	jal	ffffffffc0204686 <wait_in_queue>
ffffffffc0208ce6:	e529                	bnez	a0,ffffffffc0208d30 <stdin_io+0xbe>
ffffffffc0208ce8:	5782                	lw	a5,32(sp)
ffffffffc0208cea:	04979d63          	bne	a5,s1,ffffffffc0208d44 <stdin_io+0xd2>
ffffffffc0208cee:	00093783          	ld	a5,0(s2)
ffffffffc0208cf2:	0009b703          	ld	a4,0(s3)
ffffffffc0208cf6:	06e7cd63          	blt	a5,a4,ffffffffc0208d70 <stdin_io+0xfe>
ffffffffc0208cfa:	80000637          	lui	a2,0x80000
ffffffffc0208cfe:	0611                	addi	a2,a2,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208d00:	082c                	addi	a1,sp,24
ffffffffc0208d02:	0008d517          	auipc	a0,0x8d
ffffffffc0208d06:	b5650513          	addi	a0,a0,-1194 # ffffffffc0295858 <__wait_queue>
ffffffffc0208d0a:	aa9fb0ef          	jal	ffffffffc02047b2 <wait_current_set>
ffffffffc0208d0e:	d071                	beqz	s0,ffffffffc0208cd2 <stdin_io+0x60>
ffffffffc0208d10:	ec3f70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0208d14:	f90fe0ef          	jal	ffffffffc02074a4 <schedule>
ffffffffc0208d18:	100027f3          	csrr	a5,sstatus
ffffffffc0208d1c:	8b89                	andi	a5,a5,2
ffffffffc0208d1e:	4401                	li	s0,0
ffffffffc0208d20:	d3e1                	beqz	a5,ffffffffc0208ce0 <stdin_io+0x6e>
ffffffffc0208d22:	eb7f70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0208d26:	0828                	addi	a0,sp,24
ffffffffc0208d28:	4405                	li	s0,1
ffffffffc0208d2a:	95dfb0ef          	jal	ffffffffc0204686 <wait_in_queue>
ffffffffc0208d2e:	dd4d                	beqz	a0,ffffffffc0208ce8 <stdin_io+0x76>
ffffffffc0208d30:	082c                	addi	a1,sp,24
ffffffffc0208d32:	0008d517          	auipc	a0,0x8d
ffffffffc0208d36:	b2650513          	addi	a0,a0,-1242 # ffffffffc0295858 <__wait_queue>
ffffffffc0208d3a:	8f3fb0ef          	jal	ffffffffc020462c <wait_queue_del>
ffffffffc0208d3e:	5782                	lw	a5,32(sp)
ffffffffc0208d40:	fa9787e3          	beq	a5,s1,ffffffffc0208cee <stdin_io+0x7c>
ffffffffc0208d44:	000a051b          	sext.w	a0,s4
ffffffffc0208d48:	e42d                	bnez	s0,ffffffffc0208db2 <stdin_io+0x140>
ffffffffc0208d4a:	c519                	beqz	a0,ffffffffc0208d58 <stdin_io+0xe6>
ffffffffc0208d4c:	018ab783          	ld	a5,24(s5)
ffffffffc0208d50:	414787b3          	sub	a5,a5,s4
ffffffffc0208d54:	00fabc23          	sd	a5,24(s5)
ffffffffc0208d58:	74e6                	ld	s1,120(sp)
ffffffffc0208d5a:	7946                	ld	s2,112(sp)
ffffffffc0208d5c:	79a6                	ld	s3,104(sp)
ffffffffc0208d5e:	7a06                	ld	s4,96(sp)
ffffffffc0208d60:	6c06                	ld	s8,64(sp)
ffffffffc0208d62:	60aa                	ld	ra,136(sp)
ffffffffc0208d64:	640a                	ld	s0,128(sp)
ffffffffc0208d66:	6ae6                	ld	s5,88(sp)
ffffffffc0208d68:	6b46                	ld	s6,80(sp)
ffffffffc0208d6a:	6ba6                	ld	s7,72(sp)
ffffffffc0208d6c:	6149                	addi	sp,sp,144
ffffffffc0208d6e:	8082                	ret
ffffffffc0208d70:	43f7d693          	srai	a3,a5,0x3f
ffffffffc0208d74:	92d1                	srli	a3,a3,0x34
ffffffffc0208d76:	00d78733          	add	a4,a5,a3
ffffffffc0208d7a:	01877733          	and	a4,a4,s8
ffffffffc0208d7e:	8f15                	sub	a4,a4,a3
ffffffffc0208d80:	0008d697          	auipc	a3,0x8d
ffffffffc0208d84:	ae868693          	addi	a3,a3,-1304 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208d88:	9736                	add	a4,a4,a3
ffffffffc0208d8a:	00074683          	lbu	a3,0(a4)
ffffffffc0208d8e:	0785                	addi	a5,a5,1
ffffffffc0208d90:	014b8733          	add	a4,s7,s4
ffffffffc0208d94:	001a051b          	addiw	a0,s4,1
ffffffffc0208d98:	00f93023          	sd	a5,0(s2)
ffffffffc0208d9c:	00d70023          	sb	a3,0(a4)
ffffffffc0208da0:	0a05                	addi	s4,s4,1
ffffffffc0208da2:	f36a63e3          	bltu	s4,s6,ffffffffc0208cc8 <stdin_io+0x56>
ffffffffc0208da6:	d05d                	beqz	s0,ffffffffc0208d4c <stdin_io+0xda>
ffffffffc0208da8:	e42a                	sd	a0,8(sp)
ffffffffc0208daa:	e29f70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0208dae:	6522                	ld	a0,8(sp)
ffffffffc0208db0:	bf71                	j	ffffffffc0208d4c <stdin_io+0xda>
ffffffffc0208db2:	e42a                	sd	a0,8(sp)
ffffffffc0208db4:	e1ff70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0208db8:	6522                	ld	a0,8(sp)
ffffffffc0208dba:	f949                	bnez	a0,ffffffffc0208d4c <stdin_io+0xda>
ffffffffc0208dbc:	bf71                	j	ffffffffc0208d58 <stdin_io+0xe6>
ffffffffc0208dbe:	e1bf70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0208dc2:	4405                	li	s0,1
ffffffffc0208dc4:	ec0b1ce3          	bnez	s6,ffffffffc0208c9c <stdin_io+0x2a>
ffffffffc0208dc8:	e0bf70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0208dcc:	4501                	li	a0,0
ffffffffc0208dce:	bf51                	j	ffffffffc0208d62 <stdin_io+0xf0>
ffffffffc0208dd0:	5575                	li	a0,-3
ffffffffc0208dd2:	8082                	ret

ffffffffc0208dd4 <dev_stdin_write>:
ffffffffc0208dd4:	e111                	bnez	a0,ffffffffc0208dd8 <dev_stdin_write+0x4>
ffffffffc0208dd6:	8082                	ret
ffffffffc0208dd8:	1101                	addi	sp,sp,-32
ffffffffc0208dda:	ec06                	sd	ra,24(sp)
ffffffffc0208ddc:	e822                	sd	s0,16(sp)
ffffffffc0208dde:	100027f3          	csrr	a5,sstatus
ffffffffc0208de2:	8b89                	andi	a5,a5,2
ffffffffc0208de4:	4401                	li	s0,0
ffffffffc0208de6:	e3c1                	bnez	a5,ffffffffc0208e66 <dev_stdin_write+0x92>
ffffffffc0208de8:	0008e717          	auipc	a4,0x8e
ffffffffc0208dec:	b1873703          	ld	a4,-1256(a4) # ffffffffc0296900 <p_wpos>
ffffffffc0208df0:	6585                	lui	a1,0x1
ffffffffc0208df2:	fff58613          	addi	a2,a1,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208df6:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208dfa:	92d1                	srli	a3,a3,0x34
ffffffffc0208dfc:	00d707b3          	add	a5,a4,a3
ffffffffc0208e00:	8ff1                	and	a5,a5,a2
ffffffffc0208e02:	0008e617          	auipc	a2,0x8e
ffffffffc0208e06:	b0663603          	ld	a2,-1274(a2) # ffffffffc0296908 <p_rpos>
ffffffffc0208e0a:	8f95                	sub	a5,a5,a3
ffffffffc0208e0c:	0008d697          	auipc	a3,0x8d
ffffffffc0208e10:	a5c68693          	addi	a3,a3,-1444 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208e14:	97b6                	add	a5,a5,a3
ffffffffc0208e16:	00a78023          	sb	a0,0(a5)
ffffffffc0208e1a:	40c707b3          	sub	a5,a4,a2
ffffffffc0208e1e:	00b7d763          	bge	a5,a1,ffffffffc0208e2c <dev_stdin_write+0x58>
ffffffffc0208e22:	0705                	addi	a4,a4,1
ffffffffc0208e24:	0008e797          	auipc	a5,0x8e
ffffffffc0208e28:	ace7be23          	sd	a4,-1316(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208e2c:	0008d517          	auipc	a0,0x8d
ffffffffc0208e30:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0295858 <__wait_queue>
ffffffffc0208e34:	847fb0ef          	jal	ffffffffc020467a <wait_queue_empty>
ffffffffc0208e38:	c919                	beqz	a0,ffffffffc0208e4e <dev_stdin_write+0x7a>
ffffffffc0208e3a:	e409                	bnez	s0,ffffffffc0208e44 <dev_stdin_write+0x70>
ffffffffc0208e3c:	60e2                	ld	ra,24(sp)
ffffffffc0208e3e:	6442                	ld	s0,16(sp)
ffffffffc0208e40:	6105                	addi	sp,sp,32
ffffffffc0208e42:	8082                	ret
ffffffffc0208e44:	6442                	ld	s0,16(sp)
ffffffffc0208e46:	60e2                	ld	ra,24(sp)
ffffffffc0208e48:	6105                	addi	sp,sp,32
ffffffffc0208e4a:	d89f706f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0208e4e:	800005b7          	lui	a1,0x80000
ffffffffc0208e52:	0591                	addi	a1,a1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208e54:	4605                	li	a2,1
ffffffffc0208e56:	0008d517          	auipc	a0,0x8d
ffffffffc0208e5a:	a0250513          	addi	a0,a0,-1534 # ffffffffc0295858 <__wait_queue>
ffffffffc0208e5e:	885fb0ef          	jal	ffffffffc02046e2 <wakeup_queue>
ffffffffc0208e62:	dc69                	beqz	s0,ffffffffc0208e3c <dev_stdin_write+0x68>
ffffffffc0208e64:	b7c5                	j	ffffffffc0208e44 <dev_stdin_write+0x70>
ffffffffc0208e66:	e42a                	sd	a0,8(sp)
ffffffffc0208e68:	d71f70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0208e6c:	6522                	ld	a0,8(sp)
ffffffffc0208e6e:	4405                	li	s0,1
ffffffffc0208e70:	bfa5                	j	ffffffffc0208de8 <dev_stdin_write+0x14>

ffffffffc0208e72 <dev_init_stdin>:
ffffffffc0208e72:	1101                	addi	sp,sp,-32
ffffffffc0208e74:	ec06                	sd	ra,24(sp)
ffffffffc0208e76:	ac7ff0ef          	jal	ffffffffc020893c <dev_create_inode>
ffffffffc0208e7a:	c935                	beqz	a0,ffffffffc0208eee <dev_init_stdin+0x7c>
ffffffffc0208e7c:	4d38                	lw	a4,88(a0)
ffffffffc0208e7e:	6785                	lui	a5,0x1
ffffffffc0208e80:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e84:	08f71e63          	bne	a4,a5,ffffffffc0208f20 <dev_init_stdin+0xae>
ffffffffc0208e88:	4785                	li	a5,1
ffffffffc0208e8a:	e51c                	sd	a5,8(a0)
ffffffffc0208e8c:	00000797          	auipc	a5,0x0
ffffffffc0208e90:	dd478793          	addi	a5,a5,-556 # ffffffffc0208c60 <stdin_open>
ffffffffc0208e94:	e91c                	sd	a5,16(a0)
ffffffffc0208e96:	00000797          	auipc	a5,0x0
ffffffffc0208e9a:	dd478793          	addi	a5,a5,-556 # ffffffffc0208c6a <stdin_close>
ffffffffc0208e9e:	ed1c                	sd	a5,24(a0)
ffffffffc0208ea0:	00000797          	auipc	a5,0x0
ffffffffc0208ea4:	dd278793          	addi	a5,a5,-558 # ffffffffc0208c72 <stdin_io>
ffffffffc0208ea8:	f11c                	sd	a5,32(a0)
ffffffffc0208eaa:	00000797          	auipc	a5,0x0
ffffffffc0208eae:	dc478793          	addi	a5,a5,-572 # ffffffffc0208c6e <stdin_ioctl>
ffffffffc0208eb2:	f51c                	sd	a5,40(a0)
ffffffffc0208eb4:	00053023          	sd	zero,0(a0)
ffffffffc0208eb8:	e42a                	sd	a0,8(sp)
ffffffffc0208eba:	0008d517          	auipc	a0,0x8d
ffffffffc0208ebe:	99e50513          	addi	a0,a0,-1634 # ffffffffc0295858 <__wait_queue>
ffffffffc0208ec2:	0008e797          	auipc	a5,0x8e
ffffffffc0208ec6:	a207bf23          	sd	zero,-1474(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208eca:	0008e797          	auipc	a5,0x8e
ffffffffc0208ece:	a207bf23          	sd	zero,-1474(a5) # ffffffffc0296908 <p_rpos>
ffffffffc0208ed2:	f54fb0ef          	jal	ffffffffc0204626 <wait_queue_init>
ffffffffc0208ed6:	65a2                	ld	a1,8(sp)
ffffffffc0208ed8:	4601                	li	a2,0
ffffffffc0208eda:	00005517          	auipc	a0,0x5
ffffffffc0208ede:	62e50513          	addi	a0,a0,1582 # ffffffffc020e508 <etext+0x2d44>
ffffffffc0208ee2:	912ff0ef          	jal	ffffffffc0207ff4 <vfs_add_dev>
ffffffffc0208ee6:	e105                	bnez	a0,ffffffffc0208f06 <dev_init_stdin+0x94>
ffffffffc0208ee8:	60e2                	ld	ra,24(sp)
ffffffffc0208eea:	6105                	addi	sp,sp,32
ffffffffc0208eec:	8082                	ret
ffffffffc0208eee:	00005617          	auipc	a2,0x5
ffffffffc0208ef2:	5da60613          	addi	a2,a2,1498 # ffffffffc020e4c8 <etext+0x2d04>
ffffffffc0208ef6:	07500593          	li	a1,117
ffffffffc0208efa:	00005517          	auipc	a0,0x5
ffffffffc0208efe:	5ee50513          	addi	a0,a0,1518 # ffffffffc020e4e8 <etext+0x2d24>
ffffffffc0208f02:	d48f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208f06:	86aa                	mv	a3,a0
ffffffffc0208f08:	00005617          	auipc	a2,0x5
ffffffffc0208f0c:	60860613          	addi	a2,a2,1544 # ffffffffc020e510 <etext+0x2d4c>
ffffffffc0208f10:	07b00593          	li	a1,123
ffffffffc0208f14:	00005517          	auipc	a0,0x5
ffffffffc0208f18:	5d450513          	addi	a0,a0,1492 # ffffffffc020e4e8 <etext+0x2d24>
ffffffffc0208f1c:	d2ef70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208f20:	00005697          	auipc	a3,0x5
ffffffffc0208f24:	0d068693          	addi	a3,a3,208 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0208f28:	00003617          	auipc	a2,0x3
ffffffffc0208f2c:	cd860613          	addi	a2,a2,-808 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0208f30:	07700593          	li	a1,119
ffffffffc0208f34:	00005517          	auipc	a0,0x5
ffffffffc0208f38:	5b450513          	addi	a0,a0,1460 # ffffffffc020e4e8 <etext+0x2d24>
ffffffffc0208f3c:	d0ef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208f40 <stdout_open>:
ffffffffc0208f40:	4785                	li	a5,1
ffffffffc0208f42:	00f59463          	bne	a1,a5,ffffffffc0208f4a <stdout_open+0xa>
ffffffffc0208f46:	4501                	li	a0,0
ffffffffc0208f48:	8082                	ret
ffffffffc0208f4a:	5575                	li	a0,-3
ffffffffc0208f4c:	8082                	ret

ffffffffc0208f4e <stdout_close>:
ffffffffc0208f4e:	4501                	li	a0,0
ffffffffc0208f50:	8082                	ret

ffffffffc0208f52 <stdout_ioctl>:
ffffffffc0208f52:	5575                	li	a0,-3
ffffffffc0208f54:	8082                	ret

ffffffffc0208f56 <stdout_io>:
ffffffffc0208f56:	ca15                	beqz	a2,ffffffffc0208f8a <stdout_io+0x34>
ffffffffc0208f58:	6d9c                	ld	a5,24(a1)
ffffffffc0208f5a:	c795                	beqz	a5,ffffffffc0208f86 <stdout_io+0x30>
ffffffffc0208f5c:	1101                	addi	sp,sp,-32
ffffffffc0208f5e:	e822                	sd	s0,16(sp)
ffffffffc0208f60:	6180                	ld	s0,0(a1)
ffffffffc0208f62:	e426                	sd	s1,8(sp)
ffffffffc0208f64:	ec06                	sd	ra,24(sp)
ffffffffc0208f66:	84ae                	mv	s1,a1
ffffffffc0208f68:	00044503          	lbu	a0,0(s0)
ffffffffc0208f6c:	0405                	addi	s0,s0,1
ffffffffc0208f6e:	a72f70ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc0208f72:	6c9c                	ld	a5,24(s1)
ffffffffc0208f74:	17fd                	addi	a5,a5,-1
ffffffffc0208f76:	ec9c                	sd	a5,24(s1)
ffffffffc0208f78:	fbe5                	bnez	a5,ffffffffc0208f68 <stdout_io+0x12>
ffffffffc0208f7a:	60e2                	ld	ra,24(sp)
ffffffffc0208f7c:	6442                	ld	s0,16(sp)
ffffffffc0208f7e:	64a2                	ld	s1,8(sp)
ffffffffc0208f80:	4501                	li	a0,0
ffffffffc0208f82:	6105                	addi	sp,sp,32
ffffffffc0208f84:	8082                	ret
ffffffffc0208f86:	4501                	li	a0,0
ffffffffc0208f88:	8082                	ret
ffffffffc0208f8a:	5575                	li	a0,-3
ffffffffc0208f8c:	8082                	ret

ffffffffc0208f8e <dev_init_stdout>:
ffffffffc0208f8e:	1141                	addi	sp,sp,-16
ffffffffc0208f90:	e406                	sd	ra,8(sp)
ffffffffc0208f92:	9abff0ef          	jal	ffffffffc020893c <dev_create_inode>
ffffffffc0208f96:	c939                	beqz	a0,ffffffffc0208fec <dev_init_stdout+0x5e>
ffffffffc0208f98:	4d38                	lw	a4,88(a0)
ffffffffc0208f9a:	6785                	lui	a5,0x1
ffffffffc0208f9c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208fa0:	06f71f63          	bne	a4,a5,ffffffffc020901e <dev_init_stdout+0x90>
ffffffffc0208fa4:	4785                	li	a5,1
ffffffffc0208fa6:	e51c                	sd	a5,8(a0)
ffffffffc0208fa8:	00000797          	auipc	a5,0x0
ffffffffc0208fac:	f9878793          	addi	a5,a5,-104 # ffffffffc0208f40 <stdout_open>
ffffffffc0208fb0:	e91c                	sd	a5,16(a0)
ffffffffc0208fb2:	00000797          	auipc	a5,0x0
ffffffffc0208fb6:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208f4e <stdout_close>
ffffffffc0208fba:	ed1c                	sd	a5,24(a0)
ffffffffc0208fbc:	00000797          	auipc	a5,0x0
ffffffffc0208fc0:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208f56 <stdout_io>
ffffffffc0208fc4:	f11c                	sd	a5,32(a0)
ffffffffc0208fc6:	00000797          	auipc	a5,0x0
ffffffffc0208fca:	f8c78793          	addi	a5,a5,-116 # ffffffffc0208f52 <stdout_ioctl>
ffffffffc0208fce:	f51c                	sd	a5,40(a0)
ffffffffc0208fd0:	00053023          	sd	zero,0(a0)
ffffffffc0208fd4:	85aa                	mv	a1,a0
ffffffffc0208fd6:	4601                	li	a2,0
ffffffffc0208fd8:	00005517          	auipc	a0,0x5
ffffffffc0208fdc:	59850513          	addi	a0,a0,1432 # ffffffffc020e570 <etext+0x2dac>
ffffffffc0208fe0:	814ff0ef          	jal	ffffffffc0207ff4 <vfs_add_dev>
ffffffffc0208fe4:	e105                	bnez	a0,ffffffffc0209004 <dev_init_stdout+0x76>
ffffffffc0208fe6:	60a2                	ld	ra,8(sp)
ffffffffc0208fe8:	0141                	addi	sp,sp,16
ffffffffc0208fea:	8082                	ret
ffffffffc0208fec:	00005617          	auipc	a2,0x5
ffffffffc0208ff0:	54460613          	addi	a2,a2,1348 # ffffffffc020e530 <etext+0x2d6c>
ffffffffc0208ff4:	03700593          	li	a1,55
ffffffffc0208ff8:	00005517          	auipc	a0,0x5
ffffffffc0208ffc:	55850513          	addi	a0,a0,1368 # ffffffffc020e550 <etext+0x2d8c>
ffffffffc0209000:	c4af70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209004:	86aa                	mv	a3,a0
ffffffffc0209006:	00005617          	auipc	a2,0x5
ffffffffc020900a:	57260613          	addi	a2,a2,1394 # ffffffffc020e578 <etext+0x2db4>
ffffffffc020900e:	03d00593          	li	a1,61
ffffffffc0209012:	00005517          	auipc	a0,0x5
ffffffffc0209016:	53e50513          	addi	a0,a0,1342 # ffffffffc020e550 <etext+0x2d8c>
ffffffffc020901a:	c30f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020901e:	00005697          	auipc	a3,0x5
ffffffffc0209022:	fd268693          	addi	a3,a3,-46 # ffffffffc020dff0 <etext+0x282c>
ffffffffc0209026:	00003617          	auipc	a2,0x3
ffffffffc020902a:	bda60613          	addi	a2,a2,-1062 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020902e:	03900593          	li	a1,57
ffffffffc0209032:	00005517          	auipc	a0,0x5
ffffffffc0209036:	51e50513          	addi	a0,a0,1310 # ffffffffc020e550 <etext+0x2d8c>
ffffffffc020903a:	c10f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020903e <bitmap_translate.part.0>:
ffffffffc020903e:	1141                	addi	sp,sp,-16
ffffffffc0209040:	00005697          	auipc	a3,0x5
ffffffffc0209044:	55868693          	addi	a3,a3,1368 # ffffffffc020e598 <etext+0x2dd4>
ffffffffc0209048:	00003617          	auipc	a2,0x3
ffffffffc020904c:	bb860613          	addi	a2,a2,-1096 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209050:	04c00593          	li	a1,76
ffffffffc0209054:	00005517          	auipc	a0,0x5
ffffffffc0209058:	55c50513          	addi	a0,a0,1372 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc020905c:	e406                	sd	ra,8(sp)
ffffffffc020905e:	becf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209062 <bitmap_create>:
ffffffffc0209062:	7139                	addi	sp,sp,-64
ffffffffc0209064:	fc06                	sd	ra,56(sp)
ffffffffc0209066:	f822                	sd	s0,48(sp)
ffffffffc0209068:	f426                	sd	s1,40(sp)
ffffffffc020906a:	c179                	beqz	a0,ffffffffc0209130 <bitmap_create+0xce>
ffffffffc020906c:	842a                	mv	s0,a0
ffffffffc020906e:	4541                	li	a0,16
ffffffffc0209070:	f51f80ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0209074:	84aa                	mv	s1,a0
ffffffffc0209076:	c555                	beqz	a0,ffffffffc0209122 <bitmap_create+0xc0>
ffffffffc0209078:	e852                	sd	s4,16(sp)
ffffffffc020907a:	02041a13          	slli	s4,s0,0x20
ffffffffc020907e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0209082:	f04a                	sd	s2,32(sp)
ffffffffc0209084:	01fa0913          	addi	s2,s4,31
ffffffffc0209088:	ec4e                	sd	s3,24(sp)
ffffffffc020908a:	00595993          	srli	s3,s2,0x5
ffffffffc020908e:	00299613          	slli	a2,s3,0x2
ffffffffc0209092:	8532                	mv	a0,a2
ffffffffc0209094:	e432                	sd	a2,8(sp)
ffffffffc0209096:	f2bf80ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020909a:	6622                	ld	a2,8(sp)
ffffffffc020909c:	cd2d                	beqz	a0,ffffffffc0209116 <bitmap_create+0xb4>
ffffffffc020909e:	c080                	sw	s0,0(s1)
ffffffffc02090a0:	0134a223          	sw	s3,4(s1)
ffffffffc02090a4:	0ff00593          	li	a1,255
ffffffffc02090a8:	6b4020ef          	jal	ffffffffc020b75c <memset>
ffffffffc02090ac:	4785                	li	a5,1
ffffffffc02090ae:	1796                	slli	a5,a5,0x25
ffffffffc02090b0:	1781                	addi	a5,a5,-32
ffffffffc02090b2:	e488                	sd	a0,8(s1)
ffffffffc02090b4:	00f97933          	and	s2,s2,a5
ffffffffc02090b8:	052a0663          	beq	s4,s2,ffffffffc0209104 <bitmap_create+0xa2>
ffffffffc02090bc:	39fd                	addiw	s3,s3,-1
ffffffffc02090be:	0054571b          	srliw	a4,s0,0x5
ffffffffc02090c2:	0b371963          	bne	a4,s3,ffffffffc0209174 <bitmap_create+0x112>
ffffffffc02090c6:	0057179b          	slliw	a5,a4,0x5
ffffffffc02090ca:	40f407bb          	subw	a5,s0,a5
ffffffffc02090ce:	fff7861b          	addiw	a2,a5,-1
ffffffffc02090d2:	46f9                	li	a3,30
ffffffffc02090d4:	08c6e063          	bltu	a3,a2,ffffffffc0209154 <bitmap_create+0xf2>
ffffffffc02090d8:	070a                	slli	a4,a4,0x2
ffffffffc02090da:	953a                	add	a0,a0,a4
ffffffffc02090dc:	4118                	lw	a4,0(a0)
ffffffffc02090de:	4585                	li	a1,1
ffffffffc02090e0:	02000613          	li	a2,32
ffffffffc02090e4:	00f596bb          	sllw	a3,a1,a5
ffffffffc02090e8:	2785                	addiw	a5,a5,1
ffffffffc02090ea:	8f35                	xor	a4,a4,a3
ffffffffc02090ec:	fec79ce3          	bne	a5,a2,ffffffffc02090e4 <bitmap_create+0x82>
ffffffffc02090f0:	7442                	ld	s0,48(sp)
ffffffffc02090f2:	70e2                	ld	ra,56(sp)
ffffffffc02090f4:	c118                	sw	a4,0(a0)
ffffffffc02090f6:	7902                	ld	s2,32(sp)
ffffffffc02090f8:	69e2                	ld	s3,24(sp)
ffffffffc02090fa:	6a42                	ld	s4,16(sp)
ffffffffc02090fc:	8526                	mv	a0,s1
ffffffffc02090fe:	74a2                	ld	s1,40(sp)
ffffffffc0209100:	6121                	addi	sp,sp,64
ffffffffc0209102:	8082                	ret
ffffffffc0209104:	7442                	ld	s0,48(sp)
ffffffffc0209106:	70e2                	ld	ra,56(sp)
ffffffffc0209108:	7902                	ld	s2,32(sp)
ffffffffc020910a:	69e2                	ld	s3,24(sp)
ffffffffc020910c:	6a42                	ld	s4,16(sp)
ffffffffc020910e:	8526                	mv	a0,s1
ffffffffc0209110:	74a2                	ld	s1,40(sp)
ffffffffc0209112:	6121                	addi	sp,sp,64
ffffffffc0209114:	8082                	ret
ffffffffc0209116:	8526                	mv	a0,s1
ffffffffc0209118:	f4ff80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020911c:	7902                	ld	s2,32(sp)
ffffffffc020911e:	69e2                	ld	s3,24(sp)
ffffffffc0209120:	6a42                	ld	s4,16(sp)
ffffffffc0209122:	7442                	ld	s0,48(sp)
ffffffffc0209124:	70e2                	ld	ra,56(sp)
ffffffffc0209126:	4481                	li	s1,0
ffffffffc0209128:	8526                	mv	a0,s1
ffffffffc020912a:	74a2                	ld	s1,40(sp)
ffffffffc020912c:	6121                	addi	sp,sp,64
ffffffffc020912e:	8082                	ret
ffffffffc0209130:	00005697          	auipc	a3,0x5
ffffffffc0209134:	49868693          	addi	a3,a3,1176 # ffffffffc020e5c8 <etext+0x2e04>
ffffffffc0209138:	00003617          	auipc	a2,0x3
ffffffffc020913c:	ac860613          	addi	a2,a2,-1336 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209140:	45d5                	li	a1,21
ffffffffc0209142:	00005517          	auipc	a0,0x5
ffffffffc0209146:	46e50513          	addi	a0,a0,1134 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc020914a:	f04a                	sd	s2,32(sp)
ffffffffc020914c:	ec4e                	sd	s3,24(sp)
ffffffffc020914e:	e852                	sd	s4,16(sp)
ffffffffc0209150:	afaf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209154:	00005697          	auipc	a3,0x5
ffffffffc0209158:	4b468693          	addi	a3,a3,1204 # ffffffffc020e608 <etext+0x2e44>
ffffffffc020915c:	00003617          	auipc	a2,0x3
ffffffffc0209160:	aa460613          	addi	a2,a2,-1372 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209164:	02b00593          	li	a1,43
ffffffffc0209168:	00005517          	auipc	a0,0x5
ffffffffc020916c:	44850513          	addi	a0,a0,1096 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc0209170:	adaf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209174:	00005697          	auipc	a3,0x5
ffffffffc0209178:	47c68693          	addi	a3,a3,1148 # ffffffffc020e5f0 <etext+0x2e2c>
ffffffffc020917c:	00003617          	auipc	a2,0x3
ffffffffc0209180:	a8460613          	addi	a2,a2,-1404 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209184:	02a00593          	li	a1,42
ffffffffc0209188:	00005517          	auipc	a0,0x5
ffffffffc020918c:	42850513          	addi	a0,a0,1064 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc0209190:	abaf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209194 <bitmap_alloc>:
ffffffffc0209194:	4150                	lw	a2,4(a0)
ffffffffc0209196:	c229                	beqz	a2,ffffffffc02091d8 <bitmap_alloc+0x44>
ffffffffc0209198:	6518                	ld	a4,8(a0)
ffffffffc020919a:	4781                	li	a5,0
ffffffffc020919c:	a029                	j	ffffffffc02091a6 <bitmap_alloc+0x12>
ffffffffc020919e:	2785                	addiw	a5,a5,1
ffffffffc02091a0:	0711                	addi	a4,a4,4
ffffffffc02091a2:	02f60b63          	beq	a2,a5,ffffffffc02091d8 <bitmap_alloc+0x44>
ffffffffc02091a6:	4314                	lw	a3,0(a4)
ffffffffc02091a8:	dafd                	beqz	a3,ffffffffc020919e <bitmap_alloc+0xa>
ffffffffc02091aa:	0016f613          	andi	a2,a3,1
ffffffffc02091ae:	ea29                	bnez	a2,ffffffffc0209200 <bitmap_alloc+0x6c>
ffffffffc02091b0:	02000893          	li	a7,32
ffffffffc02091b4:	4305                	li	t1,1
ffffffffc02091b6:	2605                	addiw	a2,a2,1
ffffffffc02091b8:	03160263          	beq	a2,a7,ffffffffc02091dc <bitmap_alloc+0x48>
ffffffffc02091bc:	00c3153b          	sllw	a0,t1,a2
ffffffffc02091c0:	00a6f833          	and	a6,a3,a0
ffffffffc02091c4:	fe0809e3          	beqz	a6,ffffffffc02091b6 <bitmap_alloc+0x22>
ffffffffc02091c8:	8ea9                	xor	a3,a3,a0
ffffffffc02091ca:	0057979b          	slliw	a5,a5,0x5
ffffffffc02091ce:	c314                	sw	a3,0(a4)
ffffffffc02091d0:	9fb1                	addw	a5,a5,a2
ffffffffc02091d2:	c19c                	sw	a5,0(a1)
ffffffffc02091d4:	4501                	li	a0,0
ffffffffc02091d6:	8082                	ret
ffffffffc02091d8:	5571                	li	a0,-4
ffffffffc02091da:	8082                	ret
ffffffffc02091dc:	1141                	addi	sp,sp,-16
ffffffffc02091de:	00005697          	auipc	a3,0x5
ffffffffc02091e2:	45268693          	addi	a3,a3,1106 # ffffffffc020e630 <etext+0x2e6c>
ffffffffc02091e6:	00003617          	auipc	a2,0x3
ffffffffc02091ea:	a1a60613          	addi	a2,a2,-1510 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02091ee:	04300593          	li	a1,67
ffffffffc02091f2:	00005517          	auipc	a0,0x5
ffffffffc02091f6:	3be50513          	addi	a0,a0,958 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc02091fa:	e406                	sd	ra,8(sp)
ffffffffc02091fc:	a4ef70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209200:	8532                	mv	a0,a2
ffffffffc0209202:	4601                	li	a2,0
ffffffffc0209204:	b7d1                	j	ffffffffc02091c8 <bitmap_alloc+0x34>

ffffffffc0209206 <bitmap_test>:
ffffffffc0209206:	411c                	lw	a5,0(a0)
ffffffffc0209208:	00f5ff63          	bgeu	a1,a5,ffffffffc0209226 <bitmap_test+0x20>
ffffffffc020920c:	651c                	ld	a5,8(a0)
ffffffffc020920e:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209212:	070a                	slli	a4,a4,0x2
ffffffffc0209214:	97ba                	add	a5,a5,a4
ffffffffc0209216:	439c                	lw	a5,0(a5)
ffffffffc0209218:	4505                	li	a0,1
ffffffffc020921a:	00b5153b          	sllw	a0,a0,a1
ffffffffc020921e:	8d7d                	and	a0,a0,a5
ffffffffc0209220:	1502                	slli	a0,a0,0x20
ffffffffc0209222:	9101                	srli	a0,a0,0x20
ffffffffc0209224:	8082                	ret
ffffffffc0209226:	1141                	addi	sp,sp,-16
ffffffffc0209228:	e406                	sd	ra,8(sp)
ffffffffc020922a:	e15ff0ef          	jal	ffffffffc020903e <bitmap_translate.part.0>

ffffffffc020922e <bitmap_free>:
ffffffffc020922e:	411c                	lw	a5,0(a0)
ffffffffc0209230:	1141                	addi	sp,sp,-16
ffffffffc0209232:	e406                	sd	ra,8(sp)
ffffffffc0209234:	02f5f363          	bgeu	a1,a5,ffffffffc020925a <bitmap_free+0x2c>
ffffffffc0209238:	651c                	ld	a5,8(a0)
ffffffffc020923a:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020923e:	070a                	slli	a4,a4,0x2
ffffffffc0209240:	97ba                	add	a5,a5,a4
ffffffffc0209242:	4394                	lw	a3,0(a5)
ffffffffc0209244:	4705                	li	a4,1
ffffffffc0209246:	00b715bb          	sllw	a1,a4,a1
ffffffffc020924a:	00b6f733          	and	a4,a3,a1
ffffffffc020924e:	eb01                	bnez	a4,ffffffffc020925e <bitmap_free+0x30>
ffffffffc0209250:	60a2                	ld	ra,8(sp)
ffffffffc0209252:	8ecd                	or	a3,a3,a1
ffffffffc0209254:	c394                	sw	a3,0(a5)
ffffffffc0209256:	0141                	addi	sp,sp,16
ffffffffc0209258:	8082                	ret
ffffffffc020925a:	de5ff0ef          	jal	ffffffffc020903e <bitmap_translate.part.0>
ffffffffc020925e:	00005697          	auipc	a3,0x5
ffffffffc0209262:	3da68693          	addi	a3,a3,986 # ffffffffc020e638 <etext+0x2e74>
ffffffffc0209266:	00003617          	auipc	a2,0x3
ffffffffc020926a:	99a60613          	addi	a2,a2,-1638 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020926e:	05f00593          	li	a1,95
ffffffffc0209272:	00005517          	auipc	a0,0x5
ffffffffc0209276:	33e50513          	addi	a0,a0,830 # ffffffffc020e5b0 <etext+0x2dec>
ffffffffc020927a:	9d0f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020927e <bitmap_destroy>:
ffffffffc020927e:	1141                	addi	sp,sp,-16
ffffffffc0209280:	e022                	sd	s0,0(sp)
ffffffffc0209282:	842a                	mv	s0,a0
ffffffffc0209284:	6508                	ld	a0,8(a0)
ffffffffc0209286:	e406                	sd	ra,8(sp)
ffffffffc0209288:	ddff80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020928c:	8522                	mv	a0,s0
ffffffffc020928e:	6402                	ld	s0,0(sp)
ffffffffc0209290:	60a2                	ld	ra,8(sp)
ffffffffc0209292:	0141                	addi	sp,sp,16
ffffffffc0209294:	dd3f806f          	j	ffffffffc0202066 <kfree>

ffffffffc0209298 <bitmap_getdata>:
ffffffffc0209298:	c589                	beqz	a1,ffffffffc02092a2 <bitmap_getdata+0xa>
ffffffffc020929a:	00456783          	lwu	a5,4(a0)
ffffffffc020929e:	078a                	slli	a5,a5,0x2
ffffffffc02092a0:	e19c                	sd	a5,0(a1)
ffffffffc02092a2:	6508                	ld	a0,8(a0)
ffffffffc02092a4:	8082                	ret

ffffffffc02092a6 <sfs_init>:
ffffffffc02092a6:	1141                	addi	sp,sp,-16
ffffffffc02092a8:	00005517          	auipc	a0,0x5
ffffffffc02092ac:	1f850513          	addi	a0,a0,504 # ffffffffc020e4a0 <etext+0x2cdc>
ffffffffc02092b0:	e406                	sd	ra,8(sp)
ffffffffc02092b2:	576000ef          	jal	ffffffffc0209828 <sfs_mount>
ffffffffc02092b6:	e501                	bnez	a0,ffffffffc02092be <sfs_init+0x18>
ffffffffc02092b8:	60a2                	ld	ra,8(sp)
ffffffffc02092ba:	0141                	addi	sp,sp,16
ffffffffc02092bc:	8082                	ret
ffffffffc02092be:	86aa                	mv	a3,a0
ffffffffc02092c0:	00005617          	auipc	a2,0x5
ffffffffc02092c4:	38860613          	addi	a2,a2,904 # ffffffffc020e648 <etext+0x2e84>
ffffffffc02092c8:	45c1                	li	a1,16
ffffffffc02092ca:	00005517          	auipc	a0,0x5
ffffffffc02092ce:	39e50513          	addi	a0,a0,926 # ffffffffc020e668 <etext+0x2ea4>
ffffffffc02092d2:	978f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02092d6 <sfs_unmount>:
ffffffffc02092d6:	1141                	addi	sp,sp,-16
ffffffffc02092d8:	e406                	sd	ra,8(sp)
ffffffffc02092da:	e022                	sd	s0,0(sp)
ffffffffc02092dc:	cd1d                	beqz	a0,ffffffffc020931a <sfs_unmount+0x44>
ffffffffc02092de:	0b052783          	lw	a5,176(a0)
ffffffffc02092e2:	842a                	mv	s0,a0
ffffffffc02092e4:	eb9d                	bnez	a5,ffffffffc020931a <sfs_unmount+0x44>
ffffffffc02092e6:	7158                	ld	a4,160(a0)
ffffffffc02092e8:	09850793          	addi	a5,a0,152
ffffffffc02092ec:	02f71563          	bne	a4,a5,ffffffffc0209316 <sfs_unmount+0x40>
ffffffffc02092f0:	613c                	ld	a5,64(a0)
ffffffffc02092f2:	e7a1                	bnez	a5,ffffffffc020933a <sfs_unmount+0x64>
ffffffffc02092f4:	7d08                	ld	a0,56(a0)
ffffffffc02092f6:	f89ff0ef          	jal	ffffffffc020927e <bitmap_destroy>
ffffffffc02092fa:	6428                	ld	a0,72(s0)
ffffffffc02092fc:	d6bf80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0209300:	7448                	ld	a0,168(s0)
ffffffffc0209302:	d65f80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0209306:	8522                	mv	a0,s0
ffffffffc0209308:	d5ff80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020930c:	4501                	li	a0,0
ffffffffc020930e:	60a2                	ld	ra,8(sp)
ffffffffc0209310:	6402                	ld	s0,0(sp)
ffffffffc0209312:	0141                	addi	sp,sp,16
ffffffffc0209314:	8082                	ret
ffffffffc0209316:	5545                	li	a0,-15
ffffffffc0209318:	bfdd                	j	ffffffffc020930e <sfs_unmount+0x38>
ffffffffc020931a:	00005697          	auipc	a3,0x5
ffffffffc020931e:	36668693          	addi	a3,a3,870 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc0209322:	00003617          	auipc	a2,0x3
ffffffffc0209326:	8de60613          	addi	a2,a2,-1826 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020932a:	04100593          	li	a1,65
ffffffffc020932e:	00005517          	auipc	a0,0x5
ffffffffc0209332:	38250513          	addi	a0,a0,898 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc0209336:	914f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020933a:	00005697          	auipc	a3,0x5
ffffffffc020933e:	38e68693          	addi	a3,a3,910 # ffffffffc020e6c8 <etext+0x2f04>
ffffffffc0209342:	00003617          	auipc	a2,0x3
ffffffffc0209346:	8be60613          	addi	a2,a2,-1858 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020934a:	04500593          	li	a1,69
ffffffffc020934e:	00005517          	auipc	a0,0x5
ffffffffc0209352:	36250513          	addi	a0,a0,866 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc0209356:	8f4f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020935a <sfs_cleanup>:
ffffffffc020935a:	1101                	addi	sp,sp,-32
ffffffffc020935c:	ec06                	sd	ra,24(sp)
ffffffffc020935e:	e426                	sd	s1,8(sp)
ffffffffc0209360:	c13d                	beqz	a0,ffffffffc02093c6 <sfs_cleanup+0x6c>
ffffffffc0209362:	0b052783          	lw	a5,176(a0)
ffffffffc0209366:	84aa                	mv	s1,a0
ffffffffc0209368:	efb9                	bnez	a5,ffffffffc02093c6 <sfs_cleanup+0x6c>
ffffffffc020936a:	4158                	lw	a4,4(a0)
ffffffffc020936c:	4514                	lw	a3,8(a0)
ffffffffc020936e:	00c50593          	addi	a1,a0,12
ffffffffc0209372:	00005517          	auipc	a0,0x5
ffffffffc0209376:	36e50513          	addi	a0,a0,878 # ffffffffc020e6e0 <etext+0x2f1c>
ffffffffc020937a:	40d7063b          	subw	a2,a4,a3
ffffffffc020937e:	e822                	sd	s0,16(sp)
ffffffffc0209380:	e27f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209384:	02000413          	li	s0,32
ffffffffc0209388:	a019                	j	ffffffffc020938e <sfs_cleanup+0x34>
ffffffffc020938a:	347d                	addiw	s0,s0,-1
ffffffffc020938c:	c811                	beqz	s0,ffffffffc02093a0 <sfs_cleanup+0x46>
ffffffffc020938e:	7cdc                	ld	a5,184(s1)
ffffffffc0209390:	8526                	mv	a0,s1
ffffffffc0209392:	9782                	jalr	a5
ffffffffc0209394:	f97d                	bnez	a0,ffffffffc020938a <sfs_cleanup+0x30>
ffffffffc0209396:	6442                	ld	s0,16(sp)
ffffffffc0209398:	60e2                	ld	ra,24(sp)
ffffffffc020939a:	64a2                	ld	s1,8(sp)
ffffffffc020939c:	6105                	addi	sp,sp,32
ffffffffc020939e:	8082                	ret
ffffffffc02093a0:	6442                	ld	s0,16(sp)
ffffffffc02093a2:	60e2                	ld	ra,24(sp)
ffffffffc02093a4:	00c48693          	addi	a3,s1,12
ffffffffc02093a8:	64a2                	ld	s1,8(sp)
ffffffffc02093aa:	872a                	mv	a4,a0
ffffffffc02093ac:	00005617          	auipc	a2,0x5
ffffffffc02093b0:	35460613          	addi	a2,a2,852 # ffffffffc020e700 <etext+0x2f3c>
ffffffffc02093b4:	05f00593          	li	a1,95
ffffffffc02093b8:	00005517          	auipc	a0,0x5
ffffffffc02093bc:	2f850513          	addi	a0,a0,760 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc02093c0:	6105                	addi	sp,sp,32
ffffffffc02093c2:	8f2f706f          	j	ffffffffc02004b4 <__warn>
ffffffffc02093c6:	00005697          	auipc	a3,0x5
ffffffffc02093ca:	2ba68693          	addi	a3,a3,698 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc02093ce:	00003617          	auipc	a2,0x3
ffffffffc02093d2:	83260613          	addi	a2,a2,-1998 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02093d6:	05400593          	li	a1,84
ffffffffc02093da:	00005517          	auipc	a0,0x5
ffffffffc02093de:	2d650513          	addi	a0,a0,726 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc02093e2:	e822                	sd	s0,16(sp)
ffffffffc02093e4:	e04a                	sd	s2,0(sp)
ffffffffc02093e6:	864f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02093ea <sfs_sync>:
ffffffffc02093ea:	7179                	addi	sp,sp,-48
ffffffffc02093ec:	f406                	sd	ra,40(sp)
ffffffffc02093ee:	e44e                	sd	s3,8(sp)
ffffffffc02093f0:	c94d                	beqz	a0,ffffffffc02094a2 <sfs_sync+0xb8>
ffffffffc02093f2:	0b052783          	lw	a5,176(a0)
ffffffffc02093f6:	89aa                	mv	s3,a0
ffffffffc02093f8:	e7cd                	bnez	a5,ffffffffc02094a2 <sfs_sync+0xb8>
ffffffffc02093fa:	f022                	sd	s0,32(sp)
ffffffffc02093fc:	e84a                	sd	s2,16(sp)
ffffffffc02093fe:	603010ef          	jal	ffffffffc020b200 <lock_sfs_fs>
ffffffffc0209402:	0a09b403          	ld	s0,160(s3)
ffffffffc0209406:	09898913          	addi	s2,s3,152
ffffffffc020940a:	02890663          	beq	s2,s0,ffffffffc0209436 <sfs_sync+0x4c>
ffffffffc020940e:	7c1c                	ld	a5,56(s0)
ffffffffc0209410:	cbad                	beqz	a5,ffffffffc0209482 <sfs_sync+0x98>
ffffffffc0209412:	7b9c                	ld	a5,48(a5)
ffffffffc0209414:	c7bd                	beqz	a5,ffffffffc0209482 <sfs_sync+0x98>
ffffffffc0209416:	fc840513          	addi	a0,s0,-56
ffffffffc020941a:	00004597          	auipc	a1,0x4
ffffffffc020941e:	0c658593          	addi	a1,a1,198 # ffffffffc020d4e0 <etext+0x1d1c>
ffffffffc0209422:	decfe0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0209426:	7c1c                	ld	a5,56(s0)
ffffffffc0209428:	fc840513          	addi	a0,s0,-56
ffffffffc020942c:	7b9c                	ld	a5,48(a5)
ffffffffc020942e:	9782                	jalr	a5
ffffffffc0209430:	6400                	ld	s0,8(s0)
ffffffffc0209432:	fc891ee3          	bne	s2,s0,ffffffffc020940e <sfs_sync+0x24>
ffffffffc0209436:	854e                	mv	a0,s3
ffffffffc0209438:	5d9010ef          	jal	ffffffffc020b210 <unlock_sfs_fs>
ffffffffc020943c:	0409b783          	ld	a5,64(s3)
ffffffffc0209440:	4501                	li	a0,0
ffffffffc0209442:	e799                	bnez	a5,ffffffffc0209450 <sfs_sync+0x66>
ffffffffc0209444:	7402                	ld	s0,32(sp)
ffffffffc0209446:	70a2                	ld	ra,40(sp)
ffffffffc0209448:	6942                	ld	s2,16(sp)
ffffffffc020944a:	69a2                	ld	s3,8(sp)
ffffffffc020944c:	6145                	addi	sp,sp,48
ffffffffc020944e:	8082                	ret
ffffffffc0209450:	0409b023          	sd	zero,64(s3)
ffffffffc0209454:	854e                	mv	a0,s3
ffffffffc0209456:	48b010ef          	jal	ffffffffc020b0e0 <sfs_sync_super>
ffffffffc020945a:	c911                	beqz	a0,ffffffffc020946e <sfs_sync+0x84>
ffffffffc020945c:	7402                	ld	s0,32(sp)
ffffffffc020945e:	70a2                	ld	ra,40(sp)
ffffffffc0209460:	4785                	li	a5,1
ffffffffc0209462:	04f9b023          	sd	a5,64(s3)
ffffffffc0209466:	6942                	ld	s2,16(sp)
ffffffffc0209468:	69a2                	ld	s3,8(sp)
ffffffffc020946a:	6145                	addi	sp,sp,48
ffffffffc020946c:	8082                	ret
ffffffffc020946e:	854e                	mv	a0,s3
ffffffffc0209470:	4b7010ef          	jal	ffffffffc020b126 <sfs_sync_freemap>
ffffffffc0209474:	f565                	bnez	a0,ffffffffc020945c <sfs_sync+0x72>
ffffffffc0209476:	7402                	ld	s0,32(sp)
ffffffffc0209478:	70a2                	ld	ra,40(sp)
ffffffffc020947a:	6942                	ld	s2,16(sp)
ffffffffc020947c:	69a2                	ld	s3,8(sp)
ffffffffc020947e:	6145                	addi	sp,sp,48
ffffffffc0209480:	8082                	ret
ffffffffc0209482:	00004697          	auipc	a3,0x4
ffffffffc0209486:	00e68693          	addi	a3,a3,14 # ffffffffc020d490 <etext+0x1ccc>
ffffffffc020948a:	00002617          	auipc	a2,0x2
ffffffffc020948e:	77660613          	addi	a2,a2,1910 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209492:	45ed                	li	a1,27
ffffffffc0209494:	00005517          	auipc	a0,0x5
ffffffffc0209498:	21c50513          	addi	a0,a0,540 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc020949c:	ec26                	sd	s1,24(sp)
ffffffffc020949e:	fadf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02094a2:	00005697          	auipc	a3,0x5
ffffffffc02094a6:	1de68693          	addi	a3,a3,478 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc02094aa:	00002617          	auipc	a2,0x2
ffffffffc02094ae:	75660613          	addi	a2,a2,1878 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02094b2:	45d5                	li	a1,21
ffffffffc02094b4:	00005517          	auipc	a0,0x5
ffffffffc02094b8:	1fc50513          	addi	a0,a0,508 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc02094bc:	f022                	sd	s0,32(sp)
ffffffffc02094be:	ec26                	sd	s1,24(sp)
ffffffffc02094c0:	e84a                	sd	s2,16(sp)
ffffffffc02094c2:	f89f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02094c6 <sfs_get_root>:
ffffffffc02094c6:	1101                	addi	sp,sp,-32
ffffffffc02094c8:	ec06                	sd	ra,24(sp)
ffffffffc02094ca:	cd09                	beqz	a0,ffffffffc02094e4 <sfs_get_root+0x1e>
ffffffffc02094cc:	0b052783          	lw	a5,176(a0)
ffffffffc02094d0:	eb91                	bnez	a5,ffffffffc02094e4 <sfs_get_root+0x1e>
ffffffffc02094d2:	4605                	li	a2,1
ffffffffc02094d4:	002c                	addi	a1,sp,8
ffffffffc02094d6:	368010ef          	jal	ffffffffc020a83e <sfs_load_inode>
ffffffffc02094da:	e50d                	bnez	a0,ffffffffc0209504 <sfs_get_root+0x3e>
ffffffffc02094dc:	60e2                	ld	ra,24(sp)
ffffffffc02094de:	6522                	ld	a0,8(sp)
ffffffffc02094e0:	6105                	addi	sp,sp,32
ffffffffc02094e2:	8082                	ret
ffffffffc02094e4:	00005697          	auipc	a3,0x5
ffffffffc02094e8:	19c68693          	addi	a3,a3,412 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc02094ec:	00002617          	auipc	a2,0x2
ffffffffc02094f0:	71460613          	addi	a2,a2,1812 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02094f4:	03600593          	li	a1,54
ffffffffc02094f8:	00005517          	auipc	a0,0x5
ffffffffc02094fc:	1b850513          	addi	a0,a0,440 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc0209500:	f4bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209504:	86aa                	mv	a3,a0
ffffffffc0209506:	00005617          	auipc	a2,0x5
ffffffffc020950a:	21a60613          	addi	a2,a2,538 # ffffffffc020e720 <etext+0x2f5c>
ffffffffc020950e:	03700593          	li	a1,55
ffffffffc0209512:	00005517          	auipc	a0,0x5
ffffffffc0209516:	19e50513          	addi	a0,a0,414 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc020951a:	f31f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020951e <sfs_do_mount>:
ffffffffc020951e:	7171                	addi	sp,sp,-176
ffffffffc0209520:	e54e                	sd	s3,136(sp)
ffffffffc0209522:	00853983          	ld	s3,8(a0)
ffffffffc0209526:	f506                	sd	ra,168(sp)
ffffffffc0209528:	6785                	lui	a5,0x1
ffffffffc020952a:	26f99a63          	bne	s3,a5,ffffffffc020979e <sfs_do_mount+0x280>
ffffffffc020952e:	ed26                	sd	s1,152(sp)
ffffffffc0209530:	84aa                	mv	s1,a0
ffffffffc0209532:	4501                	li	a0,0
ffffffffc0209534:	f122                	sd	s0,160(sp)
ffffffffc0209536:	f4de                	sd	s7,104(sp)
ffffffffc0209538:	8bae                	mv	s7,a1
ffffffffc020953a:	ec0fe0ef          	jal	ffffffffc0207bfa <__alloc_fs>
ffffffffc020953e:	842a                	mv	s0,a0
ffffffffc0209540:	26050663          	beqz	a0,ffffffffc02097ac <sfs_do_mount+0x28e>
ffffffffc0209544:	e152                	sd	s4,128(sp)
ffffffffc0209546:	0b052a03          	lw	s4,176(a0)
ffffffffc020954a:	e94a                	sd	s2,144(sp)
ffffffffc020954c:	280a1763          	bnez	s4,ffffffffc02097da <sfs_do_mount+0x2bc>
ffffffffc0209550:	f904                	sd	s1,48(a0)
ffffffffc0209552:	854e                	mv	a0,s3
ffffffffc0209554:	a6df80ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc0209558:	e428                	sd	a0,72(s0)
ffffffffc020955a:	892a                	mv	s2,a0
ffffffffc020955c:	16050863          	beqz	a0,ffffffffc02096cc <sfs_do_mount+0x1ae>
ffffffffc0209560:	864e                	mv	a2,s3
ffffffffc0209562:	4681                	li	a3,0
ffffffffc0209564:	85ca                	mv	a1,s2
ffffffffc0209566:	1008                	addi	a0,sp,32
ffffffffc0209568:	f25fb0ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc020956c:	709c                	ld	a5,32(s1)
ffffffffc020956e:	85aa                	mv	a1,a0
ffffffffc0209570:	4601                	li	a2,0
ffffffffc0209572:	8526                	mv	a0,s1
ffffffffc0209574:	9782                	jalr	a5
ffffffffc0209576:	89aa                	mv	s3,a0
ffffffffc0209578:	12051a63          	bnez	a0,ffffffffc02096ac <sfs_do_mount+0x18e>
ffffffffc020957c:	00092583          	lw	a1,0(s2)
ffffffffc0209580:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc0209584:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc0209588:	14c59d63          	bne	a1,a2,ffffffffc02096e2 <sfs_do_mount+0x1c4>
ffffffffc020958c:	00492783          	lw	a5,4(s2)
ffffffffc0209590:	6090                	ld	a2,0(s1)
ffffffffc0209592:	02079713          	slli	a4,a5,0x20
ffffffffc0209596:	9301                	srli	a4,a4,0x20
ffffffffc0209598:	12e66c63          	bltu	a2,a4,ffffffffc02096d0 <sfs_do_mount+0x1b2>
ffffffffc020959c:	e4ee                	sd	s11,72(sp)
ffffffffc020959e:	01892503          	lw	a0,24(s2)
ffffffffc02095a2:	00892e03          	lw	t3,8(s2)
ffffffffc02095a6:	00c92303          	lw	t1,12(s2)
ffffffffc02095aa:	01092883          	lw	a7,16(s2)
ffffffffc02095ae:	01492803          	lw	a6,20(s2)
ffffffffc02095b2:	01c92603          	lw	a2,28(s2)
ffffffffc02095b6:	02092683          	lw	a3,32(s2)
ffffffffc02095ba:	02492703          	lw	a4,36(s2)
ffffffffc02095be:	020905a3          	sb	zero,43(s2)
ffffffffc02095c2:	cc08                	sw	a0,24(s0)
ffffffffc02095c4:	01c42423          	sw	t3,8(s0)
ffffffffc02095c8:	00642623          	sw	t1,12(s0)
ffffffffc02095cc:	01142823          	sw	a7,16(s0)
ffffffffc02095d0:	01042a23          	sw	a6,20(s0)
ffffffffc02095d4:	cc50                	sw	a2,28(s0)
ffffffffc02095d6:	d014                	sw	a3,32(s0)
ffffffffc02095d8:	d058                	sw	a4,36(s0)
ffffffffc02095da:	c00c                	sw	a1,0(s0)
ffffffffc02095dc:	c05c                	sw	a5,4(s0)
ffffffffc02095de:	02892783          	lw	a5,40(s2)
ffffffffc02095e2:	6511                	lui	a0,0x4
ffffffffc02095e4:	d41c                	sw	a5,40(s0)
ffffffffc02095e6:	9dbf80ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc02095ea:	f448                	sd	a0,168(s0)
ffffffffc02095ec:	87aa                	mv	a5,a0
ffffffffc02095ee:	8daa                	mv	s11,a0
ffffffffc02095f0:	1a050963          	beqz	a0,ffffffffc02097a2 <sfs_do_mount+0x284>
ffffffffc02095f4:	6711                	lui	a4,0x4
ffffffffc02095f6:	fcd6                	sd	s5,120(sp)
ffffffffc02095f8:	ece6                	sd	s9,88(sp)
ffffffffc02095fa:	e8ea                	sd	s10,80(sp)
ffffffffc02095fc:	972a                	add	a4,a4,a0
ffffffffc02095fe:	e79c                	sd	a5,8(a5)
ffffffffc0209600:	e39c                	sd	a5,0(a5)
ffffffffc0209602:	07c1                	addi	a5,a5,16 # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc0209604:	fee79de3          	bne	a5,a4,ffffffffc02095fe <sfs_do_mount+0xe0>
ffffffffc0209608:	00496783          	lwu	a5,4(s2)
ffffffffc020960c:	6721                	lui	a4,0x8
ffffffffc020960e:	fff70a93          	addi	s5,a4,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209612:	97d6                	add	a5,a5,s5
ffffffffc0209614:	7761                	lui	a4,0xffff8
ffffffffc0209616:	8ff9                	and	a5,a5,a4
ffffffffc0209618:	0007851b          	sext.w	a0,a5
ffffffffc020961c:	00078c9b          	sext.w	s9,a5
ffffffffc0209620:	a43ff0ef          	jal	ffffffffc0209062 <bitmap_create>
ffffffffc0209624:	fc08                	sd	a0,56(s0)
ffffffffc0209626:	8d2a                	mv	s10,a0
ffffffffc0209628:	16050963          	beqz	a0,ffffffffc020979a <sfs_do_mount+0x27c>
ffffffffc020962c:	00492783          	lw	a5,4(s2)
ffffffffc0209630:	082c                	addi	a1,sp,24
ffffffffc0209632:	e43e                	sd	a5,8(sp)
ffffffffc0209634:	c65ff0ef          	jal	ffffffffc0209298 <bitmap_getdata>
ffffffffc0209638:	16050f63          	beqz	a0,ffffffffc02097b6 <sfs_do_mount+0x298>
ffffffffc020963c:	00816783          	lwu	a5,8(sp)
ffffffffc0209640:	66e2                	ld	a3,24(sp)
ffffffffc0209642:	97d6                	add	a5,a5,s5
ffffffffc0209644:	83bd                	srli	a5,a5,0xf
ffffffffc0209646:	00c7971b          	slliw	a4,a5,0xc
ffffffffc020964a:	1702                	slli	a4,a4,0x20
ffffffffc020964c:	9301                	srli	a4,a4,0x20
ffffffffc020964e:	16d71463          	bne	a4,a3,ffffffffc02097b6 <sfs_do_mount+0x298>
ffffffffc0209652:	f0e2                	sd	s8,96(sp)
ffffffffc0209654:	00c79713          	slli	a4,a5,0xc
ffffffffc0209658:	00e50c33          	add	s8,a0,a4
ffffffffc020965c:	8aaa                	mv	s5,a0
ffffffffc020965e:	cbd9                	beqz	a5,ffffffffc02096f4 <sfs_do_mount+0x1d6>
ffffffffc0209660:	6789                	lui	a5,0x2
ffffffffc0209662:	f8da                	sd	s6,112(sp)
ffffffffc0209664:	40a78b3b          	subw	s6,a5,a0
ffffffffc0209668:	a029                	j	ffffffffc0209672 <sfs_do_mount+0x154>
ffffffffc020966a:	6785                	lui	a5,0x1
ffffffffc020966c:	9abe                	add	s5,s5,a5
ffffffffc020966e:	098a8263          	beq	s5,s8,ffffffffc02096f2 <sfs_do_mount+0x1d4>
ffffffffc0209672:	015b06bb          	addw	a3,s6,s5
ffffffffc0209676:	1682                	slli	a3,a3,0x20
ffffffffc0209678:	6605                	lui	a2,0x1
ffffffffc020967a:	85d6                	mv	a1,s5
ffffffffc020967c:	9281                	srli	a3,a3,0x20
ffffffffc020967e:	1008                	addi	a0,sp,32
ffffffffc0209680:	e0dfb0ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc0209684:	709c                	ld	a5,32(s1)
ffffffffc0209686:	85aa                	mv	a1,a0
ffffffffc0209688:	4601                	li	a2,0
ffffffffc020968a:	8526                	mv	a0,s1
ffffffffc020968c:	9782                	jalr	a5
ffffffffc020968e:	dd71                	beqz	a0,ffffffffc020966a <sfs_do_mount+0x14c>
ffffffffc0209690:	e42a                	sd	a0,8(sp)
ffffffffc0209692:	856a                	mv	a0,s10
ffffffffc0209694:	bebff0ef          	jal	ffffffffc020927e <bitmap_destroy>
ffffffffc0209698:	69a2                	ld	s3,8(sp)
ffffffffc020969a:	7b46                	ld	s6,112(sp)
ffffffffc020969c:	7c06                	ld	s8,96(sp)
ffffffffc020969e:	856e                	mv	a0,s11
ffffffffc02096a0:	9c7f80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02096a4:	7ae6                	ld	s5,120(sp)
ffffffffc02096a6:	6ce6                	ld	s9,88(sp)
ffffffffc02096a8:	6d46                	ld	s10,80(sp)
ffffffffc02096aa:	6da6                	ld	s11,72(sp)
ffffffffc02096ac:	854a                	mv	a0,s2
ffffffffc02096ae:	9b9f80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02096b2:	8522                	mv	a0,s0
ffffffffc02096b4:	9b3f80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc02096b8:	740a                	ld	s0,160(sp)
ffffffffc02096ba:	64ea                	ld	s1,152(sp)
ffffffffc02096bc:	694a                	ld	s2,144(sp)
ffffffffc02096be:	6a0a                	ld	s4,128(sp)
ffffffffc02096c0:	7ba6                	ld	s7,104(sp)
ffffffffc02096c2:	70aa                	ld	ra,168(sp)
ffffffffc02096c4:	854e                	mv	a0,s3
ffffffffc02096c6:	69aa                	ld	s3,136(sp)
ffffffffc02096c8:	614d                	addi	sp,sp,176
ffffffffc02096ca:	8082                	ret
ffffffffc02096cc:	59f1                	li	s3,-4
ffffffffc02096ce:	b7d5                	j	ffffffffc02096b2 <sfs_do_mount+0x194>
ffffffffc02096d0:	85be                	mv	a1,a5
ffffffffc02096d2:	00005517          	auipc	a0,0x5
ffffffffc02096d6:	0a650513          	addi	a0,a0,166 # ffffffffc020e778 <etext+0x2fb4>
ffffffffc02096da:	acdf60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02096de:	59f5                	li	s3,-3
ffffffffc02096e0:	b7f1                	j	ffffffffc02096ac <sfs_do_mount+0x18e>
ffffffffc02096e2:	00005517          	auipc	a0,0x5
ffffffffc02096e6:	05e50513          	addi	a0,a0,94 # ffffffffc020e740 <etext+0x2f7c>
ffffffffc02096ea:	abdf60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02096ee:	59f5                	li	s3,-3
ffffffffc02096f0:	bf75                	j	ffffffffc02096ac <sfs_do_mount+0x18e>
ffffffffc02096f2:	7b46                	ld	s6,112(sp)
ffffffffc02096f4:	00442903          	lw	s2,4(s0)
ffffffffc02096f8:	0a0c8863          	beqz	s9,ffffffffc02097a8 <sfs_do_mount+0x28a>
ffffffffc02096fc:	4481                	li	s1,0
ffffffffc02096fe:	85a6                	mv	a1,s1
ffffffffc0209700:	856a                	mv	a0,s10
ffffffffc0209702:	b05ff0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc0209706:	c111                	beqz	a0,ffffffffc020970a <sfs_do_mount+0x1ec>
ffffffffc0209708:	2a05                	addiw	s4,s4,1
ffffffffc020970a:	2485                	addiw	s1,s1,1
ffffffffc020970c:	fe9c99e3          	bne	s9,s1,ffffffffc02096fe <sfs_do_mount+0x1e0>
ffffffffc0209710:	441c                	lw	a5,8(s0)
ffffffffc0209712:	0f479a63          	bne	a5,s4,ffffffffc0209806 <sfs_do_mount+0x2e8>
ffffffffc0209716:	05040513          	addi	a0,s0,80
ffffffffc020971a:	04043023          	sd	zero,64(s0)
ffffffffc020971e:	4585                	li	a1,1
ffffffffc0209720:	ecdfa0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc0209724:	06840513          	addi	a0,s0,104
ffffffffc0209728:	4585                	li	a1,1
ffffffffc020972a:	ec3fa0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc020972e:	08040513          	addi	a0,s0,128
ffffffffc0209732:	4585                	li	a1,1
ffffffffc0209734:	eb9fa0ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc0209738:	09840793          	addi	a5,s0,152
ffffffffc020973c:	4149063b          	subw	a2,s2,s4
ffffffffc0209740:	f05c                	sd	a5,160(s0)
ffffffffc0209742:	ec5c                	sd	a5,152(s0)
ffffffffc0209744:	874a                	mv	a4,s2
ffffffffc0209746:	86d2                	mv	a3,s4
ffffffffc0209748:	00c40593          	addi	a1,s0,12
ffffffffc020974c:	00005517          	auipc	a0,0x5
ffffffffc0209750:	0bc50513          	addi	a0,a0,188 # ffffffffc020e808 <etext+0x3044>
ffffffffc0209754:	a53f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209758:	00000617          	auipc	a2,0x0
ffffffffc020975c:	c9260613          	addi	a2,a2,-878 # ffffffffc02093ea <sfs_sync>
ffffffffc0209760:	00000697          	auipc	a3,0x0
ffffffffc0209764:	d6668693          	addi	a3,a3,-666 # ffffffffc02094c6 <sfs_get_root>
ffffffffc0209768:	00000717          	auipc	a4,0x0
ffffffffc020976c:	b6e70713          	addi	a4,a4,-1170 # ffffffffc02092d6 <sfs_unmount>
ffffffffc0209770:	00000797          	auipc	a5,0x0
ffffffffc0209774:	bea78793          	addi	a5,a5,-1046 # ffffffffc020935a <sfs_cleanup>
ffffffffc0209778:	fc50                	sd	a2,184(s0)
ffffffffc020977a:	e074                	sd	a3,192(s0)
ffffffffc020977c:	e478                	sd	a4,200(s0)
ffffffffc020977e:	e87c                	sd	a5,208(s0)
ffffffffc0209780:	008bb023          	sd	s0,0(s7)
ffffffffc0209784:	64ea                	ld	s1,152(sp)
ffffffffc0209786:	740a                	ld	s0,160(sp)
ffffffffc0209788:	694a                	ld	s2,144(sp)
ffffffffc020978a:	6a0a                	ld	s4,128(sp)
ffffffffc020978c:	7ae6                	ld	s5,120(sp)
ffffffffc020978e:	7ba6                	ld	s7,104(sp)
ffffffffc0209790:	7c06                	ld	s8,96(sp)
ffffffffc0209792:	6ce6                	ld	s9,88(sp)
ffffffffc0209794:	6d46                	ld	s10,80(sp)
ffffffffc0209796:	6da6                	ld	s11,72(sp)
ffffffffc0209798:	b72d                	j	ffffffffc02096c2 <sfs_do_mount+0x1a4>
ffffffffc020979a:	59f1                	li	s3,-4
ffffffffc020979c:	b709                	j	ffffffffc020969e <sfs_do_mount+0x180>
ffffffffc020979e:	59c9                	li	s3,-14
ffffffffc02097a0:	b70d                	j	ffffffffc02096c2 <sfs_do_mount+0x1a4>
ffffffffc02097a2:	6da6                	ld	s11,72(sp)
ffffffffc02097a4:	59f1                	li	s3,-4
ffffffffc02097a6:	b719                	j	ffffffffc02096ac <sfs_do_mount+0x18e>
ffffffffc02097a8:	4a01                	li	s4,0
ffffffffc02097aa:	b79d                	j	ffffffffc0209710 <sfs_do_mount+0x1f2>
ffffffffc02097ac:	740a                	ld	s0,160(sp)
ffffffffc02097ae:	64ea                	ld	s1,152(sp)
ffffffffc02097b0:	7ba6                	ld	s7,104(sp)
ffffffffc02097b2:	59f1                	li	s3,-4
ffffffffc02097b4:	b739                	j	ffffffffc02096c2 <sfs_do_mount+0x1a4>
ffffffffc02097b6:	00005697          	auipc	a3,0x5
ffffffffc02097ba:	ff268693          	addi	a3,a3,-14 # ffffffffc020e7a8 <etext+0x2fe4>
ffffffffc02097be:	00002617          	auipc	a2,0x2
ffffffffc02097c2:	44260613          	addi	a2,a2,1090 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02097c6:	08300593          	li	a1,131
ffffffffc02097ca:	00005517          	auipc	a0,0x5
ffffffffc02097ce:	ee650513          	addi	a0,a0,-282 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc02097d2:	f8da                	sd	s6,112(sp)
ffffffffc02097d4:	f0e2                	sd	s8,96(sp)
ffffffffc02097d6:	c75f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02097da:	00005697          	auipc	a3,0x5
ffffffffc02097de:	ea668693          	addi	a3,a3,-346 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc02097e2:	00002617          	auipc	a2,0x2
ffffffffc02097e6:	41e60613          	addi	a2,a2,1054 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02097ea:	0a300593          	li	a1,163
ffffffffc02097ee:	00005517          	auipc	a0,0x5
ffffffffc02097f2:	ec250513          	addi	a0,a0,-318 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc02097f6:	fcd6                	sd	s5,120(sp)
ffffffffc02097f8:	f8da                	sd	s6,112(sp)
ffffffffc02097fa:	f0e2                	sd	s8,96(sp)
ffffffffc02097fc:	ece6                	sd	s9,88(sp)
ffffffffc02097fe:	e8ea                	sd	s10,80(sp)
ffffffffc0209800:	e4ee                	sd	s11,72(sp)
ffffffffc0209802:	c49f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209806:	00005697          	auipc	a3,0x5
ffffffffc020980a:	fd268693          	addi	a3,a3,-46 # ffffffffc020e7d8 <etext+0x3014>
ffffffffc020980e:	00002617          	auipc	a2,0x2
ffffffffc0209812:	3f260613          	addi	a2,a2,1010 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209816:	0e000593          	li	a1,224
ffffffffc020981a:	00005517          	auipc	a0,0x5
ffffffffc020981e:	e9650513          	addi	a0,a0,-362 # ffffffffc020e6b0 <etext+0x2eec>
ffffffffc0209822:	f8da                	sd	s6,112(sp)
ffffffffc0209824:	c27f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209828 <sfs_mount>:
ffffffffc0209828:	00000597          	auipc	a1,0x0
ffffffffc020982c:	cf658593          	addi	a1,a1,-778 # ffffffffc020951e <sfs_do_mount>
ffffffffc0209830:	fccfe06f          	j	ffffffffc0207ffc <vfs_mount>

ffffffffc0209834 <sfs_opendir>:
ffffffffc0209834:	0235f593          	andi	a1,a1,35
ffffffffc0209838:	e199                	bnez	a1,ffffffffc020983e <sfs_opendir+0xa>
ffffffffc020983a:	4501                	li	a0,0
ffffffffc020983c:	8082                	ret
ffffffffc020983e:	553d                	li	a0,-17
ffffffffc0209840:	8082                	ret

ffffffffc0209842 <sfs_openfile>:
ffffffffc0209842:	4501                	li	a0,0
ffffffffc0209844:	8082                	ret

ffffffffc0209846 <sfs_gettype>:
ffffffffc0209846:	1141                	addi	sp,sp,-16
ffffffffc0209848:	e406                	sd	ra,8(sp)
ffffffffc020984a:	c529                	beqz	a0,ffffffffc0209894 <sfs_gettype+0x4e>
ffffffffc020984c:	4d38                	lw	a4,88(a0)
ffffffffc020984e:	6785                	lui	a5,0x1
ffffffffc0209850:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209854:	04f71063          	bne	a4,a5,ffffffffc0209894 <sfs_gettype+0x4e>
ffffffffc0209858:	6118                	ld	a4,0(a0)
ffffffffc020985a:	4789                	li	a5,2
ffffffffc020985c:	00475683          	lhu	a3,4(a4)
ffffffffc0209860:	02f68463          	beq	a3,a5,ffffffffc0209888 <sfs_gettype+0x42>
ffffffffc0209864:	478d                	li	a5,3
ffffffffc0209866:	00f68b63          	beq	a3,a5,ffffffffc020987c <sfs_gettype+0x36>
ffffffffc020986a:	4705                	li	a4,1
ffffffffc020986c:	6785                	lui	a5,0x1
ffffffffc020986e:	04e69363          	bne	a3,a4,ffffffffc02098b4 <sfs_gettype+0x6e>
ffffffffc0209872:	60a2                	ld	ra,8(sp)
ffffffffc0209874:	c19c                	sw	a5,0(a1)
ffffffffc0209876:	4501                	li	a0,0
ffffffffc0209878:	0141                	addi	sp,sp,16
ffffffffc020987a:	8082                	ret
ffffffffc020987c:	60a2                	ld	ra,8(sp)
ffffffffc020987e:	678d                	lui	a5,0x3
ffffffffc0209880:	c19c                	sw	a5,0(a1)
ffffffffc0209882:	4501                	li	a0,0
ffffffffc0209884:	0141                	addi	sp,sp,16
ffffffffc0209886:	8082                	ret
ffffffffc0209888:	60a2                	ld	ra,8(sp)
ffffffffc020988a:	6789                	lui	a5,0x2
ffffffffc020988c:	c19c                	sw	a5,0(a1)
ffffffffc020988e:	4501                	li	a0,0
ffffffffc0209890:	0141                	addi	sp,sp,16
ffffffffc0209892:	8082                	ret
ffffffffc0209894:	00005697          	auipc	a3,0x5
ffffffffc0209898:	f9468693          	addi	a3,a3,-108 # ffffffffc020e828 <etext+0x3064>
ffffffffc020989c:	00002617          	auipc	a2,0x2
ffffffffc02098a0:	36460613          	addi	a2,a2,868 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02098a4:	38f00593          	li	a1,911
ffffffffc02098a8:	00005517          	auipc	a0,0x5
ffffffffc02098ac:	fb850513          	addi	a0,a0,-72 # ffffffffc020e860 <etext+0x309c>
ffffffffc02098b0:	b9bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02098b4:	00005617          	auipc	a2,0x5
ffffffffc02098b8:	fc460613          	addi	a2,a2,-60 # ffffffffc020e878 <etext+0x30b4>
ffffffffc02098bc:	39b00593          	li	a1,923
ffffffffc02098c0:	00005517          	auipc	a0,0x5
ffffffffc02098c4:	fa050513          	addi	a0,a0,-96 # ffffffffc020e860 <etext+0x309c>
ffffffffc02098c8:	b83f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02098cc <sfs_fsync>:
ffffffffc02098cc:	7530                	ld	a2,104(a0)
ffffffffc02098ce:	7179                	addi	sp,sp,-48
ffffffffc02098d0:	f406                	sd	ra,40(sp)
ffffffffc02098d2:	ca2d                	beqz	a2,ffffffffc0209944 <sfs_fsync+0x78>
ffffffffc02098d4:	0b062703          	lw	a4,176(a2)
ffffffffc02098d8:	e735                	bnez	a4,ffffffffc0209944 <sfs_fsync+0x78>
ffffffffc02098da:	4d34                	lw	a3,88(a0)
ffffffffc02098dc:	6705                	lui	a4,0x1
ffffffffc02098de:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02098e2:	08e69263          	bne	a3,a4,ffffffffc0209966 <sfs_fsync+0x9a>
ffffffffc02098e6:	6914                	ld	a3,16(a0)
ffffffffc02098e8:	4701                	li	a4,0
ffffffffc02098ea:	e689                	bnez	a3,ffffffffc02098f4 <sfs_fsync+0x28>
ffffffffc02098ec:	70a2                	ld	ra,40(sp)
ffffffffc02098ee:	853a                	mv	a0,a4
ffffffffc02098f0:	6145                	addi	sp,sp,48
ffffffffc02098f2:	8082                	ret
ffffffffc02098f4:	f022                	sd	s0,32(sp)
ffffffffc02098f6:	e42a                	sd	a0,8(sp)
ffffffffc02098f8:	02050413          	addi	s0,a0,32
ffffffffc02098fc:	02050513          	addi	a0,a0,32
ffffffffc0209900:	ec3a                	sd	a4,24(sp)
ffffffffc0209902:	e832                	sd	a2,16(sp)
ffffffffc0209904:	cf3fa0ef          	jal	ffffffffc02045f6 <down>
ffffffffc0209908:	67a2                	ld	a5,8(sp)
ffffffffc020990a:	6762                	ld	a4,24(sp)
ffffffffc020990c:	6b94                	ld	a3,16(a5)
ffffffffc020990e:	ea99                	bnez	a3,ffffffffc0209924 <sfs_fsync+0x58>
ffffffffc0209910:	8522                	mv	a0,s0
ffffffffc0209912:	e43a                	sd	a4,8(sp)
ffffffffc0209914:	cdffa0ef          	jal	ffffffffc02045f2 <up>
ffffffffc0209918:	6722                	ld	a4,8(sp)
ffffffffc020991a:	7402                	ld	s0,32(sp)
ffffffffc020991c:	70a2                	ld	ra,40(sp)
ffffffffc020991e:	853a                	mv	a0,a4
ffffffffc0209920:	6145                	addi	sp,sp,48
ffffffffc0209922:	8082                	ret
ffffffffc0209924:	4794                	lw	a3,8(a5)
ffffffffc0209926:	638c                	ld	a1,0(a5)
ffffffffc0209928:	6542                	ld	a0,16(sp)
ffffffffc020992a:	4701                	li	a4,0
ffffffffc020992c:	0007b823          	sd	zero,16(a5) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0209930:	04000613          	li	a2,64
ffffffffc0209934:	718010ef          	jal	ffffffffc020b04c <sfs_wbuf>
ffffffffc0209938:	872a                	mv	a4,a0
ffffffffc020993a:	d979                	beqz	a0,ffffffffc0209910 <sfs_fsync+0x44>
ffffffffc020993c:	67a2                	ld	a5,8(sp)
ffffffffc020993e:	4685                	li	a3,1
ffffffffc0209940:	eb94                	sd	a3,16(a5)
ffffffffc0209942:	b7f9                	j	ffffffffc0209910 <sfs_fsync+0x44>
ffffffffc0209944:	00005697          	auipc	a3,0x5
ffffffffc0209948:	d3c68693          	addi	a3,a3,-708 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020994c:	00002617          	auipc	a2,0x2
ffffffffc0209950:	2b460613          	addi	a2,a2,692 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209954:	2d300593          	li	a1,723
ffffffffc0209958:	00005517          	auipc	a0,0x5
ffffffffc020995c:	f0850513          	addi	a0,a0,-248 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209960:	f022                	sd	s0,32(sp)
ffffffffc0209962:	ae9f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209966:	00005697          	auipc	a3,0x5
ffffffffc020996a:	ec268693          	addi	a3,a3,-318 # ffffffffc020e828 <etext+0x3064>
ffffffffc020996e:	00002617          	auipc	a2,0x2
ffffffffc0209972:	29260613          	addi	a2,a2,658 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209976:	2d400593          	li	a1,724
ffffffffc020997a:	00005517          	auipc	a0,0x5
ffffffffc020997e:	ee650513          	addi	a0,a0,-282 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209982:	f022                	sd	s0,32(sp)
ffffffffc0209984:	ac7f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209988 <sfs_fstat>:
ffffffffc0209988:	1101                	addi	sp,sp,-32
ffffffffc020998a:	e822                	sd	s0,16(sp)
ffffffffc020998c:	e426                	sd	s1,8(sp)
ffffffffc020998e:	842a                	mv	s0,a0
ffffffffc0209990:	84ae                	mv	s1,a1
ffffffffc0209992:	852e                	mv	a0,a1
ffffffffc0209994:	02000613          	li	a2,32
ffffffffc0209998:	4581                	li	a1,0
ffffffffc020999a:	ec06                	sd	ra,24(sp)
ffffffffc020999c:	5c1010ef          	jal	ffffffffc020b75c <memset>
ffffffffc02099a0:	c439                	beqz	s0,ffffffffc02099ee <sfs_fstat+0x66>
ffffffffc02099a2:	783c                	ld	a5,112(s0)
ffffffffc02099a4:	c7a9                	beqz	a5,ffffffffc02099ee <sfs_fstat+0x66>
ffffffffc02099a6:	6bbc                	ld	a5,80(a5)
ffffffffc02099a8:	c3b9                	beqz	a5,ffffffffc02099ee <sfs_fstat+0x66>
ffffffffc02099aa:	00005597          	auipc	a1,0x5
ffffffffc02099ae:	8e658593          	addi	a1,a1,-1818 # ffffffffc020e290 <etext+0x2acc>
ffffffffc02099b2:	8522                	mv	a0,s0
ffffffffc02099b4:	85afe0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc02099b8:	783c                	ld	a5,112(s0)
ffffffffc02099ba:	85a6                	mv	a1,s1
ffffffffc02099bc:	8522                	mv	a0,s0
ffffffffc02099be:	6bbc                	ld	a5,80(a5)
ffffffffc02099c0:	9782                	jalr	a5
ffffffffc02099c2:	e10d                	bnez	a0,ffffffffc02099e4 <sfs_fstat+0x5c>
ffffffffc02099c4:	4c38                	lw	a4,88(s0)
ffffffffc02099c6:	6785                	lui	a5,0x1
ffffffffc02099c8:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02099cc:	04f71163          	bne	a4,a5,ffffffffc0209a0e <sfs_fstat+0x86>
ffffffffc02099d0:	601c                	ld	a5,0(s0)
ffffffffc02099d2:	0067d683          	lhu	a3,6(a5)
ffffffffc02099d6:	0087e703          	lwu	a4,8(a5)
ffffffffc02099da:	0007e783          	lwu	a5,0(a5)
ffffffffc02099de:	e494                	sd	a3,8(s1)
ffffffffc02099e0:	e898                	sd	a4,16(s1)
ffffffffc02099e2:	ec9c                	sd	a5,24(s1)
ffffffffc02099e4:	60e2                	ld	ra,24(sp)
ffffffffc02099e6:	6442                	ld	s0,16(sp)
ffffffffc02099e8:	64a2                	ld	s1,8(sp)
ffffffffc02099ea:	6105                	addi	sp,sp,32
ffffffffc02099ec:	8082                	ret
ffffffffc02099ee:	00005697          	auipc	a3,0x5
ffffffffc02099f2:	83a68693          	addi	a3,a3,-1990 # ffffffffc020e228 <etext+0x2a64>
ffffffffc02099f6:	00002617          	auipc	a2,0x2
ffffffffc02099fa:	20a60613          	addi	a2,a2,522 # ffffffffc020bc00 <etext+0x43c>
ffffffffc02099fe:	2c400593          	li	a1,708
ffffffffc0209a02:	00005517          	auipc	a0,0x5
ffffffffc0209a06:	e5e50513          	addi	a0,a0,-418 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209a0a:	a41f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209a0e:	00005697          	auipc	a3,0x5
ffffffffc0209a12:	e1a68693          	addi	a3,a3,-486 # ffffffffc020e828 <etext+0x3064>
ffffffffc0209a16:	00002617          	auipc	a2,0x2
ffffffffc0209a1a:	1ea60613          	addi	a2,a2,490 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209a1e:	2c700593          	li	a1,711
ffffffffc0209a22:	00005517          	auipc	a0,0x5
ffffffffc0209a26:	e3e50513          	addi	a0,a0,-450 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209a2a:	a21f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209a2e <sfs_tryseek>:
ffffffffc0209a2e:	08000737          	lui	a4,0x8000
ffffffffc0209a32:	04e5f863          	bgeu	a1,a4,ffffffffc0209a82 <sfs_tryseek+0x54>
ffffffffc0209a36:	1101                	addi	sp,sp,-32
ffffffffc0209a38:	ec06                	sd	ra,24(sp)
ffffffffc0209a3a:	c531                	beqz	a0,ffffffffc0209a86 <sfs_tryseek+0x58>
ffffffffc0209a3c:	4d30                	lw	a2,88(a0)
ffffffffc0209a3e:	6685                	lui	a3,0x1
ffffffffc0209a40:	23568693          	addi	a3,a3,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209a44:	04d61163          	bne	a2,a3,ffffffffc0209a86 <sfs_tryseek+0x58>
ffffffffc0209a48:	6114                	ld	a3,0(a0)
ffffffffc0209a4a:	0006e683          	lwu	a3,0(a3)
ffffffffc0209a4e:	02b6d663          	bge	a3,a1,ffffffffc0209a7a <sfs_tryseek+0x4c>
ffffffffc0209a52:	7934                	ld	a3,112(a0)
ffffffffc0209a54:	caa9                	beqz	a3,ffffffffc0209aa6 <sfs_tryseek+0x78>
ffffffffc0209a56:	72b4                	ld	a3,96(a3)
ffffffffc0209a58:	c6b9                	beqz	a3,ffffffffc0209aa6 <sfs_tryseek+0x78>
ffffffffc0209a5a:	e02e                	sd	a1,0(sp)
ffffffffc0209a5c:	00004597          	auipc	a1,0x4
ffffffffc0209a60:	72458593          	addi	a1,a1,1828 # ffffffffc020e180 <etext+0x29bc>
ffffffffc0209a64:	e42a                	sd	a0,8(sp)
ffffffffc0209a66:	fa9fd0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0209a6a:	67a2                	ld	a5,8(sp)
ffffffffc0209a6c:	6582                	ld	a1,0(sp)
ffffffffc0209a6e:	60e2                	ld	ra,24(sp)
ffffffffc0209a70:	7bb4                	ld	a3,112(a5)
ffffffffc0209a72:	853e                	mv	a0,a5
ffffffffc0209a74:	72bc                	ld	a5,96(a3)
ffffffffc0209a76:	6105                	addi	sp,sp,32
ffffffffc0209a78:	8782                	jr	a5
ffffffffc0209a7a:	60e2                	ld	ra,24(sp)
ffffffffc0209a7c:	4501                	li	a0,0
ffffffffc0209a7e:	6105                	addi	sp,sp,32
ffffffffc0209a80:	8082                	ret
ffffffffc0209a82:	5575                	li	a0,-3
ffffffffc0209a84:	8082                	ret
ffffffffc0209a86:	00005697          	auipc	a3,0x5
ffffffffc0209a8a:	da268693          	addi	a3,a3,-606 # ffffffffc020e828 <etext+0x3064>
ffffffffc0209a8e:	00002617          	auipc	a2,0x2
ffffffffc0209a92:	17260613          	addi	a2,a2,370 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209a96:	3a600593          	li	a1,934
ffffffffc0209a9a:	00005517          	auipc	a0,0x5
ffffffffc0209a9e:	dc650513          	addi	a0,a0,-570 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209aa2:	9a9f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209aa6:	00004697          	auipc	a3,0x4
ffffffffc0209aaa:	68268693          	addi	a3,a3,1666 # ffffffffc020e128 <etext+0x2964>
ffffffffc0209aae:	00002617          	auipc	a2,0x2
ffffffffc0209ab2:	15260613          	addi	a2,a2,338 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209ab6:	3a800593          	li	a1,936
ffffffffc0209aba:	00005517          	auipc	a0,0x5
ffffffffc0209abe:	da650513          	addi	a0,a0,-602 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209ac2:	989f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209ac6 <sfs_close>:
ffffffffc0209ac6:	1141                	addi	sp,sp,-16
ffffffffc0209ac8:	e406                	sd	ra,8(sp)
ffffffffc0209aca:	e022                	sd	s0,0(sp)
ffffffffc0209acc:	c11d                	beqz	a0,ffffffffc0209af2 <sfs_close+0x2c>
ffffffffc0209ace:	793c                	ld	a5,112(a0)
ffffffffc0209ad0:	842a                	mv	s0,a0
ffffffffc0209ad2:	c385                	beqz	a5,ffffffffc0209af2 <sfs_close+0x2c>
ffffffffc0209ad4:	7b9c                	ld	a5,48(a5)
ffffffffc0209ad6:	cf91                	beqz	a5,ffffffffc0209af2 <sfs_close+0x2c>
ffffffffc0209ad8:	00004597          	auipc	a1,0x4
ffffffffc0209adc:	a0858593          	addi	a1,a1,-1528 # ffffffffc020d4e0 <etext+0x1d1c>
ffffffffc0209ae0:	f2ffd0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0209ae4:	783c                	ld	a5,112(s0)
ffffffffc0209ae6:	8522                	mv	a0,s0
ffffffffc0209ae8:	6402                	ld	s0,0(sp)
ffffffffc0209aea:	60a2                	ld	ra,8(sp)
ffffffffc0209aec:	7b9c                	ld	a5,48(a5)
ffffffffc0209aee:	0141                	addi	sp,sp,16
ffffffffc0209af0:	8782                	jr	a5
ffffffffc0209af2:	00004697          	auipc	a3,0x4
ffffffffc0209af6:	99e68693          	addi	a3,a3,-1634 # ffffffffc020d490 <etext+0x1ccc>
ffffffffc0209afa:	00002617          	auipc	a2,0x2
ffffffffc0209afe:	10660613          	addi	a2,a2,262 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209b02:	21c00593          	li	a1,540
ffffffffc0209b06:	00005517          	auipc	a0,0x5
ffffffffc0209b0a:	d5a50513          	addi	a0,a0,-678 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209b0e:	93df60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209b12 <sfs_io.part.0>:
ffffffffc0209b12:	1141                	addi	sp,sp,-16
ffffffffc0209b14:	00005697          	auipc	a3,0x5
ffffffffc0209b18:	d1468693          	addi	a3,a3,-748 # ffffffffc020e828 <etext+0x3064>
ffffffffc0209b1c:	00002617          	auipc	a2,0x2
ffffffffc0209b20:	0e460613          	addi	a2,a2,228 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209b24:	2a300593          	li	a1,675
ffffffffc0209b28:	00005517          	auipc	a0,0x5
ffffffffc0209b2c:	d3850513          	addi	a0,a0,-712 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209b30:	e406                	sd	ra,8(sp)
ffffffffc0209b32:	919f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209b36 <sfs_block_free>:
ffffffffc0209b36:	1101                	addi	sp,sp,-32
ffffffffc0209b38:	e822                	sd	s0,16(sp)
ffffffffc0209b3a:	e426                	sd	s1,8(sp)
ffffffffc0209b3c:	ec06                	sd	ra,24(sp)
ffffffffc0209b3e:	84ae                	mv	s1,a1
ffffffffc0209b40:	842a                	mv	s0,a0
ffffffffc0209b42:	c595                	beqz	a1,ffffffffc0209b6e <sfs_block_free+0x38>
ffffffffc0209b44:	415c                	lw	a5,4(a0)
ffffffffc0209b46:	02f5f463          	bgeu	a1,a5,ffffffffc0209b6e <sfs_block_free+0x38>
ffffffffc0209b4a:	7d08                	ld	a0,56(a0)
ffffffffc0209b4c:	ebaff0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc0209b50:	ed0d                	bnez	a0,ffffffffc0209b8a <sfs_block_free+0x54>
ffffffffc0209b52:	7c08                	ld	a0,56(s0)
ffffffffc0209b54:	85a6                	mv	a1,s1
ffffffffc0209b56:	ed8ff0ef          	jal	ffffffffc020922e <bitmap_free>
ffffffffc0209b5a:	441c                	lw	a5,8(s0)
ffffffffc0209b5c:	4705                	li	a4,1
ffffffffc0209b5e:	60e2                	ld	ra,24(sp)
ffffffffc0209b60:	2785                	addiw	a5,a5,1
ffffffffc0209b62:	e038                	sd	a4,64(s0)
ffffffffc0209b64:	c41c                	sw	a5,8(s0)
ffffffffc0209b66:	6442                	ld	s0,16(sp)
ffffffffc0209b68:	64a2                	ld	s1,8(sp)
ffffffffc0209b6a:	6105                	addi	sp,sp,32
ffffffffc0209b6c:	8082                	ret
ffffffffc0209b6e:	4054                	lw	a3,4(s0)
ffffffffc0209b70:	8726                	mv	a4,s1
ffffffffc0209b72:	00005617          	auipc	a2,0x5
ffffffffc0209b76:	d1e60613          	addi	a2,a2,-738 # ffffffffc020e890 <etext+0x30cc>
ffffffffc0209b7a:	05300593          	li	a1,83
ffffffffc0209b7e:	00005517          	auipc	a0,0x5
ffffffffc0209b82:	ce250513          	addi	a0,a0,-798 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209b86:	8c5f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209b8a:	00005697          	auipc	a3,0x5
ffffffffc0209b8e:	d3e68693          	addi	a3,a3,-706 # ffffffffc020e8c8 <etext+0x3104>
ffffffffc0209b92:	00002617          	auipc	a2,0x2
ffffffffc0209b96:	06e60613          	addi	a2,a2,110 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209b9a:	06a00593          	li	a1,106
ffffffffc0209b9e:	00005517          	auipc	a0,0x5
ffffffffc0209ba2:	cc250513          	addi	a0,a0,-830 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209ba6:	8a5f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209baa <sfs_reclaim>:
ffffffffc0209baa:	1101                	addi	sp,sp,-32
ffffffffc0209bac:	e426                	sd	s1,8(sp)
ffffffffc0209bae:	7524                	ld	s1,104(a0)
ffffffffc0209bb0:	ec06                	sd	ra,24(sp)
ffffffffc0209bb2:	e822                	sd	s0,16(sp)
ffffffffc0209bb4:	e04a                	sd	s2,0(sp)
ffffffffc0209bb6:	0e048963          	beqz	s1,ffffffffc0209ca8 <sfs_reclaim+0xfe>
ffffffffc0209bba:	0b04a783          	lw	a5,176(s1)
ffffffffc0209bbe:	0e079563          	bnez	a5,ffffffffc0209ca8 <sfs_reclaim+0xfe>
ffffffffc0209bc2:	4d38                	lw	a4,88(a0)
ffffffffc0209bc4:	6785                	lui	a5,0x1
ffffffffc0209bc6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209bca:	842a                	mv	s0,a0
ffffffffc0209bcc:	10f71e63          	bne	a4,a5,ffffffffc0209ce8 <sfs_reclaim+0x13e>
ffffffffc0209bd0:	8526                	mv	a0,s1
ffffffffc0209bd2:	62e010ef          	jal	ffffffffc020b200 <lock_sfs_fs>
ffffffffc0209bd6:	4c1c                	lw	a5,24(s0)
ffffffffc0209bd8:	0ef05863          	blez	a5,ffffffffc0209cc8 <sfs_reclaim+0x11e>
ffffffffc0209bdc:	37fd                	addiw	a5,a5,-1
ffffffffc0209bde:	cc1c                	sw	a5,24(s0)
ffffffffc0209be0:	ebd9                	bnez	a5,ffffffffc0209c76 <sfs_reclaim+0xcc>
ffffffffc0209be2:	05c42903          	lw	s2,92(s0)
ffffffffc0209be6:	08091863          	bnez	s2,ffffffffc0209c76 <sfs_reclaim+0xcc>
ffffffffc0209bea:	601c                	ld	a5,0(s0)
ffffffffc0209bec:	0067d783          	lhu	a5,6(a5)
ffffffffc0209bf0:	e785                	bnez	a5,ffffffffc0209c18 <sfs_reclaim+0x6e>
ffffffffc0209bf2:	783c                	ld	a5,112(s0)
ffffffffc0209bf4:	10078a63          	beqz	a5,ffffffffc0209d08 <sfs_reclaim+0x15e>
ffffffffc0209bf8:	73bc                	ld	a5,96(a5)
ffffffffc0209bfa:	10078763          	beqz	a5,ffffffffc0209d08 <sfs_reclaim+0x15e>
ffffffffc0209bfe:	00004597          	auipc	a1,0x4
ffffffffc0209c02:	58258593          	addi	a1,a1,1410 # ffffffffc020e180 <etext+0x29bc>
ffffffffc0209c06:	8522                	mv	a0,s0
ffffffffc0209c08:	e07fd0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0209c0c:	783c                	ld	a5,112(s0)
ffffffffc0209c0e:	8522                	mv	a0,s0
ffffffffc0209c10:	4581                	li	a1,0
ffffffffc0209c12:	73bc                	ld	a5,96(a5)
ffffffffc0209c14:	9782                	jalr	a5
ffffffffc0209c16:	e559                	bnez	a0,ffffffffc0209ca4 <sfs_reclaim+0xfa>
ffffffffc0209c18:	681c                	ld	a5,16(s0)
ffffffffc0209c1a:	c39d                	beqz	a5,ffffffffc0209c40 <sfs_reclaim+0x96>
ffffffffc0209c1c:	783c                	ld	a5,112(s0)
ffffffffc0209c1e:	10078563          	beqz	a5,ffffffffc0209d28 <sfs_reclaim+0x17e>
ffffffffc0209c22:	7b9c                	ld	a5,48(a5)
ffffffffc0209c24:	10078263          	beqz	a5,ffffffffc0209d28 <sfs_reclaim+0x17e>
ffffffffc0209c28:	8522                	mv	a0,s0
ffffffffc0209c2a:	00004597          	auipc	a1,0x4
ffffffffc0209c2e:	8b658593          	addi	a1,a1,-1866 # ffffffffc020d4e0 <etext+0x1d1c>
ffffffffc0209c32:	dddfd0ef          	jal	ffffffffc0207a0e <inode_check>
ffffffffc0209c36:	783c                	ld	a5,112(s0)
ffffffffc0209c38:	8522                	mv	a0,s0
ffffffffc0209c3a:	7b9c                	ld	a5,48(a5)
ffffffffc0209c3c:	9782                	jalr	a5
ffffffffc0209c3e:	e13d                	bnez	a0,ffffffffc0209ca4 <sfs_reclaim+0xfa>
ffffffffc0209c40:	7c18                	ld	a4,56(s0)
ffffffffc0209c42:	603c                	ld	a5,64(s0)
ffffffffc0209c44:	8526                	mv	a0,s1
ffffffffc0209c46:	e71c                	sd	a5,8(a4)
ffffffffc0209c48:	e398                	sd	a4,0(a5)
ffffffffc0209c4a:	6438                	ld	a4,72(s0)
ffffffffc0209c4c:	683c                	ld	a5,80(s0)
ffffffffc0209c4e:	e71c                	sd	a5,8(a4)
ffffffffc0209c50:	e398                	sd	a4,0(a5)
ffffffffc0209c52:	5be010ef          	jal	ffffffffc020b210 <unlock_sfs_fs>
ffffffffc0209c56:	6008                	ld	a0,0(s0)
ffffffffc0209c58:	00655783          	lhu	a5,6(a0)
ffffffffc0209c5c:	cb85                	beqz	a5,ffffffffc0209c8c <sfs_reclaim+0xe2>
ffffffffc0209c5e:	c08f80ef          	jal	ffffffffc0202066 <kfree>
ffffffffc0209c62:	8522                	mv	a0,s0
ffffffffc0209c64:	d43fd0ef          	jal	ffffffffc02079a6 <inode_kill>
ffffffffc0209c68:	60e2                	ld	ra,24(sp)
ffffffffc0209c6a:	6442                	ld	s0,16(sp)
ffffffffc0209c6c:	64a2                	ld	s1,8(sp)
ffffffffc0209c6e:	854a                	mv	a0,s2
ffffffffc0209c70:	6902                	ld	s2,0(sp)
ffffffffc0209c72:	6105                	addi	sp,sp,32
ffffffffc0209c74:	8082                	ret
ffffffffc0209c76:	5945                	li	s2,-15
ffffffffc0209c78:	8526                	mv	a0,s1
ffffffffc0209c7a:	596010ef          	jal	ffffffffc020b210 <unlock_sfs_fs>
ffffffffc0209c7e:	60e2                	ld	ra,24(sp)
ffffffffc0209c80:	6442                	ld	s0,16(sp)
ffffffffc0209c82:	64a2                	ld	s1,8(sp)
ffffffffc0209c84:	854a                	mv	a0,s2
ffffffffc0209c86:	6902                	ld	s2,0(sp)
ffffffffc0209c88:	6105                	addi	sp,sp,32
ffffffffc0209c8a:	8082                	ret
ffffffffc0209c8c:	440c                	lw	a1,8(s0)
ffffffffc0209c8e:	8526                	mv	a0,s1
ffffffffc0209c90:	ea7ff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc0209c94:	6008                	ld	a0,0(s0)
ffffffffc0209c96:	5d4c                	lw	a1,60(a0)
ffffffffc0209c98:	d1f9                	beqz	a1,ffffffffc0209c5e <sfs_reclaim+0xb4>
ffffffffc0209c9a:	8526                	mv	a0,s1
ffffffffc0209c9c:	e9bff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc0209ca0:	6008                	ld	a0,0(s0)
ffffffffc0209ca2:	bf75                	j	ffffffffc0209c5e <sfs_reclaim+0xb4>
ffffffffc0209ca4:	892a                	mv	s2,a0
ffffffffc0209ca6:	bfc9                	j	ffffffffc0209c78 <sfs_reclaim+0xce>
ffffffffc0209ca8:	00005697          	auipc	a3,0x5
ffffffffc0209cac:	9d868693          	addi	a3,a3,-1576 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc0209cb0:	00002617          	auipc	a2,0x2
ffffffffc0209cb4:	f5060613          	addi	a2,a2,-176 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209cb8:	36400593          	li	a1,868
ffffffffc0209cbc:	00005517          	auipc	a0,0x5
ffffffffc0209cc0:	ba450513          	addi	a0,a0,-1116 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209cc4:	f86f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209cc8:	00005697          	auipc	a3,0x5
ffffffffc0209ccc:	c2068693          	addi	a3,a3,-992 # ffffffffc020e8e8 <etext+0x3124>
ffffffffc0209cd0:	00002617          	auipc	a2,0x2
ffffffffc0209cd4:	f3060613          	addi	a2,a2,-208 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209cd8:	36a00593          	li	a1,874
ffffffffc0209cdc:	00005517          	auipc	a0,0x5
ffffffffc0209ce0:	b8450513          	addi	a0,a0,-1148 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209ce4:	f66f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209ce8:	00005697          	auipc	a3,0x5
ffffffffc0209cec:	b4068693          	addi	a3,a3,-1216 # ffffffffc020e828 <etext+0x3064>
ffffffffc0209cf0:	00002617          	auipc	a2,0x2
ffffffffc0209cf4:	f1060613          	addi	a2,a2,-240 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209cf8:	36500593          	li	a1,869
ffffffffc0209cfc:	00005517          	auipc	a0,0x5
ffffffffc0209d00:	b6450513          	addi	a0,a0,-1180 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209d04:	f46f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209d08:	00004697          	auipc	a3,0x4
ffffffffc0209d0c:	42068693          	addi	a3,a3,1056 # ffffffffc020e128 <etext+0x2964>
ffffffffc0209d10:	00002617          	auipc	a2,0x2
ffffffffc0209d14:	ef060613          	addi	a2,a2,-272 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209d18:	36f00593          	li	a1,879
ffffffffc0209d1c:	00005517          	auipc	a0,0x5
ffffffffc0209d20:	b4450513          	addi	a0,a0,-1212 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209d24:	f26f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209d28:	00003697          	auipc	a3,0x3
ffffffffc0209d2c:	76868693          	addi	a3,a3,1896 # ffffffffc020d490 <etext+0x1ccc>
ffffffffc0209d30:	00002617          	auipc	a2,0x2
ffffffffc0209d34:	ed060613          	addi	a2,a2,-304 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209d38:	37400593          	li	a1,884
ffffffffc0209d3c:	00005517          	auipc	a0,0x5
ffffffffc0209d40:	b2450513          	addi	a0,a0,-1244 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209d44:	f06f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209d48 <sfs_block_alloc>:
ffffffffc0209d48:	1101                	addi	sp,sp,-32
ffffffffc0209d4a:	e822                	sd	s0,16(sp)
ffffffffc0209d4c:	842a                	mv	s0,a0
ffffffffc0209d4e:	7d08                	ld	a0,56(a0)
ffffffffc0209d50:	e426                	sd	s1,8(sp)
ffffffffc0209d52:	ec06                	sd	ra,24(sp)
ffffffffc0209d54:	84ae                	mv	s1,a1
ffffffffc0209d56:	c3eff0ef          	jal	ffffffffc0209194 <bitmap_alloc>
ffffffffc0209d5a:	e90d                	bnez	a0,ffffffffc0209d8c <sfs_block_alloc+0x44>
ffffffffc0209d5c:	441c                	lw	a5,8(s0)
ffffffffc0209d5e:	cbb5                	beqz	a5,ffffffffc0209dd2 <sfs_block_alloc+0x8a>
ffffffffc0209d60:	37fd                	addiw	a5,a5,-1
ffffffffc0209d62:	c41c                	sw	a5,8(s0)
ffffffffc0209d64:	408c                	lw	a1,0(s1)
ffffffffc0209d66:	4605                	li	a2,1
ffffffffc0209d68:	e030                	sd	a2,64(s0)
ffffffffc0209d6a:	c595                	beqz	a1,ffffffffc0209d96 <sfs_block_alloc+0x4e>
ffffffffc0209d6c:	405c                	lw	a5,4(s0)
ffffffffc0209d6e:	02f5f463          	bgeu	a1,a5,ffffffffc0209d96 <sfs_block_alloc+0x4e>
ffffffffc0209d72:	7c08                	ld	a0,56(s0)
ffffffffc0209d74:	c92ff0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc0209d78:	4605                	li	a2,1
ffffffffc0209d7a:	ed05                	bnez	a0,ffffffffc0209db2 <sfs_block_alloc+0x6a>
ffffffffc0209d7c:	8522                	mv	a0,s0
ffffffffc0209d7e:	6442                	ld	s0,16(sp)
ffffffffc0209d80:	408c                	lw	a1,0(s1)
ffffffffc0209d82:	60e2                	ld	ra,24(sp)
ffffffffc0209d84:	64a2                	ld	s1,8(sp)
ffffffffc0209d86:	6105                	addi	sp,sp,32
ffffffffc0209d88:	4180106f          	j	ffffffffc020b1a0 <sfs_clear_block>
ffffffffc0209d8c:	60e2                	ld	ra,24(sp)
ffffffffc0209d8e:	6442                	ld	s0,16(sp)
ffffffffc0209d90:	64a2                	ld	s1,8(sp)
ffffffffc0209d92:	6105                	addi	sp,sp,32
ffffffffc0209d94:	8082                	ret
ffffffffc0209d96:	4054                	lw	a3,4(s0)
ffffffffc0209d98:	872e                	mv	a4,a1
ffffffffc0209d9a:	00005617          	auipc	a2,0x5
ffffffffc0209d9e:	af660613          	addi	a2,a2,-1290 # ffffffffc020e890 <etext+0x30cc>
ffffffffc0209da2:	05300593          	li	a1,83
ffffffffc0209da6:	00005517          	auipc	a0,0x5
ffffffffc0209daa:	aba50513          	addi	a0,a0,-1350 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209dae:	e9cf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209db2:	00005697          	auipc	a3,0x5
ffffffffc0209db6:	b6e68693          	addi	a3,a3,-1170 # ffffffffc020e920 <etext+0x315c>
ffffffffc0209dba:	00002617          	auipc	a2,0x2
ffffffffc0209dbe:	e4660613          	addi	a2,a2,-442 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209dc2:	06100593          	li	a1,97
ffffffffc0209dc6:	00005517          	auipc	a0,0x5
ffffffffc0209dca:	a9a50513          	addi	a0,a0,-1382 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209dce:	e7cf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209dd2:	00005697          	auipc	a3,0x5
ffffffffc0209dd6:	b2e68693          	addi	a3,a3,-1234 # ffffffffc020e900 <etext+0x313c>
ffffffffc0209dda:	00002617          	auipc	a2,0x2
ffffffffc0209dde:	e2660613          	addi	a2,a2,-474 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209de2:	05f00593          	li	a1,95
ffffffffc0209de6:	00005517          	auipc	a0,0x5
ffffffffc0209dea:	a7a50513          	addi	a0,a0,-1414 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209dee:	e5cf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209df2 <sfs_bmap_load_nolock>:
ffffffffc0209df2:	711d                	addi	sp,sp,-96
ffffffffc0209df4:	e4a6                	sd	s1,72(sp)
ffffffffc0209df6:	6184                	ld	s1,0(a1)
ffffffffc0209df8:	e0ca                	sd	s2,64(sp)
ffffffffc0209dfa:	ec86                	sd	ra,88(sp)
ffffffffc0209dfc:	0084a903          	lw	s2,8(s1)
ffffffffc0209e00:	e8a2                	sd	s0,80(sp)
ffffffffc0209e02:	fc4e                	sd	s3,56(sp)
ffffffffc0209e04:	f852                	sd	s4,48(sp)
ffffffffc0209e06:	1ac96663          	bltu	s2,a2,ffffffffc0209fb2 <sfs_bmap_load_nolock+0x1c0>
ffffffffc0209e0a:	47ad                	li	a5,11
ffffffffc0209e0c:	882e                	mv	a6,a1
ffffffffc0209e0e:	8432                	mv	s0,a2
ffffffffc0209e10:	8a36                	mv	s4,a3
ffffffffc0209e12:	89aa                	mv	s3,a0
ffffffffc0209e14:	04c7f963          	bgeu	a5,a2,ffffffffc0209e66 <sfs_bmap_load_nolock+0x74>
ffffffffc0209e18:	ff46079b          	addiw	a5,a2,-12
ffffffffc0209e1c:	3ff00713          	li	a4,1023
ffffffffc0209e20:	f456                	sd	s5,40(sp)
ffffffffc0209e22:	1af76a63          	bltu	a4,a5,ffffffffc0209fd6 <sfs_bmap_load_nolock+0x1e4>
ffffffffc0209e26:	03c4a883          	lw	a7,60(s1)
ffffffffc0209e2a:	02079713          	slli	a4,a5,0x20
ffffffffc0209e2e:	01e75793          	srli	a5,a4,0x1e
ffffffffc0209e32:	ce02                	sw	zero,28(sp)
ffffffffc0209e34:	cc46                	sw	a7,24(sp)
ffffffffc0209e36:	8abe                	mv	s5,a5
ffffffffc0209e38:	12089063          	bnez	a7,ffffffffc0209f58 <sfs_bmap_load_nolock+0x166>
ffffffffc0209e3c:	08c90c63          	beq	s2,a2,ffffffffc0209ed4 <sfs_bmap_load_nolock+0xe2>
ffffffffc0209e40:	7aa2                	ld	s5,40(sp)
ffffffffc0209e42:	4581                	li	a1,0
ffffffffc0209e44:	0049a683          	lw	a3,4(s3)
ffffffffc0209e48:	f456                	sd	s5,40(sp)
ffffffffc0209e4a:	f05a                	sd	s6,32(sp)
ffffffffc0209e4c:	872e                	mv	a4,a1
ffffffffc0209e4e:	00005617          	auipc	a2,0x5
ffffffffc0209e52:	a4260613          	addi	a2,a2,-1470 # ffffffffc020e890 <etext+0x30cc>
ffffffffc0209e56:	05300593          	li	a1,83
ffffffffc0209e5a:	00005517          	auipc	a0,0x5
ffffffffc0209e5e:	a0650513          	addi	a0,a0,-1530 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209e62:	de8f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e66:	02061793          	slli	a5,a2,0x20
ffffffffc0209e6a:	01e7d713          	srli	a4,a5,0x1e
ffffffffc0209e6e:	9726                	add	a4,a4,s1
ffffffffc0209e70:	474c                	lw	a1,12(a4)
ffffffffc0209e72:	ca2e                	sw	a1,20(sp)
ffffffffc0209e74:	e581                	bnez	a1,ffffffffc0209e7c <sfs_bmap_load_nolock+0x8a>
ffffffffc0209e76:	0cc90063          	beq	s2,a2,ffffffffc0209f36 <sfs_bmap_load_nolock+0x144>
ffffffffc0209e7a:	d5e1                	beqz	a1,ffffffffc0209e42 <sfs_bmap_load_nolock+0x50>
ffffffffc0209e7c:	0049a683          	lw	a3,4(s3)
ffffffffc0209e80:	16d5f863          	bgeu	a1,a3,ffffffffc0209ff0 <sfs_bmap_load_nolock+0x1fe>
ffffffffc0209e84:	0389b503          	ld	a0,56(s3)
ffffffffc0209e88:	b7eff0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc0209e8c:	18051763          	bnez	a0,ffffffffc020a01a <sfs_bmap_load_nolock+0x228>
ffffffffc0209e90:	45d2                	lw	a1,20(sp)
ffffffffc0209e92:	0049a783          	lw	a5,4(s3)
ffffffffc0209e96:	d5d5                	beqz	a1,ffffffffc0209e42 <sfs_bmap_load_nolock+0x50>
ffffffffc0209e98:	faf5f6e3          	bgeu	a1,a5,ffffffffc0209e44 <sfs_bmap_load_nolock+0x52>
ffffffffc0209e9c:	0389b503          	ld	a0,56(s3)
ffffffffc0209ea0:	e02e                	sd	a1,0(sp)
ffffffffc0209ea2:	b64ff0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc0209ea6:	6582                	ld	a1,0(sp)
ffffffffc0209ea8:	14051763          	bnez	a0,ffffffffc0209ff6 <sfs_bmap_load_nolock+0x204>
ffffffffc0209eac:	02890063          	beq	s2,s0,ffffffffc0209ecc <sfs_bmap_load_nolock+0xda>
ffffffffc0209eb0:	000a0463          	beqz	s4,ffffffffc0209eb8 <sfs_bmap_load_nolock+0xc6>
ffffffffc0209eb4:	00ba2023          	sw	a1,0(s4)
ffffffffc0209eb8:	4781                	li	a5,0
ffffffffc0209eba:	6446                	ld	s0,80(sp)
ffffffffc0209ebc:	60e6                	ld	ra,88(sp)
ffffffffc0209ebe:	79e2                	ld	s3,56(sp)
ffffffffc0209ec0:	7a42                	ld	s4,48(sp)
ffffffffc0209ec2:	64a6                	ld	s1,72(sp)
ffffffffc0209ec4:	6906                	ld	s2,64(sp)
ffffffffc0209ec6:	853e                	mv	a0,a5
ffffffffc0209ec8:	6125                	addi	sp,sp,96
ffffffffc0209eca:	8082                	ret
ffffffffc0209ecc:	449c                	lw	a5,8(s1)
ffffffffc0209ece:	2785                	addiw	a5,a5,1
ffffffffc0209ed0:	c49c                	sw	a5,8(s1)
ffffffffc0209ed2:	bff9                	j	ffffffffc0209eb0 <sfs_bmap_load_nolock+0xbe>
ffffffffc0209ed4:	082c                	addi	a1,sp,24
ffffffffc0209ed6:	e046                	sd	a7,0(sp)
ffffffffc0209ed8:	e442                	sd	a6,8(sp)
ffffffffc0209eda:	e6fff0ef          	jal	ffffffffc0209d48 <sfs_block_alloc>
ffffffffc0209ede:	87aa                	mv	a5,a0
ffffffffc0209ee0:	ed5d                	bnez	a0,ffffffffc0209f9e <sfs_bmap_load_nolock+0x1ac>
ffffffffc0209ee2:	6882                	ld	a7,0(sp)
ffffffffc0209ee4:	6822                	ld	a6,8(sp)
ffffffffc0209ee6:	f05a                	sd	s6,32(sp)
ffffffffc0209ee8:	01c10b13          	addi	s6,sp,28
ffffffffc0209eec:	85da                	mv	a1,s6
ffffffffc0209eee:	854e                	mv	a0,s3
ffffffffc0209ef0:	e046                	sd	a7,0(sp)
ffffffffc0209ef2:	e442                	sd	a6,8(sp)
ffffffffc0209ef4:	e55ff0ef          	jal	ffffffffc0209d48 <sfs_block_alloc>
ffffffffc0209ef8:	6882                	ld	a7,0(sp)
ffffffffc0209efa:	87aa                	mv	a5,a0
ffffffffc0209efc:	e959                	bnez	a0,ffffffffc0209f92 <sfs_bmap_load_nolock+0x1a0>
ffffffffc0209efe:	46e2                	lw	a3,24(sp)
ffffffffc0209f00:	85da                	mv	a1,s6
ffffffffc0209f02:	8756                	mv	a4,s5
ffffffffc0209f04:	4611                	li	a2,4
ffffffffc0209f06:	854e                	mv	a0,s3
ffffffffc0209f08:	e046                	sd	a7,0(sp)
ffffffffc0209f0a:	142010ef          	jal	ffffffffc020b04c <sfs_wbuf>
ffffffffc0209f0e:	45f2                	lw	a1,28(sp)
ffffffffc0209f10:	6882                	ld	a7,0(sp)
ffffffffc0209f12:	e92d                	bnez	a0,ffffffffc0209f84 <sfs_bmap_load_nolock+0x192>
ffffffffc0209f14:	5cd8                	lw	a4,60(s1)
ffffffffc0209f16:	47e2                	lw	a5,24(sp)
ffffffffc0209f18:	6822                	ld	a6,8(sp)
ffffffffc0209f1a:	ca2e                	sw	a1,20(sp)
ffffffffc0209f1c:	00f70863          	beq	a4,a5,ffffffffc0209f2c <sfs_bmap_load_nolock+0x13a>
ffffffffc0209f20:	10071f63          	bnez	a4,ffffffffc020a03e <sfs_bmap_load_nolock+0x24c>
ffffffffc0209f24:	dcdc                	sw	a5,60(s1)
ffffffffc0209f26:	4785                	li	a5,1
ffffffffc0209f28:	00f83823          	sd	a5,16(a6)
ffffffffc0209f2c:	7aa2                	ld	s5,40(sp)
ffffffffc0209f2e:	7b02                	ld	s6,32(sp)
ffffffffc0209f30:	f00589e3          	beqz	a1,ffffffffc0209e42 <sfs_bmap_load_nolock+0x50>
ffffffffc0209f34:	b7a1                	j	ffffffffc0209e7c <sfs_bmap_load_nolock+0x8a>
ffffffffc0209f36:	084c                	addi	a1,sp,20
ffffffffc0209f38:	e03a                	sd	a4,0(sp)
ffffffffc0209f3a:	e442                	sd	a6,8(sp)
ffffffffc0209f3c:	e0dff0ef          	jal	ffffffffc0209d48 <sfs_block_alloc>
ffffffffc0209f40:	87aa                	mv	a5,a0
ffffffffc0209f42:	fd25                	bnez	a0,ffffffffc0209eba <sfs_bmap_load_nolock+0xc8>
ffffffffc0209f44:	45d2                	lw	a1,20(sp)
ffffffffc0209f46:	6702                	ld	a4,0(sp)
ffffffffc0209f48:	6822                	ld	a6,8(sp)
ffffffffc0209f4a:	4785                	li	a5,1
ffffffffc0209f4c:	c74c                	sw	a1,12(a4)
ffffffffc0209f4e:	00f83823          	sd	a5,16(a6)
ffffffffc0209f52:	ee0588e3          	beqz	a1,ffffffffc0209e42 <sfs_bmap_load_nolock+0x50>
ffffffffc0209f56:	b71d                	j	ffffffffc0209e7c <sfs_bmap_load_nolock+0x8a>
ffffffffc0209f58:	e02e                	sd	a1,0(sp)
ffffffffc0209f5a:	873e                	mv	a4,a5
ffffffffc0209f5c:	086c                	addi	a1,sp,28
ffffffffc0209f5e:	86c6                	mv	a3,a7
ffffffffc0209f60:	4611                	li	a2,4
ffffffffc0209f62:	f05a                	sd	s6,32(sp)
ffffffffc0209f64:	e446                	sd	a7,8(sp)
ffffffffc0209f66:	066010ef          	jal	ffffffffc020afcc <sfs_rbuf>
ffffffffc0209f6a:	01c10b13          	addi	s6,sp,28
ffffffffc0209f6e:	87aa                	mv	a5,a0
ffffffffc0209f70:	e505                	bnez	a0,ffffffffc0209f98 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209f72:	45f2                	lw	a1,28(sp)
ffffffffc0209f74:	6802                	ld	a6,0(sp)
ffffffffc0209f76:	00891463          	bne	s2,s0,ffffffffc0209f7e <sfs_bmap_load_nolock+0x18c>
ffffffffc0209f7a:	68a2                	ld	a7,8(sp)
ffffffffc0209f7c:	d9a5                	beqz	a1,ffffffffc0209eec <sfs_bmap_load_nolock+0xfa>
ffffffffc0209f7e:	5cd8                	lw	a4,60(s1)
ffffffffc0209f80:	47e2                	lw	a5,24(sp)
ffffffffc0209f82:	bf61                	j	ffffffffc0209f1a <sfs_bmap_load_nolock+0x128>
ffffffffc0209f84:	e42a                	sd	a0,8(sp)
ffffffffc0209f86:	854e                	mv	a0,s3
ffffffffc0209f88:	e046                	sd	a7,0(sp)
ffffffffc0209f8a:	badff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc0209f8e:	6882                	ld	a7,0(sp)
ffffffffc0209f90:	67a2                	ld	a5,8(sp)
ffffffffc0209f92:	45e2                	lw	a1,24(sp)
ffffffffc0209f94:	00b89763          	bne	a7,a1,ffffffffc0209fa2 <sfs_bmap_load_nolock+0x1b0>
ffffffffc0209f98:	7aa2                	ld	s5,40(sp)
ffffffffc0209f9a:	7b02                	ld	s6,32(sp)
ffffffffc0209f9c:	bf39                	j	ffffffffc0209eba <sfs_bmap_load_nolock+0xc8>
ffffffffc0209f9e:	7aa2                	ld	s5,40(sp)
ffffffffc0209fa0:	bf29                	j	ffffffffc0209eba <sfs_bmap_load_nolock+0xc8>
ffffffffc0209fa2:	854e                	mv	a0,s3
ffffffffc0209fa4:	e03e                	sd	a5,0(sp)
ffffffffc0209fa6:	b91ff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc0209faa:	6782                	ld	a5,0(sp)
ffffffffc0209fac:	7aa2                	ld	s5,40(sp)
ffffffffc0209fae:	7b02                	ld	s6,32(sp)
ffffffffc0209fb0:	b729                	j	ffffffffc0209eba <sfs_bmap_load_nolock+0xc8>
ffffffffc0209fb2:	00005697          	auipc	a3,0x5
ffffffffc0209fb6:	99668693          	addi	a3,a3,-1642 # ffffffffc020e948 <etext+0x3184>
ffffffffc0209fba:	00002617          	auipc	a2,0x2
ffffffffc0209fbe:	c4660613          	addi	a2,a2,-954 # ffffffffc020bc00 <etext+0x43c>
ffffffffc0209fc2:	16400593          	li	a1,356
ffffffffc0209fc6:	00005517          	auipc	a0,0x5
ffffffffc0209fca:	89a50513          	addi	a0,a0,-1894 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209fce:	f456                	sd	s5,40(sp)
ffffffffc0209fd0:	f05a                	sd	s6,32(sp)
ffffffffc0209fd2:	c78f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209fd6:	00005617          	auipc	a2,0x5
ffffffffc0209fda:	9a260613          	addi	a2,a2,-1630 # ffffffffc020e978 <etext+0x31b4>
ffffffffc0209fde:	11e00593          	li	a1,286
ffffffffc0209fe2:	00005517          	auipc	a0,0x5
ffffffffc0209fe6:	87e50513          	addi	a0,a0,-1922 # ffffffffc020e860 <etext+0x309c>
ffffffffc0209fea:	f05a                	sd	s6,32(sp)
ffffffffc0209fec:	c5ef60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209ff0:	f456                	sd	s5,40(sp)
ffffffffc0209ff2:	f05a                	sd	s6,32(sp)
ffffffffc0209ff4:	bda1                	j	ffffffffc0209e4c <sfs_bmap_load_nolock+0x5a>
ffffffffc0209ff6:	00005697          	auipc	a3,0x5
ffffffffc0209ffa:	8d268693          	addi	a3,a3,-1838 # ffffffffc020e8c8 <etext+0x3104>
ffffffffc0209ffe:	00002617          	auipc	a2,0x2
ffffffffc020a002:	c0260613          	addi	a2,a2,-1022 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a006:	16b00593          	li	a1,363
ffffffffc020a00a:	00005517          	auipc	a0,0x5
ffffffffc020a00e:	85650513          	addi	a0,a0,-1962 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a012:	f456                	sd	s5,40(sp)
ffffffffc020a014:	f05a                	sd	s6,32(sp)
ffffffffc020a016:	c34f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a01a:	00005697          	auipc	a3,0x5
ffffffffc020a01e:	98e68693          	addi	a3,a3,-1650 # ffffffffc020e9a8 <etext+0x31e4>
ffffffffc020a022:	00002617          	auipc	a2,0x2
ffffffffc020a026:	bde60613          	addi	a2,a2,-1058 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a02a:	12100593          	li	a1,289
ffffffffc020a02e:	00005517          	auipc	a0,0x5
ffffffffc020a032:	83250513          	addi	a0,a0,-1998 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a036:	f456                	sd	s5,40(sp)
ffffffffc020a038:	f05a                	sd	s6,32(sp)
ffffffffc020a03a:	c10f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a03e:	00005697          	auipc	a3,0x5
ffffffffc020a042:	92268693          	addi	a3,a3,-1758 # ffffffffc020e960 <etext+0x319c>
ffffffffc020a046:	00002617          	auipc	a2,0x2
ffffffffc020a04a:	bba60613          	addi	a2,a2,-1094 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a04e:	11800593          	li	a1,280
ffffffffc020a052:	00005517          	auipc	a0,0x5
ffffffffc020a056:	80e50513          	addi	a0,a0,-2034 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a05a:	bf0f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a05e <sfs_io_nolock>:
ffffffffc020a05e:	7175                	addi	sp,sp,-144
ffffffffc020a060:	f8ca                	sd	s2,112(sp)
ffffffffc020a062:	892e                	mv	s2,a1
ffffffffc020a064:	618c                	ld	a1,0(a1)
ffffffffc020a066:	e506                	sd	ra,136(sp)
ffffffffc020a068:	4809                	li	a6,2
ffffffffc020a06a:	0045d883          	lhu	a7,4(a1)
ffffffffc020a06e:	e122                	sd	s0,128(sp)
ffffffffc020a070:	fca6                	sd	s1,120(sp)
ffffffffc020a072:	1d088a63          	beq	a7,a6,ffffffffc020a246 <sfs_io_nolock+0x1e8>
ffffffffc020a076:	00073803          	ld	a6,0(a4) # 8000000 <_binary_bin_sfs_img_size+0x7f8ad00>
ffffffffc020a07a:	84ba                	mv	s1,a4
ffffffffc020a07c:	0004b023          	sd	zero,0(s1)
ffffffffc020a080:	08000737          	lui	a4,0x8000
ffffffffc020a084:	8436                	mv	s0,a3
ffffffffc020a086:	9836                	add	a6,a6,a3
ffffffffc020a088:	8336                	mv	t1,a3
ffffffffc020a08a:	1ae6fc63          	bgeu	a3,a4,ffffffffc020a242 <sfs_io_nolock+0x1e4>
ffffffffc020a08e:	1ad84a63          	blt	a6,a3,ffffffffc020a242 <sfs_io_nolock+0x1e4>
ffffffffc020a092:	f4ce                	sd	s3,104(sp)
ffffffffc020a094:	89aa                	mv	s3,a0
ffffffffc020a096:	4501                	li	a0,0
ffffffffc020a098:	13068d63          	beq	a3,a6,ffffffffc020a1d2 <sfs_io_nolock+0x174>
ffffffffc020a09c:	f0d2                	sd	s4,96(sp)
ffffffffc020a09e:	e8da                	sd	s6,80(sp)
ffffffffc020a0a0:	e4de                	sd	s7,72(sp)
ffffffffc020a0a2:	8a32                	mv	s4,a2
ffffffffc020a0a4:	01077363          	bgeu	a4,a6,ffffffffc020a0aa <sfs_io_nolock+0x4c>
ffffffffc020a0a8:	883a                	mv	a6,a4
ffffffffc020a0aa:	cfd5                	beqz	a5,ffffffffc020a166 <sfs_io_nolock+0x108>
ffffffffc020a0ac:	ecd6                	sd	s5,88(sp)
ffffffffc020a0ae:	00001b97          	auipc	s7,0x1
ffffffffc020a0b2:	ebcb8b93          	addi	s7,s7,-324 # ffffffffc020af6a <sfs_wblock>
ffffffffc020a0b6:	00001b17          	auipc	s6,0x1
ffffffffc020a0ba:	f96b0b13          	addi	s6,s6,-106 # ffffffffc020b04c <sfs_wbuf>
ffffffffc020a0be:	6605                	lui	a2,0x1
ffffffffc020a0c0:	40c45693          	srai	a3,s0,0xc
ffffffffc020a0c4:	fff60713          	addi	a4,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a0c8:	40c85793          	srai	a5,a6,0xc
ffffffffc020a0cc:	9f95                	subw	a5,a5,a3
ffffffffc020a0ce:	8f61                	and	a4,a4,s0
ffffffffc020a0d0:	00068a9b          	sext.w	s5,a3
ffffffffc020a0d4:	8e3e                	mv	t3,a5
ffffffffc020a0d6:	cb4d                	beqz	a4,ffffffffc020a188 <sfs_io_nolock+0x12a>
ffffffffc020a0d8:	40880e33          	sub	t3,a6,s0
ffffffffc020a0dc:	10079263          	bnez	a5,ffffffffc020a1e0 <sfs_io_nolock+0x182>
ffffffffc020a0e0:	1874                	addi	a3,sp,60
ffffffffc020a0e2:	8656                	mv	a2,s5
ffffffffc020a0e4:	85ca                	mv	a1,s2
ffffffffc020a0e6:	854e                	mv	a0,s3
ffffffffc020a0e8:	e41a                	sd	t1,8(sp)
ffffffffc020a0ea:	f43e                	sd	a5,40(sp)
ffffffffc020a0ec:	ec3a                	sd	a4,24(sp)
ffffffffc020a0ee:	f042                	sd	a6,32(sp)
ffffffffc020a0f0:	e872                	sd	t3,16(sp)
ffffffffc020a0f2:	d01ff0ef          	jal	ffffffffc0209df2 <sfs_bmap_load_nolock>
ffffffffc020a0f6:	6322                	ld	t1,8(sp)
ffffffffc020a0f8:	4881                	li	a7,0
ffffffffc020a0fa:	ed0d                	bnez	a0,ffffffffc020a134 <sfs_io_nolock+0xd6>
ffffffffc020a0fc:	56f2                	lw	a3,60(sp)
ffffffffc020a0fe:	6762                	ld	a4,24(sp)
ffffffffc020a100:	6642                	ld	a2,16(sp)
ffffffffc020a102:	85d2                	mv	a1,s4
ffffffffc020a104:	854e                	mv	a0,s3
ffffffffc020a106:	9b02                	jalr	s6
ffffffffc020a108:	6322                	ld	t1,8(sp)
ffffffffc020a10a:	4881                	li	a7,0
ffffffffc020a10c:	e505                	bnez	a0,ffffffffc020a134 <sfs_io_nolock+0xd6>
ffffffffc020a10e:	77a2                	ld	a5,40(sp)
ffffffffc020a110:	68c2                	ld	a7,16(sp)
ffffffffc020a112:	7802                	ld	a6,32(sp)
ffffffffc020a114:	10078a63          	beqz	a5,ffffffffc020a228 <sfs_io_nolock+0x1ca>
ffffffffc020a118:	fff78e1b          	addiw	t3,a5,-1
ffffffffc020a11c:	9a46                	add	s4,s4,a7
ffffffffc020a11e:	2a85                	addiw	s5,s5,1
ffffffffc020a120:	060e1763          	bnez	t3,ffffffffc020a18e <sfs_io_nolock+0x130>
ffffffffc020a124:	1852                	slli	a6,a6,0x34
ffffffffc020a126:	03485793          	srli	a5,a6,0x34
ffffffffc020a12a:	0c081863          	bnez	a6,ffffffffc020a1fa <sfs_io_nolock+0x19c>
ffffffffc020a12e:	01140333          	add	t1,s0,a7
ffffffffc020a132:	4501                	li	a0,0
ffffffffc020a134:	00093783          	ld	a5,0(s2)
ffffffffc020a138:	0114b023          	sd	a7,0(s1)
ffffffffc020a13c:	0007e703          	lwu	a4,0(a5)
ffffffffc020a140:	00677863          	bgeu	a4,t1,ffffffffc020a150 <sfs_io_nolock+0xf2>
ffffffffc020a144:	0114043b          	addw	s0,s0,a7
ffffffffc020a148:	c380                	sw	s0,0(a5)
ffffffffc020a14a:	4785                	li	a5,1
ffffffffc020a14c:	00f93823          	sd	a5,16(s2)
ffffffffc020a150:	79a6                	ld	s3,104(sp)
ffffffffc020a152:	7a06                	ld	s4,96(sp)
ffffffffc020a154:	6ae6                	ld	s5,88(sp)
ffffffffc020a156:	6b46                	ld	s6,80(sp)
ffffffffc020a158:	6ba6                	ld	s7,72(sp)
ffffffffc020a15a:	640a                	ld	s0,128(sp)
ffffffffc020a15c:	60aa                	ld	ra,136(sp)
ffffffffc020a15e:	74e6                	ld	s1,120(sp)
ffffffffc020a160:	7946                	ld	s2,112(sp)
ffffffffc020a162:	6149                	addi	sp,sp,144
ffffffffc020a164:	8082                	ret
ffffffffc020a166:	0005e783          	lwu	a5,0(a1)
ffffffffc020a16a:	4501                	li	a0,0
ffffffffc020a16c:	0cf45163          	bge	s0,a5,ffffffffc020a22e <sfs_io_nolock+0x1d0>
ffffffffc020a170:	ecd6                	sd	s5,88(sp)
ffffffffc020a172:	0707ca63          	blt	a5,a6,ffffffffc020a1e6 <sfs_io_nolock+0x188>
ffffffffc020a176:	00001b97          	auipc	s7,0x1
ffffffffc020a17a:	d92b8b93          	addi	s7,s7,-622 # ffffffffc020af08 <sfs_rblock>
ffffffffc020a17e:	00001b17          	auipc	s6,0x1
ffffffffc020a182:	e4eb0b13          	addi	s6,s6,-434 # ffffffffc020afcc <sfs_rbuf>
ffffffffc020a186:	bf25                	j	ffffffffc020a0be <sfs_io_nolock+0x60>
ffffffffc020a188:	4881                	li	a7,0
ffffffffc020a18a:	f80e0de3          	beqz	t3,ffffffffc020a124 <sfs_io_nolock+0xc6>
ffffffffc020a18e:	1874                	addi	a3,sp,60
ffffffffc020a190:	8656                	mv	a2,s5
ffffffffc020a192:	85ca                	mv	a1,s2
ffffffffc020a194:	854e                	mv	a0,s3
ffffffffc020a196:	ec72                	sd	t3,24(sp)
ffffffffc020a198:	e846                	sd	a7,16(sp)
ffffffffc020a19a:	e442                	sd	a6,8(sp)
ffffffffc020a19c:	c57ff0ef          	jal	ffffffffc0209df2 <sfs_bmap_load_nolock>
ffffffffc020a1a0:	6822                	ld	a6,8(sp)
ffffffffc020a1a2:	68c2                	ld	a7,16(sp)
ffffffffc020a1a4:	6e62                	ld	t3,24(sp)
ffffffffc020a1a6:	e149                	bnez	a0,ffffffffc020a228 <sfs_io_nolock+0x1ca>
ffffffffc020a1a8:	5672                	lw	a2,60(sp)
ffffffffc020a1aa:	86f2                	mv	a3,t3
ffffffffc020a1ac:	85d2                	mv	a1,s4
ffffffffc020a1ae:	854e                	mv	a0,s3
ffffffffc020a1b0:	ec46                	sd	a7,24(sp)
ffffffffc020a1b2:	e842                	sd	a6,16(sp)
ffffffffc020a1b4:	e472                	sd	t3,8(sp)
ffffffffc020a1b6:	9b82                	jalr	s7
ffffffffc020a1b8:	6e22                	ld	t3,8(sp)
ffffffffc020a1ba:	6842                	ld	a6,16(sp)
ffffffffc020a1bc:	68e2                	ld	a7,24(sp)
ffffffffc020a1be:	e52d                	bnez	a0,ffffffffc020a228 <sfs_io_nolock+0x1ca>
ffffffffc020a1c0:	00ce179b          	slliw	a5,t3,0xc
ffffffffc020a1c4:	1782                	slli	a5,a5,0x20
ffffffffc020a1c6:	9381                	srli	a5,a5,0x20
ffffffffc020a1c8:	01ca8abb          	addw	s5,s5,t3
ffffffffc020a1cc:	98be                	add	a7,a7,a5
ffffffffc020a1ce:	9a3e                	add	s4,s4,a5
ffffffffc020a1d0:	bf91                	j	ffffffffc020a124 <sfs_io_nolock+0xc6>
ffffffffc020a1d2:	640a                	ld	s0,128(sp)
ffffffffc020a1d4:	60aa                	ld	ra,136(sp)
ffffffffc020a1d6:	79a6                	ld	s3,104(sp)
ffffffffc020a1d8:	74e6                	ld	s1,120(sp)
ffffffffc020a1da:	7946                	ld	s2,112(sp)
ffffffffc020a1dc:	6149                	addi	sp,sp,144
ffffffffc020a1de:	8082                	ret
ffffffffc020a1e0:	40e60e33          	sub	t3,a2,a4
ffffffffc020a1e4:	bdf5                	j	ffffffffc020a0e0 <sfs_io_nolock+0x82>
ffffffffc020a1e6:	883e                	mv	a6,a5
ffffffffc020a1e8:	00001b97          	auipc	s7,0x1
ffffffffc020a1ec:	d20b8b93          	addi	s7,s7,-736 # ffffffffc020af08 <sfs_rblock>
ffffffffc020a1f0:	00001b17          	auipc	s6,0x1
ffffffffc020a1f4:	ddcb0b13          	addi	s6,s6,-548 # ffffffffc020afcc <sfs_rbuf>
ffffffffc020a1f8:	b5d9                	j	ffffffffc020a0be <sfs_io_nolock+0x60>
ffffffffc020a1fa:	8656                	mv	a2,s5
ffffffffc020a1fc:	1874                	addi	a3,sp,60
ffffffffc020a1fe:	85ca                	mv	a1,s2
ffffffffc020a200:	854e                	mv	a0,s3
ffffffffc020a202:	e846                	sd	a7,16(sp)
ffffffffc020a204:	e43e                	sd	a5,8(sp)
ffffffffc020a206:	bedff0ef          	jal	ffffffffc0209df2 <sfs_bmap_load_nolock>
ffffffffc020a20a:	67a2                	ld	a5,8(sp)
ffffffffc020a20c:	68c2                	ld	a7,16(sp)
ffffffffc020a20e:	ed09                	bnez	a0,ffffffffc020a228 <sfs_io_nolock+0x1ca>
ffffffffc020a210:	56f2                	lw	a3,60(sp)
ffffffffc020a212:	863e                	mv	a2,a5
ffffffffc020a214:	85d2                	mv	a1,s4
ffffffffc020a216:	854e                	mv	a0,s3
ffffffffc020a218:	4701                	li	a4,0
ffffffffc020a21a:	e846                	sd	a7,16(sp)
ffffffffc020a21c:	e43e                	sd	a5,8(sp)
ffffffffc020a21e:	9b02                	jalr	s6
ffffffffc020a220:	67a2                	ld	a5,8(sp)
ffffffffc020a222:	68c2                	ld	a7,16(sp)
ffffffffc020a224:	e111                	bnez	a0,ffffffffc020a228 <sfs_io_nolock+0x1ca>
ffffffffc020a226:	98be                	add	a7,a7,a5
ffffffffc020a228:	01140333          	add	t1,s0,a7
ffffffffc020a22c:	b721                	j	ffffffffc020a134 <sfs_io_nolock+0xd6>
ffffffffc020a22e:	640a                	ld	s0,128(sp)
ffffffffc020a230:	60aa                	ld	ra,136(sp)
ffffffffc020a232:	79a6                	ld	s3,104(sp)
ffffffffc020a234:	7a06                	ld	s4,96(sp)
ffffffffc020a236:	6b46                	ld	s6,80(sp)
ffffffffc020a238:	6ba6                	ld	s7,72(sp)
ffffffffc020a23a:	74e6                	ld	s1,120(sp)
ffffffffc020a23c:	7946                	ld	s2,112(sp)
ffffffffc020a23e:	6149                	addi	sp,sp,144
ffffffffc020a240:	8082                	ret
ffffffffc020a242:	5575                	li	a0,-3
ffffffffc020a244:	bf19                	j	ffffffffc020a15a <sfs_io_nolock+0xfc>
ffffffffc020a246:	00004697          	auipc	a3,0x4
ffffffffc020a24a:	78a68693          	addi	a3,a3,1930 # ffffffffc020e9d0 <etext+0x320c>
ffffffffc020a24e:	00002617          	auipc	a2,0x2
ffffffffc020a252:	9b260613          	addi	a2,a2,-1614 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a256:	22b00593          	li	a1,555
ffffffffc020a25a:	00004517          	auipc	a0,0x4
ffffffffc020a25e:	60650513          	addi	a0,a0,1542 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a262:	f4ce                	sd	s3,104(sp)
ffffffffc020a264:	f0d2                	sd	s4,96(sp)
ffffffffc020a266:	ecd6                	sd	s5,88(sp)
ffffffffc020a268:	e8da                	sd	s6,80(sp)
ffffffffc020a26a:	e4de                	sd	s7,72(sp)
ffffffffc020a26c:	9def60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a270 <sfs_read>:
ffffffffc020a270:	7139                	addi	sp,sp,-64
ffffffffc020a272:	f04a                	sd	s2,32(sp)
ffffffffc020a274:	06853903          	ld	s2,104(a0)
ffffffffc020a278:	fc06                	sd	ra,56(sp)
ffffffffc020a27a:	f822                	sd	s0,48(sp)
ffffffffc020a27c:	f426                	sd	s1,40(sp)
ffffffffc020a27e:	ec4e                	sd	s3,24(sp)
ffffffffc020a280:	04090e63          	beqz	s2,ffffffffc020a2dc <sfs_read+0x6c>
ffffffffc020a284:	0b092783          	lw	a5,176(s2)
ffffffffc020a288:	ebb1                	bnez	a5,ffffffffc020a2dc <sfs_read+0x6c>
ffffffffc020a28a:	4d38                	lw	a4,88(a0)
ffffffffc020a28c:	6785                	lui	a5,0x1
ffffffffc020a28e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a292:	842a                	mv	s0,a0
ffffffffc020a294:	06f71463          	bne	a4,a5,ffffffffc020a2fc <sfs_read+0x8c>
ffffffffc020a298:	02050993          	addi	s3,a0,32
ffffffffc020a29c:	854e                	mv	a0,s3
ffffffffc020a29e:	84ae                	mv	s1,a1
ffffffffc020a2a0:	b56fa0ef          	jal	ffffffffc02045f6 <down>
ffffffffc020a2a4:	6c9c                	ld	a5,24(s1)
ffffffffc020a2a6:	6494                	ld	a3,8(s1)
ffffffffc020a2a8:	6090                	ld	a2,0(s1)
ffffffffc020a2aa:	85a2                	mv	a1,s0
ffffffffc020a2ac:	e43e                	sd	a5,8(sp)
ffffffffc020a2ae:	854a                	mv	a0,s2
ffffffffc020a2b0:	0038                	addi	a4,sp,8
ffffffffc020a2b2:	4781                	li	a5,0
ffffffffc020a2b4:	dabff0ef          	jal	ffffffffc020a05e <sfs_io_nolock>
ffffffffc020a2b8:	65a2                	ld	a1,8(sp)
ffffffffc020a2ba:	842a                	mv	s0,a0
ffffffffc020a2bc:	ed81                	bnez	a1,ffffffffc020a2d4 <sfs_read+0x64>
ffffffffc020a2be:	854e                	mv	a0,s3
ffffffffc020a2c0:	b32fa0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020a2c4:	70e2                	ld	ra,56(sp)
ffffffffc020a2c6:	8522                	mv	a0,s0
ffffffffc020a2c8:	7442                	ld	s0,48(sp)
ffffffffc020a2ca:	74a2                	ld	s1,40(sp)
ffffffffc020a2cc:	7902                	ld	s2,32(sp)
ffffffffc020a2ce:	69e2                	ld	s3,24(sp)
ffffffffc020a2d0:	6121                	addi	sp,sp,64
ffffffffc020a2d2:	8082                	ret
ffffffffc020a2d4:	8526                	mv	a0,s1
ffffffffc020a2d6:	a44fb0ef          	jal	ffffffffc020551a <iobuf_skip>
ffffffffc020a2da:	b7d5                	j	ffffffffc020a2be <sfs_read+0x4e>
ffffffffc020a2dc:	00004697          	auipc	a3,0x4
ffffffffc020a2e0:	3a468693          	addi	a3,a3,932 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020a2e4:	00002617          	auipc	a2,0x2
ffffffffc020a2e8:	91c60613          	addi	a2,a2,-1764 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a2ec:	2a200593          	li	a1,674
ffffffffc020a2f0:	00004517          	auipc	a0,0x4
ffffffffc020a2f4:	57050513          	addi	a0,a0,1392 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a2f8:	952f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a2fc:	817ff0ef          	jal	ffffffffc0209b12 <sfs_io.part.0>

ffffffffc020a300 <sfs_write>:
ffffffffc020a300:	7139                	addi	sp,sp,-64
ffffffffc020a302:	f04a                	sd	s2,32(sp)
ffffffffc020a304:	06853903          	ld	s2,104(a0)
ffffffffc020a308:	fc06                	sd	ra,56(sp)
ffffffffc020a30a:	f822                	sd	s0,48(sp)
ffffffffc020a30c:	f426                	sd	s1,40(sp)
ffffffffc020a30e:	ec4e                	sd	s3,24(sp)
ffffffffc020a310:	04090e63          	beqz	s2,ffffffffc020a36c <sfs_write+0x6c>
ffffffffc020a314:	0b092783          	lw	a5,176(s2)
ffffffffc020a318:	ebb1                	bnez	a5,ffffffffc020a36c <sfs_write+0x6c>
ffffffffc020a31a:	4d38                	lw	a4,88(a0)
ffffffffc020a31c:	6785                	lui	a5,0x1
ffffffffc020a31e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a322:	842a                	mv	s0,a0
ffffffffc020a324:	06f71463          	bne	a4,a5,ffffffffc020a38c <sfs_write+0x8c>
ffffffffc020a328:	02050993          	addi	s3,a0,32
ffffffffc020a32c:	854e                	mv	a0,s3
ffffffffc020a32e:	84ae                	mv	s1,a1
ffffffffc020a330:	ac6fa0ef          	jal	ffffffffc02045f6 <down>
ffffffffc020a334:	6c9c                	ld	a5,24(s1)
ffffffffc020a336:	6494                	ld	a3,8(s1)
ffffffffc020a338:	6090                	ld	a2,0(s1)
ffffffffc020a33a:	85a2                	mv	a1,s0
ffffffffc020a33c:	e43e                	sd	a5,8(sp)
ffffffffc020a33e:	854a                	mv	a0,s2
ffffffffc020a340:	0038                	addi	a4,sp,8
ffffffffc020a342:	4785                	li	a5,1
ffffffffc020a344:	d1bff0ef          	jal	ffffffffc020a05e <sfs_io_nolock>
ffffffffc020a348:	65a2                	ld	a1,8(sp)
ffffffffc020a34a:	842a                	mv	s0,a0
ffffffffc020a34c:	ed81                	bnez	a1,ffffffffc020a364 <sfs_write+0x64>
ffffffffc020a34e:	854e                	mv	a0,s3
ffffffffc020a350:	aa2fa0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020a354:	70e2                	ld	ra,56(sp)
ffffffffc020a356:	8522                	mv	a0,s0
ffffffffc020a358:	7442                	ld	s0,48(sp)
ffffffffc020a35a:	74a2                	ld	s1,40(sp)
ffffffffc020a35c:	7902                	ld	s2,32(sp)
ffffffffc020a35e:	69e2                	ld	s3,24(sp)
ffffffffc020a360:	6121                	addi	sp,sp,64
ffffffffc020a362:	8082                	ret
ffffffffc020a364:	8526                	mv	a0,s1
ffffffffc020a366:	9b4fb0ef          	jal	ffffffffc020551a <iobuf_skip>
ffffffffc020a36a:	b7d5                	j	ffffffffc020a34e <sfs_write+0x4e>
ffffffffc020a36c:	00004697          	auipc	a3,0x4
ffffffffc020a370:	31468693          	addi	a3,a3,788 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020a374:	00002617          	auipc	a2,0x2
ffffffffc020a378:	88c60613          	addi	a2,a2,-1908 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a37c:	2a200593          	li	a1,674
ffffffffc020a380:	00004517          	auipc	a0,0x4
ffffffffc020a384:	4e050513          	addi	a0,a0,1248 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a388:	8c2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a38c:	f86ff0ef          	jal	ffffffffc0209b12 <sfs_io.part.0>

ffffffffc020a390 <sfs_dirent_read_nolock>:
ffffffffc020a390:	619c                	ld	a5,0(a1)
ffffffffc020a392:	7139                	addi	sp,sp,-64
ffffffffc020a394:	f426                	sd	s1,40(sp)
ffffffffc020a396:	84b6                	mv	s1,a3
ffffffffc020a398:	0047d683          	lhu	a3,4(a5)
ffffffffc020a39c:	fc06                	sd	ra,56(sp)
ffffffffc020a39e:	f822                	sd	s0,48(sp)
ffffffffc020a3a0:	4709                	li	a4,2
ffffffffc020a3a2:	04e69963          	bne	a3,a4,ffffffffc020a3f4 <sfs_dirent_read_nolock+0x64>
ffffffffc020a3a6:	479c                	lw	a5,8(a5)
ffffffffc020a3a8:	04f67663          	bgeu	a2,a5,ffffffffc020a3f4 <sfs_dirent_read_nolock+0x64>
ffffffffc020a3ac:	0874                	addi	a3,sp,28
ffffffffc020a3ae:	842a                	mv	s0,a0
ffffffffc020a3b0:	a43ff0ef          	jal	ffffffffc0209df2 <sfs_bmap_load_nolock>
ffffffffc020a3b4:	c511                	beqz	a0,ffffffffc020a3c0 <sfs_dirent_read_nolock+0x30>
ffffffffc020a3b6:	70e2                	ld	ra,56(sp)
ffffffffc020a3b8:	7442                	ld	s0,48(sp)
ffffffffc020a3ba:	74a2                	ld	s1,40(sp)
ffffffffc020a3bc:	6121                	addi	sp,sp,64
ffffffffc020a3be:	8082                	ret
ffffffffc020a3c0:	45f2                	lw	a1,28(sp)
ffffffffc020a3c2:	c9a9                	beqz	a1,ffffffffc020a414 <sfs_dirent_read_nolock+0x84>
ffffffffc020a3c4:	405c                	lw	a5,4(s0)
ffffffffc020a3c6:	04f5f763          	bgeu	a1,a5,ffffffffc020a414 <sfs_dirent_read_nolock+0x84>
ffffffffc020a3ca:	7c08                	ld	a0,56(s0)
ffffffffc020a3cc:	e42e                	sd	a1,8(sp)
ffffffffc020a3ce:	e39fe0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc020a3d2:	ed39                	bnez	a0,ffffffffc020a430 <sfs_dirent_read_nolock+0xa0>
ffffffffc020a3d4:	66a2                	ld	a3,8(sp)
ffffffffc020a3d6:	8522                	mv	a0,s0
ffffffffc020a3d8:	4701                	li	a4,0
ffffffffc020a3da:	10400613          	li	a2,260
ffffffffc020a3de:	85a6                	mv	a1,s1
ffffffffc020a3e0:	3ed000ef          	jal	ffffffffc020afcc <sfs_rbuf>
ffffffffc020a3e4:	f969                	bnez	a0,ffffffffc020a3b6 <sfs_dirent_read_nolock+0x26>
ffffffffc020a3e6:	100481a3          	sb	zero,259(s1)
ffffffffc020a3ea:	70e2                	ld	ra,56(sp)
ffffffffc020a3ec:	7442                	ld	s0,48(sp)
ffffffffc020a3ee:	74a2                	ld	s1,40(sp)
ffffffffc020a3f0:	6121                	addi	sp,sp,64
ffffffffc020a3f2:	8082                	ret
ffffffffc020a3f4:	00004697          	auipc	a3,0x4
ffffffffc020a3f8:	5fc68693          	addi	a3,a3,1532 # ffffffffc020e9f0 <etext+0x322c>
ffffffffc020a3fc:	00002617          	auipc	a2,0x2
ffffffffc020a400:	80460613          	addi	a2,a2,-2044 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a404:	18e00593          	li	a1,398
ffffffffc020a408:	00004517          	auipc	a0,0x4
ffffffffc020a40c:	45850513          	addi	a0,a0,1112 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a410:	83af60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a414:	4054                	lw	a3,4(s0)
ffffffffc020a416:	872e                	mv	a4,a1
ffffffffc020a418:	00004617          	auipc	a2,0x4
ffffffffc020a41c:	47860613          	addi	a2,a2,1144 # ffffffffc020e890 <etext+0x30cc>
ffffffffc020a420:	05300593          	li	a1,83
ffffffffc020a424:	00004517          	auipc	a0,0x4
ffffffffc020a428:	43c50513          	addi	a0,a0,1084 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a42c:	81ef60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a430:	00004697          	auipc	a3,0x4
ffffffffc020a434:	49868693          	addi	a3,a3,1176 # ffffffffc020e8c8 <etext+0x3104>
ffffffffc020a438:	00001617          	auipc	a2,0x1
ffffffffc020a43c:	7c860613          	addi	a2,a2,1992 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a440:	19500593          	li	a1,405
ffffffffc020a444:	00004517          	auipc	a0,0x4
ffffffffc020a448:	41c50513          	addi	a0,a0,1052 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a44c:	ffff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a450 <sfs_getdirentry>:
ffffffffc020a450:	715d                	addi	sp,sp,-80
ffffffffc020a452:	f052                	sd	s4,32(sp)
ffffffffc020a454:	8a2a                	mv	s4,a0
ffffffffc020a456:	10400513          	li	a0,260
ffffffffc020a45a:	e85a                	sd	s6,16(sp)
ffffffffc020a45c:	e486                	sd	ra,72(sp)
ffffffffc020a45e:	e0a2                	sd	s0,64(sp)
ffffffffc020a460:	8b2e                	mv	s6,a1
ffffffffc020a462:	b5ff70ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020a466:	0e050963          	beqz	a0,ffffffffc020a558 <sfs_getdirentry+0x108>
ffffffffc020a46a:	ec56                	sd	s5,24(sp)
ffffffffc020a46c:	068a3a83          	ld	s5,104(s4)
ffffffffc020a470:	0e0a8663          	beqz	s5,ffffffffc020a55c <sfs_getdirentry+0x10c>
ffffffffc020a474:	0b0aa783          	lw	a5,176(s5)
ffffffffc020a478:	0e079263          	bnez	a5,ffffffffc020a55c <sfs_getdirentry+0x10c>
ffffffffc020a47c:	058a2703          	lw	a4,88(s4)
ffffffffc020a480:	6785                	lui	a5,0x1
ffffffffc020a482:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a486:	10f71063          	bne	a4,a5,ffffffffc020a586 <sfs_getdirentry+0x136>
ffffffffc020a48a:	f44e                	sd	s3,40(sp)
ffffffffc020a48c:	57fd                	li	a5,-1
ffffffffc020a48e:	008b3983          	ld	s3,8(s6)
ffffffffc020a492:	17fe                	slli	a5,a5,0x3f
ffffffffc020a494:	0ff78793          	addi	a5,a5,255
ffffffffc020a498:	00f9f7b3          	and	a5,s3,a5
ffffffffc020a49c:	e3d5                	bnez	a5,ffffffffc020a540 <sfs_getdirentry+0xf0>
ffffffffc020a49e:	000a3783          	ld	a5,0(s4)
ffffffffc020a4a2:	0089d993          	srli	s3,s3,0x8
ffffffffc020a4a6:	2981                	sext.w	s3,s3
ffffffffc020a4a8:	479c                	lw	a5,8(a5)
ffffffffc020a4aa:	0b37e163          	bltu	a5,s3,ffffffffc020a54c <sfs_getdirentry+0xfc>
ffffffffc020a4ae:	f84a                	sd	s2,48(sp)
ffffffffc020a4b0:	892a                	mv	s2,a0
ffffffffc020a4b2:	020a0513          	addi	a0,s4,32
ffffffffc020a4b6:	e45e                	sd	s7,8(sp)
ffffffffc020a4b8:	93efa0ef          	jal	ffffffffc02045f6 <down>
ffffffffc020a4bc:	000a3783          	ld	a5,0(s4)
ffffffffc020a4c0:	0087ab83          	lw	s7,8(a5)
ffffffffc020a4c4:	07705c63          	blez	s7,ffffffffc020a53c <sfs_getdirentry+0xec>
ffffffffc020a4c8:	fc26                	sd	s1,56(sp)
ffffffffc020a4ca:	4481                	li	s1,0
ffffffffc020a4cc:	a811                	j	ffffffffc020a4e0 <sfs_getdirentry+0x90>
ffffffffc020a4ce:	00092783          	lw	a5,0(s2)
ffffffffc020a4d2:	c781                	beqz	a5,ffffffffc020a4da <sfs_getdirentry+0x8a>
ffffffffc020a4d4:	02098463          	beqz	s3,ffffffffc020a4fc <sfs_getdirentry+0xac>
ffffffffc020a4d8:	39fd                	addiw	s3,s3,-1
ffffffffc020a4da:	2485                	addiw	s1,s1,1
ffffffffc020a4dc:	049b8d63          	beq	s7,s1,ffffffffc020a536 <sfs_getdirentry+0xe6>
ffffffffc020a4e0:	86ca                	mv	a3,s2
ffffffffc020a4e2:	8626                	mv	a2,s1
ffffffffc020a4e4:	85d2                	mv	a1,s4
ffffffffc020a4e6:	8556                	mv	a0,s5
ffffffffc020a4e8:	ea9ff0ef          	jal	ffffffffc020a390 <sfs_dirent_read_nolock>
ffffffffc020a4ec:	842a                	mv	s0,a0
ffffffffc020a4ee:	d165                	beqz	a0,ffffffffc020a4ce <sfs_getdirentry+0x7e>
ffffffffc020a4f0:	74e2                	ld	s1,56(sp)
ffffffffc020a4f2:	020a0513          	addi	a0,s4,32
ffffffffc020a4f6:	8fcfa0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020a4fa:	a005                	j	ffffffffc020a51a <sfs_getdirentry+0xca>
ffffffffc020a4fc:	020a0513          	addi	a0,s4,32
ffffffffc020a500:	8f2fa0ef          	jal	ffffffffc02045f2 <up>
ffffffffc020a504:	855a                	mv	a0,s6
ffffffffc020a506:	00490593          	addi	a1,s2,4
ffffffffc020a50a:	4701                	li	a4,0
ffffffffc020a50c:	4685                	li	a3,1
ffffffffc020a50e:	10000613          	li	a2,256
ffffffffc020a512:	f85fa0ef          	jal	ffffffffc0205496 <iobuf_move>
ffffffffc020a516:	74e2                	ld	s1,56(sp)
ffffffffc020a518:	842a                	mv	s0,a0
ffffffffc020a51a:	854a                	mv	a0,s2
ffffffffc020a51c:	b4bf70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020a520:	7942                	ld	s2,48(sp)
ffffffffc020a522:	79a2                	ld	s3,40(sp)
ffffffffc020a524:	6ae2                	ld	s5,24(sp)
ffffffffc020a526:	6ba2                	ld	s7,8(sp)
ffffffffc020a528:	60a6                	ld	ra,72(sp)
ffffffffc020a52a:	8522                	mv	a0,s0
ffffffffc020a52c:	6406                	ld	s0,64(sp)
ffffffffc020a52e:	7a02                	ld	s4,32(sp)
ffffffffc020a530:	6b42                	ld	s6,16(sp)
ffffffffc020a532:	6161                	addi	sp,sp,80
ffffffffc020a534:	8082                	ret
ffffffffc020a536:	74e2                	ld	s1,56(sp)
ffffffffc020a538:	5441                	li	s0,-16
ffffffffc020a53a:	bf65                	j	ffffffffc020a4f2 <sfs_getdirentry+0xa2>
ffffffffc020a53c:	5441                	li	s0,-16
ffffffffc020a53e:	bf55                	j	ffffffffc020a4f2 <sfs_getdirentry+0xa2>
ffffffffc020a540:	b27f70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020a544:	5475                	li	s0,-3
ffffffffc020a546:	79a2                	ld	s3,40(sp)
ffffffffc020a548:	6ae2                	ld	s5,24(sp)
ffffffffc020a54a:	bff9                	j	ffffffffc020a528 <sfs_getdirentry+0xd8>
ffffffffc020a54c:	b1bf70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020a550:	5441                	li	s0,-16
ffffffffc020a552:	79a2                	ld	s3,40(sp)
ffffffffc020a554:	6ae2                	ld	s5,24(sp)
ffffffffc020a556:	bfc9                	j	ffffffffc020a528 <sfs_getdirentry+0xd8>
ffffffffc020a558:	5471                	li	s0,-4
ffffffffc020a55a:	b7f9                	j	ffffffffc020a528 <sfs_getdirentry+0xd8>
ffffffffc020a55c:	00004697          	auipc	a3,0x4
ffffffffc020a560:	12468693          	addi	a3,a3,292 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020a564:	00001617          	auipc	a2,0x1
ffffffffc020a568:	69c60613          	addi	a2,a2,1692 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a56c:	34600593          	li	a1,838
ffffffffc020a570:	00004517          	auipc	a0,0x4
ffffffffc020a574:	2f050513          	addi	a0,a0,752 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a578:	fc26                	sd	s1,56(sp)
ffffffffc020a57a:	f84a                	sd	s2,48(sp)
ffffffffc020a57c:	f44e                	sd	s3,40(sp)
ffffffffc020a57e:	e45e                	sd	s7,8(sp)
ffffffffc020a580:	e062                	sd	s8,0(sp)
ffffffffc020a582:	ec9f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a586:	00004697          	auipc	a3,0x4
ffffffffc020a58a:	2a268693          	addi	a3,a3,674 # ffffffffc020e828 <etext+0x3064>
ffffffffc020a58e:	00001617          	auipc	a2,0x1
ffffffffc020a592:	67260613          	addi	a2,a2,1650 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a596:	34700593          	li	a1,839
ffffffffc020a59a:	00004517          	auipc	a0,0x4
ffffffffc020a59e:	2c650513          	addi	a0,a0,710 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a5a2:	fc26                	sd	s1,56(sp)
ffffffffc020a5a4:	f84a                	sd	s2,48(sp)
ffffffffc020a5a6:	f44e                	sd	s3,40(sp)
ffffffffc020a5a8:	e45e                	sd	s7,8(sp)
ffffffffc020a5aa:	e062                	sd	s8,0(sp)
ffffffffc020a5ac:	e9ff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a5b0 <sfs_truncfile>:
ffffffffc020a5b0:	080007b7          	lui	a5,0x8000
ffffffffc020a5b4:	1ab7eb63          	bltu	a5,a1,ffffffffc020a76a <sfs_truncfile+0x1ba>
ffffffffc020a5b8:	7159                	addi	sp,sp,-112
ffffffffc020a5ba:	e0d2                	sd	s4,64(sp)
ffffffffc020a5bc:	06853a03          	ld	s4,104(a0)
ffffffffc020a5c0:	e8ca                	sd	s2,80(sp)
ffffffffc020a5c2:	e4ce                	sd	s3,72(sp)
ffffffffc020a5c4:	f486                	sd	ra,104(sp)
ffffffffc020a5c6:	f0a2                	sd	s0,96(sp)
ffffffffc020a5c8:	fc56                	sd	s5,56(sp)
ffffffffc020a5ca:	892a                	mv	s2,a0
ffffffffc020a5cc:	89ae                	mv	s3,a1
ffffffffc020a5ce:	1a0a0163          	beqz	s4,ffffffffc020a770 <sfs_truncfile+0x1c0>
ffffffffc020a5d2:	0b0a2783          	lw	a5,176(s4)
ffffffffc020a5d6:	18079d63          	bnez	a5,ffffffffc020a770 <sfs_truncfile+0x1c0>
ffffffffc020a5da:	4d38                	lw	a4,88(a0)
ffffffffc020a5dc:	6785                	lui	a5,0x1
ffffffffc020a5de:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a5e2:	6405                	lui	s0,0x1
ffffffffc020a5e4:	1cf71963          	bne	a4,a5,ffffffffc020a7b6 <sfs_truncfile+0x206>
ffffffffc020a5e8:	00053a83          	ld	s5,0(a0)
ffffffffc020a5ec:	147d                	addi	s0,s0,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a5ee:	942e                	add	s0,s0,a1
ffffffffc020a5f0:	000ae783          	lwu	a5,0(s5)
ffffffffc020a5f4:	8031                	srli	s0,s0,0xc
ffffffffc020a5f6:	2401                	sext.w	s0,s0
ffffffffc020a5f8:	02b79063          	bne	a5,a1,ffffffffc020a618 <sfs_truncfile+0x68>
ffffffffc020a5fc:	008aa703          	lw	a4,8(s5)
ffffffffc020a600:	4781                	li	a5,0
ffffffffc020a602:	1c871c63          	bne	a4,s0,ffffffffc020a7da <sfs_truncfile+0x22a>
ffffffffc020a606:	70a6                	ld	ra,104(sp)
ffffffffc020a608:	7406                	ld	s0,96(sp)
ffffffffc020a60a:	6946                	ld	s2,80(sp)
ffffffffc020a60c:	69a6                	ld	s3,72(sp)
ffffffffc020a60e:	6a06                	ld	s4,64(sp)
ffffffffc020a610:	7ae2                	ld	s5,56(sp)
ffffffffc020a612:	853e                	mv	a0,a5
ffffffffc020a614:	6165                	addi	sp,sp,112
ffffffffc020a616:	8082                	ret
ffffffffc020a618:	02050513          	addi	a0,a0,32
ffffffffc020a61c:	eca6                	sd	s1,88(sp)
ffffffffc020a61e:	fd9f90ef          	jal	ffffffffc02045f6 <down>
ffffffffc020a622:	008aa483          	lw	s1,8(s5)
ffffffffc020a626:	0c84e363          	bltu	s1,s0,ffffffffc020a6ec <sfs_truncfile+0x13c>
ffffffffc020a62a:	0c947e63          	bgeu	s0,s1,ffffffffc020a706 <sfs_truncfile+0x156>
ffffffffc020a62e:	48ad                	li	a7,11
ffffffffc020a630:	4305                	li	t1,1
ffffffffc020a632:	a895                	j	ffffffffc020a6a6 <sfs_truncfile+0xf6>
ffffffffc020a634:	37cd                	addiw	a5,a5,-13
ffffffffc020a636:	3ff00693          	li	a3,1023
ffffffffc020a63a:	04f6ef63          	bltu	a3,a5,ffffffffc020a698 <sfs_truncfile+0xe8>
ffffffffc020a63e:	03c82683          	lw	a3,60(a6)
ffffffffc020a642:	cab9                	beqz	a3,ffffffffc020a698 <sfs_truncfile+0xe8>
ffffffffc020a644:	004a2603          	lw	a2,4(s4)
ffffffffc020a648:	1ac6fb63          	bgeu	a3,a2,ffffffffc020a7fe <sfs_truncfile+0x24e>
ffffffffc020a64c:	038a3503          	ld	a0,56(s4)
ffffffffc020a650:	85b6                	mv	a1,a3
ffffffffc020a652:	e436                	sd	a3,8(sp)
ffffffffc020a654:	e842                	sd	a6,16(sp)
ffffffffc020a656:	ec3e                	sd	a5,24(sp)
ffffffffc020a658:	baffe0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc020a65c:	66a2                	ld	a3,8(sp)
ffffffffc020a65e:	6842                	ld	a6,16(sp)
ffffffffc020a660:	67e2                	ld	a5,24(sp)
ffffffffc020a662:	1a051d63          	bnez	a0,ffffffffc020a81c <sfs_truncfile+0x26c>
ffffffffc020a666:	02079613          	slli	a2,a5,0x20
ffffffffc020a66a:	01e65713          	srli	a4,a2,0x1e
ffffffffc020a66e:	102c                	addi	a1,sp,40
ffffffffc020a670:	4611                	li	a2,4
ffffffffc020a672:	8552                	mv	a0,s4
ffffffffc020a674:	ec42                	sd	a6,24(sp)
ffffffffc020a676:	e83a                	sd	a4,16(sp)
ffffffffc020a678:	e436                	sd	a3,8(sp)
ffffffffc020a67a:	d602                	sw	zero,44(sp)
ffffffffc020a67c:	151000ef          	jal	ffffffffc020afcc <sfs_rbuf>
ffffffffc020a680:	87aa                	mv	a5,a0
ffffffffc020a682:	e941                	bnez	a0,ffffffffc020a712 <sfs_truncfile+0x162>
ffffffffc020a684:	57a2                	lw	a5,40(sp)
ffffffffc020a686:	66a2                	ld	a3,8(sp)
ffffffffc020a688:	6742                	ld	a4,16(sp)
ffffffffc020a68a:	6862                	ld	a6,24(sp)
ffffffffc020a68c:	48ad                	li	a7,11
ffffffffc020a68e:	4305                	li	t1,1
ffffffffc020a690:	ebd5                	bnez	a5,ffffffffc020a744 <sfs_truncfile+0x194>
ffffffffc020a692:	00882703          	lw	a4,8(a6)
ffffffffc020a696:	377d                	addiw	a4,a4,-1 # 7ffffff <_binary_bin_sfs_img_size+0x7f8acff>
ffffffffc020a698:	00e82423          	sw	a4,8(a6)
ffffffffc020a69c:	00693823          	sd	t1,16(s2)
ffffffffc020a6a0:	34fd                	addiw	s1,s1,-1
ffffffffc020a6a2:	04940e63          	beq	s0,s1,ffffffffc020a6fe <sfs_truncfile+0x14e>
ffffffffc020a6a6:	00093803          	ld	a6,0(s2)
ffffffffc020a6aa:	00882783          	lw	a5,8(a6)
ffffffffc020a6ae:	0e078363          	beqz	a5,ffffffffc020a794 <sfs_truncfile+0x1e4>
ffffffffc020a6b2:	fff7871b          	addiw	a4,a5,-1
ffffffffc020a6b6:	f6e8efe3          	bltu	a7,a4,ffffffffc020a634 <sfs_truncfile+0x84>
ffffffffc020a6ba:	02071693          	slli	a3,a4,0x20
ffffffffc020a6be:	01e6d793          	srli	a5,a3,0x1e
ffffffffc020a6c2:	97c2                	add	a5,a5,a6
ffffffffc020a6c4:	47cc                	lw	a1,12(a5)
ffffffffc020a6c6:	d9e9                	beqz	a1,ffffffffc020a698 <sfs_truncfile+0xe8>
ffffffffc020a6c8:	8552                	mv	a0,s4
ffffffffc020a6ca:	e83e                	sd	a5,16(sp)
ffffffffc020a6cc:	e442                	sd	a6,8(sp)
ffffffffc020a6ce:	c68ff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc020a6d2:	67c2                	ld	a5,16(sp)
ffffffffc020a6d4:	6822                	ld	a6,8(sp)
ffffffffc020a6d6:	48ad                	li	a7,11
ffffffffc020a6d8:	0007a623          	sw	zero,12(a5)
ffffffffc020a6dc:	00882703          	lw	a4,8(a6)
ffffffffc020a6e0:	4305                	li	t1,1
ffffffffc020a6e2:	377d                	addiw	a4,a4,-1
ffffffffc020a6e4:	bf55                	j	ffffffffc020a698 <sfs_truncfile+0xe8>
ffffffffc020a6e6:	2485                	addiw	s1,s1,1
ffffffffc020a6e8:	00940b63          	beq	s0,s1,ffffffffc020a6fe <sfs_truncfile+0x14e>
ffffffffc020a6ec:	4681                	li	a3,0
ffffffffc020a6ee:	8626                	mv	a2,s1
ffffffffc020a6f0:	85ca                	mv	a1,s2
ffffffffc020a6f2:	8552                	mv	a0,s4
ffffffffc020a6f4:	efeff0ef          	jal	ffffffffc0209df2 <sfs_bmap_load_nolock>
ffffffffc020a6f8:	87aa                	mv	a5,a0
ffffffffc020a6fa:	d575                	beqz	a0,ffffffffc020a6e6 <sfs_truncfile+0x136>
ffffffffc020a6fc:	a819                	j	ffffffffc020a712 <sfs_truncfile+0x162>
ffffffffc020a6fe:	008aa783          	lw	a5,8(s5)
ffffffffc020a702:	02879063          	bne	a5,s0,ffffffffc020a722 <sfs_truncfile+0x172>
ffffffffc020a706:	4785                	li	a5,1
ffffffffc020a708:	013aa023          	sw	s3,0(s5)
ffffffffc020a70c:	00f93823          	sd	a5,16(s2)
ffffffffc020a710:	4781                	li	a5,0
ffffffffc020a712:	02090513          	addi	a0,s2,32
ffffffffc020a716:	e43e                	sd	a5,8(sp)
ffffffffc020a718:	edbf90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020a71c:	67a2                	ld	a5,8(sp)
ffffffffc020a71e:	64e6                	ld	s1,88(sp)
ffffffffc020a720:	b5dd                	j	ffffffffc020a606 <sfs_truncfile+0x56>
ffffffffc020a722:	00004697          	auipc	a3,0x4
ffffffffc020a726:	38668693          	addi	a3,a3,902 # ffffffffc020eaa8 <etext+0x32e4>
ffffffffc020a72a:	00001617          	auipc	a2,0x1
ffffffffc020a72e:	4d660613          	addi	a2,a2,1238 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a732:	3d600593          	li	a1,982
ffffffffc020a736:	00004517          	auipc	a0,0x4
ffffffffc020a73a:	12a50513          	addi	a0,a0,298 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a73e:	f85a                	sd	s6,48(sp)
ffffffffc020a740:	d0bf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a744:	4611                	li	a2,4
ffffffffc020a746:	106c                	addi	a1,sp,44
ffffffffc020a748:	8552                	mv	a0,s4
ffffffffc020a74a:	e442                	sd	a6,8(sp)
ffffffffc020a74c:	101000ef          	jal	ffffffffc020b04c <sfs_wbuf>
ffffffffc020a750:	87aa                	mv	a5,a0
ffffffffc020a752:	f161                	bnez	a0,ffffffffc020a712 <sfs_truncfile+0x162>
ffffffffc020a754:	55a2                	lw	a1,40(sp)
ffffffffc020a756:	8552                	mv	a0,s4
ffffffffc020a758:	bdeff0ef          	jal	ffffffffc0209b36 <sfs_block_free>
ffffffffc020a75c:	6822                	ld	a6,8(sp)
ffffffffc020a75e:	4305                	li	t1,1
ffffffffc020a760:	48ad                	li	a7,11
ffffffffc020a762:	00882703          	lw	a4,8(a6)
ffffffffc020a766:	377d                	addiw	a4,a4,-1
ffffffffc020a768:	bf05                	j	ffffffffc020a698 <sfs_truncfile+0xe8>
ffffffffc020a76a:	57f5                	li	a5,-3
ffffffffc020a76c:	853e                	mv	a0,a5
ffffffffc020a76e:	8082                	ret
ffffffffc020a770:	00004697          	auipc	a3,0x4
ffffffffc020a774:	f1068693          	addi	a3,a3,-240 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020a778:	00001617          	auipc	a2,0x1
ffffffffc020a77c:	48860613          	addi	a2,a2,1160 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a780:	3b500593          	li	a1,949
ffffffffc020a784:	00004517          	auipc	a0,0x4
ffffffffc020a788:	0dc50513          	addi	a0,a0,220 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a78c:	eca6                	sd	s1,88(sp)
ffffffffc020a78e:	f85a                	sd	s6,48(sp)
ffffffffc020a790:	cbbf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a794:	00004697          	auipc	a3,0x4
ffffffffc020a798:	2c468693          	addi	a3,a3,708 # ffffffffc020ea58 <etext+0x3294>
ffffffffc020a79c:	00001617          	auipc	a2,0x1
ffffffffc020a7a0:	46460613          	addi	a2,a2,1124 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a7a4:	17b00593          	li	a1,379
ffffffffc020a7a8:	00004517          	auipc	a0,0x4
ffffffffc020a7ac:	0b850513          	addi	a0,a0,184 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a7b0:	f85a                	sd	s6,48(sp)
ffffffffc020a7b2:	c99f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a7b6:	00004697          	auipc	a3,0x4
ffffffffc020a7ba:	07268693          	addi	a3,a3,114 # ffffffffc020e828 <etext+0x3064>
ffffffffc020a7be:	00001617          	auipc	a2,0x1
ffffffffc020a7c2:	44260613          	addi	a2,a2,1090 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a7c6:	3b600593          	li	a1,950
ffffffffc020a7ca:	00004517          	auipc	a0,0x4
ffffffffc020a7ce:	09650513          	addi	a0,a0,150 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a7d2:	eca6                	sd	s1,88(sp)
ffffffffc020a7d4:	f85a                	sd	s6,48(sp)
ffffffffc020a7d6:	c75f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a7da:	00004697          	auipc	a3,0x4
ffffffffc020a7de:	26668693          	addi	a3,a3,614 # ffffffffc020ea40 <etext+0x327c>
ffffffffc020a7e2:	00001617          	auipc	a2,0x1
ffffffffc020a7e6:	41e60613          	addi	a2,a2,1054 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a7ea:	3bd00593          	li	a1,957
ffffffffc020a7ee:	00004517          	auipc	a0,0x4
ffffffffc020a7f2:	07250513          	addi	a0,a0,114 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a7f6:	eca6                	sd	s1,88(sp)
ffffffffc020a7f8:	f85a                	sd	s6,48(sp)
ffffffffc020a7fa:	c51f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a7fe:	8736                	mv	a4,a3
ffffffffc020a800:	05300593          	li	a1,83
ffffffffc020a804:	86b2                	mv	a3,a2
ffffffffc020a806:	00004517          	auipc	a0,0x4
ffffffffc020a80a:	05a50513          	addi	a0,a0,90 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a80e:	00004617          	auipc	a2,0x4
ffffffffc020a812:	08260613          	addi	a2,a2,130 # ffffffffc020e890 <etext+0x30cc>
ffffffffc020a816:	f85a                	sd	s6,48(sp)
ffffffffc020a818:	c33f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a81c:	00004697          	auipc	a3,0x4
ffffffffc020a820:	25468693          	addi	a3,a3,596 # ffffffffc020ea70 <etext+0x32ac>
ffffffffc020a824:	00001617          	auipc	a2,0x1
ffffffffc020a828:	3dc60613          	addi	a2,a2,988 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a82c:	12b00593          	li	a1,299
ffffffffc020a830:	00004517          	auipc	a0,0x4
ffffffffc020a834:	03050513          	addi	a0,a0,48 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a838:	f85a                	sd	s6,48(sp)
ffffffffc020a83a:	c11f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a83e <sfs_load_inode>:
ffffffffc020a83e:	7139                	addi	sp,sp,-64
ffffffffc020a840:	fc06                	sd	ra,56(sp)
ffffffffc020a842:	f822                	sd	s0,48(sp)
ffffffffc020a844:	f426                	sd	s1,40(sp)
ffffffffc020a846:	f04a                	sd	s2,32(sp)
ffffffffc020a848:	84b2                	mv	s1,a2
ffffffffc020a84a:	892a                	mv	s2,a0
ffffffffc020a84c:	ec4e                	sd	s3,24(sp)
ffffffffc020a84e:	89ae                	mv	s3,a1
ffffffffc020a850:	1b1000ef          	jal	ffffffffc020b200 <lock_sfs_fs>
ffffffffc020a854:	8526                	mv	a0,s1
ffffffffc020a856:	45a9                	li	a1,10
ffffffffc020a858:	0a893403          	ld	s0,168(s2)
ffffffffc020a85c:	1c5000ef          	jal	ffffffffc020b220 <hash32>
ffffffffc020a860:	02051793          	slli	a5,a0,0x20
ffffffffc020a864:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020a868:	00a406b3          	add	a3,s0,a0
ffffffffc020a86c:	87b6                	mv	a5,a3
ffffffffc020a86e:	a029                	j	ffffffffc020a878 <sfs_load_inode+0x3a>
ffffffffc020a870:	fc07a703          	lw	a4,-64(a5)
ffffffffc020a874:	10970563          	beq	a4,s1,ffffffffc020a97e <sfs_load_inode+0x140>
ffffffffc020a878:	679c                	ld	a5,8(a5)
ffffffffc020a87a:	fef69be3          	bne	a3,a5,ffffffffc020a870 <sfs_load_inode+0x32>
ffffffffc020a87e:	04000513          	li	a0,64
ffffffffc020a882:	f3ef70ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020a886:	87aa                	mv	a5,a0
ffffffffc020a888:	10050b63          	beqz	a0,ffffffffc020a99e <sfs_load_inode+0x160>
ffffffffc020a88c:	14048f63          	beqz	s1,ffffffffc020a9ea <sfs_load_inode+0x1ac>
ffffffffc020a890:	00492703          	lw	a4,4(s2)
ffffffffc020a894:	14e4fb63          	bgeu	s1,a4,ffffffffc020a9ea <sfs_load_inode+0x1ac>
ffffffffc020a898:	03893503          	ld	a0,56(s2)
ffffffffc020a89c:	85a6                	mv	a1,s1
ffffffffc020a89e:	e43e                	sd	a5,8(sp)
ffffffffc020a8a0:	967fe0ef          	jal	ffffffffc0209206 <bitmap_test>
ffffffffc020a8a4:	16051263          	bnez	a0,ffffffffc020aa08 <sfs_load_inode+0x1ca>
ffffffffc020a8a8:	65a2                	ld	a1,8(sp)
ffffffffc020a8aa:	4701                	li	a4,0
ffffffffc020a8ac:	86a6                	mv	a3,s1
ffffffffc020a8ae:	04000613          	li	a2,64
ffffffffc020a8b2:	854a                	mv	a0,s2
ffffffffc020a8b4:	718000ef          	jal	ffffffffc020afcc <sfs_rbuf>
ffffffffc020a8b8:	67a2                	ld	a5,8(sp)
ffffffffc020a8ba:	842a                	mv	s0,a0
ffffffffc020a8bc:	0e051e63          	bnez	a0,ffffffffc020a9b8 <sfs_load_inode+0x17a>
ffffffffc020a8c0:	0067d703          	lhu	a4,6(a5)
ffffffffc020a8c4:	10070363          	beqz	a4,ffffffffc020a9ca <sfs_load_inode+0x18c>
ffffffffc020a8c8:	6505                	lui	a0,0x1
ffffffffc020a8ca:	23550513          	addi	a0,a0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a8ce:	e43e                	sd	a5,8(sp)
ffffffffc020a8d0:	8acfd0ef          	jal	ffffffffc020797c <__alloc_inode>
ffffffffc020a8d4:	67a2                	ld	a5,8(sp)
ffffffffc020a8d6:	842a                	mv	s0,a0
ffffffffc020a8d8:	cd79                	beqz	a0,ffffffffc020a9b6 <sfs_load_inode+0x178>
ffffffffc020a8da:	0047d683          	lhu	a3,4(a5)
ffffffffc020a8de:	4705                	li	a4,1
ffffffffc020a8e0:	0ee68063          	beq	a3,a4,ffffffffc020a9c0 <sfs_load_inode+0x182>
ffffffffc020a8e4:	4709                	li	a4,2
ffffffffc020a8e6:	00005597          	auipc	a1,0x5
ffffffffc020a8ea:	f3a58593          	addi	a1,a1,-198 # ffffffffc020f820 <sfs_node_dirops>
ffffffffc020a8ee:	16e69d63          	bne	a3,a4,ffffffffc020aa68 <sfs_load_inode+0x22a>
ffffffffc020a8f2:	864a                	mv	a2,s2
ffffffffc020a8f4:	8522                	mv	a0,s0
ffffffffc020a8f6:	e43e                	sd	a5,8(sp)
ffffffffc020a8f8:	8a0fd0ef          	jal	ffffffffc0207998 <inode_init>
ffffffffc020a8fc:	4c34                	lw	a3,88(s0)
ffffffffc020a8fe:	6705                	lui	a4,0x1
ffffffffc020a900:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a904:	67a2                	ld	a5,8(sp)
ffffffffc020a906:	14e69163          	bne	a3,a4,ffffffffc020aa48 <sfs_load_inode+0x20a>
ffffffffc020a90a:	4585                	li	a1,1
ffffffffc020a90c:	e01c                	sd	a5,0(s0)
ffffffffc020a90e:	c404                	sw	s1,8(s0)
ffffffffc020a910:	00043823          	sd	zero,16(s0)
ffffffffc020a914:	cc0c                	sw	a1,24(s0)
ffffffffc020a916:	02040513          	addi	a0,s0,32
ffffffffc020a91a:	e436                	sd	a3,8(sp)
ffffffffc020a91c:	cd1f90ef          	jal	ffffffffc02045ec <sem_init>
ffffffffc020a920:	4c3c                	lw	a5,88(s0)
ffffffffc020a922:	66a2                	ld	a3,8(sp)
ffffffffc020a924:	10d79263          	bne	a5,a3,ffffffffc020aa28 <sfs_load_inode+0x1ea>
ffffffffc020a928:	0a093703          	ld	a4,160(s2)
ffffffffc020a92c:	03840793          	addi	a5,s0,56
ffffffffc020a930:	4408                	lw	a0,8(s0)
ffffffffc020a932:	e31c                	sd	a5,0(a4)
ffffffffc020a934:	0af93023          	sd	a5,160(s2)
ffffffffc020a938:	09890793          	addi	a5,s2,152
ffffffffc020a93c:	e038                	sd	a4,64(s0)
ffffffffc020a93e:	fc1c                	sd	a5,56(s0)
ffffffffc020a940:	45a9                	li	a1,10
ffffffffc020a942:	0a893483          	ld	s1,168(s2)
ffffffffc020a946:	0db000ef          	jal	ffffffffc020b220 <hash32>
ffffffffc020a94a:	02051713          	slli	a4,a0,0x20
ffffffffc020a94e:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a952:	97a6                	add	a5,a5,s1
ffffffffc020a954:	6798                	ld	a4,8(a5)
ffffffffc020a956:	04840693          	addi	a3,s0,72
ffffffffc020a95a:	e314                	sd	a3,0(a4)
ffffffffc020a95c:	e794                	sd	a3,8(a5)
ffffffffc020a95e:	e838                	sd	a4,80(s0)
ffffffffc020a960:	e43c                	sd	a5,72(s0)
ffffffffc020a962:	854a                	mv	a0,s2
ffffffffc020a964:	0ad000ef          	jal	ffffffffc020b210 <unlock_sfs_fs>
ffffffffc020a968:	0089b023          	sd	s0,0(s3)
ffffffffc020a96c:	4401                	li	s0,0
ffffffffc020a96e:	70e2                	ld	ra,56(sp)
ffffffffc020a970:	8522                	mv	a0,s0
ffffffffc020a972:	7442                	ld	s0,48(sp)
ffffffffc020a974:	74a2                	ld	s1,40(sp)
ffffffffc020a976:	7902                	ld	s2,32(sp)
ffffffffc020a978:	69e2                	ld	s3,24(sp)
ffffffffc020a97a:	6121                	addi	sp,sp,64
ffffffffc020a97c:	8082                	ret
ffffffffc020a97e:	fb878413          	addi	s0,a5,-72
ffffffffc020a982:	8522                	mv	a0,s0
ffffffffc020a984:	e43e                	sd	a5,8(sp)
ffffffffc020a986:	874fd0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc020a98a:	4705                	li	a4,1
ffffffffc020a98c:	67a2                	ld	a5,8(sp)
ffffffffc020a98e:	fce51ae3          	bne	a0,a4,ffffffffc020a962 <sfs_load_inode+0x124>
ffffffffc020a992:	fd07a703          	lw	a4,-48(a5)
ffffffffc020a996:	2705                	addiw	a4,a4,1
ffffffffc020a998:	fce7a823          	sw	a4,-48(a5)
ffffffffc020a99c:	b7d9                	j	ffffffffc020a962 <sfs_load_inode+0x124>
ffffffffc020a99e:	5471                	li	s0,-4
ffffffffc020a9a0:	854a                	mv	a0,s2
ffffffffc020a9a2:	06f000ef          	jal	ffffffffc020b210 <unlock_sfs_fs>
ffffffffc020a9a6:	70e2                	ld	ra,56(sp)
ffffffffc020a9a8:	8522                	mv	a0,s0
ffffffffc020a9aa:	7442                	ld	s0,48(sp)
ffffffffc020a9ac:	74a2                	ld	s1,40(sp)
ffffffffc020a9ae:	7902                	ld	s2,32(sp)
ffffffffc020a9b0:	69e2                	ld	s3,24(sp)
ffffffffc020a9b2:	6121                	addi	sp,sp,64
ffffffffc020a9b4:	8082                	ret
ffffffffc020a9b6:	5471                	li	s0,-4
ffffffffc020a9b8:	853e                	mv	a0,a5
ffffffffc020a9ba:	eacf70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020a9be:	b7cd                	j	ffffffffc020a9a0 <sfs_load_inode+0x162>
ffffffffc020a9c0:	00005597          	auipc	a1,0x5
ffffffffc020a9c4:	de058593          	addi	a1,a1,-544 # ffffffffc020f7a0 <sfs_node_fileops>
ffffffffc020a9c8:	b72d                	j	ffffffffc020a8f2 <sfs_load_inode+0xb4>
ffffffffc020a9ca:	00004697          	auipc	a3,0x4
ffffffffc020a9ce:	0f668693          	addi	a3,a3,246 # ffffffffc020eac0 <etext+0x32fc>
ffffffffc020a9d2:	00001617          	auipc	a2,0x1
ffffffffc020a9d6:	22e60613          	addi	a2,a2,558 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020a9da:	0ad00593          	li	a1,173
ffffffffc020a9de:	00004517          	auipc	a0,0x4
ffffffffc020a9e2:	e8250513          	addi	a0,a0,-382 # ffffffffc020e860 <etext+0x309c>
ffffffffc020a9e6:	a65f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9ea:	00492683          	lw	a3,4(s2)
ffffffffc020a9ee:	8726                	mv	a4,s1
ffffffffc020a9f0:	00004617          	auipc	a2,0x4
ffffffffc020a9f4:	ea060613          	addi	a2,a2,-352 # ffffffffc020e890 <etext+0x30cc>
ffffffffc020a9f8:	05300593          	li	a1,83
ffffffffc020a9fc:	00004517          	auipc	a0,0x4
ffffffffc020aa00:	e6450513          	addi	a0,a0,-412 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aa04:	a47f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa08:	00004697          	auipc	a3,0x4
ffffffffc020aa0c:	ec068693          	addi	a3,a3,-320 # ffffffffc020e8c8 <etext+0x3104>
ffffffffc020aa10:	00001617          	auipc	a2,0x1
ffffffffc020aa14:	1f060613          	addi	a2,a2,496 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020aa18:	0a800593          	li	a1,168
ffffffffc020aa1c:	00004517          	auipc	a0,0x4
ffffffffc020aa20:	e4450513          	addi	a0,a0,-444 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aa24:	a27f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa28:	00004697          	auipc	a3,0x4
ffffffffc020aa2c:	e0068693          	addi	a3,a3,-512 # ffffffffc020e828 <etext+0x3064>
ffffffffc020aa30:	00001617          	auipc	a2,0x1
ffffffffc020aa34:	1d060613          	addi	a2,a2,464 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020aa38:	0b100593          	li	a1,177
ffffffffc020aa3c:	00004517          	auipc	a0,0x4
ffffffffc020aa40:	e2450513          	addi	a0,a0,-476 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aa44:	a07f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa48:	00004697          	auipc	a3,0x4
ffffffffc020aa4c:	de068693          	addi	a3,a3,-544 # ffffffffc020e828 <etext+0x3064>
ffffffffc020aa50:	00001617          	auipc	a2,0x1
ffffffffc020aa54:	1b060613          	addi	a2,a2,432 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020aa58:	07700593          	li	a1,119
ffffffffc020aa5c:	00004517          	auipc	a0,0x4
ffffffffc020aa60:	e0450513          	addi	a0,a0,-508 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aa64:	9e7f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa68:	00004617          	auipc	a2,0x4
ffffffffc020aa6c:	e1060613          	addi	a2,a2,-496 # ffffffffc020e878 <etext+0x30b4>
ffffffffc020aa70:	02e00593          	li	a1,46
ffffffffc020aa74:	00004517          	auipc	a0,0x4
ffffffffc020aa78:	dec50513          	addi	a0,a0,-532 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aa7c:	9cff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aa80 <sfs_lookup_once.constprop.0>:
ffffffffc020aa80:	711d                	addi	sp,sp,-96
ffffffffc020aa82:	f852                	sd	s4,48(sp)
ffffffffc020aa84:	8a2a                	mv	s4,a0
ffffffffc020aa86:	02058513          	addi	a0,a1,32
ffffffffc020aa8a:	ec86                	sd	ra,88(sp)
ffffffffc020aa8c:	e0ca                	sd	s2,64(sp)
ffffffffc020aa8e:	f456                	sd	s5,40(sp)
ffffffffc020aa90:	e862                	sd	s8,16(sp)
ffffffffc020aa92:	8ab2                	mv	s5,a2
ffffffffc020aa94:	892e                	mv	s2,a1
ffffffffc020aa96:	8c36                	mv	s8,a3
ffffffffc020aa98:	b5ff90ef          	jal	ffffffffc02045f6 <down>
ffffffffc020aa9c:	8556                	mv	a0,s5
ffffffffc020aa9e:	40b000ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc020aaa2:	0ff00793          	li	a5,255
ffffffffc020aaa6:	0aa7e963          	bltu	a5,a0,ffffffffc020ab58 <sfs_lookup_once.constprop.0+0xd8>
ffffffffc020aaaa:	10400513          	li	a0,260
ffffffffc020aaae:	e4a6                	sd	s1,72(sp)
ffffffffc020aab0:	d10f70ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020aab4:	84aa                	mv	s1,a0
ffffffffc020aab6:	c959                	beqz	a0,ffffffffc020ab4c <sfs_lookup_once.constprop.0+0xcc>
ffffffffc020aab8:	00093783          	ld	a5,0(s2)
ffffffffc020aabc:	fc4e                	sd	s3,56(sp)
ffffffffc020aabe:	0087a983          	lw	s3,8(a5)
ffffffffc020aac2:	05305d63          	blez	s3,ffffffffc020ab1c <sfs_lookup_once.constprop.0+0x9c>
ffffffffc020aac6:	e8a2                	sd	s0,80(sp)
ffffffffc020aac8:	4401                	li	s0,0
ffffffffc020aaca:	a821                	j	ffffffffc020aae2 <sfs_lookup_once.constprop.0+0x62>
ffffffffc020aacc:	409c                	lw	a5,0(s1)
ffffffffc020aace:	c799                	beqz	a5,ffffffffc020aadc <sfs_lookup_once.constprop.0+0x5c>
ffffffffc020aad0:	00448593          	addi	a1,s1,4
ffffffffc020aad4:	8556                	mv	a0,s5
ffffffffc020aad6:	419000ef          	jal	ffffffffc020b6ee <strcmp>
ffffffffc020aada:	c139                	beqz	a0,ffffffffc020ab20 <sfs_lookup_once.constprop.0+0xa0>
ffffffffc020aadc:	2405                	addiw	s0,s0,1
ffffffffc020aade:	02898e63          	beq	s3,s0,ffffffffc020ab1a <sfs_lookup_once.constprop.0+0x9a>
ffffffffc020aae2:	86a6                	mv	a3,s1
ffffffffc020aae4:	8622                	mv	a2,s0
ffffffffc020aae6:	85ca                	mv	a1,s2
ffffffffc020aae8:	8552                	mv	a0,s4
ffffffffc020aaea:	8a7ff0ef          	jal	ffffffffc020a390 <sfs_dirent_read_nolock>
ffffffffc020aaee:	87aa                	mv	a5,a0
ffffffffc020aaf0:	dd71                	beqz	a0,ffffffffc020aacc <sfs_lookup_once.constprop.0+0x4c>
ffffffffc020aaf2:	6446                	ld	s0,80(sp)
ffffffffc020aaf4:	8526                	mv	a0,s1
ffffffffc020aaf6:	e43e                	sd	a5,8(sp)
ffffffffc020aaf8:	d6ef70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020aafc:	02090513          	addi	a0,s2,32
ffffffffc020ab00:	af3f90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020ab04:	67a2                	ld	a5,8(sp)
ffffffffc020ab06:	79e2                	ld	s3,56(sp)
ffffffffc020ab08:	60e6                	ld	ra,88(sp)
ffffffffc020ab0a:	64a6                	ld	s1,72(sp)
ffffffffc020ab0c:	6906                	ld	s2,64(sp)
ffffffffc020ab0e:	7a42                	ld	s4,48(sp)
ffffffffc020ab10:	7aa2                	ld	s5,40(sp)
ffffffffc020ab12:	6c42                	ld	s8,16(sp)
ffffffffc020ab14:	853e                	mv	a0,a5
ffffffffc020ab16:	6125                	addi	sp,sp,96
ffffffffc020ab18:	8082                	ret
ffffffffc020ab1a:	6446                	ld	s0,80(sp)
ffffffffc020ab1c:	57c1                	li	a5,-16
ffffffffc020ab1e:	bfd9                	j	ffffffffc020aaf4 <sfs_lookup_once.constprop.0+0x74>
ffffffffc020ab20:	8526                	mv	a0,s1
ffffffffc020ab22:	4080                	lw	s0,0(s1)
ffffffffc020ab24:	d42f70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020ab28:	02090513          	addi	a0,s2,32
ffffffffc020ab2c:	ac7f90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020ab30:	8622                	mv	a2,s0
ffffffffc020ab32:	6446                	ld	s0,80(sp)
ffffffffc020ab34:	64a6                	ld	s1,72(sp)
ffffffffc020ab36:	79e2                	ld	s3,56(sp)
ffffffffc020ab38:	60e6                	ld	ra,88(sp)
ffffffffc020ab3a:	6906                	ld	s2,64(sp)
ffffffffc020ab3c:	7aa2                	ld	s5,40(sp)
ffffffffc020ab3e:	85e2                	mv	a1,s8
ffffffffc020ab40:	8552                	mv	a0,s4
ffffffffc020ab42:	6c42                	ld	s8,16(sp)
ffffffffc020ab44:	7a42                	ld	s4,48(sp)
ffffffffc020ab46:	6125                	addi	sp,sp,96
ffffffffc020ab48:	cf7ff06f          	j	ffffffffc020a83e <sfs_load_inode>
ffffffffc020ab4c:	02090513          	addi	a0,s2,32
ffffffffc020ab50:	aa3f90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020ab54:	57f1                	li	a5,-4
ffffffffc020ab56:	bf4d                	j	ffffffffc020ab08 <sfs_lookup_once.constprop.0+0x88>
ffffffffc020ab58:	00004697          	auipc	a3,0x4
ffffffffc020ab5c:	f8068693          	addi	a3,a3,-128 # ffffffffc020ead8 <etext+0x3314>
ffffffffc020ab60:	00001617          	auipc	a2,0x1
ffffffffc020ab64:	0a060613          	addi	a2,a2,160 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ab68:	1ba00593          	li	a1,442
ffffffffc020ab6c:	00004517          	auipc	a0,0x4
ffffffffc020ab70:	cf450513          	addi	a0,a0,-780 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ab74:	e8a2                	sd	s0,80(sp)
ffffffffc020ab76:	e4a6                	sd	s1,72(sp)
ffffffffc020ab78:	fc4e                	sd	s3,56(sp)
ffffffffc020ab7a:	f05a                	sd	s6,32(sp)
ffffffffc020ab7c:	ec5e                	sd	s7,24(sp)
ffffffffc020ab7e:	8cdf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ab82 <sfs_namefile>:
ffffffffc020ab82:	6d9c                	ld	a5,24(a1)
ffffffffc020ab84:	7175                	addi	sp,sp,-144
ffffffffc020ab86:	f86a                	sd	s10,48(sp)
ffffffffc020ab88:	e506                	sd	ra,136(sp)
ffffffffc020ab8a:	f46e                	sd	s11,40(sp)
ffffffffc020ab8c:	4d09                	li	s10,2
ffffffffc020ab8e:	1afd7763          	bgeu	s10,a5,ffffffffc020ad3c <sfs_namefile+0x1ba>
ffffffffc020ab92:	f4ce                	sd	s3,104(sp)
ffffffffc020ab94:	89aa                	mv	s3,a0
ffffffffc020ab96:	10400513          	li	a0,260
ffffffffc020ab9a:	fca6                	sd	s1,120(sp)
ffffffffc020ab9c:	e42e                	sd	a1,8(sp)
ffffffffc020ab9e:	c22f70ef          	jal	ffffffffc0201fc0 <kmalloc>
ffffffffc020aba2:	84aa                	mv	s1,a0
ffffffffc020aba4:	18050a63          	beqz	a0,ffffffffc020ad38 <sfs_namefile+0x1b6>
ffffffffc020aba8:	f0d2                	sd	s4,96(sp)
ffffffffc020abaa:	0689ba03          	ld	s4,104(s3)
ffffffffc020abae:	1e0a0c63          	beqz	s4,ffffffffc020ada6 <sfs_namefile+0x224>
ffffffffc020abb2:	0b0a2783          	lw	a5,176(s4)
ffffffffc020abb6:	1e079863          	bnez	a5,ffffffffc020ada6 <sfs_namefile+0x224>
ffffffffc020abba:	0589a703          	lw	a4,88(s3)
ffffffffc020abbe:	6785                	lui	a5,0x1
ffffffffc020abc0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020abc4:	e03a                	sd	a4,0(sp)
ffffffffc020abc6:	e122                	sd	s0,128(sp)
ffffffffc020abc8:	f8ca                	sd	s2,112(sp)
ffffffffc020abca:	ecd6                	sd	s5,88(sp)
ffffffffc020abcc:	e8da                	sd	s6,80(sp)
ffffffffc020abce:	e4de                	sd	s7,72(sp)
ffffffffc020abd0:	e0e2                	sd	s8,64(sp)
ffffffffc020abd2:	1af71963          	bne	a4,a5,ffffffffc020ad84 <sfs_namefile+0x202>
ffffffffc020abd6:	6722                	ld	a4,8(sp)
ffffffffc020abd8:	854e                	mv	a0,s3
ffffffffc020abda:	8b4e                	mv	s6,s3
ffffffffc020abdc:	6f1c                	ld	a5,24(a4)
ffffffffc020abde:	00073a83          	ld	s5,0(a4)
ffffffffc020abe2:	ffe78c13          	addi	s8,a5,-2
ffffffffc020abe6:	9abe                	add	s5,s5,a5
ffffffffc020abe8:	e13fc0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc020abec:	0834                	addi	a3,sp,24
ffffffffc020abee:	00004617          	auipc	a2,0x4
ffffffffc020abf2:	f1260613          	addi	a2,a2,-238 # ffffffffc020eb00 <etext+0x333c>
ffffffffc020abf6:	85da                	mv	a1,s6
ffffffffc020abf8:	8552                	mv	a0,s4
ffffffffc020abfa:	e87ff0ef          	jal	ffffffffc020aa80 <sfs_lookup_once.constprop.0>
ffffffffc020abfe:	8daa                	mv	s11,a0
ffffffffc020ac00:	e94d                	bnez	a0,ffffffffc020acb2 <sfs_namefile+0x130>
ffffffffc020ac02:	854e                	mv	a0,s3
ffffffffc020ac04:	008b2903          	lw	s2,8(s6)
ffffffffc020ac08:	ec1fc0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020ac0c:	6462                	ld	s0,24(sp)
ffffffffc020ac0e:	0f340563          	beq	s0,s3,ffffffffc020acf8 <sfs_namefile+0x176>
ffffffffc020ac12:	14040863          	beqz	s0,ffffffffc020ad62 <sfs_namefile+0x1e0>
ffffffffc020ac16:	4c38                	lw	a4,88(s0)
ffffffffc020ac18:	6782                	ld	a5,0(sp)
ffffffffc020ac1a:	14f71463          	bne	a4,a5,ffffffffc020ad62 <sfs_namefile+0x1e0>
ffffffffc020ac1e:	4418                	lw	a4,8(s0)
ffffffffc020ac20:	13270063          	beq	a4,s2,ffffffffc020ad40 <sfs_namefile+0x1be>
ffffffffc020ac24:	6018                	ld	a4,0(s0)
ffffffffc020ac26:	00475703          	lhu	a4,4(a4)
ffffffffc020ac2a:	11a71b63          	bne	a4,s10,ffffffffc020ad40 <sfs_namefile+0x1be>
ffffffffc020ac2e:	02040b93          	addi	s7,s0,32
ffffffffc020ac32:	855e                	mv	a0,s7
ffffffffc020ac34:	9c3f90ef          	jal	ffffffffc02045f6 <down>
ffffffffc020ac38:	6018                	ld	a4,0(s0)
ffffffffc020ac3a:	00872983          	lw	s3,8(a4)
ffffffffc020ac3e:	0b305763          	blez	s3,ffffffffc020acec <sfs_namefile+0x16a>
ffffffffc020ac42:	8b22                	mv	s6,s0
ffffffffc020ac44:	a039                	j	ffffffffc020ac52 <sfs_namefile+0xd0>
ffffffffc020ac46:	4098                	lw	a4,0(s1)
ffffffffc020ac48:	01270e63          	beq	a4,s2,ffffffffc020ac64 <sfs_namefile+0xe2>
ffffffffc020ac4c:	2d85                	addiw	s11,s11,1
ffffffffc020ac4e:	09b98763          	beq	s3,s11,ffffffffc020acdc <sfs_namefile+0x15a>
ffffffffc020ac52:	86a6                	mv	a3,s1
ffffffffc020ac54:	866e                	mv	a2,s11
ffffffffc020ac56:	85a2                	mv	a1,s0
ffffffffc020ac58:	8552                	mv	a0,s4
ffffffffc020ac5a:	f36ff0ef          	jal	ffffffffc020a390 <sfs_dirent_read_nolock>
ffffffffc020ac5e:	872a                	mv	a4,a0
ffffffffc020ac60:	d17d                	beqz	a0,ffffffffc020ac46 <sfs_namefile+0xc4>
ffffffffc020ac62:	a8b5                	j	ffffffffc020acde <sfs_namefile+0x15c>
ffffffffc020ac64:	855e                	mv	a0,s7
ffffffffc020ac66:	98df90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020ac6a:	00448513          	addi	a0,s1,4
ffffffffc020ac6e:	23b000ef          	jal	ffffffffc020b6a8 <strlen>
ffffffffc020ac72:	00150793          	addi	a5,a0,1
ffffffffc020ac76:	0afc6e63          	bltu	s8,a5,ffffffffc020ad32 <sfs_namefile+0x1b0>
ffffffffc020ac7a:	fff54913          	not	s2,a0
ffffffffc020ac7e:	862a                	mv	a2,a0
ffffffffc020ac80:	00448593          	addi	a1,s1,4
ffffffffc020ac84:	012a8533          	add	a0,s5,s2
ffffffffc020ac88:	40fc0c33          	sub	s8,s8,a5
ffffffffc020ac8c:	321000ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc020ac90:	02f00793          	li	a5,47
ffffffffc020ac94:	fefa8fa3          	sb	a5,-1(s5)
ffffffffc020ac98:	0834                	addi	a3,sp,24
ffffffffc020ac9a:	00004617          	auipc	a2,0x4
ffffffffc020ac9e:	e6660613          	addi	a2,a2,-410 # ffffffffc020eb00 <etext+0x333c>
ffffffffc020aca2:	85da                	mv	a1,s6
ffffffffc020aca4:	8552                	mv	a0,s4
ffffffffc020aca6:	ddbff0ef          	jal	ffffffffc020aa80 <sfs_lookup_once.constprop.0>
ffffffffc020acaa:	89a2                	mv	s3,s0
ffffffffc020acac:	9aca                	add	s5,s5,s2
ffffffffc020acae:	8daa                	mv	s11,a0
ffffffffc020acb0:	d929                	beqz	a0,ffffffffc020ac02 <sfs_namefile+0x80>
ffffffffc020acb2:	854e                	mv	a0,s3
ffffffffc020acb4:	e15fc0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020acb8:	8526                	mv	a0,s1
ffffffffc020acba:	bacf70ef          	jal	ffffffffc0202066 <kfree>
ffffffffc020acbe:	640a                	ld	s0,128(sp)
ffffffffc020acc0:	74e6                	ld	s1,120(sp)
ffffffffc020acc2:	7946                	ld	s2,112(sp)
ffffffffc020acc4:	79a6                	ld	s3,104(sp)
ffffffffc020acc6:	7a06                	ld	s4,96(sp)
ffffffffc020acc8:	6ae6                	ld	s5,88(sp)
ffffffffc020acca:	6b46                	ld	s6,80(sp)
ffffffffc020accc:	6ba6                	ld	s7,72(sp)
ffffffffc020acce:	6c06                	ld	s8,64(sp)
ffffffffc020acd0:	60aa                	ld	ra,136(sp)
ffffffffc020acd2:	7d42                	ld	s10,48(sp)
ffffffffc020acd4:	856e                	mv	a0,s11
ffffffffc020acd6:	7da2                	ld	s11,40(sp)
ffffffffc020acd8:	6149                	addi	sp,sp,144
ffffffffc020acda:	8082                	ret
ffffffffc020acdc:	5741                	li	a4,-16
ffffffffc020acde:	855e                	mv	a0,s7
ffffffffc020ace0:	e03a                	sd	a4,0(sp)
ffffffffc020ace2:	89a2                	mv	s3,s0
ffffffffc020ace4:	90ff90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020ace8:	6d82                	ld	s11,0(sp)
ffffffffc020acea:	b7e1                	j	ffffffffc020acb2 <sfs_namefile+0x130>
ffffffffc020acec:	855e                	mv	a0,s7
ffffffffc020acee:	905f90ef          	jal	ffffffffc02045f2 <up>
ffffffffc020acf2:	89a2                	mv	s3,s0
ffffffffc020acf4:	5dc1                	li	s11,-16
ffffffffc020acf6:	bf75                	j	ffffffffc020acb2 <sfs_namefile+0x130>
ffffffffc020acf8:	854e                	mv	a0,s3
ffffffffc020acfa:	dcffc0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020acfe:	6922                	ld	s2,8(sp)
ffffffffc020ad00:	85d6                	mv	a1,s5
ffffffffc020ad02:	01893403          	ld	s0,24(s2)
ffffffffc020ad06:	00093503          	ld	a0,0(s2)
ffffffffc020ad0a:	1479                	addi	s0,s0,-2
ffffffffc020ad0c:	41840433          	sub	s0,s0,s8
ffffffffc020ad10:	8622                	mv	a2,s0
ffffffffc020ad12:	0505                	addi	a0,a0,1
ffffffffc020ad14:	25b000ef          	jal	ffffffffc020b76e <memmove>
ffffffffc020ad18:	02f00713          	li	a4,47
ffffffffc020ad1c:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ad20:	00850733          	add	a4,a0,s0
ffffffffc020ad24:	00070023          	sb	zero,0(a4)
ffffffffc020ad28:	854a                	mv	a0,s2
ffffffffc020ad2a:	85a2                	mv	a1,s0
ffffffffc020ad2c:	feefa0ef          	jal	ffffffffc020551a <iobuf_skip>
ffffffffc020ad30:	b761                	j	ffffffffc020acb8 <sfs_namefile+0x136>
ffffffffc020ad32:	89a2                	mv	s3,s0
ffffffffc020ad34:	5df1                	li	s11,-4
ffffffffc020ad36:	bfb5                	j	ffffffffc020acb2 <sfs_namefile+0x130>
ffffffffc020ad38:	74e6                	ld	s1,120(sp)
ffffffffc020ad3a:	79a6                	ld	s3,104(sp)
ffffffffc020ad3c:	5df1                	li	s11,-4
ffffffffc020ad3e:	bf49                	j	ffffffffc020acd0 <sfs_namefile+0x14e>
ffffffffc020ad40:	00004697          	auipc	a3,0x4
ffffffffc020ad44:	dc868693          	addi	a3,a3,-568 # ffffffffc020eb08 <etext+0x3344>
ffffffffc020ad48:	00001617          	auipc	a2,0x1
ffffffffc020ad4c:	eb860613          	addi	a2,a2,-328 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ad50:	30500593          	li	a1,773
ffffffffc020ad54:	00004517          	auipc	a0,0x4
ffffffffc020ad58:	b0c50513          	addi	a0,a0,-1268 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ad5c:	fc66                	sd	s9,56(sp)
ffffffffc020ad5e:	eecf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad62:	00004697          	auipc	a3,0x4
ffffffffc020ad66:	ac668693          	addi	a3,a3,-1338 # ffffffffc020e828 <etext+0x3064>
ffffffffc020ad6a:	00001617          	auipc	a2,0x1
ffffffffc020ad6e:	e9660613          	addi	a2,a2,-362 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ad72:	30400593          	li	a1,772
ffffffffc020ad76:	00004517          	auipc	a0,0x4
ffffffffc020ad7a:	aea50513          	addi	a0,a0,-1302 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ad7e:	fc66                	sd	s9,56(sp)
ffffffffc020ad80:	ecaf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad84:	00004697          	auipc	a3,0x4
ffffffffc020ad88:	aa468693          	addi	a3,a3,-1372 # ffffffffc020e828 <etext+0x3064>
ffffffffc020ad8c:	00001617          	auipc	a2,0x1
ffffffffc020ad90:	e7460613          	addi	a2,a2,-396 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ad94:	2f100593          	li	a1,753
ffffffffc020ad98:	00004517          	auipc	a0,0x4
ffffffffc020ad9c:	ac850513          	addi	a0,a0,-1336 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ada0:	fc66                	sd	s9,56(sp)
ffffffffc020ada2:	ea8f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ada6:	00004697          	auipc	a3,0x4
ffffffffc020adaa:	8da68693          	addi	a3,a3,-1830 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020adae:	00001617          	auipc	a2,0x1
ffffffffc020adb2:	e5260613          	addi	a2,a2,-430 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020adb6:	2f000593          	li	a1,752
ffffffffc020adba:	00004517          	auipc	a0,0x4
ffffffffc020adbe:	aa650513          	addi	a0,a0,-1370 # ffffffffc020e860 <etext+0x309c>
ffffffffc020adc2:	e122                	sd	s0,128(sp)
ffffffffc020adc4:	f8ca                	sd	s2,112(sp)
ffffffffc020adc6:	ecd6                	sd	s5,88(sp)
ffffffffc020adc8:	e8da                	sd	s6,80(sp)
ffffffffc020adca:	e4de                	sd	s7,72(sp)
ffffffffc020adcc:	e0e2                	sd	s8,64(sp)
ffffffffc020adce:	fc66                	sd	s9,56(sp)
ffffffffc020add0:	e7af50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020add4 <sfs_lookup>:
ffffffffc020add4:	7139                	addi	sp,sp,-64
ffffffffc020add6:	f426                	sd	s1,40(sp)
ffffffffc020add8:	7524                	ld	s1,104(a0)
ffffffffc020adda:	fc06                	sd	ra,56(sp)
ffffffffc020addc:	f822                	sd	s0,48(sp)
ffffffffc020adde:	f04a                	sd	s2,32(sp)
ffffffffc020ade0:	c4b5                	beqz	s1,ffffffffc020ae4c <sfs_lookup+0x78>
ffffffffc020ade2:	0b04a783          	lw	a5,176(s1)
ffffffffc020ade6:	e3bd                	bnez	a5,ffffffffc020ae4c <sfs_lookup+0x78>
ffffffffc020ade8:	0005c783          	lbu	a5,0(a1)
ffffffffc020adec:	c3c5                	beqz	a5,ffffffffc020ae8c <sfs_lookup+0xb8>
ffffffffc020adee:	fd178793          	addi	a5,a5,-47
ffffffffc020adf2:	cfc9                	beqz	a5,ffffffffc020ae8c <sfs_lookup+0xb8>
ffffffffc020adf4:	842a                	mv	s0,a0
ffffffffc020adf6:	8932                	mv	s2,a2
ffffffffc020adf8:	e42e                	sd	a1,8(sp)
ffffffffc020adfa:	c01fc0ef          	jal	ffffffffc02079fa <inode_ref_inc>
ffffffffc020adfe:	4c38                	lw	a4,88(s0)
ffffffffc020ae00:	6785                	lui	a5,0x1
ffffffffc020ae02:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ae06:	06f71363          	bne	a4,a5,ffffffffc020ae6c <sfs_lookup+0x98>
ffffffffc020ae0a:	6018                	ld	a4,0(s0)
ffffffffc020ae0c:	4789                	li	a5,2
ffffffffc020ae0e:	00475703          	lhu	a4,4(a4)
ffffffffc020ae12:	02f71863          	bne	a4,a5,ffffffffc020ae42 <sfs_lookup+0x6e>
ffffffffc020ae16:	6622                	ld	a2,8(sp)
ffffffffc020ae18:	85a2                	mv	a1,s0
ffffffffc020ae1a:	8526                	mv	a0,s1
ffffffffc020ae1c:	0834                	addi	a3,sp,24
ffffffffc020ae1e:	c63ff0ef          	jal	ffffffffc020aa80 <sfs_lookup_once.constprop.0>
ffffffffc020ae22:	87aa                	mv	a5,a0
ffffffffc020ae24:	8522                	mv	a0,s0
ffffffffc020ae26:	843e                	mv	s0,a5
ffffffffc020ae28:	ca1fc0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020ae2c:	e401                	bnez	s0,ffffffffc020ae34 <sfs_lookup+0x60>
ffffffffc020ae2e:	67e2                	ld	a5,24(sp)
ffffffffc020ae30:	00f93023          	sd	a5,0(s2)
ffffffffc020ae34:	70e2                	ld	ra,56(sp)
ffffffffc020ae36:	8522                	mv	a0,s0
ffffffffc020ae38:	7442                	ld	s0,48(sp)
ffffffffc020ae3a:	74a2                	ld	s1,40(sp)
ffffffffc020ae3c:	7902                	ld	s2,32(sp)
ffffffffc020ae3e:	6121                	addi	sp,sp,64
ffffffffc020ae40:	8082                	ret
ffffffffc020ae42:	8522                	mv	a0,s0
ffffffffc020ae44:	c85fc0ef          	jal	ffffffffc0207ac8 <inode_ref_dec>
ffffffffc020ae48:	5439                	li	s0,-18
ffffffffc020ae4a:	b7ed                	j	ffffffffc020ae34 <sfs_lookup+0x60>
ffffffffc020ae4c:	00004697          	auipc	a3,0x4
ffffffffc020ae50:	83468693          	addi	a3,a3,-1996 # ffffffffc020e680 <etext+0x2ebc>
ffffffffc020ae54:	00001617          	auipc	a2,0x1
ffffffffc020ae58:	dac60613          	addi	a2,a2,-596 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ae5c:	3e600593          	li	a1,998
ffffffffc020ae60:	00004517          	auipc	a0,0x4
ffffffffc020ae64:	a0050513          	addi	a0,a0,-1536 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ae68:	de2f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae6c:	00004697          	auipc	a3,0x4
ffffffffc020ae70:	9bc68693          	addi	a3,a3,-1604 # ffffffffc020e828 <etext+0x3064>
ffffffffc020ae74:	00001617          	auipc	a2,0x1
ffffffffc020ae78:	d8c60613          	addi	a2,a2,-628 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ae7c:	3e900593          	li	a1,1001
ffffffffc020ae80:	00004517          	auipc	a0,0x4
ffffffffc020ae84:	9e050513          	addi	a0,a0,-1568 # ffffffffc020e860 <etext+0x309c>
ffffffffc020ae88:	dc2f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae8c:	00004697          	auipc	a3,0x4
ffffffffc020ae90:	cb468693          	addi	a3,a3,-844 # ffffffffc020eb40 <etext+0x337c>
ffffffffc020ae94:	00001617          	auipc	a2,0x1
ffffffffc020ae98:	d6c60613          	addi	a2,a2,-660 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020ae9c:	3e700593          	li	a1,999
ffffffffc020aea0:	00004517          	auipc	a0,0x4
ffffffffc020aea4:	9c050513          	addi	a0,a0,-1600 # ffffffffc020e860 <etext+0x309c>
ffffffffc020aea8:	da2f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aeac <sfs_rwblock_nolock>:
ffffffffc020aeac:	7139                	addi	sp,sp,-64
ffffffffc020aeae:	f822                	sd	s0,48(sp)
ffffffffc020aeb0:	f426                	sd	s1,40(sp)
ffffffffc020aeb2:	fc06                	sd	ra,56(sp)
ffffffffc020aeb4:	842a                	mv	s0,a0
ffffffffc020aeb6:	84b6                	mv	s1,a3
ffffffffc020aeb8:	e219                	bnez	a2,ffffffffc020aebe <sfs_rwblock_nolock+0x12>
ffffffffc020aeba:	8b05                	andi	a4,a4,1
ffffffffc020aebc:	e71d                	bnez	a4,ffffffffc020aeea <sfs_rwblock_nolock+0x3e>
ffffffffc020aebe:	405c                	lw	a5,4(s0)
ffffffffc020aec0:	02f67563          	bgeu	a2,a5,ffffffffc020aeea <sfs_rwblock_nolock+0x3e>
ffffffffc020aec4:	00c6161b          	slliw	a2,a2,0xc
ffffffffc020aec8:	02061693          	slli	a3,a2,0x20
ffffffffc020aecc:	9281                	srli	a3,a3,0x20
ffffffffc020aece:	6605                	lui	a2,0x1
ffffffffc020aed0:	850a                	mv	a0,sp
ffffffffc020aed2:	dbafa0ef          	jal	ffffffffc020548c <iobuf_init>
ffffffffc020aed6:	85aa                	mv	a1,a0
ffffffffc020aed8:	7808                	ld	a0,48(s0)
ffffffffc020aeda:	8626                	mv	a2,s1
ffffffffc020aedc:	7118                	ld	a4,32(a0)
ffffffffc020aede:	9702                	jalr	a4
ffffffffc020aee0:	70e2                	ld	ra,56(sp)
ffffffffc020aee2:	7442                	ld	s0,48(sp)
ffffffffc020aee4:	74a2                	ld	s1,40(sp)
ffffffffc020aee6:	6121                	addi	sp,sp,64
ffffffffc020aee8:	8082                	ret
ffffffffc020aeea:	00004697          	auipc	a3,0x4
ffffffffc020aeee:	c7668693          	addi	a3,a3,-906 # ffffffffc020eb60 <etext+0x339c>
ffffffffc020aef2:	00001617          	auipc	a2,0x1
ffffffffc020aef6:	d0e60613          	addi	a2,a2,-754 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020aefa:	45d5                	li	a1,21
ffffffffc020aefc:	00004517          	auipc	a0,0x4
ffffffffc020af00:	c9c50513          	addi	a0,a0,-868 # ffffffffc020eb98 <etext+0x33d4>
ffffffffc020af04:	d46f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020af08 <sfs_rblock>:
ffffffffc020af08:	7139                	addi	sp,sp,-64
ffffffffc020af0a:	ec4e                	sd	s3,24(sp)
ffffffffc020af0c:	89b6                	mv	s3,a3
ffffffffc020af0e:	f822                	sd	s0,48(sp)
ffffffffc020af10:	f04a                	sd	s2,32(sp)
ffffffffc020af12:	e852                	sd	s4,16(sp)
ffffffffc020af14:	fc06                	sd	ra,56(sp)
ffffffffc020af16:	f426                	sd	s1,40(sp)
ffffffffc020af18:	892e                	mv	s2,a1
ffffffffc020af1a:	8432                	mv	s0,a2
ffffffffc020af1c:	8a2a                	mv	s4,a0
ffffffffc020af1e:	2ea000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020af22:	02098763          	beqz	s3,ffffffffc020af50 <sfs_rblock+0x48>
ffffffffc020af26:	e456                	sd	s5,8(sp)
ffffffffc020af28:	013409bb          	addw	s3,s0,s3
ffffffffc020af2c:	6a85                	lui	s5,0x1
ffffffffc020af2e:	a021                	j	ffffffffc020af36 <sfs_rblock+0x2e>
ffffffffc020af30:	9956                	add	s2,s2,s5
ffffffffc020af32:	01340e63          	beq	s0,s3,ffffffffc020af4e <sfs_rblock+0x46>
ffffffffc020af36:	8622                	mv	a2,s0
ffffffffc020af38:	4705                	li	a4,1
ffffffffc020af3a:	4681                	li	a3,0
ffffffffc020af3c:	85ca                	mv	a1,s2
ffffffffc020af3e:	8552                	mv	a0,s4
ffffffffc020af40:	f6dff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020af44:	84aa                	mv	s1,a0
ffffffffc020af46:	2405                	addiw	s0,s0,1
ffffffffc020af48:	d565                	beqz	a0,ffffffffc020af30 <sfs_rblock+0x28>
ffffffffc020af4a:	6aa2                	ld	s5,8(sp)
ffffffffc020af4c:	a019                	j	ffffffffc020af52 <sfs_rblock+0x4a>
ffffffffc020af4e:	6aa2                	ld	s5,8(sp)
ffffffffc020af50:	4481                	li	s1,0
ffffffffc020af52:	8552                	mv	a0,s4
ffffffffc020af54:	2c4000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020af58:	70e2                	ld	ra,56(sp)
ffffffffc020af5a:	7442                	ld	s0,48(sp)
ffffffffc020af5c:	7902                	ld	s2,32(sp)
ffffffffc020af5e:	69e2                	ld	s3,24(sp)
ffffffffc020af60:	6a42                	ld	s4,16(sp)
ffffffffc020af62:	8526                	mv	a0,s1
ffffffffc020af64:	74a2                	ld	s1,40(sp)
ffffffffc020af66:	6121                	addi	sp,sp,64
ffffffffc020af68:	8082                	ret

ffffffffc020af6a <sfs_wblock>:
ffffffffc020af6a:	7139                	addi	sp,sp,-64
ffffffffc020af6c:	ec4e                	sd	s3,24(sp)
ffffffffc020af6e:	89b6                	mv	s3,a3
ffffffffc020af70:	f822                	sd	s0,48(sp)
ffffffffc020af72:	f04a                	sd	s2,32(sp)
ffffffffc020af74:	e852                	sd	s4,16(sp)
ffffffffc020af76:	fc06                	sd	ra,56(sp)
ffffffffc020af78:	f426                	sd	s1,40(sp)
ffffffffc020af7a:	892e                	mv	s2,a1
ffffffffc020af7c:	8432                	mv	s0,a2
ffffffffc020af7e:	8a2a                	mv	s4,a0
ffffffffc020af80:	288000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020af84:	02098763          	beqz	s3,ffffffffc020afb2 <sfs_wblock+0x48>
ffffffffc020af88:	e456                	sd	s5,8(sp)
ffffffffc020af8a:	013409bb          	addw	s3,s0,s3
ffffffffc020af8e:	6a85                	lui	s5,0x1
ffffffffc020af90:	a021                	j	ffffffffc020af98 <sfs_wblock+0x2e>
ffffffffc020af92:	9956                	add	s2,s2,s5
ffffffffc020af94:	01340e63          	beq	s0,s3,ffffffffc020afb0 <sfs_wblock+0x46>
ffffffffc020af98:	4705                	li	a4,1
ffffffffc020af9a:	8622                	mv	a2,s0
ffffffffc020af9c:	86ba                	mv	a3,a4
ffffffffc020af9e:	85ca                	mv	a1,s2
ffffffffc020afa0:	8552                	mv	a0,s4
ffffffffc020afa2:	f0bff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020afa6:	84aa                	mv	s1,a0
ffffffffc020afa8:	2405                	addiw	s0,s0,1
ffffffffc020afaa:	d565                	beqz	a0,ffffffffc020af92 <sfs_wblock+0x28>
ffffffffc020afac:	6aa2                	ld	s5,8(sp)
ffffffffc020afae:	a019                	j	ffffffffc020afb4 <sfs_wblock+0x4a>
ffffffffc020afb0:	6aa2                	ld	s5,8(sp)
ffffffffc020afb2:	4481                	li	s1,0
ffffffffc020afb4:	8552                	mv	a0,s4
ffffffffc020afb6:	262000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020afba:	70e2                	ld	ra,56(sp)
ffffffffc020afbc:	7442                	ld	s0,48(sp)
ffffffffc020afbe:	7902                	ld	s2,32(sp)
ffffffffc020afc0:	69e2                	ld	s3,24(sp)
ffffffffc020afc2:	6a42                	ld	s4,16(sp)
ffffffffc020afc4:	8526                	mv	a0,s1
ffffffffc020afc6:	74a2                	ld	s1,40(sp)
ffffffffc020afc8:	6121                	addi	sp,sp,64
ffffffffc020afca:	8082                	ret

ffffffffc020afcc <sfs_rbuf>:
ffffffffc020afcc:	7179                	addi	sp,sp,-48
ffffffffc020afce:	f406                	sd	ra,40(sp)
ffffffffc020afd0:	f022                	sd	s0,32(sp)
ffffffffc020afd2:	ec26                	sd	s1,24(sp)
ffffffffc020afd4:	e84a                	sd	s2,16(sp)
ffffffffc020afd6:	e44e                	sd	s3,8(sp)
ffffffffc020afd8:	e052                	sd	s4,0(sp)
ffffffffc020afda:	6785                	lui	a5,0x1
ffffffffc020afdc:	04f77863          	bgeu	a4,a5,ffffffffc020b02c <sfs_rbuf+0x60>
ffffffffc020afe0:	84ba                	mv	s1,a4
ffffffffc020afe2:	9732                	add	a4,a4,a2
ffffffffc020afe4:	04e7e463          	bltu	a5,a4,ffffffffc020b02c <sfs_rbuf+0x60>
ffffffffc020afe8:	8936                	mv	s2,a3
ffffffffc020afea:	842a                	mv	s0,a0
ffffffffc020afec:	89ae                	mv	s3,a1
ffffffffc020afee:	8a32                	mv	s4,a2
ffffffffc020aff0:	218000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020aff4:	642c                	ld	a1,72(s0)
ffffffffc020aff6:	864a                	mv	a2,s2
ffffffffc020aff8:	8522                	mv	a0,s0
ffffffffc020affa:	4705                	li	a4,1
ffffffffc020affc:	4681                	li	a3,0
ffffffffc020affe:	eafff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b002:	892a                	mv	s2,a0
ffffffffc020b004:	cd09                	beqz	a0,ffffffffc020b01e <sfs_rbuf+0x52>
ffffffffc020b006:	8522                	mv	a0,s0
ffffffffc020b008:	210000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020b00c:	70a2                	ld	ra,40(sp)
ffffffffc020b00e:	7402                	ld	s0,32(sp)
ffffffffc020b010:	64e2                	ld	s1,24(sp)
ffffffffc020b012:	69a2                	ld	s3,8(sp)
ffffffffc020b014:	6a02                	ld	s4,0(sp)
ffffffffc020b016:	854a                	mv	a0,s2
ffffffffc020b018:	6942                	ld	s2,16(sp)
ffffffffc020b01a:	6145                	addi	sp,sp,48
ffffffffc020b01c:	8082                	ret
ffffffffc020b01e:	642c                	ld	a1,72(s0)
ffffffffc020b020:	8652                	mv	a2,s4
ffffffffc020b022:	854e                	mv	a0,s3
ffffffffc020b024:	95a6                	add	a1,a1,s1
ffffffffc020b026:	786000ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc020b02a:	bff1                	j	ffffffffc020b006 <sfs_rbuf+0x3a>
ffffffffc020b02c:	00004697          	auipc	a3,0x4
ffffffffc020b030:	b8468693          	addi	a3,a3,-1148 # ffffffffc020ebb0 <etext+0x33ec>
ffffffffc020b034:	00001617          	auipc	a2,0x1
ffffffffc020b038:	bcc60613          	addi	a2,a2,-1076 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020b03c:	05500593          	li	a1,85
ffffffffc020b040:	00004517          	auipc	a0,0x4
ffffffffc020b044:	b5850513          	addi	a0,a0,-1192 # ffffffffc020eb98 <etext+0x33d4>
ffffffffc020b048:	c02f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b04c <sfs_wbuf>:
ffffffffc020b04c:	7139                	addi	sp,sp,-64
ffffffffc020b04e:	fc06                	sd	ra,56(sp)
ffffffffc020b050:	f822                	sd	s0,48(sp)
ffffffffc020b052:	f426                	sd	s1,40(sp)
ffffffffc020b054:	f04a                	sd	s2,32(sp)
ffffffffc020b056:	ec4e                	sd	s3,24(sp)
ffffffffc020b058:	e852                	sd	s4,16(sp)
ffffffffc020b05a:	e456                	sd	s5,8(sp)
ffffffffc020b05c:	6785                	lui	a5,0x1
ffffffffc020b05e:	06f77163          	bgeu	a4,a5,ffffffffc020b0c0 <sfs_wbuf+0x74>
ffffffffc020b062:	893a                	mv	s2,a4
ffffffffc020b064:	9732                	add	a4,a4,a2
ffffffffc020b066:	04e7ed63          	bltu	a5,a4,ffffffffc020b0c0 <sfs_wbuf+0x74>
ffffffffc020b06a:	89b6                	mv	s3,a3
ffffffffc020b06c:	84aa                	mv	s1,a0
ffffffffc020b06e:	8a2e                	mv	s4,a1
ffffffffc020b070:	8ab2                	mv	s5,a2
ffffffffc020b072:	196000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020b076:	64ac                	ld	a1,72(s1)
ffffffffc020b078:	864e                	mv	a2,s3
ffffffffc020b07a:	8526                	mv	a0,s1
ffffffffc020b07c:	4705                	li	a4,1
ffffffffc020b07e:	4681                	li	a3,0
ffffffffc020b080:	e2dff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b084:	842a                	mv	s0,a0
ffffffffc020b086:	cd11                	beqz	a0,ffffffffc020b0a2 <sfs_wbuf+0x56>
ffffffffc020b088:	8526                	mv	a0,s1
ffffffffc020b08a:	18e000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020b08e:	70e2                	ld	ra,56(sp)
ffffffffc020b090:	8522                	mv	a0,s0
ffffffffc020b092:	7442                	ld	s0,48(sp)
ffffffffc020b094:	74a2                	ld	s1,40(sp)
ffffffffc020b096:	7902                	ld	s2,32(sp)
ffffffffc020b098:	69e2                	ld	s3,24(sp)
ffffffffc020b09a:	6a42                	ld	s4,16(sp)
ffffffffc020b09c:	6aa2                	ld	s5,8(sp)
ffffffffc020b09e:	6121                	addi	sp,sp,64
ffffffffc020b0a0:	8082                	ret
ffffffffc020b0a2:	64a8                	ld	a0,72(s1)
ffffffffc020b0a4:	8656                	mv	a2,s5
ffffffffc020b0a6:	85d2                	mv	a1,s4
ffffffffc020b0a8:	954a                	add	a0,a0,s2
ffffffffc020b0aa:	702000ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc020b0ae:	64ac                	ld	a1,72(s1)
ffffffffc020b0b0:	4705                	li	a4,1
ffffffffc020b0b2:	864e                	mv	a2,s3
ffffffffc020b0b4:	8526                	mv	a0,s1
ffffffffc020b0b6:	86ba                	mv	a3,a4
ffffffffc020b0b8:	df5ff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b0bc:	842a                	mv	s0,a0
ffffffffc020b0be:	b7e9                	j	ffffffffc020b088 <sfs_wbuf+0x3c>
ffffffffc020b0c0:	00004697          	auipc	a3,0x4
ffffffffc020b0c4:	af068693          	addi	a3,a3,-1296 # ffffffffc020ebb0 <etext+0x33ec>
ffffffffc020b0c8:	00001617          	auipc	a2,0x1
ffffffffc020b0cc:	b3860613          	addi	a2,a2,-1224 # ffffffffc020bc00 <etext+0x43c>
ffffffffc020b0d0:	06b00593          	li	a1,107
ffffffffc020b0d4:	00004517          	auipc	a0,0x4
ffffffffc020b0d8:	ac450513          	addi	a0,a0,-1340 # ffffffffc020eb98 <etext+0x33d4>
ffffffffc020b0dc:	b6ef50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b0e0 <sfs_sync_super>:
ffffffffc020b0e0:	1101                	addi	sp,sp,-32
ffffffffc020b0e2:	ec06                	sd	ra,24(sp)
ffffffffc020b0e4:	e822                	sd	s0,16(sp)
ffffffffc020b0e6:	e426                	sd	s1,8(sp)
ffffffffc020b0e8:	842a                	mv	s0,a0
ffffffffc020b0ea:	11e000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020b0ee:	6428                	ld	a0,72(s0)
ffffffffc020b0f0:	6605                	lui	a2,0x1
ffffffffc020b0f2:	4581                	li	a1,0
ffffffffc020b0f4:	668000ef          	jal	ffffffffc020b75c <memset>
ffffffffc020b0f8:	6428                	ld	a0,72(s0)
ffffffffc020b0fa:	85a2                	mv	a1,s0
ffffffffc020b0fc:	02c00613          	li	a2,44
ffffffffc020b100:	6ac000ef          	jal	ffffffffc020b7ac <memcpy>
ffffffffc020b104:	642c                	ld	a1,72(s0)
ffffffffc020b106:	8522                	mv	a0,s0
ffffffffc020b108:	4701                	li	a4,0
ffffffffc020b10a:	4685                	li	a3,1
ffffffffc020b10c:	4601                	li	a2,0
ffffffffc020b10e:	d9fff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b112:	84aa                	mv	s1,a0
ffffffffc020b114:	8522                	mv	a0,s0
ffffffffc020b116:	102000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020b11a:	60e2                	ld	ra,24(sp)
ffffffffc020b11c:	6442                	ld	s0,16(sp)
ffffffffc020b11e:	8526                	mv	a0,s1
ffffffffc020b120:	64a2                	ld	s1,8(sp)
ffffffffc020b122:	6105                	addi	sp,sp,32
ffffffffc020b124:	8082                	ret

ffffffffc020b126 <sfs_sync_freemap>:
ffffffffc020b126:	7139                	addi	sp,sp,-64
ffffffffc020b128:	ec4e                	sd	s3,24(sp)
ffffffffc020b12a:	e852                	sd	s4,16(sp)
ffffffffc020b12c:	00456983          	lwu	s3,4(a0)
ffffffffc020b130:	8a2a                	mv	s4,a0
ffffffffc020b132:	7d08                	ld	a0,56(a0)
ffffffffc020b134:	67a1                	lui	a5,0x8
ffffffffc020b136:	17fd                	addi	a5,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020b138:	4581                	li	a1,0
ffffffffc020b13a:	f822                	sd	s0,48(sp)
ffffffffc020b13c:	fc06                	sd	ra,56(sp)
ffffffffc020b13e:	f426                	sd	s1,40(sp)
ffffffffc020b140:	99be                	add	s3,s3,a5
ffffffffc020b142:	956fe0ef          	jal	ffffffffc0209298 <bitmap_getdata>
ffffffffc020b146:	00f9d993          	srli	s3,s3,0xf
ffffffffc020b14a:	842a                	mv	s0,a0
ffffffffc020b14c:	8552                	mv	a0,s4
ffffffffc020b14e:	0ba000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020b152:	02098b63          	beqz	s3,ffffffffc020b188 <sfs_sync_freemap+0x62>
ffffffffc020b156:	09b2                	slli	s3,s3,0xc
ffffffffc020b158:	f04a                	sd	s2,32(sp)
ffffffffc020b15a:	e456                	sd	s5,8(sp)
ffffffffc020b15c:	99a2                	add	s3,s3,s0
ffffffffc020b15e:	4909                	li	s2,2
ffffffffc020b160:	6a85                	lui	s5,0x1
ffffffffc020b162:	a021                	j	ffffffffc020b16a <sfs_sync_freemap+0x44>
ffffffffc020b164:	2905                	addiw	s2,s2,1
ffffffffc020b166:	01340f63          	beq	s0,s3,ffffffffc020b184 <sfs_sync_freemap+0x5e>
ffffffffc020b16a:	4705                	li	a4,1
ffffffffc020b16c:	85a2                	mv	a1,s0
ffffffffc020b16e:	86ba                	mv	a3,a4
ffffffffc020b170:	864a                	mv	a2,s2
ffffffffc020b172:	8552                	mv	a0,s4
ffffffffc020b174:	d39ff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b178:	84aa                	mv	s1,a0
ffffffffc020b17a:	9456                	add	s0,s0,s5
ffffffffc020b17c:	d565                	beqz	a0,ffffffffc020b164 <sfs_sync_freemap+0x3e>
ffffffffc020b17e:	7902                	ld	s2,32(sp)
ffffffffc020b180:	6aa2                	ld	s5,8(sp)
ffffffffc020b182:	a021                	j	ffffffffc020b18a <sfs_sync_freemap+0x64>
ffffffffc020b184:	7902                	ld	s2,32(sp)
ffffffffc020b186:	6aa2                	ld	s5,8(sp)
ffffffffc020b188:	4481                	li	s1,0
ffffffffc020b18a:	8552                	mv	a0,s4
ffffffffc020b18c:	08c000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020b190:	70e2                	ld	ra,56(sp)
ffffffffc020b192:	7442                	ld	s0,48(sp)
ffffffffc020b194:	69e2                	ld	s3,24(sp)
ffffffffc020b196:	6a42                	ld	s4,16(sp)
ffffffffc020b198:	8526                	mv	a0,s1
ffffffffc020b19a:	74a2                	ld	s1,40(sp)
ffffffffc020b19c:	6121                	addi	sp,sp,64
ffffffffc020b19e:	8082                	ret

ffffffffc020b1a0 <sfs_clear_block>:
ffffffffc020b1a0:	7179                	addi	sp,sp,-48
ffffffffc020b1a2:	f022                	sd	s0,32(sp)
ffffffffc020b1a4:	e84a                	sd	s2,16(sp)
ffffffffc020b1a6:	e44e                	sd	s3,8(sp)
ffffffffc020b1a8:	f406                	sd	ra,40(sp)
ffffffffc020b1aa:	89b2                	mv	s3,a2
ffffffffc020b1ac:	ec26                	sd	s1,24(sp)
ffffffffc020b1ae:	842e                	mv	s0,a1
ffffffffc020b1b0:	892a                	mv	s2,a0
ffffffffc020b1b2:	056000ef          	jal	ffffffffc020b208 <lock_sfs_io>
ffffffffc020b1b6:	04893503          	ld	a0,72(s2)
ffffffffc020b1ba:	6605                	lui	a2,0x1
ffffffffc020b1bc:	4581                	li	a1,0
ffffffffc020b1be:	59e000ef          	jal	ffffffffc020b75c <memset>
ffffffffc020b1c2:	02098d63          	beqz	s3,ffffffffc020b1fc <sfs_clear_block+0x5c>
ffffffffc020b1c6:	013409bb          	addw	s3,s0,s3
ffffffffc020b1ca:	a019                	j	ffffffffc020b1d0 <sfs_clear_block+0x30>
ffffffffc020b1cc:	03340863          	beq	s0,s3,ffffffffc020b1fc <sfs_clear_block+0x5c>
ffffffffc020b1d0:	04893583          	ld	a1,72(s2)
ffffffffc020b1d4:	4705                	li	a4,1
ffffffffc020b1d6:	8622                	mv	a2,s0
ffffffffc020b1d8:	86ba                	mv	a3,a4
ffffffffc020b1da:	854a                	mv	a0,s2
ffffffffc020b1dc:	cd1ff0ef          	jal	ffffffffc020aeac <sfs_rwblock_nolock>
ffffffffc020b1e0:	84aa                	mv	s1,a0
ffffffffc020b1e2:	2405                	addiw	s0,s0,1
ffffffffc020b1e4:	d565                	beqz	a0,ffffffffc020b1cc <sfs_clear_block+0x2c>
ffffffffc020b1e6:	854a                	mv	a0,s2
ffffffffc020b1e8:	030000ef          	jal	ffffffffc020b218 <unlock_sfs_io>
ffffffffc020b1ec:	70a2                	ld	ra,40(sp)
ffffffffc020b1ee:	7402                	ld	s0,32(sp)
ffffffffc020b1f0:	6942                	ld	s2,16(sp)
ffffffffc020b1f2:	69a2                	ld	s3,8(sp)
ffffffffc020b1f4:	8526                	mv	a0,s1
ffffffffc020b1f6:	64e2                	ld	s1,24(sp)
ffffffffc020b1f8:	6145                	addi	sp,sp,48
ffffffffc020b1fa:	8082                	ret
ffffffffc020b1fc:	4481                	li	s1,0
ffffffffc020b1fe:	b7e5                	j	ffffffffc020b1e6 <sfs_clear_block+0x46>

ffffffffc020b200 <lock_sfs_fs>:
ffffffffc020b200:	05050513          	addi	a0,a0,80
ffffffffc020b204:	bf2f906f          	j	ffffffffc02045f6 <down>

ffffffffc020b208 <lock_sfs_io>:
ffffffffc020b208:	06850513          	addi	a0,a0,104
ffffffffc020b20c:	beaf906f          	j	ffffffffc02045f6 <down>

ffffffffc020b210 <unlock_sfs_fs>:
ffffffffc020b210:	05050513          	addi	a0,a0,80
ffffffffc020b214:	bdef906f          	j	ffffffffc02045f2 <up>

ffffffffc020b218 <unlock_sfs_io>:
ffffffffc020b218:	06850513          	addi	a0,a0,104
ffffffffc020b21c:	bd6f906f          	j	ffffffffc02045f2 <up>

ffffffffc020b220 <hash32>:
ffffffffc020b220:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b224:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_bin_sfs_img_size+0xffffffff9e2fad01>
ffffffffc020b226:	02a787bb          	mulw	a5,a5,a0
ffffffffc020b22a:	02000513          	li	a0,32
ffffffffc020b22e:	9d0d                	subw	a0,a0,a1
ffffffffc020b230:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020b234:	8082                	ret

ffffffffc020b236 <printnum>:
ffffffffc020b236:	7139                	addi	sp,sp,-64
ffffffffc020b238:	02071893          	slli	a7,a4,0x20
ffffffffc020b23c:	f822                	sd	s0,48(sp)
ffffffffc020b23e:	f426                	sd	s1,40(sp)
ffffffffc020b240:	f04a                	sd	s2,32(sp)
ffffffffc020b242:	ec4e                	sd	s3,24(sp)
ffffffffc020b244:	e456                	sd	s5,8(sp)
ffffffffc020b246:	0208d893          	srli	a7,a7,0x20
ffffffffc020b24a:	fc06                	sd	ra,56(sp)
ffffffffc020b24c:	0316fab3          	remu	s5,a3,a7
ffffffffc020b250:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b254:	84aa                	mv	s1,a0
ffffffffc020b256:	89ae                	mv	s3,a1
ffffffffc020b258:	8932                	mv	s2,a2
ffffffffc020b25a:	0516f063          	bgeu	a3,a7,ffffffffc020b29a <printnum+0x64>
ffffffffc020b25e:	e852                	sd	s4,16(sp)
ffffffffc020b260:	4705                	li	a4,1
ffffffffc020b262:	8a42                	mv	s4,a6
ffffffffc020b264:	00f75863          	bge	a4,a5,ffffffffc020b274 <printnum+0x3e>
ffffffffc020b268:	864e                	mv	a2,s3
ffffffffc020b26a:	85ca                	mv	a1,s2
ffffffffc020b26c:	8552                	mv	a0,s4
ffffffffc020b26e:	347d                	addiw	s0,s0,-1
ffffffffc020b270:	9482                	jalr	s1
ffffffffc020b272:	f87d                	bnez	s0,ffffffffc020b268 <printnum+0x32>
ffffffffc020b274:	6a42                	ld	s4,16(sp)
ffffffffc020b276:	00004797          	auipc	a5,0x4
ffffffffc020b27a:	98278793          	addi	a5,a5,-1662 # ffffffffc020ebf8 <etext+0x3434>
ffffffffc020b27e:	97d6                	add	a5,a5,s5
ffffffffc020b280:	7442                	ld	s0,48(sp)
ffffffffc020b282:	0007c503          	lbu	a0,0(a5)
ffffffffc020b286:	70e2                	ld	ra,56(sp)
ffffffffc020b288:	6aa2                	ld	s5,8(sp)
ffffffffc020b28a:	864e                	mv	a2,s3
ffffffffc020b28c:	85ca                	mv	a1,s2
ffffffffc020b28e:	69e2                	ld	s3,24(sp)
ffffffffc020b290:	7902                	ld	s2,32(sp)
ffffffffc020b292:	87a6                	mv	a5,s1
ffffffffc020b294:	74a2                	ld	s1,40(sp)
ffffffffc020b296:	6121                	addi	sp,sp,64
ffffffffc020b298:	8782                	jr	a5
ffffffffc020b29a:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b29e:	87a2                	mv	a5,s0
ffffffffc020b2a0:	f97ff0ef          	jal	ffffffffc020b236 <printnum>
ffffffffc020b2a4:	bfc9                	j	ffffffffc020b276 <printnum+0x40>

ffffffffc020b2a6 <sprintputch>:
ffffffffc020b2a6:	499c                	lw	a5,16(a1)
ffffffffc020b2a8:	6198                	ld	a4,0(a1)
ffffffffc020b2aa:	6594                	ld	a3,8(a1)
ffffffffc020b2ac:	2785                	addiw	a5,a5,1
ffffffffc020b2ae:	c99c                	sw	a5,16(a1)
ffffffffc020b2b0:	00d77763          	bgeu	a4,a3,ffffffffc020b2be <sprintputch+0x18>
ffffffffc020b2b4:	00170793          	addi	a5,a4,1
ffffffffc020b2b8:	e19c                	sd	a5,0(a1)
ffffffffc020b2ba:	00a70023          	sb	a0,0(a4)
ffffffffc020b2be:	8082                	ret

ffffffffc020b2c0 <vprintfmt>:
ffffffffc020b2c0:	7119                	addi	sp,sp,-128
ffffffffc020b2c2:	f4a6                	sd	s1,104(sp)
ffffffffc020b2c4:	f0ca                	sd	s2,96(sp)
ffffffffc020b2c6:	ecce                	sd	s3,88(sp)
ffffffffc020b2c8:	e8d2                	sd	s4,80(sp)
ffffffffc020b2ca:	e4d6                	sd	s5,72(sp)
ffffffffc020b2cc:	e0da                	sd	s6,64(sp)
ffffffffc020b2ce:	fc5e                	sd	s7,56(sp)
ffffffffc020b2d0:	f466                	sd	s9,40(sp)
ffffffffc020b2d2:	fc86                	sd	ra,120(sp)
ffffffffc020b2d4:	f8a2                	sd	s0,112(sp)
ffffffffc020b2d6:	f862                	sd	s8,48(sp)
ffffffffc020b2d8:	f06a                	sd	s10,32(sp)
ffffffffc020b2da:	ec6e                	sd	s11,24(sp)
ffffffffc020b2dc:	84aa                	mv	s1,a0
ffffffffc020b2de:	8cb6                	mv	s9,a3
ffffffffc020b2e0:	8aba                	mv	s5,a4
ffffffffc020b2e2:	89ae                	mv	s3,a1
ffffffffc020b2e4:	8932                	mv	s2,a2
ffffffffc020b2e6:	02500a13          	li	s4,37
ffffffffc020b2ea:	05500b93          	li	s7,85
ffffffffc020b2ee:	00004b17          	auipc	s6,0x4
ffffffffc020b2f2:	5b2b0b13          	addi	s6,s6,1458 # ffffffffc020f8a0 <sfs_node_dirops+0x80>
ffffffffc020b2f6:	000cc503          	lbu	a0,0(s9)
ffffffffc020b2fa:	001c8413          	addi	s0,s9,1
ffffffffc020b2fe:	01450b63          	beq	a0,s4,ffffffffc020b314 <vprintfmt+0x54>
ffffffffc020b302:	cd15                	beqz	a0,ffffffffc020b33e <vprintfmt+0x7e>
ffffffffc020b304:	864e                	mv	a2,s3
ffffffffc020b306:	85ca                	mv	a1,s2
ffffffffc020b308:	9482                	jalr	s1
ffffffffc020b30a:	00044503          	lbu	a0,0(s0)
ffffffffc020b30e:	0405                	addi	s0,s0,1
ffffffffc020b310:	ff4519e3          	bne	a0,s4,ffffffffc020b302 <vprintfmt+0x42>
ffffffffc020b314:	5d7d                	li	s10,-1
ffffffffc020b316:	8dea                	mv	s11,s10
ffffffffc020b318:	02000813          	li	a6,32
ffffffffc020b31c:	4c01                	li	s8,0
ffffffffc020b31e:	4581                	li	a1,0
ffffffffc020b320:	00044703          	lbu	a4,0(s0)
ffffffffc020b324:	00140c93          	addi	s9,s0,1
ffffffffc020b328:	fdd7061b          	addiw	a2,a4,-35
ffffffffc020b32c:	0ff67613          	zext.b	a2,a2
ffffffffc020b330:	02cbe663          	bltu	s7,a2,ffffffffc020b35c <vprintfmt+0x9c>
ffffffffc020b334:	060a                	slli	a2,a2,0x2
ffffffffc020b336:	965a                	add	a2,a2,s6
ffffffffc020b338:	421c                	lw	a5,0(a2)
ffffffffc020b33a:	97da                	add	a5,a5,s6
ffffffffc020b33c:	8782                	jr	a5
ffffffffc020b33e:	70e6                	ld	ra,120(sp)
ffffffffc020b340:	7446                	ld	s0,112(sp)
ffffffffc020b342:	74a6                	ld	s1,104(sp)
ffffffffc020b344:	7906                	ld	s2,96(sp)
ffffffffc020b346:	69e6                	ld	s3,88(sp)
ffffffffc020b348:	6a46                	ld	s4,80(sp)
ffffffffc020b34a:	6aa6                	ld	s5,72(sp)
ffffffffc020b34c:	6b06                	ld	s6,64(sp)
ffffffffc020b34e:	7be2                	ld	s7,56(sp)
ffffffffc020b350:	7c42                	ld	s8,48(sp)
ffffffffc020b352:	7ca2                	ld	s9,40(sp)
ffffffffc020b354:	7d02                	ld	s10,32(sp)
ffffffffc020b356:	6de2                	ld	s11,24(sp)
ffffffffc020b358:	6109                	addi	sp,sp,128
ffffffffc020b35a:	8082                	ret
ffffffffc020b35c:	864e                	mv	a2,s3
ffffffffc020b35e:	85ca                	mv	a1,s2
ffffffffc020b360:	02500513          	li	a0,37
ffffffffc020b364:	9482                	jalr	s1
ffffffffc020b366:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b36a:	02500713          	li	a4,37
ffffffffc020b36e:	8ca2                	mv	s9,s0
ffffffffc020b370:	f8e783e3          	beq	a5,a4,ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b374:	ffecc783          	lbu	a5,-2(s9)
ffffffffc020b378:	1cfd                	addi	s9,s9,-1
ffffffffc020b37a:	fee79de3          	bne	a5,a4,ffffffffc020b374 <vprintfmt+0xb4>
ffffffffc020b37e:	bfa5                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b380:	00144683          	lbu	a3,1(s0)
ffffffffc020b384:	4525                	li	a0,9
ffffffffc020b386:	fd070d1b          	addiw	s10,a4,-48
ffffffffc020b38a:	fd06879b          	addiw	a5,a3,-48
ffffffffc020b38e:	28f56063          	bltu	a0,a5,ffffffffc020b60e <vprintfmt+0x34e>
ffffffffc020b392:	2681                	sext.w	a3,a3
ffffffffc020b394:	8466                	mv	s0,s9
ffffffffc020b396:	002d179b          	slliw	a5,s10,0x2
ffffffffc020b39a:	00144703          	lbu	a4,1(s0)
ffffffffc020b39e:	01a787bb          	addw	a5,a5,s10
ffffffffc020b3a2:	0017979b          	slliw	a5,a5,0x1
ffffffffc020b3a6:	9fb5                	addw	a5,a5,a3
ffffffffc020b3a8:	fd07061b          	addiw	a2,a4,-48
ffffffffc020b3ac:	0405                	addi	s0,s0,1
ffffffffc020b3ae:	fd078d1b          	addiw	s10,a5,-48
ffffffffc020b3b2:	0007069b          	sext.w	a3,a4
ffffffffc020b3b6:	fec570e3          	bgeu	a0,a2,ffffffffc020b396 <vprintfmt+0xd6>
ffffffffc020b3ba:	f60dd3e3          	bgez	s11,ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b3be:	8dea                	mv	s11,s10
ffffffffc020b3c0:	5d7d                	li	s10,-1
ffffffffc020b3c2:	bfb9                	j	ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b3c4:	883a                	mv	a6,a4
ffffffffc020b3c6:	8466                	mv	s0,s9
ffffffffc020b3c8:	bfa1                	j	ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b3ca:	8466                	mv	s0,s9
ffffffffc020b3cc:	4c05                	li	s8,1
ffffffffc020b3ce:	bf89                	j	ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b3d0:	4785                	li	a5,1
ffffffffc020b3d2:	008a8613          	addi	a2,s5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020b3d6:	00b7c463          	blt	a5,a1,ffffffffc020b3de <vprintfmt+0x11e>
ffffffffc020b3da:	1c058363          	beqz	a1,ffffffffc020b5a0 <vprintfmt+0x2e0>
ffffffffc020b3de:	000ab683          	ld	a3,0(s5)
ffffffffc020b3e2:	4741                	li	a4,16
ffffffffc020b3e4:	8ab2                	mv	s5,a2
ffffffffc020b3e6:	2801                	sext.w	a6,a6
ffffffffc020b3e8:	87ee                	mv	a5,s11
ffffffffc020b3ea:	864a                	mv	a2,s2
ffffffffc020b3ec:	85ce                	mv	a1,s3
ffffffffc020b3ee:	8526                	mv	a0,s1
ffffffffc020b3f0:	e47ff0ef          	jal	ffffffffc020b236 <printnum>
ffffffffc020b3f4:	b709                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b3f6:	000aa503          	lw	a0,0(s5)
ffffffffc020b3fa:	864e                	mv	a2,s3
ffffffffc020b3fc:	85ca                	mv	a1,s2
ffffffffc020b3fe:	9482                	jalr	s1
ffffffffc020b400:	0aa1                	addi	s5,s5,8
ffffffffc020b402:	bdd5                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b404:	4785                	li	a5,1
ffffffffc020b406:	008a8613          	addi	a2,s5,8
ffffffffc020b40a:	00b7c463          	blt	a5,a1,ffffffffc020b412 <vprintfmt+0x152>
ffffffffc020b40e:	18058463          	beqz	a1,ffffffffc020b596 <vprintfmt+0x2d6>
ffffffffc020b412:	000ab683          	ld	a3,0(s5)
ffffffffc020b416:	4729                	li	a4,10
ffffffffc020b418:	8ab2                	mv	s5,a2
ffffffffc020b41a:	b7f1                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b41c:	864e                	mv	a2,s3
ffffffffc020b41e:	85ca                	mv	a1,s2
ffffffffc020b420:	03000513          	li	a0,48
ffffffffc020b424:	e042                	sd	a6,0(sp)
ffffffffc020b426:	9482                	jalr	s1
ffffffffc020b428:	864e                	mv	a2,s3
ffffffffc020b42a:	85ca                	mv	a1,s2
ffffffffc020b42c:	07800513          	li	a0,120
ffffffffc020b430:	9482                	jalr	s1
ffffffffc020b432:	000ab683          	ld	a3,0(s5)
ffffffffc020b436:	6802                	ld	a6,0(sp)
ffffffffc020b438:	4741                	li	a4,16
ffffffffc020b43a:	0aa1                	addi	s5,s5,8
ffffffffc020b43c:	b76d                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b43e:	864e                	mv	a2,s3
ffffffffc020b440:	85ca                	mv	a1,s2
ffffffffc020b442:	02500513          	li	a0,37
ffffffffc020b446:	9482                	jalr	s1
ffffffffc020b448:	b57d                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b44a:	000aad03          	lw	s10,0(s5)
ffffffffc020b44e:	8466                	mv	s0,s9
ffffffffc020b450:	0aa1                	addi	s5,s5,8
ffffffffc020b452:	b7a5                	j	ffffffffc020b3ba <vprintfmt+0xfa>
ffffffffc020b454:	4785                	li	a5,1
ffffffffc020b456:	008a8613          	addi	a2,s5,8
ffffffffc020b45a:	00b7c463          	blt	a5,a1,ffffffffc020b462 <vprintfmt+0x1a2>
ffffffffc020b45e:	12058763          	beqz	a1,ffffffffc020b58c <vprintfmt+0x2cc>
ffffffffc020b462:	000ab683          	ld	a3,0(s5)
ffffffffc020b466:	4721                	li	a4,8
ffffffffc020b468:	8ab2                	mv	s5,a2
ffffffffc020b46a:	bfb5                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b46c:	87ee                	mv	a5,s11
ffffffffc020b46e:	000dd363          	bgez	s11,ffffffffc020b474 <vprintfmt+0x1b4>
ffffffffc020b472:	4781                	li	a5,0
ffffffffc020b474:	00078d9b          	sext.w	s11,a5
ffffffffc020b478:	8466                	mv	s0,s9
ffffffffc020b47a:	b55d                	j	ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b47c:	0008041b          	sext.w	s0,a6
ffffffffc020b480:	fd340793          	addi	a5,s0,-45
ffffffffc020b484:	01b02733          	sgtz	a4,s11
ffffffffc020b488:	00f037b3          	snez	a5,a5
ffffffffc020b48c:	8ff9                	and	a5,a5,a4
ffffffffc020b48e:	000ab703          	ld	a4,0(s5)
ffffffffc020b492:	008a8693          	addi	a3,s5,8
ffffffffc020b496:	e436                	sd	a3,8(sp)
ffffffffc020b498:	12070563          	beqz	a4,ffffffffc020b5c2 <vprintfmt+0x302>
ffffffffc020b49c:	12079d63          	bnez	a5,ffffffffc020b5d6 <vprintfmt+0x316>
ffffffffc020b4a0:	00074783          	lbu	a5,0(a4)
ffffffffc020b4a4:	0007851b          	sext.w	a0,a5
ffffffffc020b4a8:	c78d                	beqz	a5,ffffffffc020b4d2 <vprintfmt+0x212>
ffffffffc020b4aa:	00170a93          	addi	s5,a4,1
ffffffffc020b4ae:	547d                	li	s0,-1
ffffffffc020b4b0:	000d4563          	bltz	s10,ffffffffc020b4ba <vprintfmt+0x1fa>
ffffffffc020b4b4:	3d7d                	addiw	s10,s10,-1
ffffffffc020b4b6:	008d0e63          	beq	s10,s0,ffffffffc020b4d2 <vprintfmt+0x212>
ffffffffc020b4ba:	020c1863          	bnez	s8,ffffffffc020b4ea <vprintfmt+0x22a>
ffffffffc020b4be:	864e                	mv	a2,s3
ffffffffc020b4c0:	85ca                	mv	a1,s2
ffffffffc020b4c2:	9482                	jalr	s1
ffffffffc020b4c4:	000ac783          	lbu	a5,0(s5)
ffffffffc020b4c8:	0a85                	addi	s5,s5,1
ffffffffc020b4ca:	3dfd                	addiw	s11,s11,-1
ffffffffc020b4cc:	0007851b          	sext.w	a0,a5
ffffffffc020b4d0:	f3e5                	bnez	a5,ffffffffc020b4b0 <vprintfmt+0x1f0>
ffffffffc020b4d2:	01b05a63          	blez	s11,ffffffffc020b4e6 <vprintfmt+0x226>
ffffffffc020b4d6:	864e                	mv	a2,s3
ffffffffc020b4d8:	85ca                	mv	a1,s2
ffffffffc020b4da:	02000513          	li	a0,32
ffffffffc020b4de:	3dfd                	addiw	s11,s11,-1
ffffffffc020b4e0:	9482                	jalr	s1
ffffffffc020b4e2:	fe0d9ae3          	bnez	s11,ffffffffc020b4d6 <vprintfmt+0x216>
ffffffffc020b4e6:	6aa2                	ld	s5,8(sp)
ffffffffc020b4e8:	b539                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b4ea:	3781                	addiw	a5,a5,-32
ffffffffc020b4ec:	05e00713          	li	a4,94
ffffffffc020b4f0:	fcf777e3          	bgeu	a4,a5,ffffffffc020b4be <vprintfmt+0x1fe>
ffffffffc020b4f4:	03f00513          	li	a0,63
ffffffffc020b4f8:	864e                	mv	a2,s3
ffffffffc020b4fa:	85ca                	mv	a1,s2
ffffffffc020b4fc:	9482                	jalr	s1
ffffffffc020b4fe:	000ac783          	lbu	a5,0(s5)
ffffffffc020b502:	0a85                	addi	s5,s5,1
ffffffffc020b504:	3dfd                	addiw	s11,s11,-1
ffffffffc020b506:	0007851b          	sext.w	a0,a5
ffffffffc020b50a:	d7e1                	beqz	a5,ffffffffc020b4d2 <vprintfmt+0x212>
ffffffffc020b50c:	fa0d54e3          	bgez	s10,ffffffffc020b4b4 <vprintfmt+0x1f4>
ffffffffc020b510:	bfe9                	j	ffffffffc020b4ea <vprintfmt+0x22a>
ffffffffc020b512:	000aa783          	lw	a5,0(s5)
ffffffffc020b516:	46e1                	li	a3,24
ffffffffc020b518:	0aa1                	addi	s5,s5,8
ffffffffc020b51a:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b51e:	8fb9                	xor	a5,a5,a4
ffffffffc020b520:	40e7873b          	subw	a4,a5,a4
ffffffffc020b524:	02e6c663          	blt	a3,a4,ffffffffc020b550 <vprintfmt+0x290>
ffffffffc020b528:	00004797          	auipc	a5,0x4
ffffffffc020b52c:	4d078793          	addi	a5,a5,1232 # ffffffffc020f9f8 <error_string>
ffffffffc020b530:	00371693          	slli	a3,a4,0x3
ffffffffc020b534:	97b6                	add	a5,a5,a3
ffffffffc020b536:	639c                	ld	a5,0(a5)
ffffffffc020b538:	cf81                	beqz	a5,ffffffffc020b550 <vprintfmt+0x290>
ffffffffc020b53a:	873e                	mv	a4,a5
ffffffffc020b53c:	00000697          	auipc	a3,0x0
ffffffffc020b540:	2b468693          	addi	a3,a3,692 # ffffffffc020b7f0 <etext+0x2c>
ffffffffc020b544:	864a                	mv	a2,s2
ffffffffc020b546:	85ce                	mv	a1,s3
ffffffffc020b548:	8526                	mv	a0,s1
ffffffffc020b54a:	0f2000ef          	jal	ffffffffc020b63c <printfmt>
ffffffffc020b54e:	b365                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b550:	00003697          	auipc	a3,0x3
ffffffffc020b554:	6c868693          	addi	a3,a3,1736 # ffffffffc020ec18 <etext+0x3454>
ffffffffc020b558:	864a                	mv	a2,s2
ffffffffc020b55a:	85ce                	mv	a1,s3
ffffffffc020b55c:	8526                	mv	a0,s1
ffffffffc020b55e:	0de000ef          	jal	ffffffffc020b63c <printfmt>
ffffffffc020b562:	bb51                	j	ffffffffc020b2f6 <vprintfmt+0x36>
ffffffffc020b564:	4785                	li	a5,1
ffffffffc020b566:	008a8c13          	addi	s8,s5,8
ffffffffc020b56a:	00b7c363          	blt	a5,a1,ffffffffc020b570 <vprintfmt+0x2b0>
ffffffffc020b56e:	cd81                	beqz	a1,ffffffffc020b586 <vprintfmt+0x2c6>
ffffffffc020b570:	000ab403          	ld	s0,0(s5)
ffffffffc020b574:	02044b63          	bltz	s0,ffffffffc020b5aa <vprintfmt+0x2ea>
ffffffffc020b578:	86a2                	mv	a3,s0
ffffffffc020b57a:	8ae2                	mv	s5,s8
ffffffffc020b57c:	4729                	li	a4,10
ffffffffc020b57e:	b5a5                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b580:	2585                	addiw	a1,a1,1
ffffffffc020b582:	8466                	mv	s0,s9
ffffffffc020b584:	bb71                	j	ffffffffc020b320 <vprintfmt+0x60>
ffffffffc020b586:	000aa403          	lw	s0,0(s5)
ffffffffc020b58a:	b7ed                	j	ffffffffc020b574 <vprintfmt+0x2b4>
ffffffffc020b58c:	000ae683          	lwu	a3,0(s5)
ffffffffc020b590:	4721                	li	a4,8
ffffffffc020b592:	8ab2                	mv	s5,a2
ffffffffc020b594:	bd89                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b596:	000ae683          	lwu	a3,0(s5)
ffffffffc020b59a:	4729                	li	a4,10
ffffffffc020b59c:	8ab2                	mv	s5,a2
ffffffffc020b59e:	b5a1                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b5a0:	000ae683          	lwu	a3,0(s5)
ffffffffc020b5a4:	4741                	li	a4,16
ffffffffc020b5a6:	8ab2                	mv	s5,a2
ffffffffc020b5a8:	bd3d                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b5aa:	864e                	mv	a2,s3
ffffffffc020b5ac:	85ca                	mv	a1,s2
ffffffffc020b5ae:	02d00513          	li	a0,45
ffffffffc020b5b2:	e042                	sd	a6,0(sp)
ffffffffc020b5b4:	9482                	jalr	s1
ffffffffc020b5b6:	6802                	ld	a6,0(sp)
ffffffffc020b5b8:	408006b3          	neg	a3,s0
ffffffffc020b5bc:	8ae2                	mv	s5,s8
ffffffffc020b5be:	4729                	li	a4,10
ffffffffc020b5c0:	b51d                	j	ffffffffc020b3e6 <vprintfmt+0x126>
ffffffffc020b5c2:	eba1                	bnez	a5,ffffffffc020b612 <vprintfmt+0x352>
ffffffffc020b5c4:	02800793          	li	a5,40
ffffffffc020b5c8:	853e                	mv	a0,a5
ffffffffc020b5ca:	00003a97          	auipc	s5,0x3
ffffffffc020b5ce:	647a8a93          	addi	s5,s5,1607 # ffffffffc020ec11 <etext+0x344d>
ffffffffc020b5d2:	547d                	li	s0,-1
ffffffffc020b5d4:	bdf1                	j	ffffffffc020b4b0 <vprintfmt+0x1f0>
ffffffffc020b5d6:	853a                	mv	a0,a4
ffffffffc020b5d8:	85ea                	mv	a1,s10
ffffffffc020b5da:	e03a                	sd	a4,0(sp)
ffffffffc020b5dc:	0e4000ef          	jal	ffffffffc020b6c0 <strnlen>
ffffffffc020b5e0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b5e4:	6702                	ld	a4,0(sp)
ffffffffc020b5e6:	01b05b63          	blez	s11,ffffffffc020b5fc <vprintfmt+0x33c>
ffffffffc020b5ea:	864e                	mv	a2,s3
ffffffffc020b5ec:	85ca                	mv	a1,s2
ffffffffc020b5ee:	8522                	mv	a0,s0
ffffffffc020b5f0:	e03a                	sd	a4,0(sp)
ffffffffc020b5f2:	3dfd                	addiw	s11,s11,-1
ffffffffc020b5f4:	9482                	jalr	s1
ffffffffc020b5f6:	6702                	ld	a4,0(sp)
ffffffffc020b5f8:	fe0d99e3          	bnez	s11,ffffffffc020b5ea <vprintfmt+0x32a>
ffffffffc020b5fc:	00074783          	lbu	a5,0(a4)
ffffffffc020b600:	0007851b          	sext.w	a0,a5
ffffffffc020b604:	ee0781e3          	beqz	a5,ffffffffc020b4e6 <vprintfmt+0x226>
ffffffffc020b608:	00170a93          	addi	s5,a4,1
ffffffffc020b60c:	b54d                	j	ffffffffc020b4ae <vprintfmt+0x1ee>
ffffffffc020b60e:	8466                	mv	s0,s9
ffffffffc020b610:	b36d                	j	ffffffffc020b3ba <vprintfmt+0xfa>
ffffffffc020b612:	85ea                	mv	a1,s10
ffffffffc020b614:	00003517          	auipc	a0,0x3
ffffffffc020b618:	5fc50513          	addi	a0,a0,1532 # ffffffffc020ec10 <etext+0x344c>
ffffffffc020b61c:	0a4000ef          	jal	ffffffffc020b6c0 <strnlen>
ffffffffc020b620:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020b624:	02800793          	li	a5,40
ffffffffc020b628:	00003717          	auipc	a4,0x3
ffffffffc020b62c:	5e870713          	addi	a4,a4,1512 # ffffffffc020ec10 <etext+0x344c>
ffffffffc020b630:	853e                	mv	a0,a5
ffffffffc020b632:	fbb04ce3          	bgtz	s11,ffffffffc020b5ea <vprintfmt+0x32a>
ffffffffc020b636:	00170a93          	addi	s5,a4,1
ffffffffc020b63a:	bd95                	j	ffffffffc020b4ae <vprintfmt+0x1ee>

ffffffffc020b63c <printfmt>:
ffffffffc020b63c:	7139                	addi	sp,sp,-64
ffffffffc020b63e:	02010313          	addi	t1,sp,32
ffffffffc020b642:	f03a                	sd	a4,32(sp)
ffffffffc020b644:	871a                	mv	a4,t1
ffffffffc020b646:	ec06                	sd	ra,24(sp)
ffffffffc020b648:	f43e                	sd	a5,40(sp)
ffffffffc020b64a:	f842                	sd	a6,48(sp)
ffffffffc020b64c:	fc46                	sd	a7,56(sp)
ffffffffc020b64e:	e41a                	sd	t1,8(sp)
ffffffffc020b650:	c71ff0ef          	jal	ffffffffc020b2c0 <vprintfmt>
ffffffffc020b654:	60e2                	ld	ra,24(sp)
ffffffffc020b656:	6121                	addi	sp,sp,64
ffffffffc020b658:	8082                	ret

ffffffffc020b65a <snprintf>:
ffffffffc020b65a:	711d                	addi	sp,sp,-96
ffffffffc020b65c:	15fd                	addi	a1,a1,-1
ffffffffc020b65e:	95aa                	add	a1,a1,a0
ffffffffc020b660:	03810313          	addi	t1,sp,56
ffffffffc020b664:	f406                	sd	ra,40(sp)
ffffffffc020b666:	e82e                	sd	a1,16(sp)
ffffffffc020b668:	e42a                	sd	a0,8(sp)
ffffffffc020b66a:	fc36                	sd	a3,56(sp)
ffffffffc020b66c:	e0ba                	sd	a4,64(sp)
ffffffffc020b66e:	e4be                	sd	a5,72(sp)
ffffffffc020b670:	e8c2                	sd	a6,80(sp)
ffffffffc020b672:	ecc6                	sd	a7,88(sp)
ffffffffc020b674:	cc02                	sw	zero,24(sp)
ffffffffc020b676:	e01a                	sd	t1,0(sp)
ffffffffc020b678:	c515                	beqz	a0,ffffffffc020b6a4 <snprintf+0x4a>
ffffffffc020b67a:	02a5e563          	bltu	a1,a0,ffffffffc020b6a4 <snprintf+0x4a>
ffffffffc020b67e:	75dd                	lui	a1,0xffff7
ffffffffc020b680:	86b2                	mv	a3,a2
ffffffffc020b682:	00000517          	auipc	a0,0x0
ffffffffc020b686:	c2450513          	addi	a0,a0,-988 # ffffffffc020b2a6 <sprintputch>
ffffffffc020b68a:	871a                	mv	a4,t1
ffffffffc020b68c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b690:	0030                	addi	a2,sp,8
ffffffffc020b692:	c2fff0ef          	jal	ffffffffc020b2c0 <vprintfmt>
ffffffffc020b696:	67a2                	ld	a5,8(sp)
ffffffffc020b698:	00078023          	sb	zero,0(a5)
ffffffffc020b69c:	4562                	lw	a0,24(sp)
ffffffffc020b69e:	70a2                	ld	ra,40(sp)
ffffffffc020b6a0:	6125                	addi	sp,sp,96
ffffffffc020b6a2:	8082                	ret
ffffffffc020b6a4:	5575                	li	a0,-3
ffffffffc020b6a6:	bfe5                	j	ffffffffc020b69e <snprintf+0x44>

ffffffffc020b6a8 <strlen>:
ffffffffc020b6a8:	00054783          	lbu	a5,0(a0)
ffffffffc020b6ac:	cb81                	beqz	a5,ffffffffc020b6bc <strlen+0x14>
ffffffffc020b6ae:	4781                	li	a5,0
ffffffffc020b6b0:	0785                	addi	a5,a5,1
ffffffffc020b6b2:	00f50733          	add	a4,a0,a5
ffffffffc020b6b6:	00074703          	lbu	a4,0(a4)
ffffffffc020b6ba:	fb7d                	bnez	a4,ffffffffc020b6b0 <strlen+0x8>
ffffffffc020b6bc:	853e                	mv	a0,a5
ffffffffc020b6be:	8082                	ret

ffffffffc020b6c0 <strnlen>:
ffffffffc020b6c0:	4781                	li	a5,0
ffffffffc020b6c2:	e589                	bnez	a1,ffffffffc020b6cc <strnlen+0xc>
ffffffffc020b6c4:	a811                	j	ffffffffc020b6d8 <strnlen+0x18>
ffffffffc020b6c6:	0785                	addi	a5,a5,1
ffffffffc020b6c8:	00f58863          	beq	a1,a5,ffffffffc020b6d8 <strnlen+0x18>
ffffffffc020b6cc:	00f50733          	add	a4,a0,a5
ffffffffc020b6d0:	00074703          	lbu	a4,0(a4)
ffffffffc020b6d4:	fb6d                	bnez	a4,ffffffffc020b6c6 <strnlen+0x6>
ffffffffc020b6d6:	85be                	mv	a1,a5
ffffffffc020b6d8:	852e                	mv	a0,a1
ffffffffc020b6da:	8082                	ret

ffffffffc020b6dc <strcpy>:
ffffffffc020b6dc:	87aa                	mv	a5,a0
ffffffffc020b6de:	0005c703          	lbu	a4,0(a1)
ffffffffc020b6e2:	0585                	addi	a1,a1,1
ffffffffc020b6e4:	0785                	addi	a5,a5,1
ffffffffc020b6e6:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b6ea:	fb75                	bnez	a4,ffffffffc020b6de <strcpy+0x2>
ffffffffc020b6ec:	8082                	ret

ffffffffc020b6ee <strcmp>:
ffffffffc020b6ee:	00054783          	lbu	a5,0(a0)
ffffffffc020b6f2:	e791                	bnez	a5,ffffffffc020b6fe <strcmp+0x10>
ffffffffc020b6f4:	a01d                	j	ffffffffc020b71a <strcmp+0x2c>
ffffffffc020b6f6:	00054783          	lbu	a5,0(a0)
ffffffffc020b6fa:	cb99                	beqz	a5,ffffffffc020b710 <strcmp+0x22>
ffffffffc020b6fc:	0585                	addi	a1,a1,1
ffffffffc020b6fe:	0005c703          	lbu	a4,0(a1)
ffffffffc020b702:	0505                	addi	a0,a0,1
ffffffffc020b704:	fef709e3          	beq	a4,a5,ffffffffc020b6f6 <strcmp+0x8>
ffffffffc020b708:	0007851b          	sext.w	a0,a5
ffffffffc020b70c:	9d19                	subw	a0,a0,a4
ffffffffc020b70e:	8082                	ret
ffffffffc020b710:	0015c703          	lbu	a4,1(a1)
ffffffffc020b714:	4501                	li	a0,0
ffffffffc020b716:	9d19                	subw	a0,a0,a4
ffffffffc020b718:	8082                	ret
ffffffffc020b71a:	0005c703          	lbu	a4,0(a1)
ffffffffc020b71e:	4501                	li	a0,0
ffffffffc020b720:	b7f5                	j	ffffffffc020b70c <strcmp+0x1e>

ffffffffc020b722 <strncmp>:
ffffffffc020b722:	ce01                	beqz	a2,ffffffffc020b73a <strncmp+0x18>
ffffffffc020b724:	00054783          	lbu	a5,0(a0)
ffffffffc020b728:	167d                	addi	a2,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020b72a:	cb91                	beqz	a5,ffffffffc020b73e <strncmp+0x1c>
ffffffffc020b72c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b730:	00f71763          	bne	a4,a5,ffffffffc020b73e <strncmp+0x1c>
ffffffffc020b734:	0505                	addi	a0,a0,1
ffffffffc020b736:	0585                	addi	a1,a1,1
ffffffffc020b738:	f675                	bnez	a2,ffffffffc020b724 <strncmp+0x2>
ffffffffc020b73a:	4501                	li	a0,0
ffffffffc020b73c:	8082                	ret
ffffffffc020b73e:	00054503          	lbu	a0,0(a0)
ffffffffc020b742:	0005c783          	lbu	a5,0(a1)
ffffffffc020b746:	9d1d                	subw	a0,a0,a5
ffffffffc020b748:	8082                	ret

ffffffffc020b74a <strchr>:
ffffffffc020b74a:	a021                	j	ffffffffc020b752 <strchr+0x8>
ffffffffc020b74c:	00f58763          	beq	a1,a5,ffffffffc020b75a <strchr+0x10>
ffffffffc020b750:	0505                	addi	a0,a0,1
ffffffffc020b752:	00054783          	lbu	a5,0(a0)
ffffffffc020b756:	fbfd                	bnez	a5,ffffffffc020b74c <strchr+0x2>
ffffffffc020b758:	4501                	li	a0,0
ffffffffc020b75a:	8082                	ret

ffffffffc020b75c <memset>:
ffffffffc020b75c:	ca01                	beqz	a2,ffffffffc020b76c <memset+0x10>
ffffffffc020b75e:	962a                	add	a2,a2,a0
ffffffffc020b760:	87aa                	mv	a5,a0
ffffffffc020b762:	0785                	addi	a5,a5,1
ffffffffc020b764:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b768:	fef61de3          	bne	a2,a5,ffffffffc020b762 <memset+0x6>
ffffffffc020b76c:	8082                	ret

ffffffffc020b76e <memmove>:
ffffffffc020b76e:	02a5f163          	bgeu	a1,a0,ffffffffc020b790 <memmove+0x22>
ffffffffc020b772:	00c587b3          	add	a5,a1,a2
ffffffffc020b776:	00f57d63          	bgeu	a0,a5,ffffffffc020b790 <memmove+0x22>
ffffffffc020b77a:	c61d                	beqz	a2,ffffffffc020b7a8 <memmove+0x3a>
ffffffffc020b77c:	962a                	add	a2,a2,a0
ffffffffc020b77e:	fff7c703          	lbu	a4,-1(a5)
ffffffffc020b782:	17fd                	addi	a5,a5,-1
ffffffffc020b784:	167d                	addi	a2,a2,-1
ffffffffc020b786:	00e60023          	sb	a4,0(a2)
ffffffffc020b78a:	fef59ae3          	bne	a1,a5,ffffffffc020b77e <memmove+0x10>
ffffffffc020b78e:	8082                	ret
ffffffffc020b790:	00c586b3          	add	a3,a1,a2
ffffffffc020b794:	87aa                	mv	a5,a0
ffffffffc020b796:	ca11                	beqz	a2,ffffffffc020b7aa <memmove+0x3c>
ffffffffc020b798:	0005c703          	lbu	a4,0(a1)
ffffffffc020b79c:	0585                	addi	a1,a1,1
ffffffffc020b79e:	0785                	addi	a5,a5,1
ffffffffc020b7a0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b7a4:	feb69ae3          	bne	a3,a1,ffffffffc020b798 <memmove+0x2a>
ffffffffc020b7a8:	8082                	ret
ffffffffc020b7aa:	8082                	ret

ffffffffc020b7ac <memcpy>:
ffffffffc020b7ac:	ca19                	beqz	a2,ffffffffc020b7c2 <memcpy+0x16>
ffffffffc020b7ae:	962e                	add	a2,a2,a1
ffffffffc020b7b0:	87aa                	mv	a5,a0
ffffffffc020b7b2:	0005c703          	lbu	a4,0(a1)
ffffffffc020b7b6:	0585                	addi	a1,a1,1
ffffffffc020b7b8:	0785                	addi	a5,a5,1
ffffffffc020b7ba:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b7be:	feb61ae3          	bne	a2,a1,ffffffffc020b7b2 <memcpy+0x6>
ffffffffc020b7c2:	8082                	ret
