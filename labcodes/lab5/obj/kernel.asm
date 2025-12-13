
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
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	44e50513          	addi	a0,a0,1102 # ffffffffc02a6498 <buf>
ffffffffc0200052:	000ab617          	auipc	a2,0xab
ffffffffc0200056:	8f260613          	addi	a2,a2,-1806 # ffffffffc02aa944 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	64e050ef          	jal	ra,ffffffffc02056b0 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	67258593          	addi	a1,a1,1650 # ffffffffc02056e0 <etext+0x6>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	68a50513          	addi	a0,a0,1674 # ffffffffc0205700 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6bc020ef          	jal	ra,ffffffffc0202742 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	189030ef          	jal	ra,ffffffffc0203a1a <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	56d040ef          	jal	ra,ffffffffc0204e02 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	6f9040ef          	jal	ra,ffffffffc0204f9a <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	64c50513          	addi	a0,a0,1612 # ffffffffc0205708 <etext+0x2e>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000a6b97          	auipc	s7,0xa6
ffffffffc02000d6:	3c6b8b93          	addi	s7,s7,966 # ffffffffc02a6498 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000a6517          	auipc	a0,0xa6
ffffffffc0200132:	36a50513          	addi	a0,a0,874 # ffffffffc02a6498 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
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
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
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
ffffffffc0200188:	104050ef          	jal	ra,ffffffffc020528c <vprintfmt>
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
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	0ce050ef          	jal	ra,ffffffffc020528c <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	4f250513          	addi	a0,a0,1266 # ffffffffc0205710 <etext+0x36>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	4fc50513          	addi	a0,a0,1276 # ffffffffc0205730 <etext+0x56>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	49a58593          	addi	a1,a1,1178 # ffffffffc02056da <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	50850513          	addi	a0,a0,1288 # ffffffffc0205750 <etext+0x76>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000a6597          	auipc	a1,0xa6
ffffffffc0200258:	24458593          	addi	a1,a1,580 # ffffffffc02a6498 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	51450513          	addi	a0,a0,1300 # ffffffffc0205770 <etext+0x96>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000aa597          	auipc	a1,0xaa
ffffffffc020026c:	6dc58593          	addi	a1,a1,1756 # ffffffffc02aa944 <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	52050513          	addi	a0,a0,1312 # ffffffffc0205790 <etext+0xb6>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000ab597          	auipc	a1,0xab
ffffffffc0200280:	ac758593          	addi	a1,a1,-1337 # ffffffffc02aad43 <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	51250513          	addi	a0,a0,1298 # ffffffffc02057b0 <etext+0xd6>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	53460613          	addi	a2,a2,1332 # ffffffffc02057e0 <etext+0x106>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	54050513          	addi	a0,a0,1344 # ffffffffc02057f8 <etext+0x11e>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	54860613          	addi	a2,a2,1352 # ffffffffc0205810 <etext+0x136>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	56058593          	addi	a1,a1,1376 # ffffffffc0205830 <etext+0x156>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	56050513          	addi	a0,a0,1376 # ffffffffc0205838 <etext+0x15e>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	56260613          	addi	a2,a2,1378 # ffffffffc0205848 <etext+0x16e>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	58258593          	addi	a1,a1,1410 # ffffffffc0205870 <etext+0x196>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	54250513          	addi	a0,a0,1346 # ffffffffc0205838 <etext+0x15e>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	57e60613          	addi	a2,a2,1406 # ffffffffc0205880 <etext+0x1a6>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	59658593          	addi	a1,a1,1430 # ffffffffc02058a0 <etext+0x1c6>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	52650513          	addi	a0,a0,1318 # ffffffffc0205838 <etext+0x15e>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	56450513          	addi	a0,a0,1380 # ffffffffc02058b0 <etext+0x1d6>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	56a50513          	addi	a0,a0,1386 # ffffffffc02058d8 <etext+0x1fe>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	5c4c0c13          	addi	s8,s8,1476 # ffffffffc0205948 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	57490913          	addi	s2,s2,1396 # ffffffffc0205900 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	57448493          	addi	s1,s1,1396 # ffffffffc0205908 <etext+0x22e>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	572b0b13          	addi	s6,s6,1394 # ffffffffc0205910 <etext+0x236>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	48aa0a13          	addi	s4,s4,1162 # ffffffffc0205830 <etext+0x156>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	580d0d13          	addi	s10,s10,1408 # ffffffffc0205948 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	280050ef          	jal	ra,ffffffffc0205656 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	26c050ef          	jal	ra,ffffffffc0205656 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	272050ef          	jal	ra,ffffffffc020569a <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	234050ef          	jal	ra,ffffffffc020569a <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	4b050513          	addi	a0,a0,1200 # ffffffffc0205930 <etext+0x256>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000aa317          	auipc	t1,0xaa
ffffffffc0200492:	43230313          	addi	t1,t1,1074 # ffffffffc02aa8c0 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	4d450513          	addi	a0,a0,1236 # ffffffffc0205990 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	5c650513          	addi	a0,a0,1478 # ffffffffc0206a98 <default_pmm_manager+0x578>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	4aa50513          	addi	a0,a0,1194 # ffffffffc02059b0 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	57250513          	addi	a0,a0,1394 # ffffffffc0206a98 <default_pmm_manager+0x578>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd560>
ffffffffc0200540:	000aa717          	auipc	a4,0xaa
ffffffffc0200544:	38f73823          	sd	a5,912(a4) # ffffffffc02aa8d0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	47050513          	addi	a0,a0,1136 # ffffffffc02059d0 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000aa797          	auipc	a5,0xaa
ffffffffc020056c:	3607b023          	sd	zero,864(a5) # ffffffffc02aa8c8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000aa797          	auipc	a5,0xaa
ffffffffc020057a:	35a7b783          	ld	a5,858(a5) # ffffffffc02aa8d0 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	3f050513          	addi	a0,a0,1008 # ffffffffc02059f0 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	3d250513          	addi	a0,a0,978 # ffffffffc0205a00 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	3cc50513          	addi	a0,a0,972 # ffffffffc0205a10 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	3d450513          	addi	a0,a0,980 # ffffffffc0205a28 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe355a9>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	36a90913          	addi	s2,s2,874 # ffffffffc0205a78 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	35448493          	addi	s1,s1,852 # ffffffffc0205a70 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	38050513          	addi	a0,a0,896 # ffffffffc0205af0 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	3ac50513          	addi	a0,a0,940 # ffffffffc0205b28 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	28c50513          	addi	a0,a0,652 # ffffffffc0205a48 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	645040ef          	jal	ra,ffffffffc020560e <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	69d040ef          	jal	ra,ffffffffc0205674 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	5e9040ef          	jal	ra,ffffffffc0205656 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	1fe50513          	addi	a0,a0,510 # ffffffffc0205a80 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	15050513          	addi	a0,a0,336 # ffffffffc0205aa0 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	15650513          	addi	a0,a0,342 # ffffffffc0205ab8 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	16450513          	addi	a0,a0,356 # ffffffffc0205ad8 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	1a850513          	addi	a0,a0,424 # ffffffffc0205b28 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000aa797          	auipc	a5,0xaa
ffffffffc020098c:	f487b823          	sd	s0,-176(a5) # ffffffffc02aa8d8 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000aa797          	auipc	a5,0xaa
ffffffffc0200994:	f567b823          	sd	s6,-176(a5) # ffffffffc02aa8e0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000aa517          	auipc	a0,0xaa
ffffffffc020099e:	f3e53503          	ld	a0,-194(a0) # ffffffffc02aa8d8 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000aa517          	auipc	a0,0xaa
ffffffffc02009a8:	f3c53503          	ld	a0,-196(a0) # ffffffffc02aa8e0 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	4b078793          	addi	a5,a5,1200 # ffffffffc0200e70 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	16250513          	addi	a0,a0,354 # ffffffffc0205b40 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	16a50513          	addi	a0,a0,362 # ffffffffc0205b58 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	17450513          	addi	a0,a0,372 # ffffffffc0205b70 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	17e50513          	addi	a0,a0,382 # ffffffffc0205b88 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	18850513          	addi	a0,a0,392 # ffffffffc0205ba0 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	19250513          	addi	a0,a0,402 # ffffffffc0205bb8 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	19c50513          	addi	a0,a0,412 # ffffffffc0205bd0 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	1a650513          	addi	a0,a0,422 # ffffffffc0205be8 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	1b050513          	addi	a0,a0,432 # ffffffffc0205c00 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	1ba50513          	addi	a0,a0,442 # ffffffffc0205c18 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	1c450513          	addi	a0,a0,452 # ffffffffc0205c30 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	1ce50513          	addi	a0,a0,462 # ffffffffc0205c48 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	1d850513          	addi	a0,a0,472 # ffffffffc0205c60 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	1e250513          	addi	a0,a0,482 # ffffffffc0205c78 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	1ec50513          	addi	a0,a0,492 # ffffffffc0205c90 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	1f650513          	addi	a0,a0,502 # ffffffffc0205ca8 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	20050513          	addi	a0,a0,512 # ffffffffc0205cc0 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	20a50513          	addi	a0,a0,522 # ffffffffc0205cd8 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	21450513          	addi	a0,a0,532 # ffffffffc0205cf0 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	21e50513          	addi	a0,a0,542 # ffffffffc0205d08 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	22850513          	addi	a0,a0,552 # ffffffffc0205d20 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	23250513          	addi	a0,a0,562 # ffffffffc0205d38 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	23c50513          	addi	a0,a0,572 # ffffffffc0205d50 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	24650513          	addi	a0,a0,582 # ffffffffc0205d68 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	25050513          	addi	a0,a0,592 # ffffffffc0205d80 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	25a50513          	addi	a0,a0,602 # ffffffffc0205d98 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	26450513          	addi	a0,a0,612 # ffffffffc0205db0 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	26e50513          	addi	a0,a0,622 # ffffffffc0205dc8 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	27850513          	addi	a0,a0,632 # ffffffffc0205de0 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	28250513          	addi	a0,a0,642 # ffffffffc0205df8 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	28c50513          	addi	a0,a0,652 # ffffffffc0205e10 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	29250513          	addi	a0,a0,658 # ffffffffc0205e28 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	29450513          	addi	a0,a0,660 # ffffffffc0205e40 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	29450513          	addi	a0,a0,660 # ffffffffc0205e58 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	29c50513          	addi	a0,a0,668 # ffffffffc0205e70 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	2a450513          	addi	a0,a0,676 # ffffffffc0205e88 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	2a050513          	addi	a0,a0,672 # ffffffffc0205e98 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	08f76963          	bltu	a4,a5,ffffffffc0200ca2 <interrupt_handler+0x9c>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	34c70713          	addi	a4,a4,844 # ffffffffc0205f60 <commands+0x618>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	2ea50513          	addi	a0,a0,746 # ffffffffc0205f10 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	2be50513          	addi	a0,a0,702 # ffffffffc0205ef0 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	27250513          	addi	a0,a0,626 # ffffffffc0205eb0 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	28650513          	addi	a0,a0,646 # ffffffffc0205ed0 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
        break;
    case IRQ_U_TIMER:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_TIMER:{
        clock_set_next_event();   // 设定下次时钟中断
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        static int ticks = 0;
        static int num = 0;
        ticks++;
ffffffffc0200c5e:	000aa697          	auipc	a3,0xaa
ffffffffc0200c62:	c8e68693          	addi	a3,a3,-882 # ffffffffc02aa8ec <ticks.1>
ffffffffc0200c66:	429c                	lw	a5,0(a3)

        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c68:	06400713          	li	a4,100
        ticks++;
ffffffffc0200c6c:	2785                	addiw	a5,a5,1
        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c6e:	02e7e73b          	remw	a4,a5,a4
        ticks++;
ffffffffc0200c72:	c29c                	sw	a5,0(a3)
        if (ticks % TICK_NUM == 0) {  // 每100次打印一次
ffffffffc0200c74:	cb05                	beqz	a4,ffffffffc0200ca4 <interrupt_handler+0x9e>
        print_ticks();
        num++;
        }

        if (num == 10) {              // 打印10次后关机
ffffffffc0200c76:	000aa717          	auipc	a4,0xaa
ffffffffc0200c7a:	c7272703          	lw	a4,-910(a4) # ffffffffc02aa8e8 <num.0>
ffffffffc0200c7e:	47a9                	li	a5,10
ffffffffc0200c80:	00f71863          	bne	a4,a5,ffffffffc0200c90 <interrupt_handler+0x8a>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c84:	4501                	li	a0,0
ffffffffc0200c86:	4581                	li	a1,0
ffffffffc0200c88:	4601                	li	a2,0
ffffffffc0200c8a:	48a1                	li	a7,8
ffffffffc0200c8c:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c90:	60a2                	ld	ra,8(sp)
ffffffffc0200c92:	0141                	addi	sp,sp,16
ffffffffc0200c94:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c96:	00005517          	auipc	a0,0x5
ffffffffc0200c9a:	2aa50513          	addi	a0,a0,682 # ffffffffc0205f40 <commands+0x5f8>
ffffffffc0200c9e:	cf6ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200ca2:	b709                	j	ffffffffc0200ba4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200ca4:	06400593          	li	a1,100
ffffffffc0200ca8:	00005517          	auipc	a0,0x5
ffffffffc0200cac:	28850513          	addi	a0,a0,648 # ffffffffc0205f30 <commands+0x5e8>
ffffffffc0200cb0:	ce4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        num++;
ffffffffc0200cb4:	000aa697          	auipc	a3,0xaa
ffffffffc0200cb8:	c3468693          	addi	a3,a3,-972 # ffffffffc02aa8e8 <num.0>
ffffffffc0200cbc:	429c                	lw	a5,0(a3)
ffffffffc0200cbe:	0017871b          	addiw	a4,a5,1
ffffffffc0200cc2:	c298                	sw	a4,0(a3)
ffffffffc0200cc4:	bf6d                	j	ffffffffc0200c7e <interrupt_handler+0x78>

ffffffffc0200cc6 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cc6:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cca:	1141                	addi	sp,sp,-16
ffffffffc0200ccc:	e022                	sd	s0,0(sp)
ffffffffc0200cce:	e406                	sd	ra,8(sp)
ffffffffc0200cd0:	473d                	li	a4,15
ffffffffc0200cd2:	842a                	mv	s0,a0
ffffffffc0200cd4:	0cf76463          	bltu	a4,a5,ffffffffc0200d9c <exception_handler+0xd6>
ffffffffc0200cd8:	00005717          	auipc	a4,0x5
ffffffffc0200cdc:	44870713          	addi	a4,a4,1096 # ffffffffc0206120 <commands+0x7d8>
ffffffffc0200ce0:	078a                	slli	a5,a5,0x2
ffffffffc0200ce2:	97ba                	add	a5,a5,a4
ffffffffc0200ce4:	439c                	lw	a5,0(a5)
ffffffffc0200ce6:	97ba                	add	a5,a5,a4
ffffffffc0200ce8:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cea:	00005517          	auipc	a0,0x5
ffffffffc0200cee:	38e50513          	addi	a0,a0,910 # ffffffffc0206078 <commands+0x730>
ffffffffc0200cf2:	ca2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cf6:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cfa:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cfc:	0791                	addi	a5,a5,4
ffffffffc0200cfe:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d02:	6402                	ld	s0,0(sp)
ffffffffc0200d04:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d06:	4840406f          	j	ffffffffc020518a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d0a:	00005517          	auipc	a0,0x5
ffffffffc0200d0e:	38e50513          	addi	a0,a0,910 # ffffffffc0206098 <commands+0x750>
}
ffffffffc0200d12:	6402                	ld	s0,0(sp)
ffffffffc0200d14:	60a2                	ld	ra,8(sp)
ffffffffc0200d16:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d18:	c7cff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d1c:	00005517          	auipc	a0,0x5
ffffffffc0200d20:	39c50513          	addi	a0,a0,924 # ffffffffc02060b8 <commands+0x770>
ffffffffc0200d24:	b7fd                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d26:	00005517          	auipc	a0,0x5
ffffffffc0200d2a:	3b250513          	addi	a0,a0,946 # ffffffffc02060d8 <commands+0x790>
ffffffffc0200d2e:	b7d5                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d30:	00005517          	auipc	a0,0x5
ffffffffc0200d34:	3c050513          	addi	a0,a0,960 # ffffffffc02060f0 <commands+0x7a8>
ffffffffc0200d38:	bfe9                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d3a:	00005517          	auipc	a0,0x5
ffffffffc0200d3e:	3ce50513          	addi	a0,a0,974 # ffffffffc0206108 <commands+0x7c0>
ffffffffc0200d42:	bfc1                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d44:	00005517          	auipc	a0,0x5
ffffffffc0200d48:	24c50513          	addi	a0,a0,588 # ffffffffc0205f90 <commands+0x648>
ffffffffc0200d4c:	b7d9                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d4e:	00005517          	auipc	a0,0x5
ffffffffc0200d52:	26250513          	addi	a0,a0,610 # ffffffffc0205fb0 <commands+0x668>
ffffffffc0200d56:	bf75                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d58:	00005517          	auipc	a0,0x5
ffffffffc0200d5c:	27850513          	addi	a0,a0,632 # ffffffffc0205fd0 <commands+0x688>
ffffffffc0200d60:	bf4d                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d62:	00005517          	auipc	a0,0x5
ffffffffc0200d66:	28650513          	addi	a0,a0,646 # ffffffffc0205fe8 <commands+0x6a0>
ffffffffc0200d6a:	c2aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d6e:	6458                	ld	a4,136(s0)
ffffffffc0200d70:	47a9                	li	a5,10
ffffffffc0200d72:	04f70663          	beq	a4,a5,ffffffffc0200dbe <exception_handler+0xf8>
}
ffffffffc0200d76:	60a2                	ld	ra,8(sp)
ffffffffc0200d78:	6402                	ld	s0,0(sp)
ffffffffc0200d7a:	0141                	addi	sp,sp,16
ffffffffc0200d7c:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d7e:	00005517          	auipc	a0,0x5
ffffffffc0200d82:	27a50513          	addi	a0,a0,634 # ffffffffc0205ff8 <commands+0x6b0>
ffffffffc0200d86:	b771                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d88:	00005517          	auipc	a0,0x5
ffffffffc0200d8c:	29050513          	addi	a0,a0,656 # ffffffffc0206018 <commands+0x6d0>
ffffffffc0200d90:	b749                	j	ffffffffc0200d12 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d92:	00005517          	auipc	a0,0x5
ffffffffc0200d96:	2ce50513          	addi	a0,a0,718 # ffffffffc0206060 <commands+0x718>
ffffffffc0200d9a:	bfa5                	j	ffffffffc0200d12 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d9c:	8522                	mv	a0,s0
}
ffffffffc0200d9e:	6402                	ld	s0,0(sp)
ffffffffc0200da0:	60a2                	ld	ra,8(sp)
ffffffffc0200da2:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200da4:	b501                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200da6:	00005617          	auipc	a2,0x5
ffffffffc0200daa:	28a60613          	addi	a2,a2,650 # ffffffffc0206030 <commands+0x6e8>
ffffffffc0200dae:	0c600593          	li	a1,198
ffffffffc0200db2:	00005517          	auipc	a0,0x5
ffffffffc0200db6:	29650513          	addi	a0,a0,662 # ffffffffc0206048 <commands+0x700>
ffffffffc0200dba:	ed4ff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200dbe:	10843783          	ld	a5,264(s0)
ffffffffc0200dc2:	0791                	addi	a5,a5,4
ffffffffc0200dc4:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dc8:	3c2040ef          	jal	ra,ffffffffc020518a <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dcc:	000aa797          	auipc	a5,0xaa
ffffffffc0200dd0:	b5c7b783          	ld	a5,-1188(a5) # ffffffffc02aa928 <current>
ffffffffc0200dd4:	6b9c                	ld	a5,16(a5)
ffffffffc0200dd6:	8522                	mv	a0,s0
}
ffffffffc0200dd8:	6402                	ld	s0,0(sp)
ffffffffc0200dda:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200ddc:	6589                	lui	a1,0x2
ffffffffc0200dde:	95be                	add	a1,a1,a5
}
ffffffffc0200de0:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200de2:	aab1                	j	ffffffffc0200f3e <kernel_execve_ret>

ffffffffc0200de4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200de4:	1101                	addi	sp,sp,-32
ffffffffc0200de6:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200de8:	000aa417          	auipc	s0,0xaa
ffffffffc0200dec:	b4040413          	addi	s0,s0,-1216 # ffffffffc02aa928 <current>
ffffffffc0200df0:	6018                	ld	a4,0(s0)
{
ffffffffc0200df2:	ec06                	sd	ra,24(sp)
ffffffffc0200df4:	e426                	sd	s1,8(sp)
ffffffffc0200df6:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200df8:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200dfc:	cf1d                	beqz	a4,ffffffffc0200e3a <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dfe:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e02:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e06:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e08:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e0c:	0206c463          	bltz	a3,ffffffffc0200e34 <trap+0x50>
        exception_handler(tf);
ffffffffc0200e10:	eb7ff0ef          	jal	ra,ffffffffc0200cc6 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e14:	601c                	ld	a5,0(s0)
ffffffffc0200e16:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e1a:	e499                	bnez	s1,ffffffffc0200e28 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e1c:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e20:	8b05                	andi	a4,a4,1
ffffffffc0200e22:	e329                	bnez	a4,ffffffffc0200e64 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e24:	6f9c                	ld	a5,24(a5)
ffffffffc0200e26:	eb85                	bnez	a5,ffffffffc0200e56 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e28:	60e2                	ld	ra,24(sp)
ffffffffc0200e2a:	6442                	ld	s0,16(sp)
ffffffffc0200e2c:	64a2                	ld	s1,8(sp)
ffffffffc0200e2e:	6902                	ld	s2,0(sp)
ffffffffc0200e30:	6105                	addi	sp,sp,32
ffffffffc0200e32:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e34:	dd3ff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e38:	bff1                	j	ffffffffc0200e14 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e3a:	0006c863          	bltz	a3,ffffffffc0200e4a <trap+0x66>
}
ffffffffc0200e3e:	6442                	ld	s0,16(sp)
ffffffffc0200e40:	60e2                	ld	ra,24(sp)
ffffffffc0200e42:	64a2                	ld	s1,8(sp)
ffffffffc0200e44:	6902                	ld	s2,0(sp)
ffffffffc0200e46:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e48:	bdbd                	j	ffffffffc0200cc6 <exception_handler>
}
ffffffffc0200e4a:	6442                	ld	s0,16(sp)
ffffffffc0200e4c:	60e2                	ld	ra,24(sp)
ffffffffc0200e4e:	64a2                	ld	s1,8(sp)
ffffffffc0200e50:	6902                	ld	s2,0(sp)
ffffffffc0200e52:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e54:	bb4d                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e56:	6442                	ld	s0,16(sp)
ffffffffc0200e58:	60e2                	ld	ra,24(sp)
ffffffffc0200e5a:	64a2                	ld	s1,8(sp)
ffffffffc0200e5c:	6902                	ld	s2,0(sp)
ffffffffc0200e5e:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e60:	23e0406f          	j	ffffffffc020509e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e64:	555d                	li	a0,-9
ffffffffc0200e66:	57e030ef          	jal	ra,ffffffffc02043e4 <do_exit>
            if (current->need_resched)
ffffffffc0200e6a:	601c                	ld	a5,0(s0)
ffffffffc0200e6c:	bf65                	j	ffffffffc0200e24 <trap+0x40>
	...

ffffffffc0200e70 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e70:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e74:	00011463          	bnez	sp,ffffffffc0200e7c <__alltraps+0xc>
ffffffffc0200e78:	14002173          	csrr	sp,sscratch
ffffffffc0200e7c:	712d                	addi	sp,sp,-288
ffffffffc0200e7e:	e002                	sd	zero,0(sp)
ffffffffc0200e80:	e406                	sd	ra,8(sp)
ffffffffc0200e82:	ec0e                	sd	gp,24(sp)
ffffffffc0200e84:	f012                	sd	tp,32(sp)
ffffffffc0200e86:	f416                	sd	t0,40(sp)
ffffffffc0200e88:	f81a                	sd	t1,48(sp)
ffffffffc0200e8a:	fc1e                	sd	t2,56(sp)
ffffffffc0200e8c:	e0a2                	sd	s0,64(sp)
ffffffffc0200e8e:	e4a6                	sd	s1,72(sp)
ffffffffc0200e90:	e8aa                	sd	a0,80(sp)
ffffffffc0200e92:	ecae                	sd	a1,88(sp)
ffffffffc0200e94:	f0b2                	sd	a2,96(sp)
ffffffffc0200e96:	f4b6                	sd	a3,104(sp)
ffffffffc0200e98:	f8ba                	sd	a4,112(sp)
ffffffffc0200e9a:	fcbe                	sd	a5,120(sp)
ffffffffc0200e9c:	e142                	sd	a6,128(sp)
ffffffffc0200e9e:	e546                	sd	a7,136(sp)
ffffffffc0200ea0:	e94a                	sd	s2,144(sp)
ffffffffc0200ea2:	ed4e                	sd	s3,152(sp)
ffffffffc0200ea4:	f152                	sd	s4,160(sp)
ffffffffc0200ea6:	f556                	sd	s5,168(sp)
ffffffffc0200ea8:	f95a                	sd	s6,176(sp)
ffffffffc0200eaa:	fd5e                	sd	s7,184(sp)
ffffffffc0200eac:	e1e2                	sd	s8,192(sp)
ffffffffc0200eae:	e5e6                	sd	s9,200(sp)
ffffffffc0200eb0:	e9ea                	sd	s10,208(sp)
ffffffffc0200eb2:	edee                	sd	s11,216(sp)
ffffffffc0200eb4:	f1f2                	sd	t3,224(sp)
ffffffffc0200eb6:	f5f6                	sd	t4,232(sp)
ffffffffc0200eb8:	f9fa                	sd	t5,240(sp)
ffffffffc0200eba:	fdfe                	sd	t6,248(sp)
ffffffffc0200ebc:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200ec0:	100024f3          	csrr	s1,sstatus
ffffffffc0200ec4:	14102973          	csrr	s2,sepc
ffffffffc0200ec8:	143029f3          	csrr	s3,stval
ffffffffc0200ecc:	14202a73          	csrr	s4,scause
ffffffffc0200ed0:	e822                	sd	s0,16(sp)
ffffffffc0200ed2:	e226                	sd	s1,256(sp)
ffffffffc0200ed4:	e64a                	sd	s2,264(sp)
ffffffffc0200ed6:	ea4e                	sd	s3,272(sp)
ffffffffc0200ed8:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200eda:	850a                	mv	a0,sp
    jal trap
ffffffffc0200edc:	f09ff0ef          	jal	ra,ffffffffc0200de4 <trap>

ffffffffc0200ee0 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ee0:	6492                	ld	s1,256(sp)
ffffffffc0200ee2:	6932                	ld	s2,264(sp)
ffffffffc0200ee4:	1004f413          	andi	s0,s1,256
ffffffffc0200ee8:	e401                	bnez	s0,ffffffffc0200ef0 <__trapret+0x10>
ffffffffc0200eea:	1200                	addi	s0,sp,288
ffffffffc0200eec:	14041073          	csrw	sscratch,s0
ffffffffc0200ef0:	10049073          	csrw	sstatus,s1
ffffffffc0200ef4:	14191073          	csrw	sepc,s2
ffffffffc0200ef8:	60a2                	ld	ra,8(sp)
ffffffffc0200efa:	61e2                	ld	gp,24(sp)
ffffffffc0200efc:	7202                	ld	tp,32(sp)
ffffffffc0200efe:	72a2                	ld	t0,40(sp)
ffffffffc0200f00:	7342                	ld	t1,48(sp)
ffffffffc0200f02:	73e2                	ld	t2,56(sp)
ffffffffc0200f04:	6406                	ld	s0,64(sp)
ffffffffc0200f06:	64a6                	ld	s1,72(sp)
ffffffffc0200f08:	6546                	ld	a0,80(sp)
ffffffffc0200f0a:	65e6                	ld	a1,88(sp)
ffffffffc0200f0c:	7606                	ld	a2,96(sp)
ffffffffc0200f0e:	76a6                	ld	a3,104(sp)
ffffffffc0200f10:	7746                	ld	a4,112(sp)
ffffffffc0200f12:	77e6                	ld	a5,120(sp)
ffffffffc0200f14:	680a                	ld	a6,128(sp)
ffffffffc0200f16:	68aa                	ld	a7,136(sp)
ffffffffc0200f18:	694a                	ld	s2,144(sp)
ffffffffc0200f1a:	69ea                	ld	s3,152(sp)
ffffffffc0200f1c:	7a0a                	ld	s4,160(sp)
ffffffffc0200f1e:	7aaa                	ld	s5,168(sp)
ffffffffc0200f20:	7b4a                	ld	s6,176(sp)
ffffffffc0200f22:	7bea                	ld	s7,184(sp)
ffffffffc0200f24:	6c0e                	ld	s8,192(sp)
ffffffffc0200f26:	6cae                	ld	s9,200(sp)
ffffffffc0200f28:	6d4e                	ld	s10,208(sp)
ffffffffc0200f2a:	6dee                	ld	s11,216(sp)
ffffffffc0200f2c:	7e0e                	ld	t3,224(sp)
ffffffffc0200f2e:	7eae                	ld	t4,232(sp)
ffffffffc0200f30:	7f4e                	ld	t5,240(sp)
ffffffffc0200f32:	7fee                	ld	t6,248(sp)
ffffffffc0200f34:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f36:	10200073          	sret

ffffffffc0200f3a <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f3a:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f3c:	b755                	j	ffffffffc0200ee0 <__trapret>

ffffffffc0200f3e <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f3e:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7ce8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f42:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f46:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f4a:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f4e:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f52:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f56:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f5a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f5e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f62:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f64:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f66:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f68:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f6a:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f6c:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f6e:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f70:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f72:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f74:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f76:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f78:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f7a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f7c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f7e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f80:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f82:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f84:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f86:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f88:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f8a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f8c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f8e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f90:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f92:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f94:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f96:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f98:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f9a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f9c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f9e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200fa0:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200fa2:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200fa4:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200fa6:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200fa8:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200faa:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fac:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fae:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fb0:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200fb2:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fb4:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200fb6:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fb8:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200fba:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fbc:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fbe:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fc0:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fc2:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fc4:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fc6:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fc8:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fca:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fcc:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fce:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fd0:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fd2:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fd4:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fd6:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fd8:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fda:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fdc:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fde:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fe0:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fe2:	812e                	mv	sp,a1
ffffffffc0200fe4:	bdf5                	j	ffffffffc0200ee0 <__trapret>

ffffffffc0200fe6 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fe6:	000a6797          	auipc	a5,0xa6
ffffffffc0200fea:	8b278793          	addi	a5,a5,-1870 # ffffffffc02a6898 <free_area>
ffffffffc0200fee:	e79c                	sd	a5,8(a5)
ffffffffc0200ff0:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200ff2:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200ff6:	8082                	ret

ffffffffc0200ff8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200ff8:	000a6517          	auipc	a0,0xa6
ffffffffc0200ffc:	8b056503          	lwu	a0,-1872(a0) # ffffffffc02a68a8 <free_area+0x10>
ffffffffc0201000:	8082                	ret

ffffffffc0201002 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201002:	715d                	addi	sp,sp,-80
ffffffffc0201004:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201006:	000a6417          	auipc	s0,0xa6
ffffffffc020100a:	89240413          	addi	s0,s0,-1902 # ffffffffc02a6898 <free_area>
ffffffffc020100e:	641c                	ld	a5,8(s0)
ffffffffc0201010:	e486                	sd	ra,72(sp)
ffffffffc0201012:	fc26                	sd	s1,56(sp)
ffffffffc0201014:	f84a                	sd	s2,48(sp)
ffffffffc0201016:	f44e                	sd	s3,40(sp)
ffffffffc0201018:	f052                	sd	s4,32(sp)
ffffffffc020101a:	ec56                	sd	s5,24(sp)
ffffffffc020101c:	e85a                	sd	s6,16(sp)
ffffffffc020101e:	e45e                	sd	s7,8(sp)
ffffffffc0201020:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201022:	2a878d63          	beq	a5,s0,ffffffffc02012dc <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201026:	4481                	li	s1,0
ffffffffc0201028:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020102a:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020102e:	8b09                	andi	a4,a4,2
ffffffffc0201030:	2a070a63          	beqz	a4,ffffffffc02012e4 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201034:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201038:	679c                	ld	a5,8(a5)
ffffffffc020103a:	2905                	addiw	s2,s2,1
ffffffffc020103c:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020103e:	fe8796e3          	bne	a5,s0,ffffffffc020102a <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201042:	89a6                	mv	s3,s1
ffffffffc0201044:	6df000ef          	jal	ra,ffffffffc0201f22 <nr_free_pages>
ffffffffc0201048:	6f351e63          	bne	a0,s3,ffffffffc0201744 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020104c:	4505                	li	a0,1
ffffffffc020104e:	657000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201052:	8aaa                	mv	s5,a0
ffffffffc0201054:	42050863          	beqz	a0,ffffffffc0201484 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201058:	4505                	li	a0,1
ffffffffc020105a:	64b000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020105e:	89aa                	mv	s3,a0
ffffffffc0201060:	70050263          	beqz	a0,ffffffffc0201764 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201064:	4505                	li	a0,1
ffffffffc0201066:	63f000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020106a:	8a2a                	mv	s4,a0
ffffffffc020106c:	48050c63          	beqz	a0,ffffffffc0201504 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201070:	293a8a63          	beq	s5,s3,ffffffffc0201304 <default_check+0x302>
ffffffffc0201074:	28aa8863          	beq	s5,a0,ffffffffc0201304 <default_check+0x302>
ffffffffc0201078:	28a98663          	beq	s3,a0,ffffffffc0201304 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020107c:	000aa783          	lw	a5,0(s5)
ffffffffc0201080:	2a079263          	bnez	a5,ffffffffc0201324 <default_check+0x322>
ffffffffc0201084:	0009a783          	lw	a5,0(s3)
ffffffffc0201088:	28079e63          	bnez	a5,ffffffffc0201324 <default_check+0x322>
ffffffffc020108c:	411c                	lw	a5,0(a0)
ffffffffc020108e:	28079b63          	bnez	a5,ffffffffc0201324 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201092:	000aa797          	auipc	a5,0xaa
ffffffffc0201096:	87e7b783          	ld	a5,-1922(a5) # ffffffffc02aa910 <pages>
ffffffffc020109a:	40fa8733          	sub	a4,s5,a5
ffffffffc020109e:	00006617          	auipc	a2,0x6
ffffffffc02010a2:	7a263603          	ld	a2,1954(a2) # ffffffffc0207840 <nbase>
ffffffffc02010a6:	8719                	srai	a4,a4,0x6
ffffffffc02010a8:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010aa:	000aa697          	auipc	a3,0xaa
ffffffffc02010ae:	85e6b683          	ld	a3,-1954(a3) # ffffffffc02aa908 <npage>
ffffffffc02010b2:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010b4:	0732                	slli	a4,a4,0xc
ffffffffc02010b6:	28d77763          	bgeu	a4,a3,ffffffffc0201344 <default_check+0x342>
    return page - pages + nbase;
ffffffffc02010ba:	40f98733          	sub	a4,s3,a5
ffffffffc02010be:	8719                	srai	a4,a4,0x6
ffffffffc02010c0:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010c2:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010c4:	4cd77063          	bgeu	a4,a3,ffffffffc0201584 <default_check+0x582>
    return page - pages + nbase;
ffffffffc02010c8:	40f507b3          	sub	a5,a0,a5
ffffffffc02010cc:	8799                	srai	a5,a5,0x6
ffffffffc02010ce:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010d0:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010d2:	30d7f963          	bgeu	a5,a3,ffffffffc02013e4 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010d6:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010d8:	00043c03          	ld	s8,0(s0)
ffffffffc02010dc:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010e0:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010e4:	e400                	sd	s0,8(s0)
ffffffffc02010e6:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010e8:	000a5797          	auipc	a5,0xa5
ffffffffc02010ec:	7c07a023          	sw	zero,1984(a5) # ffffffffc02a68a8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010f0:	5b5000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc02010f4:	2c051863          	bnez	a0,ffffffffc02013c4 <default_check+0x3c2>
    free_page(p0);
ffffffffc02010f8:	4585                	li	a1,1
ffffffffc02010fa:	8556                	mv	a0,s5
ffffffffc02010fc:	5e7000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_page(p1);
ffffffffc0201100:	4585                	li	a1,1
ffffffffc0201102:	854e                	mv	a0,s3
ffffffffc0201104:	5df000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_page(p2);
ffffffffc0201108:	4585                	li	a1,1
ffffffffc020110a:	8552                	mv	a0,s4
ffffffffc020110c:	5d7000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    assert(nr_free == 3);
ffffffffc0201110:	4818                	lw	a4,16(s0)
ffffffffc0201112:	478d                	li	a5,3
ffffffffc0201114:	28f71863          	bne	a4,a5,ffffffffc02013a4 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201118:	4505                	li	a0,1
ffffffffc020111a:	58b000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020111e:	89aa                	mv	s3,a0
ffffffffc0201120:	26050263          	beqz	a0,ffffffffc0201384 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201124:	4505                	li	a0,1
ffffffffc0201126:	57f000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020112a:	8aaa                	mv	s5,a0
ffffffffc020112c:	3a050c63          	beqz	a0,ffffffffc02014e4 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201130:	4505                	li	a0,1
ffffffffc0201132:	573000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201136:	8a2a                	mv	s4,a0
ffffffffc0201138:	38050663          	beqz	a0,ffffffffc02014c4 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc020113c:	4505                	li	a0,1
ffffffffc020113e:	567000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201142:	36051163          	bnez	a0,ffffffffc02014a4 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201146:	4585                	li	a1,1
ffffffffc0201148:	854e                	mv	a0,s3
ffffffffc020114a:	599000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020114e:	641c                	ld	a5,8(s0)
ffffffffc0201150:	20878a63          	beq	a5,s0,ffffffffc0201364 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201154:	4505                	li	a0,1
ffffffffc0201156:	54f000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020115a:	30a99563          	bne	s3,a0,ffffffffc0201464 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc020115e:	4505                	li	a0,1
ffffffffc0201160:	545000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201164:	2e051063          	bnez	a0,ffffffffc0201444 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201168:	481c                	lw	a5,16(s0)
ffffffffc020116a:	2a079d63          	bnez	a5,ffffffffc0201424 <default_check+0x422>
    free_page(p);
ffffffffc020116e:	854e                	mv	a0,s3
ffffffffc0201170:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201172:	01843023          	sd	s8,0(s0)
ffffffffc0201176:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020117a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020117e:	565000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_page(p1);
ffffffffc0201182:	4585                	li	a1,1
ffffffffc0201184:	8556                	mv	a0,s5
ffffffffc0201186:	55d000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_page(p2);
ffffffffc020118a:	4585                	li	a1,1
ffffffffc020118c:	8552                	mv	a0,s4
ffffffffc020118e:	555000ef          	jal	ra,ffffffffc0201ee2 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201192:	4515                	li	a0,5
ffffffffc0201194:	511000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201198:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020119a:	26050563          	beqz	a0,ffffffffc0201404 <default_check+0x402>
ffffffffc020119e:	651c                	ld	a5,8(a0)
ffffffffc02011a0:	8385                	srli	a5,a5,0x1
ffffffffc02011a2:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02011a4:	54079063          	bnez	a5,ffffffffc02016e4 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011a8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011aa:	00043b03          	ld	s6,0(s0)
ffffffffc02011ae:	00843a83          	ld	s5,8(s0)
ffffffffc02011b2:	e000                	sd	s0,0(s0)
ffffffffc02011b4:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02011b6:	4ef000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc02011ba:	50051563          	bnez	a0,ffffffffc02016c4 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011be:	08098a13          	addi	s4,s3,128
ffffffffc02011c2:	8552                	mv	a0,s4
ffffffffc02011c4:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011c6:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02011ca:	000a5797          	auipc	a5,0xa5
ffffffffc02011ce:	6c07af23          	sw	zero,1758(a5) # ffffffffc02a68a8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011d2:	511000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011d6:	4511                	li	a0,4
ffffffffc02011d8:	4cd000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc02011dc:	4c051463          	bnez	a0,ffffffffc02016a4 <default_check+0x6a2>
ffffffffc02011e0:	0889b783          	ld	a5,136(s3)
ffffffffc02011e4:	8385                	srli	a5,a5,0x1
ffffffffc02011e6:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011e8:	48078e63          	beqz	a5,ffffffffc0201684 <default_check+0x682>
ffffffffc02011ec:	0909a703          	lw	a4,144(s3)
ffffffffc02011f0:	478d                	li	a5,3
ffffffffc02011f2:	48f71963          	bne	a4,a5,ffffffffc0201684 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011f6:	450d                	li	a0,3
ffffffffc02011f8:	4ad000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc02011fc:	8c2a                	mv	s8,a0
ffffffffc02011fe:	46050363          	beqz	a0,ffffffffc0201664 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201202:	4505                	li	a0,1
ffffffffc0201204:	4a1000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201208:	42051e63          	bnez	a0,ffffffffc0201644 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc020120c:	418a1c63          	bne	s4,s8,ffffffffc0201624 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201210:	4585                	li	a1,1
ffffffffc0201212:	854e                	mv	a0,s3
ffffffffc0201214:	4cf000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_pages(p1, 3);
ffffffffc0201218:	458d                	li	a1,3
ffffffffc020121a:	8552                	mv	a0,s4
ffffffffc020121c:	4c7000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
ffffffffc0201220:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201224:	04098c13          	addi	s8,s3,64
ffffffffc0201228:	8385                	srli	a5,a5,0x1
ffffffffc020122a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020122c:	3c078c63          	beqz	a5,ffffffffc0201604 <default_check+0x602>
ffffffffc0201230:	0109a703          	lw	a4,16(s3)
ffffffffc0201234:	4785                	li	a5,1
ffffffffc0201236:	3cf71763          	bne	a4,a5,ffffffffc0201604 <default_check+0x602>
ffffffffc020123a:	008a3783          	ld	a5,8(s4)
ffffffffc020123e:	8385                	srli	a5,a5,0x1
ffffffffc0201240:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201242:	3a078163          	beqz	a5,ffffffffc02015e4 <default_check+0x5e2>
ffffffffc0201246:	010a2703          	lw	a4,16(s4)
ffffffffc020124a:	478d                	li	a5,3
ffffffffc020124c:	38f71c63          	bne	a4,a5,ffffffffc02015e4 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201250:	4505                	li	a0,1
ffffffffc0201252:	453000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201256:	36a99763          	bne	s3,a0,ffffffffc02015c4 <default_check+0x5c2>
    free_page(p0);
ffffffffc020125a:	4585                	li	a1,1
ffffffffc020125c:	487000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201260:	4509                	li	a0,2
ffffffffc0201262:	443000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0201266:	32aa1f63          	bne	s4,a0,ffffffffc02015a4 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020126a:	4589                	li	a1,2
ffffffffc020126c:	477000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    free_page(p2);
ffffffffc0201270:	4585                	li	a1,1
ffffffffc0201272:	8562                	mv	a0,s8
ffffffffc0201274:	46f000ef          	jal	ra,ffffffffc0201ee2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201278:	4515                	li	a0,5
ffffffffc020127a:	42b000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020127e:	89aa                	mv	s3,a0
ffffffffc0201280:	48050263          	beqz	a0,ffffffffc0201704 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201284:	4505                	li	a0,1
ffffffffc0201286:	41f000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc020128a:	2c051d63          	bnez	a0,ffffffffc0201564 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc020128e:	481c                	lw	a5,16(s0)
ffffffffc0201290:	2a079a63          	bnez	a5,ffffffffc0201544 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201294:	4595                	li	a1,5
ffffffffc0201296:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201298:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc020129c:	01643023          	sd	s6,0(s0)
ffffffffc02012a0:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02012a4:	43f000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    return listelm->next;
ffffffffc02012a8:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012aa:	00878963          	beq	a5,s0,ffffffffc02012bc <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012ae:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012b2:	679c                	ld	a5,8(a5)
ffffffffc02012b4:	397d                	addiw	s2,s2,-1
ffffffffc02012b6:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012b8:	fe879be3          	bne	a5,s0,ffffffffc02012ae <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012bc:	26091463          	bnez	s2,ffffffffc0201524 <default_check+0x522>
    assert(total == 0);
ffffffffc02012c0:	46049263          	bnez	s1,ffffffffc0201724 <default_check+0x722>
}
ffffffffc02012c4:	60a6                	ld	ra,72(sp)
ffffffffc02012c6:	6406                	ld	s0,64(sp)
ffffffffc02012c8:	74e2                	ld	s1,56(sp)
ffffffffc02012ca:	7942                	ld	s2,48(sp)
ffffffffc02012cc:	79a2                	ld	s3,40(sp)
ffffffffc02012ce:	7a02                	ld	s4,32(sp)
ffffffffc02012d0:	6ae2                	ld	s5,24(sp)
ffffffffc02012d2:	6b42                	ld	s6,16(sp)
ffffffffc02012d4:	6ba2                	ld	s7,8(sp)
ffffffffc02012d6:	6c02                	ld	s8,0(sp)
ffffffffc02012d8:	6161                	addi	sp,sp,80
ffffffffc02012da:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012dc:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012de:	4481                	li	s1,0
ffffffffc02012e0:	4901                	li	s2,0
ffffffffc02012e2:	b38d                	j	ffffffffc0201044 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012e4:	00005697          	auipc	a3,0x5
ffffffffc02012e8:	e7c68693          	addi	a3,a3,-388 # ffffffffc0206160 <commands+0x818>
ffffffffc02012ec:	00005617          	auipc	a2,0x5
ffffffffc02012f0:	e8460613          	addi	a2,a2,-380 # ffffffffc0206170 <commands+0x828>
ffffffffc02012f4:	11000593          	li	a1,272
ffffffffc02012f8:	00005517          	auipc	a0,0x5
ffffffffc02012fc:	e9050513          	addi	a0,a0,-368 # ffffffffc0206188 <commands+0x840>
ffffffffc0201300:	98eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201304:	00005697          	auipc	a3,0x5
ffffffffc0201308:	f1c68693          	addi	a3,a3,-228 # ffffffffc0206220 <commands+0x8d8>
ffffffffc020130c:	00005617          	auipc	a2,0x5
ffffffffc0201310:	e6460613          	addi	a2,a2,-412 # ffffffffc0206170 <commands+0x828>
ffffffffc0201314:	0db00593          	li	a1,219
ffffffffc0201318:	00005517          	auipc	a0,0x5
ffffffffc020131c:	e7050513          	addi	a0,a0,-400 # ffffffffc0206188 <commands+0x840>
ffffffffc0201320:	96eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201324:	00005697          	auipc	a3,0x5
ffffffffc0201328:	f2468693          	addi	a3,a3,-220 # ffffffffc0206248 <commands+0x900>
ffffffffc020132c:	00005617          	auipc	a2,0x5
ffffffffc0201330:	e4460613          	addi	a2,a2,-444 # ffffffffc0206170 <commands+0x828>
ffffffffc0201334:	0dc00593          	li	a1,220
ffffffffc0201338:	00005517          	auipc	a0,0x5
ffffffffc020133c:	e5050513          	addi	a0,a0,-432 # ffffffffc0206188 <commands+0x840>
ffffffffc0201340:	94eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201344:	00005697          	auipc	a3,0x5
ffffffffc0201348:	f4468693          	addi	a3,a3,-188 # ffffffffc0206288 <commands+0x940>
ffffffffc020134c:	00005617          	auipc	a2,0x5
ffffffffc0201350:	e2460613          	addi	a2,a2,-476 # ffffffffc0206170 <commands+0x828>
ffffffffc0201354:	0de00593          	li	a1,222
ffffffffc0201358:	00005517          	auipc	a0,0x5
ffffffffc020135c:	e3050513          	addi	a0,a0,-464 # ffffffffc0206188 <commands+0x840>
ffffffffc0201360:	92eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201364:	00005697          	auipc	a3,0x5
ffffffffc0201368:	fac68693          	addi	a3,a3,-84 # ffffffffc0206310 <commands+0x9c8>
ffffffffc020136c:	00005617          	auipc	a2,0x5
ffffffffc0201370:	e0460613          	addi	a2,a2,-508 # ffffffffc0206170 <commands+0x828>
ffffffffc0201374:	0f700593          	li	a1,247
ffffffffc0201378:	00005517          	auipc	a0,0x5
ffffffffc020137c:	e1050513          	addi	a0,a0,-496 # ffffffffc0206188 <commands+0x840>
ffffffffc0201380:	90eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201384:	00005697          	auipc	a3,0x5
ffffffffc0201388:	e3c68693          	addi	a3,a3,-452 # ffffffffc02061c0 <commands+0x878>
ffffffffc020138c:	00005617          	auipc	a2,0x5
ffffffffc0201390:	de460613          	addi	a2,a2,-540 # ffffffffc0206170 <commands+0x828>
ffffffffc0201394:	0f000593          	li	a1,240
ffffffffc0201398:	00005517          	auipc	a0,0x5
ffffffffc020139c:	df050513          	addi	a0,a0,-528 # ffffffffc0206188 <commands+0x840>
ffffffffc02013a0:	8eeff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc02013a4:	00005697          	auipc	a3,0x5
ffffffffc02013a8:	f5c68693          	addi	a3,a3,-164 # ffffffffc0206300 <commands+0x9b8>
ffffffffc02013ac:	00005617          	auipc	a2,0x5
ffffffffc02013b0:	dc460613          	addi	a2,a2,-572 # ffffffffc0206170 <commands+0x828>
ffffffffc02013b4:	0ee00593          	li	a1,238
ffffffffc02013b8:	00005517          	auipc	a0,0x5
ffffffffc02013bc:	dd050513          	addi	a0,a0,-560 # ffffffffc0206188 <commands+0x840>
ffffffffc02013c0:	8ceff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	f2468693          	addi	a3,a3,-220 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc02013cc:	00005617          	auipc	a2,0x5
ffffffffc02013d0:	da460613          	addi	a2,a2,-604 # ffffffffc0206170 <commands+0x828>
ffffffffc02013d4:	0e900593          	li	a1,233
ffffffffc02013d8:	00005517          	auipc	a0,0x5
ffffffffc02013dc:	db050513          	addi	a0,a0,-592 # ffffffffc0206188 <commands+0x840>
ffffffffc02013e0:	8aeff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013e4:	00005697          	auipc	a3,0x5
ffffffffc02013e8:	ee468693          	addi	a3,a3,-284 # ffffffffc02062c8 <commands+0x980>
ffffffffc02013ec:	00005617          	auipc	a2,0x5
ffffffffc02013f0:	d8460613          	addi	a2,a2,-636 # ffffffffc0206170 <commands+0x828>
ffffffffc02013f4:	0e000593          	li	a1,224
ffffffffc02013f8:	00005517          	auipc	a0,0x5
ffffffffc02013fc:	d9050513          	addi	a0,a0,-624 # ffffffffc0206188 <commands+0x840>
ffffffffc0201400:	88eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	f5468693          	addi	a3,a3,-172 # ffffffffc0206358 <commands+0xa10>
ffffffffc020140c:	00005617          	auipc	a2,0x5
ffffffffc0201410:	d6460613          	addi	a2,a2,-668 # ffffffffc0206170 <commands+0x828>
ffffffffc0201414:	11800593          	li	a1,280
ffffffffc0201418:	00005517          	auipc	a0,0x5
ffffffffc020141c:	d7050513          	addi	a0,a0,-656 # ffffffffc0206188 <commands+0x840>
ffffffffc0201420:	86eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	f2468693          	addi	a3,a3,-220 # ffffffffc0206348 <commands+0xa00>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	d4460613          	addi	a2,a2,-700 # ffffffffc0206170 <commands+0x828>
ffffffffc0201434:	0fd00593          	li	a1,253
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	d5050513          	addi	a0,a0,-688 # ffffffffc0206188 <commands+0x840>
ffffffffc0201440:	84eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201444:	00005697          	auipc	a3,0x5
ffffffffc0201448:	ea468693          	addi	a3,a3,-348 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc020144c:	00005617          	auipc	a2,0x5
ffffffffc0201450:	d2460613          	addi	a2,a2,-732 # ffffffffc0206170 <commands+0x828>
ffffffffc0201454:	0fb00593          	li	a1,251
ffffffffc0201458:	00005517          	auipc	a0,0x5
ffffffffc020145c:	d3050513          	addi	a0,a0,-720 # ffffffffc0206188 <commands+0x840>
ffffffffc0201460:	82eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201464:	00005697          	auipc	a3,0x5
ffffffffc0201468:	ec468693          	addi	a3,a3,-316 # ffffffffc0206328 <commands+0x9e0>
ffffffffc020146c:	00005617          	auipc	a2,0x5
ffffffffc0201470:	d0460613          	addi	a2,a2,-764 # ffffffffc0206170 <commands+0x828>
ffffffffc0201474:	0fa00593          	li	a1,250
ffffffffc0201478:	00005517          	auipc	a0,0x5
ffffffffc020147c:	d1050513          	addi	a0,a0,-752 # ffffffffc0206188 <commands+0x840>
ffffffffc0201480:	80eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201484:	00005697          	auipc	a3,0x5
ffffffffc0201488:	d3c68693          	addi	a3,a3,-708 # ffffffffc02061c0 <commands+0x878>
ffffffffc020148c:	00005617          	auipc	a2,0x5
ffffffffc0201490:	ce460613          	addi	a2,a2,-796 # ffffffffc0206170 <commands+0x828>
ffffffffc0201494:	0d700593          	li	a1,215
ffffffffc0201498:	00005517          	auipc	a0,0x5
ffffffffc020149c:	cf050513          	addi	a0,a0,-784 # ffffffffc0206188 <commands+0x840>
ffffffffc02014a0:	feffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014a4:	00005697          	auipc	a3,0x5
ffffffffc02014a8:	e4468693          	addi	a3,a3,-444 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc02014ac:	00005617          	auipc	a2,0x5
ffffffffc02014b0:	cc460613          	addi	a2,a2,-828 # ffffffffc0206170 <commands+0x828>
ffffffffc02014b4:	0f400593          	li	a1,244
ffffffffc02014b8:	00005517          	auipc	a0,0x5
ffffffffc02014bc:	cd050513          	addi	a0,a0,-816 # ffffffffc0206188 <commands+0x840>
ffffffffc02014c0:	fcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014c4:	00005697          	auipc	a3,0x5
ffffffffc02014c8:	d3c68693          	addi	a3,a3,-708 # ffffffffc0206200 <commands+0x8b8>
ffffffffc02014cc:	00005617          	auipc	a2,0x5
ffffffffc02014d0:	ca460613          	addi	a2,a2,-860 # ffffffffc0206170 <commands+0x828>
ffffffffc02014d4:	0f200593          	li	a1,242
ffffffffc02014d8:	00005517          	auipc	a0,0x5
ffffffffc02014dc:	cb050513          	addi	a0,a0,-848 # ffffffffc0206188 <commands+0x840>
ffffffffc02014e0:	faffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	cfc68693          	addi	a3,a3,-772 # ffffffffc02061e0 <commands+0x898>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	c8460613          	addi	a2,a2,-892 # ffffffffc0206170 <commands+0x828>
ffffffffc02014f4:	0f100593          	li	a1,241
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	c9050513          	addi	a0,a0,-880 # ffffffffc0206188 <commands+0x840>
ffffffffc0201500:	f8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	cfc68693          	addi	a3,a3,-772 # ffffffffc0206200 <commands+0x8b8>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	c6460613          	addi	a2,a2,-924 # ffffffffc0206170 <commands+0x828>
ffffffffc0201514:	0d900593          	li	a1,217
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	c7050513          	addi	a0,a0,-912 # ffffffffc0206188 <commands+0x840>
ffffffffc0201520:	f6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc0201524:	00005697          	auipc	a3,0x5
ffffffffc0201528:	f8468693          	addi	a3,a3,-124 # ffffffffc02064a8 <commands+0xb60>
ffffffffc020152c:	00005617          	auipc	a2,0x5
ffffffffc0201530:	c4460613          	addi	a2,a2,-956 # ffffffffc0206170 <commands+0x828>
ffffffffc0201534:	14600593          	li	a1,326
ffffffffc0201538:	00005517          	auipc	a0,0x5
ffffffffc020153c:	c5050513          	addi	a0,a0,-944 # ffffffffc0206188 <commands+0x840>
ffffffffc0201540:	f4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201544:	00005697          	auipc	a3,0x5
ffffffffc0201548:	e0468693          	addi	a3,a3,-508 # ffffffffc0206348 <commands+0xa00>
ffffffffc020154c:	00005617          	auipc	a2,0x5
ffffffffc0201550:	c2460613          	addi	a2,a2,-988 # ffffffffc0206170 <commands+0x828>
ffffffffc0201554:	13a00593          	li	a1,314
ffffffffc0201558:	00005517          	auipc	a0,0x5
ffffffffc020155c:	c3050513          	addi	a0,a0,-976 # ffffffffc0206188 <commands+0x840>
ffffffffc0201560:	f2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201564:	00005697          	auipc	a3,0x5
ffffffffc0201568:	d8468693          	addi	a3,a3,-636 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc020156c:	00005617          	auipc	a2,0x5
ffffffffc0201570:	c0460613          	addi	a2,a2,-1020 # ffffffffc0206170 <commands+0x828>
ffffffffc0201574:	13800593          	li	a1,312
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0206188 <commands+0x840>
ffffffffc0201580:	f0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	d2468693          	addi	a3,a3,-732 # ffffffffc02062a8 <commands+0x960>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	be460613          	addi	a2,a2,-1052 # ffffffffc0206170 <commands+0x828>
ffffffffc0201594:	0df00593          	li	a1,223
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	bf050513          	addi	a0,a0,-1040 # ffffffffc0206188 <commands+0x840>
ffffffffc02015a0:	eeffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	ec468693          	addi	a3,a3,-316 # ffffffffc0206468 <commands+0xb20>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	bc460613          	addi	a2,a2,-1084 # ffffffffc0206170 <commands+0x828>
ffffffffc02015b4:	13200593          	li	a1,306
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	bd050513          	addi	a0,a0,-1072 # ffffffffc0206188 <commands+0x840>
ffffffffc02015c0:	ecffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	e8468693          	addi	a3,a3,-380 # ffffffffc0206448 <commands+0xb00>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	ba460613          	addi	a2,a2,-1116 # ffffffffc0206170 <commands+0x828>
ffffffffc02015d4:	13000593          	li	a1,304
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	bb050513          	addi	a0,a0,-1104 # ffffffffc0206188 <commands+0x840>
ffffffffc02015e0:	eaffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	e3c68693          	addi	a3,a3,-452 # ffffffffc0206420 <commands+0xad8>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	b8460613          	addi	a2,a2,-1148 # ffffffffc0206170 <commands+0x828>
ffffffffc02015f4:	12e00593          	li	a1,302
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	b9050513          	addi	a0,a0,-1136 # ffffffffc0206188 <commands+0x840>
ffffffffc0201600:	e8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	df468693          	addi	a3,a3,-524 # ffffffffc02063f8 <commands+0xab0>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	b6460613          	addi	a2,a2,-1180 # ffffffffc0206170 <commands+0x828>
ffffffffc0201614:	12d00593          	li	a1,301
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206188 <commands+0x840>
ffffffffc0201620:	e6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	dc468693          	addi	a3,a3,-572 # ffffffffc02063e8 <commands+0xaa0>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	b4460613          	addi	a2,a2,-1212 # ffffffffc0206170 <commands+0x828>
ffffffffc0201634:	12800593          	li	a1,296
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	b5050513          	addi	a0,a0,-1200 # ffffffffc0206188 <commands+0x840>
ffffffffc0201640:	e4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	ca468693          	addi	a3,a3,-860 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	b2460613          	addi	a2,a2,-1244 # ffffffffc0206170 <commands+0x828>
ffffffffc0201654:	12700593          	li	a1,295
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0206188 <commands+0x840>
ffffffffc0201660:	e2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	d6468693          	addi	a3,a3,-668 # ffffffffc02063c8 <commands+0xa80>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	b0460613          	addi	a2,a2,-1276 # ffffffffc0206170 <commands+0x828>
ffffffffc0201674:	12600593          	li	a1,294
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0206188 <commands+0x840>
ffffffffc0201680:	e0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	d1468693          	addi	a3,a3,-748 # ffffffffc0206398 <commands+0xa50>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	ae460613          	addi	a2,a2,-1308 # ffffffffc0206170 <commands+0x828>
ffffffffc0201694:	12500593          	li	a1,293
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	af050513          	addi	a0,a0,-1296 # ffffffffc0206188 <commands+0x840>
ffffffffc02016a0:	deffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	cdc68693          	addi	a3,a3,-804 # ffffffffc0206380 <commands+0xa38>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	ac460613          	addi	a2,a2,-1340 # ffffffffc0206170 <commands+0x828>
ffffffffc02016b4:	12400593          	li	a1,292
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	ad050513          	addi	a0,a0,-1328 # ffffffffc0206188 <commands+0x840>
ffffffffc02016c0:	dcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	c2468693          	addi	a3,a3,-988 # ffffffffc02062e8 <commands+0x9a0>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	aa460613          	addi	a2,a2,-1372 # ffffffffc0206170 <commands+0x828>
ffffffffc02016d4:	11e00593          	li	a1,286
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	ab050513          	addi	a0,a0,-1360 # ffffffffc0206188 <commands+0x840>
ffffffffc02016e0:	daffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	c8468693          	addi	a3,a3,-892 # ffffffffc0206368 <commands+0xa20>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	a8460613          	addi	a2,a2,-1404 # ffffffffc0206170 <commands+0x828>
ffffffffc02016f4:	11900593          	li	a1,281
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	a9050513          	addi	a0,a0,-1392 # ffffffffc0206188 <commands+0x840>
ffffffffc0201700:	d8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	d8468693          	addi	a3,a3,-636 # ffffffffc0206488 <commands+0xb40>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	a6460613          	addi	a2,a2,-1436 # ffffffffc0206170 <commands+0x828>
ffffffffc0201714:	13700593          	li	a1,311
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	a7050513          	addi	a0,a0,-1424 # ffffffffc0206188 <commands+0x840>
ffffffffc0201720:	d6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	d9468693          	addi	a3,a3,-620 # ffffffffc02064b8 <commands+0xb70>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	a4460613          	addi	a2,a2,-1468 # ffffffffc0206170 <commands+0x828>
ffffffffc0201734:	14700593          	li	a1,327
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	a5050513          	addi	a0,a0,-1456 # ffffffffc0206188 <commands+0x840>
ffffffffc0201740:	d4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	a5c68693          	addi	a3,a3,-1444 # ffffffffc02061a0 <commands+0x858>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	a2460613          	addi	a2,a2,-1500 # ffffffffc0206170 <commands+0x828>
ffffffffc0201754:	11300593          	li	a1,275
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	a3050513          	addi	a0,a0,-1488 # ffffffffc0206188 <commands+0x840>
ffffffffc0201760:	d2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201764:	00005697          	auipc	a3,0x5
ffffffffc0201768:	a7c68693          	addi	a3,a3,-1412 # ffffffffc02061e0 <commands+0x898>
ffffffffc020176c:	00005617          	auipc	a2,0x5
ffffffffc0201770:	a0460613          	addi	a2,a2,-1532 # ffffffffc0206170 <commands+0x828>
ffffffffc0201774:	0d800593          	li	a1,216
ffffffffc0201778:	00005517          	auipc	a0,0x5
ffffffffc020177c:	a1050513          	addi	a0,a0,-1520 # ffffffffc0206188 <commands+0x840>
ffffffffc0201780:	d0ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201784 <default_free_pages>:
{
ffffffffc0201784:	1141                	addi	sp,sp,-16
ffffffffc0201786:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201788:	14058463          	beqz	a1,ffffffffc02018d0 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc020178c:	00659693          	slli	a3,a1,0x6
ffffffffc0201790:	96aa                	add	a3,a3,a0
ffffffffc0201792:	87aa                	mv	a5,a0
ffffffffc0201794:	02d50263          	beq	a0,a3,ffffffffc02017b8 <default_free_pages+0x34>
ffffffffc0201798:	6798                	ld	a4,8(a5)
ffffffffc020179a:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020179c:	10071a63          	bnez	a4,ffffffffc02018b0 <default_free_pages+0x12c>
ffffffffc02017a0:	6798                	ld	a4,8(a5)
ffffffffc02017a2:	8b09                	andi	a4,a4,2
ffffffffc02017a4:	10071663          	bnez	a4,ffffffffc02018b0 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02017a8:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017ac:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017b0:	04078793          	addi	a5,a5,64
ffffffffc02017b4:	fed792e3          	bne	a5,a3,ffffffffc0201798 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017b8:	2581                	sext.w	a1,a1
ffffffffc02017ba:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017bc:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017c0:	4789                	li	a5,2
ffffffffc02017c2:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017c6:	000a5697          	auipc	a3,0xa5
ffffffffc02017ca:	0d268693          	addi	a3,a3,210 # ffffffffc02a6898 <free_area>
ffffffffc02017ce:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017d0:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017d2:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017d6:	9db9                	addw	a1,a1,a4
ffffffffc02017d8:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017da:	0ad78463          	beq	a5,a3,ffffffffc0201882 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02017de:	fe878713          	addi	a4,a5,-24
ffffffffc02017e2:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017e6:	4581                	li	a1,0
            if (base < page)
ffffffffc02017e8:	00e56a63          	bltu	a0,a4,ffffffffc02017fc <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017ec:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017ee:	04d70c63          	beq	a4,a3,ffffffffc0201846 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02017f2:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017f4:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017f8:	fee57ae3          	bgeu	a0,a4,ffffffffc02017ec <default_free_pages+0x68>
ffffffffc02017fc:	c199                	beqz	a1,ffffffffc0201802 <default_free_pages+0x7e>
ffffffffc02017fe:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201802:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201804:	e390                	sd	a2,0(a5)
ffffffffc0201806:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201808:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020180a:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc020180c:	00d70d63          	beq	a4,a3,ffffffffc0201826 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201810:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201814:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201818:	02059813          	slli	a6,a1,0x20
ffffffffc020181c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201820:	97b2                	add	a5,a5,a2
ffffffffc0201822:	02f50c63          	beq	a0,a5,ffffffffc020185a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201826:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201828:	00d78c63          	beq	a5,a3,ffffffffc0201840 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020182c:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020182e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201832:	02061593          	slli	a1,a2,0x20
ffffffffc0201836:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020183a:	972a                	add	a4,a4,a0
ffffffffc020183c:	04e68a63          	beq	a3,a4,ffffffffc0201890 <default_free_pages+0x10c>
}
ffffffffc0201840:	60a2                	ld	ra,8(sp)
ffffffffc0201842:	0141                	addi	sp,sp,16
ffffffffc0201844:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201846:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201848:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020184a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020184c:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc020184e:	02d70763          	beq	a4,a3,ffffffffc020187c <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201852:	8832                	mv	a6,a2
ffffffffc0201854:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201856:	87ba                	mv	a5,a4
ffffffffc0201858:	bf71                	j	ffffffffc02017f4 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020185a:	491c                	lw	a5,16(a0)
ffffffffc020185c:	9dbd                	addw	a1,a1,a5
ffffffffc020185e:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201862:	57f5                	li	a5,-3
ffffffffc0201864:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201868:	01853803          	ld	a6,24(a0)
ffffffffc020186c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020186e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201870:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201874:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201876:	0105b023          	sd	a6,0(a1)
ffffffffc020187a:	b77d                	j	ffffffffc0201828 <default_free_pages+0xa4>
ffffffffc020187c:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc020187e:	873e                	mv	a4,a5
ffffffffc0201880:	bf41                	j	ffffffffc0201810 <default_free_pages+0x8c>
}
ffffffffc0201882:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201884:	e390                	sd	a2,0(a5)
ffffffffc0201886:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201888:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020188a:	ed1c                	sd	a5,24(a0)
ffffffffc020188c:	0141                	addi	sp,sp,16
ffffffffc020188e:	8082                	ret
            base->property += p->property;
ffffffffc0201890:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201894:	ff078693          	addi	a3,a5,-16
ffffffffc0201898:	9e39                	addw	a2,a2,a4
ffffffffc020189a:	c910                	sw	a2,16(a0)
ffffffffc020189c:	5775                	li	a4,-3
ffffffffc020189e:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018a2:	6398                	ld	a4,0(a5)
ffffffffc02018a4:	679c                	ld	a5,8(a5)
}
ffffffffc02018a6:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018a8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018aa:	e398                	sd	a4,0(a5)
ffffffffc02018ac:	0141                	addi	sp,sp,16
ffffffffc02018ae:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018b0:	00005697          	auipc	a3,0x5
ffffffffc02018b4:	c2068693          	addi	a3,a3,-992 # ffffffffc02064d0 <commands+0xb88>
ffffffffc02018b8:	00005617          	auipc	a2,0x5
ffffffffc02018bc:	8b860613          	addi	a2,a2,-1864 # ffffffffc0206170 <commands+0x828>
ffffffffc02018c0:	09400593          	li	a1,148
ffffffffc02018c4:	00005517          	auipc	a0,0x5
ffffffffc02018c8:	8c450513          	addi	a0,a0,-1852 # ffffffffc0206188 <commands+0x840>
ffffffffc02018cc:	bc3fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc02018d0:	00005697          	auipc	a3,0x5
ffffffffc02018d4:	bf868693          	addi	a3,a3,-1032 # ffffffffc02064c8 <commands+0xb80>
ffffffffc02018d8:	00005617          	auipc	a2,0x5
ffffffffc02018dc:	89860613          	addi	a2,a2,-1896 # ffffffffc0206170 <commands+0x828>
ffffffffc02018e0:	09000593          	li	a1,144
ffffffffc02018e4:	00005517          	auipc	a0,0x5
ffffffffc02018e8:	8a450513          	addi	a0,a0,-1884 # ffffffffc0206188 <commands+0x840>
ffffffffc02018ec:	ba3fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02018f0 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018f0:	c941                	beqz	a0,ffffffffc0201980 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018f2:	000a5597          	auipc	a1,0xa5
ffffffffc02018f6:	fa658593          	addi	a1,a1,-90 # ffffffffc02a6898 <free_area>
ffffffffc02018fa:	0105a803          	lw	a6,16(a1)
ffffffffc02018fe:	872a                	mv	a4,a0
ffffffffc0201900:	02081793          	slli	a5,a6,0x20
ffffffffc0201904:	9381                	srli	a5,a5,0x20
ffffffffc0201906:	00a7ee63          	bltu	a5,a0,ffffffffc0201922 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020190a:	87ae                	mv	a5,a1
ffffffffc020190c:	a801                	j	ffffffffc020191c <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc020190e:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201912:	02069613          	slli	a2,a3,0x20
ffffffffc0201916:	9201                	srli	a2,a2,0x20
ffffffffc0201918:	00e67763          	bgeu	a2,a4,ffffffffc0201926 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc020191c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc020191e:	feb798e3          	bne	a5,a1,ffffffffc020190e <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201922:	4501                	li	a0,0
}
ffffffffc0201924:	8082                	ret
    return listelm->prev;
ffffffffc0201926:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020192a:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020192e:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201932:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201936:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020193a:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc020193e:	02c77863          	bgeu	a4,a2,ffffffffc020196e <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201942:	071a                	slli	a4,a4,0x6
ffffffffc0201944:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201946:	41c686bb          	subw	a3,a3,t3
ffffffffc020194a:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020194c:	00870613          	addi	a2,a4,8
ffffffffc0201950:	4689                	li	a3,2
ffffffffc0201952:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201956:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020195a:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc020195e:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201962:	e290                	sd	a2,0(a3)
ffffffffc0201964:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201968:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020196a:	01173c23          	sd	a7,24(a4)
ffffffffc020196e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201972:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201976:	5775                	li	a4,-3
ffffffffc0201978:	17c1                	addi	a5,a5,-16
ffffffffc020197a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020197e:	8082                	ret
{
ffffffffc0201980:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201982:	00005697          	auipc	a3,0x5
ffffffffc0201986:	b4668693          	addi	a3,a3,-1210 # ffffffffc02064c8 <commands+0xb80>
ffffffffc020198a:	00004617          	auipc	a2,0x4
ffffffffc020198e:	7e660613          	addi	a2,a2,2022 # ffffffffc0206170 <commands+0x828>
ffffffffc0201992:	06c00593          	li	a1,108
ffffffffc0201996:	00004517          	auipc	a0,0x4
ffffffffc020199a:	7f250513          	addi	a0,a0,2034 # ffffffffc0206188 <commands+0x840>
{
ffffffffc020199e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019a0:	aeffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02019a4 <default_init_memmap>:
{
ffffffffc02019a4:	1141                	addi	sp,sp,-16
ffffffffc02019a6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019a8:	c5f1                	beqz	a1,ffffffffc0201a74 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02019aa:	00659693          	slli	a3,a1,0x6
ffffffffc02019ae:	96aa                	add	a3,a3,a0
ffffffffc02019b0:	87aa                	mv	a5,a0
ffffffffc02019b2:	00d50f63          	beq	a0,a3,ffffffffc02019d0 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019b6:	6798                	ld	a4,8(a5)
ffffffffc02019b8:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02019ba:	cf49                	beqz	a4,ffffffffc0201a54 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019bc:	0007a823          	sw	zero,16(a5)
ffffffffc02019c0:	0007b423          	sd	zero,8(a5)
ffffffffc02019c4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019c8:	04078793          	addi	a5,a5,64
ffffffffc02019cc:	fed795e3          	bne	a5,a3,ffffffffc02019b6 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019d0:	2581                	sext.w	a1,a1
ffffffffc02019d2:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019d4:	4789                	li	a5,2
ffffffffc02019d6:	00850713          	addi	a4,a0,8
ffffffffc02019da:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019de:	000a5697          	auipc	a3,0xa5
ffffffffc02019e2:	eba68693          	addi	a3,a3,-326 # ffffffffc02a6898 <free_area>
ffffffffc02019e6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019e8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019ea:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019ee:	9db9                	addw	a1,a1,a4
ffffffffc02019f0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019f2:	04d78a63          	beq	a5,a3,ffffffffc0201a46 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019f6:	fe878713          	addi	a4,a5,-24
ffffffffc02019fa:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019fe:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a00:	00e56a63          	bltu	a0,a4,ffffffffc0201a14 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a04:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a06:	02d70263          	beq	a4,a3,ffffffffc0201a2a <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201a0a:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a0c:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a10:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a04 <default_init_memmap+0x60>
ffffffffc0201a14:	c199                	beqz	a1,ffffffffc0201a1a <default_init_memmap+0x76>
ffffffffc0201a16:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a1a:	6398                	ld	a4,0(a5)
}
ffffffffc0201a1c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a1e:	e390                	sd	a2,0(a5)
ffffffffc0201a20:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a22:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a24:	ed18                	sd	a4,24(a0)
ffffffffc0201a26:	0141                	addi	sp,sp,16
ffffffffc0201a28:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a2a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a2c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a2e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a30:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a32:	00d70663          	beq	a4,a3,ffffffffc0201a3e <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a36:	8832                	mv	a6,a2
ffffffffc0201a38:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a3a:	87ba                	mv	a5,a4
ffffffffc0201a3c:	bfc1                	j	ffffffffc0201a0c <default_init_memmap+0x68>
}
ffffffffc0201a3e:	60a2                	ld	ra,8(sp)
ffffffffc0201a40:	e290                	sd	a2,0(a3)
ffffffffc0201a42:	0141                	addi	sp,sp,16
ffffffffc0201a44:	8082                	ret
ffffffffc0201a46:	60a2                	ld	ra,8(sp)
ffffffffc0201a48:	e390                	sd	a2,0(a5)
ffffffffc0201a4a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a4c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a4e:	ed1c                	sd	a5,24(a0)
ffffffffc0201a50:	0141                	addi	sp,sp,16
ffffffffc0201a52:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a54:	00005697          	auipc	a3,0x5
ffffffffc0201a58:	aa468693          	addi	a3,a3,-1372 # ffffffffc02064f8 <commands+0xbb0>
ffffffffc0201a5c:	00004617          	auipc	a2,0x4
ffffffffc0201a60:	71460613          	addi	a2,a2,1812 # ffffffffc0206170 <commands+0x828>
ffffffffc0201a64:	04b00593          	li	a1,75
ffffffffc0201a68:	00004517          	auipc	a0,0x4
ffffffffc0201a6c:	72050513          	addi	a0,a0,1824 # ffffffffc0206188 <commands+0x840>
ffffffffc0201a70:	a1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a74:	00005697          	auipc	a3,0x5
ffffffffc0201a78:	a5468693          	addi	a3,a3,-1452 # ffffffffc02064c8 <commands+0xb80>
ffffffffc0201a7c:	00004617          	auipc	a2,0x4
ffffffffc0201a80:	6f460613          	addi	a2,a2,1780 # ffffffffc0206170 <commands+0x828>
ffffffffc0201a84:	04700593          	li	a1,71
ffffffffc0201a88:	00004517          	auipc	a0,0x4
ffffffffc0201a8c:	70050513          	addi	a0,a0,1792 # ffffffffc0206188 <commands+0x840>
ffffffffc0201a90:	9fffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a94 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a94:	c94d                	beqz	a0,ffffffffc0201b46 <slob_free+0xb2>
{
ffffffffc0201a96:	1141                	addi	sp,sp,-16
ffffffffc0201a98:	e022                	sd	s0,0(sp)
ffffffffc0201a9a:	e406                	sd	ra,8(sp)
ffffffffc0201a9c:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a9e:	e9c1                	bnez	a1,ffffffffc0201b2e <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aa0:	100027f3          	csrr	a5,sstatus
ffffffffc0201aa4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201aa6:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201aa8:	ebd9                	bnez	a5,ffffffffc0201b3e <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aaa:	000a5617          	auipc	a2,0xa5
ffffffffc0201aae:	9de60613          	addi	a2,a2,-1570 # ffffffffc02a6488 <slobfree>
ffffffffc0201ab2:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ab4:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201ab6:	679c                	ld	a5,8(a5)
ffffffffc0201ab8:	02877a63          	bgeu	a4,s0,ffffffffc0201aec <slob_free+0x58>
ffffffffc0201abc:	00f46463          	bltu	s0,a5,ffffffffc0201ac4 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ac0:	fef76ae3          	bltu	a4,a5,ffffffffc0201ab4 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201ac4:	400c                	lw	a1,0(s0)
ffffffffc0201ac6:	00459693          	slli	a3,a1,0x4
ffffffffc0201aca:	96a2                	add	a3,a3,s0
ffffffffc0201acc:	02d78a63          	beq	a5,a3,ffffffffc0201b00 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ad0:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201ad2:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ad4:	00469793          	slli	a5,a3,0x4
ffffffffc0201ad8:	97ba                	add	a5,a5,a4
ffffffffc0201ada:	02f40e63          	beq	s0,a5,ffffffffc0201b16 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201ade:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201ae0:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ae2:	e129                	bnez	a0,ffffffffc0201b24 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201ae4:	60a2                	ld	ra,8(sp)
ffffffffc0201ae6:	6402                	ld	s0,0(sp)
ffffffffc0201ae8:	0141                	addi	sp,sp,16
ffffffffc0201aea:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aec:	fcf764e3          	bltu	a4,a5,ffffffffc0201ab4 <slob_free+0x20>
ffffffffc0201af0:	fcf472e3          	bgeu	s0,a5,ffffffffc0201ab4 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201af4:	400c                	lw	a1,0(s0)
ffffffffc0201af6:	00459693          	slli	a3,a1,0x4
ffffffffc0201afa:	96a2                	add	a3,a3,s0
ffffffffc0201afc:	fcd79ae3          	bne	a5,a3,ffffffffc0201ad0 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201b00:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b02:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b04:	9db5                	addw	a1,a1,a3
ffffffffc0201b06:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201b08:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201b0a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b0c:	00469793          	slli	a5,a3,0x4
ffffffffc0201b10:	97ba                	add	a5,a5,a4
ffffffffc0201b12:	fcf416e3          	bne	s0,a5,ffffffffc0201ade <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201b16:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201b18:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201b1a:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b1c:	9ebd                	addw	a3,a3,a5
ffffffffc0201b1e:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b20:	e70c                	sd	a1,8(a4)
ffffffffc0201b22:	d169                	beqz	a0,ffffffffc0201ae4 <slob_free+0x50>
}
ffffffffc0201b24:	6402                	ld	s0,0(sp)
ffffffffc0201b26:	60a2                	ld	ra,8(sp)
ffffffffc0201b28:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b2a:	e85fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b2e:	25bd                	addiw	a1,a1,15
ffffffffc0201b30:	8191                	srli	a1,a1,0x4
ffffffffc0201b32:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b34:	100027f3          	csrr	a5,sstatus
ffffffffc0201b38:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b3a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b3c:	d7bd                	beqz	a5,ffffffffc0201aaa <slob_free+0x16>
        intr_disable();
ffffffffc0201b3e:	e77fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b42:	4505                	li	a0,1
ffffffffc0201b44:	b79d                	j	ffffffffc0201aaa <slob_free+0x16>
ffffffffc0201b46:	8082                	ret

ffffffffc0201b48 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b48:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b4a:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b4c:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b50:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b52:	352000ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
	if (!page)
ffffffffc0201b56:	c91d                	beqz	a0,ffffffffc0201b8c <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b58:	000a9697          	auipc	a3,0xa9
ffffffffc0201b5c:	db86b683          	ld	a3,-584(a3) # ffffffffc02aa910 <pages>
ffffffffc0201b60:	8d15                	sub	a0,a0,a3
ffffffffc0201b62:	8519                	srai	a0,a0,0x6
ffffffffc0201b64:	00006697          	auipc	a3,0x6
ffffffffc0201b68:	cdc6b683          	ld	a3,-804(a3) # ffffffffc0207840 <nbase>
ffffffffc0201b6c:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201b6e:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b72:	83b1                	srli	a5,a5,0xc
ffffffffc0201b74:	000a9717          	auipc	a4,0xa9
ffffffffc0201b78:	d9473703          	ld	a4,-620(a4) # ffffffffc02aa908 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b7c:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b7e:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b92 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b82:	000a9697          	auipc	a3,0xa9
ffffffffc0201b86:	d9e6b683          	ld	a3,-610(a3) # ffffffffc02aa920 <va_pa_offset>
ffffffffc0201b8a:	9536                	add	a0,a0,a3
}
ffffffffc0201b8c:	60a2                	ld	ra,8(sp)
ffffffffc0201b8e:	0141                	addi	sp,sp,16
ffffffffc0201b90:	8082                	ret
ffffffffc0201b92:	86aa                	mv	a3,a0
ffffffffc0201b94:	00005617          	auipc	a2,0x5
ffffffffc0201b98:	9c460613          	addi	a2,a2,-1596 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0201b9c:	07100593          	li	a1,113
ffffffffc0201ba0:	00005517          	auipc	a0,0x5
ffffffffc0201ba4:	9e050513          	addi	a0,a0,-1568 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0201ba8:	8e7fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201bac <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201bac:	1101                	addi	sp,sp,-32
ffffffffc0201bae:	ec06                	sd	ra,24(sp)
ffffffffc0201bb0:	e822                	sd	s0,16(sp)
ffffffffc0201bb2:	e426                	sd	s1,8(sp)
ffffffffc0201bb4:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bb6:	01050713          	addi	a4,a0,16
ffffffffc0201bba:	6785                	lui	a5,0x1
ffffffffc0201bbc:	0cf77363          	bgeu	a4,a5,ffffffffc0201c82 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201bc0:	00f50493          	addi	s1,a0,15
ffffffffc0201bc4:	8091                	srli	s1,s1,0x4
ffffffffc0201bc6:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bc8:	10002673          	csrr	a2,sstatus
ffffffffc0201bcc:	8a09                	andi	a2,a2,2
ffffffffc0201bce:	e25d                	bnez	a2,ffffffffc0201c74 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201bd0:	000a5917          	auipc	s2,0xa5
ffffffffc0201bd4:	8b890913          	addi	s2,s2,-1864 # ffffffffc02a6488 <slobfree>
ffffffffc0201bd8:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bdc:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201bde:	4398                	lw	a4,0(a5)
ffffffffc0201be0:	08975e63          	bge	a4,s1,ffffffffc0201c7c <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201be4:	00f68b63          	beq	a3,a5,ffffffffc0201bfa <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201be8:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bea:	4018                	lw	a4,0(s0)
ffffffffc0201bec:	02975a63          	bge	a4,s1,ffffffffc0201c20 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201bf0:	00093683          	ld	a3,0(s2)
ffffffffc0201bf4:	87a2                	mv	a5,s0
ffffffffc0201bf6:	fef699e3          	bne	a3,a5,ffffffffc0201be8 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201bfa:	ee31                	bnez	a2,ffffffffc0201c56 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201bfc:	4501                	li	a0,0
ffffffffc0201bfe:	f4bff0ef          	jal	ra,ffffffffc0201b48 <__slob_get_free_pages.constprop.0>
ffffffffc0201c02:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c04:	cd05                	beqz	a0,ffffffffc0201c3c <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c06:	6585                	lui	a1,0x1
ffffffffc0201c08:	e8dff0ef          	jal	ra,ffffffffc0201a94 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c0c:	10002673          	csrr	a2,sstatus
ffffffffc0201c10:	8a09                	andi	a2,a2,2
ffffffffc0201c12:	ee05                	bnez	a2,ffffffffc0201c4a <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c14:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c18:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c1a:	4018                	lw	a4,0(s0)
ffffffffc0201c1c:	fc974ae3          	blt	a4,s1,ffffffffc0201bf0 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c20:	04e48763          	beq	s1,a4,ffffffffc0201c6e <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c24:	00449693          	slli	a3,s1,0x4
ffffffffc0201c28:	96a2                	add	a3,a3,s0
ffffffffc0201c2a:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c2c:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c2e:	9f05                	subw	a4,a4,s1
ffffffffc0201c30:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c32:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c34:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c36:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c3a:	e20d                	bnez	a2,ffffffffc0201c5c <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c3c:	60e2                	ld	ra,24(sp)
ffffffffc0201c3e:	8522                	mv	a0,s0
ffffffffc0201c40:	6442                	ld	s0,16(sp)
ffffffffc0201c42:	64a2                	ld	s1,8(sp)
ffffffffc0201c44:	6902                	ld	s2,0(sp)
ffffffffc0201c46:	6105                	addi	sp,sp,32
ffffffffc0201c48:	8082                	ret
        intr_disable();
ffffffffc0201c4a:	d6bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c4e:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c52:	4605                	li	a2,1
ffffffffc0201c54:	b7d1                	j	ffffffffc0201c18 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c56:	d59fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c5a:	b74d                	j	ffffffffc0201bfc <slob_alloc.constprop.0+0x50>
ffffffffc0201c5c:	d53fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201c60:	60e2                	ld	ra,24(sp)
ffffffffc0201c62:	8522                	mv	a0,s0
ffffffffc0201c64:	6442                	ld	s0,16(sp)
ffffffffc0201c66:	64a2                	ld	s1,8(sp)
ffffffffc0201c68:	6902                	ld	s2,0(sp)
ffffffffc0201c6a:	6105                	addi	sp,sp,32
ffffffffc0201c6c:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c6e:	6418                	ld	a4,8(s0)
ffffffffc0201c70:	e798                	sd	a4,8(a5)
ffffffffc0201c72:	b7d1                	j	ffffffffc0201c36 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c74:	d41fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201c78:	4605                	li	a2,1
ffffffffc0201c7a:	bf99                	j	ffffffffc0201bd0 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201c7c:	843e                	mv	s0,a5
ffffffffc0201c7e:	87b6                	mv	a5,a3
ffffffffc0201c80:	b745                	j	ffffffffc0201c20 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c82:	00005697          	auipc	a3,0x5
ffffffffc0201c86:	90e68693          	addi	a3,a3,-1778 # ffffffffc0206590 <default_pmm_manager+0x70>
ffffffffc0201c8a:	00004617          	auipc	a2,0x4
ffffffffc0201c8e:	4e660613          	addi	a2,a2,1254 # ffffffffc0206170 <commands+0x828>
ffffffffc0201c92:	06300593          	li	a1,99
ffffffffc0201c96:	00005517          	auipc	a0,0x5
ffffffffc0201c9a:	91a50513          	addi	a0,a0,-1766 # ffffffffc02065b0 <default_pmm_manager+0x90>
ffffffffc0201c9e:	ff0fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ca2 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ca2:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201ca4:	00005517          	auipc	a0,0x5
ffffffffc0201ca8:	92450513          	addi	a0,a0,-1756 # ffffffffc02065c8 <default_pmm_manager+0xa8>
{
ffffffffc0201cac:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201cae:	ce6fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201cb2:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cb4:	00005517          	auipc	a0,0x5
ffffffffc0201cb8:	92c50513          	addi	a0,a0,-1748 # ffffffffc02065e0 <default_pmm_manager+0xc0>
}
ffffffffc0201cbc:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cbe:	cd6fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201cc2 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201cc2:	4501                	li	a0,0
ffffffffc0201cc4:	8082                	ret

ffffffffc0201cc6 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201cc6:	1101                	addi	sp,sp,-32
ffffffffc0201cc8:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cca:	6905                	lui	s2,0x1
{
ffffffffc0201ccc:	e822                	sd	s0,16(sp)
ffffffffc0201cce:	ec06                	sd	ra,24(sp)
ffffffffc0201cd0:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cd2:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bd9>
{
ffffffffc0201cd6:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cd8:	04a7f963          	bgeu	a5,a0,ffffffffc0201d2a <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201cdc:	4561                	li	a0,24
ffffffffc0201cde:	ecfff0ef          	jal	ra,ffffffffc0201bac <slob_alloc.constprop.0>
ffffffffc0201ce2:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201ce4:	c929                	beqz	a0,ffffffffc0201d36 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201ce6:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201cea:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201cec:	00f95763          	bge	s2,a5,ffffffffc0201cfa <kmalloc+0x34>
ffffffffc0201cf0:	6705                	lui	a4,0x1
ffffffffc0201cf2:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201cf4:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cf6:	fef74ee3          	blt	a4,a5,ffffffffc0201cf2 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201cfa:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201cfc:	e4dff0ef          	jal	ra,ffffffffc0201b48 <__slob_get_free_pages.constprop.0>
ffffffffc0201d00:	e488                	sd	a0,8(s1)
ffffffffc0201d02:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201d04:	c525                	beqz	a0,ffffffffc0201d6c <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d06:	100027f3          	csrr	a5,sstatus
ffffffffc0201d0a:	8b89                	andi	a5,a5,2
ffffffffc0201d0c:	ef8d                	bnez	a5,ffffffffc0201d46 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d0e:	000a9797          	auipc	a5,0xa9
ffffffffc0201d12:	be278793          	addi	a5,a5,-1054 # ffffffffc02aa8f0 <bigblocks>
ffffffffc0201d16:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d18:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d1a:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d1c:	60e2                	ld	ra,24(sp)
ffffffffc0201d1e:	8522                	mv	a0,s0
ffffffffc0201d20:	6442                	ld	s0,16(sp)
ffffffffc0201d22:	64a2                	ld	s1,8(sp)
ffffffffc0201d24:	6902                	ld	s2,0(sp)
ffffffffc0201d26:	6105                	addi	sp,sp,32
ffffffffc0201d28:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d2a:	0541                	addi	a0,a0,16
ffffffffc0201d2c:	e81ff0ef          	jal	ra,ffffffffc0201bac <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d30:	01050413          	addi	s0,a0,16
ffffffffc0201d34:	f565                	bnez	a0,ffffffffc0201d1c <kmalloc+0x56>
ffffffffc0201d36:	4401                	li	s0,0
}
ffffffffc0201d38:	60e2                	ld	ra,24(sp)
ffffffffc0201d3a:	8522                	mv	a0,s0
ffffffffc0201d3c:	6442                	ld	s0,16(sp)
ffffffffc0201d3e:	64a2                	ld	s1,8(sp)
ffffffffc0201d40:	6902                	ld	s2,0(sp)
ffffffffc0201d42:	6105                	addi	sp,sp,32
ffffffffc0201d44:	8082                	ret
        intr_disable();
ffffffffc0201d46:	c6ffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d4a:	000a9797          	auipc	a5,0xa9
ffffffffc0201d4e:	ba678793          	addi	a5,a5,-1114 # ffffffffc02aa8f0 <bigblocks>
ffffffffc0201d52:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d54:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d56:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d58:	c57fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d5c:	6480                	ld	s0,8(s1)
}
ffffffffc0201d5e:	60e2                	ld	ra,24(sp)
ffffffffc0201d60:	64a2                	ld	s1,8(sp)
ffffffffc0201d62:	8522                	mv	a0,s0
ffffffffc0201d64:	6442                	ld	s0,16(sp)
ffffffffc0201d66:	6902                	ld	s2,0(sp)
ffffffffc0201d68:	6105                	addi	sp,sp,32
ffffffffc0201d6a:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d6c:	45e1                	li	a1,24
ffffffffc0201d6e:	8526                	mv	a0,s1
ffffffffc0201d70:	d25ff0ef          	jal	ra,ffffffffc0201a94 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201d74:	b765                	j	ffffffffc0201d1c <kmalloc+0x56>

ffffffffc0201d76 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d76:	c169                	beqz	a0,ffffffffc0201e38 <kfree+0xc2>
{
ffffffffc0201d78:	1101                	addi	sp,sp,-32
ffffffffc0201d7a:	e822                	sd	s0,16(sp)
ffffffffc0201d7c:	ec06                	sd	ra,24(sp)
ffffffffc0201d7e:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d80:	03451793          	slli	a5,a0,0x34
ffffffffc0201d84:	842a                	mv	s0,a0
ffffffffc0201d86:	e3d9                	bnez	a5,ffffffffc0201e0c <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d88:	100027f3          	csrr	a5,sstatus
ffffffffc0201d8c:	8b89                	andi	a5,a5,2
ffffffffc0201d8e:	e7d9                	bnez	a5,ffffffffc0201e1c <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d90:	000a9797          	auipc	a5,0xa9
ffffffffc0201d94:	b607b783          	ld	a5,-1184(a5) # ffffffffc02aa8f0 <bigblocks>
    return 0;
ffffffffc0201d98:	4601                	li	a2,0
ffffffffc0201d9a:	cbad                	beqz	a5,ffffffffc0201e0c <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201d9c:	000a9697          	auipc	a3,0xa9
ffffffffc0201da0:	b5468693          	addi	a3,a3,-1196 # ffffffffc02aa8f0 <bigblocks>
ffffffffc0201da4:	a021                	j	ffffffffc0201dac <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201da6:	01048693          	addi	a3,s1,16
ffffffffc0201daa:	c3a5                	beqz	a5,ffffffffc0201e0a <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201dac:	6798                	ld	a4,8(a5)
ffffffffc0201dae:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201db0:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201db2:	fe871ae3          	bne	a4,s0,ffffffffc0201da6 <kfree+0x30>
				*last = bb->next;
ffffffffc0201db6:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201db8:	ee2d                	bnez	a2,ffffffffc0201e32 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201dba:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201dbe:	4098                	lw	a4,0(s1)
ffffffffc0201dc0:	08f46963          	bltu	s0,a5,ffffffffc0201e52 <kfree+0xdc>
ffffffffc0201dc4:	000a9697          	auipc	a3,0xa9
ffffffffc0201dc8:	b5c6b683          	ld	a3,-1188(a3) # ffffffffc02aa920 <va_pa_offset>
ffffffffc0201dcc:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201dce:	8031                	srli	s0,s0,0xc
ffffffffc0201dd0:	000a9797          	auipc	a5,0xa9
ffffffffc0201dd4:	b387b783          	ld	a5,-1224(a5) # ffffffffc02aa908 <npage>
ffffffffc0201dd8:	06f47163          	bgeu	s0,a5,ffffffffc0201e3a <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201ddc:	00006517          	auipc	a0,0x6
ffffffffc0201de0:	a6453503          	ld	a0,-1436(a0) # ffffffffc0207840 <nbase>
ffffffffc0201de4:	8c09                	sub	s0,s0,a0
ffffffffc0201de6:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201de8:	000a9517          	auipc	a0,0xa9
ffffffffc0201dec:	b2853503          	ld	a0,-1240(a0) # ffffffffc02aa910 <pages>
ffffffffc0201df0:	4585                	li	a1,1
ffffffffc0201df2:	9522                	add	a0,a0,s0
ffffffffc0201df4:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201df8:	0ea000ef          	jal	ra,ffffffffc0201ee2 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201dfc:	6442                	ld	s0,16(sp)
ffffffffc0201dfe:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e00:	8526                	mv	a0,s1
}
ffffffffc0201e02:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e04:	45e1                	li	a1,24
}
ffffffffc0201e06:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e08:	b171                	j	ffffffffc0201a94 <slob_free>
ffffffffc0201e0a:	e20d                	bnez	a2,ffffffffc0201e2c <kfree+0xb6>
ffffffffc0201e0c:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e10:	6442                	ld	s0,16(sp)
ffffffffc0201e12:	60e2                	ld	ra,24(sp)
ffffffffc0201e14:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e16:	4581                	li	a1,0
}
ffffffffc0201e18:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e1a:	b9ad                	j	ffffffffc0201a94 <slob_free>
        intr_disable();
ffffffffc0201e1c:	b99fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e20:	000a9797          	auipc	a5,0xa9
ffffffffc0201e24:	ad07b783          	ld	a5,-1328(a5) # ffffffffc02aa8f0 <bigblocks>
        return 1;
ffffffffc0201e28:	4605                	li	a2,1
ffffffffc0201e2a:	fbad                	bnez	a5,ffffffffc0201d9c <kfree+0x26>
        intr_enable();
ffffffffc0201e2c:	b83fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e30:	bff1                	j	ffffffffc0201e0c <kfree+0x96>
ffffffffc0201e32:	b7dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e36:	b751                	j	ffffffffc0201dba <kfree+0x44>
ffffffffc0201e38:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e3a:	00004617          	auipc	a2,0x4
ffffffffc0201e3e:	7ee60613          	addi	a2,a2,2030 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc0201e42:	06900593          	li	a1,105
ffffffffc0201e46:	00004517          	auipc	a0,0x4
ffffffffc0201e4a:	73a50513          	addi	a0,a0,1850 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0201e4e:	e40fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e52:	86a2                	mv	a3,s0
ffffffffc0201e54:	00004617          	auipc	a2,0x4
ffffffffc0201e58:	7ac60613          	addi	a2,a2,1964 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0201e5c:	07700593          	li	a1,119
ffffffffc0201e60:	00004517          	auipc	a0,0x4
ffffffffc0201e64:	72050513          	addi	a0,a0,1824 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0201e68:	e26fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e6c <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e6c:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e6e:	00004617          	auipc	a2,0x4
ffffffffc0201e72:	7ba60613          	addi	a2,a2,1978 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc0201e76:	06900593          	li	a1,105
ffffffffc0201e7a:	00004517          	auipc	a0,0x4
ffffffffc0201e7e:	70650513          	addi	a0,a0,1798 # ffffffffc0206580 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201e82:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201e84:	e0afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e88 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201e88:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201e8a:	00004617          	auipc	a2,0x4
ffffffffc0201e8e:	7be60613          	addi	a2,a2,1982 # ffffffffc0206648 <default_pmm_manager+0x128>
ffffffffc0201e92:	07f00593          	li	a1,127
ffffffffc0201e96:	00004517          	auipc	a0,0x4
ffffffffc0201e9a:	6ea50513          	addi	a0,a0,1770 # ffffffffc0206580 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201e9e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201ea0:	deefe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ea4 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ea4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ea8:	8b89                	andi	a5,a5,2
ffffffffc0201eaa:	e799                	bnez	a5,ffffffffc0201eb8 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eac:	000a9797          	auipc	a5,0xa9
ffffffffc0201eb0:	a6c7b783          	ld	a5,-1428(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201eb4:	6f9c                	ld	a5,24(a5)
ffffffffc0201eb6:	8782                	jr	a5
{
ffffffffc0201eb8:	1141                	addi	sp,sp,-16
ffffffffc0201eba:	e406                	sd	ra,8(sp)
ffffffffc0201ebc:	e022                	sd	s0,0(sp)
ffffffffc0201ebe:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201ec0:	af5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ec4:	000a9797          	auipc	a5,0xa9
ffffffffc0201ec8:	a547b783          	ld	a5,-1452(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201ecc:	6f9c                	ld	a5,24(a5)
ffffffffc0201ece:	8522                	mv	a0,s0
ffffffffc0201ed0:	9782                	jalr	a5
ffffffffc0201ed2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ed4:	adbfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ed8:	60a2                	ld	ra,8(sp)
ffffffffc0201eda:	8522                	mv	a0,s0
ffffffffc0201edc:	6402                	ld	s0,0(sp)
ffffffffc0201ede:	0141                	addi	sp,sp,16
ffffffffc0201ee0:	8082                	ret

ffffffffc0201ee2 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ee2:	100027f3          	csrr	a5,sstatus
ffffffffc0201ee6:	8b89                	andi	a5,a5,2
ffffffffc0201ee8:	e799                	bnez	a5,ffffffffc0201ef6 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201eea:	000a9797          	auipc	a5,0xa9
ffffffffc0201eee:	a2e7b783          	ld	a5,-1490(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201ef2:	739c                	ld	a5,32(a5)
ffffffffc0201ef4:	8782                	jr	a5
{
ffffffffc0201ef6:	1101                	addi	sp,sp,-32
ffffffffc0201ef8:	ec06                	sd	ra,24(sp)
ffffffffc0201efa:	e822                	sd	s0,16(sp)
ffffffffc0201efc:	e426                	sd	s1,8(sp)
ffffffffc0201efe:	842a                	mv	s0,a0
ffffffffc0201f00:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f02:	ab3fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f06:	000a9797          	auipc	a5,0xa9
ffffffffc0201f0a:	a127b783          	ld	a5,-1518(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201f0e:	739c                	ld	a5,32(a5)
ffffffffc0201f10:	85a6                	mv	a1,s1
ffffffffc0201f12:	8522                	mv	a0,s0
ffffffffc0201f14:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f16:	6442                	ld	s0,16(sp)
ffffffffc0201f18:	60e2                	ld	ra,24(sp)
ffffffffc0201f1a:	64a2                	ld	s1,8(sp)
ffffffffc0201f1c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f1e:	a91fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f22 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f22:	100027f3          	csrr	a5,sstatus
ffffffffc0201f26:	8b89                	andi	a5,a5,2
ffffffffc0201f28:	e799                	bnez	a5,ffffffffc0201f36 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f2a:	000a9797          	auipc	a5,0xa9
ffffffffc0201f2e:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201f32:	779c                	ld	a5,40(a5)
ffffffffc0201f34:	8782                	jr	a5
{
ffffffffc0201f36:	1141                	addi	sp,sp,-16
ffffffffc0201f38:	e406                	sd	ra,8(sp)
ffffffffc0201f3a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f3c:	a79fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f40:	000a9797          	auipc	a5,0xa9
ffffffffc0201f44:	9d87b783          	ld	a5,-1576(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201f48:	779c                	ld	a5,40(a5)
ffffffffc0201f4a:	9782                	jalr	a5
ffffffffc0201f4c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f4e:	a61fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f52:	60a2                	ld	ra,8(sp)
ffffffffc0201f54:	8522                	mv	a0,s0
ffffffffc0201f56:	6402                	ld	s0,0(sp)
ffffffffc0201f58:	0141                	addi	sp,sp,16
ffffffffc0201f5a:	8082                	ret

ffffffffc0201f5c <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f5c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f60:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201f64:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f66:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f68:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f6a:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f6e:	6094                	ld	a3,0(s1)
{
ffffffffc0201f70:	f04a                	sd	s2,32(sp)
ffffffffc0201f72:	ec4e                	sd	s3,24(sp)
ffffffffc0201f74:	e852                	sd	s4,16(sp)
ffffffffc0201f76:	fc06                	sd	ra,56(sp)
ffffffffc0201f78:	f822                	sd	s0,48(sp)
ffffffffc0201f7a:	e456                	sd	s5,8(sp)
ffffffffc0201f7c:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f7e:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f82:	892e                	mv	s2,a1
ffffffffc0201f84:	8a32                	mv	s4,a2
ffffffffc0201f86:	000a9997          	auipc	s3,0xa9
ffffffffc0201f8a:	98298993          	addi	s3,s3,-1662 # ffffffffc02aa908 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f8e:	efbd                	bnez	a5,ffffffffc020200c <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f90:	14060c63          	beqz	a2,ffffffffc02020e8 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f94:	100027f3          	csrr	a5,sstatus
ffffffffc0201f98:	8b89                	andi	a5,a5,2
ffffffffc0201f9a:	14079963          	bnez	a5,ffffffffc02020ec <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f9e:	000a9797          	auipc	a5,0xa9
ffffffffc0201fa2:	97a7b783          	ld	a5,-1670(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0201fa6:	6f9c                	ld	a5,24(a5)
ffffffffc0201fa8:	4505                	li	a0,1
ffffffffc0201faa:	9782                	jalr	a5
ffffffffc0201fac:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fae:	12040d63          	beqz	s0,ffffffffc02020e8 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201fb2:	000a9b17          	auipc	s6,0xa9
ffffffffc0201fb6:	95eb0b13          	addi	s6,s6,-1698 # ffffffffc02aa910 <pages>
ffffffffc0201fba:	000b3503          	ld	a0,0(s6)
ffffffffc0201fbe:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fc2:	000a9997          	auipc	s3,0xa9
ffffffffc0201fc6:	94698993          	addi	s3,s3,-1722 # ffffffffc02aa908 <npage>
ffffffffc0201fca:	40a40533          	sub	a0,s0,a0
ffffffffc0201fce:	8519                	srai	a0,a0,0x6
ffffffffc0201fd0:	9556                	add	a0,a0,s5
ffffffffc0201fd2:	0009b703          	ld	a4,0(s3)
ffffffffc0201fd6:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fda:	4685                	li	a3,1
ffffffffc0201fdc:	c014                	sw	a3,0(s0)
ffffffffc0201fde:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fe0:	0532                	slli	a0,a0,0xc
ffffffffc0201fe2:	16e7f763          	bgeu	a5,a4,ffffffffc0202150 <get_pte+0x1f4>
ffffffffc0201fe6:	000a9797          	auipc	a5,0xa9
ffffffffc0201fea:	93a7b783          	ld	a5,-1734(a5) # ffffffffc02aa920 <va_pa_offset>
ffffffffc0201fee:	6605                	lui	a2,0x1
ffffffffc0201ff0:	4581                	li	a1,0
ffffffffc0201ff2:	953e                	add	a0,a0,a5
ffffffffc0201ff4:	6bc030ef          	jal	ra,ffffffffc02056b0 <memset>
    return page - pages + nbase;
ffffffffc0201ff8:	000b3683          	ld	a3,0(s6)
ffffffffc0201ffc:	40d406b3          	sub	a3,s0,a3
ffffffffc0202000:	8699                	srai	a3,a3,0x6
ffffffffc0202002:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202004:	06aa                	slli	a3,a3,0xa
ffffffffc0202006:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020200a:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020200c:	77fd                	lui	a5,0xfffff
ffffffffc020200e:	068a                	slli	a3,a3,0x2
ffffffffc0202010:	0009b703          	ld	a4,0(s3)
ffffffffc0202014:	8efd                	and	a3,a3,a5
ffffffffc0202016:	00c6d793          	srli	a5,a3,0xc
ffffffffc020201a:	10e7ff63          	bgeu	a5,a4,ffffffffc0202138 <get_pte+0x1dc>
ffffffffc020201e:	000a9a97          	auipc	s5,0xa9
ffffffffc0202022:	902a8a93          	addi	s5,s5,-1790 # ffffffffc02aa920 <va_pa_offset>
ffffffffc0202026:	000ab403          	ld	s0,0(s5)
ffffffffc020202a:	01595793          	srli	a5,s2,0x15
ffffffffc020202e:	1ff7f793          	andi	a5,a5,511
ffffffffc0202032:	96a2                	add	a3,a3,s0
ffffffffc0202034:	00379413          	slli	s0,a5,0x3
ffffffffc0202038:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020203a:	6014                	ld	a3,0(s0)
ffffffffc020203c:	0016f793          	andi	a5,a3,1
ffffffffc0202040:	ebad                	bnez	a5,ffffffffc02020b2 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202042:	0a0a0363          	beqz	s4,ffffffffc02020e8 <get_pte+0x18c>
ffffffffc0202046:	100027f3          	csrr	a5,sstatus
ffffffffc020204a:	8b89                	andi	a5,a5,2
ffffffffc020204c:	efcd                	bnez	a5,ffffffffc0202106 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc020204e:	000a9797          	auipc	a5,0xa9
ffffffffc0202052:	8ca7b783          	ld	a5,-1846(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0202056:	6f9c                	ld	a5,24(a5)
ffffffffc0202058:	4505                	li	a0,1
ffffffffc020205a:	9782                	jalr	a5
ffffffffc020205c:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020205e:	c4c9                	beqz	s1,ffffffffc02020e8 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202060:	000a9b17          	auipc	s6,0xa9
ffffffffc0202064:	8b0b0b13          	addi	s6,s6,-1872 # ffffffffc02aa910 <pages>
ffffffffc0202068:	000b3503          	ld	a0,0(s6)
ffffffffc020206c:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202070:	0009b703          	ld	a4,0(s3)
ffffffffc0202074:	40a48533          	sub	a0,s1,a0
ffffffffc0202078:	8519                	srai	a0,a0,0x6
ffffffffc020207a:	9552                	add	a0,a0,s4
ffffffffc020207c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202080:	4685                	li	a3,1
ffffffffc0202082:	c094                	sw	a3,0(s1)
ffffffffc0202084:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202086:	0532                	slli	a0,a0,0xc
ffffffffc0202088:	0ee7f163          	bgeu	a5,a4,ffffffffc020216a <get_pte+0x20e>
ffffffffc020208c:	000ab783          	ld	a5,0(s5)
ffffffffc0202090:	6605                	lui	a2,0x1
ffffffffc0202092:	4581                	li	a1,0
ffffffffc0202094:	953e                	add	a0,a0,a5
ffffffffc0202096:	61a030ef          	jal	ra,ffffffffc02056b0 <memset>
    return page - pages + nbase;
ffffffffc020209a:	000b3683          	ld	a3,0(s6)
ffffffffc020209e:	40d486b3          	sub	a3,s1,a3
ffffffffc02020a2:	8699                	srai	a3,a3,0x6
ffffffffc02020a4:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020a6:	06aa                	slli	a3,a3,0xa
ffffffffc02020a8:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020ac:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020ae:	0009b703          	ld	a4,0(s3)
ffffffffc02020b2:	068a                	slli	a3,a3,0x2
ffffffffc02020b4:	757d                	lui	a0,0xfffff
ffffffffc02020b6:	8ee9                	and	a3,a3,a0
ffffffffc02020b8:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020bc:	06e7f263          	bgeu	a5,a4,ffffffffc0202120 <get_pte+0x1c4>
ffffffffc02020c0:	000ab503          	ld	a0,0(s5)
ffffffffc02020c4:	00c95913          	srli	s2,s2,0xc
ffffffffc02020c8:	1ff97913          	andi	s2,s2,511
ffffffffc02020cc:	96aa                	add	a3,a3,a0
ffffffffc02020ce:	00391513          	slli	a0,s2,0x3
ffffffffc02020d2:	9536                	add	a0,a0,a3
}
ffffffffc02020d4:	70e2                	ld	ra,56(sp)
ffffffffc02020d6:	7442                	ld	s0,48(sp)
ffffffffc02020d8:	74a2                	ld	s1,40(sp)
ffffffffc02020da:	7902                	ld	s2,32(sp)
ffffffffc02020dc:	69e2                	ld	s3,24(sp)
ffffffffc02020de:	6a42                	ld	s4,16(sp)
ffffffffc02020e0:	6aa2                	ld	s5,8(sp)
ffffffffc02020e2:	6b02                	ld	s6,0(sp)
ffffffffc02020e4:	6121                	addi	sp,sp,64
ffffffffc02020e6:	8082                	ret
            return NULL;
ffffffffc02020e8:	4501                	li	a0,0
ffffffffc02020ea:	b7ed                	j	ffffffffc02020d4 <get_pte+0x178>
        intr_disable();
ffffffffc02020ec:	8c9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020f0:	000a9797          	auipc	a5,0xa9
ffffffffc02020f4:	8287b783          	ld	a5,-2008(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc02020f8:	6f9c                	ld	a5,24(a5)
ffffffffc02020fa:	4505                	li	a0,1
ffffffffc02020fc:	9782                	jalr	a5
ffffffffc02020fe:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202100:	8affe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202104:	b56d                	j	ffffffffc0201fae <get_pte+0x52>
        intr_disable();
ffffffffc0202106:	8affe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020210a:	000a9797          	auipc	a5,0xa9
ffffffffc020210e:	80e7b783          	ld	a5,-2034(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0202112:	6f9c                	ld	a5,24(a5)
ffffffffc0202114:	4505                	li	a0,1
ffffffffc0202116:	9782                	jalr	a5
ffffffffc0202118:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020211a:	895fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020211e:	b781                	j	ffffffffc020205e <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202120:	00004617          	auipc	a2,0x4
ffffffffc0202124:	43860613          	addi	a2,a2,1080 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0202128:	0fa00593          	li	a1,250
ffffffffc020212c:	00004517          	auipc	a0,0x4
ffffffffc0202130:	54450513          	addi	a0,a0,1348 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202134:	b5afe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202138:	00004617          	auipc	a2,0x4
ffffffffc020213c:	42060613          	addi	a2,a2,1056 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0202140:	0ed00593          	li	a1,237
ffffffffc0202144:	00004517          	auipc	a0,0x4
ffffffffc0202148:	52c50513          	addi	a0,a0,1324 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020214c:	b42fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202150:	86aa                	mv	a3,a0
ffffffffc0202152:	00004617          	auipc	a2,0x4
ffffffffc0202156:	40660613          	addi	a2,a2,1030 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc020215a:	0e900593          	li	a1,233
ffffffffc020215e:	00004517          	auipc	a0,0x4
ffffffffc0202162:	51250513          	addi	a0,a0,1298 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202166:	b28fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020216a:	86aa                	mv	a3,a0
ffffffffc020216c:	00004617          	auipc	a2,0x4
ffffffffc0202170:	3ec60613          	addi	a2,a2,1004 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0202174:	0f700593          	li	a1,247
ffffffffc0202178:	00004517          	auipc	a0,0x4
ffffffffc020217c:	4f850513          	addi	a0,a0,1272 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202180:	b0efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202184 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202184:	1141                	addi	sp,sp,-16
ffffffffc0202186:	e022                	sd	s0,0(sp)
ffffffffc0202188:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020218a:	4601                	li	a2,0
{
ffffffffc020218c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020218e:	dcfff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
    if (ptep_store != NULL)
ffffffffc0202192:	c011                	beqz	s0,ffffffffc0202196 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202194:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202196:	c511                	beqz	a0,ffffffffc02021a2 <get_page+0x1e>
ffffffffc0202198:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020219a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020219c:	0017f713          	andi	a4,a5,1
ffffffffc02021a0:	e709                	bnez	a4,ffffffffc02021aa <get_page+0x26>
}
ffffffffc02021a2:	60a2                	ld	ra,8(sp)
ffffffffc02021a4:	6402                	ld	s0,0(sp)
ffffffffc02021a6:	0141                	addi	sp,sp,16
ffffffffc02021a8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02021aa:	078a                	slli	a5,a5,0x2
ffffffffc02021ac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021ae:	000a8717          	auipc	a4,0xa8
ffffffffc02021b2:	75a73703          	ld	a4,1882(a4) # ffffffffc02aa908 <npage>
ffffffffc02021b6:	00e7ff63          	bgeu	a5,a4,ffffffffc02021d4 <get_page+0x50>
ffffffffc02021ba:	60a2                	ld	ra,8(sp)
ffffffffc02021bc:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021be:	fff80537          	lui	a0,0xfff80
ffffffffc02021c2:	97aa                	add	a5,a5,a0
ffffffffc02021c4:	079a                	slli	a5,a5,0x6
ffffffffc02021c6:	000a8517          	auipc	a0,0xa8
ffffffffc02021ca:	74a53503          	ld	a0,1866(a0) # ffffffffc02aa910 <pages>
ffffffffc02021ce:	953e                	add	a0,a0,a5
ffffffffc02021d0:	0141                	addi	sp,sp,16
ffffffffc02021d2:	8082                	ret
ffffffffc02021d4:	c99ff0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>

ffffffffc02021d8 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02021d8:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021da:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021de:	f486                	sd	ra,104(sp)
ffffffffc02021e0:	f0a2                	sd	s0,96(sp)
ffffffffc02021e2:	eca6                	sd	s1,88(sp)
ffffffffc02021e4:	e8ca                	sd	s2,80(sp)
ffffffffc02021e6:	e4ce                	sd	s3,72(sp)
ffffffffc02021e8:	e0d2                	sd	s4,64(sp)
ffffffffc02021ea:	fc56                	sd	s5,56(sp)
ffffffffc02021ec:	f85a                	sd	s6,48(sp)
ffffffffc02021ee:	f45e                	sd	s7,40(sp)
ffffffffc02021f0:	f062                	sd	s8,32(sp)
ffffffffc02021f2:	ec66                	sd	s9,24(sp)
ffffffffc02021f4:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021f6:	17d2                	slli	a5,a5,0x34
ffffffffc02021f8:	e3ed                	bnez	a5,ffffffffc02022da <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02021fa:	002007b7          	lui	a5,0x200
ffffffffc02021fe:	842e                	mv	s0,a1
ffffffffc0202200:	0ef5ed63          	bltu	a1,a5,ffffffffc02022fa <unmap_range+0x122>
ffffffffc0202204:	8932                	mv	s2,a2
ffffffffc0202206:	0ec5fa63          	bgeu	a1,a2,ffffffffc02022fa <unmap_range+0x122>
ffffffffc020220a:	4785                	li	a5,1
ffffffffc020220c:	07fe                	slli	a5,a5,0x1f
ffffffffc020220e:	0ec7e663          	bltu	a5,a2,ffffffffc02022fa <unmap_range+0x122>
ffffffffc0202212:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202214:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202216:	000a8c97          	auipc	s9,0xa8
ffffffffc020221a:	6f2c8c93          	addi	s9,s9,1778 # ffffffffc02aa908 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020221e:	000a8c17          	auipc	s8,0xa8
ffffffffc0202222:	6f2c0c13          	addi	s8,s8,1778 # ffffffffc02aa910 <pages>
ffffffffc0202226:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020222a:	000a8d17          	auipc	s10,0xa8
ffffffffc020222e:	6eed0d13          	addi	s10,s10,1774 # ffffffffc02aa918 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202232:	00200b37          	lui	s6,0x200
ffffffffc0202236:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020223a:	4601                	li	a2,0
ffffffffc020223c:	85a2                	mv	a1,s0
ffffffffc020223e:	854e                	mv	a0,s3
ffffffffc0202240:	d1dff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc0202244:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0202246:	cd29                	beqz	a0,ffffffffc02022a0 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202248:	611c                	ld	a5,0(a0)
ffffffffc020224a:	e395                	bnez	a5,ffffffffc020226e <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020224c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020224e:	ff2466e3          	bltu	s0,s2,ffffffffc020223a <unmap_range+0x62>
}
ffffffffc0202252:	70a6                	ld	ra,104(sp)
ffffffffc0202254:	7406                	ld	s0,96(sp)
ffffffffc0202256:	64e6                	ld	s1,88(sp)
ffffffffc0202258:	6946                	ld	s2,80(sp)
ffffffffc020225a:	69a6                	ld	s3,72(sp)
ffffffffc020225c:	6a06                	ld	s4,64(sp)
ffffffffc020225e:	7ae2                	ld	s5,56(sp)
ffffffffc0202260:	7b42                	ld	s6,48(sp)
ffffffffc0202262:	7ba2                	ld	s7,40(sp)
ffffffffc0202264:	7c02                	ld	s8,32(sp)
ffffffffc0202266:	6ce2                	ld	s9,24(sp)
ffffffffc0202268:	6d42                	ld	s10,16(sp)
ffffffffc020226a:	6165                	addi	sp,sp,112
ffffffffc020226c:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc020226e:	0017f713          	andi	a4,a5,1
ffffffffc0202272:	df69                	beqz	a4,ffffffffc020224c <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202274:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202278:	078a                	slli	a5,a5,0x2
ffffffffc020227a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020227c:	08e7ff63          	bgeu	a5,a4,ffffffffc020231a <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202280:	000c3503          	ld	a0,0(s8)
ffffffffc0202284:	97de                	add	a5,a5,s7
ffffffffc0202286:	079a                	slli	a5,a5,0x6
ffffffffc0202288:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020228a:	411c                	lw	a5,0(a0)
ffffffffc020228c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202290:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202292:	cf11                	beqz	a4,ffffffffc02022ae <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202294:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202298:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020229c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020229e:	bf45                	j	ffffffffc020224e <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022a0:	945a                	add	s0,s0,s6
ffffffffc02022a2:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02022a6:	d455                	beqz	s0,ffffffffc0202252 <unmap_range+0x7a>
ffffffffc02022a8:	f92469e3          	bltu	s0,s2,ffffffffc020223a <unmap_range+0x62>
ffffffffc02022ac:	b75d                	j	ffffffffc0202252 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022ae:	100027f3          	csrr	a5,sstatus
ffffffffc02022b2:	8b89                	andi	a5,a5,2
ffffffffc02022b4:	e799                	bnez	a5,ffffffffc02022c2 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02022b6:	000d3783          	ld	a5,0(s10)
ffffffffc02022ba:	4585                	li	a1,1
ffffffffc02022bc:	739c                	ld	a5,32(a5)
ffffffffc02022be:	9782                	jalr	a5
    if (flag)
ffffffffc02022c0:	bfd1                	j	ffffffffc0202294 <unmap_range+0xbc>
ffffffffc02022c2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02022c4:	ef0fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022c8:	000d3783          	ld	a5,0(s10)
ffffffffc02022cc:	6522                	ld	a0,8(sp)
ffffffffc02022ce:	4585                	li	a1,1
ffffffffc02022d0:	739c                	ld	a5,32(a5)
ffffffffc02022d2:	9782                	jalr	a5
        intr_enable();
ffffffffc02022d4:	edafe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022d8:	bf75                	j	ffffffffc0202294 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022da:	00004697          	auipc	a3,0x4
ffffffffc02022de:	3a668693          	addi	a3,a3,934 # ffffffffc0206680 <default_pmm_manager+0x160>
ffffffffc02022e2:	00004617          	auipc	a2,0x4
ffffffffc02022e6:	e8e60613          	addi	a2,a2,-370 # ffffffffc0206170 <commands+0x828>
ffffffffc02022ea:	12000593          	li	a1,288
ffffffffc02022ee:	00004517          	auipc	a0,0x4
ffffffffc02022f2:	38250513          	addi	a0,a0,898 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02022f6:	998fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02022fa:	00004697          	auipc	a3,0x4
ffffffffc02022fe:	3b668693          	addi	a3,a3,950 # ffffffffc02066b0 <default_pmm_manager+0x190>
ffffffffc0202302:	00004617          	auipc	a2,0x4
ffffffffc0202306:	e6e60613          	addi	a2,a2,-402 # ffffffffc0206170 <commands+0x828>
ffffffffc020230a:	12100593          	li	a1,289
ffffffffc020230e:	00004517          	auipc	a0,0x4
ffffffffc0202312:	36250513          	addi	a0,a0,866 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202316:	978fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020231a:	b53ff0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>

ffffffffc020231e <exit_range>:
{
ffffffffc020231e:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202320:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202324:	fc86                	sd	ra,120(sp)
ffffffffc0202326:	f8a2                	sd	s0,112(sp)
ffffffffc0202328:	f4a6                	sd	s1,104(sp)
ffffffffc020232a:	f0ca                	sd	s2,96(sp)
ffffffffc020232c:	ecce                	sd	s3,88(sp)
ffffffffc020232e:	e8d2                	sd	s4,80(sp)
ffffffffc0202330:	e4d6                	sd	s5,72(sp)
ffffffffc0202332:	e0da                	sd	s6,64(sp)
ffffffffc0202334:	fc5e                	sd	s7,56(sp)
ffffffffc0202336:	f862                	sd	s8,48(sp)
ffffffffc0202338:	f466                	sd	s9,40(sp)
ffffffffc020233a:	f06a                	sd	s10,32(sp)
ffffffffc020233c:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020233e:	17d2                	slli	a5,a5,0x34
ffffffffc0202340:	20079a63          	bnez	a5,ffffffffc0202554 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202344:	002007b7          	lui	a5,0x200
ffffffffc0202348:	24f5e463          	bltu	a1,a5,ffffffffc0202590 <exit_range+0x272>
ffffffffc020234c:	8ab2                	mv	s5,a2
ffffffffc020234e:	24c5f163          	bgeu	a1,a2,ffffffffc0202590 <exit_range+0x272>
ffffffffc0202352:	4785                	li	a5,1
ffffffffc0202354:	07fe                	slli	a5,a5,0x1f
ffffffffc0202356:	22c7ed63          	bltu	a5,a2,ffffffffc0202590 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020235a:	c00009b7          	lui	s3,0xc0000
ffffffffc020235e:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202362:	ffe00937          	lui	s2,0xffe00
ffffffffc0202366:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020236a:	5cfd                	li	s9,-1
ffffffffc020236c:	8c2a                	mv	s8,a0
ffffffffc020236e:	0125f933          	and	s2,a1,s2
ffffffffc0202372:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202374:	000a8d17          	auipc	s10,0xa8
ffffffffc0202378:	594d0d13          	addi	s10,s10,1428 # ffffffffc02aa908 <npage>
    return KADDR(page2pa(page));
ffffffffc020237c:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202380:	000a8717          	auipc	a4,0xa8
ffffffffc0202384:	59070713          	addi	a4,a4,1424 # ffffffffc02aa910 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202388:	000a8d97          	auipc	s11,0xa8
ffffffffc020238c:	590d8d93          	addi	s11,s11,1424 # ffffffffc02aa918 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202390:	c0000437          	lui	s0,0xc0000
ffffffffc0202394:	944e                	add	s0,s0,s3
ffffffffc0202396:	8079                	srli	s0,s0,0x1e
ffffffffc0202398:	1ff47413          	andi	s0,s0,511
ffffffffc020239c:	040e                	slli	s0,s0,0x3
ffffffffc020239e:	9462                	add	s0,s0,s8
ffffffffc02023a0:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ec0>
        if (pde1 & PTE_V)
ffffffffc02023a4:	001a7793          	andi	a5,s4,1
ffffffffc02023a8:	eb99                	bnez	a5,ffffffffc02023be <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02023aa:	12098463          	beqz	s3,ffffffffc02024d2 <exit_range+0x1b4>
ffffffffc02023ae:	400007b7          	lui	a5,0x40000
ffffffffc02023b2:	97ce                	add	a5,a5,s3
ffffffffc02023b4:	894e                	mv	s2,s3
ffffffffc02023b6:	1159fe63          	bgeu	s3,s5,ffffffffc02024d2 <exit_range+0x1b4>
ffffffffc02023ba:	89be                	mv	s3,a5
ffffffffc02023bc:	bfd1                	j	ffffffffc0202390 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023be:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023c2:	0a0a                	slli	s4,s4,0x2
ffffffffc02023c4:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02023c8:	1cfa7263          	bgeu	s4,a5,ffffffffc020258c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023cc:	fff80637          	lui	a2,0xfff80
ffffffffc02023d0:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02023d2:	000806b7          	lui	a3,0x80
ffffffffc02023d6:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02023d8:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02023dc:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023de:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023e0:	18f5fa63          	bgeu	a1,a5,ffffffffc0202574 <exit_range+0x256>
ffffffffc02023e4:	000a8817          	auipc	a6,0xa8
ffffffffc02023e8:	53c80813          	addi	a6,a6,1340 # ffffffffc02aa920 <va_pa_offset>
ffffffffc02023ec:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02023f0:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02023f2:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02023f6:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02023f8:	00080337          	lui	t1,0x80
ffffffffc02023fc:	6885                	lui	a7,0x1
ffffffffc02023fe:	a819                	j	ffffffffc0202414 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202400:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202402:	002007b7          	lui	a5,0x200
ffffffffc0202406:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202408:	08090c63          	beqz	s2,ffffffffc02024a0 <exit_range+0x182>
ffffffffc020240c:	09397a63          	bgeu	s2,s3,ffffffffc02024a0 <exit_range+0x182>
ffffffffc0202410:	0f597063          	bgeu	s2,s5,ffffffffc02024f0 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202414:	01595493          	srli	s1,s2,0x15
ffffffffc0202418:	1ff4f493          	andi	s1,s1,511
ffffffffc020241c:	048e                	slli	s1,s1,0x3
ffffffffc020241e:	94da                	add	s1,s1,s6
ffffffffc0202420:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202422:	0017f693          	andi	a3,a5,1
ffffffffc0202426:	dee9                	beqz	a3,ffffffffc0202400 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202428:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020242c:	078a                	slli	a5,a5,0x2
ffffffffc020242e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202430:	14b7fe63          	bgeu	a5,a1,ffffffffc020258c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202434:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202436:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020243a:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020243e:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202442:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202444:	12bef863          	bgeu	t4,a1,ffffffffc0202574 <exit_range+0x256>
ffffffffc0202448:	00083783          	ld	a5,0(a6)
ffffffffc020244c:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020244e:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202452:	629c                	ld	a5,0(a3)
ffffffffc0202454:	8b85                	andi	a5,a5,1
ffffffffc0202456:	f7d5                	bnez	a5,ffffffffc0202402 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202458:	06a1                	addi	a3,a3,8
ffffffffc020245a:	fed59ce3          	bne	a1,a3,ffffffffc0202452 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc020245e:	631c                	ld	a5,0(a4)
ffffffffc0202460:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202462:	100027f3          	csrr	a5,sstatus
ffffffffc0202466:	8b89                	andi	a5,a5,2
ffffffffc0202468:	e7d9                	bnez	a5,ffffffffc02024f6 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020246a:	000db783          	ld	a5,0(s11)
ffffffffc020246e:	4585                	li	a1,1
ffffffffc0202470:	e032                	sd	a2,0(sp)
ffffffffc0202472:	739c                	ld	a5,32(a5)
ffffffffc0202474:	9782                	jalr	a5
    if (flag)
ffffffffc0202476:	6602                	ld	a2,0(sp)
ffffffffc0202478:	000a8817          	auipc	a6,0xa8
ffffffffc020247c:	4a880813          	addi	a6,a6,1192 # ffffffffc02aa920 <va_pa_offset>
ffffffffc0202480:	fff80e37          	lui	t3,0xfff80
ffffffffc0202484:	00080337          	lui	t1,0x80
ffffffffc0202488:	6885                	lui	a7,0x1
ffffffffc020248a:	000a8717          	auipc	a4,0xa8
ffffffffc020248e:	48670713          	addi	a4,a4,1158 # ffffffffc02aa910 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202492:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202496:	002007b7          	lui	a5,0x200
ffffffffc020249a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020249c:	f60918e3          	bnez	s2,ffffffffc020240c <exit_range+0xee>
            if (free_pd0)
ffffffffc02024a0:	f00b85e3          	beqz	s7,ffffffffc02023aa <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02024a4:	000d3783          	ld	a5,0(s10)
ffffffffc02024a8:	0efa7263          	bgeu	s4,a5,ffffffffc020258c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ac:	6308                	ld	a0,0(a4)
ffffffffc02024ae:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024b0:	100027f3          	csrr	a5,sstatus
ffffffffc02024b4:	8b89                	andi	a5,a5,2
ffffffffc02024b6:	efad                	bnez	a5,ffffffffc0202530 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02024b8:	000db783          	ld	a5,0(s11)
ffffffffc02024bc:	4585                	li	a1,1
ffffffffc02024be:	739c                	ld	a5,32(a5)
ffffffffc02024c0:	9782                	jalr	a5
ffffffffc02024c2:	000a8717          	auipc	a4,0xa8
ffffffffc02024c6:	44e70713          	addi	a4,a4,1102 # ffffffffc02aa910 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024ca:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02024ce:	ee0990e3          	bnez	s3,ffffffffc02023ae <exit_range+0x90>
}
ffffffffc02024d2:	70e6                	ld	ra,120(sp)
ffffffffc02024d4:	7446                	ld	s0,112(sp)
ffffffffc02024d6:	74a6                	ld	s1,104(sp)
ffffffffc02024d8:	7906                	ld	s2,96(sp)
ffffffffc02024da:	69e6                	ld	s3,88(sp)
ffffffffc02024dc:	6a46                	ld	s4,80(sp)
ffffffffc02024de:	6aa6                	ld	s5,72(sp)
ffffffffc02024e0:	6b06                	ld	s6,64(sp)
ffffffffc02024e2:	7be2                	ld	s7,56(sp)
ffffffffc02024e4:	7c42                	ld	s8,48(sp)
ffffffffc02024e6:	7ca2                	ld	s9,40(sp)
ffffffffc02024e8:	7d02                	ld	s10,32(sp)
ffffffffc02024ea:	6de2                	ld	s11,24(sp)
ffffffffc02024ec:	6109                	addi	sp,sp,128
ffffffffc02024ee:	8082                	ret
            if (free_pd0)
ffffffffc02024f0:	ea0b8fe3          	beqz	s7,ffffffffc02023ae <exit_range+0x90>
ffffffffc02024f4:	bf45                	j	ffffffffc02024a4 <exit_range+0x186>
ffffffffc02024f6:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02024f8:	e42a                	sd	a0,8(sp)
ffffffffc02024fa:	cbafe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02024fe:	000db783          	ld	a5,0(s11)
ffffffffc0202502:	6522                	ld	a0,8(sp)
ffffffffc0202504:	4585                	li	a1,1
ffffffffc0202506:	739c                	ld	a5,32(a5)
ffffffffc0202508:	9782                	jalr	a5
        intr_enable();
ffffffffc020250a:	ca4fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020250e:	6602                	ld	a2,0(sp)
ffffffffc0202510:	000a8717          	auipc	a4,0xa8
ffffffffc0202514:	40070713          	addi	a4,a4,1024 # ffffffffc02aa910 <pages>
ffffffffc0202518:	6885                	lui	a7,0x1
ffffffffc020251a:	00080337          	lui	t1,0x80
ffffffffc020251e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202522:	000a8817          	auipc	a6,0xa8
ffffffffc0202526:	3fe80813          	addi	a6,a6,1022 # ffffffffc02aa920 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020252a:	0004b023          	sd	zero,0(s1)
ffffffffc020252e:	b7a5                	j	ffffffffc0202496 <exit_range+0x178>
ffffffffc0202530:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202532:	c82fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202536:	000db783          	ld	a5,0(s11)
ffffffffc020253a:	6502                	ld	a0,0(sp)
ffffffffc020253c:	4585                	li	a1,1
ffffffffc020253e:	739c                	ld	a5,32(a5)
ffffffffc0202540:	9782                	jalr	a5
        intr_enable();
ffffffffc0202542:	c6cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202546:	000a8717          	auipc	a4,0xa8
ffffffffc020254a:	3ca70713          	addi	a4,a4,970 # ffffffffc02aa910 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020254e:	00043023          	sd	zero,0(s0)
ffffffffc0202552:	bfb5                	j	ffffffffc02024ce <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202554:	00004697          	auipc	a3,0x4
ffffffffc0202558:	12c68693          	addi	a3,a3,300 # ffffffffc0206680 <default_pmm_manager+0x160>
ffffffffc020255c:	00004617          	auipc	a2,0x4
ffffffffc0202560:	c1460613          	addi	a2,a2,-1004 # ffffffffc0206170 <commands+0x828>
ffffffffc0202564:	13500593          	li	a1,309
ffffffffc0202568:	00004517          	auipc	a0,0x4
ffffffffc020256c:	10850513          	addi	a0,a0,264 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202570:	f1ffd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202574:	00004617          	auipc	a2,0x4
ffffffffc0202578:	fe460613          	addi	a2,a2,-28 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc020257c:	07100593          	li	a1,113
ffffffffc0202580:	00004517          	auipc	a0,0x4
ffffffffc0202584:	00050513          	mv	a0,a0
ffffffffc0202588:	f07fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020258c:	8e1ff0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202590:	00004697          	auipc	a3,0x4
ffffffffc0202594:	12068693          	addi	a3,a3,288 # ffffffffc02066b0 <default_pmm_manager+0x190>
ffffffffc0202598:	00004617          	auipc	a2,0x4
ffffffffc020259c:	bd860613          	addi	a2,a2,-1064 # ffffffffc0206170 <commands+0x828>
ffffffffc02025a0:	13600593          	li	a1,310
ffffffffc02025a4:	00004517          	auipc	a0,0x4
ffffffffc02025a8:	0cc50513          	addi	a0,a0,204 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02025ac:	ee3fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02025b0 <page_remove>:
{
ffffffffc02025b0:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025b2:	4601                	li	a2,0
{
ffffffffc02025b4:	ec26                	sd	s1,24(sp)
ffffffffc02025b6:	f406                	sd	ra,40(sp)
ffffffffc02025b8:	f022                	sd	s0,32(sp)
ffffffffc02025ba:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025bc:	9a1ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
    if (ptep != NULL)
ffffffffc02025c0:	c511                	beqz	a0,ffffffffc02025cc <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02025c2:	611c                	ld	a5,0(a0)
ffffffffc02025c4:	842a                	mv	s0,a0
ffffffffc02025c6:	0017f713          	andi	a4,a5,1
ffffffffc02025ca:	e711                	bnez	a4,ffffffffc02025d6 <page_remove+0x26>
}
ffffffffc02025cc:	70a2                	ld	ra,40(sp)
ffffffffc02025ce:	7402                	ld	s0,32(sp)
ffffffffc02025d0:	64e2                	ld	s1,24(sp)
ffffffffc02025d2:	6145                	addi	sp,sp,48
ffffffffc02025d4:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025d6:	078a                	slli	a5,a5,0x2
ffffffffc02025d8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025da:	000a8717          	auipc	a4,0xa8
ffffffffc02025de:	32e73703          	ld	a4,814(a4) # ffffffffc02aa908 <npage>
ffffffffc02025e2:	06e7f363          	bgeu	a5,a4,ffffffffc0202648 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02025e6:	fff80537          	lui	a0,0xfff80
ffffffffc02025ea:	97aa                	add	a5,a5,a0
ffffffffc02025ec:	079a                	slli	a5,a5,0x6
ffffffffc02025ee:	000a8517          	auipc	a0,0xa8
ffffffffc02025f2:	32253503          	ld	a0,802(a0) # ffffffffc02aa910 <pages>
ffffffffc02025f6:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02025f8:	411c                	lw	a5,0(a0)
ffffffffc02025fa:	fff7871b          	addiw	a4,a5,-1
ffffffffc02025fe:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202600:	cb11                	beqz	a4,ffffffffc0202614 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202602:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202606:	12048073          	sfence.vma	s1
}
ffffffffc020260a:	70a2                	ld	ra,40(sp)
ffffffffc020260c:	7402                	ld	s0,32(sp)
ffffffffc020260e:	64e2                	ld	s1,24(sp)
ffffffffc0202610:	6145                	addi	sp,sp,48
ffffffffc0202612:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202614:	100027f3          	csrr	a5,sstatus
ffffffffc0202618:	8b89                	andi	a5,a5,2
ffffffffc020261a:	eb89                	bnez	a5,ffffffffc020262c <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020261c:	000a8797          	auipc	a5,0xa8
ffffffffc0202620:	2fc7b783          	ld	a5,764(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0202624:	739c                	ld	a5,32(a5)
ffffffffc0202626:	4585                	li	a1,1
ffffffffc0202628:	9782                	jalr	a5
    if (flag)
ffffffffc020262a:	bfe1                	j	ffffffffc0202602 <page_remove+0x52>
        intr_disable();
ffffffffc020262c:	e42a                	sd	a0,8(sp)
ffffffffc020262e:	b86fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202632:	000a8797          	auipc	a5,0xa8
ffffffffc0202636:	2e67b783          	ld	a5,742(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc020263a:	739c                	ld	a5,32(a5)
ffffffffc020263c:	6522                	ld	a0,8(sp)
ffffffffc020263e:	4585                	li	a1,1
ffffffffc0202640:	9782                	jalr	a5
        intr_enable();
ffffffffc0202642:	b6cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202646:	bf75                	j	ffffffffc0202602 <page_remove+0x52>
ffffffffc0202648:	825ff0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>

ffffffffc020264c <page_insert>:
{
ffffffffc020264c:	7139                	addi	sp,sp,-64
ffffffffc020264e:	e852                	sd	s4,16(sp)
ffffffffc0202650:	8a32                	mv	s4,a2
ffffffffc0202652:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202654:	4605                	li	a2,1
{
ffffffffc0202656:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202658:	85d2                	mv	a1,s4
{
ffffffffc020265a:	f426                	sd	s1,40(sp)
ffffffffc020265c:	fc06                	sd	ra,56(sp)
ffffffffc020265e:	f04a                	sd	s2,32(sp)
ffffffffc0202660:	ec4e                	sd	s3,24(sp)
ffffffffc0202662:	e456                	sd	s5,8(sp)
ffffffffc0202664:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202666:	8f7ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
    if (ptep == NULL)
ffffffffc020266a:	c961                	beqz	a0,ffffffffc020273a <page_insert+0xee>
    page->ref += 1;
ffffffffc020266c:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc020266e:	611c                	ld	a5,0(a0)
ffffffffc0202670:	89aa                	mv	s3,a0
ffffffffc0202672:	0016871b          	addiw	a4,a3,1
ffffffffc0202676:	c018                	sw	a4,0(s0)
ffffffffc0202678:	0017f713          	andi	a4,a5,1
ffffffffc020267c:	ef05                	bnez	a4,ffffffffc02026b4 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020267e:	000a8717          	auipc	a4,0xa8
ffffffffc0202682:	29273703          	ld	a4,658(a4) # ffffffffc02aa910 <pages>
ffffffffc0202686:	8c19                	sub	s0,s0,a4
ffffffffc0202688:	000807b7          	lui	a5,0x80
ffffffffc020268c:	8419                	srai	s0,s0,0x6
ffffffffc020268e:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202690:	042a                	slli	s0,s0,0xa
ffffffffc0202692:	8cc1                	or	s1,s1,s0
ffffffffc0202694:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202698:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ec0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020269c:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02026a0:	4501                	li	a0,0
}
ffffffffc02026a2:	70e2                	ld	ra,56(sp)
ffffffffc02026a4:	7442                	ld	s0,48(sp)
ffffffffc02026a6:	74a2                	ld	s1,40(sp)
ffffffffc02026a8:	7902                	ld	s2,32(sp)
ffffffffc02026aa:	69e2                	ld	s3,24(sp)
ffffffffc02026ac:	6a42                	ld	s4,16(sp)
ffffffffc02026ae:	6aa2                	ld	s5,8(sp)
ffffffffc02026b0:	6121                	addi	sp,sp,64
ffffffffc02026b2:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02026b4:	078a                	slli	a5,a5,0x2
ffffffffc02026b6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026b8:	000a8717          	auipc	a4,0xa8
ffffffffc02026bc:	25073703          	ld	a4,592(a4) # ffffffffc02aa908 <npage>
ffffffffc02026c0:	06e7ff63          	bgeu	a5,a4,ffffffffc020273e <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02026c4:	000a8a97          	auipc	s5,0xa8
ffffffffc02026c8:	24ca8a93          	addi	s5,s5,588 # ffffffffc02aa910 <pages>
ffffffffc02026cc:	000ab703          	ld	a4,0(s5)
ffffffffc02026d0:	fff80937          	lui	s2,0xfff80
ffffffffc02026d4:	993e                	add	s2,s2,a5
ffffffffc02026d6:	091a                	slli	s2,s2,0x6
ffffffffc02026d8:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02026da:	01240c63          	beq	s0,s2,ffffffffc02026f2 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02026de:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd56bc>
ffffffffc02026e2:	fff7869b          	addiw	a3,a5,-1
ffffffffc02026e6:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02026ea:	c691                	beqz	a3,ffffffffc02026f6 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026ec:	120a0073          	sfence.vma	s4
}
ffffffffc02026f0:	bf59                	j	ffffffffc0202686 <page_insert+0x3a>
ffffffffc02026f2:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02026f4:	bf49                	j	ffffffffc0202686 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026f6:	100027f3          	csrr	a5,sstatus
ffffffffc02026fa:	8b89                	andi	a5,a5,2
ffffffffc02026fc:	ef91                	bnez	a5,ffffffffc0202718 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02026fe:	000a8797          	auipc	a5,0xa8
ffffffffc0202702:	21a7b783          	ld	a5,538(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0202706:	739c                	ld	a5,32(a5)
ffffffffc0202708:	4585                	li	a1,1
ffffffffc020270a:	854a                	mv	a0,s2
ffffffffc020270c:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020270e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202712:	120a0073          	sfence.vma	s4
ffffffffc0202716:	bf85                	j	ffffffffc0202686 <page_insert+0x3a>
        intr_disable();
ffffffffc0202718:	a9cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020271c:	000a8797          	auipc	a5,0xa8
ffffffffc0202720:	1fc7b783          	ld	a5,508(a5) # ffffffffc02aa918 <pmm_manager>
ffffffffc0202724:	739c                	ld	a5,32(a5)
ffffffffc0202726:	4585                	li	a1,1
ffffffffc0202728:	854a                	mv	a0,s2
ffffffffc020272a:	9782                	jalr	a5
        intr_enable();
ffffffffc020272c:	a82fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202730:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202734:	120a0073          	sfence.vma	s4
ffffffffc0202738:	b7b9                	j	ffffffffc0202686 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020273a:	5571                	li	a0,-4
ffffffffc020273c:	b79d                	j	ffffffffc02026a2 <page_insert+0x56>
ffffffffc020273e:	f2eff0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>

ffffffffc0202742 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202742:	00004797          	auipc	a5,0x4
ffffffffc0202746:	dde78793          	addi	a5,a5,-546 # ffffffffc0206520 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020274a:	638c                	ld	a1,0(a5)
{
ffffffffc020274c:	7159                	addi	sp,sp,-112
ffffffffc020274e:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202750:	00004517          	auipc	a0,0x4
ffffffffc0202754:	f7850513          	addi	a0,a0,-136 # ffffffffc02066c8 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202758:	000a8b17          	auipc	s6,0xa8
ffffffffc020275c:	1c0b0b13          	addi	s6,s6,448 # ffffffffc02aa918 <pmm_manager>
{
ffffffffc0202760:	f486                	sd	ra,104(sp)
ffffffffc0202762:	e8ca                	sd	s2,80(sp)
ffffffffc0202764:	e4ce                	sd	s3,72(sp)
ffffffffc0202766:	f0a2                	sd	s0,96(sp)
ffffffffc0202768:	eca6                	sd	s1,88(sp)
ffffffffc020276a:	e0d2                	sd	s4,64(sp)
ffffffffc020276c:	fc56                	sd	s5,56(sp)
ffffffffc020276e:	f45e                	sd	s7,40(sp)
ffffffffc0202770:	f062                	sd	s8,32(sp)
ffffffffc0202772:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202774:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202778:	a1dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc020277c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202780:	000a8997          	auipc	s3,0xa8
ffffffffc0202784:	1a098993          	addi	s3,s3,416 # ffffffffc02aa920 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202788:	679c                	ld	a5,8(a5)
ffffffffc020278a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020278c:	57f5                	li	a5,-3
ffffffffc020278e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202790:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202794:	a06fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202798:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020279a:	a0afe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc020279e:	200505e3          	beqz	a0,ffffffffc02031a8 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027a2:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02027a4:	00004517          	auipc	a0,0x4
ffffffffc02027a8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206700 <default_pmm_manager+0x1e0>
ffffffffc02027ac:	9e9fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027b0:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02027b4:	fff40693          	addi	a3,s0,-1
ffffffffc02027b8:	864a                	mv	a2,s2
ffffffffc02027ba:	85a6                	mv	a1,s1
ffffffffc02027bc:	00004517          	auipc	a0,0x4
ffffffffc02027c0:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206718 <default_pmm_manager+0x1f8>
ffffffffc02027c4:	9d1fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02027c8:	c8000737          	lui	a4,0xc8000
ffffffffc02027cc:	87a2                	mv	a5,s0
ffffffffc02027ce:	54876163          	bltu	a4,s0,ffffffffc0202d10 <pmm_init+0x5ce>
ffffffffc02027d2:	757d                	lui	a0,0xfffff
ffffffffc02027d4:	000a9617          	auipc	a2,0xa9
ffffffffc02027d8:	16f60613          	addi	a2,a2,367 # ffffffffc02ab943 <end+0xfff>
ffffffffc02027dc:	8e69                	and	a2,a2,a0
ffffffffc02027de:	000a8497          	auipc	s1,0xa8
ffffffffc02027e2:	12a48493          	addi	s1,s1,298 # ffffffffc02aa908 <npage>
ffffffffc02027e6:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027ea:	000a8b97          	auipc	s7,0xa8
ffffffffc02027ee:	126b8b93          	addi	s7,s7,294 # ffffffffc02aa910 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02027f2:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027f4:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027f8:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027fc:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027fe:	02f50863          	beq	a0,a5,ffffffffc020282e <pmm_init+0xec>
ffffffffc0202802:	4781                	li	a5,0
ffffffffc0202804:	4585                	li	a1,1
ffffffffc0202806:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020280a:	00679513          	slli	a0,a5,0x6
ffffffffc020280e:	9532                	add	a0,a0,a2
ffffffffc0202810:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd546c4>
ffffffffc0202814:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202818:	6088                	ld	a0,0(s1)
ffffffffc020281a:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc020281c:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202820:	00d50733          	add	a4,a0,a3
ffffffffc0202824:	fee7e3e3          	bltu	a5,a4,ffffffffc020280a <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202828:	071a                	slli	a4,a4,0x6
ffffffffc020282a:	00e606b3          	add	a3,a2,a4
ffffffffc020282e:	c02007b7          	lui	a5,0xc0200
ffffffffc0202832:	2ef6ece3          	bltu	a3,a5,ffffffffc020332a <pmm_init+0xbe8>
ffffffffc0202836:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020283a:	77fd                	lui	a5,0xfffff
ffffffffc020283c:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020283e:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202840:	5086eb63          	bltu	a3,s0,ffffffffc0202d56 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202844:	00004517          	auipc	a0,0x4
ffffffffc0202848:	efc50513          	addi	a0,a0,-260 # ffffffffc0206740 <default_pmm_manager+0x220>
ffffffffc020284c:	949fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202850:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202854:	000a8917          	auipc	s2,0xa8
ffffffffc0202858:	0ac90913          	addi	s2,s2,172 # ffffffffc02aa900 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc020285c:	7b9c                	ld	a5,48(a5)
ffffffffc020285e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202860:	00004517          	auipc	a0,0x4
ffffffffc0202864:	ef850513          	addi	a0,a0,-264 # ffffffffc0206758 <default_pmm_manager+0x238>
ffffffffc0202868:	92dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020286c:	00007697          	auipc	a3,0x7
ffffffffc0202870:	79468693          	addi	a3,a3,1940 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202874:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202878:	c02007b7          	lui	a5,0xc0200
ffffffffc020287c:	28f6ebe3          	bltu	a3,a5,ffffffffc0203312 <pmm_init+0xbd0>
ffffffffc0202880:	0009b783          	ld	a5,0(s3)
ffffffffc0202884:	8e9d                	sub	a3,a3,a5
ffffffffc0202886:	000a8797          	auipc	a5,0xa8
ffffffffc020288a:	06d7b923          	sd	a3,114(a5) # ffffffffc02aa8f8 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020288e:	100027f3          	csrr	a5,sstatus
ffffffffc0202892:	8b89                	andi	a5,a5,2
ffffffffc0202894:	4a079763          	bnez	a5,ffffffffc0202d42 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202898:	000b3783          	ld	a5,0(s6)
ffffffffc020289c:	779c                	ld	a5,40(a5)
ffffffffc020289e:	9782                	jalr	a5
ffffffffc02028a0:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02028a2:	6098                	ld	a4,0(s1)
ffffffffc02028a4:	c80007b7          	lui	a5,0xc8000
ffffffffc02028a8:	83b1                	srli	a5,a5,0xc
ffffffffc02028aa:	66e7e363          	bltu	a5,a4,ffffffffc0202f10 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028ae:	00093503          	ld	a0,0(s2)
ffffffffc02028b2:	62050f63          	beqz	a0,ffffffffc0202ef0 <pmm_init+0x7ae>
ffffffffc02028b6:	03451793          	slli	a5,a0,0x34
ffffffffc02028ba:	62079b63          	bnez	a5,ffffffffc0202ef0 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028be:	4601                	li	a2,0
ffffffffc02028c0:	4581                	li	a1,0
ffffffffc02028c2:	8c3ff0ef          	jal	ra,ffffffffc0202184 <get_page>
ffffffffc02028c6:	60051563          	bnez	a0,ffffffffc0202ed0 <pmm_init+0x78e>
ffffffffc02028ca:	100027f3          	csrr	a5,sstatus
ffffffffc02028ce:	8b89                	andi	a5,a5,2
ffffffffc02028d0:	44079e63          	bnez	a5,ffffffffc0202d2c <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028d4:	000b3783          	ld	a5,0(s6)
ffffffffc02028d8:	4505                	li	a0,1
ffffffffc02028da:	6f9c                	ld	a5,24(a5)
ffffffffc02028dc:	9782                	jalr	a5
ffffffffc02028de:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02028e0:	00093503          	ld	a0,0(s2)
ffffffffc02028e4:	4681                	li	a3,0
ffffffffc02028e6:	4601                	li	a2,0
ffffffffc02028e8:	85d2                	mv	a1,s4
ffffffffc02028ea:	d63ff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc02028ee:	26051ae3          	bnez	a0,ffffffffc0203362 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02028f2:	00093503          	ld	a0,0(s2)
ffffffffc02028f6:	4601                	li	a2,0
ffffffffc02028f8:	4581                	li	a1,0
ffffffffc02028fa:	e62ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc02028fe:	240502e3          	beqz	a0,ffffffffc0203342 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202902:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202904:	0017f713          	andi	a4,a5,1
ffffffffc0202908:	5a070263          	beqz	a4,ffffffffc0202eac <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020290c:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020290e:	078a                	slli	a5,a5,0x2
ffffffffc0202910:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202912:	58e7fb63          	bgeu	a5,a4,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202916:	000bb683          	ld	a3,0(s7)
ffffffffc020291a:	fff80637          	lui	a2,0xfff80
ffffffffc020291e:	97b2                	add	a5,a5,a2
ffffffffc0202920:	079a                	slli	a5,a5,0x6
ffffffffc0202922:	97b6                	add	a5,a5,a3
ffffffffc0202924:	14fa17e3          	bne	s4,a5,ffffffffc0203272 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202928:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc8>
ffffffffc020292c:	4785                	li	a5,1
ffffffffc020292e:	12f692e3          	bne	a3,a5,ffffffffc0203252 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202932:	00093503          	ld	a0,0(s2)
ffffffffc0202936:	77fd                	lui	a5,0xfffff
ffffffffc0202938:	6114                	ld	a3,0(a0)
ffffffffc020293a:	068a                	slli	a3,a3,0x2
ffffffffc020293c:	8efd                	and	a3,a3,a5
ffffffffc020293e:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202942:	0ee67ce3          	bgeu	a2,a4,ffffffffc020323a <pmm_init+0xaf8>
ffffffffc0202946:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020294a:	96e2                	add	a3,a3,s8
ffffffffc020294c:	0006ba83          	ld	s5,0(a3)
ffffffffc0202950:	0a8a                	slli	s5,s5,0x2
ffffffffc0202952:	00fafab3          	and	s5,s5,a5
ffffffffc0202956:	00cad793          	srli	a5,s5,0xc
ffffffffc020295a:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203220 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020295e:	4601                	li	a2,0
ffffffffc0202960:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202962:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202964:	df8ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202968:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020296a:	55551363          	bne	a0,s5,ffffffffc0202eb0 <pmm_init+0x76e>
ffffffffc020296e:	100027f3          	csrr	a5,sstatus
ffffffffc0202972:	8b89                	andi	a5,a5,2
ffffffffc0202974:	3a079163          	bnez	a5,ffffffffc0202d16 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202978:	000b3783          	ld	a5,0(s6)
ffffffffc020297c:	4505                	li	a0,1
ffffffffc020297e:	6f9c                	ld	a5,24(a5)
ffffffffc0202980:	9782                	jalr	a5
ffffffffc0202982:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202984:	00093503          	ld	a0,0(s2)
ffffffffc0202988:	46d1                	li	a3,20
ffffffffc020298a:	6605                	lui	a2,0x1
ffffffffc020298c:	85e2                	mv	a1,s8
ffffffffc020298e:	cbfff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc0202992:	060517e3          	bnez	a0,ffffffffc0203200 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202996:	00093503          	ld	a0,0(s2)
ffffffffc020299a:	4601                	li	a2,0
ffffffffc020299c:	6585                	lui	a1,0x1
ffffffffc020299e:	dbeff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc02029a2:	02050fe3          	beqz	a0,ffffffffc02031e0 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02029a6:	611c                	ld	a5,0(a0)
ffffffffc02029a8:	0107f713          	andi	a4,a5,16
ffffffffc02029ac:	7c070e63          	beqz	a4,ffffffffc0203188 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02029b0:	8b91                	andi	a5,a5,4
ffffffffc02029b2:	7a078b63          	beqz	a5,ffffffffc0203168 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02029b6:	00093503          	ld	a0,0(s2)
ffffffffc02029ba:	611c                	ld	a5,0(a0)
ffffffffc02029bc:	8bc1                	andi	a5,a5,16
ffffffffc02029be:	78078563          	beqz	a5,ffffffffc0203148 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02029c2:	000c2703          	lw	a4,0(s8)
ffffffffc02029c6:	4785                	li	a5,1
ffffffffc02029c8:	76f71063          	bne	a4,a5,ffffffffc0203128 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02029cc:	4681                	li	a3,0
ffffffffc02029ce:	6605                	lui	a2,0x1
ffffffffc02029d0:	85d2                	mv	a1,s4
ffffffffc02029d2:	c7bff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc02029d6:	72051963          	bnez	a0,ffffffffc0203108 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02029da:	000a2703          	lw	a4,0(s4)
ffffffffc02029de:	4789                	li	a5,2
ffffffffc02029e0:	70f71463          	bne	a4,a5,ffffffffc02030e8 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02029e4:	000c2783          	lw	a5,0(s8)
ffffffffc02029e8:	6e079063          	bnez	a5,ffffffffc02030c8 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029ec:	00093503          	ld	a0,0(s2)
ffffffffc02029f0:	4601                	li	a2,0
ffffffffc02029f2:	6585                	lui	a1,0x1
ffffffffc02029f4:	d68ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc02029f8:	6a050863          	beqz	a0,ffffffffc02030a8 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc02029fc:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02029fe:	00177793          	andi	a5,a4,1
ffffffffc0202a02:	4a078563          	beqz	a5,ffffffffc0202eac <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202a06:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a08:	00271793          	slli	a5,a4,0x2
ffffffffc0202a0c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a0e:	48d7fd63          	bgeu	a5,a3,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a12:	000bb683          	ld	a3,0(s7)
ffffffffc0202a16:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a1a:	97d6                	add	a5,a5,s5
ffffffffc0202a1c:	079a                	slli	a5,a5,0x6
ffffffffc0202a1e:	97b6                	add	a5,a5,a3
ffffffffc0202a20:	66fa1463          	bne	s4,a5,ffffffffc0203088 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a24:	8b41                	andi	a4,a4,16
ffffffffc0202a26:	64071163          	bnez	a4,ffffffffc0203068 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a2a:	00093503          	ld	a0,0(s2)
ffffffffc0202a2e:	4581                	li	a1,0
ffffffffc0202a30:	b81ff0ef          	jal	ra,ffffffffc02025b0 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a34:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a38:	4785                	li	a5,1
ffffffffc0202a3a:	60fc9763          	bne	s9,a5,ffffffffc0203048 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a3e:	000c2783          	lw	a5,0(s8)
ffffffffc0202a42:	5e079363          	bnez	a5,ffffffffc0203028 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a46:	00093503          	ld	a0,0(s2)
ffffffffc0202a4a:	6585                	lui	a1,0x1
ffffffffc0202a4c:	b65ff0ef          	jal	ra,ffffffffc02025b0 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a50:	000a2783          	lw	a5,0(s4)
ffffffffc0202a54:	52079a63          	bnez	a5,ffffffffc0202f88 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a58:	000c2783          	lw	a5,0(s8)
ffffffffc0202a5c:	50079663          	bnez	a5,ffffffffc0202f68 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a60:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202a64:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a66:	000a3683          	ld	a3,0(s4)
ffffffffc0202a6a:	068a                	slli	a3,a3,0x2
ffffffffc0202a6c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a6e:	42b6fd63          	bgeu	a3,a1,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a72:	000bb503          	ld	a0,0(s7)
ffffffffc0202a76:	96d6                	add	a3,a3,s5
ffffffffc0202a78:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202a7a:	00d507b3          	add	a5,a0,a3
ffffffffc0202a7e:	439c                	lw	a5,0(a5)
ffffffffc0202a80:	4d979463          	bne	a5,s9,ffffffffc0202f48 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202a84:	8699                	srai	a3,a3,0x6
ffffffffc0202a86:	00080637          	lui	a2,0x80
ffffffffc0202a8a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202a8c:	00c69713          	slli	a4,a3,0xc
ffffffffc0202a90:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a92:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a94:	48b77e63          	bgeu	a4,a1,ffffffffc0202f30 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202a98:	0009b703          	ld	a4,0(s3)
ffffffffc0202a9c:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a9e:	629c                	ld	a5,0(a3)
ffffffffc0202aa0:	078a                	slli	a5,a5,0x2
ffffffffc0202aa2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aa4:	40b7f263          	bgeu	a5,a1,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aa8:	8f91                	sub	a5,a5,a2
ffffffffc0202aaa:	079a                	slli	a5,a5,0x6
ffffffffc0202aac:	953e                	add	a0,a0,a5
ffffffffc0202aae:	100027f3          	csrr	a5,sstatus
ffffffffc0202ab2:	8b89                	andi	a5,a5,2
ffffffffc0202ab4:	30079963          	bnez	a5,ffffffffc0202dc6 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202ab8:	000b3783          	ld	a5,0(s6)
ffffffffc0202abc:	4585                	li	a1,1
ffffffffc0202abe:	739c                	ld	a5,32(a5)
ffffffffc0202ac0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac2:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202ac6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac8:	078a                	slli	a5,a5,0x2
ffffffffc0202aca:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202acc:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ad0:	000bb503          	ld	a0,0(s7)
ffffffffc0202ad4:	fff80737          	lui	a4,0xfff80
ffffffffc0202ad8:	97ba                	add	a5,a5,a4
ffffffffc0202ada:	079a                	slli	a5,a5,0x6
ffffffffc0202adc:	953e                	add	a0,a0,a5
ffffffffc0202ade:	100027f3          	csrr	a5,sstatus
ffffffffc0202ae2:	8b89                	andi	a5,a5,2
ffffffffc0202ae4:	2c079563          	bnez	a5,ffffffffc0202dae <pmm_init+0x66c>
ffffffffc0202ae8:	000b3783          	ld	a5,0(s6)
ffffffffc0202aec:	4585                	li	a1,1
ffffffffc0202aee:	739c                	ld	a5,32(a5)
ffffffffc0202af0:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202af2:	00093783          	ld	a5,0(s2)
ffffffffc0202af6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd546bc>
    asm volatile("sfence.vma");
ffffffffc0202afa:	12000073          	sfence.vma
ffffffffc0202afe:	100027f3          	csrr	a5,sstatus
ffffffffc0202b02:	8b89                	andi	a5,a5,2
ffffffffc0202b04:	28079b63          	bnez	a5,ffffffffc0202d9a <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b08:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0c:	779c                	ld	a5,40(a5)
ffffffffc0202b0e:	9782                	jalr	a5
ffffffffc0202b10:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b12:	4b441b63          	bne	s0,s4,ffffffffc0202fc8 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b16:	00004517          	auipc	a0,0x4
ffffffffc0202b1a:	f6a50513          	addi	a0,a0,-150 # ffffffffc0206a80 <default_pmm_manager+0x560>
ffffffffc0202b1e:	e76fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b22:	100027f3          	csrr	a5,sstatus
ffffffffc0202b26:	8b89                	andi	a5,a5,2
ffffffffc0202b28:	24079f63          	bnez	a5,ffffffffc0202d86 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202b30:	779c                	ld	a5,40(a5)
ffffffffc0202b32:	9782                	jalr	a5
ffffffffc0202b34:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b36:	6098                	ld	a4,0(s1)
ffffffffc0202b38:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b3c:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b3e:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b42:	6a05                	lui	s4,0x1
ffffffffc0202b44:	02f47c63          	bgeu	s0,a5,ffffffffc0202b7c <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b48:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b4c:	00093503          	ld	a0,0(s2)
ffffffffc0202b50:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e4e <pmm_init+0x70c>
ffffffffc0202b54:	0009b583          	ld	a1,0(s3)
ffffffffc0202b58:	4601                	li	a2,0
ffffffffc0202b5a:	95a2                	add	a1,a1,s0
ffffffffc0202b5c:	c00ff0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc0202b60:	32050463          	beqz	a0,ffffffffc0202e88 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b64:	611c                	ld	a5,0(a0)
ffffffffc0202b66:	078a                	slli	a5,a5,0x2
ffffffffc0202b68:	0157f7b3          	and	a5,a5,s5
ffffffffc0202b6c:	2e879e63          	bne	a5,s0,ffffffffc0202e68 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b70:	6098                	ld	a4,0(s1)
ffffffffc0202b72:	9452                	add	s0,s0,s4
ffffffffc0202b74:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b78:	fcf468e3          	bltu	s0,a5,ffffffffc0202b48 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202b7c:	00093783          	ld	a5,0(s2)
ffffffffc0202b80:	639c                	ld	a5,0(a5)
ffffffffc0202b82:	42079363          	bnez	a5,ffffffffc0202fa8 <pmm_init+0x866>
ffffffffc0202b86:	100027f3          	csrr	a5,sstatus
ffffffffc0202b8a:	8b89                	andi	a5,a5,2
ffffffffc0202b8c:	24079963          	bnez	a5,ffffffffc0202dde <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b90:	000b3783          	ld	a5,0(s6)
ffffffffc0202b94:	4505                	li	a0,1
ffffffffc0202b96:	6f9c                	ld	a5,24(a5)
ffffffffc0202b98:	9782                	jalr	a5
ffffffffc0202b9a:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202b9c:	00093503          	ld	a0,0(s2)
ffffffffc0202ba0:	4699                	li	a3,6
ffffffffc0202ba2:	10000613          	li	a2,256
ffffffffc0202ba6:	85d2                	mv	a1,s4
ffffffffc0202ba8:	aa5ff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc0202bac:	44051e63          	bnez	a0,ffffffffc0203008 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202bb0:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc8>
ffffffffc0202bb4:	4785                	li	a5,1
ffffffffc0202bb6:	42f71963          	bne	a4,a5,ffffffffc0202fe8 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202bba:	00093503          	ld	a0,0(s2)
ffffffffc0202bbe:	6405                	lui	s0,0x1
ffffffffc0202bc0:	4699                	li	a3,6
ffffffffc0202bc2:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ac8>
ffffffffc0202bc6:	85d2                	mv	a1,s4
ffffffffc0202bc8:	a85ff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc0202bcc:	72051363          	bnez	a0,ffffffffc02032f2 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202bd0:	000a2703          	lw	a4,0(s4)
ffffffffc0202bd4:	4789                	li	a5,2
ffffffffc0202bd6:	6ef71e63          	bne	a4,a5,ffffffffc02032d2 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202bda:	00004597          	auipc	a1,0x4
ffffffffc0202bde:	fee58593          	addi	a1,a1,-18 # ffffffffc0206bc8 <default_pmm_manager+0x6a8>
ffffffffc0202be2:	10000513          	li	a0,256
ffffffffc0202be6:	25f020ef          	jal	ra,ffffffffc0205644 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202bea:	10040593          	addi	a1,s0,256
ffffffffc0202bee:	10000513          	li	a0,256
ffffffffc0202bf2:	265020ef          	jal	ra,ffffffffc0205656 <strcmp>
ffffffffc0202bf6:	6a051e63          	bnez	a0,ffffffffc02032b2 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202bfa:	000bb683          	ld	a3,0(s7)
ffffffffc0202bfe:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202c02:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202c04:	40da06b3          	sub	a3,s4,a3
ffffffffc0202c08:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202c0a:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c0c:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c0e:	8031                	srli	s0,s0,0xc
ffffffffc0202c10:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c14:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c16:	30f77d63          	bgeu	a4,a5,ffffffffc0202f30 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c1a:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c1e:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c22:	96be                	add	a3,a3,a5
ffffffffc0202c24:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c28:	1e7020ef          	jal	ra,ffffffffc020560e <strlen>
ffffffffc0202c2c:	66051363          	bnez	a0,ffffffffc0203292 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c30:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c34:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c36:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd546bc>
ffffffffc0202c3a:	068a                	slli	a3,a3,0x2
ffffffffc0202c3c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c3e:	26f6f563          	bgeu	a3,a5,ffffffffc0202ea8 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c42:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c44:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c46:	2ef47563          	bgeu	s0,a5,ffffffffc0202f30 <pmm_init+0x7ee>
ffffffffc0202c4a:	0009b403          	ld	s0,0(s3)
ffffffffc0202c4e:	9436                	add	s0,s0,a3
ffffffffc0202c50:	100027f3          	csrr	a5,sstatus
ffffffffc0202c54:	8b89                	andi	a5,a5,2
ffffffffc0202c56:	1e079163          	bnez	a5,ffffffffc0202e38 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c5e:	4585                	li	a1,1
ffffffffc0202c60:	8552                	mv	a0,s4
ffffffffc0202c62:	739c                	ld	a5,32(a5)
ffffffffc0202c64:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c66:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202c68:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c6a:	078a                	slli	a5,a5,0x2
ffffffffc0202c6c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c6e:	22e7fd63          	bgeu	a5,a4,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c72:	000bb503          	ld	a0,0(s7)
ffffffffc0202c76:	fff80737          	lui	a4,0xfff80
ffffffffc0202c7a:	97ba                	add	a5,a5,a4
ffffffffc0202c7c:	079a                	slli	a5,a5,0x6
ffffffffc0202c7e:	953e                	add	a0,a0,a5
ffffffffc0202c80:	100027f3          	csrr	a5,sstatus
ffffffffc0202c84:	8b89                	andi	a5,a5,2
ffffffffc0202c86:	18079d63          	bnez	a5,ffffffffc0202e20 <pmm_init+0x6de>
ffffffffc0202c8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c8e:	4585                	li	a1,1
ffffffffc0202c90:	739c                	ld	a5,32(a5)
ffffffffc0202c92:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c94:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202c98:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c9a:	078a                	slli	a5,a5,0x2
ffffffffc0202c9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c9e:	20e7f563          	bgeu	a5,a4,ffffffffc0202ea8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ca2:	000bb503          	ld	a0,0(s7)
ffffffffc0202ca6:	fff80737          	lui	a4,0xfff80
ffffffffc0202caa:	97ba                	add	a5,a5,a4
ffffffffc0202cac:	079a                	slli	a5,a5,0x6
ffffffffc0202cae:	953e                	add	a0,a0,a5
ffffffffc0202cb0:	100027f3          	csrr	a5,sstatus
ffffffffc0202cb4:	8b89                	andi	a5,a5,2
ffffffffc0202cb6:	14079963          	bnez	a5,ffffffffc0202e08 <pmm_init+0x6c6>
ffffffffc0202cba:	000b3783          	ld	a5,0(s6)
ffffffffc0202cbe:	4585                	li	a1,1
ffffffffc0202cc0:	739c                	ld	a5,32(a5)
ffffffffc0202cc2:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202cc4:	00093783          	ld	a5,0(s2)
ffffffffc0202cc8:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202ccc:	12000073          	sfence.vma
ffffffffc0202cd0:	100027f3          	csrr	a5,sstatus
ffffffffc0202cd4:	8b89                	andi	a5,a5,2
ffffffffc0202cd6:	10079f63          	bnez	a5,ffffffffc0202df4 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cda:	000b3783          	ld	a5,0(s6)
ffffffffc0202cde:	779c                	ld	a5,40(a5)
ffffffffc0202ce0:	9782                	jalr	a5
ffffffffc0202ce2:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ce4:	4c8c1e63          	bne	s8,s0,ffffffffc02031c0 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202ce8:	00004517          	auipc	a0,0x4
ffffffffc0202cec:	f5850513          	addi	a0,a0,-168 # ffffffffc0206c40 <default_pmm_manager+0x720>
ffffffffc0202cf0:	ca4fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202cf4:	7406                	ld	s0,96(sp)
ffffffffc0202cf6:	70a6                	ld	ra,104(sp)
ffffffffc0202cf8:	64e6                	ld	s1,88(sp)
ffffffffc0202cfa:	6946                	ld	s2,80(sp)
ffffffffc0202cfc:	69a6                	ld	s3,72(sp)
ffffffffc0202cfe:	6a06                	ld	s4,64(sp)
ffffffffc0202d00:	7ae2                	ld	s5,56(sp)
ffffffffc0202d02:	7b42                	ld	s6,48(sp)
ffffffffc0202d04:	7ba2                	ld	s7,40(sp)
ffffffffc0202d06:	7c02                	ld	s8,32(sp)
ffffffffc0202d08:	6ce2                	ld	s9,24(sp)
ffffffffc0202d0a:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d0c:	f97fe06f          	j	ffffffffc0201ca2 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202d10:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d14:	bc7d                	j	ffffffffc02027d2 <pmm_init+0x90>
        intr_disable();
ffffffffc0202d16:	c9ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1e:	4505                	li	a0,1
ffffffffc0202d20:	6f9c                	ld	a5,24(a5)
ffffffffc0202d22:	9782                	jalr	a5
ffffffffc0202d24:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d26:	c89fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d2a:	b9a9                	j	ffffffffc0202984 <pmm_init+0x242>
        intr_disable();
ffffffffc0202d2c:	c89fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d30:	000b3783          	ld	a5,0(s6)
ffffffffc0202d34:	4505                	li	a0,1
ffffffffc0202d36:	6f9c                	ld	a5,24(a5)
ffffffffc0202d38:	9782                	jalr	a5
ffffffffc0202d3a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d3c:	c73fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d40:	b645                	j	ffffffffc02028e0 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d42:	c73fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d46:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4a:	779c                	ld	a5,40(a5)
ffffffffc0202d4c:	9782                	jalr	a5
ffffffffc0202d4e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d50:	c5ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d54:	b6b9                	j	ffffffffc02028a2 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d56:	6705                	lui	a4,0x1
ffffffffc0202d58:	177d                	addi	a4,a4,-1
ffffffffc0202d5a:	96ba                	add	a3,a3,a4
ffffffffc0202d5c:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d5e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d62:	14a77363          	bgeu	a4,a0,ffffffffc0202ea8 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d66:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202d6a:	fff80537          	lui	a0,0xfff80
ffffffffc0202d6e:	972a                	add	a4,a4,a0
ffffffffc0202d70:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202d72:	8c1d                	sub	s0,s0,a5
ffffffffc0202d74:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202d78:	00c45593          	srli	a1,s0,0xc
ffffffffc0202d7c:	9532                	add	a0,a0,a2
ffffffffc0202d7e:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202d80:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202d84:	b4c1                	j	ffffffffc0202844 <pmm_init+0x102>
        intr_disable();
ffffffffc0202d86:	c2ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d8a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8e:	779c                	ld	a5,40(a5)
ffffffffc0202d90:	9782                	jalr	a5
ffffffffc0202d92:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d94:	c1bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d98:	bb79                	j	ffffffffc0202b36 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202d9a:	c1bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d9e:	000b3783          	ld	a5,0(s6)
ffffffffc0202da2:	779c                	ld	a5,40(a5)
ffffffffc0202da4:	9782                	jalr	a5
ffffffffc0202da6:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202da8:	c07fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dac:	b39d                	j	ffffffffc0202b12 <pmm_init+0x3d0>
ffffffffc0202dae:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202db0:	c05fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202db4:	000b3783          	ld	a5,0(s6)
ffffffffc0202db8:	6522                	ld	a0,8(sp)
ffffffffc0202dba:	4585                	li	a1,1
ffffffffc0202dbc:	739c                	ld	a5,32(a5)
ffffffffc0202dbe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dc0:	beffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dc4:	b33d                	j	ffffffffc0202af2 <pmm_init+0x3b0>
ffffffffc0202dc6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dc8:	bedfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dcc:	000b3783          	ld	a5,0(s6)
ffffffffc0202dd0:	6522                	ld	a0,8(sp)
ffffffffc0202dd2:	4585                	li	a1,1
ffffffffc0202dd4:	739c                	ld	a5,32(a5)
ffffffffc0202dd6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dd8:	bd7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ddc:	b1dd                	j	ffffffffc0202ac2 <pmm_init+0x380>
        intr_disable();
ffffffffc0202dde:	bd7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202de2:	000b3783          	ld	a5,0(s6)
ffffffffc0202de6:	4505                	li	a0,1
ffffffffc0202de8:	6f9c                	ld	a5,24(a5)
ffffffffc0202dea:	9782                	jalr	a5
ffffffffc0202dec:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dee:	bc1fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202df2:	b36d                	j	ffffffffc0202b9c <pmm_init+0x45a>
        intr_disable();
ffffffffc0202df4:	bc1fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202df8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dfc:	779c                	ld	a5,40(a5)
ffffffffc0202dfe:	9782                	jalr	a5
ffffffffc0202e00:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e02:	badfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e06:	bdf9                	j	ffffffffc0202ce4 <pmm_init+0x5a2>
ffffffffc0202e08:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e0a:	babfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e0e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e12:	6522                	ld	a0,8(sp)
ffffffffc0202e14:	4585                	li	a1,1
ffffffffc0202e16:	739c                	ld	a5,32(a5)
ffffffffc0202e18:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e1a:	b95fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e1e:	b55d                	j	ffffffffc0202cc4 <pmm_init+0x582>
ffffffffc0202e20:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e22:	b93fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e26:	000b3783          	ld	a5,0(s6)
ffffffffc0202e2a:	6522                	ld	a0,8(sp)
ffffffffc0202e2c:	4585                	li	a1,1
ffffffffc0202e2e:	739c                	ld	a5,32(a5)
ffffffffc0202e30:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e32:	b7dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e36:	bdb9                	j	ffffffffc0202c94 <pmm_init+0x552>
        intr_disable();
ffffffffc0202e38:	b7dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e3c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e40:	4585                	li	a1,1
ffffffffc0202e42:	8552                	mv	a0,s4
ffffffffc0202e44:	739c                	ld	a5,32(a5)
ffffffffc0202e46:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e48:	b67fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e4c:	bd29                	j	ffffffffc0202c66 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e4e:	86a2                	mv	a3,s0
ffffffffc0202e50:	00003617          	auipc	a2,0x3
ffffffffc0202e54:	70860613          	addi	a2,a2,1800 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0202e58:	25300593          	li	a1,595
ffffffffc0202e5c:	00004517          	auipc	a0,0x4
ffffffffc0202e60:	81450513          	addi	a0,a0,-2028 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202e64:	e2afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e68:	00004697          	auipc	a3,0x4
ffffffffc0202e6c:	c7868693          	addi	a3,a3,-904 # ffffffffc0206ae0 <default_pmm_manager+0x5c0>
ffffffffc0202e70:	00003617          	auipc	a2,0x3
ffffffffc0202e74:	30060613          	addi	a2,a2,768 # ffffffffc0206170 <commands+0x828>
ffffffffc0202e78:	25400593          	li	a1,596
ffffffffc0202e7c:	00003517          	auipc	a0,0x3
ffffffffc0202e80:	7f450513          	addi	a0,a0,2036 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202e84:	e0afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e88:	00004697          	auipc	a3,0x4
ffffffffc0202e8c:	c1868693          	addi	a3,a3,-1000 # ffffffffc0206aa0 <default_pmm_manager+0x580>
ffffffffc0202e90:	00003617          	auipc	a2,0x3
ffffffffc0202e94:	2e060613          	addi	a2,a2,736 # ffffffffc0206170 <commands+0x828>
ffffffffc0202e98:	25300593          	li	a1,595
ffffffffc0202e9c:	00003517          	auipc	a0,0x3
ffffffffc0202ea0:	7d450513          	addi	a0,a0,2004 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202ea4:	deafd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202ea8:	fc5fe0ef          	jal	ra,ffffffffc0201e6c <pa2page.part.0>
ffffffffc0202eac:	fddfe0ef          	jal	ra,ffffffffc0201e88 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202eb0:	00004697          	auipc	a3,0x4
ffffffffc0202eb4:	9e868693          	addi	a3,a3,-1560 # ffffffffc0206898 <default_pmm_manager+0x378>
ffffffffc0202eb8:	00003617          	auipc	a2,0x3
ffffffffc0202ebc:	2b860613          	addi	a2,a2,696 # ffffffffc0206170 <commands+0x828>
ffffffffc0202ec0:	22300593          	li	a1,547
ffffffffc0202ec4:	00003517          	auipc	a0,0x3
ffffffffc0202ec8:	7ac50513          	addi	a0,a0,1964 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202ecc:	dc2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202ed0:	00004697          	auipc	a3,0x4
ffffffffc0202ed4:	90868693          	addi	a3,a3,-1784 # ffffffffc02067d8 <default_pmm_manager+0x2b8>
ffffffffc0202ed8:	00003617          	auipc	a2,0x3
ffffffffc0202edc:	29860613          	addi	a2,a2,664 # ffffffffc0206170 <commands+0x828>
ffffffffc0202ee0:	21600593          	li	a1,534
ffffffffc0202ee4:	00003517          	auipc	a0,0x3
ffffffffc0202ee8:	78c50513          	addi	a0,a0,1932 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202eec:	da2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ef0:	00004697          	auipc	a3,0x4
ffffffffc0202ef4:	8a868693          	addi	a3,a3,-1880 # ffffffffc0206798 <default_pmm_manager+0x278>
ffffffffc0202ef8:	00003617          	auipc	a2,0x3
ffffffffc0202efc:	27860613          	addi	a2,a2,632 # ffffffffc0206170 <commands+0x828>
ffffffffc0202f00:	21500593          	li	a1,533
ffffffffc0202f04:	00003517          	auipc	a0,0x3
ffffffffc0202f08:	76c50513          	addi	a0,a0,1900 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202f0c:	d82fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f10:	00004697          	auipc	a3,0x4
ffffffffc0202f14:	86868693          	addi	a3,a3,-1944 # ffffffffc0206778 <default_pmm_manager+0x258>
ffffffffc0202f18:	00003617          	auipc	a2,0x3
ffffffffc0202f1c:	25860613          	addi	a2,a2,600 # ffffffffc0206170 <commands+0x828>
ffffffffc0202f20:	21400593          	li	a1,532
ffffffffc0202f24:	00003517          	auipc	a0,0x3
ffffffffc0202f28:	74c50513          	addi	a0,a0,1868 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202f2c:	d62fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f30:	00003617          	auipc	a2,0x3
ffffffffc0202f34:	62860613          	addi	a2,a2,1576 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0202f38:	07100593          	li	a1,113
ffffffffc0202f3c:	00003517          	auipc	a0,0x3
ffffffffc0202f40:	64450513          	addi	a0,a0,1604 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0202f44:	d4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f48:	00004697          	auipc	a3,0x4
ffffffffc0202f4c:	ae068693          	addi	a3,a3,-1312 # ffffffffc0206a28 <default_pmm_manager+0x508>
ffffffffc0202f50:	00003617          	auipc	a2,0x3
ffffffffc0202f54:	22060613          	addi	a2,a2,544 # ffffffffc0206170 <commands+0x828>
ffffffffc0202f58:	23c00593          	li	a1,572
ffffffffc0202f5c:	00003517          	auipc	a0,0x3
ffffffffc0202f60:	71450513          	addi	a0,a0,1812 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202f64:	d2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f68:	00004697          	auipc	a3,0x4
ffffffffc0202f6c:	a7868693          	addi	a3,a3,-1416 # ffffffffc02069e0 <default_pmm_manager+0x4c0>
ffffffffc0202f70:	00003617          	auipc	a2,0x3
ffffffffc0202f74:	20060613          	addi	a2,a2,512 # ffffffffc0206170 <commands+0x828>
ffffffffc0202f78:	23a00593          	li	a1,570
ffffffffc0202f7c:	00003517          	auipc	a0,0x3
ffffffffc0202f80:	6f450513          	addi	a0,a0,1780 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202f84:	d0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f88:	00004697          	auipc	a3,0x4
ffffffffc0202f8c:	a8868693          	addi	a3,a3,-1400 # ffffffffc0206a10 <default_pmm_manager+0x4f0>
ffffffffc0202f90:	00003617          	auipc	a2,0x3
ffffffffc0202f94:	1e060613          	addi	a2,a2,480 # ffffffffc0206170 <commands+0x828>
ffffffffc0202f98:	23900593          	li	a1,569
ffffffffc0202f9c:	00003517          	auipc	a0,0x3
ffffffffc0202fa0:	6d450513          	addi	a0,a0,1748 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202fa4:	ceafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202fa8:	00004697          	auipc	a3,0x4
ffffffffc0202fac:	b5068693          	addi	a3,a3,-1200 # ffffffffc0206af8 <default_pmm_manager+0x5d8>
ffffffffc0202fb0:	00003617          	auipc	a2,0x3
ffffffffc0202fb4:	1c060613          	addi	a2,a2,448 # ffffffffc0206170 <commands+0x828>
ffffffffc0202fb8:	25700593          	li	a1,599
ffffffffc0202fbc:	00003517          	auipc	a0,0x3
ffffffffc0202fc0:	6b450513          	addi	a0,a0,1716 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202fc4:	ccafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202fc8:	00004697          	auipc	a3,0x4
ffffffffc0202fcc:	a9068693          	addi	a3,a3,-1392 # ffffffffc0206a58 <default_pmm_manager+0x538>
ffffffffc0202fd0:	00003617          	auipc	a2,0x3
ffffffffc0202fd4:	1a060613          	addi	a2,a2,416 # ffffffffc0206170 <commands+0x828>
ffffffffc0202fd8:	24400593          	li	a1,580
ffffffffc0202fdc:	00003517          	auipc	a0,0x3
ffffffffc0202fe0:	69450513          	addi	a0,a0,1684 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0202fe4:	caafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fe8:	00004697          	auipc	a3,0x4
ffffffffc0202fec:	b6868693          	addi	a3,a3,-1176 # ffffffffc0206b50 <default_pmm_manager+0x630>
ffffffffc0202ff0:	00003617          	auipc	a2,0x3
ffffffffc0202ff4:	18060613          	addi	a2,a2,384 # ffffffffc0206170 <commands+0x828>
ffffffffc0202ff8:	25c00593          	li	a1,604
ffffffffc0202ffc:	00003517          	auipc	a0,0x3
ffffffffc0203000:	67450513          	addi	a0,a0,1652 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203004:	c8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203008:	00004697          	auipc	a3,0x4
ffffffffc020300c:	b0868693          	addi	a3,a3,-1272 # ffffffffc0206b10 <default_pmm_manager+0x5f0>
ffffffffc0203010:	00003617          	auipc	a2,0x3
ffffffffc0203014:	16060613          	addi	a2,a2,352 # ffffffffc0206170 <commands+0x828>
ffffffffc0203018:	25b00593          	li	a1,603
ffffffffc020301c:	00003517          	auipc	a0,0x3
ffffffffc0203020:	65450513          	addi	a0,a0,1620 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203024:	c6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203028:	00004697          	auipc	a3,0x4
ffffffffc020302c:	9b868693          	addi	a3,a3,-1608 # ffffffffc02069e0 <default_pmm_manager+0x4c0>
ffffffffc0203030:	00003617          	auipc	a2,0x3
ffffffffc0203034:	14060613          	addi	a2,a2,320 # ffffffffc0206170 <commands+0x828>
ffffffffc0203038:	23600593          	li	a1,566
ffffffffc020303c:	00003517          	auipc	a0,0x3
ffffffffc0203040:	63450513          	addi	a0,a0,1588 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203044:	c4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203048:	00004697          	auipc	a3,0x4
ffffffffc020304c:	83868693          	addi	a3,a3,-1992 # ffffffffc0206880 <default_pmm_manager+0x360>
ffffffffc0203050:	00003617          	auipc	a2,0x3
ffffffffc0203054:	12060613          	addi	a2,a2,288 # ffffffffc0206170 <commands+0x828>
ffffffffc0203058:	23500593          	li	a1,565
ffffffffc020305c:	00003517          	auipc	a0,0x3
ffffffffc0203060:	61450513          	addi	a0,a0,1556 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203064:	c2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203068:	00004697          	auipc	a3,0x4
ffffffffc020306c:	99068693          	addi	a3,a3,-1648 # ffffffffc02069f8 <default_pmm_manager+0x4d8>
ffffffffc0203070:	00003617          	auipc	a2,0x3
ffffffffc0203074:	10060613          	addi	a2,a2,256 # ffffffffc0206170 <commands+0x828>
ffffffffc0203078:	23200593          	li	a1,562
ffffffffc020307c:	00003517          	auipc	a0,0x3
ffffffffc0203080:	5f450513          	addi	a0,a0,1524 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203084:	c0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203088:	00003697          	auipc	a3,0x3
ffffffffc020308c:	7e068693          	addi	a3,a3,2016 # ffffffffc0206868 <default_pmm_manager+0x348>
ffffffffc0203090:	00003617          	auipc	a2,0x3
ffffffffc0203094:	0e060613          	addi	a2,a2,224 # ffffffffc0206170 <commands+0x828>
ffffffffc0203098:	23100593          	li	a1,561
ffffffffc020309c:	00003517          	auipc	a0,0x3
ffffffffc02030a0:	5d450513          	addi	a0,a0,1492 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02030a4:	beafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030a8:	00004697          	auipc	a3,0x4
ffffffffc02030ac:	86068693          	addi	a3,a3,-1952 # ffffffffc0206908 <default_pmm_manager+0x3e8>
ffffffffc02030b0:	00003617          	auipc	a2,0x3
ffffffffc02030b4:	0c060613          	addi	a2,a2,192 # ffffffffc0206170 <commands+0x828>
ffffffffc02030b8:	23000593          	li	a1,560
ffffffffc02030bc:	00003517          	auipc	a0,0x3
ffffffffc02030c0:	5b450513          	addi	a0,a0,1460 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02030c4:	bcafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030c8:	00004697          	auipc	a3,0x4
ffffffffc02030cc:	91868693          	addi	a3,a3,-1768 # ffffffffc02069e0 <default_pmm_manager+0x4c0>
ffffffffc02030d0:	00003617          	auipc	a2,0x3
ffffffffc02030d4:	0a060613          	addi	a2,a2,160 # ffffffffc0206170 <commands+0x828>
ffffffffc02030d8:	22f00593          	li	a1,559
ffffffffc02030dc:	00003517          	auipc	a0,0x3
ffffffffc02030e0:	59450513          	addi	a0,a0,1428 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02030e4:	baafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02030e8:	00004697          	auipc	a3,0x4
ffffffffc02030ec:	8e068693          	addi	a3,a3,-1824 # ffffffffc02069c8 <default_pmm_manager+0x4a8>
ffffffffc02030f0:	00003617          	auipc	a2,0x3
ffffffffc02030f4:	08060613          	addi	a2,a2,128 # ffffffffc0206170 <commands+0x828>
ffffffffc02030f8:	22e00593          	li	a1,558
ffffffffc02030fc:	00003517          	auipc	a0,0x3
ffffffffc0203100:	57450513          	addi	a0,a0,1396 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203104:	b8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203108:	00004697          	auipc	a3,0x4
ffffffffc020310c:	89068693          	addi	a3,a3,-1904 # ffffffffc0206998 <default_pmm_manager+0x478>
ffffffffc0203110:	00003617          	auipc	a2,0x3
ffffffffc0203114:	06060613          	addi	a2,a2,96 # ffffffffc0206170 <commands+0x828>
ffffffffc0203118:	22d00593          	li	a1,557
ffffffffc020311c:	00003517          	auipc	a0,0x3
ffffffffc0203120:	55450513          	addi	a0,a0,1364 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203124:	b6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203128:	00004697          	auipc	a3,0x4
ffffffffc020312c:	85868693          	addi	a3,a3,-1960 # ffffffffc0206980 <default_pmm_manager+0x460>
ffffffffc0203130:	00003617          	auipc	a2,0x3
ffffffffc0203134:	04060613          	addi	a2,a2,64 # ffffffffc0206170 <commands+0x828>
ffffffffc0203138:	22b00593          	li	a1,555
ffffffffc020313c:	00003517          	auipc	a0,0x3
ffffffffc0203140:	53450513          	addi	a0,a0,1332 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203144:	b4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203148:	00004697          	auipc	a3,0x4
ffffffffc020314c:	81868693          	addi	a3,a3,-2024 # ffffffffc0206960 <default_pmm_manager+0x440>
ffffffffc0203150:	00003617          	auipc	a2,0x3
ffffffffc0203154:	02060613          	addi	a2,a2,32 # ffffffffc0206170 <commands+0x828>
ffffffffc0203158:	22a00593          	li	a1,554
ffffffffc020315c:	00003517          	auipc	a0,0x3
ffffffffc0203160:	51450513          	addi	a0,a0,1300 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203164:	b2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203168:	00003697          	auipc	a3,0x3
ffffffffc020316c:	7e868693          	addi	a3,a3,2024 # ffffffffc0206950 <default_pmm_manager+0x430>
ffffffffc0203170:	00003617          	auipc	a2,0x3
ffffffffc0203174:	00060613          	mv	a2,a2
ffffffffc0203178:	22900593          	li	a1,553
ffffffffc020317c:	00003517          	auipc	a0,0x3
ffffffffc0203180:	4f450513          	addi	a0,a0,1268 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203184:	b0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203188:	00003697          	auipc	a3,0x3
ffffffffc020318c:	7b868693          	addi	a3,a3,1976 # ffffffffc0206940 <default_pmm_manager+0x420>
ffffffffc0203190:	00003617          	auipc	a2,0x3
ffffffffc0203194:	fe060613          	addi	a2,a2,-32 # ffffffffc0206170 <commands+0x828>
ffffffffc0203198:	22800593          	li	a1,552
ffffffffc020319c:	00003517          	auipc	a0,0x3
ffffffffc02031a0:	4d450513          	addi	a0,a0,1236 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02031a4:	aeafd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc02031a8:	00003617          	auipc	a2,0x3
ffffffffc02031ac:	53860613          	addi	a2,a2,1336 # ffffffffc02066e0 <default_pmm_manager+0x1c0>
ffffffffc02031b0:	06500593          	li	a1,101
ffffffffc02031b4:	00003517          	auipc	a0,0x3
ffffffffc02031b8:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02031bc:	ad2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031c0:	00004697          	auipc	a3,0x4
ffffffffc02031c4:	89868693          	addi	a3,a3,-1896 # ffffffffc0206a58 <default_pmm_manager+0x538>
ffffffffc02031c8:	00003617          	auipc	a2,0x3
ffffffffc02031cc:	fa860613          	addi	a2,a2,-88 # ffffffffc0206170 <commands+0x828>
ffffffffc02031d0:	26e00593          	li	a1,622
ffffffffc02031d4:	00003517          	auipc	a0,0x3
ffffffffc02031d8:	49c50513          	addi	a0,a0,1180 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02031dc:	ab2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031e0:	00003697          	auipc	a3,0x3
ffffffffc02031e4:	72868693          	addi	a3,a3,1832 # ffffffffc0206908 <default_pmm_manager+0x3e8>
ffffffffc02031e8:	00003617          	auipc	a2,0x3
ffffffffc02031ec:	f8860613          	addi	a2,a2,-120 # ffffffffc0206170 <commands+0x828>
ffffffffc02031f0:	22700593          	li	a1,551
ffffffffc02031f4:	00003517          	auipc	a0,0x3
ffffffffc02031f8:	47c50513          	addi	a0,a0,1148 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02031fc:	a92fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203200:	00003697          	auipc	a3,0x3
ffffffffc0203204:	6c868693          	addi	a3,a3,1736 # ffffffffc02068c8 <default_pmm_manager+0x3a8>
ffffffffc0203208:	00003617          	auipc	a2,0x3
ffffffffc020320c:	f6860613          	addi	a2,a2,-152 # ffffffffc0206170 <commands+0x828>
ffffffffc0203210:	22600593          	li	a1,550
ffffffffc0203214:	00003517          	auipc	a0,0x3
ffffffffc0203218:	45c50513          	addi	a0,a0,1116 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020321c:	a72fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203220:	86d6                	mv	a3,s5
ffffffffc0203222:	00003617          	auipc	a2,0x3
ffffffffc0203226:	33660613          	addi	a2,a2,822 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc020322a:	22200593          	li	a1,546
ffffffffc020322e:	00003517          	auipc	a0,0x3
ffffffffc0203232:	44250513          	addi	a0,a0,1090 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203236:	a58fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020323a:	00003617          	auipc	a2,0x3
ffffffffc020323e:	31e60613          	addi	a2,a2,798 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0203242:	22100593          	li	a1,545
ffffffffc0203246:	00003517          	auipc	a0,0x3
ffffffffc020324a:	42a50513          	addi	a0,a0,1066 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020324e:	a40fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203252:	00003697          	auipc	a3,0x3
ffffffffc0203256:	62e68693          	addi	a3,a3,1582 # ffffffffc0206880 <default_pmm_manager+0x360>
ffffffffc020325a:	00003617          	auipc	a2,0x3
ffffffffc020325e:	f1660613          	addi	a2,a2,-234 # ffffffffc0206170 <commands+0x828>
ffffffffc0203262:	21f00593          	li	a1,543
ffffffffc0203266:	00003517          	auipc	a0,0x3
ffffffffc020326a:	40a50513          	addi	a0,a0,1034 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020326e:	a20fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203272:	00003697          	auipc	a3,0x3
ffffffffc0203276:	5f668693          	addi	a3,a3,1526 # ffffffffc0206868 <default_pmm_manager+0x348>
ffffffffc020327a:	00003617          	auipc	a2,0x3
ffffffffc020327e:	ef660613          	addi	a2,a2,-266 # ffffffffc0206170 <commands+0x828>
ffffffffc0203282:	21e00593          	li	a1,542
ffffffffc0203286:	00003517          	auipc	a0,0x3
ffffffffc020328a:	3ea50513          	addi	a0,a0,1002 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020328e:	a00fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203292:	00004697          	auipc	a3,0x4
ffffffffc0203296:	98668693          	addi	a3,a3,-1658 # ffffffffc0206c18 <default_pmm_manager+0x6f8>
ffffffffc020329a:	00003617          	auipc	a2,0x3
ffffffffc020329e:	ed660613          	addi	a2,a2,-298 # ffffffffc0206170 <commands+0x828>
ffffffffc02032a2:	26500593          	li	a1,613
ffffffffc02032a6:	00003517          	auipc	a0,0x3
ffffffffc02032aa:	3ca50513          	addi	a0,a0,970 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02032ae:	9e0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032b2:	00004697          	auipc	a3,0x4
ffffffffc02032b6:	92e68693          	addi	a3,a3,-1746 # ffffffffc0206be0 <default_pmm_manager+0x6c0>
ffffffffc02032ba:	00003617          	auipc	a2,0x3
ffffffffc02032be:	eb660613          	addi	a2,a2,-330 # ffffffffc0206170 <commands+0x828>
ffffffffc02032c2:	26200593          	li	a1,610
ffffffffc02032c6:	00003517          	auipc	a0,0x3
ffffffffc02032ca:	3aa50513          	addi	a0,a0,938 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02032ce:	9c0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02032d2:	00004697          	auipc	a3,0x4
ffffffffc02032d6:	8de68693          	addi	a3,a3,-1826 # ffffffffc0206bb0 <default_pmm_manager+0x690>
ffffffffc02032da:	00003617          	auipc	a2,0x3
ffffffffc02032de:	e9660613          	addi	a2,a2,-362 # ffffffffc0206170 <commands+0x828>
ffffffffc02032e2:	25e00593          	li	a1,606
ffffffffc02032e6:	00003517          	auipc	a0,0x3
ffffffffc02032ea:	38a50513          	addi	a0,a0,906 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02032ee:	9a0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032f2:	00004697          	auipc	a3,0x4
ffffffffc02032f6:	87668693          	addi	a3,a3,-1930 # ffffffffc0206b68 <default_pmm_manager+0x648>
ffffffffc02032fa:	00003617          	auipc	a2,0x3
ffffffffc02032fe:	e7660613          	addi	a2,a2,-394 # ffffffffc0206170 <commands+0x828>
ffffffffc0203302:	25d00593          	li	a1,605
ffffffffc0203306:	00003517          	auipc	a0,0x3
ffffffffc020330a:	36a50513          	addi	a0,a0,874 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020330e:	980fd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203312:	00003617          	auipc	a2,0x3
ffffffffc0203316:	2ee60613          	addi	a2,a2,750 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc020331a:	0c900593          	li	a1,201
ffffffffc020331e:	00003517          	auipc	a0,0x3
ffffffffc0203322:	35250513          	addi	a0,a0,850 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc0203326:	968fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020332a:	00003617          	auipc	a2,0x3
ffffffffc020332e:	2d660613          	addi	a2,a2,726 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0203332:	08100593          	li	a1,129
ffffffffc0203336:	00003517          	auipc	a0,0x3
ffffffffc020333a:	33a50513          	addi	a0,a0,826 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020333e:	950fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203342:	00003697          	auipc	a3,0x3
ffffffffc0203346:	4f668693          	addi	a3,a3,1270 # ffffffffc0206838 <default_pmm_manager+0x318>
ffffffffc020334a:	00003617          	auipc	a2,0x3
ffffffffc020334e:	e2660613          	addi	a2,a2,-474 # ffffffffc0206170 <commands+0x828>
ffffffffc0203352:	21d00593          	li	a1,541
ffffffffc0203356:	00003517          	auipc	a0,0x3
ffffffffc020335a:	31a50513          	addi	a0,a0,794 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020335e:	930fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203362:	00003697          	auipc	a3,0x3
ffffffffc0203366:	4a668693          	addi	a3,a3,1190 # ffffffffc0206808 <default_pmm_manager+0x2e8>
ffffffffc020336a:	00003617          	auipc	a2,0x3
ffffffffc020336e:	e0660613          	addi	a2,a2,-506 # ffffffffc0206170 <commands+0x828>
ffffffffc0203372:	21a00593          	li	a1,538
ffffffffc0203376:	00003517          	auipc	a0,0x3
ffffffffc020337a:	2fa50513          	addi	a0,a0,762 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020337e:	910fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203382 <copy_range>:
{
ffffffffc0203382:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203384:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203388:	f486                	sd	ra,104(sp)
ffffffffc020338a:	f0a2                	sd	s0,96(sp)
ffffffffc020338c:	eca6                	sd	s1,88(sp)
ffffffffc020338e:	e8ca                	sd	s2,80(sp)
ffffffffc0203390:	e4ce                	sd	s3,72(sp)
ffffffffc0203392:	e0d2                	sd	s4,64(sp)
ffffffffc0203394:	fc56                	sd	s5,56(sp)
ffffffffc0203396:	f85a                	sd	s6,48(sp)
ffffffffc0203398:	f45e                	sd	s7,40(sp)
ffffffffc020339a:	f062                	sd	s8,32(sp)
ffffffffc020339c:	ec66                	sd	s9,24(sp)
ffffffffc020339e:	e86a                	sd	s10,16(sp)
ffffffffc02033a0:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033a2:	17d2                	slli	a5,a5,0x34
ffffffffc02033a4:	20079f63          	bnez	a5,ffffffffc02035c2 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc02033a8:	002007b7          	lui	a5,0x200
ffffffffc02033ac:	8432                	mv	s0,a2
ffffffffc02033ae:	1af66263          	bltu	a2,a5,ffffffffc0203552 <copy_range+0x1d0>
ffffffffc02033b2:	8936                	mv	s2,a3
ffffffffc02033b4:	18d67f63          	bgeu	a2,a3,ffffffffc0203552 <copy_range+0x1d0>
ffffffffc02033b8:	4785                	li	a5,1
ffffffffc02033ba:	07fe                	slli	a5,a5,0x1f
ffffffffc02033bc:	18d7eb63          	bltu	a5,a3,ffffffffc0203552 <copy_range+0x1d0>
ffffffffc02033c0:	5b7d                	li	s6,-1
ffffffffc02033c2:	8aaa                	mv	s5,a0
ffffffffc02033c4:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc02033c6:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02033c8:	000a7c17          	auipc	s8,0xa7
ffffffffc02033cc:	540c0c13          	addi	s8,s8,1344 # ffffffffc02aa908 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02033d0:	000a7b97          	auipc	s7,0xa7
ffffffffc02033d4:	540b8b93          	addi	s7,s7,1344 # ffffffffc02aa910 <pages>
    return KADDR(page2pa(page));
ffffffffc02033d8:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02033dc:	000a7c97          	auipc	s9,0xa7
ffffffffc02033e0:	53cc8c93          	addi	s9,s9,1340 # ffffffffc02aa918 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02033e4:	4601                	li	a2,0
ffffffffc02033e6:	85a2                	mv	a1,s0
ffffffffc02033e8:	854e                	mv	a0,s3
ffffffffc02033ea:	b73fe0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc02033ee:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02033f0:	0e050c63          	beqz	a0,ffffffffc02034e8 <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc02033f4:	611c                	ld	a5,0(a0)
ffffffffc02033f6:	8b85                	andi	a5,a5,1
ffffffffc02033f8:	e785                	bnez	a5,ffffffffc0203420 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc02033fa:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02033fc:	ff2464e3          	bltu	s0,s2,ffffffffc02033e4 <copy_range+0x62>
    return 0;
ffffffffc0203400:	4501                	li	a0,0
}
ffffffffc0203402:	70a6                	ld	ra,104(sp)
ffffffffc0203404:	7406                	ld	s0,96(sp)
ffffffffc0203406:	64e6                	ld	s1,88(sp)
ffffffffc0203408:	6946                	ld	s2,80(sp)
ffffffffc020340a:	69a6                	ld	s3,72(sp)
ffffffffc020340c:	6a06                	ld	s4,64(sp)
ffffffffc020340e:	7ae2                	ld	s5,56(sp)
ffffffffc0203410:	7b42                	ld	s6,48(sp)
ffffffffc0203412:	7ba2                	ld	s7,40(sp)
ffffffffc0203414:	7c02                	ld	s8,32(sp)
ffffffffc0203416:	6ce2                	ld	s9,24(sp)
ffffffffc0203418:	6d42                	ld	s10,16(sp)
ffffffffc020341a:	6da2                	ld	s11,8(sp)
ffffffffc020341c:	6165                	addi	sp,sp,112
ffffffffc020341e:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203420:	4605                	li	a2,1
ffffffffc0203422:	85a2                	mv	a1,s0
ffffffffc0203424:	8556                	mv	a0,s5
ffffffffc0203426:	b37fe0ef          	jal	ra,ffffffffc0201f5c <get_pte>
ffffffffc020342a:	c56d                	beqz	a0,ffffffffc0203514 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020342c:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc020342e:	0017f713          	andi	a4,a5,1
ffffffffc0203432:	01f7f493          	andi	s1,a5,31
ffffffffc0203436:	16070a63          	beqz	a4,ffffffffc02035aa <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc020343a:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc020343e:	078a                	slli	a5,a5,0x2
ffffffffc0203440:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203444:	14d77763          	bgeu	a4,a3,ffffffffc0203592 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203448:	000bb783          	ld	a5,0(s7)
ffffffffc020344c:	fff806b7          	lui	a3,0xfff80
ffffffffc0203450:	9736                	add	a4,a4,a3
ffffffffc0203452:	071a                	slli	a4,a4,0x6
ffffffffc0203454:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203458:	10002773          	csrr	a4,sstatus
ffffffffc020345c:	8b09                	andi	a4,a4,2
ffffffffc020345e:	e345                	bnez	a4,ffffffffc02034fe <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203460:	000cb703          	ld	a4,0(s9)
ffffffffc0203464:	4505                	li	a0,1
ffffffffc0203466:	6f18                	ld	a4,24(a4)
ffffffffc0203468:	9702                	jalr	a4
ffffffffc020346a:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc020346c:	0c0d8363          	beqz	s11,ffffffffc0203532 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203470:	100d0163          	beqz	s10,ffffffffc0203572 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203474:	000bb703          	ld	a4,0(s7)
ffffffffc0203478:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc020347c:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203480:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203484:	8699                	srai	a3,a3,0x6
ffffffffc0203486:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203488:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020348c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020348e:	08c7f663          	bgeu	a5,a2,ffffffffc020351a <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203492:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc0203496:	000a7717          	auipc	a4,0xa7
ffffffffc020349a:	48a70713          	addi	a4,a4,1162 # ffffffffc02aa920 <va_pa_offset>
ffffffffc020349e:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc02034a0:	8799                	srai	a5,a5,0x6
ffffffffc02034a2:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc02034a4:	0167f733          	and	a4,a5,s6
ffffffffc02034a8:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034ac:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02034ae:	06c77563          	bgeu	a4,a2,ffffffffc0203518 <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02034b2:	6605                	lui	a2,0x1
ffffffffc02034b4:	953e                	add	a0,a0,a5
ffffffffc02034b6:	20c020ef          	jal	ra,ffffffffc02056c2 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc02034ba:	86a6                	mv	a3,s1
ffffffffc02034bc:	8622                	mv	a2,s0
ffffffffc02034be:	85ea                	mv	a1,s10
ffffffffc02034c0:	8556                	mv	a0,s5
ffffffffc02034c2:	98aff0ef          	jal	ra,ffffffffc020264c <page_insert>
            assert(ret == 0);
ffffffffc02034c6:	d915                	beqz	a0,ffffffffc02033fa <copy_range+0x78>
ffffffffc02034c8:	00003697          	auipc	a3,0x3
ffffffffc02034cc:	7b868693          	addi	a3,a3,1976 # ffffffffc0206c80 <default_pmm_manager+0x760>
ffffffffc02034d0:	00003617          	auipc	a2,0x3
ffffffffc02034d4:	ca060613          	addi	a2,a2,-864 # ffffffffc0206170 <commands+0x828>
ffffffffc02034d8:	1b200593          	li	a1,434
ffffffffc02034dc:	00003517          	auipc	a0,0x3
ffffffffc02034e0:	19450513          	addi	a0,a0,404 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02034e4:	fabfc0ef          	jal	ra,ffffffffc020048e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02034e8:	00200637          	lui	a2,0x200
ffffffffc02034ec:	9432                	add	s0,s0,a2
ffffffffc02034ee:	ffe00637          	lui	a2,0xffe00
ffffffffc02034f2:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02034f4:	f00406e3          	beqz	s0,ffffffffc0203400 <copy_range+0x7e>
ffffffffc02034f8:	ef2466e3          	bltu	s0,s2,ffffffffc02033e4 <copy_range+0x62>
ffffffffc02034fc:	b711                	j	ffffffffc0203400 <copy_range+0x7e>
        intr_disable();
ffffffffc02034fe:	cb6fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203502:	000cb703          	ld	a4,0(s9)
ffffffffc0203506:	4505                	li	a0,1
ffffffffc0203508:	6f18                	ld	a4,24(a4)
ffffffffc020350a:	9702                	jalr	a4
ffffffffc020350c:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc020350e:	ca0fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203512:	bfa9                	j	ffffffffc020346c <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203514:	5571                	li	a0,-4
ffffffffc0203516:	b5f5                	j	ffffffffc0203402 <copy_range+0x80>
ffffffffc0203518:	86be                	mv	a3,a5
ffffffffc020351a:	00003617          	auipc	a2,0x3
ffffffffc020351e:	03e60613          	addi	a2,a2,62 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0203522:	07100593          	li	a1,113
ffffffffc0203526:	00003517          	auipc	a0,0x3
ffffffffc020352a:	05a50513          	addi	a0,a0,90 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc020352e:	f61fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203532:	00003697          	auipc	a3,0x3
ffffffffc0203536:	72e68693          	addi	a3,a3,1838 # ffffffffc0206c60 <default_pmm_manager+0x740>
ffffffffc020353a:	00003617          	auipc	a2,0x3
ffffffffc020353e:	c3660613          	addi	a2,a2,-970 # ffffffffc0206170 <commands+0x828>
ffffffffc0203542:	19400593          	li	a1,404
ffffffffc0203546:	00003517          	auipc	a0,0x3
ffffffffc020354a:	12a50513          	addi	a0,a0,298 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020354e:	f41fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203552:	00003697          	auipc	a3,0x3
ffffffffc0203556:	15e68693          	addi	a3,a3,350 # ffffffffc02066b0 <default_pmm_manager+0x190>
ffffffffc020355a:	00003617          	auipc	a2,0x3
ffffffffc020355e:	c1660613          	addi	a2,a2,-1002 # ffffffffc0206170 <commands+0x828>
ffffffffc0203562:	17c00593          	li	a1,380
ffffffffc0203566:	00003517          	auipc	a0,0x3
ffffffffc020356a:	10a50513          	addi	a0,a0,266 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020356e:	f21fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc0203572:	00003697          	auipc	a3,0x3
ffffffffc0203576:	6fe68693          	addi	a3,a3,1790 # ffffffffc0206c70 <default_pmm_manager+0x750>
ffffffffc020357a:	00003617          	auipc	a2,0x3
ffffffffc020357e:	bf660613          	addi	a2,a2,-1034 # ffffffffc0206170 <commands+0x828>
ffffffffc0203582:	19500593          	li	a1,405
ffffffffc0203586:	00003517          	auipc	a0,0x3
ffffffffc020358a:	0ea50513          	addi	a0,a0,234 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc020358e:	f01fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203592:	00003617          	auipc	a2,0x3
ffffffffc0203596:	09660613          	addi	a2,a2,150 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc020359a:	06900593          	li	a1,105
ffffffffc020359e:	00003517          	auipc	a0,0x3
ffffffffc02035a2:	fe250513          	addi	a0,a0,-30 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc02035a6:	ee9fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035aa:	00003617          	auipc	a2,0x3
ffffffffc02035ae:	09e60613          	addi	a2,a2,158 # ffffffffc0206648 <default_pmm_manager+0x128>
ffffffffc02035b2:	07f00593          	li	a1,127
ffffffffc02035b6:	00003517          	auipc	a0,0x3
ffffffffc02035ba:	fca50513          	addi	a0,a0,-54 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc02035be:	ed1fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02035c2:	00003697          	auipc	a3,0x3
ffffffffc02035c6:	0be68693          	addi	a3,a3,190 # ffffffffc0206680 <default_pmm_manager+0x160>
ffffffffc02035ca:	00003617          	auipc	a2,0x3
ffffffffc02035ce:	ba660613          	addi	a2,a2,-1114 # ffffffffc0206170 <commands+0x828>
ffffffffc02035d2:	17b00593          	li	a1,379
ffffffffc02035d6:	00003517          	auipc	a0,0x3
ffffffffc02035da:	09a50513          	addi	a0,a0,154 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02035de:	eb1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02035e2 <pgdir_alloc_page>:
{
ffffffffc02035e2:	7179                	addi	sp,sp,-48
ffffffffc02035e4:	ec26                	sd	s1,24(sp)
ffffffffc02035e6:	e84a                	sd	s2,16(sp)
ffffffffc02035e8:	e052                	sd	s4,0(sp)
ffffffffc02035ea:	f406                	sd	ra,40(sp)
ffffffffc02035ec:	f022                	sd	s0,32(sp)
ffffffffc02035ee:	e44e                	sd	s3,8(sp)
ffffffffc02035f0:	8a2a                	mv	s4,a0
ffffffffc02035f2:	84ae                	mv	s1,a1
ffffffffc02035f4:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02035f6:	100027f3          	csrr	a5,sstatus
ffffffffc02035fa:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02035fc:	000a7997          	auipc	s3,0xa7
ffffffffc0203600:	31c98993          	addi	s3,s3,796 # ffffffffc02aa918 <pmm_manager>
ffffffffc0203604:	ef8d                	bnez	a5,ffffffffc020363e <pgdir_alloc_page+0x5c>
ffffffffc0203606:	0009b783          	ld	a5,0(s3)
ffffffffc020360a:	4505                	li	a0,1
ffffffffc020360c:	6f9c                	ld	a5,24(a5)
ffffffffc020360e:	9782                	jalr	a5
ffffffffc0203610:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203612:	cc09                	beqz	s0,ffffffffc020362c <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203614:	86ca                	mv	a3,s2
ffffffffc0203616:	8626                	mv	a2,s1
ffffffffc0203618:	85a2                	mv	a1,s0
ffffffffc020361a:	8552                	mv	a0,s4
ffffffffc020361c:	830ff0ef          	jal	ra,ffffffffc020264c <page_insert>
ffffffffc0203620:	e915                	bnez	a0,ffffffffc0203654 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203622:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203624:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203626:	4785                	li	a5,1
ffffffffc0203628:	04f71e63          	bne	a4,a5,ffffffffc0203684 <pgdir_alloc_page+0xa2>
}
ffffffffc020362c:	70a2                	ld	ra,40(sp)
ffffffffc020362e:	8522                	mv	a0,s0
ffffffffc0203630:	7402                	ld	s0,32(sp)
ffffffffc0203632:	64e2                	ld	s1,24(sp)
ffffffffc0203634:	6942                	ld	s2,16(sp)
ffffffffc0203636:	69a2                	ld	s3,8(sp)
ffffffffc0203638:	6a02                	ld	s4,0(sp)
ffffffffc020363a:	6145                	addi	sp,sp,48
ffffffffc020363c:	8082                	ret
        intr_disable();
ffffffffc020363e:	b76fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203642:	0009b783          	ld	a5,0(s3)
ffffffffc0203646:	4505                	li	a0,1
ffffffffc0203648:	6f9c                	ld	a5,24(a5)
ffffffffc020364a:	9782                	jalr	a5
ffffffffc020364c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020364e:	b60fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203652:	b7c1                	j	ffffffffc0203612 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203654:	100027f3          	csrr	a5,sstatus
ffffffffc0203658:	8b89                	andi	a5,a5,2
ffffffffc020365a:	eb89                	bnez	a5,ffffffffc020366c <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc020365c:	0009b783          	ld	a5,0(s3)
ffffffffc0203660:	8522                	mv	a0,s0
ffffffffc0203662:	4585                	li	a1,1
ffffffffc0203664:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203666:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203668:	9782                	jalr	a5
    if (flag)
ffffffffc020366a:	b7c9                	j	ffffffffc020362c <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc020366c:	b48fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203670:	0009b783          	ld	a5,0(s3)
ffffffffc0203674:	8522                	mv	a0,s0
ffffffffc0203676:	4585                	li	a1,1
ffffffffc0203678:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020367a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020367c:	9782                	jalr	a5
        intr_enable();
ffffffffc020367e:	b30fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203682:	b76d                	j	ffffffffc020362c <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203684:	00003697          	auipc	a3,0x3
ffffffffc0203688:	60c68693          	addi	a3,a3,1548 # ffffffffc0206c90 <default_pmm_manager+0x770>
ffffffffc020368c:	00003617          	auipc	a2,0x3
ffffffffc0203690:	ae460613          	addi	a2,a2,-1308 # ffffffffc0206170 <commands+0x828>
ffffffffc0203694:	1fb00593          	li	a1,507
ffffffffc0203698:	00003517          	auipc	a0,0x3
ffffffffc020369c:	fd850513          	addi	a0,a0,-40 # ffffffffc0206670 <default_pmm_manager+0x150>
ffffffffc02036a0:	deffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036a4 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036a4:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02036a6:	00003697          	auipc	a3,0x3
ffffffffc02036aa:	60268693          	addi	a3,a3,1538 # ffffffffc0206ca8 <default_pmm_manager+0x788>
ffffffffc02036ae:	00003617          	auipc	a2,0x3
ffffffffc02036b2:	ac260613          	addi	a2,a2,-1342 # ffffffffc0206170 <commands+0x828>
ffffffffc02036b6:	07400593          	li	a1,116
ffffffffc02036ba:	00003517          	auipc	a0,0x3
ffffffffc02036be:	60e50513          	addi	a0,a0,1550 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036c2:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036c4:	dcbfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036c8 <mm_create>:
{
ffffffffc02036c8:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ca:	04000513          	li	a0,64
{
ffffffffc02036ce:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036d0:	df6fe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
    if (mm != NULL)
ffffffffc02036d4:	cd19                	beqz	a0,ffffffffc02036f2 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036d6:	e508                	sd	a0,8(a0)
ffffffffc02036d8:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036da:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02036de:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02036e2:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02036e6:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02036ea:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02036ee:	02053c23          	sd	zero,56(a0)
}
ffffffffc02036f2:	60a2                	ld	ra,8(sp)
ffffffffc02036f4:	0141                	addi	sp,sp,16
ffffffffc02036f6:	8082                	ret

ffffffffc02036f8 <find_vma>:
{
ffffffffc02036f8:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02036fa:	c505                	beqz	a0,ffffffffc0203722 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02036fc:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02036fe:	c501                	beqz	a0,ffffffffc0203706 <find_vma+0xe>
ffffffffc0203700:	651c                	ld	a5,8(a0)
ffffffffc0203702:	02f5f263          	bgeu	a1,a5,ffffffffc0203726 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203706:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0203708:	00f68d63          	beq	a3,a5,ffffffffc0203722 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020370c:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f4ea8>
ffffffffc0203710:	00e5e663          	bltu	a1,a4,ffffffffc020371c <find_vma+0x24>
ffffffffc0203714:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203718:	00e5ec63          	bltu	a1,a4,ffffffffc0203730 <find_vma+0x38>
ffffffffc020371c:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020371e:	fef697e3          	bne	a3,a5,ffffffffc020370c <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203722:	4501                	li	a0,0
}
ffffffffc0203724:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203726:	691c                	ld	a5,16(a0)
ffffffffc0203728:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203706 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020372c:	ea88                	sd	a0,16(a3)
ffffffffc020372e:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203730:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203734:	ea88                	sd	a0,16(a3)
ffffffffc0203736:	8082                	ret

ffffffffc0203738 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203738:	6590                	ld	a2,8(a1)
ffffffffc020373a:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_exit_out_size+0x74ed0>
{
ffffffffc020373e:	1141                	addi	sp,sp,-16
ffffffffc0203740:	e406                	sd	ra,8(sp)
ffffffffc0203742:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203744:	01066763          	bltu	a2,a6,ffffffffc0203752 <insert_vma_struct+0x1a>
ffffffffc0203748:	a085                	j	ffffffffc02037a8 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020374a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020374e:	04e66863          	bltu	a2,a4,ffffffffc020379e <insert_vma_struct+0x66>
ffffffffc0203752:	86be                	mv	a3,a5
ffffffffc0203754:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203756:	fef51ae3          	bne	a0,a5,ffffffffc020374a <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020375a:	02a68463          	beq	a3,a0,ffffffffc0203782 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020375e:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203762:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203766:	08e8f163          	bgeu	a7,a4,ffffffffc02037e8 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020376a:	04e66f63          	bltu	a2,a4,ffffffffc02037c8 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020376e:	00f50a63          	beq	a0,a5,ffffffffc0203782 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203772:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203776:	05076963          	bltu	a4,a6,ffffffffc02037c8 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020377a:	ff07b603          	ld	a2,-16(a5)
ffffffffc020377e:	02c77363          	bgeu	a4,a2,ffffffffc02037a4 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203782:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203784:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203786:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020378a:	e390                	sd	a2,0(a5)
ffffffffc020378c:	e690                	sd	a2,8(a3)
}
ffffffffc020378e:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203790:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203792:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203794:	0017079b          	addiw	a5,a4,1
ffffffffc0203798:	d11c                	sw	a5,32(a0)
}
ffffffffc020379a:	0141                	addi	sp,sp,16
ffffffffc020379c:	8082                	ret
    if (le_prev != list)
ffffffffc020379e:	fca690e3          	bne	a3,a0,ffffffffc020375e <insert_vma_struct+0x26>
ffffffffc02037a2:	bfd1                	j	ffffffffc0203776 <insert_vma_struct+0x3e>
ffffffffc02037a4:	f01ff0ef          	jal	ra,ffffffffc02036a4 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037a8:	00003697          	auipc	a3,0x3
ffffffffc02037ac:	53068693          	addi	a3,a3,1328 # ffffffffc0206cd8 <default_pmm_manager+0x7b8>
ffffffffc02037b0:	00003617          	auipc	a2,0x3
ffffffffc02037b4:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206170 <commands+0x828>
ffffffffc02037b8:	07a00593          	li	a1,122
ffffffffc02037bc:	00003517          	auipc	a0,0x3
ffffffffc02037c0:	50c50513          	addi	a0,a0,1292 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc02037c4:	ccbfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037c8:	00003697          	auipc	a3,0x3
ffffffffc02037cc:	55068693          	addi	a3,a3,1360 # ffffffffc0206d18 <default_pmm_manager+0x7f8>
ffffffffc02037d0:	00003617          	auipc	a2,0x3
ffffffffc02037d4:	9a060613          	addi	a2,a2,-1632 # ffffffffc0206170 <commands+0x828>
ffffffffc02037d8:	07300593          	li	a1,115
ffffffffc02037dc:	00003517          	auipc	a0,0x3
ffffffffc02037e0:	4ec50513          	addi	a0,a0,1260 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc02037e4:	cabfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02037e8:	00003697          	auipc	a3,0x3
ffffffffc02037ec:	51068693          	addi	a3,a3,1296 # ffffffffc0206cf8 <default_pmm_manager+0x7d8>
ffffffffc02037f0:	00003617          	auipc	a2,0x3
ffffffffc02037f4:	98060613          	addi	a2,a2,-1664 # ffffffffc0206170 <commands+0x828>
ffffffffc02037f8:	07200593          	li	a1,114
ffffffffc02037fc:	00003517          	auipc	a0,0x3
ffffffffc0203800:	4cc50513          	addi	a0,a0,1228 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203804:	c8bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203808 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203808:	591c                	lw	a5,48(a0)
{
ffffffffc020380a:	1141                	addi	sp,sp,-16
ffffffffc020380c:	e406                	sd	ra,8(sp)
ffffffffc020380e:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203810:	e78d                	bnez	a5,ffffffffc020383a <mm_destroy+0x32>
ffffffffc0203812:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203814:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203816:	00a40c63          	beq	s0,a0,ffffffffc020382e <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc020381a:	6118                	ld	a4,0(a0)
ffffffffc020381c:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020381e:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203820:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203822:	e398                	sd	a4,0(a5)
ffffffffc0203824:	d52fe0ef          	jal	ra,ffffffffc0201d76 <kfree>
    return listelm->next;
ffffffffc0203828:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020382a:	fea418e3          	bne	s0,a0,ffffffffc020381a <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc020382e:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203830:	6402                	ld	s0,0(sp)
ffffffffc0203832:	60a2                	ld	ra,8(sp)
ffffffffc0203834:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203836:	d40fe06f          	j	ffffffffc0201d76 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020383a:	00003697          	auipc	a3,0x3
ffffffffc020383e:	4fe68693          	addi	a3,a3,1278 # ffffffffc0206d38 <default_pmm_manager+0x818>
ffffffffc0203842:	00003617          	auipc	a2,0x3
ffffffffc0203846:	92e60613          	addi	a2,a2,-1746 # ffffffffc0206170 <commands+0x828>
ffffffffc020384a:	09e00593          	li	a1,158
ffffffffc020384e:	00003517          	auipc	a0,0x3
ffffffffc0203852:	47a50513          	addi	a0,a0,1146 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203856:	c39fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020385a <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020385a:	7139                	addi	sp,sp,-64
ffffffffc020385c:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020385e:	6405                	lui	s0,0x1
ffffffffc0203860:	147d                	addi	s0,s0,-1
ffffffffc0203862:	77fd                	lui	a5,0xfffff
ffffffffc0203864:	9622                	add	a2,a2,s0
ffffffffc0203866:	962e                	add	a2,a2,a1
{
ffffffffc0203868:	f426                	sd	s1,40(sp)
ffffffffc020386a:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020386c:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203870:	f04a                	sd	s2,32(sp)
ffffffffc0203872:	ec4e                	sd	s3,24(sp)
ffffffffc0203874:	e852                	sd	s4,16(sp)
ffffffffc0203876:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203878:	002005b7          	lui	a1,0x200
ffffffffc020387c:	00f67433          	and	s0,a2,a5
ffffffffc0203880:	06b4e363          	bltu	s1,a1,ffffffffc02038e6 <mm_map+0x8c>
ffffffffc0203884:	0684f163          	bgeu	s1,s0,ffffffffc02038e6 <mm_map+0x8c>
ffffffffc0203888:	4785                	li	a5,1
ffffffffc020388a:	07fe                	slli	a5,a5,0x1f
ffffffffc020388c:	0487ed63          	bltu	a5,s0,ffffffffc02038e6 <mm_map+0x8c>
ffffffffc0203890:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203892:	cd21                	beqz	a0,ffffffffc02038ea <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203894:	85a6                	mv	a1,s1
ffffffffc0203896:	8ab6                	mv	s5,a3
ffffffffc0203898:	8a3a                	mv	s4,a4
ffffffffc020389a:	e5fff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
ffffffffc020389e:	c501                	beqz	a0,ffffffffc02038a6 <mm_map+0x4c>
ffffffffc02038a0:	651c                	ld	a5,8(a0)
ffffffffc02038a2:	0487e263          	bltu	a5,s0,ffffffffc02038e6 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038a6:	03000513          	li	a0,48
ffffffffc02038aa:	c1cfe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
ffffffffc02038ae:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02038b0:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02038b2:	02090163          	beqz	s2,ffffffffc02038d4 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02038b6:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02038b8:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02038bc:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02038c0:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02038c4:	85ca                	mv	a1,s2
ffffffffc02038c6:	e73ff0ef          	jal	ra,ffffffffc0203738 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02038ca:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02038cc:	000a0463          	beqz	s4,ffffffffc02038d4 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02038d0:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc8>

out:
    return ret;
}
ffffffffc02038d4:	70e2                	ld	ra,56(sp)
ffffffffc02038d6:	7442                	ld	s0,48(sp)
ffffffffc02038d8:	74a2                	ld	s1,40(sp)
ffffffffc02038da:	7902                	ld	s2,32(sp)
ffffffffc02038dc:	69e2                	ld	s3,24(sp)
ffffffffc02038de:	6a42                	ld	s4,16(sp)
ffffffffc02038e0:	6aa2                	ld	s5,8(sp)
ffffffffc02038e2:	6121                	addi	sp,sp,64
ffffffffc02038e4:	8082                	ret
        return -E_INVAL;
ffffffffc02038e6:	5575                	li	a0,-3
ffffffffc02038e8:	b7f5                	j	ffffffffc02038d4 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02038ea:	00003697          	auipc	a3,0x3
ffffffffc02038ee:	46668693          	addi	a3,a3,1126 # ffffffffc0206d50 <default_pmm_manager+0x830>
ffffffffc02038f2:	00003617          	auipc	a2,0x3
ffffffffc02038f6:	87e60613          	addi	a2,a2,-1922 # ffffffffc0206170 <commands+0x828>
ffffffffc02038fa:	0b300593          	li	a1,179
ffffffffc02038fe:	00003517          	auipc	a0,0x3
ffffffffc0203902:	3ca50513          	addi	a0,a0,970 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203906:	b89fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020390a <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc020390a:	7139                	addi	sp,sp,-64
ffffffffc020390c:	fc06                	sd	ra,56(sp)
ffffffffc020390e:	f822                	sd	s0,48(sp)
ffffffffc0203910:	f426                	sd	s1,40(sp)
ffffffffc0203912:	f04a                	sd	s2,32(sp)
ffffffffc0203914:	ec4e                	sd	s3,24(sp)
ffffffffc0203916:	e852                	sd	s4,16(sp)
ffffffffc0203918:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc020391a:	c52d                	beqz	a0,ffffffffc0203984 <dup_mmap+0x7a>
ffffffffc020391c:	892a                	mv	s2,a0
ffffffffc020391e:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203920:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203922:	e595                	bnez	a1,ffffffffc020394e <dup_mmap+0x44>
ffffffffc0203924:	a085                	j	ffffffffc0203984 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203926:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203928:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ec8>
        vma->vm_end = vm_end;
ffffffffc020392c:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203930:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203934:	e05ff0ef          	jal	ra,ffffffffc0203738 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203938:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bd8>
ffffffffc020393c:	fe843603          	ld	a2,-24(s0)
ffffffffc0203940:	6c8c                	ld	a1,24(s1)
ffffffffc0203942:	01893503          	ld	a0,24(s2)
ffffffffc0203946:	4701                	li	a4,0
ffffffffc0203948:	a3bff0ef          	jal	ra,ffffffffc0203382 <copy_range>
ffffffffc020394c:	e105                	bnez	a0,ffffffffc020396c <dup_mmap+0x62>
    return listelm->prev;
ffffffffc020394e:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203950:	02848863          	beq	s1,s0,ffffffffc0203980 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203954:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203958:	fe843a83          	ld	s5,-24(s0)
ffffffffc020395c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203960:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203964:	b62fe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
ffffffffc0203968:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020396a:	fd55                	bnez	a0,ffffffffc0203926 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc020396c:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc020396e:	70e2                	ld	ra,56(sp)
ffffffffc0203970:	7442                	ld	s0,48(sp)
ffffffffc0203972:	74a2                	ld	s1,40(sp)
ffffffffc0203974:	7902                	ld	s2,32(sp)
ffffffffc0203976:	69e2                	ld	s3,24(sp)
ffffffffc0203978:	6a42                	ld	s4,16(sp)
ffffffffc020397a:	6aa2                	ld	s5,8(sp)
ffffffffc020397c:	6121                	addi	sp,sp,64
ffffffffc020397e:	8082                	ret
    return 0;
ffffffffc0203980:	4501                	li	a0,0
ffffffffc0203982:	b7f5                	j	ffffffffc020396e <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203984:	00003697          	auipc	a3,0x3
ffffffffc0203988:	3dc68693          	addi	a3,a3,988 # ffffffffc0206d60 <default_pmm_manager+0x840>
ffffffffc020398c:	00002617          	auipc	a2,0x2
ffffffffc0203990:	7e460613          	addi	a2,a2,2020 # ffffffffc0206170 <commands+0x828>
ffffffffc0203994:	0cf00593          	li	a1,207
ffffffffc0203998:	00003517          	auipc	a0,0x3
ffffffffc020399c:	33050513          	addi	a0,a0,816 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc02039a0:	aeffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039a4 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02039a4:	1101                	addi	sp,sp,-32
ffffffffc02039a6:	ec06                	sd	ra,24(sp)
ffffffffc02039a8:	e822                	sd	s0,16(sp)
ffffffffc02039aa:	e426                	sd	s1,8(sp)
ffffffffc02039ac:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039ae:	c531                	beqz	a0,ffffffffc02039fa <exit_mmap+0x56>
ffffffffc02039b0:	591c                	lw	a5,48(a0)
ffffffffc02039b2:	84aa                	mv	s1,a0
ffffffffc02039b4:	e3b9                	bnez	a5,ffffffffc02039fa <exit_mmap+0x56>
    return listelm->next;
ffffffffc02039b6:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02039b8:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039bc:	02850663          	beq	a0,s0,ffffffffc02039e8 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039c0:	ff043603          	ld	a2,-16(s0)
ffffffffc02039c4:	fe843583          	ld	a1,-24(s0)
ffffffffc02039c8:	854a                	mv	a0,s2
ffffffffc02039ca:	80ffe0ef          	jal	ra,ffffffffc02021d8 <unmap_range>
ffffffffc02039ce:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039d0:	fe8498e3          	bne	s1,s0,ffffffffc02039c0 <exit_mmap+0x1c>
ffffffffc02039d4:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039d6:	00848c63          	beq	s1,s0,ffffffffc02039ee <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039da:	ff043603          	ld	a2,-16(s0)
ffffffffc02039de:	fe843583          	ld	a1,-24(s0)
ffffffffc02039e2:	854a                	mv	a0,s2
ffffffffc02039e4:	93bfe0ef          	jal	ra,ffffffffc020231e <exit_range>
ffffffffc02039e8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039ea:	fe8498e3          	bne	s1,s0,ffffffffc02039da <exit_mmap+0x36>
    }
}
ffffffffc02039ee:	60e2                	ld	ra,24(sp)
ffffffffc02039f0:	6442                	ld	s0,16(sp)
ffffffffc02039f2:	64a2                	ld	s1,8(sp)
ffffffffc02039f4:	6902                	ld	s2,0(sp)
ffffffffc02039f6:	6105                	addi	sp,sp,32
ffffffffc02039f8:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039fa:	00003697          	auipc	a3,0x3
ffffffffc02039fe:	38668693          	addi	a3,a3,902 # ffffffffc0206d80 <default_pmm_manager+0x860>
ffffffffc0203a02:	00002617          	auipc	a2,0x2
ffffffffc0203a06:	76e60613          	addi	a2,a2,1902 # ffffffffc0206170 <commands+0x828>
ffffffffc0203a0a:	0e800593          	li	a1,232
ffffffffc0203a0e:	00003517          	auipc	a0,0x3
ffffffffc0203a12:	2ba50513          	addi	a0,a0,698 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203a16:	a79fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a1a <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203a1a:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a1c:	04000513          	li	a0,64
{
ffffffffc0203a20:	fc06                	sd	ra,56(sp)
ffffffffc0203a22:	f822                	sd	s0,48(sp)
ffffffffc0203a24:	f426                	sd	s1,40(sp)
ffffffffc0203a26:	f04a                	sd	s2,32(sp)
ffffffffc0203a28:	ec4e                	sd	s3,24(sp)
ffffffffc0203a2a:	e852                	sd	s4,16(sp)
ffffffffc0203a2c:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a2e:	a98fe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
    if (mm != NULL)
ffffffffc0203a32:	2e050663          	beqz	a0,ffffffffc0203d1e <vmm_init+0x304>
ffffffffc0203a36:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203a38:	e508                	sd	a0,8(a0)
ffffffffc0203a3a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a3c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a40:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a44:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a48:	02053423          	sd	zero,40(a0)
ffffffffc0203a4c:	02052823          	sw	zero,48(a0)
ffffffffc0203a50:	02053c23          	sd	zero,56(a0)
ffffffffc0203a54:	03200413          	li	s0,50
ffffffffc0203a58:	a811                	j	ffffffffc0203a6c <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203a5a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a5c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a5e:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a62:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a64:	8526                	mv	a0,s1
ffffffffc0203a66:	cd3ff0ef          	jal	ra,ffffffffc0203738 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a6a:	c80d                	beqz	s0,ffffffffc0203a9c <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a6c:	03000513          	li	a0,48
ffffffffc0203a70:	a56fe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
ffffffffc0203a74:	85aa                	mv	a1,a0
ffffffffc0203a76:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a7a:	f165                	bnez	a0,ffffffffc0203a5a <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203a7c:	00003697          	auipc	a3,0x3
ffffffffc0203a80:	49c68693          	addi	a3,a3,1180 # ffffffffc0206f18 <default_pmm_manager+0x9f8>
ffffffffc0203a84:	00002617          	auipc	a2,0x2
ffffffffc0203a88:	6ec60613          	addi	a2,a2,1772 # ffffffffc0206170 <commands+0x828>
ffffffffc0203a8c:	12c00593          	li	a1,300
ffffffffc0203a90:	00003517          	auipc	a0,0x3
ffffffffc0203a94:	23850513          	addi	a0,a0,568 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203a98:	9f7fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203a9c:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aa0:	1f900913          	li	s2,505
ffffffffc0203aa4:	a819                	j	ffffffffc0203aba <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203aa6:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203aa8:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203aaa:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203aae:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203ab0:	8526                	mv	a0,s1
ffffffffc0203ab2:	c87ff0ef          	jal	ra,ffffffffc0203738 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ab6:	03240a63          	beq	s0,s2,ffffffffc0203aea <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203aba:	03000513          	li	a0,48
ffffffffc0203abe:	a08fe0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
ffffffffc0203ac2:	85aa                	mv	a1,a0
ffffffffc0203ac4:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203ac8:	fd79                	bnez	a0,ffffffffc0203aa6 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203aca:	00003697          	auipc	a3,0x3
ffffffffc0203ace:	44e68693          	addi	a3,a3,1102 # ffffffffc0206f18 <default_pmm_manager+0x9f8>
ffffffffc0203ad2:	00002617          	auipc	a2,0x2
ffffffffc0203ad6:	69e60613          	addi	a2,a2,1694 # ffffffffc0206170 <commands+0x828>
ffffffffc0203ada:	13300593          	li	a1,307
ffffffffc0203ade:	00003517          	auipc	a0,0x3
ffffffffc0203ae2:	1ea50513          	addi	a0,a0,490 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203ae6:	9a9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203aea:	649c                	ld	a5,8(s1)
ffffffffc0203aec:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203aee:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203af2:	16f48663          	beq	s1,a5,ffffffffc0203c5e <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203af6:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd546a4>
ffffffffc0203afa:	ffe70693          	addi	a3,a4,-2
ffffffffc0203afe:	10d61063          	bne	a2,a3,ffffffffc0203bfe <vmm_init+0x1e4>
ffffffffc0203b02:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b06:	0ed71c63          	bne	a4,a3,ffffffffc0203bfe <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203b0a:	0715                	addi	a4,a4,5
ffffffffc0203b0c:	679c                	ld	a5,8(a5)
ffffffffc0203b0e:	feb712e3          	bne	a4,a1,ffffffffc0203af2 <vmm_init+0xd8>
ffffffffc0203b12:	4a1d                	li	s4,7
ffffffffc0203b14:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b16:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b1a:	85a2                	mv	a1,s0
ffffffffc0203b1c:	8526                	mv	a0,s1
ffffffffc0203b1e:	bdbff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
ffffffffc0203b22:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b24:	16050d63          	beqz	a0,ffffffffc0203c9e <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b28:	00140593          	addi	a1,s0,1
ffffffffc0203b2c:	8526                	mv	a0,s1
ffffffffc0203b2e:	bcbff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
ffffffffc0203b32:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b34:	14050563          	beqz	a0,ffffffffc0203c7e <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203b38:	85d2                	mv	a1,s4
ffffffffc0203b3a:	8526                	mv	a0,s1
ffffffffc0203b3c:	bbdff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b40:	16051f63          	bnez	a0,ffffffffc0203cbe <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b44:	00340593          	addi	a1,s0,3
ffffffffc0203b48:	8526                	mv	a0,s1
ffffffffc0203b4a:	bafff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b4e:	1a051863          	bnez	a0,ffffffffc0203cfe <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b52:	00440593          	addi	a1,s0,4
ffffffffc0203b56:	8526                	mv	a0,s1
ffffffffc0203b58:	ba1ff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b5c:	18051163          	bnez	a0,ffffffffc0203cde <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b60:	00893783          	ld	a5,8(s2)
ffffffffc0203b64:	0a879d63          	bne	a5,s0,ffffffffc0203c1e <vmm_init+0x204>
ffffffffc0203b68:	01093783          	ld	a5,16(s2)
ffffffffc0203b6c:	0b479963          	bne	a5,s4,ffffffffc0203c1e <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b70:	0089b783          	ld	a5,8(s3)
ffffffffc0203b74:	0c879563          	bne	a5,s0,ffffffffc0203c3e <vmm_init+0x224>
ffffffffc0203b78:	0109b783          	ld	a5,16(s3)
ffffffffc0203b7c:	0d479163          	bne	a5,s4,ffffffffc0203c3e <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b80:	0415                	addi	s0,s0,5
ffffffffc0203b82:	0a15                	addi	s4,s4,5
ffffffffc0203b84:	f9541be3          	bne	s0,s5,ffffffffc0203b1a <vmm_init+0x100>
ffffffffc0203b88:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203b8a:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203b8c:	85a2                	mv	a1,s0
ffffffffc0203b8e:	8526                	mv	a0,s1
ffffffffc0203b90:	b69ff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
ffffffffc0203b94:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203b98:	c90d                	beqz	a0,ffffffffc0203bca <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203b9a:	6914                	ld	a3,16(a0)
ffffffffc0203b9c:	6510                	ld	a2,8(a0)
ffffffffc0203b9e:	00003517          	auipc	a0,0x3
ffffffffc0203ba2:	30250513          	addi	a0,a0,770 # ffffffffc0206ea0 <default_pmm_manager+0x980>
ffffffffc0203ba6:	deefc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203baa:	00003697          	auipc	a3,0x3
ffffffffc0203bae:	31e68693          	addi	a3,a3,798 # ffffffffc0206ec8 <default_pmm_manager+0x9a8>
ffffffffc0203bb2:	00002617          	auipc	a2,0x2
ffffffffc0203bb6:	5be60613          	addi	a2,a2,1470 # ffffffffc0206170 <commands+0x828>
ffffffffc0203bba:	15900593          	li	a1,345
ffffffffc0203bbe:	00003517          	auipc	a0,0x3
ffffffffc0203bc2:	10a50513          	addi	a0,a0,266 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203bc6:	8c9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203bca:	147d                	addi	s0,s0,-1
ffffffffc0203bcc:	fd2410e3          	bne	s0,s2,ffffffffc0203b8c <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203bd0:	8526                	mv	a0,s1
ffffffffc0203bd2:	c37ff0ef          	jal	ra,ffffffffc0203808 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203bd6:	00003517          	auipc	a0,0x3
ffffffffc0203bda:	30a50513          	addi	a0,a0,778 # ffffffffc0206ee0 <default_pmm_manager+0x9c0>
ffffffffc0203bde:	db6fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203be2:	7442                	ld	s0,48(sp)
ffffffffc0203be4:	70e2                	ld	ra,56(sp)
ffffffffc0203be6:	74a2                	ld	s1,40(sp)
ffffffffc0203be8:	7902                	ld	s2,32(sp)
ffffffffc0203bea:	69e2                	ld	s3,24(sp)
ffffffffc0203bec:	6a42                	ld	s4,16(sp)
ffffffffc0203bee:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bf0:	00003517          	auipc	a0,0x3
ffffffffc0203bf4:	31050513          	addi	a0,a0,784 # ffffffffc0206f00 <default_pmm_manager+0x9e0>
}
ffffffffc0203bf8:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203bfa:	d9afc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203bfe:	00003697          	auipc	a3,0x3
ffffffffc0203c02:	1ba68693          	addi	a3,a3,442 # ffffffffc0206db8 <default_pmm_manager+0x898>
ffffffffc0203c06:	00002617          	auipc	a2,0x2
ffffffffc0203c0a:	56a60613          	addi	a2,a2,1386 # ffffffffc0206170 <commands+0x828>
ffffffffc0203c0e:	13d00593          	li	a1,317
ffffffffc0203c12:	00003517          	auipc	a0,0x3
ffffffffc0203c16:	0b650513          	addi	a0,a0,182 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203c1a:	875fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c1e:	00003697          	auipc	a3,0x3
ffffffffc0203c22:	22268693          	addi	a3,a3,546 # ffffffffc0206e40 <default_pmm_manager+0x920>
ffffffffc0203c26:	00002617          	auipc	a2,0x2
ffffffffc0203c2a:	54a60613          	addi	a2,a2,1354 # ffffffffc0206170 <commands+0x828>
ffffffffc0203c2e:	14e00593          	li	a1,334
ffffffffc0203c32:	00003517          	auipc	a0,0x3
ffffffffc0203c36:	09650513          	addi	a0,a0,150 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203c3a:	855fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c3e:	00003697          	auipc	a3,0x3
ffffffffc0203c42:	23268693          	addi	a3,a3,562 # ffffffffc0206e70 <default_pmm_manager+0x950>
ffffffffc0203c46:	00002617          	auipc	a2,0x2
ffffffffc0203c4a:	52a60613          	addi	a2,a2,1322 # ffffffffc0206170 <commands+0x828>
ffffffffc0203c4e:	14f00593          	li	a1,335
ffffffffc0203c52:	00003517          	auipc	a0,0x3
ffffffffc0203c56:	07650513          	addi	a0,a0,118 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203c5a:	835fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c5e:	00003697          	auipc	a3,0x3
ffffffffc0203c62:	14268693          	addi	a3,a3,322 # ffffffffc0206da0 <default_pmm_manager+0x880>
ffffffffc0203c66:	00002617          	auipc	a2,0x2
ffffffffc0203c6a:	50a60613          	addi	a2,a2,1290 # ffffffffc0206170 <commands+0x828>
ffffffffc0203c6e:	13b00593          	li	a1,315
ffffffffc0203c72:	00003517          	auipc	a0,0x3
ffffffffc0203c76:	05650513          	addi	a0,a0,86 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203c7a:	815fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203c7e:	00003697          	auipc	a3,0x3
ffffffffc0203c82:	18268693          	addi	a3,a3,386 # ffffffffc0206e00 <default_pmm_manager+0x8e0>
ffffffffc0203c86:	00002617          	auipc	a2,0x2
ffffffffc0203c8a:	4ea60613          	addi	a2,a2,1258 # ffffffffc0206170 <commands+0x828>
ffffffffc0203c8e:	14600593          	li	a1,326
ffffffffc0203c92:	00003517          	auipc	a0,0x3
ffffffffc0203c96:	03650513          	addi	a0,a0,54 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203c9a:	ff4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203c9e:	00003697          	auipc	a3,0x3
ffffffffc0203ca2:	15268693          	addi	a3,a3,338 # ffffffffc0206df0 <default_pmm_manager+0x8d0>
ffffffffc0203ca6:	00002617          	auipc	a2,0x2
ffffffffc0203caa:	4ca60613          	addi	a2,a2,1226 # ffffffffc0206170 <commands+0x828>
ffffffffc0203cae:	14400593          	li	a1,324
ffffffffc0203cb2:	00003517          	auipc	a0,0x3
ffffffffc0203cb6:	01650513          	addi	a0,a0,22 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203cba:	fd4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203cbe:	00003697          	auipc	a3,0x3
ffffffffc0203cc2:	15268693          	addi	a3,a3,338 # ffffffffc0206e10 <default_pmm_manager+0x8f0>
ffffffffc0203cc6:	00002617          	auipc	a2,0x2
ffffffffc0203cca:	4aa60613          	addi	a2,a2,1194 # ffffffffc0206170 <commands+0x828>
ffffffffc0203cce:	14800593          	li	a1,328
ffffffffc0203cd2:	00003517          	auipc	a0,0x3
ffffffffc0203cd6:	ff650513          	addi	a0,a0,-10 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203cda:	fb4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203cde:	00003697          	auipc	a3,0x3
ffffffffc0203ce2:	15268693          	addi	a3,a3,338 # ffffffffc0206e30 <default_pmm_manager+0x910>
ffffffffc0203ce6:	00002617          	auipc	a2,0x2
ffffffffc0203cea:	48a60613          	addi	a2,a2,1162 # ffffffffc0206170 <commands+0x828>
ffffffffc0203cee:	14c00593          	li	a1,332
ffffffffc0203cf2:	00003517          	auipc	a0,0x3
ffffffffc0203cf6:	fd650513          	addi	a0,a0,-42 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203cfa:	f94fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203cfe:	00003697          	auipc	a3,0x3
ffffffffc0203d02:	12268693          	addi	a3,a3,290 # ffffffffc0206e20 <default_pmm_manager+0x900>
ffffffffc0203d06:	00002617          	auipc	a2,0x2
ffffffffc0203d0a:	46a60613          	addi	a2,a2,1130 # ffffffffc0206170 <commands+0x828>
ffffffffc0203d0e:	14a00593          	li	a1,330
ffffffffc0203d12:	00003517          	auipc	a0,0x3
ffffffffc0203d16:	fb650513          	addi	a0,a0,-74 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203d1a:	f74fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203d1e:	00003697          	auipc	a3,0x3
ffffffffc0203d22:	03268693          	addi	a3,a3,50 # ffffffffc0206d50 <default_pmm_manager+0x830>
ffffffffc0203d26:	00002617          	auipc	a2,0x2
ffffffffc0203d2a:	44a60613          	addi	a2,a2,1098 # ffffffffc0206170 <commands+0x828>
ffffffffc0203d2e:	12400593          	li	a1,292
ffffffffc0203d32:	00003517          	auipc	a0,0x3
ffffffffc0203d36:	f9650513          	addi	a0,a0,-106 # ffffffffc0206cc8 <default_pmm_manager+0x7a8>
ffffffffc0203d3a:	f54fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d3e <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d3e:	7179                	addi	sp,sp,-48
ffffffffc0203d40:	f022                	sd	s0,32(sp)
ffffffffc0203d42:	f406                	sd	ra,40(sp)
ffffffffc0203d44:	ec26                	sd	s1,24(sp)
ffffffffc0203d46:	e84a                	sd	s2,16(sp)
ffffffffc0203d48:	e44e                	sd	s3,8(sp)
ffffffffc0203d4a:	e052                	sd	s4,0(sp)
ffffffffc0203d4c:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d4e:	c135                	beqz	a0,ffffffffc0203db2 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d50:	002007b7          	lui	a5,0x200
ffffffffc0203d54:	04f5e663          	bltu	a1,a5,ffffffffc0203da0 <user_mem_check+0x62>
ffffffffc0203d58:	00c584b3          	add	s1,a1,a2
ffffffffc0203d5c:	0495f263          	bgeu	a1,s1,ffffffffc0203da0 <user_mem_check+0x62>
ffffffffc0203d60:	4785                	li	a5,1
ffffffffc0203d62:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d64:	0297ee63          	bltu	a5,s1,ffffffffc0203da0 <user_mem_check+0x62>
ffffffffc0203d68:	892a                	mv	s2,a0
ffffffffc0203d6a:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d6c:	6a05                	lui	s4,0x1
ffffffffc0203d6e:	a821                	j	ffffffffc0203d86 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d70:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d74:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d76:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d78:	c685                	beqz	a3,ffffffffc0203da0 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d7a:	c399                	beqz	a5,ffffffffc0203d80 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d7c:	02e46263          	bltu	s0,a4,ffffffffc0203da0 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203d80:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203d82:	04947663          	bgeu	s0,s1,ffffffffc0203dce <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203d86:	85a2                	mv	a1,s0
ffffffffc0203d88:	854a                	mv	a0,s2
ffffffffc0203d8a:	96fff0ef          	jal	ra,ffffffffc02036f8 <find_vma>
ffffffffc0203d8e:	c909                	beqz	a0,ffffffffc0203da0 <user_mem_check+0x62>
ffffffffc0203d90:	6518                	ld	a4,8(a0)
ffffffffc0203d92:	00e46763          	bltu	s0,a4,ffffffffc0203da0 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d96:	4d1c                	lw	a5,24(a0)
ffffffffc0203d98:	fc099ce3          	bnez	s3,ffffffffc0203d70 <user_mem_check+0x32>
ffffffffc0203d9c:	8b85                	andi	a5,a5,1
ffffffffc0203d9e:	f3ed                	bnez	a5,ffffffffc0203d80 <user_mem_check+0x42>
            return 0;
ffffffffc0203da0:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203da2:	70a2                	ld	ra,40(sp)
ffffffffc0203da4:	7402                	ld	s0,32(sp)
ffffffffc0203da6:	64e2                	ld	s1,24(sp)
ffffffffc0203da8:	6942                	ld	s2,16(sp)
ffffffffc0203daa:	69a2                	ld	s3,8(sp)
ffffffffc0203dac:	6a02                	ld	s4,0(sp)
ffffffffc0203dae:	6145                	addi	sp,sp,48
ffffffffc0203db0:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203db2:	c02007b7          	lui	a5,0xc0200
ffffffffc0203db6:	4501                	li	a0,0
ffffffffc0203db8:	fef5e5e3          	bltu	a1,a5,ffffffffc0203da2 <user_mem_check+0x64>
ffffffffc0203dbc:	962e                	add	a2,a2,a1
ffffffffc0203dbe:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203da2 <user_mem_check+0x64>
ffffffffc0203dc2:	c8000537          	lui	a0,0xc8000
ffffffffc0203dc6:	0505                	addi	a0,a0,1
ffffffffc0203dc8:	00a63533          	sltu	a0,a2,a0
ffffffffc0203dcc:	bfd9                	j	ffffffffc0203da2 <user_mem_check+0x64>
        return 1;
ffffffffc0203dce:	4505                	li	a0,1
ffffffffc0203dd0:	bfc9                	j	ffffffffc0203da2 <user_mem_check+0x64>

ffffffffc0203dd2 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203dd2:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203dd4:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dd6:	60e000ef          	jal	ra,ffffffffc02043e4 <do_exit>

ffffffffc0203dda <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203dda:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203ddc:	10800513          	li	a0,264
{
ffffffffc0203de0:	e022                	sd	s0,0(sp)
ffffffffc0203de2:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203de4:	ee3fd0ef          	jal	ra,ffffffffc0201cc6 <kmalloc>
ffffffffc0203de8:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203dea:	c525                	beqz	a0,ffffffffc0203e52 <alloc_proc+0x78>
    {
        proc->state = PROC_UNINIT;
ffffffffc0203dec:	57fd                	li	a5,-1
ffffffffc0203dee:	1782                	slli	a5,a5,0x20
ffffffffc0203df0:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203df2:	07000613          	li	a2,112
ffffffffc0203df6:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203df8:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d556c4>
        proc->kstack = 0;
ffffffffc0203dfc:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203e00:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203e04:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203e08:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e0c:	03050513          	addi	a0,a0,48
ffffffffc0203e10:	0a1010ef          	jal	ra,ffffffffc02056b0 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203e14:	000a7797          	auipc	a5,0xa7
ffffffffc0203e18:	ae47b783          	ld	a5,-1308(a5) # ffffffffc02aa8f8 <boot_pgdir_pa>
ffffffffc0203e1c:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203e1e:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203e22:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203e26:	4641                	li	a2,16
ffffffffc0203e28:	4581                	li	a1,0
ffffffffc0203e2a:	0b440513          	addi	a0,s0,180
ffffffffc0203e2e:	083010ef          	jal	ra,ffffffffc02056b0 <memset>
        list_init(&(proc->list_link));
ffffffffc0203e32:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203e36:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc0203e3a:	e878                	sd	a4,208(s0)
ffffffffc0203e3c:	e478                	sd	a4,200(s0)
ffffffffc0203e3e:	f07c                	sd	a5,224(s0)
ffffffffc0203e40:	ec7c                	sd	a5,216(s0)
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
ffffffffc0203e42:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0203e46:	10043023          	sd	zero,256(s0)
ffffffffc0203e4a:	0e043c23          	sd	zero,248(s0)
ffffffffc0203e4e:	0e043823          	sd	zero,240(s0)
    }
    return proc;
}
ffffffffc0203e52:	60a2                	ld	ra,8(sp)
ffffffffc0203e54:	8522                	mv	a0,s0
ffffffffc0203e56:	6402                	ld	s0,0(sp)
ffffffffc0203e58:	0141                	addi	sp,sp,16
ffffffffc0203e5a:	8082                	ret

ffffffffc0203e5c <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e5c:	000a7797          	auipc	a5,0xa7
ffffffffc0203e60:	acc7b783          	ld	a5,-1332(a5) # ffffffffc02aa928 <current>
ffffffffc0203e64:	73c8                	ld	a0,160(a5)
ffffffffc0203e66:	8d4fd06f          	j	ffffffffc0200f3a <forkrets>

ffffffffc0203e6a <user_main>:
static int
user_main(void *arg)
{
#ifdef TEST
    // 测试模式：执行通过TEST、TESTSTART、TESTSIZE指定的程序
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e6a:	000a7797          	auipc	a5,0xa7
ffffffffc0203e6e:	abe7b783          	ld	a5,-1346(a5) # ffffffffc02aa928 <current>
ffffffffc0203e72:	43cc                	lw	a1,4(a5)
{
ffffffffc0203e74:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e76:	00003617          	auipc	a2,0x3
ffffffffc0203e7a:	0b260613          	addi	a2,a2,178 # ffffffffc0206f28 <default_pmm_manager+0xa08>
ffffffffc0203e7e:	00003517          	auipc	a0,0x3
ffffffffc0203e82:	0b250513          	addi	a0,a0,178 # ffffffffc0206f30 <default_pmm_manager+0xa10>
{
ffffffffc0203e86:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203e88:	b0cfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203e8c:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0203e90:	0ec78793          	addi	a5,a5,236 # 9f78 <_binary_obj___user_yield_out_size>
ffffffffc0203e94:	e43e                	sd	a5,8(sp)
ffffffffc0203e96:	00003517          	auipc	a0,0x3
ffffffffc0203e9a:	09250513          	addi	a0,a0,146 # ffffffffc0206f28 <default_pmm_manager+0xa08>
ffffffffc0203e9e:	00098797          	auipc	a5,0x98
ffffffffc0203ea2:	66278793          	addi	a5,a5,1634 # ffffffffc029c500 <_binary_obj___user_yield_out_start>
ffffffffc0203ea6:	f03e                	sd	a5,32(sp)
ffffffffc0203ea8:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203eaa:	e802                	sd	zero,16(sp)
ffffffffc0203eac:	762010ef          	jal	ra,ffffffffc020560e <strlen>
ffffffffc0203eb0:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203eb2:	4511                	li	a0,4
ffffffffc0203eb4:	55a2                	lw	a1,40(sp)
ffffffffc0203eb6:	4662                	lw	a2,24(sp)
ffffffffc0203eb8:	5682                	lw	a3,32(sp)
ffffffffc0203eba:	4722                	lw	a4,8(sp)
ffffffffc0203ebc:	48a9                	li	a7,10
ffffffffc0203ebe:	9002                	ebreak
ffffffffc0203ec0:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203ec2:	65c2                	ld	a1,16(sp)
ffffffffc0203ec4:	00003517          	auipc	a0,0x3
ffffffffc0203ec8:	09450513          	addi	a0,a0,148 # ffffffffc0206f58 <default_pmm_manager+0xa38>
ffffffffc0203ecc:	ac8fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
    // 默认模式：执行exit用户程序
    KERNEL_EXECVE(exit);
#endif
    // 如果execve返回，说明执行失败
    panic("user_main execve failed.\n");
ffffffffc0203ed0:	00003617          	auipc	a2,0x3
ffffffffc0203ed4:	09860613          	addi	a2,a2,152 # ffffffffc0206f68 <default_pmm_manager+0xa48>
ffffffffc0203ed8:	3de00593          	li	a1,990
ffffffffc0203edc:	00003517          	auipc	a0,0x3
ffffffffc0203ee0:	0ac50513          	addi	a0,a0,172 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0203ee4:	daafc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203ee8 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203ee8:	6d14                	ld	a3,24(a0)
{
ffffffffc0203eea:	1141                	addi	sp,sp,-16
ffffffffc0203eec:	e406                	sd	ra,8(sp)
ffffffffc0203eee:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ef2:	02f6ee63          	bltu	a3,a5,ffffffffc0203f2e <put_pgdir+0x46>
ffffffffc0203ef6:	000a7517          	auipc	a0,0xa7
ffffffffc0203efa:	a2a53503          	ld	a0,-1494(a0) # ffffffffc02aa920 <va_pa_offset>
ffffffffc0203efe:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203f00:	82b1                	srli	a3,a3,0xc
ffffffffc0203f02:	000a7797          	auipc	a5,0xa7
ffffffffc0203f06:	a067b783          	ld	a5,-1530(a5) # ffffffffc02aa908 <npage>
ffffffffc0203f0a:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f46 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f0e:	00004517          	auipc	a0,0x4
ffffffffc0203f12:	93253503          	ld	a0,-1742(a0) # ffffffffc0207840 <nbase>
}
ffffffffc0203f16:	60a2                	ld	ra,8(sp)
ffffffffc0203f18:	8e89                	sub	a3,a3,a0
ffffffffc0203f1a:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203f1c:	000a7517          	auipc	a0,0xa7
ffffffffc0203f20:	9f453503          	ld	a0,-1548(a0) # ffffffffc02aa910 <pages>
ffffffffc0203f24:	4585                	li	a1,1
ffffffffc0203f26:	9536                	add	a0,a0,a3
}
ffffffffc0203f28:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f2a:	fb9fd06f          	j	ffffffffc0201ee2 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f2e:	00002617          	auipc	a2,0x2
ffffffffc0203f32:	6d260613          	addi	a2,a2,1746 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0203f36:	07700593          	li	a1,119
ffffffffc0203f3a:	00002517          	auipc	a0,0x2
ffffffffc0203f3e:	64650513          	addi	a0,a0,1606 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0203f42:	d4cfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f46:	00002617          	auipc	a2,0x2
ffffffffc0203f4a:	6e260613          	addi	a2,a2,1762 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc0203f4e:	06900593          	li	a1,105
ffffffffc0203f52:	00002517          	auipc	a0,0x2
ffffffffc0203f56:	62e50513          	addi	a0,a0,1582 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0203f5a:	d34fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f5e <proc_run>:
{
ffffffffc0203f5e:	7179                	addi	sp,sp,-48
ffffffffc0203f60:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f62:	000a7917          	auipc	s2,0xa7
ffffffffc0203f66:	9c690913          	addi	s2,s2,-1594 # ffffffffc02aa928 <current>
{
ffffffffc0203f6a:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f6c:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f70:	f406                	sd	ra,40(sp)
ffffffffc0203f72:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f74:	02a48863          	beq	s1,a0,ffffffffc0203fa4 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f78:	100027f3          	csrr	a5,sstatus
ffffffffc0203f7c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203f7e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f80:	ef9d                	bnez	a5,ffffffffc0203fbe <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203f82:	755c                	ld	a5,168(a0)
ffffffffc0203f84:	577d                	li	a4,-1
ffffffffc0203f86:	177e                	slli	a4,a4,0x3f
ffffffffc0203f88:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0203f8a:	00a93023          	sd	a0,0(s2)
ffffffffc0203f8e:	8fd9                	or	a5,a5,a4
ffffffffc0203f90:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc0203f94:	03050593          	addi	a1,a0,48
ffffffffc0203f98:	03048513          	addi	a0,s1,48
ffffffffc0203f9c:	018010ef          	jal	ra,ffffffffc0204fb4 <switch_to>
    if (flag)
ffffffffc0203fa0:	00099863          	bnez	s3,ffffffffc0203fb0 <proc_run+0x52>
}
ffffffffc0203fa4:	70a2                	ld	ra,40(sp)
ffffffffc0203fa6:	7482                	ld	s1,32(sp)
ffffffffc0203fa8:	6962                	ld	s2,24(sp)
ffffffffc0203faa:	69c2                	ld	s3,16(sp)
ffffffffc0203fac:	6145                	addi	sp,sp,48
ffffffffc0203fae:	8082                	ret
ffffffffc0203fb0:	70a2                	ld	ra,40(sp)
ffffffffc0203fb2:	7482                	ld	s1,32(sp)
ffffffffc0203fb4:	6962                	ld	s2,24(sp)
ffffffffc0203fb6:	69c2                	ld	s3,16(sp)
ffffffffc0203fb8:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203fba:	9f5fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203fbe:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203fc0:	9f5fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203fc4:	6522                	ld	a0,8(sp)
ffffffffc0203fc6:	4985                	li	s3,1
ffffffffc0203fc8:	bf6d                	j	ffffffffc0203f82 <proc_run+0x24>

ffffffffc0203fca <do_fork>:
{
ffffffffc0203fca:	7119                	addi	sp,sp,-128
ffffffffc0203fcc:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203fce:	000a7917          	auipc	s2,0xa7
ffffffffc0203fd2:	97290913          	addi	s2,s2,-1678 # ffffffffc02aa940 <nr_process>
ffffffffc0203fd6:	00092703          	lw	a4,0(s2)
{
ffffffffc0203fda:	fc86                	sd	ra,120(sp)
ffffffffc0203fdc:	f8a2                	sd	s0,112(sp)
ffffffffc0203fde:	f4a6                	sd	s1,104(sp)
ffffffffc0203fe0:	ecce                	sd	s3,88(sp)
ffffffffc0203fe2:	e8d2                	sd	s4,80(sp)
ffffffffc0203fe4:	e4d6                	sd	s5,72(sp)
ffffffffc0203fe6:	e0da                	sd	s6,64(sp)
ffffffffc0203fe8:	fc5e                	sd	s7,56(sp)
ffffffffc0203fea:	f862                	sd	s8,48(sp)
ffffffffc0203fec:	f466                	sd	s9,40(sp)
ffffffffc0203fee:	f06a                	sd	s10,32(sp)
ffffffffc0203ff0:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203ff2:	6785                	lui	a5,0x1
ffffffffc0203ff4:	2ef75e63          	bge	a4,a5,ffffffffc02042f0 <do_fork+0x326>
ffffffffc0203ff8:	8a2a                	mv	s4,a0
ffffffffc0203ffa:	89ae                	mv	s3,a1
ffffffffc0203ffc:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203ffe:	dddff0ef          	jal	ra,ffffffffc0203dda <alloc_proc>
ffffffffc0204002:	84aa                	mv	s1,a0
ffffffffc0204004:	2c050a63          	beqz	a0,ffffffffc02042d8 <do_fork+0x30e>
    proc->parent = current;
ffffffffc0204008:	000a7c17          	auipc	s8,0xa7
ffffffffc020400c:	920c0c13          	addi	s8,s8,-1760 # ffffffffc02aa928 <current>
ffffffffc0204010:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state == 0);
ffffffffc0204014:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8adc>
    proc->parent = current;
ffffffffc0204018:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc020401a:	2e071d63          	bnez	a4,ffffffffc0204314 <do_fork+0x34a>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020401e:	4509                	li	a0,2
ffffffffc0204020:	e85fd0ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
    if (page != NULL)
ffffffffc0204024:	2a050763          	beqz	a0,ffffffffc02042d2 <do_fork+0x308>
    return page - pages + nbase;
ffffffffc0204028:	000a7a97          	auipc	s5,0xa7
ffffffffc020402c:	8e8a8a93          	addi	s5,s5,-1816 # ffffffffc02aa910 <pages>
ffffffffc0204030:	000ab683          	ld	a3,0(s5)
ffffffffc0204034:	00004b17          	auipc	s6,0x4
ffffffffc0204038:	80cb0b13          	addi	s6,s6,-2036 # ffffffffc0207840 <nbase>
ffffffffc020403c:	000b3783          	ld	a5,0(s6)
ffffffffc0204040:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204044:	000a7b97          	auipc	s7,0xa7
ffffffffc0204048:	8c4b8b93          	addi	s7,s7,-1852 # ffffffffc02aa908 <npage>
    return page - pages + nbase;
ffffffffc020404c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020404e:	5dfd                	li	s11,-1
ffffffffc0204050:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204054:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204056:	00cddd93          	srli	s11,s11,0xc
ffffffffc020405a:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020405e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204060:	30e67263          	bgeu	a2,a4,ffffffffc0204364 <do_fork+0x39a>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204064:	000c3603          	ld	a2,0(s8)
ffffffffc0204068:	000a7c17          	auipc	s8,0xa7
ffffffffc020406c:	8b8c0c13          	addi	s8,s8,-1864 # ffffffffc02aa920 <va_pa_offset>
ffffffffc0204070:	000c3703          	ld	a4,0(s8)
ffffffffc0204074:	02863d03          	ld	s10,40(a2)
ffffffffc0204078:	e43e                	sd	a5,8(sp)
ffffffffc020407a:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020407c:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc020407e:	020d0863          	beqz	s10,ffffffffc02040ae <do_fork+0xe4>
    if (clone_flags & CLONE_VM)
ffffffffc0204082:	100a7a13          	andi	s4,s4,256
ffffffffc0204086:	180a0863          	beqz	s4,ffffffffc0204216 <do_fork+0x24c>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020408a:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020408e:	018d3783          	ld	a5,24(s10)
ffffffffc0204092:	c02006b7          	lui	a3,0xc0200
ffffffffc0204096:	2705                	addiw	a4,a4,1
ffffffffc0204098:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc020409c:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040a0:	24d7ed63          	bltu	a5,a3,ffffffffc02042fa <do_fork+0x330>
ffffffffc02040a4:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040a8:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040aa:	8f99                	sub	a5,a5,a4
ffffffffc02040ac:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040ae:	6789                	lui	a5,0x2
ffffffffc02040b0:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7ce8>
ffffffffc02040b4:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02040b6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040b8:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02040ba:	87b6                	mv	a5,a3
ffffffffc02040bc:	12040893          	addi	a7,s0,288
ffffffffc02040c0:	00063803          	ld	a6,0(a2)
ffffffffc02040c4:	6608                	ld	a0,8(a2)
ffffffffc02040c6:	6a0c                	ld	a1,16(a2)
ffffffffc02040c8:	6e18                	ld	a4,24(a2)
ffffffffc02040ca:	0107b023          	sd	a6,0(a5)
ffffffffc02040ce:	e788                	sd	a0,8(a5)
ffffffffc02040d0:	eb8c                	sd	a1,16(a5)
ffffffffc02040d2:	ef98                	sd	a4,24(a5)
ffffffffc02040d4:	02060613          	addi	a2,a2,32
ffffffffc02040d8:	02078793          	addi	a5,a5,32
ffffffffc02040dc:	ff1612e3          	bne	a2,a7,ffffffffc02040c0 <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc02040e0:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040e4:	12098763          	beqz	s3,ffffffffc0204212 <do_fork+0x248>
    if (++last_pid >= MAX_PID)
ffffffffc02040e8:	000a2817          	auipc	a6,0xa2
ffffffffc02040ec:	3a880813          	addi	a6,a6,936 # ffffffffc02a6490 <last_pid.1>
ffffffffc02040f0:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02040f4:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02040f8:	00000717          	auipc	a4,0x0
ffffffffc02040fc:	d6470713          	addi	a4,a4,-668 # ffffffffc0203e5c <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0204100:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204104:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204106:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0204108:	00a82023          	sw	a0,0(a6)
ffffffffc020410c:	6789                	lui	a5,0x2
ffffffffc020410e:	08f55b63          	bge	a0,a5,ffffffffc02041a4 <do_fork+0x1da>
    if (last_pid >= next_safe)
ffffffffc0204112:	000a2317          	auipc	t1,0xa2
ffffffffc0204116:	38230313          	addi	t1,t1,898 # ffffffffc02a6494 <next_safe.0>
ffffffffc020411a:	00032783          	lw	a5,0(t1)
ffffffffc020411e:	000a6417          	auipc	s0,0xa6
ffffffffc0204122:	79240413          	addi	s0,s0,1938 # ffffffffc02aa8b0 <proc_list>
ffffffffc0204126:	08f55763          	bge	a0,a5,ffffffffc02041b4 <do_fork+0x1ea>
    proc->pid = get_pid();
ffffffffc020412a:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020412c:	45a9                	li	a1,10
ffffffffc020412e:	2501                	sext.w	a0,a0
ffffffffc0204130:	0da010ef          	jal	ra,ffffffffc020520a <hash32>
ffffffffc0204134:	02051793          	slli	a5,a0,0x20
ffffffffc0204138:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020413c:	000a2797          	auipc	a5,0xa2
ffffffffc0204140:	77478793          	addi	a5,a5,1908 # ffffffffc02a68b0 <hash_list>
ffffffffc0204144:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204146:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204148:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020414a:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020414e:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204150:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0204152:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204154:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204156:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc020415a:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc020415c:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020415e:	e21c                	sd	a5,0(a2)
ffffffffc0204160:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204162:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204164:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204166:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020416a:	10e4b023          	sd	a4,256(s1)
ffffffffc020416e:	c311                	beqz	a4,ffffffffc0204172 <do_fork+0x1a8>
        proc->optr->yptr = proc;
ffffffffc0204170:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc0204172:	00092783          	lw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc0204176:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc0204178:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc020417a:	2785                	addiw	a5,a5,1
ffffffffc020417c:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc0204180:	69f000ef          	jal	ra,ffffffffc020501e <wakeup_proc>
    ret = proc->pid;
ffffffffc0204184:	40c8                	lw	a0,4(s1)
}
ffffffffc0204186:	70e6                	ld	ra,120(sp)
ffffffffc0204188:	7446                	ld	s0,112(sp)
ffffffffc020418a:	74a6                	ld	s1,104(sp)
ffffffffc020418c:	7906                	ld	s2,96(sp)
ffffffffc020418e:	69e6                	ld	s3,88(sp)
ffffffffc0204190:	6a46                	ld	s4,80(sp)
ffffffffc0204192:	6aa6                	ld	s5,72(sp)
ffffffffc0204194:	6b06                	ld	s6,64(sp)
ffffffffc0204196:	7be2                	ld	s7,56(sp)
ffffffffc0204198:	7c42                	ld	s8,48(sp)
ffffffffc020419a:	7ca2                	ld	s9,40(sp)
ffffffffc020419c:	7d02                	ld	s10,32(sp)
ffffffffc020419e:	6de2                	ld	s11,24(sp)
ffffffffc02041a0:	6109                	addi	sp,sp,128
ffffffffc02041a2:	8082                	ret
        last_pid = 1;
ffffffffc02041a4:	4785                	li	a5,1
ffffffffc02041a6:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041aa:	4505                	li	a0,1
ffffffffc02041ac:	000a2317          	auipc	t1,0xa2
ffffffffc02041b0:	2e830313          	addi	t1,t1,744 # ffffffffc02a6494 <next_safe.0>
    return listelm->next;
ffffffffc02041b4:	000a6417          	auipc	s0,0xa6
ffffffffc02041b8:	6fc40413          	addi	s0,s0,1788 # ffffffffc02aa8b0 <proc_list>
ffffffffc02041bc:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02041c0:	6789                	lui	a5,0x2
ffffffffc02041c2:	00f32023          	sw	a5,0(t1)
ffffffffc02041c6:	86aa                	mv	a3,a0
ffffffffc02041c8:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02041ca:	6e89                	lui	t4,0x2
ffffffffc02041cc:	108e0d63          	beq	t3,s0,ffffffffc02042e6 <do_fork+0x31c>
ffffffffc02041d0:	88ae                	mv	a7,a1
ffffffffc02041d2:	87f2                	mv	a5,t3
ffffffffc02041d4:	6609                	lui	a2,0x2
ffffffffc02041d6:	a811                	j	ffffffffc02041ea <do_fork+0x220>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02041d8:	00e6d663          	bge	a3,a4,ffffffffc02041e4 <do_fork+0x21a>
ffffffffc02041dc:	00c75463          	bge	a4,a2,ffffffffc02041e4 <do_fork+0x21a>
ffffffffc02041e0:	863a                	mv	a2,a4
ffffffffc02041e2:	4885                	li	a7,1
ffffffffc02041e4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02041e6:	00878d63          	beq	a5,s0,ffffffffc0204200 <do_fork+0x236>
            if (proc->pid == last_pid)
ffffffffc02041ea:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c8c>
ffffffffc02041ee:	fed715e3          	bne	a4,a3,ffffffffc02041d8 <do_fork+0x20e>
                if (++last_pid >= next_safe)
ffffffffc02041f2:	2685                	addiw	a3,a3,1
ffffffffc02041f4:	0ec6d463          	bge	a3,a2,ffffffffc02042dc <do_fork+0x312>
ffffffffc02041f8:	679c                	ld	a5,8(a5)
ffffffffc02041fa:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02041fc:	fe8797e3          	bne	a5,s0,ffffffffc02041ea <do_fork+0x220>
ffffffffc0204200:	c581                	beqz	a1,ffffffffc0204208 <do_fork+0x23e>
ffffffffc0204202:	00d82023          	sw	a3,0(a6)
ffffffffc0204206:	8536                	mv	a0,a3
ffffffffc0204208:	f20881e3          	beqz	a7,ffffffffc020412a <do_fork+0x160>
ffffffffc020420c:	00c32023          	sw	a2,0(t1)
ffffffffc0204210:	bf29                	j	ffffffffc020412a <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204212:	89b6                	mv	s3,a3
ffffffffc0204214:	bdd1                	j	ffffffffc02040e8 <do_fork+0x11e>
    if ((mm = mm_create()) == NULL)
ffffffffc0204216:	cb2ff0ef          	jal	ra,ffffffffc02036c8 <mm_create>
ffffffffc020421a:	8caa                	mv	s9,a0
ffffffffc020421c:	c159                	beqz	a0,ffffffffc02042a2 <do_fork+0x2d8>
    if ((page = alloc_page()) == NULL)
ffffffffc020421e:	4505                	li	a0,1
ffffffffc0204220:	c85fd0ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc0204224:	cd25                	beqz	a0,ffffffffc020429c <do_fork+0x2d2>
    return page - pages + nbase;
ffffffffc0204226:	000ab683          	ld	a3,0(s5)
ffffffffc020422a:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020422c:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204230:	40d506b3          	sub	a3,a0,a3
ffffffffc0204234:	8699                	srai	a3,a3,0x6
ffffffffc0204236:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204238:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020423c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020423e:	12edf363          	bgeu	s11,a4,ffffffffc0204364 <do_fork+0x39a>
ffffffffc0204242:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204246:	6605                	lui	a2,0x1
ffffffffc0204248:	000a6597          	auipc	a1,0xa6
ffffffffc020424c:	6b85b583          	ld	a1,1720(a1) # ffffffffc02aa900 <boot_pgdir_va>
ffffffffc0204250:	9a36                	add	s4,s4,a3
ffffffffc0204252:	8552                	mv	a0,s4
ffffffffc0204254:	46e010ef          	jal	ra,ffffffffc02056c2 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204258:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc020425c:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204260:	4785                	li	a5,1
ffffffffc0204262:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204266:	8b85                	andi	a5,a5,1
ffffffffc0204268:	4a05                	li	s4,1
ffffffffc020426a:	c799                	beqz	a5,ffffffffc0204278 <do_fork+0x2ae>
    {
        schedule();
ffffffffc020426c:	633000ef          	jal	ra,ffffffffc020509e <schedule>
ffffffffc0204270:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204274:	8b85                	andi	a5,a5,1
ffffffffc0204276:	fbfd                	bnez	a5,ffffffffc020426c <do_fork+0x2a2>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204278:	85ea                	mv	a1,s10
ffffffffc020427a:	8566                	mv	a0,s9
ffffffffc020427c:	e8eff0ef          	jal	ra,ffffffffc020390a <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204280:	57f9                	li	a5,-2
ffffffffc0204282:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0204286:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204288:	c3f1                	beqz	a5,ffffffffc020434c <do_fork+0x382>
good_mm:
ffffffffc020428a:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc020428c:	de050fe3          	beqz	a0,ffffffffc020408a <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc0204290:	8566                	mv	a0,s9
ffffffffc0204292:	f12ff0ef          	jal	ra,ffffffffc02039a4 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204296:	8566                	mv	a0,s9
ffffffffc0204298:	c51ff0ef          	jal	ra,ffffffffc0203ee8 <put_pgdir>
    mm_destroy(mm);
ffffffffc020429c:	8566                	mv	a0,s9
ffffffffc020429e:	d6aff0ef          	jal	ra,ffffffffc0203808 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042a2:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02042a4:	c02007b7          	lui	a5,0xc0200
ffffffffc02042a8:	0cf6ea63          	bltu	a3,a5,ffffffffc020437c <do_fork+0x3b2>
ffffffffc02042ac:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02042b0:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042b4:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042b8:	83b1                	srli	a5,a5,0xc
ffffffffc02042ba:	06e7fd63          	bgeu	a5,a4,ffffffffc0204334 <do_fork+0x36a>
    return &pages[PPN(pa) - nbase];
ffffffffc02042be:	000b3703          	ld	a4,0(s6)
ffffffffc02042c2:	000ab503          	ld	a0,0(s5)
ffffffffc02042c6:	4589                	li	a1,2
ffffffffc02042c8:	8f99                	sub	a5,a5,a4
ffffffffc02042ca:	079a                	slli	a5,a5,0x6
ffffffffc02042cc:	953e                	add	a0,a0,a5
ffffffffc02042ce:	c15fd0ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    kfree(proc);
ffffffffc02042d2:	8526                	mv	a0,s1
ffffffffc02042d4:	aa3fd0ef          	jal	ra,ffffffffc0201d76 <kfree>
    ret = -E_NO_MEM;
ffffffffc02042d8:	5571                	li	a0,-4
    return ret;
ffffffffc02042da:	b575                	j	ffffffffc0204186 <do_fork+0x1bc>
                    if (last_pid >= MAX_PID)
ffffffffc02042dc:	01d6c363          	blt	a3,t4,ffffffffc02042e2 <do_fork+0x318>
                        last_pid = 1;
ffffffffc02042e0:	4685                	li	a3,1
                    goto repeat;
ffffffffc02042e2:	4585                	li	a1,1
ffffffffc02042e4:	b5e5                	j	ffffffffc02041cc <do_fork+0x202>
ffffffffc02042e6:	c599                	beqz	a1,ffffffffc02042f4 <do_fork+0x32a>
ffffffffc02042e8:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02042ec:	8536                	mv	a0,a3
ffffffffc02042ee:	bd35                	j	ffffffffc020412a <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc02042f0:	556d                	li	a0,-5
ffffffffc02042f2:	bd51                	j	ffffffffc0204186 <do_fork+0x1bc>
    return last_pid;
ffffffffc02042f4:	00082503          	lw	a0,0(a6)
ffffffffc02042f8:	bd0d                	j	ffffffffc020412a <do_fork+0x160>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02042fa:	86be                	mv	a3,a5
ffffffffc02042fc:	00002617          	auipc	a2,0x2
ffffffffc0204300:	30460613          	addi	a2,a2,772 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0204304:	19300593          	li	a1,403
ffffffffc0204308:	00003517          	auipc	a0,0x3
ffffffffc020430c:	c8050513          	addi	a0,a0,-896 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204310:	97efc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(current->wait_state == 0);
ffffffffc0204314:	00003697          	auipc	a3,0x3
ffffffffc0204318:	c8c68693          	addi	a3,a3,-884 # ffffffffc0206fa0 <default_pmm_manager+0xa80>
ffffffffc020431c:	00002617          	auipc	a2,0x2
ffffffffc0204320:	e5460613          	addi	a2,a2,-428 # ffffffffc0206170 <commands+0x828>
ffffffffc0204324:	1c300593          	li	a1,451
ffffffffc0204328:	00003517          	auipc	a0,0x3
ffffffffc020432c:	c6050513          	addi	a0,a0,-928 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204330:	95efc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204334:	00002617          	auipc	a2,0x2
ffffffffc0204338:	2f460613          	addi	a2,a2,756 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc020433c:	06900593          	li	a1,105
ffffffffc0204340:	00002517          	auipc	a0,0x2
ffffffffc0204344:	24050513          	addi	a0,a0,576 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0204348:	946fc0ef          	jal	ra,ffffffffc020048e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020434c:	00003617          	auipc	a2,0x3
ffffffffc0204350:	c7460613          	addi	a2,a2,-908 # ffffffffc0206fc0 <default_pmm_manager+0xaa0>
ffffffffc0204354:	03f00593          	li	a1,63
ffffffffc0204358:	00003517          	auipc	a0,0x3
ffffffffc020435c:	c7850513          	addi	a0,a0,-904 # ffffffffc0206fd0 <default_pmm_manager+0xab0>
ffffffffc0204360:	92efc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204364:	00002617          	auipc	a2,0x2
ffffffffc0204368:	1f460613          	addi	a2,a2,500 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc020436c:	07100593          	li	a1,113
ffffffffc0204370:	00002517          	auipc	a0,0x2
ffffffffc0204374:	21050513          	addi	a0,a0,528 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0204378:	916fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020437c:	00002617          	auipc	a2,0x2
ffffffffc0204380:	28460613          	addi	a2,a2,644 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0204384:	07700593          	li	a1,119
ffffffffc0204388:	00002517          	auipc	a0,0x2
ffffffffc020438c:	1f850513          	addi	a0,a0,504 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0204390:	8fefc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204394 <kernel_thread>:
{
ffffffffc0204394:	7129                	addi	sp,sp,-320
ffffffffc0204396:	fa22                	sd	s0,304(sp)
ffffffffc0204398:	f626                	sd	s1,296(sp)
ffffffffc020439a:	f24a                	sd	s2,288(sp)
ffffffffc020439c:	84ae                	mv	s1,a1
ffffffffc020439e:	892a                	mv	s2,a0
ffffffffc02043a0:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043a2:	4581                	li	a1,0
ffffffffc02043a4:	12000613          	li	a2,288
ffffffffc02043a8:	850a                	mv	a0,sp
{
ffffffffc02043aa:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043ac:	304010ef          	jal	ra,ffffffffc02056b0 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043b0:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043b2:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043b4:	100027f3          	csrr	a5,sstatus
ffffffffc02043b8:	edd7f793          	andi	a5,a5,-291
ffffffffc02043bc:	1207e793          	ori	a5,a5,288
ffffffffc02043c0:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043c2:	860a                	mv	a2,sp
ffffffffc02043c4:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043c8:	00000797          	auipc	a5,0x0
ffffffffc02043cc:	a0a78793          	addi	a5,a5,-1526 # ffffffffc0203dd2 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043d0:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043d2:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043d4:	bf7ff0ef          	jal	ra,ffffffffc0203fca <do_fork>
}
ffffffffc02043d8:	70f2                	ld	ra,312(sp)
ffffffffc02043da:	7452                	ld	s0,304(sp)
ffffffffc02043dc:	74b2                	ld	s1,296(sp)
ffffffffc02043de:	7912                	ld	s2,288(sp)
ffffffffc02043e0:	6131                	addi	sp,sp,320
ffffffffc02043e2:	8082                	ret

ffffffffc02043e4 <do_exit>:
{
ffffffffc02043e4:	7179                	addi	sp,sp,-48
ffffffffc02043e6:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02043e8:	000a6417          	auipc	s0,0xa6
ffffffffc02043ec:	54040413          	addi	s0,s0,1344 # ffffffffc02aa928 <current>
ffffffffc02043f0:	601c                	ld	a5,0(s0)
{
ffffffffc02043f2:	f406                	sd	ra,40(sp)
ffffffffc02043f4:	ec26                	sd	s1,24(sp)
ffffffffc02043f6:	e84a                	sd	s2,16(sp)
ffffffffc02043f8:	e44e                	sd	s3,8(sp)
ffffffffc02043fa:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc02043fc:	000a6717          	auipc	a4,0xa6
ffffffffc0204400:	53473703          	ld	a4,1332(a4) # ffffffffc02aa930 <idleproc>
ffffffffc0204404:	0ce78c63          	beq	a5,a4,ffffffffc02044dc <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204408:	000a6497          	auipc	s1,0xa6
ffffffffc020440c:	53048493          	addi	s1,s1,1328 # ffffffffc02aa938 <initproc>
ffffffffc0204410:	6098                	ld	a4,0(s1)
ffffffffc0204412:	0ee78b63          	beq	a5,a4,ffffffffc0204508 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204416:	0287b983          	ld	s3,40(a5)
ffffffffc020441a:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020441c:	02098663          	beqz	s3,ffffffffc0204448 <do_exit+0x64>
ffffffffc0204420:	000a6797          	auipc	a5,0xa6
ffffffffc0204424:	4d87b783          	ld	a5,1240(a5) # ffffffffc02aa8f8 <boot_pgdir_pa>
ffffffffc0204428:	577d                	li	a4,-1
ffffffffc020442a:	177e                	slli	a4,a4,0x3f
ffffffffc020442c:	83b1                	srli	a5,a5,0xc
ffffffffc020442e:	8fd9                	or	a5,a5,a4
ffffffffc0204430:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204434:	0309a783          	lw	a5,48(s3)
ffffffffc0204438:	fff7871b          	addiw	a4,a5,-1
ffffffffc020443c:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204440:	cb55                	beqz	a4,ffffffffc02044f4 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204442:	601c                	ld	a5,0(s0)
ffffffffc0204444:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204448:	601c                	ld	a5,0(s0)
ffffffffc020444a:	470d                	li	a4,3
ffffffffc020444c:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020444e:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204452:	100027f3          	csrr	a5,sstatus
ffffffffc0204456:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204458:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020445a:	e3f9                	bnez	a5,ffffffffc0204520 <do_exit+0x13c>
        proc = current->parent;
ffffffffc020445c:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020445e:	800007b7          	lui	a5,0x80000
ffffffffc0204462:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204464:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204466:	0ec52703          	lw	a4,236(a0)
ffffffffc020446a:	0af70f63          	beq	a4,a5,ffffffffc0204528 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020446e:	6018                	ld	a4,0(s0)
ffffffffc0204470:	7b7c                	ld	a5,240(a4)
ffffffffc0204472:	c3a1                	beqz	a5,ffffffffc02044b2 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204474:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204478:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc020447a:	0985                	addi	s3,s3,1
ffffffffc020447c:	a021                	j	ffffffffc0204484 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020447e:	6018                	ld	a4,0(s0)
ffffffffc0204480:	7b7c                	ld	a5,240(a4)
ffffffffc0204482:	cb85                	beqz	a5,ffffffffc02044b2 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204484:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fc0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204488:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020448a:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020448c:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc020448e:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204492:	10e7b023          	sd	a4,256(a5)
ffffffffc0204496:	c311                	beqz	a4,ffffffffc020449a <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204498:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020449a:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc020449c:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc020449e:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044a0:	fd271fe3          	bne	a4,s2,ffffffffc020447e <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044a4:	0ec52783          	lw	a5,236(a0)
ffffffffc02044a8:	fd379be3          	bne	a5,s3,ffffffffc020447e <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02044ac:	373000ef          	jal	ra,ffffffffc020501e <wakeup_proc>
ffffffffc02044b0:	b7f9                	j	ffffffffc020447e <do_exit+0x9a>
    if (flag)
ffffffffc02044b2:	020a1263          	bnez	s4,ffffffffc02044d6 <do_exit+0xf2>
    schedule();
ffffffffc02044b6:	3e9000ef          	jal	ra,ffffffffc020509e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044ba:	601c                	ld	a5,0(s0)
ffffffffc02044bc:	00003617          	auipc	a2,0x3
ffffffffc02044c0:	b4c60613          	addi	a2,a2,-1204 # ffffffffc0207008 <default_pmm_manager+0xae8>
ffffffffc02044c4:	24a00593          	li	a1,586
ffffffffc02044c8:	43d4                	lw	a3,4(a5)
ffffffffc02044ca:	00003517          	auipc	a0,0x3
ffffffffc02044ce:	abe50513          	addi	a0,a0,-1346 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02044d2:	fbdfb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02044d6:	cd8fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02044da:	bff1                	j	ffffffffc02044b6 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02044dc:	00003617          	auipc	a2,0x3
ffffffffc02044e0:	b0c60613          	addi	a2,a2,-1268 # ffffffffc0206fe8 <default_pmm_manager+0xac8>
ffffffffc02044e4:	21600593          	li	a1,534
ffffffffc02044e8:	00003517          	auipc	a0,0x3
ffffffffc02044ec:	aa050513          	addi	a0,a0,-1376 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02044f0:	f9ffb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc02044f4:	854e                	mv	a0,s3
ffffffffc02044f6:	caeff0ef          	jal	ra,ffffffffc02039a4 <exit_mmap>
            put_pgdir(mm);
ffffffffc02044fa:	854e                	mv	a0,s3
ffffffffc02044fc:	9edff0ef          	jal	ra,ffffffffc0203ee8 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204500:	854e                	mv	a0,s3
ffffffffc0204502:	b06ff0ef          	jal	ra,ffffffffc0203808 <mm_destroy>
ffffffffc0204506:	bf35                	j	ffffffffc0204442 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204508:	00003617          	auipc	a2,0x3
ffffffffc020450c:	af060613          	addi	a2,a2,-1296 # ffffffffc0206ff8 <default_pmm_manager+0xad8>
ffffffffc0204510:	21a00593          	li	a1,538
ffffffffc0204514:	00003517          	auipc	a0,0x3
ffffffffc0204518:	a7450513          	addi	a0,a0,-1420 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc020451c:	f73fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204520:	c94fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204524:	4a05                	li	s4,1
ffffffffc0204526:	bf1d                	j	ffffffffc020445c <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204528:	2f7000ef          	jal	ra,ffffffffc020501e <wakeup_proc>
ffffffffc020452c:	b789                	j	ffffffffc020446e <do_exit+0x8a>

ffffffffc020452e <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020452e:	715d                	addi	sp,sp,-80
ffffffffc0204530:	f84a                	sd	s2,48(sp)
ffffffffc0204532:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204534:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204538:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020453a:	fc26                	sd	s1,56(sp)
ffffffffc020453c:	f052                	sd	s4,32(sp)
ffffffffc020453e:	ec56                	sd	s5,24(sp)
ffffffffc0204540:	e85a                	sd	s6,16(sp)
ffffffffc0204542:	e45e                	sd	s7,8(sp)
ffffffffc0204544:	e486                	sd	ra,72(sp)
ffffffffc0204546:	e0a2                	sd	s0,64(sp)
ffffffffc0204548:	84aa                	mv	s1,a0
ffffffffc020454a:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020454c:	000a6b97          	auipc	s7,0xa6
ffffffffc0204550:	3dcb8b93          	addi	s7,s7,988 # ffffffffc02aa928 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204554:	00050b1b          	sext.w	s6,a0
ffffffffc0204558:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020455c:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc020455e:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204560:	ccbd                	beqz	s1,ffffffffc02045de <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204562:	0359e863          	bltu	s3,s5,ffffffffc0204592 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204566:	45a9                	li	a1,10
ffffffffc0204568:	855a                	mv	a0,s6
ffffffffc020456a:	4a1000ef          	jal	ra,ffffffffc020520a <hash32>
ffffffffc020456e:	02051793          	slli	a5,a0,0x20
ffffffffc0204572:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204576:	000a2797          	auipc	a5,0xa2
ffffffffc020457a:	33a78793          	addi	a5,a5,826 # ffffffffc02a68b0 <hash_list>
ffffffffc020457e:	953e                	add	a0,a0,a5
ffffffffc0204580:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204582:	a029                	j	ffffffffc020458c <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204584:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204588:	02978163          	beq	a5,s1,ffffffffc02045aa <do_wait.part.0+0x7c>
ffffffffc020458c:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc020458e:	fe851be3          	bne	a0,s0,ffffffffc0204584 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc0204592:	5579                	li	a0,-2
}
ffffffffc0204594:	60a6                	ld	ra,72(sp)
ffffffffc0204596:	6406                	ld	s0,64(sp)
ffffffffc0204598:	74e2                	ld	s1,56(sp)
ffffffffc020459a:	7942                	ld	s2,48(sp)
ffffffffc020459c:	79a2                	ld	s3,40(sp)
ffffffffc020459e:	7a02                	ld	s4,32(sp)
ffffffffc02045a0:	6ae2                	ld	s5,24(sp)
ffffffffc02045a2:	6b42                	ld	s6,16(sp)
ffffffffc02045a4:	6ba2                	ld	s7,8(sp)
ffffffffc02045a6:	6161                	addi	sp,sp,80
ffffffffc02045a8:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045aa:	000bb683          	ld	a3,0(s7)
ffffffffc02045ae:	f4843783          	ld	a5,-184(s0)
ffffffffc02045b2:	fed790e3          	bne	a5,a3,ffffffffc0204592 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045b6:	f2842703          	lw	a4,-216(s0)
ffffffffc02045ba:	478d                	li	a5,3
ffffffffc02045bc:	0ef70b63          	beq	a4,a5,ffffffffc02046b2 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045c0:	4785                	li	a5,1
ffffffffc02045c2:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045c4:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02045c8:	2d7000ef          	jal	ra,ffffffffc020509e <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045cc:	000bb783          	ld	a5,0(s7)
ffffffffc02045d0:	0b07a783          	lw	a5,176(a5)
ffffffffc02045d4:	8b85                	andi	a5,a5,1
ffffffffc02045d6:	d7c9                	beqz	a5,ffffffffc0204560 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02045d8:	555d                	li	a0,-9
ffffffffc02045da:	e0bff0ef          	jal	ra,ffffffffc02043e4 <do_exit>
        proc = current->cptr;
ffffffffc02045de:	000bb683          	ld	a3,0(s7)
ffffffffc02045e2:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02045e4:	d45d                	beqz	s0,ffffffffc0204592 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045e6:	470d                	li	a4,3
ffffffffc02045e8:	a021                	j	ffffffffc02045f0 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02045ea:	10043403          	ld	s0,256(s0)
ffffffffc02045ee:	d869                	beqz	s0,ffffffffc02045c0 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045f0:	401c                	lw	a5,0(s0)
ffffffffc02045f2:	fee79ce3          	bne	a5,a4,ffffffffc02045ea <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc02045f6:	000a6797          	auipc	a5,0xa6
ffffffffc02045fa:	33a7b783          	ld	a5,826(a5) # ffffffffc02aa930 <idleproc>
ffffffffc02045fe:	0c878963          	beq	a5,s0,ffffffffc02046d0 <do_wait.part.0+0x1a2>
ffffffffc0204602:	000a6797          	auipc	a5,0xa6
ffffffffc0204606:	3367b783          	ld	a5,822(a5) # ffffffffc02aa938 <initproc>
ffffffffc020460a:	0cf40363          	beq	s0,a5,ffffffffc02046d0 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020460e:	000a0663          	beqz	s4,ffffffffc020461a <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204612:	0e842783          	lw	a5,232(s0)
ffffffffc0204616:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bc8>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020461a:	100027f3          	csrr	a5,sstatus
ffffffffc020461e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204620:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204622:	e7c1                	bnez	a5,ffffffffc02046aa <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204624:	6c70                	ld	a2,216(s0)
ffffffffc0204626:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204628:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020462c:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020462e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204630:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204632:	6470                	ld	a2,200(s0)
ffffffffc0204634:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204636:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204638:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020463a:	c319                	beqz	a4,ffffffffc0204640 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020463c:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020463e:	7c7c                	ld	a5,248(s0)
ffffffffc0204640:	c3b5                	beqz	a5,ffffffffc02046a4 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204642:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204646:	000a6717          	auipc	a4,0xa6
ffffffffc020464a:	2fa70713          	addi	a4,a4,762 # ffffffffc02aa940 <nr_process>
ffffffffc020464e:	431c                	lw	a5,0(a4)
ffffffffc0204650:	37fd                	addiw	a5,a5,-1
ffffffffc0204652:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204654:	e5a9                	bnez	a1,ffffffffc020469e <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204656:	6814                	ld	a3,16(s0)
ffffffffc0204658:	c02007b7          	lui	a5,0xc0200
ffffffffc020465c:	04f6ee63          	bltu	a3,a5,ffffffffc02046b8 <do_wait.part.0+0x18a>
ffffffffc0204660:	000a6797          	auipc	a5,0xa6
ffffffffc0204664:	2c07b783          	ld	a5,704(a5) # ffffffffc02aa920 <va_pa_offset>
ffffffffc0204668:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020466a:	82b1                	srli	a3,a3,0xc
ffffffffc020466c:	000a6797          	auipc	a5,0xa6
ffffffffc0204670:	29c7b783          	ld	a5,668(a5) # ffffffffc02aa908 <npage>
ffffffffc0204674:	06f6fa63          	bgeu	a3,a5,ffffffffc02046e8 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204678:	00003517          	auipc	a0,0x3
ffffffffc020467c:	1c853503          	ld	a0,456(a0) # ffffffffc0207840 <nbase>
ffffffffc0204680:	8e89                	sub	a3,a3,a0
ffffffffc0204682:	069a                	slli	a3,a3,0x6
ffffffffc0204684:	000a6517          	auipc	a0,0xa6
ffffffffc0204688:	28c53503          	ld	a0,652(a0) # ffffffffc02aa910 <pages>
ffffffffc020468c:	9536                	add	a0,a0,a3
ffffffffc020468e:	4589                	li	a1,2
ffffffffc0204690:	853fd0ef          	jal	ra,ffffffffc0201ee2 <free_pages>
    kfree(proc);
ffffffffc0204694:	8522                	mv	a0,s0
ffffffffc0204696:	ee0fd0ef          	jal	ra,ffffffffc0201d76 <kfree>
    return 0;
ffffffffc020469a:	4501                	li	a0,0
ffffffffc020469c:	bde5                	j	ffffffffc0204594 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc020469e:	b10fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046a2:	bf55                	j	ffffffffc0204656 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046a4:	701c                	ld	a5,32(s0)
ffffffffc02046a6:	fbf8                	sd	a4,240(a5)
ffffffffc02046a8:	bf79                	j	ffffffffc0204646 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046aa:	b0afc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02046ae:	4585                	li	a1,1
ffffffffc02046b0:	bf95                	j	ffffffffc0204624 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046b2:	f2840413          	addi	s0,s0,-216
ffffffffc02046b6:	b781                	j	ffffffffc02045f6 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046b8:	00002617          	auipc	a2,0x2
ffffffffc02046bc:	f4860613          	addi	a2,a2,-184 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc02046c0:	07700593          	li	a1,119
ffffffffc02046c4:	00002517          	auipc	a0,0x2
ffffffffc02046c8:	ebc50513          	addi	a0,a0,-324 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc02046cc:	dc3fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02046d0:	00003617          	auipc	a2,0x3
ffffffffc02046d4:	95860613          	addi	a2,a2,-1704 # ffffffffc0207028 <default_pmm_manager+0xb08>
ffffffffc02046d8:	37000593          	li	a1,880
ffffffffc02046dc:	00003517          	auipc	a0,0x3
ffffffffc02046e0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02046e4:	dabfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02046e8:	00002617          	auipc	a2,0x2
ffffffffc02046ec:	f4060613          	addi	a2,a2,-192 # ffffffffc0206628 <default_pmm_manager+0x108>
ffffffffc02046f0:	06900593          	li	a1,105
ffffffffc02046f4:	00002517          	auipc	a0,0x2
ffffffffc02046f8:	e8c50513          	addi	a0,a0,-372 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc02046fc:	d93fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204700 <init_main>:

// init_main - the second kernel thread used to create user_main kernel threads
// init_main - 第二个内核线程，用于创建用户态主线程并管理其生命周期
static int
init_main(void *arg)
{
ffffffffc0204700:	1141                	addi	sp,sp,-16
ffffffffc0204702:	e406                	sd	ra,8(sp)
    // 保存当前系统的空闲页面数，用于后续内存泄漏检测
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204704:	81ffd0ef          	jal	ra,ffffffffc0201f22 <nr_free_pages>
    // 保存当前内核已分配的内存量，用于后续内存泄漏检测
    size_t kernel_allocated_store = kallocated();
ffffffffc0204708:	dbafd0ef          	jal	ra,ffffffffc0201cc2 <kallocated>

    // 创建user_main内核线程，该线程负责启动所有用户态进程
    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020470c:	4601                	li	a2,0
ffffffffc020470e:	4581                	li	a1,0
ffffffffc0204710:	fffff517          	auipc	a0,0xfffff
ffffffffc0204714:	75a50513          	addi	a0,a0,1882 # ffffffffc0203e6a <user_main>
ffffffffc0204718:	c7dff0ef          	jal	ra,ffffffffc0204394 <kernel_thread>
    if (pid <= 0)
ffffffffc020471c:	00a04563          	bgtz	a0,ffffffffc0204726 <init_main+0x26>
ffffffffc0204720:	a071                	j	ffffffffc02047ac <init_main+0xac>
    // 循环等待所有子进程退出
    // do_wait(0, NULL)会等待任意一个子进程结束，返回0表示还有子进程在运行
    // 当所有子进程都退出后，do_wait返回非0值，循环结束
    while (do_wait(0, NULL) == 0)
    {
        schedule();  // 让出CPU，调度其他进程运行
ffffffffc0204722:	17d000ef          	jal	ra,ffffffffc020509e <schedule>
    if (code_store != NULL)
ffffffffc0204726:	4581                	li	a1,0
ffffffffc0204728:	4501                	li	a0,0
ffffffffc020472a:	e05ff0ef          	jal	ra,ffffffffc020452e <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020472e:	d975                	beqz	a0,ffffffffc0204722 <init_main+0x22>
    }

    // 所有用户态进程已经退出
    cprintf("all user-mode processes have quit.\n");
ffffffffc0204730:	00003517          	auipc	a0,0x3
ffffffffc0204734:	93850513          	addi	a0,a0,-1736 # ffffffffc0207068 <default_pmm_manager+0xb48>
ffffffffc0204738:	a5dfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    // 检查initproc进程状态是否正确
    // cptr: child pointer，子进程指针应为NULL（无子进程）
    // yptr: younger sibling pointer，弟进程指针应为NULL（无弟进程）
    // optr: older sibling pointer，兄进程指针应为NULL（无兄进程）
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020473c:	000a6797          	auipc	a5,0xa6
ffffffffc0204740:	1fc7b783          	ld	a5,508(a5) # ffffffffc02aa938 <initproc>
ffffffffc0204744:	7bf8                	ld	a4,240(a5)
ffffffffc0204746:	e339                	bnez	a4,ffffffffc020478c <init_main+0x8c>
ffffffffc0204748:	7ff8                	ld	a4,248(a5)
ffffffffc020474a:	e329                	bnez	a4,ffffffffc020478c <init_main+0x8c>
ffffffffc020474c:	1007b703          	ld	a4,256(a5)
ffffffffc0204750:	ef15                	bnez	a4,ffffffffc020478c <init_main+0x8c>
    
    // 检查当前系统只剩下2个进程：idleproc和initproc
    assert(nr_process == 2);
ffffffffc0204752:	000a6697          	auipc	a3,0xa6
ffffffffc0204756:	1ee6a683          	lw	a3,494(a3) # ffffffffc02aa940 <nr_process>
ffffffffc020475a:	4709                	li	a4,2
ffffffffc020475c:	0ae69463          	bne	a3,a4,ffffffffc0204804 <init_main+0x104>
    return listelm->next;
ffffffffc0204760:	000a6697          	auipc	a3,0xa6
ffffffffc0204764:	15068693          	addi	a3,a3,336 # ffffffffc02aa8b0 <proc_list>
    
    // 检查进程链表中只有initproc一个进程节点
    // list_next应该指向initproc的list_link（只有一个节点时，next指向自己）
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204768:	6698                	ld	a4,8(a3)
ffffffffc020476a:	0c878793          	addi	a5,a5,200
ffffffffc020476e:	06f71b63          	bne	a4,a5,ffffffffc02047e4 <init_main+0xe4>
    // list_prev应该指向initproc的list_link（只有一个节点时，prev指向自己）
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204772:	629c                	ld	a5,0(a3)
ffffffffc0204774:	04f71863          	bne	a4,a5,ffffffffc02047c4 <init_main+0xc4>

    // 内存检查通过（暗示没有内存泄漏）
    cprintf("init check memory pass.\n");
ffffffffc0204778:	00003517          	auipc	a0,0x3
ffffffffc020477c:	9d850513          	addi	a0,a0,-1576 # ffffffffc0207150 <default_pmm_manager+0xc30>
ffffffffc0204780:	a15fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204784:	60a2                	ld	ra,8(sp)
ffffffffc0204786:	4501                	li	a0,0
ffffffffc0204788:	0141                	addi	sp,sp,16
ffffffffc020478a:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020478c:	00003697          	auipc	a3,0x3
ffffffffc0204790:	90468693          	addi	a3,a3,-1788 # ffffffffc0207090 <default_pmm_manager+0xb70>
ffffffffc0204794:	00002617          	auipc	a2,0x2
ffffffffc0204798:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0206170 <commands+0x828>
ffffffffc020479c:	40100593          	li	a1,1025
ffffffffc02047a0:	00002517          	auipc	a0,0x2
ffffffffc02047a4:	7e850513          	addi	a0,a0,2024 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02047a8:	ce7fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02047ac:	00003617          	auipc	a2,0x3
ffffffffc02047b0:	89c60613          	addi	a2,a2,-1892 # ffffffffc0207048 <default_pmm_manager+0xb28>
ffffffffc02047b4:	3ef00593          	li	a1,1007
ffffffffc02047b8:	00002517          	auipc	a0,0x2
ffffffffc02047bc:	7d050513          	addi	a0,a0,2000 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02047c0:	ccffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047c4:	00003697          	auipc	a3,0x3
ffffffffc02047c8:	95c68693          	addi	a3,a3,-1700 # ffffffffc0207120 <default_pmm_manager+0xc00>
ffffffffc02047cc:	00002617          	auipc	a2,0x2
ffffffffc02047d0:	9a460613          	addi	a2,a2,-1628 # ffffffffc0206170 <commands+0x828>
ffffffffc02047d4:	40a00593          	li	a1,1034
ffffffffc02047d8:	00002517          	auipc	a0,0x2
ffffffffc02047dc:	7b050513          	addi	a0,a0,1968 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc02047e0:	caffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02047e4:	00003697          	auipc	a3,0x3
ffffffffc02047e8:	90c68693          	addi	a3,a3,-1780 # ffffffffc02070f0 <default_pmm_manager+0xbd0>
ffffffffc02047ec:	00002617          	auipc	a2,0x2
ffffffffc02047f0:	98460613          	addi	a2,a2,-1660 # ffffffffc0206170 <commands+0x828>
ffffffffc02047f4:	40800593          	li	a1,1032
ffffffffc02047f8:	00002517          	auipc	a0,0x2
ffffffffc02047fc:	79050513          	addi	a0,a0,1936 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204800:	c8ffb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204804:	00003697          	auipc	a3,0x3
ffffffffc0204808:	8dc68693          	addi	a3,a3,-1828 # ffffffffc02070e0 <default_pmm_manager+0xbc0>
ffffffffc020480c:	00002617          	auipc	a2,0x2
ffffffffc0204810:	96460613          	addi	a2,a2,-1692 # ffffffffc0206170 <commands+0x828>
ffffffffc0204814:	40400593          	li	a1,1028
ffffffffc0204818:	00002517          	auipc	a0,0x2
ffffffffc020481c:	77050513          	addi	a0,a0,1904 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204820:	c6ffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204824 <do_execve>:
{
ffffffffc0204824:	7171                	addi	sp,sp,-176
ffffffffc0204826:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204828:	000a6d97          	auipc	s11,0xa6
ffffffffc020482c:	100d8d93          	addi	s11,s11,256 # ffffffffc02aa928 <current>
ffffffffc0204830:	000db783          	ld	a5,0(s11)
{
ffffffffc0204834:	e54e                	sd	s3,136(sp)
ffffffffc0204836:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204838:	0287b983          	ld	s3,40(a5)
{
ffffffffc020483c:	e94a                	sd	s2,144(sp)
ffffffffc020483e:	f4de                	sd	s7,104(sp)
ffffffffc0204840:	892a                	mv	s2,a0
ffffffffc0204842:	8bb2                	mv	s7,a2
ffffffffc0204844:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204846:	862e                	mv	a2,a1
ffffffffc0204848:	4681                	li	a3,0
ffffffffc020484a:	85aa                	mv	a1,a0
ffffffffc020484c:	854e                	mv	a0,s3
{
ffffffffc020484e:	f506                	sd	ra,168(sp)
ffffffffc0204850:	f122                	sd	s0,160(sp)
ffffffffc0204852:	e152                	sd	s4,128(sp)
ffffffffc0204854:	fcd6                	sd	s5,120(sp)
ffffffffc0204856:	f8da                	sd	s6,112(sp)
ffffffffc0204858:	f0e2                	sd	s8,96(sp)
ffffffffc020485a:	ece6                	sd	s9,88(sp)
ffffffffc020485c:	e8ea                	sd	s10,80(sp)
ffffffffc020485e:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204860:	cdeff0ef          	jal	ra,ffffffffc0203d3e <user_mem_check>
ffffffffc0204864:	40050a63          	beqz	a0,ffffffffc0204c78 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204868:	4641                	li	a2,16
ffffffffc020486a:	4581                	li	a1,0
ffffffffc020486c:	1808                	addi	a0,sp,48
ffffffffc020486e:	643000ef          	jal	ra,ffffffffc02056b0 <memset>
    memcpy(local_name, name, len);
ffffffffc0204872:	47bd                	li	a5,15
ffffffffc0204874:	8626                	mv	a2,s1
ffffffffc0204876:	1e97e263          	bltu	a5,s1,ffffffffc0204a5a <do_execve+0x236>
ffffffffc020487a:	85ca                	mv	a1,s2
ffffffffc020487c:	1808                	addi	a0,sp,48
ffffffffc020487e:	645000ef          	jal	ra,ffffffffc02056c2 <memcpy>
    if (mm != NULL)
ffffffffc0204882:	1e098363          	beqz	s3,ffffffffc0204a68 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204886:	00002517          	auipc	a0,0x2
ffffffffc020488a:	4ca50513          	addi	a0,a0,1226 # ffffffffc0206d50 <default_pmm_manager+0x830>
ffffffffc020488e:	93ffb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204892:	000a6797          	auipc	a5,0xa6
ffffffffc0204896:	0667b783          	ld	a5,102(a5) # ffffffffc02aa8f8 <boot_pgdir_pa>
ffffffffc020489a:	577d                	li	a4,-1
ffffffffc020489c:	177e                	slli	a4,a4,0x3f
ffffffffc020489e:	83b1                	srli	a5,a5,0xc
ffffffffc02048a0:	8fd9                	or	a5,a5,a4
ffffffffc02048a2:	18079073          	csrw	satp,a5
ffffffffc02048a6:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b98>
ffffffffc02048aa:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048ae:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02048b2:	2c070463          	beqz	a4,ffffffffc0204b7a <do_execve+0x356>
        current->mm = NULL;
ffffffffc02048b6:	000db783          	ld	a5,0(s11)
ffffffffc02048ba:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048be:	e0bfe0ef          	jal	ra,ffffffffc02036c8 <mm_create>
ffffffffc02048c2:	84aa                	mv	s1,a0
ffffffffc02048c4:	1c050d63          	beqz	a0,ffffffffc0204a9e <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc02048c8:	4505                	li	a0,1
ffffffffc02048ca:	ddafd0ef          	jal	ra,ffffffffc0201ea4 <alloc_pages>
ffffffffc02048ce:	3a050963          	beqz	a0,ffffffffc0204c80 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc02048d2:	000a6c97          	auipc	s9,0xa6
ffffffffc02048d6:	03ec8c93          	addi	s9,s9,62 # ffffffffc02aa910 <pages>
ffffffffc02048da:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc02048de:	000a6c17          	auipc	s8,0xa6
ffffffffc02048e2:	02ac0c13          	addi	s8,s8,42 # ffffffffc02aa908 <npage>
    return page - pages + nbase;
ffffffffc02048e6:	00003717          	auipc	a4,0x3
ffffffffc02048ea:	f5a73703          	ld	a4,-166(a4) # ffffffffc0207840 <nbase>
ffffffffc02048ee:	40d506b3          	sub	a3,a0,a3
ffffffffc02048f2:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02048f4:	5afd                	li	s5,-1
ffffffffc02048f6:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc02048fa:	96ba                	add	a3,a3,a4
ffffffffc02048fc:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc02048fe:	00cad713          	srli	a4,s5,0xc
ffffffffc0204902:	ec3a                	sd	a4,24(sp)
ffffffffc0204904:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204906:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204908:	38f77063          	bgeu	a4,a5,ffffffffc0204c88 <do_execve+0x464>
ffffffffc020490c:	000a6b17          	auipc	s6,0xa6
ffffffffc0204910:	014b0b13          	addi	s6,s6,20 # ffffffffc02aa920 <va_pa_offset>
ffffffffc0204914:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204918:	6605                	lui	a2,0x1
ffffffffc020491a:	000a6597          	auipc	a1,0xa6
ffffffffc020491e:	fe65b583          	ld	a1,-26(a1) # ffffffffc02aa900 <boot_pgdir_va>
ffffffffc0204922:	9936                	add	s2,s2,a3
ffffffffc0204924:	854a                	mv	a0,s2
ffffffffc0204926:	59d000ef          	jal	ra,ffffffffc02056c2 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020492a:	7782                	ld	a5,32(sp)
ffffffffc020492c:	4398                	lw	a4,0(a5)
ffffffffc020492e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204932:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204936:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b943f>
ffffffffc020493a:	14f71863          	bne	a4,a5,ffffffffc0204a8a <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020493e:	7682                	ld	a3,32(sp)
ffffffffc0204940:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204944:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204948:	00371793          	slli	a5,a4,0x3
ffffffffc020494c:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020494e:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204950:	078e                	slli	a5,a5,0x3
ffffffffc0204952:	97ce                	add	a5,a5,s3
ffffffffc0204954:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204956:	00f9fc63          	bgeu	s3,a5,ffffffffc020496e <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc020495a:	0009a783          	lw	a5,0(s3)
ffffffffc020495e:	4705                	li	a4,1
ffffffffc0204960:	14e78163          	beq	a5,a4,ffffffffc0204aa2 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204964:	77a2                	ld	a5,40(sp)
ffffffffc0204966:	03898993          	addi	s3,s3,56
ffffffffc020496a:	fef9e8e3          	bltu	s3,a5,ffffffffc020495a <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc020496e:	4701                	li	a4,0
ffffffffc0204970:	46ad                	li	a3,11
ffffffffc0204972:	00100637          	lui	a2,0x100
ffffffffc0204976:	7ff005b7          	lui	a1,0x7ff00
ffffffffc020497a:	8526                	mv	a0,s1
ffffffffc020497c:	edffe0ef          	jal	ra,ffffffffc020385a <mm_map>
ffffffffc0204980:	8a2a                	mv	s4,a0
ffffffffc0204982:	1e051263          	bnez	a0,ffffffffc0204b66 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204986:	6c88                	ld	a0,24(s1)
ffffffffc0204988:	467d                	li	a2,31
ffffffffc020498a:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc020498e:	c55fe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc0204992:	38050363          	beqz	a0,ffffffffc0204d18 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204996:	6c88                	ld	a0,24(s1)
ffffffffc0204998:	467d                	li	a2,31
ffffffffc020499a:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc020499e:	c45fe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc02049a2:	34050b63          	beqz	a0,ffffffffc0204cf8 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049a6:	6c88                	ld	a0,24(s1)
ffffffffc02049a8:	467d                	li	a2,31
ffffffffc02049aa:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049ae:	c35fe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc02049b2:	32050363          	beqz	a0,ffffffffc0204cd8 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049b6:	6c88                	ld	a0,24(s1)
ffffffffc02049b8:	467d                	li	a2,31
ffffffffc02049ba:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049be:	c25fe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc02049c2:	2e050b63          	beqz	a0,ffffffffc0204cb8 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc02049c6:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc02049c8:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049cc:	6c94                	ld	a3,24(s1)
ffffffffc02049ce:	2785                	addiw	a5,a5,1
ffffffffc02049d0:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc02049d2:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049d4:	c02007b7          	lui	a5,0xc0200
ffffffffc02049d8:	2cf6e463          	bltu	a3,a5,ffffffffc0204ca0 <do_execve+0x47c>
ffffffffc02049dc:	000b3783          	ld	a5,0(s6)
ffffffffc02049e0:	577d                	li	a4,-1
ffffffffc02049e2:	177e                	slli	a4,a4,0x3f
ffffffffc02049e4:	8e9d                	sub	a3,a3,a5
ffffffffc02049e6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02049ea:	f654                	sd	a3,168(a2)
ffffffffc02049ec:	8fd9                	or	a5,a5,a4
ffffffffc02049ee:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc02049f2:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc02049f4:	4581                	li	a1,0
ffffffffc02049f6:	12000613          	li	a2,288
ffffffffc02049fa:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc02049fc:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a00:	4b1000ef          	jal	ra,ffffffffc02056b0 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a04:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a06:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a0a:	edf4f493          	andi	s1,s1,-289
    tf->epc = elf->e_entry;
ffffffffc0204a0e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a10:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a12:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f74>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a16:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a18:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a1c:	4641                	li	a2,16
ffffffffc0204a1e:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a20:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204a22:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a26:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a2a:	854a                	mv	a0,s2
ffffffffc0204a2c:	485000ef          	jal	ra,ffffffffc02056b0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a30:	463d                	li	a2,15
ffffffffc0204a32:	180c                	addi	a1,sp,48
ffffffffc0204a34:	854a                	mv	a0,s2
ffffffffc0204a36:	48d000ef          	jal	ra,ffffffffc02056c2 <memcpy>
}
ffffffffc0204a3a:	70aa                	ld	ra,168(sp)
ffffffffc0204a3c:	740a                	ld	s0,160(sp)
ffffffffc0204a3e:	64ea                	ld	s1,152(sp)
ffffffffc0204a40:	694a                	ld	s2,144(sp)
ffffffffc0204a42:	69aa                	ld	s3,136(sp)
ffffffffc0204a44:	7ae6                	ld	s5,120(sp)
ffffffffc0204a46:	7b46                	ld	s6,112(sp)
ffffffffc0204a48:	7ba6                	ld	s7,104(sp)
ffffffffc0204a4a:	7c06                	ld	s8,96(sp)
ffffffffc0204a4c:	6ce6                	ld	s9,88(sp)
ffffffffc0204a4e:	6d46                	ld	s10,80(sp)
ffffffffc0204a50:	6da6                	ld	s11,72(sp)
ffffffffc0204a52:	8552                	mv	a0,s4
ffffffffc0204a54:	6a0a                	ld	s4,128(sp)
ffffffffc0204a56:	614d                	addi	sp,sp,176
ffffffffc0204a58:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a5a:	463d                	li	a2,15
ffffffffc0204a5c:	85ca                	mv	a1,s2
ffffffffc0204a5e:	1808                	addi	a0,sp,48
ffffffffc0204a60:	463000ef          	jal	ra,ffffffffc02056c2 <memcpy>
    if (mm != NULL)
ffffffffc0204a64:	e20991e3          	bnez	s3,ffffffffc0204886 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a68:	000db783          	ld	a5,0(s11)
ffffffffc0204a6c:	779c                	ld	a5,40(a5)
ffffffffc0204a6e:	e40788e3          	beqz	a5,ffffffffc02048be <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a72:	00002617          	auipc	a2,0x2
ffffffffc0204a76:	6fe60613          	addi	a2,a2,1790 # ffffffffc0207170 <default_pmm_manager+0xc50>
ffffffffc0204a7a:	25600593          	li	a1,598
ffffffffc0204a7e:	00002517          	auipc	a0,0x2
ffffffffc0204a82:	50a50513          	addi	a0,a0,1290 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204a86:	a09fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204a8a:	8526                	mv	a0,s1
ffffffffc0204a8c:	c5cff0ef          	jal	ra,ffffffffc0203ee8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204a90:	8526                	mv	a0,s1
ffffffffc0204a92:	d77fe0ef          	jal	ra,ffffffffc0203808 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204a96:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204a98:	8552                	mv	a0,s4
ffffffffc0204a9a:	94bff0ef          	jal	ra,ffffffffc02043e4 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204a9e:	5a71                	li	s4,-4
ffffffffc0204aa0:	bfe5                	j	ffffffffc0204a98 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204aa2:	0289b603          	ld	a2,40(s3)
ffffffffc0204aa6:	0209b783          	ld	a5,32(s3)
ffffffffc0204aaa:	1cf66d63          	bltu	a2,a5,ffffffffc0204c84 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204aae:	0049a783          	lw	a5,4(s3)
ffffffffc0204ab2:	0017f693          	andi	a3,a5,1
ffffffffc0204ab6:	c291                	beqz	a3,ffffffffc0204aba <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204ab8:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204aba:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204abe:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ac0:	e779                	bnez	a4,ffffffffc0204b8e <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204ac2:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ac4:	c781                	beqz	a5,ffffffffc0204acc <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204ac6:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204aca:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204acc:	0026f793          	andi	a5,a3,2
ffffffffc0204ad0:	e3f1                	bnez	a5,ffffffffc0204b94 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204ad2:	0046f793          	andi	a5,a3,4
ffffffffc0204ad6:	c399                	beqz	a5,ffffffffc0204adc <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204ad8:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204adc:	0109b583          	ld	a1,16(s3)
ffffffffc0204ae0:	4701                	li	a4,0
ffffffffc0204ae2:	8526                	mv	a0,s1
ffffffffc0204ae4:	d77fe0ef          	jal	ra,ffffffffc020385a <mm_map>
ffffffffc0204ae8:	8a2a                	mv	s4,a0
ffffffffc0204aea:	ed35                	bnez	a0,ffffffffc0204b66 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204aec:	0109bb83          	ld	s7,16(s3)
ffffffffc0204af0:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204af2:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204af6:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204afa:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204afe:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b00:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b02:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204b04:	054be963          	bltu	s7,s4,ffffffffc0204b56 <do_execve+0x332>
ffffffffc0204b08:	aa95                	j	ffffffffc0204c7c <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b0a:	6785                	lui	a5,0x1
ffffffffc0204b0c:	415b8533          	sub	a0,s7,s5
ffffffffc0204b10:	9abe                	add	s5,s5,a5
ffffffffc0204b12:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b16:	015a7463          	bgeu	s4,s5,ffffffffc0204b1e <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204b1a:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204b1e:	000cb683          	ld	a3,0(s9)
ffffffffc0204b22:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b24:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b28:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b2c:	8699                	srai	a3,a3,0x6
ffffffffc0204b2e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b30:	67e2                	ld	a5,24(sp)
ffffffffc0204b32:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b36:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b38:	14b87863          	bgeu	a6,a1,ffffffffc0204c88 <do_execve+0x464>
ffffffffc0204b3c:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b40:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204b42:	9bb2                	add	s7,s7,a2
ffffffffc0204b44:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b46:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b48:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b4a:	379000ef          	jal	ra,ffffffffc02056c2 <memcpy>
            start += size, from += size;
ffffffffc0204b4e:	6622                	ld	a2,8(sp)
ffffffffc0204b50:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b52:	054bf363          	bgeu	s7,s4,ffffffffc0204b98 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b56:	6c88                	ld	a0,24(s1)
ffffffffc0204b58:	866a                	mv	a2,s10
ffffffffc0204b5a:	85d6                	mv	a1,s5
ffffffffc0204b5c:	a87fe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc0204b60:	842a                	mv	s0,a0
ffffffffc0204b62:	f545                	bnez	a0,ffffffffc0204b0a <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204b64:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204b66:	8526                	mv	a0,s1
ffffffffc0204b68:	e3dfe0ef          	jal	ra,ffffffffc02039a4 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b6c:	8526                	mv	a0,s1
ffffffffc0204b6e:	b7aff0ef          	jal	ra,ffffffffc0203ee8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b72:	8526                	mv	a0,s1
ffffffffc0204b74:	c95fe0ef          	jal	ra,ffffffffc0203808 <mm_destroy>
    return ret;
ffffffffc0204b78:	b705                	j	ffffffffc0204a98 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204b7a:	854e                	mv	a0,s3
ffffffffc0204b7c:	e29fe0ef          	jal	ra,ffffffffc02039a4 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204b80:	854e                	mv	a0,s3
ffffffffc0204b82:	b66ff0ef          	jal	ra,ffffffffc0203ee8 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204b86:	854e                	mv	a0,s3
ffffffffc0204b88:	c81fe0ef          	jal	ra,ffffffffc0203808 <mm_destroy>
ffffffffc0204b8c:	b32d                	j	ffffffffc02048b6 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204b8e:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204b92:	fb95                	bnez	a5,ffffffffc0204ac6 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204b94:	4d5d                	li	s10,23
ffffffffc0204b96:	bf35                	j	ffffffffc0204ad2 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204b98:	0109b683          	ld	a3,16(s3)
ffffffffc0204b9c:	0289b903          	ld	s2,40(s3)
ffffffffc0204ba0:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204ba2:	075bfd63          	bgeu	s7,s5,ffffffffc0204c1c <do_execve+0x3f8>
            if (start == end)
ffffffffc0204ba6:	db790fe3          	beq	s2,s7,ffffffffc0204964 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204baa:	6785                	lui	a5,0x1
ffffffffc0204bac:	00fb8533          	add	a0,s7,a5
ffffffffc0204bb0:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204bb4:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204bb8:	0b597d63          	bgeu	s2,s5,ffffffffc0204c72 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204bbc:	000cb683          	ld	a3,0(s9)
ffffffffc0204bc0:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bc2:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204bc6:	40d406b3          	sub	a3,s0,a3
ffffffffc0204bca:	8699                	srai	a3,a3,0x6
ffffffffc0204bcc:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204bce:	67e2                	ld	a5,24(sp)
ffffffffc0204bd0:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bd4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bd6:	0ac5f963          	bgeu	a1,a2,ffffffffc0204c88 <do_execve+0x464>
ffffffffc0204bda:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bde:	8652                	mv	a2,s4
ffffffffc0204be0:	4581                	li	a1,0
ffffffffc0204be2:	96c2                	add	a3,a3,a6
ffffffffc0204be4:	9536                	add	a0,a0,a3
ffffffffc0204be6:	2cb000ef          	jal	ra,ffffffffc02056b0 <memset>
            start += size;
ffffffffc0204bea:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204bee:	03597463          	bgeu	s2,s5,ffffffffc0204c16 <do_execve+0x3f2>
ffffffffc0204bf2:	d6e909e3          	beq	s2,a4,ffffffffc0204964 <do_execve+0x140>
ffffffffc0204bf6:	00002697          	auipc	a3,0x2
ffffffffc0204bfa:	5a268693          	addi	a3,a3,1442 # ffffffffc0207198 <default_pmm_manager+0xc78>
ffffffffc0204bfe:	00001617          	auipc	a2,0x1
ffffffffc0204c02:	57260613          	addi	a2,a2,1394 # ffffffffc0206170 <commands+0x828>
ffffffffc0204c06:	2bf00593          	li	a1,703
ffffffffc0204c0a:	00002517          	auipc	a0,0x2
ffffffffc0204c0e:	37e50513          	addi	a0,a0,894 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204c12:	87dfb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204c16:	ff5710e3          	bne	a4,s5,ffffffffc0204bf6 <do_execve+0x3d2>
ffffffffc0204c1a:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204c1c:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204964 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c20:	6c88                	ld	a0,24(s1)
ffffffffc0204c22:	866a                	mv	a2,s10
ffffffffc0204c24:	85d6                	mv	a1,s5
ffffffffc0204c26:	9bdfe0ef          	jal	ra,ffffffffc02035e2 <pgdir_alloc_page>
ffffffffc0204c2a:	842a                	mv	s0,a0
ffffffffc0204c2c:	dd05                	beqz	a0,ffffffffc0204b64 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c2e:	6785                	lui	a5,0x1
ffffffffc0204c30:	415b8533          	sub	a0,s7,s5
ffffffffc0204c34:	9abe                	add	s5,s5,a5
ffffffffc0204c36:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c3a:	01597463          	bgeu	s2,s5,ffffffffc0204c42 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204c3e:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204c42:	000cb683          	ld	a3,0(s9)
ffffffffc0204c46:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c48:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c4c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c50:	8699                	srai	a3,a3,0x6
ffffffffc0204c52:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c54:	67e2                	ld	a5,24(sp)
ffffffffc0204c56:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c5a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c5c:	02b87663          	bgeu	a6,a1,ffffffffc0204c88 <do_execve+0x464>
ffffffffc0204c60:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c64:	4581                	li	a1,0
            start += size;
ffffffffc0204c66:	9bb2                	add	s7,s7,a2
ffffffffc0204c68:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c6a:	9536                	add	a0,a0,a3
ffffffffc0204c6c:	245000ef          	jal	ra,ffffffffc02056b0 <memset>
ffffffffc0204c70:	b775                	j	ffffffffc0204c1c <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c72:	417a8a33          	sub	s4,s5,s7
ffffffffc0204c76:	b799                	j	ffffffffc0204bbc <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204c78:	5a75                	li	s4,-3
ffffffffc0204c7a:	b3c1                	j	ffffffffc0204a3a <do_execve+0x216>
        while (start < end)
ffffffffc0204c7c:	86de                	mv	a3,s7
ffffffffc0204c7e:	bf39                	j	ffffffffc0204b9c <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204c80:	5a71                	li	s4,-4
ffffffffc0204c82:	bdc5                	j	ffffffffc0204b72 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204c84:	5a61                	li	s4,-8
ffffffffc0204c86:	b5c5                	j	ffffffffc0204b66 <do_execve+0x342>
ffffffffc0204c88:	00002617          	auipc	a2,0x2
ffffffffc0204c8c:	8d060613          	addi	a2,a2,-1840 # ffffffffc0206558 <default_pmm_manager+0x38>
ffffffffc0204c90:	07100593          	li	a1,113
ffffffffc0204c94:	00002517          	auipc	a0,0x2
ffffffffc0204c98:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0206580 <default_pmm_manager+0x60>
ffffffffc0204c9c:	ff2fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ca0:	00002617          	auipc	a2,0x2
ffffffffc0204ca4:	96060613          	addi	a2,a2,-1696 # ffffffffc0206600 <default_pmm_manager+0xe0>
ffffffffc0204ca8:	2de00593          	li	a1,734
ffffffffc0204cac:	00002517          	auipc	a0,0x2
ffffffffc0204cb0:	2dc50513          	addi	a0,a0,732 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204cb4:	fdafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cb8:	00002697          	auipc	a3,0x2
ffffffffc0204cbc:	5f868693          	addi	a3,a3,1528 # ffffffffc02072b0 <default_pmm_manager+0xd90>
ffffffffc0204cc0:	00001617          	auipc	a2,0x1
ffffffffc0204cc4:	4b060613          	addi	a2,a2,1200 # ffffffffc0206170 <commands+0x828>
ffffffffc0204cc8:	2d900593          	li	a1,729
ffffffffc0204ccc:	00002517          	auipc	a0,0x2
ffffffffc0204cd0:	2bc50513          	addi	a0,a0,700 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204cd4:	fbafb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cd8:	00002697          	auipc	a3,0x2
ffffffffc0204cdc:	59068693          	addi	a3,a3,1424 # ffffffffc0207268 <default_pmm_manager+0xd48>
ffffffffc0204ce0:	00001617          	auipc	a2,0x1
ffffffffc0204ce4:	49060613          	addi	a2,a2,1168 # ffffffffc0206170 <commands+0x828>
ffffffffc0204ce8:	2d800593          	li	a1,728
ffffffffc0204cec:	00002517          	auipc	a0,0x2
ffffffffc0204cf0:	29c50513          	addi	a0,a0,668 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204cf4:	f9afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cf8:	00002697          	auipc	a3,0x2
ffffffffc0204cfc:	52868693          	addi	a3,a3,1320 # ffffffffc0207220 <default_pmm_manager+0xd00>
ffffffffc0204d00:	00001617          	auipc	a2,0x1
ffffffffc0204d04:	47060613          	addi	a2,a2,1136 # ffffffffc0206170 <commands+0x828>
ffffffffc0204d08:	2d700593          	li	a1,727
ffffffffc0204d0c:	00002517          	auipc	a0,0x2
ffffffffc0204d10:	27c50513          	addi	a0,a0,636 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204d14:	f7afb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d18:	00002697          	auipc	a3,0x2
ffffffffc0204d1c:	4c068693          	addi	a3,a3,1216 # ffffffffc02071d8 <default_pmm_manager+0xcb8>
ffffffffc0204d20:	00001617          	auipc	a2,0x1
ffffffffc0204d24:	45060613          	addi	a2,a2,1104 # ffffffffc0206170 <commands+0x828>
ffffffffc0204d28:	2d600593          	li	a1,726
ffffffffc0204d2c:	00002517          	auipc	a0,0x2
ffffffffc0204d30:	25c50513          	addi	a0,a0,604 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204d34:	f5afb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204d38 <do_yield>:
    current->need_resched = 1;
ffffffffc0204d38:	000a6797          	auipc	a5,0xa6
ffffffffc0204d3c:	bf07b783          	ld	a5,-1040(a5) # ffffffffc02aa928 <current>
ffffffffc0204d40:	4705                	li	a4,1
ffffffffc0204d42:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d44:	4501                	li	a0,0
ffffffffc0204d46:	8082                	ret

ffffffffc0204d48 <do_wait>:
{
ffffffffc0204d48:	1101                	addi	sp,sp,-32
ffffffffc0204d4a:	e822                	sd	s0,16(sp)
ffffffffc0204d4c:	e426                	sd	s1,8(sp)
ffffffffc0204d4e:	ec06                	sd	ra,24(sp)
ffffffffc0204d50:	842e                	mv	s0,a1
ffffffffc0204d52:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d54:	c999                	beqz	a1,ffffffffc0204d6a <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d56:	000a6797          	auipc	a5,0xa6
ffffffffc0204d5a:	bd27b783          	ld	a5,-1070(a5) # ffffffffc02aa928 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d5e:	7788                	ld	a0,40(a5)
ffffffffc0204d60:	4685                	li	a3,1
ffffffffc0204d62:	4611                	li	a2,4
ffffffffc0204d64:	fdbfe0ef          	jal	ra,ffffffffc0203d3e <user_mem_check>
ffffffffc0204d68:	c909                	beqz	a0,ffffffffc0204d7a <do_wait+0x32>
ffffffffc0204d6a:	85a2                	mv	a1,s0
}
ffffffffc0204d6c:	6442                	ld	s0,16(sp)
ffffffffc0204d6e:	60e2                	ld	ra,24(sp)
ffffffffc0204d70:	8526                	mv	a0,s1
ffffffffc0204d72:	64a2                	ld	s1,8(sp)
ffffffffc0204d74:	6105                	addi	sp,sp,32
ffffffffc0204d76:	fb8ff06f          	j	ffffffffc020452e <do_wait.part.0>
ffffffffc0204d7a:	60e2                	ld	ra,24(sp)
ffffffffc0204d7c:	6442                	ld	s0,16(sp)
ffffffffc0204d7e:	64a2                	ld	s1,8(sp)
ffffffffc0204d80:	5575                	li	a0,-3
ffffffffc0204d82:	6105                	addi	sp,sp,32
ffffffffc0204d84:	8082                	ret

ffffffffc0204d86 <do_kill>:
{
ffffffffc0204d86:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d88:	6789                	lui	a5,0x2
{
ffffffffc0204d8a:	e406                	sd	ra,8(sp)
ffffffffc0204d8c:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204d8e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204d92:	17f9                	addi	a5,a5,-2
ffffffffc0204d94:	02e7e963          	bltu	a5,a4,ffffffffc0204dc6 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204d98:	842a                	mv	s0,a0
ffffffffc0204d9a:	45a9                	li	a1,10
ffffffffc0204d9c:	2501                	sext.w	a0,a0
ffffffffc0204d9e:	46c000ef          	jal	ra,ffffffffc020520a <hash32>
ffffffffc0204da2:	02051793          	slli	a5,a0,0x20
ffffffffc0204da6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204daa:	000a2797          	auipc	a5,0xa2
ffffffffc0204dae:	b0678793          	addi	a5,a5,-1274 # ffffffffc02a68b0 <hash_list>
ffffffffc0204db2:	953e                	add	a0,a0,a5
ffffffffc0204db4:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204db6:	a029                	j	ffffffffc0204dc0 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204db8:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204dbc:	00870b63          	beq	a4,s0,ffffffffc0204dd2 <do_kill+0x4c>
ffffffffc0204dc0:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204dc2:	fef51be3          	bne	a0,a5,ffffffffc0204db8 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204dc6:	5475                	li	s0,-3
}
ffffffffc0204dc8:	60a2                	ld	ra,8(sp)
ffffffffc0204dca:	8522                	mv	a0,s0
ffffffffc0204dcc:	6402                	ld	s0,0(sp)
ffffffffc0204dce:	0141                	addi	sp,sp,16
ffffffffc0204dd0:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204dd2:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204dd6:	00177693          	andi	a3,a4,1
ffffffffc0204dda:	e295                	bnez	a3,ffffffffc0204dfe <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204ddc:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204dde:	00176713          	ori	a4,a4,1
ffffffffc0204de2:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204de6:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204de8:	fe06d0e3          	bgez	a3,ffffffffc0204dc8 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204dec:	f2878513          	addi	a0,a5,-216
ffffffffc0204df0:	22e000ef          	jal	ra,ffffffffc020501e <wakeup_proc>
}
ffffffffc0204df4:	60a2                	ld	ra,8(sp)
ffffffffc0204df6:	8522                	mv	a0,s0
ffffffffc0204df8:	6402                	ld	s0,0(sp)
ffffffffc0204dfa:	0141                	addi	sp,sp,16
ffffffffc0204dfc:	8082                	ret
        return -E_KILLED;
ffffffffc0204dfe:	545d                	li	s0,-9
ffffffffc0204e00:	b7e1                	j	ffffffffc0204dc8 <do_kill+0x42>

ffffffffc0204e02 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204e02:	1101                	addi	sp,sp,-32
ffffffffc0204e04:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204e06:	000a6797          	auipc	a5,0xa6
ffffffffc0204e0a:	aaa78793          	addi	a5,a5,-1366 # ffffffffc02aa8b0 <proc_list>
ffffffffc0204e0e:	ec06                	sd	ra,24(sp)
ffffffffc0204e10:	e822                	sd	s0,16(sp)
ffffffffc0204e12:	e04a                	sd	s2,0(sp)
ffffffffc0204e14:	000a2497          	auipc	s1,0xa2
ffffffffc0204e18:	a9c48493          	addi	s1,s1,-1380 # ffffffffc02a68b0 <hash_list>
ffffffffc0204e1c:	e79c                	sd	a5,8(a5)
ffffffffc0204e1e:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e20:	000a6717          	auipc	a4,0xa6
ffffffffc0204e24:	a9070713          	addi	a4,a4,-1392 # ffffffffc02aa8b0 <proc_list>
ffffffffc0204e28:	87a6                	mv	a5,s1
ffffffffc0204e2a:	e79c                	sd	a5,8(a5)
ffffffffc0204e2c:	e39c                	sd	a5,0(a5)
ffffffffc0204e2e:	07c1                	addi	a5,a5,16
ffffffffc0204e30:	fef71de3          	bne	a4,a5,ffffffffc0204e2a <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e34:	fa7fe0ef          	jal	ra,ffffffffc0203dda <alloc_proc>
ffffffffc0204e38:	000a6917          	auipc	s2,0xa6
ffffffffc0204e3c:	af890913          	addi	s2,s2,-1288 # ffffffffc02aa930 <idleproc>
ffffffffc0204e40:	00a93023          	sd	a0,0(s2)
ffffffffc0204e44:	0e050f63          	beqz	a0,ffffffffc0204f42 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e48:	4789                	li	a5,2
ffffffffc0204e4a:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e4c:	00003797          	auipc	a5,0x3
ffffffffc0204e50:	1b478793          	addi	a5,a5,436 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e54:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e58:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e5a:	4785                	li	a5,1
ffffffffc0204e5c:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e5e:	4641                	li	a2,16
ffffffffc0204e60:	4581                	li	a1,0
ffffffffc0204e62:	8522                	mv	a0,s0
ffffffffc0204e64:	04d000ef          	jal	ra,ffffffffc02056b0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e68:	463d                	li	a2,15
ffffffffc0204e6a:	00002597          	auipc	a1,0x2
ffffffffc0204e6e:	4a658593          	addi	a1,a1,1190 # ffffffffc0207310 <default_pmm_manager+0xdf0>
ffffffffc0204e72:	8522                	mv	a0,s0
ffffffffc0204e74:	04f000ef          	jal	ra,ffffffffc02056c2 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e78:	000a6717          	auipc	a4,0xa6
ffffffffc0204e7c:	ac870713          	addi	a4,a4,-1336 # ffffffffc02aa940 <nr_process>
ffffffffc0204e80:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204e82:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e86:	4601                	li	a2,0
    nr_process++;
ffffffffc0204e88:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e8a:	4581                	li	a1,0
ffffffffc0204e8c:	00000517          	auipc	a0,0x0
ffffffffc0204e90:	87450513          	addi	a0,a0,-1932 # ffffffffc0204700 <init_main>
    nr_process++;
ffffffffc0204e94:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204e96:	000a6797          	auipc	a5,0xa6
ffffffffc0204e9a:	a8d7b923          	sd	a3,-1390(a5) # ffffffffc02aa928 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204e9e:	cf6ff0ef          	jal	ra,ffffffffc0204394 <kernel_thread>
ffffffffc0204ea2:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ea4:	08a05363          	blez	a0,ffffffffc0204f2a <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ea8:	6789                	lui	a5,0x2
ffffffffc0204eaa:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204eae:	17f9                	addi	a5,a5,-2
ffffffffc0204eb0:	2501                	sext.w	a0,a0
ffffffffc0204eb2:	02e7e363          	bltu	a5,a4,ffffffffc0204ed8 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204eb6:	45a9                	li	a1,10
ffffffffc0204eb8:	352000ef          	jal	ra,ffffffffc020520a <hash32>
ffffffffc0204ebc:	02051793          	slli	a5,a0,0x20
ffffffffc0204ec0:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204ec4:	96a6                	add	a3,a3,s1
ffffffffc0204ec6:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204ec8:	a029                	j	ffffffffc0204ed2 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204eca:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c9c>
ffffffffc0204ece:	04870b63          	beq	a4,s0,ffffffffc0204f24 <proc_init+0x122>
    return listelm->next;
ffffffffc0204ed2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204ed4:	fef69be3          	bne	a3,a5,ffffffffc0204eca <proc_init+0xc8>
    return NULL;
ffffffffc0204ed8:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204eda:	0b478493          	addi	s1,a5,180
ffffffffc0204ede:	4641                	li	a2,16
ffffffffc0204ee0:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204ee2:	000a6417          	auipc	s0,0xa6
ffffffffc0204ee6:	a5640413          	addi	s0,s0,-1450 # ffffffffc02aa938 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204eea:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204eec:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204eee:	7c2000ef          	jal	ra,ffffffffc02056b0 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204ef2:	463d                	li	a2,15
ffffffffc0204ef4:	00002597          	auipc	a1,0x2
ffffffffc0204ef8:	44458593          	addi	a1,a1,1092 # ffffffffc0207338 <default_pmm_manager+0xe18>
ffffffffc0204efc:	8526                	mv	a0,s1
ffffffffc0204efe:	7c4000ef          	jal	ra,ffffffffc02056c2 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f02:	00093783          	ld	a5,0(s2)
ffffffffc0204f06:	cbb5                	beqz	a5,ffffffffc0204f7a <proc_init+0x178>
ffffffffc0204f08:	43dc                	lw	a5,4(a5)
ffffffffc0204f0a:	eba5                	bnez	a5,ffffffffc0204f7a <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f0c:	601c                	ld	a5,0(s0)
ffffffffc0204f0e:	c7b1                	beqz	a5,ffffffffc0204f5a <proc_init+0x158>
ffffffffc0204f10:	43d8                	lw	a4,4(a5)
ffffffffc0204f12:	4785                	li	a5,1
ffffffffc0204f14:	04f71363          	bne	a4,a5,ffffffffc0204f5a <proc_init+0x158>
}
ffffffffc0204f18:	60e2                	ld	ra,24(sp)
ffffffffc0204f1a:	6442                	ld	s0,16(sp)
ffffffffc0204f1c:	64a2                	ld	s1,8(sp)
ffffffffc0204f1e:	6902                	ld	s2,0(sp)
ffffffffc0204f20:	6105                	addi	sp,sp,32
ffffffffc0204f22:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f24:	f2878793          	addi	a5,a5,-216
ffffffffc0204f28:	bf4d                	j	ffffffffc0204eda <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f2a:	00002617          	auipc	a2,0x2
ffffffffc0204f2e:	3ee60613          	addi	a2,a2,1006 # ffffffffc0207318 <default_pmm_manager+0xdf8>
ffffffffc0204f32:	42e00593          	li	a1,1070
ffffffffc0204f36:	00002517          	auipc	a0,0x2
ffffffffc0204f3a:	05250513          	addi	a0,a0,82 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204f3e:	d50fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f42:	00002617          	auipc	a2,0x2
ffffffffc0204f46:	3b660613          	addi	a2,a2,950 # ffffffffc02072f8 <default_pmm_manager+0xdd8>
ffffffffc0204f4a:	41f00593          	li	a1,1055
ffffffffc0204f4e:	00002517          	auipc	a0,0x2
ffffffffc0204f52:	03a50513          	addi	a0,a0,58 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204f56:	d38fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f5a:	00002697          	auipc	a3,0x2
ffffffffc0204f5e:	40e68693          	addi	a3,a3,1038 # ffffffffc0207368 <default_pmm_manager+0xe48>
ffffffffc0204f62:	00001617          	auipc	a2,0x1
ffffffffc0204f66:	20e60613          	addi	a2,a2,526 # ffffffffc0206170 <commands+0x828>
ffffffffc0204f6a:	43500593          	li	a1,1077
ffffffffc0204f6e:	00002517          	auipc	a0,0x2
ffffffffc0204f72:	01a50513          	addi	a0,a0,26 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204f76:	d18fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f7a:	00002697          	auipc	a3,0x2
ffffffffc0204f7e:	3c668693          	addi	a3,a3,966 # ffffffffc0207340 <default_pmm_manager+0xe20>
ffffffffc0204f82:	00001617          	auipc	a2,0x1
ffffffffc0204f86:	1ee60613          	addi	a2,a2,494 # ffffffffc0206170 <commands+0x828>
ffffffffc0204f8a:	43400593          	li	a1,1076
ffffffffc0204f8e:	00002517          	auipc	a0,0x2
ffffffffc0204f92:	ffa50513          	addi	a0,a0,-6 # ffffffffc0206f88 <default_pmm_manager+0xa68>
ffffffffc0204f96:	cf8fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204f9a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204f9a:	1141                	addi	sp,sp,-16
ffffffffc0204f9c:	e022                	sd	s0,0(sp)
ffffffffc0204f9e:	e406                	sd	ra,8(sp)
ffffffffc0204fa0:	000a6417          	auipc	s0,0xa6
ffffffffc0204fa4:	98840413          	addi	s0,s0,-1656 # ffffffffc02aa928 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204fa8:	6018                	ld	a4,0(s0)
ffffffffc0204faa:	6f1c                	ld	a5,24(a4)
ffffffffc0204fac:	dffd                	beqz	a5,ffffffffc0204faa <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204fae:	0f0000ef          	jal	ra,ffffffffc020509e <schedule>
ffffffffc0204fb2:	bfdd                	j	ffffffffc0204fa8 <cpu_idle+0xe>

ffffffffc0204fb4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204fb4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204fb8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204fbc:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204fbe:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204fc0:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204fc4:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204fc8:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204fcc:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204fd0:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204fd4:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204fd8:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204fdc:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204fe0:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204fe4:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204fe8:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204fec:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204ff0:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204ff2:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204ff4:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204ff8:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204ffc:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205000:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205004:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205008:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020500c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205010:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205014:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205018:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020501c:	8082                	ret

ffffffffc020501e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020501e:	4118                	lw	a4,0(a0)
{
ffffffffc0205020:	1101                	addi	sp,sp,-32
ffffffffc0205022:	ec06                	sd	ra,24(sp)
ffffffffc0205024:	e822                	sd	s0,16(sp)
ffffffffc0205026:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205028:	478d                	li	a5,3
ffffffffc020502a:	04f70b63          	beq	a4,a5,ffffffffc0205080 <wakeup_proc+0x62>
ffffffffc020502e:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205030:	100027f3          	csrr	a5,sstatus
ffffffffc0205034:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205036:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205038:	ef9d                	bnez	a5,ffffffffc0205076 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020503a:	4789                	li	a5,2
ffffffffc020503c:	02f70163          	beq	a4,a5,ffffffffc020505e <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205040:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205042:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205046:	e491                	bnez	s1,ffffffffc0205052 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205048:	60e2                	ld	ra,24(sp)
ffffffffc020504a:	6442                	ld	s0,16(sp)
ffffffffc020504c:	64a2                	ld	s1,8(sp)
ffffffffc020504e:	6105                	addi	sp,sp,32
ffffffffc0205050:	8082                	ret
ffffffffc0205052:	6442                	ld	s0,16(sp)
ffffffffc0205054:	60e2                	ld	ra,24(sp)
ffffffffc0205056:	64a2                	ld	s1,8(sp)
ffffffffc0205058:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020505a:	955fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020505e:	00002617          	auipc	a2,0x2
ffffffffc0205062:	36a60613          	addi	a2,a2,874 # ffffffffc02073c8 <default_pmm_manager+0xea8>
ffffffffc0205066:	45d1                	li	a1,20
ffffffffc0205068:	00002517          	auipc	a0,0x2
ffffffffc020506c:	34850513          	addi	a0,a0,840 # ffffffffc02073b0 <default_pmm_manager+0xe90>
ffffffffc0205070:	c86fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205074:	bfc9                	j	ffffffffc0205046 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205076:	93ffb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020507a:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020507c:	4485                	li	s1,1
ffffffffc020507e:	bf75                	j	ffffffffc020503a <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205080:	00002697          	auipc	a3,0x2
ffffffffc0205084:	31068693          	addi	a3,a3,784 # ffffffffc0207390 <default_pmm_manager+0xe70>
ffffffffc0205088:	00001617          	auipc	a2,0x1
ffffffffc020508c:	0e860613          	addi	a2,a2,232 # ffffffffc0206170 <commands+0x828>
ffffffffc0205090:	45a5                	li	a1,9
ffffffffc0205092:	00002517          	auipc	a0,0x2
ffffffffc0205096:	31e50513          	addi	a0,a0,798 # ffffffffc02073b0 <default_pmm_manager+0xe90>
ffffffffc020509a:	bf4fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020509e <schedule>:

void schedule(void)
{
ffffffffc020509e:	1141                	addi	sp,sp,-16
ffffffffc02050a0:	e406                	sd	ra,8(sp)
ffffffffc02050a2:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050a4:	100027f3          	csrr	a5,sstatus
ffffffffc02050a8:	8b89                	andi	a5,a5,2
ffffffffc02050aa:	4401                	li	s0,0
ffffffffc02050ac:	efbd                	bnez	a5,ffffffffc020512a <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02050ae:	000a6897          	auipc	a7,0xa6
ffffffffc02050b2:	87a8b883          	ld	a7,-1926(a7) # ffffffffc02aa928 <current>
ffffffffc02050b6:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050ba:	000a6517          	auipc	a0,0xa6
ffffffffc02050be:	87653503          	ld	a0,-1930(a0) # ffffffffc02aa930 <idleproc>
ffffffffc02050c2:	04a88e63          	beq	a7,a0,ffffffffc020511e <schedule+0x80>
ffffffffc02050c6:	0c888693          	addi	a3,a7,200
ffffffffc02050ca:	000a5617          	auipc	a2,0xa5
ffffffffc02050ce:	7e660613          	addi	a2,a2,2022 # ffffffffc02aa8b0 <proc_list>
        le = last;
ffffffffc02050d2:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02050d4:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02050d6:	4809                	li	a6,2
ffffffffc02050d8:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02050da:	00c78863          	beq	a5,a2,ffffffffc02050ea <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02050de:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02050e2:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02050e6:	03070163          	beq	a4,a6,ffffffffc0205108 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02050ea:	fef697e3          	bne	a3,a5,ffffffffc02050d8 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050ee:	ed89                	bnez	a1,ffffffffc0205108 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02050f0:	451c                	lw	a5,8(a0)
ffffffffc02050f2:	2785                	addiw	a5,a5,1
ffffffffc02050f4:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02050f6:	00a88463          	beq	a7,a0,ffffffffc02050fe <schedule+0x60>
        {
            proc_run(next);
ffffffffc02050fa:	e65fe0ef          	jal	ra,ffffffffc0203f5e <proc_run>
    if (flag)
ffffffffc02050fe:	e819                	bnez	s0,ffffffffc0205114 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205100:	60a2                	ld	ra,8(sp)
ffffffffc0205102:	6402                	ld	s0,0(sp)
ffffffffc0205104:	0141                	addi	sp,sp,16
ffffffffc0205106:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205108:	4198                	lw	a4,0(a1)
ffffffffc020510a:	4789                	li	a5,2
ffffffffc020510c:	fef712e3          	bne	a4,a5,ffffffffc02050f0 <schedule+0x52>
ffffffffc0205110:	852e                	mv	a0,a1
ffffffffc0205112:	bff9                	j	ffffffffc02050f0 <schedule+0x52>
}
ffffffffc0205114:	6402                	ld	s0,0(sp)
ffffffffc0205116:	60a2                	ld	ra,8(sp)
ffffffffc0205118:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020511a:	895fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020511e:	000a5617          	auipc	a2,0xa5
ffffffffc0205122:	79260613          	addi	a2,a2,1938 # ffffffffc02aa8b0 <proc_list>
ffffffffc0205126:	86b2                	mv	a3,a2
ffffffffc0205128:	b76d                	j	ffffffffc02050d2 <schedule+0x34>
        intr_disable();
ffffffffc020512a:	88bfb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020512e:	4405                	li	s0,1
ffffffffc0205130:	bfbd                	j	ffffffffc02050ae <schedule+0x10>

ffffffffc0205132 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205132:	000a5797          	auipc	a5,0xa5
ffffffffc0205136:	7f67b783          	ld	a5,2038(a5) # ffffffffc02aa928 <current>
}
ffffffffc020513a:	43c8                	lw	a0,4(a5)
ffffffffc020513c:	8082                	ret

ffffffffc020513e <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020513e:	4501                	li	a0,0
ffffffffc0205140:	8082                	ret

ffffffffc0205142 <sys_putc>:
    cputchar(c);
ffffffffc0205142:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205144:	1141                	addi	sp,sp,-16
ffffffffc0205146:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205148:	882fb0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc020514c:	60a2                	ld	ra,8(sp)
ffffffffc020514e:	4501                	li	a0,0
ffffffffc0205150:	0141                	addi	sp,sp,16
ffffffffc0205152:	8082                	ret

ffffffffc0205154 <sys_kill>:
    return do_kill(pid);
ffffffffc0205154:	4108                	lw	a0,0(a0)
ffffffffc0205156:	c31ff06f          	j	ffffffffc0204d86 <do_kill>

ffffffffc020515a <sys_yield>:
    return do_yield();
ffffffffc020515a:	bdfff06f          	j	ffffffffc0204d38 <do_yield>

ffffffffc020515e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020515e:	6d14                	ld	a3,24(a0)
ffffffffc0205160:	6910                	ld	a2,16(a0)
ffffffffc0205162:	650c                	ld	a1,8(a0)
ffffffffc0205164:	6108                	ld	a0,0(a0)
ffffffffc0205166:	ebeff06f          	j	ffffffffc0204824 <do_execve>

ffffffffc020516a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020516a:	650c                	ld	a1,8(a0)
ffffffffc020516c:	4108                	lw	a0,0(a0)
ffffffffc020516e:	bdbff06f          	j	ffffffffc0204d48 <do_wait>

ffffffffc0205172 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205172:	000a5797          	auipc	a5,0xa5
ffffffffc0205176:	7b67b783          	ld	a5,1974(a5) # ffffffffc02aa928 <current>
ffffffffc020517a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020517c:	4501                	li	a0,0
ffffffffc020517e:	6a0c                	ld	a1,16(a2)
ffffffffc0205180:	e4bfe06f          	j	ffffffffc0203fca <do_fork>

ffffffffc0205184 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205184:	4108                	lw	a0,0(a0)
ffffffffc0205186:	a5eff06f          	j	ffffffffc02043e4 <do_exit>

ffffffffc020518a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020518a:	715d                	addi	sp,sp,-80
ffffffffc020518c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020518e:	000a5497          	auipc	s1,0xa5
ffffffffc0205192:	79a48493          	addi	s1,s1,1946 # ffffffffc02aa928 <current>
ffffffffc0205196:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205198:	e0a2                	sd	s0,64(sp)
ffffffffc020519a:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020519c:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020519e:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051a0:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02051a2:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051a6:	0327ee63          	bltu	a5,s2,ffffffffc02051e2 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02051aa:	00391713          	slli	a4,s2,0x3
ffffffffc02051ae:	00002797          	auipc	a5,0x2
ffffffffc02051b2:	28278793          	addi	a5,a5,642 # ffffffffc0207430 <syscalls>
ffffffffc02051b6:	97ba                	add	a5,a5,a4
ffffffffc02051b8:	639c                	ld	a5,0(a5)
ffffffffc02051ba:	c785                	beqz	a5,ffffffffc02051e2 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02051bc:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02051be:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02051c0:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02051c2:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02051c4:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02051c6:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02051c8:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02051ca:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02051cc:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02051ce:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051d0:	0028                	addi	a0,sp,8
ffffffffc02051d2:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02051d4:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051d6:	e828                	sd	a0,80(s0)
}
ffffffffc02051d8:	6406                	ld	s0,64(sp)
ffffffffc02051da:	74e2                	ld	s1,56(sp)
ffffffffc02051dc:	7942                	ld	s2,48(sp)
ffffffffc02051de:	6161                	addi	sp,sp,80
ffffffffc02051e0:	8082                	ret
    print_trapframe(tf);
ffffffffc02051e2:	8522                	mv	a0,s0
ffffffffc02051e4:	9c1fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02051e8:	609c                	ld	a5,0(s1)
ffffffffc02051ea:	86ca                	mv	a3,s2
ffffffffc02051ec:	00002617          	auipc	a2,0x2
ffffffffc02051f0:	1fc60613          	addi	a2,a2,508 # ffffffffc02073e8 <default_pmm_manager+0xec8>
ffffffffc02051f4:	43d8                	lw	a4,4(a5)
ffffffffc02051f6:	06200593          	li	a1,98
ffffffffc02051fa:	0b478793          	addi	a5,a5,180
ffffffffc02051fe:	00002517          	auipc	a0,0x2
ffffffffc0205202:	21a50513          	addi	a0,a0,538 # ffffffffc0207418 <default_pmm_manager+0xef8>
ffffffffc0205206:	a88fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020520a <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020520a:	9e3707b7          	lui	a5,0x9e370
ffffffffc020520e:	2785                	addiw	a5,a5,1
ffffffffc0205210:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205214:	02000793          	li	a5,32
ffffffffc0205218:	9f8d                	subw	a5,a5,a1
}
ffffffffc020521a:	00f5553b          	srlw	a0,a0,a5
ffffffffc020521e:	8082                	ret

ffffffffc0205220 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205220:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205224:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205226:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020522a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020522c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205230:	f022                	sd	s0,32(sp)
ffffffffc0205232:	ec26                	sd	s1,24(sp)
ffffffffc0205234:	e84a                	sd	s2,16(sp)
ffffffffc0205236:	f406                	sd	ra,40(sp)
ffffffffc0205238:	e44e                	sd	s3,8(sp)
ffffffffc020523a:	84aa                	mv	s1,a0
ffffffffc020523c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020523e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205242:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205244:	03067e63          	bgeu	a2,a6,ffffffffc0205280 <printnum+0x60>
ffffffffc0205248:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020524a:	00805763          	blez	s0,ffffffffc0205258 <printnum+0x38>
ffffffffc020524e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205250:	85ca                	mv	a1,s2
ffffffffc0205252:	854e                	mv	a0,s3
ffffffffc0205254:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205256:	fc65                	bnez	s0,ffffffffc020524e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205258:	1a02                	slli	s4,s4,0x20
ffffffffc020525a:	00002797          	auipc	a5,0x2
ffffffffc020525e:	2d678793          	addi	a5,a5,726 # ffffffffc0207530 <syscalls+0x100>
ffffffffc0205262:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205266:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205268:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020526a:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020526e:	70a2                	ld	ra,40(sp)
ffffffffc0205270:	69a2                	ld	s3,8(sp)
ffffffffc0205272:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205274:	85ca                	mv	a1,s2
ffffffffc0205276:	87a6                	mv	a5,s1
}
ffffffffc0205278:	6942                	ld	s2,16(sp)
ffffffffc020527a:	64e2                	ld	s1,24(sp)
ffffffffc020527c:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020527e:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205280:	03065633          	divu	a2,a2,a6
ffffffffc0205284:	8722                	mv	a4,s0
ffffffffc0205286:	f9bff0ef          	jal	ra,ffffffffc0205220 <printnum>
ffffffffc020528a:	b7f9                	j	ffffffffc0205258 <printnum+0x38>

ffffffffc020528c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020528c:	7119                	addi	sp,sp,-128
ffffffffc020528e:	f4a6                	sd	s1,104(sp)
ffffffffc0205290:	f0ca                	sd	s2,96(sp)
ffffffffc0205292:	ecce                	sd	s3,88(sp)
ffffffffc0205294:	e8d2                	sd	s4,80(sp)
ffffffffc0205296:	e4d6                	sd	s5,72(sp)
ffffffffc0205298:	e0da                	sd	s6,64(sp)
ffffffffc020529a:	fc5e                	sd	s7,56(sp)
ffffffffc020529c:	f06a                	sd	s10,32(sp)
ffffffffc020529e:	fc86                	sd	ra,120(sp)
ffffffffc02052a0:	f8a2                	sd	s0,112(sp)
ffffffffc02052a2:	f862                	sd	s8,48(sp)
ffffffffc02052a4:	f466                	sd	s9,40(sp)
ffffffffc02052a6:	ec6e                	sd	s11,24(sp)
ffffffffc02052a8:	892a                	mv	s2,a0
ffffffffc02052aa:	84ae                	mv	s1,a1
ffffffffc02052ac:	8d32                	mv	s10,a2
ffffffffc02052ae:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052b0:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02052b4:	5b7d                	li	s6,-1
ffffffffc02052b6:	00002a97          	auipc	s5,0x2
ffffffffc02052ba:	2a6a8a93          	addi	s5,s5,678 # ffffffffc020755c <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02052be:	00002b97          	auipc	s7,0x2
ffffffffc02052c2:	4bab8b93          	addi	s7,s7,1210 # ffffffffc0207778 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052c6:	000d4503          	lbu	a0,0(s10)
ffffffffc02052ca:	001d0413          	addi	s0,s10,1
ffffffffc02052ce:	01350a63          	beq	a0,s3,ffffffffc02052e2 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02052d2:	c121                	beqz	a0,ffffffffc0205312 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02052d4:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052d6:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02052d8:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052da:	fff44503          	lbu	a0,-1(s0)
ffffffffc02052de:	ff351ae3          	bne	a0,s3,ffffffffc02052d2 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02052e2:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02052e6:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02052ea:	4c81                	li	s9,0
ffffffffc02052ec:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02052ee:	5c7d                	li	s8,-1
ffffffffc02052f0:	5dfd                	li	s11,-1
ffffffffc02052f2:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02052f6:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02052f8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02052fc:	0ff5f593          	zext.b	a1,a1
ffffffffc0205300:	00140d13          	addi	s10,s0,1
ffffffffc0205304:	04b56263          	bltu	a0,a1,ffffffffc0205348 <vprintfmt+0xbc>
ffffffffc0205308:	058a                	slli	a1,a1,0x2
ffffffffc020530a:	95d6                	add	a1,a1,s5
ffffffffc020530c:	4194                	lw	a3,0(a1)
ffffffffc020530e:	96d6                	add	a3,a3,s5
ffffffffc0205310:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205312:	70e6                	ld	ra,120(sp)
ffffffffc0205314:	7446                	ld	s0,112(sp)
ffffffffc0205316:	74a6                	ld	s1,104(sp)
ffffffffc0205318:	7906                	ld	s2,96(sp)
ffffffffc020531a:	69e6                	ld	s3,88(sp)
ffffffffc020531c:	6a46                	ld	s4,80(sp)
ffffffffc020531e:	6aa6                	ld	s5,72(sp)
ffffffffc0205320:	6b06                	ld	s6,64(sp)
ffffffffc0205322:	7be2                	ld	s7,56(sp)
ffffffffc0205324:	7c42                	ld	s8,48(sp)
ffffffffc0205326:	7ca2                	ld	s9,40(sp)
ffffffffc0205328:	7d02                	ld	s10,32(sp)
ffffffffc020532a:	6de2                	ld	s11,24(sp)
ffffffffc020532c:	6109                	addi	sp,sp,128
ffffffffc020532e:	8082                	ret
            padc = '0';
ffffffffc0205330:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205332:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205336:	846a                	mv	s0,s10
ffffffffc0205338:	00140d13          	addi	s10,s0,1
ffffffffc020533c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205340:	0ff5f593          	zext.b	a1,a1
ffffffffc0205344:	fcb572e3          	bgeu	a0,a1,ffffffffc0205308 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205348:	85a6                	mv	a1,s1
ffffffffc020534a:	02500513          	li	a0,37
ffffffffc020534e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205350:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205354:	8d22                	mv	s10,s0
ffffffffc0205356:	f73788e3          	beq	a5,s3,ffffffffc02052c6 <vprintfmt+0x3a>
ffffffffc020535a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020535e:	1d7d                	addi	s10,s10,-1
ffffffffc0205360:	ff379de3          	bne	a5,s3,ffffffffc020535a <vprintfmt+0xce>
ffffffffc0205364:	b78d                	j	ffffffffc02052c6 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205366:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020536a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020536e:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205370:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205374:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205378:	02d86463          	bltu	a6,a3,ffffffffc02053a0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020537c:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205380:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205384:	0186873b          	addw	a4,a3,s8
ffffffffc0205388:	0017171b          	slliw	a4,a4,0x1
ffffffffc020538c:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020538e:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205392:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205394:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0205398:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020539c:	fed870e3          	bgeu	a6,a3,ffffffffc020537c <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02053a0:	f40ddce3          	bgez	s11,ffffffffc02052f8 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02053a4:	8de2                	mv	s11,s8
ffffffffc02053a6:	5c7d                	li	s8,-1
ffffffffc02053a8:	bf81                	j	ffffffffc02052f8 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02053aa:	fffdc693          	not	a3,s11
ffffffffc02053ae:	96fd                	srai	a3,a3,0x3f
ffffffffc02053b0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053b4:	00144603          	lbu	a2,1(s0)
ffffffffc02053b8:	2d81                	sext.w	s11,s11
ffffffffc02053ba:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053bc:	bf35                	j	ffffffffc02052f8 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02053be:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053c2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02053c6:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053c8:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02053ca:	bfd9                	j	ffffffffc02053a0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02053cc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053ce:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053d2:	01174463          	blt	a4,a7,ffffffffc02053da <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02053d6:	1a088e63          	beqz	a7,ffffffffc0205592 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02053da:	000a3603          	ld	a2,0(s4)
ffffffffc02053de:	46c1                	li	a3,16
ffffffffc02053e0:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02053e2:	2781                	sext.w	a5,a5
ffffffffc02053e4:	876e                	mv	a4,s11
ffffffffc02053e6:	85a6                	mv	a1,s1
ffffffffc02053e8:	854a                	mv	a0,s2
ffffffffc02053ea:	e37ff0ef          	jal	ra,ffffffffc0205220 <printnum>
            break;
ffffffffc02053ee:	bde1                	j	ffffffffc02052c6 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02053f0:	000a2503          	lw	a0,0(s4)
ffffffffc02053f4:	85a6                	mv	a1,s1
ffffffffc02053f6:	0a21                	addi	s4,s4,8
ffffffffc02053f8:	9902                	jalr	s2
            break;
ffffffffc02053fa:	b5f1                	j	ffffffffc02052c6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02053fc:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053fe:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205402:	01174463          	blt	a4,a7,ffffffffc020540a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205406:	18088163          	beqz	a7,ffffffffc0205588 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020540a:	000a3603          	ld	a2,0(s4)
ffffffffc020540e:	46a9                	li	a3,10
ffffffffc0205410:	8a2e                	mv	s4,a1
ffffffffc0205412:	bfc1                	j	ffffffffc02053e2 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205414:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205418:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020541a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020541c:	bdf1                	j	ffffffffc02052f8 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020541e:	85a6                	mv	a1,s1
ffffffffc0205420:	02500513          	li	a0,37
ffffffffc0205424:	9902                	jalr	s2
            break;
ffffffffc0205426:	b545                	j	ffffffffc02052c6 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205428:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020542c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020542e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205430:	b5e1                	j	ffffffffc02052f8 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205432:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205434:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205438:	01174463          	blt	a4,a7,ffffffffc0205440 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020543c:	14088163          	beqz	a7,ffffffffc020557e <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205440:	000a3603          	ld	a2,0(s4)
ffffffffc0205444:	46a1                	li	a3,8
ffffffffc0205446:	8a2e                	mv	s4,a1
ffffffffc0205448:	bf69                	j	ffffffffc02053e2 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020544a:	03000513          	li	a0,48
ffffffffc020544e:	85a6                	mv	a1,s1
ffffffffc0205450:	e03e                	sd	a5,0(sp)
ffffffffc0205452:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205454:	85a6                	mv	a1,s1
ffffffffc0205456:	07800513          	li	a0,120
ffffffffc020545a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020545c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020545e:	6782                	ld	a5,0(sp)
ffffffffc0205460:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205462:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205466:	bfb5                	j	ffffffffc02053e2 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205468:	000a3403          	ld	s0,0(s4)
ffffffffc020546c:	008a0713          	addi	a4,s4,8
ffffffffc0205470:	e03a                	sd	a4,0(sp)
ffffffffc0205472:	14040263          	beqz	s0,ffffffffc02055b6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205476:	0fb05763          	blez	s11,ffffffffc0205564 <vprintfmt+0x2d8>
ffffffffc020547a:	02d00693          	li	a3,45
ffffffffc020547e:	0cd79163          	bne	a5,a3,ffffffffc0205540 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205482:	00044783          	lbu	a5,0(s0)
ffffffffc0205486:	0007851b          	sext.w	a0,a5
ffffffffc020548a:	cf85                	beqz	a5,ffffffffc02054c2 <vprintfmt+0x236>
ffffffffc020548c:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205490:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205494:	000c4563          	bltz	s8,ffffffffc020549e <vprintfmt+0x212>
ffffffffc0205498:	3c7d                	addiw	s8,s8,-1
ffffffffc020549a:	036c0263          	beq	s8,s6,ffffffffc02054be <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc020549e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054a0:	0e0c8e63          	beqz	s9,ffffffffc020559c <vprintfmt+0x310>
ffffffffc02054a4:	3781                	addiw	a5,a5,-32
ffffffffc02054a6:	0ef47b63          	bgeu	s0,a5,ffffffffc020559c <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02054aa:	03f00513          	li	a0,63
ffffffffc02054ae:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054b0:	000a4783          	lbu	a5,0(s4)
ffffffffc02054b4:	3dfd                	addiw	s11,s11,-1
ffffffffc02054b6:	0a05                	addi	s4,s4,1
ffffffffc02054b8:	0007851b          	sext.w	a0,a5
ffffffffc02054bc:	ffe1                	bnez	a5,ffffffffc0205494 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02054be:	01b05963          	blez	s11,ffffffffc02054d0 <vprintfmt+0x244>
ffffffffc02054c2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02054c4:	85a6                	mv	a1,s1
ffffffffc02054c6:	02000513          	li	a0,32
ffffffffc02054ca:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02054cc:	fe0d9be3          	bnez	s11,ffffffffc02054c2 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02054d0:	6a02                	ld	s4,0(sp)
ffffffffc02054d2:	bbd5                	j	ffffffffc02052c6 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02054d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02054d6:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02054da:	01174463          	blt	a4,a7,ffffffffc02054e2 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02054de:	08088d63          	beqz	a7,ffffffffc0205578 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02054e2:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02054e6:	0a044d63          	bltz	s0,ffffffffc02055a0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02054ea:	8622                	mv	a2,s0
ffffffffc02054ec:	8a66                	mv	s4,s9
ffffffffc02054ee:	46a9                	li	a3,10
ffffffffc02054f0:	bdcd                	j	ffffffffc02053e2 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02054f2:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02054f6:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc02054f8:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02054fa:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02054fe:	8fb5                	xor	a5,a5,a3
ffffffffc0205500:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205504:	02d74163          	blt	a4,a3,ffffffffc0205526 <vprintfmt+0x29a>
ffffffffc0205508:	00369793          	slli	a5,a3,0x3
ffffffffc020550c:	97de                	add	a5,a5,s7
ffffffffc020550e:	639c                	ld	a5,0(a5)
ffffffffc0205510:	cb99                	beqz	a5,ffffffffc0205526 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205512:	86be                	mv	a3,a5
ffffffffc0205514:	00000617          	auipc	a2,0x0
ffffffffc0205518:	1f460613          	addi	a2,a2,500 # ffffffffc0205708 <etext+0x2e>
ffffffffc020551c:	85a6                	mv	a1,s1
ffffffffc020551e:	854a                	mv	a0,s2
ffffffffc0205520:	0ce000ef          	jal	ra,ffffffffc02055ee <printfmt>
ffffffffc0205524:	b34d                	j	ffffffffc02052c6 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205526:	00002617          	auipc	a2,0x2
ffffffffc020552a:	02a60613          	addi	a2,a2,42 # ffffffffc0207550 <syscalls+0x120>
ffffffffc020552e:	85a6                	mv	a1,s1
ffffffffc0205530:	854a                	mv	a0,s2
ffffffffc0205532:	0bc000ef          	jal	ra,ffffffffc02055ee <printfmt>
ffffffffc0205536:	bb41                	j	ffffffffc02052c6 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205538:	00002417          	auipc	s0,0x2
ffffffffc020553c:	01040413          	addi	s0,s0,16 # ffffffffc0207548 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205540:	85e2                	mv	a1,s8
ffffffffc0205542:	8522                	mv	a0,s0
ffffffffc0205544:	e43e                	sd	a5,8(sp)
ffffffffc0205546:	0e2000ef          	jal	ra,ffffffffc0205628 <strnlen>
ffffffffc020554a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020554e:	01b05b63          	blez	s11,ffffffffc0205564 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205552:	67a2                	ld	a5,8(sp)
ffffffffc0205554:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205558:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020555a:	85a6                	mv	a1,s1
ffffffffc020555c:	8552                	mv	a0,s4
ffffffffc020555e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205560:	fe0d9ce3          	bnez	s11,ffffffffc0205558 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205564:	00044783          	lbu	a5,0(s0)
ffffffffc0205568:	00140a13          	addi	s4,s0,1
ffffffffc020556c:	0007851b          	sext.w	a0,a5
ffffffffc0205570:	d3a5                	beqz	a5,ffffffffc02054d0 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205572:	05e00413          	li	s0,94
ffffffffc0205576:	bf39                	j	ffffffffc0205494 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205578:	000a2403          	lw	s0,0(s4)
ffffffffc020557c:	b7ad                	j	ffffffffc02054e6 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020557e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205582:	46a1                	li	a3,8
ffffffffc0205584:	8a2e                	mv	s4,a1
ffffffffc0205586:	bdb1                	j	ffffffffc02053e2 <vprintfmt+0x156>
ffffffffc0205588:	000a6603          	lwu	a2,0(s4)
ffffffffc020558c:	46a9                	li	a3,10
ffffffffc020558e:	8a2e                	mv	s4,a1
ffffffffc0205590:	bd89                	j	ffffffffc02053e2 <vprintfmt+0x156>
ffffffffc0205592:	000a6603          	lwu	a2,0(s4)
ffffffffc0205596:	46c1                	li	a3,16
ffffffffc0205598:	8a2e                	mv	s4,a1
ffffffffc020559a:	b5a1                	j	ffffffffc02053e2 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020559c:	9902                	jalr	s2
ffffffffc020559e:	bf09                	j	ffffffffc02054b0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02055a0:	85a6                	mv	a1,s1
ffffffffc02055a2:	02d00513          	li	a0,45
ffffffffc02055a6:	e03e                	sd	a5,0(sp)
ffffffffc02055a8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02055aa:	6782                	ld	a5,0(sp)
ffffffffc02055ac:	8a66                	mv	s4,s9
ffffffffc02055ae:	40800633          	neg	a2,s0
ffffffffc02055b2:	46a9                	li	a3,10
ffffffffc02055b4:	b53d                	j	ffffffffc02053e2 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02055b6:	03b05163          	blez	s11,ffffffffc02055d8 <vprintfmt+0x34c>
ffffffffc02055ba:	02d00693          	li	a3,45
ffffffffc02055be:	f6d79de3          	bne	a5,a3,ffffffffc0205538 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02055c2:	00002417          	auipc	s0,0x2
ffffffffc02055c6:	f8640413          	addi	s0,s0,-122 # ffffffffc0207548 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055ca:	02800793          	li	a5,40
ffffffffc02055ce:	02800513          	li	a0,40
ffffffffc02055d2:	00140a13          	addi	s4,s0,1
ffffffffc02055d6:	bd6d                	j	ffffffffc0205490 <vprintfmt+0x204>
ffffffffc02055d8:	00002a17          	auipc	s4,0x2
ffffffffc02055dc:	f71a0a13          	addi	s4,s4,-143 # ffffffffc0207549 <syscalls+0x119>
ffffffffc02055e0:	02800513          	li	a0,40
ffffffffc02055e4:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055e8:	05e00413          	li	s0,94
ffffffffc02055ec:	b565                	j	ffffffffc0205494 <vprintfmt+0x208>

ffffffffc02055ee <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055ee:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02055f0:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055f4:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02055f6:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02055f8:	ec06                	sd	ra,24(sp)
ffffffffc02055fa:	f83a                	sd	a4,48(sp)
ffffffffc02055fc:	fc3e                	sd	a5,56(sp)
ffffffffc02055fe:	e0c2                	sd	a6,64(sp)
ffffffffc0205600:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205602:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205604:	c89ff0ef          	jal	ra,ffffffffc020528c <vprintfmt>
}
ffffffffc0205608:	60e2                	ld	ra,24(sp)
ffffffffc020560a:	6161                	addi	sp,sp,80
ffffffffc020560c:	8082                	ret

ffffffffc020560e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020560e:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205612:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205614:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205616:	cb81                	beqz	a5,ffffffffc0205626 <strlen+0x18>
        cnt ++;
ffffffffc0205618:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020561a:	00a707b3          	add	a5,a4,a0
ffffffffc020561e:	0007c783          	lbu	a5,0(a5)
ffffffffc0205622:	fbfd                	bnez	a5,ffffffffc0205618 <strlen+0xa>
ffffffffc0205624:	8082                	ret
    }
    return cnt;
}
ffffffffc0205626:	8082                	ret

ffffffffc0205628 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205628:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020562a:	e589                	bnez	a1,ffffffffc0205634 <strnlen+0xc>
ffffffffc020562c:	a811                	j	ffffffffc0205640 <strnlen+0x18>
        cnt ++;
ffffffffc020562e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205630:	00f58863          	beq	a1,a5,ffffffffc0205640 <strnlen+0x18>
ffffffffc0205634:	00f50733          	add	a4,a0,a5
ffffffffc0205638:	00074703          	lbu	a4,0(a4)
ffffffffc020563c:	fb6d                	bnez	a4,ffffffffc020562e <strnlen+0x6>
ffffffffc020563e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205640:	852e                	mv	a0,a1
ffffffffc0205642:	8082                	ret

ffffffffc0205644 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205644:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205646:	0005c703          	lbu	a4,0(a1)
ffffffffc020564a:	0785                	addi	a5,a5,1
ffffffffc020564c:	0585                	addi	a1,a1,1
ffffffffc020564e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205652:	fb75                	bnez	a4,ffffffffc0205646 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205654:	8082                	ret

ffffffffc0205656 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205656:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020565a:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020565e:	cb89                	beqz	a5,ffffffffc0205670 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205660:	0505                	addi	a0,a0,1
ffffffffc0205662:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205664:	fee789e3          	beq	a5,a4,ffffffffc0205656 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205668:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020566c:	9d19                	subw	a0,a0,a4
ffffffffc020566e:	8082                	ret
ffffffffc0205670:	4501                	li	a0,0
ffffffffc0205672:	bfed                	j	ffffffffc020566c <strcmp+0x16>

ffffffffc0205674 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205674:	c20d                	beqz	a2,ffffffffc0205696 <strncmp+0x22>
ffffffffc0205676:	962e                	add	a2,a2,a1
ffffffffc0205678:	a031                	j	ffffffffc0205684 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020567a:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020567c:	00e79a63          	bne	a5,a4,ffffffffc0205690 <strncmp+0x1c>
ffffffffc0205680:	00b60b63          	beq	a2,a1,ffffffffc0205696 <strncmp+0x22>
ffffffffc0205684:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205688:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020568a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020568e:	f7f5                	bnez	a5,ffffffffc020567a <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205690:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0205694:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205696:	4501                	li	a0,0
ffffffffc0205698:	8082                	ret

ffffffffc020569a <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc020569a:	00054783          	lbu	a5,0(a0)
ffffffffc020569e:	c799                	beqz	a5,ffffffffc02056ac <strchr+0x12>
        if (*s == c) {
ffffffffc02056a0:	00f58763          	beq	a1,a5,ffffffffc02056ae <strchr+0x14>
    while (*s != '\0') {
ffffffffc02056a4:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02056a8:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02056aa:	fbfd                	bnez	a5,ffffffffc02056a0 <strchr+0x6>
    }
    return NULL;
ffffffffc02056ac:	4501                	li	a0,0
}
ffffffffc02056ae:	8082                	ret

ffffffffc02056b0 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02056b0:	ca01                	beqz	a2,ffffffffc02056c0 <memset+0x10>
ffffffffc02056b2:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02056b4:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02056b6:	0785                	addi	a5,a5,1
ffffffffc02056b8:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02056bc:	fec79de3          	bne	a5,a2,ffffffffc02056b6 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02056c0:	8082                	ret

ffffffffc02056c2 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02056c2:	ca19                	beqz	a2,ffffffffc02056d8 <memcpy+0x16>
ffffffffc02056c4:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02056c6:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02056c8:	0005c703          	lbu	a4,0(a1)
ffffffffc02056cc:	0585                	addi	a1,a1,1
ffffffffc02056ce:	0785                	addi	a5,a5,1
ffffffffc02056d0:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02056d4:	fec59ae3          	bne	a1,a2,ffffffffc02056c8 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02056d8:	8082                	ret
