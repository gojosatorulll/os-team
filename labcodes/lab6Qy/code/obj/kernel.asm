
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

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
ffffffffc020004a:	000f7517          	auipc	a0,0xf7
ffffffffc020004e:	9ce50513          	addi	a0,a0,-1586 # ffffffffc02f6a18 <buf>
ffffffffc0200052:	000fb617          	auipc	a2,0xfb
ffffffffc0200056:	eae60613          	addi	a2,a2,-338 # ffffffffc02faf00 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	760050ef          	jal	ra,ffffffffc02057c2 <memset>
    cons_init(); // init the console
ffffffffc0200066:	520000ef          	jal	ra,ffffffffc0200586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00005597          	auipc	a1,0x5
ffffffffc020006e:	78658593          	addi	a1,a1,1926 # ffffffffc02057f0 <etext+0x4>
ffffffffc0200072:	00005517          	auipc	a0,0x5
ffffffffc0200076:	79e50513          	addi	a0,a0,1950 # ffffffffc0205810 <etext+0x24>
ffffffffc020007a:	11e000ef          	jal	ra,ffffffffc0200198 <cprintf>

    print_kerninfo();
ffffffffc020007e:	1a2000ef          	jal	ra,ffffffffc0200220 <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	576000ef          	jal	ra,ffffffffc02005f8 <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	5c4020ef          	jal	ra,ffffffffc020264a <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	12b000ef          	jal	ra,ffffffffc02009b4 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	129000ef          	jal	ra,ffffffffc02009b6 <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	091030ef          	jal	ra,ffffffffc0203922 <vmm_init>
    sched_init();
ffffffffc0200096:	7c3040ef          	jal	ra,ffffffffc0205058 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	48b040ef          	jal	ra,ffffffffc0204d24 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	4a0000ef          	jal	ra,ffffffffc020053e <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	107000ef          	jal	ra,ffffffffc02009a8 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	617040ef          	jal	ra,ffffffffc0204ebc <cpu_idle>

ffffffffc02000aa <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000aa:	715d                	addi	sp,sp,-80
ffffffffc02000ac:	e486                	sd	ra,72(sp)
ffffffffc02000ae:	e0a6                	sd	s1,64(sp)
ffffffffc02000b0:	fc4a                	sd	s2,56(sp)
ffffffffc02000b2:	f84e                	sd	s3,48(sp)
ffffffffc02000b4:	f452                	sd	s4,40(sp)
ffffffffc02000b6:	f056                	sd	s5,32(sp)
ffffffffc02000b8:	ec5a                	sd	s6,24(sp)
ffffffffc02000ba:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000bc:	c901                	beqz	a0,ffffffffc02000cc <readline+0x22>
ffffffffc02000be:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000c0:	00005517          	auipc	a0,0x5
ffffffffc02000c4:	75850513          	addi	a0,a0,1880 # ffffffffc0205818 <etext+0x2c>
ffffffffc02000c8:	0d0000ef          	jal	ra,ffffffffc0200198 <cprintf>
readline(const char *prompt) {
ffffffffc02000cc:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d0:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000d2:	4aa9                	li	s5,10
ffffffffc02000d4:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d6:	000f7b97          	auipc	s7,0xf7
ffffffffc02000da:	942b8b93          	addi	s7,s7,-1726 # ffffffffc02f6a18 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000de:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000e2:	12e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000e6:	00054a63          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ea:	00a95a63          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc02000ee:	029a5263          	bge	s4,s1,ffffffffc0200112 <readline+0x68>
        c = getchar();
ffffffffc02000f2:	11e000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc02000f6:	fe055ae3          	bgez	a0,ffffffffc02000ea <readline+0x40>
            return NULL;
ffffffffc02000fa:	4501                	li	a0,0
ffffffffc02000fc:	a091                	j	ffffffffc0200140 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fe:	03351463          	bne	a0,s3,ffffffffc0200126 <readline+0x7c>
ffffffffc0200102:	e8a9                	bnez	s1,ffffffffc0200154 <readline+0xaa>
        c = getchar();
ffffffffc0200104:	10c000ef          	jal	ra,ffffffffc0200210 <getchar>
        if (c < 0) {
ffffffffc0200108:	fe0549e3          	bltz	a0,ffffffffc02000fa <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010c:	fea959e3          	bge	s2,a0,ffffffffc02000fe <readline+0x54>
ffffffffc0200110:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200112:	e42a                	sd	a0,8(sp)
ffffffffc0200114:	0ba000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i ++] = c;
ffffffffc0200118:	6522                	ld	a0,8(sp)
ffffffffc020011a:	009b87b3          	add	a5,s7,s1
ffffffffc020011e:	2485                	addiw	s1,s1,1
ffffffffc0200120:	00a78023          	sb	a0,0(a5)
ffffffffc0200124:	bf7d                	j	ffffffffc02000e2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200126:	01550463          	beq	a0,s5,ffffffffc020012e <readline+0x84>
ffffffffc020012a:	fb651ce3          	bne	a0,s6,ffffffffc02000e2 <readline+0x38>
            cputchar(c);
ffffffffc020012e:	0a0000ef          	jal	ra,ffffffffc02001ce <cputchar>
            buf[i] = '\0';
ffffffffc0200132:	000f7517          	auipc	a0,0xf7
ffffffffc0200136:	8e650513          	addi	a0,a0,-1818 # ffffffffc02f6a18 <buf>
ffffffffc020013a:	94aa                	add	s1,s1,a0
ffffffffc020013c:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200140:	60a6                	ld	ra,72(sp)
ffffffffc0200142:	6486                	ld	s1,64(sp)
ffffffffc0200144:	7962                	ld	s2,56(sp)
ffffffffc0200146:	79c2                	ld	s3,48(sp)
ffffffffc0200148:	7a22                	ld	s4,40(sp)
ffffffffc020014a:	7a82                	ld	s5,32(sp)
ffffffffc020014c:	6b62                	ld	s6,24(sp)
ffffffffc020014e:	6bc2                	ld	s7,16(sp)
ffffffffc0200150:	6161                	addi	sp,sp,80
ffffffffc0200152:	8082                	ret
            cputchar(c);
ffffffffc0200154:	4521                	li	a0,8
ffffffffc0200156:	078000ef          	jal	ra,ffffffffc02001ce <cputchar>
            i --;
ffffffffc020015a:	34fd                	addiw	s1,s1,-1
ffffffffc020015c:	b759                	j	ffffffffc02000e2 <readline+0x38>

ffffffffc020015e <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015e:	1141                	addi	sp,sp,-16
ffffffffc0200160:	e022                	sd	s0,0(sp)
ffffffffc0200162:	e406                	sd	ra,8(sp)
ffffffffc0200164:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200166:	422000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    (*cnt)++;
ffffffffc020016a:	401c                	lw	a5,0(s0)
}
ffffffffc020016c:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016e:	2785                	addiw	a5,a5,1
ffffffffc0200170:	c01c                	sw	a5,0(s0)
}
ffffffffc0200172:	6402                	ld	s0,0(sp)
ffffffffc0200174:	0141                	addi	sp,sp,16
ffffffffc0200176:	8082                	ret

ffffffffc0200178 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200178:	1101                	addi	sp,sp,-32
ffffffffc020017a:	862a                	mv	a2,a0
ffffffffc020017c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017e:	00000517          	auipc	a0,0x0
ffffffffc0200182:	fe050513          	addi	a0,a0,-32 # ffffffffc020015e <cputch>
ffffffffc0200186:	006c                	addi	a1,sp,12
{
ffffffffc0200188:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020018a:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020018c:	212050ef          	jal	ra,ffffffffc020539e <vprintfmt>
    return cnt;
}
ffffffffc0200190:	60e2                	ld	ra,24(sp)
ffffffffc0200192:	4532                	lw	a0,12(sp)
ffffffffc0200194:	6105                	addi	sp,sp,32
ffffffffc0200196:	8082                	ret

ffffffffc0200198 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200198:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020019a:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
{
ffffffffc020019e:	8e2a                	mv	t3,a0
ffffffffc02001a0:	f42e                	sd	a1,40(sp)
ffffffffc02001a2:	f832                	sd	a2,48(sp)
ffffffffc02001a4:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	00000517          	auipc	a0,0x0
ffffffffc02001aa:	fb850513          	addi	a0,a0,-72 # ffffffffc020015e <cputch>
ffffffffc02001ae:	004c                	addi	a1,sp,4
ffffffffc02001b0:	869a                	mv	a3,t1
ffffffffc02001b2:	8672                	mv	a2,t3
{
ffffffffc02001b4:	ec06                	sd	ra,24(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	e4be                	sd	a5,72(sp)
ffffffffc02001ba:	e8c2                	sd	a6,80(sp)
ffffffffc02001bc:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001be:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001c0:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001c2:	1dc050ef          	jal	ra,ffffffffc020539e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c6:	60e2                	ld	ra,24(sp)
ffffffffc02001c8:	4512                	lw	a0,4(sp)
ffffffffc02001ca:	6125                	addi	sp,sp,96
ffffffffc02001cc:	8082                	ret

ffffffffc02001ce <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ce:	ae6d                	j	ffffffffc0200588 <cons_putc>

ffffffffc02001d0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001d0:	1101                	addi	sp,sp,-32
ffffffffc02001d2:	e822                	sd	s0,16(sp)
ffffffffc02001d4:	ec06                	sd	ra,24(sp)
ffffffffc02001d6:	e426                	sd	s1,8(sp)
ffffffffc02001d8:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001da:	00054503          	lbu	a0,0(a0)
ffffffffc02001de:	c51d                	beqz	a0,ffffffffc020020c <cputs+0x3c>
ffffffffc02001e0:	0405                	addi	s0,s0,1
ffffffffc02001e2:	4485                	li	s1,1
ffffffffc02001e4:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e6:	3a2000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001ea:	00044503          	lbu	a0,0(s0)
ffffffffc02001ee:	008487bb          	addw	a5,s1,s0
ffffffffc02001f2:	0405                	addi	s0,s0,1
ffffffffc02001f4:	f96d                	bnez	a0,ffffffffc02001e6 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f6:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001fa:	4529                	li	a0,10
ffffffffc02001fc:	38c000ef          	jal	ra,ffffffffc0200588 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200200:	60e2                	ld	ra,24(sp)
ffffffffc0200202:	8522                	mv	a0,s0
ffffffffc0200204:	6442                	ld	s0,16(sp)
ffffffffc0200206:	64a2                	ld	s1,8(sp)
ffffffffc0200208:	6105                	addi	sp,sp,32
ffffffffc020020a:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc020020c:	4405                	li	s0,1
ffffffffc020020e:	b7f5                	j	ffffffffc02001fa <cputs+0x2a>

ffffffffc0200210 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200210:	1141                	addi	sp,sp,-16
ffffffffc0200212:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200214:	3a8000ef          	jal	ra,ffffffffc02005bc <cons_getc>
ffffffffc0200218:	dd75                	beqz	a0,ffffffffc0200214 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020021a:	60a2                	ld	ra,8(sp)
ffffffffc020021c:	0141                	addi	sp,sp,16
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200220:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200222:	00005517          	auipc	a0,0x5
ffffffffc0200226:	5fe50513          	addi	a0,a0,1534 # ffffffffc0205820 <etext+0x34>
void print_kerninfo(void) {
ffffffffc020022a:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020022c:	f6dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200230:	00000597          	auipc	a1,0x0
ffffffffc0200234:	e1a58593          	addi	a1,a1,-486 # ffffffffc020004a <kern_init>
ffffffffc0200238:	00005517          	auipc	a0,0x5
ffffffffc020023c:	60850513          	addi	a0,a0,1544 # ffffffffc0205840 <etext+0x54>
ffffffffc0200240:	f59ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200244:	00005597          	auipc	a1,0x5
ffffffffc0200248:	5a858593          	addi	a1,a1,1448 # ffffffffc02057ec <etext>
ffffffffc020024c:	00005517          	auipc	a0,0x5
ffffffffc0200250:	61450513          	addi	a0,a0,1556 # ffffffffc0205860 <etext+0x74>
ffffffffc0200254:	f45ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200258:	000f6597          	auipc	a1,0xf6
ffffffffc020025c:	7c058593          	addi	a1,a1,1984 # ffffffffc02f6a18 <buf>
ffffffffc0200260:	00005517          	auipc	a0,0x5
ffffffffc0200264:	62050513          	addi	a0,a0,1568 # ffffffffc0205880 <etext+0x94>
ffffffffc0200268:	f31ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020026c:	000fb597          	auipc	a1,0xfb
ffffffffc0200270:	c9458593          	addi	a1,a1,-876 # ffffffffc02faf00 <end>
ffffffffc0200274:	00005517          	auipc	a0,0x5
ffffffffc0200278:	62c50513          	addi	a0,a0,1580 # ffffffffc02058a0 <etext+0xb4>
ffffffffc020027c:	f1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200280:	000fb597          	auipc	a1,0xfb
ffffffffc0200284:	07f58593          	addi	a1,a1,127 # ffffffffc02fb2ff <end+0x3ff>
ffffffffc0200288:	00000797          	auipc	a5,0x0
ffffffffc020028c:	dc278793          	addi	a5,a5,-574 # ffffffffc020004a <kern_init>
ffffffffc0200290:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029a:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029e:	95be                	add	a1,a1,a5
ffffffffc02002a0:	85a9                	srai	a1,a1,0xa
ffffffffc02002a2:	00005517          	auipc	a0,0x5
ffffffffc02002a6:	61e50513          	addi	a0,a0,1566 # ffffffffc02058c0 <etext+0xd4>
}
ffffffffc02002aa:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ac:	b5f5                	j	ffffffffc0200198 <cprintf>

ffffffffc02002ae <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002ae:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b0:	00005617          	auipc	a2,0x5
ffffffffc02002b4:	64060613          	addi	a2,a2,1600 # ffffffffc02058f0 <etext+0x104>
ffffffffc02002b8:	04d00593          	li	a1,77
ffffffffc02002bc:	00005517          	auipc	a0,0x5
ffffffffc02002c0:	64c50513          	addi	a0,a0,1612 # ffffffffc0205908 <etext+0x11c>
void print_stackframe(void) {
ffffffffc02002c4:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c6:	1cc000ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02002ca <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002cc:	00005617          	auipc	a2,0x5
ffffffffc02002d0:	65460613          	addi	a2,a2,1620 # ffffffffc0205920 <etext+0x134>
ffffffffc02002d4:	00005597          	auipc	a1,0x5
ffffffffc02002d8:	66c58593          	addi	a1,a1,1644 # ffffffffc0205940 <etext+0x154>
ffffffffc02002dc:	00005517          	auipc	a0,0x5
ffffffffc02002e0:	66c50513          	addi	a0,a0,1644 # ffffffffc0205948 <etext+0x15c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	eb3ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc02002ea:	00005617          	auipc	a2,0x5
ffffffffc02002ee:	66e60613          	addi	a2,a2,1646 # ffffffffc0205958 <etext+0x16c>
ffffffffc02002f2:	00005597          	auipc	a1,0x5
ffffffffc02002f6:	68e58593          	addi	a1,a1,1678 # ffffffffc0205980 <etext+0x194>
ffffffffc02002fa:	00005517          	auipc	a0,0x5
ffffffffc02002fe:	64e50513          	addi	a0,a0,1614 # ffffffffc0205948 <etext+0x15c>
ffffffffc0200302:	e97ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200306:	00005617          	auipc	a2,0x5
ffffffffc020030a:	68a60613          	addi	a2,a2,1674 # ffffffffc0205990 <etext+0x1a4>
ffffffffc020030e:	00005597          	auipc	a1,0x5
ffffffffc0200312:	6a258593          	addi	a1,a1,1698 # ffffffffc02059b0 <etext+0x1c4>
ffffffffc0200316:	00005517          	auipc	a0,0x5
ffffffffc020031a:	63250513          	addi	a0,a0,1586 # ffffffffc0205948 <etext+0x15c>
ffffffffc020031e:	e7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    return 0;
}
ffffffffc0200322:	60a2                	ld	ra,8(sp)
ffffffffc0200324:	4501                	li	a0,0
ffffffffc0200326:	0141                	addi	sp,sp,16
ffffffffc0200328:	8082                	ret

ffffffffc020032a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020032a:	1141                	addi	sp,sp,-16
ffffffffc020032c:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032e:	ef3ff0ef          	jal	ra,ffffffffc0200220 <print_kerninfo>
    return 0;
}
ffffffffc0200332:	60a2                	ld	ra,8(sp)
ffffffffc0200334:	4501                	li	a0,0
ffffffffc0200336:	0141                	addi	sp,sp,16
ffffffffc0200338:	8082                	ret

ffffffffc020033a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020033a:	1141                	addi	sp,sp,-16
ffffffffc020033c:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033e:	f71ff0ef          	jal	ra,ffffffffc02002ae <print_stackframe>
    return 0;
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	0141                	addi	sp,sp,16
ffffffffc0200348:	8082                	ret

ffffffffc020034a <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020034a:	7115                	addi	sp,sp,-224
ffffffffc020034c:	ed5e                	sd	s7,152(sp)
ffffffffc020034e:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200350:	00005517          	auipc	a0,0x5
ffffffffc0200354:	67050513          	addi	a0,a0,1648 # ffffffffc02059c0 <etext+0x1d4>
kmonitor(struct trapframe *tf) {
ffffffffc0200358:	ed86                	sd	ra,216(sp)
ffffffffc020035a:	e9a2                	sd	s0,208(sp)
ffffffffc020035c:	e5a6                	sd	s1,200(sp)
ffffffffc020035e:	e1ca                	sd	s2,192(sp)
ffffffffc0200360:	fd4e                	sd	s3,184(sp)
ffffffffc0200362:	f952                	sd	s4,176(sp)
ffffffffc0200364:	f556                	sd	s5,168(sp)
ffffffffc0200366:	f15a                	sd	s6,160(sp)
ffffffffc0200368:	e962                	sd	s8,144(sp)
ffffffffc020036a:	e566                	sd	s9,136(sp)
ffffffffc020036c:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036e:	e2bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200372:	00005517          	auipc	a0,0x5
ffffffffc0200376:	67650513          	addi	a0,a0,1654 # ffffffffc02059e8 <etext+0x1fc>
ffffffffc020037a:	e1fff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (tf != NULL) {
ffffffffc020037e:	000b8563          	beqz	s7,ffffffffc0200388 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200382:	855e                	mv	a0,s7
ffffffffc0200384:	01b000ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
ffffffffc0200388:	00005c17          	auipc	s8,0x5
ffffffffc020038c:	6d0c0c13          	addi	s8,s8,1744 # ffffffffc0205a58 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200390:	00005917          	auipc	s2,0x5
ffffffffc0200394:	68090913          	addi	s2,s2,1664 # ffffffffc0205a10 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200398:	00005497          	auipc	s1,0x5
ffffffffc020039c:	68048493          	addi	s1,s1,1664 # ffffffffc0205a18 <etext+0x22c>
        if (argc == MAXARGS - 1) {
ffffffffc02003a0:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003a2:	00005b17          	auipc	s6,0x5
ffffffffc02003a6:	67eb0b13          	addi	s6,s6,1662 # ffffffffc0205a20 <etext+0x234>
        argv[argc ++] = buf;
ffffffffc02003aa:	00005a17          	auipc	s4,0x5
ffffffffc02003ae:	596a0a13          	addi	s4,s4,1430 # ffffffffc0205940 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003b2:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b4:	854a                	mv	a0,s2
ffffffffc02003b6:	cf5ff0ef          	jal	ra,ffffffffc02000aa <readline>
ffffffffc02003ba:	842a                	mv	s0,a0
ffffffffc02003bc:	dd65                	beqz	a0,ffffffffc02003b4 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003be:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003c2:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c4:	e1bd                	bnez	a1,ffffffffc020042a <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02003c6:	fe0c87e3          	beqz	s9,ffffffffc02003b4 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ca:	6582                	ld	a1,0(sp)
ffffffffc02003cc:	00005d17          	auipc	s10,0x5
ffffffffc02003d0:	68cd0d13          	addi	s10,s10,1676 # ffffffffc0205a58 <commands>
        argv[argc ++] = buf;
ffffffffc02003d4:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d6:	4401                	li	s0,0
ffffffffc02003d8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003da:	38e050ef          	jal	ra,ffffffffc0205768 <strcmp>
ffffffffc02003de:	c919                	beqz	a0,ffffffffc02003f4 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003e0:	2405                	addiw	s0,s0,1
ffffffffc02003e2:	0b540063          	beq	s0,s5,ffffffffc0200482 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003e6:	000d3503          	ld	a0,0(s10)
ffffffffc02003ea:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ec:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ee:	37a050ef          	jal	ra,ffffffffc0205768 <strcmp>
ffffffffc02003f2:	f57d                	bnez	a0,ffffffffc02003e0 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f4:	00141793          	slli	a5,s0,0x1
ffffffffc02003f8:	97a2                	add	a5,a5,s0
ffffffffc02003fa:	078e                	slli	a5,a5,0x3
ffffffffc02003fc:	97e2                	add	a5,a5,s8
ffffffffc02003fe:	6b9c                	ld	a5,16(a5)
ffffffffc0200400:	865e                	mv	a2,s7
ffffffffc0200402:	002c                	addi	a1,sp,8
ffffffffc0200404:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200408:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020040a:	fa0555e3          	bgez	a0,ffffffffc02003b4 <kmonitor+0x6a>
}
ffffffffc020040e:	60ee                	ld	ra,216(sp)
ffffffffc0200410:	644e                	ld	s0,208(sp)
ffffffffc0200412:	64ae                	ld	s1,200(sp)
ffffffffc0200414:	690e                	ld	s2,192(sp)
ffffffffc0200416:	79ea                	ld	s3,184(sp)
ffffffffc0200418:	7a4a                	ld	s4,176(sp)
ffffffffc020041a:	7aaa                	ld	s5,168(sp)
ffffffffc020041c:	7b0a                	ld	s6,160(sp)
ffffffffc020041e:	6bea                	ld	s7,152(sp)
ffffffffc0200420:	6c4a                	ld	s8,144(sp)
ffffffffc0200422:	6caa                	ld	s9,136(sp)
ffffffffc0200424:	6d0a                	ld	s10,128(sp)
ffffffffc0200426:	612d                	addi	sp,sp,224
ffffffffc0200428:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020042a:	8526                	mv	a0,s1
ffffffffc020042c:	380050ef          	jal	ra,ffffffffc02057ac <strchr>
ffffffffc0200430:	c901                	beqz	a0,ffffffffc0200440 <kmonitor+0xf6>
ffffffffc0200432:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200436:	00040023          	sb	zero,0(s0)
ffffffffc020043a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020043c:	d5c9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc020043e:	b7f5                	j	ffffffffc020042a <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200440:	00044783          	lbu	a5,0(s0)
ffffffffc0200444:	d3c9                	beqz	a5,ffffffffc02003c6 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200446:	033c8963          	beq	s9,s3,ffffffffc0200478 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020044a:	003c9793          	slli	a5,s9,0x3
ffffffffc020044e:	0118                	addi	a4,sp,128
ffffffffc0200450:	97ba                	add	a5,a5,a4
ffffffffc0200452:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200456:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020045a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020045c:	e591                	bnez	a1,ffffffffc0200468 <kmonitor+0x11e>
ffffffffc020045e:	b7b5                	j	ffffffffc02003ca <kmonitor+0x80>
ffffffffc0200460:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200464:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200466:	d1a5                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200468:	8526                	mv	a0,s1
ffffffffc020046a:	342050ef          	jal	ra,ffffffffc02057ac <strchr>
ffffffffc020046e:	d96d                	beqz	a0,ffffffffc0200460 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200470:	00044583          	lbu	a1,0(s0)
ffffffffc0200474:	d9a9                	beqz	a1,ffffffffc02003c6 <kmonitor+0x7c>
ffffffffc0200476:	bf55                	j	ffffffffc020042a <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200478:	45c1                	li	a1,16
ffffffffc020047a:	855a                	mv	a0,s6
ffffffffc020047c:	d1dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0200480:	b7e9                	j	ffffffffc020044a <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200482:	6582                	ld	a1,0(sp)
ffffffffc0200484:	00005517          	auipc	a0,0x5
ffffffffc0200488:	5bc50513          	addi	a0,a0,1468 # ffffffffc0205a40 <etext+0x254>
ffffffffc020048c:	d0dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
ffffffffc0200490:	b715                	j	ffffffffc02003b4 <kmonitor+0x6a>

ffffffffc0200492 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200492:	000fb317          	auipc	t1,0xfb
ffffffffc0200496:	9de30313          	addi	t1,t1,-1570 # ffffffffc02fae70 <is_panic>
ffffffffc020049a:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020049e:	715d                	addi	sp,sp,-80
ffffffffc02004a0:	ec06                	sd	ra,24(sp)
ffffffffc02004a2:	e822                	sd	s0,16(sp)
ffffffffc02004a4:	f436                	sd	a3,40(sp)
ffffffffc02004a6:	f83a                	sd	a4,48(sp)
ffffffffc02004a8:	fc3e                	sd	a5,56(sp)
ffffffffc02004aa:	e0c2                	sd	a6,64(sp)
ffffffffc02004ac:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02004ae:	020e1a63          	bnez	t3,ffffffffc02004e2 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004b2:	4785                	li	a5,1
ffffffffc02004b4:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b8:	8432                	mv	s0,a2
ffffffffc02004ba:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004bc:	862e                	mv	a2,a1
ffffffffc02004be:	85aa                	mv	a1,a0
ffffffffc02004c0:	00005517          	auipc	a0,0x5
ffffffffc02004c4:	5e050513          	addi	a0,a0,1504 # ffffffffc0205aa0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c8:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004ca:	ccfff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ce:	65a2                	ld	a1,8(sp)
ffffffffc02004d0:	8522                	mv	a0,s0
ffffffffc02004d2:	ca7ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc02004d6:	00006517          	auipc	a0,0x6
ffffffffc02004da:	6d250513          	addi	a0,a0,1746 # ffffffffc0206ba8 <default_pmm_manager+0x578>
ffffffffc02004de:	cbbff0ef          	jal	ra,ffffffffc0200198 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004e2:	4501                	li	a0,0
ffffffffc02004e4:	4581                	li	a1,0
ffffffffc02004e6:	4601                	li	a2,0
ffffffffc02004e8:	48a1                	li	a7,8
ffffffffc02004ea:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ee:	4c0000ef          	jal	ra,ffffffffc02009ae <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004f2:	4501                	li	a0,0
ffffffffc02004f4:	e57ff0ef          	jal	ra,ffffffffc020034a <kmonitor>
    while (1) {
ffffffffc02004f8:	bfed                	j	ffffffffc02004f2 <__panic+0x60>

ffffffffc02004fa <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004fa:	715d                	addi	sp,sp,-80
ffffffffc02004fc:	832e                	mv	t1,a1
ffffffffc02004fe:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200500:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200502:	8432                	mv	s0,a2
ffffffffc0200504:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200508:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020050a:	00005517          	auipc	a0,0x5
ffffffffc020050e:	5b650513          	addi	a0,a0,1462 # ffffffffc0205ac0 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200512:	ec06                	sd	ra,24(sp)
ffffffffc0200514:	f436                	sd	a3,40(sp)
ffffffffc0200516:	f83a                	sd	a4,48(sp)
ffffffffc0200518:	e0c2                	sd	a6,64(sp)
ffffffffc020051a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020051c:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051e:	c7bff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200522:	65a2                	ld	a1,8(sp)
ffffffffc0200524:	8522                	mv	a0,s0
ffffffffc0200526:	c53ff0ef          	jal	ra,ffffffffc0200178 <vcprintf>
    cprintf("\n");
ffffffffc020052a:	00006517          	auipc	a0,0x6
ffffffffc020052e:	67e50513          	addi	a0,a0,1662 # ffffffffc0206ba8 <default_pmm_manager+0x578>
ffffffffc0200532:	c67ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    va_end(ap);
}
ffffffffc0200536:	60e2                	ld	ra,24(sp)
ffffffffc0200538:	6442                	ld	s0,16(sp)
ffffffffc020053a:	6161                	addi	sp,sp,80
ffffffffc020053c:	8082                	ret

ffffffffc020053e <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc020053e:	02000793          	li	a5,32
ffffffffc0200542:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200546:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054a:	67e1                	lui	a5,0x18
ffffffffc020054c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf88>
ffffffffc0200550:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200552:	4581                	li	a1,0
ffffffffc0200554:	4601                	li	a2,0
ffffffffc0200556:	4881                	li	a7,0
ffffffffc0200558:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc020055c:	00005517          	auipc	a0,0x5
ffffffffc0200560:	58450513          	addi	a0,a0,1412 # ffffffffc0205ae0 <commands+0x88>
    ticks = 0;
ffffffffc0200564:	000fb797          	auipc	a5,0xfb
ffffffffc0200568:	9007ba23          	sd	zero,-1772(a5) # ffffffffc02fae78 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020056c:	b135                	j	ffffffffc0200198 <cprintf>

ffffffffc020056e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020056e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200572:	67e1                	lui	a5,0x18
ffffffffc0200574:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf88>
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
#include <assert.h>
#include <atomic.h>

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
ffffffffc02005a6:	408000ef          	jal	ra,ffffffffc02009ae <intr_disable>
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
ffffffffc02005ba:	a6fd                	j	ffffffffc02009a8 <intr_enable>

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
ffffffffc02005d8:	3d6000ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02005dc:	4501                	li	a0,0
ffffffffc02005de:	4581                	li	a1,0
ffffffffc02005e0:	4601                	li	a2,0
ffffffffc02005e2:	4889                	li	a7,2
ffffffffc02005e4:	00000073          	ecall
ffffffffc02005e8:	2501                	sext.w	a0,a0
ffffffffc02005ea:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ec:	3bc000ef          	jal	ra,ffffffffc02009a8 <intr_enable>
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
ffffffffc02005f8:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02005fa:	00005517          	auipc	a0,0x5
ffffffffc02005fe:	50650513          	addi	a0,a0,1286 # ffffffffc0205b00 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200602:	fc86                	sd	ra,120(sp)
ffffffffc0200604:	f8a2                	sd	s0,112(sp)
ffffffffc0200606:	e8d2                	sd	s4,80(sp)
ffffffffc0200608:	f4a6                	sd	s1,104(sp)
ffffffffc020060a:	f0ca                	sd	s2,96(sp)
ffffffffc020060c:	ecce                	sd	s3,88(sp)
ffffffffc020060e:	e4d6                	sd	s5,72(sp)
ffffffffc0200610:	e0da                	sd	s6,64(sp)
ffffffffc0200612:	fc5e                	sd	s7,56(sp)
ffffffffc0200614:	f862                	sd	s8,48(sp)
ffffffffc0200616:	f466                	sd	s9,40(sp)
ffffffffc0200618:	f06a                	sd	s10,32(sp)
ffffffffc020061a:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020061c:	b7dff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200620:	0000c597          	auipc	a1,0xc
ffffffffc0200624:	9e05b583          	ld	a1,-1568(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc0200628:	00005517          	auipc	a0,0x5
ffffffffc020062c:	4e850513          	addi	a0,a0,1256 # ffffffffc0205b10 <commands+0xb8>
ffffffffc0200630:	b69ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200634:	0000c417          	auipc	s0,0xc
ffffffffc0200638:	9d440413          	addi	s0,s0,-1580 # ffffffffc020c008 <boot_dtb>
ffffffffc020063c:	600c                	ld	a1,0(s0)
ffffffffc020063e:	00005517          	auipc	a0,0x5
ffffffffc0200642:	4e250513          	addi	a0,a0,1250 # ffffffffc0205b20 <commands+0xc8>
ffffffffc0200646:	b53ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020064a:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020064e:	00005517          	auipc	a0,0x5
ffffffffc0200652:	4ea50513          	addi	a0,a0,1258 # ffffffffc0205b38 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc0200656:	120a0463          	beqz	s4,ffffffffc020077e <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020065a:	57f5                	li	a5,-3
ffffffffc020065c:	07fa                	slli	a5,a5,0x1e
ffffffffc020065e:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200662:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200664:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200668:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020066e:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200672:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067e:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	8ec9                	or	a3,a3,a0
ffffffffc0200682:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200686:	1b7d                	addi	s6,s6,-1
ffffffffc0200688:	0167f7b3          	and	a5,a5,s6
ffffffffc020068c:	8dd5                	or	a1,a1,a3
ffffffffc020068e:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200690:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200694:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfde4fed>
ffffffffc020069a:	10f59163          	bne	a1,a5,ffffffffc020079c <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020069e:	471c                	lw	a5,8(a4)
ffffffffc02006a0:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a2:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a4:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006a8:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006ac:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006bc:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c0:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006cc:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	01146433          	or	s0,s0,a7
ffffffffc02006d2:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006d6:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006da:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006dc:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e0:	8c49                	or	s0,s0,a0
ffffffffc02006e2:	0166f6b3          	and	a3,a3,s6
ffffffffc02006e6:	00ca6a33          	or	s4,s4,a2
ffffffffc02006ea:	0167f7b3          	and	a5,a5,s6
ffffffffc02006ee:	8c55                	or	s0,s0,a3
ffffffffc02006f0:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f4:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006f6:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006f8:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fa:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200706:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200708:	00005917          	auipc	s2,0x5
ffffffffc020070c:	48090913          	addi	s2,s2,1152 # ffffffffc0205b88 <commands+0x130>
ffffffffc0200710:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200712:	4d91                	li	s11,4
ffffffffc0200714:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200716:	00005497          	auipc	s1,0x5
ffffffffc020071a:	46a48493          	addi	s1,s1,1130 # ffffffffc0205b80 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020071e:	000a2703          	lw	a4,0(s4)
ffffffffc0200722:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0087569b          	srliw	a3,a4,0x8
ffffffffc020072a:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200732:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200736:	0107571b          	srliw	a4,a4,0x10
ffffffffc020073a:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073c:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200740:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200744:	8fd5                	or	a5,a5,a3
ffffffffc0200746:	00eb7733          	and	a4,s6,a4
ffffffffc020074a:	8fd9                	or	a5,a5,a4
ffffffffc020074c:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020074e:	09778c63          	beq	a5,s7,ffffffffc02007e6 <dtb_init+0x1ee>
ffffffffc0200752:	00fbea63          	bltu	s7,a5,ffffffffc0200766 <dtb_init+0x16e>
ffffffffc0200756:	07a78663          	beq	a5,s10,ffffffffc02007c2 <dtb_init+0x1ca>
ffffffffc020075a:	4709                	li	a4,2
ffffffffc020075c:	00e79763          	bne	a5,a4,ffffffffc020076a <dtb_init+0x172>
ffffffffc0200760:	4c81                	li	s9,0
ffffffffc0200762:	8a56                	mv	s4,s5
ffffffffc0200764:	bf6d                	j	ffffffffc020071e <dtb_init+0x126>
ffffffffc0200766:	ffb78ee3          	beq	a5,s11,ffffffffc0200762 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020076a:	00005517          	auipc	a0,0x5
ffffffffc020076e:	49650513          	addi	a0,a0,1174 # ffffffffc0205c00 <commands+0x1a8>
ffffffffc0200772:	a27ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200776:	00005517          	auipc	a0,0x5
ffffffffc020077a:	4c250513          	addi	a0,a0,1218 # ffffffffc0205c38 <commands+0x1e0>
}
ffffffffc020077e:	7446                	ld	s0,112(sp)
ffffffffc0200780:	70e6                	ld	ra,120(sp)
ffffffffc0200782:	74a6                	ld	s1,104(sp)
ffffffffc0200784:	7906                	ld	s2,96(sp)
ffffffffc0200786:	69e6                	ld	s3,88(sp)
ffffffffc0200788:	6a46                	ld	s4,80(sp)
ffffffffc020078a:	6aa6                	ld	s5,72(sp)
ffffffffc020078c:	6b06                	ld	s6,64(sp)
ffffffffc020078e:	7be2                	ld	s7,56(sp)
ffffffffc0200790:	7c42                	ld	s8,48(sp)
ffffffffc0200792:	7ca2                	ld	s9,40(sp)
ffffffffc0200794:	7d02                	ld	s10,32(sp)
ffffffffc0200796:	6de2                	ld	s11,24(sp)
ffffffffc0200798:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020079a:	bafd                	j	ffffffffc0200198 <cprintf>
}
ffffffffc020079c:	7446                	ld	s0,112(sp)
ffffffffc020079e:	70e6                	ld	ra,120(sp)
ffffffffc02007a0:	74a6                	ld	s1,104(sp)
ffffffffc02007a2:	7906                	ld	s2,96(sp)
ffffffffc02007a4:	69e6                	ld	s3,88(sp)
ffffffffc02007a6:	6a46                	ld	s4,80(sp)
ffffffffc02007a8:	6aa6                	ld	s5,72(sp)
ffffffffc02007aa:	6b06                	ld	s6,64(sp)
ffffffffc02007ac:	7be2                	ld	s7,56(sp)
ffffffffc02007ae:	7c42                	ld	s8,48(sp)
ffffffffc02007b0:	7ca2                	ld	s9,40(sp)
ffffffffc02007b2:	7d02                	ld	s10,32(sp)
ffffffffc02007b4:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007b6:	00005517          	auipc	a0,0x5
ffffffffc02007ba:	3a250513          	addi	a0,a0,930 # ffffffffc0205b58 <commands+0x100>
}
ffffffffc02007be:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c0:	bae1                	j	ffffffffc0200198 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c2:	8556                	mv	a0,s5
ffffffffc02007c4:	75d040ef          	jal	ra,ffffffffc0205720 <strlen>
ffffffffc02007c8:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007ca:	4619                	li	a2,6
ffffffffc02007cc:	85a6                	mv	a1,s1
ffffffffc02007ce:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d0:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d2:	7b5040ef          	jal	ra,ffffffffc0205786 <strncmp>
ffffffffc02007d6:	e111                	bnez	a0,ffffffffc02007da <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007d8:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007da:	0a91                	addi	s5,s5,4
ffffffffc02007dc:	9ad2                	add	s5,s5,s4
ffffffffc02007de:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e2:	8a56                	mv	s4,s5
ffffffffc02007e4:	bf2d                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007e6:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ea:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ee:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f2:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fe:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200802:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020080e:	00eaeab3          	or	s5,s5,a4
ffffffffc0200812:	00fb77b3          	and	a5,s6,a5
ffffffffc0200816:	00faeab3          	or	s5,s5,a5
ffffffffc020081a:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020081c:	000c9c63          	bnez	s9,ffffffffc0200834 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200820:	1a82                	slli	s5,s5,0x20
ffffffffc0200822:	00368793          	addi	a5,a3,3
ffffffffc0200826:	020ada93          	srli	s5,s5,0x20
ffffffffc020082a:	9abe                	add	s5,s5,a5
ffffffffc020082c:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200830:	8a56                	mv	s4,s5
ffffffffc0200832:	b5f5                	j	ffffffffc020071e <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200834:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200838:	85ca                	mv	a1,s2
ffffffffc020083a:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020083c:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200840:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200844:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200848:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200850:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0087979b          	slliw	a5,a5,0x8
ffffffffc020085a:	8d59                	or	a0,a0,a4
ffffffffc020085c:	00fb77b3          	and	a5,s6,a5
ffffffffc0200860:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200862:	1502                	slli	a0,a0,0x20
ffffffffc0200864:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200866:	9522                	add	a0,a0,s0
ffffffffc0200868:	701040ef          	jal	ra,ffffffffc0205768 <strcmp>
ffffffffc020086c:	66a2                	ld	a3,8(sp)
ffffffffc020086e:	f94d                	bnez	a0,ffffffffc0200820 <dtb_init+0x228>
ffffffffc0200870:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200820 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200874:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200878:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020087c:	00005517          	auipc	a0,0x5
ffffffffc0200880:	31450513          	addi	a0,a0,788 # ffffffffc0205b90 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc0200884:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200888:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020088c:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200890:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200894:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200898:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020089c:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a0:	0187d693          	srli	a3,a5,0x18
ffffffffc02008a4:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008a8:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008ac:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b0:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008b4:	010f6f33          	or	t5,t5,a6
ffffffffc02008b8:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008bc:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c0:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008c4:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c8:	0186f6b3          	and	a3,a3,s8
ffffffffc02008cc:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d0:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008d4:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008d8:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008dc:	8361                	srli	a4,a4,0x18
ffffffffc02008de:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e2:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008e6:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008ea:	00cb7633          	and	a2,s6,a2
ffffffffc02008ee:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008f6:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008fa:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008fe:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200902:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200906:	0088989b          	slliw	a7,a7,0x8
ffffffffc020090a:	011b78b3          	and	a7,s6,a7
ffffffffc020090e:	005eeeb3          	or	t4,t4,t0
ffffffffc0200912:	00c6e733          	or	a4,a3,a2
ffffffffc0200916:	006c6c33          	or	s8,s8,t1
ffffffffc020091a:	010b76b3          	and	a3,s6,a6
ffffffffc020091e:	00bb7b33          	and	s6,s6,a1
ffffffffc0200922:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200926:	016c6b33          	or	s6,s8,s6
ffffffffc020092a:	01146433          	or	s0,s0,a7
ffffffffc020092e:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200930:	1702                	slli	a4,a4,0x20
ffffffffc0200932:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200934:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200938:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093a:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	0167eb33          	or	s6,a5,s6
ffffffffc0200942:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200944:	855ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200948:	85a2                	mv	a1,s0
ffffffffc020094a:	00005517          	auipc	a0,0x5
ffffffffc020094e:	26650513          	addi	a0,a0,614 # ffffffffc0205bb0 <commands+0x158>
ffffffffc0200952:	847ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200956:	014b5613          	srli	a2,s6,0x14
ffffffffc020095a:	85da                	mv	a1,s6
ffffffffc020095c:	00005517          	auipc	a0,0x5
ffffffffc0200960:	26c50513          	addi	a0,a0,620 # ffffffffc0205bc8 <commands+0x170>
ffffffffc0200964:	835ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200968:	008b05b3          	add	a1,s6,s0
ffffffffc020096c:	15fd                	addi	a1,a1,-1
ffffffffc020096e:	00005517          	auipc	a0,0x5
ffffffffc0200972:	27a50513          	addi	a0,a0,634 # ffffffffc0205be8 <commands+0x190>
ffffffffc0200976:	823ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc020097a:	00005517          	auipc	a0,0x5
ffffffffc020097e:	2be50513          	addi	a0,a0,702 # ffffffffc0205c38 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200982:	000fa797          	auipc	a5,0xfa
ffffffffc0200986:	4e87bf23          	sd	s0,1278(a5) # ffffffffc02fae80 <memory_base>
        memory_size = mem_size;
ffffffffc020098a:	000fa797          	auipc	a5,0xfa
ffffffffc020098e:	4f67bf23          	sd	s6,1278(a5) # ffffffffc02fae88 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200992:	b3f5                	j	ffffffffc020077e <dtb_init+0x186>

ffffffffc0200994 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200994:	000fa517          	auipc	a0,0xfa
ffffffffc0200998:	4ec53503          	ld	a0,1260(a0) # ffffffffc02fae80 <memory_base>
ffffffffc020099c:	8082                	ret

ffffffffc020099e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc020099e:	000fa517          	auipc	a0,0xfa
ffffffffc02009a2:	4ea53503          	ld	a0,1258(a0) # ffffffffc02fae88 <memory_size>
ffffffffc02009a6:	8082                	ret

ffffffffc02009a8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009a8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009b4:	8082                	ret

ffffffffc02009b6 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009b6:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009ba:	00000797          	auipc	a5,0x0
ffffffffc02009be:	46678793          	addi	a5,a5,1126 # ffffffffc0200e20 <__alltraps>
ffffffffc02009c2:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009c6:	000407b7          	lui	a5,0x40
ffffffffc02009ca:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009ce:	8082                	ret

ffffffffc02009d0 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d0:	610c                	ld	a1,0(a0)
{
ffffffffc02009d2:	1141                	addi	sp,sp,-16
ffffffffc02009d4:	e022                	sd	s0,0(sp)
ffffffffc02009d6:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	27850513          	addi	a0,a0,632 # ffffffffc0205c50 <commands+0x1f8>
{
ffffffffc02009e0:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e2:	fb6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009e6:	640c                	ld	a1,8(s0)
ffffffffc02009e8:	00005517          	auipc	a0,0x5
ffffffffc02009ec:	28050513          	addi	a0,a0,640 # ffffffffc0205c68 <commands+0x210>
ffffffffc02009f0:	fa8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009f4:	680c                	ld	a1,16(s0)
ffffffffc02009f6:	00005517          	auipc	a0,0x5
ffffffffc02009fa:	28a50513          	addi	a0,a0,650 # ffffffffc0205c80 <commands+0x228>
ffffffffc02009fe:	f9aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a02:	6c0c                	ld	a1,24(s0)
ffffffffc0200a04:	00005517          	auipc	a0,0x5
ffffffffc0200a08:	29450513          	addi	a0,a0,660 # ffffffffc0205c98 <commands+0x240>
ffffffffc0200a0c:	f8cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a10:	700c                	ld	a1,32(s0)
ffffffffc0200a12:	00005517          	auipc	a0,0x5
ffffffffc0200a16:	29e50513          	addi	a0,a0,670 # ffffffffc0205cb0 <commands+0x258>
ffffffffc0200a1a:	f7eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a1e:	740c                	ld	a1,40(s0)
ffffffffc0200a20:	00005517          	auipc	a0,0x5
ffffffffc0200a24:	2a850513          	addi	a0,a0,680 # ffffffffc0205cc8 <commands+0x270>
ffffffffc0200a28:	f70ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a2c:	780c                	ld	a1,48(s0)
ffffffffc0200a2e:	00005517          	auipc	a0,0x5
ffffffffc0200a32:	2b250513          	addi	a0,a0,690 # ffffffffc0205ce0 <commands+0x288>
ffffffffc0200a36:	f62ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a3a:	7c0c                	ld	a1,56(s0)
ffffffffc0200a3c:	00005517          	auipc	a0,0x5
ffffffffc0200a40:	2bc50513          	addi	a0,a0,700 # ffffffffc0205cf8 <commands+0x2a0>
ffffffffc0200a44:	f54ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a48:	602c                	ld	a1,64(s0)
ffffffffc0200a4a:	00005517          	auipc	a0,0x5
ffffffffc0200a4e:	2c650513          	addi	a0,a0,710 # ffffffffc0205d10 <commands+0x2b8>
ffffffffc0200a52:	f46ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a56:	642c                	ld	a1,72(s0)
ffffffffc0200a58:	00005517          	auipc	a0,0x5
ffffffffc0200a5c:	2d050513          	addi	a0,a0,720 # ffffffffc0205d28 <commands+0x2d0>
ffffffffc0200a60:	f38ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a64:	682c                	ld	a1,80(s0)
ffffffffc0200a66:	00005517          	auipc	a0,0x5
ffffffffc0200a6a:	2da50513          	addi	a0,a0,730 # ffffffffc0205d40 <commands+0x2e8>
ffffffffc0200a6e:	f2aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a72:	6c2c                	ld	a1,88(s0)
ffffffffc0200a74:	00005517          	auipc	a0,0x5
ffffffffc0200a78:	2e450513          	addi	a0,a0,740 # ffffffffc0205d58 <commands+0x300>
ffffffffc0200a7c:	f1cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a80:	702c                	ld	a1,96(s0)
ffffffffc0200a82:	00005517          	auipc	a0,0x5
ffffffffc0200a86:	2ee50513          	addi	a0,a0,750 # ffffffffc0205d70 <commands+0x318>
ffffffffc0200a8a:	f0eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a8e:	742c                	ld	a1,104(s0)
ffffffffc0200a90:	00005517          	auipc	a0,0x5
ffffffffc0200a94:	2f850513          	addi	a0,a0,760 # ffffffffc0205d88 <commands+0x330>
ffffffffc0200a98:	f00ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a9c:	782c                	ld	a1,112(s0)
ffffffffc0200a9e:	00005517          	auipc	a0,0x5
ffffffffc0200aa2:	30250513          	addi	a0,a0,770 # ffffffffc0205da0 <commands+0x348>
ffffffffc0200aa6:	ef2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200aaa:	7c2c                	ld	a1,120(s0)
ffffffffc0200aac:	00005517          	auipc	a0,0x5
ffffffffc0200ab0:	30c50513          	addi	a0,a0,780 # ffffffffc0205db8 <commands+0x360>
ffffffffc0200ab4:	ee4ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ab8:	604c                	ld	a1,128(s0)
ffffffffc0200aba:	00005517          	auipc	a0,0x5
ffffffffc0200abe:	31650513          	addi	a0,a0,790 # ffffffffc0205dd0 <commands+0x378>
ffffffffc0200ac2:	ed6ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ac6:	644c                	ld	a1,136(s0)
ffffffffc0200ac8:	00005517          	auipc	a0,0x5
ffffffffc0200acc:	32050513          	addi	a0,a0,800 # ffffffffc0205de8 <commands+0x390>
ffffffffc0200ad0:	ec8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ad4:	684c                	ld	a1,144(s0)
ffffffffc0200ad6:	00005517          	auipc	a0,0x5
ffffffffc0200ada:	32a50513          	addi	a0,a0,810 # ffffffffc0205e00 <commands+0x3a8>
ffffffffc0200ade:	ebaff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae2:	6c4c                	ld	a1,152(s0)
ffffffffc0200ae4:	00005517          	auipc	a0,0x5
ffffffffc0200ae8:	33450513          	addi	a0,a0,820 # ffffffffc0205e18 <commands+0x3c0>
ffffffffc0200aec:	eacff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af0:	704c                	ld	a1,160(s0)
ffffffffc0200af2:	00005517          	auipc	a0,0x5
ffffffffc0200af6:	33e50513          	addi	a0,a0,830 # ffffffffc0205e30 <commands+0x3d8>
ffffffffc0200afa:	e9eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200afe:	744c                	ld	a1,168(s0)
ffffffffc0200b00:	00005517          	auipc	a0,0x5
ffffffffc0200b04:	34850513          	addi	a0,a0,840 # ffffffffc0205e48 <commands+0x3f0>
ffffffffc0200b08:	e90ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b0c:	784c                	ld	a1,176(s0)
ffffffffc0200b0e:	00005517          	auipc	a0,0x5
ffffffffc0200b12:	35250513          	addi	a0,a0,850 # ffffffffc0205e60 <commands+0x408>
ffffffffc0200b16:	e82ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b1a:	7c4c                	ld	a1,184(s0)
ffffffffc0200b1c:	00005517          	auipc	a0,0x5
ffffffffc0200b20:	35c50513          	addi	a0,a0,860 # ffffffffc0205e78 <commands+0x420>
ffffffffc0200b24:	e74ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b28:	606c                	ld	a1,192(s0)
ffffffffc0200b2a:	00005517          	auipc	a0,0x5
ffffffffc0200b2e:	36650513          	addi	a0,a0,870 # ffffffffc0205e90 <commands+0x438>
ffffffffc0200b32:	e66ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b36:	646c                	ld	a1,200(s0)
ffffffffc0200b38:	00005517          	auipc	a0,0x5
ffffffffc0200b3c:	37050513          	addi	a0,a0,880 # ffffffffc0205ea8 <commands+0x450>
ffffffffc0200b40:	e58ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b44:	686c                	ld	a1,208(s0)
ffffffffc0200b46:	00005517          	auipc	a0,0x5
ffffffffc0200b4a:	37a50513          	addi	a0,a0,890 # ffffffffc0205ec0 <commands+0x468>
ffffffffc0200b4e:	e4aff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b52:	6c6c                	ld	a1,216(s0)
ffffffffc0200b54:	00005517          	auipc	a0,0x5
ffffffffc0200b58:	38450513          	addi	a0,a0,900 # ffffffffc0205ed8 <commands+0x480>
ffffffffc0200b5c:	e3cff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b60:	706c                	ld	a1,224(s0)
ffffffffc0200b62:	00005517          	auipc	a0,0x5
ffffffffc0200b66:	38e50513          	addi	a0,a0,910 # ffffffffc0205ef0 <commands+0x498>
ffffffffc0200b6a:	e2eff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b6e:	746c                	ld	a1,232(s0)
ffffffffc0200b70:	00005517          	auipc	a0,0x5
ffffffffc0200b74:	39850513          	addi	a0,a0,920 # ffffffffc0205f08 <commands+0x4b0>
ffffffffc0200b78:	e20ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b7c:	786c                	ld	a1,240(s0)
ffffffffc0200b7e:	00005517          	auipc	a0,0x5
ffffffffc0200b82:	3a250513          	addi	a0,a0,930 # ffffffffc0205f20 <commands+0x4c8>
ffffffffc0200b86:	e12ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b8a:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b8c:	6402                	ld	s0,0(sp)
ffffffffc0200b8e:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	00005517          	auipc	a0,0x5
ffffffffc0200b94:	3a850513          	addi	a0,a0,936 # ffffffffc0205f38 <commands+0x4e0>
}
ffffffffc0200b98:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9a:	dfeff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200b9e <print_trapframe>:
{
ffffffffc0200b9e:	1141                	addi	sp,sp,-16
ffffffffc0200ba0:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba2:	85aa                	mv	a1,a0
{
ffffffffc0200ba4:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba6:	00005517          	auipc	a0,0x5
ffffffffc0200baa:	3aa50513          	addi	a0,a0,938 # ffffffffc0205f50 <commands+0x4f8>
{
ffffffffc0200bae:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb0:	de8ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bb4:	8522                	mv	a0,s0
ffffffffc0200bb6:	e1bff0ef          	jal	ra,ffffffffc02009d0 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bba:	10043583          	ld	a1,256(s0)
ffffffffc0200bbe:	00005517          	auipc	a0,0x5
ffffffffc0200bc2:	3aa50513          	addi	a0,a0,938 # ffffffffc0205f68 <commands+0x510>
ffffffffc0200bc6:	dd2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bca:	10843583          	ld	a1,264(s0)
ffffffffc0200bce:	00005517          	auipc	a0,0x5
ffffffffc0200bd2:	3b250513          	addi	a0,a0,946 # ffffffffc0205f80 <commands+0x528>
ffffffffc0200bd6:	dc2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bda:	11043583          	ld	a1,272(s0)
ffffffffc0200bde:	00005517          	auipc	a0,0x5
ffffffffc0200be2:	3ba50513          	addi	a0,a0,954 # ffffffffc0205f98 <commands+0x540>
ffffffffc0200be6:	db2ff0ef          	jal	ra,ffffffffc0200198 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bea:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bee:	6402                	ld	s0,0(sp)
ffffffffc0200bf0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf2:	00005517          	auipc	a0,0x5
ffffffffc0200bf6:	3b650513          	addi	a0,a0,950 # ffffffffc0205fa8 <commands+0x550>
}
ffffffffc0200bfa:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bfc:	d9cff06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0200c00 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c00:	11853783          	ld	a5,280(a0)
ffffffffc0200c04:	472d                	li	a4,11
ffffffffc0200c06:	0786                	slli	a5,a5,0x1
ffffffffc0200c08:	8385                	srli	a5,a5,0x1
ffffffffc0200c0a:	08f76263          	bltu	a4,a5,ffffffffc0200c8e <interrupt_handler+0x8e>
ffffffffc0200c0e:	00005717          	auipc	a4,0x5
ffffffffc0200c12:	46270713          	addi	a4,a4,1122 # ffffffffc0206070 <commands+0x618>
ffffffffc0200c16:	078a                	slli	a5,a5,0x2
ffffffffc0200c18:	97ba                	add	a5,a5,a4
ffffffffc0200c1a:	439c                	lw	a5,0(a5)
ffffffffc0200c1c:	97ba                	add	a5,a5,a4
ffffffffc0200c1e:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c20:	00005517          	auipc	a0,0x5
ffffffffc0200c24:	40050513          	addi	a0,a0,1024 # ffffffffc0206020 <commands+0x5c8>
ffffffffc0200c28:	d70ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c2c:	00005517          	auipc	a0,0x5
ffffffffc0200c30:	3d450513          	addi	a0,a0,980 # ffffffffc0206000 <commands+0x5a8>
ffffffffc0200c34:	d64ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c38:	00005517          	auipc	a0,0x5
ffffffffc0200c3c:	38850513          	addi	a0,a0,904 # ffffffffc0205fc0 <commands+0x568>
ffffffffc0200c40:	d58ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c44:	00005517          	auipc	a0,0x5
ffffffffc0200c48:	39c50513          	addi	a0,a0,924 # ffffffffc0205fe0 <commands+0x588>
ffffffffc0200c4c:	d4cff06f          	j	ffffffffc0200198 <cprintf>
{
ffffffffc0200c50:	1141                	addi	sp,sp,-16
ffffffffc0200c52:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
            clock_set_next_event();   // 设定下次时钟中断
ffffffffc0200c54:	91bff0ef          	jal	ra,ffffffffc020056e <clock_set_next_event>
            static int num = 0;
            ticks++;
ffffffffc0200c58:	000fa797          	auipc	a5,0xfa
ffffffffc0200c5c:	22078793          	addi	a5,a5,544 # ffffffffc02fae78 <ticks>
ffffffffc0200c60:	6398                	ld	a4,0(a5)
ffffffffc0200c62:	0705                	addi	a4,a4,1
ffffffffc0200c64:	e398                	sd	a4,0(a5)

            if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c66:	639c                	ld	a5,0(a5)
ffffffffc0200c68:	06400713          	li	a4,100
ffffffffc0200c6c:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c70:	c385                	beqz	a5,ffffffffc0200c90 <interrupt_handler+0x90>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c72:	60a2                	ld	ra,8(sp)
            sched_class_proc_tick(current);
ffffffffc0200c74:	000fa517          	auipc	a0,0xfa
ffffffffc0200c78:	25c53503          	ld	a0,604(a0) # ffffffffc02faed0 <current>
}
ffffffffc0200c7c:	0141                	addi	sp,sp,16
            sched_class_proc_tick(current);
ffffffffc0200c7e:	3b20406f          	j	ffffffffc0205030 <sched_class_proc_tick>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c82:	00005517          	auipc	a0,0x5
ffffffffc0200c86:	3ce50513          	addi	a0,a0,974 # ffffffffc0206050 <commands+0x5f8>
ffffffffc0200c8a:	d0eff06f          	j	ffffffffc0200198 <cprintf>
        print_trapframe(tf);
ffffffffc0200c8e:	bf01                	j	ffffffffc0200b9e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c90:	06400593          	li	a1,100
ffffffffc0200c94:	00005517          	auipc	a0,0x5
ffffffffc0200c98:	3ac50513          	addi	a0,a0,940 # ffffffffc0206040 <commands+0x5e8>
ffffffffc0200c9c:	cfcff0ef          	jal	ra,ffffffffc0200198 <cprintf>
            num++;
ffffffffc0200ca0:	000fa717          	auipc	a4,0xfa
ffffffffc0200ca4:	1f070713          	addi	a4,a4,496 # ffffffffc02fae90 <num.0>
ffffffffc0200ca8:	431c                	lw	a5,0(a4)
ffffffffc0200caa:	2785                	addiw	a5,a5,1
ffffffffc0200cac:	c31c                	sw	a5,0(a4)
ffffffffc0200cae:	b7d1                	j	ffffffffc0200c72 <interrupt_handler+0x72>

ffffffffc0200cb0 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cb0:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cb4:	1141                	addi	sp,sp,-16
ffffffffc0200cb6:	e022                	sd	s0,0(sp)
ffffffffc0200cb8:	e406                	sd	ra,8(sp)
ffffffffc0200cba:	473d                	li	a4,15
ffffffffc0200cbc:	842a                	mv	s0,a0
ffffffffc0200cbe:	0af76b63          	bltu	a4,a5,ffffffffc0200d74 <exception_handler+0xc4>
ffffffffc0200cc2:	00005717          	auipc	a4,0x5
ffffffffc0200cc6:	56e70713          	addi	a4,a4,1390 # ffffffffc0206230 <commands+0x7d8>
ffffffffc0200cca:	078a                	slli	a5,a5,0x2
ffffffffc0200ccc:	97ba                	add	a5,a5,a4
ffffffffc0200cce:	439c                	lw	a5,0(a5)
ffffffffc0200cd0:	97ba                	add	a5,a5,a4
ffffffffc0200cd2:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cd4:	00005517          	auipc	a0,0x5
ffffffffc0200cd8:	4b450513          	addi	a0,a0,1204 # ffffffffc0206188 <commands+0x730>
ffffffffc0200cdc:	cbcff0ef          	jal	ra,ffffffffc0200198 <cprintf>
        tf->epc += 4;
ffffffffc0200ce0:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200ce4:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200ce6:	0791                	addi	a5,a5,4
ffffffffc0200ce8:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cec:	6402                	ld	s0,0(sp)
ffffffffc0200cee:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cf0:	5aa0406f          	j	ffffffffc020529a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cf4:	00005517          	auipc	a0,0x5
ffffffffc0200cf8:	4b450513          	addi	a0,a0,1204 # ffffffffc02061a8 <commands+0x750>
}
ffffffffc0200cfc:	6402                	ld	s0,0(sp)
ffffffffc0200cfe:	60a2                	ld	ra,8(sp)
ffffffffc0200d00:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d02:	c96ff06f          	j	ffffffffc0200198 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d06:	00005517          	auipc	a0,0x5
ffffffffc0200d0a:	4c250513          	addi	a0,a0,1218 # ffffffffc02061c8 <commands+0x770>
ffffffffc0200d0e:	b7fd                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d10:	00005517          	auipc	a0,0x5
ffffffffc0200d14:	4d850513          	addi	a0,a0,1240 # ffffffffc02061e8 <commands+0x790>
ffffffffc0200d18:	b7d5                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d1a:	00005517          	auipc	a0,0x5
ffffffffc0200d1e:	4e650513          	addi	a0,a0,1254 # ffffffffc0206200 <commands+0x7a8>
ffffffffc0200d22:	bfe9                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d24:	00005517          	auipc	a0,0x5
ffffffffc0200d28:	4f450513          	addi	a0,a0,1268 # ffffffffc0206218 <commands+0x7c0>
ffffffffc0200d2c:	bfc1                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d2e:	00005517          	auipc	a0,0x5
ffffffffc0200d32:	37250513          	addi	a0,a0,882 # ffffffffc02060a0 <commands+0x648>
ffffffffc0200d36:	b7d9                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d38:	00005517          	auipc	a0,0x5
ffffffffc0200d3c:	38850513          	addi	a0,a0,904 # ffffffffc02060c0 <commands+0x668>
ffffffffc0200d40:	bf75                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d42:	00005517          	auipc	a0,0x5
ffffffffc0200d46:	39e50513          	addi	a0,a0,926 # ffffffffc02060e0 <commands+0x688>
ffffffffc0200d4a:	bf4d                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d4c:	00005517          	auipc	a0,0x5
ffffffffc0200d50:	3ac50513          	addi	a0,a0,940 # ffffffffc02060f8 <commands+0x6a0>
ffffffffc0200d54:	b765                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200d56:	00005517          	auipc	a0,0x5
ffffffffc0200d5a:	3b250513          	addi	a0,a0,946 # ffffffffc0206108 <commands+0x6b0>
ffffffffc0200d5e:	bf79                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d60:	00005517          	auipc	a0,0x5
ffffffffc0200d64:	3c850513          	addi	a0,a0,968 # ffffffffc0206128 <commands+0x6d0>
ffffffffc0200d68:	bf51                	j	ffffffffc0200cfc <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	40650513          	addi	a0,a0,1030 # ffffffffc0206170 <commands+0x718>
ffffffffc0200d72:	b769                	j	ffffffffc0200cfc <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d74:	8522                	mv	a0,s0
}
ffffffffc0200d76:	6402                	ld	s0,0(sp)
ffffffffc0200d78:	60a2                	ld	ra,8(sp)
ffffffffc0200d7a:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d7c:	b50d                	j	ffffffffc0200b9e <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d7e:	00005617          	auipc	a2,0x5
ffffffffc0200d82:	3c260613          	addi	a2,a2,962 # ffffffffc0206140 <commands+0x6e8>
ffffffffc0200d86:	0c800593          	li	a1,200
ffffffffc0200d8a:	00005517          	auipc	a0,0x5
ffffffffc0200d8e:	3ce50513          	addi	a0,a0,974 # ffffffffc0206158 <commands+0x700>
ffffffffc0200d92:	f00ff0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0200d96 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200d96:	1101                	addi	sp,sp,-32
ffffffffc0200d98:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200d9a:	000fa417          	auipc	s0,0xfa
ffffffffc0200d9e:	13640413          	addi	s0,s0,310 # ffffffffc02faed0 <current>
ffffffffc0200da2:	6018                	ld	a4,0(s0)
{
ffffffffc0200da4:	ec06                	sd	ra,24(sp)
ffffffffc0200da6:	e426                	sd	s1,8(sp)
ffffffffc0200da8:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200daa:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200dae:	cf1d                	beqz	a4,ffffffffc0200dec <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200db0:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200db4:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200db8:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dba:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dbe:	0206c463          	bltz	a3,ffffffffc0200de6 <trap+0x50>
        exception_handler(tf);
ffffffffc0200dc2:	eefff0ef          	jal	ra,ffffffffc0200cb0 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200dc6:	601c                	ld	a5,0(s0)
ffffffffc0200dc8:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200dcc:	e499                	bnez	s1,ffffffffc0200dda <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200dce:	0b07a703          	lw	a4,176(a5)
ffffffffc0200dd2:	8b05                	andi	a4,a4,1
ffffffffc0200dd4:	e329                	bnez	a4,ffffffffc0200e16 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200dd6:	6f9c                	ld	a5,24(a5)
ffffffffc0200dd8:	eb85                	bnez	a5,ffffffffc0200e08 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200dda:	60e2                	ld	ra,24(sp)
ffffffffc0200ddc:	6442                	ld	s0,16(sp)
ffffffffc0200dde:	64a2                	ld	s1,8(sp)
ffffffffc0200de0:	6902                	ld	s2,0(sp)
ffffffffc0200de2:	6105                	addi	sp,sp,32
ffffffffc0200de4:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200de6:	e1bff0ef          	jal	ra,ffffffffc0200c00 <interrupt_handler>
ffffffffc0200dea:	bff1                	j	ffffffffc0200dc6 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dec:	0006c863          	bltz	a3,ffffffffc0200dfc <trap+0x66>
}
ffffffffc0200df0:	6442                	ld	s0,16(sp)
ffffffffc0200df2:	60e2                	ld	ra,24(sp)
ffffffffc0200df4:	64a2                	ld	s1,8(sp)
ffffffffc0200df6:	6902                	ld	s2,0(sp)
ffffffffc0200df8:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200dfa:	bd5d                	j	ffffffffc0200cb0 <exception_handler>
}
ffffffffc0200dfc:	6442                	ld	s0,16(sp)
ffffffffc0200dfe:	60e2                	ld	ra,24(sp)
ffffffffc0200e00:	64a2                	ld	s1,8(sp)
ffffffffc0200e02:	6902                	ld	s2,0(sp)
ffffffffc0200e04:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e06:	bbed                	j	ffffffffc0200c00 <interrupt_handler>
}
ffffffffc0200e08:	6442                	ld	s0,16(sp)
ffffffffc0200e0a:	60e2                	ld	ra,24(sp)
ffffffffc0200e0c:	64a2                	ld	s1,8(sp)
ffffffffc0200e0e:	6902                	ld	s2,0(sp)
ffffffffc0200e10:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e12:	34a0406f          	j	ffffffffc020515c <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e16:	555d                	li	a0,-9
ffffffffc0200e18:	458030ef          	jal	ra,ffffffffc0204270 <do_exit>
            if (current->need_resched)
ffffffffc0200e1c:	601c                	ld	a5,0(s0)
ffffffffc0200e1e:	bf65                	j	ffffffffc0200dd6 <trap+0x40>

ffffffffc0200e20 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e20:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e24:	00011463          	bnez	sp,ffffffffc0200e2c <__alltraps+0xc>
ffffffffc0200e28:	14002173          	csrr	sp,sscratch
ffffffffc0200e2c:	712d                	addi	sp,sp,-288
ffffffffc0200e2e:	e002                	sd	zero,0(sp)
ffffffffc0200e30:	e406                	sd	ra,8(sp)
ffffffffc0200e32:	ec0e                	sd	gp,24(sp)
ffffffffc0200e34:	f012                	sd	tp,32(sp)
ffffffffc0200e36:	f416                	sd	t0,40(sp)
ffffffffc0200e38:	f81a                	sd	t1,48(sp)
ffffffffc0200e3a:	fc1e                	sd	t2,56(sp)
ffffffffc0200e3c:	e0a2                	sd	s0,64(sp)
ffffffffc0200e3e:	e4a6                	sd	s1,72(sp)
ffffffffc0200e40:	e8aa                	sd	a0,80(sp)
ffffffffc0200e42:	ecae                	sd	a1,88(sp)
ffffffffc0200e44:	f0b2                	sd	a2,96(sp)
ffffffffc0200e46:	f4b6                	sd	a3,104(sp)
ffffffffc0200e48:	f8ba                	sd	a4,112(sp)
ffffffffc0200e4a:	fcbe                	sd	a5,120(sp)
ffffffffc0200e4c:	e142                	sd	a6,128(sp)
ffffffffc0200e4e:	e546                	sd	a7,136(sp)
ffffffffc0200e50:	e94a                	sd	s2,144(sp)
ffffffffc0200e52:	ed4e                	sd	s3,152(sp)
ffffffffc0200e54:	f152                	sd	s4,160(sp)
ffffffffc0200e56:	f556                	sd	s5,168(sp)
ffffffffc0200e58:	f95a                	sd	s6,176(sp)
ffffffffc0200e5a:	fd5e                	sd	s7,184(sp)
ffffffffc0200e5c:	e1e2                	sd	s8,192(sp)
ffffffffc0200e5e:	e5e6                	sd	s9,200(sp)
ffffffffc0200e60:	e9ea                	sd	s10,208(sp)
ffffffffc0200e62:	edee                	sd	s11,216(sp)
ffffffffc0200e64:	f1f2                	sd	t3,224(sp)
ffffffffc0200e66:	f5f6                	sd	t4,232(sp)
ffffffffc0200e68:	f9fa                	sd	t5,240(sp)
ffffffffc0200e6a:	fdfe                	sd	t6,248(sp)
ffffffffc0200e6c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e70:	100024f3          	csrr	s1,sstatus
ffffffffc0200e74:	14102973          	csrr	s2,sepc
ffffffffc0200e78:	143029f3          	csrr	s3,stval
ffffffffc0200e7c:	14202a73          	csrr	s4,scause
ffffffffc0200e80:	e822                	sd	s0,16(sp)
ffffffffc0200e82:	e226                	sd	s1,256(sp)
ffffffffc0200e84:	e64a                	sd	s2,264(sp)
ffffffffc0200e86:	ea4e                	sd	s3,272(sp)
ffffffffc0200e88:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200e8a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200e8c:	f0bff0ef          	jal	ra,ffffffffc0200d96 <trap>

ffffffffc0200e90 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200e90:	6492                	ld	s1,256(sp)
ffffffffc0200e92:	6932                	ld	s2,264(sp)
ffffffffc0200e94:	1004f413          	andi	s0,s1,256
ffffffffc0200e98:	e401                	bnez	s0,ffffffffc0200ea0 <__trapret+0x10>
ffffffffc0200e9a:	1200                	addi	s0,sp,288
ffffffffc0200e9c:	14041073          	csrw	sscratch,s0
ffffffffc0200ea0:	10049073          	csrw	sstatus,s1
ffffffffc0200ea4:	14191073          	csrw	sepc,s2
ffffffffc0200ea8:	60a2                	ld	ra,8(sp)
ffffffffc0200eaa:	61e2                	ld	gp,24(sp)
ffffffffc0200eac:	7202                	ld	tp,32(sp)
ffffffffc0200eae:	72a2                	ld	t0,40(sp)
ffffffffc0200eb0:	7342                	ld	t1,48(sp)
ffffffffc0200eb2:	73e2                	ld	t2,56(sp)
ffffffffc0200eb4:	6406                	ld	s0,64(sp)
ffffffffc0200eb6:	64a6                	ld	s1,72(sp)
ffffffffc0200eb8:	6546                	ld	a0,80(sp)
ffffffffc0200eba:	65e6                	ld	a1,88(sp)
ffffffffc0200ebc:	7606                	ld	a2,96(sp)
ffffffffc0200ebe:	76a6                	ld	a3,104(sp)
ffffffffc0200ec0:	7746                	ld	a4,112(sp)
ffffffffc0200ec2:	77e6                	ld	a5,120(sp)
ffffffffc0200ec4:	680a                	ld	a6,128(sp)
ffffffffc0200ec6:	68aa                	ld	a7,136(sp)
ffffffffc0200ec8:	694a                	ld	s2,144(sp)
ffffffffc0200eca:	69ea                	ld	s3,152(sp)
ffffffffc0200ecc:	7a0a                	ld	s4,160(sp)
ffffffffc0200ece:	7aaa                	ld	s5,168(sp)
ffffffffc0200ed0:	7b4a                	ld	s6,176(sp)
ffffffffc0200ed2:	7bea                	ld	s7,184(sp)
ffffffffc0200ed4:	6c0e                	ld	s8,192(sp)
ffffffffc0200ed6:	6cae                	ld	s9,200(sp)
ffffffffc0200ed8:	6d4e                	ld	s10,208(sp)
ffffffffc0200eda:	6dee                	ld	s11,216(sp)
ffffffffc0200edc:	7e0e                	ld	t3,224(sp)
ffffffffc0200ede:	7eae                	ld	t4,232(sp)
ffffffffc0200ee0:	7f4e                	ld	t5,240(sp)
ffffffffc0200ee2:	7fee                	ld	t6,248(sp)
ffffffffc0200ee4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ee6:	10200073          	sret

ffffffffc0200eea <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200eea:	812a                	mv	sp,a0
ffffffffc0200eec:	b755                	j	ffffffffc0200e90 <__trapret>

ffffffffc0200eee <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200eee:	000f6797          	auipc	a5,0xf6
ffffffffc0200ef2:	f2a78793          	addi	a5,a5,-214 # ffffffffc02f6e18 <free_area>
ffffffffc0200ef6:	e79c                	sd	a5,8(a5)
ffffffffc0200ef8:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200efa:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200efe:	8082                	ret

ffffffffc0200f00 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200f00:	000f6517          	auipc	a0,0xf6
ffffffffc0200f04:	f2856503          	lwu	a0,-216(a0) # ffffffffc02f6e28 <free_area+0x10>
ffffffffc0200f08:	8082                	ret

ffffffffc0200f0a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200f0a:	715d                	addi	sp,sp,-80
ffffffffc0200f0c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200f0e:	000f6417          	auipc	s0,0xf6
ffffffffc0200f12:	f0a40413          	addi	s0,s0,-246 # ffffffffc02f6e18 <free_area>
ffffffffc0200f16:	641c                	ld	a5,8(s0)
ffffffffc0200f18:	e486                	sd	ra,72(sp)
ffffffffc0200f1a:	fc26                	sd	s1,56(sp)
ffffffffc0200f1c:	f84a                	sd	s2,48(sp)
ffffffffc0200f1e:	f44e                	sd	s3,40(sp)
ffffffffc0200f20:	f052                	sd	s4,32(sp)
ffffffffc0200f22:	ec56                	sd	s5,24(sp)
ffffffffc0200f24:	e85a                	sd	s6,16(sp)
ffffffffc0200f26:	e45e                	sd	s7,8(sp)
ffffffffc0200f28:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f2a:	2a878d63          	beq	a5,s0,ffffffffc02011e4 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200f2e:	4481                	li	s1,0
ffffffffc0200f30:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200f32:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200f36:	8b09                	andi	a4,a4,2
ffffffffc0200f38:	2a070a63          	beqz	a4,ffffffffc02011ec <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0200f3c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f40:	679c                	ld	a5,8(a5)
ffffffffc0200f42:	2905                	addiw	s2,s2,1
ffffffffc0200f44:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0200f46:	fe8796e3          	bne	a5,s0,ffffffffc0200f32 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200f4a:	89a6                	mv	s3,s1
ffffffffc0200f4c:	6df000ef          	jal	ra,ffffffffc0201e2a <nr_free_pages>
ffffffffc0200f50:	6f351e63          	bne	a0,s3,ffffffffc020164c <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f54:	4505                	li	a0,1
ffffffffc0200f56:	657000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0200f5a:	8aaa                	mv	s5,a0
ffffffffc0200f5c:	42050863          	beqz	a0,ffffffffc020138c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f60:	4505                	li	a0,1
ffffffffc0200f62:	64b000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0200f66:	89aa                	mv	s3,a0
ffffffffc0200f68:	70050263          	beqz	a0,ffffffffc020166c <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f6c:	4505                	li	a0,1
ffffffffc0200f6e:	63f000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0200f72:	8a2a                	mv	s4,a0
ffffffffc0200f74:	48050c63          	beqz	a0,ffffffffc020140c <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f78:	293a8a63          	beq	s5,s3,ffffffffc020120c <default_check+0x302>
ffffffffc0200f7c:	28aa8863          	beq	s5,a0,ffffffffc020120c <default_check+0x302>
ffffffffc0200f80:	28a98663          	beq	s3,a0,ffffffffc020120c <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f84:	000aa783          	lw	a5,0(s5)
ffffffffc0200f88:	2a079263          	bnez	a5,ffffffffc020122c <default_check+0x322>
ffffffffc0200f8c:	0009a783          	lw	a5,0(s3)
ffffffffc0200f90:	28079e63          	bnez	a5,ffffffffc020122c <default_check+0x322>
ffffffffc0200f94:	411c                	lw	a5,0(a0)
ffffffffc0200f96:	28079b63          	bnez	a5,ffffffffc020122c <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200f9a:	000fa797          	auipc	a5,0xfa
ffffffffc0200f9e:	f1e7b783          	ld	a5,-226(a5) # ffffffffc02faeb8 <pages>
ffffffffc0200fa2:	40fa8733          	sub	a4,s5,a5
ffffffffc0200fa6:	00007617          	auipc	a2,0x7
ffffffffc0200faa:	13a63603          	ld	a2,314(a2) # ffffffffc02080e0 <nbase>
ffffffffc0200fae:	8719                	srai	a4,a4,0x6
ffffffffc0200fb0:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200fb2:	000fa697          	auipc	a3,0xfa
ffffffffc0200fb6:	efe6b683          	ld	a3,-258(a3) # ffffffffc02faeb0 <npage>
ffffffffc0200fba:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fbc:	0732                	slli	a4,a4,0xc
ffffffffc0200fbe:	28d77763          	bgeu	a4,a3,ffffffffc020124c <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200fc2:	40f98733          	sub	a4,s3,a5
ffffffffc0200fc6:	8719                	srai	a4,a4,0x6
ffffffffc0200fc8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fca:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200fcc:	4cd77063          	bgeu	a4,a3,ffffffffc020148c <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200fd0:	40f507b3          	sub	a5,a0,a5
ffffffffc0200fd4:	8799                	srai	a5,a5,0x6
ffffffffc0200fd6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200fd8:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200fda:	30d7f963          	bgeu	a5,a3,ffffffffc02012ec <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200fde:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200fe0:	00043c03          	ld	s8,0(s0)
ffffffffc0200fe4:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200fe8:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200fec:	e400                	sd	s0,8(s0)
ffffffffc0200fee:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200ff0:	000f6797          	auipc	a5,0xf6
ffffffffc0200ff4:	e207ac23          	sw	zero,-456(a5) # ffffffffc02f6e28 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200ff8:	5b5000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0200ffc:	2c051863          	bnez	a0,ffffffffc02012cc <default_check+0x3c2>
    free_page(p0);
ffffffffc0201000:	4585                	li	a1,1
ffffffffc0201002:	8556                	mv	a0,s5
ffffffffc0201004:	5e7000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_page(p1);
ffffffffc0201008:	4585                	li	a1,1
ffffffffc020100a:	854e                	mv	a0,s3
ffffffffc020100c:	5df000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_page(p2);
ffffffffc0201010:	4585                	li	a1,1
ffffffffc0201012:	8552                	mv	a0,s4
ffffffffc0201014:	5d7000ef          	jal	ra,ffffffffc0201dea <free_pages>
    assert(nr_free == 3);
ffffffffc0201018:	4818                	lw	a4,16(s0)
ffffffffc020101a:	478d                	li	a5,3
ffffffffc020101c:	28f71863          	bne	a4,a5,ffffffffc02012ac <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201020:	4505                	li	a0,1
ffffffffc0201022:	58b000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201026:	89aa                	mv	s3,a0
ffffffffc0201028:	26050263          	beqz	a0,ffffffffc020128c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020102c:	4505                	li	a0,1
ffffffffc020102e:	57f000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201032:	8aaa                	mv	s5,a0
ffffffffc0201034:	3a050c63          	beqz	a0,ffffffffc02013ec <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201038:	4505                	li	a0,1
ffffffffc020103a:	573000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020103e:	8a2a                	mv	s4,a0
ffffffffc0201040:	38050663          	beqz	a0,ffffffffc02013cc <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201044:	4505                	li	a0,1
ffffffffc0201046:	567000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020104a:	36051163          	bnez	a0,ffffffffc02013ac <default_check+0x4a2>
    free_page(p0);
ffffffffc020104e:	4585                	li	a1,1
ffffffffc0201050:	854e                	mv	a0,s3
ffffffffc0201052:	599000ef          	jal	ra,ffffffffc0201dea <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201056:	641c                	ld	a5,8(s0)
ffffffffc0201058:	20878a63          	beq	a5,s0,ffffffffc020126c <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc020105c:	4505                	li	a0,1
ffffffffc020105e:	54f000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201062:	30a99563          	bne	s3,a0,ffffffffc020136c <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201066:	4505                	li	a0,1
ffffffffc0201068:	545000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020106c:	2e051063          	bnez	a0,ffffffffc020134c <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201070:	481c                	lw	a5,16(s0)
ffffffffc0201072:	2a079d63          	bnez	a5,ffffffffc020132c <default_check+0x422>
    free_page(p);
ffffffffc0201076:	854e                	mv	a0,s3
ffffffffc0201078:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc020107a:	01843023          	sd	s8,0(s0)
ffffffffc020107e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201082:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201086:	565000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_page(p1);
ffffffffc020108a:	4585                	li	a1,1
ffffffffc020108c:	8556                	mv	a0,s5
ffffffffc020108e:	55d000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_page(p2);
ffffffffc0201092:	4585                	li	a1,1
ffffffffc0201094:	8552                	mv	a0,s4
ffffffffc0201096:	555000ef          	jal	ra,ffffffffc0201dea <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc020109a:	4515                	li	a0,5
ffffffffc020109c:	511000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc02010a0:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02010a2:	26050563          	beqz	a0,ffffffffc020130c <default_check+0x402>
ffffffffc02010a6:	651c                	ld	a5,8(a0)
ffffffffc02010a8:	8385                	srli	a5,a5,0x1
ffffffffc02010aa:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02010ac:	54079063          	bnez	a5,ffffffffc02015ec <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02010b0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010b2:	00043b03          	ld	s6,0(s0)
ffffffffc02010b6:	00843a83          	ld	s5,8(s0)
ffffffffc02010ba:	e000                	sd	s0,0(s0)
ffffffffc02010bc:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02010be:	4ef000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc02010c2:	50051563          	bnez	a0,ffffffffc02015cc <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02010c6:	08098a13          	addi	s4,s3,128
ffffffffc02010ca:	8552                	mv	a0,s4
ffffffffc02010cc:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02010ce:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02010d2:	000f6797          	auipc	a5,0xf6
ffffffffc02010d6:	d407ab23          	sw	zero,-682(a5) # ffffffffc02f6e28 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02010da:	511000ef          	jal	ra,ffffffffc0201dea <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02010de:	4511                	li	a0,4
ffffffffc02010e0:	4cd000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc02010e4:	4c051463          	bnez	a0,ffffffffc02015ac <default_check+0x6a2>
ffffffffc02010e8:	0889b783          	ld	a5,136(s3)
ffffffffc02010ec:	8385                	srli	a5,a5,0x1
ffffffffc02010ee:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02010f0:	48078e63          	beqz	a5,ffffffffc020158c <default_check+0x682>
ffffffffc02010f4:	0909a703          	lw	a4,144(s3)
ffffffffc02010f8:	478d                	li	a5,3
ffffffffc02010fa:	48f71963          	bne	a4,a5,ffffffffc020158c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02010fe:	450d                	li	a0,3
ffffffffc0201100:	4ad000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201104:	8c2a                	mv	s8,a0
ffffffffc0201106:	46050363          	beqz	a0,ffffffffc020156c <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc020110a:	4505                	li	a0,1
ffffffffc020110c:	4a1000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201110:	42051e63          	bnez	a0,ffffffffc020154c <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201114:	418a1c63          	bne	s4,s8,ffffffffc020152c <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201118:	4585                	li	a1,1
ffffffffc020111a:	854e                	mv	a0,s3
ffffffffc020111c:	4cf000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_pages(p1, 3);
ffffffffc0201120:	458d                	li	a1,3
ffffffffc0201122:	8552                	mv	a0,s4
ffffffffc0201124:	4c7000ef          	jal	ra,ffffffffc0201dea <free_pages>
ffffffffc0201128:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020112c:	04098c13          	addi	s8,s3,64
ffffffffc0201130:	8385                	srli	a5,a5,0x1
ffffffffc0201132:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201134:	3c078c63          	beqz	a5,ffffffffc020150c <default_check+0x602>
ffffffffc0201138:	0109a703          	lw	a4,16(s3)
ffffffffc020113c:	4785                	li	a5,1
ffffffffc020113e:	3cf71763          	bne	a4,a5,ffffffffc020150c <default_check+0x602>
ffffffffc0201142:	008a3783          	ld	a5,8(s4)
ffffffffc0201146:	8385                	srli	a5,a5,0x1
ffffffffc0201148:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020114a:	3a078163          	beqz	a5,ffffffffc02014ec <default_check+0x5e2>
ffffffffc020114e:	010a2703          	lw	a4,16(s4)
ffffffffc0201152:	478d                	li	a5,3
ffffffffc0201154:	38f71c63          	bne	a4,a5,ffffffffc02014ec <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201158:	4505                	li	a0,1
ffffffffc020115a:	453000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020115e:	36a99763          	bne	s3,a0,ffffffffc02014cc <default_check+0x5c2>
    free_page(p0);
ffffffffc0201162:	4585                	li	a1,1
ffffffffc0201164:	487000ef          	jal	ra,ffffffffc0201dea <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201168:	4509                	li	a0,2
ffffffffc020116a:	443000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020116e:	32aa1f63          	bne	s4,a0,ffffffffc02014ac <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201172:	4589                	li	a1,2
ffffffffc0201174:	477000ef          	jal	ra,ffffffffc0201dea <free_pages>
    free_page(p2);
ffffffffc0201178:	4585                	li	a1,1
ffffffffc020117a:	8562                	mv	a0,s8
ffffffffc020117c:	46f000ef          	jal	ra,ffffffffc0201dea <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201180:	4515                	li	a0,5
ffffffffc0201182:	42b000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201186:	89aa                	mv	s3,a0
ffffffffc0201188:	48050263          	beqz	a0,ffffffffc020160c <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020118c:	4505                	li	a0,1
ffffffffc020118e:	41f000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc0201192:	2c051d63          	bnez	a0,ffffffffc020146c <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201196:	481c                	lw	a5,16(s0)
ffffffffc0201198:	2a079a63          	bnez	a5,ffffffffc020144c <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020119c:	4595                	li	a1,5
ffffffffc020119e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02011a0:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02011a4:	01643023          	sd	s6,0(s0)
ffffffffc02011a8:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02011ac:	43f000ef          	jal	ra,ffffffffc0201dea <free_pages>
    return listelm->next;
ffffffffc02011b0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02011b2:	00878963          	beq	a5,s0,ffffffffc02011c4 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02011b6:	ff87a703          	lw	a4,-8(a5)
ffffffffc02011ba:	679c                	ld	a5,8(a5)
ffffffffc02011bc:	397d                	addiw	s2,s2,-1
ffffffffc02011be:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02011c0:	fe879be3          	bne	a5,s0,ffffffffc02011b6 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02011c4:	26091463          	bnez	s2,ffffffffc020142c <default_check+0x522>
    assert(total == 0);
ffffffffc02011c8:	46049263          	bnez	s1,ffffffffc020162c <default_check+0x722>
}
ffffffffc02011cc:	60a6                	ld	ra,72(sp)
ffffffffc02011ce:	6406                	ld	s0,64(sp)
ffffffffc02011d0:	74e2                	ld	s1,56(sp)
ffffffffc02011d2:	7942                	ld	s2,48(sp)
ffffffffc02011d4:	79a2                	ld	s3,40(sp)
ffffffffc02011d6:	7a02                	ld	s4,32(sp)
ffffffffc02011d8:	6ae2                	ld	s5,24(sp)
ffffffffc02011da:	6b42                	ld	s6,16(sp)
ffffffffc02011dc:	6ba2                	ld	s7,8(sp)
ffffffffc02011de:	6c02                	ld	s8,0(sp)
ffffffffc02011e0:	6161                	addi	sp,sp,80
ffffffffc02011e2:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02011e4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02011e6:	4481                	li	s1,0
ffffffffc02011e8:	4901                	li	s2,0
ffffffffc02011ea:	b38d                	j	ffffffffc0200f4c <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02011ec:	00005697          	auipc	a3,0x5
ffffffffc02011f0:	08468693          	addi	a3,a3,132 # ffffffffc0206270 <commands+0x818>
ffffffffc02011f4:	00005617          	auipc	a2,0x5
ffffffffc02011f8:	08c60613          	addi	a2,a2,140 # ffffffffc0206280 <commands+0x828>
ffffffffc02011fc:	11000593          	li	a1,272
ffffffffc0201200:	00005517          	auipc	a0,0x5
ffffffffc0201204:	09850513          	addi	a0,a0,152 # ffffffffc0206298 <commands+0x840>
ffffffffc0201208:	a8aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020120c:	00005697          	auipc	a3,0x5
ffffffffc0201210:	12468693          	addi	a3,a3,292 # ffffffffc0206330 <commands+0x8d8>
ffffffffc0201214:	00005617          	auipc	a2,0x5
ffffffffc0201218:	06c60613          	addi	a2,a2,108 # ffffffffc0206280 <commands+0x828>
ffffffffc020121c:	0db00593          	li	a1,219
ffffffffc0201220:	00005517          	auipc	a0,0x5
ffffffffc0201224:	07850513          	addi	a0,a0,120 # ffffffffc0206298 <commands+0x840>
ffffffffc0201228:	a6aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020122c:	00005697          	auipc	a3,0x5
ffffffffc0201230:	12c68693          	addi	a3,a3,300 # ffffffffc0206358 <commands+0x900>
ffffffffc0201234:	00005617          	auipc	a2,0x5
ffffffffc0201238:	04c60613          	addi	a2,a2,76 # ffffffffc0206280 <commands+0x828>
ffffffffc020123c:	0dc00593          	li	a1,220
ffffffffc0201240:	00005517          	auipc	a0,0x5
ffffffffc0201244:	05850513          	addi	a0,a0,88 # ffffffffc0206298 <commands+0x840>
ffffffffc0201248:	a4aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020124c:	00005697          	auipc	a3,0x5
ffffffffc0201250:	14c68693          	addi	a3,a3,332 # ffffffffc0206398 <commands+0x940>
ffffffffc0201254:	00005617          	auipc	a2,0x5
ffffffffc0201258:	02c60613          	addi	a2,a2,44 # ffffffffc0206280 <commands+0x828>
ffffffffc020125c:	0de00593          	li	a1,222
ffffffffc0201260:	00005517          	auipc	a0,0x5
ffffffffc0201264:	03850513          	addi	a0,a0,56 # ffffffffc0206298 <commands+0x840>
ffffffffc0201268:	a2aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!list_empty(&free_list));
ffffffffc020126c:	00005697          	auipc	a3,0x5
ffffffffc0201270:	1b468693          	addi	a3,a3,436 # ffffffffc0206420 <commands+0x9c8>
ffffffffc0201274:	00005617          	auipc	a2,0x5
ffffffffc0201278:	00c60613          	addi	a2,a2,12 # ffffffffc0206280 <commands+0x828>
ffffffffc020127c:	0f700593          	li	a1,247
ffffffffc0201280:	00005517          	auipc	a0,0x5
ffffffffc0201284:	01850513          	addi	a0,a0,24 # ffffffffc0206298 <commands+0x840>
ffffffffc0201288:	a0aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020128c:	00005697          	auipc	a3,0x5
ffffffffc0201290:	04468693          	addi	a3,a3,68 # ffffffffc02062d0 <commands+0x878>
ffffffffc0201294:	00005617          	auipc	a2,0x5
ffffffffc0201298:	fec60613          	addi	a2,a2,-20 # ffffffffc0206280 <commands+0x828>
ffffffffc020129c:	0f000593          	li	a1,240
ffffffffc02012a0:	00005517          	auipc	a0,0x5
ffffffffc02012a4:	ff850513          	addi	a0,a0,-8 # ffffffffc0206298 <commands+0x840>
ffffffffc02012a8:	9eaff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 3);
ffffffffc02012ac:	00005697          	auipc	a3,0x5
ffffffffc02012b0:	16468693          	addi	a3,a3,356 # ffffffffc0206410 <commands+0x9b8>
ffffffffc02012b4:	00005617          	auipc	a2,0x5
ffffffffc02012b8:	fcc60613          	addi	a2,a2,-52 # ffffffffc0206280 <commands+0x828>
ffffffffc02012bc:	0ee00593          	li	a1,238
ffffffffc02012c0:	00005517          	auipc	a0,0x5
ffffffffc02012c4:	fd850513          	addi	a0,a0,-40 # ffffffffc0206298 <commands+0x840>
ffffffffc02012c8:	9caff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012cc:	00005697          	auipc	a3,0x5
ffffffffc02012d0:	12c68693          	addi	a3,a3,300 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc02012d4:	00005617          	auipc	a2,0x5
ffffffffc02012d8:	fac60613          	addi	a2,a2,-84 # ffffffffc0206280 <commands+0x828>
ffffffffc02012dc:	0e900593          	li	a1,233
ffffffffc02012e0:	00005517          	auipc	a0,0x5
ffffffffc02012e4:	fb850513          	addi	a0,a0,-72 # ffffffffc0206298 <commands+0x840>
ffffffffc02012e8:	9aaff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02012ec:	00005697          	auipc	a3,0x5
ffffffffc02012f0:	0ec68693          	addi	a3,a3,236 # ffffffffc02063d8 <commands+0x980>
ffffffffc02012f4:	00005617          	auipc	a2,0x5
ffffffffc02012f8:	f8c60613          	addi	a2,a2,-116 # ffffffffc0206280 <commands+0x828>
ffffffffc02012fc:	0e000593          	li	a1,224
ffffffffc0201300:	00005517          	auipc	a0,0x5
ffffffffc0201304:	f9850513          	addi	a0,a0,-104 # ffffffffc0206298 <commands+0x840>
ffffffffc0201308:	98aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 != NULL);
ffffffffc020130c:	00005697          	auipc	a3,0x5
ffffffffc0201310:	15c68693          	addi	a3,a3,348 # ffffffffc0206468 <commands+0xa10>
ffffffffc0201314:	00005617          	auipc	a2,0x5
ffffffffc0201318:	f6c60613          	addi	a2,a2,-148 # ffffffffc0206280 <commands+0x828>
ffffffffc020131c:	11800593          	li	a1,280
ffffffffc0201320:	00005517          	auipc	a0,0x5
ffffffffc0201324:	f7850513          	addi	a0,a0,-136 # ffffffffc0206298 <commands+0x840>
ffffffffc0201328:	96aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc020132c:	00005697          	auipc	a3,0x5
ffffffffc0201330:	12c68693          	addi	a3,a3,300 # ffffffffc0206458 <commands+0xa00>
ffffffffc0201334:	00005617          	auipc	a2,0x5
ffffffffc0201338:	f4c60613          	addi	a2,a2,-180 # ffffffffc0206280 <commands+0x828>
ffffffffc020133c:	0fd00593          	li	a1,253
ffffffffc0201340:	00005517          	auipc	a0,0x5
ffffffffc0201344:	f5850513          	addi	a0,a0,-168 # ffffffffc0206298 <commands+0x840>
ffffffffc0201348:	94aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020134c:	00005697          	auipc	a3,0x5
ffffffffc0201350:	0ac68693          	addi	a3,a3,172 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc0201354:	00005617          	auipc	a2,0x5
ffffffffc0201358:	f2c60613          	addi	a2,a2,-212 # ffffffffc0206280 <commands+0x828>
ffffffffc020135c:	0fb00593          	li	a1,251
ffffffffc0201360:	00005517          	auipc	a0,0x5
ffffffffc0201364:	f3850513          	addi	a0,a0,-200 # ffffffffc0206298 <commands+0x840>
ffffffffc0201368:	92aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020136c:	00005697          	auipc	a3,0x5
ffffffffc0201370:	0cc68693          	addi	a3,a3,204 # ffffffffc0206438 <commands+0x9e0>
ffffffffc0201374:	00005617          	auipc	a2,0x5
ffffffffc0201378:	f0c60613          	addi	a2,a2,-244 # ffffffffc0206280 <commands+0x828>
ffffffffc020137c:	0fa00593          	li	a1,250
ffffffffc0201380:	00005517          	auipc	a0,0x5
ffffffffc0201384:	f1850513          	addi	a0,a0,-232 # ffffffffc0206298 <commands+0x840>
ffffffffc0201388:	90aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020138c:	00005697          	auipc	a3,0x5
ffffffffc0201390:	f4468693          	addi	a3,a3,-188 # ffffffffc02062d0 <commands+0x878>
ffffffffc0201394:	00005617          	auipc	a2,0x5
ffffffffc0201398:	eec60613          	addi	a2,a2,-276 # ffffffffc0206280 <commands+0x828>
ffffffffc020139c:	0d700593          	li	a1,215
ffffffffc02013a0:	00005517          	auipc	a0,0x5
ffffffffc02013a4:	ef850513          	addi	a0,a0,-264 # ffffffffc0206298 <commands+0x840>
ffffffffc02013a8:	8eaff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013ac:	00005697          	auipc	a3,0x5
ffffffffc02013b0:	04c68693          	addi	a3,a3,76 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc02013b4:	00005617          	auipc	a2,0x5
ffffffffc02013b8:	ecc60613          	addi	a2,a2,-308 # ffffffffc0206280 <commands+0x828>
ffffffffc02013bc:	0f400593          	li	a1,244
ffffffffc02013c0:	00005517          	auipc	a0,0x5
ffffffffc02013c4:	ed850513          	addi	a0,a0,-296 # ffffffffc0206298 <commands+0x840>
ffffffffc02013c8:	8caff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013cc:	00005697          	auipc	a3,0x5
ffffffffc02013d0:	f4468693          	addi	a3,a3,-188 # ffffffffc0206310 <commands+0x8b8>
ffffffffc02013d4:	00005617          	auipc	a2,0x5
ffffffffc02013d8:	eac60613          	addi	a2,a2,-340 # ffffffffc0206280 <commands+0x828>
ffffffffc02013dc:	0f200593          	li	a1,242
ffffffffc02013e0:	00005517          	auipc	a0,0x5
ffffffffc02013e4:	eb850513          	addi	a0,a0,-328 # ffffffffc0206298 <commands+0x840>
ffffffffc02013e8:	8aaff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02013ec:	00005697          	auipc	a3,0x5
ffffffffc02013f0:	f0468693          	addi	a3,a3,-252 # ffffffffc02062f0 <commands+0x898>
ffffffffc02013f4:	00005617          	auipc	a2,0x5
ffffffffc02013f8:	e8c60613          	addi	a2,a2,-372 # ffffffffc0206280 <commands+0x828>
ffffffffc02013fc:	0f100593          	li	a1,241
ffffffffc0201400:	00005517          	auipc	a0,0x5
ffffffffc0201404:	e9850513          	addi	a0,a0,-360 # ffffffffc0206298 <commands+0x840>
ffffffffc0201408:	88aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020140c:	00005697          	auipc	a3,0x5
ffffffffc0201410:	f0468693          	addi	a3,a3,-252 # ffffffffc0206310 <commands+0x8b8>
ffffffffc0201414:	00005617          	auipc	a2,0x5
ffffffffc0201418:	e6c60613          	addi	a2,a2,-404 # ffffffffc0206280 <commands+0x828>
ffffffffc020141c:	0d900593          	li	a1,217
ffffffffc0201420:	00005517          	auipc	a0,0x5
ffffffffc0201424:	e7850513          	addi	a0,a0,-392 # ffffffffc0206298 <commands+0x840>
ffffffffc0201428:	86aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(count == 0);
ffffffffc020142c:	00005697          	auipc	a3,0x5
ffffffffc0201430:	18c68693          	addi	a3,a3,396 # ffffffffc02065b8 <commands+0xb60>
ffffffffc0201434:	00005617          	auipc	a2,0x5
ffffffffc0201438:	e4c60613          	addi	a2,a2,-436 # ffffffffc0206280 <commands+0x828>
ffffffffc020143c:	14600593          	li	a1,326
ffffffffc0201440:	00005517          	auipc	a0,0x5
ffffffffc0201444:	e5850513          	addi	a0,a0,-424 # ffffffffc0206298 <commands+0x840>
ffffffffc0201448:	84aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free == 0);
ffffffffc020144c:	00005697          	auipc	a3,0x5
ffffffffc0201450:	00c68693          	addi	a3,a3,12 # ffffffffc0206458 <commands+0xa00>
ffffffffc0201454:	00005617          	auipc	a2,0x5
ffffffffc0201458:	e2c60613          	addi	a2,a2,-468 # ffffffffc0206280 <commands+0x828>
ffffffffc020145c:	13a00593          	li	a1,314
ffffffffc0201460:	00005517          	auipc	a0,0x5
ffffffffc0201464:	e3850513          	addi	a0,a0,-456 # ffffffffc0206298 <commands+0x840>
ffffffffc0201468:	82aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020146c:	00005697          	auipc	a3,0x5
ffffffffc0201470:	f8c68693          	addi	a3,a3,-116 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc0201474:	00005617          	auipc	a2,0x5
ffffffffc0201478:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206280 <commands+0x828>
ffffffffc020147c:	13800593          	li	a1,312
ffffffffc0201480:	00005517          	auipc	a0,0x5
ffffffffc0201484:	e1850513          	addi	a0,a0,-488 # ffffffffc0206298 <commands+0x840>
ffffffffc0201488:	80aff0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020148c:	00005697          	auipc	a3,0x5
ffffffffc0201490:	f2c68693          	addi	a3,a3,-212 # ffffffffc02063b8 <commands+0x960>
ffffffffc0201494:	00005617          	auipc	a2,0x5
ffffffffc0201498:	dec60613          	addi	a2,a2,-532 # ffffffffc0206280 <commands+0x828>
ffffffffc020149c:	0df00593          	li	a1,223
ffffffffc02014a0:	00005517          	auipc	a0,0x5
ffffffffc02014a4:	df850513          	addi	a0,a0,-520 # ffffffffc0206298 <commands+0x840>
ffffffffc02014a8:	febfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02014ac:	00005697          	auipc	a3,0x5
ffffffffc02014b0:	0cc68693          	addi	a3,a3,204 # ffffffffc0206578 <commands+0xb20>
ffffffffc02014b4:	00005617          	auipc	a2,0x5
ffffffffc02014b8:	dcc60613          	addi	a2,a2,-564 # ffffffffc0206280 <commands+0x828>
ffffffffc02014bc:	13200593          	li	a1,306
ffffffffc02014c0:	00005517          	auipc	a0,0x5
ffffffffc02014c4:	dd850513          	addi	a0,a0,-552 # ffffffffc0206298 <commands+0x840>
ffffffffc02014c8:	fcbfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02014cc:	00005697          	auipc	a3,0x5
ffffffffc02014d0:	08c68693          	addi	a3,a3,140 # ffffffffc0206558 <commands+0xb00>
ffffffffc02014d4:	00005617          	auipc	a2,0x5
ffffffffc02014d8:	dac60613          	addi	a2,a2,-596 # ffffffffc0206280 <commands+0x828>
ffffffffc02014dc:	13000593          	li	a1,304
ffffffffc02014e0:	00005517          	auipc	a0,0x5
ffffffffc02014e4:	db850513          	addi	a0,a0,-584 # ffffffffc0206298 <commands+0x840>
ffffffffc02014e8:	fabfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02014ec:	00005697          	auipc	a3,0x5
ffffffffc02014f0:	04468693          	addi	a3,a3,68 # ffffffffc0206530 <commands+0xad8>
ffffffffc02014f4:	00005617          	auipc	a2,0x5
ffffffffc02014f8:	d8c60613          	addi	a2,a2,-628 # ffffffffc0206280 <commands+0x828>
ffffffffc02014fc:	12e00593          	li	a1,302
ffffffffc0201500:	00005517          	auipc	a0,0x5
ffffffffc0201504:	d9850513          	addi	a0,a0,-616 # ffffffffc0206298 <commands+0x840>
ffffffffc0201508:	f8bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020150c:	00005697          	auipc	a3,0x5
ffffffffc0201510:	ffc68693          	addi	a3,a3,-4 # ffffffffc0206508 <commands+0xab0>
ffffffffc0201514:	00005617          	auipc	a2,0x5
ffffffffc0201518:	d6c60613          	addi	a2,a2,-660 # ffffffffc0206280 <commands+0x828>
ffffffffc020151c:	12d00593          	li	a1,301
ffffffffc0201520:	00005517          	auipc	a0,0x5
ffffffffc0201524:	d7850513          	addi	a0,a0,-648 # ffffffffc0206298 <commands+0x840>
ffffffffc0201528:	f6bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020152c:	00005697          	auipc	a3,0x5
ffffffffc0201530:	fcc68693          	addi	a3,a3,-52 # ffffffffc02064f8 <commands+0xaa0>
ffffffffc0201534:	00005617          	auipc	a2,0x5
ffffffffc0201538:	d4c60613          	addi	a2,a2,-692 # ffffffffc0206280 <commands+0x828>
ffffffffc020153c:	12800593          	li	a1,296
ffffffffc0201540:	00005517          	auipc	a0,0x5
ffffffffc0201544:	d5850513          	addi	a0,a0,-680 # ffffffffc0206298 <commands+0x840>
ffffffffc0201548:	f4bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020154c:	00005697          	auipc	a3,0x5
ffffffffc0201550:	eac68693          	addi	a3,a3,-340 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc0201554:	00005617          	auipc	a2,0x5
ffffffffc0201558:	d2c60613          	addi	a2,a2,-724 # ffffffffc0206280 <commands+0x828>
ffffffffc020155c:	12700593          	li	a1,295
ffffffffc0201560:	00005517          	auipc	a0,0x5
ffffffffc0201564:	d3850513          	addi	a0,a0,-712 # ffffffffc0206298 <commands+0x840>
ffffffffc0201568:	f2bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020156c:	00005697          	auipc	a3,0x5
ffffffffc0201570:	f6c68693          	addi	a3,a3,-148 # ffffffffc02064d8 <commands+0xa80>
ffffffffc0201574:	00005617          	auipc	a2,0x5
ffffffffc0201578:	d0c60613          	addi	a2,a2,-756 # ffffffffc0206280 <commands+0x828>
ffffffffc020157c:	12600593          	li	a1,294
ffffffffc0201580:	00005517          	auipc	a0,0x5
ffffffffc0201584:	d1850513          	addi	a0,a0,-744 # ffffffffc0206298 <commands+0x840>
ffffffffc0201588:	f0bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020158c:	00005697          	auipc	a3,0x5
ffffffffc0201590:	f1c68693          	addi	a3,a3,-228 # ffffffffc02064a8 <commands+0xa50>
ffffffffc0201594:	00005617          	auipc	a2,0x5
ffffffffc0201598:	cec60613          	addi	a2,a2,-788 # ffffffffc0206280 <commands+0x828>
ffffffffc020159c:	12500593          	li	a1,293
ffffffffc02015a0:	00005517          	auipc	a0,0x5
ffffffffc02015a4:	cf850513          	addi	a0,a0,-776 # ffffffffc0206298 <commands+0x840>
ffffffffc02015a8:	eebfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02015ac:	00005697          	auipc	a3,0x5
ffffffffc02015b0:	ee468693          	addi	a3,a3,-284 # ffffffffc0206490 <commands+0xa38>
ffffffffc02015b4:	00005617          	auipc	a2,0x5
ffffffffc02015b8:	ccc60613          	addi	a2,a2,-820 # ffffffffc0206280 <commands+0x828>
ffffffffc02015bc:	12400593          	li	a1,292
ffffffffc02015c0:	00005517          	auipc	a0,0x5
ffffffffc02015c4:	cd850513          	addi	a0,a0,-808 # ffffffffc0206298 <commands+0x840>
ffffffffc02015c8:	ecbfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015cc:	00005697          	auipc	a3,0x5
ffffffffc02015d0:	e2c68693          	addi	a3,a3,-468 # ffffffffc02063f8 <commands+0x9a0>
ffffffffc02015d4:	00005617          	auipc	a2,0x5
ffffffffc02015d8:	cac60613          	addi	a2,a2,-852 # ffffffffc0206280 <commands+0x828>
ffffffffc02015dc:	11e00593          	li	a1,286
ffffffffc02015e0:	00005517          	auipc	a0,0x5
ffffffffc02015e4:	cb850513          	addi	a0,a0,-840 # ffffffffc0206298 <commands+0x840>
ffffffffc02015e8:	eabfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(!PageProperty(p0));
ffffffffc02015ec:	00005697          	auipc	a3,0x5
ffffffffc02015f0:	e8c68693          	addi	a3,a3,-372 # ffffffffc0206478 <commands+0xa20>
ffffffffc02015f4:	00005617          	auipc	a2,0x5
ffffffffc02015f8:	c8c60613          	addi	a2,a2,-884 # ffffffffc0206280 <commands+0x828>
ffffffffc02015fc:	11900593          	li	a1,281
ffffffffc0201600:	00005517          	auipc	a0,0x5
ffffffffc0201604:	c9850513          	addi	a0,a0,-872 # ffffffffc0206298 <commands+0x840>
ffffffffc0201608:	e8bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020160c:	00005697          	auipc	a3,0x5
ffffffffc0201610:	f8c68693          	addi	a3,a3,-116 # ffffffffc0206598 <commands+0xb40>
ffffffffc0201614:	00005617          	auipc	a2,0x5
ffffffffc0201618:	c6c60613          	addi	a2,a2,-916 # ffffffffc0206280 <commands+0x828>
ffffffffc020161c:	13700593          	li	a1,311
ffffffffc0201620:	00005517          	auipc	a0,0x5
ffffffffc0201624:	c7850513          	addi	a0,a0,-904 # ffffffffc0206298 <commands+0x840>
ffffffffc0201628:	e6bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == 0);
ffffffffc020162c:	00005697          	auipc	a3,0x5
ffffffffc0201630:	f9c68693          	addi	a3,a3,-100 # ffffffffc02065c8 <commands+0xb70>
ffffffffc0201634:	00005617          	auipc	a2,0x5
ffffffffc0201638:	c4c60613          	addi	a2,a2,-948 # ffffffffc0206280 <commands+0x828>
ffffffffc020163c:	14700593          	li	a1,327
ffffffffc0201640:	00005517          	auipc	a0,0x5
ffffffffc0201644:	c5850513          	addi	a0,a0,-936 # ffffffffc0206298 <commands+0x840>
ffffffffc0201648:	e4bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(total == nr_free_pages());
ffffffffc020164c:	00005697          	auipc	a3,0x5
ffffffffc0201650:	c6468693          	addi	a3,a3,-924 # ffffffffc02062b0 <commands+0x858>
ffffffffc0201654:	00005617          	auipc	a2,0x5
ffffffffc0201658:	c2c60613          	addi	a2,a2,-980 # ffffffffc0206280 <commands+0x828>
ffffffffc020165c:	11300593          	li	a1,275
ffffffffc0201660:	00005517          	auipc	a0,0x5
ffffffffc0201664:	c3850513          	addi	a0,a0,-968 # ffffffffc0206298 <commands+0x840>
ffffffffc0201668:	e2bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020166c:	00005697          	auipc	a3,0x5
ffffffffc0201670:	c8468693          	addi	a3,a3,-892 # ffffffffc02062f0 <commands+0x898>
ffffffffc0201674:	00005617          	auipc	a2,0x5
ffffffffc0201678:	c0c60613          	addi	a2,a2,-1012 # ffffffffc0206280 <commands+0x828>
ffffffffc020167c:	0d800593          	li	a1,216
ffffffffc0201680:	00005517          	auipc	a0,0x5
ffffffffc0201684:	c1850513          	addi	a0,a0,-1000 # ffffffffc0206298 <commands+0x840>
ffffffffc0201688:	e0bfe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020168c <default_free_pages>:
{
ffffffffc020168c:	1141                	addi	sp,sp,-16
ffffffffc020168e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201690:	14058463          	beqz	a1,ffffffffc02017d8 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201694:	00659693          	slli	a3,a1,0x6
ffffffffc0201698:	96aa                	add	a3,a3,a0
ffffffffc020169a:	87aa                	mv	a5,a0
ffffffffc020169c:	02d50263          	beq	a0,a3,ffffffffc02016c0 <default_free_pages+0x34>
ffffffffc02016a0:	6798                	ld	a4,8(a5)
ffffffffc02016a2:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016a4:	10071a63          	bnez	a4,ffffffffc02017b8 <default_free_pages+0x12c>
ffffffffc02016a8:	6798                	ld	a4,8(a5)
ffffffffc02016aa:	8b09                	andi	a4,a4,2
ffffffffc02016ac:	10071663          	bnez	a4,ffffffffc02017b8 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02016b0:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02016b4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02016b8:	04078793          	addi	a5,a5,64
ffffffffc02016bc:	fed792e3          	bne	a5,a3,ffffffffc02016a0 <default_free_pages+0x14>
    base->property = n;
ffffffffc02016c0:	2581                	sext.w	a1,a1
ffffffffc02016c2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02016c4:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016c8:	4789                	li	a5,2
ffffffffc02016ca:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02016ce:	000f5697          	auipc	a3,0xf5
ffffffffc02016d2:	74a68693          	addi	a3,a3,1866 # ffffffffc02f6e18 <free_area>
ffffffffc02016d6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02016d8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02016da:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02016de:	9db9                	addw	a1,a1,a4
ffffffffc02016e0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02016e2:	0ad78463          	beq	a5,a3,ffffffffc020178a <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02016e6:	fe878713          	addi	a4,a5,-24
ffffffffc02016ea:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02016ee:	4581                	li	a1,0
            if (base < page)
ffffffffc02016f0:	00e56a63          	bltu	a0,a4,ffffffffc0201704 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02016f4:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02016f6:	04d70c63          	beq	a4,a3,ffffffffc020174e <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02016fa:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02016fc:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201700:	fee57ae3          	bgeu	a0,a4,ffffffffc02016f4 <default_free_pages+0x68>
ffffffffc0201704:	c199                	beqz	a1,ffffffffc020170a <default_free_pages+0x7e>
ffffffffc0201706:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020170a:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020170c:	e390                	sd	a2,0(a5)
ffffffffc020170e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201710:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201712:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201714:	00d70d63          	beq	a4,a3,ffffffffc020172e <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201718:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc020171c:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201720:	02059813          	slli	a6,a1,0x20
ffffffffc0201724:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201728:	97b2                	add	a5,a5,a2
ffffffffc020172a:	02f50c63          	beq	a0,a5,ffffffffc0201762 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020172e:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201730:	00d78c63          	beq	a5,a3,ffffffffc0201748 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201734:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201736:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc020173a:	02061593          	slli	a1,a2,0x20
ffffffffc020173e:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201742:	972a                	add	a4,a4,a0
ffffffffc0201744:	04e68a63          	beq	a3,a4,ffffffffc0201798 <default_free_pages+0x10c>
}
ffffffffc0201748:	60a2                	ld	ra,8(sp)
ffffffffc020174a:	0141                	addi	sp,sp,16
ffffffffc020174c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020174e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201750:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201752:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201754:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201756:	02d70763          	beq	a4,a3,ffffffffc0201784 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc020175a:	8832                	mv	a6,a2
ffffffffc020175c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020175e:	87ba                	mv	a5,a4
ffffffffc0201760:	bf71                	j	ffffffffc02016fc <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201762:	491c                	lw	a5,16(a0)
ffffffffc0201764:	9dbd                	addw	a1,a1,a5
ffffffffc0201766:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020176a:	57f5                	li	a5,-3
ffffffffc020176c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201770:	01853803          	ld	a6,24(a0)
ffffffffc0201774:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201776:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201778:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc020177c:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020177e:	0105b023          	sd	a6,0(a1)
ffffffffc0201782:	b77d                	j	ffffffffc0201730 <default_free_pages+0xa4>
ffffffffc0201784:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201786:	873e                	mv	a4,a5
ffffffffc0201788:	bf41                	j	ffffffffc0201718 <default_free_pages+0x8c>
}
ffffffffc020178a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020178c:	e390                	sd	a2,0(a5)
ffffffffc020178e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201790:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201792:	ed1c                	sd	a5,24(a0)
ffffffffc0201794:	0141                	addi	sp,sp,16
ffffffffc0201796:	8082                	ret
            base->property += p->property;
ffffffffc0201798:	ff87a703          	lw	a4,-8(a5)
ffffffffc020179c:	ff078693          	addi	a3,a5,-16
ffffffffc02017a0:	9e39                	addw	a2,a2,a4
ffffffffc02017a2:	c910                	sw	a2,16(a0)
ffffffffc02017a4:	5775                	li	a4,-3
ffffffffc02017a6:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02017aa:	6398                	ld	a4,0(a5)
ffffffffc02017ac:	679c                	ld	a5,8(a5)
}
ffffffffc02017ae:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02017b0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02017b2:	e398                	sd	a4,0(a5)
ffffffffc02017b4:	0141                	addi	sp,sp,16
ffffffffc02017b6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017b8:	00005697          	auipc	a3,0x5
ffffffffc02017bc:	e2868693          	addi	a3,a3,-472 # ffffffffc02065e0 <commands+0xb88>
ffffffffc02017c0:	00005617          	auipc	a2,0x5
ffffffffc02017c4:	ac060613          	addi	a2,a2,-1344 # ffffffffc0206280 <commands+0x828>
ffffffffc02017c8:	09400593          	li	a1,148
ffffffffc02017cc:	00005517          	auipc	a0,0x5
ffffffffc02017d0:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206298 <commands+0x840>
ffffffffc02017d4:	cbffe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc02017d8:	00005697          	auipc	a3,0x5
ffffffffc02017dc:	e0068693          	addi	a3,a3,-512 # ffffffffc02065d8 <commands+0xb80>
ffffffffc02017e0:	00005617          	auipc	a2,0x5
ffffffffc02017e4:	aa060613          	addi	a2,a2,-1376 # ffffffffc0206280 <commands+0x828>
ffffffffc02017e8:	09000593          	li	a1,144
ffffffffc02017ec:	00005517          	auipc	a0,0x5
ffffffffc02017f0:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206298 <commands+0x840>
ffffffffc02017f4:	c9ffe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02017f8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02017f8:	c941                	beqz	a0,ffffffffc0201888 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02017fa:	000f5597          	auipc	a1,0xf5
ffffffffc02017fe:	61e58593          	addi	a1,a1,1566 # ffffffffc02f6e18 <free_area>
ffffffffc0201802:	0105a803          	lw	a6,16(a1)
ffffffffc0201806:	872a                	mv	a4,a0
ffffffffc0201808:	02081793          	slli	a5,a6,0x20
ffffffffc020180c:	9381                	srli	a5,a5,0x20
ffffffffc020180e:	00a7ee63          	bltu	a5,a0,ffffffffc020182a <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201812:	87ae                	mv	a5,a1
ffffffffc0201814:	a801                	j	ffffffffc0201824 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201816:	ff87a683          	lw	a3,-8(a5)
ffffffffc020181a:	02069613          	slli	a2,a3,0x20
ffffffffc020181e:	9201                	srli	a2,a2,0x20
ffffffffc0201820:	00e67763          	bgeu	a2,a4,ffffffffc020182e <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201824:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201826:	feb798e3          	bne	a5,a1,ffffffffc0201816 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020182a:	4501                	li	a0,0
}
ffffffffc020182c:	8082                	ret
    return listelm->prev;
ffffffffc020182e:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201832:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201836:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc020183a:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020183e:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201842:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201846:	02c77863          	bgeu	a4,a2,ffffffffc0201876 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc020184a:	071a                	slli	a4,a4,0x6
ffffffffc020184c:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020184e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201852:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201854:	00870613          	addi	a2,a4,8
ffffffffc0201858:	4689                	li	a3,2
ffffffffc020185a:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020185e:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201862:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201866:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020186a:	e290                	sd	a2,0(a3)
ffffffffc020186c:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201870:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201872:	01173c23          	sd	a7,24(a4)
ffffffffc0201876:	41c8083b          	subw	a6,a6,t3
ffffffffc020187a:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020187e:	5775                	li	a4,-3
ffffffffc0201880:	17c1                	addi	a5,a5,-16
ffffffffc0201882:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201886:	8082                	ret
{
ffffffffc0201888:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020188a:	00005697          	auipc	a3,0x5
ffffffffc020188e:	d4e68693          	addi	a3,a3,-690 # ffffffffc02065d8 <commands+0xb80>
ffffffffc0201892:	00005617          	auipc	a2,0x5
ffffffffc0201896:	9ee60613          	addi	a2,a2,-1554 # ffffffffc0206280 <commands+0x828>
ffffffffc020189a:	06c00593          	li	a1,108
ffffffffc020189e:	00005517          	auipc	a0,0x5
ffffffffc02018a2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0206298 <commands+0x840>
{
ffffffffc02018a6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02018a8:	bebfe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02018ac <default_init_memmap>:
{
ffffffffc02018ac:	1141                	addi	sp,sp,-16
ffffffffc02018ae:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02018b0:	c5f1                	beqz	a1,ffffffffc020197c <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02018b2:	00659693          	slli	a3,a1,0x6
ffffffffc02018b6:	96aa                	add	a3,a3,a0
ffffffffc02018b8:	87aa                	mv	a5,a0
ffffffffc02018ba:	00d50f63          	beq	a0,a3,ffffffffc02018d8 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02018be:	6798                	ld	a4,8(a5)
ffffffffc02018c0:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02018c2:	cf49                	beqz	a4,ffffffffc020195c <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02018c4:	0007a823          	sw	zero,16(a5)
ffffffffc02018c8:	0007b423          	sd	zero,8(a5)
ffffffffc02018cc:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02018d0:	04078793          	addi	a5,a5,64
ffffffffc02018d4:	fed795e3          	bne	a5,a3,ffffffffc02018be <default_init_memmap+0x12>
    base->property = n;
ffffffffc02018d8:	2581                	sext.w	a1,a1
ffffffffc02018da:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02018dc:	4789                	li	a5,2
ffffffffc02018de:	00850713          	addi	a4,a0,8
ffffffffc02018e2:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02018e6:	000f5697          	auipc	a3,0xf5
ffffffffc02018ea:	53268693          	addi	a3,a3,1330 # ffffffffc02f6e18 <free_area>
ffffffffc02018ee:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02018f0:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02018f2:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02018f6:	9db9                	addw	a1,a1,a4
ffffffffc02018f8:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02018fa:	04d78a63          	beq	a5,a3,ffffffffc020194e <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02018fe:	fe878713          	addi	a4,a5,-24
ffffffffc0201902:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201906:	4581                	li	a1,0
            if (base < page)
ffffffffc0201908:	00e56a63          	bltu	a0,a4,ffffffffc020191c <default_init_memmap+0x70>
    return listelm->next;
ffffffffc020190c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020190e:	02d70263          	beq	a4,a3,ffffffffc0201932 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201912:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201914:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201918:	fee57ae3          	bgeu	a0,a4,ffffffffc020190c <default_init_memmap+0x60>
ffffffffc020191c:	c199                	beqz	a1,ffffffffc0201922 <default_init_memmap+0x76>
ffffffffc020191e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201922:	6398                	ld	a4,0(a5)
}
ffffffffc0201924:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201926:	e390                	sd	a2,0(a5)
ffffffffc0201928:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020192a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020192c:	ed18                	sd	a4,24(a0)
ffffffffc020192e:	0141                	addi	sp,sp,16
ffffffffc0201930:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201932:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201934:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201936:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201938:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc020193a:	00d70663          	beq	a4,a3,ffffffffc0201946 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc020193e:	8832                	mv	a6,a2
ffffffffc0201940:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201942:	87ba                	mv	a5,a4
ffffffffc0201944:	bfc1                	j	ffffffffc0201914 <default_init_memmap+0x68>
}
ffffffffc0201946:	60a2                	ld	ra,8(sp)
ffffffffc0201948:	e290                	sd	a2,0(a3)
ffffffffc020194a:	0141                	addi	sp,sp,16
ffffffffc020194c:	8082                	ret
ffffffffc020194e:	60a2                	ld	ra,8(sp)
ffffffffc0201950:	e390                	sd	a2,0(a5)
ffffffffc0201952:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201954:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201956:	ed1c                	sd	a5,24(a0)
ffffffffc0201958:	0141                	addi	sp,sp,16
ffffffffc020195a:	8082                	ret
        assert(PageReserved(p));
ffffffffc020195c:	00005697          	auipc	a3,0x5
ffffffffc0201960:	cac68693          	addi	a3,a3,-852 # ffffffffc0206608 <commands+0xbb0>
ffffffffc0201964:	00005617          	auipc	a2,0x5
ffffffffc0201968:	91c60613          	addi	a2,a2,-1764 # ffffffffc0206280 <commands+0x828>
ffffffffc020196c:	04b00593          	li	a1,75
ffffffffc0201970:	00005517          	auipc	a0,0x5
ffffffffc0201974:	92850513          	addi	a0,a0,-1752 # ffffffffc0206298 <commands+0x840>
ffffffffc0201978:	b1bfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(n > 0);
ffffffffc020197c:	00005697          	auipc	a3,0x5
ffffffffc0201980:	c5c68693          	addi	a3,a3,-932 # ffffffffc02065d8 <commands+0xb80>
ffffffffc0201984:	00005617          	auipc	a2,0x5
ffffffffc0201988:	8fc60613          	addi	a2,a2,-1796 # ffffffffc0206280 <commands+0x828>
ffffffffc020198c:	04700593          	li	a1,71
ffffffffc0201990:	00005517          	auipc	a0,0x5
ffffffffc0201994:	90850513          	addi	a0,a0,-1784 # ffffffffc0206298 <commands+0x840>
ffffffffc0201998:	afbfe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020199c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020199c:	c94d                	beqz	a0,ffffffffc0201a4e <slob_free+0xb2>
{
ffffffffc020199e:	1141                	addi	sp,sp,-16
ffffffffc02019a0:	e022                	sd	s0,0(sp)
ffffffffc02019a2:	e406                	sd	ra,8(sp)
ffffffffc02019a4:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02019a6:	e9c1                	bnez	a1,ffffffffc0201a36 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019a8:	100027f3          	csrr	a5,sstatus
ffffffffc02019ac:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02019ae:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019b0:	ebd9                	bnez	a5,ffffffffc0201a46 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019b2:	000f5617          	auipc	a2,0xf5
ffffffffc02019b6:	05660613          	addi	a2,a2,86 # ffffffffc02f6a08 <slobfree>
ffffffffc02019ba:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019bc:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019be:	679c                	ld	a5,8(a5)
ffffffffc02019c0:	02877a63          	bgeu	a4,s0,ffffffffc02019f4 <slob_free+0x58>
ffffffffc02019c4:	00f46463          	bltu	s0,a5,ffffffffc02019cc <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019c8:	fef76ae3          	bltu	a4,a5,ffffffffc02019bc <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02019cc:	400c                	lw	a1,0(s0)
ffffffffc02019ce:	00459693          	slli	a3,a1,0x4
ffffffffc02019d2:	96a2                	add	a3,a3,s0
ffffffffc02019d4:	02d78a63          	beq	a5,a3,ffffffffc0201a08 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02019d8:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02019da:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02019dc:	00469793          	slli	a5,a3,0x4
ffffffffc02019e0:	97ba                	add	a5,a5,a4
ffffffffc02019e2:	02f40e63          	beq	s0,a5,ffffffffc0201a1e <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc02019e6:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc02019e8:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc02019ea:	e129                	bnez	a0,ffffffffc0201a2c <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02019ec:	60a2                	ld	ra,8(sp)
ffffffffc02019ee:	6402                	ld	s0,0(sp)
ffffffffc02019f0:	0141                	addi	sp,sp,16
ffffffffc02019f2:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019f4:	fcf764e3          	bltu	a4,a5,ffffffffc02019bc <slob_free+0x20>
ffffffffc02019f8:	fcf472e3          	bgeu	s0,a5,ffffffffc02019bc <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02019fc:	400c                	lw	a1,0(s0)
ffffffffc02019fe:	00459693          	slli	a3,a1,0x4
ffffffffc0201a02:	96a2                	add	a3,a3,s0
ffffffffc0201a04:	fcd79ae3          	bne	a5,a3,ffffffffc02019d8 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201a08:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a0a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a0c:	9db5                	addw	a1,a1,a3
ffffffffc0201a0e:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201a10:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201a12:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201a14:	00469793          	slli	a5,a3,0x4
ffffffffc0201a18:	97ba                	add	a5,a5,a4
ffffffffc0201a1a:	fcf416e3          	bne	s0,a5,ffffffffc02019e6 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201a1e:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201a20:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201a22:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201a24:	9ebd                	addw	a3,a3,a5
ffffffffc0201a26:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201a28:	e70c                	sd	a1,8(a4)
ffffffffc0201a2a:	d169                	beqz	a0,ffffffffc02019ec <slob_free+0x50>
}
ffffffffc0201a2c:	6402                	ld	s0,0(sp)
ffffffffc0201a2e:	60a2                	ld	ra,8(sp)
ffffffffc0201a30:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201a32:	f77fe06f          	j	ffffffffc02009a8 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201a36:	25bd                	addiw	a1,a1,15
ffffffffc0201a38:	8191                	srli	a1,a1,0x4
ffffffffc0201a3a:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a3c:	100027f3          	csrr	a5,sstatus
ffffffffc0201a40:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a42:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a44:	d7bd                	beqz	a5,ffffffffc02019b2 <slob_free+0x16>
        intr_disable();
ffffffffc0201a46:	f69fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201a4a:	4505                	li	a0,1
ffffffffc0201a4c:	b79d                	j	ffffffffc02019b2 <slob_free+0x16>
ffffffffc0201a4e:	8082                	ret

ffffffffc0201a50 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a50:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a52:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a54:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a58:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a5a:	352000ef          	jal	ra,ffffffffc0201dac <alloc_pages>
	if (!page)
ffffffffc0201a5e:	c91d                	beqz	a0,ffffffffc0201a94 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201a60:	000f9697          	auipc	a3,0xf9
ffffffffc0201a64:	4586b683          	ld	a3,1112(a3) # ffffffffc02faeb8 <pages>
ffffffffc0201a68:	8d15                	sub	a0,a0,a3
ffffffffc0201a6a:	8519                	srai	a0,a0,0x6
ffffffffc0201a6c:	00006697          	auipc	a3,0x6
ffffffffc0201a70:	6746b683          	ld	a3,1652(a3) # ffffffffc02080e0 <nbase>
ffffffffc0201a74:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201a76:	00c51793          	slli	a5,a0,0xc
ffffffffc0201a7a:	83b1                	srli	a5,a5,0xc
ffffffffc0201a7c:	000f9717          	auipc	a4,0xf9
ffffffffc0201a80:	43473703          	ld	a4,1076(a4) # ffffffffc02faeb0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201a84:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201a86:	00e7fa63          	bgeu	a5,a4,ffffffffc0201a9a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201a8a:	000f9697          	auipc	a3,0xf9
ffffffffc0201a8e:	43e6b683          	ld	a3,1086(a3) # ffffffffc02faec8 <va_pa_offset>
ffffffffc0201a92:	9536                	add	a0,a0,a3
}
ffffffffc0201a94:	60a2                	ld	ra,8(sp)
ffffffffc0201a96:	0141                	addi	sp,sp,16
ffffffffc0201a98:	8082                	ret
ffffffffc0201a9a:	86aa                	mv	a3,a0
ffffffffc0201a9c:	00005617          	auipc	a2,0x5
ffffffffc0201aa0:	bcc60613          	addi	a2,a2,-1076 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0201aa4:	07100593          	li	a1,113
ffffffffc0201aa8:	00005517          	auipc	a0,0x5
ffffffffc0201aac:	be850513          	addi	a0,a0,-1048 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0201ab0:	9e3fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201ab4 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201ab4:	1101                	addi	sp,sp,-32
ffffffffc0201ab6:	ec06                	sd	ra,24(sp)
ffffffffc0201ab8:	e822                	sd	s0,16(sp)
ffffffffc0201aba:	e426                	sd	s1,8(sp)
ffffffffc0201abc:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201abe:	01050713          	addi	a4,a0,16
ffffffffc0201ac2:	6785                	lui	a5,0x1
ffffffffc0201ac4:	0cf77363          	bgeu	a4,a5,ffffffffc0201b8a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201ac8:	00f50493          	addi	s1,a0,15
ffffffffc0201acc:	8091                	srli	s1,s1,0x4
ffffffffc0201ace:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ad0:	10002673          	csrr	a2,sstatus
ffffffffc0201ad4:	8a09                	andi	a2,a2,2
ffffffffc0201ad6:	e25d                	bnez	a2,ffffffffc0201b7c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201ad8:	000f5917          	auipc	s2,0xf5
ffffffffc0201adc:	f3090913          	addi	s2,s2,-208 # ffffffffc02f6a08 <slobfree>
ffffffffc0201ae0:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ae4:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201ae6:	4398                	lw	a4,0(a5)
ffffffffc0201ae8:	08975e63          	bge	a4,s1,ffffffffc0201b84 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201aec:	00f68b63          	beq	a3,a5,ffffffffc0201b02 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201af0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201af2:	4018                	lw	a4,0(s0)
ffffffffc0201af4:	02975a63          	bge	a4,s1,ffffffffc0201b28 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201af8:	00093683          	ld	a3,0(s2)
ffffffffc0201afc:	87a2                	mv	a5,s0
ffffffffc0201afe:	fef699e3          	bne	a3,a5,ffffffffc0201af0 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201b02:	ee31                	bnez	a2,ffffffffc0201b5e <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201b04:	4501                	li	a0,0
ffffffffc0201b06:	f4bff0ef          	jal	ra,ffffffffc0201a50 <__slob_get_free_pages.constprop.0>
ffffffffc0201b0a:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201b0c:	cd05                	beqz	a0,ffffffffc0201b44 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201b0e:	6585                	lui	a1,0x1
ffffffffc0201b10:	e8dff0ef          	jal	ra,ffffffffc020199c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b14:	10002673          	csrr	a2,sstatus
ffffffffc0201b18:	8a09                	andi	a2,a2,2
ffffffffc0201b1a:	ee05                	bnez	a2,ffffffffc0201b52 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201b1c:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b20:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201b22:	4018                	lw	a4,0(s0)
ffffffffc0201b24:	fc974ae3          	blt	a4,s1,ffffffffc0201af8 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201b28:	04e48763          	beq	s1,a4,ffffffffc0201b76 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201b2c:	00449693          	slli	a3,s1,0x4
ffffffffc0201b30:	96a2                	add	a3,a3,s0
ffffffffc0201b32:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201b34:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201b36:	9f05                	subw	a4,a4,s1
ffffffffc0201b38:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201b3a:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201b3c:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201b3e:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201b42:	e20d                	bnez	a2,ffffffffc0201b64 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201b44:	60e2                	ld	ra,24(sp)
ffffffffc0201b46:	8522                	mv	a0,s0
ffffffffc0201b48:	6442                	ld	s0,16(sp)
ffffffffc0201b4a:	64a2                	ld	s1,8(sp)
ffffffffc0201b4c:	6902                	ld	s2,0(sp)
ffffffffc0201b4e:	6105                	addi	sp,sp,32
ffffffffc0201b50:	8082                	ret
        intr_disable();
ffffffffc0201b52:	e5dfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
			cur = slobfree;
ffffffffc0201b56:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201b5a:	4605                	li	a2,1
ffffffffc0201b5c:	b7d1                	j	ffffffffc0201b20 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201b5e:	e4bfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201b62:	b74d                	j	ffffffffc0201b04 <slob_alloc.constprop.0+0x50>
ffffffffc0201b64:	e45fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
}
ffffffffc0201b68:	60e2                	ld	ra,24(sp)
ffffffffc0201b6a:	8522                	mv	a0,s0
ffffffffc0201b6c:	6442                	ld	s0,16(sp)
ffffffffc0201b6e:	64a2                	ld	s1,8(sp)
ffffffffc0201b70:	6902                	ld	s2,0(sp)
ffffffffc0201b72:	6105                	addi	sp,sp,32
ffffffffc0201b74:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201b76:	6418                	ld	a4,8(s0)
ffffffffc0201b78:	e798                	sd	a4,8(a5)
ffffffffc0201b7a:	b7d1                	j	ffffffffc0201b3e <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201b7c:	e33fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0201b80:	4605                	li	a2,1
ffffffffc0201b82:	bf99                	j	ffffffffc0201ad8 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201b84:	843e                	mv	s0,a5
ffffffffc0201b86:	87b6                	mv	a5,a3
ffffffffc0201b88:	b745                	j	ffffffffc0201b28 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b8a:	00005697          	auipc	a3,0x5
ffffffffc0201b8e:	b1668693          	addi	a3,a3,-1258 # ffffffffc02066a0 <default_pmm_manager+0x70>
ffffffffc0201b92:	00004617          	auipc	a2,0x4
ffffffffc0201b96:	6ee60613          	addi	a2,a2,1774 # ffffffffc0206280 <commands+0x828>
ffffffffc0201b9a:	06300593          	li	a1,99
ffffffffc0201b9e:	00005517          	auipc	a0,0x5
ffffffffc0201ba2:	b2250513          	addi	a0,a0,-1246 # ffffffffc02066c0 <default_pmm_manager+0x90>
ffffffffc0201ba6:	8edfe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201baa <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201baa:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201bac:	00005517          	auipc	a0,0x5
ffffffffc0201bb0:	b2c50513          	addi	a0,a0,-1236 # ffffffffc02066d8 <default_pmm_manager+0xa8>
{
ffffffffc0201bb4:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201bb6:	de2fe0ef          	jal	ra,ffffffffc0200198 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201bba:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bbc:	00005517          	auipc	a0,0x5
ffffffffc0201bc0:	b3450513          	addi	a0,a0,-1228 # ffffffffc02066f0 <default_pmm_manager+0xc0>
}
ffffffffc0201bc4:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bc6:	dd2fe06f          	j	ffffffffc0200198 <cprintf>

ffffffffc0201bca <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201bca:	4501                	li	a0,0
ffffffffc0201bcc:	8082                	ret

ffffffffc0201bce <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201bce:	1101                	addi	sp,sp,-32
ffffffffc0201bd0:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bd2:	6905                	lui	s2,0x1
{
ffffffffc0201bd4:	e822                	sd	s0,16(sp)
ffffffffc0201bd6:	ec06                	sd	ra,24(sp)
ffffffffc0201bd8:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bda:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8f59>
{
ffffffffc0201bde:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201be0:	04a7f963          	bgeu	a5,a0,ffffffffc0201c32 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201be4:	4561                	li	a0,24
ffffffffc0201be6:	ecfff0ef          	jal	ra,ffffffffc0201ab4 <slob_alloc.constprop.0>
ffffffffc0201bea:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201bec:	c929                	beqz	a0,ffffffffc0201c3e <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201bee:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201bf2:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201bf4:	00f95763          	bge	s2,a5,ffffffffc0201c02 <kmalloc+0x34>
ffffffffc0201bf8:	6705                	lui	a4,0x1
ffffffffc0201bfa:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201bfc:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201bfe:	fef74ee3          	blt	a4,a5,ffffffffc0201bfa <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201c02:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201c04:	e4dff0ef          	jal	ra,ffffffffc0201a50 <__slob_get_free_pages.constprop.0>
ffffffffc0201c08:	e488                	sd	a0,8(s1)
ffffffffc0201c0a:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201c0c:	c525                	beqz	a0,ffffffffc0201c74 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c0e:	100027f3          	csrr	a5,sstatus
ffffffffc0201c12:	8b89                	andi	a5,a5,2
ffffffffc0201c14:	ef8d                	bnez	a5,ffffffffc0201c4e <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201c16:	000f9797          	auipc	a5,0xf9
ffffffffc0201c1a:	28278793          	addi	a5,a5,642 # ffffffffc02fae98 <bigblocks>
ffffffffc0201c1e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201c20:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201c22:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201c24:	60e2                	ld	ra,24(sp)
ffffffffc0201c26:	8522                	mv	a0,s0
ffffffffc0201c28:	6442                	ld	s0,16(sp)
ffffffffc0201c2a:	64a2                	ld	s1,8(sp)
ffffffffc0201c2c:	6902                	ld	s2,0(sp)
ffffffffc0201c2e:	6105                	addi	sp,sp,32
ffffffffc0201c30:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201c32:	0541                	addi	a0,a0,16
ffffffffc0201c34:	e81ff0ef          	jal	ra,ffffffffc0201ab4 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201c38:	01050413          	addi	s0,a0,16
ffffffffc0201c3c:	f565                	bnez	a0,ffffffffc0201c24 <kmalloc+0x56>
ffffffffc0201c3e:	4401                	li	s0,0
}
ffffffffc0201c40:	60e2                	ld	ra,24(sp)
ffffffffc0201c42:	8522                	mv	a0,s0
ffffffffc0201c44:	6442                	ld	s0,16(sp)
ffffffffc0201c46:	64a2                	ld	s1,8(sp)
ffffffffc0201c48:	6902                	ld	s2,0(sp)
ffffffffc0201c4a:	6105                	addi	sp,sp,32
ffffffffc0201c4c:	8082                	ret
        intr_disable();
ffffffffc0201c4e:	d61fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		bb->next = bigblocks;
ffffffffc0201c52:	000f9797          	auipc	a5,0xf9
ffffffffc0201c56:	24678793          	addi	a5,a5,582 # ffffffffc02fae98 <bigblocks>
ffffffffc0201c5a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201c5c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201c5e:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201c60:	d49fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
		return bb->pages;
ffffffffc0201c64:	6480                	ld	s0,8(s1)
}
ffffffffc0201c66:	60e2                	ld	ra,24(sp)
ffffffffc0201c68:	64a2                	ld	s1,8(sp)
ffffffffc0201c6a:	8522                	mv	a0,s0
ffffffffc0201c6c:	6442                	ld	s0,16(sp)
ffffffffc0201c6e:	6902                	ld	s2,0(sp)
ffffffffc0201c70:	6105                	addi	sp,sp,32
ffffffffc0201c72:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c74:	45e1                	li	a1,24
ffffffffc0201c76:	8526                	mv	a0,s1
ffffffffc0201c78:	d25ff0ef          	jal	ra,ffffffffc020199c <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201c7c:	b765                	j	ffffffffc0201c24 <kmalloc+0x56>

ffffffffc0201c7e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201c7e:	c169                	beqz	a0,ffffffffc0201d40 <kfree+0xc2>
{
ffffffffc0201c80:	1101                	addi	sp,sp,-32
ffffffffc0201c82:	e822                	sd	s0,16(sp)
ffffffffc0201c84:	ec06                	sd	ra,24(sp)
ffffffffc0201c86:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201c88:	03451793          	slli	a5,a0,0x34
ffffffffc0201c8c:	842a                	mv	s0,a0
ffffffffc0201c8e:	e3d9                	bnez	a5,ffffffffc0201d14 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c90:	100027f3          	csrr	a5,sstatus
ffffffffc0201c94:	8b89                	andi	a5,a5,2
ffffffffc0201c96:	e7d9                	bnez	a5,ffffffffc0201d24 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c98:	000f9797          	auipc	a5,0xf9
ffffffffc0201c9c:	2007b783          	ld	a5,512(a5) # ffffffffc02fae98 <bigblocks>
    return 0;
ffffffffc0201ca0:	4601                	li	a2,0
ffffffffc0201ca2:	cbad                	beqz	a5,ffffffffc0201d14 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201ca4:	000f9697          	auipc	a3,0xf9
ffffffffc0201ca8:	1f468693          	addi	a3,a3,500 # ffffffffc02fae98 <bigblocks>
ffffffffc0201cac:	a021                	j	ffffffffc0201cb4 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201cae:	01048693          	addi	a3,s1,16
ffffffffc0201cb2:	c3a5                	beqz	a5,ffffffffc0201d12 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201cb4:	6798                	ld	a4,8(a5)
ffffffffc0201cb6:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201cb8:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201cba:	fe871ae3          	bne	a4,s0,ffffffffc0201cae <kfree+0x30>
				*last = bb->next;
ffffffffc0201cbe:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201cc0:	ee2d                	bnez	a2,ffffffffc0201d3a <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201cc2:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201cc6:	4098                	lw	a4,0(s1)
ffffffffc0201cc8:	08f46963          	bltu	s0,a5,ffffffffc0201d5a <kfree+0xdc>
ffffffffc0201ccc:	000f9697          	auipc	a3,0xf9
ffffffffc0201cd0:	1fc6b683          	ld	a3,508(a3) # ffffffffc02faec8 <va_pa_offset>
ffffffffc0201cd4:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201cd6:	8031                	srli	s0,s0,0xc
ffffffffc0201cd8:	000f9797          	auipc	a5,0xf9
ffffffffc0201cdc:	1d87b783          	ld	a5,472(a5) # ffffffffc02faeb0 <npage>
ffffffffc0201ce0:	06f47163          	bgeu	s0,a5,ffffffffc0201d42 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201ce4:	00006517          	auipc	a0,0x6
ffffffffc0201ce8:	3fc53503          	ld	a0,1020(a0) # ffffffffc02080e0 <nbase>
ffffffffc0201cec:	8c09                	sub	s0,s0,a0
ffffffffc0201cee:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201cf0:	000f9517          	auipc	a0,0xf9
ffffffffc0201cf4:	1c853503          	ld	a0,456(a0) # ffffffffc02faeb8 <pages>
ffffffffc0201cf8:	4585                	li	a1,1
ffffffffc0201cfa:	9522                	add	a0,a0,s0
ffffffffc0201cfc:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201d00:	0ea000ef          	jal	ra,ffffffffc0201dea <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201d04:	6442                	ld	s0,16(sp)
ffffffffc0201d06:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d08:	8526                	mv	a0,s1
}
ffffffffc0201d0a:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d0c:	45e1                	li	a1,24
}
ffffffffc0201d0e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d10:	b171                	j	ffffffffc020199c <slob_free>
ffffffffc0201d12:	e20d                	bnez	a2,ffffffffc0201d34 <kfree+0xb6>
ffffffffc0201d14:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201d18:	6442                	ld	s0,16(sp)
ffffffffc0201d1a:	60e2                	ld	ra,24(sp)
ffffffffc0201d1c:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d1e:	4581                	li	a1,0
}
ffffffffc0201d20:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d22:	b9ad                	j	ffffffffc020199c <slob_free>
        intr_disable();
ffffffffc0201d24:	c8bfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d28:	000f9797          	auipc	a5,0xf9
ffffffffc0201d2c:	1707b783          	ld	a5,368(a5) # ffffffffc02fae98 <bigblocks>
        return 1;
ffffffffc0201d30:	4605                	li	a2,1
ffffffffc0201d32:	fbad                	bnez	a5,ffffffffc0201ca4 <kfree+0x26>
        intr_enable();
ffffffffc0201d34:	c75fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d38:	bff1                	j	ffffffffc0201d14 <kfree+0x96>
ffffffffc0201d3a:	c6ffe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0201d3e:	b751                	j	ffffffffc0201cc2 <kfree+0x44>
ffffffffc0201d40:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201d42:	00005617          	auipc	a2,0x5
ffffffffc0201d46:	9f660613          	addi	a2,a2,-1546 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc0201d4a:	06900593          	li	a1,105
ffffffffc0201d4e:	00005517          	auipc	a0,0x5
ffffffffc0201d52:	94250513          	addi	a0,a0,-1726 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0201d56:	f3cfe0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d5a:	86a2                	mv	a3,s0
ffffffffc0201d5c:	00005617          	auipc	a2,0x5
ffffffffc0201d60:	9b460613          	addi	a2,a2,-1612 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc0201d64:	07700593          	li	a1,119
ffffffffc0201d68:	00005517          	auipc	a0,0x5
ffffffffc0201d6c:	92850513          	addi	a0,a0,-1752 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0201d70:	f22fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201d74 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201d74:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201d76:	00005617          	auipc	a2,0x5
ffffffffc0201d7a:	9c260613          	addi	a2,a2,-1598 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc0201d7e:	06900593          	li	a1,105
ffffffffc0201d82:	00005517          	auipc	a0,0x5
ffffffffc0201d86:	90e50513          	addi	a0,a0,-1778 # ffffffffc0206690 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201d8a:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201d8c:	f06fe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201d90 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201d90:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201d92:	00005617          	auipc	a2,0x5
ffffffffc0201d96:	9c660613          	addi	a2,a2,-1594 # ffffffffc0206758 <default_pmm_manager+0x128>
ffffffffc0201d9a:	07f00593          	li	a1,127
ffffffffc0201d9e:	00005517          	auipc	a0,0x5
ffffffffc0201da2:	8f250513          	addi	a0,a0,-1806 # ffffffffc0206690 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201da6:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201da8:	eeafe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0201dac <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dac:	100027f3          	csrr	a5,sstatus
ffffffffc0201db0:	8b89                	andi	a5,a5,2
ffffffffc0201db2:	e799                	bnez	a5,ffffffffc0201dc0 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201db4:	000f9797          	auipc	a5,0xf9
ffffffffc0201db8:	10c7b783          	ld	a5,268(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201dbc:	6f9c                	ld	a5,24(a5)
ffffffffc0201dbe:	8782                	jr	a5
{
ffffffffc0201dc0:	1141                	addi	sp,sp,-16
ffffffffc0201dc2:	e406                	sd	ra,8(sp)
ffffffffc0201dc4:	e022                	sd	s0,0(sp)
ffffffffc0201dc6:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201dc8:	be7fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201dcc:	000f9797          	auipc	a5,0xf9
ffffffffc0201dd0:	0f47b783          	ld	a5,244(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201dd4:	6f9c                	ld	a5,24(a5)
ffffffffc0201dd6:	8522                	mv	a0,s0
ffffffffc0201dd8:	9782                	jalr	a5
ffffffffc0201dda:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ddc:	bcdfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201de0:	60a2                	ld	ra,8(sp)
ffffffffc0201de2:	8522                	mv	a0,s0
ffffffffc0201de4:	6402                	ld	s0,0(sp)
ffffffffc0201de6:	0141                	addi	sp,sp,16
ffffffffc0201de8:	8082                	ret

ffffffffc0201dea <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dea:	100027f3          	csrr	a5,sstatus
ffffffffc0201dee:	8b89                	andi	a5,a5,2
ffffffffc0201df0:	e799                	bnez	a5,ffffffffc0201dfe <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201df2:	000f9797          	auipc	a5,0xf9
ffffffffc0201df6:	0ce7b783          	ld	a5,206(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201dfa:	739c                	ld	a5,32(a5)
ffffffffc0201dfc:	8782                	jr	a5
{
ffffffffc0201dfe:	1101                	addi	sp,sp,-32
ffffffffc0201e00:	ec06                	sd	ra,24(sp)
ffffffffc0201e02:	e822                	sd	s0,16(sp)
ffffffffc0201e04:	e426                	sd	s1,8(sp)
ffffffffc0201e06:	842a                	mv	s0,a0
ffffffffc0201e08:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201e0a:	ba5fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201e0e:	000f9797          	auipc	a5,0xf9
ffffffffc0201e12:	0b27b783          	ld	a5,178(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201e16:	739c                	ld	a5,32(a5)
ffffffffc0201e18:	85a6                	mv	a1,s1
ffffffffc0201e1a:	8522                	mv	a0,s0
ffffffffc0201e1c:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201e1e:	6442                	ld	s0,16(sp)
ffffffffc0201e20:	60e2                	ld	ra,24(sp)
ffffffffc0201e22:	64a2                	ld	s1,8(sp)
ffffffffc0201e24:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201e26:	b83fe06f          	j	ffffffffc02009a8 <intr_enable>

ffffffffc0201e2a <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e2a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e2e:	8b89                	andi	a5,a5,2
ffffffffc0201e30:	e799                	bnez	a5,ffffffffc0201e3e <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e32:	000f9797          	auipc	a5,0xf9
ffffffffc0201e36:	08e7b783          	ld	a5,142(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201e3a:	779c                	ld	a5,40(a5)
ffffffffc0201e3c:	8782                	jr	a5
{
ffffffffc0201e3e:	1141                	addi	sp,sp,-16
ffffffffc0201e40:	e406                	sd	ra,8(sp)
ffffffffc0201e42:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201e44:	b6bfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e48:	000f9797          	auipc	a5,0xf9
ffffffffc0201e4c:	0787b783          	ld	a5,120(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201e50:	779c                	ld	a5,40(a5)
ffffffffc0201e52:	9782                	jalr	a5
ffffffffc0201e54:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e56:	b53fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201e5a:	60a2                	ld	ra,8(sp)
ffffffffc0201e5c:	8522                	mv	a0,s0
ffffffffc0201e5e:	6402                	ld	s0,0(sp)
ffffffffc0201e60:	0141                	addi	sp,sp,16
ffffffffc0201e62:	8082                	ret

ffffffffc0201e64 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e64:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e68:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201e6c:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e6e:	078e                	slli	a5,a5,0x3
{
ffffffffc0201e70:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e72:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201e76:	6094                	ld	a3,0(s1)
{
ffffffffc0201e78:	f04a                	sd	s2,32(sp)
ffffffffc0201e7a:	ec4e                	sd	s3,24(sp)
ffffffffc0201e7c:	e852                	sd	s4,16(sp)
ffffffffc0201e7e:	fc06                	sd	ra,56(sp)
ffffffffc0201e80:	f822                	sd	s0,48(sp)
ffffffffc0201e82:	e456                	sd	s5,8(sp)
ffffffffc0201e84:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201e86:	0016f793          	andi	a5,a3,1
{
ffffffffc0201e8a:	892e                	mv	s2,a1
ffffffffc0201e8c:	8a32                	mv	s4,a2
ffffffffc0201e8e:	000f9997          	auipc	s3,0xf9
ffffffffc0201e92:	02298993          	addi	s3,s3,34 # ffffffffc02faeb0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201e96:	efbd                	bnez	a5,ffffffffc0201f14 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e98:	14060c63          	beqz	a2,ffffffffc0201ff0 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201ea0:	8b89                	andi	a5,a5,2
ffffffffc0201ea2:	14079963          	bnez	a5,ffffffffc0201ff4 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ea6:	000f9797          	auipc	a5,0xf9
ffffffffc0201eaa:	01a7b783          	ld	a5,26(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201eae:	6f9c                	ld	a5,24(a5)
ffffffffc0201eb0:	4505                	li	a0,1
ffffffffc0201eb2:	9782                	jalr	a5
ffffffffc0201eb4:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201eb6:	12040d63          	beqz	s0,ffffffffc0201ff0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201eba:	000f9b17          	auipc	s6,0xf9
ffffffffc0201ebe:	ffeb0b13          	addi	s6,s6,-2 # ffffffffc02faeb8 <pages>
ffffffffc0201ec2:	000b3503          	ld	a0,0(s6)
ffffffffc0201ec6:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201eca:	000f9997          	auipc	s3,0xf9
ffffffffc0201ece:	fe698993          	addi	s3,s3,-26 # ffffffffc02faeb0 <npage>
ffffffffc0201ed2:	40a40533          	sub	a0,s0,a0
ffffffffc0201ed6:	8519                	srai	a0,a0,0x6
ffffffffc0201ed8:	9556                	add	a0,a0,s5
ffffffffc0201eda:	0009b703          	ld	a4,0(s3)
ffffffffc0201ede:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201ee2:	4685                	li	a3,1
ffffffffc0201ee4:	c014                	sw	a3,0(s0)
ffffffffc0201ee6:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ee8:	0532                	slli	a0,a0,0xc
ffffffffc0201eea:	16e7f763          	bgeu	a5,a4,ffffffffc0202058 <get_pte+0x1f4>
ffffffffc0201eee:	000f9797          	auipc	a5,0xf9
ffffffffc0201ef2:	fda7b783          	ld	a5,-38(a5) # ffffffffc02faec8 <va_pa_offset>
ffffffffc0201ef6:	6605                	lui	a2,0x1
ffffffffc0201ef8:	4581                	li	a1,0
ffffffffc0201efa:	953e                	add	a0,a0,a5
ffffffffc0201efc:	0c7030ef          	jal	ra,ffffffffc02057c2 <memset>
    return page - pages + nbase;
ffffffffc0201f00:	000b3683          	ld	a3,0(s6)
ffffffffc0201f04:	40d406b3          	sub	a3,s0,a3
ffffffffc0201f08:	8699                	srai	a3,a3,0x6
ffffffffc0201f0a:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f0c:	06aa                	slli	a3,a3,0xa
ffffffffc0201f0e:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f12:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f14:	77fd                	lui	a5,0xfffff
ffffffffc0201f16:	068a                	slli	a3,a3,0x2
ffffffffc0201f18:	0009b703          	ld	a4,0(s3)
ffffffffc0201f1c:	8efd                	and	a3,a3,a5
ffffffffc0201f1e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f22:	10e7ff63          	bgeu	a5,a4,ffffffffc0202040 <get_pte+0x1dc>
ffffffffc0201f26:	000f9a97          	auipc	s5,0xf9
ffffffffc0201f2a:	fa2a8a93          	addi	s5,s5,-94 # ffffffffc02faec8 <va_pa_offset>
ffffffffc0201f2e:	000ab403          	ld	s0,0(s5)
ffffffffc0201f32:	01595793          	srli	a5,s2,0x15
ffffffffc0201f36:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f3a:	96a2                	add	a3,a3,s0
ffffffffc0201f3c:	00379413          	slli	s0,a5,0x3
ffffffffc0201f40:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201f42:	6014                	ld	a3,0(s0)
ffffffffc0201f44:	0016f793          	andi	a5,a3,1
ffffffffc0201f48:	ebad                	bnez	a5,ffffffffc0201fba <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f4a:	0a0a0363          	beqz	s4,ffffffffc0201ff0 <get_pte+0x18c>
ffffffffc0201f4e:	100027f3          	csrr	a5,sstatus
ffffffffc0201f52:	8b89                	andi	a5,a5,2
ffffffffc0201f54:	efcd                	bnez	a5,ffffffffc020200e <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f56:	000f9797          	auipc	a5,0xf9
ffffffffc0201f5a:	f6a7b783          	ld	a5,-150(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0201f5e:	6f9c                	ld	a5,24(a5)
ffffffffc0201f60:	4505                	li	a0,1
ffffffffc0201f62:	9782                	jalr	a5
ffffffffc0201f64:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f66:	c4c9                	beqz	s1,ffffffffc0201ff0 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201f68:	000f9b17          	auipc	s6,0xf9
ffffffffc0201f6c:	f50b0b13          	addi	s6,s6,-176 # ffffffffc02faeb8 <pages>
ffffffffc0201f70:	000b3503          	ld	a0,0(s6)
ffffffffc0201f74:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f78:	0009b703          	ld	a4,0(s3)
ffffffffc0201f7c:	40a48533          	sub	a0,s1,a0
ffffffffc0201f80:	8519                	srai	a0,a0,0x6
ffffffffc0201f82:	9552                	add	a0,a0,s4
ffffffffc0201f84:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201f88:	4685                	li	a3,1
ffffffffc0201f8a:	c094                	sw	a3,0(s1)
ffffffffc0201f8c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f8e:	0532                	slli	a0,a0,0xc
ffffffffc0201f90:	0ee7f163          	bgeu	a5,a4,ffffffffc0202072 <get_pte+0x20e>
ffffffffc0201f94:	000ab783          	ld	a5,0(s5)
ffffffffc0201f98:	6605                	lui	a2,0x1
ffffffffc0201f9a:	4581                	li	a1,0
ffffffffc0201f9c:	953e                	add	a0,a0,a5
ffffffffc0201f9e:	025030ef          	jal	ra,ffffffffc02057c2 <memset>
    return page - pages + nbase;
ffffffffc0201fa2:	000b3683          	ld	a3,0(s6)
ffffffffc0201fa6:	40d486b3          	sub	a3,s1,a3
ffffffffc0201faa:	8699                	srai	a3,a3,0x6
ffffffffc0201fac:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201fae:	06aa                	slli	a3,a3,0xa
ffffffffc0201fb0:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201fb4:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201fb6:	0009b703          	ld	a4,0(s3)
ffffffffc0201fba:	068a                	slli	a3,a3,0x2
ffffffffc0201fbc:	757d                	lui	a0,0xfffff
ffffffffc0201fbe:	8ee9                	and	a3,a3,a0
ffffffffc0201fc0:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201fc4:	06e7f263          	bgeu	a5,a4,ffffffffc0202028 <get_pte+0x1c4>
ffffffffc0201fc8:	000ab503          	ld	a0,0(s5)
ffffffffc0201fcc:	00c95913          	srli	s2,s2,0xc
ffffffffc0201fd0:	1ff97913          	andi	s2,s2,511
ffffffffc0201fd4:	96aa                	add	a3,a3,a0
ffffffffc0201fd6:	00391513          	slli	a0,s2,0x3
ffffffffc0201fda:	9536                	add	a0,a0,a3
}
ffffffffc0201fdc:	70e2                	ld	ra,56(sp)
ffffffffc0201fde:	7442                	ld	s0,48(sp)
ffffffffc0201fe0:	74a2                	ld	s1,40(sp)
ffffffffc0201fe2:	7902                	ld	s2,32(sp)
ffffffffc0201fe4:	69e2                	ld	s3,24(sp)
ffffffffc0201fe6:	6a42                	ld	s4,16(sp)
ffffffffc0201fe8:	6aa2                	ld	s5,8(sp)
ffffffffc0201fea:	6b02                	ld	s6,0(sp)
ffffffffc0201fec:	6121                	addi	sp,sp,64
ffffffffc0201fee:	8082                	ret
            return NULL;
ffffffffc0201ff0:	4501                	li	a0,0
ffffffffc0201ff2:	b7ed                	j	ffffffffc0201fdc <get_pte+0x178>
        intr_disable();
ffffffffc0201ff4:	9bbfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ff8:	000f9797          	auipc	a5,0xf9
ffffffffc0201ffc:	ec87b783          	ld	a5,-312(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0202000:	6f9c                	ld	a5,24(a5)
ffffffffc0202002:	4505                	li	a0,1
ffffffffc0202004:	9782                	jalr	a5
ffffffffc0202006:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202008:	9a1fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020200c:	b56d                	j	ffffffffc0201eb6 <get_pte+0x52>
        intr_disable();
ffffffffc020200e:	9a1fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202012:	000f9797          	auipc	a5,0xf9
ffffffffc0202016:	eae7b783          	ld	a5,-338(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc020201a:	6f9c                	ld	a5,24(a5)
ffffffffc020201c:	4505                	li	a0,1
ffffffffc020201e:	9782                	jalr	a5
ffffffffc0202020:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0202022:	987fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202026:	b781                	j	ffffffffc0201f66 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202028:	00004617          	auipc	a2,0x4
ffffffffc020202c:	64060613          	addi	a2,a2,1600 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202030:	0fa00593          	li	a1,250
ffffffffc0202034:	00004517          	auipc	a0,0x4
ffffffffc0202038:	74c50513          	addi	a0,a0,1868 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020203c:	c56fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202040:	00004617          	auipc	a2,0x4
ffffffffc0202044:	62860613          	addi	a2,a2,1576 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202048:	0ed00593          	li	a1,237
ffffffffc020204c:	00004517          	auipc	a0,0x4
ffffffffc0202050:	73450513          	addi	a0,a0,1844 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202054:	c3efe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202058:	86aa                	mv	a3,a0
ffffffffc020205a:	00004617          	auipc	a2,0x4
ffffffffc020205e:	60e60613          	addi	a2,a2,1550 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202062:	0e900593          	li	a1,233
ffffffffc0202066:	00004517          	auipc	a0,0x4
ffffffffc020206a:	71a50513          	addi	a0,a0,1818 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020206e:	c24fe0ef          	jal	ra,ffffffffc0200492 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202072:	86aa                	mv	a3,a0
ffffffffc0202074:	00004617          	auipc	a2,0x4
ffffffffc0202078:	5f460613          	addi	a2,a2,1524 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc020207c:	0f700593          	li	a1,247
ffffffffc0202080:	00004517          	auipc	a0,0x4
ffffffffc0202084:	70050513          	addi	a0,a0,1792 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202088:	c0afe0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020208c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020208c:	1141                	addi	sp,sp,-16
ffffffffc020208e:	e022                	sd	s0,0(sp)
ffffffffc0202090:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202092:	4601                	li	a2,0
{
ffffffffc0202094:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202096:	dcfff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
    if (ptep_store != NULL)
ffffffffc020209a:	c011                	beqz	s0,ffffffffc020209e <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020209c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020209e:	c511                	beqz	a0,ffffffffc02020aa <get_page+0x1e>
ffffffffc02020a0:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02020a2:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020a4:	0017f713          	andi	a4,a5,1
ffffffffc02020a8:	e709                	bnez	a4,ffffffffc02020b2 <get_page+0x26>
}
ffffffffc02020aa:	60a2                	ld	ra,8(sp)
ffffffffc02020ac:	6402                	ld	s0,0(sp)
ffffffffc02020ae:	0141                	addi	sp,sp,16
ffffffffc02020b0:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02020b2:	078a                	slli	a5,a5,0x2
ffffffffc02020b4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020b6:	000f9717          	auipc	a4,0xf9
ffffffffc02020ba:	dfa73703          	ld	a4,-518(a4) # ffffffffc02faeb0 <npage>
ffffffffc02020be:	00e7ff63          	bgeu	a5,a4,ffffffffc02020dc <get_page+0x50>
ffffffffc02020c2:	60a2                	ld	ra,8(sp)
ffffffffc02020c4:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02020c6:	fff80537          	lui	a0,0xfff80
ffffffffc02020ca:	97aa                	add	a5,a5,a0
ffffffffc02020cc:	079a                	slli	a5,a5,0x6
ffffffffc02020ce:	000f9517          	auipc	a0,0xf9
ffffffffc02020d2:	dea53503          	ld	a0,-534(a0) # ffffffffc02faeb8 <pages>
ffffffffc02020d6:	953e                	add	a0,a0,a5
ffffffffc02020d8:	0141                	addi	sp,sp,16
ffffffffc02020da:	8082                	ret
ffffffffc02020dc:	c99ff0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>

ffffffffc02020e0 <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02020e0:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020e2:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02020e6:	f486                	sd	ra,104(sp)
ffffffffc02020e8:	f0a2                	sd	s0,96(sp)
ffffffffc02020ea:	eca6                	sd	s1,88(sp)
ffffffffc02020ec:	e8ca                	sd	s2,80(sp)
ffffffffc02020ee:	e4ce                	sd	s3,72(sp)
ffffffffc02020f0:	e0d2                	sd	s4,64(sp)
ffffffffc02020f2:	fc56                	sd	s5,56(sp)
ffffffffc02020f4:	f85a                	sd	s6,48(sp)
ffffffffc02020f6:	f45e                	sd	s7,40(sp)
ffffffffc02020f8:	f062                	sd	s8,32(sp)
ffffffffc02020fa:	ec66                	sd	s9,24(sp)
ffffffffc02020fc:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020fe:	17d2                	slli	a5,a5,0x34
ffffffffc0202100:	e3ed                	bnez	a5,ffffffffc02021e2 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc0202102:	002007b7          	lui	a5,0x200
ffffffffc0202106:	842e                	mv	s0,a1
ffffffffc0202108:	0ef5ed63          	bltu	a1,a5,ffffffffc0202202 <unmap_range+0x122>
ffffffffc020210c:	8932                	mv	s2,a2
ffffffffc020210e:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202202 <unmap_range+0x122>
ffffffffc0202112:	4785                	li	a5,1
ffffffffc0202114:	07fe                	slli	a5,a5,0x1f
ffffffffc0202116:	0ec7e663          	bltu	a5,a2,ffffffffc0202202 <unmap_range+0x122>
ffffffffc020211a:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc020211c:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020211e:	000f9c97          	auipc	s9,0xf9
ffffffffc0202122:	d92c8c93          	addi	s9,s9,-622 # ffffffffc02faeb0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202126:	000f9c17          	auipc	s8,0xf9
ffffffffc020212a:	d92c0c13          	addi	s8,s8,-622 # ffffffffc02faeb8 <pages>
ffffffffc020212e:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc0202132:	000f9d17          	auipc	s10,0xf9
ffffffffc0202136:	d8ed0d13          	addi	s10,s10,-626 # ffffffffc02faec0 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020213a:	00200b37          	lui	s6,0x200
ffffffffc020213e:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202142:	4601                	li	a2,0
ffffffffc0202144:	85a2                	mv	a1,s0
ffffffffc0202146:	854e                	mv	a0,s3
ffffffffc0202148:	d1dff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc020214c:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020214e:	cd29                	beqz	a0,ffffffffc02021a8 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202150:	611c                	ld	a5,0(a0)
ffffffffc0202152:	e395                	bnez	a5,ffffffffc0202176 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202154:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202156:	ff2466e3          	bltu	s0,s2,ffffffffc0202142 <unmap_range+0x62>
}
ffffffffc020215a:	70a6                	ld	ra,104(sp)
ffffffffc020215c:	7406                	ld	s0,96(sp)
ffffffffc020215e:	64e6                	ld	s1,88(sp)
ffffffffc0202160:	6946                	ld	s2,80(sp)
ffffffffc0202162:	69a6                	ld	s3,72(sp)
ffffffffc0202164:	6a06                	ld	s4,64(sp)
ffffffffc0202166:	7ae2                	ld	s5,56(sp)
ffffffffc0202168:	7b42                	ld	s6,48(sp)
ffffffffc020216a:	7ba2                	ld	s7,40(sp)
ffffffffc020216c:	7c02                	ld	s8,32(sp)
ffffffffc020216e:	6ce2                	ld	s9,24(sp)
ffffffffc0202170:	6d42                	ld	s10,16(sp)
ffffffffc0202172:	6165                	addi	sp,sp,112
ffffffffc0202174:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202176:	0017f713          	andi	a4,a5,1
ffffffffc020217a:	df69                	beqz	a4,ffffffffc0202154 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc020217c:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202180:	078a                	slli	a5,a5,0x2
ffffffffc0202182:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202184:	08e7ff63          	bgeu	a5,a4,ffffffffc0202222 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202188:	000c3503          	ld	a0,0(s8)
ffffffffc020218c:	97de                	add	a5,a5,s7
ffffffffc020218e:	079a                	slli	a5,a5,0x6
ffffffffc0202190:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202192:	411c                	lw	a5,0(a0)
ffffffffc0202194:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202198:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020219a:	cf11                	beqz	a4,ffffffffc02021b6 <unmap_range+0xd6>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020219c:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021a0:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02021a4:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02021a6:	bf45                	j	ffffffffc0202156 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02021a8:	945a                	add	s0,s0,s6
ffffffffc02021aa:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02021ae:	d455                	beqz	s0,ffffffffc020215a <unmap_range+0x7a>
ffffffffc02021b0:	f92469e3          	bltu	s0,s2,ffffffffc0202142 <unmap_range+0x62>
ffffffffc02021b4:	b75d                	j	ffffffffc020215a <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02021b6:	100027f3          	csrr	a5,sstatus
ffffffffc02021ba:	8b89                	andi	a5,a5,2
ffffffffc02021bc:	e799                	bnez	a5,ffffffffc02021ca <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02021be:	000d3783          	ld	a5,0(s10)
ffffffffc02021c2:	4585                	li	a1,1
ffffffffc02021c4:	739c                	ld	a5,32(a5)
ffffffffc02021c6:	9782                	jalr	a5
    if (flag)
ffffffffc02021c8:	bfd1                	j	ffffffffc020219c <unmap_range+0xbc>
ffffffffc02021ca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02021cc:	fe2fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc02021d0:	000d3783          	ld	a5,0(s10)
ffffffffc02021d4:	6522                	ld	a0,8(sp)
ffffffffc02021d6:	4585                	li	a1,1
ffffffffc02021d8:	739c                	ld	a5,32(a5)
ffffffffc02021da:	9782                	jalr	a5
        intr_enable();
ffffffffc02021dc:	fccfe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc02021e0:	bf75                	j	ffffffffc020219c <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021e2:	00004697          	auipc	a3,0x4
ffffffffc02021e6:	5ae68693          	addi	a3,a3,1454 # ffffffffc0206790 <default_pmm_manager+0x160>
ffffffffc02021ea:	00004617          	auipc	a2,0x4
ffffffffc02021ee:	09660613          	addi	a2,a2,150 # ffffffffc0206280 <commands+0x828>
ffffffffc02021f2:	12200593          	li	a1,290
ffffffffc02021f6:	00004517          	auipc	a0,0x4
ffffffffc02021fa:	58a50513          	addi	a0,a0,1418 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02021fe:	a94fe0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202202:	00004697          	auipc	a3,0x4
ffffffffc0202206:	5be68693          	addi	a3,a3,1470 # ffffffffc02067c0 <default_pmm_manager+0x190>
ffffffffc020220a:	00004617          	auipc	a2,0x4
ffffffffc020220e:	07660613          	addi	a2,a2,118 # ffffffffc0206280 <commands+0x828>
ffffffffc0202212:	12300593          	li	a1,291
ffffffffc0202216:	00004517          	auipc	a0,0x4
ffffffffc020221a:	56a50513          	addi	a0,a0,1386 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020221e:	a74fe0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202222:	b53ff0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>

ffffffffc0202226 <exit_range>:
{
ffffffffc0202226:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202228:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020222c:	fc86                	sd	ra,120(sp)
ffffffffc020222e:	f8a2                	sd	s0,112(sp)
ffffffffc0202230:	f4a6                	sd	s1,104(sp)
ffffffffc0202232:	f0ca                	sd	s2,96(sp)
ffffffffc0202234:	ecce                	sd	s3,88(sp)
ffffffffc0202236:	e8d2                	sd	s4,80(sp)
ffffffffc0202238:	e4d6                	sd	s5,72(sp)
ffffffffc020223a:	e0da                	sd	s6,64(sp)
ffffffffc020223c:	fc5e                	sd	s7,56(sp)
ffffffffc020223e:	f862                	sd	s8,48(sp)
ffffffffc0202240:	f466                	sd	s9,40(sp)
ffffffffc0202242:	f06a                	sd	s10,32(sp)
ffffffffc0202244:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202246:	17d2                	slli	a5,a5,0x34
ffffffffc0202248:	20079a63          	bnez	a5,ffffffffc020245c <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc020224c:	002007b7          	lui	a5,0x200
ffffffffc0202250:	24f5e463          	bltu	a1,a5,ffffffffc0202498 <exit_range+0x272>
ffffffffc0202254:	8ab2                	mv	s5,a2
ffffffffc0202256:	24c5f163          	bgeu	a1,a2,ffffffffc0202498 <exit_range+0x272>
ffffffffc020225a:	4785                	li	a5,1
ffffffffc020225c:	07fe                	slli	a5,a5,0x1f
ffffffffc020225e:	22c7ed63          	bltu	a5,a2,ffffffffc0202498 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202262:	c00009b7          	lui	s3,0xc0000
ffffffffc0202266:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020226a:	ffe00937          	lui	s2,0xffe00
ffffffffc020226e:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202272:	5cfd                	li	s9,-1
ffffffffc0202274:	8c2a                	mv	s8,a0
ffffffffc0202276:	0125f933          	and	s2,a1,s2
ffffffffc020227a:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc020227c:	000f9d17          	auipc	s10,0xf9
ffffffffc0202280:	c34d0d13          	addi	s10,s10,-972 # ffffffffc02faeb0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202284:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202288:	000f9717          	auipc	a4,0xf9
ffffffffc020228c:	c3070713          	addi	a4,a4,-976 # ffffffffc02faeb8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202290:	000f9d97          	auipc	s11,0xf9
ffffffffc0202294:	c30d8d93          	addi	s11,s11,-976 # ffffffffc02faec0 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202298:	c0000437          	lui	s0,0xc0000
ffffffffc020229c:	944e                	add	s0,s0,s3
ffffffffc020229e:	8079                	srli	s0,s0,0x1e
ffffffffc02022a0:	1ff47413          	andi	s0,s0,511
ffffffffc02022a4:	040e                	slli	s0,s0,0x3
ffffffffc02022a6:	9462                	add	s0,s0,s8
ffffffffc02022a8:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38e8>
        if (pde1 & PTE_V)
ffffffffc02022ac:	001a7793          	andi	a5,s4,1
ffffffffc02022b0:	eb99                	bnez	a5,ffffffffc02022c6 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02022b2:	12098463          	beqz	s3,ffffffffc02023da <exit_range+0x1b4>
ffffffffc02022b6:	400007b7          	lui	a5,0x40000
ffffffffc02022ba:	97ce                	add	a5,a5,s3
ffffffffc02022bc:	894e                	mv	s2,s3
ffffffffc02022be:	1159fe63          	bgeu	s3,s5,ffffffffc02023da <exit_range+0x1b4>
ffffffffc02022c2:	89be                	mv	s3,a5
ffffffffc02022c4:	bfd1                	j	ffffffffc0202298 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02022c6:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022ca:	0a0a                	slli	s4,s4,0x2
ffffffffc02022cc:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02022d0:	1cfa7263          	bgeu	s4,a5,ffffffffc0202494 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02022d4:	fff80637          	lui	a2,0xfff80
ffffffffc02022d8:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02022da:	000806b7          	lui	a3,0x80
ffffffffc02022de:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02022e0:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02022e4:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02022e6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02022e8:	18f5fa63          	bgeu	a1,a5,ffffffffc020247c <exit_range+0x256>
ffffffffc02022ec:	000f9817          	auipc	a6,0xf9
ffffffffc02022f0:	bdc80813          	addi	a6,a6,-1060 # ffffffffc02faec8 <va_pa_offset>
ffffffffc02022f4:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02022f8:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02022fa:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02022fe:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202300:	00080337          	lui	t1,0x80
ffffffffc0202304:	6885                	lui	a7,0x1
ffffffffc0202306:	a819                	j	ffffffffc020231c <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202308:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc020230a:	002007b7          	lui	a5,0x200
ffffffffc020230e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202310:	08090c63          	beqz	s2,ffffffffc02023a8 <exit_range+0x182>
ffffffffc0202314:	09397a63          	bgeu	s2,s3,ffffffffc02023a8 <exit_range+0x182>
ffffffffc0202318:	0f597063          	bgeu	s2,s5,ffffffffc02023f8 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc020231c:	01595493          	srli	s1,s2,0x15
ffffffffc0202320:	1ff4f493          	andi	s1,s1,511
ffffffffc0202324:	048e                	slli	s1,s1,0x3
ffffffffc0202326:	94da                	add	s1,s1,s6
ffffffffc0202328:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc020232a:	0017f693          	andi	a3,a5,1
ffffffffc020232e:	dee9                	beqz	a3,ffffffffc0202308 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202330:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202334:	078a                	slli	a5,a5,0x2
ffffffffc0202336:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202338:	14b7fe63          	bgeu	a5,a1,ffffffffc0202494 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020233c:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020233e:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0202342:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202346:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020234a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020234c:	12bef863          	bgeu	t4,a1,ffffffffc020247c <exit_range+0x256>
ffffffffc0202350:	00083783          	ld	a5,0(a6)
ffffffffc0202354:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202356:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc020235a:	629c                	ld	a5,0(a3)
ffffffffc020235c:	8b85                	andi	a5,a5,1
ffffffffc020235e:	f7d5                	bnez	a5,ffffffffc020230a <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202360:	06a1                	addi	a3,a3,8
ffffffffc0202362:	fed59ce3          	bne	a1,a3,ffffffffc020235a <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202366:	631c                	ld	a5,0(a4)
ffffffffc0202368:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020236a:	100027f3          	csrr	a5,sstatus
ffffffffc020236e:	8b89                	andi	a5,a5,2
ffffffffc0202370:	e7d9                	bnez	a5,ffffffffc02023fe <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202372:	000db783          	ld	a5,0(s11)
ffffffffc0202376:	4585                	li	a1,1
ffffffffc0202378:	e032                	sd	a2,0(sp)
ffffffffc020237a:	739c                	ld	a5,32(a5)
ffffffffc020237c:	9782                	jalr	a5
    if (flag)
ffffffffc020237e:	6602                	ld	a2,0(sp)
ffffffffc0202380:	000f9817          	auipc	a6,0xf9
ffffffffc0202384:	b4880813          	addi	a6,a6,-1208 # ffffffffc02faec8 <va_pa_offset>
ffffffffc0202388:	fff80e37          	lui	t3,0xfff80
ffffffffc020238c:	00080337          	lui	t1,0x80
ffffffffc0202390:	6885                	lui	a7,0x1
ffffffffc0202392:	000f9717          	auipc	a4,0xf9
ffffffffc0202396:	b2670713          	addi	a4,a4,-1242 # ffffffffc02faeb8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020239a:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020239e:	002007b7          	lui	a5,0x200
ffffffffc02023a2:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023a4:	f60918e3          	bnez	s2,ffffffffc0202314 <exit_range+0xee>
            if (free_pd0)
ffffffffc02023a8:	f00b85e3          	beqz	s7,ffffffffc02022b2 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02023ac:	000d3783          	ld	a5,0(s10)
ffffffffc02023b0:	0efa7263          	bgeu	s4,a5,ffffffffc0202494 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023b4:	6308                	ld	a0,0(a4)
ffffffffc02023b6:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02023b8:	100027f3          	csrr	a5,sstatus
ffffffffc02023bc:	8b89                	andi	a5,a5,2
ffffffffc02023be:	efad                	bnez	a5,ffffffffc0202438 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02023c0:	000db783          	ld	a5,0(s11)
ffffffffc02023c4:	4585                	li	a1,1
ffffffffc02023c6:	739c                	ld	a5,32(a5)
ffffffffc02023c8:	9782                	jalr	a5
ffffffffc02023ca:	000f9717          	auipc	a4,0xf9
ffffffffc02023ce:	aee70713          	addi	a4,a4,-1298 # ffffffffc02faeb8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02023d2:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02023d6:	ee0990e3          	bnez	s3,ffffffffc02022b6 <exit_range+0x90>
}
ffffffffc02023da:	70e6                	ld	ra,120(sp)
ffffffffc02023dc:	7446                	ld	s0,112(sp)
ffffffffc02023de:	74a6                	ld	s1,104(sp)
ffffffffc02023e0:	7906                	ld	s2,96(sp)
ffffffffc02023e2:	69e6                	ld	s3,88(sp)
ffffffffc02023e4:	6a46                	ld	s4,80(sp)
ffffffffc02023e6:	6aa6                	ld	s5,72(sp)
ffffffffc02023e8:	6b06                	ld	s6,64(sp)
ffffffffc02023ea:	7be2                	ld	s7,56(sp)
ffffffffc02023ec:	7c42                	ld	s8,48(sp)
ffffffffc02023ee:	7ca2                	ld	s9,40(sp)
ffffffffc02023f0:	7d02                	ld	s10,32(sp)
ffffffffc02023f2:	6de2                	ld	s11,24(sp)
ffffffffc02023f4:	6109                	addi	sp,sp,128
ffffffffc02023f6:	8082                	ret
            if (free_pd0)
ffffffffc02023f8:	ea0b8fe3          	beqz	s7,ffffffffc02022b6 <exit_range+0x90>
ffffffffc02023fc:	bf45                	j	ffffffffc02023ac <exit_range+0x186>
ffffffffc02023fe:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202400:	e42a                	sd	a0,8(sp)
ffffffffc0202402:	dacfe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202406:	000db783          	ld	a5,0(s11)
ffffffffc020240a:	6522                	ld	a0,8(sp)
ffffffffc020240c:	4585                	li	a1,1
ffffffffc020240e:	739c                	ld	a5,32(a5)
ffffffffc0202410:	9782                	jalr	a5
        intr_enable();
ffffffffc0202412:	d96fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202416:	6602                	ld	a2,0(sp)
ffffffffc0202418:	000f9717          	auipc	a4,0xf9
ffffffffc020241c:	aa070713          	addi	a4,a4,-1376 # ffffffffc02faeb8 <pages>
ffffffffc0202420:	6885                	lui	a7,0x1
ffffffffc0202422:	00080337          	lui	t1,0x80
ffffffffc0202426:	fff80e37          	lui	t3,0xfff80
ffffffffc020242a:	000f9817          	auipc	a6,0xf9
ffffffffc020242e:	a9e80813          	addi	a6,a6,-1378 # ffffffffc02faec8 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202432:	0004b023          	sd	zero,0(s1)
ffffffffc0202436:	b7a5                	j	ffffffffc020239e <exit_range+0x178>
ffffffffc0202438:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc020243a:	d74fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020243e:	000db783          	ld	a5,0(s11)
ffffffffc0202442:	6502                	ld	a0,0(sp)
ffffffffc0202444:	4585                	li	a1,1
ffffffffc0202446:	739c                	ld	a5,32(a5)
ffffffffc0202448:	9782                	jalr	a5
        intr_enable();
ffffffffc020244a:	d5efe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020244e:	000f9717          	auipc	a4,0xf9
ffffffffc0202452:	a6a70713          	addi	a4,a4,-1430 # ffffffffc02faeb8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202456:	00043023          	sd	zero,0(s0)
ffffffffc020245a:	bfb5                	j	ffffffffc02023d6 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020245c:	00004697          	auipc	a3,0x4
ffffffffc0202460:	33468693          	addi	a3,a3,820 # ffffffffc0206790 <default_pmm_manager+0x160>
ffffffffc0202464:	00004617          	auipc	a2,0x4
ffffffffc0202468:	e1c60613          	addi	a2,a2,-484 # ffffffffc0206280 <commands+0x828>
ffffffffc020246c:	13700593          	li	a1,311
ffffffffc0202470:	00004517          	auipc	a0,0x4
ffffffffc0202474:	31050513          	addi	a0,a0,784 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202478:	81afe0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc020247c:	00004617          	auipc	a2,0x4
ffffffffc0202480:	1ec60613          	addi	a2,a2,492 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202484:	07100593          	li	a1,113
ffffffffc0202488:	00004517          	auipc	a0,0x4
ffffffffc020248c:	20850513          	addi	a0,a0,520 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0202490:	802fe0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202494:	8e1ff0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202498:	00004697          	auipc	a3,0x4
ffffffffc020249c:	32868693          	addi	a3,a3,808 # ffffffffc02067c0 <default_pmm_manager+0x190>
ffffffffc02024a0:	00004617          	auipc	a2,0x4
ffffffffc02024a4:	de060613          	addi	a2,a2,-544 # ffffffffc0206280 <commands+0x828>
ffffffffc02024a8:	13800593          	li	a1,312
ffffffffc02024ac:	00004517          	auipc	a0,0x4
ffffffffc02024b0:	2d450513          	addi	a0,a0,724 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02024b4:	fdffd0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02024b8 <page_remove>:
{
ffffffffc02024b8:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02024ba:	4601                	li	a2,0
{
ffffffffc02024bc:	ec26                	sd	s1,24(sp)
ffffffffc02024be:	f406                	sd	ra,40(sp)
ffffffffc02024c0:	f022                	sd	s0,32(sp)
ffffffffc02024c2:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02024c4:	9a1ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
    if (ptep != NULL)
ffffffffc02024c8:	c511                	beqz	a0,ffffffffc02024d4 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02024ca:	611c                	ld	a5,0(a0)
ffffffffc02024cc:	842a                	mv	s0,a0
ffffffffc02024ce:	0017f713          	andi	a4,a5,1
ffffffffc02024d2:	e711                	bnez	a4,ffffffffc02024de <page_remove+0x26>
}
ffffffffc02024d4:	70a2                	ld	ra,40(sp)
ffffffffc02024d6:	7402                	ld	s0,32(sp)
ffffffffc02024d8:	64e2                	ld	s1,24(sp)
ffffffffc02024da:	6145                	addi	sp,sp,48
ffffffffc02024dc:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02024de:	078a                	slli	a5,a5,0x2
ffffffffc02024e0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024e2:	000f9717          	auipc	a4,0xf9
ffffffffc02024e6:	9ce73703          	ld	a4,-1586(a4) # ffffffffc02faeb0 <npage>
ffffffffc02024ea:	06e7f363          	bgeu	a5,a4,ffffffffc0202550 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ee:	fff80537          	lui	a0,0xfff80
ffffffffc02024f2:	97aa                	add	a5,a5,a0
ffffffffc02024f4:	079a                	slli	a5,a5,0x6
ffffffffc02024f6:	000f9517          	auipc	a0,0xf9
ffffffffc02024fa:	9c253503          	ld	a0,-1598(a0) # ffffffffc02faeb8 <pages>
ffffffffc02024fe:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202500:	411c                	lw	a5,0(a0)
ffffffffc0202502:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202506:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202508:	cb11                	beqz	a4,ffffffffc020251c <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020250a:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020250e:	12048073          	sfence.vma	s1
}
ffffffffc0202512:	70a2                	ld	ra,40(sp)
ffffffffc0202514:	7402                	ld	s0,32(sp)
ffffffffc0202516:	64e2                	ld	s1,24(sp)
ffffffffc0202518:	6145                	addi	sp,sp,48
ffffffffc020251a:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020251c:	100027f3          	csrr	a5,sstatus
ffffffffc0202520:	8b89                	andi	a5,a5,2
ffffffffc0202522:	eb89                	bnez	a5,ffffffffc0202534 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202524:	000f9797          	auipc	a5,0xf9
ffffffffc0202528:	99c7b783          	ld	a5,-1636(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc020252c:	739c                	ld	a5,32(a5)
ffffffffc020252e:	4585                	li	a1,1
ffffffffc0202530:	9782                	jalr	a5
    if (flag)
ffffffffc0202532:	bfe1                	j	ffffffffc020250a <page_remove+0x52>
        intr_disable();
ffffffffc0202534:	e42a                	sd	a0,8(sp)
ffffffffc0202536:	c78fe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc020253a:	000f9797          	auipc	a5,0xf9
ffffffffc020253e:	9867b783          	ld	a5,-1658(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc0202542:	739c                	ld	a5,32(a5)
ffffffffc0202544:	6522                	ld	a0,8(sp)
ffffffffc0202546:	4585                	li	a1,1
ffffffffc0202548:	9782                	jalr	a5
        intr_enable();
ffffffffc020254a:	c5efe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020254e:	bf75                	j	ffffffffc020250a <page_remove+0x52>
ffffffffc0202550:	825ff0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>

ffffffffc0202554 <page_insert>:
{
ffffffffc0202554:	7139                	addi	sp,sp,-64
ffffffffc0202556:	e852                	sd	s4,16(sp)
ffffffffc0202558:	8a32                	mv	s4,a2
ffffffffc020255a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020255c:	4605                	li	a2,1
{
ffffffffc020255e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202560:	85d2                	mv	a1,s4
{
ffffffffc0202562:	f426                	sd	s1,40(sp)
ffffffffc0202564:	fc06                	sd	ra,56(sp)
ffffffffc0202566:	f04a                	sd	s2,32(sp)
ffffffffc0202568:	ec4e                	sd	s3,24(sp)
ffffffffc020256a:	e456                	sd	s5,8(sp)
ffffffffc020256c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020256e:	8f7ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
    if (ptep == NULL)
ffffffffc0202572:	c961                	beqz	a0,ffffffffc0202642 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202574:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202576:	611c                	ld	a5,0(a0)
ffffffffc0202578:	89aa                	mv	s3,a0
ffffffffc020257a:	0016871b          	addiw	a4,a3,1
ffffffffc020257e:	c018                	sw	a4,0(s0)
ffffffffc0202580:	0017f713          	andi	a4,a5,1
ffffffffc0202584:	ef05                	bnez	a4,ffffffffc02025bc <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202586:	000f9717          	auipc	a4,0xf9
ffffffffc020258a:	93273703          	ld	a4,-1742(a4) # ffffffffc02faeb8 <pages>
ffffffffc020258e:	8c19                	sub	s0,s0,a4
ffffffffc0202590:	000807b7          	lui	a5,0x80
ffffffffc0202594:	8419                	srai	s0,s0,0x6
ffffffffc0202596:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202598:	042a                	slli	s0,s0,0xa
ffffffffc020259a:	8cc1                	or	s1,s1,s0
ffffffffc020259c:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02025a0:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38e8>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025a4:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02025a8:	4501                	li	a0,0
}
ffffffffc02025aa:	70e2                	ld	ra,56(sp)
ffffffffc02025ac:	7442                	ld	s0,48(sp)
ffffffffc02025ae:	74a2                	ld	s1,40(sp)
ffffffffc02025b0:	7902                	ld	s2,32(sp)
ffffffffc02025b2:	69e2                	ld	s3,24(sp)
ffffffffc02025b4:	6a42                	ld	s4,16(sp)
ffffffffc02025b6:	6aa2                	ld	s5,8(sp)
ffffffffc02025b8:	6121                	addi	sp,sp,64
ffffffffc02025ba:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025bc:	078a                	slli	a5,a5,0x2
ffffffffc02025be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025c0:	000f9717          	auipc	a4,0xf9
ffffffffc02025c4:	8f073703          	ld	a4,-1808(a4) # ffffffffc02faeb0 <npage>
ffffffffc02025c8:	06e7ff63          	bgeu	a5,a4,ffffffffc0202646 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02025cc:	000f9a97          	auipc	s5,0xf9
ffffffffc02025d0:	8eca8a93          	addi	s5,s5,-1812 # ffffffffc02faeb8 <pages>
ffffffffc02025d4:	000ab703          	ld	a4,0(s5)
ffffffffc02025d8:	fff80937          	lui	s2,0xfff80
ffffffffc02025dc:	993e                	add	s2,s2,a5
ffffffffc02025de:	091a                	slli	s2,s2,0x6
ffffffffc02025e0:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02025e2:	01240c63          	beq	s0,s2,ffffffffc02025fa <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02025e6:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fc85100>
ffffffffc02025ea:	fff7869b          	addiw	a3,a5,-1
ffffffffc02025ee:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc02025f2:	c691                	beqz	a3,ffffffffc02025fe <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025f4:	120a0073          	sfence.vma	s4
}
ffffffffc02025f8:	bf59                	j	ffffffffc020258e <page_insert+0x3a>
ffffffffc02025fa:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02025fc:	bf49                	j	ffffffffc020258e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025fe:	100027f3          	csrr	a5,sstatus
ffffffffc0202602:	8b89                	andi	a5,a5,2
ffffffffc0202604:	ef91                	bnez	a5,ffffffffc0202620 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202606:	000f9797          	auipc	a5,0xf9
ffffffffc020260a:	8ba7b783          	ld	a5,-1862(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc020260e:	739c                	ld	a5,32(a5)
ffffffffc0202610:	4585                	li	a1,1
ffffffffc0202612:	854a                	mv	a0,s2
ffffffffc0202614:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202616:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020261a:	120a0073          	sfence.vma	s4
ffffffffc020261e:	bf85                	j	ffffffffc020258e <page_insert+0x3a>
        intr_disable();
ffffffffc0202620:	b8efe0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202624:	000f9797          	auipc	a5,0xf9
ffffffffc0202628:	89c7b783          	ld	a5,-1892(a5) # ffffffffc02faec0 <pmm_manager>
ffffffffc020262c:	739c                	ld	a5,32(a5)
ffffffffc020262e:	4585                	li	a1,1
ffffffffc0202630:	854a                	mv	a0,s2
ffffffffc0202632:	9782                	jalr	a5
        intr_enable();
ffffffffc0202634:	b74fe0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202638:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020263c:	120a0073          	sfence.vma	s4
ffffffffc0202640:	b7b9                	j	ffffffffc020258e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202642:	5571                	li	a0,-4
ffffffffc0202644:	b79d                	j	ffffffffc02025aa <page_insert+0x56>
ffffffffc0202646:	f2eff0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>

ffffffffc020264a <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020264a:	00004797          	auipc	a5,0x4
ffffffffc020264e:	fe678793          	addi	a5,a5,-26 # ffffffffc0206630 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202652:	638c                	ld	a1,0(a5)
{
ffffffffc0202654:	7159                	addi	sp,sp,-112
ffffffffc0202656:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202658:	00004517          	auipc	a0,0x4
ffffffffc020265c:	18050513          	addi	a0,a0,384 # ffffffffc02067d8 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202660:	000f9b17          	auipc	s6,0xf9
ffffffffc0202664:	860b0b13          	addi	s6,s6,-1952 # ffffffffc02faec0 <pmm_manager>
{
ffffffffc0202668:	f486                	sd	ra,104(sp)
ffffffffc020266a:	e8ca                	sd	s2,80(sp)
ffffffffc020266c:	e4ce                	sd	s3,72(sp)
ffffffffc020266e:	f0a2                	sd	s0,96(sp)
ffffffffc0202670:	eca6                	sd	s1,88(sp)
ffffffffc0202672:	e0d2                	sd	s4,64(sp)
ffffffffc0202674:	fc56                	sd	s5,56(sp)
ffffffffc0202676:	f45e                	sd	s7,40(sp)
ffffffffc0202678:	f062                	sd	s8,32(sp)
ffffffffc020267a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020267c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202680:	b19fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    pmm_manager->init();
ffffffffc0202684:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202688:	000f9997          	auipc	s3,0xf9
ffffffffc020268c:	84098993          	addi	s3,s3,-1984 # ffffffffc02faec8 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202690:	679c                	ld	a5,8(a5)
ffffffffc0202692:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202694:	57f5                	li	a5,-3
ffffffffc0202696:	07fa                	slli	a5,a5,0x1e
ffffffffc0202698:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020269c:	af8fe0ef          	jal	ra,ffffffffc0200994 <get_memory_base>
ffffffffc02026a0:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02026a2:	afcfe0ef          	jal	ra,ffffffffc020099e <get_memory_size>
    if (mem_size == 0)
ffffffffc02026a6:	200505e3          	beqz	a0,ffffffffc02030b0 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02026aa:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02026ac:	00004517          	auipc	a0,0x4
ffffffffc02026b0:	16450513          	addi	a0,a0,356 # ffffffffc0206810 <default_pmm_manager+0x1e0>
ffffffffc02026b4:	ae5fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02026b8:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02026bc:	fff40693          	addi	a3,s0,-1
ffffffffc02026c0:	864a                	mv	a2,s2
ffffffffc02026c2:	85a6                	mv	a1,s1
ffffffffc02026c4:	00004517          	auipc	a0,0x4
ffffffffc02026c8:	16450513          	addi	a0,a0,356 # ffffffffc0206828 <default_pmm_manager+0x1f8>
ffffffffc02026cc:	acdfd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02026d0:	c8000737          	lui	a4,0xc8000
ffffffffc02026d4:	87a2                	mv	a5,s0
ffffffffc02026d6:	54876163          	bltu	a4,s0,ffffffffc0202c18 <pmm_init+0x5ce>
ffffffffc02026da:	757d                	lui	a0,0xfffff
ffffffffc02026dc:	000fa617          	auipc	a2,0xfa
ffffffffc02026e0:	82360613          	addi	a2,a2,-2013 # ffffffffc02fbeff <end+0xfff>
ffffffffc02026e4:	8e69                	and	a2,a2,a0
ffffffffc02026e6:	000f8497          	auipc	s1,0xf8
ffffffffc02026ea:	7ca48493          	addi	s1,s1,1994 # ffffffffc02faeb0 <npage>
ffffffffc02026ee:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026f2:	000f8b97          	auipc	s7,0xf8
ffffffffc02026f6:	7c6b8b93          	addi	s7,s7,1990 # ffffffffc02faeb8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02026fa:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02026fc:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202700:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202704:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202706:	02f50863          	beq	a0,a5,ffffffffc0202736 <pmm_init+0xec>
ffffffffc020270a:	4781                	li	a5,0
ffffffffc020270c:	4585                	li	a1,1
ffffffffc020270e:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202712:	00679513          	slli	a0,a5,0x6
ffffffffc0202716:	9532                	add	a0,a0,a2
ffffffffc0202718:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd04108>
ffffffffc020271c:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202720:	6088                	ld	a0,0(s1)
ffffffffc0202722:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202724:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202728:	00d50733          	add	a4,a0,a3
ffffffffc020272c:	fee7e3e3          	bltu	a5,a4,ffffffffc0202712 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202730:	071a                	slli	a4,a4,0x6
ffffffffc0202732:	00e606b3          	add	a3,a2,a4
ffffffffc0202736:	c02007b7          	lui	a5,0xc0200
ffffffffc020273a:	2ef6ece3          	bltu	a3,a5,ffffffffc0203232 <pmm_init+0xbe8>
ffffffffc020273e:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202742:	77fd                	lui	a5,0xfffff
ffffffffc0202744:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202746:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202748:	5086eb63          	bltu	a3,s0,ffffffffc0202c5e <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020274c:	00004517          	auipc	a0,0x4
ffffffffc0202750:	10450513          	addi	a0,a0,260 # ffffffffc0206850 <default_pmm_manager+0x220>
ffffffffc0202754:	a45fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202758:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020275c:	000f8917          	auipc	s2,0xf8
ffffffffc0202760:	74c90913          	addi	s2,s2,1868 # ffffffffc02faea8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202764:	7b9c                	ld	a5,48(a5)
ffffffffc0202766:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202768:	00004517          	auipc	a0,0x4
ffffffffc020276c:	10050513          	addi	a0,a0,256 # ffffffffc0206868 <default_pmm_manager+0x238>
ffffffffc0202770:	a29fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202774:	00009697          	auipc	a3,0x9
ffffffffc0202778:	88c68693          	addi	a3,a3,-1908 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc020277c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202780:	c02007b7          	lui	a5,0xc0200
ffffffffc0202784:	28f6ebe3          	bltu	a3,a5,ffffffffc020321a <pmm_init+0xbd0>
ffffffffc0202788:	0009b783          	ld	a5,0(s3)
ffffffffc020278c:	8e9d                	sub	a3,a3,a5
ffffffffc020278e:	000f8797          	auipc	a5,0xf8
ffffffffc0202792:	70d7b923          	sd	a3,1810(a5) # ffffffffc02faea0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202796:	100027f3          	csrr	a5,sstatus
ffffffffc020279a:	8b89                	andi	a5,a5,2
ffffffffc020279c:	4a079763          	bnez	a5,ffffffffc0202c4a <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027a0:	000b3783          	ld	a5,0(s6)
ffffffffc02027a4:	779c                	ld	a5,40(a5)
ffffffffc02027a6:	9782                	jalr	a5
ffffffffc02027a8:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02027aa:	6098                	ld	a4,0(s1)
ffffffffc02027ac:	c80007b7          	lui	a5,0xc8000
ffffffffc02027b0:	83b1                	srli	a5,a5,0xc
ffffffffc02027b2:	66e7e363          	bltu	a5,a4,ffffffffc0202e18 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02027b6:	00093503          	ld	a0,0(s2)
ffffffffc02027ba:	62050f63          	beqz	a0,ffffffffc0202df8 <pmm_init+0x7ae>
ffffffffc02027be:	03451793          	slli	a5,a0,0x34
ffffffffc02027c2:	62079b63          	bnez	a5,ffffffffc0202df8 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02027c6:	4601                	li	a2,0
ffffffffc02027c8:	4581                	li	a1,0
ffffffffc02027ca:	8c3ff0ef          	jal	ra,ffffffffc020208c <get_page>
ffffffffc02027ce:	60051563          	bnez	a0,ffffffffc0202dd8 <pmm_init+0x78e>
ffffffffc02027d2:	100027f3          	csrr	a5,sstatus
ffffffffc02027d6:	8b89                	andi	a5,a5,2
ffffffffc02027d8:	44079e63          	bnez	a5,ffffffffc0202c34 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027dc:	000b3783          	ld	a5,0(s6)
ffffffffc02027e0:	4505                	li	a0,1
ffffffffc02027e2:	6f9c                	ld	a5,24(a5)
ffffffffc02027e4:	9782                	jalr	a5
ffffffffc02027e6:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02027e8:	00093503          	ld	a0,0(s2)
ffffffffc02027ec:	4681                	li	a3,0
ffffffffc02027ee:	4601                	li	a2,0
ffffffffc02027f0:	85d2                	mv	a1,s4
ffffffffc02027f2:	d63ff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc02027f6:	26051ae3          	bnez	a0,ffffffffc020326a <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02027fa:	00093503          	ld	a0,0(s2)
ffffffffc02027fe:	4601                	li	a2,0
ffffffffc0202800:	4581                	li	a1,0
ffffffffc0202802:	e62ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc0202806:	240502e3          	beqz	a0,ffffffffc020324a <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc020280a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020280c:	0017f713          	andi	a4,a5,1
ffffffffc0202810:	5a070263          	beqz	a4,ffffffffc0202db4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202814:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202816:	078a                	slli	a5,a5,0x2
ffffffffc0202818:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020281a:	58e7fb63          	bgeu	a5,a4,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020281e:	000bb683          	ld	a3,0(s7)
ffffffffc0202822:	fff80637          	lui	a2,0xfff80
ffffffffc0202826:	97b2                	add	a5,a5,a2
ffffffffc0202828:	079a                	slli	a5,a5,0x6
ffffffffc020282a:	97b6                	add	a5,a5,a3
ffffffffc020282c:	14fa17e3          	bne	s4,a5,ffffffffc020317a <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202830:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f48>
ffffffffc0202834:	4785                	li	a5,1
ffffffffc0202836:	12f692e3          	bne	a3,a5,ffffffffc020315a <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020283a:	00093503          	ld	a0,0(s2)
ffffffffc020283e:	77fd                	lui	a5,0xfffff
ffffffffc0202840:	6114                	ld	a3,0(a0)
ffffffffc0202842:	068a                	slli	a3,a3,0x2
ffffffffc0202844:	8efd                	and	a3,a3,a5
ffffffffc0202846:	00c6d613          	srli	a2,a3,0xc
ffffffffc020284a:	0ee67ce3          	bgeu	a2,a4,ffffffffc0203142 <pmm_init+0xaf8>
ffffffffc020284e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202852:	96e2                	add	a3,a3,s8
ffffffffc0202854:	0006ba83          	ld	s5,0(a3)
ffffffffc0202858:	0a8a                	slli	s5,s5,0x2
ffffffffc020285a:	00fafab3          	and	s5,s5,a5
ffffffffc020285e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202862:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203128 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202866:	4601                	li	a2,0
ffffffffc0202868:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020286a:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020286c:	df8ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202870:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202872:	55551363          	bne	a0,s5,ffffffffc0202db8 <pmm_init+0x76e>
ffffffffc0202876:	100027f3          	csrr	a5,sstatus
ffffffffc020287a:	8b89                	andi	a5,a5,2
ffffffffc020287c:	3a079163          	bnez	a5,ffffffffc0202c1e <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202880:	000b3783          	ld	a5,0(s6)
ffffffffc0202884:	4505                	li	a0,1
ffffffffc0202886:	6f9c                	ld	a5,24(a5)
ffffffffc0202888:	9782                	jalr	a5
ffffffffc020288a:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020288c:	00093503          	ld	a0,0(s2)
ffffffffc0202890:	46d1                	li	a3,20
ffffffffc0202892:	6605                	lui	a2,0x1
ffffffffc0202894:	85e2                	mv	a1,s8
ffffffffc0202896:	cbfff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc020289a:	060517e3          	bnez	a0,ffffffffc0203108 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020289e:	00093503          	ld	a0,0(s2)
ffffffffc02028a2:	4601                	li	a2,0
ffffffffc02028a4:	6585                	lui	a1,0x1
ffffffffc02028a6:	dbeff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc02028aa:	02050fe3          	beqz	a0,ffffffffc02030e8 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02028ae:	611c                	ld	a5,0(a0)
ffffffffc02028b0:	0107f713          	andi	a4,a5,16
ffffffffc02028b4:	7c070e63          	beqz	a4,ffffffffc0203090 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02028b8:	8b91                	andi	a5,a5,4
ffffffffc02028ba:	7a078b63          	beqz	a5,ffffffffc0203070 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02028be:	00093503          	ld	a0,0(s2)
ffffffffc02028c2:	611c                	ld	a5,0(a0)
ffffffffc02028c4:	8bc1                	andi	a5,a5,16
ffffffffc02028c6:	78078563          	beqz	a5,ffffffffc0203050 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02028ca:	000c2703          	lw	a4,0(s8)
ffffffffc02028ce:	4785                	li	a5,1
ffffffffc02028d0:	76f71063          	bne	a4,a5,ffffffffc0203030 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02028d4:	4681                	li	a3,0
ffffffffc02028d6:	6605                	lui	a2,0x1
ffffffffc02028d8:	85d2                	mv	a1,s4
ffffffffc02028da:	c7bff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc02028de:	72051963          	bnez	a0,ffffffffc0203010 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02028e2:	000a2703          	lw	a4,0(s4)
ffffffffc02028e6:	4789                	li	a5,2
ffffffffc02028e8:	70f71463          	bne	a4,a5,ffffffffc0202ff0 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02028ec:	000c2783          	lw	a5,0(s8)
ffffffffc02028f0:	6e079063          	bnez	a5,ffffffffc0202fd0 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02028f4:	00093503          	ld	a0,0(s2)
ffffffffc02028f8:	4601                	li	a2,0
ffffffffc02028fa:	6585                	lui	a1,0x1
ffffffffc02028fc:	d68ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc0202900:	6a050863          	beqz	a0,ffffffffc0202fb0 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202904:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202906:	00177793          	andi	a5,a4,1
ffffffffc020290a:	4a078563          	beqz	a5,ffffffffc0202db4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020290e:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202910:	00271793          	slli	a5,a4,0x2
ffffffffc0202914:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202916:	48d7fd63          	bgeu	a5,a3,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020291a:	000bb683          	ld	a3,0(s7)
ffffffffc020291e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202922:	97d6                	add	a5,a5,s5
ffffffffc0202924:	079a                	slli	a5,a5,0x6
ffffffffc0202926:	97b6                	add	a5,a5,a3
ffffffffc0202928:	66fa1463          	bne	s4,a5,ffffffffc0202f90 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc020292c:	8b41                	andi	a4,a4,16
ffffffffc020292e:	64071163          	bnez	a4,ffffffffc0202f70 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202932:	00093503          	ld	a0,0(s2)
ffffffffc0202936:	4581                	li	a1,0
ffffffffc0202938:	b81ff0ef          	jal	ra,ffffffffc02024b8 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020293c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202940:	4785                	li	a5,1
ffffffffc0202942:	60fc9763          	bne	s9,a5,ffffffffc0202f50 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202946:	000c2783          	lw	a5,0(s8)
ffffffffc020294a:	5e079363          	bnez	a5,ffffffffc0202f30 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020294e:	00093503          	ld	a0,0(s2)
ffffffffc0202952:	6585                	lui	a1,0x1
ffffffffc0202954:	b65ff0ef          	jal	ra,ffffffffc02024b8 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202958:	000a2783          	lw	a5,0(s4)
ffffffffc020295c:	52079a63          	bnez	a5,ffffffffc0202e90 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202960:	000c2783          	lw	a5,0(s8)
ffffffffc0202964:	50079663          	bnez	a5,ffffffffc0202e70 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202968:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020296c:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020296e:	000a3683          	ld	a3,0(s4)
ffffffffc0202972:	068a                	slli	a3,a3,0x2
ffffffffc0202974:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202976:	42b6fd63          	bgeu	a3,a1,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020297a:	000bb503          	ld	a0,0(s7)
ffffffffc020297e:	96d6                	add	a3,a3,s5
ffffffffc0202980:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202982:	00d507b3          	add	a5,a0,a3
ffffffffc0202986:	439c                	lw	a5,0(a5)
ffffffffc0202988:	4d979463          	bne	a5,s9,ffffffffc0202e50 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc020298c:	8699                	srai	a3,a3,0x6
ffffffffc020298e:	00080637          	lui	a2,0x80
ffffffffc0202992:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202994:	00c69713          	slli	a4,a3,0xc
ffffffffc0202998:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020299a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020299c:	48b77e63          	bgeu	a4,a1,ffffffffc0202e38 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02029a0:	0009b703          	ld	a4,0(s3)
ffffffffc02029a4:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02029a6:	629c                	ld	a5,0(a3)
ffffffffc02029a8:	078a                	slli	a5,a5,0x2
ffffffffc02029aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029ac:	40b7f263          	bgeu	a5,a1,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029b0:	8f91                	sub	a5,a5,a2
ffffffffc02029b2:	079a                	slli	a5,a5,0x6
ffffffffc02029b4:	953e                	add	a0,a0,a5
ffffffffc02029b6:	100027f3          	csrr	a5,sstatus
ffffffffc02029ba:	8b89                	andi	a5,a5,2
ffffffffc02029bc:	30079963          	bnez	a5,ffffffffc0202cce <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02029c0:	000b3783          	ld	a5,0(s6)
ffffffffc02029c4:	4585                	li	a1,1
ffffffffc02029c6:	739c                	ld	a5,32(a5)
ffffffffc02029c8:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02029ca:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02029ce:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02029d0:	078a                	slli	a5,a5,0x2
ffffffffc02029d2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029d4:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029d8:	000bb503          	ld	a0,0(s7)
ffffffffc02029dc:	fff80737          	lui	a4,0xfff80
ffffffffc02029e0:	97ba                	add	a5,a5,a4
ffffffffc02029e2:	079a                	slli	a5,a5,0x6
ffffffffc02029e4:	953e                	add	a0,a0,a5
ffffffffc02029e6:	100027f3          	csrr	a5,sstatus
ffffffffc02029ea:	8b89                	andi	a5,a5,2
ffffffffc02029ec:	2c079563          	bnez	a5,ffffffffc0202cb6 <pmm_init+0x66c>
ffffffffc02029f0:	000b3783          	ld	a5,0(s6)
ffffffffc02029f4:	4585                	li	a1,1
ffffffffc02029f6:	739c                	ld	a5,32(a5)
ffffffffc02029f8:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02029fa:	00093783          	ld	a5,0(s2)
ffffffffc02029fe:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd04100>
    asm volatile("sfence.vma");
ffffffffc0202a02:	12000073          	sfence.vma
ffffffffc0202a06:	100027f3          	csrr	a5,sstatus
ffffffffc0202a0a:	8b89                	andi	a5,a5,2
ffffffffc0202a0c:	28079b63          	bnez	a5,ffffffffc0202ca2 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a10:	000b3783          	ld	a5,0(s6)
ffffffffc0202a14:	779c                	ld	a5,40(a5)
ffffffffc0202a16:	9782                	jalr	a5
ffffffffc0202a18:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202a1a:	4b441b63          	bne	s0,s4,ffffffffc0202ed0 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202a1e:	00004517          	auipc	a0,0x4
ffffffffc0202a22:	17250513          	addi	a0,a0,370 # ffffffffc0206b90 <default_pmm_manager+0x560>
ffffffffc0202a26:	f72fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
ffffffffc0202a2a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a2e:	8b89                	andi	a5,a5,2
ffffffffc0202a30:	24079f63          	bnez	a5,ffffffffc0202c8e <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202a34:	000b3783          	ld	a5,0(s6)
ffffffffc0202a38:	779c                	ld	a5,40(a5)
ffffffffc0202a3a:	9782                	jalr	a5
ffffffffc0202a3c:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a3e:	6098                	ld	a4,0(s1)
ffffffffc0202a40:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a44:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a46:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a4a:	6a05                	lui	s4,0x1
ffffffffc0202a4c:	02f47c63          	bgeu	s0,a5,ffffffffc0202a84 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202a50:	00c45793          	srli	a5,s0,0xc
ffffffffc0202a54:	00093503          	ld	a0,0(s2)
ffffffffc0202a58:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202d56 <pmm_init+0x70c>
ffffffffc0202a5c:	0009b583          	ld	a1,0(s3)
ffffffffc0202a60:	4601                	li	a2,0
ffffffffc0202a62:	95a2                	add	a1,a1,s0
ffffffffc0202a64:	c00ff0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc0202a68:	32050463          	beqz	a0,ffffffffc0202d90 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202a6c:	611c                	ld	a5,0(a0)
ffffffffc0202a6e:	078a                	slli	a5,a5,0x2
ffffffffc0202a70:	0157f7b3          	and	a5,a5,s5
ffffffffc0202a74:	2e879e63          	bne	a5,s0,ffffffffc0202d70 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202a78:	6098                	ld	a4,0(s1)
ffffffffc0202a7a:	9452                	add	s0,s0,s4
ffffffffc0202a7c:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a80:	fcf468e3          	bltu	s0,a5,ffffffffc0202a50 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202a84:	00093783          	ld	a5,0(s2)
ffffffffc0202a88:	639c                	ld	a5,0(a5)
ffffffffc0202a8a:	42079363          	bnez	a5,ffffffffc0202eb0 <pmm_init+0x866>
ffffffffc0202a8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202a92:	8b89                	andi	a5,a5,2
ffffffffc0202a94:	24079963          	bnez	a5,ffffffffc0202ce6 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a98:	000b3783          	ld	a5,0(s6)
ffffffffc0202a9c:	4505                	li	a0,1
ffffffffc0202a9e:	6f9c                	ld	a5,24(a5)
ffffffffc0202aa0:	9782                	jalr	a5
ffffffffc0202aa2:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202aa4:	00093503          	ld	a0,0(s2)
ffffffffc0202aa8:	4699                	li	a3,6
ffffffffc0202aaa:	10000613          	li	a2,256
ffffffffc0202aae:	85d2                	mv	a1,s4
ffffffffc0202ab0:	aa5ff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc0202ab4:	44051e63          	bnez	a0,ffffffffc0202f10 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202ab8:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f48>
ffffffffc0202abc:	4785                	li	a5,1
ffffffffc0202abe:	42f71963          	bne	a4,a5,ffffffffc0202ef0 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202ac2:	00093503          	ld	a0,0(s2)
ffffffffc0202ac6:	6405                	lui	s0,0x1
ffffffffc0202ac8:	4699                	li	a3,6
ffffffffc0202aca:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8e48>
ffffffffc0202ace:	85d2                	mv	a1,s4
ffffffffc0202ad0:	a85ff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc0202ad4:	72051363          	bnez	a0,ffffffffc02031fa <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202ad8:	000a2703          	lw	a4,0(s4)
ffffffffc0202adc:	4789                	li	a5,2
ffffffffc0202ade:	6ef71e63          	bne	a4,a5,ffffffffc02031da <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202ae2:	00004597          	auipc	a1,0x4
ffffffffc0202ae6:	1f658593          	addi	a1,a1,502 # ffffffffc0206cd8 <default_pmm_manager+0x6a8>
ffffffffc0202aea:	10000513          	li	a0,256
ffffffffc0202aee:	469020ef          	jal	ra,ffffffffc0205756 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202af2:	10040593          	addi	a1,s0,256
ffffffffc0202af6:	10000513          	li	a0,256
ffffffffc0202afa:	46f020ef          	jal	ra,ffffffffc0205768 <strcmp>
ffffffffc0202afe:	6a051e63          	bnez	a0,ffffffffc02031ba <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202b02:	000bb683          	ld	a3,0(s7)
ffffffffc0202b06:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202b0a:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202b0c:	40da06b3          	sub	a3,s4,a3
ffffffffc0202b10:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202b12:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202b14:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202b16:	8031                	srli	s0,s0,0xc
ffffffffc0202b18:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b1c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b1e:	30f77d63          	bgeu	a4,a5,ffffffffc0202e38 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b22:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b26:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202b2a:	96be                	add	a3,a3,a5
ffffffffc0202b2c:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202b30:	3f1020ef          	jal	ra,ffffffffc0205720 <strlen>
ffffffffc0202b34:	66051363          	bnez	a0,ffffffffc020319a <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202b38:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b3c:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b3e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd04100>
ffffffffc0202b42:	068a                	slli	a3,a3,0x2
ffffffffc0202b44:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b46:	26f6f563          	bgeu	a3,a5,ffffffffc0202db0 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202b4a:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b4c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b4e:	2ef47563          	bgeu	s0,a5,ffffffffc0202e38 <pmm_init+0x7ee>
ffffffffc0202b52:	0009b403          	ld	s0,0(s3)
ffffffffc0202b56:	9436                	add	s0,s0,a3
ffffffffc0202b58:	100027f3          	csrr	a5,sstatus
ffffffffc0202b5c:	8b89                	andi	a5,a5,2
ffffffffc0202b5e:	1e079163          	bnez	a5,ffffffffc0202d40 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202b62:	000b3783          	ld	a5,0(s6)
ffffffffc0202b66:	4585                	li	a1,1
ffffffffc0202b68:	8552                	mv	a0,s4
ffffffffc0202b6a:	739c                	ld	a5,32(a5)
ffffffffc0202b6c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b6e:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202b70:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b72:	078a                	slli	a5,a5,0x2
ffffffffc0202b74:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b76:	22e7fd63          	bgeu	a5,a4,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b7a:	000bb503          	ld	a0,0(s7)
ffffffffc0202b7e:	fff80737          	lui	a4,0xfff80
ffffffffc0202b82:	97ba                	add	a5,a5,a4
ffffffffc0202b84:	079a                	slli	a5,a5,0x6
ffffffffc0202b86:	953e                	add	a0,a0,a5
ffffffffc0202b88:	100027f3          	csrr	a5,sstatus
ffffffffc0202b8c:	8b89                	andi	a5,a5,2
ffffffffc0202b8e:	18079d63          	bnez	a5,ffffffffc0202d28 <pmm_init+0x6de>
ffffffffc0202b92:	000b3783          	ld	a5,0(s6)
ffffffffc0202b96:	4585                	li	a1,1
ffffffffc0202b98:	739c                	ld	a5,32(a5)
ffffffffc0202b9a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b9c:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202ba0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ba2:	078a                	slli	a5,a5,0x2
ffffffffc0202ba4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ba6:	20e7f563          	bgeu	a5,a4,ffffffffc0202db0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202baa:	000bb503          	ld	a0,0(s7)
ffffffffc0202bae:	fff80737          	lui	a4,0xfff80
ffffffffc0202bb2:	97ba                	add	a5,a5,a4
ffffffffc0202bb4:	079a                	slli	a5,a5,0x6
ffffffffc0202bb6:	953e                	add	a0,a0,a5
ffffffffc0202bb8:	100027f3          	csrr	a5,sstatus
ffffffffc0202bbc:	8b89                	andi	a5,a5,2
ffffffffc0202bbe:	14079963          	bnez	a5,ffffffffc0202d10 <pmm_init+0x6c6>
ffffffffc0202bc2:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc6:	4585                	li	a1,1
ffffffffc0202bc8:	739c                	ld	a5,32(a5)
ffffffffc0202bca:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202bcc:	00093783          	ld	a5,0(s2)
ffffffffc0202bd0:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202bd4:	12000073          	sfence.vma
ffffffffc0202bd8:	100027f3          	csrr	a5,sstatus
ffffffffc0202bdc:	8b89                	andi	a5,a5,2
ffffffffc0202bde:	10079f63          	bnez	a5,ffffffffc0202cfc <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202be2:	000b3783          	ld	a5,0(s6)
ffffffffc0202be6:	779c                	ld	a5,40(a5)
ffffffffc0202be8:	9782                	jalr	a5
ffffffffc0202bea:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202bec:	4c8c1e63          	bne	s8,s0,ffffffffc02030c8 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202bf0:	00004517          	auipc	a0,0x4
ffffffffc0202bf4:	16050513          	addi	a0,a0,352 # ffffffffc0206d50 <default_pmm_manager+0x720>
ffffffffc0202bf8:	da0fd0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0202bfc:	7406                	ld	s0,96(sp)
ffffffffc0202bfe:	70a6                	ld	ra,104(sp)
ffffffffc0202c00:	64e6                	ld	s1,88(sp)
ffffffffc0202c02:	6946                	ld	s2,80(sp)
ffffffffc0202c04:	69a6                	ld	s3,72(sp)
ffffffffc0202c06:	6a06                	ld	s4,64(sp)
ffffffffc0202c08:	7ae2                	ld	s5,56(sp)
ffffffffc0202c0a:	7b42                	ld	s6,48(sp)
ffffffffc0202c0c:	7ba2                	ld	s7,40(sp)
ffffffffc0202c0e:	7c02                	ld	s8,32(sp)
ffffffffc0202c10:	6ce2                	ld	s9,24(sp)
ffffffffc0202c12:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202c14:	f97fe06f          	j	ffffffffc0201baa <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202c18:	c80007b7          	lui	a5,0xc8000
ffffffffc0202c1c:	bc7d                	j	ffffffffc02026da <pmm_init+0x90>
        intr_disable();
ffffffffc0202c1e:	d91fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c22:	000b3783          	ld	a5,0(s6)
ffffffffc0202c26:	4505                	li	a0,1
ffffffffc0202c28:	6f9c                	ld	a5,24(a5)
ffffffffc0202c2a:	9782                	jalr	a5
ffffffffc0202c2c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c2e:	d7bfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c32:	b9a9                	j	ffffffffc020288c <pmm_init+0x242>
        intr_disable();
ffffffffc0202c34:	d7bfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202c38:	000b3783          	ld	a5,0(s6)
ffffffffc0202c3c:	4505                	li	a0,1
ffffffffc0202c3e:	6f9c                	ld	a5,24(a5)
ffffffffc0202c40:	9782                	jalr	a5
ffffffffc0202c42:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c44:	d65fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c48:	b645                	j	ffffffffc02027e8 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202c4a:	d65fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c52:	779c                	ld	a5,40(a5)
ffffffffc0202c54:	9782                	jalr	a5
ffffffffc0202c56:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c58:	d51fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202c5c:	b6b9                	j	ffffffffc02027aa <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202c5e:	6705                	lui	a4,0x1
ffffffffc0202c60:	177d                	addi	a4,a4,-1
ffffffffc0202c62:	96ba                	add	a3,a3,a4
ffffffffc0202c64:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202c66:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202c6a:	14a77363          	bgeu	a4,a0,ffffffffc0202db0 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202c6e:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202c72:	fff80537          	lui	a0,0xfff80
ffffffffc0202c76:	972a                	add	a4,a4,a0
ffffffffc0202c78:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202c7a:	8c1d                	sub	s0,s0,a5
ffffffffc0202c7c:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202c80:	00c45593          	srli	a1,s0,0xc
ffffffffc0202c84:	9532                	add	a0,a0,a2
ffffffffc0202c86:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202c88:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202c8c:	b4c1                	j	ffffffffc020274c <pmm_init+0x102>
        intr_disable();
ffffffffc0202c8e:	d21fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c92:	000b3783          	ld	a5,0(s6)
ffffffffc0202c96:	779c                	ld	a5,40(a5)
ffffffffc0202c98:	9782                	jalr	a5
ffffffffc0202c9a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c9c:	d0dfd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ca0:	bb79                	j	ffffffffc0202a3e <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202ca2:	d0dfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202ca6:	000b3783          	ld	a5,0(s6)
ffffffffc0202caa:	779c                	ld	a5,40(a5)
ffffffffc0202cac:	9782                	jalr	a5
ffffffffc0202cae:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202cb0:	cf9fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cb4:	b39d                	j	ffffffffc0202a1a <pmm_init+0x3d0>
ffffffffc0202cb6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cb8:	cf7fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202cbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202cc0:	6522                	ld	a0,8(sp)
ffffffffc0202cc2:	4585                	li	a1,1
ffffffffc0202cc4:	739c                	ld	a5,32(a5)
ffffffffc0202cc6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cc8:	ce1fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ccc:	b33d                	j	ffffffffc02029fa <pmm_init+0x3b0>
ffffffffc0202cce:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cd0:	cdffd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202cd4:	000b3783          	ld	a5,0(s6)
ffffffffc0202cd8:	6522                	ld	a0,8(sp)
ffffffffc0202cda:	4585                	li	a1,1
ffffffffc0202cdc:	739c                	ld	a5,32(a5)
ffffffffc0202cde:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ce0:	cc9fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202ce4:	b1dd                	j	ffffffffc02029ca <pmm_init+0x380>
        intr_disable();
ffffffffc0202ce6:	cc9fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202cea:	000b3783          	ld	a5,0(s6)
ffffffffc0202cee:	4505                	li	a0,1
ffffffffc0202cf0:	6f9c                	ld	a5,24(a5)
ffffffffc0202cf2:	9782                	jalr	a5
ffffffffc0202cf4:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202cf6:	cb3fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202cfa:	b36d                	j	ffffffffc0202aa4 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202cfc:	cb3fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d00:	000b3783          	ld	a5,0(s6)
ffffffffc0202d04:	779c                	ld	a5,40(a5)
ffffffffc0202d06:	9782                	jalr	a5
ffffffffc0202d08:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d0a:	c9ffd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d0e:	bdf9                	j	ffffffffc0202bec <pmm_init+0x5a2>
ffffffffc0202d10:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d12:	c9dfd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d16:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1a:	6522                	ld	a0,8(sp)
ffffffffc0202d1c:	4585                	li	a1,1
ffffffffc0202d1e:	739c                	ld	a5,32(a5)
ffffffffc0202d20:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d22:	c87fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d26:	b55d                	j	ffffffffc0202bcc <pmm_init+0x582>
ffffffffc0202d28:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202d2a:	c85fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d32:	6522                	ld	a0,8(sp)
ffffffffc0202d34:	4585                	li	a1,1
ffffffffc0202d36:	739c                	ld	a5,32(a5)
ffffffffc0202d38:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d3a:	c6ffd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d3e:	bdb9                	j	ffffffffc0202b9c <pmm_init+0x552>
        intr_disable();
ffffffffc0202d40:	c6ffd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0202d44:	000b3783          	ld	a5,0(s6)
ffffffffc0202d48:	4585                	li	a1,1
ffffffffc0202d4a:	8552                	mv	a0,s4
ffffffffc0202d4c:	739c                	ld	a5,32(a5)
ffffffffc0202d4e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d50:	c59fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0202d54:	bd29                	j	ffffffffc0202b6e <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d56:	86a2                	mv	a3,s0
ffffffffc0202d58:	00004617          	auipc	a2,0x4
ffffffffc0202d5c:	91060613          	addi	a2,a2,-1776 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202d60:	25200593          	li	a1,594
ffffffffc0202d64:	00004517          	auipc	a0,0x4
ffffffffc0202d68:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202d6c:	f26fd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202d70:	00004697          	auipc	a3,0x4
ffffffffc0202d74:	e8068693          	addi	a3,a3,-384 # ffffffffc0206bf0 <default_pmm_manager+0x5c0>
ffffffffc0202d78:	00003617          	auipc	a2,0x3
ffffffffc0202d7c:	50860613          	addi	a2,a2,1288 # ffffffffc0206280 <commands+0x828>
ffffffffc0202d80:	25300593          	li	a1,595
ffffffffc0202d84:	00004517          	auipc	a0,0x4
ffffffffc0202d88:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202d8c:	f06fd0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d90:	00004697          	auipc	a3,0x4
ffffffffc0202d94:	e2068693          	addi	a3,a3,-480 # ffffffffc0206bb0 <default_pmm_manager+0x580>
ffffffffc0202d98:	00003617          	auipc	a2,0x3
ffffffffc0202d9c:	4e860613          	addi	a2,a2,1256 # ffffffffc0206280 <commands+0x828>
ffffffffc0202da0:	25200593          	li	a1,594
ffffffffc0202da4:	00004517          	auipc	a0,0x4
ffffffffc0202da8:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202dac:	ee6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0202db0:	fc5fe0ef          	jal	ra,ffffffffc0201d74 <pa2page.part.0>
ffffffffc0202db4:	fddfe0ef          	jal	ra,ffffffffc0201d90 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202db8:	00004697          	auipc	a3,0x4
ffffffffc0202dbc:	bf068693          	addi	a3,a3,-1040 # ffffffffc02069a8 <default_pmm_manager+0x378>
ffffffffc0202dc0:	00003617          	auipc	a2,0x3
ffffffffc0202dc4:	4c060613          	addi	a2,a2,1216 # ffffffffc0206280 <commands+0x828>
ffffffffc0202dc8:	22200593          	li	a1,546
ffffffffc0202dcc:	00004517          	auipc	a0,0x4
ffffffffc0202dd0:	9b450513          	addi	a0,a0,-1612 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202dd4:	ebefd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202dd8:	00004697          	auipc	a3,0x4
ffffffffc0202ddc:	b1068693          	addi	a3,a3,-1264 # ffffffffc02068e8 <default_pmm_manager+0x2b8>
ffffffffc0202de0:	00003617          	auipc	a2,0x3
ffffffffc0202de4:	4a060613          	addi	a2,a2,1184 # ffffffffc0206280 <commands+0x828>
ffffffffc0202de8:	21500593          	li	a1,533
ffffffffc0202dec:	00004517          	auipc	a0,0x4
ffffffffc0202df0:	99450513          	addi	a0,a0,-1644 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202df4:	e9efd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202df8:	00004697          	auipc	a3,0x4
ffffffffc0202dfc:	ab068693          	addi	a3,a3,-1360 # ffffffffc02068a8 <default_pmm_manager+0x278>
ffffffffc0202e00:	00003617          	auipc	a2,0x3
ffffffffc0202e04:	48060613          	addi	a2,a2,1152 # ffffffffc0206280 <commands+0x828>
ffffffffc0202e08:	21400593          	li	a1,532
ffffffffc0202e0c:	00004517          	auipc	a0,0x4
ffffffffc0202e10:	97450513          	addi	a0,a0,-1676 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202e14:	e7efd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202e18:	00004697          	auipc	a3,0x4
ffffffffc0202e1c:	a7068693          	addi	a3,a3,-1424 # ffffffffc0206888 <default_pmm_manager+0x258>
ffffffffc0202e20:	00003617          	auipc	a2,0x3
ffffffffc0202e24:	46060613          	addi	a2,a2,1120 # ffffffffc0206280 <commands+0x828>
ffffffffc0202e28:	21300593          	li	a1,531
ffffffffc0202e2c:	00004517          	auipc	a0,0x4
ffffffffc0202e30:	95450513          	addi	a0,a0,-1708 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202e34:	e5efd0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202e38:	00004617          	auipc	a2,0x4
ffffffffc0202e3c:	83060613          	addi	a2,a2,-2000 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0202e40:	07100593          	li	a1,113
ffffffffc0202e44:	00004517          	auipc	a0,0x4
ffffffffc0202e48:	84c50513          	addi	a0,a0,-1972 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0202e4c:	e46fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202e50:	00004697          	auipc	a3,0x4
ffffffffc0202e54:	ce868693          	addi	a3,a3,-792 # ffffffffc0206b38 <default_pmm_manager+0x508>
ffffffffc0202e58:	00003617          	auipc	a2,0x3
ffffffffc0202e5c:	42860613          	addi	a2,a2,1064 # ffffffffc0206280 <commands+0x828>
ffffffffc0202e60:	23b00593          	li	a1,571
ffffffffc0202e64:	00004517          	auipc	a0,0x4
ffffffffc0202e68:	91c50513          	addi	a0,a0,-1764 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202e6c:	e26fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202e70:	00004697          	auipc	a3,0x4
ffffffffc0202e74:	c8068693          	addi	a3,a3,-896 # ffffffffc0206af0 <default_pmm_manager+0x4c0>
ffffffffc0202e78:	00003617          	auipc	a2,0x3
ffffffffc0202e7c:	40860613          	addi	a2,a2,1032 # ffffffffc0206280 <commands+0x828>
ffffffffc0202e80:	23900593          	li	a1,569
ffffffffc0202e84:	00004517          	auipc	a0,0x4
ffffffffc0202e88:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202e8c:	e06fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202e90:	00004697          	auipc	a3,0x4
ffffffffc0202e94:	c9068693          	addi	a3,a3,-880 # ffffffffc0206b20 <default_pmm_manager+0x4f0>
ffffffffc0202e98:	00003617          	auipc	a2,0x3
ffffffffc0202e9c:	3e860613          	addi	a2,a2,1000 # ffffffffc0206280 <commands+0x828>
ffffffffc0202ea0:	23800593          	li	a1,568
ffffffffc0202ea4:	00004517          	auipc	a0,0x4
ffffffffc0202ea8:	8dc50513          	addi	a0,a0,-1828 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202eac:	de6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202eb0:	00004697          	auipc	a3,0x4
ffffffffc0202eb4:	d5868693          	addi	a3,a3,-680 # ffffffffc0206c08 <default_pmm_manager+0x5d8>
ffffffffc0202eb8:	00003617          	auipc	a2,0x3
ffffffffc0202ebc:	3c860613          	addi	a2,a2,968 # ffffffffc0206280 <commands+0x828>
ffffffffc0202ec0:	25600593          	li	a1,598
ffffffffc0202ec4:	00004517          	auipc	a0,0x4
ffffffffc0202ec8:	8bc50513          	addi	a0,a0,-1860 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202ecc:	dc6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202ed0:	00004697          	auipc	a3,0x4
ffffffffc0202ed4:	c9868693          	addi	a3,a3,-872 # ffffffffc0206b68 <default_pmm_manager+0x538>
ffffffffc0202ed8:	00003617          	auipc	a2,0x3
ffffffffc0202edc:	3a860613          	addi	a2,a2,936 # ffffffffc0206280 <commands+0x828>
ffffffffc0202ee0:	24300593          	li	a1,579
ffffffffc0202ee4:	00004517          	auipc	a0,0x4
ffffffffc0202ee8:	89c50513          	addi	a0,a0,-1892 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202eec:	da6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202ef0:	00004697          	auipc	a3,0x4
ffffffffc0202ef4:	d7068693          	addi	a3,a3,-656 # ffffffffc0206c60 <default_pmm_manager+0x630>
ffffffffc0202ef8:	00003617          	auipc	a2,0x3
ffffffffc0202efc:	38860613          	addi	a2,a2,904 # ffffffffc0206280 <commands+0x828>
ffffffffc0202f00:	25b00593          	li	a1,603
ffffffffc0202f04:	00004517          	auipc	a0,0x4
ffffffffc0202f08:	87c50513          	addi	a0,a0,-1924 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202f0c:	d86fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202f10:	00004697          	auipc	a3,0x4
ffffffffc0202f14:	d1068693          	addi	a3,a3,-752 # ffffffffc0206c20 <default_pmm_manager+0x5f0>
ffffffffc0202f18:	00003617          	auipc	a2,0x3
ffffffffc0202f1c:	36860613          	addi	a2,a2,872 # ffffffffc0206280 <commands+0x828>
ffffffffc0202f20:	25a00593          	li	a1,602
ffffffffc0202f24:	00004517          	auipc	a0,0x4
ffffffffc0202f28:	85c50513          	addi	a0,a0,-1956 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202f2c:	d66fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f30:	00004697          	auipc	a3,0x4
ffffffffc0202f34:	bc068693          	addi	a3,a3,-1088 # ffffffffc0206af0 <default_pmm_manager+0x4c0>
ffffffffc0202f38:	00003617          	auipc	a2,0x3
ffffffffc0202f3c:	34860613          	addi	a2,a2,840 # ffffffffc0206280 <commands+0x828>
ffffffffc0202f40:	23500593          	li	a1,565
ffffffffc0202f44:	00004517          	auipc	a0,0x4
ffffffffc0202f48:	83c50513          	addi	a0,a0,-1988 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202f4c:	d46fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202f50:	00004697          	auipc	a3,0x4
ffffffffc0202f54:	a4068693          	addi	a3,a3,-1472 # ffffffffc0206990 <default_pmm_manager+0x360>
ffffffffc0202f58:	00003617          	auipc	a2,0x3
ffffffffc0202f5c:	32860613          	addi	a2,a2,808 # ffffffffc0206280 <commands+0x828>
ffffffffc0202f60:	23400593          	li	a1,564
ffffffffc0202f64:	00004517          	auipc	a0,0x4
ffffffffc0202f68:	81c50513          	addi	a0,a0,-2020 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202f6c:	d26fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202f70:	00004697          	auipc	a3,0x4
ffffffffc0202f74:	b9868693          	addi	a3,a3,-1128 # ffffffffc0206b08 <default_pmm_manager+0x4d8>
ffffffffc0202f78:	00003617          	auipc	a2,0x3
ffffffffc0202f7c:	30860613          	addi	a2,a2,776 # ffffffffc0206280 <commands+0x828>
ffffffffc0202f80:	23100593          	li	a1,561
ffffffffc0202f84:	00003517          	auipc	a0,0x3
ffffffffc0202f88:	7fc50513          	addi	a0,a0,2044 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202f8c:	d06fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202f90:	00004697          	auipc	a3,0x4
ffffffffc0202f94:	9e868693          	addi	a3,a3,-1560 # ffffffffc0206978 <default_pmm_manager+0x348>
ffffffffc0202f98:	00003617          	auipc	a2,0x3
ffffffffc0202f9c:	2e860613          	addi	a2,a2,744 # ffffffffc0206280 <commands+0x828>
ffffffffc0202fa0:	23000593          	li	a1,560
ffffffffc0202fa4:	00003517          	auipc	a0,0x3
ffffffffc0202fa8:	7dc50513          	addi	a0,a0,2012 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202fac:	ce6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202fb0:	00004697          	auipc	a3,0x4
ffffffffc0202fb4:	a6868693          	addi	a3,a3,-1432 # ffffffffc0206a18 <default_pmm_manager+0x3e8>
ffffffffc0202fb8:	00003617          	auipc	a2,0x3
ffffffffc0202fbc:	2c860613          	addi	a2,a2,712 # ffffffffc0206280 <commands+0x828>
ffffffffc0202fc0:	22f00593          	li	a1,559
ffffffffc0202fc4:	00003517          	auipc	a0,0x3
ffffffffc0202fc8:	7bc50513          	addi	a0,a0,1980 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202fcc:	cc6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202fd0:	00004697          	auipc	a3,0x4
ffffffffc0202fd4:	b2068693          	addi	a3,a3,-1248 # ffffffffc0206af0 <default_pmm_manager+0x4c0>
ffffffffc0202fd8:	00003617          	auipc	a2,0x3
ffffffffc0202fdc:	2a860613          	addi	a2,a2,680 # ffffffffc0206280 <commands+0x828>
ffffffffc0202fe0:	22e00593          	li	a1,558
ffffffffc0202fe4:	00003517          	auipc	a0,0x3
ffffffffc0202fe8:	79c50513          	addi	a0,a0,1948 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0202fec:	ca6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202ff0:	00004697          	auipc	a3,0x4
ffffffffc0202ff4:	ae868693          	addi	a3,a3,-1304 # ffffffffc0206ad8 <default_pmm_manager+0x4a8>
ffffffffc0202ff8:	00003617          	auipc	a2,0x3
ffffffffc0202ffc:	28860613          	addi	a2,a2,648 # ffffffffc0206280 <commands+0x828>
ffffffffc0203000:	22d00593          	li	a1,557
ffffffffc0203004:	00003517          	auipc	a0,0x3
ffffffffc0203008:	77c50513          	addi	a0,a0,1916 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020300c:	c86fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203010:	00004697          	auipc	a3,0x4
ffffffffc0203014:	a9868693          	addi	a3,a3,-1384 # ffffffffc0206aa8 <default_pmm_manager+0x478>
ffffffffc0203018:	00003617          	auipc	a2,0x3
ffffffffc020301c:	26860613          	addi	a2,a2,616 # ffffffffc0206280 <commands+0x828>
ffffffffc0203020:	22c00593          	li	a1,556
ffffffffc0203024:	00003517          	auipc	a0,0x3
ffffffffc0203028:	75c50513          	addi	a0,a0,1884 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020302c:	c66fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203030:	00004697          	auipc	a3,0x4
ffffffffc0203034:	a6068693          	addi	a3,a3,-1440 # ffffffffc0206a90 <default_pmm_manager+0x460>
ffffffffc0203038:	00003617          	auipc	a2,0x3
ffffffffc020303c:	24860613          	addi	a2,a2,584 # ffffffffc0206280 <commands+0x828>
ffffffffc0203040:	22a00593          	li	a1,554
ffffffffc0203044:	00003517          	auipc	a0,0x3
ffffffffc0203048:	73c50513          	addi	a0,a0,1852 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020304c:	c46fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203050:	00004697          	auipc	a3,0x4
ffffffffc0203054:	a2068693          	addi	a3,a3,-1504 # ffffffffc0206a70 <default_pmm_manager+0x440>
ffffffffc0203058:	00003617          	auipc	a2,0x3
ffffffffc020305c:	22860613          	addi	a2,a2,552 # ffffffffc0206280 <commands+0x828>
ffffffffc0203060:	22900593          	li	a1,553
ffffffffc0203064:	00003517          	auipc	a0,0x3
ffffffffc0203068:	71c50513          	addi	a0,a0,1820 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020306c:	c26fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203070:	00004697          	auipc	a3,0x4
ffffffffc0203074:	9f068693          	addi	a3,a3,-1552 # ffffffffc0206a60 <default_pmm_manager+0x430>
ffffffffc0203078:	00003617          	auipc	a2,0x3
ffffffffc020307c:	20860613          	addi	a2,a2,520 # ffffffffc0206280 <commands+0x828>
ffffffffc0203080:	22800593          	li	a1,552
ffffffffc0203084:	00003517          	auipc	a0,0x3
ffffffffc0203088:	6fc50513          	addi	a0,a0,1788 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020308c:	c06fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203090:	00004697          	auipc	a3,0x4
ffffffffc0203094:	9c068693          	addi	a3,a3,-1600 # ffffffffc0206a50 <default_pmm_manager+0x420>
ffffffffc0203098:	00003617          	auipc	a2,0x3
ffffffffc020309c:	1e860613          	addi	a2,a2,488 # ffffffffc0206280 <commands+0x828>
ffffffffc02030a0:	22700593          	li	a1,551
ffffffffc02030a4:	00003517          	auipc	a0,0x3
ffffffffc02030a8:	6dc50513          	addi	a0,a0,1756 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02030ac:	be6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("DTB memory info not available");
ffffffffc02030b0:	00003617          	auipc	a2,0x3
ffffffffc02030b4:	74060613          	addi	a2,a2,1856 # ffffffffc02067f0 <default_pmm_manager+0x1c0>
ffffffffc02030b8:	06500593          	li	a1,101
ffffffffc02030bc:	00003517          	auipc	a0,0x3
ffffffffc02030c0:	6c450513          	addi	a0,a0,1732 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02030c4:	bcefd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02030c8:	00004697          	auipc	a3,0x4
ffffffffc02030cc:	aa068693          	addi	a3,a3,-1376 # ffffffffc0206b68 <default_pmm_manager+0x538>
ffffffffc02030d0:	00003617          	auipc	a2,0x3
ffffffffc02030d4:	1b060613          	addi	a2,a2,432 # ffffffffc0206280 <commands+0x828>
ffffffffc02030d8:	26d00593          	li	a1,621
ffffffffc02030dc:	00003517          	auipc	a0,0x3
ffffffffc02030e0:	6a450513          	addi	a0,a0,1700 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02030e4:	baefd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030e8:	00004697          	auipc	a3,0x4
ffffffffc02030ec:	93068693          	addi	a3,a3,-1744 # ffffffffc0206a18 <default_pmm_manager+0x3e8>
ffffffffc02030f0:	00003617          	auipc	a2,0x3
ffffffffc02030f4:	19060613          	addi	a2,a2,400 # ffffffffc0206280 <commands+0x828>
ffffffffc02030f8:	22600593          	li	a1,550
ffffffffc02030fc:	00003517          	auipc	a0,0x3
ffffffffc0203100:	68450513          	addi	a0,a0,1668 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203104:	b8efd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203108:	00004697          	auipc	a3,0x4
ffffffffc020310c:	8d068693          	addi	a3,a3,-1840 # ffffffffc02069d8 <default_pmm_manager+0x3a8>
ffffffffc0203110:	00003617          	auipc	a2,0x3
ffffffffc0203114:	17060613          	addi	a2,a2,368 # ffffffffc0206280 <commands+0x828>
ffffffffc0203118:	22500593          	li	a1,549
ffffffffc020311c:	00003517          	auipc	a0,0x3
ffffffffc0203120:	66450513          	addi	a0,a0,1636 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203124:	b6efd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203128:	86d6                	mv	a3,s5
ffffffffc020312a:	00003617          	auipc	a2,0x3
ffffffffc020312e:	53e60613          	addi	a2,a2,1342 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0203132:	22100593          	li	a1,545
ffffffffc0203136:	00003517          	auipc	a0,0x3
ffffffffc020313a:	64a50513          	addi	a0,a0,1610 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020313e:	b54fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203142:	00003617          	auipc	a2,0x3
ffffffffc0203146:	52660613          	addi	a2,a2,1318 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc020314a:	22000593          	li	a1,544
ffffffffc020314e:	00003517          	auipc	a0,0x3
ffffffffc0203152:	63250513          	addi	a0,a0,1586 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203156:	b3cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020315a:	00004697          	auipc	a3,0x4
ffffffffc020315e:	83668693          	addi	a3,a3,-1994 # ffffffffc0206990 <default_pmm_manager+0x360>
ffffffffc0203162:	00003617          	auipc	a2,0x3
ffffffffc0203166:	11e60613          	addi	a2,a2,286 # ffffffffc0206280 <commands+0x828>
ffffffffc020316a:	21e00593          	li	a1,542
ffffffffc020316e:	00003517          	auipc	a0,0x3
ffffffffc0203172:	61250513          	addi	a0,a0,1554 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203176:	b1cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020317a:	00003697          	auipc	a3,0x3
ffffffffc020317e:	7fe68693          	addi	a3,a3,2046 # ffffffffc0206978 <default_pmm_manager+0x348>
ffffffffc0203182:	00003617          	auipc	a2,0x3
ffffffffc0203186:	0fe60613          	addi	a2,a2,254 # ffffffffc0206280 <commands+0x828>
ffffffffc020318a:	21d00593          	li	a1,541
ffffffffc020318e:	00003517          	auipc	a0,0x3
ffffffffc0203192:	5f250513          	addi	a0,a0,1522 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203196:	afcfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc020319a:	00004697          	auipc	a3,0x4
ffffffffc020319e:	b8e68693          	addi	a3,a3,-1138 # ffffffffc0206d28 <default_pmm_manager+0x6f8>
ffffffffc02031a2:	00003617          	auipc	a2,0x3
ffffffffc02031a6:	0de60613          	addi	a2,a2,222 # ffffffffc0206280 <commands+0x828>
ffffffffc02031aa:	26400593          	li	a1,612
ffffffffc02031ae:	00003517          	auipc	a0,0x3
ffffffffc02031b2:	5d250513          	addi	a0,a0,1490 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02031b6:	adcfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02031ba:	00004697          	auipc	a3,0x4
ffffffffc02031be:	b3668693          	addi	a3,a3,-1226 # ffffffffc0206cf0 <default_pmm_manager+0x6c0>
ffffffffc02031c2:	00003617          	auipc	a2,0x3
ffffffffc02031c6:	0be60613          	addi	a2,a2,190 # ffffffffc0206280 <commands+0x828>
ffffffffc02031ca:	26100593          	li	a1,609
ffffffffc02031ce:	00003517          	auipc	a0,0x3
ffffffffc02031d2:	5b250513          	addi	a0,a0,1458 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02031d6:	abcfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02031da:	00004697          	auipc	a3,0x4
ffffffffc02031de:	ae668693          	addi	a3,a3,-1306 # ffffffffc0206cc0 <default_pmm_manager+0x690>
ffffffffc02031e2:	00003617          	auipc	a2,0x3
ffffffffc02031e6:	09e60613          	addi	a2,a2,158 # ffffffffc0206280 <commands+0x828>
ffffffffc02031ea:	25d00593          	li	a1,605
ffffffffc02031ee:	00003517          	auipc	a0,0x3
ffffffffc02031f2:	59250513          	addi	a0,a0,1426 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02031f6:	a9cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02031fa:	00004697          	auipc	a3,0x4
ffffffffc02031fe:	a7e68693          	addi	a3,a3,-1410 # ffffffffc0206c78 <default_pmm_manager+0x648>
ffffffffc0203202:	00003617          	auipc	a2,0x3
ffffffffc0203206:	07e60613          	addi	a2,a2,126 # ffffffffc0206280 <commands+0x828>
ffffffffc020320a:	25c00593          	li	a1,604
ffffffffc020320e:	00003517          	auipc	a0,0x3
ffffffffc0203212:	57250513          	addi	a0,a0,1394 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203216:	a7cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020321a:	00003617          	auipc	a2,0x3
ffffffffc020321e:	4f660613          	addi	a2,a2,1270 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc0203222:	0c900593          	li	a1,201
ffffffffc0203226:	00003517          	auipc	a0,0x3
ffffffffc020322a:	55a50513          	addi	a0,a0,1370 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc020322e:	a64fd0ef          	jal	ra,ffffffffc0200492 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203232:	00003617          	auipc	a2,0x3
ffffffffc0203236:	4de60613          	addi	a2,a2,1246 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc020323a:	08100593          	li	a1,129
ffffffffc020323e:	00003517          	auipc	a0,0x3
ffffffffc0203242:	54250513          	addi	a0,a0,1346 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203246:	a4cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020324a:	00003697          	auipc	a3,0x3
ffffffffc020324e:	6fe68693          	addi	a3,a3,1790 # ffffffffc0206948 <default_pmm_manager+0x318>
ffffffffc0203252:	00003617          	auipc	a2,0x3
ffffffffc0203256:	02e60613          	addi	a2,a2,46 # ffffffffc0206280 <commands+0x828>
ffffffffc020325a:	21c00593          	li	a1,540
ffffffffc020325e:	00003517          	auipc	a0,0x3
ffffffffc0203262:	52250513          	addi	a0,a0,1314 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203266:	a2cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020326a:	00003697          	auipc	a3,0x3
ffffffffc020326e:	6ae68693          	addi	a3,a3,1710 # ffffffffc0206918 <default_pmm_manager+0x2e8>
ffffffffc0203272:	00003617          	auipc	a2,0x3
ffffffffc0203276:	00e60613          	addi	a2,a2,14 # ffffffffc0206280 <commands+0x828>
ffffffffc020327a:	21900593          	li	a1,537
ffffffffc020327e:	00003517          	auipc	a0,0x3
ffffffffc0203282:	50250513          	addi	a0,a0,1282 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203286:	a0cfd0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020328a <copy_range>:
{
ffffffffc020328a:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020328c:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203290:	f486                	sd	ra,104(sp)
ffffffffc0203292:	f0a2                	sd	s0,96(sp)
ffffffffc0203294:	eca6                	sd	s1,88(sp)
ffffffffc0203296:	e8ca                	sd	s2,80(sp)
ffffffffc0203298:	e4ce                	sd	s3,72(sp)
ffffffffc020329a:	e0d2                	sd	s4,64(sp)
ffffffffc020329c:	fc56                	sd	s5,56(sp)
ffffffffc020329e:	f85a                	sd	s6,48(sp)
ffffffffc02032a0:	f45e                	sd	s7,40(sp)
ffffffffc02032a2:	f062                	sd	s8,32(sp)
ffffffffc02032a4:	ec66                	sd	s9,24(sp)
ffffffffc02032a6:	e86a                	sd	s10,16(sp)
ffffffffc02032a8:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02032aa:	17d2                	slli	a5,a5,0x34
ffffffffc02032ac:	20079f63          	bnez	a5,ffffffffc02034ca <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc02032b0:	002007b7          	lui	a5,0x200
ffffffffc02032b4:	8432                	mv	s0,a2
ffffffffc02032b6:	1af66263          	bltu	a2,a5,ffffffffc020345a <copy_range+0x1d0>
ffffffffc02032ba:	8936                	mv	s2,a3
ffffffffc02032bc:	18d67f63          	bgeu	a2,a3,ffffffffc020345a <copy_range+0x1d0>
ffffffffc02032c0:	4785                	li	a5,1
ffffffffc02032c2:	07fe                	slli	a5,a5,0x1f
ffffffffc02032c4:	18d7eb63          	bltu	a5,a3,ffffffffc020345a <copy_range+0x1d0>
ffffffffc02032c8:	5b7d                	li	s6,-1
ffffffffc02032ca:	8aaa                	mv	s5,a0
ffffffffc02032cc:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02032ce:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02032d0:	000f8c17          	auipc	s8,0xf8
ffffffffc02032d4:	be0c0c13          	addi	s8,s8,-1056 # ffffffffc02faeb0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02032d8:	000f8b97          	auipc	s7,0xf8
ffffffffc02032dc:	be0b8b93          	addi	s7,s7,-1056 # ffffffffc02faeb8 <pages>
    return KADDR(page2pa(page));
ffffffffc02032e0:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02032e4:	000f8c97          	auipc	s9,0xf8
ffffffffc02032e8:	bdcc8c93          	addi	s9,s9,-1060 # ffffffffc02faec0 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02032ec:	4601                	li	a2,0
ffffffffc02032ee:	85a2                	mv	a1,s0
ffffffffc02032f0:	854e                	mv	a0,s3
ffffffffc02032f2:	b73fe0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc02032f6:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02032f8:	0e050c63          	beqz	a0,ffffffffc02033f0 <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02032fc:	611c                	ld	a5,0(a0)
ffffffffc02032fe:	8b85                	andi	a5,a5,1
ffffffffc0203300:	e785                	bnez	a5,ffffffffc0203328 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc0203302:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203304:	ff2464e3          	bltu	s0,s2,ffffffffc02032ec <copy_range+0x62>
    return 0;
ffffffffc0203308:	4501                	li	a0,0
}
ffffffffc020330a:	70a6                	ld	ra,104(sp)
ffffffffc020330c:	7406                	ld	s0,96(sp)
ffffffffc020330e:	64e6                	ld	s1,88(sp)
ffffffffc0203310:	6946                	ld	s2,80(sp)
ffffffffc0203312:	69a6                	ld	s3,72(sp)
ffffffffc0203314:	6a06                	ld	s4,64(sp)
ffffffffc0203316:	7ae2                	ld	s5,56(sp)
ffffffffc0203318:	7b42                	ld	s6,48(sp)
ffffffffc020331a:	7ba2                	ld	s7,40(sp)
ffffffffc020331c:	7c02                	ld	s8,32(sp)
ffffffffc020331e:	6ce2                	ld	s9,24(sp)
ffffffffc0203320:	6d42                	ld	s10,16(sp)
ffffffffc0203322:	6da2                	ld	s11,8(sp)
ffffffffc0203324:	6165                	addi	sp,sp,112
ffffffffc0203326:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203328:	4605                	li	a2,1
ffffffffc020332a:	85a2                	mv	a1,s0
ffffffffc020332c:	8556                	mv	a0,s5
ffffffffc020332e:	b37fe0ef          	jal	ra,ffffffffc0201e64 <get_pte>
ffffffffc0203332:	c56d                	beqz	a0,ffffffffc020341c <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203334:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203336:	0017f713          	andi	a4,a5,1
ffffffffc020333a:	01f7f493          	andi	s1,a5,31
ffffffffc020333e:	16070a63          	beqz	a4,ffffffffc02034b2 <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0203342:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203346:	078a                	slli	a5,a5,0x2
ffffffffc0203348:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020334c:	14d77763          	bgeu	a4,a3,ffffffffc020349a <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203350:	000bb783          	ld	a5,0(s7)
ffffffffc0203354:	fff806b7          	lui	a3,0xfff80
ffffffffc0203358:	9736                	add	a4,a4,a3
ffffffffc020335a:	071a                	slli	a4,a4,0x6
ffffffffc020335c:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203360:	10002773          	csrr	a4,sstatus
ffffffffc0203364:	8b09                	andi	a4,a4,2
ffffffffc0203366:	e345                	bnez	a4,ffffffffc0203406 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203368:	000cb703          	ld	a4,0(s9)
ffffffffc020336c:	4505                	li	a0,1
ffffffffc020336e:	6f18                	ld	a4,24(a4)
ffffffffc0203370:	9702                	jalr	a4
ffffffffc0203372:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203374:	0c0d8363          	beqz	s11,ffffffffc020343a <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203378:	100d0163          	beqz	s10,ffffffffc020347a <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc020337c:	000bb703          	ld	a4,0(s7)
ffffffffc0203380:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203384:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203388:	40ed86b3          	sub	a3,s11,a4
ffffffffc020338c:	8699                	srai	a3,a3,0x6
ffffffffc020338e:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203390:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203394:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203396:	08c7f663          	bgeu	a5,a2,ffffffffc0203422 <copy_range+0x198>
    return page - pages + nbase;
ffffffffc020339a:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc020339e:	000f8717          	auipc	a4,0xf8
ffffffffc02033a2:	b2a70713          	addi	a4,a4,-1238 # ffffffffc02faec8 <va_pa_offset>
ffffffffc02033a6:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc02033a8:	8799                	srai	a5,a5,0x6
ffffffffc02033aa:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc02033ac:	0167f733          	and	a4,a5,s6
ffffffffc02033b0:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02033b4:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02033b6:	06c77563          	bgeu	a4,a2,ffffffffc0203420 <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02033ba:	6605                	lui	a2,0x1
ffffffffc02033bc:	953e                	add	a0,a0,a5
ffffffffc02033be:	416020ef          	jal	ra,ffffffffc02057d4 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc02033c2:	86a6                	mv	a3,s1
ffffffffc02033c4:	8622                	mv	a2,s0
ffffffffc02033c6:	85ea                	mv	a1,s10
ffffffffc02033c8:	8556                	mv	a0,s5
ffffffffc02033ca:	98aff0ef          	jal	ra,ffffffffc0202554 <page_insert>
            assert(ret == 0);
ffffffffc02033ce:	d915                	beqz	a0,ffffffffc0203302 <copy_range+0x78>
ffffffffc02033d0:	00004697          	auipc	a3,0x4
ffffffffc02033d4:	9c068693          	addi	a3,a3,-1600 # ffffffffc0206d90 <default_pmm_manager+0x760>
ffffffffc02033d8:	00003617          	auipc	a2,0x3
ffffffffc02033dc:	ea860613          	addi	a2,a2,-344 # ffffffffc0206280 <commands+0x828>
ffffffffc02033e0:	1b100593          	li	a1,433
ffffffffc02033e4:	00003517          	auipc	a0,0x3
ffffffffc02033e8:	39c50513          	addi	a0,a0,924 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02033ec:	8a6fd0ef          	jal	ra,ffffffffc0200492 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02033f0:	00200637          	lui	a2,0x200
ffffffffc02033f4:	9432                	add	s0,s0,a2
ffffffffc02033f6:	ffe00637          	lui	a2,0xffe00
ffffffffc02033fa:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02033fc:	f00406e3          	beqz	s0,ffffffffc0203308 <copy_range+0x7e>
ffffffffc0203400:	ef2466e3          	bltu	s0,s2,ffffffffc02032ec <copy_range+0x62>
ffffffffc0203404:	b711                	j	ffffffffc0203308 <copy_range+0x7e>
        intr_disable();
ffffffffc0203406:	da8fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020340a:	000cb703          	ld	a4,0(s9)
ffffffffc020340e:	4505                	li	a0,1
ffffffffc0203410:	6f18                	ld	a4,24(a4)
ffffffffc0203412:	9702                	jalr	a4
ffffffffc0203414:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203416:	d92fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020341a:	bfa9                	j	ffffffffc0203374 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc020341c:	5571                	li	a0,-4
ffffffffc020341e:	b5f5                	j	ffffffffc020330a <copy_range+0x80>
ffffffffc0203420:	86be                	mv	a3,a5
ffffffffc0203422:	00003617          	auipc	a2,0x3
ffffffffc0203426:	24660613          	addi	a2,a2,582 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc020342a:	07100593          	li	a1,113
ffffffffc020342e:	00003517          	auipc	a0,0x3
ffffffffc0203432:	26250513          	addi	a0,a0,610 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0203436:	85cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
            assert(page != NULL);
ffffffffc020343a:	00004697          	auipc	a3,0x4
ffffffffc020343e:	93668693          	addi	a3,a3,-1738 # ffffffffc0206d70 <default_pmm_manager+0x740>
ffffffffc0203442:	00003617          	auipc	a2,0x3
ffffffffc0203446:	e3e60613          	addi	a2,a2,-450 # ffffffffc0206280 <commands+0x828>
ffffffffc020344a:	19600593          	li	a1,406
ffffffffc020344e:	00003517          	auipc	a0,0x3
ffffffffc0203452:	33250513          	addi	a0,a0,818 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203456:	83cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020345a:	00003697          	auipc	a3,0x3
ffffffffc020345e:	36668693          	addi	a3,a3,870 # ffffffffc02067c0 <default_pmm_manager+0x190>
ffffffffc0203462:	00003617          	auipc	a2,0x3
ffffffffc0203466:	e1e60613          	addi	a2,a2,-482 # ffffffffc0206280 <commands+0x828>
ffffffffc020346a:	17e00593          	li	a1,382
ffffffffc020346e:	00003517          	auipc	a0,0x3
ffffffffc0203472:	31250513          	addi	a0,a0,786 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203476:	81cfd0ef          	jal	ra,ffffffffc0200492 <__panic>
            assert(npage != NULL);
ffffffffc020347a:	00004697          	auipc	a3,0x4
ffffffffc020347e:	90668693          	addi	a3,a3,-1786 # ffffffffc0206d80 <default_pmm_manager+0x750>
ffffffffc0203482:	00003617          	auipc	a2,0x3
ffffffffc0203486:	dfe60613          	addi	a2,a2,-514 # ffffffffc0206280 <commands+0x828>
ffffffffc020348a:	19700593          	li	a1,407
ffffffffc020348e:	00003517          	auipc	a0,0x3
ffffffffc0203492:	2f250513          	addi	a0,a0,754 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc0203496:	ffdfc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020349a:	00003617          	auipc	a2,0x3
ffffffffc020349e:	29e60613          	addi	a2,a2,670 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc02034a2:	06900593          	li	a1,105
ffffffffc02034a6:	00003517          	auipc	a0,0x3
ffffffffc02034aa:	1ea50513          	addi	a0,a0,490 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc02034ae:	fe5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02034b2:	00003617          	auipc	a2,0x3
ffffffffc02034b6:	2a660613          	addi	a2,a2,678 # ffffffffc0206758 <default_pmm_manager+0x128>
ffffffffc02034ba:	07f00593          	li	a1,127
ffffffffc02034be:	00003517          	auipc	a0,0x3
ffffffffc02034c2:	1d250513          	addi	a0,a0,466 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc02034c6:	fcdfc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02034ca:	00003697          	auipc	a3,0x3
ffffffffc02034ce:	2c668693          	addi	a3,a3,710 # ffffffffc0206790 <default_pmm_manager+0x160>
ffffffffc02034d2:	00003617          	auipc	a2,0x3
ffffffffc02034d6:	dae60613          	addi	a2,a2,-594 # ffffffffc0206280 <commands+0x828>
ffffffffc02034da:	17d00593          	li	a1,381
ffffffffc02034de:	00003517          	auipc	a0,0x3
ffffffffc02034e2:	2a250513          	addi	a0,a0,674 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02034e6:	fadfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02034ea <pgdir_alloc_page>:
{
ffffffffc02034ea:	7179                	addi	sp,sp,-48
ffffffffc02034ec:	ec26                	sd	s1,24(sp)
ffffffffc02034ee:	e84a                	sd	s2,16(sp)
ffffffffc02034f0:	e052                	sd	s4,0(sp)
ffffffffc02034f2:	f406                	sd	ra,40(sp)
ffffffffc02034f4:	f022                	sd	s0,32(sp)
ffffffffc02034f6:	e44e                	sd	s3,8(sp)
ffffffffc02034f8:	8a2a                	mv	s4,a0
ffffffffc02034fa:	84ae                	mv	s1,a1
ffffffffc02034fc:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02034fe:	100027f3          	csrr	a5,sstatus
ffffffffc0203502:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203504:	000f8997          	auipc	s3,0xf8
ffffffffc0203508:	9bc98993          	addi	s3,s3,-1604 # ffffffffc02faec0 <pmm_manager>
ffffffffc020350c:	ef8d                	bnez	a5,ffffffffc0203546 <pgdir_alloc_page+0x5c>
ffffffffc020350e:	0009b783          	ld	a5,0(s3)
ffffffffc0203512:	4505                	li	a0,1
ffffffffc0203514:	6f9c                	ld	a5,24(a5)
ffffffffc0203516:	9782                	jalr	a5
ffffffffc0203518:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc020351a:	cc09                	beqz	s0,ffffffffc0203534 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020351c:	86ca                	mv	a3,s2
ffffffffc020351e:	8626                	mv	a2,s1
ffffffffc0203520:	85a2                	mv	a1,s0
ffffffffc0203522:	8552                	mv	a0,s4
ffffffffc0203524:	830ff0ef          	jal	ra,ffffffffc0202554 <page_insert>
ffffffffc0203528:	e915                	bnez	a0,ffffffffc020355c <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc020352a:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc020352c:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020352e:	4785                	li	a5,1
ffffffffc0203530:	04f71e63          	bne	a4,a5,ffffffffc020358c <pgdir_alloc_page+0xa2>
}
ffffffffc0203534:	70a2                	ld	ra,40(sp)
ffffffffc0203536:	8522                	mv	a0,s0
ffffffffc0203538:	7402                	ld	s0,32(sp)
ffffffffc020353a:	64e2                	ld	s1,24(sp)
ffffffffc020353c:	6942                	ld	s2,16(sp)
ffffffffc020353e:	69a2                	ld	s3,8(sp)
ffffffffc0203540:	6a02                	ld	s4,0(sp)
ffffffffc0203542:	6145                	addi	sp,sp,48
ffffffffc0203544:	8082                	ret
        intr_disable();
ffffffffc0203546:	c68fd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020354a:	0009b783          	ld	a5,0(s3)
ffffffffc020354e:	4505                	li	a0,1
ffffffffc0203550:	6f9c                	ld	a5,24(a5)
ffffffffc0203552:	9782                	jalr	a5
ffffffffc0203554:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203556:	c52fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020355a:	b7c1                	j	ffffffffc020351a <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020355c:	100027f3          	csrr	a5,sstatus
ffffffffc0203560:	8b89                	andi	a5,a5,2
ffffffffc0203562:	eb89                	bnez	a5,ffffffffc0203574 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203564:	0009b783          	ld	a5,0(s3)
ffffffffc0203568:	8522                	mv	a0,s0
ffffffffc020356a:	4585                	li	a1,1
ffffffffc020356c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020356e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203570:	9782                	jalr	a5
    if (flag)
ffffffffc0203572:	b7c9                	j	ffffffffc0203534 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203574:	c3afd0ef          	jal	ra,ffffffffc02009ae <intr_disable>
ffffffffc0203578:	0009b783          	ld	a5,0(s3)
ffffffffc020357c:	8522                	mv	a0,s0
ffffffffc020357e:	4585                	li	a1,1
ffffffffc0203580:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203582:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203584:	9782                	jalr	a5
        intr_enable();
ffffffffc0203586:	c22fd0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020358a:	b76d                	j	ffffffffc0203534 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc020358c:	00004697          	auipc	a3,0x4
ffffffffc0203590:	81468693          	addi	a3,a3,-2028 # ffffffffc0206da0 <default_pmm_manager+0x770>
ffffffffc0203594:	00003617          	auipc	a2,0x3
ffffffffc0203598:	cec60613          	addi	a2,a2,-788 # ffffffffc0206280 <commands+0x828>
ffffffffc020359c:	1fa00593          	li	a1,506
ffffffffc02035a0:	00003517          	auipc	a0,0x3
ffffffffc02035a4:	1e050513          	addi	a0,a0,480 # ffffffffc0206780 <default_pmm_manager+0x150>
ffffffffc02035a8:	eebfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02035ac <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02035ac:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02035ae:	00004697          	auipc	a3,0x4
ffffffffc02035b2:	80a68693          	addi	a3,a3,-2038 # ffffffffc0206db8 <default_pmm_manager+0x788>
ffffffffc02035b6:	00003617          	auipc	a2,0x3
ffffffffc02035ba:	cca60613          	addi	a2,a2,-822 # ffffffffc0206280 <commands+0x828>
ffffffffc02035be:	07400593          	li	a1,116
ffffffffc02035c2:	00004517          	auipc	a0,0x4
ffffffffc02035c6:	81650513          	addi	a0,a0,-2026 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02035ca:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02035cc:	ec7fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02035d0 <mm_create>:
{
ffffffffc02035d0:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02035d2:	04000513          	li	a0,64
{
ffffffffc02035d6:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02035d8:	df6fe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
    if (mm != NULL)
ffffffffc02035dc:	cd19                	beqz	a0,ffffffffc02035fa <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02035de:	e508                	sd	a0,8(a0)
ffffffffc02035e0:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02035e2:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02035e6:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02035ea:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02035ee:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02035f2:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02035f6:	02053c23          	sd	zero,56(a0)
}
ffffffffc02035fa:	60a2                	ld	ra,8(sp)
ffffffffc02035fc:	0141                	addi	sp,sp,16
ffffffffc02035fe:	8082                	ret

ffffffffc0203600 <find_vma>:
{
ffffffffc0203600:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203602:	c505                	beqz	a0,ffffffffc020362a <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203604:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203606:	c501                	beqz	a0,ffffffffc020360e <find_vma+0xe>
ffffffffc0203608:	651c                	ld	a5,8(a0)
ffffffffc020360a:	02f5f263          	bgeu	a1,a5,ffffffffc020362e <find_vma+0x2e>
    return listelm->next;
ffffffffc020360e:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203610:	00f68d63          	beq	a3,a5,ffffffffc020362a <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203614:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_matrix_out_size+0x1f38d0>
ffffffffc0203618:	00e5e663          	bltu	a1,a4,ffffffffc0203624 <find_vma+0x24>
ffffffffc020361c:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203620:	00e5ec63          	bltu	a1,a4,ffffffffc0203638 <find_vma+0x38>
ffffffffc0203624:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203626:	fef697e3          	bne	a3,a5,ffffffffc0203614 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020362a:	4501                	li	a0,0
}
ffffffffc020362c:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020362e:	691c                	ld	a5,16(a0)
ffffffffc0203630:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020360e <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203634:	ea88                	sd	a0,16(a3)
ffffffffc0203636:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203638:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020363c:	ea88                	sd	a0,16(a3)
ffffffffc020363e:	8082                	ret

ffffffffc0203640 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203640:	6590                	ld	a2,8(a1)
ffffffffc0203642:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_matrix_out_size+0x738f8>
{
ffffffffc0203646:	1141                	addi	sp,sp,-16
ffffffffc0203648:	e406                	sd	ra,8(sp)
ffffffffc020364a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020364c:	01066763          	bltu	a2,a6,ffffffffc020365a <insert_vma_struct+0x1a>
ffffffffc0203650:	a085                	j	ffffffffc02036b0 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203652:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203656:	04e66863          	bltu	a2,a4,ffffffffc02036a6 <insert_vma_struct+0x66>
ffffffffc020365a:	86be                	mv	a3,a5
ffffffffc020365c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020365e:	fef51ae3          	bne	a0,a5,ffffffffc0203652 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203662:	02a68463          	beq	a3,a0,ffffffffc020368a <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203666:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020366a:	fe86b883          	ld	a7,-24(a3)
ffffffffc020366e:	08e8f163          	bgeu	a7,a4,ffffffffc02036f0 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203672:	04e66f63          	bltu	a2,a4,ffffffffc02036d0 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203676:	00f50a63          	beq	a0,a5,ffffffffc020368a <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020367a:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020367e:	05076963          	bltu	a4,a6,ffffffffc02036d0 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203682:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203686:	02c77363          	bgeu	a4,a2,ffffffffc02036ac <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020368a:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020368c:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc020368e:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203692:	e390                	sd	a2,0(a5)
ffffffffc0203694:	e690                	sd	a2,8(a3)
}
ffffffffc0203696:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203698:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020369a:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc020369c:	0017079b          	addiw	a5,a4,1
ffffffffc02036a0:	d11c                	sw	a5,32(a0)
}
ffffffffc02036a2:	0141                	addi	sp,sp,16
ffffffffc02036a4:	8082                	ret
    if (le_prev != list)
ffffffffc02036a6:	fca690e3          	bne	a3,a0,ffffffffc0203666 <insert_vma_struct+0x26>
ffffffffc02036aa:	bfd1                	j	ffffffffc020367e <insert_vma_struct+0x3e>
ffffffffc02036ac:	f01ff0ef          	jal	ra,ffffffffc02035ac <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02036b0:	00003697          	auipc	a3,0x3
ffffffffc02036b4:	73868693          	addi	a3,a3,1848 # ffffffffc0206de8 <default_pmm_manager+0x7b8>
ffffffffc02036b8:	00003617          	auipc	a2,0x3
ffffffffc02036bc:	bc860613          	addi	a2,a2,-1080 # ffffffffc0206280 <commands+0x828>
ffffffffc02036c0:	07a00593          	li	a1,122
ffffffffc02036c4:	00003517          	auipc	a0,0x3
ffffffffc02036c8:	71450513          	addi	a0,a0,1812 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc02036cc:	dc7fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02036d0:	00003697          	auipc	a3,0x3
ffffffffc02036d4:	75868693          	addi	a3,a3,1880 # ffffffffc0206e28 <default_pmm_manager+0x7f8>
ffffffffc02036d8:	00003617          	auipc	a2,0x3
ffffffffc02036dc:	ba860613          	addi	a2,a2,-1112 # ffffffffc0206280 <commands+0x828>
ffffffffc02036e0:	07300593          	li	a1,115
ffffffffc02036e4:	00003517          	auipc	a0,0x3
ffffffffc02036e8:	6f450513          	addi	a0,a0,1780 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc02036ec:	da7fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02036f0:	00003697          	auipc	a3,0x3
ffffffffc02036f4:	71868693          	addi	a3,a3,1816 # ffffffffc0206e08 <default_pmm_manager+0x7d8>
ffffffffc02036f8:	00003617          	auipc	a2,0x3
ffffffffc02036fc:	b8860613          	addi	a2,a2,-1144 # ffffffffc0206280 <commands+0x828>
ffffffffc0203700:	07200593          	li	a1,114
ffffffffc0203704:	00003517          	auipc	a0,0x3
ffffffffc0203708:	6d450513          	addi	a0,a0,1748 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc020370c:	d87fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203710 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203710:	591c                	lw	a5,48(a0)
{
ffffffffc0203712:	1141                	addi	sp,sp,-16
ffffffffc0203714:	e406                	sd	ra,8(sp)
ffffffffc0203716:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203718:	e78d                	bnez	a5,ffffffffc0203742 <mm_destroy+0x32>
ffffffffc020371a:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020371c:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020371e:	00a40c63          	beq	s0,a0,ffffffffc0203736 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203722:	6118                	ld	a4,0(a0)
ffffffffc0203724:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203726:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203728:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020372a:	e398                	sd	a4,0(a5)
ffffffffc020372c:	d52fe0ef          	jal	ra,ffffffffc0201c7e <kfree>
    return listelm->next;
ffffffffc0203730:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203732:	fea418e3          	bne	s0,a0,ffffffffc0203722 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203736:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203738:	6402                	ld	s0,0(sp)
ffffffffc020373a:	60a2                	ld	ra,8(sp)
ffffffffc020373c:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020373e:	d40fe06f          	j	ffffffffc0201c7e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203742:	00003697          	auipc	a3,0x3
ffffffffc0203746:	70668693          	addi	a3,a3,1798 # ffffffffc0206e48 <default_pmm_manager+0x818>
ffffffffc020374a:	00003617          	auipc	a2,0x3
ffffffffc020374e:	b3660613          	addi	a2,a2,-1226 # ffffffffc0206280 <commands+0x828>
ffffffffc0203752:	09e00593          	li	a1,158
ffffffffc0203756:	00003517          	auipc	a0,0x3
ffffffffc020375a:	68250513          	addi	a0,a0,1666 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc020375e:	d35fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203762 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203762:	7139                	addi	sp,sp,-64
ffffffffc0203764:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203766:	6405                	lui	s0,0x1
ffffffffc0203768:	147d                	addi	s0,s0,-1
ffffffffc020376a:	77fd                	lui	a5,0xfffff
ffffffffc020376c:	9622                	add	a2,a2,s0
ffffffffc020376e:	962e                	add	a2,a2,a1
{
ffffffffc0203770:	f426                	sd	s1,40(sp)
ffffffffc0203772:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203774:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203778:	f04a                	sd	s2,32(sp)
ffffffffc020377a:	ec4e                	sd	s3,24(sp)
ffffffffc020377c:	e852                	sd	s4,16(sp)
ffffffffc020377e:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203780:	002005b7          	lui	a1,0x200
ffffffffc0203784:	00f67433          	and	s0,a2,a5
ffffffffc0203788:	06b4e363          	bltu	s1,a1,ffffffffc02037ee <mm_map+0x8c>
ffffffffc020378c:	0684f163          	bgeu	s1,s0,ffffffffc02037ee <mm_map+0x8c>
ffffffffc0203790:	4785                	li	a5,1
ffffffffc0203792:	07fe                	slli	a5,a5,0x1f
ffffffffc0203794:	0487ed63          	bltu	a5,s0,ffffffffc02037ee <mm_map+0x8c>
ffffffffc0203798:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc020379a:	cd21                	beqz	a0,ffffffffc02037f2 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc020379c:	85a6                	mv	a1,s1
ffffffffc020379e:	8ab6                	mv	s5,a3
ffffffffc02037a0:	8a3a                	mv	s4,a4
ffffffffc02037a2:	e5fff0ef          	jal	ra,ffffffffc0203600 <find_vma>
ffffffffc02037a6:	c501                	beqz	a0,ffffffffc02037ae <mm_map+0x4c>
ffffffffc02037a8:	651c                	ld	a5,8(a0)
ffffffffc02037aa:	0487e263          	bltu	a5,s0,ffffffffc02037ee <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02037ae:	03000513          	li	a0,48
ffffffffc02037b2:	c1cfe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
ffffffffc02037b6:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02037b8:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02037ba:	02090163          	beqz	s2,ffffffffc02037dc <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02037be:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02037c0:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02037c4:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02037c8:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02037cc:	85ca                	mv	a1,s2
ffffffffc02037ce:	e73ff0ef          	jal	ra,ffffffffc0203640 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02037d2:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02037d4:	000a0463          	beqz	s4,ffffffffc02037dc <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02037d8:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f48>

out:
    return ret;
}
ffffffffc02037dc:	70e2                	ld	ra,56(sp)
ffffffffc02037de:	7442                	ld	s0,48(sp)
ffffffffc02037e0:	74a2                	ld	s1,40(sp)
ffffffffc02037e2:	7902                	ld	s2,32(sp)
ffffffffc02037e4:	69e2                	ld	s3,24(sp)
ffffffffc02037e6:	6a42                	ld	s4,16(sp)
ffffffffc02037e8:	6aa2                	ld	s5,8(sp)
ffffffffc02037ea:	6121                	addi	sp,sp,64
ffffffffc02037ec:	8082                	ret
        return -E_INVAL;
ffffffffc02037ee:	5575                	li	a0,-3
ffffffffc02037f0:	b7f5                	j	ffffffffc02037dc <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02037f2:	00003697          	auipc	a3,0x3
ffffffffc02037f6:	66e68693          	addi	a3,a3,1646 # ffffffffc0206e60 <default_pmm_manager+0x830>
ffffffffc02037fa:	00003617          	auipc	a2,0x3
ffffffffc02037fe:	a8660613          	addi	a2,a2,-1402 # ffffffffc0206280 <commands+0x828>
ffffffffc0203802:	0b300593          	li	a1,179
ffffffffc0203806:	00003517          	auipc	a0,0x3
ffffffffc020380a:	5d250513          	addi	a0,a0,1490 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc020380e:	c85fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203812 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203812:	7139                	addi	sp,sp,-64
ffffffffc0203814:	fc06                	sd	ra,56(sp)
ffffffffc0203816:	f822                	sd	s0,48(sp)
ffffffffc0203818:	f426                	sd	s1,40(sp)
ffffffffc020381a:	f04a                	sd	s2,32(sp)
ffffffffc020381c:	ec4e                	sd	s3,24(sp)
ffffffffc020381e:	e852                	sd	s4,16(sp)
ffffffffc0203820:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203822:	c52d                	beqz	a0,ffffffffc020388c <dup_mmap+0x7a>
ffffffffc0203824:	892a                	mv	s2,a0
ffffffffc0203826:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203828:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc020382a:	e595                	bnez	a1,ffffffffc0203856 <dup_mmap+0x44>
ffffffffc020382c:	a085                	j	ffffffffc020388c <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020382e:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203830:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1f38f0>
        vma->vm_end = vm_end;
ffffffffc0203834:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203838:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc020383c:	e05ff0ef          	jal	ra,ffffffffc0203640 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203840:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8f58>
ffffffffc0203844:	fe843603          	ld	a2,-24(s0)
ffffffffc0203848:	6c8c                	ld	a1,24(s1)
ffffffffc020384a:	01893503          	ld	a0,24(s2)
ffffffffc020384e:	4701                	li	a4,0
ffffffffc0203850:	a3bff0ef          	jal	ra,ffffffffc020328a <copy_range>
ffffffffc0203854:	e105                	bnez	a0,ffffffffc0203874 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203856:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203858:	02848863          	beq	s1,s0,ffffffffc0203888 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020385c:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203860:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203864:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203868:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020386c:	b62fe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
ffffffffc0203870:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203872:	fd55                	bnez	a0,ffffffffc020382e <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203874:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203876:	70e2                	ld	ra,56(sp)
ffffffffc0203878:	7442                	ld	s0,48(sp)
ffffffffc020387a:	74a2                	ld	s1,40(sp)
ffffffffc020387c:	7902                	ld	s2,32(sp)
ffffffffc020387e:	69e2                	ld	s3,24(sp)
ffffffffc0203880:	6a42                	ld	s4,16(sp)
ffffffffc0203882:	6aa2                	ld	s5,8(sp)
ffffffffc0203884:	6121                	addi	sp,sp,64
ffffffffc0203886:	8082                	ret
    return 0;
ffffffffc0203888:	4501                	li	a0,0
ffffffffc020388a:	b7f5                	j	ffffffffc0203876 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc020388c:	00003697          	auipc	a3,0x3
ffffffffc0203890:	5e468693          	addi	a3,a3,1508 # ffffffffc0206e70 <default_pmm_manager+0x840>
ffffffffc0203894:	00003617          	auipc	a2,0x3
ffffffffc0203898:	9ec60613          	addi	a2,a2,-1556 # ffffffffc0206280 <commands+0x828>
ffffffffc020389c:	0cf00593          	li	a1,207
ffffffffc02038a0:	00003517          	auipc	a0,0x3
ffffffffc02038a4:	53850513          	addi	a0,a0,1336 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc02038a8:	bebfc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02038ac <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02038ac:	1101                	addi	sp,sp,-32
ffffffffc02038ae:	ec06                	sd	ra,24(sp)
ffffffffc02038b0:	e822                	sd	s0,16(sp)
ffffffffc02038b2:	e426                	sd	s1,8(sp)
ffffffffc02038b4:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02038b6:	c531                	beqz	a0,ffffffffc0203902 <exit_mmap+0x56>
ffffffffc02038b8:	591c                	lw	a5,48(a0)
ffffffffc02038ba:	84aa                	mv	s1,a0
ffffffffc02038bc:	e3b9                	bnez	a5,ffffffffc0203902 <exit_mmap+0x56>
    return listelm->next;
ffffffffc02038be:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02038c0:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02038c4:	02850663          	beq	a0,s0,ffffffffc02038f0 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038c8:	ff043603          	ld	a2,-16(s0)
ffffffffc02038cc:	fe843583          	ld	a1,-24(s0)
ffffffffc02038d0:	854a                	mv	a0,s2
ffffffffc02038d2:	80ffe0ef          	jal	ra,ffffffffc02020e0 <unmap_range>
ffffffffc02038d6:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038d8:	fe8498e3          	bne	s1,s0,ffffffffc02038c8 <exit_mmap+0x1c>
ffffffffc02038dc:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02038de:	00848c63          	beq	s1,s0,ffffffffc02038f6 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02038e2:	ff043603          	ld	a2,-16(s0)
ffffffffc02038e6:	fe843583          	ld	a1,-24(s0)
ffffffffc02038ea:	854a                	mv	a0,s2
ffffffffc02038ec:	93bfe0ef          	jal	ra,ffffffffc0202226 <exit_range>
ffffffffc02038f0:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02038f2:	fe8498e3          	bne	s1,s0,ffffffffc02038e2 <exit_mmap+0x36>
    }
}
ffffffffc02038f6:	60e2                	ld	ra,24(sp)
ffffffffc02038f8:	6442                	ld	s0,16(sp)
ffffffffc02038fa:	64a2                	ld	s1,8(sp)
ffffffffc02038fc:	6902                	ld	s2,0(sp)
ffffffffc02038fe:	6105                	addi	sp,sp,32
ffffffffc0203900:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203902:	00003697          	auipc	a3,0x3
ffffffffc0203906:	58e68693          	addi	a3,a3,1422 # ffffffffc0206e90 <default_pmm_manager+0x860>
ffffffffc020390a:	00003617          	auipc	a2,0x3
ffffffffc020390e:	97660613          	addi	a2,a2,-1674 # ffffffffc0206280 <commands+0x828>
ffffffffc0203912:	0e800593          	li	a1,232
ffffffffc0203916:	00003517          	auipc	a0,0x3
ffffffffc020391a:	4c250513          	addi	a0,a0,1218 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc020391e:	b75fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203922 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203922:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203924:	04000513          	li	a0,64
{
ffffffffc0203928:	fc06                	sd	ra,56(sp)
ffffffffc020392a:	f822                	sd	s0,48(sp)
ffffffffc020392c:	f426                	sd	s1,40(sp)
ffffffffc020392e:	f04a                	sd	s2,32(sp)
ffffffffc0203930:	ec4e                	sd	s3,24(sp)
ffffffffc0203932:	e852                	sd	s4,16(sp)
ffffffffc0203934:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203936:	a98fe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
    if (mm != NULL)
ffffffffc020393a:	2e050663          	beqz	a0,ffffffffc0203c26 <vmm_init+0x304>
ffffffffc020393e:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203940:	e508                	sd	a0,8(a0)
ffffffffc0203942:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203944:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203948:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020394c:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203950:	02053423          	sd	zero,40(a0)
ffffffffc0203954:	02052823          	sw	zero,48(a0)
ffffffffc0203958:	02053c23          	sd	zero,56(a0)
ffffffffc020395c:	03200413          	li	s0,50
ffffffffc0203960:	a811                	j	ffffffffc0203974 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203962:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203964:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203966:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc020396a:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020396c:	8526                	mv	a0,s1
ffffffffc020396e:	cd3ff0ef          	jal	ra,ffffffffc0203640 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203972:	c80d                	beqz	s0,ffffffffc02039a4 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203974:	03000513          	li	a0,48
ffffffffc0203978:	a56fe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
ffffffffc020397c:	85aa                	mv	a1,a0
ffffffffc020397e:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203982:	f165                	bnez	a0,ffffffffc0203962 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203984:	00003697          	auipc	a3,0x3
ffffffffc0203988:	6a468693          	addi	a3,a3,1700 # ffffffffc0207028 <default_pmm_manager+0x9f8>
ffffffffc020398c:	00003617          	auipc	a2,0x3
ffffffffc0203990:	8f460613          	addi	a2,a2,-1804 # ffffffffc0206280 <commands+0x828>
ffffffffc0203994:	12c00593          	li	a1,300
ffffffffc0203998:	00003517          	auipc	a0,0x3
ffffffffc020399c:	44050513          	addi	a0,a0,1088 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc02039a0:	af3fc0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc02039a4:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039a8:	1f900913          	li	s2,505
ffffffffc02039ac:	a819                	j	ffffffffc02039c2 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc02039ae:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02039b0:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02039b2:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039b6:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02039b8:	8526                	mv	a0,s1
ffffffffc02039ba:	c87ff0ef          	jal	ra,ffffffffc0203640 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02039be:	03240a63          	beq	s0,s2,ffffffffc02039f2 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039c2:	03000513          	li	a0,48
ffffffffc02039c6:	a08fe0ef          	jal	ra,ffffffffc0201bce <kmalloc>
ffffffffc02039ca:	85aa                	mv	a1,a0
ffffffffc02039cc:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02039d0:	fd79                	bnez	a0,ffffffffc02039ae <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc02039d2:	00003697          	auipc	a3,0x3
ffffffffc02039d6:	65668693          	addi	a3,a3,1622 # ffffffffc0207028 <default_pmm_manager+0x9f8>
ffffffffc02039da:	00003617          	auipc	a2,0x3
ffffffffc02039de:	8a660613          	addi	a2,a2,-1882 # ffffffffc0206280 <commands+0x828>
ffffffffc02039e2:	13300593          	li	a1,307
ffffffffc02039e6:	00003517          	auipc	a0,0x3
ffffffffc02039ea:	3f250513          	addi	a0,a0,1010 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc02039ee:	aa5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return listelm->next;
ffffffffc02039f2:	649c                	ld	a5,8(s1)
ffffffffc02039f4:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc02039f6:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc02039fa:	16f48663          	beq	s1,a5,ffffffffc0203b66 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02039fe:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd040e8>
ffffffffc0203a02:	ffe70693          	addi	a3,a4,-2
ffffffffc0203a06:	10d61063          	bne	a2,a3,ffffffffc0203b06 <vmm_init+0x1e4>
ffffffffc0203a0a:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203a0e:	0ed71c63          	bne	a4,a3,ffffffffc0203b06 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203a12:	0715                	addi	a4,a4,5
ffffffffc0203a14:	679c                	ld	a5,8(a5)
ffffffffc0203a16:	feb712e3          	bne	a4,a1,ffffffffc02039fa <vmm_init+0xd8>
ffffffffc0203a1a:	4a1d                	li	s4,7
ffffffffc0203a1c:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a1e:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203a22:	85a2                	mv	a1,s0
ffffffffc0203a24:	8526                	mv	a0,s1
ffffffffc0203a26:	bdbff0ef          	jal	ra,ffffffffc0203600 <find_vma>
ffffffffc0203a2a:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203a2c:	16050d63          	beqz	a0,ffffffffc0203ba6 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203a30:	00140593          	addi	a1,s0,1
ffffffffc0203a34:	8526                	mv	a0,s1
ffffffffc0203a36:	bcbff0ef          	jal	ra,ffffffffc0203600 <find_vma>
ffffffffc0203a3a:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203a3c:	14050563          	beqz	a0,ffffffffc0203b86 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203a40:	85d2                	mv	a1,s4
ffffffffc0203a42:	8526                	mv	a0,s1
ffffffffc0203a44:	bbdff0ef          	jal	ra,ffffffffc0203600 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203a48:	16051f63          	bnez	a0,ffffffffc0203bc6 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203a4c:	00340593          	addi	a1,s0,3
ffffffffc0203a50:	8526                	mv	a0,s1
ffffffffc0203a52:	bafff0ef          	jal	ra,ffffffffc0203600 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203a56:	1a051863          	bnez	a0,ffffffffc0203c06 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203a5a:	00440593          	addi	a1,s0,4
ffffffffc0203a5e:	8526                	mv	a0,s1
ffffffffc0203a60:	ba1ff0ef          	jal	ra,ffffffffc0203600 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203a64:	18051163          	bnez	a0,ffffffffc0203be6 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203a68:	00893783          	ld	a5,8(s2)
ffffffffc0203a6c:	0a879d63          	bne	a5,s0,ffffffffc0203b26 <vmm_init+0x204>
ffffffffc0203a70:	01093783          	ld	a5,16(s2)
ffffffffc0203a74:	0b479963          	bne	a5,s4,ffffffffc0203b26 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203a78:	0089b783          	ld	a5,8(s3)
ffffffffc0203a7c:	0c879563          	bne	a5,s0,ffffffffc0203b46 <vmm_init+0x224>
ffffffffc0203a80:	0109b783          	ld	a5,16(s3)
ffffffffc0203a84:	0d479163          	bne	a5,s4,ffffffffc0203b46 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203a88:	0415                	addi	s0,s0,5
ffffffffc0203a8a:	0a15                	addi	s4,s4,5
ffffffffc0203a8c:	f9541be3          	bne	s0,s5,ffffffffc0203a22 <vmm_init+0x100>
ffffffffc0203a90:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203a92:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203a94:	85a2                	mv	a1,s0
ffffffffc0203a96:	8526                	mv	a0,s1
ffffffffc0203a98:	b69ff0ef          	jal	ra,ffffffffc0203600 <find_vma>
ffffffffc0203a9c:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203aa0:	c90d                	beqz	a0,ffffffffc0203ad2 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203aa2:	6914                	ld	a3,16(a0)
ffffffffc0203aa4:	6510                	ld	a2,8(a0)
ffffffffc0203aa6:	00003517          	auipc	a0,0x3
ffffffffc0203aaa:	50a50513          	addi	a0,a0,1290 # ffffffffc0206fb0 <default_pmm_manager+0x980>
ffffffffc0203aae:	eeafc0ef          	jal	ra,ffffffffc0200198 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203ab2:	00003697          	auipc	a3,0x3
ffffffffc0203ab6:	52668693          	addi	a3,a3,1318 # ffffffffc0206fd8 <default_pmm_manager+0x9a8>
ffffffffc0203aba:	00002617          	auipc	a2,0x2
ffffffffc0203abe:	7c660613          	addi	a2,a2,1990 # ffffffffc0206280 <commands+0x828>
ffffffffc0203ac2:	15900593          	li	a1,345
ffffffffc0203ac6:	00003517          	auipc	a0,0x3
ffffffffc0203aca:	31250513          	addi	a0,a0,786 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203ace:	9c5fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203ad2:	147d                	addi	s0,s0,-1
ffffffffc0203ad4:	fd2410e3          	bne	s0,s2,ffffffffc0203a94 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203ad8:	8526                	mv	a0,s1
ffffffffc0203ada:	c37ff0ef          	jal	ra,ffffffffc0203710 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203ade:	00003517          	auipc	a0,0x3
ffffffffc0203ae2:	51250513          	addi	a0,a0,1298 # ffffffffc0206ff0 <default_pmm_manager+0x9c0>
ffffffffc0203ae6:	eb2fc0ef          	jal	ra,ffffffffc0200198 <cprintf>
}
ffffffffc0203aea:	7442                	ld	s0,48(sp)
ffffffffc0203aec:	70e2                	ld	ra,56(sp)
ffffffffc0203aee:	74a2                	ld	s1,40(sp)
ffffffffc0203af0:	7902                	ld	s2,32(sp)
ffffffffc0203af2:	69e2                	ld	s3,24(sp)
ffffffffc0203af4:	6a42                	ld	s4,16(sp)
ffffffffc0203af6:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203af8:	00003517          	auipc	a0,0x3
ffffffffc0203afc:	51850513          	addi	a0,a0,1304 # ffffffffc0207010 <default_pmm_manager+0x9e0>
}
ffffffffc0203b00:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203b02:	e96fc06f          	j	ffffffffc0200198 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b06:	00003697          	auipc	a3,0x3
ffffffffc0203b0a:	3c268693          	addi	a3,a3,962 # ffffffffc0206ec8 <default_pmm_manager+0x898>
ffffffffc0203b0e:	00002617          	auipc	a2,0x2
ffffffffc0203b12:	77260613          	addi	a2,a2,1906 # ffffffffc0206280 <commands+0x828>
ffffffffc0203b16:	13d00593          	li	a1,317
ffffffffc0203b1a:	00003517          	auipc	a0,0x3
ffffffffc0203b1e:	2be50513          	addi	a0,a0,702 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203b22:	971fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b26:	00003697          	auipc	a3,0x3
ffffffffc0203b2a:	42a68693          	addi	a3,a3,1066 # ffffffffc0206f50 <default_pmm_manager+0x920>
ffffffffc0203b2e:	00002617          	auipc	a2,0x2
ffffffffc0203b32:	75260613          	addi	a2,a2,1874 # ffffffffc0206280 <commands+0x828>
ffffffffc0203b36:	14e00593          	li	a1,334
ffffffffc0203b3a:	00003517          	auipc	a0,0x3
ffffffffc0203b3e:	29e50513          	addi	a0,a0,670 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203b42:	951fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b46:	00003697          	auipc	a3,0x3
ffffffffc0203b4a:	43a68693          	addi	a3,a3,1082 # ffffffffc0206f80 <default_pmm_manager+0x950>
ffffffffc0203b4e:	00002617          	auipc	a2,0x2
ffffffffc0203b52:	73260613          	addi	a2,a2,1842 # ffffffffc0206280 <commands+0x828>
ffffffffc0203b56:	14f00593          	li	a1,335
ffffffffc0203b5a:	00003517          	auipc	a0,0x3
ffffffffc0203b5e:	27e50513          	addi	a0,a0,638 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203b62:	931fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203b66:	00003697          	auipc	a3,0x3
ffffffffc0203b6a:	34a68693          	addi	a3,a3,842 # ffffffffc0206eb0 <default_pmm_manager+0x880>
ffffffffc0203b6e:	00002617          	auipc	a2,0x2
ffffffffc0203b72:	71260613          	addi	a2,a2,1810 # ffffffffc0206280 <commands+0x828>
ffffffffc0203b76:	13b00593          	li	a1,315
ffffffffc0203b7a:	00003517          	auipc	a0,0x3
ffffffffc0203b7e:	25e50513          	addi	a0,a0,606 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203b82:	911fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma2 != NULL);
ffffffffc0203b86:	00003697          	auipc	a3,0x3
ffffffffc0203b8a:	38a68693          	addi	a3,a3,906 # ffffffffc0206f10 <default_pmm_manager+0x8e0>
ffffffffc0203b8e:	00002617          	auipc	a2,0x2
ffffffffc0203b92:	6f260613          	addi	a2,a2,1778 # ffffffffc0206280 <commands+0x828>
ffffffffc0203b96:	14600593          	li	a1,326
ffffffffc0203b9a:	00003517          	auipc	a0,0x3
ffffffffc0203b9e:	23e50513          	addi	a0,a0,574 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203ba2:	8f1fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma1 != NULL);
ffffffffc0203ba6:	00003697          	auipc	a3,0x3
ffffffffc0203baa:	35a68693          	addi	a3,a3,858 # ffffffffc0206f00 <default_pmm_manager+0x8d0>
ffffffffc0203bae:	00002617          	auipc	a2,0x2
ffffffffc0203bb2:	6d260613          	addi	a2,a2,1746 # ffffffffc0206280 <commands+0x828>
ffffffffc0203bb6:	14400593          	li	a1,324
ffffffffc0203bba:	00003517          	auipc	a0,0x3
ffffffffc0203bbe:	21e50513          	addi	a0,a0,542 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203bc2:	8d1fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma3 == NULL);
ffffffffc0203bc6:	00003697          	auipc	a3,0x3
ffffffffc0203bca:	35a68693          	addi	a3,a3,858 # ffffffffc0206f20 <default_pmm_manager+0x8f0>
ffffffffc0203bce:	00002617          	auipc	a2,0x2
ffffffffc0203bd2:	6b260613          	addi	a2,a2,1714 # ffffffffc0206280 <commands+0x828>
ffffffffc0203bd6:	14800593          	li	a1,328
ffffffffc0203bda:	00003517          	auipc	a0,0x3
ffffffffc0203bde:	1fe50513          	addi	a0,a0,510 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203be2:	8b1fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma5 == NULL);
ffffffffc0203be6:	00003697          	auipc	a3,0x3
ffffffffc0203bea:	35a68693          	addi	a3,a3,858 # ffffffffc0206f40 <default_pmm_manager+0x910>
ffffffffc0203bee:	00002617          	auipc	a2,0x2
ffffffffc0203bf2:	69260613          	addi	a2,a2,1682 # ffffffffc0206280 <commands+0x828>
ffffffffc0203bf6:	14c00593          	li	a1,332
ffffffffc0203bfa:	00003517          	auipc	a0,0x3
ffffffffc0203bfe:	1de50513          	addi	a0,a0,478 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203c02:	891fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        assert(vma4 == NULL);
ffffffffc0203c06:	00003697          	auipc	a3,0x3
ffffffffc0203c0a:	32a68693          	addi	a3,a3,810 # ffffffffc0206f30 <default_pmm_manager+0x900>
ffffffffc0203c0e:	00002617          	auipc	a2,0x2
ffffffffc0203c12:	67260613          	addi	a2,a2,1650 # ffffffffc0206280 <commands+0x828>
ffffffffc0203c16:	14a00593          	li	a1,330
ffffffffc0203c1a:	00003517          	auipc	a0,0x3
ffffffffc0203c1e:	1be50513          	addi	a0,a0,446 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203c22:	871fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(mm != NULL);
ffffffffc0203c26:	00003697          	auipc	a3,0x3
ffffffffc0203c2a:	23a68693          	addi	a3,a3,570 # ffffffffc0206e60 <default_pmm_manager+0x830>
ffffffffc0203c2e:	00002617          	auipc	a2,0x2
ffffffffc0203c32:	65260613          	addi	a2,a2,1618 # ffffffffc0206280 <commands+0x828>
ffffffffc0203c36:	12400593          	li	a1,292
ffffffffc0203c3a:	00003517          	auipc	a0,0x3
ffffffffc0203c3e:	19e50513          	addi	a0,a0,414 # ffffffffc0206dd8 <default_pmm_manager+0x7a8>
ffffffffc0203c42:	851fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203c46 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203c46:	7179                	addi	sp,sp,-48
ffffffffc0203c48:	f022                	sd	s0,32(sp)
ffffffffc0203c4a:	f406                	sd	ra,40(sp)
ffffffffc0203c4c:	ec26                	sd	s1,24(sp)
ffffffffc0203c4e:	e84a                	sd	s2,16(sp)
ffffffffc0203c50:	e44e                	sd	s3,8(sp)
ffffffffc0203c52:	e052                	sd	s4,0(sp)
ffffffffc0203c54:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203c56:	c135                	beqz	a0,ffffffffc0203cba <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203c58:	002007b7          	lui	a5,0x200
ffffffffc0203c5c:	04f5e663          	bltu	a1,a5,ffffffffc0203ca8 <user_mem_check+0x62>
ffffffffc0203c60:	00c584b3          	add	s1,a1,a2
ffffffffc0203c64:	0495f263          	bgeu	a1,s1,ffffffffc0203ca8 <user_mem_check+0x62>
ffffffffc0203c68:	4785                	li	a5,1
ffffffffc0203c6a:	07fe                	slli	a5,a5,0x1f
ffffffffc0203c6c:	0297ee63          	bltu	a5,s1,ffffffffc0203ca8 <user_mem_check+0x62>
ffffffffc0203c70:	892a                	mv	s2,a0
ffffffffc0203c72:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c74:	6a05                	lui	s4,0x1
ffffffffc0203c76:	a821                	j	ffffffffc0203c8e <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c78:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c7c:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c7e:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c80:	c685                	beqz	a3,ffffffffc0203ca8 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203c82:	c399                	beqz	a5,ffffffffc0203c88 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203c84:	02e46263          	bltu	s0,a4,ffffffffc0203ca8 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203c88:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203c8a:	04947663          	bgeu	s0,s1,ffffffffc0203cd6 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203c8e:	85a2                	mv	a1,s0
ffffffffc0203c90:	854a                	mv	a0,s2
ffffffffc0203c92:	96fff0ef          	jal	ra,ffffffffc0203600 <find_vma>
ffffffffc0203c96:	c909                	beqz	a0,ffffffffc0203ca8 <user_mem_check+0x62>
ffffffffc0203c98:	6518                	ld	a4,8(a0)
ffffffffc0203c9a:	00e46763          	bltu	s0,a4,ffffffffc0203ca8 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203c9e:	4d1c                	lw	a5,24(a0)
ffffffffc0203ca0:	fc099ce3          	bnez	s3,ffffffffc0203c78 <user_mem_check+0x32>
ffffffffc0203ca4:	8b85                	andi	a5,a5,1
ffffffffc0203ca6:	f3ed                	bnez	a5,ffffffffc0203c88 <user_mem_check+0x42>
            return 0;
ffffffffc0203ca8:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203caa:	70a2                	ld	ra,40(sp)
ffffffffc0203cac:	7402                	ld	s0,32(sp)
ffffffffc0203cae:	64e2                	ld	s1,24(sp)
ffffffffc0203cb0:	6942                	ld	s2,16(sp)
ffffffffc0203cb2:	69a2                	ld	s3,8(sp)
ffffffffc0203cb4:	6a02                	ld	s4,0(sp)
ffffffffc0203cb6:	6145                	addi	sp,sp,48
ffffffffc0203cb8:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203cba:	c02007b7          	lui	a5,0xc0200
ffffffffc0203cbe:	4501                	li	a0,0
ffffffffc0203cc0:	fef5e5e3          	bltu	a1,a5,ffffffffc0203caa <user_mem_check+0x64>
ffffffffc0203cc4:	962e                	add	a2,a2,a1
ffffffffc0203cc6:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203caa <user_mem_check+0x64>
ffffffffc0203cca:	c8000537          	lui	a0,0xc8000
ffffffffc0203cce:	0505                	addi	a0,a0,1
ffffffffc0203cd0:	00a63533          	sltu	a0,a2,a0
ffffffffc0203cd4:	bfd9                	j	ffffffffc0203caa <user_mem_check+0x64>
        return 1;
ffffffffc0203cd6:	4505                	li	a0,1
ffffffffc0203cd8:	bfc9                	j	ffffffffc0203caa <user_mem_check+0x64>

ffffffffc0203cda <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203cda:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203cdc:	9402                	jalr	s0

	jal do_exit
ffffffffc0203cde:	592000ef          	jal	ra,ffffffffc0204270 <do_exit>

ffffffffc0203ce2 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203ce2:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ce4:	14800513          	li	a0,328
{
ffffffffc0203ce8:	e022                	sd	s0,0(sp)
ffffffffc0203cea:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203cec:	ee3fd0ef          	jal	ra,ffffffffc0201bce <kmalloc>
ffffffffc0203cf0:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203cf2:	c941                	beqz	a0,ffffffffc0203d82 <alloc_proc+0xa0>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203cf4:	57fd                	li	a5,-1
ffffffffc0203cf6:	1782                	slli	a5,a5,0x20
ffffffffc0203cf8:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203cfa:	07000613          	li	a2,112
ffffffffc0203cfe:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203d00:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d05108>
        proc->kstack = 0;
ffffffffc0203d04:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203d08:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203d0c:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203d10:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203d14:	03050513          	addi	a0,a0,48
ffffffffc0203d18:	2ab010ef          	jal	ra,ffffffffc02057c2 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203d1c:	000f7797          	auipc	a5,0xf7
ffffffffc0203d20:	1847b783          	ld	a5,388(a5) # ffffffffc02faea0 <boot_pgdir_pa>
ffffffffc0203d24:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203d26:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203d2a:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203d2e:	4641                	li	a2,16
ffffffffc0203d30:	4581                	li	a1,0
ffffffffc0203d32:	0b440513          	addi	a0,s0,180
ffffffffc0203d36:	28d010ef          	jal	ra,ffffffffc02057c2 <memset>
         *       skew_heap_entry_t lab6_run_pool;            // entry in the run pool (lab6 stride)
         *       uint32_t lab6_stride;                       // stride value (lab6 stride)
         *       uint32_t lab6_priority;                     // priority value (lab6 stride)
         */
        proc->rq = NULL;
        list_init(&proc->run_link);
ffffffffc0203d3a:	11040793          	addi	a5,s0,272
    elm->prev = elm->next = elm;
ffffffffc0203d3e:	10f43c23          	sd	a5,280(s0)
ffffffffc0203d42:	10f43823          	sd	a5,272(s0)
        proc->time_slice = 0;
        skew_heap_init(&proc->lab6_run_pool);
        proc->lab6_stride = 0;
ffffffffc0203d46:	4785                	li	a5,1
        list_init(&(proc->list_link));
ffffffffc0203d48:	0c840693          	addi	a3,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203d4c:	0d840713          	addi	a4,s0,216
        proc->lab6_stride = 0;
ffffffffc0203d50:	1782                	slli	a5,a5,0x20
ffffffffc0203d52:	e874                	sd	a3,208(s0)
ffffffffc0203d54:	e474                	sd	a3,200(s0)
ffffffffc0203d56:	f078                	sd	a4,224(s0)
ffffffffc0203d58:	ec78                	sd	a4,216(s0)
        proc->wait_state = 0;
ffffffffc0203d5a:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0203d5e:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;
ffffffffc0203d62:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;
ffffffffc0203d66:	10043023          	sd	zero,256(s0)
        proc->rq = NULL;
ffffffffc0203d6a:	10043423          	sd	zero,264(s0)
        proc->time_slice = 0;
ffffffffc0203d6e:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc0203d72:	12043423          	sd	zero,296(s0)
ffffffffc0203d76:	12043823          	sd	zero,304(s0)
ffffffffc0203d7a:	12043c23          	sd	zero,312(s0)
        proc->lab6_stride = 0;
ffffffffc0203d7e:	14f43023          	sd	a5,320(s0)
        proc->lab6_priority = 1; /* default priority */
    }
    return proc;
}
ffffffffc0203d82:	60a2                	ld	ra,8(sp)
ffffffffc0203d84:	8522                	mv	a0,s0
ffffffffc0203d86:	6402                	ld	s0,0(sp)
ffffffffc0203d88:	0141                	addi	sp,sp,16
ffffffffc0203d8a:	8082                	ret

ffffffffc0203d8c <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203d8c:	000f7797          	auipc	a5,0xf7
ffffffffc0203d90:	1447b783          	ld	a5,324(a5) # ffffffffc02faed0 <current>
ffffffffc0203d94:	73c8                	ld	a0,160(a5)
ffffffffc0203d96:	954fd06f          	j	ffffffffc0200eea <forkrets>

ffffffffc0203d9a <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203d9a:	6d14                	ld	a3,24(a0)
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
{
ffffffffc0203d9c:	1141                	addi	sp,sp,-16
ffffffffc0203d9e:	e406                	sd	ra,8(sp)
ffffffffc0203da0:	c02007b7          	lui	a5,0xc0200
ffffffffc0203da4:	02f6ee63          	bltu	a3,a5,ffffffffc0203de0 <put_pgdir+0x46>
ffffffffc0203da8:	000f7517          	auipc	a0,0xf7
ffffffffc0203dac:	12053503          	ld	a0,288(a0) # ffffffffc02faec8 <va_pa_offset>
ffffffffc0203db0:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203db2:	82b1                	srli	a3,a3,0xc
ffffffffc0203db4:	000f7797          	auipc	a5,0xf7
ffffffffc0203db8:	0fc7b783          	ld	a5,252(a5) # ffffffffc02faeb0 <npage>
ffffffffc0203dbc:	02f6fe63          	bgeu	a3,a5,ffffffffc0203df8 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203dc0:	00004517          	auipc	a0,0x4
ffffffffc0203dc4:	32053503          	ld	a0,800(a0) # ffffffffc02080e0 <nbase>
    free_page(kva2page(mm->pgdir));
}
ffffffffc0203dc8:	60a2                	ld	ra,8(sp)
ffffffffc0203dca:	8e89                	sub	a3,a3,a0
ffffffffc0203dcc:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203dce:	000f7517          	auipc	a0,0xf7
ffffffffc0203dd2:	0ea53503          	ld	a0,234(a0) # ffffffffc02faeb8 <pages>
ffffffffc0203dd6:	4585                	li	a1,1
ffffffffc0203dd8:	9536                	add	a0,a0,a3
}
ffffffffc0203dda:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203ddc:	80efe06f          	j	ffffffffc0201dea <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203de0:	00003617          	auipc	a2,0x3
ffffffffc0203de4:	93060613          	addi	a2,a2,-1744 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc0203de8:	07700593          	li	a1,119
ffffffffc0203dec:	00003517          	auipc	a0,0x3
ffffffffc0203df0:	8a450513          	addi	a0,a0,-1884 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0203df4:	e9efc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203df8:	00003617          	auipc	a2,0x3
ffffffffc0203dfc:	94060613          	addi	a2,a2,-1728 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc0203e00:	06900593          	li	a1,105
ffffffffc0203e04:	00003517          	auipc	a0,0x3
ffffffffc0203e08:	88c50513          	addi	a0,a0,-1908 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0203e0c:	e86fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0203e10 <proc_run>:
{
ffffffffc0203e10:	7179                	addi	sp,sp,-48
ffffffffc0203e12:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203e14:	000f7497          	auipc	s1,0xf7
ffffffffc0203e18:	0bc48493          	addi	s1,s1,188 # ffffffffc02faed0 <current>
ffffffffc0203e1c:	6098                	ld	a4,0(s1)
{
ffffffffc0203e1e:	f406                	sd	ra,40(sp)
ffffffffc0203e20:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203e22:	02a70763          	beq	a4,a0,ffffffffc0203e50 <proc_run+0x40>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203e26:	100027f3          	csrr	a5,sstatus
ffffffffc0203e2a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203e2c:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203e2e:	ef85                	bnez	a5,ffffffffc0203e66 <proc_run+0x56>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203e30:	755c                	ld	a5,168(a0)
ffffffffc0203e32:	56fd                	li	a3,-1
ffffffffc0203e34:	16fe                	slli	a3,a3,0x3f
ffffffffc0203e36:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0203e38:	e088                	sd	a0,0(s1)
ffffffffc0203e3a:	8fd5                	or	a5,a5,a3
ffffffffc0203e3c:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203e40:	03050593          	addi	a1,a0,48
ffffffffc0203e44:	03070513          	addi	a0,a4,48
ffffffffc0203e48:	0c8010ef          	jal	ra,ffffffffc0204f10 <switch_to>
    if (flag)
ffffffffc0203e4c:	00091763          	bnez	s2,ffffffffc0203e5a <proc_run+0x4a>
}
ffffffffc0203e50:	70a2                	ld	ra,40(sp)
ffffffffc0203e52:	7482                	ld	s1,32(sp)
ffffffffc0203e54:	6962                	ld	s2,24(sp)
ffffffffc0203e56:	6145                	addi	sp,sp,48
ffffffffc0203e58:	8082                	ret
ffffffffc0203e5a:	70a2                	ld	ra,40(sp)
ffffffffc0203e5c:	7482                	ld	s1,32(sp)
ffffffffc0203e5e:	6962                	ld	s2,24(sp)
ffffffffc0203e60:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203e62:	b47fc06f          	j	ffffffffc02009a8 <intr_enable>
ffffffffc0203e66:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203e68:	b47fc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
            struct proc_struct *prev = current;
ffffffffc0203e6c:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0203e6e:	6522                	ld	a0,8(sp)
ffffffffc0203e70:	4905                	li	s2,1
ffffffffc0203e72:	bf7d                	j	ffffffffc0203e30 <proc_run+0x20>

ffffffffc0203e74 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc0203e74:	7119                	addi	sp,sp,-128
ffffffffc0203e76:	f0ca                	sd	s2,96(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0203e78:	000f7917          	auipc	s2,0xf7
ffffffffc0203e7c:	07090913          	addi	s2,s2,112 # ffffffffc02faee8 <nr_process>
ffffffffc0203e80:	00092703          	lw	a4,0(s2)
{
ffffffffc0203e84:	fc86                	sd	ra,120(sp)
ffffffffc0203e86:	f8a2                	sd	s0,112(sp)
ffffffffc0203e88:	f4a6                	sd	s1,104(sp)
ffffffffc0203e8a:	ecce                	sd	s3,88(sp)
ffffffffc0203e8c:	e8d2                	sd	s4,80(sp)
ffffffffc0203e8e:	e4d6                	sd	s5,72(sp)
ffffffffc0203e90:	e0da                	sd	s6,64(sp)
ffffffffc0203e92:	fc5e                	sd	s7,56(sp)
ffffffffc0203e94:	f862                	sd	s8,48(sp)
ffffffffc0203e96:	f466                	sd	s9,40(sp)
ffffffffc0203e98:	f06a                	sd	s10,32(sp)
ffffffffc0203e9a:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203e9c:	6785                	lui	a5,0x1
ffffffffc0203e9e:	2ef75f63          	bge	a4,a5,ffffffffc020419c <do_fork+0x328>
ffffffffc0203ea2:	8a2a                	mv	s4,a0
ffffffffc0203ea4:	89ae                	mv	s3,a1
ffffffffc0203ea6:	8432                	mv	s0,a2
    {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    // 1. 分配进程控制块
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203ea8:	e3bff0ef          	jal	ra,ffffffffc0203ce2 <alloc_proc>
ffffffffc0203eac:	84aa                	mv	s1,a0
ffffffffc0203eae:	2c050b63          	beqz	a0,ffffffffc0204184 <do_fork+0x310>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203eb2:	4509                	li	a0,2
ffffffffc0203eb4:	ef9fd0ef          	jal	ra,ffffffffc0201dac <alloc_pages>
    if (page != NULL)
ffffffffc0203eb8:	2c050363          	beqz	a0,ffffffffc020417e <do_fork+0x30a>
    return page - pages + nbase;
ffffffffc0203ebc:	000f7a97          	auipc	s5,0xf7
ffffffffc0203ec0:	ffca8a93          	addi	s5,s5,-4 # ffffffffc02faeb8 <pages>
ffffffffc0203ec4:	000ab683          	ld	a3,0(s5)
ffffffffc0203ec8:	00004797          	auipc	a5,0x4
ffffffffc0203ecc:	21878793          	addi	a5,a5,536 # ffffffffc02080e0 <nbase>
ffffffffc0203ed0:	6398                	ld	a4,0(a5)
ffffffffc0203ed2:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0203ed6:	000f7b97          	auipc	s7,0xf7
ffffffffc0203eda:	fdab8b93          	addi	s7,s7,-38 # ffffffffc02faeb0 <npage>
    return page - pages + nbase;
ffffffffc0203ede:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203ee0:	57fd                	li	a5,-1
ffffffffc0203ee2:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0203ee6:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0203ee8:	00c7db13          	srli	s6,a5,0xc
ffffffffc0203eec:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ef0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203ef2:	2ec5f263          	bgeu	a1,a2,ffffffffc02041d6 <do_fork+0x362>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203ef6:	000f7c97          	auipc	s9,0xf7
ffffffffc0203efa:	fdac8c93          	addi	s9,s9,-38 # ffffffffc02faed0 <current>
ffffffffc0203efe:	000cb883          	ld	a7,0(s9)
ffffffffc0203f02:	000f7c17          	auipc	s8,0xf7
ffffffffc0203f06:	fc6c0c13          	addi	s8,s8,-58 # ffffffffc02faec8 <va_pa_offset>
ffffffffc0203f0a:	000c3603          	ld	a2,0(s8)
ffffffffc0203f0e:	0288bd83          	ld	s11,40(a7) # 1028 <_binary_obj___user_faultread_out_size-0x8f20>
ffffffffc0203f12:	e43a                	sd	a4,8(sp)
ffffffffc0203f14:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203f16:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc0203f18:	020d8a63          	beqz	s11,ffffffffc0203f4c <do_fork+0xd8>
    if (clone_flags & CLONE_VM)
ffffffffc0203f1c:	100a7a13          	andi	s4,s4,256
ffffffffc0203f20:	180a0e63          	beqz	s4,ffffffffc02040bc <do_fork+0x248>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0203f24:	030da703          	lw	a4,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f28:	018db783          	ld	a5,24(s11)
ffffffffc0203f2c:	c02006b7          	lui	a3,0xc0200
ffffffffc0203f30:	2705                	addiw	a4,a4,1
ffffffffc0203f32:	02eda823          	sw	a4,48(s11)
    proc->mm = mm;
ffffffffc0203f36:	03b4b423          	sd	s11,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f3a:	2ad7ea63          	bltu	a5,a3,ffffffffc02041ee <do_fork+0x37a>
ffffffffc0203f3e:	000c3703          	ld	a4,0(s8)

    // 5. 分配唯一pid
    proc->pid = get_pid();

    // LAB5 update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
    proc->parent = current;
ffffffffc0203f42:	000cb883          	ld	a7,0(s9)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f46:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0203f48:	8f99                	sub	a5,a5,a4
ffffffffc0203f4a:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f4c:	6789                	lui	a5,0x2
ffffffffc0203f4e:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8068>
ffffffffc0203f52:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0203f54:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203f56:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0203f58:	87b6                	mv	a5,a3
ffffffffc0203f5a:	12040313          	addi	t1,s0,288
ffffffffc0203f5e:	00063803          	ld	a6,0(a2)
ffffffffc0203f62:	6608                	ld	a0,8(a2)
ffffffffc0203f64:	6a0c                	ld	a1,16(a2)
ffffffffc0203f66:	6e18                	ld	a4,24(a2)
ffffffffc0203f68:	0107b023          	sd	a6,0(a5)
ffffffffc0203f6c:	e788                	sd	a0,8(a5)
ffffffffc0203f6e:	eb8c                	sd	a1,16(a5)
ffffffffc0203f70:	ef98                	sd	a4,24(a5)
ffffffffc0203f72:	02060613          	addi	a2,a2,32
ffffffffc0203f76:	02078793          	addi	a5,a5,32
ffffffffc0203f7a:	fe6612e3          	bne	a2,t1,ffffffffc0203f5e <do_fork+0xea>
    proc->tf->gpr.a0 = 0;
ffffffffc0203f7e:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203f82:	12098b63          	beqz	s3,ffffffffc02040b8 <do_fork+0x244>
    if (++last_pid >= MAX_PID)
ffffffffc0203f86:	000f3817          	auipc	a6,0xf3
ffffffffc0203f8a:	a8a80813          	addi	a6,a6,-1398 # ffffffffc02f6a10 <last_pid.1>
ffffffffc0203f8e:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203f92:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203f96:	00000717          	auipc	a4,0x0
ffffffffc0203f9a:	df670713          	addi	a4,a4,-522 # ffffffffc0203d8c <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0203f9e:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203fa2:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0203fa4:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0203fa6:	00a82023          	sw	a0,0(a6)
ffffffffc0203faa:	6789                	lui	a5,0x2
ffffffffc0203fac:	08f55f63          	bge	a0,a5,ffffffffc020404a <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc0203fb0:	000f3e17          	auipc	t3,0xf3
ffffffffc0203fb4:	a64e0e13          	addi	t3,t3,-1436 # ffffffffc02f6a14 <next_safe.0>
ffffffffc0203fb8:	000e2783          	lw	a5,0(t3)
ffffffffc0203fbc:	000f7417          	auipc	s0,0xf7
ffffffffc0203fc0:	e7440413          	addi	s0,s0,-396 # ffffffffc02fae30 <proc_list>
ffffffffc0203fc4:	08f55b63          	bge	a0,a5,ffffffffc020405a <do_fork+0x1e6>
    proc->pid = get_pid();
ffffffffc0203fc8:	c0c8                	sw	a0,4(s1)
    proc->parent = current;
ffffffffc0203fca:	0314b023          	sd	a7,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203fce:	45a9                	li	a1,10
    current->wait_state = 0;
ffffffffc0203fd0:	0e08a623          	sw	zero,236(a7)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203fd4:	2501                	sext.w	a0,a0
ffffffffc0203fd6:	346010ef          	jal	ra,ffffffffc020531c <hash32>
ffffffffc0203fda:	02051793          	slli	a5,a0,0x20
ffffffffc0203fde:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0203fe2:	000f3797          	auipc	a5,0xf3
ffffffffc0203fe6:	e4e78793          	addi	a5,a5,-434 # ffffffffc02f6e30 <hash_list>
ffffffffc0203fea:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0203fec:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0203fee:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203ff0:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0203ff4:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0203ff6:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203ff8:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0203ffa:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203ffc:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0204000:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204002:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0204004:	e21c                	sd	a5,0(a2)
ffffffffc0204006:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204008:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc020400a:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc020400c:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204010:	10e4b023          	sd	a4,256(s1)
ffffffffc0204014:	c311                	beqz	a4,ffffffffc0204018 <do_fork+0x1a4>
        proc->optr->yptr = proc;
ffffffffc0204016:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204018:	00092783          	lw	a5,0(s2)
    hash_proc(proc);
    // LAB5 update step 5: set the relation links of process
    set_links(proc);

    // 9. 唤醒新进程
    wakeup_proc(proc);
ffffffffc020401c:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc020401e:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204020:	2785                	addiw	a5,a5,1
ffffffffc0204022:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc0204026:	084010ef          	jal	ra,ffffffffc02050aa <wakeup_proc>

    // 10. 返回新进程pid
    ret = proc->pid;
ffffffffc020402a:	40c8                	lw	a0,4(s1)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc020402c:	70e6                	ld	ra,120(sp)
ffffffffc020402e:	7446                	ld	s0,112(sp)
ffffffffc0204030:	74a6                	ld	s1,104(sp)
ffffffffc0204032:	7906                	ld	s2,96(sp)
ffffffffc0204034:	69e6                	ld	s3,88(sp)
ffffffffc0204036:	6a46                	ld	s4,80(sp)
ffffffffc0204038:	6aa6                	ld	s5,72(sp)
ffffffffc020403a:	6b06                	ld	s6,64(sp)
ffffffffc020403c:	7be2                	ld	s7,56(sp)
ffffffffc020403e:	7c42                	ld	s8,48(sp)
ffffffffc0204040:	7ca2                	ld	s9,40(sp)
ffffffffc0204042:	7d02                	ld	s10,32(sp)
ffffffffc0204044:	6de2                	ld	s11,24(sp)
ffffffffc0204046:	6109                	addi	sp,sp,128
ffffffffc0204048:	8082                	ret
        last_pid = 1;
ffffffffc020404a:	4785                	li	a5,1
ffffffffc020404c:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0204050:	4505                	li	a0,1
ffffffffc0204052:	000f3e17          	auipc	t3,0xf3
ffffffffc0204056:	9c2e0e13          	addi	t3,t3,-1598 # ffffffffc02f6a14 <next_safe.0>
    return listelm->next;
ffffffffc020405a:	000f7417          	auipc	s0,0xf7
ffffffffc020405e:	dd640413          	addi	s0,s0,-554 # ffffffffc02fae30 <proc_list>
ffffffffc0204062:	00843e83          	ld	t4,8(s0)
        next_safe = MAX_PID;
ffffffffc0204066:	6789                	lui	a5,0x2
ffffffffc0204068:	00fe2023          	sw	a5,0(t3)
ffffffffc020406c:	86aa                	mv	a3,a0
ffffffffc020406e:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204070:	6f09                	lui	t5,0x2
ffffffffc0204072:	128e8063          	beq	t4,s0,ffffffffc0204192 <do_fork+0x31e>
ffffffffc0204076:	832e                	mv	t1,a1
ffffffffc0204078:	87f6                	mv	a5,t4
ffffffffc020407a:	6609                	lui	a2,0x2
ffffffffc020407c:	a811                	j	ffffffffc0204090 <do_fork+0x21c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020407e:	00e6d663          	bge	a3,a4,ffffffffc020408a <do_fork+0x216>
ffffffffc0204082:	00c75463          	bge	a4,a2,ffffffffc020408a <do_fork+0x216>
ffffffffc0204086:	863a                	mv	a2,a4
ffffffffc0204088:	4305                	li	t1,1
ffffffffc020408a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020408c:	00878d63          	beq	a5,s0,ffffffffc02040a6 <do_fork+0x232>
            if (proc->pid == last_pid)
ffffffffc0204090:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x800c>
ffffffffc0204094:	fed715e3          	bne	a4,a3,ffffffffc020407e <do_fork+0x20a>
                if (++last_pid >= next_safe)
ffffffffc0204098:	2685                	addiw	a3,a3,1
ffffffffc020409a:	0ec6d763          	bge	a3,a2,ffffffffc0204188 <do_fork+0x314>
ffffffffc020409e:	679c                	ld	a5,8(a5)
ffffffffc02040a0:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02040a2:	fe8797e3          	bne	a5,s0,ffffffffc0204090 <do_fork+0x21c>
ffffffffc02040a6:	c581                	beqz	a1,ffffffffc02040ae <do_fork+0x23a>
ffffffffc02040a8:	00d82023          	sw	a3,0(a6)
ffffffffc02040ac:	8536                	mv	a0,a3
ffffffffc02040ae:	f0030de3          	beqz	t1,ffffffffc0203fc8 <do_fork+0x154>
ffffffffc02040b2:	00ce2023          	sw	a2,0(t3)
ffffffffc02040b6:	bf09                	j	ffffffffc0203fc8 <do_fork+0x154>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040b8:	89b6                	mv	s3,a3
ffffffffc02040ba:	b5f1                	j	ffffffffc0203f86 <do_fork+0x112>
    if ((mm = mm_create()) == NULL)
ffffffffc02040bc:	d14ff0ef          	jal	ra,ffffffffc02035d0 <mm_create>
ffffffffc02040c0:	8d2a                	mv	s10,a0
ffffffffc02040c2:	c159                	beqz	a0,ffffffffc0204148 <do_fork+0x2d4>
    if ((page = alloc_page()) == NULL)
ffffffffc02040c4:	4505                	li	a0,1
ffffffffc02040c6:	ce7fd0ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc02040ca:	cd25                	beqz	a0,ffffffffc0204142 <do_fork+0x2ce>
    return page - pages + nbase;
ffffffffc02040cc:	000ab683          	ld	a3,0(s5)
ffffffffc02040d0:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc02040d2:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc02040d6:	40d506b3          	sub	a3,a0,a3
ffffffffc02040da:	8699                	srai	a3,a3,0x6
ffffffffc02040dc:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc02040de:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02040e2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02040e4:	0ec7f963          	bgeu	a5,a2,ffffffffc02041d6 <do_fork+0x362>
ffffffffc02040e8:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02040ec:	6605                	lui	a2,0x1
ffffffffc02040ee:	000f7597          	auipc	a1,0xf7
ffffffffc02040f2:	dba5b583          	ld	a1,-582(a1) # ffffffffc02faea8 <boot_pgdir_va>
ffffffffc02040f6:	9a36                	add	s4,s4,a3
ffffffffc02040f8:	8552                	mv	a0,s4
ffffffffc02040fa:	6da010ef          	jal	ra,ffffffffc02057d4 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02040fe:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc0204102:	014d3c23          	sd	s4,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204106:	4785                	li	a5,1
ffffffffc0204108:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020410c:	8b85                	andi	a5,a5,1
ffffffffc020410e:	4a05                	li	s4,1
ffffffffc0204110:	c799                	beqz	a5,ffffffffc020411e <do_fork+0x2aa>
    {
        schedule();
ffffffffc0204112:	04a010ef          	jal	ra,ffffffffc020515c <schedule>
ffffffffc0204116:	414b37af          	amoor.d	a5,s4,(s6)
    while (!try_lock(lock))
ffffffffc020411a:	8b85                	andi	a5,a5,1
ffffffffc020411c:	fbfd                	bnez	a5,ffffffffc0204112 <do_fork+0x29e>
        ret = dup_mmap(mm, oldmm);
ffffffffc020411e:	85ee                	mv	a1,s11
ffffffffc0204120:	856a                	mv	a0,s10
ffffffffc0204122:	ef0ff0ef          	jal	ra,ffffffffc0203812 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204126:	57f9                	li	a5,-2
ffffffffc0204128:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc020412c:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc020412e:	cfa5                	beqz	a5,ffffffffc02041a6 <do_fork+0x332>
good_mm:
ffffffffc0204130:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc0204132:	de0509e3          	beqz	a0,ffffffffc0203f24 <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc0204136:	856a                	mv	a0,s10
ffffffffc0204138:	f74ff0ef          	jal	ra,ffffffffc02038ac <exit_mmap>
    put_pgdir(mm);
ffffffffc020413c:	856a                	mv	a0,s10
ffffffffc020413e:	c5dff0ef          	jal	ra,ffffffffc0203d9a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204142:	856a                	mv	a0,s10
ffffffffc0204144:	dccff0ef          	jal	ra,ffffffffc0203710 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204148:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc020414a:	c02007b7          	lui	a5,0xc0200
ffffffffc020414e:	0af6ed63          	bltu	a3,a5,ffffffffc0204208 <do_fork+0x394>
ffffffffc0204152:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc0204156:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc020415a:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020415e:	83b1                	srli	a5,a5,0xc
ffffffffc0204160:	04e7ff63          	bgeu	a5,a4,ffffffffc02041be <do_fork+0x34a>
    return &pages[PPN(pa) - nbase];
ffffffffc0204164:	00004717          	auipc	a4,0x4
ffffffffc0204168:	f7c70713          	addi	a4,a4,-132 # ffffffffc02080e0 <nbase>
ffffffffc020416c:	6318                	ld	a4,0(a4)
ffffffffc020416e:	000ab503          	ld	a0,0(s5)
ffffffffc0204172:	4589                	li	a1,2
ffffffffc0204174:	8f99                	sub	a5,a5,a4
ffffffffc0204176:	079a                	slli	a5,a5,0x6
ffffffffc0204178:	953e                	add	a0,a0,a5
ffffffffc020417a:	c71fd0ef          	jal	ra,ffffffffc0201dea <free_pages>
    kfree(proc);
ffffffffc020417e:	8526                	mv	a0,s1
ffffffffc0204180:	afffd0ef          	jal	ra,ffffffffc0201c7e <kfree>
    ret = -E_NO_MEM;
ffffffffc0204184:	5571                	li	a0,-4
    return ret;
ffffffffc0204186:	b55d                	j	ffffffffc020402c <do_fork+0x1b8>
                    if (last_pid >= MAX_PID)
ffffffffc0204188:	01e6c363          	blt	a3,t5,ffffffffc020418e <do_fork+0x31a>
                        last_pid = 1;
ffffffffc020418c:	4685                	li	a3,1
                    goto repeat;
ffffffffc020418e:	4585                	li	a1,1
ffffffffc0204190:	b5cd                	j	ffffffffc0204072 <do_fork+0x1fe>
ffffffffc0204192:	c599                	beqz	a1,ffffffffc02041a0 <do_fork+0x32c>
ffffffffc0204194:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204198:	8536                	mv	a0,a3
ffffffffc020419a:	b53d                	j	ffffffffc0203fc8 <do_fork+0x154>
    int ret = -E_NO_FREE_PROC;
ffffffffc020419c:	556d                	li	a0,-5
ffffffffc020419e:	b579                	j	ffffffffc020402c <do_fork+0x1b8>
    return last_pid;
ffffffffc02041a0:	00082503          	lw	a0,0(a6)
ffffffffc02041a4:	b515                	j	ffffffffc0203fc8 <do_fork+0x154>
    {
        panic("Unlock failed.\n");
ffffffffc02041a6:	00003617          	auipc	a2,0x3
ffffffffc02041aa:	e9260613          	addi	a2,a2,-366 # ffffffffc0207038 <default_pmm_manager+0xa08>
ffffffffc02041ae:	04000593          	li	a1,64
ffffffffc02041b2:	00003517          	auipc	a0,0x3
ffffffffc02041b6:	e9650513          	addi	a0,a0,-362 # ffffffffc0207048 <default_pmm_manager+0xa18>
ffffffffc02041ba:	ad8fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02041be:	00002617          	auipc	a2,0x2
ffffffffc02041c2:	57a60613          	addi	a2,a2,1402 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc02041c6:	06900593          	li	a1,105
ffffffffc02041ca:	00002517          	auipc	a0,0x2
ffffffffc02041ce:	4c650513          	addi	a0,a0,1222 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc02041d2:	ac0fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return KADDR(page2pa(page));
ffffffffc02041d6:	00002617          	auipc	a2,0x2
ffffffffc02041da:	49260613          	addi	a2,a2,1170 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc02041de:	07100593          	li	a1,113
ffffffffc02041e2:	00002517          	auipc	a0,0x2
ffffffffc02041e6:	4ae50513          	addi	a0,a0,1198 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc02041ea:	aa8fc0ef          	jal	ra,ffffffffc0200492 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041ee:	86be                	mv	a3,a5
ffffffffc02041f0:	00002617          	auipc	a2,0x2
ffffffffc02041f4:	52060613          	addi	a2,a2,1312 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc02041f8:	1a900593          	li	a1,425
ffffffffc02041fc:	00003517          	auipc	a0,0x3
ffffffffc0204200:	e6450513          	addi	a0,a0,-412 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204204:	a8efc0ef          	jal	ra,ffffffffc0200492 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204208:	00002617          	auipc	a2,0x2
ffffffffc020420c:	50860613          	addi	a2,a2,1288 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc0204210:	07700593          	li	a1,119
ffffffffc0204214:	00002517          	auipc	a0,0x2
ffffffffc0204218:	47c50513          	addi	a0,a0,1148 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc020421c:	a76fc0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204220 <kernel_thread>:
{
ffffffffc0204220:	7129                	addi	sp,sp,-320
ffffffffc0204222:	fa22                	sd	s0,304(sp)
ffffffffc0204224:	f626                	sd	s1,296(sp)
ffffffffc0204226:	f24a                	sd	s2,288(sp)
ffffffffc0204228:	84ae                	mv	s1,a1
ffffffffc020422a:	892a                	mv	s2,a0
ffffffffc020422c:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020422e:	4581                	li	a1,0
ffffffffc0204230:	12000613          	li	a2,288
ffffffffc0204234:	850a                	mv	a0,sp
{
ffffffffc0204236:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204238:	58a010ef          	jal	ra,ffffffffc02057c2 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020423c:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020423e:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204240:	100027f3          	csrr	a5,sstatus
ffffffffc0204244:	edd7f793          	andi	a5,a5,-291
ffffffffc0204248:	1207e793          	ori	a5,a5,288
ffffffffc020424c:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020424e:	860a                	mv	a2,sp
ffffffffc0204250:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204254:	00000797          	auipc	a5,0x0
ffffffffc0204258:	a8678793          	addi	a5,a5,-1402 # ffffffffc0203cda <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020425c:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020425e:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204260:	c15ff0ef          	jal	ra,ffffffffc0203e74 <do_fork>
}
ffffffffc0204264:	70f2                	ld	ra,312(sp)
ffffffffc0204266:	7452                	ld	s0,304(sp)
ffffffffc0204268:	74b2                	ld	s1,296(sp)
ffffffffc020426a:	7912                	ld	s2,288(sp)
ffffffffc020426c:	6131                	addi	sp,sp,320
ffffffffc020426e:	8082                	ret

ffffffffc0204270 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc0204270:	7179                	addi	sp,sp,-48
ffffffffc0204272:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204274:	000f7417          	auipc	s0,0xf7
ffffffffc0204278:	c5c40413          	addi	s0,s0,-932 # ffffffffc02faed0 <current>
ffffffffc020427c:	601c                	ld	a5,0(s0)
{
ffffffffc020427e:	f406                	sd	ra,40(sp)
ffffffffc0204280:	ec26                	sd	s1,24(sp)
ffffffffc0204282:	e84a                	sd	s2,16(sp)
ffffffffc0204284:	e44e                	sd	s3,8(sp)
ffffffffc0204286:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204288:	000f7717          	auipc	a4,0xf7
ffffffffc020428c:	c5073703          	ld	a4,-944(a4) # ffffffffc02faed8 <idleproc>
ffffffffc0204290:	0ce78c63          	beq	a5,a4,ffffffffc0204368 <do_exit+0xf8>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204294:	000f7497          	auipc	s1,0xf7
ffffffffc0204298:	c4c48493          	addi	s1,s1,-948 # ffffffffc02faee0 <initproc>
ffffffffc020429c:	6098                	ld	a4,0(s1)
ffffffffc020429e:	0ee78b63          	beq	a5,a4,ffffffffc0204394 <do_exit+0x124>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc02042a2:	0287b983          	ld	s3,40(a5)
ffffffffc02042a6:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc02042a8:	02098663          	beqz	s3,ffffffffc02042d4 <do_exit+0x64>
ffffffffc02042ac:	000f7797          	auipc	a5,0xf7
ffffffffc02042b0:	bf47b783          	ld	a5,-1036(a5) # ffffffffc02faea0 <boot_pgdir_pa>
ffffffffc02042b4:	577d                	li	a4,-1
ffffffffc02042b6:	177e                	slli	a4,a4,0x3f
ffffffffc02042b8:	83b1                	srli	a5,a5,0xc
ffffffffc02042ba:	8fd9                	or	a5,a5,a4
ffffffffc02042bc:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02042c0:	0309a783          	lw	a5,48(s3)
ffffffffc02042c4:	fff7871b          	addiw	a4,a5,-1
ffffffffc02042c8:	02e9a823          	sw	a4,48(s3)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc02042cc:	cb55                	beqz	a4,ffffffffc0204380 <do_exit+0x110>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc02042ce:	601c                	ld	a5,0(s0)
ffffffffc02042d0:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc02042d4:	601c                	ld	a5,0(s0)
ffffffffc02042d6:	470d                	li	a4,3
ffffffffc02042d8:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02042da:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042de:	100027f3          	csrr	a5,sstatus
ffffffffc02042e2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02042e4:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02042e6:	e3f9                	bnez	a5,ffffffffc02043ac <do_exit+0x13c>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc02042e8:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02042ea:	800007b7          	lui	a5,0x80000
ffffffffc02042ee:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02042f0:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02042f2:	0ec52703          	lw	a4,236(a0)
ffffffffc02042f6:	0af70f63          	beq	a4,a5,ffffffffc02043b4 <do_exit+0x144>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02042fa:	6018                	ld	a4,0(s0)
ffffffffc02042fc:	7b7c                	ld	a5,240(a4)
ffffffffc02042fe:	c3a1                	beqz	a5,ffffffffc020433e <do_exit+0xce>
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204300:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204304:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204306:	0985                	addi	s3,s3,1
ffffffffc0204308:	a021                	j	ffffffffc0204310 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020430a:	6018                	ld	a4,0(s0)
ffffffffc020430c:	7b7c                	ld	a5,240(a4)
ffffffffc020430e:	cb85                	beqz	a5,ffffffffc020433e <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204310:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7fff39e8>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204314:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204316:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204318:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc020431a:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020431e:	10e7b023          	sd	a4,256(a5)
ffffffffc0204322:	c311                	beqz	a4,ffffffffc0204326 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204324:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204326:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204328:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc020432a:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020432c:	fd271fe3          	bne	a4,s2,ffffffffc020430a <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204330:	0ec52783          	lw	a5,236(a0)
ffffffffc0204334:	fd379be3          	bne	a5,s3,ffffffffc020430a <do_exit+0x9a>
                {
                    wakeup_proc(initproc);
ffffffffc0204338:	573000ef          	jal	ra,ffffffffc02050aa <wakeup_proc>
ffffffffc020433c:	b7f9                	j	ffffffffc020430a <do_exit+0x9a>
    if (flag)
ffffffffc020433e:	020a1263          	bnez	s4,ffffffffc0204362 <do_exit+0xf2>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204342:	61b000ef          	jal	ra,ffffffffc020515c <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204346:	601c                	ld	a5,0(s0)
ffffffffc0204348:	00003617          	auipc	a2,0x3
ffffffffc020434c:	d5060613          	addi	a2,a2,-688 # ffffffffc0207098 <default_pmm_manager+0xa68>
ffffffffc0204350:	25e00593          	li	a1,606
ffffffffc0204354:	43d4                	lw	a3,4(a5)
ffffffffc0204356:	00003517          	auipc	a0,0x3
ffffffffc020435a:	d0a50513          	addi	a0,a0,-758 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc020435e:	934fc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_enable();
ffffffffc0204362:	e46fc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc0204366:	bff1                	j	ffffffffc0204342 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204368:	00003617          	auipc	a2,0x3
ffffffffc020436c:	d1060613          	addi	a2,a2,-752 # ffffffffc0207078 <default_pmm_manager+0xa48>
ffffffffc0204370:	22a00593          	li	a1,554
ffffffffc0204374:	00003517          	auipc	a0,0x3
ffffffffc0204378:	cec50513          	addi	a0,a0,-788 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc020437c:	916fc0ef          	jal	ra,ffffffffc0200492 <__panic>
            exit_mmap(mm);
ffffffffc0204380:	854e                	mv	a0,s3
ffffffffc0204382:	d2aff0ef          	jal	ra,ffffffffc02038ac <exit_mmap>
            put_pgdir(mm);
ffffffffc0204386:	854e                	mv	a0,s3
ffffffffc0204388:	a13ff0ef          	jal	ra,ffffffffc0203d9a <put_pgdir>
            mm_destroy(mm);
ffffffffc020438c:	854e                	mv	a0,s3
ffffffffc020438e:	b82ff0ef          	jal	ra,ffffffffc0203710 <mm_destroy>
ffffffffc0204392:	bf35                	j	ffffffffc02042ce <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204394:	00003617          	auipc	a2,0x3
ffffffffc0204398:	cf460613          	addi	a2,a2,-780 # ffffffffc0207088 <default_pmm_manager+0xa58>
ffffffffc020439c:	22e00593          	li	a1,558
ffffffffc02043a0:	00003517          	auipc	a0,0x3
ffffffffc02043a4:	cc050513          	addi	a0,a0,-832 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc02043a8:	8eafc0ef          	jal	ra,ffffffffc0200492 <__panic>
        intr_disable();
ffffffffc02043ac:	e02fc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc02043b0:	4a05                	li	s4,1
ffffffffc02043b2:	bf1d                	j	ffffffffc02042e8 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc02043b4:	4f7000ef          	jal	ra,ffffffffc02050aa <wakeup_proc>
ffffffffc02043b8:	b789                	j	ffffffffc02042fa <do_exit+0x8a>

ffffffffc02043ba <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc02043ba:	715d                	addi	sp,sp,-80
ffffffffc02043bc:	f84a                	sd	s2,48(sp)
ffffffffc02043be:	f44e                	sd	s3,40(sp)
        }
    }
    if (haskid)
    {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD;
ffffffffc02043c0:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc02043c4:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc02043c6:	fc26                	sd	s1,56(sp)
ffffffffc02043c8:	f052                	sd	s4,32(sp)
ffffffffc02043ca:	ec56                	sd	s5,24(sp)
ffffffffc02043cc:	e85a                	sd	s6,16(sp)
ffffffffc02043ce:	e45e                	sd	s7,8(sp)
ffffffffc02043d0:	e486                	sd	ra,72(sp)
ffffffffc02043d2:	e0a2                	sd	s0,64(sp)
ffffffffc02043d4:	84aa                	mv	s1,a0
ffffffffc02043d6:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc02043d8:	000f7b97          	auipc	s7,0xf7
ffffffffc02043dc:	af8b8b93          	addi	s7,s7,-1288 # ffffffffc02faed0 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02043e0:	00050b1b          	sext.w	s6,a0
ffffffffc02043e4:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02043e8:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02043ea:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02043ec:	ccbd                	beqz	s1,ffffffffc020446a <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02043ee:	0359e863          	bltu	s3,s5,ffffffffc020441e <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02043f2:	45a9                	li	a1,10
ffffffffc02043f4:	855a                	mv	a0,s6
ffffffffc02043f6:	727000ef          	jal	ra,ffffffffc020531c <hash32>
ffffffffc02043fa:	02051793          	slli	a5,a0,0x20
ffffffffc02043fe:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204402:	000f3797          	auipc	a5,0xf3
ffffffffc0204406:	a2e78793          	addi	a5,a5,-1490 # ffffffffc02f6e30 <hash_list>
ffffffffc020440a:	953e                	add	a0,a0,a5
ffffffffc020440c:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc020440e:	a029                	j	ffffffffc0204418 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204410:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204414:	02978163          	beq	a5,s1,ffffffffc0204436 <do_wait.part.0+0x7c>
ffffffffc0204418:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc020441a:	fe851be3          	bne	a0,s0,ffffffffc0204410 <do_wait.part.0+0x56>
        {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;
ffffffffc020441e:	5579                	li	a0,-2
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc0204420:	60a6                	ld	ra,72(sp)
ffffffffc0204422:	6406                	ld	s0,64(sp)
ffffffffc0204424:	74e2                	ld	s1,56(sp)
ffffffffc0204426:	7942                	ld	s2,48(sp)
ffffffffc0204428:	79a2                	ld	s3,40(sp)
ffffffffc020442a:	7a02                	ld	s4,32(sp)
ffffffffc020442c:	6ae2                	ld	s5,24(sp)
ffffffffc020442e:	6b42                	ld	s6,16(sp)
ffffffffc0204430:	6ba2                	ld	s7,8(sp)
ffffffffc0204432:	6161                	addi	sp,sp,80
ffffffffc0204434:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204436:	000bb683          	ld	a3,0(s7)
ffffffffc020443a:	f4843783          	ld	a5,-184(s0)
ffffffffc020443e:	fed790e3          	bne	a5,a3,ffffffffc020441e <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204442:	f2842703          	lw	a4,-216(s0)
ffffffffc0204446:	478d                	li	a5,3
ffffffffc0204448:	0ef70b63          	beq	a4,a5,ffffffffc020453e <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc020444c:	4785                	li	a5,1
ffffffffc020444e:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204450:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204454:	509000ef          	jal	ra,ffffffffc020515c <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204458:	000bb783          	ld	a5,0(s7)
ffffffffc020445c:	0b07a783          	lw	a5,176(a5)
ffffffffc0204460:	8b85                	andi	a5,a5,1
ffffffffc0204462:	d7c9                	beqz	a5,ffffffffc02043ec <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204464:	555d                	li	a0,-9
ffffffffc0204466:	e0bff0ef          	jal	ra,ffffffffc0204270 <do_exit>
        proc = current->cptr;
ffffffffc020446a:	000bb683          	ld	a3,0(s7)
ffffffffc020446e:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204470:	d45d                	beqz	s0,ffffffffc020441e <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204472:	470d                	li	a4,3
ffffffffc0204474:	a021                	j	ffffffffc020447c <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204476:	10043403          	ld	s0,256(s0)
ffffffffc020447a:	d869                	beqz	s0,ffffffffc020444c <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020447c:	401c                	lw	a5,0(s0)
ffffffffc020447e:	fee79ce3          	bne	a5,a4,ffffffffc0204476 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204482:	000f7797          	auipc	a5,0xf7
ffffffffc0204486:	a567b783          	ld	a5,-1450(a5) # ffffffffc02faed8 <idleproc>
ffffffffc020448a:	0c878963          	beq	a5,s0,ffffffffc020455c <do_wait.part.0+0x1a2>
ffffffffc020448e:	000f7797          	auipc	a5,0xf7
ffffffffc0204492:	a527b783          	ld	a5,-1454(a5) # ffffffffc02faee0 <initproc>
ffffffffc0204496:	0cf40363          	beq	s0,a5,ffffffffc020455c <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020449a:	000a0663          	beqz	s4,ffffffffc02044a6 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020449e:	0e842783          	lw	a5,232(s0)
ffffffffc02044a2:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f48>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02044a6:	100027f3          	csrr	a5,sstatus
ffffffffc02044aa:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02044ac:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02044ae:	e7c1                	bnez	a5,ffffffffc0204536 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02044b0:	6c70                	ld	a2,216(s0)
ffffffffc02044b2:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc02044b4:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc02044b8:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc02044ba:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02044bc:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02044be:	6470                	ld	a2,200(s0)
ffffffffc02044c0:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc02044c2:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02044c4:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc02044c6:	c319                	beqz	a4,ffffffffc02044cc <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc02044c8:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc02044ca:	7c7c                	ld	a5,248(s0)
ffffffffc02044cc:	c3b5                	beqz	a5,ffffffffc0204530 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc02044ce:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc02044d2:	000f7717          	auipc	a4,0xf7
ffffffffc02044d6:	a1670713          	addi	a4,a4,-1514 # ffffffffc02faee8 <nr_process>
ffffffffc02044da:	431c                	lw	a5,0(a4)
ffffffffc02044dc:	37fd                	addiw	a5,a5,-1
ffffffffc02044de:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02044e0:	e5a9                	bnez	a1,ffffffffc020452a <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02044e2:	6814                	ld	a3,16(s0)
ffffffffc02044e4:	c02007b7          	lui	a5,0xc0200
ffffffffc02044e8:	04f6ee63          	bltu	a3,a5,ffffffffc0204544 <do_wait.part.0+0x18a>
ffffffffc02044ec:	000f7797          	auipc	a5,0xf7
ffffffffc02044f0:	9dc7b783          	ld	a5,-1572(a5) # ffffffffc02faec8 <va_pa_offset>
ffffffffc02044f4:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02044f6:	82b1                	srli	a3,a3,0xc
ffffffffc02044f8:	000f7797          	auipc	a5,0xf7
ffffffffc02044fc:	9b87b783          	ld	a5,-1608(a5) # ffffffffc02faeb0 <npage>
ffffffffc0204500:	06f6fa63          	bgeu	a3,a5,ffffffffc0204574 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204504:	00004517          	auipc	a0,0x4
ffffffffc0204508:	bdc53503          	ld	a0,-1060(a0) # ffffffffc02080e0 <nbase>
ffffffffc020450c:	8e89                	sub	a3,a3,a0
ffffffffc020450e:	069a                	slli	a3,a3,0x6
ffffffffc0204510:	000f7517          	auipc	a0,0xf7
ffffffffc0204514:	9a853503          	ld	a0,-1624(a0) # ffffffffc02faeb8 <pages>
ffffffffc0204518:	9536                	add	a0,a0,a3
ffffffffc020451a:	4589                	li	a1,2
ffffffffc020451c:	8cffd0ef          	jal	ra,ffffffffc0201dea <free_pages>
    kfree(proc);
ffffffffc0204520:	8522                	mv	a0,s0
ffffffffc0204522:	f5cfd0ef          	jal	ra,ffffffffc0201c7e <kfree>
    return 0;
ffffffffc0204526:	4501                	li	a0,0
ffffffffc0204528:	bde5                	j	ffffffffc0204420 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc020452a:	c7efc0ef          	jal	ra,ffffffffc02009a8 <intr_enable>
ffffffffc020452e:	bf55                	j	ffffffffc02044e2 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc0204530:	701c                	ld	a5,32(s0)
ffffffffc0204532:	fbf8                	sd	a4,240(a5)
ffffffffc0204534:	bf79                	j	ffffffffc02044d2 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0204536:	c78fc0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc020453a:	4585                	li	a1,1
ffffffffc020453c:	bf95                	j	ffffffffc02044b0 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020453e:	f2840413          	addi	s0,s0,-216
ffffffffc0204542:	b781                	j	ffffffffc0204482 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0204544:	00002617          	auipc	a2,0x2
ffffffffc0204548:	1cc60613          	addi	a2,a2,460 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc020454c:	07700593          	li	a1,119
ffffffffc0204550:	00002517          	auipc	a0,0x2
ffffffffc0204554:	14050513          	addi	a0,a0,320 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0204558:	f3bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020455c:	00003617          	auipc	a2,0x3
ffffffffc0204560:	b5c60613          	addi	a2,a2,-1188 # ffffffffc02070b8 <default_pmm_manager+0xa88>
ffffffffc0204564:	37f00593          	li	a1,895
ffffffffc0204568:	00003517          	auipc	a0,0x3
ffffffffc020456c:	af850513          	addi	a0,a0,-1288 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204570:	f23fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204574:	00002617          	auipc	a2,0x2
ffffffffc0204578:	1c460613          	addi	a2,a2,452 # ffffffffc0206738 <default_pmm_manager+0x108>
ffffffffc020457c:	06900593          	li	a1,105
ffffffffc0204580:	00002517          	auipc	a0,0x2
ffffffffc0204584:	11050513          	addi	a0,a0,272 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0204588:	f0bfb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020458c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020458c:	1141                	addi	sp,sp,-16
ffffffffc020458e:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204590:	89bfd0ef          	jal	ra,ffffffffc0201e2a <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204594:	e36fd0ef          	jal	ra,ffffffffc0201bca <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204598:	4601                	li	a2,0
ffffffffc020459a:	4581                	li	a1,0
ffffffffc020459c:	00000517          	auipc	a0,0x0
ffffffffc02045a0:	62850513          	addi	a0,a0,1576 # ffffffffc0204bc4 <user_main>
ffffffffc02045a4:	c7dff0ef          	jal	ra,ffffffffc0204220 <kernel_thread>
    if (pid <= 0)
ffffffffc02045a8:	00a04563          	bgtz	a0,ffffffffc02045b2 <init_main+0x26>
ffffffffc02045ac:	a071                	j	ffffffffc0204638 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02045ae:	3af000ef          	jal	ra,ffffffffc020515c <schedule>
    if (code_store != NULL)
ffffffffc02045b2:	4581                	li	a1,0
ffffffffc02045b4:	4501                	li	a0,0
ffffffffc02045b6:	e05ff0ef          	jal	ra,ffffffffc02043ba <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02045ba:	d975                	beqz	a0,ffffffffc02045ae <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02045bc:	00003517          	auipc	a0,0x3
ffffffffc02045c0:	b3c50513          	addi	a0,a0,-1220 # ffffffffc02070f8 <default_pmm_manager+0xac8>
ffffffffc02045c4:	bd5fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02045c8:	000f7797          	auipc	a5,0xf7
ffffffffc02045cc:	9187b783          	ld	a5,-1768(a5) # ffffffffc02faee0 <initproc>
ffffffffc02045d0:	7bf8                	ld	a4,240(a5)
ffffffffc02045d2:	e339                	bnez	a4,ffffffffc0204618 <init_main+0x8c>
ffffffffc02045d4:	7ff8                	ld	a4,248(a5)
ffffffffc02045d6:	e329                	bnez	a4,ffffffffc0204618 <init_main+0x8c>
ffffffffc02045d8:	1007b703          	ld	a4,256(a5)
ffffffffc02045dc:	ef15                	bnez	a4,ffffffffc0204618 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02045de:	000f7697          	auipc	a3,0xf7
ffffffffc02045e2:	90a6a683          	lw	a3,-1782(a3) # ffffffffc02faee8 <nr_process>
ffffffffc02045e6:	4709                	li	a4,2
ffffffffc02045e8:	0ae69463          	bne	a3,a4,ffffffffc0204690 <init_main+0x104>
    return listelm->next;
ffffffffc02045ec:	000f7697          	auipc	a3,0xf7
ffffffffc02045f0:	84468693          	addi	a3,a3,-1980 # ffffffffc02fae30 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02045f4:	6698                	ld	a4,8(a3)
ffffffffc02045f6:	0c878793          	addi	a5,a5,200
ffffffffc02045fa:	06f71b63          	bne	a4,a5,ffffffffc0204670 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02045fe:	629c                	ld	a5,0(a3)
ffffffffc0204600:	04f71863          	bne	a4,a5,ffffffffc0204650 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204604:	00003517          	auipc	a0,0x3
ffffffffc0204608:	bdc50513          	addi	a0,a0,-1060 # ffffffffc02071e0 <default_pmm_manager+0xbb0>
ffffffffc020460c:	b8dfb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    return 0;
}
ffffffffc0204610:	60a2                	ld	ra,8(sp)
ffffffffc0204612:	4501                	li	a0,0
ffffffffc0204614:	0141                	addi	sp,sp,16
ffffffffc0204616:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204618:	00003697          	auipc	a3,0x3
ffffffffc020461c:	b0868693          	addi	a3,a3,-1272 # ffffffffc0207120 <default_pmm_manager+0xaf0>
ffffffffc0204620:	00002617          	auipc	a2,0x2
ffffffffc0204624:	c6060613          	addi	a2,a2,-928 # ffffffffc0206280 <commands+0x828>
ffffffffc0204628:	3eb00593          	li	a1,1003
ffffffffc020462c:	00003517          	auipc	a0,0x3
ffffffffc0204630:	a3450513          	addi	a0,a0,-1484 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204634:	e5ffb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("create user_main failed.\n");
ffffffffc0204638:	00003617          	auipc	a2,0x3
ffffffffc020463c:	aa060613          	addi	a2,a2,-1376 # ffffffffc02070d8 <default_pmm_manager+0xaa8>
ffffffffc0204640:	3e200593          	li	a1,994
ffffffffc0204644:	00003517          	auipc	a0,0x3
ffffffffc0204648:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc020464c:	e47fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204650:	00003697          	auipc	a3,0x3
ffffffffc0204654:	b6068693          	addi	a3,a3,-1184 # ffffffffc02071b0 <default_pmm_manager+0xb80>
ffffffffc0204658:	00002617          	auipc	a2,0x2
ffffffffc020465c:	c2860613          	addi	a2,a2,-984 # ffffffffc0206280 <commands+0x828>
ffffffffc0204660:	3ee00593          	li	a1,1006
ffffffffc0204664:	00003517          	auipc	a0,0x3
ffffffffc0204668:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc020466c:	e27fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204670:	00003697          	auipc	a3,0x3
ffffffffc0204674:	b1068693          	addi	a3,a3,-1264 # ffffffffc0207180 <default_pmm_manager+0xb50>
ffffffffc0204678:	00002617          	auipc	a2,0x2
ffffffffc020467c:	c0860613          	addi	a2,a2,-1016 # ffffffffc0206280 <commands+0x828>
ffffffffc0204680:	3ed00593          	li	a1,1005
ffffffffc0204684:	00003517          	auipc	a0,0x3
ffffffffc0204688:	9dc50513          	addi	a0,a0,-1572 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc020468c:	e07fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(nr_process == 2);
ffffffffc0204690:	00003697          	auipc	a3,0x3
ffffffffc0204694:	ae068693          	addi	a3,a3,-1312 # ffffffffc0207170 <default_pmm_manager+0xb40>
ffffffffc0204698:	00002617          	auipc	a2,0x2
ffffffffc020469c:	be860613          	addi	a2,a2,-1048 # ffffffffc0206280 <commands+0x828>
ffffffffc02046a0:	3ec00593          	li	a1,1004
ffffffffc02046a4:	00003517          	auipc	a0,0x3
ffffffffc02046a8:	9bc50513          	addi	a0,a0,-1604 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc02046ac:	de7fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc02046b0 <do_execve>:
{
ffffffffc02046b0:	7171                	addi	sp,sp,-176
ffffffffc02046b2:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02046b4:	000f7d97          	auipc	s11,0xf7
ffffffffc02046b8:	81cd8d93          	addi	s11,s11,-2020 # ffffffffc02faed0 <current>
ffffffffc02046bc:	000db783          	ld	a5,0(s11)
{
ffffffffc02046c0:	e54e                	sd	s3,136(sp)
ffffffffc02046c2:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc02046c4:	0287b983          	ld	s3,40(a5)
{
ffffffffc02046c8:	e94a                	sd	s2,144(sp)
ffffffffc02046ca:	f4de                	sd	s7,104(sp)
ffffffffc02046cc:	892a                	mv	s2,a0
ffffffffc02046ce:	8bb2                	mv	s7,a2
ffffffffc02046d0:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02046d2:	862e                	mv	a2,a1
ffffffffc02046d4:	4681                	li	a3,0
ffffffffc02046d6:	85aa                	mv	a1,a0
ffffffffc02046d8:	854e                	mv	a0,s3
{
ffffffffc02046da:	f506                	sd	ra,168(sp)
ffffffffc02046dc:	f122                	sd	s0,160(sp)
ffffffffc02046de:	e152                	sd	s4,128(sp)
ffffffffc02046e0:	fcd6                	sd	s5,120(sp)
ffffffffc02046e2:	f8da                	sd	s6,112(sp)
ffffffffc02046e4:	f0e2                	sd	s8,96(sp)
ffffffffc02046e6:	ece6                	sd	s9,88(sp)
ffffffffc02046e8:	e8ea                	sd	s10,80(sp)
ffffffffc02046ea:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02046ec:	d5aff0ef          	jal	ra,ffffffffc0203c46 <user_mem_check>
ffffffffc02046f0:	40050a63          	beqz	a0,ffffffffc0204b04 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02046f4:	4641                	li	a2,16
ffffffffc02046f6:	4581                	li	a1,0
ffffffffc02046f8:	1808                	addi	a0,sp,48
ffffffffc02046fa:	0c8010ef          	jal	ra,ffffffffc02057c2 <memset>
    memcpy(local_name, name, len);
ffffffffc02046fe:	47bd                	li	a5,15
ffffffffc0204700:	8626                	mv	a2,s1
ffffffffc0204702:	1e97e263          	bltu	a5,s1,ffffffffc02048e6 <do_execve+0x236>
ffffffffc0204706:	85ca                	mv	a1,s2
ffffffffc0204708:	1808                	addi	a0,sp,48
ffffffffc020470a:	0ca010ef          	jal	ra,ffffffffc02057d4 <memcpy>
    if (mm != NULL)
ffffffffc020470e:	1e098363          	beqz	s3,ffffffffc02048f4 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204712:	00002517          	auipc	a0,0x2
ffffffffc0204716:	74e50513          	addi	a0,a0,1870 # ffffffffc0206e60 <default_pmm_manager+0x830>
ffffffffc020471a:	ab7fb0ef          	jal	ra,ffffffffc02001d0 <cputs>
ffffffffc020471e:	000f6797          	auipc	a5,0xf6
ffffffffc0204722:	7827b783          	ld	a5,1922(a5) # ffffffffc02faea0 <boot_pgdir_pa>
ffffffffc0204726:	577d                	li	a4,-1
ffffffffc0204728:	177e                	slli	a4,a4,0x3f
ffffffffc020472a:	83b1                	srli	a5,a5,0xc
ffffffffc020472c:	8fd9                	or	a5,a5,a4
ffffffffc020472e:	18079073          	csrw	satp,a5
ffffffffc0204732:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7f18>
ffffffffc0204736:	fff7871b          	addiw	a4,a5,-1
ffffffffc020473a:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020473e:	2c070463          	beqz	a4,ffffffffc0204a06 <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204742:	000db783          	ld	a5,0(s11)
ffffffffc0204746:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc020474a:	e87fe0ef          	jal	ra,ffffffffc02035d0 <mm_create>
ffffffffc020474e:	84aa                	mv	s1,a0
ffffffffc0204750:	1c050d63          	beqz	a0,ffffffffc020492a <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204754:	4505                	li	a0,1
ffffffffc0204756:	e56fd0ef          	jal	ra,ffffffffc0201dac <alloc_pages>
ffffffffc020475a:	3a050963          	beqz	a0,ffffffffc0204b0c <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc020475e:	000f6c97          	auipc	s9,0xf6
ffffffffc0204762:	75ac8c93          	addi	s9,s9,1882 # ffffffffc02faeb8 <pages>
ffffffffc0204766:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc020476a:	000f6c17          	auipc	s8,0xf6
ffffffffc020476e:	746c0c13          	addi	s8,s8,1862 # ffffffffc02faeb0 <npage>
    return page - pages + nbase;
ffffffffc0204772:	00004717          	auipc	a4,0x4
ffffffffc0204776:	96e73703          	ld	a4,-1682(a4) # ffffffffc02080e0 <nbase>
ffffffffc020477a:	40d506b3          	sub	a3,a0,a3
ffffffffc020477e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204780:	5afd                	li	s5,-1
ffffffffc0204782:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204786:	96ba                	add	a3,a3,a4
ffffffffc0204788:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc020478a:	00cad713          	srli	a4,s5,0xc
ffffffffc020478e:	ec3a                	sd	a4,24(sp)
ffffffffc0204790:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204792:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204794:	38f77063          	bgeu	a4,a5,ffffffffc0204b14 <do_execve+0x464>
ffffffffc0204798:	000f6b17          	auipc	s6,0xf6
ffffffffc020479c:	730b0b13          	addi	s6,s6,1840 # ffffffffc02faec8 <va_pa_offset>
ffffffffc02047a0:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc02047a4:	6605                	lui	a2,0x1
ffffffffc02047a6:	000f6597          	auipc	a1,0xf6
ffffffffc02047aa:	7025b583          	ld	a1,1794(a1) # ffffffffc02faea8 <boot_pgdir_va>
ffffffffc02047ae:	9936                	add	s2,s2,a3
ffffffffc02047b0:	854a                	mv	a0,s2
ffffffffc02047b2:	022010ef          	jal	ra,ffffffffc02057d4 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02047b6:	7782                	ld	a5,32(sp)
ffffffffc02047b8:	4398                	lw	a4,0(a5)
ffffffffc02047ba:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc02047be:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc02047c2:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b7e67>
ffffffffc02047c6:	14f71863          	bne	a4,a5,ffffffffc0204916 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02047ca:	7682                	ld	a3,32(sp)
ffffffffc02047cc:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02047d0:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02047d4:	00371793          	slli	a5,a4,0x3
ffffffffc02047d8:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02047da:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02047dc:	078e                	slli	a5,a5,0x3
ffffffffc02047de:	97ce                	add	a5,a5,s3
ffffffffc02047e0:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc02047e2:	00f9fc63          	bgeu	s3,a5,ffffffffc02047fa <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc02047e6:	0009a783          	lw	a5,0(s3)
ffffffffc02047ea:	4705                	li	a4,1
ffffffffc02047ec:	14e78163          	beq	a5,a4,ffffffffc020492e <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc02047f0:	77a2                	ld	a5,40(sp)
ffffffffc02047f2:	03898993          	addi	s3,s3,56
ffffffffc02047f6:	fef9e8e3          	bltu	s3,a5,ffffffffc02047e6 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc02047fa:	4701                	li	a4,0
ffffffffc02047fc:	46ad                	li	a3,11
ffffffffc02047fe:	00100637          	lui	a2,0x100
ffffffffc0204802:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204806:	8526                	mv	a0,s1
ffffffffc0204808:	f5bfe0ef          	jal	ra,ffffffffc0203762 <mm_map>
ffffffffc020480c:	8a2a                	mv	s4,a0
ffffffffc020480e:	1e051263          	bnez	a0,ffffffffc02049f2 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204812:	6c88                	ld	a0,24(s1)
ffffffffc0204814:	467d                	li	a2,31
ffffffffc0204816:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc020481a:	cd1fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc020481e:	38050363          	beqz	a0,ffffffffc0204ba4 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204822:	6c88                	ld	a0,24(s1)
ffffffffc0204824:	467d                	li	a2,31
ffffffffc0204826:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc020482a:	cc1fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc020482e:	34050b63          	beqz	a0,ffffffffc0204b84 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204832:	6c88                	ld	a0,24(s1)
ffffffffc0204834:	467d                	li	a2,31
ffffffffc0204836:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020483a:	cb1fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc020483e:	32050363          	beqz	a0,ffffffffc0204b64 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204842:	6c88                	ld	a0,24(s1)
ffffffffc0204844:	467d                	li	a2,31
ffffffffc0204846:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020484a:	ca1fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc020484e:	2e050b63          	beqz	a0,ffffffffc0204b44 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204852:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204854:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204858:	6c94                	ld	a3,24(s1)
ffffffffc020485a:	2785                	addiw	a5,a5,1
ffffffffc020485c:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc020485e:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204860:	c02007b7          	lui	a5,0xc0200
ffffffffc0204864:	2cf6e463          	bltu	a3,a5,ffffffffc0204b2c <do_execve+0x47c>
ffffffffc0204868:	000b3783          	ld	a5,0(s6)
ffffffffc020486c:	577d                	li	a4,-1
ffffffffc020486e:	177e                	slli	a4,a4,0x3f
ffffffffc0204870:	8e9d                	sub	a3,a3,a5
ffffffffc0204872:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204876:	f654                	sd	a3,168(a2)
ffffffffc0204878:	8fd9                	or	a5,a5,a4
ffffffffc020487a:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc020487e:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204880:	4581                	li	a1,0
ffffffffc0204882:	12000613          	li	a2,288
ffffffffc0204886:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204888:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc020488c:	737000ef          	jal	ra,ffffffffc02057c2 <memset>
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc0204890:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204892:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc0204896:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc020489a:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP; // 用户栈顶
ffffffffc020489c:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020489e:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_matrix_out_size+0xffffffff7fff399c>
    tf->gpr.sp = USTACKTOP; // 用户栈顶
ffffffffc02048a2:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc02048a4:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02048a8:	4641                	li	a2,16
ffffffffc02048aa:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP; // 用户栈顶
ffffffffc02048ac:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc02048ae:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc02048b2:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02048b6:	854a                	mv	a0,s2
ffffffffc02048b8:	70b000ef          	jal	ra,ffffffffc02057c2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02048bc:	463d                	li	a2,15
ffffffffc02048be:	180c                	addi	a1,sp,48
ffffffffc02048c0:	854a                	mv	a0,s2
ffffffffc02048c2:	713000ef          	jal	ra,ffffffffc02057d4 <memcpy>
}
ffffffffc02048c6:	70aa                	ld	ra,168(sp)
ffffffffc02048c8:	740a                	ld	s0,160(sp)
ffffffffc02048ca:	64ea                	ld	s1,152(sp)
ffffffffc02048cc:	694a                	ld	s2,144(sp)
ffffffffc02048ce:	69aa                	ld	s3,136(sp)
ffffffffc02048d0:	7ae6                	ld	s5,120(sp)
ffffffffc02048d2:	7b46                	ld	s6,112(sp)
ffffffffc02048d4:	7ba6                	ld	s7,104(sp)
ffffffffc02048d6:	7c06                	ld	s8,96(sp)
ffffffffc02048d8:	6ce6                	ld	s9,88(sp)
ffffffffc02048da:	6d46                	ld	s10,80(sp)
ffffffffc02048dc:	6da6                	ld	s11,72(sp)
ffffffffc02048de:	8552                	mv	a0,s4
ffffffffc02048e0:	6a0a                	ld	s4,128(sp)
ffffffffc02048e2:	614d                	addi	sp,sp,176
ffffffffc02048e4:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc02048e6:	463d                	li	a2,15
ffffffffc02048e8:	85ca                	mv	a1,s2
ffffffffc02048ea:	1808                	addi	a0,sp,48
ffffffffc02048ec:	6e9000ef          	jal	ra,ffffffffc02057d4 <memcpy>
    if (mm != NULL)
ffffffffc02048f0:	e20991e3          	bnez	s3,ffffffffc0204712 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc02048f4:	000db783          	ld	a5,0(s11)
ffffffffc02048f8:	779c                	ld	a5,40(a5)
ffffffffc02048fa:	e40788e3          	beqz	a5,ffffffffc020474a <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02048fe:	00003617          	auipc	a2,0x3
ffffffffc0204902:	90260613          	addi	a2,a2,-1790 # ffffffffc0207200 <default_pmm_manager+0xbd0>
ffffffffc0204906:	26a00593          	li	a1,618
ffffffffc020490a:	00002517          	auipc	a0,0x2
ffffffffc020490e:	75650513          	addi	a0,a0,1878 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204912:	b81fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    put_pgdir(mm);
ffffffffc0204916:	8526                	mv	a0,s1
ffffffffc0204918:	c82ff0ef          	jal	ra,ffffffffc0203d9a <put_pgdir>
    mm_destroy(mm);
ffffffffc020491c:	8526                	mv	a0,s1
ffffffffc020491e:	df3fe0ef          	jal	ra,ffffffffc0203710 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204922:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204924:	8552                	mv	a0,s4
ffffffffc0204926:	94bff0ef          	jal	ra,ffffffffc0204270 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc020492a:	5a71                	li	s4,-4
ffffffffc020492c:	bfe5                	j	ffffffffc0204924 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc020492e:	0289b603          	ld	a2,40(s3)
ffffffffc0204932:	0209b783          	ld	a5,32(s3)
ffffffffc0204936:	1cf66d63          	bltu	a2,a5,ffffffffc0204b10 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc020493a:	0049a783          	lw	a5,4(s3)
ffffffffc020493e:	0017f693          	andi	a3,a5,1
ffffffffc0204942:	c291                	beqz	a3,ffffffffc0204946 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204944:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204946:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc020494a:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc020494c:	e779                	bnez	a4,ffffffffc0204a1a <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc020494e:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204950:	c781                	beqz	a5,ffffffffc0204958 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204952:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204956:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204958:	0026f793          	andi	a5,a3,2
ffffffffc020495c:	e3f1                	bnez	a5,ffffffffc0204a20 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc020495e:	0046f793          	andi	a5,a3,4
ffffffffc0204962:	c399                	beqz	a5,ffffffffc0204968 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204964:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204968:	0109b583          	ld	a1,16(s3)
ffffffffc020496c:	4701                	li	a4,0
ffffffffc020496e:	8526                	mv	a0,s1
ffffffffc0204970:	df3fe0ef          	jal	ra,ffffffffc0203762 <mm_map>
ffffffffc0204974:	8a2a                	mv	s4,a0
ffffffffc0204976:	ed35                	bnez	a0,ffffffffc02049f2 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204978:	0109bb83          	ld	s7,16(s3)
ffffffffc020497c:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc020497e:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204982:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204986:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc020498a:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc020498c:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc020498e:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204990:	054be963          	bltu	s7,s4,ffffffffc02049e2 <do_execve+0x332>
ffffffffc0204994:	aa95                	j	ffffffffc0204b08 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204996:	6785                	lui	a5,0x1
ffffffffc0204998:	415b8533          	sub	a0,s7,s5
ffffffffc020499c:	9abe                	add	s5,s5,a5
ffffffffc020499e:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc02049a2:	015a7463          	bgeu	s4,s5,ffffffffc02049aa <do_execve+0x2fa>
                size -= la - end;
ffffffffc02049a6:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc02049aa:	000cb683          	ld	a3,0(s9)
ffffffffc02049ae:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc02049b0:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc02049b4:	40d406b3          	sub	a3,s0,a3
ffffffffc02049b8:	8699                	srai	a3,a3,0x6
ffffffffc02049ba:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02049bc:	67e2                	ld	a5,24(sp)
ffffffffc02049be:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02049c2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02049c4:	14b87863          	bgeu	a6,a1,ffffffffc0204b14 <do_execve+0x464>
ffffffffc02049c8:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049cc:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc02049ce:	9bb2                	add	s7,s7,a2
ffffffffc02049d0:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049d2:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc02049d4:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02049d6:	5ff000ef          	jal	ra,ffffffffc02057d4 <memcpy>
            start += size, from += size;
ffffffffc02049da:	6622                	ld	a2,8(sp)
ffffffffc02049dc:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc02049de:	054bf363          	bgeu	s7,s4,ffffffffc0204a24 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02049e2:	6c88                	ld	a0,24(s1)
ffffffffc02049e4:	866a                	mv	a2,s10
ffffffffc02049e6:	85d6                	mv	a1,s5
ffffffffc02049e8:	b03fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc02049ec:	842a                	mv	s0,a0
ffffffffc02049ee:	f545                	bnez	a0,ffffffffc0204996 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc02049f0:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc02049f2:	8526                	mv	a0,s1
ffffffffc02049f4:	eb9fe0ef          	jal	ra,ffffffffc02038ac <exit_mmap>
    put_pgdir(mm);
ffffffffc02049f8:	8526                	mv	a0,s1
ffffffffc02049fa:	ba0ff0ef          	jal	ra,ffffffffc0203d9a <put_pgdir>
    mm_destroy(mm);
ffffffffc02049fe:	8526                	mv	a0,s1
ffffffffc0204a00:	d11fe0ef          	jal	ra,ffffffffc0203710 <mm_destroy>
    return ret;
ffffffffc0204a04:	b705                	j	ffffffffc0204924 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204a06:	854e                	mv	a0,s3
ffffffffc0204a08:	ea5fe0ef          	jal	ra,ffffffffc02038ac <exit_mmap>
            put_pgdir(mm);
ffffffffc0204a0c:	854e                	mv	a0,s3
ffffffffc0204a0e:	b8cff0ef          	jal	ra,ffffffffc0203d9a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204a12:	854e                	mv	a0,s3
ffffffffc0204a14:	cfdfe0ef          	jal	ra,ffffffffc0203710 <mm_destroy>
ffffffffc0204a18:	b32d                	j	ffffffffc0204742 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204a1a:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204a1e:	fb95                	bnez	a5,ffffffffc0204952 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204a20:	4d5d                	li	s10,23
ffffffffc0204a22:	bf35                	j	ffffffffc020495e <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204a24:	0109b683          	ld	a3,16(s3)
ffffffffc0204a28:	0289b903          	ld	s2,40(s3)
ffffffffc0204a2c:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204a2e:	075bfd63          	bgeu	s7,s5,ffffffffc0204aa8 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204a32:	db790fe3          	beq	s2,s7,ffffffffc02047f0 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204a36:	6785                	lui	a5,0x1
ffffffffc0204a38:	00fb8533          	add	a0,s7,a5
ffffffffc0204a3c:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204a40:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204a44:	0b597d63          	bgeu	s2,s5,ffffffffc0204afe <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204a48:	000cb683          	ld	a3,0(s9)
ffffffffc0204a4c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204a4e:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204a52:	40d406b3          	sub	a3,s0,a3
ffffffffc0204a56:	8699                	srai	a3,a3,0x6
ffffffffc0204a58:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204a5a:	67e2                	ld	a5,24(sp)
ffffffffc0204a5c:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a60:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a62:	0ac5f963          	bgeu	a1,a2,ffffffffc0204b14 <do_execve+0x464>
ffffffffc0204a66:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204a6a:	8652                	mv	a2,s4
ffffffffc0204a6c:	4581                	li	a1,0
ffffffffc0204a6e:	96c2                	add	a3,a3,a6
ffffffffc0204a70:	9536                	add	a0,a0,a3
ffffffffc0204a72:	551000ef          	jal	ra,ffffffffc02057c2 <memset>
            start += size;
ffffffffc0204a76:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204a7a:	03597463          	bgeu	s2,s5,ffffffffc0204aa2 <do_execve+0x3f2>
ffffffffc0204a7e:	d6e909e3          	beq	s2,a4,ffffffffc02047f0 <do_execve+0x140>
ffffffffc0204a82:	00002697          	auipc	a3,0x2
ffffffffc0204a86:	7a668693          	addi	a3,a3,1958 # ffffffffc0207228 <default_pmm_manager+0xbf8>
ffffffffc0204a8a:	00001617          	auipc	a2,0x1
ffffffffc0204a8e:	7f660613          	addi	a2,a2,2038 # ffffffffc0206280 <commands+0x828>
ffffffffc0204a92:	2d300593          	li	a1,723
ffffffffc0204a96:	00002517          	auipc	a0,0x2
ffffffffc0204a9a:	5ca50513          	addi	a0,a0,1482 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204a9e:	9f5fb0ef          	jal	ra,ffffffffc0200492 <__panic>
ffffffffc0204aa2:	ff5710e3          	bne	a4,s5,ffffffffc0204a82 <do_execve+0x3d2>
ffffffffc0204aa6:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204aa8:	d52bf4e3          	bgeu	s7,s2,ffffffffc02047f0 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204aac:	6c88                	ld	a0,24(s1)
ffffffffc0204aae:	866a                	mv	a2,s10
ffffffffc0204ab0:	85d6                	mv	a1,s5
ffffffffc0204ab2:	a39fe0ef          	jal	ra,ffffffffc02034ea <pgdir_alloc_page>
ffffffffc0204ab6:	842a                	mv	s0,a0
ffffffffc0204ab8:	dd05                	beqz	a0,ffffffffc02049f0 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204aba:	6785                	lui	a5,0x1
ffffffffc0204abc:	415b8533          	sub	a0,s7,s5
ffffffffc0204ac0:	9abe                	add	s5,s5,a5
ffffffffc0204ac2:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204ac6:	01597463          	bgeu	s2,s5,ffffffffc0204ace <do_execve+0x41e>
                size -= la - end;
ffffffffc0204aca:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204ace:	000cb683          	ld	a3,0(s9)
ffffffffc0204ad2:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ad4:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204ad8:	40d406b3          	sub	a3,s0,a3
ffffffffc0204adc:	8699                	srai	a3,a3,0x6
ffffffffc0204ade:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ae0:	67e2                	ld	a5,24(sp)
ffffffffc0204ae2:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ae6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ae8:	02b87663          	bgeu	a6,a1,ffffffffc0204b14 <do_execve+0x464>
ffffffffc0204aec:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204af0:	4581                	li	a1,0
            start += size;
ffffffffc0204af2:	9bb2                	add	s7,s7,a2
ffffffffc0204af4:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204af6:	9536                	add	a0,a0,a3
ffffffffc0204af8:	4cb000ef          	jal	ra,ffffffffc02057c2 <memset>
ffffffffc0204afc:	b775                	j	ffffffffc0204aa8 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204afe:	417a8a33          	sub	s4,s5,s7
ffffffffc0204b02:	b799                	j	ffffffffc0204a48 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204b04:	5a75                	li	s4,-3
ffffffffc0204b06:	b3c1                	j	ffffffffc02048c6 <do_execve+0x216>
        while (start < end)
ffffffffc0204b08:	86de                	mv	a3,s7
ffffffffc0204b0a:	bf39                	j	ffffffffc0204a28 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204b0c:	5a71                	li	s4,-4
ffffffffc0204b0e:	bdc5                	j	ffffffffc02049fe <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204b10:	5a61                	li	s4,-8
ffffffffc0204b12:	b5c5                	j	ffffffffc02049f2 <do_execve+0x342>
ffffffffc0204b14:	00002617          	auipc	a2,0x2
ffffffffc0204b18:	b5460613          	addi	a2,a2,-1196 # ffffffffc0206668 <default_pmm_manager+0x38>
ffffffffc0204b1c:	07100593          	li	a1,113
ffffffffc0204b20:	00002517          	auipc	a0,0x2
ffffffffc0204b24:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206690 <default_pmm_manager+0x60>
ffffffffc0204b28:	96bfb0ef          	jal	ra,ffffffffc0200492 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b2c:	00002617          	auipc	a2,0x2
ffffffffc0204b30:	be460613          	addi	a2,a2,-1052 # ffffffffc0206710 <default_pmm_manager+0xe0>
ffffffffc0204b34:	2f200593          	li	a1,754
ffffffffc0204b38:	00002517          	auipc	a0,0x2
ffffffffc0204b3c:	52850513          	addi	a0,a0,1320 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204b40:	953fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b44:	00002697          	auipc	a3,0x2
ffffffffc0204b48:	7fc68693          	addi	a3,a3,2044 # ffffffffc0207340 <default_pmm_manager+0xd10>
ffffffffc0204b4c:	00001617          	auipc	a2,0x1
ffffffffc0204b50:	73460613          	addi	a2,a2,1844 # ffffffffc0206280 <commands+0x828>
ffffffffc0204b54:	2ed00593          	li	a1,749
ffffffffc0204b58:	00002517          	auipc	a0,0x2
ffffffffc0204b5c:	50850513          	addi	a0,a0,1288 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204b60:	933fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b64:	00002697          	auipc	a3,0x2
ffffffffc0204b68:	79468693          	addi	a3,a3,1940 # ffffffffc02072f8 <default_pmm_manager+0xcc8>
ffffffffc0204b6c:	00001617          	auipc	a2,0x1
ffffffffc0204b70:	71460613          	addi	a2,a2,1812 # ffffffffc0206280 <commands+0x828>
ffffffffc0204b74:	2ec00593          	li	a1,748
ffffffffc0204b78:	00002517          	auipc	a0,0x2
ffffffffc0204b7c:	4e850513          	addi	a0,a0,1256 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204b80:	913fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b84:	00002697          	auipc	a3,0x2
ffffffffc0204b88:	72c68693          	addi	a3,a3,1836 # ffffffffc02072b0 <default_pmm_manager+0xc80>
ffffffffc0204b8c:	00001617          	auipc	a2,0x1
ffffffffc0204b90:	6f460613          	addi	a2,a2,1780 # ffffffffc0206280 <commands+0x828>
ffffffffc0204b94:	2eb00593          	li	a1,747
ffffffffc0204b98:	00002517          	auipc	a0,0x2
ffffffffc0204b9c:	4c850513          	addi	a0,a0,1224 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204ba0:	8f3fb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204ba4:	00002697          	auipc	a3,0x2
ffffffffc0204ba8:	6c468693          	addi	a3,a3,1732 # ffffffffc0207268 <default_pmm_manager+0xc38>
ffffffffc0204bac:	00001617          	auipc	a2,0x1
ffffffffc0204bb0:	6d460613          	addi	a2,a2,1748 # ffffffffc0206280 <commands+0x828>
ffffffffc0204bb4:	2ea00593          	li	a1,746
ffffffffc0204bb8:	00002517          	auipc	a0,0x2
ffffffffc0204bbc:	4a850513          	addi	a0,a0,1192 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204bc0:	8d3fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204bc4 <user_main>:
{
ffffffffc0204bc4:	1101                	addi	sp,sp,-32
ffffffffc0204bc6:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204bc8:	000f6917          	auipc	s2,0xf6
ffffffffc0204bcc:	30890913          	addi	s2,s2,776 # ffffffffc02faed0 <current>
ffffffffc0204bd0:	00093783          	ld	a5,0(s2)
ffffffffc0204bd4:	00002617          	auipc	a2,0x2
ffffffffc0204bd8:	7b460613          	addi	a2,a2,1972 # ffffffffc0207388 <default_pmm_manager+0xd58>
ffffffffc0204bdc:	00002517          	auipc	a0,0x2
ffffffffc0204be0:	7c450513          	addi	a0,a0,1988 # ffffffffc02073a0 <default_pmm_manager+0xd70>
ffffffffc0204be4:	43cc                	lw	a1,4(a5)
{
ffffffffc0204be6:	ec06                	sd	ra,24(sp)
ffffffffc0204be8:	e822                	sd	s0,16(sp)
ffffffffc0204bea:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204bec:	dacfb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    size_t len = strlen(name);
ffffffffc0204bf0:	00002517          	auipc	a0,0x2
ffffffffc0204bf4:	79850513          	addi	a0,a0,1944 # ffffffffc0207388 <default_pmm_manager+0xd58>
ffffffffc0204bf8:	329000ef          	jal	ra,ffffffffc0205720 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0204bfc:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc0204c00:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204c02:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204c06:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204c08:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204c0a:	6789                	lui	a5,0x2
ffffffffc0204c0c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8068>
ffffffffc0204c10:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204c12:	8522                	mv	a0,s0
ffffffffc0204c14:	3c1000ef          	jal	ra,ffffffffc02057d4 <memcpy>
    current->tf = new_tf;
ffffffffc0204c18:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc0204c1c:	3fe06697          	auipc	a3,0x3fe06
ffffffffc0204c20:	9b468693          	addi	a3,a3,-1612 # a5d0 <_binary_obj___user_test_uniform_load_out_size>
ffffffffc0204c24:	000bd617          	auipc	a2,0xbd
ffffffffc0204c28:	d1460613          	addi	a2,a2,-748 # ffffffffc02c1938 <_binary_obj___user_test_uniform_load_out_start>
    current->tf = new_tf;
ffffffffc0204c2c:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0204c2e:	85a6                	mv	a1,s1
ffffffffc0204c30:	00002517          	auipc	a0,0x2
ffffffffc0204c34:	75850513          	addi	a0,a0,1880 # ffffffffc0207388 <default_pmm_manager+0xd58>
ffffffffc0204c38:	a79ff0ef          	jal	ra,ffffffffc02046b0 <do_execve>
    asm volatile(
ffffffffc0204c3c:	8122                	mv	sp,s0
ffffffffc0204c3e:	a52fc06f          	j	ffffffffc0200e90 <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204c42:	00002617          	auipc	a2,0x2
ffffffffc0204c46:	78660613          	addi	a2,a2,1926 # ffffffffc02073c8 <default_pmm_manager+0xd98>
ffffffffc0204c4a:	3d500593          	li	a1,981
ffffffffc0204c4e:	00002517          	auipc	a0,0x2
ffffffffc0204c52:	41250513          	addi	a0,a0,1042 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204c56:	83dfb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204c5a <do_yield>:
    current->need_resched = 1;
ffffffffc0204c5a:	000f6797          	auipc	a5,0xf6
ffffffffc0204c5e:	2767b783          	ld	a5,630(a5) # ffffffffc02faed0 <current>
ffffffffc0204c62:	4705                	li	a4,1
ffffffffc0204c64:	ef98                	sd	a4,24(a5)
}
ffffffffc0204c66:	4501                	li	a0,0
ffffffffc0204c68:	8082                	ret

ffffffffc0204c6a <do_wait>:
{
ffffffffc0204c6a:	1101                	addi	sp,sp,-32
ffffffffc0204c6c:	e822                	sd	s0,16(sp)
ffffffffc0204c6e:	e426                	sd	s1,8(sp)
ffffffffc0204c70:	ec06                	sd	ra,24(sp)
ffffffffc0204c72:	842e                	mv	s0,a1
ffffffffc0204c74:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204c76:	c999                	beqz	a1,ffffffffc0204c8c <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204c78:	000f6797          	auipc	a5,0xf6
ffffffffc0204c7c:	2587b783          	ld	a5,600(a5) # ffffffffc02faed0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204c80:	7788                	ld	a0,40(a5)
ffffffffc0204c82:	4685                	li	a3,1
ffffffffc0204c84:	4611                	li	a2,4
ffffffffc0204c86:	fc1fe0ef          	jal	ra,ffffffffc0203c46 <user_mem_check>
ffffffffc0204c8a:	c909                	beqz	a0,ffffffffc0204c9c <do_wait+0x32>
ffffffffc0204c8c:	85a2                	mv	a1,s0
}
ffffffffc0204c8e:	6442                	ld	s0,16(sp)
ffffffffc0204c90:	60e2                	ld	ra,24(sp)
ffffffffc0204c92:	8526                	mv	a0,s1
ffffffffc0204c94:	64a2                	ld	s1,8(sp)
ffffffffc0204c96:	6105                	addi	sp,sp,32
ffffffffc0204c98:	f22ff06f          	j	ffffffffc02043ba <do_wait.part.0>
ffffffffc0204c9c:	60e2                	ld	ra,24(sp)
ffffffffc0204c9e:	6442                	ld	s0,16(sp)
ffffffffc0204ca0:	64a2                	ld	s1,8(sp)
ffffffffc0204ca2:	5575                	li	a0,-3
ffffffffc0204ca4:	6105                	addi	sp,sp,32
ffffffffc0204ca6:	8082                	ret

ffffffffc0204ca8 <do_kill>:
{
ffffffffc0204ca8:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204caa:	6789                	lui	a5,0x2
{
ffffffffc0204cac:	e406                	sd	ra,8(sp)
ffffffffc0204cae:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204cb0:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204cb4:	17f9                	addi	a5,a5,-2
ffffffffc0204cb6:	02e7e963          	bltu	a5,a4,ffffffffc0204ce8 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204cba:	842a                	mv	s0,a0
ffffffffc0204cbc:	45a9                	li	a1,10
ffffffffc0204cbe:	2501                	sext.w	a0,a0
ffffffffc0204cc0:	65c000ef          	jal	ra,ffffffffc020531c <hash32>
ffffffffc0204cc4:	02051793          	slli	a5,a0,0x20
ffffffffc0204cc8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204ccc:	000f2797          	auipc	a5,0xf2
ffffffffc0204cd0:	16478793          	addi	a5,a5,356 # ffffffffc02f6e30 <hash_list>
ffffffffc0204cd4:	953e                	add	a0,a0,a5
ffffffffc0204cd6:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204cd8:	a029                	j	ffffffffc0204ce2 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204cda:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204cde:	00870b63          	beq	a4,s0,ffffffffc0204cf4 <do_kill+0x4c>
ffffffffc0204ce2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204ce4:	fef51be3          	bne	a0,a5,ffffffffc0204cda <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204ce8:	5475                	li	s0,-3
}
ffffffffc0204cea:	60a2                	ld	ra,8(sp)
ffffffffc0204cec:	8522                	mv	a0,s0
ffffffffc0204cee:	6402                	ld	s0,0(sp)
ffffffffc0204cf0:	0141                	addi	sp,sp,16
ffffffffc0204cf2:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204cf4:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204cf8:	00177693          	andi	a3,a4,1
ffffffffc0204cfc:	e295                	bnez	a3,ffffffffc0204d20 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204cfe:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204d00:	00176713          	ori	a4,a4,1
ffffffffc0204d04:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204d08:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204d0a:	fe06d0e3          	bgez	a3,ffffffffc0204cea <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204d0e:	f2878513          	addi	a0,a5,-216
ffffffffc0204d12:	398000ef          	jal	ra,ffffffffc02050aa <wakeup_proc>
}
ffffffffc0204d16:	60a2                	ld	ra,8(sp)
ffffffffc0204d18:	8522                	mv	a0,s0
ffffffffc0204d1a:	6402                	ld	s0,0(sp)
ffffffffc0204d1c:	0141                	addi	sp,sp,16
ffffffffc0204d1e:	8082                	ret
        return -E_KILLED;
ffffffffc0204d20:	545d                	li	s0,-9
ffffffffc0204d22:	b7e1                	j	ffffffffc0204cea <do_kill+0x42>

ffffffffc0204d24 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204d24:	1101                	addi	sp,sp,-32
ffffffffc0204d26:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204d28:	000f6797          	auipc	a5,0xf6
ffffffffc0204d2c:	10878793          	addi	a5,a5,264 # ffffffffc02fae30 <proc_list>
ffffffffc0204d30:	ec06                	sd	ra,24(sp)
ffffffffc0204d32:	e822                	sd	s0,16(sp)
ffffffffc0204d34:	e04a                	sd	s2,0(sp)
ffffffffc0204d36:	000f2497          	auipc	s1,0xf2
ffffffffc0204d3a:	0fa48493          	addi	s1,s1,250 # ffffffffc02f6e30 <hash_list>
ffffffffc0204d3e:	e79c                	sd	a5,8(a5)
ffffffffc0204d40:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204d42:	000f6717          	auipc	a4,0xf6
ffffffffc0204d46:	0ee70713          	addi	a4,a4,238 # ffffffffc02fae30 <proc_list>
ffffffffc0204d4a:	87a6                	mv	a5,s1
ffffffffc0204d4c:	e79c                	sd	a5,8(a5)
ffffffffc0204d4e:	e39c                	sd	a5,0(a5)
ffffffffc0204d50:	07c1                	addi	a5,a5,16
ffffffffc0204d52:	fef71de3          	bne	a4,a5,ffffffffc0204d4c <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204d56:	f8dfe0ef          	jal	ra,ffffffffc0203ce2 <alloc_proc>
ffffffffc0204d5a:	000f6917          	auipc	s2,0xf6
ffffffffc0204d5e:	17e90913          	addi	s2,s2,382 # ffffffffc02faed8 <idleproc>
ffffffffc0204d62:	00a93023          	sd	a0,0(s2)
ffffffffc0204d66:	0e050f63          	beqz	a0,ffffffffc0204e64 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204d6a:	4789                	li	a5,2
ffffffffc0204d6c:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204d6e:	00004797          	auipc	a5,0x4
ffffffffc0204d72:	29278793          	addi	a5,a5,658 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d76:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204d7a:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204d7c:	4785                	li	a5,1
ffffffffc0204d7e:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d80:	4641                	li	a2,16
ffffffffc0204d82:	4581                	li	a1,0
ffffffffc0204d84:	8522                	mv	a0,s0
ffffffffc0204d86:	23d000ef          	jal	ra,ffffffffc02057c2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d8a:	463d                	li	a2,15
ffffffffc0204d8c:	00002597          	auipc	a1,0x2
ffffffffc0204d90:	67458593          	addi	a1,a1,1652 # ffffffffc0207400 <default_pmm_manager+0xdd0>
ffffffffc0204d94:	8522                	mv	a0,s0
ffffffffc0204d96:	23f000ef          	jal	ra,ffffffffc02057d4 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204d9a:	000f6717          	auipc	a4,0xf6
ffffffffc0204d9e:	14e70713          	addi	a4,a4,334 # ffffffffc02faee8 <nr_process>
ffffffffc0204da2:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204da4:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204da8:	4601                	li	a2,0
    nr_process++;
ffffffffc0204daa:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204dac:	4581                	li	a1,0
ffffffffc0204dae:	fffff517          	auipc	a0,0xfffff
ffffffffc0204db2:	7de50513          	addi	a0,a0,2014 # ffffffffc020458c <init_main>
    nr_process++;
ffffffffc0204db6:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204db8:	000f6797          	auipc	a5,0xf6
ffffffffc0204dbc:	10d7bc23          	sd	a3,280(a5) # ffffffffc02faed0 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204dc0:	c60ff0ef          	jal	ra,ffffffffc0204220 <kernel_thread>
ffffffffc0204dc4:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204dc6:	08a05363          	blez	a0,ffffffffc0204e4c <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204dca:	6789                	lui	a5,0x2
ffffffffc0204dcc:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204dd0:	17f9                	addi	a5,a5,-2
ffffffffc0204dd2:	2501                	sext.w	a0,a0
ffffffffc0204dd4:	02e7e363          	bltu	a5,a4,ffffffffc0204dfa <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204dd8:	45a9                	li	a1,10
ffffffffc0204dda:	542000ef          	jal	ra,ffffffffc020531c <hash32>
ffffffffc0204dde:	02051793          	slli	a5,a0,0x20
ffffffffc0204de2:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204de6:	96a6                	add	a3,a3,s1
ffffffffc0204de8:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204dea:	a029                	j	ffffffffc0204df4 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204dec:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x801c>
ffffffffc0204df0:	04870b63          	beq	a4,s0,ffffffffc0204e46 <proc_init+0x122>
    return listelm->next;
ffffffffc0204df4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204df6:	fef69be3          	bne	a3,a5,ffffffffc0204dec <proc_init+0xc8>
    return NULL;
ffffffffc0204dfa:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204dfc:	0b478493          	addi	s1,a5,180
ffffffffc0204e00:	4641                	li	a2,16
ffffffffc0204e02:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204e04:	000f6417          	auipc	s0,0xf6
ffffffffc0204e08:	0dc40413          	addi	s0,s0,220 # ffffffffc02faee0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e0c:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204e0e:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e10:	1b3000ef          	jal	ra,ffffffffc02057c2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e14:	463d                	li	a2,15
ffffffffc0204e16:	00002597          	auipc	a1,0x2
ffffffffc0204e1a:	61258593          	addi	a1,a1,1554 # ffffffffc0207428 <default_pmm_manager+0xdf8>
ffffffffc0204e1e:	8526                	mv	a0,s1
ffffffffc0204e20:	1b5000ef          	jal	ra,ffffffffc02057d4 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204e24:	00093783          	ld	a5,0(s2)
ffffffffc0204e28:	cbb5                	beqz	a5,ffffffffc0204e9c <proc_init+0x178>
ffffffffc0204e2a:	43dc                	lw	a5,4(a5)
ffffffffc0204e2c:	eba5                	bnez	a5,ffffffffc0204e9c <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204e2e:	601c                	ld	a5,0(s0)
ffffffffc0204e30:	c7b1                	beqz	a5,ffffffffc0204e7c <proc_init+0x158>
ffffffffc0204e32:	43d8                	lw	a4,4(a5)
ffffffffc0204e34:	4785                	li	a5,1
ffffffffc0204e36:	04f71363          	bne	a4,a5,ffffffffc0204e7c <proc_init+0x158>
}
ffffffffc0204e3a:	60e2                	ld	ra,24(sp)
ffffffffc0204e3c:	6442                	ld	s0,16(sp)
ffffffffc0204e3e:	64a2                	ld	s1,8(sp)
ffffffffc0204e40:	6902                	ld	s2,0(sp)
ffffffffc0204e42:	6105                	addi	sp,sp,32
ffffffffc0204e44:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204e46:	f2878793          	addi	a5,a5,-216
ffffffffc0204e4a:	bf4d                	j	ffffffffc0204dfc <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204e4c:	00002617          	auipc	a2,0x2
ffffffffc0204e50:	5bc60613          	addi	a2,a2,1468 # ffffffffc0207408 <default_pmm_manager+0xdd8>
ffffffffc0204e54:	41100593          	li	a1,1041
ffffffffc0204e58:	00002517          	auipc	a0,0x2
ffffffffc0204e5c:	20850513          	addi	a0,a0,520 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204e60:	e32fb0ef          	jal	ra,ffffffffc0200492 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204e64:	00002617          	auipc	a2,0x2
ffffffffc0204e68:	58460613          	addi	a2,a2,1412 # ffffffffc02073e8 <default_pmm_manager+0xdb8>
ffffffffc0204e6c:	40200593          	li	a1,1026
ffffffffc0204e70:	00002517          	auipc	a0,0x2
ffffffffc0204e74:	1f050513          	addi	a0,a0,496 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204e78:	e1afb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204e7c:	00002697          	auipc	a3,0x2
ffffffffc0204e80:	5dc68693          	addi	a3,a3,1500 # ffffffffc0207458 <default_pmm_manager+0xe28>
ffffffffc0204e84:	00001617          	auipc	a2,0x1
ffffffffc0204e88:	3fc60613          	addi	a2,a2,1020 # ffffffffc0206280 <commands+0x828>
ffffffffc0204e8c:	41800593          	li	a1,1048
ffffffffc0204e90:	00002517          	auipc	a0,0x2
ffffffffc0204e94:	1d050513          	addi	a0,a0,464 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204e98:	dfafb0ef          	jal	ra,ffffffffc0200492 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204e9c:	00002697          	auipc	a3,0x2
ffffffffc0204ea0:	59468693          	addi	a3,a3,1428 # ffffffffc0207430 <default_pmm_manager+0xe00>
ffffffffc0204ea4:	00001617          	auipc	a2,0x1
ffffffffc0204ea8:	3dc60613          	addi	a2,a2,988 # ffffffffc0206280 <commands+0x828>
ffffffffc0204eac:	41700593          	li	a1,1047
ffffffffc0204eb0:	00002517          	auipc	a0,0x2
ffffffffc0204eb4:	1b050513          	addi	a0,a0,432 # ffffffffc0207060 <default_pmm_manager+0xa30>
ffffffffc0204eb8:	ddafb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204ebc <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204ebc:	1141                	addi	sp,sp,-16
ffffffffc0204ebe:	e022                	sd	s0,0(sp)
ffffffffc0204ec0:	e406                	sd	ra,8(sp)
ffffffffc0204ec2:	000f6417          	auipc	s0,0xf6
ffffffffc0204ec6:	00e40413          	addi	s0,s0,14 # ffffffffc02faed0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204eca:	6018                	ld	a4,0(s0)
ffffffffc0204ecc:	6f1c                	ld	a5,24(a4)
ffffffffc0204ece:	dffd                	beqz	a5,ffffffffc0204ecc <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204ed0:	28c000ef          	jal	ra,ffffffffc020515c <schedule>
ffffffffc0204ed4:	bfdd                	j	ffffffffc0204eca <cpu_idle+0xe>

ffffffffc0204ed6 <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc0204ed6:	1141                	addi	sp,sp,-16
ffffffffc0204ed8:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204eda:	85aa                	mv	a1,a0
{
ffffffffc0204edc:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc0204ede:	00002517          	auipc	a0,0x2
ffffffffc0204ee2:	5a250513          	addi	a0,a0,1442 # ffffffffc0207480 <default_pmm_manager+0xe50>
{
ffffffffc0204ee6:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0204ee8:	ab0fb0ef          	jal	ra,ffffffffc0200198 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc0204eec:	000f6797          	auipc	a5,0xf6
ffffffffc0204ef0:	fe47b783          	ld	a5,-28(a5) # ffffffffc02faed0 <current>
    if (priority == 0)
ffffffffc0204ef4:	e801                	bnez	s0,ffffffffc0204f04 <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc0204ef6:	60a2                	ld	ra,8(sp)
ffffffffc0204ef8:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc0204efa:	4705                	li	a4,1
ffffffffc0204efc:	14e7a223          	sw	a4,324(a5)
}
ffffffffc0204f00:	0141                	addi	sp,sp,16
ffffffffc0204f02:	8082                	ret
ffffffffc0204f04:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc0204f06:	1487a223          	sw	s0,324(a5)
}
ffffffffc0204f0a:	6402                	ld	s0,0(sp)
ffffffffc0204f0c:	0141                	addi	sp,sp,16
ffffffffc0204f0e:	8082                	ret

ffffffffc0204f10 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204f10:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204f14:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204f18:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204f1a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204f1c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204f20:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204f24:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204f28:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204f2c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204f30:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204f34:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204f38:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204f3c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204f40:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204f44:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204f48:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204f4c:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204f4e:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204f50:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204f54:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204f58:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204f5c:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0204f60:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204f64:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204f68:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204f6c:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204f70:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204f74:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204f78:	8082                	ret

ffffffffc0204f7a <fifo_init>:
    elm->prev = elm->next = elm;
ffffffffc0204f7a:	e508                	sd	a0,8(a0)
ffffffffc0204f7c:	e108                	sd	a0,0(a0)

static void
fifo_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
ffffffffc0204f7e:	00052823          	sw	zero,16(a0)
}
ffffffffc0204f82:	8082                	ret

ffffffffc0204f84 <fifo_pick_next>:
    return listelm->next;
ffffffffc0204f84:	651c                	ld	a5,8(a0)

static struct proc_struct *
fifo_pick_next(struct run_queue *rq)
{
    list_entry_t *le = list_next(&rq->run_list);
    if (le != &rq->run_list)
ffffffffc0204f86:	00f50563          	beq	a0,a5,ffffffffc0204f90 <fifo_pick_next+0xc>
    {
        return le2proc(le, run_link);
ffffffffc0204f8a:	ef078513          	addi	a0,a5,-272
ffffffffc0204f8e:	8082                	ret
    }
    return NULL;
ffffffffc0204f90:	4501                	li	a0,0
}
ffffffffc0204f92:	8082                	ret

ffffffffc0204f94 <fifo_proc_tick>:
static void
fifo_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // FIFO scheduler: no time slice, process runs until completion
    // Never sets need_resched, allowing process to run to completion
}
ffffffffc0204f94:	8082                	ret

ffffffffc0204f96 <fifo_dequeue>:
    return list->next == list;
ffffffffc0204f96:	1185b703          	ld	a4,280(a1)
    assert(!list_empty(&proc->run_link) && proc->rq == rq);
ffffffffc0204f9a:	11058793          	addi	a5,a1,272
ffffffffc0204f9e:	02e78363          	beq	a5,a4,ffffffffc0204fc4 <fifo_dequeue+0x2e>
ffffffffc0204fa2:	1085b683          	ld	a3,264(a1)
ffffffffc0204fa6:	00a69f63          	bne	a3,a0,ffffffffc0204fc4 <fifo_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204faa:	1105b503          	ld	a0,272(a1)
    rq->proc_num--;
ffffffffc0204fae:	4a90                	lw	a2,16(a3)
    prev->next = next;
ffffffffc0204fb0:	e518                	sd	a4,8(a0)
    next->prev = prev;
ffffffffc0204fb2:	e308                	sd	a0,0(a4)
    elm->prev = elm->next = elm;
ffffffffc0204fb4:	10f5bc23          	sd	a5,280(a1)
ffffffffc0204fb8:	10f5b823          	sd	a5,272(a1)
ffffffffc0204fbc:	fff6079b          	addiw	a5,a2,-1
ffffffffc0204fc0:	ca9c                	sw	a5,16(a3)
ffffffffc0204fc2:	8082                	ret
{
ffffffffc0204fc4:	1141                	addi	sp,sp,-16
    assert(!list_empty(&proc->run_link) && proc->rq == rq);
ffffffffc0204fc6:	00002697          	auipc	a3,0x2
ffffffffc0204fca:	4d268693          	addi	a3,a3,1234 # ffffffffc0207498 <default_pmm_manager+0xe68>
ffffffffc0204fce:	00001617          	auipc	a2,0x1
ffffffffc0204fd2:	2b260613          	addi	a2,a2,690 # ffffffffc0206280 <commands+0x828>
ffffffffc0204fd6:	45e9                	li	a1,26
ffffffffc0204fd8:	00002517          	auipc	a0,0x2
ffffffffc0204fdc:	4f050513          	addi	a0,a0,1264 # ffffffffc02074c8 <default_pmm_manager+0xe98>
{
ffffffffc0204fe0:	e406                	sd	ra,8(sp)
    assert(!list_empty(&proc->run_link) && proc->rq == rq);
ffffffffc0204fe2:	cb0fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0204fe6 <fifo_enqueue>:
    assert(list_empty(&proc->run_link));
ffffffffc0204fe6:	1185b703          	ld	a4,280(a1)
ffffffffc0204fea:	11058793          	addi	a5,a1,272
ffffffffc0204fee:	02e79063          	bne	a5,a4,ffffffffc020500e <fifo_enqueue+0x28>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0204ff2:	6114                	ld	a3,0(a0)
    rq->proc_num++;
ffffffffc0204ff4:	4918                	lw	a4,16(a0)
    prev->next = next->prev = elm;
ffffffffc0204ff6:	e11c                	sd	a5,0(a0)
ffffffffc0204ff8:	e69c                	sd	a5,8(a3)
    elm->next = next;
ffffffffc0204ffa:	10a5bc23          	sd	a0,280(a1)
    elm->prev = prev;
ffffffffc0204ffe:	10d5b823          	sd	a3,272(a1)
    proc->rq = rq;
ffffffffc0205002:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc0205006:	0017079b          	addiw	a5,a4,1
ffffffffc020500a:	c91c                	sw	a5,16(a0)
ffffffffc020500c:	8082                	ret
{
ffffffffc020500e:	1141                	addi	sp,sp,-16
    assert(list_empty(&proc->run_link));
ffffffffc0205010:	00002697          	auipc	a3,0x2
ffffffffc0205014:	4e068693          	addi	a3,a3,1248 # ffffffffc02074f0 <default_pmm_manager+0xec0>
ffffffffc0205018:	00001617          	auipc	a2,0x1
ffffffffc020501c:	26860613          	addi	a2,a2,616 # ffffffffc0206280 <commands+0x828>
ffffffffc0205020:	45c5                	li	a1,17
ffffffffc0205022:	00002517          	auipc	a0,0x2
ffffffffc0205026:	4a650513          	addi	a0,a0,1190 # ffffffffc02074c8 <default_pmm_manager+0xe98>
{
ffffffffc020502a:	e406                	sd	ra,8(sp)
    assert(list_empty(&proc->run_link));
ffffffffc020502c:	c66fb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc0205030 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc)
ffffffffc0205030:	000f6797          	auipc	a5,0xf6
ffffffffc0205034:	ea87b783          	ld	a5,-344(a5) # ffffffffc02faed8 <idleproc>
{
ffffffffc0205038:	85aa                	mv	a1,a0
    if (proc != idleproc)
ffffffffc020503a:	00a78c63          	beq	a5,a0,ffffffffc0205052 <sched_class_proc_tick+0x22>
    {
        sched_class->proc_tick(rq, proc);
ffffffffc020503e:	000f6797          	auipc	a5,0xf6
ffffffffc0205042:	eba7b783          	ld	a5,-326(a5) # ffffffffc02faef8 <sched_class>
ffffffffc0205046:	779c                	ld	a5,40(a5)
ffffffffc0205048:	000f6517          	auipc	a0,0xf6
ffffffffc020504c:	ea853503          	ld	a0,-344(a0) # ffffffffc02faef0 <rq>
ffffffffc0205050:	8782                	jr	a5
    }
    else
    {
        proc->need_resched = 1;
ffffffffc0205052:	4705                	li	a4,1
ffffffffc0205054:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc0205056:	8082                	ret

ffffffffc0205058 <sched_init>:

static struct run_queue __rq;

void sched_init(void)
{
ffffffffc0205058:	1141                	addi	sp,sp,-16
#if SCHED_CLASS == SCHED_RR
    sched_class = &default_sched_class;
#elif SCHED_CLASS == SCHED_STRIDE
    sched_class = &stride_sched_class;
#elif SCHED_CLASS == SCHED_FIFO
    sched_class = &fifo_sched_class;
ffffffffc020505a:	000f2717          	auipc	a4,0xf2
ffffffffc020505e:	97e70713          	addi	a4,a4,-1666 # ffffffffc02f69d8 <fifo_sched_class>
{
ffffffffc0205062:	e022                	sd	s0,0(sp)
ffffffffc0205064:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205066:	000f6797          	auipc	a5,0xf6
ffffffffc020506a:	dfa78793          	addi	a5,a5,-518 # ffffffffc02fae60 <timer_list>
    sched_class = &default_sched_class;  // Default to RR
#endif

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc020506e:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0205070:	000f6517          	auipc	a0,0xf6
ffffffffc0205074:	dd050513          	addi	a0,a0,-560 # ffffffffc02fae40 <__rq>
ffffffffc0205078:	e79c                	sd	a5,8(a5)
ffffffffc020507a:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc020507c:	4795                	li	a5,5
ffffffffc020507e:	c95c                	sw	a5,20(a0)
    sched_class = &fifo_sched_class;
ffffffffc0205080:	000f6417          	auipc	s0,0xf6
ffffffffc0205084:	e7840413          	addi	s0,s0,-392 # ffffffffc02faef8 <sched_class>
    rq = &__rq;
ffffffffc0205088:	000f6797          	auipc	a5,0xf6
ffffffffc020508c:	e6a7b423          	sd	a0,-408(a5) # ffffffffc02faef0 <rq>
    sched_class = &fifo_sched_class;
ffffffffc0205090:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc0205092:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205094:	601c                	ld	a5,0(s0)
}
ffffffffc0205096:	6402                	ld	s0,0(sp)
ffffffffc0205098:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020509a:	638c                	ld	a1,0(a5)
ffffffffc020509c:	00002517          	auipc	a0,0x2
ffffffffc02050a0:	47c50513          	addi	a0,a0,1148 # ffffffffc0207518 <default_pmm_manager+0xee8>
}
ffffffffc02050a4:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc02050a6:	8f2fb06f          	j	ffffffffc0200198 <cprintf>

ffffffffc02050aa <wakeup_proc>:

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02050aa:	4118                	lw	a4,0(a0)
{
ffffffffc02050ac:	1101                	addi	sp,sp,-32
ffffffffc02050ae:	ec06                	sd	ra,24(sp)
ffffffffc02050b0:	e822                	sd	s0,16(sp)
ffffffffc02050b2:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02050b4:	478d                	li	a5,3
ffffffffc02050b6:	08f70363          	beq	a4,a5,ffffffffc020513c <wakeup_proc+0x92>
ffffffffc02050ba:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050bc:	100027f3          	csrr	a5,sstatus
ffffffffc02050c0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02050c2:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050c4:	e7bd                	bnez	a5,ffffffffc0205132 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc02050c6:	4789                	li	a5,2
ffffffffc02050c8:	04f70863          	beq	a4,a5,ffffffffc0205118 <wakeup_proc+0x6e>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc02050cc:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02050ce:	0e042623          	sw	zero,236(s0)
            if (proc != current)
ffffffffc02050d2:	000f6797          	auipc	a5,0xf6
ffffffffc02050d6:	dfe7b783          	ld	a5,-514(a5) # ffffffffc02faed0 <current>
ffffffffc02050da:	02878363          	beq	a5,s0,ffffffffc0205100 <wakeup_proc+0x56>
    if (proc != idleproc)
ffffffffc02050de:	000f6797          	auipc	a5,0xf6
ffffffffc02050e2:	dfa7b783          	ld	a5,-518(a5) # ffffffffc02faed8 <idleproc>
ffffffffc02050e6:	00f40d63          	beq	s0,a5,ffffffffc0205100 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc02050ea:	000f6797          	auipc	a5,0xf6
ffffffffc02050ee:	e0e7b783          	ld	a5,-498(a5) # ffffffffc02faef8 <sched_class>
ffffffffc02050f2:	6b9c                	ld	a5,16(a5)
ffffffffc02050f4:	85a2                	mv	a1,s0
ffffffffc02050f6:	000f6517          	auipc	a0,0xf6
ffffffffc02050fa:	dfa53503          	ld	a0,-518(a0) # ffffffffc02faef0 <rq>
ffffffffc02050fe:	9782                	jalr	a5
    if (flag)
ffffffffc0205100:	e491                	bnez	s1,ffffffffc020510c <wakeup_proc+0x62>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205102:	60e2                	ld	ra,24(sp)
ffffffffc0205104:	6442                	ld	s0,16(sp)
ffffffffc0205106:	64a2                	ld	s1,8(sp)
ffffffffc0205108:	6105                	addi	sp,sp,32
ffffffffc020510a:	8082                	ret
ffffffffc020510c:	6442                	ld	s0,16(sp)
ffffffffc020510e:	60e2                	ld	ra,24(sp)
ffffffffc0205110:	64a2                	ld	s1,8(sp)
ffffffffc0205112:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205114:	895fb06f          	j	ffffffffc02009a8 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205118:	00002617          	auipc	a2,0x2
ffffffffc020511c:	45060613          	addi	a2,a2,1104 # ffffffffc0207568 <default_pmm_manager+0xf38>
ffffffffc0205120:	06d00593          	li	a1,109
ffffffffc0205124:	00002517          	auipc	a0,0x2
ffffffffc0205128:	42c50513          	addi	a0,a0,1068 # ffffffffc0207550 <default_pmm_manager+0xf20>
ffffffffc020512c:	bcefb0ef          	jal	ra,ffffffffc02004fa <__warn>
ffffffffc0205130:	bfc1                	j	ffffffffc0205100 <wakeup_proc+0x56>
        intr_disable();
ffffffffc0205132:	87dfb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205136:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205138:	4485                	li	s1,1
ffffffffc020513a:	b771                	j	ffffffffc02050c6 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020513c:	00002697          	auipc	a3,0x2
ffffffffc0205140:	3f468693          	addi	a3,a3,1012 # ffffffffc0207530 <default_pmm_manager+0xf00>
ffffffffc0205144:	00001617          	auipc	a2,0x1
ffffffffc0205148:	13c60613          	addi	a2,a2,316 # ffffffffc0206280 <commands+0x828>
ffffffffc020514c:	05e00593          	li	a1,94
ffffffffc0205150:	00002517          	auipc	a0,0x2
ffffffffc0205154:	40050513          	addi	a0,a0,1024 # ffffffffc0207550 <default_pmm_manager+0xf20>
ffffffffc0205158:	b3afb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020515c <schedule>:

void schedule(void)
{
ffffffffc020515c:	7179                	addi	sp,sp,-48
ffffffffc020515e:	f406                	sd	ra,40(sp)
ffffffffc0205160:	f022                	sd	s0,32(sp)
ffffffffc0205162:	ec26                	sd	s1,24(sp)
ffffffffc0205164:	e84a                	sd	s2,16(sp)
ffffffffc0205166:	e44e                	sd	s3,8(sp)
ffffffffc0205168:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020516a:	100027f3          	csrr	a5,sstatus
ffffffffc020516e:	8b89                	andi	a5,a5,2
ffffffffc0205170:	4a01                	li	s4,0
ffffffffc0205172:	e3cd                	bnez	a5,ffffffffc0205214 <schedule+0xb8>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205174:	000f6497          	auipc	s1,0xf6
ffffffffc0205178:	d5c48493          	addi	s1,s1,-676 # ffffffffc02faed0 <current>
ffffffffc020517c:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc020517e:	000f6997          	auipc	s3,0xf6
ffffffffc0205182:	d7a98993          	addi	s3,s3,-646 # ffffffffc02faef8 <sched_class>
ffffffffc0205186:	000f6917          	auipc	s2,0xf6
ffffffffc020518a:	d6a90913          	addi	s2,s2,-662 # ffffffffc02faef0 <rq>
        if (current->state == PROC_RUNNABLE)
ffffffffc020518e:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0205190:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE)
ffffffffc0205194:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc0205196:	0009b783          	ld	a5,0(s3)
ffffffffc020519a:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE)
ffffffffc020519e:	04e68e63          	beq	a3,a4,ffffffffc02051fa <schedule+0x9e>
    return sched_class->pick_next(rq);
ffffffffc02051a2:	739c                	ld	a5,32(a5)
ffffffffc02051a4:	9782                	jalr	a5
ffffffffc02051a6:	842a                	mv	s0,a0
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc02051a8:	c521                	beqz	a0,ffffffffc02051f0 <schedule+0x94>
    sched_class->dequeue(rq, proc);
ffffffffc02051aa:	0009b783          	ld	a5,0(s3)
ffffffffc02051ae:	00093503          	ld	a0,0(s2)
ffffffffc02051b2:	85a2                	mv	a1,s0
ffffffffc02051b4:	6f9c                	ld	a5,24(a5)
ffffffffc02051b6:	9782                	jalr	a5
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02051b8:	441c                	lw	a5,8(s0)
        if (next != current)
ffffffffc02051ba:	6098                	ld	a4,0(s1)
        next->runs++;
ffffffffc02051bc:	2785                	addiw	a5,a5,1
ffffffffc02051be:	c41c                	sw	a5,8(s0)
        if (next != current)
ffffffffc02051c0:	00870563          	beq	a4,s0,ffffffffc02051ca <schedule+0x6e>
        {
            proc_run(next);
ffffffffc02051c4:	8522                	mv	a0,s0
ffffffffc02051c6:	c4bfe0ef          	jal	ra,ffffffffc0203e10 <proc_run>
    if (flag)
ffffffffc02051ca:	000a1a63          	bnez	s4,ffffffffc02051de <schedule+0x82>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02051ce:	70a2                	ld	ra,40(sp)
ffffffffc02051d0:	7402                	ld	s0,32(sp)
ffffffffc02051d2:	64e2                	ld	s1,24(sp)
ffffffffc02051d4:	6942                	ld	s2,16(sp)
ffffffffc02051d6:	69a2                	ld	s3,8(sp)
ffffffffc02051d8:	6a02                	ld	s4,0(sp)
ffffffffc02051da:	6145                	addi	sp,sp,48
ffffffffc02051dc:	8082                	ret
ffffffffc02051de:	7402                	ld	s0,32(sp)
ffffffffc02051e0:	70a2                	ld	ra,40(sp)
ffffffffc02051e2:	64e2                	ld	s1,24(sp)
ffffffffc02051e4:	6942                	ld	s2,16(sp)
ffffffffc02051e6:	69a2                	ld	s3,8(sp)
ffffffffc02051e8:	6a02                	ld	s4,0(sp)
ffffffffc02051ea:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02051ec:	fbcfb06f          	j	ffffffffc02009a8 <intr_enable>
            next = idleproc;
ffffffffc02051f0:	000f6417          	auipc	s0,0xf6
ffffffffc02051f4:	ce843403          	ld	s0,-792(s0) # ffffffffc02faed8 <idleproc>
ffffffffc02051f8:	b7c1                	j	ffffffffc02051b8 <schedule+0x5c>
    if (proc != idleproc)
ffffffffc02051fa:	000f6717          	auipc	a4,0xf6
ffffffffc02051fe:	cde73703          	ld	a4,-802(a4) # ffffffffc02faed8 <idleproc>
ffffffffc0205202:	fae580e3          	beq	a1,a4,ffffffffc02051a2 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc0205206:	6b9c                	ld	a5,16(a5)
ffffffffc0205208:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc020520a:	0009b783          	ld	a5,0(s3)
ffffffffc020520e:	00093503          	ld	a0,0(s2)
ffffffffc0205212:	bf41                	j	ffffffffc02051a2 <schedule+0x46>
        intr_disable();
ffffffffc0205214:	f9afb0ef          	jal	ra,ffffffffc02009ae <intr_disable>
        return 1;
ffffffffc0205218:	4a05                	li	s4,1
ffffffffc020521a:	bfa9                	j	ffffffffc0205174 <schedule+0x18>

ffffffffc020521c <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020521c:	000f6797          	auipc	a5,0xf6
ffffffffc0205220:	cb47b783          	ld	a5,-844(a5) # ffffffffc02faed0 <current>
}
ffffffffc0205224:	43c8                	lw	a0,4(a5)
ffffffffc0205226:	8082                	ret

ffffffffc0205228 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205228:	4501                	li	a0,0
ffffffffc020522a:	8082                	ret

ffffffffc020522c <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc020522c:	000f6797          	auipc	a5,0xf6
ffffffffc0205230:	c4c7b783          	ld	a5,-948(a5) # ffffffffc02fae78 <ticks>
ffffffffc0205234:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205238:	9d3d                	addw	a0,a0,a5
}
ffffffffc020523a:	0015151b          	slliw	a0,a0,0x1
ffffffffc020523e:	8082                	ret

ffffffffc0205240 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205240:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205242:	1141                	addi	sp,sp,-16
ffffffffc0205244:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205246:	c91ff0ef          	jal	ra,ffffffffc0204ed6 <lab6_set_priority>
    return 0;
}
ffffffffc020524a:	60a2                	ld	ra,8(sp)
ffffffffc020524c:	4501                	li	a0,0
ffffffffc020524e:	0141                	addi	sp,sp,16
ffffffffc0205250:	8082                	ret

ffffffffc0205252 <sys_putc>:
    cputchar(c);
ffffffffc0205252:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205254:	1141                	addi	sp,sp,-16
ffffffffc0205256:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205258:	f77fa0ef          	jal	ra,ffffffffc02001ce <cputchar>
}
ffffffffc020525c:	60a2                	ld	ra,8(sp)
ffffffffc020525e:	4501                	li	a0,0
ffffffffc0205260:	0141                	addi	sp,sp,16
ffffffffc0205262:	8082                	ret

ffffffffc0205264 <sys_kill>:
    return do_kill(pid);
ffffffffc0205264:	4108                	lw	a0,0(a0)
ffffffffc0205266:	a43ff06f          	j	ffffffffc0204ca8 <do_kill>

ffffffffc020526a <sys_yield>:
    return do_yield();
ffffffffc020526a:	9f1ff06f          	j	ffffffffc0204c5a <do_yield>

ffffffffc020526e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020526e:	6d14                	ld	a3,24(a0)
ffffffffc0205270:	6910                	ld	a2,16(a0)
ffffffffc0205272:	650c                	ld	a1,8(a0)
ffffffffc0205274:	6108                	ld	a0,0(a0)
ffffffffc0205276:	c3aff06f          	j	ffffffffc02046b0 <do_execve>

ffffffffc020527a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020527a:	650c                	ld	a1,8(a0)
ffffffffc020527c:	4108                	lw	a0,0(a0)
ffffffffc020527e:	9edff06f          	j	ffffffffc0204c6a <do_wait>

ffffffffc0205282 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205282:	000f6797          	auipc	a5,0xf6
ffffffffc0205286:	c4e7b783          	ld	a5,-946(a5) # ffffffffc02faed0 <current>
ffffffffc020528a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020528c:	4501                	li	a0,0
ffffffffc020528e:	6a0c                	ld	a1,16(a2)
ffffffffc0205290:	be5fe06f          	j	ffffffffc0203e74 <do_fork>

ffffffffc0205294 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205294:	4108                	lw	a0,0(a0)
ffffffffc0205296:	fdbfe06f          	j	ffffffffc0204270 <do_exit>

ffffffffc020529a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020529a:	715d                	addi	sp,sp,-80
ffffffffc020529c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020529e:	000f6497          	auipc	s1,0xf6
ffffffffc02052a2:	c3248493          	addi	s1,s1,-974 # ffffffffc02faed0 <current>
ffffffffc02052a6:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02052a8:	e0a2                	sd	s0,64(sp)
ffffffffc02052aa:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02052ac:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02052ae:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02052b0:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc02052b4:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02052b8:	0327ee63          	bltu	a5,s2,ffffffffc02052f4 <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc02052bc:	00391713          	slli	a4,s2,0x3
ffffffffc02052c0:	00002797          	auipc	a5,0x2
ffffffffc02052c4:	31078793          	addi	a5,a5,784 # ffffffffc02075d0 <syscalls>
ffffffffc02052c8:	97ba                	add	a5,a5,a4
ffffffffc02052ca:	639c                	ld	a5,0(a5)
ffffffffc02052cc:	c785                	beqz	a5,ffffffffc02052f4 <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc02052ce:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02052d0:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02052d2:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02052d4:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02052d6:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02052d8:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02052da:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02052dc:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02052de:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02052e0:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02052e2:	0028                	addi	a0,sp,8
ffffffffc02052e4:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02052e6:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02052e8:	e828                	sd	a0,80(s0)
}
ffffffffc02052ea:	6406                	ld	s0,64(sp)
ffffffffc02052ec:	74e2                	ld	s1,56(sp)
ffffffffc02052ee:	7942                	ld	s2,48(sp)
ffffffffc02052f0:	6161                	addi	sp,sp,80
ffffffffc02052f2:	8082                	ret
    print_trapframe(tf);
ffffffffc02052f4:	8522                	mv	a0,s0
ffffffffc02052f6:	8a9fb0ef          	jal	ra,ffffffffc0200b9e <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02052fa:	609c                	ld	a5,0(s1)
ffffffffc02052fc:	86ca                	mv	a3,s2
ffffffffc02052fe:	00002617          	auipc	a2,0x2
ffffffffc0205302:	28a60613          	addi	a2,a2,650 # ffffffffc0207588 <default_pmm_manager+0xf58>
ffffffffc0205306:	43d8                	lw	a4,4(a5)
ffffffffc0205308:	06c00593          	li	a1,108
ffffffffc020530c:	0b478793          	addi	a5,a5,180
ffffffffc0205310:	00002517          	auipc	a0,0x2
ffffffffc0205314:	2a850513          	addi	a0,a0,680 # ffffffffc02075b8 <default_pmm_manager+0xf88>
ffffffffc0205318:	97afb0ef          	jal	ra,ffffffffc0200492 <__panic>

ffffffffc020531c <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020531c:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205320:	2785                	addiw	a5,a5,1
ffffffffc0205322:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205326:	02000793          	li	a5,32
ffffffffc020532a:	9f8d                	subw	a5,a5,a1
}
ffffffffc020532c:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205330:	8082                	ret

ffffffffc0205332 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205332:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205336:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205338:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020533c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020533e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205342:	f022                	sd	s0,32(sp)
ffffffffc0205344:	ec26                	sd	s1,24(sp)
ffffffffc0205346:	e84a                	sd	s2,16(sp)
ffffffffc0205348:	f406                	sd	ra,40(sp)
ffffffffc020534a:	e44e                	sd	s3,8(sp)
ffffffffc020534c:	84aa                	mv	s1,a0
ffffffffc020534e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205350:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205354:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205356:	03067e63          	bgeu	a2,a6,ffffffffc0205392 <printnum+0x60>
ffffffffc020535a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020535c:	00805763          	blez	s0,ffffffffc020536a <printnum+0x38>
ffffffffc0205360:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205362:	85ca                	mv	a1,s2
ffffffffc0205364:	854e                	mv	a0,s3
ffffffffc0205366:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205368:	fc65                	bnez	s0,ffffffffc0205360 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020536a:	1a02                	slli	s4,s4,0x20
ffffffffc020536c:	00003797          	auipc	a5,0x3
ffffffffc0205370:	a6478793          	addi	a5,a5,-1436 # ffffffffc0207dd0 <syscalls+0x800>
ffffffffc0205374:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205378:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020537a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020537c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205380:	70a2                	ld	ra,40(sp)
ffffffffc0205382:	69a2                	ld	s3,8(sp)
ffffffffc0205384:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205386:	85ca                	mv	a1,s2
ffffffffc0205388:	87a6                	mv	a5,s1
}
ffffffffc020538a:	6942                	ld	s2,16(sp)
ffffffffc020538c:	64e2                	ld	s1,24(sp)
ffffffffc020538e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205390:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205392:	03065633          	divu	a2,a2,a6
ffffffffc0205396:	8722                	mv	a4,s0
ffffffffc0205398:	f9bff0ef          	jal	ra,ffffffffc0205332 <printnum>
ffffffffc020539c:	b7f9                	j	ffffffffc020536a <printnum+0x38>

ffffffffc020539e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020539e:	7119                	addi	sp,sp,-128
ffffffffc02053a0:	f4a6                	sd	s1,104(sp)
ffffffffc02053a2:	f0ca                	sd	s2,96(sp)
ffffffffc02053a4:	ecce                	sd	s3,88(sp)
ffffffffc02053a6:	e8d2                	sd	s4,80(sp)
ffffffffc02053a8:	e4d6                	sd	s5,72(sp)
ffffffffc02053aa:	e0da                	sd	s6,64(sp)
ffffffffc02053ac:	fc5e                	sd	s7,56(sp)
ffffffffc02053ae:	f06a                	sd	s10,32(sp)
ffffffffc02053b0:	fc86                	sd	ra,120(sp)
ffffffffc02053b2:	f8a2                	sd	s0,112(sp)
ffffffffc02053b4:	f862                	sd	s8,48(sp)
ffffffffc02053b6:	f466                	sd	s9,40(sp)
ffffffffc02053b8:	ec6e                	sd	s11,24(sp)
ffffffffc02053ba:	892a                	mv	s2,a0
ffffffffc02053bc:	84ae                	mv	s1,a1
ffffffffc02053be:	8d32                	mv	s10,a2
ffffffffc02053c0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02053c2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02053c6:	5b7d                	li	s6,-1
ffffffffc02053c8:	00003a97          	auipc	s5,0x3
ffffffffc02053cc:	a34a8a93          	addi	s5,s5,-1484 # ffffffffc0207dfc <syscalls+0x82c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02053d0:	00003b97          	auipc	s7,0x3
ffffffffc02053d4:	c48b8b93          	addi	s7,s7,-952 # ffffffffc0208018 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02053d8:	000d4503          	lbu	a0,0(s10)
ffffffffc02053dc:	001d0413          	addi	s0,s10,1
ffffffffc02053e0:	01350a63          	beq	a0,s3,ffffffffc02053f4 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02053e4:	c121                	beqz	a0,ffffffffc0205424 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02053e6:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02053e8:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02053ea:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02053ec:	fff44503          	lbu	a0,-1(s0)
ffffffffc02053f0:	ff351ae3          	bne	a0,s3,ffffffffc02053e4 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053f4:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02053f8:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02053fc:	4c81                	li	s9,0
ffffffffc02053fe:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205400:	5c7d                	li	s8,-1
ffffffffc0205402:	5dfd                	li	s11,-1
ffffffffc0205404:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205408:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020540a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020540e:	0ff5f593          	zext.b	a1,a1
ffffffffc0205412:	00140d13          	addi	s10,s0,1
ffffffffc0205416:	04b56263          	bltu	a0,a1,ffffffffc020545a <vprintfmt+0xbc>
ffffffffc020541a:	058a                	slli	a1,a1,0x2
ffffffffc020541c:	95d6                	add	a1,a1,s5
ffffffffc020541e:	4194                	lw	a3,0(a1)
ffffffffc0205420:	96d6                	add	a3,a3,s5
ffffffffc0205422:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205424:	70e6                	ld	ra,120(sp)
ffffffffc0205426:	7446                	ld	s0,112(sp)
ffffffffc0205428:	74a6                	ld	s1,104(sp)
ffffffffc020542a:	7906                	ld	s2,96(sp)
ffffffffc020542c:	69e6                	ld	s3,88(sp)
ffffffffc020542e:	6a46                	ld	s4,80(sp)
ffffffffc0205430:	6aa6                	ld	s5,72(sp)
ffffffffc0205432:	6b06                	ld	s6,64(sp)
ffffffffc0205434:	7be2                	ld	s7,56(sp)
ffffffffc0205436:	7c42                	ld	s8,48(sp)
ffffffffc0205438:	7ca2                	ld	s9,40(sp)
ffffffffc020543a:	7d02                	ld	s10,32(sp)
ffffffffc020543c:	6de2                	ld	s11,24(sp)
ffffffffc020543e:	6109                	addi	sp,sp,128
ffffffffc0205440:	8082                	ret
            padc = '0';
ffffffffc0205442:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205444:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205448:	846a                	mv	s0,s10
ffffffffc020544a:	00140d13          	addi	s10,s0,1
ffffffffc020544e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205452:	0ff5f593          	zext.b	a1,a1
ffffffffc0205456:	fcb572e3          	bgeu	a0,a1,ffffffffc020541a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020545a:	85a6                	mv	a1,s1
ffffffffc020545c:	02500513          	li	a0,37
ffffffffc0205460:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205462:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205466:	8d22                	mv	s10,s0
ffffffffc0205468:	f73788e3          	beq	a5,s3,ffffffffc02053d8 <vprintfmt+0x3a>
ffffffffc020546c:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205470:	1d7d                	addi	s10,s10,-1
ffffffffc0205472:	ff379de3          	bne	a5,s3,ffffffffc020546c <vprintfmt+0xce>
ffffffffc0205476:	b78d                	j	ffffffffc02053d8 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205478:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020547c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205480:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205482:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205486:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020548a:	02d86463          	bltu	a6,a3,ffffffffc02054b2 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020548e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205492:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205496:	0186873b          	addw	a4,a3,s8
ffffffffc020549a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020549e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02054a0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02054a4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02054a6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02054aa:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02054ae:	fed870e3          	bgeu	a6,a3,ffffffffc020548e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02054b2:	f40ddce3          	bgez	s11,ffffffffc020540a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02054b6:	8de2                	mv	s11,s8
ffffffffc02054b8:	5c7d                	li	s8,-1
ffffffffc02054ba:	bf81                	j	ffffffffc020540a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02054bc:	fffdc693          	not	a3,s11
ffffffffc02054c0:	96fd                	srai	a3,a3,0x3f
ffffffffc02054c2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054c6:	00144603          	lbu	a2,1(s0)
ffffffffc02054ca:	2d81                	sext.w	s11,s11
ffffffffc02054cc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02054ce:	bf35                	j	ffffffffc020540a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02054d0:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054d4:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02054d8:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054da:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02054dc:	bfd9                	j	ffffffffc02054b2 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02054de:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02054e0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02054e4:	01174463          	blt	a4,a7,ffffffffc02054ec <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02054e8:	1a088e63          	beqz	a7,ffffffffc02056a4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02054ec:	000a3603          	ld	a2,0(s4)
ffffffffc02054f0:	46c1                	li	a3,16
ffffffffc02054f2:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02054f4:	2781                	sext.w	a5,a5
ffffffffc02054f6:	876e                	mv	a4,s11
ffffffffc02054f8:	85a6                	mv	a1,s1
ffffffffc02054fa:	854a                	mv	a0,s2
ffffffffc02054fc:	e37ff0ef          	jal	ra,ffffffffc0205332 <printnum>
            break;
ffffffffc0205500:	bde1                	j	ffffffffc02053d8 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205502:	000a2503          	lw	a0,0(s4)
ffffffffc0205506:	85a6                	mv	a1,s1
ffffffffc0205508:	0a21                	addi	s4,s4,8
ffffffffc020550a:	9902                	jalr	s2
            break;
ffffffffc020550c:	b5f1                	j	ffffffffc02053d8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020550e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205510:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205514:	01174463          	blt	a4,a7,ffffffffc020551c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205518:	18088163          	beqz	a7,ffffffffc020569a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020551c:	000a3603          	ld	a2,0(s4)
ffffffffc0205520:	46a9                	li	a3,10
ffffffffc0205522:	8a2e                	mv	s4,a1
ffffffffc0205524:	bfc1                	j	ffffffffc02054f4 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205526:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020552a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020552c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020552e:	bdf1                	j	ffffffffc020540a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205530:	85a6                	mv	a1,s1
ffffffffc0205532:	02500513          	li	a0,37
ffffffffc0205536:	9902                	jalr	s2
            break;
ffffffffc0205538:	b545                	j	ffffffffc02053d8 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020553a:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020553e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205540:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205542:	b5e1                	j	ffffffffc020540a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205544:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205546:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020554a:	01174463          	blt	a4,a7,ffffffffc0205552 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020554e:	14088163          	beqz	a7,ffffffffc0205690 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205552:	000a3603          	ld	a2,0(s4)
ffffffffc0205556:	46a1                	li	a3,8
ffffffffc0205558:	8a2e                	mv	s4,a1
ffffffffc020555a:	bf69                	j	ffffffffc02054f4 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020555c:	03000513          	li	a0,48
ffffffffc0205560:	85a6                	mv	a1,s1
ffffffffc0205562:	e03e                	sd	a5,0(sp)
ffffffffc0205564:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205566:	85a6                	mv	a1,s1
ffffffffc0205568:	07800513          	li	a0,120
ffffffffc020556c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020556e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205570:	6782                	ld	a5,0(sp)
ffffffffc0205572:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205574:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205578:	bfb5                	j	ffffffffc02054f4 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020557a:	000a3403          	ld	s0,0(s4)
ffffffffc020557e:	008a0713          	addi	a4,s4,8
ffffffffc0205582:	e03a                	sd	a4,0(sp)
ffffffffc0205584:	14040263          	beqz	s0,ffffffffc02056c8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205588:	0fb05763          	blez	s11,ffffffffc0205676 <vprintfmt+0x2d8>
ffffffffc020558c:	02d00693          	li	a3,45
ffffffffc0205590:	0cd79163          	bne	a5,a3,ffffffffc0205652 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205594:	00044783          	lbu	a5,0(s0)
ffffffffc0205598:	0007851b          	sext.w	a0,a5
ffffffffc020559c:	cf85                	beqz	a5,ffffffffc02055d4 <vprintfmt+0x236>
ffffffffc020559e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055a2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055a6:	000c4563          	bltz	s8,ffffffffc02055b0 <vprintfmt+0x212>
ffffffffc02055aa:	3c7d                	addiw	s8,s8,-1
ffffffffc02055ac:	036c0263          	beq	s8,s6,ffffffffc02055d0 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02055b0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055b2:	0e0c8e63          	beqz	s9,ffffffffc02056ae <vprintfmt+0x310>
ffffffffc02055b6:	3781                	addiw	a5,a5,-32
ffffffffc02055b8:	0ef47b63          	bgeu	s0,a5,ffffffffc02056ae <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02055bc:	03f00513          	li	a0,63
ffffffffc02055c0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055c2:	000a4783          	lbu	a5,0(s4)
ffffffffc02055c6:	3dfd                	addiw	s11,s11,-1
ffffffffc02055c8:	0a05                	addi	s4,s4,1
ffffffffc02055ca:	0007851b          	sext.w	a0,a5
ffffffffc02055ce:	ffe1                	bnez	a5,ffffffffc02055a6 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02055d0:	01b05963          	blez	s11,ffffffffc02055e2 <vprintfmt+0x244>
ffffffffc02055d4:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02055d6:	85a6                	mv	a1,s1
ffffffffc02055d8:	02000513          	li	a0,32
ffffffffc02055dc:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02055de:	fe0d9be3          	bnez	s11,ffffffffc02055d4 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02055e2:	6a02                	ld	s4,0(sp)
ffffffffc02055e4:	bbd5                	j	ffffffffc02053d8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02055e6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055e8:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02055ec:	01174463          	blt	a4,a7,ffffffffc02055f4 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02055f0:	08088d63          	beqz	a7,ffffffffc020568a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02055f4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02055f8:	0a044d63          	bltz	s0,ffffffffc02056b2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02055fc:	8622                	mv	a2,s0
ffffffffc02055fe:	8a66                	mv	s4,s9
ffffffffc0205600:	46a9                	li	a3,10
ffffffffc0205602:	bdcd                	j	ffffffffc02054f4 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205604:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205608:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020560a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020560c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205610:	8fb5                	xor	a5,a5,a3
ffffffffc0205612:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205616:	02d74163          	blt	a4,a3,ffffffffc0205638 <vprintfmt+0x29a>
ffffffffc020561a:	00369793          	slli	a5,a3,0x3
ffffffffc020561e:	97de                	add	a5,a5,s7
ffffffffc0205620:	639c                	ld	a5,0(a5)
ffffffffc0205622:	cb99                	beqz	a5,ffffffffc0205638 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205624:	86be                	mv	a3,a5
ffffffffc0205626:	00000617          	auipc	a2,0x0
ffffffffc020562a:	1f260613          	addi	a2,a2,498 # ffffffffc0205818 <etext+0x2c>
ffffffffc020562e:	85a6                	mv	a1,s1
ffffffffc0205630:	854a                	mv	a0,s2
ffffffffc0205632:	0ce000ef          	jal	ra,ffffffffc0205700 <printfmt>
ffffffffc0205636:	b34d                	j	ffffffffc02053d8 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205638:	00002617          	auipc	a2,0x2
ffffffffc020563c:	7b860613          	addi	a2,a2,1976 # ffffffffc0207df0 <syscalls+0x820>
ffffffffc0205640:	85a6                	mv	a1,s1
ffffffffc0205642:	854a                	mv	a0,s2
ffffffffc0205644:	0bc000ef          	jal	ra,ffffffffc0205700 <printfmt>
ffffffffc0205648:	bb41                	j	ffffffffc02053d8 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020564a:	00002417          	auipc	s0,0x2
ffffffffc020564e:	79e40413          	addi	s0,s0,1950 # ffffffffc0207de8 <syscalls+0x818>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205652:	85e2                	mv	a1,s8
ffffffffc0205654:	8522                	mv	a0,s0
ffffffffc0205656:	e43e                	sd	a5,8(sp)
ffffffffc0205658:	0e2000ef          	jal	ra,ffffffffc020573a <strnlen>
ffffffffc020565c:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205660:	01b05b63          	blez	s11,ffffffffc0205676 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205664:	67a2                	ld	a5,8(sp)
ffffffffc0205666:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020566a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020566c:	85a6                	mv	a1,s1
ffffffffc020566e:	8552                	mv	a0,s4
ffffffffc0205670:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205672:	fe0d9ce3          	bnez	s11,ffffffffc020566a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205676:	00044783          	lbu	a5,0(s0)
ffffffffc020567a:	00140a13          	addi	s4,s0,1
ffffffffc020567e:	0007851b          	sext.w	a0,a5
ffffffffc0205682:	d3a5                	beqz	a5,ffffffffc02055e2 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205684:	05e00413          	li	s0,94
ffffffffc0205688:	bf39                	j	ffffffffc02055a6 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020568a:	000a2403          	lw	s0,0(s4)
ffffffffc020568e:	b7ad                	j	ffffffffc02055f8 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205690:	000a6603          	lwu	a2,0(s4)
ffffffffc0205694:	46a1                	li	a3,8
ffffffffc0205696:	8a2e                	mv	s4,a1
ffffffffc0205698:	bdb1                	j	ffffffffc02054f4 <vprintfmt+0x156>
ffffffffc020569a:	000a6603          	lwu	a2,0(s4)
ffffffffc020569e:	46a9                	li	a3,10
ffffffffc02056a0:	8a2e                	mv	s4,a1
ffffffffc02056a2:	bd89                	j	ffffffffc02054f4 <vprintfmt+0x156>
ffffffffc02056a4:	000a6603          	lwu	a2,0(s4)
ffffffffc02056a8:	46c1                	li	a3,16
ffffffffc02056aa:	8a2e                	mv	s4,a1
ffffffffc02056ac:	b5a1                	j	ffffffffc02054f4 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02056ae:	9902                	jalr	s2
ffffffffc02056b0:	bf09                	j	ffffffffc02055c2 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02056b2:	85a6                	mv	a1,s1
ffffffffc02056b4:	02d00513          	li	a0,45
ffffffffc02056b8:	e03e                	sd	a5,0(sp)
ffffffffc02056ba:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02056bc:	6782                	ld	a5,0(sp)
ffffffffc02056be:	8a66                	mv	s4,s9
ffffffffc02056c0:	40800633          	neg	a2,s0
ffffffffc02056c4:	46a9                	li	a3,10
ffffffffc02056c6:	b53d                	j	ffffffffc02054f4 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02056c8:	03b05163          	blez	s11,ffffffffc02056ea <vprintfmt+0x34c>
ffffffffc02056cc:	02d00693          	li	a3,45
ffffffffc02056d0:	f6d79de3          	bne	a5,a3,ffffffffc020564a <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02056d4:	00002417          	auipc	s0,0x2
ffffffffc02056d8:	71440413          	addi	s0,s0,1812 # ffffffffc0207de8 <syscalls+0x818>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02056dc:	02800793          	li	a5,40
ffffffffc02056e0:	02800513          	li	a0,40
ffffffffc02056e4:	00140a13          	addi	s4,s0,1
ffffffffc02056e8:	bd6d                	j	ffffffffc02055a2 <vprintfmt+0x204>
ffffffffc02056ea:	00002a17          	auipc	s4,0x2
ffffffffc02056ee:	6ffa0a13          	addi	s4,s4,1791 # ffffffffc0207de9 <syscalls+0x819>
ffffffffc02056f2:	02800513          	li	a0,40
ffffffffc02056f6:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02056fa:	05e00413          	li	s0,94
ffffffffc02056fe:	b565                	j	ffffffffc02055a6 <vprintfmt+0x208>

ffffffffc0205700 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205700:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205702:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205706:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205708:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020570a:	ec06                	sd	ra,24(sp)
ffffffffc020570c:	f83a                	sd	a4,48(sp)
ffffffffc020570e:	fc3e                	sd	a5,56(sp)
ffffffffc0205710:	e0c2                	sd	a6,64(sp)
ffffffffc0205712:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205714:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205716:	c89ff0ef          	jal	ra,ffffffffc020539e <vprintfmt>
}
ffffffffc020571a:	60e2                	ld	ra,24(sp)
ffffffffc020571c:	6161                	addi	sp,sp,80
ffffffffc020571e:	8082                	ret

ffffffffc0205720 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205720:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205724:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205726:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205728:	cb81                	beqz	a5,ffffffffc0205738 <strlen+0x18>
        cnt ++;
ffffffffc020572a:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020572c:	00a707b3          	add	a5,a4,a0
ffffffffc0205730:	0007c783          	lbu	a5,0(a5)
ffffffffc0205734:	fbfd                	bnez	a5,ffffffffc020572a <strlen+0xa>
ffffffffc0205736:	8082                	ret
    }
    return cnt;
}
ffffffffc0205738:	8082                	ret

ffffffffc020573a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020573a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020573c:	e589                	bnez	a1,ffffffffc0205746 <strnlen+0xc>
ffffffffc020573e:	a811                	j	ffffffffc0205752 <strnlen+0x18>
        cnt ++;
ffffffffc0205740:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205742:	00f58863          	beq	a1,a5,ffffffffc0205752 <strnlen+0x18>
ffffffffc0205746:	00f50733          	add	a4,a0,a5
ffffffffc020574a:	00074703          	lbu	a4,0(a4)
ffffffffc020574e:	fb6d                	bnez	a4,ffffffffc0205740 <strnlen+0x6>
ffffffffc0205750:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205752:	852e                	mv	a0,a1
ffffffffc0205754:	8082                	ret

ffffffffc0205756 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205756:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205758:	0005c703          	lbu	a4,0(a1)
ffffffffc020575c:	0785                	addi	a5,a5,1
ffffffffc020575e:	0585                	addi	a1,a1,1
ffffffffc0205760:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205764:	fb75                	bnez	a4,ffffffffc0205758 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205766:	8082                	ret

ffffffffc0205768 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205768:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020576c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205770:	cb89                	beqz	a5,ffffffffc0205782 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205772:	0505                	addi	a0,a0,1
ffffffffc0205774:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205776:	fee789e3          	beq	a5,a4,ffffffffc0205768 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020577a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020577e:	9d19                	subw	a0,a0,a4
ffffffffc0205780:	8082                	ret
ffffffffc0205782:	4501                	li	a0,0
ffffffffc0205784:	bfed                	j	ffffffffc020577e <strcmp+0x16>

ffffffffc0205786 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205786:	c20d                	beqz	a2,ffffffffc02057a8 <strncmp+0x22>
ffffffffc0205788:	962e                	add	a2,a2,a1
ffffffffc020578a:	a031                	j	ffffffffc0205796 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020578c:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020578e:	00e79a63          	bne	a5,a4,ffffffffc02057a2 <strncmp+0x1c>
ffffffffc0205792:	00b60b63          	beq	a2,a1,ffffffffc02057a8 <strncmp+0x22>
ffffffffc0205796:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc020579a:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020579c:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02057a0:	f7f5                	bnez	a5,ffffffffc020578c <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057a2:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02057a6:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02057a8:	4501                	li	a0,0
ffffffffc02057aa:	8082                	ret

ffffffffc02057ac <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02057ac:	00054783          	lbu	a5,0(a0)
ffffffffc02057b0:	c799                	beqz	a5,ffffffffc02057be <strchr+0x12>
        if (*s == c) {
ffffffffc02057b2:	00f58763          	beq	a1,a5,ffffffffc02057c0 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02057b6:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02057ba:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02057bc:	fbfd                	bnez	a5,ffffffffc02057b2 <strchr+0x6>
    }
    return NULL;
ffffffffc02057be:	4501                	li	a0,0
}
ffffffffc02057c0:	8082                	ret

ffffffffc02057c2 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02057c2:	ca01                	beqz	a2,ffffffffc02057d2 <memset+0x10>
ffffffffc02057c4:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02057c6:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02057c8:	0785                	addi	a5,a5,1
ffffffffc02057ca:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02057ce:	fec79de3          	bne	a5,a2,ffffffffc02057c8 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02057d2:	8082                	ret

ffffffffc02057d4 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02057d4:	ca19                	beqz	a2,ffffffffc02057ea <memcpy+0x16>
ffffffffc02057d6:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02057d8:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02057da:	0005c703          	lbu	a4,0(a1)
ffffffffc02057de:	0585                	addi	a1,a1,1
ffffffffc02057e0:	0785                	addi	a5,a5,1
ffffffffc02057e2:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02057e6:	fec59ae3          	bne	a1,a2,ffffffffc02057da <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02057ea:	8082                	ret
