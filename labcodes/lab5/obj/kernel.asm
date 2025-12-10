
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	67650513          	addi	a0,a0,1654 # ffffffffc02916c0 <buf>
ffffffffc0200052:	00096617          	auipc	a2,0x96
ffffffffc0200056:	b1e60613          	addi	a2,a2,-1250 # ffffffffc0295b70 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	624050ef          	jal	ffffffffc0205686 <memset>
    dtb_init();
ffffffffc0200066:	592000ef          	jal	ffffffffc02005f8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	51c000ef          	jal	ffffffffc0200586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	64258593          	addi	a1,a1,1602 # ffffffffc02056b0 <etext>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	65a50513          	addi	a0,a0,1626 # ffffffffc02056d0 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a6000ef          	jal	ffffffffc0200228 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	03d020ef          	jal	ffffffffc02028c2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0f7000ef          	jal	ffffffffc0200980 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0f5000ef          	jal	ffffffffc0200982 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	0dd030ef          	jal	ffffffffc020396e <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	511040ef          	jal	ffffffffc0204da6 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	49a000ef          	jal	ffffffffc0200534 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	0d7000ef          	jal	ffffffffc0200974 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	69f040ef          	jal	ffffffffc0204f40 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a2                	sd	s0,64(sp)
ffffffffc02000ac:	fc26                	sd	s1,56(sp)
ffffffffc02000ae:	f84a                	sd	s2,48(sp)
ffffffffc02000b0:	f44e                	sd	s3,40(sp)
ffffffffc02000b2:	f052                	sd	s4,32(sp)
ffffffffc02000b4:	ec56                	sd	s5,24(sp)
ffffffffc02000b6:	e85a                	sd	s6,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	61c50513          	addi	a0,a0,1564 # ffffffffc02056d8 <etext+0x28>
ffffffffc02000c4:	0d0000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c8:	4401                	li	s0,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	44fd                	li	s1,31
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	4921                	li	s2,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4a29                	li	s4,10
ffffffffc02000d0:	4ab5                	li	s5,13
            buf[i ++] = c;
ffffffffc02000d2:	00091b17          	auipc	s6,0x91
ffffffffc02000d6:	5eeb0b13          	addi	s6,s6,1518 # ffffffffc02916c0 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00993          	li	s3,1022
        c = getchar();
ffffffffc02000de:	13a000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a4da63          	bge	s1,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	0289d263          	bge	s3,s0,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	12a000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03251463          	bne	a0,s2,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	04804963          	bgtz	s0,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200102:	116000ef          	jal	ffffffffc0200218 <getchar>
        if (c < 0) {
ffffffffc0200106:	fe0548e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010a:	fea4d8e3          	bge	s1,a0,ffffffffc02000fa <readline+0x54>
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0b8000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	008b07b3          	add	a5,s6,s0
ffffffffc020011a:	2405                	addiw	s0,s0,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01450463          	beq	a0,s4,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb551ce3          	bne	a0,s5,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	09e000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	00091517          	auipc	a0,0x91
ffffffffc0200132:	59250513          	addi	a0,a0,1426 # ffffffffc02916c0 <buf>
ffffffffc0200136:	942a                	add	s0,s0,a0
ffffffffc0200138:	00040023          	sb	zero,0(s0)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6406                	ld	s0,64(sp)
ffffffffc0200140:	74e2                	ld	s1,56(sp)
ffffffffc0200142:	7942                	ld	s2,48(sp)
ffffffffc0200144:	79a2                	ld	s3,40(sp)
ffffffffc0200146:	7a02                	ld	s4,32(sp)
ffffffffc0200148:	6ae2                	ld	s5,24(sp)
ffffffffc020014a:	6b42                	ld	s6,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	076000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200156:	347d                	addiw	s0,s0,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	426000ef          	jal	ffffffffc0200588 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	0c6050ef          	jal	ffffffffc020524e <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40
{
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb650513          	addi	a0,a0,-74 # ffffffffc020015a <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001b8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001ba:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	092050ef          	jal	ffffffffc020524e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001c8:	a6c1                	j	ffffffffc0200588 <cons_putc>

ffffffffc02001ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ca:	1101                	addi	sp,sp,-32
ffffffffc02001cc:	ec06                	sd	ra,24(sp)
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d2:	00054503          	lbu	a0,0(a0)
ffffffffc02001d6:	c905                	beqz	a0,ffffffffc0200206 <cputs+0x3c>
ffffffffc02001d8:	e426                	sd	s1,8(sp)
ffffffffc02001da:	00178493          	addi	s1,a5,1
ffffffffc02001de:	8426                	mv	s0,s1
    cons_putc(c);
ffffffffc02001e0:	3a8000ef          	jal	ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e4:	00044503          	lbu	a0,0(s0)
ffffffffc02001e8:	87a2                	mv	a5,s0
ffffffffc02001ea:	0405                	addi	s0,s0,1
ffffffffc02001ec:	f975                	bnez	a0,ffffffffc02001e0 <cputs+0x16>
    (*cnt)++;
ffffffffc02001ee:	9f85                	subw	a5,a5,s1
    cons_putc(c);
ffffffffc02001f0:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f2:	0027841b          	addiw	s0,a5,2
ffffffffc02001f6:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001f8:	390000ef          	jal	ffffffffc0200588 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	6105                	addi	sp,sp,32
ffffffffc0200204:	8082                	ret
    cons_putc(c);
ffffffffc0200206:	4529                	li	a0,10
ffffffffc0200208:	380000ef          	jal	ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
}
ffffffffc020020e:	60e2                	ld	ra,24(sp)
ffffffffc0200210:	8522                	mv	a0,s0
ffffffffc0200212:	6442                	ld	s0,16(sp)
ffffffffc0200214:	6105                	addi	sp,sp,32
ffffffffc0200216:	8082                	ret

ffffffffc0200218 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200218:	1141                	addi	sp,sp,-16
ffffffffc020021a:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021c:	3a0000ef          	jal	ffffffffc02005bc <cons_getc>
ffffffffc0200220:	dd75                	beqz	a0,ffffffffc020021c <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200222:	60a2                	ld	ra,8(sp)
ffffffffc0200224:	0141                	addi	sp,sp,16
ffffffffc0200226:	8082                	ret

ffffffffc0200228 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc0200228:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020022a:	00005517          	auipc	a0,0x5
ffffffffc020022e:	4b650513          	addi	a0,a0,1206 # ffffffffc02056e0 <etext+0x30>
{
ffffffffc0200232:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200234:	f61ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200238:	00000597          	auipc	a1,0x0
ffffffffc020023c:	e1258593          	addi	a1,a1,-494 # ffffffffc020004a <kern_init>
ffffffffc0200240:	00005517          	auipc	a0,0x5
ffffffffc0200244:	4c050513          	addi	a0,a0,1216 # ffffffffc0205700 <etext+0x50>
ffffffffc0200248:	f4dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024c:	00005597          	auipc	a1,0x5
ffffffffc0200250:	46458593          	addi	a1,a1,1124 # ffffffffc02056b0 <etext>
ffffffffc0200254:	00005517          	auipc	a0,0x5
ffffffffc0200258:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205720 <etext+0x70>
ffffffffc020025c:	f39ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200260:	00091597          	auipc	a1,0x91
ffffffffc0200264:	46058593          	addi	a1,a1,1120 # ffffffffc02916c0 <buf>
ffffffffc0200268:	00005517          	auipc	a0,0x5
ffffffffc020026c:	4d850513          	addi	a0,a0,1240 # ffffffffc0205740 <etext+0x90>
ffffffffc0200270:	f25ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200274:	00096597          	auipc	a1,0x96
ffffffffc0200278:	8fc58593          	addi	a1,a1,-1796 # ffffffffc0295b70 <end>
ffffffffc020027c:	00005517          	auipc	a0,0x5
ffffffffc0200280:	4e450513          	addi	a0,a0,1252 # ffffffffc0205760 <etext+0xb0>
ffffffffc0200284:	f11ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200288:	00096797          	auipc	a5,0x96
ffffffffc020028c:	ce778793          	addi	a5,a5,-793 # ffffffffc0295f6f <end+0x3ff>
ffffffffc0200290:	00000717          	auipc	a4,0x0
ffffffffc0200294:	dba70713          	addi	a4,a4,-582 # ffffffffc020004a <kern_init>
ffffffffc0200298:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029e:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a0:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a4:	95be                	add	a1,a1,a5
ffffffffc02002a6:	85a9                	srai	a1,a1,0xa
ffffffffc02002a8:	00005517          	auipc	a0,0x5
ffffffffc02002ac:	4d850513          	addi	a0,a0,1240 # ffffffffc0205780 <etext+0xd0>
}
ffffffffc02002b0:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b2:	b5cd                	j	ffffffffc0200194 <cprintf>

ffffffffc02002b4 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002b4:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b6:	00005617          	auipc	a2,0x5
ffffffffc02002ba:	4fa60613          	addi	a2,a2,1274 # ffffffffc02057b0 <etext+0x100>
ffffffffc02002be:	04f00593          	li	a1,79
ffffffffc02002c2:	00005517          	auipc	a0,0x5
ffffffffc02002c6:	50650513          	addi	a0,a0,1286 # ffffffffc02057c8 <etext+0x118>
{
ffffffffc02002ca:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002cc:	1bc000ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02002d0 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002d0:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002d2:	00005617          	auipc	a2,0x5
ffffffffc02002d6:	50e60613          	addi	a2,a2,1294 # ffffffffc02057e0 <etext+0x130>
ffffffffc02002da:	00005597          	auipc	a1,0x5
ffffffffc02002de:	52658593          	addi	a1,a1,1318 # ffffffffc0205800 <etext+0x150>
ffffffffc02002e2:	00005517          	auipc	a0,0x5
ffffffffc02002e6:	52650513          	addi	a0,a0,1318 # ffffffffc0205808 <etext+0x158>
{
ffffffffc02002ea:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ec:	ea9ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02002f0:	00005617          	auipc	a2,0x5
ffffffffc02002f4:	52860613          	addi	a2,a2,1320 # ffffffffc0205818 <etext+0x168>
ffffffffc02002f8:	00005597          	auipc	a1,0x5
ffffffffc02002fc:	54858593          	addi	a1,a1,1352 # ffffffffc0205840 <etext+0x190>
ffffffffc0200300:	00005517          	auipc	a0,0x5
ffffffffc0200304:	50850513          	addi	a0,a0,1288 # ffffffffc0205808 <etext+0x158>
ffffffffc0200308:	e8dff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc020030c:	00005617          	auipc	a2,0x5
ffffffffc0200310:	54460613          	addi	a2,a2,1348 # ffffffffc0205850 <etext+0x1a0>
ffffffffc0200314:	00005597          	auipc	a1,0x5
ffffffffc0200318:	55c58593          	addi	a1,a1,1372 # ffffffffc0205870 <etext+0x1c0>
ffffffffc020031c:	00005517          	auipc	a0,0x5
ffffffffc0200320:	4ec50513          	addi	a0,a0,1260 # ffffffffc0205808 <etext+0x158>
ffffffffc0200324:	e71ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc0200328:	60a2                	ld	ra,8(sp)
ffffffffc020032a:	4501                	li	a0,0
ffffffffc020032c:	0141                	addi	sp,sp,16
ffffffffc020032e:	8082                	ret

ffffffffc0200330 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200330:	1141                	addi	sp,sp,-16
ffffffffc0200332:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200334:	ef5ff0ef          	jal	ffffffffc0200228 <print_kerninfo>
    return 0;
}
ffffffffc0200338:	60a2                	ld	ra,8(sp)
ffffffffc020033a:	4501                	li	a0,0
ffffffffc020033c:	0141                	addi	sp,sp,16
ffffffffc020033e:	8082                	ret

ffffffffc0200340 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200340:	1141                	addi	sp,sp,-16
ffffffffc0200342:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200344:	f71ff0ef          	jal	ffffffffc02002b4 <print_stackframe>
    return 0;
}
ffffffffc0200348:	60a2                	ld	ra,8(sp)
ffffffffc020034a:	4501                	li	a0,0
ffffffffc020034c:	0141                	addi	sp,sp,16
ffffffffc020034e:	8082                	ret

ffffffffc0200350 <kmonitor>:
{
ffffffffc0200350:	7115                	addi	sp,sp,-224
ffffffffc0200352:	f15a                	sd	s6,160(sp)
ffffffffc0200354:	8b2a                	mv	s6,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200356:	00005517          	auipc	a0,0x5
ffffffffc020035a:	52a50513          	addi	a0,a0,1322 # ffffffffc0205880 <etext+0x1d0>
{
ffffffffc020035e:	ed86                	sd	ra,216(sp)
ffffffffc0200360:	e9a2                	sd	s0,208(sp)
ffffffffc0200362:	e5a6                	sd	s1,200(sp)
ffffffffc0200364:	e1ca                	sd	s2,192(sp)
ffffffffc0200366:	fd4e                	sd	s3,184(sp)
ffffffffc0200368:	f952                	sd	s4,176(sp)
ffffffffc020036a:	f556                	sd	s5,168(sp)
ffffffffc020036c:	ed5e                	sd	s7,152(sp)
ffffffffc020036e:	e962                	sd	s8,144(sp)
ffffffffc0200370:	e566                	sd	s9,136(sp)
ffffffffc0200372:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200374:	e21ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200378:	00005517          	auipc	a0,0x5
ffffffffc020037c:	53050513          	addi	a0,a0,1328 # ffffffffc02058a8 <etext+0x1f8>
ffffffffc0200380:	e15ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200384:	000b0563          	beqz	s6,ffffffffc020038e <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200388:	855a                	mv	a0,s6
ffffffffc020038a:	7e0000ef          	jal	ffffffffc0200b6a <print_trapframe>
ffffffffc020038e:	00007c17          	auipc	s8,0x7
ffffffffc0200392:	06ac0c13          	addi	s8,s8,106 # ffffffffc02073f8 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200396:	00005917          	auipc	s2,0x5
ffffffffc020039a:	53a90913          	addi	s2,s2,1338 # ffffffffc02058d0 <etext+0x220>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020039e:	00005497          	auipc	s1,0x5
ffffffffc02003a2:	53a48493          	addi	s1,s1,1338 # ffffffffc02058d8 <etext+0x228>
        if (argc == MAXARGS - 1)
ffffffffc02003a6:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a8:	00005a97          	auipc	s5,0x5
ffffffffc02003ac:	538a8a93          	addi	s5,s5,1336 # ffffffffc02058e0 <etext+0x230>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003b0:	4a0d                	li	s4,3
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003b2:	00005b97          	auipc	s7,0x5
ffffffffc02003b6:	54eb8b93          	addi	s7,s7,1358 # ffffffffc0205900 <etext+0x250>
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003ba:	854a                	mv	a0,s2
ffffffffc02003bc:	cebff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc02003c0:	842a                	mv	s0,a0
ffffffffc02003c2:	dd65                	beqz	a0,ffffffffc02003ba <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003c8:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ca:	e59d                	bnez	a1,ffffffffc02003f8 <kmonitor+0xa8>
    if (argc == 0)
ffffffffc02003cc:	fe0c87e3          	beqz	s9,ffffffffc02003ba <kmonitor+0x6a>
ffffffffc02003d0:	00007d17          	auipc	s10,0x7
ffffffffc02003d4:	028d0d13          	addi	s10,s10,40 # ffffffffc02073f8 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d8:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003da:	6582                	ld	a1,0(sp)
ffffffffc02003dc:	000d3503          	ld	a0,0(s10)
ffffffffc02003e0:	230050ef          	jal	ffffffffc0205610 <strcmp>
ffffffffc02003e4:	c53d                	beqz	a0,ffffffffc0200452 <kmonitor+0x102>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e6:	2405                	addiw	s0,s0,1
ffffffffc02003e8:	0d61                	addi	s10,s10,24
ffffffffc02003ea:	ff4418e3          	bne	s0,s4,ffffffffc02003da <kmonitor+0x8a>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003ee:	6582                	ld	a1,0(sp)
ffffffffc02003f0:	855e                	mv	a0,s7
ffffffffc02003f2:	da3ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003f6:	b7d1                	j	ffffffffc02003ba <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003f8:	8526                	mv	a0,s1
ffffffffc02003fa:	276050ef          	jal	ffffffffc0205670 <strchr>
ffffffffc02003fe:	c901                	beqz	a0,ffffffffc020040e <kmonitor+0xbe>
ffffffffc0200400:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200404:	00040023          	sb	zero,0(s0)
ffffffffc0200408:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020040a:	d1e9                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc020040c:	b7f5                	j	ffffffffc02003f8 <kmonitor+0xa8>
        if (*buf == '\0')
ffffffffc020040e:	00044783          	lbu	a5,0(s0)
ffffffffc0200412:	dfcd                	beqz	a5,ffffffffc02003cc <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200414:	033c8a63          	beq	s9,s3,ffffffffc0200448 <kmonitor+0xf8>
        argv[argc++] = buf;
ffffffffc0200418:	003c9793          	slli	a5,s9,0x3
ffffffffc020041c:	08078793          	addi	a5,a5,128
ffffffffc0200420:	978a                	add	a5,a5,sp
ffffffffc0200422:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200426:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc020042a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc020042c:	e591                	bnez	a1,ffffffffc0200438 <kmonitor+0xe8>
ffffffffc020042e:	bf79                	j	ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200430:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200434:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200436:	d9d9                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200438:	8526                	mv	a0,s1
ffffffffc020043a:	236050ef          	jal	ffffffffc0205670 <strchr>
ffffffffc020043e:	d96d                	beqz	a0,ffffffffc0200430 <kmonitor+0xe0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200440:	00044583          	lbu	a1,0(s0)
ffffffffc0200444:	d5c1                	beqz	a1,ffffffffc02003cc <kmonitor+0x7c>
ffffffffc0200446:	bf4d                	j	ffffffffc02003f8 <kmonitor+0xa8>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200448:	45c1                	li	a1,16
ffffffffc020044a:	8556                	mv	a0,s5
ffffffffc020044c:	d49ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200450:	b7e1                	j	ffffffffc0200418 <kmonitor+0xc8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200452:	00141793          	slli	a5,s0,0x1
ffffffffc0200456:	97a2                	add	a5,a5,s0
ffffffffc0200458:	078e                	slli	a5,a5,0x3
ffffffffc020045a:	97e2                	add	a5,a5,s8
ffffffffc020045c:	6b9c                	ld	a5,16(a5)
ffffffffc020045e:	865a                	mv	a2,s6
ffffffffc0200460:	002c                	addi	a1,sp,8
ffffffffc0200462:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200466:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200468:	f40559e3          	bgez	a0,ffffffffc02003ba <kmonitor+0x6a>
}
ffffffffc020046c:	60ee                	ld	ra,216(sp)
ffffffffc020046e:	644e                	ld	s0,208(sp)
ffffffffc0200470:	64ae                	ld	s1,200(sp)
ffffffffc0200472:	690e                	ld	s2,192(sp)
ffffffffc0200474:	79ea                	ld	s3,184(sp)
ffffffffc0200476:	7a4a                	ld	s4,176(sp)
ffffffffc0200478:	7aaa                	ld	s5,168(sp)
ffffffffc020047a:	7b0a                	ld	s6,160(sp)
ffffffffc020047c:	6bea                	ld	s7,152(sp)
ffffffffc020047e:	6c4a                	ld	s8,144(sp)
ffffffffc0200480:	6caa                	ld	s9,136(sp)
ffffffffc0200482:	6d0a                	ld	s10,128(sp)
ffffffffc0200484:	612d                	addi	sp,sp,224
ffffffffc0200486:	8082                	ret

ffffffffc0200488 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc0200488:	00095317          	auipc	t1,0x95
ffffffffc020048c:	66030313          	addi	t1,t1,1632 # ffffffffc0295ae8 <is_panic>
ffffffffc0200490:	00033e03          	ld	t3,0(t1)
{
ffffffffc0200494:	715d                	addi	sp,sp,-80
ffffffffc0200496:	ec06                	sd	ra,24(sp)
ffffffffc0200498:	f436                	sd	a3,40(sp)
ffffffffc020049a:	f83a                	sd	a4,48(sp)
ffffffffc020049c:	fc3e                	sd	a5,56(sp)
ffffffffc020049e:	e0c2                	sd	a6,64(sp)
ffffffffc02004a0:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004a2:	020e1c63          	bnez	t3,ffffffffc02004da <__panic+0x52>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004a6:	4785                	li	a5,1
ffffffffc02004a8:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004ac:	e822                	sd	s0,16(sp)
ffffffffc02004ae:	103c                	addi	a5,sp,40
ffffffffc02004b0:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b2:	862e                	mv	a2,a1
ffffffffc02004b4:	85aa                	mv	a1,a0
ffffffffc02004b6:	00005517          	auipc	a0,0x5
ffffffffc02004ba:	46250513          	addi	a0,a0,1122 # ffffffffc0205918 <etext+0x268>
    va_start(ap, fmt);
ffffffffc02004be:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c0:	cd5ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004c4:	65a2                	ld	a1,8(sp)
ffffffffc02004c6:	8522                	mv	a0,s0
ffffffffc02004c8:	cadff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004cc:	00005517          	auipc	a0,0x5
ffffffffc02004d0:	46c50513          	addi	a0,a0,1132 # ffffffffc0205938 <etext+0x288>
ffffffffc02004d4:	cc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02004d8:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004da:	4501                	li	a0,0
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	48a1                	li	a7,8
ffffffffc02004e2:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004e6:	494000ef          	jal	ffffffffc020097a <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ea:	4501                	li	a0,0
ffffffffc02004ec:	e65ff0ef          	jal	ffffffffc0200350 <kmonitor>
    while (1)
ffffffffc02004f0:	bfed                	j	ffffffffc02004ea <__panic+0x62>

ffffffffc02004f2 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f2:	715d                	addi	sp,sp,-80
ffffffffc02004f4:	e822                	sd	s0,16(sp)
ffffffffc02004f6:	fc3e                	sd	a5,56(sp)
ffffffffc02004f8:	8432                	mv	s0,a2
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004fa:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	862e                	mv	a2,a1
ffffffffc02004fe:	85aa                	mv	a1,a0
ffffffffc0200500:	00005517          	auipc	a0,0x5
ffffffffc0200504:	44050513          	addi	a0,a0,1088 # ffffffffc0205940 <etext+0x290>
{
ffffffffc0200508:	ec06                	sd	ra,24(sp)
ffffffffc020050a:	f436                	sd	a3,40(sp)
ffffffffc020050c:	f83a                	sd	a4,48(sp)
ffffffffc020050e:	e0c2                	sd	a6,64(sp)
ffffffffc0200510:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200512:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200514:	c81ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200518:	65a2                	ld	a1,8(sp)
ffffffffc020051a:	8522                	mv	a0,s0
ffffffffc020051c:	c59ff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200520:	00005517          	auipc	a0,0x5
ffffffffc0200524:	41850513          	addi	a0,a0,1048 # ffffffffc0205938 <etext+0x288>
ffffffffc0200528:	c6dff0ef          	jal	ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc020052c:	60e2                	ld	ra,24(sp)
ffffffffc020052e:	6442                	ld	s0,16(sp)
ffffffffc0200530:	6161                	addi	sp,sp,80
ffffffffc0200532:	8082                	ret

ffffffffc0200534 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200534:	67e1                	lui	a5,0x18
ffffffffc0200536:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xeb38>
ffffffffc020053a:	00095717          	auipc	a4,0x95
ffffffffc020053e:	5af73b23          	sd	a5,1462(a4) # ffffffffc0295af0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200542:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200546:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200548:	953e                	add	a0,a0,a5
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4881                	li	a7,0
ffffffffc020054e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200552:	02000793          	li	a5,32
ffffffffc0200556:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020055a:	00005517          	auipc	a0,0x5
ffffffffc020055e:	40650513          	addi	a0,a0,1030 # ffffffffc0205960 <etext+0x2b0>
    ticks = 0;
ffffffffc0200562:	00095797          	auipc	a5,0x95
ffffffffc0200566:	5807bb23          	sd	zero,1430(a5) # ffffffffc0295af8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020056a:	b12d                	j	ffffffffc0200194 <cprintf>

ffffffffc020056c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020056c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200570:	00095797          	auipc	a5,0x95
ffffffffc0200574:	5807b783          	ld	a5,1408(a5) # ffffffffc0295af0 <timebase>
ffffffffc0200578:	953e                	add	a0,a0,a5
ffffffffc020057a:	4581                	li	a1,0
ffffffffc020057c:	4601                	li	a2,0
ffffffffc020057e:	4881                	li	a7,0
ffffffffc0200580:	00000073          	ecall
ffffffffc0200584:	8082                	ret

ffffffffc0200586 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200588:	100027f3          	csrr	a5,sstatus
ffffffffc020058c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020058e:	0ff57513          	zext.b	a0,a0
ffffffffc0200592:	e799                	bnez	a5,ffffffffc02005a0 <cons_putc+0x18>
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4885                	li	a7,1
ffffffffc020059a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020059e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005a6:	3d4000ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02005aa:	6522                	ld	a0,8(sp)
ffffffffc02005ac:	4581                	li	a1,0
ffffffffc02005ae:	4601                	li	a2,0
ffffffffc02005b0:	4885                	li	a7,1
ffffffffc02005b2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005b6:	60e2                	ld	ra,24(sp)
ffffffffc02005b8:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005ba:	ae6d                	j	ffffffffc0200974 <intr_enable>

ffffffffc02005bc <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005bc:	100027f3          	csrr	a5,sstatus
ffffffffc02005c0:	8b89                	andi	a5,a5,2
ffffffffc02005c2:	eb89                	bnez	a5,ffffffffc02005d4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005c4:	4501                	li	a0,0
ffffffffc02005c6:	4581                	li	a1,0
ffffffffc02005c8:	4601                	li	a2,0
ffffffffc02005ca:	4889                	li	a7,2
ffffffffc02005cc:	00000073          	ecall
ffffffffc02005d0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d2:	8082                	ret
int cons_getc(void) {
ffffffffc02005d4:	1101                	addi	sp,sp,-32
ffffffffc02005d6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005d8:	3a2000ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02005dc:	4501                	li	a0,0
ffffffffc02005de:	4581                	li	a1,0
ffffffffc02005e0:	4601                	li	a2,0
ffffffffc02005e2:	4889                	li	a7,2
ffffffffc02005e4:	00000073          	ecall
ffffffffc02005e8:	2501                	sext.w	a0,a0
ffffffffc02005ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ec:	388000ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc02005f0:	60e2                	ld	ra,24(sp)
ffffffffc02005f2:	6522                	ld	a0,8(sp)
ffffffffc02005f4:	6105                	addi	sp,sp,32
ffffffffc02005f6:	8082                	ret

ffffffffc02005f8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005f8:	711d                	addi	sp,sp,-96
    cprintf("DTB Init\n");
ffffffffc02005fa:	00005517          	auipc	a0,0x5
ffffffffc02005fe:	38650513          	addi	a0,a0,902 # ffffffffc0205980 <etext+0x2d0>
void dtb_init(void) {
ffffffffc0200602:	ec86                	sd	ra,88(sp)
ffffffffc0200604:	e8a2                	sd	s0,80(sp)
    cprintf("DTB Init\n");
ffffffffc0200606:	b8fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020060a:	0000b597          	auipc	a1,0xb
ffffffffc020060e:	9f65b583          	ld	a1,-1546(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc0200612:	00005517          	auipc	a0,0x5
ffffffffc0200616:	37e50513          	addi	a0,a0,894 # ffffffffc0205990 <etext+0x2e0>
ffffffffc020061a:	b7bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020061e:	0000b417          	auipc	s0,0xb
ffffffffc0200622:	9ea40413          	addi	s0,s0,-1558 # ffffffffc020b008 <boot_dtb>
ffffffffc0200626:	600c                	ld	a1,0(s0)
ffffffffc0200628:	00005517          	auipc	a0,0x5
ffffffffc020062c:	37850513          	addi	a0,a0,888 # ffffffffc02059a0 <etext+0x2f0>
ffffffffc0200630:	b65ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200634:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200636:	00005517          	auipc	a0,0x5
ffffffffc020063a:	38250513          	addi	a0,a0,898 # ffffffffc02059b8 <etext+0x308>
    if (boot_dtb == 0) {
ffffffffc020063e:	12070d63          	beqz	a4,ffffffffc0200778 <dtb_init+0x180>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200642:	57f5                	li	a5,-3
ffffffffc0200644:	07fa                	slli	a5,a5,0x1e
ffffffffc0200646:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200648:	431c                	lw	a5,0(a4)
ffffffffc020064a:	f456                	sd	s5,40(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064c:	00ff0637          	lui	a2,0xff0
ffffffffc0200650:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200654:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200658:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200660:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200664:	6ac1                	lui	s5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200666:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	8ec9                	or	a3,a3,a0
ffffffffc020066a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020066e:	1afd                	addi	s5,s5,-1 # ffff <_binary_obj___user_exit_out_size+0x6497>
ffffffffc0200670:	0157f7b3          	and	a5,a5,s5
ffffffffc0200674:	8dd5                	or	a1,a1,a3
ffffffffc0200676:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200678:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067c:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020067e:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe4a37d>
ffffffffc0200682:	0ef59f63          	bne	a1,a5,ffffffffc0200780 <dtb_init+0x188>
ffffffffc0200686:	471c                	lw	a5,8(a4)
ffffffffc0200688:	4754                	lw	a3,12(a4)
ffffffffc020068a:	fc4e                	sd	s3,56(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068c:	0087d99b          	srliw	s3,a5,0x8
ffffffffc0200690:	0086d41b          	srliw	s0,a3,0x8
ffffffffc0200694:	0186951b          	slliw	a0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200698:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069c:	0187959b          	slliw	a1,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a0:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a8:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ac:	0109999b          	slliw	s3,s3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	8c71                	and	s0,s0,a2
ffffffffc02006b6:	00c9f9b3          	and	s3,s3,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ba:	01156533          	or	a0,a0,a7
ffffffffc02006be:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006c2:	0105e633          	or	a2,a1,a6
ffffffffc02006c6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006ca:	8c49                	or	s0,s0,a0
ffffffffc02006cc:	0156f6b3          	and	a3,a3,s5
ffffffffc02006d0:	00c9e9b3          	or	s3,s3,a2
ffffffffc02006d4:	0157f7b3          	and	a5,a5,s5
ffffffffc02006d8:	8c55                	or	s0,s0,a3
ffffffffc02006da:	00f9e9b3          	or	s3,s3,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006de:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e0:	1982                	slli	s3,s3,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006e2:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006e4:	0209d993          	srli	s3,s3,0x20
ffffffffc02006e8:	e4a6                	sd	s1,72(sp)
ffffffffc02006ea:	e0ca                	sd	s2,64(sp)
ffffffffc02006ec:	ec5e                	sd	s7,24(sp)
ffffffffc02006ee:	e862                	sd	s8,16(sp)
ffffffffc02006f0:	e466                	sd	s9,8(sp)
ffffffffc02006f2:	e06a                	sd	s10,0(sp)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f4:	f852                	sd	s4,48(sp)
    int in_memory_node = 0;
ffffffffc02006f6:	4b81                	li	s7,0
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f8:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fa:	99ba                	add	s3,s3,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fc:	00ff0cb7          	lui	s9,0xff0
        switch (token) {
ffffffffc0200700:	4c0d                	li	s8,3
ffffffffc0200702:	4911                	li	s2,4
ffffffffc0200704:	4d05                	li	s10,1
ffffffffc0200706:	4489                	li	s1,2
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200708:	0009a703          	lw	a4,0(s3)
ffffffffc020070c:	00498a13          	addi	s4,s3,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200710:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200714:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200718:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071c:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200720:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200724:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0196f6b3          	and	a3,a3,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072a:	0087171b          	slliw	a4,a4,0x8
ffffffffc020072e:	8fd5                	or	a5,a5,a3
ffffffffc0200730:	00eaf733          	and	a4,s5,a4
ffffffffc0200734:	8fd9                	or	a5,a5,a4
ffffffffc0200736:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200738:	09878263          	beq	a5,s8,ffffffffc02007bc <dtb_init+0x1c4>
ffffffffc020073c:	00fc6963          	bltu	s8,a5,ffffffffc020074e <dtb_init+0x156>
ffffffffc0200740:	05a78963          	beq	a5,s10,ffffffffc0200792 <dtb_init+0x19a>
ffffffffc0200744:	00979763          	bne	a5,s1,ffffffffc0200752 <dtb_init+0x15a>
ffffffffc0200748:	4b81                	li	s7,0
ffffffffc020074a:	89d2                	mv	s3,s4
ffffffffc020074c:	bf75                	j	ffffffffc0200708 <dtb_init+0x110>
ffffffffc020074e:	ff278ee3          	beq	a5,s2,ffffffffc020074a <dtb_init+0x152>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200752:	00005517          	auipc	a0,0x5
ffffffffc0200756:	32e50513          	addi	a0,a0,814 # ffffffffc0205a80 <etext+0x3d0>
ffffffffc020075a:	a3bff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020075e:	64a6                	ld	s1,72(sp)
ffffffffc0200760:	6906                	ld	s2,64(sp)
ffffffffc0200762:	79e2                	ld	s3,56(sp)
ffffffffc0200764:	7a42                	ld	s4,48(sp)
ffffffffc0200766:	7aa2                	ld	s5,40(sp)
ffffffffc0200768:	6be2                	ld	s7,24(sp)
ffffffffc020076a:	6c42                	ld	s8,16(sp)
ffffffffc020076c:	6ca2                	ld	s9,8(sp)
ffffffffc020076e:	6d02                	ld	s10,0(sp)
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	34850513          	addi	a0,a0,840 # ffffffffc0205ab8 <etext+0x408>
}
ffffffffc0200778:	6446                	ld	s0,80(sp)
ffffffffc020077a:	60e6                	ld	ra,88(sp)
ffffffffc020077c:	6125                	addi	sp,sp,96
    cprintf("DTB init completed\n");
ffffffffc020077e:	bc19                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200780:	6446                	ld	s0,80(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200782:	7aa2                	ld	s5,40(sp)
}
ffffffffc0200784:	60e6                	ld	ra,88(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200786:	00005517          	auipc	a0,0x5
ffffffffc020078a:	25250513          	addi	a0,a0,594 # ffffffffc02059d8 <etext+0x328>
}
ffffffffc020078e:	6125                	addi	sp,sp,96
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200790:	b411                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc0200792:	8552                	mv	a0,s4
ffffffffc0200794:	635040ef          	jal	ffffffffc02055c8 <strlen>
ffffffffc0200798:	89aa                	mv	s3,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020079a:	4619                	li	a2,6
ffffffffc020079c:	00005597          	auipc	a1,0x5
ffffffffc02007a0:	26458593          	addi	a1,a1,612 # ffffffffc0205a00 <etext+0x350>
ffffffffc02007a4:	8552                	mv	a0,s4
                int name_len = strlen(name);
ffffffffc02007a6:	2981                	sext.w	s3,s3
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007a8:	6a1040ef          	jal	ffffffffc0205648 <strncmp>
ffffffffc02007ac:	e111                	bnez	a0,ffffffffc02007b0 <dtb_init+0x1b8>
                    in_memory_node = 1;
ffffffffc02007ae:	4b85                	li	s7,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007b0:	0a11                	addi	s4,s4,4
ffffffffc02007b2:	9a4e                	add	s4,s4,s3
ffffffffc02007b4:	ffca7a13          	andi	s4,s4,-4
        switch (token) {
ffffffffc02007b8:	89d2                	mv	s3,s4
ffffffffc02007ba:	b7b9                	j	ffffffffc0200708 <dtb_init+0x110>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007bc:	0049a783          	lw	a5,4(s3)
ffffffffc02007c0:	f05a                	sd	s6,32(sp)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007c2:	0089a683          	lw	a3,8(s3)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c6:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007ca:	01879b1b          	slliw	s6,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d2:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d6:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007da:	00cb6b33          	or	s6,s6,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007de:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007e6:	00eb6b33          	or	s6,s6,a4
ffffffffc02007ea:	00faf7b3          	and	a5,s5,a5
ffffffffc02007ee:	00fb6b33          	or	s6,s6,a5
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f2:	00c98a13          	addi	s4,s3,12
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	2b01                	sext.w	s6,s6
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007f8:	000b9c63          	bnez	s7,ffffffffc0200810 <dtb_init+0x218>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02007fc:	1b02                	slli	s6,s6,0x20
ffffffffc02007fe:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200802:	0a0d                	addi	s4,s4,3
ffffffffc0200804:	9a5a                	add	s4,s4,s6
ffffffffc0200806:	ffca7a13          	andi	s4,s4,-4
                break;
ffffffffc020080a:	7b02                	ld	s6,32(sp)
        switch (token) {
ffffffffc020080c:	89d2                	mv	s3,s4
ffffffffc020080e:	bded                	j	ffffffffc0200708 <dtb_init+0x110>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200810:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200814:	0186979b          	slliw	a5,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200818:	0186d71b          	srliw	a4,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020081c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200820:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200824:	01957533          	and	a0,a0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200828:	8fd9                	or	a5,a5,a4
ffffffffc020082a:	0086969b          	slliw	a3,a3,0x8
ffffffffc020082e:	8d5d                	or	a0,a0,a5
ffffffffc0200830:	00daf6b3          	and	a3,s5,a3
ffffffffc0200834:	8d55                	or	a0,a0,a3
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200836:	1502                	slli	a0,a0,0x20
ffffffffc0200838:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083a:	00005597          	auipc	a1,0x5
ffffffffc020083e:	1ce58593          	addi	a1,a1,462 # ffffffffc0205a08 <etext+0x358>
ffffffffc0200842:	9522                	add	a0,a0,s0
ffffffffc0200844:	5cd040ef          	jal	ffffffffc0205610 <strcmp>
ffffffffc0200848:	f955                	bnez	a0,ffffffffc02007fc <dtb_init+0x204>
ffffffffc020084a:	47bd                	li	a5,15
ffffffffc020084c:	fb67f8e3          	bgeu	a5,s6,ffffffffc02007fc <dtb_init+0x204>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200850:	00c9b783          	ld	a5,12(s3)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200854:	0149b703          	ld	a4,20(s3)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200858:	00005517          	auipc	a0,0x5
ffffffffc020085c:	1b850513          	addi	a0,a0,440 # ffffffffc0205a10 <etext+0x360>
           fdt32_to_cpu(x >> 32);
ffffffffc0200860:	4207d693          	srai	a3,a5,0x20
ffffffffc0200864:	42075813          	srai	a6,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200868:	0187d39b          	srliw	t2,a5,0x18
ffffffffc020086c:	0186d29b          	srliw	t0,a3,0x18
ffffffffc0200870:	01875f9b          	srliw	t6,a4,0x18
ffffffffc0200874:	01885f1b          	srliw	t5,a6,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200878:	0087d49b          	srliw	s1,a5,0x8
ffffffffc020087c:	0087541b          	srliw	s0,a4,0x8
ffffffffc0200880:	01879e9b          	slliw	t4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200884:	0107d59b          	srliw	a1,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200888:	01869e1b          	slliw	t3,a3,0x18
ffffffffc020088c:	0187131b          	slliw	t1,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200890:	0107561b          	srliw	a2,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200894:	0188189b          	slliw	a7,a6,0x18
ffffffffc0200898:	83e1                	srli	a5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020089a:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	8361                	srli	a4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a0:	0108581b          	srliw	a6,a6,0x10
ffffffffc02008a4:	005e6e33          	or	t3,t3,t0
ffffffffc02008a8:	01e8e8b3          	or	a7,a7,t5
ffffffffc02008ac:	0088181b          	slliw	a6,a6,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008b0:	0104949b          	slliw	s1,s1,0x10
ffffffffc02008b4:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b8:	0085959b          	slliw	a1,a1,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008bc:	0197f7b3          	and	a5,a5,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008c0:	0086969b          	slliw	a3,a3,0x8
ffffffffc02008c4:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c8:	01977733          	and	a4,a4,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008cc:	00daf6b3          	and	a3,s5,a3
ffffffffc02008d0:	007eeeb3          	or	t4,t4,t2
ffffffffc02008d4:	01f36333          	or	t1,t1,t6
ffffffffc02008d8:	01c7e7b3          	or	a5,a5,t3
ffffffffc02008dc:	00caf633          	and	a2,s5,a2
ffffffffc02008e0:	01176733          	or	a4,a4,a7
ffffffffc02008e4:	00baf5b3          	and	a1,s5,a1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e8:	0194f4b3          	and	s1,s1,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ec:	010afab3          	and	s5,s5,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008f0:	01947433          	and	s0,s0,s9
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008f4:	01d4e4b3          	or	s1,s1,t4
ffffffffc02008f8:	00646433          	or	s0,s0,t1
ffffffffc02008fc:	8fd5                	or	a5,a5,a3
ffffffffc02008fe:	01576733          	or	a4,a4,s5
ffffffffc0200902:	8c51                	or	s0,s0,a2
ffffffffc0200904:	8ccd                	or	s1,s1,a1
           fdt32_to_cpu(x >> 32);
ffffffffc0200906:	1782                	slli	a5,a5,0x20
ffffffffc0200908:	1702                	slli	a4,a4,0x20
ffffffffc020090a:	9381                	srli	a5,a5,0x20
ffffffffc020090c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020090e:	1482                	slli	s1,s1,0x20
ffffffffc0200910:	1402                	slli	s0,s0,0x20
ffffffffc0200912:	8cdd                	or	s1,s1,a5
ffffffffc0200914:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200916:	87fff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020091a:	85a6                	mv	a1,s1
ffffffffc020091c:	00005517          	auipc	a0,0x5
ffffffffc0200920:	11450513          	addi	a0,a0,276 # ffffffffc0205a30 <etext+0x380>
ffffffffc0200924:	871ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200928:	01445613          	srli	a2,s0,0x14
ffffffffc020092c:	85a2                	mv	a1,s0
ffffffffc020092e:	00005517          	auipc	a0,0x5
ffffffffc0200932:	11a50513          	addi	a0,a0,282 # ffffffffc0205a48 <etext+0x398>
ffffffffc0200936:	85fff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020093a:	009405b3          	add	a1,s0,s1
ffffffffc020093e:	15fd                	addi	a1,a1,-1
ffffffffc0200940:	00005517          	auipc	a0,0x5
ffffffffc0200944:	12850513          	addi	a0,a0,296 # ffffffffc0205a68 <etext+0x3b8>
ffffffffc0200948:	84dff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc020094c:	7b02                	ld	s6,32(sp)
ffffffffc020094e:	00095797          	auipc	a5,0x95
ffffffffc0200952:	1a97bd23          	sd	s1,442(a5) # ffffffffc0295b08 <memory_base>
        memory_size = mem_size;
ffffffffc0200956:	00095797          	auipc	a5,0x95
ffffffffc020095a:	1a87b523          	sd	s0,426(a5) # ffffffffc0295b00 <memory_size>
ffffffffc020095e:	b501                	j	ffffffffc020075e <dtb_init+0x166>

ffffffffc0200960 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200960:	00095517          	auipc	a0,0x95
ffffffffc0200964:	1a853503          	ld	a0,424(a0) # ffffffffc0295b08 <memory_base>
ffffffffc0200968:	8082                	ret

ffffffffc020096a <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020096a:	00095517          	auipc	a0,0x95
ffffffffc020096e:	19653503          	ld	a0,406(a0) # ffffffffc0295b00 <memory_size>
ffffffffc0200972:	8082                	ret

ffffffffc0200974 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200974:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200978:	8082                	ret

ffffffffc020097a <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020097a:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020097e:	8082                	ret

ffffffffc0200980 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200980:	8082                	ret

ffffffffc0200982 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200982:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200986:	00000797          	auipc	a5,0x0
ffffffffc020098a:	4a678793          	addi	a5,a5,1190 # ffffffffc0200e2c <__alltraps>
ffffffffc020098e:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200992:	000407b7          	lui	a5,0x40
ffffffffc0200996:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020099a:	8082                	ret

ffffffffc020099c <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020099c:	610c                	ld	a1,0(a0)
{
ffffffffc020099e:	1141                	addi	sp,sp,-16
ffffffffc02009a0:	e022                	sd	s0,0(sp)
ffffffffc02009a2:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009a4:	00005517          	auipc	a0,0x5
ffffffffc02009a8:	12c50513          	addi	a0,a0,300 # ffffffffc0205ad0 <etext+0x420>
{
ffffffffc02009ac:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009ae:	fe6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009b2:	640c                	ld	a1,8(s0)
ffffffffc02009b4:	00005517          	auipc	a0,0x5
ffffffffc02009b8:	13450513          	addi	a0,a0,308 # ffffffffc0205ae8 <etext+0x438>
ffffffffc02009bc:	fd8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009c0:	680c                	ld	a1,16(s0)
ffffffffc02009c2:	00005517          	auipc	a0,0x5
ffffffffc02009c6:	13e50513          	addi	a0,a0,318 # ffffffffc0205b00 <etext+0x450>
ffffffffc02009ca:	fcaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02009ce:	6c0c                	ld	a1,24(s0)
ffffffffc02009d0:	00005517          	auipc	a0,0x5
ffffffffc02009d4:	14850513          	addi	a0,a0,328 # ffffffffc0205b18 <etext+0x468>
ffffffffc02009d8:	fbcff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02009dc:	700c                	ld	a1,32(s0)
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	15250513          	addi	a0,a0,338 # ffffffffc0205b30 <etext+0x480>
ffffffffc02009e6:	faeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009ea:	740c                	ld	a1,40(s0)
ffffffffc02009ec:	00005517          	auipc	a0,0x5
ffffffffc02009f0:	15c50513          	addi	a0,a0,348 # ffffffffc0205b48 <etext+0x498>
ffffffffc02009f4:	fa0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009f8:	780c                	ld	a1,48(s0)
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	16650513          	addi	a0,a0,358 # ffffffffc0205b60 <etext+0x4b0>
ffffffffc0200a02:	f92ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a06:	7c0c                	ld	a1,56(s0)
ffffffffc0200a08:	00005517          	auipc	a0,0x5
ffffffffc0200a0c:	17050513          	addi	a0,a0,368 # ffffffffc0205b78 <etext+0x4c8>
ffffffffc0200a10:	f84ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a14:	602c                	ld	a1,64(s0)
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	17a50513          	addi	a0,a0,378 # ffffffffc0205b90 <etext+0x4e0>
ffffffffc0200a1e:	f76ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a22:	642c                	ld	a1,72(s0)
ffffffffc0200a24:	00005517          	auipc	a0,0x5
ffffffffc0200a28:	18450513          	addi	a0,a0,388 # ffffffffc0205ba8 <etext+0x4f8>
ffffffffc0200a2c:	f68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a30:	682c                	ld	a1,80(s0)
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	18e50513          	addi	a0,a0,398 # ffffffffc0205bc0 <etext+0x510>
ffffffffc0200a3a:	f5aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a3e:	6c2c                	ld	a1,88(s0)
ffffffffc0200a40:	00005517          	auipc	a0,0x5
ffffffffc0200a44:	19850513          	addi	a0,a0,408 # ffffffffc0205bd8 <etext+0x528>
ffffffffc0200a48:	f4cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a4c:	702c                	ld	a1,96(s0)
ffffffffc0200a4e:	00005517          	auipc	a0,0x5
ffffffffc0200a52:	1a250513          	addi	a0,a0,418 # ffffffffc0205bf0 <etext+0x540>
ffffffffc0200a56:	f3eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a5a:	742c                	ld	a1,104(s0)
ffffffffc0200a5c:	00005517          	auipc	a0,0x5
ffffffffc0200a60:	1ac50513          	addi	a0,a0,428 # ffffffffc0205c08 <etext+0x558>
ffffffffc0200a64:	f30ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a68:	782c                	ld	a1,112(s0)
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	1b650513          	addi	a0,a0,438 # ffffffffc0205c20 <etext+0x570>
ffffffffc0200a72:	f22ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a76:	7c2c                	ld	a1,120(s0)
ffffffffc0200a78:	00005517          	auipc	a0,0x5
ffffffffc0200a7c:	1c050513          	addi	a0,a0,448 # ffffffffc0205c38 <etext+0x588>
ffffffffc0200a80:	f14ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a84:	604c                	ld	a1,128(s0)
ffffffffc0200a86:	00005517          	auipc	a0,0x5
ffffffffc0200a8a:	1ca50513          	addi	a0,a0,458 # ffffffffc0205c50 <etext+0x5a0>
ffffffffc0200a8e:	f06ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a92:	644c                	ld	a1,136(s0)
ffffffffc0200a94:	00005517          	auipc	a0,0x5
ffffffffc0200a98:	1d450513          	addi	a0,a0,468 # ffffffffc0205c68 <etext+0x5b8>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200aa0:	684c                	ld	a1,144(s0)
ffffffffc0200aa2:	00005517          	auipc	a0,0x5
ffffffffc0200aa6:	1de50513          	addi	a0,a0,478 # ffffffffc0205c80 <etext+0x5d0>
ffffffffc0200aaa:	eeaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200aae:	6c4c                	ld	a1,152(s0)
ffffffffc0200ab0:	00005517          	auipc	a0,0x5
ffffffffc0200ab4:	1e850513          	addi	a0,a0,488 # ffffffffc0205c98 <etext+0x5e8>
ffffffffc0200ab8:	edcff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200abc:	704c                	ld	a1,160(s0)
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	1f250513          	addi	a0,a0,498 # ffffffffc0205cb0 <etext+0x600>
ffffffffc0200ac6:	eceff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200aca:	744c                	ld	a1,168(s0)
ffffffffc0200acc:	00005517          	auipc	a0,0x5
ffffffffc0200ad0:	1fc50513          	addi	a0,a0,508 # ffffffffc0205cc8 <etext+0x618>
ffffffffc0200ad4:	ec0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200ad8:	784c                	ld	a1,176(s0)
ffffffffc0200ada:	00005517          	auipc	a0,0x5
ffffffffc0200ade:	20650513          	addi	a0,a0,518 # ffffffffc0205ce0 <etext+0x630>
ffffffffc0200ae2:	eb2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200ae6:	7c4c                	ld	a1,184(s0)
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	21050513          	addi	a0,a0,528 # ffffffffc0205cf8 <etext+0x648>
ffffffffc0200af0:	ea4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200af4:	606c                	ld	a1,192(s0)
ffffffffc0200af6:	00005517          	auipc	a0,0x5
ffffffffc0200afa:	21a50513          	addi	a0,a0,538 # ffffffffc0205d10 <etext+0x660>
ffffffffc0200afe:	e96ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b02:	646c                	ld	a1,200(s0)
ffffffffc0200b04:	00005517          	auipc	a0,0x5
ffffffffc0200b08:	22450513          	addi	a0,a0,548 # ffffffffc0205d28 <etext+0x678>
ffffffffc0200b0c:	e88ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b10:	686c                	ld	a1,208(s0)
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	22e50513          	addi	a0,a0,558 # ffffffffc0205d40 <etext+0x690>
ffffffffc0200b1a:	e7aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b1e:	6c6c                	ld	a1,216(s0)
ffffffffc0200b20:	00005517          	auipc	a0,0x5
ffffffffc0200b24:	23850513          	addi	a0,a0,568 # ffffffffc0205d58 <etext+0x6a8>
ffffffffc0200b28:	e6cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b2c:	706c                	ld	a1,224(s0)
ffffffffc0200b2e:	00005517          	auipc	a0,0x5
ffffffffc0200b32:	24250513          	addi	a0,a0,578 # ffffffffc0205d70 <etext+0x6c0>
ffffffffc0200b36:	e5eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b3a:	746c                	ld	a1,232(s0)
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	24c50513          	addi	a0,a0,588 # ffffffffc0205d88 <etext+0x6d8>
ffffffffc0200b44:	e50ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b48:	786c                	ld	a1,240(s0)
ffffffffc0200b4a:	00005517          	auipc	a0,0x5
ffffffffc0200b4e:	25650513          	addi	a0,a0,598 # ffffffffc0205da0 <etext+0x6f0>
ffffffffc0200b52:	e42ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b56:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b58:	6402                	ld	s0,0(sp)
ffffffffc0200b5a:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b5c:	00005517          	auipc	a0,0x5
ffffffffc0200b60:	25c50513          	addi	a0,a0,604 # ffffffffc0205db8 <etext+0x708>
}
ffffffffc0200b64:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b66:	e2eff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b6a <print_trapframe>:
{
ffffffffc0200b6a:	1141                	addi	sp,sp,-16
ffffffffc0200b6c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b6e:	85aa                	mv	a1,a0
{
ffffffffc0200b70:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b72:	00005517          	auipc	a0,0x5
ffffffffc0200b76:	25e50513          	addi	a0,a0,606 # ffffffffc0205dd0 <etext+0x720>
{
ffffffffc0200b7a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b7c:	e18ff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b80:	8522                	mv	a0,s0
ffffffffc0200b82:	e1bff0ef          	jal	ffffffffc020099c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b86:	10043583          	ld	a1,256(s0)
ffffffffc0200b8a:	00005517          	auipc	a0,0x5
ffffffffc0200b8e:	25e50513          	addi	a0,a0,606 # ffffffffc0205de8 <etext+0x738>
ffffffffc0200b92:	e02ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b96:	10843583          	ld	a1,264(s0)
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	26650513          	addi	a0,a0,614 # ffffffffc0205e00 <etext+0x750>
ffffffffc0200ba2:	df2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200ba6:	11043583          	ld	a1,272(s0)
ffffffffc0200baa:	00005517          	auipc	a0,0x5
ffffffffc0200bae:	26e50513          	addi	a0,a0,622 # ffffffffc0205e18 <etext+0x768>
ffffffffc0200bb2:	de2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bb6:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bba:	6402                	ld	s0,0(sp)
ffffffffc0200bbc:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	26a50513          	addi	a0,a0,618 # ffffffffc0205e28 <etext+0x778>
}
ffffffffc0200bc6:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bc8:	dccff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200bcc <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200bcc:	11853783          	ld	a5,280(a0)
ffffffffc0200bd0:	472d                	li	a4,11
ffffffffc0200bd2:	0786                	slli	a5,a5,0x1
ffffffffc0200bd4:	8385                	srli	a5,a5,0x1
ffffffffc0200bd6:	08f76963          	bltu	a4,a5,ffffffffc0200c68 <interrupt_handler+0x9c>
ffffffffc0200bda:	00007717          	auipc	a4,0x7
ffffffffc0200bde:	86670713          	addi	a4,a4,-1946 # ffffffffc0207440 <commands+0x48>
ffffffffc0200be2:	078a                	slli	a5,a5,0x2
ffffffffc0200be4:	97ba                	add	a5,a5,a4
ffffffffc0200be6:	439c                	lw	a5,0(a5)
ffffffffc0200be8:	97ba                	add	a5,a5,a4
ffffffffc0200bea:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200bec:	00005517          	auipc	a0,0x5
ffffffffc0200bf0:	2b450513          	addi	a0,a0,692 # ffffffffc0205ea0 <etext+0x7f0>
ffffffffc0200bf4:	da0ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	28850513          	addi	a0,a0,648 # ffffffffc0205e80 <etext+0x7d0>
ffffffffc0200c00:	d94ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c04:	00005517          	auipc	a0,0x5
ffffffffc0200c08:	23c50513          	addi	a0,a0,572 # ffffffffc0205e40 <etext+0x790>
ffffffffc0200c0c:	d88ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c10:	00005517          	auipc	a0,0x5
ffffffffc0200c14:	25050513          	addi	a0,a0,592 # ffffffffc0205e60 <etext+0x7b0>
ffffffffc0200c18:	d7cff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c1c:	1141                	addi	sp,sp,-16
ffffffffc0200c1e:	e406                	sd	ra,8(sp)
        break;
    case IRQ_U_TIMER:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_TIMER:{
        clock_set_next_event();   // 设定下次时钟中断
ffffffffc0200c20:	94dff0ef          	jal	ffffffffc020056c <clock_set_next_event>
        static int ticks = 0;
        static int num = 0;
        ticks++;
ffffffffc0200c24:	00095697          	auipc	a3,0x95
ffffffffc0200c28:	ef068693          	addi	a3,a3,-272 # ffffffffc0295b14 <ticks.1>
ffffffffc0200c2c:	429c                	lw	a5,0(a3)

        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c2e:	06400713          	li	a4,100
        ticks++;
ffffffffc0200c32:	2785                	addiw	a5,a5,1 # 40001 <_binary_obj___user_exit_out_size+0x36499>
        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c34:	02e7e73b          	remw	a4,a5,a4
        ticks++;
ffffffffc0200c38:	c29c                	sw	a5,0(a3)
        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c3a:	cb05                	beqz	a4,ffffffffc0200c6a <interrupt_handler+0x9e>
        print_ticks();
        num++;
        }

        if (num == 10) {              // 打印10次后关机
ffffffffc0200c3c:	00095717          	auipc	a4,0x95
ffffffffc0200c40:	ed472703          	lw	a4,-300(a4) # ffffffffc0295b10 <num.0>
ffffffffc0200c44:	47a9                	li	a5,10
ffffffffc0200c46:	00f71863          	bne	a4,a5,ffffffffc0200c56 <interrupt_handler+0x8a>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c4a:	4501                	li	a0,0
ffffffffc0200c4c:	4581                	li	a1,0
ffffffffc0200c4e:	4601                	li	a2,0
ffffffffc0200c50:	48a1                	li	a7,8
ffffffffc0200c52:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c56:	60a2                	ld	ra,8(sp)
ffffffffc0200c58:	0141                	addi	sp,sp,16
ffffffffc0200c5a:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c5c:	00005517          	auipc	a0,0x5
ffffffffc0200c60:	27450513          	addi	a0,a0,628 # ffffffffc0205ed0 <etext+0x820>
ffffffffc0200c64:	d30ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c68:	b709                	j	ffffffffc0200b6a <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c6a:	06400593          	li	a1,100
ffffffffc0200c6e:	00005517          	auipc	a0,0x5
ffffffffc0200c72:	25250513          	addi	a0,a0,594 # ffffffffc0205ec0 <etext+0x810>
ffffffffc0200c76:	d1eff0ef          	jal	ffffffffc0200194 <cprintf>
        num++;
ffffffffc0200c7a:	00095697          	auipc	a3,0x95
ffffffffc0200c7e:	e9668693          	addi	a3,a3,-362 # ffffffffc0295b10 <num.0>
ffffffffc0200c82:	429c                	lw	a5,0(a3)
ffffffffc0200c84:	0017871b          	addiw	a4,a5,1
ffffffffc0200c88:	c298                	sw	a4,0(a3)
ffffffffc0200c8a:	bf6d                	j	ffffffffc0200c44 <interrupt_handler+0x78>

ffffffffc0200c8c <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c8c:	11853783          	ld	a5,280(a0)
{
ffffffffc0200c90:	1141                	addi	sp,sp,-16
ffffffffc0200c92:	e022                	sd	s0,0(sp)
ffffffffc0200c94:	e406                	sd	ra,8(sp)
    switch (tf->cause)
ffffffffc0200c96:	473d                	li	a4,15
{
ffffffffc0200c98:	842a                	mv	s0,a0
    switch (tf->cause)
ffffffffc0200c9a:	0cf76463          	bltu	a4,a5,ffffffffc0200d62 <exception_handler+0xd6>
ffffffffc0200c9e:	00006717          	auipc	a4,0x6
ffffffffc0200ca2:	7d270713          	addi	a4,a4,2002 # ffffffffc0207470 <commands+0x78>
ffffffffc0200ca6:	078a                	slli	a5,a5,0x2
ffffffffc0200ca8:	97ba                	add	a5,a5,a4
ffffffffc0200caa:	439c                	lw	a5,0(a5)
ffffffffc0200cac:	97ba                	add	a5,a5,a4
ffffffffc0200cae:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cb0:	00005517          	auipc	a0,0x5
ffffffffc0200cb4:	32850513          	addi	a0,a0,808 # ffffffffc0205fd8 <etext+0x928>
ffffffffc0200cb8:	cdcff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cbc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cc0:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cc2:	0791                	addi	a5,a5,4
ffffffffc0200cc4:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cc8:	6402                	ld	s0,0(sp)
ffffffffc0200cca:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200ccc:	47e0406f          	j	ffffffffc020514a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cd0:	00005517          	auipc	a0,0x5
ffffffffc0200cd4:	32850513          	addi	a0,a0,808 # ffffffffc0205ff8 <etext+0x948>
}
ffffffffc0200cd8:	6402                	ld	s0,0(sp)
ffffffffc0200cda:	60a2                	ld	ra,8(sp)
ffffffffc0200cdc:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200cde:	cb6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200ce2:	00005517          	auipc	a0,0x5
ffffffffc0200ce6:	33650513          	addi	a0,a0,822 # ffffffffc0206018 <etext+0x968>
ffffffffc0200cea:	b7fd                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200cec:	00005517          	auipc	a0,0x5
ffffffffc0200cf0:	34c50513          	addi	a0,a0,844 # ffffffffc0206038 <etext+0x988>
ffffffffc0200cf4:	b7d5                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200cf6:	00005517          	auipc	a0,0x5
ffffffffc0200cfa:	35a50513          	addi	a0,a0,858 # ffffffffc0206050 <etext+0x9a0>
ffffffffc0200cfe:	bfe9                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d00:	00005517          	auipc	a0,0x5
ffffffffc0200d04:	36850513          	addi	a0,a0,872 # ffffffffc0206068 <etext+0x9b8>
ffffffffc0200d08:	bfc1                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d0a:	00005517          	auipc	a0,0x5
ffffffffc0200d0e:	1e650513          	addi	a0,a0,486 # ffffffffc0205ef0 <etext+0x840>
ffffffffc0200d12:	b7d9                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d14:	00005517          	auipc	a0,0x5
ffffffffc0200d18:	1fc50513          	addi	a0,a0,508 # ffffffffc0205f10 <etext+0x860>
ffffffffc0200d1c:	bf75                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d1e:	00005517          	auipc	a0,0x5
ffffffffc0200d22:	21250513          	addi	a0,a0,530 # ffffffffc0205f30 <etext+0x880>
ffffffffc0200d26:	bf4d                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d28:	00005517          	auipc	a0,0x5
ffffffffc0200d2c:	22050513          	addi	a0,a0,544 # ffffffffc0205f48 <etext+0x898>
ffffffffc0200d30:	c64ff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d34:	6458                	ld	a4,136(s0)
ffffffffc0200d36:	47a9                	li	a5,10
ffffffffc0200d38:	04f70663          	beq	a4,a5,ffffffffc0200d84 <exception_handler+0xf8>
}
ffffffffc0200d3c:	60a2                	ld	ra,8(sp)
ffffffffc0200d3e:	6402                	ld	s0,0(sp)
ffffffffc0200d40:	0141                	addi	sp,sp,16
ffffffffc0200d42:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d44:	00005517          	auipc	a0,0x5
ffffffffc0200d48:	21450513          	addi	a0,a0,532 # ffffffffc0205f58 <etext+0x8a8>
ffffffffc0200d4c:	b771                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d4e:	00005517          	auipc	a0,0x5
ffffffffc0200d52:	22a50513          	addi	a0,a0,554 # ffffffffc0205f78 <etext+0x8c8>
ffffffffc0200d56:	b749                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d58:	00005517          	auipc	a0,0x5
ffffffffc0200d5c:	26850513          	addi	a0,a0,616 # ffffffffc0205fc0 <etext+0x910>
ffffffffc0200d60:	bfa5                	j	ffffffffc0200cd8 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d62:	8522                	mv	a0,s0
}
ffffffffc0200d64:	6402                	ld	s0,0(sp)
ffffffffc0200d66:	60a2                	ld	ra,8(sp)
ffffffffc0200d68:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d6a:	b501                	j	ffffffffc0200b6a <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d6c:	00005617          	auipc	a2,0x5
ffffffffc0200d70:	22460613          	addi	a2,a2,548 # ffffffffc0205f90 <etext+0x8e0>
ffffffffc0200d74:	0c600593          	li	a1,198
ffffffffc0200d78:	00005517          	auipc	a0,0x5
ffffffffc0200d7c:	23050513          	addi	a0,a0,560 # ffffffffc0205fa8 <etext+0x8f8>
ffffffffc0200d80:	f08ff0ef          	jal	ffffffffc0200488 <__panic>
            tf->epc += 4;
ffffffffc0200d84:	10843783          	ld	a5,264(s0)
ffffffffc0200d88:	0791                	addi	a5,a5,4
ffffffffc0200d8a:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200d8e:	3bc040ef          	jal	ffffffffc020514a <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d92:	00095797          	auipc	a5,0x95
ffffffffc0200d96:	dc67b783          	ld	a5,-570(a5) # ffffffffc0295b58 <current>
ffffffffc0200d9a:	6b9c                	ld	a5,16(a5)
ffffffffc0200d9c:	8522                	mv	a0,s0
}
ffffffffc0200d9e:	6402                	ld	s0,0(sp)
ffffffffc0200da0:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200da2:	6589                	lui	a1,0x2
ffffffffc0200da4:	95be                	add	a1,a1,a5
}
ffffffffc0200da6:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200da8:	aa89                	j	ffffffffc0200efa <kernel_execve_ret>

ffffffffc0200daa <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200daa:	1101                	addi	sp,sp,-32
ffffffffc0200dac:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dae:	00095417          	auipc	s0,0x95
ffffffffc0200db2:	daa40413          	addi	s0,s0,-598 # ffffffffc0295b58 <current>
ffffffffc0200db6:	6018                	ld	a4,0(s0)
{
ffffffffc0200db8:	ec06                	sd	ra,24(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dba:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200dbe:	c329                	beqz	a4,ffffffffc0200e00 <trap+0x56>
ffffffffc0200dc0:	e426                	sd	s1,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dc2:	10053483          	ld	s1,256(a0)
ffffffffc0200dc6:	e04a                	sd	s2,0(sp)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dc8:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200dcc:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dce:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dd2:	0206c463          	bltz	a3,ffffffffc0200dfa <trap+0x50>
        exception_handler(tf);
ffffffffc0200dd6:	eb7ff0ef          	jal	ffffffffc0200c8c <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200dda:	601c                	ld	a5,0(s0)
ffffffffc0200ddc:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200de0:	e499                	bnez	s1,ffffffffc0200dee <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200de2:	0b07a703          	lw	a4,176(a5)
ffffffffc0200de6:	8b05                	andi	a4,a4,1
ffffffffc0200de8:	ef0d                	bnez	a4,ffffffffc0200e22 <trap+0x78>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200dea:	6f9c                	ld	a5,24(a5)
ffffffffc0200dec:	e785                	bnez	a5,ffffffffc0200e14 <trap+0x6a>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200dee:	60e2                	ld	ra,24(sp)
ffffffffc0200df0:	6442                	ld	s0,16(sp)
ffffffffc0200df2:	64a2                	ld	s1,8(sp)
ffffffffc0200df4:	6902                	ld	s2,0(sp)
ffffffffc0200df6:	6105                	addi	sp,sp,32
ffffffffc0200df8:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200dfa:	dd3ff0ef          	jal	ffffffffc0200bcc <interrupt_handler>
ffffffffc0200dfe:	bff1                	j	ffffffffc0200dda <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e00:	0006c663          	bltz	a3,ffffffffc0200e0c <trap+0x62>
}
ffffffffc0200e04:	6442                	ld	s0,16(sp)
ffffffffc0200e06:	60e2                	ld	ra,24(sp)
ffffffffc0200e08:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e0a:	b549                	j	ffffffffc0200c8c <exception_handler>
}
ffffffffc0200e0c:	6442                	ld	s0,16(sp)
ffffffffc0200e0e:	60e2                	ld	ra,24(sp)
ffffffffc0200e10:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e12:	bb6d                	j	ffffffffc0200bcc <interrupt_handler>
}
ffffffffc0200e14:	6442                	ld	s0,16(sp)
                schedule();
ffffffffc0200e16:	64a2                	ld	s1,8(sp)
ffffffffc0200e18:	6902                	ld	s2,0(sp)
}
ffffffffc0200e1a:	60e2                	ld	ra,24(sp)
ffffffffc0200e1c:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e1e:	2400406f          	j	ffffffffc020505e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e22:	555d                	li	a0,-9
ffffffffc0200e24:	55a030ef          	jal	ffffffffc020437e <do_exit>
            if (current->need_resched)
ffffffffc0200e28:	601c                	ld	a5,0(s0)
ffffffffc0200e2a:	b7c1                	j	ffffffffc0200dea <trap+0x40>

ffffffffc0200e2c <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e2c:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e30:	00011463          	bnez	sp,ffffffffc0200e38 <__alltraps+0xc>
ffffffffc0200e34:	14002173          	csrr	sp,sscratch
ffffffffc0200e38:	712d                	addi	sp,sp,-288
ffffffffc0200e3a:	e002                	sd	zero,0(sp)
ffffffffc0200e3c:	e406                	sd	ra,8(sp)
ffffffffc0200e3e:	ec0e                	sd	gp,24(sp)
ffffffffc0200e40:	f012                	sd	tp,32(sp)
ffffffffc0200e42:	f416                	sd	t0,40(sp)
ffffffffc0200e44:	f81a                	sd	t1,48(sp)
ffffffffc0200e46:	fc1e                	sd	t2,56(sp)
ffffffffc0200e48:	e0a2                	sd	s0,64(sp)
ffffffffc0200e4a:	e4a6                	sd	s1,72(sp)
ffffffffc0200e4c:	e8aa                	sd	a0,80(sp)
ffffffffc0200e4e:	ecae                	sd	a1,88(sp)
ffffffffc0200e50:	f0b2                	sd	a2,96(sp)
ffffffffc0200e52:	f4b6                	sd	a3,104(sp)
ffffffffc0200e54:	f8ba                	sd	a4,112(sp)
ffffffffc0200e56:	fcbe                	sd	a5,120(sp)
ffffffffc0200e58:	e142                	sd	a6,128(sp)
ffffffffc0200e5a:	e546                	sd	a7,136(sp)
ffffffffc0200e5c:	e94a                	sd	s2,144(sp)
ffffffffc0200e5e:	ed4e                	sd	s3,152(sp)
ffffffffc0200e60:	f152                	sd	s4,160(sp)
ffffffffc0200e62:	f556                	sd	s5,168(sp)
ffffffffc0200e64:	f95a                	sd	s6,176(sp)
ffffffffc0200e66:	fd5e                	sd	s7,184(sp)
ffffffffc0200e68:	e1e2                	sd	s8,192(sp)
ffffffffc0200e6a:	e5e6                	sd	s9,200(sp)
ffffffffc0200e6c:	e9ea                	sd	s10,208(sp)
ffffffffc0200e6e:	edee                	sd	s11,216(sp)
ffffffffc0200e70:	f1f2                	sd	t3,224(sp)
ffffffffc0200e72:	f5f6                	sd	t4,232(sp)
ffffffffc0200e74:	f9fa                	sd	t5,240(sp)
ffffffffc0200e76:	fdfe                	sd	t6,248(sp)
ffffffffc0200e78:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e7c:	100024f3          	csrr	s1,sstatus
ffffffffc0200e80:	14102973          	csrr	s2,sepc
ffffffffc0200e84:	143029f3          	csrr	s3,stval
ffffffffc0200e88:	14202a73          	csrr	s4,scause
ffffffffc0200e8c:	e822                	sd	s0,16(sp)
ffffffffc0200e8e:	e226                	sd	s1,256(sp)
ffffffffc0200e90:	e64a                	sd	s2,264(sp)
ffffffffc0200e92:	ea4e                	sd	s3,272(sp)
ffffffffc0200e94:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e96:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e98:	f13ff0ef          	jal	ffffffffc0200daa <trap>

ffffffffc0200e9c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e9c:	6492                	ld	s1,256(sp)
ffffffffc0200e9e:	6932                	ld	s2,264(sp)
ffffffffc0200ea0:	1004f413          	andi	s0,s1,256
ffffffffc0200ea4:	e401                	bnez	s0,ffffffffc0200eac <__trapret+0x10>
ffffffffc0200ea6:	1200                	addi	s0,sp,288
ffffffffc0200ea8:	14041073          	csrw	sscratch,s0
ffffffffc0200eac:	10049073          	csrw	sstatus,s1
ffffffffc0200eb0:	14191073          	csrw	sepc,s2
ffffffffc0200eb4:	60a2                	ld	ra,8(sp)
ffffffffc0200eb6:	61e2                	ld	gp,24(sp)
ffffffffc0200eb8:	7202                	ld	tp,32(sp)
ffffffffc0200eba:	72a2                	ld	t0,40(sp)
ffffffffc0200ebc:	7342                	ld	t1,48(sp)
ffffffffc0200ebe:	73e2                	ld	t2,56(sp)
ffffffffc0200ec0:	6406                	ld	s0,64(sp)
ffffffffc0200ec2:	64a6                	ld	s1,72(sp)
ffffffffc0200ec4:	6546                	ld	a0,80(sp)
ffffffffc0200ec6:	65e6                	ld	a1,88(sp)
ffffffffc0200ec8:	7606                	ld	a2,96(sp)
ffffffffc0200eca:	76a6                	ld	a3,104(sp)
ffffffffc0200ecc:	7746                	ld	a4,112(sp)
ffffffffc0200ece:	77e6                	ld	a5,120(sp)
ffffffffc0200ed0:	680a                	ld	a6,128(sp)
ffffffffc0200ed2:	68aa                	ld	a7,136(sp)
ffffffffc0200ed4:	694a                	ld	s2,144(sp)
ffffffffc0200ed6:	69ea                	ld	s3,152(sp)
ffffffffc0200ed8:	7a0a                	ld	s4,160(sp)
ffffffffc0200eda:	7aaa                	ld	s5,168(sp)
ffffffffc0200edc:	7b4a                	ld	s6,176(sp)
ffffffffc0200ede:	7bea                	ld	s7,184(sp)
ffffffffc0200ee0:	6c0e                	ld	s8,192(sp)
ffffffffc0200ee2:	6cae                	ld	s9,200(sp)
ffffffffc0200ee4:	6d4e                	ld	s10,208(sp)
ffffffffc0200ee6:	6dee                	ld	s11,216(sp)
ffffffffc0200ee8:	7e0e                	ld	t3,224(sp)
ffffffffc0200eea:	7eae                	ld	t4,232(sp)
ffffffffc0200eec:	7f4e                	ld	t5,240(sp)
ffffffffc0200eee:	7fee                	ld	t6,248(sp)
ffffffffc0200ef0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ef2:	10200073          	sret

ffffffffc0200ef6 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200ef6:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200ef8:	b755                	j	ffffffffc0200e9c <__trapret>

ffffffffc0200efa <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200efa:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6718>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200efe:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f02:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f06:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f0a:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f0e:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f12:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f16:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f1a:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f1e:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f20:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f22:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f24:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f26:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f28:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f2a:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f2c:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f2e:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f30:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f32:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f34:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f36:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f38:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f3a:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f3c:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f3e:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f40:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f42:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f44:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f46:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f48:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f4a:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f4c:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f4e:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f50:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f52:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f54:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f56:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f58:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f5a:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f5c:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f5e:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f60:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f62:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f64:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f66:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f68:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f6a:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200f6c:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200f6e:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200f70:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200f72:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200f74:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200f76:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200f78:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200f7a:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200f7c:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200f7e:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200f80:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200f82:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200f84:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200f86:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200f88:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200f8a:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200f8c:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200f8e:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200f90:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200f92:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200f94:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200f96:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200f98:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200f9a:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200f9c:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200f9e:	812e                	mv	sp,a1
ffffffffc0200fa0:	bdf5                	j	ffffffffc0200e9c <__trapret>

ffffffffc0200fa2 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fa2:	00091797          	auipc	a5,0x91
ffffffffc0200fa6:	b1e78793          	addi	a5,a5,-1250 # ffffffffc0291ac0 <free_area>
ffffffffc0200faa:	e79c                	sd	a5,8(a5)
ffffffffc0200fac:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fae:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fb2:	8082                	ret

ffffffffc0200fb4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fb4:	00091517          	auipc	a0,0x91
ffffffffc0200fb8:	b1c56503          	lwu	a0,-1252(a0) # ffffffffc0291ad0 <free_area+0x10>
ffffffffc0200fbc:	8082                	ret

ffffffffc0200fbe <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200fbe:	715d                	addi	sp,sp,-80
ffffffffc0200fc0:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200fc2:	00091417          	auipc	s0,0x91
ffffffffc0200fc6:	afe40413          	addi	s0,s0,-1282 # ffffffffc0291ac0 <free_area>
ffffffffc0200fca:	641c                	ld	a5,8(s0)
ffffffffc0200fcc:	e486                	sd	ra,72(sp)
ffffffffc0200fce:	fc26                	sd	s1,56(sp)
ffffffffc0200fd0:	f84a                	sd	s2,48(sp)
ffffffffc0200fd2:	f44e                	sd	s3,40(sp)
ffffffffc0200fd4:	f052                	sd	s4,32(sp)
ffffffffc0200fd6:	ec56                	sd	s5,24(sp)
ffffffffc0200fd8:	e85a                	sd	s6,16(sp)
ffffffffc0200fda:	e45e                	sd	s7,8(sp)
ffffffffc0200fdc:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200fde:	2a878963          	beq	a5,s0,ffffffffc0201290 <default_check+0x2d2>
    int count = 0, total = 0;
ffffffffc0200fe2:	4481                	li	s1,0
ffffffffc0200fe4:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200fe6:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200fea:	8b09                	andi	a4,a4,2
ffffffffc0200fec:	2a070663          	beqz	a4,ffffffffc0201298 <default_check+0x2da>
        count++, total += p->property;
ffffffffc0200ff0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ff4:	679c                	ld	a5,8(a5)
ffffffffc0200ff6:	2905                	addiw	s2,s2,1
ffffffffc0200ff8:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ffa:	fe8796e3          	bne	a5,s0,ffffffffc0200fe6 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200ffe:	89a6                	mv	s3,s1
ffffffffc0201000:	6bb000ef          	jal	ffffffffc0201eba <nr_free_pages>
ffffffffc0201004:	6f351a63          	bne	a0,s3,ffffffffc02016f8 <default_check+0x73a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201008:	4505                	li	a0,1
ffffffffc020100a:	633000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020100e:	8aaa                	mv	s5,a0
ffffffffc0201010:	42050463          	beqz	a0,ffffffffc0201438 <default_check+0x47a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201014:	4505                	li	a0,1
ffffffffc0201016:	627000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020101a:	89aa                	mv	s3,a0
ffffffffc020101c:	6e050e63          	beqz	a0,ffffffffc0201718 <default_check+0x75a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201020:	4505                	li	a0,1
ffffffffc0201022:	61b000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201026:	8a2a                	mv	s4,a0
ffffffffc0201028:	48050863          	beqz	a0,ffffffffc02014b8 <default_check+0x4fa>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020102c:	293a8663          	beq	s5,s3,ffffffffc02012b8 <default_check+0x2fa>
ffffffffc0201030:	28aa8463          	beq	s5,a0,ffffffffc02012b8 <default_check+0x2fa>
ffffffffc0201034:	28a98263          	beq	s3,a0,ffffffffc02012b8 <default_check+0x2fa>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201038:	000aa783          	lw	a5,0(s5)
ffffffffc020103c:	28079e63          	bnez	a5,ffffffffc02012d8 <default_check+0x31a>
ffffffffc0201040:	0009a783          	lw	a5,0(s3)
ffffffffc0201044:	28079a63          	bnez	a5,ffffffffc02012d8 <default_check+0x31a>
ffffffffc0201048:	411c                	lw	a5,0(a0)
ffffffffc020104a:	28079763          	bnez	a5,ffffffffc02012d8 <default_check+0x31a>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc020104e:	00095797          	auipc	a5,0x95
ffffffffc0201052:	afa7b783          	ld	a5,-1286(a5) # ffffffffc0295b48 <pages>
ffffffffc0201056:	40fa8733          	sub	a4,s5,a5
ffffffffc020105a:	00006617          	auipc	a2,0x6
ffffffffc020105e:	7ae63603          	ld	a2,1966(a2) # ffffffffc0207808 <nbase>
ffffffffc0201062:	8719                	srai	a4,a4,0x6
ffffffffc0201064:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201066:	00095697          	auipc	a3,0x95
ffffffffc020106a:	ada6b683          	ld	a3,-1318(a3) # ffffffffc0295b40 <npage>
ffffffffc020106e:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201070:	0732                	slli	a4,a4,0xc
ffffffffc0201072:	28d77363          	bgeu	a4,a3,ffffffffc02012f8 <default_check+0x33a>
    return page - pages + nbase;
ffffffffc0201076:	40f98733          	sub	a4,s3,a5
ffffffffc020107a:	8719                	srai	a4,a4,0x6
ffffffffc020107c:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020107e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201080:	4ad77c63          	bgeu	a4,a3,ffffffffc0201538 <default_check+0x57a>
    return page - pages + nbase;
ffffffffc0201084:	40f507b3          	sub	a5,a0,a5
ffffffffc0201088:	8799                	srai	a5,a5,0x6
ffffffffc020108a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020108c:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020108e:	30d7f563          	bgeu	a5,a3,ffffffffc0201398 <default_check+0x3da>
    assert(alloc_page() == NULL);
ffffffffc0201092:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201094:	00043c03          	ld	s8,0(s0)
ffffffffc0201098:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc020109c:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010a0:	e400                	sd	s0,8(s0)
ffffffffc02010a2:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010a4:	00091797          	auipc	a5,0x91
ffffffffc02010a8:	a207a623          	sw	zero,-1492(a5) # ffffffffc0291ad0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010ac:	591000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02010b0:	2c051463          	bnez	a0,ffffffffc0201378 <default_check+0x3ba>
    free_page(p0);
ffffffffc02010b4:	4585                	li	a1,1
ffffffffc02010b6:	8556                	mv	a0,s5
ffffffffc02010b8:	5c3000ef          	jal	ffffffffc0201e7a <free_pages>
    free_page(p1);
ffffffffc02010bc:	4585                	li	a1,1
ffffffffc02010be:	854e                	mv	a0,s3
ffffffffc02010c0:	5bb000ef          	jal	ffffffffc0201e7a <free_pages>
    free_page(p2);
ffffffffc02010c4:	4585                	li	a1,1
ffffffffc02010c6:	8552                	mv	a0,s4
ffffffffc02010c8:	5b3000ef          	jal	ffffffffc0201e7a <free_pages>
    assert(nr_free == 3);
ffffffffc02010cc:	4818                	lw	a4,16(s0)
ffffffffc02010ce:	478d                	li	a5,3
ffffffffc02010d0:	28f71463          	bne	a4,a5,ffffffffc0201358 <default_check+0x39a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010d4:	4505                	li	a0,1
ffffffffc02010d6:	567000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02010da:	89aa                	mv	s3,a0
ffffffffc02010dc:	24050e63          	beqz	a0,ffffffffc0201338 <default_check+0x37a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010e0:	4505                	li	a0,1
ffffffffc02010e2:	55b000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02010e6:	8aaa                	mv	s5,a0
ffffffffc02010e8:	3a050863          	beqz	a0,ffffffffc0201498 <default_check+0x4da>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010ec:	4505                	li	a0,1
ffffffffc02010ee:	54f000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02010f2:	8a2a                	mv	s4,a0
ffffffffc02010f4:	38050263          	beqz	a0,ffffffffc0201478 <default_check+0x4ba>
    assert(alloc_page() == NULL);
ffffffffc02010f8:	4505                	li	a0,1
ffffffffc02010fa:	543000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02010fe:	34051d63          	bnez	a0,ffffffffc0201458 <default_check+0x49a>
    free_page(p0);
ffffffffc0201102:	4585                	li	a1,1
ffffffffc0201104:	854e                	mv	a0,s3
ffffffffc0201106:	575000ef          	jal	ffffffffc0201e7a <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020110a:	641c                	ld	a5,8(s0)
ffffffffc020110c:	20878663          	beq	a5,s0,ffffffffc0201318 <default_check+0x35a>
    assert((p = alloc_page()) == p0);
ffffffffc0201110:	4505                	li	a0,1
ffffffffc0201112:	52b000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201116:	30a99163          	bne	s3,a0,ffffffffc0201418 <default_check+0x45a>
    assert(alloc_page() == NULL);
ffffffffc020111a:	4505                	li	a0,1
ffffffffc020111c:	521000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201120:	2c051c63          	bnez	a0,ffffffffc02013f8 <default_check+0x43a>
    assert(nr_free == 0);
ffffffffc0201124:	481c                	lw	a5,16(s0)
ffffffffc0201126:	2a079963          	bnez	a5,ffffffffc02013d8 <default_check+0x41a>
    free_page(p);
ffffffffc020112a:	854e                	mv	a0,s3
ffffffffc020112c:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020112e:	01843023          	sd	s8,0(s0)
ffffffffc0201132:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201136:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020113a:	541000ef          	jal	ffffffffc0201e7a <free_pages>
    free_page(p1);
ffffffffc020113e:	4585                	li	a1,1
ffffffffc0201140:	8556                	mv	a0,s5
ffffffffc0201142:	539000ef          	jal	ffffffffc0201e7a <free_pages>
    free_page(p2);
ffffffffc0201146:	4585                	li	a1,1
ffffffffc0201148:	8552                	mv	a0,s4
ffffffffc020114a:	531000ef          	jal	ffffffffc0201e7a <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020114e:	4515                	li	a0,5
ffffffffc0201150:	4ed000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201154:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201156:	26050163          	beqz	a0,ffffffffc02013b8 <default_check+0x3fa>
ffffffffc020115a:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc020115c:	8b89                	andi	a5,a5,2
ffffffffc020115e:	52079d63          	bnez	a5,ffffffffc0201698 <default_check+0x6da>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201162:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201164:	00043b83          	ld	s7,0(s0)
ffffffffc0201168:	00843b03          	ld	s6,8(s0)
ffffffffc020116c:	e000                	sd	s0,0(s0)
ffffffffc020116e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201170:	4cd000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201174:	50051263          	bnez	a0,ffffffffc0201678 <default_check+0x6ba>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201178:	08098a13          	addi	s4,s3,128
ffffffffc020117c:	8552                	mv	a0,s4
ffffffffc020117e:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201180:	01042c03          	lw	s8,16(s0)
    nr_free = 0;
ffffffffc0201184:	00091797          	auipc	a5,0x91
ffffffffc0201188:	9407a623          	sw	zero,-1716(a5) # ffffffffc0291ad0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020118c:	4ef000ef          	jal	ffffffffc0201e7a <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201190:	4511                	li	a0,4
ffffffffc0201192:	4ab000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201196:	4c051163          	bnez	a0,ffffffffc0201658 <default_check+0x69a>
ffffffffc020119a:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020119e:	8b89                	andi	a5,a5,2
ffffffffc02011a0:	48078c63          	beqz	a5,ffffffffc0201638 <default_check+0x67a>
ffffffffc02011a4:	0909a703          	lw	a4,144(s3)
ffffffffc02011a8:	478d                	li	a5,3
ffffffffc02011aa:	48f71763          	bne	a4,a5,ffffffffc0201638 <default_check+0x67a>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011ae:	450d                	li	a0,3
ffffffffc02011b0:	48d000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02011b4:	8aaa                	mv	s5,a0
ffffffffc02011b6:	46050163          	beqz	a0,ffffffffc0201618 <default_check+0x65a>
    assert(alloc_page() == NULL);
ffffffffc02011ba:	4505                	li	a0,1
ffffffffc02011bc:	481000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc02011c0:	42051c63          	bnez	a0,ffffffffc02015f8 <default_check+0x63a>
    assert(p0 + 2 == p1);
ffffffffc02011c4:	415a1a63          	bne	s4,s5,ffffffffc02015d8 <default_check+0x61a>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02011c8:	4585                	li	a1,1
ffffffffc02011ca:	854e                	mv	a0,s3
ffffffffc02011cc:	4af000ef          	jal	ffffffffc0201e7a <free_pages>
    free_pages(p1, 3);
ffffffffc02011d0:	458d                	li	a1,3
ffffffffc02011d2:	8552                	mv	a0,s4
ffffffffc02011d4:	4a7000ef          	jal	ffffffffc0201e7a <free_pages>
ffffffffc02011d8:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02011dc:	04098a93          	addi	s5,s3,64
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02011e0:	8b89                	andi	a5,a5,2
ffffffffc02011e2:	3c078b63          	beqz	a5,ffffffffc02015b8 <default_check+0x5fa>
ffffffffc02011e6:	0109a703          	lw	a4,16(s3)
ffffffffc02011ea:	4785                	li	a5,1
ffffffffc02011ec:	3cf71663          	bne	a4,a5,ffffffffc02015b8 <default_check+0x5fa>
ffffffffc02011f0:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02011f4:	8b89                	andi	a5,a5,2
ffffffffc02011f6:	3a078163          	beqz	a5,ffffffffc0201598 <default_check+0x5da>
ffffffffc02011fa:	010a2703          	lw	a4,16(s4)
ffffffffc02011fe:	478d                	li	a5,3
ffffffffc0201200:	38f71c63          	bne	a4,a5,ffffffffc0201598 <default_check+0x5da>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201204:	4505                	li	a0,1
ffffffffc0201206:	437000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020120a:	36a99763          	bne	s3,a0,ffffffffc0201578 <default_check+0x5ba>
    free_page(p0);
ffffffffc020120e:	4585                	li	a1,1
ffffffffc0201210:	46b000ef          	jal	ffffffffc0201e7a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201214:	4509                	li	a0,2
ffffffffc0201216:	427000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020121a:	32aa1f63          	bne	s4,a0,ffffffffc0201558 <default_check+0x59a>

    free_pages(p0, 2);
ffffffffc020121e:	4589                	li	a1,2
ffffffffc0201220:	45b000ef          	jal	ffffffffc0201e7a <free_pages>
    free_page(p2);
ffffffffc0201224:	4585                	li	a1,1
ffffffffc0201226:	8556                	mv	a0,s5
ffffffffc0201228:	453000ef          	jal	ffffffffc0201e7a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020122c:	4515                	li	a0,5
ffffffffc020122e:	40f000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc0201232:	89aa                	mv	s3,a0
ffffffffc0201234:	48050263          	beqz	a0,ffffffffc02016b8 <default_check+0x6fa>
    assert(alloc_page() == NULL);
ffffffffc0201238:	4505                	li	a0,1
ffffffffc020123a:	403000ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020123e:	2c051d63          	bnez	a0,ffffffffc0201518 <default_check+0x55a>

    assert(nr_free == 0);
ffffffffc0201242:	481c                	lw	a5,16(s0)
ffffffffc0201244:	2a079a63          	bnez	a5,ffffffffc02014f8 <default_check+0x53a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201248:	4595                	li	a1,5
ffffffffc020124a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020124c:	01842823          	sw	s8,16(s0)
    free_list = free_list_store;
ffffffffc0201250:	01743023          	sd	s7,0(s0)
ffffffffc0201254:	01643423          	sd	s6,8(s0)
    free_pages(p0, 5);
ffffffffc0201258:	423000ef          	jal	ffffffffc0201e7a <free_pages>
    return listelm->next;
ffffffffc020125c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020125e:	00878963          	beq	a5,s0,ffffffffc0201270 <default_check+0x2b2>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201262:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201266:	679c                	ld	a5,8(a5)
ffffffffc0201268:	397d                	addiw	s2,s2,-1
ffffffffc020126a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020126c:	fe879be3          	bne	a5,s0,ffffffffc0201262 <default_check+0x2a4>
    }
    assert(count == 0);
ffffffffc0201270:	26091463          	bnez	s2,ffffffffc02014d8 <default_check+0x51a>
    assert(total == 0);
ffffffffc0201274:	46049263          	bnez	s1,ffffffffc02016d8 <default_check+0x71a>
}
ffffffffc0201278:	60a6                	ld	ra,72(sp)
ffffffffc020127a:	6406                	ld	s0,64(sp)
ffffffffc020127c:	74e2                	ld	s1,56(sp)
ffffffffc020127e:	7942                	ld	s2,48(sp)
ffffffffc0201280:	79a2                	ld	s3,40(sp)
ffffffffc0201282:	7a02                	ld	s4,32(sp)
ffffffffc0201284:	6ae2                	ld	s5,24(sp)
ffffffffc0201286:	6b42                	ld	s6,16(sp)
ffffffffc0201288:	6ba2                	ld	s7,8(sp)
ffffffffc020128a:	6c02                	ld	s8,0(sp)
ffffffffc020128c:	6161                	addi	sp,sp,80
ffffffffc020128e:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201290:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201292:	4481                	li	s1,0
ffffffffc0201294:	4901                	li	s2,0
ffffffffc0201296:	b3ad                	j	ffffffffc0201000 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201298:	00005697          	auipc	a3,0x5
ffffffffc020129c:	de868693          	addi	a3,a3,-536 # ffffffffc0206080 <etext+0x9d0>
ffffffffc02012a0:	00005617          	auipc	a2,0x5
ffffffffc02012a4:	df060613          	addi	a2,a2,-528 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02012a8:	11000593          	li	a1,272
ffffffffc02012ac:	00005517          	auipc	a0,0x5
ffffffffc02012b0:	dfc50513          	addi	a0,a0,-516 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02012b4:	9d4ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02012b8:	00005697          	auipc	a3,0x5
ffffffffc02012bc:	e8868693          	addi	a3,a3,-376 # ffffffffc0206140 <etext+0xa90>
ffffffffc02012c0:	00005617          	auipc	a2,0x5
ffffffffc02012c4:	dd060613          	addi	a2,a2,-560 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02012c8:	0db00593          	li	a1,219
ffffffffc02012cc:	00005517          	auipc	a0,0x5
ffffffffc02012d0:	ddc50513          	addi	a0,a0,-548 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02012d4:	9b4ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02012d8:	00005697          	auipc	a3,0x5
ffffffffc02012dc:	e9068693          	addi	a3,a3,-368 # ffffffffc0206168 <etext+0xab8>
ffffffffc02012e0:	00005617          	auipc	a2,0x5
ffffffffc02012e4:	db060613          	addi	a2,a2,-592 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02012e8:	0dc00593          	li	a1,220
ffffffffc02012ec:	00005517          	auipc	a0,0x5
ffffffffc02012f0:	dbc50513          	addi	a0,a0,-580 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02012f4:	994ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02012f8:	00005697          	auipc	a3,0x5
ffffffffc02012fc:	eb068693          	addi	a3,a3,-336 # ffffffffc02061a8 <etext+0xaf8>
ffffffffc0201300:	00005617          	auipc	a2,0x5
ffffffffc0201304:	d9060613          	addi	a2,a2,-624 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201308:	0de00593          	li	a1,222
ffffffffc020130c:	00005517          	auipc	a0,0x5
ffffffffc0201310:	d9c50513          	addi	a0,a0,-612 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201314:	974ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201318:	00005697          	auipc	a3,0x5
ffffffffc020131c:	f1868693          	addi	a3,a3,-232 # ffffffffc0206230 <etext+0xb80>
ffffffffc0201320:	00005617          	auipc	a2,0x5
ffffffffc0201324:	d7060613          	addi	a2,a2,-656 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201328:	0f700593          	li	a1,247
ffffffffc020132c:	00005517          	auipc	a0,0x5
ffffffffc0201330:	d7c50513          	addi	a0,a0,-644 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201334:	954ff0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201338:	00005697          	auipc	a3,0x5
ffffffffc020133c:	da868693          	addi	a3,a3,-600 # ffffffffc02060e0 <etext+0xa30>
ffffffffc0201340:	00005617          	auipc	a2,0x5
ffffffffc0201344:	d5060613          	addi	a2,a2,-688 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201348:	0f000593          	li	a1,240
ffffffffc020134c:	00005517          	auipc	a0,0x5
ffffffffc0201350:	d5c50513          	addi	a0,a0,-676 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201354:	934ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 3);
ffffffffc0201358:	00005697          	auipc	a3,0x5
ffffffffc020135c:	ec868693          	addi	a3,a3,-312 # ffffffffc0206220 <etext+0xb70>
ffffffffc0201360:	00005617          	auipc	a2,0x5
ffffffffc0201364:	d3060613          	addi	a2,a2,-720 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201368:	0ee00593          	li	a1,238
ffffffffc020136c:	00005517          	auipc	a0,0x5
ffffffffc0201370:	d3c50513          	addi	a0,a0,-708 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201374:	914ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201378:	00005697          	auipc	a3,0x5
ffffffffc020137c:	e9068693          	addi	a3,a3,-368 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201380:	00005617          	auipc	a2,0x5
ffffffffc0201384:	d1060613          	addi	a2,a2,-752 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201388:	0e900593          	li	a1,233
ffffffffc020138c:	00005517          	auipc	a0,0x5
ffffffffc0201390:	d1c50513          	addi	a0,a0,-740 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201394:	8f4ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201398:	00005697          	auipc	a3,0x5
ffffffffc020139c:	e5068693          	addi	a3,a3,-432 # ffffffffc02061e8 <etext+0xb38>
ffffffffc02013a0:	00005617          	auipc	a2,0x5
ffffffffc02013a4:	cf060613          	addi	a2,a2,-784 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02013a8:	0e000593          	li	a1,224
ffffffffc02013ac:	00005517          	auipc	a0,0x5
ffffffffc02013b0:	cfc50513          	addi	a0,a0,-772 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02013b4:	8d4ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 != NULL);
ffffffffc02013b8:	00005697          	auipc	a3,0x5
ffffffffc02013bc:	ec068693          	addi	a3,a3,-320 # ffffffffc0206278 <etext+0xbc8>
ffffffffc02013c0:	00005617          	auipc	a2,0x5
ffffffffc02013c4:	cd060613          	addi	a2,a2,-816 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02013c8:	11800593          	li	a1,280
ffffffffc02013cc:	00005517          	auipc	a0,0x5
ffffffffc02013d0:	cdc50513          	addi	a0,a0,-804 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02013d4:	8b4ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 0);
ffffffffc02013d8:	00005697          	auipc	a3,0x5
ffffffffc02013dc:	e9068693          	addi	a3,a3,-368 # ffffffffc0206268 <etext+0xbb8>
ffffffffc02013e0:	00005617          	auipc	a2,0x5
ffffffffc02013e4:	cb060613          	addi	a2,a2,-848 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02013e8:	0fd00593          	li	a1,253
ffffffffc02013ec:	00005517          	auipc	a0,0x5
ffffffffc02013f0:	cbc50513          	addi	a0,a0,-836 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02013f4:	894ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013f8:	00005697          	auipc	a3,0x5
ffffffffc02013fc:	e1068693          	addi	a3,a3,-496 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201400:	00005617          	auipc	a2,0x5
ffffffffc0201404:	c9060613          	addi	a2,a2,-880 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201408:	0fb00593          	li	a1,251
ffffffffc020140c:	00005517          	auipc	a0,0x5
ffffffffc0201410:	c9c50513          	addi	a0,a0,-868 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201414:	874ff0ef          	jal	ffffffffc0200488 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201418:	00005697          	auipc	a3,0x5
ffffffffc020141c:	e3068693          	addi	a3,a3,-464 # ffffffffc0206248 <etext+0xb98>
ffffffffc0201420:	00005617          	auipc	a2,0x5
ffffffffc0201424:	c7060613          	addi	a2,a2,-912 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201428:	0fa00593          	li	a1,250
ffffffffc020142c:	00005517          	auipc	a0,0x5
ffffffffc0201430:	c7c50513          	addi	a0,a0,-900 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201434:	854ff0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201438:	00005697          	auipc	a3,0x5
ffffffffc020143c:	ca868693          	addi	a3,a3,-856 # ffffffffc02060e0 <etext+0xa30>
ffffffffc0201440:	00005617          	auipc	a2,0x5
ffffffffc0201444:	c5060613          	addi	a2,a2,-944 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201448:	0d700593          	li	a1,215
ffffffffc020144c:	00005517          	auipc	a0,0x5
ffffffffc0201450:	c5c50513          	addi	a0,a0,-932 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201454:	834ff0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201458:	00005697          	auipc	a3,0x5
ffffffffc020145c:	db068693          	addi	a3,a3,-592 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201460:	00005617          	auipc	a2,0x5
ffffffffc0201464:	c3060613          	addi	a2,a2,-976 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201468:	0f400593          	li	a1,244
ffffffffc020146c:	00005517          	auipc	a0,0x5
ffffffffc0201470:	c3c50513          	addi	a0,a0,-964 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201474:	814ff0ef          	jal	ffffffffc0200488 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201478:	00005697          	auipc	a3,0x5
ffffffffc020147c:	ca868693          	addi	a3,a3,-856 # ffffffffc0206120 <etext+0xa70>
ffffffffc0201480:	00005617          	auipc	a2,0x5
ffffffffc0201484:	c1060613          	addi	a2,a2,-1008 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201488:	0f200593          	li	a1,242
ffffffffc020148c:	00005517          	auipc	a0,0x5
ffffffffc0201490:	c1c50513          	addi	a0,a0,-996 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201494:	ff5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201498:	00005697          	auipc	a3,0x5
ffffffffc020149c:	c6868693          	addi	a3,a3,-920 # ffffffffc0206100 <etext+0xa50>
ffffffffc02014a0:	00005617          	auipc	a2,0x5
ffffffffc02014a4:	bf060613          	addi	a2,a2,-1040 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02014a8:	0f100593          	li	a1,241
ffffffffc02014ac:	00005517          	auipc	a0,0x5
ffffffffc02014b0:	bfc50513          	addi	a0,a0,-1028 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02014b4:	fd5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014b8:	00005697          	auipc	a3,0x5
ffffffffc02014bc:	c6868693          	addi	a3,a3,-920 # ffffffffc0206120 <etext+0xa70>
ffffffffc02014c0:	00005617          	auipc	a2,0x5
ffffffffc02014c4:	bd060613          	addi	a2,a2,-1072 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02014c8:	0d900593          	li	a1,217
ffffffffc02014cc:	00005517          	auipc	a0,0x5
ffffffffc02014d0:	bdc50513          	addi	a0,a0,-1060 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02014d4:	fb5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(count == 0);
ffffffffc02014d8:	00005697          	auipc	a3,0x5
ffffffffc02014dc:	ef068693          	addi	a3,a3,-272 # ffffffffc02063c8 <etext+0xd18>
ffffffffc02014e0:	00005617          	auipc	a2,0x5
ffffffffc02014e4:	bb060613          	addi	a2,a2,-1104 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02014e8:	14600593          	li	a1,326
ffffffffc02014ec:	00005517          	auipc	a0,0x5
ffffffffc02014f0:	bbc50513          	addi	a0,a0,-1092 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02014f4:	f95fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free == 0);
ffffffffc02014f8:	00005697          	auipc	a3,0x5
ffffffffc02014fc:	d7068693          	addi	a3,a3,-656 # ffffffffc0206268 <etext+0xbb8>
ffffffffc0201500:	00005617          	auipc	a2,0x5
ffffffffc0201504:	b9060613          	addi	a2,a2,-1136 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201508:	13a00593          	li	a1,314
ffffffffc020150c:	00005517          	auipc	a0,0x5
ffffffffc0201510:	b9c50513          	addi	a0,a0,-1124 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201514:	f75fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201518:	00005697          	auipc	a3,0x5
ffffffffc020151c:	cf068693          	addi	a3,a3,-784 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201520:	00005617          	auipc	a2,0x5
ffffffffc0201524:	b7060613          	addi	a2,a2,-1168 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201528:	13800593          	li	a1,312
ffffffffc020152c:	00005517          	auipc	a0,0x5
ffffffffc0201530:	b7c50513          	addi	a0,a0,-1156 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201534:	f55fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201538:	00005697          	auipc	a3,0x5
ffffffffc020153c:	c9068693          	addi	a3,a3,-880 # ffffffffc02061c8 <etext+0xb18>
ffffffffc0201540:	00005617          	auipc	a2,0x5
ffffffffc0201544:	b5060613          	addi	a2,a2,-1200 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201548:	0df00593          	li	a1,223
ffffffffc020154c:	00005517          	auipc	a0,0x5
ffffffffc0201550:	b5c50513          	addi	a0,a0,-1188 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201554:	f35fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201558:	00005697          	auipc	a3,0x5
ffffffffc020155c:	e3068693          	addi	a3,a3,-464 # ffffffffc0206388 <etext+0xcd8>
ffffffffc0201560:	00005617          	auipc	a2,0x5
ffffffffc0201564:	b3060613          	addi	a2,a2,-1232 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201568:	13200593          	li	a1,306
ffffffffc020156c:	00005517          	auipc	a0,0x5
ffffffffc0201570:	b3c50513          	addi	a0,a0,-1220 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201574:	f15fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201578:	00005697          	auipc	a3,0x5
ffffffffc020157c:	df068693          	addi	a3,a3,-528 # ffffffffc0206368 <etext+0xcb8>
ffffffffc0201580:	00005617          	auipc	a2,0x5
ffffffffc0201584:	b1060613          	addi	a2,a2,-1264 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201588:	13000593          	li	a1,304
ffffffffc020158c:	00005517          	auipc	a0,0x5
ffffffffc0201590:	b1c50513          	addi	a0,a0,-1252 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201594:	ef5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201598:	00005697          	auipc	a3,0x5
ffffffffc020159c:	da868693          	addi	a3,a3,-600 # ffffffffc0206340 <etext+0xc90>
ffffffffc02015a0:	00005617          	auipc	a2,0x5
ffffffffc02015a4:	af060613          	addi	a2,a2,-1296 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02015a8:	12e00593          	li	a1,302
ffffffffc02015ac:	00005517          	auipc	a0,0x5
ffffffffc02015b0:	afc50513          	addi	a0,a0,-1284 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02015b4:	ed5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015b8:	00005697          	auipc	a3,0x5
ffffffffc02015bc:	d6068693          	addi	a3,a3,-672 # ffffffffc0206318 <etext+0xc68>
ffffffffc02015c0:	00005617          	auipc	a2,0x5
ffffffffc02015c4:	ad060613          	addi	a2,a2,-1328 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02015c8:	12d00593          	li	a1,301
ffffffffc02015cc:	00005517          	auipc	a0,0x5
ffffffffc02015d0:	adc50513          	addi	a0,a0,-1316 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02015d4:	eb5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02015d8:	00005697          	auipc	a3,0x5
ffffffffc02015dc:	d3068693          	addi	a3,a3,-720 # ffffffffc0206308 <etext+0xc58>
ffffffffc02015e0:	00005617          	auipc	a2,0x5
ffffffffc02015e4:	ab060613          	addi	a2,a2,-1360 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02015e8:	12800593          	li	a1,296
ffffffffc02015ec:	00005517          	auipc	a0,0x5
ffffffffc02015f0:	abc50513          	addi	a0,a0,-1348 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02015f4:	e95fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015f8:	00005697          	auipc	a3,0x5
ffffffffc02015fc:	c1068693          	addi	a3,a3,-1008 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201600:	00005617          	auipc	a2,0x5
ffffffffc0201604:	a9060613          	addi	a2,a2,-1392 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201608:	12700593          	li	a1,295
ffffffffc020160c:	00005517          	auipc	a0,0x5
ffffffffc0201610:	a9c50513          	addi	a0,a0,-1380 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201614:	e75fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	cd068693          	addi	a3,a3,-816 # ffffffffc02062e8 <etext+0xc38>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	a7060613          	addi	a2,a2,-1424 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201628:	12600593          	li	a1,294
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	a7c50513          	addi	a0,a0,-1412 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201634:	e55fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	c8068693          	addi	a3,a3,-896 # ffffffffc02062b8 <etext+0xc08>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	a5060613          	addi	a2,a2,-1456 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201648:	12500593          	li	a1,293
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	a5c50513          	addi	a0,a0,-1444 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201654:	e35fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	c4868693          	addi	a3,a3,-952 # ffffffffc02062a0 <etext+0xbf0>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	a3060613          	addi	a2,a2,-1488 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201668:	12400593          	li	a1,292
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	a3c50513          	addi	a0,a0,-1476 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201674:	e15fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	b9068693          	addi	a3,a3,-1136 # ffffffffc0206208 <etext+0xb58>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	a1060613          	addi	a2,a2,-1520 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201688:	11e00593          	li	a1,286
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	a1c50513          	addi	a0,a0,-1508 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201694:	df5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201698:	00005697          	auipc	a3,0x5
ffffffffc020169c:	bf068693          	addi	a3,a3,-1040 # ffffffffc0206288 <etext+0xbd8>
ffffffffc02016a0:	00005617          	auipc	a2,0x5
ffffffffc02016a4:	9f060613          	addi	a2,a2,-1552 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02016a8:	11900593          	li	a1,281
ffffffffc02016ac:	00005517          	auipc	a0,0x5
ffffffffc02016b0:	9fc50513          	addi	a0,a0,-1540 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02016b4:	dd5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016b8:	00005697          	auipc	a3,0x5
ffffffffc02016bc:	cf068693          	addi	a3,a3,-784 # ffffffffc02063a8 <etext+0xcf8>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	9d060613          	addi	a2,a2,-1584 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02016c8:	13700593          	li	a1,311
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02016d4:	db5fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(total == 0);
ffffffffc02016d8:	00005697          	auipc	a3,0x5
ffffffffc02016dc:	d0068693          	addi	a3,a3,-768 # ffffffffc02063d8 <etext+0xd28>
ffffffffc02016e0:	00005617          	auipc	a2,0x5
ffffffffc02016e4:	9b060613          	addi	a2,a2,-1616 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02016e8:	14700593          	li	a1,327
ffffffffc02016ec:	00005517          	auipc	a0,0x5
ffffffffc02016f0:	9bc50513          	addi	a0,a0,-1604 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02016f4:	d95fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(total == nr_free_pages());
ffffffffc02016f8:	00005697          	auipc	a3,0x5
ffffffffc02016fc:	9c868693          	addi	a3,a3,-1592 # ffffffffc02060c0 <etext+0xa10>
ffffffffc0201700:	00005617          	auipc	a2,0x5
ffffffffc0201704:	99060613          	addi	a2,a2,-1648 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201708:	11300593          	li	a1,275
ffffffffc020170c:	00005517          	auipc	a0,0x5
ffffffffc0201710:	99c50513          	addi	a0,a0,-1636 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201714:	d75fe0ef          	jal	ffffffffc0200488 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201718:	00005697          	auipc	a3,0x5
ffffffffc020171c:	9e868693          	addi	a3,a3,-1560 # ffffffffc0206100 <etext+0xa50>
ffffffffc0201720:	00005617          	auipc	a2,0x5
ffffffffc0201724:	97060613          	addi	a2,a2,-1680 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201728:	0d800593          	li	a1,216
ffffffffc020172c:	00005517          	auipc	a0,0x5
ffffffffc0201730:	97c50513          	addi	a0,a0,-1668 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201734:	d55fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201738 <default_free_pages>:
{
ffffffffc0201738:	1141                	addi	sp,sp,-16
ffffffffc020173a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020173c:	14058463          	beqz	a1,ffffffffc0201884 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201740:	00659713          	slli	a4,a1,0x6
ffffffffc0201744:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201748:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc020174a:	c30d                	beqz	a4,ffffffffc020176c <default_free_pages+0x34>
ffffffffc020174c:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020174e:	8b05                	andi	a4,a4,1
ffffffffc0201750:	10071a63          	bnez	a4,ffffffffc0201864 <default_free_pages+0x12c>
ffffffffc0201754:	6798                	ld	a4,8(a5)
ffffffffc0201756:	8b09                	andi	a4,a4,2
ffffffffc0201758:	10071663          	bnez	a4,ffffffffc0201864 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020175c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201760:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201764:	04078793          	addi	a5,a5,64
ffffffffc0201768:	fed792e3          	bne	a5,a3,ffffffffc020174c <default_free_pages+0x14>
    base->property = n;
ffffffffc020176c:	2581                	sext.w	a1,a1
ffffffffc020176e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201770:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201774:	4789                	li	a5,2
ffffffffc0201776:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020177a:	00090697          	auipc	a3,0x90
ffffffffc020177e:	34668693          	addi	a3,a3,838 # ffffffffc0291ac0 <free_area>
ffffffffc0201782:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201784:	669c                	ld	a5,8(a3)
ffffffffc0201786:	9f2d                	addw	a4,a4,a1
ffffffffc0201788:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc020178a:	0ad78163          	beq	a5,a3,ffffffffc020182c <default_free_pages+0xf4>
            struct Page *page = le2page(le, page_link);
ffffffffc020178e:	fe878713          	addi	a4,a5,-24
ffffffffc0201792:	4581                	li	a1,0
ffffffffc0201794:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201798:	00e56a63          	bltu	a0,a4,ffffffffc02017ac <default_free_pages+0x74>
    return listelm->next;
ffffffffc020179c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020179e:	04d70c63          	beq	a4,a3,ffffffffc02017f6 <default_free_pages+0xbe>
    struct Page *p = base;
ffffffffc02017a2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017a4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017a8:	fee57ae3          	bgeu	a0,a4,ffffffffc020179c <default_free_pages+0x64>
ffffffffc02017ac:	c199                	beqz	a1,ffffffffc02017b2 <default_free_pages+0x7a>
ffffffffc02017ae:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017b2:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017b4:	e390                	sd	a2,0(a5)
ffffffffc02017b6:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02017b8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017ba:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02017bc:	00d70d63          	beq	a4,a3,ffffffffc02017d6 <default_free_pages+0x9e>
        if (p + p->property == base)
ffffffffc02017c0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02017c4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02017c8:	02059813          	slli	a6,a1,0x20
ffffffffc02017cc:	01a85793          	srli	a5,a6,0x1a
ffffffffc02017d0:	97b2                	add	a5,a5,a2
ffffffffc02017d2:	02f50c63          	beq	a0,a5,ffffffffc020180a <default_free_pages+0xd2>
    return listelm->next;
ffffffffc02017d6:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02017d8:	00d78c63          	beq	a5,a3,ffffffffc02017f0 <default_free_pages+0xb8>
        if (base + base->property == p)
ffffffffc02017dc:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02017de:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02017e2:	02061593          	slli	a1,a2,0x20
ffffffffc02017e6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02017ea:	972a                	add	a4,a4,a0
ffffffffc02017ec:	04e68c63          	beq	a3,a4,ffffffffc0201844 <default_free_pages+0x10c>
}
ffffffffc02017f0:	60a2                	ld	ra,8(sp)
ffffffffc02017f2:	0141                	addi	sp,sp,16
ffffffffc02017f4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02017f6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02017f8:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02017fa:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02017fc:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02017fe:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201800:	02d70f63          	beq	a4,a3,ffffffffc020183e <default_free_pages+0x106>
ffffffffc0201804:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201806:	87ba                	mv	a5,a4
ffffffffc0201808:	bf71                	j	ffffffffc02017a4 <default_free_pages+0x6c>
            p->property += base->property;
ffffffffc020180a:	491c                	lw	a5,16(a0)
ffffffffc020180c:	9fad                	addw	a5,a5,a1
ffffffffc020180e:	fef72c23          	sw	a5,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201812:	57f5                	li	a5,-3
ffffffffc0201814:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201818:	01853803          	ld	a6,24(a0)
ffffffffc020181c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020181e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201820:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201824:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201826:	0105b023          	sd	a6,0(a1)
ffffffffc020182a:	b77d                	j	ffffffffc02017d8 <default_free_pages+0xa0>
}
ffffffffc020182c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020182e:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201832:	e398                	sd	a4,0(a5)
ffffffffc0201834:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0201836:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201838:	ed1c                	sd	a5,24(a0)
}
ffffffffc020183a:	0141                	addi	sp,sp,16
ffffffffc020183c:	8082                	ret
ffffffffc020183e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201840:	873e                	mv	a4,a5
ffffffffc0201842:	bfad                	j	ffffffffc02017bc <default_free_pages+0x84>
            base->property += p->property;
ffffffffc0201844:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201848:	ff078693          	addi	a3,a5,-16
ffffffffc020184c:	9f31                	addw	a4,a4,a2
ffffffffc020184e:	c918                	sw	a4,16(a0)
ffffffffc0201850:	5775                	li	a4,-3
ffffffffc0201852:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201856:	6398                	ld	a4,0(a5)
ffffffffc0201858:	679c                	ld	a5,8(a5)
}
ffffffffc020185a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020185c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020185e:	e398                	sd	a4,0(a5)
ffffffffc0201860:	0141                	addi	sp,sp,16
ffffffffc0201862:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201864:	00005697          	auipc	a3,0x5
ffffffffc0201868:	b8c68693          	addi	a3,a3,-1140 # ffffffffc02063f0 <etext+0xd40>
ffffffffc020186c:	00005617          	auipc	a2,0x5
ffffffffc0201870:	82460613          	addi	a2,a2,-2012 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201874:	09400593          	li	a1,148
ffffffffc0201878:	00005517          	auipc	a0,0x5
ffffffffc020187c:	83050513          	addi	a0,a0,-2000 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201880:	c09fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(n > 0);
ffffffffc0201884:	00005697          	auipc	a3,0x5
ffffffffc0201888:	b6468693          	addi	a3,a3,-1180 # ffffffffc02063e8 <etext+0xd38>
ffffffffc020188c:	00005617          	auipc	a2,0x5
ffffffffc0201890:	80460613          	addi	a2,a2,-2044 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201894:	09000593          	li	a1,144
ffffffffc0201898:	00005517          	auipc	a0,0x5
ffffffffc020189c:	81050513          	addi	a0,a0,-2032 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc02018a0:	be9fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02018a4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018a4:	c949                	beqz	a0,ffffffffc0201936 <default_alloc_pages+0x92>
    if (n > nr_free)
ffffffffc02018a6:	00090617          	auipc	a2,0x90
ffffffffc02018aa:	21a60613          	addi	a2,a2,538 # ffffffffc0291ac0 <free_area>
ffffffffc02018ae:	4a0c                	lw	a1,16(a2)
ffffffffc02018b0:	872a                	mv	a4,a0
ffffffffc02018b2:	02059793          	slli	a5,a1,0x20
ffffffffc02018b6:	9381                	srli	a5,a5,0x20
ffffffffc02018b8:	00a7eb63          	bltu	a5,a0,ffffffffc02018ce <default_alloc_pages+0x2a>
    list_entry_t *le = &free_list;
ffffffffc02018bc:	87b2                	mv	a5,a2
ffffffffc02018be:	a029                	j	ffffffffc02018c8 <default_alloc_pages+0x24>
        if (p->property >= n)
ffffffffc02018c0:	ff87e683          	lwu	a3,-8(a5)
ffffffffc02018c4:	00e6f763          	bgeu	a3,a4,ffffffffc02018d2 <default_alloc_pages+0x2e>
    return listelm->next;
ffffffffc02018c8:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02018ca:	fec79be3          	bne	a5,a2,ffffffffc02018c0 <default_alloc_pages+0x1c>
        return NULL;
ffffffffc02018ce:	4501                	li	a0,0
}
ffffffffc02018d0:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc02018d2:	0087b883          	ld	a7,8(a5)
        if (page->property > n)
ffffffffc02018d6:	ff87a803          	lw	a6,-8(a5)
    return listelm->prev;
ffffffffc02018da:	6394                	ld	a3,0(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02018dc:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc02018e0:	02081313          	slli	t1,a6,0x20
    prev->next = next;
ffffffffc02018e4:	0116b423          	sd	a7,8(a3)
    next->prev = prev;
ffffffffc02018e8:	00d8b023          	sd	a3,0(a7)
ffffffffc02018ec:	02035313          	srli	t1,t1,0x20
            p->property = page->property - n;
ffffffffc02018f0:	0007089b          	sext.w	a7,a4
        if (page->property > n)
ffffffffc02018f4:	02677963          	bgeu	a4,t1,ffffffffc0201926 <default_alloc_pages+0x82>
            struct Page *p = page + n;
ffffffffc02018f8:	071a                	slli	a4,a4,0x6
ffffffffc02018fa:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02018fc:	4118083b          	subw	a6,a6,a7
ffffffffc0201900:	01072823          	sw	a6,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201904:	4589                	li	a1,2
ffffffffc0201906:	00870813          	addi	a6,a4,8
ffffffffc020190a:	40b8302f          	amoor.d	zero,a1,(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc020190e:	0086b803          	ld	a6,8(a3)
            list_add(prev, &(p->page_link));
ffffffffc0201912:	01870313          	addi	t1,a4,24
        nr_free -= n;
ffffffffc0201916:	4a0c                	lw	a1,16(a2)
    prev->next = next->prev = elm;
ffffffffc0201918:	00683023          	sd	t1,0(a6)
ffffffffc020191c:	0066b423          	sd	t1,8(a3)
    elm->next = next;
ffffffffc0201920:	03073023          	sd	a6,32(a4)
    elm->prev = prev;
ffffffffc0201924:	ef14                	sd	a3,24(a4)
ffffffffc0201926:	411585bb          	subw	a1,a1,a7
ffffffffc020192a:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020192c:	5775                	li	a4,-3
ffffffffc020192e:	17c1                	addi	a5,a5,-16
ffffffffc0201930:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201934:	8082                	ret
{
ffffffffc0201936:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201938:	00005697          	auipc	a3,0x5
ffffffffc020193c:	ab068693          	addi	a3,a3,-1360 # ffffffffc02063e8 <etext+0xd38>
ffffffffc0201940:	00004617          	auipc	a2,0x4
ffffffffc0201944:	75060613          	addi	a2,a2,1872 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201948:	06c00593          	li	a1,108
ffffffffc020194c:	00004517          	auipc	a0,0x4
ffffffffc0201950:	75c50513          	addi	a0,a0,1884 # ffffffffc02060a8 <etext+0x9f8>
{
ffffffffc0201954:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201956:	b33fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020195a <default_init_memmap>:
{
ffffffffc020195a:	1141                	addi	sp,sp,-16
ffffffffc020195c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020195e:	c5f1                	beqz	a1,ffffffffc0201a2a <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201960:	00659713          	slli	a4,a1,0x6
ffffffffc0201964:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201968:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc020196a:	cf11                	beqz	a4,ffffffffc0201986 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020196c:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020196e:	8b05                	andi	a4,a4,1
ffffffffc0201970:	cf49                	beqz	a4,ffffffffc0201a0a <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201972:	0007a823          	sw	zero,16(a5)
ffffffffc0201976:	0007b423          	sd	zero,8(a5)
ffffffffc020197a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc020197e:	04078793          	addi	a5,a5,64
ffffffffc0201982:	fed795e3          	bne	a5,a3,ffffffffc020196c <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201986:	2581                	sext.w	a1,a1
ffffffffc0201988:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020198a:	4789                	li	a5,2
ffffffffc020198c:	00850713          	addi	a4,a0,8
ffffffffc0201990:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201994:	00090697          	auipc	a3,0x90
ffffffffc0201998:	12c68693          	addi	a3,a3,300 # ffffffffc0291ac0 <free_area>
ffffffffc020199c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020199e:	669c                	ld	a5,8(a3)
ffffffffc02019a0:	9f2d                	addw	a4,a4,a1
ffffffffc02019a2:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc02019a4:	04d78663          	beq	a5,a3,ffffffffc02019f0 <default_init_memmap+0x96>
            struct Page *page = le2page(le, page_link);
ffffffffc02019a8:	fe878713          	addi	a4,a5,-24
ffffffffc02019ac:	4581                	li	a1,0
ffffffffc02019ae:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc02019b2:	00e56a63          	bltu	a0,a4,ffffffffc02019c6 <default_init_memmap+0x6c>
    return listelm->next;
ffffffffc02019b6:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019b8:	02d70263          	beq	a4,a3,ffffffffc02019dc <default_init_memmap+0x82>
    struct Page *p = base;
ffffffffc02019bc:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02019be:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02019c2:	fee57ae3          	bgeu	a0,a4,ffffffffc02019b6 <default_init_memmap+0x5c>
ffffffffc02019c6:	c199                	beqz	a1,ffffffffc02019cc <default_init_memmap+0x72>
ffffffffc02019c8:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02019cc:	6398                	ld	a4,0(a5)
}
ffffffffc02019ce:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02019d0:	e390                	sd	a2,0(a5)
ffffffffc02019d2:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02019d4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019d6:	ed18                	sd	a4,24(a0)
ffffffffc02019d8:	0141                	addi	sp,sp,16
ffffffffc02019da:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02019dc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02019de:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02019e0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02019e2:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02019e4:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc02019e6:	00d70e63          	beq	a4,a3,ffffffffc0201a02 <default_init_memmap+0xa8>
ffffffffc02019ea:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02019ec:	87ba                	mv	a5,a4
ffffffffc02019ee:	bfc1                	j	ffffffffc02019be <default_init_memmap+0x64>
}
ffffffffc02019f0:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02019f2:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc02019f6:	e398                	sd	a4,0(a5)
ffffffffc02019f8:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc02019fa:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019fc:	ed1c                	sd	a5,24(a0)
}
ffffffffc02019fe:	0141                	addi	sp,sp,16
ffffffffc0201a00:	8082                	ret
ffffffffc0201a02:	60a2                	ld	ra,8(sp)
ffffffffc0201a04:	e290                	sd	a2,0(a3)
ffffffffc0201a06:	0141                	addi	sp,sp,16
ffffffffc0201a08:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a0a:	00005697          	auipc	a3,0x5
ffffffffc0201a0e:	a0e68693          	addi	a3,a3,-1522 # ffffffffc0206418 <etext+0xd68>
ffffffffc0201a12:	00004617          	auipc	a2,0x4
ffffffffc0201a16:	67e60613          	addi	a2,a2,1662 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201a1a:	04b00593          	li	a1,75
ffffffffc0201a1e:	00004517          	auipc	a0,0x4
ffffffffc0201a22:	68a50513          	addi	a0,a0,1674 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201a26:	a63fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(n > 0);
ffffffffc0201a2a:	00005697          	auipc	a3,0x5
ffffffffc0201a2e:	9be68693          	addi	a3,a3,-1602 # ffffffffc02063e8 <etext+0xd38>
ffffffffc0201a32:	00004617          	auipc	a2,0x4
ffffffffc0201a36:	65e60613          	addi	a2,a2,1630 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201a3a:	04700593          	li	a1,71
ffffffffc0201a3e:	00004517          	auipc	a0,0x4
ffffffffc0201a42:	66a50513          	addi	a0,a0,1642 # ffffffffc02060a8 <etext+0x9f8>
ffffffffc0201a46:	a43fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201a4a <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a4a:	cd49                	beqz	a0,ffffffffc0201ae4 <slob_free+0x9a>
{
ffffffffc0201a4c:	1141                	addi	sp,sp,-16
ffffffffc0201a4e:	e022                	sd	s0,0(sp)
ffffffffc0201a50:	e406                	sd	ra,8(sp)
ffffffffc0201a52:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a54:	eda1                	bnez	a1,ffffffffc0201aac <slob_free+0x62>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a56:	100027f3          	csrr	a5,sstatus
ffffffffc0201a5a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a5c:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a5e:	efb9                	bnez	a5,ffffffffc0201abc <slob_free+0x72>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a60:	00090617          	auipc	a2,0x90
ffffffffc0201a64:	c5060613          	addi	a2,a2,-944 # ffffffffc02916b0 <slobfree>
ffffffffc0201a68:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a6a:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a6c:	0287fa63          	bgeu	a5,s0,ffffffffc0201aa0 <slob_free+0x56>
ffffffffc0201a70:	00e46463          	bltu	s0,a4,ffffffffc0201a78 <slob_free+0x2e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a74:	02e7ea63          	bltu	a5,a4,ffffffffc0201aa8 <slob_free+0x5e>
			break;

	if (b + b->units == cur->next)
ffffffffc0201a78:	400c                	lw	a1,0(s0)
ffffffffc0201a7a:	00459693          	slli	a3,a1,0x4
ffffffffc0201a7e:	96a2                	add	a3,a3,s0
ffffffffc0201a80:	04d70d63          	beq	a4,a3,ffffffffc0201ada <slob_free+0x90>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201a84:	438c                	lw	a1,0(a5)
ffffffffc0201a86:	e418                	sd	a4,8(s0)
ffffffffc0201a88:	00459693          	slli	a3,a1,0x4
ffffffffc0201a8c:	96be                	add	a3,a3,a5
ffffffffc0201a8e:	04d40063          	beq	s0,a3,ffffffffc0201ace <slob_free+0x84>
ffffffffc0201a92:	e780                	sd	s0,8(a5)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201a94:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201a96:	e51d                	bnez	a0,ffffffffc0201ac4 <slob_free+0x7a>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201a98:	60a2                	ld	ra,8(sp)
ffffffffc0201a9a:	6402                	ld	s0,0(sp)
ffffffffc0201a9c:	0141                	addi	sp,sp,16
ffffffffc0201a9e:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aa0:	00e7e463          	bltu	a5,a4,ffffffffc0201aa8 <slob_free+0x5e>
ffffffffc0201aa4:	fce46ae3          	bltu	s0,a4,ffffffffc0201a78 <slob_free+0x2e>
        return 1;
ffffffffc0201aa8:	87ba                	mv	a5,a4
ffffffffc0201aaa:	b7c1                	j	ffffffffc0201a6a <slob_free+0x20>
		b->units = SLOB_UNITS(size);
ffffffffc0201aac:	25bd                	addiw	a1,a1,15
ffffffffc0201aae:	8191                	srli	a1,a1,0x4
ffffffffc0201ab0:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ab2:	100027f3          	csrr	a5,sstatus
ffffffffc0201ab6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201ab8:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aba:	d3dd                	beqz	a5,ffffffffc0201a60 <slob_free+0x16>
        intr_disable();
ffffffffc0201abc:	ebffe0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0201ac0:	4505                	li	a0,1
ffffffffc0201ac2:	bf79                	j	ffffffffc0201a60 <slob_free+0x16>
}
ffffffffc0201ac4:	6402                	ld	s0,0(sp)
ffffffffc0201ac6:	60a2                	ld	ra,8(sp)
ffffffffc0201ac8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201aca:	eabfe06f          	j	ffffffffc0200974 <intr_enable>
		cur->units += b->units;
ffffffffc0201ace:	4014                	lw	a3,0(s0)
		cur->next = b->next;
ffffffffc0201ad0:	843a                	mv	s0,a4
		cur->units += b->units;
ffffffffc0201ad2:	00b6873b          	addw	a4,a3,a1
ffffffffc0201ad6:	c398                	sw	a4,0(a5)
		cur->next = b->next;
ffffffffc0201ad8:	bf6d                	j	ffffffffc0201a92 <slob_free+0x48>
		b->units += cur->next->units;
ffffffffc0201ada:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201adc:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc0201ade:	9ead                	addw	a3,a3,a1
ffffffffc0201ae0:	c014                	sw	a3,0(s0)
		b->next = cur->next->next;
ffffffffc0201ae2:	b74d                	j	ffffffffc0201a84 <slob_free+0x3a>
ffffffffc0201ae4:	8082                	ret

ffffffffc0201ae6 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201ae6:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201ae8:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201aea:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201aee:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201af0:	34c000ef          	jal	ffffffffc0201e3c <alloc_pages>
	if (!page)
ffffffffc0201af4:	c91d                	beqz	a0,ffffffffc0201b2a <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201af6:	00094797          	auipc	a5,0x94
ffffffffc0201afa:	0527b783          	ld	a5,82(a5) # ffffffffc0295b48 <pages>
ffffffffc0201afe:	8d1d                	sub	a0,a0,a5
ffffffffc0201b00:	8519                	srai	a0,a0,0x6
ffffffffc0201b02:	00006797          	auipc	a5,0x6
ffffffffc0201b06:	d067b783          	ld	a5,-762(a5) # ffffffffc0207808 <nbase>
ffffffffc0201b0a:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201b0c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b10:	83b1                	srli	a5,a5,0xc
ffffffffc0201b12:	00094717          	auipc	a4,0x94
ffffffffc0201b16:	02e73703          	ld	a4,46(a4) # ffffffffc0295b40 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b1a:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b1c:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b30 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b20:	00094797          	auipc	a5,0x94
ffffffffc0201b24:	0187b783          	ld	a5,24(a5) # ffffffffc0295b38 <va_pa_offset>
ffffffffc0201b28:	953e                	add	a0,a0,a5
}
ffffffffc0201b2a:	60a2                	ld	ra,8(sp)
ffffffffc0201b2c:	0141                	addi	sp,sp,16
ffffffffc0201b2e:	8082                	ret
ffffffffc0201b30:	86aa                	mv	a3,a0
ffffffffc0201b32:	00005617          	auipc	a2,0x5
ffffffffc0201b36:	90e60613          	addi	a2,a2,-1778 # ffffffffc0206440 <etext+0xd90>
ffffffffc0201b3a:	07100593          	li	a1,113
ffffffffc0201b3e:	00005517          	auipc	a0,0x5
ffffffffc0201b42:	92a50513          	addi	a0,a0,-1750 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0201b46:	943fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201b4a <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201b4a:	1101                	addi	sp,sp,-32
ffffffffc0201b4c:	ec06                	sd	ra,24(sp)
ffffffffc0201b4e:	e822                	sd	s0,16(sp)
ffffffffc0201b50:	e426                	sd	s1,8(sp)
ffffffffc0201b52:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b54:	01050713          	addi	a4,a0,16
ffffffffc0201b58:	6785                	lui	a5,0x1
ffffffffc0201b5a:	0cf77363          	bgeu	a4,a5,ffffffffc0201c20 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201b5e:	00f50493          	addi	s1,a0,15
ffffffffc0201b62:	8091                	srli	s1,s1,0x4
ffffffffc0201b64:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b66:	10002673          	csrr	a2,sstatus
ffffffffc0201b6a:	8a09                	andi	a2,a2,2
ffffffffc0201b6c:	e25d                	bnez	a2,ffffffffc0201c12 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201b6e:	00090917          	auipc	s2,0x90
ffffffffc0201b72:	b4290913          	addi	s2,s2,-1214 # ffffffffc02916b0 <slobfree>
ffffffffc0201b76:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b7a:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201b7c:	4398                	lw	a4,0(a5)
ffffffffc0201b7e:	08975e63          	bge	a4,s1,ffffffffc0201c1a <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201b82:	00f68b63          	beq	a3,a5,ffffffffc0201b98 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b86:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201b88:	4018                	lw	a4,0(s0)
ffffffffc0201b8a:	02975a63          	bge	a4,s1,ffffffffc0201bbe <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201b8e:	00093683          	ld	a3,0(s2)
ffffffffc0201b92:	87a2                	mv	a5,s0
ffffffffc0201b94:	fef699e3          	bne	a3,a5,ffffffffc0201b86 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201b98:	ee31                	bnez	a2,ffffffffc0201bf4 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201b9a:	4501                	li	a0,0
ffffffffc0201b9c:	f4bff0ef          	jal	ffffffffc0201ae6 <__slob_get_free_pages.constprop.0>
ffffffffc0201ba0:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201ba2:	cd05                	beqz	a0,ffffffffc0201bda <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201ba4:	6585                	lui	a1,0x1
ffffffffc0201ba6:	ea5ff0ef          	jal	ffffffffc0201a4a <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201baa:	10002673          	csrr	a2,sstatus
ffffffffc0201bae:	8a09                	andi	a2,a2,2
ffffffffc0201bb0:	ee05                	bnez	a2,ffffffffc0201be8 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201bb2:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bb6:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bb8:	4018                	lw	a4,0(s0)
ffffffffc0201bba:	fc974ae3          	blt	a4,s1,ffffffffc0201b8e <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201bbe:	04e48763          	beq	s1,a4,ffffffffc0201c0c <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201bc2:	00449693          	slli	a3,s1,0x4
ffffffffc0201bc6:	96a2                	add	a3,a3,s0
ffffffffc0201bc8:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201bca:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201bcc:	9f05                	subw	a4,a4,s1
ffffffffc0201bce:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201bd0:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201bd2:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201bd4:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201bd8:	e20d                	bnez	a2,ffffffffc0201bfa <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201bda:	60e2                	ld	ra,24(sp)
ffffffffc0201bdc:	8522                	mv	a0,s0
ffffffffc0201bde:	6442                	ld	s0,16(sp)
ffffffffc0201be0:	64a2                	ld	s1,8(sp)
ffffffffc0201be2:	6902                	ld	s2,0(sp)
ffffffffc0201be4:	6105                	addi	sp,sp,32
ffffffffc0201be6:	8082                	ret
        intr_disable();
ffffffffc0201be8:	d93fe0ef          	jal	ffffffffc020097a <intr_disable>
			cur = slobfree;
ffffffffc0201bec:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201bf0:	4605                	li	a2,1
ffffffffc0201bf2:	b7d1                	j	ffffffffc0201bb6 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201bf4:	d81fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201bf8:	b74d                	j	ffffffffc0201b9a <slob_alloc.constprop.0+0x50>
ffffffffc0201bfa:	d7bfe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201bfe:	60e2                	ld	ra,24(sp)
ffffffffc0201c00:	8522                	mv	a0,s0
ffffffffc0201c02:	6442                	ld	s0,16(sp)
ffffffffc0201c04:	64a2                	ld	s1,8(sp)
ffffffffc0201c06:	6902                	ld	s2,0(sp)
ffffffffc0201c08:	6105                	addi	sp,sp,32
ffffffffc0201c0a:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c0c:	6418                	ld	a4,8(s0)
ffffffffc0201c0e:	e798                	sd	a4,8(a5)
ffffffffc0201c10:	b7d1                	j	ffffffffc0201bd4 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c12:	d69fe0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0201c16:	4605                	li	a2,1
ffffffffc0201c18:	bf99                	j	ffffffffc0201b6e <slob_alloc.constprop.0+0x24>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c1a:	843e                	mv	s0,a5
	prev = slobfree;
ffffffffc0201c1c:	87b6                	mv	a5,a3
ffffffffc0201c1e:	b745                	j	ffffffffc0201bbe <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c20:	00005697          	auipc	a3,0x5
ffffffffc0201c24:	85868693          	addi	a3,a3,-1960 # ffffffffc0206478 <etext+0xdc8>
ffffffffc0201c28:	00004617          	auipc	a2,0x4
ffffffffc0201c2c:	46860613          	addi	a2,a2,1128 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0201c30:	06300593          	li	a1,99
ffffffffc0201c34:	00005517          	auipc	a0,0x5
ffffffffc0201c38:	86450513          	addi	a0,a0,-1948 # ffffffffc0206498 <etext+0xde8>
ffffffffc0201c3c:	84dfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201c40 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201c40:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201c42:	00005517          	auipc	a0,0x5
ffffffffc0201c46:	86e50513          	addi	a0,a0,-1938 # ffffffffc02064b0 <etext+0xe00>
{
ffffffffc0201c4a:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201c4c:	d48fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201c50:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c52:	00005517          	auipc	a0,0x5
ffffffffc0201c56:	87650513          	addi	a0,a0,-1930 # ffffffffc02064c8 <etext+0xe18>
}
ffffffffc0201c5a:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201c5c:	d38fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201c60 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201c60:	4501                	li	a0,0
ffffffffc0201c62:	8082                	ret

ffffffffc0201c64 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201c64:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c66:	6785                	lui	a5,0x1
{
ffffffffc0201c68:	e822                	sd	s0,16(sp)
ffffffffc0201c6a:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c6c:	17bd                	addi	a5,a5,-17 # fef <_binary_obj___user_softint_out_size-0x7609>
{
ffffffffc0201c6e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201c70:	04a7fa63          	bgeu	a5,a0,ffffffffc0201cc4 <kmalloc+0x60>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201c74:	4561                	li	a0,24
ffffffffc0201c76:	e426                	sd	s1,8(sp)
ffffffffc0201c78:	ed3ff0ef          	jal	ffffffffc0201b4a <slob_alloc.constprop.0>
ffffffffc0201c7c:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201c7e:	c549                	beqz	a0,ffffffffc0201d08 <kmalloc+0xa4>
ffffffffc0201c80:	e04a                	sd	s2,0(sp)
	bb->order = find_order(size);
ffffffffc0201c82:	0004079b          	sext.w	a5,s0
ffffffffc0201c86:	6905                	lui	s2,0x1
	int order = 0;
ffffffffc0201c88:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201c8a:	00f95763          	bge	s2,a5,ffffffffc0201c98 <kmalloc+0x34>
ffffffffc0201c8e:	6705                	lui	a4,0x1
ffffffffc0201c90:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201c92:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201c94:	fef74ee3          	blt	a4,a5,ffffffffc0201c90 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201c98:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201c9a:	e4dff0ef          	jal	ffffffffc0201ae6 <__slob_get_free_pages.constprop.0>
ffffffffc0201c9e:	e488                	sd	a0,8(s1)
	if (bb->pages)
ffffffffc0201ca0:	cd21                	beqz	a0,ffffffffc0201cf8 <kmalloc+0x94>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ca2:	100027f3          	csrr	a5,sstatus
ffffffffc0201ca6:	8b89                	andi	a5,a5,2
ffffffffc0201ca8:	e795                	bnez	a5,ffffffffc0201cd4 <kmalloc+0x70>
		bb->next = bigblocks;
ffffffffc0201caa:	00094797          	auipc	a5,0x94
ffffffffc0201cae:	e6e78793          	addi	a5,a5,-402 # ffffffffc0295b18 <bigblocks>
ffffffffc0201cb2:	6398                	ld	a4,0(a5)
ffffffffc0201cb4:	6902                	ld	s2,0(sp)
		bigblocks = bb;
ffffffffc0201cb6:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201cb8:	e898                	sd	a4,16(s1)
    if (flag)
ffffffffc0201cba:	64a2                	ld	s1,8(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201cbc:	60e2                	ld	ra,24(sp)
ffffffffc0201cbe:	6442                	ld	s0,16(sp)
ffffffffc0201cc0:	6105                	addi	sp,sp,32
ffffffffc0201cc2:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201cc4:	0541                	addi	a0,a0,16
ffffffffc0201cc6:	e85ff0ef          	jal	ffffffffc0201b4a <slob_alloc.constprop.0>
ffffffffc0201cca:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201ccc:	0541                	addi	a0,a0,16
ffffffffc0201cce:	f7fd                	bnez	a5,ffffffffc0201cbc <kmalloc+0x58>
		return 0;
ffffffffc0201cd0:	4501                	li	a0,0
	return __kmalloc(size, 0);
ffffffffc0201cd2:	b7ed                	j	ffffffffc0201cbc <kmalloc+0x58>
        intr_disable();
ffffffffc0201cd4:	ca7fe0ef          	jal	ffffffffc020097a <intr_disable>
		bb->next = bigblocks;
ffffffffc0201cd8:	00094797          	auipc	a5,0x94
ffffffffc0201cdc:	e4078793          	addi	a5,a5,-448 # ffffffffc0295b18 <bigblocks>
ffffffffc0201ce0:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201ce2:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201ce4:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201ce6:	c8ffe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201cea:	60e2                	ld	ra,24(sp)
ffffffffc0201cec:	6442                	ld	s0,16(sp)
		return bb->pages;
ffffffffc0201cee:	6488                	ld	a0,8(s1)
ffffffffc0201cf0:	6902                	ld	s2,0(sp)
ffffffffc0201cf2:	64a2                	ld	s1,8(sp)
}
ffffffffc0201cf4:	6105                	addi	sp,sp,32
ffffffffc0201cf6:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201cf8:	8526                	mv	a0,s1
ffffffffc0201cfa:	45e1                	li	a1,24
ffffffffc0201cfc:	d4fff0ef          	jal	ffffffffc0201a4a <slob_free>
		return 0;
ffffffffc0201d00:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d02:	64a2                	ld	s1,8(sp)
ffffffffc0201d04:	6902                	ld	s2,0(sp)
ffffffffc0201d06:	bf5d                	j	ffffffffc0201cbc <kmalloc+0x58>
ffffffffc0201d08:	64a2                	ld	s1,8(sp)
		return 0;
ffffffffc0201d0a:	4501                	li	a0,0
ffffffffc0201d0c:	bf45                	j	ffffffffc0201cbc <kmalloc+0x58>

ffffffffc0201d0e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d0e:	c169                	beqz	a0,ffffffffc0201dd0 <kfree+0xc2>
{
ffffffffc0201d10:	1101                	addi	sp,sp,-32
ffffffffc0201d12:	e822                	sd	s0,16(sp)
ffffffffc0201d14:	ec06                	sd	ra,24(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d16:	03451793          	slli	a5,a0,0x34
ffffffffc0201d1a:	842a                	mv	s0,a0
ffffffffc0201d1c:	e7c9                	bnez	a5,ffffffffc0201da6 <kfree+0x98>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d1e:	100027f3          	csrr	a5,sstatus
ffffffffc0201d22:	8b89                	andi	a5,a5,2
ffffffffc0201d24:	ebc1                	bnez	a5,ffffffffc0201db4 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d26:	00094797          	auipc	a5,0x94
ffffffffc0201d2a:	df27b783          	ld	a5,-526(a5) # ffffffffc0295b18 <bigblocks>
    return 0;
ffffffffc0201d2e:	4601                	li	a2,0
ffffffffc0201d30:	cbbd                	beqz	a5,ffffffffc0201da6 <kfree+0x98>
ffffffffc0201d32:	e426                	sd	s1,8(sp)
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201d34:	00094697          	auipc	a3,0x94
ffffffffc0201d38:	de468693          	addi	a3,a3,-540 # ffffffffc0295b18 <bigblocks>
ffffffffc0201d3c:	a021                	j	ffffffffc0201d44 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d3e:	01048693          	addi	a3,s1,16
ffffffffc0201d42:	c3a5                	beqz	a5,ffffffffc0201da2 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201d44:	6798                	ld	a4,8(a5)
ffffffffc0201d46:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201d48:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201d4a:	fe871ae3          	bne	a4,s0,ffffffffc0201d3e <kfree+0x30>
				*last = bb->next;
ffffffffc0201d4e:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201d50:	ee2d                	bnez	a2,ffffffffc0201dca <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201d52:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201d56:	4098                	lw	a4,0(s1)
ffffffffc0201d58:	08f46963          	bltu	s0,a5,ffffffffc0201dea <kfree+0xdc>
ffffffffc0201d5c:	00094797          	auipc	a5,0x94
ffffffffc0201d60:	ddc7b783          	ld	a5,-548(a5) # ffffffffc0295b38 <va_pa_offset>
ffffffffc0201d64:	8c1d                	sub	s0,s0,a5
    if (PPN(pa) >= npage)
ffffffffc0201d66:	8031                	srli	s0,s0,0xc
ffffffffc0201d68:	00094797          	auipc	a5,0x94
ffffffffc0201d6c:	dd87b783          	ld	a5,-552(a5) # ffffffffc0295b40 <npage>
ffffffffc0201d70:	06f47163          	bgeu	s0,a5,ffffffffc0201dd2 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201d74:	00006797          	auipc	a5,0x6
ffffffffc0201d78:	a947b783          	ld	a5,-1388(a5) # ffffffffc0207808 <nbase>
ffffffffc0201d7c:	8c1d                	sub	s0,s0,a5
ffffffffc0201d7e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201d80:	00094517          	auipc	a0,0x94
ffffffffc0201d84:	dc853503          	ld	a0,-568(a0) # ffffffffc0295b48 <pages>
ffffffffc0201d88:	4585                	li	a1,1
ffffffffc0201d8a:	9522                	add	a0,a0,s0
ffffffffc0201d8c:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201d90:	0ea000ef          	jal	ffffffffc0201e7a <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201d94:	6442                	ld	s0,16(sp)
ffffffffc0201d96:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d98:	8526                	mv	a0,s1
ffffffffc0201d9a:	64a2                	ld	s1,8(sp)
ffffffffc0201d9c:	45e1                	li	a1,24
}
ffffffffc0201d9e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201da0:	b16d                	j	ffffffffc0201a4a <slob_free>
ffffffffc0201da2:	64a2                	ld	s1,8(sp)
ffffffffc0201da4:	e205                	bnez	a2,ffffffffc0201dc4 <kfree+0xb6>
ffffffffc0201da6:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201daa:	6442                	ld	s0,16(sp)
ffffffffc0201dac:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201dae:	4581                	li	a1,0
}
ffffffffc0201db0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201db2:	b961                	j	ffffffffc0201a4a <slob_free>
        intr_disable();
ffffffffc0201db4:	bc7fe0ef          	jal	ffffffffc020097a <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201db8:	00094797          	auipc	a5,0x94
ffffffffc0201dbc:	d607b783          	ld	a5,-672(a5) # ffffffffc0295b18 <bigblocks>
        return 1;
ffffffffc0201dc0:	4605                	li	a2,1
ffffffffc0201dc2:	fba5                	bnez	a5,ffffffffc0201d32 <kfree+0x24>
        intr_enable();
ffffffffc0201dc4:	bb1fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201dc8:	bff9                	j	ffffffffc0201da6 <kfree+0x98>
ffffffffc0201dca:	babfe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0201dce:	b751                	j	ffffffffc0201d52 <kfree+0x44>
ffffffffc0201dd0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201dd2:	00004617          	auipc	a2,0x4
ffffffffc0201dd6:	73e60613          	addi	a2,a2,1854 # ffffffffc0206510 <etext+0xe60>
ffffffffc0201dda:	06900593          	li	a1,105
ffffffffc0201dde:	00004517          	auipc	a0,0x4
ffffffffc0201de2:	68a50513          	addi	a0,a0,1674 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0201de6:	ea2fe0ef          	jal	ffffffffc0200488 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201dea:	86a2                	mv	a3,s0
ffffffffc0201dec:	00004617          	auipc	a2,0x4
ffffffffc0201df0:	6fc60613          	addi	a2,a2,1788 # ffffffffc02064e8 <etext+0xe38>
ffffffffc0201df4:	07700593          	li	a1,119
ffffffffc0201df8:	00004517          	auipc	a0,0x4
ffffffffc0201dfc:	67050513          	addi	a0,a0,1648 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0201e00:	e88fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201e04 <pa2page.part.0>:

    uint64_t mem_begin = get_memory_base();
    uint64_t mem_size = get_memory_size();
    if (mem_size == 0)
    {
        panic("DTB memory info not available");
ffffffffc0201e04:	1141                	addi	sp,sp,-16
    }
    uint64_t mem_end = mem_begin + mem_size;

    cprintf("physcial memory map:\n");
ffffffffc0201e06:	00004617          	auipc	a2,0x4
ffffffffc0201e0a:	70a60613          	addi	a2,a2,1802 # ffffffffc0206510 <etext+0xe60>
ffffffffc0201e0e:	06900593          	li	a1,105
ffffffffc0201e12:	00004517          	auipc	a0,0x4
ffffffffc0201e16:	65650513          	addi	a0,a0,1622 # ffffffffc0206468 <etext+0xdb8>
        panic("DTB memory info not available");
ffffffffc0201e1a:	e406                	sd	ra,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc0201e1c:	e6cfe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201e20 <pte2page.part.0>:
    npage = maxpa / PGSIZE;
    // BBL has put the initial page table at the first available page after the
    // kernel
    // so stay away from it by adding extra offset to end
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

ffffffffc0201e20:	1141                	addi	sp,sp,-16
    for (size_t i = 0; i < npage - nbase; i++)
    {
        SetPageReserved(pages + i);
    }
ffffffffc0201e22:	00004617          	auipc	a2,0x4
ffffffffc0201e26:	70e60613          	addi	a2,a2,1806 # ffffffffc0206530 <etext+0xe80>
ffffffffc0201e2a:	07f00593          	li	a1,127
ffffffffc0201e2e:	00004517          	auipc	a0,0x4
ffffffffc0201e32:	63a50513          	addi	a0,a0,1594 # ffffffffc0206468 <etext+0xdb8>

ffffffffc0201e36:	e406                	sd	ra,8(sp)
    }
ffffffffc0201e38:	e50fe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0201e3c <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e3c:	100027f3          	csrr	a5,sstatus
ffffffffc0201e40:	8b89                	andi	a5,a5,2
ffffffffc0201e42:	e799                	bnez	a5,ffffffffc0201e50 <alloc_pages+0x14>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e44:	00094797          	auipc	a5,0x94
ffffffffc0201e48:	cdc7b783          	ld	a5,-804(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201e4c:	6f9c                	ld	a5,24(a5)
ffffffffc0201e4e:	8782                	jr	a5
{
ffffffffc0201e50:	1141                	addi	sp,sp,-16
ffffffffc0201e52:	e406                	sd	ra,8(sp)
ffffffffc0201e54:	e022                	sd	s0,0(sp)
ffffffffc0201e56:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201e58:	b23fe0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e5c:	00094797          	auipc	a5,0x94
ffffffffc0201e60:	cc47b783          	ld	a5,-828(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201e64:	6f9c                	ld	a5,24(a5)
ffffffffc0201e66:	8522                	mv	a0,s0
ffffffffc0201e68:	9782                	jalr	a5
ffffffffc0201e6a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e6c:	b09fe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201e70:	60a2                	ld	ra,8(sp)
ffffffffc0201e72:	8522                	mv	a0,s0
ffffffffc0201e74:	6402                	ld	s0,0(sp)
ffffffffc0201e76:	0141                	addi	sp,sp,16
ffffffffc0201e78:	8082                	ret

ffffffffc0201e7a <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e7e:	8b89                	andi	a5,a5,2
ffffffffc0201e80:	e799                	bnez	a5,ffffffffc0201e8e <free_pages+0x14>
        pmm_manager->free_pages(base, n);
ffffffffc0201e82:	00094797          	auipc	a5,0x94
ffffffffc0201e86:	c9e7b783          	ld	a5,-866(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201e8a:	739c                	ld	a5,32(a5)
ffffffffc0201e8c:	8782                	jr	a5
{
ffffffffc0201e8e:	1101                	addi	sp,sp,-32
ffffffffc0201e90:	ec06                	sd	ra,24(sp)
ffffffffc0201e92:	e822                	sd	s0,16(sp)
ffffffffc0201e94:	e426                	sd	s1,8(sp)
ffffffffc0201e96:	842a                	mv	s0,a0
ffffffffc0201e98:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201e9a:	ae1fe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201e9e:	00094797          	auipc	a5,0x94
ffffffffc0201ea2:	c827b783          	ld	a5,-894(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201ea6:	739c                	ld	a5,32(a5)
ffffffffc0201ea8:	85a6                	mv	a1,s1
ffffffffc0201eaa:	8522                	mv	a0,s0
ffffffffc0201eac:	9782                	jalr	a5
}
ffffffffc0201eae:	6442                	ld	s0,16(sp)
ffffffffc0201eb0:	60e2                	ld	ra,24(sp)
ffffffffc0201eb2:	64a2                	ld	s1,8(sp)
ffffffffc0201eb4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201eb6:	abffe06f          	j	ffffffffc0200974 <intr_enable>

ffffffffc0201eba <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201eba:	100027f3          	csrr	a5,sstatus
ffffffffc0201ebe:	8b89                	andi	a5,a5,2
ffffffffc0201ec0:	e799                	bnez	a5,ffffffffc0201ece <nr_free_pages+0x14>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201ec2:	00094797          	auipc	a5,0x94
ffffffffc0201ec6:	c5e7b783          	ld	a5,-930(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201eca:	779c                	ld	a5,40(a5)
ffffffffc0201ecc:	8782                	jr	a5
{
ffffffffc0201ece:	1141                	addi	sp,sp,-16
ffffffffc0201ed0:	e406                	sd	ra,8(sp)
ffffffffc0201ed2:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201ed4:	aa7fe0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201ed8:	00094797          	auipc	a5,0x94
ffffffffc0201edc:	c487b783          	ld	a5,-952(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201ee0:	779c                	ld	a5,40(a5)
ffffffffc0201ee2:	9782                	jalr	a5
ffffffffc0201ee4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ee6:	a8ffe0ef          	jal	ffffffffc0200974 <intr_enable>
}
ffffffffc0201eea:	60a2                	ld	ra,8(sp)
ffffffffc0201eec:	8522                	mv	a0,s0
ffffffffc0201eee:	6402                	ld	s0,0(sp)
ffffffffc0201ef0:	0141                	addi	sp,sp,16
ffffffffc0201ef2:	8082                	ret

ffffffffc0201ef4 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ef4:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201ef8:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201efc:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201efe:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f00:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f02:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f06:	6094                	ld	a3,0(s1)
{
ffffffffc0201f08:	f04a                	sd	s2,32(sp)
ffffffffc0201f0a:	ec4e                	sd	s3,24(sp)
ffffffffc0201f0c:	e852                	sd	s4,16(sp)
ffffffffc0201f0e:	fc06                	sd	ra,56(sp)
ffffffffc0201f10:	f822                	sd	s0,48(sp)
ffffffffc0201f12:	e456                	sd	s5,8(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f14:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f18:	892e                	mv	s2,a1
ffffffffc0201f1a:	8a32                	mv	s4,a2
ffffffffc0201f1c:	00094997          	auipc	s3,0x94
ffffffffc0201f20:	c2498993          	addi	s3,s3,-988 # ffffffffc0295b40 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f24:	e3c9                	bnez	a5,ffffffffc0201fa6 <get_pte+0xb2>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f26:	14060f63          	beqz	a2,ffffffffc0202084 <get_pte+0x190>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f2a:	100027f3          	csrr	a5,sstatus
ffffffffc0201f2e:	8b89                	andi	a5,a5,2
ffffffffc0201f30:	14079c63          	bnez	a5,ffffffffc0202088 <get_pte+0x194>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f34:	00094797          	auipc	a5,0x94
ffffffffc0201f38:	bec7b783          	ld	a5,-1044(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201f3c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f3e:	4505                	li	a0,1
ffffffffc0201f40:	9782                	jalr	a5
ffffffffc0201f42:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f44:	14040063          	beqz	s0,ffffffffc0202084 <get_pte+0x190>
    page->ref = val;
ffffffffc0201f48:	e05a                	sd	s6,0(sp)
    return page - pages + nbase;
ffffffffc0201f4a:	00094b17          	auipc	s6,0x94
ffffffffc0201f4e:	bfeb0b13          	addi	s6,s6,-1026 # ffffffffc0295b48 <pages>
ffffffffc0201f52:	000b3503          	ld	a0,0(s6)
ffffffffc0201f56:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f5a:	00094997          	auipc	s3,0x94
ffffffffc0201f5e:	be698993          	addi	s3,s3,-1050 # ffffffffc0295b40 <npage>
ffffffffc0201f62:	40a40533          	sub	a0,s0,a0
ffffffffc0201f66:	8519                	srai	a0,a0,0x6
ffffffffc0201f68:	9556                	add	a0,a0,s5
ffffffffc0201f6a:	0009b703          	ld	a4,0(s3)
ffffffffc0201f6e:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201f72:	4685                	li	a3,1
ffffffffc0201f74:	c014                	sw	a3,0(s0)
ffffffffc0201f76:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f78:	0532                	slli	a0,a0,0xc
ffffffffc0201f7a:	16e7fb63          	bgeu	a5,a4,ffffffffc02020f0 <get_pte+0x1fc>
ffffffffc0201f7e:	00094797          	auipc	a5,0x94
ffffffffc0201f82:	bba7b783          	ld	a5,-1094(a5) # ffffffffc0295b38 <va_pa_offset>
ffffffffc0201f86:	953e                	add	a0,a0,a5
ffffffffc0201f88:	6605                	lui	a2,0x1
ffffffffc0201f8a:	4581                	li	a1,0
ffffffffc0201f8c:	6fa030ef          	jal	ffffffffc0205686 <memset>
    return page - pages + nbase;
ffffffffc0201f90:	000b3783          	ld	a5,0(s6)
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f94:	6b02                	ld	s6,0(sp)
ffffffffc0201f96:	40f406b3          	sub	a3,s0,a5
ffffffffc0201f9a:	8699                	srai	a3,a3,0x6
ffffffffc0201f9c:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f9e:	06aa                	slli	a3,a3,0xa
ffffffffc0201fa0:	0116e693          	ori	a3,a3,17
ffffffffc0201fa4:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201fa6:	77fd                	lui	a5,0xfffff
ffffffffc0201fa8:	068a                	slli	a3,a3,0x2
ffffffffc0201faa:	0009b703          	ld	a4,0(s3)
ffffffffc0201fae:	8efd                	and	a3,a3,a5
ffffffffc0201fb0:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201fb4:	12e7f163          	bgeu	a5,a4,ffffffffc02020d6 <get_pte+0x1e2>
ffffffffc0201fb8:	00094a97          	auipc	s5,0x94
ffffffffc0201fbc:	b80a8a93          	addi	s5,s5,-1152 # ffffffffc0295b38 <va_pa_offset>
ffffffffc0201fc0:	000ab603          	ld	a2,0(s5)
ffffffffc0201fc4:	01595793          	srli	a5,s2,0x15
ffffffffc0201fc8:	1ff7f793          	andi	a5,a5,511
ffffffffc0201fcc:	96b2                	add	a3,a3,a2
ffffffffc0201fce:	078e                	slli	a5,a5,0x3
ffffffffc0201fd0:	00f68433          	add	s0,a3,a5
    if (!(*pdep0 & PTE_V))
ffffffffc0201fd4:	6014                	ld	a3,0(s0)
ffffffffc0201fd6:	0016f793          	andi	a5,a3,1
ffffffffc0201fda:	ebbd                	bnez	a5,ffffffffc0202050 <get_pte+0x15c>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fdc:	0a0a0463          	beqz	s4,ffffffffc0202084 <get_pte+0x190>
ffffffffc0201fe0:	100027f3          	csrr	a5,sstatus
ffffffffc0201fe4:	8b89                	andi	a5,a5,2
ffffffffc0201fe6:	efd5                	bnez	a5,ffffffffc02020a2 <get_pte+0x1ae>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fe8:	00094797          	auipc	a5,0x94
ffffffffc0201fec:	b387b783          	ld	a5,-1224(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0201ff0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ff2:	4505                	li	a0,1
ffffffffc0201ff4:	9782                	jalr	a5
ffffffffc0201ff6:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201ff8:	c4d1                	beqz	s1,ffffffffc0202084 <get_pte+0x190>
    page->ref = val;
ffffffffc0201ffa:	e05a                	sd	s6,0(sp)
    return page - pages + nbase;
ffffffffc0201ffc:	00094b17          	auipc	s6,0x94
ffffffffc0202000:	b4cb0b13          	addi	s6,s6,-1204 # ffffffffc0295b48 <pages>
ffffffffc0202004:	000b3683          	ld	a3,0(s6)
ffffffffc0202008:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020200c:	0009b703          	ld	a4,0(s3)
ffffffffc0202010:	40d486b3          	sub	a3,s1,a3
ffffffffc0202014:	8699                	srai	a3,a3,0x6
ffffffffc0202016:	96d2                	add	a3,a3,s4
ffffffffc0202018:	00c69793          	slli	a5,a3,0xc
    page->ref = val;
ffffffffc020201c:	4605                	li	a2,1
ffffffffc020201e:	c090                	sw	a2,0(s1)
ffffffffc0202020:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202022:	06b2                	slli	a3,a3,0xc
ffffffffc0202024:	0ee7f363          	bgeu	a5,a4,ffffffffc020210a <get_pte+0x216>
ffffffffc0202028:	000ab503          	ld	a0,0(s5)
ffffffffc020202c:	6605                	lui	a2,0x1
ffffffffc020202e:	4581                	li	a1,0
ffffffffc0202030:	9536                	add	a0,a0,a3
ffffffffc0202032:	654030ef          	jal	ffffffffc0205686 <memset>
    return page - pages + nbase;
ffffffffc0202036:	000b3783          	ld	a5,0(s6)
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020203a:	6b02                	ld	s6,0(sp)
ffffffffc020203c:	40f486b3          	sub	a3,s1,a5
ffffffffc0202040:	8699                	srai	a3,a3,0x6
ffffffffc0202042:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202044:	06aa                	slli	a3,a3,0xa
ffffffffc0202046:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020204a:	e014                	sd	a3,0(s0)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020204c:	0009b703          	ld	a4,0(s3)
ffffffffc0202050:	77fd                	lui	a5,0xfffff
ffffffffc0202052:	068a                	slli	a3,a3,0x2
ffffffffc0202054:	8efd                	and	a3,a3,a5
ffffffffc0202056:	00c6d793          	srli	a5,a3,0xc
ffffffffc020205a:	06e7f163          	bgeu	a5,a4,ffffffffc02020bc <get_pte+0x1c8>
ffffffffc020205e:	000ab783          	ld	a5,0(s5)
ffffffffc0202062:	00c95913          	srli	s2,s2,0xc
ffffffffc0202066:	1ff97913          	andi	s2,s2,511
ffffffffc020206a:	96be                	add	a3,a3,a5
ffffffffc020206c:	090e                	slli	s2,s2,0x3
ffffffffc020206e:	01268533          	add	a0,a3,s2
}
ffffffffc0202072:	70e2                	ld	ra,56(sp)
ffffffffc0202074:	7442                	ld	s0,48(sp)
ffffffffc0202076:	74a2                	ld	s1,40(sp)
ffffffffc0202078:	7902                	ld	s2,32(sp)
ffffffffc020207a:	69e2                	ld	s3,24(sp)
ffffffffc020207c:	6a42                	ld	s4,16(sp)
ffffffffc020207e:	6aa2                	ld	s5,8(sp)
ffffffffc0202080:	6121                	addi	sp,sp,64
ffffffffc0202082:	8082                	ret
            return NULL;
ffffffffc0202084:	4501                	li	a0,0
ffffffffc0202086:	b7f5                	j	ffffffffc0202072 <get_pte+0x17e>
        intr_disable();
ffffffffc0202088:	8f3fe0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020208c:	00094797          	auipc	a5,0x94
ffffffffc0202090:	a947b783          	ld	a5,-1388(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0202094:	6f9c                	ld	a5,24(a5)
ffffffffc0202096:	4505                	li	a0,1
ffffffffc0202098:	9782                	jalr	a5
ffffffffc020209a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020209c:	8d9fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02020a0:	b555                	j	ffffffffc0201f44 <get_pte+0x50>
        intr_disable();
ffffffffc02020a2:	8d9fe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02020a6:	00094797          	auipc	a5,0x94
ffffffffc02020aa:	a7a7b783          	ld	a5,-1414(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02020ae:	6f9c                	ld	a5,24(a5)
ffffffffc02020b0:	4505                	li	a0,1
ffffffffc02020b2:	9782                	jalr	a5
ffffffffc02020b4:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02020b6:	8bffe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02020ba:	bf3d                	j	ffffffffc0201ff8 <get_pte+0x104>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020bc:	00004617          	auipc	a2,0x4
ffffffffc02020c0:	38460613          	addi	a2,a2,900 # ffffffffc0206440 <etext+0xd90>
ffffffffc02020c4:	0fa00593          	li	a1,250
ffffffffc02020c8:	00004517          	auipc	a0,0x4
ffffffffc02020cc:	49050513          	addi	a0,a0,1168 # ffffffffc0206558 <etext+0xea8>
ffffffffc02020d0:	e05a                	sd	s6,0(sp)
ffffffffc02020d2:	bb6fe0ef          	jal	ffffffffc0200488 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02020d6:	00004617          	auipc	a2,0x4
ffffffffc02020da:	36a60613          	addi	a2,a2,874 # ffffffffc0206440 <etext+0xd90>
ffffffffc02020de:	0ed00593          	li	a1,237
ffffffffc02020e2:	00004517          	auipc	a0,0x4
ffffffffc02020e6:	47650513          	addi	a0,a0,1142 # ffffffffc0206558 <etext+0xea8>
ffffffffc02020ea:	e05a                	sd	s6,0(sp)
ffffffffc02020ec:	b9cfe0ef          	jal	ffffffffc0200488 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020f0:	86aa                	mv	a3,a0
ffffffffc02020f2:	00004617          	auipc	a2,0x4
ffffffffc02020f6:	34e60613          	addi	a2,a2,846 # ffffffffc0206440 <etext+0xd90>
ffffffffc02020fa:	0e900593          	li	a1,233
ffffffffc02020fe:	00004517          	auipc	a0,0x4
ffffffffc0202102:	45a50513          	addi	a0,a0,1114 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202106:	b82fe0ef          	jal	ffffffffc0200488 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020210a:	00004617          	auipc	a2,0x4
ffffffffc020210e:	33660613          	addi	a2,a2,822 # ffffffffc0206440 <etext+0xd90>
ffffffffc0202112:	0f700593          	li	a1,247
ffffffffc0202116:	00004517          	auipc	a0,0x4
ffffffffc020211a:	44250513          	addi	a0,a0,1090 # ffffffffc0206558 <etext+0xea8>
ffffffffc020211e:	b6afe0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0202122 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202122:	1141                	addi	sp,sp,-16
ffffffffc0202124:	e022                	sd	s0,0(sp)
ffffffffc0202126:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202128:	4601                	li	a2,0
{
ffffffffc020212a:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020212c:	dc9ff0ef          	jal	ffffffffc0201ef4 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202130:	c011                	beqz	s0,ffffffffc0202134 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202132:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202134:	c511                	beqz	a0,ffffffffc0202140 <get_page+0x1e>
ffffffffc0202136:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202138:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020213a:	0017f713          	andi	a4,a5,1
ffffffffc020213e:	e709                	bnez	a4,ffffffffc0202148 <get_page+0x26>
}
ffffffffc0202140:	60a2                	ld	ra,8(sp)
ffffffffc0202142:	6402                	ld	s0,0(sp)
ffffffffc0202144:	0141                	addi	sp,sp,16
ffffffffc0202146:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202148:	078a                	slli	a5,a5,0x2
ffffffffc020214a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020214c:	00094717          	auipc	a4,0x94
ffffffffc0202150:	9f473703          	ld	a4,-1548(a4) # ffffffffc0295b40 <npage>
ffffffffc0202154:	00e7ff63          	bgeu	a5,a4,ffffffffc0202172 <get_page+0x50>
ffffffffc0202158:	60a2                	ld	ra,8(sp)
ffffffffc020215a:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020215c:	fff80737          	lui	a4,0xfff80
ffffffffc0202160:	97ba                	add	a5,a5,a4
ffffffffc0202162:	00094517          	auipc	a0,0x94
ffffffffc0202166:	9e653503          	ld	a0,-1562(a0) # ffffffffc0295b48 <pages>
ffffffffc020216a:	079a                	slli	a5,a5,0x6
ffffffffc020216c:	953e                	add	a0,a0,a5
ffffffffc020216e:	0141                	addi	sp,sp,16
ffffffffc0202170:	8082                	ret
ffffffffc0202172:	c93ff0ef          	jal	ffffffffc0201e04 <pa2page.part.0>

ffffffffc0202176 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202176:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202178:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020217c:	e486                	sd	ra,72(sp)
ffffffffc020217e:	e0a2                	sd	s0,64(sp)
ffffffffc0202180:	fc26                	sd	s1,56(sp)
ffffffffc0202182:	f84a                	sd	s2,48(sp)
ffffffffc0202184:	f44e                	sd	s3,40(sp)
ffffffffc0202186:	f052                	sd	s4,32(sp)
ffffffffc0202188:	ec56                	sd	s5,24(sp)
ffffffffc020218a:	e85a                	sd	s6,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020218c:	17d2                	slli	a5,a5,0x34
ffffffffc020218e:	e7f9                	bnez	a5,ffffffffc020225c <unmap_range+0xe6>
    assert(USER_ACCESS(start, end));
ffffffffc0202190:	002007b7          	lui	a5,0x200
ffffffffc0202194:	842e                	mv	s0,a1
ffffffffc0202196:	0ef5e363          	bltu	a1,a5,ffffffffc020227c <unmap_range+0x106>
ffffffffc020219a:	8932                	mv	s2,a2
ffffffffc020219c:	0ec5f063          	bgeu	a1,a2,ffffffffc020227c <unmap_range+0x106>
ffffffffc02021a0:	4785                	li	a5,1
ffffffffc02021a2:	07fe                	slli	a5,a5,0x1f
ffffffffc02021a4:	0cc7ec63          	bltu	a5,a2,ffffffffc020227c <unmap_range+0x106>
ffffffffc02021a8:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02021aa:	6a05                	lui	s4,0x1
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02021ac:	00200b37          	lui	s6,0x200
ffffffffc02021b0:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02021b4:	4601                	li	a2,0
ffffffffc02021b6:	85a2                	mv	a1,s0
ffffffffc02021b8:	854e                	mv	a0,s3
ffffffffc02021ba:	d3bff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc02021be:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02021c0:	c125                	beqz	a0,ffffffffc0202220 <unmap_range+0xaa>
        if (*ptep != 0)
ffffffffc02021c2:	611c                	ld	a5,0(a0)
ffffffffc02021c4:	ef99                	bnez	a5,ffffffffc02021e2 <unmap_range+0x6c>
        start += PGSIZE;
ffffffffc02021c6:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02021c8:	c019                	beqz	s0,ffffffffc02021ce <unmap_range+0x58>
ffffffffc02021ca:	ff2465e3          	bltu	s0,s2,ffffffffc02021b4 <unmap_range+0x3e>
}
ffffffffc02021ce:	60a6                	ld	ra,72(sp)
ffffffffc02021d0:	6406                	ld	s0,64(sp)
ffffffffc02021d2:	74e2                	ld	s1,56(sp)
ffffffffc02021d4:	7942                	ld	s2,48(sp)
ffffffffc02021d6:	79a2                	ld	s3,40(sp)
ffffffffc02021d8:	7a02                	ld	s4,32(sp)
ffffffffc02021da:	6ae2                	ld	s5,24(sp)
ffffffffc02021dc:	6b42                	ld	s6,16(sp)
ffffffffc02021de:	6161                	addi	sp,sp,80
ffffffffc02021e0:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02021e2:	0017f713          	andi	a4,a5,1
ffffffffc02021e6:	d365                	beqz	a4,ffffffffc02021c6 <unmap_range+0x50>
    return pa2page(PTE_ADDR(pte));
ffffffffc02021e8:	078a                	slli	a5,a5,0x2
ffffffffc02021ea:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021ec:	00094717          	auipc	a4,0x94
ffffffffc02021f0:	95473703          	ld	a4,-1708(a4) # ffffffffc0295b40 <npage>
ffffffffc02021f4:	0ae7f463          	bgeu	a5,a4,ffffffffc020229c <unmap_range+0x126>
    return &pages[PPN(pa) - nbase];
ffffffffc02021f8:	fff80737          	lui	a4,0xfff80
ffffffffc02021fc:	97ba                	add	a5,a5,a4
ffffffffc02021fe:	079a                	slli	a5,a5,0x6
ffffffffc0202200:	00094517          	auipc	a0,0x94
ffffffffc0202204:	94853503          	ld	a0,-1720(a0) # ffffffffc0295b48 <pages>
ffffffffc0202208:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020220a:	411c                	lw	a5,0(a0)
ffffffffc020220c:	fff7871b          	addiw	a4,a5,-1 # 1fffff <_binary_obj___user_exit_out_size+0x1f6497>
ffffffffc0202210:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202212:	cb19                	beqz	a4,ffffffffc0202228 <unmap_range+0xb2>
        *ptep = 0;
ffffffffc0202214:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202218:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020221c:	9452                	add	s0,s0,s4
ffffffffc020221e:	b76d                	j	ffffffffc02021c8 <unmap_range+0x52>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202220:	945a                	add	s0,s0,s6
ffffffffc0202222:	01547433          	and	s0,s0,s5
            continue;
ffffffffc0202226:	b74d                	j	ffffffffc02021c8 <unmap_range+0x52>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202228:	100027f3          	csrr	a5,sstatus
ffffffffc020222c:	8b89                	andi	a5,a5,2
ffffffffc020222e:	eb89                	bnez	a5,ffffffffc0202240 <unmap_range+0xca>
        pmm_manager->free_pages(base, n);
ffffffffc0202230:	00094797          	auipc	a5,0x94
ffffffffc0202234:	8f07b783          	ld	a5,-1808(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0202238:	739c                	ld	a5,32(a5)
ffffffffc020223a:	4585                	li	a1,1
ffffffffc020223c:	9782                	jalr	a5
    if (flag)
ffffffffc020223e:	bfd9                	j	ffffffffc0202214 <unmap_range+0x9e>
        intr_disable();
ffffffffc0202240:	e42a                	sd	a0,8(sp)
ffffffffc0202242:	f38fe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202246:	00094797          	auipc	a5,0x94
ffffffffc020224a:	8da7b783          	ld	a5,-1830(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc020224e:	739c                	ld	a5,32(a5)
ffffffffc0202250:	6522                	ld	a0,8(sp)
ffffffffc0202252:	4585                	li	a1,1
ffffffffc0202254:	9782                	jalr	a5
        intr_enable();
ffffffffc0202256:	f1efe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020225a:	bf6d                	j	ffffffffc0202214 <unmap_range+0x9e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020225c:	00004697          	auipc	a3,0x4
ffffffffc0202260:	30c68693          	addi	a3,a3,780 # ffffffffc0206568 <etext+0xeb8>
ffffffffc0202264:	00004617          	auipc	a2,0x4
ffffffffc0202268:	e2c60613          	addi	a2,a2,-468 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020226c:	12000593          	li	a1,288
ffffffffc0202270:	00004517          	auipc	a0,0x4
ffffffffc0202274:	2e850513          	addi	a0,a0,744 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202278:	a10fe0ef          	jal	ffffffffc0200488 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020227c:	00004697          	auipc	a3,0x4
ffffffffc0202280:	31c68693          	addi	a3,a3,796 # ffffffffc0206598 <etext+0xee8>
ffffffffc0202284:	00004617          	auipc	a2,0x4
ffffffffc0202288:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020228c:	12100593          	li	a1,289
ffffffffc0202290:	00004517          	auipc	a0,0x4
ffffffffc0202294:	2c850513          	addi	a0,a0,712 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202298:	9f0fe0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc020229c:	b69ff0ef          	jal	ffffffffc0201e04 <pa2page.part.0>

ffffffffc02022a0 <exit_range>:
{
ffffffffc02022a0:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022a2:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02022a6:	fc86                	sd	ra,120(sp)
ffffffffc02022a8:	f8a2                	sd	s0,112(sp)
ffffffffc02022aa:	f4a6                	sd	s1,104(sp)
ffffffffc02022ac:	f0ca                	sd	s2,96(sp)
ffffffffc02022ae:	ecce                	sd	s3,88(sp)
ffffffffc02022b0:	e8d2                	sd	s4,80(sp)
ffffffffc02022b2:	e4d6                	sd	s5,72(sp)
ffffffffc02022b4:	e0da                	sd	s6,64(sp)
ffffffffc02022b6:	fc5e                	sd	s7,56(sp)
ffffffffc02022b8:	f862                	sd	s8,48(sp)
ffffffffc02022ba:	f466                	sd	s9,40(sp)
ffffffffc02022bc:	f06a                	sd	s10,32(sp)
ffffffffc02022be:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022c0:	17d2                	slli	a5,a5,0x34
ffffffffc02022c2:	24079163          	bnez	a5,ffffffffc0202504 <exit_range+0x264>
    assert(USER_ACCESS(start, end));
ffffffffc02022c6:	002007b7          	lui	a5,0x200
ffffffffc02022ca:	28f5e863          	bltu	a1,a5,ffffffffc020255a <exit_range+0x2ba>
ffffffffc02022ce:	8b32                	mv	s6,a2
ffffffffc02022d0:	28c5f563          	bgeu	a1,a2,ffffffffc020255a <exit_range+0x2ba>
ffffffffc02022d4:	4785                	li	a5,1
ffffffffc02022d6:	07fe                	slli	a5,a5,0x1f
ffffffffc02022d8:	28c7e163          	bltu	a5,a2,ffffffffc020255a <exit_range+0x2ba>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02022dc:	c0000a37          	lui	s4,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02022e0:	ffe007b7          	lui	a5,0xffe00
ffffffffc02022e4:	8d2a                	mv	s10,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02022e6:	0145fa33          	and	s4,a1,s4
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02022ea:	00f5f4b3          	and	s1,a1,a5
        d1start += PDSIZE;
ffffffffc02022ee:	40000db7          	lui	s11,0x40000
    if (PPN(pa) >= npage)
ffffffffc02022f2:	00094617          	auipc	a2,0x94
ffffffffc02022f6:	84e60613          	addi	a2,a2,-1970 # ffffffffc0295b40 <npage>
    return KADDR(page2pa(page));
ffffffffc02022fa:	00094817          	auipc	a6,0x94
ffffffffc02022fe:	83e80813          	addi	a6,a6,-1986 # ffffffffc0295b38 <va_pa_offset>
    return &pages[PPN(pa) - nbase];
ffffffffc0202302:	00094e97          	auipc	t4,0x94
ffffffffc0202306:	846e8e93          	addi	t4,t4,-1978 # ffffffffc0295b48 <pages>
                d0start += PTSIZE;
ffffffffc020230a:	00200c37          	lui	s8,0x200
ffffffffc020230e:	a819                	j	ffffffffc0202324 <exit_range+0x84>
        d1start += PDSIZE;
ffffffffc0202310:	01ba09b3          	add	s3,s4,s11
    } while (d1start != 0 && d1start < end);
ffffffffc0202314:	14098763          	beqz	s3,ffffffffc0202462 <exit_range+0x1c2>
        d1start += PDSIZE;
ffffffffc0202318:	40000a37          	lui	s4,0x40000
        d0start = d1start;
ffffffffc020231c:	400004b7          	lui	s1,0x40000
    } while (d1start != 0 && d1start < end);
ffffffffc0202320:	1569f163          	bgeu	s3,s6,ffffffffc0202462 <exit_range+0x1c2>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202324:	01ea5913          	srli	s2,s4,0x1e
ffffffffc0202328:	1ff97913          	andi	s2,s2,511
ffffffffc020232c:	090e                	slli	s2,s2,0x3
ffffffffc020232e:	996a                	add	s2,s2,s10
ffffffffc0202330:	00093a83          	ld	s5,0(s2) # 1000 <_binary_obj___user_softint_out_size-0x75f8>
        if (pde1 & PTE_V)
ffffffffc0202334:	001af793          	andi	a5,s5,1
ffffffffc0202338:	dfe1                	beqz	a5,ffffffffc0202310 <exit_range+0x70>
    if (PPN(pa) >= npage)
ffffffffc020233a:	6214                	ld	a3,0(a2)
    return pa2page(PDE_ADDR(pde));
ffffffffc020233c:	0a8a                	slli	s5,s5,0x2
ffffffffc020233e:	00cada93          	srli	s5,s5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202342:	20dafa63          	bgeu	s5,a3,ffffffffc0202556 <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc0202346:	fff80737          	lui	a4,0xfff80
ffffffffc020234a:	9756                	add	a4,a4,s5
    return page - pages + nbase;
ffffffffc020234c:	000807b7          	lui	a5,0x80
ffffffffc0202350:	97ba                	add	a5,a5,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0202352:	00c79b93          	slli	s7,a5,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202356:	071a                	slli	a4,a4,0x6
    return KADDR(page2pa(page));
ffffffffc0202358:	1ed7f263          	bgeu	a5,a3,ffffffffc020253c <exit_range+0x29c>
ffffffffc020235c:	00083783          	ld	a5,0(a6)
            free_pd0 = 1;
ffffffffc0202360:	4c85                	li	s9,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202362:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202366:	9bbe                	add	s7,s7,a5
    return page - pages + nbase;
ffffffffc0202368:	00080337          	lui	t1,0x80
ffffffffc020236c:	6885                	lui	a7,0x1
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020236e:	01ba09b3          	add	s3,s4,s11
ffffffffc0202372:	a801                	j	ffffffffc0202382 <exit_range+0xe2>
                    free_pd0 = 0;
ffffffffc0202374:	4c81                	li	s9,0
                d0start += PTSIZE;
ffffffffc0202376:	94e2                	add	s1,s1,s8
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202378:	ccd1                	beqz	s1,ffffffffc0202414 <exit_range+0x174>
ffffffffc020237a:	0934fd63          	bgeu	s1,s3,ffffffffc0202414 <exit_range+0x174>
ffffffffc020237e:	1164f163          	bgeu	s1,s6,ffffffffc0202480 <exit_range+0x1e0>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202382:	0154d413          	srli	s0,s1,0x15
ffffffffc0202386:	1ff47413          	andi	s0,s0,511
ffffffffc020238a:	040e                	slli	s0,s0,0x3
ffffffffc020238c:	945e                	add	s0,s0,s7
ffffffffc020238e:	601c                	ld	a5,0(s0)
                if (pde0 & PTE_V)
ffffffffc0202390:	0017f693          	andi	a3,a5,1
ffffffffc0202394:	d2e5                	beqz	a3,ffffffffc0202374 <exit_range+0xd4>
    if (PPN(pa) >= npage)
ffffffffc0202396:	00063f03          	ld	t5,0(a2)
    return pa2page(PDE_ADDR(pde));
ffffffffc020239a:	078a                	slli	a5,a5,0x2
ffffffffc020239c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020239e:	1be7fc63          	bgeu	a5,t5,ffffffffc0202556 <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc02023a2:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02023a4:	00678fb3          	add	t6,a5,t1
    return &pages[PPN(pa) - nbase];
ffffffffc02023a8:	000eb503          	ld	a0,0(t4)
ffffffffc02023ac:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023b0:	00cf9693          	slli	a3,t6,0xc
    return KADDR(page2pa(page));
ffffffffc02023b4:	17eff863          	bgeu	t6,t5,ffffffffc0202524 <exit_range+0x284>
ffffffffc02023b8:	00083783          	ld	a5,0(a6)
ffffffffc02023bc:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02023be:	01168f33          	add	t5,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc02023c2:	629c                	ld	a5,0(a3)
ffffffffc02023c4:	8b85                	andi	a5,a5,1
ffffffffc02023c6:	fbc5                	bnez	a5,ffffffffc0202376 <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02023c8:	06a1                	addi	a3,a3,8
ffffffffc02023ca:	ffe69ce3          	bne	a3,t5,ffffffffc02023c2 <exit_range+0x122>
    return &pages[PPN(pa) - nbase];
ffffffffc02023ce:	952e                	add	a0,a0,a1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02023d0:	100027f3          	csrr	a5,sstatus
ffffffffc02023d4:	8b89                	andi	a5,a5,2
ffffffffc02023d6:	ebc5                	bnez	a5,ffffffffc0202486 <exit_range+0x1e6>
        pmm_manager->free_pages(base, n);
ffffffffc02023d8:	00093797          	auipc	a5,0x93
ffffffffc02023dc:	7487b783          	ld	a5,1864(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02023e0:	739c                	ld	a5,32(a5)
ffffffffc02023e2:	4585                	li	a1,1
ffffffffc02023e4:	e03a                	sd	a4,0(sp)
ffffffffc02023e6:	9782                	jalr	a5
    if (flag)
ffffffffc02023e8:	6702                	ld	a4,0(sp)
ffffffffc02023ea:	fff80e37          	lui	t3,0xfff80
ffffffffc02023ee:	00080337          	lui	t1,0x80
ffffffffc02023f2:	6885                	lui	a7,0x1
ffffffffc02023f4:	00093617          	auipc	a2,0x93
ffffffffc02023f8:	74c60613          	addi	a2,a2,1868 # ffffffffc0295b40 <npage>
ffffffffc02023fc:	00093817          	auipc	a6,0x93
ffffffffc0202400:	73c80813          	addi	a6,a6,1852 # ffffffffc0295b38 <va_pa_offset>
ffffffffc0202404:	00093e97          	auipc	t4,0x93
ffffffffc0202408:	744e8e93          	addi	t4,t4,1860 # ffffffffc0295b48 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020240c:	00043023          	sd	zero,0(s0)
                d0start += PTSIZE;
ffffffffc0202410:	94e2                	add	s1,s1,s8
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202412:	f4a5                	bnez	s1,ffffffffc020237a <exit_range+0xda>
            if (free_pd0)
ffffffffc0202414:	ee0c8ee3          	beqz	s9,ffffffffc0202310 <exit_range+0x70>
    if (PPN(pa) >= npage)
ffffffffc0202418:	621c                	ld	a5,0(a2)
ffffffffc020241a:	12fafe63          	bgeu	s5,a5,ffffffffc0202556 <exit_range+0x2b6>
    return &pages[PPN(pa) - nbase];
ffffffffc020241e:	00093517          	auipc	a0,0x93
ffffffffc0202422:	72a53503          	ld	a0,1834(a0) # ffffffffc0295b48 <pages>
ffffffffc0202426:	953a                	add	a0,a0,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202428:	100027f3          	csrr	a5,sstatus
ffffffffc020242c:	8b89                	andi	a5,a5,2
ffffffffc020242e:	efd9                	bnez	a5,ffffffffc02024cc <exit_range+0x22c>
        pmm_manager->free_pages(base, n);
ffffffffc0202430:	00093797          	auipc	a5,0x93
ffffffffc0202434:	6f07b783          	ld	a5,1776(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0202438:	739c                	ld	a5,32(a5)
ffffffffc020243a:	4585                	li	a1,1
ffffffffc020243c:	9782                	jalr	a5
ffffffffc020243e:	00093e97          	auipc	t4,0x93
ffffffffc0202442:	70ae8e93          	addi	t4,t4,1802 # ffffffffc0295b48 <pages>
ffffffffc0202446:	00093817          	auipc	a6,0x93
ffffffffc020244a:	6f280813          	addi	a6,a6,1778 # ffffffffc0295b38 <va_pa_offset>
ffffffffc020244e:	00093617          	auipc	a2,0x93
ffffffffc0202452:	6f260613          	addi	a2,a2,1778 # ffffffffc0295b40 <npage>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202456:	00093023          	sd	zero,0(s2)
        d1start += PDSIZE;
ffffffffc020245a:	01ba09b3          	add	s3,s4,s11
    } while (d1start != 0 && d1start < end);
ffffffffc020245e:	ea099de3          	bnez	s3,ffffffffc0202318 <exit_range+0x78>
}
ffffffffc0202462:	70e6                	ld	ra,120(sp)
ffffffffc0202464:	7446                	ld	s0,112(sp)
ffffffffc0202466:	74a6                	ld	s1,104(sp)
ffffffffc0202468:	7906                	ld	s2,96(sp)
ffffffffc020246a:	69e6                	ld	s3,88(sp)
ffffffffc020246c:	6a46                	ld	s4,80(sp)
ffffffffc020246e:	6aa6                	ld	s5,72(sp)
ffffffffc0202470:	6b06                	ld	s6,64(sp)
ffffffffc0202472:	7be2                	ld	s7,56(sp)
ffffffffc0202474:	7c42                	ld	s8,48(sp)
ffffffffc0202476:	7ca2                	ld	s9,40(sp)
ffffffffc0202478:	7d02                	ld	s10,32(sp)
ffffffffc020247a:	6de2                	ld	s11,24(sp)
ffffffffc020247c:	6109                	addi	sp,sp,128
ffffffffc020247e:	8082                	ret
            if (free_pd0)
ffffffffc0202480:	e80c8ce3          	beqz	s9,ffffffffc0202318 <exit_range+0x78>
ffffffffc0202484:	bf51                	j	ffffffffc0202418 <exit_range+0x178>
        intr_disable();
ffffffffc0202486:	e03a                	sd	a4,0(sp)
ffffffffc0202488:	e42a                	sd	a0,8(sp)
ffffffffc020248a:	cf0fe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020248e:	00093797          	auipc	a5,0x93
ffffffffc0202492:	6927b783          	ld	a5,1682(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc0202496:	739c                	ld	a5,32(a5)
ffffffffc0202498:	6522                	ld	a0,8(sp)
ffffffffc020249a:	4585                	li	a1,1
ffffffffc020249c:	9782                	jalr	a5
        intr_enable();
ffffffffc020249e:	cd6fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02024a2:	6702                	ld	a4,0(sp)
ffffffffc02024a4:	00093e97          	auipc	t4,0x93
ffffffffc02024a8:	6a4e8e93          	addi	t4,t4,1700 # ffffffffc0295b48 <pages>
ffffffffc02024ac:	00093817          	auipc	a6,0x93
ffffffffc02024b0:	68c80813          	addi	a6,a6,1676 # ffffffffc0295b38 <va_pa_offset>
ffffffffc02024b4:	00093617          	auipc	a2,0x93
ffffffffc02024b8:	68c60613          	addi	a2,a2,1676 # ffffffffc0295b40 <npage>
ffffffffc02024bc:	6885                	lui	a7,0x1
ffffffffc02024be:	00080337          	lui	t1,0x80
ffffffffc02024c2:	fff80e37          	lui	t3,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc02024c6:	00043023          	sd	zero,0(s0)
ffffffffc02024ca:	b799                	j	ffffffffc0202410 <exit_range+0x170>
        intr_disable();
ffffffffc02024cc:	e02a                	sd	a0,0(sp)
ffffffffc02024ce:	cacfe0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02024d2:	00093797          	auipc	a5,0x93
ffffffffc02024d6:	64e7b783          	ld	a5,1614(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02024da:	739c                	ld	a5,32(a5)
ffffffffc02024dc:	6502                	ld	a0,0(sp)
ffffffffc02024de:	4585                	li	a1,1
ffffffffc02024e0:	9782                	jalr	a5
        intr_enable();
ffffffffc02024e2:	c92fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02024e6:	00093617          	auipc	a2,0x93
ffffffffc02024ea:	65a60613          	addi	a2,a2,1626 # ffffffffc0295b40 <npage>
ffffffffc02024ee:	00093817          	auipc	a6,0x93
ffffffffc02024f2:	64a80813          	addi	a6,a6,1610 # ffffffffc0295b38 <va_pa_offset>
ffffffffc02024f6:	00093e97          	auipc	t4,0x93
ffffffffc02024fa:	652e8e93          	addi	t4,t4,1618 # ffffffffc0295b48 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024fe:	00093023          	sd	zero,0(s2)
ffffffffc0202502:	bfa1                	j	ffffffffc020245a <exit_range+0x1ba>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202504:	00004697          	auipc	a3,0x4
ffffffffc0202508:	06468693          	addi	a3,a3,100 # ffffffffc0206568 <etext+0xeb8>
ffffffffc020250c:	00004617          	auipc	a2,0x4
ffffffffc0202510:	b8460613          	addi	a2,a2,-1148 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0202514:	13500593          	li	a1,309
ffffffffc0202518:	00004517          	auipc	a0,0x4
ffffffffc020251c:	04050513          	addi	a0,a0,64 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202520:	f69fd0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202524:	00004617          	auipc	a2,0x4
ffffffffc0202528:	f1c60613          	addi	a2,a2,-228 # ffffffffc0206440 <etext+0xd90>
ffffffffc020252c:	07100593          	li	a1,113
ffffffffc0202530:	00004517          	auipc	a0,0x4
ffffffffc0202534:	f3850513          	addi	a0,a0,-200 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0202538:	f51fd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc020253c:	86de                	mv	a3,s7
ffffffffc020253e:	00004617          	auipc	a2,0x4
ffffffffc0202542:	f0260613          	addi	a2,a2,-254 # ffffffffc0206440 <etext+0xd90>
ffffffffc0202546:	07100593          	li	a1,113
ffffffffc020254a:	00004517          	auipc	a0,0x4
ffffffffc020254e:	f1e50513          	addi	a0,a0,-226 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0202552:	f37fd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0202556:	8afff0ef          	jal	ffffffffc0201e04 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc020255a:	00004697          	auipc	a3,0x4
ffffffffc020255e:	03e68693          	addi	a3,a3,62 # ffffffffc0206598 <etext+0xee8>
ffffffffc0202562:	00004617          	auipc	a2,0x4
ffffffffc0202566:	b2e60613          	addi	a2,a2,-1234 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020256a:	13600593          	li	a1,310
ffffffffc020256e:	00004517          	auipc	a0,0x4
ffffffffc0202572:	fea50513          	addi	a0,a0,-22 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202576:	f13fd0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020257a <copy_range>:
{
ffffffffc020257a:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020257c:	00d667b3          	or	a5,a2,a3
{
ffffffffc0202580:	fc86                	sd	ra,120(sp)
ffffffffc0202582:	f8a2                	sd	s0,112(sp)
ffffffffc0202584:	f4a6                	sd	s1,104(sp)
ffffffffc0202586:	f0ca                	sd	s2,96(sp)
ffffffffc0202588:	ecce                	sd	s3,88(sp)
ffffffffc020258a:	e8d2                	sd	s4,80(sp)
ffffffffc020258c:	e4d6                	sd	s5,72(sp)
ffffffffc020258e:	e0da                	sd	s6,64(sp)
ffffffffc0202590:	fc5e                	sd	s7,56(sp)
ffffffffc0202592:	f862                	sd	s8,48(sp)
ffffffffc0202594:	f466                	sd	s9,40(sp)
ffffffffc0202596:	f06a                	sd	s10,32(sp)
ffffffffc0202598:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020259a:	17d2                	slli	a5,a5,0x34
ffffffffc020259c:	16079b63          	bnez	a5,ffffffffc0202712 <copy_range+0x198>
    assert(USER_ACCESS(start, end));
ffffffffc02025a0:	002007b7          	lui	a5,0x200
ffffffffc02025a4:	8432                	mv	s0,a2
ffffffffc02025a6:	12f66a63          	bltu	a2,a5,ffffffffc02026da <copy_range+0x160>
ffffffffc02025aa:	8936                	mv	s2,a3
ffffffffc02025ac:	12d67763          	bgeu	a2,a3,ffffffffc02026da <copy_range+0x160>
ffffffffc02025b0:	4785                	li	a5,1
ffffffffc02025b2:	07fe                	slli	a5,a5,0x1f
ffffffffc02025b4:	12d7e363          	bltu	a5,a3,ffffffffc02026da <copy_range+0x160>
ffffffffc02025b8:	8aaa                	mv	s5,a0
ffffffffc02025ba:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02025bc:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02025be:	00093c97          	auipc	s9,0x93
ffffffffc02025c2:	582c8c93          	addi	s9,s9,1410 # ffffffffc0295b40 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02025c6:	00093c17          	auipc	s8,0x93
ffffffffc02025ca:	582c0c13          	addi	s8,s8,1410 # ffffffffc0295b48 <pages>
ffffffffc02025ce:	fff80bb7          	lui	s7,0xfff80
        page = pmm_manager->alloc_pages(n);
ffffffffc02025d2:	00093b17          	auipc	s6,0x93
ffffffffc02025d6:	54eb0b13          	addi	s6,s6,1358 # ffffffffc0295b20 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02025da:	00200db7          	lui	s11,0x200
ffffffffc02025de:	ffe00d37          	lui	s10,0xffe00
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02025e2:	4601                	li	a2,0
ffffffffc02025e4:	85a2                	mv	a1,s0
ffffffffc02025e6:	854e                	mv	a0,s3
ffffffffc02025e8:	90dff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc02025ec:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02025ee:	c941                	beqz	a0,ffffffffc020267e <copy_range+0x104>
        if (*ptep & PTE_V)
ffffffffc02025f0:	611c                	ld	a5,0(a0)
ffffffffc02025f2:	8b85                	andi	a5,a5,1
ffffffffc02025f4:	e78d                	bnez	a5,ffffffffc020261e <copy_range+0xa4>
        start += PGSIZE;
ffffffffc02025f6:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02025f8:	c019                	beqz	s0,ffffffffc02025fe <copy_range+0x84>
ffffffffc02025fa:	ff2464e3          	bltu	s0,s2,ffffffffc02025e2 <copy_range+0x68>
    return 0;
ffffffffc02025fe:	4501                	li	a0,0
}
ffffffffc0202600:	70e6                	ld	ra,120(sp)
ffffffffc0202602:	7446                	ld	s0,112(sp)
ffffffffc0202604:	74a6                	ld	s1,104(sp)
ffffffffc0202606:	7906                	ld	s2,96(sp)
ffffffffc0202608:	69e6                	ld	s3,88(sp)
ffffffffc020260a:	6a46                	ld	s4,80(sp)
ffffffffc020260c:	6aa6                	ld	s5,72(sp)
ffffffffc020260e:	6b06                	ld	s6,64(sp)
ffffffffc0202610:	7be2                	ld	s7,56(sp)
ffffffffc0202612:	7c42                	ld	s8,48(sp)
ffffffffc0202614:	7ca2                	ld	s9,40(sp)
ffffffffc0202616:	7d02                	ld	s10,32(sp)
ffffffffc0202618:	6de2                	ld	s11,24(sp)
ffffffffc020261a:	6109                	addi	sp,sp,128
ffffffffc020261c:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020261e:	4605                	li	a2,1
ffffffffc0202620:	85a2                	mv	a1,s0
ffffffffc0202622:	8556                	mv	a0,s5
ffffffffc0202624:	8d1ff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc0202628:	c93d                	beqz	a0,ffffffffc020269e <copy_range+0x124>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020262a:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc020262c:	0017f713          	andi	a4,a5,1
ffffffffc0202630:	c769                	beqz	a4,ffffffffc02026fa <copy_range+0x180>
    if (PPN(pa) >= npage)
ffffffffc0202632:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202636:	078a                	slli	a5,a5,0x2
ffffffffc0202638:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020263a:	08e7f463          	bgeu	a5,a4,ffffffffc02026c2 <copy_range+0x148>
    return &pages[PPN(pa) - nbase];
ffffffffc020263e:	000c3483          	ld	s1,0(s8)
ffffffffc0202642:	97de                	add	a5,a5,s7
ffffffffc0202644:	079a                	slli	a5,a5,0x6
ffffffffc0202646:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202648:	100027f3          	csrr	a5,sstatus
ffffffffc020264c:	8b89                	andi	a5,a5,2
ffffffffc020264e:	ef85                	bnez	a5,ffffffffc0202686 <copy_range+0x10c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202650:	000b3783          	ld	a5,0(s6)
ffffffffc0202654:	4505                	li	a0,1
ffffffffc0202656:	6f9c                	ld	a5,24(a5)
ffffffffc0202658:	9782                	jalr	a5
            assert(page != NULL);
ffffffffc020265a:	c4a1                	beqz	s1,ffffffffc02026a2 <copy_range+0x128>
            assert(npage != NULL);
ffffffffc020265c:	fd49                	bnez	a0,ffffffffc02025f6 <copy_range+0x7c>
ffffffffc020265e:	00004697          	auipc	a3,0x4
ffffffffc0202662:	f6268693          	addi	a3,a3,-158 # ffffffffc02065c0 <etext+0xf10>
ffffffffc0202666:	00004617          	auipc	a2,0x4
ffffffffc020266a:	a2a60613          	addi	a2,a2,-1494 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020266e:	19500593          	li	a1,405
ffffffffc0202672:	00004517          	auipc	a0,0x4
ffffffffc0202676:	ee650513          	addi	a0,a0,-282 # ffffffffc0206558 <etext+0xea8>
ffffffffc020267a:	e0ffd0ef          	jal	ffffffffc0200488 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020267e:	946e                	add	s0,s0,s11
ffffffffc0202680:	01a47433          	and	s0,s0,s10
            continue;
ffffffffc0202684:	bf95                	j	ffffffffc02025f8 <copy_range+0x7e>
        intr_disable();
ffffffffc0202686:	af4fe0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020268a:	000b3783          	ld	a5,0(s6)
ffffffffc020268e:	4505                	li	a0,1
ffffffffc0202690:	6f9c                	ld	a5,24(a5)
ffffffffc0202692:	9782                	jalr	a5
ffffffffc0202694:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202696:	adefe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020269a:	6522                	ld	a0,8(sp)
ffffffffc020269c:	bf7d                	j	ffffffffc020265a <copy_range+0xe0>
                return -E_NO_MEM;
ffffffffc020269e:	5571                	li	a0,-4
ffffffffc02026a0:	b785                	j	ffffffffc0202600 <copy_range+0x86>
            assert(page != NULL);
ffffffffc02026a2:	00004697          	auipc	a3,0x4
ffffffffc02026a6:	f0e68693          	addi	a3,a3,-242 # ffffffffc02065b0 <etext+0xf00>
ffffffffc02026aa:	00004617          	auipc	a2,0x4
ffffffffc02026ae:	9e660613          	addi	a2,a2,-1562 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02026b2:	19400593          	li	a1,404
ffffffffc02026b6:	00004517          	auipc	a0,0x4
ffffffffc02026ba:	ea250513          	addi	a0,a0,-350 # ffffffffc0206558 <etext+0xea8>
ffffffffc02026be:	dcbfd0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02026c2:	00004617          	auipc	a2,0x4
ffffffffc02026c6:	e4e60613          	addi	a2,a2,-434 # ffffffffc0206510 <etext+0xe60>
ffffffffc02026ca:	06900593          	li	a1,105
ffffffffc02026ce:	00004517          	auipc	a0,0x4
ffffffffc02026d2:	d9a50513          	addi	a0,a0,-614 # ffffffffc0206468 <etext+0xdb8>
ffffffffc02026d6:	db3fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02026da:	00004697          	auipc	a3,0x4
ffffffffc02026de:	ebe68693          	addi	a3,a3,-322 # ffffffffc0206598 <etext+0xee8>
ffffffffc02026e2:	00004617          	auipc	a2,0x4
ffffffffc02026e6:	9ae60613          	addi	a2,a2,-1618 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02026ea:	17c00593          	li	a1,380
ffffffffc02026ee:	00004517          	auipc	a0,0x4
ffffffffc02026f2:	e6a50513          	addi	a0,a0,-406 # ffffffffc0206558 <etext+0xea8>
ffffffffc02026f6:	d93fd0ef          	jal	ffffffffc0200488 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02026fa:	00004617          	auipc	a2,0x4
ffffffffc02026fe:	e3660613          	addi	a2,a2,-458 # ffffffffc0206530 <etext+0xe80>
ffffffffc0202702:	07f00593          	li	a1,127
ffffffffc0202706:	00004517          	auipc	a0,0x4
ffffffffc020270a:	d6250513          	addi	a0,a0,-670 # ffffffffc0206468 <etext+0xdb8>
ffffffffc020270e:	d7bfd0ef          	jal	ffffffffc0200488 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202712:	00004697          	auipc	a3,0x4
ffffffffc0202716:	e5668693          	addi	a3,a3,-426 # ffffffffc0206568 <etext+0xeb8>
ffffffffc020271a:	00004617          	auipc	a2,0x4
ffffffffc020271e:	97660613          	addi	a2,a2,-1674 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0202722:	17b00593          	li	a1,379
ffffffffc0202726:	00004517          	auipc	a0,0x4
ffffffffc020272a:	e3250513          	addi	a0,a0,-462 # ffffffffc0206558 <etext+0xea8>
ffffffffc020272e:	d5bfd0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0202732 <page_remove>:
{
ffffffffc0202732:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202734:	4601                	li	a2,0
{
ffffffffc0202736:	ec26                	sd	s1,24(sp)
ffffffffc0202738:	f406                	sd	ra,40(sp)
ffffffffc020273a:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020273c:	fb8ff0ef          	jal	ffffffffc0201ef4 <get_pte>
    if (ptep != NULL)
ffffffffc0202740:	c901                	beqz	a0,ffffffffc0202750 <page_remove+0x1e>
    if (*ptep & PTE_V)
ffffffffc0202742:	611c                	ld	a5,0(a0)
ffffffffc0202744:	f022                	sd	s0,32(sp)
ffffffffc0202746:	842a                	mv	s0,a0
ffffffffc0202748:	0017f713          	andi	a4,a5,1
ffffffffc020274c:	e711                	bnez	a4,ffffffffc0202758 <page_remove+0x26>
ffffffffc020274e:	7402                	ld	s0,32(sp)
}
ffffffffc0202750:	70a2                	ld	ra,40(sp)
ffffffffc0202752:	64e2                	ld	s1,24(sp)
ffffffffc0202754:	6145                	addi	sp,sp,48
ffffffffc0202756:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202758:	078a                	slli	a5,a5,0x2
ffffffffc020275a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020275c:	00093717          	auipc	a4,0x93
ffffffffc0202760:	3e473703          	ld	a4,996(a4) # ffffffffc0295b40 <npage>
ffffffffc0202764:	06e7f363          	bgeu	a5,a4,ffffffffc02027ca <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202768:	fff80737          	lui	a4,0xfff80
ffffffffc020276c:	97ba                	add	a5,a5,a4
ffffffffc020276e:	079a                	slli	a5,a5,0x6
ffffffffc0202770:	00093517          	auipc	a0,0x93
ffffffffc0202774:	3d853503          	ld	a0,984(a0) # ffffffffc0295b48 <pages>
ffffffffc0202778:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020277a:	411c                	lw	a5,0(a0)
ffffffffc020277c:	fff7871b          	addiw	a4,a5,-1 # 1fffff <_binary_obj___user_exit_out_size+0x1f6497>
ffffffffc0202780:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202782:	cb11                	beqz	a4,ffffffffc0202796 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202784:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202788:	12048073          	sfence.vma	s1
ffffffffc020278c:	7402                	ld	s0,32(sp)
}
ffffffffc020278e:	70a2                	ld	ra,40(sp)
ffffffffc0202790:	64e2                	ld	s1,24(sp)
ffffffffc0202792:	6145                	addi	sp,sp,48
ffffffffc0202794:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202796:	100027f3          	csrr	a5,sstatus
ffffffffc020279a:	8b89                	andi	a5,a5,2
ffffffffc020279c:	eb89                	bnez	a5,ffffffffc02027ae <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020279e:	00093797          	auipc	a5,0x93
ffffffffc02027a2:	3827b783          	ld	a5,898(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02027a6:	739c                	ld	a5,32(a5)
ffffffffc02027a8:	4585                	li	a1,1
ffffffffc02027aa:	9782                	jalr	a5
    if (flag)
ffffffffc02027ac:	bfe1                	j	ffffffffc0202784 <page_remove+0x52>
        intr_disable();
ffffffffc02027ae:	e42a                	sd	a0,8(sp)
ffffffffc02027b0:	9cafe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02027b4:	00093797          	auipc	a5,0x93
ffffffffc02027b8:	36c7b783          	ld	a5,876(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02027bc:	739c                	ld	a5,32(a5)
ffffffffc02027be:	6522                	ld	a0,8(sp)
ffffffffc02027c0:	4585                	li	a1,1
ffffffffc02027c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02027c4:	9b0fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02027c8:	bf75                	j	ffffffffc0202784 <page_remove+0x52>
ffffffffc02027ca:	e3aff0ef          	jal	ffffffffc0201e04 <pa2page.part.0>

ffffffffc02027ce <page_insert>:
{
ffffffffc02027ce:	7139                	addi	sp,sp,-64
ffffffffc02027d0:	e852                	sd	s4,16(sp)
ffffffffc02027d2:	8a32                	mv	s4,a2
ffffffffc02027d4:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02027d6:	4605                	li	a2,1
{
ffffffffc02027d8:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02027da:	85d2                	mv	a1,s4
{
ffffffffc02027dc:	f426                	sd	s1,40(sp)
ffffffffc02027de:	fc06                	sd	ra,56(sp)
ffffffffc02027e0:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02027e2:	f12ff0ef          	jal	ffffffffc0201ef4 <get_pte>
    if (ptep == NULL)
ffffffffc02027e6:	c971                	beqz	a0,ffffffffc02028ba <page_insert+0xec>
    page->ref += 1;
ffffffffc02027e8:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02027ea:	611c                	ld	a5,0(a0)
ffffffffc02027ec:	ec4e                	sd	s3,24(sp)
ffffffffc02027ee:	0016871b          	addiw	a4,a3,1
ffffffffc02027f2:	c018                	sw	a4,0(s0)
ffffffffc02027f4:	0017f713          	andi	a4,a5,1
ffffffffc02027f8:	89aa                	mv	s3,a0
ffffffffc02027fa:	eb15                	bnez	a4,ffffffffc020282e <page_insert+0x60>
    return &pages[PPN(pa) - nbase];
ffffffffc02027fc:	00093717          	auipc	a4,0x93
ffffffffc0202800:	34c73703          	ld	a4,844(a4) # ffffffffc0295b48 <pages>
    return page - pages + nbase;
ffffffffc0202804:	8c19                	sub	s0,s0,a4
ffffffffc0202806:	000807b7          	lui	a5,0x80
ffffffffc020280a:	8419                	srai	s0,s0,0x6
ffffffffc020280c:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020280e:	042a                	slli	s0,s0,0xa
ffffffffc0202810:	8cc1                	or	s1,s1,s0
ffffffffc0202812:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202816:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020281a:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc020281e:	69e2                	ld	s3,24(sp)
ffffffffc0202820:	4501                	li	a0,0
}
ffffffffc0202822:	70e2                	ld	ra,56(sp)
ffffffffc0202824:	7442                	ld	s0,48(sp)
ffffffffc0202826:	74a2                	ld	s1,40(sp)
ffffffffc0202828:	6a42                	ld	s4,16(sp)
ffffffffc020282a:	6121                	addi	sp,sp,64
ffffffffc020282c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020282e:	078a                	slli	a5,a5,0x2
ffffffffc0202830:	f04a                	sd	s2,32(sp)
ffffffffc0202832:	e456                	sd	s5,8(sp)
ffffffffc0202834:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202836:	00093717          	auipc	a4,0x93
ffffffffc020283a:	30a73703          	ld	a4,778(a4) # ffffffffc0295b40 <npage>
ffffffffc020283e:	08e7f063          	bgeu	a5,a4,ffffffffc02028be <page_insert+0xf0>
    return &pages[PPN(pa) - nbase];
ffffffffc0202842:	00093a97          	auipc	s5,0x93
ffffffffc0202846:	306a8a93          	addi	s5,s5,774 # ffffffffc0295b48 <pages>
ffffffffc020284a:	000ab703          	ld	a4,0(s5)
ffffffffc020284e:	fff80637          	lui	a2,0xfff80
ffffffffc0202852:	00c78933          	add	s2,a5,a2
ffffffffc0202856:	091a                	slli	s2,s2,0x6
ffffffffc0202858:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020285a:	01240e63          	beq	s0,s2,ffffffffc0202876 <page_insert+0xa8>
    page->ref -= 1;
ffffffffc020285e:	00092783          	lw	a5,0(s2)
ffffffffc0202862:	fff7869b          	addiw	a3,a5,-1 # 7ffff <_binary_obj___user_exit_out_size+0x76497>
ffffffffc0202866:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020286a:	ca91                	beqz	a3,ffffffffc020287e <page_insert+0xb0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020286c:	120a0073          	sfence.vma	s4
ffffffffc0202870:	7902                	ld	s2,32(sp)
ffffffffc0202872:	6aa2                	ld	s5,8(sp)
}
ffffffffc0202874:	bf41                	j	ffffffffc0202804 <page_insert+0x36>
    return page->ref;
ffffffffc0202876:	7902                	ld	s2,32(sp)
ffffffffc0202878:	6aa2                	ld	s5,8(sp)
    page->ref -= 1;
ffffffffc020287a:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020287c:	b761                	j	ffffffffc0202804 <page_insert+0x36>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020287e:	100027f3          	csrr	a5,sstatus
ffffffffc0202882:	8b89                	andi	a5,a5,2
ffffffffc0202884:	ef81                	bnez	a5,ffffffffc020289c <page_insert+0xce>
        pmm_manager->free_pages(base, n);
ffffffffc0202886:	00093797          	auipc	a5,0x93
ffffffffc020288a:	29a7b783          	ld	a5,666(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc020288e:	739c                	ld	a5,32(a5)
ffffffffc0202890:	4585                	li	a1,1
ffffffffc0202892:	854a                	mv	a0,s2
ffffffffc0202894:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202896:	000ab703          	ld	a4,0(s5)
ffffffffc020289a:	bfc9                	j	ffffffffc020286c <page_insert+0x9e>
        intr_disable();
ffffffffc020289c:	8defe0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02028a0:	00093797          	auipc	a5,0x93
ffffffffc02028a4:	2807b783          	ld	a5,640(a5) # ffffffffc0295b20 <pmm_manager>
ffffffffc02028a8:	739c                	ld	a5,32(a5)
ffffffffc02028aa:	4585                	li	a1,1
ffffffffc02028ac:	854a                	mv	a0,s2
ffffffffc02028ae:	9782                	jalr	a5
        intr_enable();
ffffffffc02028b0:	8c4fe0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02028b4:	000ab703          	ld	a4,0(s5)
ffffffffc02028b8:	bf55                	j	ffffffffc020286c <page_insert+0x9e>
        return -E_NO_MEM;
ffffffffc02028ba:	5571                	li	a0,-4
ffffffffc02028bc:	b79d                	j	ffffffffc0202822 <page_insert+0x54>
ffffffffc02028be:	d46ff0ef          	jal	ffffffffc0201e04 <pa2page.part.0>

ffffffffc02028c2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02028c2:	00005797          	auipc	a5,0x5
ffffffffc02028c6:	bee78793          	addi	a5,a5,-1042 # ffffffffc02074b0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02028ca:	638c                	ld	a1,0(a5)
{
ffffffffc02028cc:	7159                	addi	sp,sp,-112
ffffffffc02028ce:	f486                	sd	ra,104(sp)
ffffffffc02028d0:	e8ca                	sd	s2,80(sp)
ffffffffc02028d2:	e4ce                	sd	s3,72(sp)
ffffffffc02028d4:	f85a                	sd	s6,48(sp)
ffffffffc02028d6:	f0a2                	sd	s0,96(sp)
ffffffffc02028d8:	eca6                	sd	s1,88(sp)
ffffffffc02028da:	e0d2                	sd	s4,64(sp)
ffffffffc02028dc:	fc56                	sd	s5,56(sp)
ffffffffc02028de:	f45e                	sd	s7,40(sp)
ffffffffc02028e0:	f062                	sd	s8,32(sp)
ffffffffc02028e2:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02028e4:	00093b17          	auipc	s6,0x93
ffffffffc02028e8:	23cb0b13          	addi	s6,s6,572 # ffffffffc0295b20 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02028ec:	00004517          	auipc	a0,0x4
ffffffffc02028f0:	ce450513          	addi	a0,a0,-796 # ffffffffc02065d0 <etext+0xf20>
    pmm_manager = &default_pmm_manager;
ffffffffc02028f4:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02028f8:	89dfd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02028fc:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202900:	00093997          	auipc	s3,0x93
ffffffffc0202904:	23898993          	addi	s3,s3,568 # ffffffffc0295b38 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202908:	679c                	ld	a5,8(a5)
ffffffffc020290a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020290c:	57f5                	li	a5,-3
ffffffffc020290e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202910:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202914:	84cfe0ef          	jal	ffffffffc0200960 <get_memory_base>
ffffffffc0202918:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020291a:	850fe0ef          	jal	ffffffffc020096a <get_memory_size>
    if (mem_size == 0)
ffffffffc020291e:	20050be3          	beqz	a0,ffffffffc0203334 <pmm_init+0xa72>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202922:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202924:	00004517          	auipc	a0,0x4
ffffffffc0202928:	ce450513          	addi	a0,a0,-796 # ffffffffc0206608 <etext+0xf58>
ffffffffc020292c:	869fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202930:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202934:	864a                	mv	a2,s2
ffffffffc0202936:	fff40693          	addi	a3,s0,-1
ffffffffc020293a:	85a6                	mv	a1,s1
ffffffffc020293c:	00004517          	auipc	a0,0x4
ffffffffc0202940:	ce450513          	addi	a0,a0,-796 # ffffffffc0206620 <etext+0xf70>
ffffffffc0202944:	851fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc0202948:	c80007b7          	lui	a5,0xc8000
ffffffffc020294c:	8622                	mv	a2,s0
ffffffffc020294e:	5487e763          	bltu	a5,s0,ffffffffc0202e9c <pmm_init+0x5da>
ffffffffc0202952:	77fd                	lui	a5,0xfffff
ffffffffc0202954:	00094697          	auipc	a3,0x94
ffffffffc0202958:	21b68693          	addi	a3,a3,539 # ffffffffc0296b6f <end+0xfff>
ffffffffc020295c:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc020295e:	8231                	srli	a2,a2,0xc
ffffffffc0202960:	00093497          	auipc	s1,0x93
ffffffffc0202964:	1e048493          	addi	s1,s1,480 # ffffffffc0295b40 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202968:	00093b97          	auipc	s7,0x93
ffffffffc020296c:	1e0b8b93          	addi	s7,s7,480 # ffffffffc0295b48 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202970:	e090                	sd	a2,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202972:	00dbb023          	sd	a3,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202976:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020297a:	8736                	mv	a4,a3
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020297c:	04f60163          	beq	a2,a5,ffffffffc02029be <pmm_init+0xfc>
ffffffffc0202980:	4705                	li	a4,1
ffffffffc0202982:	06a1                	addi	a3,a3,8
ffffffffc0202984:	40e6b02f          	amoor.d	zero,a4,(a3)
ffffffffc0202988:	6090                	ld	a2,0(s1)
ffffffffc020298a:	4505                	li	a0,1
ffffffffc020298c:	fff805b7          	lui	a1,0xfff80
ffffffffc0202990:	40f607b3          	sub	a5,a2,a5
ffffffffc0202994:	02f77063          	bgeu	a4,a5,ffffffffc02029b4 <pmm_init+0xf2>
        SetPageReserved(pages + i);
ffffffffc0202998:	000bb783          	ld	a5,0(s7)
ffffffffc020299c:	00671693          	slli	a3,a4,0x6
ffffffffc02029a0:	97b6                	add	a5,a5,a3
ffffffffc02029a2:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x764a0>
ffffffffc02029a4:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02029a8:	6090                	ld	a2,0(s1)
ffffffffc02029aa:	0705                	addi	a4,a4,1
ffffffffc02029ac:	00b607b3          	add	a5,a2,a1
ffffffffc02029b0:	fef764e3          	bltu	a4,a5,ffffffffc0202998 <pmm_init+0xd6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02029b4:	000bb703          	ld	a4,0(s7)
ffffffffc02029b8:	079a                	slli	a5,a5,0x6
ffffffffc02029ba:	00f706b3          	add	a3,a4,a5
ffffffffc02029be:	c02007b7          	lui	a5,0xc0200
ffffffffc02029c2:	2ef6eae3          	bltu	a3,a5,ffffffffc02034b6 <pmm_init+0xbf4>
ffffffffc02029c6:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02029ca:	77fd                	lui	a5,0xfffff
ffffffffc02029cc:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02029ce:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02029d0:	5086e963          	bltu	a3,s0,ffffffffc0202ee2 <pmm_init+0x620>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02029d4:	00004517          	auipc	a0,0x4
ffffffffc02029d8:	c7450513          	addi	a0,a0,-908 # ffffffffc0206648 <etext+0xf98>
ffffffffc02029dc:	fb8fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02029e0:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02029e4:	00093917          	auipc	s2,0x93
ffffffffc02029e8:	14c90913          	addi	s2,s2,332 # ffffffffc0295b30 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02029ec:	7b9c                	ld	a5,48(a5)
ffffffffc02029ee:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02029f0:	00004517          	auipc	a0,0x4
ffffffffc02029f4:	c7050513          	addi	a0,a0,-912 # ffffffffc0206660 <etext+0xfb0>
ffffffffc02029f8:	f9cfd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02029fc:	00007697          	auipc	a3,0x7
ffffffffc0202a00:	60468693          	addi	a3,a3,1540 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202a04:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202a08:	c02007b7          	lui	a5,0xc0200
ffffffffc0202a0c:	28f6e9e3          	bltu	a3,a5,ffffffffc020349e <pmm_init+0xbdc>
ffffffffc0202a10:	0009b783          	ld	a5,0(s3)
ffffffffc0202a14:	8e9d                	sub	a3,a3,a5
ffffffffc0202a16:	00093797          	auipc	a5,0x93
ffffffffc0202a1a:	10d7b923          	sd	a3,274(a5) # ffffffffc0295b28 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202a1e:	100027f3          	csrr	a5,sstatus
ffffffffc0202a22:	8b89                	andi	a5,a5,2
ffffffffc0202a24:	4a079563          	bnez	a5,ffffffffc0202ece <pmm_init+0x60c>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a28:	000b3783          	ld	a5,0(s6)
ffffffffc0202a2c:	779c                	ld	a5,40(a5)
ffffffffc0202a2e:	9782                	jalr	a5
ffffffffc0202a30:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202a32:	6098                	ld	a4,0(s1)
ffffffffc0202a34:	c80007b7          	lui	a5,0xc8000
ffffffffc0202a38:	83b1                	srli	a5,a5,0xc
ffffffffc0202a3a:	66e7e163          	bltu	a5,a4,ffffffffc020309c <pmm_init+0x7da>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202a3e:	00093503          	ld	a0,0(s2)
ffffffffc0202a42:	62050d63          	beqz	a0,ffffffffc020307c <pmm_init+0x7ba>
ffffffffc0202a46:	03451793          	slli	a5,a0,0x34
ffffffffc0202a4a:	62079963          	bnez	a5,ffffffffc020307c <pmm_init+0x7ba>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202a4e:	4601                	li	a2,0
ffffffffc0202a50:	4581                	li	a1,0
ffffffffc0202a52:	ed0ff0ef          	jal	ffffffffc0202122 <get_page>
ffffffffc0202a56:	60051363          	bnez	a0,ffffffffc020305c <pmm_init+0x79a>
ffffffffc0202a5a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a5e:	8b89                	andi	a5,a5,2
ffffffffc0202a60:	44079c63          	bnez	a5,ffffffffc0202eb8 <pmm_init+0x5f6>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a64:	000b3783          	ld	a5,0(s6)
ffffffffc0202a68:	4505                	li	a0,1
ffffffffc0202a6a:	6f9c                	ld	a5,24(a5)
ffffffffc0202a6c:	9782                	jalr	a5
ffffffffc0202a6e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202a70:	00093503          	ld	a0,0(s2)
ffffffffc0202a74:	4681                	li	a3,0
ffffffffc0202a76:	4601                	li	a2,0
ffffffffc0202a78:	85d2                	mv	a1,s4
ffffffffc0202a7a:	d55ff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc0202a7e:	260518e3          	bnez	a0,ffffffffc02034ee <pmm_init+0xc2c>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202a82:	00093503          	ld	a0,0(s2)
ffffffffc0202a86:	4601                	li	a2,0
ffffffffc0202a88:	4581                	li	a1,0
ffffffffc0202a8a:	c6aff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc0202a8e:	240500e3          	beqz	a0,ffffffffc02034ce <pmm_init+0xc0c>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a92:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a94:	0017f713          	andi	a4,a5,1
ffffffffc0202a98:	5a070063          	beqz	a4,ffffffffc0203038 <pmm_init+0x776>
    if (PPN(pa) >= npage)
ffffffffc0202a9c:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a9e:	078a                	slli	a5,a5,0x2
ffffffffc0202aa0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aa2:	58e7f963          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aa6:	000bb683          	ld	a3,0(s7)
ffffffffc0202aaa:	fff80637          	lui	a2,0xfff80
ffffffffc0202aae:	97b2                	add	a5,a5,a2
ffffffffc0202ab0:	079a                	slli	a5,a5,0x6
ffffffffc0202ab2:	97b6                	add	a5,a5,a3
ffffffffc0202ab4:	14fa15e3          	bne	s4,a5,ffffffffc02033fe <pmm_init+0xb3c>
    assert(page_ref(p1) == 1);
ffffffffc0202ab8:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x75f8>
ffffffffc0202abc:	4785                	li	a5,1
ffffffffc0202abe:	12f690e3          	bne	a3,a5,ffffffffc02033de <pmm_init+0xb1c>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202ac2:	00093503          	ld	a0,0(s2)
ffffffffc0202ac6:	77fd                	lui	a5,0xfffff
ffffffffc0202ac8:	6114                	ld	a3,0(a0)
ffffffffc0202aca:	068a                	slli	a3,a3,0x2
ffffffffc0202acc:	8efd                	and	a3,a3,a5
ffffffffc0202ace:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202ad2:	0ee67ae3          	bgeu	a2,a4,ffffffffc02033c6 <pmm_init+0xb04>
ffffffffc0202ad6:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202ada:	96e2                	add	a3,a3,s8
ffffffffc0202adc:	0006ba83          	ld	s5,0(a3)
ffffffffc0202ae0:	0a8a                	slli	s5,s5,0x2
ffffffffc0202ae2:	00fafab3          	and	s5,s5,a5
ffffffffc0202ae6:	00cad793          	srli	a5,s5,0xc
ffffffffc0202aea:	0ce7f1e3          	bgeu	a5,a4,ffffffffc02033ac <pmm_init+0xaea>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202aee:	4601                	li	a2,0
ffffffffc0202af0:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202af2:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202af4:	c00ff0ef          	jal	ffffffffc0201ef4 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202af8:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202afa:	55851163          	bne	a0,s8,ffffffffc020303c <pmm_init+0x77a>
ffffffffc0202afe:	100027f3          	csrr	a5,sstatus
ffffffffc0202b02:	8b89                	andi	a5,a5,2
ffffffffc0202b04:	38079f63          	bnez	a5,ffffffffc0202ea2 <pmm_init+0x5e0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b08:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0c:	4505                	li	a0,1
ffffffffc0202b0e:	6f9c                	ld	a5,24(a5)
ffffffffc0202b10:	9782                	jalr	a5
ffffffffc0202b12:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202b14:	00093503          	ld	a0,0(s2)
ffffffffc0202b18:	46d1                	li	a3,20
ffffffffc0202b1a:	6605                	lui	a2,0x1
ffffffffc0202b1c:	85e2                	mv	a1,s8
ffffffffc0202b1e:	cb1ff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc0202b22:	060515e3          	bnez	a0,ffffffffc020338c <pmm_init+0xaca>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b26:	00093503          	ld	a0,0(s2)
ffffffffc0202b2a:	4601                	li	a2,0
ffffffffc0202b2c:	6585                	lui	a1,0x1
ffffffffc0202b2e:	bc6ff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc0202b32:	02050de3          	beqz	a0,ffffffffc020336c <pmm_init+0xaaa>
    assert(*ptep & PTE_U);
ffffffffc0202b36:	611c                	ld	a5,0(a0)
ffffffffc0202b38:	0107f713          	andi	a4,a5,16
ffffffffc0202b3c:	7c070c63          	beqz	a4,ffffffffc0203314 <pmm_init+0xa52>
    assert(*ptep & PTE_W);
ffffffffc0202b40:	8b91                	andi	a5,a5,4
ffffffffc0202b42:	7a078963          	beqz	a5,ffffffffc02032f4 <pmm_init+0xa32>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b46:	00093503          	ld	a0,0(s2)
ffffffffc0202b4a:	611c                	ld	a5,0(a0)
ffffffffc0202b4c:	8bc1                	andi	a5,a5,16
ffffffffc0202b4e:	78078363          	beqz	a5,ffffffffc02032d4 <pmm_init+0xa12>
    assert(page_ref(p2) == 1);
ffffffffc0202b52:	000c2703          	lw	a4,0(s8)
ffffffffc0202b56:	4785                	li	a5,1
ffffffffc0202b58:	74f71e63          	bne	a4,a5,ffffffffc02032b4 <pmm_init+0x9f2>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202b5c:	4681                	li	a3,0
ffffffffc0202b5e:	6605                	lui	a2,0x1
ffffffffc0202b60:	85d2                	mv	a1,s4
ffffffffc0202b62:	c6dff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc0202b66:	72051763          	bnez	a0,ffffffffc0203294 <pmm_init+0x9d2>
    assert(page_ref(p1) == 2);
ffffffffc0202b6a:	000a2703          	lw	a4,0(s4)
ffffffffc0202b6e:	4789                	li	a5,2
ffffffffc0202b70:	70f71263          	bne	a4,a5,ffffffffc0203274 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc0202b74:	000c2783          	lw	a5,0(s8)
ffffffffc0202b78:	6c079e63          	bnez	a5,ffffffffc0203254 <pmm_init+0x992>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b7c:	00093503          	ld	a0,0(s2)
ffffffffc0202b80:	4601                	li	a2,0
ffffffffc0202b82:	6585                	lui	a1,0x1
ffffffffc0202b84:	b70ff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc0202b88:	6a050663          	beqz	a0,ffffffffc0203234 <pmm_init+0x972>
    assert(pte2page(*ptep) == p1);
ffffffffc0202b8c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202b8e:	00177793          	andi	a5,a4,1
ffffffffc0202b92:	4a078363          	beqz	a5,ffffffffc0203038 <pmm_init+0x776>
    if (PPN(pa) >= npage)
ffffffffc0202b96:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202b98:	00271793          	slli	a5,a4,0x2
ffffffffc0202b9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b9e:	48d7fb63          	bgeu	a5,a3,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ba2:	000bb683          	ld	a3,0(s7)
ffffffffc0202ba6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202baa:	97d6                	add	a5,a5,s5
ffffffffc0202bac:	079a                	slli	a5,a5,0x6
ffffffffc0202bae:	97b6                	add	a5,a5,a3
ffffffffc0202bb0:	66fa1263          	bne	s4,a5,ffffffffc0203214 <pmm_init+0x952>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202bb4:	8b41                	andi	a4,a4,16
ffffffffc0202bb6:	62071f63          	bnez	a4,ffffffffc02031f4 <pmm_init+0x932>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202bba:	00093503          	ld	a0,0(s2)
ffffffffc0202bbe:	4581                	li	a1,0
ffffffffc0202bc0:	b73ff0ef          	jal	ffffffffc0202732 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202bc4:	000a2c83          	lw	s9,0(s4)
ffffffffc0202bc8:	4785                	li	a5,1
ffffffffc0202bca:	60fc9563          	bne	s9,a5,ffffffffc02031d4 <pmm_init+0x912>
    assert(page_ref(p2) == 0);
ffffffffc0202bce:	000c2783          	lw	a5,0(s8)
ffffffffc0202bd2:	5e079163          	bnez	a5,ffffffffc02031b4 <pmm_init+0x8f2>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202bd6:	00093503          	ld	a0,0(s2)
ffffffffc0202bda:	6585                	lui	a1,0x1
ffffffffc0202bdc:	b57ff0ef          	jal	ffffffffc0202732 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202be0:	000a2783          	lw	a5,0(s4)
ffffffffc0202be4:	52079863          	bnez	a5,ffffffffc0203114 <pmm_init+0x852>
    assert(page_ref(p2) == 0);
ffffffffc0202be8:	000c2783          	lw	a5,0(s8)
ffffffffc0202bec:	50079463          	bnez	a5,ffffffffc02030f4 <pmm_init+0x832>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202bf0:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202bf4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bf6:	000a3783          	ld	a5,0(s4)
ffffffffc0202bfa:	078a                	slli	a5,a5,0x2
ffffffffc0202bfc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bfe:	42e7fb63          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c02:	000bb503          	ld	a0,0(s7)
ffffffffc0202c06:	97d6                	add	a5,a5,s5
ffffffffc0202c08:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202c0a:	00f506b3          	add	a3,a0,a5
ffffffffc0202c0e:	4294                	lw	a3,0(a3)
ffffffffc0202c10:	4d969263          	bne	a3,s9,ffffffffc02030d4 <pmm_init+0x812>
    return page - pages + nbase;
ffffffffc0202c14:	8799                	srai	a5,a5,0x6
ffffffffc0202c16:	00080637          	lui	a2,0x80
ffffffffc0202c1a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c1c:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202c20:	48e7fe63          	bgeu	a5,a4,ffffffffc02030bc <pmm_init+0x7fa>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202c24:	0009b783          	ld	a5,0(s3)
ffffffffc0202c28:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c2a:	639c                	ld	a5,0(a5)
ffffffffc0202c2c:	078a                	slli	a5,a5,0x2
ffffffffc0202c2e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c30:	40e7f263          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c34:	8f91                	sub	a5,a5,a2
ffffffffc0202c36:	079a                	slli	a5,a5,0x6
ffffffffc0202c38:	953e                	add	a0,a0,a5
ffffffffc0202c3a:	100027f3          	csrr	a5,sstatus
ffffffffc0202c3e:	8b89                	andi	a5,a5,2
ffffffffc0202c40:	30079963          	bnez	a5,ffffffffc0202f52 <pmm_init+0x690>
        pmm_manager->free_pages(base, n);
ffffffffc0202c44:	000b3783          	ld	a5,0(s6)
ffffffffc0202c48:	4585                	li	a1,1
ffffffffc0202c4a:	739c                	ld	a5,32(a5)
ffffffffc0202c4c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c4e:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202c52:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c54:	078a                	slli	a5,a5,0x2
ffffffffc0202c56:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c58:	3ce7fe63          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c5c:	000bb503          	ld	a0,0(s7)
ffffffffc0202c60:	fff80737          	lui	a4,0xfff80
ffffffffc0202c64:	97ba                	add	a5,a5,a4
ffffffffc0202c66:	079a                	slli	a5,a5,0x6
ffffffffc0202c68:	953e                	add	a0,a0,a5
ffffffffc0202c6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202c6e:	8b89                	andi	a5,a5,2
ffffffffc0202c70:	2c079563          	bnez	a5,ffffffffc0202f3a <pmm_init+0x678>
ffffffffc0202c74:	000b3783          	ld	a5,0(s6)
ffffffffc0202c78:	4585                	li	a1,1
ffffffffc0202c7a:	739c                	ld	a5,32(a5)
ffffffffc0202c7c:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202c7e:	00093783          	ld	a5,0(s2)
ffffffffc0202c82:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd69490>
    asm volatile("sfence.vma");
ffffffffc0202c86:	12000073          	sfence.vma
ffffffffc0202c8a:	100027f3          	csrr	a5,sstatus
ffffffffc0202c8e:	8b89                	andi	a5,a5,2
ffffffffc0202c90:	28079b63          	bnez	a5,ffffffffc0202f26 <pmm_init+0x664>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c94:	000b3783          	ld	a5,0(s6)
ffffffffc0202c98:	779c                	ld	a5,40(a5)
ffffffffc0202c9a:	9782                	jalr	a5
ffffffffc0202c9c:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202c9e:	4b441b63          	bne	s0,s4,ffffffffc0203154 <pmm_init+0x892>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202ca2:	00004517          	auipc	a0,0x4
ffffffffc0202ca6:	ce650513          	addi	a0,a0,-794 # ffffffffc0206988 <etext+0x12d8>
ffffffffc0202caa:	ceafd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202cae:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb2:	8b89                	andi	a5,a5,2
ffffffffc0202cb4:	24079f63          	bnez	a5,ffffffffc0202f12 <pmm_init+0x650>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cb8:	000b3783          	ld	a5,0(s6)
ffffffffc0202cbc:	779c                	ld	a5,40(a5)
ffffffffc0202cbe:	9782                	jalr	a5
ffffffffc0202cc0:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202cc2:	6098                	ld	a4,0(s1)
ffffffffc0202cc4:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202cc8:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202cca:	00c71793          	slli	a5,a4,0xc
ffffffffc0202cce:	6a05                	lui	s4,0x1
ffffffffc0202cd0:	02f47c63          	bgeu	s0,a5,ffffffffc0202d08 <pmm_init+0x446>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202cd4:	00c45793          	srli	a5,s0,0xc
ffffffffc0202cd8:	00093503          	ld	a0,0(s2)
ffffffffc0202cdc:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202fda <pmm_init+0x718>
ffffffffc0202ce0:	0009b583          	ld	a1,0(s3)
ffffffffc0202ce4:	4601                	li	a2,0
ffffffffc0202ce6:	95a2                	add	a1,a1,s0
ffffffffc0202ce8:	a0cff0ef          	jal	ffffffffc0201ef4 <get_pte>
ffffffffc0202cec:	32050463          	beqz	a0,ffffffffc0203014 <pmm_init+0x752>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202cf0:	611c                	ld	a5,0(a0)
ffffffffc0202cf2:	078a                	slli	a5,a5,0x2
ffffffffc0202cf4:	0157f7b3          	and	a5,a5,s5
ffffffffc0202cf8:	2e879e63          	bne	a5,s0,ffffffffc0202ff4 <pmm_init+0x732>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202cfc:	6098                	ld	a4,0(s1)
ffffffffc0202cfe:	9452                	add	s0,s0,s4
ffffffffc0202d00:	00c71793          	slli	a5,a4,0xc
ffffffffc0202d04:	fcf468e3          	bltu	s0,a5,ffffffffc0202cd4 <pmm_init+0x412>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202d08:	00093783          	ld	a5,0(s2)
ffffffffc0202d0c:	639c                	ld	a5,0(a5)
ffffffffc0202d0e:	42079363          	bnez	a5,ffffffffc0203134 <pmm_init+0x872>
ffffffffc0202d12:	100027f3          	csrr	a5,sstatus
ffffffffc0202d16:	8b89                	andi	a5,a5,2
ffffffffc0202d18:	24079963          	bnez	a5,ffffffffc0202f6a <pmm_init+0x6a8>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d1c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d20:	4505                	li	a0,1
ffffffffc0202d22:	6f9c                	ld	a5,24(a5)
ffffffffc0202d24:	9782                	jalr	a5
ffffffffc0202d26:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202d28:	00093503          	ld	a0,0(s2)
ffffffffc0202d2c:	4699                	li	a3,6
ffffffffc0202d2e:	10000613          	li	a2,256
ffffffffc0202d32:	85a2                	mv	a1,s0
ffffffffc0202d34:	a9bff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc0202d38:	44051e63          	bnez	a0,ffffffffc0203194 <pmm_init+0x8d2>
    assert(page_ref(p) == 1);
ffffffffc0202d3c:	4018                	lw	a4,0(s0)
ffffffffc0202d3e:	4785                	li	a5,1
ffffffffc0202d40:	42f71a63          	bne	a4,a5,ffffffffc0203174 <pmm_init+0x8b2>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d44:	00093503          	ld	a0,0(s2)
ffffffffc0202d48:	6605                	lui	a2,0x1
ffffffffc0202d4a:	4699                	li	a3,6
ffffffffc0202d4c:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x74f8>
ffffffffc0202d50:	85a2                	mv	a1,s0
ffffffffc0202d52:	a7dff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc0202d56:	72051463          	bnez	a0,ffffffffc020347e <pmm_init+0xbbc>
    assert(page_ref(p) == 2);
ffffffffc0202d5a:	4018                	lw	a4,0(s0)
ffffffffc0202d5c:	4789                	li	a5,2
ffffffffc0202d5e:	70f71063          	bne	a4,a5,ffffffffc020345e <pmm_init+0xb9c>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202d62:	00004597          	auipc	a1,0x4
ffffffffc0202d66:	d6e58593          	addi	a1,a1,-658 # ffffffffc0206ad0 <etext+0x1420>
ffffffffc0202d6a:	10000513          	li	a0,256
ffffffffc0202d6e:	091020ef          	jal	ffffffffc02055fe <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202d72:	6585                	lui	a1,0x1
ffffffffc0202d74:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x74f8>
ffffffffc0202d78:	10000513          	li	a0,256
ffffffffc0202d7c:	095020ef          	jal	ffffffffc0205610 <strcmp>
ffffffffc0202d80:	6a051f63          	bnez	a0,ffffffffc020343e <pmm_init+0xb7c>
    return page - pages + nbase;
ffffffffc0202d84:	000bb683          	ld	a3,0(s7)
ffffffffc0202d88:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202d8c:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202d8e:	40d406b3          	sub	a3,s0,a3
ffffffffc0202d92:	8699                	srai	a3,a3,0x6
ffffffffc0202d94:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202d96:	00c69793          	slli	a5,a3,0xc
ffffffffc0202d9a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d9c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202d9e:	30e7ff63          	bgeu	a5,a4,ffffffffc02030bc <pmm_init+0x7fa>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202da2:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202da6:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202daa:	97b6                	add	a5,a5,a3
ffffffffc0202dac:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x76598>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202db0:	019020ef          	jal	ffffffffc02055c8 <strlen>
ffffffffc0202db4:	66051563          	bnez	a0,ffffffffc020341e <pmm_init+0xb5c>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202db8:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202dbc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202dbe:	000a3783          	ld	a5,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x75f8>
ffffffffc0202dc2:	078a                	slli	a5,a5,0x2
ffffffffc0202dc4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dc6:	26e7f763          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202dca:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202dce:	2ee7f763          	bgeu	a5,a4,ffffffffc02030bc <pmm_init+0x7fa>
ffffffffc0202dd2:	0009b783          	ld	a5,0(s3)
ffffffffc0202dd6:	00f689b3          	add	s3,a3,a5
ffffffffc0202dda:	100027f3          	csrr	a5,sstatus
ffffffffc0202dde:	8b89                	andi	a5,a5,2
ffffffffc0202de0:	1e079263          	bnez	a5,ffffffffc0202fc4 <pmm_init+0x702>
        pmm_manager->free_pages(base, n);
ffffffffc0202de4:	000b3783          	ld	a5,0(s6)
ffffffffc0202de8:	4585                	li	a1,1
ffffffffc0202dea:	8522                	mv	a0,s0
ffffffffc0202dec:	739c                	ld	a5,32(a5)
ffffffffc0202dee:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202df0:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202df4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202df6:	078a                	slli	a5,a5,0x2
ffffffffc0202df8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dfa:	22e7fd63          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dfe:	000bb503          	ld	a0,0(s7)
ffffffffc0202e02:	fff80737          	lui	a4,0xfff80
ffffffffc0202e06:	97ba                	add	a5,a5,a4
ffffffffc0202e08:	079a                	slli	a5,a5,0x6
ffffffffc0202e0a:	953e                	add	a0,a0,a5
ffffffffc0202e0c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e10:	8b89                	andi	a5,a5,2
ffffffffc0202e12:	18079d63          	bnez	a5,ffffffffc0202fac <pmm_init+0x6ea>
ffffffffc0202e16:	000b3783          	ld	a5,0(s6)
ffffffffc0202e1a:	4585                	li	a1,1
ffffffffc0202e1c:	739c                	ld	a5,32(a5)
ffffffffc0202e1e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e20:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202e24:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e26:	078a                	slli	a5,a5,0x2
ffffffffc0202e28:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202e2a:	20e7f563          	bgeu	a5,a4,ffffffffc0203034 <pmm_init+0x772>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e2e:	000bb503          	ld	a0,0(s7)
ffffffffc0202e32:	fff80737          	lui	a4,0xfff80
ffffffffc0202e36:	97ba                	add	a5,a5,a4
ffffffffc0202e38:	079a                	slli	a5,a5,0x6
ffffffffc0202e3a:	953e                	add	a0,a0,a5
ffffffffc0202e3c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e40:	8b89                	andi	a5,a5,2
ffffffffc0202e42:	14079963          	bnez	a5,ffffffffc0202f94 <pmm_init+0x6d2>
ffffffffc0202e46:	000b3783          	ld	a5,0(s6)
ffffffffc0202e4a:	4585                	li	a1,1
ffffffffc0202e4c:	739c                	ld	a5,32(a5)
ffffffffc0202e4e:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202e50:	00093783          	ld	a5,0(s2)
ffffffffc0202e54:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202e58:	12000073          	sfence.vma
ffffffffc0202e5c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e60:	8b89                	andi	a5,a5,2
ffffffffc0202e62:	10079f63          	bnez	a5,ffffffffc0202f80 <pmm_init+0x6be>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e66:	000b3783          	ld	a5,0(s6)
ffffffffc0202e6a:	779c                	ld	a5,40(a5)
ffffffffc0202e6c:	9782                	jalr	a5
ffffffffc0202e6e:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202e70:	4c8c1e63          	bne	s8,s0,ffffffffc020334c <pmm_init+0xa8a>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202e74:	00004517          	auipc	a0,0x4
ffffffffc0202e78:	cd450513          	addi	a0,a0,-812 # ffffffffc0206b48 <etext+0x1498>
ffffffffc0202e7c:	b18fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202e80:	7406                	ld	s0,96(sp)
ffffffffc0202e82:	70a6                	ld	ra,104(sp)
ffffffffc0202e84:	64e6                	ld	s1,88(sp)
ffffffffc0202e86:	6946                	ld	s2,80(sp)
ffffffffc0202e88:	69a6                	ld	s3,72(sp)
ffffffffc0202e8a:	6a06                	ld	s4,64(sp)
ffffffffc0202e8c:	7ae2                	ld	s5,56(sp)
ffffffffc0202e8e:	7b42                	ld	s6,48(sp)
ffffffffc0202e90:	7ba2                	ld	s7,40(sp)
ffffffffc0202e92:	7c02                	ld	s8,32(sp)
ffffffffc0202e94:	6ce2                	ld	s9,24(sp)
ffffffffc0202e96:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202e98:	da9fe06f          	j	ffffffffc0201c40 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202e9c:	c8000637          	lui	a2,0xc8000
ffffffffc0202ea0:	bc4d                	j	ffffffffc0202952 <pmm_init+0x90>
        intr_disable();
ffffffffc0202ea2:	ad9fd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202ea6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eaa:	4505                	li	a0,1
ffffffffc0202eac:	6f9c                	ld	a5,24(a5)
ffffffffc0202eae:	9782                	jalr	a5
ffffffffc0202eb0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202eb2:	ac3fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202eb6:	b9b9                	j	ffffffffc0202b14 <pmm_init+0x252>
        intr_disable();
ffffffffc0202eb8:	ac3fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202ebc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ec0:	4505                	li	a0,1
ffffffffc0202ec2:	6f9c                	ld	a5,24(a5)
ffffffffc0202ec4:	9782                	jalr	a5
ffffffffc0202ec6:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202ec8:	aadfd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202ecc:	b655                	j	ffffffffc0202a70 <pmm_init+0x1ae>
        intr_disable();
ffffffffc0202ece:	aadfd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ed2:	000b3783          	ld	a5,0(s6)
ffffffffc0202ed6:	779c                	ld	a5,40(a5)
ffffffffc0202ed8:	9782                	jalr	a5
ffffffffc0202eda:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202edc:	a99fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202ee0:	be89                	j	ffffffffc0202a32 <pmm_init+0x170>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202ee2:	6585                	lui	a1,0x1
ffffffffc0202ee4:	15fd                	addi	a1,a1,-1 # fff <_binary_obj___user_softint_out_size-0x75f9>
ffffffffc0202ee6:	96ae                	add	a3,a3,a1
ffffffffc0202ee8:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202eea:	00c7d693          	srli	a3,a5,0xc
ffffffffc0202eee:	14c6f363          	bgeu	a3,a2,ffffffffc0203034 <pmm_init+0x772>
    pmm_manager->init_memmap(base, n);
ffffffffc0202ef2:	000b3603          	ld	a2,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202ef6:	fff805b7          	lui	a1,0xfff80
ffffffffc0202efa:	96ae                	add	a3,a3,a1
ffffffffc0202efc:	6a10                	ld	a2,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202efe:	8c1d                	sub	s0,s0,a5
ffffffffc0202f00:	00669513          	slli	a0,a3,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202f04:	00c45593          	srli	a1,s0,0xc
ffffffffc0202f08:	953a                	add	a0,a0,a4
ffffffffc0202f0a:	9602                	jalr	a2
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202f0c:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202f10:	b4d1                	j	ffffffffc02029d4 <pmm_init+0x112>
        intr_disable();
ffffffffc0202f12:	a69fd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f16:	000b3783          	ld	a5,0(s6)
ffffffffc0202f1a:	779c                	ld	a5,40(a5)
ffffffffc0202f1c:	9782                	jalr	a5
ffffffffc0202f1e:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202f20:	a55fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f24:	bb79                	j	ffffffffc0202cc2 <pmm_init+0x400>
        intr_disable();
ffffffffc0202f26:	a55fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202f2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f2e:	779c                	ld	a5,40(a5)
ffffffffc0202f30:	9782                	jalr	a5
ffffffffc0202f32:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202f34:	a41fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f38:	b39d                	j	ffffffffc0202c9e <pmm_init+0x3dc>
ffffffffc0202f3a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f3c:	a3ffd0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f40:	000b3783          	ld	a5,0(s6)
ffffffffc0202f44:	6522                	ld	a0,8(sp)
ffffffffc0202f46:	4585                	li	a1,1
ffffffffc0202f48:	739c                	ld	a5,32(a5)
ffffffffc0202f4a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f4c:	a29fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f50:	b33d                	j	ffffffffc0202c7e <pmm_init+0x3bc>
ffffffffc0202f52:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f54:	a27fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202f58:	000b3783          	ld	a5,0(s6)
ffffffffc0202f5c:	6522                	ld	a0,8(sp)
ffffffffc0202f5e:	4585                	li	a1,1
ffffffffc0202f60:	739c                	ld	a5,32(a5)
ffffffffc0202f62:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f64:	a11fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f68:	b1dd                	j	ffffffffc0202c4e <pmm_init+0x38c>
        intr_disable();
ffffffffc0202f6a:	a11fd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202f6e:	000b3783          	ld	a5,0(s6)
ffffffffc0202f72:	4505                	li	a0,1
ffffffffc0202f74:	6f9c                	ld	a5,24(a5)
ffffffffc0202f76:	9782                	jalr	a5
ffffffffc0202f78:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f7a:	9fbfd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f7e:	b36d                	j	ffffffffc0202d28 <pmm_init+0x466>
        intr_disable();
ffffffffc0202f80:	9fbfd0ef          	jal	ffffffffc020097a <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f84:	000b3783          	ld	a5,0(s6)
ffffffffc0202f88:	779c                	ld	a5,40(a5)
ffffffffc0202f8a:	9782                	jalr	a5
ffffffffc0202f8c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f8e:	9e7fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202f92:	bdf9                	j	ffffffffc0202e70 <pmm_init+0x5ae>
ffffffffc0202f94:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f96:	9e5fd0ef          	jal	ffffffffc020097a <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f9a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f9e:	6522                	ld	a0,8(sp)
ffffffffc0202fa0:	4585                	li	a1,1
ffffffffc0202fa2:	739c                	ld	a5,32(a5)
ffffffffc0202fa4:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fa6:	9cffd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202faa:	b55d                	j	ffffffffc0202e50 <pmm_init+0x58e>
ffffffffc0202fac:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202fae:	9cdfd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202fb2:	000b3783          	ld	a5,0(s6)
ffffffffc0202fb6:	6522                	ld	a0,8(sp)
ffffffffc0202fb8:	4585                	li	a1,1
ffffffffc0202fba:	739c                	ld	a5,32(a5)
ffffffffc0202fbc:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fbe:	9b7fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202fc2:	bdb9                	j	ffffffffc0202e20 <pmm_init+0x55e>
        intr_disable();
ffffffffc0202fc4:	9b7fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc0202fc8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fcc:	4585                	li	a1,1
ffffffffc0202fce:	8522                	mv	a0,s0
ffffffffc0202fd0:	739c                	ld	a5,32(a5)
ffffffffc0202fd2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fd4:	9a1fd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0202fd8:	bd21                	j	ffffffffc0202df0 <pmm_init+0x52e>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202fda:	86a2                	mv	a3,s0
ffffffffc0202fdc:	00003617          	auipc	a2,0x3
ffffffffc0202fe0:	46460613          	addi	a2,a2,1124 # ffffffffc0206440 <etext+0xd90>
ffffffffc0202fe4:	24b00593          	li	a1,587
ffffffffc0202fe8:	00003517          	auipc	a0,0x3
ffffffffc0202fec:	57050513          	addi	a0,a0,1392 # ffffffffc0206558 <etext+0xea8>
ffffffffc0202ff0:	c98fd0ef          	jal	ffffffffc0200488 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ff4:	00004697          	auipc	a3,0x4
ffffffffc0202ff8:	9f468693          	addi	a3,a3,-1548 # ffffffffc02069e8 <etext+0x1338>
ffffffffc0202ffc:	00003617          	auipc	a2,0x3
ffffffffc0203000:	09460613          	addi	a2,a2,148 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203004:	24c00593          	li	a1,588
ffffffffc0203008:	00003517          	auipc	a0,0x3
ffffffffc020300c:	55050513          	addi	a0,a0,1360 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203010:	c78fd0ef          	jal	ffffffffc0200488 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203014:	00004697          	auipc	a3,0x4
ffffffffc0203018:	99468693          	addi	a3,a3,-1644 # ffffffffc02069a8 <etext+0x12f8>
ffffffffc020301c:	00003617          	auipc	a2,0x3
ffffffffc0203020:	07460613          	addi	a2,a2,116 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203024:	24b00593          	li	a1,587
ffffffffc0203028:	00003517          	auipc	a0,0x3
ffffffffc020302c:	53050513          	addi	a0,a0,1328 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203030:	c58fd0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0203034:	dd1fe0ef          	jal	ffffffffc0201e04 <pa2page.part.0>
ffffffffc0203038:	de9fe0ef          	jal	ffffffffc0201e20 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020303c:	00003697          	auipc	a3,0x3
ffffffffc0203040:	76468693          	addi	a3,a3,1892 # ffffffffc02067a0 <etext+0x10f0>
ffffffffc0203044:	00003617          	auipc	a2,0x3
ffffffffc0203048:	04c60613          	addi	a2,a2,76 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020304c:	21b00593          	li	a1,539
ffffffffc0203050:	00003517          	auipc	a0,0x3
ffffffffc0203054:	50850513          	addi	a0,a0,1288 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203058:	c30fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020305c:	00003697          	auipc	a3,0x3
ffffffffc0203060:	68468693          	addi	a3,a3,1668 # ffffffffc02066e0 <etext+0x1030>
ffffffffc0203064:	00003617          	auipc	a2,0x3
ffffffffc0203068:	02c60613          	addi	a2,a2,44 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020306c:	20e00593          	li	a1,526
ffffffffc0203070:	00003517          	auipc	a0,0x3
ffffffffc0203074:	4e850513          	addi	a0,a0,1256 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203078:	c10fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020307c:	00003697          	auipc	a3,0x3
ffffffffc0203080:	62468693          	addi	a3,a3,1572 # ffffffffc02066a0 <etext+0xff0>
ffffffffc0203084:	00003617          	auipc	a2,0x3
ffffffffc0203088:	00c60613          	addi	a2,a2,12 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020308c:	20d00593          	li	a1,525
ffffffffc0203090:	00003517          	auipc	a0,0x3
ffffffffc0203094:	4c850513          	addi	a0,a0,1224 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203098:	bf0fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020309c:	00003697          	auipc	a3,0x3
ffffffffc02030a0:	5e468693          	addi	a3,a3,1508 # ffffffffc0206680 <etext+0xfd0>
ffffffffc02030a4:	00003617          	auipc	a2,0x3
ffffffffc02030a8:	fec60613          	addi	a2,a2,-20 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02030ac:	20c00593          	li	a1,524
ffffffffc02030b0:	00003517          	auipc	a0,0x3
ffffffffc02030b4:	4a850513          	addi	a0,a0,1192 # ffffffffc0206558 <etext+0xea8>
ffffffffc02030b8:	bd0fd0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc02030bc:	00003617          	auipc	a2,0x3
ffffffffc02030c0:	38460613          	addi	a2,a2,900 # ffffffffc0206440 <etext+0xd90>
ffffffffc02030c4:	07100593          	li	a1,113
ffffffffc02030c8:	00003517          	auipc	a0,0x3
ffffffffc02030cc:	3a050513          	addi	a0,a0,928 # ffffffffc0206468 <etext+0xdb8>
ffffffffc02030d0:	bb8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02030d4:	00004697          	auipc	a3,0x4
ffffffffc02030d8:	85c68693          	addi	a3,a3,-1956 # ffffffffc0206930 <etext+0x1280>
ffffffffc02030dc:	00003617          	auipc	a2,0x3
ffffffffc02030e0:	fb460613          	addi	a2,a2,-76 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02030e4:	23400593          	li	a1,564
ffffffffc02030e8:	00003517          	auipc	a0,0x3
ffffffffc02030ec:	47050513          	addi	a0,a0,1136 # ffffffffc0206558 <etext+0xea8>
ffffffffc02030f0:	b98fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030f4:	00003697          	auipc	a3,0x3
ffffffffc02030f8:	7f468693          	addi	a3,a3,2036 # ffffffffc02068e8 <etext+0x1238>
ffffffffc02030fc:	00003617          	auipc	a2,0x3
ffffffffc0203100:	f9460613          	addi	a2,a2,-108 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203104:	23200593          	li	a1,562
ffffffffc0203108:	00003517          	auipc	a0,0x3
ffffffffc020310c:	45050513          	addi	a0,a0,1104 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203110:	b78fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203114:	00004697          	auipc	a3,0x4
ffffffffc0203118:	80468693          	addi	a3,a3,-2044 # ffffffffc0206918 <etext+0x1268>
ffffffffc020311c:	00003617          	auipc	a2,0x3
ffffffffc0203120:	f7460613          	addi	a2,a2,-140 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203124:	23100593          	li	a1,561
ffffffffc0203128:	00003517          	auipc	a0,0x3
ffffffffc020312c:	43050513          	addi	a0,a0,1072 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203130:	b58fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203134:	00004697          	auipc	a3,0x4
ffffffffc0203138:	8cc68693          	addi	a3,a3,-1844 # ffffffffc0206a00 <etext+0x1350>
ffffffffc020313c:	00003617          	auipc	a2,0x3
ffffffffc0203140:	f5460613          	addi	a2,a2,-172 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203144:	24f00593          	li	a1,591
ffffffffc0203148:	00003517          	auipc	a0,0x3
ffffffffc020314c:	41050513          	addi	a0,a0,1040 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203150:	b38fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203154:	00004697          	auipc	a3,0x4
ffffffffc0203158:	80c68693          	addi	a3,a3,-2036 # ffffffffc0206960 <etext+0x12b0>
ffffffffc020315c:	00003617          	auipc	a2,0x3
ffffffffc0203160:	f3460613          	addi	a2,a2,-204 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203164:	23c00593          	li	a1,572
ffffffffc0203168:	00003517          	auipc	a0,0x3
ffffffffc020316c:	3f050513          	addi	a0,a0,1008 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203170:	b18fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203174:	00004697          	auipc	a3,0x4
ffffffffc0203178:	8e468693          	addi	a3,a3,-1820 # ffffffffc0206a58 <etext+0x13a8>
ffffffffc020317c:	00003617          	auipc	a2,0x3
ffffffffc0203180:	f1460613          	addi	a2,a2,-236 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203184:	25400593          	li	a1,596
ffffffffc0203188:	00003517          	auipc	a0,0x3
ffffffffc020318c:	3d050513          	addi	a0,a0,976 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203190:	af8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203194:	00004697          	auipc	a3,0x4
ffffffffc0203198:	88468693          	addi	a3,a3,-1916 # ffffffffc0206a18 <etext+0x1368>
ffffffffc020319c:	00003617          	auipc	a2,0x3
ffffffffc02031a0:	ef460613          	addi	a2,a2,-268 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02031a4:	25300593          	li	a1,595
ffffffffc02031a8:	00003517          	auipc	a0,0x3
ffffffffc02031ac:	3b050513          	addi	a0,a0,944 # ffffffffc0206558 <etext+0xea8>
ffffffffc02031b0:	ad8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02031b4:	00003697          	auipc	a3,0x3
ffffffffc02031b8:	73468693          	addi	a3,a3,1844 # ffffffffc02068e8 <etext+0x1238>
ffffffffc02031bc:	00003617          	auipc	a2,0x3
ffffffffc02031c0:	ed460613          	addi	a2,a2,-300 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02031c4:	22e00593          	li	a1,558
ffffffffc02031c8:	00003517          	auipc	a0,0x3
ffffffffc02031cc:	39050513          	addi	a0,a0,912 # ffffffffc0206558 <etext+0xea8>
ffffffffc02031d0:	ab8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02031d4:	00003697          	auipc	a3,0x3
ffffffffc02031d8:	5b468693          	addi	a3,a3,1460 # ffffffffc0206788 <etext+0x10d8>
ffffffffc02031dc:	00003617          	auipc	a2,0x3
ffffffffc02031e0:	eb460613          	addi	a2,a2,-332 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02031e4:	22d00593          	li	a1,557
ffffffffc02031e8:	00003517          	auipc	a0,0x3
ffffffffc02031ec:	37050513          	addi	a0,a0,880 # ffffffffc0206558 <etext+0xea8>
ffffffffc02031f0:	a98fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02031f4:	00003697          	auipc	a3,0x3
ffffffffc02031f8:	70c68693          	addi	a3,a3,1804 # ffffffffc0206900 <etext+0x1250>
ffffffffc02031fc:	00003617          	auipc	a2,0x3
ffffffffc0203200:	e9460613          	addi	a2,a2,-364 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203204:	22a00593          	li	a1,554
ffffffffc0203208:	00003517          	auipc	a0,0x3
ffffffffc020320c:	35050513          	addi	a0,a0,848 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203210:	a78fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203214:	00003697          	auipc	a3,0x3
ffffffffc0203218:	55c68693          	addi	a3,a3,1372 # ffffffffc0206770 <etext+0x10c0>
ffffffffc020321c:	00003617          	auipc	a2,0x3
ffffffffc0203220:	e7460613          	addi	a2,a2,-396 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203224:	22900593          	li	a1,553
ffffffffc0203228:	00003517          	auipc	a0,0x3
ffffffffc020322c:	33050513          	addi	a0,a0,816 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203230:	a58fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203234:	00003697          	auipc	a3,0x3
ffffffffc0203238:	5dc68693          	addi	a3,a3,1500 # ffffffffc0206810 <etext+0x1160>
ffffffffc020323c:	00003617          	auipc	a2,0x3
ffffffffc0203240:	e5460613          	addi	a2,a2,-428 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203244:	22800593          	li	a1,552
ffffffffc0203248:	00003517          	auipc	a0,0x3
ffffffffc020324c:	31050513          	addi	a0,a0,784 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203250:	a38fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203254:	00003697          	auipc	a3,0x3
ffffffffc0203258:	69468693          	addi	a3,a3,1684 # ffffffffc02068e8 <etext+0x1238>
ffffffffc020325c:	00003617          	auipc	a2,0x3
ffffffffc0203260:	e3460613          	addi	a2,a2,-460 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203264:	22700593          	li	a1,551
ffffffffc0203268:	00003517          	auipc	a0,0x3
ffffffffc020326c:	2f050513          	addi	a0,a0,752 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203270:	a18fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203274:	00003697          	auipc	a3,0x3
ffffffffc0203278:	65c68693          	addi	a3,a3,1628 # ffffffffc02068d0 <etext+0x1220>
ffffffffc020327c:	00003617          	auipc	a2,0x3
ffffffffc0203280:	e1460613          	addi	a2,a2,-492 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203284:	22600593          	li	a1,550
ffffffffc0203288:	00003517          	auipc	a0,0x3
ffffffffc020328c:	2d050513          	addi	a0,a0,720 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203290:	9f8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203294:	00003697          	auipc	a3,0x3
ffffffffc0203298:	60c68693          	addi	a3,a3,1548 # ffffffffc02068a0 <etext+0x11f0>
ffffffffc020329c:	00003617          	auipc	a2,0x3
ffffffffc02032a0:	df460613          	addi	a2,a2,-524 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02032a4:	22500593          	li	a1,549
ffffffffc02032a8:	00003517          	auipc	a0,0x3
ffffffffc02032ac:	2b050513          	addi	a0,a0,688 # ffffffffc0206558 <etext+0xea8>
ffffffffc02032b0:	9d8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02032b4:	00003697          	auipc	a3,0x3
ffffffffc02032b8:	5d468693          	addi	a3,a3,1492 # ffffffffc0206888 <etext+0x11d8>
ffffffffc02032bc:	00003617          	auipc	a2,0x3
ffffffffc02032c0:	dd460613          	addi	a2,a2,-556 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02032c4:	22300593          	li	a1,547
ffffffffc02032c8:	00003517          	auipc	a0,0x3
ffffffffc02032cc:	29050513          	addi	a0,a0,656 # ffffffffc0206558 <etext+0xea8>
ffffffffc02032d0:	9b8fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02032d4:	00003697          	auipc	a3,0x3
ffffffffc02032d8:	59468693          	addi	a3,a3,1428 # ffffffffc0206868 <etext+0x11b8>
ffffffffc02032dc:	00003617          	auipc	a2,0x3
ffffffffc02032e0:	db460613          	addi	a2,a2,-588 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02032e4:	22200593          	li	a1,546
ffffffffc02032e8:	00003517          	auipc	a0,0x3
ffffffffc02032ec:	27050513          	addi	a0,a0,624 # ffffffffc0206558 <etext+0xea8>
ffffffffc02032f0:	998fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(*ptep & PTE_W);
ffffffffc02032f4:	00003697          	auipc	a3,0x3
ffffffffc02032f8:	56468693          	addi	a3,a3,1380 # ffffffffc0206858 <etext+0x11a8>
ffffffffc02032fc:	00003617          	auipc	a2,0x3
ffffffffc0203300:	d9460613          	addi	a2,a2,-620 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203304:	22100593          	li	a1,545
ffffffffc0203308:	00003517          	auipc	a0,0x3
ffffffffc020330c:	25050513          	addi	a0,a0,592 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203310:	978fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203314:	00003697          	auipc	a3,0x3
ffffffffc0203318:	53468693          	addi	a3,a3,1332 # ffffffffc0206848 <etext+0x1198>
ffffffffc020331c:	00003617          	auipc	a2,0x3
ffffffffc0203320:	d7460613          	addi	a2,a2,-652 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203324:	22000593          	li	a1,544
ffffffffc0203328:	00003517          	auipc	a0,0x3
ffffffffc020332c:	23050513          	addi	a0,a0,560 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203330:	958fd0ef          	jal	ffffffffc0200488 <__panic>
        panic("DTB memory info not available");
ffffffffc0203334:	00003617          	auipc	a2,0x3
ffffffffc0203338:	2b460613          	addi	a2,a2,692 # ffffffffc02065e8 <etext+0xf38>
ffffffffc020333c:	06500593          	li	a1,101
ffffffffc0203340:	00003517          	auipc	a0,0x3
ffffffffc0203344:	21850513          	addi	a0,a0,536 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203348:	940fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020334c:	00003697          	auipc	a3,0x3
ffffffffc0203350:	61468693          	addi	a3,a3,1556 # ffffffffc0206960 <etext+0x12b0>
ffffffffc0203354:	00003617          	auipc	a2,0x3
ffffffffc0203358:	d3c60613          	addi	a2,a2,-708 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020335c:	26600593          	li	a1,614
ffffffffc0203360:	00003517          	auipc	a0,0x3
ffffffffc0203364:	1f850513          	addi	a0,a0,504 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203368:	920fd0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020336c:	00003697          	auipc	a3,0x3
ffffffffc0203370:	4a468693          	addi	a3,a3,1188 # ffffffffc0206810 <etext+0x1160>
ffffffffc0203374:	00003617          	auipc	a2,0x3
ffffffffc0203378:	d1c60613          	addi	a2,a2,-740 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020337c:	21f00593          	li	a1,543
ffffffffc0203380:	00003517          	auipc	a0,0x3
ffffffffc0203384:	1d850513          	addi	a0,a0,472 # ffffffffc0206558 <etext+0xea8>
ffffffffc0203388:	900fd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020338c:	00003697          	auipc	a3,0x3
ffffffffc0203390:	44468693          	addi	a3,a3,1092 # ffffffffc02067d0 <etext+0x1120>
ffffffffc0203394:	00003617          	auipc	a2,0x3
ffffffffc0203398:	cfc60613          	addi	a2,a2,-772 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020339c:	21e00593          	li	a1,542
ffffffffc02033a0:	00003517          	auipc	a0,0x3
ffffffffc02033a4:	1b850513          	addi	a0,a0,440 # ffffffffc0206558 <etext+0xea8>
ffffffffc02033a8:	8e0fd0ef          	jal	ffffffffc0200488 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02033ac:	86d6                	mv	a3,s5
ffffffffc02033ae:	00003617          	auipc	a2,0x3
ffffffffc02033b2:	09260613          	addi	a2,a2,146 # ffffffffc0206440 <etext+0xd90>
ffffffffc02033b6:	21a00593          	li	a1,538
ffffffffc02033ba:	00003517          	auipc	a0,0x3
ffffffffc02033be:	19e50513          	addi	a0,a0,414 # ffffffffc0206558 <etext+0xea8>
ffffffffc02033c2:	8c6fd0ef          	jal	ffffffffc0200488 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02033c6:	00003617          	auipc	a2,0x3
ffffffffc02033ca:	07a60613          	addi	a2,a2,122 # ffffffffc0206440 <etext+0xd90>
ffffffffc02033ce:	21900593          	li	a1,537
ffffffffc02033d2:	00003517          	auipc	a0,0x3
ffffffffc02033d6:	18650513          	addi	a0,a0,390 # ffffffffc0206558 <etext+0xea8>
ffffffffc02033da:	8aefd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02033de:	00003697          	auipc	a3,0x3
ffffffffc02033e2:	3aa68693          	addi	a3,a3,938 # ffffffffc0206788 <etext+0x10d8>
ffffffffc02033e6:	00003617          	auipc	a2,0x3
ffffffffc02033ea:	caa60613          	addi	a2,a2,-854 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02033ee:	21700593          	li	a1,535
ffffffffc02033f2:	00003517          	auipc	a0,0x3
ffffffffc02033f6:	16650513          	addi	a0,a0,358 # ffffffffc0206558 <etext+0xea8>
ffffffffc02033fa:	88efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02033fe:	00003697          	auipc	a3,0x3
ffffffffc0203402:	37268693          	addi	a3,a3,882 # ffffffffc0206770 <etext+0x10c0>
ffffffffc0203406:	00003617          	auipc	a2,0x3
ffffffffc020340a:	c8a60613          	addi	a2,a2,-886 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020340e:	21600593          	li	a1,534
ffffffffc0203412:	00003517          	auipc	a0,0x3
ffffffffc0203416:	14650513          	addi	a0,a0,326 # ffffffffc0206558 <etext+0xea8>
ffffffffc020341a:	86efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020341e:	00003697          	auipc	a3,0x3
ffffffffc0203422:	70268693          	addi	a3,a3,1794 # ffffffffc0206b20 <etext+0x1470>
ffffffffc0203426:	00003617          	auipc	a2,0x3
ffffffffc020342a:	c6a60613          	addi	a2,a2,-918 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020342e:	25d00593          	li	a1,605
ffffffffc0203432:	00003517          	auipc	a0,0x3
ffffffffc0203436:	12650513          	addi	a0,a0,294 # ffffffffc0206558 <etext+0xea8>
ffffffffc020343a:	84efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020343e:	00003697          	auipc	a3,0x3
ffffffffc0203442:	6aa68693          	addi	a3,a3,1706 # ffffffffc0206ae8 <etext+0x1438>
ffffffffc0203446:	00003617          	auipc	a2,0x3
ffffffffc020344a:	c4a60613          	addi	a2,a2,-950 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020344e:	25a00593          	li	a1,602
ffffffffc0203452:	00003517          	auipc	a0,0x3
ffffffffc0203456:	10650513          	addi	a0,a0,262 # ffffffffc0206558 <etext+0xea8>
ffffffffc020345a:	82efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020345e:	00003697          	auipc	a3,0x3
ffffffffc0203462:	65a68693          	addi	a3,a3,1626 # ffffffffc0206ab8 <etext+0x1408>
ffffffffc0203466:	00003617          	auipc	a2,0x3
ffffffffc020346a:	c2a60613          	addi	a2,a2,-982 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020346e:	25600593          	li	a1,598
ffffffffc0203472:	00003517          	auipc	a0,0x3
ffffffffc0203476:	0e650513          	addi	a0,a0,230 # ffffffffc0206558 <etext+0xea8>
ffffffffc020347a:	80efd0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020347e:	00003697          	auipc	a3,0x3
ffffffffc0203482:	5f268693          	addi	a3,a3,1522 # ffffffffc0206a70 <etext+0x13c0>
ffffffffc0203486:	00003617          	auipc	a2,0x3
ffffffffc020348a:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020348e:	25500593          	li	a1,597
ffffffffc0203492:	00003517          	auipc	a0,0x3
ffffffffc0203496:	0c650513          	addi	a0,a0,198 # ffffffffc0206558 <etext+0xea8>
ffffffffc020349a:	feffc0ef          	jal	ffffffffc0200488 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020349e:	00003617          	auipc	a2,0x3
ffffffffc02034a2:	04a60613          	addi	a2,a2,74 # ffffffffc02064e8 <etext+0xe38>
ffffffffc02034a6:	0c900593          	li	a1,201
ffffffffc02034aa:	00003517          	auipc	a0,0x3
ffffffffc02034ae:	0ae50513          	addi	a0,a0,174 # ffffffffc0206558 <etext+0xea8>
ffffffffc02034b2:	fd7fc0ef          	jal	ffffffffc0200488 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02034b6:	00003617          	auipc	a2,0x3
ffffffffc02034ba:	03260613          	addi	a2,a2,50 # ffffffffc02064e8 <etext+0xe38>
ffffffffc02034be:	08100593          	li	a1,129
ffffffffc02034c2:	00003517          	auipc	a0,0x3
ffffffffc02034c6:	09650513          	addi	a0,a0,150 # ffffffffc0206558 <etext+0xea8>
ffffffffc02034ca:	fbffc0ef          	jal	ffffffffc0200488 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02034ce:	00003697          	auipc	a3,0x3
ffffffffc02034d2:	27268693          	addi	a3,a3,626 # ffffffffc0206740 <etext+0x1090>
ffffffffc02034d6:	00003617          	auipc	a2,0x3
ffffffffc02034da:	bba60613          	addi	a2,a2,-1094 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02034de:	21500593          	li	a1,533
ffffffffc02034e2:	00003517          	auipc	a0,0x3
ffffffffc02034e6:	07650513          	addi	a0,a0,118 # ffffffffc0206558 <etext+0xea8>
ffffffffc02034ea:	f9ffc0ef          	jal	ffffffffc0200488 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02034ee:	00003697          	auipc	a3,0x3
ffffffffc02034f2:	22268693          	addi	a3,a3,546 # ffffffffc0206710 <etext+0x1060>
ffffffffc02034f6:	00003617          	auipc	a2,0x3
ffffffffc02034fa:	b9a60613          	addi	a2,a2,-1126 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02034fe:	21200593          	li	a1,530
ffffffffc0203502:	00003517          	auipc	a0,0x3
ffffffffc0203506:	05650513          	addi	a0,a0,86 # ffffffffc0206558 <etext+0xea8>
ffffffffc020350a:	f7ffc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020350e <pgdir_alloc_page>:
{
ffffffffc020350e:	7179                	addi	sp,sp,-48
ffffffffc0203510:	ec26                	sd	s1,24(sp)
ffffffffc0203512:	e44e                	sd	s3,8(sp)
ffffffffc0203514:	e052                	sd	s4,0(sp)
ffffffffc0203516:	f406                	sd	ra,40(sp)
ffffffffc0203518:	f022                	sd	s0,32(sp)
ffffffffc020351a:	e84a                	sd	s2,16(sp)
ffffffffc020351c:	8a2a                	mv	s4,a0
ffffffffc020351e:	84ae                	mv	s1,a1
ffffffffc0203520:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203522:	100027f3          	csrr	a5,sstatus
ffffffffc0203526:	8b89                	andi	a5,a5,2
ffffffffc0203528:	e3a9                	bnez	a5,ffffffffc020356a <pgdir_alloc_page+0x5c>
        page = pmm_manager->alloc_pages(n);
ffffffffc020352a:	00092917          	auipc	s2,0x92
ffffffffc020352e:	5f690913          	addi	s2,s2,1526 # ffffffffc0295b20 <pmm_manager>
ffffffffc0203532:	00093783          	ld	a5,0(s2)
ffffffffc0203536:	4505                	li	a0,1
ffffffffc0203538:	6f9c                	ld	a5,24(a5)
ffffffffc020353a:	9782                	jalr	a5
ffffffffc020353c:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc020353e:	c429                	beqz	s0,ffffffffc0203588 <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203540:	86ce                	mv	a3,s3
ffffffffc0203542:	8626                	mv	a2,s1
ffffffffc0203544:	85a2                	mv	a1,s0
ffffffffc0203546:	8552                	mv	a0,s4
ffffffffc0203548:	a86ff0ef          	jal	ffffffffc02027ce <page_insert>
ffffffffc020354c:	e121                	bnez	a0,ffffffffc020358c <pgdir_alloc_page+0x7e>
        assert(page_ref(page) == 1);
ffffffffc020354e:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203550:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203552:	4785                	li	a5,1
ffffffffc0203554:	06f71463          	bne	a4,a5,ffffffffc02035bc <pgdir_alloc_page+0xae>
}
ffffffffc0203558:	70a2                	ld	ra,40(sp)
ffffffffc020355a:	8522                	mv	a0,s0
ffffffffc020355c:	7402                	ld	s0,32(sp)
ffffffffc020355e:	64e2                	ld	s1,24(sp)
ffffffffc0203560:	6942                	ld	s2,16(sp)
ffffffffc0203562:	69a2                	ld	s3,8(sp)
ffffffffc0203564:	6a02                	ld	s4,0(sp)
ffffffffc0203566:	6145                	addi	sp,sp,48
ffffffffc0203568:	8082                	ret
        intr_disable();
ffffffffc020356a:	c10fd0ef          	jal	ffffffffc020097a <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020356e:	00092917          	auipc	s2,0x92
ffffffffc0203572:	5b290913          	addi	s2,s2,1458 # ffffffffc0295b20 <pmm_manager>
ffffffffc0203576:	00093783          	ld	a5,0(s2)
ffffffffc020357a:	4505                	li	a0,1
ffffffffc020357c:	6f9c                	ld	a5,24(a5)
ffffffffc020357e:	9782                	jalr	a5
ffffffffc0203580:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203582:	bf2fd0ef          	jal	ffffffffc0200974 <intr_enable>
    if (page != NULL)
ffffffffc0203586:	fc4d                	bnez	s0,ffffffffc0203540 <pgdir_alloc_page+0x32>
            return NULL;
ffffffffc0203588:	4401                	li	s0,0
ffffffffc020358a:	b7f9                	j	ffffffffc0203558 <pgdir_alloc_page+0x4a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020358c:	100027f3          	csrr	a5,sstatus
ffffffffc0203590:	8b89                	andi	a5,a5,2
ffffffffc0203592:	eb89                	bnez	a5,ffffffffc02035a4 <pgdir_alloc_page+0x96>
        pmm_manager->free_pages(base, n);
ffffffffc0203594:	00093783          	ld	a5,0(s2)
ffffffffc0203598:	8522                	mv	a0,s0
ffffffffc020359a:	4585                	li	a1,1
ffffffffc020359c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020359e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02035a0:	9782                	jalr	a5
    if (flag)
ffffffffc02035a2:	bf5d                	j	ffffffffc0203558 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc02035a4:	bd6fd0ef          	jal	ffffffffc020097a <intr_disable>
ffffffffc02035a8:	00093783          	ld	a5,0(s2)
ffffffffc02035ac:	8522                	mv	a0,s0
ffffffffc02035ae:	4585                	li	a1,1
ffffffffc02035b0:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02035b2:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02035b4:	9782                	jalr	a5
        intr_enable();
ffffffffc02035b6:	bbefd0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc02035ba:	bf79                	j	ffffffffc0203558 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02035bc:	00003697          	auipc	a3,0x3
ffffffffc02035c0:	5ac68693          	addi	a3,a3,1452 # ffffffffc0206b68 <etext+0x14b8>
ffffffffc02035c4:	00003617          	auipc	a2,0x3
ffffffffc02035c8:	acc60613          	addi	a2,a2,-1332 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02035cc:	1f300593          	li	a1,499
ffffffffc02035d0:	00003517          	auipc	a0,0x3
ffffffffc02035d4:	f8850513          	addi	a0,a0,-120 # ffffffffc0206558 <etext+0xea8>
ffffffffc02035d8:	eb1fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02035dc <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02035dc:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02035de:	00003697          	auipc	a3,0x3
ffffffffc02035e2:	5a268693          	addi	a3,a3,1442 # ffffffffc0206b80 <etext+0x14d0>
ffffffffc02035e6:	00003617          	auipc	a2,0x3
ffffffffc02035ea:	aaa60613          	addi	a2,a2,-1366 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02035ee:	07400593          	li	a1,116
ffffffffc02035f2:	00003517          	auipc	a0,0x3
ffffffffc02035f6:	5ae50513          	addi	a0,a0,1454 # ffffffffc0206ba0 <etext+0x14f0>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02035fa:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02035fc:	e8dfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203600 <mm_create>:
{
ffffffffc0203600:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203602:	04000513          	li	a0,64
{
ffffffffc0203606:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203608:	e5cfe0ef          	jal	ffffffffc0201c64 <kmalloc>
    if (mm != NULL)
ffffffffc020360c:	cd19                	beqz	a0,ffffffffc020362a <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc020360e:	e508                	sd	a0,8(a0)
ffffffffc0203610:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203612:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203616:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020361a:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020361e:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203622:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203626:	02053c23          	sd	zero,56(a0)
}
ffffffffc020362a:	60a2                	ld	ra,8(sp)
ffffffffc020362c:	0141                	addi	sp,sp,16
ffffffffc020362e:	8082                	ret

ffffffffc0203630 <find_vma>:
{
ffffffffc0203630:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203632:	c505                	beqz	a0,ffffffffc020365a <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203634:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203636:	c501                	beqz	a0,ffffffffc020363e <find_vma+0xe>
ffffffffc0203638:	651c                	ld	a5,8(a0)
ffffffffc020363a:	02f5f663          	bgeu	a1,a5,ffffffffc0203666 <find_vma+0x36>
    return listelm->next;
ffffffffc020363e:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203640:	00f68d63          	beq	a3,a5,ffffffffc020365a <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203644:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203648:	00e5e663          	bltu	a1,a4,ffffffffc0203654 <find_vma+0x24>
ffffffffc020364c:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203650:	00e5e763          	bltu	a1,a4,ffffffffc020365e <find_vma+0x2e>
ffffffffc0203654:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203656:	fef697e3          	bne	a3,a5,ffffffffc0203644 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020365a:	4501                	li	a0,0
}
ffffffffc020365c:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020365e:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203662:	ea88                	sd	a0,16(a3)
ffffffffc0203664:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203666:	691c                	ld	a5,16(a0)
ffffffffc0203668:	fcf5fbe3          	bgeu	a1,a5,ffffffffc020363e <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020366c:	ea88                	sd	a0,16(a3)
ffffffffc020366e:	8082                	ret

ffffffffc0203670 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203670:	6590                	ld	a2,8(a1)
ffffffffc0203672:	0105b803          	ld	a6,16(a1) # fffffffffff80010 <end+0x3fcea4a0>
{
ffffffffc0203676:	1141                	addi	sp,sp,-16
ffffffffc0203678:	e406                	sd	ra,8(sp)
ffffffffc020367a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020367c:	01066763          	bltu	a2,a6,ffffffffc020368a <insert_vma_struct+0x1a>
ffffffffc0203680:	a085                	j	ffffffffc02036e0 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203682:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203686:	04e66863          	bltu	a2,a4,ffffffffc02036d6 <insert_vma_struct+0x66>
ffffffffc020368a:	86be                	mv	a3,a5
ffffffffc020368c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020368e:	fef51ae3          	bne	a0,a5,ffffffffc0203682 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203692:	02a68463          	beq	a3,a0,ffffffffc02036ba <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203696:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020369a:	fe86b883          	ld	a7,-24(a3)
ffffffffc020369e:	08e8f163          	bgeu	a7,a4,ffffffffc0203720 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036a2:	04e66f63          	bltu	a2,a4,ffffffffc0203700 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc02036a6:	00f50a63          	beq	a0,a5,ffffffffc02036ba <insert_vma_struct+0x4a>
ffffffffc02036aa:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036ae:	05076963          	bltu	a4,a6,ffffffffc0203700 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02036b2:	ff07b603          	ld	a2,-16(a5)
ffffffffc02036b6:	02c77363          	bgeu	a4,a2,ffffffffc02036dc <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02036ba:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02036bc:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02036be:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02036c2:	e390                	sd	a2,0(a5)
ffffffffc02036c4:	e690                	sd	a2,8(a3)
}
ffffffffc02036c6:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02036c8:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02036ca:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02036cc:	0017079b          	addiw	a5,a4,1 # fffffffffff80001 <end+0x3fcea491>
ffffffffc02036d0:	d11c                	sw	a5,32(a0)
}
ffffffffc02036d2:	0141                	addi	sp,sp,16
ffffffffc02036d4:	8082                	ret
    if (le_prev != list)
ffffffffc02036d6:	fca690e3          	bne	a3,a0,ffffffffc0203696 <insert_vma_struct+0x26>
ffffffffc02036da:	bfd1                	j	ffffffffc02036ae <insert_vma_struct+0x3e>
ffffffffc02036dc:	f01ff0ef          	jal	ffffffffc02035dc <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02036e0:	00003697          	auipc	a3,0x3
ffffffffc02036e4:	4d068693          	addi	a3,a3,1232 # ffffffffc0206bb0 <etext+0x1500>
ffffffffc02036e8:	00003617          	auipc	a2,0x3
ffffffffc02036ec:	9a860613          	addi	a2,a2,-1624 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02036f0:	07a00593          	li	a1,122
ffffffffc02036f4:	00003517          	auipc	a0,0x3
ffffffffc02036f8:	4ac50513          	addi	a0,a0,1196 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc02036fc:	d8dfc0ef          	jal	ffffffffc0200488 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203700:	00003697          	auipc	a3,0x3
ffffffffc0203704:	4f068693          	addi	a3,a3,1264 # ffffffffc0206bf0 <etext+0x1540>
ffffffffc0203708:	00003617          	auipc	a2,0x3
ffffffffc020370c:	98860613          	addi	a2,a2,-1656 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203710:	07300593          	li	a1,115
ffffffffc0203714:	00003517          	auipc	a0,0x3
ffffffffc0203718:	48c50513          	addi	a0,a0,1164 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc020371c:	d6dfc0ef          	jal	ffffffffc0200488 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203720:	00003697          	auipc	a3,0x3
ffffffffc0203724:	4b068693          	addi	a3,a3,1200 # ffffffffc0206bd0 <etext+0x1520>
ffffffffc0203728:	00003617          	auipc	a2,0x3
ffffffffc020372c:	96860613          	addi	a2,a2,-1688 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203730:	07200593          	li	a1,114
ffffffffc0203734:	00003517          	auipc	a0,0x3
ffffffffc0203738:	46c50513          	addi	a0,a0,1132 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc020373c:	d4dfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203740 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203740:	591c                	lw	a5,48(a0)
{
ffffffffc0203742:	1141                	addi	sp,sp,-16
ffffffffc0203744:	e406                	sd	ra,8(sp)
ffffffffc0203746:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203748:	e78d                	bnez	a5,ffffffffc0203772 <mm_destroy+0x32>
ffffffffc020374a:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020374c:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020374e:	00a40c63          	beq	s0,a0,ffffffffc0203766 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203752:	6118                	ld	a4,0(a0)
ffffffffc0203754:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203756:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203758:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020375a:	e398                	sd	a4,0(a5)
ffffffffc020375c:	db2fe0ef          	jal	ffffffffc0201d0e <kfree>
    return listelm->next;
ffffffffc0203760:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203762:	fea418e3          	bne	s0,a0,ffffffffc0203752 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203766:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203768:	6402                	ld	s0,0(sp)
ffffffffc020376a:	60a2                	ld	ra,8(sp)
ffffffffc020376c:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020376e:	da0fe06f          	j	ffffffffc0201d0e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203772:	00003697          	auipc	a3,0x3
ffffffffc0203776:	49e68693          	addi	a3,a3,1182 # ffffffffc0206c10 <etext+0x1560>
ffffffffc020377a:	00003617          	auipc	a2,0x3
ffffffffc020377e:	91660613          	addi	a2,a2,-1770 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203782:	09e00593          	li	a1,158
ffffffffc0203786:	00003517          	auipc	a0,0x3
ffffffffc020378a:	41a50513          	addi	a0,a0,1050 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc020378e:	cfbfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203792 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203792:	6785                	lui	a5,0x1
ffffffffc0203794:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x75f9>
{
ffffffffc0203796:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203798:	787d                	lui	a6,0xfffff
ffffffffc020379a:	963e                	add	a2,a2,a5
{
ffffffffc020379c:	f822                	sd	s0,48(sp)
ffffffffc020379e:	f426                	sd	s1,40(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037a0:	962e                	add	a2,a2,a1
{
ffffffffc02037a2:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02037a4:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc02037a8:	002007b7          	lui	a5,0x200
ffffffffc02037ac:	01067433          	and	s0,a2,a6
ffffffffc02037b0:	08f4e363          	bltu	s1,a5,ffffffffc0203836 <mm_map+0xa4>
ffffffffc02037b4:	0884f163          	bgeu	s1,s0,ffffffffc0203836 <mm_map+0xa4>
ffffffffc02037b8:	4785                	li	a5,1
ffffffffc02037ba:	07fe                	slli	a5,a5,0x1f
ffffffffc02037bc:	0687ed63          	bltu	a5,s0,ffffffffc0203836 <mm_map+0xa4>
ffffffffc02037c0:	ec4e                	sd	s3,24(sp)
ffffffffc02037c2:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02037c4:	c93d                	beqz	a0,ffffffffc020383a <mm_map+0xa8>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02037c6:	85a6                	mv	a1,s1
ffffffffc02037c8:	e852                	sd	s4,16(sp)
ffffffffc02037ca:	e456                	sd	s5,8(sp)
ffffffffc02037cc:	8a3a                	mv	s4,a4
ffffffffc02037ce:	8ab6                	mv	s5,a3
ffffffffc02037d0:	e61ff0ef          	jal	ffffffffc0203630 <find_vma>
ffffffffc02037d4:	c501                	beqz	a0,ffffffffc02037dc <mm_map+0x4a>
ffffffffc02037d6:	651c                	ld	a5,8(a0)
ffffffffc02037d8:	0487ec63          	bltu	a5,s0,ffffffffc0203830 <mm_map+0x9e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02037dc:	03000513          	li	a0,48
ffffffffc02037e0:	f04a                	sd	s2,32(sp)
ffffffffc02037e2:	c82fe0ef          	jal	ffffffffc0201c64 <kmalloc>
ffffffffc02037e6:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02037e8:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02037ea:	02090a63          	beqz	s2,ffffffffc020381e <mm_map+0x8c>
        vma->vm_start = vm_start;
ffffffffc02037ee:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02037f2:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02037f6:	01592c23          	sw	s5,24(s2)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02037fa:	85ca                	mv	a1,s2
ffffffffc02037fc:	854e                	mv	a0,s3
ffffffffc02037fe:	e73ff0ef          	jal	ffffffffc0203670 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc0203802:	000a0463          	beqz	s4,ffffffffc020380a <mm_map+0x78>
    {
        *vma_store = vma;
ffffffffc0203806:	012a3023          	sd	s2,0(s4)
ffffffffc020380a:	7902                	ld	s2,32(sp)
ffffffffc020380c:	69e2                	ld	s3,24(sp)
ffffffffc020380e:	6a42                	ld	s4,16(sp)
ffffffffc0203810:	6aa2                	ld	s5,8(sp)
    }
    ret = 0;
ffffffffc0203812:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203814:	70e2                	ld	ra,56(sp)
ffffffffc0203816:	7442                	ld	s0,48(sp)
ffffffffc0203818:	74a2                	ld	s1,40(sp)
ffffffffc020381a:	6121                	addi	sp,sp,64
ffffffffc020381c:	8082                	ret
ffffffffc020381e:	70e2                	ld	ra,56(sp)
ffffffffc0203820:	7442                	ld	s0,48(sp)
ffffffffc0203822:	7902                	ld	s2,32(sp)
ffffffffc0203824:	69e2                	ld	s3,24(sp)
ffffffffc0203826:	6a42                	ld	s4,16(sp)
ffffffffc0203828:	6aa2                	ld	s5,8(sp)
ffffffffc020382a:	74a2                	ld	s1,40(sp)
ffffffffc020382c:	6121                	addi	sp,sp,64
ffffffffc020382e:	8082                	ret
ffffffffc0203830:	69e2                	ld	s3,24(sp)
ffffffffc0203832:	6a42                	ld	s4,16(sp)
ffffffffc0203834:	6aa2                	ld	s5,8(sp)
        return -E_INVAL;
ffffffffc0203836:	5575                	li	a0,-3
ffffffffc0203838:	bff1                	j	ffffffffc0203814 <mm_map+0x82>
    assert(mm != NULL);
ffffffffc020383a:	00003697          	auipc	a3,0x3
ffffffffc020383e:	3ee68693          	addi	a3,a3,1006 # ffffffffc0206c28 <etext+0x1578>
ffffffffc0203842:	00003617          	auipc	a2,0x3
ffffffffc0203846:	84e60613          	addi	a2,a2,-1970 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020384a:	0b300593          	li	a1,179
ffffffffc020384e:	00003517          	auipc	a0,0x3
ffffffffc0203852:	35250513          	addi	a0,a0,850 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203856:	f04a                	sd	s2,32(sp)
ffffffffc0203858:	e852                	sd	s4,16(sp)
ffffffffc020385a:	e456                	sd	s5,8(sp)
ffffffffc020385c:	c2dfc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203860 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203860:	7139                	addi	sp,sp,-64
ffffffffc0203862:	fc06                	sd	ra,56(sp)
ffffffffc0203864:	f822                	sd	s0,48(sp)
ffffffffc0203866:	f426                	sd	s1,40(sp)
ffffffffc0203868:	f04a                	sd	s2,32(sp)
ffffffffc020386a:	ec4e                	sd	s3,24(sp)
ffffffffc020386c:	e852                	sd	s4,16(sp)
ffffffffc020386e:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203870:	c525                	beqz	a0,ffffffffc02038d8 <dup_mmap+0x78>
ffffffffc0203872:	892a                	mv	s2,a0
ffffffffc0203874:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203876:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203878:	c1a5                	beqz	a1,ffffffffc02038d8 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc020387a:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc020387c:	04848c63          	beq	s1,s0,ffffffffc02038d4 <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203880:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203884:	fe843a83          	ld	s5,-24(s0) # ffffffffc01fffe8 <_binary_obj___user_exit_out_size+0xffffffffc01f6480>
ffffffffc0203888:	ff043a03          	ld	s4,-16(s0)
ffffffffc020388c:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203890:	bd4fe0ef          	jal	ffffffffc0201c64 <kmalloc>
ffffffffc0203894:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203896:	c50d                	beqz	a0,ffffffffc02038c0 <dup_mmap+0x60>
        vma->vm_start = vm_start;
ffffffffc0203898:	01553423          	sd	s5,8(a0)
ffffffffc020389c:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02038a0:	01352c23          	sw	s3,24(a0)
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02038a4:	854a                	mv	a0,s2
ffffffffc02038a6:	dcbff0ef          	jal	ffffffffc0203670 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc02038aa:	ff043683          	ld	a3,-16(s0)
ffffffffc02038ae:	fe843603          	ld	a2,-24(s0)
ffffffffc02038b2:	6c8c                	ld	a1,24(s1)
ffffffffc02038b4:	01893503          	ld	a0,24(s2)
ffffffffc02038b8:	4701                	li	a4,0
ffffffffc02038ba:	cc1fe0ef          	jal	ffffffffc020257a <copy_range>
ffffffffc02038be:	dd55                	beqz	a0,ffffffffc020387a <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc02038c0:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc02038c2:	70e2                	ld	ra,56(sp)
ffffffffc02038c4:	7442                	ld	s0,48(sp)
ffffffffc02038c6:	74a2                	ld	s1,40(sp)
ffffffffc02038c8:	7902                	ld	s2,32(sp)
ffffffffc02038ca:	69e2                	ld	s3,24(sp)
ffffffffc02038cc:	6a42                	ld	s4,16(sp)
ffffffffc02038ce:	6aa2                	ld	s5,8(sp)
ffffffffc02038d0:	6121                	addi	sp,sp,64
ffffffffc02038d2:	8082                	ret
    return 0;
ffffffffc02038d4:	4501                	li	a0,0
ffffffffc02038d6:	b7f5                	j	ffffffffc02038c2 <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc02038d8:	00003697          	auipc	a3,0x3
ffffffffc02038dc:	36068693          	addi	a3,a3,864 # ffffffffc0206c38 <etext+0x1588>
ffffffffc02038e0:	00002617          	auipc	a2,0x2
ffffffffc02038e4:	7b060613          	addi	a2,a2,1968 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02038e8:	0cf00593          	li	a1,207
ffffffffc02038ec:	00003517          	auipc	a0,0x3
ffffffffc02038f0:	2b450513          	addi	a0,a0,692 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc02038f4:	b95fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02038f8 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02038f8:	1101                	addi	sp,sp,-32
ffffffffc02038fa:	ec06                	sd	ra,24(sp)
ffffffffc02038fc:	e822                	sd	s0,16(sp)
ffffffffc02038fe:	e426                	sd	s1,8(sp)
ffffffffc0203900:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203902:	c531                	beqz	a0,ffffffffc020394e <exit_mmap+0x56>
ffffffffc0203904:	591c                	lw	a5,48(a0)
ffffffffc0203906:	84aa                	mv	s1,a0
ffffffffc0203908:	e3b9                	bnez	a5,ffffffffc020394e <exit_mmap+0x56>
    return listelm->next;
ffffffffc020390a:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc020390c:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203910:	02850663          	beq	a0,s0,ffffffffc020393c <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203914:	ff043603          	ld	a2,-16(s0)
ffffffffc0203918:	fe843583          	ld	a1,-24(s0)
ffffffffc020391c:	854a                	mv	a0,s2
ffffffffc020391e:	859fe0ef          	jal	ffffffffc0202176 <unmap_range>
ffffffffc0203922:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203924:	fe8498e3          	bne	s1,s0,ffffffffc0203914 <exit_mmap+0x1c>
ffffffffc0203928:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc020392a:	00848c63          	beq	s1,s0,ffffffffc0203942 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc020392e:	ff043603          	ld	a2,-16(s0)
ffffffffc0203932:	fe843583          	ld	a1,-24(s0)
ffffffffc0203936:	854a                	mv	a0,s2
ffffffffc0203938:	969fe0ef          	jal	ffffffffc02022a0 <exit_range>
ffffffffc020393c:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc020393e:	fe8498e3          	bne	s1,s0,ffffffffc020392e <exit_mmap+0x36>
    }
}
ffffffffc0203942:	60e2                	ld	ra,24(sp)
ffffffffc0203944:	6442                	ld	s0,16(sp)
ffffffffc0203946:	64a2                	ld	s1,8(sp)
ffffffffc0203948:	6902                	ld	s2,0(sp)
ffffffffc020394a:	6105                	addi	sp,sp,32
ffffffffc020394c:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc020394e:	00003697          	auipc	a3,0x3
ffffffffc0203952:	30a68693          	addi	a3,a3,778 # ffffffffc0206c58 <etext+0x15a8>
ffffffffc0203956:	00002617          	auipc	a2,0x2
ffffffffc020395a:	73a60613          	addi	a2,a2,1850 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020395e:	0e800593          	li	a1,232
ffffffffc0203962:	00003517          	auipc	a0,0x3
ffffffffc0203966:	23e50513          	addi	a0,a0,574 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc020396a:	b1ffc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020396e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc020396e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203970:	04000513          	li	a0,64
{
ffffffffc0203974:	fc06                	sd	ra,56(sp)
ffffffffc0203976:	f822                	sd	s0,48(sp)
ffffffffc0203978:	f426                	sd	s1,40(sp)
ffffffffc020397a:	f04a                	sd	s2,32(sp)
ffffffffc020397c:	ec4e                	sd	s3,24(sp)
ffffffffc020397e:	e852                	sd	s4,16(sp)
ffffffffc0203980:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203982:	ae2fe0ef          	jal	ffffffffc0201c64 <kmalloc>
    if (mm != NULL)
ffffffffc0203986:	18050163          	beqz	a0,ffffffffc0203b08 <vmm_init+0x19a>
ffffffffc020398a:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc020398c:	e508                	sd	a0,8(a0)
ffffffffc020398e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203990:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203994:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203998:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020399c:	02053423          	sd	zero,40(a0)
ffffffffc02039a0:	02052823          	sw	zero,48(a0)
ffffffffc02039a4:	02053c23          	sd	zero,56(a0)
ffffffffc02039a8:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039ac:	03000513          	li	a0,48
ffffffffc02039b0:	ab4fe0ef          	jal	ffffffffc0201c64 <kmalloc>
ffffffffc02039b4:	00248913          	addi	s2,s1,2
ffffffffc02039b8:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc02039ba:	12050763          	beqz	a0,ffffffffc0203ae8 <vmm_init+0x17a>
        vma->vm_start = vm_start;
ffffffffc02039be:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc02039c0:	01253823          	sd	s2,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02039c4:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc02039c8:	14ed                	addi	s1,s1,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02039ca:	8522                	mv	a0,s0
ffffffffc02039cc:	ca5ff0ef          	jal	ffffffffc0203670 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc02039d0:	fcf1                	bnez	s1,ffffffffc02039ac <vmm_init+0x3e>
ffffffffc02039d2:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039d6:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039da:	03000513          	li	a0,48
ffffffffc02039de:	a86fe0ef          	jal	ffffffffc0201c64 <kmalloc>
ffffffffc02039e2:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc02039e4:	14050263          	beqz	a0,ffffffffc0203b28 <vmm_init+0x1ba>
        vma->vm_end = vm_end;
ffffffffc02039e8:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc02039ec:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc02039ee:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02039f0:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039f4:	0495                	addi	s1,s1,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02039f6:	8522                	mv	a0,s0
ffffffffc02039f8:	c79ff0ef          	jal	ffffffffc0203670 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039fc:	fd249fe3          	bne	s1,s2,ffffffffc02039da <vmm_init+0x6c>
    return listelm->next;
ffffffffc0203a00:	641c                	ld	a5,8(s0)

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203a02:	1a878363          	beq	a5,s0,ffffffffc0203ba8 <vmm_init+0x23a>
ffffffffc0203a06:	4715                	li	a4,5
    for (i = 1; i <= step2; i++)
ffffffffc0203a08:	1f400593          	li	a1,500
ffffffffc0203a0c:	a021                	j	ffffffffc0203a14 <vmm_init+0xa6>
        assert(le != &(mm->mmap_list));
ffffffffc0203a0e:	0715                	addi	a4,a4,5
ffffffffc0203a10:	18878c63          	beq	a5,s0,ffffffffc0203ba8 <vmm_init+0x23a>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203a14:	fe87b683          	ld	a3,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f6480>
ffffffffc0203a18:	16e69863          	bne	a3,a4,ffffffffc0203b88 <vmm_init+0x21a>
ffffffffc0203a1c:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203a20:	00270693          	addi	a3,a4,2
ffffffffc0203a24:	16d61263          	bne	a2,a3,ffffffffc0203b88 <vmm_init+0x21a>
ffffffffc0203a28:	679c                	ld	a5,8(a5)
    for (i = 1; i <= step2; i++)
ffffffffc0203a2a:	feb712e3          	bne	a4,a1,ffffffffc0203a0e <vmm_init+0xa0>
ffffffffc0203a2e:	4a1d                	li	s4,7
ffffffffc0203a30:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a32:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203a36:	85a6                	mv	a1,s1
ffffffffc0203a38:	8522                	mv	a0,s0
ffffffffc0203a3a:	bf7ff0ef          	jal	ffffffffc0203630 <find_vma>
ffffffffc0203a3e:	89aa                	mv	s3,a0
        assert(vma1 != NULL);
ffffffffc0203a40:	1a050463          	beqz	a0,ffffffffc0203be8 <vmm_init+0x27a>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203a44:	00148593          	addi	a1,s1,1
ffffffffc0203a48:	8522                	mv	a0,s0
ffffffffc0203a4a:	be7ff0ef          	jal	ffffffffc0203630 <find_vma>
ffffffffc0203a4e:	892a                	mv	s2,a0
        assert(vma2 != NULL);
ffffffffc0203a50:	16050c63          	beqz	a0,ffffffffc0203bc8 <vmm_init+0x25a>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203a54:	85d2                	mv	a1,s4
ffffffffc0203a56:	8522                	mv	a0,s0
ffffffffc0203a58:	bd9ff0ef          	jal	ffffffffc0203630 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203a5c:	1e051663          	bnez	a0,ffffffffc0203c48 <vmm_init+0x2da>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203a60:	00348593          	addi	a1,s1,3
ffffffffc0203a64:	8522                	mv	a0,s0
ffffffffc0203a66:	bcbff0ef          	jal	ffffffffc0203630 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203a6a:	1a051f63          	bnez	a0,ffffffffc0203c28 <vmm_init+0x2ba>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203a6e:	00448593          	addi	a1,s1,4
ffffffffc0203a72:	8522                	mv	a0,s0
ffffffffc0203a74:	bbdff0ef          	jal	ffffffffc0203630 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203a78:	18051863          	bnez	a0,ffffffffc0203c08 <vmm_init+0x29a>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203a7c:	0089b783          	ld	a5,8(s3)
ffffffffc0203a80:	0e979463          	bne	a5,s1,ffffffffc0203b68 <vmm_init+0x1fa>
ffffffffc0203a84:	0109b783          	ld	a5,16(s3)
ffffffffc0203a88:	0f479063          	bne	a5,s4,ffffffffc0203b68 <vmm_init+0x1fa>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203a8c:	00893783          	ld	a5,8(s2)
ffffffffc0203a90:	0a979c63          	bne	a5,s1,ffffffffc0203b48 <vmm_init+0x1da>
ffffffffc0203a94:	01093783          	ld	a5,16(s2)
ffffffffc0203a98:	0b479863          	bne	a5,s4,ffffffffc0203b48 <vmm_init+0x1da>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a9c:	0495                	addi	s1,s1,5
ffffffffc0203a9e:	0a15                	addi	s4,s4,5
ffffffffc0203aa0:	f9549be3          	bne	s1,s5,ffffffffc0203a36 <vmm_init+0xc8>
ffffffffc0203aa4:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203aa6:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203aa8:	85a6                	mv	a1,s1
ffffffffc0203aaa:	8522                	mv	a0,s0
ffffffffc0203aac:	b85ff0ef          	jal	ffffffffc0203630 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203ab0:	1a051c63          	bnez	a0,ffffffffc0203c68 <vmm_init+0x2fa>
    for (i = 4; i >= 0; i--)
ffffffffc0203ab4:	14fd                	addi	s1,s1,-1
ffffffffc0203ab6:	ff2499e3          	bne	s1,s2,ffffffffc0203aa8 <vmm_init+0x13a>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203aba:	8522                	mv	a0,s0
ffffffffc0203abc:	c85ff0ef          	jal	ffffffffc0203740 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203ac0:	00003517          	auipc	a0,0x3
ffffffffc0203ac4:	30850513          	addi	a0,a0,776 # ffffffffc0206dc8 <etext+0x1718>
ffffffffc0203ac8:	eccfc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203acc:	7442                	ld	s0,48(sp)
ffffffffc0203ace:	70e2                	ld	ra,56(sp)
ffffffffc0203ad0:	74a2                	ld	s1,40(sp)
ffffffffc0203ad2:	7902                	ld	s2,32(sp)
ffffffffc0203ad4:	69e2                	ld	s3,24(sp)
ffffffffc0203ad6:	6a42                	ld	s4,16(sp)
ffffffffc0203ad8:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203ada:	00003517          	auipc	a0,0x3
ffffffffc0203ade:	30e50513          	addi	a0,a0,782 # ffffffffc0206de8 <etext+0x1738>
}
ffffffffc0203ae2:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203ae4:	eb0fc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203ae8:	00003697          	auipc	a3,0x3
ffffffffc0203aec:	19068693          	addi	a3,a3,400 # ffffffffc0206c78 <etext+0x15c8>
ffffffffc0203af0:	00002617          	auipc	a2,0x2
ffffffffc0203af4:	5a060613          	addi	a2,a2,1440 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203af8:	12c00593          	li	a1,300
ffffffffc0203afc:	00003517          	auipc	a0,0x3
ffffffffc0203b00:	0a450513          	addi	a0,a0,164 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203b04:	985fc0ef          	jal	ffffffffc0200488 <__panic>
    assert(mm != NULL);
ffffffffc0203b08:	00003697          	auipc	a3,0x3
ffffffffc0203b0c:	12068693          	addi	a3,a3,288 # ffffffffc0206c28 <etext+0x1578>
ffffffffc0203b10:	00002617          	auipc	a2,0x2
ffffffffc0203b14:	58060613          	addi	a2,a2,1408 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203b18:	12400593          	li	a1,292
ffffffffc0203b1c:	00003517          	auipc	a0,0x3
ffffffffc0203b20:	08450513          	addi	a0,a0,132 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203b24:	965fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma != NULL);
ffffffffc0203b28:	00003697          	auipc	a3,0x3
ffffffffc0203b2c:	15068693          	addi	a3,a3,336 # ffffffffc0206c78 <etext+0x15c8>
ffffffffc0203b30:	00002617          	auipc	a2,0x2
ffffffffc0203b34:	56060613          	addi	a2,a2,1376 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203b38:	13300593          	li	a1,307
ffffffffc0203b3c:	00003517          	auipc	a0,0x3
ffffffffc0203b40:	06450513          	addi	a0,a0,100 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203b44:	945fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b48:	00003697          	auipc	a3,0x3
ffffffffc0203b4c:	21068693          	addi	a3,a3,528 # ffffffffc0206d58 <etext+0x16a8>
ffffffffc0203b50:	00002617          	auipc	a2,0x2
ffffffffc0203b54:	54060613          	addi	a2,a2,1344 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203b58:	14f00593          	li	a1,335
ffffffffc0203b5c:	00003517          	auipc	a0,0x3
ffffffffc0203b60:	04450513          	addi	a0,a0,68 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203b64:	925fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b68:	00003697          	auipc	a3,0x3
ffffffffc0203b6c:	1c068693          	addi	a3,a3,448 # ffffffffc0206d28 <etext+0x1678>
ffffffffc0203b70:	00002617          	auipc	a2,0x2
ffffffffc0203b74:	52060613          	addi	a2,a2,1312 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203b78:	14e00593          	li	a1,334
ffffffffc0203b7c:	00003517          	auipc	a0,0x3
ffffffffc0203b80:	02450513          	addi	a0,a0,36 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203b84:	905fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b88:	00003697          	auipc	a3,0x3
ffffffffc0203b8c:	11868693          	addi	a3,a3,280 # ffffffffc0206ca0 <etext+0x15f0>
ffffffffc0203b90:	00002617          	auipc	a2,0x2
ffffffffc0203b94:	50060613          	addi	a2,a2,1280 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203b98:	13d00593          	li	a1,317
ffffffffc0203b9c:	00003517          	auipc	a0,0x3
ffffffffc0203ba0:	00450513          	addi	a0,a0,4 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203ba4:	8e5fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203ba8:	00003697          	auipc	a3,0x3
ffffffffc0203bac:	0e068693          	addi	a3,a3,224 # ffffffffc0206c88 <etext+0x15d8>
ffffffffc0203bb0:	00002617          	auipc	a2,0x2
ffffffffc0203bb4:	4e060613          	addi	a2,a2,1248 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203bb8:	13b00593          	li	a1,315
ffffffffc0203bbc:	00003517          	auipc	a0,0x3
ffffffffc0203bc0:	fe450513          	addi	a0,a0,-28 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203bc4:	8c5fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma2 != NULL);
ffffffffc0203bc8:	00003697          	auipc	a3,0x3
ffffffffc0203bcc:	12068693          	addi	a3,a3,288 # ffffffffc0206ce8 <etext+0x1638>
ffffffffc0203bd0:	00002617          	auipc	a2,0x2
ffffffffc0203bd4:	4c060613          	addi	a2,a2,1216 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203bd8:	14600593          	li	a1,326
ffffffffc0203bdc:	00003517          	auipc	a0,0x3
ffffffffc0203be0:	fc450513          	addi	a0,a0,-60 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203be4:	8a5fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma1 != NULL);
ffffffffc0203be8:	00003697          	auipc	a3,0x3
ffffffffc0203bec:	0f068693          	addi	a3,a3,240 # ffffffffc0206cd8 <etext+0x1628>
ffffffffc0203bf0:	00002617          	auipc	a2,0x2
ffffffffc0203bf4:	4a060613          	addi	a2,a2,1184 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203bf8:	14400593          	li	a1,324
ffffffffc0203bfc:	00003517          	auipc	a0,0x3
ffffffffc0203c00:	fa450513          	addi	a0,a0,-92 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203c04:	885fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma5 == NULL);
ffffffffc0203c08:	00003697          	auipc	a3,0x3
ffffffffc0203c0c:	11068693          	addi	a3,a3,272 # ffffffffc0206d18 <etext+0x1668>
ffffffffc0203c10:	00002617          	auipc	a2,0x2
ffffffffc0203c14:	48060613          	addi	a2,a2,1152 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203c18:	14c00593          	li	a1,332
ffffffffc0203c1c:	00003517          	auipc	a0,0x3
ffffffffc0203c20:	f8450513          	addi	a0,a0,-124 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203c24:	865fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma4 == NULL);
ffffffffc0203c28:	00003697          	auipc	a3,0x3
ffffffffc0203c2c:	0e068693          	addi	a3,a3,224 # ffffffffc0206d08 <etext+0x1658>
ffffffffc0203c30:	00002617          	auipc	a2,0x2
ffffffffc0203c34:	46060613          	addi	a2,a2,1120 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203c38:	14a00593          	li	a1,330
ffffffffc0203c3c:	00003517          	auipc	a0,0x3
ffffffffc0203c40:	f6450513          	addi	a0,a0,-156 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203c44:	845fc0ef          	jal	ffffffffc0200488 <__panic>
        assert(vma3 == NULL);
ffffffffc0203c48:	00003697          	auipc	a3,0x3
ffffffffc0203c4c:	0b068693          	addi	a3,a3,176 # ffffffffc0206cf8 <etext+0x1648>
ffffffffc0203c50:	00002617          	auipc	a2,0x2
ffffffffc0203c54:	44060613          	addi	a2,a2,1088 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203c58:	14800593          	li	a1,328
ffffffffc0203c5c:	00003517          	auipc	a0,0x3
ffffffffc0203c60:	f4450513          	addi	a0,a0,-188 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203c64:	825fc0ef          	jal	ffffffffc0200488 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203c68:	6914                	ld	a3,16(a0)
ffffffffc0203c6a:	6510                	ld	a2,8(a0)
ffffffffc0203c6c:	0004859b          	sext.w	a1,s1
ffffffffc0203c70:	00003517          	auipc	a0,0x3
ffffffffc0203c74:	11850513          	addi	a0,a0,280 # ffffffffc0206d88 <etext+0x16d8>
ffffffffc0203c78:	d1cfc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203c7c:	00003697          	auipc	a3,0x3
ffffffffc0203c80:	13468693          	addi	a3,a3,308 # ffffffffc0206db0 <etext+0x1700>
ffffffffc0203c84:	00002617          	auipc	a2,0x2
ffffffffc0203c88:	40c60613          	addi	a2,a2,1036 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0203c8c:	15900593          	li	a1,345
ffffffffc0203c90:	00003517          	auipc	a0,0x3
ffffffffc0203c94:	f1050513          	addi	a0,a0,-240 # ffffffffc0206ba0 <etext+0x14f0>
ffffffffc0203c98:	ff0fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203c9c <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203c9c:	7179                	addi	sp,sp,-48
ffffffffc0203c9e:	f022                	sd	s0,32(sp)
ffffffffc0203ca0:	f406                	sd	ra,40(sp)
ffffffffc0203ca2:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203ca4:	c535                	beqz	a0,ffffffffc0203d10 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203ca6:	002007b7          	lui	a5,0x200
ffffffffc0203caa:	04f5ee63          	bltu	a1,a5,ffffffffc0203d06 <user_mem_check+0x6a>
ffffffffc0203cae:	ec26                	sd	s1,24(sp)
ffffffffc0203cb0:	00c584b3          	add	s1,a1,a2
ffffffffc0203cb4:	0695fc63          	bgeu	a1,s1,ffffffffc0203d2c <user_mem_check+0x90>
ffffffffc0203cb8:	4785                	li	a5,1
ffffffffc0203cba:	07fe                	slli	a5,a5,0x1f
ffffffffc0203cbc:	0697e863          	bltu	a5,s1,ffffffffc0203d2c <user_mem_check+0x90>
ffffffffc0203cc0:	e84a                	sd	s2,16(sp)
ffffffffc0203cc2:	e44e                	sd	s3,8(sp)
ffffffffc0203cc4:	e052                	sd	s4,0(sp)
ffffffffc0203cc6:	892a                	mv	s2,a0
ffffffffc0203cc8:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203cca:	6a05                	lui	s4,0x1
ffffffffc0203ccc:	a821                	j	ffffffffc0203ce4 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203cce:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203cd2:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203cd4:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203cd6:	c685                	beqz	a3,ffffffffc0203cfe <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203cd8:	c399                	beqz	a5,ffffffffc0203cde <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203cda:	02e46263          	bltu	s0,a4,ffffffffc0203cfe <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203cde:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203ce0:	04947863          	bgeu	s0,s1,ffffffffc0203d30 <user_mem_check+0x94>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203ce4:	85a2                	mv	a1,s0
ffffffffc0203ce6:	854a                	mv	a0,s2
ffffffffc0203ce8:	949ff0ef          	jal	ffffffffc0203630 <find_vma>
ffffffffc0203cec:	c909                	beqz	a0,ffffffffc0203cfe <user_mem_check+0x62>
ffffffffc0203cee:	6518                	ld	a4,8(a0)
ffffffffc0203cf0:	00e46763          	bltu	s0,a4,ffffffffc0203cfe <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203cf4:	4d1c                	lw	a5,24(a0)
ffffffffc0203cf6:	fc099ce3          	bnez	s3,ffffffffc0203cce <user_mem_check+0x32>
ffffffffc0203cfa:	8b85                	andi	a5,a5,1
ffffffffc0203cfc:	f3ed                	bnez	a5,ffffffffc0203cde <user_mem_check+0x42>
ffffffffc0203cfe:	64e2                	ld	s1,24(sp)
ffffffffc0203d00:	6942                	ld	s2,16(sp)
ffffffffc0203d02:	69a2                	ld	s3,8(sp)
ffffffffc0203d04:	6a02                	ld	s4,0(sp)
            return 0;
ffffffffc0203d06:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d08:	70a2                	ld	ra,40(sp)
ffffffffc0203d0a:	7402                	ld	s0,32(sp)
ffffffffc0203d0c:	6145                	addi	sp,sp,48
ffffffffc0203d0e:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203d10:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d14:	4501                	li	a0,0
ffffffffc0203d16:	fef5e9e3          	bltu	a1,a5,ffffffffc0203d08 <user_mem_check+0x6c>
ffffffffc0203d1a:	962e                	add	a2,a2,a1
ffffffffc0203d1c:	fec5f6e3          	bgeu	a1,a2,ffffffffc0203d08 <user_mem_check+0x6c>
ffffffffc0203d20:	c8000537          	lui	a0,0xc8000
ffffffffc0203d24:	0505                	addi	a0,a0,1 # ffffffffc8000001 <end+0x7d6a491>
ffffffffc0203d26:	00a63533          	sltu	a0,a2,a0
ffffffffc0203d2a:	bff9                	j	ffffffffc0203d08 <user_mem_check+0x6c>
ffffffffc0203d2c:	64e2                	ld	s1,24(sp)
ffffffffc0203d2e:	bfe1                	j	ffffffffc0203d06 <user_mem_check+0x6a>
ffffffffc0203d30:	64e2                	ld	s1,24(sp)
ffffffffc0203d32:	6942                	ld	s2,16(sp)
ffffffffc0203d34:	69a2                	ld	s3,8(sp)
ffffffffc0203d36:	6a02                	ld	s4,0(sp)
        return 1;
ffffffffc0203d38:	4505                	li	a0,1
ffffffffc0203d3a:	b7f9                	j	ffffffffc0203d08 <user_mem_check+0x6c>

ffffffffc0203d3c <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203d3c:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203d3e:	9402                	jalr	s0

	jal do_exit
ffffffffc0203d40:	63e000ef          	jal	ffffffffc020437e <do_exit>

ffffffffc0203d44 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203d44:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d46:	10800513          	li	a0,264
{
ffffffffc0203d4a:	e022                	sd	s0,0(sp)
ffffffffc0203d4c:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203d4e:	f17fd0ef          	jal	ffffffffc0201c64 <kmalloc>
ffffffffc0203d52:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203d54:	c525                	beqz	a0,ffffffffc0203dbc <alloc_proc+0x78>
    {
        proc->state = PROC_UNINIT;
ffffffffc0203d56:	57fd                	li	a5,-1
ffffffffc0203d58:	1782                	slli	a5,a5,0x20
ffffffffc0203d5a:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203d5c:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203d60:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203d64:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203d68:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203d6c:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203d70:	07000613          	li	a2,112
ffffffffc0203d74:	4581                	li	a1,0
ffffffffc0203d76:	03050513          	addi	a0,a0,48
ffffffffc0203d7a:	10d010ef          	jal	ffffffffc0205686 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203d7e:	00092797          	auipc	a5,0x92
ffffffffc0203d82:	daa7b783          	ld	a5,-598(a5) # ffffffffc0295b28 <boot_pgdir_pa>
ffffffffc0203d86:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203d88:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203d8c:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203d90:	4641                	li	a2,16
ffffffffc0203d92:	4581                	li	a1,0
ffffffffc0203d94:	0b440513          	addi	a0,s0,180
ffffffffc0203d98:	0ef010ef          	jal	ffffffffc0205686 <memset>
        list_init(&(proc->list_link));
ffffffffc0203d9c:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203da0:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc0203da4:	e878                	sd	a4,208(s0)
ffffffffc0203da6:	e478                	sd	a4,200(s0)
ffffffffc0203da8:	f07c                	sd	a5,224(s0)
ffffffffc0203daa:	ec7c                	sd	a5,216(s0)
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
ffffffffc0203dac:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203db0:	10043023          	sd	zero,256(s0)
ffffffffc0203db4:	0e043c23          	sd	zero,248(s0)
ffffffffc0203db8:	0e043823          	sd	zero,240(s0)
    }
    return proc;
}
ffffffffc0203dbc:	60a2                	ld	ra,8(sp)
ffffffffc0203dbe:	8522                	mv	a0,s0
ffffffffc0203dc0:	6402                	ld	s0,0(sp)
ffffffffc0203dc2:	0141                	addi	sp,sp,16
ffffffffc0203dc4:	8082                	ret

ffffffffc0203dc6 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203dc6:	00092797          	auipc	a5,0x92
ffffffffc0203dca:	d927b783          	ld	a5,-622(a5) # ffffffffc0295b58 <current>
ffffffffc0203dce:	73c8                	ld	a0,160(a5)
ffffffffc0203dd0:	926fd06f          	j	ffffffffc0200ef6 <forkrets>

ffffffffc0203dd4 <user_main>:
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
ffffffffc0203dd4:	00092797          	auipc	a5,0x92
ffffffffc0203dd8:	d847b783          	ld	a5,-636(a5) # ffffffffc0295b58 <current>
ffffffffc0203ddc:	43cc                	lw	a1,4(a5)
{
ffffffffc0203dde:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(exit);
ffffffffc0203de0:	00003617          	auipc	a2,0x3
ffffffffc0203de4:	02060613          	addi	a2,a2,32 # ffffffffc0206e00 <etext+0x1750>
ffffffffc0203de8:	00003517          	auipc	a0,0x3
ffffffffc0203dec:	02050513          	addi	a0,a0,32 # ffffffffc0206e08 <etext+0x1758>
{
ffffffffc0203df0:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(exit);
ffffffffc0203df2:	ba2fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203df6:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0203dfa:	d7278793          	addi	a5,a5,-654 # 9b68 <_binary_obj___user_exit_out_size>
ffffffffc0203dfe:	e43e                	sd	a5,8(sp)
ffffffffc0203e00:	00003517          	auipc	a0,0x3
ffffffffc0203e04:	00050513          	mv	a0,a0
ffffffffc0203e08:	00022797          	auipc	a5,0x22
ffffffffc0203e0c:	38078793          	addi	a5,a5,896 # ffffffffc0226188 <_binary_obj___user_exit_out_start>
ffffffffc0203e10:	f03e                	sd	a5,32(sp)
ffffffffc0203e12:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203e14:	e802                	sd	zero,16(sp)
ffffffffc0203e16:	7b2010ef          	jal	ffffffffc02055c8 <strlen>
ffffffffc0203e1a:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203e1c:	4511                	li	a0,4
ffffffffc0203e1e:	55a2                	lw	a1,40(sp)
ffffffffc0203e20:	4662                	lw	a2,24(sp)
ffffffffc0203e22:	5682                	lw	a3,32(sp)
ffffffffc0203e24:	4722                	lw	a4,8(sp)
ffffffffc0203e26:	48a9                	li	a7,10
ffffffffc0203e28:	9002                	ebreak
ffffffffc0203e2a:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203e2c:	65c2                	ld	a1,16(sp)
ffffffffc0203e2e:	00003517          	auipc	a0,0x3
ffffffffc0203e32:	00250513          	addi	a0,a0,2 # ffffffffc0206e30 <etext+0x1780>
ffffffffc0203e36:	b5efc0ef          	jal	ffffffffc0200194 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc0203e3a:	00003617          	auipc	a2,0x3
ffffffffc0203e3e:	00660613          	addi	a2,a2,6 # ffffffffc0206e40 <etext+0x1790>
ffffffffc0203e42:	3c000593          	li	a1,960
ffffffffc0203e46:	00003517          	auipc	a0,0x3
ffffffffc0203e4a:	01a50513          	addi	a0,a0,26 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0203e4e:	e3afc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203e52 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203e52:	6d14                	ld	a3,24(a0)
{
ffffffffc0203e54:	1141                	addi	sp,sp,-16
ffffffffc0203e56:	e406                	sd	ra,8(sp)
ffffffffc0203e58:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e5c:	02f6ee63          	bltu	a3,a5,ffffffffc0203e98 <put_pgdir+0x46>
ffffffffc0203e60:	00092797          	auipc	a5,0x92
ffffffffc0203e64:	cd87b783          	ld	a5,-808(a5) # ffffffffc0295b38 <va_pa_offset>
ffffffffc0203e68:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0203e6a:	82b1                	srli	a3,a3,0xc
ffffffffc0203e6c:	00092797          	auipc	a5,0x92
ffffffffc0203e70:	cd47b783          	ld	a5,-812(a5) # ffffffffc0295b40 <npage>
ffffffffc0203e74:	02f6fe63          	bgeu	a3,a5,ffffffffc0203eb0 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203e78:	00004797          	auipc	a5,0x4
ffffffffc0203e7c:	9907b783          	ld	a5,-1648(a5) # ffffffffc0207808 <nbase>
}
ffffffffc0203e80:	60a2                	ld	ra,8(sp)
ffffffffc0203e82:	8e9d                	sub	a3,a3,a5
    free_page(kva2page(mm->pgdir));
ffffffffc0203e84:	00092517          	auipc	a0,0x92
ffffffffc0203e88:	cc453503          	ld	a0,-828(a0) # ffffffffc0295b48 <pages>
ffffffffc0203e8c:	069a                	slli	a3,a3,0x6
ffffffffc0203e8e:	4585                	li	a1,1
ffffffffc0203e90:	9536                	add	a0,a0,a3
}
ffffffffc0203e92:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203e94:	fe7fd06f          	j	ffffffffc0201e7a <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203e98:	00002617          	auipc	a2,0x2
ffffffffc0203e9c:	65060613          	addi	a2,a2,1616 # ffffffffc02064e8 <etext+0xe38>
ffffffffc0203ea0:	07700593          	li	a1,119
ffffffffc0203ea4:	00002517          	auipc	a0,0x2
ffffffffc0203ea8:	5c450513          	addi	a0,a0,1476 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0203eac:	ddcfc0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203eb0:	00002617          	auipc	a2,0x2
ffffffffc0203eb4:	66060613          	addi	a2,a2,1632 # ffffffffc0206510 <etext+0xe60>
ffffffffc0203eb8:	06900593          	li	a1,105
ffffffffc0203ebc:	00002517          	auipc	a0,0x2
ffffffffc0203ec0:	5ac50513          	addi	a0,a0,1452 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0203ec4:	dc4fc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0203ec8 <proc_run>:
{
ffffffffc0203ec8:	7179                	addi	sp,sp,-48
ffffffffc0203eca:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203ecc:	00092917          	auipc	s2,0x92
ffffffffc0203ed0:	c8c90913          	addi	s2,s2,-884 # ffffffffc0295b58 <current>
{
ffffffffc0203ed4:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203ed6:	00093483          	ld	s1,0(s2)
{
ffffffffc0203eda:	f406                	sd	ra,40(sp)
    if (proc != current)
ffffffffc0203edc:	02a48a63          	beq	s1,a0,ffffffffc0203f10 <proc_run+0x48>
ffffffffc0203ee0:	e84e                	sd	s3,16(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203ee2:	100027f3          	csrr	a5,sstatus
ffffffffc0203ee6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203ee8:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203eea:	ef9d                	bnez	a5,ffffffffc0203f28 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203eec:	755c                	ld	a5,168(a0)
ffffffffc0203eee:	577d                	li	a4,-1
ffffffffc0203ef0:	177e                	slli	a4,a4,0x3f
ffffffffc0203ef2:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0203ef4:	00a93023          	sd	a0,0(s2)
ffffffffc0203ef8:	8fd9                	or	a5,a5,a4
ffffffffc0203efa:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc0203efe:	03050593          	addi	a1,a0,48
ffffffffc0203f02:	03048513          	addi	a0,s1,48
ffffffffc0203f06:	054010ef          	jal	ffffffffc0204f5a <switch_to>
    if (flag)
ffffffffc0203f0a:	00099863          	bnez	s3,ffffffffc0203f1a <proc_run+0x52>
ffffffffc0203f0e:	69c2                	ld	s3,16(sp)
}
ffffffffc0203f10:	70a2                	ld	ra,40(sp)
ffffffffc0203f12:	7482                	ld	s1,32(sp)
ffffffffc0203f14:	6962                	ld	s2,24(sp)
ffffffffc0203f16:	6145                	addi	sp,sp,48
ffffffffc0203f18:	8082                	ret
        intr_enable();
ffffffffc0203f1a:	69c2                	ld	s3,16(sp)
ffffffffc0203f1c:	70a2                	ld	ra,40(sp)
ffffffffc0203f1e:	7482                	ld	s1,32(sp)
ffffffffc0203f20:	6962                	ld	s2,24(sp)
ffffffffc0203f22:	6145                	addi	sp,sp,48
ffffffffc0203f24:	a51fc06f          	j	ffffffffc0200974 <intr_enable>
ffffffffc0203f28:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203f2a:	a51fc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0203f2e:	6522                	ld	a0,8(sp)
ffffffffc0203f30:	4985                	li	s3,1
ffffffffc0203f32:	bf6d                	j	ffffffffc0203eec <proc_run+0x24>

ffffffffc0203f34 <do_fork>:
{
ffffffffc0203f34:	7119                	addi	sp,sp,-128
ffffffffc0203f36:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203f38:	00092917          	auipc	s2,0x92
ffffffffc0203f3c:	c1890913          	addi	s2,s2,-1000 # ffffffffc0295b50 <nr_process>
ffffffffc0203f40:	00092703          	lw	a4,0(s2)
{
ffffffffc0203f44:	fc86                	sd	ra,120(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203f46:	6785                	lui	a5,0x1
ffffffffc0203f48:	32f75063          	bge	a4,a5,ffffffffc0204268 <do_fork+0x334>
ffffffffc0203f4c:	f8a2                	sd	s0,112(sp)
ffffffffc0203f4e:	f4a6                	sd	s1,104(sp)
ffffffffc0203f50:	ecce                	sd	s3,88(sp)
ffffffffc0203f52:	e8d2                	sd	s4,80(sp)
ffffffffc0203f54:	89ae                	mv	s3,a1
ffffffffc0203f56:	8a2a                	mv	s4,a0
ffffffffc0203f58:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203f5a:	debff0ef          	jal	ffffffffc0203d44 <alloc_proc>
ffffffffc0203f5e:	84aa                	mv	s1,a0
ffffffffc0203f60:	2e050863          	beqz	a0,ffffffffc0204250 <do_fork+0x31c>
    proc->parent = current;
ffffffffc0203f64:	f862                	sd	s8,48(sp)
ffffffffc0203f66:	00092c17          	auipc	s8,0x92
ffffffffc0203f6a:	bf2c0c13          	addi	s8,s8,-1038 # ffffffffc0295b58 <current>
ffffffffc0203f6e:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state == 0);
ffffffffc0203f72:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_softint_out_size-0x750c>
    proc->parent = current;
ffffffffc0203f76:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc0203f78:	36071863          	bnez	a4,ffffffffc02042e8 <do_fork+0x3b4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203f7c:	4509                	li	a0,2
ffffffffc0203f7e:	ebffd0ef          	jal	ffffffffc0201e3c <alloc_pages>
    if (page != NULL)
ffffffffc0203f82:	2c050363          	beqz	a0,ffffffffc0204248 <do_fork+0x314>
ffffffffc0203f86:	e4d6                	sd	s5,72(sp)
    return page - pages + nbase;
ffffffffc0203f88:	00092a97          	auipc	s5,0x92
ffffffffc0203f8c:	bc0a8a93          	addi	s5,s5,-1088 # ffffffffc0295b48 <pages>
ffffffffc0203f90:	000ab703          	ld	a4,0(s5)
ffffffffc0203f94:	e0da                	sd	s6,64(sp)
ffffffffc0203f96:	00004b17          	auipc	s6,0x4
ffffffffc0203f9a:	872b0b13          	addi	s6,s6,-1934 # ffffffffc0207808 <nbase>
ffffffffc0203f9e:	000b3783          	ld	a5,0(s6)
ffffffffc0203fa2:	40e506b3          	sub	a3,a0,a4
ffffffffc0203fa6:	fc5e                	sd	s7,56(sp)
    return KADDR(page2pa(page));
ffffffffc0203fa8:	00092b97          	auipc	s7,0x92
ffffffffc0203fac:	b98b8b93          	addi	s7,s7,-1128 # ffffffffc0295b40 <npage>
ffffffffc0203fb0:	ec6e                	sd	s11,24(sp)
    return page - pages + nbase;
ffffffffc0203fb2:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203fb4:	5dfd                	li	s11,-1
ffffffffc0203fb6:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0203fba:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203fbc:	00cddd93          	srli	s11,s11,0xc
ffffffffc0203fc0:	01b6f633          	and	a2,a3,s11
ffffffffc0203fc4:	f06a                	sd	s10,32(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0203fc6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203fc8:	34e67663          	bgeu	a2,a4,ffffffffc0204314 <do_fork+0x3e0>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203fcc:	000c3603          	ld	a2,0(s8)
ffffffffc0203fd0:	00092c17          	auipc	s8,0x92
ffffffffc0203fd4:	b68c0c13          	addi	s8,s8,-1176 # ffffffffc0295b38 <va_pa_offset>
ffffffffc0203fd8:	000c3703          	ld	a4,0(s8)
ffffffffc0203fdc:	02863d03          	ld	s10,40(a2)
ffffffffc0203fe0:	e43e                	sd	a5,8(sp)
ffffffffc0203fe2:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203fe4:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0203fe6:	020d0863          	beqz	s10,ffffffffc0204016 <do_fork+0xe2>
    if (clone_flags & CLONE_VM)
ffffffffc0203fea:	100a7a13          	andi	s4,s4,256
ffffffffc0203fee:	180a0663          	beqz	s4,ffffffffc020417a <do_fork+0x246>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0203ff2:	030d2703          	lw	a4,48(s10) # ffffffffffe00030 <end+0x3fb6a4c0>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203ff6:	018d3783          	ld	a5,24(s10)
ffffffffc0203ffa:	c02006b7          	lui	a3,0xc0200
ffffffffc0203ffe:	2705                	addiw	a4,a4,1
ffffffffc0204000:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc0204004:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204008:	2ad7e663          	bltu	a5,a3,ffffffffc02042b4 <do_fork+0x380>
ffffffffc020400c:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204010:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204012:	8f99                	sub	a5,a5,a4
ffffffffc0204014:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204016:	6789                	lui	a5,0x2
ffffffffc0204018:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6718>
ffffffffc020401c:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020401e:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204020:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0204022:	87b6                	mv	a5,a3
ffffffffc0204024:	12040893          	addi	a7,s0,288
ffffffffc0204028:	00063803          	ld	a6,0(a2)
ffffffffc020402c:	6608                	ld	a0,8(a2)
ffffffffc020402e:	6a0c                	ld	a1,16(a2)
ffffffffc0204030:	6e18                	ld	a4,24(a2)
ffffffffc0204032:	0107b023          	sd	a6,0(a5)
ffffffffc0204036:	e788                	sd	a0,8(a5)
ffffffffc0204038:	eb8c                	sd	a1,16(a5)
ffffffffc020403a:	ef98                	sd	a4,24(a5)
ffffffffc020403c:	02060613          	addi	a2,a2,32
ffffffffc0204040:	02078793          	addi	a5,a5,32
ffffffffc0204044:	ff1612e3          	bne	a2,a7,ffffffffc0204028 <do_fork+0xf4>
    proc->tf->gpr.a0 = 0;
ffffffffc0204048:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020404c:	12098563          	beqz	s3,ffffffffc0204176 <do_fork+0x242>
    if (++last_pid >= MAX_PID)
ffffffffc0204050:	0008d817          	auipc	a6,0x8d
ffffffffc0204054:	66c80813          	addi	a6,a6,1644 # ffffffffc02916bc <last_pid.1>
ffffffffc0204058:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020405c:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204060:	00000717          	auipc	a4,0x0
ffffffffc0204064:	d6670713          	addi	a4,a4,-666 # ffffffffc0203dc6 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0204068:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020406c:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020406e:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0204070:	00a82023          	sw	a0,0(a6)
ffffffffc0204074:	6789                	lui	a5,0x2
ffffffffc0204076:	08f55a63          	bge	a0,a5,ffffffffc020410a <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc020407a:	0008d317          	auipc	t1,0x8d
ffffffffc020407e:	63e30313          	addi	t1,t1,1598 # ffffffffc02916b8 <next_safe.0>
ffffffffc0204082:	00032783          	lw	a5,0(t1)
ffffffffc0204086:	00092417          	auipc	s0,0x92
ffffffffc020408a:	a5240413          	addi	s0,s0,-1454 # ffffffffc0295ad8 <proc_list>
ffffffffc020408e:	08f55663          	bge	a0,a5,ffffffffc020411a <do_fork+0x1e6>
    proc->pid = get_pid();
ffffffffc0204092:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204094:	45a9                	li	a1,10
ffffffffc0204096:	2501                	sext.w	a0,a0
ffffffffc0204098:	132010ef          	jal	ffffffffc02051ca <hash32>
ffffffffc020409c:	02051793          	slli	a5,a0,0x20
ffffffffc02040a0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02040a4:	0008e797          	auipc	a5,0x8e
ffffffffc02040a8:	a3478793          	addi	a5,a5,-1484 # ffffffffc0291ad8 <hash_list>
ffffffffc02040ac:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02040ae:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040b0:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02040b2:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc02040b6:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02040b8:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc02040ba:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040bc:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02040be:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc02040c2:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc02040c4:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc02040c6:	e21c                	sd	a5,0(a2)
ffffffffc02040c8:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc02040ca:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc02040cc:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc02040ce:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02040d2:	10e4b023          	sd	a4,256(s1)
ffffffffc02040d6:	c311                	beqz	a4,ffffffffc02040da <do_fork+0x1a6>
        proc->optr->yptr = proc;
ffffffffc02040d8:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc02040da:	00092783          	lw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02040de:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc02040e0:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc02040e2:	2785                	addiw	a5,a5,1
ffffffffc02040e4:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02040e8:	6dd000ef          	jal	ffffffffc0204fc4 <wakeup_proc>
    ret = proc->pid;
ffffffffc02040ec:	40c8                	lw	a0,4(s1)
    goto fork_out;
ffffffffc02040ee:	7446                	ld	s0,112(sp)
ffffffffc02040f0:	74a6                	ld	s1,104(sp)
ffffffffc02040f2:	69e6                	ld	s3,88(sp)
ffffffffc02040f4:	6a46                	ld	s4,80(sp)
ffffffffc02040f6:	6aa6                	ld	s5,72(sp)
ffffffffc02040f8:	6b06                	ld	s6,64(sp)
ffffffffc02040fa:	7be2                	ld	s7,56(sp)
ffffffffc02040fc:	7c42                	ld	s8,48(sp)
ffffffffc02040fe:	7d02                	ld	s10,32(sp)
ffffffffc0204100:	6de2                	ld	s11,24(sp)
}
ffffffffc0204102:	70e6                	ld	ra,120(sp)
ffffffffc0204104:	7906                	ld	s2,96(sp)
ffffffffc0204106:	6109                	addi	sp,sp,128
ffffffffc0204108:	8082                	ret
        last_pid = 1;
ffffffffc020410a:	4785                	li	a5,1
ffffffffc020410c:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0204110:	4505                	li	a0,1
ffffffffc0204112:	0008d317          	auipc	t1,0x8d
ffffffffc0204116:	5a630313          	addi	t1,t1,1446 # ffffffffc02916b8 <next_safe.0>
    return listelm->next;
ffffffffc020411a:	00092417          	auipc	s0,0x92
ffffffffc020411e:	9be40413          	addi	s0,s0,-1602 # ffffffffc0295ad8 <proc_list>
ffffffffc0204122:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0204126:	6789                	lui	a5,0x2
ffffffffc0204128:	00f32023          	sw	a5,0(t1)
ffffffffc020412c:	86aa                	mv	a3,a0
ffffffffc020412e:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204130:	028e0e63          	beq	t3,s0,ffffffffc020416c <do_fork+0x238>
ffffffffc0204134:	88ae                	mv	a7,a1
ffffffffc0204136:	87f2                	mv	a5,t3
ffffffffc0204138:	6609                	lui	a2,0x2
ffffffffc020413a:	a811                	j	ffffffffc020414e <do_fork+0x21a>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020413c:	00e6d663          	bge	a3,a4,ffffffffc0204148 <do_fork+0x214>
ffffffffc0204140:	00c75463          	bge	a4,a2,ffffffffc0204148 <do_fork+0x214>
                next_safe = proc->pid;
ffffffffc0204144:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204146:	4885                	li	a7,1
ffffffffc0204148:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020414a:	00878d63          	beq	a5,s0,ffffffffc0204164 <do_fork+0x230>
            if (proc->pid == last_pid)
ffffffffc020414e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x66bc>
ffffffffc0204152:	fed715e3          	bne	a4,a3,ffffffffc020413c <do_fork+0x208>
                if (++last_pid >= next_safe)
ffffffffc0204156:	2685                	addiw	a3,a3,1
ffffffffc0204158:	10c6d263          	bge	a3,a2,ffffffffc020425c <do_fork+0x328>
ffffffffc020415c:	679c                	ld	a5,8(a5)
ffffffffc020415e:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204160:	fe8797e3          	bne	a5,s0,ffffffffc020414e <do_fork+0x21a>
ffffffffc0204164:	00088463          	beqz	a7,ffffffffc020416c <do_fork+0x238>
ffffffffc0204168:	00c32023          	sw	a2,0(t1)
ffffffffc020416c:	d19d                	beqz	a1,ffffffffc0204092 <do_fork+0x15e>
ffffffffc020416e:	00d82023          	sw	a3,0(a6)
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204172:	8536                	mv	a0,a3
ffffffffc0204174:	bf39                	j	ffffffffc0204092 <do_fork+0x15e>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204176:	89b6                	mv	s3,a3
ffffffffc0204178:	bde1                	j	ffffffffc0204050 <do_fork+0x11c>
ffffffffc020417a:	f466                	sd	s9,40(sp)
    if ((mm = mm_create()) == NULL)
ffffffffc020417c:	c84ff0ef          	jal	ffffffffc0203600 <mm_create>
ffffffffc0204180:	8caa                	mv	s9,a0
ffffffffc0204182:	c549                	beqz	a0,ffffffffc020420c <do_fork+0x2d8>
    if ((page = alloc_page()) == NULL)
ffffffffc0204184:	4505                	li	a0,1
ffffffffc0204186:	cb7fd0ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020418a:	cd35                	beqz	a0,ffffffffc0204206 <do_fork+0x2d2>
    return page - pages + nbase;
ffffffffc020418c:	000ab683          	ld	a3,0(s5)
ffffffffc0204190:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204192:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204196:	40d506b3          	sub	a3,a0,a3
ffffffffc020419a:	8699                	srai	a3,a3,0x6
ffffffffc020419c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020419e:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc02041a2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02041a4:	0eedf063          	bgeu	s11,a4,ffffffffc0204284 <do_fork+0x350>
ffffffffc02041a8:	000c3783          	ld	a5,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02041ac:	6605                	lui	a2,0x1
ffffffffc02041ae:	00092597          	auipc	a1,0x92
ffffffffc02041b2:	9825b583          	ld	a1,-1662(a1) # ffffffffc0295b30 <boot_pgdir_va>
ffffffffc02041b6:	00f68a33          	add	s4,a3,a5
ffffffffc02041ba:	8552                	mv	a0,s4
ffffffffc02041bc:	4dc010ef          	jal	ffffffffc0205698 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02041c0:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02041c4:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02041c8:	4785                	li	a5,1
ffffffffc02041ca:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02041ce:	8b85                	andi	a5,a5,1
ffffffffc02041d0:	4a05                	li	s4,1
ffffffffc02041d2:	c799                	beqz	a5,ffffffffc02041e0 <do_fork+0x2ac>
    {
        schedule();
ffffffffc02041d4:	68b000ef          	jal	ffffffffc020505e <schedule>
ffffffffc02041d8:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02041dc:	8b85                	andi	a5,a5,1
ffffffffc02041de:	fbfd                	bnez	a5,ffffffffc02041d4 <do_fork+0x2a0>
        ret = dup_mmap(mm, oldmm);
ffffffffc02041e0:	85ea                	mv	a1,s10
ffffffffc02041e2:	8566                	mv	a0,s9
ffffffffc02041e4:	e7cff0ef          	jal	ffffffffc0203860 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02041e8:	57f9                	li	a5,-2
ffffffffc02041ea:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02041ee:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02041f0:	c7d5                	beqz	a5,ffffffffc020429c <do_fork+0x368>
    if ((mm = mm_create()) == NULL)
ffffffffc02041f2:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02041f4:	e119                	bnez	a0,ffffffffc02041fa <do_fork+0x2c6>
ffffffffc02041f6:	7ca2                	ld	s9,40(sp)
ffffffffc02041f8:	bbed                	j	ffffffffc0203ff2 <do_fork+0xbe>
    exit_mmap(mm);
ffffffffc02041fa:	8566                	mv	a0,s9
ffffffffc02041fc:	efcff0ef          	jal	ffffffffc02038f8 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204200:	8566                	mv	a0,s9
ffffffffc0204202:	c51ff0ef          	jal	ffffffffc0203e52 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204206:	8566                	mv	a0,s9
ffffffffc0204208:	d38ff0ef          	jal	ffffffffc0203740 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020420c:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc020420e:	c02007b7          	lui	a5,0xc0200
ffffffffc0204212:	0af6ef63          	bltu	a3,a5,ffffffffc02042d0 <do_fork+0x39c>
ffffffffc0204216:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc020421a:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc020421e:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204222:	83b1                	srli	a5,a5,0xc
ffffffffc0204224:	04e7f463          	bgeu	a5,a4,ffffffffc020426c <do_fork+0x338>
    return &pages[PPN(pa) - nbase];
ffffffffc0204228:	000b3703          	ld	a4,0(s6)
ffffffffc020422c:	000ab503          	ld	a0,0(s5)
ffffffffc0204230:	4589                	li	a1,2
ffffffffc0204232:	8f99                	sub	a5,a5,a4
ffffffffc0204234:	079a                	slli	a5,a5,0x6
ffffffffc0204236:	953e                	add	a0,a0,a5
ffffffffc0204238:	c43fd0ef          	jal	ffffffffc0201e7a <free_pages>
}
ffffffffc020423c:	6aa6                	ld	s5,72(sp)
ffffffffc020423e:	6b06                	ld	s6,64(sp)
ffffffffc0204240:	7be2                	ld	s7,56(sp)
ffffffffc0204242:	7ca2                	ld	s9,40(sp)
ffffffffc0204244:	7d02                	ld	s10,32(sp)
ffffffffc0204246:	6de2                	ld	s11,24(sp)
    kfree(proc);
ffffffffc0204248:	8526                	mv	a0,s1
ffffffffc020424a:	ac5fd0ef          	jal	ffffffffc0201d0e <kfree>
ffffffffc020424e:	7c42                	ld	s8,48(sp)
ffffffffc0204250:	7446                	ld	s0,112(sp)
ffffffffc0204252:	74a6                	ld	s1,104(sp)
ffffffffc0204254:	69e6                	ld	s3,88(sp)
ffffffffc0204256:	6a46                	ld	s4,80(sp)
    ret = -E_NO_MEM;
ffffffffc0204258:	5571                	li	a0,-4
    return ret;
ffffffffc020425a:	b565                	j	ffffffffc0204102 <do_fork+0x1ce>
                    if (last_pid >= MAX_PID)
ffffffffc020425c:	6789                	lui	a5,0x2
ffffffffc020425e:	00f6c363          	blt	a3,a5,ffffffffc0204264 <do_fork+0x330>
                        last_pid = 1;
ffffffffc0204262:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204264:	4585                	li	a1,1
ffffffffc0204266:	b5e9                	j	ffffffffc0204130 <do_fork+0x1fc>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204268:	556d                	li	a0,-5
ffffffffc020426a:	bd61                	j	ffffffffc0204102 <do_fork+0x1ce>
        panic("pa2page called with invalid pa");
ffffffffc020426c:	00002617          	auipc	a2,0x2
ffffffffc0204270:	2a460613          	addi	a2,a2,676 # ffffffffc0206510 <etext+0xe60>
ffffffffc0204274:	06900593          	li	a1,105
ffffffffc0204278:	00002517          	auipc	a0,0x2
ffffffffc020427c:	1f050513          	addi	a0,a0,496 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0204280:	a08fc0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204284:	00002617          	auipc	a2,0x2
ffffffffc0204288:	1bc60613          	addi	a2,a2,444 # ffffffffc0206440 <etext+0xd90>
ffffffffc020428c:	07100593          	li	a1,113
ffffffffc0204290:	00002517          	auipc	a0,0x2
ffffffffc0204294:	1d850513          	addi	a0,a0,472 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0204298:	9f0fc0ef          	jal	ffffffffc0200488 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020429c:	00003617          	auipc	a2,0x3
ffffffffc02042a0:	bfc60613          	addi	a2,a2,-1028 # ffffffffc0206e98 <etext+0x17e8>
ffffffffc02042a4:	03f00593          	li	a1,63
ffffffffc02042a8:	00003517          	auipc	a0,0x3
ffffffffc02042ac:	c0050513          	addi	a0,a0,-1024 # ffffffffc0206ea8 <etext+0x17f8>
ffffffffc02042b0:	9d8fc0ef          	jal	ffffffffc0200488 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042b4:	86be                	mv	a3,a5
ffffffffc02042b6:	00002617          	auipc	a2,0x2
ffffffffc02042ba:	23260613          	addi	a2,a2,562 # ffffffffc02064e8 <etext+0xe38>
ffffffffc02042be:	19300593          	li	a1,403
ffffffffc02042c2:	00003517          	auipc	a0,0x3
ffffffffc02042c6:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc02042ca:	f466                	sd	s9,40(sp)
ffffffffc02042cc:	9bcfc0ef          	jal	ffffffffc0200488 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02042d0:	00002617          	auipc	a2,0x2
ffffffffc02042d4:	21860613          	addi	a2,a2,536 # ffffffffc02064e8 <etext+0xe38>
ffffffffc02042d8:	07700593          	li	a1,119
ffffffffc02042dc:	00002517          	auipc	a0,0x2
ffffffffc02042e0:	18c50513          	addi	a0,a0,396 # ffffffffc0206468 <etext+0xdb8>
ffffffffc02042e4:	9a4fc0ef          	jal	ffffffffc0200488 <__panic>
    assert(current->wait_state == 0);
ffffffffc02042e8:	00003697          	auipc	a3,0x3
ffffffffc02042ec:	b9068693          	addi	a3,a3,-1136 # ffffffffc0206e78 <etext+0x17c8>
ffffffffc02042f0:	00002617          	auipc	a2,0x2
ffffffffc02042f4:	da060613          	addi	a2,a2,-608 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02042f8:	1c300593          	li	a1,451
ffffffffc02042fc:	00003517          	auipc	a0,0x3
ffffffffc0204300:	b6450513          	addi	a0,a0,-1180 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204304:	e4d6                	sd	s5,72(sp)
ffffffffc0204306:	e0da                	sd	s6,64(sp)
ffffffffc0204308:	fc5e                	sd	s7,56(sp)
ffffffffc020430a:	f466                	sd	s9,40(sp)
ffffffffc020430c:	f06a                	sd	s10,32(sp)
ffffffffc020430e:	ec6e                	sd	s11,24(sp)
ffffffffc0204310:	978fc0ef          	jal	ffffffffc0200488 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204314:	00002617          	auipc	a2,0x2
ffffffffc0204318:	12c60613          	addi	a2,a2,300 # ffffffffc0206440 <etext+0xd90>
ffffffffc020431c:	07100593          	li	a1,113
ffffffffc0204320:	00002517          	auipc	a0,0x2
ffffffffc0204324:	14850513          	addi	a0,a0,328 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0204328:	f466                	sd	s9,40(sp)
ffffffffc020432a:	95efc0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020432e <kernel_thread>:
{
ffffffffc020432e:	7129                	addi	sp,sp,-320
ffffffffc0204330:	fa22                	sd	s0,304(sp)
ffffffffc0204332:	f626                	sd	s1,296(sp)
ffffffffc0204334:	f24a                	sd	s2,288(sp)
ffffffffc0204336:	84ae                	mv	s1,a1
ffffffffc0204338:	892a                	mv	s2,a0
ffffffffc020433a:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020433c:	4581                	li	a1,0
ffffffffc020433e:	12000613          	li	a2,288
ffffffffc0204342:	850a                	mv	a0,sp
{
ffffffffc0204344:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204346:	340010ef          	jal	ffffffffc0205686 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020434a:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020434c:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020434e:	100027f3          	csrr	a5,sstatus
ffffffffc0204352:	edd7f793          	andi	a5,a5,-291
ffffffffc0204356:	1207e793          	ori	a5,a5,288
ffffffffc020435a:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020435c:	860a                	mv	a2,sp
ffffffffc020435e:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204362:	00000797          	auipc	a5,0x0
ffffffffc0204366:	9da78793          	addi	a5,a5,-1574 # ffffffffc0203d3c <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020436a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020436c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020436e:	bc7ff0ef          	jal	ffffffffc0203f34 <do_fork>
}
ffffffffc0204372:	70f2                	ld	ra,312(sp)
ffffffffc0204374:	7452                	ld	s0,304(sp)
ffffffffc0204376:	74b2                	ld	s1,296(sp)
ffffffffc0204378:	7912                	ld	s2,288(sp)
ffffffffc020437a:	6131                	addi	sp,sp,320
ffffffffc020437c:	8082                	ret

ffffffffc020437e <do_exit>:
{
ffffffffc020437e:	7179                	addi	sp,sp,-48
ffffffffc0204380:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204382:	00091417          	auipc	s0,0x91
ffffffffc0204386:	7d640413          	addi	s0,s0,2006 # ffffffffc0295b58 <current>
ffffffffc020438a:	601c                	ld	a5,0(s0)
{
ffffffffc020438c:	f406                	sd	ra,40(sp)
    if (current == idleproc)
ffffffffc020438e:	00091717          	auipc	a4,0x91
ffffffffc0204392:	7da73703          	ld	a4,2010(a4) # ffffffffc0295b68 <idleproc>
ffffffffc0204396:	ec26                	sd	s1,24(sp)
ffffffffc0204398:	0ce78f63          	beq	a5,a4,ffffffffc0204476 <do_exit+0xf8>
    if (current == initproc)
ffffffffc020439c:	00091497          	auipc	s1,0x91
ffffffffc02043a0:	7c448493          	addi	s1,s1,1988 # ffffffffc0295b60 <initproc>
ffffffffc02043a4:	6098                	ld	a4,0(s1)
ffffffffc02043a6:	e84a                	sd	s2,16(sp)
ffffffffc02043a8:	e44e                	sd	s3,8(sp)
ffffffffc02043aa:	e052                	sd	s4,0(sp)
ffffffffc02043ac:	0ee78e63          	beq	a5,a4,ffffffffc02044a8 <do_exit+0x12a>
    struct mm_struct *mm = current->mm;
ffffffffc02043b0:	0287b983          	ld	s3,40(a5)
ffffffffc02043b4:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc02043b6:	02098663          	beqz	s3,ffffffffc02043e2 <do_exit+0x64>
ffffffffc02043ba:	00091797          	auipc	a5,0x91
ffffffffc02043be:	76e7b783          	ld	a5,1902(a5) # ffffffffc0295b28 <boot_pgdir_pa>
ffffffffc02043c2:	577d                	li	a4,-1
ffffffffc02043c4:	177e                	slli	a4,a4,0x3f
ffffffffc02043c6:	83b1                	srli	a5,a5,0xc
ffffffffc02043c8:	8fd9                	or	a5,a5,a4
ffffffffc02043ca:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02043ce:	0309a783          	lw	a5,48(s3)
ffffffffc02043d2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02043d6:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02043da:	cf4d                	beqz	a4,ffffffffc0204494 <do_exit+0x116>
        current->mm = NULL;
ffffffffc02043dc:	601c                	ld	a5,0(s0)
ffffffffc02043de:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02043e2:	601c                	ld	a5,0(s0)
ffffffffc02043e4:	470d                	li	a4,3
ffffffffc02043e6:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02043e8:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043ec:	100027f3          	csrr	a5,sstatus
ffffffffc02043f0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02043f2:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043f4:	e7f1                	bnez	a5,ffffffffc02044c0 <do_exit+0x142>
        proc = current->parent;
ffffffffc02043f6:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02043f8:	800007b7          	lui	a5,0x80000
ffffffffc02043fc:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff6499>
        proc = current->parent;
ffffffffc02043fe:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204400:	0ec52703          	lw	a4,236(a0)
ffffffffc0204404:	0cf70263          	beq	a4,a5,ffffffffc02044c8 <do_exit+0x14a>
        while (current->cptr != NULL)
ffffffffc0204408:	6018                	ld	a4,0(s0)
ffffffffc020440a:	7b7c                	ld	a5,240(a4)
ffffffffc020440c:	c3a1                	beqz	a5,ffffffffc020444c <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020440e:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204412:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204414:	0985                	addi	s3,s3,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff6499>
ffffffffc0204416:	a021                	j	ffffffffc020441e <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204418:	6018                	ld	a4,0(s0)
ffffffffc020441a:	7b7c                	ld	a5,240(a4)
ffffffffc020441c:	cb85                	beqz	a5,ffffffffc020444c <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc020441e:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204422:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204424:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204426:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0204428:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020442c:	10e7b023          	sd	a4,256(a5)
ffffffffc0204430:	c311                	beqz	a4,ffffffffc0204434 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204432:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204434:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204436:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204438:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020443a:	fd271fe3          	bne	a4,s2,ffffffffc0204418 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020443e:	0ec52783          	lw	a5,236(a0)
ffffffffc0204442:	fd379be3          	bne	a5,s3,ffffffffc0204418 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc0204446:	37f000ef          	jal	ffffffffc0204fc4 <wakeup_proc>
ffffffffc020444a:	b7f9                	j	ffffffffc0204418 <do_exit+0x9a>
    if (flag)
ffffffffc020444c:	020a1263          	bnez	s4,ffffffffc0204470 <do_exit+0xf2>
    schedule();
ffffffffc0204450:	40f000ef          	jal	ffffffffc020505e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204454:	601c                	ld	a5,0(s0)
ffffffffc0204456:	00003617          	auipc	a2,0x3
ffffffffc020445a:	a8a60613          	addi	a2,a2,-1398 # ffffffffc0206ee0 <etext+0x1830>
ffffffffc020445e:	24a00593          	li	a1,586
ffffffffc0204462:	43d4                	lw	a3,4(a5)
ffffffffc0204464:	00003517          	auipc	a0,0x3
ffffffffc0204468:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc020446c:	81cfc0ef          	jal	ffffffffc0200488 <__panic>
        intr_enable();
ffffffffc0204470:	d04fc0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc0204474:	bff1                	j	ffffffffc0204450 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204476:	00003617          	auipc	a2,0x3
ffffffffc020447a:	a4a60613          	addi	a2,a2,-1462 # ffffffffc0206ec0 <etext+0x1810>
ffffffffc020447e:	21600593          	li	a1,534
ffffffffc0204482:	00003517          	auipc	a0,0x3
ffffffffc0204486:	9de50513          	addi	a0,a0,-1570 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc020448a:	e84a                	sd	s2,16(sp)
ffffffffc020448c:	e44e                	sd	s3,8(sp)
ffffffffc020448e:	e052                	sd	s4,0(sp)
ffffffffc0204490:	ff9fb0ef          	jal	ffffffffc0200488 <__panic>
            exit_mmap(mm);
ffffffffc0204494:	854e                	mv	a0,s3
ffffffffc0204496:	c62ff0ef          	jal	ffffffffc02038f8 <exit_mmap>
            put_pgdir(mm);
ffffffffc020449a:	854e                	mv	a0,s3
ffffffffc020449c:	9b7ff0ef          	jal	ffffffffc0203e52 <put_pgdir>
            mm_destroy(mm);
ffffffffc02044a0:	854e                	mv	a0,s3
ffffffffc02044a2:	a9eff0ef          	jal	ffffffffc0203740 <mm_destroy>
ffffffffc02044a6:	bf1d                	j	ffffffffc02043dc <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc02044a8:	00003617          	auipc	a2,0x3
ffffffffc02044ac:	a2860613          	addi	a2,a2,-1496 # ffffffffc0206ed0 <etext+0x1820>
ffffffffc02044b0:	21a00593          	li	a1,538
ffffffffc02044b4:	00003517          	auipc	a0,0x3
ffffffffc02044b8:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc02044bc:	fcdfb0ef          	jal	ffffffffc0200488 <__panic>
        intr_disable();
ffffffffc02044c0:	cbafc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc02044c4:	4a05                	li	s4,1
ffffffffc02044c6:	bf05                	j	ffffffffc02043f6 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc02044c8:	2fd000ef          	jal	ffffffffc0204fc4 <wakeup_proc>
ffffffffc02044cc:	bf35                	j	ffffffffc0204408 <do_exit+0x8a>

ffffffffc02044ce <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc02044ce:	7179                	addi	sp,sp,-48
ffffffffc02044d0:	ec26                	sd	s1,24(sp)
ffffffffc02044d2:	e84a                	sd	s2,16(sp)
ffffffffc02044d4:	e44e                	sd	s3,8(sp)
ffffffffc02044d6:	f406                	sd	ra,40(sp)
ffffffffc02044d8:	f022                	sd	s0,32(sp)
ffffffffc02044da:	84aa                	mv	s1,a0
ffffffffc02044dc:	892e                	mv	s2,a1
ffffffffc02044de:	00091997          	auipc	s3,0x91
ffffffffc02044e2:	67a98993          	addi	s3,s3,1658 # ffffffffc0295b58 <current>
    if (pid != 0)
ffffffffc02044e6:	c105                	beqz	a0,ffffffffc0204506 <do_wait.part.0+0x38>
    if (0 < pid && pid < MAX_PID)
ffffffffc02044e8:	6789                	lui	a5,0x2
ffffffffc02044ea:	fff5071b          	addiw	a4,a0,-1
ffffffffc02044ee:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x65fa>
ffffffffc02044f0:	2501                	sext.w	a0,a0
ffffffffc02044f2:	12e7f363          	bgeu	a5,a4,ffffffffc0204618 <do_wait.part.0+0x14a>
    return -E_BAD_PROC;
ffffffffc02044f6:	5579                	li	a0,-2
}
ffffffffc02044f8:	70a2                	ld	ra,40(sp)
ffffffffc02044fa:	7402                	ld	s0,32(sp)
ffffffffc02044fc:	64e2                	ld	s1,24(sp)
ffffffffc02044fe:	6942                	ld	s2,16(sp)
ffffffffc0204500:	69a2                	ld	s3,8(sp)
ffffffffc0204502:	6145                	addi	sp,sp,48
ffffffffc0204504:	8082                	ret
        proc = current->cptr;
ffffffffc0204506:	0009b683          	ld	a3,0(s3)
ffffffffc020450a:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020450c:	d46d                	beqz	s0,ffffffffc02044f6 <do_wait.part.0+0x28>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020450e:	470d                	li	a4,3
ffffffffc0204510:	a021                	j	ffffffffc0204518 <do_wait.part.0+0x4a>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204512:	10043403          	ld	s0,256(s0)
ffffffffc0204516:	cc71                	beqz	s0,ffffffffc02045f2 <do_wait.part.0+0x124>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204518:	401c                	lw	a5,0(s0)
ffffffffc020451a:	fee79ce3          	bne	a5,a4,ffffffffc0204512 <do_wait.part.0+0x44>
    if (proc == idleproc || proc == initproc)
ffffffffc020451e:	00091797          	auipc	a5,0x91
ffffffffc0204522:	64a7b783          	ld	a5,1610(a5) # ffffffffc0295b68 <idleproc>
ffffffffc0204526:	14878c63          	beq	a5,s0,ffffffffc020467e <do_wait.part.0+0x1b0>
ffffffffc020452a:	00091797          	auipc	a5,0x91
ffffffffc020452e:	6367b783          	ld	a5,1590(a5) # ffffffffc0295b60 <initproc>
ffffffffc0204532:	14f40663          	beq	s0,a5,ffffffffc020467e <do_wait.part.0+0x1b0>
    if (code_store != NULL)
ffffffffc0204536:	00090663          	beqz	s2,ffffffffc0204542 <do_wait.part.0+0x74>
        *code_store = proc->exit_code;
ffffffffc020453a:	0e842783          	lw	a5,232(s0)
ffffffffc020453e:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204542:	100027f3          	csrr	a5,sstatus
ffffffffc0204546:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204548:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020454a:	10079463          	bnez	a5,ffffffffc0204652 <do_wait.part.0+0x184>
    __list_del(listelm->prev, listelm->next);
ffffffffc020454e:	6c74                	ld	a3,216(s0)
ffffffffc0204550:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc0204552:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc0204556:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204558:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc020455a:	6474                	ld	a3,200(s0)
ffffffffc020455c:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc020455e:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204560:	e314                	sd	a3,0(a4)
ffffffffc0204562:	c399                	beqz	a5,ffffffffc0204568 <do_wait.part.0+0x9a>
        proc->optr->yptr = proc->yptr;
ffffffffc0204564:	7c78                	ld	a4,248(s0)
ffffffffc0204566:	fff8                	sd	a4,248(a5)
    if (proc->yptr != NULL)
ffffffffc0204568:	7c78                	ld	a4,248(s0)
ffffffffc020456a:	c36d                	beqz	a4,ffffffffc020464c <do_wait.part.0+0x17e>
        proc->yptr->optr = proc->optr;
ffffffffc020456c:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc0204570:	00091717          	auipc	a4,0x91
ffffffffc0204574:	5e070713          	addi	a4,a4,1504 # ffffffffc0295b50 <nr_process>
ffffffffc0204578:	431c                	lw	a5,0(a4)
ffffffffc020457a:	37fd                	addiw	a5,a5,-1
ffffffffc020457c:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020457e:	e661                	bnez	a2,ffffffffc0204646 <do_wait.part.0+0x178>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204580:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204582:	c02007b7          	lui	a5,0xc0200
ffffffffc0204586:	0ef6e063          	bltu	a3,a5,ffffffffc0204666 <do_wait.part.0+0x198>
ffffffffc020458a:	00091797          	auipc	a5,0x91
ffffffffc020458e:	5ae7b783          	ld	a5,1454(a5) # ffffffffc0295b38 <va_pa_offset>
ffffffffc0204592:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204594:	82b1                	srli	a3,a3,0xc
ffffffffc0204596:	00091797          	auipc	a5,0x91
ffffffffc020459a:	5aa7b783          	ld	a5,1450(a5) # ffffffffc0295b40 <npage>
ffffffffc020459e:	0ef6fc63          	bgeu	a3,a5,ffffffffc0204696 <do_wait.part.0+0x1c8>
    return &pages[PPN(pa) - nbase];
ffffffffc02045a2:	00003797          	auipc	a5,0x3
ffffffffc02045a6:	2667b783          	ld	a5,614(a5) # ffffffffc0207808 <nbase>
ffffffffc02045aa:	8e9d                	sub	a3,a3,a5
ffffffffc02045ac:	069a                	slli	a3,a3,0x6
ffffffffc02045ae:	00091517          	auipc	a0,0x91
ffffffffc02045b2:	59a53503          	ld	a0,1434(a0) # ffffffffc0295b48 <pages>
ffffffffc02045b6:	9536                	add	a0,a0,a3
ffffffffc02045b8:	4589                	li	a1,2
ffffffffc02045ba:	8c1fd0ef          	jal	ffffffffc0201e7a <free_pages>
    kfree(proc);
ffffffffc02045be:	8522                	mv	a0,s0
ffffffffc02045c0:	f4efd0ef          	jal	ffffffffc0201d0e <kfree>
}
ffffffffc02045c4:	70a2                	ld	ra,40(sp)
ffffffffc02045c6:	7402                	ld	s0,32(sp)
ffffffffc02045c8:	64e2                	ld	s1,24(sp)
ffffffffc02045ca:	6942                	ld	s2,16(sp)
ffffffffc02045cc:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc02045ce:	4501                	li	a0,0
}
ffffffffc02045d0:	6145                	addi	sp,sp,48
ffffffffc02045d2:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045d4:	00091997          	auipc	s3,0x91
ffffffffc02045d8:	58498993          	addi	s3,s3,1412 # ffffffffc0295b58 <current>
ffffffffc02045dc:	0009b683          	ld	a3,0(s3)
ffffffffc02045e0:	f4843783          	ld	a5,-184(s0)
ffffffffc02045e4:	f0d799e3          	bne	a5,a3,ffffffffc02044f6 <do_wait.part.0+0x28>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045e8:	f2842703          	lw	a4,-216(s0)
ffffffffc02045ec:	478d                	li	a5,3
ffffffffc02045ee:	06f70663          	beq	a4,a5,ffffffffc020465a <do_wait.part.0+0x18c>
        current->wait_state = WT_CHILD;
ffffffffc02045f2:	800007b7          	lui	a5,0x80000
ffffffffc02045f6:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff6499>
        current->state = PROC_SLEEPING;
ffffffffc02045f8:	4705                	li	a4,1
        current->wait_state = WT_CHILD;
ffffffffc02045fa:	0ef6a623          	sw	a5,236(a3)
        current->state = PROC_SLEEPING;
ffffffffc02045fe:	c298                	sw	a4,0(a3)
        schedule();
ffffffffc0204600:	25f000ef          	jal	ffffffffc020505e <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204604:	0009b783          	ld	a5,0(s3)
ffffffffc0204608:	0b07a783          	lw	a5,176(a5)
ffffffffc020460c:	8b85                	andi	a5,a5,1
ffffffffc020460e:	eba9                	bnez	a5,ffffffffc0204660 <do_wait.part.0+0x192>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204610:	0004851b          	sext.w	a0,s1
    if (pid != 0)
ffffffffc0204614:	ee0489e3          	beqz	s1,ffffffffc0204506 <do_wait.part.0+0x38>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204618:	45a9                	li	a1,10
ffffffffc020461a:	3b1000ef          	jal	ffffffffc02051ca <hash32>
ffffffffc020461e:	02051793          	slli	a5,a0,0x20
ffffffffc0204622:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204626:	0008d797          	auipc	a5,0x8d
ffffffffc020462a:	4b278793          	addi	a5,a5,1202 # ffffffffc0291ad8 <hash_list>
ffffffffc020462e:	953e                	add	a0,a0,a5
ffffffffc0204630:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204632:	a029                	j	ffffffffc020463c <do_wait.part.0+0x16e>
            if (proc->pid == pid)
ffffffffc0204634:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204638:	f8978ee3          	beq	a5,s1,ffffffffc02045d4 <do_wait.part.0+0x106>
    return listelm->next;
ffffffffc020463c:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc020463e:	fe851be3          	bne	a0,s0,ffffffffc0204634 <do_wait.part.0+0x166>
    return -E_BAD_PROC;
ffffffffc0204642:	5579                	li	a0,-2
ffffffffc0204644:	bd55                	j	ffffffffc02044f8 <do_wait.part.0+0x2a>
        intr_enable();
ffffffffc0204646:	b2efc0ef          	jal	ffffffffc0200974 <intr_enable>
ffffffffc020464a:	bf1d                	j	ffffffffc0204580 <do_wait.part.0+0xb2>
        proc->parent->cptr = proc->optr;
ffffffffc020464c:	7018                	ld	a4,32(s0)
ffffffffc020464e:	fb7c                	sd	a5,240(a4)
ffffffffc0204650:	b705                	j	ffffffffc0204570 <do_wait.part.0+0xa2>
        intr_disable();
ffffffffc0204652:	b28fc0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc0204656:	4605                	li	a2,1
ffffffffc0204658:	bddd                	j	ffffffffc020454e <do_wait.part.0+0x80>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020465a:	f2840413          	addi	s0,s0,-216
ffffffffc020465e:	b5c1                	j	ffffffffc020451e <do_wait.part.0+0x50>
            do_exit(-E_KILLED);
ffffffffc0204660:	555d                	li	a0,-9
ffffffffc0204662:	d1dff0ef          	jal	ffffffffc020437e <do_exit>
    return pa2page(PADDR(kva));
ffffffffc0204666:	00002617          	auipc	a2,0x2
ffffffffc020466a:	e8260613          	addi	a2,a2,-382 # ffffffffc02064e8 <etext+0xe38>
ffffffffc020466e:	07700593          	li	a1,119
ffffffffc0204672:	00002517          	auipc	a0,0x2
ffffffffc0204676:	df650513          	addi	a0,a0,-522 # ffffffffc0206468 <etext+0xdb8>
ffffffffc020467a:	e0ffb0ef          	jal	ffffffffc0200488 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020467e:	00003617          	auipc	a2,0x3
ffffffffc0204682:	88260613          	addi	a2,a2,-1918 # ffffffffc0206f00 <etext+0x1850>
ffffffffc0204686:	36800593          	li	a1,872
ffffffffc020468a:	00002517          	auipc	a0,0x2
ffffffffc020468e:	7d650513          	addi	a0,a0,2006 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204692:	df7fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204696:	00002617          	auipc	a2,0x2
ffffffffc020469a:	e7a60613          	addi	a2,a2,-390 # ffffffffc0206510 <etext+0xe60>
ffffffffc020469e:	06900593          	li	a1,105
ffffffffc02046a2:	00002517          	auipc	a0,0x2
ffffffffc02046a6:	dc650513          	addi	a0,a0,-570 # ffffffffc0206468 <etext+0xdb8>
ffffffffc02046aa:	ddffb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02046ae <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02046ae:	1141                	addi	sp,sp,-16
ffffffffc02046b0:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02046b2:	809fd0ef          	jal	ffffffffc0201eba <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02046b6:	daafd0ef          	jal	ffffffffc0201c60 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc02046ba:	4601                	li	a2,0
ffffffffc02046bc:	4581                	li	a1,0
ffffffffc02046be:	fffff517          	auipc	a0,0xfffff
ffffffffc02046c2:	71650513          	addi	a0,a0,1814 # ffffffffc0203dd4 <user_main>
ffffffffc02046c6:	c69ff0ef          	jal	ffffffffc020432e <kernel_thread>
    if (pid <= 0)
ffffffffc02046ca:	00a04563          	bgtz	a0,ffffffffc02046d4 <init_main+0x26>
ffffffffc02046ce:	a071                	j	ffffffffc020475a <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02046d0:	18f000ef          	jal	ffffffffc020505e <schedule>
    if (code_store != NULL)
ffffffffc02046d4:	4581                	li	a1,0
ffffffffc02046d6:	4501                	li	a0,0
ffffffffc02046d8:	df7ff0ef          	jal	ffffffffc02044ce <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02046dc:	d975                	beqz	a0,ffffffffc02046d0 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02046de:	00003517          	auipc	a0,0x3
ffffffffc02046e2:	86250513          	addi	a0,a0,-1950 # ffffffffc0206f40 <etext+0x1890>
ffffffffc02046e6:	aaffb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02046ea:	00091797          	auipc	a5,0x91
ffffffffc02046ee:	4767b783          	ld	a5,1142(a5) # ffffffffc0295b60 <initproc>
ffffffffc02046f2:	7bf8                	ld	a4,240(a5)
ffffffffc02046f4:	e339                	bnez	a4,ffffffffc020473a <init_main+0x8c>
ffffffffc02046f6:	7ff8                	ld	a4,248(a5)
ffffffffc02046f8:	e329                	bnez	a4,ffffffffc020473a <init_main+0x8c>
ffffffffc02046fa:	1007b703          	ld	a4,256(a5)
ffffffffc02046fe:	ef15                	bnez	a4,ffffffffc020473a <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204700:	00091697          	auipc	a3,0x91
ffffffffc0204704:	4506a683          	lw	a3,1104(a3) # ffffffffc0295b50 <nr_process>
ffffffffc0204708:	4709                	li	a4,2
ffffffffc020470a:	0ae69463          	bne	a3,a4,ffffffffc02047b2 <init_main+0x104>
ffffffffc020470e:	00091697          	auipc	a3,0x91
ffffffffc0204712:	3ca68693          	addi	a3,a3,970 # ffffffffc0295ad8 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204716:	6698                	ld	a4,8(a3)
ffffffffc0204718:	0c878793          	addi	a5,a5,200
ffffffffc020471c:	06f71b63          	bne	a4,a5,ffffffffc0204792 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204720:	629c                	ld	a5,0(a3)
ffffffffc0204722:	04f71863          	bne	a4,a5,ffffffffc0204772 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204726:	00003517          	auipc	a0,0x3
ffffffffc020472a:	90250513          	addi	a0,a0,-1790 # ffffffffc0207028 <etext+0x1978>
ffffffffc020472e:	a67fb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204732:	60a2                	ld	ra,8(sp)
ffffffffc0204734:	4501                	li	a0,0
ffffffffc0204736:	0141                	addi	sp,sp,16
ffffffffc0204738:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020473a:	00003697          	auipc	a3,0x3
ffffffffc020473e:	82e68693          	addi	a3,a3,-2002 # ffffffffc0206f68 <etext+0x18b8>
ffffffffc0204742:	00002617          	auipc	a2,0x2
ffffffffc0204746:	94e60613          	addi	a2,a2,-1714 # ffffffffc0206090 <etext+0x9e0>
ffffffffc020474a:	3d600593          	li	a1,982
ffffffffc020474e:	00002517          	auipc	a0,0x2
ffffffffc0204752:	71250513          	addi	a0,a0,1810 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204756:	d33fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("create user_main failed.\n");
ffffffffc020475a:	00002617          	auipc	a2,0x2
ffffffffc020475e:	7c660613          	addi	a2,a2,1990 # ffffffffc0206f20 <etext+0x1870>
ffffffffc0204762:	3cd00593          	li	a1,973
ffffffffc0204766:	00002517          	auipc	a0,0x2
ffffffffc020476a:	6fa50513          	addi	a0,a0,1786 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc020476e:	d1bfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204772:	00003697          	auipc	a3,0x3
ffffffffc0204776:	88668693          	addi	a3,a3,-1914 # ffffffffc0206ff8 <etext+0x1948>
ffffffffc020477a:	00002617          	auipc	a2,0x2
ffffffffc020477e:	91660613          	addi	a2,a2,-1770 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204782:	3d900593          	li	a1,985
ffffffffc0204786:	00002517          	auipc	a0,0x2
ffffffffc020478a:	6da50513          	addi	a0,a0,1754 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc020478e:	cfbfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204792:	00003697          	auipc	a3,0x3
ffffffffc0204796:	83668693          	addi	a3,a3,-1994 # ffffffffc0206fc8 <etext+0x1918>
ffffffffc020479a:	00002617          	auipc	a2,0x2
ffffffffc020479e:	8f660613          	addi	a2,a2,-1802 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02047a2:	3d800593          	li	a1,984
ffffffffc02047a6:	00002517          	auipc	a0,0x2
ffffffffc02047aa:	6ba50513          	addi	a0,a0,1722 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc02047ae:	cdbfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(nr_process == 2);
ffffffffc02047b2:	00003697          	auipc	a3,0x3
ffffffffc02047b6:	80668693          	addi	a3,a3,-2042 # ffffffffc0206fb8 <etext+0x1908>
ffffffffc02047ba:	00002617          	auipc	a2,0x2
ffffffffc02047be:	8d660613          	addi	a2,a2,-1834 # ffffffffc0206090 <etext+0x9e0>
ffffffffc02047c2:	3d700593          	li	a1,983
ffffffffc02047c6:	00002517          	auipc	a0,0x2
ffffffffc02047ca:	69a50513          	addi	a0,a0,1690 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc02047ce:	cbbfb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02047d2 <do_execve>:
{
ffffffffc02047d2:	7171                	addi	sp,sp,-176
ffffffffc02047d4:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047d6:	00091d97          	auipc	s11,0x91
ffffffffc02047da:	382d8d93          	addi	s11,s11,898 # ffffffffc0295b58 <current>
ffffffffc02047de:	000db783          	ld	a5,0(s11)
{
ffffffffc02047e2:	e54e                	sd	s3,136(sp)
ffffffffc02047e4:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02047e6:	0287b983          	ld	s3,40(a5)
{
ffffffffc02047ea:	e94a                	sd	s2,144(sp)
ffffffffc02047ec:	f8da                	sd	s6,112(sp)
ffffffffc02047ee:	892a                	mv	s2,a0
ffffffffc02047f0:	8b32                	mv	s6,a2
ffffffffc02047f2:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02047f4:	862e                	mv	a2,a1
ffffffffc02047f6:	4681                	li	a3,0
ffffffffc02047f8:	85aa                	mv	a1,a0
ffffffffc02047fa:	854e                	mv	a0,s3
{
ffffffffc02047fc:	f506                	sd	ra,168(sp)
ffffffffc02047fe:	f05a                	sd	s6,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204800:	c9cff0ef          	jal	ffffffffc0203c9c <user_mem_check>
ffffffffc0204804:	40050a63          	beqz	a0,ffffffffc0204c18 <do_execve+0x446>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204808:	4641                	li	a2,16
ffffffffc020480a:	4581                	li	a1,0
ffffffffc020480c:	1808                	addi	a0,sp,48
ffffffffc020480e:	f122                	sd	s0,160(sp)
ffffffffc0204810:	e152                	sd	s4,128(sp)
ffffffffc0204812:	fcd6                	sd	s5,120(sp)
ffffffffc0204814:	f4de                	sd	s7,104(sp)
ffffffffc0204816:	f0e2                	sd	s8,96(sp)
ffffffffc0204818:	ece6                	sd	s9,88(sp)
ffffffffc020481a:	e8ea                	sd	s10,80(sp)
ffffffffc020481c:	66b000ef          	jal	ffffffffc0205686 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc0204820:	47bd                	li	a5,15
ffffffffc0204822:	8626                	mv	a2,s1
ffffffffc0204824:	0e97e063          	bltu	a5,s1,ffffffffc0204904 <do_execve+0x132>
    memcpy(local_name, name, len);
ffffffffc0204828:	85ca                	mv	a1,s2
ffffffffc020482a:	1808                	addi	a0,sp,48
ffffffffc020482c:	66d000ef          	jal	ffffffffc0205698 <memcpy>
    if (mm != NULL)
ffffffffc0204830:	0e098163          	beqz	s3,ffffffffc0204912 <do_execve+0x140>
        cputs("mm != NULL");
ffffffffc0204834:	00002517          	auipc	a0,0x2
ffffffffc0204838:	3f450513          	addi	a0,a0,1012 # ffffffffc0206c28 <etext+0x1578>
ffffffffc020483c:	98ffb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc0204840:	00091797          	auipc	a5,0x91
ffffffffc0204844:	2e87b783          	ld	a5,744(a5) # ffffffffc0295b28 <boot_pgdir_pa>
ffffffffc0204848:	577d                	li	a4,-1
ffffffffc020484a:	177e                	slli	a4,a4,0x3f
ffffffffc020484c:	83b1                	srli	a5,a5,0xc
ffffffffc020484e:	8fd9                	or	a5,a5,a4
ffffffffc0204850:	18079073          	csrw	satp,a5
ffffffffc0204854:	0309a783          	lw	a5,48(s3)
ffffffffc0204858:	fff7871b          	addiw	a4,a5,-1
ffffffffc020485c:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204860:	28070a63          	beqz	a4,ffffffffc0204af4 <do_execve+0x322>
        current->mm = NULL;
ffffffffc0204864:	000db783          	ld	a5,0(s11)
ffffffffc0204868:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc020486c:	d95fe0ef          	jal	ffffffffc0203600 <mm_create>
ffffffffc0204870:	84aa                	mv	s1,a0
ffffffffc0204872:	1a050b63          	beqz	a0,ffffffffc0204a28 <do_execve+0x256>
    if ((page = alloc_page()) == NULL)
ffffffffc0204876:	4505                	li	a0,1
ffffffffc0204878:	dc4fd0ef          	jal	ffffffffc0201e3c <alloc_pages>
ffffffffc020487c:	3a050263          	beqz	a0,ffffffffc0204c20 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204880:	00091c97          	auipc	s9,0x91
ffffffffc0204884:	2c8c8c93          	addi	s9,s9,712 # ffffffffc0295b48 <pages>
ffffffffc0204888:	000cb783          	ld	a5,0(s9)
    return KADDR(page2pa(page));
ffffffffc020488c:	00091d17          	auipc	s10,0x91
ffffffffc0204890:	2b4d0d13          	addi	s10,s10,692 # ffffffffc0295b40 <npage>
    return page - pages + nbase;
ffffffffc0204894:	00003c17          	auipc	s8,0x3
ffffffffc0204898:	f74c3c03          	ld	s8,-140(s8) # ffffffffc0207808 <nbase>
ffffffffc020489c:	40f506b3          	sub	a3,a0,a5
ffffffffc02048a0:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02048a2:	5bfd                	li	s7,-1
ffffffffc02048a4:	000d3783          	ld	a5,0(s10)
    return page - pages + nbase;
ffffffffc02048a8:	96e2                	add	a3,a3,s8
    return KADDR(page2pa(page));
ffffffffc02048aa:	00cbd713          	srli	a4,s7,0xc
ffffffffc02048ae:	ec3a                	sd	a4,24(sp)
ffffffffc02048b0:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02048b2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02048b4:	36f77a63          	bgeu	a4,a5,ffffffffc0204c28 <do_execve+0x456>
ffffffffc02048b8:	00091a97          	auipc	s5,0x91
ffffffffc02048bc:	280a8a93          	addi	s5,s5,640 # ffffffffc0295b38 <va_pa_offset>
ffffffffc02048c0:	000ab783          	ld	a5,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02048c4:	6605                	lui	a2,0x1
ffffffffc02048c6:	00091597          	auipc	a1,0x91
ffffffffc02048ca:	26a5b583          	ld	a1,618(a1) # ffffffffc0295b30 <boot_pgdir_va>
ffffffffc02048ce:	00f68933          	add	s2,a3,a5
ffffffffc02048d2:	854a                	mv	a0,s2
ffffffffc02048d4:	5c5000ef          	jal	ffffffffc0205698 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048d8:	7682                	ld	a3,32(sp)
ffffffffc02048da:	464c47b7          	lui	a5,0x464c4
ffffffffc02048de:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464baa17>
ffffffffc02048e2:	4298                	lw	a4,0(a3)
    mm->pgdir = pgdir;
ffffffffc02048e4:	0124bc23          	sd	s2,24(s1)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02048e8:	0206ba03          	ld	s4,32(a3)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02048ec:	04f70363          	beq	a4,a5,ffffffffc0204932 <do_execve+0x160>
        ret = -E_INVAL_ELF;
ffffffffc02048f0:	5961                	li	s2,-8
    put_pgdir(mm);
ffffffffc02048f2:	8526                	mv	a0,s1
ffffffffc02048f4:	d5eff0ef          	jal	ffffffffc0203e52 <put_pgdir>
    mm_destroy(mm);
ffffffffc02048f8:	8526                	mv	a0,s1
ffffffffc02048fa:	e47fe0ef          	jal	ffffffffc0203740 <mm_destroy>
    do_exit(ret);
ffffffffc02048fe:	854a                	mv	a0,s2
ffffffffc0204900:	a7fff0ef          	jal	ffffffffc020437e <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204904:	463d                	li	a2,15
    memcpy(local_name, name, len);
ffffffffc0204906:	85ca                	mv	a1,s2
ffffffffc0204908:	1808                	addi	a0,sp,48
ffffffffc020490a:	58f000ef          	jal	ffffffffc0205698 <memcpy>
    if (mm != NULL)
ffffffffc020490e:	f20993e3          	bnez	s3,ffffffffc0204834 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204912:	000db783          	ld	a5,0(s11)
ffffffffc0204916:	779c                	ld	a5,40(a5)
ffffffffc0204918:	dbb1                	beqz	a5,ffffffffc020486c <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc020491a:	00002617          	auipc	a2,0x2
ffffffffc020491e:	72e60613          	addi	a2,a2,1838 # ffffffffc0207048 <etext+0x1998>
ffffffffc0204922:	25600593          	li	a1,598
ffffffffc0204926:	00002517          	auipc	a0,0x2
ffffffffc020492a:	53a50513          	addi	a0,a0,1338 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc020492e:	b5bfb0ef          	jal	ffffffffc0200488 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204932:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204936:	9a36                	add	s4,s4,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204938:	00371793          	slli	a5,a4,0x3
ffffffffc020493c:	8f99                	sub	a5,a5,a4
ffffffffc020493e:	078e                	slli	a5,a5,0x3
ffffffffc0204940:	97d2                	add	a5,a5,s4
ffffffffc0204942:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204944:	00fa7c63          	bgeu	s4,a5,ffffffffc020495c <do_execve+0x18a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204948:	000a2783          	lw	a5,0(s4) # 1000 <_binary_obj___user_softint_out_size-0x75f8>
ffffffffc020494c:	4705                	li	a4,1
ffffffffc020494e:	0ce78f63          	beq	a5,a4,ffffffffc0204a2c <do_execve+0x25a>
    for (; ph < ph_end; ph++)
ffffffffc0204952:	77a2                	ld	a5,40(sp)
ffffffffc0204954:	038a0a13          	addi	s4,s4,56
ffffffffc0204958:	fefa68e3          	bltu	s4,a5,ffffffffc0204948 <do_execve+0x176>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc020495c:	4701                	li	a4,0
ffffffffc020495e:	46ad                	li	a3,11
ffffffffc0204960:	00100637          	lui	a2,0x100
ffffffffc0204964:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204968:	8526                	mv	a0,s1
ffffffffc020496a:	e29fe0ef          	jal	ffffffffc0203792 <mm_map>
ffffffffc020496e:	892a                	mv	s2,a0
ffffffffc0204970:	16051e63          	bnez	a0,ffffffffc0204aec <do_execve+0x31a>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204974:	6c88                	ld	a0,24(s1)
ffffffffc0204976:	467d                	li	a2,31
ffffffffc0204978:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc020497c:	b93fe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc0204980:	32050c63          	beqz	a0,ffffffffc0204cb8 <do_execve+0x4e6>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204984:	6c88                	ld	a0,24(s1)
ffffffffc0204986:	467d                	li	a2,31
ffffffffc0204988:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc020498c:	b83fe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc0204990:	30050463          	beqz	a0,ffffffffc0204c98 <do_execve+0x4c6>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204994:	6c88                	ld	a0,24(s1)
ffffffffc0204996:	467d                	li	a2,31
ffffffffc0204998:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020499c:	b73fe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc02049a0:	2c050c63          	beqz	a0,ffffffffc0204c78 <do_execve+0x4a6>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049a4:	6c88                	ld	a0,24(s1)
ffffffffc02049a6:	467d                	li	a2,31
ffffffffc02049a8:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049ac:	b63fe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc02049b0:	2a050463          	beqz	a0,ffffffffc0204c58 <do_execve+0x486>
    mm->mm_count += 1;
ffffffffc02049b4:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc02049b6:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049ba:	6c94                	ld	a3,24(s1)
ffffffffc02049bc:	2785                	addiw	a5,a5,1
ffffffffc02049be:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc02049c0:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049c2:	c02007b7          	lui	a5,0xc0200
ffffffffc02049c6:	26f6ed63          	bltu	a3,a5,ffffffffc0204c40 <do_execve+0x46e>
ffffffffc02049ca:	000ab783          	ld	a5,0(s5)
ffffffffc02049ce:	577d                	li	a4,-1
ffffffffc02049d0:	177e                	slli	a4,a4,0x3f
ffffffffc02049d2:	8e9d                	sub	a3,a3,a5
ffffffffc02049d4:	00c6d793          	srli	a5,a3,0xc
ffffffffc02049d8:	f654                	sd	a3,168(a2)
ffffffffc02049da:	8fd9                	or	a5,a5,a4
ffffffffc02049dc:	18079073          	csrw	satp,a5
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02049e0:	7248                	ld	a0,160(a2)
ffffffffc02049e2:	4581                	li	a1,0
ffffffffc02049e4:	12000613          	li	a2,288
ffffffffc02049e8:	49f000ef          	jal	ffffffffc0205686 <memset>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02049ec:	000db403          	ld	s0,0(s11)
ffffffffc02049f0:	4641                	li	a2,16
ffffffffc02049f2:	4581                	li	a1,0
ffffffffc02049f4:	0b440413          	addi	s0,s0,180
ffffffffc02049f8:	8522                	mv	a0,s0
ffffffffc02049fa:	48d000ef          	jal	ffffffffc0205686 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02049fe:	8522                	mv	a0,s0
ffffffffc0204a00:	463d                	li	a2,15
ffffffffc0204a02:	180c                	addi	a1,sp,48
ffffffffc0204a04:	495000ef          	jal	ffffffffc0205698 <memcpy>
ffffffffc0204a08:	740a                	ld	s0,160(sp)
ffffffffc0204a0a:	6a0a                	ld	s4,128(sp)
ffffffffc0204a0c:	7ae6                	ld	s5,120(sp)
ffffffffc0204a0e:	7ba6                	ld	s7,104(sp)
ffffffffc0204a10:	7c06                	ld	s8,96(sp)
ffffffffc0204a12:	6ce6                	ld	s9,88(sp)
ffffffffc0204a14:	6d46                	ld	s10,80(sp)
}
ffffffffc0204a16:	70aa                	ld	ra,168(sp)
ffffffffc0204a18:	64ea                	ld	s1,152(sp)
ffffffffc0204a1a:	69aa                	ld	s3,136(sp)
ffffffffc0204a1c:	7b46                	ld	s6,112(sp)
ffffffffc0204a1e:	6da6                	ld	s11,72(sp)
ffffffffc0204a20:	854a                	mv	a0,s2
ffffffffc0204a22:	694a                	ld	s2,144(sp)
ffffffffc0204a24:	614d                	addi	sp,sp,176
ffffffffc0204a26:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204a28:	5971                	li	s2,-4
ffffffffc0204a2a:	bdd1                	j	ffffffffc02048fe <do_execve+0x12c>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204a2c:	028a3603          	ld	a2,40(s4)
ffffffffc0204a30:	020a3783          	ld	a5,32(s4)
ffffffffc0204a34:	1ef66863          	bltu	a2,a5,ffffffffc0204c24 <do_execve+0x452>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a38:	004a2783          	lw	a5,4(s4)
ffffffffc0204a3c:	0017f693          	andi	a3,a5,1
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a40:	0027f593          	andi	a1,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a44:	0026971b          	slliw	a4,a3,0x2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a48:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204a4a:	068a                	slli	a3,a3,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204a4c:	edd5                	bnez	a1,ffffffffc0204b08 <do_execve+0x336>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a4e:	1a079b63          	bnez	a5,ffffffffc0204c04 <do_execve+0x432>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204a52:	47c5                	li	a5,17
ffffffffc0204a54:	e83e                	sd	a5,16(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204a56:	0046f793          	andi	a5,a3,4
ffffffffc0204a5a:	c789                	beqz	a5,ffffffffc0204a64 <do_execve+0x292>
            perm |= PTE_X;
ffffffffc0204a5c:	67c2                	ld	a5,16(sp)
ffffffffc0204a5e:	0087e793          	ori	a5,a5,8
ffffffffc0204a62:	e83e                	sd	a5,16(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204a64:	010a3583          	ld	a1,16(s4)
ffffffffc0204a68:	4701                	li	a4,0
ffffffffc0204a6a:	8526                	mv	a0,s1
ffffffffc0204a6c:	d27fe0ef          	jal	ffffffffc0203792 <mm_map>
ffffffffc0204a70:	892a                	mv	s2,a0
ffffffffc0204a72:	ed2d                	bnez	a0,ffffffffc0204aec <do_execve+0x31a>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204a74:	010a3b83          	ld	s7,16(s4)
ffffffffc0204a78:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204a7a:	020a3903          	ld	s2,32(s4)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a7e:	008a3983          	ld	s3,8(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204a82:	00fbfb33          	and	s6,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a86:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204a88:	995e                	add	s2,s2,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204a8a:	99be                	add	s3,s3,a5
        while (start < end)
ffffffffc0204a8c:	052be863          	bltu	s7,s2,ffffffffc0204adc <do_execve+0x30a>
ffffffffc0204a90:	a271                	j	ffffffffc0204c1c <do_execve+0x44a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204a92:	6785                	lui	a5,0x1
ffffffffc0204a94:	416b8533          	sub	a0,s7,s6
ffffffffc0204a98:	9b3e                	add	s6,s6,a5
            if (end < la)
ffffffffc0204a9a:	41790633          	sub	a2,s2,s7
ffffffffc0204a9e:	01696463          	bltu	s2,s6,ffffffffc0204aa6 <do_execve+0x2d4>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204aa2:	417b0633          	sub	a2,s6,s7
    return page - pages + nbase;
ffffffffc0204aa6:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204aaa:	67e2                	ld	a5,24(sp)
ffffffffc0204aac:	000d3583          	ld	a1,0(s10)
    return page - pages + nbase;
ffffffffc0204ab0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ab4:	8699                	srai	a3,a3,0x6
ffffffffc0204ab6:	96e2                	add	a3,a3,s8
    return KADDR(page2pa(page));
ffffffffc0204ab8:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204abc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204abe:	16b87563          	bgeu	a6,a1,ffffffffc0204c28 <do_execve+0x456>
ffffffffc0204ac2:	000ab803          	ld	a6,0(s5)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204ac6:	85ce                	mv	a1,s3
ffffffffc0204ac8:	e432                	sd	a2,8(sp)
ffffffffc0204aca:	96c2                	add	a3,a3,a6
ffffffffc0204acc:	9536                	add	a0,a0,a3
ffffffffc0204ace:	3cb000ef          	jal	ffffffffc0205698 <memcpy>
            start += size, from += size;
ffffffffc0204ad2:	6622                	ld	a2,8(sp)
ffffffffc0204ad4:	9bb2                	add	s7,s7,a2
ffffffffc0204ad6:	99b2                	add	s3,s3,a2
        while (start < end)
ffffffffc0204ad8:	052bf163          	bgeu	s7,s2,ffffffffc0204b1a <do_execve+0x348>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204adc:	6c88                	ld	a0,24(s1)
ffffffffc0204ade:	6642                	ld	a2,16(sp)
ffffffffc0204ae0:	85da                	mv	a1,s6
ffffffffc0204ae2:	a2dfe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc0204ae6:	842a                	mv	s0,a0
ffffffffc0204ae8:	f54d                	bnez	a0,ffffffffc0204a92 <do_execve+0x2c0>
        ret = -E_NO_MEM;
ffffffffc0204aea:	5971                	li	s2,-4
    exit_mmap(mm);
ffffffffc0204aec:	8526                	mv	a0,s1
ffffffffc0204aee:	e0bfe0ef          	jal	ffffffffc02038f8 <exit_mmap>
ffffffffc0204af2:	b501                	j	ffffffffc02048f2 <do_execve+0x120>
            exit_mmap(mm);
ffffffffc0204af4:	854e                	mv	a0,s3
ffffffffc0204af6:	e03fe0ef          	jal	ffffffffc02038f8 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204afa:	854e                	mv	a0,s3
ffffffffc0204afc:	b56ff0ef          	jal	ffffffffc0203e52 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204b00:	854e                	mv	a0,s3
ffffffffc0204b02:	c3ffe0ef          	jal	ffffffffc0203740 <mm_destroy>
ffffffffc0204b06:	bbb9                	j	ffffffffc0204864 <do_execve+0x92>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204b08:	0e079963          	bnez	a5,ffffffffc0204bfa <do_execve+0x428>
            vm_flags |= VM_WRITE;
ffffffffc0204b0c:	00276713          	ori	a4,a4,2
ffffffffc0204b10:	0007069b          	sext.w	a3,a4
            perm |= (PTE_W | PTE_R);
ffffffffc0204b14:	47dd                	li	a5,23
ffffffffc0204b16:	e83e                	sd	a5,16(sp)
ffffffffc0204b18:	bf3d                	j	ffffffffc0204a56 <do_execve+0x284>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204b1a:	010a3903          	ld	s2,16(s4)
ffffffffc0204b1e:	028a3683          	ld	a3,40(s4)
ffffffffc0204b22:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204b24:	076bf963          	bgeu	s7,s6,ffffffffc0204b96 <do_execve+0x3c4>
            if (start == end)
ffffffffc0204b28:	e37905e3          	beq	s2,s7,ffffffffc0204952 <do_execve+0x180>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204b2c:	6505                	lui	a0,0x1
ffffffffc0204b2e:	955e                	add	a0,a0,s7
ffffffffc0204b30:	41650533          	sub	a0,a0,s6
                size -= la - end;
ffffffffc0204b34:	417909b3          	sub	s3,s2,s7
            if (end < la)
ffffffffc0204b38:	0d697d63          	bgeu	s2,s6,ffffffffc0204c12 <do_execve+0x440>
    return page - pages + nbase;
ffffffffc0204b3c:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204b40:	000d3603          	ld	a2,0(s10)
    return page - pages + nbase;
ffffffffc0204b44:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b48:	8699                	srai	a3,a3,0x6
ffffffffc0204b4a:	96e2                	add	a3,a3,s8
    return KADDR(page2pa(page));
ffffffffc0204b4c:	00c69593          	slli	a1,a3,0xc
ffffffffc0204b50:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b52:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b54:	0cc5fa63          	bgeu	a1,a2,ffffffffc0204c28 <do_execve+0x456>
ffffffffc0204b58:	000ab803          	ld	a6,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204b5c:	864e                	mv	a2,s3
ffffffffc0204b5e:	4581                	li	a1,0
ffffffffc0204b60:	96c2                	add	a3,a3,a6
ffffffffc0204b62:	9536                	add	a0,a0,a3
ffffffffc0204b64:	323000ef          	jal	ffffffffc0205686 <memset>
            start += size;
ffffffffc0204b68:	9bce                	add	s7,s7,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204b6a:	03697463          	bgeu	s2,s6,ffffffffc0204b92 <do_execve+0x3c0>
ffffffffc0204b6e:	df7902e3          	beq	s2,s7,ffffffffc0204952 <do_execve+0x180>
ffffffffc0204b72:	00002697          	auipc	a3,0x2
ffffffffc0204b76:	4fe68693          	addi	a3,a3,1278 # ffffffffc0207070 <etext+0x19c0>
ffffffffc0204b7a:	00001617          	auipc	a2,0x1
ffffffffc0204b7e:	51660613          	addi	a2,a2,1302 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204b82:	2bf00593          	li	a1,703
ffffffffc0204b86:	00002517          	auipc	a0,0x2
ffffffffc0204b8a:	2da50513          	addi	a0,a0,730 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204b8e:	8fbfb0ef          	jal	ffffffffc0200488 <__panic>
ffffffffc0204b92:	ff7b10e3          	bne	s6,s7,ffffffffc0204b72 <do_execve+0x3a0>
        while (start < end)
ffffffffc0204b96:	db2bfee3          	bgeu	s7,s2,ffffffffc0204952 <do_execve+0x180>
ffffffffc0204b9a:	56fd                	li	a3,-1
ffffffffc0204b9c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204ba0:	e43e                	sd	a5,8(sp)
ffffffffc0204ba2:	a0a1                	j	ffffffffc0204bea <do_execve+0x418>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204ba4:	6785                	lui	a5,0x1
ffffffffc0204ba6:	416b8533          	sub	a0,s7,s6
ffffffffc0204baa:	9b3e                	add	s6,s6,a5
            if (end < la)
ffffffffc0204bac:	417909b3          	sub	s3,s2,s7
ffffffffc0204bb0:	01696463          	bltu	s2,s6,ffffffffc0204bb8 <do_execve+0x3e6>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204bb4:	417b09b3          	sub	s3,s6,s7
    return page - pages + nbase;
ffffffffc0204bb8:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204bbc:	67a2                	ld	a5,8(sp)
ffffffffc0204bbe:	000d3583          	ld	a1,0(s10)
    return page - pages + nbase;
ffffffffc0204bc2:	40d406b3          	sub	a3,s0,a3
ffffffffc0204bc6:	8699                	srai	a3,a3,0x6
ffffffffc0204bc8:	96e2                	add	a3,a3,s8
    return KADDR(page2pa(page));
ffffffffc0204bca:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bce:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bd0:	04b87c63          	bgeu	a6,a1,ffffffffc0204c28 <do_execve+0x456>
ffffffffc0204bd4:	000ab803          	ld	a6,0(s5)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bd8:	864e                	mv	a2,s3
ffffffffc0204bda:	4581                	li	a1,0
ffffffffc0204bdc:	96c2                	add	a3,a3,a6
ffffffffc0204bde:	9536                	add	a0,a0,a3
            start += size;
ffffffffc0204be0:	9bce                	add	s7,s7,s3
            memset(page2kva(page) + off, 0, size);
ffffffffc0204be2:	2a5000ef          	jal	ffffffffc0205686 <memset>
        while (start < end)
ffffffffc0204be6:	d72bf6e3          	bgeu	s7,s2,ffffffffc0204952 <do_execve+0x180>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204bea:	6c88                	ld	a0,24(s1)
ffffffffc0204bec:	6642                	ld	a2,16(sp)
ffffffffc0204bee:	85da                	mv	a1,s6
ffffffffc0204bf0:	91ffe0ef          	jal	ffffffffc020350e <pgdir_alloc_page>
ffffffffc0204bf4:	842a                	mv	s0,a0
ffffffffc0204bf6:	f55d                	bnez	a0,ffffffffc0204ba4 <do_execve+0x3d2>
ffffffffc0204bf8:	bdcd                	j	ffffffffc0204aea <do_execve+0x318>
            vm_flags |= VM_READ;
ffffffffc0204bfa:	00376713          	ori	a4,a4,3
ffffffffc0204bfe:	0007069b          	sext.w	a3,a4
        if (vm_flags & VM_WRITE)
ffffffffc0204c02:	bf09                	j	ffffffffc0204b14 <do_execve+0x342>
            vm_flags |= VM_READ;
ffffffffc0204c04:	00176713          	ori	a4,a4,1
ffffffffc0204c08:	47cd                	li	a5,19
ffffffffc0204c0a:	0007069b          	sext.w	a3,a4
ffffffffc0204c0e:	e83e                	sd	a5,16(sp)
ffffffffc0204c10:	b599                	j	ffffffffc0204a56 <do_execve+0x284>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c12:	417b09b3          	sub	s3,s6,s7
ffffffffc0204c16:	b71d                	j	ffffffffc0204b3c <do_execve+0x36a>
        return -E_INVAL;
ffffffffc0204c18:	5975                	li	s2,-3
ffffffffc0204c1a:	bbf5                	j	ffffffffc0204a16 <do_execve+0x244>
        while (start < end)
ffffffffc0204c1c:	895e                	mv	s2,s7
ffffffffc0204c1e:	b701                	j	ffffffffc0204b1e <do_execve+0x34c>
    int ret = -E_NO_MEM;
ffffffffc0204c20:	5971                	li	s2,-4
ffffffffc0204c22:	b9d9                	j	ffffffffc02048f8 <do_execve+0x126>
            ret = -E_INVAL_ELF;
ffffffffc0204c24:	5961                	li	s2,-8
ffffffffc0204c26:	b5d9                	j	ffffffffc0204aec <do_execve+0x31a>
ffffffffc0204c28:	00002617          	auipc	a2,0x2
ffffffffc0204c2c:	81860613          	addi	a2,a2,-2024 # ffffffffc0206440 <etext+0xd90>
ffffffffc0204c30:	07100593          	li	a1,113
ffffffffc0204c34:	00002517          	auipc	a0,0x2
ffffffffc0204c38:	83450513          	addi	a0,a0,-1996 # ffffffffc0206468 <etext+0xdb8>
ffffffffc0204c3c:	84dfb0ef          	jal	ffffffffc0200488 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c40:	00002617          	auipc	a2,0x2
ffffffffc0204c44:	8a860613          	addi	a2,a2,-1880 # ffffffffc02064e8 <etext+0xe38>
ffffffffc0204c48:	2de00593          	li	a1,734
ffffffffc0204c4c:	00002517          	auipc	a0,0x2
ffffffffc0204c50:	21450513          	addi	a0,a0,532 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204c54:	835fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c58:	00002697          	auipc	a3,0x2
ffffffffc0204c5c:	53068693          	addi	a3,a3,1328 # ffffffffc0207188 <etext+0x1ad8>
ffffffffc0204c60:	00001617          	auipc	a2,0x1
ffffffffc0204c64:	43060613          	addi	a2,a2,1072 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204c68:	2d900593          	li	a1,729
ffffffffc0204c6c:	00002517          	auipc	a0,0x2
ffffffffc0204c70:	1f450513          	addi	a0,a0,500 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204c74:	815fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c78:	00002697          	auipc	a3,0x2
ffffffffc0204c7c:	4c868693          	addi	a3,a3,1224 # ffffffffc0207140 <etext+0x1a90>
ffffffffc0204c80:	00001617          	auipc	a2,0x1
ffffffffc0204c84:	41060613          	addi	a2,a2,1040 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204c88:	2d800593          	li	a1,728
ffffffffc0204c8c:	00002517          	auipc	a0,0x2
ffffffffc0204c90:	1d450513          	addi	a0,a0,468 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204c94:	ff4fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c98:	00002697          	auipc	a3,0x2
ffffffffc0204c9c:	46068693          	addi	a3,a3,1120 # ffffffffc02070f8 <etext+0x1a48>
ffffffffc0204ca0:	00001617          	auipc	a2,0x1
ffffffffc0204ca4:	3f060613          	addi	a2,a2,1008 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204ca8:	2d700593          	li	a1,727
ffffffffc0204cac:	00002517          	auipc	a0,0x2
ffffffffc0204cb0:	1b450513          	addi	a0,a0,436 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204cb4:	fd4fb0ef          	jal	ffffffffc0200488 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204cb8:	00002697          	auipc	a3,0x2
ffffffffc0204cbc:	3f868693          	addi	a3,a3,1016 # ffffffffc02070b0 <etext+0x1a00>
ffffffffc0204cc0:	00001617          	auipc	a2,0x1
ffffffffc0204cc4:	3d060613          	addi	a2,a2,976 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204cc8:	2d600593          	li	a1,726
ffffffffc0204ccc:	00002517          	auipc	a0,0x2
ffffffffc0204cd0:	19450513          	addi	a0,a0,404 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204cd4:	fb4fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204cd8 <do_yield>:
    current->need_resched = 1;
ffffffffc0204cd8:	00091797          	auipc	a5,0x91
ffffffffc0204cdc:	e807b783          	ld	a5,-384(a5) # ffffffffc0295b58 <current>
ffffffffc0204ce0:	4705                	li	a4,1
ffffffffc0204ce2:	ef98                	sd	a4,24(a5)
}
ffffffffc0204ce4:	4501                	li	a0,0
ffffffffc0204ce6:	8082                	ret

ffffffffc0204ce8 <do_wait>:
{
ffffffffc0204ce8:	1101                	addi	sp,sp,-32
ffffffffc0204cea:	e822                	sd	s0,16(sp)
ffffffffc0204cec:	e426                	sd	s1,8(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204cee:	00091797          	auipc	a5,0x91
ffffffffc0204cf2:	e6a7b783          	ld	a5,-406(a5) # ffffffffc0295b58 <current>
{
ffffffffc0204cf6:	ec06                	sd	ra,24(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204cf8:	779c                	ld	a5,40(a5)
{
ffffffffc0204cfa:	842e                	mv	s0,a1
ffffffffc0204cfc:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204cfe:	c599                	beqz	a1,ffffffffc0204d0c <do_wait+0x24>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d00:	4685                	li	a3,1
ffffffffc0204d02:	4611                	li	a2,4
ffffffffc0204d04:	853e                	mv	a0,a5
ffffffffc0204d06:	f97fe0ef          	jal	ffffffffc0203c9c <user_mem_check>
ffffffffc0204d0a:	c909                	beqz	a0,ffffffffc0204d1c <do_wait+0x34>
ffffffffc0204d0c:	85a2                	mv	a1,s0
}
ffffffffc0204d0e:	6442                	ld	s0,16(sp)
ffffffffc0204d10:	60e2                	ld	ra,24(sp)
ffffffffc0204d12:	8526                	mv	a0,s1
ffffffffc0204d14:	64a2                	ld	s1,8(sp)
ffffffffc0204d16:	6105                	addi	sp,sp,32
ffffffffc0204d18:	fb6ff06f          	j	ffffffffc02044ce <do_wait.part.0>
ffffffffc0204d1c:	60e2                	ld	ra,24(sp)
ffffffffc0204d1e:	6442                	ld	s0,16(sp)
ffffffffc0204d20:	64a2                	ld	s1,8(sp)
ffffffffc0204d22:	5575                	li	a0,-3
ffffffffc0204d24:	6105                	addi	sp,sp,32
ffffffffc0204d26:	8082                	ret

ffffffffc0204d28 <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d28:	6789                	lui	a5,0x2
ffffffffc0204d2a:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204d2e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x65fa>
ffffffffc0204d30:	06e7e963          	bltu	a5,a4,ffffffffc0204da2 <do_kill+0x7a>
{
ffffffffc0204d34:	1141                	addi	sp,sp,-16
ffffffffc0204d36:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204d38:	45a9                	li	a1,10
ffffffffc0204d3a:	842a                	mv	s0,a0
ffffffffc0204d3c:	2501                	sext.w	a0,a0
{
ffffffffc0204d3e:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204d40:	48a000ef          	jal	ffffffffc02051ca <hash32>
ffffffffc0204d44:	02051793          	slli	a5,a0,0x20
ffffffffc0204d48:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204d4c:	0008d797          	auipc	a5,0x8d
ffffffffc0204d50:	d8c78793          	addi	a5,a5,-628 # ffffffffc0291ad8 <hash_list>
ffffffffc0204d54:	953e                	add	a0,a0,a5
ffffffffc0204d56:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204d58:	a029                	j	ffffffffc0204d62 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204d5a:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204d5e:	00870a63          	beq	a4,s0,ffffffffc0204d72 <do_kill+0x4a>
ffffffffc0204d62:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204d64:	fef51be3          	bne	a0,a5,ffffffffc0204d5a <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204d68:	5575                	li	a0,-3
}
ffffffffc0204d6a:	60a2                	ld	ra,8(sp)
ffffffffc0204d6c:	6402                	ld	s0,0(sp)
ffffffffc0204d6e:	0141                	addi	sp,sp,16
ffffffffc0204d70:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204d72:	fd87a703          	lw	a4,-40(a5)
        return -E_KILLED;
ffffffffc0204d76:	555d                	li	a0,-9
        if (!(proc->flags & PF_EXITING))
ffffffffc0204d78:	00177693          	andi	a3,a4,1
ffffffffc0204d7c:	f6fd                	bnez	a3,ffffffffc0204d6a <do_kill+0x42>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204d7e:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204d80:	00176713          	ori	a4,a4,1
ffffffffc0204d84:	fce7ac23          	sw	a4,-40(a5)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204d88:	0006c763          	bltz	a3,ffffffffc0204d96 <do_kill+0x6e>
            return 0;
ffffffffc0204d8c:	4501                	li	a0,0
}
ffffffffc0204d8e:	60a2                	ld	ra,8(sp)
ffffffffc0204d90:	6402                	ld	s0,0(sp)
ffffffffc0204d92:	0141                	addi	sp,sp,16
ffffffffc0204d94:	8082                	ret
                wakeup_proc(proc);
ffffffffc0204d96:	f2878513          	addi	a0,a5,-216
ffffffffc0204d9a:	22a000ef          	jal	ffffffffc0204fc4 <wakeup_proc>
            return 0;
ffffffffc0204d9e:	4501                	li	a0,0
ffffffffc0204da0:	b7fd                	j	ffffffffc0204d8e <do_kill+0x66>
    return -E_INVAL;
ffffffffc0204da2:	5575                	li	a0,-3
}
ffffffffc0204da4:	8082                	ret

ffffffffc0204da6 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204da6:	1101                	addi	sp,sp,-32
ffffffffc0204da8:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204daa:	00091797          	auipc	a5,0x91
ffffffffc0204dae:	d2e78793          	addi	a5,a5,-722 # ffffffffc0295ad8 <proc_list>
ffffffffc0204db2:	ec06                	sd	ra,24(sp)
ffffffffc0204db4:	e822                	sd	s0,16(sp)
ffffffffc0204db6:	e04a                	sd	s2,0(sp)
ffffffffc0204db8:	0008d497          	auipc	s1,0x8d
ffffffffc0204dbc:	d2048493          	addi	s1,s1,-736 # ffffffffc0291ad8 <hash_list>
ffffffffc0204dc0:	e79c                	sd	a5,8(a5)
ffffffffc0204dc2:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204dc4:	00091717          	auipc	a4,0x91
ffffffffc0204dc8:	d1470713          	addi	a4,a4,-748 # ffffffffc0295ad8 <proc_list>
ffffffffc0204dcc:	87a6                	mv	a5,s1
ffffffffc0204dce:	e79c                	sd	a5,8(a5)
ffffffffc0204dd0:	e39c                	sd	a5,0(a5)
ffffffffc0204dd2:	07c1                	addi	a5,a5,16
ffffffffc0204dd4:	fee79de3          	bne	a5,a4,ffffffffc0204dce <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204dd8:	f6dfe0ef          	jal	ffffffffc0203d44 <alloc_proc>
ffffffffc0204ddc:	00091917          	auipc	s2,0x91
ffffffffc0204de0:	d8c90913          	addi	s2,s2,-628 # ffffffffc0295b68 <idleproc>
ffffffffc0204de4:	00a93023          	sd	a0,0(s2)
ffffffffc0204de8:	10050063          	beqz	a0,ffffffffc0204ee8 <proc_init+0x142>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204dec:	4789                	li	a5,2
ffffffffc0204dee:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204df0:	00003797          	auipc	a5,0x3
ffffffffc0204df4:	21078793          	addi	a5,a5,528 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204df8:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204dfc:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204dfe:	4785                	li	a5,1
ffffffffc0204e00:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e02:	4641                	li	a2,16
ffffffffc0204e04:	4581                	li	a1,0
ffffffffc0204e06:	8522                	mv	a0,s0
ffffffffc0204e08:	07f000ef          	jal	ffffffffc0205686 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e0c:	463d                	li	a2,15
ffffffffc0204e0e:	00002597          	auipc	a1,0x2
ffffffffc0204e12:	3da58593          	addi	a1,a1,986 # ffffffffc02071e8 <etext+0x1b38>
ffffffffc0204e16:	8522                	mv	a0,s0
ffffffffc0204e18:	081000ef          	jal	ffffffffc0205698 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e1c:	00091717          	auipc	a4,0x91
ffffffffc0204e20:	d3470713          	addi	a4,a4,-716 # ffffffffc0295b50 <nr_process>
ffffffffc0204e24:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204e26:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e2a:	4601                	li	a2,0
    nr_process++;
ffffffffc0204e2c:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e2e:	4581                	li	a1,0
ffffffffc0204e30:	00000517          	auipc	a0,0x0
ffffffffc0204e34:	87e50513          	addi	a0,a0,-1922 # ffffffffc02046ae <init_main>
    nr_process++;
ffffffffc0204e38:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204e3a:	00091797          	auipc	a5,0x91
ffffffffc0204e3e:	d0d7bf23          	sd	a3,-738(a5) # ffffffffc0295b58 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e42:	cecff0ef          	jal	ffffffffc020432e <kernel_thread>
ffffffffc0204e46:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204e48:	08a05463          	blez	a0,ffffffffc0204ed0 <proc_init+0x12a>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e4c:	6789                	lui	a5,0x2
ffffffffc0204e4e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e52:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x65fa>
ffffffffc0204e54:	2501                	sext.w	a0,a0
ffffffffc0204e56:	02e7e463          	bltu	a5,a4,ffffffffc0204e7e <proc_init+0xd8>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e5a:	45a9                	li	a1,10
ffffffffc0204e5c:	36e000ef          	jal	ffffffffc02051ca <hash32>
ffffffffc0204e60:	02051713          	slli	a4,a0,0x20
ffffffffc0204e64:	01c75793          	srli	a5,a4,0x1c
ffffffffc0204e68:	00f486b3          	add	a3,s1,a5
ffffffffc0204e6c:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204e6e:	a029                	j	ffffffffc0204e78 <proc_init+0xd2>
            if (proc->pid == pid)
ffffffffc0204e70:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204e74:	04870b63          	beq	a4,s0,ffffffffc0204eca <proc_init+0x124>
    return listelm->next;
ffffffffc0204e78:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204e7a:	fef69be3          	bne	a3,a5,ffffffffc0204e70 <proc_init+0xca>
    return NULL;
ffffffffc0204e7e:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e80:	0b478493          	addi	s1,a5,180
ffffffffc0204e84:	4641                	li	a2,16
ffffffffc0204e86:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204e88:	00091417          	auipc	s0,0x91
ffffffffc0204e8c:	cd840413          	addi	s0,s0,-808 # ffffffffc0295b60 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e90:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204e92:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e94:	7f2000ef          	jal	ffffffffc0205686 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e98:	463d                	li	a2,15
ffffffffc0204e9a:	00002597          	auipc	a1,0x2
ffffffffc0204e9e:	37658593          	addi	a1,a1,886 # ffffffffc0207210 <etext+0x1b60>
ffffffffc0204ea2:	8526                	mv	a0,s1
ffffffffc0204ea4:	7f4000ef          	jal	ffffffffc0205698 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204ea8:	00093783          	ld	a5,0(s2)
ffffffffc0204eac:	cbb5                	beqz	a5,ffffffffc0204f20 <proc_init+0x17a>
ffffffffc0204eae:	43dc                	lw	a5,4(a5)
ffffffffc0204eb0:	eba5                	bnez	a5,ffffffffc0204f20 <proc_init+0x17a>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204eb2:	601c                	ld	a5,0(s0)
ffffffffc0204eb4:	c7b1                	beqz	a5,ffffffffc0204f00 <proc_init+0x15a>
ffffffffc0204eb6:	43d8                	lw	a4,4(a5)
ffffffffc0204eb8:	4785                	li	a5,1
ffffffffc0204eba:	04f71363          	bne	a4,a5,ffffffffc0204f00 <proc_init+0x15a>
}
ffffffffc0204ebe:	60e2                	ld	ra,24(sp)
ffffffffc0204ec0:	6442                	ld	s0,16(sp)
ffffffffc0204ec2:	64a2                	ld	s1,8(sp)
ffffffffc0204ec4:	6902                	ld	s2,0(sp)
ffffffffc0204ec6:	6105                	addi	sp,sp,32
ffffffffc0204ec8:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204eca:	f2878793          	addi	a5,a5,-216
ffffffffc0204ece:	bf4d                	j	ffffffffc0204e80 <proc_init+0xda>
        panic("create init_main failed.\n");
ffffffffc0204ed0:	00002617          	auipc	a2,0x2
ffffffffc0204ed4:	32060613          	addi	a2,a2,800 # ffffffffc02071f0 <etext+0x1b40>
ffffffffc0204ed8:	3fc00593          	li	a1,1020
ffffffffc0204edc:	00002517          	auipc	a0,0x2
ffffffffc0204ee0:	f8450513          	addi	a0,a0,-124 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204ee4:	da4fb0ef          	jal	ffffffffc0200488 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204ee8:	00002617          	auipc	a2,0x2
ffffffffc0204eec:	2e860613          	addi	a2,a2,744 # ffffffffc02071d0 <etext+0x1b20>
ffffffffc0204ef0:	3ed00593          	li	a1,1005
ffffffffc0204ef4:	00002517          	auipc	a0,0x2
ffffffffc0204ef8:	f6c50513          	addi	a0,a0,-148 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204efc:	d8cfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f00:	00002697          	auipc	a3,0x2
ffffffffc0204f04:	34068693          	addi	a3,a3,832 # ffffffffc0207240 <etext+0x1b90>
ffffffffc0204f08:	00001617          	auipc	a2,0x1
ffffffffc0204f0c:	18860613          	addi	a2,a2,392 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204f10:	40300593          	li	a1,1027
ffffffffc0204f14:	00002517          	auipc	a0,0x2
ffffffffc0204f18:	f4c50513          	addi	a0,a0,-180 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204f1c:	d6cfb0ef          	jal	ffffffffc0200488 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f20:	00002697          	auipc	a3,0x2
ffffffffc0204f24:	2f868693          	addi	a3,a3,760 # ffffffffc0207218 <etext+0x1b68>
ffffffffc0204f28:	00001617          	auipc	a2,0x1
ffffffffc0204f2c:	16860613          	addi	a2,a2,360 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0204f30:	40200593          	li	a1,1026
ffffffffc0204f34:	00002517          	auipc	a0,0x2
ffffffffc0204f38:	f2c50513          	addi	a0,a0,-212 # ffffffffc0206e60 <etext+0x17b0>
ffffffffc0204f3c:	d4cfb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc0204f40 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204f40:	1141                	addi	sp,sp,-16
ffffffffc0204f42:	e022                	sd	s0,0(sp)
ffffffffc0204f44:	e406                	sd	ra,8(sp)
ffffffffc0204f46:	00091417          	auipc	s0,0x91
ffffffffc0204f4a:	c1240413          	addi	s0,s0,-1006 # ffffffffc0295b58 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204f4e:	6018                	ld	a4,0(s0)
ffffffffc0204f50:	6f1c                	ld	a5,24(a4)
ffffffffc0204f52:	dffd                	beqz	a5,ffffffffc0204f50 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204f54:	10a000ef          	jal	ffffffffc020505e <schedule>
ffffffffc0204f58:	bfdd                	j	ffffffffc0204f4e <cpu_idle+0xe>

ffffffffc0204f5a <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204f5a:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204f5e:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204f62:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204f64:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204f66:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204f6a:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204f6e:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204f72:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204f76:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204f7a:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204f7e:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204f82:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204f86:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204f8a:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204f8e:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204f92:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204f96:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204f98:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204f9a:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204f9e:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204fa2:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204fa6:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0204faa:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204fae:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204fb2:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204fb6:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204fba:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204fbe:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204fc2:	8082                	ret

ffffffffc0204fc4 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fc4:	4118                	lw	a4,0(a0)
{
ffffffffc0204fc6:	1141                	addi	sp,sp,-16
ffffffffc0204fc8:	e406                	sd	ra,8(sp)
ffffffffc0204fca:	e022                	sd	s0,0(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fcc:	478d                	li	a5,3
ffffffffc0204fce:	06f70963          	beq	a4,a5,ffffffffc0205040 <wakeup_proc+0x7c>
ffffffffc0204fd2:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204fd4:	100027f3          	csrr	a5,sstatus
ffffffffc0204fd8:	8b89                	andi	a5,a5,2
ffffffffc0204fda:	eb99                	bnez	a5,ffffffffc0204ff0 <wakeup_proc+0x2c>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0204fdc:	4789                	li	a5,2
ffffffffc0204fde:	02f70763          	beq	a4,a5,ffffffffc020500c <wakeup_proc+0x48>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0204fe2:	60a2                	ld	ra,8(sp)
ffffffffc0204fe4:	6402                	ld	s0,0(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc0204fe6:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc0204fe8:	0e052623          	sw	zero,236(a0)
}
ffffffffc0204fec:	0141                	addi	sp,sp,16
ffffffffc0204fee:	8082                	ret
        intr_disable();
ffffffffc0204ff0:	98bfb0ef          	jal	ffffffffc020097a <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0204ff4:	4018                	lw	a4,0(s0)
ffffffffc0204ff6:	4789                	li	a5,2
ffffffffc0204ff8:	02f70863          	beq	a4,a5,ffffffffc0205028 <wakeup_proc+0x64>
            proc->state = PROC_RUNNABLE;
ffffffffc0204ffc:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0204ffe:	0e042623          	sw	zero,236(s0)
}
ffffffffc0205002:	6402                	ld	s0,0(sp)
ffffffffc0205004:	60a2                	ld	ra,8(sp)
ffffffffc0205006:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205008:	96dfb06f          	j	ffffffffc0200974 <intr_enable>
ffffffffc020500c:	6402                	ld	s0,0(sp)
ffffffffc020500e:	60a2                	ld	ra,8(sp)
            warn("wakeup runnable process.\n");
ffffffffc0205010:	00002617          	auipc	a2,0x2
ffffffffc0205014:	29060613          	addi	a2,a2,656 # ffffffffc02072a0 <etext+0x1bf0>
ffffffffc0205018:	45d1                	li	a1,20
ffffffffc020501a:	00002517          	auipc	a0,0x2
ffffffffc020501e:	26e50513          	addi	a0,a0,622 # ffffffffc0207288 <etext+0x1bd8>
}
ffffffffc0205022:	0141                	addi	sp,sp,16
            warn("wakeup runnable process.\n");
ffffffffc0205024:	ccefb06f          	j	ffffffffc02004f2 <__warn>
ffffffffc0205028:	00002617          	auipc	a2,0x2
ffffffffc020502c:	27860613          	addi	a2,a2,632 # ffffffffc02072a0 <etext+0x1bf0>
ffffffffc0205030:	45d1                	li	a1,20
ffffffffc0205032:	00002517          	auipc	a0,0x2
ffffffffc0205036:	25650513          	addi	a0,a0,598 # ffffffffc0207288 <etext+0x1bd8>
ffffffffc020503a:	cb8fb0ef          	jal	ffffffffc02004f2 <__warn>
    if (flag)
ffffffffc020503e:	b7d1                	j	ffffffffc0205002 <wakeup_proc+0x3e>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205040:	00002697          	auipc	a3,0x2
ffffffffc0205044:	22868693          	addi	a3,a3,552 # ffffffffc0207268 <etext+0x1bb8>
ffffffffc0205048:	00001617          	auipc	a2,0x1
ffffffffc020504c:	04860613          	addi	a2,a2,72 # ffffffffc0206090 <etext+0x9e0>
ffffffffc0205050:	45a5                	li	a1,9
ffffffffc0205052:	00002517          	auipc	a0,0x2
ffffffffc0205056:	23650513          	addi	a0,a0,566 # ffffffffc0207288 <etext+0x1bd8>
ffffffffc020505a:	c2efb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc020505e <schedule>:

void schedule(void)
{
ffffffffc020505e:	1141                	addi	sp,sp,-16
ffffffffc0205060:	e406                	sd	ra,8(sp)
ffffffffc0205062:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205064:	100027f3          	csrr	a5,sstatus
ffffffffc0205068:	8b89                	andi	a5,a5,2
ffffffffc020506a:	4401                	li	s0,0
ffffffffc020506c:	efbd                	bnez	a5,ffffffffc02050ea <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020506e:	00091897          	auipc	a7,0x91
ffffffffc0205072:	aea8b883          	ld	a7,-1302(a7) # ffffffffc0295b58 <current>
ffffffffc0205076:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020507a:	00091517          	auipc	a0,0x91
ffffffffc020507e:	aee53503          	ld	a0,-1298(a0) # ffffffffc0295b68 <idleproc>
ffffffffc0205082:	04a88e63          	beq	a7,a0,ffffffffc02050de <schedule+0x80>
ffffffffc0205086:	0c888693          	addi	a3,a7,200
ffffffffc020508a:	00091617          	auipc	a2,0x91
ffffffffc020508e:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0295ad8 <proc_list>
        le = last;
ffffffffc0205092:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205094:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205096:	4809                	li	a6,2
ffffffffc0205098:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc020509a:	00c78863          	beq	a5,a2,ffffffffc02050aa <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc020509e:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02050a2:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02050a6:	03070163          	beq	a4,a6,ffffffffc02050c8 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02050aa:	fef697e3          	bne	a3,a5,ffffffffc0205098 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050ae:	ed89                	bnez	a1,ffffffffc02050c8 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02050b0:	451c                	lw	a5,8(a0)
ffffffffc02050b2:	2785                	addiw	a5,a5,1
ffffffffc02050b4:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02050b6:	00a88463          	beq	a7,a0,ffffffffc02050be <schedule+0x60>
        {
            proc_run(next);
ffffffffc02050ba:	e0ffe0ef          	jal	ffffffffc0203ec8 <proc_run>
    if (flag)
ffffffffc02050be:	e819                	bnez	s0,ffffffffc02050d4 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02050c0:	60a2                	ld	ra,8(sp)
ffffffffc02050c2:	6402                	ld	s0,0(sp)
ffffffffc02050c4:	0141                	addi	sp,sp,16
ffffffffc02050c6:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050c8:	4198                	lw	a4,0(a1)
ffffffffc02050ca:	4789                	li	a5,2
ffffffffc02050cc:	fef712e3          	bne	a4,a5,ffffffffc02050b0 <schedule+0x52>
ffffffffc02050d0:	852e                	mv	a0,a1
ffffffffc02050d2:	bff9                	j	ffffffffc02050b0 <schedule+0x52>
}
ffffffffc02050d4:	6402                	ld	s0,0(sp)
ffffffffc02050d6:	60a2                	ld	ra,8(sp)
ffffffffc02050d8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02050da:	89bfb06f          	j	ffffffffc0200974 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050de:	00091617          	auipc	a2,0x91
ffffffffc02050e2:	9fa60613          	addi	a2,a2,-1542 # ffffffffc0295ad8 <proc_list>
ffffffffc02050e6:	86b2                	mv	a3,a2
ffffffffc02050e8:	b76d                	j	ffffffffc0205092 <schedule+0x34>
        intr_disable();
ffffffffc02050ea:	891fb0ef          	jal	ffffffffc020097a <intr_disable>
        return 1;
ffffffffc02050ee:	4405                	li	s0,1
ffffffffc02050f0:	bfbd                	j	ffffffffc020506e <schedule+0x10>

ffffffffc02050f2 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02050f2:	00091797          	auipc	a5,0x91
ffffffffc02050f6:	a667b783          	ld	a5,-1434(a5) # ffffffffc0295b58 <current>
}
ffffffffc02050fa:	43c8                	lw	a0,4(a5)
ffffffffc02050fc:	8082                	ret

ffffffffc02050fe <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02050fe:	4501                	li	a0,0
ffffffffc0205100:	8082                	ret

ffffffffc0205102 <sys_putc>:
    cputchar(c);
ffffffffc0205102:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205104:	1141                	addi	sp,sp,-16
ffffffffc0205106:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205108:	8c0fb0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc020510c:	60a2                	ld	ra,8(sp)
ffffffffc020510e:	4501                	li	a0,0
ffffffffc0205110:	0141                	addi	sp,sp,16
ffffffffc0205112:	8082                	ret

ffffffffc0205114 <sys_kill>:
    return do_kill(pid);
ffffffffc0205114:	4108                	lw	a0,0(a0)
ffffffffc0205116:	c13ff06f          	j	ffffffffc0204d28 <do_kill>

ffffffffc020511a <sys_yield>:
    return do_yield();
ffffffffc020511a:	bbfff06f          	j	ffffffffc0204cd8 <do_yield>

ffffffffc020511e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020511e:	6d14                	ld	a3,24(a0)
ffffffffc0205120:	6910                	ld	a2,16(a0)
ffffffffc0205122:	650c                	ld	a1,8(a0)
ffffffffc0205124:	6108                	ld	a0,0(a0)
ffffffffc0205126:	eacff06f          	j	ffffffffc02047d2 <do_execve>

ffffffffc020512a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020512a:	650c                	ld	a1,8(a0)
ffffffffc020512c:	4108                	lw	a0,0(a0)
ffffffffc020512e:	bbbff06f          	j	ffffffffc0204ce8 <do_wait>

ffffffffc0205132 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205132:	00091797          	auipc	a5,0x91
ffffffffc0205136:	a267b783          	ld	a5,-1498(a5) # ffffffffc0295b58 <current>
ffffffffc020513a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020513c:	4501                	li	a0,0
ffffffffc020513e:	6a0c                	ld	a1,16(a2)
ffffffffc0205140:	df5fe06f          	j	ffffffffc0203f34 <do_fork>

ffffffffc0205144 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205144:	4108                	lw	a0,0(a0)
ffffffffc0205146:	a38ff06f          	j	ffffffffc020437e <do_exit>

ffffffffc020514a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020514a:	715d                	addi	sp,sp,-80
ffffffffc020514c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020514e:	00091497          	auipc	s1,0x91
ffffffffc0205152:	a0a48493          	addi	s1,s1,-1526 # ffffffffc0295b58 <current>
ffffffffc0205156:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205158:	e0a2                	sd	s0,64(sp)
ffffffffc020515a:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020515c:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020515e:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205160:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205162:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205166:	0327ee63          	bltu	a5,s2,ffffffffc02051a2 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc020516a:	00391713          	slli	a4,s2,0x3
ffffffffc020516e:	00002797          	auipc	a5,0x2
ffffffffc0205172:	37a78793          	addi	a5,a5,890 # ffffffffc02074e8 <syscalls>
ffffffffc0205176:	97ba                	add	a5,a5,a4
ffffffffc0205178:	639c                	ld	a5,0(a5)
ffffffffc020517a:	c785                	beqz	a5,ffffffffc02051a2 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc020517c:	7028                	ld	a0,96(s0)
ffffffffc020517e:	742c                	ld	a1,104(s0)
ffffffffc0205180:	7834                	ld	a3,112(s0)
ffffffffc0205182:	7c38                	ld	a4,120(s0)
ffffffffc0205184:	6c30                	ld	a2,88(s0)
ffffffffc0205186:	e82a                	sd	a0,16(sp)
ffffffffc0205188:	ec2e                	sd	a1,24(sp)
ffffffffc020518a:	e432                	sd	a2,8(sp)
ffffffffc020518c:	f036                	sd	a3,32(sp)
ffffffffc020518e:	f43a                	sd	a4,40(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205190:	0028                	addi	a0,sp,8
ffffffffc0205192:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205194:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205196:	e828                	sd	a0,80(s0)
}
ffffffffc0205198:	6406                	ld	s0,64(sp)
ffffffffc020519a:	74e2                	ld	s1,56(sp)
ffffffffc020519c:	7942                	ld	s2,48(sp)
ffffffffc020519e:	6161                	addi	sp,sp,80
ffffffffc02051a0:	8082                	ret
    print_trapframe(tf);
ffffffffc02051a2:	8522                	mv	a0,s0
ffffffffc02051a4:	9c7fb0ef          	jal	ffffffffc0200b6a <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02051a8:	609c                	ld	a5,0(s1)
ffffffffc02051aa:	86ca                	mv	a3,s2
ffffffffc02051ac:	00002617          	auipc	a2,0x2
ffffffffc02051b0:	11460613          	addi	a2,a2,276 # ffffffffc02072c0 <etext+0x1c10>
ffffffffc02051b4:	43d8                	lw	a4,4(a5)
ffffffffc02051b6:	06200593          	li	a1,98
ffffffffc02051ba:	0b478793          	addi	a5,a5,180
ffffffffc02051be:	00002517          	auipc	a0,0x2
ffffffffc02051c2:	13250513          	addi	a0,a0,306 # ffffffffc02072f0 <etext+0x1c40>
ffffffffc02051c6:	ac2fb0ef          	jal	ffffffffc0200488 <__panic>

ffffffffc02051ca <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02051ca:	9e3707b7          	lui	a5,0x9e370
ffffffffc02051ce:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e366499>
ffffffffc02051d0:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc02051d4:	02000513          	li	a0,32
ffffffffc02051d8:	9d0d                	subw	a0,a0,a1
}
ffffffffc02051da:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02051de:	8082                	ret

ffffffffc02051e0 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02051e0:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051e4:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02051e6:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051ea:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02051ec:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02051f0:	f022                	sd	s0,32(sp)
ffffffffc02051f2:	ec26                	sd	s1,24(sp)
ffffffffc02051f4:	e84a                	sd	s2,16(sp)
ffffffffc02051f6:	f406                	sd	ra,40(sp)
ffffffffc02051f8:	84aa                	mv	s1,a0
ffffffffc02051fa:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02051fc:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205200:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205202:	05067063          	bgeu	a2,a6,ffffffffc0205242 <printnum+0x62>
ffffffffc0205206:	e44e                	sd	s3,8(sp)
ffffffffc0205208:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020520a:	4785                	li	a5,1
ffffffffc020520c:	00e7d763          	bge	a5,a4,ffffffffc020521a <printnum+0x3a>
            putch(padc, putdat);
ffffffffc0205210:	85ca                	mv	a1,s2
ffffffffc0205212:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0205214:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205216:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205218:	fc65                	bnez	s0,ffffffffc0205210 <printnum+0x30>
ffffffffc020521a:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020521c:	1a02                	slli	s4,s4,0x20
ffffffffc020521e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205222:	00002797          	auipc	a5,0x2
ffffffffc0205226:	0e678793          	addi	a5,a5,230 # ffffffffc0207308 <etext+0x1c58>
ffffffffc020522a:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020522c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020522e:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0205232:	70a2                	ld	ra,40(sp)
ffffffffc0205234:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205236:	85ca                	mv	a1,s2
ffffffffc0205238:	87a6                	mv	a5,s1
}
ffffffffc020523a:	6942                	ld	s2,16(sp)
ffffffffc020523c:	64e2                	ld	s1,24(sp)
ffffffffc020523e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205240:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205242:	03065633          	divu	a2,a2,a6
ffffffffc0205246:	8722                	mv	a4,s0
ffffffffc0205248:	f99ff0ef          	jal	ffffffffc02051e0 <printnum>
ffffffffc020524c:	bfc1                	j	ffffffffc020521c <printnum+0x3c>

ffffffffc020524e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020524e:	7119                	addi	sp,sp,-128
ffffffffc0205250:	f4a6                	sd	s1,104(sp)
ffffffffc0205252:	f0ca                	sd	s2,96(sp)
ffffffffc0205254:	ecce                	sd	s3,88(sp)
ffffffffc0205256:	e8d2                	sd	s4,80(sp)
ffffffffc0205258:	e4d6                	sd	s5,72(sp)
ffffffffc020525a:	e0da                	sd	s6,64(sp)
ffffffffc020525c:	f862                	sd	s8,48(sp)
ffffffffc020525e:	fc86                	sd	ra,120(sp)
ffffffffc0205260:	f8a2                	sd	s0,112(sp)
ffffffffc0205262:	fc5e                	sd	s7,56(sp)
ffffffffc0205264:	f466                	sd	s9,40(sp)
ffffffffc0205266:	f06a                	sd	s10,32(sp)
ffffffffc0205268:	ec6e                	sd	s11,24(sp)
ffffffffc020526a:	892a                	mv	s2,a0
ffffffffc020526c:	84ae                	mv	s1,a1
ffffffffc020526e:	8c32                	mv	s8,a2
ffffffffc0205270:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205272:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205276:	05500b13          	li	s6,85
ffffffffc020527a:	00002a97          	auipc	s5,0x2
ffffffffc020527e:	36ea8a93          	addi	s5,s5,878 # ffffffffc02075e8 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205282:	000c4503          	lbu	a0,0(s8)
ffffffffc0205286:	001c0413          	addi	s0,s8,1
ffffffffc020528a:	01350a63          	beq	a0,s3,ffffffffc020529e <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc020528e:	cd0d                	beqz	a0,ffffffffc02052c8 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0205290:	85a6                	mv	a1,s1
ffffffffc0205292:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205294:	00044503          	lbu	a0,0(s0)
ffffffffc0205298:	0405                	addi	s0,s0,1
ffffffffc020529a:	ff351ae3          	bne	a0,s3,ffffffffc020528e <vprintfmt+0x40>
        char padc = ' ';
ffffffffc020529e:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02052a2:	4b81                	li	s7,0
ffffffffc02052a4:	4601                	li	a2,0
        width = precision = -1;
ffffffffc02052a6:	5d7d                	li	s10,-1
ffffffffc02052a8:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02052aa:	00044683          	lbu	a3,0(s0)
ffffffffc02052ae:	00140c13          	addi	s8,s0,1
ffffffffc02052b2:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02052b6:	0ff5f593          	zext.b	a1,a1
ffffffffc02052ba:	02bb6663          	bltu	s6,a1,ffffffffc02052e6 <vprintfmt+0x98>
ffffffffc02052be:	058a                	slli	a1,a1,0x2
ffffffffc02052c0:	95d6                	add	a1,a1,s5
ffffffffc02052c2:	4198                	lw	a4,0(a1)
ffffffffc02052c4:	9756                	add	a4,a4,s5
ffffffffc02052c6:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02052c8:	70e6                	ld	ra,120(sp)
ffffffffc02052ca:	7446                	ld	s0,112(sp)
ffffffffc02052cc:	74a6                	ld	s1,104(sp)
ffffffffc02052ce:	7906                	ld	s2,96(sp)
ffffffffc02052d0:	69e6                	ld	s3,88(sp)
ffffffffc02052d2:	6a46                	ld	s4,80(sp)
ffffffffc02052d4:	6aa6                	ld	s5,72(sp)
ffffffffc02052d6:	6b06                	ld	s6,64(sp)
ffffffffc02052d8:	7be2                	ld	s7,56(sp)
ffffffffc02052da:	7c42                	ld	s8,48(sp)
ffffffffc02052dc:	7ca2                	ld	s9,40(sp)
ffffffffc02052de:	7d02                	ld	s10,32(sp)
ffffffffc02052e0:	6de2                	ld	s11,24(sp)
ffffffffc02052e2:	6109                	addi	sp,sp,128
ffffffffc02052e4:	8082                	ret
            putch('%', putdat);
ffffffffc02052e6:	85a6                	mv	a1,s1
ffffffffc02052e8:	02500513          	li	a0,37
ffffffffc02052ec:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02052ee:	fff44703          	lbu	a4,-1(s0)
ffffffffc02052f2:	02500793          	li	a5,37
ffffffffc02052f6:	8c22                	mv	s8,s0
ffffffffc02052f8:	f8f705e3          	beq	a4,a5,ffffffffc0205282 <vprintfmt+0x34>
ffffffffc02052fc:	02500713          	li	a4,37
ffffffffc0205300:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0205304:	1c7d                	addi	s8,s8,-1
ffffffffc0205306:	fee79de3          	bne	a5,a4,ffffffffc0205300 <vprintfmt+0xb2>
ffffffffc020530a:	bfa5                	j	ffffffffc0205282 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc020530c:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0205310:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
ffffffffc0205312:	fd068d1b          	addiw	s10,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0205316:	fd07859b          	addiw	a1,a5,-48
                ch = *fmt;
ffffffffc020531a:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020531e:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
ffffffffc0205320:	02b76563          	bltu	a4,a1,ffffffffc020534a <vprintfmt+0xfc>
ffffffffc0205324:	4525                	li	a0,9
                ch = *fmt;
ffffffffc0205326:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020532a:	002d171b          	slliw	a4,s10,0x2
ffffffffc020532e:	01a7073b          	addw	a4,a4,s10
ffffffffc0205332:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205336:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
ffffffffc0205338:	fd07859b          	addiw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020533c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020533e:	fd070d1b          	addiw	s10,a4,-48
                ch = *fmt;
ffffffffc0205342:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
ffffffffc0205346:	feb570e3          	bgeu	a0,a1,ffffffffc0205326 <vprintfmt+0xd8>
            if (width < 0)
ffffffffc020534a:	f60cd0e3          	bgez	s9,ffffffffc02052aa <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc020534e:	8cea                	mv	s9,s10
ffffffffc0205350:	5d7d                	li	s10,-1
ffffffffc0205352:	bfa1                	j	ffffffffc02052aa <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205354:	8db6                	mv	s11,a3
ffffffffc0205356:	8462                	mv	s0,s8
ffffffffc0205358:	bf89                	j	ffffffffc02052aa <vprintfmt+0x5c>
ffffffffc020535a:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc020535c:	4b85                	li	s7,1
            goto reswitch;
ffffffffc020535e:	b7b1                	j	ffffffffc02052aa <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0205360:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205362:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205366:	00c7c463          	blt	a5,a2,ffffffffc020536e <vprintfmt+0x120>
    else if (lflag) {
ffffffffc020536a:	1a060163          	beqz	a2,ffffffffc020550c <vprintfmt+0x2be>
        return va_arg(*ap, unsigned long);
ffffffffc020536e:	000a3603          	ld	a2,0(s4)
ffffffffc0205372:	46c1                	li	a3,16
ffffffffc0205374:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205376:	000d879b          	sext.w	a5,s11
ffffffffc020537a:	8766                	mv	a4,s9
ffffffffc020537c:	85a6                	mv	a1,s1
ffffffffc020537e:	854a                	mv	a0,s2
ffffffffc0205380:	e61ff0ef          	jal	ffffffffc02051e0 <printnum>
            break;
ffffffffc0205384:	bdfd                	j	ffffffffc0205282 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0205386:	000a2503          	lw	a0,0(s4)
ffffffffc020538a:	85a6                	mv	a1,s1
ffffffffc020538c:	0a21                	addi	s4,s4,8
ffffffffc020538e:	9902                	jalr	s2
            break;
ffffffffc0205390:	bdcd                	j	ffffffffc0205282 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205392:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205394:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc0205398:	00c7c463          	blt	a5,a2,ffffffffc02053a0 <vprintfmt+0x152>
    else if (lflag) {
ffffffffc020539c:	16060363          	beqz	a2,ffffffffc0205502 <vprintfmt+0x2b4>
        return va_arg(*ap, unsigned long);
ffffffffc02053a0:	000a3603          	ld	a2,0(s4)
ffffffffc02053a4:	46a9                	li	a3,10
ffffffffc02053a6:	8a3a                	mv	s4,a4
ffffffffc02053a8:	b7f9                	j	ffffffffc0205376 <vprintfmt+0x128>
            putch('0', putdat);
ffffffffc02053aa:	85a6                	mv	a1,s1
ffffffffc02053ac:	03000513          	li	a0,48
ffffffffc02053b0:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02053b2:	85a6                	mv	a1,s1
ffffffffc02053b4:	07800513          	li	a0,120
ffffffffc02053b8:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02053ba:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02053be:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02053c0:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02053c2:	bf55                	j	ffffffffc0205376 <vprintfmt+0x128>
            putch(ch, putdat);
ffffffffc02053c4:	85a6                	mv	a1,s1
ffffffffc02053c6:	02500513          	li	a0,37
ffffffffc02053ca:	9902                	jalr	s2
            break;
ffffffffc02053cc:	bd5d                	j	ffffffffc0205282 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02053ce:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053d2:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02053d4:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02053d6:	bf95                	j	ffffffffc020534a <vprintfmt+0xfc>
    if (lflag >= 2) {
ffffffffc02053d8:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc02053da:	008a0713          	addi	a4,s4,8
    if (lflag >= 2) {
ffffffffc02053de:	00c7c463          	blt	a5,a2,ffffffffc02053e6 <vprintfmt+0x198>
    else if (lflag) {
ffffffffc02053e2:	10060b63          	beqz	a2,ffffffffc02054f8 <vprintfmt+0x2aa>
        return va_arg(*ap, unsigned long);
ffffffffc02053e6:	000a3603          	ld	a2,0(s4)
ffffffffc02053ea:	46a1                	li	a3,8
ffffffffc02053ec:	8a3a                	mv	s4,a4
ffffffffc02053ee:	b761                	j	ffffffffc0205376 <vprintfmt+0x128>
            if (width < 0)
ffffffffc02053f0:	fffcc793          	not	a5,s9
ffffffffc02053f4:	97fd                	srai	a5,a5,0x3f
ffffffffc02053f6:	00fcf7b3          	and	a5,s9,a5
ffffffffc02053fa:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053fe:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205400:	b56d                	j	ffffffffc02052aa <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205402:	000a3403          	ld	s0,0(s4)
ffffffffc0205406:	008a0793          	addi	a5,s4,8
ffffffffc020540a:	e43e                	sd	a5,8(sp)
ffffffffc020540c:	12040063          	beqz	s0,ffffffffc020552c <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0205410:	0d905963          	blez	s9,ffffffffc02054e2 <vprintfmt+0x294>
ffffffffc0205414:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205418:	00140a13          	addi	s4,s0,1
            if (width > 0 && padc != '-') {
ffffffffc020541c:	12fd9763          	bne	s11,a5,ffffffffc020554a <vprintfmt+0x2fc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205420:	00044783          	lbu	a5,0(s0)
ffffffffc0205424:	0007851b          	sext.w	a0,a5
ffffffffc0205428:	cb9d                	beqz	a5,ffffffffc020545e <vprintfmt+0x210>
ffffffffc020542a:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020542c:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205430:	000d4563          	bltz	s10,ffffffffc020543a <vprintfmt+0x1ec>
ffffffffc0205434:	3d7d                	addiw	s10,s10,-1
ffffffffc0205436:	028d0263          	beq	s10,s0,ffffffffc020545a <vprintfmt+0x20c>
                    putch('?', putdat);
ffffffffc020543a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020543c:	0c0b8d63          	beqz	s7,ffffffffc0205516 <vprintfmt+0x2c8>
ffffffffc0205440:	3781                	addiw	a5,a5,-32
ffffffffc0205442:	0cfdfa63          	bgeu	s11,a5,ffffffffc0205516 <vprintfmt+0x2c8>
                    putch('?', putdat);
ffffffffc0205446:	03f00513          	li	a0,63
ffffffffc020544a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020544c:	000a4783          	lbu	a5,0(s4)
ffffffffc0205450:	3cfd                	addiw	s9,s9,-1
ffffffffc0205452:	0a05                	addi	s4,s4,1
ffffffffc0205454:	0007851b          	sext.w	a0,a5
ffffffffc0205458:	ffe1                	bnez	a5,ffffffffc0205430 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
ffffffffc020545a:	01905963          	blez	s9,ffffffffc020546c <vprintfmt+0x21e>
                putch(' ', putdat);
ffffffffc020545e:	85a6                	mv	a1,s1
ffffffffc0205460:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0205464:	3cfd                	addiw	s9,s9,-1
                putch(' ', putdat);
ffffffffc0205466:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0205468:	fe0c9be3          	bnez	s9,ffffffffc020545e <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020546c:	6a22                	ld	s4,8(sp)
ffffffffc020546e:	bd11                	j	ffffffffc0205282 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0205470:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0205472:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0205476:	00c7c363          	blt	a5,a2,ffffffffc020547c <vprintfmt+0x22e>
    else if (lflag) {
ffffffffc020547a:	ce25                	beqz	a2,ffffffffc02054f2 <vprintfmt+0x2a4>
        return va_arg(*ap, long);
ffffffffc020547c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205480:	08044d63          	bltz	s0,ffffffffc020551a <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0205484:	8622                	mv	a2,s0
ffffffffc0205486:	8a5e                	mv	s4,s7
ffffffffc0205488:	46a9                	li	a3,10
ffffffffc020548a:	b5f5                	j	ffffffffc0205376 <vprintfmt+0x128>
            if (err < 0) {
ffffffffc020548c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205490:	4661                	li	a2,24
            if (err < 0) {
ffffffffc0205492:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0205496:	8fb9                	xor	a5,a5,a4
ffffffffc0205498:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020549c:	02d64663          	blt	a2,a3,ffffffffc02054c8 <vprintfmt+0x27a>
ffffffffc02054a0:	00369713          	slli	a4,a3,0x3
ffffffffc02054a4:	00002797          	auipc	a5,0x2
ffffffffc02054a8:	29c78793          	addi	a5,a5,668 # ffffffffc0207740 <error_string>
ffffffffc02054ac:	97ba                	add	a5,a5,a4
ffffffffc02054ae:	639c                	ld	a5,0(a5)
ffffffffc02054b0:	cf81                	beqz	a5,ffffffffc02054c8 <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02054b2:	86be                	mv	a3,a5
ffffffffc02054b4:	00000617          	auipc	a2,0x0
ffffffffc02054b8:	22460613          	addi	a2,a2,548 # ffffffffc02056d8 <etext+0x28>
ffffffffc02054bc:	85a6                	mv	a1,s1
ffffffffc02054be:	854a                	mv	a0,s2
ffffffffc02054c0:	0e8000ef          	jal	ffffffffc02055a8 <printfmt>
            err = va_arg(ap, int);
ffffffffc02054c4:	0a21                	addi	s4,s4,8
ffffffffc02054c6:	bb75                	j	ffffffffc0205282 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02054c8:	00002617          	auipc	a2,0x2
ffffffffc02054cc:	e6060613          	addi	a2,a2,-416 # ffffffffc0207328 <etext+0x1c78>
ffffffffc02054d0:	85a6                	mv	a1,s1
ffffffffc02054d2:	854a                	mv	a0,s2
ffffffffc02054d4:	0d4000ef          	jal	ffffffffc02055a8 <printfmt>
            err = va_arg(ap, int);
ffffffffc02054d8:	0a21                	addi	s4,s4,8
ffffffffc02054da:	b365                	j	ffffffffc0205282 <vprintfmt+0x34>
            lflag ++;
ffffffffc02054dc:	2605                	addiw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054de:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc02054e0:	b3e9                	j	ffffffffc02052aa <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054e2:	00044783          	lbu	a5,0(s0)
ffffffffc02054e6:	0007851b          	sext.w	a0,a5
ffffffffc02054ea:	d3c9                	beqz	a5,ffffffffc020546c <vprintfmt+0x21e>
ffffffffc02054ec:	00140a13          	addi	s4,s0,1
ffffffffc02054f0:	bf2d                	j	ffffffffc020542a <vprintfmt+0x1dc>
        return va_arg(*ap, int);
ffffffffc02054f2:	000a2403          	lw	s0,0(s4)
ffffffffc02054f6:	b769                	j	ffffffffc0205480 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
ffffffffc02054f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02054fc:	46a1                	li	a3,8
ffffffffc02054fe:	8a3a                	mv	s4,a4
ffffffffc0205500:	bd9d                	j	ffffffffc0205376 <vprintfmt+0x128>
ffffffffc0205502:	000a6603          	lwu	a2,0(s4)
ffffffffc0205506:	46a9                	li	a3,10
ffffffffc0205508:	8a3a                	mv	s4,a4
ffffffffc020550a:	b5b5                	j	ffffffffc0205376 <vprintfmt+0x128>
ffffffffc020550c:	000a6603          	lwu	a2,0(s4)
ffffffffc0205510:	46c1                	li	a3,16
ffffffffc0205512:	8a3a                	mv	s4,a4
ffffffffc0205514:	b58d                	j	ffffffffc0205376 <vprintfmt+0x128>
                    putch(ch, putdat);
ffffffffc0205516:	9902                	jalr	s2
ffffffffc0205518:	bf15                	j	ffffffffc020544c <vprintfmt+0x1fe>
                putch('-', putdat);
ffffffffc020551a:	85a6                	mv	a1,s1
ffffffffc020551c:	02d00513          	li	a0,45
ffffffffc0205520:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0205522:	40800633          	neg	a2,s0
ffffffffc0205526:	8a5e                	mv	s4,s7
ffffffffc0205528:	46a9                	li	a3,10
ffffffffc020552a:	b5b1                	j	ffffffffc0205376 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
ffffffffc020552c:	01905663          	blez	s9,ffffffffc0205538 <vprintfmt+0x2ea>
ffffffffc0205530:	02d00793          	li	a5,45
ffffffffc0205534:	04fd9263          	bne	s11,a5,ffffffffc0205578 <vprintfmt+0x32a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205538:	02800793          	li	a5,40
ffffffffc020553c:	00002a17          	auipc	s4,0x2
ffffffffc0205540:	de5a0a13          	addi	s4,s4,-539 # ffffffffc0207321 <etext+0x1c71>
ffffffffc0205544:	02800513          	li	a0,40
ffffffffc0205548:	b5cd                	j	ffffffffc020542a <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020554a:	85ea                	mv	a1,s10
ffffffffc020554c:	8522                	mv	a0,s0
ffffffffc020554e:	094000ef          	jal	ffffffffc02055e2 <strnlen>
ffffffffc0205552:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205556:	01905963          	blez	s9,ffffffffc0205568 <vprintfmt+0x31a>
                    putch(padc, putdat);
ffffffffc020555a:	2d81                	sext.w	s11,s11
ffffffffc020555c:	85a6                	mv	a1,s1
ffffffffc020555e:	856e                	mv	a0,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205560:	3cfd                	addiw	s9,s9,-1
                    putch(padc, putdat);
ffffffffc0205562:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205564:	fe0c9ce3          	bnez	s9,ffffffffc020555c <vprintfmt+0x30e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205568:	00044783          	lbu	a5,0(s0)
ffffffffc020556c:	0007851b          	sext.w	a0,a5
ffffffffc0205570:	ea079de3          	bnez	a5,ffffffffc020542a <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205574:	6a22                	ld	s4,8(sp)
ffffffffc0205576:	b331                	j	ffffffffc0205282 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205578:	85ea                	mv	a1,s10
ffffffffc020557a:	00002517          	auipc	a0,0x2
ffffffffc020557e:	da650513          	addi	a0,a0,-602 # ffffffffc0207320 <etext+0x1c70>
ffffffffc0205582:	060000ef          	jal	ffffffffc02055e2 <strnlen>
ffffffffc0205586:	40ac8cbb          	subw	s9,s9,a0
                p = "(null)";
ffffffffc020558a:	00002417          	auipc	s0,0x2
ffffffffc020558e:	d9640413          	addi	s0,s0,-618 # ffffffffc0207320 <etext+0x1c70>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205592:	00002a17          	auipc	s4,0x2
ffffffffc0205596:	d8fa0a13          	addi	s4,s4,-625 # ffffffffc0207321 <etext+0x1c71>
ffffffffc020559a:	02800793          	li	a5,40
ffffffffc020559e:	02800513          	li	a0,40
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02055a2:	fb904ce3          	bgtz	s9,ffffffffc020555a <vprintfmt+0x30c>
ffffffffc02055a6:	b551                	j	ffffffffc020542a <vprintfmt+0x1dc>

ffffffffc02055a8 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055a8:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02055aa:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055ae:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02055b0:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055b2:	ec06                	sd	ra,24(sp)
ffffffffc02055b4:	f83a                	sd	a4,48(sp)
ffffffffc02055b6:	fc3e                	sd	a5,56(sp)
ffffffffc02055b8:	e0c2                	sd	a6,64(sp)
ffffffffc02055ba:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02055bc:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02055be:	c91ff0ef          	jal	ffffffffc020524e <vprintfmt>
}
ffffffffc02055c2:	60e2                	ld	ra,24(sp)
ffffffffc02055c4:	6161                	addi	sp,sp,80
ffffffffc02055c6:	8082                	ret

ffffffffc02055c8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02055c8:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02055cc:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02055ce:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02055d0:	cb81                	beqz	a5,ffffffffc02055e0 <strlen+0x18>
        cnt ++;
ffffffffc02055d2:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02055d4:	00a707b3          	add	a5,a4,a0
ffffffffc02055d8:	0007c783          	lbu	a5,0(a5)
ffffffffc02055dc:	fbfd                	bnez	a5,ffffffffc02055d2 <strlen+0xa>
ffffffffc02055de:	8082                	ret
    }
    return cnt;
}
ffffffffc02055e0:	8082                	ret

ffffffffc02055e2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02055e2:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02055e4:	e589                	bnez	a1,ffffffffc02055ee <strnlen+0xc>
ffffffffc02055e6:	a811                	j	ffffffffc02055fa <strnlen+0x18>
        cnt ++;
ffffffffc02055e8:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02055ea:	00f58863          	beq	a1,a5,ffffffffc02055fa <strnlen+0x18>
ffffffffc02055ee:	00f50733          	add	a4,a0,a5
ffffffffc02055f2:	00074703          	lbu	a4,0(a4)
ffffffffc02055f6:	fb6d                	bnez	a4,ffffffffc02055e8 <strnlen+0x6>
ffffffffc02055f8:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02055fa:	852e                	mv	a0,a1
ffffffffc02055fc:	8082                	ret

ffffffffc02055fe <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02055fe:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205600:	0005c703          	lbu	a4,0(a1)
ffffffffc0205604:	0785                	addi	a5,a5,1
ffffffffc0205606:	0585                	addi	a1,a1,1
ffffffffc0205608:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020560c:	fb75                	bnez	a4,ffffffffc0205600 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020560e:	8082                	ret

ffffffffc0205610 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205610:	00054783          	lbu	a5,0(a0)
ffffffffc0205614:	e791                	bnez	a5,ffffffffc0205620 <strcmp+0x10>
ffffffffc0205616:	a02d                	j	ffffffffc0205640 <strcmp+0x30>
ffffffffc0205618:	00054783          	lbu	a5,0(a0)
ffffffffc020561c:	cf89                	beqz	a5,ffffffffc0205636 <strcmp+0x26>
ffffffffc020561e:	85b6                	mv	a1,a3
ffffffffc0205620:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0205624:	0505                	addi	a0,a0,1
ffffffffc0205626:	00158693          	addi	a3,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020562a:	fef707e3          	beq	a4,a5,ffffffffc0205618 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020562e:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205632:	9d19                	subw	a0,a0,a4
ffffffffc0205634:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205636:	0015c703          	lbu	a4,1(a1)
ffffffffc020563a:	4501                	li	a0,0
}
ffffffffc020563c:	9d19                	subw	a0,a0,a4
ffffffffc020563e:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205640:	0005c703          	lbu	a4,0(a1)
ffffffffc0205644:	4501                	li	a0,0
ffffffffc0205646:	b7f5                	j	ffffffffc0205632 <strcmp+0x22>

ffffffffc0205648 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205648:	ce01                	beqz	a2,ffffffffc0205660 <strncmp+0x18>
ffffffffc020564a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc020564e:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205650:	cb91                	beqz	a5,ffffffffc0205664 <strncmp+0x1c>
ffffffffc0205652:	0005c703          	lbu	a4,0(a1)
ffffffffc0205656:	00f71763          	bne	a4,a5,ffffffffc0205664 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc020565a:	0505                	addi	a0,a0,1
ffffffffc020565c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020565e:	f675                	bnez	a2,ffffffffc020564a <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205660:	4501                	li	a0,0
ffffffffc0205662:	8082                	ret
ffffffffc0205664:	00054503          	lbu	a0,0(a0)
ffffffffc0205668:	0005c783          	lbu	a5,0(a1)
ffffffffc020566c:	9d1d                	subw	a0,a0,a5
}
ffffffffc020566e:	8082                	ret

ffffffffc0205670 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205670:	00054783          	lbu	a5,0(a0)
ffffffffc0205674:	c799                	beqz	a5,ffffffffc0205682 <strchr+0x12>
        if (*s == c) {
ffffffffc0205676:	00f58763          	beq	a1,a5,ffffffffc0205684 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020567a:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020567e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205680:	fbfd                	bnez	a5,ffffffffc0205676 <strchr+0x6>
    }
    return NULL;
ffffffffc0205682:	4501                	li	a0,0
}
ffffffffc0205684:	8082                	ret

ffffffffc0205686 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205686:	ca01                	beqz	a2,ffffffffc0205696 <memset+0x10>
ffffffffc0205688:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020568a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020568c:	0785                	addi	a5,a5,1
ffffffffc020568e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205692:	fef61de3          	bne	a2,a5,ffffffffc020568c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205696:	8082                	ret

ffffffffc0205698 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205698:	ca19                	beqz	a2,ffffffffc02056ae <memcpy+0x16>
ffffffffc020569a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020569c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020569e:	0005c703          	lbu	a4,0(a1)
ffffffffc02056a2:	0585                	addi	a1,a1,1
ffffffffc02056a4:	0785                	addi	a5,a5,1
ffffffffc02056a6:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02056aa:	feb61ae3          	bne	a2,a1,ffffffffc020569e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02056ae:	8082                	ret
