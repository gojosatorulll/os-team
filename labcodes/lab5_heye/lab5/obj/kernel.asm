
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
ffffffffc020004a:	00098517          	auipc	a0,0x98
ffffffffc020004e:	80650513          	addi	a0,a0,-2042 # ffffffffc0297850 <buf>
ffffffffc0200052:	0009c617          	auipc	a2,0x9c
ffffffffc0200056:	ca660613          	addi	a2,a2,-858 # ffffffffc029bcf8 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	023050ef          	jal	ffffffffc0205884 <memset>
    dtb_init();
ffffffffc0200066:	552000ef          	jal	ffffffffc02005b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	4dc000ef          	jal	ffffffffc0200546 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	84258593          	addi	a1,a1,-1982 # ffffffffc02058b0 <etext+0x2>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	85a50513          	addi	a0,a0,-1958 # ffffffffc02058d0 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1a4000ef          	jal	ffffffffc0200226 <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	7e2020ef          	jal	ffffffffc0202868 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	081000ef          	jal	ffffffffc020090a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	07f000ef          	jal	ffffffffc020090c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	2cf030ef          	jal	ffffffffc0203b60 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	739040ef          	jal	ffffffffc0204fce <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	45a000ef          	jal	ffffffffc02004f4 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	061000ef          	jal	ffffffffc02008fe <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	0cc050ef          	jal	ffffffffc020516e <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	7179                	addi	sp,sp,-48
ffffffffc02000a8:	f406                	sd	ra,40(sp)
ffffffffc02000aa:	f022                	sd	s0,32(sp)
ffffffffc02000ac:	ec26                	sd	s1,24(sp)
ffffffffc02000ae:	e84a                	sd	s2,16(sp)
ffffffffc02000b0:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc02000b2:	c901                	beqz	a0,ffffffffc02000c2 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc02000b4:	85aa                	mv	a1,a0
ffffffffc02000b6:	00006517          	auipc	a0,0x6
ffffffffc02000ba:	82250513          	addi	a0,a0,-2014 # ffffffffc02058d8 <etext+0x2a>
ffffffffc02000be:	0d6000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c2:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c4:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc02000c6:	00097997          	auipc	s3,0x97
ffffffffc02000ca:	78a98993          	addi	s3,s3,1930 # ffffffffc0297850 <buf>
        c = getchar();
ffffffffc02000ce:	148000ef          	jal	ffffffffc0200216 <getchar>
ffffffffc02000d2:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d8:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000dc:	ff650693          	addi	a3,a0,-10
ffffffffc02000e0:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc02000e4:	02054963          	bltz	a0,ffffffffc0200116 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e8:	02a95f63          	bge	s2,a0,ffffffffc0200126 <readline+0x80>
ffffffffc02000ec:	cf0d                	beqz	a4,ffffffffc0200126 <readline+0x80>
            cputchar(c);
ffffffffc02000ee:	0da000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc02000f2:	009987b3          	add	a5,s3,s1
ffffffffc02000f6:	00878023          	sb	s0,0(a5)
ffffffffc02000fa:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc02000fc:	11a000ef          	jal	ffffffffc0200216 <getchar>
ffffffffc0200100:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200102:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200106:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	ff650693          	addi	a3,a0,-10
ffffffffc020010e:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0200112:	fc055be3          	bgez	a0,ffffffffc02000e8 <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0200116:	70a2                	ld	ra,40(sp)
ffffffffc0200118:	7402                	ld	s0,32(sp)
ffffffffc020011a:	64e2                	ld	s1,24(sp)
ffffffffc020011c:	6942                	ld	s2,16(sp)
ffffffffc020011e:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0200120:	4501                	li	a0,0
}
ffffffffc0200122:	6145                	addi	sp,sp,48
ffffffffc0200124:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0200126:	eb81                	bnez	a5,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc0200128:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc020012a:	00905663          	blez	s1,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc020012e:	09a000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200132:	34fd                	addiw	s1,s1,-1
ffffffffc0200134:	bf69                	j	ffffffffc02000ce <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0200136:	c291                	beqz	a3,ffffffffc020013a <readline+0x94>
ffffffffc0200138:	fa59                	bnez	a2,ffffffffc02000ce <readline+0x28>
            cputchar(c);
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	08c000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc0200140:	00097517          	auipc	a0,0x97
ffffffffc0200144:	71050513          	addi	a0,a0,1808 # ffffffffc0297850 <buf>
ffffffffc0200148:	94aa                	add	s1,s1,a0
ffffffffc020014a:	00048023          	sb	zero,0(s1)
}
ffffffffc020014e:	70a2                	ld	ra,40(sp)
ffffffffc0200150:	7402                	ld	s0,32(sp)
ffffffffc0200152:	64e2                	ld	s1,24(sp)
ffffffffc0200154:	6942                	ld	s2,16(sp)
ffffffffc0200156:	69a2                	ld	s3,8(sp)
ffffffffc0200158:	6145                	addi	sp,sp,48
ffffffffc020015a:	8082                	ret

ffffffffc020015c <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	ec06                	sd	ra,24(sp)
ffffffffc0200160:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200162:	3e6000ef          	jal	ffffffffc0200548 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	65a2                	ld	a1,8(sp)
}
ffffffffc0200168:	60e2                	ld	ra,24(sp)
    (*cnt)++;
ffffffffc020016a:	419c                	lw	a5,0(a1)
ffffffffc020016c:	2785                	addiw	a5,a5,1
ffffffffc020016e:	c19c                	sw	a5,0(a1)
}
ffffffffc0200170:	6105                	addi	sp,sp,32
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
ffffffffc020017e:	fe250513          	addi	a0,a0,-30 # ffffffffc020015c <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	2e2050ef          	jal	ffffffffc020546a <vprintfmt>
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
ffffffffc02001a8:	fb850513          	addi	a0,a0,-72 # ffffffffc020015c <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02001b8:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	2ae050ef          	jal	ffffffffc020546a <vprintfmt>
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
ffffffffc02001c8:	a641                	j	ffffffffc0200548 <cons_putc>

ffffffffc02001ca <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001ca:	1101                	addi	sp,sp,-32
ffffffffc02001cc:	e822                	sd	s0,16(sp)
ffffffffc02001ce:	ec06                	sd	ra,24(sp)
ffffffffc02001d0:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d2:	00054503          	lbu	a0,0(a0)
ffffffffc02001d6:	c51d                	beqz	a0,ffffffffc0200204 <cputs+0x3a>
ffffffffc02001d8:	e426                	sd	s1,8(sp)
ffffffffc02001da:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc02001dc:	4481                	li	s1,0
    cons_putc(c);
ffffffffc02001de:	36a000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e2:	00044503          	lbu	a0,0(s0)
ffffffffc02001e6:	0405                	addi	s0,s0,1
ffffffffc02001e8:	87a6                	mv	a5,s1
    (*cnt)++;
ffffffffc02001ea:	2485                	addiw	s1,s1,1
    while ((c = *str++) != '\0')
ffffffffc02001ec:	f96d                	bnez	a0,ffffffffc02001de <cputs+0x14>
    cons_putc(c);
ffffffffc02001ee:	4529                	li	a0,10
    (*cnt)++;
ffffffffc02001f0:	0027841b          	addiw	s0,a5,2
ffffffffc02001f4:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001f6:	352000ef          	jal	ffffffffc0200548 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fa:	60e2                	ld	ra,24(sp)
ffffffffc02001fc:	8522                	mv	a0,s0
ffffffffc02001fe:	6442                	ld	s0,16(sp)
ffffffffc0200200:	6105                	addi	sp,sp,32
ffffffffc0200202:	8082                	ret
    cons_putc(c);
ffffffffc0200204:	4529                	li	a0,10
ffffffffc0200206:	342000ef          	jal	ffffffffc0200548 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc020020a:	4405                	li	s0,1
}
ffffffffc020020c:	60e2                	ld	ra,24(sp)
ffffffffc020020e:	8522                	mv	a0,s0
ffffffffc0200210:	6442                	ld	s0,16(sp)
ffffffffc0200212:	6105                	addi	sp,sp,32
ffffffffc0200214:	8082                	ret

ffffffffc0200216 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc0200216:	1141                	addi	sp,sp,-16
ffffffffc0200218:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020021a:	362000ef          	jal	ffffffffc020057c <cons_getc>
ffffffffc020021e:	dd75                	beqz	a0,ffffffffc020021a <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200220:	60a2                	ld	ra,8(sp)
ffffffffc0200222:	0141                	addi	sp,sp,16
ffffffffc0200224:	8082                	ret

ffffffffc0200226 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc0200226:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	00005517          	auipc	a0,0x5
ffffffffc020022c:	6b850513          	addi	a0,a0,1720 # ffffffffc02058e0 <etext+0x32>
{
ffffffffc0200230:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200232:	f63ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200236:	00000597          	auipc	a1,0x0
ffffffffc020023a:	e1458593          	addi	a1,a1,-492 # ffffffffc020004a <kern_init>
ffffffffc020023e:	00005517          	auipc	a0,0x5
ffffffffc0200242:	6c250513          	addi	a0,a0,1730 # ffffffffc0205900 <etext+0x52>
ffffffffc0200246:	f4fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020024a:	00005597          	auipc	a1,0x5
ffffffffc020024e:	66458593          	addi	a1,a1,1636 # ffffffffc02058ae <etext>
ffffffffc0200252:	00005517          	auipc	a0,0x5
ffffffffc0200256:	6ce50513          	addi	a0,a0,1742 # ffffffffc0205920 <etext+0x72>
ffffffffc020025a:	f3bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020025e:	00097597          	auipc	a1,0x97
ffffffffc0200262:	5f258593          	addi	a1,a1,1522 # ffffffffc0297850 <buf>
ffffffffc0200266:	00005517          	auipc	a0,0x5
ffffffffc020026a:	6da50513          	addi	a0,a0,1754 # ffffffffc0205940 <etext+0x92>
ffffffffc020026e:	f27ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200272:	0009c597          	auipc	a1,0x9c
ffffffffc0200276:	a8658593          	addi	a1,a1,-1402 # ffffffffc029bcf8 <end>
ffffffffc020027a:	00005517          	auipc	a0,0x5
ffffffffc020027e:	6e650513          	addi	a0,a0,1766 # ffffffffc0205960 <etext+0xb2>
ffffffffc0200282:	f13ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200286:	00000717          	auipc	a4,0x0
ffffffffc020028a:	dc470713          	addi	a4,a4,-572 # ffffffffc020004a <kern_init>
ffffffffc020028e:	0009c797          	auipc	a5,0x9c
ffffffffc0200292:	e6978793          	addi	a5,a5,-407 # ffffffffc029c0f7 <end+0x3ff>
ffffffffc0200296:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200298:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020029c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020029e:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a2:	95be                	add	a1,a1,a5
ffffffffc02002a4:	85a9                	srai	a1,a1,0xa
ffffffffc02002a6:	00005517          	auipc	a0,0x5
ffffffffc02002aa:	6da50513          	addi	a0,a0,1754 # ffffffffc0205980 <etext+0xd2>
}
ffffffffc02002ae:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b0:	b5d5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002b2 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002b2:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002b4:	00005617          	auipc	a2,0x5
ffffffffc02002b8:	6fc60613          	addi	a2,a2,1788 # ffffffffc02059b0 <etext+0x102>
ffffffffc02002bc:	04f00593          	li	a1,79
ffffffffc02002c0:	00005517          	auipc	a0,0x5
ffffffffc02002c4:	70850513          	addi	a0,a0,1800 # ffffffffc02059c8 <etext+0x11a>
{
ffffffffc02002c8:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ca:	17c000ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02002ce <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002ce:	1101                	addi	sp,sp,-32
ffffffffc02002d0:	e822                	sd	s0,16(sp)
ffffffffc02002d2:	e426                	sd	s1,8(sp)
ffffffffc02002d4:	ec06                	sd	ra,24(sp)
ffffffffc02002d6:	00007417          	auipc	s0,0x7
ffffffffc02002da:	36a40413          	addi	s0,s0,874 # ffffffffc0207640 <commands>
ffffffffc02002de:	00007497          	auipc	s1,0x7
ffffffffc02002e2:	3aa48493          	addi	s1,s1,938 # ffffffffc0207688 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	6410                	ld	a2,8(s0)
ffffffffc02002e8:	600c                	ld	a1,0(s0)
ffffffffc02002ea:	00005517          	auipc	a0,0x5
ffffffffc02002ee:	6f650513          	addi	a0,a0,1782 # ffffffffc02059e0 <etext+0x132>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f2:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002f4:	ea1ff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02002f8:	fe9417e3          	bne	s0,s1,ffffffffc02002e6 <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002fc:	60e2                	ld	ra,24(sp)
ffffffffc02002fe:	6442                	ld	s0,16(sp)
ffffffffc0200300:	64a2                	ld	s1,8(sp)
ffffffffc0200302:	4501                	li	a0,0
ffffffffc0200304:	6105                	addi	sp,sp,32
ffffffffc0200306:	8082                	ret

ffffffffc0200308 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200308:	1141                	addi	sp,sp,-16
ffffffffc020030a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020030c:	f1bff0ef          	jal	ffffffffc0200226 <print_kerninfo>
    return 0;
}
ffffffffc0200310:	60a2                	ld	ra,8(sp)
ffffffffc0200312:	4501                	li	a0,0
ffffffffc0200314:	0141                	addi	sp,sp,16
ffffffffc0200316:	8082                	ret

ffffffffc0200318 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200318:	1141                	addi	sp,sp,-16
ffffffffc020031a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020031c:	f97ff0ef          	jal	ffffffffc02002b2 <print_stackframe>
    return 0;
}
ffffffffc0200320:	60a2                	ld	ra,8(sp)
ffffffffc0200322:	4501                	li	a0,0
ffffffffc0200324:	0141                	addi	sp,sp,16
ffffffffc0200326:	8082                	ret

ffffffffc0200328 <kmonitor>:
{
ffffffffc0200328:	7131                	addi	sp,sp,-192
ffffffffc020032a:	e952                	sd	s4,144(sp)
ffffffffc020032c:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020032e:	00005517          	auipc	a0,0x5
ffffffffc0200332:	6c250513          	addi	a0,a0,1730 # ffffffffc02059f0 <etext+0x142>
{
ffffffffc0200336:	fd06                	sd	ra,184(sp)
ffffffffc0200338:	f922                	sd	s0,176(sp)
ffffffffc020033a:	f526                	sd	s1,168(sp)
ffffffffc020033c:	ed4e                	sd	s3,152(sp)
ffffffffc020033e:	e556                	sd	s5,136(sp)
ffffffffc0200340:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200342:	e53ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200346:	00005517          	auipc	a0,0x5
ffffffffc020034a:	6d250513          	addi	a0,a0,1746 # ffffffffc0205a18 <etext+0x16a>
ffffffffc020034e:	e47ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc0200352:	000a0563          	beqz	s4,ffffffffc020035c <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc0200356:	8552                	mv	a0,s4
ffffffffc0200358:	79c000ef          	jal	ffffffffc0200af4 <print_trapframe>
ffffffffc020035c:	00007a97          	auipc	s5,0x7
ffffffffc0200360:	2e4a8a93          	addi	s5,s5,740 # ffffffffc0207640 <commands>
        if (argc == MAXARGS - 1)
ffffffffc0200364:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL)
ffffffffc0200366:	00005517          	auipc	a0,0x5
ffffffffc020036a:	6da50513          	addi	a0,a0,1754 # ffffffffc0205a40 <etext+0x192>
ffffffffc020036e:	d39ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200372:	842a                	mv	s0,a0
ffffffffc0200374:	d96d                	beqz	a0,ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200376:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020037a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020037c:	e99d                	bnez	a1,ffffffffc02003b2 <kmonitor+0x8a>
    int argc = 0;
ffffffffc020037e:	8b26                	mv	s6,s1
    if (argc == 0)
ffffffffc0200380:	fe0b03e3          	beqz	s6,ffffffffc0200366 <kmonitor+0x3e>
ffffffffc0200384:	00007497          	auipc	s1,0x7
ffffffffc0200388:	2bc48493          	addi	s1,s1,700 # ffffffffc0207640 <commands>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020038c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc020038e:	6582                	ld	a1,0(sp)
ffffffffc0200390:	6088                	ld	a0,0(s1)
ffffffffc0200392:	484050ef          	jal	ffffffffc0205816 <strcmp>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200396:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200398:	c149                	beqz	a0,ffffffffc020041a <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020039a:	2405                	addiw	s0,s0,1
ffffffffc020039c:	04e1                	addi	s1,s1,24
ffffffffc020039e:	fef418e3          	bne	s0,a5,ffffffffc020038e <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003a2:	6582                	ld	a1,0(sp)
ffffffffc02003a4:	00005517          	auipc	a0,0x5
ffffffffc02003a8:	6cc50513          	addi	a0,a0,1740 # ffffffffc0205a70 <etext+0x1c2>
ffffffffc02003ac:	de9ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc02003b0:	bf5d                	j	ffffffffc0200366 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003b2:	00005517          	auipc	a0,0x5
ffffffffc02003b6:	69650513          	addi	a0,a0,1686 # ffffffffc0205a48 <etext+0x19a>
ffffffffc02003ba:	4b8050ef          	jal	ffffffffc0205872 <strchr>
ffffffffc02003be:	c901                	beqz	a0,ffffffffc02003ce <kmonitor+0xa6>
ffffffffc02003c0:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc02003c4:	00040023          	sb	zero,0(s0)
ffffffffc02003c8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ca:	d9d5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003cc:	b7dd                	j	ffffffffc02003b2 <kmonitor+0x8a>
        if (*buf == '\0')
ffffffffc02003ce:	00044783          	lbu	a5,0(s0)
ffffffffc02003d2:	d7d5                	beqz	a5,ffffffffc020037e <kmonitor+0x56>
        if (argc == MAXARGS - 1)
ffffffffc02003d4:	03348b63          	beq	s1,s3,ffffffffc020040a <kmonitor+0xe2>
        argv[argc++] = buf;
ffffffffc02003d8:	00349793          	slli	a5,s1,0x3
ffffffffc02003dc:	978a                	add	a5,a5,sp
ffffffffc02003de:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e0:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc02003e4:	2485                	addiw	s1,s1,1
ffffffffc02003e6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003e8:	e591                	bnez	a1,ffffffffc02003f4 <kmonitor+0xcc>
ffffffffc02003ea:	bf59                	j	ffffffffc0200380 <kmonitor+0x58>
ffffffffc02003ec:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc02003f0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc02003f2:	d5d1                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc02003f4:	00005517          	auipc	a0,0x5
ffffffffc02003f8:	65450513          	addi	a0,a0,1620 # ffffffffc0205a48 <etext+0x19a>
ffffffffc02003fc:	476050ef          	jal	ffffffffc0205872 <strchr>
ffffffffc0200400:	d575                	beqz	a0,ffffffffc02003ec <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200402:	00044583          	lbu	a1,0(s0)
ffffffffc0200406:	dda5                	beqz	a1,ffffffffc020037e <kmonitor+0x56>
ffffffffc0200408:	b76d                	j	ffffffffc02003b2 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020040a:	45c1                	li	a1,16
ffffffffc020040c:	00005517          	auipc	a0,0x5
ffffffffc0200410:	64450513          	addi	a0,a0,1604 # ffffffffc0205a50 <etext+0x1a2>
ffffffffc0200414:	d81ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200418:	b7c1                	j	ffffffffc02003d8 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041a:	00141793          	slli	a5,s0,0x1
ffffffffc020041e:	97a2                	add	a5,a5,s0
ffffffffc0200420:	078e                	slli	a5,a5,0x3
ffffffffc0200422:	97d6                	add	a5,a5,s5
ffffffffc0200424:	6b9c                	ld	a5,16(a5)
ffffffffc0200426:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042a:	8652                	mv	a2,s4
ffffffffc020042c:	002c                	addi	a1,sp,8
ffffffffc020042e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200430:	f2055be3          	bgez	a0,ffffffffc0200366 <kmonitor+0x3e>
}
ffffffffc0200434:	70ea                	ld	ra,184(sp)
ffffffffc0200436:	744a                	ld	s0,176(sp)
ffffffffc0200438:	74aa                	ld	s1,168(sp)
ffffffffc020043a:	69ea                	ld	s3,152(sp)
ffffffffc020043c:	6a4a                	ld	s4,144(sp)
ffffffffc020043e:	6aaa                	ld	s5,136(sp)
ffffffffc0200440:	6b0a                	ld	s6,128(sp)
ffffffffc0200442:	6129                	addi	sp,sp,192
ffffffffc0200444:	8082                	ret

ffffffffc0200446 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc0200446:	0009c317          	auipc	t1,0x9c
ffffffffc020044a:	83233303          	ld	t1,-1998(t1) # ffffffffc029bc78 <is_panic>
{
ffffffffc020044e:	715d                	addi	sp,sp,-80
ffffffffc0200450:	ec06                	sd	ra,24(sp)
ffffffffc0200452:	f436                	sd	a3,40(sp)
ffffffffc0200454:	f83a                	sd	a4,48(sp)
ffffffffc0200456:	fc3e                	sd	a5,56(sp)
ffffffffc0200458:	e0c2                	sd	a6,64(sp)
ffffffffc020045a:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc020045c:	02031e63          	bnez	t1,ffffffffc0200498 <__panic+0x52>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200460:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200462:	103c                	addi	a5,sp,40
ffffffffc0200464:	e822                	sd	s0,16(sp)
ffffffffc0200466:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200468:	862e                	mv	a2,a1
ffffffffc020046a:	85aa                	mv	a1,a0
ffffffffc020046c:	00005517          	auipc	a0,0x5
ffffffffc0200470:	6ac50513          	addi	a0,a0,1708 # ffffffffc0205b18 <etext+0x26a>
    is_panic = 1;
ffffffffc0200474:	0009c697          	auipc	a3,0x9c
ffffffffc0200478:	80e6b223          	sd	a4,-2044(a3) # ffffffffc029bc78 <is_panic>
    va_start(ap, fmt);
ffffffffc020047c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047e:	d17ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cefff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020048a:	00005517          	auipc	a0,0x5
ffffffffc020048e:	6ae50513          	addi	a0,a0,1710 # ffffffffc0205b38 <etext+0x28a>
ffffffffc0200492:	d03ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200496:	6442                	ld	s0,16(sp)
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200498:	4501                	li	a0,0
ffffffffc020049a:	4581                	li	a1,0
ffffffffc020049c:	4601                	li	a2,0
ffffffffc020049e:	48a1                	li	a7,8
ffffffffc02004a0:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004a4:	460000ef          	jal	ffffffffc0200904 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004a8:	4501                	li	a0,0
ffffffffc02004aa:	e7fff0ef          	jal	ffffffffc0200328 <kmonitor>
    while (1)
ffffffffc02004ae:	bfed                	j	ffffffffc02004a8 <__panic+0x62>

ffffffffc02004b0 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004b0:	715d                	addi	sp,sp,-80
ffffffffc02004b2:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	02810313          	addi	t1,sp,40
{
ffffffffc02004b8:	8432                	mv	s0,a2
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ba:	862e                	mv	a2,a1
ffffffffc02004bc:	85aa                	mv	a1,a0
ffffffffc02004be:	00005517          	auipc	a0,0x5
ffffffffc02004c2:	68250513          	addi	a0,a0,1666 # ffffffffc0205b40 <etext+0x292>
{
ffffffffc02004c6:	ec06                	sd	ra,24(sp)
ffffffffc02004c8:	f436                	sd	a3,40(sp)
ffffffffc02004ca:	f83a                	sd	a4,48(sp)
ffffffffc02004cc:	fc3e                	sd	a5,56(sp)
ffffffffc02004ce:	e0c2                	sd	a6,64(sp)
ffffffffc02004d0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02004d2:	e41a                	sd	t1,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004d4:	cc1ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004d8:	65a2                	ld	a1,8(sp)
ffffffffc02004da:	8522                	mv	a0,s0
ffffffffc02004dc:	c99ff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004e0:	00005517          	auipc	a0,0x5
ffffffffc02004e4:	65850513          	addi	a0,a0,1624 # ffffffffc0205b38 <etext+0x28a>
ffffffffc02004e8:	cadff0ef          	jal	ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc02004ec:	60e2                	ld	ra,24(sp)
ffffffffc02004ee:	6442                	ld	s0,16(sp)
ffffffffc02004f0:	6161                	addi	sp,sp,80
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004f4:	67e1                	lui	a5,0x18
ffffffffc02004f6:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xe4e8>
ffffffffc02004fa:	0009b717          	auipc	a4,0x9b
ffffffffc02004fe:	78f73323          	sd	a5,1926(a4) # ffffffffc029bc80 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200502:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200506:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200508:	953e                	add	a0,a0,a5
ffffffffc020050a:	4601                	li	a2,0
ffffffffc020050c:	4881                	li	a7,0
ffffffffc020050e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200512:	02000793          	li	a5,32
ffffffffc0200516:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020051a:	00005517          	auipc	a0,0x5
ffffffffc020051e:	64650513          	addi	a0,a0,1606 # ffffffffc0205b60 <etext+0x2b2>
    ticks = 0;
ffffffffc0200522:	0009b797          	auipc	a5,0x9b
ffffffffc0200526:	7607b323          	sd	zero,1894(a5) # ffffffffc029bc88 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020052a:	b1ad                	j	ffffffffc0200194 <cprintf>

ffffffffc020052c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200530:	0009b797          	auipc	a5,0x9b
ffffffffc0200534:	7507b783          	ld	a5,1872(a5) # ffffffffc029bc80 <timebase>
ffffffffc0200538:	4581                	li	a1,0
ffffffffc020053a:	4601                	li	a2,0
ffffffffc020053c:	953e                	add	a0,a0,a5
ffffffffc020053e:	4881                	li	a7,0
ffffffffc0200540:	00000073          	ecall
ffffffffc0200544:	8082                	ret

ffffffffc0200546 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200546:	8082                	ret

ffffffffc0200548 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200548:	100027f3          	csrr	a5,sstatus
ffffffffc020054c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020054e:	0ff57513          	zext.b	a0,a0
ffffffffc0200552:	e799                	bnez	a5,ffffffffc0200560 <cons_putc+0x18>
ffffffffc0200554:	4581                	li	a1,0
ffffffffc0200556:	4601                	li	a2,0
ffffffffc0200558:	4885                	li	a7,1
ffffffffc020055a:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc020055e:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200560:	1101                	addi	sp,sp,-32
ffffffffc0200562:	ec06                	sd	ra,24(sp)
ffffffffc0200564:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200566:	39e000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020056a:	6522                	ld	a0,8(sp)
ffffffffc020056c:	4581                	li	a1,0
ffffffffc020056e:	4601                	li	a2,0
ffffffffc0200570:	4885                	li	a7,1
ffffffffc0200572:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200576:	60e2                	ld	ra,24(sp)
ffffffffc0200578:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc020057a:	a651                	j	ffffffffc02008fe <intr_enable>

ffffffffc020057c <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020057c:	100027f3          	csrr	a5,sstatus
ffffffffc0200580:	8b89                	andi	a5,a5,2
ffffffffc0200582:	eb89                	bnez	a5,ffffffffc0200594 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200584:	4501                	li	a0,0
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4889                	li	a7,2
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200592:	8082                	ret
int cons_getc(void) {
ffffffffc0200594:	1101                	addi	sp,sp,-32
ffffffffc0200596:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200598:	36c000ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc020059c:	4501                	li	a0,0
ffffffffc020059e:	4581                	li	a1,0
ffffffffc02005a0:	4601                	li	a2,0
ffffffffc02005a2:	4889                	li	a7,2
ffffffffc02005a4:	00000073          	ecall
ffffffffc02005a8:	2501                	sext.w	a0,a0
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005ac:	352000ef          	jal	ffffffffc02008fe <intr_enable>
}
ffffffffc02005b0:	60e2                	ld	ra,24(sp)
ffffffffc02005b2:	6522                	ld	a0,8(sp)
ffffffffc02005b4:	6105                	addi	sp,sp,32
ffffffffc02005b6:	8082                	ret

ffffffffc02005b8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005b8:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc02005ba:	00005517          	auipc	a0,0x5
ffffffffc02005be:	5c650513          	addi	a0,a0,1478 # ffffffffc0205b80 <etext+0x2d2>
void dtb_init(void) {
ffffffffc02005c2:	f406                	sd	ra,40(sp)
ffffffffc02005c4:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc02005c6:	bcfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005ca:	0000b597          	auipc	a1,0xb
ffffffffc02005ce:	a365b583          	ld	a1,-1482(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc02005d2:	00005517          	auipc	a0,0x5
ffffffffc02005d6:	5be50513          	addi	a0,a0,1470 # ffffffffc0205b90 <etext+0x2e2>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005da:	0000b417          	auipc	s0,0xb
ffffffffc02005de:	a2e40413          	addi	s0,s0,-1490 # ffffffffc020b008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005e2:	bb3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005e6:	600c                	ld	a1,0(s0)
ffffffffc02005e8:	00005517          	auipc	a0,0x5
ffffffffc02005ec:	5b850513          	addi	a0,a0,1464 # ffffffffc0205ba0 <etext+0x2f2>
ffffffffc02005f0:	ba5ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005f4:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005f6:	00005517          	auipc	a0,0x5
ffffffffc02005fa:	5c250513          	addi	a0,a0,1474 # ffffffffc0205bb8 <etext+0x30a>
    if (boot_dtb == 0) {
ffffffffc02005fe:	10070163          	beqz	a4,ffffffffc0200700 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200602:	57f5                	li	a5,-3
ffffffffc0200604:	07fa                	slli	a5,a5,0x1e
ffffffffc0200606:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200608:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020060a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020060e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe441f5>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200612:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200616:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020061e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200622:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200626:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200628:	8e49                	or	a2,a2,a0
ffffffffc020062a:	0ff7f793          	zext.b	a5,a5
ffffffffc020062e:	8dd1                	or	a1,a1,a2
ffffffffc0200630:	07a2                	slli	a5,a5,0x8
ffffffffc0200632:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200634:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc0200638:	0cd59863          	bne	a1,a3,ffffffffc0200708 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020063c:	4710                	lw	a2,8(a4)
ffffffffc020063e:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200640:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200642:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200646:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064a:	01865e1b          	srliw	t3,a2,0x18
ffffffffc020064e:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200652:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200656:	0186959b          	slliw	a1,a3,0x18
ffffffffc020065a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020065e:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200662:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200666:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020066a:	01c56533          	or	a0,a0,t3
ffffffffc020066e:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200672:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200676:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067e:	0ff6f693          	zext.b	a3,a3
ffffffffc0200682:	8c49                	or	s0,s0,a0
ffffffffc0200684:	0622                	slli	a2,a2,0x8
ffffffffc0200686:	8fcd                	or	a5,a5,a1
ffffffffc0200688:	06a2                	slli	a3,a3,0x8
ffffffffc020068a:	8c51                	or	s0,s0,a2
ffffffffc020068c:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020068e:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200690:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200692:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200694:	9381                	srli	a5,a5,0x20
ffffffffc0200696:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200698:	4301                	li	t1,0
        switch (token) {
ffffffffc020069a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020069c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020069e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc02006a2:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a4:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a6:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006aa:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ae:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	8ed1                	or	a3,a3,a2
ffffffffc02006c0:	0ff77713          	zext.b	a4,a4
ffffffffc02006c4:	8fd5                	or	a5,a5,a3
ffffffffc02006c6:	0722                	slli	a4,a4,0x8
ffffffffc02006c8:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc02006ca:	05178763          	beq	a5,a7,ffffffffc0200718 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006ce:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc02006d0:	00f8e963          	bltu	a7,a5,ffffffffc02006e2 <dtb_init+0x12a>
ffffffffc02006d4:	07c78d63          	beq	a5,t3,ffffffffc020074e <dtb_init+0x196>
ffffffffc02006d8:	4709                	li	a4,2
ffffffffc02006da:	00e79763          	bne	a5,a4,ffffffffc02006e8 <dtb_init+0x130>
ffffffffc02006de:	4301                	li	t1,0
ffffffffc02006e0:	b7d1                	j	ffffffffc02006a4 <dtb_init+0xec>
ffffffffc02006e2:	4711                	li	a4,4
ffffffffc02006e4:	fce780e3          	beq	a5,a4,ffffffffc02006a4 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006e8:	00005517          	auipc	a0,0x5
ffffffffc02006ec:	59850513          	addi	a0,a0,1432 # ffffffffc0205c80 <etext+0x3d2>
ffffffffc02006f0:	aa5ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f4:	64e2                	ld	s1,24(sp)
ffffffffc02006f6:	6942                	ld	s2,16(sp)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	5c050513          	addi	a0,a0,1472 # ffffffffc0205cb8 <etext+0x40a>
}
ffffffffc0200700:	7402                	ld	s0,32(sp)
ffffffffc0200702:	70a2                	ld	ra,40(sp)
ffffffffc0200704:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200706:	b479                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200708:	7402                	ld	s0,32(sp)
ffffffffc020070a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020070c:	00005517          	auipc	a0,0x5
ffffffffc0200710:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205bd8 <etext+0x32a>
}
ffffffffc0200714:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200716:	bcbd                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200718:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020071e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200722:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200726:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020072a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200732:	8ed1                	or	a3,a3,a2
ffffffffc0200734:	0ff77713          	zext.b	a4,a4
ffffffffc0200738:	8fd5                	or	a5,a5,a3
ffffffffc020073a:	0722                	slli	a4,a4,0x8
ffffffffc020073c:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020073e:	04031463          	bnez	t1,ffffffffc0200786 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200742:	1782                	slli	a5,a5,0x20
ffffffffc0200744:	9381                	srli	a5,a5,0x20
ffffffffc0200746:	043d                	addi	s0,s0,15
ffffffffc0200748:	943e                	add	s0,s0,a5
ffffffffc020074a:	9871                	andi	s0,s0,-4
                break;
ffffffffc020074c:	bfa1                	j	ffffffffc02006a4 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc020074e:	8522                	mv	a0,s0
ffffffffc0200750:	e01a                	sd	t1,0(sp)
ffffffffc0200752:	07e050ef          	jal	ffffffffc02057d0 <strlen>
ffffffffc0200756:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200758:	4619                	li	a2,6
ffffffffc020075a:	8522                	mv	a0,s0
ffffffffc020075c:	00005597          	auipc	a1,0x5
ffffffffc0200760:	4a458593          	addi	a1,a1,1188 # ffffffffc0205c00 <etext+0x352>
ffffffffc0200764:	0e6050ef          	jal	ffffffffc020584a <strncmp>
ffffffffc0200768:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020076a:	0411                	addi	s0,s0,4
ffffffffc020076c:	0004879b          	sext.w	a5,s1
ffffffffc0200770:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200772:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200776:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200778:	00a36333          	or	t1,t1,a0
                break;
ffffffffc020077c:	00ff0837          	lui	a6,0xff0
ffffffffc0200780:	488d                	li	a7,3
ffffffffc0200782:	4e05                	li	t3,1
ffffffffc0200784:	b705                	j	ffffffffc02006a4 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200786:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200788:	00005597          	auipc	a1,0x5
ffffffffc020078c:	48058593          	addi	a1,a1,1152 # ffffffffc0205c08 <etext+0x35a>
ffffffffc0200790:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200792:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200796:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020079e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007a6:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007aa:	8ed1                	or	a3,a3,a2
ffffffffc02007ac:	0ff77713          	zext.b	a4,a4
ffffffffc02007b0:	0722                	slli	a4,a4,0x8
ffffffffc02007b2:	8d55                	or	a0,a0,a3
ffffffffc02007b4:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007b6:	1502                	slli	a0,a0,0x20
ffffffffc02007b8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ba:	954a                	add	a0,a0,s2
ffffffffc02007bc:	e01a                	sd	t1,0(sp)
ffffffffc02007be:	058050ef          	jal	ffffffffc0205816 <strcmp>
ffffffffc02007c2:	67a2                	ld	a5,8(sp)
ffffffffc02007c4:	473d                	li	a4,15
ffffffffc02007c6:	6302                	ld	t1,0(sp)
ffffffffc02007c8:	00ff0837          	lui	a6,0xff0
ffffffffc02007cc:	488d                	li	a7,3
ffffffffc02007ce:	4e05                	li	t3,1
ffffffffc02007d0:	f6f779e3          	bgeu	a4,a5,ffffffffc0200742 <dtb_init+0x18a>
ffffffffc02007d4:	f53d                	bnez	a0,ffffffffc0200742 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007d6:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007da:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007de:	00005517          	auipc	a0,0x5
ffffffffc02007e2:	43250513          	addi	a0,a0,1074 # ffffffffc0205c10 <etext+0x362>
           fdt32_to_cpu(x >> 32);
ffffffffc02007e6:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ea:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007ee:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007f2:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f6:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007fa:	0187959b          	slliw	a1,a5,0x18
ffffffffc02007fe:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200802:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200806:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080e:	01037333          	and	t1,t1,a6
ffffffffc0200812:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200816:	01e5e5b3          	or	a1,a1,t5
ffffffffc020081a:	0ff7f793          	zext.b	a5,a5
ffffffffc020081e:	01de6e33          	or	t3,t3,t4
ffffffffc0200822:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200826:	01067633          	and	a2,a2,a6
ffffffffc020082a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020082e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	07a2                	slli	a5,a5,0x8
ffffffffc0200834:	0108d89b          	srliw	a7,a7,0x10
ffffffffc0200838:	0186df1b          	srliw	t5,a3,0x18
ffffffffc020083c:	01875e9b          	srliw	t4,a4,0x18
ffffffffc0200840:	8ddd                	or	a1,a1,a5
ffffffffc0200842:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200846:	0186979b          	slliw	a5,a3,0x18
ffffffffc020084a:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084e:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200852:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020085a:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085e:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200862:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200866:	08a2                	slli	a7,a7,0x8
ffffffffc0200868:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020086c:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200870:	0ff6f693          	zext.b	a3,a3
ffffffffc0200874:	01de6833          	or	a6,t3,t4
ffffffffc0200878:	0ff77713          	zext.b	a4,a4
ffffffffc020087c:	01166633          	or	a2,a2,a7
ffffffffc0200880:	0067e7b3          	or	a5,a5,t1
ffffffffc0200884:	06a2                	slli	a3,a3,0x8
ffffffffc0200886:	01046433          	or	s0,s0,a6
ffffffffc020088a:	0722                	slli	a4,a4,0x8
ffffffffc020088c:	8fd5                	or	a5,a5,a3
ffffffffc020088e:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200890:	1582                	slli	a1,a1,0x20
ffffffffc0200892:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200894:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200896:	9201                	srli	a2,a2,0x20
ffffffffc0200898:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020089a:	1402                	slli	s0,s0,0x20
ffffffffc020089c:	00b7e4b3          	or	s1,a5,a1
ffffffffc02008a0:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008a2:	8f3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008a6:	85a6                	mv	a1,s1
ffffffffc02008a8:	00005517          	auipc	a0,0x5
ffffffffc02008ac:	38850513          	addi	a0,a0,904 # ffffffffc0205c30 <etext+0x382>
ffffffffc02008b0:	8e5ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008b4:	01445613          	srli	a2,s0,0x14
ffffffffc02008b8:	85a2                	mv	a1,s0
ffffffffc02008ba:	00005517          	auipc	a0,0x5
ffffffffc02008be:	38e50513          	addi	a0,a0,910 # ffffffffc0205c48 <etext+0x39a>
ffffffffc02008c2:	8d3ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008c6:	009405b3          	add	a1,s0,s1
ffffffffc02008ca:	15fd                	addi	a1,a1,-1
ffffffffc02008cc:	00005517          	auipc	a0,0x5
ffffffffc02008d0:	39c50513          	addi	a0,a0,924 # ffffffffc0205c68 <etext+0x3ba>
ffffffffc02008d4:	8c1ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc02008d8:	0009b797          	auipc	a5,0x9b
ffffffffc02008dc:	3c97b023          	sd	s1,960(a5) # ffffffffc029bc98 <memory_base>
        memory_size = mem_size;
ffffffffc02008e0:	0009b797          	auipc	a5,0x9b
ffffffffc02008e4:	3a87b823          	sd	s0,944(a5) # ffffffffc029bc90 <memory_size>
ffffffffc02008e8:	b531                	j	ffffffffc02006f4 <dtb_init+0x13c>

ffffffffc02008ea <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008ea:	0009b517          	auipc	a0,0x9b
ffffffffc02008ee:	3ae53503          	ld	a0,942(a0) # ffffffffc029bc98 <memory_base>
ffffffffc02008f2:	8082                	ret

ffffffffc02008f4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008f4:	0009b517          	auipc	a0,0x9b
ffffffffc02008f8:	39c53503          	ld	a0,924(a0) # ffffffffc029bc90 <memory_size>
ffffffffc02008fc:	8082                	ret

ffffffffc02008fe <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02008fe:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200902:	8082                	ret

ffffffffc0200904 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200904:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200908:	8082                	ret

ffffffffc020090a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020090a:	8082                	ret

ffffffffc020090c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020090c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200910:	00000797          	auipc	a5,0x0
ffffffffc0200914:	5dc78793          	addi	a5,a5,1500 # ffffffffc0200eec <__alltraps>
ffffffffc0200918:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020091c:	000407b7          	lui	a5,0x40
ffffffffc0200920:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200924:	8082                	ret

ffffffffc0200926 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200926:	610c                	ld	a1,0(a0)
{
ffffffffc0200928:	1141                	addi	sp,sp,-16
ffffffffc020092a:	e022                	sd	s0,0(sp)
ffffffffc020092c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020092e:	00005517          	auipc	a0,0x5
ffffffffc0200932:	3a250513          	addi	a0,a0,930 # ffffffffc0205cd0 <etext+0x422>
{
ffffffffc0200936:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200938:	85dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020093c:	640c                	ld	a1,8(s0)
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	3aa50513          	addi	a0,a0,938 # ffffffffc0205ce8 <etext+0x43a>
ffffffffc0200946:	84fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020094a:	680c                	ld	a1,16(s0)
ffffffffc020094c:	00005517          	auipc	a0,0x5
ffffffffc0200950:	3b450513          	addi	a0,a0,948 # ffffffffc0205d00 <etext+0x452>
ffffffffc0200954:	841ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200958:	6c0c                	ld	a1,24(s0)
ffffffffc020095a:	00005517          	auipc	a0,0x5
ffffffffc020095e:	3be50513          	addi	a0,a0,958 # ffffffffc0205d18 <etext+0x46a>
ffffffffc0200962:	833ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200966:	700c                	ld	a1,32(s0)
ffffffffc0200968:	00005517          	auipc	a0,0x5
ffffffffc020096c:	3c850513          	addi	a0,a0,968 # ffffffffc0205d30 <etext+0x482>
ffffffffc0200970:	825ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200974:	740c                	ld	a1,40(s0)
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	3d250513          	addi	a0,a0,978 # ffffffffc0205d48 <etext+0x49a>
ffffffffc020097e:	817ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200982:	780c                	ld	a1,48(s0)
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	3dc50513          	addi	a0,a0,988 # ffffffffc0205d60 <etext+0x4b2>
ffffffffc020098c:	809ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200990:	7c0c                	ld	a1,56(s0)
ffffffffc0200992:	00005517          	auipc	a0,0x5
ffffffffc0200996:	3e650513          	addi	a0,a0,998 # ffffffffc0205d78 <etext+0x4ca>
ffffffffc020099a:	ffaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020099e:	602c                	ld	a1,64(s0)
ffffffffc02009a0:	00005517          	auipc	a0,0x5
ffffffffc02009a4:	3f050513          	addi	a0,a0,1008 # ffffffffc0205d90 <etext+0x4e2>
ffffffffc02009a8:	fecff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009ac:	642c                	ld	a1,72(s0)
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205da8 <etext+0x4fa>
ffffffffc02009b6:	fdeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ba:	682c                	ld	a1,80(s0)
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	40450513          	addi	a0,a0,1028 # ffffffffc0205dc0 <etext+0x512>
ffffffffc02009c4:	fd0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009c8:	6c2c                	ld	a1,88(s0)
ffffffffc02009ca:	00005517          	auipc	a0,0x5
ffffffffc02009ce:	40e50513          	addi	a0,a0,1038 # ffffffffc0205dd8 <etext+0x52a>
ffffffffc02009d2:	fc2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02009d6:	702c                	ld	a1,96(s0)
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	41850513          	addi	a0,a0,1048 # ffffffffc0205df0 <etext+0x542>
ffffffffc02009e0:	fb4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02009e4:	742c                	ld	a1,104(s0)
ffffffffc02009e6:	00005517          	auipc	a0,0x5
ffffffffc02009ea:	42250513          	addi	a0,a0,1058 # ffffffffc0205e08 <etext+0x55a>
ffffffffc02009ee:	fa6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02009f2:	782c                	ld	a1,112(s0)
ffffffffc02009f4:	00005517          	auipc	a0,0x5
ffffffffc02009f8:	42c50513          	addi	a0,a0,1068 # ffffffffc0205e20 <etext+0x572>
ffffffffc02009fc:	f98ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a00:	7c2c                	ld	a1,120(s0)
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	43650513          	addi	a0,a0,1078 # ffffffffc0205e38 <etext+0x58a>
ffffffffc0200a0a:	f8aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a0e:	604c                	ld	a1,128(s0)
ffffffffc0200a10:	00005517          	auipc	a0,0x5
ffffffffc0200a14:	44050513          	addi	a0,a0,1088 # ffffffffc0205e50 <etext+0x5a2>
ffffffffc0200a18:	f7cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a1c:	644c                	ld	a1,136(s0)
ffffffffc0200a1e:	00005517          	auipc	a0,0x5
ffffffffc0200a22:	44a50513          	addi	a0,a0,1098 # ffffffffc0205e68 <etext+0x5ba>
ffffffffc0200a26:	f6eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a2a:	684c                	ld	a1,144(s0)
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	45450513          	addi	a0,a0,1108 # ffffffffc0205e80 <etext+0x5d2>
ffffffffc0200a34:	f60ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a38:	6c4c                	ld	a1,152(s0)
ffffffffc0200a3a:	00005517          	auipc	a0,0x5
ffffffffc0200a3e:	45e50513          	addi	a0,a0,1118 # ffffffffc0205e98 <etext+0x5ea>
ffffffffc0200a42:	f52ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a46:	704c                	ld	a1,160(s0)
ffffffffc0200a48:	00005517          	auipc	a0,0x5
ffffffffc0200a4c:	46850513          	addi	a0,a0,1128 # ffffffffc0205eb0 <etext+0x602>
ffffffffc0200a50:	f44ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a54:	744c                	ld	a1,168(s0)
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	47250513          	addi	a0,a0,1138 # ffffffffc0205ec8 <etext+0x61a>
ffffffffc0200a5e:	f36ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a62:	784c                	ld	a1,176(s0)
ffffffffc0200a64:	00005517          	auipc	a0,0x5
ffffffffc0200a68:	47c50513          	addi	a0,a0,1148 # ffffffffc0205ee0 <etext+0x632>
ffffffffc0200a6c:	f28ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a70:	7c4c                	ld	a1,184(s0)
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	48650513          	addi	a0,a0,1158 # ffffffffc0205ef8 <etext+0x64a>
ffffffffc0200a7a:	f1aff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200a7e:	606c                	ld	a1,192(s0)
ffffffffc0200a80:	00005517          	auipc	a0,0x5
ffffffffc0200a84:	49050513          	addi	a0,a0,1168 # ffffffffc0205f10 <etext+0x662>
ffffffffc0200a88:	f0cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200a8c:	646c                	ld	a1,200(s0)
ffffffffc0200a8e:	00005517          	auipc	a0,0x5
ffffffffc0200a92:	49a50513          	addi	a0,a0,1178 # ffffffffc0205f28 <etext+0x67a>
ffffffffc0200a96:	efeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a9a:	686c                	ld	a1,208(s0)
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	4a450513          	addi	a0,a0,1188 # ffffffffc0205f40 <etext+0x692>
ffffffffc0200aa4:	ef0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200aa8:	6c6c                	ld	a1,216(s0)
ffffffffc0200aaa:	00005517          	auipc	a0,0x5
ffffffffc0200aae:	4ae50513          	addi	a0,a0,1198 # ffffffffc0205f58 <etext+0x6aa>
ffffffffc0200ab2:	ee2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ab6:	706c                	ld	a1,224(s0)
ffffffffc0200ab8:	00005517          	auipc	a0,0x5
ffffffffc0200abc:	4b850513          	addi	a0,a0,1208 # ffffffffc0205f70 <etext+0x6c2>
ffffffffc0200ac0:	ed4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200ac4:	746c                	ld	a1,232(s0)
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	4c250513          	addi	a0,a0,1218 # ffffffffc0205f88 <etext+0x6da>
ffffffffc0200ace:	ec6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200ad2:	786c                	ld	a1,240(s0)
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205fa0 <etext+0x6f2>
ffffffffc0200adc:	eb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae0:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200ae2:	6402                	ld	s0,0(sp)
ffffffffc0200ae4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	4d250513          	addi	a0,a0,1234 # ffffffffc0205fb8 <etext+0x70a>
}
ffffffffc0200aee:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200af0:	ea4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200af4 <print_trapframe>:
{
ffffffffc0200af4:	1141                	addi	sp,sp,-16
ffffffffc0200af6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200af8:	85aa                	mv	a1,a0
{
ffffffffc0200afa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200afc:	00005517          	auipc	a0,0x5
ffffffffc0200b00:	4d450513          	addi	a0,a0,1236 # ffffffffc0205fd0 <etext+0x722>
{
ffffffffc0200b04:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b06:	e8eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b0a:	8522                	mv	a0,s0
ffffffffc0200b0c:	e1bff0ef          	jal	ffffffffc0200926 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b10:	10043583          	ld	a1,256(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	4d450513          	addi	a0,a0,1236 # ffffffffc0205fe8 <etext+0x73a>
ffffffffc0200b1c:	e78ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b20:	10843583          	ld	a1,264(s0)
ffffffffc0200b24:	00005517          	auipc	a0,0x5
ffffffffc0200b28:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206000 <etext+0x752>
ffffffffc0200b2c:	e68ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200b30:	11043583          	ld	a1,272(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	4e450513          	addi	a0,a0,1252 # ffffffffc0206018 <etext+0x76a>
ffffffffc0200b3c:	e58ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b40:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b44:	6402                	ld	s0,0(sp)
ffffffffc0200b46:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	4e050513          	addi	a0,a0,1248 # ffffffffc0206028 <etext+0x77a>
}
ffffffffc0200b50:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b52:	e42ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b56 <pgfault_handler.isra.0>:
    if (current == NULL) {
ffffffffc0200b56:	0009b797          	auipc	a5,0x9b
ffffffffc0200b5a:	18a7b783          	ld	a5,394(a5) # ffffffffc029bce0 <current>
pgfault_handler(struct trapframe *tf) {
ffffffffc0200b5e:	1141                	addi	sp,sp,-16
ffffffffc0200b60:	e406                	sd	ra,8(sp)
    if (current == NULL) {
ffffffffc0200b62:	c791                	beqz	a5,ffffffffc0200b6e <pgfault_handler.isra.0+0x18>
    if (current->mm == NULL) {
ffffffffc0200b64:	779c                	ld	a5,40(a5)
ffffffffc0200b66:	c395                	beqz	a5,ffffffffc0200b8a <pgfault_handler.isra.0+0x34>
}
ffffffffc0200b68:	60a2                	ld	ra,8(sp)
ffffffffc0200b6a:	0141                	addi	sp,sp,16
ffffffffc0200b6c:	8082                	ret
        print_trapframe(tf);
ffffffffc0200b6e:	f87ff0ef          	jal	ffffffffc0200af4 <print_trapframe>
        panic("page fault in kernel!");
ffffffffc0200b72:	00005617          	auipc	a2,0x5
ffffffffc0200b76:	4ce60613          	addi	a2,a2,1230 # ffffffffc0206040 <etext+0x792>
ffffffffc0200b7a:	02400593          	li	a1,36
ffffffffc0200b7e:	00005517          	auipc	a0,0x5
ffffffffc0200b82:	4da50513          	addi	a0,a0,1242 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200b86:	8c1ff0ef          	jal	ffffffffc0200446 <__panic>
        print_trapframe(tf);
ffffffffc0200b8a:	f6bff0ef          	jal	ffffffffc0200af4 <print_trapframe>
        panic("page fault in kernel thread!");
ffffffffc0200b8e:	00005617          	auipc	a2,0x5
ffffffffc0200b92:	4e260613          	addi	a2,a2,1250 # ffffffffc0206070 <etext+0x7c2>
ffffffffc0200b96:	02900593          	li	a1,41
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	4be50513          	addi	a0,a0,1214 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200ba2:	8a5ff0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0200ba6 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200ba6:	11853783          	ld	a5,280(a0)
ffffffffc0200baa:	472d                	li	a4,11
ffffffffc0200bac:	0786                	slli	a5,a5,0x1
ffffffffc0200bae:	8385                	srli	a5,a5,0x1
ffffffffc0200bb0:	08f76d63          	bltu	a4,a5,ffffffffc0200c4a <interrupt_handler+0xa4>
ffffffffc0200bb4:	00007717          	auipc	a4,0x7
ffffffffc0200bb8:	ad470713          	addi	a4,a4,-1324 # ffffffffc0207688 <commands+0x48>
ffffffffc0200bbc:	078a                	slli	a5,a5,0x2
ffffffffc0200bbe:	97ba                	add	a5,a5,a4
ffffffffc0200bc0:	439c                	lw	a5,0(a5)
ffffffffc0200bc2:	97ba                	add	a5,a5,a4
ffffffffc0200bc4:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200bc6:	00005517          	auipc	a0,0x5
ffffffffc0200bca:	52a50513          	addi	a0,a0,1322 # ffffffffc02060f0 <etext+0x842>
ffffffffc0200bce:	dc6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bd2:	00005517          	auipc	a0,0x5
ffffffffc0200bd6:	4fe50513          	addi	a0,a0,1278 # ffffffffc02060d0 <etext+0x822>
ffffffffc0200bda:	dbaff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200bde:	00005517          	auipc	a0,0x5
ffffffffc0200be2:	4b250513          	addi	a0,a0,1202 # ffffffffc0206090 <etext+0x7e2>
ffffffffc0200be6:	daeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200bea:	00005517          	auipc	a0,0x5
ffffffffc0200bee:	4c650513          	addi	a0,a0,1222 # ffffffffc02060b0 <etext+0x802>
ffffffffc0200bf2:	da2ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200bf6:	1141                	addi	sp,sp,-16
ffffffffc0200bf8:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200bfa:	933ff0ef          	jal	ffffffffc020052c <clock_set_next_event>
        ticks++;
ffffffffc0200bfe:	0009b797          	auipc	a5,0x9b
ffffffffc0200c02:	08a78793          	addi	a5,a5,138 # ffffffffc029bc88 <ticks>
ffffffffc0200c06:	6394                	ld	a3,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200c08:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200c0c:	28f70713          	addi	a4,a4,655 # 28f5c28f <_binary_obj___user_exit_out_size+0x28f520d7>
        ticks++;
ffffffffc0200c10:	0685                	addi	a3,a3,1
ffffffffc0200c12:	e394                	sd	a3,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200c14:	6390                	ld	a2,0(a5)
ffffffffc0200c16:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200c1a:	1702                	slli	a4,a4,0x20
ffffffffc0200c1c:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <_binary_obj___user_exit_out_size+0x5c28540b>
ffffffffc0200c20:	00265793          	srli	a5,a2,0x2
ffffffffc0200c24:	9736                	add	a4,a4,a3
ffffffffc0200c26:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200c2a:	06400593          	li	a1,100
ffffffffc0200c2e:	8389                	srli	a5,a5,0x2
ffffffffc0200c30:	02b787b3          	mul	a5,a5,a1
ffffffffc0200c34:	00f60c63          	beq	a2,a5,ffffffffc0200c4c <interrupt_handler+0xa6>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c38:	60a2                	ld	ra,8(sp)
ffffffffc0200c3a:	0141                	addi	sp,sp,16
ffffffffc0200c3c:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	4e250513          	addi	a0,a0,1250 # ffffffffc0206120 <etext+0x872>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c4a:	b56d                	j	ffffffffc0200af4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c4c:	00005517          	auipc	a0,0x5
ffffffffc0200c50:	4c450513          	addi	a0,a0,1220 # ffffffffc0206110 <etext+0x862>
ffffffffc0200c54:	d40ff0ef          	jal	ffffffffc0200194 <cprintf>
            if(current != NULL)
ffffffffc0200c58:	0009b797          	auipc	a5,0x9b
ffffffffc0200c5c:	0887b783          	ld	a5,136(a5) # ffffffffc029bce0 <current>
ffffffffc0200c60:	dfe1                	beqz	a5,ffffffffc0200c38 <interrupt_handler+0x92>
                current->need_resched = 1;
ffffffffc0200c62:	4705                	li	a4,1
ffffffffc0200c64:	ef98                	sd	a4,24(a5)
ffffffffc0200c66:	bfc9                	j	ffffffffc0200c38 <interrupt_handler+0x92>

ffffffffc0200c68 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c68:	11853783          	ld	a5,280(a0)
ffffffffc0200c6c:	473d                	li	a4,15
ffffffffc0200c6e:	1ef76063          	bltu	a4,a5,ffffffffc0200e4e <exception_handler+0x1e6>
ffffffffc0200c72:	00007717          	auipc	a4,0x7
ffffffffc0200c76:	a4670713          	addi	a4,a4,-1466 # ffffffffc02076b8 <commands+0x78>
ffffffffc0200c7a:	078a                	slli	a5,a5,0x2
ffffffffc0200c7c:	97ba                	add	a5,a5,a4
ffffffffc0200c7e:	439c                	lw	a5,0(a5)
{
ffffffffc0200c80:	1101                	addi	sp,sp,-32
ffffffffc0200c82:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200c84:	97ba                	add	a5,a5,a4
ffffffffc0200c86:	86aa                	mv	a3,a0
ffffffffc0200c88:	8782                	jr	a5
ffffffffc0200c8a:	e42a                	sd	a0,8(sp)
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200c8c:	00005517          	auipc	a0,0x5
ffffffffc0200c90:	58450513          	addi	a0,a0,1412 # ffffffffc0206210 <etext+0x962>
ffffffffc0200c94:	d00ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200c98:	66a2                	ld	a3,8(sp)
ffffffffc0200c9a:	1086b783          	ld	a5,264(a3)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c9e:	60e2                	ld	ra,24(sp)
        tf->epc += 4;
ffffffffc0200ca0:	0791                	addi	a5,a5,4
ffffffffc0200ca2:	10f6b423          	sd	a5,264(a3)
}
ffffffffc0200ca6:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200ca8:	6ca0406f          	j	ffffffffc0205372 <syscall>
}
ffffffffc0200cac:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200cae:	00005517          	auipc	a0,0x5
ffffffffc0200cb2:	58250513          	addi	a0,a0,1410 # ffffffffc0206230 <etext+0x982>
}
ffffffffc0200cb6:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200cb8:	cdcff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cbc:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200cbe:	00005517          	auipc	a0,0x5
ffffffffc0200cc2:	59250513          	addi	a0,a0,1426 # ffffffffc0206250 <etext+0x9a2>
}
ffffffffc0200cc6:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200cc8:	cccff06f          	j	ffffffffc0200194 <cprintf>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200ccc:	e42a                	sd	a0,8(sp)
ffffffffc0200cce:	e89ff0ef          	jal	ffffffffc0200b56 <pgfault_handler.isra.0>
            cprintf("Fetch page fault\n");
ffffffffc0200cd2:	00005517          	auipc	a0,0x5
ffffffffc0200cd6:	59e50513          	addi	a0,a0,1438 # ffffffffc0206270 <etext+0x9c2>
ffffffffc0200cda:	cbaff0ef          	jal	ffffffffc0200194 <cprintf>
            print_trapframe(tf);
ffffffffc0200cde:	6522                	ld	a0,8(sp)
ffffffffc0200ce0:	e15ff0ef          	jal	ffffffffc0200af4 <print_trapframe>
            if (current != NULL) {
ffffffffc0200ce4:	0009b797          	auipc	a5,0x9b
ffffffffc0200ce8:	ffc7b783          	ld	a5,-4(a5) # ffffffffc029bce0 <current>
ffffffffc0200cec:	16078263          	beqz	a5,ffffffffc0200e50 <exception_handler+0x1e8>
}
ffffffffc0200cf0:	60e2                	ld	ra,24(sp)
                do_exit(-E_KILLED);
ffffffffc0200cf2:	555d                	li	a0,-9
}
ffffffffc0200cf4:	6105                	addi	sp,sp,32
                do_exit(-E_KILLED);
ffffffffc0200cf6:	0310306f          	j	ffffffffc0204526 <do_exit>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200cfa:	e42a                	sd	a0,8(sp)
ffffffffc0200cfc:	e5bff0ef          	jal	ffffffffc0200b56 <pgfault_handler.isra.0>
            cprintf("Load page fault\n");
ffffffffc0200d00:	00005517          	auipc	a0,0x5
ffffffffc0200d04:	5a050513          	addi	a0,a0,1440 # ffffffffc02062a0 <etext+0x9f2>
ffffffffc0200d08:	c8cff0ef          	jal	ffffffffc0200194 <cprintf>
            print_trapframe(tf);
ffffffffc0200d0c:	6522                	ld	a0,8(sp)
ffffffffc0200d0e:	de7ff0ef          	jal	ffffffffc0200af4 <print_trapframe>
            if (current != NULL) {
ffffffffc0200d12:	0009b797          	auipc	a5,0x9b
ffffffffc0200d16:	fce7b783          	ld	a5,-50(a5) # ffffffffc029bce0 <current>
ffffffffc0200d1a:	fbf9                	bnez	a5,ffffffffc0200cf0 <exception_handler+0x88>
                panic("kernel page fault");
ffffffffc0200d1c:	00005617          	auipc	a2,0x5
ffffffffc0200d20:	56c60613          	addi	a2,a2,1388 # ffffffffc0206288 <etext+0x9da>
ffffffffc0200d24:	10100593          	li	a1,257
ffffffffc0200d28:	00005517          	auipc	a0,0x5
ffffffffc0200d2c:	33050513          	addi	a0,a0,816 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200d30:	f16ff0ef          	jal	ffffffffc0200446 <__panic>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d34:	e42a                	sd	a0,8(sp)
ffffffffc0200d36:	e21ff0ef          	jal	ffffffffc0200b56 <pgfault_handler.isra.0>
            cprintf("Store/AMO page fault\n");
ffffffffc0200d3a:	00005517          	auipc	a0,0x5
ffffffffc0200d3e:	57e50513          	addi	a0,a0,1406 # ffffffffc02062b8 <etext+0xa0a>
ffffffffc0200d42:	c52ff0ef          	jal	ffffffffc0200194 <cprintf>
            print_trapframe(tf);
ffffffffc0200d46:	6522                	ld	a0,8(sp)
ffffffffc0200d48:	dadff0ef          	jal	ffffffffc0200af4 <print_trapframe>
            if (current != NULL) {
ffffffffc0200d4c:	0009b797          	auipc	a5,0x9b
ffffffffc0200d50:	f947b783          	ld	a5,-108(a5) # ffffffffc029bce0 <current>
ffffffffc0200d54:	ffd1                	bnez	a5,ffffffffc0200cf0 <exception_handler+0x88>
                panic("kernel page fault");
ffffffffc0200d56:	00005617          	auipc	a2,0x5
ffffffffc0200d5a:	53260613          	addi	a2,a2,1330 # ffffffffc0206288 <etext+0x9da>
ffffffffc0200d5e:	10c00593          	li	a1,268
ffffffffc0200d62:	00005517          	auipc	a0,0x5
ffffffffc0200d66:	2f650513          	addi	a0,a0,758 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200d6a:	edcff0ef          	jal	ffffffffc0200446 <__panic>
}
ffffffffc0200d6e:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200d70:	00005517          	auipc	a0,0x5
ffffffffc0200d74:	3d050513          	addi	a0,a0,976 # ffffffffc0206140 <etext+0x892>
}
ffffffffc0200d78:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200d7a:	c1aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d7e:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200d80:	00005517          	auipc	a0,0x5
ffffffffc0200d84:	3e050513          	addi	a0,a0,992 # ffffffffc0206160 <etext+0x8b2>
}
ffffffffc0200d88:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200d8a:	c0aff06f          	j	ffffffffc0200194 <cprintf>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200d8e:	10053783          	ld	a5,256(a0)
ffffffffc0200d92:	1007f793          	andi	a5,a5,256
        if (!trap_in_kernel(tf) && tf->tval == 0) {
ffffffffc0200d96:	e7b5                	bnez	a5,ffffffffc0200e02 <exception_handler+0x19a>
ffffffffc0200d98:	11053783          	ld	a5,272(a0)
ffffffffc0200d9c:	e3bd                	bnez	a5,ffffffffc0200e02 <exception_handler+0x19a>
            tf->epc += 4; // 跳过出错指令
ffffffffc0200d9e:	10853783          	ld	a5,264(a0)
            tf->gpr.a0 = -1;
ffffffffc0200da2:	577d                	li	a4,-1
ffffffffc0200da4:	e938                	sd	a4,80(a0)
            tf->epc += 4; // 跳过出错指令
ffffffffc0200da6:	0791                	addi	a5,a5,4
ffffffffc0200da8:	10f53423          	sd	a5,264(a0)
            return;
ffffffffc0200dac:	a829                	j	ffffffffc0200dc6 <exception_handler+0x15e>
ffffffffc0200dae:	e42a                	sd	a0,8(sp)
        cprintf("Breakpoint\n");
ffffffffc0200db0:	00005517          	auipc	a0,0x5
ffffffffc0200db4:	3e850513          	addi	a0,a0,1000 # ffffffffc0206198 <etext+0x8ea>
ffffffffc0200db8:	bdcff0ef          	jal	ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200dbc:	66a2                	ld	a3,8(sp)
ffffffffc0200dbe:	47a9                	li	a5,10
ffffffffc0200dc0:	66d8                	ld	a4,136(a3)
ffffffffc0200dc2:	06f70463          	beq	a4,a5,ffffffffc0200e2a <exception_handler+0x1c2>
}
ffffffffc0200dc6:	60e2                	ld	ra,24(sp)
ffffffffc0200dc8:	6105                	addi	sp,sp,32
ffffffffc0200dca:	8082                	ret
ffffffffc0200dcc:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200dce:	00005517          	auipc	a0,0x5
ffffffffc0200dd2:	3fa50513          	addi	a0,a0,1018 # ffffffffc02061c8 <etext+0x91a>
}
ffffffffc0200dd6:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200dd8:	bbcff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200ddc:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200dde:	00005517          	auipc	a0,0x5
ffffffffc0200de2:	41a50513          	addi	a0,a0,1050 # ffffffffc02061f8 <etext+0x94a>
}
ffffffffc0200de6:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200de8:	bacff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200dec:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200dee:	00005517          	auipc	a0,0x5
ffffffffc0200df2:	3ba50513          	addi	a0,a0,954 # ffffffffc02061a8 <etext+0x8fa>
}
ffffffffc0200df6:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200df8:	b9cff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200dfc:	60e2                	ld	ra,24(sp)
ffffffffc0200dfe:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200e00:	b9d5                	j	ffffffffc0200af4 <print_trapframe>
}
ffffffffc0200e02:	60e2                	ld	ra,24(sp)
        cprintf("Illegal instruction\n");
ffffffffc0200e04:	00005517          	auipc	a0,0x5
ffffffffc0200e08:	37c50513          	addi	a0,a0,892 # ffffffffc0206180 <etext+0x8d2>
}
ffffffffc0200e0c:	6105                	addi	sp,sp,32
        cprintf("Illegal instruction\n");
ffffffffc0200e0e:	b86ff06f          	j	ffffffffc0200194 <cprintf>
        panic("AMO address misaligned\n");
ffffffffc0200e12:	00005617          	auipc	a2,0x5
ffffffffc0200e16:	3ce60613          	addi	a2,a2,974 # ffffffffc02061e0 <etext+0x932>
ffffffffc0200e1a:	0da00593          	li	a1,218
ffffffffc0200e1e:	00005517          	auipc	a0,0x5
ffffffffc0200e22:	23a50513          	addi	a0,a0,570 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200e26:	e20ff0ef          	jal	ffffffffc0200446 <__panic>
            tf->epc += 4;
ffffffffc0200e2a:	1086b783          	ld	a5,264(a3)
ffffffffc0200e2e:	0791                	addi	a5,a5,4
ffffffffc0200e30:	10f6b423          	sd	a5,264(a3)
            syscall();
ffffffffc0200e34:	53e040ef          	jal	ffffffffc0205372 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e38:	0009b717          	auipc	a4,0x9b
ffffffffc0200e3c:	ea873703          	ld	a4,-344(a4) # ffffffffc029bce0 <current>
ffffffffc0200e40:	6522                	ld	a0,8(sp)
}
ffffffffc0200e42:	60e2                	ld	ra,24(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e44:	6b0c                	ld	a1,16(a4)
ffffffffc0200e46:	6789                	lui	a5,0x2
ffffffffc0200e48:	95be                	add	a1,a1,a5
}
ffffffffc0200e4a:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e4c:	a2bd                	j	ffffffffc0200fba <kernel_execve_ret>
        print_trapframe(tf);
ffffffffc0200e4e:	b15d                	j	ffffffffc0200af4 <print_trapframe>
                panic("kernel page fault");
ffffffffc0200e50:	00005617          	auipc	a2,0x5
ffffffffc0200e54:	43860613          	addi	a2,a2,1080 # ffffffffc0206288 <etext+0x9da>
ffffffffc0200e58:	0f600593          	li	a1,246
ffffffffc0200e5c:	00005517          	auipc	a0,0x5
ffffffffc0200e60:	1fc50513          	addi	a0,a0,508 # ffffffffc0206058 <etext+0x7aa>
ffffffffc0200e64:	de2ff0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0200e68 <trap>:
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e68:	0009b717          	auipc	a4,0x9b
ffffffffc0200e6c:	e7873703          	ld	a4,-392(a4) # ffffffffc029bce0 <current>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e70:	11853583          	ld	a1,280(a0)
    if (current == NULL)
ffffffffc0200e74:	cf21                	beqz	a4,ffffffffc0200ecc <trap+0x64>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e76:	10053603          	ld	a2,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e7a:	0a073803          	ld	a6,160(a4)
{
ffffffffc0200e7e:	1101                	addi	sp,sp,-32
ffffffffc0200e80:	ec06                	sd	ra,24(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e82:	10067613          	andi	a2,a2,256
        current->tf = tf;
ffffffffc0200e86:	f348                	sd	a0,160(a4)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e88:	e432                	sd	a2,8(sp)
ffffffffc0200e8a:	e042                	sd	a6,0(sp)
ffffffffc0200e8c:	0205c763          	bltz	a1,ffffffffc0200eba <trap+0x52>
        exception_handler(tf);
ffffffffc0200e90:	dd9ff0ef          	jal	ffffffffc0200c68 <exception_handler>
ffffffffc0200e94:	6622                	ld	a2,8(sp)
ffffffffc0200e96:	6802                	ld	a6,0(sp)
ffffffffc0200e98:	0009b697          	auipc	a3,0x9b
ffffffffc0200e9c:	e4868693          	addi	a3,a3,-440 # ffffffffc029bce0 <current>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ea0:	6298                	ld	a4,0(a3)
ffffffffc0200ea2:	0b073023          	sd	a6,160(a4)
        if (!in_kernel)
ffffffffc0200ea6:	e619                	bnez	a2,ffffffffc0200eb4 <trap+0x4c>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200ea8:	0b072783          	lw	a5,176(a4)
ffffffffc0200eac:	8b85                	andi	a5,a5,1
ffffffffc0200eae:	e79d                	bnez	a5,ffffffffc0200edc <trap+0x74>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200eb0:	6f1c                	ld	a5,24(a4)
ffffffffc0200eb2:	e38d                	bnez	a5,ffffffffc0200ed4 <trap+0x6c>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200eb4:	60e2                	ld	ra,24(sp)
ffffffffc0200eb6:	6105                	addi	sp,sp,32
ffffffffc0200eb8:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200eba:	cedff0ef          	jal	ffffffffc0200ba6 <interrupt_handler>
ffffffffc0200ebe:	6802                	ld	a6,0(sp)
ffffffffc0200ec0:	6622                	ld	a2,8(sp)
ffffffffc0200ec2:	0009b697          	auipc	a3,0x9b
ffffffffc0200ec6:	e1e68693          	addi	a3,a3,-482 # ffffffffc029bce0 <current>
ffffffffc0200eca:	bfd9                	j	ffffffffc0200ea0 <trap+0x38>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ecc:	0005c363          	bltz	a1,ffffffffc0200ed2 <trap+0x6a>
        exception_handler(tf);
ffffffffc0200ed0:	bb61                	j	ffffffffc0200c68 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200ed2:	b9d1                	j	ffffffffc0200ba6 <interrupt_handler>
}
ffffffffc0200ed4:	60e2                	ld	ra,24(sp)
ffffffffc0200ed6:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ed8:	3ae0406f          	j	ffffffffc0205286 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200edc:	555d                	li	a0,-9
ffffffffc0200ede:	648030ef          	jal	ffffffffc0204526 <do_exit>
            if (current->need_resched)
ffffffffc0200ee2:	0009b717          	auipc	a4,0x9b
ffffffffc0200ee6:	dfe73703          	ld	a4,-514(a4) # ffffffffc029bce0 <current>
ffffffffc0200eea:	b7d9                	j	ffffffffc0200eb0 <trap+0x48>

ffffffffc0200eec <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200eec:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200ef0:	00011463          	bnez	sp,ffffffffc0200ef8 <__alltraps+0xc>
ffffffffc0200ef4:	14002173          	csrr	sp,sscratch
ffffffffc0200ef8:	712d                	addi	sp,sp,-288
ffffffffc0200efa:	e002                	sd	zero,0(sp)
ffffffffc0200efc:	e406                	sd	ra,8(sp)
ffffffffc0200efe:	ec0e                	sd	gp,24(sp)
ffffffffc0200f00:	f012                	sd	tp,32(sp)
ffffffffc0200f02:	f416                	sd	t0,40(sp)
ffffffffc0200f04:	f81a                	sd	t1,48(sp)
ffffffffc0200f06:	fc1e                	sd	t2,56(sp)
ffffffffc0200f08:	e0a2                	sd	s0,64(sp)
ffffffffc0200f0a:	e4a6                	sd	s1,72(sp)
ffffffffc0200f0c:	e8aa                	sd	a0,80(sp)
ffffffffc0200f0e:	ecae                	sd	a1,88(sp)
ffffffffc0200f10:	f0b2                	sd	a2,96(sp)
ffffffffc0200f12:	f4b6                	sd	a3,104(sp)
ffffffffc0200f14:	f8ba                	sd	a4,112(sp)
ffffffffc0200f16:	fcbe                	sd	a5,120(sp)
ffffffffc0200f18:	e142                	sd	a6,128(sp)
ffffffffc0200f1a:	e546                	sd	a7,136(sp)
ffffffffc0200f1c:	e94a                	sd	s2,144(sp)
ffffffffc0200f1e:	ed4e                	sd	s3,152(sp)
ffffffffc0200f20:	f152                	sd	s4,160(sp)
ffffffffc0200f22:	f556                	sd	s5,168(sp)
ffffffffc0200f24:	f95a                	sd	s6,176(sp)
ffffffffc0200f26:	fd5e                	sd	s7,184(sp)
ffffffffc0200f28:	e1e2                	sd	s8,192(sp)
ffffffffc0200f2a:	e5e6                	sd	s9,200(sp)
ffffffffc0200f2c:	e9ea                	sd	s10,208(sp)
ffffffffc0200f2e:	edee                	sd	s11,216(sp)
ffffffffc0200f30:	f1f2                	sd	t3,224(sp)
ffffffffc0200f32:	f5f6                	sd	t4,232(sp)
ffffffffc0200f34:	f9fa                	sd	t5,240(sp)
ffffffffc0200f36:	fdfe                	sd	t6,248(sp)
ffffffffc0200f38:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f3c:	100024f3          	csrr	s1,sstatus
ffffffffc0200f40:	14102973          	csrr	s2,sepc
ffffffffc0200f44:	143029f3          	csrr	s3,stval
ffffffffc0200f48:	14202a73          	csrr	s4,scause
ffffffffc0200f4c:	e822                	sd	s0,16(sp)
ffffffffc0200f4e:	e226                	sd	s1,256(sp)
ffffffffc0200f50:	e64a                	sd	s2,264(sp)
ffffffffc0200f52:	ea4e                	sd	s3,272(sp)
ffffffffc0200f54:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f56:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f58:	f11ff0ef          	jal	ffffffffc0200e68 <trap>

ffffffffc0200f5c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f5c:	6492                	ld	s1,256(sp)
ffffffffc0200f5e:	6932                	ld	s2,264(sp)
ffffffffc0200f60:	1004f413          	andi	s0,s1,256
ffffffffc0200f64:	e401                	bnez	s0,ffffffffc0200f6c <__trapret+0x10>
ffffffffc0200f66:	1200                	addi	s0,sp,288
ffffffffc0200f68:	14041073          	csrw	sscratch,s0
ffffffffc0200f6c:	10049073          	csrw	sstatus,s1
ffffffffc0200f70:	14191073          	csrw	sepc,s2
ffffffffc0200f74:	60a2                	ld	ra,8(sp)
ffffffffc0200f76:	61e2                	ld	gp,24(sp)
ffffffffc0200f78:	7202                	ld	tp,32(sp)
ffffffffc0200f7a:	72a2                	ld	t0,40(sp)
ffffffffc0200f7c:	7342                	ld	t1,48(sp)
ffffffffc0200f7e:	73e2                	ld	t2,56(sp)
ffffffffc0200f80:	6406                	ld	s0,64(sp)
ffffffffc0200f82:	64a6                	ld	s1,72(sp)
ffffffffc0200f84:	6546                	ld	a0,80(sp)
ffffffffc0200f86:	65e6                	ld	a1,88(sp)
ffffffffc0200f88:	7606                	ld	a2,96(sp)
ffffffffc0200f8a:	76a6                	ld	a3,104(sp)
ffffffffc0200f8c:	7746                	ld	a4,112(sp)
ffffffffc0200f8e:	77e6                	ld	a5,120(sp)
ffffffffc0200f90:	680a                	ld	a6,128(sp)
ffffffffc0200f92:	68aa                	ld	a7,136(sp)
ffffffffc0200f94:	694a                	ld	s2,144(sp)
ffffffffc0200f96:	69ea                	ld	s3,152(sp)
ffffffffc0200f98:	7a0a                	ld	s4,160(sp)
ffffffffc0200f9a:	7aaa                	ld	s5,168(sp)
ffffffffc0200f9c:	7b4a                	ld	s6,176(sp)
ffffffffc0200f9e:	7bea                	ld	s7,184(sp)
ffffffffc0200fa0:	6c0e                	ld	s8,192(sp)
ffffffffc0200fa2:	6cae                	ld	s9,200(sp)
ffffffffc0200fa4:	6d4e                	ld	s10,208(sp)
ffffffffc0200fa6:	6dee                	ld	s11,216(sp)
ffffffffc0200fa8:	7e0e                	ld	t3,224(sp)
ffffffffc0200faa:	7eae                	ld	t4,232(sp)
ffffffffc0200fac:	7f4e                	ld	t5,240(sp)
ffffffffc0200fae:	7fee                	ld	t6,248(sp)
ffffffffc0200fb0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200fb2:	10200073          	sret

ffffffffc0200fb6 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fb6:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200fb8:	b755                	j	ffffffffc0200f5c <__trapret>

ffffffffc0200fba <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200fba:	ee058593          	addi	a1,a1,-288

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200fbe:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200fc2:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200fc6:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200fca:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200fce:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200fd2:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200fd6:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200fda:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200fde:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200fe0:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200fe2:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200fe4:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200fe6:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200fe8:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200fea:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200fec:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200fee:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200ff0:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200ff2:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200ff4:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200ff6:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200ff8:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200ffa:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200ffc:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200ffe:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201000:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0201002:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201004:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0201006:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201008:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc020100a:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc020100c:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc020100e:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201010:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0201012:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201014:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0201016:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201018:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc020101a:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc020101c:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc020101e:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201020:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0201022:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201024:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0201026:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201028:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc020102a:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc020102c:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc020102e:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201030:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0201032:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201034:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0201036:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201038:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc020103a:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc020103c:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc020103e:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201040:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0201042:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201044:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0201046:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0201048:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc020104a:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc020104c:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc020104e:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201050:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0201052:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201054:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0201056:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0201058:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc020105a:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc020105c:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc020105e:	812e                	mv	sp,a1
ffffffffc0201060:	bdf5                	j	ffffffffc0200f5c <__trapret>

ffffffffc0201062 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201062:	00097797          	auipc	a5,0x97
ffffffffc0201066:	bee78793          	addi	a5,a5,-1042 # ffffffffc0297c50 <free_area>
ffffffffc020106a:	e79c                	sd	a5,8(a5)
ffffffffc020106c:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc020106e:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201072:	8082                	ret

ffffffffc0201074 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201074:	00097517          	auipc	a0,0x97
ffffffffc0201078:	bec56503          	lwu	a0,-1044(a0) # ffffffffc0297c60 <free_area+0x10>
ffffffffc020107c:	8082                	ret

ffffffffc020107e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc020107e:	711d                	addi	sp,sp,-96
ffffffffc0201080:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201082:	00097917          	auipc	s2,0x97
ffffffffc0201086:	bce90913          	addi	s2,s2,-1074 # ffffffffc0297c50 <free_area>
ffffffffc020108a:	00893783          	ld	a5,8(s2)
ffffffffc020108e:	ec86                	sd	ra,88(sp)
ffffffffc0201090:	e8a2                	sd	s0,80(sp)
ffffffffc0201092:	e4a6                	sd	s1,72(sp)
ffffffffc0201094:	fc4e                	sd	s3,56(sp)
ffffffffc0201096:	f852                	sd	s4,48(sp)
ffffffffc0201098:	f456                	sd	s5,40(sp)
ffffffffc020109a:	f05a                	sd	s6,32(sp)
ffffffffc020109c:	ec5e                	sd	s7,24(sp)
ffffffffc020109e:	e862                	sd	s8,16(sp)
ffffffffc02010a0:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02010a2:	2f278363          	beq	a5,s2,ffffffffc0201388 <default_check+0x30a>
    int count = 0, total = 0;
ffffffffc02010a6:	4401                	li	s0,0
ffffffffc02010a8:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02010aa:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02010ae:	8b09                	andi	a4,a4,2
ffffffffc02010b0:	2e070063          	beqz	a4,ffffffffc0201390 <default_check+0x312>
        count++, total += p->property;
ffffffffc02010b4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010b8:	679c                	ld	a5,8(a5)
ffffffffc02010ba:	2485                	addiw	s1,s1,1
ffffffffc02010bc:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02010be:	ff2796e3          	bne	a5,s2,ffffffffc02010aa <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc02010c2:	89a2                	mv	s3,s0
ffffffffc02010c4:	743000ef          	jal	ffffffffc0202006 <nr_free_pages>
ffffffffc02010c8:	73351463          	bne	a0,s3,ffffffffc02017f0 <default_check+0x772>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010cc:	4505                	li	a0,1
ffffffffc02010ce:	6c7000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02010d2:	8a2a                	mv	s4,a0
ffffffffc02010d4:	44050e63          	beqz	a0,ffffffffc0201530 <default_check+0x4b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010d8:	4505                	li	a0,1
ffffffffc02010da:	6bb000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02010de:	89aa                	mv	s3,a0
ffffffffc02010e0:	72050863          	beqz	a0,ffffffffc0201810 <default_check+0x792>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010e4:	4505                	li	a0,1
ffffffffc02010e6:	6af000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02010ea:	8aaa                	mv	s5,a0
ffffffffc02010ec:	4c050263          	beqz	a0,ffffffffc02015b0 <default_check+0x532>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010f0:	40a987b3          	sub	a5,s3,a0
ffffffffc02010f4:	40aa0733          	sub	a4,s4,a0
ffffffffc02010f8:	0017b793          	seqz	a5,a5
ffffffffc02010fc:	00173713          	seqz	a4,a4
ffffffffc0201100:	8fd9                	or	a5,a5,a4
ffffffffc0201102:	30079763          	bnez	a5,ffffffffc0201410 <default_check+0x392>
ffffffffc0201106:	313a0563          	beq	s4,s3,ffffffffc0201410 <default_check+0x392>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020110a:	000a2783          	lw	a5,0(s4)
ffffffffc020110e:	2a079163          	bnez	a5,ffffffffc02013b0 <default_check+0x332>
ffffffffc0201112:	0009a783          	lw	a5,0(s3)
ffffffffc0201116:	28079d63          	bnez	a5,ffffffffc02013b0 <default_check+0x332>
ffffffffc020111a:	411c                	lw	a5,0(a0)
ffffffffc020111c:	28079a63          	bnez	a5,ffffffffc02013b0 <default_check+0x332>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201120:	0009b797          	auipc	a5,0x9b
ffffffffc0201124:	bb07b783          	ld	a5,-1104(a5) # ffffffffc029bcd0 <pages>
ffffffffc0201128:	00007617          	auipc	a2,0x7
ffffffffc020112c:	92863603          	ld	a2,-1752(a2) # ffffffffc0207a50 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201130:	0009b697          	auipc	a3,0x9b
ffffffffc0201134:	b986b683          	ld	a3,-1128(a3) # ffffffffc029bcc8 <npage>
ffffffffc0201138:	40fa0733          	sub	a4,s4,a5
ffffffffc020113c:	8719                	srai	a4,a4,0x6
ffffffffc020113e:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201140:	0732                	slli	a4,a4,0xc
ffffffffc0201142:	06b2                	slli	a3,a3,0xc
ffffffffc0201144:	2ad77663          	bgeu	a4,a3,ffffffffc02013f0 <default_check+0x372>
    return page - pages + nbase;
ffffffffc0201148:	40f98733          	sub	a4,s3,a5
ffffffffc020114c:	8719                	srai	a4,a4,0x6
ffffffffc020114e:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201150:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201152:	4cd77f63          	bgeu	a4,a3,ffffffffc0201630 <default_check+0x5b2>
    return page - pages + nbase;
ffffffffc0201156:	40f507b3          	sub	a5,a0,a5
ffffffffc020115a:	8799                	srai	a5,a5,0x6
ffffffffc020115c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020115e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201160:	32d7f863          	bgeu	a5,a3,ffffffffc0201490 <default_check+0x412>
    assert(alloc_page() == NULL);
ffffffffc0201164:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201166:	00093c03          	ld	s8,0(s2)
ffffffffc020116a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc020116e:	00097b17          	auipc	s6,0x97
ffffffffc0201172:	af2b2b03          	lw	s6,-1294(s6) # ffffffffc0297c60 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0201176:	01293023          	sd	s2,0(s2)
ffffffffc020117a:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc020117e:	00097797          	auipc	a5,0x97
ffffffffc0201182:	ae07a123          	sw	zero,-1310(a5) # ffffffffc0297c60 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201186:	60f000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc020118a:	2e051363          	bnez	a0,ffffffffc0201470 <default_check+0x3f2>
    free_page(p0);
ffffffffc020118e:	8552                	mv	a0,s4
ffffffffc0201190:	4585                	li	a1,1
ffffffffc0201192:	63d000ef          	jal	ffffffffc0201fce <free_pages>
    free_page(p1);
ffffffffc0201196:	854e                	mv	a0,s3
ffffffffc0201198:	4585                	li	a1,1
ffffffffc020119a:	635000ef          	jal	ffffffffc0201fce <free_pages>
    free_page(p2);
ffffffffc020119e:	8556                	mv	a0,s5
ffffffffc02011a0:	4585                	li	a1,1
ffffffffc02011a2:	62d000ef          	jal	ffffffffc0201fce <free_pages>
    assert(nr_free == 3);
ffffffffc02011a6:	00097717          	auipc	a4,0x97
ffffffffc02011aa:	aba72703          	lw	a4,-1350(a4) # ffffffffc0297c60 <free_area+0x10>
ffffffffc02011ae:	478d                	li	a5,3
ffffffffc02011b0:	2af71063          	bne	a4,a5,ffffffffc0201450 <default_check+0x3d2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011b4:	4505                	li	a0,1
ffffffffc02011b6:	5df000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02011ba:	89aa                	mv	s3,a0
ffffffffc02011bc:	26050a63          	beqz	a0,ffffffffc0201430 <default_check+0x3b2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02011c0:	4505                	li	a0,1
ffffffffc02011c2:	5d3000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02011c6:	8aaa                	mv	s5,a0
ffffffffc02011c8:	3c050463          	beqz	a0,ffffffffc0201590 <default_check+0x512>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011cc:	4505                	li	a0,1
ffffffffc02011ce:	5c7000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02011d2:	8a2a                	mv	s4,a0
ffffffffc02011d4:	38050e63          	beqz	a0,ffffffffc0201570 <default_check+0x4f2>
    assert(alloc_page() == NULL);
ffffffffc02011d8:	4505                	li	a0,1
ffffffffc02011da:	5bb000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02011de:	36051963          	bnez	a0,ffffffffc0201550 <default_check+0x4d2>
    free_page(p0);
ffffffffc02011e2:	4585                	li	a1,1
ffffffffc02011e4:	854e                	mv	a0,s3
ffffffffc02011e6:	5e9000ef          	jal	ffffffffc0201fce <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02011ea:	00893783          	ld	a5,8(s2)
ffffffffc02011ee:	1f278163          	beq	a5,s2,ffffffffc02013d0 <default_check+0x352>
    assert((p = alloc_page()) == p0);
ffffffffc02011f2:	4505                	li	a0,1
ffffffffc02011f4:	5a1000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02011f8:	8caa                	mv	s9,a0
ffffffffc02011fa:	30a99b63          	bne	s3,a0,ffffffffc0201510 <default_check+0x492>
    assert(alloc_page() == NULL);
ffffffffc02011fe:	4505                	li	a0,1
ffffffffc0201200:	595000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0201204:	2e051663          	bnez	a0,ffffffffc02014f0 <default_check+0x472>
    assert(nr_free == 0);
ffffffffc0201208:	00097797          	auipc	a5,0x97
ffffffffc020120c:	a587a783          	lw	a5,-1448(a5) # ffffffffc0297c60 <free_area+0x10>
ffffffffc0201210:	2c079063          	bnez	a5,ffffffffc02014d0 <default_check+0x452>
    free_page(p);
ffffffffc0201214:	8566                	mv	a0,s9
ffffffffc0201216:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201218:	01893023          	sd	s8,0(s2)
ffffffffc020121c:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0201220:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0201224:	5ab000ef          	jal	ffffffffc0201fce <free_pages>
    free_page(p1);
ffffffffc0201228:	8556                	mv	a0,s5
ffffffffc020122a:	4585                	li	a1,1
ffffffffc020122c:	5a3000ef          	jal	ffffffffc0201fce <free_pages>
    free_page(p2);
ffffffffc0201230:	8552                	mv	a0,s4
ffffffffc0201232:	4585                	li	a1,1
ffffffffc0201234:	59b000ef          	jal	ffffffffc0201fce <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201238:	4515                	li	a0,5
ffffffffc020123a:	55b000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc020123e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201240:	26050863          	beqz	a0,ffffffffc02014b0 <default_check+0x432>
ffffffffc0201244:	651c                	ld	a5,8(a0)
    assert(!PageProperty(p0));
ffffffffc0201246:	8b89                	andi	a5,a5,2
ffffffffc0201248:	54079463          	bnez	a5,ffffffffc0201790 <default_check+0x712>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020124c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020124e:	00093b83          	ld	s7,0(s2)
ffffffffc0201252:	00893b03          	ld	s6,8(s2)
ffffffffc0201256:	01293023          	sd	s2,0(s2)
ffffffffc020125a:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc020125e:	537000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0201262:	50051763          	bnez	a0,ffffffffc0201770 <default_check+0x6f2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201266:	08098a13          	addi	s4,s3,128
ffffffffc020126a:	8552                	mv	a0,s4
ffffffffc020126c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020126e:	00097c17          	auipc	s8,0x97
ffffffffc0201272:	9f2c2c03          	lw	s8,-1550(s8) # ffffffffc0297c60 <free_area+0x10>
    nr_free = 0;
ffffffffc0201276:	00097797          	auipc	a5,0x97
ffffffffc020127a:	9e07a523          	sw	zero,-1558(a5) # ffffffffc0297c60 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020127e:	551000ef          	jal	ffffffffc0201fce <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201282:	4511                	li	a0,4
ffffffffc0201284:	511000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0201288:	4c051463          	bnez	a0,ffffffffc0201750 <default_check+0x6d2>
ffffffffc020128c:	0889b783          	ld	a5,136(s3)
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201290:	8b89                	andi	a5,a5,2
ffffffffc0201292:	48078f63          	beqz	a5,ffffffffc0201730 <default_check+0x6b2>
ffffffffc0201296:	0909a503          	lw	a0,144(s3)
ffffffffc020129a:	478d                	li	a5,3
ffffffffc020129c:	48f51a63          	bne	a0,a5,ffffffffc0201730 <default_check+0x6b2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02012a0:	4f5000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02012a4:	8aaa                	mv	s5,a0
ffffffffc02012a6:	46050563          	beqz	a0,ffffffffc0201710 <default_check+0x692>
    assert(alloc_page() == NULL);
ffffffffc02012aa:	4505                	li	a0,1
ffffffffc02012ac:	4e9000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02012b0:	44051063          	bnez	a0,ffffffffc02016f0 <default_check+0x672>
    assert(p0 + 2 == p1);
ffffffffc02012b4:	415a1e63          	bne	s4,s5,ffffffffc02016d0 <default_check+0x652>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02012b8:	4585                	li	a1,1
ffffffffc02012ba:	854e                	mv	a0,s3
ffffffffc02012bc:	513000ef          	jal	ffffffffc0201fce <free_pages>
    free_pages(p1, 3);
ffffffffc02012c0:	8552                	mv	a0,s4
ffffffffc02012c2:	458d                	li	a1,3
ffffffffc02012c4:	50b000ef          	jal	ffffffffc0201fce <free_pages>
ffffffffc02012c8:	0089b783          	ld	a5,8(s3)
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02012cc:	8b89                	andi	a5,a5,2
ffffffffc02012ce:	3e078163          	beqz	a5,ffffffffc02016b0 <default_check+0x632>
ffffffffc02012d2:	0109aa83          	lw	s5,16(s3)
ffffffffc02012d6:	4785                	li	a5,1
ffffffffc02012d8:	3cfa9c63          	bne	s5,a5,ffffffffc02016b0 <default_check+0x632>
ffffffffc02012dc:	008a3783          	ld	a5,8(s4)
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02012e0:	8b89                	andi	a5,a5,2
ffffffffc02012e2:	3a078763          	beqz	a5,ffffffffc0201690 <default_check+0x612>
ffffffffc02012e6:	010a2703          	lw	a4,16(s4)
ffffffffc02012ea:	478d                	li	a5,3
ffffffffc02012ec:	3af71263          	bne	a4,a5,ffffffffc0201690 <default_check+0x612>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012f0:	8556                	mv	a0,s5
ffffffffc02012f2:	4a3000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc02012f6:	36a99d63          	bne	s3,a0,ffffffffc0201670 <default_check+0x5f2>
    free_page(p0);
ffffffffc02012fa:	85d6                	mv	a1,s5
ffffffffc02012fc:	4d3000ef          	jal	ffffffffc0201fce <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201300:	4509                	li	a0,2
ffffffffc0201302:	493000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0201306:	34aa1563          	bne	s4,a0,ffffffffc0201650 <default_check+0x5d2>

    free_pages(p0, 2);
ffffffffc020130a:	4589                	li	a1,2
ffffffffc020130c:	4c3000ef          	jal	ffffffffc0201fce <free_pages>
    free_page(p2);
ffffffffc0201310:	04098513          	addi	a0,s3,64
ffffffffc0201314:	85d6                	mv	a1,s5
ffffffffc0201316:	4b9000ef          	jal	ffffffffc0201fce <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020131a:	4515                	li	a0,5
ffffffffc020131c:	479000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0201320:	89aa                	mv	s3,a0
ffffffffc0201322:	48050763          	beqz	a0,ffffffffc02017b0 <default_check+0x732>
    assert(alloc_page() == NULL);
ffffffffc0201326:	8556                	mv	a0,s5
ffffffffc0201328:	46d000ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc020132c:	2e051263          	bnez	a0,ffffffffc0201610 <default_check+0x592>

    assert(nr_free == 0);
ffffffffc0201330:	00097797          	auipc	a5,0x97
ffffffffc0201334:	9307a783          	lw	a5,-1744(a5) # ffffffffc0297c60 <free_area+0x10>
ffffffffc0201338:	2a079c63          	bnez	a5,ffffffffc02015f0 <default_check+0x572>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020133c:	854e                	mv	a0,s3
ffffffffc020133e:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0201340:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0201344:	01793023          	sd	s7,0(s2)
ffffffffc0201348:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc020134c:	483000ef          	jal	ffffffffc0201fce <free_pages>
    return listelm->next;
ffffffffc0201350:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201354:	01278963          	beq	a5,s2,ffffffffc0201366 <default_check+0x2e8>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201358:	ff87a703          	lw	a4,-8(a5)
ffffffffc020135c:	679c                	ld	a5,8(a5)
ffffffffc020135e:	34fd                	addiw	s1,s1,-1
ffffffffc0201360:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201362:	ff279be3          	bne	a5,s2,ffffffffc0201358 <default_check+0x2da>
    }
    assert(count == 0);
ffffffffc0201366:	26049563          	bnez	s1,ffffffffc02015d0 <default_check+0x552>
    assert(total == 0);
ffffffffc020136a:	46041363          	bnez	s0,ffffffffc02017d0 <default_check+0x752>
}
ffffffffc020136e:	60e6                	ld	ra,88(sp)
ffffffffc0201370:	6446                	ld	s0,80(sp)
ffffffffc0201372:	64a6                	ld	s1,72(sp)
ffffffffc0201374:	6906                	ld	s2,64(sp)
ffffffffc0201376:	79e2                	ld	s3,56(sp)
ffffffffc0201378:	7a42                	ld	s4,48(sp)
ffffffffc020137a:	7aa2                	ld	s5,40(sp)
ffffffffc020137c:	7b02                	ld	s6,32(sp)
ffffffffc020137e:	6be2                	ld	s7,24(sp)
ffffffffc0201380:	6c42                	ld	s8,16(sp)
ffffffffc0201382:	6ca2                	ld	s9,8(sp)
ffffffffc0201384:	6125                	addi	sp,sp,96
ffffffffc0201386:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201388:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020138a:	4401                	li	s0,0
ffffffffc020138c:	4481                	li	s1,0
ffffffffc020138e:	bb1d                	j	ffffffffc02010c4 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201390:	00005697          	auipc	a3,0x5
ffffffffc0201394:	f4068693          	addi	a3,a3,-192 # ffffffffc02062d0 <etext+0xa22>
ffffffffc0201398:	00005617          	auipc	a2,0x5
ffffffffc020139c:	f4860613          	addi	a2,a2,-184 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02013a0:	11000593          	li	a1,272
ffffffffc02013a4:	00005517          	auipc	a0,0x5
ffffffffc02013a8:	f5450513          	addi	a0,a0,-172 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02013ac:	89aff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02013b0:	00005697          	auipc	a3,0x5
ffffffffc02013b4:	00868693          	addi	a3,a3,8 # ffffffffc02063b8 <etext+0xb0a>
ffffffffc02013b8:	00005617          	auipc	a2,0x5
ffffffffc02013bc:	f2860613          	addi	a2,a2,-216 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02013c0:	0dc00593          	li	a1,220
ffffffffc02013c4:	00005517          	auipc	a0,0x5
ffffffffc02013c8:	f3450513          	addi	a0,a0,-204 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02013cc:	87aff0ef          	jal	ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02013d0:	00005697          	auipc	a3,0x5
ffffffffc02013d4:	0b068693          	addi	a3,a3,176 # ffffffffc0206480 <etext+0xbd2>
ffffffffc02013d8:	00005617          	auipc	a2,0x5
ffffffffc02013dc:	f0860613          	addi	a2,a2,-248 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02013e0:	0f700593          	li	a1,247
ffffffffc02013e4:	00005517          	auipc	a0,0x5
ffffffffc02013e8:	f1450513          	addi	a0,a0,-236 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02013ec:	85aff0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02013f0:	00005697          	auipc	a3,0x5
ffffffffc02013f4:	00868693          	addi	a3,a3,8 # ffffffffc02063f8 <etext+0xb4a>
ffffffffc02013f8:	00005617          	auipc	a2,0x5
ffffffffc02013fc:	ee860613          	addi	a2,a2,-280 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201400:	0de00593          	li	a1,222
ffffffffc0201404:	00005517          	auipc	a0,0x5
ffffffffc0201408:	ef450513          	addi	a0,a0,-268 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020140c:	83aff0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201410:	00005697          	auipc	a3,0x5
ffffffffc0201414:	f8068693          	addi	a3,a3,-128 # ffffffffc0206390 <etext+0xae2>
ffffffffc0201418:	00005617          	auipc	a2,0x5
ffffffffc020141c:	ec860613          	addi	a2,a2,-312 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201420:	0db00593          	li	a1,219
ffffffffc0201424:	00005517          	auipc	a0,0x5
ffffffffc0201428:	ed450513          	addi	a0,a0,-300 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020142c:	81aff0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201430:	00005697          	auipc	a3,0x5
ffffffffc0201434:	f0068693          	addi	a3,a3,-256 # ffffffffc0206330 <etext+0xa82>
ffffffffc0201438:	00005617          	auipc	a2,0x5
ffffffffc020143c:	ea860613          	addi	a2,a2,-344 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201440:	0f000593          	li	a1,240
ffffffffc0201444:	00005517          	auipc	a0,0x5
ffffffffc0201448:	eb450513          	addi	a0,a0,-332 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020144c:	ffbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc0201450:	00005697          	auipc	a3,0x5
ffffffffc0201454:	02068693          	addi	a3,a3,32 # ffffffffc0206470 <etext+0xbc2>
ffffffffc0201458:	00005617          	auipc	a2,0x5
ffffffffc020145c:	e8860613          	addi	a2,a2,-376 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201460:	0ee00593          	li	a1,238
ffffffffc0201464:	00005517          	auipc	a0,0x5
ffffffffc0201468:	e9450513          	addi	a0,a0,-364 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020146c:	fdbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201470:	00005697          	auipc	a3,0x5
ffffffffc0201474:	fe868693          	addi	a3,a3,-24 # ffffffffc0206458 <etext+0xbaa>
ffffffffc0201478:	00005617          	auipc	a2,0x5
ffffffffc020147c:	e6860613          	addi	a2,a2,-408 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201480:	0e900593          	li	a1,233
ffffffffc0201484:	00005517          	auipc	a0,0x5
ffffffffc0201488:	e7450513          	addi	a0,a0,-396 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020148c:	fbbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201490:	00005697          	auipc	a3,0x5
ffffffffc0201494:	fa868693          	addi	a3,a3,-88 # ffffffffc0206438 <etext+0xb8a>
ffffffffc0201498:	00005617          	auipc	a2,0x5
ffffffffc020149c:	e4860613          	addi	a2,a2,-440 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02014a0:	0e000593          	li	a1,224
ffffffffc02014a4:	00005517          	auipc	a0,0x5
ffffffffc02014a8:	e5450513          	addi	a0,a0,-428 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02014ac:	f9bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc02014b0:	00005697          	auipc	a3,0x5
ffffffffc02014b4:	01868693          	addi	a3,a3,24 # ffffffffc02064c8 <etext+0xc1a>
ffffffffc02014b8:	00005617          	auipc	a2,0x5
ffffffffc02014bc:	e2860613          	addi	a2,a2,-472 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02014c0:	11800593          	li	a1,280
ffffffffc02014c4:	00005517          	auipc	a0,0x5
ffffffffc02014c8:	e3450513          	addi	a0,a0,-460 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02014cc:	f7bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc02014d0:	00005697          	auipc	a3,0x5
ffffffffc02014d4:	fe868693          	addi	a3,a3,-24 # ffffffffc02064b8 <etext+0xc0a>
ffffffffc02014d8:	00005617          	auipc	a2,0x5
ffffffffc02014dc:	e0860613          	addi	a2,a2,-504 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02014e0:	0fd00593          	li	a1,253
ffffffffc02014e4:	00005517          	auipc	a0,0x5
ffffffffc02014e8:	e1450513          	addi	a0,a0,-492 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02014ec:	f5bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014f0:	00005697          	auipc	a3,0x5
ffffffffc02014f4:	f6868693          	addi	a3,a3,-152 # ffffffffc0206458 <etext+0xbaa>
ffffffffc02014f8:	00005617          	auipc	a2,0x5
ffffffffc02014fc:	de860613          	addi	a2,a2,-536 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201500:	0fb00593          	li	a1,251
ffffffffc0201504:	00005517          	auipc	a0,0x5
ffffffffc0201508:	df450513          	addi	a0,a0,-524 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020150c:	f3bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201510:	00005697          	auipc	a3,0x5
ffffffffc0201514:	f8868693          	addi	a3,a3,-120 # ffffffffc0206498 <etext+0xbea>
ffffffffc0201518:	00005617          	auipc	a2,0x5
ffffffffc020151c:	dc860613          	addi	a2,a2,-568 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201520:	0fa00593          	li	a1,250
ffffffffc0201524:	00005517          	auipc	a0,0x5
ffffffffc0201528:	dd450513          	addi	a0,a0,-556 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020152c:	f1bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201530:	00005697          	auipc	a3,0x5
ffffffffc0201534:	e0068693          	addi	a3,a3,-512 # ffffffffc0206330 <etext+0xa82>
ffffffffc0201538:	00005617          	auipc	a2,0x5
ffffffffc020153c:	da860613          	addi	a2,a2,-600 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201540:	0d700593          	li	a1,215
ffffffffc0201544:	00005517          	auipc	a0,0x5
ffffffffc0201548:	db450513          	addi	a0,a0,-588 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020154c:	efbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201550:	00005697          	auipc	a3,0x5
ffffffffc0201554:	f0868693          	addi	a3,a3,-248 # ffffffffc0206458 <etext+0xbaa>
ffffffffc0201558:	00005617          	auipc	a2,0x5
ffffffffc020155c:	d8860613          	addi	a2,a2,-632 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201560:	0f400593          	li	a1,244
ffffffffc0201564:	00005517          	auipc	a0,0x5
ffffffffc0201568:	d9450513          	addi	a0,a0,-620 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020156c:	edbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201570:	00005697          	auipc	a3,0x5
ffffffffc0201574:	e0068693          	addi	a3,a3,-512 # ffffffffc0206370 <etext+0xac2>
ffffffffc0201578:	00005617          	auipc	a2,0x5
ffffffffc020157c:	d6860613          	addi	a2,a2,-664 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201580:	0f200593          	li	a1,242
ffffffffc0201584:	00005517          	auipc	a0,0x5
ffffffffc0201588:	d7450513          	addi	a0,a0,-652 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020158c:	ebbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201590:	00005697          	auipc	a3,0x5
ffffffffc0201594:	dc068693          	addi	a3,a3,-576 # ffffffffc0206350 <etext+0xaa2>
ffffffffc0201598:	00005617          	auipc	a2,0x5
ffffffffc020159c:	d4860613          	addi	a2,a2,-696 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02015a0:	0f100593          	li	a1,241
ffffffffc02015a4:	00005517          	auipc	a0,0x5
ffffffffc02015a8:	d5450513          	addi	a0,a0,-684 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02015ac:	e9bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02015b0:	00005697          	auipc	a3,0x5
ffffffffc02015b4:	dc068693          	addi	a3,a3,-576 # ffffffffc0206370 <etext+0xac2>
ffffffffc02015b8:	00005617          	auipc	a2,0x5
ffffffffc02015bc:	d2860613          	addi	a2,a2,-728 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02015c0:	0d900593          	li	a1,217
ffffffffc02015c4:	00005517          	auipc	a0,0x5
ffffffffc02015c8:	d3450513          	addi	a0,a0,-716 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02015cc:	e7bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc02015d0:	00005697          	auipc	a3,0x5
ffffffffc02015d4:	04868693          	addi	a3,a3,72 # ffffffffc0206618 <etext+0xd6a>
ffffffffc02015d8:	00005617          	auipc	a2,0x5
ffffffffc02015dc:	d0860613          	addi	a2,a2,-760 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02015e0:	14600593          	li	a1,326
ffffffffc02015e4:	00005517          	auipc	a0,0x5
ffffffffc02015e8:	d1450513          	addi	a0,a0,-748 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02015ec:	e5bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc02015f0:	00005697          	auipc	a3,0x5
ffffffffc02015f4:	ec868693          	addi	a3,a3,-312 # ffffffffc02064b8 <etext+0xc0a>
ffffffffc02015f8:	00005617          	auipc	a2,0x5
ffffffffc02015fc:	ce860613          	addi	a2,a2,-792 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201600:	13a00593          	li	a1,314
ffffffffc0201604:	00005517          	auipc	a0,0x5
ffffffffc0201608:	cf450513          	addi	a0,a0,-780 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020160c:	e3bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201610:	00005697          	auipc	a3,0x5
ffffffffc0201614:	e4868693          	addi	a3,a3,-440 # ffffffffc0206458 <etext+0xbaa>
ffffffffc0201618:	00005617          	auipc	a2,0x5
ffffffffc020161c:	cc860613          	addi	a2,a2,-824 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201620:	13800593          	li	a1,312
ffffffffc0201624:	00005517          	auipc	a0,0x5
ffffffffc0201628:	cd450513          	addi	a0,a0,-812 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020162c:	e1bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201630:	00005697          	auipc	a3,0x5
ffffffffc0201634:	de868693          	addi	a3,a3,-536 # ffffffffc0206418 <etext+0xb6a>
ffffffffc0201638:	00005617          	auipc	a2,0x5
ffffffffc020163c:	ca860613          	addi	a2,a2,-856 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201640:	0df00593          	li	a1,223
ffffffffc0201644:	00005517          	auipc	a0,0x5
ffffffffc0201648:	cb450513          	addi	a0,a0,-844 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020164c:	dfbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201650:	00005697          	auipc	a3,0x5
ffffffffc0201654:	f8868693          	addi	a3,a3,-120 # ffffffffc02065d8 <etext+0xd2a>
ffffffffc0201658:	00005617          	auipc	a2,0x5
ffffffffc020165c:	c8860613          	addi	a2,a2,-888 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201660:	13200593          	li	a1,306
ffffffffc0201664:	00005517          	auipc	a0,0x5
ffffffffc0201668:	c9450513          	addi	a0,a0,-876 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020166c:	ddbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201670:	00005697          	auipc	a3,0x5
ffffffffc0201674:	f4868693          	addi	a3,a3,-184 # ffffffffc02065b8 <etext+0xd0a>
ffffffffc0201678:	00005617          	auipc	a2,0x5
ffffffffc020167c:	c6860613          	addi	a2,a2,-920 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201680:	13000593          	li	a1,304
ffffffffc0201684:	00005517          	auipc	a0,0x5
ffffffffc0201688:	c7450513          	addi	a0,a0,-908 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020168c:	dbbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201690:	00005697          	auipc	a3,0x5
ffffffffc0201694:	f0068693          	addi	a3,a3,-256 # ffffffffc0206590 <etext+0xce2>
ffffffffc0201698:	00005617          	auipc	a2,0x5
ffffffffc020169c:	c4860613          	addi	a2,a2,-952 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02016a0:	12e00593          	li	a1,302
ffffffffc02016a4:	00005517          	auipc	a0,0x5
ffffffffc02016a8:	c5450513          	addi	a0,a0,-940 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02016ac:	d9bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02016b0:	00005697          	auipc	a3,0x5
ffffffffc02016b4:	eb868693          	addi	a3,a3,-328 # ffffffffc0206568 <etext+0xcba>
ffffffffc02016b8:	00005617          	auipc	a2,0x5
ffffffffc02016bc:	c2860613          	addi	a2,a2,-984 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02016c0:	12d00593          	li	a1,301
ffffffffc02016c4:	00005517          	auipc	a0,0x5
ffffffffc02016c8:	c3450513          	addi	a0,a0,-972 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02016cc:	d7bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02016d0:	00005697          	auipc	a3,0x5
ffffffffc02016d4:	e8868693          	addi	a3,a3,-376 # ffffffffc0206558 <etext+0xcaa>
ffffffffc02016d8:	00005617          	auipc	a2,0x5
ffffffffc02016dc:	c0860613          	addi	a2,a2,-1016 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02016e0:	12800593          	li	a1,296
ffffffffc02016e4:	00005517          	auipc	a0,0x5
ffffffffc02016e8:	c1450513          	addi	a0,a0,-1004 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02016ec:	d5bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016f0:	00005697          	auipc	a3,0x5
ffffffffc02016f4:	d6868693          	addi	a3,a3,-664 # ffffffffc0206458 <etext+0xbaa>
ffffffffc02016f8:	00005617          	auipc	a2,0x5
ffffffffc02016fc:	be860613          	addi	a2,a2,-1048 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201700:	12700593          	li	a1,295
ffffffffc0201704:	00005517          	auipc	a0,0x5
ffffffffc0201708:	bf450513          	addi	a0,a0,-1036 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020170c:	d3bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201710:	00005697          	auipc	a3,0x5
ffffffffc0201714:	e2868693          	addi	a3,a3,-472 # ffffffffc0206538 <etext+0xc8a>
ffffffffc0201718:	00005617          	auipc	a2,0x5
ffffffffc020171c:	bc860613          	addi	a2,a2,-1080 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201720:	12600593          	li	a1,294
ffffffffc0201724:	00005517          	auipc	a0,0x5
ffffffffc0201728:	bd450513          	addi	a0,a0,-1068 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020172c:	d1bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201730:	00005697          	auipc	a3,0x5
ffffffffc0201734:	dd868693          	addi	a3,a3,-552 # ffffffffc0206508 <etext+0xc5a>
ffffffffc0201738:	00005617          	auipc	a2,0x5
ffffffffc020173c:	ba860613          	addi	a2,a2,-1112 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201740:	12500593          	li	a1,293
ffffffffc0201744:	00005517          	auipc	a0,0x5
ffffffffc0201748:	bb450513          	addi	a0,a0,-1100 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020174c:	cfbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201750:	00005697          	auipc	a3,0x5
ffffffffc0201754:	da068693          	addi	a3,a3,-608 # ffffffffc02064f0 <etext+0xc42>
ffffffffc0201758:	00005617          	auipc	a2,0x5
ffffffffc020175c:	b8860613          	addi	a2,a2,-1144 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201760:	12400593          	li	a1,292
ffffffffc0201764:	00005517          	auipc	a0,0x5
ffffffffc0201768:	b9450513          	addi	a0,a0,-1132 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020176c:	cdbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201770:	00005697          	auipc	a3,0x5
ffffffffc0201774:	ce868693          	addi	a3,a3,-792 # ffffffffc0206458 <etext+0xbaa>
ffffffffc0201778:	00005617          	auipc	a2,0x5
ffffffffc020177c:	b6860613          	addi	a2,a2,-1176 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201780:	11e00593          	li	a1,286
ffffffffc0201784:	00005517          	auipc	a0,0x5
ffffffffc0201788:	b7450513          	addi	a0,a0,-1164 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020178c:	cbbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201790:	00005697          	auipc	a3,0x5
ffffffffc0201794:	d4868693          	addi	a3,a3,-696 # ffffffffc02064d8 <etext+0xc2a>
ffffffffc0201798:	00005617          	auipc	a2,0x5
ffffffffc020179c:	b4860613          	addi	a2,a2,-1208 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02017a0:	11900593          	li	a1,281
ffffffffc02017a4:	00005517          	auipc	a0,0x5
ffffffffc02017a8:	b5450513          	addi	a0,a0,-1196 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02017ac:	c9bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02017b0:	00005697          	auipc	a3,0x5
ffffffffc02017b4:	e4868693          	addi	a3,a3,-440 # ffffffffc02065f8 <etext+0xd4a>
ffffffffc02017b8:	00005617          	auipc	a2,0x5
ffffffffc02017bc:	b2860613          	addi	a2,a2,-1240 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02017c0:	13700593          	li	a1,311
ffffffffc02017c4:	00005517          	auipc	a0,0x5
ffffffffc02017c8:	b3450513          	addi	a0,a0,-1228 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02017cc:	c7bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc02017d0:	00005697          	auipc	a3,0x5
ffffffffc02017d4:	e5868693          	addi	a3,a3,-424 # ffffffffc0206628 <etext+0xd7a>
ffffffffc02017d8:	00005617          	auipc	a2,0x5
ffffffffc02017dc:	b0860613          	addi	a2,a2,-1272 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02017e0:	14700593          	li	a1,327
ffffffffc02017e4:	00005517          	auipc	a0,0x5
ffffffffc02017e8:	b1450513          	addi	a0,a0,-1260 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc02017ec:	c5bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc02017f0:	00005697          	auipc	a3,0x5
ffffffffc02017f4:	b2068693          	addi	a3,a3,-1248 # ffffffffc0206310 <etext+0xa62>
ffffffffc02017f8:	00005617          	auipc	a2,0x5
ffffffffc02017fc:	ae860613          	addi	a2,a2,-1304 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201800:	11300593          	li	a1,275
ffffffffc0201804:	00005517          	auipc	a0,0x5
ffffffffc0201808:	af450513          	addi	a0,a0,-1292 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020180c:	c3bfe0ef          	jal	ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201810:	00005697          	auipc	a3,0x5
ffffffffc0201814:	b4068693          	addi	a3,a3,-1216 # ffffffffc0206350 <etext+0xaa2>
ffffffffc0201818:	00005617          	auipc	a2,0x5
ffffffffc020181c:	ac860613          	addi	a2,a2,-1336 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201820:	0d800593          	li	a1,216
ffffffffc0201824:	00005517          	auipc	a0,0x5
ffffffffc0201828:	ad450513          	addi	a0,a0,-1324 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020182c:	c1bfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201830 <default_free_pages>:
{
ffffffffc0201830:	1141                	addi	sp,sp,-16
ffffffffc0201832:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201834:	14058663          	beqz	a1,ffffffffc0201980 <default_free_pages+0x150>
    for (; p != base + n; p++)
ffffffffc0201838:	00659713          	slli	a4,a1,0x6
ffffffffc020183c:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201840:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc0201842:	c30d                	beqz	a4,ffffffffc0201864 <default_free_pages+0x34>
ffffffffc0201844:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201846:	8b05                	andi	a4,a4,1
ffffffffc0201848:	10071c63          	bnez	a4,ffffffffc0201960 <default_free_pages+0x130>
ffffffffc020184c:	6798                	ld	a4,8(a5)
ffffffffc020184e:	8b09                	andi	a4,a4,2
ffffffffc0201850:	10071863          	bnez	a4,ffffffffc0201960 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc0201854:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201858:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc020185c:	04078793          	addi	a5,a5,64
ffffffffc0201860:	fed792e3          	bne	a5,a3,ffffffffc0201844 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201864:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201866:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020186a:	4789                	li	a5,2
ffffffffc020186c:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201870:	00096717          	auipc	a4,0x96
ffffffffc0201874:	3f072703          	lw	a4,1008(a4) # ffffffffc0297c60 <free_area+0x10>
ffffffffc0201878:	00096697          	auipc	a3,0x96
ffffffffc020187c:	3d868693          	addi	a3,a3,984 # ffffffffc0297c50 <free_area>
    return list->next == list;
ffffffffc0201880:	669c                	ld	a5,8(a3)
ffffffffc0201882:	9f2d                	addw	a4,a4,a1
ffffffffc0201884:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201886:	0ad78163          	beq	a5,a3,ffffffffc0201928 <default_free_pages+0xf8>
            struct Page *page = le2page(le, page_link);
ffffffffc020188a:	fe878713          	addi	a4,a5,-24
ffffffffc020188e:	4581                	li	a1,0
ffffffffc0201890:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201894:	00e56a63          	bltu	a0,a4,ffffffffc02018a8 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201898:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020189a:	04d70c63          	beq	a4,a3,ffffffffc02018f2 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc020189e:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02018a0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02018a4:	fee57ae3          	bgeu	a0,a4,ffffffffc0201898 <default_free_pages+0x68>
ffffffffc02018a8:	c199                	beqz	a1,ffffffffc02018ae <default_free_pages+0x7e>
ffffffffc02018aa:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02018ae:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02018b0:	e390                	sd	a2,0(a5)
ffffffffc02018b2:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02018b4:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02018b6:	f11c                	sd	a5,32(a0)
    if (le != &free_list)
ffffffffc02018b8:	00d70d63          	beq	a4,a3,ffffffffc02018d2 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02018bc:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02018c0:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02018c4:	02059813          	slli	a6,a1,0x20
ffffffffc02018c8:	01a85793          	srli	a5,a6,0x1a
ffffffffc02018cc:	97b2                	add	a5,a5,a2
ffffffffc02018ce:	02f50c63          	beq	a0,a5,ffffffffc0201906 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02018d2:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02018d4:	00d78c63          	beq	a5,a3,ffffffffc02018ec <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc02018d8:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02018da:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02018de:	02061593          	slli	a1,a2,0x20
ffffffffc02018e2:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02018e6:	972a                	add	a4,a4,a0
ffffffffc02018e8:	04e68c63          	beq	a3,a4,ffffffffc0201940 <default_free_pages+0x110>
}
ffffffffc02018ec:	60a2                	ld	ra,8(sp)
ffffffffc02018ee:	0141                	addi	sp,sp,16
ffffffffc02018f0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02018f2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018f4:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02018f6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02018f8:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02018fa:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc02018fc:	02d70f63          	beq	a4,a3,ffffffffc020193a <default_free_pages+0x10a>
ffffffffc0201900:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201902:	87ba                	mv	a5,a4
ffffffffc0201904:	bf71                	j	ffffffffc02018a0 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201906:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201908:	5875                	li	a6,-3
ffffffffc020190a:	9fad                	addw	a5,a5,a1
ffffffffc020190c:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201910:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201914:	01853803          	ld	a6,24(a0)
ffffffffc0201918:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020191a:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020191c:	00b83423          	sd	a1,8(a6) # ff0008 <_binary_obj___user_exit_out_size+0xfe5e50>
    return listelm->next;
ffffffffc0201920:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201922:	0105b023          	sd	a6,0(a1)
ffffffffc0201926:	b77d                	j	ffffffffc02018d4 <default_free_pages+0xa4>
}
ffffffffc0201928:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020192a:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc020192e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201930:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201932:	e398                	sd	a4,0(a5)
ffffffffc0201934:	e798                	sd	a4,8(a5)
}
ffffffffc0201936:	0141                	addi	sp,sp,16
ffffffffc0201938:	8082                	ret
ffffffffc020193a:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc020193c:	873e                	mv	a4,a5
ffffffffc020193e:	bfad                	j	ffffffffc02018b8 <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0201940:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201944:	56f5                	li	a3,-3
ffffffffc0201946:	9f31                	addw	a4,a4,a2
ffffffffc0201948:	c918                	sw	a4,16(a0)
ffffffffc020194a:	ff078713          	addi	a4,a5,-16
ffffffffc020194e:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201952:	6398                	ld	a4,0(a5)
ffffffffc0201954:	679c                	ld	a5,8(a5)
}
ffffffffc0201956:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201958:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020195a:	e398                	sd	a4,0(a5)
ffffffffc020195c:	0141                	addi	sp,sp,16
ffffffffc020195e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201960:	00005697          	auipc	a3,0x5
ffffffffc0201964:	ce068693          	addi	a3,a3,-800 # ffffffffc0206640 <etext+0xd92>
ffffffffc0201968:	00005617          	auipc	a2,0x5
ffffffffc020196c:	97860613          	addi	a2,a2,-1672 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201970:	09400593          	li	a1,148
ffffffffc0201974:	00005517          	auipc	a0,0x5
ffffffffc0201978:	98450513          	addi	a0,a0,-1660 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020197c:	acbfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201980:	00005697          	auipc	a3,0x5
ffffffffc0201984:	cb868693          	addi	a3,a3,-840 # ffffffffc0206638 <etext+0xd8a>
ffffffffc0201988:	00005617          	auipc	a2,0x5
ffffffffc020198c:	95860613          	addi	a2,a2,-1704 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201990:	09000593          	li	a1,144
ffffffffc0201994:	00005517          	auipc	a0,0x5
ffffffffc0201998:	96450513          	addi	a0,a0,-1692 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc020199c:	aabfe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02019a0 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02019a0:	c951                	beqz	a0,ffffffffc0201a34 <default_alloc_pages+0x94>
    if (n > nr_free)
ffffffffc02019a2:	00096597          	auipc	a1,0x96
ffffffffc02019a6:	2be5a583          	lw	a1,702(a1) # ffffffffc0297c60 <free_area+0x10>
ffffffffc02019aa:	86aa                	mv	a3,a0
ffffffffc02019ac:	02059793          	slli	a5,a1,0x20
ffffffffc02019b0:	9381                	srli	a5,a5,0x20
ffffffffc02019b2:	00a7ef63          	bltu	a5,a0,ffffffffc02019d0 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02019b6:	00096617          	auipc	a2,0x96
ffffffffc02019ba:	29a60613          	addi	a2,a2,666 # ffffffffc0297c50 <free_area>
ffffffffc02019be:	87b2                	mv	a5,a2
ffffffffc02019c0:	a029                	j	ffffffffc02019ca <default_alloc_pages+0x2a>
        if (p->property >= n)
ffffffffc02019c2:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02019c6:	00d77763          	bgeu	a4,a3,ffffffffc02019d4 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc02019ca:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02019cc:	fec79be3          	bne	a5,a2,ffffffffc02019c2 <default_alloc_pages+0x22>
        return NULL;
ffffffffc02019d0:	4501                	li	a0,0
}
ffffffffc02019d2:	8082                	ret
        if (page->property > n)
ffffffffc02019d4:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc02019d8:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02019dc:	6798                	ld	a4,8(a5)
ffffffffc02019de:	02089313          	slli	t1,a7,0x20
ffffffffc02019e2:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc02019e6:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc02019ea:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc02019ee:	fe878513          	addi	a0,a5,-24
        if (page->property > n)
ffffffffc02019f2:	0266fa63          	bgeu	a3,t1,ffffffffc0201a26 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc02019f6:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc02019fa:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc02019fe:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201a00:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a04:	00870313          	addi	t1,a4,8
ffffffffc0201a08:	4889                	li	a7,2
ffffffffc0201a0a:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201a0e:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc0201a12:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc0201a16:	0068b023          	sd	t1,0(a7)
ffffffffc0201a1a:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201a1e:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0201a22:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc0201a26:	9d95                	subw	a1,a1,a3
ffffffffc0201a28:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201a2a:	5775                	li	a4,-3
ffffffffc0201a2c:	17c1                	addi	a5,a5,-16
ffffffffc0201a2e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201a32:	8082                	ret
{
ffffffffc0201a34:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201a36:	00005697          	auipc	a3,0x5
ffffffffc0201a3a:	c0268693          	addi	a3,a3,-1022 # ffffffffc0206638 <etext+0xd8a>
ffffffffc0201a3e:	00005617          	auipc	a2,0x5
ffffffffc0201a42:	8a260613          	addi	a2,a2,-1886 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201a46:	06c00593          	li	a1,108
ffffffffc0201a4a:	00005517          	auipc	a0,0x5
ffffffffc0201a4e:	8ae50513          	addi	a0,a0,-1874 # ffffffffc02062f8 <etext+0xa4a>
{
ffffffffc0201a52:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a54:	9f3fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201a58 <default_init_memmap>:
{
ffffffffc0201a58:	1141                	addi	sp,sp,-16
ffffffffc0201a5a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a5c:	c9e1                	beqz	a1,ffffffffc0201b2c <default_init_memmap+0xd4>
    for (; p != base + n; p++)
ffffffffc0201a5e:	00659713          	slli	a4,a1,0x6
ffffffffc0201a62:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201a66:	87aa                	mv	a5,a0
    for (; p != base + n; p++)
ffffffffc0201a68:	cf11                	beqz	a4,ffffffffc0201a84 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201a6a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201a6c:	8b05                	andi	a4,a4,1
ffffffffc0201a6e:	cf59                	beqz	a4,ffffffffc0201b0c <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201a70:	0007a823          	sw	zero,16(a5)
ffffffffc0201a74:	0007b423          	sd	zero,8(a5)
ffffffffc0201a78:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a7c:	04078793          	addi	a5,a5,64
ffffffffc0201a80:	fed795e3          	bne	a5,a3,ffffffffc0201a6a <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a84:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a86:	4789                	li	a5,2
ffffffffc0201a88:	00850713          	addi	a4,a0,8
ffffffffc0201a8c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a90:	00096717          	auipc	a4,0x96
ffffffffc0201a94:	1d072703          	lw	a4,464(a4) # ffffffffc0297c60 <free_area+0x10>
ffffffffc0201a98:	00096697          	auipc	a3,0x96
ffffffffc0201a9c:	1b868693          	addi	a3,a3,440 # ffffffffc0297c50 <free_area>
    return list->next == list;
ffffffffc0201aa0:	669c                	ld	a5,8(a3)
ffffffffc0201aa2:	9f2d                	addw	a4,a4,a1
ffffffffc0201aa4:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list))
ffffffffc0201aa6:	04d78663          	beq	a5,a3,ffffffffc0201af2 <default_init_memmap+0x9a>
            struct Page *page = le2page(le, page_link);
ffffffffc0201aaa:	fe878713          	addi	a4,a5,-24
ffffffffc0201aae:	4581                	li	a1,0
ffffffffc0201ab0:	01850613          	addi	a2,a0,24
            if (base < page)
ffffffffc0201ab4:	00e56a63          	bltu	a0,a4,ffffffffc0201ac8 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201ab8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201aba:	02d70263          	beq	a4,a3,ffffffffc0201ade <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc0201abe:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201ac0:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201ac4:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ab8 <default_init_memmap+0x60>
ffffffffc0201ac8:	c199                	beqz	a1,ffffffffc0201ace <default_init_memmap+0x76>
ffffffffc0201aca:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201ace:	6398                	ld	a4,0(a5)
}
ffffffffc0201ad0:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201ad2:	e390                	sd	a2,0(a5)
ffffffffc0201ad4:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201ad6:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201ad8:	f11c                	sd	a5,32(a0)
ffffffffc0201ada:	0141                	addi	sp,sp,16
ffffffffc0201adc:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201ade:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ae0:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201ae2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201ae4:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201ae6:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list)
ffffffffc0201ae8:	00d70e63          	beq	a4,a3,ffffffffc0201b04 <default_init_memmap+0xac>
ffffffffc0201aec:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc0201aee:	87ba                	mv	a5,a4
ffffffffc0201af0:	bfc1                	j	ffffffffc0201ac0 <default_init_memmap+0x68>
}
ffffffffc0201af2:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201af4:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201af8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201afa:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201afc:	e398                	sd	a4,0(a5)
ffffffffc0201afe:	e798                	sd	a4,8(a5)
}
ffffffffc0201b00:	0141                	addi	sp,sp,16
ffffffffc0201b02:	8082                	ret
ffffffffc0201b04:	60a2                	ld	ra,8(sp)
ffffffffc0201b06:	e290                	sd	a2,0(a3)
ffffffffc0201b08:	0141                	addi	sp,sp,16
ffffffffc0201b0a:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201b0c:	00005697          	auipc	a3,0x5
ffffffffc0201b10:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0206668 <etext+0xdba>
ffffffffc0201b14:	00004617          	auipc	a2,0x4
ffffffffc0201b18:	7cc60613          	addi	a2,a2,1996 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201b1c:	04b00593          	li	a1,75
ffffffffc0201b20:	00004517          	auipc	a0,0x4
ffffffffc0201b24:	7d850513          	addi	a0,a0,2008 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc0201b28:	91ffe0ef          	jal	ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201b2c:	00005697          	auipc	a3,0x5
ffffffffc0201b30:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0206638 <etext+0xd8a>
ffffffffc0201b34:	00004617          	auipc	a2,0x4
ffffffffc0201b38:	7ac60613          	addi	a2,a2,1964 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201b3c:	04700593          	li	a1,71
ffffffffc0201b40:	00004517          	auipc	a0,0x4
ffffffffc0201b44:	7b850513          	addi	a0,a0,1976 # ffffffffc02062f8 <etext+0xa4a>
ffffffffc0201b48:	8fffe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201b4c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201b4c:	c531                	beqz	a0,ffffffffc0201b98 <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201b4e:	e9b9                	bnez	a1,ffffffffc0201ba4 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b50:	100027f3          	csrr	a5,sstatus
ffffffffc0201b54:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b56:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b58:	efb1                	bnez	a5,ffffffffc0201bb4 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b5a:	00096797          	auipc	a5,0x96
ffffffffc0201b5e:	ce67b783          	ld	a5,-794(a5) # ffffffffc0297840 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b62:	873e                	mv	a4,a5
ffffffffc0201b64:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b66:	02a77a63          	bgeu	a4,a0,ffffffffc0201b9a <slob_free+0x4e>
ffffffffc0201b6a:	00f56463          	bltu	a0,a5,ffffffffc0201b72 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b6e:	fef76ae3          	bltu	a4,a5,ffffffffc0201b62 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b72:	4110                	lw	a2,0(a0)
ffffffffc0201b74:	00461693          	slli	a3,a2,0x4
ffffffffc0201b78:	96aa                	add	a3,a3,a0
ffffffffc0201b7a:	0ad78463          	beq	a5,a3,ffffffffc0201c22 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b7e:	4310                	lw	a2,0(a4)
ffffffffc0201b80:	e51c                	sd	a5,8(a0)
ffffffffc0201b82:	00461693          	slli	a3,a2,0x4
ffffffffc0201b86:	96ba                	add	a3,a3,a4
ffffffffc0201b88:	08d50163          	beq	a0,a3,ffffffffc0201c0a <slob_free+0xbe>
ffffffffc0201b8c:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201b8e:	00096797          	auipc	a5,0x96
ffffffffc0201b92:	cae7b923          	sd	a4,-846(a5) # ffffffffc0297840 <slobfree>
    if (flag)
ffffffffc0201b96:	e9a5                	bnez	a1,ffffffffc0201c06 <slob_free+0xba>
ffffffffc0201b98:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b9a:	fcf574e3          	bgeu	a0,a5,ffffffffc0201b62 <slob_free+0x16>
ffffffffc0201b9e:	fcf762e3          	bltu	a4,a5,ffffffffc0201b62 <slob_free+0x16>
ffffffffc0201ba2:	bfc1                	j	ffffffffc0201b72 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201ba4:	25bd                	addiw	a1,a1,15
ffffffffc0201ba6:	8191                	srli	a1,a1,0x4
ffffffffc0201ba8:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201baa:	100027f3          	csrr	a5,sstatus
ffffffffc0201bae:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201bb0:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bb2:	d7c5                	beqz	a5,ffffffffc0201b5a <slob_free+0xe>
{
ffffffffc0201bb4:	1101                	addi	sp,sp,-32
ffffffffc0201bb6:	e42a                	sd	a0,8(sp)
ffffffffc0201bb8:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201bba:	d4bfe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201bbe:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201bc0:	00096797          	auipc	a5,0x96
ffffffffc0201bc4:	c807b783          	ld	a5,-896(a5) # ffffffffc0297840 <slobfree>
ffffffffc0201bc8:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201bca:	873e                	mv	a4,a5
ffffffffc0201bcc:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201bce:	06a77663          	bgeu	a4,a0,ffffffffc0201c3a <slob_free+0xee>
ffffffffc0201bd2:	00f56463          	bltu	a0,a5,ffffffffc0201bda <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201bd6:	fef76ae3          	bltu	a4,a5,ffffffffc0201bca <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc0201bda:	4110                	lw	a2,0(a0)
ffffffffc0201bdc:	00461693          	slli	a3,a2,0x4
ffffffffc0201be0:	96aa                	add	a3,a3,a0
ffffffffc0201be2:	06d78363          	beq	a5,a3,ffffffffc0201c48 <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc0201be6:	4310                	lw	a2,0(a4)
ffffffffc0201be8:	e51c                	sd	a5,8(a0)
ffffffffc0201bea:	00461693          	slli	a3,a2,0x4
ffffffffc0201bee:	96ba                	add	a3,a3,a4
ffffffffc0201bf0:	06d50163          	beq	a0,a3,ffffffffc0201c52 <slob_free+0x106>
ffffffffc0201bf4:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc0201bf6:	00096797          	auipc	a5,0x96
ffffffffc0201bfa:	c4e7b523          	sd	a4,-950(a5) # ffffffffc0297840 <slobfree>
    if (flag)
ffffffffc0201bfe:	e1a9                	bnez	a1,ffffffffc0201c40 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201c00:	60e2                	ld	ra,24(sp)
ffffffffc0201c02:	6105                	addi	sp,sp,32
ffffffffc0201c04:	8082                	ret
        intr_enable();
ffffffffc0201c06:	cf9fe06f          	j	ffffffffc02008fe <intr_enable>
		cur->units += b->units;
ffffffffc0201c0a:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201c0c:	853e                	mv	a0,a5
ffffffffc0201c0e:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201c10:	00c687bb          	addw	a5,a3,a2
ffffffffc0201c14:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201c16:	00096797          	auipc	a5,0x96
ffffffffc0201c1a:	c2e7b523          	sd	a4,-982(a5) # ffffffffc0297840 <slobfree>
    if (flag)
ffffffffc0201c1e:	ddad                	beqz	a1,ffffffffc0201b98 <slob_free+0x4c>
ffffffffc0201c20:	b7dd                	j	ffffffffc0201c06 <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201c22:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201c24:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201c26:	9eb1                	addw	a3,a3,a2
ffffffffc0201c28:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201c2a:	4310                	lw	a2,0(a4)
ffffffffc0201c2c:	e51c                	sd	a5,8(a0)
ffffffffc0201c2e:	00461693          	slli	a3,a2,0x4
ffffffffc0201c32:	96ba                	add	a3,a3,a4
ffffffffc0201c34:	f4d51ce3          	bne	a0,a3,ffffffffc0201b8c <slob_free+0x40>
ffffffffc0201c38:	bfc9                	j	ffffffffc0201c0a <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201c3a:	f8f56ee3          	bltu	a0,a5,ffffffffc0201bd6 <slob_free+0x8a>
ffffffffc0201c3e:	b771                	j	ffffffffc0201bca <slob_free+0x7e>
}
ffffffffc0201c40:	60e2                	ld	ra,24(sp)
ffffffffc0201c42:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201c44:	cbbfe06f          	j	ffffffffc02008fe <intr_enable>
		b->units += cur->next->units;
ffffffffc0201c48:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201c4a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201c4c:	9eb1                	addw	a3,a3,a2
ffffffffc0201c4e:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201c50:	bf59                	j	ffffffffc0201be6 <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201c52:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201c54:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201c56:	00c687bb          	addw	a5,a3,a2
ffffffffc0201c5a:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201c5c:	bf61                	j	ffffffffc0201bf4 <slob_free+0xa8>

ffffffffc0201c5e <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201c5e:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201c60:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201c62:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201c66:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201c68:	32c000ef          	jal	ffffffffc0201f94 <alloc_pages>
	if (!page)
ffffffffc0201c6c:	c91d                	beqz	a0,ffffffffc0201ca2 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201c6e:	0009a697          	auipc	a3,0x9a
ffffffffc0201c72:	0626b683          	ld	a3,98(a3) # ffffffffc029bcd0 <pages>
ffffffffc0201c76:	00006797          	auipc	a5,0x6
ffffffffc0201c7a:	dda7b783          	ld	a5,-550(a5) # ffffffffc0207a50 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201c7e:	0009a717          	auipc	a4,0x9a
ffffffffc0201c82:	04a73703          	ld	a4,74(a4) # ffffffffc029bcc8 <npage>
    return page - pages + nbase;
ffffffffc0201c86:	8d15                	sub	a0,a0,a3
ffffffffc0201c88:	8519                	srai	a0,a0,0x6
ffffffffc0201c8a:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201c8c:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c90:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c92:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201c94:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ca8 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c98:	0009a797          	auipc	a5,0x9a
ffffffffc0201c9c:	0287b783          	ld	a5,40(a5) # ffffffffc029bcc0 <va_pa_offset>
ffffffffc0201ca0:	953e                	add	a0,a0,a5
}
ffffffffc0201ca2:	60a2                	ld	ra,8(sp)
ffffffffc0201ca4:	0141                	addi	sp,sp,16
ffffffffc0201ca6:	8082                	ret
ffffffffc0201ca8:	86aa                	mv	a3,a0
ffffffffc0201caa:	00005617          	auipc	a2,0x5
ffffffffc0201cae:	9e660613          	addi	a2,a2,-1562 # ffffffffc0206690 <etext+0xde2>
ffffffffc0201cb2:	07100593          	li	a1,113
ffffffffc0201cb6:	00005517          	auipc	a0,0x5
ffffffffc0201cba:	a0250513          	addi	a0,a0,-1534 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0201cbe:	f88fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201cc2 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201cc2:	7179                	addi	sp,sp,-48
ffffffffc0201cc4:	f406                	sd	ra,40(sp)
ffffffffc0201cc6:	f022                	sd	s0,32(sp)
ffffffffc0201cc8:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201cca:	01050713          	addi	a4,a0,16
ffffffffc0201cce:	6785                	lui	a5,0x1
ffffffffc0201cd0:	0af77e63          	bgeu	a4,a5,ffffffffc0201d8c <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201cd4:	00f50413          	addi	s0,a0,15
ffffffffc0201cd8:	8011                	srli	s0,s0,0x4
ffffffffc0201cda:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cdc:	100025f3          	csrr	a1,sstatus
ffffffffc0201ce0:	8989                	andi	a1,a1,2
ffffffffc0201ce2:	edd1                	bnez	a1,ffffffffc0201d7e <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201ce4:	00096497          	auipc	s1,0x96
ffffffffc0201ce8:	b5c48493          	addi	s1,s1,-1188 # ffffffffc0297840 <slobfree>
ffffffffc0201cec:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cee:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201cf0:	4314                	lw	a3,0(a4)
ffffffffc0201cf2:	0886da63          	bge	a3,s0,ffffffffc0201d86 <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201cf6:	00e60a63          	beq	a2,a4,ffffffffc0201d0a <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201cfa:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201cfc:	4394                	lw	a3,0(a5)
ffffffffc0201cfe:	0286d863          	bge	a3,s0,ffffffffc0201d2e <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201d02:	6090                	ld	a2,0(s1)
ffffffffc0201d04:	873e                	mv	a4,a5
ffffffffc0201d06:	fee61ae3          	bne	a2,a4,ffffffffc0201cfa <slob_alloc.constprop.0+0x38>
    if (flag)
ffffffffc0201d0a:	e9b1                	bnez	a1,ffffffffc0201d5e <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201d0c:	4501                	li	a0,0
ffffffffc0201d0e:	f51ff0ef          	jal	ffffffffc0201c5e <__slob_get_free_pages.constprop.0>
ffffffffc0201d12:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201d14:	c915                	beqz	a0,ffffffffc0201d48 <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201d16:	6585                	lui	a1,0x1
ffffffffc0201d18:	e35ff0ef          	jal	ffffffffc0201b4c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d1c:	100025f3          	csrr	a1,sstatus
ffffffffc0201d20:	8989                	andi	a1,a1,2
ffffffffc0201d22:	e98d                	bnez	a1,ffffffffc0201d54 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201d24:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201d26:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201d28:	4394                	lw	a3,0(a5)
ffffffffc0201d2a:	fc86cce3          	blt	a3,s0,ffffffffc0201d02 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201d2e:	04d40563          	beq	s0,a3,ffffffffc0201d78 <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201d32:	00441613          	slli	a2,s0,0x4
ffffffffc0201d36:	963e                	add	a2,a2,a5
ffffffffc0201d38:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201d3a:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201d3c:	9e81                	subw	a3,a3,s0
ffffffffc0201d3e:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201d40:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201d42:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201d44:	e098                	sd	a4,0(s1)
    if (flag)
ffffffffc0201d46:	ed99                	bnez	a1,ffffffffc0201d64 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201d48:	70a2                	ld	ra,40(sp)
ffffffffc0201d4a:	7402                	ld	s0,32(sp)
ffffffffc0201d4c:	64e2                	ld	s1,24(sp)
ffffffffc0201d4e:	853e                	mv	a0,a5
ffffffffc0201d50:	6145                	addi	sp,sp,48
ffffffffc0201d52:	8082                	ret
        intr_disable();
ffffffffc0201d54:	bb1fe0ef          	jal	ffffffffc0200904 <intr_disable>
			cur = slobfree;
ffffffffc0201d58:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201d5a:	4585                	li	a1,1
ffffffffc0201d5c:	b7e9                	j	ffffffffc0201d26 <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201d5e:	ba1fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201d62:	b76d                	j	ffffffffc0201d0c <slob_alloc.constprop.0+0x4a>
ffffffffc0201d64:	e43e                	sd	a5,8(sp)
ffffffffc0201d66:	b99fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201d6a:	67a2                	ld	a5,8(sp)
}
ffffffffc0201d6c:	70a2                	ld	ra,40(sp)
ffffffffc0201d6e:	7402                	ld	s0,32(sp)
ffffffffc0201d70:	64e2                	ld	s1,24(sp)
ffffffffc0201d72:	853e                	mv	a0,a5
ffffffffc0201d74:	6145                	addi	sp,sp,48
ffffffffc0201d76:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201d78:	6794                	ld	a3,8(a5)
ffffffffc0201d7a:	e714                	sd	a3,8(a4)
ffffffffc0201d7c:	b7e1                	j	ffffffffc0201d44 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201d7e:	b87fe0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0201d82:	4585                	li	a1,1
ffffffffc0201d84:	b785                	j	ffffffffc0201ce4 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201d86:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201d88:	8732                	mv	a4,a2
ffffffffc0201d8a:	b755                	j	ffffffffc0201d2e <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d8c:	00005697          	auipc	a3,0x5
ffffffffc0201d90:	93c68693          	addi	a3,a3,-1732 # ffffffffc02066c8 <etext+0xe1a>
ffffffffc0201d94:	00004617          	auipc	a2,0x4
ffffffffc0201d98:	54c60613          	addi	a2,a2,1356 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0201d9c:	06300593          	li	a1,99
ffffffffc0201da0:	00005517          	auipc	a0,0x5
ffffffffc0201da4:	94850513          	addi	a0,a0,-1720 # ffffffffc02066e8 <etext+0xe3a>
ffffffffc0201da8:	e9efe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201dac <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201dac:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201dae:	00005517          	auipc	a0,0x5
ffffffffc0201db2:	95250513          	addi	a0,a0,-1710 # ffffffffc0206700 <etext+0xe52>
{
ffffffffc0201db6:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201db8:	bdcfe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201dbc:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201dbe:	00005517          	auipc	a0,0x5
ffffffffc0201dc2:	95a50513          	addi	a0,a0,-1702 # ffffffffc0206718 <etext+0xe6a>
}
ffffffffc0201dc6:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201dc8:	bccfe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201dcc <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201dcc:	4501                	li	a0,0
ffffffffc0201dce:	8082                	ret

ffffffffc0201dd0 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201dd0:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201dd2:	6685                	lui	a3,0x1
{
ffffffffc0201dd4:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201dd6:	16bd                	addi	a3,a3,-17 # fef <_binary_obj___user_softint_out_size-0x7bc1>
ffffffffc0201dd8:	04a6f963          	bgeu	a3,a0,ffffffffc0201e2a <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201ddc:	e42a                	sd	a0,8(sp)
ffffffffc0201dde:	4561                	li	a0,24
ffffffffc0201de0:	e822                	sd	s0,16(sp)
ffffffffc0201de2:	ee1ff0ef          	jal	ffffffffc0201cc2 <slob_alloc.constprop.0>
ffffffffc0201de6:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201de8:	c541                	beqz	a0,ffffffffc0201e70 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201dea:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201dec:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201dee:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201df0:	00f75763          	bge	a4,a5,ffffffffc0201dfe <kmalloc+0x2e>
ffffffffc0201df4:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201df8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201dfa:	fef74de3          	blt	a4,a5,ffffffffc0201df4 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201dfe:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201e00:	e5fff0ef          	jal	ffffffffc0201c5e <__slob_get_free_pages.constprop.0>
ffffffffc0201e04:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201e06:	cd31                	beqz	a0,ffffffffc0201e62 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e08:	100027f3          	csrr	a5,sstatus
ffffffffc0201e0c:	8b89                	andi	a5,a5,2
ffffffffc0201e0e:	eb85                	bnez	a5,ffffffffc0201e3e <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201e10:	0009a797          	auipc	a5,0x9a
ffffffffc0201e14:	e907b783          	ld	a5,-368(a5) # ffffffffc029bca0 <bigblocks>
		bigblocks = bb;
ffffffffc0201e18:	0009a717          	auipc	a4,0x9a
ffffffffc0201e1c:	e8873423          	sd	s0,-376(a4) # ffffffffc029bca0 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201e20:	e81c                	sd	a5,16(s0)
    if (flag)
ffffffffc0201e22:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201e24:	60e2                	ld	ra,24(sp)
ffffffffc0201e26:	6105                	addi	sp,sp,32
ffffffffc0201e28:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201e2a:	0541                	addi	a0,a0,16
ffffffffc0201e2c:	e97ff0ef          	jal	ffffffffc0201cc2 <slob_alloc.constprop.0>
ffffffffc0201e30:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201e32:	0541                	addi	a0,a0,16
ffffffffc0201e34:	fbe5                	bnez	a5,ffffffffc0201e24 <kmalloc+0x54>
		return 0;
ffffffffc0201e36:	4501                	li	a0,0
}
ffffffffc0201e38:	60e2                	ld	ra,24(sp)
ffffffffc0201e3a:	6105                	addi	sp,sp,32
ffffffffc0201e3c:	8082                	ret
        intr_disable();
ffffffffc0201e3e:	ac7fe0ef          	jal	ffffffffc0200904 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201e42:	0009a797          	auipc	a5,0x9a
ffffffffc0201e46:	e5e7b783          	ld	a5,-418(a5) # ffffffffc029bca0 <bigblocks>
		bigblocks = bb;
ffffffffc0201e4a:	0009a717          	auipc	a4,0x9a
ffffffffc0201e4e:	e4873b23          	sd	s0,-426(a4) # ffffffffc029bca0 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201e52:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201e54:	aabfe0ef          	jal	ffffffffc02008fe <intr_enable>
		return bb->pages;
ffffffffc0201e58:	6408                	ld	a0,8(s0)
}
ffffffffc0201e5a:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201e5c:	6442                	ld	s0,16(sp)
}
ffffffffc0201e5e:	6105                	addi	sp,sp,32
ffffffffc0201e60:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e62:	8522                	mv	a0,s0
ffffffffc0201e64:	45e1                	li	a1,24
ffffffffc0201e66:	ce7ff0ef          	jal	ffffffffc0201b4c <slob_free>
		return 0;
ffffffffc0201e6a:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e6c:	6442                	ld	s0,16(sp)
ffffffffc0201e6e:	b7e9                	j	ffffffffc0201e38 <kmalloc+0x68>
ffffffffc0201e70:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201e72:	4501                	li	a0,0
ffffffffc0201e74:	b7d1                	j	ffffffffc0201e38 <kmalloc+0x68>

ffffffffc0201e76 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201e76:	c579                	beqz	a0,ffffffffc0201f44 <kfree+0xce>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201e78:	03451793          	slli	a5,a0,0x34
ffffffffc0201e7c:	e3e1                	bnez	a5,ffffffffc0201f3c <kfree+0xc6>
{
ffffffffc0201e7e:	1101                	addi	sp,sp,-32
ffffffffc0201e80:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e82:	100027f3          	csrr	a5,sstatus
ffffffffc0201e86:	8b89                	andi	a5,a5,2
ffffffffc0201e88:	e7c1                	bnez	a5,ffffffffc0201f10 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e8a:	0009a797          	auipc	a5,0x9a
ffffffffc0201e8e:	e167b783          	ld	a5,-490(a5) # ffffffffc029bca0 <bigblocks>
    return 0;
ffffffffc0201e92:	4581                	li	a1,0
ffffffffc0201e94:	cbad                	beqz	a5,ffffffffc0201f06 <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201e96:	0009a617          	auipc	a2,0x9a
ffffffffc0201e9a:	e0a60613          	addi	a2,a2,-502 # ffffffffc029bca0 <bigblocks>
ffffffffc0201e9e:	a021                	j	ffffffffc0201ea6 <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201ea0:	01070613          	addi	a2,a4,16
ffffffffc0201ea4:	c3a5                	beqz	a5,ffffffffc0201f04 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201ea6:	6794                	ld	a3,8(a5)
ffffffffc0201ea8:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201eaa:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201eac:	fea69ae3          	bne	a3,a0,ffffffffc0201ea0 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201eb0:	e21c                	sd	a5,0(a2)
    if (flag)
ffffffffc0201eb2:	edb5                	bnez	a1,ffffffffc0201f2e <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201eb4:	c02007b7          	lui	a5,0xc0200
ffffffffc0201eb8:	0af56363          	bltu	a0,a5,ffffffffc0201f5e <kfree+0xe8>
ffffffffc0201ebc:	0009a797          	auipc	a5,0x9a
ffffffffc0201ec0:	e047b783          	ld	a5,-508(a5) # ffffffffc029bcc0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201ec4:	0009a697          	auipc	a3,0x9a
ffffffffc0201ec8:	e046b683          	ld	a3,-508(a3) # ffffffffc029bcc8 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201ecc:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201ece:	00c55793          	srli	a5,a0,0xc
ffffffffc0201ed2:	06d7fa63          	bgeu	a5,a3,ffffffffc0201f46 <kfree+0xd0>
    return &pages[PPN(pa) - nbase];
ffffffffc0201ed6:	00006617          	auipc	a2,0x6
ffffffffc0201eda:	b7a63603          	ld	a2,-1158(a2) # ffffffffc0207a50 <nbase>
ffffffffc0201ede:	0009a517          	auipc	a0,0x9a
ffffffffc0201ee2:	df253503          	ld	a0,-526(a0) # ffffffffc029bcd0 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201ee6:	4314                	lw	a3,0(a4)
ffffffffc0201ee8:	8f91                	sub	a5,a5,a2
ffffffffc0201eea:	079a                	slli	a5,a5,0x6
ffffffffc0201eec:	4585                	li	a1,1
ffffffffc0201eee:	953e                	add	a0,a0,a5
ffffffffc0201ef0:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201ef4:	e03a                	sd	a4,0(sp)
ffffffffc0201ef6:	0d8000ef          	jal	ffffffffc0201fce <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201efa:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201efc:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201efe:	45e1                	li	a1,24
}
ffffffffc0201f00:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201f02:	b1a9                	j	ffffffffc0201b4c <slob_free>
ffffffffc0201f04:	e185                	bnez	a1,ffffffffc0201f24 <kfree+0xae>
}
ffffffffc0201f06:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201f08:	1541                	addi	a0,a0,-16
ffffffffc0201f0a:	4581                	li	a1,0
}
ffffffffc0201f0c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201f0e:	b93d                	j	ffffffffc0201b4c <slob_free>
        intr_disable();
ffffffffc0201f10:	e02a                	sd	a0,0(sp)
ffffffffc0201f12:	9f3fe0ef          	jal	ffffffffc0200904 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201f16:	0009a797          	auipc	a5,0x9a
ffffffffc0201f1a:	d8a7b783          	ld	a5,-630(a5) # ffffffffc029bca0 <bigblocks>
ffffffffc0201f1e:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201f20:	4585                	li	a1,1
ffffffffc0201f22:	fbb5                	bnez	a5,ffffffffc0201e96 <kfree+0x20>
ffffffffc0201f24:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201f26:	9d9fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201f2a:	6502                	ld	a0,0(sp)
ffffffffc0201f2c:	bfe9                	j	ffffffffc0201f06 <kfree+0x90>
ffffffffc0201f2e:	e42a                	sd	a0,8(sp)
ffffffffc0201f30:	e03a                	sd	a4,0(sp)
ffffffffc0201f32:	9cdfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0201f36:	6522                	ld	a0,8(sp)
ffffffffc0201f38:	6702                	ld	a4,0(sp)
ffffffffc0201f3a:	bfad                	j	ffffffffc0201eb4 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201f3c:	1541                	addi	a0,a0,-16
ffffffffc0201f3e:	4581                	li	a1,0
ffffffffc0201f40:	c0dff06f          	j	ffffffffc0201b4c <slob_free>
ffffffffc0201f44:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201f46:	00005617          	auipc	a2,0x5
ffffffffc0201f4a:	81a60613          	addi	a2,a2,-2022 # ffffffffc0206760 <etext+0xeb2>
ffffffffc0201f4e:	06900593          	li	a1,105
ffffffffc0201f52:	00004517          	auipc	a0,0x4
ffffffffc0201f56:	76650513          	addi	a0,a0,1894 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0201f5a:	cecfe0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201f5e:	86aa                	mv	a3,a0
ffffffffc0201f60:	00004617          	auipc	a2,0x4
ffffffffc0201f64:	7d860613          	addi	a2,a2,2008 # ffffffffc0206738 <etext+0xe8a>
ffffffffc0201f68:	07700593          	li	a1,119
ffffffffc0201f6c:	00004517          	auipc	a0,0x4
ffffffffc0201f70:	74c50513          	addi	a0,a0,1868 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0201f74:	cd2fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201f78 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201f78:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201f7a:	00004617          	auipc	a2,0x4
ffffffffc0201f7e:	7e660613          	addi	a2,a2,2022 # ffffffffc0206760 <etext+0xeb2>
ffffffffc0201f82:	06900593          	li	a1,105
ffffffffc0201f86:	00004517          	auipc	a0,0x4
ffffffffc0201f8a:	73250513          	addi	a0,a0,1842 # ffffffffc02066b8 <etext+0xe0a>
pa2page(uintptr_t pa)
ffffffffc0201f8e:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201f90:	cb6fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0201f94 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f94:	100027f3          	csrr	a5,sstatus
ffffffffc0201f98:	8b89                	andi	a5,a5,2
ffffffffc0201f9a:	e799                	bnez	a5,ffffffffc0201fa8 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f9c:	0009a797          	auipc	a5,0x9a
ffffffffc0201fa0:	d0c7b783          	ld	a5,-756(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0201fa4:	6f9c                	ld	a5,24(a5)
ffffffffc0201fa6:	8782                	jr	a5
{
ffffffffc0201fa8:	1101                	addi	sp,sp,-32
ffffffffc0201faa:	ec06                	sd	ra,24(sp)
ffffffffc0201fac:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201fae:	957fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fb2:	0009a797          	auipc	a5,0x9a
ffffffffc0201fb6:	cf67b783          	ld	a5,-778(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0201fba:	6522                	ld	a0,8(sp)
ffffffffc0201fbc:	6f9c                	ld	a5,24(a5)
ffffffffc0201fbe:	9782                	jalr	a5
ffffffffc0201fc0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201fc2:	93dfe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201fc6:	60e2                	ld	ra,24(sp)
ffffffffc0201fc8:	6522                	ld	a0,8(sp)
ffffffffc0201fca:	6105                	addi	sp,sp,32
ffffffffc0201fcc:	8082                	ret

ffffffffc0201fce <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fce:	100027f3          	csrr	a5,sstatus
ffffffffc0201fd2:	8b89                	andi	a5,a5,2
ffffffffc0201fd4:	e799                	bnez	a5,ffffffffc0201fe2 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201fd6:	0009a797          	auipc	a5,0x9a
ffffffffc0201fda:	cd27b783          	ld	a5,-814(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0201fde:	739c                	ld	a5,32(a5)
ffffffffc0201fe0:	8782                	jr	a5
{
ffffffffc0201fe2:	1101                	addi	sp,sp,-32
ffffffffc0201fe4:	ec06                	sd	ra,24(sp)
ffffffffc0201fe6:	e42e                	sd	a1,8(sp)
ffffffffc0201fe8:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201fea:	91bfe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201fee:	0009a797          	auipc	a5,0x9a
ffffffffc0201ff2:	cba7b783          	ld	a5,-838(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0201ff6:	65a2                	ld	a1,8(sp)
ffffffffc0201ff8:	6502                	ld	a0,0(sp)
ffffffffc0201ffa:	739c                	ld	a5,32(a5)
ffffffffc0201ffc:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201ffe:	60e2                	ld	ra,24(sp)
ffffffffc0202000:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202002:	8fdfe06f          	j	ffffffffc02008fe <intr_enable>

ffffffffc0202006 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202006:	100027f3          	csrr	a5,sstatus
ffffffffc020200a:	8b89                	andi	a5,a5,2
ffffffffc020200c:	e799                	bnez	a5,ffffffffc020201a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc020200e:	0009a797          	auipc	a5,0x9a
ffffffffc0202012:	c9a7b783          	ld	a5,-870(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0202016:	779c                	ld	a5,40(a5)
ffffffffc0202018:	8782                	jr	a5
{
ffffffffc020201a:	1101                	addi	sp,sp,-32
ffffffffc020201c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020201e:	8e7fe0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202022:	0009a797          	auipc	a5,0x9a
ffffffffc0202026:	c867b783          	ld	a5,-890(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc020202a:	779c                	ld	a5,40(a5)
ffffffffc020202c:	9782                	jalr	a5
ffffffffc020202e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202030:	8cffe0ef          	jal	ffffffffc02008fe <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202034:	60e2                	ld	ra,24(sp)
ffffffffc0202036:	6522                	ld	a0,8(sp)
ffffffffc0202038:	6105                	addi	sp,sp,32
ffffffffc020203a:	8082                	ret

ffffffffc020203c <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020203c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202040:	1ff7f793          	andi	a5,a5,511
ffffffffc0202044:	078e                	slli	a5,a5,0x3
ffffffffc0202046:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc020204a:	6314                	ld	a3,0(a4)
{
ffffffffc020204c:	7139                	addi	sp,sp,-64
ffffffffc020204e:	f822                	sd	s0,48(sp)
ffffffffc0202050:	f426                	sd	s1,40(sp)
ffffffffc0202052:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202054:	0016f793          	andi	a5,a3,1
{
ffffffffc0202058:	842e                	mv	s0,a1
ffffffffc020205a:	8832                	mv	a6,a2
ffffffffc020205c:	0009a497          	auipc	s1,0x9a
ffffffffc0202060:	c6c48493          	addi	s1,s1,-916 # ffffffffc029bcc8 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0202064:	ebd1                	bnez	a5,ffffffffc02020f8 <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202066:	16060d63          	beqz	a2,ffffffffc02021e0 <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020206a:	100027f3          	csrr	a5,sstatus
ffffffffc020206e:	8b89                	andi	a5,a5,2
ffffffffc0202070:	16079e63          	bnez	a5,ffffffffc02021ec <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202074:	0009a797          	auipc	a5,0x9a
ffffffffc0202078:	c347b783          	ld	a5,-972(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc020207c:	4505                	li	a0,1
ffffffffc020207e:	e43a                	sd	a4,8(sp)
ffffffffc0202080:	6f9c                	ld	a5,24(a5)
ffffffffc0202082:	e832                	sd	a2,16(sp)
ffffffffc0202084:	9782                	jalr	a5
ffffffffc0202086:	6722                	ld	a4,8(sp)
ffffffffc0202088:	6842                	ld	a6,16(sp)
ffffffffc020208a:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020208c:	14078a63          	beqz	a5,ffffffffc02021e0 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0202090:	0009a517          	auipc	a0,0x9a
ffffffffc0202094:	c4053503          	ld	a0,-960(a0) # ffffffffc029bcd0 <pages>
ffffffffc0202098:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020209c:	0009a497          	auipc	s1,0x9a
ffffffffc02020a0:	c2c48493          	addi	s1,s1,-980 # ffffffffc029bcc8 <npage>
ffffffffc02020a4:	40a78533          	sub	a0,a5,a0
ffffffffc02020a8:	8519                	srai	a0,a0,0x6
ffffffffc02020aa:	9546                	add	a0,a0,a7
ffffffffc02020ac:	6090                	ld	a2,0(s1)
ffffffffc02020ae:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc02020b2:	4585                	li	a1,1
ffffffffc02020b4:	82b1                	srli	a3,a3,0xc
ffffffffc02020b6:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc02020b8:	0532                	slli	a0,a0,0xc
ffffffffc02020ba:	1ac6f763          	bgeu	a3,a2,ffffffffc0202268 <get_pte+0x22c>
ffffffffc02020be:	0009a697          	auipc	a3,0x9a
ffffffffc02020c2:	c026b683          	ld	a3,-1022(a3) # ffffffffc029bcc0 <va_pa_offset>
ffffffffc02020c6:	6605                	lui	a2,0x1
ffffffffc02020c8:	4581                	li	a1,0
ffffffffc02020ca:	9536                	add	a0,a0,a3
ffffffffc02020cc:	ec42                	sd	a6,24(sp)
ffffffffc02020ce:	e83e                	sd	a5,16(sp)
ffffffffc02020d0:	e43a                	sd	a4,8(sp)
ffffffffc02020d2:	7b2030ef          	jal	ffffffffc0205884 <memset>
    return page - pages + nbase;
ffffffffc02020d6:	0009a697          	auipc	a3,0x9a
ffffffffc02020da:	bfa6b683          	ld	a3,-1030(a3) # ffffffffc029bcd0 <pages>
ffffffffc02020de:	67c2                	ld	a5,16(sp)
ffffffffc02020e0:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020e4:	6722                	ld	a4,8(sp)
ffffffffc02020e6:	40d786b3          	sub	a3,a5,a3
ffffffffc02020ea:	8699                	srai	a3,a3,0x6
ffffffffc02020ec:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020ee:	06aa                	slli	a3,a3,0xa
ffffffffc02020f0:	6862                	ld	a6,24(sp)
ffffffffc02020f2:	0116e693          	ori	a3,a3,17
ffffffffc02020f6:	e314                	sd	a3,0(a4)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02020f8:	c006f693          	andi	a3,a3,-1024
ffffffffc02020fc:	6098                	ld	a4,0(s1)
ffffffffc02020fe:	068a                	slli	a3,a3,0x2
ffffffffc0202100:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202104:	14e7f663          	bgeu	a5,a4,ffffffffc0202250 <get_pte+0x214>
ffffffffc0202108:	0009a897          	auipc	a7,0x9a
ffffffffc020210c:	bb888893          	addi	a7,a7,-1096 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc0202110:	0008b603          	ld	a2,0(a7)
ffffffffc0202114:	01545793          	srli	a5,s0,0x15
ffffffffc0202118:	1ff7f793          	andi	a5,a5,511
ffffffffc020211c:	96b2                	add	a3,a3,a2
ffffffffc020211e:	078e                	slli	a5,a5,0x3
ffffffffc0202120:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202122:	6394                	ld	a3,0(a5)
ffffffffc0202124:	0016f613          	andi	a2,a3,1
ffffffffc0202128:	e659                	bnez	a2,ffffffffc02021b6 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020212a:	0a080b63          	beqz	a6,ffffffffc02021e0 <get_pte+0x1a4>
ffffffffc020212e:	10002773          	csrr	a4,sstatus
ffffffffc0202132:	8b09                	andi	a4,a4,2
ffffffffc0202134:	ef71                	bnez	a4,ffffffffc0202210 <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202136:	0009a717          	auipc	a4,0x9a
ffffffffc020213a:	b7273703          	ld	a4,-1166(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc020213e:	4505                	li	a0,1
ffffffffc0202140:	e43e                	sd	a5,8(sp)
ffffffffc0202142:	6f18                	ld	a4,24(a4)
ffffffffc0202144:	9702                	jalr	a4
ffffffffc0202146:	67a2                	ld	a5,8(sp)
ffffffffc0202148:	872a                	mv	a4,a0
ffffffffc020214a:	0009a897          	auipc	a7,0x9a
ffffffffc020214e:	b7688893          	addi	a7,a7,-1162 # ffffffffc029bcc0 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202152:	c759                	beqz	a4,ffffffffc02021e0 <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0202154:	0009a697          	auipc	a3,0x9a
ffffffffc0202158:	b7c6b683          	ld	a3,-1156(a3) # ffffffffc029bcd0 <pages>
ffffffffc020215c:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202160:	608c                	ld	a1,0(s1)
ffffffffc0202162:	40d706b3          	sub	a3,a4,a3
ffffffffc0202166:	8699                	srai	a3,a3,0x6
ffffffffc0202168:	96c2                	add	a3,a3,a6
ffffffffc020216a:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc020216e:	4505                	li	a0,1
ffffffffc0202170:	8231                	srli	a2,a2,0xc
ffffffffc0202172:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0202174:	06b2                	slli	a3,a3,0xc
ffffffffc0202176:	10b67663          	bgeu	a2,a1,ffffffffc0202282 <get_pte+0x246>
ffffffffc020217a:	0008b503          	ld	a0,0(a7)
ffffffffc020217e:	6605                	lui	a2,0x1
ffffffffc0202180:	4581                	li	a1,0
ffffffffc0202182:	9536                	add	a0,a0,a3
ffffffffc0202184:	e83a                	sd	a4,16(sp)
ffffffffc0202186:	e43e                	sd	a5,8(sp)
ffffffffc0202188:	6fc030ef          	jal	ffffffffc0205884 <memset>
    return page - pages + nbase;
ffffffffc020218c:	0009a697          	auipc	a3,0x9a
ffffffffc0202190:	b446b683          	ld	a3,-1212(a3) # ffffffffc029bcd0 <pages>
ffffffffc0202194:	6742                	ld	a4,16(sp)
ffffffffc0202196:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020219a:	67a2                	ld	a5,8(sp)
ffffffffc020219c:	40d706b3          	sub	a3,a4,a3
ffffffffc02021a0:	8699                	srai	a3,a3,0x6
ffffffffc02021a2:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02021a4:	06aa                	slli	a3,a3,0xa
ffffffffc02021a6:	0116e693          	ori	a3,a3,17
ffffffffc02021aa:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021ac:	6098                	ld	a4,0(s1)
ffffffffc02021ae:	0009a897          	auipc	a7,0x9a
ffffffffc02021b2:	b1288893          	addi	a7,a7,-1262 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc02021b6:	c006f693          	andi	a3,a3,-1024
ffffffffc02021ba:	068a                	slli	a3,a3,0x2
ffffffffc02021bc:	00c6d793          	srli	a5,a3,0xc
ffffffffc02021c0:	06e7fc63          	bgeu	a5,a4,ffffffffc0202238 <get_pte+0x1fc>
ffffffffc02021c4:	0008b783          	ld	a5,0(a7)
ffffffffc02021c8:	8031                	srli	s0,s0,0xc
ffffffffc02021ca:	1ff47413          	andi	s0,s0,511
ffffffffc02021ce:	040e                	slli	s0,s0,0x3
ffffffffc02021d0:	96be                	add	a3,a3,a5
}
ffffffffc02021d2:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021d4:	00868533          	add	a0,a3,s0
}
ffffffffc02021d8:	7442                	ld	s0,48(sp)
ffffffffc02021da:	74a2                	ld	s1,40(sp)
ffffffffc02021dc:	6121                	addi	sp,sp,64
ffffffffc02021de:	8082                	ret
ffffffffc02021e0:	70e2                	ld	ra,56(sp)
ffffffffc02021e2:	7442                	ld	s0,48(sp)
ffffffffc02021e4:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc02021e6:	4501                	li	a0,0
}
ffffffffc02021e8:	6121                	addi	sp,sp,64
ffffffffc02021ea:	8082                	ret
        intr_disable();
ffffffffc02021ec:	e83a                	sd	a4,16(sp)
ffffffffc02021ee:	ec32                	sd	a2,24(sp)
ffffffffc02021f0:	f14fe0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02021f4:	0009a797          	auipc	a5,0x9a
ffffffffc02021f8:	ab47b783          	ld	a5,-1356(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc02021fc:	4505                	li	a0,1
ffffffffc02021fe:	6f9c                	ld	a5,24(a5)
ffffffffc0202200:	9782                	jalr	a5
ffffffffc0202202:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202204:	efafe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202208:	6862                	ld	a6,24(sp)
ffffffffc020220a:	6742                	ld	a4,16(sp)
ffffffffc020220c:	67a2                	ld	a5,8(sp)
ffffffffc020220e:	bdbd                	j	ffffffffc020208c <get_pte+0x50>
        intr_disable();
ffffffffc0202210:	e83e                	sd	a5,16(sp)
ffffffffc0202212:	ef2fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202216:	0009a717          	auipc	a4,0x9a
ffffffffc020221a:	a9273703          	ld	a4,-1390(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc020221e:	4505                	li	a0,1
ffffffffc0202220:	6f18                	ld	a4,24(a4)
ffffffffc0202222:	9702                	jalr	a4
ffffffffc0202224:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202226:	ed8fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020222a:	6722                	ld	a4,8(sp)
ffffffffc020222c:	67c2                	ld	a5,16(sp)
ffffffffc020222e:	0009a897          	auipc	a7,0x9a
ffffffffc0202232:	a9288893          	addi	a7,a7,-1390 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc0202236:	bf31                	j	ffffffffc0202152 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202238:	00004617          	auipc	a2,0x4
ffffffffc020223c:	45860613          	addi	a2,a2,1112 # ffffffffc0206690 <etext+0xde2>
ffffffffc0202240:	0fa00593          	li	a1,250
ffffffffc0202244:	00004517          	auipc	a0,0x4
ffffffffc0202248:	53c50513          	addi	a0,a0,1340 # ffffffffc0206780 <etext+0xed2>
ffffffffc020224c:	9fafe0ef          	jal	ffffffffc0200446 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202250:	00004617          	auipc	a2,0x4
ffffffffc0202254:	44060613          	addi	a2,a2,1088 # ffffffffc0206690 <etext+0xde2>
ffffffffc0202258:	0ed00593          	li	a1,237
ffffffffc020225c:	00004517          	auipc	a0,0x4
ffffffffc0202260:	52450513          	addi	a0,a0,1316 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202264:	9e2fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202268:	86aa                	mv	a3,a0
ffffffffc020226a:	00004617          	auipc	a2,0x4
ffffffffc020226e:	42660613          	addi	a2,a2,1062 # ffffffffc0206690 <etext+0xde2>
ffffffffc0202272:	0e900593          	li	a1,233
ffffffffc0202276:	00004517          	auipc	a0,0x4
ffffffffc020227a:	50a50513          	addi	a0,a0,1290 # ffffffffc0206780 <etext+0xed2>
ffffffffc020227e:	9c8fe0ef          	jal	ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202282:	00004617          	auipc	a2,0x4
ffffffffc0202286:	40e60613          	addi	a2,a2,1038 # ffffffffc0206690 <etext+0xde2>
ffffffffc020228a:	0f700593          	li	a1,247
ffffffffc020228e:	00004517          	auipc	a0,0x4
ffffffffc0202292:	4f250513          	addi	a0,a0,1266 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202296:	9b0fe0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020229a <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020229a:	1141                	addi	sp,sp,-16
ffffffffc020229c:	e022                	sd	s0,0(sp)
ffffffffc020229e:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02022a0:	4601                	li	a2,0
{
ffffffffc02022a2:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02022a4:	d99ff0ef          	jal	ffffffffc020203c <get_pte>
    if (ptep_store != NULL)
ffffffffc02022a8:	c011                	beqz	s0,ffffffffc02022ac <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02022aa:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02022ac:	c511                	beqz	a0,ffffffffc02022b8 <get_page+0x1e>
ffffffffc02022ae:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02022b0:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02022b2:	0017f713          	andi	a4,a5,1
ffffffffc02022b6:	e709                	bnez	a4,ffffffffc02022c0 <get_page+0x26>
}
ffffffffc02022b8:	60a2                	ld	ra,8(sp)
ffffffffc02022ba:	6402                	ld	s0,0(sp)
ffffffffc02022bc:	0141                	addi	sp,sp,16
ffffffffc02022be:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02022c0:	0009a717          	auipc	a4,0x9a
ffffffffc02022c4:	a0873703          	ld	a4,-1528(a4) # ffffffffc029bcc8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02022c8:	078a                	slli	a5,a5,0x2
ffffffffc02022ca:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02022cc:	00e7ff63          	bgeu	a5,a4,ffffffffc02022ea <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc02022d0:	0009a517          	auipc	a0,0x9a
ffffffffc02022d4:	a0053503          	ld	a0,-1536(a0) # ffffffffc029bcd0 <pages>
ffffffffc02022d8:	60a2                	ld	ra,8(sp)
ffffffffc02022da:	6402                	ld	s0,0(sp)
ffffffffc02022dc:	079a                	slli	a5,a5,0x6
ffffffffc02022de:	fe000737          	lui	a4,0xfe000
ffffffffc02022e2:	97ba                	add	a5,a5,a4
ffffffffc02022e4:	953e                	add	a0,a0,a5
ffffffffc02022e6:	0141                	addi	sp,sp,16
ffffffffc02022e8:	8082                	ret
ffffffffc02022ea:	c8fff0ef          	jal	ffffffffc0201f78 <pa2page.part.0>

ffffffffc02022ee <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02022ee:	715d                	addi	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022f0:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02022f4:	e486                	sd	ra,72(sp)
ffffffffc02022f6:	e0a2                	sd	s0,64(sp)
ffffffffc02022f8:	fc26                	sd	s1,56(sp)
ffffffffc02022fa:	f84a                	sd	s2,48(sp)
ffffffffc02022fc:	f44e                	sd	s3,40(sp)
ffffffffc02022fe:	f052                	sd	s4,32(sp)
ffffffffc0202300:	ec56                	sd	s5,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202302:	03479713          	slli	a4,a5,0x34
ffffffffc0202306:	ef61                	bnez	a4,ffffffffc02023de <unmap_range+0xf0>
    assert(USER_ACCESS(start, end));
ffffffffc0202308:	00200a37          	lui	s4,0x200
ffffffffc020230c:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202310:	0145b733          	sltu	a4,a1,s4
ffffffffc0202314:	0017b793          	seqz	a5,a5
ffffffffc0202318:	8fd9                	or	a5,a5,a4
ffffffffc020231a:	842e                	mv	s0,a1
ffffffffc020231c:	84b2                	mv	s1,a2
ffffffffc020231e:	e3e5                	bnez	a5,ffffffffc02023fe <unmap_range+0x110>
ffffffffc0202320:	4785                	li	a5,1
ffffffffc0202322:	07fe                	slli	a5,a5,0x1f
ffffffffc0202324:	0785                	addi	a5,a5,1
ffffffffc0202326:	892a                	mv	s2,a0
ffffffffc0202328:	6985                	lui	s3,0x1
    do
    {
        pte_t *ptep = get_pte(pgdir, start, 0);
        if (ptep == NULL)
        {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020232a:	ffe00ab7          	lui	s5,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc020232e:	0cf67863          	bgeu	a2,a5,ffffffffc02023fe <unmap_range+0x110>
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202332:	4601                	li	a2,0
ffffffffc0202334:	85a2                	mv	a1,s0
ffffffffc0202336:	854a                	mv	a0,s2
ffffffffc0202338:	d05ff0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc020233c:	87aa                	mv	a5,a0
        if (ptep == NULL)
ffffffffc020233e:	cd31                	beqz	a0,ffffffffc020239a <unmap_range+0xac>
            continue;
        }
        if (*ptep != 0)
ffffffffc0202340:	6118                	ld	a4,0(a0)
ffffffffc0202342:	ef11                	bnez	a4,ffffffffc020235e <unmap_range+0x70>
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202344:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202346:	c019                	beqz	s0,ffffffffc020234c <unmap_range+0x5e>
ffffffffc0202348:	fe9465e3          	bltu	s0,s1,ffffffffc0202332 <unmap_range+0x44>
}
ffffffffc020234c:	60a6                	ld	ra,72(sp)
ffffffffc020234e:	6406                	ld	s0,64(sp)
ffffffffc0202350:	74e2                	ld	s1,56(sp)
ffffffffc0202352:	7942                	ld	s2,48(sp)
ffffffffc0202354:	79a2                	ld	s3,40(sp)
ffffffffc0202356:	7a02                	ld	s4,32(sp)
ffffffffc0202358:	6ae2                	ld	s5,24(sp)
ffffffffc020235a:	6161                	addi	sp,sp,80
ffffffffc020235c:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc020235e:	00177693          	andi	a3,a4,1
ffffffffc0202362:	d2ed                	beqz	a3,ffffffffc0202344 <unmap_range+0x56>
    if (PPN(pa) >= npage)
ffffffffc0202364:	0009a697          	auipc	a3,0x9a
ffffffffc0202368:	9646b683          	ld	a3,-1692(a3) # ffffffffc029bcc8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc020236c:	070a                	slli	a4,a4,0x2
ffffffffc020236e:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202370:	0ad77763          	bgeu	a4,a3,ffffffffc020241e <unmap_range+0x130>
    return &pages[PPN(pa) - nbase];
ffffffffc0202374:	0009a517          	auipc	a0,0x9a
ffffffffc0202378:	95c53503          	ld	a0,-1700(a0) # ffffffffc029bcd0 <pages>
ffffffffc020237c:	071a                	slli	a4,a4,0x6
ffffffffc020237e:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202382:	9736                	add	a4,a4,a3
ffffffffc0202384:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202386:	4118                	lw	a4,0(a0)
ffffffffc0202388:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd64307>
ffffffffc020238a:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020238c:	cb19                	beqz	a4,ffffffffc02023a2 <unmap_range+0xb4>
        *ptep = 0;
ffffffffc020238e:	0007b023          	sd	zero,0(a5)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202392:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202396:	944e                	add	s0,s0,s3
ffffffffc0202398:	b77d                	j	ffffffffc0202346 <unmap_range+0x58>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020239a:	9452                	add	s0,s0,s4
ffffffffc020239c:	01547433          	and	s0,s0,s5
            continue;
ffffffffc02023a0:	b75d                	j	ffffffffc0202346 <unmap_range+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02023a2:	10002773          	csrr	a4,sstatus
ffffffffc02023a6:	8b09                	andi	a4,a4,2
ffffffffc02023a8:	eb19                	bnez	a4,ffffffffc02023be <unmap_range+0xd0>
        pmm_manager->free_pages(base, n);
ffffffffc02023aa:	0009a717          	auipc	a4,0x9a
ffffffffc02023ae:	8fe73703          	ld	a4,-1794(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc02023b2:	4585                	li	a1,1
ffffffffc02023b4:	e03e                	sd	a5,0(sp)
ffffffffc02023b6:	7318                	ld	a4,32(a4)
ffffffffc02023b8:	9702                	jalr	a4
    if (flag)
ffffffffc02023ba:	6782                	ld	a5,0(sp)
ffffffffc02023bc:	bfc9                	j	ffffffffc020238e <unmap_range+0xa0>
        intr_disable();
ffffffffc02023be:	e43e                	sd	a5,8(sp)
ffffffffc02023c0:	e02a                	sd	a0,0(sp)
ffffffffc02023c2:	d42fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc02023c6:	0009a717          	auipc	a4,0x9a
ffffffffc02023ca:	8e273703          	ld	a4,-1822(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc02023ce:	6502                	ld	a0,0(sp)
ffffffffc02023d0:	4585                	li	a1,1
ffffffffc02023d2:	7318                	ld	a4,32(a4)
ffffffffc02023d4:	9702                	jalr	a4
        intr_enable();
ffffffffc02023d6:	d28fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02023da:	67a2                	ld	a5,8(sp)
ffffffffc02023dc:	bf4d                	j	ffffffffc020238e <unmap_range+0xa0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023de:	00004697          	auipc	a3,0x4
ffffffffc02023e2:	3b268693          	addi	a3,a3,946 # ffffffffc0206790 <etext+0xee2>
ffffffffc02023e6:	00004617          	auipc	a2,0x4
ffffffffc02023ea:	efa60613          	addi	a2,a2,-262 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02023ee:	12000593          	li	a1,288
ffffffffc02023f2:	00004517          	auipc	a0,0x4
ffffffffc02023f6:	38e50513          	addi	a0,a0,910 # ffffffffc0206780 <etext+0xed2>
ffffffffc02023fa:	84cfe0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02023fe:	00004697          	auipc	a3,0x4
ffffffffc0202402:	3c268693          	addi	a3,a3,962 # ffffffffc02067c0 <etext+0xf12>
ffffffffc0202406:	00004617          	auipc	a2,0x4
ffffffffc020240a:	eda60613          	addi	a2,a2,-294 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020240e:	12100593          	li	a1,289
ffffffffc0202412:	00004517          	auipc	a0,0x4
ffffffffc0202416:	36e50513          	addi	a0,a0,878 # ffffffffc0206780 <etext+0xed2>
ffffffffc020241a:	82cfe0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020241e:	b5bff0ef          	jal	ffffffffc0201f78 <pa2page.part.0>

ffffffffc0202422 <exit_range>:
{
ffffffffc0202422:	7135                	addi	sp,sp,-160
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202424:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202428:	ed06                	sd	ra,152(sp)
ffffffffc020242a:	e922                	sd	s0,144(sp)
ffffffffc020242c:	e526                	sd	s1,136(sp)
ffffffffc020242e:	e14a                	sd	s2,128(sp)
ffffffffc0202430:	fcce                	sd	s3,120(sp)
ffffffffc0202432:	f8d2                	sd	s4,112(sp)
ffffffffc0202434:	f4d6                	sd	s5,104(sp)
ffffffffc0202436:	f0da                	sd	s6,96(sp)
ffffffffc0202438:	ecde                	sd	s7,88(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020243a:	17d2                	slli	a5,a5,0x34
ffffffffc020243c:	22079263          	bnez	a5,ffffffffc0202660 <exit_range+0x23e>
    assert(USER_ACCESS(start, end));
ffffffffc0202440:	00200937          	lui	s2,0x200
ffffffffc0202444:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202448:	0125b733          	sltu	a4,a1,s2
ffffffffc020244c:	0017b793          	seqz	a5,a5
ffffffffc0202450:	8fd9                	or	a5,a5,a4
ffffffffc0202452:	26079263          	bnez	a5,ffffffffc02026b6 <exit_range+0x294>
ffffffffc0202456:	4785                	li	a5,1
ffffffffc0202458:	07fe                	slli	a5,a5,0x1f
ffffffffc020245a:	0785                	addi	a5,a5,1
ffffffffc020245c:	24f67d63          	bgeu	a2,a5,ffffffffc02026b6 <exit_range+0x294>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202460:	c00004b7          	lui	s1,0xc0000
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202464:	ffe007b7          	lui	a5,0xffe00
ffffffffc0202468:	8a2a                	mv	s4,a0
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020246a:	8ced                	and	s1,s1,a1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020246c:	00f5f833          	and	a6,a1,a5
    if (PPN(pa) >= npage)
ffffffffc0202470:	0009aa97          	auipc	s5,0x9a
ffffffffc0202474:	858a8a93          	addi	s5,s5,-1960 # ffffffffc029bcc8 <npage>
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202478:	400009b7          	lui	s3,0x40000
ffffffffc020247c:	a809                	j	ffffffffc020248e <exit_range+0x6c>
        d1start += PDSIZE;
ffffffffc020247e:	013487b3          	add	a5,s1,s3
ffffffffc0202482:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc0202486:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc0202488:	c3f1                	beqz	a5,ffffffffc020254c <exit_range+0x12a>
ffffffffc020248a:	0cc7f163          	bgeu	a5,a2,ffffffffc020254c <exit_range+0x12a>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc020248e:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202492:	1ff47413          	andi	s0,s0,511
ffffffffc0202496:	040e                	slli	s0,s0,0x3
ffffffffc0202498:	9452                	add	s0,s0,s4
ffffffffc020249a:	00043883          	ld	a7,0(s0)
        if (pde1 & PTE_V)
ffffffffc020249e:	0018f793          	andi	a5,a7,1
ffffffffc02024a2:	dff1                	beqz	a5,ffffffffc020247e <exit_range+0x5c>
ffffffffc02024a4:	000ab783          	ld	a5,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024a8:	088a                	slli	a7,a7,0x2
ffffffffc02024aa:	00c8d893          	srli	a7,a7,0xc
    if (PPN(pa) >= npage)
ffffffffc02024ae:	20f8f263          	bgeu	a7,a5,ffffffffc02026b2 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc02024b2:	fff802b7          	lui	t0,0xfff80
ffffffffc02024b6:	00588f33          	add	t5,a7,t0
    return page - pages + nbase;
ffffffffc02024ba:	000803b7          	lui	t2,0x80
ffffffffc02024be:	007f0733          	add	a4,t5,t2
    return page2ppn(page) << PGSHIFT;
ffffffffc02024c2:	00c71e13          	slli	t3,a4,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02024c6:	0f1a                	slli	t5,t5,0x6
    return KADDR(page2pa(page));
ffffffffc02024c8:	1cf77863          	bgeu	a4,a5,ffffffffc0202698 <exit_range+0x276>
ffffffffc02024cc:	00099f97          	auipc	t6,0x99
ffffffffc02024d0:	7f4f8f93          	addi	t6,t6,2036 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc02024d4:	000fb783          	ld	a5,0(t6)
            free_pd0 = 1;
ffffffffc02024d8:	4e85                	li	t4,1
ffffffffc02024da:	6b05                	lui	s6,0x1
ffffffffc02024dc:	9e3e                	add	t3,t3,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024de:	01348333          	add	t1,s1,s3
                pde0 = pd0[PDX0(d0start)];
ffffffffc02024e2:	01585713          	srli	a4,a6,0x15
ffffffffc02024e6:	1ff77713          	andi	a4,a4,511
ffffffffc02024ea:	070e                	slli	a4,a4,0x3
ffffffffc02024ec:	9772                	add	a4,a4,t3
ffffffffc02024ee:	631c                	ld	a5,0(a4)
                if (pde0 & PTE_V)
ffffffffc02024f0:	0017f693          	andi	a3,a5,1
ffffffffc02024f4:	e6bd                	bnez	a3,ffffffffc0202562 <exit_range+0x140>
                    free_pd0 = 0;
ffffffffc02024f6:	4e81                	li	t4,0
                d0start += PTSIZE;
ffffffffc02024f8:	984a                	add	a6,a6,s2
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024fa:	00080863          	beqz	a6,ffffffffc020250a <exit_range+0xe8>
ffffffffc02024fe:	879a                	mv	a5,t1
ffffffffc0202500:	00667363          	bgeu	a2,t1,ffffffffc0202506 <exit_range+0xe4>
ffffffffc0202504:	87b2                	mv	a5,a2
ffffffffc0202506:	fcf86ee3          	bltu	a6,a5,ffffffffc02024e2 <exit_range+0xc0>
            if (free_pd0)
ffffffffc020250a:	f60e8ae3          	beqz	t4,ffffffffc020247e <exit_range+0x5c>
    if (PPN(pa) >= npage)
ffffffffc020250e:	000ab783          	ld	a5,0(s5)
ffffffffc0202512:	1af8f063          	bgeu	a7,a5,ffffffffc02026b2 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc0202516:	00099517          	auipc	a0,0x99
ffffffffc020251a:	7ba53503          	ld	a0,1978(a0) # ffffffffc029bcd0 <pages>
ffffffffc020251e:	957a                	add	a0,a0,t5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202520:	100027f3          	csrr	a5,sstatus
ffffffffc0202524:	8b89                	andi	a5,a5,2
ffffffffc0202526:	10079b63          	bnez	a5,ffffffffc020263c <exit_range+0x21a>
        pmm_manager->free_pages(base, n);
ffffffffc020252a:	00099797          	auipc	a5,0x99
ffffffffc020252e:	77e7b783          	ld	a5,1918(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0202532:	4585                	li	a1,1
ffffffffc0202534:	e432                	sd	a2,8(sp)
ffffffffc0202536:	739c                	ld	a5,32(a5)
ffffffffc0202538:	9782                	jalr	a5
ffffffffc020253a:	6622                	ld	a2,8(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc020253c:	00043023          	sd	zero,0(s0)
        d1start += PDSIZE;
ffffffffc0202540:	013487b3          	add	a5,s1,s3
ffffffffc0202544:	400004b7          	lui	s1,0x40000
        d0start = d1start;
ffffffffc0202548:	8826                	mv	a6,s1
    } while (d1start != 0 && d1start < end);
ffffffffc020254a:	f3a1                	bnez	a5,ffffffffc020248a <exit_range+0x68>
}
ffffffffc020254c:	60ea                	ld	ra,152(sp)
ffffffffc020254e:	644a                	ld	s0,144(sp)
ffffffffc0202550:	64aa                	ld	s1,136(sp)
ffffffffc0202552:	690a                	ld	s2,128(sp)
ffffffffc0202554:	79e6                	ld	s3,120(sp)
ffffffffc0202556:	7a46                	ld	s4,112(sp)
ffffffffc0202558:	7aa6                	ld	s5,104(sp)
ffffffffc020255a:	7b06                	ld	s6,96(sp)
ffffffffc020255c:	6be6                	ld	s7,88(sp)
ffffffffc020255e:	610d                	addi	sp,sp,160
ffffffffc0202560:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc0202562:	000ab503          	ld	a0,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202566:	078a                	slli	a5,a5,0x2
ffffffffc0202568:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020256a:	14a7f463          	bgeu	a5,a0,ffffffffc02026b2 <exit_range+0x290>
    return &pages[PPN(pa) - nbase];
ffffffffc020256e:	9796                	add	a5,a5,t0
    return page - pages + nbase;
ffffffffc0202570:	00778bb3          	add	s7,a5,t2
    return &pages[PPN(pa) - nbase];
ffffffffc0202574:	00679593          	slli	a1,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202578:	00cb9693          	slli	a3,s7,0xc
    return KADDR(page2pa(page));
ffffffffc020257c:	10abf263          	bgeu	s7,a0,ffffffffc0202680 <exit_range+0x25e>
ffffffffc0202580:	000fb783          	ld	a5,0(t6)
ffffffffc0202584:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202586:	01668533          	add	a0,a3,s6
                        if (pt[i] & PTE_V)
ffffffffc020258a:	629c                	ld	a5,0(a3)
ffffffffc020258c:	8b85                	andi	a5,a5,1
ffffffffc020258e:	f7ad                	bnez	a5,ffffffffc02024f8 <exit_range+0xd6>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202590:	06a1                	addi	a3,a3,8
ffffffffc0202592:	fea69ce3          	bne	a3,a0,ffffffffc020258a <exit_range+0x168>
    return &pages[PPN(pa) - nbase];
ffffffffc0202596:	00099517          	auipc	a0,0x99
ffffffffc020259a:	73a53503          	ld	a0,1850(a0) # ffffffffc029bcd0 <pages>
ffffffffc020259e:	952e                	add	a0,a0,a1
ffffffffc02025a0:	100027f3          	csrr	a5,sstatus
ffffffffc02025a4:	8b89                	andi	a5,a5,2
ffffffffc02025a6:	e3b9                	bnez	a5,ffffffffc02025ec <exit_range+0x1ca>
        pmm_manager->free_pages(base, n);
ffffffffc02025a8:	00099797          	auipc	a5,0x99
ffffffffc02025ac:	7007b783          	ld	a5,1792(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc02025b0:	4585                	li	a1,1
ffffffffc02025b2:	e0b2                	sd	a2,64(sp)
ffffffffc02025b4:	739c                	ld	a5,32(a5)
ffffffffc02025b6:	fc1a                	sd	t1,56(sp)
ffffffffc02025b8:	f846                	sd	a7,48(sp)
ffffffffc02025ba:	f47a                	sd	t5,40(sp)
ffffffffc02025bc:	f072                	sd	t3,32(sp)
ffffffffc02025be:	ec76                	sd	t4,24(sp)
ffffffffc02025c0:	e842                	sd	a6,16(sp)
ffffffffc02025c2:	e43a                	sd	a4,8(sp)
ffffffffc02025c4:	9782                	jalr	a5
    if (flag)
ffffffffc02025c6:	6722                	ld	a4,8(sp)
ffffffffc02025c8:	6842                	ld	a6,16(sp)
ffffffffc02025ca:	6ee2                	ld	t4,24(sp)
ffffffffc02025cc:	7e02                	ld	t3,32(sp)
ffffffffc02025ce:	7f22                	ld	t5,40(sp)
ffffffffc02025d0:	78c2                	ld	a7,48(sp)
ffffffffc02025d2:	7362                	ld	t1,56(sp)
ffffffffc02025d4:	6606                	ld	a2,64(sp)
                        pd0[PDX0(d0start)] = 0;
ffffffffc02025d6:	fff802b7          	lui	t0,0xfff80
ffffffffc02025da:	000803b7          	lui	t2,0x80
ffffffffc02025de:	00099f97          	auipc	t6,0x99
ffffffffc02025e2:	6e2f8f93          	addi	t6,t6,1762 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc02025e6:	00073023          	sd	zero,0(a4)
ffffffffc02025ea:	b739                	j	ffffffffc02024f8 <exit_range+0xd6>
        intr_disable();
ffffffffc02025ec:	e4b2                	sd	a2,72(sp)
ffffffffc02025ee:	e09a                	sd	t1,64(sp)
ffffffffc02025f0:	fc46                	sd	a7,56(sp)
ffffffffc02025f2:	f47a                	sd	t5,40(sp)
ffffffffc02025f4:	f072                	sd	t3,32(sp)
ffffffffc02025f6:	ec76                	sd	t4,24(sp)
ffffffffc02025f8:	e842                	sd	a6,16(sp)
ffffffffc02025fa:	e43a                	sd	a4,8(sp)
ffffffffc02025fc:	f82a                	sd	a0,48(sp)
ffffffffc02025fe:	b06fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202602:	00099797          	auipc	a5,0x99
ffffffffc0202606:	6a67b783          	ld	a5,1702(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc020260a:	7542                	ld	a0,48(sp)
ffffffffc020260c:	4585                	li	a1,1
ffffffffc020260e:	739c                	ld	a5,32(a5)
ffffffffc0202610:	9782                	jalr	a5
        intr_enable();
ffffffffc0202612:	aecfe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202616:	6722                	ld	a4,8(sp)
ffffffffc0202618:	6626                	ld	a2,72(sp)
ffffffffc020261a:	6306                	ld	t1,64(sp)
ffffffffc020261c:	78e2                	ld	a7,56(sp)
ffffffffc020261e:	7f22                	ld	t5,40(sp)
ffffffffc0202620:	7e02                	ld	t3,32(sp)
ffffffffc0202622:	6ee2                	ld	t4,24(sp)
ffffffffc0202624:	6842                	ld	a6,16(sp)
ffffffffc0202626:	00099f97          	auipc	t6,0x99
ffffffffc020262a:	69af8f93          	addi	t6,t6,1690 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc020262e:	000803b7          	lui	t2,0x80
ffffffffc0202632:	fff802b7          	lui	t0,0xfff80
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202636:	00073023          	sd	zero,0(a4)
ffffffffc020263a:	bd7d                	j	ffffffffc02024f8 <exit_range+0xd6>
        intr_disable();
ffffffffc020263c:	e832                	sd	a2,16(sp)
ffffffffc020263e:	e42a                	sd	a0,8(sp)
ffffffffc0202640:	ac4fe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202644:	00099797          	auipc	a5,0x99
ffffffffc0202648:	6647b783          	ld	a5,1636(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc020264c:	6522                	ld	a0,8(sp)
ffffffffc020264e:	4585                	li	a1,1
ffffffffc0202650:	739c                	ld	a5,32(a5)
ffffffffc0202652:	9782                	jalr	a5
        intr_enable();
ffffffffc0202654:	aaafe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202658:	6642                	ld	a2,16(sp)
                pgdir[PDX1(d1start)] = 0;
ffffffffc020265a:	00043023          	sd	zero,0(s0)
ffffffffc020265e:	b5cd                	j	ffffffffc0202540 <exit_range+0x11e>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202660:	00004697          	auipc	a3,0x4
ffffffffc0202664:	13068693          	addi	a3,a3,304 # ffffffffc0206790 <etext+0xee2>
ffffffffc0202668:	00004617          	auipc	a2,0x4
ffffffffc020266c:	c7860613          	addi	a2,a2,-904 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0202670:	13500593          	li	a1,309
ffffffffc0202674:	00004517          	auipc	a0,0x4
ffffffffc0202678:	10c50513          	addi	a0,a0,268 # ffffffffc0206780 <etext+0xed2>
ffffffffc020267c:	dcbfd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202680:	00004617          	auipc	a2,0x4
ffffffffc0202684:	01060613          	addi	a2,a2,16 # ffffffffc0206690 <etext+0xde2>
ffffffffc0202688:	07100593          	li	a1,113
ffffffffc020268c:	00004517          	auipc	a0,0x4
ffffffffc0202690:	02c50513          	addi	a0,a0,44 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0202694:	db3fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202698:	86f2                	mv	a3,t3
ffffffffc020269a:	00004617          	auipc	a2,0x4
ffffffffc020269e:	ff660613          	addi	a2,a2,-10 # ffffffffc0206690 <etext+0xde2>
ffffffffc02026a2:	07100593          	li	a1,113
ffffffffc02026a6:	00004517          	auipc	a0,0x4
ffffffffc02026aa:	01250513          	addi	a0,a0,18 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc02026ae:	d99fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc02026b2:	8c7ff0ef          	jal	ffffffffc0201f78 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02026b6:	00004697          	auipc	a3,0x4
ffffffffc02026ba:	10a68693          	addi	a3,a3,266 # ffffffffc02067c0 <etext+0xf12>
ffffffffc02026be:	00004617          	auipc	a2,0x4
ffffffffc02026c2:	c2260613          	addi	a2,a2,-990 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02026c6:	13600593          	li	a1,310
ffffffffc02026ca:	00004517          	auipc	a0,0x4
ffffffffc02026ce:	0b650513          	addi	a0,a0,182 # ffffffffc0206780 <etext+0xed2>
ffffffffc02026d2:	d75fd0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02026d6 <page_remove>:
{
ffffffffc02026d6:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02026d8:	4601                	li	a2,0
{
ffffffffc02026da:	e822                	sd	s0,16(sp)
ffffffffc02026dc:	ec06                	sd	ra,24(sp)
ffffffffc02026de:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02026e0:	95dff0ef          	jal	ffffffffc020203c <get_pte>
    if (ptep != NULL)
ffffffffc02026e4:	c511                	beqz	a0,ffffffffc02026f0 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc02026e6:	6118                	ld	a4,0(a0)
ffffffffc02026e8:	87aa                	mv	a5,a0
ffffffffc02026ea:	00177693          	andi	a3,a4,1
ffffffffc02026ee:	e689                	bnez	a3,ffffffffc02026f8 <page_remove+0x22>
}
ffffffffc02026f0:	60e2                	ld	ra,24(sp)
ffffffffc02026f2:	6442                	ld	s0,16(sp)
ffffffffc02026f4:	6105                	addi	sp,sp,32
ffffffffc02026f6:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02026f8:	00099697          	auipc	a3,0x99
ffffffffc02026fc:	5d06b683          	ld	a3,1488(a3) # ffffffffc029bcc8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202700:	070a                	slli	a4,a4,0x2
ffffffffc0202702:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202704:	06d77563          	bgeu	a4,a3,ffffffffc020276e <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202708:	00099517          	auipc	a0,0x99
ffffffffc020270c:	5c853503          	ld	a0,1480(a0) # ffffffffc029bcd0 <pages>
ffffffffc0202710:	071a                	slli	a4,a4,0x6
ffffffffc0202712:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202716:	9736                	add	a4,a4,a3
ffffffffc0202718:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc020271a:	4118                	lw	a4,0(a0)
ffffffffc020271c:	377d                	addiw	a4,a4,-1
ffffffffc020271e:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202720:	cb09                	beqz	a4,ffffffffc0202732 <page_remove+0x5c>
        *ptep = 0;
ffffffffc0202722:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202726:	12040073          	sfence.vma	s0
}
ffffffffc020272a:	60e2                	ld	ra,24(sp)
ffffffffc020272c:	6442                	ld	s0,16(sp)
ffffffffc020272e:	6105                	addi	sp,sp,32
ffffffffc0202730:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202732:	10002773          	csrr	a4,sstatus
ffffffffc0202736:	8b09                	andi	a4,a4,2
ffffffffc0202738:	eb19                	bnez	a4,ffffffffc020274e <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc020273a:	00099717          	auipc	a4,0x99
ffffffffc020273e:	56e73703          	ld	a4,1390(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc0202742:	4585                	li	a1,1
ffffffffc0202744:	e03e                	sd	a5,0(sp)
ffffffffc0202746:	7318                	ld	a4,32(a4)
ffffffffc0202748:	9702                	jalr	a4
    if (flag)
ffffffffc020274a:	6782                	ld	a5,0(sp)
ffffffffc020274c:	bfd9                	j	ffffffffc0202722 <page_remove+0x4c>
        intr_disable();
ffffffffc020274e:	e43e                	sd	a5,8(sp)
ffffffffc0202750:	e02a                	sd	a0,0(sp)
ffffffffc0202752:	9b2fe0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202756:	00099717          	auipc	a4,0x99
ffffffffc020275a:	55273703          	ld	a4,1362(a4) # ffffffffc029bca8 <pmm_manager>
ffffffffc020275e:	6502                	ld	a0,0(sp)
ffffffffc0202760:	4585                	li	a1,1
ffffffffc0202762:	7318                	ld	a4,32(a4)
ffffffffc0202764:	9702                	jalr	a4
        intr_enable();
ffffffffc0202766:	998fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020276a:	67a2                	ld	a5,8(sp)
ffffffffc020276c:	bf5d                	j	ffffffffc0202722 <page_remove+0x4c>
ffffffffc020276e:	80bff0ef          	jal	ffffffffc0201f78 <pa2page.part.0>

ffffffffc0202772 <page_insert>:
{
ffffffffc0202772:	7139                	addi	sp,sp,-64
ffffffffc0202774:	f426                	sd	s1,40(sp)
ffffffffc0202776:	84b2                	mv	s1,a2
ffffffffc0202778:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020277a:	4605                	li	a2,1
{
ffffffffc020277c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020277e:	85a6                	mv	a1,s1
{
ffffffffc0202780:	fc06                	sd	ra,56(sp)
ffffffffc0202782:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202784:	8b9ff0ef          	jal	ffffffffc020203c <get_pte>
    if (ptep == NULL)
ffffffffc0202788:	cd61                	beqz	a0,ffffffffc0202860 <page_insert+0xee>
    page->ref += 1;
ffffffffc020278a:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc020278c:	611c                	ld	a5,0(a0)
ffffffffc020278e:	66a2                	ld	a3,8(sp)
ffffffffc0202790:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_obj___user_softint_out_size-0x7baf>
ffffffffc0202794:	c010                	sw	a2,0(s0)
ffffffffc0202796:	0017f613          	andi	a2,a5,1
ffffffffc020279a:	872a                	mv	a4,a0
ffffffffc020279c:	e61d                	bnez	a2,ffffffffc02027ca <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc020279e:	00099617          	auipc	a2,0x99
ffffffffc02027a2:	53263603          	ld	a2,1330(a2) # ffffffffc029bcd0 <pages>
    return page - pages + nbase;
ffffffffc02027a6:	8c11                	sub	s0,s0,a2
ffffffffc02027a8:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02027aa:	200007b7          	lui	a5,0x20000
ffffffffc02027ae:	042a                	slli	s0,s0,0xa
ffffffffc02027b0:	943e                	add	s0,s0,a5
ffffffffc02027b2:	8ec1                	or	a3,a3,s0
ffffffffc02027b4:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02027b8:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027ba:	12048073          	sfence.vma	s1
    return 0;
ffffffffc02027be:	4501                	li	a0,0
}
ffffffffc02027c0:	70e2                	ld	ra,56(sp)
ffffffffc02027c2:	7442                	ld	s0,48(sp)
ffffffffc02027c4:	74a2                	ld	s1,40(sp)
ffffffffc02027c6:	6121                	addi	sp,sp,64
ffffffffc02027c8:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02027ca:	00099617          	auipc	a2,0x99
ffffffffc02027ce:	4fe63603          	ld	a2,1278(a2) # ffffffffc029bcc8 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02027d2:	078a                	slli	a5,a5,0x2
ffffffffc02027d4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027d6:	08c7f763          	bgeu	a5,a2,ffffffffc0202864 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02027da:	00099617          	auipc	a2,0x99
ffffffffc02027de:	4f663603          	ld	a2,1270(a2) # ffffffffc029bcd0 <pages>
ffffffffc02027e2:	fe000537          	lui	a0,0xfe000
ffffffffc02027e6:	079a                	slli	a5,a5,0x6
ffffffffc02027e8:	97aa                	add	a5,a5,a0
ffffffffc02027ea:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc02027ee:	00a40963          	beq	s0,a0,ffffffffc0202800 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc02027f2:	411c                	lw	a5,0(a0)
ffffffffc02027f4:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_obj___user_exit_out_size+0x1fff5e47>
ffffffffc02027f6:	c11c                	sw	a5,0(a0)
        if (page_ref(page) == 0)
ffffffffc02027f8:	c791                	beqz	a5,ffffffffc0202804 <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027fa:	12048073          	sfence.vma	s1
}
ffffffffc02027fe:	b765                	j	ffffffffc02027a6 <page_insert+0x34>
ffffffffc0202800:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202802:	b755                	j	ffffffffc02027a6 <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202804:	100027f3          	csrr	a5,sstatus
ffffffffc0202808:	8b89                	andi	a5,a5,2
ffffffffc020280a:	e39d                	bnez	a5,ffffffffc0202830 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc020280c:	00099797          	auipc	a5,0x99
ffffffffc0202810:	49c7b783          	ld	a5,1180(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0202814:	4585                	li	a1,1
ffffffffc0202816:	e83a                	sd	a4,16(sp)
ffffffffc0202818:	739c                	ld	a5,32(a5)
ffffffffc020281a:	e436                	sd	a3,8(sp)
ffffffffc020281c:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020281e:	00099617          	auipc	a2,0x99
ffffffffc0202822:	4b263603          	ld	a2,1202(a2) # ffffffffc029bcd0 <pages>
ffffffffc0202826:	66a2                	ld	a3,8(sp)
ffffffffc0202828:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020282a:	12048073          	sfence.vma	s1
ffffffffc020282e:	bfa5                	j	ffffffffc02027a6 <page_insert+0x34>
        intr_disable();
ffffffffc0202830:	ec3a                	sd	a4,24(sp)
ffffffffc0202832:	e836                	sd	a3,16(sp)
ffffffffc0202834:	e42a                	sd	a0,8(sp)
ffffffffc0202836:	8cefe0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020283a:	00099797          	auipc	a5,0x99
ffffffffc020283e:	46e7b783          	ld	a5,1134(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0202842:	6522                	ld	a0,8(sp)
ffffffffc0202844:	4585                	li	a1,1
ffffffffc0202846:	739c                	ld	a5,32(a5)
ffffffffc0202848:	9782                	jalr	a5
        intr_enable();
ffffffffc020284a:	8b4fe0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc020284e:	00099617          	auipc	a2,0x99
ffffffffc0202852:	48263603          	ld	a2,1154(a2) # ffffffffc029bcd0 <pages>
ffffffffc0202856:	6762                	ld	a4,24(sp)
ffffffffc0202858:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020285a:	12048073          	sfence.vma	s1
ffffffffc020285e:	b7a1                	j	ffffffffc02027a6 <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc0202860:	5571                	li	a0,-4
ffffffffc0202862:	bfb9                	j	ffffffffc02027c0 <page_insert+0x4e>
ffffffffc0202864:	f14ff0ef          	jal	ffffffffc0201f78 <pa2page.part.0>

ffffffffc0202868 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202868:	00005797          	auipc	a5,0x5
ffffffffc020286c:	e9078793          	addi	a5,a5,-368 # ffffffffc02076f8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202870:	638c                	ld	a1,0(a5)
{
ffffffffc0202872:	7159                	addi	sp,sp,-112
ffffffffc0202874:	f486                	sd	ra,104(sp)
ffffffffc0202876:	e8ca                	sd	s2,80(sp)
ffffffffc0202878:	e4ce                	sd	s3,72(sp)
ffffffffc020287a:	f85a                	sd	s6,48(sp)
ffffffffc020287c:	f0a2                	sd	s0,96(sp)
ffffffffc020287e:	eca6                	sd	s1,88(sp)
ffffffffc0202880:	e0d2                	sd	s4,64(sp)
ffffffffc0202882:	fc56                	sd	s5,56(sp)
ffffffffc0202884:	f45e                	sd	s7,40(sp)
ffffffffc0202886:	f062                	sd	s8,32(sp)
ffffffffc0202888:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020288a:	00099b17          	auipc	s6,0x99
ffffffffc020288e:	41eb0b13          	addi	s6,s6,1054 # ffffffffc029bca8 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202892:	00004517          	auipc	a0,0x4
ffffffffc0202896:	f4650513          	addi	a0,a0,-186 # ffffffffc02067d8 <etext+0xf2a>
    pmm_manager = &default_pmm_manager;
ffffffffc020289a:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020289e:	8f7fd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02028a2:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02028a6:	00099997          	auipc	s3,0x99
ffffffffc02028aa:	41a98993          	addi	s3,s3,1050 # ffffffffc029bcc0 <va_pa_offset>
    pmm_manager->init();
ffffffffc02028ae:	679c                	ld	a5,8(a5)
ffffffffc02028b0:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02028b2:	57f5                	li	a5,-3
ffffffffc02028b4:	07fa                	slli	a5,a5,0x1e
ffffffffc02028b6:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02028ba:	830fe0ef          	jal	ffffffffc02008ea <get_memory_base>
ffffffffc02028be:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02028c0:	834fe0ef          	jal	ffffffffc02008f4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02028c4:	70050e63          	beqz	a0,ffffffffc0202fe0 <pmm_init+0x778>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02028c8:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02028ca:	00004517          	auipc	a0,0x4
ffffffffc02028ce:	f4650513          	addi	a0,a0,-186 # ffffffffc0206810 <etext+0xf62>
ffffffffc02028d2:	8c3fd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02028d6:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02028da:	864a                	mv	a2,s2
ffffffffc02028dc:	85a6                	mv	a1,s1
ffffffffc02028de:	fff40693          	addi	a3,s0,-1
ffffffffc02028e2:	00004517          	auipc	a0,0x4
ffffffffc02028e6:	f4650513          	addi	a0,a0,-186 # ffffffffc0206828 <etext+0xf7a>
ffffffffc02028ea:	8abfd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc02028ee:	c80007b7          	lui	a5,0xc8000
ffffffffc02028f2:	8522                	mv	a0,s0
ffffffffc02028f4:	5287ed63          	bltu	a5,s0,ffffffffc0202e2e <pmm_init+0x5c6>
ffffffffc02028f8:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02028fa:	0009a617          	auipc	a2,0x9a
ffffffffc02028fe:	3fd60613          	addi	a2,a2,1021 # ffffffffc029ccf7 <end+0xfff>
ffffffffc0202902:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc0202904:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202906:	00099b97          	auipc	s7,0x99
ffffffffc020290a:	3cab8b93          	addi	s7,s7,970 # ffffffffc029bcd0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020290e:	00099497          	auipc	s1,0x99
ffffffffc0202912:	3ba48493          	addi	s1,s1,954 # ffffffffc029bcc8 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202916:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc020291a:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020291c:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202920:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202922:	02f50763          	beq	a0,a5,ffffffffc0202950 <pmm_init+0xe8>
ffffffffc0202926:	4701                	li	a4,0
ffffffffc0202928:	4585                	li	a1,1
ffffffffc020292a:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020292e:	00671793          	slli	a5,a4,0x6
ffffffffc0202932:	97b2                	add	a5,a5,a2
ffffffffc0202934:	07a1                	addi	a5,a5,8 # 80008 <_binary_obj___user_exit_out_size+0x75e50>
ffffffffc0202936:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020293a:	6088                	ld	a0,0(s1)
ffffffffc020293c:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020293e:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202942:	00d507b3          	add	a5,a0,a3
ffffffffc0202946:	fef764e3          	bltu	a4,a5,ffffffffc020292e <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020294a:	079a                	slli	a5,a5,0x6
ffffffffc020294c:	00f606b3          	add	a3,a2,a5
ffffffffc0202950:	c02007b7          	lui	a5,0xc0200
ffffffffc0202954:	16f6eee3          	bltu	a3,a5,ffffffffc02032d0 <pmm_init+0xa68>
ffffffffc0202958:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020295c:	77fd                	lui	a5,0xfffff
ffffffffc020295e:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202960:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202962:	4e86ed63          	bltu	a3,s0,ffffffffc0202e5c <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202966:	00004517          	auipc	a0,0x4
ffffffffc020296a:	eea50513          	addi	a0,a0,-278 # ffffffffc0206850 <etext+0xfa2>
ffffffffc020296e:	827fd0ef          	jal	ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202972:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202976:	00099917          	auipc	s2,0x99
ffffffffc020297a:	34290913          	addi	s2,s2,834 # ffffffffc029bcb8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc020297e:	7b9c                	ld	a5,48(a5)
ffffffffc0202980:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202982:	00004517          	auipc	a0,0x4
ffffffffc0202986:	ee650513          	addi	a0,a0,-282 # ffffffffc0206868 <etext+0xfba>
ffffffffc020298a:	80bfd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020298e:	00007697          	auipc	a3,0x7
ffffffffc0202992:	67268693          	addi	a3,a3,1650 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202996:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020299a:	c02007b7          	lui	a5,0xc0200
ffffffffc020299e:	2af6eee3          	bltu	a3,a5,ffffffffc020345a <pmm_init+0xbf2>
ffffffffc02029a2:	0009b783          	ld	a5,0(s3)
ffffffffc02029a6:	8e9d                	sub	a3,a3,a5
ffffffffc02029a8:	00099797          	auipc	a5,0x99
ffffffffc02029ac:	30d7b423          	sd	a3,776(a5) # ffffffffc029bcb0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02029b0:	100027f3          	csrr	a5,sstatus
ffffffffc02029b4:	8b89                	andi	a5,a5,2
ffffffffc02029b6:	48079963          	bnez	a5,ffffffffc0202e48 <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc02029ba:	000b3783          	ld	a5,0(s6)
ffffffffc02029be:	779c                	ld	a5,40(a5)
ffffffffc02029c0:	9782                	jalr	a5
ffffffffc02029c2:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02029c4:	6098                	ld	a4,0(s1)
ffffffffc02029c6:	c80007b7          	lui	a5,0xc8000
ffffffffc02029ca:	83b1                	srli	a5,a5,0xc
ffffffffc02029cc:	66e7e663          	bltu	a5,a4,ffffffffc0203038 <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02029d0:	00093503          	ld	a0,0(s2)
ffffffffc02029d4:	64050263          	beqz	a0,ffffffffc0203018 <pmm_init+0x7b0>
ffffffffc02029d8:	03451793          	slli	a5,a0,0x34
ffffffffc02029dc:	62079e63          	bnez	a5,ffffffffc0203018 <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02029e0:	4601                	li	a2,0
ffffffffc02029e2:	4581                	li	a1,0
ffffffffc02029e4:	8b7ff0ef          	jal	ffffffffc020229a <get_page>
ffffffffc02029e8:	240519e3          	bnez	a0,ffffffffc020343a <pmm_init+0xbd2>
ffffffffc02029ec:	100027f3          	csrr	a5,sstatus
ffffffffc02029f0:	8b89                	andi	a5,a5,2
ffffffffc02029f2:	44079063          	bnez	a5,ffffffffc0202e32 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc02029f6:	000b3783          	ld	a5,0(s6)
ffffffffc02029fa:	4505                	li	a0,1
ffffffffc02029fc:	6f9c                	ld	a5,24(a5)
ffffffffc02029fe:	9782                	jalr	a5
ffffffffc0202a00:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202a02:	00093503          	ld	a0,0(s2)
ffffffffc0202a06:	4681                	li	a3,0
ffffffffc0202a08:	4601                	li	a2,0
ffffffffc0202a0a:	85d2                	mv	a1,s4
ffffffffc0202a0c:	d67ff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc0202a10:	280511e3          	bnez	a0,ffffffffc0203492 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202a14:	00093503          	ld	a0,0(s2)
ffffffffc0202a18:	4601                	li	a2,0
ffffffffc0202a1a:	4581                	li	a1,0
ffffffffc0202a1c:	e20ff0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0202a20:	240509e3          	beqz	a0,ffffffffc0203472 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a24:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a26:	0017f713          	andi	a4,a5,1
ffffffffc0202a2a:	58070f63          	beqz	a4,ffffffffc0202fc8 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202a2e:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a30:	078a                	slli	a5,a5,0x2
ffffffffc0202a32:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a34:	58e7f863          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a38:	000bb683          	ld	a3,0(s7)
ffffffffc0202a3c:	079a                	slli	a5,a5,0x6
ffffffffc0202a3e:	fe000637          	lui	a2,0xfe000
ffffffffc0202a42:	97b2                	add	a5,a5,a2
ffffffffc0202a44:	97b6                	add	a5,a5,a3
ffffffffc0202a46:	14fa1ae3          	bne	s4,a5,ffffffffc020339a <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc0202a4a:	000a2683          	lw	a3,0(s4) # 200000 <_binary_obj___user_exit_out_size+0x1f5e48>
ffffffffc0202a4e:	4785                	li	a5,1
ffffffffc0202a50:	12f695e3          	bne	a3,a5,ffffffffc020337a <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202a54:	00093503          	ld	a0,0(s2)
ffffffffc0202a58:	77fd                	lui	a5,0xfffff
ffffffffc0202a5a:	6114                	ld	a3,0(a0)
ffffffffc0202a5c:	068a                	slli	a3,a3,0x2
ffffffffc0202a5e:	8efd                	and	a3,a3,a5
ffffffffc0202a60:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202a64:	0ee67fe3          	bgeu	a2,a4,ffffffffc0203362 <pmm_init+0xafa>
ffffffffc0202a68:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202a6c:	96e2                	add	a3,a3,s8
ffffffffc0202a6e:	0006ba83          	ld	s5,0(a3)
ffffffffc0202a72:	0a8a                	slli	s5,s5,0x2
ffffffffc0202a74:	00fafab3          	and	s5,s5,a5
ffffffffc0202a78:	00cad793          	srli	a5,s5,0xc
ffffffffc0202a7c:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0203348 <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a80:	4601                	li	a2,0
ffffffffc0202a82:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202a84:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a86:	db6ff0ef          	jal	ffffffffc020203c <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202a8a:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202a8c:	05851ee3          	bne	a0,s8,ffffffffc02032e8 <pmm_init+0xa80>
ffffffffc0202a90:	100027f3          	csrr	a5,sstatus
ffffffffc0202a94:	8b89                	andi	a5,a5,2
ffffffffc0202a96:	3e079b63          	bnez	a5,ffffffffc0202e8c <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a9a:	000b3783          	ld	a5,0(s6)
ffffffffc0202a9e:	4505                	li	a0,1
ffffffffc0202aa0:	6f9c                	ld	a5,24(a5)
ffffffffc0202aa2:	9782                	jalr	a5
ffffffffc0202aa4:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202aa6:	00093503          	ld	a0,0(s2)
ffffffffc0202aaa:	46d1                	li	a3,20
ffffffffc0202aac:	6605                	lui	a2,0x1
ffffffffc0202aae:	85e2                	mv	a1,s8
ffffffffc0202ab0:	cc3ff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc0202ab4:	06051ae3          	bnez	a0,ffffffffc0203328 <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202ab8:	00093503          	ld	a0,0(s2)
ffffffffc0202abc:	4601                	li	a2,0
ffffffffc0202abe:	6585                	lui	a1,0x1
ffffffffc0202ac0:	d7cff0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0202ac4:	040502e3          	beqz	a0,ffffffffc0203308 <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc0202ac8:	611c                	ld	a5,0(a0)
ffffffffc0202aca:	0107f713          	andi	a4,a5,16
ffffffffc0202ace:	7e070163          	beqz	a4,ffffffffc02032b0 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc0202ad2:	8b91                	andi	a5,a5,4
ffffffffc0202ad4:	7a078e63          	beqz	a5,ffffffffc0203290 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202ad8:	00093503          	ld	a0,0(s2)
ffffffffc0202adc:	611c                	ld	a5,0(a0)
ffffffffc0202ade:	8bc1                	andi	a5,a5,16
ffffffffc0202ae0:	78078863          	beqz	a5,ffffffffc0203270 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc0202ae4:	000c2703          	lw	a4,0(s8)
ffffffffc0202ae8:	4785                	li	a5,1
ffffffffc0202aea:	76f71363          	bne	a4,a5,ffffffffc0203250 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202aee:	4681                	li	a3,0
ffffffffc0202af0:	6605                	lui	a2,0x1
ffffffffc0202af2:	85d2                	mv	a1,s4
ffffffffc0202af4:	c7fff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc0202af8:	72051c63          	bnez	a0,ffffffffc0203230 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202afc:	000a2703          	lw	a4,0(s4)
ffffffffc0202b00:	4789                	li	a5,2
ffffffffc0202b02:	70f71763          	bne	a4,a5,ffffffffc0203210 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc0202b06:	000c2783          	lw	a5,0(s8)
ffffffffc0202b0a:	6e079363          	bnez	a5,ffffffffc02031f0 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202b0e:	00093503          	ld	a0,0(s2)
ffffffffc0202b12:	4601                	li	a2,0
ffffffffc0202b14:	6585                	lui	a1,0x1
ffffffffc0202b16:	d26ff0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0202b1a:	6a050b63          	beqz	a0,ffffffffc02031d0 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202b1e:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202b20:	00177793          	andi	a5,a4,1
ffffffffc0202b24:	4a078263          	beqz	a5,ffffffffc0202fc8 <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202b28:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202b2a:	00271793          	slli	a5,a4,0x2
ffffffffc0202b2e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b30:	48d7fa63          	bgeu	a5,a3,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b34:	000bb683          	ld	a3,0(s7)
ffffffffc0202b38:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202b3c:	97d6                	add	a5,a5,s5
ffffffffc0202b3e:	079a                	slli	a5,a5,0x6
ffffffffc0202b40:	97b6                	add	a5,a5,a3
ffffffffc0202b42:	66fa1763          	bne	s4,a5,ffffffffc02031b0 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202b46:	8b41                	andi	a4,a4,16
ffffffffc0202b48:	64071463          	bnez	a4,ffffffffc0203190 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202b4c:	00093503          	ld	a0,0(s2)
ffffffffc0202b50:	4581                	li	a1,0
ffffffffc0202b52:	b85ff0ef          	jal	ffffffffc02026d6 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202b56:	000a2c83          	lw	s9,0(s4)
ffffffffc0202b5a:	4785                	li	a5,1
ffffffffc0202b5c:	60fc9a63          	bne	s9,a5,ffffffffc0203170 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202b60:	000c2783          	lw	a5,0(s8)
ffffffffc0202b64:	5e079663          	bnez	a5,ffffffffc0203150 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202b68:	00093503          	ld	a0,0(s2)
ffffffffc0202b6c:	6585                	lui	a1,0x1
ffffffffc0202b6e:	b69ff0ef          	jal	ffffffffc02026d6 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202b72:	000a2783          	lw	a5,0(s4)
ffffffffc0202b76:	52079d63          	bnez	a5,ffffffffc02030b0 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202b7a:	000c2783          	lw	a5,0(s8)
ffffffffc0202b7e:	50079963          	bnez	a5,ffffffffc0203090 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202b82:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202b86:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b88:	000a3783          	ld	a5,0(s4)
ffffffffc0202b8c:	078a                	slli	a5,a5,0x2
ffffffffc0202b8e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b90:	42e7fa63          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b94:	000bb503          	ld	a0,0(s7)
ffffffffc0202b98:	97d6                	add	a5,a5,s5
ffffffffc0202b9a:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc0202b9c:	00f506b3          	add	a3,a0,a5
ffffffffc0202ba0:	4294                	lw	a3,0(a3)
ffffffffc0202ba2:	4d969763          	bne	a3,s9,ffffffffc0203070 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc0202ba6:	8799                	srai	a5,a5,0x6
ffffffffc0202ba8:	00080637          	lui	a2,0x80
ffffffffc0202bac:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202bae:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202bb2:	4ae7f363          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202bb6:	0009b783          	ld	a5,0(s3)
ffffffffc0202bba:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bbc:	639c                	ld	a5,0(a5)
ffffffffc0202bbe:	078a                	slli	a5,a5,0x2
ffffffffc0202bc0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bc2:	40e7f163          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bc6:	8f91                	sub	a5,a5,a2
ffffffffc0202bc8:	079a                	slli	a5,a5,0x6
ffffffffc0202bca:	953e                	add	a0,a0,a5
ffffffffc0202bcc:	100027f3          	csrr	a5,sstatus
ffffffffc0202bd0:	8b89                	andi	a5,a5,2
ffffffffc0202bd2:	30079863          	bnez	a5,ffffffffc0202ee2 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc0202bd6:	000b3783          	ld	a5,0(s6)
ffffffffc0202bda:	4585                	li	a1,1
ffffffffc0202bdc:	739c                	ld	a5,32(a5)
ffffffffc0202bde:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202be0:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202be4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202be6:	078a                	slli	a5,a5,0x2
ffffffffc0202be8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bea:	3ce7fd63          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bee:	000bb503          	ld	a0,0(s7)
ffffffffc0202bf2:	fe000737          	lui	a4,0xfe000
ffffffffc0202bf6:	079a                	slli	a5,a5,0x6
ffffffffc0202bf8:	97ba                	add	a5,a5,a4
ffffffffc0202bfa:	953e                	add	a0,a0,a5
ffffffffc0202bfc:	100027f3          	csrr	a5,sstatus
ffffffffc0202c00:	8b89                	andi	a5,a5,2
ffffffffc0202c02:	2c079463          	bnez	a5,ffffffffc0202eca <pmm_init+0x662>
ffffffffc0202c06:	000b3783          	ld	a5,0(s6)
ffffffffc0202c0a:	4585                	li	a1,1
ffffffffc0202c0c:	739c                	ld	a5,32(a5)
ffffffffc0202c0e:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202c10:	00093783          	ld	a5,0(s2)
ffffffffc0202c14:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd63308>
    asm volatile("sfence.vma");
ffffffffc0202c18:	12000073          	sfence.vma
ffffffffc0202c1c:	100027f3          	csrr	a5,sstatus
ffffffffc0202c20:	8b89                	andi	a5,a5,2
ffffffffc0202c22:	28079a63          	bnez	a5,ffffffffc0202eb6 <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c26:	000b3783          	ld	a5,0(s6)
ffffffffc0202c2a:	779c                	ld	a5,40(a5)
ffffffffc0202c2c:	9782                	jalr	a5
ffffffffc0202c2e:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202c30:	4d441063          	bne	s0,s4,ffffffffc02030f0 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202c34:	00004517          	auipc	a0,0x4
ffffffffc0202c38:	f8450513          	addi	a0,a0,-124 # ffffffffc0206bb8 <etext+0x130a>
ffffffffc0202c3c:	d58fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202c40:	100027f3          	csrr	a5,sstatus
ffffffffc0202c44:	8b89                	andi	a5,a5,2
ffffffffc0202c46:	24079e63          	bnez	a5,ffffffffc0202ea2 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c4a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c4e:	779c                	ld	a5,40(a5)
ffffffffc0202c50:	9782                	jalr	a5
ffffffffc0202c52:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c54:	609c                	ld	a5,0(s1)
ffffffffc0202c56:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202c5a:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c5c:	00c79713          	slli	a4,a5,0xc
ffffffffc0202c60:	6a85                	lui	s5,0x1
ffffffffc0202c62:	02e47c63          	bgeu	s0,a4,ffffffffc0202c9a <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202c66:	00c45713          	srli	a4,s0,0xc
ffffffffc0202c6a:	30f77063          	bgeu	a4,a5,ffffffffc0202f6a <pmm_init+0x702>
ffffffffc0202c6e:	0009b583          	ld	a1,0(s3)
ffffffffc0202c72:	00093503          	ld	a0,0(s2)
ffffffffc0202c76:	4601                	li	a2,0
ffffffffc0202c78:	95a2                	add	a1,a1,s0
ffffffffc0202c7a:	bc2ff0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0202c7e:	32050363          	beqz	a0,ffffffffc0202fa4 <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202c82:	611c                	ld	a5,0(a0)
ffffffffc0202c84:	078a                	slli	a5,a5,0x2
ffffffffc0202c86:	0147f7b3          	and	a5,a5,s4
ffffffffc0202c8a:	2e879d63          	bne	a5,s0,ffffffffc0202f84 <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c8e:	609c                	ld	a5,0(s1)
ffffffffc0202c90:	9456                	add	s0,s0,s5
ffffffffc0202c92:	00c79713          	slli	a4,a5,0xc
ffffffffc0202c96:	fce468e3          	bltu	s0,a4,ffffffffc0202c66 <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202c9a:	00093783          	ld	a5,0(s2)
ffffffffc0202c9e:	639c                	ld	a5,0(a5)
ffffffffc0202ca0:	42079863          	bnez	a5,ffffffffc02030d0 <pmm_init+0x868>
ffffffffc0202ca4:	100027f3          	csrr	a5,sstatus
ffffffffc0202ca8:	8b89                	andi	a5,a5,2
ffffffffc0202caa:	24079863          	bnez	a5,ffffffffc0202efa <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202cae:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb2:	4505                	li	a0,1
ffffffffc0202cb4:	6f9c                	ld	a5,24(a5)
ffffffffc0202cb6:	9782                	jalr	a5
ffffffffc0202cb8:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202cba:	00093503          	ld	a0,0(s2)
ffffffffc0202cbe:	4699                	li	a3,6
ffffffffc0202cc0:	10000613          	li	a2,256
ffffffffc0202cc4:	85a2                	mv	a1,s0
ffffffffc0202cc6:	aadff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc0202cca:	46051363          	bnez	a0,ffffffffc0203130 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc0202cce:	4018                	lw	a4,0(s0)
ffffffffc0202cd0:	4785                	li	a5,1
ffffffffc0202cd2:	42f71f63          	bne	a4,a5,ffffffffc0203110 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202cd6:	00093503          	ld	a0,0(s2)
ffffffffc0202cda:	6605                	lui	a2,0x1
ffffffffc0202cdc:	10060613          	addi	a2,a2,256 # 1100 <_binary_obj___user_softint_out_size-0x7ab0>
ffffffffc0202ce0:	4699                	li	a3,6
ffffffffc0202ce2:	85a2                	mv	a1,s0
ffffffffc0202ce4:	a8fff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc0202ce8:	72051963          	bnez	a0,ffffffffc020341a <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc0202cec:	4018                	lw	a4,0(s0)
ffffffffc0202cee:	4789                	li	a5,2
ffffffffc0202cf0:	70f71563          	bne	a4,a5,ffffffffc02033fa <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202cf4:	00004597          	auipc	a1,0x4
ffffffffc0202cf8:	00c58593          	addi	a1,a1,12 # ffffffffc0206d00 <etext+0x1452>
ffffffffc0202cfc:	10000513          	li	a0,256
ffffffffc0202d00:	305020ef          	jal	ffffffffc0205804 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202d04:	6585                	lui	a1,0x1
ffffffffc0202d06:	10058593          	addi	a1,a1,256 # 1100 <_binary_obj___user_softint_out_size-0x7ab0>
ffffffffc0202d0a:	10000513          	li	a0,256
ffffffffc0202d0e:	309020ef          	jal	ffffffffc0205816 <strcmp>
ffffffffc0202d12:	6c051463          	bnez	a0,ffffffffc02033da <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc0202d16:	000bb683          	ld	a3,0(s7)
ffffffffc0202d1a:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202d1e:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202d20:	40d406b3          	sub	a3,s0,a3
ffffffffc0202d24:	8699                	srai	a3,a3,0x6
ffffffffc0202d26:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202d28:	00c69793          	slli	a5,a3,0xc
ffffffffc0202d2c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d2e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202d30:	32e7f463          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202d34:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202d38:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202d3c:	97b6                	add	a5,a5,a3
ffffffffc0202d3e:	10078023          	sb	zero,256(a5) # 80100 <_binary_obj___user_exit_out_size+0x75f48>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202d42:	28f020ef          	jal	ffffffffc02057d0 <strlen>
ffffffffc0202d46:	66051a63          	bnez	a0,ffffffffc02033ba <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202d4a:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202d4e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d50:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd63308>
ffffffffc0202d54:	078a                	slli	a5,a5,0x2
ffffffffc0202d56:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d58:	26e7f663          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d5c:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202d60:	2ee7fc63          	bgeu	a5,a4,ffffffffc0203058 <pmm_init+0x7f0>
ffffffffc0202d64:	0009b783          	ld	a5,0(s3)
ffffffffc0202d68:	00f689b3          	add	s3,a3,a5
ffffffffc0202d6c:	100027f3          	csrr	a5,sstatus
ffffffffc0202d70:	8b89                	andi	a5,a5,2
ffffffffc0202d72:	1e079163          	bnez	a5,ffffffffc0202f54 <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc0202d76:	000b3783          	ld	a5,0(s6)
ffffffffc0202d7a:	8522                	mv	a0,s0
ffffffffc0202d7c:	4585                	li	a1,1
ffffffffc0202d7e:	739c                	ld	a5,32(a5)
ffffffffc0202d80:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d82:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc0202d86:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d88:	078a                	slli	a5,a5,0x2
ffffffffc0202d8a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d8c:	22e7fc63          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d90:	000bb503          	ld	a0,0(s7)
ffffffffc0202d94:	fe000737          	lui	a4,0xfe000
ffffffffc0202d98:	079a                	slli	a5,a5,0x6
ffffffffc0202d9a:	97ba                	add	a5,a5,a4
ffffffffc0202d9c:	953e                	add	a0,a0,a5
ffffffffc0202d9e:	100027f3          	csrr	a5,sstatus
ffffffffc0202da2:	8b89                	andi	a5,a5,2
ffffffffc0202da4:	18079c63          	bnez	a5,ffffffffc0202f3c <pmm_init+0x6d4>
ffffffffc0202da8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dac:	4585                	li	a1,1
ffffffffc0202dae:	739c                	ld	a5,32(a5)
ffffffffc0202db0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202db2:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202db6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202db8:	078a                	slli	a5,a5,0x2
ffffffffc0202dba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dbc:	20e7f463          	bgeu	a5,a4,ffffffffc0202fc4 <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dc0:	000bb503          	ld	a0,0(s7)
ffffffffc0202dc4:	fe000737          	lui	a4,0xfe000
ffffffffc0202dc8:	079a                	slli	a5,a5,0x6
ffffffffc0202dca:	97ba                	add	a5,a5,a4
ffffffffc0202dcc:	953e                	add	a0,a0,a5
ffffffffc0202dce:	100027f3          	csrr	a5,sstatus
ffffffffc0202dd2:	8b89                	andi	a5,a5,2
ffffffffc0202dd4:	14079863          	bnez	a5,ffffffffc0202f24 <pmm_init+0x6bc>
ffffffffc0202dd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ddc:	4585                	li	a1,1
ffffffffc0202dde:	739c                	ld	a5,32(a5)
ffffffffc0202de0:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202de2:	00093783          	ld	a5,0(s2)
ffffffffc0202de6:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202dea:	12000073          	sfence.vma
ffffffffc0202dee:	100027f3          	csrr	a5,sstatus
ffffffffc0202df2:	8b89                	andi	a5,a5,2
ffffffffc0202df4:	10079e63          	bnez	a5,ffffffffc0202f10 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202df8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dfc:	779c                	ld	a5,40(a5)
ffffffffc0202dfe:	9782                	jalr	a5
ffffffffc0202e00:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202e02:	1e8c1b63          	bne	s8,s0,ffffffffc0202ff8 <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202e06:	00004517          	auipc	a0,0x4
ffffffffc0202e0a:	f7250513          	addi	a0,a0,-142 # ffffffffc0206d78 <etext+0x14ca>
ffffffffc0202e0e:	b86fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202e12:	7406                	ld	s0,96(sp)
ffffffffc0202e14:	70a6                	ld	ra,104(sp)
ffffffffc0202e16:	64e6                	ld	s1,88(sp)
ffffffffc0202e18:	6946                	ld	s2,80(sp)
ffffffffc0202e1a:	69a6                	ld	s3,72(sp)
ffffffffc0202e1c:	6a06                	ld	s4,64(sp)
ffffffffc0202e1e:	7ae2                	ld	s5,56(sp)
ffffffffc0202e20:	7b42                	ld	s6,48(sp)
ffffffffc0202e22:	7ba2                	ld	s7,40(sp)
ffffffffc0202e24:	7c02                	ld	s8,32(sp)
ffffffffc0202e26:	6ce2                	ld	s9,24(sp)
ffffffffc0202e28:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202e2a:	f83fe06f          	j	ffffffffc0201dac <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202e2e:	853e                	mv	a0,a5
ffffffffc0202e30:	b4e1                	j	ffffffffc02028f8 <pmm_init+0x90>
        intr_disable();
ffffffffc0202e32:	ad3fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e36:	000b3783          	ld	a5,0(s6)
ffffffffc0202e3a:	4505                	li	a0,1
ffffffffc0202e3c:	6f9c                	ld	a5,24(a5)
ffffffffc0202e3e:	9782                	jalr	a5
ffffffffc0202e40:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e42:	abdfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e46:	be75                	j	ffffffffc0202a02 <pmm_init+0x19a>
        intr_disable();
ffffffffc0202e48:	abdfd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e4c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e50:	779c                	ld	a5,40(a5)
ffffffffc0202e52:	9782                	jalr	a5
ffffffffc0202e54:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e56:	aa9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202e5a:	b6ad                	j	ffffffffc02029c4 <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202e5c:	6705                	lui	a4,0x1
ffffffffc0202e5e:	177d                	addi	a4,a4,-1 # fff <_binary_obj___user_softint_out_size-0x7bb1>
ffffffffc0202e60:	96ba                	add	a3,a3,a4
ffffffffc0202e62:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202e64:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202e68:	14a77e63          	bgeu	a4,a0,ffffffffc0202fc4 <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202e6c:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202e70:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202e72:	071a                	slli	a4,a4,0x6
ffffffffc0202e74:	fe0007b7          	lui	a5,0xfe000
ffffffffc0202e78:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202e7a:	6a9c                	ld	a5,16(a3)
ffffffffc0202e7c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202e80:	00e60533          	add	a0,a2,a4
ffffffffc0202e84:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202e86:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202e8a:	bcf1                	j	ffffffffc0202966 <pmm_init+0xfe>
        intr_disable();
ffffffffc0202e8c:	a79fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e90:	000b3783          	ld	a5,0(s6)
ffffffffc0202e94:	4505                	li	a0,1
ffffffffc0202e96:	6f9c                	ld	a5,24(a5)
ffffffffc0202e98:	9782                	jalr	a5
ffffffffc0202e9a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e9c:	a63fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ea0:	b119                	j	ffffffffc0202aa6 <pmm_init+0x23e>
        intr_disable();
ffffffffc0202ea2:	a63fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202ea6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eaa:	779c                	ld	a5,40(a5)
ffffffffc0202eac:	9782                	jalr	a5
ffffffffc0202eae:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202eb0:	a4ffd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202eb4:	b345                	j	ffffffffc0202c54 <pmm_init+0x3ec>
        intr_disable();
ffffffffc0202eb6:	a4ffd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202eba:	000b3783          	ld	a5,0(s6)
ffffffffc0202ebe:	779c                	ld	a5,40(a5)
ffffffffc0202ec0:	9782                	jalr	a5
ffffffffc0202ec2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202ec4:	a3bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ec8:	b3a5                	j	ffffffffc0202c30 <pmm_init+0x3c8>
ffffffffc0202eca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ecc:	a39fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202ed0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ed4:	6522                	ld	a0,8(sp)
ffffffffc0202ed6:	4585                	li	a1,1
ffffffffc0202ed8:	739c                	ld	a5,32(a5)
ffffffffc0202eda:	9782                	jalr	a5
        intr_enable();
ffffffffc0202edc:	a23fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ee0:	bb05                	j	ffffffffc0202c10 <pmm_init+0x3a8>
ffffffffc0202ee2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202ee4:	a21fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202ee8:	000b3783          	ld	a5,0(s6)
ffffffffc0202eec:	6522                	ld	a0,8(sp)
ffffffffc0202eee:	4585                	li	a1,1
ffffffffc0202ef0:	739c                	ld	a5,32(a5)
ffffffffc0202ef2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ef4:	a0bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202ef8:	b1e5                	j	ffffffffc0202be0 <pmm_init+0x378>
        intr_disable();
ffffffffc0202efa:	a0bfd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202efe:	000b3783          	ld	a5,0(s6)
ffffffffc0202f02:	4505                	li	a0,1
ffffffffc0202f04:	6f9c                	ld	a5,24(a5)
ffffffffc0202f06:	9782                	jalr	a5
ffffffffc0202f08:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f0a:	9f5fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202f0e:	b375                	j	ffffffffc0202cba <pmm_init+0x452>
        intr_disable();
ffffffffc0202f10:	9f5fd0ef          	jal	ffffffffc0200904 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202f14:	000b3783          	ld	a5,0(s6)
ffffffffc0202f18:	779c                	ld	a5,40(a5)
ffffffffc0202f1a:	9782                	jalr	a5
ffffffffc0202f1c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202f1e:	9e1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202f22:	b5c5                	j	ffffffffc0202e02 <pmm_init+0x59a>
ffffffffc0202f24:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f26:	9dffd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f2a:	000b3783          	ld	a5,0(s6)
ffffffffc0202f2e:	6522                	ld	a0,8(sp)
ffffffffc0202f30:	4585                	li	a1,1
ffffffffc0202f32:	739c                	ld	a5,32(a5)
ffffffffc0202f34:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f36:	9c9fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202f3a:	b565                	j	ffffffffc0202de2 <pmm_init+0x57a>
ffffffffc0202f3c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202f3e:	9c7fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202f42:	000b3783          	ld	a5,0(s6)
ffffffffc0202f46:	6522                	ld	a0,8(sp)
ffffffffc0202f48:	4585                	li	a1,1
ffffffffc0202f4a:	739c                	ld	a5,32(a5)
ffffffffc0202f4c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f4e:	9b1fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202f52:	b585                	j	ffffffffc0202db2 <pmm_init+0x54a>
        intr_disable();
ffffffffc0202f54:	9b1fd0ef          	jal	ffffffffc0200904 <intr_disable>
ffffffffc0202f58:	000b3783          	ld	a5,0(s6)
ffffffffc0202f5c:	8522                	mv	a0,s0
ffffffffc0202f5e:	4585                	li	a1,1
ffffffffc0202f60:	739c                	ld	a5,32(a5)
ffffffffc0202f62:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f64:	99bfd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0202f68:	bd29                	j	ffffffffc0202d82 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f6a:	86a2                	mv	a3,s0
ffffffffc0202f6c:	00003617          	auipc	a2,0x3
ffffffffc0202f70:	72460613          	addi	a2,a2,1828 # ffffffffc0206690 <etext+0xde2>
ffffffffc0202f74:	23900593          	li	a1,569
ffffffffc0202f78:	00004517          	auipc	a0,0x4
ffffffffc0202f7c:	80850513          	addi	a0,a0,-2040 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202f80:	cc6fd0ef          	jal	ffffffffc0200446 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202f84:	00004697          	auipc	a3,0x4
ffffffffc0202f88:	c9468693          	addi	a3,a3,-876 # ffffffffc0206c18 <etext+0x136a>
ffffffffc0202f8c:	00003617          	auipc	a2,0x3
ffffffffc0202f90:	35460613          	addi	a2,a2,852 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0202f94:	23a00593          	li	a1,570
ffffffffc0202f98:	00003517          	auipc	a0,0x3
ffffffffc0202f9c:	7e850513          	addi	a0,a0,2024 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202fa0:	ca6fd0ef          	jal	ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202fa4:	00004697          	auipc	a3,0x4
ffffffffc0202fa8:	c3468693          	addi	a3,a3,-972 # ffffffffc0206bd8 <etext+0x132a>
ffffffffc0202fac:	00003617          	auipc	a2,0x3
ffffffffc0202fb0:	33460613          	addi	a2,a2,820 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0202fb4:	23900593          	li	a1,569
ffffffffc0202fb8:	00003517          	auipc	a0,0x3
ffffffffc0202fbc:	7c850513          	addi	a0,a0,1992 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202fc0:	c86fd0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0202fc4:	fb5fe0ef          	jal	ffffffffc0201f78 <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc0202fc8:	00004617          	auipc	a2,0x4
ffffffffc0202fcc:	9b060613          	addi	a2,a2,-1616 # ffffffffc0206978 <etext+0x10ca>
ffffffffc0202fd0:	07f00593          	li	a1,127
ffffffffc0202fd4:	00003517          	auipc	a0,0x3
ffffffffc0202fd8:	6e450513          	addi	a0,a0,1764 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0202fdc:	c6afd0ef          	jal	ffffffffc0200446 <__panic>
        panic("DTB memory info not available");
ffffffffc0202fe0:	00004617          	auipc	a2,0x4
ffffffffc0202fe4:	81060613          	addi	a2,a2,-2032 # ffffffffc02067f0 <etext+0xf42>
ffffffffc0202fe8:	06500593          	li	a1,101
ffffffffc0202fec:	00003517          	auipc	a0,0x3
ffffffffc0202ff0:	79450513          	addi	a0,a0,1940 # ffffffffc0206780 <etext+0xed2>
ffffffffc0202ff4:	c52fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202ff8:	00004697          	auipc	a3,0x4
ffffffffc0202ffc:	b9868693          	addi	a3,a3,-1128 # ffffffffc0206b90 <etext+0x12e2>
ffffffffc0203000:	00003617          	auipc	a2,0x3
ffffffffc0203004:	2e060613          	addi	a2,a2,736 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203008:	25400593          	li	a1,596
ffffffffc020300c:	00003517          	auipc	a0,0x3
ffffffffc0203010:	77450513          	addi	a0,a0,1908 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203014:	c32fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0203018:	00004697          	auipc	a3,0x4
ffffffffc020301c:	89068693          	addi	a3,a3,-1904 # ffffffffc02068a8 <etext+0xffa>
ffffffffc0203020:	00003617          	auipc	a2,0x3
ffffffffc0203024:	2c060613          	addi	a2,a2,704 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203028:	1fb00593          	li	a1,507
ffffffffc020302c:	00003517          	auipc	a0,0x3
ffffffffc0203030:	75450513          	addi	a0,a0,1876 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203034:	c12fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203038:	00004697          	auipc	a3,0x4
ffffffffc020303c:	85068693          	addi	a3,a3,-1968 # ffffffffc0206888 <etext+0xfda>
ffffffffc0203040:	00003617          	auipc	a2,0x3
ffffffffc0203044:	2a060613          	addi	a2,a2,672 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203048:	1fa00593          	li	a1,506
ffffffffc020304c:	00003517          	auipc	a0,0x3
ffffffffc0203050:	73450513          	addi	a0,a0,1844 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203054:	bf2fd0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203058:	00003617          	auipc	a2,0x3
ffffffffc020305c:	63860613          	addi	a2,a2,1592 # ffffffffc0206690 <etext+0xde2>
ffffffffc0203060:	07100593          	li	a1,113
ffffffffc0203064:	00003517          	auipc	a0,0x3
ffffffffc0203068:	65450513          	addi	a0,a0,1620 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc020306c:	bdafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203070:	00004697          	auipc	a3,0x4
ffffffffc0203074:	af068693          	addi	a3,a3,-1296 # ffffffffc0206b60 <etext+0x12b2>
ffffffffc0203078:	00003617          	auipc	a2,0x3
ffffffffc020307c:	26860613          	addi	a2,a2,616 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203080:	22200593          	li	a1,546
ffffffffc0203084:	00003517          	auipc	a0,0x3
ffffffffc0203088:	6fc50513          	addi	a0,a0,1788 # ffffffffc0206780 <etext+0xed2>
ffffffffc020308c:	bbafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203090:	00004697          	auipc	a3,0x4
ffffffffc0203094:	a8868693          	addi	a3,a3,-1400 # ffffffffc0206b18 <etext+0x126a>
ffffffffc0203098:	00003617          	auipc	a2,0x3
ffffffffc020309c:	24860613          	addi	a2,a2,584 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02030a0:	22000593          	li	a1,544
ffffffffc02030a4:	00003517          	auipc	a0,0x3
ffffffffc02030a8:	6dc50513          	addi	a0,a0,1756 # ffffffffc0206780 <etext+0xed2>
ffffffffc02030ac:	b9afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02030b0:	00004697          	auipc	a3,0x4
ffffffffc02030b4:	a9868693          	addi	a3,a3,-1384 # ffffffffc0206b48 <etext+0x129a>
ffffffffc02030b8:	00003617          	auipc	a2,0x3
ffffffffc02030bc:	22860613          	addi	a2,a2,552 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02030c0:	21f00593          	li	a1,543
ffffffffc02030c4:	00003517          	auipc	a0,0x3
ffffffffc02030c8:	6bc50513          	addi	a0,a0,1724 # ffffffffc0206780 <etext+0xed2>
ffffffffc02030cc:	b7afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02030d0:	00004697          	auipc	a3,0x4
ffffffffc02030d4:	b6068693          	addi	a3,a3,-1184 # ffffffffc0206c30 <etext+0x1382>
ffffffffc02030d8:	00003617          	auipc	a2,0x3
ffffffffc02030dc:	20860613          	addi	a2,a2,520 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02030e0:	23d00593          	li	a1,573
ffffffffc02030e4:	00003517          	auipc	a0,0x3
ffffffffc02030e8:	69c50513          	addi	a0,a0,1692 # ffffffffc0206780 <etext+0xed2>
ffffffffc02030ec:	b5afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02030f0:	00004697          	auipc	a3,0x4
ffffffffc02030f4:	aa068693          	addi	a3,a3,-1376 # ffffffffc0206b90 <etext+0x12e2>
ffffffffc02030f8:	00003617          	auipc	a2,0x3
ffffffffc02030fc:	1e860613          	addi	a2,a2,488 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203100:	22a00593          	li	a1,554
ffffffffc0203104:	00003517          	auipc	a0,0x3
ffffffffc0203108:	67c50513          	addi	a0,a0,1660 # ffffffffc0206780 <etext+0xed2>
ffffffffc020310c:	b3afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203110:	00004697          	auipc	a3,0x4
ffffffffc0203114:	b7868693          	addi	a3,a3,-1160 # ffffffffc0206c88 <etext+0x13da>
ffffffffc0203118:	00003617          	auipc	a2,0x3
ffffffffc020311c:	1c860613          	addi	a2,a2,456 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203120:	24200593          	li	a1,578
ffffffffc0203124:	00003517          	auipc	a0,0x3
ffffffffc0203128:	65c50513          	addi	a0,a0,1628 # ffffffffc0206780 <etext+0xed2>
ffffffffc020312c:	b1afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203130:	00004697          	auipc	a3,0x4
ffffffffc0203134:	b1868693          	addi	a3,a3,-1256 # ffffffffc0206c48 <etext+0x139a>
ffffffffc0203138:	00003617          	auipc	a2,0x3
ffffffffc020313c:	1a860613          	addi	a2,a2,424 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203140:	24100593          	li	a1,577
ffffffffc0203144:	00003517          	auipc	a0,0x3
ffffffffc0203148:	63c50513          	addi	a0,a0,1596 # ffffffffc0206780 <etext+0xed2>
ffffffffc020314c:	afafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203150:	00004697          	auipc	a3,0x4
ffffffffc0203154:	9c868693          	addi	a3,a3,-1592 # ffffffffc0206b18 <etext+0x126a>
ffffffffc0203158:	00003617          	auipc	a2,0x3
ffffffffc020315c:	18860613          	addi	a2,a2,392 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203160:	21c00593          	li	a1,540
ffffffffc0203164:	00003517          	auipc	a0,0x3
ffffffffc0203168:	61c50513          	addi	a0,a0,1564 # ffffffffc0206780 <etext+0xed2>
ffffffffc020316c:	adafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203170:	00004697          	auipc	a3,0x4
ffffffffc0203174:	84868693          	addi	a3,a3,-1976 # ffffffffc02069b8 <etext+0x110a>
ffffffffc0203178:	00003617          	auipc	a2,0x3
ffffffffc020317c:	16860613          	addi	a2,a2,360 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203180:	21b00593          	li	a1,539
ffffffffc0203184:	00003517          	auipc	a0,0x3
ffffffffc0203188:	5fc50513          	addi	a0,a0,1532 # ffffffffc0206780 <etext+0xed2>
ffffffffc020318c:	abafd0ef          	jal	ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203190:	00004697          	auipc	a3,0x4
ffffffffc0203194:	9a068693          	addi	a3,a3,-1632 # ffffffffc0206b30 <etext+0x1282>
ffffffffc0203198:	00003617          	auipc	a2,0x3
ffffffffc020319c:	14860613          	addi	a2,a2,328 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02031a0:	21800593          	li	a1,536
ffffffffc02031a4:	00003517          	auipc	a0,0x3
ffffffffc02031a8:	5dc50513          	addi	a0,a0,1500 # ffffffffc0206780 <etext+0xed2>
ffffffffc02031ac:	a9afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02031b0:	00003697          	auipc	a3,0x3
ffffffffc02031b4:	7f068693          	addi	a3,a3,2032 # ffffffffc02069a0 <etext+0x10f2>
ffffffffc02031b8:	00003617          	auipc	a2,0x3
ffffffffc02031bc:	12860613          	addi	a2,a2,296 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02031c0:	21700593          	li	a1,535
ffffffffc02031c4:	00003517          	auipc	a0,0x3
ffffffffc02031c8:	5bc50513          	addi	a0,a0,1468 # ffffffffc0206780 <etext+0xed2>
ffffffffc02031cc:	a7afd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031d0:	00004697          	auipc	a3,0x4
ffffffffc02031d4:	87068693          	addi	a3,a3,-1936 # ffffffffc0206a40 <etext+0x1192>
ffffffffc02031d8:	00003617          	auipc	a2,0x3
ffffffffc02031dc:	10860613          	addi	a2,a2,264 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02031e0:	21600593          	li	a1,534
ffffffffc02031e4:	00003517          	auipc	a0,0x3
ffffffffc02031e8:	59c50513          	addi	a0,a0,1436 # ffffffffc0206780 <etext+0xed2>
ffffffffc02031ec:	a5afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02031f0:	00004697          	auipc	a3,0x4
ffffffffc02031f4:	92868693          	addi	a3,a3,-1752 # ffffffffc0206b18 <etext+0x126a>
ffffffffc02031f8:	00003617          	auipc	a2,0x3
ffffffffc02031fc:	0e860613          	addi	a2,a2,232 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203200:	21500593          	li	a1,533
ffffffffc0203204:	00003517          	auipc	a0,0x3
ffffffffc0203208:	57c50513          	addi	a0,a0,1404 # ffffffffc0206780 <etext+0xed2>
ffffffffc020320c:	a3afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203210:	00004697          	auipc	a3,0x4
ffffffffc0203214:	8f068693          	addi	a3,a3,-1808 # ffffffffc0206b00 <etext+0x1252>
ffffffffc0203218:	00003617          	auipc	a2,0x3
ffffffffc020321c:	0c860613          	addi	a2,a2,200 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203220:	21400593          	li	a1,532
ffffffffc0203224:	00003517          	auipc	a0,0x3
ffffffffc0203228:	55c50513          	addi	a0,a0,1372 # ffffffffc0206780 <etext+0xed2>
ffffffffc020322c:	a1afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203230:	00004697          	auipc	a3,0x4
ffffffffc0203234:	8a068693          	addi	a3,a3,-1888 # ffffffffc0206ad0 <etext+0x1222>
ffffffffc0203238:	00003617          	auipc	a2,0x3
ffffffffc020323c:	0a860613          	addi	a2,a2,168 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203240:	21300593          	li	a1,531
ffffffffc0203244:	00003517          	auipc	a0,0x3
ffffffffc0203248:	53c50513          	addi	a0,a0,1340 # ffffffffc0206780 <etext+0xed2>
ffffffffc020324c:	9fafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203250:	00004697          	auipc	a3,0x4
ffffffffc0203254:	86868693          	addi	a3,a3,-1944 # ffffffffc0206ab8 <etext+0x120a>
ffffffffc0203258:	00003617          	auipc	a2,0x3
ffffffffc020325c:	08860613          	addi	a2,a2,136 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203260:	21100593          	li	a1,529
ffffffffc0203264:	00003517          	auipc	a0,0x3
ffffffffc0203268:	51c50513          	addi	a0,a0,1308 # ffffffffc0206780 <etext+0xed2>
ffffffffc020326c:	9dafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203270:	00004697          	auipc	a3,0x4
ffffffffc0203274:	82868693          	addi	a3,a3,-2008 # ffffffffc0206a98 <etext+0x11ea>
ffffffffc0203278:	00003617          	auipc	a2,0x3
ffffffffc020327c:	06860613          	addi	a2,a2,104 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203280:	21000593          	li	a1,528
ffffffffc0203284:	00003517          	auipc	a0,0x3
ffffffffc0203288:	4fc50513          	addi	a0,a0,1276 # ffffffffc0206780 <etext+0xed2>
ffffffffc020328c:	9bafd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203290:	00003697          	auipc	a3,0x3
ffffffffc0203294:	7f868693          	addi	a3,a3,2040 # ffffffffc0206a88 <etext+0x11da>
ffffffffc0203298:	00003617          	auipc	a2,0x3
ffffffffc020329c:	04860613          	addi	a2,a2,72 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02032a0:	20f00593          	li	a1,527
ffffffffc02032a4:	00003517          	auipc	a0,0x3
ffffffffc02032a8:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206780 <etext+0xed2>
ffffffffc02032ac:	99afd0ef          	jal	ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02032b0:	00003697          	auipc	a3,0x3
ffffffffc02032b4:	7c868693          	addi	a3,a3,1992 # ffffffffc0206a78 <etext+0x11ca>
ffffffffc02032b8:	00003617          	auipc	a2,0x3
ffffffffc02032bc:	02860613          	addi	a2,a2,40 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02032c0:	20e00593          	li	a1,526
ffffffffc02032c4:	00003517          	auipc	a0,0x3
ffffffffc02032c8:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206780 <etext+0xed2>
ffffffffc02032cc:	97afd0ef          	jal	ffffffffc0200446 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02032d0:	00003617          	auipc	a2,0x3
ffffffffc02032d4:	46860613          	addi	a2,a2,1128 # ffffffffc0206738 <etext+0xe8a>
ffffffffc02032d8:	08100593          	li	a1,129
ffffffffc02032dc:	00003517          	auipc	a0,0x3
ffffffffc02032e0:	4a450513          	addi	a0,a0,1188 # ffffffffc0206780 <etext+0xed2>
ffffffffc02032e4:	962fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02032e8:	00003697          	auipc	a3,0x3
ffffffffc02032ec:	6e868693          	addi	a3,a3,1768 # ffffffffc02069d0 <etext+0x1122>
ffffffffc02032f0:	00003617          	auipc	a2,0x3
ffffffffc02032f4:	ff060613          	addi	a2,a2,-16 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02032f8:	20900593          	li	a1,521
ffffffffc02032fc:	00003517          	auipc	a0,0x3
ffffffffc0203300:	48450513          	addi	a0,a0,1156 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203304:	942fd0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203308:	00003697          	auipc	a3,0x3
ffffffffc020330c:	73868693          	addi	a3,a3,1848 # ffffffffc0206a40 <etext+0x1192>
ffffffffc0203310:	00003617          	auipc	a2,0x3
ffffffffc0203314:	fd060613          	addi	a2,a2,-48 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203318:	20d00593          	li	a1,525
ffffffffc020331c:	00003517          	auipc	a0,0x3
ffffffffc0203320:	46450513          	addi	a0,a0,1124 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203324:	922fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203328:	00003697          	auipc	a3,0x3
ffffffffc020332c:	6d868693          	addi	a3,a3,1752 # ffffffffc0206a00 <etext+0x1152>
ffffffffc0203330:	00003617          	auipc	a2,0x3
ffffffffc0203334:	fb060613          	addi	a2,a2,-80 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203338:	20c00593          	li	a1,524
ffffffffc020333c:	00003517          	auipc	a0,0x3
ffffffffc0203340:	44450513          	addi	a0,a0,1092 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203344:	902fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203348:	86d6                	mv	a3,s5
ffffffffc020334a:	00003617          	auipc	a2,0x3
ffffffffc020334e:	34660613          	addi	a2,a2,838 # ffffffffc0206690 <etext+0xde2>
ffffffffc0203352:	20800593          	li	a1,520
ffffffffc0203356:	00003517          	auipc	a0,0x3
ffffffffc020335a:	42a50513          	addi	a0,a0,1066 # ffffffffc0206780 <etext+0xed2>
ffffffffc020335e:	8e8fd0ef          	jal	ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203362:	00003617          	auipc	a2,0x3
ffffffffc0203366:	32e60613          	addi	a2,a2,814 # ffffffffc0206690 <etext+0xde2>
ffffffffc020336a:	20700593          	li	a1,519
ffffffffc020336e:	00003517          	auipc	a0,0x3
ffffffffc0203372:	41250513          	addi	a0,a0,1042 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203376:	8d0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020337a:	00003697          	auipc	a3,0x3
ffffffffc020337e:	63e68693          	addi	a3,a3,1598 # ffffffffc02069b8 <etext+0x110a>
ffffffffc0203382:	00003617          	auipc	a2,0x3
ffffffffc0203386:	f5e60613          	addi	a2,a2,-162 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020338a:	20500593          	li	a1,517
ffffffffc020338e:	00003517          	auipc	a0,0x3
ffffffffc0203392:	3f250513          	addi	a0,a0,1010 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203396:	8b0fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020339a:	00003697          	auipc	a3,0x3
ffffffffc020339e:	60668693          	addi	a3,a3,1542 # ffffffffc02069a0 <etext+0x10f2>
ffffffffc02033a2:	00003617          	auipc	a2,0x3
ffffffffc02033a6:	f3e60613          	addi	a2,a2,-194 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02033aa:	20400593          	li	a1,516
ffffffffc02033ae:	00003517          	auipc	a0,0x3
ffffffffc02033b2:	3d250513          	addi	a0,a0,978 # ffffffffc0206780 <etext+0xed2>
ffffffffc02033b6:	890fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02033ba:	00004697          	auipc	a3,0x4
ffffffffc02033be:	99668693          	addi	a3,a3,-1642 # ffffffffc0206d50 <etext+0x14a2>
ffffffffc02033c2:	00003617          	auipc	a2,0x3
ffffffffc02033c6:	f1e60613          	addi	a2,a2,-226 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02033ca:	24b00593          	li	a1,587
ffffffffc02033ce:	00003517          	auipc	a0,0x3
ffffffffc02033d2:	3b250513          	addi	a0,a0,946 # ffffffffc0206780 <etext+0xed2>
ffffffffc02033d6:	870fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02033da:	00004697          	auipc	a3,0x4
ffffffffc02033de:	93e68693          	addi	a3,a3,-1730 # ffffffffc0206d18 <etext+0x146a>
ffffffffc02033e2:	00003617          	auipc	a2,0x3
ffffffffc02033e6:	efe60613          	addi	a2,a2,-258 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02033ea:	24800593          	li	a1,584
ffffffffc02033ee:	00003517          	auipc	a0,0x3
ffffffffc02033f2:	39250513          	addi	a0,a0,914 # ffffffffc0206780 <etext+0xed2>
ffffffffc02033f6:	850fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02033fa:	00004697          	auipc	a3,0x4
ffffffffc02033fe:	8ee68693          	addi	a3,a3,-1810 # ffffffffc0206ce8 <etext+0x143a>
ffffffffc0203402:	00003617          	auipc	a2,0x3
ffffffffc0203406:	ede60613          	addi	a2,a2,-290 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020340a:	24400593          	li	a1,580
ffffffffc020340e:	00003517          	auipc	a0,0x3
ffffffffc0203412:	37250513          	addi	a0,a0,882 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203416:	830fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020341a:	00004697          	auipc	a3,0x4
ffffffffc020341e:	88668693          	addi	a3,a3,-1914 # ffffffffc0206ca0 <etext+0x13f2>
ffffffffc0203422:	00003617          	auipc	a2,0x3
ffffffffc0203426:	ebe60613          	addi	a2,a2,-322 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020342a:	24300593          	li	a1,579
ffffffffc020342e:	00003517          	auipc	a0,0x3
ffffffffc0203432:	35250513          	addi	a0,a0,850 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203436:	810fd0ef          	jal	ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020343a:	00003697          	auipc	a3,0x3
ffffffffc020343e:	4ae68693          	addi	a3,a3,1198 # ffffffffc02068e8 <etext+0x103a>
ffffffffc0203442:	00003617          	auipc	a2,0x3
ffffffffc0203446:	e9e60613          	addi	a2,a2,-354 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020344a:	1fc00593          	li	a1,508
ffffffffc020344e:	00003517          	auipc	a0,0x3
ffffffffc0203452:	33250513          	addi	a0,a0,818 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203456:	ff1fc0ef          	jal	ffffffffc0200446 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020345a:	00003617          	auipc	a2,0x3
ffffffffc020345e:	2de60613          	addi	a2,a2,734 # ffffffffc0206738 <etext+0xe8a>
ffffffffc0203462:	0c900593          	li	a1,201
ffffffffc0203466:	00003517          	auipc	a0,0x3
ffffffffc020346a:	31a50513          	addi	a0,a0,794 # ffffffffc0206780 <etext+0xed2>
ffffffffc020346e:	fd9fc0ef          	jal	ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203472:	00003697          	auipc	a3,0x3
ffffffffc0203476:	4d668693          	addi	a3,a3,1238 # ffffffffc0206948 <etext+0x109a>
ffffffffc020347a:	00003617          	auipc	a2,0x3
ffffffffc020347e:	e6660613          	addi	a2,a2,-410 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203482:	20300593          	li	a1,515
ffffffffc0203486:	00003517          	auipc	a0,0x3
ffffffffc020348a:	2fa50513          	addi	a0,a0,762 # ffffffffc0206780 <etext+0xed2>
ffffffffc020348e:	fb9fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203492:	00003697          	auipc	a3,0x3
ffffffffc0203496:	48668693          	addi	a3,a3,1158 # ffffffffc0206918 <etext+0x106a>
ffffffffc020349a:	00003617          	auipc	a2,0x3
ffffffffc020349e:	e4660613          	addi	a2,a2,-442 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02034a2:	20000593          	li	a1,512
ffffffffc02034a6:	00003517          	auipc	a0,0x3
ffffffffc02034aa:	2da50513          	addi	a0,a0,730 # ffffffffc0206780 <etext+0xed2>
ffffffffc02034ae:	f99fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02034b2 <copy_range>:
{
ffffffffc02034b2:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02034b4:	00d667b3          	or	a5,a2,a3
{
ffffffffc02034b8:	f486                	sd	ra,104(sp)
ffffffffc02034ba:	f0a2                	sd	s0,96(sp)
ffffffffc02034bc:	eca6                	sd	s1,88(sp)
ffffffffc02034be:	e8ca                	sd	s2,80(sp)
ffffffffc02034c0:	e4ce                	sd	s3,72(sp)
ffffffffc02034c2:	e0d2                	sd	s4,64(sp)
ffffffffc02034c4:	fc56                	sd	s5,56(sp)
ffffffffc02034c6:	f85a                	sd	s6,48(sp)
ffffffffc02034c8:	f45e                	sd	s7,40(sp)
ffffffffc02034ca:	f062                	sd	s8,32(sp)
ffffffffc02034cc:	ec66                	sd	s9,24(sp)
ffffffffc02034ce:	e86a                	sd	s10,16(sp)
ffffffffc02034d0:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02034d2:	03479713          	slli	a4,a5,0x34
ffffffffc02034d6:	20071f63          	bnez	a4,ffffffffc02036f4 <copy_range+0x242>
    assert(USER_ACCESS(start, end));
ffffffffc02034da:	002007b7          	lui	a5,0x200
ffffffffc02034de:	00d63733          	sltu	a4,a2,a3
ffffffffc02034e2:	00f637b3          	sltu	a5,a2,a5
ffffffffc02034e6:	00173713          	seqz	a4,a4
ffffffffc02034ea:	8fd9                	or	a5,a5,a4
ffffffffc02034ec:	8432                	mv	s0,a2
ffffffffc02034ee:	8936                	mv	s2,a3
ffffffffc02034f0:	1e079263          	bnez	a5,ffffffffc02036d4 <copy_range+0x222>
ffffffffc02034f4:	4785                	li	a5,1
ffffffffc02034f6:	07fe                	slli	a5,a5,0x1f
ffffffffc02034f8:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc02034fa:	1cf6fd63          	bgeu	a3,a5,ffffffffc02036d4 <copy_range+0x222>
ffffffffc02034fe:	5b7d                	li	s6,-1
ffffffffc0203500:	8baa                	mv	s7,a0
ffffffffc0203502:	8a2e                	mv	s4,a1
ffffffffc0203504:	6a85                	lui	s5,0x1
ffffffffc0203506:	00cb5b13          	srli	s6,s6,0xc
    if (PPN(pa) >= npage)
ffffffffc020350a:	00098c97          	auipc	s9,0x98
ffffffffc020350e:	7bec8c93          	addi	s9,s9,1982 # ffffffffc029bcc8 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203512:	00098c17          	auipc	s8,0x98
ffffffffc0203516:	7bec0c13          	addi	s8,s8,1982 # ffffffffc029bcd0 <pages>
ffffffffc020351a:	fff80d37          	lui	s10,0xfff80
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc020351e:	4601                	li	a2,0
ffffffffc0203520:	85a2                	mv	a1,s0
ffffffffc0203522:	8552                	mv	a0,s4
ffffffffc0203524:	b19fe0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0203528:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020352a:	0e050a63          	beqz	a0,ffffffffc020361e <copy_range+0x16c>
        if (*ptep & PTE_V)
ffffffffc020352e:	611c                	ld	a5,0(a0)
ffffffffc0203530:	8b85                	andi	a5,a5,1
ffffffffc0203532:	e78d                	bnez	a5,ffffffffc020355c <copy_range+0xaa>
        start += PGSIZE;
ffffffffc0203534:	9456                	add	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0203536:	c019                	beqz	s0,ffffffffc020353c <copy_range+0x8a>
ffffffffc0203538:	ff2463e3          	bltu	s0,s2,ffffffffc020351e <copy_range+0x6c>
    return 0;
ffffffffc020353c:	4501                	li	a0,0
}
ffffffffc020353e:	70a6                	ld	ra,104(sp)
ffffffffc0203540:	7406                	ld	s0,96(sp)
ffffffffc0203542:	64e6                	ld	s1,88(sp)
ffffffffc0203544:	6946                	ld	s2,80(sp)
ffffffffc0203546:	69a6                	ld	s3,72(sp)
ffffffffc0203548:	6a06                	ld	s4,64(sp)
ffffffffc020354a:	7ae2                	ld	s5,56(sp)
ffffffffc020354c:	7b42                	ld	s6,48(sp)
ffffffffc020354e:	7ba2                	ld	s7,40(sp)
ffffffffc0203550:	7c02                	ld	s8,32(sp)
ffffffffc0203552:	6ce2                	ld	s9,24(sp)
ffffffffc0203554:	6d42                	ld	s10,16(sp)
ffffffffc0203556:	6da2                	ld	s11,8(sp)
ffffffffc0203558:	6165                	addi	sp,sp,112
ffffffffc020355a:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020355c:	4605                	li	a2,1
ffffffffc020355e:	85a2                	mv	a1,s0
ffffffffc0203560:	855e                	mv	a0,s7
ffffffffc0203562:	adbfe0ef          	jal	ffffffffc020203c <get_pte>
ffffffffc0203566:	c165                	beqz	a0,ffffffffc0203646 <copy_range+0x194>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203568:	0004b983          	ld	s3,0(s1)
    if (!(pte & PTE_V))
ffffffffc020356c:	0019f793          	andi	a5,s3,1
ffffffffc0203570:	14078663          	beqz	a5,ffffffffc02036bc <copy_range+0x20a>
    if (PPN(pa) >= npage)
ffffffffc0203574:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203578:	00299793          	slli	a5,s3,0x2
ffffffffc020357c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020357e:	12e7f363          	bgeu	a5,a4,ffffffffc02036a4 <copy_range+0x1f2>
    return &pages[PPN(pa) - nbase];
ffffffffc0203582:	000c3483          	ld	s1,0(s8)
ffffffffc0203586:	97ea                	add	a5,a5,s10
ffffffffc0203588:	079a                	slli	a5,a5,0x6
ffffffffc020358a:	94be                	add	s1,s1,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020358c:	100027f3          	csrr	a5,sstatus
ffffffffc0203590:	8b89                	andi	a5,a5,2
ffffffffc0203592:	efc9                	bnez	a5,ffffffffc020362c <copy_range+0x17a>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203594:	00098797          	auipc	a5,0x98
ffffffffc0203598:	7147b783          	ld	a5,1812(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc020359c:	4505                	li	a0,1
ffffffffc020359e:	6f9c                	ld	a5,24(a5)
ffffffffc02035a0:	9782                	jalr	a5
ffffffffc02035a2:	8daa                	mv	s11,a0
            assert(page != NULL);
ffffffffc02035a4:	c0e5                	beqz	s1,ffffffffc0203684 <copy_range+0x1d2>
            assert(npage != NULL);
ffffffffc02035a6:	0a0d8f63          	beqz	s11,ffffffffc0203664 <copy_range+0x1b2>
    return page - pages + nbase;
ffffffffc02035aa:	000c3783          	ld	a5,0(s8)
ffffffffc02035ae:	00080637          	lui	a2,0x80
    return KADDR(page2pa(page));
ffffffffc02035b2:	000cb703          	ld	a4,0(s9)
    return page - pages + nbase;
ffffffffc02035b6:	40f486b3          	sub	a3,s1,a5
ffffffffc02035ba:	8699                	srai	a3,a3,0x6
ffffffffc02035bc:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02035be:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02035c2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02035c4:	08e5f463          	bgeu	a1,a4,ffffffffc020364c <copy_range+0x19a>
    return page - pages + nbase;
ffffffffc02035c8:	40fd87b3          	sub	a5,s11,a5
ffffffffc02035cc:	8799                	srai	a5,a5,0x6
ffffffffc02035ce:	97b2                	add	a5,a5,a2
    return KADDR(page2pa(page));
ffffffffc02035d0:	0167f633          	and	a2,a5,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02035d4:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02035d6:	06e67a63          	bgeu	a2,a4,ffffffffc020364a <copy_range+0x198>
ffffffffc02035da:	00098517          	auipc	a0,0x98
ffffffffc02035de:	6e653503          	ld	a0,1766(a0) # ffffffffc029bcc0 <va_pa_offset>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc02035e2:	6605                	lui	a2,0x1
ffffffffc02035e4:	00a685b3          	add	a1,a3,a0
ffffffffc02035e8:	953e                	add	a0,a0,a5
ffffffffc02035ea:	2ac020ef          	jal	ffffffffc0205896 <memcpy>
            int ret = page_insert(to, npage, start, perm);
ffffffffc02035ee:	01f9f693          	andi	a3,s3,31
ffffffffc02035f2:	85ee                	mv	a1,s11
ffffffffc02035f4:	8622                	mv	a2,s0
ffffffffc02035f6:	855e                	mv	a0,s7
ffffffffc02035f8:	97aff0ef          	jal	ffffffffc0202772 <page_insert>
            assert(ret == 0);
ffffffffc02035fc:	dd05                	beqz	a0,ffffffffc0203534 <copy_range+0x82>
ffffffffc02035fe:	00003697          	auipc	a3,0x3
ffffffffc0203602:	7ba68693          	addi	a3,a3,1978 # ffffffffc0206db8 <etext+0x150a>
ffffffffc0203606:	00003617          	auipc	a2,0x3
ffffffffc020360a:	cda60613          	addi	a2,a2,-806 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020360e:	19800593          	li	a1,408
ffffffffc0203612:	00003517          	auipc	a0,0x3
ffffffffc0203616:	16e50513          	addi	a0,a0,366 # ffffffffc0206780 <etext+0xed2>
ffffffffc020361a:	e2dfc0ef          	jal	ffffffffc0200446 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020361e:	002007b7          	lui	a5,0x200
ffffffffc0203622:	97a2                	add	a5,a5,s0
ffffffffc0203624:	ffe00437          	lui	s0,0xffe00
ffffffffc0203628:	8c7d                	and	s0,s0,a5
            continue;
ffffffffc020362a:	b731                	j	ffffffffc0203536 <copy_range+0x84>
        intr_disable();
ffffffffc020362c:	ad8fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203630:	00098797          	auipc	a5,0x98
ffffffffc0203634:	6787b783          	ld	a5,1656(a5) # ffffffffc029bca8 <pmm_manager>
ffffffffc0203638:	4505                	li	a0,1
ffffffffc020363a:	6f9c                	ld	a5,24(a5)
ffffffffc020363c:	9782                	jalr	a5
ffffffffc020363e:	8daa                	mv	s11,a0
        intr_enable();
ffffffffc0203640:	abefd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0203644:	b785                	j	ffffffffc02035a4 <copy_range+0xf2>
                return -E_NO_MEM;
ffffffffc0203646:	5571                	li	a0,-4
ffffffffc0203648:	bddd                	j	ffffffffc020353e <copy_range+0x8c>
ffffffffc020364a:	86be                	mv	a3,a5
ffffffffc020364c:	00003617          	auipc	a2,0x3
ffffffffc0203650:	04460613          	addi	a2,a2,68 # ffffffffc0206690 <etext+0xde2>
ffffffffc0203654:	07100593          	li	a1,113
ffffffffc0203658:	00003517          	auipc	a0,0x3
ffffffffc020365c:	06050513          	addi	a0,a0,96 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0203660:	de7fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(npage != NULL);
ffffffffc0203664:	00003697          	auipc	a3,0x3
ffffffffc0203668:	74468693          	addi	a3,a3,1860 # ffffffffc0206da8 <etext+0x14fa>
ffffffffc020366c:	00003617          	auipc	a2,0x3
ffffffffc0203670:	c7460613          	addi	a2,a2,-908 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203674:	19300593          	li	a1,403
ffffffffc0203678:	00003517          	auipc	a0,0x3
ffffffffc020367c:	10850513          	addi	a0,a0,264 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203680:	dc7fc0ef          	jal	ffffffffc0200446 <__panic>
            assert(page != NULL);
ffffffffc0203684:	00003697          	auipc	a3,0x3
ffffffffc0203688:	71468693          	addi	a3,a3,1812 # ffffffffc0206d98 <etext+0x14ea>
ffffffffc020368c:	00003617          	auipc	a2,0x3
ffffffffc0203690:	c5460613          	addi	a2,a2,-940 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203694:	19200593          	li	a1,402
ffffffffc0203698:	00003517          	auipc	a0,0x3
ffffffffc020369c:	0e850513          	addi	a0,a0,232 # ffffffffc0206780 <etext+0xed2>
ffffffffc02036a0:	da7fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02036a4:	00003617          	auipc	a2,0x3
ffffffffc02036a8:	0bc60613          	addi	a2,a2,188 # ffffffffc0206760 <etext+0xeb2>
ffffffffc02036ac:	06900593          	li	a1,105
ffffffffc02036b0:	00003517          	auipc	a0,0x3
ffffffffc02036b4:	00850513          	addi	a0,a0,8 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc02036b8:	d8ffc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02036bc:	00003617          	auipc	a2,0x3
ffffffffc02036c0:	2bc60613          	addi	a2,a2,700 # ffffffffc0206978 <etext+0x10ca>
ffffffffc02036c4:	07f00593          	li	a1,127
ffffffffc02036c8:	00003517          	auipc	a0,0x3
ffffffffc02036cc:	ff050513          	addi	a0,a0,-16 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc02036d0:	d77fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02036d4:	00003697          	auipc	a3,0x3
ffffffffc02036d8:	0ec68693          	addi	a3,a3,236 # ffffffffc02067c0 <etext+0xf12>
ffffffffc02036dc:	00003617          	auipc	a2,0x3
ffffffffc02036e0:	c0460613          	addi	a2,a2,-1020 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02036e4:	17c00593          	li	a1,380
ffffffffc02036e8:	00003517          	auipc	a0,0x3
ffffffffc02036ec:	09850513          	addi	a0,a0,152 # ffffffffc0206780 <etext+0xed2>
ffffffffc02036f0:	d57fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02036f4:	00003697          	auipc	a3,0x3
ffffffffc02036f8:	09c68693          	addi	a3,a3,156 # ffffffffc0206790 <etext+0xee2>
ffffffffc02036fc:	00003617          	auipc	a2,0x3
ffffffffc0203700:	be460613          	addi	a2,a2,-1052 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203704:	17b00593          	li	a1,379
ffffffffc0203708:	00003517          	auipc	a0,0x3
ffffffffc020370c:	07850513          	addi	a0,a0,120 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203710:	d37fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203714 <pgdir_alloc_page>:
{
ffffffffc0203714:	7139                	addi	sp,sp,-64
ffffffffc0203716:	f426                	sd	s1,40(sp)
ffffffffc0203718:	f04a                	sd	s2,32(sp)
ffffffffc020371a:	ec4e                	sd	s3,24(sp)
ffffffffc020371c:	fc06                	sd	ra,56(sp)
ffffffffc020371e:	f822                	sd	s0,48(sp)
ffffffffc0203720:	892a                	mv	s2,a0
ffffffffc0203722:	84ae                	mv	s1,a1
ffffffffc0203724:	89b2                	mv	s3,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203726:	100027f3          	csrr	a5,sstatus
ffffffffc020372a:	8b89                	andi	a5,a5,2
ffffffffc020372c:	ebb5                	bnez	a5,ffffffffc02037a0 <pgdir_alloc_page+0x8c>
        page = pmm_manager->alloc_pages(n);
ffffffffc020372e:	00098417          	auipc	s0,0x98
ffffffffc0203732:	57a40413          	addi	s0,s0,1402 # ffffffffc029bca8 <pmm_manager>
ffffffffc0203736:	601c                	ld	a5,0(s0)
ffffffffc0203738:	4505                	li	a0,1
ffffffffc020373a:	6f9c                	ld	a5,24(a5)
ffffffffc020373c:	9782                	jalr	a5
ffffffffc020373e:	85aa                	mv	a1,a0
    if (page != NULL)
ffffffffc0203740:	c5b9                	beqz	a1,ffffffffc020378e <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203742:	86ce                	mv	a3,s3
ffffffffc0203744:	854a                	mv	a0,s2
ffffffffc0203746:	8626                	mv	a2,s1
ffffffffc0203748:	e42e                	sd	a1,8(sp)
ffffffffc020374a:	828ff0ef          	jal	ffffffffc0202772 <page_insert>
ffffffffc020374e:	65a2                	ld	a1,8(sp)
ffffffffc0203750:	e515                	bnez	a0,ffffffffc020377c <pgdir_alloc_page+0x68>
        assert(page_ref(page) == 1);
ffffffffc0203752:	4198                	lw	a4,0(a1)
        page->pra_vaddr = la;
ffffffffc0203754:	fd84                	sd	s1,56(a1)
        assert(page_ref(page) == 1);
ffffffffc0203756:	4785                	li	a5,1
ffffffffc0203758:	02f70c63          	beq	a4,a5,ffffffffc0203790 <pgdir_alloc_page+0x7c>
ffffffffc020375c:	00003697          	auipc	a3,0x3
ffffffffc0203760:	66c68693          	addi	a3,a3,1644 # ffffffffc0206dc8 <etext+0x151a>
ffffffffc0203764:	00003617          	auipc	a2,0x3
ffffffffc0203768:	b7c60613          	addi	a2,a2,-1156 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020376c:	1e100593          	li	a1,481
ffffffffc0203770:	00003517          	auipc	a0,0x3
ffffffffc0203774:	01050513          	addi	a0,a0,16 # ffffffffc0206780 <etext+0xed2>
ffffffffc0203778:	ccffc0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc020377c:	100027f3          	csrr	a5,sstatus
ffffffffc0203780:	8b89                	andi	a5,a5,2
ffffffffc0203782:	ef95                	bnez	a5,ffffffffc02037be <pgdir_alloc_page+0xaa>
        pmm_manager->free_pages(base, n);
ffffffffc0203784:	601c                	ld	a5,0(s0)
ffffffffc0203786:	852e                	mv	a0,a1
ffffffffc0203788:	4585                	li	a1,1
ffffffffc020378a:	739c                	ld	a5,32(a5)
ffffffffc020378c:	9782                	jalr	a5
            return NULL;
ffffffffc020378e:	4581                	li	a1,0
}
ffffffffc0203790:	70e2                	ld	ra,56(sp)
ffffffffc0203792:	7442                	ld	s0,48(sp)
ffffffffc0203794:	74a2                	ld	s1,40(sp)
ffffffffc0203796:	7902                	ld	s2,32(sp)
ffffffffc0203798:	69e2                	ld	s3,24(sp)
ffffffffc020379a:	852e                	mv	a0,a1
ffffffffc020379c:	6121                	addi	sp,sp,64
ffffffffc020379e:	8082                	ret
        intr_disable();
ffffffffc02037a0:	964fd0ef          	jal	ffffffffc0200904 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02037a4:	00098417          	auipc	s0,0x98
ffffffffc02037a8:	50440413          	addi	s0,s0,1284 # ffffffffc029bca8 <pmm_manager>
ffffffffc02037ac:	601c                	ld	a5,0(s0)
ffffffffc02037ae:	4505                	li	a0,1
ffffffffc02037b0:	6f9c                	ld	a5,24(a5)
ffffffffc02037b2:	9782                	jalr	a5
ffffffffc02037b4:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02037b6:	948fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02037ba:	65a2                	ld	a1,8(sp)
ffffffffc02037bc:	b751                	j	ffffffffc0203740 <pgdir_alloc_page+0x2c>
        intr_disable();
ffffffffc02037be:	946fd0ef          	jal	ffffffffc0200904 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02037c2:	601c                	ld	a5,0(s0)
ffffffffc02037c4:	6522                	ld	a0,8(sp)
ffffffffc02037c6:	4585                	li	a1,1
ffffffffc02037c8:	739c                	ld	a5,32(a5)
ffffffffc02037ca:	9782                	jalr	a5
        intr_enable();
ffffffffc02037cc:	932fd0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02037d0:	bf7d                	j	ffffffffc020378e <pgdir_alloc_page+0x7a>

ffffffffc02037d2 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02037d2:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02037d4:	00003697          	auipc	a3,0x3
ffffffffc02037d8:	60c68693          	addi	a3,a3,1548 # ffffffffc0206de0 <etext+0x1532>
ffffffffc02037dc:	00003617          	auipc	a2,0x3
ffffffffc02037e0:	b0460613          	addi	a2,a2,-1276 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02037e4:	07400593          	li	a1,116
ffffffffc02037e8:	00003517          	auipc	a0,0x3
ffffffffc02037ec:	61850513          	addi	a0,a0,1560 # ffffffffc0206e00 <etext+0x1552>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02037f0:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02037f2:	c55fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02037f6 <mm_create>:
{
ffffffffc02037f6:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02037f8:	04000513          	li	a0,64
{
ffffffffc02037fc:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02037fe:	dd2fe0ef          	jal	ffffffffc0201dd0 <kmalloc>
    if (mm != NULL)
ffffffffc0203802:	cd19                	beqz	a0,ffffffffc0203820 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203804:	e508                	sd	a0,8(a0)
ffffffffc0203806:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203808:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020380c:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203810:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203814:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203818:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc020381c:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203820:	60a2                	ld	ra,8(sp)
ffffffffc0203822:	0141                	addi	sp,sp,16
ffffffffc0203824:	8082                	ret

ffffffffc0203826 <find_vma>:
    if (mm != NULL)
ffffffffc0203826:	c505                	beqz	a0,ffffffffc020384e <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc0203828:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020382a:	c781                	beqz	a5,ffffffffc0203832 <find_vma+0xc>
ffffffffc020382c:	6798                	ld	a4,8(a5)
ffffffffc020382e:	02e5f363          	bgeu	a1,a4,ffffffffc0203854 <find_vma+0x2e>
    return listelm->next;
ffffffffc0203832:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc0203834:	00f50d63          	beq	a0,a5,ffffffffc020384e <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203838:	fe87b703          	ld	a4,-24(a5)
ffffffffc020383c:	00e5e663          	bltu	a1,a4,ffffffffc0203848 <find_vma+0x22>
ffffffffc0203840:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203844:	00e5ee63          	bltu	a1,a4,ffffffffc0203860 <find_vma+0x3a>
ffffffffc0203848:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020384a:	fef517e3          	bne	a0,a5,ffffffffc0203838 <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc020384e:	4781                	li	a5,0
}
ffffffffc0203850:	853e                	mv	a0,a5
ffffffffc0203852:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203854:	6b98                	ld	a4,16(a5)
ffffffffc0203856:	fce5fee3          	bgeu	a1,a4,ffffffffc0203832 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc020385a:	e91c                	sd	a5,16(a0)
}
ffffffffc020385c:	853e                	mv	a0,a5
ffffffffc020385e:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203860:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203862:	e91c                	sd	a5,16(a0)
ffffffffc0203864:	bfe5                	j	ffffffffc020385c <find_vma+0x36>

ffffffffc0203866 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203866:	6590                	ld	a2,8(a1)
ffffffffc0203868:	0105b803          	ld	a6,16(a1)
{
ffffffffc020386c:	1141                	addi	sp,sp,-16
ffffffffc020386e:	e406                	sd	ra,8(sp)
ffffffffc0203870:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203872:	01066763          	bltu	a2,a6,ffffffffc0203880 <insert_vma_struct+0x1a>
ffffffffc0203876:	a8b9                	j	ffffffffc02038d4 <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203878:	fe87b703          	ld	a4,-24(a5)
ffffffffc020387c:	04e66763          	bltu	a2,a4,ffffffffc02038ca <insert_vma_struct+0x64>
ffffffffc0203880:	86be                	mv	a3,a5
ffffffffc0203882:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203884:	fef51ae3          	bne	a0,a5,ffffffffc0203878 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203888:	02a68463          	beq	a3,a0,ffffffffc02038b0 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020388c:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203890:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203894:	08e8f063          	bgeu	a7,a4,ffffffffc0203914 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203898:	04e66e63          	bltu	a2,a4,ffffffffc02038f4 <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc020389c:	00f50a63          	beq	a0,a5,ffffffffc02038b0 <insert_vma_struct+0x4a>
ffffffffc02038a0:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02038a4:	05076863          	bltu	a4,a6,ffffffffc02038f4 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc02038a8:	ff07b603          	ld	a2,-16(a5)
ffffffffc02038ac:	02c77263          	bgeu	a4,a2,ffffffffc02038d0 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02038b0:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02038b2:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02038b4:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02038b8:	e390                	sd	a2,0(a5)
ffffffffc02038ba:	e690                	sd	a2,8(a3)
}
ffffffffc02038bc:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02038be:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02038c0:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02038c2:	2705                	addiw	a4,a4,1
ffffffffc02038c4:	d118                	sw	a4,32(a0)
}
ffffffffc02038c6:	0141                	addi	sp,sp,16
ffffffffc02038c8:	8082                	ret
    if (le_prev != list)
ffffffffc02038ca:	fca691e3          	bne	a3,a0,ffffffffc020388c <insert_vma_struct+0x26>
ffffffffc02038ce:	bfd9                	j	ffffffffc02038a4 <insert_vma_struct+0x3e>
ffffffffc02038d0:	f03ff0ef          	jal	ffffffffc02037d2 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02038d4:	00003697          	auipc	a3,0x3
ffffffffc02038d8:	53c68693          	addi	a3,a3,1340 # ffffffffc0206e10 <etext+0x1562>
ffffffffc02038dc:	00003617          	auipc	a2,0x3
ffffffffc02038e0:	a0460613          	addi	a2,a2,-1532 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02038e4:	07a00593          	li	a1,122
ffffffffc02038e8:	00003517          	auipc	a0,0x3
ffffffffc02038ec:	51850513          	addi	a0,a0,1304 # ffffffffc0206e00 <etext+0x1552>
ffffffffc02038f0:	b57fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02038f4:	00003697          	auipc	a3,0x3
ffffffffc02038f8:	55c68693          	addi	a3,a3,1372 # ffffffffc0206e50 <etext+0x15a2>
ffffffffc02038fc:	00003617          	auipc	a2,0x3
ffffffffc0203900:	9e460613          	addi	a2,a2,-1564 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203904:	07300593          	li	a1,115
ffffffffc0203908:	00003517          	auipc	a0,0x3
ffffffffc020390c:	4f850513          	addi	a0,a0,1272 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203910:	b37fc0ef          	jal	ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203914:	00003697          	auipc	a3,0x3
ffffffffc0203918:	51c68693          	addi	a3,a3,1308 # ffffffffc0206e30 <etext+0x1582>
ffffffffc020391c:	00003617          	auipc	a2,0x3
ffffffffc0203920:	9c460613          	addi	a2,a2,-1596 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203924:	07200593          	li	a1,114
ffffffffc0203928:	00003517          	auipc	a0,0x3
ffffffffc020392c:	4d850513          	addi	a0,a0,1240 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203930:	b17fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203934 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203934:	591c                	lw	a5,48(a0)
{
ffffffffc0203936:	1141                	addi	sp,sp,-16
ffffffffc0203938:	e406                	sd	ra,8(sp)
ffffffffc020393a:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc020393c:	e78d                	bnez	a5,ffffffffc0203966 <mm_destroy+0x32>
ffffffffc020393e:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203940:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203942:	00a40c63          	beq	s0,a0,ffffffffc020395a <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203946:	6118                	ld	a4,0(a0)
ffffffffc0203948:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020394a:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc020394c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020394e:	e398                	sd	a4,0(a5)
ffffffffc0203950:	d26fe0ef          	jal	ffffffffc0201e76 <kfree>
    return listelm->next;
ffffffffc0203954:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203956:	fea418e3          	bne	s0,a0,ffffffffc0203946 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc020395a:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc020395c:	6402                	ld	s0,0(sp)
ffffffffc020395e:	60a2                	ld	ra,8(sp)
ffffffffc0203960:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203962:	d14fe06f          	j	ffffffffc0201e76 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203966:	00003697          	auipc	a3,0x3
ffffffffc020396a:	50a68693          	addi	a3,a3,1290 # ffffffffc0206e70 <etext+0x15c2>
ffffffffc020396e:	00003617          	auipc	a2,0x3
ffffffffc0203972:	97260613          	addi	a2,a2,-1678 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203976:	09e00593          	li	a1,158
ffffffffc020397a:	00003517          	auipc	a0,0x3
ffffffffc020397e:	48650513          	addi	a0,a0,1158 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203982:	ac5fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203986 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203986:	6785                	lui	a5,0x1
ffffffffc0203988:	17fd                	addi	a5,a5,-1 # fff <_binary_obj___user_softint_out_size-0x7bb1>
ffffffffc020398a:	963e                	add	a2,a2,a5
    if (!USER_ACCESS(start, end))
ffffffffc020398c:	4785                	li	a5,1
{
ffffffffc020398e:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203990:	962e                	add	a2,a2,a1
ffffffffc0203992:	787d                	lui	a6,0xfffff
    if (!USER_ACCESS(start, end))
ffffffffc0203994:	07fe                	slli	a5,a5,0x1f
{
ffffffffc0203996:	f822                	sd	s0,48(sp)
ffffffffc0203998:	f426                	sd	s1,40(sp)
ffffffffc020399a:	01067433          	and	s0,a2,a6
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020399e:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end))
ffffffffc02039a2:	0785                	addi	a5,a5,1
ffffffffc02039a4:	0084b633          	sltu	a2,s1,s0
ffffffffc02039a8:	00f437b3          	sltu	a5,s0,a5
ffffffffc02039ac:	00163613          	seqz	a2,a2
ffffffffc02039b0:	0017b793          	seqz	a5,a5
{
ffffffffc02039b4:	fc06                	sd	ra,56(sp)
    if (!USER_ACCESS(start, end))
ffffffffc02039b6:	8fd1                	or	a5,a5,a2
ffffffffc02039b8:	ebbd                	bnez	a5,ffffffffc0203a2e <mm_map+0xa8>
ffffffffc02039ba:	002007b7          	lui	a5,0x200
ffffffffc02039be:	06f4e863          	bltu	s1,a5,ffffffffc0203a2e <mm_map+0xa8>
ffffffffc02039c2:	f04a                	sd	s2,32(sp)
ffffffffc02039c4:	ec4e                	sd	s3,24(sp)
ffffffffc02039c6:	e852                	sd	s4,16(sp)
ffffffffc02039c8:	892a                	mv	s2,a0
ffffffffc02039ca:	89ba                	mv	s3,a4
ffffffffc02039cc:	8a36                	mv	s4,a3
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02039ce:	c135                	beqz	a0,ffffffffc0203a32 <mm_map+0xac>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02039d0:	85a6                	mv	a1,s1
ffffffffc02039d2:	e55ff0ef          	jal	ffffffffc0203826 <find_vma>
ffffffffc02039d6:	c501                	beqz	a0,ffffffffc02039de <mm_map+0x58>
ffffffffc02039d8:	651c                	ld	a5,8(a0)
ffffffffc02039da:	0487e763          	bltu	a5,s0,ffffffffc0203a28 <mm_map+0xa2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02039de:	03000513          	li	a0,48
ffffffffc02039e2:	beefe0ef          	jal	ffffffffc0201dd0 <kmalloc>
ffffffffc02039e6:	85aa                	mv	a1,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02039e8:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02039ea:	c59d                	beqz	a1,ffffffffc0203a18 <mm_map+0x92>
        vma->vm_start = vm_start;
ffffffffc02039ec:	e584                	sd	s1,8(a1)
        vma->vm_end = vm_end;
ffffffffc02039ee:	e980                	sd	s0,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc02039f0:	0145ac23          	sw	s4,24(a1)

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02039f4:	854a                	mv	a0,s2
ffffffffc02039f6:	e42e                	sd	a1,8(sp)
ffffffffc02039f8:	e6fff0ef          	jal	ffffffffc0203866 <insert_vma_struct>
    if (vma_store != NULL)
ffffffffc02039fc:	65a2                	ld	a1,8(sp)
ffffffffc02039fe:	00098463          	beqz	s3,ffffffffc0203a06 <mm_map+0x80>
    {
        *vma_store = vma;
ffffffffc0203a02:	00b9b023          	sd	a1,0(s3)
ffffffffc0203a06:	7902                	ld	s2,32(sp)
ffffffffc0203a08:	69e2                	ld	s3,24(sp)
ffffffffc0203a0a:	6a42                	ld	s4,16(sp)
    }
    ret = 0;
ffffffffc0203a0c:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0203a0e:	70e2                	ld	ra,56(sp)
ffffffffc0203a10:	7442                	ld	s0,48(sp)
ffffffffc0203a12:	74a2                	ld	s1,40(sp)
ffffffffc0203a14:	6121                	addi	sp,sp,64
ffffffffc0203a16:	8082                	ret
ffffffffc0203a18:	70e2                	ld	ra,56(sp)
ffffffffc0203a1a:	7442                	ld	s0,48(sp)
ffffffffc0203a1c:	7902                	ld	s2,32(sp)
ffffffffc0203a1e:	69e2                	ld	s3,24(sp)
ffffffffc0203a20:	6a42                	ld	s4,16(sp)
ffffffffc0203a22:	74a2                	ld	s1,40(sp)
ffffffffc0203a24:	6121                	addi	sp,sp,64
ffffffffc0203a26:	8082                	ret
ffffffffc0203a28:	7902                	ld	s2,32(sp)
ffffffffc0203a2a:	69e2                	ld	s3,24(sp)
ffffffffc0203a2c:	6a42                	ld	s4,16(sp)
        return -E_INVAL;
ffffffffc0203a2e:	5575                	li	a0,-3
ffffffffc0203a30:	bff9                	j	ffffffffc0203a0e <mm_map+0x88>
    assert(mm != NULL);
ffffffffc0203a32:	00003697          	auipc	a3,0x3
ffffffffc0203a36:	45668693          	addi	a3,a3,1110 # ffffffffc0206e88 <etext+0x15da>
ffffffffc0203a3a:	00003617          	auipc	a2,0x3
ffffffffc0203a3e:	8a660613          	addi	a2,a2,-1882 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203a42:	0b300593          	li	a1,179
ffffffffc0203a46:	00003517          	auipc	a0,0x3
ffffffffc0203a4a:	3ba50513          	addi	a0,a0,954 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203a4e:	9f9fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203a52 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203a52:	7139                	addi	sp,sp,-64
ffffffffc0203a54:	fc06                	sd	ra,56(sp)
ffffffffc0203a56:	f822                	sd	s0,48(sp)
ffffffffc0203a58:	f426                	sd	s1,40(sp)
ffffffffc0203a5a:	f04a                	sd	s2,32(sp)
ffffffffc0203a5c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a5e:	e852                	sd	s4,16(sp)
ffffffffc0203a60:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203a62:	c525                	beqz	a0,ffffffffc0203aca <dup_mmap+0x78>
ffffffffc0203a64:	892a                	mv	s2,a0
ffffffffc0203a66:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203a68:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203a6a:	c1a5                	beqz	a1,ffffffffc0203aca <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0203a6c:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203a6e:	04848c63          	beq	s1,s0,ffffffffc0203ac6 <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a72:	03000513          	li	a0,48
    {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203a76:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203a7a:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203a7e:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a82:	b4efe0ef          	jal	ffffffffc0201dd0 <kmalloc>
    if (vma != NULL)
ffffffffc0203a86:	c515                	beqz	a0,ffffffffc0203ab2 <dup_mmap+0x60>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203a88:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0203a8a:	01553423          	sd	s5,8(a0)
ffffffffc0203a8e:	01453823          	sd	s4,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a92:	01352c23          	sw	s3,24(a0)
        insert_vma_struct(to, nvma);
ffffffffc0203a96:	854a                	mv	a0,s2
ffffffffc0203a98:	dcfff0ef          	jal	ffffffffc0203866 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203a9c:	ff043683          	ld	a3,-16(s0)
ffffffffc0203aa0:	fe843603          	ld	a2,-24(s0)
ffffffffc0203aa4:	6c8c                	ld	a1,24(s1)
ffffffffc0203aa6:	01893503          	ld	a0,24(s2)
ffffffffc0203aaa:	4701                	li	a4,0
ffffffffc0203aac:	a07ff0ef          	jal	ffffffffc02034b2 <copy_range>
ffffffffc0203ab0:	dd55                	beqz	a0,ffffffffc0203a6c <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0203ab2:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203ab4:	70e2                	ld	ra,56(sp)
ffffffffc0203ab6:	7442                	ld	s0,48(sp)
ffffffffc0203ab8:	74a2                	ld	s1,40(sp)
ffffffffc0203aba:	7902                	ld	s2,32(sp)
ffffffffc0203abc:	69e2                	ld	s3,24(sp)
ffffffffc0203abe:	6a42                	ld	s4,16(sp)
ffffffffc0203ac0:	6aa2                	ld	s5,8(sp)
ffffffffc0203ac2:	6121                	addi	sp,sp,64
ffffffffc0203ac4:	8082                	ret
    return 0;
ffffffffc0203ac6:	4501                	li	a0,0
ffffffffc0203ac8:	b7f5                	j	ffffffffc0203ab4 <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0203aca:	00003697          	auipc	a3,0x3
ffffffffc0203ace:	3ce68693          	addi	a3,a3,974 # ffffffffc0206e98 <etext+0x15ea>
ffffffffc0203ad2:	00003617          	auipc	a2,0x3
ffffffffc0203ad6:	80e60613          	addi	a2,a2,-2034 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203ada:	0cf00593          	li	a1,207
ffffffffc0203ade:	00003517          	auipc	a0,0x3
ffffffffc0203ae2:	32250513          	addi	a0,a0,802 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203ae6:	961fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203aea <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203aea:	1101                	addi	sp,sp,-32
ffffffffc0203aec:	ec06                	sd	ra,24(sp)
ffffffffc0203aee:	e822                	sd	s0,16(sp)
ffffffffc0203af0:	e426                	sd	s1,8(sp)
ffffffffc0203af2:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203af4:	c531                	beqz	a0,ffffffffc0203b40 <exit_mmap+0x56>
ffffffffc0203af6:	591c                	lw	a5,48(a0)
ffffffffc0203af8:	84aa                	mv	s1,a0
ffffffffc0203afa:	e3b9                	bnez	a5,ffffffffc0203b40 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203afc:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203afe:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203b02:	02850663          	beq	a0,s0,ffffffffc0203b2e <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203b06:	ff043603          	ld	a2,-16(s0)
ffffffffc0203b0a:	fe843583          	ld	a1,-24(s0)
ffffffffc0203b0e:	854a                	mv	a0,s2
ffffffffc0203b10:	fdefe0ef          	jal	ffffffffc02022ee <unmap_range>
ffffffffc0203b14:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203b16:	fe8498e3          	bne	s1,s0,ffffffffc0203b06 <exit_mmap+0x1c>
ffffffffc0203b1a:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203b1c:	00848c63          	beq	s1,s0,ffffffffc0203b34 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203b20:	ff043603          	ld	a2,-16(s0)
ffffffffc0203b24:	fe843583          	ld	a1,-24(s0)
ffffffffc0203b28:	854a                	mv	a0,s2
ffffffffc0203b2a:	8f9fe0ef          	jal	ffffffffc0202422 <exit_range>
ffffffffc0203b2e:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203b30:	fe8498e3          	bne	s1,s0,ffffffffc0203b20 <exit_mmap+0x36>
    }
}
ffffffffc0203b34:	60e2                	ld	ra,24(sp)
ffffffffc0203b36:	6442                	ld	s0,16(sp)
ffffffffc0203b38:	64a2                	ld	s1,8(sp)
ffffffffc0203b3a:	6902                	ld	s2,0(sp)
ffffffffc0203b3c:	6105                	addi	sp,sp,32
ffffffffc0203b3e:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203b40:	00003697          	auipc	a3,0x3
ffffffffc0203b44:	37868693          	addi	a3,a3,888 # ffffffffc0206eb8 <etext+0x160a>
ffffffffc0203b48:	00002617          	auipc	a2,0x2
ffffffffc0203b4c:	79860613          	addi	a2,a2,1944 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203b50:	0e800593          	li	a1,232
ffffffffc0203b54:	00003517          	auipc	a0,0x3
ffffffffc0203b58:	2ac50513          	addi	a0,a0,684 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203b5c:	8ebfc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203b60 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203b60:	7179                	addi	sp,sp,-48
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203b62:	04000513          	li	a0,64
{
ffffffffc0203b66:	f406                	sd	ra,40(sp)
ffffffffc0203b68:	f022                	sd	s0,32(sp)
ffffffffc0203b6a:	ec26                	sd	s1,24(sp)
ffffffffc0203b6c:	e84a                	sd	s2,16(sp)
ffffffffc0203b6e:	e44e                	sd	s3,8(sp)
ffffffffc0203b70:	e052                	sd	s4,0(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203b72:	a5efe0ef          	jal	ffffffffc0201dd0 <kmalloc>
    if (mm != NULL)
ffffffffc0203b76:	16050c63          	beqz	a0,ffffffffc0203cee <vmm_init+0x18e>
ffffffffc0203b7a:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203b7c:	e508                	sd	a0,8(a0)
ffffffffc0203b7e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203b80:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203b84:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203b88:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203b8c:	02053423          	sd	zero,40(a0)
ffffffffc0203b90:	02052823          	sw	zero,48(a0)
ffffffffc0203b94:	02053c23          	sd	zero,56(a0)
ffffffffc0203b98:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b9c:	03000513          	li	a0,48
ffffffffc0203ba0:	a30fe0ef          	jal	ffffffffc0201dd0 <kmalloc>
    if (vma != NULL)
ffffffffc0203ba4:	12050563          	beqz	a0,ffffffffc0203cce <vmm_init+0x16e>
        vma->vm_end = vm_end;
ffffffffc0203ba8:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203bac:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203bae:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203bb2:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203bb4:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc0203bb6:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc0203bb8:	8522                	mv	a0,s0
ffffffffc0203bba:	cadff0ef          	jal	ffffffffc0203866 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203bbe:	fcf9                	bnez	s1,ffffffffc0203b9c <vmm_init+0x3c>
ffffffffc0203bc0:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203bc4:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203bc8:	03000513          	li	a0,48
ffffffffc0203bcc:	a04fe0ef          	jal	ffffffffc0201dd0 <kmalloc>
    if (vma != NULL)
ffffffffc0203bd0:	12050f63          	beqz	a0,ffffffffc0203d0e <vmm_init+0x1ae>
        vma->vm_end = vm_end;
ffffffffc0203bd4:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203bd8:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203bda:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203bde:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203be0:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203be2:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203be4:	8522                	mv	a0,s0
ffffffffc0203be6:	c81ff0ef          	jal	ffffffffc0203866 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203bea:	fd249fe3          	bne	s1,s2,ffffffffc0203bc8 <vmm_init+0x68>
    return listelm->next;
ffffffffc0203bee:	641c                	ld	a5,8(s0)
ffffffffc0203bf0:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203bf2:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203bf6:	1ef40c63          	beq	s0,a5,ffffffffc0203dee <vmm_init+0x28e>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203bfa:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f5e30>
ffffffffc0203bfe:	ffe70693          	addi	a3,a4,-2
ffffffffc0203c02:	12d61663          	bne	a2,a3,ffffffffc0203d2e <vmm_init+0x1ce>
ffffffffc0203c06:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203c0a:	12e69263          	bne	a3,a4,ffffffffc0203d2e <vmm_init+0x1ce>
    for (i = 1; i <= step2; i++)
ffffffffc0203c0e:	0715                	addi	a4,a4,5
ffffffffc0203c10:	679c                	ld	a5,8(a5)
ffffffffc0203c12:	feb712e3          	bne	a4,a1,ffffffffc0203bf6 <vmm_init+0x96>
ffffffffc0203c16:	491d                	li	s2,7
ffffffffc0203c18:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203c1a:	85a6                	mv	a1,s1
ffffffffc0203c1c:	8522                	mv	a0,s0
ffffffffc0203c1e:	c09ff0ef          	jal	ffffffffc0203826 <find_vma>
ffffffffc0203c22:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0203c24:	20050563          	beqz	a0,ffffffffc0203e2e <vmm_init+0x2ce>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203c28:	00148593          	addi	a1,s1,1
ffffffffc0203c2c:	8522                	mv	a0,s0
ffffffffc0203c2e:	bf9ff0ef          	jal	ffffffffc0203826 <find_vma>
ffffffffc0203c32:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203c34:	1c050d63          	beqz	a0,ffffffffc0203e0e <vmm_init+0x2ae>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203c38:	85ca                	mv	a1,s2
ffffffffc0203c3a:	8522                	mv	a0,s0
ffffffffc0203c3c:	bebff0ef          	jal	ffffffffc0203826 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203c40:	18051763          	bnez	a0,ffffffffc0203dce <vmm_init+0x26e>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203c44:	00348593          	addi	a1,s1,3
ffffffffc0203c48:	8522                	mv	a0,s0
ffffffffc0203c4a:	bddff0ef          	jal	ffffffffc0203826 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203c4e:	16051063          	bnez	a0,ffffffffc0203dae <vmm_init+0x24e>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203c52:	00448593          	addi	a1,s1,4
ffffffffc0203c56:	8522                	mv	a0,s0
ffffffffc0203c58:	bcfff0ef          	jal	ffffffffc0203826 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203c5c:	12051963          	bnez	a0,ffffffffc0203d8e <vmm_init+0x22e>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c60:	008a3783          	ld	a5,8(s4)
ffffffffc0203c64:	10979563          	bne	a5,s1,ffffffffc0203d6e <vmm_init+0x20e>
ffffffffc0203c68:	010a3783          	ld	a5,16(s4)
ffffffffc0203c6c:	11279163          	bne	a5,s2,ffffffffc0203d6e <vmm_init+0x20e>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c70:	0089b783          	ld	a5,8(s3)
ffffffffc0203c74:	0c979d63          	bne	a5,s1,ffffffffc0203d4e <vmm_init+0x1ee>
ffffffffc0203c78:	0109b783          	ld	a5,16(s3)
ffffffffc0203c7c:	0d279963          	bne	a5,s2,ffffffffc0203d4e <vmm_init+0x1ee>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203c80:	0495                	addi	s1,s1,5
ffffffffc0203c82:	1f900793          	li	a5,505
ffffffffc0203c86:	0915                	addi	s2,s2,5
ffffffffc0203c88:	f8f499e3          	bne	s1,a5,ffffffffc0203c1a <vmm_init+0xba>
ffffffffc0203c8c:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203c8e:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203c90:	85a6                	mv	a1,s1
ffffffffc0203c92:	8522                	mv	a0,s0
ffffffffc0203c94:	b93ff0ef          	jal	ffffffffc0203826 <find_vma>
        if (vma_below_5 != NULL)
ffffffffc0203c98:	1a051b63          	bnez	a0,ffffffffc0203e4e <vmm_init+0x2ee>
    for (i = 4; i >= 0; i--)
ffffffffc0203c9c:	14fd                	addi	s1,s1,-1
ffffffffc0203c9e:	ff2499e3          	bne	s1,s2,ffffffffc0203c90 <vmm_init+0x130>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
ffffffffc0203ca2:	8522                	mv	a0,s0
ffffffffc0203ca4:	c91ff0ef          	jal	ffffffffc0203934 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203ca8:	00003517          	auipc	a0,0x3
ffffffffc0203cac:	38050513          	addi	a0,a0,896 # ffffffffc0207028 <etext+0x177a>
ffffffffc0203cb0:	ce4fc0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0203cb4:	7402                	ld	s0,32(sp)
ffffffffc0203cb6:	70a2                	ld	ra,40(sp)
ffffffffc0203cb8:	64e2                	ld	s1,24(sp)
ffffffffc0203cba:	6942                	ld	s2,16(sp)
ffffffffc0203cbc:	69a2                	ld	s3,8(sp)
ffffffffc0203cbe:	6a02                	ld	s4,0(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203cc0:	00003517          	auipc	a0,0x3
ffffffffc0203cc4:	38850513          	addi	a0,a0,904 # ffffffffc0207048 <etext+0x179a>
}
ffffffffc0203cc8:	6145                	addi	sp,sp,48
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203cca:	ccafc06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203cce:	00003697          	auipc	a3,0x3
ffffffffc0203cd2:	20a68693          	addi	a3,a3,522 # ffffffffc0206ed8 <etext+0x162a>
ffffffffc0203cd6:	00002617          	auipc	a2,0x2
ffffffffc0203cda:	60a60613          	addi	a2,a2,1546 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203cde:	12c00593          	li	a1,300
ffffffffc0203ce2:	00003517          	auipc	a0,0x3
ffffffffc0203ce6:	11e50513          	addi	a0,a0,286 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203cea:	f5cfc0ef          	jal	ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc0203cee:	00003697          	auipc	a3,0x3
ffffffffc0203cf2:	19a68693          	addi	a3,a3,410 # ffffffffc0206e88 <etext+0x15da>
ffffffffc0203cf6:	00002617          	auipc	a2,0x2
ffffffffc0203cfa:	5ea60613          	addi	a2,a2,1514 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203cfe:	12400593          	li	a1,292
ffffffffc0203d02:	00003517          	auipc	a0,0x3
ffffffffc0203d06:	0fe50513          	addi	a0,a0,254 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203d0a:	f3cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma != NULL);
ffffffffc0203d0e:	00003697          	auipc	a3,0x3
ffffffffc0203d12:	1ca68693          	addi	a3,a3,458 # ffffffffc0206ed8 <etext+0x162a>
ffffffffc0203d16:	00002617          	auipc	a2,0x2
ffffffffc0203d1a:	5ca60613          	addi	a2,a2,1482 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203d1e:	13300593          	li	a1,307
ffffffffc0203d22:	00003517          	auipc	a0,0x3
ffffffffc0203d26:	0de50513          	addi	a0,a0,222 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203d2a:	f1cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203d2e:	00003697          	auipc	a3,0x3
ffffffffc0203d32:	1d268693          	addi	a3,a3,466 # ffffffffc0206f00 <etext+0x1652>
ffffffffc0203d36:	00002617          	auipc	a2,0x2
ffffffffc0203d3a:	5aa60613          	addi	a2,a2,1450 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203d3e:	13d00593          	li	a1,317
ffffffffc0203d42:	00003517          	auipc	a0,0x3
ffffffffc0203d46:	0be50513          	addi	a0,a0,190 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203d4a:	efcfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203d4e:	00003697          	auipc	a3,0x3
ffffffffc0203d52:	26a68693          	addi	a3,a3,618 # ffffffffc0206fb8 <etext+0x170a>
ffffffffc0203d56:	00002617          	auipc	a2,0x2
ffffffffc0203d5a:	58a60613          	addi	a2,a2,1418 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203d5e:	14f00593          	li	a1,335
ffffffffc0203d62:	00003517          	auipc	a0,0x3
ffffffffc0203d66:	09e50513          	addi	a0,a0,158 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203d6a:	edcfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203d6e:	00003697          	auipc	a3,0x3
ffffffffc0203d72:	21a68693          	addi	a3,a3,538 # ffffffffc0206f88 <etext+0x16da>
ffffffffc0203d76:	00002617          	auipc	a2,0x2
ffffffffc0203d7a:	56a60613          	addi	a2,a2,1386 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203d7e:	14e00593          	li	a1,334
ffffffffc0203d82:	00003517          	auipc	a0,0x3
ffffffffc0203d86:	07e50513          	addi	a0,a0,126 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203d8a:	ebcfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203d8e:	00003697          	auipc	a3,0x3
ffffffffc0203d92:	1ea68693          	addi	a3,a3,490 # ffffffffc0206f78 <etext+0x16ca>
ffffffffc0203d96:	00002617          	auipc	a2,0x2
ffffffffc0203d9a:	54a60613          	addi	a2,a2,1354 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203d9e:	14c00593          	li	a1,332
ffffffffc0203da2:	00003517          	auipc	a0,0x3
ffffffffc0203da6:	05e50513          	addi	a0,a0,94 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203daa:	e9cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203dae:	00003697          	auipc	a3,0x3
ffffffffc0203db2:	1ba68693          	addi	a3,a3,442 # ffffffffc0206f68 <etext+0x16ba>
ffffffffc0203db6:	00002617          	auipc	a2,0x2
ffffffffc0203dba:	52a60613          	addi	a2,a2,1322 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203dbe:	14a00593          	li	a1,330
ffffffffc0203dc2:	00003517          	auipc	a0,0x3
ffffffffc0203dc6:	03e50513          	addi	a0,a0,62 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203dca:	e7cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203dce:	00003697          	auipc	a3,0x3
ffffffffc0203dd2:	18a68693          	addi	a3,a3,394 # ffffffffc0206f58 <etext+0x16aa>
ffffffffc0203dd6:	00002617          	auipc	a2,0x2
ffffffffc0203dda:	50a60613          	addi	a2,a2,1290 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203dde:	14800593          	li	a1,328
ffffffffc0203de2:	00003517          	auipc	a0,0x3
ffffffffc0203de6:	01e50513          	addi	a0,a0,30 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203dea:	e5cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203dee:	00003697          	auipc	a3,0x3
ffffffffc0203df2:	0fa68693          	addi	a3,a3,250 # ffffffffc0206ee8 <etext+0x163a>
ffffffffc0203df6:	00002617          	auipc	a2,0x2
ffffffffc0203dfa:	4ea60613          	addi	a2,a2,1258 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203dfe:	13b00593          	li	a1,315
ffffffffc0203e02:	00003517          	auipc	a0,0x3
ffffffffc0203e06:	ffe50513          	addi	a0,a0,-2 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203e0a:	e3cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203e0e:	00003697          	auipc	a3,0x3
ffffffffc0203e12:	13a68693          	addi	a3,a3,314 # ffffffffc0206f48 <etext+0x169a>
ffffffffc0203e16:	00002617          	auipc	a2,0x2
ffffffffc0203e1a:	4ca60613          	addi	a2,a2,1226 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203e1e:	14600593          	li	a1,326
ffffffffc0203e22:	00003517          	auipc	a0,0x3
ffffffffc0203e26:	fde50513          	addi	a0,a0,-34 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203e2a:	e1cfc0ef          	jal	ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203e2e:	00003697          	auipc	a3,0x3
ffffffffc0203e32:	10a68693          	addi	a3,a3,266 # ffffffffc0206f38 <etext+0x168a>
ffffffffc0203e36:	00002617          	auipc	a2,0x2
ffffffffc0203e3a:	4aa60613          	addi	a2,a2,1194 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203e3e:	14400593          	li	a1,324
ffffffffc0203e42:	00003517          	auipc	a0,0x3
ffffffffc0203e46:	fbe50513          	addi	a0,a0,-66 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203e4a:	dfcfc0ef          	jal	ffffffffc0200446 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203e4e:	6914                	ld	a3,16(a0)
ffffffffc0203e50:	6510                	ld	a2,8(a0)
ffffffffc0203e52:	0004859b          	sext.w	a1,s1
ffffffffc0203e56:	00003517          	auipc	a0,0x3
ffffffffc0203e5a:	19250513          	addi	a0,a0,402 # ffffffffc0206fe8 <etext+0x173a>
ffffffffc0203e5e:	b36fc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc0203e62:	00003697          	auipc	a3,0x3
ffffffffc0203e66:	1ae68693          	addi	a3,a3,430 # ffffffffc0207010 <etext+0x1762>
ffffffffc0203e6a:	00002617          	auipc	a2,0x2
ffffffffc0203e6e:	47660613          	addi	a2,a2,1142 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0203e72:	15900593          	li	a1,345
ffffffffc0203e76:	00003517          	auipc	a0,0x3
ffffffffc0203e7a:	f8a50513          	addi	a0,a0,-118 # ffffffffc0206e00 <etext+0x1552>
ffffffffc0203e7e:	dc8fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0203e82 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203e82:	7179                	addi	sp,sp,-48
ffffffffc0203e84:	f022                	sd	s0,32(sp)
ffffffffc0203e86:	f406                	sd	ra,40(sp)
ffffffffc0203e88:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203e8a:	c52d                	beqz	a0,ffffffffc0203ef4 <user_mem_check+0x72>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203e8c:	002007b7          	lui	a5,0x200
ffffffffc0203e90:	04f5ed63          	bltu	a1,a5,ffffffffc0203eea <user_mem_check+0x68>
ffffffffc0203e94:	ec26                	sd	s1,24(sp)
ffffffffc0203e96:	00c584b3          	add	s1,a1,a2
ffffffffc0203e9a:	0695ff63          	bgeu	a1,s1,ffffffffc0203f18 <user_mem_check+0x96>
ffffffffc0203e9e:	4785                	li	a5,1
ffffffffc0203ea0:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ea2:	0785                	addi	a5,a5,1 # 200001 <_binary_obj___user_exit_out_size+0x1f5e49>
ffffffffc0203ea4:	06f4fa63          	bgeu	s1,a5,ffffffffc0203f18 <user_mem_check+0x96>
ffffffffc0203ea8:	e84a                	sd	s2,16(sp)
ffffffffc0203eaa:	e44e                	sd	s3,8(sp)
ffffffffc0203eac:	8936                	mv	s2,a3
ffffffffc0203eae:	89aa                	mv	s3,a0
ffffffffc0203eb0:	a829                	j	ffffffffc0203eca <user_mem_check+0x48>
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203eb2:	6685                	lui	a3,0x1
ffffffffc0203eb4:	9736                	add	a4,a4,a3
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203eb6:	0027f693          	andi	a3,a5,2
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203eba:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203ebc:	c685                	beqz	a3,ffffffffc0203ee4 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203ebe:	c399                	beqz	a5,ffffffffc0203ec4 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203ec0:	02e46263          	bltu	s0,a4,ffffffffc0203ee4 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203ec4:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203ec6:	04947b63          	bgeu	s0,s1,ffffffffc0203f1c <user_mem_check+0x9a>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203eca:	85a2                	mv	a1,s0
ffffffffc0203ecc:	854e                	mv	a0,s3
ffffffffc0203ece:	959ff0ef          	jal	ffffffffc0203826 <find_vma>
ffffffffc0203ed2:	c909                	beqz	a0,ffffffffc0203ee4 <user_mem_check+0x62>
ffffffffc0203ed4:	6518                	ld	a4,8(a0)
ffffffffc0203ed6:	00e46763          	bltu	s0,a4,ffffffffc0203ee4 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203eda:	4d1c                	lw	a5,24(a0)
ffffffffc0203edc:	fc091be3          	bnez	s2,ffffffffc0203eb2 <user_mem_check+0x30>
ffffffffc0203ee0:	8b85                	andi	a5,a5,1
ffffffffc0203ee2:	f3ed                	bnez	a5,ffffffffc0203ec4 <user_mem_check+0x42>
ffffffffc0203ee4:	64e2                	ld	s1,24(sp)
ffffffffc0203ee6:	6942                	ld	s2,16(sp)
ffffffffc0203ee8:	69a2                	ld	s3,8(sp)
            return 0;
ffffffffc0203eea:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203eec:	70a2                	ld	ra,40(sp)
ffffffffc0203eee:	7402                	ld	s0,32(sp)
ffffffffc0203ef0:	6145                	addi	sp,sp,48
ffffffffc0203ef2:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203ef4:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ef8:	fef5eae3          	bltu	a1,a5,ffffffffc0203eec <user_mem_check+0x6a>
ffffffffc0203efc:	c80007b7          	lui	a5,0xc8000
ffffffffc0203f00:	962e                	add	a2,a2,a1
ffffffffc0203f02:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d64309>
ffffffffc0203f04:	00c5b433          	sltu	s0,a1,a2
ffffffffc0203f08:	00f63633          	sltu	a2,a2,a5
ffffffffc0203f0c:	70a2                	ld	ra,40(sp)
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203f0e:	00867533          	and	a0,a2,s0
ffffffffc0203f12:	7402                	ld	s0,32(sp)
ffffffffc0203f14:	6145                	addi	sp,sp,48
ffffffffc0203f16:	8082                	ret
ffffffffc0203f18:	64e2                	ld	s1,24(sp)
ffffffffc0203f1a:	bfc1                	j	ffffffffc0203eea <user_mem_check+0x68>
ffffffffc0203f1c:	64e2                	ld	s1,24(sp)
ffffffffc0203f1e:	6942                	ld	s2,16(sp)
ffffffffc0203f20:	69a2                	ld	s3,8(sp)
        return 1;
ffffffffc0203f22:	4505                	li	a0,1
ffffffffc0203f24:	b7e1                	j	ffffffffc0203eec <user_mem_check+0x6a>

ffffffffc0203f26 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203f26:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203f28:	9402                	jalr	s0

	jal do_exit
ffffffffc0203f2a:	5fc000ef          	jal	ffffffffc0204526 <do_exit>

ffffffffc0203f2e <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203f2e:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203f30:	10800513          	li	a0,264
{
ffffffffc0203f34:	e022                	sd	s0,0(sp)
ffffffffc0203f36:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203f38:	e99fd0ef          	jal	ffffffffc0201dd0 <kmalloc>
ffffffffc0203f3c:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203f3e:	c525                	beqz	a0,ffffffffc0203fa6 <alloc_proc+0x78>
    {
        proc->state = PROC_UNINIT;
ffffffffc0203f40:	57fd                	li	a5,-1
ffffffffc0203f42:	1782                	slli	a5,a5,0x20
ffffffffc0203f44:	e11c                	sd	a5,0(a0)
        proc->pid = -1;
        proc->runs = 0;
ffffffffc0203f46:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203f4a:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203f4e:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203f52:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203f56:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203f5a:	07000613          	li	a2,112
ffffffffc0203f5e:	4581                	li	a1,0
ffffffffc0203f60:	03050513          	addi	a0,a0,48
ffffffffc0203f64:	121010ef          	jal	ffffffffc0205884 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203f68:	00098797          	auipc	a5,0x98
ffffffffc0203f6c:	d487b783          	ld	a5,-696(a5) # ffffffffc029bcb0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc0203f70:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203f74:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203f78:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f7a:	0b440513          	addi	a0,s0,180
ffffffffc0203f7e:	4641                	li	a2,16
ffffffffc0203f80:	4581                	li	a1,0
ffffffffc0203f82:	103010ef          	jal	ffffffffc0205884 <memset>
        list_init(&(proc->list_link));
ffffffffc0203f86:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203f8a:	0d840793          	addi	a5,s0,216
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->wait_state = 0;
ffffffffc0203f8e:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0203f92:	0e043823          	sd	zero,240(s0)
        proc->yptr = NULL;
ffffffffc0203f96:	0e043c23          	sd	zero,248(s0)
        proc->optr = NULL;
ffffffffc0203f9a:	10043023          	sd	zero,256(s0)
    elm->prev = elm->next = elm;
ffffffffc0203f9e:	e878                	sd	a4,208(s0)
ffffffffc0203fa0:	e478                	sd	a4,200(s0)
ffffffffc0203fa2:	f07c                	sd	a5,224(s0)
ffffffffc0203fa4:	ec7c                	sd	a5,216(s0)
    }
    return proc;
}
ffffffffc0203fa6:	60a2                	ld	ra,8(sp)
ffffffffc0203fa8:	8522                	mv	a0,s0
ffffffffc0203faa:	6402                	ld	s0,0(sp)
ffffffffc0203fac:	0141                	addi	sp,sp,16
ffffffffc0203fae:	8082                	ret

ffffffffc0203fb0 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203fb0:	00098797          	auipc	a5,0x98
ffffffffc0203fb4:	d307b783          	ld	a5,-720(a5) # ffffffffc029bce0 <current>
ffffffffc0203fb8:	73c8                	ld	a0,160(a5)
ffffffffc0203fba:	ffdfc06f          	j	ffffffffc0200fb6 <forkrets>

ffffffffc0203fbe <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fbe:	00098797          	auipc	a5,0x98
ffffffffc0203fc2:	d227b783          	ld	a5,-734(a5) # ffffffffc029bce0 <current>
{
ffffffffc0203fc6:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fc8:	00003617          	auipc	a2,0x3
ffffffffc0203fcc:	09860613          	addi	a2,a2,152 # ffffffffc0207060 <etext+0x17b2>
ffffffffc0203fd0:	43cc                	lw	a1,4(a5)
ffffffffc0203fd2:	00003517          	auipc	a0,0x3
ffffffffc0203fd6:	09e50513          	addi	a0,a0,158 # ffffffffc0207070 <etext+0x17c2>
{
ffffffffc0203fda:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fdc:	9b8fc0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0203fe0:	3fe06797          	auipc	a5,0x3fe06
ffffffffc0203fe4:	8f078793          	addi	a5,a5,-1808 # 98d0 <_binary_obj___user_forktest_out_size>
ffffffffc0203fe8:	e43e                	sd	a5,8(sp)
kernel_execve(const char *name, unsigned char *binary, size_t size)
ffffffffc0203fea:	00003517          	auipc	a0,0x3
ffffffffc0203fee:	07650513          	addi	a0,a0,118 # ffffffffc0207060 <etext+0x17b2>
ffffffffc0203ff2:	00040797          	auipc	a5,0x40
ffffffffc0203ff6:	d0678793          	addi	a5,a5,-762 # ffffffffc0243cf8 <_binary_obj___user_forktest_out_start>
ffffffffc0203ffa:	f03e                	sd	a5,32(sp)
ffffffffc0203ffc:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203ffe:	e802                	sd	zero,16(sp)
ffffffffc0204000:	7d0010ef          	jal	ffffffffc02057d0 <strlen>
ffffffffc0204004:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204006:	4511                	li	a0,4
ffffffffc0204008:	55a2                	lw	a1,40(sp)
ffffffffc020400a:	4662                	lw	a2,24(sp)
ffffffffc020400c:	5682                	lw	a3,32(sp)
ffffffffc020400e:	4722                	lw	a4,8(sp)
ffffffffc0204010:	48a9                	li	a7,10
ffffffffc0204012:	9002                	ebreak
ffffffffc0204014:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204016:	65c2                	ld	a1,16(sp)
ffffffffc0204018:	00003517          	auipc	a0,0x3
ffffffffc020401c:	08050513          	addi	a0,a0,128 # ffffffffc0207098 <etext+0x17ea>
ffffffffc0204020:	974fc0ef          	jal	ffffffffc0200194 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204024:	00003617          	auipc	a2,0x3
ffffffffc0204028:	08460613          	addi	a2,a2,132 # ffffffffc02070a8 <etext+0x17fa>
ffffffffc020402c:	3be00593          	li	a1,958
ffffffffc0204030:	00003517          	auipc	a0,0x3
ffffffffc0204034:	09850513          	addi	a0,a0,152 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204038:	c0efc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020403c <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc020403c:	6d14                	ld	a3,24(a0)
{
ffffffffc020403e:	1141                	addi	sp,sp,-16
ffffffffc0204040:	e406                	sd	ra,8(sp)
ffffffffc0204042:	c02007b7          	lui	a5,0xc0200
ffffffffc0204046:	02f6ee63          	bltu	a3,a5,ffffffffc0204082 <put_pgdir+0x46>
ffffffffc020404a:	00098717          	auipc	a4,0x98
ffffffffc020404e:	c7673703          	ld	a4,-906(a4) # ffffffffc029bcc0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204052:	00098797          	auipc	a5,0x98
ffffffffc0204056:	c767b783          	ld	a5,-906(a5) # ffffffffc029bcc8 <npage>
    return pa2page(PADDR(kva));
ffffffffc020405a:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc020405c:	82b1                	srli	a3,a3,0xc
ffffffffc020405e:	02f6fe63          	bgeu	a3,a5,ffffffffc020409a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204062:	00004797          	auipc	a5,0x4
ffffffffc0204066:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc0207a50 <nbase>
ffffffffc020406a:	00098517          	auipc	a0,0x98
ffffffffc020406e:	c6653503          	ld	a0,-922(a0) # ffffffffc029bcd0 <pages>
}
ffffffffc0204072:	60a2                	ld	ra,8(sp)
ffffffffc0204074:	8e9d                	sub	a3,a3,a5
ffffffffc0204076:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204078:	4585                	li	a1,1
ffffffffc020407a:	9536                	add	a0,a0,a3
}
ffffffffc020407c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020407e:	f51fd06f          	j	ffffffffc0201fce <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204082:	00002617          	auipc	a2,0x2
ffffffffc0204086:	6b660613          	addi	a2,a2,1718 # ffffffffc0206738 <etext+0xe8a>
ffffffffc020408a:	07700593          	li	a1,119
ffffffffc020408e:	00002517          	auipc	a0,0x2
ffffffffc0204092:	62a50513          	addi	a0,a0,1578 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204096:	bb0fc0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020409a:	00002617          	auipc	a2,0x2
ffffffffc020409e:	6c660613          	addi	a2,a2,1734 # ffffffffc0206760 <etext+0xeb2>
ffffffffc02040a2:	06900593          	li	a1,105
ffffffffc02040a6:	00002517          	auipc	a0,0x2
ffffffffc02040aa:	61250513          	addi	a0,a0,1554 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc02040ae:	b98fc0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02040b2 <proc_run>:
    if (proc != current)
ffffffffc02040b2:	00098797          	auipc	a5,0x98
ffffffffc02040b6:	c2e78793          	addi	a5,a5,-978 # ffffffffc029bce0 <current>
ffffffffc02040ba:	6398                	ld	a4,0(a5)
ffffffffc02040bc:	04a70163          	beq	a4,a0,ffffffffc02040fe <proc_run+0x4c>
{
ffffffffc02040c0:	1101                	addi	sp,sp,-32
ffffffffc02040c2:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040c4:	100026f3          	csrr	a3,sstatus
ffffffffc02040c8:	8a89                	andi	a3,a3,2
    return 0;
ffffffffc02040ca:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040cc:	ea95                	bnez	a3,ffffffffc0204100 <proc_run+0x4e>
        current = proc;
ffffffffc02040ce:	e388                	sd	a0,0(a5)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc02040d0:	755c                	ld	a5,168(a0)
ffffffffc02040d2:	56fd                	li	a3,-1
ffffffffc02040d4:	16fe                	slli	a3,a3,0x3f
ffffffffc02040d6:	83b1                	srli	a5,a5,0xc
ffffffffc02040d8:	e432                	sd	a2,8(sp)
ffffffffc02040da:	8fd5                	or	a5,a5,a3
ffffffffc02040dc:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(proc->context));
ffffffffc02040e0:	03050593          	addi	a1,a0,48
ffffffffc02040e4:	03070513          	addi	a0,a4,48
ffffffffc02040e8:	0a0010ef          	jal	ffffffffc0205188 <switch_to>
    if (flag)
ffffffffc02040ec:	6622                	ld	a2,8(sp)
ffffffffc02040ee:	e601                	bnez	a2,ffffffffc02040f6 <proc_run+0x44>
}
ffffffffc02040f0:	60e2                	ld	ra,24(sp)
ffffffffc02040f2:	6105                	addi	sp,sp,32
ffffffffc02040f4:	8082                	ret
ffffffffc02040f6:	60e2                	ld	ra,24(sp)
ffffffffc02040f8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02040fa:	805fc06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc02040fe:	8082                	ret
        intr_disable();
ffffffffc0204100:	e42a                	sd	a0,8(sp)
ffffffffc0204102:	803fc0ef          	jal	ffffffffc0200904 <intr_disable>
        struct proc_struct *prev = current;
ffffffffc0204106:	00098797          	auipc	a5,0x98
ffffffffc020410a:	bda78793          	addi	a5,a5,-1062 # ffffffffc029bce0 <current>
ffffffffc020410e:	6398                	ld	a4,0(a5)
        return 1;
ffffffffc0204110:	6522                	ld	a0,8(sp)
ffffffffc0204112:	4605                	li	a2,1
ffffffffc0204114:	bf6d                	j	ffffffffc02040ce <proc_run+0x1c>

ffffffffc0204116 <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc0204116:	00098797          	auipc	a5,0x98
ffffffffc020411a:	bc27a783          	lw	a5,-1086(a5) # ffffffffc029bcd8 <nr_process>
{
ffffffffc020411e:	7119                	addi	sp,sp,-128
ffffffffc0204120:	ecce                	sd	s3,88(sp)
ffffffffc0204122:	fc86                	sd	ra,120(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204124:	6985                	lui	s3,0x1
ffffffffc0204126:	3337d963          	bge	a5,s3,ffffffffc0204458 <do_fork+0x342>
ffffffffc020412a:	f8a2                	sd	s0,112(sp)
ffffffffc020412c:	f4a6                	sd	s1,104(sp)
ffffffffc020412e:	f0ca                	sd	s2,96(sp)
ffffffffc0204130:	ec6e                	sd	s11,24(sp)
ffffffffc0204132:	892e                	mv	s2,a1
ffffffffc0204134:	84b2                	mv	s1,a2
ffffffffc0204136:	8daa                	mv	s11,a0
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0204138:	df7ff0ef          	jal	ffffffffc0203f2e <alloc_proc>
ffffffffc020413c:	842a                	mv	s0,a0
ffffffffc020413e:	2e050963          	beqz	a0,ffffffffc0204430 <do_fork+0x31a>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204142:	4509                	li	a0,2
ffffffffc0204144:	e51fd0ef          	jal	ffffffffc0201f94 <alloc_pages>
    if (page != NULL)
ffffffffc0204148:	2e050163          	beqz	a0,ffffffffc020442a <do_fork+0x314>
ffffffffc020414c:	e8d2                	sd	s4,80(sp)
    return page - pages + nbase;
ffffffffc020414e:	00098a17          	auipc	s4,0x98
ffffffffc0204152:	b82a0a13          	addi	s4,s4,-1150 # ffffffffc029bcd0 <pages>
ffffffffc0204156:	000a3783          	ld	a5,0(s4)
ffffffffc020415a:	e4d6                	sd	s5,72(sp)
ffffffffc020415c:	00004a97          	auipc	s5,0x4
ffffffffc0204160:	8f4a8a93          	addi	s5,s5,-1804 # ffffffffc0207a50 <nbase>
ffffffffc0204164:	000ab703          	ld	a4,0(s5)
ffffffffc0204168:	40f506b3          	sub	a3,a0,a5
ffffffffc020416c:	e0da                	sd	s6,64(sp)
    return KADDR(page2pa(page));
ffffffffc020416e:	00098b17          	auipc	s6,0x98
ffffffffc0204172:	b5ab0b13          	addi	s6,s6,-1190 # ffffffffc029bcc8 <npage>
ffffffffc0204176:	f06a                	sd	s10,32(sp)
    return page - pages + nbase;
ffffffffc0204178:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020417a:	5d7d                	li	s10,-1
ffffffffc020417c:	000b3783          	ld	a5,0(s6)
    return page - pages + nbase;
ffffffffc0204180:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204182:	00cd5d13          	srli	s10,s10,0xc
ffffffffc0204186:	01a6f633          	and	a2,a3,s10
ffffffffc020418a:	fc5e                	sd	s7,56(sp)
ffffffffc020418c:	f862                	sd	s8,48(sp)
ffffffffc020418e:	f466                	sd	s9,40(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc0204190:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204192:	2ef67163          	bgeu	a2,a5,ffffffffc0204474 <do_fork+0x35e>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204196:	00098c17          	auipc	s8,0x98
ffffffffc020419a:	b4ac0c13          	addi	s8,s8,-1206 # ffffffffc029bce0 <current>
ffffffffc020419e:	000c3803          	ld	a6,0(s8)
ffffffffc02041a2:	00098b97          	auipc	s7,0x98
ffffffffc02041a6:	b1eb8b93          	addi	s7,s7,-1250 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc02041aa:	000bb783          	ld	a5,0(s7)
ffffffffc02041ae:	02883c83          	ld	s9,40(a6) # fffffffffffff028 <end+0x3fd63330>
ffffffffc02041b2:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02041b4:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc02041b6:	020c8a63          	beqz	s9,ffffffffc02041ea <do_fork+0xd4>
    if (clone_flags & CLONE_VM)
ffffffffc02041ba:	100df793          	andi	a5,s11,256
ffffffffc02041be:	18078863          	beqz	a5,ffffffffc020434e <do_fork+0x238>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02041c2:	030ca703          	lw	a4,48(s9)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041c6:	018cb783          	ld	a5,24(s9)
ffffffffc02041ca:	c02006b7          	lui	a3,0xc0200
ffffffffc02041ce:	2705                	addiw	a4,a4,1
ffffffffc02041d0:	02eca823          	sw	a4,48(s9)
    proc->mm = mm;
ffffffffc02041d4:	03943423          	sd	s9,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041d8:	2cd7e663          	bltu	a5,a3,ffffffffc02044a4 <do_fork+0x38e>
ffffffffc02041dc:	000bb703          	ld	a4,0(s7)
    proc->parent = current;
ffffffffc02041e0:	000c3803          	ld	a6,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02041e4:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041e6:	8f99                	sub	a5,a5,a4
ffffffffc02041e8:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02041ea:	6789                	lui	a5,0x2
ffffffffc02041ec:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_softint_out_size-0x6cd0>
ffffffffc02041f0:	96be                	add	a3,a3,a5
ffffffffc02041f2:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc02041f4:	87b6                	mv	a5,a3
ffffffffc02041f6:	12048713          	addi	a4,s1,288
ffffffffc02041fa:	6890                	ld	a2,16(s1)
ffffffffc02041fc:	6088                	ld	a0,0(s1)
ffffffffc02041fe:	648c                	ld	a1,8(s1)
ffffffffc0204200:	eb90                	sd	a2,16(a5)
ffffffffc0204202:	e388                	sd	a0,0(a5)
ffffffffc0204204:	e78c                	sd	a1,8(a5)
ffffffffc0204206:	6c90                	ld	a2,24(s1)
ffffffffc0204208:	02048493          	addi	s1,s1,32
ffffffffc020420c:	02078793          	addi	a5,a5,32
ffffffffc0204210:	fec7bc23          	sd	a2,-8(a5)
ffffffffc0204214:	fee493e3          	bne	s1,a4,ffffffffc02041fa <do_fork+0xe4>
    proc->tf->gpr.a0 = 0;
ffffffffc0204218:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020421c:	22090063          	beqz	s2,ffffffffc020443c <do_fork+0x326>
    if (++last_pid >= MAX_PID)
ffffffffc0204220:	00093597          	auipc	a1,0x93
ffffffffc0204224:	62c5a583          	lw	a1,1580(a1) # ffffffffc029784c <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204228:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020422c:	00000797          	auipc	a5,0x0
ffffffffc0204230:	d8478793          	addi	a5,a5,-636 # ffffffffc0203fb0 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0204234:	2585                	addiw	a1,a1,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204236:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204238:	fc14                	sd	a3,56(s0)
    if (++last_pid >= MAX_PID)
ffffffffc020423a:	00093717          	auipc	a4,0x93
ffffffffc020423e:	60b72923          	sw	a1,1554(a4) # ffffffffc029784c <last_pid.1>
ffffffffc0204242:	6789                	lui	a5,0x2
ffffffffc0204244:	1ef5de63          	bge	a1,a5,ffffffffc0204440 <do_fork+0x32a>
    if (last_pid >= next_safe)
ffffffffc0204248:	00093797          	auipc	a5,0x93
ffffffffc020424c:	6007a783          	lw	a5,1536(a5) # ffffffffc0297848 <next_safe.0>
ffffffffc0204250:	00098497          	auipc	s1,0x98
ffffffffc0204254:	a1848493          	addi	s1,s1,-1512 # ffffffffc029bc68 <proc_list>
ffffffffc0204258:	06f5c563          	blt	a1,a5,ffffffffc02042c2 <do_fork+0x1ac>
    return listelm->next;
ffffffffc020425c:	00098497          	auipc	s1,0x98
ffffffffc0204260:	a0c48493          	addi	s1,s1,-1524 # ffffffffc029bc68 <proc_list>
ffffffffc0204264:	0084b303          	ld	t1,8(s1)
        next_safe = MAX_PID;
ffffffffc0204268:	6789                	lui	a5,0x2
ffffffffc020426a:	00093717          	auipc	a4,0x93
ffffffffc020426e:	5cf72f23          	sw	a5,1502(a4) # ffffffffc0297848 <next_safe.0>
ffffffffc0204272:	86ae                	mv	a3,a1
ffffffffc0204274:	4501                	li	a0,0
        while ((le = list_next(le)) != list)
ffffffffc0204276:	04930063          	beq	t1,s1,ffffffffc02042b6 <do_fork+0x1a0>
ffffffffc020427a:	88aa                	mv	a7,a0
ffffffffc020427c:	879a                	mv	a5,t1
ffffffffc020427e:	6609                	lui	a2,0x2
ffffffffc0204280:	a811                	j	ffffffffc0204294 <do_fork+0x17e>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204282:	00e6d663          	bge	a3,a4,ffffffffc020428e <do_fork+0x178>
ffffffffc0204286:	00c75463          	bge	a4,a2,ffffffffc020428e <do_fork+0x178>
                next_safe = proc->pid;
ffffffffc020428a:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020428c:	4885                	li	a7,1
ffffffffc020428e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204290:	00978d63          	beq	a5,s1,ffffffffc02042aa <do_fork+0x194>
            if (proc->pid == last_pid)
ffffffffc0204294:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_softint_out_size-0x6c74>
ffffffffc0204298:	fed715e3          	bne	a4,a3,ffffffffc0204282 <do_fork+0x16c>
                if (++last_pid >= next_safe)
ffffffffc020429c:	2685                	addiw	a3,a3,1
ffffffffc020429e:	1ac6d763          	bge	a3,a2,ffffffffc020444c <do_fork+0x336>
ffffffffc02042a2:	679c                	ld	a5,8(a5)
ffffffffc02042a4:	4505                	li	a0,1
        while ((le = list_next(le)) != list)
ffffffffc02042a6:	fe9797e3          	bne	a5,s1,ffffffffc0204294 <do_fork+0x17e>
ffffffffc02042aa:	00088663          	beqz	a7,ffffffffc02042b6 <do_fork+0x1a0>
ffffffffc02042ae:	00093797          	auipc	a5,0x93
ffffffffc02042b2:	58c7ad23          	sw	a2,1434(a5) # ffffffffc0297848 <next_safe.0>
ffffffffc02042b6:	c511                	beqz	a0,ffffffffc02042c2 <do_fork+0x1ac>
ffffffffc02042b8:	00093797          	auipc	a5,0x93
ffffffffc02042bc:	58d7aa23          	sw	a3,1428(a5) # ffffffffc029784c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02042c0:	85b6                	mv	a1,a3
    proc->pid = get_pid();
ffffffffc02042c2:	c04c                	sw	a1,4(s0)
    proc->parent = current;
ffffffffc02042c4:	03043023          	sd	a6,32(s0)
    current->wait_state = 0;
ffffffffc02042c8:	0e082623          	sw	zero,236(a6)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02042cc:	4048                	lw	a0,4(s0)
ffffffffc02042ce:	45a9                	li	a1,10
ffffffffc02042d0:	11e010ef          	jal	ffffffffc02053ee <hash32>
ffffffffc02042d4:	02051793          	slli	a5,a0,0x20
ffffffffc02042d8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02042dc:	00094797          	auipc	a5,0x94
ffffffffc02042e0:	98c78793          	addi	a5,a5,-1652 # ffffffffc0297c68 <hash_list>
ffffffffc02042e4:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02042e6:	6518                	ld	a4,8(a0)
ffffffffc02042e8:	0d840793          	addi	a5,s0,216
ffffffffc02042ec:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc02042ee:	e31c                	sd	a5,0(a4)
ffffffffc02042f0:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc02042f2:	f078                	sd	a4,224(s0)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02042f4:	0c840793          	addi	a5,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02042f8:	7018                	ld	a4,32(s0)
    elm->prev = prev;
ffffffffc02042fa:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc02042fc:	e21c                	sd	a5,0(a2)
    proc->yptr = NULL;
ffffffffc02042fe:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204302:	7b74                	ld	a3,240(a4)
ffffffffc0204304:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc0204306:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204308:	e464                	sd	s1,200(s0)
ffffffffc020430a:	10d43023          	sd	a3,256(s0)
ffffffffc020430e:	c299                	beqz	a3,ffffffffc0204314 <do_fork+0x1fe>
        proc->optr->yptr = proc;
ffffffffc0204310:	fee0                	sd	s0,248(a3)
    proc->parent->cptr = proc;
ffffffffc0204312:	7018                	ld	a4,32(s0)
    nr_process++;
ffffffffc0204314:	00098797          	auipc	a5,0x98
ffffffffc0204318:	9c47a783          	lw	a5,-1596(a5) # ffffffffc029bcd8 <nr_process>
    proc->parent->cptr = proc;
ffffffffc020431c:	fb60                	sd	s0,240(a4)
    wakeup_proc(proc);
ffffffffc020431e:	8522                	mv	a0,s0
    nr_process++;
ffffffffc0204320:	2785                	addiw	a5,a5,1
ffffffffc0204322:	00098717          	auipc	a4,0x98
ffffffffc0204326:	9af72b23          	sw	a5,-1610(a4) # ffffffffc029bcd8 <nr_process>
    wakeup_proc(proc);
ffffffffc020432a:	6c9000ef          	jal	ffffffffc02051f2 <wakeup_proc>
    ret = proc->pid;
ffffffffc020432e:	4048                	lw	a0,4(s0)
    goto fork_out;
ffffffffc0204330:	74a6                	ld	s1,104(sp)
ffffffffc0204332:	7446                	ld	s0,112(sp)
ffffffffc0204334:	7906                	ld	s2,96(sp)
ffffffffc0204336:	6a46                	ld	s4,80(sp)
ffffffffc0204338:	6aa6                	ld	s5,72(sp)
ffffffffc020433a:	6b06                	ld	s6,64(sp)
ffffffffc020433c:	7be2                	ld	s7,56(sp)
ffffffffc020433e:	7c42                	ld	s8,48(sp)
ffffffffc0204340:	7ca2                	ld	s9,40(sp)
ffffffffc0204342:	7d02                	ld	s10,32(sp)
ffffffffc0204344:	6de2                	ld	s11,24(sp)
}
ffffffffc0204346:	70e6                	ld	ra,120(sp)
ffffffffc0204348:	69e6                	ld	s3,88(sp)
ffffffffc020434a:	6109                	addi	sp,sp,128
ffffffffc020434c:	8082                	ret
    if ((mm = mm_create()) == NULL)
ffffffffc020434e:	e43a                	sd	a4,8(sp)
ffffffffc0204350:	ca6ff0ef          	jal	ffffffffc02037f6 <mm_create>
ffffffffc0204354:	8daa                	mv	s11,a0
ffffffffc0204356:	c959                	beqz	a0,ffffffffc02043ec <do_fork+0x2d6>
    if ((page = alloc_page()) == NULL)
ffffffffc0204358:	4505                	li	a0,1
ffffffffc020435a:	c3bfd0ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc020435e:	c541                	beqz	a0,ffffffffc02043e6 <do_fork+0x2d0>
    return page - pages + nbase;
ffffffffc0204360:	000a3683          	ld	a3,0(s4)
ffffffffc0204364:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204366:	000b3783          	ld	a5,0(s6)
    return page - pages + nbase;
ffffffffc020436a:	40d506b3          	sub	a3,a0,a3
ffffffffc020436e:	8699                	srai	a3,a3,0x6
ffffffffc0204370:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204372:	01a6fd33          	and	s10,a3,s10
    return page2ppn(page) << PGSHIFT;
ffffffffc0204376:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204378:	0efd7e63          	bgeu	s10,a5,ffffffffc0204474 <do_fork+0x35e>
ffffffffc020437c:	000bb783          	ld	a5,0(s7)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204380:	00098597          	auipc	a1,0x98
ffffffffc0204384:	9385b583          	ld	a1,-1736(a1) # ffffffffc029bcb8 <boot_pgdir_va>
ffffffffc0204388:	864e                	mv	a2,s3
ffffffffc020438a:	00f689b3          	add	s3,a3,a5
ffffffffc020438e:	854e                	mv	a0,s3
ffffffffc0204390:	506010ef          	jal	ffffffffc0205896 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204394:	038c8d13          	addi	s10,s9,56
    mm->pgdir = pgdir;
ffffffffc0204398:	013dbc23          	sd	s3,24(s11)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020439c:	4785                	li	a5,1
ffffffffc020439e:	40fd37af          	amoor.d	a5,a5,(s10)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02043a2:	03f79713          	slli	a4,a5,0x3f
ffffffffc02043a6:	03f75793          	srli	a5,a4,0x3f
ffffffffc02043aa:	4985                	li	s3,1
ffffffffc02043ac:	cb91                	beqz	a5,ffffffffc02043c0 <do_fork+0x2aa>
    {
        schedule();
ffffffffc02043ae:	6d9000ef          	jal	ffffffffc0205286 <schedule>
ffffffffc02043b2:	413d37af          	amoor.d	a5,s3,(s10)
    while (!try_lock(lock))
ffffffffc02043b6:	03f79713          	slli	a4,a5,0x3f
ffffffffc02043ba:	03f75793          	srli	a5,a4,0x3f
ffffffffc02043be:	fbe5                	bnez	a5,ffffffffc02043ae <do_fork+0x298>
        ret = dup_mmap(mm, oldmm);
ffffffffc02043c0:	85e6                	mv	a1,s9
ffffffffc02043c2:	856e                	mv	a0,s11
ffffffffc02043c4:	e8eff0ef          	jal	ffffffffc0203a52 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02043c8:	57f9                	li	a5,-2
ffffffffc02043ca:	60fd37af          	amoand.d	a5,a5,(s10)
ffffffffc02043ce:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02043d0:	0e078763          	beqz	a5,ffffffffc02044be <do_fork+0x3a8>
    if ((mm = mm_create()) == NULL)
ffffffffc02043d4:	8cee                	mv	s9,s11
    if (ret != 0)
ffffffffc02043d6:	de0506e3          	beqz	a0,ffffffffc02041c2 <do_fork+0xac>
    exit_mmap(mm);
ffffffffc02043da:	856e                	mv	a0,s11
ffffffffc02043dc:	f0eff0ef          	jal	ffffffffc0203aea <exit_mmap>
    put_pgdir(mm);
ffffffffc02043e0:	856e                	mv	a0,s11
ffffffffc02043e2:	c5bff0ef          	jal	ffffffffc020403c <put_pgdir>
    mm_destroy(mm);
ffffffffc02043e6:	856e                	mv	a0,s11
ffffffffc02043e8:	d4cff0ef          	jal	ffffffffc0203934 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02043ec:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02043ee:	c02007b7          	lui	a5,0xc0200
ffffffffc02043f2:	08f6ed63          	bltu	a3,a5,ffffffffc020448c <do_fork+0x376>
ffffffffc02043f6:	000bb783          	ld	a5,0(s7)
    if (PPN(pa) >= npage)
ffffffffc02043fa:	000b3703          	ld	a4,0(s6)
    return pa2page(PADDR(kva));
ffffffffc02043fe:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204402:	83b1                	srli	a5,a5,0xc
ffffffffc0204404:	04e7fc63          	bgeu	a5,a4,ffffffffc020445c <do_fork+0x346>
    return &pages[PPN(pa) - nbase];
ffffffffc0204408:	000ab703          	ld	a4,0(s5)
ffffffffc020440c:	000a3503          	ld	a0,0(s4)
ffffffffc0204410:	4589                	li	a1,2
ffffffffc0204412:	8f99                	sub	a5,a5,a4
ffffffffc0204414:	079a                	slli	a5,a5,0x6
ffffffffc0204416:	953e                	add	a0,a0,a5
ffffffffc0204418:	bb7fd0ef          	jal	ffffffffc0201fce <free_pages>
}
ffffffffc020441c:	6a46                	ld	s4,80(sp)
ffffffffc020441e:	6aa6                	ld	s5,72(sp)
ffffffffc0204420:	6b06                	ld	s6,64(sp)
ffffffffc0204422:	7be2                	ld	s7,56(sp)
ffffffffc0204424:	7c42                	ld	s8,48(sp)
ffffffffc0204426:	7ca2                	ld	s9,40(sp)
ffffffffc0204428:	7d02                	ld	s10,32(sp)
    kfree(proc);
ffffffffc020442a:	8522                	mv	a0,s0
ffffffffc020442c:	a4bfd0ef          	jal	ffffffffc0201e76 <kfree>
    goto fork_out;
ffffffffc0204430:	7446                	ld	s0,112(sp)
ffffffffc0204432:	74a6                	ld	s1,104(sp)
ffffffffc0204434:	7906                	ld	s2,96(sp)
ffffffffc0204436:	6de2                	ld	s11,24(sp)
    ret = -E_NO_MEM;
ffffffffc0204438:	5571                	li	a0,-4
    return ret;
ffffffffc020443a:	b731                	j	ffffffffc0204346 <do_fork+0x230>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020443c:	8936                	mv	s2,a3
ffffffffc020443e:	b3cd                	j	ffffffffc0204220 <do_fork+0x10a>
        last_pid = 1;
ffffffffc0204440:	4585                	li	a1,1
ffffffffc0204442:	00093797          	auipc	a5,0x93
ffffffffc0204446:	40b7a523          	sw	a1,1034(a5) # ffffffffc029784c <last_pid.1>
        goto inside;
ffffffffc020444a:	bd09                	j	ffffffffc020425c <do_fork+0x146>
                    if (last_pid >= MAX_PID)
ffffffffc020444c:	6789                	lui	a5,0x2
ffffffffc020444e:	00f6c363          	blt	a3,a5,ffffffffc0204454 <do_fork+0x33e>
                        last_pid = 1;
ffffffffc0204452:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204454:	4505                	li	a0,1
ffffffffc0204456:	b505                	j	ffffffffc0204276 <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204458:	556d                	li	a0,-5
ffffffffc020445a:	b5f5                	j	ffffffffc0204346 <do_fork+0x230>
        panic("pa2page called with invalid pa");
ffffffffc020445c:	00002617          	auipc	a2,0x2
ffffffffc0204460:	30460613          	addi	a2,a2,772 # ffffffffc0206760 <etext+0xeb2>
ffffffffc0204464:	06900593          	li	a1,105
ffffffffc0204468:	00002517          	auipc	a0,0x2
ffffffffc020446c:	25050513          	addi	a0,a0,592 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204470:	fd7fb0ef          	jal	ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0204474:	00002617          	auipc	a2,0x2
ffffffffc0204478:	21c60613          	addi	a2,a2,540 # ffffffffc0206690 <etext+0xde2>
ffffffffc020447c:	07100593          	li	a1,113
ffffffffc0204480:	00002517          	auipc	a0,0x2
ffffffffc0204484:	23850513          	addi	a0,a0,568 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204488:	fbffb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc020448c:	00002617          	auipc	a2,0x2
ffffffffc0204490:	2ac60613          	addi	a2,a2,684 # ffffffffc0206738 <etext+0xe8a>
ffffffffc0204494:	07700593          	li	a1,119
ffffffffc0204498:	00002517          	auipc	a0,0x2
ffffffffc020449c:	22050513          	addi	a0,a0,544 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc02044a0:	fa7fb0ef          	jal	ffffffffc0200446 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02044a4:	86be                	mv	a3,a5
ffffffffc02044a6:	00002617          	auipc	a2,0x2
ffffffffc02044aa:	29260613          	addi	a2,a2,658 # ffffffffc0206738 <etext+0xe8a>
ffffffffc02044ae:	19400593          	li	a1,404
ffffffffc02044b2:	00003517          	auipc	a0,0x3
ffffffffc02044b6:	c1650513          	addi	a0,a0,-1002 # ffffffffc02070c8 <etext+0x181a>
ffffffffc02044ba:	f8dfb0ef          	jal	ffffffffc0200446 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc02044be:	00003617          	auipc	a2,0x3
ffffffffc02044c2:	c2260613          	addi	a2,a2,-990 # ffffffffc02070e0 <etext+0x1832>
ffffffffc02044c6:	03f00593          	li	a1,63
ffffffffc02044ca:	00003517          	auipc	a0,0x3
ffffffffc02044ce:	c2650513          	addi	a0,a0,-986 # ffffffffc02070f0 <etext+0x1842>
ffffffffc02044d2:	f75fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02044d6 <kernel_thread>:
{
ffffffffc02044d6:	7129                	addi	sp,sp,-320
ffffffffc02044d8:	fa22                	sd	s0,304(sp)
ffffffffc02044da:	f626                	sd	s1,296(sp)
ffffffffc02044dc:	f24a                	sd	s2,288(sp)
ffffffffc02044de:	842a                	mv	s0,a0
ffffffffc02044e0:	84ae                	mv	s1,a1
ffffffffc02044e2:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044e4:	850a                	mv	a0,sp
ffffffffc02044e6:	12000613          	li	a2,288
ffffffffc02044ea:	4581                	li	a1,0
{
ffffffffc02044ec:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044ee:	396010ef          	jal	ffffffffc0205884 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02044f2:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02044f4:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02044f6:	100027f3          	csrr	a5,sstatus
ffffffffc02044fa:	edd7f793          	andi	a5,a5,-291
ffffffffc02044fe:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204502:	860a                	mv	a2,sp
ffffffffc0204504:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204508:	00000717          	auipc	a4,0x0
ffffffffc020450c:	a1e70713          	addi	a4,a4,-1506 # ffffffffc0203f26 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204510:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204512:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204514:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204516:	c01ff0ef          	jal	ffffffffc0204116 <do_fork>
}
ffffffffc020451a:	70f2                	ld	ra,312(sp)
ffffffffc020451c:	7452                	ld	s0,304(sp)
ffffffffc020451e:	74b2                	ld	s1,296(sp)
ffffffffc0204520:	7912                	ld	s2,288(sp)
ffffffffc0204522:	6131                	addi	sp,sp,320
ffffffffc0204524:	8082                	ret

ffffffffc0204526 <do_exit>:
{
ffffffffc0204526:	7179                	addi	sp,sp,-48
ffffffffc0204528:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc020452a:	00097417          	auipc	s0,0x97
ffffffffc020452e:	7b640413          	addi	s0,s0,1974 # ffffffffc029bce0 <current>
ffffffffc0204532:	601c                	ld	a5,0(s0)
ffffffffc0204534:	00097717          	auipc	a4,0x97
ffffffffc0204538:	7bc73703          	ld	a4,1980(a4) # ffffffffc029bcf0 <idleproc>
{
ffffffffc020453c:	f406                	sd	ra,40(sp)
ffffffffc020453e:	ec26                	sd	s1,24(sp)
    if (current == idleproc)
ffffffffc0204540:	0ce78b63          	beq	a5,a4,ffffffffc0204616 <do_exit+0xf0>
    if (current == initproc)
ffffffffc0204544:	00097497          	auipc	s1,0x97
ffffffffc0204548:	7a448493          	addi	s1,s1,1956 # ffffffffc029bce8 <initproc>
ffffffffc020454c:	6098                	ld	a4,0(s1)
ffffffffc020454e:	e84a                	sd	s2,16(sp)
ffffffffc0204550:	0ee78a63          	beq	a5,a4,ffffffffc0204644 <do_exit+0x11e>
ffffffffc0204554:	892a                	mv	s2,a0
    struct mm_struct *mm = current->mm;
ffffffffc0204556:	7788                	ld	a0,40(a5)
    if (mm != NULL)
ffffffffc0204558:	c115                	beqz	a0,ffffffffc020457c <do_exit+0x56>
ffffffffc020455a:	00097797          	auipc	a5,0x97
ffffffffc020455e:	7567b783          	ld	a5,1878(a5) # ffffffffc029bcb0 <boot_pgdir_pa>
ffffffffc0204562:	577d                	li	a4,-1
ffffffffc0204564:	177e                	slli	a4,a4,0x3f
ffffffffc0204566:	83b1                	srli	a5,a5,0xc
ffffffffc0204568:	8fd9                	or	a5,a5,a4
ffffffffc020456a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020456e:	591c                	lw	a5,48(a0)
ffffffffc0204570:	37fd                	addiw	a5,a5,-1
ffffffffc0204572:	d91c                	sw	a5,48(a0)
        if (mm_count_dec(mm) == 0)
ffffffffc0204574:	cfd5                	beqz	a5,ffffffffc0204630 <do_exit+0x10a>
        current->mm = NULL;
ffffffffc0204576:	601c                	ld	a5,0(s0)
ffffffffc0204578:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020457c:	470d                	li	a4,3
    current->exit_code = error_code;
ffffffffc020457e:	0f27a423          	sw	s2,232(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204582:	c398                	sw	a4,0(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204584:	100027f3          	csrr	a5,sstatus
ffffffffc0204588:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020458a:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020458c:	ebe1                	bnez	a5,ffffffffc020465c <do_exit+0x136>
        proc = current->parent;
ffffffffc020458e:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204590:	800007b7          	lui	a5,0x80000
ffffffffc0204594:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        proc = current->parent;
ffffffffc0204596:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204598:	0ec52703          	lw	a4,236(a0)
ffffffffc020459c:	0cf70463          	beq	a4,a5,ffffffffc0204664 <do_exit+0x13e>
        while (current->cptr != NULL)
ffffffffc02045a0:	6018                	ld	a4,0(s0)
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045a2:	800005b7          	lui	a1,0x80000
ffffffffc02045a6:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        while (current->cptr != NULL)
ffffffffc02045a8:	7b7c                	ld	a5,240(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045aa:	460d                	li	a2,3
        while (current->cptr != NULL)
ffffffffc02045ac:	e789                	bnez	a5,ffffffffc02045b6 <do_exit+0x90>
ffffffffc02045ae:	a83d                	j	ffffffffc02045ec <do_exit+0xc6>
ffffffffc02045b0:	6018                	ld	a4,0(s0)
ffffffffc02045b2:	7b7c                	ld	a5,240(a4)
ffffffffc02045b4:	cf85                	beqz	a5,ffffffffc02045ec <do_exit+0xc6>
            current->cptr = proc->optr;
ffffffffc02045b6:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045ba:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02045bc:	fb74                	sd	a3,240(a4)
            proc->yptr = NULL;
ffffffffc02045be:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045c2:	7978                	ld	a4,240(a0)
ffffffffc02045c4:	10e7b023          	sd	a4,256(a5)
ffffffffc02045c8:	c311                	beqz	a4,ffffffffc02045cc <do_exit+0xa6>
                initproc->cptr->yptr = proc;
ffffffffc02045ca:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045cc:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02045ce:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02045d0:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045d2:	fcc71fe3          	bne	a4,a2,ffffffffc02045b0 <do_exit+0x8a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045d6:	0ec52783          	lw	a5,236(a0)
ffffffffc02045da:	fcb79be3          	bne	a5,a1,ffffffffc02045b0 <do_exit+0x8a>
                    wakeup_proc(initproc);
ffffffffc02045de:	415000ef          	jal	ffffffffc02051f2 <wakeup_proc>
ffffffffc02045e2:	800005b7          	lui	a1,0x80000
ffffffffc02045e6:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
ffffffffc02045e8:	460d                	li	a2,3
ffffffffc02045ea:	b7d9                	j	ffffffffc02045b0 <do_exit+0x8a>
    if (flag)
ffffffffc02045ec:	02091263          	bnez	s2,ffffffffc0204610 <do_exit+0xea>
    schedule();
ffffffffc02045f0:	497000ef          	jal	ffffffffc0205286 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02045f4:	601c                	ld	a5,0(s0)
ffffffffc02045f6:	00003617          	auipc	a2,0x3
ffffffffc02045fa:	b3260613          	addi	a2,a2,-1230 # ffffffffc0207128 <etext+0x187a>
ffffffffc02045fe:	24c00593          	li	a1,588
ffffffffc0204602:	43d4                	lw	a3,4(a5)
ffffffffc0204604:	00003517          	auipc	a0,0x3
ffffffffc0204608:	ac450513          	addi	a0,a0,-1340 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020460c:	e3bfb0ef          	jal	ffffffffc0200446 <__panic>
        intr_enable();
ffffffffc0204610:	aeefc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc0204614:	bff1                	j	ffffffffc02045f0 <do_exit+0xca>
        panic("idleproc exit.\n");
ffffffffc0204616:	00003617          	auipc	a2,0x3
ffffffffc020461a:	af260613          	addi	a2,a2,-1294 # ffffffffc0207108 <etext+0x185a>
ffffffffc020461e:	21800593          	li	a1,536
ffffffffc0204622:	00003517          	auipc	a0,0x3
ffffffffc0204626:	aa650513          	addi	a0,a0,-1370 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020462a:	e84a                	sd	s2,16(sp)
ffffffffc020462c:	e1bfb0ef          	jal	ffffffffc0200446 <__panic>
            exit_mmap(mm);
ffffffffc0204630:	e42a                	sd	a0,8(sp)
ffffffffc0204632:	cb8ff0ef          	jal	ffffffffc0203aea <exit_mmap>
            put_pgdir(mm);
ffffffffc0204636:	6522                	ld	a0,8(sp)
ffffffffc0204638:	a05ff0ef          	jal	ffffffffc020403c <put_pgdir>
            mm_destroy(mm);
ffffffffc020463c:	6522                	ld	a0,8(sp)
ffffffffc020463e:	af6ff0ef          	jal	ffffffffc0203934 <mm_destroy>
ffffffffc0204642:	bf15                	j	ffffffffc0204576 <do_exit+0x50>
        panic("initproc exit.\n");
ffffffffc0204644:	00003617          	auipc	a2,0x3
ffffffffc0204648:	ad460613          	addi	a2,a2,-1324 # ffffffffc0207118 <etext+0x186a>
ffffffffc020464c:	21c00593          	li	a1,540
ffffffffc0204650:	00003517          	auipc	a0,0x3
ffffffffc0204654:	a7850513          	addi	a0,a0,-1416 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204658:	deffb0ef          	jal	ffffffffc0200446 <__panic>
        intr_disable();
ffffffffc020465c:	aa8fc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0204660:	4905                	li	s2,1
ffffffffc0204662:	b735                	j	ffffffffc020458e <do_exit+0x68>
            wakeup_proc(proc);
ffffffffc0204664:	38f000ef          	jal	ffffffffc02051f2 <wakeup_proc>
ffffffffc0204668:	bf25                	j	ffffffffc02045a0 <do_exit+0x7a>

ffffffffc020466a <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020466a:	7179                	addi	sp,sp,-48
ffffffffc020466c:	ec26                	sd	s1,24(sp)
ffffffffc020466e:	e84a                	sd	s2,16(sp)
ffffffffc0204670:	e44e                	sd	s3,8(sp)
ffffffffc0204672:	f406                	sd	ra,40(sp)
ffffffffc0204674:	f022                	sd	s0,32(sp)
ffffffffc0204676:	84aa                	mv	s1,a0
ffffffffc0204678:	892e                	mv	s2,a1
ffffffffc020467a:	00097997          	auipc	s3,0x97
ffffffffc020467e:	66698993          	addi	s3,s3,1638 # ffffffffc029bce0 <current>
    if (pid != 0)
ffffffffc0204682:	cd19                	beqz	a0,ffffffffc02046a0 <do_wait.part.0+0x36>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204684:	6789                	lui	a5,0x2
ffffffffc0204686:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc0204688:	fff5071b          	addiw	a4,a0,-1
ffffffffc020468c:	12e7f563          	bgeu	a5,a4,ffffffffc02047b6 <do_wait.part.0+0x14c>
}
ffffffffc0204690:	70a2                	ld	ra,40(sp)
ffffffffc0204692:	7402                	ld	s0,32(sp)
ffffffffc0204694:	64e2                	ld	s1,24(sp)
ffffffffc0204696:	6942                	ld	s2,16(sp)
ffffffffc0204698:	69a2                	ld	s3,8(sp)
    return -E_BAD_PROC;
ffffffffc020469a:	5579                	li	a0,-2
}
ffffffffc020469c:	6145                	addi	sp,sp,48
ffffffffc020469e:	8082                	ret
        proc = current->cptr;
ffffffffc02046a0:	0009b703          	ld	a4,0(s3)
ffffffffc02046a4:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02046a6:	d46d                	beqz	s0,ffffffffc0204690 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046a8:	468d                	li	a3,3
ffffffffc02046aa:	a021                	j	ffffffffc02046b2 <do_wait.part.0+0x48>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02046ac:	10043403          	ld	s0,256(s0)
ffffffffc02046b0:	c075                	beqz	s0,ffffffffc0204794 <do_wait.part.0+0x12a>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02046b2:	401c                	lw	a5,0(s0)
ffffffffc02046b4:	fed79ce3          	bne	a5,a3,ffffffffc02046ac <do_wait.part.0+0x42>
    if (proc == idleproc || proc == initproc)
ffffffffc02046b8:	00097797          	auipc	a5,0x97
ffffffffc02046bc:	6387b783          	ld	a5,1592(a5) # ffffffffc029bcf0 <idleproc>
ffffffffc02046c0:	14878263          	beq	a5,s0,ffffffffc0204804 <do_wait.part.0+0x19a>
ffffffffc02046c4:	00097797          	auipc	a5,0x97
ffffffffc02046c8:	6247b783          	ld	a5,1572(a5) # ffffffffc029bce8 <initproc>
ffffffffc02046cc:	12f40c63          	beq	s0,a5,ffffffffc0204804 <do_wait.part.0+0x19a>
    if (code_store != NULL)
ffffffffc02046d0:	00090663          	beqz	s2,ffffffffc02046dc <do_wait.part.0+0x72>
        *code_store = proc->exit_code;
ffffffffc02046d4:	0e842783          	lw	a5,232(s0)
ffffffffc02046d8:	00f92023          	sw	a5,0(s2)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046dc:	100027f3          	csrr	a5,sstatus
ffffffffc02046e0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046e2:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046e4:	10079963          	bnez	a5,ffffffffc02047f6 <do_wait.part.0+0x18c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02046e8:	6c74                	ld	a3,216(s0)
ffffffffc02046ea:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL)
ffffffffc02046ec:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc02046f0:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02046f2:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc02046f4:	6474                	ld	a3,200(s0)
ffffffffc02046f6:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc02046f8:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02046fa:	e314                	sd	a3,0(a4)
ffffffffc02046fc:	c789                	beqz	a5,ffffffffc0204706 <do_wait.part.0+0x9c>
        proc->optr->yptr = proc->yptr;
ffffffffc02046fe:	7c78                	ld	a4,248(s0)
ffffffffc0204700:	fff8                	sd	a4,248(a5)
        proc->yptr->optr = proc->optr;
ffffffffc0204702:	10043783          	ld	a5,256(s0)
    if (proc->yptr != NULL)
ffffffffc0204706:	7c78                	ld	a4,248(s0)
ffffffffc0204708:	c36d                	beqz	a4,ffffffffc02047ea <do_wait.part.0+0x180>
        proc->yptr->optr = proc->optr;
ffffffffc020470a:	10f73023          	sd	a5,256(a4)
    nr_process--;
ffffffffc020470e:	00097797          	auipc	a5,0x97
ffffffffc0204712:	5ca7a783          	lw	a5,1482(a5) # ffffffffc029bcd8 <nr_process>
ffffffffc0204716:	37fd                	addiw	a5,a5,-1
ffffffffc0204718:	00097717          	auipc	a4,0x97
ffffffffc020471c:	5cf72023          	sw	a5,1472(a4) # ffffffffc029bcd8 <nr_process>
    if (flag)
ffffffffc0204720:	e271                	bnez	a2,ffffffffc02047e4 <do_wait.part.0+0x17a>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204722:	6814                	ld	a3,16(s0)
ffffffffc0204724:	c02007b7          	lui	a5,0xc0200
ffffffffc0204728:	10f6e663          	bltu	a3,a5,ffffffffc0204834 <do_wait.part.0+0x1ca>
ffffffffc020472c:	00097717          	auipc	a4,0x97
ffffffffc0204730:	59473703          	ld	a4,1428(a4) # ffffffffc029bcc0 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0204734:	00097797          	auipc	a5,0x97
ffffffffc0204738:	5947b783          	ld	a5,1428(a5) # ffffffffc029bcc8 <npage>
    return pa2page(PADDR(kva));
ffffffffc020473c:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage)
ffffffffc020473e:	82b1                	srli	a3,a3,0xc
ffffffffc0204740:	0cf6fe63          	bgeu	a3,a5,ffffffffc020481c <do_wait.part.0+0x1b2>
    return &pages[PPN(pa) - nbase];
ffffffffc0204744:	00003797          	auipc	a5,0x3
ffffffffc0204748:	30c7b783          	ld	a5,780(a5) # ffffffffc0207a50 <nbase>
ffffffffc020474c:	00097517          	auipc	a0,0x97
ffffffffc0204750:	58453503          	ld	a0,1412(a0) # ffffffffc029bcd0 <pages>
ffffffffc0204754:	4589                	li	a1,2
ffffffffc0204756:	8e9d                	sub	a3,a3,a5
ffffffffc0204758:	069a                	slli	a3,a3,0x6
ffffffffc020475a:	9536                	add	a0,a0,a3
ffffffffc020475c:	873fd0ef          	jal	ffffffffc0201fce <free_pages>
    kfree(proc);
ffffffffc0204760:	8522                	mv	a0,s0
ffffffffc0204762:	f14fd0ef          	jal	ffffffffc0201e76 <kfree>
}
ffffffffc0204766:	70a2                	ld	ra,40(sp)
ffffffffc0204768:	7402                	ld	s0,32(sp)
ffffffffc020476a:	64e2                	ld	s1,24(sp)
ffffffffc020476c:	6942                	ld	s2,16(sp)
ffffffffc020476e:	69a2                	ld	s3,8(sp)
    return 0;
ffffffffc0204770:	4501                	li	a0,0
}
ffffffffc0204772:	6145                	addi	sp,sp,48
ffffffffc0204774:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204776:	00097997          	auipc	s3,0x97
ffffffffc020477a:	56a98993          	addi	s3,s3,1386 # ffffffffc029bce0 <current>
ffffffffc020477e:	0009b703          	ld	a4,0(s3)
ffffffffc0204782:	f487b683          	ld	a3,-184(a5)
ffffffffc0204786:	f0e695e3          	bne	a3,a4,ffffffffc0204690 <do_wait.part.0+0x26>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020478a:	f287a603          	lw	a2,-216(a5)
ffffffffc020478e:	468d                	li	a3,3
ffffffffc0204790:	06d60063          	beq	a2,a3,ffffffffc02047f0 <do_wait.part.0+0x186>
        current->wait_state = WT_CHILD;
ffffffffc0204794:	800007b7          	lui	a5,0x80000
ffffffffc0204798:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_obj___user_exit_out_size+0xffffffff7fff5e49>
        current->state = PROC_SLEEPING;
ffffffffc020479a:	4685                	li	a3,1
        current->wait_state = WT_CHILD;
ffffffffc020479c:	0ef72623          	sw	a5,236(a4)
        current->state = PROC_SLEEPING;
ffffffffc02047a0:	c314                	sw	a3,0(a4)
        schedule();
ffffffffc02047a2:	2e5000ef          	jal	ffffffffc0205286 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02047a6:	0009b783          	ld	a5,0(s3)
ffffffffc02047aa:	0b07a783          	lw	a5,176(a5)
ffffffffc02047ae:	8b85                	andi	a5,a5,1
ffffffffc02047b0:	e7b9                	bnez	a5,ffffffffc02047fe <do_wait.part.0+0x194>
    if (pid != 0)
ffffffffc02047b2:	ee0487e3          	beqz	s1,ffffffffc02046a0 <do_wait.part.0+0x36>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02047b6:	45a9                	li	a1,10
ffffffffc02047b8:	8526                	mv	a0,s1
ffffffffc02047ba:	435000ef          	jal	ffffffffc02053ee <hash32>
ffffffffc02047be:	02051793          	slli	a5,a0,0x20
ffffffffc02047c2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02047c6:	00093797          	auipc	a5,0x93
ffffffffc02047ca:	4a278793          	addi	a5,a5,1186 # ffffffffc0297c68 <hash_list>
ffffffffc02047ce:	953e                	add	a0,a0,a5
ffffffffc02047d0:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02047d2:	a029                	j	ffffffffc02047dc <do_wait.part.0+0x172>
            if (proc->pid == pid)
ffffffffc02047d4:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02047d8:	f8970fe3          	beq	a4,s1,ffffffffc0204776 <do_wait.part.0+0x10c>
    return listelm->next;
ffffffffc02047dc:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02047de:	fef51be3          	bne	a0,a5,ffffffffc02047d4 <do_wait.part.0+0x16a>
ffffffffc02047e2:	b57d                	j	ffffffffc0204690 <do_wait.part.0+0x26>
        intr_enable();
ffffffffc02047e4:	91afc0ef          	jal	ffffffffc02008fe <intr_enable>
ffffffffc02047e8:	bf2d                	j	ffffffffc0204722 <do_wait.part.0+0xb8>
        proc->parent->cptr = proc->optr;
ffffffffc02047ea:	7018                	ld	a4,32(s0)
ffffffffc02047ec:	fb7c                	sd	a5,240(a4)
ffffffffc02047ee:	b705                	j	ffffffffc020470e <do_wait.part.0+0xa4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02047f0:	f2878413          	addi	s0,a5,-216
ffffffffc02047f4:	b5d1                	j	ffffffffc02046b8 <do_wait.part.0+0x4e>
        intr_disable();
ffffffffc02047f6:	90efc0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc02047fa:	4605                	li	a2,1
ffffffffc02047fc:	b5f5                	j	ffffffffc02046e8 <do_wait.part.0+0x7e>
            do_exit(-E_KILLED);
ffffffffc02047fe:	555d                	li	a0,-9
ffffffffc0204800:	d27ff0ef          	jal	ffffffffc0204526 <do_exit>
        panic("wait idleproc or initproc.\n");
ffffffffc0204804:	00003617          	auipc	a2,0x3
ffffffffc0204808:	94460613          	addi	a2,a2,-1724 # ffffffffc0207148 <etext+0x189a>
ffffffffc020480c:	36600593          	li	a1,870
ffffffffc0204810:	00003517          	auipc	a0,0x3
ffffffffc0204814:	8b850513          	addi	a0,a0,-1864 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204818:	c2ffb0ef          	jal	ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020481c:	00002617          	auipc	a2,0x2
ffffffffc0204820:	f4460613          	addi	a2,a2,-188 # ffffffffc0206760 <etext+0xeb2>
ffffffffc0204824:	06900593          	li	a1,105
ffffffffc0204828:	00002517          	auipc	a0,0x2
ffffffffc020482c:	e9050513          	addi	a0,a0,-368 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204830:	c17fb0ef          	jal	ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204834:	00002617          	auipc	a2,0x2
ffffffffc0204838:	f0460613          	addi	a2,a2,-252 # ffffffffc0206738 <etext+0xe8a>
ffffffffc020483c:	07700593          	li	a1,119
ffffffffc0204840:	00002517          	auipc	a0,0x2
ffffffffc0204844:	e7850513          	addi	a0,a0,-392 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204848:	bfffb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020484c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020484c:	1141                	addi	sp,sp,-16
ffffffffc020484e:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204850:	fb6fd0ef          	jal	ffffffffc0202006 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204854:	d78fd0ef          	jal	ffffffffc0201dcc <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204858:	4601                	li	a2,0
ffffffffc020485a:	4581                	li	a1,0
ffffffffc020485c:	fffff517          	auipc	a0,0xfffff
ffffffffc0204860:	76250513          	addi	a0,a0,1890 # ffffffffc0203fbe <user_main>
ffffffffc0204864:	c73ff0ef          	jal	ffffffffc02044d6 <kernel_thread>
    if (pid <= 0)
ffffffffc0204868:	00a04563          	bgtz	a0,ffffffffc0204872 <init_main+0x26>
ffffffffc020486c:	a071                	j	ffffffffc02048f8 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020486e:	219000ef          	jal	ffffffffc0205286 <schedule>
    if (code_store != NULL)
ffffffffc0204872:	4581                	li	a1,0
ffffffffc0204874:	4501                	li	a0,0
ffffffffc0204876:	df5ff0ef          	jal	ffffffffc020466a <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020487a:	d975                	beqz	a0,ffffffffc020486e <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020487c:	00003517          	auipc	a0,0x3
ffffffffc0204880:	90c50513          	addi	a0,a0,-1780 # ffffffffc0207188 <etext+0x18da>
ffffffffc0204884:	911fb0ef          	jal	ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204888:	00097797          	auipc	a5,0x97
ffffffffc020488c:	4607b783          	ld	a5,1120(a5) # ffffffffc029bce8 <initproc>
ffffffffc0204890:	7bf8                	ld	a4,240(a5)
ffffffffc0204892:	e339                	bnez	a4,ffffffffc02048d8 <init_main+0x8c>
ffffffffc0204894:	7ff8                	ld	a4,248(a5)
ffffffffc0204896:	e329                	bnez	a4,ffffffffc02048d8 <init_main+0x8c>
ffffffffc0204898:	1007b703          	ld	a4,256(a5)
ffffffffc020489c:	ef15                	bnez	a4,ffffffffc02048d8 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020489e:	00097697          	auipc	a3,0x97
ffffffffc02048a2:	43a6a683          	lw	a3,1082(a3) # ffffffffc029bcd8 <nr_process>
ffffffffc02048a6:	4709                	li	a4,2
ffffffffc02048a8:	0ae69463          	bne	a3,a4,ffffffffc0204950 <init_main+0x104>
ffffffffc02048ac:	00097697          	auipc	a3,0x97
ffffffffc02048b0:	3bc68693          	addi	a3,a3,956 # ffffffffc029bc68 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02048b4:	6698                	ld	a4,8(a3)
ffffffffc02048b6:	0c878793          	addi	a5,a5,200
ffffffffc02048ba:	06f71b63          	bne	a4,a5,ffffffffc0204930 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02048be:	629c                	ld	a5,0(a3)
ffffffffc02048c0:	04f71863          	bne	a4,a5,ffffffffc0204910 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02048c4:	00003517          	auipc	a0,0x3
ffffffffc02048c8:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0207270 <etext+0x19c2>
ffffffffc02048cc:	8c9fb0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02048d0:	60a2                	ld	ra,8(sp)
ffffffffc02048d2:	4501                	li	a0,0
ffffffffc02048d4:	0141                	addi	sp,sp,16
ffffffffc02048d6:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02048d8:	00003697          	auipc	a3,0x3
ffffffffc02048dc:	8d868693          	addi	a3,a3,-1832 # ffffffffc02071b0 <etext+0x1902>
ffffffffc02048e0:	00002617          	auipc	a2,0x2
ffffffffc02048e4:	a0060613          	addi	a2,a2,-1536 # ffffffffc02062e0 <etext+0xa32>
ffffffffc02048e8:	3d400593          	li	a1,980
ffffffffc02048ec:	00002517          	auipc	a0,0x2
ffffffffc02048f0:	7dc50513          	addi	a0,a0,2012 # ffffffffc02070c8 <etext+0x181a>
ffffffffc02048f4:	b53fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("create user_main failed.\n");
ffffffffc02048f8:	00003617          	auipc	a2,0x3
ffffffffc02048fc:	87060613          	addi	a2,a2,-1936 # ffffffffc0207168 <etext+0x18ba>
ffffffffc0204900:	3cb00593          	li	a1,971
ffffffffc0204904:	00002517          	auipc	a0,0x2
ffffffffc0204908:	7c450513          	addi	a0,a0,1988 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020490c:	b3bfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204910:	00003697          	auipc	a3,0x3
ffffffffc0204914:	93068693          	addi	a3,a3,-1744 # ffffffffc0207240 <etext+0x1992>
ffffffffc0204918:	00002617          	auipc	a2,0x2
ffffffffc020491c:	9c860613          	addi	a2,a2,-1592 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204920:	3d700593          	li	a1,983
ffffffffc0204924:	00002517          	auipc	a0,0x2
ffffffffc0204928:	7a450513          	addi	a0,a0,1956 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020492c:	b1bfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204930:	00003697          	auipc	a3,0x3
ffffffffc0204934:	8e068693          	addi	a3,a3,-1824 # ffffffffc0207210 <etext+0x1962>
ffffffffc0204938:	00002617          	auipc	a2,0x2
ffffffffc020493c:	9a860613          	addi	a2,a2,-1624 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204940:	3d600593          	li	a1,982
ffffffffc0204944:	00002517          	auipc	a0,0x2
ffffffffc0204948:	78450513          	addi	a0,a0,1924 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020494c:	afbfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(nr_process == 2);
ffffffffc0204950:	00003697          	auipc	a3,0x3
ffffffffc0204954:	8b068693          	addi	a3,a3,-1872 # ffffffffc0207200 <etext+0x1952>
ffffffffc0204958:	00002617          	auipc	a2,0x2
ffffffffc020495c:	98860613          	addi	a2,a2,-1656 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204960:	3d500593          	li	a1,981
ffffffffc0204964:	00002517          	auipc	a0,0x2
ffffffffc0204968:	76450513          	addi	a0,a0,1892 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020496c:	adbfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204970 <do_execve>:
{
ffffffffc0204970:	7171                	addi	sp,sp,-176
ffffffffc0204972:	e8ea                	sd	s10,80(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204974:	00097d17          	auipc	s10,0x97
ffffffffc0204978:	36cd0d13          	addi	s10,s10,876 # ffffffffc029bce0 <current>
ffffffffc020497c:	000d3783          	ld	a5,0(s10)
{
ffffffffc0204980:	e94a                	sd	s2,144(sp)
ffffffffc0204982:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204984:	0287b903          	ld	s2,40(a5)
{
ffffffffc0204988:	84ae                	mv	s1,a1
ffffffffc020498a:	e54e                	sd	s3,136(sp)
ffffffffc020498c:	ec32                	sd	a2,24(sp)
ffffffffc020498e:	89aa                	mv	s3,a0
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204990:	85aa                	mv	a1,a0
ffffffffc0204992:	8626                	mv	a2,s1
ffffffffc0204994:	854a                	mv	a0,s2
ffffffffc0204996:	4681                	li	a3,0
{
ffffffffc0204998:	f506                	sd	ra,168(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020499a:	ce8ff0ef          	jal	ffffffffc0203e82 <user_mem_check>
ffffffffc020499e:	46050f63          	beqz	a0,ffffffffc0204e1c <do_execve+0x4ac>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02049a2:	4641                	li	a2,16
ffffffffc02049a4:	1808                	addi	a0,sp,48
ffffffffc02049a6:	4581                	li	a1,0
ffffffffc02049a8:	6dd000ef          	jal	ffffffffc0205884 <memset>
    if (len > PROC_NAME_LEN)
ffffffffc02049ac:	47bd                	li	a5,15
ffffffffc02049ae:	8626                	mv	a2,s1
ffffffffc02049b0:	0e97ef63          	bltu	a5,s1,ffffffffc0204aae <do_execve+0x13e>
    memcpy(local_name, name, len);
ffffffffc02049b4:	85ce                	mv	a1,s3
ffffffffc02049b6:	1808                	addi	a0,sp,48
ffffffffc02049b8:	6df000ef          	jal	ffffffffc0205896 <memcpy>
    if (mm != NULL)
ffffffffc02049bc:	10090063          	beqz	s2,ffffffffc0204abc <do_execve+0x14c>
        cputs("mm != NULL");
ffffffffc02049c0:	00002517          	auipc	a0,0x2
ffffffffc02049c4:	4c850513          	addi	a0,a0,1224 # ffffffffc0206e88 <etext+0x15da>
ffffffffc02049c8:	803fb0ef          	jal	ffffffffc02001ca <cputs>
ffffffffc02049cc:	00097797          	auipc	a5,0x97
ffffffffc02049d0:	2e47b783          	ld	a5,740(a5) # ffffffffc029bcb0 <boot_pgdir_pa>
ffffffffc02049d4:	577d                	li	a4,-1
ffffffffc02049d6:	177e                	slli	a4,a4,0x3f
ffffffffc02049d8:	83b1                	srli	a5,a5,0xc
ffffffffc02049da:	8fd9                	or	a5,a5,a4
ffffffffc02049dc:	18079073          	csrw	satp,a5
ffffffffc02049e0:	03092783          	lw	a5,48(s2)
ffffffffc02049e4:	37fd                	addiw	a5,a5,-1
ffffffffc02049e6:	02f92823          	sw	a5,48(s2)
        if (mm_count_dec(mm) == 0)
ffffffffc02049ea:	30078563          	beqz	a5,ffffffffc0204cf4 <do_execve+0x384>
        current->mm = NULL;
ffffffffc02049ee:	000d3783          	ld	a5,0(s10)
ffffffffc02049f2:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02049f6:	e01fe0ef          	jal	ffffffffc02037f6 <mm_create>
ffffffffc02049fa:	892a                	mv	s2,a0
ffffffffc02049fc:	22050063          	beqz	a0,ffffffffc0204c1c <do_execve+0x2ac>
    if ((page = alloc_page()) == NULL)
ffffffffc0204a00:	4505                	li	a0,1
ffffffffc0204a02:	d92fd0ef          	jal	ffffffffc0201f94 <alloc_pages>
ffffffffc0204a06:	42050063          	beqz	a0,ffffffffc0204e26 <do_execve+0x4b6>
    return page - pages + nbase;
ffffffffc0204a0a:	f0e2                	sd	s8,96(sp)
ffffffffc0204a0c:	00097c17          	auipc	s8,0x97
ffffffffc0204a10:	2c4c0c13          	addi	s8,s8,708 # ffffffffc029bcd0 <pages>
ffffffffc0204a14:	000c3783          	ld	a5,0(s8)
ffffffffc0204a18:	f4de                	sd	s7,104(sp)
ffffffffc0204a1a:	00003b97          	auipc	s7,0x3
ffffffffc0204a1e:	036bbb83          	ld	s7,54(s7) # ffffffffc0207a50 <nbase>
ffffffffc0204a22:	40f506b3          	sub	a3,a0,a5
ffffffffc0204a26:	ece6                	sd	s9,88(sp)
    return KADDR(page2pa(page));
ffffffffc0204a28:	00097c97          	auipc	s9,0x97
ffffffffc0204a2c:	2a0c8c93          	addi	s9,s9,672 # ffffffffc029bcc8 <npage>
ffffffffc0204a30:	f8da                	sd	s6,112(sp)
    return page - pages + nbase;
ffffffffc0204a32:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204a34:	5b7d                	li	s6,-1
ffffffffc0204a36:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc0204a3a:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204a3c:	00cb5713          	srli	a4,s6,0xc
ffffffffc0204a40:	e83a                	sd	a4,16(sp)
ffffffffc0204a42:	fcd6                	sd	s5,120(sp)
ffffffffc0204a44:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a46:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a48:	40f77263          	bgeu	a4,a5,ffffffffc0204e4c <do_execve+0x4dc>
ffffffffc0204a4c:	00097a97          	auipc	s5,0x97
ffffffffc0204a50:	274a8a93          	addi	s5,s5,628 # ffffffffc029bcc0 <va_pa_offset>
ffffffffc0204a54:	000ab783          	ld	a5,0(s5)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204a58:	00097597          	auipc	a1,0x97
ffffffffc0204a5c:	2605b583          	ld	a1,608(a1) # ffffffffc029bcb8 <boot_pgdir_va>
ffffffffc0204a60:	6605                	lui	a2,0x1
ffffffffc0204a62:	00f684b3          	add	s1,a3,a5
ffffffffc0204a66:	8526                	mv	a0,s1
ffffffffc0204a68:	62f000ef          	jal	ffffffffc0205896 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a6c:	66e2                	ld	a3,24(sp)
ffffffffc0204a6e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204a72:	00993c23          	sd	s1,24(s2)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a76:	4298                	lw	a4,0(a3)
ffffffffc0204a78:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464ba3c7>
ffffffffc0204a7c:	06f70863          	beq	a4,a5,ffffffffc0204aec <do_execve+0x17c>
        ret = -E_INVAL_ELF;
ffffffffc0204a80:	54e1                	li	s1,-8
    put_pgdir(mm);
ffffffffc0204a82:	854a                	mv	a0,s2
ffffffffc0204a84:	db8ff0ef          	jal	ffffffffc020403c <put_pgdir>
ffffffffc0204a88:	7ae6                	ld	s5,120(sp)
ffffffffc0204a8a:	7b46                	ld	s6,112(sp)
ffffffffc0204a8c:	7ba6                	ld	s7,104(sp)
ffffffffc0204a8e:	7c06                	ld	s8,96(sp)
ffffffffc0204a90:	6ce6                	ld	s9,88(sp)
    mm_destroy(mm);
ffffffffc0204a92:	854a                	mv	a0,s2
ffffffffc0204a94:	ea1fe0ef          	jal	ffffffffc0203934 <mm_destroy>
    do_exit(ret);
ffffffffc0204a98:	8526                	mv	a0,s1
ffffffffc0204a9a:	f122                	sd	s0,160(sp)
ffffffffc0204a9c:	e152                	sd	s4,128(sp)
ffffffffc0204a9e:	fcd6                	sd	s5,120(sp)
ffffffffc0204aa0:	f8da                	sd	s6,112(sp)
ffffffffc0204aa2:	f4de                	sd	s7,104(sp)
ffffffffc0204aa4:	f0e2                	sd	s8,96(sp)
ffffffffc0204aa6:	ece6                	sd	s9,88(sp)
ffffffffc0204aa8:	e4ee                	sd	s11,72(sp)
ffffffffc0204aaa:	a7dff0ef          	jal	ffffffffc0204526 <do_exit>
    if (len > PROC_NAME_LEN)
ffffffffc0204aae:	863e                	mv	a2,a5
    memcpy(local_name, name, len);
ffffffffc0204ab0:	85ce                	mv	a1,s3
ffffffffc0204ab2:	1808                	addi	a0,sp,48
ffffffffc0204ab4:	5e3000ef          	jal	ffffffffc0205896 <memcpy>
    if (mm != NULL)
ffffffffc0204ab8:	f00914e3          	bnez	s2,ffffffffc02049c0 <do_execve+0x50>
    if (current->mm != NULL)
ffffffffc0204abc:	000d3783          	ld	a5,0(s10)
ffffffffc0204ac0:	779c                	ld	a5,40(a5)
ffffffffc0204ac2:	db95                	beqz	a5,ffffffffc02049f6 <do_execve+0x86>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204ac4:	00002617          	auipc	a2,0x2
ffffffffc0204ac8:	7cc60613          	addi	a2,a2,1996 # ffffffffc0207290 <etext+0x19e2>
ffffffffc0204acc:	25800593          	li	a1,600
ffffffffc0204ad0:	00002517          	auipc	a0,0x2
ffffffffc0204ad4:	5f850513          	addi	a0,a0,1528 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204ad8:	f122                	sd	s0,160(sp)
ffffffffc0204ada:	e152                	sd	s4,128(sp)
ffffffffc0204adc:	fcd6                	sd	s5,120(sp)
ffffffffc0204ade:	f8da                	sd	s6,112(sp)
ffffffffc0204ae0:	f4de                	sd	s7,104(sp)
ffffffffc0204ae2:	f0e2                	sd	s8,96(sp)
ffffffffc0204ae4:	ece6                	sd	s9,88(sp)
ffffffffc0204ae6:	e4ee                	sd	s11,72(sp)
ffffffffc0204ae8:	95ffb0ef          	jal	ffffffffc0200446 <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204aec:	0386d703          	lhu	a4,56(a3)
ffffffffc0204af0:	e152                	sd	s4,128(sp)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204af2:	0206ba03          	ld	s4,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204af6:	00371793          	slli	a5,a4,0x3
ffffffffc0204afa:	8f99                	sub	a5,a5,a4
ffffffffc0204afc:	078e                	slli	a5,a5,0x3
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204afe:	9a36                	add	s4,s4,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204b00:	97d2                	add	a5,a5,s4
ffffffffc0204b02:	f122                	sd	s0,160(sp)
ffffffffc0204b04:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204b06:	00fa7e63          	bgeu	s4,a5,ffffffffc0204b22 <do_execve+0x1b2>
ffffffffc0204b0a:	e4ee                	sd	s11,72(sp)
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204b0c:	000a2783          	lw	a5,0(s4)
ffffffffc0204b10:	4705                	li	a4,1
ffffffffc0204b12:	10e78763          	beq	a5,a4,ffffffffc0204c20 <do_execve+0x2b0>
    for (; ph < ph_end; ph++)
ffffffffc0204b16:	77a2                	ld	a5,40(sp)
ffffffffc0204b18:	038a0a13          	addi	s4,s4,56
ffffffffc0204b1c:	fefa68e3          	bltu	s4,a5,ffffffffc0204b0c <do_execve+0x19c>
ffffffffc0204b20:	6da6                	ld	s11,72(sp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204b22:	4701                	li	a4,0
ffffffffc0204b24:	46ad                	li	a3,11
ffffffffc0204b26:	00100637          	lui	a2,0x100
ffffffffc0204b2a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204b2e:	854a                	mv	a0,s2
ffffffffc0204b30:	e57fe0ef          	jal	ffffffffc0203986 <mm_map>
ffffffffc0204b34:	84aa                	mv	s1,a0
ffffffffc0204b36:	1a051963          	bnez	a0,ffffffffc0204ce8 <do_execve+0x378>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204b3a:	01893503          	ld	a0,24(s2)
ffffffffc0204b3e:	467d                	li	a2,31
ffffffffc0204b40:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204b44:	bd1fe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204b48:	3a050163          	beqz	a0,ffffffffc0204eea <do_execve+0x57a>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b4c:	01893503          	ld	a0,24(s2)
ffffffffc0204b50:	467d                	li	a2,31
ffffffffc0204b52:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204b56:	bbffe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204b5a:	36050763          	beqz	a0,ffffffffc0204ec8 <do_execve+0x558>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b5e:	01893503          	ld	a0,24(s2)
ffffffffc0204b62:	467d                	li	a2,31
ffffffffc0204b64:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204b68:	badfe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204b6c:	32050d63          	beqz	a0,ffffffffc0204ea6 <do_execve+0x536>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b70:	01893503          	ld	a0,24(s2)
ffffffffc0204b74:	467d                	li	a2,31
ffffffffc0204b76:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204b7a:	b9bfe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204b7e:	30050363          	beqz	a0,ffffffffc0204e84 <do_execve+0x514>
    mm->mm_count += 1;
ffffffffc0204b82:	03092783          	lw	a5,48(s2)
    current->mm = mm;
ffffffffc0204b86:	000d3603          	ld	a2,0(s10)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b8a:	01893683          	ld	a3,24(s2)
ffffffffc0204b8e:	2785                	addiw	a5,a5,1
ffffffffc0204b90:	02f92823          	sw	a5,48(s2)
    current->mm = mm;
ffffffffc0204b94:	03263423          	sd	s2,40(a2) # 100028 <_binary_obj___user_exit_out_size+0xf5e70>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b98:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b9c:	2cf6e763          	bltu	a3,a5,ffffffffc0204e6a <do_execve+0x4fa>
ffffffffc0204ba0:	000ab783          	ld	a5,0(s5)
ffffffffc0204ba4:	577d                	li	a4,-1
ffffffffc0204ba6:	177e                	slli	a4,a4,0x3f
ffffffffc0204ba8:	8e9d                	sub	a3,a3,a5
ffffffffc0204baa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204bae:	f654                	sd	a3,168(a2)
ffffffffc0204bb0:	8fd9                	or	a5,a5,a4
ffffffffc0204bb2:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204bb6:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204bb8:	4581                	li	a1,0
ffffffffc0204bba:	12000613          	li	a2,288
ffffffffc0204bbe:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204bc0:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204bc4:	4c1000ef          	jal	ffffffffc0205884 <memset>
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc0204bc8:	67e2                	ld	a5,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204bca:	000d3983          	ld	s3,0(s10)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc0204bce:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc0204bd2:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP; // 用户栈顶
ffffffffc0204bd4:	4785                	li	a5,1
ffffffffc0204bd6:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc0204bd8:	02096913          	ori	s2,s2,32
    tf->epc = elf->e_entry; // 用户程序入口
ffffffffc0204bdc:	10e43423          	sd	a4,264(s0)
    tf->gpr.sp = USTACKTOP; // 用户栈顶
ffffffffc0204be0:	e81c                	sd	a5,16(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE; // 设置为用户模式，允许中断
ffffffffc0204be2:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204be6:	4641                	li	a2,16
ffffffffc0204be8:	4581                	li	a1,0
ffffffffc0204bea:	0b498513          	addi	a0,s3,180
ffffffffc0204bee:	497000ef          	jal	ffffffffc0205884 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204bf2:	180c                	addi	a1,sp,48
ffffffffc0204bf4:	0b498513          	addi	a0,s3,180
ffffffffc0204bf8:	463d                	li	a2,15
ffffffffc0204bfa:	49d000ef          	jal	ffffffffc0205896 <memcpy>
ffffffffc0204bfe:	740a                	ld	s0,160(sp)
ffffffffc0204c00:	6a0a                	ld	s4,128(sp)
ffffffffc0204c02:	7ae6                	ld	s5,120(sp)
ffffffffc0204c04:	7b46                	ld	s6,112(sp)
ffffffffc0204c06:	7ba6                	ld	s7,104(sp)
ffffffffc0204c08:	7c06                	ld	s8,96(sp)
ffffffffc0204c0a:	6ce6                	ld	s9,88(sp)
}
ffffffffc0204c0c:	70aa                	ld	ra,168(sp)
ffffffffc0204c0e:	694a                	ld	s2,144(sp)
ffffffffc0204c10:	69aa                	ld	s3,136(sp)
ffffffffc0204c12:	6d46                	ld	s10,80(sp)
ffffffffc0204c14:	8526                	mv	a0,s1
ffffffffc0204c16:	64ea                	ld	s1,152(sp)
ffffffffc0204c18:	614d                	addi	sp,sp,176
ffffffffc0204c1a:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0204c1c:	54f1                	li	s1,-4
ffffffffc0204c1e:	bdad                	j	ffffffffc0204a98 <do_execve+0x128>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204c20:	028a3603          	ld	a2,40(s4)
ffffffffc0204c24:	020a3783          	ld	a5,32(s4)
ffffffffc0204c28:	20f66363          	bltu	a2,a5,ffffffffc0204e2e <do_execve+0x4be>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204c2c:	004a2783          	lw	a5,4(s4)
ffffffffc0204c30:	0027971b          	slliw	a4,a5,0x2
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c34:	0027f693          	andi	a3,a5,2
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204c38:	8b11                	andi	a4,a4,4
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c3a:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c3c:	c6f1                	beqz	a3,ffffffffc0204d08 <do_execve+0x398>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c3e:	1c079763          	bnez	a5,ffffffffc0204e0c <do_execve+0x49c>
            perm |= (PTE_W | PTE_R);
ffffffffc0204c42:	47dd                	li	a5,23
            vm_flags |= VM_WRITE;
ffffffffc0204c44:	00276693          	ori	a3,a4,2
            perm |= (PTE_W | PTE_R);
ffffffffc0204c48:	e43e                	sd	a5,8(sp)
        if (vm_flags & VM_EXEC)
ffffffffc0204c4a:	c709                	beqz	a4,ffffffffc0204c54 <do_execve+0x2e4>
            perm |= PTE_X;
ffffffffc0204c4c:	67a2                	ld	a5,8(sp)
ffffffffc0204c4e:	0087e793          	ori	a5,a5,8
ffffffffc0204c52:	e43e                	sd	a5,8(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204c54:	010a3583          	ld	a1,16(s4)
ffffffffc0204c58:	4701                	li	a4,0
ffffffffc0204c5a:	854a                	mv	a0,s2
ffffffffc0204c5c:	d2bfe0ef          	jal	ffffffffc0203986 <mm_map>
ffffffffc0204c60:	84aa                	mv	s1,a0
ffffffffc0204c62:	1c051463          	bnez	a0,ffffffffc0204e2a <do_execve+0x4ba>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c66:	010a3b03          	ld	s6,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c6a:	020a3483          	ld	s1,32(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c6e:	77fd                	lui	a5,0xfffff
ffffffffc0204c70:	00fb75b3          	and	a1,s6,a5
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c74:	94da                	add	s1,s1,s6
        while (start < end)
ffffffffc0204c76:	1a9b7563          	bgeu	s6,s1,ffffffffc0204e20 <do_execve+0x4b0>
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c7a:	008a3983          	ld	s3,8(s4)
ffffffffc0204c7e:	67e2                	ld	a5,24(sp)
ffffffffc0204c80:	99be                	add	s3,s3,a5
ffffffffc0204c82:	a881                	j	ffffffffc0204cd2 <do_execve+0x362>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c84:	6785                	lui	a5,0x1
ffffffffc0204c86:	00f58db3          	add	s11,a1,a5
                size -= la - end;
ffffffffc0204c8a:	41648633          	sub	a2,s1,s6
            if (end < la)
ffffffffc0204c8e:	01b4e463          	bltu	s1,s11,ffffffffc0204c96 <do_execve+0x326>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c92:	416d8633          	sub	a2,s11,s6
    return page - pages + nbase;
ffffffffc0204c96:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204c9a:	67c2                	ld	a5,16(sp)
ffffffffc0204c9c:	000cb503          	ld	a0,0(s9)
    return page - pages + nbase;
ffffffffc0204ca0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ca4:	8699                	srai	a3,a3,0x6
ffffffffc0204ca6:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204ca8:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204cac:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204cae:	18a87363          	bgeu	a6,a0,ffffffffc0204e34 <do_execve+0x4c4>
ffffffffc0204cb2:	000ab503          	ld	a0,0(s5)
ffffffffc0204cb6:	40bb05b3          	sub	a1,s6,a1
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204cba:	e032                	sd	a2,0(sp)
ffffffffc0204cbc:	9536                	add	a0,a0,a3
ffffffffc0204cbe:	952e                	add	a0,a0,a1
ffffffffc0204cc0:	85ce                	mv	a1,s3
ffffffffc0204cc2:	3d5000ef          	jal	ffffffffc0205896 <memcpy>
            start += size, from += size;
ffffffffc0204cc6:	6602                	ld	a2,0(sp)
ffffffffc0204cc8:	9b32                	add	s6,s6,a2
ffffffffc0204cca:	99b2                	add	s3,s3,a2
        while (start < end)
ffffffffc0204ccc:	049b7563          	bgeu	s6,s1,ffffffffc0204d16 <do_execve+0x3a6>
ffffffffc0204cd0:	85ee                	mv	a1,s11
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204cd2:	01893503          	ld	a0,24(s2)
ffffffffc0204cd6:	6622                	ld	a2,8(sp)
ffffffffc0204cd8:	e02e                	sd	a1,0(sp)
ffffffffc0204cda:	a3bfe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204cde:	6582                	ld	a1,0(sp)
ffffffffc0204ce0:	842a                	mv	s0,a0
ffffffffc0204ce2:	f14d                	bnez	a0,ffffffffc0204c84 <do_execve+0x314>
ffffffffc0204ce4:	6da6                	ld	s11,72(sp)
        ret = -E_NO_MEM;
ffffffffc0204ce6:	54f1                	li	s1,-4
    exit_mmap(mm);
ffffffffc0204ce8:	854a                	mv	a0,s2
ffffffffc0204cea:	e01fe0ef          	jal	ffffffffc0203aea <exit_mmap>
ffffffffc0204cee:	740a                	ld	s0,160(sp)
ffffffffc0204cf0:	6a0a                	ld	s4,128(sp)
ffffffffc0204cf2:	bb41                	j	ffffffffc0204a82 <do_execve+0x112>
            exit_mmap(mm);
ffffffffc0204cf4:	854a                	mv	a0,s2
ffffffffc0204cf6:	df5fe0ef          	jal	ffffffffc0203aea <exit_mmap>
            put_pgdir(mm);
ffffffffc0204cfa:	854a                	mv	a0,s2
ffffffffc0204cfc:	b40ff0ef          	jal	ffffffffc020403c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204d00:	854a                	mv	a0,s2
ffffffffc0204d02:	c33fe0ef          	jal	ffffffffc0203934 <mm_destroy>
ffffffffc0204d06:	b1e5                	j	ffffffffc02049ee <do_execve+0x7e>
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d08:	0e078e63          	beqz	a5,ffffffffc0204e04 <do_execve+0x494>
            perm |= PTE_R;
ffffffffc0204d0c:	47cd                	li	a5,19
            vm_flags |= VM_READ;
ffffffffc0204d0e:	00176693          	ori	a3,a4,1
            perm |= PTE_R;
ffffffffc0204d12:	e43e                	sd	a5,8(sp)
ffffffffc0204d14:	bf1d                	j	ffffffffc0204c4a <do_execve+0x2da>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204d16:	010a3483          	ld	s1,16(s4)
ffffffffc0204d1a:	028a3683          	ld	a3,40(s4)
ffffffffc0204d1e:	94b6                	add	s1,s1,a3
        if (start < la)
ffffffffc0204d20:	07bb7c63          	bgeu	s6,s11,ffffffffc0204d98 <do_execve+0x428>
            if (start == end)
ffffffffc0204d24:	df6489e3          	beq	s1,s6,ffffffffc0204b16 <do_execve+0x1a6>
                size -= la - end;
ffffffffc0204d28:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204d2c:	0fb4f563          	bgeu	s1,s11,ffffffffc0204e16 <do_execve+0x4a6>
    return page - pages + nbase;
ffffffffc0204d30:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204d34:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0204d38:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d3c:	8699                	srai	a3,a3,0x6
ffffffffc0204d3e:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204d40:	00c69593          	slli	a1,a3,0xc
ffffffffc0204d44:	81b1                	srli	a1,a1,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d46:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d48:	0ec5f663          	bgeu	a1,a2,ffffffffc0204e34 <do_execve+0x4c4>
ffffffffc0204d4c:	000ab603          	ld	a2,0(s5)
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204d50:	6505                	lui	a0,0x1
ffffffffc0204d52:	955a                	add	a0,a0,s6
ffffffffc0204d54:	96b2                	add	a3,a3,a2
ffffffffc0204d56:	41b50533          	sub	a0,a0,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204d5a:	9536                	add	a0,a0,a3
ffffffffc0204d5c:	864e                	mv	a2,s3
ffffffffc0204d5e:	4581                	li	a1,0
ffffffffc0204d60:	325000ef          	jal	ffffffffc0205884 <memset>
            start += size;
ffffffffc0204d64:	9b4e                	add	s6,s6,s3
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204d66:	01b4b6b3          	sltu	a3,s1,s11
ffffffffc0204d6a:	01b4f463          	bgeu	s1,s11,ffffffffc0204d72 <do_execve+0x402>
ffffffffc0204d6e:	db6484e3          	beq	s1,s6,ffffffffc0204b16 <do_execve+0x1a6>
ffffffffc0204d72:	e299                	bnez	a3,ffffffffc0204d78 <do_execve+0x408>
ffffffffc0204d74:	03bb0263          	beq	s6,s11,ffffffffc0204d98 <do_execve+0x428>
ffffffffc0204d78:	00002697          	auipc	a3,0x2
ffffffffc0204d7c:	54068693          	addi	a3,a3,1344 # ffffffffc02072b8 <etext+0x1a0a>
ffffffffc0204d80:	00001617          	auipc	a2,0x1
ffffffffc0204d84:	56060613          	addi	a2,a2,1376 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204d88:	2c100593          	li	a1,705
ffffffffc0204d8c:	00002517          	auipc	a0,0x2
ffffffffc0204d90:	33c50513          	addi	a0,a0,828 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204d94:	eb2fb0ef          	jal	ffffffffc0200446 <__panic>
        while (start < end)
ffffffffc0204d98:	d69b7fe3          	bgeu	s6,s1,ffffffffc0204b16 <do_execve+0x1a6>
ffffffffc0204d9c:	56fd                	li	a3,-1
ffffffffc0204d9e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204da2:	f03e                	sd	a5,32(sp)
ffffffffc0204da4:	a0b9                	j	ffffffffc0204df2 <do_execve+0x482>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204da6:	6785                	lui	a5,0x1
ffffffffc0204da8:	00fd8833          	add	a6,s11,a5
                size -= la - end;
ffffffffc0204dac:	416489b3          	sub	s3,s1,s6
            if (end < la)
ffffffffc0204db0:	0104e463          	bltu	s1,a6,ffffffffc0204db8 <do_execve+0x448>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204db4:	416809b3          	sub	s3,a6,s6
    return page - pages + nbase;
ffffffffc0204db8:	000c3683          	ld	a3,0(s8)
    return KADDR(page2pa(page));
ffffffffc0204dbc:	7782                	ld	a5,32(sp)
ffffffffc0204dbe:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204dc2:	40d406b3          	sub	a3,s0,a3
ffffffffc0204dc6:	8699                	srai	a3,a3,0x6
ffffffffc0204dc8:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0204dca:	00f6f533          	and	a0,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204dce:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204dd0:	06b57263          	bgeu	a0,a1,ffffffffc0204e34 <do_execve+0x4c4>
ffffffffc0204dd4:	000ab583          	ld	a1,0(s5)
ffffffffc0204dd8:	41bb0533          	sub	a0,s6,s11
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ddc:	864e                	mv	a2,s3
ffffffffc0204dde:	96ae                	add	a3,a3,a1
ffffffffc0204de0:	9536                	add	a0,a0,a3
ffffffffc0204de2:	4581                	li	a1,0
            start += size;
ffffffffc0204de4:	9b4e                	add	s6,s6,s3
ffffffffc0204de6:	e042                	sd	a6,0(sp)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204de8:	29d000ef          	jal	ffffffffc0205884 <memset>
        while (start < end)
ffffffffc0204dec:	d29b75e3          	bgeu	s6,s1,ffffffffc0204b16 <do_execve+0x1a6>
ffffffffc0204df0:	6d82                	ld	s11,0(sp)
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204df2:	01893503          	ld	a0,24(s2)
ffffffffc0204df6:	6622                	ld	a2,8(sp)
ffffffffc0204df8:	85ee                	mv	a1,s11
ffffffffc0204dfa:	91bfe0ef          	jal	ffffffffc0203714 <pgdir_alloc_page>
ffffffffc0204dfe:	842a                	mv	s0,a0
ffffffffc0204e00:	f15d                	bnez	a0,ffffffffc0204da6 <do_execve+0x436>
ffffffffc0204e02:	b5cd                	j	ffffffffc0204ce4 <do_execve+0x374>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204e04:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e06:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204e08:	e43e                	sd	a5,8(sp)
ffffffffc0204e0a:	b581                	j	ffffffffc0204c4a <do_execve+0x2da>
            perm |= (PTE_W | PTE_R);
ffffffffc0204e0c:	47dd                	li	a5,23
            vm_flags |= VM_READ;
ffffffffc0204e0e:	00376693          	ori	a3,a4,3
            perm |= (PTE_W | PTE_R);
ffffffffc0204e12:	e43e                	sd	a5,8(sp)
ffffffffc0204e14:	bd1d                	j	ffffffffc0204c4a <do_execve+0x2da>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204e16:	416d89b3          	sub	s3,s11,s6
ffffffffc0204e1a:	bf19                	j	ffffffffc0204d30 <do_execve+0x3c0>
        return -E_INVAL;
ffffffffc0204e1c:	54f5                	li	s1,-3
ffffffffc0204e1e:	b3fd                	j	ffffffffc0204c0c <do_execve+0x29c>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e20:	8dae                	mv	s11,a1
        while (start < end)
ffffffffc0204e22:	84da                	mv	s1,s6
ffffffffc0204e24:	bddd                	j	ffffffffc0204d1a <do_execve+0x3aa>
    int ret = -E_NO_MEM;
ffffffffc0204e26:	54f1                	li	s1,-4
ffffffffc0204e28:	b1ad                	j	ffffffffc0204a92 <do_execve+0x122>
ffffffffc0204e2a:	6da6                	ld	s11,72(sp)
ffffffffc0204e2c:	bd75                	j	ffffffffc0204ce8 <do_execve+0x378>
            ret = -E_INVAL_ELF;
ffffffffc0204e2e:	6da6                	ld	s11,72(sp)
ffffffffc0204e30:	54e1                	li	s1,-8
ffffffffc0204e32:	bd5d                	j	ffffffffc0204ce8 <do_execve+0x378>
ffffffffc0204e34:	00002617          	auipc	a2,0x2
ffffffffc0204e38:	85c60613          	addi	a2,a2,-1956 # ffffffffc0206690 <etext+0xde2>
ffffffffc0204e3c:	07100593          	li	a1,113
ffffffffc0204e40:	00002517          	auipc	a0,0x2
ffffffffc0204e44:	87850513          	addi	a0,a0,-1928 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204e48:	dfefb0ef          	jal	ffffffffc0200446 <__panic>
ffffffffc0204e4c:	00002617          	auipc	a2,0x2
ffffffffc0204e50:	84460613          	addi	a2,a2,-1980 # ffffffffc0206690 <etext+0xde2>
ffffffffc0204e54:	07100593          	li	a1,113
ffffffffc0204e58:	00002517          	auipc	a0,0x2
ffffffffc0204e5c:	86050513          	addi	a0,a0,-1952 # ffffffffc02066b8 <etext+0xe0a>
ffffffffc0204e60:	f122                	sd	s0,160(sp)
ffffffffc0204e62:	e152                	sd	s4,128(sp)
ffffffffc0204e64:	e4ee                	sd	s11,72(sp)
ffffffffc0204e66:	de0fb0ef          	jal	ffffffffc0200446 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204e6a:	00002617          	auipc	a2,0x2
ffffffffc0204e6e:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0206738 <etext+0xe8a>
ffffffffc0204e72:	2e000593          	li	a1,736
ffffffffc0204e76:	00002517          	auipc	a0,0x2
ffffffffc0204e7a:	25250513          	addi	a0,a0,594 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204e7e:	e4ee                	sd	s11,72(sp)
ffffffffc0204e80:	dc6fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e84:	00002697          	auipc	a3,0x2
ffffffffc0204e88:	54c68693          	addi	a3,a3,1356 # ffffffffc02073d0 <etext+0x1b22>
ffffffffc0204e8c:	00001617          	auipc	a2,0x1
ffffffffc0204e90:	45460613          	addi	a2,a2,1108 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204e94:	2db00593          	li	a1,731
ffffffffc0204e98:	00002517          	auipc	a0,0x2
ffffffffc0204e9c:	23050513          	addi	a0,a0,560 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204ea0:	e4ee                	sd	s11,72(sp)
ffffffffc0204ea2:	da4fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ea6:	00002697          	auipc	a3,0x2
ffffffffc0204eaa:	4e268693          	addi	a3,a3,1250 # ffffffffc0207388 <etext+0x1ada>
ffffffffc0204eae:	00001617          	auipc	a2,0x1
ffffffffc0204eb2:	43260613          	addi	a2,a2,1074 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204eb6:	2da00593          	li	a1,730
ffffffffc0204eba:	00002517          	auipc	a0,0x2
ffffffffc0204ebe:	20e50513          	addi	a0,a0,526 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204ec2:	e4ee                	sd	s11,72(sp)
ffffffffc0204ec4:	d82fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ec8:	00002697          	auipc	a3,0x2
ffffffffc0204ecc:	47868693          	addi	a3,a3,1144 # ffffffffc0207340 <etext+0x1a92>
ffffffffc0204ed0:	00001617          	auipc	a2,0x1
ffffffffc0204ed4:	41060613          	addi	a2,a2,1040 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204ed8:	2d900593          	li	a1,729
ffffffffc0204edc:	00002517          	auipc	a0,0x2
ffffffffc0204ee0:	1ec50513          	addi	a0,a0,492 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204ee4:	e4ee                	sd	s11,72(sp)
ffffffffc0204ee6:	d60fb0ef          	jal	ffffffffc0200446 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204eea:	00002697          	auipc	a3,0x2
ffffffffc0204eee:	40e68693          	addi	a3,a3,1038 # ffffffffc02072f8 <etext+0x1a4a>
ffffffffc0204ef2:	00001617          	auipc	a2,0x1
ffffffffc0204ef6:	3ee60613          	addi	a2,a2,1006 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0204efa:	2d800593          	li	a1,728
ffffffffc0204efe:	00002517          	auipc	a0,0x2
ffffffffc0204f02:	1ca50513          	addi	a0,a0,458 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0204f06:	e4ee                	sd	s11,72(sp)
ffffffffc0204f08:	d3efb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0204f0c <do_yield>:
    current->need_resched = 1;
ffffffffc0204f0c:	00097797          	auipc	a5,0x97
ffffffffc0204f10:	dd47b783          	ld	a5,-556(a5) # ffffffffc029bce0 <current>
ffffffffc0204f14:	4705                	li	a4,1
}
ffffffffc0204f16:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0204f18:	ef98                	sd	a4,24(a5)
}
ffffffffc0204f1a:	8082                	ret

ffffffffc0204f1c <do_wait>:
    if (code_store != NULL)
ffffffffc0204f1c:	c59d                	beqz	a1,ffffffffc0204f4a <do_wait+0x2e>
{
ffffffffc0204f1e:	1101                	addi	sp,sp,-32
ffffffffc0204f20:	e02a                	sd	a0,0(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204f22:	00097517          	auipc	a0,0x97
ffffffffc0204f26:	dbe53503          	ld	a0,-578(a0) # ffffffffc029bce0 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f2a:	4685                	li	a3,1
ffffffffc0204f2c:	4611                	li	a2,4
ffffffffc0204f2e:	7508                	ld	a0,40(a0)
{
ffffffffc0204f30:	ec06                	sd	ra,24(sp)
ffffffffc0204f32:	e42e                	sd	a1,8(sp)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204f34:	f4ffe0ef          	jal	ffffffffc0203e82 <user_mem_check>
ffffffffc0204f38:	6702                	ld	a4,0(sp)
ffffffffc0204f3a:	67a2                	ld	a5,8(sp)
ffffffffc0204f3c:	c909                	beqz	a0,ffffffffc0204f4e <do_wait+0x32>
}
ffffffffc0204f3e:	60e2                	ld	ra,24(sp)
ffffffffc0204f40:	85be                	mv	a1,a5
ffffffffc0204f42:	853a                	mv	a0,a4
ffffffffc0204f44:	6105                	addi	sp,sp,32
ffffffffc0204f46:	f24ff06f          	j	ffffffffc020466a <do_wait.part.0>
ffffffffc0204f4a:	f20ff06f          	j	ffffffffc020466a <do_wait.part.0>
ffffffffc0204f4e:	60e2                	ld	ra,24(sp)
ffffffffc0204f50:	5575                	li	a0,-3
ffffffffc0204f52:	6105                	addi	sp,sp,32
ffffffffc0204f54:	8082                	ret

ffffffffc0204f56 <do_kill>:
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f56:	6789                	lui	a5,0x2
ffffffffc0204f58:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204f5c:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc0204f5e:	06e7e463          	bltu	a5,a4,ffffffffc0204fc6 <do_kill+0x70>
{
ffffffffc0204f62:	1101                	addi	sp,sp,-32
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f64:	45a9                	li	a1,10
{
ffffffffc0204f66:	ec06                	sd	ra,24(sp)
ffffffffc0204f68:	e42a                	sd	a0,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f6a:	484000ef          	jal	ffffffffc02053ee <hash32>
ffffffffc0204f6e:	02051793          	slli	a5,a0,0x20
ffffffffc0204f72:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204f76:	00093797          	auipc	a5,0x93
ffffffffc0204f7a:	cf278793          	addi	a5,a5,-782 # ffffffffc0297c68 <hash_list>
ffffffffc0204f7e:	96be                	add	a3,a3,a5
        while ((le = list_next(le)) != list)
ffffffffc0204f80:	6622                	ld	a2,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f82:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list)
ffffffffc0204f84:	a029                	j	ffffffffc0204f8e <do_kill+0x38>
            if (proc->pid == pid)
ffffffffc0204f86:	f2c52703          	lw	a4,-212(a0)
ffffffffc0204f8a:	00c70963          	beq	a4,a2,ffffffffc0204f9c <do_kill+0x46>
ffffffffc0204f8e:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list)
ffffffffc0204f90:	fea69be3          	bne	a3,a0,ffffffffc0204f86 <do_kill+0x30>
}
ffffffffc0204f94:	60e2                	ld	ra,24(sp)
    return -E_INVAL;
ffffffffc0204f96:	5575                	li	a0,-3
}
ffffffffc0204f98:	6105                	addi	sp,sp,32
ffffffffc0204f9a:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204f9c:	fd852703          	lw	a4,-40(a0)
ffffffffc0204fa0:	00177693          	andi	a3,a4,1
ffffffffc0204fa4:	e29d                	bnez	a3,ffffffffc0204fca <do_kill+0x74>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204fa6:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc0204fa8:	00176713          	ori	a4,a4,1
ffffffffc0204fac:	fce52c23          	sw	a4,-40(a0)
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204fb0:	0006c663          	bltz	a3,ffffffffc0204fbc <do_kill+0x66>
            return 0;
ffffffffc0204fb4:	4501                	li	a0,0
}
ffffffffc0204fb6:	60e2                	ld	ra,24(sp)
ffffffffc0204fb8:	6105                	addi	sp,sp,32
ffffffffc0204fba:	8082                	ret
                wakeup_proc(proc);
ffffffffc0204fbc:	f2850513          	addi	a0,a0,-216
ffffffffc0204fc0:	232000ef          	jal	ffffffffc02051f2 <wakeup_proc>
ffffffffc0204fc4:	bfc5                	j	ffffffffc0204fb4 <do_kill+0x5e>
    return -E_INVAL;
ffffffffc0204fc6:	5575                	li	a0,-3
}
ffffffffc0204fc8:	8082                	ret
        return -E_KILLED;
ffffffffc0204fca:	555d                	li	a0,-9
ffffffffc0204fcc:	b7ed                	j	ffffffffc0204fb6 <do_kill+0x60>

ffffffffc0204fce <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204fce:	1101                	addi	sp,sp,-32
ffffffffc0204fd0:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204fd2:	00097797          	auipc	a5,0x97
ffffffffc0204fd6:	c9678793          	addi	a5,a5,-874 # ffffffffc029bc68 <proc_list>
ffffffffc0204fda:	ec06                	sd	ra,24(sp)
ffffffffc0204fdc:	e822                	sd	s0,16(sp)
ffffffffc0204fde:	e04a                	sd	s2,0(sp)
ffffffffc0204fe0:	00093497          	auipc	s1,0x93
ffffffffc0204fe4:	c8848493          	addi	s1,s1,-888 # ffffffffc0297c68 <hash_list>
ffffffffc0204fe8:	e79c                	sd	a5,8(a5)
ffffffffc0204fea:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204fec:	00097717          	auipc	a4,0x97
ffffffffc0204ff0:	c7c70713          	addi	a4,a4,-900 # ffffffffc029bc68 <proc_list>
ffffffffc0204ff4:	87a6                	mv	a5,s1
ffffffffc0204ff6:	e79c                	sd	a5,8(a5)
ffffffffc0204ff8:	e39c                	sd	a5,0(a5)
ffffffffc0204ffa:	07c1                	addi	a5,a5,16
ffffffffc0204ffc:	fee79de3          	bne	a5,a4,ffffffffc0204ff6 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205000:	f2ffe0ef          	jal	ffffffffc0203f2e <alloc_proc>
ffffffffc0205004:	00097917          	auipc	s2,0x97
ffffffffc0205008:	cec90913          	addi	s2,s2,-788 # ffffffffc029bcf0 <idleproc>
ffffffffc020500c:	00a93023          	sd	a0,0(s2)
ffffffffc0205010:	10050363          	beqz	a0,ffffffffc0205116 <proc_init+0x148>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205014:	4789                	li	a5,2
ffffffffc0205016:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205018:	00003797          	auipc	a5,0x3
ffffffffc020501c:	fe878793          	addi	a5,a5,-24 # ffffffffc0208000 <bootstack>
ffffffffc0205020:	e91c                	sd	a5,16(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205022:	0b450413          	addi	s0,a0,180
    idleproc->need_resched = 1;
ffffffffc0205026:	4785                	li	a5,1
ffffffffc0205028:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020502a:	4641                	li	a2,16
ffffffffc020502c:	8522                	mv	a0,s0
ffffffffc020502e:	4581                	li	a1,0
ffffffffc0205030:	055000ef          	jal	ffffffffc0205884 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205034:	8522                	mv	a0,s0
ffffffffc0205036:	463d                	li	a2,15
ffffffffc0205038:	00002597          	auipc	a1,0x2
ffffffffc020503c:	3f858593          	addi	a1,a1,1016 # ffffffffc0207430 <etext+0x1b82>
ffffffffc0205040:	057000ef          	jal	ffffffffc0205896 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205044:	00097797          	auipc	a5,0x97
ffffffffc0205048:	c947a783          	lw	a5,-876(a5) # ffffffffc029bcd8 <nr_process>

    current = idleproc;
ffffffffc020504c:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205050:	4601                	li	a2,0
    nr_process++;
ffffffffc0205052:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205054:	4581                	li	a1,0
ffffffffc0205056:	fffff517          	auipc	a0,0xfffff
ffffffffc020505a:	7f650513          	addi	a0,a0,2038 # ffffffffc020484c <init_main>
    current = idleproc;
ffffffffc020505e:	00097697          	auipc	a3,0x97
ffffffffc0205062:	c8e6b123          	sd	a4,-894(a3) # ffffffffc029bce0 <current>
    nr_process++;
ffffffffc0205066:	00097717          	auipc	a4,0x97
ffffffffc020506a:	c6f72923          	sw	a5,-910(a4) # ffffffffc029bcd8 <nr_process>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020506e:	c68ff0ef          	jal	ffffffffc02044d6 <kernel_thread>
ffffffffc0205072:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0205074:	08a05563          	blez	a0,ffffffffc02050fe <proc_init+0x130>
    if (0 < pid && pid < MAX_PID)
ffffffffc0205078:	6789                	lui	a5,0x2
ffffffffc020507a:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_obj___user_softint_out_size-0x6bb2>
ffffffffc020507c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205080:	02e7e463          	bltu	a5,a4,ffffffffc02050a8 <proc_init+0xda>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205084:	45a9                	li	a1,10
ffffffffc0205086:	368000ef          	jal	ffffffffc02053ee <hash32>
ffffffffc020508a:	02051713          	slli	a4,a0,0x20
ffffffffc020508e:	01c75793          	srli	a5,a4,0x1c
ffffffffc0205092:	00f486b3          	add	a3,s1,a5
ffffffffc0205096:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205098:	a029                	j	ffffffffc02050a2 <proc_init+0xd4>
            if (proc->pid == pid)
ffffffffc020509a:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020509e:	04870d63          	beq	a4,s0,ffffffffc02050f8 <proc_init+0x12a>
    return listelm->next;
ffffffffc02050a2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050a4:	fef69be3          	bne	a3,a5,ffffffffc020509a <proc_init+0xcc>
    return NULL;
ffffffffc02050a8:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050aa:	0b478413          	addi	s0,a5,180
ffffffffc02050ae:	4641                	li	a2,16
ffffffffc02050b0:	4581                	li	a1,0
ffffffffc02050b2:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02050b4:	00097717          	auipc	a4,0x97
ffffffffc02050b8:	c2f73a23          	sd	a5,-972(a4) # ffffffffc029bce8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050bc:	7c8000ef          	jal	ffffffffc0205884 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02050c0:	8522                	mv	a0,s0
ffffffffc02050c2:	463d                	li	a2,15
ffffffffc02050c4:	00002597          	auipc	a1,0x2
ffffffffc02050c8:	39458593          	addi	a1,a1,916 # ffffffffc0207458 <etext+0x1baa>
ffffffffc02050cc:	7ca000ef          	jal	ffffffffc0205896 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02050d0:	00093783          	ld	a5,0(s2)
ffffffffc02050d4:	cfad                	beqz	a5,ffffffffc020514e <proc_init+0x180>
ffffffffc02050d6:	43dc                	lw	a5,4(a5)
ffffffffc02050d8:	ebbd                	bnez	a5,ffffffffc020514e <proc_init+0x180>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02050da:	00097797          	auipc	a5,0x97
ffffffffc02050de:	c0e7b783          	ld	a5,-1010(a5) # ffffffffc029bce8 <initproc>
ffffffffc02050e2:	c7b1                	beqz	a5,ffffffffc020512e <proc_init+0x160>
ffffffffc02050e4:	43d8                	lw	a4,4(a5)
ffffffffc02050e6:	4785                	li	a5,1
ffffffffc02050e8:	04f71363          	bne	a4,a5,ffffffffc020512e <proc_init+0x160>
}
ffffffffc02050ec:	60e2                	ld	ra,24(sp)
ffffffffc02050ee:	6442                	ld	s0,16(sp)
ffffffffc02050f0:	64a2                	ld	s1,8(sp)
ffffffffc02050f2:	6902                	ld	s2,0(sp)
ffffffffc02050f4:	6105                	addi	sp,sp,32
ffffffffc02050f6:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02050f8:	f2878793          	addi	a5,a5,-216
ffffffffc02050fc:	b77d                	j	ffffffffc02050aa <proc_init+0xdc>
        panic("create init_main failed.\n");
ffffffffc02050fe:	00002617          	auipc	a2,0x2
ffffffffc0205102:	33a60613          	addi	a2,a2,826 # ffffffffc0207438 <etext+0x1b8a>
ffffffffc0205106:	3fa00593          	li	a1,1018
ffffffffc020510a:	00002517          	auipc	a0,0x2
ffffffffc020510e:	fbe50513          	addi	a0,a0,-66 # ffffffffc02070c8 <etext+0x181a>
ffffffffc0205112:	b34fb0ef          	jal	ffffffffc0200446 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205116:	00002617          	auipc	a2,0x2
ffffffffc020511a:	30260613          	addi	a2,a2,770 # ffffffffc0207418 <etext+0x1b6a>
ffffffffc020511e:	3eb00593          	li	a1,1003
ffffffffc0205122:	00002517          	auipc	a0,0x2
ffffffffc0205126:	fa650513          	addi	a0,a0,-90 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020512a:	b1cfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020512e:	00002697          	auipc	a3,0x2
ffffffffc0205132:	35a68693          	addi	a3,a3,858 # ffffffffc0207488 <etext+0x1bda>
ffffffffc0205136:	00001617          	auipc	a2,0x1
ffffffffc020513a:	1aa60613          	addi	a2,a2,426 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020513e:	40100593          	li	a1,1025
ffffffffc0205142:	00002517          	auipc	a0,0x2
ffffffffc0205146:	f8650513          	addi	a0,a0,-122 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020514a:	afcfb0ef          	jal	ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020514e:	00002697          	auipc	a3,0x2
ffffffffc0205152:	31268693          	addi	a3,a3,786 # ffffffffc0207460 <etext+0x1bb2>
ffffffffc0205156:	00001617          	auipc	a2,0x1
ffffffffc020515a:	18a60613          	addi	a2,a2,394 # ffffffffc02062e0 <etext+0xa32>
ffffffffc020515e:	40000593          	li	a1,1024
ffffffffc0205162:	00002517          	auipc	a0,0x2
ffffffffc0205166:	f6650513          	addi	a0,a0,-154 # ffffffffc02070c8 <etext+0x181a>
ffffffffc020516a:	adcfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc020516e <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc020516e:	1141                	addi	sp,sp,-16
ffffffffc0205170:	e022                	sd	s0,0(sp)
ffffffffc0205172:	e406                	sd	ra,8(sp)
ffffffffc0205174:	00097417          	auipc	s0,0x97
ffffffffc0205178:	b6c40413          	addi	s0,s0,-1172 # ffffffffc029bce0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc020517c:	6018                	ld	a4,0(s0)
ffffffffc020517e:	6f1c                	ld	a5,24(a4)
ffffffffc0205180:	dffd                	beqz	a5,ffffffffc020517e <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205182:	104000ef          	jal	ffffffffc0205286 <schedule>
ffffffffc0205186:	bfdd                	j	ffffffffc020517c <cpu_idle+0xe>

ffffffffc0205188 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205188:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc020518c:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205190:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0205192:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0205194:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205198:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc020519c:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02051a0:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02051a4:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02051a8:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02051ac:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02051b0:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02051b4:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02051b8:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02051bc:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02051c0:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02051c4:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02051c6:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02051c8:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02051cc:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02051d0:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02051d4:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02051d8:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02051dc:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02051e0:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02051e4:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02051e8:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02051ec:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02051f0:	8082                	ret

ffffffffc02051f2 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051f2:	4118                	lw	a4,0(a0)
{
ffffffffc02051f4:	1101                	addi	sp,sp,-32
ffffffffc02051f6:	ec06                	sd	ra,24(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051f8:	478d                	li	a5,3
ffffffffc02051fa:	06f70763          	beq	a4,a5,ffffffffc0205268 <wakeup_proc+0x76>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02051fe:	100027f3          	csrr	a5,sstatus
ffffffffc0205202:	8b89                	andi	a5,a5,2
ffffffffc0205204:	eb91                	bnez	a5,ffffffffc0205218 <wakeup_proc+0x26>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205206:	4789                	li	a5,2
ffffffffc0205208:	02f70763          	beq	a4,a5,ffffffffc0205236 <wakeup_proc+0x44>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020520c:	60e2                	ld	ra,24(sp)
            proc->state = PROC_RUNNABLE;
ffffffffc020520e:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc0205210:	0e052623          	sw	zero,236(a0)
}
ffffffffc0205214:	6105                	addi	sp,sp,32
ffffffffc0205216:	8082                	ret
        intr_disable();
ffffffffc0205218:	e42a                	sd	a0,8(sp)
ffffffffc020521a:	eeafb0ef          	jal	ffffffffc0200904 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020521e:	6522                	ld	a0,8(sp)
ffffffffc0205220:	4789                	li	a5,2
ffffffffc0205222:	4118                	lw	a4,0(a0)
ffffffffc0205224:	02f70663          	beq	a4,a5,ffffffffc0205250 <wakeup_proc+0x5e>
            proc->state = PROC_RUNNABLE;
ffffffffc0205228:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc020522a:	0e052623          	sw	zero,236(a0)
}
ffffffffc020522e:	60e2                	ld	ra,24(sp)
ffffffffc0205230:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205232:	eccfb06f          	j	ffffffffc02008fe <intr_enable>
ffffffffc0205236:	60e2                	ld	ra,24(sp)
            warn("wakeup runnable process.\n");
ffffffffc0205238:	00002617          	auipc	a2,0x2
ffffffffc020523c:	2b060613          	addi	a2,a2,688 # ffffffffc02074e8 <etext+0x1c3a>
ffffffffc0205240:	45d1                	li	a1,20
ffffffffc0205242:	00002517          	auipc	a0,0x2
ffffffffc0205246:	28e50513          	addi	a0,a0,654 # ffffffffc02074d0 <etext+0x1c22>
}
ffffffffc020524a:	6105                	addi	sp,sp,32
            warn("wakeup runnable process.\n");
ffffffffc020524c:	a64fb06f          	j	ffffffffc02004b0 <__warn>
ffffffffc0205250:	00002617          	auipc	a2,0x2
ffffffffc0205254:	29860613          	addi	a2,a2,664 # ffffffffc02074e8 <etext+0x1c3a>
ffffffffc0205258:	45d1                	li	a1,20
ffffffffc020525a:	00002517          	auipc	a0,0x2
ffffffffc020525e:	27650513          	addi	a0,a0,630 # ffffffffc02074d0 <etext+0x1c22>
ffffffffc0205262:	a4efb0ef          	jal	ffffffffc02004b0 <__warn>
    if (flag)
ffffffffc0205266:	b7e1                	j	ffffffffc020522e <wakeup_proc+0x3c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205268:	00002697          	auipc	a3,0x2
ffffffffc020526c:	24868693          	addi	a3,a3,584 # ffffffffc02074b0 <etext+0x1c02>
ffffffffc0205270:	00001617          	auipc	a2,0x1
ffffffffc0205274:	07060613          	addi	a2,a2,112 # ffffffffc02062e0 <etext+0xa32>
ffffffffc0205278:	45a5                	li	a1,9
ffffffffc020527a:	00002517          	auipc	a0,0x2
ffffffffc020527e:	25650513          	addi	a0,a0,598 # ffffffffc02074d0 <etext+0x1c22>
ffffffffc0205282:	9c4fb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc0205286 <schedule>:

void schedule(void)
{
ffffffffc0205286:	1101                	addi	sp,sp,-32
ffffffffc0205288:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020528a:	100027f3          	csrr	a5,sstatus
ffffffffc020528e:	8b89                	andi	a5,a5,2
ffffffffc0205290:	4301                	li	t1,0
ffffffffc0205292:	e3c1                	bnez	a5,ffffffffc0205312 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205294:	00097897          	auipc	a7,0x97
ffffffffc0205298:	a4c8b883          	ld	a7,-1460(a7) # ffffffffc029bce0 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020529c:	00097517          	auipc	a0,0x97
ffffffffc02052a0:	a5453503          	ld	a0,-1452(a0) # ffffffffc029bcf0 <idleproc>
        current->need_resched = 0;
ffffffffc02052a4:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02052a8:	04a88f63          	beq	a7,a0,ffffffffc0205306 <schedule+0x80>
ffffffffc02052ac:	0c888693          	addi	a3,a7,200
ffffffffc02052b0:	00097617          	auipc	a2,0x97
ffffffffc02052b4:	9b860613          	addi	a2,a2,-1608 # ffffffffc029bc68 <proc_list>
        le = last;
ffffffffc02052b8:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02052ba:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02052bc:	4809                	li	a6,2
ffffffffc02052be:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02052c0:	00c78863          	beq	a5,a2,ffffffffc02052d0 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE)
ffffffffc02052c4:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02052c8:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02052cc:	03070363          	beq	a4,a6,ffffffffc02052f2 <schedule+0x6c>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02052d0:	fef697e3          	bne	a3,a5,ffffffffc02052be <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02052d4:	ed99                	bnez	a1,ffffffffc02052f2 <schedule+0x6c>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02052d6:	451c                	lw	a5,8(a0)
ffffffffc02052d8:	2785                	addiw	a5,a5,1
ffffffffc02052da:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02052dc:	00a88663          	beq	a7,a0,ffffffffc02052e8 <schedule+0x62>
ffffffffc02052e0:	e41a                	sd	t1,8(sp)
        {
            proc_run(next);
ffffffffc02052e2:	dd1fe0ef          	jal	ffffffffc02040b2 <proc_run>
ffffffffc02052e6:	6322                	ld	t1,8(sp)
    if (flag)
ffffffffc02052e8:	00031b63          	bnez	t1,ffffffffc02052fe <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02052ec:	60e2                	ld	ra,24(sp)
ffffffffc02052ee:	6105                	addi	sp,sp,32
ffffffffc02052f0:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02052f2:	4198                	lw	a4,0(a1)
ffffffffc02052f4:	4789                	li	a5,2
ffffffffc02052f6:	fef710e3          	bne	a4,a5,ffffffffc02052d6 <schedule+0x50>
ffffffffc02052fa:	852e                	mv	a0,a1
ffffffffc02052fc:	bfe9                	j	ffffffffc02052d6 <schedule+0x50>
}
ffffffffc02052fe:	60e2                	ld	ra,24(sp)
ffffffffc0205300:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205302:	dfcfb06f          	j	ffffffffc02008fe <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205306:	00097617          	auipc	a2,0x97
ffffffffc020530a:	96260613          	addi	a2,a2,-1694 # ffffffffc029bc68 <proc_list>
ffffffffc020530e:	86b2                	mv	a3,a2
ffffffffc0205310:	b765                	j	ffffffffc02052b8 <schedule+0x32>
        intr_disable();
ffffffffc0205312:	df2fb0ef          	jal	ffffffffc0200904 <intr_disable>
        return 1;
ffffffffc0205316:	4305                	li	t1,1
ffffffffc0205318:	bfb5                	j	ffffffffc0205294 <schedule+0xe>

ffffffffc020531a <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020531a:	00097797          	auipc	a5,0x97
ffffffffc020531e:	9c67b783          	ld	a5,-1594(a5) # ffffffffc029bce0 <current>
}
ffffffffc0205322:	43c8                	lw	a0,4(a5)
ffffffffc0205324:	8082                	ret

ffffffffc0205326 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205326:	4501                	li	a0,0
ffffffffc0205328:	8082                	ret

ffffffffc020532a <sys_putc>:
    cputchar(c);
ffffffffc020532a:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020532c:	1141                	addi	sp,sp,-16
ffffffffc020532e:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205330:	e99fa0ef          	jal	ffffffffc02001c8 <cputchar>
}
ffffffffc0205334:	60a2                	ld	ra,8(sp)
ffffffffc0205336:	4501                	li	a0,0
ffffffffc0205338:	0141                	addi	sp,sp,16
ffffffffc020533a:	8082                	ret

ffffffffc020533c <sys_kill>:
    return do_kill(pid);
ffffffffc020533c:	4108                	lw	a0,0(a0)
ffffffffc020533e:	c19ff06f          	j	ffffffffc0204f56 <do_kill>

ffffffffc0205342 <sys_yield>:
    return do_yield();
ffffffffc0205342:	bcbff06f          	j	ffffffffc0204f0c <do_yield>

ffffffffc0205346 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205346:	6d14                	ld	a3,24(a0)
ffffffffc0205348:	6910                	ld	a2,16(a0)
ffffffffc020534a:	650c                	ld	a1,8(a0)
ffffffffc020534c:	6108                	ld	a0,0(a0)
ffffffffc020534e:	e22ff06f          	j	ffffffffc0204970 <do_execve>

ffffffffc0205352 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205352:	650c                	ld	a1,8(a0)
ffffffffc0205354:	4108                	lw	a0,0(a0)
ffffffffc0205356:	bc7ff06f          	j	ffffffffc0204f1c <do_wait>

ffffffffc020535a <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020535a:	00097797          	auipc	a5,0x97
ffffffffc020535e:	9867b783          	ld	a5,-1658(a5) # ffffffffc029bce0 <current>
    return do_fork(0, stack, tf);
ffffffffc0205362:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc0205364:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205366:	6a0c                	ld	a1,16(a2)
ffffffffc0205368:	daffe06f          	j	ffffffffc0204116 <do_fork>

ffffffffc020536c <sys_exit>:
    return do_exit(error_code);
ffffffffc020536c:	4108                	lw	a0,0(a0)
ffffffffc020536e:	9b8ff06f          	j	ffffffffc0204526 <do_exit>

ffffffffc0205372 <syscall>:

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
    struct trapframe *tf = current->tf;
ffffffffc0205372:	00097697          	auipc	a3,0x97
ffffffffc0205376:	96e6b683          	ld	a3,-1682(a3) # ffffffffc029bce0 <current>
syscall(void) {
ffffffffc020537a:	715d                	addi	sp,sp,-80
ffffffffc020537c:	e0a2                	sd	s0,64(sp)
    struct trapframe *tf = current->tf;
ffffffffc020537e:	72c0                	ld	s0,160(a3)
syscall(void) {
ffffffffc0205380:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205382:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205384:	4834                	lw	a3,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205386:	02d7ec63          	bltu	a5,a3,ffffffffc02053be <syscall+0x4c>
        if (syscalls[num] != NULL) {
ffffffffc020538a:	00002797          	auipc	a5,0x2
ffffffffc020538e:	3a678793          	addi	a5,a5,934 # ffffffffc0207730 <syscalls>
ffffffffc0205392:	00369613          	slli	a2,a3,0x3
ffffffffc0205396:	97b2                	add	a5,a5,a2
ffffffffc0205398:	639c                	ld	a5,0(a5)
ffffffffc020539a:	c395                	beqz	a5,ffffffffc02053be <syscall+0x4c>
            arg[0] = tf->gpr.a1;
ffffffffc020539c:	7028                	ld	a0,96(s0)
ffffffffc020539e:	742c                	ld	a1,104(s0)
ffffffffc02053a0:	7830                	ld	a2,112(s0)
ffffffffc02053a2:	7c34                	ld	a3,120(s0)
ffffffffc02053a4:	6c38                	ld	a4,88(s0)
ffffffffc02053a6:	f02a                	sd	a0,32(sp)
ffffffffc02053a8:	f42e                	sd	a1,40(sp)
ffffffffc02053aa:	f832                	sd	a2,48(sp)
ffffffffc02053ac:	fc36                	sd	a3,56(sp)
ffffffffc02053ae:	ec3a                	sd	a4,24(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053b0:	0828                	addi	a0,sp,24
ffffffffc02053b2:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02053b4:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02053b6:	e828                	sd	a0,80(s0)
}
ffffffffc02053b8:	6406                	ld	s0,64(sp)
ffffffffc02053ba:	6161                	addi	sp,sp,80
ffffffffc02053bc:	8082                	ret
    print_trapframe(tf);
ffffffffc02053be:	8522                	mv	a0,s0
ffffffffc02053c0:	e436                	sd	a3,8(sp)
ffffffffc02053c2:	f32fb0ef          	jal	ffffffffc0200af4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02053c6:	00097797          	auipc	a5,0x97
ffffffffc02053ca:	91a7b783          	ld	a5,-1766(a5) # ffffffffc029bce0 <current>
ffffffffc02053ce:	66a2                	ld	a3,8(sp)
ffffffffc02053d0:	00002617          	auipc	a2,0x2
ffffffffc02053d4:	13860613          	addi	a2,a2,312 # ffffffffc0207508 <etext+0x1c5a>
ffffffffc02053d8:	43d8                	lw	a4,4(a5)
ffffffffc02053da:	06200593          	li	a1,98
ffffffffc02053de:	0b478793          	addi	a5,a5,180
ffffffffc02053e2:	00002517          	auipc	a0,0x2
ffffffffc02053e6:	15650513          	addi	a0,a0,342 # ffffffffc0207538 <etext+0x1c8a>
ffffffffc02053ea:	85cfb0ef          	jal	ffffffffc0200446 <__panic>

ffffffffc02053ee <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02053ee:	9e3707b7          	lui	a5,0x9e370
ffffffffc02053f2:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_exit_out_size+0xffffffff9e365e49>
ffffffffc02053f4:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc02053f8:	02000513          	li	a0,32
ffffffffc02053fc:	9d0d                	subw	a0,a0,a1
}
ffffffffc02053fe:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0205402:	8082                	ret

ffffffffc0205404 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205404:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205406:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020540a:	f022                	sd	s0,32(sp)
ffffffffc020540c:	ec26                	sd	s1,24(sp)
ffffffffc020540e:	e84a                	sd	s2,16(sp)
ffffffffc0205410:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205412:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205416:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205418:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020541c:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205420:	84aa                	mv	s1,a0
ffffffffc0205422:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0205424:	03067d63          	bgeu	a2,a6,ffffffffc020545e <printnum+0x5a>
ffffffffc0205428:	e44e                	sd	s3,8(sp)
ffffffffc020542a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020542c:	4785                	li	a5,1
ffffffffc020542e:	00e7d763          	bge	a5,a4,ffffffffc020543c <printnum+0x38>
            putch(padc, putdat);
ffffffffc0205432:	85ca                	mv	a1,s2
ffffffffc0205434:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0205436:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205438:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020543a:	fc65                	bnez	s0,ffffffffc0205432 <printnum+0x2e>
ffffffffc020543c:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020543e:	00002797          	auipc	a5,0x2
ffffffffc0205442:	11278793          	addi	a5,a5,274 # ffffffffc0207550 <etext+0x1ca2>
ffffffffc0205446:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205448:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020544a:	0007c503          	lbu	a0,0(a5)
}
ffffffffc020544e:	70a2                	ld	ra,40(sp)
ffffffffc0205450:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205452:	85ca                	mv	a1,s2
ffffffffc0205454:	87a6                	mv	a5,s1
}
ffffffffc0205456:	6942                	ld	s2,16(sp)
ffffffffc0205458:	64e2                	ld	s1,24(sp)
ffffffffc020545a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020545c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020545e:	03065633          	divu	a2,a2,a6
ffffffffc0205462:	8722                	mv	a4,s0
ffffffffc0205464:	fa1ff0ef          	jal	ffffffffc0205404 <printnum>
ffffffffc0205468:	bfd9                	j	ffffffffc020543e <printnum+0x3a>

ffffffffc020546a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020546a:	7119                	addi	sp,sp,-128
ffffffffc020546c:	f4a6                	sd	s1,104(sp)
ffffffffc020546e:	f0ca                	sd	s2,96(sp)
ffffffffc0205470:	ecce                	sd	s3,88(sp)
ffffffffc0205472:	e8d2                	sd	s4,80(sp)
ffffffffc0205474:	e4d6                	sd	s5,72(sp)
ffffffffc0205476:	e0da                	sd	s6,64(sp)
ffffffffc0205478:	f862                	sd	s8,48(sp)
ffffffffc020547a:	fc86                	sd	ra,120(sp)
ffffffffc020547c:	f8a2                	sd	s0,112(sp)
ffffffffc020547e:	fc5e                	sd	s7,56(sp)
ffffffffc0205480:	f466                	sd	s9,40(sp)
ffffffffc0205482:	f06a                	sd	s10,32(sp)
ffffffffc0205484:	ec6e                	sd	s11,24(sp)
ffffffffc0205486:	84aa                	mv	s1,a0
ffffffffc0205488:	8c32                	mv	s8,a2
ffffffffc020548a:	8a36                	mv	s4,a3
ffffffffc020548c:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020548e:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205492:	05500b13          	li	s6,85
ffffffffc0205496:	00002a97          	auipc	s5,0x2
ffffffffc020549a:	39aa8a93          	addi	s5,s5,922 # ffffffffc0207830 <syscalls+0x100>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020549e:	000c4503          	lbu	a0,0(s8)
ffffffffc02054a2:	001c0413          	addi	s0,s8,1
ffffffffc02054a6:	01350a63          	beq	a0,s3,ffffffffc02054ba <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc02054aa:	cd0d                	beqz	a0,ffffffffc02054e4 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc02054ac:	85ca                	mv	a1,s2
ffffffffc02054ae:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02054b0:	00044503          	lbu	a0,0(s0)
ffffffffc02054b4:	0405                	addi	s0,s0,1
ffffffffc02054b6:	ff351ae3          	bne	a0,s3,ffffffffc02054aa <vprintfmt+0x40>
        width = precision = -1;
ffffffffc02054ba:	5cfd                	li	s9,-1
ffffffffc02054bc:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc02054be:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc02054c2:	4b81                	li	s7,0
ffffffffc02054c4:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054c6:	00044683          	lbu	a3,0(s0)
ffffffffc02054ca:	00140c13          	addi	s8,s0,1
ffffffffc02054ce:	fdd6859b          	addiw	a1,a3,-35
ffffffffc02054d2:	0ff5f593          	zext.b	a1,a1
ffffffffc02054d6:	02bb6663          	bltu	s6,a1,ffffffffc0205502 <vprintfmt+0x98>
ffffffffc02054da:	058a                	slli	a1,a1,0x2
ffffffffc02054dc:	95d6                	add	a1,a1,s5
ffffffffc02054de:	4198                	lw	a4,0(a1)
ffffffffc02054e0:	9756                	add	a4,a4,s5
ffffffffc02054e2:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02054e4:	70e6                	ld	ra,120(sp)
ffffffffc02054e6:	7446                	ld	s0,112(sp)
ffffffffc02054e8:	74a6                	ld	s1,104(sp)
ffffffffc02054ea:	7906                	ld	s2,96(sp)
ffffffffc02054ec:	69e6                	ld	s3,88(sp)
ffffffffc02054ee:	6a46                	ld	s4,80(sp)
ffffffffc02054f0:	6aa6                	ld	s5,72(sp)
ffffffffc02054f2:	6b06                	ld	s6,64(sp)
ffffffffc02054f4:	7be2                	ld	s7,56(sp)
ffffffffc02054f6:	7c42                	ld	s8,48(sp)
ffffffffc02054f8:	7ca2                	ld	s9,40(sp)
ffffffffc02054fa:	7d02                	ld	s10,32(sp)
ffffffffc02054fc:	6de2                	ld	s11,24(sp)
ffffffffc02054fe:	6109                	addi	sp,sp,128
ffffffffc0205500:	8082                	ret
            putch('%', putdat);
ffffffffc0205502:	85ca                	mv	a1,s2
ffffffffc0205504:	02500513          	li	a0,37
ffffffffc0205508:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020550a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020550e:	02500713          	li	a4,37
ffffffffc0205512:	8c22                	mv	s8,s0
ffffffffc0205514:	f8e785e3          	beq	a5,a4,ffffffffc020549e <vprintfmt+0x34>
ffffffffc0205518:	ffec4783          	lbu	a5,-2(s8)
ffffffffc020551c:	1c7d                	addi	s8,s8,-1
ffffffffc020551e:	fee79de3          	bne	a5,a4,ffffffffc0205518 <vprintfmt+0xae>
ffffffffc0205522:	bfb5                	j	ffffffffc020549e <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0205524:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0205528:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc020552a:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc020552e:	fd06071b          	addiw	a4,a2,-48
ffffffffc0205532:	24e56a63          	bltu	a0,a4,ffffffffc0205786 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0205536:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205538:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc020553a:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc020553e:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205542:	0197073b          	addw	a4,a4,s9
ffffffffc0205546:	0017171b          	slliw	a4,a4,0x1
ffffffffc020554a:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc020554c:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205550:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205552:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0205556:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc020555a:	feb570e3          	bgeu	a0,a1,ffffffffc020553a <vprintfmt+0xd0>
            if (width < 0)
ffffffffc020555e:	f60d54e3          	bgez	s10,ffffffffc02054c6 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0205562:	8d66                	mv	s10,s9
ffffffffc0205564:	5cfd                	li	s9,-1
ffffffffc0205566:	b785                	j	ffffffffc02054c6 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205568:	8db6                	mv	s11,a3
ffffffffc020556a:	8462                	mv	s0,s8
ffffffffc020556c:	bfa9                	j	ffffffffc02054c6 <vprintfmt+0x5c>
ffffffffc020556e:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0205570:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0205572:	bf91                	j	ffffffffc02054c6 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0205574:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205576:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020557a:	00f74463          	blt	a4,a5,ffffffffc0205582 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc020557e:	1a078763          	beqz	a5,ffffffffc020572c <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0205582:	000a3603          	ld	a2,0(s4)
ffffffffc0205586:	46c1                	li	a3,16
ffffffffc0205588:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020558a:	000d879b          	sext.w	a5,s11
ffffffffc020558e:	876a                	mv	a4,s10
ffffffffc0205590:	85ca                	mv	a1,s2
ffffffffc0205592:	8526                	mv	a0,s1
ffffffffc0205594:	e71ff0ef          	jal	ffffffffc0205404 <printnum>
            break;
ffffffffc0205598:	b719                	j	ffffffffc020549e <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc020559a:	000a2503          	lw	a0,0(s4)
ffffffffc020559e:	85ca                	mv	a1,s2
ffffffffc02055a0:	0a21                	addi	s4,s4,8
ffffffffc02055a2:	9482                	jalr	s1
            break;
ffffffffc02055a4:	bded                	j	ffffffffc020549e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02055a6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055a8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055ac:	00f74463          	blt	a4,a5,ffffffffc02055b4 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc02055b0:	16078963          	beqz	a5,ffffffffc0205722 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc02055b4:	000a3603          	ld	a2,0(s4)
ffffffffc02055b8:	46a9                	li	a3,10
ffffffffc02055ba:	8a2e                	mv	s4,a1
ffffffffc02055bc:	b7f9                	j	ffffffffc020558a <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc02055be:	85ca                	mv	a1,s2
ffffffffc02055c0:	03000513          	li	a0,48
ffffffffc02055c4:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc02055c6:	85ca                	mv	a1,s2
ffffffffc02055c8:	07800513          	li	a0,120
ffffffffc02055cc:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02055ce:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc02055d2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02055d4:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02055d6:	bf55                	j	ffffffffc020558a <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc02055d8:	85ca                	mv	a1,s2
ffffffffc02055da:	02500513          	li	a0,37
ffffffffc02055de:	9482                	jalr	s1
            break;
ffffffffc02055e0:	bd7d                	j	ffffffffc020549e <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc02055e2:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055e6:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc02055e8:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc02055ea:	bf95                	j	ffffffffc020555e <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc02055ec:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055ee:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055f2:	00f74463          	blt	a4,a5,ffffffffc02055fa <vprintfmt+0x190>
    else if (lflag) {
ffffffffc02055f6:	12078163          	beqz	a5,ffffffffc0205718 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc02055fa:	000a3603          	ld	a2,0(s4)
ffffffffc02055fe:	46a1                	li	a3,8
ffffffffc0205600:	8a2e                	mv	s4,a1
ffffffffc0205602:	b761                	j	ffffffffc020558a <vprintfmt+0x120>
            if (width < 0)
ffffffffc0205604:	876a                	mv	a4,s10
ffffffffc0205606:	000d5363          	bgez	s10,ffffffffc020560c <vprintfmt+0x1a2>
ffffffffc020560a:	4701                	li	a4,0
ffffffffc020560c:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205610:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205612:	bd55                	j	ffffffffc02054c6 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0205614:	000d841b          	sext.w	s0,s11
ffffffffc0205618:	fd340793          	addi	a5,s0,-45
ffffffffc020561c:	00f037b3          	snez	a5,a5
ffffffffc0205620:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205624:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0205628:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020562a:	008a0793          	addi	a5,s4,8
ffffffffc020562e:	e43e                	sd	a5,8(sp)
ffffffffc0205630:	100d8c63          	beqz	s11,ffffffffc0205748 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0205634:	12071363          	bnez	a4,ffffffffc020575a <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205638:	000dc783          	lbu	a5,0(s11)
ffffffffc020563c:	0007851b          	sext.w	a0,a5
ffffffffc0205640:	c78d                	beqz	a5,ffffffffc020566a <vprintfmt+0x200>
ffffffffc0205642:	0d85                	addi	s11,s11,1
ffffffffc0205644:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205646:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020564a:	000cc563          	bltz	s9,ffffffffc0205654 <vprintfmt+0x1ea>
ffffffffc020564e:	3cfd                	addiw	s9,s9,-1
ffffffffc0205650:	008c8d63          	beq	s9,s0,ffffffffc020566a <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205654:	020b9663          	bnez	s7,ffffffffc0205680 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0205658:	85ca                	mv	a1,s2
ffffffffc020565a:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020565c:	000dc783          	lbu	a5,0(s11)
ffffffffc0205660:	0d85                	addi	s11,s11,1
ffffffffc0205662:	3d7d                	addiw	s10,s10,-1
ffffffffc0205664:	0007851b          	sext.w	a0,a5
ffffffffc0205668:	f3ed                	bnez	a5,ffffffffc020564a <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc020566a:	01a05963          	blez	s10,ffffffffc020567c <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc020566e:	85ca                	mv	a1,s2
ffffffffc0205670:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0205674:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0205676:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0205678:	fe0d1be3          	bnez	s10,ffffffffc020566e <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020567c:	6a22                	ld	s4,8(sp)
ffffffffc020567e:	b505                	j	ffffffffc020549e <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205680:	3781                	addiw	a5,a5,-32
ffffffffc0205682:	fcfa7be3          	bgeu	s4,a5,ffffffffc0205658 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0205686:	03f00513          	li	a0,63
ffffffffc020568a:	85ca                	mv	a1,s2
ffffffffc020568c:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020568e:	000dc783          	lbu	a5,0(s11)
ffffffffc0205692:	0d85                	addi	s11,s11,1
ffffffffc0205694:	3d7d                	addiw	s10,s10,-1
ffffffffc0205696:	0007851b          	sext.w	a0,a5
ffffffffc020569a:	dbe1                	beqz	a5,ffffffffc020566a <vprintfmt+0x200>
ffffffffc020569c:	fa0cd9e3          	bgez	s9,ffffffffc020564e <vprintfmt+0x1e4>
ffffffffc02056a0:	b7c5                	j	ffffffffc0205680 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc02056a2:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056a6:	4661                	li	a2,24
            err = va_arg(ap, int);
ffffffffc02056a8:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02056aa:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc02056ae:	8fb9                	xor	a5,a5,a4
ffffffffc02056b0:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056b4:	02d64563          	blt	a2,a3,ffffffffc02056de <vprintfmt+0x274>
ffffffffc02056b8:	00002797          	auipc	a5,0x2
ffffffffc02056bc:	2d078793          	addi	a5,a5,720 # ffffffffc0207988 <error_string>
ffffffffc02056c0:	00369713          	slli	a4,a3,0x3
ffffffffc02056c4:	97ba                	add	a5,a5,a4
ffffffffc02056c6:	639c                	ld	a5,0(a5)
ffffffffc02056c8:	cb99                	beqz	a5,ffffffffc02056de <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc02056ca:	86be                	mv	a3,a5
ffffffffc02056cc:	00000617          	auipc	a2,0x0
ffffffffc02056d0:	20c60613          	addi	a2,a2,524 # ffffffffc02058d8 <etext+0x2a>
ffffffffc02056d4:	85ca                	mv	a1,s2
ffffffffc02056d6:	8526                	mv	a0,s1
ffffffffc02056d8:	0d8000ef          	jal	ffffffffc02057b0 <printfmt>
ffffffffc02056dc:	b3c9                	j	ffffffffc020549e <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02056de:	00002617          	auipc	a2,0x2
ffffffffc02056e2:	e9260613          	addi	a2,a2,-366 # ffffffffc0207570 <etext+0x1cc2>
ffffffffc02056e6:	85ca                	mv	a1,s2
ffffffffc02056e8:	8526                	mv	a0,s1
ffffffffc02056ea:	0c6000ef          	jal	ffffffffc02057b0 <printfmt>
ffffffffc02056ee:	bb45                	j	ffffffffc020549e <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc02056f0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056f2:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc02056f6:	00f74363          	blt	a4,a5,ffffffffc02056fc <vprintfmt+0x292>
    else if (lflag) {
ffffffffc02056fa:	cf81                	beqz	a5,ffffffffc0205712 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc02056fc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205700:	02044b63          	bltz	s0,ffffffffc0205736 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0205704:	8622                	mv	a2,s0
ffffffffc0205706:	8a5e                	mv	s4,s7
ffffffffc0205708:	46a9                	li	a3,10
ffffffffc020570a:	b541                	j	ffffffffc020558a <vprintfmt+0x120>
            lflag ++;
ffffffffc020570c:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020570e:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0205710:	bb5d                	j	ffffffffc02054c6 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0205712:	000a2403          	lw	s0,0(s4)
ffffffffc0205716:	b7ed                	j	ffffffffc0205700 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0205718:	000a6603          	lwu	a2,0(s4)
ffffffffc020571c:	46a1                	li	a3,8
ffffffffc020571e:	8a2e                	mv	s4,a1
ffffffffc0205720:	b5ad                	j	ffffffffc020558a <vprintfmt+0x120>
ffffffffc0205722:	000a6603          	lwu	a2,0(s4)
ffffffffc0205726:	46a9                	li	a3,10
ffffffffc0205728:	8a2e                	mv	s4,a1
ffffffffc020572a:	b585                	j	ffffffffc020558a <vprintfmt+0x120>
ffffffffc020572c:	000a6603          	lwu	a2,0(s4)
ffffffffc0205730:	46c1                	li	a3,16
ffffffffc0205732:	8a2e                	mv	s4,a1
ffffffffc0205734:	bd99                	j	ffffffffc020558a <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0205736:	85ca                	mv	a1,s2
ffffffffc0205738:	02d00513          	li	a0,45
ffffffffc020573c:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc020573e:	40800633          	neg	a2,s0
ffffffffc0205742:	8a5e                	mv	s4,s7
ffffffffc0205744:	46a9                	li	a3,10
ffffffffc0205746:	b591                	j	ffffffffc020558a <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0205748:	e329                	bnez	a4,ffffffffc020578a <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020574a:	02800793          	li	a5,40
ffffffffc020574e:	853e                	mv	a0,a5
ffffffffc0205750:	00002d97          	auipc	s11,0x2
ffffffffc0205754:	e19d8d93          	addi	s11,s11,-487 # ffffffffc0207569 <etext+0x1cbb>
ffffffffc0205758:	b5f5                	j	ffffffffc0205644 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020575a:	85e6                	mv	a1,s9
ffffffffc020575c:	856e                	mv	a0,s11
ffffffffc020575e:	08a000ef          	jal	ffffffffc02057e8 <strnlen>
ffffffffc0205762:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0205766:	01a05863          	blez	s10,ffffffffc0205776 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc020576a:	85ca                	mv	a1,s2
ffffffffc020576c:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020576e:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0205770:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205772:	fe0d1ce3          	bnez	s10,ffffffffc020576a <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205776:	000dc783          	lbu	a5,0(s11)
ffffffffc020577a:	0007851b          	sext.w	a0,a5
ffffffffc020577e:	ec0792e3          	bnez	a5,ffffffffc0205642 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205782:	6a22                	ld	s4,8(sp)
ffffffffc0205784:	bb29                	j	ffffffffc020549e <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205786:	8462                	mv	s0,s8
ffffffffc0205788:	bbd9                	j	ffffffffc020555e <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020578a:	85e6                	mv	a1,s9
ffffffffc020578c:	00002517          	auipc	a0,0x2
ffffffffc0205790:	ddc50513          	addi	a0,a0,-548 # ffffffffc0207568 <etext+0x1cba>
ffffffffc0205794:	054000ef          	jal	ffffffffc02057e8 <strnlen>
ffffffffc0205798:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020579c:	02800793          	li	a5,40
                p = "(null)";
ffffffffc02057a0:	00002d97          	auipc	s11,0x2
ffffffffc02057a4:	dc8d8d93          	addi	s11,s11,-568 # ffffffffc0207568 <etext+0x1cba>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057a8:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057aa:	fda040e3          	bgtz	s10,ffffffffc020576a <vprintfmt+0x300>
ffffffffc02057ae:	bd51                	j	ffffffffc0205642 <vprintfmt+0x1d8>

ffffffffc02057b0 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057b0:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02057b2:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057b6:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057b8:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02057ba:	ec06                	sd	ra,24(sp)
ffffffffc02057bc:	f83a                	sd	a4,48(sp)
ffffffffc02057be:	fc3e                	sd	a5,56(sp)
ffffffffc02057c0:	e0c2                	sd	a6,64(sp)
ffffffffc02057c2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02057c4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057c6:	ca5ff0ef          	jal	ffffffffc020546a <vprintfmt>
}
ffffffffc02057ca:	60e2                	ld	ra,24(sp)
ffffffffc02057cc:	6161                	addi	sp,sp,80
ffffffffc02057ce:	8082                	ret

ffffffffc02057d0 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02057d0:	00054783          	lbu	a5,0(a0)
ffffffffc02057d4:	cb81                	beqz	a5,ffffffffc02057e4 <strlen+0x14>
    size_t cnt = 0;
ffffffffc02057d6:	4781                	li	a5,0
        cnt ++;
ffffffffc02057d8:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02057da:	00f50733          	add	a4,a0,a5
ffffffffc02057de:	00074703          	lbu	a4,0(a4)
ffffffffc02057e2:	fb7d                	bnez	a4,ffffffffc02057d8 <strlen+0x8>
    }
    return cnt;
}
ffffffffc02057e4:	853e                	mv	a0,a5
ffffffffc02057e6:	8082                	ret

ffffffffc02057e8 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02057e8:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02057ea:	e589                	bnez	a1,ffffffffc02057f4 <strnlen+0xc>
ffffffffc02057ec:	a811                	j	ffffffffc0205800 <strnlen+0x18>
        cnt ++;
ffffffffc02057ee:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02057f0:	00f58863          	beq	a1,a5,ffffffffc0205800 <strnlen+0x18>
ffffffffc02057f4:	00f50733          	add	a4,a0,a5
ffffffffc02057f8:	00074703          	lbu	a4,0(a4)
ffffffffc02057fc:	fb6d                	bnez	a4,ffffffffc02057ee <strnlen+0x6>
ffffffffc02057fe:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205800:	852e                	mv	a0,a1
ffffffffc0205802:	8082                	ret

ffffffffc0205804 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205804:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205806:	0005c703          	lbu	a4,0(a1)
ffffffffc020580a:	0585                	addi	a1,a1,1
ffffffffc020580c:	0785                	addi	a5,a5,1
ffffffffc020580e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205812:	fb75                	bnez	a4,ffffffffc0205806 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205814:	8082                	ret

ffffffffc0205816 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205816:	00054783          	lbu	a5,0(a0)
ffffffffc020581a:	e791                	bnez	a5,ffffffffc0205826 <strcmp+0x10>
ffffffffc020581c:	a01d                	j	ffffffffc0205842 <strcmp+0x2c>
ffffffffc020581e:	00054783          	lbu	a5,0(a0)
ffffffffc0205822:	cb99                	beqz	a5,ffffffffc0205838 <strcmp+0x22>
ffffffffc0205824:	0585                	addi	a1,a1,1
ffffffffc0205826:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc020582a:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020582c:	fef709e3          	beq	a4,a5,ffffffffc020581e <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205830:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205834:	9d19                	subw	a0,a0,a4
ffffffffc0205836:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205838:	0015c703          	lbu	a4,1(a1)
ffffffffc020583c:	4501                	li	a0,0
}
ffffffffc020583e:	9d19                	subw	a0,a0,a4
ffffffffc0205840:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205842:	0005c703          	lbu	a4,0(a1)
ffffffffc0205846:	4501                	li	a0,0
ffffffffc0205848:	b7f5                	j	ffffffffc0205834 <strcmp+0x1e>

ffffffffc020584a <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020584a:	ce01                	beqz	a2,ffffffffc0205862 <strncmp+0x18>
ffffffffc020584c:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205850:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205852:	cb91                	beqz	a5,ffffffffc0205866 <strncmp+0x1c>
ffffffffc0205854:	0005c703          	lbu	a4,0(a1)
ffffffffc0205858:	00f71763          	bne	a4,a5,ffffffffc0205866 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc020585c:	0505                	addi	a0,a0,1
ffffffffc020585e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205860:	f675                	bnez	a2,ffffffffc020584c <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205862:	4501                	li	a0,0
ffffffffc0205864:	8082                	ret
ffffffffc0205866:	00054503          	lbu	a0,0(a0)
ffffffffc020586a:	0005c783          	lbu	a5,0(a1)
ffffffffc020586e:	9d1d                	subw	a0,a0,a5
}
ffffffffc0205870:	8082                	ret

ffffffffc0205872 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205872:	a021                	j	ffffffffc020587a <strchr+0x8>
        if (*s == c) {
ffffffffc0205874:	00f58763          	beq	a1,a5,ffffffffc0205882 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0205878:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020587a:	00054783          	lbu	a5,0(a0)
ffffffffc020587e:	fbfd                	bnez	a5,ffffffffc0205874 <strchr+0x2>
    }
    return NULL;
ffffffffc0205880:	4501                	li	a0,0
}
ffffffffc0205882:	8082                	ret

ffffffffc0205884 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205884:	ca01                	beqz	a2,ffffffffc0205894 <memset+0x10>
ffffffffc0205886:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205888:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020588a:	0785                	addi	a5,a5,1
ffffffffc020588c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205890:	fef61de3          	bne	a2,a5,ffffffffc020588a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205894:	8082                	ret

ffffffffc0205896 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205896:	ca19                	beqz	a2,ffffffffc02058ac <memcpy+0x16>
ffffffffc0205898:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020589a:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020589c:	0005c703          	lbu	a4,0(a1)
ffffffffc02058a0:	0585                	addi	a1,a1,1
ffffffffc02058a2:	0785                	addi	a5,a5,1
ffffffffc02058a4:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02058a8:	feb61ae3          	bne	a2,a1,ffffffffc020589c <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02058ac:	8082                	ret
