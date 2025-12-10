
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0208137          	lui	sp,0xc0208
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49e60613          	addi	a2,a2,1182 # ffffffffc020d4f0 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0207ff0 <bootstack+0x1ff0>
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	5db030ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0200066:	4c2000ef          	jal	ffffffffc0200528 <dtb_init>
ffffffffc020006a:	44c000ef          	jal	ffffffffc02004b6 <cons_init>
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e2258593          	addi	a1,a1,-478 # ffffffffc0203e90 <etext+0x6>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e3a50513          	addi	a0,a0,-454 # ffffffffc0203eb0 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200082:	158000ef          	jal	ffffffffc02001da <print_kerninfo>
ffffffffc0200086:	0e0020ef          	jal	ffffffffc0202166 <pmm_init>
ffffffffc020008a:	7f0000ef          	jal	ffffffffc020087a <pic_init>
ffffffffc020008e:	7ee000ef          	jal	ffffffffc020087c <idt_init>
ffffffffc0200092:	651020ef          	jal	ffffffffc0202ee2 <vmm_init>
ffffffffc0200096:	56e030ef          	jal	ffffffffc0203604 <proc_init>
ffffffffc020009a:	3ca000ef          	jal	ffffffffc0200464 <clock_init>
ffffffffc020009e:	7d0000ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02000a2:	7ba030ef          	jal	ffffffffc020385c <cpu_idle>

ffffffffc02000a6 <readline>:
ffffffffc02000a6:	7179                	addi	sp,sp,-48
ffffffffc02000a8:	f406                	sd	ra,40(sp)
ffffffffc02000aa:	f022                	sd	s0,32(sp)
ffffffffc02000ac:	ec26                	sd	s1,24(sp)
ffffffffc02000ae:	e84a                	sd	s2,16(sp)
ffffffffc02000b0:	e44e                	sd	s3,8(sp)
ffffffffc02000b2:	c901                	beqz	a0,ffffffffc02000c2 <readline+0x1c>
ffffffffc02000b4:	85aa                	mv	a1,a0
ffffffffc02000b6:	00004517          	auipc	a0,0x4
ffffffffc02000ba:	e0250513          	addi	a0,a0,-510 # ffffffffc0203eb8 <etext+0x2e>
ffffffffc02000be:	0d6000ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02000c2:	4481                	li	s1,0
ffffffffc02000c4:	497d                	li	s2,31
ffffffffc02000c6:	00009997          	auipc	s3,0x9
ffffffffc02000ca:	f6a98993          	addi	s3,s3,-150 # ffffffffc0209030 <buf>
ffffffffc02000ce:	0fc000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc02000d2:	842a                	mv	s0,a0
ffffffffc02000d4:	ff850793          	addi	a5,a0,-8
ffffffffc02000d8:	3ff4a713          	slti	a4,s1,1023
ffffffffc02000dc:	ff650693          	addi	a3,a0,-10
ffffffffc02000e0:	ff350613          	addi	a2,a0,-13
ffffffffc02000e4:	02054963          	bltz	a0,ffffffffc0200116 <readline+0x70>
ffffffffc02000e8:	02a95f63          	bge	s2,a0,ffffffffc0200126 <readline+0x80>
ffffffffc02000ec:	cf0d                	beqz	a4,ffffffffc0200126 <readline+0x80>
ffffffffc02000ee:	0da000ef          	jal	ffffffffc02001c8 <cputchar>
ffffffffc02000f2:	009987b3          	add	a5,s3,s1
ffffffffc02000f6:	00878023          	sb	s0,0(a5)
ffffffffc02000fa:	2485                	addiw	s1,s1,1
ffffffffc02000fc:	0ce000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc0200100:	842a                	mv	s0,a0
ffffffffc0200102:	ff850793          	addi	a5,a0,-8
ffffffffc0200106:	3ff4a713          	slti	a4,s1,1023
ffffffffc020010a:	ff650693          	addi	a3,a0,-10
ffffffffc020010e:	ff350613          	addi	a2,a0,-13
ffffffffc0200112:	fc055be3          	bgez	a0,ffffffffc02000e8 <readline+0x42>
ffffffffc0200116:	70a2                	ld	ra,40(sp)
ffffffffc0200118:	7402                	ld	s0,32(sp)
ffffffffc020011a:	64e2                	ld	s1,24(sp)
ffffffffc020011c:	6942                	ld	s2,16(sp)
ffffffffc020011e:	69a2                	ld	s3,8(sp)
ffffffffc0200120:	4501                	li	a0,0
ffffffffc0200122:	6145                	addi	sp,sp,48
ffffffffc0200124:	8082                	ret
ffffffffc0200126:	eb81                	bnez	a5,ffffffffc0200136 <readline+0x90>
ffffffffc0200128:	4521                	li	a0,8
ffffffffc020012a:	00905663          	blez	s1,ffffffffc0200136 <readline+0x90>
ffffffffc020012e:	09a000ef          	jal	ffffffffc02001c8 <cputchar>
ffffffffc0200132:	34fd                	addiw	s1,s1,-1
ffffffffc0200134:	bf69                	j	ffffffffc02000ce <readline+0x28>
ffffffffc0200136:	c291                	beqz	a3,ffffffffc020013a <readline+0x94>
ffffffffc0200138:	fa59                	bnez	a2,ffffffffc02000ce <readline+0x28>
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	08c000ef          	jal	ffffffffc02001c8 <cputchar>
ffffffffc0200140:	00009517          	auipc	a0,0x9
ffffffffc0200144:	ef050513          	addi	a0,a0,-272 # ffffffffc0209030 <buf>
ffffffffc0200148:	94aa                	add	s1,s1,a0
ffffffffc020014a:	00048023          	sb	zero,0(s1)
ffffffffc020014e:	70a2                	ld	ra,40(sp)
ffffffffc0200150:	7402                	ld	s0,32(sp)
ffffffffc0200152:	64e2                	ld	s1,24(sp)
ffffffffc0200154:	6942                	ld	s2,16(sp)
ffffffffc0200156:	69a2                	ld	s3,8(sp)
ffffffffc0200158:	6145                	addi	sp,sp,48
ffffffffc020015a:	8082                	ret

ffffffffc020015c <cputch>:
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	ec06                	sd	ra,24(sp)
ffffffffc0200160:	e42e                	sd	a1,8(sp)
ffffffffc0200162:	356000ef          	jal	ffffffffc02004b8 <cons_putc>
ffffffffc0200166:	65a2                	ld	a1,8(sp)
ffffffffc0200168:	60e2                	ld	ra,24(sp)
ffffffffc020016a:	419c                	lw	a5,0(a1)
ffffffffc020016c:	2785                	addiw	a5,a5,1
ffffffffc020016e:	c19c                	sw	a5,0(a1)
ffffffffc0200170:	6105                	addi	sp,sp,32
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe250513          	addi	a0,a0,-30 # ffffffffc020015c <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
ffffffffc0200184:	ec06                	sd	ra,24(sp)
ffffffffc0200186:	c602                	sw	zero,12(sp)
ffffffffc0200188:	09b030ef          	jal	ffffffffc0203a22 <vprintfmt>
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
ffffffffc0200194:	711d                	addi	sp,sp,-96
ffffffffc0200196:	02810313          	addi	t1,sp,40
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb850513          	addi	a0,a0,-72 # ffffffffc020015c <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
ffffffffc02001b8:	c202                	sw	zero,4(sp)
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
ffffffffc02001bc:	067030ef          	jal	ffffffffc0203a22 <vprintfmt>
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:
ffffffffc02001c8:	acc5                	j	ffffffffc02004b8 <cons_putc>

ffffffffc02001ca <getchar>:
ffffffffc02001ca:	1141                	addi	sp,sp,-16
ffffffffc02001cc:	e406                	sd	ra,8(sp)
ffffffffc02001ce:	31e000ef          	jal	ffffffffc02004ec <cons_getc>
ffffffffc02001d2:	dd75                	beqz	a0,ffffffffc02001ce <getchar+0x4>
ffffffffc02001d4:	60a2                	ld	ra,8(sp)
ffffffffc02001d6:	0141                	addi	sp,sp,16
ffffffffc02001d8:	8082                	ret

ffffffffc02001da <print_kerninfo>:
ffffffffc02001da:	1141                	addi	sp,sp,-16
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	ce450513          	addi	a0,a0,-796 # ffffffffc0203ec0 <etext+0x36>
ffffffffc02001e4:	e406                	sd	ra,8(sp)
ffffffffc02001e6:	fafff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02001ea:	00000597          	auipc	a1,0x0
ffffffffc02001ee:	e6058593          	addi	a1,a1,-416 # ffffffffc020004a <kern_init>
ffffffffc02001f2:	00004517          	auipc	a0,0x4
ffffffffc02001f6:	cee50513          	addi	a0,a0,-786 # ffffffffc0203ee0 <etext+0x56>
ffffffffc02001fa:	f9bff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02001fe:	00004597          	auipc	a1,0x4
ffffffffc0200202:	c8c58593          	addi	a1,a1,-884 # ffffffffc0203e8a <etext>
ffffffffc0200206:	00004517          	auipc	a0,0x4
ffffffffc020020a:	cfa50513          	addi	a0,a0,-774 # ffffffffc0203f00 <etext+0x76>
ffffffffc020020e:	f87ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200212:	00009597          	auipc	a1,0x9
ffffffffc0200216:	e1e58593          	addi	a1,a1,-482 # ffffffffc0209030 <buf>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	d0650513          	addi	a0,a0,-762 # ffffffffc0203f20 <etext+0x96>
ffffffffc0200222:	f73ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200226:	0000d597          	auipc	a1,0xd
ffffffffc020022a:	2ca58593          	addi	a1,a1,714 # ffffffffc020d4f0 <end>
ffffffffc020022e:	00004517          	auipc	a0,0x4
ffffffffc0200232:	d1250513          	addi	a0,a0,-750 # ffffffffc0203f40 <etext+0xb6>
ffffffffc0200236:	f5fff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020023a:	00000717          	auipc	a4,0x0
ffffffffc020023e:	e1070713          	addi	a4,a4,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000d797          	auipc	a5,0xd
ffffffffc0200246:	6ad78793          	addi	a5,a5,1709 # ffffffffc020d8ef <end+0x3ff>
ffffffffc020024a:	8f99                	sub	a5,a5,a4
ffffffffc020024c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200250:	60a2                	ld	ra,8(sp)
ffffffffc0200252:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200256:	95be                	add	a1,a1,a5
ffffffffc0200258:	85a9                	srai	a1,a1,0xa
ffffffffc020025a:	00004517          	auipc	a0,0x4
ffffffffc020025e:	d0650513          	addi	a0,a0,-762 # ffffffffc0203f60 <etext+0xd6>
ffffffffc0200262:	0141                	addi	sp,sp,16
ffffffffc0200264:	bf05                	j	ffffffffc0200194 <cprintf>

ffffffffc0200266 <print_stackframe>:
ffffffffc0200266:	1141                	addi	sp,sp,-16
ffffffffc0200268:	00004617          	auipc	a2,0x4
ffffffffc020026c:	d2860613          	addi	a2,a2,-728 # ffffffffc0203f90 <etext+0x106>
ffffffffc0200270:	04900593          	li	a1,73
ffffffffc0200274:	00004517          	auipc	a0,0x4
ffffffffc0200278:	d3450513          	addi	a0,a0,-716 # ffffffffc0203fa8 <etext+0x11e>
ffffffffc020027c:	e406                	sd	ra,8(sp)
ffffffffc020027e:	188000ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0200282 <mon_help>:
ffffffffc0200282:	1101                	addi	sp,sp,-32
ffffffffc0200284:	e822                	sd	s0,16(sp)
ffffffffc0200286:	e426                	sd	s1,8(sp)
ffffffffc0200288:	ec06                	sd	ra,24(sp)
ffffffffc020028a:	00005417          	auipc	s0,0x5
ffffffffc020028e:	4d640413          	addi	s0,s0,1238 # ffffffffc0205760 <commands>
ffffffffc0200292:	00005497          	auipc	s1,0x5
ffffffffc0200296:	51648493          	addi	s1,s1,1302 # ffffffffc02057a8 <commands+0x48>
ffffffffc020029a:	6410                	ld	a2,8(s0)
ffffffffc020029c:	600c                	ld	a1,0(s0)
ffffffffc020029e:	00004517          	auipc	a0,0x4
ffffffffc02002a2:	d2250513          	addi	a0,a0,-734 # ffffffffc0203fc0 <etext+0x136>
ffffffffc02002a6:	0461                	addi	s0,s0,24
ffffffffc02002a8:	eedff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02002ac:	fe9417e3          	bne	s0,s1,ffffffffc020029a <mon_help+0x18>
ffffffffc02002b0:	60e2                	ld	ra,24(sp)
ffffffffc02002b2:	6442                	ld	s0,16(sp)
ffffffffc02002b4:	64a2                	ld	s1,8(sp)
ffffffffc02002b6:	4501                	li	a0,0
ffffffffc02002b8:	6105                	addi	sp,sp,32
ffffffffc02002ba:	8082                	ret

ffffffffc02002bc <mon_kerninfo>:
ffffffffc02002bc:	1141                	addi	sp,sp,-16
ffffffffc02002be:	e406                	sd	ra,8(sp)
ffffffffc02002c0:	f1bff0ef          	jal	ffffffffc02001da <print_kerninfo>
ffffffffc02002c4:	60a2                	ld	ra,8(sp)
ffffffffc02002c6:	4501                	li	a0,0
ffffffffc02002c8:	0141                	addi	sp,sp,16
ffffffffc02002ca:	8082                	ret

ffffffffc02002cc <mon_backtrace>:
ffffffffc02002cc:	1141                	addi	sp,sp,-16
ffffffffc02002ce:	e406                	sd	ra,8(sp)
ffffffffc02002d0:	f97ff0ef          	jal	ffffffffc0200266 <print_stackframe>
ffffffffc02002d4:	60a2                	ld	ra,8(sp)
ffffffffc02002d6:	4501                	li	a0,0
ffffffffc02002d8:	0141                	addi	sp,sp,16
ffffffffc02002da:	8082                	ret

ffffffffc02002dc <kmonitor>:
ffffffffc02002dc:	7131                	addi	sp,sp,-192
ffffffffc02002de:	e952                	sd	s4,144(sp)
ffffffffc02002e0:	8a2a                	mv	s4,a0
ffffffffc02002e2:	00004517          	auipc	a0,0x4
ffffffffc02002e6:	cee50513          	addi	a0,a0,-786 # ffffffffc0203fd0 <etext+0x146>
ffffffffc02002ea:	fd06                	sd	ra,184(sp)
ffffffffc02002ec:	f922                	sd	s0,176(sp)
ffffffffc02002ee:	f526                	sd	s1,168(sp)
ffffffffc02002f0:	f14a                	sd	s2,160(sp)
ffffffffc02002f2:	e556                	sd	s5,136(sp)
ffffffffc02002f4:	e15a                	sd	s6,128(sp)
ffffffffc02002f6:	e9fff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02002fa:	00004517          	auipc	a0,0x4
ffffffffc02002fe:	cfe50513          	addi	a0,a0,-770 # ffffffffc0203ff8 <etext+0x16e>
ffffffffc0200302:	e93ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200306:	000a0563          	beqz	s4,ffffffffc0200310 <kmonitor+0x34>
ffffffffc020030a:	8552                	mv	a0,s4
ffffffffc020030c:	758000ef          	jal	ffffffffc0200a64 <print_trapframe>
ffffffffc0200310:	4501                	li	a0,0
ffffffffc0200312:	4581                	li	a1,0
ffffffffc0200314:	4601                	li	a2,0
ffffffffc0200316:	48a1                	li	a7,8
ffffffffc0200318:	00000073          	ecall
ffffffffc020031c:	00005a97          	auipc	s5,0x5
ffffffffc0200320:	444a8a93          	addi	s5,s5,1092 # ffffffffc0205760 <commands>
ffffffffc0200324:	493d                	li	s2,15
ffffffffc0200326:	00004517          	auipc	a0,0x4
ffffffffc020032a:	cfa50513          	addi	a0,a0,-774 # ffffffffc0204020 <etext+0x196>
ffffffffc020032e:	d79ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200332:	842a                	mv	s0,a0
ffffffffc0200334:	d96d                	beqz	a0,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200336:	00054583          	lbu	a1,0(a0)
ffffffffc020033a:	4481                	li	s1,0
ffffffffc020033c:	e99d                	bnez	a1,ffffffffc0200372 <kmonitor+0x96>
ffffffffc020033e:	8b26                	mv	s6,s1
ffffffffc0200340:	fe0b03e3          	beqz	s6,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200344:	00005497          	auipc	s1,0x5
ffffffffc0200348:	41c48493          	addi	s1,s1,1052 # ffffffffc0205760 <commands>
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	6582                	ld	a1,0(sp)
ffffffffc0200350:	6088                	ld	a0,0(s1)
ffffffffc0200352:	27d030ef          	jal	ffffffffc0203dce <strcmp>
ffffffffc0200356:	478d                	li	a5,3
ffffffffc0200358:	c149                	beqz	a0,ffffffffc02003da <kmonitor+0xfe>
ffffffffc020035a:	2405                	addiw	s0,s0,1
ffffffffc020035c:	04e1                	addi	s1,s1,24
ffffffffc020035e:	fef418e3          	bne	s0,a5,ffffffffc020034e <kmonitor+0x72>
ffffffffc0200362:	6582                	ld	a1,0(sp)
ffffffffc0200364:	00004517          	auipc	a0,0x4
ffffffffc0200368:	cec50513          	addi	a0,a0,-788 # ffffffffc0204050 <etext+0x1c6>
ffffffffc020036c:	e29ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200370:	bf5d                	j	ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200372:	00004517          	auipc	a0,0x4
ffffffffc0200376:	cb650513          	addi	a0,a0,-842 # ffffffffc0204028 <etext+0x19e>
ffffffffc020037a:	2b1030ef          	jal	ffffffffc0203e2a <strchr>
ffffffffc020037e:	c901                	beqz	a0,ffffffffc020038e <kmonitor+0xb2>
ffffffffc0200380:	00144583          	lbu	a1,1(s0)
ffffffffc0200384:	00040023          	sb	zero,0(s0)
ffffffffc0200388:	0405                	addi	s0,s0,1
ffffffffc020038a:	d9d5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc020038c:	b7dd                	j	ffffffffc0200372 <kmonitor+0x96>
ffffffffc020038e:	00044783          	lbu	a5,0(s0)
ffffffffc0200392:	d7d5                	beqz	a5,ffffffffc020033e <kmonitor+0x62>
ffffffffc0200394:	03248b63          	beq	s1,s2,ffffffffc02003ca <kmonitor+0xee>
ffffffffc0200398:	00349793          	slli	a5,s1,0x3
ffffffffc020039c:	978a                	add	a5,a5,sp
ffffffffc020039e:	e380                	sd	s0,0(a5)
ffffffffc02003a0:	00044583          	lbu	a1,0(s0)
ffffffffc02003a4:	2485                	addiw	s1,s1,1
ffffffffc02003a6:	8b26                	mv	s6,s1
ffffffffc02003a8:	e591                	bnez	a1,ffffffffc02003b4 <kmonitor+0xd8>
ffffffffc02003aa:	bf59                	j	ffffffffc0200340 <kmonitor+0x64>
ffffffffc02003ac:	00144583          	lbu	a1,1(s0)
ffffffffc02003b0:	0405                	addi	s0,s0,1
ffffffffc02003b2:	d5d1                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003b4:	00004517          	auipc	a0,0x4
ffffffffc02003b8:	c7450513          	addi	a0,a0,-908 # ffffffffc0204028 <etext+0x19e>
ffffffffc02003bc:	26f030ef          	jal	ffffffffc0203e2a <strchr>
ffffffffc02003c0:	d575                	beqz	a0,ffffffffc02003ac <kmonitor+0xd0>
ffffffffc02003c2:	00044583          	lbu	a1,0(s0)
ffffffffc02003c6:	dda5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003c8:	b76d                	j	ffffffffc0200372 <kmonitor+0x96>
ffffffffc02003ca:	45c1                	li	a1,16
ffffffffc02003cc:	00004517          	auipc	a0,0x4
ffffffffc02003d0:	c6450513          	addi	a0,a0,-924 # ffffffffc0204030 <etext+0x1a6>
ffffffffc02003d4:	dc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02003d8:	b7c1                	j	ffffffffc0200398 <kmonitor+0xbc>
ffffffffc02003da:	00141793          	slli	a5,s0,0x1
ffffffffc02003de:	97a2                	add	a5,a5,s0
ffffffffc02003e0:	078e                	slli	a5,a5,0x3
ffffffffc02003e2:	97d6                	add	a5,a5,s5
ffffffffc02003e4:	6b9c                	ld	a5,16(a5)
ffffffffc02003e6:	fffb051b          	addiw	a0,s6,-1
ffffffffc02003ea:	8652                	mv	a2,s4
ffffffffc02003ec:	002c                	addi	a1,sp,8
ffffffffc02003ee:	9782                	jalr	a5
ffffffffc02003f0:	f2055be3          	bgez	a0,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc02003f4:	70ea                	ld	ra,184(sp)
ffffffffc02003f6:	744a                	ld	s0,176(sp)
ffffffffc02003f8:	74aa                	ld	s1,168(sp)
ffffffffc02003fa:	790a                	ld	s2,160(sp)
ffffffffc02003fc:	6a4a                	ld	s4,144(sp)
ffffffffc02003fe:	6aaa                	ld	s5,136(sp)
ffffffffc0200400:	6b0a                	ld	s6,128(sp)
ffffffffc0200402:	6129                	addi	sp,sp,192
ffffffffc0200404:	8082                	ret

ffffffffc0200406 <__panic>:
ffffffffc0200406:	0000d317          	auipc	t1,0xd
ffffffffc020040a:	06232303          	lw	t1,98(t1) # ffffffffc020d468 <is_panic>
ffffffffc020040e:	715d                	addi	sp,sp,-80
ffffffffc0200410:	ec06                	sd	ra,24(sp)
ffffffffc0200412:	f436                	sd	a3,40(sp)
ffffffffc0200414:	f83a                	sd	a4,48(sp)
ffffffffc0200416:	fc3e                	sd	a5,56(sp)
ffffffffc0200418:	e0c2                	sd	a6,64(sp)
ffffffffc020041a:	e4c6                	sd	a7,72(sp)
ffffffffc020041c:	02031e63          	bnez	t1,ffffffffc0200458 <__panic+0x52>
ffffffffc0200420:	4705                	li	a4,1
ffffffffc0200422:	103c                	addi	a5,sp,40
ffffffffc0200424:	e822                	sd	s0,16(sp)
ffffffffc0200426:	8432                	mv	s0,a2
ffffffffc0200428:	862e                	mv	a2,a1
ffffffffc020042a:	85aa                	mv	a1,a0
ffffffffc020042c:	00004517          	auipc	a0,0x4
ffffffffc0200430:	ccc50513          	addi	a0,a0,-820 # ffffffffc02040f8 <etext+0x26e>
ffffffffc0200434:	0000d697          	auipc	a3,0xd
ffffffffc0200438:	02e6aa23          	sw	a4,52(a3) # ffffffffc020d468 <is_panic>
ffffffffc020043c:	e43e                	sd	a5,8(sp)
ffffffffc020043e:	d57ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200442:	65a2                	ld	a1,8(sp)
ffffffffc0200444:	8522                	mv	a0,s0
ffffffffc0200446:	d2fff0ef          	jal	ffffffffc0200174 <vcprintf>
ffffffffc020044a:	00004517          	auipc	a0,0x4
ffffffffc020044e:	cce50513          	addi	a0,a0,-818 # ffffffffc0204118 <etext+0x28e>
ffffffffc0200452:	d43ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200456:	6442                	ld	s0,16(sp)
ffffffffc0200458:	41c000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020045c:	4501                	li	a0,0
ffffffffc020045e:	e7fff0ef          	jal	ffffffffc02002dc <kmonitor>
ffffffffc0200462:	bfed                	j	ffffffffc020045c <__panic+0x56>

ffffffffc0200464 <clock_init>:
ffffffffc0200464:	67e1                	lui	a5,0x18
ffffffffc0200466:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046a:	0000d717          	auipc	a4,0xd
ffffffffc020046e:	00f73323          	sd	a5,6(a4) # ffffffffc020d470 <timebase>
ffffffffc0200472:	c0102573          	rdtime	a0
ffffffffc0200476:	4581                	li	a1,0
ffffffffc0200478:	953e                	add	a0,a0,a5
ffffffffc020047a:	4601                	li	a2,0
ffffffffc020047c:	4881                	li	a7,0
ffffffffc020047e:	00000073          	ecall
ffffffffc0200482:	02000793          	li	a5,32
ffffffffc0200486:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020048a:	00004517          	auipc	a0,0x4
ffffffffc020048e:	c9650513          	addi	a0,a0,-874 # ffffffffc0204120 <etext+0x296>
ffffffffc0200492:	0000d797          	auipc	a5,0xd
ffffffffc0200496:	fe07b323          	sd	zero,-26(a5) # ffffffffc020d478 <ticks>
ffffffffc020049a:	b9ed                	j	ffffffffc0200194 <cprintf>

ffffffffc020049c <clock_set_next_event>:
ffffffffc020049c:	c0102573          	rdtime	a0
ffffffffc02004a0:	0000d797          	auipc	a5,0xd
ffffffffc02004a4:	fd07b783          	ld	a5,-48(a5) # ffffffffc020d470 <timebase>
ffffffffc02004a8:	4581                	li	a1,0
ffffffffc02004aa:	4601                	li	a2,0
ffffffffc02004ac:	953e                	add	a0,a0,a5
ffffffffc02004ae:	4881                	li	a7,0
ffffffffc02004b0:	00000073          	ecall
ffffffffc02004b4:	8082                	ret

ffffffffc02004b6 <cons_init>:
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <cons_putc>:
ffffffffc02004b8:	100027f3          	csrr	a5,sstatus
ffffffffc02004bc:	8b89                	andi	a5,a5,2
ffffffffc02004be:	0ff57513          	zext.b	a0,a0
ffffffffc02004c2:	e799                	bnez	a5,ffffffffc02004d0 <cons_putc+0x18>
ffffffffc02004c4:	4581                	li	a1,0
ffffffffc02004c6:	4601                	li	a2,0
ffffffffc02004c8:	4885                	li	a7,1
ffffffffc02004ca:	00000073          	ecall
ffffffffc02004ce:	8082                	ret
ffffffffc02004d0:	1101                	addi	sp,sp,-32
ffffffffc02004d2:	ec06                	sd	ra,24(sp)
ffffffffc02004d4:	e42a                	sd	a0,8(sp)
ffffffffc02004d6:	39e000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02004da:	6522                	ld	a0,8(sp)
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	4885                	li	a7,1
ffffffffc02004e2:	00000073          	ecall
ffffffffc02004e6:	60e2                	ld	ra,24(sp)
ffffffffc02004e8:	6105                	addi	sp,sp,32
ffffffffc02004ea:	a651                	j	ffffffffc020086e <intr_enable>

ffffffffc02004ec <cons_getc>:
ffffffffc02004ec:	100027f3          	csrr	a5,sstatus
ffffffffc02004f0:	8b89                	andi	a5,a5,2
ffffffffc02004f2:	eb89                	bnez	a5,ffffffffc0200504 <cons_getc+0x18>
ffffffffc02004f4:	4501                	li	a0,0
ffffffffc02004f6:	4581                	li	a1,0
ffffffffc02004f8:	4601                	li	a2,0
ffffffffc02004fa:	4889                	li	a7,2
ffffffffc02004fc:	00000073          	ecall
ffffffffc0200500:	2501                	sext.w	a0,a0
ffffffffc0200502:	8082                	ret
ffffffffc0200504:	1101                	addi	sp,sp,-32
ffffffffc0200506:	ec06                	sd	ra,24(sp)
ffffffffc0200508:	36c000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020050c:	4501                	li	a0,0
ffffffffc020050e:	4581                	li	a1,0
ffffffffc0200510:	4601                	li	a2,0
ffffffffc0200512:	4889                	li	a7,2
ffffffffc0200514:	00000073          	ecall
ffffffffc0200518:	2501                	sext.w	a0,a0
ffffffffc020051a:	e42a                	sd	a0,8(sp)
ffffffffc020051c:	352000ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0200520:	60e2                	ld	ra,24(sp)
ffffffffc0200522:	6522                	ld	a0,8(sp)
ffffffffc0200524:	6105                	addi	sp,sp,32
ffffffffc0200526:	8082                	ret

ffffffffc0200528 <dtb_init>:
ffffffffc0200528:	7179                	addi	sp,sp,-48
ffffffffc020052a:	00004517          	auipc	a0,0x4
ffffffffc020052e:	c1650513          	addi	a0,a0,-1002 # ffffffffc0204140 <etext+0x2b6>
ffffffffc0200532:	f406                	sd	ra,40(sp)
ffffffffc0200534:	f022                	sd	s0,32(sp)
ffffffffc0200536:	c5fff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020053a:	00009597          	auipc	a1,0x9
ffffffffc020053e:	ac65b583          	ld	a1,-1338(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc0200542:	00004517          	auipc	a0,0x4
ffffffffc0200546:	c0e50513          	addi	a0,a0,-1010 # ffffffffc0204150 <etext+0x2c6>
ffffffffc020054a:	00009417          	auipc	s0,0x9
ffffffffc020054e:	abe40413          	addi	s0,s0,-1346 # ffffffffc0209008 <boot_dtb>
ffffffffc0200552:	c43ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200556:	600c                	ld	a1,0(s0)
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0204160 <etext+0x2d6>
ffffffffc0200560:	c35ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200564:	6018                	ld	a4,0(s0)
ffffffffc0200566:	00004517          	auipc	a0,0x4
ffffffffc020056a:	c1250513          	addi	a0,a0,-1006 # ffffffffc0204178 <etext+0x2ee>
ffffffffc020056e:	10070163          	beqz	a4,ffffffffc0200670 <dtb_init+0x148>
ffffffffc0200572:	57f5                	li	a5,-3
ffffffffc0200574:	07fa                	slli	a5,a5,0x1e
ffffffffc0200576:	973e                	add	a4,a4,a5
ffffffffc0200578:	431c                	lw	a5,0(a4)
ffffffffc020057a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020057e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed29fd>
ffffffffc0200582:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200586:	0187961b          	slliw	a2,a5,0x18
ffffffffc020058a:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020058e:	0ff5f593          	zext.b	a1,a1
ffffffffc0200592:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200596:	05c2                	slli	a1,a1,0x10
ffffffffc0200598:	8e49                	or	a2,a2,a0
ffffffffc020059a:	0ff7f793          	zext.b	a5,a5
ffffffffc020059e:	8dd1                	or	a1,a1,a2
ffffffffc02005a0:	07a2                	slli	a5,a5,0x8
ffffffffc02005a2:	8ddd                	or	a1,a1,a5
ffffffffc02005a4:	00ff0837          	lui	a6,0xff0
ffffffffc02005a8:	0cd59863          	bne	a1,a3,ffffffffc0200678 <dtb_init+0x150>
ffffffffc02005ac:	4710                	lw	a2,8(a4)
ffffffffc02005ae:	4754                	lw	a3,12(a4)
ffffffffc02005b0:	e84a                	sd	s2,16(sp)
ffffffffc02005b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02005b6:	0086d79b          	srliw	a5,a3,0x8
ffffffffc02005ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02005be:	0186d89b          	srliw	a7,a3,0x18
ffffffffc02005c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02005c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02005ca:	0104141b          	slliw	s0,s0,0x10
ffffffffc02005ce:	0106561b          	srliw	a2,a2,0x10
ffffffffc02005d2:	0107979b          	slliw	a5,a5,0x10
ffffffffc02005d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02005da:	01c56533          	or	a0,a0,t3
ffffffffc02005de:	0115e5b3          	or	a1,a1,a7
ffffffffc02005e2:	01047433          	and	s0,s0,a6
ffffffffc02005e6:	0ff67613          	zext.b	a2,a2
ffffffffc02005ea:	0107f7b3          	and	a5,a5,a6
ffffffffc02005ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02005f2:	8c49                	or	s0,s0,a0
ffffffffc02005f4:	0622                	slli	a2,a2,0x8
ffffffffc02005f6:	8fcd                	or	a5,a5,a1
ffffffffc02005f8:	06a2                	slli	a3,a3,0x8
ffffffffc02005fa:	8c51                	or	s0,s0,a2
ffffffffc02005fc:	8fd5                	or	a5,a5,a3
ffffffffc02005fe:	1402                	slli	s0,s0,0x20
ffffffffc0200600:	1782                	slli	a5,a5,0x20
ffffffffc0200602:	9001                	srli	s0,s0,0x20
ffffffffc0200604:	9381                	srli	a5,a5,0x20
ffffffffc0200606:	ec26                	sd	s1,24(sp)
ffffffffc0200608:	4301                	li	t1,0
ffffffffc020060a:	488d                	li	a7,3
ffffffffc020060c:	943a                	add	s0,s0,a4
ffffffffc020060e:	00e78933          	add	s2,a5,a4
ffffffffc0200612:	4e05                	li	t3,1
ffffffffc0200614:	4018                	lw	a4,0(s0)
ffffffffc0200616:	0087579b          	srliw	a5,a4,0x8
ffffffffc020061a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020061e:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200622:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200626:	0107571b          	srliw	a4,a4,0x10
ffffffffc020062a:	0107f7b3          	and	a5,a5,a6
ffffffffc020062e:	8ed1                	or	a3,a3,a2
ffffffffc0200630:	0ff77713          	zext.b	a4,a4
ffffffffc0200634:	8fd5                	or	a5,a5,a3
ffffffffc0200636:	0722                	slli	a4,a4,0x8
ffffffffc0200638:	8fd9                	or	a5,a5,a4
ffffffffc020063a:	05178763          	beq	a5,a7,ffffffffc0200688 <dtb_init+0x160>
ffffffffc020063e:	0411                	addi	s0,s0,4
ffffffffc0200640:	00f8e963          	bltu	a7,a5,ffffffffc0200652 <dtb_init+0x12a>
ffffffffc0200644:	07c78d63          	beq	a5,t3,ffffffffc02006be <dtb_init+0x196>
ffffffffc0200648:	4709                	li	a4,2
ffffffffc020064a:	00e79763          	bne	a5,a4,ffffffffc0200658 <dtb_init+0x130>
ffffffffc020064e:	4301                	li	t1,0
ffffffffc0200650:	b7d1                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc0200652:	4711                	li	a4,4
ffffffffc0200654:	fce780e3          	beq	a5,a4,ffffffffc0200614 <dtb_init+0xec>
ffffffffc0200658:	00004517          	auipc	a0,0x4
ffffffffc020065c:	be850513          	addi	a0,a0,-1048 # ffffffffc0204240 <etext+0x3b6>
ffffffffc0200660:	b35ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200664:	64e2                	ld	s1,24(sp)
ffffffffc0200666:	6942                	ld	s2,16(sp)
ffffffffc0200668:	00004517          	auipc	a0,0x4
ffffffffc020066c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0204278 <etext+0x3ee>
ffffffffc0200670:	7402                	ld	s0,32(sp)
ffffffffc0200672:	70a2                	ld	ra,40(sp)
ffffffffc0200674:	6145                	addi	sp,sp,48
ffffffffc0200676:	be39                	j	ffffffffc0200194 <cprintf>
ffffffffc0200678:	7402                	ld	s0,32(sp)
ffffffffc020067a:	70a2                	ld	ra,40(sp)
ffffffffc020067c:	00004517          	auipc	a0,0x4
ffffffffc0200680:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0204198 <etext+0x30e>
ffffffffc0200684:	6145                	addi	sp,sp,48
ffffffffc0200686:	b639                	j	ffffffffc0200194 <cprintf>
ffffffffc0200688:	4058                	lw	a4,4(s0)
ffffffffc020068a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020068e:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200692:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200696:	0107979b          	slliw	a5,a5,0x10
ffffffffc020069a:	0107571b          	srliw	a4,a4,0x10
ffffffffc020069e:	0107f7b3          	and	a5,a5,a6
ffffffffc02006a2:	8ed1                	or	a3,a3,a2
ffffffffc02006a4:	0ff77713          	zext.b	a4,a4
ffffffffc02006a8:	8fd5                	or	a5,a5,a3
ffffffffc02006aa:	0722                	slli	a4,a4,0x8
ffffffffc02006ac:	8fd9                	or	a5,a5,a4
ffffffffc02006ae:	04031463          	bnez	t1,ffffffffc02006f6 <dtb_init+0x1ce>
ffffffffc02006b2:	1782                	slli	a5,a5,0x20
ffffffffc02006b4:	9381                	srli	a5,a5,0x20
ffffffffc02006b6:	043d                	addi	s0,s0,15
ffffffffc02006b8:	943e                	add	s0,s0,a5
ffffffffc02006ba:	9871                	andi	s0,s0,-4
ffffffffc02006bc:	bfa1                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc02006be:	8522                	mv	a0,s0
ffffffffc02006c0:	e01a                	sd	t1,0(sp)
ffffffffc02006c2:	6c6030ef          	jal	ffffffffc0203d88 <strlen>
ffffffffc02006c6:	84aa                	mv	s1,a0
ffffffffc02006c8:	4619                	li	a2,6
ffffffffc02006ca:	8522                	mv	a0,s0
ffffffffc02006cc:	00004597          	auipc	a1,0x4
ffffffffc02006d0:	af458593          	addi	a1,a1,-1292 # ffffffffc02041c0 <etext+0x336>
ffffffffc02006d4:	72e030ef          	jal	ffffffffc0203e02 <strncmp>
ffffffffc02006d8:	6302                	ld	t1,0(sp)
ffffffffc02006da:	0411                	addi	s0,s0,4
ffffffffc02006dc:	0004879b          	sext.w	a5,s1
ffffffffc02006e0:	943e                	add	s0,s0,a5
ffffffffc02006e2:	00153513          	seqz	a0,a0
ffffffffc02006e6:	9871                	andi	s0,s0,-4
ffffffffc02006e8:	00a36333          	or	t1,t1,a0
ffffffffc02006ec:	00ff0837          	lui	a6,0xff0
ffffffffc02006f0:	488d                	li	a7,3
ffffffffc02006f2:	4e05                	li	t3,1
ffffffffc02006f4:	b705                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc02006f6:	4418                	lw	a4,8(s0)
ffffffffc02006f8:	00004597          	auipc	a1,0x4
ffffffffc02006fc:	ad058593          	addi	a1,a1,-1328 # ffffffffc02041c8 <etext+0x33e>
ffffffffc0200700:	e43e                	sd	a5,8(sp)
ffffffffc0200702:	0087551b          	srliw	a0,a4,0x8
ffffffffc0200706:	0187561b          	srliw	a2,a4,0x18
ffffffffc020070a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020070e:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200712:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200716:	01057533          	and	a0,a0,a6
ffffffffc020071a:	8ed1                	or	a3,a3,a2
ffffffffc020071c:	0ff77713          	zext.b	a4,a4
ffffffffc0200720:	0722                	slli	a4,a4,0x8
ffffffffc0200722:	8d55                	or	a0,a0,a3
ffffffffc0200724:	8d59                	or	a0,a0,a4
ffffffffc0200726:	1502                	slli	a0,a0,0x20
ffffffffc0200728:	9101                	srli	a0,a0,0x20
ffffffffc020072a:	954a                	add	a0,a0,s2
ffffffffc020072c:	e01a                	sd	t1,0(sp)
ffffffffc020072e:	6a0030ef          	jal	ffffffffc0203dce <strcmp>
ffffffffc0200732:	67a2                	ld	a5,8(sp)
ffffffffc0200734:	473d                	li	a4,15
ffffffffc0200736:	6302                	ld	t1,0(sp)
ffffffffc0200738:	00ff0837          	lui	a6,0xff0
ffffffffc020073c:	488d                	li	a7,3
ffffffffc020073e:	4e05                	li	t3,1
ffffffffc0200740:	f6f779e3          	bgeu	a4,a5,ffffffffc02006b2 <dtb_init+0x18a>
ffffffffc0200744:	f53d                	bnez	a0,ffffffffc02006b2 <dtb_init+0x18a>
ffffffffc0200746:	00c43683          	ld	a3,12(s0)
ffffffffc020074a:	01443703          	ld	a4,20(s0)
ffffffffc020074e:	00004517          	auipc	a0,0x4
ffffffffc0200752:	a8250513          	addi	a0,a0,-1406 # ffffffffc02041d0 <etext+0x346>
ffffffffc0200756:	4206d793          	srai	a5,a3,0x20
ffffffffc020075a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020075e:	00871f93          	slli	t6,a4,0x8
ffffffffc0200762:	42075893          	srai	a7,a4,0x20
ffffffffc0200766:	0187df1b          	srliw	t5,a5,0x18
ffffffffc020076a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020076e:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200772:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200776:	420fd613          	srai	a2,t6,0x20
ffffffffc020077a:	0188de9b          	srliw	t4,a7,0x18
ffffffffc020077e:	01037333          	and	t1,t1,a6
ffffffffc0200782:	01889e1b          	slliw	t3,a7,0x18
ffffffffc0200786:	01e5e5b3          	or	a1,a1,t5
ffffffffc020078a:	0ff7f793          	zext.b	a5,a5
ffffffffc020078e:	01de6e33          	or	t3,t3,t4
ffffffffc0200792:	0065e5b3          	or	a1,a1,t1
ffffffffc0200796:	01067633          	and	a2,a2,a6
ffffffffc020079a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020079e:	0087541b          	srliw	s0,a4,0x8
ffffffffc02007a2:	07a2                	slli	a5,a5,0x8
ffffffffc02007a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02007a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02007ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02007b0:	8ddd                	or	a1,a1,a5
ffffffffc02007b2:	01c66633          	or	a2,a2,t3
ffffffffc02007b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02007ba:	01871e1b          	slliw	t3,a4,0x18
ffffffffc02007be:	0ff8f893          	zext.b	a7,a7
ffffffffc02007c2:	0103131b          	slliw	t1,t1,0x10
ffffffffc02007c6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02007ca:	0104141b          	slliw	s0,s0,0x10
ffffffffc02007ce:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007d2:	01037333          	and	t1,t1,a6
ffffffffc02007d6:	08a2                	slli	a7,a7,0x8
ffffffffc02007d8:	01e7e7b3          	or	a5,a5,t5
ffffffffc02007dc:	01047433          	and	s0,s0,a6
ffffffffc02007e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02007e4:	01de6833          	or	a6,t3,t4
ffffffffc02007e8:	0ff77713          	zext.b	a4,a4
ffffffffc02007ec:	01166633          	or	a2,a2,a7
ffffffffc02007f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02007f4:	06a2                	slli	a3,a3,0x8
ffffffffc02007f6:	01046433          	or	s0,s0,a6
ffffffffc02007fa:	0722                	slli	a4,a4,0x8
ffffffffc02007fc:	8fd5                	or	a5,a5,a3
ffffffffc02007fe:	8c59                	or	s0,s0,a4
ffffffffc0200800:	1582                	slli	a1,a1,0x20
ffffffffc0200802:	1602                	slli	a2,a2,0x20
ffffffffc0200804:	1782                	slli	a5,a5,0x20
ffffffffc0200806:	9201                	srli	a2,a2,0x20
ffffffffc0200808:	9181                	srli	a1,a1,0x20
ffffffffc020080a:	1402                	slli	s0,s0,0x20
ffffffffc020080c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200810:	8c51                	or	s0,s0,a2
ffffffffc0200812:	983ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200816:	85a6                	mv	a1,s1
ffffffffc0200818:	00004517          	auipc	a0,0x4
ffffffffc020081c:	9d850513          	addi	a0,a0,-1576 # ffffffffc02041f0 <etext+0x366>
ffffffffc0200820:	975ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200824:	01445613          	srli	a2,s0,0x14
ffffffffc0200828:	85a2                	mv	a1,s0
ffffffffc020082a:	00004517          	auipc	a0,0x4
ffffffffc020082e:	9de50513          	addi	a0,a0,-1570 # ffffffffc0204208 <etext+0x37e>
ffffffffc0200832:	963ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200836:	009405b3          	add	a1,s0,s1
ffffffffc020083a:	15fd                	addi	a1,a1,-1
ffffffffc020083c:	00004517          	auipc	a0,0x4
ffffffffc0200840:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0204228 <etext+0x39e>
ffffffffc0200844:	951ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200848:	0000d797          	auipc	a5,0xd
ffffffffc020084c:	c497b023          	sd	s1,-960(a5) # ffffffffc020d488 <memory_base>
ffffffffc0200850:	0000d797          	auipc	a5,0xd
ffffffffc0200854:	c287b823          	sd	s0,-976(a5) # ffffffffc020d480 <memory_size>
ffffffffc0200858:	b531                	j	ffffffffc0200664 <dtb_init+0x13c>

ffffffffc020085a <get_memory_base>:
ffffffffc020085a:	0000d517          	auipc	a0,0xd
ffffffffc020085e:	c2e53503          	ld	a0,-978(a0) # ffffffffc020d488 <memory_base>
ffffffffc0200862:	8082                	ret

ffffffffc0200864 <get_memory_size>:
ffffffffc0200864:	0000d517          	auipc	a0,0xd
ffffffffc0200868:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d480 <memory_size>
ffffffffc020086c:	8082                	ret

ffffffffc020086e <intr_enable>:
ffffffffc020086e:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200872:	8082                	ret

ffffffffc0200874 <intr_disable>:
ffffffffc0200874:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200878:	8082                	ret

ffffffffc020087a <pic_init>:
ffffffffc020087a:	8082                	ret

ffffffffc020087c <idt_init>:
ffffffffc020087c:	14005073          	csrwi	sscratch,0
ffffffffc0200880:	00000797          	auipc	a5,0x0
ffffffffc0200884:	40c78793          	addi	a5,a5,1036 # ffffffffc0200c8c <__alltraps>
ffffffffc0200888:	10579073          	csrw	stvec,a5
ffffffffc020088c:	000407b7          	lui	a5,0x40
ffffffffc0200890:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200894:	8082                	ret

ffffffffc0200896 <print_regs>:
ffffffffc0200896:	610c                	ld	a1,0(a0)
ffffffffc0200898:	1141                	addi	sp,sp,-16
ffffffffc020089a:	e022                	sd	s0,0(sp)
ffffffffc020089c:	842a                	mv	s0,a0
ffffffffc020089e:	00004517          	auipc	a0,0x4
ffffffffc02008a2:	9f250513          	addi	a0,a0,-1550 # ffffffffc0204290 <etext+0x406>
ffffffffc02008a6:	e406                	sd	ra,8(sp)
ffffffffc02008a8:	8edff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008ac:	640c                	ld	a1,8(s0)
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc02042a8 <etext+0x41e>
ffffffffc02008b6:	8dfff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008ba:	680c                	ld	a1,16(s0)
ffffffffc02008bc:	00004517          	auipc	a0,0x4
ffffffffc02008c0:	a0450513          	addi	a0,a0,-1532 # ffffffffc02042c0 <etext+0x436>
ffffffffc02008c4:	8d1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008c8:	6c0c                	ld	a1,24(s0)
ffffffffc02008ca:	00004517          	auipc	a0,0x4
ffffffffc02008ce:	a0e50513          	addi	a0,a0,-1522 # ffffffffc02042d8 <etext+0x44e>
ffffffffc02008d2:	8c3ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008d6:	700c                	ld	a1,32(s0)
ffffffffc02008d8:	00004517          	auipc	a0,0x4
ffffffffc02008dc:	a1850513          	addi	a0,a0,-1512 # ffffffffc02042f0 <etext+0x466>
ffffffffc02008e0:	8b5ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008e4:	740c                	ld	a1,40(s0)
ffffffffc02008e6:	00004517          	auipc	a0,0x4
ffffffffc02008ea:	a2250513          	addi	a0,a0,-1502 # ffffffffc0204308 <etext+0x47e>
ffffffffc02008ee:	8a7ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02008f2:	780c                	ld	a1,48(s0)
ffffffffc02008f4:	00004517          	auipc	a0,0x4
ffffffffc02008f8:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0204320 <etext+0x496>
ffffffffc02008fc:	899ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200900:	7c0c                	ld	a1,56(s0)
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	a3650513          	addi	a0,a0,-1482 # ffffffffc0204338 <etext+0x4ae>
ffffffffc020090a:	88bff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020090e:	602c                	ld	a1,64(s0)
ffffffffc0200910:	00004517          	auipc	a0,0x4
ffffffffc0200914:	a4050513          	addi	a0,a0,-1472 # ffffffffc0204350 <etext+0x4c6>
ffffffffc0200918:	87dff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020091c:	642c                	ld	a1,72(s0)
ffffffffc020091e:	00004517          	auipc	a0,0x4
ffffffffc0200922:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0204368 <etext+0x4de>
ffffffffc0200926:	86fff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020092a:	682c                	ld	a1,80(s0)
ffffffffc020092c:	00004517          	auipc	a0,0x4
ffffffffc0200930:	a5450513          	addi	a0,a0,-1452 # ffffffffc0204380 <etext+0x4f6>
ffffffffc0200934:	861ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200938:	6c2c                	ld	a1,88(s0)
ffffffffc020093a:	00004517          	auipc	a0,0x4
ffffffffc020093e:	a5e50513          	addi	a0,a0,-1442 # ffffffffc0204398 <etext+0x50e>
ffffffffc0200942:	853ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200946:	702c                	ld	a1,96(s0)
ffffffffc0200948:	00004517          	auipc	a0,0x4
ffffffffc020094c:	a6850513          	addi	a0,a0,-1432 # ffffffffc02043b0 <etext+0x526>
ffffffffc0200950:	845ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200954:	742c                	ld	a1,104(s0)
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	a7250513          	addi	a0,a0,-1422 # ffffffffc02043c8 <etext+0x53e>
ffffffffc020095e:	837ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200962:	782c                	ld	a1,112(s0)
ffffffffc0200964:	00004517          	auipc	a0,0x4
ffffffffc0200968:	a7c50513          	addi	a0,a0,-1412 # ffffffffc02043e0 <etext+0x556>
ffffffffc020096c:	829ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200970:	7c2c                	ld	a1,120(s0)
ffffffffc0200972:	00004517          	auipc	a0,0x4
ffffffffc0200976:	a8650513          	addi	a0,a0,-1402 # ffffffffc02043f8 <etext+0x56e>
ffffffffc020097a:	81bff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020097e:	604c                	ld	a1,128(s0)
ffffffffc0200980:	00004517          	auipc	a0,0x4
ffffffffc0200984:	a9050513          	addi	a0,a0,-1392 # ffffffffc0204410 <etext+0x586>
ffffffffc0200988:	80dff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020098c:	644c                	ld	a1,136(s0)
ffffffffc020098e:	00004517          	auipc	a0,0x4
ffffffffc0200992:	a9a50513          	addi	a0,a0,-1382 # ffffffffc0204428 <etext+0x59e>
ffffffffc0200996:	ffeff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020099a:	684c                	ld	a1,144(s0)
ffffffffc020099c:	00004517          	auipc	a0,0x4
ffffffffc02009a0:	aa450513          	addi	a0,a0,-1372 # ffffffffc0204440 <etext+0x5b6>
ffffffffc02009a4:	ff0ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009a8:	6c4c                	ld	a1,152(s0)
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	aae50513          	addi	a0,a0,-1362 # ffffffffc0204458 <etext+0x5ce>
ffffffffc02009b2:	fe2ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009b6:	704c                	ld	a1,160(s0)
ffffffffc02009b8:	00004517          	auipc	a0,0x4
ffffffffc02009bc:	ab850513          	addi	a0,a0,-1352 # ffffffffc0204470 <etext+0x5e6>
ffffffffc02009c0:	fd4ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009c4:	744c                	ld	a1,168(s0)
ffffffffc02009c6:	00004517          	auipc	a0,0x4
ffffffffc02009ca:	ac250513          	addi	a0,a0,-1342 # ffffffffc0204488 <etext+0x5fe>
ffffffffc02009ce:	fc6ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009d2:	784c                	ld	a1,176(s0)
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	acc50513          	addi	a0,a0,-1332 # ffffffffc02044a0 <etext+0x616>
ffffffffc02009dc:	fb8ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009e0:	7c4c                	ld	a1,184(s0)
ffffffffc02009e2:	00004517          	auipc	a0,0x4
ffffffffc02009e6:	ad650513          	addi	a0,a0,-1322 # ffffffffc02044b8 <etext+0x62e>
ffffffffc02009ea:	faaff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009ee:	606c                	ld	a1,192(s0)
ffffffffc02009f0:	00004517          	auipc	a0,0x4
ffffffffc02009f4:	ae050513          	addi	a0,a0,-1312 # ffffffffc02044d0 <etext+0x646>
ffffffffc02009f8:	f9cff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02009fc:	646c                	ld	a1,200(s0)
ffffffffc02009fe:	00004517          	auipc	a0,0x4
ffffffffc0200a02:	aea50513          	addi	a0,a0,-1302 # ffffffffc02044e8 <etext+0x65e>
ffffffffc0200a06:	f8eff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a0a:	686c                	ld	a1,208(s0)
ffffffffc0200a0c:	00004517          	auipc	a0,0x4
ffffffffc0200a10:	af450513          	addi	a0,a0,-1292 # ffffffffc0204500 <etext+0x676>
ffffffffc0200a14:	f80ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a18:	6c6c                	ld	a1,216(s0)
ffffffffc0200a1a:	00004517          	auipc	a0,0x4
ffffffffc0200a1e:	afe50513          	addi	a0,a0,-1282 # ffffffffc0204518 <etext+0x68e>
ffffffffc0200a22:	f72ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a26:	706c                	ld	a1,224(s0)
ffffffffc0200a28:	00004517          	auipc	a0,0x4
ffffffffc0200a2c:	b0850513          	addi	a0,a0,-1272 # ffffffffc0204530 <etext+0x6a6>
ffffffffc0200a30:	f64ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a34:	746c                	ld	a1,232(s0)
ffffffffc0200a36:	00004517          	auipc	a0,0x4
ffffffffc0200a3a:	b1250513          	addi	a0,a0,-1262 # ffffffffc0204548 <etext+0x6be>
ffffffffc0200a3e:	f56ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a42:	786c                	ld	a1,240(s0)
ffffffffc0200a44:	00004517          	auipc	a0,0x4
ffffffffc0200a48:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0204560 <etext+0x6d6>
ffffffffc0200a4c:	f48ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a50:	7c6c                	ld	a1,248(s0)
ffffffffc0200a52:	6402                	ld	s0,0(sp)
ffffffffc0200a54:	60a2                	ld	ra,8(sp)
ffffffffc0200a56:	00004517          	auipc	a0,0x4
ffffffffc0200a5a:	b2250513          	addi	a0,a0,-1246 # ffffffffc0204578 <etext+0x6ee>
ffffffffc0200a5e:	0141                	addi	sp,sp,16
ffffffffc0200a60:	f34ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200a64 <print_trapframe>:
ffffffffc0200a64:	1141                	addi	sp,sp,-16
ffffffffc0200a66:	e022                	sd	s0,0(sp)
ffffffffc0200a68:	85aa                	mv	a1,a0
ffffffffc0200a6a:	842a                	mv	s0,a0
ffffffffc0200a6c:	00004517          	auipc	a0,0x4
ffffffffc0200a70:	b2450513          	addi	a0,a0,-1244 # ffffffffc0204590 <etext+0x706>
ffffffffc0200a74:	e406                	sd	ra,8(sp)
ffffffffc0200a76:	f1eff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a7a:	8522                	mv	a0,s0
ffffffffc0200a7c:	e1bff0ef          	jal	ffffffffc0200896 <print_regs>
ffffffffc0200a80:	10043583          	ld	a1,256(s0)
ffffffffc0200a84:	00004517          	auipc	a0,0x4
ffffffffc0200a88:	b2450513          	addi	a0,a0,-1244 # ffffffffc02045a8 <etext+0x71e>
ffffffffc0200a8c:	f08ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200a90:	10843583          	ld	a1,264(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	b2c50513          	addi	a0,a0,-1236 # ffffffffc02045c0 <etext+0x736>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200aa0:	11043583          	ld	a1,272(s0)
ffffffffc0200aa4:	00004517          	auipc	a0,0x4
ffffffffc0200aa8:	b3450513          	addi	a0,a0,-1228 # ffffffffc02045d8 <etext+0x74e>
ffffffffc0200aac:	ee8ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200ab0:	11843583          	ld	a1,280(s0)
ffffffffc0200ab4:	6402                	ld	s0,0(sp)
ffffffffc0200ab6:	60a2                	ld	ra,8(sp)
ffffffffc0200ab8:	00004517          	auipc	a0,0x4
ffffffffc0200abc:	b3850513          	addi	a0,a0,-1224 # ffffffffc02045f0 <etext+0x766>
ffffffffc0200ac0:	0141                	addi	sp,sp,16
ffffffffc0200ac2:	ed2ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ac6 <interrupt_handler>:
ffffffffc0200ac6:	11853783          	ld	a5,280(a0)
ffffffffc0200aca:	472d                	li	a4,11
ffffffffc0200acc:	0786                	slli	a5,a5,0x1
ffffffffc0200ace:	8385                	srli	a5,a5,0x1
ffffffffc0200ad0:	0af76c63          	bltu	a4,a5,ffffffffc0200b88 <interrupt_handler+0xc2>
ffffffffc0200ad4:	00005717          	auipc	a4,0x5
ffffffffc0200ad8:	cd470713          	addi	a4,a4,-812 # ffffffffc02057a8 <commands+0x48>
ffffffffc0200adc:	078a                	slli	a5,a5,0x2
ffffffffc0200ade:	97ba                	add	a5,a5,a4
ffffffffc0200ae0:	439c                	lw	a5,0(a5)
ffffffffc0200ae2:	97ba                	add	a5,a5,a4
ffffffffc0200ae4:	8782                	jr	a5
ffffffffc0200ae6:	00004517          	auipc	a0,0x4
ffffffffc0200aea:	b8250513          	addi	a0,a0,-1150 # ffffffffc0204668 <etext+0x7de>
ffffffffc0200aee:	ea6ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	b5650513          	addi	a0,a0,-1194 # ffffffffc0204648 <etext+0x7be>
ffffffffc0200afa:	e9aff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200afe:	00004517          	auipc	a0,0x4
ffffffffc0200b02:	b0a50513          	addi	a0,a0,-1270 # ffffffffc0204608 <etext+0x77e>
ffffffffc0200b06:	e8eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200b0a:	00004517          	auipc	a0,0x4
ffffffffc0200b0e:	b1e50513          	addi	a0,a0,-1250 # ffffffffc0204628 <etext+0x79e>
ffffffffc0200b12:	e82ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200b16:	1141                	addi	sp,sp,-16
ffffffffc0200b18:	e406                	sd	ra,8(sp)
ffffffffc0200b1a:	983ff0ef          	jal	ffffffffc020049c <clock_set_next_event>
ffffffffc0200b1e:	0000d697          	auipc	a3,0xd
ffffffffc0200b22:	9766a683          	lw	a3,-1674(a3) # ffffffffc020d494 <ticks.1>
ffffffffc0200b26:	c28f6737          	lui	a4,0xc28f6
ffffffffc0200b2a:	c297071b          	addiw	a4,a4,-983 # ffffffffc28f5c29 <end+0x26e8739>
ffffffffc0200b2e:	2685                	addiw	a3,a3,1
ffffffffc0200b30:	02d7073b          	mulw	a4,a4,a3
ffffffffc0200b34:	051ec7b7          	lui	a5,0x51ec
ffffffffc0200b38:	8507879b          	addiw	a5,a5,-1968 # 51eb850 <kern_entry-0xffffffffbb0147b0>
ffffffffc0200b3c:	0000d597          	auipc	a1,0xd
ffffffffc0200b40:	94d5ac23          	sw	a3,-1704(a1) # ffffffffc020d494 <ticks.1>
ffffffffc0200b44:	028f66b7          	lui	a3,0x28f6
ffffffffc0200b48:	c2868693          	addi	a3,a3,-984 # 28f5c28 <kern_entry-0xffffffffbd90a3d8>
ffffffffc0200b4c:	9fb9                	addw	a5,a5,a4
ffffffffc0200b4e:	0027d71b          	srliw	a4,a5,0x2
ffffffffc0200b52:	01e7979b          	slliw	a5,a5,0x1e
ffffffffc0200b56:	9fb9                	addw	a5,a5,a4
ffffffffc0200b58:	02f6f963          	bgeu	a3,a5,ffffffffc0200b8a <interrupt_handler+0xc4>
ffffffffc0200b5c:	0000d797          	auipc	a5,0xd
ffffffffc0200b60:	9347a783          	lw	a5,-1740(a5) # ffffffffc020d490 <num.0>
ffffffffc0200b64:	4729                	li	a4,10
ffffffffc0200b66:	00e79863          	bne	a5,a4,ffffffffc0200b76 <interrupt_handler+0xb0>
ffffffffc0200b6a:	4501                	li	a0,0
ffffffffc0200b6c:	4581                	li	a1,0
ffffffffc0200b6e:	4601                	li	a2,0
ffffffffc0200b70:	48a1                	li	a7,8
ffffffffc0200b72:	00000073          	ecall
ffffffffc0200b76:	60a2                	ld	ra,8(sp)
ffffffffc0200b78:	0141                	addi	sp,sp,16
ffffffffc0200b7a:	8082                	ret
ffffffffc0200b7c:	00004517          	auipc	a0,0x4
ffffffffc0200b80:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0204698 <etext+0x80e>
ffffffffc0200b84:	e10ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200b88:	bdf1                	j	ffffffffc0200a64 <print_trapframe>
ffffffffc0200b8a:	06400593          	li	a1,100
ffffffffc0200b8e:	00004517          	auipc	a0,0x4
ffffffffc0200b92:	afa50513          	addi	a0,a0,-1286 # ffffffffc0204688 <etext+0x7fe>
ffffffffc0200b96:	dfeff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200b9a:	0000d797          	auipc	a5,0xd
ffffffffc0200b9e:	8f67a783          	lw	a5,-1802(a5) # ffffffffc020d490 <num.0>
ffffffffc0200ba2:	2785                	addiw	a5,a5,1
ffffffffc0200ba4:	0000d717          	auipc	a4,0xd
ffffffffc0200ba8:	8ef72623          	sw	a5,-1812(a4) # ffffffffc020d490 <num.0>
ffffffffc0200bac:	bf65                	j	ffffffffc0200b64 <interrupt_handler+0x9e>

ffffffffc0200bae <exception_handler>:
ffffffffc0200bae:	11853783          	ld	a5,280(a0)
ffffffffc0200bb2:	473d                	li	a4,15
ffffffffc0200bb4:	0cf76563          	bltu	a4,a5,ffffffffc0200c7e <exception_handler+0xd0>
ffffffffc0200bb8:	00005717          	auipc	a4,0x5
ffffffffc0200bbc:	c2070713          	addi	a4,a4,-992 # ffffffffc02057d8 <commands+0x78>
ffffffffc0200bc0:	078a                	slli	a5,a5,0x2
ffffffffc0200bc2:	97ba                	add	a5,a5,a4
ffffffffc0200bc4:	439c                	lw	a5,0(a5)
ffffffffc0200bc6:	97ba                	add	a5,a5,a4
ffffffffc0200bc8:	8782                	jr	a5
ffffffffc0200bca:	00004517          	auipc	a0,0x4
ffffffffc0200bce:	c6e50513          	addi	a0,a0,-914 # ffffffffc0204838 <etext+0x9ae>
ffffffffc0200bd2:	dc2ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bd6:	00004517          	auipc	a0,0x4
ffffffffc0200bda:	ae250513          	addi	a0,a0,-1310 # ffffffffc02046b8 <etext+0x82e>
ffffffffc0200bde:	db6ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200be2:	00004517          	auipc	a0,0x4
ffffffffc0200be6:	af650513          	addi	a0,a0,-1290 # ffffffffc02046d8 <etext+0x84e>
ffffffffc0200bea:	daaff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bee:	00004517          	auipc	a0,0x4
ffffffffc0200bf2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc02046f8 <etext+0x86e>
ffffffffc0200bf6:	d9eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200bfa:	00004517          	auipc	a0,0x4
ffffffffc0200bfe:	b1650513          	addi	a0,a0,-1258 # ffffffffc0204710 <etext+0x886>
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c06:	00004517          	auipc	a0,0x4
ffffffffc0200c0a:	b1a50513          	addi	a0,a0,-1254 # ffffffffc0204720 <etext+0x896>
ffffffffc0200c0e:	d86ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c12:	00004517          	auipc	a0,0x4
ffffffffc0200c16:	b2e50513          	addi	a0,a0,-1234 # ffffffffc0204740 <etext+0x8b6>
ffffffffc0200c1a:	d7aff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c1e:	00004517          	auipc	a0,0x4
ffffffffc0200c22:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0204758 <etext+0x8ce>
ffffffffc0200c26:	d6eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c2a:	00004517          	auipc	a0,0x4
ffffffffc0200c2e:	b4650513          	addi	a0,a0,-1210 # ffffffffc0204770 <etext+0x8e6>
ffffffffc0200c32:	d62ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c36:	00004517          	auipc	a0,0x4
ffffffffc0200c3a:	b5250513          	addi	a0,a0,-1198 # ffffffffc0204788 <etext+0x8fe>
ffffffffc0200c3e:	d56ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c42:	00004517          	auipc	a0,0x4
ffffffffc0200c46:	b6650513          	addi	a0,a0,-1178 # ffffffffc02047a8 <etext+0x91e>
ffffffffc0200c4a:	d4aff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c4e:	00004517          	auipc	a0,0x4
ffffffffc0200c52:	b7a50513          	addi	a0,a0,-1158 # ffffffffc02047c8 <etext+0x93e>
ffffffffc0200c56:	d3eff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c5a:	00004517          	auipc	a0,0x4
ffffffffc0200c5e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc02047e8 <etext+0x95e>
ffffffffc0200c62:	d32ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c66:	00004517          	auipc	a0,0x4
ffffffffc0200c6a:	ba250513          	addi	a0,a0,-1118 # ffffffffc0204808 <etext+0x97e>
ffffffffc0200c6e:	d26ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c72:	00004517          	auipc	a0,0x4
ffffffffc0200c76:	bae50513          	addi	a0,a0,-1106 # ffffffffc0204820 <etext+0x996>
ffffffffc0200c7a:	d1aff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200c7e:	b3dd                	j	ffffffffc0200a64 <print_trapframe>

ffffffffc0200c80 <trap>:
ffffffffc0200c80:	11853783          	ld	a5,280(a0)
ffffffffc0200c84:	0007c363          	bltz	a5,ffffffffc0200c8a <trap+0xa>
ffffffffc0200c88:	b71d                	j	ffffffffc0200bae <exception_handler>
ffffffffc0200c8a:	bd35                	j	ffffffffc0200ac6 <interrupt_handler>

ffffffffc0200c8c <__alltraps>:
ffffffffc0200c8c:	14011073          	csrw	sscratch,sp
ffffffffc0200c90:	712d                	addi	sp,sp,-288
ffffffffc0200c92:	e406                	sd	ra,8(sp)
ffffffffc0200c94:	ec0e                	sd	gp,24(sp)
ffffffffc0200c96:	f012                	sd	tp,32(sp)
ffffffffc0200c98:	f416                	sd	t0,40(sp)
ffffffffc0200c9a:	f81a                	sd	t1,48(sp)
ffffffffc0200c9c:	fc1e                	sd	t2,56(sp)
ffffffffc0200c9e:	e0a2                	sd	s0,64(sp)
ffffffffc0200ca0:	e4a6                	sd	s1,72(sp)
ffffffffc0200ca2:	e8aa                	sd	a0,80(sp)
ffffffffc0200ca4:	ecae                	sd	a1,88(sp)
ffffffffc0200ca6:	f0b2                	sd	a2,96(sp)
ffffffffc0200ca8:	f4b6                	sd	a3,104(sp)
ffffffffc0200caa:	f8ba                	sd	a4,112(sp)
ffffffffc0200cac:	fcbe                	sd	a5,120(sp)
ffffffffc0200cae:	e142                	sd	a6,128(sp)
ffffffffc0200cb0:	e546                	sd	a7,136(sp)
ffffffffc0200cb2:	e94a                	sd	s2,144(sp)
ffffffffc0200cb4:	ed4e                	sd	s3,152(sp)
ffffffffc0200cb6:	f152                	sd	s4,160(sp)
ffffffffc0200cb8:	f556                	sd	s5,168(sp)
ffffffffc0200cba:	f95a                	sd	s6,176(sp)
ffffffffc0200cbc:	fd5e                	sd	s7,184(sp)
ffffffffc0200cbe:	e1e2                	sd	s8,192(sp)
ffffffffc0200cc0:	e5e6                	sd	s9,200(sp)
ffffffffc0200cc2:	e9ea                	sd	s10,208(sp)
ffffffffc0200cc4:	edee                	sd	s11,216(sp)
ffffffffc0200cc6:	f1f2                	sd	t3,224(sp)
ffffffffc0200cc8:	f5f6                	sd	t4,232(sp)
ffffffffc0200cca:	f9fa                	sd	t5,240(sp)
ffffffffc0200ccc:	fdfe                	sd	t6,248(sp)
ffffffffc0200cce:	14002473          	csrr	s0,sscratch
ffffffffc0200cd2:	100024f3          	csrr	s1,sstatus
ffffffffc0200cd6:	14102973          	csrr	s2,sepc
ffffffffc0200cda:	143029f3          	csrr	s3,stval
ffffffffc0200cde:	14202a73          	csrr	s4,scause
ffffffffc0200ce2:	e822                	sd	s0,16(sp)
ffffffffc0200ce4:	e226                	sd	s1,256(sp)
ffffffffc0200ce6:	e64a                	sd	s2,264(sp)
ffffffffc0200ce8:	ea4e                	sd	s3,272(sp)
ffffffffc0200cea:	ee52                	sd	s4,280(sp)
ffffffffc0200cec:	850a                	mv	a0,sp
ffffffffc0200cee:	f93ff0ef          	jal	ffffffffc0200c80 <trap>

ffffffffc0200cf2 <__trapret>:
ffffffffc0200cf2:	6492                	ld	s1,256(sp)
ffffffffc0200cf4:	6932                	ld	s2,264(sp)
ffffffffc0200cf6:	10049073          	csrw	sstatus,s1
ffffffffc0200cfa:	14191073          	csrw	sepc,s2
ffffffffc0200cfe:	60a2                	ld	ra,8(sp)
ffffffffc0200d00:	61e2                	ld	gp,24(sp)
ffffffffc0200d02:	7202                	ld	tp,32(sp)
ffffffffc0200d04:	72a2                	ld	t0,40(sp)
ffffffffc0200d06:	7342                	ld	t1,48(sp)
ffffffffc0200d08:	73e2                	ld	t2,56(sp)
ffffffffc0200d0a:	6406                	ld	s0,64(sp)
ffffffffc0200d0c:	64a6                	ld	s1,72(sp)
ffffffffc0200d0e:	6546                	ld	a0,80(sp)
ffffffffc0200d10:	65e6                	ld	a1,88(sp)
ffffffffc0200d12:	7606                	ld	a2,96(sp)
ffffffffc0200d14:	76a6                	ld	a3,104(sp)
ffffffffc0200d16:	7746                	ld	a4,112(sp)
ffffffffc0200d18:	77e6                	ld	a5,120(sp)
ffffffffc0200d1a:	680a                	ld	a6,128(sp)
ffffffffc0200d1c:	68aa                	ld	a7,136(sp)
ffffffffc0200d1e:	694a                	ld	s2,144(sp)
ffffffffc0200d20:	69ea                	ld	s3,152(sp)
ffffffffc0200d22:	7a0a                	ld	s4,160(sp)
ffffffffc0200d24:	7aaa                	ld	s5,168(sp)
ffffffffc0200d26:	7b4a                	ld	s6,176(sp)
ffffffffc0200d28:	7bea                	ld	s7,184(sp)
ffffffffc0200d2a:	6c0e                	ld	s8,192(sp)
ffffffffc0200d2c:	6cae                	ld	s9,200(sp)
ffffffffc0200d2e:	6d4e                	ld	s10,208(sp)
ffffffffc0200d30:	6dee                	ld	s11,216(sp)
ffffffffc0200d32:	7e0e                	ld	t3,224(sp)
ffffffffc0200d34:	7eae                	ld	t4,232(sp)
ffffffffc0200d36:	7f4e                	ld	t5,240(sp)
ffffffffc0200d38:	7fee                	ld	t6,248(sp)
ffffffffc0200d3a:	6142                	ld	sp,16(sp)
ffffffffc0200d3c:	10200073          	sret

ffffffffc0200d40 <forkrets>:
ffffffffc0200d40:	812a                	mv	sp,a0
ffffffffc0200d42:	bf45                	j	ffffffffc0200cf2 <__trapret>
ffffffffc0200d44:	0001                	nop

ffffffffc0200d46 <default_init>:
ffffffffc0200d46:	00008797          	auipc	a5,0x8
ffffffffc0200d4a:	6ea78793          	addi	a5,a5,1770 # ffffffffc0209430 <free_area>
ffffffffc0200d4e:	e79c                	sd	a5,8(a5)
ffffffffc0200d50:	e39c                	sd	a5,0(a5)
ffffffffc0200d52:	0007a823          	sw	zero,16(a5)
ffffffffc0200d56:	8082                	ret

ffffffffc0200d58 <default_nr_free_pages>:
ffffffffc0200d58:	00008517          	auipc	a0,0x8
ffffffffc0200d5c:	6e856503          	lwu	a0,1768(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200d60:	8082                	ret

ffffffffc0200d62 <default_check>:
ffffffffc0200d62:	711d                	addi	sp,sp,-96
ffffffffc0200d64:	e0ca                	sd	s2,64(sp)
ffffffffc0200d66:	00008917          	auipc	s2,0x8
ffffffffc0200d6a:	6ca90913          	addi	s2,s2,1738 # ffffffffc0209430 <free_area>
ffffffffc0200d6e:	00893783          	ld	a5,8(s2)
ffffffffc0200d72:	ec86                	sd	ra,88(sp)
ffffffffc0200d74:	e8a2                	sd	s0,80(sp)
ffffffffc0200d76:	e4a6                	sd	s1,72(sp)
ffffffffc0200d78:	fc4e                	sd	s3,56(sp)
ffffffffc0200d7a:	f852                	sd	s4,48(sp)
ffffffffc0200d7c:	f456                	sd	s5,40(sp)
ffffffffc0200d7e:	f05a                	sd	s6,32(sp)
ffffffffc0200d80:	ec5e                	sd	s7,24(sp)
ffffffffc0200d82:	e862                	sd	s8,16(sp)
ffffffffc0200d84:	e466                	sd	s9,8(sp)
ffffffffc0200d86:	2f278763          	beq	a5,s2,ffffffffc0201074 <default_check+0x312>
ffffffffc0200d8a:	4401                	li	s0,0
ffffffffc0200d8c:	4481                	li	s1,0
ffffffffc0200d8e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200d92:	8b09                	andi	a4,a4,2
ffffffffc0200d94:	2e070463          	beqz	a4,ffffffffc020107c <default_check+0x31a>
ffffffffc0200d98:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d9c:	679c                	ld	a5,8(a5)
ffffffffc0200d9e:	2485                	addiw	s1,s1,1
ffffffffc0200da0:	9c39                	addw	s0,s0,a4
ffffffffc0200da2:	ff2796e3          	bne	a5,s2,ffffffffc0200d8e <default_check+0x2c>
ffffffffc0200da6:	89a2                	mv	s3,s0
ffffffffc0200da8:	745000ef          	jal	ffffffffc0201cec <nr_free_pages>
ffffffffc0200dac:	73351863          	bne	a0,s3,ffffffffc02014dc <default_check+0x77a>
ffffffffc0200db0:	4505                	li	a0,1
ffffffffc0200db2:	6c9000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200db6:	8a2a                	mv	s4,a0
ffffffffc0200db8:	46050263          	beqz	a0,ffffffffc020121c <default_check+0x4ba>
ffffffffc0200dbc:	4505                	li	a0,1
ffffffffc0200dbe:	6bd000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200dc2:	89aa                	mv	s3,a0
ffffffffc0200dc4:	72050c63          	beqz	a0,ffffffffc02014fc <default_check+0x79a>
ffffffffc0200dc8:	4505                	li	a0,1
ffffffffc0200dca:	6b1000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200dce:	8aaa                	mv	s5,a0
ffffffffc0200dd0:	4c050663          	beqz	a0,ffffffffc020129c <default_check+0x53a>
ffffffffc0200dd4:	40aa07b3          	sub	a5,s4,a0
ffffffffc0200dd8:	40a98733          	sub	a4,s3,a0
ffffffffc0200ddc:	0017b793          	seqz	a5,a5
ffffffffc0200de0:	00173713          	seqz	a4,a4
ffffffffc0200de4:	8fd9                	or	a5,a5,a4
ffffffffc0200de6:	30079b63          	bnez	a5,ffffffffc02010fc <default_check+0x39a>
ffffffffc0200dea:	313a0963          	beq	s4,s3,ffffffffc02010fc <default_check+0x39a>
ffffffffc0200dee:	000a2783          	lw	a5,0(s4)
ffffffffc0200df2:	2a079563          	bnez	a5,ffffffffc020109c <default_check+0x33a>
ffffffffc0200df6:	0009a783          	lw	a5,0(s3)
ffffffffc0200dfa:	2a079163          	bnez	a5,ffffffffc020109c <default_check+0x33a>
ffffffffc0200dfe:	411c                	lw	a5,0(a0)
ffffffffc0200e00:	28079e63          	bnez	a5,ffffffffc020109c <default_check+0x33a>
ffffffffc0200e04:	0000c797          	auipc	a5,0xc
ffffffffc0200e08:	6c47b783          	ld	a5,1732(a5) # ffffffffc020d4c8 <pages>
ffffffffc0200e0c:	00005617          	auipc	a2,0x5
ffffffffc0200e10:	bd463603          	ld	a2,-1068(a2) # ffffffffc02059e0 <nbase>
ffffffffc0200e14:	0000c697          	auipc	a3,0xc
ffffffffc0200e18:	6ac6b683          	ld	a3,1708(a3) # ffffffffc020d4c0 <npage>
ffffffffc0200e1c:	40fa0733          	sub	a4,s4,a5
ffffffffc0200e20:	8719                	srai	a4,a4,0x6
ffffffffc0200e22:	9732                	add	a4,a4,a2
ffffffffc0200e24:	0732                	slli	a4,a4,0xc
ffffffffc0200e26:	06b2                	slli	a3,a3,0xc
ffffffffc0200e28:	2ad77a63          	bgeu	a4,a3,ffffffffc02010dc <default_check+0x37a>
ffffffffc0200e2c:	40f98733          	sub	a4,s3,a5
ffffffffc0200e30:	8719                	srai	a4,a4,0x6
ffffffffc0200e32:	9732                	add	a4,a4,a2
ffffffffc0200e34:	0732                	slli	a4,a4,0xc
ffffffffc0200e36:	4ed77363          	bgeu	a4,a3,ffffffffc020131c <default_check+0x5ba>
ffffffffc0200e3a:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e3e:	8799                	srai	a5,a5,0x6
ffffffffc0200e40:	97b2                	add	a5,a5,a2
ffffffffc0200e42:	07b2                	slli	a5,a5,0xc
ffffffffc0200e44:	32d7fc63          	bgeu	a5,a3,ffffffffc020117c <default_check+0x41a>
ffffffffc0200e48:	4505                	li	a0,1
ffffffffc0200e4a:	00093c03          	ld	s8,0(s2)
ffffffffc0200e4e:	00893b83          	ld	s7,8(s2)
ffffffffc0200e52:	00008b17          	auipc	s6,0x8
ffffffffc0200e56:	5eeb2b03          	lw	s6,1518(s6) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200e5a:	01293023          	sd	s2,0(s2)
ffffffffc0200e5e:	01293423          	sd	s2,8(s2)
ffffffffc0200e62:	00008797          	auipc	a5,0x8
ffffffffc0200e66:	5c07af23          	sw	zero,1502(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200e6a:	611000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200e6e:	2e051763          	bnez	a0,ffffffffc020115c <default_check+0x3fa>
ffffffffc0200e72:	8552                	mv	a0,s4
ffffffffc0200e74:	4585                	li	a1,1
ffffffffc0200e76:	63f000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200e7a:	854e                	mv	a0,s3
ffffffffc0200e7c:	4585                	li	a1,1
ffffffffc0200e7e:	637000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200e82:	8556                	mv	a0,s5
ffffffffc0200e84:	4585                	li	a1,1
ffffffffc0200e86:	62f000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200e8a:	00008717          	auipc	a4,0x8
ffffffffc0200e8e:	5b672703          	lw	a4,1462(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200e92:	478d                	li	a5,3
ffffffffc0200e94:	2af71463          	bne	a4,a5,ffffffffc020113c <default_check+0x3da>
ffffffffc0200e98:	4505                	li	a0,1
ffffffffc0200e9a:	5e1000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200e9e:	89aa                	mv	s3,a0
ffffffffc0200ea0:	26050e63          	beqz	a0,ffffffffc020111c <default_check+0x3ba>
ffffffffc0200ea4:	4505                	li	a0,1
ffffffffc0200ea6:	5d5000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200eaa:	8aaa                	mv	s5,a0
ffffffffc0200eac:	3c050863          	beqz	a0,ffffffffc020127c <default_check+0x51a>
ffffffffc0200eb0:	4505                	li	a0,1
ffffffffc0200eb2:	5c9000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200eb6:	8a2a                	mv	s4,a0
ffffffffc0200eb8:	3a050263          	beqz	a0,ffffffffc020125c <default_check+0x4fa>
ffffffffc0200ebc:	4505                	li	a0,1
ffffffffc0200ebe:	5bd000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200ec2:	36051d63          	bnez	a0,ffffffffc020123c <default_check+0x4da>
ffffffffc0200ec6:	4585                	li	a1,1
ffffffffc0200ec8:	854e                	mv	a0,s3
ffffffffc0200eca:	5eb000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200ece:	00893783          	ld	a5,8(s2)
ffffffffc0200ed2:	1f278563          	beq	a5,s2,ffffffffc02010bc <default_check+0x35a>
ffffffffc0200ed6:	4505                	li	a0,1
ffffffffc0200ed8:	5a3000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200edc:	8caa                	mv	s9,a0
ffffffffc0200ede:	30a99f63          	bne	s3,a0,ffffffffc02011fc <default_check+0x49a>
ffffffffc0200ee2:	4505                	li	a0,1
ffffffffc0200ee4:	597000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200ee8:	2e051a63          	bnez	a0,ffffffffc02011dc <default_check+0x47a>
ffffffffc0200eec:	00008797          	auipc	a5,0x8
ffffffffc0200ef0:	5547a783          	lw	a5,1364(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ef4:	2c079463          	bnez	a5,ffffffffc02011bc <default_check+0x45a>
ffffffffc0200ef8:	8566                	mv	a0,s9
ffffffffc0200efa:	4585                	li	a1,1
ffffffffc0200efc:	01893023          	sd	s8,0(s2)
ffffffffc0200f00:	01793423          	sd	s7,8(s2)
ffffffffc0200f04:	01692823          	sw	s6,16(s2)
ffffffffc0200f08:	5ad000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200f0c:	8556                	mv	a0,s5
ffffffffc0200f0e:	4585                	li	a1,1
ffffffffc0200f10:	5a5000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200f14:	8552                	mv	a0,s4
ffffffffc0200f16:	4585                	li	a1,1
ffffffffc0200f18:	59d000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200f1c:	4515                	li	a0,5
ffffffffc0200f1e:	55d000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200f22:	89aa                	mv	s3,a0
ffffffffc0200f24:	26050c63          	beqz	a0,ffffffffc020119c <default_check+0x43a>
ffffffffc0200f28:	651c                	ld	a5,8(a0)
ffffffffc0200f2a:	8385                	srli	a5,a5,0x1
ffffffffc0200f2c:	8b85                	andi	a5,a5,1
ffffffffc0200f2e:	54079763          	bnez	a5,ffffffffc020147c <default_check+0x71a>
ffffffffc0200f32:	4505                	li	a0,1
ffffffffc0200f34:	00093b83          	ld	s7,0(s2)
ffffffffc0200f38:	00893b03          	ld	s6,8(s2)
ffffffffc0200f3c:	01293023          	sd	s2,0(s2)
ffffffffc0200f40:	01293423          	sd	s2,8(s2)
ffffffffc0200f44:	537000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200f48:	50051a63          	bnez	a0,ffffffffc020145c <default_check+0x6fa>
ffffffffc0200f4c:	08098a13          	addi	s4,s3,128
ffffffffc0200f50:	8552                	mv	a0,s4
ffffffffc0200f52:	458d                	li	a1,3
ffffffffc0200f54:	00008c17          	auipc	s8,0x8
ffffffffc0200f58:	4ecc2c03          	lw	s8,1260(s8) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200f5c:	00008797          	auipc	a5,0x8
ffffffffc0200f60:	4e07a223          	sw	zero,1252(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200f64:	551000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200f68:	4511                	li	a0,4
ffffffffc0200f6a:	511000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200f6e:	4c051763          	bnez	a0,ffffffffc020143c <default_check+0x6da>
ffffffffc0200f72:	0889b783          	ld	a5,136(s3)
ffffffffc0200f76:	8385                	srli	a5,a5,0x1
ffffffffc0200f78:	8b85                	andi	a5,a5,1
ffffffffc0200f7a:	4a078163          	beqz	a5,ffffffffc020141c <default_check+0x6ba>
ffffffffc0200f7e:	0909a503          	lw	a0,144(s3)
ffffffffc0200f82:	478d                	li	a5,3
ffffffffc0200f84:	48f51c63          	bne	a0,a5,ffffffffc020141c <default_check+0x6ba>
ffffffffc0200f88:	4f3000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200f8c:	8aaa                	mv	s5,a0
ffffffffc0200f8e:	46050763          	beqz	a0,ffffffffc02013fc <default_check+0x69a>
ffffffffc0200f92:	4505                	li	a0,1
ffffffffc0200f94:	4e7000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200f98:	44051263          	bnez	a0,ffffffffc02013dc <default_check+0x67a>
ffffffffc0200f9c:	435a1063          	bne	s4,s5,ffffffffc02013bc <default_check+0x65a>
ffffffffc0200fa0:	4585                	li	a1,1
ffffffffc0200fa2:	854e                	mv	a0,s3
ffffffffc0200fa4:	511000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200fa8:	8552                	mv	a0,s4
ffffffffc0200faa:	458d                	li	a1,3
ffffffffc0200fac:	509000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200fb0:	0089b783          	ld	a5,8(s3)
ffffffffc0200fb4:	8385                	srli	a5,a5,0x1
ffffffffc0200fb6:	8b85                	andi	a5,a5,1
ffffffffc0200fb8:	3e078263          	beqz	a5,ffffffffc020139c <default_check+0x63a>
ffffffffc0200fbc:	0109aa83          	lw	s5,16(s3)
ffffffffc0200fc0:	4785                	li	a5,1
ffffffffc0200fc2:	3cfa9d63          	bne	s5,a5,ffffffffc020139c <default_check+0x63a>
ffffffffc0200fc6:	008a3783          	ld	a5,8(s4)
ffffffffc0200fca:	8385                	srli	a5,a5,0x1
ffffffffc0200fcc:	8b85                	andi	a5,a5,1
ffffffffc0200fce:	3a078763          	beqz	a5,ffffffffc020137c <default_check+0x61a>
ffffffffc0200fd2:	010a2703          	lw	a4,16(s4)
ffffffffc0200fd6:	478d                	li	a5,3
ffffffffc0200fd8:	3af71263          	bne	a4,a5,ffffffffc020137c <default_check+0x61a>
ffffffffc0200fdc:	8556                	mv	a0,s5
ffffffffc0200fde:	49d000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200fe2:	36a99d63          	bne	s3,a0,ffffffffc020135c <default_check+0x5fa>
ffffffffc0200fe6:	85d6                	mv	a1,s5
ffffffffc0200fe8:	4cd000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200fec:	4509                	li	a0,2
ffffffffc0200fee:	48d000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0200ff2:	34aa1563          	bne	s4,a0,ffffffffc020133c <default_check+0x5da>
ffffffffc0200ff6:	4589                	li	a1,2
ffffffffc0200ff8:	4bd000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0200ffc:	04098513          	addi	a0,s3,64
ffffffffc0201000:	85d6                	mv	a1,s5
ffffffffc0201002:	4b3000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0201006:	4515                	li	a0,5
ffffffffc0201008:	473000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc020100c:	89aa                	mv	s3,a0
ffffffffc020100e:	48050763          	beqz	a0,ffffffffc020149c <default_check+0x73a>
ffffffffc0201012:	8556                	mv	a0,s5
ffffffffc0201014:	467000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0201018:	2e051263          	bnez	a0,ffffffffc02012fc <default_check+0x59a>
ffffffffc020101c:	00008797          	auipc	a5,0x8
ffffffffc0201020:	4247a783          	lw	a5,1060(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201024:	2a079c63          	bnez	a5,ffffffffc02012dc <default_check+0x57a>
ffffffffc0201028:	854e                	mv	a0,s3
ffffffffc020102a:	4595                	li	a1,5
ffffffffc020102c:	01892823          	sw	s8,16(s2)
ffffffffc0201030:	01793023          	sd	s7,0(s2)
ffffffffc0201034:	01693423          	sd	s6,8(s2)
ffffffffc0201038:	47d000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc020103c:	00893783          	ld	a5,8(s2)
ffffffffc0201040:	01278963          	beq	a5,s2,ffffffffc0201052 <default_check+0x2f0>
ffffffffc0201044:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201048:	679c                	ld	a5,8(a5)
ffffffffc020104a:	34fd                	addiw	s1,s1,-1
ffffffffc020104c:	9c19                	subw	s0,s0,a4
ffffffffc020104e:	ff279be3          	bne	a5,s2,ffffffffc0201044 <default_check+0x2e2>
ffffffffc0201052:	26049563          	bnez	s1,ffffffffc02012bc <default_check+0x55a>
ffffffffc0201056:	46041363          	bnez	s0,ffffffffc02014bc <default_check+0x75a>
ffffffffc020105a:	60e6                	ld	ra,88(sp)
ffffffffc020105c:	6446                	ld	s0,80(sp)
ffffffffc020105e:	64a6                	ld	s1,72(sp)
ffffffffc0201060:	6906                	ld	s2,64(sp)
ffffffffc0201062:	79e2                	ld	s3,56(sp)
ffffffffc0201064:	7a42                	ld	s4,48(sp)
ffffffffc0201066:	7aa2                	ld	s5,40(sp)
ffffffffc0201068:	7b02                	ld	s6,32(sp)
ffffffffc020106a:	6be2                	ld	s7,24(sp)
ffffffffc020106c:	6c42                	ld	s8,16(sp)
ffffffffc020106e:	6ca2                	ld	s9,8(sp)
ffffffffc0201070:	6125                	addi	sp,sp,96
ffffffffc0201072:	8082                	ret
ffffffffc0201074:	4981                	li	s3,0
ffffffffc0201076:	4401                	li	s0,0
ffffffffc0201078:	4481                	li	s1,0
ffffffffc020107a:	b33d                	j	ffffffffc0200da8 <default_check+0x46>
ffffffffc020107c:	00003697          	auipc	a3,0x3
ffffffffc0201080:	7d468693          	addi	a3,a3,2004 # ffffffffc0204850 <etext+0x9c6>
ffffffffc0201084:	00003617          	auipc	a2,0x3
ffffffffc0201088:	7dc60613          	addi	a2,a2,2012 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020108c:	0f000593          	li	a1,240
ffffffffc0201090:	00003517          	auipc	a0,0x3
ffffffffc0201094:	7e850513          	addi	a0,a0,2024 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201098:	b6eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020109c:	00004697          	auipc	a3,0x4
ffffffffc02010a0:	89c68693          	addi	a3,a3,-1892 # ffffffffc0204938 <etext+0xaae>
ffffffffc02010a4:	00003617          	auipc	a2,0x3
ffffffffc02010a8:	7bc60613          	addi	a2,a2,1980 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02010ac:	0be00593          	li	a1,190
ffffffffc02010b0:	00003517          	auipc	a0,0x3
ffffffffc02010b4:	7c850513          	addi	a0,a0,1992 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02010b8:	b4eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02010bc:	00004697          	auipc	a3,0x4
ffffffffc02010c0:	94468693          	addi	a3,a3,-1724 # ffffffffc0204a00 <etext+0xb76>
ffffffffc02010c4:	00003617          	auipc	a2,0x3
ffffffffc02010c8:	79c60613          	addi	a2,a2,1948 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02010cc:	0d900593          	li	a1,217
ffffffffc02010d0:	00003517          	auipc	a0,0x3
ffffffffc02010d4:	7a850513          	addi	a0,a0,1960 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02010d8:	b2eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02010dc:	00004697          	auipc	a3,0x4
ffffffffc02010e0:	89c68693          	addi	a3,a3,-1892 # ffffffffc0204978 <etext+0xaee>
ffffffffc02010e4:	00003617          	auipc	a2,0x3
ffffffffc02010e8:	77c60613          	addi	a2,a2,1916 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02010ec:	0c000593          	li	a1,192
ffffffffc02010f0:	00003517          	auipc	a0,0x3
ffffffffc02010f4:	78850513          	addi	a0,a0,1928 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02010f8:	b0eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02010fc:	00004697          	auipc	a3,0x4
ffffffffc0201100:	81468693          	addi	a3,a3,-2028 # ffffffffc0204910 <etext+0xa86>
ffffffffc0201104:	00003617          	auipc	a2,0x3
ffffffffc0201108:	75c60613          	addi	a2,a2,1884 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020110c:	0bd00593          	li	a1,189
ffffffffc0201110:	00003517          	auipc	a0,0x3
ffffffffc0201114:	76850513          	addi	a0,a0,1896 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201118:	aeeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020111c:	00003697          	auipc	a3,0x3
ffffffffc0201120:	79468693          	addi	a3,a3,1940 # ffffffffc02048b0 <etext+0xa26>
ffffffffc0201124:	00003617          	auipc	a2,0x3
ffffffffc0201128:	73c60613          	addi	a2,a2,1852 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020112c:	0d200593          	li	a1,210
ffffffffc0201130:	00003517          	auipc	a0,0x3
ffffffffc0201134:	74850513          	addi	a0,a0,1864 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201138:	aceff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020113c:	00004697          	auipc	a3,0x4
ffffffffc0201140:	8b468693          	addi	a3,a3,-1868 # ffffffffc02049f0 <etext+0xb66>
ffffffffc0201144:	00003617          	auipc	a2,0x3
ffffffffc0201148:	71c60613          	addi	a2,a2,1820 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020114c:	0d000593          	li	a1,208
ffffffffc0201150:	00003517          	auipc	a0,0x3
ffffffffc0201154:	72850513          	addi	a0,a0,1832 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201158:	aaeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020115c:	00004697          	auipc	a3,0x4
ffffffffc0201160:	87c68693          	addi	a3,a3,-1924 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc0201164:	00003617          	auipc	a2,0x3
ffffffffc0201168:	6fc60613          	addi	a2,a2,1788 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020116c:	0cb00593          	li	a1,203
ffffffffc0201170:	00003517          	auipc	a0,0x3
ffffffffc0201174:	70850513          	addi	a0,a0,1800 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201178:	a8eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020117c:	00004697          	auipc	a3,0x4
ffffffffc0201180:	83c68693          	addi	a3,a3,-1988 # ffffffffc02049b8 <etext+0xb2e>
ffffffffc0201184:	00003617          	auipc	a2,0x3
ffffffffc0201188:	6dc60613          	addi	a2,a2,1756 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020118c:	0c200593          	li	a1,194
ffffffffc0201190:	00003517          	auipc	a0,0x3
ffffffffc0201194:	6e850513          	addi	a0,a0,1768 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201198:	a6eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020119c:	00004697          	auipc	a3,0x4
ffffffffc02011a0:	8ac68693          	addi	a3,a3,-1876 # ffffffffc0204a48 <etext+0xbbe>
ffffffffc02011a4:	00003617          	auipc	a2,0x3
ffffffffc02011a8:	6bc60613          	addi	a2,a2,1724 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02011ac:	0f800593          	li	a1,248
ffffffffc02011b0:	00003517          	auipc	a0,0x3
ffffffffc02011b4:	6c850513          	addi	a0,a0,1736 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02011b8:	a4eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02011bc:	00004697          	auipc	a3,0x4
ffffffffc02011c0:	87c68693          	addi	a3,a3,-1924 # ffffffffc0204a38 <etext+0xbae>
ffffffffc02011c4:	00003617          	auipc	a2,0x3
ffffffffc02011c8:	69c60613          	addi	a2,a2,1692 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02011cc:	0df00593          	li	a1,223
ffffffffc02011d0:	00003517          	auipc	a0,0x3
ffffffffc02011d4:	6a850513          	addi	a0,a0,1704 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02011d8:	a2eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02011dc:	00003697          	auipc	a3,0x3
ffffffffc02011e0:	7fc68693          	addi	a3,a3,2044 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc02011e4:	00003617          	auipc	a2,0x3
ffffffffc02011e8:	67c60613          	addi	a2,a2,1660 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02011ec:	0dd00593          	li	a1,221
ffffffffc02011f0:	00003517          	auipc	a0,0x3
ffffffffc02011f4:	68850513          	addi	a0,a0,1672 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02011f8:	a0eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02011fc:	00004697          	auipc	a3,0x4
ffffffffc0201200:	81c68693          	addi	a3,a3,-2020 # ffffffffc0204a18 <etext+0xb8e>
ffffffffc0201204:	00003617          	auipc	a2,0x3
ffffffffc0201208:	65c60613          	addi	a2,a2,1628 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020120c:	0dc00593          	li	a1,220
ffffffffc0201210:	00003517          	auipc	a0,0x3
ffffffffc0201214:	66850513          	addi	a0,a0,1640 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201218:	9eeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020121c:	00003697          	auipc	a3,0x3
ffffffffc0201220:	69468693          	addi	a3,a3,1684 # ffffffffc02048b0 <etext+0xa26>
ffffffffc0201224:	00003617          	auipc	a2,0x3
ffffffffc0201228:	63c60613          	addi	a2,a2,1596 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020122c:	0b900593          	li	a1,185
ffffffffc0201230:	00003517          	auipc	a0,0x3
ffffffffc0201234:	64850513          	addi	a0,a0,1608 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201238:	9ceff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020123c:	00003697          	auipc	a3,0x3
ffffffffc0201240:	79c68693          	addi	a3,a3,1948 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc0201244:	00003617          	auipc	a2,0x3
ffffffffc0201248:	61c60613          	addi	a2,a2,1564 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020124c:	0d600593          	li	a1,214
ffffffffc0201250:	00003517          	auipc	a0,0x3
ffffffffc0201254:	62850513          	addi	a0,a0,1576 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201258:	9aeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020125c:	00003697          	auipc	a3,0x3
ffffffffc0201260:	69468693          	addi	a3,a3,1684 # ffffffffc02048f0 <etext+0xa66>
ffffffffc0201264:	00003617          	auipc	a2,0x3
ffffffffc0201268:	5fc60613          	addi	a2,a2,1532 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020126c:	0d400593          	li	a1,212
ffffffffc0201270:	00003517          	auipc	a0,0x3
ffffffffc0201274:	60850513          	addi	a0,a0,1544 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201278:	98eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020127c:	00003697          	auipc	a3,0x3
ffffffffc0201280:	65468693          	addi	a3,a3,1620 # ffffffffc02048d0 <etext+0xa46>
ffffffffc0201284:	00003617          	auipc	a2,0x3
ffffffffc0201288:	5dc60613          	addi	a2,a2,1500 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020128c:	0d300593          	li	a1,211
ffffffffc0201290:	00003517          	auipc	a0,0x3
ffffffffc0201294:	5e850513          	addi	a0,a0,1512 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201298:	96eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020129c:	00003697          	auipc	a3,0x3
ffffffffc02012a0:	65468693          	addi	a3,a3,1620 # ffffffffc02048f0 <etext+0xa66>
ffffffffc02012a4:	00003617          	auipc	a2,0x3
ffffffffc02012a8:	5bc60613          	addi	a2,a2,1468 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02012ac:	0bb00593          	li	a1,187
ffffffffc02012b0:	00003517          	auipc	a0,0x3
ffffffffc02012b4:	5c850513          	addi	a0,a0,1480 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02012b8:	94eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02012bc:	00004697          	auipc	a3,0x4
ffffffffc02012c0:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0204b98 <etext+0xd0e>
ffffffffc02012c4:	00003617          	auipc	a2,0x3
ffffffffc02012c8:	59c60613          	addi	a2,a2,1436 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02012cc:	12500593          	li	a1,293
ffffffffc02012d0:	00003517          	auipc	a0,0x3
ffffffffc02012d4:	5a850513          	addi	a0,a0,1448 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02012d8:	92eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02012dc:	00003697          	auipc	a3,0x3
ffffffffc02012e0:	75c68693          	addi	a3,a3,1884 # ffffffffc0204a38 <etext+0xbae>
ffffffffc02012e4:	00003617          	auipc	a2,0x3
ffffffffc02012e8:	57c60613          	addi	a2,a2,1404 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02012ec:	11a00593          	li	a1,282
ffffffffc02012f0:	00003517          	auipc	a0,0x3
ffffffffc02012f4:	58850513          	addi	a0,a0,1416 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02012f8:	90eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02012fc:	00003697          	auipc	a3,0x3
ffffffffc0201300:	6dc68693          	addi	a3,a3,1756 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc0201304:	00003617          	auipc	a2,0x3
ffffffffc0201308:	55c60613          	addi	a2,a2,1372 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020130c:	11800593          	li	a1,280
ffffffffc0201310:	00003517          	auipc	a0,0x3
ffffffffc0201314:	56850513          	addi	a0,a0,1384 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201318:	8eeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020131c:	00003697          	auipc	a3,0x3
ffffffffc0201320:	67c68693          	addi	a3,a3,1660 # ffffffffc0204998 <etext+0xb0e>
ffffffffc0201324:	00003617          	auipc	a2,0x3
ffffffffc0201328:	53c60613          	addi	a2,a2,1340 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020132c:	0c100593          	li	a1,193
ffffffffc0201330:	00003517          	auipc	a0,0x3
ffffffffc0201334:	54850513          	addi	a0,a0,1352 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201338:	8ceff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020133c:	00004697          	auipc	a3,0x4
ffffffffc0201340:	81c68693          	addi	a3,a3,-2020 # ffffffffc0204b58 <etext+0xcce>
ffffffffc0201344:	00003617          	auipc	a2,0x3
ffffffffc0201348:	51c60613          	addi	a2,a2,1308 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020134c:	11200593          	li	a1,274
ffffffffc0201350:	00003517          	auipc	a0,0x3
ffffffffc0201354:	52850513          	addi	a0,a0,1320 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201358:	8aeff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020135c:	00003697          	auipc	a3,0x3
ffffffffc0201360:	7dc68693          	addi	a3,a3,2012 # ffffffffc0204b38 <etext+0xcae>
ffffffffc0201364:	00003617          	auipc	a2,0x3
ffffffffc0201368:	4fc60613          	addi	a2,a2,1276 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020136c:	11000593          	li	a1,272
ffffffffc0201370:	00003517          	auipc	a0,0x3
ffffffffc0201374:	50850513          	addi	a0,a0,1288 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201378:	88eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020137c:	00003697          	auipc	a3,0x3
ffffffffc0201380:	79468693          	addi	a3,a3,1940 # ffffffffc0204b10 <etext+0xc86>
ffffffffc0201384:	00003617          	auipc	a2,0x3
ffffffffc0201388:	4dc60613          	addi	a2,a2,1244 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020138c:	10e00593          	li	a1,270
ffffffffc0201390:	00003517          	auipc	a0,0x3
ffffffffc0201394:	4e850513          	addi	a0,a0,1256 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201398:	86eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020139c:	00003697          	auipc	a3,0x3
ffffffffc02013a0:	74c68693          	addi	a3,a3,1868 # ffffffffc0204ae8 <etext+0xc5e>
ffffffffc02013a4:	00003617          	auipc	a2,0x3
ffffffffc02013a8:	4bc60613          	addi	a2,a2,1212 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02013ac:	10d00593          	li	a1,269
ffffffffc02013b0:	00003517          	auipc	a0,0x3
ffffffffc02013b4:	4c850513          	addi	a0,a0,1224 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02013b8:	84eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02013bc:	00003697          	auipc	a3,0x3
ffffffffc02013c0:	71c68693          	addi	a3,a3,1820 # ffffffffc0204ad8 <etext+0xc4e>
ffffffffc02013c4:	00003617          	auipc	a2,0x3
ffffffffc02013c8:	49c60613          	addi	a2,a2,1180 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02013cc:	10800593          	li	a1,264
ffffffffc02013d0:	00003517          	auipc	a0,0x3
ffffffffc02013d4:	4a850513          	addi	a0,a0,1192 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02013d8:	82eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02013dc:	00003697          	auipc	a3,0x3
ffffffffc02013e0:	5fc68693          	addi	a3,a3,1532 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc02013e4:	00003617          	auipc	a2,0x3
ffffffffc02013e8:	47c60613          	addi	a2,a2,1148 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02013ec:	10700593          	li	a1,263
ffffffffc02013f0:	00003517          	auipc	a0,0x3
ffffffffc02013f4:	48850513          	addi	a0,a0,1160 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02013f8:	80eff0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02013fc:	00003697          	auipc	a3,0x3
ffffffffc0201400:	6bc68693          	addi	a3,a3,1724 # ffffffffc0204ab8 <etext+0xc2e>
ffffffffc0201404:	00003617          	auipc	a2,0x3
ffffffffc0201408:	45c60613          	addi	a2,a2,1116 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020140c:	10600593          	li	a1,262
ffffffffc0201410:	00003517          	auipc	a0,0x3
ffffffffc0201414:	46850513          	addi	a0,a0,1128 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201418:	feffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020141c:	00003697          	auipc	a3,0x3
ffffffffc0201420:	66c68693          	addi	a3,a3,1644 # ffffffffc0204a88 <etext+0xbfe>
ffffffffc0201424:	00003617          	auipc	a2,0x3
ffffffffc0201428:	43c60613          	addi	a2,a2,1084 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020142c:	10500593          	li	a1,261
ffffffffc0201430:	00003517          	auipc	a0,0x3
ffffffffc0201434:	44850513          	addi	a0,a0,1096 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201438:	fcffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020143c:	00003697          	auipc	a3,0x3
ffffffffc0201440:	63468693          	addi	a3,a3,1588 # ffffffffc0204a70 <etext+0xbe6>
ffffffffc0201444:	00003617          	auipc	a2,0x3
ffffffffc0201448:	41c60613          	addi	a2,a2,1052 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020144c:	10400593          	li	a1,260
ffffffffc0201450:	00003517          	auipc	a0,0x3
ffffffffc0201454:	42850513          	addi	a0,a0,1064 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201458:	faffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020145c:	00003697          	auipc	a3,0x3
ffffffffc0201460:	57c68693          	addi	a3,a3,1404 # ffffffffc02049d8 <etext+0xb4e>
ffffffffc0201464:	00003617          	auipc	a2,0x3
ffffffffc0201468:	3fc60613          	addi	a2,a2,1020 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020146c:	0fe00593          	li	a1,254
ffffffffc0201470:	00003517          	auipc	a0,0x3
ffffffffc0201474:	40850513          	addi	a0,a0,1032 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201478:	f8ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020147c:	00003697          	auipc	a3,0x3
ffffffffc0201480:	5dc68693          	addi	a3,a3,1500 # ffffffffc0204a58 <etext+0xbce>
ffffffffc0201484:	00003617          	auipc	a2,0x3
ffffffffc0201488:	3dc60613          	addi	a2,a2,988 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020148c:	0f900593          	li	a1,249
ffffffffc0201490:	00003517          	auipc	a0,0x3
ffffffffc0201494:	3e850513          	addi	a0,a0,1000 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201498:	f6ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020149c:	00003697          	auipc	a3,0x3
ffffffffc02014a0:	6dc68693          	addi	a3,a3,1756 # ffffffffc0204b78 <etext+0xcee>
ffffffffc02014a4:	00003617          	auipc	a2,0x3
ffffffffc02014a8:	3bc60613          	addi	a2,a2,956 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02014ac:	11700593          	li	a1,279
ffffffffc02014b0:	00003517          	auipc	a0,0x3
ffffffffc02014b4:	3c850513          	addi	a0,a0,968 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02014b8:	f4ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02014bc:	00003697          	auipc	a3,0x3
ffffffffc02014c0:	6ec68693          	addi	a3,a3,1772 # ffffffffc0204ba8 <etext+0xd1e>
ffffffffc02014c4:	00003617          	auipc	a2,0x3
ffffffffc02014c8:	39c60613          	addi	a2,a2,924 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02014cc:	12600593          	li	a1,294
ffffffffc02014d0:	00003517          	auipc	a0,0x3
ffffffffc02014d4:	3a850513          	addi	a0,a0,936 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02014d8:	f2ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02014dc:	00003697          	auipc	a3,0x3
ffffffffc02014e0:	3b468693          	addi	a3,a3,948 # ffffffffc0204890 <etext+0xa06>
ffffffffc02014e4:	00003617          	auipc	a2,0x3
ffffffffc02014e8:	37c60613          	addi	a2,a2,892 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02014ec:	0f300593          	li	a1,243
ffffffffc02014f0:	00003517          	auipc	a0,0x3
ffffffffc02014f4:	38850513          	addi	a0,a0,904 # ffffffffc0204878 <etext+0x9ee>
ffffffffc02014f8:	f0ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02014fc:	00003697          	auipc	a3,0x3
ffffffffc0201500:	3d468693          	addi	a3,a3,980 # ffffffffc02048d0 <etext+0xa46>
ffffffffc0201504:	00003617          	auipc	a2,0x3
ffffffffc0201508:	35c60613          	addi	a2,a2,860 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020150c:	0ba00593          	li	a1,186
ffffffffc0201510:	00003517          	auipc	a0,0x3
ffffffffc0201514:	36850513          	addi	a0,a0,872 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201518:	eeffe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020151c <default_free_pages>:
ffffffffc020151c:	1141                	addi	sp,sp,-16
ffffffffc020151e:	e406                	sd	ra,8(sp)
ffffffffc0201520:	14058663          	beqz	a1,ffffffffc020166c <default_free_pages+0x150>
ffffffffc0201524:	00659713          	slli	a4,a1,0x6
ffffffffc0201528:	00e506b3          	add	a3,a0,a4
ffffffffc020152c:	87aa                	mv	a5,a0
ffffffffc020152e:	c30d                	beqz	a4,ffffffffc0201550 <default_free_pages+0x34>
ffffffffc0201530:	6798                	ld	a4,8(a5)
ffffffffc0201532:	8b05                	andi	a4,a4,1
ffffffffc0201534:	10071c63          	bnez	a4,ffffffffc020164c <default_free_pages+0x130>
ffffffffc0201538:	6798                	ld	a4,8(a5)
ffffffffc020153a:	8b09                	andi	a4,a4,2
ffffffffc020153c:	10071863          	bnez	a4,ffffffffc020164c <default_free_pages+0x130>
ffffffffc0201540:	0007b423          	sd	zero,8(a5)
ffffffffc0201544:	0007a023          	sw	zero,0(a5)
ffffffffc0201548:	04078793          	addi	a5,a5,64
ffffffffc020154c:	fed792e3          	bne	a5,a3,ffffffffc0201530 <default_free_pages+0x14>
ffffffffc0201550:	c90c                	sw	a1,16(a0)
ffffffffc0201552:	00850893          	addi	a7,a0,8
ffffffffc0201556:	4789                	li	a5,2
ffffffffc0201558:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc020155c:	00008717          	auipc	a4,0x8
ffffffffc0201560:	ee472703          	lw	a4,-284(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201564:	00008697          	auipc	a3,0x8
ffffffffc0201568:	ecc68693          	addi	a3,a3,-308 # ffffffffc0209430 <free_area>
ffffffffc020156c:	669c                	ld	a5,8(a3)
ffffffffc020156e:	9f2d                	addw	a4,a4,a1
ffffffffc0201570:	ca98                	sw	a4,16(a3)
ffffffffc0201572:	0ad78163          	beq	a5,a3,ffffffffc0201614 <default_free_pages+0xf8>
ffffffffc0201576:	fe878713          	addi	a4,a5,-24
ffffffffc020157a:	4581                	li	a1,0
ffffffffc020157c:	01850613          	addi	a2,a0,24
ffffffffc0201580:	00e56a63          	bltu	a0,a4,ffffffffc0201594 <default_free_pages+0x78>
ffffffffc0201584:	6798                	ld	a4,8(a5)
ffffffffc0201586:	04d70c63          	beq	a4,a3,ffffffffc02015de <default_free_pages+0xc2>
ffffffffc020158a:	87ba                	mv	a5,a4
ffffffffc020158c:	fe878713          	addi	a4,a5,-24
ffffffffc0201590:	fee57ae3          	bgeu	a0,a4,ffffffffc0201584 <default_free_pages+0x68>
ffffffffc0201594:	c199                	beqz	a1,ffffffffc020159a <default_free_pages+0x7e>
ffffffffc0201596:	0106b023          	sd	a6,0(a3)
ffffffffc020159a:	6398                	ld	a4,0(a5)
ffffffffc020159c:	e390                	sd	a2,0(a5)
ffffffffc020159e:	e710                	sd	a2,8(a4)
ffffffffc02015a0:	ed18                	sd	a4,24(a0)
ffffffffc02015a2:	f11c                	sd	a5,32(a0)
ffffffffc02015a4:	00d70d63          	beq	a4,a3,ffffffffc02015be <default_free_pages+0xa2>
ffffffffc02015a8:	ff872583          	lw	a1,-8(a4)
ffffffffc02015ac:	fe870613          	addi	a2,a4,-24
ffffffffc02015b0:	02059813          	slli	a6,a1,0x20
ffffffffc02015b4:	01a85793          	srli	a5,a6,0x1a
ffffffffc02015b8:	97b2                	add	a5,a5,a2
ffffffffc02015ba:	02f50c63          	beq	a0,a5,ffffffffc02015f2 <default_free_pages+0xd6>
ffffffffc02015be:	711c                	ld	a5,32(a0)
ffffffffc02015c0:	00d78c63          	beq	a5,a3,ffffffffc02015d8 <default_free_pages+0xbc>
ffffffffc02015c4:	4910                	lw	a2,16(a0)
ffffffffc02015c6:	fe878693          	addi	a3,a5,-24
ffffffffc02015ca:	02061593          	slli	a1,a2,0x20
ffffffffc02015ce:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02015d2:	972a                	add	a4,a4,a0
ffffffffc02015d4:	04e68c63          	beq	a3,a4,ffffffffc020162c <default_free_pages+0x110>
ffffffffc02015d8:	60a2                	ld	ra,8(sp)
ffffffffc02015da:	0141                	addi	sp,sp,16
ffffffffc02015dc:	8082                	ret
ffffffffc02015de:	e790                	sd	a2,8(a5)
ffffffffc02015e0:	f114                	sd	a3,32(a0)
ffffffffc02015e2:	6798                	ld	a4,8(a5)
ffffffffc02015e4:	ed1c                	sd	a5,24(a0)
ffffffffc02015e6:	8832                	mv	a6,a2
ffffffffc02015e8:	02d70f63          	beq	a4,a3,ffffffffc0201626 <default_free_pages+0x10a>
ffffffffc02015ec:	4585                	li	a1,1
ffffffffc02015ee:	87ba                	mv	a5,a4
ffffffffc02015f0:	bf71                	j	ffffffffc020158c <default_free_pages+0x70>
ffffffffc02015f2:	491c                	lw	a5,16(a0)
ffffffffc02015f4:	5875                	li	a6,-3
ffffffffc02015f6:	9fad                	addw	a5,a5,a1
ffffffffc02015f8:	fef72c23          	sw	a5,-8(a4)
ffffffffc02015fc:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201600:	01853803          	ld	a6,24(a0)
ffffffffc0201604:	710c                	ld	a1,32(a0)
ffffffffc0201606:	8532                	mv	a0,a2
ffffffffc0201608:	00b83423          	sd	a1,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
ffffffffc020160c:	671c                	ld	a5,8(a4)
ffffffffc020160e:	0105b023          	sd	a6,0(a1)
ffffffffc0201612:	b77d                	j	ffffffffc02015c0 <default_free_pages+0xa4>
ffffffffc0201614:	60a2                	ld	ra,8(sp)
ffffffffc0201616:	01850713          	addi	a4,a0,24
ffffffffc020161a:	f11c                	sd	a5,32(a0)
ffffffffc020161c:	ed1c                	sd	a5,24(a0)
ffffffffc020161e:	e398                	sd	a4,0(a5)
ffffffffc0201620:	e798                	sd	a4,8(a5)
ffffffffc0201622:	0141                	addi	sp,sp,16
ffffffffc0201624:	8082                	ret
ffffffffc0201626:	e290                	sd	a2,0(a3)
ffffffffc0201628:	873e                	mv	a4,a5
ffffffffc020162a:	bfad                	j	ffffffffc02015a4 <default_free_pages+0x88>
ffffffffc020162c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201630:	56f5                	li	a3,-3
ffffffffc0201632:	9f31                	addw	a4,a4,a2
ffffffffc0201634:	c918                	sw	a4,16(a0)
ffffffffc0201636:	ff078713          	addi	a4,a5,-16
ffffffffc020163a:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc020163e:	6398                	ld	a4,0(a5)
ffffffffc0201640:	679c                	ld	a5,8(a5)
ffffffffc0201642:	60a2                	ld	ra,8(sp)
ffffffffc0201644:	e71c                	sd	a5,8(a4)
ffffffffc0201646:	e398                	sd	a4,0(a5)
ffffffffc0201648:	0141                	addi	sp,sp,16
ffffffffc020164a:	8082                	ret
ffffffffc020164c:	00003697          	auipc	a3,0x3
ffffffffc0201650:	57468693          	addi	a3,a3,1396 # ffffffffc0204bc0 <etext+0xd36>
ffffffffc0201654:	00003617          	auipc	a2,0x3
ffffffffc0201658:	20c60613          	addi	a2,a2,524 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020165c:	08300593          	li	a1,131
ffffffffc0201660:	00003517          	auipc	a0,0x3
ffffffffc0201664:	21850513          	addi	a0,a0,536 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201668:	d9ffe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020166c:	00003697          	auipc	a3,0x3
ffffffffc0201670:	54c68693          	addi	a3,a3,1356 # ffffffffc0204bb8 <etext+0xd2e>
ffffffffc0201674:	00003617          	auipc	a2,0x3
ffffffffc0201678:	1ec60613          	addi	a2,a2,492 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020167c:	08000593          	li	a1,128
ffffffffc0201680:	00003517          	auipc	a0,0x3
ffffffffc0201684:	1f850513          	addi	a0,a0,504 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201688:	d7ffe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020168c <default_alloc_pages>:
ffffffffc020168c:	c951                	beqz	a0,ffffffffc0201720 <default_alloc_pages+0x94>
ffffffffc020168e:	00008597          	auipc	a1,0x8
ffffffffc0201692:	db25a583          	lw	a1,-590(a1) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201696:	86aa                	mv	a3,a0
ffffffffc0201698:	02059793          	slli	a5,a1,0x20
ffffffffc020169c:	9381                	srli	a5,a5,0x20
ffffffffc020169e:	00a7ef63          	bltu	a5,a0,ffffffffc02016bc <default_alloc_pages+0x30>
ffffffffc02016a2:	00008617          	auipc	a2,0x8
ffffffffc02016a6:	d8e60613          	addi	a2,a2,-626 # ffffffffc0209430 <free_area>
ffffffffc02016aa:	87b2                	mv	a5,a2
ffffffffc02016ac:	a029                	j	ffffffffc02016b6 <default_alloc_pages+0x2a>
ffffffffc02016ae:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02016b2:	00d77763          	bgeu	a4,a3,ffffffffc02016c0 <default_alloc_pages+0x34>
ffffffffc02016b6:	679c                	ld	a5,8(a5)
ffffffffc02016b8:	fec79be3          	bne	a5,a2,ffffffffc02016ae <default_alloc_pages+0x22>
ffffffffc02016bc:	4501                	li	a0,0
ffffffffc02016be:	8082                	ret
ffffffffc02016c0:	ff87a883          	lw	a7,-8(a5)
ffffffffc02016c4:	0007b803          	ld	a6,0(a5)
ffffffffc02016c8:	6798                	ld	a4,8(a5)
ffffffffc02016ca:	02089313          	slli	t1,a7,0x20
ffffffffc02016ce:	02035313          	srli	t1,t1,0x20
ffffffffc02016d2:	00e83423          	sd	a4,8(a6)
ffffffffc02016d6:	01073023          	sd	a6,0(a4)
ffffffffc02016da:	fe878513          	addi	a0,a5,-24
ffffffffc02016de:	0266fa63          	bgeu	a3,t1,ffffffffc0201712 <default_alloc_pages+0x86>
ffffffffc02016e2:	00669713          	slli	a4,a3,0x6
ffffffffc02016e6:	40d888bb          	subw	a7,a7,a3
ffffffffc02016ea:	972a                	add	a4,a4,a0
ffffffffc02016ec:	01172823          	sw	a7,16(a4)
ffffffffc02016f0:	00870313          	addi	t1,a4,8
ffffffffc02016f4:	4889                	li	a7,2
ffffffffc02016f6:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc02016fa:	00883883          	ld	a7,8(a6)
ffffffffc02016fe:	01870313          	addi	t1,a4,24
ffffffffc0201702:	0068b023          	sd	t1,0(a7)
ffffffffc0201706:	00683423          	sd	t1,8(a6)
ffffffffc020170a:	03173023          	sd	a7,32(a4)
ffffffffc020170e:	01073c23          	sd	a6,24(a4)
ffffffffc0201712:	9d95                	subw	a1,a1,a3
ffffffffc0201714:	ca0c                	sw	a1,16(a2)
ffffffffc0201716:	5775                	li	a4,-3
ffffffffc0201718:	17c1                	addi	a5,a5,-16
ffffffffc020171a:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020171e:	8082                	ret
ffffffffc0201720:	1141                	addi	sp,sp,-16
ffffffffc0201722:	00003697          	auipc	a3,0x3
ffffffffc0201726:	49668693          	addi	a3,a3,1174 # ffffffffc0204bb8 <etext+0xd2e>
ffffffffc020172a:	00003617          	auipc	a2,0x3
ffffffffc020172e:	13660613          	addi	a2,a2,310 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0201732:	06200593          	li	a1,98
ffffffffc0201736:	00003517          	auipc	a0,0x3
ffffffffc020173a:	14250513          	addi	a0,a0,322 # ffffffffc0204878 <etext+0x9ee>
ffffffffc020173e:	e406                	sd	ra,8(sp)
ffffffffc0201740:	cc7fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201744 <default_init_memmap>:
ffffffffc0201744:	1141                	addi	sp,sp,-16
ffffffffc0201746:	e406                	sd	ra,8(sp)
ffffffffc0201748:	c9e1                	beqz	a1,ffffffffc0201818 <default_init_memmap+0xd4>
ffffffffc020174a:	00659713          	slli	a4,a1,0x6
ffffffffc020174e:	00e506b3          	add	a3,a0,a4
ffffffffc0201752:	87aa                	mv	a5,a0
ffffffffc0201754:	cf11                	beqz	a4,ffffffffc0201770 <default_init_memmap+0x2c>
ffffffffc0201756:	6798                	ld	a4,8(a5)
ffffffffc0201758:	8b05                	andi	a4,a4,1
ffffffffc020175a:	cf59                	beqz	a4,ffffffffc02017f8 <default_init_memmap+0xb4>
ffffffffc020175c:	0007a823          	sw	zero,16(a5)
ffffffffc0201760:	0007b423          	sd	zero,8(a5)
ffffffffc0201764:	0007a023          	sw	zero,0(a5)
ffffffffc0201768:	04078793          	addi	a5,a5,64
ffffffffc020176c:	fed795e3          	bne	a5,a3,ffffffffc0201756 <default_init_memmap+0x12>
ffffffffc0201770:	c90c                	sw	a1,16(a0)
ffffffffc0201772:	4789                	li	a5,2
ffffffffc0201774:	00850713          	addi	a4,a0,8
ffffffffc0201778:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc020177c:	00008717          	auipc	a4,0x8
ffffffffc0201780:	cc472703          	lw	a4,-828(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0201784:	00008697          	auipc	a3,0x8
ffffffffc0201788:	cac68693          	addi	a3,a3,-852 # ffffffffc0209430 <free_area>
ffffffffc020178c:	669c                	ld	a5,8(a3)
ffffffffc020178e:	9f2d                	addw	a4,a4,a1
ffffffffc0201790:	ca98                	sw	a4,16(a3)
ffffffffc0201792:	04d78663          	beq	a5,a3,ffffffffc02017de <default_init_memmap+0x9a>
ffffffffc0201796:	fe878713          	addi	a4,a5,-24
ffffffffc020179a:	4581                	li	a1,0
ffffffffc020179c:	01850613          	addi	a2,a0,24
ffffffffc02017a0:	00e56a63          	bltu	a0,a4,ffffffffc02017b4 <default_init_memmap+0x70>
ffffffffc02017a4:	6798                	ld	a4,8(a5)
ffffffffc02017a6:	02d70263          	beq	a4,a3,ffffffffc02017ca <default_init_memmap+0x86>
ffffffffc02017aa:	87ba                	mv	a5,a4
ffffffffc02017ac:	fe878713          	addi	a4,a5,-24
ffffffffc02017b0:	fee57ae3          	bgeu	a0,a4,ffffffffc02017a4 <default_init_memmap+0x60>
ffffffffc02017b4:	c199                	beqz	a1,ffffffffc02017ba <default_init_memmap+0x76>
ffffffffc02017b6:	0106b023          	sd	a6,0(a3)
ffffffffc02017ba:	6398                	ld	a4,0(a5)
ffffffffc02017bc:	60a2                	ld	ra,8(sp)
ffffffffc02017be:	e390                	sd	a2,0(a5)
ffffffffc02017c0:	e710                	sd	a2,8(a4)
ffffffffc02017c2:	ed18                	sd	a4,24(a0)
ffffffffc02017c4:	f11c                	sd	a5,32(a0)
ffffffffc02017c6:	0141                	addi	sp,sp,16
ffffffffc02017c8:	8082                	ret
ffffffffc02017ca:	e790                	sd	a2,8(a5)
ffffffffc02017cc:	f114                	sd	a3,32(a0)
ffffffffc02017ce:	6798                	ld	a4,8(a5)
ffffffffc02017d0:	ed1c                	sd	a5,24(a0)
ffffffffc02017d2:	8832                	mv	a6,a2
ffffffffc02017d4:	00d70e63          	beq	a4,a3,ffffffffc02017f0 <default_init_memmap+0xac>
ffffffffc02017d8:	4585                	li	a1,1
ffffffffc02017da:	87ba                	mv	a5,a4
ffffffffc02017dc:	bfc1                	j	ffffffffc02017ac <default_init_memmap+0x68>
ffffffffc02017de:	60a2                	ld	ra,8(sp)
ffffffffc02017e0:	01850713          	addi	a4,a0,24
ffffffffc02017e4:	f11c                	sd	a5,32(a0)
ffffffffc02017e6:	ed1c                	sd	a5,24(a0)
ffffffffc02017e8:	e398                	sd	a4,0(a5)
ffffffffc02017ea:	e798                	sd	a4,8(a5)
ffffffffc02017ec:	0141                	addi	sp,sp,16
ffffffffc02017ee:	8082                	ret
ffffffffc02017f0:	60a2                	ld	ra,8(sp)
ffffffffc02017f2:	e290                	sd	a2,0(a3)
ffffffffc02017f4:	0141                	addi	sp,sp,16
ffffffffc02017f6:	8082                	ret
ffffffffc02017f8:	00003697          	auipc	a3,0x3
ffffffffc02017fc:	3f068693          	addi	a3,a3,1008 # ffffffffc0204be8 <etext+0xd5e>
ffffffffc0201800:	00003617          	auipc	a2,0x3
ffffffffc0201804:	06060613          	addi	a2,a2,96 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0201808:	04900593          	li	a1,73
ffffffffc020180c:	00003517          	auipc	a0,0x3
ffffffffc0201810:	06c50513          	addi	a0,a0,108 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201814:	bf3fe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0201818:	00003697          	auipc	a3,0x3
ffffffffc020181c:	3a068693          	addi	a3,a3,928 # ffffffffc0204bb8 <etext+0xd2e>
ffffffffc0201820:	00003617          	auipc	a2,0x3
ffffffffc0201824:	04060613          	addi	a2,a2,64 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0201828:	04600593          	li	a1,70
ffffffffc020182c:	00003517          	auipc	a0,0x3
ffffffffc0201830:	04c50513          	addi	a0,a0,76 # ffffffffc0204878 <etext+0x9ee>
ffffffffc0201834:	bd3fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201838 <slob_free>:
ffffffffc0201838:	c531                	beqz	a0,ffffffffc0201884 <slob_free+0x4c>
ffffffffc020183a:	e9b9                	bnez	a1,ffffffffc0201890 <slob_free+0x58>
ffffffffc020183c:	100027f3          	csrr	a5,sstatus
ffffffffc0201840:	8b89                	andi	a5,a5,2
ffffffffc0201842:	4581                	li	a1,0
ffffffffc0201844:	efb1                	bnez	a5,ffffffffc02018a0 <slob_free+0x68>
ffffffffc0201846:	00007797          	auipc	a5,0x7
ffffffffc020184a:	7da7b783          	ld	a5,2010(a5) # ffffffffc0209020 <slobfree>
ffffffffc020184e:	873e                	mv	a4,a5
ffffffffc0201850:	679c                	ld	a5,8(a5)
ffffffffc0201852:	02a77a63          	bgeu	a4,a0,ffffffffc0201886 <slob_free+0x4e>
ffffffffc0201856:	00f56463          	bltu	a0,a5,ffffffffc020185e <slob_free+0x26>
ffffffffc020185a:	fef76ae3          	bltu	a4,a5,ffffffffc020184e <slob_free+0x16>
ffffffffc020185e:	4110                	lw	a2,0(a0)
ffffffffc0201860:	00461693          	slli	a3,a2,0x4
ffffffffc0201864:	96aa                	add	a3,a3,a0
ffffffffc0201866:	0ad78463          	beq	a5,a3,ffffffffc020190e <slob_free+0xd6>
ffffffffc020186a:	4310                	lw	a2,0(a4)
ffffffffc020186c:	e51c                	sd	a5,8(a0)
ffffffffc020186e:	00461693          	slli	a3,a2,0x4
ffffffffc0201872:	96ba                	add	a3,a3,a4
ffffffffc0201874:	08d50163          	beq	a0,a3,ffffffffc02018f6 <slob_free+0xbe>
ffffffffc0201878:	e708                	sd	a0,8(a4)
ffffffffc020187a:	00007797          	auipc	a5,0x7
ffffffffc020187e:	7ae7b323          	sd	a4,1958(a5) # ffffffffc0209020 <slobfree>
ffffffffc0201882:	e9a5                	bnez	a1,ffffffffc02018f2 <slob_free+0xba>
ffffffffc0201884:	8082                	ret
ffffffffc0201886:	fcf574e3          	bgeu	a0,a5,ffffffffc020184e <slob_free+0x16>
ffffffffc020188a:	fcf762e3          	bltu	a4,a5,ffffffffc020184e <slob_free+0x16>
ffffffffc020188e:	bfc1                	j	ffffffffc020185e <slob_free+0x26>
ffffffffc0201890:	25bd                	addiw	a1,a1,15
ffffffffc0201892:	8191                	srli	a1,a1,0x4
ffffffffc0201894:	c10c                	sw	a1,0(a0)
ffffffffc0201896:	100027f3          	csrr	a5,sstatus
ffffffffc020189a:	8b89                	andi	a5,a5,2
ffffffffc020189c:	4581                	li	a1,0
ffffffffc020189e:	d7c5                	beqz	a5,ffffffffc0201846 <slob_free+0xe>
ffffffffc02018a0:	1101                	addi	sp,sp,-32
ffffffffc02018a2:	e42a                	sd	a0,8(sp)
ffffffffc02018a4:	ec06                	sd	ra,24(sp)
ffffffffc02018a6:	fcffe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02018aa:	6522                	ld	a0,8(sp)
ffffffffc02018ac:	00007797          	auipc	a5,0x7
ffffffffc02018b0:	7747b783          	ld	a5,1908(a5) # ffffffffc0209020 <slobfree>
ffffffffc02018b4:	4585                	li	a1,1
ffffffffc02018b6:	873e                	mv	a4,a5
ffffffffc02018b8:	679c                	ld	a5,8(a5)
ffffffffc02018ba:	06a77663          	bgeu	a4,a0,ffffffffc0201926 <slob_free+0xee>
ffffffffc02018be:	00f56463          	bltu	a0,a5,ffffffffc02018c6 <slob_free+0x8e>
ffffffffc02018c2:	fef76ae3          	bltu	a4,a5,ffffffffc02018b6 <slob_free+0x7e>
ffffffffc02018c6:	4110                	lw	a2,0(a0)
ffffffffc02018c8:	00461693          	slli	a3,a2,0x4
ffffffffc02018cc:	96aa                	add	a3,a3,a0
ffffffffc02018ce:	06d78363          	beq	a5,a3,ffffffffc0201934 <slob_free+0xfc>
ffffffffc02018d2:	4310                	lw	a2,0(a4)
ffffffffc02018d4:	e51c                	sd	a5,8(a0)
ffffffffc02018d6:	00461693          	slli	a3,a2,0x4
ffffffffc02018da:	96ba                	add	a3,a3,a4
ffffffffc02018dc:	06d50163          	beq	a0,a3,ffffffffc020193e <slob_free+0x106>
ffffffffc02018e0:	e708                	sd	a0,8(a4)
ffffffffc02018e2:	00007797          	auipc	a5,0x7
ffffffffc02018e6:	72e7bf23          	sd	a4,1854(a5) # ffffffffc0209020 <slobfree>
ffffffffc02018ea:	e1a9                	bnez	a1,ffffffffc020192c <slob_free+0xf4>
ffffffffc02018ec:	60e2                	ld	ra,24(sp)
ffffffffc02018ee:	6105                	addi	sp,sp,32
ffffffffc02018f0:	8082                	ret
ffffffffc02018f2:	f7dfe06f          	j	ffffffffc020086e <intr_enable>
ffffffffc02018f6:	4114                	lw	a3,0(a0)
ffffffffc02018f8:	853e                	mv	a0,a5
ffffffffc02018fa:	e708                	sd	a0,8(a4)
ffffffffc02018fc:	00c687bb          	addw	a5,a3,a2
ffffffffc0201900:	c31c                	sw	a5,0(a4)
ffffffffc0201902:	00007797          	auipc	a5,0x7
ffffffffc0201906:	70e7bf23          	sd	a4,1822(a5) # ffffffffc0209020 <slobfree>
ffffffffc020190a:	ddad                	beqz	a1,ffffffffc0201884 <slob_free+0x4c>
ffffffffc020190c:	b7dd                	j	ffffffffc02018f2 <slob_free+0xba>
ffffffffc020190e:	4394                	lw	a3,0(a5)
ffffffffc0201910:	679c                	ld	a5,8(a5)
ffffffffc0201912:	9eb1                	addw	a3,a3,a2
ffffffffc0201914:	c114                	sw	a3,0(a0)
ffffffffc0201916:	4310                	lw	a2,0(a4)
ffffffffc0201918:	e51c                	sd	a5,8(a0)
ffffffffc020191a:	00461693          	slli	a3,a2,0x4
ffffffffc020191e:	96ba                	add	a3,a3,a4
ffffffffc0201920:	f4d51ce3          	bne	a0,a3,ffffffffc0201878 <slob_free+0x40>
ffffffffc0201924:	bfc9                	j	ffffffffc02018f6 <slob_free+0xbe>
ffffffffc0201926:	f8f56ee3          	bltu	a0,a5,ffffffffc02018c2 <slob_free+0x8a>
ffffffffc020192a:	b771                	j	ffffffffc02018b6 <slob_free+0x7e>
ffffffffc020192c:	60e2                	ld	ra,24(sp)
ffffffffc020192e:	6105                	addi	sp,sp,32
ffffffffc0201930:	f3ffe06f          	j	ffffffffc020086e <intr_enable>
ffffffffc0201934:	4394                	lw	a3,0(a5)
ffffffffc0201936:	679c                	ld	a5,8(a5)
ffffffffc0201938:	9eb1                	addw	a3,a3,a2
ffffffffc020193a:	c114                	sw	a3,0(a0)
ffffffffc020193c:	bf59                	j	ffffffffc02018d2 <slob_free+0x9a>
ffffffffc020193e:	4114                	lw	a3,0(a0)
ffffffffc0201940:	853e                	mv	a0,a5
ffffffffc0201942:	00c687bb          	addw	a5,a3,a2
ffffffffc0201946:	c31c                	sw	a5,0(a4)
ffffffffc0201948:	bf61                	j	ffffffffc02018e0 <slob_free+0xa8>

ffffffffc020194a <__slob_get_free_pages.constprop.0>:
ffffffffc020194a:	4785                	li	a5,1
ffffffffc020194c:	1141                	addi	sp,sp,-16
ffffffffc020194e:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201952:	e406                	sd	ra,8(sp)
ffffffffc0201954:	326000ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc0201958:	c91d                	beqz	a0,ffffffffc020198e <__slob_get_free_pages.constprop.0+0x44>
ffffffffc020195a:	0000c697          	auipc	a3,0xc
ffffffffc020195e:	b6e6b683          	ld	a3,-1170(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201962:	00004797          	auipc	a5,0x4
ffffffffc0201966:	07e7b783          	ld	a5,126(a5) # ffffffffc02059e0 <nbase>
ffffffffc020196a:	0000c717          	auipc	a4,0xc
ffffffffc020196e:	b5673703          	ld	a4,-1194(a4) # ffffffffc020d4c0 <npage>
ffffffffc0201972:	8d15                	sub	a0,a0,a3
ffffffffc0201974:	8519                	srai	a0,a0,0x6
ffffffffc0201976:	953e                	add	a0,a0,a5
ffffffffc0201978:	00c51793          	slli	a5,a0,0xc
ffffffffc020197c:	83b1                	srli	a5,a5,0xc
ffffffffc020197e:	0532                	slli	a0,a0,0xc
ffffffffc0201980:	00e7fa63          	bgeu	a5,a4,ffffffffc0201994 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201984:	0000c797          	auipc	a5,0xc
ffffffffc0201988:	b347b783          	ld	a5,-1228(a5) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc020198c:	953e                	add	a0,a0,a5
ffffffffc020198e:	60a2                	ld	ra,8(sp)
ffffffffc0201990:	0141                	addi	sp,sp,16
ffffffffc0201992:	8082                	ret
ffffffffc0201994:	86aa                	mv	a3,a0
ffffffffc0201996:	00003617          	auipc	a2,0x3
ffffffffc020199a:	27a60613          	addi	a2,a2,634 # ffffffffc0204c10 <etext+0xd86>
ffffffffc020199e:	07100593          	li	a1,113
ffffffffc02019a2:	00003517          	auipc	a0,0x3
ffffffffc02019a6:	29650513          	addi	a0,a0,662 # ffffffffc0204c38 <etext+0xdae>
ffffffffc02019aa:	a5dfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02019ae <slob_alloc.constprop.0>:
ffffffffc02019ae:	7179                	addi	sp,sp,-48
ffffffffc02019b0:	f406                	sd	ra,40(sp)
ffffffffc02019b2:	f022                	sd	s0,32(sp)
ffffffffc02019b4:	ec26                	sd	s1,24(sp)
ffffffffc02019b6:	01050713          	addi	a4,a0,16
ffffffffc02019ba:	6785                	lui	a5,0x1
ffffffffc02019bc:	0af77e63          	bgeu	a4,a5,ffffffffc0201a78 <slob_alloc.constprop.0+0xca>
ffffffffc02019c0:	00f50413          	addi	s0,a0,15
ffffffffc02019c4:	8011                	srli	s0,s0,0x4
ffffffffc02019c6:	2401                	sext.w	s0,s0
ffffffffc02019c8:	100025f3          	csrr	a1,sstatus
ffffffffc02019cc:	8989                	andi	a1,a1,2
ffffffffc02019ce:	edd1                	bnez	a1,ffffffffc0201a6a <slob_alloc.constprop.0+0xbc>
ffffffffc02019d0:	00007497          	auipc	s1,0x7
ffffffffc02019d4:	65048493          	addi	s1,s1,1616 # ffffffffc0209020 <slobfree>
ffffffffc02019d8:	6090                	ld	a2,0(s1)
ffffffffc02019da:	6618                	ld	a4,8(a2)
ffffffffc02019dc:	4314                	lw	a3,0(a4)
ffffffffc02019de:	0886da63          	bge	a3,s0,ffffffffc0201a72 <slob_alloc.constprop.0+0xc4>
ffffffffc02019e2:	00e60a63          	beq	a2,a4,ffffffffc02019f6 <slob_alloc.constprop.0+0x48>
ffffffffc02019e6:	671c                	ld	a5,8(a4)
ffffffffc02019e8:	4394                	lw	a3,0(a5)
ffffffffc02019ea:	0286d863          	bge	a3,s0,ffffffffc0201a1a <slob_alloc.constprop.0+0x6c>
ffffffffc02019ee:	6090                	ld	a2,0(s1)
ffffffffc02019f0:	873e                	mv	a4,a5
ffffffffc02019f2:	fee61ae3          	bne	a2,a4,ffffffffc02019e6 <slob_alloc.constprop.0+0x38>
ffffffffc02019f6:	e9b1                	bnez	a1,ffffffffc0201a4a <slob_alloc.constprop.0+0x9c>
ffffffffc02019f8:	4501                	li	a0,0
ffffffffc02019fa:	f51ff0ef          	jal	ffffffffc020194a <__slob_get_free_pages.constprop.0>
ffffffffc02019fe:	87aa                	mv	a5,a0
ffffffffc0201a00:	c915                	beqz	a0,ffffffffc0201a34 <slob_alloc.constprop.0+0x86>
ffffffffc0201a02:	6585                	lui	a1,0x1
ffffffffc0201a04:	e35ff0ef          	jal	ffffffffc0201838 <slob_free>
ffffffffc0201a08:	100025f3          	csrr	a1,sstatus
ffffffffc0201a0c:	8989                	andi	a1,a1,2
ffffffffc0201a0e:	e98d                	bnez	a1,ffffffffc0201a40 <slob_alloc.constprop.0+0x92>
ffffffffc0201a10:	6098                	ld	a4,0(s1)
ffffffffc0201a12:	671c                	ld	a5,8(a4)
ffffffffc0201a14:	4394                	lw	a3,0(a5)
ffffffffc0201a16:	fc86cce3          	blt	a3,s0,ffffffffc02019ee <slob_alloc.constprop.0+0x40>
ffffffffc0201a1a:	04d40563          	beq	s0,a3,ffffffffc0201a64 <slob_alloc.constprop.0+0xb6>
ffffffffc0201a1e:	00441613          	slli	a2,s0,0x4
ffffffffc0201a22:	963e                	add	a2,a2,a5
ffffffffc0201a24:	e710                	sd	a2,8(a4)
ffffffffc0201a26:	6788                	ld	a0,8(a5)
ffffffffc0201a28:	9e81                	subw	a3,a3,s0
ffffffffc0201a2a:	c214                	sw	a3,0(a2)
ffffffffc0201a2c:	e608                	sd	a0,8(a2)
ffffffffc0201a2e:	c380                	sw	s0,0(a5)
ffffffffc0201a30:	e098                	sd	a4,0(s1)
ffffffffc0201a32:	ed99                	bnez	a1,ffffffffc0201a50 <slob_alloc.constprop.0+0xa2>
ffffffffc0201a34:	70a2                	ld	ra,40(sp)
ffffffffc0201a36:	7402                	ld	s0,32(sp)
ffffffffc0201a38:	64e2                	ld	s1,24(sp)
ffffffffc0201a3a:	853e                	mv	a0,a5
ffffffffc0201a3c:	6145                	addi	sp,sp,48
ffffffffc0201a3e:	8082                	ret
ffffffffc0201a40:	e35fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201a44:	6098                	ld	a4,0(s1)
ffffffffc0201a46:	4585                	li	a1,1
ffffffffc0201a48:	b7e9                	j	ffffffffc0201a12 <slob_alloc.constprop.0+0x64>
ffffffffc0201a4a:	e25fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201a4e:	b76d                	j	ffffffffc02019f8 <slob_alloc.constprop.0+0x4a>
ffffffffc0201a50:	e43e                	sd	a5,8(sp)
ffffffffc0201a52:	e1dfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201a56:	67a2                	ld	a5,8(sp)
ffffffffc0201a58:	70a2                	ld	ra,40(sp)
ffffffffc0201a5a:	7402                	ld	s0,32(sp)
ffffffffc0201a5c:	64e2                	ld	s1,24(sp)
ffffffffc0201a5e:	853e                	mv	a0,a5
ffffffffc0201a60:	6145                	addi	sp,sp,48
ffffffffc0201a62:	8082                	ret
ffffffffc0201a64:	6794                	ld	a3,8(a5)
ffffffffc0201a66:	e714                	sd	a3,8(a4)
ffffffffc0201a68:	b7e1                	j	ffffffffc0201a30 <slob_alloc.constprop.0+0x82>
ffffffffc0201a6a:	e0bfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201a6e:	4585                	li	a1,1
ffffffffc0201a70:	b785                	j	ffffffffc02019d0 <slob_alloc.constprop.0+0x22>
ffffffffc0201a72:	87ba                	mv	a5,a4
ffffffffc0201a74:	8732                	mv	a4,a2
ffffffffc0201a76:	b755                	j	ffffffffc0201a1a <slob_alloc.constprop.0+0x6c>
ffffffffc0201a78:	00003697          	auipc	a3,0x3
ffffffffc0201a7c:	1d068693          	addi	a3,a3,464 # ffffffffc0204c48 <etext+0xdbe>
ffffffffc0201a80:	00003617          	auipc	a2,0x3
ffffffffc0201a84:	de060613          	addi	a2,a2,-544 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0201a88:	06300593          	li	a1,99
ffffffffc0201a8c:	00003517          	auipc	a0,0x3
ffffffffc0201a90:	1dc50513          	addi	a0,a0,476 # ffffffffc0204c68 <etext+0xdde>
ffffffffc0201a94:	973fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201a98 <kmalloc_init>:
ffffffffc0201a98:	1141                	addi	sp,sp,-16
ffffffffc0201a9a:	00003517          	auipc	a0,0x3
ffffffffc0201a9e:	1e650513          	addi	a0,a0,486 # ffffffffc0204c80 <etext+0xdf6>
ffffffffc0201aa2:	e406                	sd	ra,8(sp)
ffffffffc0201aa4:	ef0fe0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0201aa8:	60a2                	ld	ra,8(sp)
ffffffffc0201aaa:	00003517          	auipc	a0,0x3
ffffffffc0201aae:	1ee50513          	addi	a0,a0,494 # ffffffffc0204c98 <etext+0xe0e>
ffffffffc0201ab2:	0141                	addi	sp,sp,16
ffffffffc0201ab4:	ee0fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201ab8 <kmalloc>:
ffffffffc0201ab8:	1101                	addi	sp,sp,-32
ffffffffc0201aba:	6685                	lui	a3,0x1
ffffffffc0201abc:	ec06                	sd	ra,24(sp)
ffffffffc0201abe:	16bd                	addi	a3,a3,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201ac0:	04a6f963          	bgeu	a3,a0,ffffffffc0201b12 <kmalloc+0x5a>
ffffffffc0201ac4:	e42a                	sd	a0,8(sp)
ffffffffc0201ac6:	4561                	li	a0,24
ffffffffc0201ac8:	e822                	sd	s0,16(sp)
ffffffffc0201aca:	ee5ff0ef          	jal	ffffffffc02019ae <slob_alloc.constprop.0>
ffffffffc0201ace:	842a                	mv	s0,a0
ffffffffc0201ad0:	c541                	beqz	a0,ffffffffc0201b58 <kmalloc+0xa0>
ffffffffc0201ad2:	47a2                	lw	a5,8(sp)
ffffffffc0201ad4:	6705                	lui	a4,0x1
ffffffffc0201ad6:	4501                	li	a0,0
ffffffffc0201ad8:	00f75763          	bge	a4,a5,ffffffffc0201ae6 <kmalloc+0x2e>
ffffffffc0201adc:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0201ae0:	2505                	addiw	a0,a0,1
ffffffffc0201ae2:	fef74de3          	blt	a4,a5,ffffffffc0201adc <kmalloc+0x24>
ffffffffc0201ae6:	c008                	sw	a0,0(s0)
ffffffffc0201ae8:	e63ff0ef          	jal	ffffffffc020194a <__slob_get_free_pages.constprop.0>
ffffffffc0201aec:	e408                	sd	a0,8(s0)
ffffffffc0201aee:	cd31                	beqz	a0,ffffffffc0201b4a <kmalloc+0x92>
ffffffffc0201af0:	100027f3          	csrr	a5,sstatus
ffffffffc0201af4:	8b89                	andi	a5,a5,2
ffffffffc0201af6:	eb85                	bnez	a5,ffffffffc0201b26 <kmalloc+0x6e>
ffffffffc0201af8:	0000c797          	auipc	a5,0xc
ffffffffc0201afc:	9a07b783          	ld	a5,-1632(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201b00:	0000c717          	auipc	a4,0xc
ffffffffc0201b04:	98873c23          	sd	s0,-1640(a4) # ffffffffc020d498 <bigblocks>
ffffffffc0201b08:	e81c                	sd	a5,16(s0)
ffffffffc0201b0a:	6442                	ld	s0,16(sp)
ffffffffc0201b0c:	60e2                	ld	ra,24(sp)
ffffffffc0201b0e:	6105                	addi	sp,sp,32
ffffffffc0201b10:	8082                	ret
ffffffffc0201b12:	0541                	addi	a0,a0,16
ffffffffc0201b14:	e9bff0ef          	jal	ffffffffc02019ae <slob_alloc.constprop.0>
ffffffffc0201b18:	87aa                	mv	a5,a0
ffffffffc0201b1a:	0541                	addi	a0,a0,16
ffffffffc0201b1c:	fbe5                	bnez	a5,ffffffffc0201b0c <kmalloc+0x54>
ffffffffc0201b1e:	4501                	li	a0,0
ffffffffc0201b20:	60e2                	ld	ra,24(sp)
ffffffffc0201b22:	6105                	addi	sp,sp,32
ffffffffc0201b24:	8082                	ret
ffffffffc0201b26:	d4ffe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201b2a:	0000c797          	auipc	a5,0xc
ffffffffc0201b2e:	96e7b783          	ld	a5,-1682(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201b32:	0000c717          	auipc	a4,0xc
ffffffffc0201b36:	96873323          	sd	s0,-1690(a4) # ffffffffc020d498 <bigblocks>
ffffffffc0201b3a:	e81c                	sd	a5,16(s0)
ffffffffc0201b3c:	d33fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201b40:	6408                	ld	a0,8(s0)
ffffffffc0201b42:	60e2                	ld	ra,24(sp)
ffffffffc0201b44:	6442                	ld	s0,16(sp)
ffffffffc0201b46:	6105                	addi	sp,sp,32
ffffffffc0201b48:	8082                	ret
ffffffffc0201b4a:	8522                	mv	a0,s0
ffffffffc0201b4c:	45e1                	li	a1,24
ffffffffc0201b4e:	cebff0ef          	jal	ffffffffc0201838 <slob_free>
ffffffffc0201b52:	4501                	li	a0,0
ffffffffc0201b54:	6442                	ld	s0,16(sp)
ffffffffc0201b56:	b7e9                	j	ffffffffc0201b20 <kmalloc+0x68>
ffffffffc0201b58:	6442                	ld	s0,16(sp)
ffffffffc0201b5a:	4501                	li	a0,0
ffffffffc0201b5c:	b7d1                	j	ffffffffc0201b20 <kmalloc+0x68>

ffffffffc0201b5e <kfree>:
ffffffffc0201b5e:	c571                	beqz	a0,ffffffffc0201c2a <kfree+0xcc>
ffffffffc0201b60:	03451793          	slli	a5,a0,0x34
ffffffffc0201b64:	e3e1                	bnez	a5,ffffffffc0201c24 <kfree+0xc6>
ffffffffc0201b66:	1101                	addi	sp,sp,-32
ffffffffc0201b68:	ec06                	sd	ra,24(sp)
ffffffffc0201b6a:	100027f3          	csrr	a5,sstatus
ffffffffc0201b6e:	8b89                	andi	a5,a5,2
ffffffffc0201b70:	e7c1                	bnez	a5,ffffffffc0201bf8 <kfree+0x9a>
ffffffffc0201b72:	0000c797          	auipc	a5,0xc
ffffffffc0201b76:	9267b783          	ld	a5,-1754(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201b7a:	4581                	li	a1,0
ffffffffc0201b7c:	cbad                	beqz	a5,ffffffffc0201bee <kfree+0x90>
ffffffffc0201b7e:	0000c617          	auipc	a2,0xc
ffffffffc0201b82:	91a60613          	addi	a2,a2,-1766 # ffffffffc020d498 <bigblocks>
ffffffffc0201b86:	a021                	j	ffffffffc0201b8e <kfree+0x30>
ffffffffc0201b88:	01070613          	addi	a2,a4,16
ffffffffc0201b8c:	c3a5                	beqz	a5,ffffffffc0201bec <kfree+0x8e>
ffffffffc0201b8e:	6794                	ld	a3,8(a5)
ffffffffc0201b90:	873e                	mv	a4,a5
ffffffffc0201b92:	6b9c                	ld	a5,16(a5)
ffffffffc0201b94:	fea69ae3          	bne	a3,a0,ffffffffc0201b88 <kfree+0x2a>
ffffffffc0201b98:	e21c                	sd	a5,0(a2)
ffffffffc0201b9a:	edb5                	bnez	a1,ffffffffc0201c16 <kfree+0xb8>
ffffffffc0201b9c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201ba0:	0af56263          	bltu	a0,a5,ffffffffc0201c44 <kfree+0xe6>
ffffffffc0201ba4:	0000c797          	auipc	a5,0xc
ffffffffc0201ba8:	9147b783          	ld	a5,-1772(a5) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201bac:	0000c697          	auipc	a3,0xc
ffffffffc0201bb0:	9146b683          	ld	a3,-1772(a3) # ffffffffc020d4c0 <npage>
ffffffffc0201bb4:	8d1d                	sub	a0,a0,a5
ffffffffc0201bb6:	00c55793          	srli	a5,a0,0xc
ffffffffc0201bba:	06d7f963          	bgeu	a5,a3,ffffffffc0201c2c <kfree+0xce>
ffffffffc0201bbe:	00004617          	auipc	a2,0x4
ffffffffc0201bc2:	e2263603          	ld	a2,-478(a2) # ffffffffc02059e0 <nbase>
ffffffffc0201bc6:	0000c517          	auipc	a0,0xc
ffffffffc0201bca:	90253503          	ld	a0,-1790(a0) # ffffffffc020d4c8 <pages>
ffffffffc0201bce:	4314                	lw	a3,0(a4)
ffffffffc0201bd0:	8f91                	sub	a5,a5,a2
ffffffffc0201bd2:	079a                	slli	a5,a5,0x6
ffffffffc0201bd4:	4585                	li	a1,1
ffffffffc0201bd6:	953e                	add	a0,a0,a5
ffffffffc0201bd8:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201bdc:	e03a                	sd	a4,0(sp)
ffffffffc0201bde:	0d6000ef          	jal	ffffffffc0201cb4 <free_pages>
ffffffffc0201be2:	6502                	ld	a0,0(sp)
ffffffffc0201be4:	60e2                	ld	ra,24(sp)
ffffffffc0201be6:	45e1                	li	a1,24
ffffffffc0201be8:	6105                	addi	sp,sp,32
ffffffffc0201bea:	b1b9                	j	ffffffffc0201838 <slob_free>
ffffffffc0201bec:	e185                	bnez	a1,ffffffffc0201c0c <kfree+0xae>
ffffffffc0201bee:	60e2                	ld	ra,24(sp)
ffffffffc0201bf0:	1541                	addi	a0,a0,-16
ffffffffc0201bf2:	4581                	li	a1,0
ffffffffc0201bf4:	6105                	addi	sp,sp,32
ffffffffc0201bf6:	b189                	j	ffffffffc0201838 <slob_free>
ffffffffc0201bf8:	e02a                	sd	a0,0(sp)
ffffffffc0201bfa:	c7bfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201bfe:	0000c797          	auipc	a5,0xc
ffffffffc0201c02:	89a7b783          	ld	a5,-1894(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201c06:	6502                	ld	a0,0(sp)
ffffffffc0201c08:	4585                	li	a1,1
ffffffffc0201c0a:	fbb5                	bnez	a5,ffffffffc0201b7e <kfree+0x20>
ffffffffc0201c0c:	e02a                	sd	a0,0(sp)
ffffffffc0201c0e:	c61fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201c12:	6502                	ld	a0,0(sp)
ffffffffc0201c14:	bfe9                	j	ffffffffc0201bee <kfree+0x90>
ffffffffc0201c16:	e42a                	sd	a0,8(sp)
ffffffffc0201c18:	e03a                	sd	a4,0(sp)
ffffffffc0201c1a:	c55fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201c1e:	6522                	ld	a0,8(sp)
ffffffffc0201c20:	6702                	ld	a4,0(sp)
ffffffffc0201c22:	bfad                	j	ffffffffc0201b9c <kfree+0x3e>
ffffffffc0201c24:	1541                	addi	a0,a0,-16
ffffffffc0201c26:	4581                	li	a1,0
ffffffffc0201c28:	b901                	j	ffffffffc0201838 <slob_free>
ffffffffc0201c2a:	8082                	ret
ffffffffc0201c2c:	00003617          	auipc	a2,0x3
ffffffffc0201c30:	0b460613          	addi	a2,a2,180 # ffffffffc0204ce0 <etext+0xe56>
ffffffffc0201c34:	06900593          	li	a1,105
ffffffffc0201c38:	00003517          	auipc	a0,0x3
ffffffffc0201c3c:	00050513          	mv	a0,a0
ffffffffc0201c40:	fc6fe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0201c44:	86aa                	mv	a3,a0
ffffffffc0201c46:	00003617          	auipc	a2,0x3
ffffffffc0201c4a:	07260613          	addi	a2,a2,114 # ffffffffc0204cb8 <etext+0xe2e>
ffffffffc0201c4e:	07700593          	li	a1,119
ffffffffc0201c52:	00003517          	auipc	a0,0x3
ffffffffc0201c56:	fe650513          	addi	a0,a0,-26 # ffffffffc0204c38 <etext+0xdae>
ffffffffc0201c5a:	facfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201c5e <pa2page.part.0>:
ffffffffc0201c5e:	1141                	addi	sp,sp,-16
ffffffffc0201c60:	00003617          	auipc	a2,0x3
ffffffffc0201c64:	08060613          	addi	a2,a2,128 # ffffffffc0204ce0 <etext+0xe56>
ffffffffc0201c68:	06900593          	li	a1,105
ffffffffc0201c6c:	00003517          	auipc	a0,0x3
ffffffffc0201c70:	fcc50513          	addi	a0,a0,-52 # ffffffffc0204c38 <etext+0xdae>
ffffffffc0201c74:	e406                	sd	ra,8(sp)
ffffffffc0201c76:	f90fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201c7a <alloc_pages>:
ffffffffc0201c7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201c7e:	8b89                	andi	a5,a5,2
ffffffffc0201c80:	e799                	bnez	a5,ffffffffc0201c8e <alloc_pages+0x14>
ffffffffc0201c82:	0000c797          	auipc	a5,0xc
ffffffffc0201c86:	81e7b783          	ld	a5,-2018(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201c8a:	6f9c                	ld	a5,24(a5)
ffffffffc0201c8c:	8782                	jr	a5
ffffffffc0201c8e:	1101                	addi	sp,sp,-32
ffffffffc0201c90:	ec06                	sd	ra,24(sp)
ffffffffc0201c92:	e42a                	sd	a0,8(sp)
ffffffffc0201c94:	be1fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201c98:	0000c797          	auipc	a5,0xc
ffffffffc0201c9c:	8087b783          	ld	a5,-2040(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201ca0:	6522                	ld	a0,8(sp)
ffffffffc0201ca2:	6f9c                	ld	a5,24(a5)
ffffffffc0201ca4:	9782                	jalr	a5
ffffffffc0201ca6:	e42a                	sd	a0,8(sp)
ffffffffc0201ca8:	bc7fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201cac:	60e2                	ld	ra,24(sp)
ffffffffc0201cae:	6522                	ld	a0,8(sp)
ffffffffc0201cb0:	6105                	addi	sp,sp,32
ffffffffc0201cb2:	8082                	ret

ffffffffc0201cb4 <free_pages>:
ffffffffc0201cb4:	100027f3          	csrr	a5,sstatus
ffffffffc0201cb8:	8b89                	andi	a5,a5,2
ffffffffc0201cba:	e799                	bnez	a5,ffffffffc0201cc8 <free_pages+0x14>
ffffffffc0201cbc:	0000b797          	auipc	a5,0xb
ffffffffc0201cc0:	7e47b783          	ld	a5,2020(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201cc4:	739c                	ld	a5,32(a5)
ffffffffc0201cc6:	8782                	jr	a5
ffffffffc0201cc8:	1101                	addi	sp,sp,-32
ffffffffc0201cca:	ec06                	sd	ra,24(sp)
ffffffffc0201ccc:	e42e                	sd	a1,8(sp)
ffffffffc0201cce:	e02a                	sd	a0,0(sp)
ffffffffc0201cd0:	ba5fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201cd4:	0000b797          	auipc	a5,0xb
ffffffffc0201cd8:	7cc7b783          	ld	a5,1996(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201cdc:	65a2                	ld	a1,8(sp)
ffffffffc0201cde:	6502                	ld	a0,0(sp)
ffffffffc0201ce0:	739c                	ld	a5,32(a5)
ffffffffc0201ce2:	9782                	jalr	a5
ffffffffc0201ce4:	60e2                	ld	ra,24(sp)
ffffffffc0201ce6:	6105                	addi	sp,sp,32
ffffffffc0201ce8:	b87fe06f          	j	ffffffffc020086e <intr_enable>

ffffffffc0201cec <nr_free_pages>:
ffffffffc0201cec:	100027f3          	csrr	a5,sstatus
ffffffffc0201cf0:	8b89                	andi	a5,a5,2
ffffffffc0201cf2:	e799                	bnez	a5,ffffffffc0201d00 <nr_free_pages+0x14>
ffffffffc0201cf4:	0000b797          	auipc	a5,0xb
ffffffffc0201cf8:	7ac7b783          	ld	a5,1964(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201cfc:	779c                	ld	a5,40(a5)
ffffffffc0201cfe:	8782                	jr	a5
ffffffffc0201d00:	1101                	addi	sp,sp,-32
ffffffffc0201d02:	ec06                	sd	ra,24(sp)
ffffffffc0201d04:	b71fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201d08:	0000b797          	auipc	a5,0xb
ffffffffc0201d0c:	7987b783          	ld	a5,1944(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d10:	779c                	ld	a5,40(a5)
ffffffffc0201d12:	9782                	jalr	a5
ffffffffc0201d14:	e42a                	sd	a0,8(sp)
ffffffffc0201d16:	b59fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201d1a:	60e2                	ld	ra,24(sp)
ffffffffc0201d1c:	6522                	ld	a0,8(sp)
ffffffffc0201d1e:	6105                	addi	sp,sp,32
ffffffffc0201d20:	8082                	ret

ffffffffc0201d22 <get_pte>:
ffffffffc0201d22:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201d26:	1ff7f793          	andi	a5,a5,511
ffffffffc0201d2a:	078e                	slli	a5,a5,0x3
ffffffffc0201d2c:	00f50733          	add	a4,a0,a5
ffffffffc0201d30:	6314                	ld	a3,0(a4)
ffffffffc0201d32:	7139                	addi	sp,sp,-64
ffffffffc0201d34:	f822                	sd	s0,48(sp)
ffffffffc0201d36:	f426                	sd	s1,40(sp)
ffffffffc0201d38:	fc06                	sd	ra,56(sp)
ffffffffc0201d3a:	0016f793          	andi	a5,a3,1
ffffffffc0201d3e:	842e                	mv	s0,a1
ffffffffc0201d40:	8832                	mv	a6,a2
ffffffffc0201d42:	0000b497          	auipc	s1,0xb
ffffffffc0201d46:	77e48493          	addi	s1,s1,1918 # ffffffffc020d4c0 <npage>
ffffffffc0201d4a:	ebd1                	bnez	a5,ffffffffc0201dde <get_pte+0xbc>
ffffffffc0201d4c:	16060d63          	beqz	a2,ffffffffc0201ec6 <get_pte+0x1a4>
ffffffffc0201d50:	100027f3          	csrr	a5,sstatus
ffffffffc0201d54:	8b89                	andi	a5,a5,2
ffffffffc0201d56:	16079e63          	bnez	a5,ffffffffc0201ed2 <get_pte+0x1b0>
ffffffffc0201d5a:	0000b797          	auipc	a5,0xb
ffffffffc0201d5e:	7467b783          	ld	a5,1862(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d62:	4505                	li	a0,1
ffffffffc0201d64:	e43a                	sd	a4,8(sp)
ffffffffc0201d66:	6f9c                	ld	a5,24(a5)
ffffffffc0201d68:	e832                	sd	a2,16(sp)
ffffffffc0201d6a:	9782                	jalr	a5
ffffffffc0201d6c:	6722                	ld	a4,8(sp)
ffffffffc0201d6e:	6842                	ld	a6,16(sp)
ffffffffc0201d70:	87aa                	mv	a5,a0
ffffffffc0201d72:	14078a63          	beqz	a5,ffffffffc0201ec6 <get_pte+0x1a4>
ffffffffc0201d76:	0000b517          	auipc	a0,0xb
ffffffffc0201d7a:	75253503          	ld	a0,1874(a0) # ffffffffc020d4c8 <pages>
ffffffffc0201d7e:	000808b7          	lui	a7,0x80
ffffffffc0201d82:	0000b497          	auipc	s1,0xb
ffffffffc0201d86:	73e48493          	addi	s1,s1,1854 # ffffffffc020d4c0 <npage>
ffffffffc0201d8a:	40a78533          	sub	a0,a5,a0
ffffffffc0201d8e:	8519                	srai	a0,a0,0x6
ffffffffc0201d90:	9546                	add	a0,a0,a7
ffffffffc0201d92:	6090                	ld	a2,0(s1)
ffffffffc0201d94:	00c51693          	slli	a3,a0,0xc
ffffffffc0201d98:	4585                	li	a1,1
ffffffffc0201d9a:	82b1                	srli	a3,a3,0xc
ffffffffc0201d9c:	c38c                	sw	a1,0(a5)
ffffffffc0201d9e:	0532                	slli	a0,a0,0xc
ffffffffc0201da0:	1ac6f763          	bgeu	a3,a2,ffffffffc0201f4e <get_pte+0x22c>
ffffffffc0201da4:	0000b697          	auipc	a3,0xb
ffffffffc0201da8:	7146b683          	ld	a3,1812(a3) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201dac:	6605                	lui	a2,0x1
ffffffffc0201dae:	4581                	li	a1,0
ffffffffc0201db0:	9536                	add	a0,a0,a3
ffffffffc0201db2:	ec42                	sd	a6,24(sp)
ffffffffc0201db4:	e83e                	sd	a5,16(sp)
ffffffffc0201db6:	e43a                	sd	a4,8(sp)
ffffffffc0201db8:	084020ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0201dbc:	0000b697          	auipc	a3,0xb
ffffffffc0201dc0:	70c6b683          	ld	a3,1804(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201dc4:	67c2                	ld	a5,16(sp)
ffffffffc0201dc6:	000808b7          	lui	a7,0x80
ffffffffc0201dca:	6722                	ld	a4,8(sp)
ffffffffc0201dcc:	40d786b3          	sub	a3,a5,a3
ffffffffc0201dd0:	8699                	srai	a3,a3,0x6
ffffffffc0201dd2:	96c6                	add	a3,a3,a7
ffffffffc0201dd4:	06aa                	slli	a3,a3,0xa
ffffffffc0201dd6:	6862                	ld	a6,24(sp)
ffffffffc0201dd8:	0116e693          	ori	a3,a3,17
ffffffffc0201ddc:	e314                	sd	a3,0(a4)
ffffffffc0201dde:	c006f693          	andi	a3,a3,-1024
ffffffffc0201de2:	6098                	ld	a4,0(s1)
ffffffffc0201de4:	068a                	slli	a3,a3,0x2
ffffffffc0201de6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201dea:	14e7f663          	bgeu	a5,a4,ffffffffc0201f36 <get_pte+0x214>
ffffffffc0201dee:	0000b897          	auipc	a7,0xb
ffffffffc0201df2:	6ca88893          	addi	a7,a7,1738 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201df6:	0008b603          	ld	a2,0(a7)
ffffffffc0201dfa:	01545793          	srli	a5,s0,0x15
ffffffffc0201dfe:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e02:	96b2                	add	a3,a3,a2
ffffffffc0201e04:	078e                	slli	a5,a5,0x3
ffffffffc0201e06:	97b6                	add	a5,a5,a3
ffffffffc0201e08:	6394                	ld	a3,0(a5)
ffffffffc0201e0a:	0016f613          	andi	a2,a3,1
ffffffffc0201e0e:	e659                	bnez	a2,ffffffffc0201e9c <get_pte+0x17a>
ffffffffc0201e10:	0a080b63          	beqz	a6,ffffffffc0201ec6 <get_pte+0x1a4>
ffffffffc0201e14:	10002773          	csrr	a4,sstatus
ffffffffc0201e18:	8b09                	andi	a4,a4,2
ffffffffc0201e1a:	ef71                	bnez	a4,ffffffffc0201ef6 <get_pte+0x1d4>
ffffffffc0201e1c:	0000b717          	auipc	a4,0xb
ffffffffc0201e20:	68473703          	ld	a4,1668(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201e24:	4505                	li	a0,1
ffffffffc0201e26:	e43e                	sd	a5,8(sp)
ffffffffc0201e28:	6f18                	ld	a4,24(a4)
ffffffffc0201e2a:	9702                	jalr	a4
ffffffffc0201e2c:	67a2                	ld	a5,8(sp)
ffffffffc0201e2e:	872a                	mv	a4,a0
ffffffffc0201e30:	0000b897          	auipc	a7,0xb
ffffffffc0201e34:	68888893          	addi	a7,a7,1672 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201e38:	c759                	beqz	a4,ffffffffc0201ec6 <get_pte+0x1a4>
ffffffffc0201e3a:	0000b697          	auipc	a3,0xb
ffffffffc0201e3e:	68e6b683          	ld	a3,1678(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201e42:	00080837          	lui	a6,0x80
ffffffffc0201e46:	608c                	ld	a1,0(s1)
ffffffffc0201e48:	40d706b3          	sub	a3,a4,a3
ffffffffc0201e4c:	8699                	srai	a3,a3,0x6
ffffffffc0201e4e:	96c2                	add	a3,a3,a6
ffffffffc0201e50:	00c69613          	slli	a2,a3,0xc
ffffffffc0201e54:	4505                	li	a0,1
ffffffffc0201e56:	8231                	srli	a2,a2,0xc
ffffffffc0201e58:	c308                	sw	a0,0(a4)
ffffffffc0201e5a:	06b2                	slli	a3,a3,0xc
ffffffffc0201e5c:	10b67663          	bgeu	a2,a1,ffffffffc0201f68 <get_pte+0x246>
ffffffffc0201e60:	0008b503          	ld	a0,0(a7)
ffffffffc0201e64:	6605                	lui	a2,0x1
ffffffffc0201e66:	4581                	li	a1,0
ffffffffc0201e68:	9536                	add	a0,a0,a3
ffffffffc0201e6a:	e83a                	sd	a4,16(sp)
ffffffffc0201e6c:	e43e                	sd	a5,8(sp)
ffffffffc0201e6e:	7cf010ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0201e72:	0000b697          	auipc	a3,0xb
ffffffffc0201e76:	6566b683          	ld	a3,1622(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201e7a:	6742                	ld	a4,16(sp)
ffffffffc0201e7c:	00080837          	lui	a6,0x80
ffffffffc0201e80:	67a2                	ld	a5,8(sp)
ffffffffc0201e82:	40d706b3          	sub	a3,a4,a3
ffffffffc0201e86:	8699                	srai	a3,a3,0x6
ffffffffc0201e88:	96c2                	add	a3,a3,a6
ffffffffc0201e8a:	06aa                	slli	a3,a3,0xa
ffffffffc0201e8c:	0116e693          	ori	a3,a3,17
ffffffffc0201e90:	e394                	sd	a3,0(a5)
ffffffffc0201e92:	6098                	ld	a4,0(s1)
ffffffffc0201e94:	0000b897          	auipc	a7,0xb
ffffffffc0201e98:	62488893          	addi	a7,a7,1572 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201e9c:	c006f693          	andi	a3,a3,-1024
ffffffffc0201ea0:	068a                	slli	a3,a3,0x2
ffffffffc0201ea2:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ea6:	06e7fc63          	bgeu	a5,a4,ffffffffc0201f1e <get_pte+0x1fc>
ffffffffc0201eaa:	0008b783          	ld	a5,0(a7)
ffffffffc0201eae:	8031                	srli	s0,s0,0xc
ffffffffc0201eb0:	1ff47413          	andi	s0,s0,511
ffffffffc0201eb4:	040e                	slli	s0,s0,0x3
ffffffffc0201eb6:	96be                	add	a3,a3,a5
ffffffffc0201eb8:	70e2                	ld	ra,56(sp)
ffffffffc0201eba:	00868533          	add	a0,a3,s0
ffffffffc0201ebe:	7442                	ld	s0,48(sp)
ffffffffc0201ec0:	74a2                	ld	s1,40(sp)
ffffffffc0201ec2:	6121                	addi	sp,sp,64
ffffffffc0201ec4:	8082                	ret
ffffffffc0201ec6:	70e2                	ld	ra,56(sp)
ffffffffc0201ec8:	7442                	ld	s0,48(sp)
ffffffffc0201eca:	74a2                	ld	s1,40(sp)
ffffffffc0201ecc:	4501                	li	a0,0
ffffffffc0201ece:	6121                	addi	sp,sp,64
ffffffffc0201ed0:	8082                	ret
ffffffffc0201ed2:	e83a                	sd	a4,16(sp)
ffffffffc0201ed4:	ec32                	sd	a2,24(sp)
ffffffffc0201ed6:	99ffe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201eda:	0000b797          	auipc	a5,0xb
ffffffffc0201ede:	5c67b783          	ld	a5,1478(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201ee2:	4505                	li	a0,1
ffffffffc0201ee4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ee6:	9782                	jalr	a5
ffffffffc0201ee8:	e42a                	sd	a0,8(sp)
ffffffffc0201eea:	985fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201eee:	6862                	ld	a6,24(sp)
ffffffffc0201ef0:	6742                	ld	a4,16(sp)
ffffffffc0201ef2:	67a2                	ld	a5,8(sp)
ffffffffc0201ef4:	bdbd                	j	ffffffffc0201d72 <get_pte+0x50>
ffffffffc0201ef6:	e83e                	sd	a5,16(sp)
ffffffffc0201ef8:	97dfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0201efc:	0000b717          	auipc	a4,0xb
ffffffffc0201f00:	5a473703          	ld	a4,1444(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201f04:	4505                	li	a0,1
ffffffffc0201f06:	6f18                	ld	a4,24(a4)
ffffffffc0201f08:	9702                	jalr	a4
ffffffffc0201f0a:	e42a                	sd	a0,8(sp)
ffffffffc0201f0c:	963fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201f10:	6722                	ld	a4,8(sp)
ffffffffc0201f12:	67c2                	ld	a5,16(sp)
ffffffffc0201f14:	0000b897          	auipc	a7,0xb
ffffffffc0201f18:	5a488893          	addi	a7,a7,1444 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201f1c:	bf31                	j	ffffffffc0201e38 <get_pte+0x116>
ffffffffc0201f1e:	00003617          	auipc	a2,0x3
ffffffffc0201f22:	cf260613          	addi	a2,a2,-782 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0201f26:	0fb00593          	li	a1,251
ffffffffc0201f2a:	00003517          	auipc	a0,0x3
ffffffffc0201f2e:	dd650513          	addi	a0,a0,-554 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0201f32:	cd4fe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0201f36:	00003617          	auipc	a2,0x3
ffffffffc0201f3a:	cda60613          	addi	a2,a2,-806 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0201f3e:	0ee00593          	li	a1,238
ffffffffc0201f42:	00003517          	auipc	a0,0x3
ffffffffc0201f46:	dbe50513          	addi	a0,a0,-578 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0201f4a:	cbcfe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0201f4e:	86aa                	mv	a3,a0
ffffffffc0201f50:	00003617          	auipc	a2,0x3
ffffffffc0201f54:	cc060613          	addi	a2,a2,-832 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0201f58:	0eb00593          	li	a1,235
ffffffffc0201f5c:	00003517          	auipc	a0,0x3
ffffffffc0201f60:	da450513          	addi	a0,a0,-604 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0201f64:	ca2fe0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0201f68:	00003617          	auipc	a2,0x3
ffffffffc0201f6c:	ca860613          	addi	a2,a2,-856 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0201f70:	0f800593          	li	a1,248
ffffffffc0201f74:	00003517          	auipc	a0,0x3
ffffffffc0201f78:	d8c50513          	addi	a0,a0,-628 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0201f7c:	c8afe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201f80 <get_page>:
ffffffffc0201f80:	1141                	addi	sp,sp,-16
ffffffffc0201f82:	e022                	sd	s0,0(sp)
ffffffffc0201f84:	8432                	mv	s0,a2
ffffffffc0201f86:	4601                	li	a2,0
ffffffffc0201f88:	e406                	sd	ra,8(sp)
ffffffffc0201f8a:	d99ff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc0201f8e:	c011                	beqz	s0,ffffffffc0201f92 <get_page+0x12>
ffffffffc0201f90:	e008                	sd	a0,0(s0)
ffffffffc0201f92:	c511                	beqz	a0,ffffffffc0201f9e <get_page+0x1e>
ffffffffc0201f94:	611c                	ld	a5,0(a0)
ffffffffc0201f96:	4501                	li	a0,0
ffffffffc0201f98:	0017f713          	andi	a4,a5,1
ffffffffc0201f9c:	e709                	bnez	a4,ffffffffc0201fa6 <get_page+0x26>
ffffffffc0201f9e:	60a2                	ld	ra,8(sp)
ffffffffc0201fa0:	6402                	ld	s0,0(sp)
ffffffffc0201fa2:	0141                	addi	sp,sp,16
ffffffffc0201fa4:	8082                	ret
ffffffffc0201fa6:	0000b717          	auipc	a4,0xb
ffffffffc0201faa:	51a73703          	ld	a4,1306(a4) # ffffffffc020d4c0 <npage>
ffffffffc0201fae:	078a                	slli	a5,a5,0x2
ffffffffc0201fb0:	83b1                	srli	a5,a5,0xc
ffffffffc0201fb2:	00e7ff63          	bgeu	a5,a4,ffffffffc0201fd0 <get_page+0x50>
ffffffffc0201fb6:	0000b517          	auipc	a0,0xb
ffffffffc0201fba:	51253503          	ld	a0,1298(a0) # ffffffffc020d4c8 <pages>
ffffffffc0201fbe:	60a2                	ld	ra,8(sp)
ffffffffc0201fc0:	6402                	ld	s0,0(sp)
ffffffffc0201fc2:	079a                	slli	a5,a5,0x6
ffffffffc0201fc4:	fe000737          	lui	a4,0xfe000
ffffffffc0201fc8:	97ba                	add	a5,a5,a4
ffffffffc0201fca:	953e                	add	a0,a0,a5
ffffffffc0201fcc:	0141                	addi	sp,sp,16
ffffffffc0201fce:	8082                	ret
ffffffffc0201fd0:	c8fff0ef          	jal	ffffffffc0201c5e <pa2page.part.0>

ffffffffc0201fd4 <page_remove>:
ffffffffc0201fd4:	1101                	addi	sp,sp,-32
ffffffffc0201fd6:	4601                	li	a2,0
ffffffffc0201fd8:	e822                	sd	s0,16(sp)
ffffffffc0201fda:	ec06                	sd	ra,24(sp)
ffffffffc0201fdc:	842e                	mv	s0,a1
ffffffffc0201fde:	d45ff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc0201fe2:	c511                	beqz	a0,ffffffffc0201fee <page_remove+0x1a>
ffffffffc0201fe4:	6118                	ld	a4,0(a0)
ffffffffc0201fe6:	87aa                	mv	a5,a0
ffffffffc0201fe8:	00177693          	andi	a3,a4,1
ffffffffc0201fec:	e689                	bnez	a3,ffffffffc0201ff6 <page_remove+0x22>
ffffffffc0201fee:	60e2                	ld	ra,24(sp)
ffffffffc0201ff0:	6442                	ld	s0,16(sp)
ffffffffc0201ff2:	6105                	addi	sp,sp,32
ffffffffc0201ff4:	8082                	ret
ffffffffc0201ff6:	0000b697          	auipc	a3,0xb
ffffffffc0201ffa:	4ca6b683          	ld	a3,1226(a3) # ffffffffc020d4c0 <npage>
ffffffffc0201ffe:	070a                	slli	a4,a4,0x2
ffffffffc0202000:	8331                	srli	a4,a4,0xc
ffffffffc0202002:	06d77563          	bgeu	a4,a3,ffffffffc020206c <page_remove+0x98>
ffffffffc0202006:	0000b517          	auipc	a0,0xb
ffffffffc020200a:	4c253503          	ld	a0,1218(a0) # ffffffffc020d4c8 <pages>
ffffffffc020200e:	071a                	slli	a4,a4,0x6
ffffffffc0202010:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202014:	9736                	add	a4,a4,a3
ffffffffc0202016:	953a                	add	a0,a0,a4
ffffffffc0202018:	4118                	lw	a4,0(a0)
ffffffffc020201a:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3ddf2b0f>
ffffffffc020201c:	c118                	sw	a4,0(a0)
ffffffffc020201e:	cb09                	beqz	a4,ffffffffc0202030 <page_remove+0x5c>
ffffffffc0202020:	0007b023          	sd	zero,0(a5)
ffffffffc0202024:	12040073          	sfence.vma	s0
ffffffffc0202028:	60e2                	ld	ra,24(sp)
ffffffffc020202a:	6442                	ld	s0,16(sp)
ffffffffc020202c:	6105                	addi	sp,sp,32
ffffffffc020202e:	8082                	ret
ffffffffc0202030:	10002773          	csrr	a4,sstatus
ffffffffc0202034:	8b09                	andi	a4,a4,2
ffffffffc0202036:	eb19                	bnez	a4,ffffffffc020204c <page_remove+0x78>
ffffffffc0202038:	0000b717          	auipc	a4,0xb
ffffffffc020203c:	46873703          	ld	a4,1128(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202040:	4585                	li	a1,1
ffffffffc0202042:	e03e                	sd	a5,0(sp)
ffffffffc0202044:	7318                	ld	a4,32(a4)
ffffffffc0202046:	9702                	jalr	a4
ffffffffc0202048:	6782                	ld	a5,0(sp)
ffffffffc020204a:	bfd9                	j	ffffffffc0202020 <page_remove+0x4c>
ffffffffc020204c:	e43e                	sd	a5,8(sp)
ffffffffc020204e:	e02a                	sd	a0,0(sp)
ffffffffc0202050:	825fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202054:	0000b717          	auipc	a4,0xb
ffffffffc0202058:	44c73703          	ld	a4,1100(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc020205c:	6502                	ld	a0,0(sp)
ffffffffc020205e:	4585                	li	a1,1
ffffffffc0202060:	7318                	ld	a4,32(a4)
ffffffffc0202062:	9702                	jalr	a4
ffffffffc0202064:	80bfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202068:	67a2                	ld	a5,8(sp)
ffffffffc020206a:	bf5d                	j	ffffffffc0202020 <page_remove+0x4c>
ffffffffc020206c:	bf3ff0ef          	jal	ffffffffc0201c5e <pa2page.part.0>

ffffffffc0202070 <page_insert>:
ffffffffc0202070:	7139                	addi	sp,sp,-64
ffffffffc0202072:	f426                	sd	s1,40(sp)
ffffffffc0202074:	84b2                	mv	s1,a2
ffffffffc0202076:	f822                	sd	s0,48(sp)
ffffffffc0202078:	4605                	li	a2,1
ffffffffc020207a:	842e                	mv	s0,a1
ffffffffc020207c:	85a6                	mv	a1,s1
ffffffffc020207e:	fc06                	sd	ra,56(sp)
ffffffffc0202080:	e436                	sd	a3,8(sp)
ffffffffc0202082:	ca1ff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc0202086:	cd61                	beqz	a0,ffffffffc020215e <page_insert+0xee>
ffffffffc0202088:	400c                	lw	a1,0(s0)
ffffffffc020208a:	611c                	ld	a5,0(a0)
ffffffffc020208c:	66a2                	ld	a3,8(sp)
ffffffffc020208e:	0015861b          	addiw	a2,a1,1 # 1001 <kern_entry-0xffffffffc01fefff>
ffffffffc0202092:	c010                	sw	a2,0(s0)
ffffffffc0202094:	0017f613          	andi	a2,a5,1
ffffffffc0202098:	872a                	mv	a4,a0
ffffffffc020209a:	e61d                	bnez	a2,ffffffffc02020c8 <page_insert+0x58>
ffffffffc020209c:	0000b617          	auipc	a2,0xb
ffffffffc02020a0:	42c63603          	ld	a2,1068(a2) # ffffffffc020d4c8 <pages>
ffffffffc02020a4:	8c11                	sub	s0,s0,a2
ffffffffc02020a6:	8419                	srai	s0,s0,0x6
ffffffffc02020a8:	200007b7          	lui	a5,0x20000
ffffffffc02020ac:	042a                	slli	s0,s0,0xa
ffffffffc02020ae:	943e                	add	s0,s0,a5
ffffffffc02020b0:	8ec1                	or	a3,a3,s0
ffffffffc02020b2:	0016e693          	ori	a3,a3,1
ffffffffc02020b6:	e314                	sd	a3,0(a4)
ffffffffc02020b8:	12048073          	sfence.vma	s1
ffffffffc02020bc:	4501                	li	a0,0
ffffffffc02020be:	70e2                	ld	ra,56(sp)
ffffffffc02020c0:	7442                	ld	s0,48(sp)
ffffffffc02020c2:	74a2                	ld	s1,40(sp)
ffffffffc02020c4:	6121                	addi	sp,sp,64
ffffffffc02020c6:	8082                	ret
ffffffffc02020c8:	0000b617          	auipc	a2,0xb
ffffffffc02020cc:	3f863603          	ld	a2,1016(a2) # ffffffffc020d4c0 <npage>
ffffffffc02020d0:	078a                	slli	a5,a5,0x2
ffffffffc02020d2:	83b1                	srli	a5,a5,0xc
ffffffffc02020d4:	08c7f763          	bgeu	a5,a2,ffffffffc0202162 <page_insert+0xf2>
ffffffffc02020d8:	0000b617          	auipc	a2,0xb
ffffffffc02020dc:	3f063603          	ld	a2,1008(a2) # ffffffffc020d4c8 <pages>
ffffffffc02020e0:	fe000537          	lui	a0,0xfe000
ffffffffc02020e4:	079a                	slli	a5,a5,0x6
ffffffffc02020e6:	97aa                	add	a5,a5,a0
ffffffffc02020e8:	00f60533          	add	a0,a2,a5
ffffffffc02020ec:	00a40963          	beq	s0,a0,ffffffffc02020fe <page_insert+0x8e>
ffffffffc02020f0:	411c                	lw	a5,0(a0)
ffffffffc02020f2:	37fd                	addiw	a5,a5,-1 # 1fffffff <kern_entry-0xffffffffa0200001>
ffffffffc02020f4:	c11c                	sw	a5,0(a0)
ffffffffc02020f6:	c791                	beqz	a5,ffffffffc0202102 <page_insert+0x92>
ffffffffc02020f8:	12048073          	sfence.vma	s1
ffffffffc02020fc:	b765                	j	ffffffffc02020a4 <page_insert+0x34>
ffffffffc02020fe:	c00c                	sw	a1,0(s0)
ffffffffc0202100:	b755                	j	ffffffffc02020a4 <page_insert+0x34>
ffffffffc0202102:	100027f3          	csrr	a5,sstatus
ffffffffc0202106:	8b89                	andi	a5,a5,2
ffffffffc0202108:	e39d                	bnez	a5,ffffffffc020212e <page_insert+0xbe>
ffffffffc020210a:	0000b797          	auipc	a5,0xb
ffffffffc020210e:	3967b783          	ld	a5,918(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202112:	4585                	li	a1,1
ffffffffc0202114:	e83a                	sd	a4,16(sp)
ffffffffc0202116:	739c                	ld	a5,32(a5)
ffffffffc0202118:	e436                	sd	a3,8(sp)
ffffffffc020211a:	9782                	jalr	a5
ffffffffc020211c:	0000b617          	auipc	a2,0xb
ffffffffc0202120:	3ac63603          	ld	a2,940(a2) # ffffffffc020d4c8 <pages>
ffffffffc0202124:	66a2                	ld	a3,8(sp)
ffffffffc0202126:	6742                	ld	a4,16(sp)
ffffffffc0202128:	12048073          	sfence.vma	s1
ffffffffc020212c:	bfa5                	j	ffffffffc02020a4 <page_insert+0x34>
ffffffffc020212e:	ec3a                	sd	a4,24(sp)
ffffffffc0202130:	e836                	sd	a3,16(sp)
ffffffffc0202132:	e42a                	sd	a0,8(sp)
ffffffffc0202134:	f40fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202138:	0000b797          	auipc	a5,0xb
ffffffffc020213c:	3687b783          	ld	a5,872(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202140:	6522                	ld	a0,8(sp)
ffffffffc0202142:	4585                	li	a1,1
ffffffffc0202144:	739c                	ld	a5,32(a5)
ffffffffc0202146:	9782                	jalr	a5
ffffffffc0202148:	f26fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020214c:	0000b617          	auipc	a2,0xb
ffffffffc0202150:	37c63603          	ld	a2,892(a2) # ffffffffc020d4c8 <pages>
ffffffffc0202154:	6762                	ld	a4,24(sp)
ffffffffc0202156:	66c2                	ld	a3,16(sp)
ffffffffc0202158:	12048073          	sfence.vma	s1
ffffffffc020215c:	b7a1                	j	ffffffffc02020a4 <page_insert+0x34>
ffffffffc020215e:	5571                	li	a0,-4
ffffffffc0202160:	bfb9                	j	ffffffffc02020be <page_insert+0x4e>
ffffffffc0202162:	afdff0ef          	jal	ffffffffc0201c5e <pa2page.part.0>

ffffffffc0202166 <pmm_init>:
ffffffffc0202166:	00003797          	auipc	a5,0x3
ffffffffc020216a:	6b278793          	addi	a5,a5,1714 # ffffffffc0205818 <default_pmm_manager>
ffffffffc020216e:	638c                	ld	a1,0(a5)
ffffffffc0202170:	7159                	addi	sp,sp,-112
ffffffffc0202172:	f486                	sd	ra,104(sp)
ffffffffc0202174:	e8ca                	sd	s2,80(sp)
ffffffffc0202176:	e4ce                	sd	s3,72(sp)
ffffffffc0202178:	f85a                	sd	s6,48(sp)
ffffffffc020217a:	f0a2                	sd	s0,96(sp)
ffffffffc020217c:	eca6                	sd	s1,88(sp)
ffffffffc020217e:	e0d2                	sd	s4,64(sp)
ffffffffc0202180:	fc56                	sd	s5,56(sp)
ffffffffc0202182:	f45e                	sd	s7,40(sp)
ffffffffc0202184:	f062                	sd	s8,32(sp)
ffffffffc0202186:	ec66                	sd	s9,24(sp)
ffffffffc0202188:	0000bb17          	auipc	s6,0xb
ffffffffc020218c:	318b0b13          	addi	s6,s6,792 # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202190:	00003517          	auipc	a0,0x3
ffffffffc0202194:	b8050513          	addi	a0,a0,-1152 # ffffffffc0204d10 <etext+0xe86>
ffffffffc0202198:	00fb3023          	sd	a5,0(s6)
ffffffffc020219c:	ff9fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02021a0:	000b3783          	ld	a5,0(s6)
ffffffffc02021a4:	0000b997          	auipc	s3,0xb
ffffffffc02021a8:	31498993          	addi	s3,s3,788 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc02021ac:	679c                	ld	a5,8(a5)
ffffffffc02021ae:	9782                	jalr	a5
ffffffffc02021b0:	57f5                	li	a5,-3
ffffffffc02021b2:	07fa                	slli	a5,a5,0x1e
ffffffffc02021b4:	00f9b023          	sd	a5,0(s3)
ffffffffc02021b8:	ea2fe0ef          	jal	ffffffffc020085a <get_memory_base>
ffffffffc02021bc:	892a                	mv	s2,a0
ffffffffc02021be:	ea6fe0ef          	jal	ffffffffc0200864 <get_memory_size>
ffffffffc02021c2:	70050e63          	beqz	a0,ffffffffc02028de <pmm_init+0x778>
ffffffffc02021c6:	84aa                	mv	s1,a0
ffffffffc02021c8:	00003517          	auipc	a0,0x3
ffffffffc02021cc:	b8050513          	addi	a0,a0,-1152 # ffffffffc0204d48 <etext+0xebe>
ffffffffc02021d0:	fc5fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02021d4:	00990433          	add	s0,s2,s1
ffffffffc02021d8:	864a                	mv	a2,s2
ffffffffc02021da:	85a6                	mv	a1,s1
ffffffffc02021dc:	fff40693          	addi	a3,s0,-1
ffffffffc02021e0:	00003517          	auipc	a0,0x3
ffffffffc02021e4:	b8050513          	addi	a0,a0,-1152 # ffffffffc0204d60 <etext+0xed6>
ffffffffc02021e8:	fadfd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02021ec:	c80007b7          	lui	a5,0xc8000
ffffffffc02021f0:	8522                	mv	a0,s0
ffffffffc02021f2:	5287ed63          	bltu	a5,s0,ffffffffc020272c <pmm_init+0x5c6>
ffffffffc02021f6:	77fd                	lui	a5,0xfffff
ffffffffc02021f8:	0000c617          	auipc	a2,0xc
ffffffffc02021fc:	2f760613          	addi	a2,a2,759 # ffffffffc020e4ef <end+0xfff>
ffffffffc0202200:	8e7d                	and	a2,a2,a5
ffffffffc0202202:	8131                	srli	a0,a0,0xc
ffffffffc0202204:	0000bb97          	auipc	s7,0xb
ffffffffc0202208:	2c4b8b93          	addi	s7,s7,708 # ffffffffc020d4c8 <pages>
ffffffffc020220c:	0000b497          	auipc	s1,0xb
ffffffffc0202210:	2b448493          	addi	s1,s1,692 # ffffffffc020d4c0 <npage>
ffffffffc0202214:	00cbb023          	sd	a2,0(s7)
ffffffffc0202218:	e088                	sd	a0,0(s1)
ffffffffc020221a:	000807b7          	lui	a5,0x80
ffffffffc020221e:	86b2                	mv	a3,a2
ffffffffc0202220:	02f50763          	beq	a0,a5,ffffffffc020224e <pmm_init+0xe8>
ffffffffc0202224:	4701                	li	a4,0
ffffffffc0202226:	4585                	li	a1,1
ffffffffc0202228:	fff806b7          	lui	a3,0xfff80
ffffffffc020222c:	00671793          	slli	a5,a4,0x6
ffffffffc0202230:	97b2                	add	a5,a5,a2
ffffffffc0202232:	07a1                	addi	a5,a5,8 # 80008 <kern_entry-0xffffffffc017fff8>
ffffffffc0202234:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202238:	6088                	ld	a0,0(s1)
ffffffffc020223a:	0705                	addi	a4,a4,1
ffffffffc020223c:	000bb603          	ld	a2,0(s7)
ffffffffc0202240:	00d507b3          	add	a5,a0,a3
ffffffffc0202244:	fef764e3          	bltu	a4,a5,ffffffffc020222c <pmm_init+0xc6>
ffffffffc0202248:	079a                	slli	a5,a5,0x6
ffffffffc020224a:	00f606b3          	add	a3,a2,a5
ffffffffc020224e:	c02007b7          	lui	a5,0xc0200
ffffffffc0202252:	16f6eee3          	bltu	a3,a5,ffffffffc0202bce <pmm_init+0xa68>
ffffffffc0202256:	0009b583          	ld	a1,0(s3)
ffffffffc020225a:	77fd                	lui	a5,0xfffff
ffffffffc020225c:	8c7d                	and	s0,s0,a5
ffffffffc020225e:	8e8d                	sub	a3,a3,a1
ffffffffc0202260:	4e86ed63          	bltu	a3,s0,ffffffffc020275a <pmm_init+0x5f4>
ffffffffc0202264:	00003517          	auipc	a0,0x3
ffffffffc0202268:	b2450513          	addi	a0,a0,-1244 # ffffffffc0204d88 <etext+0xefe>
ffffffffc020226c:	f29fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202270:	000b3783          	ld	a5,0(s6)
ffffffffc0202274:	0000b917          	auipc	s2,0xb
ffffffffc0202278:	23c90913          	addi	s2,s2,572 # ffffffffc020d4b0 <boot_pgdir_va>
ffffffffc020227c:	7b9c                	ld	a5,48(a5)
ffffffffc020227e:	9782                	jalr	a5
ffffffffc0202280:	00003517          	auipc	a0,0x3
ffffffffc0202284:	b2050513          	addi	a0,a0,-1248 # ffffffffc0204da0 <etext+0xf16>
ffffffffc0202288:	f0dfd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020228c:	00006697          	auipc	a3,0x6
ffffffffc0202290:	d7468693          	addi	a3,a3,-652 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202294:	00d93023          	sd	a3,0(s2)
ffffffffc0202298:	c02007b7          	lui	a5,0xc0200
ffffffffc020229c:	2af6eee3          	bltu	a3,a5,ffffffffc0202d58 <pmm_init+0xbf2>
ffffffffc02022a0:	0009b783          	ld	a5,0(s3)
ffffffffc02022a4:	8e9d                	sub	a3,a3,a5
ffffffffc02022a6:	0000b797          	auipc	a5,0xb
ffffffffc02022aa:	20d7b123          	sd	a3,514(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
ffffffffc02022ae:	100027f3          	csrr	a5,sstatus
ffffffffc02022b2:	8b89                	andi	a5,a5,2
ffffffffc02022b4:	48079963          	bnez	a5,ffffffffc0202746 <pmm_init+0x5e0>
ffffffffc02022b8:	000b3783          	ld	a5,0(s6)
ffffffffc02022bc:	779c                	ld	a5,40(a5)
ffffffffc02022be:	9782                	jalr	a5
ffffffffc02022c0:	842a                	mv	s0,a0
ffffffffc02022c2:	6098                	ld	a4,0(s1)
ffffffffc02022c4:	c80007b7          	lui	a5,0xc8000
ffffffffc02022c8:	83b1                	srli	a5,a5,0xc
ffffffffc02022ca:	66e7e663          	bltu	a5,a4,ffffffffc0202936 <pmm_init+0x7d0>
ffffffffc02022ce:	00093503          	ld	a0,0(s2)
ffffffffc02022d2:	64050263          	beqz	a0,ffffffffc0202916 <pmm_init+0x7b0>
ffffffffc02022d6:	03451793          	slli	a5,a0,0x34
ffffffffc02022da:	62079e63          	bnez	a5,ffffffffc0202916 <pmm_init+0x7b0>
ffffffffc02022de:	4601                	li	a2,0
ffffffffc02022e0:	4581                	li	a1,0
ffffffffc02022e2:	c9fff0ef          	jal	ffffffffc0201f80 <get_page>
ffffffffc02022e6:	240519e3          	bnez	a0,ffffffffc0202d38 <pmm_init+0xbd2>
ffffffffc02022ea:	100027f3          	csrr	a5,sstatus
ffffffffc02022ee:	8b89                	andi	a5,a5,2
ffffffffc02022f0:	44079063          	bnez	a5,ffffffffc0202730 <pmm_init+0x5ca>
ffffffffc02022f4:	000b3783          	ld	a5,0(s6)
ffffffffc02022f8:	4505                	li	a0,1
ffffffffc02022fa:	6f9c                	ld	a5,24(a5)
ffffffffc02022fc:	9782                	jalr	a5
ffffffffc02022fe:	8a2a                	mv	s4,a0
ffffffffc0202300:	00093503          	ld	a0,0(s2)
ffffffffc0202304:	4681                	li	a3,0
ffffffffc0202306:	4601                	li	a2,0
ffffffffc0202308:	85d2                	mv	a1,s4
ffffffffc020230a:	d67ff0ef          	jal	ffffffffc0202070 <page_insert>
ffffffffc020230e:	280511e3          	bnez	a0,ffffffffc0202d90 <pmm_init+0xc2a>
ffffffffc0202312:	00093503          	ld	a0,0(s2)
ffffffffc0202316:	4601                	li	a2,0
ffffffffc0202318:	4581                	li	a1,0
ffffffffc020231a:	a09ff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc020231e:	240509e3          	beqz	a0,ffffffffc0202d70 <pmm_init+0xc0a>
ffffffffc0202322:	611c                	ld	a5,0(a0)
ffffffffc0202324:	0017f713          	andi	a4,a5,1
ffffffffc0202328:	58070f63          	beqz	a4,ffffffffc02028c6 <pmm_init+0x760>
ffffffffc020232c:	6098                	ld	a4,0(s1)
ffffffffc020232e:	078a                	slli	a5,a5,0x2
ffffffffc0202330:	83b1                	srli	a5,a5,0xc
ffffffffc0202332:	58e7f863          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc0202336:	000bb683          	ld	a3,0(s7)
ffffffffc020233a:	079a                	slli	a5,a5,0x6
ffffffffc020233c:	fe000637          	lui	a2,0xfe000
ffffffffc0202340:	97b2                	add	a5,a5,a2
ffffffffc0202342:	97b6                	add	a5,a5,a3
ffffffffc0202344:	14fa1ae3          	bne	s4,a5,ffffffffc0202c98 <pmm_init+0xb32>
ffffffffc0202348:	000a2683          	lw	a3,0(s4)
ffffffffc020234c:	4785                	li	a5,1
ffffffffc020234e:	12f695e3          	bne	a3,a5,ffffffffc0202c78 <pmm_init+0xb12>
ffffffffc0202352:	00093503          	ld	a0,0(s2)
ffffffffc0202356:	77fd                	lui	a5,0xfffff
ffffffffc0202358:	6114                	ld	a3,0(a0)
ffffffffc020235a:	068a                	slli	a3,a3,0x2
ffffffffc020235c:	8efd                	and	a3,a3,a5
ffffffffc020235e:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202362:	0ee67fe3          	bgeu	a2,a4,ffffffffc0202c60 <pmm_init+0xafa>
ffffffffc0202366:	0009bc03          	ld	s8,0(s3)
ffffffffc020236a:	96e2                	add	a3,a3,s8
ffffffffc020236c:	0006ba83          	ld	s5,0(a3)
ffffffffc0202370:	0a8a                	slli	s5,s5,0x2
ffffffffc0202372:	00fafab3          	and	s5,s5,a5
ffffffffc0202376:	00cad793          	srli	a5,s5,0xc
ffffffffc020237a:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0202c46 <pmm_init+0xae0>
ffffffffc020237e:	4601                	li	a2,0
ffffffffc0202380:	6585                	lui	a1,0x1
ffffffffc0202382:	9c56                	add	s8,s8,s5
ffffffffc0202384:	99fff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc0202388:	0c21                	addi	s8,s8,8
ffffffffc020238a:	05851ee3          	bne	a0,s8,ffffffffc0202be6 <pmm_init+0xa80>
ffffffffc020238e:	100027f3          	csrr	a5,sstatus
ffffffffc0202392:	8b89                	andi	a5,a5,2
ffffffffc0202394:	3e079b63          	bnez	a5,ffffffffc020278a <pmm_init+0x624>
ffffffffc0202398:	000b3783          	ld	a5,0(s6)
ffffffffc020239c:	4505                	li	a0,1
ffffffffc020239e:	6f9c                	ld	a5,24(a5)
ffffffffc02023a0:	9782                	jalr	a5
ffffffffc02023a2:	8c2a                	mv	s8,a0
ffffffffc02023a4:	00093503          	ld	a0,0(s2)
ffffffffc02023a8:	46d1                	li	a3,20
ffffffffc02023aa:	6605                	lui	a2,0x1
ffffffffc02023ac:	85e2                	mv	a1,s8
ffffffffc02023ae:	cc3ff0ef          	jal	ffffffffc0202070 <page_insert>
ffffffffc02023b2:	06051ae3          	bnez	a0,ffffffffc0202c26 <pmm_init+0xac0>
ffffffffc02023b6:	00093503          	ld	a0,0(s2)
ffffffffc02023ba:	4601                	li	a2,0
ffffffffc02023bc:	6585                	lui	a1,0x1
ffffffffc02023be:	965ff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc02023c2:	040502e3          	beqz	a0,ffffffffc0202c06 <pmm_init+0xaa0>
ffffffffc02023c6:	611c                	ld	a5,0(a0)
ffffffffc02023c8:	0107f713          	andi	a4,a5,16
ffffffffc02023cc:	7e070163          	beqz	a4,ffffffffc0202bae <pmm_init+0xa48>
ffffffffc02023d0:	8b91                	andi	a5,a5,4
ffffffffc02023d2:	7a078e63          	beqz	a5,ffffffffc0202b8e <pmm_init+0xa28>
ffffffffc02023d6:	00093503          	ld	a0,0(s2)
ffffffffc02023da:	611c                	ld	a5,0(a0)
ffffffffc02023dc:	8bc1                	andi	a5,a5,16
ffffffffc02023de:	78078863          	beqz	a5,ffffffffc0202b6e <pmm_init+0xa08>
ffffffffc02023e2:	000c2703          	lw	a4,0(s8)
ffffffffc02023e6:	4785                	li	a5,1
ffffffffc02023e8:	76f71363          	bne	a4,a5,ffffffffc0202b4e <pmm_init+0x9e8>
ffffffffc02023ec:	4681                	li	a3,0
ffffffffc02023ee:	6605                	lui	a2,0x1
ffffffffc02023f0:	85d2                	mv	a1,s4
ffffffffc02023f2:	c7fff0ef          	jal	ffffffffc0202070 <page_insert>
ffffffffc02023f6:	72051c63          	bnez	a0,ffffffffc0202b2e <pmm_init+0x9c8>
ffffffffc02023fa:	000a2703          	lw	a4,0(s4)
ffffffffc02023fe:	4789                	li	a5,2
ffffffffc0202400:	70f71763          	bne	a4,a5,ffffffffc0202b0e <pmm_init+0x9a8>
ffffffffc0202404:	000c2783          	lw	a5,0(s8)
ffffffffc0202408:	6e079363          	bnez	a5,ffffffffc0202aee <pmm_init+0x988>
ffffffffc020240c:	00093503          	ld	a0,0(s2)
ffffffffc0202410:	4601                	li	a2,0
ffffffffc0202412:	6585                	lui	a1,0x1
ffffffffc0202414:	90fff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc0202418:	6a050b63          	beqz	a0,ffffffffc0202ace <pmm_init+0x968>
ffffffffc020241c:	6118                	ld	a4,0(a0)
ffffffffc020241e:	00177793          	andi	a5,a4,1
ffffffffc0202422:	4a078263          	beqz	a5,ffffffffc02028c6 <pmm_init+0x760>
ffffffffc0202426:	6094                	ld	a3,0(s1)
ffffffffc0202428:	00271793          	slli	a5,a4,0x2
ffffffffc020242c:	83b1                	srli	a5,a5,0xc
ffffffffc020242e:	48d7fa63          	bgeu	a5,a3,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc0202432:	000bb683          	ld	a3,0(s7)
ffffffffc0202436:	fff80ab7          	lui	s5,0xfff80
ffffffffc020243a:	97d6                	add	a5,a5,s5
ffffffffc020243c:	079a                	slli	a5,a5,0x6
ffffffffc020243e:	97b6                	add	a5,a5,a3
ffffffffc0202440:	66fa1763          	bne	s4,a5,ffffffffc0202aae <pmm_init+0x948>
ffffffffc0202444:	8b41                	andi	a4,a4,16
ffffffffc0202446:	64071463          	bnez	a4,ffffffffc0202a8e <pmm_init+0x928>
ffffffffc020244a:	00093503          	ld	a0,0(s2)
ffffffffc020244e:	4581                	li	a1,0
ffffffffc0202450:	b85ff0ef          	jal	ffffffffc0201fd4 <page_remove>
ffffffffc0202454:	000a2c83          	lw	s9,0(s4)
ffffffffc0202458:	4785                	li	a5,1
ffffffffc020245a:	60fc9a63          	bne	s9,a5,ffffffffc0202a6e <pmm_init+0x908>
ffffffffc020245e:	000c2783          	lw	a5,0(s8)
ffffffffc0202462:	5e079663          	bnez	a5,ffffffffc0202a4e <pmm_init+0x8e8>
ffffffffc0202466:	00093503          	ld	a0,0(s2)
ffffffffc020246a:	6585                	lui	a1,0x1
ffffffffc020246c:	b69ff0ef          	jal	ffffffffc0201fd4 <page_remove>
ffffffffc0202470:	000a2783          	lw	a5,0(s4)
ffffffffc0202474:	52079d63          	bnez	a5,ffffffffc02029ae <pmm_init+0x848>
ffffffffc0202478:	000c2783          	lw	a5,0(s8)
ffffffffc020247c:	50079963          	bnez	a5,ffffffffc020298e <pmm_init+0x828>
ffffffffc0202480:	00093a03          	ld	s4,0(s2)
ffffffffc0202484:	6098                	ld	a4,0(s1)
ffffffffc0202486:	000a3783          	ld	a5,0(s4)
ffffffffc020248a:	078a                	slli	a5,a5,0x2
ffffffffc020248c:	83b1                	srli	a5,a5,0xc
ffffffffc020248e:	42e7fa63          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc0202492:	000bb503          	ld	a0,0(s7)
ffffffffc0202496:	97d6                	add	a5,a5,s5
ffffffffc0202498:	079a                	slli	a5,a5,0x6
ffffffffc020249a:	00f506b3          	add	a3,a0,a5
ffffffffc020249e:	4294                	lw	a3,0(a3)
ffffffffc02024a0:	4d969763          	bne	a3,s9,ffffffffc020296e <pmm_init+0x808>
ffffffffc02024a4:	8799                	srai	a5,a5,0x6
ffffffffc02024a6:	00080637          	lui	a2,0x80
ffffffffc02024aa:	97b2                	add	a5,a5,a2
ffffffffc02024ac:	00c79693          	slli	a3,a5,0xc
ffffffffc02024b0:	4ae7f363          	bgeu	a5,a4,ffffffffc0202956 <pmm_init+0x7f0>
ffffffffc02024b4:	0009b783          	ld	a5,0(s3)
ffffffffc02024b8:	97b6                	add	a5,a5,a3
ffffffffc02024ba:	639c                	ld	a5,0(a5)
ffffffffc02024bc:	078a                	slli	a5,a5,0x2
ffffffffc02024be:	83b1                	srli	a5,a5,0xc
ffffffffc02024c0:	40e7f163          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc02024c4:	8f91                	sub	a5,a5,a2
ffffffffc02024c6:	079a                	slli	a5,a5,0x6
ffffffffc02024c8:	953e                	add	a0,a0,a5
ffffffffc02024ca:	100027f3          	csrr	a5,sstatus
ffffffffc02024ce:	8b89                	andi	a5,a5,2
ffffffffc02024d0:	30079863          	bnez	a5,ffffffffc02027e0 <pmm_init+0x67a>
ffffffffc02024d4:	000b3783          	ld	a5,0(s6)
ffffffffc02024d8:	4585                	li	a1,1
ffffffffc02024da:	739c                	ld	a5,32(a5)
ffffffffc02024dc:	9782                	jalr	a5
ffffffffc02024de:	000a3783          	ld	a5,0(s4)
ffffffffc02024e2:	6098                	ld	a4,0(s1)
ffffffffc02024e4:	078a                	slli	a5,a5,0x2
ffffffffc02024e6:	83b1                	srli	a5,a5,0xc
ffffffffc02024e8:	3ce7fd63          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc02024ec:	000bb503          	ld	a0,0(s7)
ffffffffc02024f0:	fe000737          	lui	a4,0xfe000
ffffffffc02024f4:	079a                	slli	a5,a5,0x6
ffffffffc02024f6:	97ba                	add	a5,a5,a4
ffffffffc02024f8:	953e                	add	a0,a0,a5
ffffffffc02024fa:	100027f3          	csrr	a5,sstatus
ffffffffc02024fe:	8b89                	andi	a5,a5,2
ffffffffc0202500:	2c079463          	bnez	a5,ffffffffc02027c8 <pmm_init+0x662>
ffffffffc0202504:	000b3783          	ld	a5,0(s6)
ffffffffc0202508:	4585                	li	a1,1
ffffffffc020250a:	739c                	ld	a5,32(a5)
ffffffffc020250c:	9782                	jalr	a5
ffffffffc020250e:	00093783          	ld	a5,0(s2)
ffffffffc0202512:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b10>
ffffffffc0202516:	12000073          	sfence.vma
ffffffffc020251a:	100027f3          	csrr	a5,sstatus
ffffffffc020251e:	8b89                	andi	a5,a5,2
ffffffffc0202520:	28079a63          	bnez	a5,ffffffffc02027b4 <pmm_init+0x64e>
ffffffffc0202524:	000b3783          	ld	a5,0(s6)
ffffffffc0202528:	779c                	ld	a5,40(a5)
ffffffffc020252a:	9782                	jalr	a5
ffffffffc020252c:	8a2a                	mv	s4,a0
ffffffffc020252e:	4d441063          	bne	s0,s4,ffffffffc02029ee <pmm_init+0x888>
ffffffffc0202532:	00003517          	auipc	a0,0x3
ffffffffc0202536:	bbe50513          	addi	a0,a0,-1090 # ffffffffc02050f0 <etext+0x1266>
ffffffffc020253a:	c5bfd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020253e:	100027f3          	csrr	a5,sstatus
ffffffffc0202542:	8b89                	andi	a5,a5,2
ffffffffc0202544:	24079e63          	bnez	a5,ffffffffc02027a0 <pmm_init+0x63a>
ffffffffc0202548:	000b3783          	ld	a5,0(s6)
ffffffffc020254c:	779c                	ld	a5,40(a5)
ffffffffc020254e:	9782                	jalr	a5
ffffffffc0202550:	8c2a                	mv	s8,a0
ffffffffc0202552:	609c                	ld	a5,0(s1)
ffffffffc0202554:	c0200437          	lui	s0,0xc0200
ffffffffc0202558:	7a7d                	lui	s4,0xfffff
ffffffffc020255a:	00c79713          	slli	a4,a5,0xc
ffffffffc020255e:	6a85                	lui	s5,0x1
ffffffffc0202560:	02e47c63          	bgeu	s0,a4,ffffffffc0202598 <pmm_init+0x432>
ffffffffc0202564:	00c45713          	srli	a4,s0,0xc
ffffffffc0202568:	30f77063          	bgeu	a4,a5,ffffffffc0202868 <pmm_init+0x702>
ffffffffc020256c:	0009b583          	ld	a1,0(s3)
ffffffffc0202570:	00093503          	ld	a0,0(s2)
ffffffffc0202574:	4601                	li	a2,0
ffffffffc0202576:	95a2                	add	a1,a1,s0
ffffffffc0202578:	faaff0ef          	jal	ffffffffc0201d22 <get_pte>
ffffffffc020257c:	32050363          	beqz	a0,ffffffffc02028a2 <pmm_init+0x73c>
ffffffffc0202580:	611c                	ld	a5,0(a0)
ffffffffc0202582:	078a                	slli	a5,a5,0x2
ffffffffc0202584:	0147f7b3          	and	a5,a5,s4
ffffffffc0202588:	2e879d63          	bne	a5,s0,ffffffffc0202882 <pmm_init+0x71c>
ffffffffc020258c:	609c                	ld	a5,0(s1)
ffffffffc020258e:	9456                	add	s0,s0,s5
ffffffffc0202590:	00c79713          	slli	a4,a5,0xc
ffffffffc0202594:	fce468e3          	bltu	s0,a4,ffffffffc0202564 <pmm_init+0x3fe>
ffffffffc0202598:	00093783          	ld	a5,0(s2)
ffffffffc020259c:	639c                	ld	a5,0(a5)
ffffffffc020259e:	42079863          	bnez	a5,ffffffffc02029ce <pmm_init+0x868>
ffffffffc02025a2:	100027f3          	csrr	a5,sstatus
ffffffffc02025a6:	8b89                	andi	a5,a5,2
ffffffffc02025a8:	24079863          	bnez	a5,ffffffffc02027f8 <pmm_init+0x692>
ffffffffc02025ac:	000b3783          	ld	a5,0(s6)
ffffffffc02025b0:	4505                	li	a0,1
ffffffffc02025b2:	6f9c                	ld	a5,24(a5)
ffffffffc02025b4:	9782                	jalr	a5
ffffffffc02025b6:	842a                	mv	s0,a0
ffffffffc02025b8:	00093503          	ld	a0,0(s2)
ffffffffc02025bc:	4699                	li	a3,6
ffffffffc02025be:	10000613          	li	a2,256
ffffffffc02025c2:	85a2                	mv	a1,s0
ffffffffc02025c4:	aadff0ef          	jal	ffffffffc0202070 <page_insert>
ffffffffc02025c8:	46051363          	bnez	a0,ffffffffc0202a2e <pmm_init+0x8c8>
ffffffffc02025cc:	4018                	lw	a4,0(s0)
ffffffffc02025ce:	4785                	li	a5,1
ffffffffc02025d0:	42f71f63          	bne	a4,a5,ffffffffc0202a0e <pmm_init+0x8a8>
ffffffffc02025d4:	00093503          	ld	a0,0(s2)
ffffffffc02025d8:	6605                	lui	a2,0x1
ffffffffc02025da:	10060613          	addi	a2,a2,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025de:	4699                	li	a3,6
ffffffffc02025e0:	85a2                	mv	a1,s0
ffffffffc02025e2:	a8fff0ef          	jal	ffffffffc0202070 <page_insert>
ffffffffc02025e6:	72051963          	bnez	a0,ffffffffc0202d18 <pmm_init+0xbb2>
ffffffffc02025ea:	4018                	lw	a4,0(s0)
ffffffffc02025ec:	4789                	li	a5,2
ffffffffc02025ee:	70f71563          	bne	a4,a5,ffffffffc0202cf8 <pmm_init+0xb92>
ffffffffc02025f2:	00003597          	auipc	a1,0x3
ffffffffc02025f6:	c4658593          	addi	a1,a1,-954 # ffffffffc0205238 <etext+0x13ae>
ffffffffc02025fa:	10000513          	li	a0,256
ffffffffc02025fe:	7be010ef          	jal	ffffffffc0203dbc <strcpy>
ffffffffc0202602:	6585                	lui	a1,0x1
ffffffffc0202604:	10058593          	addi	a1,a1,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0202608:	10000513          	li	a0,256
ffffffffc020260c:	7c2010ef          	jal	ffffffffc0203dce <strcmp>
ffffffffc0202610:	6c051463          	bnez	a0,ffffffffc0202cd8 <pmm_init+0xb72>
ffffffffc0202614:	000bb683          	ld	a3,0(s7)
ffffffffc0202618:	000807b7          	lui	a5,0x80
ffffffffc020261c:	6098                	ld	a4,0(s1)
ffffffffc020261e:	40d406b3          	sub	a3,s0,a3
ffffffffc0202622:	8699                	srai	a3,a3,0x6
ffffffffc0202624:	96be                	add	a3,a3,a5
ffffffffc0202626:	00c69793          	slli	a5,a3,0xc
ffffffffc020262a:	83b1                	srli	a5,a5,0xc
ffffffffc020262c:	06b2                	slli	a3,a3,0xc
ffffffffc020262e:	32e7f463          	bgeu	a5,a4,ffffffffc0202956 <pmm_init+0x7f0>
ffffffffc0202632:	0009b783          	ld	a5,0(s3)
ffffffffc0202636:	10000513          	li	a0,256
ffffffffc020263a:	97b6                	add	a5,a5,a3
ffffffffc020263c:	10078023          	sb	zero,256(a5) # 80100 <kern_entry-0xffffffffc017ff00>
ffffffffc0202640:	748010ef          	jal	ffffffffc0203d88 <strlen>
ffffffffc0202644:	66051a63          	bnez	a0,ffffffffc0202cb8 <pmm_init+0xb52>
ffffffffc0202648:	00093a03          	ld	s4,0(s2)
ffffffffc020264c:	6098                	ld	a4,0(s1)
ffffffffc020264e:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fdf1b10>
ffffffffc0202652:	078a                	slli	a5,a5,0x2
ffffffffc0202654:	83b1                	srli	a5,a5,0xc
ffffffffc0202656:	26e7f663          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc020265a:	00c79693          	slli	a3,a5,0xc
ffffffffc020265e:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202956 <pmm_init+0x7f0>
ffffffffc0202662:	0009b783          	ld	a5,0(s3)
ffffffffc0202666:	00f689b3          	add	s3,a3,a5
ffffffffc020266a:	100027f3          	csrr	a5,sstatus
ffffffffc020266e:	8b89                	andi	a5,a5,2
ffffffffc0202670:	1e079163          	bnez	a5,ffffffffc0202852 <pmm_init+0x6ec>
ffffffffc0202674:	000b3783          	ld	a5,0(s6)
ffffffffc0202678:	8522                	mv	a0,s0
ffffffffc020267a:	4585                	li	a1,1
ffffffffc020267c:	739c                	ld	a5,32(a5)
ffffffffc020267e:	9782                	jalr	a5
ffffffffc0202680:	0009b783          	ld	a5,0(s3)
ffffffffc0202684:	6098                	ld	a4,0(s1)
ffffffffc0202686:	078a                	slli	a5,a5,0x2
ffffffffc0202688:	83b1                	srli	a5,a5,0xc
ffffffffc020268a:	22e7fc63          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc020268e:	000bb503          	ld	a0,0(s7)
ffffffffc0202692:	fe000737          	lui	a4,0xfe000
ffffffffc0202696:	079a                	slli	a5,a5,0x6
ffffffffc0202698:	97ba                	add	a5,a5,a4
ffffffffc020269a:	953e                	add	a0,a0,a5
ffffffffc020269c:	100027f3          	csrr	a5,sstatus
ffffffffc02026a0:	8b89                	andi	a5,a5,2
ffffffffc02026a2:	18079c63          	bnez	a5,ffffffffc020283a <pmm_init+0x6d4>
ffffffffc02026a6:	000b3783          	ld	a5,0(s6)
ffffffffc02026aa:	4585                	li	a1,1
ffffffffc02026ac:	739c                	ld	a5,32(a5)
ffffffffc02026ae:	9782                	jalr	a5
ffffffffc02026b0:	000a3783          	ld	a5,0(s4)
ffffffffc02026b4:	6098                	ld	a4,0(s1)
ffffffffc02026b6:	078a                	slli	a5,a5,0x2
ffffffffc02026b8:	83b1                	srli	a5,a5,0xc
ffffffffc02026ba:	20e7f463          	bgeu	a5,a4,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc02026be:	000bb503          	ld	a0,0(s7)
ffffffffc02026c2:	fe000737          	lui	a4,0xfe000
ffffffffc02026c6:	079a                	slli	a5,a5,0x6
ffffffffc02026c8:	97ba                	add	a5,a5,a4
ffffffffc02026ca:	953e                	add	a0,a0,a5
ffffffffc02026cc:	100027f3          	csrr	a5,sstatus
ffffffffc02026d0:	8b89                	andi	a5,a5,2
ffffffffc02026d2:	14079863          	bnez	a5,ffffffffc0202822 <pmm_init+0x6bc>
ffffffffc02026d6:	000b3783          	ld	a5,0(s6)
ffffffffc02026da:	4585                	li	a1,1
ffffffffc02026dc:	739c                	ld	a5,32(a5)
ffffffffc02026de:	9782                	jalr	a5
ffffffffc02026e0:	00093783          	ld	a5,0(s2)
ffffffffc02026e4:	0007b023          	sd	zero,0(a5)
ffffffffc02026e8:	12000073          	sfence.vma
ffffffffc02026ec:	100027f3          	csrr	a5,sstatus
ffffffffc02026f0:	8b89                	andi	a5,a5,2
ffffffffc02026f2:	10079e63          	bnez	a5,ffffffffc020280e <pmm_init+0x6a8>
ffffffffc02026f6:	000b3783          	ld	a5,0(s6)
ffffffffc02026fa:	779c                	ld	a5,40(a5)
ffffffffc02026fc:	9782                	jalr	a5
ffffffffc02026fe:	842a                	mv	s0,a0
ffffffffc0202700:	1e8c1b63          	bne	s8,s0,ffffffffc02028f6 <pmm_init+0x790>
ffffffffc0202704:	00003517          	auipc	a0,0x3
ffffffffc0202708:	bac50513          	addi	a0,a0,-1108 # ffffffffc02052b0 <etext+0x1426>
ffffffffc020270c:	a89fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202710:	7406                	ld	s0,96(sp)
ffffffffc0202712:	70a6                	ld	ra,104(sp)
ffffffffc0202714:	64e6                	ld	s1,88(sp)
ffffffffc0202716:	6946                	ld	s2,80(sp)
ffffffffc0202718:	69a6                	ld	s3,72(sp)
ffffffffc020271a:	6a06                	ld	s4,64(sp)
ffffffffc020271c:	7ae2                	ld	s5,56(sp)
ffffffffc020271e:	7b42                	ld	s6,48(sp)
ffffffffc0202720:	7ba2                	ld	s7,40(sp)
ffffffffc0202722:	7c02                	ld	s8,32(sp)
ffffffffc0202724:	6ce2                	ld	s9,24(sp)
ffffffffc0202726:	6165                	addi	sp,sp,112
ffffffffc0202728:	b70ff06f          	j	ffffffffc0201a98 <kmalloc_init>
ffffffffc020272c:	853e                	mv	a0,a5
ffffffffc020272e:	b4e1                	j	ffffffffc02021f6 <pmm_init+0x90>
ffffffffc0202730:	944fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202734:	000b3783          	ld	a5,0(s6)
ffffffffc0202738:	4505                	li	a0,1
ffffffffc020273a:	6f9c                	ld	a5,24(a5)
ffffffffc020273c:	9782                	jalr	a5
ffffffffc020273e:	8a2a                	mv	s4,a0
ffffffffc0202740:	92efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202744:	be75                	j	ffffffffc0202300 <pmm_init+0x19a>
ffffffffc0202746:	92efe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020274a:	000b3783          	ld	a5,0(s6)
ffffffffc020274e:	779c                	ld	a5,40(a5)
ffffffffc0202750:	9782                	jalr	a5
ffffffffc0202752:	842a                	mv	s0,a0
ffffffffc0202754:	91afe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202758:	b6ad                	j	ffffffffc02022c2 <pmm_init+0x15c>
ffffffffc020275a:	6705                	lui	a4,0x1
ffffffffc020275c:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc020275e:	96ba                	add	a3,a3,a4
ffffffffc0202760:	8ff5                	and	a5,a5,a3
ffffffffc0202762:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202766:	14a77e63          	bgeu	a4,a0,ffffffffc02028c2 <pmm_init+0x75c>
ffffffffc020276a:	000b3683          	ld	a3,0(s6)
ffffffffc020276e:	8c1d                	sub	s0,s0,a5
ffffffffc0202770:	071a                	slli	a4,a4,0x6
ffffffffc0202772:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202776:	973e                	add	a4,a4,a5
ffffffffc0202778:	6a9c                	ld	a5,16(a3)
ffffffffc020277a:	00c45593          	srli	a1,s0,0xc
ffffffffc020277e:	00e60533          	add	a0,a2,a4
ffffffffc0202782:	9782                	jalr	a5
ffffffffc0202784:	0009b583          	ld	a1,0(s3)
ffffffffc0202788:	bcf1                	j	ffffffffc0202264 <pmm_init+0xfe>
ffffffffc020278a:	8eafe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020278e:	000b3783          	ld	a5,0(s6)
ffffffffc0202792:	4505                	li	a0,1
ffffffffc0202794:	6f9c                	ld	a5,24(a5)
ffffffffc0202796:	9782                	jalr	a5
ffffffffc0202798:	8c2a                	mv	s8,a0
ffffffffc020279a:	8d4fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020279e:	b119                	j	ffffffffc02023a4 <pmm_init+0x23e>
ffffffffc02027a0:	8d4fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027a4:	000b3783          	ld	a5,0(s6)
ffffffffc02027a8:	779c                	ld	a5,40(a5)
ffffffffc02027aa:	9782                	jalr	a5
ffffffffc02027ac:	8c2a                	mv	s8,a0
ffffffffc02027ae:	8c0fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027b2:	b345                	j	ffffffffc0202552 <pmm_init+0x3ec>
ffffffffc02027b4:	8c0fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027b8:	000b3783          	ld	a5,0(s6)
ffffffffc02027bc:	779c                	ld	a5,40(a5)
ffffffffc02027be:	9782                	jalr	a5
ffffffffc02027c0:	8a2a                	mv	s4,a0
ffffffffc02027c2:	8acfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027c6:	b3a5                	j	ffffffffc020252e <pmm_init+0x3c8>
ffffffffc02027c8:	e42a                	sd	a0,8(sp)
ffffffffc02027ca:	8aafe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027ce:	000b3783          	ld	a5,0(s6)
ffffffffc02027d2:	6522                	ld	a0,8(sp)
ffffffffc02027d4:	4585                	li	a1,1
ffffffffc02027d6:	739c                	ld	a5,32(a5)
ffffffffc02027d8:	9782                	jalr	a5
ffffffffc02027da:	894fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027de:	bb05                	j	ffffffffc020250e <pmm_init+0x3a8>
ffffffffc02027e0:	e42a                	sd	a0,8(sp)
ffffffffc02027e2:	892fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027e6:	000b3783          	ld	a5,0(s6)
ffffffffc02027ea:	6522                	ld	a0,8(sp)
ffffffffc02027ec:	4585                	li	a1,1
ffffffffc02027ee:	739c                	ld	a5,32(a5)
ffffffffc02027f0:	9782                	jalr	a5
ffffffffc02027f2:	87cfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02027f6:	b1e5                	j	ffffffffc02024de <pmm_init+0x378>
ffffffffc02027f8:	87cfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02027fc:	000b3783          	ld	a5,0(s6)
ffffffffc0202800:	4505                	li	a0,1
ffffffffc0202802:	6f9c                	ld	a5,24(a5)
ffffffffc0202804:	9782                	jalr	a5
ffffffffc0202806:	842a                	mv	s0,a0
ffffffffc0202808:	866fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020280c:	b375                	j	ffffffffc02025b8 <pmm_init+0x452>
ffffffffc020280e:	866fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202812:	000b3783          	ld	a5,0(s6)
ffffffffc0202816:	779c                	ld	a5,40(a5)
ffffffffc0202818:	9782                	jalr	a5
ffffffffc020281a:	842a                	mv	s0,a0
ffffffffc020281c:	852fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202820:	b5c5                	j	ffffffffc0202700 <pmm_init+0x59a>
ffffffffc0202822:	e42a                	sd	a0,8(sp)
ffffffffc0202824:	850fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202828:	000b3783          	ld	a5,0(s6)
ffffffffc020282c:	6522                	ld	a0,8(sp)
ffffffffc020282e:	4585                	li	a1,1
ffffffffc0202830:	739c                	ld	a5,32(a5)
ffffffffc0202832:	9782                	jalr	a5
ffffffffc0202834:	83afe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202838:	b565                	j	ffffffffc02026e0 <pmm_init+0x57a>
ffffffffc020283a:	e42a                	sd	a0,8(sp)
ffffffffc020283c:	838fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202840:	000b3783          	ld	a5,0(s6)
ffffffffc0202844:	6522                	ld	a0,8(sp)
ffffffffc0202846:	4585                	li	a1,1
ffffffffc0202848:	739c                	ld	a5,32(a5)
ffffffffc020284a:	9782                	jalr	a5
ffffffffc020284c:	822fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202850:	b585                	j	ffffffffc02026b0 <pmm_init+0x54a>
ffffffffc0202852:	822fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202856:	000b3783          	ld	a5,0(s6)
ffffffffc020285a:	8522                	mv	a0,s0
ffffffffc020285c:	4585                	li	a1,1
ffffffffc020285e:	739c                	ld	a5,32(a5)
ffffffffc0202860:	9782                	jalr	a5
ffffffffc0202862:	80cfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202866:	bd29                	j	ffffffffc0202680 <pmm_init+0x51a>
ffffffffc0202868:	86a2                	mv	a3,s0
ffffffffc020286a:	00002617          	auipc	a2,0x2
ffffffffc020286e:	3a660613          	addi	a2,a2,934 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0202872:	1a400593          	li	a1,420
ffffffffc0202876:	00002517          	auipc	a0,0x2
ffffffffc020287a:	48a50513          	addi	a0,a0,1162 # ffffffffc0204d00 <etext+0xe76>
ffffffffc020287e:	b89fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202882:	00003697          	auipc	a3,0x3
ffffffffc0202886:	8ce68693          	addi	a3,a3,-1842 # ffffffffc0205150 <etext+0x12c6>
ffffffffc020288a:	00002617          	auipc	a2,0x2
ffffffffc020288e:	fd660613          	addi	a2,a2,-42 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202892:	1a500593          	li	a1,421
ffffffffc0202896:	00002517          	auipc	a0,0x2
ffffffffc020289a:	46a50513          	addi	a0,a0,1130 # ffffffffc0204d00 <etext+0xe76>
ffffffffc020289e:	b69fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02028a2:	00003697          	auipc	a3,0x3
ffffffffc02028a6:	86e68693          	addi	a3,a3,-1938 # ffffffffc0205110 <etext+0x1286>
ffffffffc02028aa:	00002617          	auipc	a2,0x2
ffffffffc02028ae:	fb660613          	addi	a2,a2,-74 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02028b2:	1a400593          	li	a1,420
ffffffffc02028b6:	00002517          	auipc	a0,0x2
ffffffffc02028ba:	44a50513          	addi	a0,a0,1098 # ffffffffc0204d00 <etext+0xe76>
ffffffffc02028be:	b49fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02028c2:	b9cff0ef          	jal	ffffffffc0201c5e <pa2page.part.0>
ffffffffc02028c6:	00002617          	auipc	a2,0x2
ffffffffc02028ca:	5ea60613          	addi	a2,a2,1514 # ffffffffc0204eb0 <etext+0x1026>
ffffffffc02028ce:	07f00593          	li	a1,127
ffffffffc02028d2:	00002517          	auipc	a0,0x2
ffffffffc02028d6:	36650513          	addi	a0,a0,870 # ffffffffc0204c38 <etext+0xdae>
ffffffffc02028da:	b2dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02028de:	00002617          	auipc	a2,0x2
ffffffffc02028e2:	44a60613          	addi	a2,a2,1098 # ffffffffc0204d28 <etext+0xe9e>
ffffffffc02028e6:	06400593          	li	a1,100
ffffffffc02028ea:	00002517          	auipc	a0,0x2
ffffffffc02028ee:	41650513          	addi	a0,a0,1046 # ffffffffc0204d00 <etext+0xe76>
ffffffffc02028f2:	b15fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02028f6:	00002697          	auipc	a3,0x2
ffffffffc02028fa:	7d268693          	addi	a3,a3,2002 # ffffffffc02050c8 <etext+0x123e>
ffffffffc02028fe:	00002617          	auipc	a2,0x2
ffffffffc0202902:	f6260613          	addi	a2,a2,-158 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202906:	1bf00593          	li	a1,447
ffffffffc020290a:	00002517          	auipc	a0,0x2
ffffffffc020290e:	3f650513          	addi	a0,a0,1014 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202912:	af5fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202916:	00002697          	auipc	a3,0x2
ffffffffc020291a:	4ca68693          	addi	a3,a3,1226 # ffffffffc0204de0 <etext+0xf56>
ffffffffc020291e:	00002617          	auipc	a2,0x2
ffffffffc0202922:	f4260613          	addi	a2,a2,-190 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202926:	16600593          	li	a1,358
ffffffffc020292a:	00002517          	auipc	a0,0x2
ffffffffc020292e:	3d650513          	addi	a0,a0,982 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202932:	ad5fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202936:	00002697          	auipc	a3,0x2
ffffffffc020293a:	48a68693          	addi	a3,a3,1162 # ffffffffc0204dc0 <etext+0xf36>
ffffffffc020293e:	00002617          	auipc	a2,0x2
ffffffffc0202942:	f2260613          	addi	a2,a2,-222 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202946:	16500593          	li	a1,357
ffffffffc020294a:	00002517          	auipc	a0,0x2
ffffffffc020294e:	3b650513          	addi	a0,a0,950 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202952:	ab5fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202956:	00002617          	auipc	a2,0x2
ffffffffc020295a:	2ba60613          	addi	a2,a2,698 # ffffffffc0204c10 <etext+0xd86>
ffffffffc020295e:	07100593          	li	a1,113
ffffffffc0202962:	00002517          	auipc	a0,0x2
ffffffffc0202966:	2d650513          	addi	a0,a0,726 # ffffffffc0204c38 <etext+0xdae>
ffffffffc020296a:	a9dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020296e:	00002697          	auipc	a3,0x2
ffffffffc0202972:	72a68693          	addi	a3,a3,1834 # ffffffffc0205098 <etext+0x120e>
ffffffffc0202976:	00002617          	auipc	a2,0x2
ffffffffc020297a:	eea60613          	addi	a2,a2,-278 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020297e:	18d00593          	li	a1,397
ffffffffc0202982:	00002517          	auipc	a0,0x2
ffffffffc0202986:	37e50513          	addi	a0,a0,894 # ffffffffc0204d00 <etext+0xe76>
ffffffffc020298a:	a7dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020298e:	00002697          	auipc	a3,0x2
ffffffffc0202992:	6c268693          	addi	a3,a3,1730 # ffffffffc0205050 <etext+0x11c6>
ffffffffc0202996:	00002617          	auipc	a2,0x2
ffffffffc020299a:	eca60613          	addi	a2,a2,-310 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020299e:	18b00593          	li	a1,395
ffffffffc02029a2:	00002517          	auipc	a0,0x2
ffffffffc02029a6:	35e50513          	addi	a0,a0,862 # ffffffffc0204d00 <etext+0xe76>
ffffffffc02029aa:	a5dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02029ae:	00002697          	auipc	a3,0x2
ffffffffc02029b2:	6d268693          	addi	a3,a3,1746 # ffffffffc0205080 <etext+0x11f6>
ffffffffc02029b6:	00002617          	auipc	a2,0x2
ffffffffc02029ba:	eaa60613          	addi	a2,a2,-342 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02029be:	18a00593          	li	a1,394
ffffffffc02029c2:	00002517          	auipc	a0,0x2
ffffffffc02029c6:	33e50513          	addi	a0,a0,830 # ffffffffc0204d00 <etext+0xe76>
ffffffffc02029ca:	a3dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02029ce:	00002697          	auipc	a3,0x2
ffffffffc02029d2:	79a68693          	addi	a3,a3,1946 # ffffffffc0205168 <etext+0x12de>
ffffffffc02029d6:	00002617          	auipc	a2,0x2
ffffffffc02029da:	e8a60613          	addi	a2,a2,-374 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02029de:	1a800593          	li	a1,424
ffffffffc02029e2:	00002517          	auipc	a0,0x2
ffffffffc02029e6:	31e50513          	addi	a0,a0,798 # ffffffffc0204d00 <etext+0xe76>
ffffffffc02029ea:	a1dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02029ee:	00002697          	auipc	a3,0x2
ffffffffc02029f2:	6da68693          	addi	a3,a3,1754 # ffffffffc02050c8 <etext+0x123e>
ffffffffc02029f6:	00002617          	auipc	a2,0x2
ffffffffc02029fa:	e6a60613          	addi	a2,a2,-406 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02029fe:	19500593          	li	a1,405
ffffffffc0202a02:	00002517          	auipc	a0,0x2
ffffffffc0202a06:	2fe50513          	addi	a0,a0,766 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202a0a:	9fdfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202a0e:	00002697          	auipc	a3,0x2
ffffffffc0202a12:	7b268693          	addi	a3,a3,1970 # ffffffffc02051c0 <etext+0x1336>
ffffffffc0202a16:	00002617          	auipc	a2,0x2
ffffffffc0202a1a:	e4a60613          	addi	a2,a2,-438 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202a1e:	1ad00593          	li	a1,429
ffffffffc0202a22:	00002517          	auipc	a0,0x2
ffffffffc0202a26:	2de50513          	addi	a0,a0,734 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202a2a:	9ddfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202a2e:	00002697          	auipc	a3,0x2
ffffffffc0202a32:	75268693          	addi	a3,a3,1874 # ffffffffc0205180 <etext+0x12f6>
ffffffffc0202a36:	00002617          	auipc	a2,0x2
ffffffffc0202a3a:	e2a60613          	addi	a2,a2,-470 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202a3e:	1ac00593          	li	a1,428
ffffffffc0202a42:	00002517          	auipc	a0,0x2
ffffffffc0202a46:	2be50513          	addi	a0,a0,702 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202a4a:	9bdfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202a4e:	00002697          	auipc	a3,0x2
ffffffffc0202a52:	60268693          	addi	a3,a3,1538 # ffffffffc0205050 <etext+0x11c6>
ffffffffc0202a56:	00002617          	auipc	a2,0x2
ffffffffc0202a5a:	e0a60613          	addi	a2,a2,-502 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202a5e:	18700593          	li	a1,391
ffffffffc0202a62:	00002517          	auipc	a0,0x2
ffffffffc0202a66:	29e50513          	addi	a0,a0,670 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202a6a:	99dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202a6e:	00002697          	auipc	a3,0x2
ffffffffc0202a72:	48268693          	addi	a3,a3,1154 # ffffffffc0204ef0 <etext+0x1066>
ffffffffc0202a76:	00002617          	auipc	a2,0x2
ffffffffc0202a7a:	dea60613          	addi	a2,a2,-534 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202a7e:	18600593          	li	a1,390
ffffffffc0202a82:	00002517          	auipc	a0,0x2
ffffffffc0202a86:	27e50513          	addi	a0,a0,638 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202a8a:	97dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202a8e:	00002697          	auipc	a3,0x2
ffffffffc0202a92:	5da68693          	addi	a3,a3,1498 # ffffffffc0205068 <etext+0x11de>
ffffffffc0202a96:	00002617          	auipc	a2,0x2
ffffffffc0202a9a:	dca60613          	addi	a2,a2,-566 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202a9e:	18300593          	li	a1,387
ffffffffc0202aa2:	00002517          	auipc	a0,0x2
ffffffffc0202aa6:	25e50513          	addi	a0,a0,606 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202aaa:	95dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202aae:	00002697          	auipc	a3,0x2
ffffffffc0202ab2:	42a68693          	addi	a3,a3,1066 # ffffffffc0204ed8 <etext+0x104e>
ffffffffc0202ab6:	00002617          	auipc	a2,0x2
ffffffffc0202aba:	daa60613          	addi	a2,a2,-598 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202abe:	18200593          	li	a1,386
ffffffffc0202ac2:	00002517          	auipc	a0,0x2
ffffffffc0202ac6:	23e50513          	addi	a0,a0,574 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202aca:	93dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202ace:	00002697          	auipc	a3,0x2
ffffffffc0202ad2:	4aa68693          	addi	a3,a3,1194 # ffffffffc0204f78 <etext+0x10ee>
ffffffffc0202ad6:	00002617          	auipc	a2,0x2
ffffffffc0202ada:	d8a60613          	addi	a2,a2,-630 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202ade:	18100593          	li	a1,385
ffffffffc0202ae2:	00002517          	auipc	a0,0x2
ffffffffc0202ae6:	21e50513          	addi	a0,a0,542 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202aea:	91dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202aee:	00002697          	auipc	a3,0x2
ffffffffc0202af2:	56268693          	addi	a3,a3,1378 # ffffffffc0205050 <etext+0x11c6>
ffffffffc0202af6:	00002617          	auipc	a2,0x2
ffffffffc0202afa:	d6a60613          	addi	a2,a2,-662 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202afe:	18000593          	li	a1,384
ffffffffc0202b02:	00002517          	auipc	a0,0x2
ffffffffc0202b06:	1fe50513          	addi	a0,a0,510 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202b0a:	8fdfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202b0e:	00002697          	auipc	a3,0x2
ffffffffc0202b12:	52a68693          	addi	a3,a3,1322 # ffffffffc0205038 <etext+0x11ae>
ffffffffc0202b16:	00002617          	auipc	a2,0x2
ffffffffc0202b1a:	d4a60613          	addi	a2,a2,-694 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202b1e:	17f00593          	li	a1,383
ffffffffc0202b22:	00002517          	auipc	a0,0x2
ffffffffc0202b26:	1de50513          	addi	a0,a0,478 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202b2a:	8ddfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202b2e:	00002697          	auipc	a3,0x2
ffffffffc0202b32:	4da68693          	addi	a3,a3,1242 # ffffffffc0205008 <etext+0x117e>
ffffffffc0202b36:	00002617          	auipc	a2,0x2
ffffffffc0202b3a:	d2a60613          	addi	a2,a2,-726 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202b3e:	17e00593          	li	a1,382
ffffffffc0202b42:	00002517          	auipc	a0,0x2
ffffffffc0202b46:	1be50513          	addi	a0,a0,446 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202b4a:	8bdfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202b4e:	00002697          	auipc	a3,0x2
ffffffffc0202b52:	4a268693          	addi	a3,a3,1186 # ffffffffc0204ff0 <etext+0x1166>
ffffffffc0202b56:	00002617          	auipc	a2,0x2
ffffffffc0202b5a:	d0a60613          	addi	a2,a2,-758 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202b5e:	17c00593          	li	a1,380
ffffffffc0202b62:	00002517          	auipc	a0,0x2
ffffffffc0202b66:	19e50513          	addi	a0,a0,414 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202b6a:	89dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202b6e:	00002697          	auipc	a3,0x2
ffffffffc0202b72:	46268693          	addi	a3,a3,1122 # ffffffffc0204fd0 <etext+0x1146>
ffffffffc0202b76:	00002617          	auipc	a2,0x2
ffffffffc0202b7a:	cea60613          	addi	a2,a2,-790 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202b7e:	17b00593          	li	a1,379
ffffffffc0202b82:	00002517          	auipc	a0,0x2
ffffffffc0202b86:	17e50513          	addi	a0,a0,382 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202b8a:	87dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202b8e:	00002697          	auipc	a3,0x2
ffffffffc0202b92:	43268693          	addi	a3,a3,1074 # ffffffffc0204fc0 <etext+0x1136>
ffffffffc0202b96:	00002617          	auipc	a2,0x2
ffffffffc0202b9a:	cca60613          	addi	a2,a2,-822 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202b9e:	17a00593          	li	a1,378
ffffffffc0202ba2:	00002517          	auipc	a0,0x2
ffffffffc0202ba6:	15e50513          	addi	a0,a0,350 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202baa:	85dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202bae:	00002697          	auipc	a3,0x2
ffffffffc0202bb2:	40268693          	addi	a3,a3,1026 # ffffffffc0204fb0 <etext+0x1126>
ffffffffc0202bb6:	00002617          	auipc	a2,0x2
ffffffffc0202bba:	caa60613          	addi	a2,a2,-854 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202bbe:	17900593          	li	a1,377
ffffffffc0202bc2:	00002517          	auipc	a0,0x2
ffffffffc0202bc6:	13e50513          	addi	a0,a0,318 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202bca:	83dfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202bce:	00002617          	auipc	a2,0x2
ffffffffc0202bd2:	0ea60613          	addi	a2,a2,234 # ffffffffc0204cb8 <etext+0xe2e>
ffffffffc0202bd6:	08000593          	li	a1,128
ffffffffc0202bda:	00002517          	auipc	a0,0x2
ffffffffc0202bde:	12650513          	addi	a0,a0,294 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202be2:	825fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202be6:	00002697          	auipc	a3,0x2
ffffffffc0202bea:	32268693          	addi	a3,a3,802 # ffffffffc0204f08 <etext+0x107e>
ffffffffc0202bee:	00002617          	auipc	a2,0x2
ffffffffc0202bf2:	c7260613          	addi	a2,a2,-910 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202bf6:	17400593          	li	a1,372
ffffffffc0202bfa:	00002517          	auipc	a0,0x2
ffffffffc0202bfe:	10650513          	addi	a0,a0,262 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c02:	805fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c06:	00002697          	auipc	a3,0x2
ffffffffc0202c0a:	37268693          	addi	a3,a3,882 # ffffffffc0204f78 <etext+0x10ee>
ffffffffc0202c0e:	00002617          	auipc	a2,0x2
ffffffffc0202c12:	c5260613          	addi	a2,a2,-942 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202c16:	17800593          	li	a1,376
ffffffffc0202c1a:	00002517          	auipc	a0,0x2
ffffffffc0202c1e:	0e650513          	addi	a0,a0,230 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c22:	fe4fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c26:	00002697          	auipc	a3,0x2
ffffffffc0202c2a:	31268693          	addi	a3,a3,786 # ffffffffc0204f38 <etext+0x10ae>
ffffffffc0202c2e:	00002617          	auipc	a2,0x2
ffffffffc0202c32:	c3260613          	addi	a2,a2,-974 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202c36:	17700593          	li	a1,375
ffffffffc0202c3a:	00002517          	auipc	a0,0x2
ffffffffc0202c3e:	0c650513          	addi	a0,a0,198 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c42:	fc4fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c46:	86d6                	mv	a3,s5
ffffffffc0202c48:	00002617          	auipc	a2,0x2
ffffffffc0202c4c:	fc860613          	addi	a2,a2,-56 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0202c50:	17300593          	li	a1,371
ffffffffc0202c54:	00002517          	auipc	a0,0x2
ffffffffc0202c58:	0ac50513          	addi	a0,a0,172 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c5c:	faafd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c60:	00002617          	auipc	a2,0x2
ffffffffc0202c64:	fb060613          	addi	a2,a2,-80 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0202c68:	17200593          	li	a1,370
ffffffffc0202c6c:	00002517          	auipc	a0,0x2
ffffffffc0202c70:	09450513          	addi	a0,a0,148 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c74:	f92fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c78:	00002697          	auipc	a3,0x2
ffffffffc0202c7c:	27868693          	addi	a3,a3,632 # ffffffffc0204ef0 <etext+0x1066>
ffffffffc0202c80:	00002617          	auipc	a2,0x2
ffffffffc0202c84:	be060613          	addi	a2,a2,-1056 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202c88:	17000593          	li	a1,368
ffffffffc0202c8c:	00002517          	auipc	a0,0x2
ffffffffc0202c90:	07450513          	addi	a0,a0,116 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202c94:	f72fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202c98:	00002697          	auipc	a3,0x2
ffffffffc0202c9c:	24068693          	addi	a3,a3,576 # ffffffffc0204ed8 <etext+0x104e>
ffffffffc0202ca0:	00002617          	auipc	a2,0x2
ffffffffc0202ca4:	bc060613          	addi	a2,a2,-1088 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202ca8:	16f00593          	li	a1,367
ffffffffc0202cac:	00002517          	auipc	a0,0x2
ffffffffc0202cb0:	05450513          	addi	a0,a0,84 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202cb4:	f52fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202cb8:	00002697          	auipc	a3,0x2
ffffffffc0202cbc:	5d068693          	addi	a3,a3,1488 # ffffffffc0205288 <etext+0x13fe>
ffffffffc0202cc0:	00002617          	auipc	a2,0x2
ffffffffc0202cc4:	ba060613          	addi	a2,a2,-1120 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202cc8:	1b600593          	li	a1,438
ffffffffc0202ccc:	00002517          	auipc	a0,0x2
ffffffffc0202cd0:	03450513          	addi	a0,a0,52 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202cd4:	f32fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202cd8:	00002697          	auipc	a3,0x2
ffffffffc0202cdc:	57868693          	addi	a3,a3,1400 # ffffffffc0205250 <etext+0x13c6>
ffffffffc0202ce0:	00002617          	auipc	a2,0x2
ffffffffc0202ce4:	b8060613          	addi	a2,a2,-1152 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202ce8:	1b300593          	li	a1,435
ffffffffc0202cec:	00002517          	auipc	a0,0x2
ffffffffc0202cf0:	01450513          	addi	a0,a0,20 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202cf4:	f12fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202cf8:	00002697          	auipc	a3,0x2
ffffffffc0202cfc:	52868693          	addi	a3,a3,1320 # ffffffffc0205220 <etext+0x1396>
ffffffffc0202d00:	00002617          	auipc	a2,0x2
ffffffffc0202d04:	b6060613          	addi	a2,a2,-1184 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202d08:	1af00593          	li	a1,431
ffffffffc0202d0c:	00002517          	auipc	a0,0x2
ffffffffc0202d10:	ff450513          	addi	a0,a0,-12 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202d14:	ef2fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202d18:	00002697          	auipc	a3,0x2
ffffffffc0202d1c:	4c068693          	addi	a3,a3,1216 # ffffffffc02051d8 <etext+0x134e>
ffffffffc0202d20:	00002617          	auipc	a2,0x2
ffffffffc0202d24:	b4060613          	addi	a2,a2,-1216 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202d28:	1ae00593          	li	a1,430
ffffffffc0202d2c:	00002517          	auipc	a0,0x2
ffffffffc0202d30:	fd450513          	addi	a0,a0,-44 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202d34:	ed2fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202d38:	00002697          	auipc	a3,0x2
ffffffffc0202d3c:	0e868693          	addi	a3,a3,232 # ffffffffc0204e20 <etext+0xf96>
ffffffffc0202d40:	00002617          	auipc	a2,0x2
ffffffffc0202d44:	b2060613          	addi	a2,a2,-1248 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202d48:	16700593          	li	a1,359
ffffffffc0202d4c:	00002517          	auipc	a0,0x2
ffffffffc0202d50:	fb450513          	addi	a0,a0,-76 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202d54:	eb2fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202d58:	00002617          	auipc	a2,0x2
ffffffffc0202d5c:	f6060613          	addi	a2,a2,-160 # ffffffffc0204cb8 <etext+0xe2e>
ffffffffc0202d60:	0cb00593          	li	a1,203
ffffffffc0202d64:	00002517          	auipc	a0,0x2
ffffffffc0202d68:	f9c50513          	addi	a0,a0,-100 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202d6c:	e9afd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202d70:	00002697          	auipc	a3,0x2
ffffffffc0202d74:	11068693          	addi	a3,a3,272 # ffffffffc0204e80 <etext+0xff6>
ffffffffc0202d78:	00002617          	auipc	a2,0x2
ffffffffc0202d7c:	ae860613          	addi	a2,a2,-1304 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202d80:	16e00593          	li	a1,366
ffffffffc0202d84:	00002517          	auipc	a0,0x2
ffffffffc0202d88:	f7c50513          	addi	a0,a0,-132 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202d8c:	e7afd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202d90:	00002697          	auipc	a3,0x2
ffffffffc0202d94:	0c068693          	addi	a3,a3,192 # ffffffffc0204e50 <etext+0xfc6>
ffffffffc0202d98:	00002617          	auipc	a2,0x2
ffffffffc0202d9c:	ac860613          	addi	a2,a2,-1336 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202da0:	16b00593          	li	a1,363
ffffffffc0202da4:	00002517          	auipc	a0,0x2
ffffffffc0202da8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0204d00 <etext+0xe76>
ffffffffc0202dac:	e5afd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202db0 <check_vma_overlap.part.0>:
ffffffffc0202db0:	1141                	addi	sp,sp,-16
ffffffffc0202db2:	00002697          	auipc	a3,0x2
ffffffffc0202db6:	51e68693          	addi	a3,a3,1310 # ffffffffc02052d0 <etext+0x1446>
ffffffffc0202dba:	00002617          	auipc	a2,0x2
ffffffffc0202dbe:	aa660613          	addi	a2,a2,-1370 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202dc2:	08800593          	li	a1,136
ffffffffc0202dc6:	00002517          	auipc	a0,0x2
ffffffffc0202dca:	52a50513          	addi	a0,a0,1322 # ffffffffc02052f0 <etext+0x1466>
ffffffffc0202dce:	e406                	sd	ra,8(sp)
ffffffffc0202dd0:	e36fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202dd4 <find_vma>:
ffffffffc0202dd4:	c505                	beqz	a0,ffffffffc0202dfc <find_vma+0x28>
ffffffffc0202dd6:	691c                	ld	a5,16(a0)
ffffffffc0202dd8:	c781                	beqz	a5,ffffffffc0202de0 <find_vma+0xc>
ffffffffc0202dda:	6798                	ld	a4,8(a5)
ffffffffc0202ddc:	02e5f363          	bgeu	a1,a4,ffffffffc0202e02 <find_vma+0x2e>
ffffffffc0202de0:	651c                	ld	a5,8(a0)
ffffffffc0202de2:	00f50d63          	beq	a0,a5,ffffffffc0202dfc <find_vma+0x28>
ffffffffc0202de6:	fe87b703          	ld	a4,-24(a5) # fffffffffdffffe8 <end+0x3ddf2af8>
ffffffffc0202dea:	00e5e663          	bltu	a1,a4,ffffffffc0202df6 <find_vma+0x22>
ffffffffc0202dee:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202df2:	00e5ee63          	bltu	a1,a4,ffffffffc0202e0e <find_vma+0x3a>
ffffffffc0202df6:	679c                	ld	a5,8(a5)
ffffffffc0202df8:	fef517e3          	bne	a0,a5,ffffffffc0202de6 <find_vma+0x12>
ffffffffc0202dfc:	4781                	li	a5,0
ffffffffc0202dfe:	853e                	mv	a0,a5
ffffffffc0202e00:	8082                	ret
ffffffffc0202e02:	6b98                	ld	a4,16(a5)
ffffffffc0202e04:	fce5fee3          	bgeu	a1,a4,ffffffffc0202de0 <find_vma+0xc>
ffffffffc0202e08:	e91c                	sd	a5,16(a0)
ffffffffc0202e0a:	853e                	mv	a0,a5
ffffffffc0202e0c:	8082                	ret
ffffffffc0202e0e:	1781                	addi	a5,a5,-32
ffffffffc0202e10:	e91c                	sd	a5,16(a0)
ffffffffc0202e12:	bfe5                	j	ffffffffc0202e0a <find_vma+0x36>

ffffffffc0202e14 <insert_vma_struct>:
ffffffffc0202e14:	6590                	ld	a2,8(a1)
ffffffffc0202e16:	0105b803          	ld	a6,16(a1)
ffffffffc0202e1a:	1141                	addi	sp,sp,-16
ffffffffc0202e1c:	e406                	sd	ra,8(sp)
ffffffffc0202e1e:	87aa                	mv	a5,a0
ffffffffc0202e20:	01066763          	bltu	a2,a6,ffffffffc0202e2e <insert_vma_struct+0x1a>
ffffffffc0202e24:	a8b9                	j	ffffffffc0202e82 <insert_vma_struct+0x6e>
ffffffffc0202e26:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e2a:	04e66763          	bltu	a2,a4,ffffffffc0202e78 <insert_vma_struct+0x64>
ffffffffc0202e2e:	86be                	mv	a3,a5
ffffffffc0202e30:	679c                	ld	a5,8(a5)
ffffffffc0202e32:	fef51ae3          	bne	a0,a5,ffffffffc0202e26 <insert_vma_struct+0x12>
ffffffffc0202e36:	02a68463          	beq	a3,a0,ffffffffc0202e5e <insert_vma_struct+0x4a>
ffffffffc0202e3a:	ff06b703          	ld	a4,-16(a3)
ffffffffc0202e3e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e42:	08e8f063          	bgeu	a7,a4,ffffffffc0202ec2 <insert_vma_struct+0xae>
ffffffffc0202e46:	04e66e63          	bltu	a2,a4,ffffffffc0202ea2 <insert_vma_struct+0x8e>
ffffffffc0202e4a:	00f50a63          	beq	a0,a5,ffffffffc0202e5e <insert_vma_struct+0x4a>
ffffffffc0202e4e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e52:	05076863          	bltu	a4,a6,ffffffffc0202ea2 <insert_vma_struct+0x8e>
ffffffffc0202e56:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e5a:	02c77263          	bgeu	a4,a2,ffffffffc0202e7e <insert_vma_struct+0x6a>
ffffffffc0202e5e:	5118                	lw	a4,32(a0)
ffffffffc0202e60:	e188                	sd	a0,0(a1)
ffffffffc0202e62:	02058613          	addi	a2,a1,32
ffffffffc0202e66:	e390                	sd	a2,0(a5)
ffffffffc0202e68:	e690                	sd	a2,8(a3)
ffffffffc0202e6a:	60a2                	ld	ra,8(sp)
ffffffffc0202e6c:	f59c                	sd	a5,40(a1)
ffffffffc0202e6e:	f194                	sd	a3,32(a1)
ffffffffc0202e70:	2705                	addiw	a4,a4,1
ffffffffc0202e72:	d118                	sw	a4,32(a0)
ffffffffc0202e74:	0141                	addi	sp,sp,16
ffffffffc0202e76:	8082                	ret
ffffffffc0202e78:	fca691e3          	bne	a3,a0,ffffffffc0202e3a <insert_vma_struct+0x26>
ffffffffc0202e7c:	bfd9                	j	ffffffffc0202e52 <insert_vma_struct+0x3e>
ffffffffc0202e7e:	f33ff0ef          	jal	ffffffffc0202db0 <check_vma_overlap.part.0>
ffffffffc0202e82:	00002697          	auipc	a3,0x2
ffffffffc0202e86:	47e68693          	addi	a3,a3,1150 # ffffffffc0205300 <etext+0x1476>
ffffffffc0202e8a:	00002617          	auipc	a2,0x2
ffffffffc0202e8e:	9d660613          	addi	a2,a2,-1578 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202e92:	08e00593          	li	a1,142
ffffffffc0202e96:	00002517          	auipc	a0,0x2
ffffffffc0202e9a:	45a50513          	addi	a0,a0,1114 # ffffffffc02052f0 <etext+0x1466>
ffffffffc0202e9e:	d68fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202ea2:	00002697          	auipc	a3,0x2
ffffffffc0202ea6:	49e68693          	addi	a3,a3,1182 # ffffffffc0205340 <etext+0x14b6>
ffffffffc0202eaa:	00002617          	auipc	a2,0x2
ffffffffc0202eae:	9b660613          	addi	a2,a2,-1610 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202eb2:	08700593          	li	a1,135
ffffffffc0202eb6:	00002517          	auipc	a0,0x2
ffffffffc0202eba:	43a50513          	addi	a0,a0,1082 # ffffffffc02052f0 <etext+0x1466>
ffffffffc0202ebe:	d48fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0202ec2:	00002697          	auipc	a3,0x2
ffffffffc0202ec6:	45e68693          	addi	a3,a3,1118 # ffffffffc0205320 <etext+0x1496>
ffffffffc0202eca:	00002617          	auipc	a2,0x2
ffffffffc0202ece:	99660613          	addi	a2,a2,-1642 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0202ed2:	08600593          	li	a1,134
ffffffffc0202ed6:	00002517          	auipc	a0,0x2
ffffffffc0202eda:	41a50513          	addi	a0,a0,1050 # ffffffffc02052f0 <etext+0x1466>
ffffffffc0202ede:	d28fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202ee2 <vmm_init>:
ffffffffc0202ee2:	7139                	addi	sp,sp,-64
ffffffffc0202ee4:	03000513          	li	a0,48
ffffffffc0202ee8:	fc06                	sd	ra,56(sp)
ffffffffc0202eea:	f822                	sd	s0,48(sp)
ffffffffc0202eec:	f426                	sd	s1,40(sp)
ffffffffc0202eee:	f04a                	sd	s2,32(sp)
ffffffffc0202ef0:	ec4e                	sd	s3,24(sp)
ffffffffc0202ef2:	e852                	sd	s4,16(sp)
ffffffffc0202ef4:	e456                	sd	s5,8(sp)
ffffffffc0202ef6:	bc3fe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc0202efa:	18050a63          	beqz	a0,ffffffffc020308e <vmm_init+0x1ac>
ffffffffc0202efe:	842a                	mv	s0,a0
ffffffffc0202f00:	e508                	sd	a0,8(a0)
ffffffffc0202f02:	e108                	sd	a0,0(a0)
ffffffffc0202f04:	00053823          	sd	zero,16(a0)
ffffffffc0202f08:	00053c23          	sd	zero,24(a0)
ffffffffc0202f0c:	02052023          	sw	zero,32(a0)
ffffffffc0202f10:	02053423          	sd	zero,40(a0)
ffffffffc0202f14:	03200493          	li	s1,50
ffffffffc0202f18:	03000513          	li	a0,48
ffffffffc0202f1c:	b9dfe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc0202f20:	14050763          	beqz	a0,ffffffffc020306e <vmm_init+0x18c>
ffffffffc0202f24:	00248793          	addi	a5,s1,2
ffffffffc0202f28:	e504                	sd	s1,8(a0)
ffffffffc0202f2a:	00052c23          	sw	zero,24(a0)
ffffffffc0202f2e:	e91c                	sd	a5,16(a0)
ffffffffc0202f30:	85aa                	mv	a1,a0
ffffffffc0202f32:	14ed                	addi	s1,s1,-5
ffffffffc0202f34:	8522                	mv	a0,s0
ffffffffc0202f36:	edfff0ef          	jal	ffffffffc0202e14 <insert_vma_struct>
ffffffffc0202f3a:	fcf9                	bnez	s1,ffffffffc0202f18 <vmm_init+0x36>
ffffffffc0202f3c:	03700493          	li	s1,55
ffffffffc0202f40:	1f900913          	li	s2,505
ffffffffc0202f44:	03000513          	li	a0,48
ffffffffc0202f48:	b71fe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc0202f4c:	16050163          	beqz	a0,ffffffffc02030ae <vmm_init+0x1cc>
ffffffffc0202f50:	00248793          	addi	a5,s1,2
ffffffffc0202f54:	e504                	sd	s1,8(a0)
ffffffffc0202f56:	00052c23          	sw	zero,24(a0)
ffffffffc0202f5a:	e91c                	sd	a5,16(a0)
ffffffffc0202f5c:	85aa                	mv	a1,a0
ffffffffc0202f5e:	0495                	addi	s1,s1,5
ffffffffc0202f60:	8522                	mv	a0,s0
ffffffffc0202f62:	eb3ff0ef          	jal	ffffffffc0202e14 <insert_vma_struct>
ffffffffc0202f66:	fd249fe3          	bne	s1,s2,ffffffffc0202f44 <vmm_init+0x62>
ffffffffc0202f6a:	641c                	ld	a5,8(s0)
ffffffffc0202f6c:	471d                	li	a4,7
ffffffffc0202f6e:	1fb00593          	li	a1,507
ffffffffc0202f72:	8abe                	mv	s5,a5
ffffffffc0202f74:	20f40d63          	beq	s0,a5,ffffffffc020318e <vmm_init+0x2ac>
ffffffffc0202f78:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202f7c:	ffe70693          	addi	a3,a4,-2
ffffffffc0202f80:	14d61763          	bne	a2,a3,ffffffffc02030ce <vmm_init+0x1ec>
ffffffffc0202f84:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202f88:	14e69363          	bne	a3,a4,ffffffffc02030ce <vmm_init+0x1ec>
ffffffffc0202f8c:	0715                	addi	a4,a4,5
ffffffffc0202f8e:	679c                	ld	a5,8(a5)
ffffffffc0202f90:	feb712e3          	bne	a4,a1,ffffffffc0202f74 <vmm_init+0x92>
ffffffffc0202f94:	491d                	li	s2,7
ffffffffc0202f96:	4495                	li	s1,5
ffffffffc0202f98:	85a6                	mv	a1,s1
ffffffffc0202f9a:	8522                	mv	a0,s0
ffffffffc0202f9c:	e39ff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0202fa0:	8a2a                	mv	s4,a0
ffffffffc0202fa2:	22050663          	beqz	a0,ffffffffc02031ce <vmm_init+0x2ec>
ffffffffc0202fa6:	00148593          	addi	a1,s1,1
ffffffffc0202faa:	8522                	mv	a0,s0
ffffffffc0202fac:	e29ff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0202fb0:	89aa                	mv	s3,a0
ffffffffc0202fb2:	1e050e63          	beqz	a0,ffffffffc02031ae <vmm_init+0x2cc>
ffffffffc0202fb6:	85ca                	mv	a1,s2
ffffffffc0202fb8:	8522                	mv	a0,s0
ffffffffc0202fba:	e1bff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0202fbe:	1a051863          	bnez	a0,ffffffffc020316e <vmm_init+0x28c>
ffffffffc0202fc2:	00348593          	addi	a1,s1,3
ffffffffc0202fc6:	8522                	mv	a0,s0
ffffffffc0202fc8:	e0dff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0202fcc:	18051163          	bnez	a0,ffffffffc020314e <vmm_init+0x26c>
ffffffffc0202fd0:	00448593          	addi	a1,s1,4
ffffffffc0202fd4:	8522                	mv	a0,s0
ffffffffc0202fd6:	dffff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0202fda:	14051a63          	bnez	a0,ffffffffc020312e <vmm_init+0x24c>
ffffffffc0202fde:	008a3783          	ld	a5,8(s4)
ffffffffc0202fe2:	12979663          	bne	a5,s1,ffffffffc020310e <vmm_init+0x22c>
ffffffffc0202fe6:	010a3783          	ld	a5,16(s4)
ffffffffc0202fea:	13279263          	bne	a5,s2,ffffffffc020310e <vmm_init+0x22c>
ffffffffc0202fee:	0089b783          	ld	a5,8(s3)
ffffffffc0202ff2:	0e979e63          	bne	a5,s1,ffffffffc02030ee <vmm_init+0x20c>
ffffffffc0202ff6:	0109b783          	ld	a5,16(s3)
ffffffffc0202ffa:	0f279a63          	bne	a5,s2,ffffffffc02030ee <vmm_init+0x20c>
ffffffffc0202ffe:	0495                	addi	s1,s1,5
ffffffffc0203000:	1f900793          	li	a5,505
ffffffffc0203004:	0915                	addi	s2,s2,5
ffffffffc0203006:	f8f499e3          	bne	s1,a5,ffffffffc0202f98 <vmm_init+0xb6>
ffffffffc020300a:	4491                	li	s1,4
ffffffffc020300c:	597d                	li	s2,-1
ffffffffc020300e:	85a6                	mv	a1,s1
ffffffffc0203010:	8522                	mv	a0,s0
ffffffffc0203012:	dc3ff0ef          	jal	ffffffffc0202dd4 <find_vma>
ffffffffc0203016:	1c051c63          	bnez	a0,ffffffffc02031ee <vmm_init+0x30c>
ffffffffc020301a:	14fd                	addi	s1,s1,-1
ffffffffc020301c:	ff2499e3          	bne	s1,s2,ffffffffc020300e <vmm_init+0x12c>
ffffffffc0203020:	028a8063          	beq	s5,s0,ffffffffc0203040 <vmm_init+0x15e>
ffffffffc0203024:	008ab783          	ld	a5,8(s5) # 1008 <kern_entry-0xffffffffc01feff8>
ffffffffc0203028:	000ab703          	ld	a4,0(s5)
ffffffffc020302c:	fe0a8513          	addi	a0,s5,-32
ffffffffc0203030:	e71c                	sd	a5,8(a4)
ffffffffc0203032:	e398                	sd	a4,0(a5)
ffffffffc0203034:	b2bfe0ef          	jal	ffffffffc0201b5e <kfree>
ffffffffc0203038:	641c                	ld	a5,8(s0)
ffffffffc020303a:	8abe                	mv	s5,a5
ffffffffc020303c:	fef414e3          	bne	s0,a5,ffffffffc0203024 <vmm_init+0x142>
ffffffffc0203040:	8522                	mv	a0,s0
ffffffffc0203042:	b1dfe0ef          	jal	ffffffffc0201b5e <kfree>
ffffffffc0203046:	00002517          	auipc	a0,0x2
ffffffffc020304a:	47a50513          	addi	a0,a0,1146 # ffffffffc02054c0 <etext+0x1636>
ffffffffc020304e:	946fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203052:	7442                	ld	s0,48(sp)
ffffffffc0203054:	70e2                	ld	ra,56(sp)
ffffffffc0203056:	74a2                	ld	s1,40(sp)
ffffffffc0203058:	7902                	ld	s2,32(sp)
ffffffffc020305a:	69e2                	ld	s3,24(sp)
ffffffffc020305c:	6a42                	ld	s4,16(sp)
ffffffffc020305e:	6aa2                	ld	s5,8(sp)
ffffffffc0203060:	00002517          	auipc	a0,0x2
ffffffffc0203064:	48050513          	addi	a0,a0,1152 # ffffffffc02054e0 <etext+0x1656>
ffffffffc0203068:	6121                	addi	sp,sp,64
ffffffffc020306a:	92afd06f          	j	ffffffffc0200194 <cprintf>
ffffffffc020306e:	00002697          	auipc	a3,0x2
ffffffffc0203072:	30268693          	addi	a3,a3,770 # ffffffffc0205370 <etext+0x14e6>
ffffffffc0203076:	00001617          	auipc	a2,0x1
ffffffffc020307a:	7ea60613          	addi	a2,a2,2026 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020307e:	0da00593          	li	a1,218
ffffffffc0203082:	00002517          	auipc	a0,0x2
ffffffffc0203086:	26e50513          	addi	a0,a0,622 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020308a:	b7cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020308e:	00002697          	auipc	a3,0x2
ffffffffc0203092:	2d268693          	addi	a3,a3,722 # ffffffffc0205360 <etext+0x14d6>
ffffffffc0203096:	00001617          	auipc	a2,0x1
ffffffffc020309a:	7ca60613          	addi	a2,a2,1994 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020309e:	0d200593          	li	a1,210
ffffffffc02030a2:	00002517          	auipc	a0,0x2
ffffffffc02030a6:	24e50513          	addi	a0,a0,590 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02030aa:	b5cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02030ae:	00002697          	auipc	a3,0x2
ffffffffc02030b2:	2c268693          	addi	a3,a3,706 # ffffffffc0205370 <etext+0x14e6>
ffffffffc02030b6:	00001617          	auipc	a2,0x1
ffffffffc02030ba:	7aa60613          	addi	a2,a2,1962 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02030be:	0e100593          	li	a1,225
ffffffffc02030c2:	00002517          	auipc	a0,0x2
ffffffffc02030c6:	22e50513          	addi	a0,a0,558 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02030ca:	b3cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02030ce:	00002697          	auipc	a3,0x2
ffffffffc02030d2:	2ca68693          	addi	a3,a3,714 # ffffffffc0205398 <etext+0x150e>
ffffffffc02030d6:	00001617          	auipc	a2,0x1
ffffffffc02030da:	78a60613          	addi	a2,a2,1930 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02030de:	0eb00593          	li	a1,235
ffffffffc02030e2:	00002517          	auipc	a0,0x2
ffffffffc02030e6:	20e50513          	addi	a0,a0,526 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02030ea:	b1cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02030ee:	00002697          	auipc	a3,0x2
ffffffffc02030f2:	36268693          	addi	a3,a3,866 # ffffffffc0205450 <etext+0x15c6>
ffffffffc02030f6:	00001617          	auipc	a2,0x1
ffffffffc02030fa:	76a60613          	addi	a2,a2,1898 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02030fe:	0fd00593          	li	a1,253
ffffffffc0203102:	00002517          	auipc	a0,0x2
ffffffffc0203106:	1ee50513          	addi	a0,a0,494 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020310a:	afcfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020310e:	00002697          	auipc	a3,0x2
ffffffffc0203112:	31268693          	addi	a3,a3,786 # ffffffffc0205420 <etext+0x1596>
ffffffffc0203116:	00001617          	auipc	a2,0x1
ffffffffc020311a:	74a60613          	addi	a2,a2,1866 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020311e:	0fc00593          	li	a1,252
ffffffffc0203122:	00002517          	auipc	a0,0x2
ffffffffc0203126:	1ce50513          	addi	a0,a0,462 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020312a:	adcfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020312e:	00002697          	auipc	a3,0x2
ffffffffc0203132:	2e268693          	addi	a3,a3,738 # ffffffffc0205410 <etext+0x1586>
ffffffffc0203136:	00001617          	auipc	a2,0x1
ffffffffc020313a:	72a60613          	addi	a2,a2,1834 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020313e:	0fa00593          	li	a1,250
ffffffffc0203142:	00002517          	auipc	a0,0x2
ffffffffc0203146:	1ae50513          	addi	a0,a0,430 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020314a:	abcfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020314e:	00002697          	auipc	a3,0x2
ffffffffc0203152:	2b268693          	addi	a3,a3,690 # ffffffffc0205400 <etext+0x1576>
ffffffffc0203156:	00001617          	auipc	a2,0x1
ffffffffc020315a:	70a60613          	addi	a2,a2,1802 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020315e:	0f800593          	li	a1,248
ffffffffc0203162:	00002517          	auipc	a0,0x2
ffffffffc0203166:	18e50513          	addi	a0,a0,398 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020316a:	a9cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020316e:	00002697          	auipc	a3,0x2
ffffffffc0203172:	28268693          	addi	a3,a3,642 # ffffffffc02053f0 <etext+0x1566>
ffffffffc0203176:	00001617          	auipc	a2,0x1
ffffffffc020317a:	6ea60613          	addi	a2,a2,1770 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020317e:	0f600593          	li	a1,246
ffffffffc0203182:	00002517          	auipc	a0,0x2
ffffffffc0203186:	16e50513          	addi	a0,a0,366 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020318a:	a7cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020318e:	00002697          	auipc	a3,0x2
ffffffffc0203192:	1f268693          	addi	a3,a3,498 # ffffffffc0205380 <etext+0x14f6>
ffffffffc0203196:	00001617          	auipc	a2,0x1
ffffffffc020319a:	6ca60613          	addi	a2,a2,1738 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020319e:	0e900593          	li	a1,233
ffffffffc02031a2:	00002517          	auipc	a0,0x2
ffffffffc02031a6:	14e50513          	addi	a0,a0,334 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02031aa:	a5cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02031ae:	00002697          	auipc	a3,0x2
ffffffffc02031b2:	23268693          	addi	a3,a3,562 # ffffffffc02053e0 <etext+0x1556>
ffffffffc02031b6:	00001617          	auipc	a2,0x1
ffffffffc02031ba:	6aa60613          	addi	a2,a2,1706 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02031be:	0f400593          	li	a1,244
ffffffffc02031c2:	00002517          	auipc	a0,0x2
ffffffffc02031c6:	12e50513          	addi	a0,a0,302 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02031ca:	a3cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02031ce:	00002697          	auipc	a3,0x2
ffffffffc02031d2:	20268693          	addi	a3,a3,514 # ffffffffc02053d0 <etext+0x1546>
ffffffffc02031d6:	00001617          	auipc	a2,0x1
ffffffffc02031da:	68a60613          	addi	a2,a2,1674 # ffffffffc0204860 <etext+0x9d6>
ffffffffc02031de:	0f200593          	li	a1,242
ffffffffc02031e2:	00002517          	auipc	a0,0x2
ffffffffc02031e6:	10e50513          	addi	a0,a0,270 # ffffffffc02052f0 <etext+0x1466>
ffffffffc02031ea:	a1cfd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02031ee:	6914                	ld	a3,16(a0)
ffffffffc02031f0:	6510                	ld	a2,8(a0)
ffffffffc02031f2:	0004859b          	sext.w	a1,s1
ffffffffc02031f6:	00002517          	auipc	a0,0x2
ffffffffc02031fa:	28a50513          	addi	a0,a0,650 # ffffffffc0205480 <etext+0x15f6>
ffffffffc02031fe:	f97fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203202:	00002697          	auipc	a3,0x2
ffffffffc0203206:	2a668693          	addi	a3,a3,678 # ffffffffc02054a8 <etext+0x161e>
ffffffffc020320a:	00001617          	auipc	a2,0x1
ffffffffc020320e:	65660613          	addi	a2,a2,1622 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0203212:	10700593          	li	a1,263
ffffffffc0203216:	00002517          	auipc	a0,0x2
ffffffffc020321a:	0da50513          	addi	a0,a0,218 # ffffffffc02052f0 <etext+0x1466>
ffffffffc020321e:	9e8fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203222 <kernel_thread_entry>:
ffffffffc0203222:	8526                	mv	a0,s1
ffffffffc0203224:	9402                	jalr	s0
ffffffffc0203226:	3c2000ef          	jal	ffffffffc02035e8 <do_exit>

ffffffffc020322a <alloc_proc>:
ffffffffc020322a:	1141                	addi	sp,sp,-16
ffffffffc020322c:	0e800513          	li	a0,232
ffffffffc0203230:	e022                	sd	s0,0(sp)
ffffffffc0203232:	e406                	sd	ra,8(sp)
ffffffffc0203234:	885fe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc0203238:	842a                	mv	s0,a0
ffffffffc020323a:	cd21                	beqz	a0,ffffffffc0203292 <alloc_proc+0x68>
ffffffffc020323c:	57fd                	li	a5,-1
ffffffffc020323e:	1782                	slli	a5,a5,0x20
ffffffffc0203240:	e11c                	sd	a5,0(a0)
ffffffffc0203242:	00052423          	sw	zero,8(a0)
ffffffffc0203246:	00053823          	sd	zero,16(a0)
ffffffffc020324a:	00052c23          	sw	zero,24(a0)
ffffffffc020324e:	02053023          	sd	zero,32(a0)
ffffffffc0203252:	02053423          	sd	zero,40(a0)
ffffffffc0203256:	07000613          	li	a2,112
ffffffffc020325a:	4581                	li	a1,0
ffffffffc020325c:	03050513          	addi	a0,a0,48
ffffffffc0203260:	3dd000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0203264:	0000a797          	auipc	a5,0xa
ffffffffc0203268:	2447b783          	ld	a5,580(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
ffffffffc020326c:	0a043023          	sd	zero,160(s0) # ffffffffc02000a0 <kern_init+0x56>
ffffffffc0203270:	0a042823          	sw	zero,176(s0)
ffffffffc0203274:	f45c                	sd	a5,168(s0)
ffffffffc0203276:	0b440513          	addi	a0,s0,180
ffffffffc020327a:	4641                	li	a2,16
ffffffffc020327c:	4581                	li	a1,0
ffffffffc020327e:	3bf000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0203282:	0c840713          	addi	a4,s0,200
ffffffffc0203286:	0d840793          	addi	a5,s0,216
ffffffffc020328a:	e878                	sd	a4,208(s0)
ffffffffc020328c:	e478                	sd	a4,200(s0)
ffffffffc020328e:	f07c                	sd	a5,224(s0)
ffffffffc0203290:	ec7c                	sd	a5,216(s0)
ffffffffc0203292:	60a2                	ld	ra,8(sp)
ffffffffc0203294:	8522                	mv	a0,s0
ffffffffc0203296:	6402                	ld	s0,0(sp)
ffffffffc0203298:	0141                	addi	sp,sp,16
ffffffffc020329a:	8082                	ret

ffffffffc020329c <forkret>:
ffffffffc020329c:	0000a797          	auipc	a5,0xa
ffffffffc02032a0:	23c7b783          	ld	a5,572(a5) # ffffffffc020d4d8 <current>
ffffffffc02032a4:	73c8                	ld	a0,160(a5)
ffffffffc02032a6:	a9bfd06f          	j	ffffffffc0200d40 <forkrets>

ffffffffc02032aa <init_main>:
ffffffffc02032aa:	1101                	addi	sp,sp,-32
ffffffffc02032ac:	e822                	sd	s0,16(sp)
ffffffffc02032ae:	0000a417          	auipc	s0,0xa
ffffffffc02032b2:	22a43403          	ld	s0,554(s0) # ffffffffc020d4d8 <current>
ffffffffc02032b6:	e04a                	sd	s2,0(sp)
ffffffffc02032b8:	4641                	li	a2,16
ffffffffc02032ba:	892a                	mv	s2,a0
ffffffffc02032bc:	4581                	li	a1,0
ffffffffc02032be:	00006517          	auipc	a0,0x6
ffffffffc02032c2:	18a50513          	addi	a0,a0,394 # ffffffffc0209448 <name.2>
ffffffffc02032c6:	ec06                	sd	ra,24(sp)
ffffffffc02032c8:	e426                	sd	s1,8(sp)
ffffffffc02032ca:	4044                	lw	s1,4(s0)
ffffffffc02032cc:	371000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc02032d0:	0b440593          	addi	a1,s0,180
ffffffffc02032d4:	463d                	li	a2,15
ffffffffc02032d6:	00006517          	auipc	a0,0x6
ffffffffc02032da:	17250513          	addi	a0,a0,370 # ffffffffc0209448 <name.2>
ffffffffc02032de:	371000ef          	jal	ffffffffc0203e4e <memcpy>
ffffffffc02032e2:	862a                	mv	a2,a0
ffffffffc02032e4:	85a6                	mv	a1,s1
ffffffffc02032e6:	00002517          	auipc	a0,0x2
ffffffffc02032ea:	21250513          	addi	a0,a0,530 # ffffffffc02054f8 <etext+0x166e>
ffffffffc02032ee:	ea7fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02032f2:	85ca                	mv	a1,s2
ffffffffc02032f4:	00002517          	auipc	a0,0x2
ffffffffc02032f8:	22c50513          	addi	a0,a0,556 # ffffffffc0205520 <etext+0x1696>
ffffffffc02032fc:	e99fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203300:	00002517          	auipc	a0,0x2
ffffffffc0203304:	23050513          	addi	a0,a0,560 # ffffffffc0205530 <etext+0x16a6>
ffffffffc0203308:	e8dfc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020330c:	60e2                	ld	ra,24(sp)
ffffffffc020330e:	6442                	ld	s0,16(sp)
ffffffffc0203310:	64a2                	ld	s1,8(sp)
ffffffffc0203312:	6902                	ld	s2,0(sp)
ffffffffc0203314:	4501                	li	a0,0
ffffffffc0203316:	6105                	addi	sp,sp,32
ffffffffc0203318:	8082                	ret

ffffffffc020331a <proc_run>:
ffffffffc020331a:	0000a797          	auipc	a5,0xa
ffffffffc020331e:	1be78793          	addi	a5,a5,446 # ffffffffc020d4d8 <current>
ffffffffc0203322:	6398                	ld	a4,0(a5)
ffffffffc0203324:	04a70263          	beq	a4,a0,ffffffffc0203368 <proc_run+0x4e>
ffffffffc0203328:	1101                	addi	sp,sp,-32
ffffffffc020332a:	ec06                	sd	ra,24(sp)
ffffffffc020332c:	100026f3          	csrr	a3,sstatus
ffffffffc0203330:	8a89                	andi	a3,a3,2
ffffffffc0203332:	4601                	li	a2,0
ffffffffc0203334:	ea9d                	bnez	a3,ffffffffc020336a <proc_run+0x50>
ffffffffc0203336:	e388                	sd	a0,0(a5)
ffffffffc0203338:	755c                	ld	a5,168(a0)
ffffffffc020333a:	800006b7          	lui	a3,0x80000
ffffffffc020333e:	e432                	sd	a2,8(sp)
ffffffffc0203340:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc0203344:	8fd5                	or	a5,a5,a3
ffffffffc0203346:	18079073          	csrw	satp,a5
ffffffffc020334a:	03050593          	addi	a1,a0,48
ffffffffc020334e:	03070513          	addi	a0,a4,48
ffffffffc0203352:	524000ef          	jal	ffffffffc0203876 <switch_to>
ffffffffc0203356:	6622                	ld	a2,8(sp)
ffffffffc0203358:	e601                	bnez	a2,ffffffffc0203360 <proc_run+0x46>
ffffffffc020335a:	60e2                	ld	ra,24(sp)
ffffffffc020335c:	6105                	addi	sp,sp,32
ffffffffc020335e:	8082                	ret
ffffffffc0203360:	60e2                	ld	ra,24(sp)
ffffffffc0203362:	6105                	addi	sp,sp,32
ffffffffc0203364:	d0afd06f          	j	ffffffffc020086e <intr_enable>
ffffffffc0203368:	8082                	ret
ffffffffc020336a:	e42a                	sd	a0,8(sp)
ffffffffc020336c:	d08fd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0203370:	0000a797          	auipc	a5,0xa
ffffffffc0203374:	16878793          	addi	a5,a5,360 # ffffffffc020d4d8 <current>
ffffffffc0203378:	6398                	ld	a4,0(a5)
ffffffffc020337a:	6522                	ld	a0,8(sp)
ffffffffc020337c:	4605                	li	a2,1
ffffffffc020337e:	bf65                	j	ffffffffc0203336 <proc_run+0x1c>

ffffffffc0203380 <do_fork>:
ffffffffc0203380:	0000a717          	auipc	a4,0xa
ffffffffc0203384:	15072703          	lw	a4,336(a4) # ffffffffc020d4d0 <nr_process>
ffffffffc0203388:	6785                	lui	a5,0x1
ffffffffc020338a:	1cf75963          	bge	a4,a5,ffffffffc020355c <do_fork+0x1dc>
ffffffffc020338e:	1101                	addi	sp,sp,-32
ffffffffc0203390:	e822                	sd	s0,16(sp)
ffffffffc0203392:	e426                	sd	s1,8(sp)
ffffffffc0203394:	e04a                	sd	s2,0(sp)
ffffffffc0203396:	ec06                	sd	ra,24(sp)
ffffffffc0203398:	892e                	mv	s2,a1
ffffffffc020339a:	8432                	mv	s0,a2
ffffffffc020339c:	e8fff0ef          	jal	ffffffffc020322a <alloc_proc>
ffffffffc02033a0:	84aa                	mv	s1,a0
ffffffffc02033a2:	1a050b63          	beqz	a0,ffffffffc0203558 <do_fork+0x1d8>
ffffffffc02033a6:	4509                	li	a0,2
ffffffffc02033a8:	8d3fe0ef          	jal	ffffffffc0201c7a <alloc_pages>
ffffffffc02033ac:	1a050363          	beqz	a0,ffffffffc0203552 <do_fork+0x1d2>
ffffffffc02033b0:	0000a697          	auipc	a3,0xa
ffffffffc02033b4:	1186b683          	ld	a3,280(a3) # ffffffffc020d4c8 <pages>
ffffffffc02033b8:	00002797          	auipc	a5,0x2
ffffffffc02033bc:	6287b783          	ld	a5,1576(a5) # ffffffffc02059e0 <nbase>
ffffffffc02033c0:	0000a717          	auipc	a4,0xa
ffffffffc02033c4:	10073703          	ld	a4,256(a4) # ffffffffc020d4c0 <npage>
ffffffffc02033c8:	40d506b3          	sub	a3,a0,a3
ffffffffc02033cc:	8699                	srai	a3,a3,0x6
ffffffffc02033ce:	96be                	add	a3,a3,a5
ffffffffc02033d0:	00c69793          	slli	a5,a3,0xc
ffffffffc02033d4:	83b1                	srli	a5,a5,0xc
ffffffffc02033d6:	06b2                	slli	a3,a3,0xc
ffffffffc02033d8:	1ae7f463          	bgeu	a5,a4,ffffffffc0203580 <do_fork+0x200>
ffffffffc02033dc:	0000a897          	auipc	a7,0xa
ffffffffc02033e0:	0fc8b883          	ld	a7,252(a7) # ffffffffc020d4d8 <current>
ffffffffc02033e4:	0000a717          	auipc	a4,0xa
ffffffffc02033e8:	0d473703          	ld	a4,212(a4) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc02033ec:	0288b783          	ld	a5,40(a7)
ffffffffc02033f0:	96ba                	add	a3,a3,a4
ffffffffc02033f2:	e894                	sd	a3,16(s1)
ffffffffc02033f4:	16079663          	bnez	a5,ffffffffc0203560 <do_fork+0x1e0>
ffffffffc02033f8:	6789                	lui	a5,0x2
ffffffffc02033fa:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02033fe:	96be                	add	a3,a3,a5
ffffffffc0203400:	8622                	mv	a2,s0
ffffffffc0203402:	f0d4                	sd	a3,160(s1)
ffffffffc0203404:	87b6                	mv	a5,a3
ffffffffc0203406:	12040713          	addi	a4,s0,288
ffffffffc020340a:	6a0c                	ld	a1,16(a2)
ffffffffc020340c:	00063803          	ld	a6,0(a2)
ffffffffc0203410:	6608                	ld	a0,8(a2)
ffffffffc0203412:	eb8c                	sd	a1,16(a5)
ffffffffc0203414:	0107b023          	sd	a6,0(a5)
ffffffffc0203418:	e788                	sd	a0,8(a5)
ffffffffc020341a:	6e0c                	ld	a1,24(a2)
ffffffffc020341c:	02060613          	addi	a2,a2,32
ffffffffc0203420:	02078793          	addi	a5,a5,32
ffffffffc0203424:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0203428:	fee611e3          	bne	a2,a4,ffffffffc020340a <do_fork+0x8a>
ffffffffc020342c:	0406b823          	sd	zero,80(a3)
ffffffffc0203430:	10090363          	beqz	s2,ffffffffc0203536 <do_fork+0x1b6>
ffffffffc0203434:	00006517          	auipc	a0,0x6
ffffffffc0203438:	bf852503          	lw	a0,-1032(a0) # ffffffffc020902c <last_pid.1>
ffffffffc020343c:	0126b823          	sd	s2,16(a3)
ffffffffc0203440:	00000797          	auipc	a5,0x0
ffffffffc0203444:	e5c78793          	addi	a5,a5,-420 # ffffffffc020329c <forkret>
ffffffffc0203448:	2505                	addiw	a0,a0,1
ffffffffc020344a:	f89c                	sd	a5,48(s1)
ffffffffc020344c:	fc94                	sd	a3,56(s1)
ffffffffc020344e:	00006717          	auipc	a4,0x6
ffffffffc0203452:	bca72f23          	sw	a0,-1058(a4) # ffffffffc020902c <last_pid.1>
ffffffffc0203456:	6789                	lui	a5,0x2
ffffffffc0203458:	0ef55163          	bge	a0,a5,ffffffffc020353a <do_fork+0x1ba>
ffffffffc020345c:	00006797          	auipc	a5,0x6
ffffffffc0203460:	bcc7a783          	lw	a5,-1076(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc0203464:	0000a417          	auipc	s0,0xa
ffffffffc0203468:	ff440413          	addi	s0,s0,-12 # ffffffffc020d458 <proc_list>
ffffffffc020346c:	06f54563          	blt	a0,a5,ffffffffc02034d6 <do_fork+0x156>
ffffffffc0203470:	0000a417          	auipc	s0,0xa
ffffffffc0203474:	fe840413          	addi	s0,s0,-24 # ffffffffc020d458 <proc_list>
ffffffffc0203478:	00843303          	ld	t1,8(s0)
ffffffffc020347c:	6789                	lui	a5,0x2
ffffffffc020347e:	00006717          	auipc	a4,0x6
ffffffffc0203482:	baf72523          	sw	a5,-1110(a4) # ffffffffc0209028 <next_safe.0>
ffffffffc0203486:	86aa                	mv	a3,a0
ffffffffc0203488:	4581                	li	a1,0
ffffffffc020348a:	04830063          	beq	t1,s0,ffffffffc02034ca <do_fork+0x14a>
ffffffffc020348e:	882e                	mv	a6,a1
ffffffffc0203490:	879a                	mv	a5,t1
ffffffffc0203492:	6609                	lui	a2,0x2
ffffffffc0203494:	a811                	j	ffffffffc02034a8 <do_fork+0x128>
ffffffffc0203496:	00e6d663          	bge	a3,a4,ffffffffc02034a2 <do_fork+0x122>
ffffffffc020349a:	00c75463          	bge	a4,a2,ffffffffc02034a2 <do_fork+0x122>
ffffffffc020349e:	863a                	mv	a2,a4
ffffffffc02034a0:	4805                	li	a6,1
ffffffffc02034a2:	679c                	ld	a5,8(a5)
ffffffffc02034a4:	00878d63          	beq	a5,s0,ffffffffc02034be <do_fork+0x13e>
ffffffffc02034a8:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc02034ac:	fed715e3          	bne	a4,a3,ffffffffc0203496 <do_fork+0x116>
ffffffffc02034b0:	2685                	addiw	a3,a3,1
ffffffffc02034b2:	08c6da63          	bge	a3,a2,ffffffffc0203546 <do_fork+0x1c6>
ffffffffc02034b6:	679c                	ld	a5,8(a5)
ffffffffc02034b8:	4585                	li	a1,1
ffffffffc02034ba:	fe8797e3          	bne	a5,s0,ffffffffc02034a8 <do_fork+0x128>
ffffffffc02034be:	00080663          	beqz	a6,ffffffffc02034ca <do_fork+0x14a>
ffffffffc02034c2:	00006797          	auipc	a5,0x6
ffffffffc02034c6:	b6c7a323          	sw	a2,-1178(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc02034ca:	c591                	beqz	a1,ffffffffc02034d6 <do_fork+0x156>
ffffffffc02034cc:	00006797          	auipc	a5,0x6
ffffffffc02034d0:	b6d7a023          	sw	a3,-1184(a5) # ffffffffc020902c <last_pid.1>
ffffffffc02034d4:	8536                	mv	a0,a3
ffffffffc02034d6:	0314b023          	sd	a7,32(s1)
ffffffffc02034da:	45a9                	li	a1,10
ffffffffc02034dc:	c0c8                	sw	a0,4(s1)
ffffffffc02034de:	4c8000ef          	jal	ffffffffc02039a6 <hash32>
ffffffffc02034e2:	02051793          	slli	a5,a0,0x20
ffffffffc02034e6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02034ea:	00006797          	auipc	a5,0x6
ffffffffc02034ee:	f6e78793          	addi	a5,a5,-146 # ffffffffc0209458 <hash_list>
ffffffffc02034f2:	953e                	add	a0,a0,a5
ffffffffc02034f4:	6518                	ld	a4,8(a0)
ffffffffc02034f6:	0d848793          	addi	a5,s1,216
ffffffffc02034fa:	6414                	ld	a3,8(s0)
ffffffffc02034fc:	e31c                	sd	a5,0(a4)
ffffffffc02034fe:	e51c                	sd	a5,8(a0)
ffffffffc0203500:	0000a797          	auipc	a5,0xa
ffffffffc0203504:	fd07a783          	lw	a5,-48(a5) # ffffffffc020d4d0 <nr_process>
ffffffffc0203508:	f0f8                	sd	a4,224(s1)
ffffffffc020350a:	ece8                	sd	a0,216(s1)
ffffffffc020350c:	0c848713          	addi	a4,s1,200
ffffffffc0203510:	e298                	sd	a4,0(a3)
ffffffffc0203512:	8526                	mv	a0,s1
ffffffffc0203514:	2785                	addiw	a5,a5,1
ffffffffc0203516:	e8f4                	sd	a3,208(s1)
ffffffffc0203518:	e4e0                	sd	s0,200(s1)
ffffffffc020351a:	e418                	sd	a4,8(s0)
ffffffffc020351c:	0000a717          	auipc	a4,0xa
ffffffffc0203520:	faf72a23          	sw	a5,-76(a4) # ffffffffc020d4d0 <nr_process>
ffffffffc0203524:	3bc000ef          	jal	ffffffffc02038e0 <wakeup_proc>
ffffffffc0203528:	40c8                	lw	a0,4(s1)
ffffffffc020352a:	60e2                	ld	ra,24(sp)
ffffffffc020352c:	6442                	ld	s0,16(sp)
ffffffffc020352e:	64a2                	ld	s1,8(sp)
ffffffffc0203530:	6902                	ld	s2,0(sp)
ffffffffc0203532:	6105                	addi	sp,sp,32
ffffffffc0203534:	8082                	ret
ffffffffc0203536:	8936                	mv	s2,a3
ffffffffc0203538:	bdf5                	j	ffffffffc0203434 <do_fork+0xb4>
ffffffffc020353a:	4505                	li	a0,1
ffffffffc020353c:	00006797          	auipc	a5,0x6
ffffffffc0203540:	aea7a823          	sw	a0,-1296(a5) # ffffffffc020902c <last_pid.1>
ffffffffc0203544:	b735                	j	ffffffffc0203470 <do_fork+0xf0>
ffffffffc0203546:	6789                	lui	a5,0x2
ffffffffc0203548:	00f6c363          	blt	a3,a5,ffffffffc020354e <do_fork+0x1ce>
ffffffffc020354c:	4685                	li	a3,1
ffffffffc020354e:	4585                	li	a1,1
ffffffffc0203550:	bf2d                	j	ffffffffc020348a <do_fork+0x10a>
ffffffffc0203552:	8526                	mv	a0,s1
ffffffffc0203554:	e0afe0ef          	jal	ffffffffc0201b5e <kfree>
ffffffffc0203558:	5571                	li	a0,-4
ffffffffc020355a:	bfc1                	j	ffffffffc020352a <do_fork+0x1aa>
ffffffffc020355c:	556d                	li	a0,-5
ffffffffc020355e:	8082                	ret
ffffffffc0203560:	00002697          	auipc	a3,0x2
ffffffffc0203564:	ff068693          	addi	a3,a3,-16 # ffffffffc0205550 <etext+0x16c6>
ffffffffc0203568:	00001617          	auipc	a2,0x1
ffffffffc020356c:	2f860613          	addi	a2,a2,760 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0203570:	12800593          	li	a1,296
ffffffffc0203574:	00002517          	auipc	a0,0x2
ffffffffc0203578:	ff450513          	addi	a0,a0,-12 # ffffffffc0205568 <etext+0x16de>
ffffffffc020357c:	e8bfc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0203580:	00001617          	auipc	a2,0x1
ffffffffc0203584:	69060613          	addi	a2,a2,1680 # ffffffffc0204c10 <etext+0xd86>
ffffffffc0203588:	07100593          	li	a1,113
ffffffffc020358c:	00001517          	auipc	a0,0x1
ffffffffc0203590:	6ac50513          	addi	a0,a0,1708 # ffffffffc0204c38 <etext+0xdae>
ffffffffc0203594:	e73fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203598 <kernel_thread>:
ffffffffc0203598:	7129                	addi	sp,sp,-320
ffffffffc020359a:	fa22                	sd	s0,304(sp)
ffffffffc020359c:	f626                	sd	s1,296(sp)
ffffffffc020359e:	f24a                	sd	s2,288(sp)
ffffffffc02035a0:	842a                	mv	s0,a0
ffffffffc02035a2:	84ae                	mv	s1,a1
ffffffffc02035a4:	8932                	mv	s2,a2
ffffffffc02035a6:	850a                	mv	a0,sp
ffffffffc02035a8:	12000613          	li	a2,288
ffffffffc02035ac:	4581                	li	a1,0
ffffffffc02035ae:	fe06                	sd	ra,312(sp)
ffffffffc02035b0:	08d000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc02035b4:	e0a2                	sd	s0,64(sp)
ffffffffc02035b6:	e4a6                	sd	s1,72(sp)
ffffffffc02035b8:	100027f3          	csrr	a5,sstatus
ffffffffc02035bc:	edd7f793          	andi	a5,a5,-291
ffffffffc02035c0:	1207e793          	ori	a5,a5,288
ffffffffc02035c4:	860a                	mv	a2,sp
ffffffffc02035c6:	10096513          	ori	a0,s2,256
ffffffffc02035ca:	00000717          	auipc	a4,0x0
ffffffffc02035ce:	c5870713          	addi	a4,a4,-936 # ffffffffc0203222 <kernel_thread_entry>
ffffffffc02035d2:	4581                	li	a1,0
ffffffffc02035d4:	e23e                	sd	a5,256(sp)
ffffffffc02035d6:	e63a                	sd	a4,264(sp)
ffffffffc02035d8:	da9ff0ef          	jal	ffffffffc0203380 <do_fork>
ffffffffc02035dc:	70f2                	ld	ra,312(sp)
ffffffffc02035de:	7452                	ld	s0,304(sp)
ffffffffc02035e0:	74b2                	ld	s1,296(sp)
ffffffffc02035e2:	7912                	ld	s2,288(sp)
ffffffffc02035e4:	6131                	addi	sp,sp,320
ffffffffc02035e6:	8082                	ret

ffffffffc02035e8 <do_exit>:
ffffffffc02035e8:	1141                	addi	sp,sp,-16
ffffffffc02035ea:	00002617          	auipc	a2,0x2
ffffffffc02035ee:	f9660613          	addi	a2,a2,-106 # ffffffffc0205580 <etext+0x16f6>
ffffffffc02035f2:	19b00593          	li	a1,411
ffffffffc02035f6:	00002517          	auipc	a0,0x2
ffffffffc02035fa:	f7250513          	addi	a0,a0,-142 # ffffffffc0205568 <etext+0x16de>
ffffffffc02035fe:	e406                	sd	ra,8(sp)
ffffffffc0203600:	e07fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203604 <proc_init>:
ffffffffc0203604:	7179                	addi	sp,sp,-48
ffffffffc0203606:	ec26                	sd	s1,24(sp)
ffffffffc0203608:	0000a797          	auipc	a5,0xa
ffffffffc020360c:	e5078793          	addi	a5,a5,-432 # ffffffffc020d458 <proc_list>
ffffffffc0203610:	f406                	sd	ra,40(sp)
ffffffffc0203612:	f022                	sd	s0,32(sp)
ffffffffc0203614:	e84a                	sd	s2,16(sp)
ffffffffc0203616:	e44e                	sd	s3,8(sp)
ffffffffc0203618:	00006497          	auipc	s1,0x6
ffffffffc020361c:	e4048493          	addi	s1,s1,-448 # ffffffffc0209458 <hash_list>
ffffffffc0203620:	e79c                	sd	a5,8(a5)
ffffffffc0203622:	e39c                	sd	a5,0(a5)
ffffffffc0203624:	0000a717          	auipc	a4,0xa
ffffffffc0203628:	e3470713          	addi	a4,a4,-460 # ffffffffc020d458 <proc_list>
ffffffffc020362c:	87a6                	mv	a5,s1
ffffffffc020362e:	e79c                	sd	a5,8(a5)
ffffffffc0203630:	e39c                	sd	a5,0(a5)
ffffffffc0203632:	07c1                	addi	a5,a5,16
ffffffffc0203634:	fee79de3          	bne	a5,a4,ffffffffc020362e <proc_init+0x2a>
ffffffffc0203638:	bf3ff0ef          	jal	ffffffffc020322a <alloc_proc>
ffffffffc020363c:	0000a917          	auipc	s2,0xa
ffffffffc0203640:	eac90913          	addi	s2,s2,-340 # ffffffffc020d4e8 <idleproc>
ffffffffc0203644:	00a93023          	sd	a0,0(s2)
ffffffffc0203648:	1a050263          	beqz	a0,ffffffffc02037ec <proc_init+0x1e8>
ffffffffc020364c:	07000513          	li	a0,112
ffffffffc0203650:	c68fe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc0203654:	07000613          	li	a2,112
ffffffffc0203658:	4581                	li	a1,0
ffffffffc020365a:	842a                	mv	s0,a0
ffffffffc020365c:	7e0000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0203660:	00093503          	ld	a0,0(s2)
ffffffffc0203664:	85a2                	mv	a1,s0
ffffffffc0203666:	07000613          	li	a2,112
ffffffffc020366a:	03050513          	addi	a0,a0,48
ffffffffc020366e:	7f8000ef          	jal	ffffffffc0203e66 <memcmp>
ffffffffc0203672:	89aa                	mv	s3,a0
ffffffffc0203674:	453d                	li	a0,15
ffffffffc0203676:	c42fe0ef          	jal	ffffffffc0201ab8 <kmalloc>
ffffffffc020367a:	463d                	li	a2,15
ffffffffc020367c:	4581                	li	a1,0
ffffffffc020367e:	842a                	mv	s0,a0
ffffffffc0203680:	7bc000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0203684:	00093503          	ld	a0,0(s2)
ffffffffc0203688:	85a2                	mv	a1,s0
ffffffffc020368a:	463d                	li	a2,15
ffffffffc020368c:	0b450513          	addi	a0,a0,180
ffffffffc0203690:	7d6000ef          	jal	ffffffffc0203e66 <memcmp>
ffffffffc0203694:	00093783          	ld	a5,0(s2)
ffffffffc0203698:	0000a717          	auipc	a4,0xa
ffffffffc020369c:	e1073703          	ld	a4,-496(a4) # ffffffffc020d4a8 <boot_pgdir_pa>
ffffffffc02036a0:	77d4                	ld	a3,168(a5)
ffffffffc02036a2:	0ee68863          	beq	a3,a4,ffffffffc0203792 <proc_init+0x18e>
ffffffffc02036a6:	4709                	li	a4,2
ffffffffc02036a8:	e398                	sd	a4,0(a5)
ffffffffc02036aa:	00003717          	auipc	a4,0x3
ffffffffc02036ae:	95670713          	addi	a4,a4,-1706 # ffffffffc0206000 <bootstack>
ffffffffc02036b2:	0b478413          	addi	s0,a5,180
ffffffffc02036b6:	eb98                	sd	a4,16(a5)
ffffffffc02036b8:	4705                	li	a4,1
ffffffffc02036ba:	cf98                	sw	a4,24(a5)
ffffffffc02036bc:	8522                	mv	a0,s0
ffffffffc02036be:	4641                	li	a2,16
ffffffffc02036c0:	4581                	li	a1,0
ffffffffc02036c2:	77a000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc02036c6:	8522                	mv	a0,s0
ffffffffc02036c8:	463d                	li	a2,15
ffffffffc02036ca:	00002597          	auipc	a1,0x2
ffffffffc02036ce:	efe58593          	addi	a1,a1,-258 # ffffffffc02055c8 <etext+0x173e>
ffffffffc02036d2:	77c000ef          	jal	ffffffffc0203e4e <memcpy>
ffffffffc02036d6:	0000a797          	auipc	a5,0xa
ffffffffc02036da:	dfa7a783          	lw	a5,-518(a5) # ffffffffc020d4d0 <nr_process>
ffffffffc02036de:	00093703          	ld	a4,0(s2)
ffffffffc02036e2:	4601                	li	a2,0
ffffffffc02036e4:	2785                	addiw	a5,a5,1
ffffffffc02036e6:	00002597          	auipc	a1,0x2
ffffffffc02036ea:	eea58593          	addi	a1,a1,-278 # ffffffffc02055d0 <etext+0x1746>
ffffffffc02036ee:	00000517          	auipc	a0,0x0
ffffffffc02036f2:	bbc50513          	addi	a0,a0,-1092 # ffffffffc02032aa <init_main>
ffffffffc02036f6:	0000a697          	auipc	a3,0xa
ffffffffc02036fa:	dee6b123          	sd	a4,-542(a3) # ffffffffc020d4d8 <current>
ffffffffc02036fe:	0000a717          	auipc	a4,0xa
ffffffffc0203702:	dcf72923          	sw	a5,-558(a4) # ffffffffc020d4d0 <nr_process>
ffffffffc0203706:	e93ff0ef          	jal	ffffffffc0203598 <kernel_thread>
ffffffffc020370a:	842a                	mv	s0,a0
ffffffffc020370c:	0ea05c63          	blez	a0,ffffffffc0203804 <proc_init+0x200>
ffffffffc0203710:	6789                	lui	a5,0x2
ffffffffc0203712:	17f9                	addi	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc0203714:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203718:	02e7e463          	bltu	a5,a4,ffffffffc0203740 <proc_init+0x13c>
ffffffffc020371c:	45a9                	li	a1,10
ffffffffc020371e:	288000ef          	jal	ffffffffc02039a6 <hash32>
ffffffffc0203722:	02051713          	slli	a4,a0,0x20
ffffffffc0203726:	01c75793          	srli	a5,a4,0x1c
ffffffffc020372a:	00f486b3          	add	a3,s1,a5
ffffffffc020372e:	87b6                	mv	a5,a3
ffffffffc0203730:	a029                	j	ffffffffc020373a <proc_init+0x136>
ffffffffc0203732:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0203736:	0a870863          	beq	a4,s0,ffffffffc02037e6 <proc_init+0x1e2>
ffffffffc020373a:	679c                	ld	a5,8(a5)
ffffffffc020373c:	fef69be3          	bne	a3,a5,ffffffffc0203732 <proc_init+0x12e>
ffffffffc0203740:	4781                	li	a5,0
ffffffffc0203742:	0b478413          	addi	s0,a5,180
ffffffffc0203746:	4641                	li	a2,16
ffffffffc0203748:	4581                	li	a1,0
ffffffffc020374a:	8522                	mv	a0,s0
ffffffffc020374c:	0000a717          	auipc	a4,0xa
ffffffffc0203750:	d8f73a23          	sd	a5,-620(a4) # ffffffffc020d4e0 <initproc>
ffffffffc0203754:	6e8000ef          	jal	ffffffffc0203e3c <memset>
ffffffffc0203758:	8522                	mv	a0,s0
ffffffffc020375a:	463d                	li	a2,15
ffffffffc020375c:	00002597          	auipc	a1,0x2
ffffffffc0203760:	ea458593          	addi	a1,a1,-348 # ffffffffc0205600 <etext+0x1776>
ffffffffc0203764:	6ea000ef          	jal	ffffffffc0203e4e <memcpy>
ffffffffc0203768:	00093783          	ld	a5,0(s2)
ffffffffc020376c:	cbe1                	beqz	a5,ffffffffc020383c <proc_init+0x238>
ffffffffc020376e:	43dc                	lw	a5,4(a5)
ffffffffc0203770:	e7f1                	bnez	a5,ffffffffc020383c <proc_init+0x238>
ffffffffc0203772:	0000a797          	auipc	a5,0xa
ffffffffc0203776:	d6e7b783          	ld	a5,-658(a5) # ffffffffc020d4e0 <initproc>
ffffffffc020377a:	c3cd                	beqz	a5,ffffffffc020381c <proc_init+0x218>
ffffffffc020377c:	43d8                	lw	a4,4(a5)
ffffffffc020377e:	4785                	li	a5,1
ffffffffc0203780:	08f71e63          	bne	a4,a5,ffffffffc020381c <proc_init+0x218>
ffffffffc0203784:	70a2                	ld	ra,40(sp)
ffffffffc0203786:	7402                	ld	s0,32(sp)
ffffffffc0203788:	64e2                	ld	s1,24(sp)
ffffffffc020378a:	6942                	ld	s2,16(sp)
ffffffffc020378c:	69a2                	ld	s3,8(sp)
ffffffffc020378e:	6145                	addi	sp,sp,48
ffffffffc0203790:	8082                	ret
ffffffffc0203792:	73d8                	ld	a4,160(a5)
ffffffffc0203794:	f00719e3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc0203798:	f00997e3          	bnez	s3,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc020379c:	4398                	lw	a4,0(a5)
ffffffffc020379e:	f00714e3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037a2:	43d4                	lw	a3,4(a5)
ffffffffc02037a4:	577d                	li	a4,-1
ffffffffc02037a6:	f0e690e3          	bne	a3,a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037aa:	4798                	lw	a4,8(a5)
ffffffffc02037ac:	ee071de3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037b0:	6b98                	ld	a4,16(a5)
ffffffffc02037b2:	ee071ae3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037b6:	4f98                	lw	a4,24(a5)
ffffffffc02037b8:	ee0717e3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037bc:	7398                	ld	a4,32(a5)
ffffffffc02037be:	ee0714e3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037c2:	7798                	ld	a4,40(a5)
ffffffffc02037c4:	ee0711e3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037c8:	0b07a703          	lw	a4,176(a5)
ffffffffc02037cc:	8f49                	or	a4,a4,a0
ffffffffc02037ce:	2701                	sext.w	a4,a4
ffffffffc02037d0:	ec071be3          	bnez	a4,ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037d4:	00002517          	auipc	a0,0x2
ffffffffc02037d8:	ddc50513          	addi	a0,a0,-548 # ffffffffc02055b0 <etext+0x1726>
ffffffffc02037dc:	9b9fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02037e0:	00093783          	ld	a5,0(s2)
ffffffffc02037e4:	b5c9                	j	ffffffffc02036a6 <proc_init+0xa2>
ffffffffc02037e6:	f2878793          	addi	a5,a5,-216
ffffffffc02037ea:	bfa1                	j	ffffffffc0203742 <proc_init+0x13e>
ffffffffc02037ec:	00002617          	auipc	a2,0x2
ffffffffc02037f0:	dac60613          	addi	a2,a2,-596 # ffffffffc0205598 <etext+0x170e>
ffffffffc02037f4:	1b600593          	li	a1,438
ffffffffc02037f8:	00002517          	auipc	a0,0x2
ffffffffc02037fc:	d7050513          	addi	a0,a0,-656 # ffffffffc0205568 <etext+0x16de>
ffffffffc0203800:	c07fc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0203804:	00002617          	auipc	a2,0x2
ffffffffc0203808:	ddc60613          	addi	a2,a2,-548 # ffffffffc02055e0 <etext+0x1756>
ffffffffc020380c:	1d300593          	li	a1,467
ffffffffc0203810:	00002517          	auipc	a0,0x2
ffffffffc0203814:	d5850513          	addi	a0,a0,-680 # ffffffffc0205568 <etext+0x16de>
ffffffffc0203818:	beffc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020381c:	00002697          	auipc	a3,0x2
ffffffffc0203820:	e1468693          	addi	a3,a3,-492 # ffffffffc0205630 <etext+0x17a6>
ffffffffc0203824:	00001617          	auipc	a2,0x1
ffffffffc0203828:	03c60613          	addi	a2,a2,60 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020382c:	1da00593          	li	a1,474
ffffffffc0203830:	00002517          	auipc	a0,0x2
ffffffffc0203834:	d3850513          	addi	a0,a0,-712 # ffffffffc0205568 <etext+0x16de>
ffffffffc0203838:	bcffc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc020383c:	00002697          	auipc	a3,0x2
ffffffffc0203840:	dcc68693          	addi	a3,a3,-564 # ffffffffc0205608 <etext+0x177e>
ffffffffc0203844:	00001617          	auipc	a2,0x1
ffffffffc0203848:	01c60613          	addi	a2,a2,28 # ffffffffc0204860 <etext+0x9d6>
ffffffffc020384c:	1d900593          	li	a1,473
ffffffffc0203850:	00002517          	auipc	a0,0x2
ffffffffc0203854:	d1850513          	addi	a0,a0,-744 # ffffffffc0205568 <etext+0x16de>
ffffffffc0203858:	baffc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020385c <cpu_idle>:
ffffffffc020385c:	1141                	addi	sp,sp,-16
ffffffffc020385e:	e022                	sd	s0,0(sp)
ffffffffc0203860:	e406                	sd	ra,8(sp)
ffffffffc0203862:	0000a417          	auipc	s0,0xa
ffffffffc0203866:	c7640413          	addi	s0,s0,-906 # ffffffffc020d4d8 <current>
ffffffffc020386a:	6018                	ld	a4,0(s0)
ffffffffc020386c:	4f1c                	lw	a5,24(a4)
ffffffffc020386e:	dffd                	beqz	a5,ffffffffc020386c <cpu_idle+0x10>
ffffffffc0203870:	0a2000ef          	jal	ffffffffc0203912 <schedule>
ffffffffc0203874:	bfdd                	j	ffffffffc020386a <cpu_idle+0xe>

ffffffffc0203876 <switch_to>:
ffffffffc0203876:	00153023          	sd	ra,0(a0)
ffffffffc020387a:	00253423          	sd	sp,8(a0)
ffffffffc020387e:	e900                	sd	s0,16(a0)
ffffffffc0203880:	ed04                	sd	s1,24(a0)
ffffffffc0203882:	03253023          	sd	s2,32(a0)
ffffffffc0203886:	03353423          	sd	s3,40(a0)
ffffffffc020388a:	03453823          	sd	s4,48(a0)
ffffffffc020388e:	03553c23          	sd	s5,56(a0)
ffffffffc0203892:	05653023          	sd	s6,64(a0)
ffffffffc0203896:	05753423          	sd	s7,72(a0)
ffffffffc020389a:	05853823          	sd	s8,80(a0)
ffffffffc020389e:	05953c23          	sd	s9,88(a0)
ffffffffc02038a2:	07a53023          	sd	s10,96(a0)
ffffffffc02038a6:	07b53423          	sd	s11,104(a0)
ffffffffc02038aa:	0005b083          	ld	ra,0(a1)
ffffffffc02038ae:	0085b103          	ld	sp,8(a1)
ffffffffc02038b2:	6980                	ld	s0,16(a1)
ffffffffc02038b4:	6d84                	ld	s1,24(a1)
ffffffffc02038b6:	0205b903          	ld	s2,32(a1)
ffffffffc02038ba:	0285b983          	ld	s3,40(a1)
ffffffffc02038be:	0305ba03          	ld	s4,48(a1)
ffffffffc02038c2:	0385ba83          	ld	s5,56(a1)
ffffffffc02038c6:	0405bb03          	ld	s6,64(a1)
ffffffffc02038ca:	0485bb83          	ld	s7,72(a1)
ffffffffc02038ce:	0505bc03          	ld	s8,80(a1)
ffffffffc02038d2:	0585bc83          	ld	s9,88(a1)
ffffffffc02038d6:	0605bd03          	ld	s10,96(a1)
ffffffffc02038da:	0685bd83          	ld	s11,104(a1)
ffffffffc02038de:	8082                	ret

ffffffffc02038e0 <wakeup_proc>:
ffffffffc02038e0:	411c                	lw	a5,0(a0)
ffffffffc02038e2:	4705                	li	a4,1
ffffffffc02038e4:	37f9                	addiw	a5,a5,-2
ffffffffc02038e6:	00f77563          	bgeu	a4,a5,ffffffffc02038f0 <wakeup_proc+0x10>
ffffffffc02038ea:	4789                	li	a5,2
ffffffffc02038ec:	c11c                	sw	a5,0(a0)
ffffffffc02038ee:	8082                	ret
ffffffffc02038f0:	1141                	addi	sp,sp,-16
ffffffffc02038f2:	00002697          	auipc	a3,0x2
ffffffffc02038f6:	d6668693          	addi	a3,a3,-666 # ffffffffc0205658 <etext+0x17ce>
ffffffffc02038fa:	00001617          	auipc	a2,0x1
ffffffffc02038fe:	f6660613          	addi	a2,a2,-154 # ffffffffc0204860 <etext+0x9d6>
ffffffffc0203902:	45a5                	li	a1,9
ffffffffc0203904:	00002517          	auipc	a0,0x2
ffffffffc0203908:	d9450513          	addi	a0,a0,-620 # ffffffffc0205698 <etext+0x180e>
ffffffffc020390c:	e406                	sd	ra,8(sp)
ffffffffc020390e:	af9fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203912 <schedule>:
ffffffffc0203912:	1101                	addi	sp,sp,-32
ffffffffc0203914:	ec06                	sd	ra,24(sp)
ffffffffc0203916:	100027f3          	csrr	a5,sstatus
ffffffffc020391a:	8b89                	andi	a5,a5,2
ffffffffc020391c:	4301                	li	t1,0
ffffffffc020391e:	e3c1                	bnez	a5,ffffffffc020399e <schedule+0x8c>
ffffffffc0203920:	0000a897          	auipc	a7,0xa
ffffffffc0203924:	bb88b883          	ld	a7,-1096(a7) # ffffffffc020d4d8 <current>
ffffffffc0203928:	0000a517          	auipc	a0,0xa
ffffffffc020392c:	bc053503          	ld	a0,-1088(a0) # ffffffffc020d4e8 <idleproc>
ffffffffc0203930:	0008ac23          	sw	zero,24(a7)
ffffffffc0203934:	04a88f63          	beq	a7,a0,ffffffffc0203992 <schedule+0x80>
ffffffffc0203938:	0c888693          	addi	a3,a7,200
ffffffffc020393c:	0000a617          	auipc	a2,0xa
ffffffffc0203940:	b1c60613          	addi	a2,a2,-1252 # ffffffffc020d458 <proc_list>
ffffffffc0203944:	87b6                	mv	a5,a3
ffffffffc0203946:	4581                	li	a1,0
ffffffffc0203948:	4809                	li	a6,2
ffffffffc020394a:	679c                	ld	a5,8(a5)
ffffffffc020394c:	00c78863          	beq	a5,a2,ffffffffc020395c <schedule+0x4a>
ffffffffc0203950:	f387a703          	lw	a4,-200(a5)
ffffffffc0203954:	f3878593          	addi	a1,a5,-200
ffffffffc0203958:	03070363          	beq	a4,a6,ffffffffc020397e <schedule+0x6c>
ffffffffc020395c:	fef697e3          	bne	a3,a5,ffffffffc020394a <schedule+0x38>
ffffffffc0203960:	ed99                	bnez	a1,ffffffffc020397e <schedule+0x6c>
ffffffffc0203962:	451c                	lw	a5,8(a0)
ffffffffc0203964:	2785                	addiw	a5,a5,1
ffffffffc0203966:	c51c                	sw	a5,8(a0)
ffffffffc0203968:	00a88663          	beq	a7,a0,ffffffffc0203974 <schedule+0x62>
ffffffffc020396c:	e41a                	sd	t1,8(sp)
ffffffffc020396e:	9adff0ef          	jal	ffffffffc020331a <proc_run>
ffffffffc0203972:	6322                	ld	t1,8(sp)
ffffffffc0203974:	00031b63          	bnez	t1,ffffffffc020398a <schedule+0x78>
ffffffffc0203978:	60e2                	ld	ra,24(sp)
ffffffffc020397a:	6105                	addi	sp,sp,32
ffffffffc020397c:	8082                	ret
ffffffffc020397e:	4198                	lw	a4,0(a1)
ffffffffc0203980:	4789                	li	a5,2
ffffffffc0203982:	fef710e3          	bne	a4,a5,ffffffffc0203962 <schedule+0x50>
ffffffffc0203986:	852e                	mv	a0,a1
ffffffffc0203988:	bfe9                	j	ffffffffc0203962 <schedule+0x50>
ffffffffc020398a:	60e2                	ld	ra,24(sp)
ffffffffc020398c:	6105                	addi	sp,sp,32
ffffffffc020398e:	ee1fc06f          	j	ffffffffc020086e <intr_enable>
ffffffffc0203992:	0000a617          	auipc	a2,0xa
ffffffffc0203996:	ac660613          	addi	a2,a2,-1338 # ffffffffc020d458 <proc_list>
ffffffffc020399a:	86b2                	mv	a3,a2
ffffffffc020399c:	b765                	j	ffffffffc0203944 <schedule+0x32>
ffffffffc020399e:	ed7fc0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02039a2:	4305                	li	t1,1
ffffffffc02039a4:	bfb5                	j	ffffffffc0203920 <schedule+0xe>

ffffffffc02039a6 <hash32>:
ffffffffc02039a6:	9e3707b7          	lui	a5,0x9e370
ffffffffc02039aa:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc02039ac:	02a787bb          	mulw	a5,a5,a0
ffffffffc02039b0:	02000513          	li	a0,32
ffffffffc02039b4:	9d0d                	subw	a0,a0,a1
ffffffffc02039b6:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02039ba:	8082                	ret

ffffffffc02039bc <printnum>:
ffffffffc02039bc:	7179                	addi	sp,sp,-48
ffffffffc02039be:	02069813          	slli	a6,a3,0x20
ffffffffc02039c2:	f022                	sd	s0,32(sp)
ffffffffc02039c4:	ec26                	sd	s1,24(sp)
ffffffffc02039c6:	e84a                	sd	s2,16(sp)
ffffffffc02039c8:	e052                	sd	s4,0(sp)
ffffffffc02039ca:	02085813          	srli	a6,a6,0x20
ffffffffc02039ce:	f406                	sd	ra,40(sp)
ffffffffc02039d0:	03067a33          	remu	s4,a2,a6
ffffffffc02039d4:	fff7041b          	addiw	s0,a4,-1
ffffffffc02039d8:	84aa                	mv	s1,a0
ffffffffc02039da:	892e                	mv	s2,a1
ffffffffc02039dc:	03067d63          	bgeu	a2,a6,ffffffffc0203a16 <printnum+0x5a>
ffffffffc02039e0:	e44e                	sd	s3,8(sp)
ffffffffc02039e2:	89be                	mv	s3,a5
ffffffffc02039e4:	4785                	li	a5,1
ffffffffc02039e6:	00e7d763          	bge	a5,a4,ffffffffc02039f4 <printnum+0x38>
ffffffffc02039ea:	85ca                	mv	a1,s2
ffffffffc02039ec:	854e                	mv	a0,s3
ffffffffc02039ee:	347d                	addiw	s0,s0,-1
ffffffffc02039f0:	9482                	jalr	s1
ffffffffc02039f2:	fc65                	bnez	s0,ffffffffc02039ea <printnum+0x2e>
ffffffffc02039f4:	69a2                	ld	s3,8(sp)
ffffffffc02039f6:	00002797          	auipc	a5,0x2
ffffffffc02039fa:	cba78793          	addi	a5,a5,-838 # ffffffffc02056b0 <etext+0x1826>
ffffffffc02039fe:	97d2                	add	a5,a5,s4
ffffffffc0203a00:	7402                	ld	s0,32(sp)
ffffffffc0203a02:	0007c503          	lbu	a0,0(a5)
ffffffffc0203a06:	70a2                	ld	ra,40(sp)
ffffffffc0203a08:	6a02                	ld	s4,0(sp)
ffffffffc0203a0a:	85ca                	mv	a1,s2
ffffffffc0203a0c:	87a6                	mv	a5,s1
ffffffffc0203a0e:	6942                	ld	s2,16(sp)
ffffffffc0203a10:	64e2                	ld	s1,24(sp)
ffffffffc0203a12:	6145                	addi	sp,sp,48
ffffffffc0203a14:	8782                	jr	a5
ffffffffc0203a16:	03065633          	divu	a2,a2,a6
ffffffffc0203a1a:	8722                	mv	a4,s0
ffffffffc0203a1c:	fa1ff0ef          	jal	ffffffffc02039bc <printnum>
ffffffffc0203a20:	bfd9                	j	ffffffffc02039f6 <printnum+0x3a>

ffffffffc0203a22 <vprintfmt>:
ffffffffc0203a22:	7119                	addi	sp,sp,-128
ffffffffc0203a24:	f4a6                	sd	s1,104(sp)
ffffffffc0203a26:	f0ca                	sd	s2,96(sp)
ffffffffc0203a28:	ecce                	sd	s3,88(sp)
ffffffffc0203a2a:	e8d2                	sd	s4,80(sp)
ffffffffc0203a2c:	e4d6                	sd	s5,72(sp)
ffffffffc0203a2e:	e0da                	sd	s6,64(sp)
ffffffffc0203a30:	f862                	sd	s8,48(sp)
ffffffffc0203a32:	fc86                	sd	ra,120(sp)
ffffffffc0203a34:	f8a2                	sd	s0,112(sp)
ffffffffc0203a36:	fc5e                	sd	s7,56(sp)
ffffffffc0203a38:	f466                	sd	s9,40(sp)
ffffffffc0203a3a:	f06a                	sd	s10,32(sp)
ffffffffc0203a3c:	ec6e                	sd	s11,24(sp)
ffffffffc0203a3e:	84aa                	mv	s1,a0
ffffffffc0203a40:	8c32                	mv	s8,a2
ffffffffc0203a42:	8a36                	mv	s4,a3
ffffffffc0203a44:	892e                	mv	s2,a1
ffffffffc0203a46:	02500993          	li	s3,37
ffffffffc0203a4a:	05500b13          	li	s6,85
ffffffffc0203a4e:	00002a97          	auipc	s5,0x2
ffffffffc0203a52:	e02a8a93          	addi	s5,s5,-510 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0203a56:	000c4503          	lbu	a0,0(s8)
ffffffffc0203a5a:	001c0413          	addi	s0,s8,1
ffffffffc0203a5e:	01350a63          	beq	a0,s3,ffffffffc0203a72 <vprintfmt+0x50>
ffffffffc0203a62:	cd0d                	beqz	a0,ffffffffc0203a9c <vprintfmt+0x7a>
ffffffffc0203a64:	85ca                	mv	a1,s2
ffffffffc0203a66:	9482                	jalr	s1
ffffffffc0203a68:	00044503          	lbu	a0,0(s0)
ffffffffc0203a6c:	0405                	addi	s0,s0,1
ffffffffc0203a6e:	ff351ae3          	bne	a0,s3,ffffffffc0203a62 <vprintfmt+0x40>
ffffffffc0203a72:	5cfd                	li	s9,-1
ffffffffc0203a74:	8d66                	mv	s10,s9
ffffffffc0203a76:	02000d93          	li	s11,32
ffffffffc0203a7a:	4b81                	li	s7,0
ffffffffc0203a7c:	4781                	li	a5,0
ffffffffc0203a7e:	00044683          	lbu	a3,0(s0)
ffffffffc0203a82:	00140c13          	addi	s8,s0,1
ffffffffc0203a86:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0203a8a:	0ff5f593          	zext.b	a1,a1
ffffffffc0203a8e:	02bb6663          	bltu	s6,a1,ffffffffc0203aba <vprintfmt+0x98>
ffffffffc0203a92:	058a                	slli	a1,a1,0x2
ffffffffc0203a94:	95d6                	add	a1,a1,s5
ffffffffc0203a96:	4198                	lw	a4,0(a1)
ffffffffc0203a98:	9756                	add	a4,a4,s5
ffffffffc0203a9a:	8702                	jr	a4
ffffffffc0203a9c:	70e6                	ld	ra,120(sp)
ffffffffc0203a9e:	7446                	ld	s0,112(sp)
ffffffffc0203aa0:	74a6                	ld	s1,104(sp)
ffffffffc0203aa2:	7906                	ld	s2,96(sp)
ffffffffc0203aa4:	69e6                	ld	s3,88(sp)
ffffffffc0203aa6:	6a46                	ld	s4,80(sp)
ffffffffc0203aa8:	6aa6                	ld	s5,72(sp)
ffffffffc0203aaa:	6b06                	ld	s6,64(sp)
ffffffffc0203aac:	7be2                	ld	s7,56(sp)
ffffffffc0203aae:	7c42                	ld	s8,48(sp)
ffffffffc0203ab0:	7ca2                	ld	s9,40(sp)
ffffffffc0203ab2:	7d02                	ld	s10,32(sp)
ffffffffc0203ab4:	6de2                	ld	s11,24(sp)
ffffffffc0203ab6:	6109                	addi	sp,sp,128
ffffffffc0203ab8:	8082                	ret
ffffffffc0203aba:	85ca                	mv	a1,s2
ffffffffc0203abc:	02500513          	li	a0,37
ffffffffc0203ac0:	9482                	jalr	s1
ffffffffc0203ac2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203ac6:	02500713          	li	a4,37
ffffffffc0203aca:	8c22                	mv	s8,s0
ffffffffc0203acc:	f8e785e3          	beq	a5,a4,ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203ad0:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0203ad4:	1c7d                	addi	s8,s8,-1
ffffffffc0203ad6:	fee79de3          	bne	a5,a4,ffffffffc0203ad0 <vprintfmt+0xae>
ffffffffc0203ada:	bfb5                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203adc:	00144603          	lbu	a2,1(s0)
ffffffffc0203ae0:	4525                	li	a0,9
ffffffffc0203ae2:	fd068c9b          	addiw	s9,a3,-48
ffffffffc0203ae6:	fd06071b          	addiw	a4,a2,-48
ffffffffc0203aea:	24e56a63          	bltu	a0,a4,ffffffffc0203d3e <vprintfmt+0x31c>
ffffffffc0203aee:	2601                	sext.w	a2,a2
ffffffffc0203af0:	8462                	mv	s0,s8
ffffffffc0203af2:	002c971b          	slliw	a4,s9,0x2
ffffffffc0203af6:	00144683          	lbu	a3,1(s0)
ffffffffc0203afa:	0197073b          	addw	a4,a4,s9
ffffffffc0203afe:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203b02:	9f31                	addw	a4,a4,a2
ffffffffc0203b04:	fd06859b          	addiw	a1,a3,-48
ffffffffc0203b08:	0405                	addi	s0,s0,1
ffffffffc0203b0a:	fd070c9b          	addiw	s9,a4,-48
ffffffffc0203b0e:	0006861b          	sext.w	a2,a3
ffffffffc0203b12:	feb570e3          	bgeu	a0,a1,ffffffffc0203af2 <vprintfmt+0xd0>
ffffffffc0203b16:	f60d54e3          	bgez	s10,ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203b1a:	8d66                	mv	s10,s9
ffffffffc0203b1c:	5cfd                	li	s9,-1
ffffffffc0203b1e:	b785                	j	ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203b20:	8db6                	mv	s11,a3
ffffffffc0203b22:	8462                	mv	s0,s8
ffffffffc0203b24:	bfa9                	j	ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203b26:	8462                	mv	s0,s8
ffffffffc0203b28:	4b85                	li	s7,1
ffffffffc0203b2a:	bf91                	j	ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203b2c:	4705                	li	a4,1
ffffffffc0203b2e:	008a0593          	addi	a1,s4,8
ffffffffc0203b32:	00f74463          	blt	a4,a5,ffffffffc0203b3a <vprintfmt+0x118>
ffffffffc0203b36:	1a078763          	beqz	a5,ffffffffc0203ce4 <vprintfmt+0x2c2>
ffffffffc0203b3a:	000a3603          	ld	a2,0(s4)
ffffffffc0203b3e:	46c1                	li	a3,16
ffffffffc0203b40:	8a2e                	mv	s4,a1
ffffffffc0203b42:	000d879b          	sext.w	a5,s11
ffffffffc0203b46:	876a                	mv	a4,s10
ffffffffc0203b48:	85ca                	mv	a1,s2
ffffffffc0203b4a:	8526                	mv	a0,s1
ffffffffc0203b4c:	e71ff0ef          	jal	ffffffffc02039bc <printnum>
ffffffffc0203b50:	b719                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203b52:	000a2503          	lw	a0,0(s4)
ffffffffc0203b56:	85ca                	mv	a1,s2
ffffffffc0203b58:	0a21                	addi	s4,s4,8
ffffffffc0203b5a:	9482                	jalr	s1
ffffffffc0203b5c:	bded                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203b5e:	4705                	li	a4,1
ffffffffc0203b60:	008a0593          	addi	a1,s4,8
ffffffffc0203b64:	00f74463          	blt	a4,a5,ffffffffc0203b6c <vprintfmt+0x14a>
ffffffffc0203b68:	16078963          	beqz	a5,ffffffffc0203cda <vprintfmt+0x2b8>
ffffffffc0203b6c:	000a3603          	ld	a2,0(s4)
ffffffffc0203b70:	46a9                	li	a3,10
ffffffffc0203b72:	8a2e                	mv	s4,a1
ffffffffc0203b74:	b7f9                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203b76:	85ca                	mv	a1,s2
ffffffffc0203b78:	03000513          	li	a0,48
ffffffffc0203b7c:	9482                	jalr	s1
ffffffffc0203b7e:	85ca                	mv	a1,s2
ffffffffc0203b80:	07800513          	li	a0,120
ffffffffc0203b84:	9482                	jalr	s1
ffffffffc0203b86:	000a3603          	ld	a2,0(s4)
ffffffffc0203b8a:	46c1                	li	a3,16
ffffffffc0203b8c:	0a21                	addi	s4,s4,8
ffffffffc0203b8e:	bf55                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203b90:	85ca                	mv	a1,s2
ffffffffc0203b92:	02500513          	li	a0,37
ffffffffc0203b96:	9482                	jalr	s1
ffffffffc0203b98:	bd7d                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203b9a:	000a2c83          	lw	s9,0(s4)
ffffffffc0203b9e:	8462                	mv	s0,s8
ffffffffc0203ba0:	0a21                	addi	s4,s4,8
ffffffffc0203ba2:	bf95                	j	ffffffffc0203b16 <vprintfmt+0xf4>
ffffffffc0203ba4:	4705                	li	a4,1
ffffffffc0203ba6:	008a0593          	addi	a1,s4,8
ffffffffc0203baa:	00f74463          	blt	a4,a5,ffffffffc0203bb2 <vprintfmt+0x190>
ffffffffc0203bae:	12078163          	beqz	a5,ffffffffc0203cd0 <vprintfmt+0x2ae>
ffffffffc0203bb2:	000a3603          	ld	a2,0(s4)
ffffffffc0203bb6:	46a1                	li	a3,8
ffffffffc0203bb8:	8a2e                	mv	s4,a1
ffffffffc0203bba:	b761                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203bbc:	876a                	mv	a4,s10
ffffffffc0203bbe:	000d5363          	bgez	s10,ffffffffc0203bc4 <vprintfmt+0x1a2>
ffffffffc0203bc2:	4701                	li	a4,0
ffffffffc0203bc4:	00070d1b          	sext.w	s10,a4
ffffffffc0203bc8:	8462                	mv	s0,s8
ffffffffc0203bca:	bd55                	j	ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203bcc:	000d841b          	sext.w	s0,s11
ffffffffc0203bd0:	fd340793          	addi	a5,s0,-45
ffffffffc0203bd4:	00f037b3          	snez	a5,a5
ffffffffc0203bd8:	01a02733          	sgtz	a4,s10
ffffffffc0203bdc:	000a3d83          	ld	s11,0(s4)
ffffffffc0203be0:	8f7d                	and	a4,a4,a5
ffffffffc0203be2:	008a0793          	addi	a5,s4,8
ffffffffc0203be6:	e43e                	sd	a5,8(sp)
ffffffffc0203be8:	100d8c63          	beqz	s11,ffffffffc0203d00 <vprintfmt+0x2de>
ffffffffc0203bec:	12071363          	bnez	a4,ffffffffc0203d12 <vprintfmt+0x2f0>
ffffffffc0203bf0:	000dc783          	lbu	a5,0(s11)
ffffffffc0203bf4:	0007851b          	sext.w	a0,a5
ffffffffc0203bf8:	c78d                	beqz	a5,ffffffffc0203c22 <vprintfmt+0x200>
ffffffffc0203bfa:	0d85                	addi	s11,s11,1
ffffffffc0203bfc:	547d                	li	s0,-1
ffffffffc0203bfe:	05e00a13          	li	s4,94
ffffffffc0203c02:	000cc563          	bltz	s9,ffffffffc0203c0c <vprintfmt+0x1ea>
ffffffffc0203c06:	3cfd                	addiw	s9,s9,-1
ffffffffc0203c08:	008c8d63          	beq	s9,s0,ffffffffc0203c22 <vprintfmt+0x200>
ffffffffc0203c0c:	020b9663          	bnez	s7,ffffffffc0203c38 <vprintfmt+0x216>
ffffffffc0203c10:	85ca                	mv	a1,s2
ffffffffc0203c12:	9482                	jalr	s1
ffffffffc0203c14:	000dc783          	lbu	a5,0(s11)
ffffffffc0203c18:	0d85                	addi	s11,s11,1
ffffffffc0203c1a:	3d7d                	addiw	s10,s10,-1
ffffffffc0203c1c:	0007851b          	sext.w	a0,a5
ffffffffc0203c20:	f3ed                	bnez	a5,ffffffffc0203c02 <vprintfmt+0x1e0>
ffffffffc0203c22:	01a05963          	blez	s10,ffffffffc0203c34 <vprintfmt+0x212>
ffffffffc0203c26:	85ca                	mv	a1,s2
ffffffffc0203c28:	02000513          	li	a0,32
ffffffffc0203c2c:	3d7d                	addiw	s10,s10,-1
ffffffffc0203c2e:	9482                	jalr	s1
ffffffffc0203c30:	fe0d1be3          	bnez	s10,ffffffffc0203c26 <vprintfmt+0x204>
ffffffffc0203c34:	6a22                	ld	s4,8(sp)
ffffffffc0203c36:	b505                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203c38:	3781                	addiw	a5,a5,-32
ffffffffc0203c3a:	fcfa7be3          	bgeu	s4,a5,ffffffffc0203c10 <vprintfmt+0x1ee>
ffffffffc0203c3e:	03f00513          	li	a0,63
ffffffffc0203c42:	85ca                	mv	a1,s2
ffffffffc0203c44:	9482                	jalr	s1
ffffffffc0203c46:	000dc783          	lbu	a5,0(s11)
ffffffffc0203c4a:	0d85                	addi	s11,s11,1
ffffffffc0203c4c:	3d7d                	addiw	s10,s10,-1
ffffffffc0203c4e:	0007851b          	sext.w	a0,a5
ffffffffc0203c52:	dbe1                	beqz	a5,ffffffffc0203c22 <vprintfmt+0x200>
ffffffffc0203c54:	fa0cd9e3          	bgez	s9,ffffffffc0203c06 <vprintfmt+0x1e4>
ffffffffc0203c58:	b7c5                	j	ffffffffc0203c38 <vprintfmt+0x216>
ffffffffc0203c5a:	000a2783          	lw	a5,0(s4)
ffffffffc0203c5e:	4619                	li	a2,6
ffffffffc0203c60:	0a21                	addi	s4,s4,8
ffffffffc0203c62:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0203c66:	8fb9                	xor	a5,a5,a4
ffffffffc0203c68:	40e786bb          	subw	a3,a5,a4
ffffffffc0203c6c:	02d64563          	blt	a2,a3,ffffffffc0203c96 <vprintfmt+0x274>
ffffffffc0203c70:	00002797          	auipc	a5,0x2
ffffffffc0203c74:	d3878793          	addi	a5,a5,-712 # ffffffffc02059a8 <error_string>
ffffffffc0203c78:	00369713          	slli	a4,a3,0x3
ffffffffc0203c7c:	97ba                	add	a5,a5,a4
ffffffffc0203c7e:	639c                	ld	a5,0(a5)
ffffffffc0203c80:	cb99                	beqz	a5,ffffffffc0203c96 <vprintfmt+0x274>
ffffffffc0203c82:	86be                	mv	a3,a5
ffffffffc0203c84:	00000617          	auipc	a2,0x0
ffffffffc0203c88:	23460613          	addi	a2,a2,564 # ffffffffc0203eb8 <etext+0x2e>
ffffffffc0203c8c:	85ca                	mv	a1,s2
ffffffffc0203c8e:	8526                	mv	a0,s1
ffffffffc0203c90:	0d8000ef          	jal	ffffffffc0203d68 <printfmt>
ffffffffc0203c94:	b3c9                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203c96:	00002617          	auipc	a2,0x2
ffffffffc0203c9a:	a3a60613          	addi	a2,a2,-1478 # ffffffffc02056d0 <etext+0x1846>
ffffffffc0203c9e:	85ca                	mv	a1,s2
ffffffffc0203ca0:	8526                	mv	a0,s1
ffffffffc0203ca2:	0c6000ef          	jal	ffffffffc0203d68 <printfmt>
ffffffffc0203ca6:	bb45                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203ca8:	4705                	li	a4,1
ffffffffc0203caa:	008a0b93          	addi	s7,s4,8
ffffffffc0203cae:	00f74363          	blt	a4,a5,ffffffffc0203cb4 <vprintfmt+0x292>
ffffffffc0203cb2:	cf81                	beqz	a5,ffffffffc0203cca <vprintfmt+0x2a8>
ffffffffc0203cb4:	000a3403          	ld	s0,0(s4)
ffffffffc0203cb8:	02044b63          	bltz	s0,ffffffffc0203cee <vprintfmt+0x2cc>
ffffffffc0203cbc:	8622                	mv	a2,s0
ffffffffc0203cbe:	8a5e                	mv	s4,s7
ffffffffc0203cc0:	46a9                	li	a3,10
ffffffffc0203cc2:	b541                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203cc4:	2785                	addiw	a5,a5,1
ffffffffc0203cc6:	8462                	mv	s0,s8
ffffffffc0203cc8:	bb5d                	j	ffffffffc0203a7e <vprintfmt+0x5c>
ffffffffc0203cca:	000a2403          	lw	s0,0(s4)
ffffffffc0203cce:	b7ed                	j	ffffffffc0203cb8 <vprintfmt+0x296>
ffffffffc0203cd0:	000a6603          	lwu	a2,0(s4)
ffffffffc0203cd4:	46a1                	li	a3,8
ffffffffc0203cd6:	8a2e                	mv	s4,a1
ffffffffc0203cd8:	b5ad                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203cda:	000a6603          	lwu	a2,0(s4)
ffffffffc0203cde:	46a9                	li	a3,10
ffffffffc0203ce0:	8a2e                	mv	s4,a1
ffffffffc0203ce2:	b585                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203ce4:	000a6603          	lwu	a2,0(s4)
ffffffffc0203ce8:	46c1                	li	a3,16
ffffffffc0203cea:	8a2e                	mv	s4,a1
ffffffffc0203cec:	bd99                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203cee:	85ca                	mv	a1,s2
ffffffffc0203cf0:	02d00513          	li	a0,45
ffffffffc0203cf4:	9482                	jalr	s1
ffffffffc0203cf6:	40800633          	neg	a2,s0
ffffffffc0203cfa:	8a5e                	mv	s4,s7
ffffffffc0203cfc:	46a9                	li	a3,10
ffffffffc0203cfe:	b591                	j	ffffffffc0203b42 <vprintfmt+0x120>
ffffffffc0203d00:	e329                	bnez	a4,ffffffffc0203d42 <vprintfmt+0x320>
ffffffffc0203d02:	02800793          	li	a5,40
ffffffffc0203d06:	853e                	mv	a0,a5
ffffffffc0203d08:	00002d97          	auipc	s11,0x2
ffffffffc0203d0c:	9c1d8d93          	addi	s11,s11,-1599 # ffffffffc02056c9 <etext+0x183f>
ffffffffc0203d10:	b5f5                	j	ffffffffc0203bfc <vprintfmt+0x1da>
ffffffffc0203d12:	85e6                	mv	a1,s9
ffffffffc0203d14:	856e                	mv	a0,s11
ffffffffc0203d16:	08a000ef          	jal	ffffffffc0203da0 <strnlen>
ffffffffc0203d1a:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0203d1e:	01a05863          	blez	s10,ffffffffc0203d2e <vprintfmt+0x30c>
ffffffffc0203d22:	85ca                	mv	a1,s2
ffffffffc0203d24:	8522                	mv	a0,s0
ffffffffc0203d26:	3d7d                	addiw	s10,s10,-1
ffffffffc0203d28:	9482                	jalr	s1
ffffffffc0203d2a:	fe0d1ce3          	bnez	s10,ffffffffc0203d22 <vprintfmt+0x300>
ffffffffc0203d2e:	000dc783          	lbu	a5,0(s11)
ffffffffc0203d32:	0007851b          	sext.w	a0,a5
ffffffffc0203d36:	ec0792e3          	bnez	a5,ffffffffc0203bfa <vprintfmt+0x1d8>
ffffffffc0203d3a:	6a22                	ld	s4,8(sp)
ffffffffc0203d3c:	bb29                	j	ffffffffc0203a56 <vprintfmt+0x34>
ffffffffc0203d3e:	8462                	mv	s0,s8
ffffffffc0203d40:	bbd9                	j	ffffffffc0203b16 <vprintfmt+0xf4>
ffffffffc0203d42:	85e6                	mv	a1,s9
ffffffffc0203d44:	00002517          	auipc	a0,0x2
ffffffffc0203d48:	98450513          	addi	a0,a0,-1660 # ffffffffc02056c8 <etext+0x183e>
ffffffffc0203d4c:	054000ef          	jal	ffffffffc0203da0 <strnlen>
ffffffffc0203d50:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0203d54:	02800793          	li	a5,40
ffffffffc0203d58:	00002d97          	auipc	s11,0x2
ffffffffc0203d5c:	970d8d93          	addi	s11,s11,-1680 # ffffffffc02056c8 <etext+0x183e>
ffffffffc0203d60:	853e                	mv	a0,a5
ffffffffc0203d62:	fda040e3          	bgtz	s10,ffffffffc0203d22 <vprintfmt+0x300>
ffffffffc0203d66:	bd51                	j	ffffffffc0203bfa <vprintfmt+0x1d8>

ffffffffc0203d68 <printfmt>:
ffffffffc0203d68:	715d                	addi	sp,sp,-80
ffffffffc0203d6a:	02810313          	addi	t1,sp,40
ffffffffc0203d6e:	f436                	sd	a3,40(sp)
ffffffffc0203d70:	869a                	mv	a3,t1
ffffffffc0203d72:	ec06                	sd	ra,24(sp)
ffffffffc0203d74:	f83a                	sd	a4,48(sp)
ffffffffc0203d76:	fc3e                	sd	a5,56(sp)
ffffffffc0203d78:	e0c2                	sd	a6,64(sp)
ffffffffc0203d7a:	e4c6                	sd	a7,72(sp)
ffffffffc0203d7c:	e41a                	sd	t1,8(sp)
ffffffffc0203d7e:	ca5ff0ef          	jal	ffffffffc0203a22 <vprintfmt>
ffffffffc0203d82:	60e2                	ld	ra,24(sp)
ffffffffc0203d84:	6161                	addi	sp,sp,80
ffffffffc0203d86:	8082                	ret

ffffffffc0203d88 <strlen>:
ffffffffc0203d88:	00054783          	lbu	a5,0(a0)
ffffffffc0203d8c:	cb81                	beqz	a5,ffffffffc0203d9c <strlen+0x14>
ffffffffc0203d8e:	4781                	li	a5,0
ffffffffc0203d90:	0785                	addi	a5,a5,1
ffffffffc0203d92:	00f50733          	add	a4,a0,a5
ffffffffc0203d96:	00074703          	lbu	a4,0(a4)
ffffffffc0203d9a:	fb7d                	bnez	a4,ffffffffc0203d90 <strlen+0x8>
ffffffffc0203d9c:	853e                	mv	a0,a5
ffffffffc0203d9e:	8082                	ret

ffffffffc0203da0 <strnlen>:
ffffffffc0203da0:	4781                	li	a5,0
ffffffffc0203da2:	e589                	bnez	a1,ffffffffc0203dac <strnlen+0xc>
ffffffffc0203da4:	a811                	j	ffffffffc0203db8 <strnlen+0x18>
ffffffffc0203da6:	0785                	addi	a5,a5,1
ffffffffc0203da8:	00f58863          	beq	a1,a5,ffffffffc0203db8 <strnlen+0x18>
ffffffffc0203dac:	00f50733          	add	a4,a0,a5
ffffffffc0203db0:	00074703          	lbu	a4,0(a4)
ffffffffc0203db4:	fb6d                	bnez	a4,ffffffffc0203da6 <strnlen+0x6>
ffffffffc0203db6:	85be                	mv	a1,a5
ffffffffc0203db8:	852e                	mv	a0,a1
ffffffffc0203dba:	8082                	ret

ffffffffc0203dbc <strcpy>:
ffffffffc0203dbc:	87aa                	mv	a5,a0
ffffffffc0203dbe:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dc2:	0585                	addi	a1,a1,1
ffffffffc0203dc4:	0785                	addi	a5,a5,1
ffffffffc0203dc6:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203dca:	fb75                	bnez	a4,ffffffffc0203dbe <strcpy+0x2>
ffffffffc0203dcc:	8082                	ret

ffffffffc0203dce <strcmp>:
ffffffffc0203dce:	00054783          	lbu	a5,0(a0)
ffffffffc0203dd2:	e791                	bnez	a5,ffffffffc0203dde <strcmp+0x10>
ffffffffc0203dd4:	a01d                	j	ffffffffc0203dfa <strcmp+0x2c>
ffffffffc0203dd6:	00054783          	lbu	a5,0(a0)
ffffffffc0203dda:	cb99                	beqz	a5,ffffffffc0203df0 <strcmp+0x22>
ffffffffc0203ddc:	0585                	addi	a1,a1,1
ffffffffc0203dde:	0005c703          	lbu	a4,0(a1)
ffffffffc0203de2:	0505                	addi	a0,a0,1
ffffffffc0203de4:	fef709e3          	beq	a4,a5,ffffffffc0203dd6 <strcmp+0x8>
ffffffffc0203de8:	0007851b          	sext.w	a0,a5
ffffffffc0203dec:	9d19                	subw	a0,a0,a4
ffffffffc0203dee:	8082                	ret
ffffffffc0203df0:	0015c703          	lbu	a4,1(a1)
ffffffffc0203df4:	4501                	li	a0,0
ffffffffc0203df6:	9d19                	subw	a0,a0,a4
ffffffffc0203df8:	8082                	ret
ffffffffc0203dfa:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dfe:	4501                	li	a0,0
ffffffffc0203e00:	b7f5                	j	ffffffffc0203dec <strcmp+0x1e>

ffffffffc0203e02 <strncmp>:
ffffffffc0203e02:	ce01                	beqz	a2,ffffffffc0203e1a <strncmp+0x18>
ffffffffc0203e04:	00054783          	lbu	a5,0(a0)
ffffffffc0203e08:	167d                	addi	a2,a2,-1
ffffffffc0203e0a:	cb91                	beqz	a5,ffffffffc0203e1e <strncmp+0x1c>
ffffffffc0203e0c:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e10:	00f71763          	bne	a4,a5,ffffffffc0203e1e <strncmp+0x1c>
ffffffffc0203e14:	0505                	addi	a0,a0,1
ffffffffc0203e16:	0585                	addi	a1,a1,1
ffffffffc0203e18:	f675                	bnez	a2,ffffffffc0203e04 <strncmp+0x2>
ffffffffc0203e1a:	4501                	li	a0,0
ffffffffc0203e1c:	8082                	ret
ffffffffc0203e1e:	00054503          	lbu	a0,0(a0)
ffffffffc0203e22:	0005c783          	lbu	a5,0(a1)
ffffffffc0203e26:	9d1d                	subw	a0,a0,a5
ffffffffc0203e28:	8082                	ret

ffffffffc0203e2a <strchr>:
ffffffffc0203e2a:	a021                	j	ffffffffc0203e32 <strchr+0x8>
ffffffffc0203e2c:	00f58763          	beq	a1,a5,ffffffffc0203e3a <strchr+0x10>
ffffffffc0203e30:	0505                	addi	a0,a0,1
ffffffffc0203e32:	00054783          	lbu	a5,0(a0)
ffffffffc0203e36:	fbfd                	bnez	a5,ffffffffc0203e2c <strchr+0x2>
ffffffffc0203e38:	4501                	li	a0,0
ffffffffc0203e3a:	8082                	ret

ffffffffc0203e3c <memset>:
ffffffffc0203e3c:	ca01                	beqz	a2,ffffffffc0203e4c <memset+0x10>
ffffffffc0203e3e:	962a                	add	a2,a2,a0
ffffffffc0203e40:	87aa                	mv	a5,a0
ffffffffc0203e42:	0785                	addi	a5,a5,1
ffffffffc0203e44:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0203e48:	fef61de3          	bne	a2,a5,ffffffffc0203e42 <memset+0x6>
ffffffffc0203e4c:	8082                	ret

ffffffffc0203e4e <memcpy>:
ffffffffc0203e4e:	ca19                	beqz	a2,ffffffffc0203e64 <memcpy+0x16>
ffffffffc0203e50:	962e                	add	a2,a2,a1
ffffffffc0203e52:	87aa                	mv	a5,a0
ffffffffc0203e54:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e58:	0585                	addi	a1,a1,1
ffffffffc0203e5a:	0785                	addi	a5,a5,1
ffffffffc0203e5c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203e60:	feb61ae3          	bne	a2,a1,ffffffffc0203e54 <memcpy+0x6>
ffffffffc0203e64:	8082                	ret

ffffffffc0203e66 <memcmp>:
ffffffffc0203e66:	c205                	beqz	a2,ffffffffc0203e86 <memcmp+0x20>
ffffffffc0203e68:	962a                	add	a2,a2,a0
ffffffffc0203e6a:	a019                	j	ffffffffc0203e70 <memcmp+0xa>
ffffffffc0203e6c:	00c50d63          	beq	a0,a2,ffffffffc0203e86 <memcmp+0x20>
ffffffffc0203e70:	00054783          	lbu	a5,0(a0)
ffffffffc0203e74:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e78:	0505                	addi	a0,a0,1
ffffffffc0203e7a:	0585                	addi	a1,a1,1
ffffffffc0203e7c:	fee788e3          	beq	a5,a4,ffffffffc0203e6c <memcmp+0x6>
ffffffffc0203e80:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e84:	8082                	ret
ffffffffc0203e86:	4501                	li	a0,0
ffffffffc0203e88:	8082                	ret
